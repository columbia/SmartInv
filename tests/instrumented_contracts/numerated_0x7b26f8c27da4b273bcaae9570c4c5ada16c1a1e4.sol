1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.10;
3 pragma experimental ABIEncoderV2;
4 
5 // Enter the Gold AI Bot. Your Entry starts here
6 // https://t.me/handofmidasentry
7 
8 /**
9  * @dev Provides information about the current execution context, including the
10  * sender of the transaction and its data. While these are generally available
11  * via msg.sender and msg.data, they should not be accessed in such a direct
12  * manner, since when dealing with meta-transactions the account sending and
13  * paying for execution may not be the actual sender (as far as an application
14  * is concerned).
15  *
16  * This contract is only required for intermediate, library-like contracts.
17  */
18 abstract contract Context {
19     function _msgSender() internal view virtual returns (address) {
20         return msg.sender;
21     }
22 
23     function _msgData() internal view virtual returns (bytes calldata) {
24         return msg.data;
25     }
26 }
27 
28 /**
29  * @dev Contract module which provides a basic access control mechanism, where
30  * there is an account (an owner) that can be granted exclusive access to
31  * specific functions.
32  *
33  * By default, the owner account will be the one that deploys the contract. This
34  * can later be changed with {transferOwnership}.
35  *
36  * This module is used through inheritance. It will make available the modifier
37  * `onlyOwner`, which can be applied to your functions to restrict their use to
38  * the owner.
39  */
40 abstract contract Ownable is Context {
41     address private _owner;
42 
43     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
44 
45     /**
46      * @dev Initializes the contract setting the deployer as the initial owner.
47      */
48     constructor() {
49         _transferOwnership(_msgSender());
50     }
51 
52     /**
53      * @dev Returns the address of the current owner.
54      */
55     function owner() public view virtual returns (address) {
56         return _owner;
57     }
58 
59     /**
60      * @dev Throws if called by any account other than the owner.
61      */
62     modifier onlyOwner() {
63         require(owner() == _msgSender(), "Ownable: caller is not the owner");
64         _;
65     }
66 
67     /**
68      * @dev Leaves the contract without owner. It will not be possible to call
69      * `onlyOwner` functions anymore. Can only be called by the current owner.
70      *
71      * NOTE: Renouncing ownership will leave the contract without an owner,
72      * thereby removing any functionality that is only available to the owner.
73      */
74     function renounceOwnership() public virtual onlyOwner {
75         _transferOwnership(address(0));
76     }
77 
78     /**
79      * @dev Transfers ownership of the contract to a new account (`newOwner`).
80      * Can only be called by the current owner.
81      */
82     function transferOwnership(address newOwner) public virtual onlyOwner {
83         require(newOwner != address(0), "Ownable: new owner is the zero address");
84         _transferOwnership(newOwner);
85     }
86 
87     /**
88      * @dev Transfers ownership of the contract to a new account (`newOwner`).
89      * Internal function without access restriction.
90      */
91     function _transferOwnership(address newOwner) internal virtual {
92         address oldOwner = _owner;
93         _owner = newOwner;
94         emit OwnershipTransferred(oldOwner, newOwner);
95     }
96 }
97 
98 /**
99  * @dev Interface of the ERC20 standard as defined in the EIP.
100  */
101 interface IERC20 {
102     /**
103      * @dev Returns the amount of tokens in existence.
104      */
105     function totalSupply() external view returns (uint256);
106 
107     /**
108      * @dev Returns the amount of tokens owned by `account`.
109      */
110     function balanceOf(address account) external view returns (uint256);
111 
112     /**
113      * @dev Moves `amount` tokens from the caller's account to `recipient`.
114      *
115      * Returns a boolean value indicating whether the operation succeeded.
116      *
117      * Emits a {Transfer} event.
118      */
119     function transfer(address recipient, uint256 amount) external returns (bool);
120 
121     /**
122      * @dev Returns the remaining number of tokens that `spender` will be
123      * allowed to spend on behalf of `owner` through {transferFrom}. This is
124      * zero by default.
125      *
126      * This value changes when {approve} or {transferFrom} are called.
127      */
128     function allowance(address owner, address spender) external view returns (uint256);
129 
130     /**
131      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
132      *
133      * Returns a boolean value indicating whether the operation succeeded.
134      *
135      * IMPORTANT: Beware that changing an allowance with this method brings the risk
136      * that someone may use both the old and the new allowance by unfortunate
137      * transaction ordering. One possible solution to mitigate this race
138      * condition is to first reduce the spender's allowance to 0 and set the
139      * desired value afterwards:
140      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
141      *
142      * Emits an {Approval} event.
143      */
144     function approve(address spender, uint256 amount) external returns (bool);
145 
146     /**
147      * @dev Moves `amount` tokens from `sender` to `recipient` using the
148      * allowance mechanism. `amount` is then deducted from the caller's
149      * allowance.
150      *
151      * Returns a boolean value indicating whether the operation succeeded.
152      *
153      * Emits a {Transfer} event.
154      */
155     function transferFrom(
156         address sender,
157         address recipient,
158         uint256 amount
159     ) external returns (bool);
160 
161     /**
162      * @dev Emitted when `value` tokens are moved from one account (`from`) to
163      * another (`to`).
164      *
165      * Note that `value` may be zero.
166      */
167     event Transfer(address indexed from, address indexed to, uint256 value);
168 
169     /**
170      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
171      * a call to {approve}. `value` is the new allowance.
172      */
173     event Approval(address indexed owner, address indexed spender, uint256 value);
174 }
175 
176 /**
177  * @dev Interface for the optional metadata functions from the ERC20 standard.
178  *
179  * _Available since v4.1._
180  */
181 interface IERC20Metadata is IERC20 {
182     /**
183      * @dev Returns the name of the token.
184      */
185     function name() external view returns (string memory);
186 
187     /**
188      * @dev Returns the symbol of the token.
189      */
190     function symbol() external view returns (string memory);
191 
192     /**
193      * @dev Returns the decimals places of the token.
194      */
195     function decimals() external view returns (uint8);
196 }
197 
198 /**
199  * @dev Implementation of the {IERC20} interface.
200  *
201  * This implementation is agnostic to the way tokens are created. This means
202  * that a supply mechanism has to be added in a derived contract using {_mint}.
203  * For a generic mechanism see {ERC20PresetMinterPauser}.
204  *
205  * TIP: For a detailed writeup see our guide
206  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
207  * to implement supply mechanisms].
208  *
209  * We have followed general OpenZeppelin Contracts guidelines: functions revert
210  * instead returning `false` on failure. This behavior is nonetheless
211  * conventional and does not conflict with the expectations of ERC20
212  * applications.
213  *
214  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
215  * This allows applications to reconstruct the allowance for all accounts just
216  * by listening to said events. Other implementations of the EIP may not emit
217  * these events, as it isn't required by the specification.
218  *
219  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
220  * functions have been added to mitigate the well-known issues around setting
221  * allowances. See {IERC20-approve}.
222  */
223 contract ERC20 is Context, IERC20, IERC20Metadata {
224     mapping(address => uint256) private _balances;
225 
226     mapping(address => mapping(address => uint256)) private _allowances;
227 
228     uint256 private _totalSupply;
229 
230     string private _name;
231     string private _symbol;
232 
233     /**
234      * @dev Sets the values for {name} and {symbol}.
235      *
236      * The default value of {decimals} is 18. To select a different value for
237      * {decimals} you should overload it.
238      *
239      * All two of these values are immutable: they can only be set once during
240      * construction.
241      */
242     constructor(string memory name_, string memory symbol_) {
243         _name = name_;
244         _symbol = symbol_;
245     }
246 
247     /**
248      * @dev Returns the name of the token.
249      */
250     function name() public view virtual override returns (string memory) {
251         return _name;
252     }
253 
254     /**
255      * @dev Returns the symbol of the token, usually a shorter version of the
256      * name.
257      */
258     function symbol() public view virtual override returns (string memory) {
259         return _symbol;
260     }
261 
262     /**
263      * @dev Returns the number of decimals used to get its user representation.
264      * For example, if `decimals` equals `2`, a balance of `505` tokens should
265      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
266      *
267      * Tokens usually opt for a value of 18, imitating the relationship between
268      * Ether and Wei. This is the value {ERC20} uses, unless this function is
269      * overridden;
270      *
271      * NOTE: This information is only used for _display_ purposes: it in
272      * no way affects any of the arithmetic of the contract, including
273      * {IERC20-balanceOf} and {IERC20-transfer}.
274      */
275     function decimals() public view virtual override returns (uint8) {
276         return 18;
277     }
278 
279     /**
280      * @dev See {IERC20-totalSupply}.
281      */
282     function totalSupply() public view virtual override returns (uint256) {
283         return _totalSupply;
284     }
285 
286     /**
287      * @dev See {IERC20-balanceOf}.
288      */
289     function balanceOf(address account) public view virtual override returns (uint256) {
290         return _balances[account];
291     }
292 
293     /**
294      * @dev See {IERC20-transfer}.
295      *
296      * Requirements:
297      *
298      * - `recipient` cannot be the zero address.
299      * - the caller must have a balance of at least `amount`.
300      */
301     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
302         _transfer(_msgSender(), recipient, amount);
303         return true;
304     }
305 
306     /**
307      * @dev See {IERC20-allowance}.
308      */
309     function allowance(address owner, address spender) public view virtual override returns (uint256) {
310         return _allowances[owner][spender];
311     }
312 
313     /**
314      * @dev See {IERC20-approve}.
315      *
316      * Requirements:
317      *
318      * - `spender` cannot be the zero address.
319      */
320     function approve(address spender, uint256 amount) public virtual override returns (bool) {
321         _approve(_msgSender(), spender, amount);
322         return true;
323     }
324 
325     /**
326      * @dev See {IERC20-transferFrom}.
327      *
328      * Emits an {Approval} event indicating the updated allowance. This is not
329      * required by the EIP. See the note at the beginning of {ERC20}.
330      *
331      * Requirements:
332      *
333      * - `sender` and `recipient` cannot be the zero address.
334      * - `sender` must have a balance of at least `amount`.
335      * - the caller must have allowance for ``sender``'s tokens of at least
336      * `amount`.
337      */
338     function transferFrom(
339         address sender,
340         address recipient,
341         uint256 amount
342     ) public virtual override returns (bool) {
343         _transfer(sender, recipient, amount);
344 
345         uint256 currentAllowance = _allowances[sender][_msgSender()];
346         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
347         unchecked {
348             _approve(sender, _msgSender(), currentAllowance - amount);
349         }
350 
351         return true;
352     }
353 
354     /**
355      * @dev Moves `amount` of tokens from `sender` to `recipient`.
356      *
357      * This internal function is equivalent to {transfer}, and can be used to
358      * e.g. implement automatic token fees, slashing mechanisms, etc.
359      *
360      * Emits a {Transfer} event.
361      *
362      * Requirements:
363      *
364      * - `sender` cannot be the zero address.
365      * - `recipient` cannot be the zero address.
366      * - `sender` must have a balance of at least `amount`.
367      */
368     function _transfer(
369         address sender,
370         address recipient,
371         uint256 amount
372     ) internal virtual {
373         require(sender != address(0), "ERC20: transfer from the zero address");
374         require(recipient != address(0), "ERC20: transfer to the zero address");
375 
376         _beforeTokenTransfer(sender, recipient, amount);
377 
378         uint256 senderBalance = _balances[sender];
379         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
380         unchecked {
381             _balances[sender] = senderBalance - amount;
382         }
383         _balances[recipient] += amount;
384 
385         emit Transfer(sender, recipient, amount);
386 
387         _afterTokenTransfer(sender, recipient, amount);
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
404         _totalSupply += amount;
405         _balances[account] += amount;
406         emit Transfer(address(0), account, amount);
407 
408         _afterTokenTransfer(address(0), account, amount);
409     }
410 
411 
412     /**
413      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
414      *
415      * This internal function is equivalent to `approve`, and can be used to
416      * e.g. set automatic allowances for certain subsystems, etc.
417      *
418      * Emits an {Approval} event.
419      *
420      * Requirements:
421      *
422      * - `owner` cannot be the zero address.
423      * - `spender` cannot be the zero address.
424      */
425     function _approve(
426         address owner,
427         address spender,
428         uint256 amount
429     ) internal virtual {
430         require(owner != address(0), "ERC20: approve from the zero address");
431         require(spender != address(0), "ERC20: approve to the zero address");
432 
433         _allowances[owner][spender] = amount;
434         emit Approval(owner, spender, amount);
435     }
436 
437     /**
438      * @dev Hook that is called before any transfer of tokens. This includes
439      * minting and burning.
440      *
441      * Calling conditions:
442      *
443      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
444      * will be transferred to `to`.
445      * - when `from` is zero, `amount` tokens will be minted for `to`.
446      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
447      * - `from` and `to` are never both zero.
448      *
449      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
450      */
451     function _beforeTokenTransfer(
452         address from,
453         address to,
454         uint256 amount
455     ) internal virtual {}
456 
457     /**
458      * @dev Hook that is called after any transfer of tokens. This includes
459      * minting and burning.
460      *
461      * Calling conditions:
462      *
463      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
464      * has been transferred to `to`.
465      * - when `from` is zero, `amount` tokens have been minted for `to`.
466      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
467      * - `from` and `to` are never both zero.
468      *
469      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
470      */
471     function _afterTokenTransfer(
472         address from,
473         address to,
474         uint256 amount
475     ) internal virtual {}
476 }
477 
478 /**
479  * @dev Wrappers over Solidity's arithmetic operations.
480  *
481  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
482  * now has built in overflow checking.
483  */
484 library SafeMath {
485     /**
486      * @dev Returns the addition of two unsigned integers, with an overflow flag.
487      *
488      * _Available since v3.4._
489      */
490     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
491         unchecked {
492             uint256 c = a + b;
493             if (c < a) return (false, 0);
494             return (true, c);
495         }
496     }
497 
498     /**
499      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
500      *
501      * _Available since v3.4._
502      */
503     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
504         unchecked {
505             if (b > a) return (false, 0);
506             return (true, a - b);
507         }
508     }
509 
510     /**
511      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
512      *
513      * _Available since v3.4._
514      */
515     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
516         unchecked {
517             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
518             // benefit is lost if 'b' is also tested.
519             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
520             if (a == 0) return (true, 0);
521             uint256 c = a * b;
522             if (c / a != b) return (false, 0);
523             return (true, c);
524         }
525     }
526 
527     /**
528      * @dev Returns the division of two unsigned integers, with a division by zero flag.
529      *
530      * _Available since v3.4._
531      */
532     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
533         unchecked {
534             if (b == 0) return (false, 0);
535             return (true, a / b);
536         }
537     }
538 
539     /**
540      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
541      *
542      * _Available since v3.4._
543      */
544     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
545         unchecked {
546             if (b == 0) return (false, 0);
547             return (true, a % b);
548         }
549     }
550 
551     /**
552      * @dev Returns the addition of two unsigned integers, reverting on
553      * overflow.
554      *
555      * Counterpart to Solidity's `+` operator.
556      *
557      * Requirements:
558      *
559      * - Addition cannot overflow.
560      */
561     function add(uint256 a, uint256 b) internal pure returns (uint256) {
562         return a + b;
563     }
564 
565     /**
566      * @dev Returns the subtraction of two unsigned integers, reverting on
567      * overflow (when the result is negative).
568      *
569      * Counterpart to Solidity's `-` operator.
570      *
571      * Requirements:
572      *
573      * - Subtraction cannot overflow.
574      */
575     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
576         return a - b;
577     }
578 
579     /**
580      * @dev Returns the multiplication of two unsigned integers, reverting on
581      * overflow.
582      *
583      * Counterpart to Solidity's `*` operator.
584      *
585      * Requirements:
586      *
587      * - Multiplication cannot overflow.
588      */
589     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
590         return a * b;
591     }
592 
593     /**
594      * @dev Returns the integer division of two unsigned integers, reverting on
595      * division by zero. The result is rounded towards zero.
596      *
597      * Counterpart to Solidity's `/` operator.
598      *
599      * Requirements:
600      *
601      * - The divisor cannot be zero.
602      */
603     function div(uint256 a, uint256 b) internal pure returns (uint256) {
604         return a / b;
605     }
606 
607     /**
608      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
609      * reverting when dividing by zero.
610      *
611      * Counterpart to Solidity's `%` operator. This function uses a `revert`
612      * opcode (which leaves remaining gas untouched) while Solidity uses an
613      * invalid opcode to revert (consuming all remaining gas).
614      *
615      * Requirements:
616      *
617      * - The divisor cannot be zero.
618      */
619     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
620         return a % b;
621     }
622 
623     /**
624      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
625      * overflow (when the result is negative).
626      *
627      * CAUTION: This function is deprecated because it requires allocating memory for the error
628      * message unnecessarily. For custom revert reasons use {trySub}.
629      *
630      * Counterpart to Solidity's `-` operator.
631      *
632      * Requirements:
633      *
634      * - Subtraction cannot overflow.
635      */
636     function sub(
637         uint256 a,
638         uint256 b,
639         string memory errorMessage
640     ) internal pure returns (uint256) {
641         unchecked {
642             require(b <= a, errorMessage);
643             return a - b;
644         }
645     }
646 
647     /**
648      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
649      * division by zero. The result is rounded towards zero.
650      *
651      * Counterpart to Solidity's `/` operator. Note: this function uses a
652      * `revert` opcode (which leaves remaining gas untouched) while Solidity
653      * uses an invalid opcode to revert (consuming all remaining gas).
654      *
655      * Requirements:
656      *
657      * - The divisor cannot be zero.
658      */
659     function div(
660         uint256 a,
661         uint256 b,
662         string memory errorMessage
663     ) internal pure returns (uint256) {
664         unchecked {
665             require(b > 0, errorMessage);
666             return a / b;
667         }
668     }
669 
670     /**
671      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
672      * reverting with custom message when dividing by zero.
673      *
674      * CAUTION: This function is deprecated because it requires allocating memory for the error
675      * message unnecessarily. For custom revert reasons use {tryMod}.
676      *
677      * Counterpart to Solidity's `%` operator. This function uses a `revert`
678      * opcode (which leaves remaining gas untouched) while Solidity uses an
679      * invalid opcode to revert (consuming all remaining gas).
680      *
681      * Requirements:
682      *
683      * - The divisor cannot be zero.
684      */
685     function mod(
686         uint256 a,
687         uint256 b,
688         string memory errorMessage
689     ) internal pure returns (uint256) {
690         unchecked {
691             require(b > 0, errorMessage);
692             return a % b;
693         }
694     }
695 }
696 
697 interface IUniswapV2Factory {
698     event PairCreated(
699         address indexed token0,
700         address indexed token1,
701         address pair,
702         uint256
703     );
704 
705     function createPair(address tokenA, address tokenB)
706         external
707         returns (address pair);
708 }
709 
710 interface IUniswapV2Router02 {
711     function factory() external pure returns (address);
712 
713     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
714         uint256 amountIn,
715         uint256 amountOutMin,
716         address[] calldata path,
717         address to,
718         uint256 deadline
719     ) external;
720 }
721 
722 contract MIDAS is ERC20, Ownable {
723     using SafeMath for uint256;
724 
725     IUniswapV2Router02 public immutable uniswapV2Router;
726     address public immutable uniswapV2Pair;
727  
728     address public pairedToken = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;
729     address public routerUni = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
730 
731     bool private swapping;
732 
733     uint256 public maxTransactionAmount;
734     uint256 public swapTokensAtAmount;
735     uint256 public maxWallet;
736 
737     bool public limitsInEffect = true;
738     bool public tradingActive = false;
739     bool public swapEnabled = false;
740 
741     // Anti-bot and anti-whale mappings and variables
742     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
743     bool public transferDelayEnabled = true;
744     uint256 private launchBlock;
745     uint256 private deadBlocks;
746     mapping(address => bool) public blocked;
747 
748     uint256 public buyTotalFees;
749     uint256 public sellTotalFees;
750 
751     // exclude from fees and max transaction amount
752     mapping(address => bool) private _isExcludedFromFees;
753     mapping(address => bool) public _isExcludedMaxTransactionAmount;
754 
755     Distributor tokenDistributor;
756 
757     event ExcludeFromFees(address indexed account, bool isExcluded);
758 
759     event WalletsUpdated(
760         address newTreasuryWallet,
761         address newDevelopmentWallet,
762         address newMarketingWallet,
763         address newDeployerWallet
764     );
765 
766     constructor() ERC20("Hand of Midas", "MIDAS") {
767         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
768             routerUni
769         );
770 
771         excludeFromMaxTransaction(address(_uniswapV2Router), true);
772         uniswapV2Router = _uniswapV2Router;
773 
774         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
775             .createPair(address(this), pairedToken);
776         excludeFromMaxTransaction(address(uniswapV2Pair), true);
777 
778         uint256 totalSupply = 100_000_000 * 1e18;
779 
780         maxTransactionAmount =  totalSupply * 1 / 100; // 1% 
781         maxWallet = totalSupply * 2 / 100; // 2% 
782         swapTokensAtAmount = (totalSupply * 20) / 10000; // 0.2%
783 
784         buyTotalFees = 5;
785         sellTotalFees = 5;
786 
787         address treasuryWallet = 0x5e4BECEA2FC6558a37bDc78dE047fEb21835e083;
788         address developmentWallet = 0xCe18230c58c3191Ef7b065AbcE65021FeFbA67F5;
789         address marketingWallet = 0xaC3bE69904B62EDd0cB433eeE4342ef0BE92dc30;
790         address deployerWallet = 0x825cb6E98d0c5D8c762F901d6f9E8B02bee95D27;
791 
792         uint256 treasuryShare = 25;
793         uint256 developmentShare = 25;
794         uint256 marketingShare = 25;
795         uint256 deployerShare = 25;
796 
797         tokenDistributor = new Distributor(
798             pairedToken,
799             treasuryWallet,
800             developmentWallet,
801             marketingWallet,
802             deployerWallet,
803             treasuryShare,
804             developmentShare,
805             marketingShare,
806             deployerShare);
807 
808         // exclude from paying fees or having max transaction amount
809         excludeFromFees(owner(), true);
810         excludeFromFees(address(this), true);
811         excludeFromFees(address(0xdead), true);
812 
813         excludeFromMaxTransaction(owner(), true);
814         excludeFromMaxTransaction(address(this), true);
815         excludeFromMaxTransaction(address(0xdead), true);
816 
817         /*
818             _mint is an internal function in ERC20.sol that is only called here,
819             and CANNOT be called ever again
820         */
821         _mint(msg.sender, totalSupply);
822     }
823 
824     receive() external payable {}
825 
826     function enableTrading(uint256 _deadBlocks) external onlyOwner {
827         require(!tradingActive, "Token launched");
828         tradingActive = true;
829         launchBlock = block.number;
830         swapEnabled = true;
831         deadBlocks = _deadBlocks;
832     }
833     // remove limits after token is stable
834     function removeLimits() external onlyOwner returns (bool) {
835         limitsInEffect = false;
836         return true;
837     }
838 
839         function disableTransferDelay() external onlyOwner returns (bool) {
840         transferDelayEnabled = false;
841         return true;
842     }
843 
844     // change the minimum amount of tokens to sell from fees
845     function updateSwapTokensAtAmount(uint256 newAmount)
846         external
847         onlyOwner
848         returns (bool)
849     {
850         require(
851             newAmount >= (totalSupply() * 1) / 100000,
852             "Swap amount cannot be lower than 0.001% total supply."
853         );
854         require(
855             newAmount <= (totalSupply() * 5) / 1000,
856             "Swap amount cannot be higher than 0.5% total supply."
857         );
858         swapTokensAtAmount = newAmount;
859         return true;
860     }
861 
862     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
863         require(
864             newNum >= ((totalSupply() * 1) / 1000) / 1e18,
865             "Cannot set maxTransactionAmount lower than 0.1%"
866         );
867         maxTransactionAmount = newNum * (10**18);
868     }
869 
870     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
871         require(
872             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
873             "Cannot set maxWallet lower than 0.5%"
874         );
875         maxWallet = newNum * (10**18);
876     }
877 
878     function excludeFromMaxTransaction(address updAds, bool isEx)
879         public
880         onlyOwner
881     {
882         _isExcludedMaxTransactionAmount[updAds] = isEx;
883     }
884 
885     // only use to disable contract sales if absolutely necessary (emergency use only)
886     function updateSwapEnabled(bool enabled) external onlyOwner {
887         swapEnabled = enabled;
888     }
889 
890     function updateBuyFees(
891         uint256 _buyFee
892     ) external onlyOwner {
893         buyTotalFees = _buyFee;
894     }
895 
896     function updateSellFees(
897         uint256 _sellFee
898     ) external onlyOwner {
899         sellTotalFees = _sellFee;
900     }
901 
902     function updateRatios(
903         uint256 _treasuryShare,
904         uint256 _developmentShare,
905         uint256 _marketingShare,
906         uint256 _deployerShare
907     ) external onlyOwner {
908         assert(_treasuryShare + _developmentShare + _marketingShare + _deployerShare == 100);
909         tokenDistributor.updateRatios(
910             _treasuryShare,
911             _developmentShare,
912             _marketingShare,
913             _deployerShare);
914     }
915 
916     function excludeFromFees(address account, bool excluded) public onlyOwner {
917         _isExcludedFromFees[account] = excluded;
918         emit ExcludeFromFees(account, excluded);
919     }
920 
921     function updateWallets(
922         address newTreasuryWallet,
923         address newDevelopmentWallet,
924         address newMarketingWallet,
925         address newDeployerWallet)
926         external
927         onlyOwner
928     {
929         tokenDistributor.updateWallets(
930             newTreasuryWallet,
931             newDevelopmentWallet,
932             newMarketingWallet,
933             newDeployerWallet
934         );
935         emit WalletsUpdated(
936             newTreasuryWallet,
937             newDevelopmentWallet,
938             newMarketingWallet,
939             newDeployerWallet);
940     }
941 
942     function isExcludedFromFees(address account) public view returns (bool) {
943         return _isExcludedFromFees[account];
944     }
945 
946     event BoughtEarly(address indexed sniper);
947 
948     function _transfer(
949         address from,
950         address to,
951         uint256 amount
952     ) internal override {
953         require(from != address(0), "ERC20: transfer from the zero address");
954         require(to != address(0), "ERC20: transfer to the zero address");
955         require(!blocked[from], "Sniper blocked");
956 
957         if (amount == 0) {
958             super._transfer(from, to, 0);
959             return;
960         }
961 
962         if (limitsInEffect) {
963             if (
964                 from != owner() &&
965                 to != owner() &&
966                 to != address(0) &&
967                 to != address(0xdead) &&
968                 !swapping
969             ) {
970                 if (!tradingActive) {
971                     require(
972                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
973                         "Trading is not active."
974                     );
975                 }
976 
977                 if(block.number <= launchBlock + deadBlocks && from == address(uniswapV2Pair) &&  
978                 to != routerUni && to != address(this) && to != address(uniswapV2Pair)){
979                     blocked[to] = true;
980                     emit BoughtEarly(to);
981                 }
982 
983                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.
984                 if (transferDelayEnabled) {
985                     if (
986                         to != owner() &&
987                         to != routerUni &&
988                         to != address(uniswapV2Pair)
989                     ) {
990                         require(
991                             _holderLastTransferTimestamp[tx.origin] <
992                                 block.number,
993                             "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
994                         );
995                         _holderLastTransferTimestamp[tx.origin] = block.number;
996                     }
997                 }
998 
999                 if (
1000                     from == uniswapV2Pair &&
1001                     !_isExcludedMaxTransactionAmount[to]
1002                 ) {
1003                     require(
1004                         amount <= maxTransactionAmount,
1005                         "Buy transfer amount exceeds the maxTransactionAmount."
1006                     );
1007                     require(
1008                         amount + balanceOf(to) <= maxWallet,
1009                         "Max wallet exceeded"
1010                     );
1011                 }
1012                 else if (!_isExcludedMaxTransactionAmount[to]) {
1013                     require(
1014                         amount + balanceOf(to) <= maxWallet,
1015                         "Max wallet exceeded"
1016                     );
1017                 }
1018             }
1019         }
1020 
1021         uint256 contractTokenBalance = balanceOf(address(this));
1022 
1023         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1024 
1025         if (
1026             canSwap &&
1027             swapEnabled &&
1028             !swapping &&
1029             to == uniswapV2Pair &&
1030             !_isExcludedFromFees[from] &&
1031             !_isExcludedFromFees[to]
1032         ) {
1033             swapping = true;
1034 
1035             swapBack();
1036 
1037             swapping = false;
1038         }
1039 
1040         bool takeFee = !swapping;
1041 
1042         // if any account belongs to _isExcludedFromFee account then remove the fee
1043         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1044             takeFee = false;
1045         }
1046 
1047         uint256 fees = 0;
1048 
1049         // only take fees on buys/sells, do not take on wallet transfers
1050         if (takeFee) {
1051             // on sell
1052             if (to == uniswapV2Pair && sellTotalFees > 0) {
1053                 fees = amount.mul(sellTotalFees).div(100);
1054             }
1055             // on buy
1056             else if (from == uniswapV2Pair && buyTotalFees > 0) {
1057                 fees = amount.mul(buyTotalFees).div(100);
1058             }
1059 
1060             if (fees> 0) {
1061                 super._transfer(from, address(this), fees);
1062             }
1063           
1064             amount -= fees;
1065         }
1066 
1067         super._transfer(from, to, amount);
1068     }
1069 
1070     function swapTokensForPairedToken(uint256 tokenAmount) private {
1071         // generate the uniswap pair path of token -> weth
1072         address[] memory path = new address[](2);
1073         path[0] = address(this);
1074         path[1] = pairedToken;
1075         _approve(address(this), address(uniswapV2Router), tokenAmount);
1076 
1077         // make the swap
1078         uniswapV2Router.swapExactTokensForTokensSupportingFeeOnTransferTokens(
1079             tokenAmount,
1080             0, // accept any amount of pairedToken
1081             path,
1082             address(tokenDistributor),
1083             block.timestamp
1084         );
1085     }
1086 
1087     function multiBlock(address[] calldata blockees, bool shouldBlock) external onlyOwner {
1088         for(uint256 i = 0;i<blockees.length;i++){
1089             address blockee = blockees[i];
1090             if(blockee != address(this) && 
1091                blockee != routerUni && 
1092                blockee != address(uniswapV2Pair))
1093                 blocked[blockee] = shouldBlock;
1094         }
1095     }
1096 
1097     function swapBack() private {
1098         uint256 contractBalance = balanceOf(address(this));
1099         if (contractBalance == 0) {
1100             return;
1101         }
1102 
1103         if (contractBalance > swapTokensAtAmount * 20) {
1104             contractBalance = swapTokensAtAmount * 20;
1105         }
1106 
1107         swapTokensForPairedToken(contractBalance);
1108 
1109         tokenDistributor.clearUSDC();
1110     }
1111 
1112     function clearUSDC() public {
1113         tokenDistributor.clearUSDC();
1114     }
1115 }
1116 
1117 contract Distributor{
1118 
1119     address immutable deployer;
1120     IERC20 immutable token;
1121 
1122     address treasuryWallet;
1123     address developmentWallet;
1124     address marketingWallet;
1125     address deployerWallet;
1126 
1127     uint256 treasuryShare;
1128     uint256 developmentShare;
1129     uint256 marketingShare;
1130     uint256 deployerShare;
1131 
1132     constructor(
1133         address _token, 
1134         address _treasuryWallet, 
1135         address _developmentWallet, 
1136         address _marketingWallet, 
1137         address _deployerWallet, 
1138         uint256 _treasuryShare,
1139         uint256 _developmentShare,
1140         uint256 _marketingShare,
1141         uint256 _deployerShare)
1142         {
1143             deployer = msg.sender;
1144             token = IERC20(_token);
1145 
1146             treasuryWallet = _treasuryWallet;
1147             developmentWallet = _developmentWallet;
1148             marketingWallet = _marketingWallet;
1149             deployerWallet = _deployerWallet;
1150 
1151             treasuryShare = _treasuryShare;
1152             developmentShare = _developmentShare;
1153             marketingShare = _marketingShare;
1154             deployerShare = _deployerShare;
1155     }
1156 
1157     function updateRatios(
1158         uint256 _treasuryShare,
1159         uint256 _developmentShare,
1160         uint256 _marketingShare,
1161         uint256 _deployerShare
1162     ) external 
1163         {
1164             require(msg.sender == deployer);
1165             treasuryShare = _treasuryShare;
1166             developmentShare = _developmentShare;
1167             marketingShare = _marketingShare;
1168             deployerShare = _deployerShare;
1169     }
1170 
1171     function updateWallets(
1172         address newTreasuryWallet,
1173         address newDevelopmentWallet,
1174         address newMarketingWallet,
1175         address newDeployerWallet)
1176         external 
1177         {
1178             require(msg.sender == deployer);
1179             treasuryWallet = newTreasuryWallet;
1180             developmentWallet = newDevelopmentWallet;
1181             marketingWallet = newMarketingWallet;
1182             deployerWallet = newDeployerWallet;
1183     }
1184 
1185     function clearUSDC() public {
1186         uint256 tokensToTransfer = token.balanceOf(address(this));
1187         token.transfer(treasuryWallet, tokensToTransfer * treasuryShare / 100);
1188         token.transfer(developmentWallet, tokensToTransfer * developmentShare / 100);
1189         token.transfer(marketingWallet, tokensToTransfer * marketingShare / 100);
1190         token.transfer(deployerWallet, tokensToTransfer * deployerShare / 100);
1191     }
1192 }