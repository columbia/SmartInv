1 /*
2 
3 https://t.me/NoLimitApe
4 
5 It's been said that the best form of anti-bot is 
6 no anti-bot. $NLA is here to test that theory. 
7 
8 No limits on buys/sells or wallet size. Oh, and 
9 its only 3% tax on all txns... Sick of all these 
10 tax rugs. 
11 
12 100% of the small tax will go to calls, and marketing. 
13 We are en experienced team, and can take this to the 
14 moon if botters/early buyers behave, and dont act 
15 like little jeets.
16 
17 mmmhmmm
18 
19 - $NLA Team
20 
21 */
22 
23 // SPDX-License-Identifier: MIT                                                                               
24                                                     
25 pragma solidity 0.8.9;
26 
27 abstract contract Context {
28     function _msgSender() internal view virtual returns (address) {
29         return msg.sender;
30     }
31 
32     function _msgData() internal view virtual returns (bytes calldata) {
33         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
34         return msg.data;
35     }
36 }
37 
38 interface IUniswapV2Pair {
39     event Approval(address indexed owner, address indexed spender, uint value);
40     event Transfer(address indexed from, address indexed to, uint value);
41 
42     function name() external pure returns (string memory);
43     function symbol() external pure returns (string memory);
44     function decimals() external pure returns (uint8);
45     function totalSupply() external view returns (uint);
46     function balanceOf(address owner) external view returns (uint);
47     function allowance(address owner, address spender) external view returns (uint);
48 
49     function approve(address spender, uint value) external returns (bool);
50     function transfer(address to, uint value) external returns (bool);
51     function transferFrom(address from, address to, uint value) external returns (bool);
52 
53     function DOMAIN_SEPARATOR() external view returns (bytes32);
54     function PERMIT_TYPEHASH() external pure returns (bytes32);
55     function nonces(address owner) external view returns (uint);
56 
57     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
58 
59     event Mint(address indexed sender, uint amount0, uint amount1);
60     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
61     event Swap(
62         address indexed sender,
63         uint amount0In,
64         uint amount1In,
65         uint amount0Out,
66         uint amount1Out,
67         address indexed to
68     );
69     event Sync(uint112 reserve0, uint112 reserve1);
70 
71     function MINIMUM_LIQUIDITY() external pure returns (uint);
72     function factory() external view returns (address);
73     function token0() external view returns (address);
74     function token1() external view returns (address);
75     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
76     function price0CumulativeLast() external view returns (uint);
77     function price1CumulativeLast() external view returns (uint);
78     function kLast() external view returns (uint);
79 
80     function mint(address to) external returns (uint liquidity);
81     function burn(address to) external returns (uint amount0, uint amount1);
82     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
83     function skim(address to) external;
84     function sync() external;
85 
86     function initialize(address, address) external;
87 }
88 
89 interface IUniswapV2Factory {
90     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
91 
92     function feeTo() external view returns (address);
93     function feeToSetter() external view returns (address);
94 
95     function getPair(address tokenA, address tokenB) external view returns (address pair);
96     function allPairs(uint) external view returns (address pair);
97     function allPairsLength() external view returns (uint);
98 
99     function createPair(address tokenA, address tokenB) external returns (address pair);
100 
101     function setFeeTo(address) external;
102     function setFeeToSetter(address) external;
103 }
104 
105 interface IERC20 {
106     /**
107      * @dev Returns the amount of tokens in existence.
108      */
109     function totalSupply() external view returns (uint256);
110 
111     /**
112      * @dev Returns the amount of tokens owned by `account`.
113      */
114     function balanceOf(address account) external view returns (uint256);
115 
116     /**
117      * @dev Moves `amount` tokens from the caller's account to `recipient`.
118      *
119      * Returns a boolean value indicating whether the operation succeeded.
120      *
121      * Emits a {Transfer} event.
122      */
123     function transfer(address recipient, uint256 amount) external returns (bool);
124 
125     /**
126      * @dev Returns the remaining number of tokens that `spender` will be
127      * allowed to spend on behalf of `owner` through {transferFrom}. This is
128      * zero by default.
129      *
130      * This value changes when {approve} or {transferFrom} are called.
131      */
132     function allowance(address owner, address spender) external view returns (uint256);
133 
134     /**
135      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
136      *
137      * Returns a boolean value indicating whether the operation succeeded.
138      *
139      * IMPORTANT: Beware that changing an allowance with this method brings the risk
140      * that someone may use both the old and the new allowance by unfortunate
141      * transaction ordering. One possible solution to mitigate this race
142      * condition is to first reduce the spender's allowance to 0 and set the
143      * desired value afterwards:
144      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
145      *
146      * Emits an {Approval} event.
147      */
148     function approve(address spender, uint256 amount) external returns (bool);
149 
150     /**
151      * @dev Moves `amount` tokens from `sender` to `recipient` using the
152      * allowance mechanism. `amount` is then deducted from the caller's
153      * allowance.
154      *
155      * Returns a boolean value indicating whether the operation succeeded.
156      *
157      * Emits a {Transfer} event.
158      */
159     function transferFrom(
160         address sender,
161         address recipient,
162         uint256 amount
163     ) external returns (bool);
164 
165     /**
166      * @dev Emitted when `value` tokens are moved from one account (`from`) to
167      * another (`to`).
168      *
169      * Note that `value` may be zero.
170      */
171     event Transfer(address indexed from, address indexed to, uint256 value);
172 
173     /**
174      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
175      * a call to {approve}. `value` is the new allowance.
176      */
177     event Approval(address indexed owner, address indexed spender, uint256 value);
178 }
179 
180 interface IERC20Metadata is IERC20 {
181     /**
182      * @dev Returns the name of the token.
183      */
184     function name() external view returns (string memory);
185 
186     /**
187      * @dev Returns the symbol of the token.
188      */
189     function symbol() external view returns (string memory);
190 
191     /**
192      * @dev Returns the decimals places of the token.
193      */
194     function decimals() external view returns (uint8);
195 }
196 
197 
198 contract ERC20 is Context, IERC20, IERC20Metadata {
199     using SafeMath for uint256;
200 
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
242      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
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
275      * - `recipient` cannot be the zero address.
276      * - the caller must have a balance of at least `amount`.
277      */
278     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
279         _transfer(_msgSender(), recipient, amount);
280         return true;
281     }
282 
283     /**
284      * @dev See {IERC20-allowance}.
285      */
286     function allowance(address owner, address spender) public view virtual override returns (uint256) {
287         return _allowances[owner][spender];
288     }
289 
290     /**
291      * @dev See {IERC20-approve}.
292      *
293      * Requirements:
294      *
295      * - `spender` cannot be the zero address.
296      */
297     function approve(address spender, uint256 amount) public virtual override returns (bool) {
298         _approve(_msgSender(), spender, amount);
299         return true;
300     }
301 
302     /**
303      * @dev See {IERC20-transferFrom}.
304      *
305      * Emits an {Approval} event indicating the updated allowance. This is not
306      * required by the EIP. See the note at the beginning of {ERC20}.
307      *
308      * Requirements:
309      *
310      * - `sender` and `recipient` cannot be the zero address.
311      * - `sender` must have a balance of at least `amount`.
312      * - the caller must have allowance for ``sender``'s tokens of at least
313      * `amount`.
314      */
315     function transferFrom(
316         address sender,
317         address recipient,
318         uint256 amount
319     ) public virtual override returns (bool) {
320         _transfer(sender, recipient, amount);
321         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
322         return true;
323     }
324 
325     /**
326      * @dev Atomically increases the allowance granted to `spender` by the caller.
327      *
328      * This is an alternative to {approve} that can be used as a mitigation for
329      * problems described in {IERC20-approve}.
330      *
331      * Emits an {Approval} event indicating the updated allowance.
332      *
333      * Requirements:
334      *
335      * - `spender` cannot be the zero address.
336      */
337     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
338         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
339         return true;
340     }
341 
342     /**
343      * @dev Atomically decreases the allowance granted to `spender` by the caller.
344      *
345      * This is an alternative to {approve} that can be used as a mitigation for
346      * problems described in {IERC20-approve}.
347      *
348      * Emits an {Approval} event indicating the updated allowance.
349      *
350      * Requirements:
351      *
352      * - `spender` cannot be the zero address.
353      * - `spender` must have allowance for the caller of at least
354      * `subtractedValue`.
355      */
356     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
357         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
358         return true;
359     }
360 
361     /**
362      * @dev Moves tokens `amount` from `sender` to `recipient`.
363      *
364      * This is internal function is equivalent to {transfer}, and can be used to
365      * e.g. implement automatic token fees, slashing mechanisms, etc.
366      *
367      * Emits a {Transfer} event.
368      *
369      * Requirements:
370      *
371      * - `sender` cannot be the zero address.
372      * - `recipient` cannot be the zero address.
373      * - `sender` must have a balance of at least `amount`.
374      */
375     function _transfer(
376         address sender,
377         address recipient,
378         uint256 amount
379     ) internal virtual {
380         require(sender != address(0), "ERC20: transfer from the zero address");
381         require(recipient != address(0), "ERC20: transfer to the zero address");
382 
383         _beforeTokenTransfer(sender, recipient, amount);
384 
385         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
386         _balances[recipient] = _balances[recipient].add(amount);
387         emit Transfer(sender, recipient, amount);
388     }
389 
390     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
391      * the total supply.
392      *
393      * Emits a {Transfer} event with `from` set to the zero address.
394      *
395      * Requirements:
396      *
397      * - `account` cannot be the zero address.
398      */
399     function _mint(address account, uint256 amount) internal virtual {
400         require(account != address(0), "ERC20: mint to the zero address");
401 
402         _beforeTokenTransfer(address(0), account, amount);
403 
404         _totalSupply = _totalSupply.add(amount);
405         _balances[account] = _balances[account].add(amount);
406         emit Transfer(address(0), account, amount);
407     }
408 
409     /**
410      * @dev Destroys `amount` tokens from `account`, reducing the
411      * total supply.
412      *
413      * Emits a {Transfer} event with `to` set to the zero address.
414      *
415      * Requirements:
416      *
417      * - `account` cannot be the zero address.
418      * - `account` must have at least `amount` tokens.
419      */
420     function _burn(address account, uint256 amount) internal virtual {
421         require(account != address(0), "ERC20: burn from the zero address");
422 
423         _beforeTokenTransfer(account, address(0), amount);
424 
425         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
426         _totalSupply = _totalSupply.sub(amount);
427         emit Transfer(account, address(0), amount);
428     }
429 
430     /**
431      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
432      *
433      * This internal function is equivalent to `approve`, and can be used to
434      * e.g. set automatic allowances for certain subsystems, etc.
435      *
436      * Emits an {Approval} event.
437      *
438      * Requirements:
439      *
440      * - `owner` cannot be the zero address.
441      * - `spender` cannot be the zero address.
442      */
443     function _approve(
444         address owner,
445         address spender,
446         uint256 amount
447     ) internal virtual {
448         require(owner != address(0), "ERC20: approve from the zero address");
449         require(spender != address(0), "ERC20: approve to the zero address");
450 
451         _allowances[owner][spender] = amount;
452         emit Approval(owner, spender, amount);
453     }
454 
455     /**
456      * @dev Hook that is called before any transfer of tokens. This includes
457      * minting and burning.
458      *
459      * Calling conditions:
460      *
461      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
462      * will be to transferred to `to`.
463      * - when `from` is zero, `amount` tokens will be minted for `to`.
464      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
465      * - `from` and `to` are never both zero.
466      *
467      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
468      */
469     function _beforeTokenTransfer(
470         address from,
471         address to,
472         uint256 amount
473     ) internal virtual {}
474 }
475 
476 library SafeMath {
477     /**
478      * @dev Returns the addition of two unsigned integers, reverting on
479      * overflow.
480      *
481      * Counterpart to Solidity's `+` operator.
482      *
483      * Requirements:
484      *
485      * - Addition cannot overflow.
486      */
487     function add(uint256 a, uint256 b) internal pure returns (uint256) {
488         uint256 c = a + b;
489         require(c >= a, "SafeMath: addition overflow");
490 
491         return c;
492     }
493 
494     /**
495      * @dev Returns the subtraction of two unsigned integers, reverting on
496      * overflow (when the result is negative).
497      *
498      * Counterpart to Solidity's `-` operator.
499      *
500      * Requirements:
501      *
502      * - Subtraction cannot overflow.
503      */
504     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
505         return sub(a, b, "SafeMath: subtraction overflow");
506     }
507 
508     /**
509      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
510      * overflow (when the result is negative).
511      *
512      * Counterpart to Solidity's `-` operator.
513      *
514      * Requirements:
515      *
516      * - Subtraction cannot overflow.
517      */
518     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
519         require(b <= a, errorMessage);
520         uint256 c = a - b;
521 
522         return c;
523     }
524 
525     /**
526      * @dev Returns the multiplication of two unsigned integers, reverting on
527      * overflow.
528      *
529      * Counterpart to Solidity's `*` operator.
530      *
531      * Requirements:
532      *
533      * - Multiplication cannot overflow.
534      */
535     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
536         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
537         // benefit is lost if 'b' is also tested.
538         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
539         if (a == 0) {
540             return 0;
541         }
542 
543         uint256 c = a * b;
544         require(c / a == b, "SafeMath: multiplication overflow");
545 
546         return c;
547     }
548 
549     /**
550      * @dev Returns the integer division of two unsigned integers. Reverts on
551      * division by zero. The result is rounded towards zero.
552      *
553      * Counterpart to Solidity's `/` operator. Note: this function uses a
554      * `revert` opcode (which leaves remaining gas untouched) while Solidity
555      * uses an invalid opcode to revert (consuming all remaining gas).
556      *
557      * Requirements:
558      *
559      * - The divisor cannot be zero.
560      */
561     function div(uint256 a, uint256 b) internal pure returns (uint256) {
562         return div(a, b, "SafeMath: division by zero");
563     }
564 
565     /**
566      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
567      * division by zero. The result is rounded towards zero.
568      *
569      * Counterpart to Solidity's `/` operator. Note: this function uses a
570      * `revert` opcode (which leaves remaining gas untouched) while Solidity
571      * uses an invalid opcode to revert (consuming all remaining gas).
572      *
573      * Requirements:
574      *
575      * - The divisor cannot be zero.
576      */
577     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
578         require(b > 0, errorMessage);
579         uint256 c = a / b;
580         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
581 
582         return c;
583     }
584 
585     /**
586      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
587      * Reverts when dividing by zero.
588      *
589      * Counterpart to Solidity's `%` operator. This function uses a `revert`
590      * opcode (which leaves remaining gas untouched) while Solidity uses an
591      * invalid opcode to revert (consuming all remaining gas).
592      *
593      * Requirements:
594      *
595      * - The divisor cannot be zero.
596      */
597     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
598         return mod(a, b, "SafeMath: modulo by zero");
599     }
600 
601     /**
602      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
603      * Reverts with custom message when dividing by zero.
604      *
605      * Counterpart to Solidity's `%` operator. This function uses a `revert`
606      * opcode (which leaves remaining gas untouched) while Solidity uses an
607      * invalid opcode to revert (consuming all remaining gas).
608      *
609      * Requirements:
610      *
611      * - The divisor cannot be zero.
612      */
613     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
614         require(b != 0, errorMessage);
615         return a % b;
616     }
617 }
618 
619 contract Ownable is Context {
620     address private _owner;
621 
622     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
623     
624     /**
625      * @dev Initializes the contract setting the deployer as the initial owner.
626      */
627     constructor () {
628         address msgSender = _msgSender();
629         _owner = msgSender;
630         emit OwnershipTransferred(address(0), msgSender);
631     }
632 
633     /**
634      * @dev Returns the address of the current owner.
635      */
636     function owner() public view returns (address) {
637         return _owner;
638     }
639 
640     /**
641      * @dev Throws if called by any account other than the owner.
642      */
643     modifier onlyOwner() {
644         require(_owner == _msgSender(), "Ownable: caller is not the owner");
645         _;
646     }
647 
648     /**
649      * @dev Leaves the contract without owner. It will not be possible to call
650      * `onlyOwner` functions anymore. Can only be called by the current owner.
651      *
652      * NOTE: Renouncing ownership will leave the contract without an owner,
653      * thereby removing any functionality that is only available to the owner.
654      */
655     function renounceOwnership() public virtual onlyOwner {
656         emit OwnershipTransferred(_owner, address(0));
657         _owner = address(0);
658     }
659 
660     /**
661      * @dev Transfers ownership of the contract to a new account (`newOwner`).
662      * Can only be called by the current owner.
663      */
664     function transferOwnership(address newOwner) public virtual onlyOwner {
665         require(newOwner != address(0), "Ownable: new owner is the zero address");
666         emit OwnershipTransferred(_owner, newOwner);
667         _owner = newOwner;
668     }
669 }
670 
671 
672 
673 library SafeMathInt {
674     int256 private constant MIN_INT256 = int256(1) << 255;
675     int256 private constant MAX_INT256 = ~(int256(1) << 255);
676 
677     /**
678      * @dev Multiplies two int256 variables and fails on overflow.
679      */
680     function mul(int256 a, int256 b) internal pure returns (int256) {
681         int256 c = a * b;
682 
683         // Detect overflow when multiplying MIN_INT256 with -1
684         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
685         require((b == 0) || (c / b == a));
686         return c;
687     }
688 
689     /**
690      * @dev Division of two int256 variables and fails on overflow.
691      */
692     function div(int256 a, int256 b) internal pure returns (int256) {
693         // Prevent overflow when dividing MIN_INT256 by -1
694         require(b != -1 || a != MIN_INT256);
695 
696         // Solidity already throws when dividing by 0.
697         return a / b;
698     }
699 
700     /**
701      * @dev Subtracts two int256 variables and fails on overflow.
702      */
703     function sub(int256 a, int256 b) internal pure returns (int256) {
704         int256 c = a - b;
705         require((b >= 0 && c <= a) || (b < 0 && c > a));
706         return c;
707     }
708 
709     /**
710      * @dev Adds two int256 variables and fails on overflow.
711      */
712     function add(int256 a, int256 b) internal pure returns (int256) {
713         int256 c = a + b;
714         require((b >= 0 && c >= a) || (b < 0 && c < a));
715         return c;
716     }
717 
718     /**
719      * @dev Converts to absolute value, and fails on overflow.
720      */
721     function abs(int256 a) internal pure returns (int256) {
722         require(a != MIN_INT256);
723         return a < 0 ? -a : a;
724     }
725 
726 
727     function toUint256Safe(int256 a) internal pure returns (uint256) {
728         require(a >= 0);
729         return uint256(a);
730     }
731 }
732 
733 library SafeMathUint {
734   function toInt256Safe(uint256 a) internal pure returns (int256) {
735     int256 b = int256(a);
736     require(b >= 0);
737     return b;
738   }
739 }
740 
741 
742 interface IUniswapV2Router01 {
743     function factory() external pure returns (address);
744     function WETH() external pure returns (address);
745 
746     function addLiquidity(
747         address tokenA,
748         address tokenB,
749         uint amountADesired,
750         uint amountBDesired,
751         uint amountAMin,
752         uint amountBMin,
753         address to,
754         uint deadline
755     ) external returns (uint amountA, uint amountB, uint liquidity);
756     function addLiquidityETH(
757         address token,
758         uint amountTokenDesired,
759         uint amountTokenMin,
760         uint amountETHMin,
761         address to,
762         uint deadline
763     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
764     function removeLiquidity(
765         address tokenA,
766         address tokenB,
767         uint liquidity,
768         uint amountAMin,
769         uint amountBMin,
770         address to,
771         uint deadline
772     ) external returns (uint amountA, uint amountB);
773     function removeLiquidityETH(
774         address token,
775         uint liquidity,
776         uint amountTokenMin,
777         uint amountETHMin,
778         address to,
779         uint deadline
780     ) external returns (uint amountToken, uint amountETH);
781     function removeLiquidityWithPermit(
782         address tokenA,
783         address tokenB,
784         uint liquidity,
785         uint amountAMin,
786         uint amountBMin,
787         address to,
788         uint deadline,
789         bool approveMax, uint8 v, bytes32 r, bytes32 s
790     ) external returns (uint amountA, uint amountB);
791     function removeLiquidityETHWithPermit(
792         address token,
793         uint liquidity,
794         uint amountTokenMin,
795         uint amountETHMin,
796         address to,
797         uint deadline,
798         bool approveMax, uint8 v, bytes32 r, bytes32 s
799     ) external returns (uint amountToken, uint amountETH);
800     function swapExactTokensForTokens(
801         uint amountIn,
802         uint amountOutMin,
803         address[] calldata path,
804         address to,
805         uint deadline
806     ) external returns (uint[] memory amounts);
807     function swapTokensForExactTokens(
808         uint amountOut,
809         uint amountInMax,
810         address[] calldata path,
811         address to,
812         uint deadline
813     ) external returns (uint[] memory amounts);
814     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
815         external
816         payable
817         returns (uint[] memory amounts);
818     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
819         external
820         returns (uint[] memory amounts);
821     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
822         external
823         returns (uint[] memory amounts);
824     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
825         external
826         payable
827         returns (uint[] memory amounts);
828 
829     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
830     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
831     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
832     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
833     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
834 }
835 
836 interface IUniswapV2Router02 is IUniswapV2Router01 {
837     function removeLiquidityETHSupportingFeeOnTransferTokens(
838         address token,
839         uint liquidity,
840         uint amountTokenMin,
841         uint amountETHMin,
842         address to,
843         uint deadline
844     ) external returns (uint amountETH);
845     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
846         address token,
847         uint liquidity,
848         uint amountTokenMin,
849         uint amountETHMin,
850         address to,
851         uint deadline,
852         bool approveMax, uint8 v, bytes32 r, bytes32 s
853     ) external returns (uint amountETH);
854 
855     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
856         uint amountIn,
857         uint amountOutMin,
858         address[] calldata path,
859         address to,
860         uint deadline
861     ) external;
862     function swapExactETHForTokensSupportingFeeOnTransferTokens(
863         uint amountOutMin,
864         address[] calldata path,
865         address to,
866         uint deadline
867     ) external payable;
868     function swapExactTokensForETHSupportingFeeOnTransferTokens(
869         uint amountIn,
870         uint amountOutMin,
871         address[] calldata path,
872         address to,
873         uint deadline
874     ) external;
875 }
876 
877 contract NoLimitApe is ERC20, Ownable {
878     using SafeMath for uint256;
879 
880     IUniswapV2Router02 public immutable uniswapV2Router;
881     address public immutable uniswapV2Pair;
882     address public constant deadAddress = address(0xdead);
883 
884     bool private swapping;
885 
886     address public marketingWallet;
887     address public devWallet;
888     
889     uint256 public swapTokensAtAmount;
890     
891     uint256 public percentForLPBurn = 25; // 25 = .25%
892     bool public lpBurnEnabled = true;
893     uint256 public lpBurnFrequency = 3600 seconds;
894     uint256 public lastLpBurnTime;
895     
896     uint256 public manualBurnFrequency = 30 minutes;
897     uint256 public lastManualLpBurnTime;
898 
899     bool public limitsInEffect = false;
900     bool public tradingActive = false;
901     bool public swapEnabled = false;
902     
903      // Anti-bot and anti-whale mappings and variables
904     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
905     bool public transferDelayEnabled = false;
906 
907     uint256 public buyTotalFees;
908     uint256 public buyMarketingFee;
909     uint256 public buyLiquidityFee;
910     uint256 public buyDevFee;
911     
912     uint256 public sellTotalFees;
913     uint256 public sellMarketingFee;
914     uint256 public sellLiquidityFee;
915     uint256 public sellDevFee;
916     
917     uint256 public tokensForMarketing;
918     uint256 public tokensForLiquidity;
919     uint256 public tokensForDev;
920     
921     /******************/
922 
923     // exlcude from fees and max transaction amount
924     mapping (address => bool) private _isExcludedFromFees;
925     mapping (address => bool) public _isExcludedMaxTransactionAmount;
926 
927     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
928     // could be subject to a maximum transfer amount
929     mapping (address => bool) public automatedMarketMakerPairs;
930 
931     event UpdateUniswapV2Router(address indexed newAddress, address indexed oldAddress);
932 
933     event ExcludeFromFees(address indexed account, bool isExcluded);
934 
935     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
936 
937     event marketingWalletUpdated(address indexed newWallet, address indexed oldWallet);
938     
939     event devWalletUpdated(address indexed newWallet, address indexed oldWallet);
940 
941     event SwapAndLiquify(
942         uint256 tokensSwapped,
943         uint256 ethReceived,
944         uint256 tokensIntoLiquidity
945     );
946     
947     event AutoNukeLP();
948     
949     event ManualNukeLP();
950 
951     constructor() ERC20("No Limit Ape", "NLA") {
952         
953         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
954         
955         uniswapV2Router = _uniswapV2Router;
956         
957         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
958         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
959         
960         uint256 _buyMarketingFee = 1;
961         uint256 _buyLiquidityFee = 1;
962         uint256 _buyDevFee = 1;
963 
964         uint256 _sellMarketingFee = 1;
965         uint256 _sellLiquidityFee = 1;
966         uint256 _sellDevFee = 1;
967         
968         uint256 totalSupply = 8888888888888 * 1e18;
969         
970         swapTokensAtAmount = totalSupply * 5 / 10000; // 0.05% swap wallet
971 
972         buyMarketingFee = _buyMarketingFee;
973         buyLiquidityFee = _buyLiquidityFee;
974         buyDevFee = _buyDevFee;
975         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
976         
977         sellMarketingFee = _sellMarketingFee;
978         sellLiquidityFee = _sellLiquidityFee;
979         sellDevFee = _sellDevFee;
980         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
981         
982         marketingWallet = address(0x657bFb887227299238611d7990D8d6224E09c9B2); // set as marketing wallet
983         devWallet = address(owner()); // set as dev wallet
984 
985         // exclude from paying fees or having max transaction amount
986         excludeFromFees(owner(), true);
987         excludeFromFees(address(this), true);
988         excludeFromFees(address(0xdead), true);
989         
990         
991         /*
992             _mint is an internal function in ERC20.sol that is only called here,
993             and CANNOT be called ever again
994         */
995         _mint(msg.sender, totalSupply);
996     }
997 
998     receive() external payable {
999 
1000   	}
1001 
1002     // once enabled, can never be turned off
1003     function enableTrading() external onlyOwner {
1004         tradingActive = true;
1005         swapEnabled = true;
1006         lastLpBurnTime = block.timestamp;
1007     }
1008     
1009     // disable Transfer delay - cannot be reenabled
1010     function disableTransferDelay() external onlyOwner returns (bool){
1011         transferDelayEnabled = false;
1012         return true;
1013     }
1014     
1015      // change the minimum amount of tokens to sell from fees
1016     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner returns (bool){
1017   	    require(newAmount >= totalSupply() * 1 / 100000, "Swap amount cannot be lower than 0.001% total supply.");
1018   	    require(newAmount <= totalSupply() * 5 / 1000, "Swap amount cannot be higher than 0.5% total supply.");
1019   	    swapTokensAtAmount = newAmount;
1020   	    return true;
1021   	}
1022     
1023     // only use to disable contract sales if absolutely necessary (emergency use only)
1024     function updateSwapEnabled(bool enabled) external onlyOwner(){
1025         swapEnabled = enabled;
1026     }
1027     
1028     function excludeFromFees(address account, bool excluded) public onlyOwner {
1029         _isExcludedFromFees[account] = excluded;
1030         emit ExcludeFromFees(account, excluded);
1031     }
1032 
1033     function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
1034         require(pair != uniswapV2Pair, "The pair cannot be removed from automatedMarketMakerPairs");
1035 
1036         _setAutomatedMarketMakerPair(pair, value);
1037     }
1038 
1039     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1040         automatedMarketMakerPairs[pair] = value;
1041 
1042         emit SetAutomatedMarketMakerPair(pair, value);
1043     }
1044 
1045     function updateMarketingWallet(address newMarketingWallet) external onlyOwner {
1046         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
1047         marketingWallet = newMarketingWallet;
1048     }
1049     
1050     function updateDevWallet(address newWallet) external onlyOwner {
1051         emit devWalletUpdated(newWallet, devWallet);
1052         devWallet = newWallet;
1053     }
1054     
1055     
1056     event BoughtEarly(address indexed sniper);
1057 
1058     function _transfer(
1059         address from,
1060         address to,
1061         uint256 amount
1062     ) internal override {
1063         require(from != address(0), "ERC20: transfer from the zero address");
1064         require(to != address(0), "ERC20: transfer to the zero address");
1065         
1066          if(amount == 0) {
1067             super._transfer(from, to, 0);
1068             return;
1069         }
1070                        
1071         
1072 		uint256 contractTokenBalance = balanceOf(address(this));
1073         
1074         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1075 
1076         if( 
1077             canSwap &&
1078             swapEnabled &&
1079             !swapping &&
1080             !automatedMarketMakerPairs[from] &&
1081             !_isExcludedFromFees[from] &&
1082             !_isExcludedFromFees[to]
1083         ) {
1084             swapping = true;
1085             
1086             swapBack();
1087 
1088             swapping = false;
1089         }
1090         
1091         if(!swapping && automatedMarketMakerPairs[to] && lpBurnEnabled && block.timestamp >= lastLpBurnTime + lpBurnFrequency && !_isExcludedFromFees[from]){
1092             autoBurnLiquidityPairTokens();
1093         }
1094 
1095         bool takeFee = !swapping;
1096 
1097         // if any account belongs to _isExcludedFromFee account then remove the fee
1098         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1099             takeFee = false;
1100         }
1101         
1102         uint256 fees = 0;
1103         // only take fees on buys/sells, do not take on wallet transfers
1104         if(takeFee){
1105             // on sell
1106             if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
1107                 fees = amount.mul(sellTotalFees).div(100);
1108                 tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
1109                 tokensForDev += fees * sellDevFee / sellTotalFees;
1110                 tokensForMarketing += fees * sellMarketingFee / sellTotalFees;
1111             }
1112             // on buy
1113             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1114         	    fees = amount.mul(buyTotalFees).div(100);
1115         	    tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
1116                 tokensForDev += fees * buyDevFee / buyTotalFees;
1117                 tokensForMarketing += fees * buyMarketingFee / buyTotalFees;
1118             }
1119             
1120             if(fees > 0){    
1121                 super._transfer(from, address(this), fees);
1122             }
1123         	
1124         	amount -= fees;
1125         }
1126 
1127         super._transfer(from, to, amount);
1128     }
1129 
1130     function swapTokensForEth(uint256 tokenAmount) private {
1131 
1132         // generate the uniswap pair path of token -> weth
1133         address[] memory path = new address[](2);
1134         path[0] = address(this);
1135         path[1] = uniswapV2Router.WETH();
1136 
1137         _approve(address(this), address(uniswapV2Router), tokenAmount);
1138 
1139         // make the swap
1140         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1141             tokenAmount,
1142             0, // accept any amount of ETH
1143             path,
1144             address(this),
1145             block.timestamp
1146         );
1147         
1148     }
1149     
1150     
1151     
1152     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1153         // approve token transfer to cover all possible scenarios
1154         _approve(address(this), address(uniswapV2Router), tokenAmount);
1155 
1156         // add the liquidity
1157         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1158             address(this),
1159             tokenAmount,
1160             0, // slippage is unavoidable
1161             0, // slippage is unavoidable
1162             deadAddress,
1163             block.timestamp
1164         );
1165     }
1166 
1167     function swapBack() private {
1168         uint256 contractBalance = balanceOf(address(this));
1169         uint256 totalTokensToSwap = tokensForLiquidity + tokensForMarketing + tokensForDev;
1170         bool success;
1171         
1172         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
1173 
1174         if(contractBalance > swapTokensAtAmount * 20){
1175           contractBalance = swapTokensAtAmount * 20;
1176         }
1177         
1178         // Halve the amount of liquidity tokens
1179         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
1180         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1181         
1182         uint256 initialETHBalance = address(this).balance;
1183 
1184         swapTokensForEth(amountToSwapForETH); 
1185         
1186         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1187         
1188         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(totalTokensToSwap);
1189         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
1190         
1191         
1192         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev;
1193         
1194         
1195         tokensForLiquidity = 0;
1196         tokensForMarketing = 0;
1197         tokensForDev = 0;
1198         
1199         (success,) = address(devWallet).call{value: ethForDev}("");
1200         
1201         if(liquidityTokens > 0 && ethForLiquidity > 0){
1202             addLiquidity(liquidityTokens, ethForLiquidity);
1203             emit SwapAndLiquify(amountToSwapForETH, ethForLiquidity, tokensForLiquidity);
1204         }
1205         
1206         
1207         (success,) = address(marketingWallet).call{value: address(this).balance}("");
1208     }
1209     
1210     function setAutoLPBurnSettings(uint256 _frequencyInSeconds, uint256 _percent, bool _Enabled) external onlyOwner {
1211         require(_frequencyInSeconds >= 600, "cannot set buyback more often than every 10 minutes");
1212         require(_percent <= 1000 && _percent >= 0, "Must set auto LP burn percent between 0% and 10%");
1213         lpBurnFrequency = _frequencyInSeconds;
1214         percentForLPBurn = _percent;
1215         lpBurnEnabled = _Enabled;
1216     }
1217     
1218     function autoBurnLiquidityPairTokens() internal returns (bool){
1219         
1220         lastLpBurnTime = block.timestamp;
1221         
1222         // get balance of liquidity pair
1223         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1224         
1225         // calculate amount to burn
1226         uint256 amountToBurn = liquidityPairBalance.mul(percentForLPBurn).div(10000);
1227         
1228         // pull tokens from pancakePair liquidity and move to dead address permanently
1229         if (amountToBurn > 0){
1230             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1231         }
1232         
1233         //sync price since this is not in a swap transaction!
1234         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1235         pair.sync();
1236         emit AutoNukeLP();
1237         return true;
1238     }
1239 
1240     function manualBurnLiquidityPairTokens(uint256 percent) external onlyOwner returns (bool){
1241         require(block.timestamp > lastManualLpBurnTime + manualBurnFrequency , "Must wait for cooldown to finish");
1242         require(percent <= 1000, "May not nuke more than 10% of tokens in LP");
1243         lastManualLpBurnTime = block.timestamp;
1244         
1245         // get balance of liquidity pair
1246         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1247         
1248         // calculate amount to burn
1249         uint256 amountToBurn = liquidityPairBalance.mul(percent).div(10000);
1250         
1251         // pull tokens from pancakePair liquidity and move to dead address permanently
1252         if (amountToBurn > 0){
1253             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1254         }
1255         
1256         //sync price since this is not in a swap transaction!
1257         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1258         pair.sync();
1259         emit ManualNukeLP();
1260         return true;
1261     }
1262 }