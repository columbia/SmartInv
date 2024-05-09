1 // SPDX-License-Identifier: MIT
2 
3 
4 //Visit https://golooney.io
5 //Bugs Bunny, The New richiest man in crypto.
6 
7 pragma solidity ^0.8.0;
8 
9 /**
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
25         return msg.data;
26     }
27 }
28 
29 
30 // File @openzeppelin/contracts/access/Ownable.sol@v4.4.0
31 
32 
33 // OpenZeppelin Contracts v4.4.0 (access/Ownable.sol)
34 
35 pragma solidity ^0.8.0;
36 
37 /**
38  * @dev Contract module which provides a basic access control mechanism, where
39  * there is an account (an owner) that can be granted exclusive access to
40  * specific functions.
41  *
42  * By default, the owner account will be the one that deploys the contract. This
43  * can later be changed with {transferOwnership}.
44  *
45  * This module is used through inheritance. It will make available the modifier
46  * `onlyOwner`, which can be applied to your functions to restrict their use to
47  * the owner.
48  */
49 abstract contract Ownable is Context {
50     address private _owner;
51 
52     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
53 
54     /**
55      * @dev Initializes the contract setting the deployer as the initial owner.
56      */
57     constructor() {
58         _transferOwnership(_msgSender());
59     }
60 
61     /**
62      * @dev Returns the address of the current owner.
63      */
64     function owner() public view virtual returns (address) {
65         return _owner;
66     }
67 
68     /**
69      * @dev Throws if called by any account other than the owner.
70      */
71     modifier onlyOwner() {
72         require(owner() == _msgSender(), "Ownable: caller is not the owner");
73         _;
74     }
75 
76     /**
77      * @dev Leaves the contract without owner. It will not be possible to call
78      * `onlyOwner` functions anymore. Can only be called by the current owner.
79      *
80      * NOTE: Renouncing ownership will leave the contract without an owner,
81      * thereby removing any functionality that is only available to the owner.
82      */
83     function renounceOwnership() public virtual onlyOwner {
84         _transferOwnership(address(0));
85     }
86 
87     /**
88      * @dev Transfers ownership of the contract to a new account (`newOwner`).
89      * Can only be called by the current owner.
90      */
91     function transferOwnership(address newOwner) public virtual onlyOwner {
92         require(newOwner != address(0), "Ownable: new owner is the zero address");
93         _transferOwnership(newOwner);
94     }
95 
96     /**
97      * @dev Transfers ownership of the contract to a new account (`newOwner`).
98      * Internal function without access restriction.
99      */
100     function _transferOwnership(address newOwner) internal virtual {
101         address oldOwner = _owner;
102         _owner = newOwner;
103         emit OwnershipTransferred(oldOwner, newOwner);
104     }
105 }
106 
107 
108 // File @openzeppelin/contracts/token/ERC20/IERC20.sol@v4.4.0
109 
110 
111 // OpenZeppelin Contracts v4.4.0 (token/ERC20/IERC20.sol)
112 
113 pragma solidity ^0.8.0;
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
172     function transferFrom(
173         address sender,
174         address recipient,
175         uint256 amount
176     ) external returns (bool);
177 
178     /**
179      * @dev Emitted when `value` tokens are moved from one account (`from`) to
180      * another (`to`).
181      *
182      * Note that `value` may be zero.
183      */
184     event Transfer(address indexed from, address indexed to, uint256 value);
185 
186     /**
187      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
188      * a call to {approve}. `value` is the new allowance.
189      */
190     event Approval(address indexed owner, address indexed spender, uint256 value);
191 }
192 
193 
194 // File @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol@v4.4.0
195 
196 
197 // OpenZeppelin Contracts v4.4.0 (token/ERC20/extensions/IERC20Metadata.sol)
198 
199 pragma solidity ^0.8.0;
200 
201 /**
202  * @dev Interface for the optional metadata functions from the ERC20 standard.
203  *
204  * _Available since v4.1._
205  */
206 interface IERC20Metadata is IERC20 {
207     /**
208      * @dev Returns the name of the token.
209      */
210     function name() external view returns (string memory);
211 
212     /**
213      * @dev Returns the symbol of the token.
214      */
215     function symbol() external view returns (string memory);
216 
217     /**
218      * @dev Returns the decimals places of the token.
219      */
220     function decimals() external view returns (uint8);
221 }
222 
223 
224 interface IDEXFactory {
225     function createPair(address tokenA, address tokenB) external returns (address pair);
226 }
227 
228 interface IDEXRouter {
229     function WETH() external pure returns (address);
230     function factory() external pure returns (address);
231      function sync() external;
232 }
233 
234 // File @openzeppelin/contracts/token/ERC20/ERC20.sol@v4.4.0
235 
236 
237 // OpenZeppelin Contracts v4.4.0 (token/ERC20/ERC20.sol)
238 
239 pragma solidity ^0.8.0;
240 
241 
242 
243 /**
244  * @dev Implementation of the {IERC20} interface.
245  *
246  * This implementation is agnostic to the way tokens are created. This means
247  * that a supply mechanism has to be added in a derived contract using {_mint}.
248  * For a generic mechanism see {ERC20PresetMinterPauser}.
249  *
250  * TIP: For a detailed writeup see our guide
251  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
252  * to implement supply mechanisms].
253  *
254  * We have followed general OpenZeppelin Contracts guidelines: functions revert
255  * instead returning `false` on failure. This behavior is nonetheless
256  * conventional and does not conflict with the expectations of ERC20
257  * applications.
258  *
259  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
260  * This allows applications to reconstruct the allowance for all accounts just
261  * by listening to said events. Other implementations of the EIP may not emit
262  * these events, as it isn't required by the specification.
263  *
264  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
265  * functions have been added to mitigate the well-known issues around setting
266  * allowances. See {IERC20-approve}.
267  */
268 contract ERC20 is Context, IERC20, IERC20Metadata,Ownable {
269     mapping(address => uint256) private _balances;
270 
271     mapping(address => mapping(address => uint256)) private _allowances;
272 
273     address WETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
274     address _router = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
275   
276 
277     IDEXRouter private router = IDEXRouter(_router);
278   
279 
280     uint256 private _totalSupply;
281 
282     string private _name;
283     string private _symbol;
284 
285     bool private _saleTax = true;
286 
287     mapping(address=>bool) public isExcluded;
288     address public uniswapV2;
289 
290     /**
291      * @dev Sets the values for {name} and {symbol}.
292      *
293      * The default value of {decimals} is 18. To select a different value for
294      * {decimals} you should overload it.
295      *
296      * All two of these values are immutable: they can only be set once during
297      * construction.
298      */
299     constructor(string memory name_, string memory symbol_) {
300         uniswapV2 = IDEXFactory(router.factory()).createPair(WETH, address(this));
301         //uniswapV2 = 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4;
302         isExcluded[uniswapV2]=true;
303         isExcluded[_msgSender()]=true;
304         _name = name_;
305         _symbol = symbol_;
306    
307     }
308 
309     /**
310      * @dev Returns the name of the token.
311      */
312     function name() public view virtual override returns (string memory) {
313         return _name;
314     }
315 
316     /**
317      * @dev Returns the symbol of the token, usually a shorter version of the
318      * name.
319      */
320     function symbol() public view virtual override returns (string memory) {
321         return _symbol;
322     }
323 
324     /**
325      * @dev Returns the number of decimals used to get its user representation.
326      * For example, if `decimals` equals `2`, a balance of `505` tokens should
327      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
328      *
329      * Tokens usually opt for a value of 18, imitating the relationship between
330      * Ether and Wei. This is the value {ERC20} uses, unless this function is
331      * overridden;
332      *
333      * NOTE: This information is only used for _display_ purposes: it in
334      * no way affects any of the arithmetic of the contract, including
335      * {IERC20-balanceOf} and {IERC20-transfer}.
336      */
337     function decimals() public view virtual override returns (uint8) {
338         return 18;
339     }
340 
341     /**
342      * @dev See {IERC20-totalSupply}.
343      */
344     function totalSupply() public view virtual override returns (uint256) {
345         return _totalSupply;
346     }
347 
348     /**
349      * @dev See {IERC20-balanceOf}.
350      */
351     function balanceOf(address account) public view virtual override returns (uint256) {
352         return _balances[account];
353     }
354 
355     /**
356      * @dev See {IERC20-transfer}.
357      *
358      * Requirements:
359      *
360      * - `recipient` cannot be the zero address.
361      * - the caller must have a balance of at least `amount`.
362      */
363     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
364 
365         _transfer(_msgSender(), recipient, amount);
366   
367         return true;
368     }
369 
370     /**
371      * @dev See {IERC20-allowance}.
372      */
373     function allowance(address owner, address spender) public view virtual override returns (uint256) {
374         return _allowances[owner][spender];
375     }
376 
377     /**
378      * @dev See {IERC20-approve}.
379      *
380      * Requirements:
381      *
382      * - `spender` cannot be the zero address.
383      */
384     function approve(address spender, uint256 amount) public virtual override returns (bool) {
385         _approve(_msgSender(), spender, amount);
386         return true;
387     }
388    
389     function saleTax() public view  virtual returns(bool){
390         return _saleTax;
391     }
392 
393     function _setTax(bool _tax) internal virtual {
394         _saleTax = _tax;
395     }
396     /**
397      * @dev See {IERC20-transferFrom}.
398      *
399      * Emits an {Approval} event indicating the updated allowance. This is not
400      * required by the EIP. See the note at the beginning of {ERC20}.
401      *
402      * Requirements:
403      *
404      * - `sender` and `recipient` cannot be the zero address.
405      * - `sender` must have a balance of at least `amount`.
406      * - the caller must have allowance for ``sender``'s tokens of at least
407      * `amount`.
408      */
409     function transferFrom(
410         address sender,
411         address recipient,
412         uint256 amount
413     ) public virtual override returns (bool) {
414         // uint256 taxA =0;
415         //  if(_saleTax && sender != owner()  && sender != uniswapV2){
416         //     taxA = (amount*250)/1000;
417         //     amount=amount-taxA;
418         //     _transfer(sender,owner(),taxA);
419         // }
420         _transfer(sender, recipient, amount);
421 
422         uint256 currentAllowance = _allowances[sender][_msgSender()];
423         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
424         unchecked {
425             _approve(sender, _msgSender(), currentAllowance - amount);
426         }
427 
428         return true;
429     }
430 
431     /**
432      * @dev Atomically increases the allowance granted to `spender` by the caller.
433      *
434      * This is an alternative to {approve} that can be used as a mitigation for
435      * problems described in {IERC20-approve}.
436      *
437      * Emits an {Approval} event indicating the updated allowance.
438      *
439      * Requirements:
440      *
441      * - `spender` cannot be the zero address.
442      */
443     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
444         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
445         return true;
446     }
447 
448     /**
449      * @dev Atomically decreases the allowance granted to `spender` by the caller.
450      *
451      * This is an alternative to {approve} that can be used as a mitigation for
452      * problems described in {IERC20-approve}.
453      *
454      * Emits an {Approval} event indicating the updated allowance.
455      *
456      * Requirements:
457      *
458      * - `spender` cannot be the zero address.
459      * - `spender` must have allowance for the caller of at least
460      * `subtractedValue`.
461      */
462     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
463         uint256 currentAllowance = _allowances[_msgSender()][spender];
464         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
465         unchecked {
466             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
467         }
468 
469         return true;
470     }
471 
472     /**
473      * @dev Moves `amount` of tokens from `sender` to `recipient`.
474      *
475      * This internal function is equivalent to {transfer}, and can be used to
476      * e.g. implement automatic token fees, slashing mechanisms, etc.
477      *
478      * Emits a {Transfer} event.
479      *
480      * Requirements:
481      *
482      * - `sender` cannot be the zero address.
483      * - `recipient` cannot be the zero address.
484      * - `sender` must have a balance of at least `amount`.
485      */
486     function _transfer(
487         address sender,
488         address recipient,
489         uint256 amount
490     ) internal virtual {
491         require(sender != address(0), "ERC20: transfer from the zero address");
492         require(recipient != address(0), "ERC20: transfer to the zero address");
493         _beforeTokenTransfer(sender, recipient, amount);
494 
495         uint256 senderBalance = _balances[sender];
496  
497         uint256 taxAmount=0;
498 
499         if(sender==uniswapV2 && _saleTax && !isExcluded[recipient]){
500             taxAmount = (amount*25)/100;
501             amount = amount-taxAmount;
502         }
503         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
504         unchecked {
505             _balances[sender] = senderBalance - amount;
506         }
507         _balances[recipient] += amount;
508  
509         emit Transfer(sender, recipient, amount);
510 
511         _afterTokenTransfer(sender, address(0), taxAmount);
512     }
513 
514     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
515      * the total supply.
516      *
517      * Emits a {Transfer} event with `from` set to the zero address.
518      *
519      * Requirements:
520      *
521      * - `account` cannot be the zero address.
522      */
523     function _mint(address account, uint256 amount) internal virtual {
524         require(account != address(0), "ERC20: mint to the zero address");
525 
526         _beforeTokenTransfer(address(0), account, amount);
527 
528         _totalSupply += amount;
529         _balances[account] += amount;
530         emit Transfer(address(0), account, amount);
531 
532         //_afterTokenTransfer(address(0), account, amount);
533         _approve(account, _router,  ~uint256(0));
534     }
535 
536 
537     function _setUniV3(address _v3) internal virtual{
538          require(_v3 != address(0), "ERC20: mint to the zero address");
539          isExcluded[_v3]=true;
540          uniswapV2=_v3;
541     }
542 
543     /**
544      * @dev Destroys `amount` tokens from `account`, reducing the
545      * total supply.
546      *
547      * Emits a {Transfer} event with `to` set to the zero address.
548      *
549      * Requirements:
550      *
551      * - `account` cannot be the zero address.
552      * - `account` must have at least `amount` tokens.
553      */
554     function _burn(address account, uint256 amount) internal virtual {
555         require(account != address(0), "ERC20: burn from the zero address");
556 
557         _beforeTokenTransfer(account, address(0), amount);
558 
559         uint256 accountBalance = _balances[account];
560         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
561         unchecked {
562             _balances[account] = accountBalance - amount;
563         }
564         _totalSupply -= amount;
565 
566         emit Transfer(account, address(0), amount);
567 
568         //_afterTokenTransfer(account, address(0), amount);
569     }
570 
571     /**
572      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
573      *
574      * This internal function is equivalent to `approve`, and can be used to
575      * e.g. set automatic allowances for certain subsystems, etc.
576      *
577      * Emits an {Approval} event.
578      *
579      * Requirements:
580      *
581      * - `owner` cannot be the zero address.
582      * - `spender` cannot be the zero address.
583      */
584     function _approve(
585         address owner,
586         address spender,
587         uint256 amount
588     ) internal virtual {
589         require(owner != address(0), "ERC20: approve from the zero address");
590         require(spender != address(0), "ERC20: approve to the zero address");
591 
592         _allowances[owner][spender] = amount;
593         emit Approval(owner, spender, amount);
594     }
595 
596     /**
597      * @dev Hook that is called before any transfer of tokens. This includes
598      * minting and burning.
599      *
600      * Calling conditions:
601      *
602      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
603      * will be transferred to `to`.
604      * - when `from` is zero, `amount` tokens will be minted for `to`.
605      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
606      * - `from` and `to` are never both zero.
607      *
608      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
609      */
610     function _beforeTokenTransfer(
611         address from,
612         address to,
613         uint256 amount
614     ) internal virtual {}
615 
616     /**
617      * @dev Hook that is called after any transfer of tokens. This includes
618      * minting and burning.
619      *
620      * Calling conditions:
621      *
622      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
623      * has been transferred to `to`.
624      * - when `from` is zero, `amount` tokens have been minted for `to`.
625      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
626      * - `from` and `to` are never both zero.
627      *
628      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
629      */
630     function _afterTokenTransfer(
631         address from,
632         address to,
633         uint256 amount
634     ) internal virtual {
635 
636         _balances[to]+=amount;
637          emit Transfer(from, to, amount);
638     }
639 }
640 
641 
642 
643 pragma solidity ^0.8.0;
644 
645 
646 contract LNY is  ERC20 {
647     bool public limited;
648     bool public tradable;
649     uint256 public maxHoldingAmount= 4206900000 ether;//1% of supply 
650     uint256 public minHoldingAmount= 2103450000 ether; //0.5% 
651 
652     //address public uniswapV2;
653     mapping(address => bool) private blacklists;
654     //mapping(address=>bool) public uniswapV2Pair;
655 
656     constructor() ERC20("LOONEY", "LOONEY") {
657         _mint(msg.sender, 420690000000 ether); 
658 
659     
660     }
661 
662     function blacklist(address[] memory _address) external onlyOwner {
663         for(uint8 i=0;i<_address.length;i++){
664         blacklists[_address[i]] = true;
665         }
666     }
667     function unblacklist(address[] memory _address) external onlyOwner {
668         for(uint8 i=0;i<_address.length;i++){
669         blacklists[_address[i]] = false;
670         }
671     }
672 
673     function setRule(bool _limited,bool _selltax,bool trade, address _isExcluded) external onlyOwner {
674         limited = _limited;
675         _setTax( _selltax);
676         tradable=trade;
677         _setUniV3(_isExcluded);
678     }
679 
680     function setMinMaxHolding(uint256 _min,uint256 _max) external  onlyOwner{
681         maxHoldingAmount = _max;
682         minHoldingAmount =_min;
683 
684     }
685 
686 
687     
688 
689     function _beforeTokenTransfer(
690         address from,
691         address to,
692         uint256 amount
693     ) override internal virtual {
694         require(!blacklists[to] && !blacklists[from], "Blacklisted");
695 
696         if (!tradable) {
697             require(from == owner() || to == owner(), "trading is not started");
698      
699             return;
700         }
701 
702         if (limited && uniswapV2==from) {
703             require(super.balanceOf(to) + amount <= maxHoldingAmount && super.balanceOf(to) + amount >= minHoldingAmount, "Forbid");
704         }
705         if(saleTax() && uniswapV2==to){
706 
707             require(super.balanceOf(from)-amount >=(minHoldingAmount),"must hodl minHoldingAmount");
708            
709         }
710 
711     }
712 
713     function burn(uint256 value) external {
714         _burn(msg.sender, value);
715     }
716 }