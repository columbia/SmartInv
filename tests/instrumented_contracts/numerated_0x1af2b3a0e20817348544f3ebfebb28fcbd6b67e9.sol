1 // A Unique Version of the Chinese Oracle for Making Decisions and Discovering Your Destiny
2 
3 // SPDX-License-Identifier: MIT                                                                               
4                                                     
5 pragma solidity 0.8.9;
6 
7 abstract contract Context {
8     function _msgSender() internal view virtual returns (address) {
9         return msg.sender;
10     }
11 
12     function _msgData() internal view virtual returns (bytes calldata) {
13         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
14         return msg.data;
15     }
16 }
17 
18 interface IUniswapV2Pair {
19     event Approval(address indexed owner, address indexed spender, uint value);
20     event Transfer(address indexed from, address indexed to, uint value);
21 
22     function name() external pure returns (string memory);
23     function symbol() external pure returns (string memory);
24     function decimals() external pure returns (uint8);
25     function totalSupply() external view returns (uint);
26     function balanceOf(address owner) external view returns (uint);
27     function allowance(address owner, address spender) external view returns (uint);
28 
29     function approve(address spender, uint value) external returns (bool);
30     function transfer(address to, uint value) external returns (bool);
31     function transferFrom(address from, address to, uint value) external returns (bool);
32 
33     function DOMAIN_SEPARATOR() external view returns (bytes32);
34     function PERMIT_TYPEHASH() external pure returns (bytes32);
35     function nonces(address owner) external view returns (uint);
36 
37     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
38 
39     event Mint(address indexed sender, uint amount0, uint amount1);
40     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
41     event Swap(
42         address indexed sender,
43         uint amount0In,
44         uint amount1In,
45         uint amount0Out,
46         uint amount1Out,
47         address indexed to
48     );
49     event Sync(uint112 reserve0, uint112 reserve1);
50 
51     function MINIMUM_LIQUIDITY() external pure returns (uint);
52     function factory() external view returns (address);
53     function token0() external view returns (address);
54     function token1() external view returns (address);
55     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
56     function price0CumulativeLast() external view returns (uint);
57     function price1CumulativeLast() external view returns (uint);
58     function kLast() external view returns (uint);
59 
60     function mint(address to) external returns (uint liquidity);
61     function burn(address to) external returns (uint amount0, uint amount1);
62     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
63     function skim(address to) external;
64     function sync() external;
65 
66     function initialize(address, address) external;
67 }
68 
69 interface IUniswapV2Factory {
70     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
71 
72     function feeTo() external view returns (address);
73     function feeToSetter() external view returns (address);
74 
75     function getPair(address tokenA, address tokenB) external view returns (address pair);
76     function allPairs(uint) external view returns (address pair);
77     function allPairsLength() external view returns (uint);
78 
79     function createPair(address tokenA, address tokenB) external returns (address pair);
80 
81     function setFeeTo(address) external;
82     function setFeeToSetter(address) external;
83 }
84 
85 interface IERC20 {
86     /**
87      * @dev Returns the amount of tokens in existence.
88      */
89     function totalSupply() external view returns (uint256);
90 
91     /**
92      * @dev Returns the amount of tokens owned by `account`.
93      */
94     function balanceOf(address account) external view returns (uint256);
95 
96     /**
97      * @dev Moves `amount` tokens from the caller's account to `recipient`.
98      *
99      * Returns a boolean value indicating whether the operation succeeded.
100      *
101      * Emits a {Transfer} event.
102      */
103     function transfer(address recipient, uint256 amount) external returns (bool);
104 
105     /**
106      * @dev Returns the remaining number of tokens that `spender` will be
107      * allowed to spend on behalf of `owner` through {transferFrom}. This is
108      * zero by default.
109      *
110      * This value changes when {approve} or {transferFrom} are called.
111      */
112     function allowance(address owner, address spender) external view returns (uint256);
113 
114     /**
115      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
116      *
117      * Returns a boolean value indicating whether the operation succeeded.
118      *
119      * IMPORTANT: Beware that changing an allowance with this method brings the risk
120      * that someone may use both the old and the new allowance by unfortunate
121      * transaction ordering. One possible solution to mitigate this race
122      * condition is to first reduce the spender's allowance to 0 and set the
123      * desired value afterwards:
124      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
125      *
126      * Emits an {Approval} event.
127      */
128     function approve(address spender, uint256 amount) external returns (bool);
129 
130     /**
131      * @dev Moves `amount` tokens from `sender` to `recipient` using the
132      * allowance mechanism. `amount` is then deducted from the caller's
133      * allowance.
134      *
135      * Returns a boolean value indicating whether the operation succeeded.
136      *
137      * Emits a {Transfer} event.
138      */
139     function transferFrom(
140         address sender,
141         address recipient,
142         uint256 amount
143     ) external returns (bool);
144 
145     /**
146      * @dev Emitted when `value` tokens are moved from one account (`from`) to
147      * another (`to`).
148      *
149      * Note that `value` may be zero.
150      */
151     event Transfer(address indexed from, address indexed to, uint256 value);
152 
153     /**
154      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
155      * a call to {approve}. `value` is the new allowance.
156      */
157     event Approval(address indexed owner, address indexed spender, uint256 value);
158 }
159 
160 interface IERC20Metadata is IERC20 {
161     /**
162      * @dev Returns the name of the token.
163      */
164     function name() external view returns (string memory);
165 
166     /**
167      * @dev Returns the symbol of the token.
168      */
169     function symbol() external view returns (string memory);
170 
171     /**
172      * @dev Returns the decimals places of the token.
173      */
174     function decimals() external view returns (uint8);
175 }
176 
177 
178 contract ERC20 is Context, IERC20, IERC20Metadata {
179     using SafeMath for uint256;
180 
181     mapping(address => uint256) private _balances;
182 
183     mapping(address => mapping(address => uint256)) private _allowances;
184 
185     uint256 private _totalSupply;
186 
187     string private _name;
188     string private _symbol;
189 
190     /**
191      * @dev Sets the values for {name} and {symbol}.
192      *
193      * The default value of {decimals} is 18. To select a different value for
194      * {decimals} you should overload it.
195      *
196      * All two of these values are immutable: they can only be set once during
197      * construction.
198      */
199     constructor(string memory name_, string memory symbol_) {
200         _name = name_;
201         _symbol = symbol_;
202     }
203 
204     /**
205      * @dev Returns the name of the token.
206      */
207     function name() public view virtual override returns (string memory) {
208         return _name;
209     }
210 
211     /**
212      * @dev Returns the symbol of the token, usually a shorter version of the
213      * name.
214      */
215     function symbol() public view virtual override returns (string memory) {
216         return _symbol;
217     }
218 
219     /**
220      * @dev Returns the number of decimals used to get its user representation.
221      * For example, if `decimals` equals `2`, a balance of `505` tokens should
222      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
223      *
224      * Tokens usually opt for a value of 18, imitating the relationship between
225      * Ether and Wei. This is the value {ERC20} uses, unless this function is
226      * overridden;
227      *
228      * NOTE: This information is only used for _display_ purposes: it in
229      * no way affects any of the arithmetic of the contract, including
230      * {IERC20-balanceOf} and {IERC20-transfer}.
231      */
232     function decimals() public view virtual override returns (uint8) {
233         return 18;
234     }
235 
236     /**
237      * @dev See {IERC20-totalSupply}.
238      */
239     function totalSupply() public view virtual override returns (uint256) {
240         return _totalSupply;
241     }
242 
243     /**
244      * @dev See {IERC20-balanceOf}.
245      */
246     function balanceOf(address account) public view virtual override returns (uint256) {
247         return _balances[account];
248     }
249 
250     /**
251      * @dev See {IERC20-transfer}.
252      *
253      * Requirements:
254      *
255      * - `recipient` cannot be the zero address.
256      * - the caller must have a balance of at least `amount`.
257      */
258     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
259         _transfer(_msgSender(), recipient, amount);
260         return true;
261     }
262 
263     /**
264      * @dev See {IERC20-allowance}.
265      */
266     function allowance(address owner, address spender) public view virtual override returns (uint256) {
267         return _allowances[owner][spender];
268     }
269 
270     /**
271      * @dev See {IERC20-approve}.
272      *
273      * Requirements:
274      *
275      * - `spender` cannot be the zero address.
276      */
277     function approve(address spender, uint256 amount) public virtual override returns (bool) {
278         _approve(_msgSender(), spender, amount);
279         return true;
280     }
281 
282     /**
283      * @dev See {IERC20-transferFrom}.
284      *
285      * Emits an {Approval} event indicating the updated allowance. This is not
286      * required by the EIP. See the note at the beginning of {ERC20}.
287      *
288      * Requirements:
289      *
290      * - `sender` and `recipient` cannot be the zero address.
291      * - `sender` must have a balance of at least `amount`.
292      * - the caller must have allowance for ``sender``'s tokens of at least
293      * `amount`.
294      */
295     function transferFrom(
296         address sender,
297         address recipient,
298         uint256 amount
299     ) public virtual override returns (bool) {
300         _transfer(sender, recipient, amount);
301         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
302         return true;
303     }
304 
305     /**
306      * @dev Atomically increases the allowance granted to `spender` by the caller.
307      *
308      * This is an alternative to {approve} that can be used as a mitigation for
309      * problems described in {IERC20-approve}.
310      *
311      * Emits an {Approval} event indicating the updated allowance.
312      *
313      * Requirements:
314      *
315      * - `spender` cannot be the zero address.
316      */
317     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
318         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
319         return true;
320     }
321 
322     /**
323      * @dev Atomically decreases the allowance granted to `spender` by the caller.
324      *
325      * This is an alternative to {approve} that can be used as a mitigation for
326      * problems described in {IERC20-approve}.
327      *
328      * Emits an {Approval} event indicating the updated allowance.
329      *
330      * Requirements:
331      *
332      * - `spender` cannot be the zero address.
333      * - `spender` must have allowance for the caller of at least
334      * `subtractedValue`.
335      */
336     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
337         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
338         return true;
339     }
340 
341     /**
342      * @dev Moves tokens `amount` from `sender` to `recipient`.
343      *
344      * This is internal function is equivalent to {transfer}, and can be used to
345      * e.g. implement automatic token fees, slashing mechanisms, etc.
346      *
347      * Emits a {Transfer} event.
348      *
349      * Requirements:
350      *
351      * - `sender` cannot be the zero address.
352      * - `recipient` cannot be the zero address.
353      * - `sender` must have a balance of at least `amount`.
354      */
355     function _transfer(
356         address sender,
357         address recipient,
358         uint256 amount
359     ) internal virtual {
360         require(sender != address(0), "ERC20: transfer from the zero address");
361         require(recipient != address(0), "ERC20: transfer to the zero address");
362 
363         _beforeTokenTransfer(sender, recipient, amount);
364 
365         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
366         _balances[recipient] = _balances[recipient].add(amount);
367         emit Transfer(sender, recipient, amount);
368     }
369 
370     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
371      * the total supply.
372      *
373      * Emits a {Transfer} event with `from` set to the zero address.
374      *
375      * Requirements:
376      *
377      * - `account` cannot be the zero address.
378      */
379     function _mint(address account, uint256 amount) internal virtual {
380         require(account != address(0), "ERC20: mint to the zero address");
381 
382         _beforeTokenTransfer(address(0), account, amount);
383 
384         _totalSupply = _totalSupply.add(amount);
385         _balances[account] = _balances[account].add(amount);
386         emit Transfer(address(0), account, amount);
387     }
388 
389     /**
390      * @dev Destroys `amount` tokens from `account`, reducing the
391      * total supply.
392      *
393      * Emits a {Transfer} event with `to` set to the zero address.
394      *
395      * Requirements:
396      *
397      * - `account` cannot be the zero address.
398      * - `account` must have at least `amount` tokens.
399      */
400     function _burn(address account, uint256 amount) internal virtual {
401         require(account != address(0), "ERC20: burn from the zero address");
402 
403         _beforeTokenTransfer(account, address(0), amount);
404 
405         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
406         _totalSupply = _totalSupply.sub(amount);
407         emit Transfer(account, address(0), amount);
408     }
409 
410     /**
411      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
412      *
413      * This internal function is equivalent to `approve`, and can be used to
414      * e.g. set automatic allowances for certain subsystems, etc.
415      *
416      * Emits an {Approval} event.
417      *
418      * Requirements:
419      *
420      * - `owner` cannot be the zero address.
421      * - `spender` cannot be the zero address.
422      */
423     function _approve(
424         address owner,
425         address spender,
426         uint256 amount
427     ) internal virtual {
428         require(owner != address(0), "ERC20: approve from the zero address");
429         require(spender != address(0), "ERC20: approve to the zero address");
430 
431         _allowances[owner][spender] = amount;
432         emit Approval(owner, spender, amount);
433     }
434 
435     /**
436      * @dev Hook that is called before any transfer of tokens. This includes
437      * minting and burning.
438      *
439      * Calling conditions:
440      *
441      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
442      * will be to transferred to `to`.
443      * - when `from` is zero, `amount` tokens will be minted for `to`.
444      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
445      * - `from` and `to` are never both zero.
446      *
447      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
448      */
449     function _beforeTokenTransfer(
450         address from,
451         address to,
452         uint256 amount
453     ) internal virtual {}
454 }
455 
456 library SafeMath {
457     /**
458      * @dev Returns the addition of two unsigned integers, reverting on
459      * overflow.
460      *
461      * Counterpart to Solidity's `+` operator.
462      *
463      * Requirements:
464      *
465      * - Addition cannot overflow.
466      */
467     function add(uint256 a, uint256 b) internal pure returns (uint256) {
468         uint256 c = a + b;
469         require(c >= a, "SafeMath: addition overflow");
470 
471         return c;
472     }
473 
474     /**
475      * @dev Returns the subtraction of two unsigned integers, reverting on
476      * overflow (when the result is negative).
477      *
478      * Counterpart to Solidity's `-` operator.
479      *
480      * Requirements:
481      *
482      * - Subtraction cannot overflow.
483      */
484     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
485         return sub(a, b, "SafeMath: subtraction overflow");
486     }
487 
488     /**
489      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
490      * overflow (when the result is negative).
491      *
492      * Counterpart to Solidity's `-` operator.
493      *
494      * Requirements:
495      *
496      * - Subtraction cannot overflow.
497      */
498     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
499         require(b <= a, errorMessage);
500         uint256 c = a - b;
501 
502         return c;
503     }
504 
505     /**
506      * @dev Returns the multiplication of two unsigned integers, reverting on
507      * overflow.
508      *
509      * Counterpart to Solidity's `*` operator.
510      *
511      * Requirements:
512      *
513      * - Multiplication cannot overflow.
514      */
515     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
516         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
517         // benefit is lost if 'b' is also tested.
518         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
519         if (a == 0) {
520             return 0;
521         }
522 
523         uint256 c = a * b;
524         require(c / a == b, "SafeMath: multiplication overflow");
525 
526         return c;
527     }
528 
529     /**
530      * @dev Returns the integer division of two unsigned integers. Reverts on
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
541     function div(uint256 a, uint256 b) internal pure returns (uint256) {
542         return div(a, b, "SafeMath: division by zero");
543     }
544 
545     /**
546      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
547      * division by zero. The result is rounded towards zero.
548      *
549      * Counterpart to Solidity's `/` operator. Note: this function uses a
550      * `revert` opcode (which leaves remaining gas untouched) while Solidity
551      * uses an invalid opcode to revert (consuming all remaining gas).
552      *
553      * Requirements:
554      *
555      * - The divisor cannot be zero.
556      */
557     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
558         require(b > 0, errorMessage);
559         uint256 c = a / b;
560         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
561 
562         return c;
563     }
564 
565     /**
566      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
567      * Reverts when dividing by zero.
568      *
569      * Counterpart to Solidity's `%` operator. This function uses a `revert`
570      * opcode (which leaves remaining gas untouched) while Solidity uses an
571      * invalid opcode to revert (consuming all remaining gas).
572      *
573      * Requirements:
574      *
575      * - The divisor cannot be zero.
576      */
577     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
578         return mod(a, b, "SafeMath: modulo by zero");
579     }
580 
581     /**
582      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
583      * Reverts with custom message when dividing by zero.
584      *
585      * Counterpart to Solidity's `%` operator. This function uses a `revert`
586      * opcode (which leaves remaining gas untouched) while Solidity uses an
587      * invalid opcode to revert (consuming all remaining gas).
588      *
589      * Requirements:
590      *
591      * - The divisor cannot be zero.
592      */
593     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
594         require(b != 0, errorMessage);
595         return a % b;
596     }
597 }
598 
599 contract Ownable is Context {
600     address private _owner;
601 
602     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
603     
604     /**
605      * @dev Initializes the contract setting the deployer as the initial owner.
606      */
607     constructor () {
608         address msgSender = _msgSender();
609         _owner = msgSender;
610         emit OwnershipTransferred(address(0), msgSender);
611     }
612 
613     /**
614      * @dev Returns the address of the current owner.
615      */
616     function owner() public view returns (address) {
617         return _owner;
618     }
619 
620     /**
621      * @dev Throws if called by any account other than the owner.
622      */
623     modifier onlyOwner() {
624         require(_owner == _msgSender(), "Ownable: caller is not the owner");
625         _;
626     }
627 
628     /**
629      * @dev Leaves the contract without owner. It will not be possible to call
630      * `onlyOwner` functions anymore. Can only be called by the current owner.
631      *
632      * NOTE: Renouncing ownership will leave the contract without an owner,
633      * thereby removing any functionality that is only available to the owner.
634      */
635     function renounceOwnership() public virtual onlyOwner {
636         emit OwnershipTransferred(_owner, address(0));
637         _owner = address(0);
638     }
639 
640     /**
641      * @dev Transfers ownership of the contract to a new account (`newOwner`).
642      * Can only be called by the current owner.
643      */
644     function transferOwnership(address newOwner) public virtual onlyOwner {
645         require(newOwner != address(0), "Ownable: new owner is the zero address");
646         emit OwnershipTransferred(_owner, newOwner);
647         _owner = newOwner;
648     }
649 }
650 
651 interface IUniswapV2Router {
652     function factory() external pure returns (address);
653     function WETH() external pure returns (address);
654 }
655 
656 contract TheCelestialDragon is ERC20, Ownable {
657     using SafeMath for uint256;
658 
659     IUniswapV2Router public immutable uniswapV2Router;
660     address public immutable uniswapV2Pair;
661     address public constant deadAddress = address(0xdead);
662 
663     uint256 public maxTransactionAmount;
664     uint256 public maxWallet;
665     
666     bool public tradingActive = false;
667     
668     mapping(address => uint256) private _holderLastTransferTimestamp;
669     bool public transferDelayEnabled = true;
670 
671     // exlcude from fees and max transaction amount
672     mapping (address => bool) public _isExcludedMaxTransactionAmount;
673     mapping (address => bool) public _isExcludedFromFees;
674     mapping (address => bool) public automatedMarketMakerPairs;
675 
676     event ExcludeFromFees(address indexed account, bool isExcluded);
677 
678     constructor() ERC20("The Celestial Dragon", "CHING") {
679         
680         IUniswapV2Router _uniswapV2Router = IUniswapV2Router(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
681         
682         excludeFromMaxTransaction(address(_uniswapV2Router), true);
683         excludeFromMaxTransaction(owner(), true);
684         excludeFromFees(owner(),true);
685         uniswapV2Router = _uniswapV2Router;
686         
687         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
688         excludeFromMaxTransaction(address(uniswapV2Pair), true);
689         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
690          
691         uint256 totalSupply = 64 * 1e6 * 1e18;
692         
693         maxTransactionAmount = totalSupply * 20 / 1000; // 2% maxTransactionAmountTxn
694         maxWallet = totalSupply * 20 / 1000; // 2% maxWallet
695 
696         _mint(msg.sender, totalSupply);
697     }
698 
699     receive() external payable {
700 
701   	}
702 
703     function enableTrading() external onlyOwner {
704         tradingActive = true;
705     }
706 
707     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
708         require(newNum >= (totalSupply() * 1 / 1000)/1e18, "Cannot set maxTransactionAmount lower than 0.1%");
709         maxTransactionAmount = newNum * (10**18);
710     }
711 
712     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
713         require(newNum >= (totalSupply() * 5 / 1000)/1e18, "Cannot set maxWallet lower than 0.5%");
714         maxWallet = newNum * (10**18);
715     }
716     
717     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
718         _isExcludedMaxTransactionAmount[updAds] = isEx;
719     }
720 
721     function excludeFromFees(address account, bool excluded) public onlyOwner {
722         _isExcludedFromFees[account] = excluded;
723         emit ExcludeFromFees(account, excluded);
724     }
725 
726     function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
727         require(pair != uniswapV2Pair, "The pair cannot be removed from automatedMarketMakerPairs");
728 
729         _setAutomatedMarketMakerPair(pair, value);
730     }
731 
732     function _setAutomatedMarketMakerPair(address pair, bool value) private {
733         automatedMarketMakerPairs[pair] = value;
734     }
735 
736     function _transfer(
737         address from,
738         address to,
739         uint256 amount
740     ) internal override {
741         require(from != address(0), "ERC20: transfer from the zero address");
742         require(to != address(0), "ERC20: transfer to the zero address");
743         
744          if(amount == 0) {
745             super._transfer(from, to, 0);
746             return;
747         }
748         
749         if (
750             from != owner() &&
751             to != owner() &&
752             to != address(0) &&
753             to != address(0xdead)
754         ){
755             if(!tradingActive){
756                     require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");
757             }
758 
759             if (to != owner() && to != address(uniswapV2Router) && to != address(uniswapV2Pair)){
760                 require(_holderLastTransferTimestamp[tx.origin] < block.number, "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed.");
761                 _holderLastTransferTimestamp[tx.origin] = block.number;
762             }
763                  
764             //when buy
765             if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
766                     require(amount <= maxTransactionAmount, "Buy transfer amount exceeds the maxTransactionAmount.");
767                     require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
768             }
769                 
770             //when sell
771             else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
772                     require(amount <= maxTransactionAmount, "Sell transfer amount exceeds the maxTransactionAmount.");
773             }
774             else if(!_isExcludedMaxTransactionAmount[to]){
775                 require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
776             }
777         }
778     super._transfer(from, to, amount);
779     }
780 }