1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.7;
3 
4 /**
5  * @dev Interface of the ERC165 standard, as defined in the
6  * https://eips.ethereum.org/EIPS/eip-165[EIP].
7  *
8  * Implementers can declare support of contract interfaces, which can then be
9  * queried by others ({ERC165Checker}).
10  *
11  * For an implementation, see {ERC165}.
12  */
13 interface IERC165 {
14     /**
15      * @dev Returns true if this contract implements the interface defined by
16      * `interfaceId`. See the corresponding
17      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
18      * to learn more about how these ids are created.
19      *
20      * This function call must use less than 30 000 gas.
21      */
22     function supportsInterface(bytes4 interfaceId) external view returns (bool);
23 }
24 
25 
26 /**
27  * @dev Implementation of the {IERC165} interface.
28  *
29  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
30  * for the additional interface id that will be supported. For example:
31  *
32  * ```solidity
33  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
34  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
35  * }
36  * ```
37  *
38  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
39  */
40 abstract contract ERC165 is IERC165 {
41     /**
42      * @dev See {IERC165-supportsInterface}.
43      */
44     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
45         return interfaceId == type(IERC165).interfaceId;
46     }
47 }
48 
49 /**
50  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
51  *
52  * These functions can be used to verify that a message was signed by the holder
53  * of the private keys of a given address.
54  */
55 library ECDSA {
56     enum RecoverError {
57         NoError,
58         InvalidSignature,
59         InvalidSignatureLength,
60         InvalidSignatureS,
61         InvalidSignatureV
62     }
63 
64     function _throwError(RecoverError error) private pure {
65         if (error == RecoverError.NoError) {
66             return; // no error: do nothing
67         } else if (error == RecoverError.InvalidSignature) {
68             revert("ECDSA: invalid signature");
69         } else if (error == RecoverError.InvalidSignatureLength) {
70             revert("ECDSA: invalid signature length");
71         } else if (error == RecoverError.InvalidSignatureS) {
72             revert("ECDSA: invalid signature 's' value");
73         } else if (error == RecoverError.InvalidSignatureV) {
74             revert("ECDSA: invalid signature 'v' value");
75         }
76     }
77 
78     /**
79      * @dev Returns the address that signed a hashed message (`hash`) with
80      * `signature` or error string. This address can then be used for verification purposes.
81      *
82      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
83      * this function rejects them by requiring the `s` value to be in the lower
84      * half order, and the `v` value to be either 27 or 28.
85      *
86      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
87      * verification to be secure: it is possible to craft signatures that
88      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
89      * this is by receiving a hash of the original message (which may otherwise
90      * be too long), and then calling {toEthSignedMessageHash} on it.
91      *
92      * Documentation for signature generation:
93      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
94      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
95      *
96      * _Available since v4.3._
97      */
98     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
99         // Check the signature length
100         // - case 65: r,s,v signature (standard)
101         // - case 64: r,vs signature (cf https://eips.ethereum.org/EIPS/eip-2098) _Available since v4.1._
102         if (signature.length == 65) {
103             bytes32 r;
104             bytes32 s;
105             uint8 v;
106             // ecrecover takes the signature parameters, and the only way to get them
107             // currently is to use assembly.
108             assembly {
109                 r := mload(add(signature, 0x20))
110                 s := mload(add(signature, 0x40))
111                 v := byte(0, mload(add(signature, 0x60)))
112             }
113             return tryRecover(hash, v, r, s);
114         } else if (signature.length == 64) {
115             bytes32 r;
116             bytes32 vs;
117             // ecrecover takes the signature parameters, and the only way to get them
118             // currently is to use assembly.
119             assembly {
120                 r := mload(add(signature, 0x20))
121                 vs := mload(add(signature, 0x40))
122             }
123             return tryRecover(hash, r, vs);
124         } else {
125             return (address(0), RecoverError.InvalidSignatureLength);
126         }
127     }
128 
129     /**
130      * @dev Returns the address that signed a hashed message (`hash`) with
131      * `signature`. This address can then be used for verification purposes.
132      *
133      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
134      * this function rejects them by requiring the `s` value to be in the lower
135      * half order, and the `v` value to be either 27 or 28.
136      *
137      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
138      * verification to be secure: it is possible to craft signatures that
139      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
140      * this is by receiving a hash of the original message (which may otherwise
141      * be too long), and then calling {toEthSignedMessageHash} on it.
142      */
143     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
144         (address recovered, RecoverError error) = tryRecover(hash, signature);
145         _throwError(error);
146         return recovered;
147     }
148 
149     /**
150      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
151      *
152      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
153      *
154      * _Available since v4.3._
155      */
156     function tryRecover(
157         bytes32 hash,
158         bytes32 r,
159         bytes32 vs
160     ) internal pure returns (address, RecoverError) {
161         bytes32 s;
162         uint8 v;
163         assembly {
164             s := and(vs, 0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff)
165             v := add(shr(255, vs), 27)
166         }
167         return tryRecover(hash, v, r, s);
168     }
169 
170     /**
171      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
172      *
173      * _Available since v4.2._
174      */
175     function recover(
176         bytes32 hash,
177         bytes32 r,
178         bytes32 vs
179     ) internal pure returns (address) {
180         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
181         _throwError(error);
182         return recovered;
183     }
184 
185     /**
186      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
187      * `r` and `s` signature fields separately.
188      *
189      * _Available since v4.3._
190      */
191     function tryRecover(
192         bytes32 hash,
193         uint8 v,
194         bytes32 r,
195         bytes32 s
196     ) internal pure returns (address, RecoverError) {
197         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
198         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
199         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
200         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
201         //
202         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
203         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
204         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
205         // these malleable signatures as well.
206         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
207             return (address(0), RecoverError.InvalidSignatureS);
208         }
209         if (v != 27 && v != 28) {
210             return (address(0), RecoverError.InvalidSignatureV);
211         }
212 
213         // If the signature is valid (and not malleable), return the signer address
214         address signer = ecrecover(hash, v, r, s);
215         if (signer == address(0)) {
216             return (address(0), RecoverError.InvalidSignature);
217         }
218 
219         return (signer, RecoverError.NoError);
220     }
221 
222     /**
223      * @dev Overload of {ECDSA-recover} that receives the `v`,
224      * `r` and `s` signature fields separately.
225      */
226     function recover(
227         bytes32 hash,
228         uint8 v,
229         bytes32 r,
230         bytes32 s
231     ) internal pure returns (address) {
232         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
233         _throwError(error);
234         return recovered;
235     }
236 
237     /**
238      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
239      * produces hash corresponding to the one signed with the
240      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
241      * JSON-RPC method as part of EIP-191.
242      *
243      * See {recover}.
244      */
245     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
246         // 32 is the length in bytes of hash,
247         // enforced by the type signature above
248         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
249     }
250 
251     /**
252      * @dev Returns an Ethereum Signed Typed Data, created from a
253      * `domainSeparator` and a `structHash`. This produces hash corresponding
254      * to the one signed with the
255      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
256      * JSON-RPC method as part of EIP-712.
257      *
258      * See {recover}.
259      */
260     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
261         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
262     }
263 }
264 
265 /**
266  * @dev Provides information about the current execution context, including the
267  * sender of the transaction and its data. While these are generally available
268  * via msg.sender and msg.data, they should not be accessed in such a direct
269  * manner, since when dealing with meta-transactions the account sending and
270  * paying for execution may not be the actual sender (as far as an application
271  * is concerned).
272  *
273  * This contract is only required for intermediate, library-like contracts.
274  */
275 abstract contract Context {
276     function _msgSender() internal view virtual returns (address) {
277         return msg.sender;
278     }
279 
280     function _msgData() internal view virtual returns (bytes calldata) {
281         return msg.data;
282     }
283 }
284 
285 /**
286  * @dev Collection of functions related to the address type
287  */
288 library Address {
289     /**
290      * @dev Returns true if `account` is a contract.
291      *
292      * [IMPORTANT]
293      * ====
294      * It is unsafe to assume that an address for which this function returns
295      * false is an externally-owned account (EOA) and not a contract.
296      *
297      * Among others, `isContract` will return false for the following
298      * types of addresses:
299      *
300      *  - an externally-owned account
301      *  - a contract in construction
302      *  - an address where a contract will be created
303      *  - an address where a contract lived, but was destroyed
304      * ====
305      */
306     function isContract(address account) internal view returns (bool) {
307         // This method relies on extcodesize, which returns 0 for contracts in
308         // construction, since the code is only stored at the end of the
309         // constructor execution.
310 
311         uint256 size;
312         assembly {
313             size := extcodesize(account)
314         }
315         return size > 0;
316     }
317 
318     /**
319      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
320      * `recipient`, forwarding all available gas and reverting on errors.
321      *
322      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
323      * of certain opcodes, possibly making contracts go over the 2300 gas limit
324      * imposed by `transfer`, making them unable to receive funds via
325      * `transfer`. {sendValue} removes this limitation.
326      *
327      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
328      *
329      * IMPORTANT: because control is transferred to `recipient`, care must be
330      * taken to not create reentrancy vulnerabilities. Consider using
331      * {ReentrancyGuard} or the
332      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
333      */
334     function sendValue(address payable recipient, uint256 amount) internal {
335         require(address(this).balance >= amount, "Address: insufficient balance");
336 
337         (bool success, ) = recipient.call{value: amount}("");
338         require(success, "Address: unable to send value, recipient may have reverted");
339     }
340 
341     /**
342      * @dev Performs a Solidity function call using a low level `call`. A
343      * plain `call` is an unsafe replacement for a function call: use this
344      * function instead.
345      *
346      * If `target` reverts with a revert reason, it is bubbled up by this
347      * function (like regular Solidity function calls).
348      *
349      * Returns the raw returned data. To convert to the expected return value,
350      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
351      *
352      * Requirements:
353      *
354      * - `target` must be a contract.
355      * - calling `target` with `data` must not revert.
356      *
357      * _Available since v3.1._
358      */
359     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
360         return functionCall(target, data, "Address: low-level call failed");
361     }
362 
363     /**
364      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
365      * `errorMessage` as a fallback revert reason when `target` reverts.
366      *
367      * _Available since v3.1._
368      */
369     function functionCall(
370         address target,
371         bytes memory data,
372         string memory errorMessage
373     ) internal returns (bytes memory) {
374         return functionCallWithValue(target, data, 0, errorMessage);
375     }
376 
377     /**
378      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
379      * but also transferring `value` wei to `target`.
380      *
381      * Requirements:
382      *
383      * - the calling contract must have an ETH balance of at least `value`.
384      * - the called Solidity function must be `payable`.
385      *
386      * _Available since v3.1._
387      */
388     function functionCallWithValue(
389         address target,
390         bytes memory data,
391         uint256 value
392     ) internal returns (bytes memory) {
393         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
394     }
395 
396     /**
397      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
398      * with `errorMessage` as a fallback revert reason when `target` reverts.
399      *
400      * _Available since v3.1._
401      */
402     function functionCallWithValue(
403         address target,
404         bytes memory data,
405         uint256 value,
406         string memory errorMessage
407     ) internal returns (bytes memory) {
408         require(address(this).balance >= value, "Address: insufficient balance for call");
409         require(isContract(target), "Address: call to non-contract");
410 
411         (bool success, bytes memory returndata) = target.call{value: value}(data);
412         return verifyCallResult(success, returndata, errorMessage);
413     }
414 
415     /**
416      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
417      * but performing a static call.
418      *
419      * _Available since v3.3._
420      */
421     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
422         return functionStaticCall(target, data, "Address: low-level static call failed");
423     }
424 
425     /**
426      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
427      * but performing a static call.
428      *
429      * _Available since v3.3._
430      */
431     function functionStaticCall(
432         address target,
433         bytes memory data,
434         string memory errorMessage
435     ) internal view returns (bytes memory) {
436         require(isContract(target), "Address: static call to non-contract");
437 
438         (bool success, bytes memory returndata) = target.staticcall(data);
439         return verifyCallResult(success, returndata, errorMessage);
440     }
441 
442     /**
443      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
444      * but performing a delegate call.
445      *
446      * _Available since v3.4._
447      */
448     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
449         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
450     }
451 
452     /**
453      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
454      * but performing a delegate call.
455      *
456      * _Available since v3.4._
457      */
458     function functionDelegateCall(
459         address target,
460         bytes memory data,
461         string memory errorMessage
462     ) internal returns (bytes memory) {
463         require(isContract(target), "Address: delegate call to non-contract");
464 
465         (bool success, bytes memory returndata) = target.delegatecall(data);
466         return verifyCallResult(success, returndata, errorMessage);
467     }
468 
469     /**
470      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
471      * revert reason using the provided one.
472      *
473      * _Available since v4.3._
474      */
475     function verifyCallResult(
476         bool success,
477         bytes memory returndata,
478         string memory errorMessage
479     ) internal pure returns (bytes memory) {
480         if (success) {
481             return returndata;
482         } else {
483             // Look for revert reason and bubble it up if present
484             if (returndata.length > 0) {
485                 // The easiest way to bubble the revert reason is using memory via assembly
486 
487                 assembly {
488                     let returndata_size := mload(returndata)
489                     revert(add(32, returndata), returndata_size)
490                 }
491             } else {
492                 revert(errorMessage);
493             }
494         }
495     }
496 }
497 
498 /**
499  * @dev Interface of the ERC20 standard as defined in the EIP.
500  */
501 interface IERC20 {
502     /**
503      * @dev Returns the amount of tokens in existence.
504      */
505     function totalSupply() external view returns (uint256);
506 
507     /**
508      * @dev Returns the amount of tokens owned by `account`.
509      */
510     function balanceOf(address account) external view returns (uint256);
511 
512     /**
513      * @dev Moves `amount` tokens from the caller's account to `recipient`.
514      *
515      * Returns a boolean value indicating whether the operation succeeded.
516      *
517      * Emits a {Transfer} event.
518      */
519     function transfer(address recipient, uint256 amount) external returns (bool);
520 
521     /**
522      * @dev Returns the remaining number of tokens that `spender` will be
523      * allowed to spend on behalf of `owner` through {transferFrom}. This is
524      * zero by default.
525      *
526      * This value changes when {approve} or {transferFrom} are called.
527      */
528     function allowance(address owner, address spender) external view returns (uint256);
529 
530     /**
531      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
532      *
533      * Returns a boolean value indicating whether the operation succeeded.
534      *
535      * IMPORTANT: Beware that changing an allowance with this method brings the risk
536      * that someone may use both the old and the new allowance by unfortunate
537      * transaction ordering. One possible solution to mitigate this race
538      * condition is to first reduce the spender's allowance to 0 and set the
539      * desired value afterwards:
540      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
541      *
542      * Emits an {Approval} event.
543      */
544     function approve(address spender, uint256 amount) external returns (bool);
545 
546     /**
547      * @dev Moves `amount` tokens from `sender` to `recipient` using the
548      * allowance mechanism. `amount` is then deducted from the caller's
549      * allowance.
550      *
551      * Returns a boolean value indicating whether the operation succeeded.
552      *
553      * Emits a {Transfer} event.
554      */
555     function transferFrom(
556         address sender,
557         address recipient,
558         uint256 amount
559     ) external returns (bool);
560 
561     /**
562      * @dev Emitted when `value` tokens are moved from one account (`from`) to
563      * another (`to`).
564      *
565      * Note that `value` may be zero.
566      */
567     event Transfer(address indexed from, address indexed to, uint256 value);
568 
569     /**
570      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
571      * a call to {approve}. `value` is the new allowance.
572      */
573     event Approval(address indexed owner, address indexed spender, uint256 value);
574 }
575 
576 
577 /**
578  * @dev Interface for the optional metadata functions from the ERC20 standard.
579  *
580  * _Available since v4.1._
581  */
582 interface IERC20Metadata is IERC20 {
583     /**
584      * @dev Returns the name of the token.
585      */
586     function name() external view returns (string memory);
587 
588     /**
589      * @dev Returns the symbol of the token.
590      */
591     function symbol() external view returns (string memory);
592 
593     /**
594      * @dev Returns the decimals places of the token.
595      */
596     function decimals() external view returns (uint8);
597 }
598 
599 /**
600  * @dev Implementation of the {IERC20} interface.
601  *
602  * This implementation is agnostic to the way tokens are created. This means
603  * that a supply mechanism has to be added in a derived contract using {_mint}.
604  * For a generic mechanism see {ERC20PresetMinterPauser}.
605  *
606  * TIP: For a detailed writeup see our guide
607  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
608  * to implement supply mechanisms].
609  *
610  * We have followed general OpenZeppelin Contracts guidelines: functions revert
611  * instead returning `false` on failure. This behavior is nonetheless
612  * conventional and does not conflict with the expectations of ERC20
613  * applications.
614  *
615  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
616  * This allows applications to reconstruct the allowance for all accounts just
617  * by listening to said events. Other implementations of the EIP may not emit
618  * these events, as it isn't required by the specification.
619  *
620  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
621  * functions have been added to mitigate the well-known issues around setting
622  * allowances. See {IERC20-approve}.
623  */
624 contract ERC20 is Context, IERC20, IERC20Metadata {
625     mapping(address => uint256) private _balances;
626 
627     mapping(address => mapping(address => uint256)) private _allowances;
628 
629     uint256 private _totalSupply;
630 
631     string private _name;
632     string private _symbol;
633 
634     /**
635      * @dev Sets the values for {name} and {symbol}.
636      *
637      * The default value of {decimals} is 18. To select a different value for
638      * {decimals} you should overload it.
639      *
640      * All two of these values are immutable: they can only be set once during
641      * construction.
642      */
643     constructor(string memory name_, string memory symbol_) {
644         _name = name_;
645         _symbol = symbol_;
646     }
647 
648     /**
649      * @dev Returns the name of the token.
650      */
651     function name() public view virtual override returns (string memory) {
652         return _name;
653     }
654 
655     /**
656      * @dev Returns the symbol of the token, usually a shorter version of the
657      * name.
658      */
659     function symbol() public view virtual override returns (string memory) {
660         return _symbol;
661     }
662 
663     /**
664      * @dev Returns the number of decimals used to get its user representation.
665      * For example, if `decimals` equals `2`, a balance of `505` tokens should
666      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
667      *
668      * Tokens usually opt for a value of 18, imitating the relationship between
669      * Ether and Wei. This is the value {ERC20} uses, unless this function is
670      * overridden;
671      *
672      * NOTE: This information is only used for _display_ purposes: it in
673      * no way affects any of the arithmetic of the contract, including
674      * {IERC20-balanceOf} and {IERC20-transfer}.
675      */
676     function decimals() public view virtual override returns (uint8) {
677         return 18;
678     }
679 
680     /**
681      * @dev See {IERC20-totalSupply}.
682      */
683     function totalSupply() public view virtual override returns (uint256) {
684         return _totalSupply;
685     }
686 
687     /**
688      * @dev See {IERC20-balanceOf}.
689      */
690     function balanceOf(address account) public view virtual override returns (uint256) {
691         return _balances[account];
692     }
693 
694     /**
695      * @dev See {IERC20-transfer}.
696      *
697      * Requirements:
698      *
699      * - `recipient` cannot be the zero address.
700      * - the caller must have a balance of at least `amount`.
701      */
702     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
703         _transfer(_msgSender(), recipient, amount);
704         return true;
705     }
706 
707     /**
708      * @dev See {IERC20-allowance}.
709      */
710     function allowance(address owner, address spender) public view virtual override returns (uint256) {
711         return _allowances[owner][spender];
712     }
713 
714     /**
715      * @dev See {IERC20-approve}.
716      *
717      * Requirements:
718      *
719      * - `spender` cannot be the zero address.
720      */
721     function approve(address spender, uint256 amount) public virtual override returns (bool) {
722         _approve(_msgSender(), spender, amount);
723         return true;
724     }
725 
726     /**
727      * @dev See {IERC20-transferFrom}.
728      *
729      * Emits an {Approval} event indicating the updated allowance. This is not
730      * required by the EIP. See the note at the beginning of {ERC20}.
731      *
732      * Requirements:
733      *
734      * - `sender` and `recipient` cannot be the zero address.
735      * - `sender` must have a balance of at least `amount`.
736      * - the caller must have allowance for ``sender``'s tokens of at least
737      * `amount`.
738      */
739     function transferFrom(
740         address sender,
741         address recipient,
742         uint256 amount
743     ) public virtual override returns (bool) {
744         _transfer(sender, recipient, amount);
745 
746         uint256 currentAllowance = _allowances[sender][_msgSender()];
747         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
748         unchecked {
749             _approve(sender, _msgSender(), currentAllowance - amount);
750         }
751 
752         return true;
753     }
754 
755     /**
756      * @dev Atomically increases the allowance granted to `spender` by the caller.
757      *
758      * This is an alternative to {approve} that can be used as a mitigation for
759      * problems described in {IERC20-approve}.
760      *
761      * Emits an {Approval} event indicating the updated allowance.
762      *
763      * Requirements:
764      *
765      * - `spender` cannot be the zero address.
766      */
767     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
768         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
769         return true;
770     }
771 
772     /**
773      * @dev Atomically decreases the allowance granted to `spender` by the caller.
774      *
775      * This is an alternative to {approve} that can be used as a mitigation for
776      * problems described in {IERC20-approve}.
777      *
778      * Emits an {Approval} event indicating the updated allowance.
779      *
780      * Requirements:
781      *
782      * - `spender` cannot be the zero address.
783      * - `spender` must have allowance for the caller of at least
784      * `subtractedValue`.
785      */
786     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
787         uint256 currentAllowance = _allowances[_msgSender()][spender];
788         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
789         unchecked {
790             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
791         }
792 
793         return true;
794     }
795 
796     /**
797      * @dev Moves `amount` of tokens from `sender` to `recipient`.
798      *
799      * This internal function is equivalent to {transfer}, and can be used to
800      * e.g. implement automatic token fees, slashing mechanisms, etc.
801      *
802      * Emits a {Transfer} event.
803      *
804      * Requirements:
805      *
806      * - `sender` cannot be the zero address.
807      * - `recipient` cannot be the zero address.
808      * - `sender` must have a balance of at least `amount`.
809      */
810     function _transfer(
811         address sender,
812         address recipient,
813         uint256 amount
814     ) internal virtual {
815         require(sender != address(0), "ERC20: transfer from the zero address");
816         require(recipient != address(0), "ERC20: transfer to the zero address");
817 
818         _beforeTokenTransfer(sender, recipient, amount);
819 
820         uint256 senderBalance = _balances[sender];
821         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
822         unchecked {
823             _balances[sender] = senderBalance - amount;
824         }
825         _balances[recipient] += amount;
826 
827         emit Transfer(sender, recipient, amount);
828 
829         _afterTokenTransfer(sender, recipient, amount);
830     }
831 
832     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
833      * the total supply.
834      *
835      * Emits a {Transfer} event with `from` set to the zero address.
836      *
837      * Requirements:
838      *
839      * - `account` cannot be the zero address.
840      */
841     function _mint(address account, uint256 amount) internal virtual {
842         require(account != address(0), "ERC20: mint to the zero address");
843 
844         _beforeTokenTransfer(address(0), account, amount);
845 
846         _totalSupply += amount;
847         _balances[account] += amount;
848         emit Transfer(address(0), account, amount);
849 
850         _afterTokenTransfer(address(0), account, amount);
851     }
852 
853     /**
854      * @dev Destroys `amount` tokens from `account`, reducing the
855      * total supply.
856      *
857      * Emits a {Transfer} event with `to` set to the zero address.
858      *
859      * Requirements:
860      *
861      * - `account` cannot be the zero address.
862      * - `account` must have at least `amount` tokens.
863      */
864     function _burn(address account, uint256 amount) internal virtual {
865         require(account != address(0), "ERC20: burn from the zero address");
866 
867         _beforeTokenTransfer(account, address(0), amount);
868 
869         uint256 accountBalance = _balances[account];
870         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
871         unchecked {
872             _balances[account] = accountBalance - amount;
873         }
874         _totalSupply -= amount;
875 
876         emit Transfer(account, address(0), amount);
877 
878         _afterTokenTransfer(account, address(0), amount);
879     }
880 
881     /**
882      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
883      *
884      * This internal function is equivalent to `approve`, and can be used to
885      * e.g. set automatic allowances for certain subsystems, etc.
886      *
887      * Emits an {Approval} event.
888      *
889      * Requirements:
890      *
891      * - `owner` cannot be the zero address.
892      * - `spender` cannot be the zero address.
893      */
894     function _approve(
895         address owner,
896         address spender,
897         uint256 amount
898     ) internal virtual {
899         require(owner != address(0), "ERC20: approve from the zero address");
900         require(spender != address(0), "ERC20: approve to the zero address");
901 
902         _allowances[owner][spender] = amount;
903         emit Approval(owner, spender, amount);
904     }
905 
906     /**
907      * @dev Hook that is called before any transfer of tokens. This includes
908      * minting and burning.
909      *
910      * Calling conditions:
911      *
912      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
913      * will be transferred to `to`.
914      * - when `from` is zero, `amount` tokens will be minted for `to`.
915      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
916      * - `from` and `to` are never both zero.
917      *
918      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
919      */
920     function _beforeTokenTransfer(
921         address from,
922         address to,
923         uint256 amount
924     ) internal virtual {}
925 
926     /**
927      * @dev Hook that is called after any transfer of tokens. This includes
928      * minting and burning.
929      *
930      * Calling conditions:
931      *
932      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
933      * has been transferred to `to`.
934      * - when `from` is zero, `amount` tokens have been minted for `to`.
935      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
936      * - `from` and `to` are never both zero.
937      *
938      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
939      */
940     function _afterTokenTransfer(
941         address from,
942         address to,
943         uint256 amount
944     ) internal virtual {}
945 }
946 
947 
948 /**
949  * @dev _Available since v3.1._
950  */
951 interface IERC1155Receiver is IERC165 {
952     /**
953         @dev Handles the receipt of a single ERC1155 token type. This function is
954         called at the end of a `safeTransferFrom` after the balance has been updated.
955         To accept the transfer, this must return
956         `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
957         (i.e. 0xf23a6e61, or its own function selector).
958         @param operator The address which initiated the transfer (i.e. msg.sender)
959         @param from The address which previously owned the token
960         @param id The ID of the token being transferred
961         @param value The amount of tokens being transferred
962         @param data Additional data with no specified format
963         @return `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))` if transfer is allowed
964     */
965     function onERC1155Received(
966         address operator,
967         address from,
968         uint256 id,
969         uint256 value,
970         bytes calldata data
971     ) external returns (bytes4);
972 
973     /**
974         @dev Handles the receipt of a multiple ERC1155 token types. This function
975         is called at the end of a `safeBatchTransferFrom` after the balances have
976         been updated. To accept the transfer(s), this must return
977         `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
978         (i.e. 0xbc197c81, or its own function selector).
979         @param operator The address which initiated the batch transfer (i.e. msg.sender)
980         @param from The address which previously owned the token
981         @param ids An array containing ids of each token being transferred (order and length must match values array)
982         @param values An array containing amounts of each token being transferred (order and length must match ids array)
983         @param data Additional data with no specified format
984         @return `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))` if transfer is allowed
985     */
986     function onERC1155BatchReceived(
987         address operator,
988         address from,
989         uint256[] calldata ids,
990         uint256[] calldata values,
991         bytes calldata data
992     ) external returns (bytes4);
993 }
994 
995 /**
996  * @dev Required interface of an ERC1155 compliant contract, as defined in the
997  * https://eips.ethereum.org/EIPS/eip-1155[EIP].
998  *
999  * _Available since v3.1._
1000  */
1001 interface IERC1155 is IERC165 {
1002     /**
1003      * @dev Emitted when `value` tokens of token type `id` are transferred from `from` to `to` by `operator`.
1004      */
1005     event TransferSingle(address indexed operator, address indexed from, address indexed to, uint256 id, uint256 value);
1006 
1007     /**
1008      * @dev Equivalent to multiple {TransferSingle} events, where `operator`, `from` and `to` are the same for all
1009      * transfers.
1010      */
1011     event TransferBatch(
1012         address indexed operator,
1013         address indexed from,
1014         address indexed to,
1015         uint256[] ids,
1016         uint256[] values
1017     );
1018 
1019     /**
1020      * @dev Emitted when `account` grants or revokes permission to `operator` to transfer their tokens, according to
1021      * `approved`.
1022      */
1023     event ApprovalForAll(address indexed account, address indexed operator, bool approved);
1024 
1025     /**
1026      * @dev Emitted when the URI for token type `id` changes to `value`, if it is a non-programmatic URI.
1027      *
1028      * If an {URI} event was emitted for `id`, the standard
1029      * https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[guarantees] that `value` will equal the value
1030      * returned by {IERC1155MetadataURI-uri}.
1031      */
1032     event URI(string value, uint256 indexed id);
1033 
1034     /**
1035      * @dev Returns the amount of tokens of token type `id` owned by `account`.
1036      *
1037      * Requirements:
1038      *
1039      * - `account` cannot be the zero address.
1040      */
1041     function balanceOf(address account, uint256 id) external view returns (uint256);
1042 
1043     /**
1044      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {balanceOf}.
1045      *
1046      * Requirements:
1047      *
1048      * - `accounts` and `ids` must have the same length.
1049      */
1050     function balanceOfBatch(address[] calldata accounts, uint256[] calldata ids)
1051         external
1052         view
1053         returns (uint256[] memory);
1054 
1055     /**
1056      * @dev Grants or revokes permission to `operator` to transfer the caller's tokens, according to `approved`,
1057      *
1058      * Emits an {ApprovalForAll} event.
1059      *
1060      * Requirements:
1061      *
1062      * - `operator` cannot be the caller.
1063      */
1064     function setApprovalForAll(address operator, bool approved) external;
1065 
1066     /**
1067      * @dev Returns true if `operator` is approved to transfer ``account``'s tokens.
1068      *
1069      * See {setApprovalForAll}.
1070      */
1071     function isApprovedForAll(address account, address operator) external view returns (bool);
1072 
1073     /**
1074      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
1075      *
1076      * Emits a {TransferSingle} event.
1077      *
1078      * Requirements:
1079      *
1080      * - `to` cannot be the zero address.
1081      * - If the caller is not `from`, it must be have been approved to spend ``from``'s tokens via {setApprovalForAll}.
1082      * - `from` must have a balance of tokens of type `id` of at least `amount`.
1083      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
1084      * acceptance magic value.
1085      */
1086     function safeTransferFrom(
1087         address from,
1088         address to,
1089         uint256 id,
1090         uint256 amount,
1091         bytes calldata data
1092     ) external;
1093 
1094     /**
1095      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {safeTransferFrom}.
1096      *
1097      * Emits a {TransferBatch} event.
1098      *
1099      * Requirements:
1100      *
1101      * - `ids` and `amounts` must have the same length.
1102      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
1103      * acceptance magic value.
1104      */
1105     function safeBatchTransferFrom(
1106         address from,
1107         address to,
1108         uint256[] calldata ids,
1109         uint256[] calldata amounts,
1110         bytes calldata data
1111     ) external;
1112 }
1113 
1114 
1115 /**
1116  * @dev Interface of the optional ERC1155MetadataExtension interface, as defined
1117  * in the https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[EIP].
1118  *
1119  * _Available since v3.1._
1120  */
1121 interface IERC1155MetadataURI is IERC1155 {
1122     /**
1123      * @dev Returns the URI for token type `id`.
1124      *
1125      * If the `\{id\}` substring is present in the URI, it must be replaced by
1126      * clients with the actual token type ID.
1127      */
1128     function uri(uint256 id) external view returns (string memory);
1129 }
1130 
1131 
1132 /**
1133  * @dev Implementation of the basic standard multi-token.
1134  * See https://eips.ethereum.org/EIPS/eip-1155
1135  * Originally based on code by Enjin: https://github.com/enjin/erc-1155
1136  *
1137  * _Available since v3.1._
1138  */
1139 contract ERC1155 is Context, ERC165, IERC1155, IERC1155MetadataURI {
1140     using Address for address;
1141 
1142     // Mapping from token ID to account balances
1143     mapping(uint256 => mapping(address => uint256)) private _balances;
1144 
1145     // Mapping from account to operator approvals
1146     mapping(address => mapping(address => bool)) private _operatorApprovals;
1147 
1148     // Used as the URI for all token types by relying on ID substitution, e.g. https://token-cdn-domain/{id}.json
1149     string private _uri;
1150 
1151     /**
1152      * @dev See {_setURI}.
1153      */
1154     constructor(string memory uri_) {
1155         _setURI(uri_);
1156     }
1157 
1158     /**
1159      * @dev See {IERC165-supportsInterface}.
1160      */
1161     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1162         return
1163             interfaceId == type(IERC1155).interfaceId ||
1164             interfaceId == type(IERC1155MetadataURI).interfaceId ||
1165             super.supportsInterface(interfaceId);
1166     }
1167 
1168     /**
1169      * @dev See {IERC1155MetadataURI-uri}.
1170      *
1171      * This implementation returns the same URI for *all* token types. It relies
1172      * on the token type ID substitution mechanism
1173      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
1174      *
1175      * Clients calling this function must replace the `\{id\}` substring with the
1176      * actual token type ID.
1177      */
1178     function uri(uint256) public view virtual override returns (string memory) {
1179         return _uri;
1180     }
1181 
1182     /**
1183      * @dev See {IERC1155-balanceOf}.
1184      *
1185      * Requirements:
1186      *
1187      * - `account` cannot be the zero address.
1188      */
1189     function balanceOf(address account, uint256 id) public view virtual override returns (uint256) {
1190         require(account != address(0), "ERC1155: balance query for the zero address");
1191         return _balances[id][account];
1192     }
1193 
1194     /**
1195      * @dev See {IERC1155-balanceOfBatch}.
1196      *
1197      * Requirements:
1198      *
1199      * - `accounts` and `ids` must have the same length.
1200      */
1201     function balanceOfBatch(address[] memory accounts, uint256[] memory ids)
1202         public
1203         view
1204         virtual
1205         override
1206         returns (uint256[] memory)
1207     {
1208         require(accounts.length == ids.length, "ERC1155: accounts and ids length mismatch");
1209 
1210         uint256[] memory batchBalances = new uint256[](accounts.length);
1211 
1212         for (uint256 i = 0; i < accounts.length; ++i) {
1213             batchBalances[i] = balanceOf(accounts[i], ids[i]);
1214         }
1215 
1216         return batchBalances;
1217     }
1218 
1219     /**
1220      * @dev See {IERC1155-setApprovalForAll}.
1221      */
1222     function setApprovalForAll(address operator, bool approved) public virtual override {
1223         require(_msgSender() != operator, "ERC1155: setting approval status for self");
1224 
1225         _operatorApprovals[_msgSender()][operator] = approved;
1226         emit ApprovalForAll(_msgSender(), operator, approved);
1227     }
1228 
1229     /**
1230      * @dev See {IERC1155-isApprovedForAll}.
1231      */
1232     function isApprovedForAll(address account, address operator) public view virtual override returns (bool) {
1233         return _operatorApprovals[account][operator];
1234     }
1235 
1236     /**
1237      * @dev See {IERC1155-safeTransferFrom}.
1238      */
1239     function safeTransferFrom(
1240         address from,
1241         address to,
1242         uint256 id,
1243         uint256 amount,
1244         bytes memory data
1245     ) public virtual override {
1246         require(
1247             from == _msgSender() || isApprovedForAll(from, _msgSender()),
1248             "ERC1155: caller is not owner nor approved"
1249         );
1250         _safeTransferFrom(from, to, id, amount, data);
1251     }
1252 
1253     /**
1254      * @dev See {IERC1155-safeBatchTransferFrom}.
1255      */
1256     function safeBatchTransferFrom(
1257         address from,
1258         address to,
1259         uint256[] memory ids,
1260         uint256[] memory amounts,
1261         bytes memory data
1262     ) public virtual override {
1263         require(
1264             from == _msgSender() || isApprovedForAll(from, _msgSender()),
1265             "ERC1155: transfer caller is not owner nor approved"
1266         );
1267         _safeBatchTransferFrom(from, to, ids, amounts, data);
1268     }
1269 
1270     /**
1271      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
1272      *
1273      * Emits a {TransferSingle} event.
1274      *
1275      * Requirements:
1276      *
1277      * - `to` cannot be the zero address.
1278      * - `from` must have a balance of tokens of type `id` of at least `amount`.
1279      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
1280      * acceptance magic value.
1281      */
1282     function _safeTransferFrom(
1283         address from,
1284         address to,
1285         uint256 id,
1286         uint256 amount,
1287         bytes memory data
1288     ) internal virtual {
1289         require(to != address(0), "ERC1155: transfer to the zero address");
1290 
1291         address operator = _msgSender();
1292 
1293         _beforeTokenTransfer(operator, from, to, _asSingletonArray(id), _asSingletonArray(amount), data);
1294 
1295         uint256 fromBalance = _balances[id][from];
1296         require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
1297         unchecked {
1298             _balances[id][from] = fromBalance - amount;
1299         }
1300         _balances[id][to] += amount;
1301 
1302         emit TransferSingle(operator, from, to, id, amount);
1303 
1304         _doSafeTransferAcceptanceCheck(operator, from, to, id, amount, data);
1305     }
1306 
1307     /**
1308      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_safeTransferFrom}.
1309      *
1310      * Emits a {TransferBatch} event.
1311      *
1312      * Requirements:
1313      *
1314      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
1315      * acceptance magic value.
1316      */
1317     function _safeBatchTransferFrom(
1318         address from,
1319         address to,
1320         uint256[] memory ids,
1321         uint256[] memory amounts,
1322         bytes memory data
1323     ) internal virtual {
1324         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
1325         require(to != address(0), "ERC1155: transfer to the zero address");
1326 
1327         address operator = _msgSender();
1328 
1329         _beforeTokenTransfer(operator, from, to, ids, amounts, data);
1330 
1331         for (uint256 i = 0; i < ids.length; ++i) {
1332             uint256 id = ids[i];
1333             uint256 amount = amounts[i];
1334 
1335             uint256 fromBalance = _balances[id][from];
1336             require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
1337             unchecked {
1338                 _balances[id][from] = fromBalance - amount;
1339             }
1340             _balances[id][to] += amount;
1341         }
1342 
1343         emit TransferBatch(operator, from, to, ids, amounts);
1344 
1345         _doSafeBatchTransferAcceptanceCheck(operator, from, to, ids, amounts, data);
1346     }
1347 
1348     /**
1349      * @dev Sets a new URI for all token types, by relying on the token type ID
1350      * substitution mechanism
1351      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
1352      *
1353      * By this mechanism, any occurrence of the `\{id\}` substring in either the
1354      * URI or any of the amounts in the JSON file at said URI will be replaced by
1355      * clients with the token type ID.
1356      *
1357      * For example, the `https://token-cdn-domain/\{id\}.json` URI would be
1358      * interpreted by clients as
1359      * `https://token-cdn-domain/000000000000000000000000000000000000000000000000000000000004cce0.json`
1360      * for token type ID 0x4cce0.
1361      *
1362      * See {uri}.
1363      *
1364      * Because these URIs cannot be meaningfully represented by the {URI} event,
1365      * this function emits no events.
1366      */
1367     function _setURI(string memory newuri) internal virtual {
1368         _uri = newuri;
1369     }
1370 
1371     /**
1372      * @dev Creates `amount` tokens of token type `id`, and assigns them to `account`.
1373      *
1374      * Emits a {TransferSingle} event.
1375      *
1376      * Requirements:
1377      *
1378      * - `account` cannot be the zero address.
1379      * - If `account` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
1380      * acceptance magic value.
1381      */
1382     function _mint(
1383         address account,
1384         uint256 id,
1385         uint256 amount,
1386         bytes memory data
1387     ) internal virtual {
1388         require(account != address(0), "ERC1155: mint to the zero address");
1389 
1390         address operator = _msgSender();
1391 
1392         _beforeTokenTransfer(operator, address(0), account, _asSingletonArray(id), _asSingletonArray(amount), data);
1393 
1394         _balances[id][account] += amount;
1395         emit TransferSingle(operator, address(0), account, id, amount);
1396 
1397         _doSafeTransferAcceptanceCheck(operator, address(0), account, id, amount, data);
1398     }
1399 
1400     /**
1401      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_mint}.
1402      *
1403      * Requirements:
1404      *
1405      * - `ids` and `amounts` must have the same length.
1406      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
1407      * acceptance magic value.
1408      */
1409     function _mintBatch(
1410         address to,
1411         uint256[] memory ids,
1412         uint256[] memory amounts,
1413         bytes memory data
1414     ) internal virtual {
1415         require(to != address(0), "ERC1155: mint to the zero address");
1416         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
1417 
1418         address operator = _msgSender();
1419 
1420         _beforeTokenTransfer(operator, address(0), to, ids, amounts, data);
1421 
1422         for (uint256 i = 0; i < ids.length; i++) {
1423             _balances[ids[i]][to] += amounts[i];
1424         }
1425 
1426         emit TransferBatch(operator, address(0), to, ids, amounts);
1427 
1428         _doSafeBatchTransferAcceptanceCheck(operator, address(0), to, ids, amounts, data);
1429     }
1430 
1431     /**
1432      * @dev Destroys `amount` tokens of token type `id` from `account`
1433      *
1434      * Requirements:
1435      *
1436      * - `account` cannot be the zero address.
1437      * - `account` must have at least `amount` tokens of token type `id`.
1438      */
1439     function _burn(
1440         address account,
1441         uint256 id,
1442         uint256 amount
1443     ) internal virtual {
1444         require(account != address(0), "ERC1155: burn from the zero address");
1445 
1446         address operator = _msgSender();
1447 
1448         _beforeTokenTransfer(operator, account, address(0), _asSingletonArray(id), _asSingletonArray(amount), "");
1449 
1450         uint256 accountBalance = _balances[id][account];
1451         require(accountBalance >= amount, "ERC1155: burn amount exceeds balance");
1452         unchecked {
1453             _balances[id][account] = accountBalance - amount;
1454         }
1455 
1456         emit TransferSingle(operator, account, address(0), id, amount);
1457     }
1458 
1459     /**
1460      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_burn}.
1461      *
1462      * Requirements:
1463      *
1464      * - `ids` and `amounts` must have the same length.
1465      */
1466     function _burnBatch(
1467         address account,
1468         uint256[] memory ids,
1469         uint256[] memory amounts
1470     ) internal virtual {
1471         require(account != address(0), "ERC1155: burn from the zero address");
1472         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
1473 
1474         address operator = _msgSender();
1475 
1476         _beforeTokenTransfer(operator, account, address(0), ids, amounts, "");
1477 
1478         for (uint256 i = 0; i < ids.length; i++) {
1479             uint256 id = ids[i];
1480             uint256 amount = amounts[i];
1481 
1482             uint256 accountBalance = _balances[id][account];
1483             require(accountBalance >= amount, "ERC1155: burn amount exceeds balance");
1484             unchecked {
1485                 _balances[id][account] = accountBalance - amount;
1486             }
1487         }
1488 
1489         emit TransferBatch(operator, account, address(0), ids, amounts);
1490     }
1491 
1492     /**
1493      * @dev Hook that is called before any token transfer. This includes minting
1494      * and burning, as well as batched variants.
1495      *
1496      * The same hook is called on both single and batched variants. For single
1497      * transfers, the length of the `id` and `amount` arrays will be 1.
1498      *
1499      * Calling conditions (for each `id` and `amount` pair):
1500      *
1501      * - When `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1502      * of token type `id` will be  transferred to `to`.
1503      * - When `from` is zero, `amount` tokens of token type `id` will be minted
1504      * for `to`.
1505      * - when `to` is zero, `amount` of ``from``'s tokens of token type `id`
1506      * will be burned.
1507      * - `from` and `to` are never both zero.
1508      * - `ids` and `amounts` have the same, non-zero length.
1509      *
1510      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1511      */
1512     function _beforeTokenTransfer(
1513         address operator,
1514         address from,
1515         address to,
1516         uint256[] memory ids,
1517         uint256[] memory amounts,
1518         bytes memory data
1519     ) internal virtual {}
1520 
1521     function _doSafeTransferAcceptanceCheck(
1522         address operator,
1523         address from,
1524         address to,
1525         uint256 id,
1526         uint256 amount,
1527         bytes memory data
1528     ) private {
1529         if (to.isContract()) {
1530             try IERC1155Receiver(to).onERC1155Received(operator, from, id, amount, data) returns (bytes4 response) {
1531                 if (response != IERC1155Receiver.onERC1155Received.selector) {
1532                     revert("ERC1155: ERC1155Receiver rejected tokens");
1533                 }
1534             } catch Error(string memory reason) {
1535                 revert(reason);
1536             } catch {
1537                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
1538             }
1539         }
1540     }
1541 
1542     function _doSafeBatchTransferAcceptanceCheck(
1543         address operator,
1544         address from,
1545         address to,
1546         uint256[] memory ids,
1547         uint256[] memory amounts,
1548         bytes memory data
1549     ) private {
1550         if (to.isContract()) {
1551             try IERC1155Receiver(to).onERC1155BatchReceived(operator, from, ids, amounts, data) returns (
1552                 bytes4 response
1553             ) {
1554                 if (response != IERC1155Receiver.onERC1155BatchReceived.selector) {
1555                     revert("ERC1155: ERC1155Receiver rejected tokens");
1556                 }
1557             } catch Error(string memory reason) {
1558                 revert(reason);
1559             } catch {
1560                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
1561             }
1562         }
1563     }
1564 
1565     function _asSingletonArray(uint256 element) private pure returns (uint256[] memory) {
1566         uint256[] memory array = new uint256[](1);
1567         array[0] = element;
1568 
1569         return array;
1570     }
1571 }
1572 
1573 
1574 contract GoobersRewardsNFT is ERC1155 {
1575     address public admin;
1576     string public name;
1577     string public symbol;
1578     string public metadata;
1579     
1580     mapping(uint256 => bool) minted;
1581     
1582     using ECDSA for bytes32;
1583     address signer = 0x2d74B499EF55E067cB1C2715F01AA505187B6F80;
1584 	address maintainer;
1585 
1586     modifier onlyAdmin {
1587         require(admin == msg.sender, "Not allowed");
1588         _;
1589     }
1590 
1591     constructor(
1592         string memory _name,
1593         string memory _symbol,
1594         string memory _metadata
1595     ) ERC1155("") {
1596         name = _name;
1597         symbol = _symbol;
1598         metadata = _metadata;
1599         admin = msg.sender;
1600     }
1601 
1602     function authorizedMint(uint _nftId, bool _unique, uint _nonce, bytes memory _signature) public {
1603         bytes32 hash = hashTransaction(msg.sender, _nftId, _unique, _nonce);
1604         require(!minted[uint(hash)], "Token already minted");
1605         require(matchSignerAdmin(signTransaction(hash), _signature), "Signature mismatch");
1606         _mint(msg.sender, _nftId, 1, "");
1607         minted[uint(hash)] = true;
1608     }
1609 
1610     function adminBatchMint(
1611         address[] memory _to,
1612         uint256[] memory _ids,
1613         uint256[] memory _values,
1614         bytes memory _data
1615     ) public onlyAdmin {
1616         for (uint256 i = 0; i < _to.length; i++) {
1617             _mint(_to[i], _ids[i], _values[i], _data);
1618         }
1619     }
1620 
1621     function updateMetadata(string memory _metadata) external {
1622 		require (msg.sender == admin || msg.sender == maintainer, "Not allowed");
1623         metadata = _metadata;
1624     }
1625 
1626     function uri(uint256 _id) public view override returns (string memory) {
1627         return string(abi.encodePacked(metadata, uint2str(_id), ".json"));
1628     }
1629 
1630     function supportsInterface(bytes4 interfaceId)
1631         public
1632         view
1633         virtual
1634         override(ERC1155)
1635         returns (bool)
1636     {
1637         return super.supportsInterface(interfaceId);
1638     }
1639     
1640     function hasBeenMinted(address _sender, uint _nftId, bool _unique, uint _nonce) public view returns (bool) {
1641         return minted[uint(keccak256(abi.encodePacked(_sender, _nftId, _unique, _nonce)))];
1642     }
1643     
1644     function hashTransaction(address _sender, uint _nftId, bool _unique, uint _nonce) public pure returns (bytes32) {
1645         bytes32 _hash = keccak256(abi.encodePacked(_sender, _nftId, _unique, _nonce));
1646     	return _hash;
1647 	}
1648 	
1649 	
1650 	function signTransaction(bytes32 _hash) public pure returns (bytes32) {
1651 	    return _hash.toEthSignedMessageHash();
1652 	}
1653 
1654 	function matchSignerAdmin(bytes32 _payload, bytes memory _signature) public view returns (bool) {
1655 		return signer == _payload.recover(_signature);
1656 	}
1657 
1658     function changeMaintainer(address newAddress) external onlyAdmin {
1659         maintainer = newAddress;
1660     }
1661 	
1662 	function changeAdmin(address newAdmin) external onlyAdmin {
1663 	    admin = newAdmin;
1664 	}
1665 	
1666 	function changeApprovedSigner(address newSigner) external onlyAdmin {
1667 	    signer = newSigner;
1668 	}
1669 
1670     function uint2str(uint _i) internal pure returns (string memory _uintAsString) {
1671         if (_i == 0) {
1672             return "0";
1673         }
1674         uint j = _i;
1675         uint len;
1676         while (j != 0) {
1677             len++;
1678             j /= 10;
1679         }
1680         bytes memory bstr = new bytes(len);
1681         uint k = len;
1682         while (_i != 0) {
1683             k = k-1;
1684             uint8 temp = (48 + uint8(_i - _i / 10 * 10));
1685             bytes1 b1 = bytes1(temp);
1686             bstr[k] = b1;
1687             _i /= 10;
1688         }
1689         return string(bstr);
1690     }
1691 }