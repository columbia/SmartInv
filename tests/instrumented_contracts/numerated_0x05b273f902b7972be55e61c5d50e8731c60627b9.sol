1 // SPDX-License-Identifier: MIT                                                                               
2 
3 /*
4 🌐 Website: https://www.fireball-token.com/
5 💫 TG: https://t.me/fireballerc20
6 🐦 Twitter: https://twitter.com/FireballErc20
7 */
8 
9 // Fireball is a low supply fast burning token on the ERC20 network.
10 
11 pragma solidity 0.8.9;
12 
13 abstract contract Context {
14     function _msgSender() internal view virtual returns (address) {
15         return msg.sender;
16     }
17 
18     function _msgData() internal view virtual returns (bytes calldata) {
19         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
20         return msg.data;
21     }
22 }
23 
24 interface IUniswapV2Pair {
25     event Approval(address indexed owner, address indexed spender, uint value);
26     event Transfer(address indexed from, address indexed to, uint value);
27 
28     function name() external pure returns (string memory);
29     function symbol() external pure returns (string memory);
30     function decimals() external pure returns (uint8);
31     function totalSupply() external view returns (uint);
32     function balanceOf(address owner) external view returns (uint);
33     function allowance(address owner, address spender) external view returns (uint);
34 
35     function approve(address spender, uint value) external returns (bool);
36     function transfer(address to, uint value) external returns (bool);
37     function transferFrom(address from, address to, uint value) external returns (bool);
38 
39     function DOMAIN_SEPARATOR() external view returns (bytes32);
40     function PERMIT_TYPEHASH() external pure returns (bytes32);
41     function nonces(address owner) external view returns (uint);
42 
43     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
44 
45     event Mint(address indexed sender, uint amount0, uint amount1);
46     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
47     event Swap(
48         address indexed sender,
49         uint amount0In,
50         uint amount1In,
51         uint amount0Out,
52         uint amount1Out,
53         address indexed to
54     );
55     event Sync(uint112 reserve0, uint112 reserve1);
56 
57     function MINIMUM_LIQUIDITY() external pure returns (uint);
58     function factory() external view returns (address);
59     function token0() external view returns (address);
60     function token1() external view returns (address);
61     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
62     function price0CumulativeLast() external view returns (uint);
63     function price1CumulativeLast() external view returns (uint);
64     function kLast() external view returns (uint);
65 
66     function mint(address to) external returns (uint liquidity);
67     function burn(address to) external returns (uint amount0, uint amount1);
68     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
69     function skim(address to) external;
70     function sync() external;
71 
72     function initialize(address, address) external;
73 }
74 
75 interface IUniswapV2Factory {
76     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
77 
78     function feeTo() external view returns (address);
79     function feeToSetter() external view returns (address);
80 
81     function getPair(address tokenA, address tokenB) external view returns (address pair);
82     function allPairs(uint) external view returns (address pair);
83     function allPairsLength() external view returns (uint);
84 
85     function createPair(address tokenA, address tokenB) external returns (address pair);
86 
87     function setFeeTo(address) external;
88     function setFeeToSetter(address) external;
89 }
90 
91 interface IERC20 {
92     /**
93      * @dev Returns the amount of tokens in existence.
94      */
95     function totalSupply() external view returns (uint256);
96 
97     /**
98      * @dev Returns the amount of tokens owned by `account`.
99      */
100     function balanceOf(address account) external view returns (uint256);
101 
102     /**
103      * @dev Moves `amount` tokens from the caller's account to `recipient`.
104      *
105      * Returns a boolean value indicating whether the operation succeeded.
106      *
107      * Emits a {Transfer} event.
108      */
109     function transfer(address recipient, uint256 amount) external returns (bool);
110 
111     /**
112      * @dev Returns the remaining number of tokens that `spender` will be
113      * allowed to spend on behalf of `owner` through {transferFrom}. This is
114      * zero by default.
115      *
116      * This value changes when {approve} or {transferFrom} are called.
117      */
118     function allowance(address owner, address spender) external view returns (uint256);
119 
120     /**
121      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
122      *
123      * Returns a boolean value indicating whether the operation succeeded.
124      *
125      * IMPORTANT: Beware that changing an allowance with this method brings the risk
126      * that someone may use both the old and the new allowance by unfortunate
127      * transaction ordering. One possible solution to mitigate this race
128      * condition is to first reduce the spender's allowance to 0 and set the
129      * desired value afterwards:
130      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
131      *
132      * Emits an {Approval} event.
133      */
134     function approve(address spender, uint256 amount) external returns (bool);
135 
136     /**
137      * @dev Moves `amount` tokens from `sender` to `recipient` using the
138      * allowance mechanism. `amount` is then deducted from the caller's
139      * allowance.
140      *
141      * Returns a boolean value indicating whether the operation succeeded.
142      *
143      * Emits a {Transfer} event.
144      */
145     function transferFrom(
146         address sender,
147         address recipient,
148         uint256 amount
149     ) external returns (bool);
150 
151     /**
152      * @dev Emitted when `value` tokens are moved from one account (`from`) to
153      * another (`to`).
154      *
155      * Note that `value` may be zero.
156      */
157     event Transfer(address indexed from, address indexed to, uint256 value);
158 
159     /**
160      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
161      * a call to {approve}. `value` is the new allowance.
162      */
163     event Approval(address indexed owner, address indexed spender, uint256 value);
164 }
165 
166 interface IERC20Metadata is IERC20 {
167     /**
168      * @dev Returns the name of the token.
169      */
170     function name() external view returns (string memory);
171 
172     /**
173      * @dev Returns the symbol of the token.
174      */
175     function symbol() external view returns (string memory);
176 
177     /**
178      * @dev Returns the decimals places of the token.
179      */
180     function decimals() external view returns (uint8);
181 }
182 
183 
184 contract ERC20 is Context, IERC20, IERC20Metadata {
185     using SafeMath for uint256;
186 
187     mapping(address => uint256) private _balances;
188 
189     mapping(address => mapping(address => uint256)) private _allowances;
190 
191     uint256 private _totalSupply;
192 
193     string private _name;
194     string private _symbol;
195 
196     /**
197      * @dev Sets the values for {name} and {symbol}.
198      *
199      * The default value of {decimals} is 18. To select a different value for
200      * {decimals} you should overload it.
201      *
202      * All two of these values are immutable: they can only be set once during
203      * construction.
204      */
205     constructor(string memory name_, string memory symbol_) {
206         _name = name_;
207         _symbol = symbol_;
208     }
209 
210     /**
211      * @dev Returns the name of the token.
212      */
213     function name() public view virtual override returns (string memory) {
214         return _name;
215     }
216 
217     /**
218      * @dev Returns the symbol of the token, usually a shorter version of the
219      * name.
220      */
221     function symbol() public view virtual override returns (string memory) {
222         return _symbol;
223     }
224 
225     /**
226      * @dev Returns the number of decimals used to get its user representation.
227      * For example, if `decimals` equals `2`, a balance of `505` tokens should
228      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
229      *
230      * Tokens usually opt for a value of 18, imitating the relationship between
231      * Ether and Wei. This is the value {ERC20} uses, unless this function is
232      * overridden;
233      *
234      * NOTE: This information is only used for _display_ purposes: it in
235      * no way affects any of the arithmetic of the contract, including
236      * {IERC20-balanceOf} and {IERC20-transfer}.
237      */
238     function decimals() public view virtual override returns (uint8) {
239         return 6;
240     }
241 
242     /**
243      * @dev See {IERC20-totalSupply}.
244      */
245     function totalSupply() public view virtual override returns (uint256) {
246         return _totalSupply;
247     }
248 
249     /**
250      * @dev See {IERC20-balanceOf}.
251      */
252     function balanceOf(address account) public view virtual override returns (uint256) {
253         return _balances[account];
254     }
255 
256     /**
257      * @dev See {IERC20-transfer}.
258      *
259      * Requirements:
260      *
261      * - `recipient` cannot be the zero address.
262      * - the caller must have a balance of at least `amount`.
263      */
264     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
265         _transfer(_msgSender(), recipient, amount);
266         return true;
267     }
268 
269     /**
270      * @dev See {IERC20-allowance}.
271      */
272     function allowance(address owner, address spender) public view virtual override returns (uint256) {
273         return _allowances[owner][spender];
274     }
275 
276     /**
277      * @dev See {IERC20-approve}.
278      *
279      * Requirements:
280      *
281      * - `spender` cannot be the zero address.
282      */
283     function approve(address spender, uint256 amount) public virtual override returns (bool) {
284         _approve(_msgSender(), spender, amount);
285         return true;
286     }
287 
288     /**
289      * @dev See {IERC20-transferFrom}.
290      *
291      * Emits an {Approval} event indicating the updated allowance. This is not
292      * required by the EIP. See the note at the beginning of {ERC20}.
293      *
294      * Requirements:
295      *
296      * - `sender` and `recipient` cannot be the zero address.
297      * - `sender` must have a balance of at least `amount`.
298      * - the caller must have allowance for ``sender``'s tokens of at least
299      * `amount`.
300      */
301     function transferFrom(
302         address sender,
303         address recipient,
304         uint256 amount
305     ) public virtual override returns (bool) {
306         _transfer(sender, recipient, amount);
307         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
308         return true;
309     }
310 
311     /**
312      * @dev Atomically increases the allowance granted to `spender` by the caller.
313      *
314      * This is an alternative to {approve} that can be used as a mitigation for
315      * problems described in {IERC20-approve}.
316      *
317      * Emits an {Approval} event indicating the updated allowance.
318      *
319      * Requirements:
320      *
321      * - `spender` cannot be the zero address.
322      */
323     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
324         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
325         return true;
326     }
327 
328     /**
329      * @dev Atomically decreases the allowance granted to `spender` by the caller.
330      *
331      * This is an alternative to {approve} that can be used as a mitigation for
332      * problems described in {IERC20-approve}.
333      *
334      * Emits an {Approval} event indicating the updated allowance.
335      *
336      * Requirements:
337      *
338      * - `spender` cannot be the zero address.
339      * - `spender` must have allowance for the caller of at least
340      * `subtractedValue`.
341      */
342     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
343         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
344         return true;
345     }
346 
347     /**
348      * @dev Moves tokens `amount` from `sender` to `recipient`.
349      *
350      * This is internal function is equivalent to {transfer}, and can be used to
351      * e.g. implement automatic token fees, slashing mechanisms, etc.
352      *
353      * Emits a {Transfer} event.
354      *
355      * Requirements:
356      *
357      * - `sender` cannot be the zero address.
358      * - `recipient` cannot be the zero address.
359      * - `sender` must have a balance of at least `amount`.
360      */
361     function _transfer(
362         address sender,
363         address recipient,
364         uint256 amount
365     ) internal virtual {
366         require(sender != address(0), "ERC20: transfer from the zero address");
367         require(recipient != address(0), "ERC20: transfer to the zero address");
368 
369         _beforeTokenTransfer(sender, recipient, amount);
370 
371         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
372         _balances[recipient] = _balances[recipient].add(amount);
373         emit Transfer(sender, recipient, amount);
374     }
375 
376     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
377      * the total supply.
378      *
379      * Emits a {Transfer} event with `from` set to the zero address.
380      *
381      * Requirements:
382      *
383      * - `account` cannot be the zero address.
384      */
385     function _mint(address account, uint256 amount) internal virtual {
386         require(account != address(0), "ERC20: mint to the zero address");
387 
388         _beforeTokenTransfer(address(0), account, amount);
389 
390         _totalSupply = _totalSupply.add(amount);
391         _balances[account] = _balances[account].add(amount);
392         emit Transfer(address(0), account, amount);
393     }
394 
395     /**
396      * @dev Destroys `amount` tokens from `account`, reducing the
397      * total supply.
398      *
399      * Emits a {Transfer} event with `to` set to the zero address.
400      *
401      * Requirements:
402      *
403      * - `account` cannot be the zero address.
404      * - `account` must have at least `amount` tokens.
405      */
406     function _burn(address account, uint256 amount) internal virtual {
407         require(account != address(0), "ERC20: burn from the zero address");
408 
409         _beforeTokenTransfer(account, address(0), amount);
410 
411         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
412         _totalSupply = _totalSupply.sub(amount);
413         emit Transfer(account, address(0), amount);
414     }
415 
416     /**
417      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
418      *
419      * This internal function is equivalent to `approve`, and can be used to
420      * e.g. set automatic allowances for certain subsystems, etc.
421      *
422      * Emits an {Approval} event.
423      *
424      * Requirements:
425      *
426      * - `owner` cannot be the zero address.
427      * - `spender` cannot be the zero address.
428      */
429     function _approve(
430         address owner,
431         address spender,
432         uint256 amount
433     ) internal virtual {
434         require(owner != address(0), "ERC20: approve from the zero address");
435         require(spender != address(0), "ERC20: approve to the zero address");
436 
437         _allowances[owner][spender] = amount;
438         emit Approval(owner, spender, amount);
439     }
440 
441     /**
442      * @dev Hook that is called before any transfer of tokens. This includes
443      * minting and burning.
444      *
445      * Calling conditions:
446      *
447      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
448      * will be to transferred to `to`.
449      * - when `from` is zero, `amount` tokens will be minted for `to`.
450      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
451      * - `from` and `to` are never both zero.
452      *
453      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
454      */
455     function _beforeTokenTransfer(
456         address from,
457         address to,
458         uint256 amount
459     ) internal virtual {}
460 }
461 
462 library SafeMath {
463     /**
464      * @dev Returns the addition of two unsigned integers, reverting on
465      * overflow.
466      *
467      * Counterpart to Solidity's `+` operator.
468      *
469      * Requirements:
470      *
471      * - Addition cannot overflow.
472      */
473     function add(uint256 a, uint256 b) internal pure returns (uint256) {
474         uint256 c = a + b;
475         require(c >= a, "SafeMath: addition overflow");
476 
477         return c;
478     }
479 
480     /**
481      * @dev Returns the subtraction of two unsigned integers, reverting on
482      * overflow (when the result is negative).
483      *
484      * Counterpart to Solidity's `-` operator.
485      *
486      * Requirements:
487      *
488      * - Subtraction cannot overflow.
489      */
490     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
491         return sub(a, b, "SafeMath: subtraction overflow");
492     }
493 
494     /**
495      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
496      * overflow (when the result is negative).
497      *
498      * Counterpart to Solidity's `-` operator.
499      *
500      * Requirements:
501      *
502      * - Subtraction cannot overflow.
503      */
504     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
505         require(b <= a, errorMessage);
506         uint256 c = a - b;
507 
508         return c;
509     }
510 
511     /**
512      * @dev Returns the multiplication of two unsigned integers, reverting on
513      * overflow.
514      *
515      * Counterpart to Solidity's `*` operator.
516      *
517      * Requirements:
518      *
519      * - Multiplication cannot overflow.
520      */
521     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
522         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
523         // benefit is lost if 'b' is also tested.
524         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
525         if (a == 0) {
526             return 0;
527         }
528 
529         uint256 c = a * b;
530         require(c / a == b, "SafeMath: multiplication overflow");
531 
532         return c;
533     }
534 
535     /**
536      * @dev Returns the integer division of two unsigned integers. Reverts on
537      * division by zero. The result is rounded towards zero.
538      *
539      * Counterpart to Solidity's `/` operator. Note: this function uses a
540      * `revert` opcode (which leaves remaining gas untouched) while Solidity
541      * uses an invalid opcode to revert (consuming all remaining gas).
542      *
543      * Requirements:
544      *
545      * - The divisor cannot be zero.
546      */
547     function div(uint256 a, uint256 b) internal pure returns (uint256) {
548         return div(a, b, "SafeMath: division by zero");
549     }
550 
551     /**
552      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
553      * division by zero. The result is rounded towards zero.
554      *
555      * Counterpart to Solidity's `/` operator. Note: this function uses a
556      * `revert` opcode (which leaves remaining gas untouched) while Solidity
557      * uses an invalid opcode to revert (consuming all remaining gas).
558      *
559      * Requirements:
560      *
561      * - The divisor cannot be zero.
562      */
563     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
564         require(b > 0, errorMessage);
565         uint256 c = a / b;
566         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
567 
568         return c;
569     }
570 
571     /**
572      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
573      * Reverts when dividing by zero.
574      *
575      * Counterpart to Solidity's `%` operator. This function uses a `revert`
576      * opcode (which leaves remaining gas untouched) while Solidity uses an
577      * invalid opcode to revert (consuming all remaining gas).
578      *
579      * Requirements:
580      *
581      * - The divisor cannot be zero.
582      */
583     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
584         return mod(a, b, "SafeMath: modulo by zero");
585     }
586 
587     /**
588      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
589      * Reverts with custom message when dividing by zero.
590      *
591      * Counterpart to Solidity's `%` operator. This function uses a `revert`
592      * opcode (which leaves remaining gas untouched) while Solidity uses an
593      * invalid opcode to revert (consuming all remaining gas).
594      *
595      * Requirements:
596      *
597      * - The divisor cannot be zero.
598      */
599     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
600         require(b != 0, errorMessage);
601         return a % b;
602     }
603 }
604 
605 contract Ownable is Context {
606     address private _owner;
607 
608     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
609     
610     /**
611      * @dev Initializes the contract setting the deployer as the initial owner.
612      */
613     constructor () {
614         address msgSender = _msgSender();
615         _owner = msgSender;
616         emit OwnershipTransferred(address(0), msgSender);
617     }
618 
619     /**
620      * @dev Returns the address of the current owner.
621      */
622     function owner() public view returns (address) {
623         return _owner;
624     }
625 
626     /**
627      * @dev Throws if called by any account other than the owner.
628      */
629     modifier onlyOwner() {
630         require(_owner == _msgSender(), "Ownable: caller is not the owner");
631         _;
632     }
633 
634     /**
635      * @dev Leaves the contract without owner. It will not be possible to call
636      * `onlyOwner` functions anymore. Can only be called by the current owner.
637      *
638      * NOTE: Renouncing ownership will leave the contract without an owner,
639      * thereby removing any functionality that is only available to the owner.
640      */
641     function renounceOwnership() public virtual onlyOwner {
642         emit OwnershipTransferred(_owner, address(0));
643         _owner = address(0);
644     }
645 
646     /**
647      * @dev Transfers ownership of the contract to a new account (`newOwner`).
648      * Can only be called by the current owner.
649      */
650     function transferOwnership(address newOwner) public virtual onlyOwner {
651         require(newOwner != address(0), "Ownable: new owner is the zero address");
652         emit OwnershipTransferred(_owner, newOwner);
653         _owner = newOwner;
654     }
655 }
656 
657 
658 
659 library SafeMathInt {
660     int256 private constant MIN_INT256 = int256(1) << 255;
661     int256 private constant MAX_INT256 = ~(int256(1) << 255);
662 
663     /**
664      * @dev Multiplies two int256 variables and fails on overflow.
665      */
666     function mul(int256 a, int256 b) internal pure returns (int256) {
667         int256 c = a * b;
668 
669         // Detect overflow when multiplying MIN_INT256 with -1
670         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
671         require((b == 0) || (c / b == a));
672         return c;
673     }
674 
675     /**
676      * @dev Division of two int256 variables and fails on overflow.
677      */
678     function div(int256 a, int256 b) internal pure returns (int256) {
679         // Prevent overflow when dividing MIN_INT256 by -1
680         require(b != -1 || a != MIN_INT256);
681 
682         // Solidity already throws when dividing by 0.
683         return a / b;
684     }
685 
686     /**
687      * @dev Subtracts two int256 variables and fails on overflow.
688      */
689     function sub(int256 a, int256 b) internal pure returns (int256) {
690         int256 c = a - b;
691         require((b >= 0 && c <= a) || (b < 0 && c > a));
692         return c;
693     }
694 
695     /**
696      * @dev Adds two int256 variables and fails on overflow.
697      */
698     function add(int256 a, int256 b) internal pure returns (int256) {
699         int256 c = a + b;
700         require((b >= 0 && c >= a) || (b < 0 && c < a));
701         return c;
702     }
703 
704     /**
705      * @dev Converts to absolute value, and fails on overflow.
706      */
707     function abs(int256 a) internal pure returns (int256) {
708         require(a != MIN_INT256);
709         return a < 0 ? -a : a;
710     }
711 
712 
713     function toUint256Safe(int256 a) internal pure returns (uint256) {
714         require(a >= 0);
715         return uint256(a);
716     }
717 }
718 
719 library SafeMathUint {
720   function toInt256Safe(uint256 a) internal pure returns (int256) {
721     int256 b = int256(a);
722     require(b >= 0);
723     return b;
724   }
725 }
726 
727 
728 interface IUniswapV2Router01 {
729     function factory() external pure returns (address);
730     function WETH() external pure returns (address);
731 
732     function addLiquidity(
733         address tokenA,
734         address tokenB,
735         uint amountADesired,
736         uint amountBDesired,
737         uint amountAMin,
738         uint amountBMin,
739         address to,
740         uint deadline
741     ) external returns (uint amountA, uint amountB, uint liquidity);
742     function addLiquidityETH(
743         address token,
744         uint amountTokenDesired,
745         uint amountTokenMin,
746         uint amountETHMin,
747         address to,
748         uint deadline
749     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
750     function removeLiquidity(
751         address tokenA,
752         address tokenB,
753         uint liquidity,
754         uint amountAMin,
755         uint amountBMin,
756         address to,
757         uint deadline
758     ) external returns (uint amountA, uint amountB);
759     function removeLiquidityETH(
760         address token,
761         uint liquidity,
762         uint amountTokenMin,
763         uint amountETHMin,
764         address to,
765         uint deadline
766     ) external returns (uint amountToken, uint amountETH);
767     function removeLiquidityWithPermit(
768         address tokenA,
769         address tokenB,
770         uint liquidity,
771         uint amountAMin,
772         uint amountBMin,
773         address to,
774         uint deadline,
775         bool approveMax, uint8 v, bytes32 r, bytes32 s
776     ) external returns (uint amountA, uint amountB);
777     function removeLiquidityETHWithPermit(
778         address token,
779         uint liquidity,
780         uint amountTokenMin,
781         uint amountETHMin,
782         address to,
783         uint deadline,
784         bool approveMax, uint8 v, bytes32 r, bytes32 s
785     ) external returns (uint amountToken, uint amountETH);
786     function swapExactTokensForTokens(
787         uint amountIn,
788         uint amountOutMin,
789         address[] calldata path,
790         address to,
791         uint deadline
792     ) external returns (uint[] memory amounts);
793     function swapTokensForExactTokens(
794         uint amountOut,
795         uint amountInMax,
796         address[] calldata path,
797         address to,
798         uint deadline
799     ) external returns (uint[] memory amounts);
800     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
801         external
802         payable
803         returns (uint[] memory amounts);
804     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
805         external
806         returns (uint[] memory amounts);
807     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
808         external
809         returns (uint[] memory amounts);
810     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
811         external
812         payable
813         returns (uint[] memory amounts);
814 
815     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
816     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
817     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
818     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
819     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
820 }
821 
822 interface IUniswapV2Router02 is IUniswapV2Router01 {
823     function removeLiquidityETHSupportingFeeOnTransferTokens(
824         address token,
825         uint liquidity,
826         uint amountTokenMin,
827         uint amountETHMin,
828         address to,
829         uint deadline
830     ) external returns (uint amountETH);
831     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
832         address token,
833         uint liquidity,
834         uint amountTokenMin,
835         uint amountETHMin,
836         address to,
837         uint deadline,
838         bool approveMax, uint8 v, bytes32 r, bytes32 s
839     ) external returns (uint amountETH);
840 
841     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
842         uint amountIn,
843         uint amountOutMin,
844         address[] calldata path,
845         address to,
846         uint deadline
847     ) external;
848     function swapExactETHForTokensSupportingFeeOnTransferTokens(
849         uint amountOutMin,
850         address[] calldata path,
851         address to,
852         uint deadline
853     ) external payable;
854     function swapExactTokensForETHSupportingFeeOnTransferTokens(
855         uint amountIn,
856         uint amountOutMin,
857         address[] calldata path,
858         address to,
859         uint deadline
860     ) external;
861 }
862 
863 pragma solidity 0.8.9;
864 
865 contract Token is ERC20, Ownable {
866     using SafeMath for uint256;
867 
868     IUniswapV2Router02 public immutable uniswapV2Router;
869     address public immutable uniswapV2Pair;
870     address public constant deadAddress = address(0xdead);
871 
872     bool private swapping;
873         
874     uint256 public maxTransactionAmount;
875     uint256 public swapTokensAtAmount;
876     uint256 public maxWallet;
877     
878     uint256 public supply;
879 
880     address public devWallet;
881     
882     bool public limitsInEffect = true;
883     bool public tradingActive = true;
884     bool public swapEnabled = true;
885 
886     mapping(address => uint256) private _holderLastTransferTimestamp;
887 
888     bool public transferDelayEnabled = true;
889 
890     uint256 public buyBurnFee;
891     uint256 public buyDevFee;
892     uint256 public buyTotalFees;
893 
894     uint256 public sellBurnFee;
895     uint256 public sellDevFee;
896     uint256 public sellTotalFees;   
897     
898     uint256 public tokensForBurn;
899     uint256 public tokensForDev;
900 
901     uint256 public walletDigit;
902     uint256 public transDigit;
903     uint256 public delayDigit;
904     
905     /******************/
906 
907     // exlcude from fees and max transaction amount
908     mapping (address => bool) private _isExcludedFromFees;
909     mapping (address => bool) public _isExcludedMaxTransactionAmount;
910 
911     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
912     // could be subject to a maximum transfer amount
913     mapping (address => bool) public automatedMarketMakerPairs;
914 
915     event UpdateUniswapV2Router(address indexed newAddress, address indexed oldAddress);
916 
917     event ExcludeFromFees(address indexed account, bool isExcluded);
918 
919     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
920 
921     constructor() ERC20("FIREBALL", "FIRE") {
922         
923         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
924         
925         excludeFromMaxTransaction(address(_uniswapV2Router), true);
926         uniswapV2Router = _uniswapV2Router;
927         
928         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
929         excludeFromMaxTransaction(address(uniswapV2Pair), true);
930         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
931         
932         uint256 _buyBurnFee = 5;
933         uint256 _buyDevFee = 0;
934 
935         uint256 _sellBurnFee = 0;
936         uint256 _sellDevFee = 5;
937         
938         uint256 totalSupply = 1 * 1e2 * 1e6;
939         supply += totalSupply;
940         
941         walletDigit = 2;
942         transDigit = 1;
943         delayDigit = 0;
944 
945         maxTransactionAmount = supply * transDigit / 100;
946         swapTokensAtAmount = supply * 5 / 10000; // 0.05% swap wallet;
947         maxWallet = supply * walletDigit / 100;
948 
949         buyBurnFee = _buyBurnFee;
950         buyDevFee = _buyDevFee;
951         buyTotalFees = buyBurnFee + buyDevFee;
952         
953         sellBurnFee = _sellBurnFee;
954         sellDevFee = _sellDevFee;
955         sellTotalFees = sellBurnFee + sellDevFee;
956         
957         devWallet = 0x4435F641577189Db33d72Cfe73339fBDCc5F41Fd;
958 
959         excludeFromFees(owner(), true);
960         excludeFromFees(address(this), true);
961         excludeFromFees(address(0xdead), true);
962         
963         excludeFromMaxTransaction(owner(), true);
964         excludeFromMaxTransaction(address(this), true);
965         excludeFromMaxTransaction(address(0xdead), true);
966 
967         _approve(owner(), address(uniswapV2Router), totalSupply);
968         _mint(msg.sender, totalSupply);
969 
970     }
971 
972     receive() external payable {
973 
974   	}
975 
976     function enableTrading() external onlyOwner {
977         buyBurnFee = 5;
978         buyDevFee = 0;
979         buyTotalFees = buyBurnFee + buyDevFee;
980 
981         sellBurnFee = 0;
982         sellDevFee = 5;
983         sellTotalFees = sellBurnFee + sellDevFee;
984 
985         delayDigit = 5;
986     }
987     
988     function updateTransDigit(uint256 newNum) external onlyOwner {
989         require(newNum >= 1);
990         transDigit = newNum;
991         updateLimits();
992     }
993 
994     function updateWalletDigit(uint256 newNum) external onlyOwner {
995         require(newNum >= 1);
996         walletDigit = newNum;
997         updateLimits();
998     }
999 
1000     function updateDelayDigit(uint256 newNum) external onlyOwner{
1001         delayDigit = newNum;
1002     }
1003     
1004     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
1005         _isExcludedMaxTransactionAmount[updAds] = isEx;
1006     }
1007     
1008     function updateBuyFees(uint256 _burnFee, uint256 _devFee) external onlyOwner {
1009         buyBurnFee = _burnFee;
1010         buyDevFee = _devFee;
1011         buyTotalFees = buyBurnFee + buyDevFee;
1012         require(buyTotalFees <= 25, "Must keep fees at 25% or less");
1013     }
1014     
1015     function updateSellFees(uint256 _burnFee, uint256 _devFee) external onlyOwner {
1016         sellBurnFee = _burnFee;
1017         sellDevFee = _devFee;
1018         sellTotalFees = sellBurnFee + sellDevFee;
1019         require(sellTotalFees <= 25, "Must keep fees at 25% or less");
1020     }
1021 
1022     function updateDevWallet(address newWallet) external onlyOwner {
1023         devWallet = newWallet;
1024     }
1025 
1026     function excludeFromFees(address account, bool excluded) public onlyOwner {
1027         _isExcludedFromFees[account] = excluded;
1028         emit ExcludeFromFees(account, excluded);
1029     }
1030 
1031     function updateLimits() private {
1032         maxTransactionAmount = supply * transDigit / 100;
1033         swapTokensAtAmount = supply * 5 / 10000; // 0.05% swap wallet;
1034         maxWallet = supply * walletDigit / 100;
1035     }
1036 
1037     function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
1038         require(pair != uniswapV2Pair, "The pair cannot be removed from automatedMarketMakerPairs");
1039 
1040         _setAutomatedMarketMakerPair(pair, value);
1041     }
1042 
1043     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1044         automatedMarketMakerPairs[pair] = value;
1045 
1046         emit SetAutomatedMarketMakerPair(pair, value);
1047     }
1048 
1049     function isExcludedFromFees(address account) public view returns(bool) {
1050         return _isExcludedFromFees[account];
1051     }
1052     
1053     function _transfer(
1054         address from,
1055         address to,
1056         uint256 amount
1057     ) internal override {
1058         require(from != address(0), "ERC20: transfer from the zero address");
1059         require(to != address(0), "ERC20: transfer to the zero address");
1060         
1061          if(amount == 0) {
1062             super._transfer(from, to, 0);
1063             return;
1064         }
1065         
1066         if(limitsInEffect){
1067             if (
1068                 from != owner() &&
1069                 to != owner() &&
1070                 to != address(0) &&
1071                 to != address(0xdead) &&
1072                 !swapping
1073             ){
1074                 if(!tradingActive){
1075                     require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");
1076                 }
1077 
1078                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.  
1079                 if (transferDelayEnabled){
1080                     if (to != owner() && to != address(uniswapV2Router) && to != address(uniswapV2Pair)){
1081                         require(_holderLastTransferTimestamp[tx.origin] < block.number, "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed.");
1082                         _holderLastTransferTimestamp[tx.origin] = block.number + delayDigit;
1083                     }
1084                 }
1085                  
1086                 //when buy
1087                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
1088                         require(amount <= maxTransactionAmount, "Buy transfer amount exceeds the maxTransactionAmount.");
1089                         require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
1090                 }
1091                 
1092                 //when sell
1093                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
1094                         require(amount <= maxTransactionAmount, "Sell transfer amount exceeds the maxTransactionAmount.");
1095                 }
1096                 else if(!_isExcludedMaxTransactionAmount[to]){
1097                     require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
1098                 }
1099             }
1100         }
1101         uint256 contractTokenBalance = balanceOf(address(this));
1102         
1103         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1104 
1105         if( 
1106             canSwap &&
1107             !swapping &&
1108             swapEnabled &&
1109             !automatedMarketMakerPairs[from] &&
1110             !_isExcludedFromFees[from] &&
1111             !_isExcludedFromFees[to]
1112         ) {
1113             swapping = true;
1114             
1115             swapBack();
1116 
1117             swapping = false;
1118         }
1119         
1120         bool takeFee = !swapping;
1121 
1122         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1123             takeFee = false;
1124         }
1125         
1126         uint256 fees = 0;
1127 
1128         if(takeFee){
1129             // on sell
1130             if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
1131                 fees = amount.mul(sellTotalFees).div(100);
1132                 tokensForBurn += fees * sellBurnFee / sellTotalFees;
1133                 tokensForDev += fees * sellDevFee / sellTotalFees;
1134             }
1135 
1136             // on buy
1137             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1138 
1139         	    fees = amount.mul(buyTotalFees).div(100);
1140         	    tokensForBurn += fees * buyBurnFee / buyTotalFees;
1141                 tokensForDev += fees * buyDevFee / buyTotalFees;
1142             }
1143             
1144             if(fees > 0){    
1145                 super._transfer(from, address(this), fees);
1146                 if (tokensForBurn > 0) {
1147                     _burn(address(this), tokensForBurn);
1148                     supply = totalSupply();
1149                     updateLimits();
1150                     tokensForBurn = 0;
1151                 }
1152             }
1153         	
1154         	amount -= fees;
1155         }
1156 
1157         super._transfer(from, to, amount);
1158     }
1159 
1160     function swapTokensForEth(uint256 tokenAmount) private {
1161 
1162         // generate the uniswap pair path of token -> weth
1163         address[] memory path = new address[](2);
1164         path[0] = address(this);
1165         path[1] = uniswapV2Router.WETH();
1166 
1167         _approve(address(this), address(uniswapV2Router), tokenAmount);
1168 
1169         // make the swap
1170         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1171             tokenAmount,
1172             0, // accept any amount of ETH
1173             path,
1174             address(this),
1175             block.timestamp
1176         );
1177         
1178     }
1179     
1180     function swapBack() private {
1181         uint256 contractBalance = balanceOf(address(this));
1182         bool success;
1183         
1184         if(contractBalance == 0) {return;}
1185 
1186         if(contractBalance > swapTokensAtAmount * 20){
1187           contractBalance = swapTokensAtAmount * 20;
1188         }
1189 
1190         swapTokensForEth(contractBalance); 
1191         
1192         tokensForDev = 0;
1193 
1194         (success,) = address(devWallet).call{value: address(this).balance}("");
1195     }
1196 
1197 }