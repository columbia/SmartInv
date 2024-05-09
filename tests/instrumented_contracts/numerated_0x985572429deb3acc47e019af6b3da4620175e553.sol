1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.10;
3 
4 /**
5  * @dev Interface of the ERC20 standard as defined in the EIP.
6  */
7 interface IERC20 {
8     /**
9      * @dev Returns the amount of tokens in existence.
10      */
11     function totalSupply() external view returns (uint256);
12 
13     /**
14      * @dev Returns the amount of tokens owned by `account`.
15      */
16     function balanceOf(address account) external view returns (uint256);
17 
18     /**
19      * @dev Moves `amount` tokens from the caller's account to `recipient`.
20      *
21      * Returns a boolean value indicating whether the operation succeeded.
22      *
23      * Emits a {Transfer} event.
24      */
25     function transfer(address recipient, uint256 amount) external returns (bool);
26 
27     /**
28      * @dev Returns the remaining number of tokens that `spender` will be
29      * allowed to spend on behalf of `owner` through {transferFrom}. This is
30      * zero by default.
31      *
32      * This value changes when {approve} or {transferFrom} are called.
33      */
34     function allowance(address owner, address spender) external view returns (uint256);
35 
36     /**
37      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
38      *
39      * Returns a boolean value indicating whether the operation succeeded.
40      *
41      * IMPORTANT: Beware that changing an allowance with this method brings the risk
42      * that someone may use both the old and the new allowance by unfortunate
43      * transaction ordering. One possible solution to mitigate this race
44      * condition is to first reduce the spender's allowance to 0 and set the
45      * desired value afterwards:
46      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
47      *
48      * Emits an {Approval} event.
49      */
50     function approve(address spender, uint256 amount) external returns (bool);
51 
52     /**
53      * @dev Moves `amount` tokens from `sender` to `recipient` using the
54      * allowance mechanism. `amount` is then deducted from the caller's
55      * allowance.
56      *
57      * Returns a boolean value indicating whether the operation succeeded.
58      *
59      * Emits a {Transfer} event.
60      */
61     function transferFrom(
62         address sender,
63         address recipient,
64         uint256 amount
65     ) external returns (bool);
66 
67     /**
68      * @dev Emitted when `value` tokens are moved from one account (`from`) to
69      * another (`to`).
70      *
71      * Note that `value` may be zero.
72      */
73     event Transfer(address indexed from, address indexed to, uint256 value);
74 
75     /**
76      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
77      * a call to {approve}. `value` is the new allowance.
78      */
79     event Approval(address indexed owner, address indexed spender, uint256 value);
80 }
81 
82 /**
83  * @dev Interface for the optional metadata functions from the ERC20 standard.
84  *
85  * _Available since v4.1._
86  */
87 interface IERC20Metadata is IERC20 {
88     /**
89      * @dev Returns the name of the token.
90      */
91     function name() external view returns (string memory);
92 
93     /**
94      * @dev Returns the symbol of the token.
95      */
96     function symbol() external view returns (string memory);
97 
98     /**
99      * @dev Returns the decimals places of the token.
100      */
101     function decimals() external view returns (uint8);
102 }
103 
104 /**
105  * @dev Provides information about the current execution context, including the
106  * sender of the transaction and its data. While these are generally available
107  * via msg.sender and msg.data, they should not be accessed in such a direct
108  * manner, since when dealing with meta-transactions the account sending and
109  * paying for execution may not be the actual sender (as far as an application
110  * is concerned).
111  *
112  * This contract is only required for intermediate, library-like contracts.
113  */
114 abstract contract Context {
115     function _msgSender() internal view virtual returns (address) {
116         return msg.sender;
117     }
118 
119     function _msgData() internal view virtual returns (bytes calldata) {
120         return msg.data;
121     }
122 }
123 
124 /**
125  * @dev Implementation of the {IERC20} interface.
126  *
127  * This implementation is agnostic to the way tokens are created. This means
128  * that a supply mechanism has to be added in a derived contract using {_mint}.
129  * For a generic mechanism see {ERC20PresetMinterPauser}.
130  *
131  * TIP: For a detailed writeup see our guide
132  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
133  * to implement supply mechanisms].
134  *
135  * We have followed general OpenZeppelin Contracts guidelines: functions revert
136  * instead returning `false` on failure. This behavior is nonetheless
137  * conventional and does not conflict with the expectations of ERC20
138  * applications.
139  *
140  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
141  * This allows applications to reconstruct the allowance for all accounts just
142  * by listening to said events. Other implementations of the EIP may not emit
143  * these events, as it isn't required by the specification.
144  *
145  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
146  * functions have been added to mitigate the well-known issues around setting
147  * allowances. See {IERC20-approve}.
148  */
149 contract ERC20 is Context, IERC20, IERC20Metadata {
150     mapping(address => uint256) private _balances;
151 
152     mapping(address => mapping(address => uint256)) private _allowances;
153 
154     uint256 private _totalSupply;
155 
156     string private _name;
157     string private _symbol;
158 
159     /**
160      * @dev Sets the values for {name} and {symbol}.
161      *
162      * The default value of {decimals} is 18. To select a different value for
163      * {decimals} you should overload it.
164      *
165      * All two of these values are immutable: they can only be set once during
166      * construction.
167      */
168     constructor(string memory name_, string memory symbol_) {
169         _name = name_;
170         _symbol = symbol_;
171     }
172 
173     /**
174      * @dev Returns the name of the token.
175      */
176     function name() public view virtual override returns (string memory) {
177         return _name;
178     }
179 
180     /**
181      * @dev Returns the symbol of the token, usually a shorter version of the
182      * name.
183      */
184     function symbol() public view virtual override returns (string memory) {
185         return _symbol;
186     }
187 
188     /**
189      * @dev Returns the number of decimals used to get its user representation.
190      * For example, if `decimals` equals `2`, a balance of `505` tokens should
191      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
192      *
193      * Tokens usually opt for a value of 18, imitating the relationship between
194      * Ether and Wei. This is the value {ERC20} uses, unless this function is
195      * overridden;
196      *
197      * NOTE: This information is only used for _display_ purposes: it in
198      * no way affects any of the arithmetic of the contract, including
199      * {IERC20-balanceOf} and {IERC20-transfer}.
200      */
201     function decimals() public view virtual override returns (uint8) {
202         return 18;
203     }
204 
205     /**
206      * @dev See {IERC20-totalSupply}.
207      */
208     function totalSupply() public view virtual override returns (uint256) {
209         return _totalSupply;
210     }
211 
212     /**
213      * @dev See {IERC20-balanceOf}.
214      */
215     function balanceOf(address account) public view virtual override returns (uint256) {
216         return _balances[account];
217     }
218 
219     /**
220      * @dev See {IERC20-transfer}.
221      *
222      * Requirements:
223      *
224      * - `recipient` cannot be the zero address.
225      * - the caller must have a balance of at least `amount`.
226      */
227     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
228         _transfer(_msgSender(), recipient, amount);
229         return true;
230     }
231 
232     /**
233      * @dev See {IERC20-allowance}.
234      */
235     function allowance(address owner, address spender) public view virtual override returns (uint256) {
236         return _allowances[owner][spender];
237     }
238 
239     /**
240      * @dev See {IERC20-approve}.
241      *
242      * Requirements:
243      *
244      * - `spender` cannot be the zero address.
245      */
246     function approve(address spender, uint256 amount) public virtual override returns (bool) {
247         _approve(_msgSender(), spender, amount);
248         return true;
249     }
250 
251     /**
252      * @dev See {IERC20-transferFrom}.
253      *
254      * Emits an {Approval} event indicating the updated allowance. This is not
255      * required by the EIP. See the note at the beginning of {ERC20}.
256      *
257      * Requirements:
258      *
259      * - `sender` and `recipient` cannot be the zero address.
260      * - `sender` must have a balance of at least `amount`.
261      * - the caller must have allowance for ``sender``'s tokens of at least
262      * `amount`.
263      */
264     function transferFrom(
265         address sender,
266         address recipient,
267         uint256 amount
268     ) public virtual override returns (bool) {
269         _transfer(sender, recipient, amount);
270 
271         uint256 currentAllowance = _allowances[sender][_msgSender()];
272         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
273         unchecked {
274             _approve(sender, _msgSender(), currentAllowance - amount);
275         }
276 
277         return true;
278     }
279 
280     /**
281      * @dev Atomically increases the allowance granted to `spender` by the caller.
282      *
283      * This is an alternative to {approve} that can be used as a mitigation for
284      * problems described in {IERC20-approve}.
285      *
286      * Emits an {Approval} event indicating the updated allowance.
287      *
288      * Requirements:
289      *
290      * - `spender` cannot be the zero address.
291      */
292     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
293         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
294         return true;
295     }
296 
297     /**
298      * @dev Atomically decreases the allowance granted to `spender` by the caller.
299      *
300      * This is an alternative to {approve} that can be used as a mitigation for
301      * problems described in {IERC20-approve}.
302      *
303      * Emits an {Approval} event indicating the updated allowance.
304      *
305      * Requirements:
306      *
307      * - `spender` cannot be the zero address.
308      * - `spender` must have allowance for the caller of at least
309      * `subtractedValue`.
310      */
311     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
312         uint256 currentAllowance = _allowances[_msgSender()][spender];
313         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
314         unchecked {
315             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
316         }
317 
318         return true;
319     }
320 
321     /**
322      * @dev Moves `amount` of tokens from `sender` to `recipient`.
323      *
324      * This internal function is equivalent to {transfer}, and can be used to
325      * e.g. implement automatic token fees, slashing mechanisms, etc.
326      *
327      * Emits a {Transfer} event.
328      *
329      * Requirements:
330      *
331      * - `sender` cannot be the zero address.
332      * - `recipient` cannot be the zero address.
333      * - `sender` must have a balance of at least `amount`.
334      */
335     function _transfer(
336         address sender,
337         address recipient,
338         uint256 amount
339     ) internal virtual {
340         require(sender != address(0), "ERC20: transfer from the zero address");
341         require(recipient != address(0), "ERC20: transfer to the zero address");
342 
343         _beforeTokenTransfer(sender, recipient, amount);
344 
345         uint256 senderBalance = _balances[sender];
346         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
347         unchecked {
348             _balances[sender] = senderBalance - amount;
349         }
350         _balances[recipient] += amount;
351 
352         emit Transfer(sender, recipient, amount);
353 
354         _afterTokenTransfer(sender, recipient, amount);
355     }
356 
357     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
358      * the total supply.
359      *
360      * Emits a {Transfer} event with `from` set to the zero address.
361      *
362      * Requirements:
363      *
364      * - `account` cannot be the zero address.
365      */
366     function _mint(address account, uint256 amount) internal virtual {
367         require(account != address(0), "ERC20: mint to the zero address");
368 
369         _beforeTokenTransfer(address(0), account, amount);
370 
371         _totalSupply += amount;
372         _balances[account] += amount;
373         emit Transfer(address(0), account, amount);
374 
375         _afterTokenTransfer(address(0), account, amount);
376     }
377 
378     /**
379      * @dev Destroys `amount` tokens from `account`, reducing the
380      * total supply.
381      *
382      * Emits a {Transfer} event with `to` set to the zero address.
383      *
384      * Requirements:
385      *
386      * - `account` cannot be the zero address.
387      * - `account` must have at least `amount` tokens.
388      */
389     function _burn(address account, uint256 amount) internal virtual {
390         require(account != address(0), "ERC20: burn from the zero address");
391 
392         _beforeTokenTransfer(account, address(0), amount);
393 
394         uint256 accountBalance = _balances[account];
395         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
396         unchecked {
397             _balances[account] = accountBalance - amount;
398         }
399         _totalSupply -= amount;
400 
401         emit Transfer(account, address(0), amount);
402 
403         _afterTokenTransfer(account, address(0), amount);
404     }
405 
406     /**
407      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
408      *
409      * This internal function is equivalent to `approve`, and can be used to
410      * e.g. set automatic allowances for certain subsystems, etc.
411      *
412      * Emits an {Approval} event.
413      *
414      * Requirements:
415      *
416      * - `owner` cannot be the zero address.
417      * - `spender` cannot be the zero address.
418      */
419     function _approve(
420         address owner,
421         address spender,
422         uint256 amount
423     ) internal virtual {
424         require(owner != address(0), "ERC20: approve from the zero address");
425         require(spender != address(0), "ERC20: approve to the zero address");
426 
427         _allowances[owner][spender] = amount;
428         emit Approval(owner, spender, amount);
429     }
430 
431     /**
432      * @dev Hook that is called before any transfer of tokens. This includes
433      * minting and burning.
434      *
435      * Calling conditions:
436      *
437      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
438      * will be transferred to `to`.
439      * - when `from` is zero, `amount` tokens will be minted for `to`.
440      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
441      * - `from` and `to` are never both zero.
442      *
443      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
444      */
445     function _beforeTokenTransfer(
446         address from,
447         address to,
448         uint256 amount
449     ) internal virtual {}
450 
451     /**
452      * @dev Hook that is called after any transfer of tokens. This includes
453      * minting and burning.
454      *
455      * Calling conditions:
456      *
457      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
458      * has been transferred to `to`.
459      * - when `from` is zero, `amount` tokens have been minted for `to`.
460      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
461      * - `from` and `to` are never both zero.
462      *
463      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
464      */
465     function _afterTokenTransfer(
466         address from,
467         address to,
468         uint256 amount
469     ) internal virtual {}
470 }
471 
472 /**
473  * @dev Extension of {ERC20} that allows token holders to destroy both their own
474  * tokens and those that they have an allowance for, in a way that can be
475  * recognized off-chain (via event analysis).
476  */
477 abstract contract ERC20Burnable is Context, ERC20 {
478     /**
479      * @dev Destroys `amount` tokens from the caller.
480      *
481      * See {ERC20-_burn}.
482      */
483     function burn(uint256 amount) public virtual {
484         _burn(_msgSender(), amount);
485     }
486 
487     /**
488      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
489      * allowance.
490      *
491      * See {ERC20-_burn} and {ERC20-allowance}.
492      *
493      * Requirements:
494      *
495      * - the caller must have allowance for ``accounts``'s tokens of at least
496      * `amount`.
497      */
498     function burnFrom(address account, uint256 amount) public virtual {
499         uint256 currentAllowance = allowance(account, _msgSender());
500         require(currentAllowance >= amount, "ERC20: burn amount exceeds allowance");
501         unchecked {
502             _approve(account, _msgSender(), currentAllowance - amount);
503         }
504         _burn(account, amount);
505     }
506 }
507 
508 /**
509  * @dev Interface of the ERC20 Permit extension allowing approvals to be made via signatures, as defined in
510  * https://eips.ethereum.org/EIPS/eip-2612[EIP-2612].
511  *
512  * Adds the {permit} method, which can be used to change an account's ERC20 allowance (see {IERC20-allowance}) by
513  * presenting a message signed by the account. By not relying on {IERC20-approve}, the token holder account doesn't
514  * need to send a transaction, and thus is not required to hold Ether at all.
515  */
516 interface IERC20Permit {
517     /**
518      * @dev Sets `value` as the allowance of `spender` over ``owner``'s tokens,
519      * given ``owner``'s signed approval.
520      *
521      * IMPORTANT: The same issues {IERC20-approve} has related to transaction
522      * ordering also apply here.
523      *
524      * Emits an {Approval} event.
525      *
526      * Requirements:
527      *
528      * - `spender` cannot be the zero address.
529      * - `deadline` must be a timestamp in the future.
530      * - `v`, `r` and `s` must be a valid `secp256k1` signature from `owner`
531      * over the EIP712-formatted function arguments.
532      * - the signature must use ``owner``'s current nonce (see {nonces}).
533      *
534      * For more information on the signature format, see the
535      * https://eips.ethereum.org/EIPS/eip-2612#specification[relevant EIP
536      * section].
537      */
538     function permit(
539         address owner,
540         address spender,
541         uint256 value,
542         uint256 deadline,
543         uint8 v,
544         bytes32 r,
545         bytes32 s
546     ) external;
547 
548     /**
549      * @dev Returns the current nonce for `owner`. This value must be
550      * included whenever a signature is generated for {permit}.
551      *
552      * Every successful call to {permit} increases ``owner``'s nonce by one. This
553      * prevents a signature from being used multiple times.
554      */
555     function nonces(address owner) external view returns (uint256);
556 
557     /**
558      * @dev Returns the domain separator used in the encoding of the signature for {permit}, as defined by {EIP712}.
559      */
560     // solhint-disable-next-line func-name-mixedcase
561     function DOMAIN_SEPARATOR() external view returns (bytes32);
562 }
563 
564 /**
565  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
566  *
567  * These functions can be used to verify that a message was signed by the holder
568  * of the private keys of a given address.
569  */
570 library ECDSA {
571     enum RecoverError {
572         NoError,
573         InvalidSignature,
574         InvalidSignatureLength,
575         InvalidSignatureS,
576         InvalidSignatureV
577     }
578 
579     function _throwError(RecoverError error) private pure {
580         if (error == RecoverError.NoError) {
581             return; // no error: do nothing
582         } else if (error == RecoverError.InvalidSignature) {
583             revert("ECDSA: invalid signature");
584         } else if (error == RecoverError.InvalidSignatureLength) {
585             revert("ECDSA: invalid signature length");
586         } else if (error == RecoverError.InvalidSignatureS) {
587             revert("ECDSA: invalid signature 's' value");
588         } else if (error == RecoverError.InvalidSignatureV) {
589             revert("ECDSA: invalid signature 'v' value");
590         }
591     }
592 
593     /**
594      * @dev Returns the address that signed a hashed message (`hash`) with
595      * `signature` or error string. This address can then be used for verification purposes.
596      *
597      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
598      * this function rejects them by requiring the `s` value to be in the lower
599      * half order, and the `v` value to be either 27 or 28.
600      *
601      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
602      * verification to be secure: it is possible to craft signatures that
603      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
604      * this is by receiving a hash of the original message (which may otherwise
605      * be too long), and then calling {toEthSignedMessageHash} on it.
606      *
607      * Documentation for signature generation:
608      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
609      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
610      *
611      * _Available since v4.3._
612      */
613     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
614         // Check the signature length
615         // - case 65: r,s,v signature (standard)
616         // - case 64: r,vs signature (cf https://eips.ethereum.org/EIPS/eip-2098) _Available since v4.1._
617         if (signature.length == 65) {
618             bytes32 r;
619             bytes32 s;
620             uint8 v;
621             // ecrecover takes the signature parameters, and the only way to get them
622             // currently is to use assembly.
623             assembly {
624                 r := mload(add(signature, 0x20))
625                 s := mload(add(signature, 0x40))
626                 v := byte(0, mload(add(signature, 0x60)))
627             }
628             return tryRecover(hash, v, r, s);
629         } else if (signature.length == 64) {
630             bytes32 r;
631             bytes32 vs;
632             // ecrecover takes the signature parameters, and the only way to get them
633             // currently is to use assembly.
634             assembly {
635                 r := mload(add(signature, 0x20))
636                 vs := mload(add(signature, 0x40))
637             }
638             return tryRecover(hash, r, vs);
639         } else {
640             return (address(0), RecoverError.InvalidSignatureLength);
641         }
642     }
643 
644     /**
645      * @dev Returns the address that signed a hashed message (`hash`) with
646      * `signature`. This address can then be used for verification purposes.
647      *
648      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
649      * this function rejects them by requiring the `s` value to be in the lower
650      * half order, and the `v` value to be either 27 or 28.
651      *
652      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
653      * verification to be secure: it is possible to craft signatures that
654      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
655      * this is by receiving a hash of the original message (which may otherwise
656      * be too long), and then calling {toEthSignedMessageHash} on it.
657      */
658     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
659         (address recovered, RecoverError error) = tryRecover(hash, signature);
660         _throwError(error);
661         return recovered;
662     }
663 
664     /**
665      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
666      *
667      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
668      *
669      * _Available since v4.3._
670      */
671     function tryRecover(
672         bytes32 hash,
673         bytes32 r,
674         bytes32 vs
675     ) internal pure returns (address, RecoverError) {
676         bytes32 s;
677         uint8 v;
678         assembly {
679             s := and(vs, 0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff)
680             v := add(shr(255, vs), 27)
681         }
682         return tryRecover(hash, v, r, s);
683     }
684 
685     /**
686      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
687      *
688      * _Available since v4.2._
689      */
690     function recover(
691         bytes32 hash,
692         bytes32 r,
693         bytes32 vs
694     ) internal pure returns (address) {
695         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
696         _throwError(error);
697         return recovered;
698     }
699 
700     /**
701      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
702      * `r` and `s` signature fields separately.
703      *
704      * _Available since v4.3._
705      */
706     function tryRecover(
707         bytes32 hash,
708         uint8 v,
709         bytes32 r,
710         bytes32 s
711     ) internal pure returns (address, RecoverError) {
712         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
713         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
714         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
715         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
716         //
717         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
718         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
719         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
720         // these malleable signatures as well.
721         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
722             return (address(0), RecoverError.InvalidSignatureS);
723         }
724         if (v != 27 && v != 28) {
725             return (address(0), RecoverError.InvalidSignatureV);
726         }
727 
728         // If the signature is valid (and not malleable), return the signer address
729         address signer = ecrecover(hash, v, r, s);
730         if (signer == address(0)) {
731             return (address(0), RecoverError.InvalidSignature);
732         }
733 
734         return (signer, RecoverError.NoError);
735     }
736 
737     /**
738      * @dev Overload of {ECDSA-recover} that receives the `v`,
739      * `r` and `s` signature fields separately.
740      */
741     function recover(
742         bytes32 hash,
743         uint8 v,
744         bytes32 r,
745         bytes32 s
746     ) internal pure returns (address) {
747         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
748         _throwError(error);
749         return recovered;
750     }
751 
752     /**
753      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
754      * produces hash corresponding to the one signed with the
755      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
756      * JSON-RPC method as part of EIP-191.
757      *
758      * See {recover}.
759      */
760     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
761         // 32 is the length in bytes of hash,
762         // enforced by the type signature above
763         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
764     }
765 
766     /**
767      * @dev Returns an Ethereum Signed Typed Data, created from a
768      * `domainSeparator` and a `structHash`. This produces hash corresponding
769      * to the one signed with the
770      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
771      * JSON-RPC method as part of EIP-712.
772      *
773      * See {recover}.
774      */
775     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
776         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
777     }
778 }
779 
780 /**
781  * @dev https://eips.ethereum.org/EIPS/eip-712[EIP 712] is a standard for hashing and signing of typed structured data.
782  *
783  * The encoding specified in the EIP is very generic, and such a generic implementation in Solidity is not feasible,
784  * thus this contract does not implement the encoding itself. Protocols need to implement the type-specific encoding
785  * they need in their contracts using a combination of `abi.encode` and `keccak256`.
786  *
787  * This contract implements the EIP 712 domain separator ({_domainSeparatorV4}) that is used as part of the encoding
788  * scheme, and the final step of the encoding to obtain the message digest that is then signed via ECDSA
789  * ({_hashTypedDataV4}).
790  *
791  * The implementation of the domain separator was designed to be as efficient as possible while still properly updating
792  * the chain id to protect against replay attacks on an eventual fork of the chain.
793  *
794  * NOTE: This contract implements the version of the encoding known as "v4", as implemented by the JSON RPC method
795  * https://docs.metamask.io/guide/signing-data.html[`eth_signTypedDataV4` in MetaMask].
796  *
797  * _Available since v3.4._
798  */
799 abstract contract EIP712 {
800     /* solhint-disable var-name-mixedcase */
801     // Cache the domain separator as an immutable value, but also store the chain id that it corresponds to, in order to
802     // invalidate the cached domain separator if the chain id changes.
803     bytes32 private immutable _CACHED_DOMAIN_SEPARATOR;
804     uint256 private immutable _CACHED_CHAIN_ID;
805 
806     bytes32 private immutable _HASHED_NAME;
807     bytes32 private immutable _HASHED_VERSION;
808     bytes32 private immutable _TYPE_HASH;
809 
810     /* solhint-enable var-name-mixedcase */
811 
812     /**
813      * @dev Initializes the domain separator and parameter caches.
814      *
815      * The meaning of `name` and `version` is specified in
816      * https://eips.ethereum.org/EIPS/eip-712#definition-of-domainseparator[EIP 712]:
817      *
818      * - `name`: the user readable name of the signing domain, i.e. the name of the DApp or the protocol.
819      * - `version`: the current major version of the signing domain.
820      *
821      * NOTE: These parameters cannot be changed except through a xref:learn::upgrading-smart-contracts.adoc[smart
822      * contract upgrade].
823      */
824     constructor(string memory name, string memory version) {
825         bytes32 hashedName = keccak256(bytes(name));
826         bytes32 hashedVersion = keccak256(bytes(version));
827         bytes32 typeHash = keccak256(
828             "EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"
829         );
830         _HASHED_NAME = hashedName;
831         _HASHED_VERSION = hashedVersion;
832         _CACHED_CHAIN_ID = block.chainid;
833         _CACHED_DOMAIN_SEPARATOR = _buildDomainSeparator(typeHash, hashedName, hashedVersion);
834         _TYPE_HASH = typeHash;
835     }
836 
837     /**
838      * @dev Returns the domain separator for the current chain.
839      */
840     function _domainSeparatorV4() internal view returns (bytes32) {
841         if (block.chainid == _CACHED_CHAIN_ID) {
842             return _CACHED_DOMAIN_SEPARATOR;
843         } else {
844             return _buildDomainSeparator(_TYPE_HASH, _HASHED_NAME, _HASHED_VERSION);
845         }
846     }
847 
848     function _buildDomainSeparator(
849         bytes32 typeHash,
850         bytes32 nameHash,
851         bytes32 versionHash
852     ) private view returns (bytes32) {
853         return keccak256(abi.encode(typeHash, nameHash, versionHash, block.chainid, address(this)));
854     }
855 
856     /**
857      * @dev Given an already https://eips.ethereum.org/EIPS/eip-712#definition-of-hashstruct[hashed struct], this
858      * function returns the hash of the fully encoded EIP712 message for this domain.
859      *
860      * This hash can be used together with {ECDSA-recover} to obtain the signer of a message. For example:
861      *
862      * ```solidity
863      * bytes32 digest = _hashTypedDataV4(keccak256(abi.encode(
864      *     keccak256("Mail(address to,string contents)"),
865      *     mailTo,
866      *     keccak256(bytes(mailContents))
867      * )));
868      * address signer = ECDSA.recover(digest, signature);
869      * ```
870      */
871     function _hashTypedDataV4(bytes32 structHash) internal view virtual returns (bytes32) {
872         return ECDSA.toTypedDataHash(_domainSeparatorV4(), structHash);
873     }
874 }
875 
876 /**
877  * @title Counters
878  * @author Matt Condon (@shrugs)
879  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
880  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
881  *
882  * Include with `using Counters for Counters.Counter;`
883  */
884 library Counters {
885     struct Counter {
886         // This variable should never be directly accessed by users of the library: interactions must be restricted to
887         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
888         // this feature: see https://github.com/ethereum/solidity/issues/4637
889         uint256 _value; // default: 0
890     }
891 
892     function current(Counter storage counter) internal view returns (uint256) {
893         return counter._value;
894     }
895 
896     function increment(Counter storage counter) internal {
897         unchecked {
898             counter._value += 1;
899         }
900     }
901 
902     function decrement(Counter storage counter) internal {
903         uint256 value = counter._value;
904         require(value > 0, "Counter: decrement overflow");
905         unchecked {
906             counter._value = value - 1;
907         }
908     }
909 
910     function reset(Counter storage counter) internal {
911         counter._value = 0;
912     }
913 }
914 
915 /**
916  * @dev Implementation of the ERC20 Permit extension allowing approvals to be made via signatures, as defined in
917  * https://eips.ethereum.org/EIPS/eip-2612[EIP-2612].
918  *
919  * Adds the {permit} method, which can be used to change an account's ERC20 allowance (see {IERC20-allowance}) by
920  * presenting a message signed by the account. By not relying on `{IERC20-approve}`, the token holder account doesn't
921  * need to send a transaction, and thus is not required to hold Ether at all.
922  *
923  * _Available since v3.4._
924  */
925 abstract contract ERC20Permit is ERC20, IERC20Permit, EIP712 {
926     using Counters for Counters.Counter;
927 
928     mapping(address => Counters.Counter) private _nonces;
929 
930     // solhint-disable-next-line var-name-mixedcase
931     bytes32 private immutable _PERMIT_TYPEHASH =
932         keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");
933 
934     /**
935      * @dev Initializes the {EIP712} domain separator using the `name` parameter, and setting `version` to `"1"`.
936      *
937      * It's a good idea to use the same `name` that is defined as the ERC20 token name.
938      */
939     constructor(string memory name) EIP712(name, "1") {}
940 
941     /**
942      * @dev See {IERC20Permit-permit}.
943      */
944     function permit(
945         address owner,
946         address spender,
947         uint256 value,
948         uint256 deadline,
949         uint8 v,
950         bytes32 r,
951         bytes32 s
952     ) public virtual override {
953         require(block.timestamp <= deadline, "ERC20Permit: expired deadline");
954 
955         bytes32 structHash = keccak256(abi.encode(_PERMIT_TYPEHASH, owner, spender, value, _useNonce(owner), deadline));
956 
957         bytes32 hash = _hashTypedDataV4(structHash);
958 
959         address signer = ECDSA.recover(hash, v, r, s);
960         require(signer == owner, "ERC20Permit: invalid signature");
961 
962         _approve(owner, spender, value);
963     }
964 
965     /**
966      * @dev See {IERC20Permit-nonces}.
967      */
968     function nonces(address owner) public view virtual override returns (uint256) {
969         return _nonces[owner].current();
970     }
971 
972     /**
973      * @dev See {IERC20Permit-DOMAIN_SEPARATOR}.
974      */
975     // solhint-disable-next-line func-name-mixedcase
976     function DOMAIN_SEPARATOR() external view override returns (bytes32) {
977         return _domainSeparatorV4();
978     }
979 
980     /**
981      * @dev "Consume a nonce": return the current value and increment.
982      *
983      * _Available since v4.1._
984      */
985     function _useNonce(address owner) internal virtual returns (uint256 current) {
986         Counters.Counter storage nonce = _nonces[owner];
987         current = nonce.current();
988         nonce.increment();
989     }
990 }
991 
992 contract FeeToken is ERC20, ERC20Burnable, ERC20Permit {
993     constructor() ERC20("FeeToken", "FEE") ERC20Permit("FeeToken") {
994         super._mint(_msgSender(), 100_000_000 ether);
995     }
996 }