1 // Dependency file: @openzeppelin/contracts/token/ERC20/IERC20.sol
2 
3 // SPDX-License-Identifier: MIT
4 // OpenZeppelin Contracts v4.4.0 (token/ERC20/IERC20.sol)
5 
6 // pragma solidity ^0.8.0;
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
87 // Dependency file: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
88 
89 // OpenZeppelin Contracts v4.4.0 (token/ERC20/extensions/IERC20Metadata.sol)
90 
91 // pragma solidity ^0.8.0;
92 
93 // import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
94 
95 /**
96  * @dev Interface for the optional metadata functions from the ERC20 standard.
97  *
98  * _Available since v4.1._
99  */
100 interface IERC20Metadata is IERC20 {
101     /**
102      * @dev Returns the name of the token.
103      */
104     function name() external view returns (string memory);
105 
106     /**
107      * @dev Returns the symbol of the token.
108      */
109     function symbol() external view returns (string memory);
110 
111     /**
112      * @dev Returns the decimals places of the token.
113      */
114     function decimals() external view returns (uint8);
115 }
116 
117 
118 // Dependency file: @openzeppelin/contracts/utils/Context.sol
119 
120 // OpenZeppelin Contracts v4.4.0 (utils/Context.sol)
121 
122 // pragma solidity ^0.8.0;
123 
124 /**
125  * @dev Provides information about the current execution context, including the
126  * sender of the transaction and its data. While these are generally available
127  * via msg.sender and msg.data, they should not be accessed in such a direct
128  * manner, since when dealing with meta-transactions the account sending and
129  * paying for execution may not be the actual sender (as far as an application
130  * is concerned).
131  *
132  * This contract is only required for intermediate, library-like contracts.
133  */
134 abstract contract Context {
135     function _msgSender() internal view virtual returns (address) {
136         return msg.sender;
137     }
138 
139     function _msgData() internal view virtual returns (bytes calldata) {
140         return msg.data;
141     }
142 }
143 
144 
145 // Dependency file: @openzeppelin/contracts/token/ERC20/ERC20.sol
146 
147 // OpenZeppelin Contracts v4.4.0 (token/ERC20/ERC20.sol)
148 
149 // pragma solidity ^0.8.0;
150 
151 // import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
152 // import "@openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol";
153 // import "@openzeppelin/contracts/utils/Context.sol";
154 
155 /**
156  * @dev Implementation of the {IERC20} interface.
157  *
158  * This implementation is agnostic to the way tokens are created. This means
159  * that a supply mechanism has to be added in a derived contract using {_mint}.
160  * For a generic mechanism see {ERC20PresetMinterPauser}.
161  *
162  * TIP: For a detailed writeup see our guide
163  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
164  * to implement supply mechanisms].
165  *
166  * We have followed general OpenZeppelin Contracts guidelines: functions revert
167  * instead returning `false` on failure. This behavior is nonetheless
168  * conventional and does not conflict with the expectations of ERC20
169  * applications.
170  *
171  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
172  * This allows applications to reconstruct the allowance for all accounts just
173  * by listening to said events. Other implementations of the EIP may not emit
174  * these events, as it isn't required by the specification.
175  *
176  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
177  * functions have been added to mitigate the well-known issues around setting
178  * allowances. See {IERC20-approve}.
179  */
180 contract ERC20 is Context, IERC20, IERC20Metadata {
181     mapping(address => uint256) private _balances;
182 
183     mapping(address => mapping(address => uint256)) private _allowances;
184 
185     uint256 private _totalSupply;
186 
187     string private _name;
188     string private _symbol;
189 
190     /**
191      * @dev Sets the values for {name} and {symbol}.
192      *
193      * The default value of {decimals} is 18. To select a different value for
194      * {decimals} you should overload it.
195      *
196      * All two of these values are immutable: they can only be set once during
197      * construction.
198      */
199     constructor(string memory name_, string memory symbol_) {
200         _name = name_;
201         _symbol = symbol_;
202     }
203 
204     /**
205      * @dev Returns the name of the token.
206      */
207     function name() public view virtual override returns (string memory) {
208         return _name;
209     }
210 
211     /**
212      * @dev Returns the symbol of the token, usually a shorter version of the
213      * name.
214      */
215     function symbol() public view virtual override returns (string memory) {
216         return _symbol;
217     }
218 
219     /**
220      * @dev Returns the number of decimals used to get its user representation.
221      * For example, if `decimals` equals `2`, a balance of `505` tokens should
222      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
223      *
224      * Tokens usually opt for a value of 18, imitating the relationship between
225      * Ether and Wei. This is the value {ERC20} uses, unless this function is
226      * overridden;
227      *
228      * NOTE: This information is only used for _display_ purposes: it in
229      * no way affects any of the arithmetic of the contract, including
230      * {IERC20-balanceOf} and {IERC20-transfer}.
231      */
232     function decimals() public view virtual override returns (uint8) {
233         return 18;
234     }
235 
236     /**
237      * @dev See {IERC20-totalSupply}.
238      */
239     function totalSupply() public view virtual override returns (uint256) {
240         return _totalSupply;
241     }
242 
243     /**
244      * @dev See {IERC20-balanceOf}.
245      */
246     function balanceOf(address account) public view virtual override returns (uint256) {
247         return _balances[account];
248     }
249 
250     /**
251      * @dev See {IERC20-transfer}.
252      *
253      * Requirements:
254      *
255      * - `recipient` cannot be the zero address.
256      * - the caller must have a balance of at least `amount`.
257      */
258     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
259         _transfer(_msgSender(), recipient, amount);
260         return true;
261     }
262 
263     /**
264      * @dev See {IERC20-allowance}.
265      */
266     function allowance(address owner, address spender) public view virtual override returns (uint256) {
267         return _allowances[owner][spender];
268     }
269 
270     /**
271      * @dev See {IERC20-approve}.
272      *
273      * Requirements:
274      *
275      * - `spender` cannot be the zero address.
276      */
277     function approve(address spender, uint256 amount) public virtual override returns (bool) {
278         _approve(_msgSender(), spender, amount);
279         return true;
280     }
281 
282     /**
283      * @dev See {IERC20-transferFrom}.
284      *
285      * Emits an {Approval} event indicating the updated allowance. This is not
286      * required by the EIP. See the note at the beginning of {ERC20}.
287      *
288      * Requirements:
289      *
290      * - `sender` and `recipient` cannot be the zero address.
291      * - `sender` must have a balance of at least `amount`.
292      * - the caller must have allowance for ``sender``'s tokens of at least
293      * `amount`.
294      */
295     function transferFrom(
296         address sender,
297         address recipient,
298         uint256 amount
299     ) public virtual override returns (bool) {
300         _transfer(sender, recipient, amount);
301 
302         uint256 currentAllowance = _allowances[sender][_msgSender()];
303         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
304         unchecked {
305             _approve(sender, _msgSender(), currentAllowance - amount);
306         }
307 
308         return true;
309     }
310 
311     /**
312      * @dev Atomically increases the allowance granted to `spender` by the caller.
313      *
314      * This is an alternative to {approve} that can be used as a mitigation for
315      * problems described in {IERC20-approve}.
316      *
317      * Emits an {Approval} event indicating the updated allowance.
318      *
319      * Requirements:
320      *
321      * - `spender` cannot be the zero address.
322      */
323     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
324         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
325         return true;
326     }
327 
328     /**
329      * @dev Atomically decreases the allowance granted to `spender` by the caller.
330      *
331      * This is an alternative to {approve} that can be used as a mitigation for
332      * problems described in {IERC20-approve}.
333      *
334      * Emits an {Approval} event indicating the updated allowance.
335      *
336      * Requirements:
337      *
338      * - `spender` cannot be the zero address.
339      * - `spender` must have allowance for the caller of at least
340      * `subtractedValue`.
341      */
342     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
343         uint256 currentAllowance = _allowances[_msgSender()][spender];
344         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
345         unchecked {
346             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
347         }
348 
349         return true;
350     }
351 
352     /**
353      * @dev Moves `amount` of tokens from `sender` to `recipient`.
354      *
355      * This internal function is equivalent to {transfer}, and can be used to
356      * e.g. implement automatic token fees, slashing mechanisms, etc.
357      *
358      * Emits a {Transfer} event.
359      *
360      * Requirements:
361      *
362      * - `sender` cannot be the zero address.
363      * - `recipient` cannot be the zero address.
364      * - `sender` must have a balance of at least `amount`.
365      */
366     function _transfer(
367         address sender,
368         address recipient,
369         uint256 amount
370     ) internal virtual {
371         require(sender != address(0), "ERC20: transfer from the zero address");
372         require(recipient != address(0), "ERC20: transfer to the zero address");
373 
374         _beforeTokenTransfer(sender, recipient, amount);
375 
376         uint256 senderBalance = _balances[sender];
377         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
378         unchecked {
379             _balances[sender] = senderBalance - amount;
380         }
381         _balances[recipient] += amount;
382 
383         emit Transfer(sender, recipient, amount);
384 
385         _afterTokenTransfer(sender, recipient, amount);
386     }
387 
388     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
389      * the total supply.
390      *
391      * Emits a {Transfer} event with `from` set to the zero address.
392      *
393      * Requirements:
394      *
395      * - `account` cannot be the zero address.
396      */
397     function _mint(address account, uint256 amount) internal virtual {
398         require(account != address(0), "ERC20: mint to the zero address");
399 
400         _beforeTokenTransfer(address(0), account, amount);
401 
402         _totalSupply += amount;
403         _balances[account] += amount;
404         emit Transfer(address(0), account, amount);
405 
406         _afterTokenTransfer(address(0), account, amount);
407     }
408 
409     /**
410      * @dev Destroys `amount` tokens from `account`, reducing the
411      * total supply.
412      *
413      * Emits a {Transfer} event with `to` set to the zero address.
414      *
415      * Requirements:
416      *
417      * - `account` cannot be the zero address.
418      * - `account` must have at least `amount` tokens.
419      */
420     function _burn(address account, uint256 amount) internal virtual {
421         require(account != address(0), "ERC20: burn from the zero address");
422 
423         _beforeTokenTransfer(account, address(0), amount);
424 
425         uint256 accountBalance = _balances[account];
426         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
427         unchecked {
428             _balances[account] = accountBalance - amount;
429         }
430         _totalSupply -= amount;
431 
432         emit Transfer(account, address(0), amount);
433 
434         _afterTokenTransfer(account, address(0), amount);
435     }
436 
437     /**
438      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
439      *
440      * This internal function is equivalent to `approve`, and can be used to
441      * e.g. set automatic allowances for certain subsystems, etc.
442      *
443      * Emits an {Approval} event.
444      *
445      * Requirements:
446      *
447      * - `owner` cannot be the zero address.
448      * - `spender` cannot be the zero address.
449      */
450     function _approve(
451         address owner,
452         address spender,
453         uint256 amount
454     ) internal virtual {
455         require(owner != address(0), "ERC20: approve from the zero address");
456         require(spender != address(0), "ERC20: approve to the zero address");
457 
458         _allowances[owner][spender] = amount;
459         emit Approval(owner, spender, amount);
460     }
461 
462     /**
463      * @dev Hook that is called before any transfer of tokens. This includes
464      * minting and burning.
465      *
466      * Calling conditions:
467      *
468      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
469      * will be transferred to `to`.
470      * - when `from` is zero, `amount` tokens will be minted for `to`.
471      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
472      * - `from` and `to` are never both zero.
473      *
474      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
475      */
476     function _beforeTokenTransfer(
477         address from,
478         address to,
479         uint256 amount
480     ) internal virtual {}
481 
482     /**
483      * @dev Hook that is called after any transfer of tokens. This includes
484      * minting and burning.
485      *
486      * Calling conditions:
487      *
488      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
489      * has been transferred to `to`.
490      * - when `from` is zero, `amount` tokens have been minted for `to`.
491      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
492      * - `from` and `to` are never both zero.
493      *
494      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
495      */
496     function _afterTokenTransfer(
497         address from,
498         address to,
499         uint256 amount
500     ) internal virtual {}
501 }
502 
503 
504 // Dependency file: @openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol
505 
506 // OpenZeppelin Contracts v4.4.0 (token/ERC20/extensions/ERC20Burnable.sol)
507 
508 // pragma solidity ^0.8.0;
509 
510 // import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
511 // import "@openzeppelin/contracts/utils/Context.sol";
512 
513 /**
514  * @dev Extension of {ERC20} that allows token holders to destroy both their own
515  * tokens and those that they have an allowance for, in a way that can be
516  * recognized off-chain (via event analysis).
517  */
518 abstract contract ERC20Burnable is Context, ERC20 {
519     /**
520      * @dev Destroys `amount` tokens from the caller.
521      *
522      * See {ERC20-_burn}.
523      */
524     function burn(uint256 amount) public virtual {
525         _burn(_msgSender(), amount);
526     }
527 
528     /**
529      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
530      * allowance.
531      *
532      * See {ERC20-_burn} and {ERC20-allowance}.
533      *
534      * Requirements:
535      *
536      * - the caller must have allowance for ``accounts``'s tokens of at least
537      * `amount`.
538      */
539     function burnFrom(address account, uint256 amount) public virtual {
540         uint256 currentAllowance = allowance(account, _msgSender());
541         require(currentAllowance >= amount, "ERC20: burn amount exceeds allowance");
542         unchecked {
543             _approve(account, _msgSender(), currentAllowance - amount);
544         }
545         _burn(account, amount);
546     }
547 }
548 
549 
550 // Dependency file: @openzeppelin/contracts/token/ERC20/extensions/draft-IERC20Permit.sol
551 
552 // OpenZeppelin Contracts v4.4.0 (token/ERC20/extensions/draft-IERC20Permit.sol)
553 
554 // pragma solidity ^0.8.0;
555 
556 /**
557  * @dev Interface of the ERC20 Permit extension allowing approvals to be made via signatures, as defined in
558  * https://eips.ethereum.org/EIPS/eip-2612[EIP-2612].
559  *
560  * Adds the {permit} method, which can be used to change an account's ERC20 allowance (see {IERC20-allowance}) by
561  * presenting a message signed by the account. By not relying on {IERC20-approve}, the token holder account doesn't
562  * need to send a transaction, and thus is not required to hold Ether at all.
563  */
564 interface IERC20Permit {
565     /**
566      * @dev Sets `value` as the allowance of `spender` over ``owner``'s tokens,
567      * given ``owner``'s signed approval.
568      *
569      * IMPORTANT: The same issues {IERC20-approve} has related to transaction
570      * ordering also apply here.
571      *
572      * Emits an {Approval} event.
573      *
574      * Requirements:
575      *
576      * - `spender` cannot be the zero address.
577      * - `deadline` must be a timestamp in the future.
578      * - `v`, `r` and `s` must be a valid `secp256k1` signature from `owner`
579      * over the EIP712-formatted function arguments.
580      * - the signature must use ``owner``'s current nonce (see {nonces}).
581      *
582      * For more information on the signature format, see the
583      * https://eips.ethereum.org/EIPS/eip-2612#specification[relevant EIP
584      * section].
585      */
586     function permit(
587         address owner,
588         address spender,
589         uint256 value,
590         uint256 deadline,
591         uint8 v,
592         bytes32 r,
593         bytes32 s
594     ) external;
595 
596     /**
597      * @dev Returns the current nonce for `owner`. This value must be
598      * included whenever a signature is generated for {permit}.
599      *
600      * Every successful call to {permit} increases ``owner``'s nonce by one. This
601      * prevents a signature from being used multiple times.
602      */
603     function nonces(address owner) external view returns (uint256);
604 
605     /**
606      * @dev Returns the domain separator used in the encoding of the signature for {permit}, as defined by {EIP712}.
607      */
608     // solhint-disable-next-line func-name-mixedcase
609     function DOMAIN_SEPARATOR() external view returns (bytes32);
610 }
611 
612 
613 // Dependency file: @openzeppelin/contracts/utils/Strings.sol
614 
615 // OpenZeppelin Contracts v4.4.0 (utils/Strings.sol)
616 
617 // pragma solidity ^0.8.0;
618 
619 /**
620  * @dev String operations.
621  */
622 library Strings {
623     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
624 
625     /**
626      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
627      */
628     function toString(uint256 value) internal pure returns (string memory) {
629         // Inspired by OraclizeAPI's implementation - MIT licence
630         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
631 
632         if (value == 0) {
633             return "0";
634         }
635         uint256 temp = value;
636         uint256 digits;
637         while (temp != 0) {
638             digits++;
639             temp /= 10;
640         }
641         bytes memory buffer = new bytes(digits);
642         while (value != 0) {
643             digits -= 1;
644             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
645             value /= 10;
646         }
647         return string(buffer);
648     }
649 
650     /**
651      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
652      */
653     function toHexString(uint256 value) internal pure returns (string memory) {
654         if (value == 0) {
655             return "0x00";
656         }
657         uint256 temp = value;
658         uint256 length = 0;
659         while (temp != 0) {
660             length++;
661             temp >>= 8;
662         }
663         return toHexString(value, length);
664     }
665 
666     /**
667      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
668      */
669     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
670         bytes memory buffer = new bytes(2 * length + 2);
671         buffer[0] = "0";
672         buffer[1] = "x";
673         for (uint256 i = 2 * length + 1; i > 1; --i) {
674             buffer[i] = _HEX_SYMBOLS[value & 0xf];
675             value >>= 4;
676         }
677         require(value == 0, "Strings: hex length insufficient");
678         return string(buffer);
679     }
680 }
681 
682 
683 // Dependency file: @openzeppelin/contracts/utils/cryptography/ECDSA.sol
684 
685 // OpenZeppelin Contracts v4.4.0 (utils/cryptography/ECDSA.sol)
686 
687 // pragma solidity ^0.8.0;
688 
689 // import "@openzeppelin/contracts/utils/Strings.sol";
690 
691 /**
692  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
693  *
694  * These functions can be used to verify that a message was signed by the holder
695  * of the private keys of a given address.
696  */
697 library ECDSA {
698     enum RecoverError {
699         NoError,
700         InvalidSignature,
701         InvalidSignatureLength,
702         InvalidSignatureS,
703         InvalidSignatureV
704     }
705 
706     function _throwError(RecoverError error) private pure {
707         if (error == RecoverError.NoError) {
708             return; // no error: do nothing
709         } else if (error == RecoverError.InvalidSignature) {
710             revert("ECDSA: invalid signature");
711         } else if (error == RecoverError.InvalidSignatureLength) {
712             revert("ECDSA: invalid signature length");
713         } else if (error == RecoverError.InvalidSignatureS) {
714             revert("ECDSA: invalid signature 's' value");
715         } else if (error == RecoverError.InvalidSignatureV) {
716             revert("ECDSA: invalid signature 'v' value");
717         }
718     }
719 
720     /**
721      * @dev Returns the address that signed a hashed message (`hash`) with
722      * `signature` or error string. This address can then be used for verification purposes.
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
733      *
734      * Documentation for signature generation:
735      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
736      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
737      *
738      * _Available since v4.3._
739      */
740     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
741         // Check the signature length
742         // - case 65: r,s,v signature (standard)
743         // - case 64: r,vs signature (cf https://eips.ethereum.org/EIPS/eip-2098) _Available since v4.1._
744         if (signature.length == 65) {
745             bytes32 r;
746             bytes32 s;
747             uint8 v;
748             // ecrecover takes the signature parameters, and the only way to get them
749             // currently is to use assembly.
750             assembly {
751                 r := mload(add(signature, 0x20))
752                 s := mload(add(signature, 0x40))
753                 v := byte(0, mload(add(signature, 0x60)))
754             }
755             return tryRecover(hash, v, r, s);
756         } else if (signature.length == 64) {
757             bytes32 r;
758             bytes32 vs;
759             // ecrecover takes the signature parameters, and the only way to get them
760             // currently is to use assembly.
761             assembly {
762                 r := mload(add(signature, 0x20))
763                 vs := mload(add(signature, 0x40))
764             }
765             return tryRecover(hash, r, vs);
766         } else {
767             return (address(0), RecoverError.InvalidSignatureLength);
768         }
769     }
770 
771     /**
772      * @dev Returns the address that signed a hashed message (`hash`) with
773      * `signature`. This address can then be used for verification purposes.
774      *
775      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
776      * this function rejects them by requiring the `s` value to be in the lower
777      * half order, and the `v` value to be either 27 or 28.
778      *
779      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
780      * verification to be secure: it is possible to craft signatures that
781      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
782      * this is by receiving a hash of the original message (which may otherwise
783      * be too long), and then calling {toEthSignedMessageHash} on it.
784      */
785     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
786         (address recovered, RecoverError error) = tryRecover(hash, signature);
787         _throwError(error);
788         return recovered;
789     }
790 
791     /**
792      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
793      *
794      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
795      *
796      * _Available since v4.3._
797      */
798     function tryRecover(
799         bytes32 hash,
800         bytes32 r,
801         bytes32 vs
802     ) internal pure returns (address, RecoverError) {
803         bytes32 s;
804         uint8 v;
805         assembly {
806             s := and(vs, 0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff)
807             v := add(shr(255, vs), 27)
808         }
809         return tryRecover(hash, v, r, s);
810     }
811 
812     /**
813      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
814      *
815      * _Available since v4.2._
816      */
817     function recover(
818         bytes32 hash,
819         bytes32 r,
820         bytes32 vs
821     ) internal pure returns (address) {
822         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
823         _throwError(error);
824         return recovered;
825     }
826 
827     /**
828      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
829      * `r` and `s` signature fields separately.
830      *
831      * _Available since v4.3._
832      */
833     function tryRecover(
834         bytes32 hash,
835         uint8 v,
836         bytes32 r,
837         bytes32 s
838     ) internal pure returns (address, RecoverError) {
839         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
840         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
841         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
842         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
843         //
844         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
845         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
846         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
847         // these malleable signatures as well.
848         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
849             return (address(0), RecoverError.InvalidSignatureS);
850         }
851         if (v != 27 && v != 28) {
852             return (address(0), RecoverError.InvalidSignatureV);
853         }
854 
855         // If the signature is valid (and not malleable), return the signer address
856         address signer = ecrecover(hash, v, r, s);
857         if (signer == address(0)) {
858             return (address(0), RecoverError.InvalidSignature);
859         }
860 
861         return (signer, RecoverError.NoError);
862     }
863 
864     /**
865      * @dev Overload of {ECDSA-recover} that receives the `v`,
866      * `r` and `s` signature fields separately.
867      */
868     function recover(
869         bytes32 hash,
870         uint8 v,
871         bytes32 r,
872         bytes32 s
873     ) internal pure returns (address) {
874         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
875         _throwError(error);
876         return recovered;
877     }
878 
879     /**
880      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
881      * produces hash corresponding to the one signed with the
882      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
883      * JSON-RPC method as part of EIP-191.
884      *
885      * See {recover}.
886      */
887     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
888         // 32 is the length in bytes of hash,
889         // enforced by the type signature above
890         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
891     }
892 
893     /**
894      * @dev Returns an Ethereum Signed Message, created from `s`. This
895      * produces hash corresponding to the one signed with the
896      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
897      * JSON-RPC method as part of EIP-191.
898      *
899      * See {recover}.
900      */
901     function toEthSignedMessageHash(bytes memory s) internal pure returns (bytes32) {
902         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n", Strings.toString(s.length), s));
903     }
904 
905     /**
906      * @dev Returns an Ethereum Signed Typed Data, created from a
907      * `domainSeparator` and a `structHash`. This produces hash corresponding
908      * to the one signed with the
909      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
910      * JSON-RPC method as part of EIP-712.
911      *
912      * See {recover}.
913      */
914     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
915         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
916     }
917 }
918 
919 
920 // Dependency file: @openzeppelin/contracts/utils/cryptography/draft-EIP712.sol
921 
922 // OpenZeppelin Contracts v4.4.0 (utils/cryptography/draft-EIP712.sol)
923 
924 // pragma solidity ^0.8.0;
925 
926 // import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
927 
928 /**
929  * @dev https://eips.ethereum.org/EIPS/eip-712[EIP 712] is a standard for hashing and signing of typed structured data.
930  *
931  * The encoding specified in the EIP is very generic, and such a generic implementation in Solidity is not feasible,
932  * thus this contract does not implement the encoding itself. Protocols need to implement the type-specific encoding
933  * they need in their contracts using a combination of `abi.encode` and `keccak256`.
934  *
935  * This contract implements the EIP 712 domain separator ({_domainSeparatorV4}) that is used as part of the encoding
936  * scheme, and the final step of the encoding to obtain the message digest that is then signed via ECDSA
937  * ({_hashTypedDataV4}).
938  *
939  * The implementation of the domain separator was designed to be as efficient as possible while still properly updating
940  * the chain id to protect against replay attacks on an eventual fork of the chain.
941  *
942  * NOTE: This contract implements the version of the encoding known as "v4", as implemented by the JSON RPC method
943  * https://docs.metamask.io/guide/signing-data.html[`eth_signTypedDataV4` in MetaMask].
944  *
945  * _Available since v3.4._
946  */
947 abstract contract EIP712 {
948     /* solhint-disable var-name-mixedcase */
949     // Cache the domain separator as an immutable value, but also store the chain id that it corresponds to, in order to
950     // invalidate the cached domain separator if the chain id changes.
951     bytes32 private immutable _CACHED_DOMAIN_SEPARATOR;
952     uint256 private immutable _CACHED_CHAIN_ID;
953     address private immutable _CACHED_THIS;
954 
955     bytes32 private immutable _HASHED_NAME;
956     bytes32 private immutable _HASHED_VERSION;
957     bytes32 private immutable _TYPE_HASH;
958 
959     /* solhint-enable var-name-mixedcase */
960 
961     /**
962      * @dev Initializes the domain separator and parameter caches.
963      *
964      * The meaning of `name` and `version` is specified in
965      * https://eips.ethereum.org/EIPS/eip-712#definition-of-domainseparator[EIP 712]:
966      *
967      * - `name`: the user readable name of the signing domain, i.e. the name of the DApp or the protocol.
968      * - `version`: the current major version of the signing domain.
969      *
970      * NOTE: These parameters cannot be changed except through a xref:learn::upgrading-smart-contracts.adoc[smart
971      * contract upgrade].
972      */
973     constructor(string memory name, string memory version) {
974         bytes32 hashedName = keccak256(bytes(name));
975         bytes32 hashedVersion = keccak256(bytes(version));
976         bytes32 typeHash = keccak256(
977             "EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"
978         );
979         _HASHED_NAME = hashedName;
980         _HASHED_VERSION = hashedVersion;
981         _CACHED_CHAIN_ID = block.chainid;
982         _CACHED_DOMAIN_SEPARATOR = _buildDomainSeparator(typeHash, hashedName, hashedVersion);
983         _CACHED_THIS = address(this);
984         _TYPE_HASH = typeHash;
985     }
986 
987     /**
988      * @dev Returns the domain separator for the current chain.
989      */
990     function _domainSeparatorV4() internal view returns (bytes32) {
991         if (address(this) == _CACHED_THIS && block.chainid == _CACHED_CHAIN_ID) {
992             return _CACHED_DOMAIN_SEPARATOR;
993         } else {
994             return _buildDomainSeparator(_TYPE_HASH, _HASHED_NAME, _HASHED_VERSION);
995         }
996     }
997 
998     function _buildDomainSeparator(
999         bytes32 typeHash,
1000         bytes32 nameHash,
1001         bytes32 versionHash
1002     ) private view returns (bytes32) {
1003         return keccak256(abi.encode(typeHash, nameHash, versionHash, block.chainid, address(this)));
1004     }
1005 
1006     /**
1007      * @dev Given an already https://eips.ethereum.org/EIPS/eip-712#definition-of-hashstruct[hashed struct], this
1008      * function returns the hash of the fully encoded EIP712 message for this domain.
1009      *
1010      * This hash can be used together with {ECDSA-recover} to obtain the signer of a message. For example:
1011      *
1012      * ```solidity
1013      * bytes32 digest = _hashTypedDataV4(keccak256(abi.encode(
1014      *     keccak256("Mail(address to,string contents)"),
1015      *     mailTo,
1016      *     keccak256(bytes(mailContents))
1017      * )));
1018      * address signer = ECDSA.recover(digest, signature);
1019      * ```
1020      */
1021     function _hashTypedDataV4(bytes32 structHash) internal view virtual returns (bytes32) {
1022         return ECDSA.toTypedDataHash(_domainSeparatorV4(), structHash);
1023     }
1024 }
1025 
1026 
1027 // Dependency file: @openzeppelin/contracts/utils/Counters.sol
1028 
1029 // OpenZeppelin Contracts v4.4.0 (utils/Counters.sol)
1030 
1031 // pragma solidity ^0.8.0;
1032 
1033 /**
1034  * @title Counters
1035  * @author Matt Condon (@shrugs)
1036  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
1037  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
1038  *
1039  * Include with `using Counters for Counters.Counter;`
1040  */
1041 library Counters {
1042     struct Counter {
1043         // This variable should never be directly accessed by users of the library: interactions must be restricted to
1044         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
1045         // this feature: see https://github.com/ethereum/solidity/issues/4637
1046         uint256 _value; // default: 0
1047     }
1048 
1049     function current(Counter storage counter) internal view returns (uint256) {
1050         return counter._value;
1051     }
1052 
1053     function increment(Counter storage counter) internal {
1054         unchecked {
1055             counter._value += 1;
1056         }
1057     }
1058 
1059     function decrement(Counter storage counter) internal {
1060         uint256 value = counter._value;
1061         require(value > 0, "Counter: decrement overflow");
1062         unchecked {
1063             counter._value = value - 1;
1064         }
1065     }
1066 
1067     function reset(Counter storage counter) internal {
1068         counter._value = 0;
1069     }
1070 }
1071 
1072 
1073 // Dependency file: @openzeppelin/contracts/token/ERC20/extensions/draft-ERC20Permit.sol
1074 
1075 // OpenZeppelin Contracts v4.4.0 (token/ERC20/extensions/draft-ERC20Permit.sol)
1076 
1077 // pragma solidity ^0.8.0;
1078 
1079 // import "@openzeppelin/contracts/token/ERC20/extensions/draft-IERC20Permit.sol";
1080 // import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
1081 // import "@openzeppelin/contracts/utils/cryptography/draft-EIP712.sol";
1082 // import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
1083 // import "@openzeppelin/contracts/utils/Counters.sol";
1084 
1085 /**
1086  * @dev Implementation of the ERC20 Permit extension allowing approvals to be made via signatures, as defined in
1087  * https://eips.ethereum.org/EIPS/eip-2612[EIP-2612].
1088  *
1089  * Adds the {permit} method, which can be used to change an account's ERC20 allowance (see {IERC20-allowance}) by
1090  * presenting a message signed by the account. By not relying on `{IERC20-approve}`, the token holder account doesn't
1091  * need to send a transaction, and thus is not required to hold Ether at all.
1092  *
1093  * _Available since v3.4._
1094  */
1095 abstract contract ERC20Permit is ERC20, IERC20Permit, EIP712 {
1096     using Counters for Counters.Counter;
1097 
1098     mapping(address => Counters.Counter) private _nonces;
1099 
1100     // solhint-disable-next-line var-name-mixedcase
1101     bytes32 private immutable _PERMIT_TYPEHASH =
1102         keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");
1103 
1104     /**
1105      * @dev Initializes the {EIP712} domain separator using the `name` parameter, and setting `version` to `"1"`.
1106      *
1107      * It's a good idea to use the same `name` that is defined as the ERC20 token name.
1108      */
1109     constructor(string memory name) EIP712(name, "1") {}
1110 
1111     /**
1112      * @dev See {IERC20Permit-permit}.
1113      */
1114     function permit(
1115         address owner,
1116         address spender,
1117         uint256 value,
1118         uint256 deadline,
1119         uint8 v,
1120         bytes32 r,
1121         bytes32 s
1122     ) public virtual override {
1123         require(block.timestamp <= deadline, "ERC20Permit: expired deadline");
1124 
1125         bytes32 structHash = keccak256(abi.encode(_PERMIT_TYPEHASH, owner, spender, value, _useNonce(owner), deadline));
1126 
1127         bytes32 hash = _hashTypedDataV4(structHash);
1128 
1129         address signer = ECDSA.recover(hash, v, r, s);
1130         require(signer == owner, "ERC20Permit: invalid signature");
1131 
1132         _approve(owner, spender, value);
1133     }
1134 
1135     /**
1136      * @dev See {IERC20Permit-nonces}.
1137      */
1138     function nonces(address owner) public view virtual override returns (uint256) {
1139         return _nonces[owner].current();
1140     }
1141 
1142     /**
1143      * @dev See {IERC20Permit-DOMAIN_SEPARATOR}.
1144      */
1145     // solhint-disable-next-line func-name-mixedcase
1146     function DOMAIN_SEPARATOR() external view override returns (bytes32) {
1147         return _domainSeparatorV4();
1148     }
1149 
1150     /**
1151      * @dev "Consume a nonce": return the current value and increment.
1152      *
1153      * _Available since v4.1._
1154      */
1155     function _useNonce(address owner) internal virtual returns (uint256 current) {
1156         Counters.Counter storage nonce = _nonces[owner];
1157         current = nonce.current();
1158         nonce.increment();
1159     }
1160 }
1161 
1162 
1163 // Dependency file: @openzeppelin/contracts/access/Ownable.sol
1164 
1165 // OpenZeppelin Contracts v4.4.0 (access/Ownable.sol)
1166 
1167 // pragma solidity ^0.8.0;
1168 
1169 // import "@openzeppelin/contracts/utils/Context.sol";
1170 
1171 /**
1172  * @dev Contract module which provides a basic access control mechanism, where
1173  * there is an account (an owner) that can be granted exclusive access to
1174  * specific functions.
1175  *
1176  * By default, the owner account will be the one that deploys the contract. This
1177  * can later be changed with {transferOwnership}.
1178  *
1179  * This module is used through inheritance. It will make available the modifier
1180  * `onlyOwner`, which can be applied to your functions to restrict their use to
1181  * the owner.
1182  */
1183 abstract contract Ownable is Context {
1184     address private _owner;
1185 
1186     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1187 
1188     /**
1189      * @dev Initializes the contract setting the deployer as the initial owner.
1190      */
1191     constructor() {
1192         _transferOwnership(_msgSender());
1193     }
1194 
1195     /**
1196      * @dev Returns the address of the current owner.
1197      */
1198     function owner() public view virtual returns (address) {
1199         return _owner;
1200     }
1201 
1202     /**
1203      * @dev Throws if called by any account other than the owner.
1204      */
1205     modifier onlyOwner() {
1206         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1207         _;
1208     }
1209 
1210     /**
1211      * @dev Leaves the contract without owner. It will not be possible to call
1212      * `onlyOwner` functions anymore. Can only be called by the current owner.
1213      *
1214      * NOTE: Renouncing ownership will leave the contract without an owner,
1215      * thereby removing any functionality that is only available to the owner.
1216      */
1217     function renounceOwnership() public virtual onlyOwner {
1218         _transferOwnership(address(0));
1219     }
1220 
1221     /**
1222      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1223      * Can only be called by the current owner.
1224      */
1225     function transferOwnership(address newOwner) public virtual onlyOwner {
1226         require(newOwner != address(0), "Ownable: new owner is the zero address");
1227         _transferOwnership(newOwner);
1228     }
1229 
1230     /**
1231      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1232      * Internal function without access restriction.
1233      */
1234     function _transferOwnership(address newOwner) internal virtual {
1235         address oldOwner = _owner;
1236         _owner = newOwner;
1237         emit OwnershipTransferred(oldOwner, newOwner);
1238     }
1239 }
1240 
1241 
1242 // Dependency file: contracts/RecoverableErc20ByOwner.sol
1243 
1244 // pragma solidity ^0.8.0;
1245 
1246 // import "@openzeppelin/contracts/access/Ownable.sol";
1247 // import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
1248 
1249 abstract contract RecoverableErc20ByOwner is Ownable {
1250     function recoverErc20(address tokenAddress, uint256 amount, address to) external onlyOwner {
1251         uint256 recoverableAmount = _getRecoverableAmount(tokenAddress);
1252         require(amount <= recoverableAmount, "RecoverableByOwner: RECOVERABLE_AMOUNT_NOT_ENOUGH");
1253         _sendErc20(tokenAddress, amount, to);
1254     }
1255 
1256     function _getRecoverableAmount(address tokenAddress) private view returns (uint256) {
1257         return IERC20(tokenAddress).balanceOf(address(this));
1258     }
1259 
1260     function _sendErc20(address tokenAddress, uint256 amount, address to) private {
1261         // bytes4(keccak256(bytes('transfer(address,uint256)')));
1262         (bool success, bytes memory data) = tokenAddress.call(abi.encodeWithSelector(0xa9059cbb, to, amount));
1263         require(success && (data.length == 0 || abi.decode(data, (bool))), "RecoverableByOwner: ERC20_TRANSFER_FAILED");
1264     }
1265 }
1266 
1267 
1268 // Dependency file: contracts/interfaces/IRoboShort.sol
1269 
1270 // pragma solidity ^0.8.0;
1271 
1272 interface IRoboShort {
1273     function rawOwnerOf(uint256 tokenId) external view returns (address owner);
1274     function isMintedBeforeSale(uint256 tokenId) external view returns (bool);
1275     function tokenName(uint256 tokenId) external view returns (string memory);
1276 }
1277 
1278 
1279 // Root file: contracts/RNCT.sol
1280 
1281 pragma solidity ^0.8.0;
1282 
1283 // import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
1284 // import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
1285 // import "@openzeppelin/contracts/token/ERC20/extensions/draft-ERC20Permit.sol";
1286 // import "@openzeppelin/contracts/access/Ownable.sol";
1287 // import "contracts/RecoverableErc20ByOwner.sol";
1288 // import "contracts/interfaces/IRoboShort.sol";
1289 
1290 contract RNCT is Ownable, RecoverableErc20ByOwner, ERC20, ERC20Burnable, ERC20Permit {
1291     address public ROBO;
1292     uint256 public constant BONUS = 1830 ether;
1293     uint256 public constant EMISSION_START = 1645279170;
1294     uint256 public constant EMISSION_END = 1960639170;
1295     uint256 public constant EMISSION_RATE = 10 ether / uint256(86400);
1296     mapping(uint256 => uint256) private _lastClaim;
1297 
1298     constructor()
1299         ERC20("Roborovski NameChangeToken", "RNCT")
1300         ERC20Permit("Roborovski NameChangeToken")
1301     {
1302         _mint(_msgSender(), 1000000 ether);
1303     }
1304 
1305     function lastClaim(uint256 tokenId) public view returns (uint256) {
1306         require(IRoboShort(ROBO).rawOwnerOf(tokenId) != address(0), "RNCT: owner cannot be zero address");
1307 
1308         uint256 lastClaimed = uint256(_lastClaim[tokenId]) != 0
1309             ? uint256(_lastClaim[tokenId])
1310             : EMISSION_START;
1311         return lastClaimed;
1312     }
1313 
1314     function accumulated(uint256 tokenId) public view returns (uint256) {
1315         uint256 lastClaimed = lastClaim(tokenId);
1316         if (lastClaimed >= EMISSION_END)
1317             return 0;
1318 
1319         uint256 accumulationPeriod = block.timestamp < EMISSION_END
1320             ? block.timestamp
1321             : EMISSION_END;
1322         uint256 total = EMISSION_RATE * (accumulationPeriod - lastClaimed);
1323 
1324         if (lastClaimed == EMISSION_START) {
1325             uint256 bonus = IRoboShort(ROBO).isMintedBeforeSale(tokenId) == true
1326                 ? BONUS
1327                 : 0;
1328             total = total + bonus;
1329         }
1330 
1331         return total;
1332     }
1333 
1334     function accumulatedBatch(uint256[] memory tokenIds) public view returns (uint256) {
1335         uint256 total = 0;
1336         for (uint256 i = 0; i < tokenIds.length; i++) {
1337             for (uint256 j = i + 1; j < tokenIds.length; j++) {
1338                 require(tokenIds[i] != tokenIds[j], "RNCT: duplicate tokenId");
1339             }
1340 
1341             uint256 amount = accumulated(tokenIds[i]);
1342             if (amount != 0) {
1343                 total = total + amount;
1344             }
1345         }
1346         return total;
1347     }
1348 
1349     function claim(uint256[] memory tokenIds) public returns (uint256) {
1350         require(block.timestamp > EMISSION_START, "RNCT: emission has not started yet");
1351         uint256 totalClaimQty = 0;
1352         for (uint256 i = 0; i < tokenIds.length; i++) {
1353             for (uint256 j = i + 1; j < tokenIds.length; j++) {
1354                 require(tokenIds[i] != tokenIds[j], "RNCT: duplicate tokenId");
1355             }
1356 
1357             uint256 tokenId = tokenIds[i];
1358             require(IRoboShort(ROBO).rawOwnerOf(tokenId) == _msgSender(), "RNCT: sender is not the owner");
1359 
1360             uint256 claimQty = accumulated(tokenId);
1361             if (claimQty != 0) {
1362                 totalClaimQty = totalClaimQty + claimQty;
1363                 _lastClaim[tokenId] = block.timestamp;
1364             }
1365         }
1366 
1367         require(totalClaimQty != 0, "RNCT: no accumulated RNCT");
1368         _mint(_msgSender(), totalClaimQty);
1369         return totalClaimQty;
1370     }
1371 
1372     function setRobo(address robo) public onlyOwner {
1373         require(ROBO == address(0), "RNCT: ROBO is already set");
1374         ROBO = robo;
1375     }
1376 
1377     // The following functions are overrides required by Solidity.
1378     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
1379         if (_msgSender() == ROBO) {
1380             _transfer(sender, recipient, amount);
1381             return true;
1382         }
1383         return super.transferFrom(sender, recipient, amount);
1384     }
1385 }