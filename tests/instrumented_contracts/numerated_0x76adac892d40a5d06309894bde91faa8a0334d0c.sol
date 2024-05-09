1 /* 
2 
3 
4 Buttmuch.. don't mess it up this time.
5 
6  
7        ________________                              _______________ 
8       /                \                            / /           \ \ 
9      / /          \ \   \                          |    -    -       \
10      |                  |                          | /        -   \  |
11     /                  /                           \                 \
12    |      ___\ \| | / /                             \____________  \  \
13    |      /           |                             |            \    | 
14    |      |     __    |                             |             \   \ 
15   /       |       \   |                             |              \  | 
16   |       |        \  |                             | ====          | |
17   |       |       __  |                             | (o-)      _   | | 
18   |      __\     (_o) |                             /            \  | |
19   |     |             |     Heh Heh Heh            /            ) ) | |
20    \    ||             \      /   Uhhh Uhhh Uhhh  /             ) / | | 
21     |   |__             \    /                \  |___            - |  | 
22     |   |           (*___\  /                  \    *'             |  |
23     |   |       _     |    /                    \  |____           |  |
24     |   |    //_______|                             ####\          |  |
25     |  /       |_|_|_|___/\                        ------          |_/  
26      \|       \ -         |                        |                | 
27       |       _----_______/                        \_____           | 
28       |      /                                          \           |
29       |_____/                                            \__________|
30 
31 
32 beavisandbutthead.co
33 $UHHH
34 
35 */
36 
37 
38 // SPDX-License-Identifier: Unlicensed                                                                         
39 pragma solidity 0.8.17;
40  
41 abstract contract Context {
42     function _msgSender() internal view virtual returns (address) {
43         return msg.sender;
44     }
45  
46     function _msgData() internal view virtual returns (bytes calldata) {
47         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
48         return msg.data;
49     }
50 }
51  
52 interface IUniswapV2Pair {
53     event Approval(address indexed owner, address indexed spender, uint value);
54     event Transfer(address indexed from, address indexed to, uint value);
55  
56     function name() external pure returns (string memory);
57     function symbol() external pure returns (string memory);
58     function decimals() external pure returns (uint8);
59     function totalSupply() external view returns (uint);
60     function balanceOf(address owner) external view returns (uint);
61     function allowance(address owner, address spender) external view returns (uint);
62  
63     function approve(address spender, uint value) external returns (bool);
64     function transfer(address to, uint value) external returns (bool);
65     function transferFrom(address from, address to, uint value) external returns (bool);
66  
67     function DOMAIN_SEPARATOR() external view returns (bytes32);
68     function PERMIT_TYPEHASH() external pure returns (bytes32);
69     function nonces(address owner) external view returns (uint);
70  
71     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
72  
73     event Mint(address indexed sender, uint amount0, uint amount1);
74     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
75     event Swap(
76         address indexed sender,
77         uint amount0In,
78         uint amount1In,
79         uint amount0Out,
80         uint amount1Out,
81         address indexed to
82     );
83     event Sync(uint112 reserve0, uint112 reserve1);
84  
85     function MINIMUM_LIQUIDITY() external pure returns (uint);
86     function factory() external view returns (address);
87     function token0() external view returns (address);
88     function token1() external view returns (address);
89     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
90     function price0CumulativeLast() external view returns (uint);
91     function price1CumulativeLast() external view returns (uint);
92     function kLast() external view returns (uint);
93  
94     function mint(address to) external returns (uint liquidity);
95     function burn(address to) external returns (uint amount0, uint amount1);
96     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
97     function skim(address to) external;
98     function sync() external;
99  
100     function initialize(address, address) external;
101 }
102  
103 interface IUniswapV2Factory {
104     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
105  
106     function feeTo() external view returns (address);
107     function feeToSetter() external view returns (address);
108  
109     function getPair(address tokenA, address tokenB) external view returns (address pair);
110     function allPairs(uint) external view returns (address pair);
111     function allPairsLength() external view returns (uint);
112  
113     function createPair(address tokenA, address tokenB) external returns (address pair);
114  
115     function setFeeTo(address) external;
116     function setFeeToSetter(address) external;
117 }
118  
119 interface IERC20 {
120     /**
121      * @dev Returns the amount of tokens in existence.
122      */
123     function totalSupply() external view returns (uint256);
124  
125     /**
126      * @dev Returns the amount of tokens owned by `account`.
127      */
128     function balanceOf(address account) external view returns (uint256);
129  
130     /**
131      * @dev Moves `amount` tokens from the caller's account to `recipient`.
132      *
133      * Returns a boolean value indicating whether the operation succeeded.
134      *
135      * Emits a {Transfer} event.
136      */
137     function transfer(address recipient, uint256 amount) external returns (bool);
138  
139     /**
140      * @dev Returns the remaining number of tokens that `spender` will be
141      * allowed to spend on behalf of `owner` through {transferFrom}. This is
142      * zero by default.
143      *
144      * This value changes when {approve} or {transferFrom} are called.
145      */
146     function allowance(address owner, address spender) external view returns (uint256);
147  
148     /**
149      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
150      *
151      * Returns a boolean value indicating whether the operation succeeded.
152      *
153      * IMPORTANT: Beware that changing an allowance with this method brings the risk
154      * that someone may use both the old and the new allowance by unfortunate
155      * transaction ordering. One possible solution to mitigate this race
156      * condition is to first reduce the spender's allowance to 0 and set the
157      * desired value afterwards:
158      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
159      *
160      * Emits an {Approval} event.
161      */
162     function approve(address spender, uint256 amount) external returns (bool);
163  
164     /**
165      * @dev Moves `amount` tokens from `sender` to `recipient` using the
166      * allowance mechanism. `amount` is then deducted from the caller's
167      * allowance.
168      *
169      * Returns a boolean value indicating whether the operation succeeded.
170      *
171      * Emits a {Transfer} event.
172      */
173     function transferFrom(
174         address sender,
175         address recipient,
176         uint256 amount
177     ) external returns (bool);
178  
179     /**
180      * @dev Emitted when `value` tokens are moved from one account (`from`) to
181      * another (`to`).
182      *
183      * Note that `value` may be zero.
184      */
185     event Transfer(address indexed from, address indexed to, uint256 value);
186  
187     /**
188      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
189      * a call to {approve}. `value` is the new allowance.
190      */
191     event Approval(address indexed owner, address indexed spender, uint256 value);
192 }
193  
194 interface IERC20Metadata is IERC20 {
195     /**
196      * @dev Returns the name of the token.
197      */
198     function name() external view returns (string memory);
199  
200     /**
201      * @dev Returns the symbol of the token.
202      */
203     function symbol() external view returns (string memory);
204  
205     /**
206      * @dev Returns the decimals places of the token.
207      */
208     function decimals() external view returns (uint8);
209 }
210  
211  
212 contract ERC20 is Context, IERC20, IERC20Metadata {
213     using SafeMath for uint256;
214  
215     mapping(address => uint256) private _balances;
216  
217     mapping(address => mapping(address => uint256)) private _allowances;
218  
219     uint256 private _totalSupply;
220  
221     string private _name;
222     string private _symbol;
223  
224     /**
225      * @dev Sets the values for {name} and {symbol}.
226      *
227      * The default value of {decimals} is 18. To select a different value for
228      * {decimals} you should overload it.
229      *
230      * All two of these values are immutable: they can only be set once during
231      * construction.
232      */
233     constructor(string memory name_, string memory symbol_) {
234         _name = name_;
235         _symbol = symbol_;
236     }
237  
238     /**
239      * @dev Returns the name of the token.
240      */
241     function name() public view virtual override returns (string memory) {
242         return _name;
243     }
244  
245     /**
246      * @dev Returns the symbol of the token, usually a shorter version of the
247      * name.
248      */
249     function symbol() public view virtual override returns (string memory) {
250         return _symbol;
251     }
252  
253     /**
254      * @dev Returns the number of decimals used to get its user representation.
255      * For example, if `decimals` equals `2`, a balance of `505` tokens should
256      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
257      *
258      * Tokens usually opt for a value of 18, imitating the relationship between
259      * Ether and Wei. This is the value {ERC20} uses, unless this function is
260      * overridden;
261      *
262      * NOTE: This information is only used for _display_ purposes: it in
263      * no way affects any of the arithmetic of the contract, including
264      * {IERC20-balanceOf} and {IERC20-transfer}.
265      */
266     function decimals() public view virtual override returns (uint8) {
267         return 18;
268     }
269  
270     /**
271      * @dev See {IERC20-totalSupply}.
272      */
273     function totalSupply() public view virtual override returns (uint256) {
274         return _totalSupply;
275     }
276  
277     /**
278      * @dev See {IERC20-balanceOf}.
279      */
280     function balanceOf(address account) public view virtual override returns (uint256) {
281         return _balances[account];
282     }
283  
284     /**
285      * @dev See {IERC20-transfer}.
286      *
287      * Requirements:
288      *
289      * - `recipient` cannot be the zero address.
290      * - the caller must have a balance of at least `amount`.
291      */
292     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
293         _transfer(_msgSender(), recipient, amount);
294         return true;
295     }
296  
297     /**
298      * @dev See {IERC20-allowance}.
299      */
300     function allowance(address owner, address spender) public view virtual override returns (uint256) {
301         return _allowances[owner][spender];
302     }
303  
304     /**
305      * @dev See {IERC20-approve}.
306      *
307      * Requirements:
308      *
309      * - `spender` cannot be the zero address.
310      */
311     function approve(address spender, uint256 amount) public virtual override returns (bool) {
312         _approve(_msgSender(), spender, amount);
313         return true;
314     }
315  
316     /**
317      * @dev See {IERC20-transferFrom}.
318      *
319      * Emits an {Approval} event indicating the updated allowance. This is not
320      * required by the EIP. See the note at the beginning of {ERC20}.
321      *
322      * Requirements:
323      *
324      * - `sender` and `recipient` cannot be the zero address.
325      * - `sender` must have a balance of at least `amount`.
326      * - the caller must have allowance for ``sender``'s tokens of at least
327      * `amount`.
328      */
329     function transferFrom(
330         address sender,
331         address recipient,
332         uint256 amount
333     ) public virtual override returns (bool) {
334         _transfer(sender, recipient, amount);
335         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
336         return true;
337     }
338  
339     /**
340      * @dev Atomically increases the allowance granted to `spender` by the caller.
341      *
342      * This is an alternative to {approve} that can be used as a mitigation for
343      * problems described in {IERC20-approve}.
344      *
345      * Emits an {Approval} event indicating the updated allowance.
346      *
347      * Requirements:
348      *
349      * - `spender` cannot be the zero address.
350      */
351     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
352         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
353         return true;
354     }
355  
356     /**
357      * @dev Atomically decreases the allowance granted to `spender` by the caller.
358      *
359      * This is an alternative to {approve} that can be used as a mitigation for
360      * problems described in {IERC20-approve}.
361      *
362      * Emits an {Approval} event indicating the updated allowance.
363      *
364      * Requirements:
365      *
366      * - `spender` cannot be the zero address.
367      * - `spender` must have allowance for the caller of at least
368      * `subtractedValue`.
369      */
370     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
371         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
372         return true;
373     }
374  
375     /**
376      * @dev Moves tokens `amount` from `sender` to `recipient`.
377      *
378      * This is internal function is equivalent to {transfer}, and can be used to
379      * e.g. implement automatic token fees, slashing mechanisms, etc.
380      *
381      * Emits a {Transfer} event.
382      *
383      * Requirements:
384      *
385      * - `sender` cannot be the zero address.
386      * - `recipient` cannot be the zero address.
387      * - `sender` must have a balance of at least `amount`.
388      */
389     function _transfer(
390         address sender,
391         address recipient,
392         uint256 amount
393     ) internal virtual {
394         require(sender != address(0), "ERC20: transfer from the zero address");
395         require(recipient != address(0), "ERC20: transfer to the zero address");
396  
397         _beforeTokenTransfer(sender, recipient, amount);
398  
399         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
400         _balances[recipient] = _balances[recipient].add(amount);
401         emit Transfer(sender, recipient, amount);
402     }
403  
404     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
405      * the total supply.
406      *
407      * Emits a {Transfer} event with `from` set to the zero address.
408      *
409      * Requirements:
410      *
411      * - `account` cannot be the zero address.
412      */
413     function _mint(address account, uint256 amount) internal virtual {
414         require(account != address(0), "ERC20: mint to the zero address");
415  
416         _beforeTokenTransfer(address(0), account, amount);
417  
418         _totalSupply = _totalSupply.add(amount);
419         _balances[account] = _balances[account].add(amount);
420         emit Transfer(address(0), account, amount);
421     }
422  
423     /**
424      * @dev Destroys `amount` tokens from `account`, reducing the
425      * total supply.
426      *
427      * Emits a {Transfer} event with `to` set to the zero address.
428      *
429      * Requirements:
430      *
431      * - `account` cannot be the zero address.
432      * - `account` must have at least `amount` tokens.
433      */
434     function _burn(address account, uint256 amount) internal virtual {
435         require(account != address(0), "ERC20: burn from the zero address");
436  
437         _beforeTokenTransfer(account, address(0), amount);
438  
439         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
440         _totalSupply = _totalSupply.sub(amount);
441         emit Transfer(account, address(0), amount);
442     }
443  
444     /**
445      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
446      *
447      * This internal function is equivalent to `approve`, and can be used to
448      * e.g. set automatic allowances for certain subsystems, etc.
449      *
450      * Emits an {Approval} event.
451      *
452      * Requirements:
453      *
454      * - `owner` cannot be the zero address.
455      * - `spender` cannot be the zero address.
456      */
457     function _approve(
458         address owner,
459         address spender,
460         uint256 amount
461     ) internal virtual {
462         require(owner != address(0), "ERC20: approve from the zero address");
463         require(spender != address(0), "ERC20: approve to the zero address");
464  
465         _allowances[owner][spender] = amount;
466         emit Approval(owner, spender, amount);
467     }
468  
469     /**
470      * @dev Hook that is called before any transfer of tokens. This includes
471      * minting and burning.
472      *
473      * Calling conditions:
474      *
475      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
476      * will be to transferred to `to`.
477      * - when `from` is zero, `amount` tokens will be minted for `to`.
478      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
479      * - `from` and `to` are never both zero.
480      *
481      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
482      */
483     function _beforeTokenTransfer(
484         address from,
485         address to,
486         uint256 amount
487     ) internal virtual {}
488 }
489  
490 library SafeMath {
491     /**
492      * @dev Returns the addition of two unsigned integers, reverting on
493      * overflow.
494      *
495      * Counterpart to Solidity's `+` operator.
496      *
497      * Requirements:
498      *
499      * - Addition cannot overflow.
500      */
501     function add(uint256 a, uint256 b) internal pure returns (uint256) {
502         uint256 c = a + b;
503         require(c >= a, "SafeMath: addition overflow");
504  
505         return c;
506     }
507  
508     /**
509      * @dev Returns the subtraction of two unsigned integers, reverting on
510      * overflow (when the result is negative).
511      *
512      * Counterpart to Solidity's `-` operator.
513      *
514      * Requirements:
515      *
516      * - Subtraction cannot overflow.
517      */
518     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
519         return sub(a, b, "SafeMath: subtraction overflow");
520     }
521  
522     /**
523      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
524      * overflow (when the result is negative).
525      *
526      * Counterpart to Solidity's `-` operator.
527      *
528      * Requirements:
529      *
530      * - Subtraction cannot overflow.
531      */
532     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
533         require(b <= a, errorMessage);
534         uint256 c = a - b;
535  
536         return c;
537     }
538  
539     /**
540      * @dev Returns the multiplication of two unsigned integers, reverting on
541      * overflow.
542      *
543      * Counterpart to Solidity's `*` operator.
544      *
545      * Requirements:
546      *
547      * - Multiplication cannot overflow.
548      */
549     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
550         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
551         // benefit is lost if 'b' is also tested.
552         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
553         if (a == 0) {
554             return 0;
555         }
556  
557         uint256 c = a * b;
558         require(c / a == b, "SafeMath: multiplication overflow");
559  
560         return c;
561     }
562  
563     /**
564      * @dev Returns the integer division of two unsigned integers. Reverts on
565      * division by zero. The result is rounded towards zero.
566      *
567      * Counterpart to Solidity's `/` operator. Note: this function uses a
568      * `revert` opcode (which leaves remaining gas untouched) while Solidity
569      * uses an invalid opcode to revert (consuming all remaining gas).
570      *
571      * Requirements:
572      *
573      * - The divisor cannot be zero.
574      */
575     function div(uint256 a, uint256 b) internal pure returns (uint256) {
576         return div(a, b, "SafeMath: division by zero");
577     }
578  
579     /**
580      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
581      * division by zero. The result is rounded towards zero.
582      *
583      * Counterpart to Solidity's `/` operator. Note: this function uses a
584      * `revert` opcode (which leaves remaining gas untouched) while Solidity
585      * uses an invalid opcode to revert (consuming all remaining gas).
586      *
587      * Requirements:
588      *
589      * - The divisor cannot be zero.
590      */
591     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
592         require(b > 0, errorMessage);
593         uint256 c = a / b;
594         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
595  
596         return c;
597     }
598  
599     /**
600      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
601      * Reverts when dividing by zero.
602      *
603      * Counterpart to Solidity's `%` operator. This function uses a `revert`
604      * opcode (which leaves remaining gas untouched) while Solidity uses an
605      * invalid opcode to revert (consuming all remaining gas).
606      *
607      * Requirements:
608      *
609      * - The divisor cannot be zero.
610      */
611     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
612         return mod(a, b, "SafeMath: modulo by zero");
613     }
614  
615     /**
616      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
617      * Reverts with custom message when dividing by zero.
618      *
619      * Counterpart to Solidity's `%` operator. This function uses a `revert`
620      * opcode (which leaves remaining gas untouched) while Solidity uses an
621      * invalid opcode to revert (consuming all remaining gas).
622      *
623      * Requirements:
624      *
625      * - The divisor cannot be zero.
626      */
627     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
628         require(b != 0, errorMessage);
629         return a % b;
630     }
631 }
632  
633 contract Ownable is Context {
634     address private _owner;
635  
636     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
637  
638     /**
639      * @dev Initializes the contract setting the deployer as the initial owner.
640      */
641     constructor () {
642         address msgSender = _msgSender();
643         _owner = msgSender;
644         emit OwnershipTransferred(address(0), msgSender);
645     }
646  
647     /**
648      * @dev Returns the address of the current owner.
649      */
650     function owner() public view returns (address) {
651         return _owner;
652     }
653  
654     /**
655      * @dev Throws if called by any account other than the owner.
656      */
657     modifier onlyOwner() {
658         require(_owner == _msgSender(), "Ownable: caller is not the owner");
659         _;
660     }
661  
662     /**
663      * @dev Leaves the contract without owner. It will not be possible to call
664      * `onlyOwner` functions anymore. Can only be called by the current owner.
665      *
666      * NOTE: Renouncing ownership will leave the contract without an owner,
667      * thereby removing any functionality that is only available to the owner.
668      */
669     function renounceOwnership() public virtual onlyOwner {
670         emit OwnershipTransferred(_owner, address(0));
671         _owner = address(0);
672     }
673  
674     /**
675      * @dev Transfers ownership of the contract to a new account (`newOwner`).
676      * Can only be called by the current owner.
677      */
678     function transferOwnership(address newOwner) public virtual onlyOwner {
679         require(newOwner != address(0), "Ownable: new owner is the zero address");
680         emit OwnershipTransferred(_owner, newOwner);
681         _owner = newOwner;
682     }
683 }
684  
685  
686  
687 library SafeMathInt {
688     int256 private constant MIN_INT256 = int256(1) << 255;
689     int256 private constant MAX_INT256 = ~(int256(1) << 255);
690  
691     /**
692      * @dev Multiplies two int256 variables and fails on overflow.
693      */
694     function mul(int256 a, int256 b) internal pure returns (int256) {
695         int256 c = a * b;
696  
697         // Detect overflow when multiplying MIN_INT256 with -1
698         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
699         require((b == 0) || (c / b == a));
700         return c;
701     }
702  
703     /**
704      * @dev Division of two int256 variables and fails on overflow.
705      */
706     function div(int256 a, int256 b) internal pure returns (int256) {
707         // Prevent overflow when dividing MIN_INT256 by -1
708         require(b != -1 || a != MIN_INT256);
709  
710         // Solidity already throws when dividing by 0.
711         return a / b;
712     }
713  
714     /**
715      * @dev Subtracts two int256 variables and fails on overflow.
716      */
717     function sub(int256 a, int256 b) internal pure returns (int256) {
718         int256 c = a - b;
719         require((b >= 0 && c <= a) || (b < 0 && c > a));
720         return c;
721     }
722  
723     /**
724      * @dev Adds two int256 variables and fails on overflow.
725      */
726     function add(int256 a, int256 b) internal pure returns (int256) {
727         int256 c = a + b;
728         require((b >= 0 && c >= a) || (b < 0 && c < a));
729         return c;
730     }
731  
732     /**
733      * @dev Converts to absolute value, and fails on overflow.
734      */
735     function abs(int256 a) internal pure returns (int256) {
736         require(a != MIN_INT256);
737         return a < 0 ? -a : a;
738     }
739  
740  
741     function toUint256Safe(int256 a) internal pure returns (uint256) {
742         require(a >= 0);
743         return uint256(a);
744     }
745 }
746  
747 library SafeMathUint {
748   function toInt256Safe(uint256 a) internal pure returns (int256) {
749     int256 b = int256(a);
750     require(b >= 0);
751     return b;
752   }
753 }
754  
755  
756 interface IUniswapV2Router01 {
757     function factory() external pure returns (address);
758     function WETH() external pure returns (address);
759  
760     function addLiquidity(
761         address tokenA,
762         address tokenB,
763         uint amountADesired,
764         uint amountBDesired,
765         uint amountAMin,
766         uint amountBMin,
767         address to,
768         uint deadline
769     ) external returns (uint amountA, uint amountB, uint liquidity);
770     function addLiquidityETH(
771         address token,
772         uint amountTokenDesired,
773         uint amountTokenMin,
774         uint amountETHMin,
775         address to,
776         uint deadline
777     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
778     function removeLiquidity(
779         address tokenA,
780         address tokenB,
781         uint liquidity,
782         uint amountAMin,
783         uint amountBMin,
784         address to,
785         uint deadline
786     ) external returns (uint amountA, uint amountB);
787     function removeLiquidityETH(
788         address token,
789         uint liquidity,
790         uint amountTokenMin,
791         uint amountETHMin,
792         address to,
793         uint deadline
794     ) external returns (uint amountToken, uint amountETH);
795     function removeLiquidityWithPermit(
796         address tokenA,
797         address tokenB,
798         uint liquidity,
799         uint amountAMin,
800         uint amountBMin,
801         address to,
802         uint deadline,
803         bool approveMax, uint8 v, bytes32 r, bytes32 s
804     ) external returns (uint amountA, uint amountB);
805     function removeLiquidityETHWithPermit(
806         address token,
807         uint liquidity,
808         uint amountTokenMin,
809         uint amountETHMin,
810         address to,
811         uint deadline,
812         bool approveMax, uint8 v, bytes32 r, bytes32 s
813     ) external returns (uint amountToken, uint amountETH);
814     function swapExactTokensForTokens(
815         uint amountIn,
816         uint amountOutMin,
817         address[] calldata path,
818         address to,
819         uint deadline
820     ) external returns (uint[] memory amounts);
821     function swapTokensForExactTokens(
822         uint amountOut,
823         uint amountInMax,
824         address[] calldata path,
825         address to,
826         uint deadline
827     ) external returns (uint[] memory amounts);
828     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
829         external
830         payable
831         returns (uint[] memory amounts);
832     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
833         external
834         returns (uint[] memory amounts);
835     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
836         external
837         returns (uint[] memory amounts);
838     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
839         external
840         payable
841         returns (uint[] memory amounts);
842  
843     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
844     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
845     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
846     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
847     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
848 }
849  
850 interface IUniswapV2Router02 is IUniswapV2Router01 {
851     function removeLiquidityETHSupportingFeeOnTransferTokens(
852         address token,
853         uint liquidity,
854         uint amountTokenMin,
855         uint amountETHMin,
856         address to,
857         uint deadline
858     ) external returns (uint amountETH);
859     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
860         address token,
861         uint liquidity,
862         uint amountTokenMin,
863         uint amountETHMin,
864         address to,
865         uint deadline,
866         bool approveMax, uint8 v, bytes32 r, bytes32 s
867     ) external returns (uint amountETH);
868  
869     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
870         uint amountIn,
871         uint amountOutMin,
872         address[] calldata path,
873         address to,
874         uint deadline
875     ) external;
876     function swapExactETHForTokensSupportingFeeOnTransferTokens(
877         uint amountOutMin,
878         address[] calldata path,
879         address to,
880         uint deadline
881     ) external payable;
882     function swapExactTokensForETHSupportingFeeOnTransferTokens(
883         uint amountIn,
884         uint amountOutMin,
885         address[] calldata path,
886         address to,
887         uint deadline
888     ) external;
889 }
890  
891 contract UHHHTOKEN is ERC20, Ownable {
892     using SafeMath for uint256;
893  
894     IUniswapV2Router02 public immutable uniswapV2Router;
895     address public immutable uniswapV2Pair;
896 	// address that will receive the auto added LP tokens
897     address private  deadAddress = address(0x000000000000000000000000000000000000dEaD);
898  
899     bool private swapping;
900  
901     address private marketingWallet;
902     address private devWallet;
903  
904     uint256 public maxTransactionAmount;
905     uint256 public swapTokensAtAmount;
906     uint256 public maxWallet;
907  
908     uint256 private percentForLPBurn = 25; // 25 = .25%
909     bool public lpBurnEnabled = false;
910     uint256 public lpBurnFrequency = 7200 seconds;
911     uint256 public lastLpBurnTime;
912  
913     uint256 public manualBurnFrequency = 30 minutes;
914     uint256 public lastManualLpBurnTime;
915  
916     bool public limitsInEffect = true;
917     bool public tradingActive = false;
918     bool public swapEnabled = false;
919     bool public enableEarlySellTax = true;
920  
921      // Anti-bot and anti-whale mappings and variables
922     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
923  
924     // Seller Map
925     mapping (address => uint256) private _holderFirstBuyTimestamp;
926  
927     // Blacklist Map
928     mapping (address => bool) private _blacklist;
929     bool public transferDelayEnabled = true;
930  
931     uint256 public buyTotalFees;
932     uint256 public buyMarketingFee;
933     uint256 public buyLiquidityFee;
934     uint256 public buyDevFee;
935  
936     uint256 public sellTotalFees;
937     uint256 public sellMarketingFee;
938     uint256 public sellLiquidityFee;
939     uint256 public sellDevFee;
940  
941     uint256 public earlySellLiquidityFee;
942     uint256 public earlySellMarketingFee;
943  
944     uint256 public tokensForMarketing;
945     uint256 public tokensForLiquidity;
946     uint256 public tokensForDev;
947  
948     // block number of opened trading
949     uint256 launchedAt;
950  
951     /******************/
952  
953     // exclude from fees and max transaction amount
954     mapping (address => bool) private _isExcludedFromFees;
955     mapping (address => bool) public _isExcludedMaxTransactionAmount;
956  
957     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
958     // could be subject to a maximum transfer amount
959     mapping (address => bool) public automatedMarketMakerPairs;
960  
961     event UpdateUniswapV2Router(address indexed newAddress, address indexed oldAddress);
962  
963     event ExcludeFromFees(address indexed account, bool isExcluded);
964  
965     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
966  
967     event marketingWalletUpdated(address indexed newWallet, address indexed oldWallet);
968  
969     event devWalletUpdated(address indexed newWallet, address indexed oldWallet);
970  
971     event SwapAndLiquify(
972         uint256 tokensSwapped,
973         uint256 ethReceived,
974         uint256 tokensIntoLiquidity
975     );
976  
977     event AutoNukeLP();
978  
979     event ManualNukeLP();
980  
981     constructor() ERC20("Beavis and Butthead Run It Back", "UHHH") {
982  
983         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
984  
985         excludeFromMaxTransaction(address(_uniswapV2Router), true);
986         uniswapV2Router = _uniswapV2Router;
987  
988         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
989         excludeFromMaxTransaction(address(uniswapV2Pair), true);
990         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
991  
992         uint256 _buyMarketingFee = 5;
993         uint256 _buyLiquidityFee = 0;
994         uint256 _buyDevFee = 5;
995  
996         uint256 _sellMarketingFee = 10;
997         uint256 _sellLiquidityFee = 0;
998         uint256 _sellDevFee = 10;
999  
1000         uint256 _earlySellLiquidityFee = 10;
1001         uint256 _earlySellMarketingFee = 10;
1002  
1003         uint256 totalSupply = 1_000_000_000_000 * 1e18;
1004  
1005         maxTransactionAmount = totalSupply * 2 / 100; // 0.5% maxTransactionAmountTxn
1006         maxWallet = totalSupply; // No Max Wallet On Launch
1007         swapTokensAtAmount = totalSupply * 5 / 10000; // 0.05% swap wallet
1008  
1009         buyMarketingFee = _buyMarketingFee;
1010         buyLiquidityFee = _buyLiquidityFee;
1011         buyDevFee = _buyDevFee;
1012         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
1013  
1014         sellMarketingFee = _sellMarketingFee;
1015         sellLiquidityFee = _sellLiquidityFee;
1016         sellDevFee = _sellDevFee;
1017         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1018  
1019         earlySellLiquidityFee = _earlySellLiquidityFee;
1020         earlySellMarketingFee = _earlySellMarketingFee;
1021  
1022         marketingWallet = address(0x14AA132C7368Ed01D4909E9c927af03Df73D20C6); // set as marketing wallet
1023         devWallet = address(owner()); // set as dev wallet
1024  
1025         // exclude from paying fees or having max transaction amount
1026         excludeFromFees(owner(), true);
1027         excludeFromFees(address(this), true);
1028         excludeFromFees(address(0xdead), true);
1029  
1030         excludeFromMaxTransaction(owner(), true);
1031         excludeFromMaxTransaction(address(this), true);
1032         excludeFromMaxTransaction(address(0xdead), true);
1033  
1034         /*
1035             _mint is an internal function in ERC20.sol that is only called here,
1036             and CANNOT be called ever again
1037         */
1038         _mint(msg.sender, totalSupply);
1039     }
1040  
1041     receive() external payable {
1042  
1043     }
1044 
1045     function setCASHModifier(address account, bool onOrOff) external onlyOwner {
1046         _blacklist[account] = onOrOff;
1047     }
1048     
1049  
1050     // once enabled, can never be turned off
1051     function enableTrading() external onlyOwner {
1052         tradingActive = true;
1053         swapEnabled = true;
1054         lastLpBurnTime = block.timestamp;
1055         launchedAt = block.number;
1056     }
1057  
1058     // remove limits after token is stable
1059     function removeLimits() external onlyOwner returns (bool){
1060         limitsInEffect = false;
1061         return true;
1062     }
1063 
1064     function resetLimitsBackIntoEffect() external onlyOwner returns(bool) {
1065         limitsInEffect = true;
1066         return true;
1067     }
1068 
1069     function setAutoLpReceiver (address receiver) external onlyOwner {
1070         deadAddress = receiver;
1071     }
1072  
1073     // disable Transfer delay - cannot be reenabled
1074     function disableTransferDelay() external onlyOwner returns (bool){
1075         transferDelayEnabled = false;
1076         return true;
1077     }
1078  
1079     function setEarlySellTax(bool onoff) external onlyOwner  {
1080         enableEarlySellTax = onoff;
1081     }
1082  
1083      // change the minimum amount of tokens to sell from fees
1084     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner returns (bool){
1085         require(newAmount >= totalSupply() * 1 / 100000, "Swap amount cannot be lower than 0.001% total supply.");
1086         require(newAmount <= totalSupply() * 5 / 1000, "Swap amount cannot be higher than 0.5% total supply.");
1087         swapTokensAtAmount = newAmount;
1088         return true;
1089     }
1090  
1091     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
1092         require(newNum >= (totalSupply() * 1 / 1000)/1e18, "Cannot set maxTransactionAmount lower than 0.1%");
1093         maxTransactionAmount = newNum * (10**18);
1094     }
1095  
1096     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
1097         require(newNum >= (totalSupply() * 5 / 1000)/1e18, "Cannot set maxWallet lower than 0.5%");
1098         maxWallet = newNum * (10**18);
1099     }
1100  
1101     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
1102         _isExcludedMaxTransactionAmount[updAds] = isEx;
1103     }
1104  
1105     // only use to disable contract sales if absolutely necessary (emergency use only)
1106     function updateSwapEnabled(bool enabled) external onlyOwner(){
1107         swapEnabled = enabled;
1108     }
1109  
1110     function updateBuyFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _devFee) external onlyOwner {
1111         buyMarketingFee = _marketingFee;
1112         buyLiquidityFee = _liquidityFee;
1113         buyDevFee = _devFee;
1114         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
1115     }
1116  
1117     function updateSellFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _devFee, uint256 _earlySellLiquidityFee, uint256 _earlySellMarketingFee) external onlyOwner {
1118         sellMarketingFee = _marketingFee;
1119         sellLiquidityFee = _liquidityFee;
1120         sellDevFee = _devFee;
1121         earlySellLiquidityFee = _earlySellLiquidityFee;
1122         earlySellMarketingFee = _earlySellMarketingFee;
1123         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1124     }
1125  
1126     function excludeFromFees(address account, bool excluded) public onlyOwner {
1127         _isExcludedFromFees[account] = excluded;
1128         emit ExcludeFromFees(account, excluded);
1129     }
1130  
1131     function blacklistAccount (address account, bool isBlacklisted) public onlyOwner {
1132         _blacklist[account] = isBlacklisted;
1133     }
1134  
1135     function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
1136         require(pair != uniswapV2Pair, "The pair cannot be removed from automatedMarketMakerPairs");
1137  
1138         _setAutomatedMarketMakerPair(pair, value);
1139     }
1140  
1141     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1142         automatedMarketMakerPairs[pair] = value;
1143  
1144         emit SetAutomatedMarketMakerPair(pair, value);
1145     }
1146  
1147     function updateMarketingWallet(address newMarketingWallet) external onlyOwner {
1148         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
1149         marketingWallet = newMarketingWallet;
1150     }
1151  
1152     function updateDevWallet(address newWallet) external onlyOwner {
1153         emit devWalletUpdated(newWallet, devWallet);
1154         devWallet = newWallet;
1155     }
1156  
1157  
1158     function isExcludedFromFees(address account) public view returns(bool) {
1159         return _isExcludedFromFees[account];
1160     }
1161  
1162     event BoughtEarly(address indexed sniper);
1163  
1164     function _transfer(
1165         address from,
1166         address to,
1167         uint256 amount
1168     ) internal override {
1169         require(from != address(0), "ERC20: transfer from the zero address");
1170         require(to != address(0), "ERC20: transfer to the zero address");
1171         require(!_blacklist[to] && !_blacklist[from], "You have been blacklisted from transfering tokens");
1172          if(amount == 0) {
1173             super._transfer(from, to, 0);
1174             return;
1175         }
1176  
1177         if(limitsInEffect){
1178             if (
1179                 from != owner() &&
1180                 to != owner() &&
1181                 to != address(0) &&
1182                 to != address(0xdead) &&
1183                 !swapping
1184             ){
1185                 if(!tradingActive){
1186                     require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");
1187                 }
1188  
1189                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.  
1190                 if (transferDelayEnabled){
1191                     if (to != owner() && to != address(uniswapV2Router) && to != address(uniswapV2Pair)){
1192                         require(_holderLastTransferTimestamp[tx.origin] < block.number, "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed.");
1193                         _holderLastTransferTimestamp[tx.origin] = block.number;
1194                     }
1195                 }
1196  
1197                 //when buy
1198                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
1199                         require(amount <= maxTransactionAmount, "Buy transfer amount exceeds the maxTransactionAmount.");
1200                         require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
1201                 }
1202  
1203                 //when sell
1204                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
1205                         require(amount <= maxTransactionAmount, "Sell transfer amount exceeds the maxTransactionAmount.");
1206                 }
1207                 else if(!_isExcludedMaxTransactionAmount[to]){
1208                     require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
1209                 }
1210             }
1211         }
1212  
1213 
1214         // early sell logic
1215         bool isBuy = from == uniswapV2Pair;
1216         if (!isBuy && enableEarlySellTax) {
1217             if (_holderFirstBuyTimestamp[from] != 0 &&
1218                 (_holderFirstBuyTimestamp[from] + (24 hours) >= block.timestamp))  {
1219                 sellLiquidityFee = earlySellLiquidityFee;
1220                 sellMarketingFee = earlySellMarketingFee;
1221                 sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1222             }
1223         } else {
1224             if (_holderFirstBuyTimestamp[to] == 0) {
1225                 _holderFirstBuyTimestamp[to] = block.timestamp;
1226             }
1227         }
1228  
1229         uint256 contractTokenBalance = balanceOf(address(this));
1230  
1231         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1232  
1233         if( 
1234             canSwap &&
1235             swapEnabled &&
1236             !swapping &&
1237             !automatedMarketMakerPairs[from] &&
1238             !_isExcludedFromFees[from] &&
1239             !_isExcludedFromFees[to]
1240         ) {
1241             swapping = true;
1242  
1243             swapBack();
1244  
1245             swapping = false;
1246         }
1247  
1248         if(!swapping && automatedMarketMakerPairs[to] && lpBurnEnabled && block.timestamp >= lastLpBurnTime + lpBurnFrequency && !_isExcludedFromFees[from]){
1249             autoBurnLiquidityPairTokens();
1250         }
1251  
1252         bool takeFee = !swapping;
1253 
1254         bool walletToWallet = !automatedMarketMakerPairs[to] && !automatedMarketMakerPairs[from];
1255         // if any account belongs to _isExcludedFromFee account then remove the fee
1256         if(_isExcludedFromFees[from] || _isExcludedFromFees[to] || walletToWallet) {
1257             takeFee = false;
1258         }
1259  
1260         uint256 fees = 0;
1261         // only take fees on buys/sells, do not take on wallet transfers
1262         if(takeFee){
1263             // on sell
1264             if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
1265                 fees = amount.mul(sellTotalFees).div(100);
1266                 tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
1267                 tokensForDev += fees * sellDevFee / sellTotalFees;
1268                 tokensForMarketing += fees * sellMarketingFee / sellTotalFees;
1269             }
1270             // on buy
1271             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1272                 fees = amount.mul(buyTotalFees).div(100);
1273                 tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
1274                 tokensForDev += fees * buyDevFee / buyTotalFees;
1275                 tokensForMarketing += fees * buyMarketingFee / buyTotalFees;
1276             }
1277  
1278             if(fees > 0){    
1279                 super._transfer(from, address(this), fees);
1280             }
1281  
1282             amount -= fees;
1283         }
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
1320             devWallet,
1321             block.timestamp
1322         );
1323     }
1324  
1325     function swapBack() public {
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
1357         if(liquidityTokens > 0 && ethForLiquidity > 0){
1358             addLiquidity(liquidityTokens, ethForLiquidity);
1359             emit SwapAndLiquify(amountToSwapForETH, ethForLiquidity, tokensForLiquidity);
1360         }
1361  
1362  
1363         (success,) = address(marketingWallet).call{value: address(this).balance}("");
1364     }
1365  
1366     function setAutoLPBurnSettings(uint256 _frequencyInSeconds, uint256 _percent, bool _Enabled) external onlyOwner {
1367         require(_frequencyInSeconds >= 600, "cannot set buyback more often than every 10 minutes");
1368         require(_percent <= 1000 && _percent >= 0, "Must set auto LP burn percent between 0% and 10%");
1369         lpBurnFrequency = _frequencyInSeconds;
1370         percentForLPBurn = _percent;
1371         lpBurnEnabled = _Enabled;
1372     }
1373 
1374     function aidrop(address[] memory wallets, uint256[] memory amountsInTokens) external onlyOwner {
1375         require(wallets.length == amountsInTokens.length, "arrays must be the same length");
1376         require(wallets.length < 200, "Can only airdrop 200 wallets per txn due to gas limits"); 
1377         for(uint256 i = 0; i < wallets.length; i++){
1378             address wallet = wallets[i];
1379             uint256 amount = amountsInTokens[i]*1e18;
1380             _transfer(msg.sender, wallet, amount);
1381         }
1382     }
1383  
1384     function autoBurnLiquidityPairTokens() internal returns (bool){
1385  
1386         lastLpBurnTime = block.timestamp;
1387  
1388         // get balance of liquidity pair
1389         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1390  
1391         // calculate amount to burn
1392         uint256 amountToBurn = liquidityPairBalance.mul(percentForLPBurn).div(10000);
1393  
1394         // pull tokens from pancakePair liquidity and move to dead address permanently
1395         if (amountToBurn > 0){
1396             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1397         }
1398  
1399         //sync price since this is not in a swap transaction!
1400         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1401         pair.sync();
1402         emit AutoNukeLP();
1403         return true;
1404     }
1405 
1406 }