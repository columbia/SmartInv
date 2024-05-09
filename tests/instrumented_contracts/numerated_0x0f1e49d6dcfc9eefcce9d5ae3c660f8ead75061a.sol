1 // SPDX-License-Identifier: MIT                                                                               
2                                                     
3 pragma solidity 0.8.18;
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
38     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
39     event Swap(
40         address indexed sender,
41         uint amount0In,
42         uint amount1In,
43         uint amount0Out,
44         uint amount1Out,
45         address indexed to
46     );
47     event Sync(uint112 reserve0, uint112 reserve1);
48 
49     function MINIMUM_LIQUIDITY() external pure returns (uint);
50     function factory() external view returns (address);
51     function token0() external view returns (address);
52     function token1() external view returns (address);
53     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
54     function price0CumulativeLast() external view returns (uint);
55     function price1CumulativeLast() external view returns (uint);
56     function kLast() external view returns (uint);
57 
58     function mint(address to) external returns (uint liquidity);
59     function burn(address to) external returns (uint amount0, uint amount1);
60     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
61     function skim(address to) external;
62     function sync() external;
63 
64     function initialize(address, address) external;
65 }
66 
67 interface IUniswapV2Factory {
68     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
69 
70     function feeTo() external view returns (address);
71     function feeToSetter() external view returns (address);
72 
73     function getPair(address tokenA, address tokenB) external view returns (address pair);
74     function allPairs(uint) external view returns (address pair);
75     function allPairsLength() external view returns (uint);
76 
77     function createPair(address tokenA, address tokenB) external returns (address pair);
78 
79     function setFeeTo(address) external;
80     function setFeeToSetter(address) external;
81 }
82 
83 interface IERC20 {
84     /**
85      * @dev Returns the amount of tokens in existence.
86      */
87     function totalSupply() external view returns (uint256);
88 
89     /**
90      * @dev Returns the amount of tokens owned by `account`.
91      */
92     function balanceOf(address account) external view returns (uint256);
93 
94     /**
95      * @dev Moves `amount` tokens from the caller's account to `recipient`.
96      *
97      * Returns a boolean value indicating whether the operation succeeded.
98      *
99      * Emits a {Transfer} event.
100      */
101     function transfer(address recipient, uint256 amount) external returns (bool);
102 
103     /**
104      * @dev Returns the remaining number of tokens that `spender` will be
105      * allowed to spend on behalf of `owner` through {transferFrom}. This is
106      * zero by default.
107      *
108      * This value changes when {approve} or {transferFrom} are called.
109      */
110     function allowance(address owner, address spender) external view returns (uint256);
111 
112     /**
113      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
114      *
115      * Returns a boolean value indicating whether the operation succeeded.
116      *
117      * IMPORTANT: Beware that changing an allowance with this method brings the risk
118      * that someone may use both the old and the new allowance by unfortunate
119      * transaction ordering. One possible solution to mitigate this race
120      * condition is to first reduce the spender's allowance to 0 and set the
121      * desired value afterwards:
122      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
123      *
124      * Emits an {Approval} event.
125      */
126     function approve(address spender, uint256 amount) external returns (bool);
127 
128     /**
129      * @dev Moves `amount` tokens from `sender` to `recipient` using the
130      * allowance mechanism. `amount` is then deducted from the caller's
131      * allowance.
132      *
133      * Returns a boolean value indicating whether the operation succeeded.
134      *
135      * Emits a {Transfer} event.
136      */
137     function transferFrom(
138         address sender,
139         address recipient,
140         uint256 amount
141     ) external returns (bool);
142 
143     /**
144      * @dev Emitted when `value` tokens are moved from one account (`from`) to
145      * another (`to`).
146      *
147      * Note that `value` may be zero.
148      */
149     event Transfer(address indexed from, address indexed to, uint256 value);
150 
151     /**
152      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
153      * a call to {approve}. `value` is the new allowance.
154      */
155     event Approval(address indexed owner, address indexed spender, uint256 value);
156 }
157 
158 interface IERC20Metadata is IERC20 {
159     /**
160      * @dev Returns the name of the token.
161      */
162     function name() external view returns (string memory);
163 
164     /**
165      * @dev Returns the symbol of the token.
166      */
167     function symbol() external view returns (string memory);
168 
169     /**
170      * @dev Returns the decimals places of the token.
171      */
172     function decimals() external view returns (uint8);
173 }
174 
175 
176 contract ERC20 is Context, IERC20, IERC20Metadata {
177     using SafeMath for uint256;
178 
179     mapping(address => uint256) private _balances;
180 
181     mapping(address => mapping(address => uint256)) private _allowances;
182 
183     uint256 private _totalSupply;
184 
185     string private _name;
186     string private _symbol;
187 
188     /**
189      * @dev Sets the values for {name} and {symbol}.
190      *
191      * The default value of {decimals} is 18. To select a different value for
192      * {decimals} you should overload it.
193      *
194      * All two of these values are immutable: they can only be set once during
195      * construction.
196      */
197     constructor(string memory name_, string memory symbol_) {
198         _name = name_;
199         _symbol = symbol_;
200     }
201 
202     /**
203      * @dev Returns the name of the token.
204      */
205     function name() public view virtual override returns (string memory) {
206         return _name;
207     }
208 
209     /**
210      * @dev Returns the symbol of the token, usually a shorter version of the
211      * name.
212      */
213     function symbol() public view virtual override returns (string memory) {
214         return _symbol;
215     }
216 
217     /**
218      * @dev Returns the number of decimals used to get its user representation.
219      * For example, if `decimals` equals `2`, a balance of `505` tokens should
220      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
221      *
222      * Tokens usually opt for a value of 18, imitating the relationship between
223      * Ether and Wei. This is the value {ERC20} uses, unless this function is
224      * overridden;
225      *
226      * NOTE: This information is only used for _display_ purposes: it in
227      * no way affects any of the arithmetic of the contract, including
228      * {IERC20-balanceOf} and {IERC20-transfer}.
229      */
230     function decimals() public view virtual override returns (uint8) {
231         return 9;
232     }
233 
234     /**
235      * @dev See {IERC20-totalSupply}.
236      */
237     function totalSupply() public view virtual override returns (uint256) {
238         return _totalSupply;
239     }
240 
241     /**
242      * @dev See {IERC20-balanceOf}.
243      */
244     function balanceOf(address account) public view virtual override returns (uint256) {
245         return _balances[account];
246     }
247 
248     /**
249      * @dev See {IERC20-transfer}.
250      *
251      * Requirements:
252      *
253      * - `recipient` cannot be the zero address.
254      * - the caller must have a balance of at least `amount`.
255      */
256     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
257         _transfer(_msgSender(), recipient, amount);
258         return true;
259     }
260 
261     /**
262      * @dev See {IERC20-allowance}.
263      */
264     function allowance(address owner, address spender) public view virtual override returns (uint256) {
265         return _allowances[owner][spender];
266     }
267 
268     /**
269      * @dev See {IERC20-approve}.
270      *
271      * Requirements:
272      *
273      * - `spender` cannot be the zero address.
274      */
275     function approve(address spender, uint256 amount) public virtual override returns (bool) {
276         _approve(_msgSender(), spender, amount);
277         return true;
278     }
279 
280     /**
281      * @dev See {IERC20-transferFrom}.
282      *
283      * Emits an {Approval} event indicating the updated allowance. This is not
284      * required by the EIP. See the note at the beginning of {ERC20}.
285      *
286      * Requirements:
287      *
288      * - `sender` and `recipient` cannot be the zero address.
289      * - `sender` must have a balance of at least `amount`.
290      * - the caller must have allowance for ``sender``'s tokens of at least
291      * `amount`.
292      */
293     function transferFrom(
294         address sender,
295         address recipient,
296         uint256 amount
297     ) public virtual override returns (bool) {
298         _transfer(sender, recipient, amount);
299         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
300         return true;
301     }
302 
303     /**
304      * @dev Atomically increases the allowance granted to `spender` by the caller.
305      *
306      * This is an alternative to {approve} that can be used as a mitigation for
307      * problems described in {IERC20-approve}.
308      *
309      * Emits an {Approval} event indicating the updated allowance.
310      *
311      * Requirements:
312      *
313      * - `spender` cannot be the zero address.
314      */
315     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
316         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
317         return true;
318     }
319 
320     /**
321      * @dev Atomically decreases the allowance granted to `spender` by the caller.
322      *
323      * This is an alternative to {approve} that can be used as a mitigation for
324      * problems described in {IERC20-approve}.
325      *
326      * Emits an {Approval} event indicating the updated allowance.
327      *
328      * Requirements:
329      *
330      * - `spender` cannot be the zero address.
331      * - `spender` must have allowance for the caller of at least
332      * `subtractedValue`.
333      */
334     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
335         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
336         return true;
337     }
338 
339     /**
340      * @dev Moves tokens `amount` from `sender` to `recipient`.
341      *
342      * This is internal function is equivalent to {transfer}, and can be used to
343      * e.g. implement automatic token fees, slashing mechanisms, etc.
344      *
345      * Emits a {Transfer} event.
346      *
347      * Requirements:
348      *
349      * - `sender` cannot be the zero address.
350      * - `recipient` cannot be the zero address.
351      * - `sender` must have a balance of at least `amount`.
352      */
353     function _transfer(
354         address sender,
355         address recipient,
356         uint256 amount
357     ) internal virtual {
358         require(sender != address(0), "ERC20: transfer from the zero address");
359         require(recipient != address(0), "ERC20: transfer to the zero address");
360 
361         _beforeTokenTransfer(sender, recipient, amount);
362 
363         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
364         _balances[recipient] = _balances[recipient].add(amount);
365         emit Transfer(sender, recipient, amount);
366     }
367 
368     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
369      * the total supply.
370      *
371      * Emits a {Transfer} event with `from` set to the zero address.
372      *
373      * Requirements:
374      *
375      * - `account` cannot be the zero address.
376      */
377     function _mint(address account, uint256 amount) internal virtual {
378         require(account != address(0), "ERC20: mint to the zero address");
379 
380         _beforeTokenTransfer(address(0), account, amount);
381 
382         _totalSupply = _totalSupply.add(amount);
383         _balances[account] = _balances[account].add(amount);
384         emit Transfer(address(0), account, amount);
385     }
386 
387     /**
388      * @dev Destroys `amount` tokens from `account`, reducing the
389      * total supply.
390      *
391      * Emits a {Transfer} event with `to` set to the zero address.
392      *
393      * Requirements:
394      *
395      * - `account` cannot be the zero address.
396      * - `account` must have at least `amount` tokens.
397      */
398     function _burn(address account, uint256 amount) internal virtual {
399         require(account != address(0), "ERC20: burn from the zero address");
400 
401         _beforeTokenTransfer(account, address(0), amount);
402 
403         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
404         _totalSupply = _totalSupply.sub(amount);
405         emit Transfer(account, address(0), amount);
406     }
407 
408     /**
409      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
410      *
411      * This internal function is equivalent to `approve`, and can be used to
412      * e.g. set automatic allowances for certain subsystems, etc.
413      *
414      * Emits an {Approval} event.
415      *
416      * Requirements:
417      *
418      * - `owner` cannot be the zero address.
419      * - `spender` cannot be the zero address.
420      */
421     function _approve(
422         address owner,
423         address spender,
424         uint256 amount
425     ) internal virtual {
426         require(owner != address(0), "ERC20: approve from the zero address");
427         require(spender != address(0), "ERC20: approve to the zero address");
428 
429         _allowances[owner][spender] = amount;
430         emit Approval(owner, spender, amount);
431     }
432 
433     /**
434      * @dev Hook that is called before any transfer of tokens. This includes
435      * minting and burning.
436      *
437      * Calling conditions:
438      *
439      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
440      * will be to transferred to `to`.
441      * - when `from` is zero, `amount` tokens will be minted for `to`.
442      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
443      * - `from` and `to` are never both zero.
444      *
445      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
446      */
447     function _beforeTokenTransfer(
448         address from,
449         address to,
450         uint256 amount
451     ) internal virtual {}
452 }
453 
454 library SafeMath {
455     /**
456      * @dev Returns the addition of two unsigned integers, reverting on
457      * overflow.
458      *
459      * Counterpart to Solidity's `+` operator.
460      *
461      * Requirements:
462      *
463      * - Addition cannot overflow.
464      */
465     function add(uint256 a, uint256 b) internal pure returns (uint256) {
466         uint256 c = a + b;
467         require(c >= a, "SafeMath: addition overflow");
468 
469         return c;
470     }
471 
472     /**
473      * @dev Returns the subtraction of two unsigned integers, reverting on
474      * overflow (when the result is negative).
475      *
476      * Counterpart to Solidity's `-` operator.
477      *
478      * Requirements:
479      *
480      * - Subtraction cannot overflow.
481      */
482     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
483         return sub(a, b, "SafeMath: subtraction overflow");
484     }
485 
486     /**
487      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
488      * overflow (when the result is negative).
489      *
490      * Counterpart to Solidity's `-` operator.
491      *
492      * Requirements:
493      *
494      * - Subtraction cannot overflow.
495      */
496     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
497         require(b <= a, errorMessage);
498         uint256 c = a - b;
499 
500         return c;
501     }
502 
503     /**
504      * @dev Returns the multiplication of two unsigned integers, reverting on
505      * overflow.
506      *
507      * Counterpart to Solidity's `*` operator.
508      *
509      * Requirements:
510      *
511      * - Multiplication cannot overflow.
512      */
513     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
514         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
515         // benefit is lost if 'b' is also tested.
516         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
517         if (a == 0) {
518             return 0;
519         }
520 
521         uint256 c = a * b;
522         require(c / a == b, "SafeMath: multiplication overflow");
523 
524         return c;
525     }
526 
527     /**
528      * @dev Returns the integer division of two unsigned integers. Reverts on
529      * division by zero. The result is rounded towards zero.
530      *
531      * Counterpart to Solidity's `/` operator. Note: this function uses a
532      * `revert` opcode (which leaves remaining gas untouched) while Solidity
533      * uses an invalid opcode to revert (consuming all remaining gas).
534      *
535      * Requirements:
536      *
537      * - The divisor cannot be zero.
538      */
539     function div(uint256 a, uint256 b) internal pure returns (uint256) {
540         return div(a, b, "SafeMath: division by zero");
541     }
542 
543     /**
544      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
545      * division by zero. The result is rounded towards zero.
546      *
547      * Counterpart to Solidity's `/` operator. Note: this function uses a
548      * `revert` opcode (which leaves remaining gas untouched) while Solidity
549      * uses an invalid opcode to revert (consuming all remaining gas).
550      *
551      * Requirements:
552      *
553      * - The divisor cannot be zero.
554      */
555     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
556         require(b > 0, errorMessage);
557         uint256 c = a / b;
558         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
559 
560         return c;
561     }
562 
563     /**
564      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
565      * Reverts when dividing by zero.
566      *
567      * Counterpart to Solidity's `%` operator. This function uses a `revert`
568      * opcode (which leaves remaining gas untouched) while Solidity uses an
569      * invalid opcode to revert (consuming all remaining gas).
570      *
571      * Requirements:
572      *
573      * - The divisor cannot be zero.
574      */
575     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
576         return mod(a, b, "SafeMath: modulo by zero");
577     }
578 
579     /**
580      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
581      * Reverts with custom message when dividing by zero.
582      *
583      * Counterpart to Solidity's `%` operator. This function uses a `revert`
584      * opcode (which leaves remaining gas untouched) while Solidity uses an
585      * invalid opcode to revert (consuming all remaining gas).
586      *
587      * Requirements:
588      *
589      * - The divisor cannot be zero.
590      */
591     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
592         require(b != 0, errorMessage);
593         return a % b;
594     }
595 }
596 
597 contract Ownable is Context {
598     address private _owner;
599 
600     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
601     
602     /**
603      * @dev Initializes the contract setting the deployer as the initial owner.
604      */
605     constructor () {
606         address msgSender = _msgSender();
607         _owner = msgSender;
608         emit OwnershipTransferred(address(0), msgSender);
609     }
610 
611     /**
612      * @dev Returns the address of the current owner.
613      */
614     function owner() public view returns (address) {
615         return _owner;
616     }
617 
618     /**
619      * @dev Throws if called by any account other than the owner.
620      */
621     modifier onlyOwner() {
622         require(_owner == _msgSender(), "Ownable: caller is not the owner");
623         _;
624     }
625 
626     /**
627      * @dev Leaves the contract without owner. It will not be possible to call
628      * `onlyOwner` functions anymore. Can only be called by the current owner.
629      *
630      * NOTE: Renouncing ownership will leave the contract without an owner,
631      * thereby removing any functionality that is only available to the owner.
632      */
633     function renounceOwnership() public virtual onlyOwner {
634         emit OwnershipTransferred(_owner, address(0));
635         _owner = address(0);
636     }
637 
638     /**
639      * @dev Transfers ownership of the contract to a new account (`newOwner`).
640      * Can only be called by the current owner.
641      */
642     function transferOwnership(address newOwner) public virtual onlyOwner {
643         require(newOwner != address(0), "Ownable: new owner is the zero address");
644         emit OwnershipTransferred(_owner, newOwner);
645         _owner = newOwner;
646     }
647 }
648 
649 
650 
651 library SafeMathInt {
652     int256 private constant MIN_INT256 = int256(1) << 255;
653     int256 private constant MAX_INT256 = ~(int256(1) << 255);
654 
655     /**
656      * @dev Multiplies two int256 variables and fails on overflow.
657      */
658     function mul(int256 a, int256 b) internal pure returns (int256) {
659         int256 c = a * b;
660 
661         // Detect overflow when multiplying MIN_INT256 with -1
662         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
663         require((b == 0) || (c / b == a));
664         return c;
665     }
666 
667     /**
668      * @dev Division of two int256 variables and fails on overflow.
669      */
670     function div(int256 a, int256 b) internal pure returns (int256) {
671         // Prevent overflow when dividing MIN_INT256 by -1
672         require(b != -1 || a != MIN_INT256);
673 
674         // Solidity already throws when dividing by 0.
675         return a / b;
676     }
677 
678     /**
679      * @dev Subtracts two int256 variables and fails on overflow.
680      */
681     function sub(int256 a, int256 b) internal pure returns (int256) {
682         int256 c = a - b;
683         require((b >= 0 && c <= a) || (b < 0 && c > a));
684         return c;
685     }
686 
687     /**
688      * @dev Adds two int256 variables and fails on overflow.
689      */
690     function add(int256 a, int256 b) internal pure returns (int256) {
691         int256 c = a + b;
692         require((b >= 0 && c >= a) || (b < 0 && c < a));
693         return c;
694     }
695 
696     /**
697      * @dev Converts to absolute value, and fails on overflow.
698      */
699     function abs(int256 a) internal pure returns (int256) {
700         require(a != MIN_INT256);
701         return a < 0 ? -a : a;
702     }
703 
704 
705     function toUint256Safe(int256 a) internal pure returns (uint256) {
706         require(a >= 0);
707         return uint256(a);
708     }
709 }
710 
711 library SafeMathUint {
712   function toInt256Safe(uint256 a) internal pure returns (int256) {
713     int256 b = int256(a);
714     require(b >= 0);
715     return b;
716   }
717 }
718 
719 
720 interface IUniswapV2Router01 {
721     function factory() external pure returns (address);
722     function WETH() external pure returns (address);
723 
724     function addLiquidity(
725         address tokenA,
726         address tokenB,
727         uint amountADesired,
728         uint amountBDesired,
729         uint amountAMin,
730         uint amountBMin,
731         address to,
732         uint deadline
733     ) external returns (uint amountA, uint amountB, uint liquidity);
734     function addLiquidityETH(
735         address token,
736         uint amountTokenDesired,
737         uint amountTokenMin,
738         uint amountETHMin,
739         address to,
740         uint deadline
741     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
742     function removeLiquidity(
743         address tokenA,
744         address tokenB,
745         uint liquidity,
746         uint amountAMin,
747         uint amountBMin,
748         address to,
749         uint deadline
750     ) external returns (uint amountA, uint amountB);
751     function removeLiquidityETH(
752         address token,
753         uint liquidity,
754         uint amountTokenMin,
755         uint amountETHMin,
756         address to,
757         uint deadline
758     ) external returns (uint amountToken, uint amountETH);
759     function removeLiquidityWithPermit(
760         address tokenA,
761         address tokenB,
762         uint liquidity,
763         uint amountAMin,
764         uint amountBMin,
765         address to,
766         uint deadline,
767         bool approveMax, uint8 v, bytes32 r, bytes32 s
768     ) external returns (uint amountA, uint amountB);
769     function removeLiquidityETHWithPermit(
770         address token,
771         uint liquidity,
772         uint amountTokenMin,
773         uint amountETHMin,
774         address to,
775         uint deadline,
776         bool approveMax, uint8 v, bytes32 r, bytes32 s
777     ) external returns (uint amountToken, uint amountETH);
778     function swapExactTokensForTokens(
779         uint amountIn,
780         uint amountOutMin,
781         address[] calldata path,
782         address to,
783         uint deadline
784     ) external returns (uint[] memory amounts);
785     function swapTokensForExactTokens(
786         uint amountOut,
787         uint amountInMax,
788         address[] calldata path,
789         address to,
790         uint deadline
791     ) external returns (uint[] memory amounts);
792     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
793         external
794         payable
795         returns (uint[] memory amounts);
796     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
797         external
798         returns (uint[] memory amounts);
799     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
800         external
801         returns (uint[] memory amounts);
802     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
803         external
804         payable
805         returns (uint[] memory amounts);
806 
807     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
808     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
809     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
810     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
811     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
812 }
813 
814 interface IUniswapV2Router02 is IUniswapV2Router01 {
815     function removeLiquidityETHSupportingFeeOnTransferTokens(
816         address token,
817         uint liquidity,
818         uint amountTokenMin,
819         uint amountETHMin,
820         address to,
821         uint deadline
822     ) external returns (uint amountETH);
823     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
824         address token,
825         uint liquidity,
826         uint amountTokenMin,
827         uint amountETHMin,
828         address to,
829         uint deadline,
830         bool approveMax, uint8 v, bytes32 r, bytes32 s
831     ) external returns (uint amountETH);
832 
833     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
834         uint amountIn,
835         uint amountOutMin,
836         address[] calldata path,
837         address to,
838         uint deadline
839     ) external;
840     function swapExactETHForTokensSupportingFeeOnTransferTokens(
841         uint amountOutMin,
842         address[] calldata path,
843         address to,
844         uint deadline
845     ) external payable;
846     function swapExactTokensForETHSupportingFeeOnTransferTokens(
847         uint amountIn,
848         uint amountOutMin,
849         address[] calldata path,
850         address to,
851         uint deadline
852     ) external;
853 }
854 
855 contract LockToken is Ownable {
856     bool public isOpen = false;
857     mapping(address => bool) private _whiteList;
858     address public tradingEnablerRole;
859     
860     modifier open(address from, address to) {
861         require(isOpen || _whiteList[from] || _whiteList[to], "Not Open");
862         _;
863     }
864 
865     constructor() {
866         _whiteList[msg.sender] = true;
867         _whiteList[address(this)] = true;
868         tradingEnablerRole = owner();
869     }
870 
871     function enableTrade(bool _enable) external onlyOwner {
872         require(tradingEnablerRole == msg.sender, 'incompatible role!');
873         isOpen = _enable;
874     }
875 
876     function renounceTradingEnablerRole() public {
877         require(tradingEnablerRole == msg.sender, 'incompatible role!');
878         tradingEnablerRole = address(0x0);
879     }
880 
881     function preTrade(address[] memory _users) external onlyOwner {
882         for(uint8 i = 0; i < _users.length; i++) {
883             _whiteList[_users[i]] = true;
884         }
885     }
886 }
887 
888 contract Vinlink is ERC20, LockToken {
889     using SafeMath for uint256;
890 
891     IUniswapV2Router02 public immutable uniswapV2Router;
892     address public immutable uniswapV2Pair;
893     address public constant deadAddress = address(0xdead);
894 
895     bool private swapping;
896 
897     address public developmentWallet;
898     address public treasuryWallet;
899     
900     uint256 public maxTransactionAmount;
901     uint256 public swapTokensAtAmount;
902     uint256 public maxWallet;
903 
904     bool public swapEnabled = true;
905 
906     uint256 public buyTotalFees;
907     uint256 public buyDevFee;
908     uint256 public buyLiquidityFee;
909     uint256 public buyTreasury;
910     
911     uint256 public sellTotalFees;
912     uint256 public sellDevFee;
913     uint256 public sellLiquidityFee;
914     uint256 public sellTreasury;
915     
916     uint256 public tokensForDev;
917     uint256 public tokensForLiquidity;
918     uint256 public tokensForTreasury;
919     
920     /******************/
921 
922     // exlcude from fees and max transaction amount
923     mapping (address => bool) private _isExcludedFromFees;
924     mapping (address => bool) public _isExcludedMaxTransactionAmount;
925 
926     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
927     // could be subject to a maximum transfer amount
928     mapping (address => bool) public automatedMarketMakerPairs;
929 
930     event UpdateUniswapV2Router(address indexed newAddress, address indexed oldAddress);
931 
932     event ExcludeFromFees(address indexed account, bool isExcluded);
933 
934     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
935 
936     event developmentWalletUpdated(address indexed newWallet, address indexed oldWallet);
937     
938     event treasuryWalletUpdated(address indexed newWallet, address indexed oldWallet);
939 
940     event SwapAndLiquify(
941         uint256 tokensSwapped,
942         uint256 ethReceived,
943         uint256 tokensIntoLiquidity
944     );
945 
946     event BuyBackTriggered(uint256 amount);
947 
948     constructor() ERC20("VINLINK", "VINLINK") {
949 
950         address newOwner = address(msg.sender);
951         
952         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
953         
954         excludeFromMaxTransaction(address(_uniswapV2Router), true);
955         uniswapV2Router = _uniswapV2Router;
956         
957         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
958         excludeFromMaxTransaction(address(uniswapV2Pair), true);
959         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
960         
961         uint256 _buyDevFee = 12;
962         uint256 _buyLiquidityFee = 12;
963         uint256 _buyTreasury = 12;
964         
965         uint256 _sellDevFee = 12;
966         uint256 _sellLiquidityFee = 12;
967         uint256 _sellTreasury = 12;
968         
969         uint256 totalSupply = 100e9 * 1e9;
970         
971         maxTransactionAmount = 1000000000 * 10e9; // 1% maxTransactionAmountTxn
972         swapTokensAtAmount = totalSupply * 5 / 10000; // 0.05% swap wallet
973         maxWallet = 1000000000 * 10e9; // 1% max wallet
974 
975         buyDevFee = _buyDevFee;
976         buyLiquidityFee = _buyLiquidityFee;
977         buyTreasury = _buyTreasury;
978         buyTotalFees = buyDevFee + buyLiquidityFee + buyTreasury;
979         
980         sellDevFee = _sellDevFee;
981         sellLiquidityFee = _sellLiquidityFee;
982         sellTreasury = _sellTreasury;
983         sellTotalFees = sellDevFee + sellLiquidityFee + sellTreasury;
984         
985         developmentWallet = address(0x2d7461c335afaC99A54C859562296bAb655E6060); // set as Development wallet
986         treasuryWallet = address(0x841f17161f325c30752d535561D91924a6EB1a95); // set as treasury wallet
987 
988         // exclude from paying fees or having max transaction amount
989         excludeFromFees(newOwner, true);
990         excludeFromFees(address(this), true);
991         excludeFromFees(address(0xdead), true);
992         excludeFromFees(treasuryWallet, true);
993         
994         excludeFromMaxTransaction(newOwner, true);
995         excludeFromMaxTransaction(address(this), true);
996         excludeFromMaxTransaction(treasuryWallet, true);
997         excludeFromMaxTransaction(address(0xdead), true);
998         
999         /*
1000             _mint is an internal function in ERC20.sol that is only called here,
1001             and CANNOT be called ever again
1002         */
1003         _mint(newOwner, totalSupply);
1004         transferOwnership(newOwner);
1005     }
1006 
1007     receive() external payable {
1008 
1009     }
1010     
1011      // change the minimum amount of tokens to sell from fees
1012     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner returns (bool){
1013         require(newAmount >= totalSupply() * 1 / 100000, "Swap amount cannot be lower than 0.001% total supply.");
1014         require(newAmount <= totalSupply() * 5 / 1000, "Swap amount cannot be higher than 0.5% total supply.");
1015         swapTokensAtAmount = newAmount;
1016         return true;
1017     }
1018     
1019     function updateMaxAmount(uint256 newNum) external onlyOwner {
1020         require(newNum >= (totalSupply() * 5 / 1000)/1e9, "Cannot set maxTransactionAmount lower than 0.5%");
1021         maxTransactionAmount = newNum * (10**9);
1022     }
1023 
1024     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
1025         require (newNum >= (totalSupply() * 3 / 1000)/1e9, "Cannot set maxWallet lower than 0.3%");
1026         maxWallet = newNum * (10**9);
1027     }
1028     
1029     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
1030         _isExcludedMaxTransactionAmount[updAds] = isEx;
1031     }
1032     
1033     // only use to disable contract sales if absolutely necessary (emergency use only)
1034     function updateSwapEnabled(bool enabled) external onlyOwner(){
1035         swapEnabled = enabled;
1036     }
1037     
1038     function updateBuyFees(uint256 _devFee, uint256 _liquidityFee, uint256 _treasuryFee) external onlyOwner {
1039         buyDevFee = _devFee;
1040         buyLiquidityFee = _liquidityFee;
1041         buyTreasury = _treasuryFee;
1042         buyTotalFees = buyDevFee + buyLiquidityFee + buyTreasury;
1043         require(buyTotalFees <= 30, "Must keep fees at 30% or less");
1044     }
1045     
1046     function updateSellFees(uint256 _devFee, uint256 _liquidityFee, uint256 _treasuryFee) external onlyOwner {
1047         sellDevFee = _devFee;
1048         sellLiquidityFee = _liquidityFee;
1049         sellTreasury = _treasuryFee;
1050         sellTotalFees = sellDevFee + sellLiquidityFee + sellTreasury;
1051         require(sellTotalFees <= 30, "Must keep fees at 30% or less");
1052     }
1053 
1054     function excludeFromFees(address account, bool excluded) public onlyOwner {
1055         _isExcludedFromFees[account] = excluded;
1056         emit ExcludeFromFees(account, excluded);
1057     }
1058 
1059     function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
1060         require(pair != uniswapV2Pair, "The pair cannot be removed from automatedMarketMakerPairs");
1061 
1062         _setAutomatedMarketMakerPair(pair, value);
1063     }
1064 
1065     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1066         automatedMarketMakerPairs[pair] = value;
1067 
1068         emit SetAutomatedMarketMakerPair(pair, value);
1069     }
1070 
1071     function updatedevelopmentWallet(address newdevelopmentWallet) external onlyOwner {
1072         emit developmentWalletUpdated(newdevelopmentWallet, developmentWallet);
1073         developmentWallet = newdevelopmentWallet;
1074     }
1075     
1076     function updatetreasuryWallet(address newWallet) external onlyOwner {
1077         emit treasuryWalletUpdated(newWallet, treasuryWallet);
1078         treasuryWallet = newWallet;
1079     }
1080     
1081 
1082     function isExcludedFromFees(address account) public view returns(bool) {
1083         return _isExcludedFromFees[account];
1084     }
1085 
1086     function _transfer(
1087         address from,
1088         address to,
1089         uint256 amount
1090     ) open(to, from)internal override {
1091         require(from != address(0), "ERC20: transfer from the zero address");
1092         require(to != address(0), "ERC20: transfer to the zero address");
1093         
1094          if(amount == 0) {
1095             super._transfer(from, to, 0);
1096             return;
1097         }
1098         
1099        
1100             if (
1101                 from != owner() &&
1102                 to != owner() &&
1103                 to != address(0) &&
1104                 to != address(0xdead) &&
1105                 !swapping
1106             ){
1107                  
1108                 //when buy
1109                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
1110                         require(amount <= maxTransactionAmount, "Buy transfer amount exceeds the maxTransactionAmount.");
1111                         require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
1112                 }
1113                 
1114                 //when sell
1115                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
1116                         require(amount <= maxTransactionAmount, "Sell transfer amount exceeds the maxTransactionAmount.");
1117                 }
1118                 else {
1119                     require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
1120                 }
1121             }
1122         
1123         
1124         
1125         uint256 contractTokenBalance = balanceOf(address(this));
1126         
1127         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1128 
1129         if( 
1130             canSwap &&
1131             swapEnabled &&
1132             !swapping &&
1133             !automatedMarketMakerPairs[from] &&
1134             !_isExcludedFromFees[from] &&
1135             !_isExcludedFromFees[to]
1136         ) {
1137             swapping = true;
1138             
1139             swapBack();
1140 
1141             swapping = false;
1142         }
1143         
1144         bool takeFee = !swapping;
1145 
1146         // if any account belongs to _isExcludedFromFee account then remove the fee
1147         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1148             takeFee = false;
1149         }
1150         
1151         uint256 fees = 0;
1152         // only take fees on buys/sells, do not take on wallet transfers
1153         if(takeFee){
1154             // on sell
1155             if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
1156                 fees = amount.mul(sellTotalFees).div(100);
1157                 tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
1158                 tokensForTreasury += fees * sellTreasury / sellTotalFees;
1159                 tokensForDev += fees * sellDevFee / sellTotalFees;
1160             }
1161             // on buy
1162             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1163                 fees = amount.mul(buyTotalFees).div(100);
1164                 tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
1165                 tokensForTreasury += fees * buyTreasury / buyTotalFees;
1166                 tokensForDev += fees * buyDevFee / buyTotalFees;
1167             }
1168             
1169             if(fees > 0){    
1170                 super._transfer(from, address(this), fees);
1171             }
1172             
1173             amount -= fees;
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
1199     
1200     
1201     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1202         // approve token transfer to cover all possible scenarios
1203         _approve(address(this), address(uniswapV2Router), tokenAmount);
1204 
1205         // add the liquidity
1206         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1207             address(this),
1208             tokenAmount,
1209             0, // slippage is unavoidable
1210             0, // slippage is unavoidable
1211             deadAddress,
1212             block.timestamp
1213         );
1214     }
1215 
1216     function swapBack() private {
1217         uint256 contractBalance = balanceOf(address(this));
1218         uint256 totalTokensToSwap = tokensForLiquidity + tokensForDev + tokensForTreasury;
1219         
1220         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
1221         
1222         // Halve the amount of liquidity tokens
1223         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
1224         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1225         
1226         uint256 initialETHBalance = address(this).balance;
1227 
1228         swapTokensForEth(amountToSwapForETH); 
1229         
1230         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1231         
1232         uint256 ethForMarketing = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
1233         uint256 ethForBuyBack = ethBalance.mul(tokensForTreasury).div(totalTokensToSwap);
1234         
1235         
1236         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForBuyBack;
1237         
1238         
1239         tokensForLiquidity = 0;
1240         tokensForDev = 0;
1241         tokensForTreasury = 0;
1242         
1243         (bool success,) = address(developmentWallet).call{value: ethForMarketing}("");
1244         if(liquidityTokens > 0 && ethForLiquidity > 0){
1245             addLiquidity(liquidityTokens, ethForLiquidity);
1246             emit SwapAndLiquify(amountToSwapForETH, ethForLiquidity, tokensForLiquidity);
1247         }
1248         
1249         // keep leftover ETH for buyback
1250         (success,) = address(treasuryWallet).call{value: address(this).balance}("");
1251     }
1252     
1253     // useful for buybacks or to reclaim any ETH on the contract in a way that helps holders.
1254     function buyBackTokens(uint256 ETHAmountInWei) external onlyOwner {
1255         // generate the uniswap pair path of weth -> eth
1256         address[] memory path = new address[](2);
1257         path[0] = uniswapV2Router.WETH();
1258         path[1] = address(this);
1259 
1260         // make the swap
1261         uniswapV2Router.swapExactETHForTokensSupportingFeeOnTransferTokens{value: ETHAmountInWei}(
1262             0, // accept any amount of Ethereum
1263             path,
1264             address(0xdead),
1265             block.timestamp
1266         );
1267         emit BuyBackTriggered(ETHAmountInWei);
1268     }
1269 
1270     function withdrawStuckETH() external onlyOwner{
1271         require (address(this).balance > 0, "Can't withdraw negative or zero");
1272         payable(owner()).transfer(address(this).balance);
1273     }
1274 
1275     function removeStuckToken(address _address) external onlyOwner {
1276         require(_address != address(this), "Can't withdraw tokens destined for liquidity");
1277         require(IERC20(_address).balanceOf(address(this)) > 0, "Can't withdraw 0");
1278 
1279         IERC20(_address).transfer(owner(), IERC20(_address).balanceOf(address(this)));
1280     }
1281 
1282 }