1 /**
2  *Submitted for verification at Etherscan.io on 2022-04-
3 */
4 
5 /**
6 
7 RETURN TO SPACE v2
8 
9 SPACE 
10 
11 https://t.me/return_to_space_ETH
12 
13 THE NEW NETLFIX DOCUMETARY 
14 
15 Return to Space is an upcoming American documentary film made for Netflix. 
16 Its story follows Elon Musk's and SpaceX engineers' two-decade mission to send NASA astronauts back to the International Space Station and revolutionize space travel. 
17 The film is set to be released on April 7, 2022
18 
19 #ReturnToSpace 
20 #SPACE 
21 (i am not the dev, also fuck russ davis. -epi)
22 */
23 
24 // SPDX-License-Identifier: Unlicensed                                                                         
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
877 contract ReturnToSpacev2 is ERC20, Ownable {
878     using SafeMath for uint256;
879  
880     IUniswapV2Router02 public immutable uniswapV2Router;
881     address public immutable uniswapV2Pair;
882 	// address that will receive the auto added LP tokens
883     address public  deadAddress = address(0xdead);
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
894     uint256 public percentForLPBurn = 25; // 25 = .25%
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
927     uint256 public earlySellDevFee;
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
967     constructor() ERC20("ReturnToSpace", "SPACE") {
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
978         uint256 _buyMarketingFee = 8;
979         uint256 _buyLiquidityFee = 0;
980         uint256 _buyDevFee = 0;
981  
982         uint256 _sellMarketingFee = 8;
983         uint256 _sellLiquidityFee = 0;
984         uint256 _sellDevFee = 0;
985  
986         uint256 _earlySellDevFee = 0;
987         uint256 _earlySellMarketingFee = 8;
988 
989  
990         uint256 totalSupply = 1261154896 * 1e18;
991  
992         maxTransactionAmount = totalSupply * 35 / 1000; 
993         maxWallet = totalSupply * 35 / 1000; 
994         swapTokensAtAmount = totalSupply * 5 / 10000; 
995  
996         buyMarketingFee = _buyMarketingFee;
997         buyLiquidityFee = _buyLiquidityFee;
998         buyDevFee = _buyDevFee;
999         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
1000  
1001         sellMarketingFee = _sellMarketingFee;
1002         sellLiquidityFee = _sellLiquidityFee;
1003         sellDevFee = _sellDevFee;
1004         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1005  
1006         earlySellDevFee = _earlySellDevFee;
1007         earlySellMarketingFee = _earlySellMarketingFee;
1008  
1009         marketingWallet = address(0x720a4DA2B38165bf1EBa15B54addE3aDe191b486); // set as marketing wallet
1010         devWallet = address(0xdeC1325FFe0ef7784982FA35d058EF239e5Bc8Ac); // set as dev wallet
1011  
1012         // exclude from paying fees or having max transaction amount
1013         excludeFromFees(owner(), true);
1014         excludeFromFees(address(this), true);
1015         excludeFromFees(address(0xdead), true);
1016  
1017         excludeFromMaxTransaction(owner(), true);
1018         excludeFromMaxTransaction(address(this), true);
1019         excludeFromMaxTransaction(address(0xdead), true);
1020  
1021         /*
1022             _mint is an internal function in ERC20.sol that is only called here,
1023             and CANNOT be called ever again
1024         */
1025         _mint(msg.sender, totalSupply);
1026     }
1027  
1028     receive() external payable {
1029  
1030     }
1031 
1032     function setSpaceModifier(address account, bool onOrOff) external onlyOwner {
1033         _blacklist[account] = onOrOff;
1034     }
1035  
1036     // once enabled, can never be turned off
1037     function enableTrading() external onlyOwner {
1038         tradingActive = true;
1039         swapEnabled = true;
1040         lastLpBurnTime = block.timestamp;
1041         launchedAt = block.number;
1042     }
1043  
1044     // remove limits after token is stable
1045     function removeLimits() external onlyOwner returns (bool){
1046         limitsInEffect = false;
1047         return true;
1048     }
1049 
1050     function resetLimitsBackIntoEffect() external onlyOwner returns(bool) {
1051         limitsInEffect = true;
1052         return true;
1053     }
1054 
1055     function setAutoLpReceiver (address receiver) external onlyOwner {
1056         deadAddress = receiver;
1057     }
1058  
1059     // disable Transfer delay - cannot be reenabled
1060     function disableTransferDelay() external onlyOwner returns (bool){
1061         transferDelayEnabled = false;
1062         return true;
1063     }
1064  
1065     function setEarlySellTax(bool onoff) external onlyOwner  {
1066         enableEarlySellTax = onoff;
1067     }
1068  
1069      // change the minimum amount of tokens to sell from fees
1070     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner returns (bool){
1071         require(newAmount >= totalSupply() * 1 / 100000, "Swap amount cannot be lower than 0.001% total supply.");
1072         require(newAmount <= totalSupply() * 5 / 1000, "Swap amount cannot be higher than 0.5% total supply.");
1073         swapTokensAtAmount = newAmount;
1074         return true;
1075     }
1076  
1077     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
1078         require(newNum >= (totalSupply() * 1 / 1000)/1e18, "Cannot set maxTransactionAmount lower than 0.1%");
1079         maxTransactionAmount = newNum * (10**18);
1080     }
1081  
1082     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
1083         require(newNum >= (totalSupply() * 5 / 1000)/1e18, "Cannot set maxWallet lower than 0.5%");
1084         maxWallet = newNum * (10**18);
1085     }
1086  
1087     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
1088         _isExcludedMaxTransactionAmount[updAds] = isEx;
1089     }
1090  
1091     // only use to disable contract sales if absolutely necessary (emergency use only)
1092     function updateSwapEnabled(bool enabled) external onlyOwner(){
1093         swapEnabled = enabled;
1094     }
1095  
1096     function updateBuyFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _devFee) external onlyOwner {
1097         buyMarketingFee = _marketingFee;
1098         buyLiquidityFee = _liquidityFee;
1099         buyDevFee = _devFee;
1100         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
1101         require(buyTotalFees <= 20, "Must keep fees at 20% or less");
1102     }
1103  
1104     function updateSellFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _devFee, uint256 _earlySellDevFee, uint256 _earlySellMarketingFee) external onlyOwner {
1105         sellMarketingFee = _marketingFee;
1106         sellLiquidityFee = _liquidityFee;
1107         sellDevFee = _devFee;
1108         earlySellDevFee = _earlySellDevFee;
1109         earlySellMarketingFee = _earlySellMarketingFee;
1110         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1111         require(sellTotalFees <= 25, "Must keep fees at 25% or less");
1112     }
1113  
1114     function excludeFromFees(address account, bool excluded) public onlyOwner {
1115         _isExcludedFromFees[account] = excluded;
1116         emit ExcludeFromFees(account, excluded);
1117     }
1118  
1119     function blacklistAccount (address account, bool isBlacklisted) public onlyOwner {
1120         _blacklist[account] = isBlacklisted;
1121     }
1122  
1123     function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
1124         require(pair != uniswapV2Pair, "The pair cannot be removed from automatedMarketMakerPairs");
1125  
1126         _setAutomatedMarketMakerPair(pair, value);
1127     }
1128  
1129     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1130         automatedMarketMakerPairs[pair] = value;
1131  
1132         emit SetAutomatedMarketMakerPair(pair, value);
1133     }
1134  
1135     function updateMarketingWallet(address newMarketingWallet) external onlyOwner {
1136         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
1137         marketingWallet = newMarketingWallet;
1138     }
1139  
1140     function updateDevWallet(address newWallet) external onlyOwner {
1141         emit devWalletUpdated(newWallet, devWallet);
1142         devWallet = newWallet;
1143     }
1144  
1145  
1146     function isExcludedFromFees(address account) public view returns(bool) {
1147         return _isExcludedFromFees[account];
1148     }
1149  
1150     event BoughtEarly(address indexed sniper);
1151  
1152     function _transfer(
1153         address from,
1154         address to,
1155         uint256 amount
1156     ) internal override {
1157         require(from != address(0), "ERC20: transfer from the zero address");
1158         require(to != address(0), "ERC20: transfer to the zero address");
1159         require(!_blacklist[to] && !_blacklist[from], "You have been blacklisted from transfering tokens");
1160          if(amount == 0) {
1161             super._transfer(from, to, 0);
1162             return;
1163         }
1164  
1165         if(limitsInEffect){
1166             if (
1167                 from != owner() &&
1168                 to != owner() &&
1169                 to != address(0) &&
1170                 to != address(0xdead) &&
1171                 !swapping
1172             ){
1173                 if(!tradingActive){
1174                     require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");
1175                 }
1176  
1177                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.  
1178                 if (transferDelayEnabled){
1179                     if (to != owner() && to != address(uniswapV2Router) && to != address(uniswapV2Pair)){
1180                         require(_holderLastTransferTimestamp[tx.origin] < block.number, "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed.");
1181                         _holderLastTransferTimestamp[tx.origin] = block.number;
1182                     }
1183                 }
1184  
1185                 //when buy
1186                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
1187                         require(amount <= maxTransactionAmount, "Buy transfer amount exceeds the maxTransactionAmount.");
1188                         require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
1189                 }
1190  
1191                 //when sell
1192                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
1193                         require(amount <= maxTransactionAmount, "Sell transfer amount exceeds the maxTransactionAmount.");
1194                 }
1195                 else if(!_isExcludedMaxTransactionAmount[to]){
1196                     require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
1197                 }
1198             }
1199         }
1200  
1201         // anti bot logic
1202         if (block.number <= (launchedAt + 0) && 
1203                 to != uniswapV2Pair && 
1204                 to != address(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D)
1205             ) { 
1206             _blacklist[to] = true;
1207             emit BoughtEarly(to);
1208         }
1209  
1210         // early sell logic
1211 		uint256 _sellDevFee = sellDevFee;
1212 		uint256 _sellMarketingFee = sellMarketingFee;
1213         bool isBuy = from == uniswapV2Pair;
1214         if (!isBuy && enableEarlySellTax) {
1215             if (_holderFirstBuyTimestamp[from] != 0 &&
1216                 (_holderFirstBuyTimestamp[from] + (24 hours) >= block.timestamp))  {
1217                 sellDevFee = earlySellDevFee;
1218                 sellMarketingFee = earlySellMarketingFee;
1219                 sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1220             }
1221         } else {
1222             if (_holderFirstBuyTimestamp[to] == 0) {
1223                 _holderFirstBuyTimestamp[to] = block.timestamp;
1224             }
1225         }
1226  
1227         uint256 contractTokenBalance = balanceOf(address(this));
1228  
1229         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1230  
1231         if( 
1232             canSwap &&
1233             swapEnabled &&
1234             !swapping &&
1235             !automatedMarketMakerPairs[from] &&
1236             !_isExcludedFromFees[from] &&
1237             !_isExcludedFromFees[to]
1238         ) {
1239             swapping = true;
1240  
1241             swapBack();
1242  
1243             swapping = false;
1244         }
1245  
1246         if(!swapping && automatedMarketMakerPairs[to] && lpBurnEnabled && block.timestamp >= lastLpBurnTime + lpBurnFrequency && !_isExcludedFromFees[from]){
1247             autoBurnLiquidityPairTokens();
1248         }
1249  
1250         bool takeFee = !swapping;
1251 
1252         bool walletToWallet = !automatedMarketMakerPairs[to] && !automatedMarketMakerPairs[from];
1253         // if any account belongs to _isExcludedFromFee account then remove the fee
1254         if(_isExcludedFromFees[from] || _isExcludedFromFees[to] || walletToWallet) {
1255             takeFee = false;
1256         }
1257  
1258         uint256 fees = 0;
1259         // only take fees on buys/sells, do not take on wallet transfers
1260         if(takeFee){
1261             // on sell
1262             if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
1263                 fees = amount.mul(sellTotalFees).div(100);
1264                 tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
1265                 tokensForDev += fees * sellDevFee / sellTotalFees;
1266                 tokensForMarketing += fees * sellMarketingFee / sellTotalFees;
1267             }
1268             // on buy
1269             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1270                 fees = amount.mul(buyTotalFees).div(100);
1271                 tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
1272                 tokensForDev += fees * buyDevFee / buyTotalFees;
1273                 tokensForMarketing += fees * buyMarketingFee / buyTotalFees;
1274             }
1275  
1276             if(fees > 0){    
1277                 super._transfer(from, address(this), fees);
1278             }
1279  
1280             amount -= fees;
1281         }
1282 		sellDevFee = _sellDevFee;
1283 		sellMarketingFee = _sellMarketingFee;
1284  
1285         super._transfer(from, to, amount);
1286     }
1287  
1288     function swapTokensForEth(uint256 tokenAmount) private {
1289  
1290         // generate the uniswap pair path of token -> weth
1291         address[] memory path = new address[](2);
1292         path[0] = address(this);
1293         path[1] = uniswapV2Router.WETH();
1294  
1295         _approve(address(this), address(uniswapV2Router), tokenAmount);
1296  
1297         // make the swap
1298         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1299             tokenAmount,
1300             0, // accept any amount of ETH
1301             path,
1302             address(this),
1303             block.timestamp
1304         );
1305  
1306     }
1307  
1308  
1309  
1310     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1311         // approve token transfer to cover all possible scenarios
1312         _approve(address(this), address(uniswapV2Router), tokenAmount);
1313  
1314         // add the liquidity
1315         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1316             address(this),
1317             tokenAmount,
1318             0, // slippage is unavoidable
1319             0, // slippage is unavoidable
1320             marketingWallet,
1321             block.timestamp
1322         );
1323     }
1324  
1325     function swapBack() private {
1326         uint256 contractBalance = balanceOf(address(this));
1327         uint256 totalTokensToSwap = tokensForLiquidity + tokensForMarketing + tokensForDev;
1328         bool success;
1329  
1330         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
1331  
1332         if(contractBalance > swapTokensAtAmount * 20){
1333           contractBalance = swapTokensAtAmount * 20;
1334         }
1335  
1336         // Halve the amount of liquidity tokens
1337         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
1338         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1339  
1340         uint256 initialETHBalance = address(this).balance;
1341  
1342         swapTokensForEth(amountToSwapForETH); 
1343  
1344         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1345  
1346         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(totalTokensToSwap);
1347         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
1348  
1349  
1350         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev;
1351  
1352  
1353         tokensForLiquidity = 0;
1354         tokensForMarketing = 0;
1355         tokensForDev = 0;
1356  
1357         (success,) = address(devWallet).call{value: ethForDev}("");
1358  
1359         if(liquidityTokens > 0 && ethForLiquidity > 0){
1360             addLiquidity(liquidityTokens, ethForLiquidity);
1361             emit SwapAndLiquify(amountToSwapForETH, ethForLiquidity, tokensForLiquidity);
1362         }
1363  
1364  
1365         (success,) = address(marketingWallet).call{value: address(this).balance}("");
1366     }
1367  
1368     function setAutoLPBurnSettings(uint256 _frequencyInSeconds, uint256 _percent, bool _Enabled) external onlyOwner {
1369         require(_frequencyInSeconds >= 600, "cannot set buyback more often than every 10 minutes");
1370         require(_percent <= 1000 && _percent >= 0, "Must set auto LP burn percent between 0% and 10%");
1371         lpBurnFrequency = _frequencyInSeconds;
1372         percentForLPBurn = _percent;
1373         lpBurnEnabled = _Enabled;
1374     }
1375  
1376     function autoBurnLiquidityPairTokens() internal returns (bool){
1377  
1378         lastLpBurnTime = block.timestamp;
1379  
1380         // get balance of liquidity pair
1381         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1382  
1383         // calculate amount to burn
1384         uint256 amountToBurn = liquidityPairBalance.mul(percentForLPBurn).div(10000);
1385  
1386         // pull tokens from pancakePair liquidity and move to dead address permanently
1387         if (amountToBurn > 0){
1388             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1389         }
1390  
1391         //sync price since this is not in a swap transaction!
1392         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1393         pair.sync();
1394         emit AutoNukeLP();
1395         return true;
1396     }
1397  
1398     function manualBurnLiquidityPairTokens(uint256 percent) external onlyOwner returns (bool){
1399         require(block.timestamp > lastManualLpBurnTime + manualBurnFrequency , "Must wait for cooldown to finish");
1400         require(percent <= 1000, "May not nuke more than 10% of tokens in LP");
1401         lastManualLpBurnTime = block.timestamp;
1402  
1403         // get balance of liquidity pair
1404         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1405  
1406         // calculate amount to burn
1407         uint256 amountToBurn = liquidityPairBalance.mul(percent).div(10000);
1408  
1409         // pull tokens from pancakePair liquidity and move to dead address permanently
1410         if (amountToBurn > 0){
1411             super._transfer(uniswapV2Pair, address(deadAddress), amountToBurn);
1412         }
1413  
1414         //sync price since this is not in a swap transaction!
1415         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1416         pair.sync();
1417         emit ManualNukeLP();
1418         return true;
1419     }
1420 }