1 // SPDX-License-Identifier: MIT                                                                               
2                                                     
3 pragma solidity ^0.8.9;
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
231         return 18;
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
855 contract LowClub is ERC20, Ownable {
856     using SafeMath for uint256;
857 
858     IUniswapV2Router02 public immutable uniswapV2Router;
859     address public immutable uniswapV2Pair;
860     address public constant deadAddress = address(0xdead);
861 
862     bool private swapping;
863 
864     address public marketingWallet;
865     address public devWallet;
866     address public buyBackWallet;
867     
868     uint256 public maxTransactionAmount;
869     uint256 public maxWallet;
870     uint8 private _decimals;
871 
872     bool public limitsInEffect = true;
873     bool public tradingActive = false;
874     bool public swapEnabled = false;
875     bool public rescueSwap = false;
876     bool public antiMevBot = false;
877     
878     uint256 public tradingActiveBlock;
879     uint256 public currentBlock;
880     uint256 public blockTxCount = 0;
881         
882     uint256 public buyTotalFees;
883     uint256 public buyMarketingFee;
884     uint256 public buyLiquidityFee;
885     uint256 public buyDevFee;
886     uint256 public buyBuyBackFee;
887     
888     uint256 public sellTotalFees;
889     uint256 public sellMarketingFee;
890     uint256 public sellLiquidityFee;
891     uint256 public sellDevFee;
892     uint256 public sellBuyBackFee;
893     
894     uint256 public tokensForMarketing;
895     uint256 public tokensForLiquidity;
896     uint256 public tokensForDev;
897     uint256 public tokensForBuyBack;
898     
899     /******************/
900 
901     // exlcude from fees and max transaction amount
902     mapping (address => bool) private _isExcludedFromFees;
903     mapping (address => bool) public _isExcludedMaxTransactionAmount;
904 
905     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
906     // could be subject to a maximum transfer amount
907     mapping (address => bool) public automatedMarketMakerPairs;
908 
909     event UpdateUniswapV2Router(address indexed newAddress, address indexed oldAddress);
910 
911     event ExcludeFromFees(address indexed account, bool isExcluded);
912 
913     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
914 
915     event marketingWalletUpdated(address indexed newWallet, address indexed oldWallet);
916     
917     event devWalletUpdated(address indexed newWallet, address indexed oldWallet);
918     
919     event buyBackWalletUpdated(address indexed newWallet, address indexed oldWallet);
920 
921     event SwapAndLiquify(
922         uint256 tokensSwapped,
923         uint256 ethReceived,
924         uint256 tokensIntoLiquidity
925     );
926 
927     event BuyBackTriggered(uint256 amount);
928     
929     event OwnerForcedSwapBack(uint256 timestamp);
930 
931     constructor() ERC20("LowClub", "LOWC") {
932 
933         address _owner = 0xAe6007C18e4b844D4BE22A05DEbc017B971CCCf1;
934 
935         _decimals = 18;
936 
937         uint256 totalSupply = 100000000 * (10**_decimals);
938         
939         maxTransactionAmount = totalSupply * 2 / 1000; // 0.2% maxTransactionAmountTxn
940         maxWallet = totalSupply * 2 / 1000; // 0.2% maxWallet
941 
942         buyMarketingFee = 0;
943         buyLiquidityFee = 0;
944         buyDevFee = 0;
945         buyBuyBackFee = 0;
946         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee + buyBuyBackFee;
947         
948         sellMarketingFee = 0;
949         sellLiquidityFee = 0;
950         sellDevFee = 0;
951         sellBuyBackFee = 0;
952         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee + sellBuyBackFee;
953 
954         marketingWallet = address(0xAe6007C18e4b844D4BE22A05DEbc017B971CCCf1); // set as marketing wallet
955         devWallet = address(0xAe6007C18e4b844D4BE22A05DEbc017B971CCCf1); // set as dev wallet
956         buyBackWallet = address(0xAe6007C18e4b844D4BE22A05DEbc017B971CCCf1); // set as buyBackWallet
957 
958 
959         address currentRouter;
960         
961         //Adding Variables for all the routers for easier deployment for our customers.
962         if (block.chainid == 56) {
963             currentRouter = 0x10ED43C718714eb63d5aA57B78B54704E256024E; // PCS Router
964         } else if (block.chainid == 97) {
965             currentRouter = 0xD99D1c33F9fC3444f8101754aBC46c52416550D1; // PCS Testnet
966         } else if (block.chainid == 43114) {
967             currentRouter = 0x60aE616a2155Ee3d9A68541Ba4544862310933d4; //Avax Mainnet
968         } else if (block.chainid == 137) {
969             currentRouter = 0xa5E0829CaCEd8fFDD4De3c43696c57F7D7A678ff; //Polygon Ropsten
970         } else if (block.chainid == 250) {
971             currentRouter = 0xF491e7B69E4244ad4002BC14e878a34207E38c29; //SpookySwap FTM
972         } else if (block.chainid == 3) {
973             currentRouter = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D; //Ropsten
974         } else if (block.chainid == 1 || block.chainid == 4) {
975             currentRouter = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D; //Mainnet
976         } else {
977             revert();
978         }
979 
980         //End of Router Variables.
981 
982         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(currentRouter);
983 
984         excludeFromMaxTransaction(address(_uniswapV2Router), true);
985         uniswapV2Router = _uniswapV2Router;
986         
987         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
988         excludeFromMaxTransaction(address(uniswapV2Pair), true);
989         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
990 
991         // exclude from paying fees or having max transaction amount
992         excludeFromFees(_owner, true);
993         excludeFromFees(address(this), true);
994         excludeFromFees(address(0xdead), true);
995         
996         excludeFromMaxTransaction(_owner, true);
997         excludeFromMaxTransaction(address(this), true);
998         excludeFromMaxTransaction(address(0xdead), true);
999         
1000         /*
1001             _mint is an internal function in ERC20.sol that is only called here,
1002             and CANNOT be called ever again
1003         */
1004         _mint(_owner, totalSupply);
1005         transferOwnership(_owner);
1006     }
1007 
1008     receive() external payable {
1009 
1010     }
1011 
1012     // once enabled, can never be turned off
1013     function enableTrading() external onlyOwner {
1014         tradingActive = true;
1015         swapEnabled = true;
1016         tradingActiveBlock = block.number;
1017         antiMevBot = true;
1018     }
1019     
1020     // remove limits after token is stable
1021     function removeLimits() external onlyOwner returns (bool){
1022         limitsInEffect = false;
1023         return true;
1024     }
1025     
1026     function airdropToWallets(address[] memory airdropWallets, uint256[] memory amounts) external onlyOwner returns (bool){
1027         require(!tradingActive, "Trading is already active, cannot airdrop after launch.");
1028         require(airdropWallets.length == amounts.length, "arrays must be the same length");
1029         require(airdropWallets.length < 200, "Can only airdrop 200 wallets per txn due to gas limits"); // allows for airdrop + launch at the same exact time, reducing delays and reducing sniper input.
1030         for(uint256 i = 0; i < airdropWallets.length; i++){
1031             address wallet = airdropWallets[i];
1032             uint256 amount = amounts[i];
1033             _transfer(msg.sender, wallet, amount);
1034         }
1035         return true;
1036     }
1037     
1038     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
1039         _isExcludedMaxTransactionAmount[updAds] = isEx;
1040     }
1041 
1042     function decimals() public view override returns (uint8) {
1043         return _decimals;
1044     }
1045     
1046     // only use to disable contract sales if absolutely necessary (emergency use only)
1047     function updateSwapEnabled(bool enabled) external onlyOwner(){
1048         swapEnabled = enabled;
1049     }
1050 
1051     function updateAntiMevBotEnabled(bool enabled) external onlyOwner {
1052         antiMevBot = enabled;
1053     }
1054 
1055     // only use this to disable swapback and send tax in form of tokens
1056     function updateRescueSwap(bool enabled) external onlyOwner(){
1057         rescueSwap = enabled;
1058     }
1059 
1060     function excludeFromFees(address account, bool excluded) public onlyOwner {
1061         _isExcludedFromFees[account] = excluded;
1062         emit ExcludeFromFees(account, excluded);
1063     }
1064 
1065     function setAutomatedMarketMakerPair(address pair, bool value) external onlyOwner {
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
1077     function _transfer(
1078         address from,
1079         address to,
1080         uint256 amount
1081     ) internal override {
1082         require(from != address(0), "ERC20: transfer from the zero address");
1083         require(to != address(0), "ERC20: transfer to the zero address");
1084         if(!tradingActive){
1085             require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");
1086         }
1087          if(amount == 0) {
1088             super._transfer(from, to, 0);
1089             return;
1090         }
1091         
1092         if(limitsInEffect){
1093             if (
1094                 from != owner() &&
1095                 to != owner() &&
1096                 to != address(0) &&
1097                 to != address(0xdead) &&
1098                 !(_isExcludedFromFees[from] || _isExcludedFromFees[to]) &&
1099                 !swapping
1100             ){
1101                  
1102                 //when buy
1103                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
1104                         require(amount <= maxTransactionAmount, "Buy transfer amount exceeds the maxTransactionAmount.");
1105                         require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
1106                 }
1107                 
1108                 //when sell
1109                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
1110                         require(amount <= maxTransactionAmount, "Sell transfer amount exceeds the maxTransactionAmount.");
1111                 }
1112                 else {
1113                     require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
1114                 }
1115             }
1116         }
1117         
1118         uint256 contractTokenBalance = balanceOf(address(this));
1119         
1120         bool canSwap = contractTokenBalance > 0;
1121 
1122         if( 
1123             canSwap &&
1124             swapEnabled &&
1125             !swapping &&
1126             !automatedMarketMakerPairs[from] &&
1127             !_isExcludedFromFees[from] &&
1128             !_isExcludedFromFees[to]
1129         ) {
1130             swapping = true;
1131             
1132             swapBack();
1133 
1134             swapping = false;
1135         }
1136         
1137         bool takeFee = !swapping;
1138 
1139         // if any account belongs to _isExcludedFromFee account then remove the fee
1140         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1141             takeFee = false;
1142         }
1143 
1144         if (!swapping && antiMevBot){
1145             if (currentBlock == block.number){
1146                 blockTxCount++;
1147                 require (blockTxCount <= 2, "Max 2 tx per block to avoid sandwhich attack");
1148             }
1149             else{
1150                 currentBlock = block.number;
1151                 blockTxCount = 1;
1152             }
1153         }
1154         
1155         uint256 fees = 0;
1156         // only take fees on buys/sells, do not take on wallet transfers
1157         if(takeFee){
1158             
1159             if(tradingActiveBlock == block.number && (automatedMarketMakerPairs[to] || automatedMarketMakerPairs[from])){
1160                 fees = amount.mul(99).div(100);
1161                 tokensForLiquidity += fees * 33 / 99;
1162                 tokensForBuyBack += fees * 33 / 99;
1163                 tokensForMarketing += fees * 33 / 99;
1164             }
1165             // on sell
1166             else if (automatedMarketMakerPairs[to]){
1167                 if (sellTotalFees > 0){
1168                     fees = amount.mul(sellTotalFees).div(100);
1169                     tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
1170                     tokensForDev += fees * sellDevFee / sellTotalFees;
1171                     tokensForMarketing += fees * sellMarketingFee / sellTotalFees;
1172                     tokensForBuyBack += fees * sellBuyBackFee / sellTotalFees;
1173                 }
1174             }
1175             // on buy
1176             else if(automatedMarketMakerPairs[from]) {
1177                 if (buyTotalFees > 0){
1178                     fees = amount.mul(buyTotalFees).div(100);
1179                     tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
1180                     tokensForDev += fees * buyDevFee / buyTotalFees;
1181                     tokensForMarketing += fees * buyMarketingFee / buyTotalFees;
1182                     tokensForBuyBack += fees * buyBuyBackFee / buyTotalFees;
1183                 }
1184             }
1185             
1186             if(fees > 0){    
1187                 super._transfer(from, address(this), fees);
1188             }
1189             
1190             amount -= fees;
1191         }
1192 
1193         super._transfer(from, to, amount);
1194     }
1195 
1196     function swapTokensForEth(uint256 tokenAmount) private {
1197 
1198         // generate the uniswap pair path of token -> weth
1199         address[] memory path = new address[](2);
1200         path[0] = address(this);
1201         path[1] = uniswapV2Router.WETH();
1202 
1203         _approve(address(this), address(uniswapV2Router), tokenAmount);
1204 
1205         // make the swap
1206         try uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1207             tokenAmount,
1208             0, // accept any amount of ETH
1209             path,
1210             address(this),
1211             block.timestamp
1212         ) {} catch {}
1213         
1214     }
1215     
1216     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1217         // approve token transfer to cover all possible scenarios
1218         _approve(address(this), address(uniswapV2Router), tokenAmount);
1219 
1220         // add the liquidity
1221         try uniswapV2Router.addLiquidityETH{value: ethAmount}(
1222             address(this),
1223             tokenAmount,
1224             0, // slippage is unavoidable
1225             0, // slippage is unavoidable
1226             deadAddress,
1227             block.timestamp
1228         ) {} catch {}
1229     }
1230 
1231     function resetTaxAmount() public onlyOwner {
1232         tokensForLiquidity = 0;
1233         tokensForMarketing = 0;
1234         tokensForDev = 0;
1235         tokensForBuyBack = 0;
1236     }
1237 
1238     function swapBack() private {
1239         uint256 contractBalance = balanceOf(address(this));
1240 
1241         if (rescueSwap){
1242             if (contractBalance > 0){
1243                 super._transfer(address(this), marketingWallet, contractBalance);
1244             }
1245             return;
1246         }
1247 
1248         uint256 totalTokensToSwap = tokensForLiquidity + tokensForMarketing + tokensForDev + tokensForBuyBack;
1249         bool success;
1250         
1251         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
1252         
1253         // Halve the amount of liquidity tokens
1254         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
1255         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1256         
1257         uint256 initialETHBalance = address(this).balance;
1258 
1259         swapTokensForEth(amountToSwapForETH); 
1260         
1261         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1262         
1263         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(totalTokensToSwap);
1264         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
1265         uint256 ethForBuyBack = ethBalance.mul(tokensForBuyBack).div(totalTokensToSwap);
1266         
1267         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev - ethForBuyBack;
1268         
1269         tokensForLiquidity = 0;
1270         tokensForMarketing = 0;
1271         tokensForDev = 0;
1272         tokensForBuyBack = 0;
1273         
1274         (success,) = address(devWallet).call{value: ethForDev}("");
1275         (success,) = address(buyBackWallet).call{value: ethForBuyBack}("");
1276         
1277         if(liquidityTokens > 0 && ethForLiquidity > 0){
1278             addLiquidity(liquidityTokens, ethForLiquidity);
1279             emit SwapAndLiquify(amountToSwapForETH, ethForLiquidity, tokensForLiquidity);
1280         }
1281         
1282         (success,) = address(marketingWallet).call{value: address(this).balance}("");
1283         
1284     }
1285 }