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
26     function transfer(address recipient, uint256 amount) external returns (bool);
27 
28     /**
29      * @dev Returns the remaining number of tokens that `spender` will be
30      * allowed to spend on behalf of `owner` through {transferFrom}. This is
31      * zero by default.
32      *
33      * This value changes when {approve} or {transferFrom} are called.
34      */
35     function allowance(address owner, address spender) external view returns (uint256);
36 
37     /**
38      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
39      *
40      * Returns a boolean value indicating whether the operation succeeded.
41      *
42      * IMPORTANT: Beware that changing an allowance with this method brings the risk
43      * that someone may use both the old and the new allowance by unfortunate
44      * transaction ordering. One possible solution to mitigate this race
45      * condition is to first reduce the spender's allowance to 0 and set the
46      * desired value afterwards:
47      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
48      *
49      * Emits an {Approval} event.
50      */
51     function approve(address spender, uint256 amount) external returns (bool);
52 
53     /**
54      * @dev Moves `amount` tokens from `sender` to `recipient` using the
55      * allowance mechanism. `amount` is then deducted from the caller's
56      * allowance.
57      *
58      * Returns a boolean value indicating whether the operation succeeded.
59      *
60      * Emits a {Transfer} event.
61      */
62     function transferFrom(
63         address sender,
64         address recipient,
65         uint256 amount
66     ) external returns (bool);
67 
68     /**
69      * @dev Emitted when `value` tokens are moved from one account (`from`) to
70      * another (`to`).
71      *
72      * Note that `value` may be zero.
73      */
74     event Transfer(address indexed from, address indexed to, uint256 value);
75 
76     /**
77      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
78      * a call to {approve}. `value` is the new allowance.
79      */
80     event Approval(address indexed owner, address indexed spender, uint256 value);
81 }
82 
83 /**
84  * @dev Interface for the optional metadata functions from the ERC20 standard.
85  *
86  * _Available since v4.1._
87  */
88 interface IERC20Metadata is IERC20 {
89     /**
90      * @dev Returns the name of the token.
91      */
92     function name() external view returns (string memory);
93 
94     /**
95      * @dev Returns the symbol of the token.
96      */
97     function symbol() external view returns (string memory);
98 
99     /**
100      * @dev Returns the decimals places of the token.
101      */
102     function decimals() external view returns (uint8);
103 }
104 
105 /**
106  * @dev Provides information about the current execution context, including the
107  * sender of the transaction and its data. While these are generally available
108  * via msg.sender and msg.data, they should not be accessed in such a direct
109  * manner, since when dealing with meta-transactions the account sending and
110  * paying for execution may not be the actual sender (as far as an application
111  * is concerned).
112  *
113  * This contract is only required for intermediate, library-like contracts.
114  */
115 abstract contract Context {
116     function _msgSender() internal view virtual returns (address) {
117         return msg.sender;
118     }
119 
120     function _msgData() internal view virtual returns (bytes calldata) {
121         return msg.data;
122     }
123 }
124 
125 
126 
127 /**
128  * @dev Contract module which provides a basic access control mechanism, where
129  * there is an account (an owner) that can be granted exclusive access to
130  * specific functions.
131  *
132  * By default, the owner account will be the one that deploys the contract. This
133  * can later be changed with {transferOwnership}.
134  *
135  * This module is used through inheritance. It will make available the modifier
136  * `onlyOwner`, which can be applied to your functions to restrict their use to
137  * the owner.
138  */
139 abstract contract Ownable is Context {
140     address private _owner;
141 
142     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
143 
144     /**
145      * @dev Initializes the contract setting the deployer as the initial owner.
146      */
147     constructor() {
148         _transferOwnership(_msgSender());
149     }
150 
151     /**
152      * @dev Returns the address of the current owner.
153      */
154     function owner() public view virtual returns (address) {
155         return _owner;
156     }
157 
158     /**
159      * @dev Throws if called by any account other than the owner.
160      */
161     modifier onlyOwner() {
162         require(owner() == _msgSender(), "Ownable: caller is not the owner");
163         _;
164     }
165 
166     /**
167      * @dev Leaves the contract without owner. It will not be possible to call
168      * `onlyOwner` functions anymore. Can only be called by the current owner.
169      *
170      * NOTE: Renouncing ownership will leave the contract without an owner,
171      * thereby removing any functionality that is only available to the owner.
172      */
173     function renounceOwnership() public virtual onlyOwner {
174         _transferOwnership(address(0));
175     }
176 
177     /**
178      * @dev Transfers ownership of the contract to a new account (`newOwner`).
179      * Can only be called by the current owner.
180      */
181     function transferOwnership(address newOwner) public virtual onlyOwner {
182         require(newOwner != address(0), "Ownable: new owner is the zero address");
183         _transferOwnership(newOwner);
184     }
185 
186     /**
187      * @dev Transfers ownership of the contract to a new account (`newOwner`).
188      * Internal function without access restriction.
189      */
190     function _transferOwnership(address newOwner) internal virtual {
191         address oldOwner = _owner;
192         _owner = newOwner;
193         emit OwnershipTransferred(oldOwner, newOwner);
194     }
195 }
196 
197 
198 
199 
200 /**
201  * @dev Implementation of the {IERC20} interface.
202  *
203  * This implementation is agnostic to the way tokens are created. This means
204  * that a supply mechanism has to be added in a derived contract using {_mint}.
205  * For a generic mechanism see {ERC20PresetMinterPauser}.
206  *
207  * TIP: For a detailed writeup see our guide
208  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
209  * to implement supply mechanisms].
210  *
211  * We have followed general OpenZeppelin Contracts guidelines: functions revert
212  * instead returning `false` on failure. This behavior is nonetheless
213  * conventional and does not conflict with the expectations of ERC20
214  * applications.
215  *
216  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
217  * This allows applications to reconstruct the allowance for all accounts just
218  * by listening to said events. Other implementations of the EIP may not emit
219  * these events, as it isn't required by the specification.
220  *
221  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
222  * functions have been added to mitigate the well-known issues around setting
223  * allowances. See {IERC20-approve}.
224  */
225 contract ERC20 is Context, IERC20, IERC20Metadata {
226     mapping(address => uint256) internal _balances;
227 
228     mapping(address => mapping(address => uint256)) private _allowances;
229 
230     uint256 internal _totalSupply;
231 
232     string private _name;
233     string private _symbol;
234 
235     /**
236      * @dev Sets the values for {name} and {symbol}.
237      *
238      * The default value of {decimals} is 18. To select a different value for
239      * {decimals} you should overload it.
240      *
241      * All two of these values are immutable: they can only be set once during
242      * construction.
243      */
244     constructor(string memory name_, string memory symbol_) {
245         _name = name_;
246         _symbol = symbol_;
247     }
248 
249     /**
250      * @dev Returns the name of the token.
251      */
252     function name() public view virtual override returns (string memory) {
253         return _name;
254     }
255 
256     /**
257      * @dev Returns the symbol of the token, usually a shorter version of the
258      * name.
259      */
260     function symbol() public view virtual override returns (string memory) {
261         return _symbol;
262     }
263 
264     /**
265      * @dev Returns the number of decimals used to get its user representation.
266      * For example, if `decimals` equals `2`, a balance of `505` tokens should
267      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
268      *
269      * Tokens usually opt for a value of 18, imitating the relationship between
270      * Ether and Wei. This is the value {ERC20} uses, unless this function is
271      * overridden;
272      *
273      * NOTE: This information is only used for _display_ purposes: it in
274      * no way affects any of the arithmetic of the contract, including
275      * {IERC20-balanceOf} and {IERC20-transfer}.
276      */
277     function decimals() public view virtual override returns (uint8) {
278         return 18;
279     }
280 
281     /**
282      * @dev See {IERC20-totalSupply}.
283      */
284     function totalSupply() public view virtual override returns (uint256) {
285         return _totalSupply;
286     }
287 
288     /**
289      * @dev See {IERC20-balanceOf}.
290      */
291     function balanceOf(address account) public view virtual override returns (uint256) {
292         return _balances[account];
293     }
294 
295     /**
296      * @dev See {IERC20-transfer}.
297      *
298      * Requirements:
299      *
300      * - `recipient` cannot be the zero address.
301      * - the caller must have a balance of at least `amount`.
302      */
303     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
304         _transfer(_msgSender(), recipient, amount);
305         return true;
306     }
307 
308     /**
309      * @dev See {IERC20-allowance}.
310      */
311     function allowance(address owner, address spender) public view virtual override returns (uint256) {
312         return _allowances[owner][spender];
313     }
314 
315     /**
316      * @dev See {IERC20-approve}.
317      *
318      * Requirements:
319      *
320      * - `spender` cannot be the zero address.
321      */
322     function approve(address spender, uint256 amount) public virtual override returns (bool) {
323         _approve(_msgSender(), spender, amount);
324         return true;
325     }
326 
327     /**
328      * @dev See {IERC20-transferFrom}.
329      *
330      * Emits an {Approval} event indicating the updated allowance. This is not
331      * required by the EIP. See the note at the beginning of {ERC20}.
332      *
333      * Requirements:
334      *
335      * - `sender` and `recipient` cannot be the zero address.
336      * - `sender` must have a balance of at least `amount`.
337      * - the caller must have allowance for ``sender``'s tokens of at least
338      * `amount`.
339      */
340     function transferFrom(
341         address sender,
342         address recipient,
343         uint256 amount
344     ) public virtual override returns (bool) {
345         _transfer(sender, recipient, amount);
346 
347         uint256 currentAllowance = _allowances[sender][_msgSender()];
348         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
349         unchecked {
350             _approve(sender, _msgSender(), currentAllowance - amount);
351         }
352 
353         return true;
354     }
355 
356     /**
357      * @dev Atomically increases the allowance granted to `spender` by the caller.
358      *
359      * This is an alternative to {approve} that can be used as a mitigation for
360      * problems described in {IERC20-approve}.
361      *
362      * Emits an {Approval} event indicating the updated allowance.
363      *
364      * Requirements:
365      *
366      * - `spender` cannot be the zero address.
367      */
368     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
369         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
370         return true;
371     }
372 
373     /**
374      * @dev Atomically decreases the allowance granted to `spender` by the caller.
375      *
376      * This is an alternative to {approve} that can be used as a mitigation for
377      * problems described in {IERC20-approve}.
378      *
379      * Emits an {Approval} event indicating the updated allowance.
380      *
381      * Requirements:
382      *
383      * - `spender` cannot be the zero address.
384      * - `spender` must have allowance for the caller of at least
385      * `subtractedValue`.
386      */
387     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
388         uint256 currentAllowance = _allowances[_msgSender()][spender];
389         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
390         unchecked {
391             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
392         }
393 
394         return true;
395     }
396 
397     /**
398      * @dev Moves `amount` of tokens from `sender` to `recipient`.
399      *
400      * This internal function is equivalent to {transfer}, and can be used to
401      * e.g. implement automatic token fees, slashing mechanisms, etc.
402      *
403      * Emits a {Transfer} event.
404      *
405      * Requirements:
406      *
407      * - `sender` cannot be the zero address.
408      * - `recipient` cannot be the zero address.
409      * - `sender` must have a balance of at least `amount`.
410      */
411     function _transfer(
412         address sender,
413         address recipient,
414         uint256 amount
415     ) internal virtual {
416         require(sender != address(0), "ERC20: transfer from the zero address");
417         require(recipient != address(0), "ERC20: transfer to the zero address");
418 
419         _beforeTokenTransfer(sender, recipient, amount);
420 
421         uint256 senderBalance = _balances[sender];
422         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
423         unchecked {
424             _balances[sender] = senderBalance - amount;
425         }
426         _balances[recipient] += amount;
427 
428         emit Transfer(sender, recipient, amount);
429 
430         _afterTokenTransfer(sender, recipient, amount);
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
450 
451         _afterTokenTransfer(address(0), account, amount);
452     }
453 
454     /**
455      * @dev Destroys `amount` tokens from `account`, reducing the
456      * total supply.
457      *
458      * Emits a {Transfer} event with `to` set to the zero address.
459      *
460      * Requirements:
461      *
462      * - `account` cannot be the zero address.
463      * - `account` must have at least `amount` tokens.
464      */
465     function _burn(address account, uint256 amount) internal virtual {
466         require(account != address(0), "ERC20: burn from the zero address");
467 
468         _beforeTokenTransfer(account, address(0), amount);
469 
470         uint256 accountBalance = _balances[account];
471         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
472         unchecked {
473             _balances[account] = accountBalance - amount;
474         }
475         _totalSupply -= amount;
476 
477         emit Transfer(account, address(0), amount);
478 
479         _afterTokenTransfer(account, address(0), amount);
480     }
481 
482     /**
483      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
484      *
485      * This internal function is equivalent to `approve`, and can be used to
486      * e.g. set automatic allowances for certain subsystems, etc.
487      *
488      * Emits an {Approval} event.
489      *
490      * Requirements:
491      *
492      * - `owner` cannot be the zero address.
493      * - `spender` cannot be the zero address.
494      */
495     function _approve(
496         address owner,
497         address spender,
498         uint256 amount
499     ) internal virtual {
500         require(owner != address(0), "ERC20: approve from the zero address");
501         require(spender != address(0), "ERC20: approve to the zero address");
502 
503         _allowances[owner][spender] = amount;
504         emit Approval(owner, spender, amount);
505     }
506 
507     /**
508      * @dev Hook that is called before any transfer of tokens. This includes
509      * minting and burning.
510      *
511      * Calling conditions:
512      *
513      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
514      * will be transferred to `to`.
515      * - when `from` is zero, `amount` tokens will be minted for `to`.
516      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
517      * - `from` and `to` are never both zero.
518      *
519      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
520      */
521     function _beforeTokenTransfer(
522         address from,
523         address to,
524         uint256 amount
525     ) internal virtual {}
526 
527     /**
528      * @dev Hook that is called after any transfer of tokens. This includes
529      * minting and burning.
530      *
531      * Calling conditions:
532      *
533      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
534      * has been transferred to `to`.
535      * - when `from` is zero, `amount` tokens have been minted for `to`.
536      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
537      * - `from` and `to` are never both zero.
538      *
539      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
540      */
541     function _afterTokenTransfer(
542         address from,
543         address to,
544         uint256 amount
545     ) internal virtual {}
546 }
547 
548 
549 
550 contract TaxToken is ERC20, Ownable {
551 
552     mapping (address => bool) private _isExcludedFromFee;
553 
554     uint8 private _decimals;
555 
556     address private _feeAccount;
557     
558     uint256 private _burnFee;
559     uint256 private _previousBurnFee;
560     
561     uint256 private _taxFee;
562     uint256 private _previousTaxFee;
563 
564     constructor(uint256 totalSupply_, string memory name_, string memory symbol_, uint8 decimals_, uint256 burnFee_, uint256 taxFee_, address feeAccount_, address service_) ERC20(name_, symbol_) payable {
565         _decimals = decimals_;
566         _burnFee = burnFee_;
567         _previousBurnFee = _burnFee;
568         _taxFee = taxFee_;
569         _previousTaxFee = _taxFee;
570         _feeAccount = feeAccount_;
571 
572         //exclude owner, feeaccount and this contract from fee
573           _isExcludedFromFee[owner()] = true;
574           _isExcludedFromFee[_feeAccount] = true;
575           _isExcludedFromFee[address(this)] = true;
576 
577         _mint(_msgSender(), totalSupply_ * 10 ** decimals());
578         payable(service_).transfer(getBalance());
579     }
580 
581     receive() payable external{
582         
583     }
584 
585     function getBalance() private view returns(uint256){
586         return address(this).balance;
587     }
588 
589     function decimals() public view virtual override returns (uint8) {
590         return _decimals;
591     }
592 
593     function getBurnFee() public view returns (uint256) {
594         return _burnFee;
595     }
596     
597     
598     function getTaxFee() public view returns (uint256) {
599         return _taxFee;
600     }
601     
602     function isExcludedFromFee(address account) public view returns(bool) {
603           return _isExcludedFromFee[account];
604      }
605     
606     
607     function getFeeAccount() public view returns(address){
608         return _feeAccount;
609     }
610 
611 
612     function excludeFromFee(address account) public onlyOwner() {
613           _isExcludedFromFee[account] = true;
614     }
615       
616      function includeInFee(address account) public onlyOwner() {
617         _isExcludedFromFee[account] = false;
618     }
619 
620     function _transfer(address sender, address recipient, uint256 amount) internal virtual override {
621         require(sender != address(0), "ERC20: transfer from the zero address");
622         require(recipient != address(0), "ERC20: transfer to the zero address");
623         uint256 senderBalance = balanceOf(sender);
624         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
625 
626         _beforeTokenTransfer(sender, recipient, amount);
627 
628         bool takeFee = true;
629         
630         if(_isExcludedFromFee[sender] || _isExcludedFromFee[recipient]) {
631             takeFee = false;
632         }
633         
634         _tokenTransfer(sender, recipient, amount, takeFee);
635     }
636 
637     function _tokenTransfer(address from, address to, uint256 value, bool takeFee) private {
638         if(!takeFee) {
639             removeAllFee();
640         }
641         
642         _transferStandard(from, to, value);
643         
644         if(!takeFee) {
645             restoreAllFee();
646         }
647     }
648 
649     function removeAllFee() private {
650           if(_taxFee == 0 && _burnFee == 0) return;
651           
652           _previousTaxFee = _taxFee;
653           _previousBurnFee = _burnFee;
654           
655           _taxFee = 0;
656           _burnFee = 0;
657       }
658       
659       function restoreAllFee() private {
660           _taxFee = _previousTaxFee;
661           _burnFee = _previousBurnFee;
662       }
663 
664 
665       function _transferStandard(address from, address to, uint256 amount) private {
666         uint256 transferAmount = _getTransferValues(amount);
667         
668         _balances[from] = _balances[from] - amount;
669         _balances[to] = _balances[to] + transferAmount;
670         
671         burnFeeTransfer(from, amount);
672         taxFeeTransfer(from, amount);
673         
674         emit Transfer(from, to, transferAmount);
675     }
676 
677     function _getTransferValues(uint256 amount) private view returns(uint256) {
678         uint256 taxValue = _getCompleteTaxValue(amount);
679         uint256 transferAmount = amount - taxValue;
680         return transferAmount;
681     }
682     
683     function _getCompleteTaxValue(uint256 amount) private view returns(uint256) {
684         uint256 allTaxes = _taxFee + _burnFee;
685         uint256 taxValue = amount * allTaxes / 100;
686         return taxValue;
687     }
688     
689     
690     function burnFeeTransfer(address sender, uint256 amount) private {
691         uint256 burnFee = amount * _burnFee / 100;
692         if(burnFee > 0){
693             _totalSupply = _totalSupply - burnFee;
694             emit Transfer(sender, address(0), burnFee);
695         }
696     }
697     
698     function taxFeeTransfer(address sender, uint256 amount) private {
699         uint256 taxFee = amount * _taxFee / 100;
700         if(taxFee > 0){
701             _balances[_feeAccount] = _balances[_feeAccount] + taxFee;
702             emit Transfer(sender, _feeAccount, taxFee);
703         }
704     }
705 }