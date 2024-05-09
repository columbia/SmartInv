1 /**
2  * 🐸 PEPE.BET & PEPE.CASINO - Your WEB3 Social Gambling Platform
3  *
4  * PEPEBET offers a user-friendly, transparent, and fun betting/gaming platform where we focus on the needs of our community. 
5  * We offer market-leading features, no house cuts for token holders, and staking as well to those who want to passively earn and be a part of the PEPE ecosystem.
6  * If you have a large community or friends with similar interests, you can set up your own tipster competition and earn the house cut yourself! 
7  * If you prefer yields, you can stake your PEPEBET tokens, because we are sharing 50% of the house income with our holders.
8  * You can bet on our platform using ETH and PEPEBET as well! The main difference, however, is that when you are wagering with our token, NO HOUSE FEE will be deducted. 
9  * Do you want to play using ETH but want to lower the fees? 🔥 Hold & burn PEPEBET on your account to decrease the ETH house tax by 50%. 
10  *
11  * Total Supply: 1.000.000.000 PEPEBET
12  * Circulating Supply: 777.777.777 PEPEBET (rest burned before launch)
13  * Max Wallet: 2%
14  * Max TX: 1%
15  * Initial Taxes: 5-7%
16  * Launch Pair & LP size: 3000 USDC
17  * Intitial LP Lock: 2 months
18  * 
19  * NO TEAM TOKENS, NO PRIVATE/PRESALE, 100% OF CIRCULATING SUPPLY IN LIQUIDITY (FAIR LAUNCH), NO MARKETING PRIOR LAUNCH (STEALTH LAUNCH)
20  * 
21  * Website: https://pepe.bet
22  * Telegram: https://t.me/pepebetverification
23  * Twitter: 
24  * 
25  */
26 
27 // SPDX-License-Identifier: MIT
28 pragma solidity ^0.8.10;
29 pragma experimental ABIEncoderV2;
30 
31 ////// lib/openzeppelin-contracts/contracts/utils/Context.sol
32 // OpenZeppelin Contracts v4.4.0 (utils/Context.sol)
33 
34 /* pragma solidity ^0.8.0; */
35 
36 /**
37  * @dev Provides information about the current execution context, including the
38  * sender of the transaction and its data. While these are generally available
39  * via msg.sender and msg.data, they should not be accessed in such a direct
40  * manner, since when dealing with meta-transactions the account sending and
41  * paying for execution may not be the actual sender (as far as an application
42  * is concerned).
43  *
44  * This contract is only required for intermediate, library-like contracts.
45  */
46 abstract contract Context {
47     function _msgSender() internal view virtual returns (address) {
48         return msg.sender;
49     }
50 
51     function _msgData() internal view virtual returns (bytes calldata) {
52         return msg.data;
53     }
54 }
55 
56 ////// lib/openzeppelin-contracts/contracts/access/Ownable.sol
57 // OpenZeppelin Contracts v4.4.0 (access/Ownable.sol)
58 
59 /* pragma solidity ^0.8.0; */
60 
61 /* import "../utils/Context.sol"; */
62 
63 /**
64  * @dev Contract module which provides a basic access control mechanism, where
65  * there is an account (an owner) that can be granted exclusive access to
66  * specific functions.
67  *
68  * By default, the owner account will be the one that deploys the contract. This
69  * can later be changed with {transferOwnership}.
70  *
71  * This module is used through inheritance. It will make available the modifier
72  * `onlyOwner`, which can be applied to your functions to restrict their use to
73  * the owner.
74  */
75 abstract contract Ownable is Context {
76     address private _owner;
77 
78     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
79 
80     /**
81      * @dev Initializes the contract setting the deployer as the initial owner.
82      */
83     constructor() {
84         _transferOwnership(_msgSender());
85     }
86 
87     /**
88      * @dev Returns the address of the current owner.
89      */
90     function owner() public view virtual returns (address) {
91         return _owner;
92     }
93 
94     /**
95      * @dev Throws if called by any account other than the owner.
96      */
97     modifier onlyOwner() {
98         require(owner() == _msgSender(), "Ownable: caller is not the owner");
99         _;
100     }
101 
102     /**
103      * @dev Leaves the contract without owner. It will not be possible to call
104      * `onlyOwner` functions anymore. Can only be called by the current owner.
105      *
106      * NOTE: Renouncing ownership will leave the contract without an owner,
107      * thereby removing any functionality that is only available to the owner.
108      */
109     function renounceOwnership() public virtual onlyOwner {
110         _transferOwnership(address(0));
111     }
112 
113     /**
114      * @dev Transfers ownership of the contract to a new account (`newOwner`).
115      * Can only be called by the current owner.
116      */
117     function transferOwnership(address newOwner) public virtual onlyOwner {
118         require(newOwner != address(0), "Ownable: new owner is the zero address");
119         _transferOwnership(newOwner);
120     }
121 
122     /**
123      * @dev Transfers ownership of the contract to a new account (`newOwner`).
124      * Internal function without access restriction.
125      */
126     function _transferOwnership(address newOwner) internal virtual {
127         address oldOwner = _owner;
128         _owner = newOwner;
129         emit OwnershipTransferred(oldOwner, newOwner);
130     }
131 }
132 
133 ////// lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol
134 // OpenZeppelin Contracts v4.4.0 (token/ERC20/IERC20.sol)
135 
136 /**
137  * @dev Interface of the ERC20 standard as defined in the EIP.
138  */
139 interface IERC20 {
140     /**
141      * @dev Returns the amount of tokens in existence.
142      */
143     function totalSupply() external view returns (uint256);
144 
145     /**
146      * @dev Returns the amount of tokens owned by `account`.
147      */
148     function balanceOf(address account) external view returns (uint256);
149 
150     /**
151      * @dev Moves `amount` tokens from the caller's account to `recipient`.
152      *
153      * Returns a boolean value indicating whether the operation succeeded.
154      *
155      * Emits a {Transfer} event.
156      */
157     function transfer(address recipient, uint256 amount) external returns (bool);
158 
159     /**
160      * @dev Returns the remaining number of tokens that `spender` will be
161      * allowed to spend on behalf of `owner` through {transferFrom}. This is
162      * zero by default.
163      *
164      * This value changes when {approve} or {transferFrom} are called.
165      */
166     function allowance(address owner, address spender) external view returns (uint256);
167 
168     /**
169      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
170      *
171      * Returns a boolean value indicating whether the operation succeeded.
172      *
173      * IMPORTANT: Beware that changing an allowance with this method brings the risk
174      * that someone may use both the old and the new allowance by unfortunate
175      * transaction ordering. One possible solution to mitigate this race
176      * condition is to first reduce the spender's allowance to 0 and set the
177      * desired value afterwards:
178      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
179      *
180      * Emits an {Approval} event.
181      */
182     function approve(address spender, uint256 amount) external returns (bool);
183 
184     /**
185      * @dev Moves `amount` tokens from `sender` to `recipient` using the
186      * allowance mechanism. `amount` is then deducted from the caller's
187      * allowance.
188      *
189      * Returns a boolean value indicating whether the operation succeeded.
190      *
191      * Emits a {Transfer} event.
192      */
193     function transferFrom(
194         address sender,
195         address recipient,
196         uint256 amount
197     ) external returns (bool);
198 
199     /**
200      * @dev Emitted when `value` tokens are moved from one account (`from`) to
201      * another (`to`).
202      *
203      * Note that `value` may be zero.
204      */
205     event Transfer(address indexed from, address indexed to, uint256 value);
206 
207     /**
208      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
209      * a call to {approve}. `value` is the new allowance.
210      */
211     event Approval(address indexed owner, address indexed spender, uint256 value);
212 }
213 
214 ////// lib/openzeppelin-contracts/contracts/token/ERC20/extensions/IERC20Metadata.sol
215 // OpenZeppelin Contracts v4.4.0 (token/ERC20/extensions/IERC20Metadata.sol)
216 
217 /* pragma solidity ^0.8.0; */
218 
219 /* import "../IERC20.sol"; */
220 
221 /**
222  * @dev Interface for the optional metadata functions from the ERC20 standard.
223  *
224  * _Available since v4.1._
225  */
226 interface IERC20Metadata is IERC20 {
227     /**
228      * @dev Returns the name of the token.
229      */
230     function name() external view returns (string memory);
231 
232     /**
233      * @dev Returns the symbol of the token.
234      */
235     function symbol() external view returns (string memory);
236 
237     /**
238      * @dev Returns the decimals places of the token.
239      */
240     function decimals() external view returns (uint8);
241 }
242 
243 ////// lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol
244 // OpenZeppelin Contracts v4.4.0 (token/ERC20/ERC20.sol)
245 
246 /* pragma solidity ^0.8.0; */
247 
248 /* import "./IERC20.sol"; */
249 /* import "./extensions/IERC20Metadata.sol"; */
250 /* import "../../utils/Context.sol"; */
251 
252 /**
253  * @dev Implementation of the {IERC20} interface.
254  *
255  * This implementation is agnostic to the way tokens are created. This means
256  * that a supply mechanism has to be added in a derived contract using {_mint}.
257  * For a generic mechanism see {ERC20PresetMinterPauser}.
258  *
259  * TIP: For a detailed writeup see our guide
260  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
261  * to implement supply mechanisms].
262  *
263  * We have followed general OpenZeppelin Contracts guidelines: functions revert
264  * instead returning `false` on failure. This behavior is nonetheless
265  * conventional and does not conflict with the expectations of ERC20
266  * applications.
267  *
268  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
269  * This allows applications to reconstruct the allowance for all accounts just
270  * by listening to said events. Other implementations of the EIP may not emit
271  * these events, as it isn't required by the specification.
272  *
273  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
274  * functions have been added to mitigate the well-known issues around setting
275  * allowances. See {IERC20-approve}.
276  */
277 contract ERC20 is Context, IERC20, IERC20Metadata {
278     mapping(address => uint256) private _balances;
279 
280     mapping(address => mapping(address => uint256)) private _allowances;
281 
282     uint256 private _totalSupply;
283 
284     string private _name;
285     string private _symbol;
286 
287     /**
288      * @dev Sets the values for {name} and {symbol}.
289      *
290      * The default value of {decimals} is 18. To select a different value for
291      * {decimals} you should overload it.
292      *
293      * All two of these values are immutable: they can only be set once during
294      * construction.
295      */
296     constructor(string memory name_, string memory symbol_) {
297         _name = name_;
298         _symbol = symbol_;
299     }
300 
301     /**
302      * @dev Returns the name of the token.
303      */
304     function name() public view virtual override returns (string memory) {
305         return _name;
306     }
307 
308     /**
309      * @dev Returns the symbol of the token, usually a shorter version of the
310      * name.
311      */
312     function symbol() public view virtual override returns (string memory) {
313         return _symbol;
314     }
315 
316     /**
317      * @dev Returns the number of decimals used to get its user representation.
318      * For example, if `decimals` equals `2`, a balance of `505` tokens should
319      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
320      *
321      * Tokens usually opt for a value of 18, imitating the relationship between
322      * Ether and Wei. This is the value {ERC20} uses, unless this function is
323      * overridden;
324      *
325      * NOTE: This information is only used for _display_ purposes: it in
326      * no way affects any of the arithmetic of the contract, including
327      * {IERC20-balanceOf} and {IERC20-transfer}.
328      */
329     function decimals() public view virtual override returns (uint8) {
330         return 18;
331     }
332 
333     /**
334      * @dev See {IERC20-totalSupply}.
335      */
336     function totalSupply() public view virtual override returns (uint256) {
337         return _totalSupply;
338     }
339 
340     /**
341      * @dev See {IERC20-balanceOf}.
342      */
343     function balanceOf(address account) public view virtual override returns (uint256) {
344         return _balances[account];
345     }
346 
347     /**
348      * @dev See {IERC20-transfer}.
349      *
350      * Requirements:
351      *
352      * - `recipient` cannot be the zero address.
353      * - the caller must have a balance of at least `amount`.
354      */
355     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
356         _transfer(_msgSender(), recipient, amount);
357         return true;
358     }
359 
360     /**
361      * @dev See {IERC20-allowance}.
362      */
363     function allowance(address owner, address spender) public view virtual override returns (uint256) {
364         return _allowances[owner][spender];
365     }
366 
367     /**
368      * @dev See {IERC20-approve}.
369      *
370      * Requirements:
371      *
372      * - `spender` cannot be the zero address.
373      */
374     function approve(address spender, uint256 amount) public virtual override returns (bool) {
375         _approve(_msgSender(), spender, amount);
376         return true;
377     }
378 
379     /**
380      * @dev See {IERC20-transferFrom}.
381      *
382      * Emits an {Approval} event indicating the updated allowance. This is not
383      * required by the EIP. See the note at the beginning of {ERC20}.
384      *
385      * Requirements:
386      *
387      * - `sender` and `recipient` cannot be the zero address.
388      * - `sender` must have a balance of at least `amount`.
389      * - the caller must have allowance for ``sender``'s tokens of at least
390      * `amount`.
391      */
392     function transferFrom(
393         address sender,
394         address recipient,
395         uint256 amount
396     ) public virtual override returns (bool) {
397         _transfer(sender, recipient, amount);
398 
399         uint256 currentAllowance = _allowances[sender][_msgSender()];
400         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
401         unchecked {
402             _approve(sender, _msgSender(), currentAllowance - amount);
403         }
404 
405         return true;
406     }
407 
408     /**
409      * @dev Moves `amount` of tokens from `sender` to `recipient`.
410      *
411      * This internal function is equivalent to {transfer}, and can be used to
412      * e.g. implement automatic token fees, slashing mechanisms, etc.
413      *
414      * Emits a {Transfer} event.
415      *
416      * Requirements:
417      *
418      * - `sender` cannot be the zero address.
419      * - `recipient` cannot be the zero address.
420      * - `sender` must have a balance of at least `amount`.
421      */
422     function _transfer(
423         address sender,
424         address recipient,
425         uint256 amount
426     ) internal virtual {
427         require(sender != address(0), "ERC20: transfer from the zero address");
428         require(recipient != address(0), "ERC20: transfer to the zero address");
429 
430         _beforeTokenTransfer(sender, recipient, amount);
431 
432         uint256 senderBalance = _balances[sender];
433         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
434         unchecked {
435             _balances[sender] = senderBalance - amount;
436         }
437         _balances[recipient] += amount;
438 
439         emit Transfer(sender, recipient, amount);
440 
441         _afterTokenTransfer(sender, recipient, amount);
442     }
443 
444     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
445      * the total supply.
446      *
447      * Emits a {Transfer} event with `from` set to the zero address.
448      *
449      * Requirements:
450      *
451      * - `account` cannot be the zero address.
452      */
453     function _mint(address account, uint256 amount) internal virtual {
454         require(account != address(0), "ERC20: mint to the zero address");
455 
456         _beforeTokenTransfer(address(0), account, amount);
457 
458         _totalSupply += amount;
459         _balances[account] += amount;
460         emit Transfer(address(0), account, amount);
461 
462         _afterTokenTransfer(address(0), account, amount);
463     }
464 
465 
466     /**
467      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
468      *
469      * This internal function is equivalent to `approve`, and can be used to
470      * e.g. set automatic allowances for certain subsystems, etc.
471      *
472      * Emits an {Approval} event.
473      *
474      * Requirements:
475      *
476      * - `owner` cannot be the zero address.
477      * - `spender` cannot be the zero address.
478      */
479     function _approve(
480         address owner,
481         address spender,
482         uint256 amount
483     ) internal virtual {
484         require(owner != address(0), "ERC20: approve from the zero address");
485         require(spender != address(0), "ERC20: approve to the zero address");
486 
487         _allowances[owner][spender] = amount;
488         emit Approval(owner, spender, amount);
489     }
490 
491     /**
492      * @dev Hook that is called before any transfer of tokens. This includes
493      * minting and burning.
494      *
495      * Calling conditions:
496      *
497      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
498      * will be transferred to `to`.
499      * - when `from` is zero, `amount` tokens will be minted for `to`.
500      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
501      * - `from` and `to` are never both zero.
502      *
503      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
504      */
505     function _beforeTokenTransfer(
506         address from,
507         address to,
508         uint256 amount
509     ) internal virtual {}
510 
511     /**
512      * @dev Hook that is called after any transfer of tokens. This includes
513      * minting and burning.
514      *
515      * Calling conditions:
516      *
517      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
518      * has been transferred to `to`.
519      * - when `from` is zero, `amount` tokens have been minted for `to`.
520      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
521      * - `from` and `to` are never both zero.
522      *
523      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
524      */
525     function _afterTokenTransfer(
526         address from,
527         address to,
528         uint256 amount
529     ) internal virtual {}
530 }
531 
532 ////// lib/openzeppelin-contracts/contracts/utils/math/SafeMath.sol
533 // OpenZeppelin Contracts v4.4.0 (utils/math/SafeMath.sol)
534 
535 /**
536  * @dev Wrappers over Solidity's arithmetic operations.
537  *
538  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
539  * now has built in overflow checking.
540  */
541 library SafeMath {
542     /**
543      * @dev Returns the addition of two unsigned integers, with an overflow flag.
544      *
545      * _Available since v3.4._
546      */
547     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
548         unchecked {
549             uint256 c = a + b;
550             if (c < a) return (false, 0);
551             return (true, c);
552         }
553     }
554 
555     /**
556      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
557      *
558      * _Available since v3.4._
559      */
560     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
561         unchecked {
562             if (b > a) return (false, 0);
563             return (true, a - b);
564         }
565     }
566 
567     /**
568      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
569      *
570      * _Available since v3.4._
571      */
572     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
573         unchecked {
574             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
575             // benefit is lost if 'b' is also tested.
576             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
577             if (a == 0) return (true, 0);
578             uint256 c = a * b;
579             if (c / a != b) return (false, 0);
580             return (true, c);
581         }
582     }
583 
584     /**
585      * @dev Returns the division of two unsigned integers, with a division by zero flag.
586      *
587      * _Available since v3.4._
588      */
589     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
590         unchecked {
591             if (b == 0) return (false, 0);
592             return (true, a / b);
593         }
594     }
595 
596     /**
597      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
598      *
599      * _Available since v3.4._
600      */
601     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
602         unchecked {
603             if (b == 0) return (false, 0);
604             return (true, a % b);
605         }
606     }
607 
608     /**
609      * @dev Returns the addition of two unsigned integers, reverting on
610      * overflow.
611      *
612      * Counterpart to Solidity's `+` operator.
613      *
614      * Requirements:
615      *
616      * - Addition cannot overflow.
617      */
618     function add(uint256 a, uint256 b) internal pure returns (uint256) {
619         return a + b;
620     }
621 
622     /**
623      * @dev Returns the subtraction of two unsigned integers, reverting on
624      * overflow (when the result is negative).
625      *
626      * Counterpart to Solidity's `-` operator.
627      *
628      * Requirements:
629      *
630      * - Subtraction cannot overflow.
631      */
632     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
633         return a - b;
634     }
635 
636     /**
637      * @dev Returns the multiplication of two unsigned integers, reverting on
638      * overflow.
639      *
640      * Counterpart to Solidity's `*` operator.
641      *
642      * Requirements:
643      *
644      * - Multiplication cannot overflow.
645      */
646     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
647         return a * b;
648     }
649 
650     /**
651      * @dev Returns the integer division of two unsigned integers, reverting on
652      * division by zero. The result is rounded towards zero.
653      *
654      * Counterpart to Solidity's `/` operator.
655      *
656      * Requirements:
657      *
658      * - The divisor cannot be zero.
659      */
660     function div(uint256 a, uint256 b) internal pure returns (uint256) {
661         return a / b;
662     }
663 
664     /**
665      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
666      * reverting when dividing by zero.
667      *
668      * Counterpart to Solidity's `%` operator. This function uses a `revert`
669      * opcode (which leaves remaining gas untouched) while Solidity uses an
670      * invalid opcode to revert (consuming all remaining gas).
671      *
672      * Requirements:
673      *
674      * - The divisor cannot be zero.
675      */
676     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
677         return a % b;
678     }
679 
680     /**
681      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
682      * overflow (when the result is negative).
683      *
684      * CAUTION: This function is deprecated because it requires allocating memory for the error
685      * message unnecessarily. For custom revert reasons use {trySub}.
686      *
687      * Counterpart to Solidity's `-` operator.
688      *
689      * Requirements:
690      *
691      * - Subtraction cannot overflow.
692      */
693     function sub(
694         uint256 a,
695         uint256 b,
696         string memory errorMessage
697     ) internal pure returns (uint256) {
698         unchecked {
699             require(b <= a, errorMessage);
700             return a - b;
701         }
702     }
703 
704     /**
705      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
706      * division by zero. The result is rounded towards zero.
707      *
708      * Counterpart to Solidity's `/` operator. Note: this function uses a
709      * `revert` opcode (which leaves remaining gas untouched) while Solidity
710      * uses an invalid opcode to revert (consuming all remaining gas).
711      *
712      * Requirements:
713      *
714      * - The divisor cannot be zero.
715      */
716     function div(
717         uint256 a,
718         uint256 b,
719         string memory errorMessage
720     ) internal pure returns (uint256) {
721         unchecked {
722             require(b > 0, errorMessage);
723             return a / b;
724         }
725     }
726 
727     /**
728      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
729      * reverting with custom message when dividing by zero.
730      *
731      * CAUTION: This function is deprecated because it requires allocating memory for the error
732      * message unnecessarily. For custom revert reasons use {tryMod}.
733      *
734      * Counterpart to Solidity's `%` operator. This function uses a `revert`
735      * opcode (which leaves remaining gas untouched) while Solidity uses an
736      * invalid opcode to revert (consuming all remaining gas).
737      *
738      * Requirements:
739      *
740      * - The divisor cannot be zero.
741      */
742     function mod(
743         uint256 a,
744         uint256 b,
745         string memory errorMessage
746     ) internal pure returns (uint256) {
747         unchecked {
748             require(b > 0, errorMessage);
749             return a % b;
750         }
751     }
752 }
753 
754 interface IUniswapV2Factory {
755     event PairCreated(
756         address indexed token0,
757         address indexed token1,
758         address pair,
759         uint256
760     );
761 
762     function createPair(address tokenA, address tokenB)
763         external
764         returns (address pair);
765 }
766 
767 interface IUniswapV2Router02 {
768     function factory() external pure returns (address);
769 
770     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
771         uint256 amountIn,
772         uint256 amountOutMin,
773         address[] calldata path,
774         address to,
775         uint256 deadline
776     ) external;
777 }
778 
779 contract PEPEBET is ERC20, Ownable {
780     using SafeMath for uint256;
781 
782     IUniswapV2Router02 public immutable uniswapV2Router;
783     address public immutable uniswapV2Pair;
784     address public constant deadAddress = address(0xdead);
785     address public USDC = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;
786     bool private swapping;
787     address public devWallet;
788     uint256 public maxTransactionAmount;
789     uint256 public swapTokensAtAmount;
790     uint256 public maxWallet;
791 
792     bool public limitsInEffect = true;
793     bool public tradingActive = false;
794     bool public swapEnabled = false;
795 
796     uint256 public buyTotalFees;
797     uint256 public buyDevFee;
798 
799     uint256 public sellTotalFees;
800     uint256 public sellDevFee;
801 
802     /******************/
803 
804     // exlcude from fees and max transaction amount
805     mapping(address => bool) private _isExcludedFromFees;
806     mapping(address => bool) public _isExcludedMaxTransactionAmount;
807 
808     event ExcludeFromFees(address indexed account, bool isExcluded);
809 
810     event devWalletUpdated(
811         address indexed newWallet,
812         address indexed oldWallet
813     );
814 
815     constructor() ERC20("PEPE.bet Token", "PEPEBET") {
816         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
817             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
818         );
819 
820         excludeFromMaxTransaction(address(_uniswapV2Router), true);
821         uniswapV2Router = _uniswapV2Router;
822 
823         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
824             .createPair(address(this), USDC);
825         excludeFromMaxTransaction(address(uniswapV2Pair), true);
826 
827 
828         uint256 _buyDevFee = 5;
829         uint256 _sellDevFee = 7;
830 
831         uint256 totalSupply = 100_000_000 * 1e19;
832 
833         maxTransactionAmount =  totalSupply * 1 / 100; // 1% Total Supply Max Transaction
834         maxWallet = totalSupply * 2 / 100; // 2% Total Supply Max Wallet
835         swapTokensAtAmount = (totalSupply * 10) / 10000; // 0.1% Swap Wallet
836 
837         buyDevFee = _buyDevFee;
838         buyTotalFees = buyDevFee;
839 
840         sellDevFee = _sellDevFee;
841         sellTotalFees = sellDevFee;
842 
843         devWallet = address(0x53A21453255910766d952DB76473b41C3913Ac0e);
844         excludeFromFees(owner(), true);
845         excludeFromFees(address(this), true);
846         excludeFromFees(address(0xdead), true);
847 
848         excludeFromMaxTransaction(owner(), true);
849         excludeFromMaxTransaction(address(this), true);
850         excludeFromMaxTransaction(address(0xdead), true);
851 
852         /*
853             _mint is an internal function in ERC20.sol that is only called here,
854             and CANNOT be called ever again
855         */
856         _mint(msg.sender, totalSupply);
857     }
858 
859     receive() external payable {}
860 
861     // Once enabled, can never be turned off
862     function enableTrading() external onlyOwner {
863         tradingActive = true;
864         swapEnabled = true;
865     }
866 
867     // Remove limits after token is stable
868     function removeLimits() external onlyOwner returns (bool) {
869         limitsInEffect = false;
870         return true;
871     }
872 
873     // Change the minimum amount of tokens to sell from fees
874     function updateSwapTokensAtAmount(uint256 newAmount)
875         external
876         onlyOwner
877         returns (bool)
878     {
879         require(
880             newAmount >= (totalSupply() * 1) / 100000,
881             "Swap amount cannot be lower than 0.001% total supply."
882         );
883         require(
884             newAmount <= (totalSupply() * 5) / 1000,
885             "Swap amount cannot be higher than 0.5% total supply."
886         );
887         swapTokensAtAmount = newAmount;
888         return true;
889     }
890 
891     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
892         require(
893             newNum >= ((totalSupply() * 1) / 1000) / 1e19,
894             "Cannot set maxTransactionAmount lower than 0.1%"
895         );
896         maxTransactionAmount = newNum * (10**19);
897     }
898 
899     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
900         require(
901             newNum >= ((totalSupply() * 5) / 1000) / 1e19,
902             "Cannot set maxWallet lower than 0.5%"
903         );
904         maxWallet = newNum * (10**19);
905     }
906 
907     function excludeFromMaxTransaction(address updAds, bool isEx)
908         public
909         onlyOwner
910     {
911         _isExcludedMaxTransactionAmount[updAds] = isEx;
912     }
913 
914     function updateSwapEnabled(bool enabled) external onlyOwner {
915         swapEnabled = enabled;
916     }
917 
918     function updateBuyFees(
919         uint256 _devFee
920     ) external onlyOwner {
921         buyDevFee = _devFee;
922         buyTotalFees = buyDevFee;
923         require(buyTotalFees <= 5, "Must keep fees at 5% or less");
924     }
925 
926     function updateSellFees(
927         uint256 _devFee
928     ) external onlyOwner {
929         sellDevFee = _devFee;
930         sellTotalFees = sellDevFee;
931         require(sellTotalFees <= 10, "Must keep fees at 10% or less");
932     }
933 
934     function excludeFromFees(address account, bool excluded) public onlyOwner {
935         _isExcludedFromFees[account] = excluded;
936         emit ExcludeFromFees(account, excluded);
937     }
938 
939     function updateDevWallet(address newDevWallet)
940         external
941         onlyOwner
942     {
943         emit devWalletUpdated(newDevWallet, devWallet);
944         devWallet = newDevWallet;
945     }
946 
947 
948     function isExcludedFromFees(address account) public view returns (bool) {
949         return _isExcludedFromFees[account];
950     }
951 
952     function _transfer(
953         address from,
954         address to,
955         uint256 amount
956     ) internal override {
957         require(from != address(0), "ERC20: transfer from the zero address");
958         require(to != address(0), "ERC20: transfer to the zero address");
959 
960         if (amount == 0) {
961             super._transfer(from, to, 0);
962             return;
963         }
964 
965         if (limitsInEffect) {
966             if (
967                 from != owner() &&
968                 to != owner() &&
969                 to != address(0) &&
970                 to != address(0xdead) &&
971                 !swapping
972             ) {
973                 if (!tradingActive) {
974                     require(
975                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
976                         "Trading is not active."
977                     );
978                 }
979 
980                 //when buy
981                 if (
982                     from == uniswapV2Pair &&
983                     !_isExcludedMaxTransactionAmount[to]
984                 ) {
985                     require(
986                         amount <= maxTransactionAmount,
987                         "Buy transfer amount exceeds the maxTransactionAmount."
988                     );
989                     require(
990                         amount + balanceOf(to) <= maxWallet,
991                         "Max wallet exceeded"
992                     );
993                 }
994                 else if (!_isExcludedMaxTransactionAmount[to]) {
995                     require(
996                         amount + balanceOf(to) <= maxWallet,
997                         "Max wallet exceeded"
998                     );
999                 }
1000             }
1001         }
1002 
1003         uint256 contractTokenBalance = balanceOf(address(this));
1004 
1005         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1006 
1007         if (
1008             canSwap &&
1009             swapEnabled &&
1010             !swapping &&
1011             to == uniswapV2Pair &&
1012             !_isExcludedFromFees[from] &&
1013             !_isExcludedFromFees[to]
1014         ) {
1015             swapping = true;
1016             swapBack();
1017             swapping = false;
1018         }
1019 
1020         bool takeFee = !swapping;
1021 
1022         // if any account belongs to _isExcludedFromFee account then remove the fee
1023         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1024             takeFee = false;
1025         }
1026 
1027         uint256 fees = 0;
1028         uint256 tokensForDev = 0;
1029         // only take fees on buys/sells, do not take on wallet transfers
1030         if (takeFee) {
1031             // on sell
1032             if (to == uniswapV2Pair && sellTotalFees > 0) {
1033                 fees = amount.mul(sellTotalFees).div(100);
1034                 tokensForDev = (fees * sellDevFee) / sellTotalFees;
1035             }
1036             // on buy
1037             else if (from == uniswapV2Pair && buyTotalFees > 0) {
1038                 fees = amount.mul(buyTotalFees).div(100);
1039                 tokensForDev = (fees * buyDevFee) / buyTotalFees;
1040             }
1041 
1042             if (fees> 0) {
1043                 super._transfer(from, address(this), fees);
1044             }
1045 
1046             amount -= fees;
1047         }
1048 
1049         super._transfer(from, to, amount);
1050     }
1051 
1052     function swapTokensForUSDC(uint256 tokenAmount) private {
1053         // generate the uniswap pair path of token -> weth
1054         address[] memory path = new address[](2);
1055         path[0] = address(this);
1056         path[1] = USDC;
1057 
1058         _approve(address(this), address(uniswapV2Router), tokenAmount);
1059 
1060         // make the swap
1061         uniswapV2Router.swapExactTokensForTokensSupportingFeeOnTransferTokens(
1062             tokenAmount,
1063             0, // accept any amount of USDC
1064             path,
1065             devWallet,
1066             block.timestamp
1067         );
1068     }
1069 
1070     function swapBack() private {
1071         uint256 contractBalance = balanceOf(address(this));
1072         if (contractBalance == 0) {
1073             return;
1074         }
1075 
1076         if (contractBalance > swapTokensAtAmount * 20) {
1077             contractBalance = swapTokensAtAmount * 20;
1078         }
1079 
1080         swapTokensForUSDC(contractBalance);
1081     }
1082 
1083 }