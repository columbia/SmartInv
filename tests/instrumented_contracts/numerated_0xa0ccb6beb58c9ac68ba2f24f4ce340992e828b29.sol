1 /*
2   _   _____  _   _  _____   ___   _____     __                          
3  | | /  __ \| | | ||_   _| / _ \ |  _  |   / _|                         
4 / __)| /  \/| |_| |  | |  / /_\ \| | | |  | |_   ___   _ __   ___   ___ 
5 \__ \| |    |  _  |  | |  |  _  || | | |  |  _| / _ \ | '__| / __| / _ \
6 (   /| \__/\| | | | _| |_ | | | |\ \_/ /  | |  | (_) || |   | (__ |  __/
7  |_|  \____/\_| |_/ \___/ \_| |_/ \___/   |_|   \___/ |_|    \___| \___|
8 
9 Perhaps the most proper and popular smart contract ever written.
10 
11     WEBSITE:
12 https://www.chiao.io/
13 
14     WHITEPAPER:
15 https://www.chiao.io/whitepaper
16 
17     CertiK AUDIT:
18 https://www.certik.com/projects/chiaotzu-inu
19 Unlike most projects, Chiaotzu Inu will be audited BEFORE LAUNCH!
20 We do this to ensure your investment is as safe and secure as possible.
21 
22     MAIN TELEGRAM (English):
23 https://t.me/chiaotoken
24 
25     DISCORD:
26 https://discord.io/CHIAO
27 
28     TWITTER:
29 https://twitter.com/chiaotoken
30 
31     REDDIT:
32 https://www.reddit.com/r/chiaotoken/
33 
34     MEDIUM:
35 https://chiaotzutoken.medium.com/
36 
37     INSTAGRAM:
38 https://www.instagram.com/chiaotzuinu/
39 
40     FACEBOOK:
41 https://www.facebook.com/ChiaotzuInuToken
42 
43     SLIPPAGE:
44 Set your slippage to 50% on Uniswap to avoid failed transactions and any other problems.
45 Chiaotzu Inu uses advanced anti-bot scripting which makes front-running impossible for bots,
46 even with such high slippage.  
47 
48     TOKEN FEE STRUCTURE:
49 ABSOLUTELY NO FEE OR TAX ON REGULAR SEND / RECEIVE TRANSACTIONS! 
50 Chiaotzu Inu only charges taxes on Buy and Sell Transactions!
51         ON BUY 14%
52 —10% Marketing | —2% Auto LP | —1% Reflections | —1% Development
53 
54         ON SELL 16%
55 —10% Marketing | —2% Auto LP | —2% Reflections | —2% Development
56 
57         ON EARLY SELL 30% (24 HOURS FROM THE FIRST AND ONLY THE FIRST BUY PER WALLET):
58 —24% Marketing | —2% Auto LP | —2% Reflections | —2% Development
59 Chiaotzu Inu will charge taxes on send / receive transactions during the early sell period.
60 
61     TOKEN DEFAULT THRESHOLDS:
62 Max Buy & Sell Limit: 0.5%
63 Max Wallet Size: 2%
64 
65     DISTRIBUTION:
66 —75% Tradable Liquidity | 20% EVM Bridges (BSC, FTM, etc...) | 5% CEX (Binance, OKEx, Bitmart & many many more)
67 
68     LOCKED LIQUIDITY:
69 As you can see, Chiaotzu Inu is very transparent and will honor this
70 transparency by locking 100% of the tradable liquidity on Unicrypt for
71 1 year before trading is actually opened up to the public. This will
72 give $CHIAO investors an undeniable and unmatched trust score. Safely 
73 invest with total confidence knowing you can believe in your Chiao Force!
74 
75 Chiao Force may also lock the Project tokens in anticipation of
76 Bridging and CEX listings before Open trading to ensure a trusted
77 environment is made suitable for early adoption of the platform.
78 
79     ZERO-BOT TOLERANCE:
80 For the first 5 blocks after Chiaotzu Inu opens trading on mainnet,
81 all wallets who buy during this time will be blacklisted and unable
82 to sell their tokens. If a normal user who is not a bot buys during
83 this time, they may request to be unblacklisted at chiao.io/whitelist
84 and may be granted the ability to sell their tokens again if Chiao
85 Force sees them fit.
86 
87     AUTOMATED LIQUIDITY TOKEN BURNS:
88 $CHIAO's floor is literally guaranteed to increase forever. Chiaotzu Inu's
89 smart contract automatically burns LP tokens at a rate of 0.25% per hour,
90 this rate may also be increased and never decreased, which will raise the
91 value of all holders at a much faster rate!
92 
93 */
94 
95 // SPDX-License-Identifier: MIT                                                                               
96                                                     
97 pragma solidity 0.8.9;
98 
99 abstract contract Context {
100     function _msgSender() internal view virtual returns (address) {
101         return msg.sender;
102     }
103 
104     function _msgData() internal view virtual returns (bytes calldata) {
105         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
106         return msg.data;
107     }
108 }
109 
110 interface IUniswapV2Pair {
111     event Approval(address indexed owner, address indexed spender, uint value);
112     event Transfer(address indexed from, address indexed to, uint value);
113 
114     function name() external pure returns (string memory);
115     function symbol() external pure returns (string memory);
116     function decimals() external pure returns (uint8);
117     function totalSupply() external view returns (uint);
118     function balanceOf(address owner) external view returns (uint);
119     function allowance(address owner, address spender) external view returns (uint);
120 
121     function approve(address spender, uint value) external returns (bool);
122     function transfer(address to, uint value) external returns (bool);
123     function transferFrom(address from, address to, uint value) external returns (bool);
124 
125     function DOMAIN_SEPARATOR() external view returns (bytes32);
126     function PERMIT_TYPEHASH() external pure returns (bytes32);
127     function nonces(address owner) external view returns (uint);
128 
129     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
130 
131     event Mint(address indexed sender, uint amount0, uint amount1);
132     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
133     event Swap(
134         address indexed sender,
135         uint amount0In,
136         uint amount1In,
137         uint amount0Out,
138         uint amount1Out,
139         address indexed to
140     );
141     event Sync(uint112 reserve0, uint112 reserve1);
142 
143     function MINIMUM_LIQUIDITY() external pure returns (uint);
144     function factory() external view returns (address);
145     function token0() external view returns (address);
146     function token1() external view returns (address);
147     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
148     function price0CumulativeLast() external view returns (uint);
149     function price1CumulativeLast() external view returns (uint);
150     function kLast() external view returns (uint);
151 
152     function mint(address to) external returns (uint liquidity);
153     function burn(address to) external returns (uint amount0, uint amount1);
154     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
155     function skim(address to) external;
156     function sync() external;
157 
158     function initialize(address, address) external;
159 }
160 
161 interface IUniswapV2Factory {
162     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
163 
164     function feeTo() external view returns (address);
165     function feeToSetter() external view returns (address);
166 
167     function getPair(address tokenA, address tokenB) external view returns (address pair);
168     function allPairs(uint) external view returns (address pair);
169     function allPairsLength() external view returns (uint);
170 
171     function createPair(address tokenA, address tokenB) external returns (address pair);
172 
173     function setFeeTo(address) external;
174     function setFeeToSetter(address) external;
175 }
176 
177 interface IERC20 {
178     /**
179      * @dev Returns the amount of tokens in existence.
180      */
181     function totalSupply() external view returns (uint256);
182 
183     /**
184      * @dev Returns the amount of tokens owned by `account`.
185      */
186     function balanceOf(address account) external view returns (uint256);
187 
188     /**
189      * @dev Moves `amount` tokens from the caller's account to `recipient`.
190      *
191      * Returns a boolean value indicating whether the operation succeeded.
192      *
193      * Emits a {Transfer} event.
194      */
195     function transfer(address recipient, uint256 amount) external returns (bool);
196 
197     /**
198      * @dev Returns the remaining number of tokens that `spender` will be
199      * allowed to spend on behalf of `owner` through {transferFrom}. This is
200      * zero by default.
201      *
202      * This value changes when {approve} or {transferFrom} are called.
203      */
204     function allowance(address owner, address spender) external view returns (uint256);
205 
206     /**
207      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
208      *
209      * Returns a boolean value indicating whether the operation succeeded.
210      *
211      * IMPORTANT: Beware that changing an allowance with this method brings the risk
212      * that someone may use both the old and the new allowance by unfortunate
213      * transaction ordering. One possible solution to mitigate this race
214      * condition is to first reduce the spender's allowance to 0 and set the
215      * desired value afterwards:
216      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
217      *
218      * Emits an {Approval} event.
219      */
220     function approve(address spender, uint256 amount) external returns (bool);
221 
222     /**
223      * @dev Moves `amount` tokens from `sender` to `recipient` using the
224      * allowance mechanism. `amount` is then deducted from the caller's
225      * allowance.
226      *
227      * Returns a boolean value indicating whether the operation succeeded.
228      *
229      * Emits a {Transfer} event.
230      */
231     function transferFrom(
232         address sender,
233         address recipient,
234         uint256 amount
235     ) external returns (bool);
236 
237     /**
238      * @dev Emitted when `value` tokens are moved from one account (`from`) to
239      * another (`to`).
240      *
241      * Note that `value` may be zero.
242      */
243     event Transfer(address indexed from, address indexed to, uint256 value);
244 
245     /**
246      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
247      * a call to {approve}. `value` is the new allowance.
248      */
249     event Approval(address indexed owner, address indexed spender, uint256 value);
250 }
251 
252 interface IERC20Metadata is IERC20 {
253     /**
254      * @dev Returns the name of the token.
255      */
256     function name() external view returns (string memory);
257 
258     /**
259      * @dev Returns the symbol of the token.
260      */
261     function symbol() external view returns (string memory);
262 
263     /**
264      * @dev Returns the decimals places of the token.
265      */
266     function decimals() external view returns (uint8);
267 }
268 
269 
270 contract ERC20 is Context, IERC20, IERC20Metadata {
271     using SafeMath for uint256;
272 
273     mapping(address => uint256) private _balances;
274 
275     mapping(address => mapping(address => uint256)) private _allowances;
276 
277     uint256 private _totalSupply;
278 
279     string private _name;
280     string private _symbol;
281 
282     /**
283      * @dev Sets the values for {name} and {symbol}.
284      *
285      * The default value of {decimals} is 18. To select a different value for
286      * {decimals} you should overload it.
287      *
288      * All two of these values are immutable: they can only be set once during
289      * construction.
290      */
291     constructor(string memory name_, string memory symbol_) {
292         _name = name_;
293         _symbol = symbol_;
294     }
295 
296     /**
297      * @dev Returns the name of the token.
298      */
299     function name() public view virtual override returns (string memory) {
300         return _name;
301     }
302 
303     /**
304      * @dev Returns the symbol of the token, usually a shorter version of the
305      * name.
306      */
307     function symbol() public view virtual override returns (string memory) {
308         return _symbol;
309     }
310 
311     /**
312      * @dev Returns the number of decimals used to get its user representation.
313      * For example, if `decimals` equals `2`, a balance of `505` tokens should
314      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
315      *
316      * Tokens usually opt for a value of 18, imitating the relationship between
317      * Ether and Wei. This is the value {ERC20} uses, unless this function is
318      * overridden;
319      *
320      * NOTE: This information is only used for _display_ purposes: it in
321      * no way affects any of the arithmetic of the contract, including
322      * {IERC20-balanceOf} and {IERC20-transfer}.
323      */
324     function decimals() public view virtual override returns (uint8) {
325         return 18;
326     }
327 
328     /**
329      * @dev See {IERC20-totalSupply}.
330      */
331     function totalSupply() public view virtual override returns (uint256) {
332         return _totalSupply;
333     }
334 
335     /**
336      * @dev See {IERC20-balanceOf}.
337      */
338     function balanceOf(address account) public view virtual override returns (uint256) {
339         return _balances[account];
340     }
341 
342     /**
343      * @dev See {IERC20-transfer}.
344      *
345      * Requirements:
346      *
347      * - `recipient` cannot be the zero address.
348      * - the caller must have a balance of at least `amount`.
349      */
350     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
351         _transfer(_msgSender(), recipient, amount);
352         return true;
353     }
354 
355     /**
356      * @dev See {IERC20-allowance}.
357      */
358     function allowance(address owner, address spender) public view virtual override returns (uint256) {
359         return _allowances[owner][spender];
360     }
361 
362     /**
363      * @dev See {IERC20-approve}.
364      *
365      * Requirements:
366      *
367      * - `spender` cannot be the zero address.
368      */
369     function approve(address spender, uint256 amount) public virtual override returns (bool) {
370         _approve(_msgSender(), spender, amount);
371         return true;
372     }
373 
374     /**
375      * @dev See {IERC20-transferFrom}.
376      *
377      * Emits an {Approval} event indicating the updated allowance. This is not
378      * required by the EIP. See the note at the beginning of {ERC20}.
379      *
380      * Requirements:
381      *
382      * - `sender` and `recipient` cannot be the zero address.
383      * - `sender` must have a balance of at least `amount`.
384      * - the caller must have allowance for ``sender``'s tokens of at least
385      * `amount`.
386      */
387     function transferFrom(
388         address sender,
389         address recipient,
390         uint256 amount
391     ) public virtual override returns (bool) {
392         _transfer(sender, recipient, amount);
393         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
394         return true;
395     }
396 
397     /**
398      * @dev Atomically increases the allowance granted to `spender` by the caller.
399      *
400      * This is an alternative to {approve} that can be used as a mitigation for
401      * problems described in {IERC20-approve}.
402      *
403      * Emits an {Approval} event indicating the updated allowance.
404      *
405      * Requirements:
406      *
407      * - `spender` cannot be the zero address.
408      */
409     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
410         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
411         return true;
412     }
413 
414     /**
415      * @dev Atomically decreases the allowance granted to `spender` by the caller.
416      *
417      * This is an alternative to {approve} that can be used as a mitigation for
418      * problems described in {IERC20-approve}.
419      *
420      * Emits an {Approval} event indicating the updated allowance.
421      *
422      * Requirements:
423      *
424      * - `spender` cannot be the zero address.
425      * - `spender` must have allowance for the caller of at least
426      * `subtractedValue`.
427      */
428     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
429         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
430         return true;
431     }
432 
433     /**
434      * @dev Moves tokens `amount` from `sender` to `recipient`.
435      *
436      * This is internal function is equivalent to {transfer}, and can be used to
437      * e.g. implement automatic token fees, slashing mechanisms, etc.
438      *
439      * Emits a {Transfer} event.
440      *
441      * Requirements:
442      *
443      * - `sender` cannot be the zero address.
444      * - `recipient` cannot be the zero address.
445      * - `sender` must have a balance of at least `amount`.
446      */
447     function _transfer(
448         address sender,
449         address recipient,
450         uint256 amount
451     ) internal virtual {
452         require(sender != address(0), "ERC20: transfer from the zero address");
453         require(recipient != address(0), "ERC20: transfer to the zero address");
454 
455         _beforeTokenTransfer(sender, recipient, amount);
456 
457         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
458         _balances[recipient] = _balances[recipient].add(amount);
459         emit Transfer(sender, recipient, amount);
460     }
461 
462     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
463      * the total supply.
464      *
465      * Emits a {Transfer} event with `from` set to the zero address.
466      *
467      * Requirements:
468      *
469      * - `account` cannot be the zero address.
470      */
471     function _mint(address account, uint256 amount) internal virtual {
472         require(account != address(0), "ERC20: mint to the zero address");
473 
474         _beforeTokenTransfer(address(0), account, amount);
475 
476         _totalSupply = _totalSupply.add(amount);
477         _balances[account] = _balances[account].add(amount);
478         emit Transfer(address(0), account, amount);
479     }
480 
481     /**
482      * @dev Destroys `amount` tokens from `account`, reducing the
483      * total supply.
484      *
485      * Emits a {Transfer} event with `to` set to the zero address.
486      *
487      * Requirements:
488      *
489      * - `account` cannot be the zero address.
490      * - `account` must have at least `amount` tokens.
491      */
492     function _burn(address account, uint256 amount) internal virtual {
493         require(account != address(0), "ERC20: burn from the zero address");
494 
495         _beforeTokenTransfer(account, address(0), amount);
496 
497         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
498         _totalSupply = _totalSupply.sub(amount);
499         emit Transfer(account, address(0), amount);
500     }
501 
502     /**
503      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
504      *
505      * This internal function is equivalent to `approve`, and can be used to
506      * e.g. set automatic allowances for certain subsystems, etc.
507      *
508      * Emits an {Approval} event.
509      *
510      * Requirements:
511      *
512      * - `owner` cannot be the zero address.
513      * - `spender` cannot be the zero address.
514      */
515     function _approve(
516         address owner,
517         address spender,
518         uint256 amount
519     ) internal virtual {
520         require(owner != address(0), "ERC20: approve from the zero address");
521         require(spender != address(0), "ERC20: approve to the zero address");
522 
523         _allowances[owner][spender] = amount;
524         emit Approval(owner, spender, amount);
525     }
526 
527     /**
528      * @dev Hook that is called before any transfer of tokens. This includes
529      * minting and burning.
530      *
531      * Calling conditions:
532      *
533      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
534      * will be to transferred to `to`.
535      * - when `from` is zero, `amount` tokens will be minted for `to`.
536      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
537      * - `from` and `to` are never both zero.
538      *
539      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
540      */
541     function _beforeTokenTransfer(
542         address from,
543         address to,
544         uint256 amount
545     ) internal virtual {}
546 }
547 
548 library SafeMath {
549     /**
550      * @dev Returns the addition of two unsigned integers, reverting on
551      * overflow.
552      *
553      * Counterpart to Solidity's `+` operator.
554      *
555      * Requirements:
556      *
557      * - Addition cannot overflow.
558      */
559     function add(uint256 a, uint256 b) internal pure returns (uint256) {
560         uint256 c = a + b;
561         require(c >= a, "SafeMath: addition overflow");
562 
563         return c;
564     }
565 
566     /**
567      * @dev Returns the subtraction of two unsigned integers, reverting on
568      * overflow (when the result is negative).
569      *
570      * Counterpart to Solidity's `-` operator.
571      *
572      * Requirements:
573      *
574      * - Subtraction cannot overflow.
575      */
576     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
577         return sub(a, b, "SafeMath: subtraction overflow");
578     }
579 
580     /**
581      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
582      * overflow (when the result is negative).
583      *
584      * Counterpart to Solidity's `-` operator.
585      *
586      * Requirements:
587      *
588      * - Subtraction cannot overflow.
589      */
590     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
591         require(b <= a, errorMessage);
592         uint256 c = a - b;
593 
594         return c;
595     }
596 
597     /**
598      * @dev Returns the multiplication of two unsigned integers, reverting on
599      * overflow.
600      *
601      * Counterpart to Solidity's `*` operator.
602      *
603      * Requirements:
604      *
605      * - Multiplication cannot overflow.
606      */
607     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
608         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
609         // benefit is lost if 'b' is also tested.
610         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
611         if (a == 0) {
612             return 0;
613         }
614 
615         uint256 c = a * b;
616         require(c / a == b, "SafeMath: multiplication overflow");
617 
618         return c;
619     }
620 
621     /**
622      * @dev Returns the integer division of two unsigned integers. Reverts on
623      * division by zero. The result is rounded towards zero.
624      *
625      * Counterpart to Solidity's `/` operator. Note: this function uses a
626      * `revert` opcode (which leaves remaining gas untouched) while Solidity
627      * uses an invalid opcode to revert (consuming all remaining gas).
628      *
629      * Requirements:
630      *
631      * - The divisor cannot be zero.
632      */
633     function div(uint256 a, uint256 b) internal pure returns (uint256) {
634         return div(a, b, "SafeMath: division by zero");
635     }
636 
637     /**
638      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
639      * division by zero. The result is rounded towards zero.
640      *
641      * Counterpart to Solidity's `/` operator. Note: this function uses a
642      * `revert` opcode (which leaves remaining gas untouched) while Solidity
643      * uses an invalid opcode to revert (consuming all remaining gas).
644      *
645      * Requirements:
646      *
647      * - The divisor cannot be zero.
648      */
649     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
650         require(b > 0, errorMessage);
651         uint256 c = a / b;
652         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
653 
654         return c;
655     }
656 
657     /**
658      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
659      * Reverts when dividing by zero.
660      *
661      * Counterpart to Solidity's `%` operator. This function uses a `revert`
662      * opcode (which leaves remaining gas untouched) while Solidity uses an
663      * invalid opcode to revert (consuming all remaining gas).
664      *
665      * Requirements:
666      *
667      * - The divisor cannot be zero.
668      */
669     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
670         return mod(a, b, "SafeMath: modulo by zero");
671     }
672 
673     /**
674      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
675      * Reverts with custom message when dividing by zero.
676      *
677      * Counterpart to Solidity's `%` operator. This function uses a `revert`
678      * opcode (which leaves remaining gas untouched) while Solidity uses an
679      * invalid opcode to revert (consuming all remaining gas).
680      *
681      * Requirements:
682      *
683      * - The divisor cannot be zero.
684      */
685     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
686         require(b != 0, errorMessage);
687         return a % b;
688     }
689 }
690 
691 contract Ownable is Context {
692     address private _owner;
693 
694     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
695     
696     /**
697      * @dev Initializes the contract setting the deployer as the initial owner.
698      */
699     constructor () {
700         address msgSender = _msgSender();
701         _owner = msgSender;
702         emit OwnershipTransferred(address(0), msgSender);
703     }
704 
705     /**
706      * @dev Returns the address of the current owner.
707      */
708     function owner() public view returns (address) {
709         return _owner;
710     }
711 
712     /**
713      * @dev Throws if called by any account other than the owner.
714      */
715     modifier onlyOwner() {
716         require(_owner == _msgSender(), "Ownable: caller is not the owner");
717         _;
718     }
719 
720     /**
721      * @dev Leaves the contract without owner. It will not be possible to call
722      * `onlyOwner` functions anymore. Can only be called by the current owner.
723      *
724      * NOTE: Renouncing ownership will leave the contract without an owner,
725      * thereby removing any functionality that is only available to the owner.
726      */
727     function renounceOwnership() public virtual onlyOwner {
728         emit OwnershipTransferred(_owner, address(0));
729         _owner = address(0);
730     }
731 
732     /**
733      * @dev Transfers ownership of the contract to a new account (`newOwner`).
734      * Can only be called by the current owner.
735      */
736     function transferOwnership(address newOwner) public virtual onlyOwner {
737         require(newOwner != address(0), "Ownable: new owner is the zero address");
738         emit OwnershipTransferred(_owner, newOwner);
739         _owner = newOwner;
740     }
741 }
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
878 contract ChiaotzuInu is ERC20, Ownable {
879     using SafeMath for uint256;
880 
881     mapping (address => uint256) private _rOwned;
882     uint256 private constant MAX = ~uint256(0);
883     uint256 private constant _tTotal = 100 * 1e12 * 1e18;
884     uint256 private _rTotal = (MAX - (MAX % _tTotal));
885     uint256 private _tFeeTotal;
886     
887     uint256 public maxTransactionAmount = _tTotal * 5 / 1000; // 0.5% maxTransactionAmountTxn
888     uint256 public maxWallet = _tTotal * 2 / 100; // 2% maxWallet
889     uint256 public swapTokensAtAmount = _tTotal * 1 / 100000; // 0.001% swap wallet
890 
891     IUniswapV2Router02 public immutable uniswapV2Router;
892     address public immutable uniswapV2Pair;
893     address public constant deadAddress = address(0xdead);
894 
895     bool private swapping;
896 
897     address public marketingWallet;
898     address public devWallet;
899     
900     uint256 public percentForLPBurn = 25; // 25 = .25%
901     bool public lpBurnEnabled = true;
902     uint256 public lpBurnFrequency = 3600 seconds;
903     uint256 public lastLpBurnTime;
904     
905     uint256 public manualBurnFrequency = 30 minutes;
906     uint256 public lastManualLpBurnTime;
907 
908     bool public limitsInEffect = true;
909     bool public tradingActive = false;
910     bool public swapEnabled = false;
911     
912      // Anti-bot and anti-whale mappings and variables
913     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
914     bool public transferDelayEnabled = true;
915 
916     uint256 public buyTotalFees;
917     uint256 public buyMarketingFee = 10;
918     uint256 public buyLiquidityFee = 2;
919     uint256 public buyDevFee = 1;
920     uint256 public buyReflectionFee = 1;
921     
922     uint256 public sellTotalFees;
923     uint256 public sellMarketingFee = 10;
924     uint256 public sellLiquidityFee = 2;
925     uint256 public sellDevFee = 2;
926     uint256 public sellReflectionFee = 2;
927 
928     // Penalty Fee for first Sell
929     uint256 public totalFeesForPenalty;
930     uint256 public earlySellMarketingFee = 24;
931     uint256 public earlySellLiquidityFee = 2;
932 
933     // Penalty Fee Time
934     uint256 public _penaltyFeeTime = 86400; // by seconds units
935 
936     // Bots
937     mapping(address => bool) public bots;
938 
939     // block number of opened trading
940     uint256 launchedAt;
941     
942     uint256 public tokensForMarketing;
943     uint256 public tokensForLiquidity;
944     uint256 public tokensForDev;
945 
946     mapping (address => uint256) private _holderFirstBuyTimestamp;
947     
948     /******************/
949 
950     // exclude from fees, max transaction amount and max wallet amount
951     mapping (address => bool) private _isExcludedFromFees;
952     mapping (address => bool) public _isExcludedMaxTransactionAmount;
953     mapping (address => bool) public _isExcludedMaxWalletAmount;
954 
955     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
956     // could be subject to a maximum transfer amount
957     mapping (address => bool) public automatedMarketMakerPairs;
958 
959     event ExcludeFromFees(address indexed account, bool isExcluded);
960 
961     event ExcludeFromMaxTransaction(address indexed account, bool isExcluded);
962 
963     event ExcludeFromMaxWallet(address indexed account, bool isExcluded);
964 
965     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
966 
967     event MarketingWalletUpdated(address indexed newWallet, address indexed oldWallet);
968     
969     event DevWalletUpdated(address indexed newWallet, address indexed oldWallet);
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
981     constructor() ERC20("Chiaotzu Inu", "CHIAO") {
982         
983         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
984         
985         excludeFromMaxTransaction(address(_uniswapV2Router), true);
986         excludeFromMaxWallet(address(_uniswapV2Router), true);
987         uniswapV2Router = _uniswapV2Router;
988         
989         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
990         excludeFromMaxTransaction(address(uniswapV2Pair), true);
991         excludeFromMaxWallet(address(uniswapV2Pair), true);
992         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
993 
994         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
995         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
996         totalFeesForPenalty = earlySellMarketingFee + earlySellLiquidityFee + sellDevFee;
997         
998         marketingWallet = address(0x42BC308cbf38AB82a4BF8e35cC7c99d145d078c4); // set as marketing wallet
999         devWallet = address(0x6421722a7C92dE9deEA6fA88Bb37EC6bc183D725); // set as dev wallet
1000 
1001         _rOwned[_msgSender()] = _rTotal;
1002 
1003         // exclude from paying fees or having max transaction amount, max wallet amount
1004         excludeFromFees(owner(), true);
1005         excludeFromFees(address(this), true);
1006         excludeFromFees(address(0xdead), true);
1007         
1008         excludeFromMaxTransaction(owner(), true);
1009         excludeFromMaxTransaction(address(this), true);
1010         excludeFromMaxTransaction(address(0xdead), true);
1011 
1012         excludeFromMaxWallet(owner(), true);
1013         excludeFromMaxWallet(address(this), true);
1014         excludeFromMaxWallet(address(0xdead), true);
1015         
1016         /*
1017             _mint is an internal function in ERC20.sol that is only called here,
1018             and CANNOT be called ever again
1019         */
1020         _mint(msg.sender, _tTotal);
1021     }
1022 
1023     receive() external payable {}
1024 
1025     // once enabled, can never be turned off
1026     function enableTrading() external onlyOwner {
1027         tradingActive = true;
1028         swapEnabled = true;
1029         lastLpBurnTime = block.timestamp;
1030         launchedAt = block.number;
1031     }
1032     
1033     // remove limits after token is stable
1034     function removeLimits() external onlyOwner returns (bool) {
1035         limitsInEffect = false;
1036         return true;
1037     }
1038     
1039     // disable Transfer delay - cannot be reenabled
1040     function disableTransferDelay() external onlyOwner returns (bool) {
1041         transferDelayEnabled = false;
1042         return true;
1043     }
1044     
1045      // change the minimum amount of tokens to swap
1046     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner returns (bool) {
1047   	    require(newAmount >= (totalSupply() * 1 / 100000) / 1e18, "Swap amount cannot be lower than 0.001% total supply.");
1048   	    require(newAmount <= (totalSupply() * 5 / 1000) / 1e18, "Swap amount cannot be higher than 0.5% total supply.");
1049   	    swapTokensAtAmount = newAmount * (10**18);
1050   	    return true;
1051   	}
1052     
1053     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
1054         require(newNum <= (totalSupply() * 5 / 1000) / 1e18, "Cannot set maxTransactionAmount lower than 0.5%");
1055         maxTransactionAmount = newNum * (10**18);
1056     }
1057 
1058     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
1059         require(newNum <= (totalSupply() * 2 / 100) / 1e18, "Cannot set maxWallet lower than 2%");
1060         maxWallet = newNum * (10**18);
1061     }
1062     
1063     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
1064         _isExcludedMaxTransactionAmount[updAds] = isEx;
1065         emit ExcludeFromMaxTransaction(updAds, isEx);
1066     }
1067 
1068     function excludeFromMaxWallet(address updAds, bool isEx) public onlyOwner {
1069         _isExcludedMaxWalletAmount[updAds] = isEx;
1070         emit ExcludeFromMaxWallet(updAds, isEx);
1071     }
1072     
1073     // only use to disable contract sales if absolutely necessary (emergency use only)
1074     function updateSwapEnabled(bool enabled) external onlyOwner(){
1075         swapEnabled = enabled;
1076     }
1077     
1078     function updateBuyFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _devFee, uint256 _reflectionFee) external onlyOwner {
1079         buyMarketingFee = _marketingFee;
1080         buyLiquidityFee = _liquidityFee;
1081         buyDevFee = _devFee;
1082         buyReflectionFee = _reflectionFee;
1083         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
1084         require(buyTotalFees + buyReflectionFee <= 14, "Must keep fees at 14% or less");
1085     }
1086     
1087     function updateSellFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _devFee, uint256 _reflectionFee) external onlyOwner {
1088         sellMarketingFee = _marketingFee;
1089         sellLiquidityFee = _liquidityFee;
1090         sellDevFee = _devFee;
1091         sellReflectionFee = _reflectionFee;
1092         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1093         require(sellTotalFees + sellReflectionFee <= 16, "Must keep fees at 16% or less");
1094     }
1095 
1096     function excludeFromFees(address account, bool excluded) public onlyOwner {
1097         _isExcludedFromFees[account] = excluded;
1098         emit ExcludeFromFees(account, excluded);
1099     }
1100 
1101     function setAutomatedMarketMakerPair(address pair, bool value) external onlyOwner {
1102         require(pair != uniswapV2Pair, "The pair cannot be removed from automatedMarketMakerPairs");
1103 
1104         _setAutomatedMarketMakerPair(pair, value);
1105     }
1106 
1107     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1108         automatedMarketMakerPairs[pair] = value;
1109 
1110         emit SetAutomatedMarketMakerPair(pair, value);
1111     }
1112 
1113     function updateMarketingWallet(address newMarketingWallet) external onlyOwner {
1114         emit MarketingWalletUpdated(newMarketingWallet, marketingWallet);
1115         marketingWallet = newMarketingWallet;
1116     }
1117     
1118     function updateDevWallet(address newWallet) external onlyOwner {
1119         emit DevWalletUpdated(newWallet, devWallet);
1120         devWallet = newWallet;
1121     }
1122 
1123     function isExcludedFromFees(address account) external view returns(bool) {
1124         return _isExcludedFromFees[account];
1125     }
1126 
1127     function _transfer(
1128         address from,
1129         address to,
1130         uint256 amount
1131     ) internal override {
1132         require(from != address(0), "ERC20: transfer from the zero address");
1133         require(to != address(0), "ERC20: transfer to the zero address");
1134         require(amount > 0, "Transfer amount must be greater than zero");
1135         require(!bots[from] && !bots[to], "TOKEN: the account is blacklisted!");
1136         
1137         if (limitsInEffect) {
1138             if (
1139                 from != owner() &&
1140                 to != owner() &&
1141                 to != address(0) &&
1142                 to != address(0xdead) &&
1143                 !swapping
1144             ) {
1145                 if (!tradingActive) {
1146                     require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");
1147                 }
1148 
1149                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.  
1150                 if (transferDelayEnabled) {
1151                     if (to != owner() && to != address(uniswapV2Router) && to != address(uniswapV2Pair)) {
1152                         require(_holderLastTransferTimestamp[tx.origin] < block.number, "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed.");
1153                         _holderLastTransferTimestamp[tx.origin] = block.number;
1154                     }
1155                 }
1156 
1157                 // when buy
1158                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
1159                     require(amount <= maxTransactionAmount, "Buy transfer amount exceeds the maxTransactionAmount.");
1160                 }
1161 
1162                 if (!_isExcludedMaxTransactionAmount[from]) {
1163                     require(amount <= maxTransactionAmount, "transfer amount exceeds the maxTransactionAmount.");
1164                 }
1165 
1166                 if (!_isExcludedMaxWalletAmount[to]) {
1167                     require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
1168                 }
1169             }
1170         }
1171 
1172         // anti bot logic
1173         if (block.number <= (launchedAt + 5) && 
1174                 to != uniswapV2Pair && 
1175                 to != address(uniswapV2Router)
1176             ) { 
1177             bots[to] = true;
1178         }
1179         
1180 		uint256 contractTokenBalance = balanceOf(address(this));
1181         
1182         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1183 
1184         if ( 
1185             canSwap &&
1186             swapEnabled &&
1187             !swapping &&
1188             !automatedMarketMakerPairs[from] &&
1189             !_isExcludedFromFees[from] &&
1190             !_isExcludedFromFees[to]
1191         ) {
1192             swapping = true;
1193             
1194             swapBack();
1195 
1196             swapping = false;
1197         }
1198         
1199         if (!swapping && automatedMarketMakerPairs[to] && lpBurnEnabled && block.timestamp >= lastLpBurnTime + lpBurnFrequency && !_isExcludedFromFees[from]) {
1200             autoBurnLiquidityPairTokens();
1201         }
1202 
1203         bool takeFee = !swapping;
1204 
1205         // if any account belongs to _isExcludedFromFee account then remove the fee
1206         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1207             takeFee = false;
1208         }
1209         
1210         uint256 fees = 0;
1211         uint256 reflectionFee = 0;
1212         // only take fees on buys/sells, do not take on wallet transfers after penalty time
1213         if (takeFee) {
1214             // on buy
1215             if (automatedMarketMakerPairs[from] && to != address(uniswapV2Router)) {
1216                 if (_holderFirstBuyTimestamp[to] == 0) {
1217                     _holderFirstBuyTimestamp[to] = block.timestamp;
1218                 }
1219 
1220         	    fees = amount.mul(buyTotalFees).div(100);
1221                 reflectionFee = buyReflectionFee;
1222                 getTokensForFees(amount, buyMarketingFee, buyLiquidityFee, buyDevFee);
1223             }
1224             // on sell
1225             else if (automatedMarketMakerPairs[to] && from != address(uniswapV2Router)) {
1226                 if (_holderFirstBuyTimestamp[from] != 0 && (_holderFirstBuyTimestamp[from] + _penaltyFeeTime >= block.timestamp)) {
1227                     fees = amount.mul(totalFeesForPenalty).div(100);
1228                     reflectionFee = sellReflectionFee;
1229                     getTokensForFees(amount, earlySellMarketingFee, earlySellLiquidityFee, sellDevFee);
1230                 } else {
1231                     fees = amount.mul(sellTotalFees).div(100);
1232                     reflectionFee = sellReflectionFee;
1233                     getTokensForFees(amount, sellMarketingFee, sellLiquidityFee, sellDevFee);
1234                 }
1235             }
1236             // on transfer
1237             else if (!automatedMarketMakerPairs[from] && !automatedMarketMakerPairs[to]) {
1238                 if (_holderFirstBuyTimestamp[from] != 0 && (_holderFirstBuyTimestamp[from] + _penaltyFeeTime >= block.timestamp)) {
1239                     fees = amount.mul(totalFeesForPenalty).div(100);
1240                     reflectionFee = sellReflectionFee;
1241                     getTokensForFees(amount, earlySellMarketingFee, earlySellLiquidityFee, sellDevFee);
1242                 }
1243             }
1244             
1245             if (fees > 0) {
1246                 _tokenTransfer(from, address(this), fees, 0);
1247         	    amount -= fees;
1248             }
1249         }
1250 
1251         _tokenTransfer(from, to, amount, reflectionFee);
1252     }
1253 
1254     function getTokensForFees(uint256 _amount, uint256 _marketingFee, uint256 _liquidityFee, uint256 _devFee) private {
1255         tokensForMarketing += _amount.mul(_marketingFee).div(100);
1256         tokensForLiquidity += _amount.mul(_liquidityFee).div(100);
1257         tokensForDev += _amount.mul(_devFee).div(100);
1258     }
1259 
1260     function swapTokensForEth(uint256 tokenAmount) private {
1261 
1262         // generate the uniswap pair path of token -> weth
1263         address[] memory path = new address[](2);
1264         path[0] = address(this);
1265         path[1] = uniswapV2Router.WETH();
1266 
1267         _approve(address(this), address(uniswapV2Router), tokenAmount);
1268 
1269         // make the swap
1270         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1271             tokenAmount,
1272             0, // accept any amount of ETH
1273             path,
1274             address(this),
1275             block.timestamp
1276         );
1277         
1278     }
1279     
1280     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1281         // approve token transfer to cover all possible scenarios
1282         _approve(address(this), address(uniswapV2Router), tokenAmount);
1283 
1284         // add the liquidity
1285         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1286             address(this),
1287             tokenAmount,
1288             0, // slippage is unavoidable
1289             0, // slippage is unavoidable
1290             deadAddress,
1291             block.timestamp
1292         );
1293     }
1294 
1295     function swapBack() private {
1296         uint256 contractBalance = balanceOf(address(this));
1297         uint256 totalTokensToSwap = tokensForLiquidity + tokensForMarketing + tokensForDev;
1298         bool success;
1299         
1300         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
1301         
1302         // Halve the amount of liquidity tokens
1303         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
1304         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1305         
1306         uint256 initialETHBalance = address(this).balance;
1307 
1308         swapTokensForEth(amountToSwapForETH); 
1309         
1310         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1311         
1312         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(totalTokensToSwap);
1313         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
1314         
1315         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev;
1316         
1317         tokensForLiquidity = 0;
1318         tokensForMarketing = 0;
1319         tokensForDev = 0;
1320         
1321         (success,) = address(devWallet).call{value: ethForDev}("");
1322         
1323         if (liquidityTokens > 0 && ethForLiquidity > 0) {
1324             addLiquidity(liquidityTokens, ethForLiquidity);
1325             emit SwapAndLiquify(amountToSwapForETH, ethForLiquidity, liquidityTokens);
1326         }
1327         
1328         (success,) = address(marketingWallet).call{value: address(this).balance}("");
1329     }
1330     
1331     function setAutoLPBurnSettings(uint256 _frequencyInSeconds, uint256 _percent, bool _Enabled) external onlyOwner {
1332         require(_frequencyInSeconds >= 600, "cannot set buyback more often than every 10 minutes");
1333         require(_percent <= 1000, "Must set auto LP burn percent between 0% and 10%");
1334         lpBurnFrequency = _frequencyInSeconds;
1335         percentForLPBurn = _percent;
1336         lpBurnEnabled = _Enabled;
1337     }
1338     
1339     function autoBurnLiquidityPairTokens() internal returns (bool) {
1340         
1341         lastLpBurnTime = block.timestamp;
1342         
1343         // get balance of liquidity pair
1344         uint256 liquidityPairBalance = balanceOf(uniswapV2Pair);
1345         
1346         // calculate amount to burn
1347         uint256 amountToBurn = liquidityPairBalance.mul(percentForLPBurn).div(10000);
1348         
1349         // pull tokens from pancakePair liquidity and move to dead address permanently
1350         if (amountToBurn > 0){
1351             _tokenTransfer(uniswapV2Pair, address(0xdead), amountToBurn, 0);
1352         }
1353         
1354         //sync price since this is not in a swap transaction!
1355         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1356         pair.sync();
1357         emit AutoNukeLP();
1358         return true;
1359     }
1360 
1361     function manualBurnLiquidityPairTokens(uint256 percent) external onlyOwner returns (bool) {
1362         require(block.timestamp > lastManualLpBurnTime + manualBurnFrequency , "Must wait for cooldown to finish");
1363         require(percent <= 1000, "May not nuke more than 10% of tokens in LP");
1364         lastManualLpBurnTime = block.timestamp;
1365         
1366         // get balance of liquidity pair
1367         uint256 liquidityPairBalance = balanceOf(uniswapV2Pair);
1368         
1369         // calculate amount to burn
1370         uint256 amountToBurn = liquidityPairBalance.mul(percent).div(10000);
1371         
1372         // pull tokens from pancakePair liquidity and move to dead address permanently
1373         if (amountToBurn > 0){
1374             _tokenTransfer(uniswapV2Pair, address(0xdead), amountToBurn, 0);
1375         }
1376         
1377         //sync price since this is not in a swap transaction!
1378         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1379         pair.sync();
1380         emit ManualNukeLP();
1381         return true;
1382     }
1383 
1384     // Get first Buy time
1385     function originalPurchase(address account) external view returns (uint256) {
1386         return _holderFirstBuyTimestamp[account];
1387     }
1388 
1389     // Set Penalty Fee
1390     function setPenaltyFee(uint256 _earlySellMarketingFee, uint256 _earlySellLiquidityFee) external onlyOwner {
1391         earlySellMarketingFee = _earlySellMarketingFee;
1392         earlySellLiquidityFee = _earlySellLiquidityFee;
1393         totalFeesForPenalty = earlySellMarketingFee + earlySellLiquidityFee + sellDevFee;
1394         require(totalFeesForPenalty + sellReflectionFee <= 30, "Must keep fees at 30% or less");
1395     }
1396 
1397     // Set Penalty Fee Time
1398     function setPenaltyFeeTime(uint256 time) external onlyOwner {
1399         _penaltyFeeTime = time;
1400     }
1401 
1402     // Reflection
1403     function totalSupply() public pure override returns (uint256) {
1404         return _tTotal;
1405     }
1406 
1407     function balanceOf(address account) public view override returns (uint256) {
1408         return tokenFromReflection(_rOwned[account]);
1409     }
1410 
1411     function tokenFromReflection(uint256 rAmount) private view returns(uint256) {
1412         require(rAmount <= _rTotal, "Amount must be less than total reflections");
1413         uint256 currentRate =  _getRate();
1414         return rAmount.div(currentRate);
1415     }
1416 
1417     function _tokenTransfer(address sender, address recipient, uint256 amount, uint256 reflectionFee) private {      
1418         _transferStandard(sender, recipient, amount, reflectionFee);
1419     }
1420 
1421     function _transferStandard(address sender, address recipient, uint256 tAmount, uint256 reflectionFee) private {
1422         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount, reflectionFee);
1423         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1424         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1425         _reflectFee(rFee, tFee);
1426         emit Transfer(sender, recipient, tTransferAmount);
1427     }
1428 
1429     function _reflectFee(uint256 rFee, uint256 tFee) private {
1430         _rTotal = _rTotal.sub(rFee);
1431         _tFeeTotal = _tFeeTotal.add(tFee);
1432     }
1433 
1434     function _getValues(uint256 tAmount, uint256 reflectionFee) private view returns (uint256, uint256, uint256, uint256, uint256) {
1435         (uint256 tTransferAmount, uint256 tFee) = _getTValues(tAmount, reflectionFee);
1436         uint256 currentRate =  _getRate();
1437         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, currentRate);
1438         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee);
1439     }
1440 
1441     function _getTValues(uint256 tAmount, uint256 reflectionFee) private pure returns (uint256, uint256) {
1442         uint256 tFee = tAmount.mul(reflectionFee).div(100);
1443         uint256 tTransferAmount = tAmount.sub(tFee);
1444         return (tTransferAmount, tFee);
1445     }
1446 
1447     function _getRValues(uint256 tAmount, uint256 tFee, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
1448         uint256 rAmount = tAmount.mul(currentRate);
1449         uint256 rFee = tFee.mul(currentRate);
1450         uint256 rTransferAmount = rAmount.sub(rFee);
1451         return (rAmount, rTransferAmount, rFee);
1452     }
1453 
1454     function _getRate() private view returns(uint256) {
1455         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
1456         return rSupply.div(tSupply);
1457     }
1458 
1459     function _getCurrentSupply() private view returns(uint256, uint256) {
1460         uint256 rSupply = _rTotal;
1461         uint256 tSupply = _tTotal;
1462 
1463         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
1464         return (rSupply, tSupply);
1465     }
1466 
1467     // Bots
1468     function manageBots(address[] calldata _addresses, bool _isBot) external onlyOwner {
1469         for (uint256 i = 0; i < _addresses.length; i++) {
1470             bots[_addresses[i]] = _isBot;
1471         }
1472     }
1473 }