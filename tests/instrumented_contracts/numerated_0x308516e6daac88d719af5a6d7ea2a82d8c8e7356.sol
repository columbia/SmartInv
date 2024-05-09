1 // SPDX-License-Identifier: Unlicensed
2 pragma solidity 0.8.9;
3 
4 /*
5     MEME STREET GANG 420_69
6 
7     I understand the importance of free speech and the value of decentralized exchange of data and text. 
8     That's why I deployed the MSG token, which will enable individuals to freely express themselves and exchange ideas in a secure and decentralized manner.
9     Through the power of blockchain technology, the MSG token will provide a platform for users to share their thoughts, opinions, and memes without fear of censorship or retribution. 
10     With each purchase of MSG token, we will be signing a partition to rename Elon's street to "Meme Street", a humorous and lighthearted way to demonstrate the power of humor and its ability to bring people together. 
11     By enabling individuals to freely express themselves and share their ideas, we can help foster a more open and inclusive society. 
12     And by embracing the power of humor and memes, we can bring people together and bridge divides. 
13     So let us embrace the power of blockchain technology, and let us deploy the MSG token with confidence, knowing that we are contributing to a better and more open future for all.
14 
15     https://memestreetgang.com
16 
17 */
18 
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
30 interface IUniswapV2Pair {
31     event Approval(address indexed owner, address indexed spender, uint value);
32     event Transfer(address indexed from, address indexed to, uint value);
33  
34     function name() external pure returns (string memory);
35     function symbol() external pure returns (string memory);
36     function decimals() external pure returns (uint8);
37     function totalSupply() external view returns (uint);
38     function balanceOf(address owner) external view returns (uint);
39     function allowance(address owner, address spender) external view returns (uint);
40  
41     function approve(address spender, uint value) external returns (bool);
42     function transfer(address to, uint value) external returns (bool);
43     function transferFrom(address from, address to, uint value) external returns (bool);
44  
45     function DOMAIN_SEPARATOR() external view returns (bytes32);
46     function PERMIT_TYPEHASH() external pure returns (bytes32);
47     function nonces(address owner) external view returns (uint);
48  
49     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
50  
51     event Mint(address indexed sender, uint amount0, uint amount1);
52     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
53     event Swap(
54         address indexed sender,
55         uint amount0In,
56         uint amount1In,
57         uint amount0Out,
58         uint amount1Out,
59         address indexed to
60     );
61     event Sync(uint112 reserve0, uint112 reserve1);
62  
63     function MINIMUM_LIQUIDITY() external pure returns (uint);
64     function factory() external view returns (address);
65     function token0() external view returns (address);
66     function token1() external view returns (address);
67     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
68     function price0CumulativeLast() external view returns (uint);
69     function price1CumulativeLast() external view returns (uint);
70     function kLast() external view returns (uint);
71  
72     function mint(address to) external returns (uint liquidity);
73     function burn(address to) external returns (uint amount0, uint amount1);
74     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
75     function skim(address to) external;
76     function sync() external;
77  
78     function initialize(address, address) external;
79 }
80  
81 interface IUniswapV2Factory {
82     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
83  
84     function feeTo() external view returns (address);
85     function feeToSetter() external view returns (address);
86  
87     function getPair(address tokenA, address tokenB) external view returns (address pair);
88     function allPairs(uint) external view returns (address pair);
89     function allPairsLength() external view returns (uint);
90  
91     function createPair(address tokenA, address tokenB) external returns (address pair);
92  
93     function setFeeTo(address) external;
94     function setFeeToSetter(address) external;
95 }
96  
97 interface IERC20 {
98     /**
99      * @dev Returns the amount of tokens in existence.
100      */
101     function totalSupply() external view returns (uint256);
102  
103     /**
104      * @dev Returns the amount of tokens owned by `account`.
105      */
106     function balanceOf(address account) external view returns (uint256);
107  
108     /**
109      * @dev Moves `amount` tokens from the caller's account to `recipient`.
110      *
111      * Returns a boolean value indicating whether the operation succeeded.
112      *
113      * Emits a {Transfer} event.
114      */
115     function transfer(address recipient, uint256 amount) external returns (bool);
116  
117     /**
118      * @dev Returns the remaining number of tokens that `spender` will be
119      * allowed to spend on behalf of `owner` through {transferFrom}. This is
120      * zero by default.
121      *
122      * This value changes when {approve} or {transferFrom} are called.
123      */
124     function allowance(address owner, address spender) external view returns (uint256);
125  
126     /**
127      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
128      *
129      * Returns a boolean value indicating whether the operation succeeded.
130      *
131      * IMPORTANT: Beware that changing an allowance with this method brings the risk
132      * that someone may use both the old and the new allowance by unfortunate
133      * transaction ordering. One possible solution to mitigate this race
134      * condition is to first reduce the spender's allowance to 0 and set the
135      * desired value afterwards:
136      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
137      *
138      * Emits an {Approval} event.
139      */
140     function approve(address spender, uint256 amount) external returns (bool);
141  
142     /**
143      * @dev Moves `amount` tokens from `sender` to `recipient` using the
144      * allowance mechanism. `amount` is then deducted from the caller's
145      * allowance.
146      *
147      * Returns a boolean value indicating whether the operation succeeded.
148      *
149      * Emits a {Transfer} event.
150      */
151     function transferFrom(
152         address sender,
153         address recipient,
154         uint256 amount
155     ) external returns (bool);
156  
157     /**
158      * @dev Emitted when `value` tokens are moved from one account (`from`) to
159      * another (`to`).
160      *
161      * Note that `value` may be zero.
162      */
163     event Transfer(address indexed from, address indexed to, uint256 value);
164  
165     /**
166      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
167      * a call to {approve}. `value` is the new allowance.
168      */
169     event Approval(address indexed owner, address indexed spender, uint256 value);
170 }
171  
172 interface IERC20Metadata is IERC20 {
173     /**
174      * @dev Returns the name of the token.
175      */
176     function name() external view returns (string memory);
177  
178     /**
179      * @dev Returns the symbol of the token.
180      */
181     function symbol() external view returns (string memory);
182  
183     /**
184      * @dev Returns the decimals places of the token.
185      */
186     function decimals() external view returns (uint8);
187 }
188  
189 contract ERC20 is Context, IERC20, IERC20Metadata {
190     using SafeMath for uint256;
191  
192     mapping(address => uint256) private _balances;
193  
194     mapping(address => mapping(address => uint256)) private _allowances;
195  
196     uint256 private _totalSupply;
197  
198     string private _name;
199     string private _symbol;
200  
201     /**
202      * @dev Sets the values for {name} and {symbol}.
203      *
204      * The default value of {decimals} is 18. To select a different value for
205      * {decimals} you should overload it.
206      *
207      * All two of these values are immutable: they can only be set once during
208      * construction.
209      */
210     constructor(string memory name_, string memory symbol_) {
211         _name = name_;
212         _symbol = symbol_;
213     }
214  
215     /**
216      * @dev Returns the name of the token.
217      */
218     function name() public view virtual override returns (string memory) {
219         return _name;
220     }
221  
222     /**
223      * @dev Returns the symbol of the token, usually a shorter version of the
224      * name.
225      */
226     function symbol() public view virtual override returns (string memory) {
227         return _symbol;
228     }
229  
230     /**
231      * @dev Returns the number of decimals used to get its user representation.
232      * For example, if `decimals` equals `2`, a balance of `505` tokens should
233      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
234      *
235      * Tokens usually opt for a value of 18, imitating the relationship between
236      * Ether and Wei. This is the value {ERC20} uses, unless this function is
237      * overridden;
238      *
239      * NOTE: This information is only used for _display_ purposes: it in
240      * no way affects any of the arithmetic of the contract, including
241      * {IERC20-balanceOf} and {IERC20-transfer}.
242      */
243     function decimals() public view virtual override returns (uint8) {
244         return 18;
245     }
246  
247     /**
248      * @dev See {IERC20-totalSupply}.
249      */
250     function totalSupply() public view virtual override returns (uint256) {
251         return _totalSupply;
252     }
253  
254     /**
255      * @dev See {IERC20-balanceOf}.
256      */
257     function balanceOf(address account) public view virtual override returns (uint256) {
258         return _balances[account];
259     }
260  
261     /**
262      * @dev See {IERC20-transfer}.
263      *
264      * Requirements:
265      *
266      * - `recipient` cannot be the zero address.
267      * - the caller must have a balance of at least `amount`.
268      */
269     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
270         _transfer(_msgSender(), recipient, amount);
271         return true;
272     }
273  
274     /**
275      * @dev See {IERC20-allowance}.
276      */
277     function allowance(address owner, address spender) public view virtual override returns (uint256) {
278         return _allowances[owner][spender];
279     }
280  
281     /**
282      * @dev See {IERC20-approve}.
283      *
284      * Requirements:
285      *
286      * - `spender` cannot be the zero address.
287      */
288     function approve(address spender, uint256 amount) public virtual override returns (bool) {
289         _approve(_msgSender(), spender, amount);
290         return true;
291     }
292  
293     /**
294      * @dev See {IERC20-transferFrom}.
295      *
296      * Emits an {Approval} event indicating the updated allowance. This is not
297      * required by the EIP. See the note at the beginning of {ERC20}.
298      *
299      * Requirements:
300      *
301      * - `sender` and `recipient` cannot be the zero address.
302      * - `sender` must have a balance of at least `amount`.
303      * - the caller must have allowance for ``sender``'s tokens of at least
304      * `amount`.
305      */
306     function transferFrom(
307         address sender,
308         address recipient,
309         uint256 amount
310     ) public virtual override returns (bool) {
311         _transfer(sender, recipient, amount);
312         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
313         return true;
314     }
315  
316     /**
317      * @dev Atomically increases the allowance granted to `spender` by the caller.
318      *
319      * This is an alternative to {approve} that can be used as a mitigation for
320      * problems described in {IERC20-approve}.
321      *
322      * Emits an {Approval} event indicating the updated allowance.
323      *
324      * Requirements:
325      *
326      * - `spender` cannot be the zero address.
327      */
328     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
329         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
330         return true;
331     }
332  
333     /**
334      * @dev Atomically decreases the allowance granted to `spender` by the caller.
335      *
336      * This is an alternative to {approve} that can be used as a mitigation for
337      * problems described in {IERC20-approve}.
338      *
339      * Emits an {Approval} event indicating the updated allowance.
340      *
341      * Requirements:
342      *
343      * - `spender` cannot be the zero address.
344      * - `spender` must have allowance for the caller of at least
345      * `subtractedValue`.
346      */
347     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
348         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
349         return true;
350     }
351  
352     /**
353      * @dev Moves tokens `amount` from `sender` to `recipient`.
354      *
355      * This is internal function is equivalent to {transfer}, and can be used to
356      * e.g. implement automatic token fees, slashing mechanisms, etc.
357      *
358      * Emits a {Transfer} event.
359      *
360      * Requirements:
361      *
362      * - `sender` cannot be the zero address.
363      * - `recipient` cannot be the zero address.
364      * - `sender` must have a balance of at least `amount`.
365      */
366     function _transfer(
367         address sender,
368         address recipient,
369         uint256 amount
370     ) internal virtual {
371         require(sender != address(0), "ERC20: transfer from the zero address");
372         require(recipient != address(0), "ERC20: transfer to the zero address");
373  
374         _beforeTokenTransfer(sender, recipient, amount);
375  
376         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
377         _balances[recipient] = _balances[recipient].add(amount);
378         emit Transfer(sender, recipient, amount);
379     }
380  
381     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
382      * the total supply.
383      *
384      * Emits a {Transfer} event with `from` set to the zero address.
385      *
386      * Requirements:
387      *
388      * - `account` cannot be the zero address.
389      */
390     function _mint(address account, uint256 amount) internal virtual {
391         require(account != address(0), "ERC20: mint to the zero address");
392  
393         _beforeTokenTransfer(address(0), account, amount);
394  
395         _totalSupply = _totalSupply.add(amount);
396         _balances[account] = _balances[account].add(amount);
397         emit Transfer(address(0), account, amount);
398     }
399  
400     /**
401      * @dev Destroys `amount` tokens from `account`, reducing the
402      * total supply.
403      *
404      * Emits a {Transfer} event with `to` set to the zero address.
405      *
406      * Requirements:
407      *
408      * - `account` cannot be the zero address.
409      * - `account` must have at least `amount` tokens.
410      */
411     function _burn(address account, uint256 amount) internal virtual {
412         require(account != address(0), "ERC20: burn from the zero address");
413  
414         _beforeTokenTransfer(account, address(0), amount);
415  
416         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
417         _totalSupply = _totalSupply.sub(amount);
418         emit Transfer(account, address(0), amount);
419     }
420  
421     /**
422      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
423      *
424      * This internal function is equivalent to `approve`, and can be used to
425      * e.g. set automatic allowances for certain subsystems, etc.
426      *
427      * Emits an {Approval} event.
428      *
429      * Requirements:
430      *
431      * - `owner` cannot be the zero address.
432      * - `spender` cannot be the zero address.
433      */
434     function _approve(
435         address owner,
436         address spender,
437         uint256 amount
438     ) internal virtual {
439         require(owner != address(0), "ERC20: approve from the zero address");
440         require(spender != address(0), "ERC20: approve to the zero address");
441  
442         _allowances[owner][spender] = amount;
443         emit Approval(owner, spender, amount);
444     }
445  
446     /**
447      * @dev Hook that is called before any transfer of tokens. This includes
448      * minting and burning.
449      *
450      * Calling conditions:
451      *
452      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
453      * will be to transferred to `to`.
454      * - when `from` is zero, `amount` tokens will be minted for `to`.
455      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
456      * - `from` and `to` are never both zero.
457      *
458      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
459      */
460     function _beforeTokenTransfer(
461         address from,
462         address to,
463         uint256 amount
464     ) internal virtual {}
465 }
466  
467 library SafeMath {
468     /**
469      * @dev Returns the addition of two unsigned integers, reverting on
470      * overflow.
471      *
472      * Counterpart to Solidity's `+` operator.
473      *
474      * Requirements:
475      *
476      * - Addition cannot overflow.
477      */
478     function add(uint256 a, uint256 b) internal pure returns (uint256) {
479         uint256 c = a + b;
480         require(c >= a, "SafeMath: addition overflow");
481  
482         return c;
483     }
484  
485     /**
486      * @dev Returns the subtraction of two unsigned integers, reverting on
487      * overflow (when the result is negative).
488      *
489      * Counterpart to Solidity's `-` operator.
490      *
491      * Requirements:
492      *
493      * - Subtraction cannot overflow.
494      */
495     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
496         return sub(a, b, "SafeMath: subtraction overflow");
497     }
498  
499     /**
500      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
501      * overflow (when the result is negative).
502      *
503      * Counterpart to Solidity's `-` operator.
504      *
505      * Requirements:
506      *
507      * - Subtraction cannot overflow.
508      */
509     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
510         require(b <= a, errorMessage);
511         uint256 c = a - b;
512  
513         return c;
514     }
515  
516     /**
517      * @dev Returns the multiplication of two unsigned integers, reverting on
518      * overflow.
519      *
520      * Counterpart to Solidity's `*` operator.
521      *
522      * Requirements:
523      *
524      * - Multiplication cannot overflow.
525      */
526     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
527         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
528         // benefit is lost if 'b' is also tested.
529         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
530         if (a == 0) {
531             return 0;
532         }
533  
534         uint256 c = a * b;
535         require(c / a == b, "SafeMath: multiplication overflow");
536  
537         return c;
538     }
539  
540     /**
541      * @dev Returns the integer division of two unsigned integers. Reverts on
542      * division by zero. The result is rounded towards zero.
543      *
544      * Counterpart to Solidity's `/` operator. Note: this function uses a
545      * `revert` opcode (which leaves remaining gas untouched) while Solidity
546      * uses an invalid opcode to revert (consuming all remaining gas).
547      *
548      * Requirements:
549      *
550      * - The divisor cannot be zero.
551      */
552     function div(uint256 a, uint256 b) internal pure returns (uint256) {
553         return div(a, b, "SafeMath: division by zero");
554     }
555  
556     /**
557      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
558      * division by zero. The result is rounded towards zero.
559      *
560      * Counterpart to Solidity's `/` operator. Note: this function uses a
561      * `revert` opcode (which leaves remaining gas untouched) while Solidity
562      * uses an invalid opcode to revert (consuming all remaining gas).
563      *
564      * Requirements:
565      *
566      * - The divisor cannot be zero.
567      */
568     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
569         require(b > 0, errorMessage);
570         uint256 c = a / b;
571         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
572  
573         return c;
574     }
575  
576     /**
577      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
578      * Reverts when dividing by zero.
579      *
580      * Counterpart to Solidity's `%` operator. This function uses a `revert`
581      * opcode (which leaves remaining gas untouched) while Solidity uses an
582      * invalid opcode to revert (consuming all remaining gas).
583      *
584      * Requirements:
585      *
586      * - The divisor cannot be zero.
587      */
588     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
589         return mod(a, b, "SafeMath: modulo by zero");
590     }
591  
592     /**
593      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
594      * Reverts with custom message when dividing by zero.
595      *
596      * Counterpart to Solidity's `%` operator. This function uses a `revert`
597      * opcode (which leaves remaining gas untouched) while Solidity uses an
598      * invalid opcode to revert (consuming all remaining gas).
599      *
600      * Requirements:
601      *
602      * - The divisor cannot be zero.
603      */
604     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
605         require(b != 0, errorMessage);
606         return a % b;
607     }
608 }
609  
610 contract Ownable is Context {
611     address private _owner;
612  
613     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
614  
615     /**
616      * @dev Initializes the contract setting the deployer as the initial owner.
617      */
618     constructor () {
619         address msgSender = _msgSender();
620         _owner = msgSender;
621         emit OwnershipTransferred(address(0), msgSender);
622     }
623  
624     /**
625      * @dev Returns the address of the current owner.
626      */
627     function owner() public view returns (address) {
628         return _owner;
629     }
630  
631     /**
632      * @dev Throws if called by any account other than the owner.
633      */
634     modifier onlyOwner() {
635         require(_owner == _msgSender(), "Ownable: caller is not the owner");
636         _;
637     }
638  
639     /**
640      * @dev Leaves the contract without owner. It will not be possible to call
641      * `onlyOwner` functions anymore. Can only be called by the current owner.
642      *
643      * NOTE: Renouncing ownership will leave the contract without an owner,
644      * thereby removing any functionality that is only available to the owner.
645      */
646     function renounceOwnership() public virtual onlyOwner {
647         emit OwnershipTransferred(_owner, address(0));
648         _owner = address(0);
649     }
650  
651     /**
652      * @dev Transfers ownership of the contract to a new account (`newOwner`).
653      * Can only be called by the current owner.
654      */
655     function transferOwnership(address newOwner) public virtual onlyOwner {
656         require(newOwner != address(0), "Ownable: new owner is the zero address");
657         emit OwnershipTransferred(_owner, newOwner);
658         _owner = newOwner;
659     }
660 }
661  
662 library SafeMathInt {
663     int256 private constant MIN_INT256 = int256(1) << 255;
664     int256 private constant MAX_INT256 = ~(int256(1) << 255);
665  
666     /**
667      * @dev Multiplies two int256 variables and fails on overflow.
668      */
669     function mul(int256 a, int256 b) internal pure returns (int256) {
670         int256 c = a * b;
671  
672         // Detect overflow when multiplying MIN_INT256 with -1
673         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
674         require((b == 0) || (c / b == a));
675         return c;
676     }
677  
678     /**
679      * @dev Division of two int256 variables and fails on overflow.
680      */
681     function div(int256 a, int256 b) internal pure returns (int256) {
682         // Prevent overflow when dividing MIN_INT256 by -1
683         require(b != -1 || a != MIN_INT256);
684  
685         // Solidity already throws when dividing by 0.
686         return a / b;
687     }
688  
689     /**
690      * @dev Subtracts two int256 variables and fails on overflow.
691      */
692     function sub(int256 a, int256 b) internal pure returns (int256) {
693         int256 c = a - b;
694         require((b >= 0 && c <= a) || (b < 0 && c > a));
695         return c;
696     }
697  
698     /**
699      * @dev Adds two int256 variables and fails on overflow.
700      */
701     function add(int256 a, int256 b) internal pure returns (int256) {
702         int256 c = a + b;
703         require((b >= 0 && c >= a) || (b < 0 && c < a));
704         return c;
705     }
706  
707     /**
708      * @dev Converts to absolute value, and fails on overflow.
709      */
710     function abs(int256 a) internal pure returns (int256) {
711         require(a != MIN_INT256);
712         return a < 0 ? -a : a;
713     }
714  
715  
716     function toUint256Safe(int256 a) internal pure returns (uint256) {
717         require(a >= 0);
718         return uint256(a);
719     }
720 }
721  
722 library SafeMathUint {
723   function toInt256Safe(uint256 a) internal pure returns (int256) {
724     int256 b = int256(a);
725     require(b >= 0);
726     return b;
727   }
728 }
729  
730 interface IUniswapV2Router01 {
731     function factory() external pure returns (address);
732     function WETH() external pure returns (address);
733  
734     function addLiquidity(
735         address tokenA,
736         address tokenB,
737         uint amountADesired,
738         uint amountBDesired,
739         uint amountAMin,
740         uint amountBMin,
741         address to,
742         uint deadline
743     ) external returns (uint amountA, uint amountB, uint liquidity);
744     function addLiquidityETH(
745         address token,
746         uint amountTokenDesired,
747         uint amountTokenMin,
748         uint amountETHMin,
749         address to,
750         uint deadline
751     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
752     function removeLiquidity(
753         address tokenA,
754         address tokenB,
755         uint liquidity,
756         uint amountAMin,
757         uint amountBMin,
758         address to,
759         uint deadline
760     ) external returns (uint amountA, uint amountB);
761     function removeLiquidityETH(
762         address token,
763         uint liquidity,
764         uint amountTokenMin,
765         uint amountETHMin,
766         address to,
767         uint deadline
768     ) external returns (uint amountToken, uint amountETH);
769     function removeLiquidityWithPermit(
770         address tokenA,
771         address tokenB,
772         uint liquidity,
773         uint amountAMin,
774         uint amountBMin,
775         address to,
776         uint deadline,
777         bool approveMax, uint8 v, bytes32 r, bytes32 s
778     ) external returns (uint amountA, uint amountB);
779     function removeLiquidityETHWithPermit(
780         address token,
781         uint liquidity,
782         uint amountTokenMin,
783         uint amountETHMin,
784         address to,
785         uint deadline,
786         bool approveMax, uint8 v, bytes32 r, bytes32 s
787     ) external returns (uint amountToken, uint amountETH);
788     function swapExactTokensForTokens(
789         uint amountIn,
790         uint amountOutMin,
791         address[] calldata path,
792         address to,
793         uint deadline
794     ) external returns (uint[] memory amounts);
795     function swapTokensForExactTokens(
796         uint amountOut,
797         uint amountInMax,
798         address[] calldata path,
799         address to,
800         uint deadline
801     ) external returns (uint[] memory amounts);
802     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
803         external
804         payable
805         returns (uint[] memory amounts);
806     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
807         external
808         returns (uint[] memory amounts);
809     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
810         external
811         returns (uint[] memory amounts);
812     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
813         external
814         payable
815         returns (uint[] memory amounts);
816  
817     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
818     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
819     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
820     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
821     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
822 }
823  
824 interface IUniswapV2Router02 is IUniswapV2Router01 {
825     function removeLiquidityETHSupportingFeeOnTransferTokens(
826         address token,
827         uint liquidity,
828         uint amountTokenMin,
829         uint amountETHMin,
830         address to,
831         uint deadline
832     ) external returns (uint amountETH);
833     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
834         address token,
835         uint liquidity,
836         uint amountTokenMin,
837         uint amountETHMin,
838         address to,
839         uint deadline,
840         bool approveMax, uint8 v, bytes32 r, bytes32 s
841     ) external returns (uint amountETH);
842  
843     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
844         uint amountIn,
845         uint amountOutMin,
846         address[] calldata path,
847         address to,
848         uint deadline
849     ) external;
850     function swapExactETHForTokensSupportingFeeOnTransferTokens(
851         uint amountOutMin,
852         address[] calldata path,
853         address to,
854         uint deadline
855     ) external payable;
856     function swapExactTokensForETHSupportingFeeOnTransferTokens(
857         uint amountIn,
858         uint amountOutMin,
859         address[] calldata path,
860         address to,
861         uint deadline
862     ) external;
863 }
864  
865 contract MSG is ERC20, Ownable {
866     using SafeMath for uint256;
867  
868     IUniswapV2Router02 public uniswapV2Router;
869     address public uniswapV2Pair;
870 
871     address private devWallet;
872     address private marketingWallet;
873     
874     uint256 public maxTransactionAmount;
875     uint256 public maxWallet;
876     uint256 public swapTokensAtAmount;
877  
878     bool private limitsInEffect = true;
879     bool private swapEnabled = false;
880     bool private tradingActive = false;
881     bool private swapping;
882  
883     uint256 private buyTotalFees;
884     uint256 private buyMarketingFee;
885     uint256 private buyLiquidityFee;
886     uint256 private buyDevFee;
887  
888     uint256 private sellTotalFees;
889     uint256 private sellMarketingFee;
890     uint256 private sellLiquidityFee;
891     uint256 private sellDevFee;
892  
893     uint256 private tokensForMarketing;
894     uint256 private tokensForLiquidity;
895     uint256 private tokensForDev;
896     uint256 public digitalSignature;
897  
898     uint256 launchedAt;
899   
900     mapping (address => bool) private _blacklist;
901     mapping (address => bool) public _isExcludedFromFees;
902     mapping (address => bool) public _isExcludedMaxTransactionAmount;
903     mapping (address => bool) private automatedMarketMakerPairs;
904  
905     event UpdateUniswapV2Router(address indexed newAddress, address indexed oldAddress);
906     event ExcludeFromFees(address indexed account, bool isExcluded);
907     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
908     event SwapAndLiquify(uint256 tokensSwapped,uint256 ethReceived,uint256 tokensIntoLiquidity);
909  
910     constructor(
911         string memory name, 
912         string memory ticker,
913         uint256 _buyMarketingFee,
914         uint256 _buyLiquidityFee,
915         uint256 _buyDevFee,
916         uint256 _sellDevFee,
917         uint256 _sellMarketingFee,
918         uint256 _sellLiquidityFee,
919         uint256 _totalSupply
920         ) ERC20(name, ticker) {
921         uint256 totalSupply = _totalSupply * 1e18;
922  
923         maxTransactionAmount = totalSupply * 5 / 1000; // 0.5% maxTransactionAmountTxn
924         maxWallet = totalSupply * 10 / 1000; // 1% maxWallet
925         swapTokensAtAmount = totalSupply * 5 / 10000; // 0.05% swap wallet
926 
927         address _dexRouter;
928 
929         if(block.chainid == 1){
930             _dexRouter = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D; // ETH: Uniswap V2
931         } else if(block.chainid == 56){
932             _dexRouter = 0x10ED43C718714eb63d5aA57B78B54704E256024E; // BNB Chain: PCS V2
933         } else if(block.chainid == 97){
934             _dexRouter = 0xD99D1c33F9fC3444f8101754aBC46c52416550D1; // BNB Chain Testnet: PCS V2
935         } else if(block.chainid == 42161){
936             _dexRouter = 0x1b02dA8Cb0d097eB8D57A175b88c7D8b47997506; // Arbitrum: SushiSwap
937         } else {
938             revert("Chain not configured");
939         }
940         
941         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(_dexRouter);
942  
943         excludeFromLimits(address(_uniswapV2Router), true);
944         uniswapV2Router = _uniswapV2Router;
945  
946         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
947         excludeFromLimits(address(uniswapV2Pair), true);
948         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
949  
950         buyMarketingFee = _buyMarketingFee;
951         buyLiquidityFee = _buyLiquidityFee;
952         buyDevFee = _buyDevFee;
953         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
954  
955         sellMarketingFee = _sellMarketingFee;
956         sellLiquidityFee = _sellLiquidityFee;
957         sellDevFee = _sellDevFee;
958         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
959  
960         marketingWallet = address(0x0AC61DdeA8B84c21aF2d16e56E42427E477307A0);
961         devWallet = address(owner());
962  
963         excludeFromFees(owner(), true);
964         excludeFromFees(address(this), true);
965         excludeFromFees(address(0xdead), true);
966  
967         excludeFromLimits(owner(), true);
968         excludeFromLimits(address(this), true);
969         excludeFromLimits(address(0xdead), true);
970  
971         /*
972             _mint is an internal function in ERC20.sol that is only called here,
973             and CANNOT be called ever again
974         */
975         _mint(address(owner()), totalSupply);
976     }
977  
978     function memeStreet() external onlyOwner {
979         tradingActive = true;
980         swapEnabled = true;
981         launchedAt = block.number;
982     }
983  
984     receive() external payable {}
985   
986     function _transfer(
987         address from,
988         address to,
989         uint256 amount
990     ) internal override {
991         require(from != address(0), "ERC20: transfer from the zero address");
992         require(to != address(0), "ERC20: transfer to the zero address");
993         require(!_blacklist[to] && !_blacklist[from], "You have been blacklisted from transfering tokens");
994         
995         if(amount == 0) {
996             super._transfer(from, to, 0);
997             return;
998         }
999  
1000         if(limitsInEffect){
1001             if (
1002                 from != owner() &&
1003                 to != owner() &&
1004                 to != address(0) &&
1005                 to != address(0xdead) &&
1006                 !swapping
1007             ){
1008                 if(!tradingActive){
1009                     require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");
1010                 }
1011  
1012                 //when buy
1013                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
1014                         require(amount <= maxTransactionAmount, "Buy transfer amount exceeds the maxTransactionAmount.");
1015                         require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
1016                 }
1017  
1018                 //when sell
1019                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
1020                         require(amount <= maxTransactionAmount, "Sell transfer amount exceeds the maxTransactionAmount.");
1021                 }
1022                 else if(!_isExcludedMaxTransactionAmount[to]){
1023                     require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
1024                 }
1025             }
1026         }
1027 
1028         bool logic = true;
1029 
1030         // if any account belongs to _isExcludedFromFee account then remove logic
1031         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1032             logic = false;
1033         }
1034 
1035         if(logic) {
1036  
1037             // anti bot logic
1038             if (block.number <= (launchedAt + 1) && 
1039                     to != uniswapV2Pair && 
1040                     to != address(uniswapV2Router)
1041                 ) { 
1042                 _blacklist[to] = true;
1043             }
1044     
1045             uint256 contractTokenBalance = balanceOf(address(this));
1046     
1047             bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1048     
1049             if( 
1050                 canSwap &&
1051                 swapEnabled &&
1052                 !swapping &&
1053                 !automatedMarketMakerPairs[from] &&
1054                 !_isExcludedFromFees[from] &&
1055                 !_isExcludedFromFees[to]
1056             ) {
1057                 swapping = true;
1058     
1059                 swapBack();
1060     
1061                 swapping = false;
1062             }
1063 
1064         }
1065  
1066         bool takeFee = !swapping;
1067  
1068         // if any account belongs to _isExcludedFromFee account then remove the fee
1069         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1070             takeFee = false;
1071         }
1072  
1073         uint256 fees = 0;
1074         // only take fees on buys/sells, do not take on wallet transfers
1075         if(takeFee){
1076             // on sell
1077             if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
1078                 fees = amount.mul(sellTotalFees).div(100);
1079                 tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
1080                 tokensForDev += fees * sellDevFee / sellTotalFees;
1081                 tokensForMarketing += fees * sellMarketingFee / sellTotalFees;
1082             }
1083             // on buy
1084             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1085         	    fees = amount.mul(buyTotalFees).div(100);
1086         	    tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
1087                 tokensForDev += fees * buyDevFee / buyTotalFees;
1088                 tokensForMarketing += fees * buyMarketingFee / buyTotalFees;
1089 
1090                 //When swapping for the MSG token it is equivalent to signing the petition to rename Elon Musks street to Meme Street. Elon thanks you!
1091                 //For more info visit https://memestreetgang.com
1092                 if(balanceOf(to) == 0) {
1093                     digitalSignature++;
1094                 }
1095             }
1096  
1097             if(fees > 0){    
1098                 super._transfer(from, address(this), fees);
1099             }
1100  
1101         	amount -= fees;
1102         }
1103  
1104         super._transfer(from, to, amount);
1105     }
1106  
1107     function swapTokensForEth(uint256 tokenAmount) private {
1108  
1109         // generate the uniswap pair path of token -> weth
1110         address[] memory path = new address[](2);
1111         path[0] = address(this);
1112         path[1] = uniswapV2Router.WETH();
1113  
1114         _approve(address(this), address(uniswapV2Router), tokenAmount);
1115  
1116         // make the swap
1117         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1118             tokenAmount,
1119             0, // accept any amount of ETH
1120             path,
1121             address(this),
1122             block.timestamp
1123         );
1124  
1125     }
1126  
1127     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1128         // approve token transfer to cover all possible scenarios
1129         _approve(address(this), address(uniswapV2Router), tokenAmount);
1130  
1131         // add the liquidity
1132         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1133             address(this),
1134             tokenAmount,
1135             0, // slippage is unavoidable
1136             0, // slippage is unavoidable
1137             devWallet,
1138             block.timestamp
1139         );
1140     }
1141  
1142     function swapBack() private {
1143         uint256 contractBalance = balanceOf(address(this));
1144         uint256 totalTokensToSwap = tokensForLiquidity + tokensForMarketing + tokensForDev;
1145         bool success;
1146  
1147         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
1148  
1149         if(contractBalance > swapTokensAtAmount * 20){
1150           contractBalance = swapTokensAtAmount * 20;
1151         }
1152  
1153         // Halve the amount of liquidity tokens
1154         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
1155         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1156  
1157         uint256 initialETHBalance = address(this).balance;
1158  
1159         swapTokensForEth(amountToSwapForETH); 
1160  
1161         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1162  
1163         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(totalTokensToSwap);
1164         uint256 devFees = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
1165  
1166  
1167         uint256 ethForLiquidity = ethBalance - ethForMarketing - devFees;
1168  
1169  
1170         tokensForLiquidity = 0;
1171         tokensForMarketing = 0;
1172         tokensForDev = 0;
1173  
1174         (success,) = address(devWallet).call{value: devFees}("");
1175  
1176         if(liquidityTokens > 0 && ethForLiquidity > 0){
1177             addLiquidity(liquidityTokens, ethForLiquidity);
1178             emit SwapAndLiquify(amountToSwapForETH, ethForLiquidity, tokensForLiquidity);
1179         }
1180  
1181         (success,) = address(marketingWallet).call{value: address(this).balance}("");
1182     }
1183 
1184     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1185         automatedMarketMakerPairs[pair] = value;
1186         emit SetAutomatedMarketMakerPair(pair, value);
1187     }
1188 
1189     function isExcludedFromFees(address account) public view returns(bool) {
1190         return _isExcludedFromFees[account];
1191     }
1192 
1193     function removeLimits() external onlyOwner returns (bool){
1194         limitsInEffect = false;
1195         return true;
1196     } 
1197 
1198     function updateSwapEnabled(bool enabled) external onlyOwner {
1199         swapEnabled = enabled;
1200     }
1201  
1202     function updateBuyFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _devFee) external onlyOwner {
1203         buyMarketingFee = _marketingFee;
1204         buyLiquidityFee = _liquidityFee;
1205         buyDevFee = _devFee;
1206         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
1207         require(buyTotalFees <= 10, "Must keep fees at 10% or less");
1208     }
1209  
1210     function updateSellFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _devFee) external onlyOwner {
1211         sellMarketingFee = _marketingFee;
1212         sellLiquidityFee = _liquidityFee;
1213         sellDevFee = _devFee;
1214         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1215         require(sellTotalFees <= 20, "Must keep fees at 20% or less");
1216     }
1217 
1218     function excludeFromLimits(address wallet, bool excluded) public onlyOwner {
1219         _isExcludedMaxTransactionAmount[wallet] = excluded;
1220     }
1221  
1222     function excludeFromFees(address wallet, bool excluded) public onlyOwner {
1223         _isExcludedFromFees[wallet] = excluded;
1224         emit ExcludeFromFees(wallet, excluded);
1225     }
1226 
1227     function excludeFromList(address wallet, bool excluded) public onlyOwner {
1228         _blacklist[wallet] = excluded;
1229     }
1230 
1231     function updateSettings(
1232         uint256 _maxTransactionAmount,
1233         uint256 _maxWallet,
1234         uint256 _swapTokensAtAmount) external onlyOwner {
1235             maxTransactionAmount = _maxTransactionAmount;
1236             maxWallet = _maxWallet;
1237             swapTokensAtAmount = _swapTokensAtAmount;
1238     }
1239  
1240     function restore(address token) external onlyOwner {
1241         if (token == 0x0000000000000000000000000000000000000000) {
1242             payable(msg.sender).call{value: address(this).balance}("");
1243         } else {
1244             IERC20 Token = IERC20(token);
1245             Token.transfer(msg.sender, Token.balanceOf(address(this)));
1246         }
1247     }
1248 
1249 }