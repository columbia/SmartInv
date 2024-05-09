1 /**
2                                    _ 
3                                   (_)
4   _ __   ___ _ __   ___  _ __  _____ 
5  | '_ \ / _ \ '_ \ / _ \| '_ \|_  / |
6  | |_) |  __/ |_) | (_) | | | |/ /| |
7  | .__/ \___| .__/ \___/|_| |_/___|_|
8  | |        | |                      
9  |_|        |_|                      
10  
11 Peponzi is a new age Ponzi token with game mechanics that offers a fun and exciting way to earn passive income. 
12 Built on the Ethereum blockchain, Peponzi allows users to buy specific Pepes and generate PEPONZI tokens through them. 
13 Peponzi automatically burns 2.5% of tokens from volume, which ensures that the token remains viable in the long run.
14 With five Pepes to choose from, Peponzi offers a unique opportunity to earn rewards while enjoying the universal appeal of Pepe the Frog.
15 Interested? Let's start with Protocol description.
16 
17 The Peponzi protocol is at the heart of our unique crypto ecosystem. Inspired by the success of node tokens, Peponzi has developed a new model that uses Pepes instead of traditional nodes. 
18 This innovative approach allows users to generate passive income through our token while also maintaining the sustainability of the system through automatic token burning from generated volume.
19 There are similarities between the Peponzi protocol and other popular projects such as Universe and BRR. 
20 However, we believe that the Peponzi protocol is superior in several ways. 
21 Our goal is to provide holders with Pepes that print tokens, which ensures a steady flow of income for our users. 
22 At the same time, we are committed to maintaining the long-term viability of our platform through a deflationary approach that burns tokens automatically.
23 We are also not using NFTs as nodes due to Ethereum gas fees.
24 Pepes owners can claim PEPONZI rewards at any time, rewards are not locked.
25 
26 Website: https://peponzi.com
27 Telegram: https://t.me/peponzicom
28 Twitter: https://twitter.com/peponzi_com
29 Discord: https://discord.gg/hs9nYYcEGZ
30 Medium: https://medium.com/@peponzi/peponzi-new-age-ponzi-token-f9f4545509ab
31 Docs: https://peponzi.gitbook.io/introduction/
32 
33 */
34 
35 // SPDX-License-Identifier: MIT
36 
37 pragma solidity 0.8.17;
38 
39 /**
40  * @dev Provides information about the current execution context, including the
41  * sender of the transaction and its data. While these are generally available
42  * via msg.sender and msg.data, they should not be accessed in such a direct
43  * manner, since when dealing with meta-transactions the account sending and
44  * paying for execution may not be the actual sender (as far as an application
45  * is concerned).
46  *
47  * This contract is only required for intermediate, library-like contracts.
48  */
49 abstract contract Context {
50     function _msgSender() internal view virtual returns (address) {
51         return msg.sender;
52     }
53 
54     function _msgData() internal view virtual returns (bytes calldata) {
55         return msg.data;
56     }
57 }
58 
59 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
60 
61 
62 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
63 
64 /**
65  * @dev Interface of the ERC20 standard as defined in the EIP.
66  */
67 interface IERC20 {
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
81 
82     /**
83      * @dev Returns the amount of tokens in existence.
84      */
85     function totalSupply() external view returns (uint256);
86 
87     /**
88      * @dev Returns the amount of tokens owned by `account`.
89      */
90     function balanceOf(address account) external view returns (uint256);
91 
92     /**
93      * @dev Moves `amount` tokens from the caller's account to `to`.
94      *
95      * Returns a boolean value indicating whether the operation succeeded.
96      *
97      * Emits a {Transfer} event.
98      */
99     function transfer(address to, uint256 amount) external returns (bool);
100 
101     /**
102      * @dev Returns the remaining number of tokens that `spender` will be
103      * allowed to spend on behalf of `owner` through {transferFrom}. This is
104      * zero by default.
105      *
106      * This value changes when {approve} or {transferFrom} are called.
107      */
108     function allowance(address owner, address spender) external view returns (uint256);
109 
110     /**
111      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
112      *
113      * Returns a boolean value indicating whether the operation succeeded.
114      *
115      * IMPORTANT: Beware that changing an allowance with this method brings the risk
116      * that someone may use both the old and the new allowance by unfortunate
117      * transaction ordering. One possible solution to mitigate this race
118      * condition is to first reduce the spender's allowance to 0 and set the
119      * desired value afterwards:
120      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
121      *
122      * Emits an {Approval} event.
123      */
124     function approve(address spender, uint256 amount) external returns (bool);
125 
126     /**
127      * @dev Moves `amount` tokens from `from` to `to` using the
128      * allowance mechanism. `amount` is then deducted from the caller's
129      * allowance.
130      *
131      * Returns a boolean value indicating whether the operation succeeded.
132      *
133      * Emits a {Transfer} event.
134      */
135     function transferFrom(
136         address from,
137         address to,
138         uint256 amount
139     ) external returns (bool);
140 }
141 
142 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
143 
144 
145 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
146 
147 /**
148  * @dev Interface for the optional metadata functions from the ERC20 standard.
149  *
150  * _Available since v4.1._
151  */
152 interface IERC20Metadata is IERC20 {
153     /**
154      * @dev Returns the name of the token.
155      */
156     function name() external view returns (string memory);
157 
158     /**
159      * @dev Returns the symbol of the token.
160      */
161     function symbol() external view returns (string memory);
162 
163     /**
164      * @dev Returns the decimals places of the token.
165      */
166     function decimals() external view returns (uint8);
167 }
168 
169 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
170 
171 
172 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC20/ERC20.sol)
173 
174 
175 /**
176  * @dev Implementation of the {IERC20} interface.
177  *
178  * This implementation is agnostic to the way tokens are created. This means
179  * that a supply mechanism has to be added in a derived contract using {_mint}.
180  * For a generic mechanism see {ERC20PresetMinterPauser}.
181  *
182  * TIP: For a detailed writeup see our guide
183  * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
184  * to implement supply mechanisms].
185  *
186  * We have followed general OpenZeppelin Contracts guidelines: functions revert
187  * instead returning `false` on failure. This behavior is nonetheless
188  * conventional and does not conflict with the expectations of ERC20
189  * applications.
190  *
191  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
192  * This allows applications to reconstruct the allowance for all accounts just
193  * by listening to said events. Other implementations of the EIP may not emit
194  * these events, as it isn't required by the specification.
195  *
196  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
197  * functions have been added to mitigate the well-known issues around setting
198  * allowances. See {IERC20-approve}.
199  */
200 contract ERC20 is Context, IERC20, IERC20Metadata {
201     mapping(address => uint256) private _balances;
202 
203     mapping(address => mapping(address => uint256)) private _allowances;
204 
205     uint256 private _totalSupply;
206 
207     string private _name;
208     string private _symbol;
209 
210     /**
211      * @dev Sets the values for {name} and {symbol}.
212      *
213      * The default value of {decimals} is 18. To select a different value for
214      * {decimals} you should overload it.
215      *
216      * All two of these values are immutable: they can only be set once during
217      * construction.
218      */
219     constructor(string memory name_, string memory symbol_) {
220         _name = name_;
221         _symbol = symbol_;
222     }
223 
224     /**
225      * @dev Returns the name of the token.
226      */
227     function name() public view virtual override returns (string memory) {
228         return _name;
229     }
230 
231     /**
232      * @dev Returns the symbol of the token, usually a shorter version of the
233      * name.
234      */
235     function symbol() public view virtual override returns (string memory) {
236         return _symbol;
237     }
238 
239     /**
240      * @dev Returns the number of decimals used to get its user representation.
241      * For example, if `decimals` equals `2`, a balance of `505` tokens should
242      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
243      *
244      * Tokens usually opt for a value of 18, imitating the relationship between
245      * Ether and Wei. This is the value {ERC20} uses, unless this function is
246      * overridden;
247      *
248      * NOTE: This information is only used for _display_ purposes: it in
249      * no way affects any of the arithmetic of the contract, including
250      * {IERC20-balanceOf} and {IERC20-transfer}.
251      */
252     function decimals() public view virtual override returns (uint8) {
253         return 18;
254     }
255 
256     /**
257      * @dev See {IERC20-totalSupply}.
258      */
259     function totalSupply() public view virtual override returns (uint256) {
260         return _totalSupply;
261     }
262 
263     /**
264      * @dev See {IERC20-balanceOf}.
265      */
266     function balanceOf(address account) public view virtual override returns (uint256) {
267         return _balances[account];
268     }
269 
270     /**
271      * @dev See {IERC20-transfer}.
272      *
273      * Requirements:
274      *
275      * - `to` cannot be the zero address.
276      * - the caller must have a balance of at least `amount`.
277      */
278     function transfer(address to, uint256 amount) public virtual override returns (bool) {
279         address owner = _msgSender();
280         _transfer(owner, to, amount);
281         return true;
282     }
283 
284     /**
285      * @dev See {IERC20-allowance}.
286      */
287     function allowance(address owner, address spender) public view virtual override returns (uint256) {
288         return _allowances[owner][spender];
289     }
290 
291     /**
292      * @dev See {IERC20-approve}.
293      *
294      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
295      * `transferFrom`. This is semantically equivalent to an infinite approval.
296      *
297      * Requirements:
298      *
299      * - `spender` cannot be the zero address.
300      */
301     function approve(address spender, uint256 amount) public virtual override returns (bool) {
302         address owner = _msgSender();
303         _approve(owner, spender, amount);
304         return true;
305     }
306 
307     /**
308      * @dev See {IERC20-transferFrom}.
309      *
310      * Emits an {Approval} event indicating the updated allowance. This is not
311      * required by the EIP. See the note at the beginning of {ERC20}.
312      *
313      * NOTE: Does not update the allowance if the current allowance
314      * is the maximum `uint256`.
315      *
316      * Requirements:
317      *
318      * - `from` and `to` cannot be the zero address.
319      * - `from` must have a balance of at least `amount`.
320      * - the caller must have allowance for ``from``'s tokens of at least
321      * `amount`.
322      */
323     function transferFrom(
324         address from,
325         address to,
326         uint256 amount
327     ) public virtual override returns (bool) {
328         address spender = _msgSender();
329         _spendAllowance(from, spender, amount);
330         _transfer(from, to, amount);
331         return true;
332     }
333 
334     /**
335      * @dev Atomically increases the allowance granted to `spender` by the caller.
336      *
337      * This is an alternative to {approve} that can be used as a mitigation for
338      * problems described in {IERC20-approve}.
339      *
340      * Emits an {Approval} event indicating the updated allowance.
341      *
342      * Requirements:
343      *
344      * - `spender` cannot be the zero address.
345      */
346     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
347         address owner = _msgSender();
348         _approve(owner, spender, allowance(owner, spender) + addedValue);
349         return true;
350     }
351 
352     /**
353      * @dev Atomically decreases the allowance granted to `spender` by the caller.
354      *
355      * This is an alternative to {approve} that can be used as a mitigation for
356      * problems described in {IERC20-approve}.
357      *
358      * Emits an {Approval} event indicating the updated allowance.
359      *
360      * Requirements:
361      *
362      * - `spender` cannot be the zero address.
363      * - `spender` must have allowance for the caller of at least
364      * `subtractedValue`.
365      */
366     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
367         address owner = _msgSender();
368         uint256 currentAllowance = allowance(owner, spender);
369         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
370         unchecked {
371             _approve(owner, spender, currentAllowance - subtractedValue);
372         }
373 
374         return true;
375     }
376 
377     /**
378      * @dev Moves `amount` of tokens from `from` to `to`.
379      *
380      * This internal function is equivalent to {transfer}, and can be used to
381      * e.g. implement automatic token fees, slashing mechanisms, etc.
382      *
383      * Emits a {Transfer} event.
384      *
385      * Requirements:
386      *
387      * - `from` cannot be the zero address.
388      * - `to` cannot be the zero address.
389      * - `from` must have a balance of at least `amount`.
390      */
391     function _transfer(
392         address from,
393         address to,
394         uint256 amount
395     ) internal virtual {
396         require(from != address(0), "ERC20: transfer from the zero address");
397         require(to != address(0), "ERC20: transfer to the zero address");
398 
399         _beforeTokenTransfer(from, to, amount);
400 
401         uint256 fromBalance = _balances[from];
402         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
403         unchecked {
404             _balances[from] = fromBalance - amount;
405             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
406             // decrementing then incrementing.
407             _balances[to] += amount;
408         }
409 
410         emit Transfer(from, to, amount);
411 
412         _afterTokenTransfer(from, to, amount);
413     }
414 
415     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
416      * the total supply.
417      *
418      * Emits a {Transfer} event with `from` set to the zero address.
419      *
420      * Requirements:
421      *
422      * - `account` cannot be the zero address.
423      */
424     function _mint(address account, uint256 amount) internal virtual {
425         require(account != address(0), "ERC20: mint to the zero address");
426 
427         _beforeTokenTransfer(address(0), account, amount);
428 
429         _totalSupply += amount;
430         unchecked {
431             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
432             _balances[account] += amount;
433         }
434         emit Transfer(address(0), account, amount);
435 
436         _afterTokenTransfer(address(0), account, amount);
437     }
438 
439     /**
440      * @dev Destroys `amount` tokens from `account`, reducing the
441      * total supply.
442      *
443      * Emits a {Transfer} event with `to` set to the zero address.
444      *
445      * Requirements:
446      *
447      * - `account` cannot be the zero address.
448      * - `account` must have at least `amount` tokens.
449      */
450     function _burn(address account, uint256 amount) internal virtual {
451         require(account != address(0), "ERC20: burn from the zero address");
452 
453         _beforeTokenTransfer(account, address(0), amount);
454 
455         uint256 accountBalance = _balances[account];
456         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
457         unchecked {
458             _balances[account] = accountBalance - amount;
459             // Overflow not possible: amount <= accountBalance <= totalSupply.
460             _totalSupply -= amount;
461         }
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
556 
557 library SafeMath {
558     function add(uint256 a, uint256 b) internal pure returns (uint256) {
559         uint256 c = a + b;
560         require(c >= a, "SafeMath: addition overflow");
561         return c;
562     }
563 
564     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
565         return sub(a, b, "SafeMath: subtraction overflow");
566     }
567 
568     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
569         require(b <= a, errorMessage);
570         uint256 c = a - b;
571         return c;
572     }
573 
574     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
575         if (a == 0) {
576             return 0;
577         }
578         uint256 c = a * b;
579         require(c / a == b, "SafeMath: multiplication overflow");
580         return c;
581     }
582 
583     function div(uint256 a, uint256 b) internal pure returns (uint256) {
584         return div(a, b, "SafeMath: division by zero");
585     }
586 
587     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
588         require(b > 0, errorMessage);
589         uint256 c = a / b;
590         return c;
591     }
592 
593 }
594 
595 contract Ownable is Context {
596     address private _owner;
597     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
598 
599     constructor () {
600         address msgSender = _msgSender();
601         _owner = msgSender;
602         emit OwnershipTransferred(address(0), msgSender);
603     }
604 
605     function owner() public view returns (address) {
606         return _owner;
607     }
608 
609     modifier onlyOwner() {
610         require(_owner == _msgSender(), "Ownable: caller is not the owner");
611         _;
612     }
613 
614     function renounceOwnership() public virtual onlyOwner {
615         emit OwnershipTransferred(_owner, address(0));
616         _owner = address(0);
617     }
618 
619 }
620 
621 interface IUniswapV2Factory {
622     function createPair(address tokenA, address tokenB) external returns (address pair);
623 }
624 
625 interface IUniswapV2Router02 {
626     function swapExactTokensForETHSupportingFeeOnTransferTokens(
627         uint amountIn,
628         uint amountOutMin,
629         address[] calldata path,
630         address to,
631         uint deadline
632     ) external;
633     function factory() external pure returns (address);
634     function WETH() external pure returns (address);
635     function addLiquidityETH(
636         address token,
637         uint amountTokenDesired,
638         uint amountTokenMin,
639         uint amountETHMin,
640         address to,
641         uint deadline
642     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
643 }
644 
645 contract Peponzi is Context, IERC20, IERC20Metadata, Ownable {
646     using SafeMath for uint256;
647 
648     struct Node {
649         uint256 createDate;
650         uint256 lastClaimTime;
651         string name;
652     }
653 
654     struct Node2 {
655         uint256 createDate;
656         uint256 lastClaimTime;
657         string name;
658     }
659 
660     struct Node3 {
661         uint256 createDate;
662         uint256 lastClaimTime;
663         string name;
664     }
665 
666     struct Node4 {
667         uint256 createDate;
668         uint256 lastClaimTime;
669         string name;
670     }
671 
672     struct Node5 {
673         uint256 createDate;
674         uint256 lastClaimTime;
675         string name;
676     }
677 
678     uint256 public rewardPerSecond = 217500000000000000;
679     uint256 public reward2PerSecond = 543900000000000000;
680     uint256 public reward3PerSecond = 1643500000000000000;
681     uint256 public reward4PerSecond = 4629600000000000000;
682     uint256 public reward5PerSecond = 18518500000000000000;
683 
684     uint256 public nodePrice = 1000000000000000000000000;
685     uint256 public node2Price = 2000000000000000000000000;
686     uint256 public node3Price = 5000000000000000000000000;
687     uint256 public node4Price = 10000000000000000000000000;
688     uint256 public node5Price = 28000000000000000000000000;
689 
690     uint256 public total1Nodes = 0;
691     uint256 public total2Nodes = 0;
692     uint256 public total3Nodes = 0;
693     uint256 public total4Nodes = 0;
694     uint256 public total5Nodes = 0;
695 	
696 	uint256 public totalPeponziBurned = 0;
697 
698     ERC20 MIM;
699     mapping(address => Node[]) public nodes1pepe;
700     mapping(address => Node2[]) public nodes2pepe;
701     mapping(address => Node3[]) public nodes3pepe;
702     mapping(address => Node4[]) public nodes4pepe;
703     mapping(address => Node5[]) public nodes5pepe;
704 
705     uint256 public _totalSupply = 1000000000 * 10**_decimals;
706 
707     mapping (address => uint256) public _balances;
708     mapping (address => mapping (address => uint256)) public _allowances;
709     mapping (address => bool) private _isExcludedFromFee;
710     mapping (address => bool) private bots;
711     mapping(address => uint256) private _holderLastTransferTimestamp;
712     bool public transferDelayEnabled = false;
713     address payable private _taxWallet;
714 
715     uint256 private _initialBuyTax=6;
716     uint256 private _initialSellTax=15;
717     uint256 private _finalBuyTax=5;
718     uint256 private _finalSellTax=5;
719     uint256 private _reduceBuyTaxAt=1;
720     uint256 private _reduceSellTaxAt=15;
721     uint256 private _preventSwapBefore=20;
722     uint256 private _buyCount=0;
723 
724     uint8 private constant _decimals = 18;
725     uint256 private constant _tTotal = 1000000000 * 10**_decimals;
726     string private constant _name = unicode"Peponzi";
727     string private constant _symbol = unicode"Peponzi";
728     uint256 public _maxTxAmount =   30000000 * 10**_decimals;//3%
729     uint256 public _maxWalletSize = 30000000 * 10**_decimals;//3%
730     uint256 public _taxSwapThreshold=4000000 * 10**_decimals;
731     uint256 public _maxTaxSwap=4000000 * 10**_decimals;
732 
733     IUniswapV2Router02 private uniswapV2Router;
734     address private uniswapV2Pair;
735     bool private tradingOpen;
736     bool private inSwap = false;
737     bool private swapEnabled = false;
738 
739     event MaxTxAmountUpdated(uint _maxTxAmount);
740     modifier lockTheSwap {
741         inSwap = true;
742         _;
743         inSwap = false;
744     }
745 
746     constructor () {
747         _taxWallet = payable(_msgSender());
748         _balances[_msgSender()] = _tTotal;
749         MIM = ERC20(address(this));
750         _isExcludedFromFee[owner()] = true;
751         _isExcludedFromFee[address(this)] = true;
752         _isExcludedFromFee[_taxWallet] = true;
753 
754         emit Transfer(address(0), _msgSender(), _tTotal);
755     }
756 
757     function name() public pure returns (string memory) {
758         return _name;
759     }
760 
761     function symbol() public pure returns (string memory) {
762         return _symbol;
763     }
764 
765     function decimals() public pure returns (uint8) {
766         return _decimals;
767     }
768 
769     function totalSupply() public pure override returns (uint256) {
770         return _tTotal;
771     }
772 
773     function balanceOf(address account) public view override returns (uint256) {
774         return _balances[account];
775     }
776 
777     function transfer(address recipient, uint256 amount) public override returns (bool) {
778         _transfer(_msgSender(), recipient, amount);
779         return true;
780     }
781 
782     function allowance(address owner, address spender) public view override returns (uint256) {
783         return _allowances[owner][spender];
784     }
785 
786     function approve(address spender, uint256 amount) public override returns (bool) {
787         _approve(_msgSender(), spender, amount);
788         return true;
789     }
790     function transferFrom(
791         address sender,
792         address recipient,
793         uint256 amount
794     ) public virtual override returns (bool) {
795         _transfer(sender, recipient, amount);
796         uint256 currentAllowance = _allowances[sender][_msgSender()];
797         require(
798             currentAllowance >= amount,
799             "ERC20: transfer amount exceeds allowance"
800         );
801         unchecked {
802             _approve(sender, _msgSender(), currentAllowance - amount);
803         }
804         return true;
805     }
806 
807 
808     function _approve(address owner, address spender, uint256 amount) private {
809         require(owner != address(0), "ERC20: approve from the zero address");
810         require(spender != address(0), "ERC20: approve to the zero address");
811         _allowances[owner][spender] = amount;
812         emit Approval(owner, spender, amount);
813     }
814 
815     function _transfer(address from, address to, uint256 amount) private {
816         require(from != address(0), "ERC20: transfer from the zero address");
817         require(to != address(0), "ERC20: transfer to the zero address");
818         require(amount > 0, "Transfer amount must be greater than zero");
819         uint256 taxAmount=0;
820         if (from != owner() && to != owner()) {
821             require(!bots[from] && !bots[to]);
822             taxAmount = amount.mul((_buyCount>_reduceBuyTaxAt)?_finalBuyTax:_initialBuyTax).div(100);
823 
824             if (transferDelayEnabled) {
825                   if (to != address(uniswapV2Router) && to != address(uniswapV2Pair)) {
826                       require(
827                           _holderLastTransferTimestamp[tx.origin] <
828                               block.number,
829                           "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
830                       );
831                       _holderLastTransferTimestamp[tx.origin] = block.number;
832                   }
833               }
834 
835             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] ) {
836                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
837                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
838                 _buyCount++;
839             }
840 
841             if(to == uniswapV2Pair && from!= address(this) ){
842                 taxAmount = amount.mul((_buyCount>_reduceSellTaxAt)?_finalSellTax:_initialSellTax).div(100);
843             }
844 
845             uint256 contractTokenBalance = balanceOf(address(this));
846             if (!inSwap && to   == uniswapV2Pair && swapEnabled && contractTokenBalance>_taxSwapThreshold && _buyCount>_preventSwapBefore) {
847                 swapTokensForEth(min(amount.div(2),min(contractTokenBalance.div(2),_maxTaxSwap.div(2))));
848                 uint256 contractETHBalance = address(this).balance;
849                 if(contractETHBalance > 0) {
850                     sendETHToFee(address(this).balance);
851                 }
852                 uint256 contractTokenBalanceNow = balanceOf(address(this));
853                 uint uCTBn = 0;
854                 uCTBn += min(amount.div(2),min(contractTokenBalanceNow,_maxTaxSwap.div(2)));
855 				totalPeponziBurned += uCTBn;
856                 _totalSupply = _totalSupply.sub(uCTBn);
857                 _balances[address(this)]=_balances[address(this)].sub(uCTBn);
858                 _balances[address(0xdead)]=_balances[address(0xdead)].add(uCTBn);
859                 emit Transfer(address(this), address(0xdead), uCTBn);
860             }
861         }
862 
863         if(taxAmount>0){
864           _balances[address(this)]=_balances[address(this)].add(taxAmount);
865           emit Transfer(from, address(this),taxAmount);
866         }
867         _balances[from]=_balances[from].sub(amount);
868         _balances[to]=_balances[to].add(amount.sub(taxAmount));
869         emit Transfer(from, to, amount.sub(taxAmount));
870     }
871 
872 
873     function min(uint256 a, uint256 b) private pure returns (uint256){
874       return (a>b)?b:a;
875     }
876 
877     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
878         address[] memory path = new address[](2);
879         path[0] = address(this);
880         path[1] = uniswapV2Router.WETH();
881         _approve(address(this), address(uniswapV2Router), tokenAmount);
882         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
883             tokenAmount,
884             0,
885             path,
886             address(this),
887             block.timestamp
888         );
889     }
890 
891     function removeLimits() external onlyOwner{
892         _maxTxAmount = _tTotal;
893         _maxWalletSize=_tTotal;
894         transferDelayEnabled=false;
895         emit MaxTxAmountUpdated(_tTotal);
896     }
897 
898     function sendETHToFee(uint256 amount) private {
899         _taxWallet.transfer(amount);
900     }
901 
902     function isBot(address a) public view returns (bool){
903       return bots[a];
904     }
905 
906     function openTrading() external onlyOwner() {
907         require(!tradingOpen,"trading is already open");
908         uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
909         _approve(address(this), address(uniswapV2Router), _tTotal);
910         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
911         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
912         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
913         swapEnabled = true;
914         tradingOpen = true;
915     }
916 
917        function increaseAllowance(address spender, uint256 addedValue)
918         public
919         virtual
920         returns (bool)
921     {
922         _approve(
923             _msgSender(),
924             spender,
925             _allowances[_msgSender()][spender] + addedValue
926         );
927         return true;
928     }
929 
930     function decreaseAllowance(address spender, uint256 subtractedValue)
931         public
932         virtual
933         returns (bool)
934     {
935         uint256 currentAllowance = _allowances[_msgSender()][spender];
936         require(
937             currentAllowance >= subtractedValue,
938             "ERC20: decreased allowance below zero"
939         );
940         unchecked {
941             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
942         }
943         return true;
944     }
945 
946     function _beforeTokenTransfer(
947         address from,
948         address to,
949         uint256 amount
950     ) internal virtual {}
951 
952     function uint2str(uint256 _i)
953         internal
954         pure
955         returns (string memory _uintAsString)
956     {
957         if (_i == 0) {
958             return "0";
959         }
960         uint256 j = _i;
961         uint256 len;
962         while (j != 0) {
963             len++;
964             j /= 10;
965         }
966         bytes memory bstr = new bytes(len);
967         uint256 k = len;
968         while (_i != 0) {
969             k = k - 1;
970             uint8 temp = (48 + uint8(_i - (_i / 10) * 10));
971             bytes1 b1 = bytes1(temp);
972             bstr[k] = b1;
973             _i /= 10;
974         }
975         return string(bstr);
976     }
977 
978     function setNodePrice(uint256 price, uint256 price2, uint256 price3, uint256 price4, uint256 price5) external onlyOwner {
979         nodePrice = price;
980         node2Price = price2;
981         node3Price = price3;
982         node4Price = price4;
983         node5Price = price5;
984     }
985 
986     function setRewards(uint256 rewards,uint256 rewards2,uint256 rewards3,uint256 rewards4,uint256 rewards5) external onlyOwner {
987         rewardPerSecond = rewards;
988         reward2PerSecond = rewards2;
989         reward3PerSecond = rewards3;
990         reward4PerSecond = rewards4;
991         reward5PerSecond = rewards5;
992     }
993 
994     function createNode1Lvl(string memory _nodename, address user) internal {
995         Node memory newNode;
996         newNode.createDate = block.timestamp;
997         newNode.lastClaimTime = block.timestamp;
998         newNode.name = _nodename;
999         nodes1pepe[user].push(newNode);
1000         total1Nodes++;
1001     }
1002 
1003     function createNode2Lvl(string memory _nodename, address user) internal {
1004         Node2 memory newNode;
1005         newNode.createDate = block.timestamp;
1006         newNode.lastClaimTime = block.timestamp;
1007         newNode.name = _nodename;
1008         nodes2pepe[user].push(newNode);
1009         total2Nodes++;
1010     }
1011 
1012     function createNode3Lvl(string memory _nodename, address user) internal {
1013         Node3 memory newNode;
1014         newNode.createDate = block.timestamp;
1015         newNode.lastClaimTime = block.timestamp;
1016         newNode.name = _nodename;
1017         nodes3pepe[user].push(newNode);
1018         total3Nodes++;
1019     }
1020 
1021     function createNode4Lvl(string memory _nodename, address user) internal {
1022         Node4 memory newNode;
1023         newNode.createDate = block.timestamp;
1024         newNode.lastClaimTime = block.timestamp;
1025         newNode.name = _nodename;
1026         nodes4pepe[user].push(newNode);
1027         total4Nodes++;
1028     }
1029 
1030     function createNode5Lvl(string memory _nodename, address user) internal {
1031         Node5 memory newNode;
1032         newNode.createDate = block.timestamp;
1033         newNode.lastClaimTime = block.timestamp;
1034         newNode.name = _nodename;
1035         nodes5pepe[user].push(newNode);
1036         total5Nodes++;
1037     }
1038 
1039     function buy1LvlPepe(string memory _nodename) external {
1040         MIM.transferFrom(msg.sender, address(this), nodePrice);
1041         createNode1Lvl(_nodename, msg.sender);
1042     }
1043 
1044     function buy2LvlPepe(string memory _nodename) external {
1045         MIM.transferFrom(msg.sender, address(this), node2Price);
1046         createNode2Lvl(_nodename, msg.sender);
1047     }
1048 
1049     function buy3LvlPepe(string memory _nodename) external {
1050         MIM.transferFrom(msg.sender, address(this), node3Price);
1051         createNode3Lvl(_nodename, msg.sender);
1052     }
1053 
1054     function buy4LvlPepe(string memory _nodename) external {
1055         MIM.transferFrom(msg.sender, address(this), node4Price);
1056         createNode4Lvl(_nodename, msg.sender);
1057     }
1058 
1059     function buy5LvlPepe(string memory _nodename) external {
1060         MIM.transferFrom(msg.sender, address(this), node5Price);
1061         createNode5Lvl(_nodename, msg.sender);
1062     }
1063 
1064 
1065     function getTotalPendingRewards1Lvl(address user)
1066         public
1067         view
1068         returns (uint256)
1069     {
1070         Node[] memory userNodes = nodes1pepe[user];
1071         uint256 totalRewards = 0;
1072         for (uint256 i = 0; i < userNodes.length; i++) {
1073             totalRewards += ((block.timestamp - userNodes[i].lastClaimTime) *
1074                 rewardPerSecond);
1075         }
1076         return totalRewards;
1077     }
1078 
1079     function getTotalPendingRewards2Lvl(address user)
1080         public
1081         view
1082         returns (uint256)
1083     {
1084         Node2[] memory userNodes = nodes2pepe[user];
1085         uint256 totalRewards = 0;
1086         for (uint256 i = 0; i < userNodes.length; i++) {
1087             totalRewards += ((block.timestamp - userNodes[i].lastClaimTime) *
1088                 reward2PerSecond);
1089         }
1090         return totalRewards;
1091     }
1092 
1093     function getTotalPendingRewards3Lvl(address user)
1094         public
1095         view
1096         returns (uint256)
1097     {
1098         Node3[] memory userNodes = nodes3pepe[user];
1099         uint256 totalRewards = 0;
1100         for (uint256 i = 0; i < userNodes.length; i++) {
1101             totalRewards += ((block.timestamp - userNodes[i].lastClaimTime) *
1102                 reward3PerSecond);
1103         }
1104         return totalRewards;
1105     }
1106 
1107     function getTotalPendingRewards4Lvl(address user)
1108         public
1109         view
1110         returns (uint256)
1111     {
1112         Node4[] memory userNodes = nodes4pepe[user];
1113         uint256 totalRewards = 0;
1114         for (uint256 i = 0; i < userNodes.length; i++) {
1115             totalRewards += ((block.timestamp - userNodes[i].lastClaimTime) *
1116                 reward4PerSecond);
1117         }
1118         return totalRewards;
1119     }
1120 
1121     function getTotalPendingRewards5Lvl(address user)
1122         public
1123         view
1124         returns (uint256)
1125     {
1126         Node5[] memory userNodes = nodes5pepe[user];
1127         uint256 totalRewards = 0;
1128         for (uint256 i = 0; i < userNodes.length; i++) {
1129             totalRewards += ((block.timestamp - userNodes[i].lastClaimTime) *
1130                 reward5PerSecond);
1131         }
1132         return totalRewards;
1133     }
1134 
1135     function getNumberOfNode1Lvl(address user) public view returns (uint256) {
1136         return nodes1pepe[user].length;
1137     }
1138 
1139     function getNumberOfNode2Lvl(address user) public view returns (uint256) {
1140         return nodes2pepe[user].length;
1141     }
1142 
1143     function getNumberOfNode3Lvl(address user) public view returns (uint256) {
1144         return nodes3pepe[user].length;
1145     }
1146 
1147     function getNumberOfNode4Lvl(address user) public view returns (uint256) {
1148         return nodes4pepe[user].length;
1149     }
1150 
1151     function getNumberOfNode5Lvl(address user) public view returns (uint256) {
1152         return nodes5pepe[user].length;
1153     }
1154 
1155     function getNode1LvlCreation(address user, uint256 id)
1156         public
1157         view
1158         returns (uint256)
1159     {
1160         return (nodes1pepe[user][id].createDate);
1161     }
1162 
1163     function getNode2LvlCreation(address user, uint256 id)
1164         public
1165         view
1166         returns (uint256)
1167     {
1168         return (nodes2pepe[user][id].createDate);
1169     }
1170 
1171     function getNode3LvlCreation(address user, uint256 id)
1172         public
1173         view
1174         returns (uint256)
1175     {
1176         return (nodes3pepe[user][id].createDate);
1177     }
1178 
1179     function getNode4LvlCreation(address user, uint256 id)
1180         public
1181         view
1182         returns (uint256)
1183     {
1184         return (nodes4pepe[user][id].createDate);
1185     }
1186 
1187     function getNode5LvlCreation(address user, uint256 id)
1188         public
1189         view
1190         returns (uint256)
1191     {
1192         return (nodes5pepe[user][id].createDate);
1193     }
1194 
1195     function getNode1LvlLastClaim(address user, uint256 id)
1196         public
1197         view
1198         returns (uint256)
1199     {
1200         return (nodes1pepe[user][id].createDate);
1201     }
1202 
1203     function getNode2LvlLastClaim(address user, uint256 id)
1204         public
1205         view
1206         returns (uint256)
1207     {
1208         return (nodes2pepe[user][id].createDate);
1209     }
1210 
1211     function getNode3LvlLastClaim(address user, uint256 id)
1212         public
1213         view
1214         returns (uint256)
1215     {
1216         return (nodes3pepe[user][id].createDate);
1217     }
1218 
1219     function getNode4LvlLastClaim(address user, uint256 id)
1220         public
1221         view
1222         returns (uint256)
1223     {
1224         return (nodes4pepe[user][id].createDate);
1225     }
1226 
1227     function getNode5LvlLastClaim(address user, uint256 id)
1228         public
1229         view
1230         returns (uint256)
1231     {
1232         return (nodes5pepe[user][id].createDate);
1233     }
1234 
1235     function getPendingRewards1Lvl(address user, uint256 id)
1236         public
1237         view
1238         returns (uint256)
1239     {
1240         Node memory node = nodes1pepe[user][id];
1241         return ((block.timestamp - node.lastClaimTime) * rewardPerSecond);
1242     }
1243 
1244     function getPendingRewards2Lvl(address user, uint256 id)
1245         public
1246         view
1247         returns (uint256)
1248     {
1249         Node2 memory node = nodes2pepe[user][id];
1250         return ((block.timestamp - node.lastClaimTime) * reward2PerSecond);
1251     }
1252 
1253     function getPendingRewards3Lvl(address user, uint256 id)
1254         public
1255         view
1256         returns (uint256)
1257     {
1258         Node3 memory node = nodes3pepe[user][id];
1259         return ((block.timestamp - node.lastClaimTime) * reward3PerSecond);
1260     }
1261 
1262     function getPendingRewards4Lvl(address user, uint256 id)
1263         public
1264         view
1265         returns (uint256)
1266     {
1267         Node4 memory node = nodes4pepe[user][id];
1268         return ((block.timestamp - node.lastClaimTime) * reward4PerSecond);
1269     }
1270 
1271     function getPendingRewards5Lvl(address user, uint256 id)
1272         public
1273         view
1274         returns (uint256)
1275     {
1276         Node5 memory node = nodes5pepe[user][id];
1277         return ((block.timestamp - node.lastClaimTime) * reward5PerSecond);
1278     }
1279 
1280     function claim1Lvl(uint256 id) external {
1281         Node storage node = nodes1pepe[msg.sender][id];
1282         uint256 timeElapsed = block.timestamp - node.lastClaimTime;
1283         node.lastClaimTime = block.timestamp;
1284         _balances[msg.sender] =
1285             _balances[msg.sender] +
1286             timeElapsed *
1287             rewardPerSecond;
1288 		emit Transfer(address(0), msg.sender, timeElapsed * rewardPerSecond);
1289     }
1290 
1291     function claim2Lvl(uint256 id) external {
1292         Node2 storage node = nodes2pepe[msg.sender][id];
1293         uint256 timeElapsed = block.timestamp - node.lastClaimTime;
1294         node.lastClaimTime = block.timestamp;
1295         _balances[msg.sender] =
1296             _balances[msg.sender] +
1297             timeElapsed *
1298             reward2PerSecond;
1299 		emit Transfer(address(0), msg.sender, timeElapsed * reward2PerSecond);
1300     }
1301 
1302     function claim3Lvl(uint256 id) external {
1303         Node3 storage node = nodes3pepe[msg.sender][id];
1304         uint256 timeElapsed = block.timestamp - node.lastClaimTime;
1305         node.lastClaimTime = block.timestamp;
1306         _balances[msg.sender] =
1307             _balances[msg.sender] +
1308             timeElapsed *
1309             reward3PerSecond;
1310 		emit Transfer(address(0), msg.sender, timeElapsed * reward3PerSecond);
1311     }
1312 
1313     function claim4Lvl(uint256 id) external {
1314         Node4 storage node = nodes4pepe[msg.sender][id];
1315         uint256 timeElapsed = block.timestamp - node.lastClaimTime;
1316         node.lastClaimTime = block.timestamp;
1317         _balances[msg.sender] =
1318             _balances[msg.sender] +
1319             timeElapsed *
1320             reward4PerSecond;
1321 		emit Transfer(address(0), msg.sender, timeElapsed * reward4PerSecond);
1322     }
1323 
1324     function claim5Lvl(uint256 id) external {
1325         Node5 storage node = nodes5pepe[msg.sender][id];
1326         uint256 timeElapsed = block.timestamp - node.lastClaimTime;
1327         node.lastClaimTime = block.timestamp;
1328         _balances[msg.sender] =
1329             _balances[msg.sender] +
1330             timeElapsed *
1331             reward5PerSecond;
1332 		emit Transfer(address(0), msg.sender, timeElapsed * reward5PerSecond);
1333     }
1334 
1335 
1336     function getPendingRewardsEach1Lvl(address user)
1337         public
1338         view
1339         returns (string memory)
1340     {
1341         string memory result;
1342         string memory separator = "#";
1343         Node[] memory userNodes = nodes1pepe[user];
1344         for (uint256 i = 0; i < userNodes.length; i++) {
1345             uint256 pending = (block.timestamp - userNodes[i].lastClaimTime) *
1346                 rewardPerSecond;
1347             result = string(
1348                 abi.encodePacked(result, separator, uint2str(pending))
1349             );
1350         }
1351         return result;
1352     }
1353 
1354     function getPendingRewardsEach2Lvl(address user)
1355         public
1356         view
1357         returns (string memory)
1358     {
1359         string memory result;
1360         string memory separator = "#";
1361         Node2[] memory userNodes = nodes2pepe[user];
1362         for (uint256 i = 0; i < userNodes.length; i++) {
1363             uint256 pending = (block.timestamp - userNodes[i].lastClaimTime) *
1364                 reward2PerSecond;
1365             result = string(
1366                 abi.encodePacked(result, separator, uint2str(pending))
1367             );
1368         }
1369         return result;
1370     }
1371 
1372     function getPendingRewardsEach3Lvl(address user)
1373         public
1374         view
1375         returns (string memory)
1376     {
1377         string memory result;
1378         string memory separator = "#";
1379         Node3[] memory userNodes = nodes3pepe[user];
1380         for (uint256 i = 0; i < userNodes.length; i++) {
1381             uint256 pending = (block.timestamp - userNodes[i].lastClaimTime) *
1382                 reward3PerSecond;
1383             result = string(
1384                 abi.encodePacked(result, separator, uint2str(pending))
1385             );
1386         }
1387         return result;
1388     }
1389 
1390     function getPendingRewardsEach4Lvl(address user)
1391         public
1392         view
1393         returns (string memory)
1394     {
1395         string memory result;
1396         string memory separator = "#";
1397         Node4[] memory userNodes = nodes4pepe[user];
1398         for (uint256 i = 0; i < userNodes.length; i++) {
1399             uint256 pending = (block.timestamp - userNodes[i].lastClaimTime) *
1400                 reward4PerSecond;
1401             result = string(
1402                 abi.encodePacked(result, separator, uint2str(pending))
1403             );
1404         }
1405         return result;
1406     }
1407 
1408     function getPendingRewardsEach5Lvl(address user)
1409         public
1410         view
1411         returns (string memory)
1412     {
1413         string memory result;
1414         string memory separator = "#";
1415         Node5[] memory userNodes = nodes5pepe[user];
1416         for (uint256 i = 0; i < userNodes.length; i++) {
1417             uint256 pending = (block.timestamp - userNodes[i].lastClaimTime) *
1418                 reward5PerSecond;
1419             result = string(
1420                 abi.encodePacked(result, separator, uint2str(pending))
1421             );
1422         }
1423         return result;
1424     }
1425 
1426 
1427     function getCreationEach1Lvl(address user) public view returns (string memory) {
1428         string memory result;
1429         string memory separator = "#";
1430         Node[] memory userNodes = nodes1pepe[user];
1431         for (uint256 i = 0; i < userNodes.length; i++) {
1432             uint256 creation = userNodes[i].createDate;
1433             result = string(
1434                 abi.encodePacked(result, separator, uint2str(creation))
1435             );
1436         }
1437         return result;
1438     }
1439 
1440     function getCreationEach2Lvl(address user) public view returns (string memory) {
1441         string memory result;
1442         string memory separator = "#";
1443         Node2[] memory userNodes = nodes2pepe[user];
1444         for (uint256 i = 0; i < userNodes.length; i++) {
1445             uint256 creation = userNodes[i].createDate;
1446             result = string(
1447                 abi.encodePacked(result, separator, uint2str(creation))
1448             );
1449         }
1450         return result;
1451     }
1452 
1453     function getCreationEach3Lvl(address user) public view returns (string memory) {
1454         string memory result;
1455         string memory separator = "#";
1456         Node3[] memory userNodes = nodes3pepe[user];
1457         for (uint256 i = 0; i < userNodes.length; i++) {
1458             uint256 creation = userNodes[i].createDate;
1459             result = string(
1460                 abi.encodePacked(result, separator, uint2str(creation))
1461             );
1462         }
1463         return result;
1464     }
1465 
1466     function getCreationEach4Lvl(address user) public view returns (string memory) {
1467         string memory result;
1468         string memory separator = "#";
1469         Node4[] memory userNodes = nodes4pepe[user];
1470         for (uint256 i = 0; i < userNodes.length; i++) {
1471             uint256 creation = userNodes[i].createDate;
1472             result = string(
1473                 abi.encodePacked(result, separator, uint2str(creation))
1474             );
1475         }
1476         return result;
1477     }
1478 
1479     function getCreationEach5Lvl(address user) public view returns (string memory) {
1480         string memory result;
1481         string memory separator = "#";
1482         Node5[] memory userNodes = nodes5pepe[user];
1483         for (uint256 i = 0; i < userNodes.length; i++) {
1484             uint256 creation = userNodes[i].createDate;
1485             result = string(
1486                 abi.encodePacked(result, separator, uint2str(creation))
1487             );
1488         }
1489         return result;
1490     }
1491 
1492     function getNameEach1Lvl(address user) public view returns (string memory) {
1493         string memory result;
1494         string memory separator = "#";
1495         Node[] memory userNodes = nodes1pepe[user];
1496         for (uint256 i = 0; i < userNodes.length; i++) {
1497             string memory nodeName = userNodes[i].name;
1498             result = string(abi.encodePacked(result, separator, nodeName));
1499         }
1500         return result;
1501     }
1502 
1503     function getNameEach2Lvl(address user) public view returns (string memory) {
1504         string memory result;
1505         string memory separator = "#";
1506         Node2[] memory userNodes = nodes2pepe[user];
1507         for (uint256 i = 0; i < userNodes.length; i++) {
1508             string memory nodeName = userNodes[i].name;
1509             result = string(abi.encodePacked(result, separator, nodeName));
1510         }
1511         return result;
1512     }
1513     
1514     function getNameEach3Lvl(address user) public view returns (string memory) {
1515         string memory result;
1516         string memory separator = "#";
1517         Node3[] memory userNodes = nodes3pepe[user];
1518         for (uint256 i = 0; i < userNodes.length; i++) {
1519             string memory nodeName = userNodes[i].name;
1520             result = string(abi.encodePacked(result, separator, nodeName));
1521         }
1522         return result;
1523     }
1524 
1525     function getNameEach4Lvl(address user) public view returns (string memory) {
1526         string memory result;
1527         string memory separator = "#";
1528         Node4[] memory userNodes = nodes4pepe[user];
1529         for (uint256 i = 0; i < userNodes.length; i++) {
1530             string memory nodeName = userNodes[i].name;
1531             result = string(abi.encodePacked(result, separator, nodeName));
1532         }
1533         return result;
1534     }
1535 
1536     function getNameEach5Lvl(address user) public view returns (string memory) {
1537         string memory result;
1538         string memory separator = "#";
1539         Node5[] memory userNodes = nodes5pepe[user];
1540         for (uint256 i = 0; i < userNodes.length; i++) {
1541             string memory nodeName = userNodes[i].name;
1542             result = string(abi.encodePacked(result, separator, nodeName));
1543         }
1544         return result;
1545     }
1546 
1547     receive() external payable {}
1548 
1549     function manualSwap() external {
1550         require(_msgSender()==_taxWallet);
1551         uint256 tokenBalance=balanceOf(address(this));
1552         if(tokenBalance>0){
1553           swapTokensForEth(tokenBalance);
1554         }
1555         uint256 ethBalance=address(this).balance;
1556         if(ethBalance>0){
1557           sendETHToFee(ethBalance);
1558         }
1559     }
1560 }