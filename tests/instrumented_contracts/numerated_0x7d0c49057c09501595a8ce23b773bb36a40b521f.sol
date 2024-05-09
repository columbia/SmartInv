1 // SPDX-License-Identifier: UNLICENSED
2 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
3 
4 
5 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
6 
7 pragma solidity ^0.8.0;
8 
9 /**
10  * @dev Interface of the ERC20 standard as defined in the EIP.
11  */
12 interface IERC20 {
13     /**
14      * @dev Emitted when `value` tokens are moved from one account (`from`) to
15      * another (`to`).
16      *
17      * Note that `value` may be zero.
18      */
19     event Transfer(address indexed from, address indexed to, uint256 value);
20 
21     /**
22      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
23      * a call to {approve}. `value` is the new allowance.
24      */
25     event Approval(address indexed owner, address indexed spender, uint256 value);
26 
27     /**
28      * @dev Returns the amount of tokens in existence.
29      */
30     function totalSupply() external view returns (uint256);
31 
32     /**
33      * @dev Returns the amount of tokens owned by `account`.
34      */
35     function balanceOf(address account) external view returns (uint256);
36 
37     /**
38      * @dev Moves `amount` tokens from the caller's account to `to`.
39      *
40      * Returns a boolean value indicating whether the operation succeeded.
41      *
42      * Emits a {Transfer} event.
43      */
44     function transfer(address to, uint256 amount) external returns (bool);
45 
46     /**
47      * @dev Returns the remaining number of tokens that `spender` will be
48      * allowed to spend on behalf of `owner` through {transferFrom}. This is
49      * zero by default.
50      *
51      * This value changes when {approve} or {transferFrom} are called.
52      */
53     function allowance(address owner, address spender) external view returns (uint256);
54 
55     /**
56      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
57      *
58      * Returns a boolean value indicating whether the operation succeeded.
59      *
60      * IMPORTANT: Beware that changing an allowance with this method brings the risk
61      * that someone may use both the old and the new allowance by unfortunate
62      * transaction ordering. One possible solution to mitigate this race
63      * condition is to first reduce the spender's allowance to 0 and set the
64      * desired value afterwards:
65      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
66      *
67      * Emits an {Approval} event.
68      */
69     function approve(address spender, uint256 amount) external returns (bool);
70 
71     /**
72      * @dev Moves `amount` tokens from `from` to `to` using the
73      * allowance mechanism. `amount` is then deducted from the caller's
74      * allowance.
75      *
76      * Returns a boolean value indicating whether the operation succeeded.
77      *
78      * Emits a {Transfer} event.
79      */
80     function transferFrom(
81         address from,
82         address to,
83         uint256 amount
84     ) external returns (bool);
85 }
86 
87 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
88 
89 
90 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
91 
92 pragma solidity ^0.8.0;
93 
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
117 // File: @openzeppelin/contracts/utils/Context.sol
118 
119 
120 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
121 
122 pragma solidity ^0.8.0;
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
144 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
145 
146 
147 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC20/ERC20.sol)
148 
149 pragma solidity ^0.8.0;
150 
151 
152 
153 
154 /**
155  * @dev Implementation of the {IERC20} interface.
156  *
157  * This implementation is agnostic to the way tokens are created. This means
158  * that a supply mechanism has to be added in a derived contract using {_mint}.
159  * For a generic mechanism see {ERC20PresetMinterPauser}.
160  *
161  * TIP: For a detailed writeup see our guide
162  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
163  * to implement supply mechanisms].
164  *
165  * We have followed general OpenZeppelin Contracts guidelines: functions revert
166  * instead returning `false` on failure. This behavior is nonetheless
167  * conventional and does not conflict with the expectations of ERC20
168  * applications.
169  *
170  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
171  * This allows applications to reconstruct the allowance for all accounts just
172  * by listening to said events. Other implementations of the EIP may not emit
173  * these events, as it isn't required by the specification.
174  *
175  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
176  * functions have been added to mitigate the well-known issues around setting
177  * allowances. See {IERC20-approve}.
178  */
179 contract ERC20 is Context, IERC20, IERC20Metadata {
180     mapping(address => uint256) private _balances;
181 
182     mapping(address => mapping(address => uint256)) private _allowances;
183 
184     uint256 private _totalSupply;
185 
186     string private _name;
187     string private _symbol;
188 
189     /**
190      * @dev Sets the values for {name} and {symbol}.
191      *
192      * The default value of {decimals} is 18. To select a different value for
193      * {decimals} you should overload it.
194      *
195      * All two of these values are immutable: they can only be set once during
196      * construction.
197      */
198     constructor(string memory name_, string memory symbol_) {
199         _name = name_;
200         _symbol = symbol_;
201     }
202 
203     /**
204      * @dev Returns the name of the token.
205      */
206     function name() public view virtual override returns (string memory) {
207         return _name;
208     }
209 
210     /**
211      * @dev Returns the symbol of the token, usually a shorter version of the
212      * name.
213      */
214     function symbol() public view virtual override returns (string memory) {
215         return _symbol;
216     }
217 
218     /**
219      * @dev Returns the number of decimals used to get its user representation.
220      * For example, if `decimals` equals `2`, a balance of `505` tokens should
221      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
222      *
223      * Tokens usually opt for a value of 18, imitating the relationship between
224      * Ether and Wei. This is the value {ERC20} uses, unless this function is
225      * overridden;
226      *
227      * NOTE: This information is only used for _display_ purposes: it in
228      * no way affects any of the arithmetic of the contract, including
229      * {IERC20-balanceOf} and {IERC20-transfer}.
230      */
231     function decimals() public view virtual override returns (uint8) {
232         return 18;
233     }
234 
235     /**
236      * @dev See {IERC20-totalSupply}.
237      */
238     function totalSupply() public view virtual override returns (uint256) {
239         return _totalSupply;
240     }
241 
242     /**
243      * @dev See {IERC20-balanceOf}.
244      */
245     function balanceOf(address account) public view virtual override returns (uint256) {
246         return _balances[account];
247     }
248 
249     /**
250      * @dev See {IERC20-transfer}.
251      *
252      * Requirements:
253      *
254      * - `to` cannot be the zero address.
255      * - the caller must have a balance of at least `amount`.
256      */
257     function transfer(address to, uint256 amount) public virtual override returns (bool) {
258         address owner = _msgSender();
259         _transfer(owner, to, amount);
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
273      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
274      * `transferFrom`. This is semantically equivalent to an infinite approval.
275      *
276      * Requirements:
277      *
278      * - `spender` cannot be the zero address.
279      */
280     function approve(address spender, uint256 amount) public virtual override returns (bool) {
281         address owner = _msgSender();
282         _approve(owner, spender, amount);
283         return true;
284     }
285 
286     /**
287      * @dev See {IERC20-transferFrom}.
288      *
289      * Emits an {Approval} event indicating the updated allowance. This is not
290      * required by the EIP. See the note at the beginning of {ERC20}.
291      *
292      * NOTE: Does not update the allowance if the current allowance
293      * is the maximum `uint256`.
294      *
295      * Requirements:
296      *
297      * - `from` and `to` cannot be the zero address.
298      * - `from` must have a balance of at least `amount`.
299      * - the caller must have allowance for ``from``'s tokens of at least
300      * `amount`.
301      */
302     function transferFrom(
303         address from,
304         address to,
305         uint256 amount
306     ) public virtual override returns (bool) {
307         address spender = _msgSender();
308         _spendAllowance(from, spender, amount);
309         _transfer(from, to, amount);
310         return true;
311     }
312 
313     /**
314      * @dev Atomically increases the allowance granted to `spender` by the caller.
315      *
316      * This is an alternative to {approve} that can be used as a mitigation for
317      * problems described in {IERC20-approve}.
318      *
319      * Emits an {Approval} event indicating the updated allowance.
320      *
321      * Requirements:
322      *
323      * - `spender` cannot be the zero address.
324      */
325     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
326         address owner = _msgSender();
327         _approve(owner, spender, allowance(owner, spender) + addedValue);
328         return true;
329     }
330 
331     /**
332      * @dev Atomically decreases the allowance granted to `spender` by the caller.
333      *
334      * This is an alternative to {approve} that can be used as a mitigation for
335      * problems described in {IERC20-approve}.
336      *
337      * Emits an {Approval} event indicating the updated allowance.
338      *
339      * Requirements:
340      *
341      * - `spender` cannot be the zero address.
342      * - `spender` must have allowance for the caller of at least
343      * `subtractedValue`.
344      */
345     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
346         address owner = _msgSender();
347         uint256 currentAllowance = allowance(owner, spender);
348         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
349         unchecked {
350             _approve(owner, spender, currentAllowance - subtractedValue);
351         }
352 
353         return true;
354     }
355 
356     /**
357      * @dev Moves `amount` of tokens from `from` to `to`.
358      *
359      * This internal function is equivalent to {transfer}, and can be used to
360      * e.g. implement automatic token fees, slashing mechanisms, etc.
361      *
362      * Emits a {Transfer} event.
363      *
364      * Requirements:
365      *
366      * - `from` cannot be the zero address.
367      * - `to` cannot be the zero address.
368      * - `from` must have a balance of at least `amount`.
369      */
370     function _transfer(
371         address from,
372         address to,
373         uint256 amount
374     ) internal virtual {
375         require(from != address(0), "ERC20: transfer from the zero address");
376         require(to != address(0), "ERC20: transfer to the zero address");
377 
378         _beforeTokenTransfer(from, to, amount);
379 
380         uint256 fromBalance = _balances[from];
381         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
382         unchecked {
383             _balances[from] = fromBalance - amount;
384         }
385         _balances[to] += amount;
386 
387         emit Transfer(from, to, amount);
388 
389         _afterTokenTransfer(from, to, amount);
390     }
391 
392     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
393      * the total supply.
394      *
395      * Emits a {Transfer} event with `from` set to the zero address.
396      *
397      * Requirements:
398      *
399      * - `account` cannot be the zero address.
400      */
401     function _mint(address account, uint256 amount) internal virtual {
402         require(account != address(0), "ERC20: mint to the zero address");
403 
404         _beforeTokenTransfer(address(0), account, amount);
405 
406         _totalSupply += amount;
407         _balances[account] += amount;
408         emit Transfer(address(0), account, amount);
409 
410         _afterTokenTransfer(address(0), account, amount);
411     }
412 
413     /**
414      * @dev Destroys `amount` tokens from `account`, reducing the
415      * total supply.
416      *
417      * Emits a {Transfer} event with `to` set to the zero address.
418      *
419      * Requirements:
420      *
421      * - `account` cannot be the zero address.
422      * - `account` must have at least `amount` tokens.
423      */
424     function _burn(address account, uint256 amount) internal virtual {
425         require(account != address(0), "ERC20: burn from the zero address");
426 
427         _beforeTokenTransfer(account, address(0), amount);
428 
429         uint256 accountBalance = _balances[account];
430         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
431         unchecked {
432             _balances[account] = accountBalance - amount;
433         }
434         _totalSupply -= amount;
435 
436         emit Transfer(account, address(0), amount);
437 
438         _afterTokenTransfer(account, address(0), amount);
439     }
440 
441     /**
442      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
443      *
444      * This internal function is equivalent to `approve`, and can be used to
445      * e.g. set automatic allowances for certain subsystems, etc.
446      *
447      * Emits an {Approval} event.
448      *
449      * Requirements:
450      *
451      * - `owner` cannot be the zero address.
452      * - `spender` cannot be the zero address.
453      */
454     function _approve(
455         address owner,
456         address spender,
457         uint256 amount
458     ) internal virtual {
459         require(owner != address(0), "ERC20: approve from the zero address");
460         require(spender != address(0), "ERC20: approve to the zero address");
461 
462         _allowances[owner][spender] = amount;
463         emit Approval(owner, spender, amount);
464     }
465 
466     /**
467      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
468      *
469      * Does not update the allowance amount in case of infinite allowance.
470      * Revert if not enough allowance is available.
471      *
472      * Might emit an {Approval} event.
473      */
474     function _spendAllowance(
475         address owner,
476         address spender,
477         uint256 amount
478     ) internal virtual {
479         uint256 currentAllowance = allowance(owner, spender);
480         if (currentAllowance != type(uint256).max) {
481             require(currentAllowance >= amount, "ERC20: insufficient allowance");
482             unchecked {
483                 _approve(owner, spender, currentAllowance - amount);
484             }
485         }
486     }
487 
488     /**
489      * @dev Hook that is called before any transfer of tokens. This includes
490      * minting and burning.
491      *
492      * Calling conditions:
493      *
494      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
495      * will be transferred to `to`.
496      * - when `from` is zero, `amount` tokens will be minted for `to`.
497      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
498      * - `from` and `to` are never both zero.
499      *
500      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
501      */
502     function _beforeTokenTransfer(
503         address from,
504         address to,
505         uint256 amount
506     ) internal virtual {}
507 
508     /**
509      * @dev Hook that is called after any transfer of tokens. This includes
510      * minting and burning.
511      *
512      * Calling conditions:
513      *
514      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
515      * has been transferred to `to`.
516      * - when `from` is zero, `amount` tokens have been minted for `to`.
517      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
518      * - `from` and `to` are never both zero.
519      *
520      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
521      */
522     function _afterTokenTransfer(
523         address from,
524         address to,
525         uint256 amount
526     ) internal virtual {}
527 }
528 
529 // File: @openzeppelin/contracts/access/Ownable.sol
530 
531 
532 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
533 
534 pragma solidity ^0.8.0;
535 
536 
537 /**
538  * @dev Contract module which provides a basic access control mechanism, where
539  * there is an account (an owner) that can be granted exclusive access to
540  * specific functions.
541  *
542  * By default, the owner account will be the one that deploys the contract. This
543  * can later be changed with {transferOwnership}.
544  *
545  * This module is used through inheritance. It will make available the modifier
546  * `onlyOwner`, which can be applied to your functions to restrict their use to
547  * the owner.
548  */
549 abstract contract Ownable is Context {
550     address private _owner;
551 
552     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
553 
554     /**
555      * @dev Initializes the contract setting the deployer as the initial owner.
556      */
557     constructor() {
558         _transferOwnership(_msgSender());
559     }
560 
561     /**
562      * @dev Throws if called by any account other than the owner.
563      */
564     modifier onlyOwner() {
565         _checkOwner();
566         _;
567     }
568 
569     /**
570      * @dev Returns the address of the current owner.
571      */
572     function owner() public view virtual returns (address) {
573         return _owner;
574     }
575 
576     /**
577      * @dev Throws if the sender is not the owner.
578      */
579     function _checkOwner() internal view virtual {
580         require(owner() == _msgSender(), "Ownable: caller is not the owner");
581     }
582 
583     /**
584      * @dev Leaves the contract without owner. It will not be possible to call
585      * `onlyOwner` functions anymore. Can only be called by the current owner.
586      *
587      * NOTE: Renouncing ownership will leave the contract without an owner,
588      * thereby removing any functionality that is only available to the owner.
589      */
590     function renounceOwnership() public virtual onlyOwner {
591         _transferOwnership(address(0));
592     }
593 
594     /**
595      * @dev Transfers ownership of the contract to a new account (`newOwner`).
596      * Can only be called by the current owner.
597      */
598     function transferOwnership(address newOwner) public virtual onlyOwner {
599         require(newOwner != address(0), "Ownable: new owner is the zero address");
600         _transferOwnership(newOwner);
601     }
602 
603     /**
604      * @dev Transfers ownership of the contract to a new account (`newOwner`).
605      * Internal function without access restriction.
606      */
607     function _transferOwnership(address newOwner) internal virtual {
608         address oldOwner = _owner;
609         _owner = newOwner;
610         emit OwnershipTransferred(oldOwner, newOwner);
611     }
612 }
613 
614 interface BURNTOKEN {
615   function burn(uint256 amount) external;
616 }
617 
618 
619 pragma solidity ^0.8.0;
620 
621 interface IRouter {
622     function WETH() external pure returns (address);
623     function factory() external pure returns (address);    
624 
625     function swapExactTokensForETHSupportingFeeOnTransferTokens(
626         uint amountIn,
627         uint amountOutMin,
628         address[] calldata path,
629         address to,
630         uint deadline
631     ) external payable;
632 
633     function swapExactETHForTokensSupportingFeeOnTransferTokens(
634         uint amountOutMin,
635         address[] calldata path,
636         address to,
637         uint deadline
638     ) external payable;
639 }
640 
641 interface IFactory {
642     function createPair(address tokenA, address tokenB) external returns (address pair);
643     function getPair(address tokenA, address tokenB) external view returns (address pair);
644 }
645 
646 contract PREME is Ownable, ERC20('PREME Token', 'PREME') {
647        
648     IRouter public Router;
649     
650     uint256 public devFee;
651     uint256 public burnFee;
652     uint256 public NFTFee;
653     address public burnToken;
654     uint256 public swapAtAmount;
655     address payable public  marketingWallet;
656     address payable public NFTWallet;
657     address public swapPair;
658     mapping (address => bool) public automatedMarketMakerPairs;
659     mapping (address => bool) private _isExcludedFromFees;
660     
661     constructor(address _router, address _MarketingWallet, address _NFTWallet, uint256 initialSupply, address _burnToken)  {
662        devFee = 100;  // 100 = 1%
663        burnFee = 100; // 100 = 1%
664        NFTFee = 100;  // 100 = 1%
665        burnToken = _burnToken;
666        marketingWallet = payable(_MarketingWallet);
667        NFTWallet = payable(_NFTWallet);
668        excludeFromFees(owner(), true);
669        excludeFromFees(address(this), true);
670        _mint(owner(), initialSupply * (10**18));
671        swapAtAmount = totalSupply() * 10 / 1000000;  // .01% 
672        updateSwapRouter(_router);   
673     }
674    
675      event ExcludeFromFees(address indexed account, bool isExcluded);
676      event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
677     
678     function setDevFee(uint256 _newDevFee) public onlyOwner {
679       require(_newDevFee <= 1000, "Cannot exceed 1000");
680       devFee = _newDevFee;
681     }
682     
683     function setBurnFee(uint256 _newBurnFee) public onlyOwner {
684       require(_newBurnFee <= 1000, "Cannot exceed 1000");
685       burnFee = _newBurnFee;
686     }
687 
688     function setNFTFee(uint256 _newNFTFee) public onlyOwner {
689       require(_newNFTFee <= 1000, "Cannot exceed 1000");
690       NFTFee = _newNFTFee;
691     }
692     
693     function setMarketingWallet(address payable newMarketingWallet) public onlyOwner {
694          if (_isExcludedFromFees[marketingWallet] = true) excludeFromFees(marketingWallet, false);
695         marketingWallet = newMarketingWallet;
696          if (_isExcludedFromFees[marketingWallet] = false) excludeFromFees(marketingWallet, true);
697     }
698 
699     function setBurnToken(address _newBurnToken) external onlyOwner {
700         burnToken = _newBurnToken;
701     }
702     
703     function excludeFromFees(address account, bool excluded) public onlyOwner {
704         require(_isExcludedFromFees[account] != excluded, "Account is already the value of 'excluded'");
705         _isExcludedFromFees[account] = excluded;
706 
707         emit ExcludeFromFees(account, excluded);
708     }
709     
710     function _setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
711         require(automatedMarketMakerPairs[pair] != value, "Automated market maker pair is already set to that value");
712         automatedMarketMakerPairs[pair] = value;
713         emit SetAutomatedMarketMakerPair(pair, value);
714     }
715    
716     function updateSwapRouter(address newAddress) public onlyOwner {
717         require(newAddress != address(Router), "The router already has that address");
718         Router = IRouter(newAddress);
719         address bnbPair = IFactory(Router.factory())
720             .getPair(address(this), Router.WETH());
721         if(bnbPair == address(0)) bnbPair = IFactory(Router.factory()).createPair(address(this), Router.WETH());
722         if (automatedMarketMakerPairs[bnbPair] != true && bnbPair != address(0) ){
723             _setAutomatedMarketMakerPair(bnbPair, true);
724         }
725           _approve(address(this), address(Router), ~uint256(0));
726         
727         swapPair = bnbPair;
728     }
729     
730     function isExcludedFromFees(address account) public view returns(bool) {
731         return _isExcludedFromFees[account];
732     }
733 
734     function setSwapAtAmount(uint256 _newSwapAtAmount) external onlyOwner {
735         swapAtAmount = _newSwapAtAmount;
736     }
737 
738     bool private inSwapAndLiquify;
739     modifier lockTheSwap {
740         inSwapAndLiquify = true;
741         _;
742         inSwapAndLiquify = false;
743     }
744     
745     function _transfer(
746         address from,
747         address to,
748         uint256 amount
749     ) internal override {
750            
751         // if any account belongs to _isExcludedFromFee account then remove the fee
752         if(!_isExcludedFromFees[from] && !_isExcludedFromFees[to]) {
753 
754             if(automatedMarketMakerPairs[to] || automatedMarketMakerPairs[from]) {
755                 uint256 extraFee;
756                 if(devFee >0 || burnFee >0 || NFTFee >0) extraFee =(amount * devFee)/10000 + (amount * burnFee)/10000 + (amount * NFTFee)/10000;
757                 
758 
759                 if (balanceOf(address(this)) > swapAtAmount && !inSwapAndLiquify && automatedMarketMakerPairs[to]) SwapFees();
760                 
761                 if (extraFee > 0) {
762                   super._transfer(from, address(this), extraFee);
763                   amount = amount - extraFee;
764                 }
765                 
766             }     
767         }
768       super._transfer(from, to, amount);
769         
770    }
771 
772     function SwapFees() private lockTheSwap {
773        
774           address[] memory path = new address[](2);
775             path[0] = address(this);
776             path[1] = Router.WETH();
777 
778                 Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
779                     balanceOf(address(this)),
780                     0,
781                     path,
782                     address(this),
783                     block.timestamp
784                 );
785 
786             uint256 burnAmount = address(this).balance * burnFee / (burnFee + devFee + NFTFee);
787             
788             address[] memory path1 = new address[](2);
789             path1[0] = Router.WETH();
790             path1[1] = burnToken;
791 
792                 Router.swapExactETHForTokensSupportingFeeOnTransferTokens{value: burnAmount} (
793                     0,
794                     path1,
795                     address(this),
796                     block.timestamp
797                 );
798                         
799             BURNTOKEN(burnToken).burn(ERC20(burnToken).balanceOf(address(this)));
800 
801             uint256 NFTAmount = address(this).balance * NFTFee / ( devFee + NFTFee );
802 
803             payable(NFTWallet).transfer(NFTAmount);
804             payable(marketingWallet).transfer(address(this).balance);
805                     
806     }
807 
808         function manualSwapAndBurn() external onlyOwner {
809             address[] memory path = new address[](2);
810             path[0] = address(this);
811             path[1] = Router.WETH();
812 
813                 Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
814                     balanceOf(address(this)),
815                     0,
816                     path,
817                     address(this),
818                     block.timestamp
819                 );
820 
821             uint256 burnAmount = address(this).balance * burnFee / (burnFee + devFee + NFTFee);
822             
823             address[] memory path1 = new address[](2);
824             path1[0] = Router.WETH();
825             path1[1] = burnToken;
826 
827                 Router.swapExactETHForTokensSupportingFeeOnTransferTokens{value: burnAmount} (
828                     0,
829                     path1,
830                     address(this),
831                     block.timestamp
832                 );
833                         
834             BURNTOKEN(burnToken).burn(ERC20(burnToken).balanceOf(address(this)));
835 
836             uint256 NFTAmount = address(this).balance * NFTFee / ( devFee + NFTFee );
837 
838             payable(NFTWallet).transfer(NFTAmount);
839             payable(marketingWallet).transfer(address(this).balance);
840         }
841 
842         function withdawlBNB() external onlyOwner {
843             payable(msg.sender).transfer(address(this).balance);
844         }
845 
846         function withdrawlToken(address _tokenAddress) external onlyOwner {
847             ERC20(_tokenAddress).transfer(msg.sender, ERC20(_tokenAddress).balanceOf(address(this)));
848         }   
849  
850 
851     // to receive Eth From Router when Swapping
852     receive() external payable {}
853     
854     
855 }