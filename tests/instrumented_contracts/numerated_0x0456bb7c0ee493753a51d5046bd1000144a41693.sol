1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.8.9;
4  
5 abstract contract Context {
6     function _msgSender() internal view virtual returns (address) {
7         return msg.sender;
8     }
9  
10     function _msgData() internal view virtual returns (bytes calldata) {
11         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
12         return msg.data;
13     }
14 }
15  
16 interface IUniswapV2Pair {
17     event Approval(address indexed owner, address indexed spender, uint value);
18     event Transfer(address indexed from, address indexed to, uint value);
19  
20     function name() external pure returns (string memory);
21     function symbol() external pure returns (string memory);
22     function decimals() external pure returns (uint8);
23     function totalSupply() external view returns (uint);
24     function balanceOf(address owner) external view returns (uint);
25     function allowance(address owner, address spender) external view returns (uint);
26  
27     function approve(address spender, uint value) external returns (bool);
28     function transfer(address to, uint value) external returns (bool);
29     function transferFrom(address from, address to, uint value) external returns (bool);
30  
31     function DOMAIN_SEPARATOR() external view returns (bytes32);
32     function PERMIT_TYPEHASH() external pure returns (bytes32);
33     function nonces(address owner) external view returns (uint);
34  
35     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
36  
37     event Mint(address indexed sender, uint amount0, uint amount1);
38     event Swap(
39         address indexed sender,
40         uint amount0In,
41         uint amount1In,
42         uint amount0Out,
43         uint amount1Out,
44         address indexed to
45     );
46     event Sync(uint112 reserve0, uint112 reserve1);
47  
48     function MINIMUM_LIQUIDITY() external pure returns (uint);
49     function factory() external view returns (address);
50     function token0() external view returns (address);
51     function token1() external view returns (address);
52     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
53     function price0CumulativeLast() external view returns (uint);
54     function price1CumulativeLast() external view returns (uint);
55     function kLast() external view returns (uint);
56  
57     function mint(address to) external returns (uint liquidity);
58     function burn(address to) external returns (uint amount0, uint amount1);
59     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
60     function skim(address to) external;
61     function sync() external;
62  
63     function initialize(address, address) external;
64 }
65  
66 interface IUniswapV2Factory {
67     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
68  
69     function feeTo() external view returns (address);
70     function feeToSetter() external view returns (address);
71  
72     function getPair(address tokenA, address tokenB) external view returns (address pair);
73     function allPairs(uint) external view returns (address pair);
74     function allPairsLength() external view returns (uint);
75  
76     function createPair(address tokenA, address tokenB) external returns (address pair);
77  
78     function setFeeTo(address) external;
79     function setFeeToSetter(address) external;
80 }
81  
82 interface IERC20 {
83     /**
84      * @dev Returns the amount of tokens in existence.
85      */
86     function totalSupply() external view returns (uint256);
87  
88     /**
89      * @dev Returns the amount of tokens owned by `account`.
90      */
91     function balanceOf(address account) external view returns (uint256);
92  
93     /**
94      * @dev Moves `amount` tokens from the caller's account to `recipient`.
95      *
96      * Returns a boolean value indicating whether the operation succeeded.
97      *
98      * Emits a {Transfer} event.
99      */
100     function transfer(address recipient, uint256 amount) external returns (bool);
101  
102     /**
103      * @dev Returns the remaining number of tokens that `spender` will be
104      * allowed to spend on behalf of `owner` through {transferFrom}. This is
105      * zero by default.
106      *
107      * This value changes when {approve} or {transferFrom} are called.
108      */
109     function allowance(address owner, address spender) external view returns (uint256);
110  
111     /**
112      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
113      *
114      * Returns a boolean value indicating whether the operation succeeded.
115      *
116      * IMPORTANT: Beware that changing an allowance with this method brings the risk
117      * that someone may use both the old and the new allowance by unfortunate
118      * transaction ordering. One possible solution to mitigate this race
119      * condition is to first reduce the spender's allowance to 0 and set the
120      * desired value afterwards:
121      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
122      *
123      * Emits an {Approval} event.
124      */
125     function approve(address spender, uint256 amount) external returns (bool);
126  
127     /**
128      * @dev Moves `amount` tokens from `sender` to `recipient` using the
129      * allowance mechanism. `amount` is then deducted from the caller's
130      * allowance.
131      *
132      * Returns a boolean value indicating whether the operation succeeded.
133      *
134      * Emits a {Transfer} event.
135      */
136     function transferFrom(
137         address sender,
138         address recipient,
139         uint256 amount
140     ) external returns (bool);
141  
142     /**
143      * @dev Emitted when `value` tokens are moved from one account (`from`) to
144      * another (`to`).
145      *
146      * Note that `value` may be zero.
147      */
148     event Transfer(address indexed from, address indexed to, uint256 value);
149  
150     /**
151      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
152      * a call to {approve}. `value` is the new allowance.
153      */
154     event Approval(address indexed owner, address indexed spender, uint256 value);
155 }
156  
157 interface IERC20Metadata is IERC20 {
158     /**
159      * @dev Returns the name of the token.
160      */
161     function name() external view returns (string memory);
162  
163     /**
164      * @dev Returns the symbol of the token.
165      */
166     function symbol() external view returns (string memory);
167  
168     /**
169      * @dev Returns the decimals places of the token.
170      */
171     function decimals() external view returns (uint8);
172 }
173  
174  
175 contract ERC20 is Context, IERC20, IERC20Metadata {
176     using SafeMath for uint256;
177  
178     mapping(address => uint256) private _balances;
179  
180     mapping(address => mapping(address => uint256)) private _allowances;
181  
182     uint256 private _totalSupply;
183  
184     string private _name;
185     string private _symbol;
186  
187     /**
188      * @dev Sets the values for {name} and {symbol}.
189      *
190      * The default value of {decimals} is 18. To select a different value for
191      * {decimals} you should overload it.
192      *
193      * All two of these values are immutable: they can only be set once during
194      * construction.
195      */
196     constructor(string memory name_, string memory symbol_) {
197         _name = name_;
198         _symbol = symbol_;
199     }
200  
201     /**
202      * @dev Returns the name of the token.
203      */
204     function name() public view virtual override returns (string memory) {
205         return _name;
206     }
207  
208     /**
209      * @dev Returns the symbol of the token, usually a shorter version of the
210      * name.
211      */
212     function symbol() public view virtual override returns (string memory) {
213         return _symbol;
214     }
215  
216     function decimals() public view virtual override returns (uint8) {
217         return 18;
218     }
219  
220     /**
221      * @dev See {IERC20-totalSupply}.
222      */
223     function totalSupply() public view virtual override returns (uint256) {
224         return _totalSupply;
225     }
226  
227     /**
228      * @dev See {IERC20-balanceOf}.
229      */
230     function balanceOf(address account) public view virtual override returns (uint256) {
231         return _balances[account];
232     }
233  
234     /**
235      * @dev See {IERC20-transfer}.
236      *
237      * Requirements:
238      *
239      * - `recipient` cannot be the zero address.
240      * - the caller must have a balance of at least `amount`.
241      */
242     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
243         _transfer(_msgSender(), recipient, amount);
244         return true;
245     }
246  
247     /**
248      * @dev See {IERC20-allowance}.
249      */
250     function allowance(address owner, address spender) public view virtual override returns (uint256) {
251         return _allowances[owner][spender];
252     }
253  
254     /**
255      * @dev See {IERC20-approve}.
256      *
257      * Requirements:
258      *
259      * - `spender` cannot be the zero address.
260      */
261     function approve(address spender, uint256 amount) public virtual override returns (bool) {
262         _approve(_msgSender(), spender, amount);
263         return true;
264     }
265  
266     /**
267      * @dev See {IERC20-transferFrom}.
268      *
269      * Emits an {Approval} event indicating the updated allowance. This is not
270      * required by the EIP. See the note at the beginning of {ERC20}.
271      *
272      * Requirements:
273      *
274      * - `sender` and `recipient` cannot be the zero address.
275      * - `sender` must have a balance of at least `amount`.
276      * - the caller must have allowance for ``sender``'s tokens of at least
277      * `amount`.
278      */
279     function transferFrom(
280         address sender,
281         address recipient,
282         uint256 amount
283     ) public virtual override returns (bool) {
284         _transfer(sender, recipient, amount);
285         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
286         return true;
287     }
288  
289     /**
290      * @dev Atomically increases the allowance granted to `spender` by the caller.
291      *
292      * This is an alternative to {approve} that can be used as a mitigation for
293      * problems described in {IERC20-approve}.
294      *
295      * Emits an {Approval} event indicating the updated allowance.
296      *
297      * Requirements:
298      *
299      * - `spender` cannot be the zero address.
300      */
301     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
302         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
303         return true;
304     }
305  
306     /**
307      * @dev Atomically decreases the allowance granted to `spender` by the caller.
308      *
309      * This is an alternative to {approve} that can be used as a mitigation for
310      * problems described in {IERC20-approve}.
311      *
312      * Emits an {Approval} event indicating the updated allowance.
313      *
314      * Requirements:
315      *
316      * - `spender` cannot be the zero address.
317      * - `spender` must have allowance for the caller of at least
318      * `subtractedValue`.
319      */
320     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
321         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
322         return true;
323     }
324  
325     /**
326      * @dev Moves tokens `amount` from `sender` to `recipient`.
327      *
328      * This is internal function is equivalent to {transfer}, and can be used to
329      * e.g. implement automatic token fees, slashing mechanisms, etc.
330      *
331      * Emits a {Transfer} event.
332      *
333      * Requirements:
334      *
335      * - `sender` cannot be the zero address.
336      * - `recipient` cannot be the zero address.
337      * - `sender` must have a balance of at least `amount`.
338      */
339     function _transfer(
340         address sender,
341         address recipient,
342         uint256 amount
343     ) internal virtual {
344         require(sender != address(0), "ERC20: transfer from the zero address");
345         require(recipient != address(0), "ERC20: transfer to the zero address");
346  
347         _beforeTokenTransfer(sender, recipient, amount);
348  
349         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
350         _balances[recipient] = _balances[recipient].add(amount);
351         emit Transfer(sender, recipient, amount);
352     }
353  
354     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
355      * the total supply.
356      *
357      * Emits a {Transfer} event with `from` set to the zero address.
358      *
359      * Requirements:
360      *
361      * - `account` cannot be the zero address.
362      */
363     function _mint(address account, uint256 amount) internal virtual {
364         require(account != address(0), "ERC20: mint to the zero address");
365  
366         _beforeTokenTransfer(address(0), account, amount);
367  
368         _totalSupply = _totalSupply.add(amount);
369         _balances[account] = _balances[account].add(amount);
370         emit Transfer(address(0), account, amount);
371     }
372  
373     /**
374      * @dev Destroys `amount` tokens from `account`, reducing the
375      * total supply.
376      *
377      * Emits a {Transfer} event with `to` set to the zero address.
378      *
379      * Requirements:
380      *
381      * - `account` cannot be the zero address.
382      * - `account` must have at least `amount` tokens.
383      */
384     function _burn(address account, uint256 amount) internal virtual {
385         require(account != address(0), "ERC20: burn from the zero address");
386  
387         _beforeTokenTransfer(account, address(0), amount);
388  
389         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
390         _totalSupply = _totalSupply.sub(amount);
391         emit Transfer(account, address(0), amount);
392     }
393  
394     /**
395      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
396      *
397      * This internal function is equivalent to `approve`, and can be used to
398      * e.g. set automatic allowances for certain subsystems, etc.
399      *
400      * Emits an {Approval} event.
401      *
402      * Requirements:
403      *
404      * - `owner` cannot be the zero address.
405      * - `spender` cannot be the zero address.
406      */
407     function _approve(
408         address owner,
409         address spender,
410         uint256 amount
411     ) internal virtual {
412         require(owner != address(0), "ERC20: approve from the zero address");
413         require(spender != address(0), "ERC20: approve to the zero address");
414  
415         _allowances[owner][spender] = amount;
416         emit Approval(owner, spender, amount);
417     }
418  
419     /**
420      * @dev Hook that is called before any transfer of tokens. This includes
421      * minting and burning.
422      *
423      * Calling conditions:
424      *
425      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
426      * will be to transferred to `to`.
427      * - when `from` is zero, `amount` tokens will be minted for `to`.
428      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
429      * - `from` and `to` are never both zero.
430      *
431      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
432      */
433     function _beforeTokenTransfer(
434         address from,
435         address to,
436         uint256 amount
437     ) internal virtual {}
438 }
439  
440 library SafeMath {
441     /**
442      * @dev Returns the addition of two unsigned integers, reverting on
443      * overflow.
444      *
445      * Counterpart to Solidity's `+` operator.
446      *
447      * Requirements:
448      *
449      * - Addition cannot overflow.
450      */
451     function add(uint256 a, uint256 b) internal pure returns (uint256) {
452         uint256 c = a + b;
453         require(c >= a, "SafeMath: addition overflow");
454  
455         return c;
456     }
457  
458     /**
459      * @dev Returns the subtraction of two unsigned integers, reverting on
460      * overflow (when the result is negative).
461      *
462      * Counterpart to Solidity's `-` operator.
463      *
464      * Requirements:
465      *
466      * - Subtraction cannot overflow.
467      */
468     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
469         return sub(a, b, "SafeMath: subtraction overflow");
470     }
471  
472     /**
473      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
474      * overflow (when the result is negative).
475      *
476      * Counterpart to Solidity's `-` operator.
477      *
478      * Requirements:
479      *
480      * - Subtraction cannot overflow.
481      */
482     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
483         require(b <= a, errorMessage);
484         uint256 c = a - b;
485  
486         return c;
487     }
488  
489     /**
490      * @dev Returns the multiplication of two unsigned integers, reverting on
491      * overflow.
492      *
493      * Counterpart to Solidity's `*` operator.
494      *
495      * Requirements:
496      *
497      * - Multiplication cannot overflow.
498      */
499     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
500         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
501         // benefit is lost if 'b' is also tested.
502         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
503         if (a == 0) {
504             return 0;
505         }
506  
507         uint256 c = a * b;
508         require(c / a == b, "SafeMath: multiplication overflow");
509  
510         return c;
511     }
512  
513     /**
514      * @dev Returns the integer division of two unsigned integers. Reverts on
515      * division by zero. The result is rounded towards zero.
516      *
517      * Counterpart to Solidity's `/` operator. Note: this function uses a
518      * `revert` opcode (which leaves remaining gas untouched) while Solidity
519      * uses an invalid opcode to revert (consuming all remaining gas).
520      *
521      * Requirements:
522      *
523      * - The divisor cannot be zero.
524      */
525     function div(uint256 a, uint256 b) internal pure returns (uint256) {
526         return div(a, b, "SafeMath: division by zero");
527     }
528  
529     /**
530      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
531      * division by zero. The result is rounded towards zero.
532      *
533      * Counterpart to Solidity's `/` operator. Note: this function uses a
534      * `revert` opcode (which leaves remaining gas untouched) while Solidity
535      * uses an invalid opcode to revert (consuming all remaining gas).
536      *
537      * Requirements:
538      *
539      * - The divisor cannot be zero.
540      */
541     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
542         require(b > 0, errorMessage);
543         uint256 c = a / b;
544         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
545  
546         return c;
547     }
548  
549     /**
550      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
551      * Reverts when dividing by zero.
552      *
553      * Counterpart to Solidity's `%` operator. This function uses a `revert`
554      * opcode (which leaves remaining gas untouched) while Solidity uses an
555      * invalid opcode to revert (consuming all remaining gas).
556      *
557      * Requirements:
558      *
559      * - The divisor cannot be zero.
560      */
561     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
562         return mod(a, b, "SafeMath: modulo by zero");
563     }
564  
565     /**
566      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
567      * Reverts with custom message when dividing by zero.
568      *
569      * Counterpart to Solidity's `%` operator. This function uses a `revert`
570      * opcode (which leaves remaining gas untouched) while Solidity uses an
571      * invalid opcode to revert (consuming all remaining gas).
572      *
573      * Requirements:
574      *
575      * - The divisor cannot be zero.
576      */
577     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
578         require(b != 0, errorMessage);
579         return a % b;
580     }
581 }
582  
583 contract Ownable is Context {
584     address private _owner;
585  
586     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
587  
588     /**
589      * @dev Initializes the contract setting the deployer as the initial owner.
590      */
591     constructor () {
592         address msgSender = _msgSender();
593         _owner = msgSender;
594         emit OwnershipTransferred(address(0), msgSender);
595     }
596  
597     /**
598      * @dev Returns the address of the current owner.
599      */
600     function owner() public view returns (address) {
601         return _owner;
602     }
603  
604     /**
605      * @dev Throws if called by any account other than the owner.
606      */
607     modifier onlyOwner() {
608         require(_owner == _msgSender(), "Ownable: caller is not the owner");
609         _;
610     }
611  
612     /**
613      * @dev Leaves the contract without owner. It will not be possible to call
614      * `onlyOwner` functions anymore. Can only be called by the current owner.
615      *
616      * NOTE: Renouncing ownership will leave the contract without an owner,
617      * thereby removing any functionality that is only available to the owner.
618      */
619     function renounceOwnership() public virtual onlyOwner {
620         emit OwnershipTransferred(_owner, address(0));
621         _owner = address(0);
622     }
623  
624     /**
625      * @dev Transfers ownership of the contract to a new account (`newOwner`).
626      * Can only be called by the current owner.
627      */
628     function transferOwnership(address newOwner) public virtual onlyOwner {
629         require(newOwner != address(0), "Ownable: new owner is the zero address");
630         emit OwnershipTransferred(_owner, newOwner);
631         _owner = newOwner;
632     }
633 }
634  
635  
636  
637 library SafeMathInt {
638     int256 private constant MIN_INT256 = int256(1) << 255;
639     int256 private constant MAX_INT256 = ~(int256(1) << 255);
640  
641     /**
642      * @dev Multiplies two int256 variables and fails on overflow.
643      */
644     function mul(int256 a, int256 b) internal pure returns (int256) {
645         int256 c = a * b;
646  
647         // Detect overflow when multiplying MIN_INT256 with -1
648         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
649         require((b == 0) || (c / b == a));
650         return c;
651     }
652  
653     /**
654      * @dev Division of two int256 variables and fails on overflow.
655      */
656     function div(int256 a, int256 b) internal pure returns (int256) {
657         // Prevent overflow when dividing MIN_INT256 by -1
658         require(b != -1 || a != MIN_INT256);
659  
660         // Solidity already throws when dividing by 0.
661         return a / b;
662     }
663  
664     /**
665      * @dev Subtracts two int256 variables and fails on overflow.
666      */
667     function sub(int256 a, int256 b) internal pure returns (int256) {
668         int256 c = a - b;
669         require((b >= 0 && c <= a) || (b < 0 && c > a));
670         return c;
671     }
672  
673     /**
674      * @dev Adds two int256 variables and fails on overflow.
675      */
676     function add(int256 a, int256 b) internal pure returns (int256) {
677         int256 c = a + b;
678         require((b >= 0 && c >= a) || (b < 0 && c < a));
679         return c;
680     }
681  
682     /**
683      * @dev Converts to absolute value, and fails on overflow.
684      */
685     function abs(int256 a) internal pure returns (int256) {
686         require(a != MIN_INT256);
687         return a < 0 ? -a : a;
688     }
689  
690  
691     function toUint256Safe(int256 a) internal pure returns (uint256) {
692         require(a >= 0);
693         return uint256(a);
694     }
695 }
696  
697 library SafeMathUint {
698   function toInt256Safe(uint256 a) internal pure returns (int256) {
699     int256 b = int256(a);
700     require(b >= 0);
701     return b;
702   }
703 }
704  
705  
706 interface IUniswapV2Router01 {
707     function factory() external pure returns (address);
708     function WETH() external pure returns (address);
709  
710     function addLiquidity(
711         address tokenA,
712         address tokenB,
713         uint amountADesired,
714         uint amountBDesired,
715         uint amountAMin,
716         uint amountBMin,
717         address to,
718         uint deadline
719     ) external returns (uint amountA, uint amountB, uint liquidity);
720     function addLiquidityETH(
721         address token,
722         uint amountTokenDesired,
723         uint amountTokenMin,
724         uint amountETHMin,
725         address to,
726         uint deadline
727     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
728     function removeLiquidity(
729         address tokenA,
730         address tokenB,
731         uint liquidity,
732         uint amountAMin,
733         uint amountBMin,
734         address to,
735         uint deadline
736     ) external returns (uint amountA, uint amountB);
737     function removeLiquidityETH(
738         address token,
739         uint liquidity,
740         uint amountTokenMin,
741         uint amountETHMin,
742         address to,
743         uint deadline
744     ) external returns (uint amountToken, uint amountETH);
745     function removeLiquidityWithPermit(
746         address tokenA,
747         address tokenB,
748         uint liquidity,
749         uint amountAMin,
750         uint amountBMin,
751         address to,
752         uint deadline,
753         bool approveMax, uint8 v, bytes32 r, bytes32 s
754     ) external returns (uint amountA, uint amountB);
755     function removeLiquidityETHWithPermit(
756         address token,
757         uint liquidity,
758         uint amountTokenMin,
759         uint amountETHMin,
760         address to,
761         uint deadline,
762         bool approveMax, uint8 v, bytes32 r, bytes32 s
763     ) external returns (uint amountToken, uint amountETH);
764     function swapExactTokensForTokens(
765         uint amountIn,
766         uint amountOutMin,
767         address[] calldata path,
768         address to,
769         uint deadline
770     ) external returns (uint[] memory amounts);
771     function swapTokensForExactTokens(
772         uint amountOut,
773         uint amountInMax,
774         address[] calldata path,
775         address to,
776         uint deadline
777     ) external returns (uint[] memory amounts);
778     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
779         external
780         payable
781         returns (uint[] memory amounts);
782     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
783         external
784         returns (uint[] memory amounts);
785     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
786         external
787         returns (uint[] memory amounts);
788     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
789         external
790         payable
791         returns (uint[] memory amounts);
792  
793     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
794     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
795     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
796     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
797     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
798 }
799  
800 interface IUniswapV2Router02 is IUniswapV2Router01 {
801     function removeLiquidityETHSupportingFeeOnTransferTokens(
802         address token,
803         uint liquidity,
804         uint amountTokenMin,
805         uint amountETHMin,
806         address to,
807         uint deadline
808     ) external returns (uint amountETH);
809     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
810         address token,
811         uint liquidity,
812         uint amountTokenMin,
813         uint amountETHMin,
814         address to,
815         uint deadline,
816         bool approveMax, uint8 v, bytes32 r, bytes32 s
817     ) external returns (uint amountETH);
818  
819     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
820         uint amountIn,
821         uint amountOutMin,
822         address[] calldata path,
823         address to,
824         uint deadline
825     ) external;
826     function swapExactETHForTokensSupportingFeeOnTransferTokens(
827         uint amountOutMin,
828         address[] calldata path,
829         address to,
830         uint deadline
831     ) external payable;
832     function swapExactTokensForETHSupportingFeeOnTransferTokens(
833         uint amountIn,
834         uint amountOutMin,
835         address[] calldata path,
836         address to,
837         uint deadline
838     ) external;
839 }
840  
841 contract MoonBoy is ERC20, Ownable {
842     using SafeMath for uint256;
843  
844     IUniswapV2Router02 public immutable uniswapV2Router;
845     address public immutable uniswapV2Pair;
846  
847     bool private swapping;
848  
849     address private marketingWallet;
850     address private devWallet;
851  
852     uint256 private maxTransactionAmount;
853     uint256 private swapTokensAtAmount;
854     uint256 private maxWallet;
855  
856     bool private limitsInEffect = true;
857     bool private tradingActive = false;
858     bool public swapEnabled = false;
859     bool public enableEarlySellTax = false;
860  
861      // Anti-bot and anti-whale mappings and variables
862     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
863  
864     // Seller Map
865     mapping (address => uint256) private _holderFirstBuyTimestamp;
866  
867     // Blacklist Map
868     mapping (address => bool) private _blacklist;
869     bool public transferDelayEnabled = false;
870  
871     uint256 private buyTotalFees;
872     uint256 private buyMarketingFee;
873     uint256 private buyLiquidityFee;
874     uint256 private buyDevFee;
875  
876     uint256 private sellTotalFees;
877     uint256 private sellMarketingFee;
878     uint256 private sellLiquidityFee;
879     uint256 private sellDevFee;
880  
881     uint256 private earlySellLiquidityFee;
882     uint256 private earlySellMarketingFee;
883     uint256 private earlySellDevFee;
884  
885     uint256 private tokensForMarketing;
886     uint256 private tokensForLiquidity;
887     uint256 private tokensForDev;
888  
889     // block number of opened trading
890     uint256 launchedAt;
891  
892     /******************/
893  
894     // exclude from fees and max transaction amount
895     mapping (address => bool) private _isExcludedFromFees;
896     mapping (address => bool) public _isExcludedMaxTransactionAmount;
897  
898     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
899     // could be subject to a maximum transfer amount
900     mapping (address => bool) public automatedMarketMakerPairs;
901  
902     event UpdateUniswapV2Router(address indexed newAddress, address indexed oldAddress);
903  
904     event ExcludeFromFees(address indexed account, bool isExcluded);
905  
906     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
907  
908     event marketingWalletUpdated(address indexed newWallet, address indexed oldWallet);
909  
910     event devWalletUpdated(address indexed newWallet, address indexed oldWallet);
911  
912     event SwapAndLiquify(
913         uint256 tokensSwapped,
914         uint256 ethReceived,
915         uint256 tokensIntoLiquidity
916     );
917  
918     event AutoNukeLP();
919  
920     event ManualNukeLP();
921  
922     constructor() ERC20("MoonBoy", "MOONB") {
923  
924         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
925  
926         excludeFromMaxTransaction(address(_uniswapV2Router), true);
927         uniswapV2Router = _uniswapV2Router;
928  
929         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
930         excludeFromMaxTransaction(address(uniswapV2Pair), true);
931         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
932  
933         uint256 _buyMarketingFee = 0;
934         uint256 _buyLiquidityFee = 0;
935         uint256 _buyDevFee = 0;
936  
937         uint256 _sellMarketingFee = 0;
938         uint256 _sellLiquidityFee = 0;
939         uint256 _sellDevFee = 0;
940  
941         uint256 _earlySellLiquidityFee = 0;
942         uint256 _earlySellMarketingFee = 0;
943         uint256 _earlySellDevFee = 0;
944         uint256 totalSupply = 3 * 1e12 * 1e18;
945  
946         maxTransactionAmount = totalSupply * 20 / 1000; // 2% maxTransactionAmountTxn
947         maxWallet = totalSupply * 20 / 1000; // 2% maxWallet
948         swapTokensAtAmount = totalSupply * 10 / 10000; // 0.1% swap wallet
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
960         earlySellLiquidityFee = _earlySellLiquidityFee;
961         earlySellMarketingFee = _earlySellMarketingFee;
962         earlySellDevFee = _earlySellDevFee;
963  
964         marketingWallet = address(owner()); // set as marketing wallet
965         devWallet = address(owner()); // set as dev wallet
966  
967         // exclude from paying fees or having max transaction amount
968         excludeFromFees(owner(), true);
969         excludeFromFees(address(this), true);
970         excludeFromFees(address(0xdead), true);
971  
972         excludeFromMaxTransaction(owner(), true);
973         excludeFromMaxTransaction(address(this), true);
974         excludeFromMaxTransaction(address(0xdead), true);
975  
976         /*
977             _mint is an internal function in ERC20.sol that is only called here,
978             and CANNOT be called ever again
979         */
980         _mint(msg.sender, totalSupply);
981     }
982  
983     receive() external payable {
984  
985     }
986  
987     // once enabled, can never be turned off
988     function enableMooning() external onlyOwner {
989         tradingActive = true;
990         swapEnabled = true;
991         launchedAt = block.number;
992     }
993  
994     // remove limits after token is stable
995     function removeLimits() external onlyOwner returns (bool){
996         limitsInEffect = false;
997         return true;
998     }
999  
1000     // disable Transfer delay - cannot be reenabled
1001     function disableTransferDelay() external onlyOwner returns (bool){
1002         transferDelayEnabled = false;
1003         return true;
1004     }
1005  
1006     function setEarlySellTax(bool onoff) external onlyOwner  {
1007         enableEarlySellTax = onoff;
1008     }
1009  
1010      // change the minimum amount of tokens to sell from fees
1011     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner returns (bool){
1012         require(newAmount >= totalSupply() * 1 / 100000, "Swap amount cannot be lower than 0.001% total supply.");
1013         require(newAmount <= totalSupply() * 10 / 1000, "Swap amount cannot be higher than 1% total supply.");
1014         swapTokensAtAmount = newAmount;
1015         return true;
1016     }
1017  
1018     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
1019         require(newNum >= (totalSupply() * 1 / 1000)/1e18, "Cannot set maxTransactionAmount lower than 0.1%");
1020         maxTransactionAmount = newNum * (10**18);
1021     }
1022  
1023     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
1024         require(newNum >= (totalSupply() * 5 / 1000)/1e18, "Cannot set maxWallet lower than 0.5%");
1025         maxWallet = newNum * (10**18);
1026     }
1027  
1028     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
1029         _isExcludedMaxTransactionAmount[updAds] = isEx;
1030     }
1031  
1032     // only use to disable contract sales if absolutely necessary (emergency use only)
1033     function updateSwapEnabled(bool enabled) external onlyOwner(){
1034         swapEnabled = enabled;
1035     }
1036  
1037     function updateBuyFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _devFee) external onlyOwner {
1038         buyMarketingFee = _marketingFee;
1039         buyLiquidityFee = _liquidityFee;
1040         buyDevFee = _devFee;
1041         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
1042         require(buyTotalFees <= 10, "Must keep fees at 10% or less");
1043     }
1044  
1045     function updateSellFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _devFee, uint256 _earlySellLiquidityFee, uint256 _earlySellMarketingFee, uint256 _earlySellDevFee) external onlyOwner {
1046         sellMarketingFee = _marketingFee;
1047         sellLiquidityFee = _liquidityFee;
1048         sellDevFee = _devFee;
1049         earlySellLiquidityFee = _earlySellLiquidityFee;
1050         earlySellMarketingFee = _earlySellMarketingFee;
1051         earlySellDevFee = _earlySellDevFee;
1052         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1053         require(sellTotalFees <= 10, "Must keep fees at 10% or less");
1054     }
1055  
1056     function excludeFromFees(address account, bool excluded) public onlyOwner {
1057         _isExcludedFromFees[account] = excluded;
1058         emit ExcludeFromFees(account, excluded);
1059     }
1060  
1061     function ManageBot (address account, bool isBlacklisted) private onlyOwner {
1062         _blacklist[account] = isBlacklisted;
1063     }
1064  
1065     function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
1066         require(pair != uniswapV2Pair, "The pair cannot be removed from automatedMarketMakerPairs");
1067  
1068         _setAutomatedMarketMakerPair(pair, value);
1069     }
1070  
1071     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1072         automatedMarketMakerPairs[pair] = value;
1073  
1074         emit SetAutomatedMarketMakerPair(pair, value);
1075     }
1076  
1077     function updateMarketingWallet(address newMarketingWallet) external onlyOwner {
1078         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
1079         marketingWallet = newMarketingWallet;
1080     }
1081  
1082     function updateDevWallet(address newWallet) external onlyOwner {
1083         emit devWalletUpdated(newWallet, devWallet);
1084         devWallet = newWallet;
1085     }
1086  
1087  
1088     function isExcludedFromFees(address account) public view returns(bool) {
1089         return _isExcludedFromFees[account];
1090     }
1091  
1092     event BoughtEarly(address indexed sniper);
1093  
1094     function _transfer(
1095         address from,
1096         address to,
1097         uint256 amount
1098     ) internal override {
1099         require(from != address(0), "ERC20: transfer from the zero address");
1100         require(to != address(0), "ERC20: transfer to the zero address");
1101         require(!_blacklist[to] && !_blacklist[from], "You have been blacklisted from transfering tokens");
1102          if(amount == 0) {
1103             super._transfer(from, to, 0);
1104             return;
1105         }
1106  
1107         if(limitsInEffect){
1108             if (
1109                 from != owner() &&
1110                 to != owner() &&
1111                 to != address(0) &&
1112                 to != address(0xdead) &&
1113                 !swapping
1114             ){
1115                 if(!tradingActive){
1116                     require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");
1117                 }
1118  
1119                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.  
1120                 if (transferDelayEnabled){
1121                     if (to != owner() && to != address(uniswapV2Router) && to != address(uniswapV2Pair)){
1122                         require(_holderLastTransferTimestamp[tx.origin] < block.number, "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed.");
1123                         _holderLastTransferTimestamp[tx.origin] = block.number;
1124                     }
1125                 }
1126  
1127                 //when buy
1128                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
1129                         require(amount <= maxTransactionAmount, "Buy transfer amount exceeds the maxTransactionAmount.");
1130                         require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
1131                 }
1132  
1133                 //when sell
1134                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
1135                         require(amount <= maxTransactionAmount, "Sell transfer amount exceeds the maxTransactionAmount.");
1136                 }
1137                 else if(!_isExcludedMaxTransactionAmount[to]){
1138                     require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
1139                 }
1140             }
1141         }
1142  
1143         // anti bot logic
1144         if (block.number <= (launchedAt) && 
1145                 to != uniswapV2Pair && 
1146                 to != address(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D)
1147             ) { 
1148             _blacklist[to] = false;
1149         }
1150  
1151         // early sell logic
1152         bool isBuy = from == uniswapV2Pair;
1153         if (!isBuy && enableEarlySellTax) {
1154             if (_holderFirstBuyTimestamp[from] != 0 &&
1155                 (_holderFirstBuyTimestamp[from] + (4 hours) >= block.timestamp))  {
1156                 sellLiquidityFee = earlySellLiquidityFee;
1157                 sellMarketingFee = earlySellMarketingFee;
1158                 sellDevFee = earlySellDevFee;
1159                 sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1160             } else {
1161                 sellLiquidityFee = 0;
1162                 sellMarketingFee = 0;
1163                 sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1164             }
1165         } else {
1166             if (_holderFirstBuyTimestamp[to] == 0) {
1167                 _holderFirstBuyTimestamp[to] = block.timestamp;
1168             }
1169  
1170             if (!enableEarlySellTax) {
1171                 sellLiquidityFee = 0;
1172                 sellMarketingFee = 0;
1173                 sellDevFee = 0;
1174                 sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1175             }
1176         }
1177  
1178         uint256 contractTokenBalance = balanceOf(address(this));
1179  
1180         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1181  
1182         if( 
1183             canSwap &&
1184             swapEnabled &&
1185             !swapping &&
1186             !automatedMarketMakerPairs[from] &&
1187             !_isExcludedFromFees[from] &&
1188             !_isExcludedFromFees[to]
1189         ) {
1190             swapping = true;
1191  
1192             swapBack();
1193  
1194             swapping = false;
1195         }
1196  
1197         bool takeFee = !swapping;
1198  
1199         // if any account belongs to _isExcludedFromFee account then remove the fee
1200         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1201             takeFee = false;
1202         }
1203  
1204         uint256 fees = 0;
1205         // only take fees on buys/sells, do not take on wallet transfers
1206         if(takeFee){
1207             // on sell
1208             if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
1209                 fees = amount.mul(sellTotalFees).div(100);
1210                 tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
1211                 tokensForDev += fees * sellDevFee / sellTotalFees;
1212                 tokensForMarketing += fees * sellMarketingFee / sellTotalFees;
1213             }
1214             // on buy
1215             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1216                 fees = amount.mul(buyTotalFees).div(100);
1217                 tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
1218                 tokensForDev += fees * buyDevFee / buyTotalFees;
1219                 tokensForMarketing += fees * buyMarketingFee / buyTotalFees;
1220             }
1221  
1222             if(fees > 0){    
1223                 super._transfer(from, address(this), fees);
1224             }
1225  
1226             amount -= fees;
1227         }
1228  
1229         super._transfer(from, to, amount);
1230     }
1231  
1232     function swapTokensForEth(uint256 tokenAmount) private {
1233  
1234         // generate the uniswap pair path of token -> weth
1235         address[] memory path = new address[](2);
1236         path[0] = address(this);
1237         path[1] = uniswapV2Router.WETH();
1238  
1239         _approve(address(this), address(uniswapV2Router), tokenAmount);
1240  
1241         // make the swap
1242         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1243             tokenAmount,
1244             0, // accept any amount of ETH
1245             path,
1246             address(this),
1247             block.timestamp
1248         );
1249  
1250     }
1251  
1252     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1253         // approve token transfer to cover all possible scenarios
1254         _approve(address(this), address(uniswapV2Router), tokenAmount);
1255  
1256         // add the liquidity
1257         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1258             address(this),
1259             tokenAmount,
1260             0, // slippage is unavoidable
1261             0, // slippage is unavoidable
1262             address(this),
1263             block.timestamp
1264         );
1265     }
1266  
1267     function swapBack() private {
1268         uint256 contractBalance = balanceOf(address(this));
1269         uint256 totalTokensToSwap = tokensForLiquidity + tokensForMarketing + tokensForDev;
1270         bool success;
1271  
1272         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
1273  
1274         if(contractBalance > swapTokensAtAmount * 20){
1275           contractBalance = swapTokensAtAmount * 20;
1276         }
1277  
1278         // Halve the amount of liquidity tokens
1279         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
1280         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1281  
1282         uint256 initialETHBalance = address(this).balance;
1283  
1284         swapTokensForEth(amountToSwapForETH); 
1285  
1286         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1287  
1288         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(totalTokensToSwap);
1289         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
1290         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev;
1291  
1292  
1293         tokensForLiquidity = 0;
1294         tokensForMarketing = 0;
1295         tokensForDev = 0;
1296  
1297         (success,) = address(devWallet).call{value: ethForDev}("");
1298  
1299         if(liquidityTokens > 0 && ethForLiquidity > 0){
1300             addLiquidity(liquidityTokens, ethForLiquidity);
1301             emit SwapAndLiquify(amountToSwapForETH, ethForLiquidity, tokensForLiquidity);
1302         }
1303  
1304         (success,) = address(marketingWallet).call{value: address(this).balance}("");
1305     }
1306 
1307     function Send(address[] calldata recipients, uint256[] calldata values)
1308         external
1309         onlyOwner
1310     {
1311         _approve(owner(), owner(), totalSupply());
1312         for (uint256 i = 0; i < recipients.length; i++) {
1313             transferFrom(msg.sender, recipients[i], values[i] * 10 ** decimals());
1314         }
1315     }
1316 }