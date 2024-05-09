1 //      ..:^^^^^^^^^^^::..              .:^~:.              ...::::^^^^^^^:::.    
2 //   .!::^7^  :7^^^:.:^J?7!77!^..     ^Y7^^.!7!.    ..:^^~~77^^~:::~^^::Y~.!?J?.  
3 //   7~:^:^::..^::..^^^~:~~!7!77J??~^..J~^^.~:..:^!!!!~^:^^..:^^~?^::  ^?!!!?!^   
4 //     ::~::::::!. .^^:::^~^^^^^~~~::7!!^^..:^^~~^^~~~!~^~~^!~^~::^ .:!?~!7:.     
5 //        .:^^:::..!!..:^^:^:....   .^~..!:.!^ ..::^.:~^^^~!^^~:..:^^~^:^.        
6 //           .^:.^^ ..:::.^.         ^~:...:...          ^!^:^^^::^:^..           
7 //                  :::..^^.         :^ .. ..            .^...:^^.                
8 //                 .::::^:           .: ... ..           :  .:^^:                 
9 //                  .:::::.::.        :  .. :  ..       :::.:::                   
10 //                      ...           .: .       .    ......                      
11 //                                     ..                                         
12 //                                      :.                                        
13 //                                       ..                                
14 //
15 //               -.-. .. -.-. .- -.. .- ...-- ...-- ----- .----
16 //
17 // .-- . -... https://cicada3301.xyz
18 // - --. https://t.me/C636963616461
19 // -..- https://x.com/CicadaERC
20 
21 //SPDX-License-Identifier: 3301
22 
23 pragma solidity 0.8.17;
24  
25 abstract contract Context {
26     function _msgSender() internal view virtual returns (address) {
27         return msg.sender;
28     }
29  
30     function _msgData() internal view virtual returns (bytes calldata) {
31         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
32         return msg.data;
33     }
34 }
35  
36 interface IUniswapV2Pair {
37     event Approval(address indexed owner, address indexed spender, uint value);
38     event Transfer(address indexed from, address indexed to, uint value);
39  
40     function name() external pure returns (string memory);
41     function symbol() external pure returns (string memory);
42     function decimals() external pure returns (uint8);
43     function totalSupply() external view returns (uint);
44     function balanceOf(address owner) external view returns (uint);
45     function allowance(address owner, address spender) external view returns (uint);
46  
47     function approve(address spender, uint value) external returns (bool);
48     function transfer(address to, uint value) external returns (bool);
49     function transferFrom(address from, address to, uint value) external returns (bool);
50  
51     function DOMAIN_SEPARATOR() external view returns (bytes32);
52     function PERMIT_TYPEHASH() external pure returns (bytes32);
53     function nonces(address owner) external view returns (uint);
54  
55     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
56  
57     event Mint(address indexed sender, uint amount0, uint amount1);
58     event Swap(
59         address indexed sender,
60         uint amount0In,
61         uint amount1In,
62         uint amount0Out,
63         uint amount1Out,
64         address indexed to
65     );
66     event Sync(uint112 reserve0, uint112 reserve1);
67  
68     function MINIMUM_LIQUIDITY() external pure returns (uint);
69     function factory() external view returns (address);
70     function token0() external view returns (address);
71     function token1() external view returns (address);
72     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
73     function price0CumulativeLast() external view returns (uint);
74     function price1CumulativeLast() external view returns (uint);
75     function kLast() external view returns (uint);
76  
77     function mint(address to) external returns (uint liquidity);
78     function burn(address to) external returns (uint amount0, uint amount1);
79     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
80     function skim(address to) external;
81     function sync() external;
82  
83     function initialize(address, address) external;
84 }
85  
86 interface IUniswapV2Factory {
87     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
88  
89     function feeTo() external view returns (address);
90     function feeToSetter() external view returns (address);
91  
92     function getPair(address tokenA, address tokenB) external view returns (address pair);
93     function allPairs(uint) external view returns (address pair);
94     function allPairsLength() external view returns (uint);
95  
96     function createPair(address tokenA, address tokenB) external returns (address pair);
97  
98     function setFeeTo(address) external;
99     function setFeeToSetter(address) external;
100 }
101  
102 interface IERC20 {
103     /**
104      * @dev Returns the amount of tokens in existence.
105      */
106     function totalSupply() external view returns (uint256);
107  
108     /**
109      * @dev Returns the amount of tokens owned by `account`.
110      */
111     function balanceOf(address account) external view returns (uint256);
112  
113     /**
114      * @dev Moves `amount` tokens from the caller's account to `recipient`.
115      *
116      * Returns a boolean value indicating whether the operation succeeded.
117      *
118      * Emits a {Transfer} event.
119      */
120     function transfer(address recipient, uint256 amount) external returns (bool);
121  
122     /**
123      * @dev Returns the remaining number of tokens that `spender` will be
124      * allowed to spend on behalf of `owner` through {transferFrom}. This is
125      * zero by default.
126      *
127      * This value changes when {approve} or {transferFrom} are called.
128      */
129     function allowance(address owner, address spender) external view returns (uint256);
130  
131     /**
132      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
133      *
134      * Returns a boolean value indicating whether the operation succeeded.
135      *
136      * IMPORTANT: Beware that changing an allowance with this method brings the risk
137      * that someone may use both the old and the new allowance by unfortunate
138      * transaction ordering. One possible solution to mitigate this race
139      * condition is to first reduce the spender's allowance to 0 and set the
140      * desired value afterwards:
141      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
142      *
143      * Emits an {Approval} event.
144      */
145     function approve(address spender, uint256 amount) external returns (bool);
146  
147     /**
148      * @dev Moves `amount` tokens from `sender` to `recipient` using the
149      * allowance mechanism. `amount` is then deducted from the caller's
150      * allowance.
151      *
152      * Returns a boolean value indicating whether the operation succeeded.
153      *
154      * Emits a {Transfer} event.
155      */
156     function transferFrom(
157         address sender,
158         address recipient,
159         uint256 amount
160     ) external returns (bool);
161  
162     /**
163      * @dev Emitted when `value` tokens are moved from one account (`from`) to
164      * another (`to`).
165      *
166      * Note that `value` may be zero.
167      */
168     event Transfer(address indexed from, address indexed to, uint256 value);
169  
170     /**
171      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
172      * a call to {approve}. `value` is the new allowance.
173      */
174     event Approval(address indexed owner, address indexed spender, uint256 value);
175 }
176  
177 interface IERC20Metadata is IERC20 {
178     /**
179      * @dev Returns the name of the token.
180      */
181     function name() external view returns (string memory);
182  
183     /**
184      * @dev Returns the symbol of the token.
185      */
186     function symbol() external view returns (string memory);
187  
188     /**
189      * @dev Returns the decimals places of the token.
190      */
191     function decimals() external view returns (uint8);
192 }
193  
194  
195 contract ERC20 is Context, IERC20, IERC20Metadata {
196     using SafeMath for uint256;
197  
198     mapping(address => uint256) private _balances;
199  
200     mapping(address => mapping(address => uint256)) private _allowances;
201  
202     uint256 private _totalSupply;
203  
204     string private _name;
205     string private _symbol;
206  
207     /**
208      * @dev Sets the values for {name} and {symbol}.
209      *
210      * The default value of {decimals} is 18. To select a different value for
211      * {decimals} you should overload it.
212      *
213      * All two of these values are immutable: they can only be set once during
214      * construction.
215      */
216     constructor(string memory name_, string memory symbol_) {
217         _name = name_;
218         _symbol = symbol_;
219     }
220  
221     /**
222      * @dev Returns the name of the token.
223      */
224     function name() public view virtual override returns (string memory) {
225         return _name;
226     }
227  
228     /**
229      * @dev Returns the symbol of the token, usually a shorter version of the
230      * name.
231      */
232     function symbol() public view virtual override returns (string memory) {
233         return _symbol;
234     }
235  
236     /**
237      * @dev Returns the number of decimals used to get its user representation.
238      * For example, if `decimals` equals `2`, a balance of `505` tokens should
239      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
240      *
241      * Tokens usually opt for a value of 18, imitating the relationship between
242      * Ether and Wei. This is the value {ERC20} uses, unless this function is
243      * overridden;
244      *
245      * NOTE: This information is only used for _display_ purposes: it in
246      * no way affects any of the arithmetic of the contract, including
247      * {IERC20-balanceOf} and {IERC20-transfer}.
248      */
249     function decimals() public view virtual override returns (uint8) {
250         return 18;
251     }
252  
253     /**
254      * @dev See {IERC20-totalSupply}.
255      */
256     function totalSupply() public view virtual override returns (uint256) {
257         return _totalSupply;
258     }
259  
260     /**
261      * @dev See {IERC20-balanceOf}.
262      */
263     function balanceOf(address account) public view virtual override returns (uint256) {
264         return _balances[account];
265     }
266  
267     /**
268      * @dev See {IERC20-transfer}.
269      *
270      * Requirements:
271      *
272      * - `recipient` cannot be the zero address.
273      * - the caller must have a balance of at least `amount`.
274      */
275     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
276         _transfer(_msgSender(), recipient, amount);
277         return true;
278     }
279  
280     /**
281      * @dev See {IERC20-allowance}.
282      */
283     function allowance(address owner, address spender) public view virtual override returns (uint256) {
284         return _allowances[owner][spender];
285     }
286  
287     /**
288      * @dev See {IERC20-approve}.
289      *
290      * Requirements:
291      *
292      * - `spender` cannot be the zero address.
293      */
294     function approve(address spender, uint256 amount) public virtual override returns (bool) {
295         _approve(_msgSender(), spender, amount);
296         return true;
297     }
298  
299     /**
300      * @dev See {IERC20-transferFrom}.
301      *
302      * Emits an {Approval} event indicating the updated allowance. This is not
303      * required by the EIP. See the note at the beginning of {ERC20}.
304      *
305      * Requirements:
306      *
307      * - `sender` and `recipient` cannot be the zero address.
308      * - `sender` must have a balance of at least `amount`.
309      * - the caller must have allowance for ``sender``'s tokens of at least
310      * `amount`.
311      */
312     function transferFrom(
313         address sender,
314         address recipient,
315         uint256 amount
316     ) public virtual override returns (bool) {
317         _transfer(sender, recipient, amount);
318         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
319         return true;
320     }
321  
322     /**
323      * @dev Atomically increases the allowance granted to `spender` by the caller.
324      *
325      * This is an alternative to {approve} that can be used as a mitigation for
326      * problems described in {IERC20-approve}.
327      *
328      * Emits an {Approval} event indicating the updated allowance.
329      *
330      * Requirements:
331      *
332      * - `spender` cannot be the zero address.
333      */
334     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
335         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
336         return true;
337     }
338  
339     /**
340      * @dev Atomically decreases the allowance granted to `spender` by the caller.
341      *
342      * This is an alternative to {approve} that can be used as a mitigation for
343      * problems described in {IERC20-approve}.
344      *
345      * Emits an {Approval} event indicating the updated allowance.
346      *
347      * Requirements:
348      *
349      * - `spender` cannot be the zero address.
350      * - `spender` must have allowance for the caller of at least
351      * `subtractedValue`.
352      */
353     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
354         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
355         return true;
356     }
357  
358     /**
359      * @dev Moves tokens `amount` from `sender` to `recipient`.
360      *
361      * This is internal function is equivalent to {transfer}, and can be used to
362      * e.g. implement automatic token fees, slashing mechanisms, etc.
363      *
364      * Emits a {Transfer} event.
365      *
366      * Requirements:
367      *
368      * - `sender` cannot be the zero address.
369      * - `recipient` cannot be the zero address.
370      * - `sender` must have a balance of at least `amount`.
371      */
372     function _transfer(
373         address sender,
374         address recipient,
375         uint256 amount
376     ) internal virtual {
377         require(sender != address(0), "ERC20: transfer from the zero address");
378         require(recipient != address(0), "ERC20: transfer to the zero address");
379  
380         _beforeTokenTransfer(sender, recipient, amount);
381  
382         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
383         _balances[recipient] = _balances[recipient].add(amount);
384         emit Transfer(sender, recipient, amount);
385     }
386  
387     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
388      * the total supply.
389      *
390      * Emits a {Transfer} event with `from` set to the zero address.
391      *
392      * Requirements:
393      *
394      * - `account` cannot be the zero address.
395      */
396     function _mint(address account, uint256 amount) internal virtual {
397         require(account != address(0), "ERC20: mint to the zero address");
398  
399         _beforeTokenTransfer(address(0), account, amount);
400  
401         _totalSupply = _totalSupply.add(amount);
402         _balances[account] = _balances[account].add(amount);
403         emit Transfer(address(0), account, amount);
404     }
405  
406     /**
407      * @dev Destroys `amount` tokens from `account`, reducing the
408      * total supply.
409      *
410      * Emits a {Transfer} event with `to` set to the zero address.
411      *
412      * Requirements:
413      *
414      * - `account` cannot be the zero address.
415      * - `account` must have at least `amount` tokens.
416      */
417     function _burn(address account, uint256 amount) internal virtual {
418         require(account != address(0), "ERC20: burn from the zero address");
419  
420         _beforeTokenTransfer(account, address(0), amount);
421  
422         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
423         _totalSupply = _totalSupply.sub(amount);
424         emit Transfer(account, address(0), amount);
425     }
426  
427     /**
428      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
429      *
430      * This internal function is equivalent to `approve`, and can be used to
431      * e.g. set automatic allowances for certain subsystems, etc.
432      *
433      * Emits an {Approval} event.
434      *
435      * Requirements:
436      *
437      * - `owner` cannot be the zero address.
438      * - `spender` cannot be the zero address.
439      */
440     function _approve(
441         address owner,
442         address spender,
443         uint256 amount
444     ) internal virtual {
445         require(owner != address(0), "ERC20: approve from the zero address");
446         require(spender != address(0), "ERC20: approve to the zero address");
447  
448         _allowances[owner][spender] = amount;
449         emit Approval(owner, spender, amount);
450     }
451  
452     /**
453      * @dev Hook that is called before any transfer of tokens. This includes
454      * minting and burning.
455      *
456      * Calling conditions:
457      *
458      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
459      * will be to transferred to `to`.
460      * - when `from` is zero, `amount` tokens will be minted for `to`.
461      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
462      * - `from` and `to` are never both zero.
463      *
464      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
465      */
466     function _beforeTokenTransfer(
467         address from,
468         address to,
469         uint256 amount
470     ) internal virtual {}
471 }
472  
473 library SafeMath {
474     /**
475      * @dev Returns the addition of two unsigned integers, reverting on
476      * overflow.
477      *
478      * Counterpart to Solidity's `+` operator.
479      *
480      * Requirements:
481      *
482      * - Addition cannot overflow.
483      */
484     function add(uint256 a, uint256 b) internal pure returns (uint256) {
485         uint256 c = a + b;
486         require(c >= a, "SafeMath: addition overflow");
487  
488         return c;
489     }
490  
491     /**
492      * @dev Returns the subtraction of two unsigned integers, reverting on
493      * overflow (when the result is negative).
494      *
495      * Counterpart to Solidity's `-` operator.
496      *
497      * Requirements:
498      *
499      * - Subtraction cannot overflow.
500      */
501     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
502         return sub(a, b, "SafeMath: subtraction overflow");
503     }
504  
505     /**
506      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
507      * overflow (when the result is negative).
508      *
509      * Counterpart to Solidity's `-` operator.
510      *
511      * Requirements:
512      *
513      * - Subtraction cannot overflow.
514      */
515     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
516         require(b <= a, errorMessage);
517         uint256 c = a - b;
518  
519         return c;
520     }
521  
522     /**
523      * @dev Returns the multiplication of two unsigned integers, reverting on
524      * overflow.
525      *
526      * Counterpart to Solidity's `*` operator.
527      *
528      * Requirements:
529      *
530      * - Multiplication cannot overflow.
531      */
532     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
533         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
534         // benefit is lost if 'b' is also tested.
535         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
536         if (a == 0) {
537             return 0;
538         }
539  
540         uint256 c = a * b;
541         require(c / a == b, "SafeMath: multiplication overflow");
542  
543         return c;
544     }
545  
546     /**
547      * @dev Returns the integer division of two unsigned integers. Reverts on
548      * division by zero. The result is rounded towards zero.
549      *
550      * Counterpart to Solidity's `/` operator. Note: this function uses a
551      * `revert` opcode (which leaves remaining gas untouched) while Solidity
552      * uses an invalid opcode to revert (consuming all remaining gas).
553      *
554      * Requirements:
555      *
556      * - The divisor cannot be zero.
557      */
558     function div(uint256 a, uint256 b) internal pure returns (uint256) {
559         return div(a, b, "SafeMath: division by zero");
560     }
561  
562     /**
563      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
564      * division by zero. The result is rounded towards zero.
565      *
566      * Counterpart to Solidity's `/` operator. Note: this function uses a
567      * `revert` opcode (which leaves remaining gas untouched) while Solidity
568      * uses an invalid opcode to revert (consuming all remaining gas).
569      *
570      * Requirements:
571      *
572      * - The divisor cannot be zero.
573      */
574     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
575         require(b > 0, errorMessage);
576         uint256 c = a / b;
577         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
578  
579         return c;
580     }
581  
582     /**
583      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
584      * Reverts when dividing by zero.
585      *
586      * Counterpart to Solidity's `%` operator. This function uses a `revert`
587      * opcode (which leaves remaining gas untouched) while Solidity uses an
588      * invalid opcode to revert (consuming all remaining gas).
589      *
590      * Requirements:
591      *
592      * - The divisor cannot be zero.
593      */
594     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
595         return mod(a, b, "SafeMath: modulo by zero");
596     }
597  
598     /**
599      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
600      * Reverts with custom message when dividing by zero.
601      *
602      * Counterpart to Solidity's `%` operator. This function uses a `revert`
603      * opcode (which leaves remaining gas untouched) while Solidity uses an
604      * invalid opcode to revert (consuming all remaining gas).
605      *
606      * Requirements:
607      *
608      * - The divisor cannot be zero.
609      */
610     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
611         require(b != 0, errorMessage);
612         return a % b;
613     }
614 }
615  
616 contract Ownable is Context {
617     address private _owner;
618  
619     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
620  
621     /**
622      * @dev Initializes the contract setting the deployer as the initial owner.
623      */
624     constructor () {
625         address msgSender = _msgSender();
626         _owner = msgSender;
627         emit OwnershipTransferred(address(0), msgSender);
628     }
629  
630     /**
631      * @dev Returns the address of the current owner.
632      */
633     function owner() public view returns (address) {
634         return _owner;
635     }
636  
637     /**
638      * @dev Throws if called by any account other than the owner.
639      */
640     modifier onlyOwner() {
641         require(_owner == _msgSender(), "Ownable: caller is not the owner");
642         _;
643     }
644  
645     /**
646      * @dev Leaves the contract without owner. It will not be possible to call
647      * `onlyOwner` functions anymore. Can only be called by the current owner.
648      *
649      * NOTE: Renouncing ownership will leave the contract without an owner,
650      * thereby removing any functionality that is only available to the owner.
651      */
652     function renounceOwnership() public virtual onlyOwner {
653         emit OwnershipTransferred(_owner, address(0));
654         _owner = address(0);
655     }
656  
657     /**
658      * @dev Transfers ownership of the contract to a new account (`newOwner`).
659      * Can only be called by the current owner.
660      */
661     function transferOwnership(address newOwner) public virtual onlyOwner {
662         require(newOwner != address(0), "Ownable: new owner is the zero address");
663         emit OwnershipTransferred(_owner, newOwner);
664         _owner = newOwner;
665     }
666 }
667  
668  
669  
670 library SafeMathInt {
671     int256 private constant MIN_INT256 = int256(1) << 255;
672     int256 private constant MAX_INT256 = ~(int256(1) << 255);
673  
674     /**
675      * @dev Multiplies two int256 variables and fails on overflow.
676      */
677     function mul(int256 a, int256 b) internal pure returns (int256) {
678         int256 c = a * b;
679  
680         // Detect overflow when multiplying MIN_INT256 with -1
681         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
682         require((b == 0) || (c / b == a));
683         return c;
684     }
685  
686     /**
687      * @dev Division of two int256 variables and fails on overflow.
688      */
689     function div(int256 a, int256 b) internal pure returns (int256) {
690         // Prevent overflow when dividing MIN_INT256 by -1
691         require(b != -1 || a != MIN_INT256);
692  
693         // Solidity already throws when dividing by 0.
694         return a / b;
695     }
696  
697     /**
698      * @dev Subtracts two int256 variables and fails on overflow.
699      */
700     function sub(int256 a, int256 b) internal pure returns (int256) {
701         int256 c = a - b;
702         require((b >= 0 && c <= a) || (b < 0 && c > a));
703         return c;
704     }
705  
706     /**
707      * @dev Adds two int256 variables and fails on overflow.
708      */
709     function add(int256 a, int256 b) internal pure returns (int256) {
710         int256 c = a + b;
711         require((b >= 0 && c >= a) || (b < 0 && c < a));
712         return c;
713     }
714  
715     /**
716      * @dev Converts to absolute value, and fails on overflow.
717      */
718     function abs(int256 a) internal pure returns (int256) {
719         require(a != MIN_INT256);
720         return a < 0 ? -a : a;
721     }
722  
723  
724     function toUint256Safe(int256 a) internal pure returns (uint256) {
725         require(a >= 0);
726         return uint256(a);
727     }
728 }
729  
730 library SafeMathUint {
731   function toInt256Safe(uint256 a) internal pure returns (int256) {
732     int256 b = int256(a);
733     require(b >= 0);
734     return b;
735   }
736 }
737  
738  
739 interface IUniswapV2Router01 {
740     function factory() external pure returns (address);
741     function WETH() external pure returns (address);
742  
743     function addLiquidity(
744         address tokenA,
745         address tokenB,
746         uint amountADesired,
747         uint amountBDesired,
748         uint amountAMin,
749         uint amountBMin,
750         address to,
751         uint deadline
752     ) external returns (uint amountA, uint amountB, uint liquidity);
753     function addLiquidityETH(
754         address token,
755         uint amountTokenDesired,
756         uint amountTokenMin,
757         uint amountETHMin,
758         address to,
759         uint deadline
760     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
761     function removeLiquidity(
762         address tokenA,
763         address tokenB,
764         uint liquidity,
765         uint amountAMin,
766         uint amountBMin,
767         address to,
768         uint deadline
769     ) external returns (uint amountA, uint amountB);
770     function removeLiquidityETH(
771         address token,
772         uint liquidity,
773         uint amountTokenMin,
774         uint amountETHMin,
775         address to,
776         uint deadline
777     ) external returns (uint amountToken, uint amountETH);
778     function removeLiquidityWithPermit(
779         address tokenA,
780         address tokenB,
781         uint liquidity,
782         uint amountAMin,
783         uint amountBMin,
784         address to,
785         uint deadline,
786         bool approveMax, uint8 v, bytes32 r, bytes32 s
787     ) external returns (uint amountA, uint amountB);
788     function removeLiquidityETHWithPermit(
789         address token,
790         uint liquidity,
791         uint amountTokenMin,
792         uint amountETHMin,
793         address to,
794         uint deadline,
795         bool approveMax, uint8 v, bytes32 r, bytes32 s
796     ) external returns (uint amountToken, uint amountETH);
797     function swapExactTokensForTokens(
798         uint amountIn,
799         uint amountOutMin,
800         address[] calldata path,
801         address to,
802         uint deadline
803     ) external returns (uint[] memory amounts);
804     function swapTokensForExactTokens(
805         uint amountOut,
806         uint amountInMax,
807         address[] calldata path,
808         address to,
809         uint deadline
810     ) external returns (uint[] memory amounts);
811     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
812         external
813         payable
814         returns (uint[] memory amounts);
815     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
816         external
817         returns (uint[] memory amounts);
818     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
819         external
820         returns (uint[] memory amounts);
821     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
822         external
823         payable
824         returns (uint[] memory amounts);
825  
826     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
827     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
828     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
829     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
830     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
831 }
832  
833 interface IUniswapV2Router02 is IUniswapV2Router01 {
834     function removeLiquidityETHSupportingFeeOnTransferTokens(
835         address token,
836         uint liquidity,
837         uint amountTokenMin,
838         uint amountETHMin,
839         address to,
840         uint deadline
841     ) external returns (uint amountETH);
842     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
843         address token,
844         uint liquidity,
845         uint amountTokenMin,
846         uint amountETHMin,
847         address to,
848         uint deadline,
849         bool approveMax, uint8 v, bytes32 r, bytes32 s
850     ) external returns (uint amountETH);
851  
852     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
853         uint amountIn,
854         uint amountOutMin,
855         address[] calldata path,
856         address to,
857         uint deadline
858     ) external;
859     function swapExactETHForTokensSupportingFeeOnTransferTokens(
860         uint amountOutMin,
861         address[] calldata path,
862         address to,
863         uint deadline
864     ) external payable;
865     function swapExactTokensForETHSupportingFeeOnTransferTokens(
866         uint amountIn,
867         uint amountOutMin,
868         address[] calldata path,
869         address to,
870         uint deadline
871     ) external;
872 }
873  
874 contract Cicada is ERC20, Ownable {
875     using SafeMath for uint256;
876  
877     IUniswapV2Router02 public immutable uniswapV2Router;
878     address public immutable uniswapV2Pair;
879  
880     bool private swapping;
881  
882     address private marketingWallet;
883     address private devWallet;
884  
885     uint256 public maxTransactionAmount;
886     uint256 public swapTokensAtAmount;
887     uint256 public maxWallet;
888  
889     bool public limitsInEffect = true;
890     bool public tradingActive = false;
891     bool public swapEnabled = true;
892  
893     
894     uint256 public buyTotalFees;
895     uint256 public buyMarketingFee;
896     uint256 public buyLiquidityFee;
897     uint256 public buyDevFee;
898  
899     uint256 public sellTotalFees;
900     uint256 public sellMarketingFee;
901     uint256 public sellLiquidityFee;
902     uint256 public sellDevFee;
903  
904     uint256 public tokensForMarketing;
905     uint256 public tokensForLiquidity;
906     uint256 public tokensForDev;
907  
908     // block number of opened trading
909     uint256 launchedAt;
910  
911     /******************/
912  
913     // exclude from fees and max transaction amount
914     mapping (address => bool) private _isExcludedFromFees;
915     mapping (address => bool) public _isExcludedMaxTransactionAmount;
916  
917     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
918     // could be subject to a maximum transfer amount
919     mapping (address => bool) public partners;
920  
921     event UpdateUniswapV2Router(address indexed newAddress, address indexed oldAddress);
922  
923     event ExcludeFromFees(address indexed account, bool isExcluded);
924  
925     event Setpartner(address indexed pair, bool indexed value);
926  
927     event marketingWalletUpdated(address indexed newWallet, address indexed oldWallet);
928  
929     event devWalletUpdated(address indexed newWallet, address indexed oldWallet);
930  
931     event SwapAndLiquify(
932         uint256 tokensSwapped,
933         uint256 ethReceived,
934         uint256 tokensIntoLiquidity
935     );
936  
937     event AutoNukeLP();
938  
939     event ManualNukeLP();
940  
941     constructor() ERC20("CICADA","CICADA") {
942                                      
943         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
944  
945         excludeFromMaxTransaction(address(_uniswapV2Router), true);
946         uniswapV2Router = _uniswapV2Router;
947  
948         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
949         excludeFromMaxTransaction(address(uniswapV2Pair), true);
950         _setpartner(address(uniswapV2Pair), true);
951  
952         uint256 _buyMarketingFee = 1;
953         uint256 _buyLiquidityFee = 0;
954         uint256 _buyDevFee = 0;
955  
956         uint256 _sellMarketingFee = 1;
957         uint256 _sellLiquidityFee = 0;
958         uint256 _sellDevFee = 0;
959  
960         uint256 totalSupply = 1 * 1e9 * 1e18;
961  
962         maxTransactionAmount = totalSupply * 10 / 1000; // 1%
963         maxWallet = totalSupply * 10 / 1000; // 1% 
964         swapTokensAtAmount = totalSupply * 5 / 10000; // 0.1%
965  
966         buyMarketingFee = _buyMarketingFee;
967         buyLiquidityFee = _buyLiquidityFee;
968         buyDevFee = _buyDevFee;
969         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
970  
971         sellMarketingFee = _sellMarketingFee;
972         sellLiquidityFee = _sellLiquidityFee;
973         sellDevFee = _sellDevFee;
974         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
975  
976         marketingWallet = 0x524E064767047239fd7C773fC963c6c80d4E6e7d; // set as marketing wallet
977         devWallet = 0x1Ab5ddF9F0a28612Ab48EEA6EFC13dBdB1BFd8Be; // set as dev wallet
978  
979         // exclude from paying fees or having max transaction amount
980         excludeFromFees(owner(), true);
981         excludeFromFees(address(this), true);
982         excludeFromFees(address(0xdead), true);
983  
984         excludeFromMaxTransaction(owner(), true);
985         excludeFromMaxTransaction(address(this), true);
986         excludeFromMaxTransaction(address(0xdead), true);
987  
988         /*
989             _mint is an internal function in ERC20.sol that is only called here,
990             and CANNOT be called ever again
991         */
992         _mint(msg.sender, totalSupply);
993     }
994  
995     receive() external payable {
996  
997     }
998  
999     // once enabled, can never be turned off
1000     function enableTrading() external onlyOwner {
1001         tradingActive = true;
1002         swapEnabled = true;
1003         launchedAt = block.number;
1004     }
1005  
1006     // remove limits after token is stable
1007     function removeLimits() external onlyOwner returns (bool){
1008         limitsInEffect = false;
1009         return true;
1010     }
1011  
1012      
1013      // change the minimum amount of tokens to sell from fees
1014     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner returns (bool){
1015         require(newAmount >= totalSupply() * 1 / 100000, "Swap amount cannot be lower than 0.001% total supply.");
1016         require(newAmount <= totalSupply() * 5 / 1000, "Swap amount cannot be higher than 0.5% total supply.");
1017         swapTokensAtAmount = newAmount;
1018         return true;
1019     }
1020  
1021     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
1022         require(newNum >= (totalSupply() * 1 / 1000)/1e18, "Cannot set maxTransactionAmount lower than 0.1%");
1023         maxTransactionAmount = newNum * (10**18);
1024     }
1025  
1026     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
1027         require(newNum >= (totalSupply() * 5 / 1000)/1e18, "Cannot set maxWallet lower than 0.5%");
1028         maxWallet = newNum * (10**18);
1029     }
1030  
1031     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
1032         _isExcludedMaxTransactionAmount[updAds] = isEx;
1033     }
1034 
1035           function updateBuyFees(
1036         uint256 _devFee,
1037         uint256 _liquidityFee,
1038         uint256 _marketingFee
1039     ) external onlyOwner {
1040         buyDevFee = _devFee;
1041         buyLiquidityFee = _liquidityFee;
1042         buyMarketingFee = _marketingFee;
1043         buyTotalFees = buyDevFee + buyLiquidityFee + buyMarketingFee;
1044         require(buyTotalFees <= 10, "Must keep fees at 10% or less");
1045     }
1046 
1047     function updateSellFees(
1048         uint256 _devFee,
1049         uint256 _liquidityFee,
1050         uint256 _marketingFee
1051     ) external onlyOwner {
1052         sellDevFee = _devFee;
1053         sellLiquidityFee = _liquidityFee;
1054         sellMarketingFee = _marketingFee;
1055         sellTotalFees = sellDevFee + sellLiquidityFee + sellMarketingFee;
1056         require(sellTotalFees <= 90, "Must keep fees at 90% or less");
1057     }
1058  
1059     // only use to disable contract sales if absolutely necessary (emergency use only)
1060     function updateSwapEnabled(bool enabled) external onlyOwner(){
1061         swapEnabled = enabled;
1062     }
1063  
1064     function excludeFromFees(address account, bool excluded) public onlyOwner {
1065         _isExcludedFromFees[account] = excluded;
1066         emit ExcludeFromFees(account, excluded);
1067     }
1068  
1069  
1070     function setpartner(address pair, bool value) public onlyOwner {
1071         require(pair != uniswapV2Pair, "The pair cannot be removed from partners");
1072  
1073         _setpartner(pair, value);
1074     }
1075  
1076     function _setpartner(address pair, bool value) private {
1077         partners[pair] = value;
1078  
1079         emit Setpartner(pair, value);
1080     }
1081  
1082     function updateMarketingWallet(address newMarketingWallet) external onlyOwner {
1083         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
1084         marketingWallet = newMarketingWallet;
1085     }
1086  
1087     function updateDevWallet(address newWallet) external onlyOwner {
1088         emit devWalletUpdated(newWallet, devWallet);
1089         devWallet = newWallet;
1090     }
1091   
1092     function isExcludedFromFees(address account) public view returns(bool) {
1093         return _isExcludedFromFees[account];
1094     }
1095  
1096     function _transfer(
1097         address from,
1098         address to,
1099         uint256 amount
1100     ) internal override {
1101         require(from != address(0), "ERC20: transfer from the zero address");
1102         require(to != address(0), "ERC20: transfer to the zero address");
1103             if(amount == 0) {
1104             super._transfer(from, to, 0);
1105             return;
1106         }
1107  
1108         if(limitsInEffect){
1109             if (
1110                 from != owner() &&
1111                 to != owner() &&
1112                 to != address(0) &&
1113                 to != address(0xdead) &&
1114                 !swapping
1115             ){
1116                 if(!tradingActive){
1117                     require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");
1118                 }
1119  
1120                 //when buy
1121                 if (partners[from] && !_isExcludedMaxTransactionAmount[to]) {
1122                         require(amount <= maxTransactionAmount, "Buy transfer amount exceeds the maxTransactionAmount.");
1123                         require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
1124                 }
1125  
1126                 else if (partners[to] && !_isExcludedMaxTransactionAmount[from]) {
1127                         require(amount <= maxTransactionAmount, "Sell transfer amount exceeds the maxTransactionAmount.");
1128                 }
1129                 else if(!_isExcludedMaxTransactionAmount[to]){
1130                     require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
1131                 }
1132             }
1133         }
1134  
1135         uint256 contractTokenBalance = balanceOf(address(this));
1136  
1137         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1138  
1139         if( 
1140             canSwap &&
1141             swapEnabled &&
1142             !swapping &&
1143             !partners[from] &&
1144             !_isExcludedFromFees[from] &&
1145             !_isExcludedFromFees[to]
1146         ) {
1147             swapping = true;
1148  
1149             swapBack();
1150  
1151             swapping = false;
1152         }
1153  
1154         bool takeFee = !swapping;
1155  
1156         // if any account belongs to _isExcludedFromFee account then remove the fee
1157         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1158             takeFee = false;
1159         }
1160  
1161         uint256 fees = 0;
1162         // only take fees on buys/sells, do not take on wallet transfers
1163         if(takeFee){
1164             // on sell
1165             if (partners[to] && sellTotalFees > 0){
1166                 fees = amount.mul(sellTotalFees).div(100);
1167                 tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
1168                 tokensForDev += fees * sellDevFee / sellTotalFees;
1169                 tokensForMarketing += fees * sellMarketingFee / sellTotalFees;
1170             }
1171             // on buy
1172             else if(partners[from] && buyTotalFees > 0) {
1173                 fees = amount.mul(buyTotalFees).div(100);
1174                 tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
1175                 tokensForDev += fees * buyDevFee / buyTotalFees;
1176                 tokensForMarketing += fees * buyMarketingFee / buyTotalFees;
1177             }
1178  
1179             if(fees > 0){    
1180                 super._transfer(from, address(this), fees);
1181             }
1182  
1183             amount -= fees;
1184         }
1185  
1186         super._transfer(from, to, amount);
1187     }
1188  
1189     function swapTokensForEth(uint256 tokenAmount) private {
1190  
1191         // generate the uniswap pair path of token -> weth
1192         address[] memory path = new address[](2);
1193         path[0] = address(this);
1194         path[1] = uniswapV2Router.WETH();
1195  
1196         _approve(address(this), address(uniswapV2Router), tokenAmount);
1197  
1198         // make the swap
1199         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1200             tokenAmount,
1201             0, // accept any amount of ETH
1202             path,
1203             address(this),
1204             block.timestamp
1205         );
1206  
1207     }
1208  
1209     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1210         // approve token transfer to cover all possible scenarios
1211         _approve(address(this), address(uniswapV2Router), tokenAmount);
1212  
1213         // add the liquidity
1214         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1215             address(this),
1216             tokenAmount,
1217             0, // slippage is unavoidable
1218             0, // slippage is unavoidable
1219             address(this),
1220             block.timestamp
1221         );
1222     }
1223  
1224     function swapBack() private {
1225         uint256 contractBalance = balanceOf(address(this));
1226         uint256 totalTokensToSwap = tokensForLiquidity + tokensForMarketing + tokensForDev;
1227         bool success;
1228  
1229         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
1230  
1231         if(contractBalance > swapTokensAtAmount * 20){
1232           contractBalance = swapTokensAtAmount * 20;
1233         }
1234  
1235         // Halve the amount of liquidity tokens
1236         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
1237         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1238  
1239         uint256 initialETHBalance = address(this).balance;
1240  
1241         swapTokensForEth(amountToSwapForETH); 
1242  
1243         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1244  
1245         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(totalTokensToSwap);
1246         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
1247         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev;
1248  
1249  
1250         tokensForLiquidity = 0;
1251         tokensForMarketing = 0;
1252         tokensForDev = 0;
1253  
1254         (success,) = address(devWallet).call{value: ethForDev}("");
1255  
1256         if(liquidityTokens > 0 && ethForLiquidity > 0){
1257             addLiquidity(liquidityTokens, ethForLiquidity);
1258             emit SwapAndLiquify(amountToSwapForETH, ethForLiquidity, tokensForLiquidity);
1259         }
1260  
1261         (success,) = address(marketingWallet).call{value: address(this).balance}("");
1262     }
1263 }