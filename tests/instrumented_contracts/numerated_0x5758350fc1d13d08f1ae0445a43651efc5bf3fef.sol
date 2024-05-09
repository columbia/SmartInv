1 // SPDX-License-Identifier: MIT
2 
3 // File: @openzeppelin/contracts/utils/Context.sol
4 
5 
6 
7 pragma solidity ^0.8.0;
8 
9 /*
10  * @dev Provides information about the current execution context, including the
11  * sender of the transaction and its data. While these are generally available
12  * via msg.sender and msg.data, they should not be accessed in such a direct
13  * manner, since when dealing with meta-transactions the account sending and
14  * paying for execution may not be the actual sender (as far as an application
15  * is concerned).
16  *
17  * This contract is only required for intermediate, library-like contracts.
18  */
19 abstract contract Context {
20     function _msgSender() internal view virtual returns (address) {
21         return msg.sender;
22     }
23 
24     function _msgData() internal view virtual returns (bytes calldata) {
25         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
26         return msg.data;
27     }
28 }
29 
30 // File: @openzeppelin/contracts/access/Ownable.sol
31 
32 
33 
34 pragma solidity ^0.8.0;
35 
36 /**
37  * @dev Contract module which provides a basic access control mechanism, where
38  * there is an account (an owner) that can be granted exclusive access to
39  * specific functions.
40  *
41  * By default, the owner account will be the one that deploys the contract. This
42  * can later be changed with {transferOwnership}.
43  *
44  * This module is used through inheritance. It will make available the modifier
45  * `onlyOwner`, which can be applied to your functions to restrict their use to
46  * the owner.
47  */
48 abstract contract Ownable is Context {
49     address private _owner;
50 
51     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
52 
53     /**
54      * @dev Initializes the contract setting the deployer as the initial owner.
55      */
56     constructor () {
57         address msgSender = _msgSender();
58         _owner = msgSender;
59         emit OwnershipTransferred(address(0), msgSender);
60     }
61 
62     /**
63      * @dev Returns the address of the current owner.
64      */
65     function owner() public view virtual returns (address) {
66         return _owner;
67     }
68 
69     /**
70      * @dev Throws if called by any account other than the owner.
71      */
72     modifier onlyOwner() {
73         require(owner() == _msgSender(), "Ownable: caller is not the owner");
74         _;
75     }
76 
77     /**
78      * @dev Leaves the contract without owner. It will not be possible to call
79      * `onlyOwner` functions anymore. Can only be called by the current owner.
80      *
81      * NOTE: Renouncing ownership will leave the contract without an owner,
82      * thereby removing any functionality that is only available to the owner.
83      */
84     function renounceOwnership() public virtual onlyOwner {
85         emit OwnershipTransferred(_owner, address(0));
86         _owner = address(0);
87     }
88 
89     /**
90      * @dev Transfers ownership of the contract to a new account (`newOwner`).
91      * Can only be called by the current owner.
92      */
93     function transferOwnership(address newOwner) public virtual onlyOwner {
94         require(newOwner != address(0), "Ownable: new owner is the zero address");
95         emit OwnershipTransferred(_owner, newOwner);
96         _owner = newOwner;
97     }
98 }
99 
100 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
101 
102 
103 
104 pragma solidity ^0.8.0;
105 
106 /**
107  * @dev Interface of the ERC20 standard as defined in the EIP.
108  */
109 interface IERC20 {
110     /**
111      * @dev Returns the amount of tokens in existence.
112      */
113     function totalSupply() external view returns (uint256);
114 
115     /**
116      * @dev Returns the amount of tokens owned by `account`.
117      */
118     function balanceOf(address account) external view returns (uint256);
119 
120     /**
121      * @dev Moves `amount` tokens from the caller's account to `recipient`.
122      *
123      * Returns a boolean value indicating whether the operation succeeded.
124      *
125      * Emits a {Transfer} event.
126      */
127     function transfer(address recipient, uint256 amount) external returns (bool);
128 
129     /**
130      * @dev Returns the remaining number of tokens that `spender` will be
131      * allowed to spend on behalf of `owner` through {transferFrom}. This is
132      * zero by default.
133      *
134      * This value changes when {approve} or {transferFrom} are called.
135      */
136     function allowance(address owner, address spender) external view returns (uint256);
137 
138     /**
139      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
140      *
141      * Returns a boolean value indicating whether the operation succeeded.
142      *
143      * IMPORTANT: Beware that changing an allowance with this method brings the risk
144      * that someone may use both the old and the new allowance by unfortunate
145      * transaction ordering. One possible solution to mitigate this race
146      * condition is to first reduce the spender's allowance to 0 and set the
147      * desired value afterwards:
148      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
149      *
150      * Emits an {Approval} event.
151      */
152     function approve(address spender, uint256 amount) external returns (bool);
153 
154     /**
155      * @dev Moves `amount` tokens from `sender` to `recipient` using the
156      * allowance mechanism. `amount` is then deducted from the caller's
157      * allowance.
158      *
159      * Returns a boolean value indicating whether the operation succeeded.
160      *
161      * Emits a {Transfer} event.
162      */
163     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
164 
165     /**
166      * @dev Emitted when `value` tokens are moved from one account (`from`) to
167      * another (`to`).
168      *
169      * Note that `value` may be zero.
170      */
171     event Transfer(address indexed from, address indexed to, uint256 value);
172 
173     /**
174      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
175      * a call to {approve}. `value` is the new allowance.
176      */
177     event Approval(address indexed owner, address indexed spender, uint256 value);
178 }
179 
180 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
181 
182 
183 
184 pragma solidity ^0.8.0;
185 
186 
187 /**
188  * @dev Interface for the optional metadata functions from the ERC20 standard.
189  *
190  * _Available since v4.1._
191  */
192 interface IERC20Metadata is IERC20 {
193     /**
194      * @dev Returns the name of the token.
195      */
196     function name() external view returns (string memory);
197 
198     /**
199      * @dev Returns the symbol of the token.
200      */
201     function symbol() external view returns (string memory);
202 
203     /**
204      * @dev Returns the decimals places of the token.
205      */
206     function decimals() external view returns (uint8);
207 }
208 
209 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
210 
211 
212 
213 pragma solidity ^0.8.0;
214 
215 
216 
217 
218 /**
219  * @dev Implementation of the {IERC20} interface.
220  *
221  * This implementation is agnostic to the way tokens are created. This means
222  * that a supply mechanism has to be added in a derived contract using {_mint}.
223  * For a generic mechanism see {ERC20PresetMinterPauser}.
224  *
225  * TIP: For a detailed writeup see our guide
226  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
227  * to implement supply mechanisms].
228  *
229  * We have followed general OpenZeppelin guidelines: functions revert instead
230  * of returning `false` on failure. This behavior is nonetheless conventional
231  * and does not conflict with the expectations of ERC20 applications.
232  *
233  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
234  * This allows applications to reconstruct the allowance for all accounts just
235  * by listening to said events. Other implementations of the EIP may not emit
236  * these events, as it isn't required by the specification.
237  *
238  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
239  * functions have been added to mitigate the well-known issues around setting
240  * allowances. See {IERC20-approve}.
241  */
242 contract ERC20 is Context, IERC20, IERC20Metadata {
243     mapping (address => uint256) private _balances;
244 
245     mapping (address => mapping (address => uint256)) private _allowances;
246 
247     uint256 private _totalSupply;
248 
249     string private _name;
250     string private _symbol;
251 
252     /**
253      * @dev Sets the values for {name} and {symbol}.
254      *
255      * The defaut value of {decimals} is 18. To select a different value for
256      * {decimals} you should overload it.
257      *
258      * All two of these values are immutable: they can only be set once during
259      * construction.
260      */
261     constructor (string memory name_, string memory symbol_) {
262         _name = name_;
263         _symbol = symbol_;
264     }
265 
266     /**
267      * @dev Returns the name of the token.
268      */
269     function name() public view virtual override returns (string memory) {
270         return _name;
271     }
272 
273     /**
274      * @dev Returns the symbol of the token, usually a shorter version of the
275      * name.
276      */
277     function symbol() public view virtual override returns (string memory) {
278         return _symbol;
279     }
280 
281     /**
282      * @dev Returns the number of decimals used to get its user representation.
283      * For example, if `decimals` equals `2`, a balance of `505` tokens should
284      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
285      *
286      * Tokens usually opt for a value of 18, imitating the relationship between
287      * Ether and Wei. This is the value {ERC20} uses, unless this function is
288      * overridden;
289      *
290      * NOTE: This information is only used for _display_ purposes: it in
291      * no way affects any of the arithmetic of the contract, including
292      * {IERC20-balanceOf} and {IERC20-transfer}.
293      */
294     function decimals() public view virtual override returns (uint8) {
295         return 18;
296     }
297 
298     /**
299      * @dev See {IERC20-totalSupply}.
300      */
301     function totalSupply() public view virtual override returns (uint256) {
302         return _totalSupply;
303     }
304 
305     /**
306      * @dev See {IERC20-balanceOf}.
307      */
308     function balanceOf(address account) public view virtual override returns (uint256) {
309         return _balances[account];
310     }
311 
312     /**
313      * @dev See {IERC20-transfer}.
314      *
315      * Requirements:
316      *
317      * - `recipient` cannot be the zero address.
318      * - the caller must have a balance of at least `amount`.
319      */
320     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
321         _transfer(_msgSender(), recipient, amount);
322         return true;
323     }
324 
325     /**
326      * @dev See {IERC20-allowance}.
327      */
328     function allowance(address owner, address spender) public view virtual override returns (uint256) {
329         return _allowances[owner][spender];
330     }
331 
332     /**
333      * @dev See {IERC20-approve}.
334      *
335      * Requirements:
336      *
337      * - `spender` cannot be the zero address.
338      */
339     function approve(address spender, uint256 amount) public virtual override returns (bool) {
340         _approve(_msgSender(), spender, amount);
341         return true;
342     }
343 
344     /**
345      * @dev See {IERC20-transferFrom}.
346      *
347      * Emits an {Approval} event indicating the updated allowance. This is not
348      * required by the EIP. See the note at the beginning of {ERC20}.
349      *
350      * Requirements:
351      *
352      * - `sender` and `recipient` cannot be the zero address.
353      * - `sender` must have a balance of at least `amount`.
354      * - the caller must have allowance for ``sender``'s tokens of at least
355      * `amount`.
356      */
357     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
358         _transfer(sender, recipient, amount);
359 
360         uint256 currentAllowance = _allowances[sender][_msgSender()];
361         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
362         _approve(sender, _msgSender(), currentAllowance - amount);
363 
364         return true;
365     }
366 
367     /**
368      * @dev Atomically increases the allowance granted to `spender` by the caller.
369      *
370      * This is an alternative to {approve} that can be used as a mitigation for
371      * problems described in {IERC20-approve}.
372      *
373      * Emits an {Approval} event indicating the updated allowance.
374      *
375      * Requirements:
376      *
377      * - `spender` cannot be the zero address.
378      */
379     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
380         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
381         return true;
382     }
383 
384     /**
385      * @dev Atomically decreases the allowance granted to `spender` by the caller.
386      *
387      * This is an alternative to {approve} that can be used as a mitigation for
388      * problems described in {IERC20-approve}.
389      *
390      * Emits an {Approval} event indicating the updated allowance.
391      *
392      * Requirements:
393      *
394      * - `spender` cannot be the zero address.
395      * - `spender` must have allowance for the caller of at least
396      * `subtractedValue`.
397      */
398     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
399         uint256 currentAllowance = _allowances[_msgSender()][spender];
400         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
401         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
402 
403         return true;
404     }
405 
406     /**
407      * @dev Moves tokens `amount` from `sender` to `recipient`.
408      *
409      * This is internal function is equivalent to {transfer}, and can be used to
410      * e.g. implement automatic token fees, slashing mechanisms, etc.
411      *
412      * Emits a {Transfer} event.
413      *
414      * Requirements:
415      *
416      * - `sender` cannot be the zero address.
417      * - `recipient` cannot be the zero address.
418      * - `sender` must have a balance of at least `amount`.
419      */
420     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
421         require(sender != address(0), "ERC20: transfer from the zero address");
422         require(recipient != address(0), "ERC20: transfer to the zero address");
423 
424         _beforeTokenTransfer(sender, recipient, amount);
425 
426         uint256 senderBalance = _balances[sender];
427         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
428         _balances[sender] = senderBalance - amount;
429         _balances[recipient] += amount;
430 
431         emit Transfer(sender, recipient, amount);
432     }
433 
434     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
435      * the total supply.
436      *
437      * Emits a {Transfer} event with `from` set to the zero address.
438      *
439      * Requirements:
440      *
441      * - `to` cannot be the zero address.
442      */
443     function _mint(address account, uint256 amount) internal virtual {
444         require(account != address(0), "ERC20: mint to the zero address");
445 
446         _beforeTokenTransfer(address(0), account, amount);
447 
448         _totalSupply += amount;
449         _balances[account] += amount;
450         emit Transfer(address(0), account, amount);
451     }
452 
453     /**
454      * @dev Destroys `amount` tokens from `account`, reducing the
455      * total supply.
456      *
457      * Emits a {Transfer} event with `to` set to the zero address.
458      *
459      * Requirements:
460      *
461      * - `account` cannot be the zero address.
462      * - `account` must have at least `amount` tokens.
463      */
464     function _burn(address account, uint256 amount) internal virtual {
465         require(account != address(0), "ERC20: burn from the zero address");
466 
467         _beforeTokenTransfer(account, address(0), amount);
468 
469         uint256 accountBalance = _balances[account];
470         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
471         _balances[account] = accountBalance - amount;
472         _totalSupply -= amount;
473 
474         emit Transfer(account, address(0), amount);
475     }
476 
477     /**
478      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
479      *
480      * This internal function is equivalent to `approve`, and can be used to
481      * e.g. set automatic allowances for certain subsystems, etc.
482      *
483      * Emits an {Approval} event.
484      *
485      * Requirements:
486      *
487      * - `owner` cannot be the zero address.
488      * - `spender` cannot be the zero address.
489      */
490     function _approve(address owner, address spender, uint256 amount) internal virtual {
491         require(owner != address(0), "ERC20: approve from the zero address");
492         require(spender != address(0), "ERC20: approve to the zero address");
493 
494         _allowances[owner][spender] = amount;
495         emit Approval(owner, spender, amount);
496     }
497 
498     /**
499      * @dev Hook that is called before any transfer of tokens. This includes
500      * minting and burning.
501      *
502      * Calling conditions:
503      *
504      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
505      * will be to transferred to `to`.
506      * - when `from` is zero, `amount` tokens will be minted for `to`.
507      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
508      * - `from` and `to` are never both zero.
509      *
510      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
511      */
512     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
513 }
514 
515 // File: @openzeppelin/contracts/token/ERC20/extensions/ERC20Capped.sol
516 
517 
518 
519 pragma solidity ^0.8.0;
520 
521 
522 /**
523  * @dev Extension of {ERC20} that adds a cap to the supply of tokens.
524  */
525 abstract contract ERC20Capped is ERC20 {
526     uint256 immutable private _cap;
527 
528     /**
529      * @dev Sets the value of the `cap`. This value is immutable, it can only be
530      * set once during construction.
531      */
532     constructor (uint256 cap_) {
533         require(cap_ > 0, "ERC20Capped: cap is 0");
534         _cap = cap_;
535     }
536 
537     /**
538      * @dev Returns the cap on the token's total supply.
539      */
540     function cap() public view virtual returns (uint256) {
541         return _cap;
542     }
543 
544     /**
545      * @dev See {ERC20-_mint}.
546      */
547     function _mint(address account, uint256 amount) internal virtual override {
548         require(ERC20.totalSupply() + amount <= cap(), "ERC20Capped: cap exceeded");
549         super._mint(account, amount);
550     }
551 }
552 
553 // File: @openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol
554 
555 
556 
557 pragma solidity ^0.8.0;
558 
559 
560 
561 /**
562  * @dev Extension of {ERC20} that allows token holders to destroy both their own
563  * tokens and those that they have an allowance for, in a way that can be
564  * recognized off-chain (via event analysis).
565  */
566 abstract contract ERC20Burnable is Context, ERC20 {
567     /**
568      * @dev Destroys `amount` tokens from the caller.
569      *
570      * See {ERC20-_burn}.
571      */
572     function burn(uint256 amount) public virtual {
573         _burn(_msgSender(), amount);
574     }
575 
576     /**
577      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
578      * allowance.
579      *
580      * See {ERC20-_burn} and {ERC20-allowance}.
581      *
582      * Requirements:
583      *
584      * - the caller must have allowance for ``accounts``'s tokens of at least
585      * `amount`.
586      */
587     function burnFrom(address account, uint256 amount) public virtual {
588         uint256 currentAllowance = allowance(account, _msgSender());
589         require(currentAllowance >= amount, "ERC20: burn amount exceeds allowance");
590         _approve(account, _msgSender(), currentAllowance - amount);
591         _burn(account, amount);
592     }
593 }
594 
595 // File: contracts/token/ERC20/behaviours/ERC20Decimals.sol
596 
597 
598 
599 pragma solidity ^0.8.0;
600 
601 
602 /**
603  * @title ERC20Decimals
604  * @dev Implementation of the ERC20Decimals. Extension of {ERC20} that adds decimals storage slot.
605  */
606 abstract contract ERC20Decimals is ERC20 {
607     uint8 private immutable _decimals;
608 
609     /**
610      * @dev Sets the value of the `decimals`. This value is immutable, it can only be
611      * set once during construction.
612      */
613     constructor(uint8 decimals_) {
614         _decimals = decimals_;
615     }
616 
617     function decimals() public view virtual override returns (uint8) {
618         return _decimals;
619     }
620 }
621 
622 // File: contracts/token/ERC20/behaviours/ERC20Mintable.sol
623 
624 
625 
626 pragma solidity ^0.8.0;
627 
628 
629 /**
630  * @title ERC20Mintable
631  * @dev Implementation of the ERC20Mintable. Extension of {ERC20} that adds a minting behaviour.
632  */
633 abstract contract ERC20Mintable is ERC20 {
634     // indicates if minting is finished
635     bool private _mintingFinished = false;
636 
637     /**
638      * @dev Emitted during finish minting
639      */
640     event MintFinished();
641 
642     /**
643      * @dev Tokens can be minted only before minting finished.
644      */
645     modifier canMint() {
646         require(!_mintingFinished, "ERC20Mintable: minting is finished");
647         _;
648     }
649 
650     /**
651      * @return if minting is finished or not.
652      */
653     function mintingFinished() external view returns (bool) {
654         return _mintingFinished;
655     }
656 
657     /**
658      * @dev Function to mint tokens.
659      *
660      * WARNING: it allows everyone to mint new tokens. Access controls MUST be defined in derived contracts.
661      *
662      * @param account The address that will receive the minted tokens
663      * @param amount The amount of tokens to mint
664      */
665     function mint(address account, uint256 amount) external canMint {
666         _mint(account, amount);
667     }
668 
669     /**
670      * @dev Function to stop minting new tokens.
671      *
672      * WARNING: it allows everyone to finish minting. Access controls MUST be defined in derived contracts.
673      */
674     function finishMinting() external canMint {
675         _finishMinting();
676     }
677 
678     /**
679      * @dev Function to stop minting new tokens.
680      */
681     function _finishMinting() internal virtual {
682         _mintingFinished = true;
683 
684         emit MintFinished();
685     }
686 }
687 
688 // File: contracts/service/ServicePayer.sol
689 
690 
691 
692 pragma solidity ^0.8.0;
693 
694 interface IPayable {
695     function pay(string memory serviceName) external payable;
696 }
697 
698 /**
699  * @title ServicePayer
700  * @dev Implementation of the ServicePayer
701  */
702 abstract contract ServicePayer {
703     constructor(address payable receiver, string memory serviceName) payable {
704         IPayable(receiver).pay{value: msg.value}(serviceName);
705     }
706 }
707 
708 // File: contracts/token/ERC20/CommonERC20.sol
709 
710 
711 
712 pragma solidity ^0.8.0;
713 
714 
715 
716 
717 
718 
719 
720 /**
721  * @title CommonERC20
722  * @dev Implementation of the CommonERC20
723  */
724 contract CommonERC20 is ERC20Decimals, ERC20Capped, ERC20Mintable, ERC20Burnable, Ownable, ServicePayer {
725     constructor(
726         string memory name_,
727         string memory symbol_,
728         uint8 decimals_,
729         uint256 cap_,
730         uint256 initialBalance_,
731         address payable feeReceiver_
732     )
733         payable
734         ERC20(name_, symbol_)
735         ERC20Decimals(decimals_)
736         ERC20Capped(cap_)
737         ServicePayer(feeReceiver_, "CommonERC20")
738     {
739         // Immutable variables cannot be read during contract creation time
740         // https://github.com/ethereum/solidity/issues/10463
741         require(initialBalance_ <= cap_, "ERC20Capped: cap exceeded");
742         ERC20._mint(_msgSender(), initialBalance_);
743     }
744 
745     function decimals() public view virtual override(ERC20, ERC20Decimals) returns (uint8) {
746         return super.decimals();
747     }
748 
749     /**
750      * @dev Function to mint tokens.
751      *
752      * NOTE: restricting access to owner only. See {ERC20Mintable-mint}.
753      *
754      * @param account The address that will receive the minted tokens
755      * @param amount The amount of tokens to mint
756      */
757     function _mint(address account, uint256 amount) internal override(ERC20, ERC20Capped) onlyOwner {
758         super._mint(account, amount);
759     }
760 
761     /**
762      * @dev Function to stop minting new tokens.
763      *
764      * NOTE: restricting access to owner only. See {ERC20Mintable-finishMinting}.
765      */
766     function _finishMinting() internal override onlyOwner {
767         super._finishMinting();
768     }
769 }
