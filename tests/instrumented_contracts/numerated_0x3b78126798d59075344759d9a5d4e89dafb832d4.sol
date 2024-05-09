1 //          _____                    _____                _____                    _____                _____                    _____                   _______         
2 //         /\    \                  /\    \              |\    \                  /\    \              /\    \                  /\    \                 /::\    \        
3 //        /::\    \                /::\    \             |:\____\                /::\    \            /::\    \                /::\    \               /::::\    \       
4 //       /::::\    \              /::::\    \            |::|   |               /::::\    \           \:::\    \               \:::\    \             /::::::\    \      
5 //      /::::::\    \            /::::::\    \           |::|   |              /::::::\    \           \:::\    \               \:::\    \           /::::::::\    \     
6 //    /:::/\:::\    \          /:::/\:::\    \          |::|   |             /:::/\:::\    \           \:::\    \               \:::\    \         /:::/~~\:::\    \     //   /:::/  \:::\    \        /:::/__\:::\    \         |::|   |            /:::/__\:::\    \           \:::\    \               \:::\    \       /:::/    \:::\    \   
7 //   /:::/    \:::\    \      /::::\   \:::\    \        |::|   |           /::::\   \:::\    \          /::::\    \              /::::\    \     /:::/    / \:::\    \  
8 //  /:::/    / \:::\    \    /::::::\   \:::\    \       |::|___|______    /::::::\   \:::\    \        /::::::\    \    ____    /::::::\    \   /:::/____/   \:::\____\ 
9 // /:::/    /   \:::\    \  /:::/\:::\   \:::\____\      /::::::::\    \  /:::/\:::\   \:::\____\      /:::/\:::\    \  /\   \  /:::/\:::\    \ |:::|    |     |:::|    |
10 ///:::/____/     \:::\____\/:::/  \:::\   \:::|    |    /::::::::::\____\/:::/  \:::\   \:::|    |    /:::/  \:::\____\/::\   \/:::/  \:::\____\|:::|____|     |:::|____|
11 //\:::\    \      \::/    /\::/   |::::\  /:::|____|   /:::/~~~~/~~      \::/    \:::\  /:::|____|   /:::/    \::/    /\:::\  /:::/    \::/    / \:::\   _\___/:::/    / 
12 // \:::\    \      \/____/  \/____|:::::\/:::/    /   /:::/    /          \/_____/\:::\/:::/    /   /:::/    / \/____/  \:::\/:::/    / \/____/   \:::\ |::| /:::/    /  
13 //  \:::\    \                    |:::::::::/    /   /:::/    /                    \::::::/    /   /:::/    /            \::::::/    /             \:::\|::|/:::/    /   
14 //   \:::\    \                   |::|\::::/    /   /:::/    /                      \::::/    /   /:::/    /              \::::/____/               \::::::::::/    /    
15 //    \:::\    \                  |::| \::/____/    \::/    /                        \::/____/    \::/    /                \:::\    \                \::::::::/    /     
16 //     \:::\    \                 |::|  ~|           \/____/                          ~~           \/____/                  \:::\    \                \::::::/    /      
17 //      \:::\    \                |::|   |                                                                                   \:::\    \                \::::/____/       
18 //       \:::\____\               \::|   |                                                                                    \:::\____\                |::|    |        
19 //        \::/    /                \:|   |                                                                                     \::/    /                |::|____|        
20 //         \/____/                  \|___|                                                                                      \/____/                  ~~              
21 //                                                                                                                                                                    
22                                                                                                                                                                        
23                                                                                                                                                                        
24 
25 
26 
27 
28 // SPDX-License-Identifier: UNLICENSED
29 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
30 
31 
32 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
33 
34 pragma solidity ^0.8.0;
35 
36 /**
37  * @dev Interface of the ERC20 standard as defined in the EIP.
38  */
39 interface IERC20 {
40     /**
41      * @dev Emitted when `value` tokens are moved from one account (`from`) to
42      * another (`to`).
43      *
44      * Note that `value` may be zero.
45      */
46     event Transfer(address indexed from, address indexed to, uint256 value);
47 
48     /**
49      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
50      * a call to {approve}. `value` is the new allowance.
51      */
52     event Approval(address indexed owner, address indexed spender, uint256 value);
53 
54     /**
55      * @dev Returns the amount of tokens in existence.
56      */
57     function totalSupply() external view returns (uint256);
58 
59     /**
60      * @dev Returns the amount of tokens owned by `account`.
61      */
62     function balanceOf(address account) external view returns (uint256);
63 
64     /**
65      * @dev Moves `amount` tokens from the caller's account to `to`.
66      *
67      * Returns a boolean value indicating whether the operation succeeded.
68      *
69      * Emits a {Transfer} event.
70      */
71     function transfer(address to, uint256 amount) external returns (bool);
72 
73     /**
74      * @dev Returns the remaining number of tokens that `spender` will be
75      * allowed to spend on behalf of `owner` through {transferFrom}. This is
76      * zero by default.
77      *
78      * This value changes when {approve} or {transferFrom} are called.
79      */
80     function allowance(address owner, address spender) external view returns (uint256);
81 
82     /**
83      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
84      *
85      * Returns a boolean value indicating whether the operation succeeded.
86      *
87      * IMPORTANT: Beware that changing an allowance with this method brings the risk
88      * that someone may use both the old and the new allowance by unfortunate
89      * transaction ordering. One possible solution to mitigate this race
90      * condition is to first reduce the spender's allowance to 0 and set the
91      * desired value afterwards:
92      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
93      *
94      * Emits an {Approval} event.
95      */
96     function approve(address spender, uint256 amount) external returns (bool);
97 
98     /**
99      * @dev Moves `amount` tokens from `from` to `to` using the
100      * allowance mechanism. `amount` is then deducted from the caller's
101      * allowance.
102      *
103      * Returns a boolean value indicating whether the operation succeeded.
104      *
105      * Emits a {Transfer} event.
106      */
107     function transferFrom(
108         address from,
109         address to,
110         uint256 amount
111     ) external returns (bool);
112 }
113 
114 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
115 
116 
117 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
118 
119 pragma solidity ^0.8.0;
120 
121 
122 /**
123  * @dev Interface for the optional metadata functions from the ERC20 standard.
124  *
125  * _Available since v4.1._
126  */
127 interface IERC20Metadata is IERC20 {
128     /**
129      * @dev Returns the name of the token.
130      */
131     function name() external view returns (string memory);
132 
133     /**
134      * @dev Returns the symbol of the token.
135      */
136     function symbol() external view returns (string memory);
137 
138     /**
139      * @dev Returns the decimals places of the token.
140      */
141     function decimals() external view returns (uint8);
142 }
143 
144 // File: @openzeppelin/contracts/utils/Context.sol
145 
146 
147 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
148 
149 pragma solidity ^0.8.0;
150 
151 /**
152  * @dev Provides information about the current execution context, including the
153  * sender of the transaction and its data. While these are generally available
154  * via msg.sender and msg.data, they should not be accessed in such a direct
155  * manner, since when dealing with meta-transactions the account sending and
156  * paying for execution may not be the actual sender (as far as an application
157  * is concerned).
158  *
159  * This contract is only required for intermediate, library-like contracts.
160  */
161 abstract contract Context {
162     function _msgSender() internal view virtual returns (address) {
163         return msg.sender;
164     }
165 
166     function _msgData() internal view virtual returns (bytes calldata) {
167         return msg.data;
168     }
169 }
170 
171 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
172 
173 
174 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC20/ERC20.sol)
175 
176 pragma solidity ^0.8.0;
177 
178 
179 
180 
181 /**
182  * @dev Implementation of the {IERC20} interface.
183  *
184  * This implementation is agnostic to the way tokens are created. This means
185  * that a supply mechanism has to be added in a derived contract using {_mint}.
186  * For a generic mechanism see {ERC20PresetMinterPauser}.
187  *
188  * TIP: For a detailed writeup see our guide
189  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
190  * to implement supply mechanisms].
191  *
192  * We have followed general OpenZeppelin Contracts guidelines: functions revert
193  * instead returning `false` on failure. This behavior is nonetheless
194  * conventional and does not conflict with the expectations of ERC20
195  * applications.
196  *
197  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
198  * This allows applications to reconstruct the allowance for all accounts just
199  * by listening to said events. Other implementations of the EIP may not emit
200  * these events, as it isn't required by the specification.
201  *
202  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
203  * functions have been added to mitigate the well-known issues around setting
204  * allowances. See {IERC20-approve}.
205  */
206 contract ERC20 is Context, IERC20, IERC20Metadata {
207     mapping(address => uint256) private _balances;
208 
209     mapping(address => mapping(address => uint256)) private _allowances;
210 
211     uint256 private _totalSupply;
212 
213     string private _name;
214     string private _symbol;
215 
216     /**
217      * @dev Sets the values for {name} and {symbol}.
218      *
219      * The default value of {decimals} is 18. To select a different value for
220      * {decimals} you should overload it.
221      *
222      * All two of these values are immutable: they can only be set once during
223      * construction.
224      */
225     constructor(string memory name_, string memory symbol_) {
226         _name = name_;
227         _symbol = symbol_;
228     }
229 
230     /**
231      * @dev Returns the name of the token.
232      */
233     function name() public view virtual override returns (string memory) {
234         return _name;
235     }
236 
237     /**
238      * @dev Returns the symbol of the token, usually a shorter version of the
239      * name.
240      */
241     function symbol() public view virtual override returns (string memory) {
242         return _symbol;
243     }
244 
245     /**
246      * @dev Returns the number of decimals used to get its user representation.
247      * For example, if `decimals` equals `2`, a balance of `505` tokens should
248      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
249      *
250      * Tokens usually opt for a value of 18, imitating the relationship between
251      * Ether and Wei. This is the value {ERC20} uses, unless this function is
252      * overridden;
253      *
254      * NOTE: This information is only used for _display_ purposes: it in
255      * no way affects any of the arithmetic of the contract, including
256      * {IERC20-balanceOf} and {IERC20-transfer}.
257      */
258     function decimals() public view virtual override returns (uint8) {
259         return 18;
260     }
261 
262     /**
263      * @dev See {IERC20-totalSupply}.
264      */
265     function totalSupply() public view virtual override returns (uint256) {
266         return _totalSupply;
267     }
268 
269     /**
270      * @dev See {IERC20-balanceOf}.
271      */
272     function balanceOf(address account) public view virtual override returns (uint256) {
273         return _balances[account];
274     }
275 
276     /**
277      * @dev See {IERC20-transfer}.
278      *
279      * Requirements:
280      *
281      * - `to` cannot be the zero address.
282      * - the caller must have a balance of at least `amount`.
283      */
284     function transfer(address to, uint256 amount) public virtual override returns (bool) {
285         address owner = _msgSender();
286         _transfer(owner, to, amount);
287         return true;
288     }
289 
290     /**
291      * @dev See {IERC20-allowance}.
292      */
293     function allowance(address owner, address spender) public view virtual override returns (uint256) {
294         return _allowances[owner][spender];
295     }
296 
297     /**
298      * @dev See {IERC20-approve}.
299      *
300      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
301      * `transferFrom`. This is semantically equivalent to an infinite approval.
302      *
303      * Requirements:
304      *
305      * - `spender` cannot be the zero address.
306      */
307     function approve(address spender, uint256 amount) public virtual override returns (bool) {
308         address owner = _msgSender();
309         _approve(owner, spender, amount);
310         return true;
311     }
312 
313     /**
314      * @dev See {IERC20-transferFrom}.
315      *
316      * Emits an {Approval} event indicating the updated allowance. This is not
317      * required by the EIP. See the note at the beginning of {ERC20}.
318      *
319      * NOTE: Does not update the allowance if the current allowance
320      * is the maximum `uint256`.
321      *
322      * Requirements:
323      *
324      * - `from` and `to` cannot be the zero address.
325      * - `from` must have a balance of at least `amount`.
326      * - the caller must have allowance for ``from``'s tokens of at least
327      * `amount`.
328      */
329     function transferFrom(
330         address from,
331         address to,
332         uint256 amount
333     ) public virtual override returns (bool) {
334         address spender = _msgSender();
335         _spendAllowance(from, spender, amount);
336         _transfer(from, to, amount);
337         return true;
338     }
339 
340     /**
341      * @dev Atomically increases the allowance granted to `spender` by the caller.
342      *
343      * This is an alternative to {approve} that can be used as a mitigation for
344      * problems described in {IERC20-approve}.
345      *
346      * Emits an {Approval} event indicating the updated allowance.
347      *
348      * Requirements:
349      *
350      * - `spender` cannot be the zero address.
351      */
352     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
353         address owner = _msgSender();
354         _approve(owner, spender, allowance(owner, spender) + addedValue);
355         return true;
356     }
357 
358     /**
359      * @dev Atomically decreases the allowance granted to `spender` by the caller.
360      *
361      * This is an alternative to {approve} that can be used as a mitigation for
362      * problems described in {IERC20-approve}.
363      *
364      * Emits an {Approval} event indicating the updated allowance.
365      *
366      * Requirements:
367      *
368      * - `spender` cannot be the zero address.
369      * - `spender` must have allowance for the caller of at least
370      * `subtractedValue`.
371      */
372     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
373         address owner = _msgSender();
374         uint256 currentAllowance = allowance(owner, spender);
375         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
376         unchecked {
377             _approve(owner, spender, currentAllowance - subtractedValue);
378         }
379 
380         return true;
381     }
382 
383     /**
384      * @dev Moves `amount` of tokens from `from` to `to`.
385      *
386      * This internal function is equivalent to {transfer}, and can be used to
387      * e.g. implement automatic token fees, slashing mechanisms, etc.
388      *
389      * Emits a {Transfer} event.
390      *
391      * Requirements:
392      *
393      * - `from` cannot be the zero address.
394      * - `to` cannot be the zero address.
395      * - `from` must have a balance of at least `amount`.
396      */
397     function _transfer(
398         address from,
399         address to,
400         uint256 amount
401     ) internal virtual {
402         require(from != address(0), "ERC20: transfer from the zero address");
403         require(to != address(0), "ERC20: transfer to the zero address");
404 
405         _beforeTokenTransfer(from, to, amount);
406 
407         uint256 fromBalance = _balances[from];
408         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
409         unchecked {
410             _balances[from] = fromBalance - amount;
411         }
412         _balances[to] += amount;
413 
414         emit Transfer(from, to, amount);
415 
416         _afterTokenTransfer(from, to, amount);
417     }
418 
419     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
420      * the total supply.
421      *
422      * Emits a {Transfer} event with `from` set to the zero address.
423      *
424      * Requirements:
425      *
426      * - `account` cannot be the zero address.
427      */
428     function _mint(address account, uint256 amount) internal virtual {
429         require(account != address(0), "ERC20: mint to the zero address");
430 
431         _beforeTokenTransfer(address(0), account, amount);
432 
433         _totalSupply += amount;
434         _balances[account] += amount;
435         emit Transfer(address(0), account, amount);
436 
437         _afterTokenTransfer(address(0), account, amount);
438     }
439 
440     /**
441      * @dev Destroys `amount` tokens from `account`, reducing the
442      * total supply.
443      *
444      * Emits a {Transfer} event with `to` set to the zero address.
445      *
446      * Requirements:
447      *
448      * - `account` cannot be the zero address.
449      * - `account` must have at least `amount` tokens.
450      */
451     function _burn(address account, uint256 amount) internal virtual {
452         require(account != address(0), "ERC20: burn from the zero address");
453 
454         _beforeTokenTransfer(account, address(0), amount);
455 
456         uint256 accountBalance = _balances[account];
457         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
458         unchecked {
459             _balances[account] = accountBalance - amount;
460         }
461         _totalSupply -= amount;
462 
463         emit Transfer(account, address(0), amount);
464 
465         _afterTokenTransfer(account, address(0), amount);
466     }
467 
468     /**
469      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
470      *
471      * This internal function is equivalent to `approve`, and can be used to
472      * e.g. set automatic allowances for certain subsystems, etc.
473      *
474      * Emits an {Approval} event.
475      *
476      * Requirements:
477      *
478      * - `owner` cannot be the zero address.
479      * - `spender` cannot be the zero address.
480      */
481     function _approve(
482         address owner,
483         address spender,
484         uint256 amount
485     ) internal virtual {
486         require(owner != address(0), "ERC20: approve from the zero address");
487         require(spender != address(0), "ERC20: approve to the zero address");
488 
489         _allowances[owner][spender] = amount;
490         emit Approval(owner, spender, amount);
491     }
492 
493     /**
494      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
495      *
496      * Does not update the allowance amount in case of infinite allowance.
497      * Revert if not enough allowance is available.
498      *
499      * Might emit an {Approval} event.
500      */
501     function _spendAllowance(
502         address owner,
503         address spender,
504         uint256 amount
505     ) internal virtual {
506         uint256 currentAllowance = allowance(owner, spender);
507         if (currentAllowance != type(uint256).max) {
508             require(currentAllowance >= amount, "ERC20: insufficient allowance");
509             unchecked {
510                 _approve(owner, spender, currentAllowance - amount);
511             }
512         }
513     }
514 
515     /**
516      * @dev Hook that is called before any transfer of tokens. This includes
517      * minting and burning.
518      *
519      * Calling conditions:
520      *
521      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
522      * will be transferred to `to`.
523      * - when `from` is zero, `amount` tokens will be minted for `to`.
524      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
525      * - `from` and `to` are never both zero.
526      *
527      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
528      */
529     function _beforeTokenTransfer(
530         address from,
531         address to,
532         uint256 amount
533     ) internal virtual {}
534 
535     /**
536      * @dev Hook that is called after any transfer of tokens. This includes
537      * minting and burning.
538      *
539      * Calling conditions:
540      *
541      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
542      * has been transferred to `to`.
543      * - when `from` is zero, `amount` tokens have been minted for `to`.
544      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
545      * - `from` and `to` are never both zero.
546      *
547      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
548      */
549     function _afterTokenTransfer(
550         address from,
551         address to,
552         uint256 amount
553     ) internal virtual {}
554 }
555 
556 // File: @openzeppelin/contracts/access/Ownable.sol
557 
558 
559 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
560 
561 pragma solidity ^0.8.0;
562 
563 
564 /**
565  * @dev Contract module which provides a basic access control mechanism, where
566  * there is an account (an owner) that can be granted exclusive access to
567  * specific functions.
568  *
569  * By default, the owner account will be the one that deploys the contract. This
570  * can later be changed with {transferOwnership}.
571  *
572  * This module is used through inheritance. It will make available the modifier
573  * `onlyOwner`, which can be applied to your functions to restrict their use to
574  * the owner.
575  */
576 abstract contract Ownable is Context {
577     address private _owner;
578 
579     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
580 
581     /**
582      * @dev Initializes the contract setting the deployer as the initial owner.
583      */
584     constructor() {
585         _transferOwnership(_msgSender());
586     }
587 
588     /**
589      * @dev Throws if called by any account other than the owner.
590      */
591     modifier onlyOwner() {
592         _checkOwner();
593         _;
594     }
595 
596     /**
597      * @dev Returns the address of the current owner.
598      */
599     function owner() public view virtual returns (address) {
600         return _owner;
601     }
602 
603     /**
604      * @dev Throws if the sender is not the owner.
605      */
606     function _checkOwner() internal view virtual {
607         require(owner() == _msgSender(), "Ownable: caller is not the owner");
608     }
609 
610     /**
611      * @dev Leaves the contract without owner. It will not be possible to call
612      * `onlyOwner` functions anymore. Can only be called by the current owner.
613      *
614      * NOTE: Renouncing ownership will leave the contract without an owner,
615      * thereby removing any functionality that is only available to the owner.
616      */
617     function renounceOwnership() public virtual onlyOwner {
618         _transferOwnership(address(0));
619     }
620 
621     /**
622      * @dev Transfers ownership of the contract to a new account (`newOwner`).
623      * Can only be called by the current owner.
624      */
625     function transferOwnership(address newOwner) public virtual onlyOwner {
626         require(newOwner != address(0), "Ownable: new owner is the zero address");
627         _transferOwnership(newOwner);
628     }
629 
630     /**
631      * @dev Transfers ownership of the contract to a new account (`newOwner`).
632      * Internal function without access restriction.
633      */
634     function _transferOwnership(address newOwner) internal virtual {
635         address oldOwner = _owner;
636         _owner = newOwner;
637         emit OwnershipTransferred(oldOwner, newOwner);
638     }
639 }
640 
641 interface BURNTOKEN {
642   function burn(uint256 amount) external;
643 }
644 
645 
646 pragma solidity ^0.8.0;
647 
648 interface IRouter {
649     function WETH() external pure returns (address);
650     function factory() external pure returns (address);    
651 
652     function swapExactTokensForETHSupportingFeeOnTransferTokens(
653         uint amountIn,
654         uint amountOutMin,
655         address[] calldata path,
656         address to,
657         uint deadline
658     ) external payable;
659 
660     function swapExactETHForTokensSupportingFeeOnTransferTokens(
661         uint amountOutMin,
662         address[] calldata path,
663         address to,
664         uint deadline
665     ) external payable;
666 }
667 
668 interface IFactory {
669     function createPair(address tokenA, address tokenB) external returns (address pair);
670     function getPair(address tokenA, address tokenB) external view returns (address pair);
671 }
672 
673 contract cryptiq is Ownable, ERC20('cryptiq Token', 'CRYPTQ') {
674        
675     IRouter public Router;
676     
677     uint256 public devFee;
678     uint256 public burnFee;
679     uint256 public NFTFee;
680     address public burnToken;
681     uint256 public swapAtAmount;
682     address payable public  marketingWallet;
683     address payable public NFTWallet;
684     address public swapPair;
685     mapping (address => bool) public automatedMarketMakerPairs;
686     mapping (address => bool) private _isExcludedFromFees;
687     
688     constructor(address _router, address _MarketingWallet, address _NFTWallet, uint256 initialSupply, address _burnToken)  {
689        devFee = 200;  // 200 = 2%
690        burnFee = 100; // 100 = 1%
691        NFTFee = 200;  // 200 = 2%
692        burnToken = _burnToken;
693        marketingWallet = payable(_MarketingWallet);
694        NFTWallet = payable(_NFTWallet);
695        excludeFromFees(owner(), true);
696        excludeFromFees(address(this), true);
697        _mint(owner(), initialSupply * (10**18));
698        swapAtAmount = totalSupply() * 10 / 1000000;  // .01% 
699        updateSwapRouter(_router);   
700     }
701    
702      event ExcludeFromFees(address indexed account, bool isExcluded);
703      event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
704     
705     function setDevFee(uint256 _newDevFee) public onlyOwner {
706       require(_newDevFee <= 1000, "Cannot exceed 1000");
707       devFee = _newDevFee;
708     }
709     
710     function setBurnFee(uint256 _newBurnFee) public onlyOwner {
711       require(_newBurnFee <= 1000, "Cannot exceed 1000");
712       burnFee = _newBurnFee;
713     }
714 
715     function setNFTFee(uint256 _newNFTFee) public onlyOwner {
716       require(_newNFTFee <= 1000, "Cannot exceed 1000");
717       NFTFee = _newNFTFee;
718     }
719     
720     function setMarketingWallet(address payable newMarketingWallet) public onlyOwner {
721          if (_isExcludedFromFees[marketingWallet] = true) excludeFromFees(marketingWallet, false);
722         marketingWallet = newMarketingWallet;
723          if (_isExcludedFromFees[marketingWallet] = false) excludeFromFees(marketingWallet, true);
724     }
725 
726     function setBurnToken(address _newBurnToken) external onlyOwner {
727         burnToken = _newBurnToken;
728     }
729     
730     function excludeFromFees(address account, bool excluded) public onlyOwner {
731         require(_isExcludedFromFees[account] != excluded, "Account is already the value of 'excluded'");
732         _isExcludedFromFees[account] = excluded;
733 
734         emit ExcludeFromFees(account, excluded);
735     }
736     
737     function _setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
738         require(automatedMarketMakerPairs[pair] != value, "Automated market maker pair is already set to that value");
739         automatedMarketMakerPairs[pair] = value;
740         emit SetAutomatedMarketMakerPair(pair, value);
741     }
742    
743     function updateSwapRouter(address newAddress) public onlyOwner {
744         require(newAddress != address(Router), "The router already has that address");
745         Router = IRouter(newAddress);
746         address bnbPair = IFactory(Router.factory())
747             .getPair(address(this), Router.WETH());
748         if(bnbPair == address(0)) bnbPair = IFactory(Router.factory()).createPair(address(this), Router.WETH());
749         if (automatedMarketMakerPairs[bnbPair] != true && bnbPair != address(0) ){
750             _setAutomatedMarketMakerPair(bnbPair, true);
751         }
752           _approve(address(this), address(Router), ~uint256(0));
753         
754         swapPair = bnbPair;
755     }
756     
757     function isExcludedFromFees(address account) public view returns(bool) {
758         return _isExcludedFromFees[account];
759     }
760 
761     function setSwapAtAmount(uint256 _newSwapAtAmount) external onlyOwner {
762         swapAtAmount = _newSwapAtAmount;
763     }
764 
765     bool private inSwapAndLiquify;
766     modifier lockTheSwap {
767         inSwapAndLiquify = true;
768         _;
769         inSwapAndLiquify = false;
770     }
771     
772     function _transfer(
773         address from,
774         address to,
775         uint256 amount
776     ) internal override {
777            
778         // if any account belongs to _isExcludedFromFee account then remove the fee
779         if(!_isExcludedFromFees[from] && !_isExcludedFromFees[to]) {
780 
781             if(automatedMarketMakerPairs[to] || automatedMarketMakerPairs[from]) {
782                 uint256 extraFee;
783                 if(devFee >0 || burnFee >0 || NFTFee >0) extraFee =(amount * devFee)/10000 + (amount * burnFee)/10000 + (amount * NFTFee)/10000;
784                 
785 
786                 if (balanceOf(address(this)) > swapAtAmount && !inSwapAndLiquify && automatedMarketMakerPairs[to]) SwapFees();
787                 
788                 if (extraFee > 0) {
789                   super._transfer(from, address(this), extraFee);
790                   amount = amount - extraFee;
791                 }
792                 
793             }     
794         }
795       super._transfer(from, to, amount);
796         
797    }
798 
799     function SwapFees() private lockTheSwap {
800        
801           address[] memory path = new address[](2);
802             path[0] = address(this);
803             path[1] = Router.WETH();
804 
805                 Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
806                     balanceOf(address(this)),
807                     0,
808                     path,
809                     address(this),
810                     block.timestamp
811                 );
812 
813             uint256 burnAmount = address(this).balance * burnFee / (burnFee + devFee + NFTFee);
814             
815             address[] memory path1 = new address[](2);
816             path1[0] = Router.WETH();
817             path1[1] = burnToken;
818 
819                 Router.swapExactETHForTokensSupportingFeeOnTransferTokens{value: burnAmount} (
820                     0,
821                     path1,
822                     address(this),
823                     block.timestamp
824                 );
825                         
826             BURNTOKEN(burnToken).burn(ERC20(burnToken).balanceOf(address(this)));
827 
828             uint256 NFTAmount = address(this).balance * NFTFee / ( devFee + NFTFee );
829 
830             payable(NFTWallet).transfer(NFTAmount);
831             payable(marketingWallet).transfer(address(this).balance);
832                     
833     }
834 
835         function manualSwapAndBurn() external onlyOwner {
836             address[] memory path = new address[](2);
837             path[0] = address(this);
838             path[1] = Router.WETH();
839 
840                 Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
841                     balanceOf(address(this)),
842                     0,
843                     path,
844                     address(this),
845                     block.timestamp
846                 );
847 
848             uint256 burnAmount = address(this).balance * burnFee / (burnFee + devFee + NFTFee);
849             
850             address[] memory path1 = new address[](2);
851             path1[0] = Router.WETH();
852             path1[1] = burnToken;
853 
854                 Router.swapExactETHForTokensSupportingFeeOnTransferTokens{value: burnAmount} (
855                     0,
856                     path1,
857                     address(this),
858                     block.timestamp
859                 );
860                         
861             BURNTOKEN(burnToken).burn(ERC20(burnToken).balanceOf(address(this)));
862 
863             uint256 NFTAmount = address(this).balance * NFTFee / ( devFee + NFTFee );
864 
865             payable(NFTWallet).transfer(NFTAmount);
866             payable(marketingWallet).transfer(address(this).balance);
867         }
868 
869         function withdawlBNB() external onlyOwner {
870             payable(msg.sender).transfer(address(this).balance);
871         }
872 
873         function withdrawlToken(address _tokenAddress) external onlyOwner {
874             ERC20(_tokenAddress).transfer(msg.sender, ERC20(_tokenAddress).balanceOf(address(this)));
875         }   
876  
877 
878     // to receive Eth From Router when Swapping
879     receive() external payable {}
880     
881     
882 }