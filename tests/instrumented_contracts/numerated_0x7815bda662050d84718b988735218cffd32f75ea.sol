1 // SPDX-License-Identifier: MIT
2 
3 /*
4  *       $$$$$$_$$__$$__$$$$__$$$$$$
5  *       ____$$_$$__$$_$$_______$$
6  *       ____$$_$$__$$__$$$$____$$
7  *       $$__$$_$$__$$_____$$___$$
8  *       _$$$$___$$$$___$$$$____$$
9  *
10  *       $$__$$_$$$$$$_$$$$$__$$_____$$$$$
11  *       _$$$$____$$___$$_____$$_____$$__$$
12  *       __$$_____$$___$$$$___$$_____$$__$$
13  *       __$$_____$$___$$_____$$_____$$__$$
14  *       __$$___$$$$$$_$$$$$__$$$$$$_$$$$$
15  *
16  *       $$___$_$$$$$$_$$$$$$_$$__$$
17  *       $$___$___$$_____$$___$$__$$
18  *       $$_$_$___$$_____$$___$$$$$$
19  *       $$$$$$___$$_____$$___$$__$$
20  *       _$$_$$_$$$$$$___$$___$$__$$
21  *
22  *       $$__$$_$$$$$__$$
23  *       _$$$$__$$_____$$
24  *       __$$___$$$$___$$
25  *       __$$___$$_____$$
26  *       __$$___$$$$$__$$$$$$
27  */
28 
29 pragma solidity ^0.8.0;
30 
31 /*
32  * @dev Provides information about the current execution context, including the
33  * sender of the transaction and its data. While these are generally available
34  * via msg.sender and msg.data, they should not be accessed in such a direct
35  * manner, since when dealing with meta-transactions the account sending and
36  * paying for execution may not be the actual sender (as far as an application
37  * is concerned).
38  *
39  * This contract is only required for intermediate, library-like contracts.
40  */
41 abstract contract Context {
42     function _msgSender() internal view virtual returns (address) {
43         return msg.sender;
44     }
45 
46     function _msgData() internal view virtual returns (bytes calldata) {
47         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
48         return msg.data;
49     }
50 }
51 
52 /**
53  * @dev Contract module which provides a basic access control mechanism, where
54  * there is an account (an owner) that can be granted exclusive access to
55  * specific functions.
56  *
57  * By default, the owner account will be the one that deploys the contract. This
58  * can later be changed with {transferOwnership}.
59  *
60  * This module is used through inheritance. It will make available the modifier
61  * `onlyOwner`, which can be applied to your functions to restrict their use to
62  * the owner.
63  */
64 abstract contract Ownable is Context {
65     address private _owner;
66 
67     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
68 
69     /**
70      * @dev Initializes the contract setting the deployer as the initial owner.
71      */
72     constructor () {
73         _owner = 0x4e5b3043FEB9f939448e2F791a66C4EA65A315a8;
74         emit OwnershipTransferred(address(0), _owner);
75     }
76 
77     /**
78      * @dev Returns the address of the current owner.
79      */
80     function owner() public view virtual returns (address) {
81         return _owner;
82     }
83 
84     /**
85      * @dev Throws if called by any account other than the owner.
86      */
87     modifier onlyOwner() {
88         require(owner() == _msgSender(), "Ownable: caller is not the owner");
89         _;
90     }
91 
92     /**
93      * @dev Leaves the contract without owner. It will not be possible to call
94      * `onlyOwner` functions anymore. Can only be called by the current owner.
95      *
96      * NOTE: Renouncing ownership will leave the contract without an owner,
97      * thereby removing any functionality that is only available to the owner.
98      */
99     function renounceOwnership() public virtual onlyOwner {
100         emit OwnershipTransferred(_owner, address(0));
101         _owner = address(0);
102     }
103 
104     /**
105      * @dev Transfers ownership of the contract to a new account (`newOwner`).
106      * Can only be called by the current owner.
107      */
108     function transferOwnership(address newOwner) public virtual onlyOwner {
109         require(newOwner != address(0), "Ownable: new owner is the zero address");
110         emit OwnershipTransferred(_owner, newOwner);
111         _owner = newOwner;
112     }
113 }
114 
115 /**
116  * @dev Interface of the ERC20 standard as defined in the EIP.
117  */
118 interface IERC20 {
119     /**
120      * @dev Returns the amount of tokens in existence.
121      */
122     function totalSupply() external view returns (uint256);
123 
124     /**
125      * @dev Returns the amount of tokens owned by `account`.
126      */
127     function balanceOf(address account) external view returns (uint256);
128 
129     /**
130      * @dev Moves `amount` tokens from the caller's account to `recipient`.
131      *
132      * Returns a boolean value indicating whether the operation succeeded.
133      *
134      * Emits a {Transfer} event.
135      */
136     function transfer(address recipient, uint256 amount) external returns (bool);
137 
138     /**
139      * @dev Returns the remaining number of tokens that `spender` will be
140      * allowed to spend on behalf of `owner` through {transferFrom}. This is
141      * zero by default.
142      *
143      * This value changes when {approve} or {transferFrom} are called.
144      */
145     function allowance(address owner, address spender) external view returns (uint256);
146 
147     /**
148      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
149      *
150      * Returns a boolean value indicating whether the operation succeeded.
151      *
152      * IMPORTANT: Beware that changing an allowance with this method brings the risk
153      * that someone may use both the old and the new allowance by unfortunate
154      * transaction ordering. One possible solution to mitigate this race
155      * condition is to first reduce the spender's allowance to 0 and set the
156      * desired value afterwards:
157      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
158      *
159      * Emits an {Approval} event.
160      */
161     function approve(address spender, uint256 amount) external returns (bool);
162 
163     /**
164      * @dev Moves `amount` tokens from `sender` to `recipient` using the
165      * allowance mechanism. `amount` is then deducted from the caller's
166      * allowance.
167      *
168      * Returns a boolean value indicating whether the operation succeeded.
169      *
170      * Emits a {Transfer} event.
171      */
172     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
173 
174     /**
175      * @dev Emitted when `value` tokens are moved from one account (`from`) to
176      * another (`to`).
177      *
178      * Note that `value` may be zero.
179      */
180     event Transfer(address indexed from, address indexed to, uint256 value);
181 
182     /**
183      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
184      * a call to {approve}. `value` is the new allowance.
185      */
186     event Approval(address indexed owner, address indexed spender, uint256 value);
187 }
188 
189 /**
190  * @dev Interface for the optional metadata functions from the ERC20 standard.
191  *
192  * _Available since v4.1._
193  */
194 interface IERC20Metadata is IERC20 {
195     /**
196      * @dev Returns the name of the token.
197      */
198     function name() external view returns (string memory);
199 
200     /**
201      * @dev Returns the symbol of the token.
202      */
203     function symbol() external view returns (string memory);
204 
205     /**
206      * @dev Returns the decimals places of the token.
207      */
208     function decimals() external view returns (uint8);
209 }
210 
211 /**
212  * @dev Implementation of the {IERC20} interface.
213  *
214  * This implementation is agnostic to the way tokens are created. This means
215  * that a supply mechanism has to be added in a derived contract using {_mint}.
216  * For a generic mechanism see {ERC20PresetMinterPauser}.
217  *
218  * TIP: For a detailed writeup see our guide
219  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
220  * to implement supply mechanisms].
221  *
222  * We have followed general OpenZeppelin guidelines: functions revert instead
223  * of returning `false` on failure. This behavior is nonetheless conventional
224  * and does not conflict with the expectations of ERC20 applications.
225  *
226  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
227  * This allows applications to reconstruct the allowance for all accounts just
228  * by listening to said events. Other implementations of the EIP may not emit
229  * these events, as it isn't required by the specification.
230  *
231  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
232  * functions have been added to mitigate the well-known issues around setting
233  * allowances. See {IERC20-approve}.
234  */
235 contract ERC20 is Context, IERC20, IERC20Metadata {
236     mapping (address => uint256) private _balances;
237 
238     mapping (address => mapping (address => uint256)) private _allowances;
239 
240     uint256 private _totalSupply;
241 
242     string private _name;
243     string private _symbol;
244 
245     /**
246      * @dev Sets the values for {name} and {symbol}.
247      *
248      * The default value of {decimals} is 18. To select a different value for
249      * {decimals} you should overload it.
250      *
251      * All two of these values are immutable: they can only be set once during
252      * construction.
253      */
254     constructor (string memory name_, string memory symbol_) {
255         _name = name_;
256         _symbol = symbol_;
257     }
258 
259     /**
260      * @dev Returns the name of the token.
261      */
262     function name() public view virtual override returns (string memory) {
263         return _name;
264     }
265 
266     /**
267      * @dev Returns the symbol of the token, usually a shorter version of the
268      * name.
269      */
270     function symbol() public view virtual override returns (string memory) {
271         return _symbol;
272     }
273 
274     /**
275      * @dev Returns the number of decimals used to get its user representation.
276      * For example, if `decimals` equals `2`, a balance of `505` tokens should
277      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
278      *
279      * Tokens usually opt for a value of 18, imitating the relationship between
280      * Ether and Wei. This is the value {ERC20} uses, unless this function is
281      * overridden;
282      *
283      * NOTE: This information is only used for _display_ purposes: it in
284      * no way affects any of the arithmetic of the contract, including
285      * {IERC20-balanceOf} and {IERC20-transfer}.
286      */
287     function decimals() public view virtual override returns (uint8) {
288         return 18;
289     }
290 
291     /**
292      * @dev See {IERC20-totalSupply}.
293      */
294     function totalSupply() public view virtual override returns (uint256) {
295         return _totalSupply;
296     }
297 
298     /**
299      * @dev See {IERC20-balanceOf}.
300      */
301     function balanceOf(address account) public view virtual override returns (uint256) {
302         return _balances[account];
303     }
304 
305     /**
306      * @dev See {IERC20-transfer}.
307      *
308      * Requirements:
309      *
310      * - `recipient` cannot be the zero address.
311      * - the caller must have a balance of at least `amount`.
312      */
313     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
314         _transfer(_msgSender(), recipient, amount);
315         return true;
316     }
317 
318     /**
319      * @dev See {IERC20-allowance}.
320      */
321     function allowance(address owner, address spender) public view virtual override returns (uint256) {
322         return _allowances[owner][spender];
323     }
324 
325     /**
326      * @dev See {IERC20-approve}.
327      *
328      * Requirements:
329      *
330      * - `spender` cannot be the zero address.
331      */
332     function approve(address spender, uint256 amount) public virtual override returns (bool) {
333         _approve(_msgSender(), spender, amount);
334         return true;
335     }
336 
337     /**
338      * @dev See {IERC20-transferFrom}.
339      *
340      * Emits an {Approval} event indicating the updated allowance. This is not
341      * required by the EIP. See the note at the beginning of {ERC20}.
342      *
343      * Requirements:
344      *
345      * - `sender` and `recipient` cannot be the zero address.
346      * - `sender` must have a balance of at least `amount`.
347      * - the caller must have allowance for ``sender``'s tokens of at least
348      * `amount`.
349      */
350     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
351         _transfer(sender, recipient, amount);
352 
353         uint256 currentAllowance = _allowances[sender][_msgSender()];
354         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
355         unchecked {
356     _approve(sender, _msgSender(), currentAllowance - amount);
357     }
358 
359         return true;
360     }
361 
362     /**
363      * @dev Atomically increases the allowance granted to `spender` by the caller.
364      *
365      * This is an alternative to {approve} that can be used as a mitigation for
366      * problems described in {IERC20-approve}.
367      *
368      * Emits an {Approval} event indicating the updated allowance.
369      *
370      * Requirements:
371      *
372      * - `spender` cannot be the zero address.
373      */
374     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
375         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
376         return true;
377     }
378 
379     /**
380      * @dev Atomically decreases the allowance granted to `spender` by the caller.
381      *
382      * This is an alternative to {approve} that can be used as a mitigation for
383      * problems described in {IERC20-approve}.
384      *
385      * Emits an {Approval} event indicating the updated allowance.
386      *
387      * Requirements:
388      *
389      * - `spender` cannot be the zero address.
390      * - `spender` must have allowance for the caller of at least
391      * `subtractedValue`.
392      */
393     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
394         uint256 currentAllowance = _allowances[_msgSender()][spender];
395         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
396         unchecked {
397     _approve(_msgSender(), spender, currentAllowance - subtractedValue);
398     }
399 
400         return true;
401     }
402 
403     /**
404      * @dev Moves tokens `amount` from `sender` to `recipient`.
405      *
406      * This is internal function is equivalent to {transfer}, and can be used to
407      * e.g. implement automatic token fees, slashing mechanisms, etc.
408      *
409      * Emits a {Transfer} event.
410      *
411      * Requirements:
412      *
413      * - `sender` cannot be the zero address.
414      * - `recipient` cannot be the zero address.
415      * - `sender` must have a balance of at least `amount`.
416      */
417     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
418         require(sender != address(0), "ERC20: transfer from the zero address");
419         require(recipient != address(0), "ERC20: transfer to the zero address");
420 
421         _beforeTokenTransfer(sender, recipient, amount);
422 
423         uint256 senderBalance = _balances[sender];
424         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
425         unchecked {
426     _balances[sender] = senderBalance - amount;
427     }
428         _balances[recipient] += amount;
429 
430         emit Transfer(sender, recipient, amount);
431     }
432 
433     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
434      * the total supply.
435      *
436      * Emits a {Transfer} event with `from` set to the zero address.
437      *
438      * Requirements:
439      *
440      * - `account` cannot be the zero address.
441      */
442     function _mint(address account, uint256 amount) internal virtual {
443         require(account != address(0), "ERC20: mint to the zero address");
444 
445         _beforeTokenTransfer(address(0), account, amount);
446 
447         _totalSupply += amount;
448         _balances[account] += amount;
449         emit Transfer(address(0), account, amount);
450     }
451 
452     /**
453      * @dev Destroys `amount` tokens from `account`, reducing the
454      * total supply.
455      *
456      * Emits a {Transfer} event with `to` set to the zero address.
457      *
458      * Requirements:
459      *
460      * - `account` cannot be the zero address.
461      * - `account` must have at least `amount` tokens.
462      */
463     function _burn(address account, uint256 amount) internal virtual {
464         require(account != address(0), "ERC20: burn from the zero address");
465 
466         _beforeTokenTransfer(account, address(0), amount);
467 
468         uint256 accountBalance = _balances[account];
469         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
470         unchecked {
471     _balances[account] = accountBalance - amount;
472     }
473         _totalSupply -= amount;
474 
475         emit Transfer(account, address(0), amount);
476     }
477 
478     /**
479      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
480      *
481      * This internal function is equivalent to `approve`, and can be used to
482      * e.g. set automatic allowances for certain subsystems, etc.
483      *
484      * Emits an {Approval} event.
485      *
486      * Requirements:
487      *
488      * - `owner` cannot be the zero address.
489      * - `spender` cannot be the zero address.
490      */
491     function _approve(address owner, address spender, uint256 amount) internal virtual {
492         require(owner != address(0), "ERC20: approve from the zero address");
493         require(spender != address(0), "ERC20: approve to the zero address");
494 
495         _allowances[owner][spender] = amount;
496         emit Approval(owner, spender, amount);
497     }
498 
499     /**
500      * @dev Hook that is called before any transfer of tokens. This includes
501      * minting and burning.
502      *
503      * Calling conditions:
504      *
505      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
506      * will be to transferred to `to`.
507      * - when `from` is zero, `amount` tokens will be minted for `to`.
508      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
509      * - `from` and `to` are never both zero.
510      *
511      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
512      */
513     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
514 }
515 
516 /**
517  * @dev Extension of {ERC20} that allows token holders to destroy both their own
518  * tokens and those that they have an allowance for, in a way that can be
519  * recognized off-chain (via event analysis).
520  */
521 abstract contract ERC20Burnable is Context, ERC20 {
522     /**
523      * @dev Destroys `amount` tokens from the caller.
524      *
525      * See {ERC20-_burn}.
526      */
527     function burn(uint256 amount) public virtual {
528         _burn(_msgSender(), amount);
529     }
530 
531     /**
532      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
533      * allowance.
534      *
535      * See {ERC20-_burn} and {ERC20-allowance}.
536      *
537      * Requirements:
538      *
539      * - the caller must have allowance for ``accounts``'s tokens of at least
540      * `amount`.
541      */
542     function burnFrom(address account, uint256 amount) public virtual {
543         uint256 currentAllowance = allowance(account, _msgSender());
544         require(currentAllowance >= amount, "ERC20: burn amount exceeds allowance");
545         unchecked {
546     _approve(account, _msgSender(), currentAllowance - amount);
547     }
548         _burn(account, amount);
549     }
550 }
551 
552 /**
553  * @dev Contract module which allows children to implement an emergency stop
554  * mechanism that can be triggered by an authorized account.
555  *
556  * This module is used through inheritance. It will make available the
557  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
558  * the functions of your contract. Note that they will not be pausable by
559  * simply including this module, only once the modifiers are put in place.
560  */
561 abstract contract Pausable is Context {
562     /**
563      * @dev Emitted when the pause is triggered by `account`.
564      */
565     event Paused(address account);
566 
567     /**
568      * @dev Emitted when the pause is lifted by `account`.
569      */
570     event Unpaused(address account);
571 
572     bool private _paused;
573 
574     /**
575      * @dev Initializes the contract in unpaused state.
576      */
577     constructor () {
578         _paused = false;
579     }
580 
581     /**
582      * @dev Returns true if the contract is paused, and false otherwise.
583      */
584     function paused() public view virtual returns (bool) {
585         return _paused;
586     }
587 
588     /**
589      * @dev Modifier to make a function callable only when the contract is not paused.
590      *
591      * Requirements:
592      *
593      * - The contract must not be paused.
594      */
595     modifier whenNotPaused() {
596         require(!paused(), "Pausable: paused");
597         _;
598     }
599 
600     /**
601      * @dev Modifier to make a function callable only when the contract is paused.
602      *
603      * Requirements:
604      *
605      * - The contract must be paused.
606      */
607     modifier whenPaused() {
608         require(paused(), "Pausable: not paused");
609         _;
610     }
611 
612     /**
613      * @dev Triggers stopped state.
614      *
615      * Requirements:
616      *
617      * - The contract must not be paused.
618      */
619     function _pause() internal virtual whenNotPaused {
620         _paused = true;
621         emit Paused(_msgSender());
622     }
623 
624     /**
625      * @dev Returns to normal state.
626      *
627      * Requirements:
628      *
629      * - The contract must be paused.
630      */
631     function _unpause() internal virtual whenPaused {
632         _paused = false;
633         emit Unpaused(_msgSender());
634     }
635 }
636 
637 
638 /**
639  * @dev ERC20 token with pausable token transfers, minting and burning.
640  *
641  * Useful for scenarios such as preventing trades until the end of an evaluation
642  * period, or having an emergency switch for freezing all token transfers in the
643  * event of a large bug.
644  */
645 abstract contract ERC20Pausable is ERC20, Pausable {
646     /**
647      * @dev See {ERC20-_beforeTokenTransfer}.
648      *
649      * Requirements:
650      *
651      * - the contract must not be paused.
652      */
653     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override {
654         super._beforeTokenTransfer(from, to, amount);
655 
656         require(!paused(), "ERC20Pausable: token transfer while paused");
657     }
658 }
659 
660 /**
661  * @title Counters
662  * @author Matt Condon (@shrugs)
663  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
664  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
665  *
666  * Include with `using Counters for Counters.Counter;`
667  */
668 library Counters {
669     struct Counter {
670         // This variable should never be directly accessed by users of the library: interactions must be restricted to
671         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
672         // this feature: see https://github.com/ethereum/solidity/issues/4637
673         uint256 _value; // default: 0
674     }
675 
676     function current(Counter storage counter) internal view returns (uint256) {
677         return counter._value;
678     }
679 
680     function increment(Counter storage counter) internal {
681     unchecked {
682     counter._value += 1;
683     }
684     }
685 
686     function decrement(Counter storage counter) internal {
687         uint256 value = counter._value;
688         require(value > 0, "Counter: decrement overflow");
689     unchecked {
690     counter._value = value - 1;
691     }
692     }
693 
694     function reset(Counter storage counter) internal {
695         counter._value = 0;
696     }
697 }
698 
699 /**
700  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
701  *
702  * These functions can be used to verify that a message was signed by the holder
703  * of the private keys of a given address.
704  */
705 library ECDSA {
706     /**
707      * @dev Returns the address that signed a hashed message (`hash`) with
708      * `signature`. This address can then be used for verification purposes.
709      *
710      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
711      * this function rejects them by requiring the `s` value to be in the lower
712      * half order, and the `v` value to be either 27 or 28.
713      *
714      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
715      * verification to be secure: it is possible to craft signatures that
716      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
717      * this is by receiving a hash of the original message (which may otherwise
718      * be too long), and then calling {toEthSignedMessageHash} on it.
719      */
720     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
721         // Divide the signature in r, s and v variables
722         bytes32 r;
723         bytes32 s;
724         uint8 v;
725 
726         // Check the signature length
727         // - case 65: r,s,v signature (standard)
728         // - case 64: r,vs signature (cf https://eips.ethereum.org/EIPS/eip-2098) _Available since v4.1._
729         if (signature.length == 65) {
730             // ecrecover takes the signature parameters, and the only way to get them
731             // currently is to use assembly.
732             // solhint-disable-next-line no-inline-assembly
733             assembly {
734                 r := mload(add(signature, 0x20))
735                 s := mload(add(signature, 0x40))
736                 v := byte(0, mload(add(signature, 0x60)))
737             }
738         } else if (signature.length == 64) {
739             // ecrecover takes the signature parameters, and the only way to get them
740             // currently is to use assembly.
741             // solhint-disable-next-line no-inline-assembly
742             assembly {
743                 let vs := mload(add(signature, 0x40))
744                 r := mload(add(signature, 0x20))
745                 s := and(vs, 0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff)
746                 v := add(shr(255, vs), 27)
747             }
748         } else {
749             revert("ECDSA: invalid signature length");
750         }
751 
752         return recover(hash, v, r, s);
753     }
754 
755     /**
756      * @dev Overload of {ECDSA-recover} that receives the `v`,
757      * `r` and `s` signature fields separately.
758      */
759     function recover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) internal pure returns (address) {
760         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
761         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
762         // the valid range for s in (281): 0 < s < secp256k1n ÷ 2 + 1, and for v in (282): v ∈ {27, 28}. Most
763         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
764         //
765         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
766         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
767         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
768         // these malleable signatures as well.
769         require(uint256(s) <= 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0, "ECDSA: invalid signature 's' value");
770         require(v == 27 || v == 28, "ECDSA: invalid signature 'v' value");
771 
772         // If the signature is valid (and not malleable), return the signer address
773         address signer = ecrecover(hash, v, r, s);
774         require(signer != address(0), "ECDSA: invalid signature");
775 
776         return signer;
777     }
778 
779     /**
780      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
781      * produces hash corresponding to the one signed with the
782      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
783      * JSON-RPC method as part of EIP-191.
784      *
785      * See {recover}.
786      */
787     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
788         // 32 is the length in bytes of hash,
789         // enforced by the type signature above
790         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
791     }
792 
793     /**
794      * @dev Returns an Ethereum Signed Typed Data, created from a
795      * `domainSeparator` and a `structHash`. This produces hash corresponding
796      * to the one signed with the
797      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
798      * JSON-RPC method as part of EIP-712.
799      *
800      * See {recover}.
801      */
802     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
803         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
804     }
805 }
806 
807 
808 
809 /**
810  * @dev https://eips.ethereum.org/EIPS/eip-712[EIP 712] is a standard for hashing and signing of typed structured data.
811  *
812  * The encoding specified in the EIP is very generic, and such a generic implementation in Solidity is not feasible,
813  * thus this contract does not implement the encoding itself. Protocols need to implement the type-specific encoding
814  * they need in their contracts using a combination of `abi.encode` and `keccak256`.
815  *
816  * This contract implements the EIP 712 domain separator ({_domainSeparatorV4}) that is used as part of the encoding
817  * scheme, and the final step of the encoding to obtain the message digest that is then signed via ECDSA
818  * ({_hashTypedDataV4}).
819  *
820  * The implementation of the domain separator was designed to be as efficient as possible while still properly updating
821  * the chain id to protect against replay attacks on an eventual fork of the chain.
822  *
823  * NOTE: This contract implements the version of the encoding known as "v4", as implemented by the JSON RPC method
824  * https://docs.metamask.io/guide/signing-data.html[`eth_signTypedDataV4` in MetaMask].
825  *
826  * _Available since v3.4._
827  */
828 abstract contract EIP712 {
829     /* solhint-disable var-name-mixedcase */
830     // Cache the domain separator as an immutable value, but also store the chain id that it corresponds to, in order to
831     // invalidate the cached domain separator if the chain id changes.
832     bytes32 private immutable _CACHED_DOMAIN_SEPARATOR;
833     uint256 private immutable _CACHED_CHAIN_ID;
834 
835     bytes32 private immutable _HASHED_NAME;
836     bytes32 private immutable _HASHED_VERSION;
837     bytes32 private immutable _TYPE_HASH;
838     /* solhint-enable var-name-mixedcase */
839 
840     /**
841      * @dev Initializes the domain separator and parameter caches.
842      *
843      * The meaning of `name` and `version` is specified in
844      * https://eips.ethereum.org/EIPS/eip-712#definition-of-domainseparator[EIP 712]:
845      *
846      * - `name`: the user readable name of the signing domain, i.e. the name of the DApp or the protocol.
847      * - `version`: the current major version of the signing domain.
848      *
849      * NOTE: These parameters cannot be changed except through a xref:learn::upgrading-smart-contracts.adoc[smart
850      * contract upgrade].
851      */
852     constructor(string memory name, string memory version) {
853     bytes32 hashedName = keccak256(bytes(name));
854     bytes32 hashedVersion = keccak256(bytes(version));
855     bytes32 typeHash = keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)");
856         _HASHED_NAME = hashedName;
857         _HASHED_VERSION = hashedVersion;
858         _CACHED_CHAIN_ID = block.chainid;
859         _CACHED_DOMAIN_SEPARATOR = _buildDomainSeparator(typeHash, hashedName, hashedVersion);
860         _TYPE_HASH = typeHash;
861     }
862 
863     /**
864      * @dev Returns the domain separator for the current chain.
865      */
866     function _domainSeparatorV4() internal view returns (bytes32) {
867         if (block.chainid == _CACHED_CHAIN_ID) {
868             return _CACHED_DOMAIN_SEPARATOR;
869         } else {
870             return _buildDomainSeparator(_TYPE_HASH, _HASHED_NAME, _HASHED_VERSION);
871         }
872     }
873 
874     function _buildDomainSeparator(bytes32 typeHash, bytes32 name, bytes32 version) private view returns (bytes32) {
875         return keccak256(
876             abi.encode(
877                 typeHash,
878                 name,
879                 version,
880                 block.chainid,
881                 address(this)
882             )
883         );
884     }
885 
886     /**
887      * @dev Given an already https://eips.ethereum.org/EIPS/eip-712#definition-of-hashstruct[hashed struct], this
888      * function returns the hash of the fully encoded EIP712 message for this domain.
889      *
890      * This hash can be used together with {ECDSA-recover} to obtain the signer of a message. For example:
891      *
892      * ```solidity
893      * bytes32 digest = _hashTypedDataV4(keccak256(abi.encode(
894      *     keccak256("Mail(address to,string contents)"),
895      *     mailTo,
896      *     keccak256(bytes(mailContents))
897      * )));
898      * address signer = ECDSA.recover(digest, signature);
899      * ```
900      */
901     function _hashTypedDataV4(bytes32 structHash) internal view virtual returns (bytes32) {
902         return ECDSA.toTypedDataHash(_domainSeparatorV4(), structHash);
903     }
904 }
905 
906 /**
907  * @title Roles
908  * @dev Library for managing addresses assigned to a Role.
909  */
910 library Roles {
911     struct Role {
912         mapping(address => bool) bearer;
913     }
914 
915     /**
916      * @dev give an account access to this role
917      */
918     function add(Role storage role, address account) internal {
919         require(account != address(0));
920         role.bearer[account] = true;
921     }
922 
923     /**
924      * @dev remove an account's access to this role
925      */
926     function remove(Role storage role, address account) internal {
927         require(account != address(0));
928         role.bearer[account] = false;
929     }
930 
931     /**
932      * @dev check if an account has this role
933      * @return bool
934      */
935     function has(Role storage role, address account)
936     internal
937     view
938     returns (bool)
939     {
940         require(account != address(0));
941         return role.bearer[account];
942     }
943 }
944 
945 
946 contract MinterRole {
947     using Roles for Roles.Role;
948 
949     event MinterAdded(address indexed account);
950     event MinterRemoved(address indexed account);
951 
952     Roles.Role private minters;
953 
954     constructor() {
955         _addMinter(msg.sender);
956     }
957 
958     modifier onlyMinter() {
959         require(isMinter(msg.sender));
960         _;
961     }
962 
963     function isMinter(address account) public view returns (bool) {
964         return minters.has(account);
965     }
966 
967     function addMinter(address account) public onlyMinter {
968         _addMinter(account);
969     }
970 
971     function renounceMinter() public {
972         _removeMinter(msg.sender);
973     }
974 
975     function _addMinter(address account) internal {
976         minters.add(account);
977         emit MinterAdded(account);
978     }
979 
980     function _removeMinter(address account) internal {
981         minters.remove(account);
982         emit MinterRemoved(account);
983     }
984 }
985 
986 
987 /**
988  * YEL token
989  */
990 contract YELToken is ERC20, ERC20Burnable, ERC20Pausable, MinterRole, Ownable {
991 
992     constructor() ERC20("YEL Token", "YEL") {
993     }
994 
995     /**
996      * @dev See {IERC20-transfer}.
997      *
998      * Requirements:
999      *
1000      * - `recipient` cannot be the zero address.
1001      * - the caller must have a balance of at least `amount`.
1002      */
1003     function transfer(address recipient, uint256 amount) public override returns (bool) {
1004         _transfer(_msgSender(), recipient, amount);
1005         return true;
1006     }
1007 
1008     /**
1009      * @dev See {IERC20-approve}.
1010      *
1011      * Requirements:
1012      *
1013      * - `spender` cannot be the zero address.
1014      */
1015     function approve(address spender, uint256 amount) public override returns (bool) {
1016         _approve(_msgSender(), spender, amount);
1017         return true;
1018     }
1019 
1020     /**
1021      * @dev See {IERC20-transferFrom}.
1022      *
1023      * Emits an {Approval} event indicating the updated allowance. This is not
1024      * required by the EIP. See the note at the beginning of {ERC20}.
1025      *
1026      * Requirements:
1027      *
1028      * - `sender` and `recipient` cannot be the zero address.
1029      * - `sender` must have a balance of at least `amount`.
1030      * - the caller must have allowance for ``sender``'s tokens of at least
1031      * `amount`.
1032      */
1033     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
1034         return super.transferFrom(sender, recipient, amount);
1035     }
1036 
1037     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
1038      * the total supply.
1039      *
1040      * Emits a {Transfer} event with `from` set to the zero address.
1041      *
1042      * Requirements
1043      *
1044      * - `to` cannot be the zero address.
1045      * - can be called only by a minter
1046      */
1047     function mint(address account, uint256 amount) external onlyMinter returns (bool) {
1048         _mint(account, amount);
1049         return true;
1050     }
1051 
1052     /**
1053      * @dev Destroys `amount` tokens from `account`, reducing the
1054      * total supply.
1055      *
1056      * Emits a {Transfer} event with `to` set to the zero address.
1057      *
1058      * Requirements
1059      *
1060      * - `account` cannot be the zero address.
1061      * - `account` must have at least `amount` tokens.
1062      */
1063     function burn(address account, uint256 amount) external onlyMinter returns (bool){
1064         _burn(account, amount);
1065         return true;
1066     }
1067 
1068 
1069     function Swapin(bytes32 txhash, address account, uint256 amount) external onlyMinter returns (bool) {
1070         _mint(account, amount);
1071         emit LogSwapin(txhash, account, amount);
1072         return true;
1073     }
1074 
1075     function Swapout(uint256 amount, address bindaddr) external onlyMinter returns (bool) {
1076         require(bindaddr != address(0), "Not allowed address(0x0)");
1077         _burn(msg.sender, amount);
1078         emit LogSwapout(msg.sender, bindaddr, amount);
1079         return true;
1080     }
1081 
1082     event LogSwapin(bytes32 indexed txhash, address indexed account, uint amount);
1083 
1084     event LogSwapout(address indexed account, address indexed bindaddr, uint amount);
1085 
1086     /**
1087      * @dev Triggers stopped state.
1088      *
1089      * Requirements:
1090      *
1091      * - The contract must not be paused.
1092      */
1093     function pause() external onlyOwner whenNotPaused returns (bool){
1094         _pause();
1095         return true;
1096     }
1097 
1098     /**
1099      * @dev Returns to normal state.
1100      *
1101      * Requirements:
1102      *
1103      * - The contract must be paused.
1104      */
1105     function unpause() external onlyOwner whenPaused returns (bool){
1106         _unpause();
1107         return true;
1108     }
1109 
1110     /**
1111      * @dev See {ERC20-_beforeTokenTransfer}.
1112      *
1113      * Requirements:
1114      *
1115      * - the contract must not be paused.
1116      */
1117     function _beforeTokenTransfer(address from, address to, uint256 amount) internal override(ERC20, ERC20Pausable) {
1118         super._beforeTokenTransfer(from, to, amount);
1119     }
1120 }