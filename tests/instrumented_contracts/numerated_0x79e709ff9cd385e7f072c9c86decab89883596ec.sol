1 // SPDX-License-Identifier: MIT
2 pragma solidity =0.8.13;
3 
4 
5 
6 interface IERC20 {
7     /**
8      * @dev Returns the amount of tokens in existence.
9      */
10     function totalSupply() external view returns (uint256);
11 
12     /**
13      * @dev Returns the amount of tokens owned by `account`.
14      */
15     function balanceOf(address account) external view returns (uint256);
16 
17     /**
18      * @dev Moves `amount` tokens from the caller's account to `to`.
19      *
20      * Returns a boolean value indicating whether the operation succeeded.
21      *
22      * Emits a {Transfer} event.
23      */
24     function transfer(address to, uint256 amount) external returns (bool);
25 
26     /**
27      * @dev Returns the remaining number of tokens that `spender` will be
28      * allowed to spend on behalf of `owner` through {transferFrom}. This is
29      * zero by default.
30      *
31      * This value changes when {approve} or {transferFrom} are called.
32      */
33     function allowance(address owner, address spender) external view returns (uint256);
34 
35     /**
36      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
37      *
38      * Returns a boolean value indicating whether the operation succeeded.
39      *
40      * IMPORTANT: Beware that changing an allowance with this method brings the risk
41      * that someone may use both the old and the new allowance by unfortunate
42      * transaction ordering. One possible solution to mitigate this race
43      * condition is to first reduce the spender's allowance to 0 and set the
44      * desired value afterwards:
45      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
46      *
47      * Emits an {Approval} event.
48      */
49     function approve(address spender, uint256 amount) external returns (bool);
50 
51     /**
52      * @dev Moves `amount` tokens from `from` to `to` using the
53      * allowance mechanism. `amount` is then deducted from the caller's
54      * allowance.
55      *
56      * Returns a boolean value indicating whether the operation succeeded.
57      *
58      * Emits a {Transfer} event.
59      */
60     function transferFrom(
61         address from,
62         address to,
63         uint256 amount
64     ) external returns (bool);
65 
66     /**
67      * @dev Emitted when `value` tokens are moved from one account (`from`) to
68      * another (`to`).
69      *
70      * Note that `value` may be zero.
71      */
72     event Transfer(address indexed from, address indexed to, uint256 value);
73 
74     /**
75      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
76      * a call to {approve}. `value` is the new allowance.
77      */
78     event Approval(address indexed owner, address indexed spender, uint256 value);
79 }
80 
81 
82 interface IERC20Metadata is IERC20 {
83     /**
84      * @dev Returns the name of the token.
85      */
86     function name() external view returns (string memory);
87 
88     /**
89      * @dev Returns the symbol of the token.
90      */
91     function symbol() external view returns (string memory);
92 
93     /**
94      * @dev Returns the decimals places of the token.
95      */
96     function decimals() external view returns (uint8);
97 }
98 
99 
100 
101 abstract contract Context {
102     function _msgSender() internal view virtual returns (address) {
103         return msg.sender;
104     }
105 
106     function _msgData() internal view virtual returns (bytes calldata) {
107         return msg.data;
108     }
109 }
110 
111 
112 
113 abstract contract Ownable is Context {
114     address private _owner;
115 
116     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
117 
118     /**
119      * @dev Initializes the contract setting the deployer as the initial owner.
120      */
121     constructor() {
122         _transferOwnership(_msgSender());
123     }
124 
125     /**
126      * @dev Returns the address of the current owner.
127      */
128     function owner() public view virtual returns (address) {
129         return _owner;
130     }
131 
132     /**
133      * @dev Throws if called by any account other than the owner.
134      */
135     modifier onlyOwner() {
136         require(owner() == _msgSender(), "Ownable: caller is not the owner");
137         _;
138     }
139 
140     /**
141      * @dev Leaves the contract without owner. It will not be possible to call
142      * `onlyOwner` functions anymore. Can only be called by the current owner.
143      *
144      * NOTE: Renouncing ownership will leave the contract without an owner,
145      * thereby removing any functionality that is only available to the owner.
146      */
147     function renounceOwnership() public virtual onlyOwner {
148         _transferOwnership(address(0));
149     }
150 
151     /**
152      * @dev Transfers ownership of the contract to a new account (`newOwner`).
153      * Can only be called by the current owner.
154      */
155     function transferOwnership(address newOwner) public virtual onlyOwner {
156         require(newOwner != address(0), "Ownable: new owner is the zero address");
157         _transferOwnership(newOwner);
158     }
159 
160     /**
161      * @dev Transfers ownership of the contract to a new account (`newOwner`).
162      * Internal function without access restriction.
163      */
164     function _transferOwnership(address newOwner) internal virtual {
165         address oldOwner = _owner;
166         _owner = newOwner;
167         emit OwnershipTransferred(oldOwner, newOwner);
168     }
169 }
170 
171 contract ERC20 is Context, IERC20, IERC20Metadata {
172     mapping(address => uint256) private _balances;
173 
174     mapping(address => mapping(address => uint256)) private _allowances;
175 
176     uint256 private _totalSupply;
177 
178     string private _name;
179     string private _symbol;
180 
181     /**
182      * @dev Sets the values for {name} and {symbol}.
183      *
184      * The default value of {decimals} is 18. To select a different value for
185      * {decimals} you should overload it.
186      *
187      * All two of these values are immutable: they can only be set once during
188      * construction.
189      */
190     constructor(string memory name_, string memory symbol_) {
191         _name = name_;
192         _symbol = symbol_;
193     }
194 
195     /**
196      * @dev Returns the name of the token.
197      */
198     function name() public view virtual override returns (string memory) {
199         return _name;
200     }
201 
202     /**
203      * @dev Returns the symbol of the token, usually a shorter version of the
204      * name.
205      */
206     function symbol() public view virtual override returns (string memory) {
207         return _symbol;
208     }
209 
210     /**
211      * @dev Returns the number of decimals used to get its user representation.
212      * For example, if `decimals` equals `2`, a balance of `505` tokens should
213      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
214      *
215      * Tokens usually opt for a value of 18, imitating the relationship between
216      * Ether and Wei. This is the value {ERC20} uses, unless this function is
217      * overridden;
218      *
219      * NOTE: This information is only used for _display_ purposes: it in
220      * no way affects any of the arithmetic of the contract, including
221      * {IERC20-balanceOf} and {IERC20-transfer}.
222      */
223     function decimals() public view virtual override returns (uint8) {
224         return 18;
225     }
226 
227     /**
228      * @dev See {IERC20-totalSupply}.
229      */
230     function totalSupply() public view virtual override returns (uint256) {
231         return _totalSupply;
232     }
233 
234     /**
235      * @dev See {IERC20-balanceOf}.
236      */
237     function balanceOf(address account) public view virtual override returns (uint256) {
238         return _balances[account];
239     }
240 
241     /**
242      * @dev See {IERC20-transfer}.
243      *
244      * Requirements:
245      *
246      * - `to` cannot be the zero address.
247      * - the caller must have a balance of at least `amount`.
248      */
249     function transfer(address to, uint256 amount) public virtual override returns (bool) {
250         address owner = _msgSender();
251         _transfer(owner, to, amount);
252         return true;
253     }
254 
255     /**
256      * @dev See {IERC20-allowance}.
257      */
258     function allowance(address owner, address spender) public view virtual override returns (uint256) {
259         return _allowances[owner][spender];
260     }
261 
262     /**
263      * @dev See {IERC20-approve}.
264      *
265      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
266      * `transferFrom`. This is semantically equivalent to an infinite approval.
267      *
268      * Requirements:
269      *
270      * - `spender` cannot be the zero address.
271      */
272     function approve(address spender, uint256 amount) public virtual override returns (bool) {
273         address owner = _msgSender();
274         _approve(owner, spender, amount);
275         return true;
276     }
277 
278     /**
279      * @dev See {IERC20-transferFrom}.
280      *
281      * Emits an {Approval} event indicating the updated allowance. This is not
282      * required by the EIP. See the note at the beginning of {ERC20}.
283      *
284      * NOTE: Does not update the allowance if the current allowance
285      * is the maximum `uint256`.
286      *
287      * Requirements:
288      *
289      * - `from` and `to` cannot be the zero address.
290      * - `from` must have a balance of at least `amount`.
291      * - the caller must have allowance for ``from``'s tokens of at least
292      * `amount`.
293      */
294     function transferFrom(
295         address from,
296         address to,
297         uint256 amount
298     ) public virtual override returns (bool) {
299         address spender = _msgSender();
300         _spendAllowance(from, spender, amount);
301         _transfer(from, to, amount);
302         return true;
303     }
304 
305     /**
306      * @dev Atomically increases the allowance granted to `spender` by the caller.
307      *
308      * This is an alternative to {approve} that can be used as a mitigation for
309      * problems described in {IERC20-approve}.
310      *
311      * Emits an {Approval} event indicating the updated allowance.
312      *
313      * Requirements:
314      *
315      * - `spender` cannot be the zero address.
316      */
317     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
318         address owner = _msgSender();
319         _approve(owner, spender, _allowances[owner][spender] + addedValue);
320         return true;
321     }
322 
323     /**
324      * @dev Atomically decreases the allowance granted to `spender` by the caller.
325      *
326      * This is an alternative to {approve} that can be used as a mitigation for
327      * problems described in {IERC20-approve}.
328      *
329      * Emits an {Approval} event indicating the updated allowance.
330      *
331      * Requirements:
332      *
333      * - `spender` cannot be the zero address.
334      * - `spender` must have allowance for the caller of at least
335      * `subtractedValue`.
336      */
337     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
338         address owner = _msgSender();
339         uint256 currentAllowance = _allowances[owner][spender];
340         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
341         unchecked {
342             _approve(owner, spender, currentAllowance - subtractedValue);
343         }
344 
345         return true;
346     }
347 
348     /**
349      * @dev Moves `amount` of tokens from `sender` to `recipient`.
350      *
351      * This internal function is equivalent to {transfer}, and can be used to
352      * e.g. implement automatic token fees, slashing mechanisms, etc.
353      *
354      * Emits a {Transfer} event.
355      *
356      * Requirements:
357      *
358      * - `from` cannot be the zero address.
359      * - `to` cannot be the zero address.
360      * - `from` must have a balance of at least `amount`.
361      */
362     function _transfer(
363         address from,
364         address to,
365         uint256 amount
366     ) internal virtual {
367         require(from != address(0), "ERC20: transfer from the zero address");
368         require(to != address(0), "ERC20: transfer to the zero address");
369 
370         _beforeTokenTransfer(from, to, amount);
371 
372         uint256 fromBalance = _balances[from];
373         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
374         unchecked {
375             _balances[from] = fromBalance - amount;
376         }
377         _balances[to] += amount;
378 
379         emit Transfer(from, to, amount);
380 
381         _afterTokenTransfer(from, to, amount);
382     }
383 
384     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
385      * the total supply.
386      *
387      * Emits a {Transfer} event with `from` set to the zero address.
388      *
389      * Requirements:
390      *
391      * - `account` cannot be the zero address.
392      */
393     function _mint(address account, uint256 amount) internal virtual {
394         require(account != address(0), "ERC20: mint to the zero address");
395 
396         _beforeTokenTransfer(address(0), account, amount);
397 
398         _totalSupply += amount;
399         _balances[account] += amount;
400         emit Transfer(address(0), account, amount);
401 
402         _afterTokenTransfer(address(0), account, amount);
403     }
404 
405     /**
406      * @dev Destroys `amount` tokens from `account`, reducing the
407      * total supply.
408      *
409      * Emits a {Transfer} event with `to` set to the zero address.
410      *
411      * Requirements:
412      *
413      * - `account` cannot be the zero address.
414      * - `account` must have at least `amount` tokens.
415      */
416     function _burn(address account, uint256 amount) internal virtual {
417         require(account != address(0), "ERC20: burn from the zero address");
418 
419         _beforeTokenTransfer(account, address(0), amount);
420 
421         uint256 accountBalance = _balances[account];
422         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
423         unchecked {
424             _balances[account] = accountBalance - amount;
425         }
426         _totalSupply -= amount;
427 
428         emit Transfer(account, address(0), amount);
429 
430         _afterTokenTransfer(account, address(0), amount);
431     }
432 
433     /**
434      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
435      *
436      * This internal function is equivalent to `approve`, and can be used to
437      * e.g. set automatic allowances for certain subsystems, etc.
438      *
439      * Emits an {Approval} event.
440      *
441      * Requirements:
442      *
443      * - `owner` cannot be the zero address.
444      * - `spender` cannot be the zero address.
445      */
446     function _approve(
447         address owner,
448         address spender,
449         uint256 amount
450     ) internal virtual {
451         require(owner != address(0), "ERC20: approve from the zero address");
452         require(spender != address(0), "ERC20: approve to the zero address");
453 
454         _allowances[owner][spender] = amount;
455         emit Approval(owner, spender, amount);
456     }
457 
458     /**
459      * @dev Spend `amount` form the allowance of `owner` toward `spender`.
460      *
461      * Does not update the allowance amount in case of infinite allowance.
462      * Revert if not enough allowance is available.
463      *
464      * Might emit an {Approval} event.
465      */
466     function _spendAllowance(
467         address owner,
468         address spender,
469         uint256 amount
470     ) internal virtual {
471         uint256 currentAllowance = allowance(owner, spender);
472         if (currentAllowance != type(uint256).max) {
473             require(currentAllowance >= amount, "ERC20: insufficient allowance");
474             unchecked {
475                 _approve(owner, spender, currentAllowance - amount);
476             }
477         }
478     }
479 
480     /**
481      * @dev Hook that is called before any transfer of tokens. This includes
482      * minting and burning.
483      *
484      * Calling conditions:
485      *
486      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
487      * will be transferred to `to`.
488      * - when `from` is zero, `amount` tokens will be minted for `to`.
489      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
490      * - `from` and `to` are never both zero.
491      *
492      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
493      */
494     function _beforeTokenTransfer(
495         address from,
496         address to,
497         uint256 amount
498     ) internal virtual {}
499 
500     /**
501      * @dev Hook that is called after any transfer of tokens. This includes
502      * minting and burning.
503      *
504      * Calling conditions:
505      *
506      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
507      * has been transferred to `to`.
508      * - when `from` is zero, `amount` tokens have been minted for `to`.
509      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
510      * - `from` and `to` are never both zero.
511      *
512      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
513      */
514     function _afterTokenTransfer(
515         address from,
516         address to,
517         uint256 amount
518     ) internal virtual {}
519 }
520 
521 
522 
523 contract Edith is ERC20, Ownable {
524     mapping (address => uint256) private _rOwned;
525     mapping (address => bool) private _isHolder;
526     address[] private _holders;
527     
528     //mapping (address => uint256) private _tOwned;
529     mapping (address => mapping (address => uint256)) private _allowances;
530 
531     //recieves no reflections, transfers from are untaxed
532     mapping (address => bool) private _isExcluded; 
533     //recieves no reflections, all transfers are untaxed. All items on this list need to also be on _isExcluded.
534     mapping (address => bool) private _isCompletelyExcluded;
535 
536     //address[] private _holders;
537     address[] private _excluded;
538    
539     uint256 private constant MAX = 2**128 - 1;
540     uint256 private constant _tTotal = 10 * 10**6 * 10**5;
541     uint256 private _rTotal = (MAX - (MAX % _tTotal));
542     uint256 private _rTotalInitial = _rTotal;
543     uint256 private _tFeeTotal;
544 
545     uint256 private _taxLowerBound = 0;
546     uint256 private _taxUpperBound = 0;
547     uint256 private constant _taxMaximum = 50; //sets the absolute max tax
548     uint256 private _taxMaximumCutoff = 50; 
549     bool private _rSupplyNeedsReset = false;
550 
551     string private constant _name = "Edith";
552     string private constant _symbol = "EDTH";
553     uint8 private constant _decimals = 5;
554 
555     constructor () ERC20("Edith", "EDTH") {
556         address sender = _msgSender();
557         _rOwned[sender] = _rTotal;
558         _isHolder[sender] = true;
559         _holders.push(sender);
560         setTaxRates(2, 20);
561         emit Transfer(address(0), sender, _tTotal);
562     }
563 
564     function min(uint256 a, uint256 b) private pure returns(uint256) {
565         if (a <= b) {
566             return a;
567         } else {
568             return b;
569         }
570     }
571 
572     function setTaxRates(uint256 LB, uint256 UB) public onlyOwner returns(bool) {
573         require(LB <= UB, "lower bound must be less than or equal to upper bound");
574         require(UB <= _taxMaximum, "upper bound must be less than or equal to _taxMaximum");
575         require(!_rSupplyNeedsReset, "the tax functionality has been permenantly disabled for this contract");
576         _taxLowerBound = LB;
577         _taxUpperBound = UB;
578         return true;
579     }
580 
581     function setTaxMaximumCutoff(uint256 cutoff) public onlyOwner returns(bool) {
582         require(cutoff >= _tTotal/10, "cutoff must be >= 1/10th of the total supply");
583         _taxMaximumCutoff = cutoff;
584         return true;
585     }
586 
587     function getTaxMaximumCutoff() public view returns(uint256) {
588         return _taxMaximumCutoff;
589     }
590 
591     function getTaxRates() public view returns(uint256, uint256) {
592         return(_taxLowerBound, _taxUpperBound);
593     }
594 
595     function getTaxableState() public view returns(bool){
596         return !_rSupplyNeedsReset;
597     }
598 
599     function name() public pure override returns (string memory) {
600         return _name;
601     }
602 
603     function symbol() public pure override returns (string memory) {
604         return _symbol;
605     }
606 
607     function decimals() public pure override returns (uint8) {
608         return _decimals;
609     }
610 
611     function totalSupply() public pure override returns (uint256) {
612         return _tTotal;
613     }
614 
615     function rSupply() public view returns(uint256) {
616         return _rTotal;
617     }
618 
619     function rOwned(address account) public view returns(uint256) {
620         return _rOwned[account];
621     }
622 
623     function balanceOf(address account) public view override returns (uint256) {
624         // uint256 rAmount = _rOwned[account];
625         // uint256 currentRate =  _getRate();
626         // return rAmount/currentRate;
627         return (_rOwned[account]*_tTotal)/_rTotal;
628     }
629 
630     function transfer(address recipient, uint256 amount) public override returns (bool) {
631         _transfer(_msgSender(), recipient, amount);
632         if (!_isHolder[recipient]) {
633             _isHolder[recipient] = true;
634             _holders.push(recipient);
635         }
636         return true;
637     }
638 
639     function allowance(address owner, address spender) public view override returns (uint256) {
640         return _allowances[owner][spender];
641     }
642 
643     function approve(address spender, uint256 amount) public override returns (bool) {
644         _approve(_msgSender(), spender, amount);
645         return true;
646     }
647 
648     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
649         uint256 allowed = _allowances[sender][_msgSender()];
650         require(amount <= allowed, "transferring too much edith");
651         _approve(sender, _msgSender(), allowed - amount);
652         _transfer(sender, recipient, amount);
653         return true;
654     }
655 
656     function increaseAllowance(address spender, uint256 addedValue) public override returns (bool) {
657         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
658         return true;
659     }
660 
661     function decreaseAllowance(address spender, uint256 subtractedValue) public override returns (bool) {
662         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] - subtractedValue);
663         return true;
664     }
665 
666     function isExcluded(address account) public view returns (bool) {
667         return _isExcluded[account];
668     }
669 
670     function isCompletelyExcluded(address account) public view returns (bool) {
671         return _isCompletelyExcluded[account];
672     }
673 
674     function totalFees() public view returns (uint256) {
675         return _tFeeTotal;
676     }
677 
678     function excludeAccount(address account) external onlyOwner() {
679         require(!_isExcluded[account], "Account is already excluded");
680         _isExcluded[account] = true;
681         _excluded.push(account);
682     }
683 
684     function completelyExcludeAccount(address account) external onlyOwner() {
685         require(!_isCompletelyExcluded[account], "Account is already completely excluded");
686         _isCompletelyExcluded[account] = true;
687         // check if already on excluded list. if not, add it.
688         if (!_isExcluded[account]){
689             _isExcluded[account] = true;
690             _excluded.push(account);
691         }
692     }
693 
694     function numExcluded() public view returns(uint256) {
695         return _excluded.length;
696     }
697 
698     function viewExcluded(uint256 n) public view returns(address) {
699         require(n < _excluded.length, "n is too big");
700         return _excluded[n];
701     }
702 
703     function includeAccount(address account) external onlyOwner() {
704         require(_isExcluded[account], "Account is already included");
705         for (uint256 i = 0; i < _excluded.length; i++) {
706             if (_excluded[i] == account) {
707                 _excluded[i] = _excluded[_excluded.length - 1];
708                 //_tOwned[account] = 0;
709                 _isExcluded[account] = false;
710                 _isCompletelyExcluded[account] = false;
711                 _excluded.pop();
712                 break;
713             }
714         }
715     }
716 
717     function _approve(address owner, address spender, uint256 amount) internal override {
718         require(owner != address(0), "ERC20: approve from the zero address");
719         require(spender != address(0), "ERC20: approve to the zero address");
720 
721         _allowances[owner][spender] = amount;
722         emit Approval(owner, spender, amount);
723     }
724 
725     function _transfer(address sender, address recipient, uint256 amount) internal override{
726         require(sender != address(0), "ERC20: transfer from the zero address");
727         require(recipient != address(0), "ERC20: transfer to the zero address");
728         require(amount > 0, "Transfer amount must be greater than zero");
729 
730 
731         if (_isExcluded[sender] || _isCompletelyExcluded[recipient] || _rSupplyNeedsReset || _taxUpperBound == 0) {
732             //sender excluded or both excluded, or recipient completely excluded
733             _transferTaxFree(sender, recipient, amount);
734         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
735             _transferToExcluded(sender, recipient, amount);
736         } else {
737             uint256 excludedRowned = 0;
738             if (!_isExcluded[sender]){
739                 excludedRowned += _rOwned[sender];
740             }
741             if (!_isExcluded[recipient]){
742                 excludedRowned += _rOwned[recipient];
743             }
744             for (uint256 i = 0; i < _excluded.length; i++){
745                 excludedRowned += _rOwned[_excluded[i]];
746             }
747             if (excludedRowned > (99*_rTotal)/100){
748                 _transferTaxFree(sender, recipient, amount);
749             } else {
750                 _transferStandard(sender, recipient, amount);
751             }
752             
753         }
754     }
755 
756     //struct needed to avoid "stack too deep" compile error
757     struct stackTooDeepStruct {
758         uint256 n1;
759         uint256 n2;
760         uint256 n3;
761         uint256 temp;
762         uint256 a;
763         uint256 b;
764         uint256 c;
765     }
766 
767     struct accountInfo {
768         address account;
769         uint256 rOwned;
770     }
771 
772     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
773         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount); //, rSupply, tSupply);
774         uint256 ne = numExcluded();
775 
776         uint256[] memory excludedROwned = new uint256[](ne);
777         uint256 totalExcluded = 0;
778 
779         for (uint i = 0; i < ne; i++){
780             excludedROwned[i] = _rOwned[_excluded[i]];
781             totalExcluded += excludedROwned[i];
782         }
783 
784         stackTooDeepStruct memory std;
785         std.n1 = _rOwned[sender] - rAmount;
786         std.n2 = _rOwned[recipient] + rTransferAmount;
787         std.n3 = totalExcluded;
788         std.temp = _rTotal- std.n1 - std.n2 - std.n3;
789 
790         std.a = (rFee*std.n1)/std.temp;
791         std.b = (rFee*std.n2)/std.temp;
792         std.c = (rFee*std.n3)/std.temp;
793 
794 
795         _rOwned[sender] = std.n1 - std.a;
796         _rOwned[recipient] = std.n2 - std.b;
797         uint256 subtractedTotal = 0;
798         uint256 toSubtract;
799         if (totalExcluded > 0){
800             for (uint i=0; i < ne; i++){
801                 toSubtract = (std.c*excludedROwned[i])/totalExcluded;
802                 _rOwned[_excluded[i]] = excludedROwned[i] - toSubtract;
803                 subtractedTotal += toSubtract;
804             }
805             //_rOwned[_excluded[ne-1]] = excludedROwned[ne-1] - (std.c - subtractedTotal);
806         }
807         _reflectFee(rFee + std.a + std.b + subtractedTotal, tFee);
808         emit Transfer(sender, recipient, tTransferAmount);
809 
810     }
811 
812     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
813         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount); //, rSupply, tSupply);
814 
815         uint256 ne = numExcluded();
816 
817         // for this one, excludedInfo refers to accounts *other than* the recipient.
818         // otherwise, this function is the same as transferStandard.
819         // i.e. the recipient is just another excluded account.
820         accountInfo[] memory excludedInfo = new accountInfo[](ne - 1);
821         uint256 totalExcluded = 0;
822 
823         uint256 arrayIndex = 0;
824         for (uint i = 0; i < ne; i++){
825             if (_excluded[i] != recipient){
826                 excludedInfo[arrayIndex].account = _excluded[i];
827                 excludedInfo[arrayIndex].rOwned = _rOwned[excludedInfo[arrayIndex].account];
828                 totalExcluded += excludedInfo[arrayIndex].rOwned;
829                 arrayIndex += 1;
830             }
831         }
832 
833         stackTooDeepStruct memory std;
834         std.n1 = _rOwned[sender] - rAmount;
835         std.n2 = _rOwned[recipient] + rTransferAmount;
836         std.n3 = totalExcluded;
837         std.temp = _rTotal - std.n1 - std.n2 - std.n3;
838 
839         std.a = (rFee*std.n1)/std.temp;
840         std.b = (rFee*std.n2)/std.temp;
841         std.c = (rFee*std.n3)/std.temp;
842 
843         _rOwned[sender] = std.n1 - std.a;
844         _rOwned[recipient] = std.n2 - std.b;
845 
846         uint256 subtractedTotal = 0;
847         uint256 toSubtract;
848         if (totalExcluded > 0){
849             for (uint i = 0; i < excludedInfo.length; i++){
850                 toSubtract = (std.c * excludedInfo[i].rOwned) / totalExcluded;
851                 _rOwned[excludedInfo[i].account] = excludedInfo[i].rOwned - toSubtract;
852                 subtractedTotal += toSubtract;
853             }
854             //_rOwned[excludedInfo[excludedInfo.length - 1].account] = excludedInfo[excludedInfo.length - 1].rOwned - (std.c - subtractedTotal);
855         }
856         _reflectFee(rFee + std.a + std.b + subtractedTotal, tFee);
857         emit Transfer(sender, recipient, tTransferAmount);
858     }
859 
860 
861     function _transferTaxFree(address sender, address recipient, uint256 tAmount) private {
862         // uint256 currentRate = _rTotal / _tTotal;
863         // uint256 rAmount = tAmount * currentRate;
864         uint256 rAmount = (tAmount * _rTotal) / _tTotal;
865         _rOwned[sender] = _rOwned[sender] - rAmount;
866         _rOwned[recipient] = _rOwned[recipient] + rAmount; 
867         emit Transfer(sender, recipient, tAmount);
868     }
869 
870     function _reflectFee(uint256 rFee, uint256 tFee) private {
871         _rTotal -= rFee;
872         _tFeeTotal += tFee;
873     }
874 
875     function calculateTax(uint256 tAmount) public view returns (uint256) {
876         uint256 cutoffTSupply = (_tTotal * _taxMaximumCutoff) / 100;
877         uint256 taxTemp = _taxLowerBound + ((_taxUpperBound - _taxLowerBound)*tAmount)/cutoffTSupply;
878         return min(taxTemp, _taxUpperBound);
879     }
880 
881     function _getValues(uint256 tAmount) private returns (uint256, uint256, uint256, uint256, uint256) {
882         //check for rSupply depletion
883         if (!_rSupplyNeedsReset) {
884             if (_rTotal < 15 * _tTotal){
885                 _rSupplyNeedsReset = true;
886             }
887         }
888 
889         //calculates tax based on amount being transferred
890         uint256 tax = calculateTax(tAmount); //_taxLowerBound + (_taxUpperBound - _taxLowerBound) * tAmount.div(tSupply);
891 
892         (uint256 tTransferAmount, uint256 tFee) = _getTValues(tAmount, tax);
893         //uint256 currentRate =  _getRate();
894         //uint256 currentRate = _getRate();
895         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee);
896         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee);
897     }
898 
899     function _getTValues(uint256 tAmount, uint256 tax) private pure returns (uint256, uint256) {
900         uint256 tFee = (tAmount * tax) / 100;
901         uint256 tTransferAmount = tAmount - tFee;
902         return (tTransferAmount, tFee);
903     }
904 
905     function _getRValues(uint256 tAmount, uint256 tFee) private view returns (uint256, uint256, uint256) {
906         uint256 rAmount = (tAmount * _rTotal) / _tTotal;
907         uint256 rFee = (tFee * _rTotal) / _tTotal;
908         uint256 rTransferAmount = rAmount - rFee;
909         return (rAmount, rTransferAmount, rFee);
910     }
911 
912     function resetRSupply() public onlyOwner returns(bool) {
913         uint256 newROwned;
914         uint256 totalNewROwned;
915         for (uint256 i = 0; i < _holders.length; i++) {
916             newROwned = (_rOwned[_holders[i]]*_rTotalInitial)/_rTotal;
917             totalNewROwned += newROwned;
918             _rOwned[_holders[i]] = newROwned;
919         }
920         _rTotal = totalNewROwned;
921         _rSupplyNeedsReset = false;
922         return true;
923     }
924 }