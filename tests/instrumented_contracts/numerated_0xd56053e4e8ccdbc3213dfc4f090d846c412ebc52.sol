1 /*
2 What if I told you I know of a yield protocol that's going to $1B?  
3 
4 I know who made it, and what their intentions are.
5 
6 ------------------------------------------------------------------------------------------------------------
7 
8 What if I told you crypto was meant to be simple?
9 
10 You don't need a whitepaper, website, TG, Twitter, and endless hype to become a successful project.
11 
12 Is it a coicidence that so many succeful projects recently launched are paired with a stable token?
13 Hex, Tsuka, Lasrever, Amplifi, Spiral. What do they know, anon? Is something about to...change?
14 
15 ------------------------------------------------------------------------------------------------------------
16 
17 The Stabilizer will focus exclusively on acquiring as large of a position as possible in this protocol.
18 
19 You might ask why you wouldn't just buy this token yourself? Answer: You might, but if we pool resources,
20 we can obtain some degree of influence over the protocol before institutional capital pours into that
21 project. Think of how Convex controls Curve.
22 
23 All I can say is that I am a skeleton, and the frog is not just a frog. If you only knew who was behind this...
24 
25 --------------------------------------------------------------------------------------------------------------
26 
27 The Stabilizer(Stablz) - Version 2.0
28 
29 Taxes (5% buy / 5% sell) 100% of tax revenue will go to the purchase and distribution of the above mentioned yield protocol.
30 
31 Rewards from yield protocol treasury will buyback The Stabilizer token, forever STABILIZING it.
32 
33 (The purpose of this token is to Stabilize your portfolio, I will lower tax to 6/6 before renounce, an
34 early sell penalty will be imposed during the initial launch period).
35 
36 https://t.me/TheStabilizer
37 
38 */
39 
40 // SPDX-License-Identifier: MIT
41 pragma solidity ^0.8.10;
42 pragma experimental ABIEncoderV2;
43 
44 
45 /* pragma solidity ^0.8.0; */
46 
47 
48 abstract contract Context {
49     function _msgSender() internal view virtual returns (address) {
50         return msg.sender;
51     }
52 
53     function _msgData() internal view virtual returns (bytes calldata) {
54         return msg.data;
55     }
56 }
57 
58 ////// lib/openzeppelin-contracts/contracts/access/Ownable.sol
59 // OpenZeppelin Contracts v4.4.0 (access/Ownable.sol)
60 
61 /* pragma solidity ^0.8.0; */
62 
63 /* import "../utils/Context.sol"; */
64 
65 /**
66  * @dev Contract module which provides a basic access control mechanism, where
67  * there is an account (an owner) that can be granted exclusive access to
68  * specific functions.
69  *
70  * By default, the owner account will be the one that deploys the contract. This
71  * can later be changed with {transferOwnership}.
72  *
73  * This module is used through inheritance. It will make available the modifier
74  * `onlyOwner`, which can be applied to your functions to restrict their use to
75  * the owner.
76  */
77 abstract contract Ownable is Context {
78     address private _owner;
79 
80     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
81 
82     /**
83      * @dev Initializes the contract setting the deployer as the initial owner.
84      */
85     constructor() {
86         _transferOwnership(_msgSender());
87     }
88 
89     /**
90      * @dev Returns the address of the current owner.
91      */
92     function owner() public view virtual returns (address) {
93         return _owner;
94     }
95 
96     /**
97      * @dev Throws if called by any account other than the owner.
98      */
99     modifier onlyOwner() {
100         require(owner() == _msgSender(), "Ownable: caller is not the owner");
101         _;
102     }
103 //A
104     /**
105      * @dev Leaves the contract without owner. It will not be possible to call
106      * `onlyOwner` functions anymore. Can only be called by the current owner.
107      *
108      * NOTE: Renouncing ownership will leave the contract without an owner,
109      * thereby removing any functionality that is only available to the owner.
110      */
111     function renounceOwnership() public virtual onlyOwner {
112         _transferOwnership(address(0));
113     }
114 
115     /**
116      * @dev Transfers ownership of the contract to a new account (`newOwner`).
117      * Can only be called by the current owner.
118      */
119     function transferOwnership(address newOwner) public virtual onlyOwner {
120         require(newOwner != address(0), "Ownable: new owner is the zero address");
121         _transferOwnership(newOwner);
122     }
123 
124     /**
125      * @dev Transfers ownership of the contract to a new account (`newOwner`).
126      * Internal function without access restriction.
127      */
128     function _transferOwnership(address newOwner) internal virtual {
129         address oldOwner = _owner;
130         _owner = newOwner;
131         emit OwnershipTransferred(oldOwner, newOwner);
132     }
133 }
134 
135 ////// lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol
136 // OpenZeppelin Contracts v4.4.0 (token/ERC20/IERC20.sol)
137 
138 /* pragma solidity ^0.8.0; */
139 
140 /**
141  * @dev Interface of the ERC20 standard as defined in the EIP.
142  */
143 interface IERC20 {
144     /**
145      * @dev Returns the amount of tokens in existence.
146      */
147     function totalSupply() external view returns (uint256);
148 
149     /**
150      * @dev Returns the amount of tokens owned by `account`.
151      */
152     function balanceOf(address account) external view returns (uint256);
153 
154     /**
155      * @dev Moves `amount` tokens from the caller's account to `recipient`.
156      *
157      * Returns a boolean value indicating whether the operation succeeded.
158      *
159      * Emits a {Transfer} event.
160      */
161     function transfer(address recipient, uint256 amount) external returns (bool);
162 
163     /**
164      * @dev Returns the remaining number of tokens that `spender` will be
165      * allowed to spend on behalf of `owner` through {transferFrom}. This is
166      * zero by default.
167      *
168      * This value changes when {approve} or {transferFrom} are called.
169      */
170     function allowance(address owner, address spender) external view returns (uint256);
171 
172     /**
173      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
174      *
175      * Returns a boolean value indicating whether the operation succeeded.
176      *
177      * IMPORTANT: Beware that changing an allowance with this method brings the risk
178      * that someone may use both the old and the new allowance by unfortunate
179      * transaction ordering. One possible solution to mitigate this race
180      * condition is to first reduce the spender's allowance to 0 and set the
181      * desired value afterwards:
182      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
183      *
184      * Emits an {Approval} event.
185      */
186     function approve(address spender, uint256 amount) external returns (bool);
187 
188     /**
189      * @dev Moves `amount` tokens from `sender` to `recipient` using the
190      * allowance mechanism. `amount` is then deducted from the caller's
191      * allowance.
192      *
193      * Returns a boolean value indicating whether the operation succeeded.
194      *
195      * Emits a {Transfer} event.
196      */
197     function transferFrom(
198         address sender,
199         address recipient,
200         uint256 amount
201     ) external returns (bool);
202 //M
203     /**
204      * @dev Emitted when `value` tokens are moved from one account (`from`) to
205      * another (`to`).
206      *
207      * Note that `value` may be zero.
208      */
209     event Transfer(address indexed from, address indexed to, uint256 value);
210 
211     /**
212      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
213      * a call to {approve}. `value` is the new allowance.
214      */
215     event Approval(address indexed owner, address indexed spender, uint256 value);
216 }
217 
218 ////// lib/openzeppelin-contracts/contracts/token/ERC20/extensions/IERC20Metadata.sol
219 // OpenZeppelin Contracts v4.4.0 (token/ERC20/extensions/IERC20Metadata.sol)
220 
221 /* pragma solidity ^0.8.0; */
222 
223 /* import "../IERC20.sol"; */
224 
225 /**
226  * @dev Interface for the optional metadata functions from the ERC20 standard.
227  *
228  * _Available since v4.1._
229  */
230 interface IERC20Metadata is IERC20 {
231     /**
232      * @dev Returns the name of the token.
233      */
234     function name() external view returns (string memory);
235 
236     /**
237      * @dev Returns the symbol of the token.
238      */
239     function symbol() external view returns (string memory);
240 
241     /**
242      * @dev Returns the decimals places of the token.
243      */
244     function decimals() external view returns (uint8);
245 }
246 
247 ////// lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol
248 // OpenZeppelin Contracts v4.4.0 (token/ERC20/ERC20.sol)
249 
250 /* pragma solidity ^0.8.0; */
251 
252 /* import "./IERC20.sol"; */
253 /* import "./extensions/IERC20Metadata.sol"; */
254 /* import "../../utils/Context.sol"; */
255 
256 /**
257  * @dev Implementation of the {IERC20} interface.
258  *
259  * This implementation is agnostic to the way tokens are created. This means
260  * that a supply mechanism has to be added in a derived contract using {_mint}.
261  * For a generic mechanism see {ERC20PresetMinterPauser}.
262  *
263  * TIP: For a detailed writeup see our guide
264  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
265  * to implement supply mechanisms].
266  *
267  * We have followed general OpenZeppelin Contracts guidelines: functions revert
268  * instead returning `false` on failure. This behavior is nonetheless
269  * conventional and does not conflict with the expectations of ERC20
270  * applications.
271  *
272  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
273  * This allows applications to reconstruct the allowance for all accounts just
274  * by listening to said events. Other implementations of the EIP may not emit
275  * these events, as it isn't required by the specification.
276  *
277  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
278  * functions have been added to mitigate the well-known issues around setting
279  * allowances. See {IERC20-approve}.
280  */
281 contract ERC20 is Context, IERC20, IERC20Metadata {
282     mapping(address => uint256) private _balances;
283 
284     mapping(address => mapping(address => uint256)) private _allowances;
285 
286     uint256 private _totalSupply;
287 
288     string private _name;
289     string private _symbol;
290 
291     /**
292      * @dev Sets the values for {name} and {symbol}.
293      *
294      * The default value of {decimals} is 18. To select a different value for
295      * {decimals} you should overload it.
296      *
297      * All two of these values are immutable: they can only be set once during
298      * construction.
299      */
300     constructor(string memory name_, string memory symbol_) {
301         _name = name_;
302         _symbol = symbol_;
303     }
304 //P
305     /**
306      * @dev Returns the name of the token.
307      */
308     function name() public view virtual override returns (string memory) {
309         return _name;
310     }
311 
312     /**
313      * @dev Returns the symbol of the token, usually a shorter version of the
314      * name.
315      */
316     function symbol() public view virtual override returns (string memory) {
317         return _symbol;
318     }
319 
320     /**
321      * @dev Returns the number of decimals used to get its user representation.
322      * For example, if `decimals` equals `2`, a balance of `505` tokens should
323      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
324      *
325      * Tokens usually opt for a value of 18, imitating the relationship between
326      * Ether and Wei. This is the value {ERC20} uses, unless this function is
327      * overridden;
328      *
329      * NOTE: This information is only used for _display_ purposes: it in
330      * no way affects any of the arithmetic of the contract, including
331      * {IERC20-balanceOf} and {IERC20-transfer}.
332      */
333     function decimals() public view virtual override returns (uint8) {
334         return 18;
335     }
336 
337     /**
338      * @dev See {IERC20-totalSupply}.
339      */
340     function totalSupply() public view virtual override returns (uint256) {
341         return _totalSupply;
342     }
343 
344     /**
345      * @dev See {IERC20-balanceOf}.
346      */
347     function balanceOf(address account) public view virtual override returns (uint256) {
348         return _balances[account];
349     }
350 
351     /**
352      * @dev See {IERC20-transfer}.
353      *
354      * Requirements:
355      *
356      * - `recipient` cannot be the zero address.
357      * - the caller must have a balance of at least `amount`.
358      */
359     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
360         _transfer(_msgSender(), recipient, amount);
361         return true;
362     }
363 
364     /**
365      * @dev See {IERC20-allowance}.
366      */
367     function allowance(address owner, address spender) public view virtual override returns (uint256) {
368         return _allowances[owner][spender];
369     }
370 
371     /**
372      * @dev See {IERC20-approve}.
373      *
374      * Requirements:
375      *
376      * - `spender` cannot be the zero address.
377      */
378     function approve(address spender, uint256 amount) public virtual override returns (bool) {
379         _approve(_msgSender(), spender, amount);
380         return true;
381     }
382 
383     /**
384      * @dev See {IERC20-transferFrom}.
385      *
386      * Emits an {Approval} event indicating the updated allowance. This is not
387      * required by the EIP. See the note at the beginning of {ERC20}.
388      *
389      * Requirements:
390      *
391      * - `sender` and `recipient` cannot be the zero address.
392      * - `sender` must have a balance of at least `amount`.
393      * - the caller must have allowance for ``sender``'s tokens of at least
394      * `amount`.
395      */
396     function transferFrom(
397         address sender,
398         address recipient,
399         uint256 amount
400     ) public virtual override returns (bool) {
401         _transfer(sender, recipient, amount);
402 
403         uint256 currentAllowance = _allowances[sender][_msgSender()];
404         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
405         unchecked {
406             _approve(sender, _msgSender(), currentAllowance - amount);
407         }
408 //L
409         return true;
410     }
411 
412     /**
413      * @dev Moves `amount` of tokens from `sender` to `recipient`.
414      *
415      * This internal function is equivalent to {transfer}, and can be used to
416      * e.g. implement automatic token fees, slashing mechanisms, etc.
417      *
418      * Emits a {Transfer} event.
419      *
420      * Requirements:
421      *
422      * - `sender` cannot be the zero address.
423      * - `recipient` cannot be the zero address.
424      * - `sender` must have a balance of at least `amount`.
425      */
426     function _transfer(
427         address sender,
428         address recipient,
429         uint256 amount
430     ) internal virtual {
431         require(sender != address(0), "ERC20: transfer from the zero address");
432         require(recipient != address(0), "ERC20: transfer to the zero address");
433 
434         _beforeTokenTransfer(sender, recipient, amount);
435 
436         uint256 senderBalance = _balances[sender];
437         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
438         unchecked {
439             _balances[sender] = senderBalance - amount;
440         }
441         _balances[recipient] += amount;
442 
443         emit Transfer(sender, recipient, amount);
444 
445         _afterTokenTransfer(sender, recipient, amount);
446     }
447 
448     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
449      * the total supply.
450      *
451      * Emits a {Transfer} event with `from` set to the zero address.
452      *
453      * Requirements:
454      *
455      * - `account` cannot be the zero address.
456      */
457     function _mint(address account, uint256 amount) internal virtual {
458         require(account != address(0), "ERC20: mint to the zero address");
459 
460         _beforeTokenTransfer(address(0), account, amount);
461 
462         _totalSupply += amount;
463         _balances[account] += amount;
464         emit Transfer(address(0), account, amount);
465 
466         _afterTokenTransfer(address(0), account, amount);
467     }
468 
469 
470     /**
471      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
472      *
473      * This internal function is equivalent to `approve`, and can be used to
474      * e.g. set automatic allowances for certain subsystems, etc.
475      *
476      * Emits an {Approval} event.
477      *
478      * Requirements:
479      *
480      * - `owner` cannot be the zero address.
481      * - `spender` cannot be the zero address.
482      */
483     function _approve(
484         address owner,
485         address spender,
486         uint256 amount
487     ) internal virtual {
488         require(owner != address(0), "ERC20: approve from the zero address");
489         require(spender != address(0), "ERC20: approve to the zero address");
490 
491         _allowances[owner][spender] = amount;
492         emit Approval(owner, spender, amount);
493     }
494 //I
495     /**
496      * @dev Hook that is called before any transfer of tokens. This includes
497      * minting and burning.
498      *
499      * Calling conditions:
500      *
501      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
502      * will be transferred to `to`.
503      * - when `from` is zero, `amount` tokens will be minted for `to`.
504      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
505      * - `from` and `to` are never both zero.
506      *
507      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
508      */
509     function _beforeTokenTransfer(
510         address from,
511         address to,
512         uint256 amount
513     ) internal virtual {}
514 
515     /**
516      * @dev Hook that is called after any transfer of tokens. This includes
517      * minting and burning.
518      *
519      * Calling conditions:
520      *
521      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
522      * has been transferred to `to`.
523      * - when `from` is zero, `amount` tokens have been minted for `to`.
524      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
525      * - `from` and `to` are never both zero.
526      *
527      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
528      */
529     function _afterTokenTransfer(
530         address from,
531         address to,
532         uint256 amount
533     ) internal virtual {}
534 }
535 
536 ////// lib/openzeppelin-contracts/contracts/utils/math/SafeMath.sol
537 // OpenZeppelin Contracts v4.4.0 (utils/math/SafeMath.sol)
538 
539 /* pragma solidity ^0.8.0; */
540 
541 // CAUTION
542 // This version of SafeMath should only be used with Solidity 0.8 or later,
543 // because it relies on the compiler's built in overflow checks.
544 
545 /**
546  * @dev Wrappers over Solidity's arithmetic operations.
547  *
548  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
549  * now has built in overflow checking.
550  */
551 library SafeMath {
552     /**
553      * @dev Returns the addition of two unsigned integers, with an overflow flag.
554      *
555      * _Available since v3.4._
556      */
557     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
558         unchecked {
559             uint256 c = a + b;
560             if (c < a) return (false, 0);
561             return (true, c);
562         }
563     }
564 
565     /**
566      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
567      *
568      * _Available since v3.4._
569      */
570     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
571         unchecked {
572             if (b > a) return (false, 0);
573             return (true, a - b);
574         }
575     }
576 
577     /**
578      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
579      *
580      * _Available since v3.4._
581      */
582     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
583         unchecked {
584             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
585             // benefit is lost if 'b' is also tested.
586             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
587             if (a == 0) return (true, 0);
588             uint256 c = a * b;
589             if (c / a != b) return (false, 0);
590             return (true, c);
591         }
592     }
593 //F
594     /**
595      * @dev Returns the division of two unsigned integers, with a division by zero flag.
596      *
597      * _Available since v3.4._
598      */
599     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
600         unchecked {
601             if (b == 0) return (false, 0);
602             return (true, a / b);
603         }
604     }
605 
606     /**
607      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
608      *
609      * _Available since v3.4._
610      */
611     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
612         unchecked {
613             if (b == 0) return (false, 0);
614             return (true, a % b);
615         }
616     }
617 
618     /**
619      * @dev Returns the addition of two unsigned integers, reverting on
620      * overflow.
621      *
622      * Counterpart to Solidity's `+` operator.
623      *
624      * Requirements:
625      *
626      * - Addition cannot overflow.
627      */
628     function add(uint256 a, uint256 b) internal pure returns (uint256) {
629         return a + b;
630     }
631 
632     /**
633      * @dev Returns the subtraction of two unsigned integers, reverting on
634      * overflow (when the result is negative).
635      *
636      * Counterpart to Solidity's `-` operator.
637      *
638      * Requirements:
639      *
640      * - Subtraction cannot overflow.
641      */
642     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
643         return a - b;
644     }
645 
646     /**
647      * @dev Returns the multiplication of two unsigned integers, reverting on
648      * overflow.
649      *
650      * Counterpart to Solidity's `*` operator.
651      *
652      * Requirements:
653      *
654      * - Multiplication cannot overflow.
655      */
656     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
657         return a * b;
658     }
659 
660     /**
661      * @dev Returns the integer division of two unsigned integers, reverting on
662      * division by zero. The result is rounded towards zero.
663      *
664      * Counterpart to Solidity's `/` operator.
665      *
666      * Requirements:
667      *
668      * - The divisor cannot be zero.
669      */
670     function div(uint256 a, uint256 b) internal pure returns (uint256) {
671         return a / b;
672     }
673 
674     /**
675      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
676      * reverting when dividing by zero.
677      *
678      * Counterpart to Solidity's `%` operator. This function uses a `revert`
679      * opcode (which leaves remaining gas untouched) while Solidity uses an
680      * invalid opcode to revert (consuming all remaining gas).
681      *
682      * Requirements:
683      *
684      * - The divisor cannot be zero.
685      */
686     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
687         return a % b;
688     }
689 
690     /**
691      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
692      * overflow (when the result is negative).
693      *
694      * CAUTION: This function is deprecated because it requires allocating memory for the error
695      * message unnecessarily. For custom revert reasons use {trySub}.
696      *
697      * Counterpart to Solidity's `-` operator.
698      *
699      * Requirements:
700      *
701      * - Subtraction cannot overflow.
702      */
703     function sub(
704         uint256 a,
705         uint256 b,
706         string memory errorMessage
707     ) internal pure returns (uint256) {
708         unchecked {
709             require(b <= a, errorMessage);
710             return a - b;
711         }
712     }
713 //I
714     /**
715      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
716      * division by zero. The result is rounded towards zero.
717      *
718      * Counterpart to Solidity's `/` operator. Note: this function uses a
719      * `revert` opcode (which leaves remaining gas untouched) while Solidity
720      * uses an invalid opcode to revert (consuming all remaining gas).
721      *
722      * Requirements:
723      *
724      * - The divisor cannot be zero.
725      */
726     function div(
727         uint256 a,
728         uint256 b,
729         string memory errorMessage
730     ) internal pure returns (uint256) {
731         unchecked {
732             require(b > 0, errorMessage);
733             return a / b;
734         }
735     }
736 
737     /**
738      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
739      * reverting with custom message when dividing by zero.
740      *
741      * CAUTION: This function is deprecated because it requires allocating memory for the error
742      * message unnecessarily. For custom revert reasons use {tryMod}.
743      *
744      * Counterpart to Solidity's `%` operator. This function uses a `revert`
745      * opcode (which leaves remaining gas untouched) while Solidity uses an
746      * invalid opcode to revert (consuming all remaining gas).
747      *
748      * Requirements:
749      *
750      * - The divisor cannot be zero.
751      */
752     function mod(
753         uint256 a,
754         uint256 b,
755         string memory errorMessage
756     ) internal pure returns (uint256) {
757         unchecked {
758             require(b > 0, errorMessage);
759             return a % b;
760         }
761     }
762 }
763 
764 interface IUniswapV2Factory {
765     event PairCreated(
766         address indexed token0,
767         address indexed token1,
768         address pair,
769         uint256
770     );
771 
772     function createPair(address tokenA, address tokenB)
773         external
774         returns (address pair);
775 }
776 
777 interface IUniswapV2Router02 {
778     function factory() external pure returns (address);
779 
780     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
781         uint256 amountIn,
782         uint256 amountOutMin,
783         address[] calldata path,
784         address to,
785         uint256 deadline
786     ) external;
787 }
788 
789 contract TheStabilizer2 is ERC20, Ownable {
790     using SafeMath for uint256;
791 
792     IUniswapV2Router02 public immutable uniswapV2Router;
793     address public immutable uniswapV2Pair;
794     address public constant deadAddress = address(0xdead);
795     address public DAI = 0x6B175474E89094C44Da98b954EedeAC495271d0F;
796 
797     bool private swapping;
798 
799     address public devWallet;
800 
801     uint256 public maxTransactionAmount;
802     uint256 public swapTokensAtAmount;
803     uint256 public maxWallet;
804 
805     bool public limitsInEffect = true;
806     bool public tradingActive = false;
807     bool public swapEnabled = false;
808 
809     uint256 public buyTotalFees;
810     uint256 public buyDevFee;
811     uint256 public buyLiquidityFee;
812 
813     uint256 public sellTotalFees;
814     uint256 public sellDevFee;
815     uint256 public sellLiquidityFee;
816 
817     /******************/
818 
819     // exlcude from fees and max transaction amount
820     mapping(address => bool) private _isExcludedFromFees;
821     mapping(address => bool) public _isExcludedMaxTransactionAmount;
822 
823 
824     event ExcludeFromFees(address indexed account, bool isExcluded);
825 
826     event devWalletUpdated(
827         address indexed newWallet,
828         address indexed oldWallet
829     );
830 
831     constructor() ERC20("The Stabilizer", "STABLZ") {
832         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
833             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
834         );
835 
836         excludeFromMaxTransaction(address(_uniswapV2Router), true);
837         uniswapV2Router = _uniswapV2Router;
838 
839         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
840             .createPair(address(this), DAI);
841         excludeFromMaxTransaction(address(uniswapV2Pair), true);
842 
843 
844         uint256 _buyDevFee = 5;
845         uint256 _buyLiquidityFee = 0;
846 
847         uint256 _sellDevFee = 15;
848         uint256 _sellLiquidityFee = 0;
849 
850         uint256 totalSupply = 1_060_000_000_000 * 1e18;
851 
852         maxTransactionAmount =  totalSupply * 3 / 100; // 3% from total supply maxTransactionAmountTxn
853         maxWallet = totalSupply * 3 / 100; // 3% from total supply maxWallet
854         swapTokensAtAmount = (totalSupply * 1) / 1000; // 0.1% swap wallet
855 
856         buyDevFee = _buyDevFee;
857         buyLiquidityFee = _buyLiquidityFee;
858         buyTotalFees = buyDevFee + buyLiquidityFee;
859 
860         sellDevFee = _sellDevFee;
861         sellLiquidityFee = _sellLiquidityFee;
862         sellTotalFees = sellDevFee + sellLiquidityFee;
863 
864         devWallet = address(0x954eD22D959Ee732C1A324dF49b75aE5459c85c9); 
865 
866         // exclude from paying fees or having max transaction amount
867         excludeFromFees(owner(), true);
868         excludeFromFees(address(this), true);
869         excludeFromFees(address(0xdead), true);
870 
871         excludeFromMaxTransaction(owner(), true);
872         excludeFromMaxTransaction(address(this), true);
873         excludeFromMaxTransaction(address(0xdead), true);
874 
875         /*
876             _mint is an internal function in ERC20.sol that is only called here,
877             and CANNOT be called ever again
878         */
879         _mint(msg.sender, totalSupply);
880     }
881 
882     receive() external payable {}
883 
884     // once enabled, can never be turned off
885     function enableTrading() external onlyOwner {
886         tradingActive = true;
887         swapEnabled = true;
888     }
889 
890     // remove limits after token is stable
891     function removeLimits() external onlyOwner returns (bool) {
892         limitsInEffect = false;
893         return true;
894     }
895 
896     // change the minimum amount of tokens to sell from fees
897     function updateSwapTokensAtAmount(uint256 newAmount)
898         external
899         onlyOwner
900         returns (bool)
901     {
902         require(
903             newAmount >= (totalSupply() * 1) / 100000,
904             "Swap amount cannot be lower than 0.001% total supply."
905         );
906         require(
907             newAmount <= (totalSupply() * 5) / 1000,
908             "Swap amount cannot be higher than 0.5% total supply."
909         );
910         swapTokensAtAmount = newAmount;
911         return true;
912     }
913 
914     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
915         require(
916             newNum >= ((totalSupply() * 1) / 1000) / 1e18,
917             "Cannot set maxTransactionAmount lower than 0.1%"
918         );
919         maxTransactionAmount = newNum * (10**18);
920     }
921 
922     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
923         require(
924             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
925             "Cannot set maxWallet lower than 0.5%"
926         );
927         maxWallet = newNum * (10**18);
928     }
929 
930     function excludeFromMaxTransaction(address updAds, bool isEx)
931         public
932         onlyOwner
933     {
934         _isExcludedMaxTransactionAmount[updAds] = isEx;
935     }
936 
937     // only use to disable contract sales if absolutely necessary (emergency use only)
938     function updateSwapEnabled(bool enabled) external onlyOwner {
939         swapEnabled = enabled;
940     }
941 
942     function updateBuyFees(
943         uint256 _devFee,
944         uint256 _liquidityFee
945     ) external onlyOwner {
946         buyDevFee = _devFee;
947         buyLiquidityFee = _liquidityFee;
948         buyTotalFees = buyDevFee + buyLiquidityFee;
949         require(buyTotalFees <= 5, "Must keep fees at 6% or less");
950     }
951 
952     function updateSellFees(
953         uint256 _devFee,
954         uint256 _liquidityFee
955     ) external onlyOwner {
956         sellDevFee = _devFee;
957         sellLiquidityFee = _liquidityFee;
958         sellTotalFees = sellDevFee + sellLiquidityFee;
959         require(sellTotalFees <= 15, "Must keep fees at 16% or less");
960     }
961 
962     function excludeFromFees(address account, bool excluded) public onlyOwner {
963         _isExcludedFromFees[account] = excluded;
964         emit ExcludeFromFees(account, excluded);
965     }
966 
967     function updateDevWallet(address newDevWallet)
968         external
969         onlyOwner
970     {
971         emit devWalletUpdated(newDevWallet, devWallet);
972         devWallet = newDevWallet;
973     }
974 
975 
976     function isExcludedFromFees(address account) public view returns (bool) {
977         return _isExcludedFromFees[account];
978     }
979 
980     function _transfer(
981         address from,
982         address to,
983         uint256 amount
984     ) internal override {
985         require(from != address(0), "ERC20: transfer from the zero address");
986         require(to != address(0), "ERC20: transfer to the zero address");
987 
988         if (amount == 0) {
989             super._transfer(from, to, 0);
990             return;
991         }
992 
993         if (limitsInEffect) {
994             if (
995                 from != owner() &&
996                 to != owner() &&
997                 to != address(0) &&
998                 to != address(0xdead) &&
999                 !swapping
1000             ) {
1001                 if (!tradingActive) {
1002                     require(
1003                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
1004                         "Trading is not active."
1005                     );
1006                 }
1007 
1008                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.
1009                 //when buy
1010                 if (
1011                     from == uniswapV2Pair &&
1012                     !_isExcludedMaxTransactionAmount[to]
1013                 ) {
1014                     require(
1015                         amount <= maxTransactionAmount,
1016                         "Buy transfer amount exceeds the maxTransactionAmount."
1017                     );
1018                     require(
1019                         amount + balanceOf(to) <= maxWallet,
1020                         "Max wallet exceeded"
1021                     );
1022                 }
1023                 else if (!_isExcludedMaxTransactionAmount[to]) {
1024                     require(
1025                         amount + balanceOf(to) <= maxWallet,
1026                         "Max wallet exceeded"
1027                     );
1028                 }
1029             }
1030         }
1031 
1032         uint256 contractTokenBalance = balanceOf(address(this));
1033 
1034         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1035 
1036         if (
1037             canSwap &&
1038             swapEnabled &&
1039             !swapping &&
1040             to == uniswapV2Pair &&
1041             !_isExcludedFromFees[from] &&
1042             !_isExcludedFromFees[to]
1043         ) {
1044             swapping = true;
1045 
1046             swapBack();
1047 
1048             swapping = false;
1049         }
1050 
1051         bool takeFee = !swapping;
1052 
1053         // if any account belongs to _isExcludedFromFee account then remove the fee
1054         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1055             takeFee = false;
1056         }
1057 
1058         uint256 fees = 0;
1059         uint256 tokensForLiquidity = 0;
1060         uint256 tokensForDev = 0;
1061         // only take fees on buys/sells, do not take on wallet transfers
1062         if (takeFee) {
1063             // on sell
1064             if (to == uniswapV2Pair && sellTotalFees > 0) {
1065                 fees = amount.mul(sellTotalFees).div(100);
1066                 tokensForLiquidity = (fees * sellLiquidityFee) / sellTotalFees;
1067                 tokensForDev = (fees * sellDevFee) / sellTotalFees;
1068             }
1069             // on buy
1070             else if (from == uniswapV2Pair && buyTotalFees > 0) {
1071                 fees = amount.mul(buyTotalFees).div(100);
1072                 tokensForLiquidity = (fees * buyLiquidityFee) / buyTotalFees; 
1073                 tokensForDev = (fees * buyDevFee) / buyTotalFees;
1074             }
1075 
1076             if (fees> 0) {
1077                 super._transfer(from, address(this), fees);
1078             }
1079             if (tokensForLiquidity > 0) {
1080                 super._transfer(address(this), uniswapV2Pair, tokensForLiquidity);
1081             }
1082 
1083             amount -= fees;
1084         }
1085 
1086         super._transfer(from, to, amount);
1087     }
1088 
1089     function swapTokensForDAI(uint256 tokenAmount) private {
1090         // generate the uniswap pair path of token -> weth
1091         address[] memory path = new address[](2);
1092         path[0] = address(this);
1093         path[1] = DAI;
1094 
1095         _approve(address(this), address(uniswapV2Router), tokenAmount);
1096 
1097         // make the swap
1098         uniswapV2Router.swapExactTokensForTokensSupportingFeeOnTransferTokens(
1099             tokenAmount,
1100             0, // accept any amount of DAI
1101             path,
1102             devWallet,
1103             block.timestamp
1104         );
1105     }
1106 
1107     function swapBack() private {
1108         uint256 contractBalance = balanceOf(address(this));
1109         if (contractBalance == 0) {
1110             return;
1111         }
1112 
1113         if (contractBalance > swapTokensAtAmount * 15) {
1114             contractBalance = swapTokensAtAmount * 15;
1115         }
1116 
1117         swapTokensForDAI(contractBalance);
1118     }
1119 
1120 }