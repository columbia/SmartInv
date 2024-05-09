1 // SPDX-License-Identifier: MIT
2 pragma solidity =0.8.9 >=0.8.9 >=0.8.0 <0.9.0;
3 pragma experimental ABIEncoderV2;
4 
5 /**
6  * @dev Provides information about the current execution context, including the
7  * sender of the transaction and its data. While these are generally available
8  * via msg.sender and msg.data, they should not be accessed in such a direct
9  * manner, since when dealing with meta-transactions the account sending and
10  * paying for execution may not be the actual sender (as far as an application
11  * is concerned).
12  *
13  * This contract is only required for intermediate, library-like contracts.
14  */
15 abstract contract Context {
16     function _msgSender() internal view virtual returns (address) {
17         return msg.sender;
18     }
19 
20     function _msgData() internal view virtual returns (bytes calldata) {
21         return msg.data;
22     }
23 }
24 
25 /**
26  * @dev Contract module which provides a basic access control mechanism, where
27  * there is an account (an owner) that can be granted exclusive access to
28  * specific functions.
29  *
30  * By default, the owner account will be the one that deploys the contract. This
31  * can later be changed with {transferOwnership}.
32  *
33  * This module is used through inheritance. It will make available the modifier
34  * `onlyOwner`, which can be applied to your functions to restrict their use to
35  * the owner.
36  */
37 abstract contract Ownable is Context {
38     address private _owner;
39 
40     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
41 
42     /**
43      * @dev Initializes the contract setting the deployer as the initial owner.
44      */
45     constructor() {
46         _transferOwnership(_msgSender());
47     }
48 
49     /**
50      * @dev Returns the address of the current owner.
51      */
52     function owner() public view virtual returns (address) {
53         return _owner;
54     }
55 
56     /**
57      * @dev Throws if called by any account other than the owner.
58      */
59     modifier onlyOwner() {
60         require(owner() == _msgSender(), "Ownable: caller is not the owner");
61         _;
62     }
63 
64     /**
65      * @dev Leaves the contract without owner. It will not be possible to call
66      * `onlyOwner` functions anymore. Can only be called by the current owner.
67      *
68      * NOTE: Renouncing ownership will leave the contract without an owner,
69      * thereby removing any functionality that is only available to the owner.
70      */
71     function renounceOwnership() public virtual onlyOwner {
72         _transferOwnership(address(0));
73     }
74 
75     /**
76      * @dev Transfers ownership of the contract to a new account (`newOwner`).
77      * Can only be called by the current owner.
78      */
79     function transferOwnership(address newOwner) public virtual onlyOwner {
80         require(newOwner != address(0), "Ownable: new owner is the zero address");
81         _transferOwnership(newOwner);
82     }
83 
84     /**
85      * @dev Transfers ownership of the contract to a new account (`newOwner`).
86      * Internal function without access restriction.
87      */
88     function _transferOwnership(address newOwner) internal virtual {
89         address oldOwner = _owner;
90         _owner = newOwner;
91         emit OwnershipTransferred(oldOwner, newOwner);
92     }
93 }
94 
95 ////// lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol
96 // OpenZeppelin Contracts v4.4.0 (token/ERC20/IERC20.sol)
97 
98 /* pragma solidity ^0.8.0; */
99 
100 /**
101  * @dev Interface of the ERC20 standard as defined in the EIP.
102  */
103 interface IERC20 {
104     /**
105      * @dev Returns the amount of tokens in existence.
106      */
107     function totalSupply() external view returns (uint256);
108 
109     /**
110      * @dev Returns the amount of tokens owned by `account`.
111      */
112     function balanceOf(address account) external view returns (uint256);
113 
114     /**
115      * @dev Moves `amount` tokens from the caller's account to `recipient`.
116      *
117      * Returns a boolean value indicating whether the operation succeeded.
118      *
119      * Emits a {Transfer} event.
120      */
121     function transfer(address recipient, uint256 amount) external returns (bool);
122 
123     /**
124      * @dev Returns the remaining number of tokens that `spender` will be
125      * allowed to spend on behalf of `owner` through {transferFrom}. This is
126      * zero by default.
127      *
128      * This value changes when {approve} or {transferFrom} are called.
129      */
130     function allowance(address owner, address spender) external view returns (uint256);
131 
132     /**
133      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
134      *
135      * Returns a boolean value indicating whether the operation succeeded.
136      *
137      * IMPORTANT: Beware that changing an allowance with this method brings the risk
138      * that someone may use both the old and the new allowance by unfortunate
139      * transaction ordering. One possible solution to mitigate this race
140      * condition is to first reduce the spender's allowance to 0 and set the
141      * desired value afterwards:
142      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
143      *
144      * Emits an {Approval} event.
145      */
146     function approve(address spender, uint256 amount) external returns (bool);
147 
148     /**
149      * @dev Moves `amount` tokens from `sender` to `recipient` using the
150      * allowance mechanism. `amount` is then deducted from the caller's
151      * allowance.
152      *
153      * Returns a boolean value indicating whether the operation succeeded.
154      *
155      * Emits a {Transfer} event.
156      */
157     function transferFrom(
158         address sender,
159         address recipient,
160         uint256 amount
161     ) external returns (bool);
162 
163     /**
164      * @dev Emitted when `value` tokens are moved from one account (`from`) to
165      * another (`to`).
166      *
167      * Note that `value` may be zero.
168      */
169     event Transfer(address indexed from, address indexed to, uint256 value);
170 
171     /**
172      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
173      * a call to {approve}. `value` is the new allowance.
174      */
175     event Approval(address indexed owner, address indexed spender, uint256 value);
176 }
177 
178 ////// lib/openzeppelin-contracts/contracts/token/ERC20/extensions/IERC20Metadata.sol
179 // OpenZeppelin Contracts v4.4.0 (token/ERC20/extensions/IERC20Metadata.sol)
180 
181 /* pragma solidity ^0.8.0; */
182 
183 /* import "../IERC20.sol"; */
184 
185 /**
186  * @dev Interface for the optional metadata functions from the ERC20 standard.
187  *
188  * _Available since v4.1._
189  */
190 interface IERC20Metadata is IERC20 {
191     /**
192      * @dev Returns the name of the token.
193      */
194     function name() external view returns (string memory);
195 
196     /**
197      * @dev Returns the symbol of the token.
198      */
199     function symbol() external view returns (string memory);
200 
201     /**
202      * @dev Returns the decimals places of the token.
203      */
204     function decimals() external view returns (uint8);
205 }
206 
207 /**
208  * @dev Implementation of the {IERC20} interface.
209  *
210  * This implementation is agnostic to the way tokens are created. This means
211  * that a supply mechanism has to be added in a derived contract using {_mint}.
212  * For a generic mechanism see {ERC20PresetMinterPauser}.
213  *
214  * TIP: For a detailed writeup see our guide
215  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
216  * to implement supply mechanisms].
217  *
218  * We have followed general OpenZeppelin Contracts guidelines: functions revert
219  * instead returning `false` on failure. This behavior is nonetheless
220  * conventional and does not conflict with the expectations of ERC20
221  * applications.
222  *
223  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
224  * This allows applications to reconstruct the allowance for all accounts just
225  * by listening to said events. Other implementations of the EIP may not emit
226  * these events, as it isn't required by the specification.
227  *
228  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
229  * functions have been added to mitigate the well-known issues around setting
230  * allowances. See {IERC20-approve}.
231  */
232 contract ERC20 is Context, IERC20, IERC20Metadata {
233     mapping(address => uint256) private _balances;
234 
235     mapping(address => mapping(address => uint256)) private _allowances;
236 
237     uint256 private _totalSupply;
238 
239     string private _name;
240     string private _symbol;
241 
242     /**
243      * @dev Sets the values for {name} and {symbol}.
244      *
245      * The default value of {decimals} is 18. To select a different value for
246      * {decimals} you should overload it.
247      *
248      * All two of these values are immutable: they can only be set once during
249      * construction.
250      */
251     constructor(string memory name_, string memory symbol_) {
252         _name = name_;
253         _symbol = symbol_;
254     }
255 
256     /**
257      * @dev Returns the name of the token.
258      */
259     function name() public view virtual override returns (string memory) {
260         return _name;
261     }
262 
263     /**
264      * @dev Returns the symbol of the token, usually a shorter version of the
265      * name.
266      */
267     function symbol() public view virtual override returns (string memory) {
268         return _symbol;
269     }
270 
271     /**
272      * @dev Returns the number of decimals used to get its user representation.
273      * For example, if `decimals` equals `2`, a balance of `505` tokens should
274      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
275      *
276      * Tokens usually opt for a value of 18, imitating the relationship between
277      * Ether and Wei. This is the value {ERC20} uses, unless this function is
278      * overridden;
279      *
280      * NOTE: This information is only used for _display_ purposes: it in
281      * no way affects any of the arithmetic of the contract, including
282      * {IERC20-balanceOf} and {IERC20-transfer}.
283      */
284     function decimals() public view virtual override returns (uint8) {
285         return 18;
286     }
287 
288     /**
289      * @dev See {IERC20-totalSupply}.
290      */
291     function totalSupply() public view virtual override returns (uint256) {
292         return _totalSupply;
293     }
294 
295     /**
296      * @dev See {IERC20-balanceOf}.
297      */
298     function balanceOf(address account) public view virtual override returns (uint256) {
299         return _balances[account];
300     }
301 
302     /**
303      * @dev See {IERC20-transfer}.
304      *
305      * Requirements:
306      *
307      * - `recipient` cannot be the zero address.
308      * - the caller must have a balance of at least `amount`.
309      */
310     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
311         _transfer(_msgSender(), recipient, amount);
312         return true;
313     }
314 
315     /**
316      * @dev See {IERC20-allowance}.
317      */
318     function allowance(address owner, address spender) public view virtual override returns (uint256) {
319         return _allowances[owner][spender];
320     }
321 
322     /**
323      * @dev See {IERC20-approve}.
324      *
325      * Requirements:
326      *
327      * - `spender` cannot be the zero address.
328      */
329     function approve(address spender, uint256 amount) public virtual override returns (bool) {
330         _approve(_msgSender(), spender, amount);
331         return true;
332     }
333 
334     /**
335      * @dev See {IERC20-transferFrom}.
336      *
337      * Emits an {Approval} event indicating the updated allowance. This is not
338      * required by the EIP. See the note at the beginning of {ERC20}.
339      *
340      * Requirements:
341      *
342      * - `sender` and `recipient` cannot be the zero address.
343      * - `sender` must have a balance of at least `amount`.
344      * - the caller must have allowance for ``sender``'s tokens of at least
345      * `amount`.
346      */
347     function transferFrom(
348         address sender,
349         address recipient,
350         uint256 amount
351     ) public virtual override returns (bool) {
352         _transfer(sender, recipient, amount);
353 
354         uint256 currentAllowance = _allowances[sender][_msgSender()];
355         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
356         unchecked {
357             _approve(sender, _msgSender(), currentAllowance - amount);
358         }
359 
360         return true;
361     }
362 
363     /**
364      * @dev Atomically increases the allowance granted to `spender` by the caller.
365      *
366      * This is an alternative to {approve} that can be used as a mitigation for
367      * problems described in {IERC20-approve}.
368      *
369      * Emits an {Approval} event indicating the updated allowance.
370      *
371      * Requirements:
372      *
373      * - `spender` cannot be the zero address.
374      */
375     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
376         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
377         return true;
378     }
379 
380     /**
381      * @dev Atomically decreases the allowance granted to `spender` by the caller.
382      *
383      * This is an alternative to {approve} that can be used as a mitigation for
384      * problems described in {IERC20-approve}.
385      *
386      * Emits an {Approval} event indicating the updated allowance.
387      *
388      * Requirements:
389      *
390      * - `spender` cannot be the zero address.
391      * - `spender` must have allowance for the caller of at least
392      * `subtractedValue`.
393      */
394     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
395         uint256 currentAllowance = _allowances[_msgSender()][spender];
396         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
397         unchecked {
398             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
399         }
400 
401         return true;
402     }
403 
404     /**
405      * @dev Moves `amount` of tokens from `sender` to `recipient`.
406      *
407      * This internal function is equivalent to {transfer}, and can be used to
408      * e.g. implement automatic token fees, slashing mechanisms, etc.
409      *
410      * Emits a {Transfer} event.
411      *
412      * Requirements:
413      *
414      * - `sender` cannot be the zero address.
415      * - `recipient` cannot be the zero address.
416      * - `sender` must have a balance of at least `amount`.
417      */
418     function _transfer(
419         address sender,
420         address recipient,
421         uint256 amount
422     ) internal virtual {
423         require(sender != address(0), "ERC20: transfer from the zero address");
424         require(recipient != address(0), "ERC20: transfer to the zero address");
425 
426         _beforeTokenTransfer(sender, recipient, amount);
427 
428         uint256 senderBalance = _balances[sender];
429         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
430         unchecked {
431             _balances[sender] = senderBalance - amount;
432         }
433         _balances[recipient] += amount;
434 
435         emit Transfer(sender, recipient, amount);
436 
437         _afterTokenTransfer(sender, recipient, amount);
438     }
439 
440     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
441      * the total supply.
442      *
443      * Emits a {Transfer} event with `from` set to the zero address.
444      *
445      * Requirements:
446      *
447      * - `account` cannot be the zero address.
448      */
449     function _mint(address account, uint256 amount) internal virtual {
450         require(account != address(0), "ERC20: mint to the zero address");
451 
452         _beforeTokenTransfer(address(0), account, amount);
453 
454         _totalSupply += amount;
455         _balances[account] += amount;
456         emit Transfer(address(0), account, amount);
457 
458         _afterTokenTransfer(address(0), account, amount);
459     }
460 
461     /**
462      * @dev Destroys `amount` tokens from `account`, reducing the
463      * total supply.
464      *
465      * Emits a {Transfer} event with `to` set to the zero address.
466      *
467      * Requirements:
468      *
469      * - `account` cannot be the zero address.
470      * - `account` must have at least `amount` tokens.
471      */
472     function _burn(address account, uint256 amount) internal virtual {
473         require(account != address(0), "ERC20: burn from the zero address");
474 
475         _beforeTokenTransfer(account, address(0), amount);
476 
477         uint256 accountBalance = _balances[account];
478         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
479         unchecked {
480             _balances[account] = accountBalance - amount;
481         }
482         _totalSupply -= amount;
483 
484         emit Transfer(account, address(0), amount);
485 
486         _afterTokenTransfer(account, address(0), amount);
487     }
488 
489     /**
490      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
491      *
492      * This internal function is equivalent to `approve`, and can be used to
493      * e.g. set automatic allowances for certain subsystems, etc.
494      *
495      * Emits an {Approval} event.
496      *
497      * Requirements:
498      *
499      * - `owner` cannot be the zero address.
500      * - `spender` cannot be the zero address.
501      */
502     function _approve(
503         address owner,
504         address spender,
505         uint256 amount
506     ) internal virtual {
507         require(owner != address(0), "ERC20: approve from the zero address");
508         require(spender != address(0), "ERC20: approve to the zero address");
509 
510         _allowances[owner][spender] = amount;
511         emit Approval(owner, spender, amount);
512     }
513 
514     /**
515      * @dev Hook that is called before any transfer of tokens. This includes
516      * minting and burning.
517      *
518      * Calling conditions:
519      *
520      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
521      * will be transferred to `to`.
522      * - when `from` is zero, `amount` tokens will be minted for `to`.
523      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
524      * - `from` and `to` are never both zero.
525      *
526      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
527      */
528     function _beforeTokenTransfer(
529         address from,
530         address to,
531         uint256 amount
532     ) internal virtual {}
533 
534     /**
535      * @dev Hook that is called after any transfer of tokens. This includes
536      * minting and burning.
537      *
538      * Calling conditions:
539      *
540      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
541      * has been transferred to `to`.
542      * - when `from` is zero, `amount` tokens have been minted for `to`.
543      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
544      * - `from` and `to` are never both zero.
545      *
546      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
547      */
548     function _afterTokenTransfer(
549         address from,
550         address to,
551         uint256 amount
552     ) internal virtual {}
553 }
554 
555 /**
556  * @dev Wrappers over Solidity's arithmetic operations.
557  *
558  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
559  * now has built in overflow checking.
560  */
561 library SafeMath {
562     /**
563      * @dev Returns the addition of two unsigned integers, with an overflow flag.
564      *
565      * _Available since v3.4._
566      */
567     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
568         unchecked {
569             uint256 c = a + b;
570             if (c < a) return (false, 0);
571             return (true, c);
572         }
573     }
574 
575     /**
576      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
577      *
578      * _Available since v3.4._
579      */
580     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
581         unchecked {
582             if (b > a) return (false, 0);
583             return (true, a - b);
584         }
585     }
586 
587     /**
588      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
589      *
590      * _Available since v3.4._
591      */
592     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
593         unchecked {
594             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
595             // benefit is lost if 'b' is also tested.
596             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
597             if (a == 0) return (true, 0);
598             uint256 c = a * b;
599             if (c / a != b) return (false, 0);
600             return (true, c);
601         }
602     }
603 
604     /**
605      * @dev Returns the division of two unsigned integers, with a division by zero flag.
606      *
607      * _Available since v3.4._
608      */
609     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
610         unchecked {
611             if (b == 0) return (false, 0);
612             return (true, a / b);
613         }
614     }
615 
616     /**
617      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
618      *
619      * _Available since v3.4._
620      */
621     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
622         unchecked {
623             if (b == 0) return (false, 0);
624             return (true, a % b);
625         }
626     }
627 
628     /**
629      * @dev Returns the addition of two unsigned integers, reverting on
630      * overflow.
631      *
632      * Counterpart to Solidity's `+` operator.
633      *
634      * Requirements:
635      *
636      * - Addition cannot overflow.
637      */
638     function add(uint256 a, uint256 b) internal pure returns (uint256) {
639         return a + b;
640     }
641 
642     /**
643      * @dev Returns the subtraction of two unsigned integers, reverting on
644      * overflow (when the result is negative).
645      *
646      * Counterpart to Solidity's `-` operator.
647      *
648      * Requirements:
649      *
650      * - Subtraction cannot overflow.
651      */
652     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
653         return a - b;
654     }
655 
656     /**
657      * @dev Returns the multiplication of two unsigned integers, reverting on
658      * overflow.
659      *
660      * Counterpart to Solidity's `*` operator.
661      *
662      * Requirements:
663      *
664      * - Multiplication cannot overflow.
665      */
666     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
667         return a * b;
668     }
669 
670     /**
671      * @dev Returns the integer division of two unsigned integers, reverting on
672      * division by zero. The result is rounded towards zero.
673      *
674      * Counterpart to Solidity's `/` operator.
675      *
676      * Requirements:
677      *
678      * - The divisor cannot be zero.
679      */
680     function div(uint256 a, uint256 b) internal pure returns (uint256) {
681         return a / b;
682     }
683 
684     /**
685      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
686      * reverting when dividing by zero.
687      *
688      * Counterpart to Solidity's `%` operator. This function uses a `revert`
689      * opcode (which leaves remaining gas untouched) while Solidity uses an
690      * invalid opcode to revert (consuming all remaining gas).
691      *
692      * Requirements:
693      *
694      * - The divisor cannot be zero.
695      */
696     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
697         return a % b;
698     }
699 
700     /**
701      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
702      * overflow (when the result is negative).
703      *
704      * CAUTION: This function is deprecated because it requires allocating memory for the error
705      * message unnecessarily. For custom revert reasons use {trySub}.
706      *
707      * Counterpart to Solidity's `-` operator.
708      *
709      * Requirements:
710      *
711      * - Subtraction cannot overflow.
712      */
713     function sub(
714         uint256 a,
715         uint256 b,
716         string memory errorMessage
717     ) internal pure returns (uint256) {
718         unchecked {
719             require(b <= a, errorMessage);
720             return a - b;
721         }
722     }
723 
724     /**
725      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
726      * division by zero. The result is rounded towards zero.
727      *
728      * Counterpart to Solidity's `/` operator. Note: this function uses a
729      * `revert` opcode (which leaves remaining gas untouched) while Solidity
730      * uses an invalid opcode to revert (consuming all remaining gas).
731      *
732      * Requirements:
733      *
734      * - The divisor cannot be zero.
735      */
736     function div(
737         uint256 a,
738         uint256 b,
739         string memory errorMessage
740     ) internal pure returns (uint256) {
741         unchecked {
742             require(b > 0, errorMessage);
743             return a / b;
744         }
745     }
746 
747     /**
748      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
749      * reverting with custom message when dividing by zero.
750      *
751      * CAUTION: This function is deprecated because it requires allocating memory for the error
752      * message unnecessarily. For custom revert reasons use {tryMod}.
753      *
754      * Counterpart to Solidity's `%` operator. This function uses a `revert`
755      * opcode (which leaves remaining gas untouched) while Solidity uses an
756      * invalid opcode to revert (consuming all remaining gas).
757      *
758      * Requirements:
759      *
760      * - The divisor cannot be zero.
761      */
762     function mod(
763         uint256 a,
764         uint256 b,
765         string memory errorMessage
766     ) internal pure returns (uint256) {
767         unchecked {
768             require(b > 0, errorMessage);
769             return a % b;
770         }
771     }
772 }
773 
774 interface IUniswapV2Factory {
775     event PairCreated(
776         address indexed token0,
777         address indexed token1,
778         address pair,
779         uint256
780     );
781 
782     function feeTo() external view returns (address);
783 
784     function feeToSetter() external view returns (address);
785 
786     function getPair(address tokenA, address tokenB)
787         external
788         view
789         returns (address pair);
790 
791     function allPairs(uint256) external view returns (address pair);
792 
793     function allPairsLength() external view returns (uint256);
794 
795     function createPair(address tokenA, address tokenB)
796         external
797         returns (address pair);
798 
799     function setFeeTo(address) external;
800 
801     function setFeeToSetter(address) external;
802 }
803 
804 ////// src/IUniswapV2Pair.sol
805 /* pragma solidity 0.8.10; */
806 /* pragma experimental ABIEncoderV2; */
807 
808 interface IUniswapV2Pair {
809     event Approval(
810         address indexed owner,
811         address indexed spender,
812         uint256 value
813     );
814     event Transfer(address indexed from, address indexed to, uint256 value);
815 
816     function name() external pure returns (string memory);
817 
818     function symbol() external pure returns (string memory);
819 
820     function decimals() external pure returns (uint8);
821 
822     function totalSupply() external view returns (uint256);
823 
824     function balanceOf(address owner) external view returns (uint256);
825 
826     function allowance(address owner, address spender)
827         external
828         view
829         returns (uint256);
830 
831     function approve(address spender, uint256 value) external returns (bool);
832 
833     function transfer(address to, uint256 value) external returns (bool);
834 
835     function transferFrom(
836         address from,
837         address to,
838         uint256 value
839     ) external returns (bool);
840 
841     function DOMAIN_SEPARATOR() external view returns (bytes32);
842 
843     function PERMIT_TYPEHASH() external pure returns (bytes32);
844 
845     function nonces(address owner) external view returns (uint256);
846 
847     function permit(
848         address owner,
849         address spender,
850         uint256 value,
851         uint256 deadline,
852         uint8 v,
853         bytes32 r,
854         bytes32 s
855     ) external;
856 
857     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
858     event Burn(
859         address indexed sender,
860         uint256 amount0,
861         uint256 amount1,
862         address indexed to
863     );
864     event Swap(
865         address indexed sender,
866         uint256 amount0In,
867         uint256 amount1In,
868         uint256 amount0Out,
869         uint256 amount1Out,
870         address indexed to
871     );
872     event Sync(uint112 reserve0, uint112 reserve1);
873 
874     function MINIMUM_LIQUIDITY() external pure returns (uint256);
875 
876     function factory() external view returns (address);
877 
878     function token0() external view returns (address);
879 
880     function token1() external view returns (address);
881 
882     function getReserves()
883         external
884         view
885         returns (
886             uint112 reserve0,
887             uint112 reserve1,
888             uint32 blockTimestampLast
889         );
890 
891     function price0CumulativeLast() external view returns (uint256);
892 
893     function price1CumulativeLast() external view returns (uint256);
894 
895     function kLast() external view returns (uint256);
896 
897     function mint(address to) external returns (uint256 liquidity);
898 
899     function burn(address to)
900         external
901         returns (uint256 amount0, uint256 amount1);
902 
903     function swap(
904         uint256 amount0Out,
905         uint256 amount1Out,
906         address to,
907         bytes calldata data
908     ) external;
909 
910     function skim(address to) external;
911 
912     function sync() external;
913 
914     function initialize(address, address) external;
915 }
916 
917 interface IUniswapV2Router02 {
918     function factory() external pure returns (address);
919 
920     function WETH() external pure returns (address);
921 
922     function addLiquidity(
923         address tokenA,
924         address tokenB,
925         uint256 amountADesired,
926         uint256 amountBDesired,
927         uint256 amountAMin,
928         uint256 amountBMin,
929         address to,
930         uint256 deadline
931     )
932         external
933         returns (
934             uint256 amountA,
935             uint256 amountB,
936             uint256 liquidity
937         );
938 
939     function addLiquidityETH(
940         address token,
941         uint256 amountTokenDesired,
942         uint256 amountTokenMin,
943         uint256 amountETHMin,
944         address to,
945         uint256 deadline
946     )
947         external
948         payable
949         returns (
950             uint256 amountToken,
951             uint256 amountETH,
952             uint256 liquidity
953         );
954 
955     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
956         uint256 amountIn,
957         uint256 amountOutMin,
958         address[] calldata path,
959         address to,
960         uint256 deadline
961     ) external;
962 
963     function swapExactETHForTokensSupportingFeeOnTransferTokens(
964         uint256 amountOutMin,
965         address[] calldata path,
966         address to,
967         uint256 deadline
968     ) external payable;
969 
970     function swapExactTokensForETHSupportingFeeOnTransferTokens(
971         uint256 amountIn,
972         uint256 amountOutMin,
973         address[] calldata path,
974         address to,
975         uint256 deadline
976     ) external;
977 }
978 
979 contract Karen is ERC20, Ownable {
980     using SafeMath for uint256;
981 
982     IUniswapV2Router02 public immutable uniswapV2Router;
983     address public immutable uniswapV2Pair;
984     address public constant deadAddress = address(0xdead);
985 
986     bool private swapping;
987 
988     address public marketingWallet;
989     address public devWallet;
990 
991     uint256 public maxTransactionAmount;
992     uint256 public swapTokensAtAmount;
993     uint256 public maxWallet;
994 
995     uint256 public percentForLPBurn = 25; // 25 = .25%
996     bool public lpBurnEnabled = false;
997     uint256 public lpBurnFrequency = 3600 seconds;
998     uint256 public lastLpBurnTime;
999 
1000     uint256 public manualBurnFrequency = 30 minutes;
1001     uint256 public lastManualLpBurnTime;
1002 
1003     bool public limitsInEffect = true;
1004     bool public tradingActive = false;
1005     bool public swapEnabled = false;
1006 
1007     // Anti-bot and anti-whale mappings and variables
1008     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
1009     mapping(address => bool) blacklisted;
1010     bool public transferDelayEnabled = true;
1011 
1012     uint256 public buyTotalFees;
1013     uint256 public buyMarketingFee;
1014     uint256 public buyLiquidityFee;
1015     uint256 public buyDevFee;
1016 
1017     uint256 public sellTotalFees;
1018     uint256 public sellMarketingFee;
1019     uint256 public sellLiquidityFee;
1020     uint256 public sellDevFee;
1021 
1022     uint256 public tokensForMarketing;
1023     uint256 public tokensForLiquidity;
1024     uint256 public tokensForDev;
1025 
1026     /******************/
1027 
1028     // exclude from fees and max transaction amount
1029     mapping(address => bool) private _isExcludedFromFees;
1030     mapping(address => bool) public _isExcludedMaxTransactionAmount;
1031 
1032     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
1033     // could be subject to a maximum transfer amount
1034     mapping(address => bool) public automatedMarketMakerPairs;
1035 
1036     event UpdateUniswapV2Router(
1037         address indexed newAddress,
1038         address indexed oldAddress
1039     );
1040 
1041     event ExcludeFromFees(address indexed account, bool isExcluded);
1042 
1043     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
1044 
1045     event marketingWalletUpdated(
1046         address indexed newWallet,
1047         address indexed oldWallet
1048     );
1049 
1050     event devWalletUpdated(
1051         address indexed newWallet,
1052         address indexed oldWallet
1053     );
1054 
1055     event SwapAndLiquify(
1056         uint256 tokensSwapped,
1057         uint256 ethReceived,
1058         uint256 tokensIntoLiquidity
1059     );
1060 
1061     event AutoNukeLP();
1062 
1063     event ManualNukeLP();
1064 
1065     constructor() ERC20("Karen", "KAREN") {
1066         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
1067             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
1068         );
1069 
1070         excludeFromMaxTransaction(address(_uniswapV2Router), true);
1071         uniswapV2Router = _uniswapV2Router;
1072 
1073         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
1074             .createPair(address(this), _uniswapV2Router.WETH());
1075         excludeFromMaxTransaction(address(uniswapV2Pair), true);
1076         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
1077 
1078         uint256 _buyMarketingFee = 0;
1079         uint256 _buyLiquidityFee = 0;
1080         uint256 _buyDevFee = 0;
1081 
1082         uint256 _sellMarketingFee = 0;
1083         uint256 _sellLiquidityFee = 0;
1084         uint256 _sellDevFee = 0;
1085 
1086         uint256 totalSupply = 690_000_000_000 * 1e18;
1087 
1088         maxTransactionAmount = 3_450_000_000 * 1e18; // 0.5% from total supply
1089         maxWallet = 13_800_000_000 * 1e18; // 2% from total supply maxWallet
1090         swapTokensAtAmount = 345_000_000 * 1e18; // 0.05% swap wallet
1091 
1092         buyMarketingFee = _buyMarketingFee;
1093         buyLiquidityFee = _buyLiquidityFee;
1094         buyDevFee = _buyDevFee;
1095         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
1096 
1097         sellMarketingFee = _sellMarketingFee;
1098         sellLiquidityFee = _sellLiquidityFee;
1099         sellDevFee = _sellDevFee;
1100         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1101 
1102         marketingWallet = address(0x507Ba65BeD8B4328Cd862673fAC73eA67E59c59c); // set as marketing wallet
1103         devWallet = address(0x507Ba65BeD8B4328Cd862673fAC73eA67E59c59c); // set as dev wallet
1104 
1105         // exclude from paying fees or having max transaction amount
1106         excludeFromFees(owner(), true);
1107         excludeFromFees(address(this), true);
1108         excludeFromFees(address(0xdead), true);
1109 
1110         excludeFromMaxTransaction(owner(), true);
1111         excludeFromMaxTransaction(address(this), true);
1112         excludeFromMaxTransaction(address(0xdead), true);
1113 
1114         /*
1115             _mint is an internal function in ERC20.sol that is only called here,
1116             and CANNOT be called ever again
1117         */
1118         _mint(msg.sender, totalSupply);
1119     }
1120 
1121     receive() external payable {}
1122 
1123     // once enabled, can never be turned off
1124     function enableTrading() external onlyOwner {
1125         tradingActive = true;
1126         swapEnabled = true;
1127         lastLpBurnTime = block.timestamp;
1128     }
1129 
1130     // remove limits after token is stable
1131     function removeLimits() external onlyOwner returns (bool) {
1132         limitsInEffect = false;
1133         return true;
1134     }
1135 
1136     function enableLimits() external onlyOwner returns (bool) {
1137         limitsInEffect = true;
1138         return true;
1139     }
1140 
1141     // disable Transfer delay - cannot be reenabled
1142     function disableTransferDelay() external onlyOwner returns (bool) {
1143         transferDelayEnabled = false;
1144         return true;
1145     }
1146 
1147     // change the minimum amount of tokens to sell from fees
1148     function updateSwapTokensAtAmount(uint256 newAmount)
1149         external
1150         onlyOwner
1151         returns (bool)
1152     {
1153         require(
1154             newAmount >= (totalSupply() * 1) / 100000,
1155             "Swap amount cannot be lower than 0.001% total supply."
1156         );
1157         require(
1158             newAmount <= (totalSupply() * 5) / 1000,
1159             "Swap amount cannot be higher than 0.5% total supply."
1160         );
1161         swapTokensAtAmount = newAmount;
1162         return true;
1163     }
1164 
1165     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
1166         require(
1167             newNum >= ((totalSupply() * 1) / 1000) / 1e18,
1168             "Cannot set maxTransactionAmount lower than 0.1%"
1169         );
1170         maxTransactionAmount = newNum * (10**18);
1171     }
1172 
1173     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
1174         require(
1175             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
1176             "Cannot set maxWallet lower than 0.5%"
1177         );
1178         maxWallet = newNum * (10**18);
1179     }
1180 
1181     function excludeFromMaxTransaction(address updAds, bool isEx)
1182         public
1183         onlyOwner
1184     {
1185         _isExcludedMaxTransactionAmount[updAds] = isEx;
1186     }
1187 
1188     // only use to disable contract sales if absolutely necessary (emergency use only)
1189     function updateSwapEnabled(bool enabled) external onlyOwner {
1190         swapEnabled = enabled;
1191     }
1192 
1193     function updateBuyFees(
1194         uint256 _marketingFee,
1195         uint256 _liquidityFee,
1196         uint256 _devFee
1197     ) external onlyOwner {
1198         buyMarketingFee = _marketingFee;
1199         buyLiquidityFee = _liquidityFee;
1200         buyDevFee = _devFee;
1201         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
1202     }
1203 
1204     function updateSellFees(
1205         uint256 _marketingFee,
1206         uint256 _liquidityFee,
1207         uint256 _devFee
1208     ) external onlyOwner {
1209         sellMarketingFee = _marketingFee;
1210         sellLiquidityFee = _liquidityFee;
1211         sellDevFee = _devFee;
1212         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1213     }
1214 
1215     function excludeFromFees(address account, bool excluded) public onlyOwner {
1216         _isExcludedFromFees[account] = excluded;
1217         emit ExcludeFromFees(account, excluded);
1218     }
1219 
1220     function setAutomatedMarketMakerPair(address pair, bool value)
1221         public
1222         onlyOwner
1223     {
1224         require(
1225             pair != uniswapV2Pair,
1226             "The pair cannot be removed from automatedMarketMakerPairs"
1227         );
1228 
1229         _setAutomatedMarketMakerPair(pair, value);
1230     }
1231 
1232     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1233         automatedMarketMakerPairs[pair] = value;
1234 
1235         emit SetAutomatedMarketMakerPair(pair, value);
1236     }
1237 
1238     function updateMarketingWallet(address newMarketingWallet) external onlyOwner {
1239         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
1240         marketingWallet = newMarketingWallet;
1241     }
1242 
1243     function updateDevWallet(address newWallet) external onlyOwner {
1244         emit devWalletUpdated(newWallet, devWallet);
1245         devWallet = newWallet;
1246     }
1247 
1248     function isExcludedFromFees(address account) public view returns (bool) {
1249         return _isExcludedFromFees[account];
1250     }
1251 
1252     function isBlacklisted(address account) public view returns (bool) {
1253         return blacklisted[account];
1254     }
1255 
1256     function _transfer(
1257         address from,
1258         address to,
1259         uint256 amount
1260     ) internal override {
1261         require(from != address(0), "ERC20: transfer from the zero address");
1262         require(to != address(0), "ERC20: transfer to the zero address");
1263         require(!blacklisted[from],"Sender blacklisted");
1264         require(!blacklisted[to],"Receiver blacklisted");
1265 
1266         if (amount == 0) {
1267             super._transfer(from, to, 0);
1268             return;
1269         }
1270 
1271         if (limitsInEffect) {
1272             if (
1273                 from != owner() &&
1274                 to != owner() &&
1275                 to != address(0) &&
1276                 to != address(0xdead) &&
1277                 !swapping
1278             ) {
1279                 if (!tradingActive) {
1280                     require(
1281                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
1282                         "Trading is not active."
1283                     );
1284                 }
1285 
1286                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.
1287                 if (transferDelayEnabled) {
1288                     if (
1289                         to != owner() &&
1290                         to != address(uniswapV2Router) &&
1291                         to != address(uniswapV2Pair)
1292                     ) {
1293                         require(
1294                             _holderLastTransferTimestamp[tx.origin] + 1 <
1295                                 block.number,
1296                             "_transfer:: Transfer Delay enabled.  Only one purchase per two blocks allowed."
1297                         );
1298                         _holderLastTransferTimestamp[tx.origin] = block.number;
1299                     }
1300                 }
1301 
1302                 //when buy
1303                 if (
1304                     automatedMarketMakerPairs[from] &&
1305                     !_isExcludedMaxTransactionAmount[to]
1306                 ) {
1307                     require(
1308                         amount <= maxTransactionAmount,
1309                         "Buy transfer amount exceeds the maxTransactionAmount."
1310                     );
1311                     require(
1312                         amount + balanceOf(to) <= maxWallet,
1313                         "Max wallet exceeded"
1314                     );
1315                 }
1316                 //when sell
1317                 else if (
1318                     automatedMarketMakerPairs[to] &&
1319                     !_isExcludedMaxTransactionAmount[from]
1320                 ) {
1321                     require(
1322                         amount <= maxTransactionAmount,
1323                         "Sell transfer amount exceeds the maxTransactionAmount."
1324                     );
1325                 } else if (!_isExcludedMaxTransactionAmount[to]) {
1326                     require(
1327                         amount + balanceOf(to) <= maxWallet,
1328                         "Max wallet exceeded"
1329                     );
1330                 }
1331             }
1332         }
1333 
1334         uint256 contractTokenBalance = balanceOf(address(this));
1335 
1336         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1337 
1338         if (
1339             canSwap &&
1340             swapEnabled &&
1341             !swapping &&
1342             !automatedMarketMakerPairs[from] &&
1343             !_isExcludedFromFees[from] &&
1344             !_isExcludedFromFees[to]
1345         ) {
1346             swapping = true;
1347 
1348             swapBack();
1349 
1350             swapping = false;
1351         }
1352 
1353         if (
1354             !swapping &&
1355             automatedMarketMakerPairs[to] &&
1356             lpBurnEnabled &&
1357             block.timestamp >= lastLpBurnTime + lpBurnFrequency &&
1358             !_isExcludedFromFees[from]
1359         ) {
1360             autoBurnLiquidityPairTokens();
1361         }
1362 
1363         bool takeFee = !swapping;
1364 
1365         // if any account belongs to _isExcludedFromFee account then remove the fee
1366         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1367             takeFee = false;
1368         }
1369 
1370         uint256 fees = 0;
1371         // only take fees on buys/sells, do not take on wallet transfers
1372         if (takeFee) {
1373             // on sell
1374             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
1375                 fees = amount.mul(sellTotalFees).div(100);
1376                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
1377                 tokensForDev += (fees * sellDevFee) / sellTotalFees;
1378                 tokensForMarketing += (fees * sellMarketingFee) / sellTotalFees;
1379             }
1380             // on buy
1381             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1382                 fees = amount.mul(buyTotalFees).div(100);
1383                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
1384                 tokensForDev += (fees * buyDevFee) / buyTotalFees;
1385                 tokensForMarketing += (fees * buyMarketingFee) / buyTotalFees;
1386             }
1387 
1388             if (fees > 0) {
1389                 super._transfer(from, address(this), fees);
1390             }
1391 
1392             amount -= fees;
1393         }
1394 
1395         super._transfer(from, to, amount);
1396     }
1397 
1398     function swapTokensForEth(uint256 tokenAmount) private {
1399         // generate the uniswap pair path of token -> weth
1400         address[] memory path = new address[](2);
1401         path[0] = address(this);
1402         path[1] = uniswapV2Router.WETH();
1403 
1404         _approve(address(this), address(uniswapV2Router), tokenAmount);
1405 
1406         // make the swap
1407         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1408             tokenAmount,
1409             0, // accept any amount of ETH
1410             path,
1411             address(this),
1412             block.timestamp
1413         );
1414     }
1415 
1416     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1417         // approve token transfer to cover all possible scenarios
1418         _approve(address(this), address(uniswapV2Router), tokenAmount);
1419 
1420         // add the liquidity
1421         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1422             address(this),
1423             tokenAmount,
1424             0, // slippage is unavoidable
1425             0, // slippage is unavoidable
1426             owner(),
1427             block.timestamp
1428         );
1429     }
1430 
1431     function swapBack() private {
1432         uint256 contractBalance = balanceOf(address(this));
1433         uint256 totalTokensToSwap = tokensForLiquidity +
1434             tokensForMarketing +
1435             tokensForDev;
1436         bool success;
1437 
1438         if (contractBalance == 0 || totalTokensToSwap == 0) {
1439             return;
1440         }
1441 
1442         if (contractBalance > swapTokensAtAmount * 20) {
1443             contractBalance = swapTokensAtAmount * 20;
1444         }
1445 
1446         // Halve the amount of liquidity tokens
1447         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) /
1448             totalTokensToSwap /
1449             2;
1450         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1451 
1452         uint256 initialETHBalance = address(this).balance;
1453 
1454         swapTokensForEth(amountToSwapForETH);
1455 
1456         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1457 
1458         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(totalTokensToSwap - (tokensForLiquidity / 2));
1459         
1460         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap - (tokensForLiquidity / 2));
1461 
1462         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev;
1463 
1464         tokensForLiquidity = 0;
1465         tokensForMarketing = 0;
1466         tokensForDev = 0;
1467 
1468         (success, ) = address(devWallet).call{value: ethForDev}("");
1469 
1470         if (liquidityTokens > 0 && ethForLiquidity > 0) {
1471             addLiquidity(liquidityTokens, ethForLiquidity);
1472             emit SwapAndLiquify(
1473                 amountToSwapForETH,
1474                 ethForLiquidity,
1475                 tokensForLiquidity
1476             );
1477         }
1478 
1479         (success, ) = address(marketingWallet).call{value: address(this).balance}("");
1480     }
1481 
1482     function setAutoLPBurnSettings(
1483         uint256 _frequencyInSeconds,
1484         uint256 _percent,
1485         bool _Enabled
1486     ) external onlyOwner {
1487         require(
1488             _frequencyInSeconds >= 600,
1489             "cannot set buyback more often than every 10 minutes"
1490         );
1491         require(
1492             _percent <= 1000 && _percent >= 0,
1493             "Must set auto LP burn percent between 0% and 10%"
1494         );
1495         lpBurnFrequency = _frequencyInSeconds;
1496         percentForLPBurn = _percent;
1497         lpBurnEnabled = _Enabled;
1498     }
1499 
1500     function autoBurnLiquidityPairTokens() internal returns (bool) {
1501         lastLpBurnTime = block.timestamp;
1502 
1503         // get balance of liquidity pair
1504         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1505 
1506         // calculate amount to burn
1507         uint256 amountToBurn = liquidityPairBalance.mul(percentForLPBurn).div(
1508             10000
1509         );
1510 
1511         // pull tokens from Pair liquidity and move to dead address permanently
1512         if (amountToBurn > 0) {
1513             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1514         }
1515 
1516         //sync price since this is not in a swap transaction!
1517         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1518         pair.sync();
1519         emit AutoNukeLP();
1520         return true;
1521     }
1522 
1523     function manualBurnLiquidityPairTokens(uint256 percent)
1524         external
1525         onlyOwner
1526         returns (bool)
1527     {
1528         require(
1529             block.timestamp > lastManualLpBurnTime + manualBurnFrequency,
1530             "Must wait for cooldown to finish"
1531         );
1532         require(percent <= 1000, "May not nuke more than 10% of tokens in LP");
1533         lastManualLpBurnTime = block.timestamp;
1534 
1535         // get balance of liquidity pair
1536         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1537 
1538         // calculate amount to burn
1539         uint256 amountToBurn = liquidityPairBalance.mul(percent).div(10000);
1540 
1541         // pull tokens from Pair liquidity and move to dead address permanently
1542         if (amountToBurn > 0) {
1543             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1544         }
1545 
1546         //sync price since this is not in a swap transaction!
1547         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1548         pair.sync();
1549         emit ManualNukeLP();
1550         return true;
1551     }
1552 
1553     function withdraw() external onlyOwner {
1554         uint256 balance = IERC20(address(this)).balanceOf(address(this));
1555         IERC20(address(this)).transfer(msg.sender, balance);
1556         payable(msg.sender).transfer(address(this).balance);
1557     }
1558 
1559     function withdrawToken(address _token, address _to) external onlyOwner {
1560         require(_token != address(0), "_token address cannot be 0");
1561         uint256 _contractBalance = IERC20(_token).balanceOf(address(this));
1562         IERC20(_token).transfer(_to, _contractBalance);
1563     }
1564 
1565     function blacklist(address _black) public onlyOwner {
1566         blacklisted[_black] = true;
1567     }
1568 
1569     function unblacklist(address _black) public onlyOwner {
1570         blacklisted[_black] = false;
1571     }
1572 }