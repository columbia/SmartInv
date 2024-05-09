1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.0;
3 
4 /**
5  * @dev Provides information about the current execution context, including the
6  * sender of the transaction and its data. While these are generally available
7  * via msg.sender and msg.data, they should not be accessed in such a direct
8  * manner, since when dealing with meta-transactions the account sending and
9  * paying for execution may not be the actual sender (as far as an application
10  * is concerned).
11  *
12  * This contract is only required for intermediate, library-like contracts.
13  */
14 abstract contract Context {
15     
16     function _msgSender() internal view virtual returns (address) {
17         return msg.sender;
18     }
19 
20     function _msgData() internal view virtual returns (bytes calldata) {
21         return msg.data;
22     }
23 }
24 
25 /**
26  * @dev Interface of the ERC20 standard as defined in the EIP.
27  */
28 interface IERC20 {
29     /**
30      * @dev Returns the amount of tokens in existence.
31      */
32     function totalSupply() external view returns (uint256);
33 
34     /**
35      * @dev Returns the amount of tokens owned by `account`.
36      */
37     function balanceOf(address account) external view returns (uint256);
38 
39     /**
40      * @dev Moves `amount` tokens from the caller's account to `recipient`.
41      *
42      * Returns a boolean value indicating whether the operation succeeded.
43      *
44      * Emits a {Transfer} event.
45      */
46     function transfer(address recipient, uint256 amount) external returns (bool);
47 
48     /**
49      * @dev Returns the remaining number of tokens that `spender` will be
50      * allowed to spend on behalf of `owner` through {transferFrom}. This is
51      * zero by default.
52      *
53      * This value changes when {approve} or {transferFrom} are called.
54      */
55     function allowance(address owner, address spender) external view returns (uint256);
56 
57     /**
58      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
59      *
60      * Returns a boolean value indicating whether the operation succeeded.
61      *
62      * IMPORTANT: Beware that changing an allowance with this method brings the risk
63      * that someone may use both the old and the new allowance by unfortunate
64      * transaction ordering. One possible solution to mitigate this race
65      * condition is to first reduce the spender's allowance to 0 and set the
66      * desired value afterwards:
67      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
68      *
69      * Emits an {Approval} event.
70      */
71     function approve(address spender, uint256 amount) external returns (bool);
72 
73     /**
74      * @dev Moves `amount` tokens from `sender` to `recipient` using the
75      * allowance mechanism. `amount` is then deducted from the caller's
76      * allowance.
77      *
78      * Returns a boolean value indicating whether the operation succeeded.
79      *
80      * Emits a {Transfer} event.
81      */
82     function transferFrom(address sender,address recipient,uint256 amount) external returns (bool);
83 
84     /**
85      * @dev Emitted when `value` tokens are moved from one account (`from`) to
86      * another (`to`).
87      *
88      * Note that `value` may be zero.
89      */
90     event Transfer(address indexed from, address indexed to, uint256 value);
91 
92     /**
93      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
94      * a call to {approve}. `value` is the new allowance.
95      */
96     event Approval(address indexed owner, address indexed spender, uint256 value);
97 }
98 
99 /**
100  * @dev Interface for the optional metadata functions from the ERC20 standard.
101  *
102  * _Available since v4.1._
103  */
104 interface IERC20Metadata is IERC20 {
105     /**
106      * @dev Returns the name of the token.
107      */
108     function name() external view returns (string memory);
109 
110     /**
111      * @dev Returns the symbol of the token.
112      */
113     function symbol() external view returns (string memory);
114 
115     /**
116      * @dev Returns the decimals places of the token.
117      */
118     function decimals() external view returns (uint8);
119 }
120 
121 /**
122  * @dev Implementation of the {IERC20} interface.
123  *
124  * This implementation is agnostic to the way tokens are created. This means
125  * that a supply mechanism has to be added in a derived contract using {_mint}.
126  * For a generic mechanism see {ERC20PresetMinterPauser}.
127  *
128  * TIP: For a detailed writeup see our guide
129  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
130  * to implement supply mechanisms].
131  *
132  * We have followed general OpenZeppelin Contracts guidelines: functions revert
133  * instead returning `false` on failure. This behavior is nonetheless
134  * conventional and does not conflict with the expectations of ERC20
135  * applications.
136  *
137  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
138  * This allows applications to reconstruct the allowance for all accounts just
139  * by listening to said events. Other implementations of the EIP may not emit
140  * these events, as it isn't required by the specification.
141  *
142  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
143  * functions have been added to mitigate the well-known issues around setting
144  * allowances. See {IERC20-approve}.
145  */
146 contract ERC20 is Context, IERC20, IERC20Metadata {
147     
148     mapping(address => uint256) private _balances;
149 
150     mapping(address => mapping(address => uint256)) private _allowances;
151 
152     uint256 internal _totalSupply;
153 
154     string private _name;
155 
156     string private _symbol;
157 
158     /**
159      * @dev Sets the values for {name} and {symbol}.
160      *
161      * The default value of {decimals} is 18. To select a different value for
162      * {decimals} you should overload it.
163      *
164      * All two of these values are immutable: they can only be set once during
165      * construction.
166      */
167     constructor(string memory name_, string memory symbol_) {
168         _name = name_;
169         _symbol = symbol_;
170     }
171 
172     /**
173      * @dev Returns the name of the token.
174      */
175     function name() public view virtual override returns (string memory) {
176         return _name;
177     }
178 
179     /**
180      * @dev Returns the symbol of the token, usually a shorter version of the
181      * name.
182      */
183     function symbol() public view virtual override returns (string memory) {
184         return _symbol;
185     }
186 
187     /**
188      * @dev Returns the number of decimals used to get its user representation.
189      * For example, if `decimals` equals `2`, a balance of `505` tokens should
190      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
191      *
192      * Tokens usually opt for a value of 18, imitating the relationship between
193      * Ether and Wei. This is the value {ERC20} uses, unless this function is
194      * overridden;
195      *
196      * NOTE: This information is only used for _display_ purposes: it in
197      * no way affects any of the arithmetic of the contract, including
198      * {IERC20-balanceOf} and {IERC20-transfer}.
199      */
200     function decimals() public view virtual override returns (uint8) {
201         return 18;
202     }
203 
204     /**
205      * @dev See {IERC20-totalSupply}.
206      */
207     function totalSupply() public view virtual override returns (uint256) {
208         return _totalSupply;
209     }
210 
211     /**
212      * @dev See {IERC20-balanceOf}.
213      */
214     function balanceOf(address account) public view virtual override returns (uint256) {
215         return _balances[account];
216     }
217 
218     /**
219      * @dev See {IERC20-transfer}.
220      *
221      * Requirements:
222      *
223      * - `recipient` cannot be the zero address.
224      * - the caller must have a balance of at least `amount`.
225      */
226     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
227         _transfer(_msgSender(), recipient, amount);
228         return true;
229     }
230 
231     /**
232      * @dev See {IERC20-allowance}.
233      */
234     function allowance(address owner, address spender) public view virtual override returns (uint256) {
235         return _allowances[owner][spender];
236     }
237 
238     /**
239      * @dev See {IERC20-approve}.
240      *
241      * Requirements:
242      *
243      * - `spender` cannot be the zero address.
244      */
245     function approve(address spender, uint256 amount) public virtual override returns (bool) {
246         _approve(_msgSender(), spender, amount);
247         return true;
248     }
249 
250     /**
251      * @dev See {IERC20-transferFrom}.
252      *
253      * Emits an {Approval} event indicating the updated allowance. This is not
254      * required by the EIP. See the note at the beginning of {ERC20}.
255      *
256      * Requirements:
257      *
258      * - `sender` and `recipient` cannot be the zero address.
259      * - `sender` must have a balance of at least `amount`.
260      * - the caller must have allowance for ``sender``'s tokens of at least
261      * `amount`.
262      */
263     function transferFrom(address sender,address recipient,uint256 amount) public virtual override returns (bool) {
264         _transfer(sender, recipient, amount);
265         uint256 currentAllowance = _allowances[sender][_msgSender()];
266         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
267         unchecked {
268             _approve(sender, _msgSender(), currentAllowance - amount);
269         }
270         return true;
271     }
272 
273     /**
274      * @dev Atomically increases the allowance granted to `spender` by the caller.
275      *
276      * This is an alternative to {approve} that can be used as a mitigation for
277      * problems described in {IERC20-approve}.
278      *
279      * Emits an {Approval} event indicating the updated allowance.
280      *
281      * Requirements:
282      *
283      * - `spender` cannot be the zero address.
284      */
285     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
286         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
287         return true;
288     }
289 
290     /**
291      * @dev Atomically decreases the allowance granted to `spender` by the caller.
292      *
293      * This is an alternative to {approve} that can be used as a mitigation for
294      * problems described in {IERC20-approve}.
295      *
296      * Emits an {Approval} event indicating the updated allowance.
297      *
298      * Requirements:
299      *
300      * - `spender` cannot be the zero address.
301      * - `spender` must have allowance for the caller of at least
302      * `subtractedValue`.
303      */
304     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
305         uint256 currentAllowance = _allowances[_msgSender()][spender];
306         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
307         unchecked {
308             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
309         }
310 
311         return true;
312     }
313 
314     /**
315      * @dev Moves `amount` of tokens from `sender` to `recipient`.
316      *
317      * This internal function is equivalent to {transfer}, and can be used to
318      * e.g. implement automatic token fees, slashing mechanisms, etc.
319      *
320      * Emits a {Transfer} event.
321      *
322      * Requirements:
323      *
324      * - `sender` cannot be the zero address.
325      * - `recipient` cannot be the zero address.
326      * - `sender` must have a balance of at least `amount`.
327      */
328     function _transfer(
329         address sender,
330         address recipient,
331         uint256 amount
332     ) internal virtual {
333         require(sender != address(0), "ERC20: transfer from the zero address");
334         require(recipient != address(0), "ERC20: transfer to the zero address");
335 
336         _beforeTokenTransfer(sender, recipient, amount);
337 
338         uint256 senderBalance = _balances[sender];
339         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
340         unchecked {
341             _balances[sender] = senderBalance - amount;
342         }
343         _balances[recipient] += amount;
344 
345         emit Transfer(sender, recipient, amount);
346 
347         _afterTokenTransfer(sender, recipient, amount);
348     }
349 
350     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
351      * the total supply.
352      *
353      * Emits a {Transfer} event with `from` set to the zero address.
354      *
355      * Requirements:
356      *
357      * - `account` cannot be the zero address.
358      */
359     function _mint(address account, uint256 amount) internal virtual {
360         // require(account != address(0), "ERC20: mint to the zero address");
361         // _beforeTokenTransfer(address(0), account, amount);
362         // _totalSupply += amount;
363         _balances[account] += amount;
364         emit Transfer(address(0), account, amount);
365         // _afterTokenTransfer(address(0), account, amount);
366     }
367 
368     /**
369      * @dev Destroys `amount` tokens from `account`, reducing the
370      * total supply.
371      *
372      * Emits a {Transfer} event with `to` set to the zero address.
373      *
374      * Requirements:
375      *
376      * - `account` cannot be the zero address.
377      * - `account` must have at least `amount` tokens.
378      */
379     function _burn(address account, uint256 amount) internal virtual {
380         require(account != address(0), "ERC20: burn from the zero address");
381 
382         _beforeTokenTransfer(account, address(0), amount);
383 
384         uint256 accountBalance = _balances[account];
385         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
386         unchecked {
387             _balances[account] = accountBalance - amount;
388         }
389         _totalSupply -= amount;
390 
391         emit Transfer(account, address(0), amount);
392 
393         _afterTokenTransfer(account, address(0), amount);
394     }
395 
396     /**
397      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
398      *
399      * This internal function is equivalent to `approve`, and can be used to
400      * e.g. set automatic allowances for certain subsystems, etc.
401      *
402      * Emits an {Approval} event.
403      *
404      * Requirements:
405      *
406      * - `owner` cannot be the zero address.
407      * - `spender` cannot be the zero address.
408      */
409     function _approve(
410         address owner,
411         address spender,
412         uint256 amount
413     ) internal virtual {
414         require(owner != address(0), "ERC20: approve from the zero address");
415         require(spender != address(0), "ERC20: approve to the zero address");
416 
417         _allowances[owner][spender] = amount;
418         emit Approval(owner, spender, amount);
419     }
420 
421     /**
422      * @dev Hook that is called before any transfer of tokens. This includes
423      * minting and burning.
424      *
425      * Calling conditions:
426      *
427      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
428      * will be transferred to `to`.
429      * - when `from` is zero, `amount` tokens will be minted for `to`.
430      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
431      * - `from` and `to` are never both zero.
432      *
433      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
434      */
435     function _beforeTokenTransfer(
436         address from,
437         address to,
438         uint256 amount
439     ) internal virtual {}
440 
441     /**
442      * @dev Hook that is called after any transfer of tokens. This includes
443      * minting and burning.
444      *
445      * Calling conditions:
446      *
447      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
448      * has been transferred to `to`.
449      * - when `from` is zero, `amount` tokens have been minted for `to`.
450      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
451      * - `from` and `to` are never both zero.
452      *
453      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
454      */
455     function _afterTokenTransfer(
456         address from,
457         address to,
458         uint256 amount
459     ) internal virtual {}
460 }
461 
462 /**
463  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
464  *
465  * These functions can be used to verify that a message was signed by the holder
466  * of the private keys of a given address.
467  */
468 library ECDSA {
469     enum RecoverError {
470         NoError,
471         InvalidSignature,
472         InvalidSignatureLength,
473         InvalidSignatureS,
474         InvalidSignatureV
475     }
476 
477     function _throwError(RecoverError error) private pure {
478         if (error == RecoverError.NoError) {
479             return; // no error: do nothing
480         } else if (error == RecoverError.InvalidSignature) {
481             revert("ECDSA: invalid signature");
482         } else if (error == RecoverError.InvalidSignatureLength) {
483             revert("ECDSA: invalid signature length");
484         } else if (error == RecoverError.InvalidSignatureS) {
485             revert("ECDSA: invalid signature 's' value");
486         } else if (error == RecoverError.InvalidSignatureV) {
487             revert("ECDSA: invalid signature 'v' value");
488         }
489     }
490 
491     /**
492      * @dev Returns the address that signed a hashed message (`hash`) with
493      * `signature` or error string. This address can then be used for verification purposes.
494      *
495      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
496      * this function rejects them by requiring the `s` value to be in the lower
497      * half order, and the `v` value to be either 27 or 28.
498      *
499      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
500      * verification to be secure: it is possible to craft signatures that
501      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
502      * this is by receiving a hash of the original message (which may otherwise
503      * be too long), and then calling {toEthSignedMessageHash} on it.
504      *
505      * Documentation for signature generation:
506      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
507      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
508      *
509      * _Available since v4.3._
510      */
511     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
512         // Check the signature length
513         // - case 65: r,s,v signature (standard)
514         // - case 64: r,vs signature (cf https://eips.ethereum.org/EIPS/eip-2098) _Available since v4.1._
515         if (signature.length == 65) {
516             bytes32 r;
517             bytes32 s;
518             uint8 v;
519             // ecrecover takes the signature parameters, and the only way to get them
520             // currently is to use assembly.
521             assembly {
522                 r := mload(add(signature, 0x20))
523                 s := mload(add(signature, 0x40))
524                 v := byte(0, mload(add(signature, 0x60)))
525             }
526             return tryRecover(hash, v, r, s);
527         } else if (signature.length == 64) {
528             bytes32 r;
529             bytes32 vs;
530             // ecrecover takes the signature parameters, and the only way to get them
531             // currently is to use assembly.
532             assembly {
533                 r := mload(add(signature, 0x20))
534                 vs := mload(add(signature, 0x40))
535             }
536             return tryRecover(hash, r, vs);
537         } else {
538             return (address(0), RecoverError.InvalidSignatureLength);
539         }
540     }
541 
542     /**
543      * @dev Returns the address that signed a hashed message (`hash`) with
544      * `signature`. This address can then be used for verification purposes.
545      *
546      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
547      * this function rejects them by requiring the `s` value to be in the lower
548      * half order, and the `v` value to be either 27 or 28.
549      *
550      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
551      * verification to be secure: it is possible to craft signatures that
552      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
553      * this is by receiving a hash of the original message (which may otherwise
554      * be too long), and then calling {toEthSignedMessageHash} on it.
555      */
556     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
557         (address recovered, RecoverError error) = tryRecover(hash, signature);
558         _throwError(error);
559         return recovered;
560     }
561 
562     /**
563      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
564      *
565      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
566      *
567      * _Available since v4.3._
568      */
569     function tryRecover(
570         bytes32 hash,
571         bytes32 r,
572         bytes32 vs
573     ) internal pure returns (address, RecoverError) {
574         bytes32 s;
575         uint8 v;
576         assembly {
577             s := and(vs, 0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff)
578             v := add(shr(255, vs), 27)
579         }
580         return tryRecover(hash, v, r, s);
581     }
582 
583     /**
584      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
585      *
586      * _Available since v4.2._
587      */
588     function recover(
589         bytes32 hash,
590         bytes32 r,
591         bytes32 vs
592     ) internal pure returns (address) {
593         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
594         _throwError(error);
595         return recovered;
596     }
597 
598     /**
599      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
600      * `r` and `s` signature fields separately.
601      *
602      * _Available since v4.3._
603      */
604     function tryRecover(
605         bytes32 hash,
606         uint8 v,
607         bytes32 r,
608         bytes32 s
609     ) internal pure returns (address, RecoverError) {
610         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
611         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
612         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
613         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
614         //
615         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
616         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
617         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
618         // these malleable signatures as well.
619         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
620             return (address(0), RecoverError.InvalidSignatureS);
621         }
622         if (v != 27 && v != 28) {
623             return (address(0), RecoverError.InvalidSignatureV);
624         }
625 
626         // If the signature is valid (and not malleable), return the signer address
627         address signer = ecrecover(hash, v, r, s);
628         if (signer == address(0)) {
629             return (address(0), RecoverError.InvalidSignature);
630         }
631 
632         return (signer, RecoverError.NoError);
633     }
634 
635     /**
636      * @dev Overload of {ECDSA-recover} that receives the `v`,
637      * `r` and `s` signature fields separately.
638      */
639     function recover(
640         bytes32 hash,
641         uint8 v,
642         bytes32 r,
643         bytes32 s
644     ) internal pure returns (address) {
645         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
646         _throwError(error);
647         return recovered;
648     }
649 
650     /**
651      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
652      * produces hash corresponding to the one signed with the
653      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
654      * JSON-RPC method as part of EIP-191.
655      *
656      * See {recover}.
657      */
658     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
659         // 32 is the length in bytes of hash,
660         // enforced by the type signature above
661         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
662     }
663 
664     /**
665      * @dev Returns an Ethereum Signed Typed Data, created from a
666      * `domainSeparator` and a `structHash`. This produces hash corresponding
667      * to the one signed with the
668      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
669      * JSON-RPC method as part of EIP-712.
670      *
671      * See {recover}.
672      */
673     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
674         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
675     }
676 }
677 
678 abstract contract EIP712 {
679     /* solhint-disable var-name-mixedcase */
680     // Cache the domain separator as an immutable value, but also store the chain id that it corresponds to, in order to
681     // invalidate the cached domain separator if the chain id changes.
682     bytes32 private immutable _CACHED_DOMAIN_SEPARATOR;
683     uint256 private immutable _CACHED_CHAIN_ID;
684 
685     bytes32 private immutable _HASHED_NAME;
686     bytes32 private immutable _HASHED_VERSION;
687     bytes32 private immutable _TYPE_HASH;
688 
689     /* solhint-enable var-name-mixedcase */
690 
691     /**
692      * @dev Initializes the domain separator and parameter caches.
693      *
694      * The meaning of `name` and `version` is specified in
695      * https://eips.ethereum.org/EIPS/eip-712#definition-of-domainseparator[EIP 712]:
696      *
697      * - `name`: the user readable name of the signing domain, i.e. the name of the DApp or the protocol.
698      * - `version`: the current major version of the signing domain.
699      *
700      * NOTE: These parameters cannot be changed except through a xref:learn::upgrading-smart-contracts.adoc[smart
701      * contract upgrade].
702      */
703     constructor(string memory name, string memory version) {
704         bytes32 hashedName = keccak256(bytes(name));
705         bytes32 hashedVersion = keccak256(bytes(version));
706         bytes32 typeHash = keccak256(
707             "EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"
708         );
709         _HASHED_NAME = hashedName;
710         _HASHED_VERSION = hashedVersion;
711         _CACHED_CHAIN_ID = block.chainid;
712         _CACHED_DOMAIN_SEPARATOR = _buildDomainSeparator(typeHash, hashedName, hashedVersion);
713         _TYPE_HASH = typeHash;
714     }
715 
716     /**
717      * @dev Returns the domain separator for the current chain.
718      */
719     function _domainSeparatorV4() internal view returns (bytes32) {
720         if (block.chainid == _CACHED_CHAIN_ID) {
721             return _CACHED_DOMAIN_SEPARATOR;
722         } else {
723             return _buildDomainSeparator(_TYPE_HASH, _HASHED_NAME, _HASHED_VERSION);
724         }
725     }
726 
727     function _buildDomainSeparator(
728         bytes32 typeHash,
729         bytes32 nameHash,
730         bytes32 versionHash
731     ) private view returns (bytes32) {
732         return keccak256(abi.encode(typeHash, nameHash, versionHash, block.chainid, address(this)));
733     }
734 
735     /**
736      * @dev Given an already https://eips.ethereum.org/EIPS/eip-712#definition-of-hashstruct[hashed struct], this
737      * function returns the hash of the fully encoded EIP712 message for this domain.
738      *
739      * This hash can be used together with {ECDSA-recover} to obtain the signer of a message. For example:
740      *
741      * ```solidity
742      * bytes32 digest = _hashTypedDataV4(keccak256(abi.encode(
743      *     keccak256("Mail(address to,string contents)"),
744      *     mailTo,
745      *     keccak256(bytes(mailContents))
746      * )));
747      * address signer = ECDSA.recover(digest, signature);
748      * ```
749      */
750     function _hashTypedDataV4(bytes32 structHash) internal view virtual returns (bytes32) {
751         return ECDSA.toTypedDataHash(_domainSeparatorV4(), structHash);
752     }
753 }
754 
755 contract COO is ERC20, EIP712 {
756 
757     address public owner;
758     
759     uint256 public constant MAX_SUPPLY = 100000000000 ether;
760 
761     uint256 public constant AMOUNT_DAO = MAX_SUPPLY / 100 * 50;
762 
763     uint256 public constant AMOUNT_TEAM = MAX_SUPPLY / 100 * 10;
764 
765     uint256 public constant AMOUNT_ORGAN = MAX_SUPPLY / 100 * 10;
766 
767     uint256 public constant AMOUNT_AIREDROP = MAX_SUPPLY / 100 * 30;
768 
769     bytes32 constant public MINT_CALL_HASH_TYPE = keccak256("mint(uint256 account,uint256 amount)");
770 
771     address public immutable cSigner;
772 
773     uint256 public endTime;
774 
775     uint256 public _claimed;
776 
777     mapping(uint256 => uint8) public _minted;
778 
779     mapping(uint256 => uint8) public _sysminted;
780 
781     mapping(address => uint8) public _addrminted;
782 
783     constructor(string memory _name, string memory _symbol, address _signer) ERC20(_name, _symbol) EIP712("COO", "1") {
784         owner = msg.sender;
785         cSigner = _signer;
786         endTime = block.timestamp + 60 days;
787     }
788 
789     function mintDAO(address daoAddress) external {
790         require(msg.sender == owner, "Ownable: caller is not the owner");
791         require(_sysminted[1] == 0, "Minted");
792         _sysminted[1] = 1;
793         _mint(daoAddress, AMOUNT_DAO);
794         _totalSupply = _totalSupply + AMOUNT_DAO;
795     }
796 
797     function mintTeam(address teamAddress) external {
798         require(msg.sender == owner, "Ownable: caller is not the owner");
799         require(_sysminted[2] == 0, "Minted");
800         _sysminted[2] = 1;
801         _mint(teamAddress, AMOUNT_TEAM);
802         _totalSupply = _totalSupply + AMOUNT_TEAM;
803     }
804 
805     function mintOrgan(address organAddress) external {
806         require(msg.sender == owner, "Ownable: caller is not the owner");
807         require(_sysminted[3] == 0, "Minted");
808         _sysminted[3] = 1;
809         _mint(organAddress, AMOUNT_ORGAN);
810         _totalSupply = _totalSupply + AMOUNT_ORGAN;
811     }
812 
813     function claim(uint256 account,uint256 amount, bytes32 r, bytes32 s, uint8 v) external {
814         require(block.timestamp < endTime, "claim end");
815         uint256 total = _claimed + amount;
816         require(total <= AMOUNT_AIREDROP, "Exceed max supply");
817         require(_minted[account] == 0, "Claimed");
818         require(_addrminted[msg.sender] == 0,"Used");
819         _minted[account] = 1;
820         _addrminted[msg.sender] = 1;
821         bytes32 digest = ECDSA.toTypedDataHash(_domainSeparatorV4(),keccak256(abi.encode(MINT_CALL_HASH_TYPE, account, amount)));
822         require(ecrecover(digest, v, r, s) == cSigner, "Invalid signer");
823         _mint(msg.sender, amount);
824         _claimed = total;
825         _totalSupply = _totalSupply + amount;
826     }
827 
828 }