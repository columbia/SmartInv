1 /**
2 
3 
4 
5 ░█████╗░██╗░░░░░██╗███████╗███╗░░██╗  ██╗███╗░░██╗██╗░░░██╗░█████╗░░██████╗██╗░█████╗░███╗░░██╗
6 ██╔══██╗██║░░░░░██║██╔════╝████╗░██║  ██║████╗░██║██║░░░██║██╔══██╗██╔════╝██║██╔══██╗████╗░██║
7 ███████║██║░░░░░██║█████╗░░██╔██╗██║  ██║██╔██╗██║╚██╗░██╔╝███████║╚█████╗░██║██║░░██║██╔██╗██║
8 ██╔══██║██║░░░░░██║██╔══╝░░██║╚████║  ██║██║╚████║░╚████╔╝░██╔══██║░╚═══██╗██║██║░░██║██║╚████║
9 ██║░░██║███████╗██║███████╗██║░╚███║  ██║██║░╚███║░░╚██╔╝░░██║░░██║██████╔╝██║╚█████╔╝██║░╚███║
10 ╚═╝░░╚═╝╚══════╝╚═╝╚══════╝╚═╝░░╚══╝  ╚═╝╚═╝░░╚══╝░░░╚═╝░░░╚═╝░░╚═╝╚═════╝░╚═╝░╚════╝░╚═╝░░╚══╝
11 =================================================
12 Website : http://alieninvasion.life/
13 Telegram: https://t.me/AInvasionERC
14 Twitter : https://twitter.com/AInvasionERC
15 =================================================
16 
17 ░█████╗░██╗░░░░░██╗███████╗███╗░░██╗  ██╗███╗░░██╗██╗░░░██╗░█████╗░░██████╗██╗░█████╗░███╗░░██╗
18 ██╔══██╗██║░░░░░██║██╔════╝████╗░██║  ██║████╗░██║██║░░░██║██╔══██╗██╔════╝██║██╔══██╗████╗░██║
19 ███████║██║░░░░░██║█████╗░░██╔██╗██║  ██║██╔██╗██║╚██╗░██╔╝███████║╚█████╗░██║██║░░██║██╔██╗██║
20 ██╔══██║██║░░░░░██║██╔══╝░░██║╚████║  ██║██║╚████║░╚████╔╝░██╔══██║░╚═══██╗██║██║░░██║██║╚████║
21 ██║░░██║███████╗██║███████╗██║░╚███║  ██║██║░╚███║░░╚██╔╝░░██║░░██║██████╔╝██║╚█████╔╝██║░╚███║
22 ╚═╝░░╚═╝╚══════╝╚═╝╚══════╝╚═╝░░╚══╝  ╚═╝╚═╝░░╚══╝░░░╚═╝░░░╚═╝░░╚═╝╚═════╝░╚═╝░╚════╝░╚═╝░░╚══╝
23 */
24 
25 // SPDX-License-Identifier: MIT                                                                               
26                                                     
27 pragma solidity = 0.8.19;
28 
29 abstract contract Context {
30     function _msgSender() internal view virtual returns (address) {
31         return msg.sender;
32     }
33 
34     function _msgData() internal view virtual returns (bytes calldata) {
35         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
36         return msg.data;
37     }
38 }
39 
40 interface IUniswapV2Pair {
41     event Sync(uint112 reserve0, uint112 reserve1);
42     function sync() external;
43 }
44 
45 interface IUniswapV2Factory {
46     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
47 
48     function createPair(address tokenA, address tokenB) external returns (address pair);
49 }
50 
51 interface IERC20 {
52     /**
53      * @dev Returns the amount of tokens in existence.
54      */
55     function totalSupply() external view returns (uint256);
56 
57     /**
58      * @dev Returns the amount of tokens owned by `account`.
59      */
60     function balanceOf(address account) external view returns (uint256);
61 
62     /**
63      * @dev Moves `amount` tokens from the caller's account to `recipient`.
64      *
65      * Returns a boolean value indicating whether the operation succeeded.
66      *
67      * Emits a {Transfer} event.
68      */
69     function transfer(address recipient, uint256 amount) external returns (bool);
70 
71     /**
72      * @dev Returns the remaining number of tokens that `spender` will be
73      * allowed to spend on behalf of `owner` through {transferFrom}. This is
74      * zero by default.
75      *
76      * This value changes when {approve} or {transferFrom} are called.
77      */
78     function allowance(address owner, address spender) external view returns (uint256);
79 
80     /**
81      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
82      *
83      * Returns a boolean value indicating whether the operation succeeded.
84      *
85      * IMPORTANT: Beware that changing an allowance with this method brings the risk
86      * that someone may use both the old and the new allowance by unfortunate
87      * transaction ordering. One possible solution to mitigate this race
88      * condition is to first reduce the spender's allowance to 0 and set the
89      * desired value afterwards:
90      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
91      *
92      * Emits an {Approval} event.
93      */
94     function approve(address spender, uint256 amount) external returns (bool);
95 
96     /**
97      * @dev Moves `amount` tokens from `sender` to `recipient` using the
98      * allowance mechanism. `amount` is then deducted from the caller's
99      * allowance.
100      *
101      * Returns a boolean value indicating whether the operation succeeded.
102      *
103      * Emits a {Transfer} event.
104      */
105     function transferFrom(
106         address sender,
107         address recipient,
108         uint256 amount
109     ) external returns (bool);
110 
111     /**
112      * @dev Emitted when `value` tokens are moved from one account (`from`) to
113      * another (`to`).
114      *
115      * Note that `value` may be zero.
116      */
117     event Transfer(address indexed from, address indexed to, uint256 value);
118 
119     /**
120      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
121      * a call to {approve}. `value` is the new allowance.
122      */
123     event Approval(address indexed owner, address indexed spender, uint256 value);
124 }
125 
126 interface IERC20Metadata is IERC20 {
127     /**
128      * @dev Returns the name of the token.
129      */
130     function name() external view returns (string memory);
131 
132     /**
133      * @dev Returns the symbol of the token.
134      */
135     function symbol() external view returns (string memory);
136 
137     /**
138      * @dev Returns the decimals places of the token.
139      */
140     function decimals() external view returns (uint8);
141 }
142 
143 
144 contract ERC20 is Context, IERC20, IERC20Metadata {
145     using SafeMath for uint256;
146 
147     mapping(address => uint256) private _balances;
148 
149     mapping(address => mapping(address => uint256)) private _allowances;
150 
151     uint256 private _totalSupply;
152 
153     string private _name;
154     string private _symbol;
155 
156     /**
157      * @dev Sets the values for {name} and {symbol}.
158      *
159      * The default value of {decimals} is 18. To select a different value for
160      * {decimals} you should overload it.
161      *
162      * All two of these values are immutable: they can only be set once during
163      * construction.
164      */
165     constructor(string memory name_, string memory symbol_) {
166         _name = name_;
167         _symbol = symbol_;
168     }
169 
170     /**
171      * @dev Returns the name of the token.
172      */
173     function name() public view virtual override returns (string memory) {
174         return _name;
175     }
176 
177     /**
178      * @dev Returns the symbol of the token, usually a shorter version of the
179      * name.
180      */
181     function symbol() public view virtual override returns (string memory) {
182         return _symbol;
183     }
184 
185     /**
186      * @dev Returns the number of decimals used to get its user representation.
187      * For example, if `decimals` equals `2`, a balance of `505` tokens should
188      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
189      *
190      * Tokens usually opt for a value of 18, imitating the relationship between
191      * Ether and Wei. This is the value {ERC20} uses, unless this function is
192      * overridden;
193      *
194      * NOTE: This information is only used for _display_ purposes: it in
195      * no way affects any of the arithmetic of the contract, including
196      * {IERC20-balanceOf} and {IERC20-transfer}.
197      */
198     function decimals() public view virtual override returns (uint8) {
199         return 18;
200     }
201 
202     /**
203      * @dev See {IERC20-totalSupply}.
204      */
205     function totalSupply() public view virtual override returns (uint256) {
206         return _totalSupply;
207     }
208 
209     /**
210      * @dev See {IERC20-balanceOf}.
211      */
212     function balanceOf(address account) public view virtual override returns (uint256) {
213         return _balances[account];
214     }
215 
216     /**
217      * @dev See {IERC20-transfer}.
218      *
219      * Requirements:
220      *
221      * - `recipient` cannot be the zero address.
222      * - the caller must have a balance of at least `amount`.
223      */
224     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
225         _transfer(_msgSender(), recipient, amount);
226         return true;
227     }
228 
229     /**
230      * @dev See {IERC20-allowance}.
231      */
232     function allowance(address owner, address spender) public view virtual override returns (uint256) {
233         return _allowances[owner][spender];
234     }
235 
236     /**
237      * @dev See {IERC20-approve}.
238      *
239      * Requirements:
240      *
241      * - `spender` cannot be the zero address.
242      */
243     function approve(address spender, uint256 amount) public virtual override returns (bool) {
244         _approve(_msgSender(), spender, amount);
245         return true;
246     }
247 
248     /**
249      * @dev See {IERC20-transferFrom}.
250      *
251      * Emits an {Approval} event indicating the updated allowance. This is not
252      * required by the EIP. See the note at the beginning of {ERC20}.
253      *
254      * Requirements:
255      *
256      * - `sender` and `recipient` cannot be the zero address.
257      * - `sender` must have a balance of at least `amount`.
258      * - the caller must have allowance for ``sender``'s tokens of at least
259      * `amount`.
260      */
261     function transferFrom(
262         address sender,
263         address recipient,
264         uint256 amount
265     ) public virtual override returns (bool) {
266         _transfer(sender, recipient, amount);
267         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
268         return true;
269     }
270 
271     /**
272      * @dev Atomically increases the allowance granted to `spender` by the caller.
273      *
274      * This is an alternative to {approve} that can be used as a mitigation for
275      * problems described in {IERC20-approve}.
276      *
277      * Emits an {Approval} event indicating the updated allowance.
278      *
279      * Requirements:
280      *
281      * - `spender` cannot be the zero address.
282      */
283     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
284         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
285         return true;
286     }
287 
288     /**
289      * @dev Atomically decreases the allowance granted to `spender` by the caller.
290      *
291      * This is an alternative to {approve} that can be used as a mitigation for
292      * problems described in {IERC20-approve}.
293      *
294      * Emits an {Approval} event indicating the updated allowance.
295      *
296      * Requirements:
297      *
298      * - `spender` cannot be the zero address.
299      * - `spender` must have allowance for the caller of at least
300      * `subtractedValue`.
301      */
302     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
303         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
304         return true;
305     }
306 
307     /**
308      * @dev Moves tokens `amount` from `sender` to `recipient`.
309      *
310      * This is internal function is equivalent to {transfer}, and can be used to
311      * e.g. implement automatic token fees, slashing mechanisms, etc.
312      *
313      * Emits a {Transfer} event.
314      *
315      * Requirements:
316      *
317      * - `sender` cannot be the zero address.
318      * - `recipient` cannot be the zero address.
319      * - `sender` must have a balance of at least `amount`.
320      */
321     function _transfer(
322         address sender,
323         address recipient,
324         uint256 amount
325     ) internal virtual {
326         require(sender != address(0), "ERC20: transfer from the zero address");
327         require(recipient != address(0), "ERC20: transfer to the zero address");
328 
329         _beforeTokenTransfer(sender, recipient, amount);
330 
331         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
332         _balances[recipient] = _balances[recipient].add(amount);
333         emit Transfer(sender, recipient, amount);
334     }
335 
336     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
337      * the total supply.
338      *
339      * Emits a {Transfer} event with `from` set to the zero address.
340      *
341      * Requirements:
342      *
343      * - `account` cannot be the zero address.
344      */
345     function _mint(address account, uint256 amount) internal virtual {
346         require(account != address(0), "ERC20: mint to the zero address");
347 
348         _beforeTokenTransfer(address(0), account, amount);
349 
350         _totalSupply = _totalSupply.add(amount);
351         _balances[account] = _balances[account].add(amount);
352         emit Transfer(address(0), account, amount);
353     }
354 
355     /**
356      * @dev Destroys `amount` tokens from `account`, reducing the
357      * total supply.
358      *
359      * Emits a {Transfer} event with `to` set to the zero address.
360      *
361      * Requirements:
362      *
363      * - `account` cannot be the zero address.
364      * - `account` must have at least `amount` tokens.
365      */
366     function _burn(address account, uint256 amount) internal virtual {
367         require(account != address(0), "ERC20: burn from the zero address");
368 
369         _beforeTokenTransfer(account, address(0), amount);
370 
371         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
372         _totalSupply = _totalSupply.sub(amount);
373         emit Transfer(account, address(0), amount);
374     }
375 
376     /**
377      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
378      *
379      * This internal function is equivalent to `approve`, and can be used to
380      * e.g. set automatic allowances for certain subsystems, etc.
381      *
382      * Emits an {Approval} event.
383      *
384      * Requirements:
385      *
386      * - `owner` cannot be the zero address.
387      * - `spender` cannot be the zero address.
388      */
389     function _approve(
390         address owner,
391         address spender,
392         uint256 amount
393     ) internal virtual {
394         require(owner != address(0), "ERC20: approve from the zero address");
395         require(spender != address(0), "ERC20: approve to the zero address");
396 
397         _allowances[owner][spender] = amount;
398         emit Approval(owner, spender, amount);
399     }
400 
401     /**
402      * @dev Hook that is called before any transfer of tokens. This includes
403      * minting and burning.
404      *
405      * Calling conditions:
406      *
407      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
408      * will be to transferred to `to`.
409      * - when `from` is zero, `amount` tokens will be minted for `to`.
410      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
411      * - `from` and `to` are never both zero.
412      *
413      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
414      */
415     function _beforeTokenTransfer(
416         address from,
417         address to,
418         uint256 amount
419     ) internal virtual {}
420 }
421 
422 library SafeMath {
423     /**
424      * @dev Returns the addition of two unsigned integers, reverting on
425      * overflow.
426      *
427      * Counterpart to Solidity's `+` operator.
428      *
429      * Requirements:
430      *
431      * - Addition cannot overflow.
432      */
433     function add(uint256 a, uint256 b) internal pure returns (uint256) {
434         uint256 c = a + b;
435         require(c >= a, "SafeMath: addition overflow");
436 
437         return c;
438     }
439 
440     /**
441      * @dev Returns the subtraction of two unsigned integers, reverting on
442      * overflow (when the result is negative).
443      *
444      * Counterpart to Solidity's `-` operator.
445      *
446      * Requirements:
447      *
448      * - Subtraction cannot overflow.
449      */
450     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
451         return sub(a, b, "SafeMath: subtraction overflow");
452     }
453 
454     /**
455      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
456      * overflow (when the result is negative).
457      *
458      * Counterpart to Solidity's `-` operator.
459      *
460      * Requirements:
461      *
462      * - Subtraction cannot overflow.
463      */
464     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
465         require(b <= a, errorMessage);
466         uint256 c = a - b;
467 
468         return c;
469     }
470 
471     /**
472      * @dev Returns the multiplication of two unsigned integers, reverting on
473      * overflow.
474      *
475      * Counterpart to Solidity's `*` operator.
476      *
477      * Requirements:
478      *
479      * - Multiplication cannot overflow.
480      */
481     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
482         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
483         // benefit is lost if 'b' is also tested.
484         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
485         if (a == 0) {
486             return 0;
487         }
488 
489         uint256 c = a * b;
490         require(c / a == b, "SafeMath: multiplication overflow");
491 
492         return c;
493     }
494 
495     /**
496      * @dev Returns the integer division of two unsigned integers. Reverts on
497      * division by zero. The result is rounded towards zero.
498      *
499      * Counterpart to Solidity's `/` operator. Note: this function uses a
500      * `revert` opcode (which leaves remaining gas untouched) while Solidity
501      * uses an invalid opcode to revert (consuming all remaining gas).
502      *
503      * Requirements:
504      *
505      * - The divisor cannot be zero.
506      */
507     function div(uint256 a, uint256 b) internal pure returns (uint256) {
508         return div(a, b, "SafeMath: division by zero");
509     }
510 
511     /**
512      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
513      * division by zero. The result is rounded towards zero.
514      *
515      * Counterpart to Solidity's `/` operator. Note: this function uses a
516      * `revert` opcode (which leaves remaining gas untouched) while Solidity
517      * uses an invalid opcode to revert (consuming all remaining gas).
518      *
519      * Requirements:
520      *
521      * - The divisor cannot be zero.
522      */
523     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
524         require(b > 0, errorMessage);
525         uint256 c = a / b;
526         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
527 
528         return c;
529     }
530 
531     /**
532      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
533      * Reverts when dividing by zero.
534      *
535      * Counterpart to Solidity's `%` operator. This function uses a `revert`
536      * opcode (which leaves remaining gas untouched) while Solidity uses an
537      * invalid opcode to revert (consuming all remaining gas).
538      *
539      * Requirements:
540      *
541      * - The divisor cannot be zero.
542      */
543     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
544         return mod(a, b, "SafeMath: modulo by zero");
545     }
546 
547     /**
548      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
549      * Reverts with custom message when dividing by zero.
550      *
551      * Counterpart to Solidity's `%` operator. This function uses a `revert`
552      * opcode (which leaves remaining gas untouched) while Solidity uses an
553      * invalid opcode to revert (consuming all remaining gas).
554      *
555      * Requirements:
556      *
557      * - The divisor cannot be zero.
558      */
559     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
560         require(b != 0, errorMessage);
561         return a % b;
562     }
563 }
564 
565 contract Ownable is Context {
566     address private _owner;
567 
568     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
569     
570     /**
571      * @dev Initializes the contract setting the deployer as the initial owner.
572      */
573     constructor () {
574         address msgSender = _msgSender();
575         _owner = msgSender;
576         emit OwnershipTransferred(address(0), msgSender);
577     }
578 
579     /**
580      * @dev Returns the address of the current owner.
581      */
582     function owner() public view returns (address) {
583         return _owner;
584     }
585 
586     /**
587      * @dev Throws if called by any account other than the owner.
588      */
589     modifier onlyOwner() {
590         require(_owner == _msgSender(), "Ownable: caller is not the owner");
591         _;
592     }
593 
594     /**
595      * @dev Leaves the contract without owner. It will not be possible to call
596      * `onlyOwner` functions anymore. Can only be called by the current owner.
597      *
598      * NOTE: Renouncing ownership will leave the contract without an owner,
599      * thereby removing any functionality that is only available to the owner.
600      */
601     function renounceOwnership() public virtual onlyOwner {
602         emit OwnershipTransferred(_owner, address(0));
603         _owner = address(0);
604     }
605 
606     /**
607      * @dev Transfers ownership of the contract to a new account (`newOwner`).
608      * Can only be called by the current owner.
609      */
610     function transferOwnership(address newOwner) public virtual onlyOwner {
611         require(newOwner != address(0), "Ownable: new owner is the zero address");
612         emit OwnershipTransferred(_owner, newOwner);
613         _owner = newOwner;
614     }
615 }
616 
617 
618 
619 library SafeMathInt {
620     int256 private constant MIN_INT256 = int256(1) << 255;
621     int256 private constant MAX_INT256 = ~(int256(1) << 255);
622 
623     /**
624      * @dev Multiplies two int256 variables and fails on overflow.
625      */
626     function mul(int256 a, int256 b) internal pure returns (int256) {
627         int256 c = a * b;
628 
629         // Detect overflow when multiplying MIN_INT256 with -1
630         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
631         require((b == 0) || (c / b == a));
632         return c;
633     }
634 
635     /**
636      * @dev Division of two int256 variables and fails on overflow.
637      */
638     function div(int256 a, int256 b) internal pure returns (int256) {
639         // Prevent overflow when dividing MIN_INT256 by -1
640         require(b != -1 || a != MIN_INT256);
641 
642         // Solidity already throws when dividing by 0.
643         return a / b;
644     }
645 
646     /**
647      * @dev Subtracts two int256 variables and fails on overflow.
648      */
649     function sub(int256 a, int256 b) internal pure returns (int256) {
650         int256 c = a - b;
651         require((b >= 0 && c <= a) || (b < 0 && c > a));
652         return c;
653     }
654 
655     /**
656      * @dev Adds two int256 variables and fails on overflow.
657      */
658     function add(int256 a, int256 b) internal pure returns (int256) {
659         int256 c = a + b;
660         require((b >= 0 && c >= a) || (b < 0 && c < a));
661         return c;
662     }
663 
664     /**
665      * @dev Converts to absolute value, and fails on overflow.
666      */
667     function abs(int256 a) internal pure returns (int256) {
668         require(a != MIN_INT256);
669         return a < 0 ? -a : a;
670     }
671 
672 
673     function toUint256Safe(int256 a) internal pure returns (uint256) {
674         require(a >= 0);
675         return uint256(a);
676     }
677 }
678 
679 library SafeMathUint {
680   function toInt256Safe(uint256 a) internal pure returns (int256) {
681     int256 b = int256(a);
682     require(b >= 0);
683     return b;
684   }
685 }
686 
687 
688 interface IUniswapV2Router01 {
689     function factory() external pure returns (address);
690     function WETH() external pure returns (address);
691 
692     function addLiquidityETH(
693         address token,
694         uint amountTokenDesired,
695         uint amountTokenMin,
696         uint amountETHMin,
697         address to,
698         uint deadline
699     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
700 }
701 
702 interface IUniswapV2Router02 is IUniswapV2Router01 {
703     function swapExactTokensForETHSupportingFeeOnTransferTokens(
704         uint amountIn,
705         uint amountOutMin,
706         address[] calldata path,
707         address to,
708         uint deadline
709     ) external;
710 }
711 
712 contract AI is ERC20, Ownable {
713 
714     IUniswapV2Router02 public immutable uniswapV2Router;
715     address public immutable uniswapV2Pair;
716     address public constant deadAddress = address(0xdead);
717 
718     bool private swapping;
719 
720     address public marketingWallet;
721     address public devWallet;
722     
723     uint256 public maxTransactionAmount;
724     uint256 public swapTokensAtAmount;
725     uint256 public maxWallet;
726     
727     uint256 public percentForLPBurn = 25; // 25 = .25%
728     bool public lpBurnEnabled = false;
729     uint256 public lpBurnFrequency = 3600 seconds;
730     uint256 public lastLpBurnTime;
731     
732     uint256 public manualBurnFrequency = 30 minutes;
733     uint256 public lastManualLpBurnTime;
734 
735     bool public limitsInEffect = true;
736     bool public tradingActive = false;
737     bool public swapEnabled = false;
738     
739      // Anti-bot and anti-whale mappings and variables
740     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
741     mapping (address => bool) public isBlacklisted;
742     bool public transferDelayEnabled = true;
743 
744     uint256 public buyTotalFees;
745     uint256 public buyMarketingFee;
746     uint256 public buyLiquidityFee;
747     uint256 public buyDevFee;
748     
749     uint256 public sellTotalFees;
750     uint256 public sellMarketingFee;
751     uint256 public sellLiquidityFee;
752     uint256 public sellDevFee;
753     
754     uint256 public tokensForMarketing;
755     uint256 public tokensForLiquidity;
756     uint256 public tokensForDev;
757     
758     mapping(address => bool) private whitelist;
759 
760     // exlcude from fees and max transaction amount
761     mapping (address => bool) private _isExcludedFromFees;
762     mapping (address => bool) public _isExcludedMaxTransactionAmount;
763 
764     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
765     // could be subject to a maximum transfer amount
766     mapping (address => bool) public automatedMarketMakerPairs;
767 
768     constructor() ERC20("Alien Invasion", "AI") {
769         
770         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
771         
772         excludeFromMaxTransaction(address(_uniswapV2Router), true);
773         uniswapV2Router = _uniswapV2Router;
774         
775         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
776         excludeFromMaxTransaction(address(uniswapV2Pair), true);
777         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
778         
779         uint256 _buyMarketingFee = 25;
780         uint256 _buyLiquidityFee = 0;
781         uint256 _buyDevFee = 0;
782 
783         uint256 _sellMarketingFee = 35;
784         uint256 _sellLiquidityFee = 0;
785         uint256 _sellDevFee = 0;
786         
787         uint256 totalSupply = 1000000000000 * 1e18; 
788         
789         maxTransactionAmount = totalSupply * 2 / 100; // 2% maxTransactionAmountTxn
790         maxWallet = totalSupply * 2 / 100; // 2% maxWallet
791         swapTokensAtAmount = totalSupply * 5 / 1000; // 0.5% swap wallet
792 
793         buyMarketingFee = _buyMarketingFee;
794         buyLiquidityFee = _buyLiquidityFee;
795         buyDevFee = _buyDevFee;
796         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
797         
798         sellMarketingFee = _sellMarketingFee;
799         sellLiquidityFee = _sellLiquidityFee;
800         sellDevFee = _sellDevFee;
801         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
802         
803         marketingWallet = address(owner()); // set as marketing wallet
804         devWallet = address(owner()); // set as dev wallet
805 
806         // exclude from paying fees or having max transaction amount
807         excludeFromFees(owner(), true);
808         excludeFromFees(address(this), true);
809         excludeFromFees(address(0xdead), true);
810         
811         excludeFromMaxTransaction(owner(), true);
812         excludeFromMaxTransaction(address(this), true);
813         excludeFromMaxTransaction(address(0xdead), true);
814         
815         _mint(msg.sender, totalSupply);
816     }
817 
818     receive() external payable {
819 
820   	}
821     
822     function setWhitelist(address[] memory whitelist_) public onlyOwner {
823         for (uint256 i = 0; i < whitelist_.length; i++) {
824             whitelist[whitelist_[i]] = true;
825         }
826     }
827 
828     function isWhiteListed(address account) public view returns (bool) {
829         return whitelist[account];
830     }  
831 
832     // once enabled, can never be turned off
833     function openTrading() external onlyOwner {
834         tradingActive = true;
835         swapEnabled = true;
836         lastLpBurnTime = block.timestamp;
837     }
838     
839     // remove limits after token is stable
840     function removealllimits() external onlyOwner returns (bool){
841         limitsInEffect = false;
842         transferDelayEnabled = false;
843         return true;
844     }
845     
846     // change the minimum amount of tokens to sell from fees
847     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner returns (bool){
848   	    require(newAmount <= 1, "Swap amount cannot be higher than 1% total supply.");
849   	    swapTokensAtAmount = totalSupply() * newAmount / 100;
850   	    return true;
851   	}
852     
853     function updateMaxTxnAmount(uint256 txNum, uint256 walNum) external onlyOwner {
854         require(txNum >= 1, "Cannot set maxTransactionAmount lower than 1%");
855         maxTransactionAmount = (totalSupply() * txNum / 100)/1e18;
856         require(walNum >= 1, "Cannot set maxWallet lower than 1%");
857         maxWallet = (totalSupply() * walNum / 100)/1e18;
858     }
859 
860     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
861         _isExcludedMaxTransactionAmount[updAds] = isEx;
862     }
863     
864     // only use to disable contract sales if absolutely necessary (emergency use only)
865     function updateSwapEnabled(bool enabled) external onlyOwner(){
866         swapEnabled = enabled;
867     }
868     
869     function updateBuyFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _devFee) external onlyOwner {
870         buyMarketingFee = _marketingFee;
871         buyLiquidityFee = _liquidityFee;
872         buyDevFee = _devFee;
873         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
874         require(buyTotalFees <= 40, "Must keep fees at 40% or less");
875     }
876     
877     function updateSellFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _devFee) external onlyOwner {
878         sellMarketingFee = _marketingFee;
879         sellLiquidityFee = _liquidityFee;
880         sellDevFee = _devFee;
881         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
882         require(sellTotalFees <= 40, "Must keep fees at 40% or less");
883     }
884 
885     function excludeFromFees(address account, bool excluded) public onlyOwner {
886         _isExcludedFromFees[account] = excluded;
887     }
888 
889     function _setAutomatedMarketMakerPair(address pair, bool value) private {
890         automatedMarketMakerPairs[pair] = value;
891     }
892 
893     function updateMarketingWalletdetails(address newMarketingWallet) external onlyOwner {
894         marketingWallet = newMarketingWallet;
895     }
896     
897     function updateDevWalletdetails(address newWallet) external onlyOwner {
898         devWallet = newWallet;
899     }
900 
901     function isExcludedFromFees(address account) public view returns(bool) {
902         return _isExcludedFromFees[account];
903     }
904 
905     function manageall_bots(address _address, bool status) external onlyOwner {
906         require(_address != address(0),"Address should not be 0");
907         isBlacklisted[_address] = status;
908     }
909 
910     function _transfer(
911         address from,
912         address to,
913         uint256 amount
914     ) internal override {
915         require(from != address(0), "ERC20: transfer from the zero address");
916         require(to != address(0), "ERC20: transfer to the zero address");
917         require(!isBlacklisted[from] && !isBlacklisted[to],"Blacklisted");
918          if(amount == 0) {
919             super._transfer(from, to, 0);
920             return;
921         }
922         
923         if(limitsInEffect){
924             if (
925                 from != owner() &&
926                 to != owner() &&
927                 to != address(0) &&
928                 to != address(0xdead) &&
929                 !swapping
930             ){
931                 if(!tradingActive){
932                     require(whitelist[from] || whitelist[to] || whitelist[msg.sender]);
933                 }
934 
935                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.  
936                 if (transferDelayEnabled){
937                     if (to != owner() && to != address(uniswapV2Router) && to != address(uniswapV2Pair)){
938                         require(_holderLastTransferTimestamp[tx.origin] < block.number, "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed.");
939                         _holderLastTransferTimestamp[tx.origin] = block.number;
940                     }
941                 }
942                  
943                 //when buy
944                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
945                         require(amount <= maxTransactionAmount, "Buy transfer amount exceeds the maxTransactionAmount.");
946                         require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
947                 }
948                 
949                 //when sell
950                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
951                         require(amount <= maxTransactionAmount, "Sell transfer amount exceeds the maxTransactionAmount.");
952                 }
953                 else if(!_isExcludedMaxTransactionAmount[to]){
954                     require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
955                 }
956             }
957         }
958         
959 		uint256 contractTokenBalance = balanceOf(address(this));
960         
961         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
962 
963         if( 
964             canSwap &&
965             swapEnabled &&
966             !swapping &&
967             !automatedMarketMakerPairs[from] &&
968             !_isExcludedFromFees[from] &&
969             !_isExcludedFromFees[to]
970         ) {
971             swapping = true;
972             
973             swapBack();
974 
975             swapping = false;
976         }
977 
978         bool takeFee = !swapping;
979 
980         // if any account belongs to _isExcludedFromFee account then remove the fee
981         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
982             takeFee = false;
983         }
984         
985         uint256 fees = 0;
986         // only take fees on buys/sells, do not take on wallet transfers
987         if(takeFee){
988             // on sell
989             if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
990                 fees = amount * sellTotalFees/100;
991                 tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
992                 tokensForDev += fees * sellDevFee / sellTotalFees;
993                 tokensForMarketing += fees * sellMarketingFee / sellTotalFees;
994             }
995             // on buy
996             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
997         	    fees = amount * buyTotalFees/100;
998         	    tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
999                 tokensForDev += fees * buyDevFee / buyTotalFees;
1000                 tokensForMarketing += fees * buyMarketingFee / buyTotalFees;
1001             }
1002             
1003             if(fees > 0){    
1004                 super._transfer(from, address(this), fees);
1005             }
1006         	
1007         	amount -= fees;
1008         }
1009 
1010         super._transfer(from, to, amount);
1011     }
1012 
1013     function swapTokensForEth(uint256 tokenAmount) private {
1014 
1015         // generate the uniswap pair path of token -> weth
1016         address[] memory path = new address[](2);
1017         path[0] = address(this);
1018         path[1] = uniswapV2Router.WETH();
1019 
1020         _approve(address(this), address(uniswapV2Router), tokenAmount);
1021 
1022         // make the swap
1023         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1024             tokenAmount,
1025             0, // accept any amount of ETH
1026             path,
1027             address(this),
1028             block.timestamp
1029         );
1030         
1031     }
1032     
1033     
1034     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1035         // approve token transfer to cover all possible scenarios
1036         _approve(address(this), address(uniswapV2Router), tokenAmount);
1037 
1038         // add the liquidity
1039         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1040             address(this),
1041             tokenAmount,
1042             0, // slippage is unavoidable
1043             0, // slippage is unavoidable
1044             deadAddress,
1045             block.timestamp
1046         );
1047     }
1048 
1049     function swapBack() private {
1050         uint256 contractBalance = balanceOf(address(this));
1051         uint256 totalTokensToSwap = tokensForLiquidity + tokensForMarketing + tokensForDev;
1052         bool success;
1053         
1054         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
1055 
1056         if(contractBalance > swapTokensAtAmount * 20){
1057           contractBalance = swapTokensAtAmount * 20;
1058         }
1059         
1060         // Halve the amount of liquidity tokens
1061         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
1062         uint256 amountToSwapForETH = contractBalance - liquidityTokens;
1063         
1064         uint256 initialETHBalance = address(this).balance;
1065 
1066         swapTokensForEth(amountToSwapForETH); 
1067         
1068         uint256 ethBalance = address(this).balance - initialETHBalance;
1069         
1070         uint256 ethForMarketing = ethBalance * tokensForMarketing/totalTokensToSwap;
1071         uint256 ethForDev = ethBalance * tokensForDev/totalTokensToSwap;
1072         
1073         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev;
1074         
1075         tokensForLiquidity = 0;
1076         tokensForMarketing = 0;
1077         tokensForDev = 0;
1078         
1079         (success,) = address(devWallet).call{value: ethForDev}("");
1080         
1081         if(liquidityTokens > 0 && ethForLiquidity > 0){
1082             addLiquidity(liquidityTokens, ethForLiquidity);
1083         }
1084         
1085         (success,) = address(marketingWallet).call{value: address(this).balance}("");
1086     }
1087 
1088     function manualBurnLiquidityPairTokens(uint256 percent) external onlyOwner returns (bool){
1089         require(block.timestamp > lastManualLpBurnTime + manualBurnFrequency , "Must wait for cooldown to finish");
1090         require(percent <= 1000, "May not nuke more than 10% of tokens in LP");
1091         lastManualLpBurnTime = block.timestamp;
1092         
1093         // get balance of liquidity pair
1094         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1095         
1096         // calculate amount to burn
1097         uint256 amountToBurn = liquidityPairBalance * percent/10000;
1098         
1099         // pull tokens from pancakePair liquidity and move to dead address permanently
1100         if (amountToBurn > 0){
1101             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1102         }
1103         
1104         //sync price since this is not in a swap transaction!
1105         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1106         pair.sync();
1107         return true;
1108     }
1109 }