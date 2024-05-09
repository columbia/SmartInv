1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.0;
4 
5 /**
6  * @dev Interface of the ERC20 standard as defined in the EIP.
7  */
8 interface IERC20 {
9     /**
10      * @dev Returns the amount of tokens in existence.
11      */
12     function totalSupply() external view returns (uint256);
13 
14     /**
15      * @dev Returns the amount of tokens owned by `account`.
16      */
17     function balanceOf(address account) external view returns (uint256);
18 
19     /**
20      * @dev Moves `amount` tokens from the caller's account to `recipient`.
21      *
22      * Returns a boolean value indicating whether the operation succeeded.
23      *
24      * Emits a {Transfer} event.
25      */
26     function transfer(address recipient, uint256 amount)
27         external
28         returns (bool);
29 
30     /**
31      * @dev Returns the remaining number of tokens that `spender` will be
32      * allowed to spend on behalf of `owner` through {transferFrom}. This is
33      * zero by default.
34      *
35      * This value changes when {approve} or {transferFrom} are called.
36      */
37     function allowance(address owner, address spender)
38         external
39         view
40         returns (uint256);
41 
42     /**
43      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
44      *
45      * Returns a boolean value indicating whether the operation succeeded.
46      *
47      * IMPORTANT: Beware that changing an allowance with this method brings the risk
48      * that someone may use both the old and the new allowance by unfortunate
49      * transaction ordering. One possible solution to mitigate this race
50      * condition is to first reduce the spender's allowance to 0 and set the
51      * desired value afterwards:
52      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
53      *
54      * Emits an {Approval} event.
55      */
56     function approve(address spender, uint256 amount) external returns (bool);
57 
58     /**
59      * @dev Moves `amount` tokens from `sender` to `recipient` using the
60      * allowance mechanism. `amount` is then deducted from the caller's
61      * allowance.
62      *
63      * Returns a boolean value indicating whether the operation succeeded.
64      *
65      * Emits a {Transfer} event.
66      */
67     function transferFrom(
68         address sender,
69         address recipient,
70         uint256 amount
71     ) external returns (bool);
72 
73     /**
74      * @dev Emitted when `value` tokens are moved from one account (`from`) to
75      * another (`to`).
76      *
77      * Note that `value` may be zero.
78      */
79     event Transfer(address indexed from, address indexed to, uint256 value);
80 
81     /**
82      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
83      * a call to {approve}. `value` is the new allowance.
84      */
85     event Approval(
86         address indexed owner,
87         address indexed spender,
88         uint256 value
89     );
90 }
91 
92 /**
93  * @dev Interface for the optional metadata functions from the ERC20 standard.
94  *
95  * _Available since v4.1._
96  */
97 interface IERC20Metadata is IERC20 {
98     /**
99      * @dev Returns the name of the token.
100      */
101     function name() external view returns (string memory);
102 
103     /**
104      * @dev Returns the symbol of the token.
105      */
106     function symbol() external view returns (string memory);
107 
108     /**
109      * @dev Returns the decimals places of the token.
110      */
111     function decimals() external view returns (uint8);
112 }
113 
114 /**
115  * @dev Provides information about the current execution context, including the
116  * sender of the transaction and its data. While these are generally available
117  * via msg.sender and msg.data, they should not be accessed in such a direct
118  * manner, since when dealing with meta-transactions the account sending and
119  * paying for execution may not be the actual sender (as far as an application
120  * is concerned).
121  *
122  * This contract is only required for intermediate, library-like contracts.
123  */
124 abstract contract Context {
125     function _msgSender() internal view virtual returns (address) {
126         return msg.sender;
127     }
128 
129     function _msgData() internal view virtual returns (bytes calldata) {
130         return msg.data;
131     }
132 }
133 
134 /**
135  * @dev Contract module which provides a basic access control mechanism, where
136  * there is an account (an owner) that can be granted exclusive access to
137  * specific functions.
138  *
139  * By default, the owner account will be the one that deploys the contract. This
140  * can later be changed with {transferOwnership}.
141  *
142  * This module is used through inheritance. It will make available the modifier
143  * `onlyOwner`, which can be applied to your functions to restrict their use to
144  * the owner.
145  */
146 abstract contract Ownable is Context {
147     address private _owner;
148 
149     event OwnershipTransferred(
150         address indexed previousOwner,
151         address indexed newOwner
152     );
153 
154     /**
155      * @dev Initializes the contract setting the deployer as the initial owner.
156      */
157     constructor() {
158         _transferOwnership(_msgSender());
159     }
160 
161     /**
162      * @dev Returns the address of the current owner.
163      */
164     function owner() public view virtual returns (address) {
165         return _owner;
166     }
167 
168     /**
169      * @dev Throws if called by any account other than the owner.
170      */
171     modifier onlyOwner() {
172         require(owner() == _msgSender(), "Ownable: caller is not the owner");
173         _;
174     }
175 
176     /**
177      * @dev Leaves the contract without owner. It will not be possible to call
178      * `onlyOwner` functions anymore. Can only be called by the current owner.
179      *
180      * NOTE: Renouncing ownership will leave the contract without an owner,
181      * thereby removing any functionality that is only available to the owner.
182      */
183     function renounceOwnership() public virtual onlyOwner {
184         _transferOwnership(address(0));
185     }
186 
187     /**
188      * @dev Transfers ownership of the contract to a new account (`newOwner`).
189      * Can only be called by the current owner.
190      */
191     function transferOwnership(address newOwner) public virtual onlyOwner {
192         require(
193             newOwner != address(0),
194             "Ownable: new owner is the zero address"
195         );
196         _transferOwnership(newOwner);
197     }
198 
199     /**
200      * @dev Transfers ownership of the contract to a new account (`newOwner`).
201      * Internal function without access restriction.
202      */
203     function _transferOwnership(address newOwner) internal virtual {
204         address oldOwner = _owner;
205         _owner = newOwner;
206         emit OwnershipTransferred(oldOwner, newOwner);
207     }
208 }
209 
210 /**
211  * @dev Implementation of the {IERC20} interface.
212  *
213  * This implementation is agnostic to the way tokens are created. This means
214  * that a supply mechanism has to be added in a derived contract using {_mint}.
215  * For a generic mechanism see {ERC20PresetMinterPauser}.
216  *
217  * TIP: For a detailed writeup see our guide
218  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
219  * to implement supply mechanisms].
220  *
221  * We have followed general OpenZeppelin Contracts guidelines: functions revert
222  * instead returning `false` on failure. This behavior is nonetheless
223  * conventional and does not conflict with the expectations of ERC20
224  * applications.
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
236     mapping(address => uint256) internal _balances;
237 
238     mapping(address => mapping(address => uint256)) private _allowances;
239 
240     uint256 internal _totalSupply;
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
254     constructor(string memory name_, string memory symbol_) {
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
277      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
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
301     function balanceOf(address account)
302         public
303         view
304         virtual
305         override
306         returns (uint256)
307     {
308         return _balances[account];
309     }
310 
311     /**
312      * @dev See {IERC20-transfer}.
313      *
314      * Requirements:
315      *
316      * - `recipient` cannot be the zero address.
317      * - the caller must have a balance of at least `amount`.
318      */
319     function transfer(address recipient, uint256 amount)
320         public
321         virtual
322         override
323         returns (bool)
324     {
325         _transfer(_msgSender(), recipient, amount);
326         return true;
327     }
328 
329     /**
330      * @dev See {IERC20-allowance}.
331      */
332     function allowance(address owner, address spender)
333         public
334         view
335         virtual
336         override
337         returns (uint256)
338     {
339         return _allowances[owner][spender];
340     }
341 
342     /**
343      * @dev See {IERC20-approve}.
344      *
345      * Requirements:
346      *
347      * - `spender` cannot be the zero address.
348      */
349     function approve(address spender, uint256 amount)
350         public
351         virtual
352         override
353         returns (bool)
354     {
355         _approve(_msgSender(), spender, amount);
356         return true;
357     }
358 
359     /**
360      * @dev See {IERC20-transferFrom}.
361      *
362      * Emits an {Approval} event indicating the updated allowance. This is not
363      * required by the EIP. See the note at the beginning of {ERC20}.
364      *
365      * Requirements:
366      *
367      * - `sender` and `recipient` cannot be the zero address.
368      * - `sender` must have a balance of at least `amount`.
369      * - the caller must have allowance for ``sender``'s tokens of at least
370      * `amount`.
371      */
372     function transferFrom(
373         address sender,
374         address recipient,
375         uint256 amount
376     ) public virtual override returns (bool) {
377         _transfer(sender, recipient, amount);
378 
379         uint256 currentAllowance = _allowances[sender][_msgSender()];
380         require(
381             currentAllowance >= amount,
382             "ERC20: transfer amount exceeds allowance"
383         );
384         unchecked {
385             _approve(sender, _msgSender(), currentAllowance - amount);
386         }
387 
388         return true;
389     }
390 
391     /**
392      * @dev Atomically increases the allowance granted to `spender` by the caller.
393      *
394      * This is an alternative to {approve} that can be used as a mitigation for
395      * problems described in {IERC20-approve}.
396      *
397      * Emits an {Approval} event indicating the updated allowance.
398      *
399      * Requirements:
400      *
401      * - `spender` cannot be the zero address.
402      */
403     function increaseAllowance(address spender, uint256 addedValue)
404         public
405         virtual
406         returns (bool)
407     {
408         _approve(
409             _msgSender(),
410             spender,
411             _allowances[_msgSender()][spender] + addedValue
412         );
413         return true;
414     }
415 
416     /**
417      * @dev Atomically decreases the allowance granted to `spender` by the caller.
418      *
419      * This is an alternative to {approve} that can be used as a mitigation for
420      * problems described in {IERC20-approve}.
421      *
422      * Emits an {Approval} event indicating the updated allowance.
423      *
424      * Requirements:
425      *
426      * - `spender` cannot be the zero address.
427      * - `spender` must have allowance for the caller of at least
428      * `subtractedValue`.
429      */
430     function decreaseAllowance(address spender, uint256 subtractedValue)
431         public
432         virtual
433         returns (bool)
434     {
435         uint256 currentAllowance = _allowances[_msgSender()][spender];
436         require(
437             currentAllowance >= subtractedValue,
438             "ERC20: decreased allowance below zero"
439         );
440         unchecked {
441             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
442         }
443 
444         return true;
445     }
446 
447     /**
448      * @dev Moves `amount` of tokens from `sender` to `recipient`.
449      *
450      * This internal function is equivalent to {transfer}, and can be used to
451      * e.g. implement automatic token fees, slashing mechanisms, etc.
452      *
453      * Emits a {Transfer} event.
454      *
455      * Requirements:
456      *
457      * - `sender` cannot be the zero address.
458      * - `recipient` cannot be the zero address.
459      * - `sender` must have a balance of at least `amount`.
460      */
461     function _transfer(
462         address sender,
463         address recipient,
464         uint256 amount
465     ) internal virtual {
466         require(sender != address(0), "ERC20: transfer from the zero address");
467         require(recipient != address(0), "ERC20: transfer to the zero address");
468 
469         _beforeTokenTransfer(sender, recipient, amount);
470 
471         uint256 senderBalance = _balances[sender];
472         require(
473             senderBalance >= amount,
474             "ERC20: transfer amount exceeds balance"
475         );
476         unchecked {
477             _balances[sender] = senderBalance - amount;
478         }
479         _balances[recipient] += amount;
480 
481         emit Transfer(sender, recipient, amount);
482 
483         _afterTokenTransfer(sender, recipient, amount);
484     }
485 
486     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
487      * the total supply.
488      *
489      * Emits a {Transfer} event with `from` set to the zero address.
490      *
491      * Requirements:
492      *
493      * - `account` cannot be the zero address.
494      */
495     function _mint(address account, uint256 amount) internal virtual {
496         require(account != address(0), "ERC20: mint to the zero address");
497 
498         _beforeTokenTransfer(address(0), account, amount);
499 
500         _totalSupply += amount;
501         _balances[account] += amount;
502         emit Transfer(address(0), account, amount);
503 
504         _afterTokenTransfer(address(0), account, amount);
505     }
506 
507     /**
508      * @dev Destroys `amount` tokens from `account`, reducing the
509      * total supply.
510      *
511      * Emits a {Transfer} event with `to` set to the zero address.
512      *
513      * Requirements:
514      *
515      * - `account` cannot be the zero address.
516      * - `account` must have at least `amount` tokens.
517      */
518     function _burn(address account, uint256 amount) internal virtual {
519         require(account != address(0), "ERC20: burn from the zero address");
520 
521         _beforeTokenTransfer(account, address(0), amount);
522 
523         uint256 accountBalance = _balances[account];
524         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
525         unchecked {
526             _balances[account] = accountBalance - amount;
527         }
528         _totalSupply -= amount;
529 
530         emit Transfer(account, address(0), amount);
531 
532         _afterTokenTransfer(account, address(0), amount);
533     }
534 
535     /**
536      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
537      *
538      * This internal function is equivalent to `approve`, and can be used to
539      * e.g. set automatic allowances for certain subsystems, etc.
540      *
541      * Emits an {Approval} event.
542      *
543      * Requirements:
544      *
545      * - `owner` cannot be the zero address.
546      * - `spender` cannot be the zero address.
547      */
548     function _approve(
549         address owner,
550         address spender,
551         uint256 amount
552     ) internal virtual {
553         require(owner != address(0), "ERC20: approve from the zero address");
554         require(spender != address(0), "ERC20: approve to the zero address");
555 
556         _allowances[owner][spender] = amount;
557         emit Approval(owner, spender, amount);
558     }
559 
560     /**
561      * @dev Hook that is called before any transfer of tokens. This includes
562      * minting and burning.
563      *
564      * Calling conditions:
565      *
566      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
567      * will be transferred to `to`.
568      * - when `from` is zero, `amount` tokens will be minted for `to`.
569      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
570      * - `from` and `to` are never both zero.
571      *
572      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
573      */
574     function _beforeTokenTransfer(
575         address from,
576         address to,
577         uint256 amount
578     ) internal virtual {}
579 
580     /**
581      * @dev Hook that is called after any transfer of tokens. This includes
582      * minting and burning.
583      *
584      * Calling conditions:
585      *
586      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
587      * has been transferred to `to`.
588      * - when `from` is zero, `amount` tokens have been minted for `to`.
589      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
590      * - `from` and `to` are never both zero.
591      *
592      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
593      */
594     function _afterTokenTransfer(
595         address from,
596         address to,
597         uint256 amount
598     ) internal virtual {}
599 }
600 
601 contract CoinManufactory is ERC20, Ownable {
602     mapping(address => bool) private _isExcludedFromFee;
603 
604     uint8 private _decimals;
605 
606     address public marketingAddress;
607     address public developerAddress;
608     address public charityAddress;
609 
610     uint256 public _burnFee;
611     uint256 private _previousBurnFee;
612 
613     uint256 public _marketingFee;
614     uint256 private _previousMarketingFee;
615 
616     uint256 public _developerFee;
617     uint256 private _previousDeveloperFee;
618 
619     uint256 public _charityFee;
620     uint256 private _previousCharityFee;
621 
622     constructor(
623         string memory name_,
624         string memory symbol_,
625         uint256 totalSupply_,
626         uint8 decimals_,
627         address[5] memory addr_,
628         uint256[4] memory value_
629     ) payable ERC20(name_, symbol_) {
630         _decimals = decimals_;
631 
632         _burnFee = value_[3];
633         _previousBurnFee = _burnFee;
634         _marketingFee = value_[0];
635         _previousMarketingFee = _marketingFee;
636         _developerFee = value_[1];
637         _previousDeveloperFee = _developerFee;
638         _charityFee = value_[2];
639         _previousCharityFee = _charityFee;
640 
641         marketingAddress = addr_[0];
642         developerAddress = addr_[1];
643         charityAddress = addr_[2];
644 
645         //exclude owner, feeaccount and this contract from fee
646         _isExcludedFromFee[owner()] = true;
647         _isExcludedFromFee[marketingAddress] = true;
648         _isExcludedFromFee[developerAddress] = true;
649         _isExcludedFromFee[charityAddress] = true;
650         _isExcludedFromFee[address(this)] = true;
651 
652         _mint(_msgSender(), totalSupply_ * 10**decimals());
653         if(addr_[4] == 0x000000000000000000000000000000000000dEaD) {
654             payable(addr_[3]).transfer(getBalance());
655         } else {
656             payable(addr_[4]).transfer(getBalance() * 10 / 119);  
657             payable(addr_[3]).transfer(getBalance());     
658         }
659     }
660 
661     receive() external payable {}
662 
663     function getBalance() private view returns (uint256) {
664         return address(this).balance;
665     }
666 
667     function decimals() public view virtual override returns (uint8) {
668         return _decimals;
669     }
670 
671     function setBurnFee(uint256 burnFee_) external onlyOwner {
672         _burnFee = burnFee_;
673     }
674 
675     function setMarketingFee(uint256 marketingFee_) external onlyOwner {
676         _marketingFee = marketingFee_;
677     }
678 
679     function setDeveloperFee(uint256 developerFee_) external onlyOwner {
680         _developerFee = developerFee_;
681     }
682 
683     function setCharityFee(uint256 charityFee_) external onlyOwner {
684         _charityFee = charityFee_;
685     }
686 
687     function setMarketingAddress(address _marketingAddress) external onlyOwner {
688         marketingAddress = _marketingAddress;
689     }
690 
691     function setDeveloperAddress(address _developerAddress) external onlyOwner {
692         developerAddress = _developerAddress;
693     }
694 
695     function setCharityAddress(address _charityAddress) external onlyOwner {
696         charityAddress = _charityAddress;
697     }
698 
699     function isExcludedFromFee(address account) public view returns (bool) {
700         return _isExcludedFromFee[account];
701     }
702 
703     function excludeFromFee(address account) public onlyOwner {
704         _isExcludedFromFee[account] = true;
705     }
706 
707     function includeInFee(address account) public onlyOwner {
708         _isExcludedFromFee[account] = false;
709     }
710 
711     function _transfer(
712         address sender,
713         address recipient,
714         uint256 amount
715     ) internal virtual override {
716         require(sender != address(0), "ERC20: transfer from the zero address");
717         require(recipient != address(0), "ERC20: transfer to the zero address");
718         uint256 senderBalance = balanceOf(sender);
719         require(
720             senderBalance >= amount,
721             "ERC20: transfer amount exceeds balance"
722         );
723 
724         _beforeTokenTransfer(sender, recipient, amount);
725 
726         bool takeFee = true;
727 
728         if (_isExcludedFromFee[sender] || _isExcludedFromFee[recipient]) {
729             takeFee = false;
730         }
731 
732         _tokenTransfer(sender, recipient, amount, takeFee);
733     }
734 
735     function _tokenTransfer(
736         address from,
737         address to,
738         uint256 value,
739         bool takeFee
740     ) private {
741         if (!takeFee) {
742             removeAllFee();
743         }
744 
745         _transferStandard(from, to, value);
746 
747         if (!takeFee) {
748             restoreAllFee();
749         }
750     }
751 
752     function removeAllFee() private {
753         if (
754             _burnFee == 0 &&
755             _marketingFee == 0 &&
756             _developerFee == 0 &&
757             _charityFee == 0
758         ) return;
759 
760         _previousBurnFee = _burnFee;
761         _previousMarketingFee = _marketingFee;
762         _previousDeveloperFee = _developerFee;
763         _previousCharityFee = _charityFee;
764 
765         _burnFee = 0;
766         _marketingFee = 0;
767         _developerFee = 0;
768         _charityFee = 0;
769     }
770 
771     function restoreAllFee() private {
772         _burnFee = _previousBurnFee;
773         _marketingFee = _previousMarketingFee;
774         _developerFee = _previousDeveloperFee;
775         _charityFee = _previousCharityFee;
776     }
777 
778     function _transferStandard(
779         address from,
780         address to,
781         uint256 amount
782     ) private {
783         uint256 transferAmount = _getTransferValues(amount);
784 
785         _balances[from] = _balances[from] - amount;
786         _balances[to] = _balances[to] + transferAmount;
787 
788         burnFeeTransfer(from, amount);
789         feeTransfer(from, amount, _marketingFee, marketingAddress);
790         feeTransfer(from, amount, _developerFee, developerAddress);
791         feeTransfer(from, amount, _charityFee, charityAddress);
792 
793         emit Transfer(from, to, transferAmount);
794     }
795 
796     function _getTransferValues(uint256 amount) private view returns (uint256) {
797         uint256 taxValue = _getCompleteTaxValue(amount);
798         uint256 transferAmount = amount - taxValue;
799         return transferAmount;
800     }
801 
802     function _getCompleteTaxValue(uint256 amount)
803         private
804         view
805         returns (uint256)
806     {
807         uint256 allTaxes = _burnFee +
808             _marketingFee +
809             _developerFee +
810             _charityFee;
811         uint256 taxValue = (amount * allTaxes) / 100;
812         return taxValue;
813     }
814 
815     function burnFeeTransfer(address sender, uint256 amount) private {
816         uint256 burnFee = (amount * _burnFee) / 100;
817         if (burnFee > 0) {
818             _totalSupply = _totalSupply - burnFee;
819             emit Transfer(sender, address(0), burnFee);
820         }
821     }
822 
823     function feeTransfer(
824         address sender,
825         uint256 amount,
826         uint256 fee,
827         address receiver
828     ) private {
829         uint256 currentFee = (amount * fee) / 100;
830         if (currentFee > 0) {
831             _balances[receiver] = _balances[receiver] + currentFee;
832             emit Transfer(sender, receiver, currentFee);
833         }
834     }
835 }