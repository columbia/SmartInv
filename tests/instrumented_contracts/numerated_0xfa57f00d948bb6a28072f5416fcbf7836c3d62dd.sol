1 // Sources flattened with hardhat v2.8.0 https://hardhat.org
2 
3 // File @openzeppelin/contracts/token/ERC20/IERC20.sol@v4.4.1
4 
5 // OpenZeppelin Contracts v4.4.1 (token/ERC20/IERC20.sol)
6 
7 pragma solidity ^0.8.0;
8 
9 /**
10  * @dev Interface of the ERC20 standard as defined in the EIP.
11  */
12 interface IERC20 {
13     /**
14      * @dev Returns the amount of tokens in existence.
15      */
16     function totalSupply() external view returns (uint256);
17 
18     /**
19      * @dev Returns the amount of tokens owned by `account`.
20      */
21     function balanceOf(address account) external view returns (uint256);
22 
23     /**
24      * @dev Moves `amount` tokens from the caller's account to `recipient`.
25      *
26      * Returns a boolean value indicating whether the operation succeeded.
27      *
28      * Emits a {Transfer} event.
29      */
30     function transfer(address recipient, uint256 amount) external returns (bool);
31 
32     /**
33      * @dev Returns the remaining number of tokens that `spender` will be
34      * allowed to spend on behalf of `owner` through {transferFrom}. This is
35      * zero by default.
36      *
37      * This value changes when {approve} or {transferFrom} are called.
38      */
39     function allowance(address owner, address spender) external view returns (uint256);
40 
41     /**
42      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
43      *
44      * Returns a boolean value indicating whether the operation succeeded.
45      *
46      * IMPORTANT: Beware that changing an allowance with this method brings the risk
47      * that someone may use both the old and the new allowance by unfortunate
48      * transaction ordering. One possible solution to mitigate this race
49      * condition is to first reduce the spender's allowance to 0 and set the
50      * desired value afterwards:
51      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
52      *
53      * Emits an {Approval} event.
54      */
55     function approve(address spender, uint256 amount) external returns (bool);
56 
57     /**
58      * @dev Moves `amount` tokens from `sender` to `recipient` using the
59      * allowance mechanism. `amount` is then deducted from the caller's
60      * allowance.
61      *
62      * Returns a boolean value indicating whether the operation succeeded.
63      *
64      * Emits a {Transfer} event.
65      */
66     function transferFrom(
67         address sender,
68         address recipient,
69         uint256 amount
70     ) external returns (bool);
71 
72     /**
73      * @dev Emitted when `value` tokens are moved from one account (`from`) to
74      * another (`to`).
75      *
76      * Note that `value` may be zero.
77      */
78     event Transfer(address indexed from, address indexed to, uint256 value);
79 
80     /**
81      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
82      * a call to {approve}. `value` is the new allowance.
83      */
84     event Approval(address indexed owner, address indexed spender, uint256 value);
85 }
86 
87 
88 // File @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol@v4.4.1
89 
90 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
91 
92 pragma solidity ^0.8.0;
93 
94 /**
95  * @dev Interface for the optional metadata functions from the ERC20 standard.
96  *
97  * _Available since v4.1._
98  */
99 interface IERC20Metadata is IERC20 {
100     /**
101      * @dev Returns the name of the token.
102      */
103     function name() external view returns (string memory);
104 
105     /**
106      * @dev Returns the symbol of the token.
107      */
108     function symbol() external view returns (string memory);
109 
110     /**
111      * @dev Returns the decimals places of the token.
112      */
113     function decimals() external view returns (uint8);
114 }
115 
116 
117 // File @openzeppelin/contracts/utils/Context.sol@v4.4.1
118 
119 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
120 
121 pragma solidity ^0.8.0;
122 
123 /**
124  * @dev Provides information about the current execution context, including the
125  * sender of the transaction and its data. While these are generally available
126  * via msg.sender and msg.data, they should not be accessed in such a direct
127  * manner, since when dealing with meta-transactions the account sending and
128  * paying for execution may not be the actual sender (as far as an application
129  * is concerned).
130  *
131  * This contract is only required for intermediate, library-like contracts.
132  */
133 abstract contract Context {
134     function _msgSender() internal view virtual returns (address) {
135         return msg.sender;
136     }
137 
138     function _msgData() internal view virtual returns (bytes calldata) {
139         return msg.data;
140     }
141 }
142 
143 
144 // File @openzeppelin/contracts/token/ERC20/ERC20.sol@v4.4.1
145 
146 // OpenZeppelin Contracts v4.4.1 (token/ERC20/ERC20.sol)
147 
148 pragma solidity ^0.8.0;
149 
150 
151 
152 /**
153  * @dev Implementation of the {IERC20} interface.
154  *
155  * This implementation is agnostic to the way tokens are created. This means
156  * that a supply mechanism has to be added in a derived contract using {_mint}.
157  * For a generic mechanism see {ERC20PresetMinterPauser}.
158  *
159  * TIP: For a detailed writeup see our guide
160  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
161  * to implement supply mechanisms].
162  *
163  * We have followed general OpenZeppelin Contracts guidelines: functions revert
164  * instead returning `false` on failure. This behavior is nonetheless
165  * conventional and does not conflict with the expectations of ERC20
166  * applications.
167  *
168  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
169  * This allows applications to reconstruct the allowance for all accounts just
170  * by listening to said events. Other implementations of the EIP may not emit
171  * these events, as it isn't required by the specification.
172  *
173  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
174  * functions have been added to mitigate the well-known issues around setting
175  * allowances. See {IERC20-approve}.
176  */
177 contract ERC20 is Context, IERC20, IERC20Metadata {
178     mapping(address => uint256) private _balances;
179 
180     mapping(address => mapping(address => uint256)) private _allowances;
181 
182     uint256 private _totalSupply;
183 
184     string private _name;
185     string private _symbol;
186 
187     /**
188      * @dev Sets the values for {name} and {symbol}.
189      *
190      * The default value of {decimals} is 18. To select a different value for
191      * {decimals} you should overload it.
192      *
193      * All two of these values are immutable: they can only be set once during
194      * construction.
195      */
196     constructor(string memory name_, string memory symbol_) {
197         _name = name_;
198         _symbol = symbol_;
199     }
200 
201     /**
202      * @dev Returns the name of the token.
203      */
204     function name() public view virtual override returns (string memory) {
205         return _name;
206     }
207 
208     /**
209      * @dev Returns the symbol of the token, usually a shorter version of the
210      * name.
211      */
212     function symbol() public view virtual override returns (string memory) {
213         return _symbol;
214     }
215 
216     /**
217      * @dev Returns the number of decimals used to get its user representation.
218      * For example, if `decimals` equals `2`, a balance of `505` tokens should
219      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
220      *
221      * Tokens usually opt for a value of 18, imitating the relationship between
222      * Ether and Wei. This is the value {ERC20} uses, unless this function is
223      * overridden;
224      *
225      * NOTE: This information is only used for _display_ purposes: it in
226      * no way affects any of the arithmetic of the contract, including
227      * {IERC20-balanceOf} and {IERC20-transfer}.
228      */
229     function decimals() public view virtual override returns (uint8) {
230         return 18;
231     }
232 
233     /**
234      * @dev See {IERC20-totalSupply}.
235      */
236     function totalSupply() public view virtual override returns (uint256) {
237         return _totalSupply;
238     }
239 
240     /**
241      * @dev See {IERC20-balanceOf}.
242      */
243     function balanceOf(address account) public view virtual override returns (uint256) {
244         return _balances[account];
245     }
246 
247     /**
248      * @dev See {IERC20-transfer}.
249      *
250      * Requirements:
251      *
252      * - `recipient` cannot be the zero address.
253      * - the caller must have a balance of at least `amount`.
254      */
255     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
256         _transfer(_msgSender(), recipient, amount);
257         return true;
258     }
259 
260     /**
261      * @dev See {IERC20-allowance}.
262      */
263     function allowance(address owner, address spender) public view virtual override returns (uint256) {
264         return _allowances[owner][spender];
265     }
266 
267     /**
268      * @dev See {IERC20-approve}.
269      *
270      * Requirements:
271      *
272      * - `spender` cannot be the zero address.
273      */
274     function approve(address spender, uint256 amount) public virtual override returns (bool) {
275         _approve(_msgSender(), spender, amount);
276         return true;
277     }
278 
279     /**
280      * @dev See {IERC20-transferFrom}.
281      *
282      * Emits an {Approval} event indicating the updated allowance. This is not
283      * required by the EIP. See the note at the beginning of {ERC20}.
284      *
285      * Requirements:
286      *
287      * - `sender` and `recipient` cannot be the zero address.
288      * - `sender` must have a balance of at least `amount`.
289      * - the caller must have allowance for ``sender``'s tokens of at least
290      * `amount`.
291      */
292     function transferFrom(
293         address sender,
294         address recipient,
295         uint256 amount
296     ) public virtual override returns (bool) {
297         _transfer(sender, recipient, amount);
298 
299         uint256 currentAllowance = _allowances[sender][_msgSender()];
300         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
301         unchecked {
302             _approve(sender, _msgSender(), currentAllowance - amount);
303         }
304 
305         return true;
306     }
307 
308     /**
309      * @dev Atomically increases the allowance granted to `spender` by the caller.
310      *
311      * This is an alternative to {approve} that can be used as a mitigation for
312      * problems described in {IERC20-approve}.
313      *
314      * Emits an {Approval} event indicating the updated allowance.
315      *
316      * Requirements:
317      *
318      * - `spender` cannot be the zero address.
319      */
320     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
321         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
322         return true;
323     }
324 
325     /**
326      * @dev Atomically decreases the allowance granted to `spender` by the caller.
327      *
328      * This is an alternative to {approve} that can be used as a mitigation for
329      * problems described in {IERC20-approve}.
330      *
331      * Emits an {Approval} event indicating the updated allowance.
332      *
333      * Requirements:
334      *
335      * - `spender` cannot be the zero address.
336      * - `spender` must have allowance for the caller of at least
337      * `subtractedValue`.
338      */
339     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
340         uint256 currentAllowance = _allowances[_msgSender()][spender];
341         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
342         unchecked {
343             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
344         }
345 
346         return true;
347     }
348 
349     /**
350      * @dev Moves `amount` of tokens from `sender` to `recipient`.
351      *
352      * This internal function is equivalent to {transfer}, and can be used to
353      * e.g. implement automatic token fees, slashing mechanisms, etc.
354      *
355      * Emits a {Transfer} event.
356      *
357      * Requirements:
358      *
359      * - `sender` cannot be the zero address.
360      * - `recipient` cannot be the zero address.
361      * - `sender` must have a balance of at least `amount`.
362      */
363     function _transfer(
364         address sender,
365         address recipient,
366         uint256 amount
367     ) internal virtual {
368         require(sender != address(0), "ERC20: transfer from the zero address");
369         require(recipient != address(0), "ERC20: transfer to the zero address");
370 
371         _beforeTokenTransfer(sender, recipient, amount);
372 
373         uint256 senderBalance = _balances[sender];
374         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
375         unchecked {
376             _balances[sender] = senderBalance - amount;
377         }
378         _balances[recipient] += amount;
379 
380         emit Transfer(sender, recipient, amount);
381 
382         _afterTokenTransfer(sender, recipient, amount);
383     }
384 
385     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
386      * the total supply.
387      *
388      * Emits a {Transfer} event with `from` set to the zero address.
389      *
390      * Requirements:
391      *
392      * - `account` cannot be the zero address.
393      */
394     function _mint(address account, uint256 amount) internal virtual {
395         require(account != address(0), "ERC20: mint to the zero address");
396 
397         _beforeTokenTransfer(address(0), account, amount);
398 
399         _totalSupply += amount;
400         _balances[account] += amount;
401         emit Transfer(address(0), account, amount);
402 
403         _afterTokenTransfer(address(0), account, amount);
404     }
405 
406     /**
407      * @dev Destroys `amount` tokens from `account`, reducing the
408      * total supply.
409      *
410      * Emits a {Transfer} event with `to` set to the zero address.
411      *
412      * Requirements:
413      *
414      * - `account` cannot be the zero address.
415      * - `account` must have at least `amount` tokens.
416      */
417     function _burn(address account, uint256 amount) internal virtual {
418         require(account != address(0), "ERC20: burn from the zero address");
419 
420         _beforeTokenTransfer(account, address(0), amount);
421 
422         uint256 accountBalance = _balances[account];
423         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
424         unchecked {
425             _balances[account] = accountBalance - amount;
426         }
427         _totalSupply -= amount;
428 
429         emit Transfer(account, address(0), amount);
430 
431         _afterTokenTransfer(account, address(0), amount);
432     }
433 
434     /**
435      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
436      *
437      * This internal function is equivalent to `approve`, and can be used to
438      * e.g. set automatic allowances for certain subsystems, etc.
439      *
440      * Emits an {Approval} event.
441      *
442      * Requirements:
443      *
444      * - `owner` cannot be the zero address.
445      * - `spender` cannot be the zero address.
446      */
447     function _approve(
448         address owner,
449         address spender,
450         uint256 amount
451     ) internal virtual {
452         require(owner != address(0), "ERC20: approve from the zero address");
453         require(spender != address(0), "ERC20: approve to the zero address");
454 
455         _allowances[owner][spender] = amount;
456         emit Approval(owner, spender, amount);
457     }
458 
459     /**
460      * @dev Hook that is called before any transfer of tokens. This includes
461      * minting and burning.
462      *
463      * Calling conditions:
464      *
465      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
466      * will be transferred to `to`.
467      * - when `from` is zero, `amount` tokens will be minted for `to`.
468      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
469      * - `from` and `to` are never both zero.
470      *
471      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
472      */
473     function _beforeTokenTransfer(
474         address from,
475         address to,
476         uint256 amount
477     ) internal virtual {}
478 
479     /**
480      * @dev Hook that is called after any transfer of tokens. This includes
481      * minting and burning.
482      *
483      * Calling conditions:
484      *
485      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
486      * has been transferred to `to`.
487      * - when `from` is zero, `amount` tokens have been minted for `to`.
488      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
489      * - `from` and `to` are never both zero.
490      *
491      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
492      */
493     function _afterTokenTransfer(
494         address from,
495         address to,
496         uint256 amount
497     ) internal virtual {}
498 }
499 
500 
501 // File @openzeppelin/contracts/token/ERC20/extensions/draft-IERC20Permit.sol@v4.4.1
502 
503 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/draft-IERC20Permit.sol)
504 
505 pragma solidity ^0.8.0;
506 
507 /**
508  * @dev Interface of the ERC20 Permit extension allowing approvals to be made via signatures, as defined in
509  * https://eips.ethereum.org/EIPS/eip-2612[EIP-2612].
510  *
511  * Adds the {permit} method, which can be used to change an account's ERC20 allowance (see {IERC20-allowance}) by
512  * presenting a message signed by the account. By not relying on {IERC20-approve}, the token holder account doesn't
513  * need to send a transaction, and thus is not required to hold Ether at all.
514  */
515 interface IERC20Permit {
516     /**
517      * @dev Sets `value` as the allowance of `spender` over ``owner``'s tokens,
518      * given ``owner``'s signed approval.
519      *
520      * IMPORTANT: The same issues {IERC20-approve} has related to transaction
521      * ordering also apply here.
522      *
523      * Emits an {Approval} event.
524      *
525      * Requirements:
526      *
527      * - `spender` cannot be the zero address.
528      * - `deadline` must be a timestamp in the future.
529      * - `v`, `r` and `s` must be a valid `secp256k1` signature from `owner`
530      * over the EIP712-formatted function arguments.
531      * - the signature must use ``owner``'s current nonce (see {nonces}).
532      *
533      * For more information on the signature format, see the
534      * https://eips.ethereum.org/EIPS/eip-2612#specification[relevant EIP
535      * section].
536      */
537     function permit(
538         address owner,
539         address spender,
540         uint256 value,
541         uint256 deadline,
542         uint8 v,
543         bytes32 r,
544         bytes32 s
545     ) external;
546 
547     /**
548      * @dev Returns the current nonce for `owner`. This value must be
549      * included whenever a signature is generated for {permit}.
550      *
551      * Every successful call to {permit} increases ``owner``'s nonce by one. This
552      * prevents a signature from being used multiple times.
553      */
554     function nonces(address owner) external view returns (uint256);
555 
556     /**
557      * @dev Returns the domain separator used in the encoding of the signature for {permit}, as defined by {EIP712}.
558      */
559     // solhint-disable-next-line func-name-mixedcase
560     function DOMAIN_SEPARATOR() external view returns (bytes32);
561 }
562 
563 
564 // File @openzeppelin/contracts/utils/Strings.sol@v4.4.1
565 
566 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
567 
568 pragma solidity ^0.8.0;
569 
570 /**
571  * @dev String operations.
572  */
573 library Strings {
574     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
575 
576     /**
577      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
578      */
579     function toString(uint256 value) internal pure returns (string memory) {
580         // Inspired by OraclizeAPI's implementation - MIT licence
581         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
582 
583         if (value == 0) {
584             return "0";
585         }
586         uint256 temp = value;
587         uint256 digits;
588         while (temp != 0) {
589             digits++;
590             temp /= 10;
591         }
592         bytes memory buffer = new bytes(digits);
593         while (value != 0) {
594             digits -= 1;
595             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
596             value /= 10;
597         }
598         return string(buffer);
599     }
600 
601     /**
602      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
603      */
604     function toHexString(uint256 value) internal pure returns (string memory) {
605         if (value == 0) {
606             return "0x00";
607         }
608         uint256 temp = value;
609         uint256 length = 0;
610         while (temp != 0) {
611             length++;
612             temp >>= 8;
613         }
614         return toHexString(value, length);
615     }
616 
617     /**
618      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
619      */
620     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
621         bytes memory buffer = new bytes(2 * length + 2);
622         buffer[0] = "0";
623         buffer[1] = "x";
624         for (uint256 i = 2 * length + 1; i > 1; --i) {
625             buffer[i] = _HEX_SYMBOLS[value & 0xf];
626             value >>= 4;
627         }
628         require(value == 0, "Strings: hex length insufficient");
629         return string(buffer);
630     }
631 }
632 
633 
634 // File @openzeppelin/contracts/utils/cryptography/ECDSA.sol@v4.4.1
635 
636 // OpenZeppelin Contracts v4.4.1 (utils/cryptography/ECDSA.sol)
637 
638 pragma solidity ^0.8.0;
639 
640 /**
641  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
642  *
643  * These functions can be used to verify that a message was signed by the holder
644  * of the private keys of a given address.
645  */
646 library ECDSA {
647     enum RecoverError {
648         NoError,
649         InvalidSignature,
650         InvalidSignatureLength,
651         InvalidSignatureS,
652         InvalidSignatureV
653     }
654 
655     function _throwError(RecoverError error) private pure {
656         if (error == RecoverError.NoError) {
657             return; // no error: do nothing
658         } else if (error == RecoverError.InvalidSignature) {
659             revert("ECDSA: invalid signature");
660         } else if (error == RecoverError.InvalidSignatureLength) {
661             revert("ECDSA: invalid signature length");
662         } else if (error == RecoverError.InvalidSignatureS) {
663             revert("ECDSA: invalid signature 's' value");
664         } else if (error == RecoverError.InvalidSignatureV) {
665             revert("ECDSA: invalid signature 'v' value");
666         }
667     }
668 
669     /**
670      * @dev Returns the address that signed a hashed message (`hash`) with
671      * `signature` or error string. This address can then be used for verification purposes.
672      *
673      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
674      * this function rejects them by requiring the `s` value to be in the lower
675      * half order, and the `v` value to be either 27 or 28.
676      *
677      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
678      * verification to be secure: it is possible to craft signatures that
679      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
680      * this is by receiving a hash of the original message (which may otherwise
681      * be too long), and then calling {toEthSignedMessageHash} on it.
682      *
683      * Documentation for signature generation:
684      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
685      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
686      *
687      * _Available since v4.3._
688      */
689     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
690         // Check the signature length
691         // - case 65: r,s,v signature (standard)
692         // - case 64: r,vs signature (cf https://eips.ethereum.org/EIPS/eip-2098) _Available since v4.1._
693         if (signature.length == 65) {
694             bytes32 r;
695             bytes32 s;
696             uint8 v;
697             // ecrecover takes the signature parameters, and the only way to get them
698             // currently is to use assembly.
699             assembly {
700                 r := mload(add(signature, 0x20))
701                 s := mload(add(signature, 0x40))
702                 v := byte(0, mload(add(signature, 0x60)))
703             }
704             return tryRecover(hash, v, r, s);
705         } else if (signature.length == 64) {
706             bytes32 r;
707             bytes32 vs;
708             // ecrecover takes the signature parameters, and the only way to get them
709             // currently is to use assembly.
710             assembly {
711                 r := mload(add(signature, 0x20))
712                 vs := mload(add(signature, 0x40))
713             }
714             return tryRecover(hash, r, vs);
715         } else {
716             return (address(0), RecoverError.InvalidSignatureLength);
717         }
718     }
719 
720     /**
721      * @dev Returns the address that signed a hashed message (`hash`) with
722      * `signature`. This address can then be used for verification purposes.
723      *
724      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
725      * this function rejects them by requiring the `s` value to be in the lower
726      * half order, and the `v` value to be either 27 or 28.
727      *
728      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
729      * verification to be secure: it is possible to craft signatures that
730      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
731      * this is by receiving a hash of the original message (which may otherwise
732      * be too long), and then calling {toEthSignedMessageHash} on it.
733      */
734     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
735         (address recovered, RecoverError error) = tryRecover(hash, signature);
736         _throwError(error);
737         return recovered;
738     }
739 
740     /**
741      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
742      *
743      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
744      *
745      * _Available since v4.3._
746      */
747     function tryRecover(
748         bytes32 hash,
749         bytes32 r,
750         bytes32 vs
751     ) internal pure returns (address, RecoverError) {
752         bytes32 s;
753         uint8 v;
754         assembly {
755             s := and(vs, 0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff)
756             v := add(shr(255, vs), 27)
757         }
758         return tryRecover(hash, v, r, s);
759     }
760 
761     /**
762      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
763      *
764      * _Available since v4.2._
765      */
766     function recover(
767         bytes32 hash,
768         bytes32 r,
769         bytes32 vs
770     ) internal pure returns (address) {
771         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
772         _throwError(error);
773         return recovered;
774     }
775 
776     /**
777      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
778      * `r` and `s` signature fields separately.
779      *
780      * _Available since v4.3._
781      */
782     function tryRecover(
783         bytes32 hash,
784         uint8 v,
785         bytes32 r,
786         bytes32 s
787     ) internal pure returns (address, RecoverError) {
788         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
789         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
790         // the valid range for s in (301): 0 < s < secp256k1n ├╖ 2 + 1, and for v in (302): v Γêê {27, 28}. Most
791         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
792         //
793         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
794         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
795         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
796         // these malleable signatures as well.
797         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
798             return (address(0), RecoverError.InvalidSignatureS);
799         }
800         if (v != 27 && v != 28) {
801             return (address(0), RecoverError.InvalidSignatureV);
802         }
803 
804         // If the signature is valid (and not malleable), return the signer address
805         address signer = ecrecover(hash, v, r, s);
806         if (signer == address(0)) {
807             return (address(0), RecoverError.InvalidSignature);
808         }
809 
810         return (signer, RecoverError.NoError);
811     }
812 
813     /**
814      * @dev Overload of {ECDSA-recover} that receives the `v`,
815      * `r` and `s` signature fields separately.
816      */
817     function recover(
818         bytes32 hash,
819         uint8 v,
820         bytes32 r,
821         bytes32 s
822     ) internal pure returns (address) {
823         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
824         _throwError(error);
825         return recovered;
826     }
827 
828     /**
829      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
830      * produces hash corresponding to the one signed with the
831      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
832      * JSON-RPC method as part of EIP-191.
833      *
834      * See {recover}.
835      */
836     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
837         // 32 is the length in bytes of hash,
838         // enforced by the type signature above
839         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
840     }
841 
842     /**
843      * @dev Returns an Ethereum Signed Message, created from `s`. This
844      * produces hash corresponding to the one signed with the
845      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
846      * JSON-RPC method as part of EIP-191.
847      *
848      * See {recover}.
849      */
850     function toEthSignedMessageHash(bytes memory s) internal pure returns (bytes32) {
851         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n", Strings.toString(s.length), s));
852     }
853 
854     /**
855      * @dev Returns an Ethereum Signed Typed Data, created from a
856      * `domainSeparator` and a `structHash`. This produces hash corresponding
857      * to the one signed with the
858      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
859      * JSON-RPC method as part of EIP-712.
860      *
861      * See {recover}.
862      */
863     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
864         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
865     }
866 }
867 
868 
869 // File @openzeppelin/contracts/utils/cryptography/draft-EIP712.sol@v4.4.1
870 
871 // OpenZeppelin Contracts v4.4.1 (utils/cryptography/draft-EIP712.sol)
872 
873 pragma solidity ^0.8.0;
874 
875 /**
876  * @dev https://eips.ethereum.org/EIPS/eip-712[EIP 712] is a standard for hashing and signing of typed structured data.
877  *
878  * The encoding specified in the EIP is very generic, and such a generic implementation in Solidity is not feasible,
879  * thus this contract does not implement the encoding itself. Protocols need to implement the type-specific encoding
880  * they need in their contracts using a combination of `abi.encode` and `keccak256`.
881  *
882  * This contract implements the EIP 712 domain separator ({_domainSeparatorV4}) that is used as part of the encoding
883  * scheme, and the final step of the encoding to obtain the message digest that is then signed via ECDSA
884  * ({_hashTypedDataV4}).
885  *
886  * The implementation of the domain separator was designed to be as efficient as possible while still properly updating
887  * the chain id to protect against replay attacks on an eventual fork of the chain.
888  *
889  * NOTE: This contract implements the version of the encoding known as "v4", as implemented by the JSON RPC method
890  * https://docs.metamask.io/guide/signing-data.html[`eth_signTypedDataV4` in MetaMask].
891  *
892  * _Available since v3.4._
893  */
894 abstract contract EIP712 {
895     /* solhint-disable var-name-mixedcase */
896     // Cache the domain separator as an immutable value, but also store the chain id that it corresponds to, in order to
897     // invalidate the cached domain separator if the chain id changes.
898     bytes32 private immutable _CACHED_DOMAIN_SEPARATOR;
899     uint256 private immutable _CACHED_CHAIN_ID;
900     address private immutable _CACHED_THIS;
901 
902     bytes32 private immutable _HASHED_NAME;
903     bytes32 private immutable _HASHED_VERSION;
904     bytes32 private immutable _TYPE_HASH;
905 
906     /* solhint-enable var-name-mixedcase */
907 
908     /**
909      * @dev Initializes the domain separator and parameter caches.
910      *
911      * The meaning of `name` and `version` is specified in
912      * https://eips.ethereum.org/EIPS/eip-712#definition-of-domainseparator[EIP 712]:
913      *
914      * - `name`: the user readable name of the signing domain, i.e. the name of the DApp or the protocol.
915      * - `version`: the current major version of the signing domain.
916      *
917      * NOTE: These parameters cannot be changed except through a xref:learn::upgrading-smart-contracts.adoc[smart
918      * contract upgrade].
919      */
920     constructor(string memory name, string memory version) {
921         bytes32 hashedName = keccak256(bytes(name));
922         bytes32 hashedVersion = keccak256(bytes(version));
923         bytes32 typeHash = keccak256(
924             "EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"
925         );
926         _HASHED_NAME = hashedName;
927         _HASHED_VERSION = hashedVersion;
928         _CACHED_CHAIN_ID = block.chainid;
929         _CACHED_DOMAIN_SEPARATOR = _buildDomainSeparator(typeHash, hashedName, hashedVersion);
930         _CACHED_THIS = address(this);
931         _TYPE_HASH = typeHash;
932     }
933 
934     /**
935      * @dev Returns the domain separator for the current chain.
936      */
937     function _domainSeparatorV4() internal view returns (bytes32) {
938         if (address(this) == _CACHED_THIS && block.chainid == _CACHED_CHAIN_ID) {
939             return _CACHED_DOMAIN_SEPARATOR;
940         } else {
941             return _buildDomainSeparator(_TYPE_HASH, _HASHED_NAME, _HASHED_VERSION);
942         }
943     }
944 
945     function _buildDomainSeparator(
946         bytes32 typeHash,
947         bytes32 nameHash,
948         bytes32 versionHash
949     ) private view returns (bytes32) {
950         return keccak256(abi.encode(typeHash, nameHash, versionHash, block.chainid, address(this)));
951     }
952 
953     /**
954      * @dev Given an already https://eips.ethereum.org/EIPS/eip-712#definition-of-hashstruct[hashed struct], this
955      * function returns the hash of the fully encoded EIP712 message for this domain.
956      *
957      * This hash can be used together with {ECDSA-recover} to obtain the signer of a message. For example:
958      *
959      * ```solidity
960      * bytes32 digest = _hashTypedDataV4(keccak256(abi.encode(
961      *     keccak256("Mail(address to,string contents)"),
962      *     mailTo,
963      *     keccak256(bytes(mailContents))
964      * )));
965      * address signer = ECDSA.recover(digest, signature);
966      * ```
967      */
968     function _hashTypedDataV4(bytes32 structHash) internal view virtual returns (bytes32) {
969         return ECDSA.toTypedDataHash(_domainSeparatorV4(), structHash);
970     }
971 }
972 
973 
974 // File @openzeppelin/contracts/utils/Counters.sol@v4.4.1
975 
976 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
977 
978 pragma solidity ^0.8.0;
979 
980 /**
981  * @title Counters
982  * @author Matt Condon (@shrugs)
983  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
984  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
985  *
986  * Include with `using Counters for Counters.Counter;`
987  */
988 library Counters {
989     struct Counter {
990         // This variable should never be directly accessed by users of the library: interactions must be restricted to
991         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
992         // this feature: see https://github.com/ethereum/solidity/issues/4637
993         uint256 _value; // default: 0
994     }
995 
996     function current(Counter storage counter) internal view returns (uint256) {
997         return counter._value;
998     }
999 
1000     function increment(Counter storage counter) internal {
1001         unchecked {
1002             counter._value += 1;
1003         }
1004     }
1005 
1006     function decrement(Counter storage counter) internal {
1007         uint256 value = counter._value;
1008         require(value > 0, "Counter: decrement overflow");
1009         unchecked {
1010             counter._value = value - 1;
1011         }
1012     }
1013 
1014     function reset(Counter storage counter) internal {
1015         counter._value = 0;
1016     }
1017 }
1018 
1019 
1020 // File @openzeppelin/contracts/token/ERC20/extensions/draft-ERC20Permit.sol@v4.4.1
1021 
1022 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/draft-ERC20Permit.sol)
1023 
1024 pragma solidity ^0.8.0;
1025 
1026 
1027 
1028 
1029 
1030 /**
1031  * @dev Implementation of the ERC20 Permit extension allowing approvals to be made via signatures, as defined in
1032  * https://eips.ethereum.org/EIPS/eip-2612[EIP-2612].
1033  *
1034  * Adds the {permit} method, which can be used to change an account's ERC20 allowance (see {IERC20-allowance}) by
1035  * presenting a message signed by the account. By not relying on `{IERC20-approve}`, the token holder account doesn't
1036  * need to send a transaction, and thus is not required to hold Ether at all.
1037  *
1038  * _Available since v3.4._
1039  */
1040 abstract contract ERC20Permit is ERC20, IERC20Permit, EIP712 {
1041     using Counters for Counters.Counter;
1042 
1043     mapping(address => Counters.Counter) private _nonces;
1044 
1045     // solhint-disable-next-line var-name-mixedcase
1046     bytes32 private immutable _PERMIT_TYPEHASH =
1047         keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");
1048 
1049     /**
1050      * @dev Initializes the {EIP712} domain separator using the `name` parameter, and setting `version` to `"1"`.
1051      *
1052      * It's a good idea to use the same `name` that is defined as the ERC20 token name.
1053      */
1054     constructor(string memory name) EIP712(name, "1") {}
1055 
1056     /**
1057      * @dev See {IERC20Permit-permit}.
1058      */
1059     function permit(
1060         address owner,
1061         address spender,
1062         uint256 value,
1063         uint256 deadline,
1064         uint8 v,
1065         bytes32 r,
1066         bytes32 s
1067     ) public virtual override {
1068         require(block.timestamp <= deadline, "ERC20Permit: expired deadline");
1069 
1070         bytes32 structHash = keccak256(abi.encode(_PERMIT_TYPEHASH, owner, spender, value, _useNonce(owner), deadline));
1071 
1072         bytes32 hash = _hashTypedDataV4(structHash);
1073 
1074         address signer = ECDSA.recover(hash, v, r, s);
1075         require(signer == owner, "ERC20Permit: invalid signature");
1076 
1077         _approve(owner, spender, value);
1078     }
1079 
1080     /**
1081      * @dev See {IERC20Permit-nonces}.
1082      */
1083     function nonces(address owner) public view virtual override returns (uint256) {
1084         return _nonces[owner].current();
1085     }
1086 
1087     /**
1088      * @dev See {IERC20Permit-DOMAIN_SEPARATOR}.
1089      */
1090     // solhint-disable-next-line func-name-mixedcase
1091     function DOMAIN_SEPARATOR() external view override returns (bytes32) {
1092         return _domainSeparatorV4();
1093     }
1094 
1095     /**
1096      * @dev "Consume a nonce": return the current value and increment.
1097      *
1098      * _Available since v4.1._
1099      */
1100     function _useNonce(address owner) internal virtual returns (uint256 current) {
1101         Counters.Counter storage nonce = _nonces[owner];
1102         current = nonce.current();
1103         nonce.increment();
1104     }
1105 }
1106 
1107 
1108 // File @openzeppelin/contracts/utils/math/Math.sol@v4.4.1
1109 
1110 // OpenZeppelin Contracts v4.4.1 (utils/math/Math.sol)
1111 
1112 pragma solidity ^0.8.0;
1113 
1114 /**
1115  * @dev Standard math utilities missing in the Solidity language.
1116  */
1117 library Math {
1118     /**
1119      * @dev Returns the largest of two numbers.
1120      */
1121     function max(uint256 a, uint256 b) internal pure returns (uint256) {
1122         return a >= b ? a : b;
1123     }
1124 
1125     /**
1126      * @dev Returns the smallest of two numbers.
1127      */
1128     function min(uint256 a, uint256 b) internal pure returns (uint256) {
1129         return a < b ? a : b;
1130     }
1131 
1132     /**
1133      * @dev Returns the average of two numbers. The result is rounded towards
1134      * zero.
1135      */
1136     function average(uint256 a, uint256 b) internal pure returns (uint256) {
1137         // (a + b) / 2 can overflow.
1138         return (a & b) + (a ^ b) / 2;
1139     }
1140 
1141     /**
1142      * @dev Returns the ceiling of the division of two numbers.
1143      *
1144      * This differs from standard division with `/` in that it rounds up instead
1145      * of rounding down.
1146      */
1147     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
1148         // (a + b - 1) / b can overflow on addition, so we distribute.
1149         return a / b + (a % b == 0 ? 0 : 1);
1150     }
1151 }
1152 
1153 
1154 // File @openzeppelin/contracts/utils/math/SafeCast.sol@v4.4.1
1155 
1156 // OpenZeppelin Contracts v4.4.1 (utils/math/SafeCast.sol)
1157 
1158 pragma solidity ^0.8.0;
1159 
1160 /**
1161  * @dev Wrappers over Solidity's uintXX/intXX casting operators with added overflow
1162  * checks.
1163  *
1164  * Downcasting from uint256/int256 in Solidity does not revert on overflow. This can
1165  * easily result in undesired exploitation or bugs, since developers usually
1166  * assume that overflows raise errors. `SafeCast` restores this intuition by
1167  * reverting the transaction when such an operation overflows.
1168  *
1169  * Using this library instead of the unchecked operations eliminates an entire
1170  * class of bugs, so it's recommended to use it always.
1171  *
1172  * Can be combined with {SafeMath} and {SignedSafeMath} to extend it to smaller types, by performing
1173  * all math on `uint256` and `int256` and then downcasting.
1174  */
1175 library SafeCast {
1176     /**
1177      * @dev Returns the downcasted uint224 from uint256, reverting on
1178      * overflow (when the input is greater than largest uint224).
1179      *
1180      * Counterpart to Solidity's `uint224` operator.
1181      *
1182      * Requirements:
1183      *
1184      * - input must fit into 224 bits
1185      */
1186     function toUint224(uint256 value) internal pure returns (uint224) {
1187         require(value <= type(uint224).max, "SafeCast: value doesn't fit in 224 bits");
1188         return uint224(value);
1189     }
1190 
1191     /**
1192      * @dev Returns the downcasted uint128 from uint256, reverting on
1193      * overflow (when the input is greater than largest uint128).
1194      *
1195      * Counterpart to Solidity's `uint128` operator.
1196      *
1197      * Requirements:
1198      *
1199      * - input must fit into 128 bits
1200      */
1201     function toUint128(uint256 value) internal pure returns (uint128) {
1202         require(value <= type(uint128).max, "SafeCast: value doesn't fit in 128 bits");
1203         return uint128(value);
1204     }
1205 
1206     /**
1207      * @dev Returns the downcasted uint96 from uint256, reverting on
1208      * overflow (when the input is greater than largest uint96).
1209      *
1210      * Counterpart to Solidity's `uint96` operator.
1211      *
1212      * Requirements:
1213      *
1214      * - input must fit into 96 bits
1215      */
1216     function toUint96(uint256 value) internal pure returns (uint96) {
1217         require(value <= type(uint96).max, "SafeCast: value doesn't fit in 96 bits");
1218         return uint96(value);
1219     }
1220 
1221     /**
1222      * @dev Returns the downcasted uint64 from uint256, reverting on
1223      * overflow (when the input is greater than largest uint64).
1224      *
1225      * Counterpart to Solidity's `uint64` operator.
1226      *
1227      * Requirements:
1228      *
1229      * - input must fit into 64 bits
1230      */
1231     function toUint64(uint256 value) internal pure returns (uint64) {
1232         require(value <= type(uint64).max, "SafeCast: value doesn't fit in 64 bits");
1233         return uint64(value);
1234     }
1235 
1236     /**
1237      * @dev Returns the downcasted uint32 from uint256, reverting on
1238      * overflow (when the input is greater than largest uint32).
1239      *
1240      * Counterpart to Solidity's `uint32` operator.
1241      *
1242      * Requirements:
1243      *
1244      * - input must fit into 32 bits
1245      */
1246     function toUint32(uint256 value) internal pure returns (uint32) {
1247         require(value <= type(uint32).max, "SafeCast: value doesn't fit in 32 bits");
1248         return uint32(value);
1249     }
1250 
1251     /**
1252      * @dev Returns the downcasted uint16 from uint256, reverting on
1253      * overflow (when the input is greater than largest uint16).
1254      *
1255      * Counterpart to Solidity's `uint16` operator.
1256      *
1257      * Requirements:
1258      *
1259      * - input must fit into 16 bits
1260      */
1261     function toUint16(uint256 value) internal pure returns (uint16) {
1262         require(value <= type(uint16).max, "SafeCast: value doesn't fit in 16 bits");
1263         return uint16(value);
1264     }
1265 
1266     /**
1267      * @dev Returns the downcasted uint8 from uint256, reverting on
1268      * overflow (when the input is greater than largest uint8).
1269      *
1270      * Counterpart to Solidity's `uint8` operator.
1271      *
1272      * Requirements:
1273      *
1274      * - input must fit into 8 bits.
1275      */
1276     function toUint8(uint256 value) internal pure returns (uint8) {
1277         require(value <= type(uint8).max, "SafeCast: value doesn't fit in 8 bits");
1278         return uint8(value);
1279     }
1280 
1281     /**
1282      * @dev Converts a signed int256 into an unsigned uint256.
1283      *
1284      * Requirements:
1285      *
1286      * - input must be greater than or equal to 0.
1287      */
1288     function toUint256(int256 value) internal pure returns (uint256) {
1289         require(value >= 0, "SafeCast: value must be positive");
1290         return uint256(value);
1291     }
1292 
1293     /**
1294      * @dev Returns the downcasted int128 from int256, reverting on
1295      * overflow (when the input is less than smallest int128 or
1296      * greater than largest int128).
1297      *
1298      * Counterpart to Solidity's `int128` operator.
1299      *
1300      * Requirements:
1301      *
1302      * - input must fit into 128 bits
1303      *
1304      * _Available since v3.1._
1305      */
1306     function toInt128(int256 value) internal pure returns (int128) {
1307         require(value >= type(int128).min && value <= type(int128).max, "SafeCast: value doesn't fit in 128 bits");
1308         return int128(value);
1309     }
1310 
1311     /**
1312      * @dev Returns the downcasted int64 from int256, reverting on
1313      * overflow (when the input is less than smallest int64 or
1314      * greater than largest int64).
1315      *
1316      * Counterpart to Solidity's `int64` operator.
1317      *
1318      * Requirements:
1319      *
1320      * - input must fit into 64 bits
1321      *
1322      * _Available since v3.1._
1323      */
1324     function toInt64(int256 value) internal pure returns (int64) {
1325         require(value >= type(int64).min && value <= type(int64).max, "SafeCast: value doesn't fit in 64 bits");
1326         return int64(value);
1327     }
1328 
1329     /**
1330      * @dev Returns the downcasted int32 from int256, reverting on
1331      * overflow (when the input is less than smallest int32 or
1332      * greater than largest int32).
1333      *
1334      * Counterpart to Solidity's `int32` operator.
1335      *
1336      * Requirements:
1337      *
1338      * - input must fit into 32 bits
1339      *
1340      * _Available since v3.1._
1341      */
1342     function toInt32(int256 value) internal pure returns (int32) {
1343         require(value >= type(int32).min && value <= type(int32).max, "SafeCast: value doesn't fit in 32 bits");
1344         return int32(value);
1345     }
1346 
1347     /**
1348      * @dev Returns the downcasted int16 from int256, reverting on
1349      * overflow (when the input is less than smallest int16 or
1350      * greater than largest int16).
1351      *
1352      * Counterpart to Solidity's `int16` operator.
1353      *
1354      * Requirements:
1355      *
1356      * - input must fit into 16 bits
1357      *
1358      * _Available since v3.1._
1359      */
1360     function toInt16(int256 value) internal pure returns (int16) {
1361         require(value >= type(int16).min && value <= type(int16).max, "SafeCast: value doesn't fit in 16 bits");
1362         return int16(value);
1363     }
1364 
1365     /**
1366      * @dev Returns the downcasted int8 from int256, reverting on
1367      * overflow (when the input is less than smallest int8 or
1368      * greater than largest int8).
1369      *
1370      * Counterpart to Solidity's `int8` operator.
1371      *
1372      * Requirements:
1373      *
1374      * - input must fit into 8 bits.
1375      *
1376      * _Available since v3.1._
1377      */
1378     function toInt8(int256 value) internal pure returns (int8) {
1379         require(value >= type(int8).min && value <= type(int8).max, "SafeCast: value doesn't fit in 8 bits");
1380         return int8(value);
1381     }
1382 
1383     /**
1384      * @dev Converts an unsigned uint256 into a signed int256.
1385      *
1386      * Requirements:
1387      *
1388      * - input must be less than or equal to maxInt256.
1389      */
1390     function toInt256(uint256 value) internal pure returns (int256) {
1391         // Note: Unsafe cast below is okay because `type(int256).max` is guaranteed to be positive
1392         require(value <= uint256(type(int256).max), "SafeCast: value doesn't fit in an int256");
1393         return int256(value);
1394     }
1395 }
1396 
1397 
1398 // File @openzeppelin/contracts/token/ERC20/extensions/ERC20Votes.sol@v4.4.1
1399 
1400 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/ERC20Votes.sol)
1401 
1402 pragma solidity ^0.8.0;
1403 
1404 
1405 
1406 
1407 /**
1408  * @dev Extension of ERC20 to support Compound-like voting and delegation. This version is more generic than Compound's,
1409  * and supports token supply up to 2^224^ - 1, while COMP is limited to 2^96^ - 1.
1410  *
1411  * NOTE: If exact COMP compatibility is required, use the {ERC20VotesComp} variant of this module.
1412  *
1413  * This extension keeps a history (checkpoints) of each account's vote power. Vote power can be delegated either
1414  * by calling the {delegate} function directly, or by providing a signature to be used with {delegateBySig}. Voting
1415  * power can be queried through the public accessors {getVotes} and {getPastVotes}.
1416  *
1417  * By default, token balance does not account for voting power. This makes transfers cheaper. The downside is that it
1418  * requires users to delegate to themselves in order to activate checkpoints and have their voting power tracked.
1419  * Enabling self-delegation can easily be done by overriding the {delegates} function. Keep in mind however that this
1420  * will significantly increase the base gas cost of transfers.
1421  *
1422  * _Available since v4.2._
1423  */
1424 abstract contract ERC20Votes is ERC20Permit {
1425     struct Checkpoint {
1426         uint32 fromBlock;
1427         uint224 votes;
1428     }
1429 
1430     bytes32 private constant _DELEGATION_TYPEHASH =
1431         keccak256("Delegation(address delegatee,uint256 nonce,uint256 expiry)");
1432 
1433     mapping(address => address) private _delegates;
1434     mapping(address => Checkpoint[]) private _checkpoints;
1435     Checkpoint[] private _totalSupplyCheckpoints;
1436 
1437     /**
1438      * @dev Emitted when an account changes their delegate.
1439      */
1440     event DelegateChanged(address indexed delegator, address indexed fromDelegate, address indexed toDelegate);
1441 
1442     /**
1443      * @dev Emitted when a token transfer or delegate change results in changes to an account's voting power.
1444      */
1445     event DelegateVotesChanged(address indexed delegate, uint256 previousBalance, uint256 newBalance);
1446 
1447     /**
1448      * @dev Get the `pos`-th checkpoint for `account`.
1449      */
1450     function checkpoints(address account, uint32 pos) public view virtual returns (Checkpoint memory) {
1451         return _checkpoints[account][pos];
1452     }
1453 
1454     /**
1455      * @dev Get number of checkpoints for `account`.
1456      */
1457     function numCheckpoints(address account) public view virtual returns (uint32) {
1458         return SafeCast.toUint32(_checkpoints[account].length);
1459     }
1460 
1461     /**
1462      * @dev Get the address `account` is currently delegating to.
1463      */
1464     function delegates(address account) public view virtual returns (address) {
1465         return _delegates[account];
1466     }
1467 
1468     /**
1469      * @dev Gets the current votes balance for `account`
1470      */
1471     function getVotes(address account) public view returns (uint256) {
1472         uint256 pos = _checkpoints[account].length;
1473         return pos == 0 ? 0 : _checkpoints[account][pos - 1].votes;
1474     }
1475 
1476     /**
1477      * @dev Retrieve the number of votes for `account` at the end of `blockNumber`.
1478      *
1479      * Requirements:
1480      *
1481      * - `blockNumber` must have been already mined
1482      */
1483     function getPastVotes(address account, uint256 blockNumber) public view returns (uint256) {
1484         require(blockNumber < block.number, "ERC20Votes: block not yet mined");
1485         return _checkpointsLookup(_checkpoints[account], blockNumber);
1486     }
1487 
1488     /**
1489      * @dev Retrieve the `totalSupply` at the end of `blockNumber`. Note, this value is the sum of all balances.
1490      * It is but NOT the sum of all the delegated votes!
1491      *
1492      * Requirements:
1493      *
1494      * - `blockNumber` must have been already mined
1495      */
1496     function getPastTotalSupply(uint256 blockNumber) public view returns (uint256) {
1497         require(blockNumber < block.number, "ERC20Votes: block not yet mined");
1498         return _checkpointsLookup(_totalSupplyCheckpoints, blockNumber);
1499     }
1500 
1501     /**
1502      * @dev Lookup a value in a list of (sorted) checkpoints.
1503      */
1504     function _checkpointsLookup(Checkpoint[] storage ckpts, uint256 blockNumber) private view returns (uint256) {
1505         // We run a binary search to look for the earliest checkpoint taken after `blockNumber`.
1506         //
1507         // During the loop, the index of the wanted checkpoint remains in the range [low-1, high).
1508         // With each iteration, either `low` or `high` is moved towards the middle of the range to maintain the invariant.
1509         // - If the middle checkpoint is after `blockNumber`, we look in [low, mid)
1510         // - If the middle checkpoint is before or equal to `blockNumber`, we look in [mid+1, high)
1511         // Once we reach a single value (when low == high), we've found the right checkpoint at the index high-1, if not
1512         // out of bounds (in which case we're looking too far in the past and the result is 0).
1513         // Note that if the latest checkpoint available is exactly for `blockNumber`, we end up with an index that is
1514         // past the end of the array, so we technically don't find a checkpoint after `blockNumber`, but it works out
1515         // the same.
1516         uint256 high = ckpts.length;
1517         uint256 low = 0;
1518         while (low < high) {
1519             uint256 mid = Math.average(low, high);
1520             if (ckpts[mid].fromBlock > blockNumber) {
1521                 high = mid;
1522             } else {
1523                 low = mid + 1;
1524             }
1525         }
1526 
1527         return high == 0 ? 0 : ckpts[high - 1].votes;
1528     }
1529 
1530     /**
1531      * @dev Delegate votes from the sender to `delegatee`.
1532      */
1533     function delegate(address delegatee) public virtual {
1534         _delegate(_msgSender(), delegatee);
1535     }
1536 
1537     /**
1538      * @dev Delegates votes from signer to `delegatee`
1539      */
1540     function delegateBySig(
1541         address delegatee,
1542         uint256 nonce,
1543         uint256 expiry,
1544         uint8 v,
1545         bytes32 r,
1546         bytes32 s
1547     ) public virtual {
1548         require(block.timestamp <= expiry, "ERC20Votes: signature expired");
1549         address signer = ECDSA.recover(
1550             _hashTypedDataV4(keccak256(abi.encode(_DELEGATION_TYPEHASH, delegatee, nonce, expiry))),
1551             v,
1552             r,
1553             s
1554         );
1555         require(nonce == _useNonce(signer), "ERC20Votes: invalid nonce");
1556         _delegate(signer, delegatee);
1557     }
1558 
1559     /**
1560      * @dev Maximum token supply. Defaults to `type(uint224).max` (2^224^ - 1).
1561      */
1562     function _maxSupply() internal view virtual returns (uint224) {
1563         return type(uint224).max;
1564     }
1565 
1566     /**
1567      * @dev Snapshots the totalSupply after it has been increased.
1568      */
1569     function _mint(address account, uint256 amount) internal virtual override {
1570         super._mint(account, amount);
1571         require(totalSupply() <= _maxSupply(), "ERC20Votes: total supply risks overflowing votes");
1572 
1573         _writeCheckpoint(_totalSupplyCheckpoints, _add, amount);
1574     }
1575 
1576     /**
1577      * @dev Snapshots the totalSupply after it has been decreased.
1578      */
1579     function _burn(address account, uint256 amount) internal virtual override {
1580         super._burn(account, amount);
1581 
1582         _writeCheckpoint(_totalSupplyCheckpoints, _subtract, amount);
1583     }
1584 
1585     /**
1586      * @dev Move voting power when tokens are transferred.
1587      *
1588      * Emits a {DelegateVotesChanged} event.
1589      */
1590     function _afterTokenTransfer(
1591         address from,
1592         address to,
1593         uint256 amount
1594     ) internal virtual override {
1595         super._afterTokenTransfer(from, to, amount);
1596 
1597         _moveVotingPower(delegates(from), delegates(to), amount);
1598     }
1599 
1600     /**
1601      * @dev Change delegation for `delegator` to `delegatee`.
1602      *
1603      * Emits events {DelegateChanged} and {DelegateVotesChanged}.
1604      */
1605     function _delegate(address delegator, address delegatee) internal virtual {
1606         address currentDelegate = delegates(delegator);
1607         uint256 delegatorBalance = balanceOf(delegator);
1608         _delegates[delegator] = delegatee;
1609 
1610         emit DelegateChanged(delegator, currentDelegate, delegatee);
1611 
1612         _moveVotingPower(currentDelegate, delegatee, delegatorBalance);
1613     }
1614 
1615     function _moveVotingPower(
1616         address src,
1617         address dst,
1618         uint256 amount
1619     ) private {
1620         if (src != dst && amount > 0) {
1621             if (src != address(0)) {
1622                 (uint256 oldWeight, uint256 newWeight) = _writeCheckpoint(_checkpoints[src], _subtract, amount);
1623                 emit DelegateVotesChanged(src, oldWeight, newWeight);
1624             }
1625 
1626             if (dst != address(0)) {
1627                 (uint256 oldWeight, uint256 newWeight) = _writeCheckpoint(_checkpoints[dst], _add, amount);
1628                 emit DelegateVotesChanged(dst, oldWeight, newWeight);
1629             }
1630         }
1631     }
1632 
1633     function _writeCheckpoint(
1634         Checkpoint[] storage ckpts,
1635         function(uint256, uint256) view returns (uint256) op,
1636         uint256 delta
1637     ) private returns (uint256 oldWeight, uint256 newWeight) {
1638         uint256 pos = ckpts.length;
1639         oldWeight = pos == 0 ? 0 : ckpts[pos - 1].votes;
1640         newWeight = op(oldWeight, delta);
1641 
1642         if (pos > 0 && ckpts[pos - 1].fromBlock == block.number) {
1643             ckpts[pos - 1].votes = SafeCast.toUint224(newWeight);
1644         } else {
1645             ckpts.push(Checkpoint({fromBlock: SafeCast.toUint32(block.number), votes: SafeCast.toUint224(newWeight)}));
1646         }
1647     }
1648 
1649     function _add(uint256 a, uint256 b) private pure returns (uint256) {
1650         return a + b;
1651     }
1652 
1653     function _subtract(uint256 a, uint256 b) private pure returns (uint256) {
1654         return a - b;
1655     }
1656 }
1657 
1658 
1659 // File @openzeppelin/contracts/access/Ownable.sol@v4.4.1
1660 
1661 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1662 
1663 pragma solidity ^0.8.0;
1664 
1665 /**
1666  * @dev Contract module which provides a basic access control mechanism, where
1667  * there is an account (an owner) that can be granted exclusive access to
1668  * specific functions.
1669  *
1670  * By default, the owner account will be the one that deploys the contract. This
1671  * can later be changed with {transferOwnership}.
1672  *
1673  * This module is used through inheritance. It will make available the modifier
1674  * `onlyOwner`, which can be applied to your functions to restrict their use to
1675  * the owner.
1676  */
1677 abstract contract Ownable is Context {
1678     address private _owner;
1679 
1680     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1681 
1682     /**
1683      * @dev Initializes the contract setting the deployer as the initial owner.
1684      */
1685     constructor() {
1686         _transferOwnership(_msgSender());
1687     }
1688 
1689     /**
1690      * @dev Returns the address of the current owner.
1691      */
1692     function owner() public view virtual returns (address) {
1693         return _owner;
1694     }
1695 
1696     /**
1697      * @dev Throws if called by any account other than the owner.
1698      */
1699     modifier onlyOwner() {
1700         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1701         _;
1702     }
1703 
1704     /**
1705      * @dev Leaves the contract without owner. It will not be possible to call
1706      * `onlyOwner` functions anymore. Can only be called by the current owner.
1707      *
1708      * NOTE: Renouncing ownership will leave the contract without an owner,
1709      * thereby removing any functionality that is only available to the owner.
1710      */
1711     function renounceOwnership() public virtual onlyOwner {
1712         _transferOwnership(address(0));
1713     }
1714 
1715     /**
1716      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1717      * Can only be called by the current owner.
1718      */
1719     function transferOwnership(address newOwner) public virtual onlyOwner {
1720         require(newOwner != address(0), "Ownable: new owner is the zero address");
1721         _transferOwnership(newOwner);
1722     }
1723 
1724     /**
1725      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1726      * Internal function without access restriction.
1727      */
1728     function _transferOwnership(address newOwner) internal virtual {
1729         address oldOwner = _owner;
1730         _owner = newOwner;
1731         emit OwnershipTransferred(oldOwner, newOwner);
1732     }
1733 }
1734 
1735 
1736 // File contracts/token.sol
1737 
1738 // SPDX-License-Identifier: Apache-2.0
1739 
1740 /*
1741 
1742   /$$$$$$          /$$                     /$$$$$$$   /$$$$$$   /$$$$$$ 
1743  /$$__  $$        |__/                    | $$__  $$ /$$__  $$ /$$__  $$
1744 | $$  \__//$$$$$$  /$$  /$$$$$$   /$$$$$$$| $$  \ $$| $$  \ $$| $$  \ $$
1745 | $$$$   /$$__  $$| $$ /$$__  $$ /$$_____/| $$  | $$| $$$$$$$$| $$  | $$
1746 | $$_/  | $$  \__/| $$| $$$$$$$$|  $$$$$$ | $$  | $$| $$__  $$| $$  | $$
1747 | $$    | $$      | $$| $$_____/ \____  $$| $$  | $$| $$  | $$| $$  | $$
1748 | $$    | $$      | $$|  $$$$$$$ /$$$$$$$/| $$$$$$$/| $$  | $$|  $$$$$$/
1749 |__/    |__/      |__/ \_______/|_______/ |_______/ |__/  |__/ \______/ 
1750 
1751 */
1752 
1753 pragma solidity ^0.8.7;
1754 contract Administrable is Ownable {
1755 
1756     mapping (address => bool) public admins;
1757 
1758     event AdminAdded(address added);
1759     event AdminRemoved(address removed);
1760 
1761     // Only allow an admin to call a function
1762 
1763     modifier onlyAdmin {
1764         require(admins[_msgSender()] || owner() == _msgSender(), "Administrable: caller is not an admin");
1765         _;
1766     }
1767 
1768     // Set an account as an admin
1769 
1770     function addAdmin(address admin) external onlyOwner {
1771         require(!admins[admin], "Administrable: address is already an admin");
1772         admins[admin] = true;
1773         emit AdminAdded(admin);
1774     }
1775 
1776     // Remove an admin from admins
1777 
1778     function removeAdmin(address admin) external onlyOwner {
1779         require(admins[admin], "Administrable: address is not an admin");
1780         delete admins[admin];
1781         emit AdminRemoved(admin);
1782     }
1783 
1784 }
1785 
1786 contract FriesDAOToken is ERC20Votes, Administrable {
1787 
1788     constructor() ERC20("friesDAO", "FRIES") ERC20Permit("FRIES") {
1789     }
1790 
1791     // Mint amount of FRIES to account
1792 
1793     function mint(address account, uint256 amount) external onlyAdmin {
1794         _mint(account, amount);
1795     }
1796 
1797     // Burn FRIES from caller
1798 
1799     function burn(uint256 amount) external {
1800         _burn(_msgSender(), amount);
1801     }
1802 
1803     // Burn FRIES from account with approval
1804 
1805     function burnFrom(address account, uint256 amount) external {
1806         uint256 currentAllowance = allowance(account, _msgSender());
1807         require(currentAllowance >= amount, "ERC20: burn amount exceeds allowance");
1808         unchecked {
1809             _approve(account, _msgSender(), currentAllowance - amount);
1810         }
1811         _burn(account, amount);
1812     }
1813 
1814 }