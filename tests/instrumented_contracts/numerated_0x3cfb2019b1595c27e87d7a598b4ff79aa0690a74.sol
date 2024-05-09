1 /**
2 
3 
4 Total supply - 1,000,000
5 
6 
7             ***High sell tax until jeets fuck off****
8                       ***5/5 after that****
9 
10 Tax Distribution - 
11 R&D - 3% 
12 Marketing - 2%
13 
14           -------------LINKS-------------
15 
16 Telegram -   https://t.me/bionicinu
17 Twitter-   https://twitter.com/bionicinu
18 Telegram -   https://bionicinu.com
19 
20  */
21 
22 
23 
24 // SPDX-License-Identifier: Unlicensed
25 
26 pragma solidity 0.8.9;
27 
28 abstract contract Context {
29     function _msgSender() internal view virtual returns (address) {
30         return msg.sender;
31     }
32  
33     function _msgData() internal view virtual returns (bytes calldata) {
34         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
35         return msg.data;
36     }
37 }
38  
39 interface IUniswapV2Pair {
40     event Approval(address indexed owner, address indexed spender, uint value);
41     event Transfer(address indexed from, address indexed to, uint value);
42  
43     function name() external pure returns (string memory);
44     function symbol() external pure returns (string memory);
45     function decimals() external pure returns (uint8);
46     function totalSupply() external view returns (uint);
47     function balanceOf(address owner) external view returns (uint);
48     function allowance(address owner, address spender) external view returns (uint);
49  
50     function approve(address spender, uint value) external returns (bool);
51     function transfer(address to, uint value) external returns (bool);
52     function transferFrom(address from, address to, uint value) external returns (bool);
53  
54     function DOMAIN_SEPARATOR() external view returns (bytes32);
55     function PERMIT_TYPEHASH() external pure returns (bytes32);
56     function nonces(address owner) external view returns (uint);
57  
58     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
59  
60     event Mint(address indexed sender, uint amount0, uint amount1);
61     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
62     event Swap(
63         address indexed sender,
64         uint amount0In,
65         uint amount1In,
66         uint amount0Out,
67         uint amount1Out,
68         address indexed to
69     );
70     event Sync(uint112 reserve0, uint112 reserve1);
71  
72     function MINIMUM_LIQUIDITY() external pure returns (uint);
73     function factory() external view returns (address);
74     function token0() external view returns (address);
75     function token1() external view returns (address);
76     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
77     function price0CumulativeLast() external view returns (uint);
78     function price1CumulativeLast() external view returns (uint);
79     function kLast() external view returns (uint);
80  
81     function mint(address to) external returns (uint liquidity);
82     function burn(address to) external returns (uint amount0, uint amount1);
83     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
84     function skim(address to) external;
85     function sync() external;
86  
87     function initialize(address, address) external;
88 }
89  
90 interface IUniswapV2Factory {
91     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
92  
93     function feeTo() external view returns (address);
94     function feeToSetter() external view returns (address);
95  
96     function getPair(address tokenA, address tokenB) external view returns (address pair);
97     function allPairs(uint) external view returns (address pair);
98     function allPairsLength() external view returns (uint);
99  
100     function createPair(address tokenA, address tokenB) external returns (address pair);
101  
102     function setFeeTo(address) external;
103     function setFeeToSetter(address) external;
104 }
105  
106 interface IERC20 {
107     /**
108      * @dev Returns the amount of tokens in existence.
109      */
110     function totalSupply() external view returns (uint256);
111  
112     /**
113      * @dev Returns the amount of tokens owned by `account`.
114      */
115     function balanceOf(address account) external view returns (uint256);
116  
117     /**
118      * @dev Moves `amount` tokens from the caller's account to `recipient`.
119      *
120      * Returns a boolean value indicating whether the operation succeeded.
121      *
122      * Emits a {Transfer} event.
123      */
124     function transfer(address recipient, uint256 amount) external returns (bool);
125  
126     /**
127      * @dev Returns the remaining number of tokens that `spender` will be
128      * allowed to spend on behalf of `owner` through {transferFrom}. This is
129      * zero by default.
130      *
131      * This value changes when {approve} or {transferFrom} are called.
132      */
133     function allowance(address owner, address spender) external view returns (uint256);
134  
135     /**
136      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
137      *
138      * Returns a boolean value indicating whether the operation succeeded.
139      *
140      * IMPORTANT: Beware that changing an allowance with this method brings the risk
141      * that someone may use both the old and the new allowance by unfortunate
142      * transaction ordering. One possible solution to mitigate this race
143      * condition is to first reduce the spender's allowance to 0 and set the
144      * desired value afterwards:
145      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
146      *
147      * Emits an {Approval} event.
148      */
149     function approve(address spender, uint256 amount) external returns (bool);
150  
151     /**
152      * @dev Moves `amount` tokens from `sender` to `recipient` using the
153      * allowance mechanism. `amount` is then deducted from the caller's
154      * allowance.
155      *
156      * Returns a boolean value indicating whether the operation succeeded.
157      *
158      * Emits a {Transfer} event.
159      */
160     function transferFrom(
161         address sender,
162         address recipient,
163         uint256 amount
164     ) external returns (bool);
165  
166     /**
167      * @dev Emitted when `value` tokens are moved from one account (`from`) to
168      * another (`to`).
169      *
170      * Note that `value` may be zero.
171      */
172     event Transfer(address indexed from, address indexed to, uint256 value);
173  
174     /**
175      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
176      * a call to {approve}. `value` is the new allowance.
177      */
178     event Approval(address indexed owner, address indexed spender, uint256 value);
179 }
180  
181 interface IERC20Metadata is IERC20 {
182     /**
183      * @dev Returns the name of the token.
184      */
185     function name() external view returns (string memory);
186  
187     /**
188      * @dev Returns the symbol of the token.
189      */
190     function symbol() external view returns (string memory);
191  
192     /**
193      * @dev Returns the decimals places of the token.
194      */
195     function decimals() external view returns (uint8);
196 }
197  
198  
199 contract ERC20 is Context, IERC20, IERC20Metadata {
200     using SafeMath for uint256;
201  
202     mapping(address => uint256) private _balances;
203  
204     mapping(address => mapping(address => uint256)) private _allowances;
205  
206     uint256 private _totalSupply;
207  
208     string private _name;
209     string private _symbol;
210  
211     /**
212      * @dev Sets the values for {name} and {symbol}.
213      *
214      * The default value of {decimals} is 18. To select a different value for
215      * {decimals} you should overload it.
216      *
217      * All two of these values are immutable: they can only be set once during
218      * construction.
219      */
220     constructor(string memory name_, string memory symbol_) {
221         _name = name_;
222         _symbol = symbol_;
223     }
224  
225     /**
226      * @dev Returns the name of the token.
227      */
228     function name() public view virtual override returns (string memory) {
229         return _name;
230     }
231  
232     /**
233      * @dev Returns the symbol of the token, usually a shorter version of the
234      * name.
235      */
236     function symbol() public view virtual override returns (string memory) {
237         return _symbol;
238     }
239  
240     /**
241      * @dev Returns the number of decimals used to get its user representation.
242      * For example, if `decimals` equals `2`, a balance of `505` tokens should
243      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
244      *
245      * Tokens usually opt for a value of 18, imitating the relationship between
246      * Ether and Wei. This is the value {ERC20} uses, unless this function is
247      * overridden;
248      *
249      * NOTE: This information is only used for _display_ purposes: it in
250      * no way affects any of the arithmetic of the contract, including
251      * {IERC20-balanceOf} and {IERC20-transfer}.
252      */
253     function decimals() public view virtual override returns (uint8) {
254         return 18;
255     }
256  
257     /**
258      * @dev See {IERC20-totalSupply}.
259      */
260     function totalSupply() public view virtual override returns (uint256) {
261         return _totalSupply;
262     }
263  
264     /**
265      * @dev See {IERC20-balanceOf}.
266      */
267     function balanceOf(address account) public view virtual override returns (uint256) {
268         return _balances[account];
269     }
270  
271     /**
272      * @dev See {IERC20-transfer}.
273      *
274      * Requirements:
275      *
276      * - `recipient` cannot be the zero address.
277      * - the caller must have a balance of at least `amount`.
278      */
279     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
280         _transfer(_msgSender(), recipient, amount);
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
294      * Requirements:
295      *
296      * - `spender` cannot be the zero address.
297      */
298     function approve(address spender, uint256 amount) public virtual override returns (bool) {
299         _approve(_msgSender(), spender, amount);
300         return true;
301     }
302  
303     /**
304      * @dev See {IERC20-transferFrom}.
305      *
306      * Emits an {Approval} event indicating the updated allowance. This is not
307      * required by the EIP. See the note at the beginning of {ERC20}.
308      *
309      * Requirements:
310      *
311      * - `sender` and `recipient` cannot be the zero address.
312      * - `sender` must have a balance of at least `amount`.
313      * - the caller must have allowance for ``sender``'s tokens of at least
314      * `amount`.
315      */
316     function transferFrom(
317         address sender,
318         address recipient,
319         uint256 amount
320     ) public virtual override returns (bool) {
321         _transfer(sender, recipient, amount);
322         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
323         return true;
324     }
325  
326     /**
327      * @dev Atomically increases the allowance granted to `spender` by the caller.
328      *
329      * This is an alternative to {approve} that can be used as a mitigation for
330      * problems described in {IERC20-approve}.
331      *
332      * Emits an {Approval} event indicating the updated allowance.
333      *
334      * Requirements:
335      *
336      * - `spender` cannot be the zero address.
337      */
338     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
339         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
340         return true;
341     }
342  
343     /**
344      * @dev Atomically decreases the allowance granted to `spender` by the caller.
345      *
346      * This is an alternative to {approve} that can be used as a mitigation for
347      * problems described in {IERC20-approve}.
348      *
349      * Emits an {Approval} event indicating the updated allowance.
350      *
351      * Requirements:
352      *
353      * - `spender` cannot be the zero address.
354      * - `spender` must have allowance for the caller of at least
355      * `subtractedValue`.
356      */
357     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
358         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
359         return true;
360     }
361  
362     /**
363      * @dev Moves tokens `amount` from `sender` to `recipient`.
364      *
365      * This is internal function is equivalent to {transfer}, and can be used to
366      * e.g. implement automatic token fees, slashing mechanisms, etc.
367      *
368      * Emits a {Transfer} event.
369      *
370      * Requirements:
371      *
372      * - `sender` cannot be the zero address.
373      * - `recipient` cannot be the zero address.
374      * - `sender` must have a balance of at least `amount`.
375      */
376     function _transfer(
377         address sender,
378         address recipient,
379         uint256 amount
380     ) internal virtual {
381         require(sender != address(0), "ERC20: transfer from the zero address");
382         require(recipient != address(0), "ERC20: transfer to the zero address");
383  
384         _beforeTokenTransfer(sender, recipient, amount);
385  
386         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
387         _balances[recipient] = _balances[recipient].add(amount);
388         emit Transfer(sender, recipient, amount);
389     }
390  
391     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
392      * the total supply.
393      *
394      * Emits a {Transfer} event with `from` set to the zero address.
395      *
396      * Requirements:
397      *
398      * - `account` cannot be the zero address.
399      */
400     function _mint(address account, uint256 amount) internal virtual {
401         require(account != address(0), "ERC20: mint to the zero address");
402  
403         _beforeTokenTransfer(address(0), account, amount);
404  
405         _totalSupply = _totalSupply.add(amount);
406         _balances[account] = _balances[account].add(amount);
407         emit Transfer(address(0), account, amount);
408     }
409  
410     /**
411      * @dev Destroys `amount` tokens from `account`, reducing the
412      * total supply.
413      *
414      * Emits a {Transfer} event with `to` set to the zero address.
415      *
416      * Requirements:
417      *
418      * - `account` cannot be the zero address.
419      * - `account` must have at least `amount` tokens.
420      */
421     function _burn(address account, uint256 amount) internal virtual {
422         require(account != address(0), "ERC20: burn from the zero address");
423  
424         _beforeTokenTransfer(account, address(0), amount);
425  
426         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
427         _totalSupply = _totalSupply.sub(amount);
428         emit Transfer(account, address(0), amount);
429     }
430  
431     /**
432      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
433      *
434      * This internal function is equivalent to `approve`, and can be used to
435      * e.g. set automatic allowances for certain subsystems, etc.
436      *
437      * Emits an {Approval} event.
438      *
439      * Requirements:
440      *
441      * - `owner` cannot be the zero address.
442      * - `spender` cannot be the zero address.
443      */
444     function _approve(
445         address owner,
446         address spender,
447         uint256 amount
448     ) internal virtual {
449         require(owner != address(0), "ERC20: approve from the zero address");
450         require(spender != address(0), "ERC20: approve to the zero address");
451  
452         _allowances[owner][spender] = amount;
453         emit Approval(owner, spender, amount);
454     }
455  
456     /**
457      * @dev Hook that is called before any transfer of tokens. This includes
458      * minting and burning.
459      *
460      * Calling conditions:
461      *
462      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
463      * will be to transferred to `to`.
464      * - when `from` is zero, `amount` tokens will be minted for `to`.
465      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
466      * - `from` and `to` are never both zero.
467      *
468      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
469      */
470     function _beforeTokenTransfer(
471         address from,
472         address to,
473         uint256 amount
474     ) internal virtual {}
475 }
476  
477 library SafeMath {
478     /**
479      * @dev Returns the addition of two unsigned integers, reverting on
480      * overflow.
481      *
482      * Counterpart to Solidity's `+` operator.
483      *
484      * Requirements:
485      *
486      * - Addition cannot overflow.
487      */
488     function add(uint256 a, uint256 b) internal pure returns (uint256) {
489         uint256 c = a + b;
490         require(c >= a, "SafeMath: addition overflow");
491  
492         return c;
493     }
494  
495     /**
496      * @dev Returns the subtraction of two unsigned integers, reverting on
497      * overflow (when the result is negative).
498      *
499      * Counterpart to Solidity's `-` operator.
500      *
501      * Requirements:
502      *
503      * - Subtraction cannot overflow.
504      */
505     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
506         return sub(a, b, "SafeMath: subtraction overflow");
507     }
508  
509     /**
510      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
511      * overflow (when the result is negative).
512      *
513      * Counterpart to Solidity's `-` operator.
514      *
515      * Requirements:
516      *
517      * - Subtraction cannot overflow.
518      */
519     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
520         require(b <= a, errorMessage);
521         uint256 c = a - b;
522  
523         return c;
524     }
525  
526     /**
527      * @dev Returns the multiplication of two unsigned integers, reverting on
528      * overflow.
529      *
530      * Counterpart to Solidity's `*` operator.
531      *
532      * Requirements:
533      *
534      * - Multiplication cannot overflow.
535      */
536     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
537         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
538         // benefit is lost if 'b' is also tested.
539         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
540         if (a == 0) {
541             return 0;
542         }
543  
544         uint256 c = a * b;
545         require(c / a == b, "SafeMath: multiplication overflow");
546  
547         return c;
548     }
549  
550     /**
551      * @dev Returns the integer division of two unsigned integers. Reverts on
552      * division by zero. The result is rounded towards zero.
553      *
554      * Counterpart to Solidity's `/` operator. Note: this function uses a
555      * `revert` opcode (which leaves remaining gas untouched) while Solidity
556      * uses an invalid opcode to revert (consuming all remaining gas).
557      *
558      * Requirements:
559      *
560      * - The divisor cannot be zero.
561      */
562     function div(uint256 a, uint256 b) internal pure returns (uint256) {
563         return div(a, b, "SafeMath: division by zero");
564     }
565  
566     /**
567      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
568      * division by zero. The result is rounded towards zero.
569      *
570      * Counterpart to Solidity's `/` operator. Note: this function uses a
571      * `revert` opcode (which leaves remaining gas untouched) while Solidity
572      * uses an invalid opcode to revert (consuming all remaining gas).
573      *
574      * Requirements:
575      *
576      * - The divisor cannot be zero.
577      */
578     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
579         require(b > 0, errorMessage);
580         uint256 c = a / b;
581         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
582  
583         return c;
584     }
585  
586     /**
587      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
588      * Reverts when dividing by zero.
589      *
590      * Counterpart to Solidity's `%` operator. This function uses a `revert`
591      * opcode (which leaves remaining gas untouched) while Solidity uses an
592      * invalid opcode to revert (consuming all remaining gas).
593      *
594      * Requirements:
595      *
596      * - The divisor cannot be zero.
597      */
598     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
599         return mod(a, b, "SafeMath: modulo by zero");
600     }
601  
602     /**
603      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
604      * Reverts with custom message when dividing by zero.
605      *
606      * Counterpart to Solidity's `%` operator. This function uses a `revert`
607      * opcode (which leaves remaining gas untouched) while Solidity uses an
608      * invalid opcode to revert (consuming all remaining gas).
609      *
610      * Requirements:
611      *
612      * - The divisor cannot be zero.
613      */
614     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
615         require(b != 0, errorMessage);
616         return a % b;
617     }
618 }
619  
620 contract Ownable is Context {
621     address private _owner;
622  
623     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
624  
625     /**
626      * @dev Initializes the contract setting the deployer as the initial owner.
627      */
628     constructor () {
629         address msgSender = _msgSender();
630         _owner = msgSender;
631         emit OwnershipTransferred(address(0), msgSender);
632     }
633  
634     /**
635      * @dev Returns the address of the current owner.
636      */
637     function owner() public view returns (address) {
638         return _owner;
639     }
640  
641     /**
642      * @dev Throws if called by any account other than the owner.
643      */
644     modifier onlyOwner() {
645         require(_owner == _msgSender(), "Ownable: caller is not the owner");
646         _;
647     }
648  
649     /**
650      * @dev Leaves the contract without owner. It will not be possible to call
651      * `onlyOwner` functions anymore. Can only be called by the current owner.
652      *
653      * NOTE: Renouncing ownership will leave the contract without an owner,
654      * thereby removing any functionality that is only available to the owner.
655      */
656     function renounceOwnership() public virtual onlyOwner {
657         emit OwnershipTransferred(_owner, address(0));
658         _owner = address(0);
659     }
660  
661     /**
662      * @dev Transfers ownership of the contract to a new account (`newOwner`).
663      * Can only be called by the current owner.
664      */
665     function transferOwnership(address newOwner) public virtual onlyOwner {
666         require(newOwner != address(0), "Ownable: new owner is the zero address");
667         emit OwnershipTransferred(_owner, newOwner);
668         _owner = newOwner;
669     }
670 }
671  
672  
673  
674 library SafeMathInt {
675     int256 private constant MIN_INT256 = int256(1) << 255;
676     int256 private constant MAX_INT256 = ~(int256(1) << 255);
677  
678     /**
679      * @dev Multiplies two int256 variables and fails on overflow.
680      */
681     function mul(int256 a, int256 b) internal pure returns (int256) {
682         int256 c = a * b;
683  
684         // Detect overflow when multiplying MIN_INT256 with -1
685         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
686         require((b == 0) || (c / b == a));
687         return c;
688     }
689  
690     /**
691      * @dev Division of two int256 variables and fails on overflow.
692      */
693     function div(int256 a, int256 b) internal pure returns (int256) {
694         // Prevent overflow when dividing MIN_INT256 by -1
695         require(b != -1 || a != MIN_INT256);
696  
697         // Solidity already throws when dividing by 0.
698         return a / b;
699     }
700  
701     /**
702      * @dev Subtracts two int256 variables and fails on overflow.
703      */
704     function sub(int256 a, int256 b) internal pure returns (int256) {
705         int256 c = a - b;
706         require((b >= 0 && c <= a) || (b < 0 && c > a));
707         return c;
708     }
709  
710     /**
711      * @dev Adds two int256 variables and fails on overflow.
712      */
713     function add(int256 a, int256 b) internal pure returns (int256) {
714         int256 c = a + b;
715         require((b >= 0 && c >= a) || (b < 0 && c < a));
716         return c;
717     }
718  
719     /**
720      * @dev Converts to absolute value, and fails on overflow.
721      */
722     function abs(int256 a) internal pure returns (int256) {
723         require(a != MIN_INT256);
724         return a < 0 ? -a : a;
725     }
726  
727  
728     function toUint256Safe(int256 a) internal pure returns (uint256) {
729         require(a >= 0);
730         return uint256(a);
731     }
732 }
733  
734 library SafeMathUint {
735   function toInt256Safe(uint256 a) internal pure returns (int256) {
736     int256 b = int256(a);
737     require(b >= 0);
738     return b;
739   }
740 }
741  
742  
743 interface IUniswapV2Router01 {
744     function factory() external pure returns (address);
745     function WETH() external pure returns (address);
746  
747     function addLiquidity(
748         address tokenA,
749         address tokenB,
750         uint amountADesired,
751         uint amountBDesired,
752         uint amountAMin,
753         uint amountBMin,
754         address to,
755         uint deadline
756     ) external returns (uint amountA, uint amountB, uint liquidity);
757     function addLiquidityETH(
758         address token,
759         uint amountTokenDesired,
760         uint amountTokenMin,
761         uint amountETHMin,
762         address to,
763         uint deadline
764     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
765     function removeLiquidity(
766         address tokenA,
767         address tokenB,
768         uint liquidity,
769         uint amountAMin,
770         uint amountBMin,
771         address to,
772         uint deadline
773     ) external returns (uint amountA, uint amountB);
774     function removeLiquidityETH(
775         address token,
776         uint liquidity,
777         uint amountTokenMin,
778         uint amountETHMin,
779         address to,
780         uint deadline
781     ) external returns (uint amountToken, uint amountETH);
782     function removeLiquidityWithPermit(
783         address tokenA,
784         address tokenB,
785         uint liquidity,
786         uint amountAMin,
787         uint amountBMin,
788         address to,
789         uint deadline,
790         bool approveMax, uint8 v, bytes32 r, bytes32 s
791     ) external returns (uint amountA, uint amountB);
792     function removeLiquidityETHWithPermit(
793         address token,
794         uint liquidity,
795         uint amountTokenMin,
796         uint amountETHMin,
797         address to,
798         uint deadline,
799         bool approveMax, uint8 v, bytes32 r, bytes32 s
800     ) external returns (uint amountToken, uint amountETH);
801     function swapExactTokensForTokens(
802         uint amountIn,
803         uint amountOutMin,
804         address[] calldata path,
805         address to,
806         uint deadline
807     ) external returns (uint[] memory amounts);
808     function swapTokensForExactTokens(
809         uint amountOut,
810         uint amountInMax,
811         address[] calldata path,
812         address to,
813         uint deadline
814     ) external returns (uint[] memory amounts);
815     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
816         external
817         payable
818         returns (uint[] memory amounts);
819     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
820         external
821         returns (uint[] memory amounts);
822     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
823         external
824         returns (uint[] memory amounts);
825     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
826         external
827         payable
828         returns (uint[] memory amounts);
829  
830     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
831     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
832     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
833     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
834     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
835 }
836  
837 interface IUniswapV2Router02 is IUniswapV2Router01 {
838     function removeLiquidityETHSupportingFeeOnTransferTokens(
839         address token,
840         uint liquidity,
841         uint amountTokenMin,
842         uint amountETHMin,
843         address to,
844         uint deadline
845     ) external returns (uint amountETH);
846     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
847         address token,
848         uint liquidity,
849         uint amountTokenMin,
850         uint amountETHMin,
851         address to,
852         uint deadline,
853         bool approveMax, uint8 v, bytes32 r, bytes32 s
854     ) external returns (uint amountETH);
855  
856     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
857         uint amountIn,
858         uint amountOutMin,
859         address[] calldata path,
860         address to,
861         uint deadline
862     ) external;
863     function swapExactETHForTokensSupportingFeeOnTransferTokens(
864         uint amountOutMin,
865         address[] calldata path,
866         address to,
867         uint deadline
868     ) external payable;
869     function swapExactTokensForETHSupportingFeeOnTransferTokens(
870         uint amountIn,
871         uint amountOutMin,
872         address[] calldata path,
873         address to,
874         uint deadline
875     ) external;
876 }
877  
878 contract BIONIC is ERC20, Ownable {
879     using SafeMath for uint256;
880  
881     IUniswapV2Router02 public immutable uniswapV2Router;
882     address public immutable uniswapV2Pair;
883     address public constant deadAddress = address(0x000000000000000000000000000000000000dEaD);
884  
885     bool private swapping;
886  
887     address public marketingWallet;
888     address public devWallet;
889  
890     uint256 public maxTransactionAmount;
891     uint256 public swapTokensAtAmount;
892     uint256 public maxWallet;
893  
894     uint256 public percentForLPBurn = 10; // 10 = .10%
895     bool public lpBurnEnabled = true;
896     uint256 public lpBurnFrequency = 7200 seconds;
897     uint256 public lastLpBurnTime;
898  
899     uint256 public manualBurnFrequency = 30 minutes;
900     uint256 public lastManualLpBurnTime;
901  
902     bool public limitsInEffect = true;
903     bool public tradingActive = false;
904     bool public swapEnabled = false;
905     bool public enableEarlySellTax = true;
906  
907      // Anti-bot and anti-whale mappings and variables
908     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
909  
910     // Seller Map
911     mapping (address => uint256) private _holderFirstBuyTimestamp;
912  
913     // Blacklist Map
914     mapping (address => bool) private _blacklist;
915     bool public transferDelayEnabled = true;
916  
917     uint256 public buyTotalFees;
918     uint256 public buyMarketingFee;
919     uint256 public buyLiquidityFee;
920     uint256 public buyDevFee;
921  
922     uint256 public sellTotalFees;
923     uint256 public sellMarketingFee;
924     uint256 public sellLiquidityFee;
925     uint256 public sellDevFee;
926  
927     uint256 public earlySellLiquidityFee;
928     uint256 public earlySellMarketingFee;
929  
930     uint256 public tokensForMarketing;
931     uint256 public tokensForLiquidity;
932     uint256 public tokensForDev;
933  
934     // block number of opened trading
935     uint256 launchedAt;
936  
937     /******************/
938  
939     // exclude from fees and max transaction amount
940     mapping (address => bool) private _isExcludedFromFees;
941     mapping (address => bool) public _isExcludedMaxTransactionAmount;
942  
943     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
944     // could be subject to a maximum transfer amount
945     mapping (address => bool) public automatedMarketMakerPairs;
946  
947     event UpdateUniswapV2Router(address indexed newAddress, address indexed oldAddress);
948  
949     event ExcludeFromFees(address indexed account, bool isExcluded);
950  
951     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
952  
953     event marketingWalletUpdated(address indexed newWallet, address indexed oldWallet);
954  
955     event devWalletUpdated(address indexed newWallet, address indexed oldWallet);
956  
957     event SwapAndLiquify(
958         uint256 tokensSwapped,
959         uint256 ethReceived,
960         uint256 tokensIntoLiquidity
961     );
962  
963     event AutoNukeLP();
964  
965     event ManualNukeLP();
966  
967     constructor() ERC20("Bionic Inu", "BIONIC") {
968  
969         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
970  
971         excludeFromMaxTransaction(address(_uniswapV2Router), true);
972         uniswapV2Router = _uniswapV2Router;
973  
974         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
975         excludeFromMaxTransaction(address(uniswapV2Pair), true);
976         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
977  
978         uint256 _buyMarketingFee = 5;
979         uint256 _buyLiquidityFee = 0;
980         uint256 _buyDevFee = 0;
981  
982         uint256 _sellMarketingFee = 25;
983         uint256 _sellLiquidityFee = 0;
984         uint256 _sellDevFee = 0;
985  
986         uint256 _earlySellLiquidityFee = 0;
987         uint256 _earlySellMarketingFee = 0;
988  
989         uint256 totalSupply = 1 * 1e12 * 1e18;
990  
991         maxTransactionAmount = totalSupply * 20 / 1000; // 2% maxTransactionAmountTxn
992         maxWallet = totalSupply * 20 / 1000; // 2% maxWallet
993         swapTokensAtAmount = totalSupply * 5 / 10000; // 0.05% swap wallet
994  
995         buyMarketingFee = _buyMarketingFee;
996         buyLiquidityFee = _buyLiquidityFee;
997         buyDevFee = _buyDevFee;
998         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
999  
1000         sellMarketingFee = _sellMarketingFee;
1001         sellLiquidityFee = _sellLiquidityFee;
1002         sellDevFee = _sellDevFee;
1003         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1004  
1005         earlySellLiquidityFee = _earlySellLiquidityFee;
1006         earlySellMarketingFee = _earlySellMarketingFee;
1007  
1008         marketingWallet = address(owner()); // set as marketing wallet
1009         devWallet = address(owner()); // set as dev wallet
1010  
1011         // exclude from paying fees or having max transaction amount
1012         excludeFromFees(owner(), true);
1013         excludeFromFees(address(this), true);
1014         excludeFromFees(address(0xdead), true);
1015  
1016         excludeFromMaxTransaction(owner(), true);
1017         excludeFromMaxTransaction(address(this), true);
1018         excludeFromMaxTransaction(address(0xdead), true);
1019  
1020         /*
1021             _mint is an internal function in ERC20.sol that is only called here,
1022             and CANNOT be called ever again
1023         */
1024         _mint(msg.sender, totalSupply);
1025     }
1026  
1027     receive() external payable {
1028  
1029   	}
1030  
1031     // once enabled, can never be turned off
1032     function enableTrading() external onlyOwner {
1033         tradingActive = true;
1034         swapEnabled = true;
1035         lastLpBurnTime = block.timestamp;
1036         launchedAt = block.number;
1037     }
1038  
1039     // remove limits after token is stable
1040     function removeLimits() external onlyOwner returns (bool){
1041         limitsInEffect = false;
1042         return true;
1043     }
1044  
1045     // disable Transfer delay - cannot be reenabled
1046     function disableTransferDelay() external onlyOwner returns (bool){
1047         transferDelayEnabled = false;
1048         return true;
1049     }
1050  
1051     function setEarlySellTax(bool onoff) external onlyOwner  {
1052         enableEarlySellTax = onoff;
1053     }
1054  
1055      // change the minimum amount of tokens to sell from fees
1056     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner returns (bool){
1057   	    require(newAmount >= totalSupply() * 1 / 100000, "Swap amount cannot be lower than 0.001% total supply.");
1058   	    require(newAmount <= totalSupply() * 5 / 1000, "Swap amount cannot be higher than 0.5% total supply.");
1059   	    swapTokensAtAmount = newAmount;
1060   	    return true;
1061   	}
1062  
1063     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
1064         require(newNum >= (totalSupply() * 1 / 1000)/1e18, "Cannot set maxTransactionAmount lower than 0.1%");
1065         maxTransactionAmount = newNum * (10**18);
1066     }
1067  
1068     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
1069         require(newNum >= (totalSupply() * 5 / 1000)/1e18, "Cannot set maxWallet lower than 0.5%");
1070         maxWallet = newNum * (10**18);
1071     }
1072  
1073     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
1074         _isExcludedMaxTransactionAmount[updAds] = isEx;
1075     }
1076  
1077     // only use to disable contract sales if absolutely necessary (emergency use only)
1078     function updateSwapEnabled(bool enabled) external onlyOwner(){
1079         swapEnabled = enabled;
1080     }
1081  
1082     function updateBuyFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _devFee) external onlyOwner {
1083         buyMarketingFee = _marketingFee;
1084         buyLiquidityFee = _liquidityFee;
1085         buyDevFee = _devFee;
1086         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
1087         require(buyTotalFees <= 20, "Must keep fees at 20% or less");
1088     }
1089  
1090     function updateSellFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _devFee, uint256 _earlySellLiquidityFee, uint256 _earlySellMarketingFee) external onlyOwner {
1091         sellMarketingFee = _marketingFee;
1092         sellLiquidityFee = _liquidityFee;
1093         sellDevFee = _devFee;
1094         earlySellLiquidityFee = _earlySellLiquidityFee;
1095         earlySellMarketingFee = _earlySellMarketingFee;
1096         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1097         require(sellTotalFees <= 25, "Must keep fees at 25% or less");
1098     }
1099  
1100     function excludeFromFees(address account, bool excluded) public onlyOwner {
1101         _isExcludedFromFees[account] = excluded;
1102         emit ExcludeFromFees(account, excluded);
1103     }
1104  
1105     function blacklistAccount (address account, bool isBlacklisted) public onlyOwner {
1106         _blacklist[account] = isBlacklisted;
1107     }
1108  
1109     function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
1110         require(pair != uniswapV2Pair, "The pair cannot be removed from automatedMarketMakerPairs");
1111  
1112         _setAutomatedMarketMakerPair(pair, value);
1113     }
1114  
1115     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1116         automatedMarketMakerPairs[pair] = value;
1117  
1118         emit SetAutomatedMarketMakerPair(pair, value);
1119     }
1120  
1121     function updateMarketingWallet(address newMarketingWallet) external onlyOwner {
1122         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
1123         marketingWallet = newMarketingWallet;
1124     }
1125  
1126     function updateDevWallet(address newWallet) external onlyOwner {
1127         emit devWalletUpdated(newWallet, devWallet);
1128         devWallet = newWallet;
1129     }
1130  
1131  
1132     function isExcludedFromFees(address account) public view returns(bool) {
1133         return _isExcludedFromFees[account];
1134     }
1135  
1136     event BoughtEarly(address indexed sniper);
1137  
1138     function _transfer(
1139         address from,
1140         address to,
1141         uint256 amount
1142     ) internal override {
1143         require(from != address(0), "ERC20: transfer from the zero address");
1144         require(to != address(0), "ERC20: transfer to the zero address");
1145         require(!_blacklist[to] && !_blacklist[from], "You have been blacklisted from transfering tokens");
1146          if(amount == 0) {
1147             super._transfer(from, to, 0);
1148             return;
1149         }
1150  
1151         if(limitsInEffect){
1152             if (
1153                 from != owner() &&
1154                 to != owner() &&
1155                 to != address(0) &&
1156                 to != address(0xdead) &&
1157                 !swapping
1158             ){
1159                 if(!tradingActive){
1160                     require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");
1161                 }
1162  
1163                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.  
1164                 if (transferDelayEnabled){
1165                     if (to != owner() && to != address(uniswapV2Router) && to != address(uniswapV2Pair)){
1166                         require(_holderLastTransferTimestamp[tx.origin] < block.number, "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed.");
1167                         _holderLastTransferTimestamp[tx.origin] = block.number;
1168                     }
1169                 }
1170  
1171                 //when buy
1172                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
1173                         require(amount <= maxTransactionAmount, "Buy transfer amount exceeds the maxTransactionAmount.");
1174                         require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
1175                 }
1176  
1177                 //when sell
1178                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
1179                         require(amount <= maxTransactionAmount, "Sell transfer amount exceeds the maxTransactionAmount.");
1180                 }
1181                 else if(!_isExcludedMaxTransactionAmount[to]){
1182                     require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
1183                 }
1184             }
1185         }
1186  
1187         // anti bot logic
1188         if (block.number <= (launchedAt + 1) && 
1189                 to != uniswapV2Pair && 
1190                 to != address(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D)
1191             ) { 
1192             _blacklist[to] = true;
1193         }
1194  
1195         // early sell logic
1196         bool isBuy = from == uniswapV2Pair;
1197         if (!isBuy && enableEarlySellTax) {
1198             if (_holderFirstBuyTimestamp[from] != 0 &&
1199                 (_holderFirstBuyTimestamp[from] + (24 hours) >= block.timestamp))  {
1200                 sellLiquidityFee = earlySellLiquidityFee;
1201                 sellMarketingFee = earlySellMarketingFee;
1202                 sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1203             } else {
1204                 sellLiquidityFee = 0;
1205                 sellMarketingFee = 0;
1206                 sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1207             }
1208         } else {
1209             if (_holderFirstBuyTimestamp[to] == 0) {
1210                 _holderFirstBuyTimestamp[to] = block.timestamp;
1211             }
1212  
1213             if (!enableEarlySellTax) {
1214                 sellLiquidityFee = 0;
1215                 sellMarketingFee = 0;
1216                 sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1217             }
1218         }
1219  
1220 		uint256 contractTokenBalance = balanceOf(address(this));
1221  
1222         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1223  
1224         if( 
1225             canSwap &&
1226             swapEnabled &&
1227             !swapping &&
1228             !automatedMarketMakerPairs[from] &&
1229             !_isExcludedFromFees[from] &&
1230             !_isExcludedFromFees[to]
1231         ) {
1232             swapping = true;
1233  
1234             swapBack();
1235  
1236             swapping = false;
1237         }
1238  
1239         if(!swapping && automatedMarketMakerPairs[to] && lpBurnEnabled && block.timestamp >= lastLpBurnTime + lpBurnFrequency && !_isExcludedFromFees[from]){
1240             autoBurnLiquidityPairTokens();
1241         }
1242  
1243         bool takeFee = !swapping;
1244  
1245         // if any account belongs to _isExcludedFromFee account then remove the fee
1246         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1247             takeFee = false;
1248         }
1249  
1250         uint256 fees = 0;
1251         // only take fees on buys/sells, do not take on wallet transfers
1252         if(takeFee){
1253             // on sell
1254             if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
1255                 fees = amount.mul(sellTotalFees).div(100);
1256                 tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
1257                 tokensForDev += fees * sellDevFee / sellTotalFees;
1258                 tokensForMarketing += fees * sellMarketingFee / sellTotalFees;
1259             }
1260             // on buy
1261             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1262         	    fees = amount.mul(buyTotalFees).div(100);
1263         	    tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
1264                 tokensForDev += fees * buyDevFee / buyTotalFees;
1265                 tokensForMarketing += fees * buyMarketingFee / buyTotalFees;
1266             }
1267  
1268             if(fees > 0){    
1269                 super._transfer(from, address(this), fees);
1270             }
1271  
1272         	amount -= fees;
1273         }
1274  
1275         super._transfer(from, to, amount);
1276     }
1277  
1278     function swapTokensForEth(uint256 tokenAmount) private {
1279  
1280         // generate the uniswap pair path of token -> weth
1281         address[] memory path = new address[](2);
1282         path[0] = address(this);
1283         path[1] = uniswapV2Router.WETH();
1284  
1285         _approve(address(this), address(uniswapV2Router), tokenAmount);
1286  
1287         // make the swap
1288         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1289             tokenAmount,
1290             0, // accept any amount of ETH
1291             path,
1292             address(this),
1293             block.timestamp
1294         );
1295  
1296     }
1297  
1298  
1299  
1300     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1301         // approve token transfer to cover all possible scenarios
1302         _approve(address(this), address(uniswapV2Router), tokenAmount);
1303  
1304         // add the liquidity
1305         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1306             address(this),
1307             tokenAmount,
1308             0, // slippage is unavoidable
1309             0, // slippage is unavoidable
1310             deadAddress,
1311             block.timestamp
1312         );
1313     }
1314  
1315     function swapBack() private {
1316         uint256 contractBalance = balanceOf(address(this));
1317         uint256 totalTokensToSwap = tokensForLiquidity + tokensForMarketing + tokensForDev;
1318         bool success;
1319  
1320         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
1321  
1322         if(contractBalance > swapTokensAtAmount * 20){
1323           contractBalance = swapTokensAtAmount * 20;
1324         }
1325  
1326         // Halve the amount of liquidity tokens
1327         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
1328         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1329  
1330         uint256 initialETHBalance = address(this).balance;
1331  
1332         swapTokensForEth(amountToSwapForETH); 
1333  
1334         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1335  
1336         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(totalTokensToSwap);
1337         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
1338  
1339  
1340         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev;
1341  
1342  
1343         tokensForLiquidity = 0;
1344         tokensForMarketing = 0;
1345         tokensForDev = 0;
1346  
1347         (success,) = address(devWallet).call{value: ethForDev}("");
1348  
1349         if(liquidityTokens > 0 && ethForLiquidity > 0){
1350             addLiquidity(liquidityTokens, ethForLiquidity);
1351             emit SwapAndLiquify(amountToSwapForETH, ethForLiquidity, tokensForLiquidity);
1352         }
1353  
1354  
1355         (success,) = address(marketingWallet).call{value: address(this).balance}("");
1356     }
1357  
1358     function setAutoLPBurnSettings(uint256 _frequencyInSeconds, uint256 _percent, bool _Enabled) external onlyOwner {
1359         require(_frequencyInSeconds >= 600, "cannot set buyback more often than every 10 minutes");
1360         require(_percent <= 1000 && _percent >= 0, "Must set auto LP burn percent between 0% and 10%");
1361         lpBurnFrequency = _frequencyInSeconds;
1362         percentForLPBurn = _percent;
1363         lpBurnEnabled = _Enabled;
1364     }
1365  
1366     function autoBurnLiquidityPairTokens() internal returns (bool){
1367  
1368         lastLpBurnTime = block.timestamp;
1369  
1370         // get balance of liquidity pair
1371         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1372  
1373         // calculate amount to burn
1374         uint256 amountToBurn = liquidityPairBalance.mul(percentForLPBurn).div(10000);
1375  
1376         // pull tokens from pancakePair liquidity and move to dead address permanently
1377         if (amountToBurn > 0){
1378             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1379         }
1380  
1381         //sync price since this is not in a swap transaction!
1382         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1383         pair.sync();
1384         emit AutoNukeLP();
1385         return true;
1386     }
1387  
1388     function manualBurnLiquidityPairTokens(uint256 percent) external onlyOwner returns (bool){
1389         require(block.timestamp > lastManualLpBurnTime + manualBurnFrequency , "Must wait for cooldown to finish");
1390         require(percent <= 1000, "May not nuke more than 10% of tokens in LP");
1391         lastManualLpBurnTime = block.timestamp;
1392  
1393         // get balance of liquidity pair
1394         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1395  
1396         // calculate amount to burn
1397         uint256 amountToBurn = liquidityPairBalance.mul(percent).div(10000);
1398  
1399         // pull tokens from pancakePair liquidity and move to dead address permanently
1400         if (amountToBurn > 0){
1401             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1402         }
1403  
1404         //sync price since this is not in a swap transaction!
1405         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1406         pair.sync();
1407         emit ManualNukeLP();
1408         return true;
1409     }
1410 }