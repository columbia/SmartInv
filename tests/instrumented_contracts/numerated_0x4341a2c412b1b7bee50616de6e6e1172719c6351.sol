1 /*
2 
3 GUPPI.FINANCE - Official GUPPI token contract
4 Bringing DeFi To the Masses
5 
6 At its core, the ethos behind GUPPI token is one of fairness and sustainability. 
7 With a total supply of 1 billion, the token introduces several thresholds to maintain the ecosystem's health: 
8 - a 2% maximum wallet holding, 
9 - 1% maximum transaction limit,
10 - and 6% taxes applied on buy and sell transactions (out of which 1% is directed into the liquidity to ensure price stability, and 1% into our staking pool to share it among our holders). 
11 GUPPI token launches with 30 ETH liquidity paired. 
12 
13 The team owns a vested token allocation of 4%, and there is 5% earmarked for CEX listings, 91% of the total supply is in circulation either through private sale or public trading. 
14 Integral to our overarching ecosystem, the GUPPI token is more than just a digital asset. 
15 It's the gateway to a series of utilities that serve to augment the user experience. 
16 
17 Of all utilities, the "crown jewel" of the GUPPI ecosystem is our revenue-sharing staking system. 
18 Through it, holders can earn a substantial allocation of our ecosystem’s diverse income streams, 
19 which include transaction tax revenue, earnings from the Harpoon sniper tool, proceeds from the payment processor, and swap income.
20 
21 Website: https://guppi.finance/
22 Twitter: https://twitter.com/guppifinance
23 Telegram Chat: https://t.me/guppifinanceverify
24 Telegram ANN: https://t.me/guppifinanceann
25 
26 Binocular Free TG Smart Contract Scanner: https://t.me/guppiscanner
27 Binocular Free TG Scanner Bot: https://t.me/GuppiBinocularScannerBot
28 Binocular PRO: https://t.me/GuppiBinocularPRO_bot
29 
30 Scammer Hall of Shame: https://t.me/GuppiHOS
31 On-Chain Scam Alert: guppi-scam-alert.eth
32 On-Chain Analysis: guppi-scanner.eth
33 
34 */                                                                            
35 
36 
37 // SPDX-License-Identifier: MIT
38 pragma solidity 0.8.9;
39 
40 abstract contract Context {
41     function _msgSender() internal view virtual returns (address) {
42         return msg.sender;
43     }
44 
45     function _msgData() internal view virtual returns (bytes calldata) {
46         this;
47         return msg.data;
48     }
49 }
50 
51 interface IUniswapV2Pair {
52     event Approval(address indexed owner, address indexed spender, uint value);
53     event Transfer(address indexed from, address indexed to, uint value);
54 
55     function name() external pure returns (string memory);
56     function symbol() external pure returns (string memory);
57     function decimals() external pure returns (uint8);
58     function totalSupply() external view returns (uint);
59     function balanceOf(address owner) external view returns (uint);
60     function allowance(address owner, address spender) external view returns (uint);
61 
62     function approve(address spender, uint value) external returns (bool);
63     function transfer(address to, uint value) external returns (bool);
64     function transferFrom(address from, address to, uint value) external returns (bool);
65 
66     function DOMAIN_SEPARATOR() external view returns (bytes32);
67     function PERMIT_TYPEHASH() external pure returns (bytes32);
68     function nonces(address owner) external view returns (uint);
69 
70     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
71 
72     event Mint(address indexed sender, uint amount0, uint amount1);
73     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
74     event Swap(
75         address indexed sender,
76         uint amount0In,
77         uint amount1In,
78         uint amount0Out,
79         uint amount1Out,
80         address indexed to
81     );
82     event Sync(uint112 reserve0, uint112 reserve1);
83 
84     function MINIMUM_LIQUIDITY() external pure returns (uint);
85     function factory() external view returns (address);
86     function token0() external view returns (address);
87     function token1() external view returns (address);
88     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
89     function price0CumulativeLast() external view returns (uint);
90     function price1CumulativeLast() external view returns (uint);
91     function kLast() external view returns (uint);
92 
93     function mint(address to) external returns (uint liquidity);
94     function burn(address to) external returns (uint amount0, uint amount1);
95     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
96     function skim(address to) external;
97     function sync() external;
98 
99     function initialize(address, address) external;
100 }
101 
102 interface IUniswapV2Factory {
103     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
104 
105     function feeTo() external view returns (address);
106     function feeToSetter() external view returns (address);
107 
108     function getPair(address tokenA, address tokenB) external view returns (address pair);
109     function allPairs(uint) external view returns (address pair);
110     function allPairsLength() external view returns (uint);
111 
112     function createPair(address tokenA, address tokenB) external returns (address pair);
113 
114     function setFeeTo(address) external;
115     function setFeeToSetter(address) external;
116 }
117 
118 interface IERC20 {
119     /**
120      * @dev Returns the amount of tokens in existence.
121      */
122     function totalSupply() external view returns (uint256);
123 
124     /**
125      * @dev Returns the amount of tokens owned by `account`.
126      */
127     function balanceOf(address account) external view returns (uint256);
128 
129     /**
130      * @dev Moves `amount` tokens from the caller's account to `recipient`.
131      *
132      * Returns a boolean value indicating whether the operation succeeded.
133      *
134      * Emits a {Transfer} event.
135      */
136     function transfer(address recipient, uint256 amount) external returns (bool);
137 
138     /**
139      * @dev Returns the remaining number of tokens that `spender` will be
140      * allowed to spend on behalf of `owner` through {transferFrom}. This is
141      * zero by default.
142      *
143      * This value changes when {approve} or {transferFrom} are called.
144      */
145     function allowance(address owner, address spender) external view returns (uint256);
146 
147     /**
148      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
149      *
150      * Returns a boolean value indicating whether the operation succeeded.
151      *
152      * IMPORTANT: Beware that changing an allowance with this method brings the risk
153      * that someone may use both the old and the new allowance by unfortunate
154      * transaction ordering. One possible solution to mitigate this race
155      * condition is to first reduce the spender's allowance to 0 and set the
156      * desired value afterwards:
157      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
158      *
159      * Emits an {Approval} event.
160      */
161     function approve(address spender, uint256 amount) external returns (bool);
162 
163     /**
164      * @dev Moves `amount` tokens from `sender` to `recipient` using the
165      * allowance mechanism. `amount` is then deducted from the caller's
166      * allowance.
167      *
168      * Returns a boolean value indicating whether the operation succeeded.
169      *
170      * Emits a {Transfer} event.
171      */
172     function transferFrom(
173         address sender,
174         address recipient,
175         uint256 amount
176     ) external returns (bool);
177 
178     /**
179      * @dev Emitted when `value` tokens are moved from one account (`from`) to
180      * another (`to`).
181      *
182      * Note that `value` may be zero.
183      */
184     event Transfer(address indexed from, address indexed to, uint256 value);
185 
186     /**
187      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
188      * a call to {approve}. `value` is the new allowance.
189      */
190     event Approval(address indexed owner, address indexed spender, uint256 value);
191 }
192 
193 interface IERC20Metadata is IERC20 {
194     /**
195      * @dev Returns the name of the token.
196      */
197     function name() external view returns (string memory);
198 
199     /**
200      * @dev Returns the symbol of the token.
201      */
202     function symbol() external view returns (string memory);
203 
204     /**
205      * @dev Returns the decimals places of the token.
206      */
207     function decimals() external view returns (uint8);
208 }
209 
210 
211 contract ERC20 is Context, IERC20, IERC20Metadata {
212     using SafeMath for uint256;
213     mapping(address => uint256) private _balances;
214     mapping(address => mapping(address => uint256)) private _allowances;
215     uint256 private _totalSupply;
216     string private _name;
217     string private _symbol;
218 
219     /**
220      * @dev Sets the values for {name} and {symbol}.
221      *
222      * The default value of {decimals} is 18. To select a different value for
223      * {decimals} you should overload it.
224      *
225      * All two of these values are immutable: they can only be set once during
226      * construction.
227      */
228     constructor(string memory name_, string memory symbol_) {
229         _name = name_;
230         _symbol = symbol_;
231     }
232 
233     /**
234      * @dev Returns the name of the token.
235      */
236     function name() public view virtual override returns (string memory) {
237         return _name;
238     }
239 
240     /**
241      * @dev Returns the symbol of the token, usually a shorter version of the
242      * name.
243      */
244     function symbol() public view virtual override returns (string memory) {
245         return _symbol;
246     }
247 
248     /**
249      * @dev Returns the number of decimals used to get its user representation.
250      * For example, if `decimals` equals `2`, a balance of `505` tokens should
251      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
252      *
253      * Tokens usually opt for a value of 18, imitating the relationship between
254      * Ether and Wei. This is the value {ERC20} uses, unless this function is
255      * overridden;
256      *
257      * NOTE: This information is only used for _display_ purposes: it in
258      * no way affects any of the arithmetic of the contract, including
259      * {IERC20-balanceOf} and {IERC20-transfer}.
260      */
261     function decimals() public view virtual override returns (uint8) {
262         return 18;
263     }
264 
265     /**
266      * @dev See {IERC20-totalSupply}.
267      */
268     function totalSupply() public view virtual override returns (uint256) {
269         return _totalSupply;
270     }
271 
272     /**
273      * @dev See {IERC20-balanceOf}.
274      */
275     function balanceOf(address account) public view virtual override returns (uint256) {
276         return _balances[account];
277     }
278 
279     /**
280      * @dev See {IERC20-transfer}.
281      *
282      * Requirements:
283      *
284      * - `recipient` cannot be the zero address.
285      * - the caller must have a balance of at least `amount`.
286      */
287     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
288         _transfer(_msgSender(), recipient, amount);
289         return true;
290     }
291 
292     /**
293      * @dev See {IERC20-allowance}.
294      */
295     function allowance(address owner, address spender) public view virtual override returns (uint256) {
296         return _allowances[owner][spender];
297     }
298 
299     /**
300      * @dev See {IERC20-approve}.
301      *
302      * Requirements:
303      *
304      * - `spender` cannot be the zero address.
305      */
306     function approve(address spender, uint256 amount) public virtual override returns (bool) {
307         _approve(_msgSender(), spender, amount);
308         return true;
309     }
310 
311     /**
312      * @dev See {IERC20-transferFrom}.
313      *
314      * Emits an {Approval} event indicating the updated allowance. This is not
315      * required by the EIP. See the note at the beginning of {ERC20}.
316      *
317      * Requirements:
318      *
319      * - `sender` and `recipient` cannot be the zero address.
320      * - `sender` must have a balance of at least `amount`.
321      * - the caller must have allowance for ``sender``'s tokens of at least
322      * `amount`.
323      */
324     function transferFrom(
325         address sender,
326         address recipient,
327         uint256 amount
328     ) public virtual override returns (bool) {
329         _transfer(sender, recipient, amount);
330         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
331         return true;
332     }
333 
334     /**
335      * @dev Atomically increases the allowance granted to `spender` by the caller.
336      *
337      * This is an alternative to {approve} that can be used as a mitigation for
338      * problems described in {IERC20-approve}.
339      *
340      * Emits an {Approval} event indicating the updated allowance.
341      *
342      * Requirements:
343      *
344      * - `spender` cannot be the zero address.
345      */
346     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
347         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
348         return true;
349     }
350 
351     /**
352      * @dev Atomically decreases the allowance granted to `spender` by the caller.
353      *
354      * This is an alternative to {approve} that can be used as a mitigation for
355      * problems described in {IERC20-approve}.
356      *
357      * Emits an {Approval} event indicating the updated allowance.
358      *
359      * Requirements:
360      *
361      * - `spender` cannot be the zero address.
362      * - `spender` must have allowance for the caller of at least
363      * `subtractedValue`.
364      */
365     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
366         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
367         return true;
368     }
369 
370     /**
371      * @dev Moves tokens `amount` from `sender` to `recipient`.
372      *
373      * This is internal function is equivalent to {transfer}, and can be used to
374      * e.g. implement automatic token fees, slashing mechanisms, etc.
375      *
376      * Emits a {Transfer} event.
377      *
378      * Requirements:
379      *
380      * - `sender` cannot be the zero address.
381      * - `recipient` cannot be the zero address.
382      * - `sender` must have a balance of at least `amount`.
383      */
384     function _transfer(
385         address sender,
386         address recipient,
387         uint256 amount
388     ) internal virtual {
389         require(sender != address(0), "ERC20: transfer from the zero address");
390         require(recipient != address(0), "ERC20: transfer to the zero address");
391 
392         _beforeTokenTransfer(sender, recipient, amount);
393 
394         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
395         _balances[recipient] = _balances[recipient].add(amount);
396         emit Transfer(sender, recipient, amount);
397     }
398 
399     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
400      * the total supply.
401      *
402      * Emits a {Transfer} event with `from` set to the zero address.
403      *
404      * Requirements:
405      *
406      * - `account` cannot be the zero address.
407      */
408     function _mint(address account, uint256 amount) internal virtual {
409         require(account != address(0), "ERC20: mint to the zero address");
410 
411         _beforeTokenTransfer(address(0), account, amount);
412 
413         _totalSupply = _totalSupply.add(amount);
414         _balances[account] = _balances[account].add(amount);
415         emit Transfer(address(0), account, amount);
416     }
417 
418     /**
419      * @dev Destroys `amount` tokens from `account`, reducing the
420      * total supply.
421      *
422      * Emits a {Transfer} event with `to` set to the zero address.
423      *
424      * Requirements:
425      *
426      * - `account` cannot be the zero address.
427      * - `account` must have at least `amount` tokens.
428      */
429     function _burn(address account, uint256 amount) internal virtual {
430         require(account != address(0), "ERC20: burn from the zero address");
431 
432         _beforeTokenTransfer(account, address(0), amount);
433 
434         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
435         _totalSupply = _totalSupply.sub(amount);
436         emit Transfer(account, address(0), amount);
437     }
438 
439     /**
440      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
441      *
442      * This internal function is equivalent to `approve`, and can be used to
443      * e.g. set automatic allowances for certain subsystems, etc.
444      *
445      * Emits an {Approval} event.
446      *
447      * Requirements:
448      *
449      * - `owner` cannot be the zero address.
450      * - `spender` cannot be the zero address.
451      */
452     function _approve(
453         address owner,
454         address spender,
455         uint256 amount
456     ) internal virtual {
457         require(owner != address(0), "ERC20: approve from the zero address");
458         require(spender != address(0), "ERC20: approve to the zero address");
459 
460         _allowances[owner][spender] = amount;
461         emit Approval(owner, spender, amount);
462     }
463 
464     /**
465      * @dev Hook that is called before any transfer of tokens. This includes
466      * minting and burning.
467      *
468      * Calling conditions:
469      *
470      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
471      * will be to transferred to `to`.
472      * - when `from` is zero, `amount` tokens will be minted for `to`.
473      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
474      * - `from` and `to` are never both zero.
475      *
476      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
477      */
478     function _beforeTokenTransfer(
479         address from,
480         address to,
481         uint256 amount
482     ) internal virtual {}
483 }
484 
485 library SafeMath {
486     /**
487      * @dev Returns the addition of two unsigned integers, reverting on
488      * overflow.
489      *
490      * Counterpart to Solidity's `+` operator.
491      *
492      * Requirements:
493      *
494      * - Addition cannot overflow.
495      */
496     function add(uint256 a, uint256 b) internal pure returns (uint256) {
497         uint256 c = a + b;
498         require(c >= a, "SafeMath: addition overflow");
499 
500         return c;
501     }
502 
503     /**
504      * @dev Returns the subtraction of two unsigned integers, reverting on
505      * overflow (when the result is negative).
506      *
507      * Counterpart to Solidity's `-` operator.
508      *
509      * Requirements:
510      *
511      * - Subtraction cannot overflow.
512      */
513     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
514         return sub(a, b, "SafeMath: subtraction overflow");
515     }
516 
517     /**
518      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
519      * overflow (when the result is negative).
520      *
521      * Counterpart to Solidity's `-` operator.
522      *
523      * Requirements:
524      *
525      * - Subtraction cannot overflow.
526      */
527     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
528         require(b <= a, errorMessage);
529         uint256 c = a - b;
530 
531         return c;
532     }
533 
534     /**
535      * @dev Returns the multiplication of two unsigned integers, reverting on
536      * overflow.
537      *
538      * Counterpart to Solidity's `*` operator.
539      *
540      * Requirements:
541      *
542      * - Multiplication cannot overflow.
543      */
544     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
545         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
546         // benefit is lost if 'b' is also tested.
547         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
548         if (a == 0) {
549             return 0;
550         }
551 
552         uint256 c = a * b;
553         require(c / a == b, "SafeMath: multiplication overflow");
554 
555         return c;
556     }
557 
558     /**
559      * @dev Returns the integer division of two unsigned integers. Reverts on
560      * division by zero. The result is rounded towards zero.
561      *
562      * Counterpart to Solidity's `/` operator. Note: this function uses a
563      * `revert` opcode (which leaves remaining gas untouched) while Solidity
564      * uses an invalid opcode to revert (consuming all remaining gas).
565      *
566      * Requirements:
567      *
568      * - The divisor cannot be zero.
569      */
570     function div(uint256 a, uint256 b) internal pure returns (uint256) {
571         return div(a, b, "SafeMath: division by zero");
572     }
573 
574     /**
575      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
576      * division by zero. The result is rounded towards zero.
577      *
578      * Counterpart to Solidity's `/` operator. Note: this function uses a
579      * `revert` opcode (which leaves remaining gas untouched) while Solidity
580      * uses an invalid opcode to revert (consuming all remaining gas).
581      *
582      * Requirements:
583      *
584      * - The divisor cannot be zero.
585      */
586     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
587         require(b > 0, errorMessage);
588         uint256 c = a / b;
589         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
590 
591         return c;
592     }
593 
594     /**
595      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
596      * Reverts when dividing by zero.
597      *
598      * Counterpart to Solidity's `%` operator. This function uses a `revert`
599      * opcode (which leaves remaining gas untouched) while Solidity uses an
600      * invalid opcode to revert (consuming all remaining gas).
601      *
602      * Requirements:
603      *
604      * - The divisor cannot be zero.
605      */
606     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
607         return mod(a, b, "SafeMath: modulo by zero");
608     }
609 
610     /**
611      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
612      * Reverts with custom message when dividing by zero.
613      *
614      * Counterpart to Solidity's `%` operator. This function uses a `revert`
615      * opcode (which leaves remaining gas untouched) while Solidity uses an
616      * invalid opcode to revert (consuming all remaining gas).
617      *
618      * Requirements:
619      *
620      * - The divisor cannot be zero.
621      */
622     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
623         require(b != 0, errorMessage);
624         return a % b;
625     }
626 }
627 
628 contract Ownable is Context {
629     address private _owner;
630 
631     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
632     
633     /**
634      * @dev Initializes the contract setting the deployer as the initial owner.
635      */
636     constructor () {
637         address msgSender = _msgSender();
638         _owner = msgSender;
639         emit OwnershipTransferred(address(0), msgSender);
640     }
641 
642     /**
643      * @dev Returns the address of the current owner.
644      */
645     function owner() public view returns (address) {
646         return _owner;
647     }
648 
649     /**
650      * @dev Throws if called by any account other than the owner.
651      */
652     modifier onlyOwner() {
653         require(_owner == _msgSender(), "Ownable: caller is not the owner");
654         _;
655     }
656 
657     /**
658      * @dev Leaves the contract without owner. It will not be possible to call
659      * `onlyOwner` functions anymore. Can only be called by the current owner.
660      *
661      * NOTE: Renouncing ownership will leave the contract without an owner,
662      * thereby removing any functionality that is only available to the owner.
663      */
664     function renounceOwnership() public virtual onlyOwner {
665         emit OwnershipTransferred(_owner, address(0));
666         _owner = address(0);
667     }
668 
669     /**
670      * @dev Transfers ownership of the contract to a new account (`newOwner`).
671      * Can only be called by the current owner.
672      */
673     function transferOwnership(address newOwner) public virtual onlyOwner {
674         require(newOwner != address(0), "Ownable: new owner is the zero address");
675         emit OwnershipTransferred(_owner, newOwner);
676         _owner = newOwner;
677     }
678 }
679 
680 library SafeMathInt {
681     int256 private constant MIN_INT256 = int256(1) << 255;
682     int256 private constant MAX_INT256 = ~(int256(1) << 255);
683 
684     /**
685      * @dev Multiplies two int256 variables and fails on overflow.
686      */
687     function mul(int256 a, int256 b) internal pure returns (int256) {
688         int256 c = a * b;
689 
690         // Detect overflow when multiplying MIN_INT256 with -1
691         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
692         require((b == 0) || (c / b == a));
693         return c;
694     }
695 
696     /**
697      * @dev Division of two int256 variables and fails on overflow.
698      */
699     function div(int256 a, int256 b) internal pure returns (int256) {
700         // Prevent overflow when dividing MIN_INT256 by -1
701         require(b != -1 || a != MIN_INT256);
702 
703         // Solidity already throws when dividing by 0.
704         return a / b;
705     }
706 
707     /**
708      * @dev Subtracts two int256 variables and fails on overflow.
709      */
710     function sub(int256 a, int256 b) internal pure returns (int256) {
711         int256 c = a - b;
712         require((b >= 0 && c <= a) || (b < 0 && c > a));
713         return c;
714     }
715 
716     /**
717      * @dev Adds two int256 variables and fails on overflow.
718      */
719     function add(int256 a, int256 b) internal pure returns (int256) {
720         int256 c = a + b;
721         require((b >= 0 && c >= a) || (b < 0 && c < a));
722         return c;
723     }
724 
725     /**
726      * @dev Converts to absolute value, and fails on overflow.
727      */
728     function abs(int256 a) internal pure returns (int256) {
729         require(a != MIN_INT256);
730         return a < 0 ? -a : a;
731     }
732 
733 
734     function toUint256Safe(int256 a) internal pure returns (uint256) {
735         require(a >= 0);
736         return uint256(a);
737     }
738 }
739 
740 library SafeMathUint {
741   function toInt256Safe(uint256 a) internal pure returns (int256) {
742     int256 b = int256(a);
743     require(b >= 0);
744     return b;
745   }
746 }
747 
748 
749 interface IUniswapV2Router01 {
750     function factory() external pure returns (address);
751     function WETH() external pure returns (address);
752 
753     function addLiquidity(
754         address tokenA,
755         address tokenB,
756         uint amountADesired,
757         uint amountBDesired,
758         uint amountAMin,
759         uint amountBMin,
760         address to,
761         uint deadline
762     ) external returns (uint amountA, uint amountB, uint liquidity);
763     function addLiquidityETH(
764         address token,
765         uint amountTokenDesired,
766         uint amountTokenMin,
767         uint amountETHMin,
768         address to,
769         uint deadline
770     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
771     function removeLiquidity(
772         address tokenA,
773         address tokenB,
774         uint liquidity,
775         uint amountAMin,
776         uint amountBMin,
777         address to,
778         uint deadline
779     ) external returns (uint amountA, uint amountB);
780     function removeLiquidityETH(
781         address token,
782         uint liquidity,
783         uint amountTokenMin,
784         uint amountETHMin,
785         address to,
786         uint deadline
787     ) external returns (uint amountToken, uint amountETH);
788     function removeLiquidityWithPermit(
789         address tokenA,
790         address tokenB,
791         uint liquidity,
792         uint amountAMin,
793         uint amountBMin,
794         address to,
795         uint deadline,
796         bool approveMax, uint8 v, bytes32 r, bytes32 s
797     ) external returns (uint amountA, uint amountB);
798     function removeLiquidityETHWithPermit(
799         address token,
800         uint liquidity,
801         uint amountTokenMin,
802         uint amountETHMin,
803         address to,
804         uint deadline,
805         bool approveMax, uint8 v, bytes32 r, bytes32 s
806     ) external returns (uint amountToken, uint amountETH);
807     function swapExactTokensForTokens(
808         uint amountIn,
809         uint amountOutMin,
810         address[] calldata path,
811         address to,
812         uint deadline
813     ) external returns (uint[] memory amounts);
814     function swapTokensForExactTokens(
815         uint amountOut,
816         uint amountInMax,
817         address[] calldata path,
818         address to,
819         uint deadline
820     ) external returns (uint[] memory amounts);
821     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
822         external
823         payable
824         returns (uint[] memory amounts);
825     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
826         external
827         returns (uint[] memory amounts);
828     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
829         external
830         returns (uint[] memory amounts);
831     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
832         external
833         payable
834         returns (uint[] memory amounts);
835 
836     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
837     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
838     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
839     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
840     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
841 }
842 
843 interface IUniswapV2Router02 is IUniswapV2Router01 {
844     function removeLiquidityETHSupportingFeeOnTransferTokens(
845         address token,
846         uint liquidity,
847         uint amountTokenMin,
848         uint amountETHMin,
849         address to,
850         uint deadline
851     ) external returns (uint amountETH);
852     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
853         address token,
854         uint liquidity,
855         uint amountTokenMin,
856         uint amountETHMin,
857         address to,
858         uint deadline,
859         bool approveMax, uint8 v, bytes32 r, bytes32 s
860     ) external returns (uint amountETH);
861 
862     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
863         uint amountIn,
864         uint amountOutMin,
865         address[] calldata path,
866         address to,
867         uint deadline
868     ) external;
869     function swapExactETHForTokensSupportingFeeOnTransferTokens(
870         uint amountOutMin,
871         address[] calldata path,
872         address to,
873         uint deadline
874     ) external payable;
875     function swapExactTokensForETHSupportingFeeOnTransferTokens(
876         uint amountIn,
877         uint amountOutMin,
878         address[] calldata path,
879         address to,
880         uint deadline
881     ) external;
882 }
883 
884 contract GUPPI is ERC20, Ownable {
885     using SafeMath for uint256;
886 
887     IUniswapV2Router02 public immutable uniswapV2Router;
888     address public immutable uniswapV2Pair;
889     address public constant deadAddress = address(0xdead);
890 
891     bool private swapping;
892 
893     address public stakingWallet;
894     address public devWallet;
895     
896     uint256 public maxTransactionAmount;
897     uint256 public swapTokensAtAmount;
898     uint256 public maxWallet;
899     
900     uint256 public manualBurnFrequency = 30 minutes;
901     uint256 public lastManualLpBurnTime;
902 
903     bool public limitsInEffect = true;
904     bool public tradingActive = false;
905     bool public swapEnabled = false;
906     
907     // Anti-MEV mappings and variables
908     mapping(address => uint256) private _holderLastTransferTimestamp;
909     bool public transferDelayEnabled = true;
910 
911     uint256 public buyTotalFees;
912     uint256 public buyStakingFee;
913     uint256 public buyLiquidityFee;
914     uint256 public buyDevFee;
915     
916     uint256 public sellTotalFees;
917     uint256 public sellStakingFee;
918     uint256 public sellLiquidityFee;
919     uint256 public sellDevFee;
920     
921     uint256 public tokensForStaking;
922     uint256 public tokensForLiquidity;
923     uint256 public tokensForDev;
924     
925     /******************/
926 
927     // exlcude from fees and max transaction amount
928     mapping (address => bool) private _isExcludedFromFees;
929     mapping (address => bool) public _isExcludedMaxTransactionAmount;
930     mapping (address => bool) public automatedMarketMakerPairs;
931     event UpdateUniswapV2Router(address indexed newAddress, address indexed oldAddress);
932     event ExcludeFromFees(address indexed account, bool isExcluded);
933     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
934     event stakingWalletUpdated(address indexed newWallet, address indexed oldWallet);
935     event devWalletUpdated(address indexed newWallet, address indexed oldWallet);
936 
937     event SwapAndLiquify(
938         uint256 tokensSwapped,
939         uint256 ethReceived,
940         uint256 tokensIntoLiquidity
941     );
942     
943     event ManualBurn();
944 
945     constructor() ERC20("GUPPI", "GUPPI") {
946         
947         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
948         
949         excludeFromMaxTransaction(address(_uniswapV2Router), true);
950         uniswapV2Router = _uniswapV2Router;
951         
952         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
953         excludeFromMaxTransaction(address(uniswapV2Pair), true);
954         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
955         
956         uint256 _buyStakingFee = 1;
957         uint256 _buyLiquidityFee = 1;
958         uint256 _buyDevFee = 4;
959 
960         uint256 _sellStakingFee = 0;
961         uint256 _sellLiquidityFee = 0;
962         uint256 _sellDevFee = 6;
963         
964         uint256 totalSupply = 1 * 1e9 * 1e18;
965         
966         maxTransactionAmount = totalSupply * 10 / 1000; // 1% maxTX limit
967         maxWallet = totalSupply * 20 / 1000; // 2% maxWallet limit
968         swapTokensAtAmount = totalSupply * 5 / 10000;
969 
970         buyStakingFee = _buyStakingFee;
971         buyLiquidityFee = _buyLiquidityFee;
972         buyDevFee = _buyDevFee;
973         buyTotalFees = buyStakingFee + buyLiquidityFee + buyDevFee;
974         
975         sellStakingFee = _sellStakingFee;
976         sellLiquidityFee = _sellLiquidityFee;
977         sellDevFee = _sellDevFee;
978         sellTotalFees = sellStakingFee + sellLiquidityFee + sellDevFee;
979         
980         stakingWallet = address(owner()); // set as staking revshare wallet
981         devWallet = address(owner()); // set as dev wallet
982 
983         // exclude from paying fees or having max transaction amount
984         excludeFromFees(owner(), true);
985         excludeFromFees(address(this), true);
986         excludeFromFees(address(0xdead), true);
987         
988         excludeFromMaxTransaction(owner(), true);
989         excludeFromMaxTransaction(address(this), true);
990         excludeFromMaxTransaction(address(0xdead), true);
991         
992         /*
993             _mint is an internal function in ERC20.sol that is only called here,
994             and CANNOT be called ever again
995         */
996         _mint(msg.sender, totalSupply);
997     }
998 
999     receive() external payable {
1000 
1001   	}
1002 
1003     // once enabled, can never be turned off
1004     function enableTrading(uint256 _stakingFee, uint256 _liquidityFee, uint256 _devFee, uint256 _stakingFee2, uint256 _liquidityFee2, uint256 _devFee2) external onlyOwner {
1005         buyStakingFee = _stakingFee;
1006         buyLiquidityFee = _liquidityFee;
1007         buyDevFee = _devFee;
1008         buyTotalFees = buyStakingFee + buyLiquidityFee + buyDevFee;
1009         sellStakingFee = _stakingFee2;
1010         sellLiquidityFee = _liquidityFee2;
1011         sellDevFee = _devFee2;
1012         sellTotalFees = sellStakingFee + sellLiquidityFee + sellDevFee;
1013         tradingActive = true;
1014         swapEnabled = true;
1015     }
1016     
1017     // remove TX and maxWallet limits after token is stable
1018     function removeLimits() external onlyOwner returns (bool){
1019         limitsInEffect = false;
1020         return true;
1021     }
1022     
1023     // disable Transfer delay - Anti-MEV
1024     function disableTransferDelay() external onlyOwner returns (bool){
1025         transferDelayEnabled = false;
1026         return true;
1027     }
1028     
1029      // change the minimum amount of tokens to sell from fees
1030     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner returns (bool){
1031   	    require(newAmount >= totalSupply() * 1 / 100000, "Swap amount cannot be lower than 0.001% total supply.");
1032   	    require(newAmount <= totalSupply() * 5 / 1000, "Swap amount cannot be higher than 0.5% total supply.");
1033   	    swapTokensAtAmount = newAmount;
1034   	    return true;
1035   	}
1036     
1037     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
1038         require(newNum >= (totalSupply() * 1 / 1000)/1e18, "Cannot set maxTransactionAmount lower than 0.1%");
1039         maxTransactionAmount = newNum * (10**18);
1040     }
1041 
1042     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
1043         require(newNum >= (totalSupply() * 5 / 1000)/1e18, "Cannot set maxWallet lower than 0.5%");
1044         maxWallet = newNum * (10**18);
1045     }
1046     
1047     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
1048         _isExcludedMaxTransactionAmount[updAds] = isEx;
1049     }
1050     
1051     function updateBuyFees(uint256 _stakingFee, uint256 _liquidityFee, uint256 _devFee) external onlyOwner {
1052         buyStakingFee = _stakingFee;
1053         buyLiquidityFee = _liquidityFee;
1054         buyDevFee = _devFee;
1055         buyTotalFees = buyStakingFee + buyLiquidityFee + buyDevFee;
1056         require(buyTotalFees <= 6, "Must keep fees at 6% or less");
1057     }
1058     
1059     function updateSellFees(uint256 _stakingFee, uint256 _liquidityFee, uint256 _devFee) external onlyOwner {
1060         sellStakingFee = _stakingFee;
1061         sellLiquidityFee = _liquidityFee;
1062         sellDevFee = _devFee;
1063         sellTotalFees = sellStakingFee + sellLiquidityFee + sellDevFee;
1064         require(sellTotalFees <= 12, "Must keep fees at 12% or less");
1065     }
1066 
1067     function excludeFromFees(address account, bool excluded) public onlyOwner {
1068         _isExcludedFromFees[account] = excluded;
1069         emit ExcludeFromFees(account, excluded);
1070     }
1071 
1072     function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
1073         require(pair != uniswapV2Pair, "The pair cannot be removed from automatedMarketMakerPairs");
1074 
1075         _setAutomatedMarketMakerPair(pair, value);
1076     }
1077 
1078     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1079         automatedMarketMakerPairs[pair] = value;
1080 
1081         emit SetAutomatedMarketMakerPair(pair, value);
1082     }
1083 
1084     function updateStakingWallet(address newStakingWallet) external onlyOwner {
1085         emit stakingWalletUpdated(newStakingWallet, stakingWallet);
1086         stakingWallet = newStakingWallet;
1087     }
1088     
1089     function updateDevWallet(address newWallet) external onlyOwner {
1090         emit devWalletUpdated(newWallet, devWallet);
1091         devWallet = newWallet;
1092     }
1093 
1094     function isExcludedFromFees(address account) public view returns(bool) {
1095         return _isExcludedFromFees[account];
1096     }
1097 
1098     function _transfer(
1099         address from,
1100         address to,
1101         uint256 amount
1102     ) internal override {
1103         require(from != address(0), "ERC20: transfer from the zero address");
1104         require(to != address(0), "ERC20: transfer to the zero address");
1105         
1106          if(amount == 0) {
1107             super._transfer(from, to, 0);
1108             return;
1109         }
1110         
1111         if(limitsInEffect){
1112             if (
1113                 from != owner() &&
1114                 to != owner() &&
1115                 to != address(0) &&
1116                 to != address(0xdead) &&
1117                 !swapping
1118             ){
1119                 if(!tradingActive){
1120                     require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");
1121                 }
1122 
1123                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.  
1124                 if (transferDelayEnabled){
1125                     if (to != owner() && to != address(uniswapV2Router) && to != address(uniswapV2Pair)){
1126                         require(_holderLastTransferTimestamp[tx.origin] < block.number, "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed.");
1127                         _holderLastTransferTimestamp[tx.origin] = block.number;
1128                     }
1129                 }
1130                  
1131                 //when buy
1132                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
1133                         require(amount <= maxTransactionAmount, "Buy transfer amount exceeds the maxTransactionAmount.");
1134                         require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
1135                 }
1136                 
1137                 //when sell
1138                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
1139                         require(amount <= maxTransactionAmount, "Sell transfer amount exceeds the maxTransactionAmount.");
1140                 }
1141                 else if(!_isExcludedMaxTransactionAmount[to]){
1142                     require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
1143                 }
1144             }
1145         }
1146         
1147         
1148 		uint256 contractTokenBalance = balanceOf(address(this));
1149         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1150 
1151         if( 
1152             canSwap &&
1153             swapEnabled &&
1154             !swapping &&
1155             !automatedMarketMakerPairs[from] &&
1156             !_isExcludedFromFees[from] &&
1157             !_isExcludedFromFees[to]
1158         ) {
1159             swapping = true;
1160             swapBack();
1161             swapping = false;
1162         }
1163 
1164         bool takeFee = !swapping;
1165 
1166         // if any account belongs to _isExcludedFromFee account then remove the fee
1167         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1168             takeFee = false;
1169         }
1170         
1171         uint256 fees = 0;
1172         // only take fees on buys/sells, do not take on wallet transfers
1173         if(takeFee){
1174             // on sell
1175             if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
1176                 fees = amount.mul(sellTotalFees).div(100);
1177                 tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
1178                 tokensForDev += fees * sellDevFee / sellTotalFees;
1179                 tokensForStaking += fees * sellStakingFee / sellTotalFees;
1180             }
1181             // on buy
1182             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1183         	    fees = amount.mul(buyTotalFees).div(100);
1184         	    tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
1185                 tokensForDev += fees * buyDevFee / buyTotalFees;
1186                 tokensForStaking += fees * buyStakingFee / buyTotalFees;
1187             }
1188             
1189             if(fees > 0){    
1190                 super._transfer(from, address(this), fees);
1191             }
1192         	
1193         	amount -= fees;
1194         }
1195 
1196         super._transfer(from, to, amount);
1197     }
1198 
1199     function swapTokensForEth(uint256 tokenAmount) private {
1200 
1201         // generate the uniswap pair path of token -> weth
1202         address[] memory path = new address[](2);
1203         path[0] = address(this);
1204         path[1] = uniswapV2Router.WETH();
1205 
1206         _approve(address(this), address(uniswapV2Router), tokenAmount);
1207 
1208         // make the swap
1209         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1210             tokenAmount,
1211             0, // accept any amount of ETH
1212             path,
1213             address(this),
1214             block.timestamp
1215         );
1216         
1217     }
1218     
1219     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1220         // approve token transfer to cover all possible scenarios
1221         _approve(address(this), address(uniswapV2Router), tokenAmount);
1222 
1223         // add the liquidity
1224         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1225             address(this),
1226             tokenAmount,
1227             0, // slippage is unavoidable
1228             0, // slippage is unavoidable
1229             deadAddress,
1230             block.timestamp
1231         );
1232     }
1233 
1234     function swapBack() private {
1235         uint256 contractBalance = balanceOf(address(this));
1236         uint256 totalTokensToSwap = tokensForLiquidity + tokensForStaking + tokensForDev;
1237         bool success;
1238         
1239         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
1240 
1241         if(contractBalance > swapTokensAtAmount * 20){
1242           contractBalance = swapTokensAtAmount * 20;
1243         }
1244         
1245         // Halve the amount of liquidity tokens
1246         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
1247         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1248         uint256 initialETHBalance = address(this).balance;
1249         swapTokensForEth(amountToSwapForETH); 
1250         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1251         uint256 ethForMarketing = ethBalance.mul(tokensForStaking).div(totalTokensToSwap);
1252         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
1253         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev;
1254 
1255         tokensForLiquidity = 0;
1256         tokensForStaking = 0;
1257         tokensForDev = 0;
1258         
1259         (success,) = address(devWallet).call{value: ethForDev}("");
1260         
1261         if(liquidityTokens > 0 && ethForLiquidity > 0){
1262             addLiquidity(liquidityTokens, ethForLiquidity);
1263             emit SwapAndLiquify(amountToSwapForETH, ethForLiquidity, tokensForLiquidity);
1264         }
1265         
1266         (success,) = address(stakingWallet).call{value: address(this).balance}("");
1267     }
1268 
1269     function manualTokenBurn(uint256 percent) external onlyOwner returns (bool){
1270         require(block.timestamp > lastManualLpBurnTime + manualBurnFrequency , "Still on Cooldown!");
1271         require(percent <= 200, "Cannot burn more than 2% of LP tokens at a time!");
1272         lastManualLpBurnTime = block.timestamp;
1273         
1274         // get balance of liquidity pair
1275         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1276         
1277         // calculate amount to burn
1278         uint256 amountToBurn = liquidityPairBalance.mul(percent).div(10000);
1279         
1280         // pull tokens from pancakePair liquidity and move to dead address permanently
1281         if (amountToBurn > 0){
1282             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1283         }
1284         
1285         //sync price since this is not in a swap transaction!
1286         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1287         pair.sync();
1288         emit ManualBurn();
1289         return true;
1290     }
1291 }