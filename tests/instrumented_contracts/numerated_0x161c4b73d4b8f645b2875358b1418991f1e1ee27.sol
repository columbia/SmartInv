1 // File: @openzeppelin/contracts/utils/Context.sol
2 
3 
4 /**
5 Twitter: https://twitter.com/3CuteMeme
6 Telegram: https://t.me/ThreeCute3
7 Website: https://www.3cute.io/
8 **/
9 
10 pragma solidity ^0.8.0;
11 
12 /**
13  * @dev Provides information about the current execution context, including the
14  * sender of the transaction and its data. While these are generally available
15  * via msg.sender and msg.data, they should not be accessed in such a direct
16  * manner, since when dealing with meta-transactions the account sending and
17  * paying for execution may not be the actual sender (as far as an application
18  * is concerned).
19  *
20  * This contract is only required for intermediate, library-like contracts.
21  */
22 abstract contract Context {
23     function _msgSender() internal view virtual returns (address) {
24         return msg.sender;
25     }
26 
27     function _msgData() internal view virtual returns (bytes calldata) {
28         return msg.data;
29     }
30 }
31 
32 // File: @openzeppelin/contracts/access/Ownable.sol
33 
34 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
35 
36 pragma solidity ^0.8.0;
37 
38 
39 /**
40  * @dev Contract module which provides a basic access control mechanism, where
41  * there is an account (an owner) that can be granted exclusive access to
42  * specific functions.
43  *
44  * By default, the owner account will be the one that deploys the contract. This
45  * can later be changed with {transferOwnership}.
46  *
47  * This module is used through inheritance. It will make available the modifier
48  * `onlyOwner`, which can be applied to your functions to restrict their use to
49  * the owner.
50  */
51 abstract contract Ownable is Context {
52     address private _owner;
53 
54     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
55 
56     /**
57      * @dev Initializes the contract setting the deployer as the initial owner.
58      */
59     constructor() {
60         _transferOwnership(_msgSender());
61     }
62 
63     /**
64      * @dev Returns the address of the current owner.
65      */
66     function owner() public view virtual returns (address) {
67         return _owner;
68     }
69 
70     /**
71      * @dev Throws if called by any account other than the owner.
72      */
73     modifier onlyOwner() {
74         require(owner() == _msgSender(), "Ownable: caller is not the owner");
75         _;
76     }
77 
78     /**
79      * @dev Leaves the contract without owner. It will not be possible to call
80      * `onlyOwner` functions anymore. Can only be called by the current owner.
81      *
82      * NOTE: Renouncing ownership will leave the contract without an owner,
83      * thereby removing any functionality that is only available to the owner.
84      */
85     function renounceOwnership() public virtual onlyOwner {
86         _transferOwnership(address(0));
87     }
88 
89     /**
90      * @dev Transfers ownership of the contract to a new account (`newOwner`).
91      * Can only be called by the current owner.
92      */
93     function transferOwnership(address newOwner) public virtual onlyOwner {
94         require(newOwner != address(0), "Ownable: new owner is the zero address");
95         _transferOwnership(newOwner);
96     }
97 
98     /**
99      * @dev Transfers ownership of the contract to a new account (`newOwner`).
100      * Internal function without access restriction.
101      */
102     function _transferOwnership(address newOwner) internal virtual {
103         address oldOwner = _owner;
104         _owner = newOwner;
105         emit OwnershipTransferred(oldOwner, newOwner);
106     }
107 }
108 
109 // File: @openzeppelin/contracts/token/ERC20/extensions/draft-IERC20Permit.sol
110 
111 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/draft-IERC20Permit.sol)
112 
113 pragma solidity ^0.8.0;
114 
115 /**
116  * @dev Interface of the ERC20 Permit extension allowing approvals to be made via signatures, as defined in
117  * https://eips.ethereum.org/EIPS/eip-2612[EIP-2612].
118  *
119  * Adds the {permit} method, which can be used to change an account's ERC20 allowance (see {IERC20-allowance}) by
120  * presenting a message signed by the account. By not relying on {IERC20-approve}, the token holder account doesn't
121  * need to send a transaction, and thus is not required to hold Ether at all.
122  */
123 interface IERC20Permit {
124     /**
125      * @dev Sets `value` as the allowance of `spender` over ``owner``'s tokens,
126      * given ``owner``'s signed approval.
127      *
128      * IMPORTANT: The same issues {IERC20-approve} has related to transaction
129      * ordering also apply here.
130      *
131      * Emits an {Approval} event.
132      *
133      * Requirements:
134      *
135      * - `spender` cannot be the zero address.
136      * - `deadline` must be a timestamp in the future.
137      * - `v`, `r` and `s` must be a valid `secp256k1` signature from `owner`
138      * over the EIP712-formatted function arguments.
139      * - the signature must use ``owner``'s current nonce (see {nonces}).
140      *
141      * For more information on the signature format, see the
142      * https://eips.ethereum.org/EIPS/eip-2612#specification[relevant EIP
143      * section].
144      */
145     function permit(
146         address owner,
147         address spender,
148         uint256 value,
149         uint256 deadline,
150         uint8 v,
151         bytes32 r,
152         bytes32 s
153     ) external;
154 
155     /**
156      * @dev Returns the current nonce for `owner`. This value must be
157      * included whenever a signature is generated for {permit}.
158      *
159      * Every successful call to {permit} increases ``owner``'s nonce by one. This
160      * prevents a signature from being used multiple times.
161      */
162     function nonces(address owner) external view returns (uint256);
163 
164     /**
165      * @dev Returns the domain separator used in the encoding of the signature for {permit}, as defined by {EIP712}.
166      */
167     // solhint-disable-next-line func-name-mixedcase
168     function DOMAIN_SEPARATOR() external view returns (bytes32);
169 }
170 
171 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
172 
173 
174 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
175 
176 pragma solidity ^0.8.0;
177 
178 /**
179  * @dev Interface of the ERC20 standard as defined in the EIP.
180  */
181 interface IERC20 {
182     /**
183      * @dev Emitted when `value` tokens are moved from one account (`from`) to
184      * another (`to`).
185      *
186      * Note that `value` may be zero.
187      */
188     event Transfer(address indexed from, address indexed to, uint256 value);
189 
190     /**
191      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
192      * a call to {approve}. `value` is the new allowance.
193      */
194     event Approval(address indexed owner, address indexed spender, uint256 value);
195 
196     /**
197      * @dev Returns the amount of tokens in existence.
198      */
199     function totalSupply() external view returns (uint256);
200 
201     /**
202      * @dev Returns the amount of tokens owned by `account`.
203      */
204     function balanceOf(address account) external view returns (uint256);
205 
206     /**
207      * @dev Moves `amount` tokens from the caller's account to `to`.
208      *
209      * Returns a boolean value indicating whether the operation succeeded.
210      *
211      * Emits a {Transfer} event.
212      */
213     function transfer(address to, uint256 amount) external returns (bool);
214 
215     /**
216      * @dev Returns the remaining number of tokens that `spender` will be
217      * allowed to spend on behalf of `owner` through {transferFrom}. This is
218      * zero by default.
219      *
220      * This value changes when {approve} or {transferFrom} are called.
221      */
222     function allowance(address owner, address spender) external view returns (uint256);
223 
224     /**
225      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
226      *
227      * Returns a boolean value indicating whether the operation succeeded.
228      *
229      * IMPORTANT: Beware that changing an allowance with this method brings the risk
230      * that someone may use both the old and the new allowance by unfortunate
231      * transaction ordering. One possible solution to mitigate this race
232      * condition is to first reduce the spender's allowance to 0 and set the
233      * desired value afterwards:
234      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
235      *
236      * Emits an {Approval} event.
237      */
238     function approve(address spender, uint256 amount) external returns (bool);
239 
240     /**
241      * @dev Moves `amount` tokens from `from` to `to` using the
242      * allowance mechanism. `amount` is then deducted from the caller's
243      * allowance.
244      *
245      * Returns a boolean value indicating whether the operation succeeded.
246      *
247      * Emits a {Transfer} event.
248      */
249     function transferFrom(
250         address from,
251         address to,
252         uint256 amount
253     ) external returns (bool);
254 }
255 
256 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
257 
258 
259 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
260 
261 pragma solidity ^0.8.0;
262 
263 
264 /**
265  * @dev Interface for the optional metadata functions from the ERC20 standard.
266  *
267  * _Available since v4.1._
268  */
269 interface IERC20Metadata is IERC20 {
270     /**
271      * @dev Returns the name of the token.
272      */
273     function name() external view returns (string memory);
274 
275     /**
276      * @dev Returns the symbol of the token.
277      */
278     function symbol() external view returns (string memory);
279 
280     /**
281      * @dev Returns the decimals places of the token.
282      */
283     function decimals() external view returns (uint8);
284 }
285 
286 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
287 
288 
289 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/ERC20.sol)
290 
291 pragma solidity ^0.8.0;
292 
293 
294 
295 
296 /**
297  * @dev Implementation of the {IERC20} interface.
298  *
299  * This implementation is agnostic to the way tokens are created. This means
300  * that a supply mechanism has to be added in a derived contract using {_mint}.
301  * For a generic mechanism see {ERC20PresetMinterPauser}.
302  *
303  * TIP: For a detailed writeup see our guide
304  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
305  * to implement supply mechanisms].
306  *
307  * We have followed general OpenZeppelin Contracts guidelines: functions revert
308  * instead returning `false` on failure. This behavior is nonetheless
309  * conventional and does not conflict with the expectations of ERC20
310  * applications.
311  *
312  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
313  * This allows applications to reconstruct the allowance for all accounts just
314  * by listening to said events. Other implementations of the EIP may not emit
315  * these events, as it isn't required by the specification.
316  *
317  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
318  * functions have been added to mitigate the well-known issues around setting
319  * allowances. See {IERC20-approve}.
320  */
321 contract ERC20 is Context, IERC20, IERC20Metadata {
322     mapping(address => uint256) private _balances;
323 
324     mapping(address => mapping(address => uint256)) private _allowances;
325 
326     uint256 private _totalSupply;
327 
328     string private _name;
329     string private _symbol;
330 
331     /**
332      * @dev Sets the values for {name} and {symbol}.
333      *
334      * The default value of {decimals} is 18. To select a different value for
335      * {decimals} you should overload it.
336      *
337      * All two of these values are immutable: they can only be set once during
338      * construction.
339      */
340     constructor(string memory name_, string memory symbol_) {
341         _name = name_;
342         _symbol = symbol_;
343     }
344 
345     /**
346      * @dev Returns the name of the token.
347      */
348     function name() public view virtual override returns (string memory) {
349         return _name;
350     }
351 
352     /**
353      * @dev Returns the symbol of the token, usually a shorter version of the
354      * name.
355      */
356     function symbol() public view virtual override returns (string memory) {
357         return _symbol;
358     }
359 
360     /**
361      * @dev Returns the number of decimals used to get its user representation.
362      * For example, if `decimals` equals `2`, a balance of `505` tokens should
363      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
364      *
365      * Tokens usually opt for a value of 18, imitating the relationship between
366      * Ether and Wei. This is the value {ERC20} uses, unless this function is
367      * overridden;
368      *
369      * NOTE: This information is only used for _display_ purposes: it in
370      * no way affects any of the arithmetic of the contract, including
371      * {IERC20-balanceOf} and {IERC20-transfer}.
372      */
373     function decimals() public view virtual override returns (uint8) {
374         return 18;
375     }
376 
377     /**
378      * @dev See {IERC20-totalSupply}.
379      */
380     function totalSupply() public view virtual override returns (uint256) {
381         return _totalSupply;
382     }
383 
384     /**
385      * @dev See {IERC20-balanceOf}.
386      */
387     function balanceOf(address account) public view virtual override returns (uint256) {
388         return _balances[account];
389     }
390 
391     /**
392      * @dev See {IERC20-transfer}.
393      *
394      * Requirements:
395      *
396      * - `to` cannot be the zero address.
397      * - the caller must have a balance of at least `amount`.
398      */
399     function transfer(address to, uint256 amount) public virtual override returns (bool) {
400         address owner = _msgSender();
401         _transfer(owner, to, amount);
402         return true;
403     }
404 
405     /**
406      * @dev See {IERC20-allowance}.
407      */
408     function allowance(address owner, address spender) public view virtual override returns (uint256) {
409         return _allowances[owner][spender];
410     }
411 
412     /**
413      * @dev See {IERC20-approve}.
414      *
415      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
416      * `transferFrom`. This is semantically equivalent to an infinite approval.
417      *
418      * Requirements:
419      *
420      * - `spender` cannot be the zero address.
421      */
422     function approve(address spender, uint256 amount) public virtual override returns (bool) {
423         address owner = _msgSender();
424         _approve(owner, spender, amount);
425         return true;
426     }
427 
428     /**
429      * @dev See {IERC20-transferFrom}.
430      *
431      * Emits an {Approval} event indicating the updated allowance. This is not
432      * required by the EIP. See the note at the beginning of {ERC20}.
433      *
434      * NOTE: Does not update the allowance if the current allowance
435      * is the maximum `uint256`.
436      *
437      * Requirements:
438      *
439      * - `from` and `to` cannot be the zero address.
440      * - `from` must have a balance of at least `amount`.
441      * - the caller must have allowance for ``from``'s tokens of at least
442      * `amount`.
443      */
444     function transferFrom(
445         address from,
446         address to,
447         uint256 amount
448     ) public virtual override returns (bool) {
449         address spender = _msgSender();
450         _spendAllowance(from, spender, amount);
451         _transfer(from, to, amount);
452         return true;
453     }
454 
455     /**
456      * @dev Atomically increases the allowance granted to `spender` by the caller.
457      *
458      * This is an alternative to {approve} that can be used as a mitigation for
459      * problems described in {IERC20-approve}.
460      *
461      * Emits an {Approval} event indicating the updated allowance.
462      *
463      * Requirements:
464      *
465      * - `spender` cannot be the zero address.
466      */
467     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
468         address owner = _msgSender();
469         _approve(owner, spender, allowance(owner, spender) + addedValue);
470         return true;
471     }
472 
473     /**
474      * @dev Atomically decreases the allowance granted to `spender` by the caller.
475      *
476      * This is an alternative to {approve} that can be used as a mitigation for
477      * problems described in {IERC20-approve}.
478      *
479      * Emits an {Approval} event indicating the updated allowance.
480      *
481      * Requirements:
482      *
483      * - `spender` cannot be the zero address.
484      * - `spender` must have allowance for the caller of at least
485      * `subtractedValue`.
486      */
487     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
488         address owner = _msgSender();
489         uint256 currentAllowance = allowance(owner, spender);
490         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
491     unchecked {
492         _approve(owner, spender, currentAllowance - subtractedValue);
493     }
494 
495         return true;
496     }
497 
498     /**
499      * @dev Moves `amount` of tokens from `sender` to `recipient`.
500      *
501      * This internal function is equivalent to {transfer}, and can be used to
502      * e.g. implement automatic token fees, slashing mechanisms, etc.
503      *
504      * Emits a {Transfer} event.
505      *
506      * Requirements:
507      *
508      * - `from` cannot be the zero address.
509      * - `to` cannot be the zero address.
510      * - `from` must have a balance of at least `amount`.
511      */
512     function _transfer(
513         address from,
514         address to,
515         uint256 amount
516     ) internal virtual {
517         require(from != address(0), "ERC20: transfer from the zero address");
518         require(to != address(0), "ERC20: transfer to the zero address");
519 
520         _beforeTokenTransfer(from, to, amount);
521 
522         uint256 fromBalance = _balances[from];
523         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
524     unchecked {
525         _balances[from] = fromBalance - amount;
526     }
527         _balances[to] += amount;
528 
529         emit Transfer(from, to, amount);
530 
531         _afterTokenTransfer(from, to, amount);
532     }
533 
534     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
535      * the total supply.
536      *
537      * Emits a {Transfer} event with `from` set to the zero address.
538      *
539      * Requirements:
540      *
541      * - `account` cannot be the zero address.
542      */
543     function _mint(address account, uint256 amount) internal virtual {
544         require(account != address(0), "ERC20: mint to the zero address");
545 
546         _beforeTokenTransfer(address(0), account, amount);
547 
548         _totalSupply += amount;
549         _balances[account] += amount;
550         emit Transfer(address(0), account, amount);
551 
552         _afterTokenTransfer(address(0), account, amount);
553     }
554 
555     /**
556      * @dev Destroys `amount` tokens from `account`, reducing the
557      * total supply.
558      *
559      * Emits a {Transfer} event with `to` set to the zero address.
560      *
561      * Requirements:
562      *
563      * - `account` cannot be the zero address.
564      * - `account` must have at least `amount` tokens.
565      */
566     function _burn(address account, uint256 amount) internal virtual {
567         require(account != address(0), "ERC20: burn from the zero address");
568 
569         _beforeTokenTransfer(account, address(0), amount);
570 
571         uint256 accountBalance = _balances[account];
572         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
573     unchecked {
574         _balances[account] = accountBalance - amount;
575     }
576         _totalSupply -= amount;
577 
578         emit Transfer(account, address(0), amount);
579 
580         _afterTokenTransfer(account, address(0), amount);
581     }
582 
583     /**
584      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
585      *
586      * This internal function is equivalent to `approve`, and can be used to
587      * e.g. set automatic allowances for certain subsystems, etc.
588      *
589      * Emits an {Approval} event.
590      *
591      * Requirements:
592      *
593      * - `owner` cannot be the zero address.
594      * - `spender` cannot be the zero address.
595      */
596     function _approve(
597         address owner,
598         address spender,
599         uint256 amount
600     ) internal virtual {
601         require(owner != address(0), "ERC20: approve from the zero address");
602         require(spender != address(0), "ERC20: approve to the zero address");
603 
604         _allowances[owner][spender] = amount;
605         emit Approval(owner, spender, amount);
606     }
607 
608     /**
609      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
610      *
611      * Does not update the allowance amount in case of infinite allowance.
612      * Revert if not enough allowance is available.
613      *
614      * Might emit an {Approval} event.
615      */
616     function _spendAllowance(
617         address owner,
618         address spender,
619         uint256 amount
620     ) internal virtual {
621         uint256 currentAllowance = allowance(owner, spender);
622         if (currentAllowance != type(uint256).max) {
623             require(currentAllowance >= amount, "ERC20: insufficient allowance");
624         unchecked {
625             _approve(owner, spender, currentAllowance - amount);
626         }
627         }
628     }
629 
630     /**
631      * @dev Hook that is called before any transfer of tokens. This includes
632      * minting and burning.
633      *
634      * Calling conditions:
635      *
636      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
637      * will be transferred to `to`.
638      * - when `from` is zero, `amount` tokens will be minted for `to`.
639      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
640      * - `from` and `to` are never both zero.
641      *
642      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
643      */
644     function _beforeTokenTransfer(
645         address from,
646         address to,
647         uint256 amount
648     ) internal virtual {}
649 
650     /**
651      * @dev Hook that is called after any transfer of tokens. This includes
652      * minting and burning.
653      *
654      * Calling conditions:
655      *
656      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
657      * has been transferred to `to`.
658      * - when `from` is zero, `amount` tokens have been minted for `to`.
659      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
660      * - `from` and `to` are never both zero.
661      *
662      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
663      */
664     function _afterTokenTransfer(
665         address from,
666         address to,
667         uint256 amount
668     ) internal virtual {}
669 }
670 
671 // File: @openzeppelin/contracts/utils/Strings.sol
672 
673 
674 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
675 
676 pragma solidity ^0.8.0;
677 
678 /**
679  * @dev String operations.
680  */
681 library Strings {
682     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
683 
684     /**
685      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
686      */
687     function toString(uint256 value) internal pure returns (string memory) {
688         // Inspired by OraclizeAPI's implementation - MIT licence
689         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
690 
691         if (value == 0) {
692             return "0";
693         }
694         uint256 temp = value;
695         uint256 digits;
696         while (temp != 0) {
697             digits++;
698             temp /= 10;
699         }
700         bytes memory buffer = new bytes(digits);
701         while (value != 0) {
702             digits -= 1;
703             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
704             value /= 10;
705         }
706         return string(buffer);
707     }
708 
709     /**
710      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
711      */
712     function toHexString(uint256 value) internal pure returns (string memory) {
713         if (value == 0) {
714             return "0x00";
715         }
716         uint256 temp = value;
717         uint256 length = 0;
718         while (temp != 0) {
719             length++;
720             temp >>= 8;
721         }
722         return toHexString(value, length);
723     }
724 
725     /**
726      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
727      */
728     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
729         bytes memory buffer = new bytes(2 * length + 2);
730         buffer[0] = "0";
731         buffer[1] = "x";
732         for (uint256 i = 2 * length + 1; i > 1; --i) {
733             buffer[i] = _HEX_SYMBOLS[value & 0xf];
734             value >>= 4;
735         }
736         require(value == 0, "Strings: hex length insufficient");
737         return string(buffer);
738     }
739 }
740 
741 // File: @openzeppelin/contracts/utils/cryptography/ECDSA.sol
742 
743 // OpenZeppelin Contracts (last updated v4.5.0) (utils/cryptography/ECDSA.sol)
744 
745 pragma solidity ^0.8.0;
746 
747 
748 /**
749  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
750  *
751  * These functions can be used to verify that a message was signed by the holder
752  * of the private keys of a given address.
753  */
754 library ECDSA {
755     enum RecoverError {
756         NoError,
757         InvalidSignature,
758         InvalidSignatureLength,
759         InvalidSignatureS,
760         InvalidSignatureV
761     }
762 
763     function _throwError(RecoverError error) private pure {
764         if (error == RecoverError.NoError) {
765             return; // no error: do nothing
766         } else if (error == RecoverError.InvalidSignature) {
767             revert("ECDSA: invalid signature");
768         } else if (error == RecoverError.InvalidSignatureLength) {
769             revert("ECDSA: invalid signature length");
770         } else if (error == RecoverError.InvalidSignatureS) {
771             revert("ECDSA: invalid signature 's' value");
772         } else if (error == RecoverError.InvalidSignatureV) {
773             revert("ECDSA: invalid signature 'v' value");
774         }
775     }
776 
777     /**
778      * @dev Returns the address that signed a hashed message (`hash`) with
779      * `signature` or error string. This address can then be used for verification purposes.
780      *
781      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
782      * this function rejects them by requiring the `s` value to be in the lower
783      * half order, and the `v` value to be either 27 or 28.
784      *
785      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
786      * verification to be secure: it is possible to craft signatures that
787      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
788      * this is by receiving a hash of the original message (which may otherwise
789      * be too long), and then calling {toEthSignedMessageHash} on it.
790      *
791      * Documentation for signature generation:
792      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
793      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
794      *
795      * _Available since v4.3._
796      */
797     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
798         // Check the signature length
799         // - case 65: r,s,v signature (standard)
800         // - case 64: r,vs signature (cf https://eips.ethereum.org/EIPS/eip-2098) _Available since v4.1._
801         if (signature.length == 65) {
802             bytes32 r;
803             bytes32 s;
804             uint8 v;
805             // ecrecover takes the signature parameters, and the only way to get them
806             // currently is to use assembly.
807             assembly {
808                 r := mload(add(signature, 0x20))
809                 s := mload(add(signature, 0x40))
810                 v := byte(0, mload(add(signature, 0x60)))
811             }
812             return tryRecover(hash, v, r, s);
813         } else if (signature.length == 64) {
814             bytes32 r;
815             bytes32 vs;
816             // ecrecover takes the signature parameters, and the only way to get them
817             // currently is to use assembly.
818             assembly {
819                 r := mload(add(signature, 0x20))
820                 vs := mload(add(signature, 0x40))
821             }
822             return tryRecover(hash, r, vs);
823         } else {
824             return (address(0), RecoverError.InvalidSignatureLength);
825         }
826     }
827 
828     /**
829      * @dev Returns the address that signed a hashed message (`hash`) with
830      * `signature`. This address can then be used for verification purposes.
831      *
832      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
833      * this function rejects them by requiring the `s` value to be in the lower
834      * half order, and the `v` value to be either 27 or 28.
835      *
836      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
837      * verification to be secure: it is possible to craft signatures that
838      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
839      * this is by receiving a hash of the original message (which may otherwise
840      * be too long), and then calling {toEthSignedMessageHash} on it.
841      */
842     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
843         (address recovered, RecoverError error) = tryRecover(hash, signature);
844         _throwError(error);
845         return recovered;
846     }
847 
848     /**
849      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
850      *
851      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
852      *
853      * _Available since v4.3._
854      */
855     function tryRecover(
856         bytes32 hash,
857         bytes32 r,
858         bytes32 vs
859     ) internal pure returns (address, RecoverError) {
860         bytes32 s = vs & bytes32(0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff);
861         uint8 v = uint8((uint256(vs) >> 255) + 27);
862         return tryRecover(hash, v, r, s);
863     }
864 
865     /**
866      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
867      *
868      * _Available since v4.2._
869      */
870     function recover(
871         bytes32 hash,
872         bytes32 r,
873         bytes32 vs
874     ) internal pure returns (address) {
875         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
876         _throwError(error);
877         return recovered;
878     }
879 
880     /**
881      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
882      * `r` and `s` signature fields separately.
883      *
884      * _Available since v4.3._
885      */
886     function tryRecover(
887         bytes32 hash,
888         uint8 v,
889         bytes32 r,
890         bytes32 s
891     ) internal pure returns (address, RecoverError) {
892         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
893         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
894         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
895         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
896         //
897         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
898         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
899         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
900         // these malleable signatures as well.
901         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
902             return (address(0), RecoverError.InvalidSignatureS);
903         }
904         if (v != 27 && v != 28) {
905             return (address(0), RecoverError.InvalidSignatureV);
906         }
907 
908         // If the signature is valid (and not malleable), return the signer address
909         address signer = ecrecover(hash, v, r, s);
910         if (signer == address(0)) {
911             return (address(0), RecoverError.InvalidSignature);
912         }
913 
914         return (signer, RecoverError.NoError);
915     }
916 
917     /**
918      * @dev Overload of {ECDSA-recover} that receives the `v`,
919      * `r` and `s` signature fields separately.
920      */
921     function recover(
922         bytes32 hash,
923         uint8 v,
924         bytes32 r,
925         bytes32 s
926     ) internal pure returns (address) {
927         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
928         _throwError(error);
929         return recovered;
930     }
931 
932     /**
933      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
934      * produces hash corresponding to the one signed with the
935      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
936      * JSON-RPC method as part of EIP-191.
937      *
938      * See {recover}.
939      */
940     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
941         // 32 is the length in bytes of hash,
942         // enforced by the type signature above
943         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
944     }
945 
946     /**
947      * @dev Returns an Ethereum Signed Message, created from `s`. This
948      * produces hash corresponding to the one signed with the
949      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
950      * JSON-RPC method as part of EIP-191.
951      *
952      * See {recover}.
953      */
954     function toEthSignedMessageHash(bytes memory s) internal pure returns (bytes32) {
955         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n", Strings.toString(s.length), s));
956     }
957 
958     /**
959      * @dev Returns an Ethereum Signed Typed Data, created from a
960      * `domainSeparator` and a `structHash`. This produces hash corresponding
961      * to the one signed with the
962      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
963      * JSON-RPC method as part of EIP-712.
964      *
965      * See {recover}.
966      */
967     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
968         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
969     }
970 }
971 
972 // File: @openzeppelin/contracts/utils/cryptography/draft-EIP712.sol
973 
974 // OpenZeppelin Contracts v4.4.1 (utils/cryptography/draft-EIP712.sol)
975 
976 pragma solidity ^0.8.0;
977 
978 
979 /**
980  * @dev https://eips.ethereum.org/EIPS/eip-712[EIP 712] is a standard for hashing and signing of typed structured data.
981  *
982  * The encoding specified in the EIP is very generic, and such a generic implementation in Solidity is not feasible,
983  * thus this contract does not implement the encoding itself. Protocols need to implement the type-specific encoding
984  * they need in their contracts using a combination of `abi.encode` and `keccak256`.
985  *
986  * This contract implements the EIP 712 domain separator ({_domainSeparatorV4}) that is used as part of the encoding
987  * scheme, and the final step of the encoding to obtain the message digest that is then signed via ECDSA
988  * ({_hashTypedDataV4}).
989  *
990  * The implementation of the domain separator was designed to be as efficient as possible while still properly updating
991  * the chain id to protect against replay attacks on an eventual fork of the chain.
992  *
993  * NOTE: This contract implements the version of the encoding known as "v4", as implemented by the JSON RPC method
994  * https://docs.metamask.io/guide/signing-data.html[`eth_signTypedDataV4` in MetaMask].
995  *
996  * _Available since v3.4._
997  */
998 abstract contract EIP712 {
999     /* solhint-disable var-name-mixedcase */
1000     // Cache the domain separator as an immutable value, but also store the chain id that it corresponds to, in order to
1001     // invalidate the cached domain separator if the chain id changes.
1002     bytes32 private immutable _CACHED_DOMAIN_SEPARATOR;
1003     uint256 private immutable _CACHED_CHAIN_ID;
1004     address private immutable _CACHED_THIS;
1005 
1006     bytes32 private immutable _HASHED_NAME;
1007     bytes32 private immutable _HASHED_VERSION;
1008     bytes32 private immutable _TYPE_HASH;
1009 
1010     /* solhint-enable var-name-mixedcase */
1011 
1012     /**
1013      * @dev Initializes the domain separator and parameter caches.
1014      *
1015      * The meaning of `name` and `version` is specified in
1016      * https://eips.ethereum.org/EIPS/eip-712#definition-of-domainseparator[EIP 712]:
1017      *
1018      * - `name`: the user readable name of the signing domain, i.e. the name of the DApp or the protocol.
1019      * - `version`: the current major version of the signing domain.
1020      *
1021      * NOTE: These parameters cannot be changed except through a xref:learn::upgrading-smart-contracts.adoc[smart
1022      * contract upgrade].
1023      */
1024     constructor(string memory name, string memory version) {
1025         bytes32 hashedName = keccak256(bytes(name));
1026         bytes32 hashedVersion = keccak256(bytes(version));
1027         bytes32 typeHash = keccak256(
1028             "EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"
1029         );
1030         _HASHED_NAME = hashedName;
1031         _HASHED_VERSION = hashedVersion;
1032         _CACHED_CHAIN_ID = block.chainid;
1033         _CACHED_DOMAIN_SEPARATOR = _buildDomainSeparator(typeHash, hashedName, hashedVersion);
1034         _CACHED_THIS = address(this);
1035         _TYPE_HASH = typeHash;
1036     }
1037 
1038     /**
1039      * @dev Returns the domain separator for the current chain.
1040      */
1041     function _domainSeparatorV4() internal view returns (bytes32) {
1042         if (address(this) == _CACHED_THIS && block.chainid == _CACHED_CHAIN_ID) {
1043             return _CACHED_DOMAIN_SEPARATOR;
1044         } else {
1045             return _buildDomainSeparator(_TYPE_HASH, _HASHED_NAME, _HASHED_VERSION);
1046         }
1047     }
1048 
1049     function _buildDomainSeparator(
1050         bytes32 typeHash,
1051         bytes32 nameHash,
1052         bytes32 versionHash
1053     ) private view returns (bytes32) {
1054         return keccak256(abi.encode(typeHash, nameHash, versionHash, block.chainid, address(this)));
1055     }
1056 
1057     /**
1058      * @dev Given an already https://eips.ethereum.org/EIPS/eip-712#definition-of-hashstruct[hashed struct], this
1059      * function returns the hash of the fully encoded EIP712 message for this domain.
1060      *
1061      * This hash can be used together with {ECDSA-recover} to obtain the signer of a message. For example:
1062      *
1063      * ```solidity
1064      * bytes32 digest = _hashTypedDataV4(keccak256(abi.encode(
1065      *     keccak256("Mail(address to,string contents)"),
1066      *     mailTo,
1067      *     keccak256(bytes(mailContents))
1068      * )));
1069      * address signer = ECDSA.recover(digest, signature);
1070      * ```
1071      */
1072     function _hashTypedDataV4(bytes32 structHash) internal view virtual returns (bytes32) {
1073         return ECDSA.toTypedDataHash(_domainSeparatorV4(), structHash);
1074     }
1075 }
1076 
1077 // File: @openzeppelin/contracts/utils/Counters.sol
1078 
1079 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
1080 
1081 pragma solidity ^0.8.0;
1082 
1083 /**
1084  * @title Counters
1085  * @author Matt Condon (@shrugs)
1086  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
1087  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
1088  *
1089  * Include with `using Counters for Counters.Counter;`
1090  */
1091 library Counters {
1092     struct Counter {
1093         // This variable should never be directly accessed by users of the library: interactions must be restricted to
1094         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
1095         // this feature: see https://github.com/ethereum/solidity/issues/4637
1096         uint256 _value; // default: 0
1097     }
1098 
1099     function current(Counter storage counter) internal view returns (uint256) {
1100         return counter._value;
1101     }
1102 
1103     function increment(Counter storage counter) internal {
1104     unchecked {
1105         counter._value += 1;
1106     }
1107     }
1108 
1109     function decrement(Counter storage counter) internal {
1110         uint256 value = counter._value;
1111         require(value > 0, "Counter: decrement overflow");
1112     unchecked {
1113         counter._value = value - 1;
1114     }
1115     }
1116 
1117     function reset(Counter storage counter) internal {
1118         counter._value = 0;
1119     }
1120 }
1121 
1122 // File: @openzeppelin/contracts/token/ERC20/extensions/draft-ERC20Permit.sol
1123 
1124 // SPDX-License-Identifier: MIT
1125 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/extensions/draft-ERC20Permit.sol)
1126 
1127 pragma solidity ^0.8.0;
1128 
1129 
1130 
1131 
1132 
1133 
1134 /**
1135  * @dev Implementation of the ERC20 Permit extension allowing approvals to be made via signatures, as defined in
1136  * https://eips.ethereum.org/EIPS/eip-2612[EIP-2612].
1137  *
1138  * Adds the {permit} method, which can be used to change an account's ERC20 allowance (see {IERC20-allowance}) by
1139  * presenting a message signed by the account. By not relying on `{IERC20-approve}`, the token holder account doesn't
1140  * need to send a transaction, and thus is not required to hold Ether at all.
1141  *
1142  * _Available since v3.4._
1143  */
1144 abstract contract ERC20Permit is ERC20, IERC20Permit, EIP712 {
1145     using Counters for Counters.Counter;
1146 
1147     mapping(address => Counters.Counter) private _nonces;
1148 
1149     // solhint-disable-next-line var-name-mixedcase
1150     bytes32 private constant _PERMIT_TYPEHASH =
1151     keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");
1152 
1153     // solhint-disable-next-line var-name-mixedcase
1154     bytes32 private _PERMIT_TYPEHASH_DEPRECATED_SLOT;
1155 
1156     /**
1157      * @dev Initializes the {EIP712} domain separator using the `name` parameter, and setting `version` to `"1"`.
1158      *
1159      * It's a good idea to use the same `name` that is defined as the ERC20 token name.
1160      */
1161     constructor(string memory name) EIP712(name, "1") {}
1162 
1163     /**
1164      * @dev See {IERC20Permit-permit}.
1165      */
1166     function permit(
1167         address owner,
1168         address spender,
1169         uint256 value,
1170         uint256 deadline,
1171         uint8 v,
1172         bytes32 r,
1173         bytes32 s
1174     ) public virtual override {
1175         require(block.timestamp <= deadline, "ERC20Permit: expired deadline");
1176 
1177         bytes32 structHash = keccak256(abi.encode(_PERMIT_TYPEHASH, owner, spender, value, _useNonce(owner), deadline));
1178 
1179         bytes32 hash = _hashTypedDataV4(structHash);
1180 
1181         address signer = ECDSA.recover(hash, v, r, s);
1182         require(signer == owner, "ERC20Permit: invalid signature");
1183 
1184         _approve(owner, spender, value);
1185     }
1186 
1187     /**
1188      * @dev See {IERC20Permit-nonces}.
1189      */
1190     function nonces(address owner) public view virtual override returns (uint256) {
1191         return _nonces[owner].current();
1192     }
1193 
1194     /**
1195      * @dev See {IERC20Permit-DOMAIN_SEPARATOR}.
1196      */
1197     // solhint-disable-next-line func-name-mixedcase
1198     function DOMAIN_SEPARATOR() external view override returns (bytes32) {
1199         return _domainSeparatorV4();
1200     }
1201 
1202     /**
1203      * @dev "Consume a nonce": return the current value and increment.
1204      *
1205      * _Available since v4.1._
1206      */
1207     function _useNonce(address owner) internal virtual returns (uint256 current) {
1208         Counters.Counter storage nonce = _nonces[owner];
1209         current = nonce.current();
1210         nonce.increment();
1211     }
1212 }
1213 
1214 interface IFactory {
1215     function createPair(address tokenA, address tokenB) external returns (address pair);
1216 }
1217 
1218 
1219 
1220 
1221 interface IRouter {
1222     function factory() external pure returns (address);
1223     function WETH() external pure returns (address);
1224 }
1225 
1226 
1227 contract cute is ERC20Permit, Ownable{
1228 
1229     uint public _balanceLimit = 690e12 * 1e16;
1230     uint public _startBlock;
1231 
1232     uint8 public _buyTax;
1233     address public _pair;
1234     uint8 public _sellTax;
1235     address public _feeAccount = address(0xFe42769dc3c77211379Eb7Ee9a265D753C1E5818);
1236 
1237 
1238 
1239 
1240     constructor(
1241         string memory name,
1242         string memory symbol
1243     ) ERC20(name, symbol) ERC20Permit(name) {
1244 
1245         IRouter router = IRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
1246         _pair = IFactory(router.factory()).createPair(address(this), router.WETH());
1247 
1248         _mint(msg.sender, 690e12 * 1e18);
1249     }
1250 
1251     function setFeeAccount(address account) external onlyOwner{
1252         _feeAccount = account;
1253     }
1254 
1255     function setBalanceLimit(uint amount) external onlyOwner {
1256         _balanceLimit = amount;
1257     }
1258 
1259     function setTax(uint8 buy, uint8 sell) external onlyOwner {
1260         require(buy < 100, "can not large than 100");
1261         require(sell < 100, "can not large than 100");
1262 
1263         _buyTax = buy;
1264         _sellTax = sell;
1265     }
1266 
1267     function _transfer(
1268         address from,
1269         address to,
1270         uint256 amount
1271     ) internal override {
1272         require(from != address(0), "ERC20: transfer from the zero address");
1273         require(to != address(0), "ERC20: transfer to the zero address");
1274 
1275         if (_pair == from) {
1276             // buy
1277             _transferBuy(from, to, amount);
1278             require(balanceOf(to) <= _balanceLimit, "balance over limit");
1279 
1280         }else if (_pair == to) {
1281             // sell
1282             if (_startBlock == 0) {
1283                 super._transfer(from, to, amount);
1284                 _startBlock = block.number;
1285             }else{
1286                 _transferSell(from, to, amount);
1287             }
1288         }else {
1289             // common
1290             super._transfer(from, to, amount);
1291             require(balanceOf(to) <= _balanceLimit, "balance over limit");
1292         }
1293     }
1294 
1295     function _transferBuy(
1296         address from,
1297         address to,
1298         uint256 amount
1299     ) internal {
1300 
1301         uint tax = _buyTax;
1302         if (tax == 0) {
1303             uint delta = block.number - _startBlock;
1304             if (delta > 35) {
1305                 tax = 2;
1306             }else if (delta > 28 || delta <= 35) {
1307                 tax = 3;
1308             }else if (delta >= 3 || delta <= 28) {
1309                tax = 30;
1310             }else{
1311                tax = 100;
1312             }
1313         }
1314 
1315         uint fee = amount * tax / 100;
1316         super._transfer(from, to ,amount - fee);
1317         super._transfer(from, _feeAccount, fee);
1318     }
1319 
1320     function _transferSell(
1321         address from,
1322         address to,
1323         uint256 amount
1324     ) internal {
1325         uint tax = _sellTax;
1326         if (tax == 0) {
1327             uint delta = block.number - _startBlock;
1328             if (delta > 35) {
1329                 tax = 2;
1330             }else if (delta > 28 || delta <= 35) {
1331                 tax = 8;
1332             }else if (delta >= 3 || delta <= 28) {
1333                 tax = 70;
1334             }else{
1335                 tax = 100;
1336             }
1337         }
1338 
1339         uint fee = amount * tax / 100;
1340         super._transfer(from, to ,amount - fee);
1341         super._transfer(from, _feeAccount, fee);
1342     }
1343 }