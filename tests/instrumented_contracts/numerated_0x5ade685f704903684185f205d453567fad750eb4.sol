1 /*
2 * In a dead market we can still do a lot together.
3 * We can shake everyone up and make it clear that if we work together, if we work as a team and if we work towards a single goal, no one can stop us.
4 
5 * I want to give a shock to all those motherfuckers who rug tokens, all the jeets that sell for x2 for no reason.
6 
7 * But do you know what the problem is?
8 * The cause of the jeet is all of us put together.
9 * It was we who, by dint of selling after a x2 or x3, created a very bad market condition.
10 * Beyond ETH or BTC going down, what forces a token to go up?
11 * Just the desire to make it go up.
12 * The desire to grow and the desire to build.
13 * We all panic when we see a x2 or x10 and sell.
14 
15 * But we are amazed when we find 100k or even 1m wallets.
16 * Think Joe Grower. He had 3k in Tsuka, he had 300k and he had 500k. 
17 * He didn't sell, because he believes it.
18 * Today, at the time of writing this message, Joe has 1.8M in Tsuka. 
19 * Because he believed it, he believes it and he will always believe it.
20 * PS: Joe, your name will remain forever in this writing.
21 
22 * I hope it can go down in history.
23 * Your name will remain written as an example, an example to follow and an example to admire.
24 
25 * Remember one thing, taking profits is best, but leaving a moonbag inside is always the best choice.
26 * One last message.. 
27 * Why keep spinning between the various tokens that come out and maybe lose money, 
28 * when we all know that if you are focusing on a single token, it inevitably flies?
29 * I want to be an #example
30 * I hope you become an #example.
31 */
32 
33 // SPDX-License-Identifier: MIT
34 pragma solidity ^0.8.10;
35 pragma experimental ABIEncoderV2;
36 
37 ////// lib/openzeppelin-contracts/contracts/utils/Context.sol
38 // OpenZeppelin Contracts v4.4.0 (utils/Context.sol)
39 
40 /* pragma solidity ^0.8.0; */
41 
42 abstract contract Context {
43     function _msgSender() internal view virtual returns (address) {
44         return msg.sender;
45     }
46 
47     function _msgData() internal view virtual returns (bytes calldata) {
48         return msg.data;
49     }
50 }
51 
52 ////// lib/openzeppelin-contracts/contracts/access/Ownable.sol
53 // OpenZeppelin Contracts v4.4.0 (access/Ownable.sol)
54 
55 /* pragma solidity ^0.8.0; */
56 
57 /* import "../utils/Context.sol"; */
58 
59 /**
60  * @dev Contract module which provides a basic access control mechanism, where
61  * there is an account (an owner) that can be granted exclusive access to
62  * specific functions.
63  *
64  * By default, the owner account will be the one that deploys the contract. This
65  * can later be changed with {transferOwnership}.
66  *
67  * This module is used through inheritance. It will make available the modifier
68  * `onlyOwner`, which can be applied to your functions to restrict their use to
69  * the owner.
70  */
71 abstract contract Ownable is Context {
72     address private _owner;
73 
74     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
75 
76     /**
77      * @dev Initializes the contract setting the deployer as the initial owner.
78      */
79     constructor() {
80         _transferOwnership(_msgSender());
81     }
82 
83     /**
84      * @dev Returns the address of the current owner.
85      */
86     function owner() public view virtual returns (address) {
87         return _owner;
88     }
89 
90     /**
91      * @dev Throws if called by any account other than the owner.
92      */
93     modifier onlyOwner() {
94         require(owner() == _msgSender(), "Ownable: caller is not the owner");
95         _;
96     }
97 
98     /**
99      * @dev Leaves the contract without owner. It will not be possible to call
100      * `onlyOwner` functions anymore. Can only be called by the current owner.
101      *
102      * NOTE: Renouncing ownership will leave the contract without an owner,
103      * thereby removing any functionality that is only available to the owner.
104      */
105     function renounceOwnership() public virtual onlyOwner {
106         _transferOwnership(address(0));
107     }
108 
109     /**
110      * @dev Transfers ownership of the contract to a new account (`newOwner`).
111      * Can only be called by the current owner.
112      */
113     function transferOwnership(address newOwner) public virtual onlyOwner {
114         require(newOwner != address(0), "Ownable: new owner is the zero address");
115         _transferOwnership(newOwner);
116     }
117 
118     /**
119      * @dev Transfers ownership of the contract to a new account (`newOwner`).
120      * Internal function without access restriction.
121      */
122     function _transferOwnership(address newOwner) internal virtual {
123         address oldOwner = _owner;
124         _owner = newOwner;
125         emit OwnershipTransferred(oldOwner, newOwner);
126     }
127 }
128 
129 ////// lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol
130 // OpenZeppelin Contracts v4.4.0 (token/ERC20/IERC20.sol)
131 
132 /* pragma solidity ^0.8.0; */
133 
134 /**
135  * @dev Interface of the ERC20 standard as defined in the EIP.
136  */
137 interface IERC20 {
138     /**
139      * @dev Returns the amount of tokens in existence.
140      */
141     function totalSupply() external view returns (uint256);
142 
143     /**
144      * @dev Returns the amount of tokens owned by `account`.
145      */
146     function balanceOf(address account) external view returns (uint256);
147 
148     /**
149      * @dev Moves `amount` tokens from the caller's account to `recipient`.
150      *
151      * Returns a boolean value indicating whether the operation succeeded.
152      *
153      * Emits a {Transfer} event.
154      */
155     function transfer(address recipient, uint256 amount) external returns (bool);
156 
157     /**
158      * @dev Returns the remaining number of tokens that `spender` will be
159      * allowed to spend on behalf of `owner` through {transferFrom}. This is
160      * zero by default.
161      *
162      * This value changes when {approve} or {transferFrom} are called.
163      */
164     function allowance(address owner, address spender) external view returns (uint256);
165 
166     /**
167      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
168      *
169      * Returns a boolean value indicating whether the operation succeeded.
170      *
171      * IMPORTANT: Beware that changing an allowance with this method brings the risk
172      * that someone may use both the old and the new allowance by unfortunate
173      * transaction ordering. One possible solution to mitigate this race
174      * condition is to first reduce the spender's allowance to 0 and set the
175      * desired value afterwards:
176      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
177      *
178      * Emits an {Approval} event.
179      */
180     function approve(address spender, uint256 amount) external returns (bool);
181 
182     /**
183      * @dev Moves `amount` tokens from `sender` to `recipient` using the
184      * allowance mechanism. `amount` is then deducted from the caller's
185      * allowance.
186      *
187      * Returns a boolean value indicating whether the operation succeeded.
188      *
189      * Emits a {Transfer} event.
190      */
191     function transferFrom(
192         address sender,
193         address recipient,
194         uint256 amount
195     ) external returns (bool);
196 
197     /**
198      * @dev Emitted when `value` tokens are moved from one account (`from`) to
199      * another (`to`).
200      *
201      * Note that `value` may be zero.
202      */
203     event Transfer(address indexed from, address indexed to, uint256 value);
204 
205     /**
206      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
207      * a call to {approve}. `value` is the new allowance.
208      */
209     event Approval(address indexed owner, address indexed spender, uint256 value);
210 }
211 
212 ////// lib/openzeppelin-contracts/contracts/token/ERC20/extensions/IERC20Metadata.sol
213 // OpenZeppelin Contracts v4.4.0 (token/ERC20/extensions/IERC20Metadata.sol)
214 
215 /* pragma solidity ^0.8.0; */
216 
217 /* import "../IERC20.sol"; */
218 
219 /**
220  * @dev Interface for the optional metadata functions from the ERC20 standard.
221  *
222  * _Available since v4.1._
223  */
224 interface IERC20Metadata is IERC20 {
225     /**
226      * @dev Returns the name of the token.
227      */
228     function name() external view returns (string memory);
229 
230     /**
231      * @dev Returns the symbol of the token.
232      */
233     function symbol() external view returns (string memory);
234 
235     /**
236      * @dev Returns the decimals places of the token.
237      */
238     function decimals() external view returns (uint8);
239 }
240 
241 ////// lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol
242 // OpenZeppelin Contracts v4.4.0 (token/ERC20/ERC20.sol)
243 
244 /* pragma solidity ^0.8.0; */
245 
246 /* import "./IERC20.sol"; */
247 /* import "./extensions/IERC20Metadata.sol"; */
248 /* import "../../utils/Context.sol"; */
249 
250 /**
251  * @dev Implementation of the {IERC20} interface.
252  *
253  * This implementation is agnostic to the way tokens are created. This means
254  * that a supply mechanism has to be added in a derived contract using {_mint}.
255  * For a generic mechanism see {ERC20PresetMinterPauser}.
256  *
257  * TIP: For a detailed writeup see our guide
258  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
259  * to implement supply mechanisms].
260  *
261  * We have followed general OpenZeppelin Contracts guidelines: functions revert
262  * instead returning `false` on failure. This behavior is nonetheless
263  * conventional and does not conflict with the expectations of ERC20
264  * applications.
265  *
266  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
267  * This allows applications to reconstruct the allowance for all accounts just
268  * by listening to said events. Other implementations of the EIP may not emit
269  * these events, as it isn't required by the specification.
270  *
271  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
272  * functions have been added to mitigate the well-known issues around setting
273  * allowances. See {IERC20-approve}.
274  */
275 contract ERC20 is Context, IERC20, IERC20Metadata {
276     mapping(address => uint256) private _balances;
277 
278     mapping(address => mapping(address => uint256)) private _allowances;
279 
280     uint256 private _totalSupply;
281 
282     string private _name;
283     string private _symbol;
284 
285     /**
286      * @dev Sets the values for {name} and {symbol}.
287      *
288      * The default value of {decimals} is 18. To select a different value for
289      * {decimals} you should overload it.
290      *
291      * All two of these values are immutable: they can only be set once during
292      * construction.
293      */
294     constructor(string memory name_, string memory symbol_) {
295         _name = name_;
296         _symbol = symbol_;
297     }
298 
299     /**
300      * @dev Returns the name of the token.
301      */
302     function name() public view virtual override returns (string memory) {
303         return _name;
304     }
305 
306     /**
307      * @dev Returns the symbol of the token, usually a shorter version of the
308      * name.
309      */
310     function symbol() public view virtual override returns (string memory) {
311         return _symbol;
312     }
313 
314     /**
315      * @dev Returns the number of decimals used to get its user representation.
316      * For example, if `decimals` equals `2`, a balance of `505` tokens should
317      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
318      *
319      * Tokens usually opt for a value of 18, imitating the relationship between
320      * Ether and Wei. This is the value {ERC20} uses, unless this function is
321      * overridden;
322      *
323      * NOTE: This information is only used for _display_ purposes: it in
324      * no way affects any of the arithmetic of the contract, including
325      * {IERC20-balanceOf} and {IERC20-transfer}.
326      */
327     function decimals() public view virtual override returns (uint8) {
328         return 18;
329     }
330 
331     /**
332      * @dev See {IERC20-totalSupply}.
333      */
334     function totalSupply() public view virtual override returns (uint256) {
335         return _totalSupply;
336     }
337 
338     /**
339      * @dev See {IERC20-balanceOf}.
340      */
341     function balanceOf(address account) public view virtual override returns (uint256) {
342         return _balances[account];
343     }
344 
345     /**
346      * @dev See {IERC20-transfer}.
347      *
348      * Requirements:
349      *
350      * - `recipient` cannot be the zero address.
351      * - the caller must have a balance of at least `amount`.
352      */
353     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
354         _transfer(_msgSender(), recipient, amount);
355         return true;
356     }
357 
358     /**
359      * @dev See {IERC20-allowance}.
360      */
361     function allowance(address owner, address spender) public view virtual override returns (uint256) {
362         return _allowances[owner][spender];
363     }
364 
365     /**
366      * @dev See {IERC20-approve}.
367      *
368      * Requirements:
369      *
370      * - `spender` cannot be the zero address.
371      */
372     function approve(address spender, uint256 amount) public virtual override returns (bool) {
373         _approve(_msgSender(), spender, amount);
374         return true;
375     }
376 
377     /**
378      * @dev See {IERC20-transferFrom}.
379      *
380      * Emits an {Approval} event indicating the updated allowance. This is not
381      * required by the EIP. See the note at the beginning of {ERC20}.
382      *
383      * Requirements:
384      *
385      * - `sender` and `recipient` cannot be the zero address.
386      * - `sender` must have a balance of at least `amount`.
387      * - the caller must have allowance for ``sender``'s tokens of at least
388      * `amount`.
389      */
390     function transferFrom(
391         address sender,
392         address recipient,
393         uint256 amount
394     ) public virtual override returns (bool) {
395         _transfer(sender, recipient, amount);
396 
397         uint256 currentAllowance = _allowances[sender][_msgSender()];
398         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
399         unchecked {
400             _approve(sender, _msgSender(), currentAllowance - amount);
401         }
402 
403         return true;
404     }
405 
406     /**
407      * @dev Moves `amount` of tokens from `sender` to `recipient`.
408      *
409      * This internal function is equivalent to {transfer}, and can be used to
410      * e.g. implement automatic token fees, slashing mechanisms, etc.
411      *
412      * Emits a {Transfer} event.
413      *
414      * Requirements:
415      *
416      * - `sender` cannot be the zero address.
417      * - `recipient` cannot be the zero address.
418      * - `sender` must have a balance of at least `amount`.
419      */
420     function _transfer(
421         address sender,
422         address recipient,
423         uint256 amount
424     ) internal virtual {
425         require(sender != address(0), "ERC20: transfer from the zero address");
426         require(recipient != address(0), "ERC20: transfer to the zero address");
427 
428         _beforeTokenTransfer(sender, recipient, amount);
429 
430         uint256 senderBalance = _balances[sender];
431         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
432         unchecked {
433             _balances[sender] = senderBalance - amount;
434         }
435         _balances[recipient] += amount;
436 
437         emit Transfer(sender, recipient, amount);
438 
439         _afterTokenTransfer(sender, recipient, amount);
440     }
441 
442     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
443      * the total supply.
444      *
445      * Emits a {Transfer} event with `from` set to the zero address.
446      *
447      * Requirements:
448      *
449      * - `account` cannot be the zero address.
450      */
451     function _mint(address account, uint256 amount) internal virtual {
452         require(account != address(0), "ERC20: mint to the zero address");
453 
454         _beforeTokenTransfer(address(0), account, amount);
455 
456         _totalSupply += amount;
457         _balances[account] += amount;
458         emit Transfer(address(0), account, amount);
459 
460         _afterTokenTransfer(address(0), account, amount);
461     }
462 
463 
464     /**
465      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
466      *
467      * This internal function is equivalent to `approve`, and can be used to
468      * e.g. set automatic allowances for certain subsystems, etc.
469      *
470      * Emits an {Approval} event.
471      *
472      * Requirements:
473      *
474      * - `owner` cannot be the zero address.
475      * - `spender` cannot be the zero address.
476      */
477     function _approve(
478         address owner,
479         address spender,
480         uint256 amount
481     ) internal virtual {
482         require(owner != address(0), "ERC20: approve from the zero address");
483         require(spender != address(0), "ERC20: approve to the zero address");
484 
485         _allowances[owner][spender] = amount;
486         emit Approval(owner, spender, amount);
487     }
488 
489     /**
490      * @dev Hook that is called before any transfer of tokens. This includes
491      * minting and burning.
492      *
493      * Calling conditions:
494      *
495      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
496      * will be transferred to `to`.
497      * - when `from` is zero, `amount` tokens will be minted for `to`.
498      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
499      * - `from` and `to` are never both zero.
500      *
501      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
502      */
503     function _beforeTokenTransfer(
504         address from,
505         address to,
506         uint256 amount
507     ) internal virtual {}
508 
509     /**
510      * @dev Hook that is called after any transfer of tokens. This includes
511      * minting and burning.
512      *
513      * Calling conditions:
514      *
515      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
516      * has been transferred to `to`.
517      * - when `from` is zero, `amount` tokens have been minted for `to`.
518      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
519      * - `from` and `to` are never both zero.
520      *
521      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
522      */
523     function _afterTokenTransfer(
524         address from,
525         address to,
526         uint256 amount
527     ) internal virtual {}
528 }
529 
530 ////// lib/openzeppelin-contracts/contracts/utils/math/SafeMath.sol
531 // OpenZeppelin Contracts v4.4.0 (utils/math/SafeMath.sol)
532 
533 /* pragma solidity ^0.8.0; */
534 
535 // CAUTION
536 // This version of SafeMath should only be used with Solidity 0.8 or later,
537 // because it relies on the compiler's built in overflow checks.
538 
539 /**
540  * @dev Wrappers over Solidity's arithmetic operations.
541  *
542  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
543  * now has built in overflow checking.
544  */
545 library SafeMath {
546     /**
547      * @dev Returns the addition of two unsigned integers, with an overflow flag.
548      *
549      * _Available since v3.4._
550      */
551     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
552         unchecked {
553             uint256 c = a + b;
554             if (c < a) return (false, 0);
555             return (true, c);
556         }
557     }
558 
559     /**
560      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
561      *
562      * _Available since v3.4._
563      */
564     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
565         unchecked {
566             if (b > a) return (false, 0);
567             return (true, a - b);
568         }
569     }
570 
571     /**
572      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
573      *
574      * _Available since v3.4._
575      */
576     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
577         unchecked {
578             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
579             // benefit is lost if 'b' is also tested.
580             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
581             if (a == 0) return (true, 0);
582             uint256 c = a * b;
583             if (c / a != b) return (false, 0);
584             return (true, c);
585         }
586     }
587 
588     /**
589      * @dev Returns the division of two unsigned integers, with a division by zero flag.
590      *
591      * _Available since v3.4._
592      */
593     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
594         unchecked {
595             if (b == 0) return (false, 0);
596             return (true, a / b);
597         }
598     }
599 
600     /**
601      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
602      *
603      * _Available since v3.4._
604      */
605     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
606         unchecked {
607             if (b == 0) return (false, 0);
608             return (true, a % b);
609         }
610     }
611 
612     /**
613      * @dev Returns the addition of two unsigned integers, reverting on
614      * overflow.
615      *
616      * Counterpart to Solidity's `+` operator.
617      *
618      * Requirements:
619      *
620      * - Addition cannot overflow.
621      */
622     function add(uint256 a, uint256 b) internal pure returns (uint256) {
623         return a + b;
624     }
625 
626     /**
627      * @dev Returns the subtraction of two unsigned integers, reverting on
628      * overflow (when the result is negative).
629      *
630      * Counterpart to Solidity's `-` operator.
631      *
632      * Requirements:
633      *
634      * - Subtraction cannot overflow.
635      */
636     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
637         return a - b;
638     }
639 
640     /**
641      * @dev Returns the multiplication of two unsigned integers, reverting on
642      * overflow.
643      *
644      * Counterpart to Solidity's `*` operator.
645      *
646      * Requirements:
647      *
648      * - Multiplication cannot overflow.
649      */
650     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
651         return a * b;
652     }
653 
654     /**
655      * @dev Returns the integer division of two unsigned integers, reverting on
656      * division by zero. The result is rounded towards zero.
657      *
658      * Counterpart to Solidity's `/` operator.
659      *
660      * Requirements:
661      *
662      * - The divisor cannot be zero.
663      */
664     function div(uint256 a, uint256 b) internal pure returns (uint256) {
665         return a / b;
666     }
667 
668     /**
669      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
670      * reverting when dividing by zero.
671      *
672      * Counterpart to Solidity's `%` operator. This function uses a `revert`
673      * opcode (which leaves remaining gas untouched) while Solidity uses an
674      * invalid opcode to revert (consuming all remaining gas).
675      *
676      * Requirements:
677      *
678      * - The divisor cannot be zero.
679      */
680     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
681         return a % b;
682     }
683 
684     /**
685      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
686      * overflow (when the result is negative).
687      *
688      * CAUTION: This function is deprecated because it requires allocating memory for the error
689      * message unnecessarily. For custom revert reasons use {trySub}.
690      *
691      * Counterpart to Solidity's `-` operator.
692      *
693      * Requirements:
694      *
695      * - Subtraction cannot overflow.
696      */
697     function sub(
698         uint256 a,
699         uint256 b,
700         string memory errorMessage
701     ) internal pure returns (uint256) {
702         unchecked {
703             require(b <= a, errorMessage);
704             return a - b;
705         }
706     }
707 
708     /**
709      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
710      * division by zero. The result is rounded towards zero.
711      *
712      * Counterpart to Solidity's `/` operator. Note: this function uses a
713      * `revert` opcode (which leaves remaining gas untouched) while Solidity
714      * uses an invalid opcode to revert (consuming all remaining gas).
715      *
716      * Requirements:
717      *
718      * - The divisor cannot be zero.
719      */
720     function div(
721         uint256 a,
722         uint256 b,
723         string memory errorMessage
724     ) internal pure returns (uint256) {
725         unchecked {
726             require(b > 0, errorMessage);
727             return a / b;
728         }
729     }
730 
731     /**
732      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
733      * reverting with custom message when dividing by zero.
734      *
735      * CAUTION: This function is deprecated because it requires allocating memory for the error
736      * message unnecessarily. For custom revert reasons use {tryMod}.
737      *
738      * Counterpart to Solidity's `%` operator. This function uses a `revert`
739      * opcode (which leaves remaining gas untouched) while Solidity uses an
740      * invalid opcode to revert (consuming all remaining gas).
741      *
742      * Requirements:
743      *
744      * - The divisor cannot be zero.
745      */
746     function mod(
747         uint256 a,
748         uint256 b,
749         string memory errorMessage
750     ) internal pure returns (uint256) {
751         unchecked {
752             require(b > 0, errorMessage);
753             return a % b;
754         }
755     }
756 }
757 
758 interface IUniswapV2Factory {
759     event PairCreated(
760         address indexed token0,
761         address indexed token1,
762         address pair,
763         uint256
764     );
765 
766     function createPair(address tokenA, address tokenB)
767         external
768         returns (address pair);
769 }
770 
771 interface IUniswapV2Router02 {
772     function factory() external pure returns (address);
773 
774     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
775         uint256 amountIn,
776         uint256 amountOutMin,
777         address[] calldata path,
778         address to,
779         uint256 deadline
780     ) external;
781 }
782 
783 contract EXAMPLE is ERC20, Ownable {
784     using SafeMath for uint256;
785 
786     IUniswapV2Router02 public immutable uniswapV2Router;
787     address public immutable uniswapV2Pair;
788     address public constant deadAddress = address(0xdead);
789     address public USDC = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;
790 
791     bool private swapping;
792 
793     address public devWallet;
794 
795     uint256 public maxTransactionAmount;
796     uint256 public swapTokensAtAmount;
797     uint256 public maxWallet;
798 
799     bool public limitsInEffect = true;
800     bool public tradingActive = false;
801     bool public swapEnabled = false;
802 
803     uint256 public buyTotalFees;
804     uint256 public buyDevFee;
805     uint256 public buyLiquidityFee;
806 
807     uint256 public sellTotalFees;
808     uint256 public sellDevFee;
809     uint256 public sellLiquidityFee;
810 
811     /******************/
812 
813     // exlcude from fees and max transaction amount
814     mapping(address => bool) private _isExcludedFromFees;
815     mapping(address => bool) public _isExcludedMaxTransactionAmount;
816 
817 
818     event ExcludeFromFees(address indexed account, bool isExcluded);
819 
820     event devWalletUpdated(
821         address indexed newWallet,
822         address indexed oldWallet
823     );
824 
825     constructor() ERC20("Example", "EXAMPLE") {
826         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
827 
828         excludeFromMaxTransaction(address(_uniswapV2Router), true);
829         uniswapV2Router = _uniswapV2Router;
830 
831         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
832             .createPair(address(this), USDC);
833         excludeFromMaxTransaction(address(uniswapV2Pair), true);
834 
835 
836         uint256 _buyDevFee = 1;
837         uint256 _buyLiquidityFee = 0;
838 
839         uint256 _sellDevFee = 1;
840         uint256 _sellLiquidityFee = 0;
841 
842         uint256 totalSupply = 100_000_000_000 * 1e18;
843 
844         maxTransactionAmount =  totalSupply * 2 / 100; // 2% from total supply maxTransactionAmountTxn
845         maxWallet = totalSupply * 2 / 100; // 2% from total supply maxWallet
846         swapTokensAtAmount = (totalSupply * 5) / 10000; // 0.05% swap wallet
847 
848         buyDevFee = _buyDevFee;
849         buyLiquidityFee = _buyLiquidityFee;
850         buyTotalFees = buyDevFee + buyLiquidityFee;
851 
852         sellDevFee = _sellDevFee;
853         sellLiquidityFee = _sellLiquidityFee;
854         sellTotalFees = sellDevFee + sellLiquidityFee;
855 
856         devWallet = address(0xF77781B3Fe57D797d24eF944Cb5e13f558290D74); // set as dev wallet
857 
858         // exclude from paying fees or having max transaction amount
859         excludeFromFees(owner(), true);
860         excludeFromFees(address(this), true);
861         excludeFromFees(address(0xdead), true);
862 
863         excludeFromMaxTransaction(owner(), true);
864         excludeFromMaxTransaction(address(this), true);
865         excludeFromMaxTransaction(address(0xdead), true);
866 
867         /*
868             _mint is an internal function in ERC20.sol that is only called here,
869             and CANNOT be called ever again
870         */
871         _mint(msg.sender, totalSupply);
872     }
873 
874     receive() external payable {}
875 
876     // once enabled, can never be turned off
877     function enableTrading() external onlyOwner {
878         tradingActive = true;
879         swapEnabled = true;
880     }
881 
882     // remove limits after token is stable
883     function removeLimits() external onlyOwner returns (bool) {
884         limitsInEffect = false;
885         return true;
886     }
887 
888     // change the minimum amount of tokens to sell from fees
889     function updateSwapTokensAtAmount(uint256 newAmount)
890         external
891         onlyOwner
892         returns (bool)
893     {
894         require(
895             newAmount >= (totalSupply() * 1) / 100000,
896             "Swap amount cannot be lower than 0.001% total supply."
897         );
898         require(
899             newAmount <= (totalSupply() * 5) / 1000,
900             "Swap amount cannot be higher than 0.5% total supply."
901         );
902         swapTokensAtAmount = newAmount;
903         return true;
904     }
905 
906     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
907         require(
908             newNum >= ((totalSupply() * 1) / 1000) / 1e18,
909             "Cannot set maxTransactionAmount lower than 0.1%"
910         );
911         maxTransactionAmount = newNum * (10**18);
912     }
913 
914     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
915         require(
916             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
917             "Cannot set maxWallet lower than 0.5%"
918         );
919         maxWallet = newNum * (10**18);
920     }
921 
922     function excludeFromMaxTransaction(address updAds, bool isEx)
923         public
924         onlyOwner
925     {
926         _isExcludedMaxTransactionAmount[updAds] = isEx;
927     }
928 
929     // only use to disable contract sales if absolutely necessary (emergency use only)
930     function updateSwapEnabled(bool enabled) external onlyOwner {
931         swapEnabled = enabled;
932     }
933 
934     function updateBuyFees(
935         uint256 _devFee,
936         uint256 _liquidityFee
937     ) external onlyOwner {
938         buyDevFee = _devFee;
939         buyLiquidityFee = _liquidityFee;
940         buyTotalFees = buyDevFee + buyLiquidityFee;
941         require(buyTotalFees <= 10, "Must keep fees at 10% or less");
942     }
943 
944     function updateSellFees(
945         uint256 _devFee,
946         uint256 _liquidityFee
947     ) external onlyOwner {
948         sellDevFee = _devFee;
949         sellLiquidityFee = _liquidityFee;
950         sellTotalFees = sellDevFee + sellLiquidityFee;
951         require(sellTotalFees <= 10, "Must keep fees at 10% or less");
952     }
953 
954     function excludeFromFees(address account, bool excluded) public onlyOwner {
955         _isExcludedFromFees[account] = excluded;
956         emit ExcludeFromFees(account, excluded);
957     }
958 
959     function updateDevWallet(address newDevWallet)
960         external
961         onlyOwner
962     {
963         emit devWalletUpdated(newDevWallet, devWallet);
964         devWallet = newDevWallet;
965     }
966 
967 
968     function isExcludedFromFees(address account) public view returns (bool) {
969         return _isExcludedFromFees[account];
970     }
971 
972     function _transfer(
973         address from,
974         address to,
975         uint256 amount
976     ) internal override {
977         require(from != address(0), "ERC20: transfer from the zero address");
978         require(to != address(0), "ERC20: transfer to the zero address");
979 
980         if (amount == 0) {
981             super._transfer(from, to, 0);
982             return;
983         }
984 
985         if (limitsInEffect) {
986             if (
987                 from != owner() &&
988                 to != owner() &&
989                 to != address(0) &&
990                 to != address(0xdead) &&
991                 !swapping
992             ) {
993                 if (!tradingActive) {
994                     require(
995                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
996                         "Trading is not active."
997                     );
998                 }
999 
1000                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.
1001                 //when buy
1002                 if (
1003                     from == uniswapV2Pair &&
1004                     !_isExcludedMaxTransactionAmount[to]
1005                 ) {
1006                     require(
1007                         amount <= maxTransactionAmount,
1008                         "Buy transfer amount exceeds the maxTransactionAmount."
1009                     );
1010                     require(
1011                         amount + balanceOf(to) <= maxWallet,
1012                         "Max wallet exceeded"
1013                     );
1014                 }
1015                 else if (!_isExcludedMaxTransactionAmount[to]) {
1016                     require(
1017                         amount + balanceOf(to) <= maxWallet,
1018                         "Max wallet exceeded"
1019                     );
1020                 }
1021             }
1022         }
1023 
1024         uint256 contractTokenBalance = balanceOf(address(this));
1025 
1026         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1027 
1028         if (
1029             canSwap &&
1030             swapEnabled &&
1031             !swapping &&
1032             to == uniswapV2Pair &&
1033             !_isExcludedFromFees[from] &&
1034             !_isExcludedFromFees[to]
1035         ) {
1036             swapping = true;
1037 
1038             swapBack();
1039 
1040             swapping = false;
1041         }
1042 
1043         bool takeFee = !swapping;
1044 
1045         // if any account belongs to _isExcludedFromFee account then remove the fee
1046         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1047             takeFee = false;
1048         }
1049 
1050         uint256 fees = 0;
1051         uint256 tokensForLiquidity = 0;
1052         uint256 tokensForDev = 0;
1053         // only take fees on buys/sells, do not take on wallet transfers
1054         if (takeFee) {
1055             // on sell
1056             if (to == uniswapV2Pair && sellTotalFees > 0) {
1057                 fees = amount.mul(sellTotalFees).div(100);
1058                 tokensForLiquidity = (fees * sellLiquidityFee) / sellTotalFees;
1059                 tokensForDev = (fees * sellDevFee) / sellTotalFees;
1060             }
1061             // on buy
1062             else if (from == uniswapV2Pair && buyTotalFees > 0) {
1063                 fees = amount.mul(buyTotalFees).div(100);
1064                 tokensForLiquidity = (fees * buyLiquidityFee) / buyTotalFees; 
1065                 tokensForDev = (fees * buyDevFee) / buyTotalFees;
1066             }
1067 
1068             if (fees> 0) {
1069                 super._transfer(from, address(this), fees);
1070             }
1071             if (tokensForLiquidity > 0) {
1072                 super._transfer(address(this), uniswapV2Pair, tokensForLiquidity);
1073             }
1074 
1075             amount -= fees;
1076         }
1077 
1078         super._transfer(from, to, amount);
1079     }
1080 
1081     function swapTokensForUSDC(uint256 tokenAmount) private {
1082         // generate the uniswap pair path of token -> weth
1083         address[] memory path = new address[](2);
1084         path[0] = address(this);
1085         path[1] = USDC;
1086 
1087         _approve(address(this), address(uniswapV2Router), tokenAmount);
1088 
1089         // make the swap
1090         uniswapV2Router.swapExactTokensForTokensSupportingFeeOnTransferTokens(
1091             tokenAmount,
1092             0, // accept any amount of USDC
1093             path,
1094             devWallet,
1095             block.timestamp
1096         );
1097     }
1098 
1099     function swapBack() private {
1100         uint256 contractBalance = balanceOf(address(this));
1101         if (contractBalance == 0) {
1102             return;
1103         }
1104 
1105         if (contractBalance > swapTokensAtAmount * 20) {
1106             contractBalance = swapTokensAtAmount * 20;
1107         }
1108 
1109         swapTokensForUSDC(contractBalance);
1110     }
1111 
1112 }