1 // SPDX-License-Identifier: NOLICENSE
2 
3 /**
4  NAPALM - Napalm Man
5  
6  https://napalmtoken.com/
7 
8  https://t.me/napalmtoken
9 
10 🔥 The biggest hyper deflationary and burn token.
11 
12 🔥 Buy and Sell tax after trading enabled: 5% Buy (burn) tax / 5% Sell (burn) tax + 2% Sell dev tax.
13 
14 🔥 Burns after every transaction
15 The burn will be a true burn and actually remove the tokens from the total tokens reducing the total supply with every transaction. 
16 
17 🔥 NOTE: We have a higher launch sell tax set in place to help kickstart the burning process while volume is high, and to help keep pesty bots out of the project.
18 
19 
20                (  .      )
21            )           (              )
22                  .  '   .   '  .  '  .
23         (    , )       (.   )  (   ',    )
24          .' ) ( . )    ,  ( ,     )   ( .
25       ). , ( .   (  ) ( , ')  .' (  ,    )
26      (_,) . ), ) _) _,')  (, ) '. )  ,. (' )
27     ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
28 
29 */
30 pragma solidity 0.8.9;
31 
32 abstract contract Context {
33     function _msgSender() internal view virtual returns (address) {
34         return msg.sender;
35     }
36 
37     function _msgData() internal view virtual returns (bytes calldata) {
38         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
39         return msg.data;
40     }
41 }
42 
43 interface IUniswapV2Pair {
44     event Approval(address indexed owner, address indexed spender, uint value);
45     event Transfer(address indexed from, address indexed to, uint value);
46 
47     function name() external pure returns (string memory);
48     function symbol() external pure returns (string memory);
49     function decimals() external pure returns (uint8);
50     function totalSupply() external view returns (uint);
51     function balanceOf(address owner) external view returns (uint);
52     function allowance(address owner, address spender) external view returns (uint);
53 
54     function approve(address spender, uint value) external returns (bool);
55     function transfer(address to, uint value) external returns (bool);
56     function transferFrom(address from, address to, uint value) external returns (bool);
57 
58     function DOMAIN_SEPARATOR() external view returns (bytes32);
59     function PERMIT_TYPEHASH() external pure returns (bytes32);
60     function nonces(address owner) external view returns (uint);
61 
62     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
63 
64     event Mint(address indexed sender, uint amount0, uint amount1);
65     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
66     event Swap(
67         address indexed sender,
68         uint amount0In,
69         uint amount1In,
70         uint amount0Out,
71         uint amount1Out,
72         address indexed to
73     );
74     event Sync(uint112 reserve0, uint112 reserve1);
75 
76     function MINIMUM_LIQUIDITY() external pure returns (uint);
77     function factory() external view returns (address);
78     function token0() external view returns (address);
79     function token1() external view returns (address);
80     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
81     function price0CumulativeLast() external view returns (uint);
82     function price1CumulativeLast() external view returns (uint);
83     function kLast() external view returns (uint);
84 
85     function mint(address to) external returns (uint liquidity);
86     function burn(address to) external returns (uint amount0, uint amount1);
87     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
88     function skim(address to) external;
89     function sync() external;
90 
91     function initialize(address, address) external;
92 }
93 
94 interface IUniswapV2Factory {
95     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
96 
97     function feeTo() external view returns (address);
98     function feeToSetter() external view returns (address);
99 
100     function getPair(address tokenA, address tokenB) external view returns (address pair);
101     function allPairs(uint) external view returns (address pair);
102     function allPairsLength() external view returns (uint);
103 
104     function createPair(address tokenA, address tokenB) external returns (address pair);
105 
106     function setFeeTo(address) external;
107     function setFeeToSetter(address) external;
108 }
109 
110 interface IERC20 {
111     /**
112      * @dev Returns the amount of tokens in existence.
113      */
114     function totalSupply() external view returns (uint256);
115 
116     /**
117      * @dev Returns the amount of tokens owned by `account`.
118      */
119     function balanceOf(address account) external view returns (uint256);
120 
121     /**
122      * @dev Moves `amount` tokens from the caller's account to `recipient`.
123      *
124      * Returns a boolean value indicating whether the operation succeeded.
125      *
126      * Emits a {Transfer} event.
127      */
128     function transfer(address recipient, uint256 amount) external returns (bool);
129 
130     /**
131      * @dev Returns the remaining number of tokens that `spender` will be
132      * allowed to spend on behalf of `owner` through {transferFrom}. This is
133      * zero by default.
134      *
135      * This value changes when {approve} or {transferFrom} are called.
136      */
137     function allowance(address owner, address spender) external view returns (uint256);
138 
139     /**
140      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
141      *
142      * Returns a boolean value indicating whether the operation succeeded.
143      *
144      * IMPORTANT: Beware that changing an allowance with this method brings the risk
145      * that someone may use both the old and the new allowance by unfortunate
146      * transaction ordering. One possible solution to mitigate this race
147      * condition is to first reduce the spender's allowance to 0 and set the
148      * desired value afterwards:
149      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
150      *
151      * Emits an {Approval} event.
152      */
153     function approve(address spender, uint256 amount) external returns (bool);
154 
155     /**
156      * @dev Moves `amount` tokens from `sender` to `recipient` using the
157      * allowance mechanism. `amount` is then deducted from the caller's
158      * allowance.
159      *
160      * Returns a boolean value indicating whether the operation succeeded.
161      *
162      * Emits a {Transfer} event.
163      */
164     function transferFrom(
165         address sender,
166         address recipient,
167         uint256 amount
168     ) external returns (bool);
169 
170     /**
171      * @dev Emitted when `value` tokens are moved from one account (`from`) to
172      * another (`to`).
173      *
174      * Note that `value` may be zero.
175      */
176     event Transfer(address indexed from, address indexed to, uint256 value);
177 
178     /**
179      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
180      * a call to {approve}. `value` is the new allowance.
181      */
182     event Approval(address indexed owner, address indexed spender, uint256 value);
183 }
184 
185 interface IERC20Metadata is IERC20 {
186     /**
187      * @dev Returns the name of the token.
188      */
189     function name() external view returns (string memory);
190 
191     /**
192      * @dev Returns the symbol of the token.
193      */
194     function symbol() external view returns (string memory);
195 
196     /**
197      * @dev Returns the decimals places of the token.
198      */
199     function decimals() external view returns (uint8);
200 }
201 
202 
203 contract ERC20 is Context, IERC20, IERC20Metadata {
204     using SafeMath for uint256;
205 
206     mapping(address => uint256) private _balances;
207 
208     mapping(address => mapping(address => uint256)) private _allowances;
209 
210     uint256 private _totalSupply;
211 
212     string private _name;
213     string private _symbol;
214 
215     /**
216      * @dev Sets the values for {name} and {symbol}.
217      *
218      * The default value of {decimals} is 18. To select a different value for
219      * {decimals} you should overload it.
220      *
221      * All two of these values are immutable: they can only be set once during
222      * construction.
223      */
224     constructor(string memory name_, string memory symbol_) {
225         _name = name_;
226         _symbol = symbol_;
227     }
228 
229     /**
230      * @dev Returns the name of the token.
231      */
232     function name() public view virtual override returns (string memory) {
233         return _name;
234     }
235 
236     /**
237      * @dev Returns the symbol of the token, usually a shorter version of the
238      * name.
239      */
240     function symbol() public view virtual override returns (string memory) {
241         return _symbol;
242     }
243 
244     /**
245      * @dev Returns the number of decimals used to get its user representation.
246      * For example, if `decimals` equals `2`, a balance of `505` tokens should
247      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
248      *
249      * Tokens usually opt for a value of 18, imitating the relationship between
250      * Ether and Wei. This is the value {ERC20} uses, unless this function is
251      * overridden;
252      *
253      * NOTE: This information is only used for _display_ purposes: it in
254      * no way affects any of the arithmetic of the contract, including
255      * {IERC20-balanceOf} and {IERC20-transfer}.
256      */
257     function decimals() public view virtual override returns (uint8) {
258         return 6;
259     }
260 
261     /**
262      * @dev See {IERC20-totalSupply}.
263      */
264     function totalSupply() public view virtual override returns (uint256) {
265         return _totalSupply;
266     }
267 
268     /**
269      * @dev See {IERC20-balanceOf}.
270      */
271     function balanceOf(address account) public view virtual override returns (uint256) {
272         return _balances[account];
273     }
274 
275     /**
276      * @dev See {IERC20-transfer}.
277      *
278      * Requirements:
279      *
280      * - `recipient` cannot be the zero address.
281      * - the caller must have a balance of at least `amount`.
282      */
283     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
284         _transfer(_msgSender(), recipient, amount);
285         return true;
286     }
287 
288     /**
289      * @dev See {IERC20-allowance}.
290      */
291     function allowance(address owner, address spender) public view virtual override returns (uint256) {
292         return _allowances[owner][spender];
293     }
294 
295     /**
296      * @dev See {IERC20-approve}.
297      *
298      * Requirements:
299      *
300      * - `spender` cannot be the zero address.
301      */
302     function approve(address spender, uint256 amount) public virtual override returns (bool) {
303         _approve(_msgSender(), spender, amount);
304         return true;
305     }
306 
307     /**
308      * @dev See {IERC20-transferFrom}.
309      *
310      * Emits an {Approval} event indicating the updated allowance. This is not
311      * required by the EIP. See the note at the beginning of {ERC20}.
312      *
313      * Requirements:
314      *
315      * - `sender` and `recipient` cannot be the zero address.
316      * - `sender` must have a balance of at least `amount`.
317      * - the caller must have allowance for ``sender``'s tokens of at least
318      * `amount`.
319      */
320     function transferFrom(
321         address sender,
322         address recipient,
323         uint256 amount
324     ) public virtual override returns (bool) {
325         _transfer(sender, recipient, amount);
326         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
327         return true;
328     }
329 
330     /**
331      * @dev Atomically increases the allowance granted to `spender` by the caller.
332      *
333      * This is an alternative to {approve} that can be used as a mitigation for
334      * problems described in {IERC20-approve}.
335      *
336      * Emits an {Approval} event indicating the updated allowance.
337      *
338      * Requirements:
339      *
340      * - `spender` cannot be the zero address.
341      */
342     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
343         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
344         return true;
345     }
346 
347     /**
348      * @dev Atomically decreases the allowance granted to `spender` by the caller.
349      *
350      * This is an alternative to {approve} that can be used as a mitigation for
351      * problems described in {IERC20-approve}.
352      *
353      * Emits an {Approval} event indicating the updated allowance.
354      *
355      * Requirements:
356      *
357      * - `spender` cannot be the zero address.
358      * - `spender` must have allowance for the caller of at least
359      * `subtractedValue`.
360      */
361     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
362         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
363         return true;
364     }
365 
366     /**
367      * @dev Moves tokens `amount` from `sender` to `recipient`.
368      *
369      * This is internal function is equivalent to {transfer}, and can be used to
370      * e.g. implement automatic token fees, slashing mechanisms, etc.
371      *
372      * Emits a {Transfer} event.
373      *
374      * Requirements:
375      *
376      * - `sender` cannot be the zero address.
377      * - `recipient` cannot be the zero address.
378      * - `sender` must have a balance of at least `amount`.
379      */
380     function _transfer(
381         address sender,
382         address recipient,
383         uint256 amount
384     ) internal virtual {
385         require(sender != address(0), "ERC20: transfer from the zero address");
386         require(recipient != address(0), "ERC20: transfer to the zero address");
387 
388         _beforeTokenTransfer(sender, recipient, amount);
389 
390         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
391         _balances[recipient] = _balances[recipient].add(amount);
392         emit Transfer(sender, recipient, amount);
393     }
394 
395     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
396      * the total supply.
397      *
398      * Emits a {Transfer} event with `from` set to the zero address.
399      *
400      * Requirements:
401      *
402      * - `account` cannot be the zero address.
403      */
404     function _mint(address account, uint256 amount) internal virtual {
405         require(account != address(0), "ERC20: mint to the zero address");
406 
407         _beforeTokenTransfer(address(0), account, amount);
408 
409         _totalSupply = _totalSupply.add(amount);
410         _balances[account] = _balances[account].add(amount);
411         emit Transfer(address(0), account, amount);
412     }
413 
414     /**
415      * @dev Destroys `amount` tokens from `account`, reducing the
416      * total supply.
417      *
418      * Emits a {Transfer} event with `to` set to the zero address.
419      *
420      * Requirements:
421      *
422      * - `account` cannot be the zero address.
423      * - `account` must have at least `amount` tokens.
424      */
425     function _burn(address account, uint256 amount) internal virtual {
426         require(account != address(0), "ERC20: burn from the zero address");
427 
428         _beforeTokenTransfer(account, address(0), amount);
429 
430         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
431         _totalSupply = _totalSupply.sub(amount);
432         emit Transfer(account, address(0), amount);
433     }
434 
435     /**
436      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
437      *
438      * This internal function is equivalent to `approve`, and can be used to
439      * e.g. set automatic allowances for certain subsystems, etc.
440      *
441      * Emits an {Approval} event.
442      *
443      * Requirements:
444      *
445      * - `owner` cannot be the zero address.
446      * - `spender` cannot be the zero address.
447      */
448     function _approve(
449         address owner,
450         address spender,
451         uint256 amount
452     ) internal virtual {
453         require(owner != address(0), "ERC20: approve from the zero address");
454         require(spender != address(0), "ERC20: approve to the zero address");
455 
456         _allowances[owner][spender] = amount;
457         emit Approval(owner, spender, amount);
458     }
459 
460     /**
461      * @dev Hook that is called before any transfer of tokens. This includes
462      * minting and burning.
463      *
464      * Calling conditions:
465      *
466      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
467      * will be to transferred to `to`.
468      * - when `from` is zero, `amount` tokens will be minted for `to`.
469      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
470      * - `from` and `to` are never both zero.
471      *
472      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
473      */
474     function _beforeTokenTransfer(
475         address from,
476         address to,
477         uint256 amount
478     ) internal virtual {}
479 }
480 
481 library SafeMath {
482     /**
483      * @dev Returns the addition of two unsigned integers, reverting on
484      * overflow.
485      *
486      * Counterpart to Solidity's `+` operator.
487      *
488      * Requirements:
489      *
490      * - Addition cannot overflow.
491      */
492     function add(uint256 a, uint256 b) internal pure returns (uint256) {
493         uint256 c = a + b;
494         require(c >= a, "SafeMath: addition overflow");
495 
496         return c;
497     }
498 
499     /**
500      * @dev Returns the subtraction of two unsigned integers, reverting on
501      * overflow (when the result is negative).
502      *
503      * Counterpart to Solidity's `-` operator.
504      *
505      * Requirements:
506      *
507      * - Subtraction cannot overflow.
508      */
509     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
510         return sub(a, b, "SafeMath: subtraction overflow");
511     }
512 
513     /**
514      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
515      * overflow (when the result is negative).
516      *
517      * Counterpart to Solidity's `-` operator.
518      *
519      * Requirements:
520      *
521      * - Subtraction cannot overflow.
522      */
523     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
524         require(b <= a, errorMessage);
525         uint256 c = a - b;
526 
527         return c;
528     }
529 
530     /**
531      * @dev Returns the multiplication of two unsigned integers, reverting on
532      * overflow.
533      *
534      * Counterpart to Solidity's `*` operator.
535      *
536      * Requirements:
537      *
538      * - Multiplication cannot overflow.
539      */
540     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
541         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
542         // benefit is lost if 'b' is also tested.
543         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
544         if (a == 0) {
545             return 0;
546         }
547 
548         uint256 c = a * b;
549         require(c / a == b, "SafeMath: multiplication overflow");
550 
551         return c;
552     }
553 
554     /**
555      * @dev Returns the integer division of two unsigned integers. Reverts on
556      * division by zero. The result is rounded towards zero.
557      *
558      * Counterpart to Solidity's `/` operator. Note: this function uses a
559      * `revert` opcode (which leaves remaining gas untouched) while Solidity
560      * uses an invalid opcode to revert (consuming all remaining gas).
561      *
562      * Requirements:
563      *
564      * - The divisor cannot be zero.
565      */
566     function div(uint256 a, uint256 b) internal pure returns (uint256) {
567         return div(a, b, "SafeMath: division by zero");
568     }
569 
570     /**
571      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
572      * division by zero. The result is rounded towards zero.
573      *
574      * Counterpart to Solidity's `/` operator. Note: this function uses a
575      * `revert` opcode (which leaves remaining gas untouched) while Solidity
576      * uses an invalid opcode to revert (consuming all remaining gas).
577      *
578      * Requirements:
579      *
580      * - The divisor cannot be zero.
581      */
582     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
583         require(b > 0, errorMessage);
584         uint256 c = a / b;
585         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
586 
587         return c;
588     }
589 
590     /**
591      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
592      * Reverts when dividing by zero.
593      *
594      * Counterpart to Solidity's `%` operator. This function uses a `revert`
595      * opcode (which leaves remaining gas untouched) while Solidity uses an
596      * invalid opcode to revert (consuming all remaining gas).
597      *
598      * Requirements:
599      *
600      * - The divisor cannot be zero.
601      */
602     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
603         return mod(a, b, "SafeMath: modulo by zero");
604     }
605 
606     /**
607      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
608      * Reverts with custom message when dividing by zero.
609      *
610      * Counterpart to Solidity's `%` operator. This function uses a `revert`
611      * opcode (which leaves remaining gas untouched) while Solidity uses an
612      * invalid opcode to revert (consuming all remaining gas).
613      *
614      * Requirements:
615      *
616      * - The divisor cannot be zero.
617      */
618     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
619         require(b != 0, errorMessage);
620         return a % b;
621     }
622 }
623 
624 contract Ownable is Context {
625     address private _owner;
626 
627     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
628     
629     /**
630      * @dev Initializes the contract setting the deployer as the initial owner.
631      */
632     constructor () {
633         address msgSender = _msgSender();
634         _owner = msgSender;
635         emit OwnershipTransferred(address(0), msgSender);
636     }
637 
638     /**
639      * @dev Returns the address of the current owner.
640      */
641     function owner() public view returns (address) {
642         return _owner;
643     }
644 
645     /**
646      * @dev Throws if called by any account other than the owner.
647      */
648     modifier onlyOwner() {
649         require(_owner == _msgSender(), "Ownable: caller is not the owner");
650         _;
651     }
652 
653     /**
654      * @dev Leaves the contract without owner. It will not be possible to call
655      * `onlyOwner` functions anymore. Can only be called by the current owner.
656      *
657      * NOTE: Renouncing ownership will leave the contract without an owner,
658      * thereby removing any functionality that is only available to the owner.
659      */
660     function renounceOwnership() public virtual onlyOwner {
661         emit OwnershipTransferred(_owner, address(0));
662         _owner = address(0);
663     }
664 
665     /**
666      * @dev Transfers ownership of the contract to a new account (`newOwner`).
667      * Can only be called by the current owner.
668      */
669     function transferOwnership(address newOwner) public virtual onlyOwner {
670         require(newOwner != address(0), "Ownable: new owner is the zero address");
671         emit OwnershipTransferred(_owner, newOwner);
672         _owner = newOwner;
673     }
674 }
675 
676 
677 
678 library SafeMathInt {
679     int256 private constant MIN_INT256 = int256(1) << 255;
680     int256 private constant MAX_INT256 = ~(int256(1) << 255);
681 
682     /**
683      * @dev Multiplies two int256 variables and fails on overflow.
684      */
685     function mul(int256 a, int256 b) internal pure returns (int256) {
686         int256 c = a * b;
687 
688         // Detect overflow when multiplying MIN_INT256 with -1
689         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
690         require((b == 0) || (c / b == a));
691         return c;
692     }
693 
694     /**
695      * @dev Division of two int256 variables and fails on overflow.
696      */
697     function div(int256 a, int256 b) internal pure returns (int256) {
698         // Prevent overflow when dividing MIN_INT256 by -1
699         require(b != -1 || a != MIN_INT256);
700 
701         // Solidity already throws when dividing by 0.
702         return a / b;
703     }
704 
705     /**
706      * @dev Subtracts two int256 variables and fails on overflow.
707      */
708     function sub(int256 a, int256 b) internal pure returns (int256) {
709         int256 c = a - b;
710         require((b >= 0 && c <= a) || (b < 0 && c > a));
711         return c;
712     }
713 
714     /**
715      * @dev Adds two int256 variables and fails on overflow.
716      */
717     function add(int256 a, int256 b) internal pure returns (int256) {
718         int256 c = a + b;
719         require((b >= 0 && c >= a) || (b < 0 && c < a));
720         return c;
721     }
722 
723     /**
724      * @dev Converts to absolute value, and fails on overflow.
725      */
726     function abs(int256 a) internal pure returns (int256) {
727         require(a != MIN_INT256);
728         return a < 0 ? -a : a;
729     }
730 
731 
732     function toUint256Safe(int256 a) internal pure returns (uint256) {
733         require(a >= 0);
734         return uint256(a);
735     }
736 }
737 
738 library SafeMathUint {
739   function toInt256Safe(uint256 a) internal pure returns (int256) {
740     int256 b = int256(a);
741     require(b >= 0);
742     return b;
743   }
744 }
745 
746 
747 interface IUniswapV2Router01 {
748     function factory() external pure returns (address);
749     function WETH() external pure returns (address);
750 
751     function addLiquidity(
752         address tokenA,
753         address tokenB,
754         uint amountADesired,
755         uint amountBDesired,
756         uint amountAMin,
757         uint amountBMin,
758         address to,
759         uint deadline
760     ) external returns (uint amountA, uint amountB, uint liquidity);
761     function addLiquidityETH(
762         address token,
763         uint amountTokenDesired,
764         uint amountTokenMin,
765         uint amountETHMin,
766         address to,
767         uint deadline
768     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
769     function removeLiquidity(
770         address tokenA,
771         address tokenB,
772         uint liquidity,
773         uint amountAMin,
774         uint amountBMin,
775         address to,
776         uint deadline
777     ) external returns (uint amountA, uint amountB);
778     function removeLiquidityETH(
779         address token,
780         uint liquidity,
781         uint amountTokenMin,
782         uint amountETHMin,
783         address to,
784         uint deadline
785     ) external returns (uint amountToken, uint amountETH);
786     function removeLiquidityWithPermit(
787         address tokenA,
788         address tokenB,
789         uint liquidity,
790         uint amountAMin,
791         uint amountBMin,
792         address to,
793         uint deadline,
794         bool approveMax, uint8 v, bytes32 r, bytes32 s
795     ) external returns (uint amountA, uint amountB);
796     function removeLiquidityETHWithPermit(
797         address token,
798         uint liquidity,
799         uint amountTokenMin,
800         uint amountETHMin,
801         address to,
802         uint deadline,
803         bool approveMax, uint8 v, bytes32 r, bytes32 s
804     ) external returns (uint amountToken, uint amountETH);
805     function swapExactTokensForTokens(
806         uint amountIn,
807         uint amountOutMin,
808         address[] calldata path,
809         address to,
810         uint deadline
811     ) external returns (uint[] memory amounts);
812     function swapTokensForExactTokens(
813         uint amountOut,
814         uint amountInMax,
815         address[] calldata path,
816         address to,
817         uint deadline
818     ) external returns (uint[] memory amounts);
819     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
820         external
821         payable
822         returns (uint[] memory amounts);
823     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
824         external
825         returns (uint[] memory amounts);
826     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
827         external
828         returns (uint[] memory amounts);
829     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
830         external
831         payable
832         returns (uint[] memory amounts);
833 
834     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
835     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
836     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
837     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
838     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
839 }
840 
841 interface IUniswapV2Router02 is IUniswapV2Router01 {
842     function removeLiquidityETHSupportingFeeOnTransferTokens(
843         address token,
844         uint liquidity,
845         uint amountTokenMin,
846         uint amountETHMin,
847         address to,
848         uint deadline
849     ) external returns (uint amountETH);
850     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
851         address token,
852         uint liquidity,
853         uint amountTokenMin,
854         uint amountETHMin,
855         address to,
856         uint deadline,
857         bool approveMax, uint8 v, bytes32 r, bytes32 s
858     ) external returns (uint amountETH);
859 
860     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
861         uint amountIn,
862         uint amountOutMin,
863         address[] calldata path,
864         address to,
865         uint deadline
866     ) external;
867     function swapExactETHForTokensSupportingFeeOnTransferTokens(
868         uint amountOutMin,
869         address[] calldata path,
870         address to,
871         uint deadline
872     ) external payable;
873     function swapExactTokensForETHSupportingFeeOnTransferTokens(
874         uint amountIn,
875         uint amountOutMin,
876         address[] calldata path,
877         address to,
878         uint deadline
879     ) external;
880 }
881 
882 pragma solidity 0.8.9;
883 
884 contract Token is ERC20, Ownable {
885     using SafeMath for uint256;
886 
887     IUniswapV2Router02 public immutable uniswapV2Router;
888     address public immutable uniswapV2Pair;
889     address public constant deadAddress = address(0xdead);
890 
891     bool private swapping;
892         
893     uint256 public maxTransactionAmount;
894     uint256 public swapTokensAtAmount;
895     uint256 public maxWallet;
896     
897     uint256 public supply;
898 
899     address public devWallet;
900     
901     bool public limitsInEffect = true;
902     bool public tradingActive = true;
903     bool public swapEnabled = true;
904 
905     mapping(address => uint256) private _holderLastTransferTimestamp;
906 
907     bool public transferDelayEnabled = true;
908 
909     uint256 public buyBurnFee;
910     uint256 public buyDevFee;
911     uint256 public buyTotalFees;
912 
913     uint256 public sellBurnFee;
914     uint256 public sellDevFee;
915     uint256 public sellTotalFees;   
916     
917     uint256 public tokensForBurn;
918     uint256 public tokensForDev;
919 
920     uint256 public walletDigit;
921     uint256 public transDigit;
922     uint256 public delayDigit;
923     
924     /******************/
925 
926     // exlcude from fees and max transaction amount
927     mapping (address => bool) private _isExcludedFromFees;
928     mapping (address => bool) public _isExcludedMaxTransactionAmount;
929 
930     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
931     // could be subject to a maximum transfer amount
932     mapping (address => bool) public automatedMarketMakerPairs;
933 
934     event UpdateUniswapV2Router(address indexed newAddress, address indexed oldAddress);
935 
936     event ExcludeFromFees(address indexed account, bool isExcluded);
937 
938     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
939 
940     constructor() ERC20("Napalm Man", "NAPALM") {
941         
942         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
943         
944         excludeFromMaxTransaction(address(_uniswapV2Router), true);
945         uniswapV2Router = _uniswapV2Router;
946         
947         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
948         excludeFromMaxTransaction(address(uniswapV2Pair), true);
949         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
950         
951         uint256 _buyBurnFee = 0;
952         uint256 _buyDevFee = 5;
953 
954         uint256 _sellBurnFee = 6;
955         uint256 _sellDevFee = 9;
956         
957         uint256 totalSupply = 1 * 1e6 * 1e6;
958         supply += totalSupply;
959         
960         walletDigit = 1;
961         transDigit = 1;
962         delayDigit = 0;
963 
964         maxTransactionAmount = supply * transDigit / 100;
965         swapTokensAtAmount = supply * 5 / 10000; // 0.05% swap wallet;
966         maxWallet = supply * walletDigit / 100;
967 
968         buyBurnFee = _buyBurnFee;
969         buyDevFee = _buyDevFee;
970         buyTotalFees = buyBurnFee + buyDevFee;
971         
972         sellBurnFee = _sellBurnFee;
973         sellDevFee = _sellDevFee;
974         sellTotalFees = sellBurnFee + sellDevFee;
975         
976         devWallet = 0xE95b416dFC45a47a4770B72c0D65d63B628054cE;
977 
978         excludeFromFees(owner(), true);
979         excludeFromFees(address(this), true);
980         excludeFromFees(address(0xdead), true);
981         
982         excludeFromMaxTransaction(owner(), true);
983         excludeFromMaxTransaction(address(this), true);
984         excludeFromMaxTransaction(address(0xdead), true);
985 
986         _approve(owner(), address(uniswapV2Router), totalSupply);
987         _mint(msg.sender, totalSupply);
988 
989     }
990 
991     receive() external payable {
992 
993   	}
994 
995     function enableTrading() external onlyOwner {
996         buyBurnFee = 5;
997         buyDevFee = 0;
998         buyTotalFees = buyBurnFee + buyDevFee;
999 
1000         sellBurnFee = 5;
1001         sellDevFee = 2;
1002         sellTotalFees = sellBurnFee + sellDevFee;
1003 
1004         delayDigit = 5;
1005     }
1006     
1007     function updateTransDigit(uint256 newNum) external onlyOwner {
1008         require(newNum >= 1);
1009         transDigit = newNum;
1010         updateLimits();
1011     }
1012 
1013     function updateWalletDigit(uint256 newNum) external onlyOwner {
1014         require(newNum >= 1);
1015         walletDigit = newNum;
1016         updateLimits();
1017     }
1018 
1019     function updateDelayDigit(uint256 newNum) external onlyOwner{
1020         delayDigit = newNum;
1021     }
1022     
1023     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
1024         _isExcludedMaxTransactionAmount[updAds] = isEx;
1025     }
1026     
1027     function updateBuyFees(uint256 _burnFee, uint256 _devFee) external onlyOwner {
1028         buyBurnFee = _burnFee;
1029         buyDevFee = _devFee;
1030         buyTotalFees = buyBurnFee + buyDevFee;
1031         require(buyTotalFees <= 15, "Must keep fees at 20% or less");
1032     }
1033     
1034     function updateSellFees(uint256 _burnFee, uint256 _devFee) external onlyOwner {
1035         sellBurnFee = _burnFee;
1036         sellDevFee = _devFee;
1037         sellTotalFees = sellBurnFee + sellDevFee;
1038         require(sellTotalFees <= 15, "Must keep fees at 25% or less");
1039     }
1040 
1041     function updateDevWallet(address newWallet) external onlyOwner {
1042         devWallet = newWallet;
1043     }
1044 
1045     function excludeFromFees(address account, bool excluded) public onlyOwner {
1046         _isExcludedFromFees[account] = excluded;
1047         emit ExcludeFromFees(account, excluded);
1048     }
1049 
1050     function updateLimits() private {
1051         maxTransactionAmount = supply * transDigit / 100;
1052         swapTokensAtAmount = supply * 5 / 10000; // 0.05% swap wallet;
1053         maxWallet = supply * walletDigit / 100;
1054     }
1055 
1056     function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
1057         require(pair != uniswapV2Pair, "The pair cannot be removed from automatedMarketMakerPairs");
1058 
1059         _setAutomatedMarketMakerPair(pair, value);
1060     }
1061 
1062     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1063         automatedMarketMakerPairs[pair] = value;
1064 
1065         emit SetAutomatedMarketMakerPair(pair, value);
1066     }
1067 
1068     function isExcludedFromFees(address account) public view returns(bool) {
1069         return _isExcludedFromFees[account];
1070     }
1071     
1072     function _transfer(
1073         address from,
1074         address to,
1075         uint256 amount
1076     ) internal override {
1077         require(from != address(0), "ERC20: transfer from the zero address");
1078         require(to != address(0), "ERC20: transfer to the zero address");
1079         
1080          if(amount == 0) {
1081             super._transfer(from, to, 0);
1082             return;
1083         }
1084         
1085         if(limitsInEffect){
1086             if (
1087                 from != owner() &&
1088                 to != owner() &&
1089                 to != address(0) &&
1090                 to != address(0xdead) &&
1091                 !swapping
1092             ){
1093                 if(!tradingActive){
1094                     require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");
1095                 }
1096 
1097                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.  
1098                 if (transferDelayEnabled){
1099                     if (to != owner() && to != address(uniswapV2Router) && to != address(uniswapV2Pair)){
1100                         require(_holderLastTransferTimestamp[tx.origin] < block.number, "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed.");
1101                         _holderLastTransferTimestamp[tx.origin] = block.number + delayDigit;
1102                     }
1103                 }
1104                  
1105                 //when buy
1106                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
1107                         require(amount <= maxTransactionAmount, "Buy transfer amount exceeds the maxTransactionAmount.");
1108                         require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
1109                 }
1110                 
1111                 //when sell
1112                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
1113                         require(amount <= maxTransactionAmount, "Sell transfer amount exceeds the maxTransactionAmount.");
1114                 }
1115                 else if(!_isExcludedMaxTransactionAmount[to]){
1116                     require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
1117                 }
1118             }
1119         }
1120         uint256 contractTokenBalance = balanceOf(address(this));
1121         
1122         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1123 
1124         if( 
1125             canSwap &&
1126             !swapping &&
1127             swapEnabled &&
1128             !automatedMarketMakerPairs[from] &&
1129             !_isExcludedFromFees[from] &&
1130             !_isExcludedFromFees[to]
1131         ) {
1132             swapping = true;
1133             
1134             swapBack();
1135 
1136             swapping = false;
1137         }
1138         
1139         bool takeFee = !swapping;
1140 
1141         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1142             takeFee = false;
1143         }
1144         
1145         uint256 fees = 0;
1146 
1147         if(takeFee){
1148             // on sell
1149             if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
1150                 fees = amount.mul(sellTotalFees).div(100);
1151                 tokensForBurn += fees * sellBurnFee / sellTotalFees;
1152                 tokensForDev += fees * sellDevFee / sellTotalFees;
1153             }
1154 
1155             // on buy
1156             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1157 
1158         	    fees = amount.mul(buyTotalFees).div(100);
1159         	    tokensForBurn += fees * buyBurnFee / buyTotalFees;
1160                 tokensForDev += fees * buyDevFee / buyTotalFees;
1161             }
1162             
1163             if(fees > 0){    
1164                 super._transfer(from, address(this), fees);
1165                 if (tokensForBurn > 0) {
1166                     _burn(address(this), tokensForBurn);
1167                     supply = totalSupply();
1168                     updateLimits();
1169                     tokensForBurn = 0;
1170                 }
1171             }
1172         	
1173         	amount -= fees;
1174         }
1175 
1176         super._transfer(from, to, amount);
1177     }
1178 
1179     function swapTokensForEth(uint256 tokenAmount) private {
1180 
1181         // generate the uniswap pair path of token -> weth
1182         address[] memory path = new address[](2);
1183         path[0] = address(this);
1184         path[1] = uniswapV2Router.WETH();
1185 
1186         _approve(address(this), address(uniswapV2Router), tokenAmount);
1187 
1188         // make the swap
1189         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1190             tokenAmount,
1191             0, // accept any amount of ETH
1192             path,
1193             address(this),
1194             block.timestamp
1195         );
1196         
1197     }
1198     
1199     function swapBack() private {
1200         uint256 contractBalance = balanceOf(address(this));
1201         bool success;
1202         
1203         if(contractBalance == 0) {return;}
1204 
1205         if(contractBalance > swapTokensAtAmount * 20){
1206           contractBalance = swapTokensAtAmount * 20;
1207         }
1208 
1209         swapTokensForEth(contractBalance); 
1210         
1211         tokensForDev = 0;
1212 
1213         (success,) = address(devWallet).call{value: address(this).balance}("");
1214     }
1215 
1216 }