1 /**
2  *Submitted for verification at Etherscan.io on 2023-09-15
3 */
4 
5 // SPDX-License-Identifier: MIT
6 pragma solidity 0.8.20;
7 pragma experimental ABIEncoderV2;
8 
9 /**
10  * @dev Provides information about the current execution context, including the
11  * sender of the transaction and its data. While these are generally available
12  * via msg.sender and msg.data, they should not be accessed in such a direct
13  * manner, since when dealing with meta-transactions the account sending and
14  * paying for execution may not be the actual sender (as far as an application
15  * is concerned).
16  *
17  * This contract is only required for intermediate, library-like contracts.
18  */
19 abstract contract Context {
20     function _msgSender() internal view virtual returns (address) {
21         return msg.sender;
22     }
23 
24     function _msgData() internal view virtual returns (bytes calldata) {
25         return msg.data;
26     }
27 }
28 
29 /**
30  * @dev Contract module which provides a basic access control mechanism, where
31  * there is an account (an owner) that can be granted exclusive access to
32  * specific functions.
33  *
34  * By default, the owner account will be the one that deploys the contract. This
35  * can later be changed with {transferOwnership}.
36  *
37  * This module is used through inheritance. It will make available the modifier
38  * `onlyOwner`, which can be applied to your functions to restrict their use to
39  * the owner.
40  */
41 abstract contract Ownable is Context {
42     address private _owner;
43 
44     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
45 
46     /**
47      * @dev Initializes the contract setting the deployer as the initial owner.
48      */
49     constructor() {
50         _transferOwnership(_msgSender());
51     }
52 
53     /**
54      * @dev Returns the address of the current owner.
55      */
56     function owner() public view virtual returns (address) {
57         return _owner;
58     }
59 
60     /**
61      * @dev Throws if called by any account other than the owner.
62      */
63     modifier onlyOwner() {
64         require(owner() == _msgSender(), "Ownable: caller is not the owner");
65         _;
66     }
67 
68     /**
69      * @dev Leaves the contract without owner. It will not be possible to call
70      * `onlyOwner` functions anymore. Can only be called by the current owner.
71      *
72      * NOTE: Renouncing ownership will leave the contract without an owner,
73      * thereby removing any functionality that is only available to the owner.
74      */
75     function renounceOwnership() public virtual onlyOwner {
76         _transferOwnership(address(0));
77     }
78 
79     /**
80      * @dev Transfers ownership of the contract to a new account (`newOwner`).
81      * Can only be called by the current owner.
82      */
83     function transferOwnership(address newOwner) public virtual onlyOwner {
84         require(newOwner != address(0), "Ownable: new owner is the zero address");
85         _transferOwnership(newOwner);
86     }
87 
88     /**
89      * @dev Transfers ownership of the contract to a new account (`newOwner`).
90      * Internal function without access restriction.
91      */
92     function _transferOwnership(address newOwner) internal virtual {
93         address oldOwner = _owner;
94         _owner = newOwner;
95         emit OwnershipTransferred(oldOwner, newOwner);
96     }
97 }
98 
99 /**
100  * @dev Interface of the ERC20 standard as defined in the EIP.
101  */
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
177 /**
178  * @dev Interface for the optional metadata functions from the ERC20 standard.
179  *
180  * _Available since v4.1._
181  */
182 interface IERC20Metadata is IERC20 {
183     /**
184      * @dev Returns the name of the token.
185      */
186     function name() external view returns (string memory);
187 
188     /**
189      * @dev Returns the symbol of the token.
190      */
191     function symbol() external view returns (string memory);
192 
193     /**
194      * @dev Returns the decimals places of the token.
195      */
196     function decimals() external view returns (uint8);
197 }
198 
199 /**
200  * @dev Implementation of the {IERC20} interface.
201  *
202  * This implementation is agnostic to the way tokens are created. This means
203  * that a supply mechanism has to be added in a derived contract using {_mint}.
204  * For a generic mechanism see {ERC20PresetMinterPauser}.
205  *
206  * TIP: For a detailed writeup see our guide
207  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
208  * to implement supply mechanisms].
209  *
210  * We have followed general OpenZeppelin Contracts guidelines: functions revert
211  * instead returning `false` on failure. This behavior is nonetheless
212  * conventional and does not conflict with the expectations of ERC20
213  * applications.
214  *
215  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
216  * This allows applications to reconstruct the allowance for all accounts just
217  * by listening to said events. Other implementations of the EIP may not emit
218  * these events, as it isn't required by the specification.
219  *
220  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
221  * functions have been added to mitigate the well-known issues around setting
222  * allowances. See {IERC20-approve}.
223  */
224 contract ERC20 is Context, IERC20, IERC20Metadata {
225     mapping(address => uint256) private _balances;
226 
227     mapping(address => mapping(address => uint256)) private _allowances;
228 
229     uint256 private _totalSupply;
230 
231     string private _name;
232     string private _symbol;
233 
234     /**
235      * @dev Sets the values for {name} and {symbol}.
236      *
237      * The default value of {decimals} is 18. To select a different value for
238      * {decimals} you should overload it.
239      *
240      * All two of these values are immutable: they can only be set once during
241      * construction.
242      */
243     constructor(string memory name_, string memory symbol_) {
244         _name = name_;
245         _symbol = symbol_;
246     }
247 
248     /**
249      * @dev Returns the name of the token.
250      */
251     function name() public view virtual override returns (string memory) {
252         return _name;
253     }
254 
255     /**
256      * @dev Returns the symbol of the token, usually a shorter version of the
257      * name.
258      */
259     function symbol() public view virtual override returns (string memory) {
260         return _symbol;
261     }
262 
263     /**
264      * @dev Returns the number of decimals used to get its user representation.
265      * For example, if `decimals` equals `2`, a balance of `505` tokens should
266      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
267      *
268      * Tokens usually opt for a value of 18, imitating the relationship between
269      * Ether and Wei. This is the value {ERC20} uses, unless this function is
270      * overridden;
271      *
272      * NOTE: This information is only used for _display_ purposes: it in
273      * no way affects any of the arithmetic of the contract, including
274      * {IERC20-balanceOf} and {IERC20-transfer}.
275      */
276     function decimals() public view virtual override returns (uint8) {
277         return 18;
278     }
279 
280     /**
281      * @dev See {IERC20-totalSupply}.
282      */
283     function totalSupply() public view virtual override returns (uint256) {
284         return _totalSupply;
285     }
286 
287     /**
288      * @dev See {IERC20-balanceOf}.
289      */
290     function balanceOf(address account) public view virtual override returns (uint256) {
291         return _balances[account];
292     }
293 
294     /**
295      * @dev See {IERC20-transfer}.
296      *
297      * Requirements:
298      *
299      * - `recipient` cannot be the zero address.
300      * - the caller must have a balance of at least `amount`.
301      */
302     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
303         _transfer(_msgSender(), recipient, amount);
304         return true;
305     }
306 
307     /**
308      * @dev See {IERC20-allowance}.
309      */
310     function allowance(address owner, address spender) public view virtual override returns (uint256) {
311         return _allowances[owner][spender];
312     }
313 
314     /**
315      * @dev See {IERC20-approve}.
316      *
317      * Requirements:
318      *
319      * - `spender` cannot be the zero address.
320      */
321     function approve(address spender, uint256 amount) public virtual override returns (bool) {
322         _approve(_msgSender(), spender, amount);
323         return true;
324     }
325 
326     /**
327      * @dev See {IERC20-transferFrom}.
328      *
329      * Emits an {Approval} event indicating the updated allowance. This is not
330      * required by the EIP. See the note at the beginning of {ERC20}.
331      *
332      * Requirements:
333      *
334      * - `sender` and `recipient` cannot be the zero address.
335      * - `sender` must have a balance of at least `amount`.
336      * - the caller must have allowance for ``sender``'s tokens of at least
337      * `amount`.
338      */
339     function transferFrom(
340         address sender,
341         address recipient,
342         uint256 amount
343     ) public virtual override returns (bool) {
344         _transfer(sender, recipient, amount);
345 
346         uint256 currentAllowance = _allowances[sender][_msgSender()];
347         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
348         unchecked {
349             _approve(sender, _msgSender(), currentAllowance - amount);
350         }
351 
352         return true;
353     }
354 
355     /**
356      * @dev Atomically increases the allowance granted to `spender` by the caller.
357      *
358      * This is an alternative to {approve} that can be used as a mitigation for
359      * problems described in {IERC20-approve}.
360      *
361      * Emits an {Approval} event indicating the updated allowance.
362      *
363      * Requirements:
364      *
365      * - `spender` cannot be the zero address.
366      */
367     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
368         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
369         return true;
370     }
371 
372     /**
373      * @dev Atomically decreases the allowance granted to `spender` by the caller.
374      *
375      * This is an alternative to {approve} that can be used as a mitigation for
376      * problems described in {IERC20-approve}.
377      *
378      * Emits an {Approval} event indicating the updated allowance.
379      *
380      * Requirements:
381      *
382      * - `spender` cannot be the zero address.
383      * - `spender` must have allowance for the caller of at least
384      * `subtractedValue`.
385      */
386     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
387         uint256 currentAllowance = _allowances[_msgSender()][spender];
388         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
389         unchecked {
390             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
391         }
392 
393         return true;
394     }
395 
396     /**
397      * @dev Moves `amount` of tokens from `sender` to `recipient`.
398      *
399      * This internal function is equivalent to {transfer}, and can be used to
400      * e.g. implement automatic token fees, slashing mechanisms, etc.
401      *
402      * Emits a {Transfer} event.
403      *
404      * Requirements:
405      *
406      * - `sender` cannot be the zero address.
407      * - `recipient` cannot be the zero address.
408      * - `sender` must have a balance of at least `amount`.
409      */
410     function _transfer(
411         address sender,
412         address recipient,
413         uint256 amount
414     ) internal virtual {
415         require(sender != address(0), "ERC20: transfer from the zero address");
416         require(recipient != address(0), "ERC20: transfer to the zero address");
417 
418         _beforeTokenTransfer(sender, recipient, amount);
419 
420         uint256 senderBalance = _balances[sender];
421         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
422         unchecked {
423             _balances[sender] = senderBalance - amount;
424         }
425         _balances[recipient] += amount;
426 
427         emit Transfer(sender, recipient, amount);
428 
429         _afterTokenTransfer(sender, recipient, amount);
430     }
431 
432     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
433      * the total supply.
434      *
435      * Emits a {Transfer} event with `from` set to the zero address.
436      *
437      * Requirements:
438      *
439      * - `account` cannot be the zero address.
440      */
441     function _mint(address account, uint256 amount) internal virtual {
442         require(account != address(0), "ERC20: mint to the zero address");
443 
444         _beforeTokenTransfer(address(0), account, amount);
445 
446         _totalSupply += amount;
447         _balances[account] += amount;
448         emit Transfer(address(0), account, amount);
449 
450         _afterTokenTransfer(address(0), account, amount);
451     }
452 
453     /**
454      * @dev Destroys `amount` tokens from `account`, reducing the
455      * total supply.
456      *
457      * Emits a {Transfer} event with `to` set to the zero address.
458      *
459      * Requirements:
460      *
461      * - `account` cannot be the zero address.
462      * - `account` must have at least `amount` tokens.
463      */
464     function _burn(address account, uint256 amount) internal virtual {
465         require(account != address(0), "ERC20: burn from the zero address");
466 
467         _beforeTokenTransfer(account, address(0), amount);
468 
469         uint256 accountBalance = _balances[account];
470         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
471         unchecked {
472             _balances[account] = accountBalance - amount;
473         }
474         _totalSupply -= amount;
475 
476         emit Transfer(account, address(0), amount);
477 
478         _afterTokenTransfer(account, address(0), amount);
479     }
480 
481     /**
482      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
483      *
484      * This internal function is equivalent to `approve`, and can be used to
485      * e.g. set automatic allowances for certain subsystems, etc.
486      *
487      * Emits an {Approval} event.
488      *
489      * Requirements:
490      *
491      * - `owner` cannot be the zero address.
492      * - `spender` cannot be the zero address.
493      */
494     function _approve(
495         address owner,
496         address spender,
497         uint256 amount
498     ) internal virtual {
499         require(owner != address(0), "ERC20: approve from the zero address");
500         require(spender != address(0), "ERC20: approve to the zero address");
501 
502         _allowances[owner][spender] = amount;
503         emit Approval(owner, spender, amount);
504     }
505 
506     /**
507      * @dev Hook that is called before any transfer of tokens. This includes
508      * minting and burning.
509      *
510      * Calling conditions:
511      *
512      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
513      * will be transferred to `to`.
514      * - when `from` is zero, `amount` tokens will be minted for `to`.
515      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
516      * - `from` and `to` are never both zero.
517      *
518      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
519      */
520     function _beforeTokenTransfer(
521         address from,
522         address to,
523         uint256 amount
524     ) internal virtual {}
525 
526     /**
527      * @dev Hook that is called after any transfer of tokens. This includes
528      * minting and burning.
529      *
530      * Calling conditions:
531      *
532      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
533      * has been transferred to `to`.
534      * - when `from` is zero, `amount` tokens have been minted for `to`.
535      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
536      * - `from` and `to` are never both zero.
537      *
538      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
539      */
540     function _afterTokenTransfer(
541         address from,
542         address to,
543         uint256 amount
544     ) internal virtual {}
545 }
546 
547 /**
548  * @dev Wrappers over Solidity's arithmetic operations.
549  *
550  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
551  * now has built in overflow checking.
552  */
553 library SafeMath {
554     /**
555      * @dev Returns the addition of two unsigned integers, with an overflow flag.
556      *
557      * _Available since v3.4._
558      */
559     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
560         unchecked {
561             uint256 c = a + b;
562             if (c < a) return (false, 0);
563             return (true, c);
564         }
565     }
566 
567     /**
568      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
569      *
570      * _Available since v3.4._
571      */
572     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
573         unchecked {
574             if (b > a) return (false, 0);
575             return (true, a - b);
576         }
577     }
578 
579     /**
580      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
581      *
582      * _Available since v3.4._
583      */
584     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
585         unchecked {
586             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
587             // benefit is lost if 'b' is also tested.
588             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
589             if (a == 0) return (true, 0);
590             uint256 c = a * b;
591             if (c / a != b) return (false, 0);
592             return (true, c);
593         }
594     }
595 
596     /**
597      * @dev Returns the division of two unsigned integers, with a division by zero flag.
598      *
599      * _Available since v3.4._
600      */
601     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
602         unchecked {
603             if (b == 0) return (false, 0);
604             return (true, a / b);
605         }
606     }
607 
608     /**
609      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
610      *
611      * _Available since v3.4._
612      */
613     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
614         unchecked {
615             if (b == 0) return (false, 0);
616             return (true, a % b);
617         }
618     }
619 
620     /**
621      * @dev Returns the addition of two unsigned integers, reverting on
622      * overflow.
623      *
624      * Counterpart to Solidity's `+` operator.
625      *
626      * Requirements:
627      *
628      * - Addition cannot overflow.
629      */
630     function add(uint256 a, uint256 b) internal pure returns (uint256) {
631         return a + b;
632     }
633 
634     /**
635      * @dev Returns the subtraction of two unsigned integers, reverting on
636      * overflow (when the result is negative).
637      *
638      * Counterpart to Solidity's `-` operator.
639      *
640      * Requirements:
641      *
642      * - Subtraction cannot overflow.
643      */
644     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
645         return a - b;
646     }
647 
648     /**
649      * @dev Returns the multiplication of two unsigned integers, reverting on
650      * overflow.
651      *
652      * Counterpart to Solidity's `*` operator.
653      *
654      * Requirements:
655      *
656      * - Multiplication cannot overflow.
657      */
658     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
659         return a * b;
660     }
661 
662     /**
663      * @dev Returns the integer division of two unsigned integers, reverting on
664      * division by zero. The result is rounded towards zero.
665      *
666      * Counterpart to Solidity's `/` operator.
667      *
668      * Requirements:
669      *
670      * - The divisor cannot be zero.
671      */
672     function div(uint256 a, uint256 b) internal pure returns (uint256) {
673         return a / b;
674     }
675 
676     /**
677      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
678      * reverting when dividing by zero.
679      *
680      * Counterpart to Solidity's `%` operator. This function uses a `revert`
681      * opcode (which leaves remaining gas untouched) while Solidity uses an
682      * invalid opcode to revert (consuming all remaining gas).
683      *
684      * Requirements:
685      *
686      * - The divisor cannot be zero.
687      */
688     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
689         return a % b;
690     }
691 
692     /**
693      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
694      * overflow (when the result is negative).
695      *
696      * CAUTION: This function is deprecated because it requires allocating memory for the error
697      * message unnecessarily. For custom revert reasons use {trySub}.
698      *
699      * Counterpart to Solidity's `-` operator.
700      *
701      * Requirements:
702      *
703      * - Subtraction cannot overflow.
704      */
705     function sub(
706         uint256 a,
707         uint256 b,
708         string memory errorMessage
709     ) internal pure returns (uint256) {
710         unchecked {
711             require(b <= a, errorMessage);
712             return a - b;
713         }
714     }
715 
716     /**
717      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
718      * division by zero. The result is rounded towards zero.
719      *
720      * Counterpart to Solidity's `/` operator. Note: this function uses a
721      * `revert` opcode (which leaves remaining gas untouched) while Solidity
722      * uses an invalid opcode to revert (consuming all remaining gas).
723      *
724      * Requirements:
725      *
726      * - The divisor cannot be zero.
727      */
728     function div(
729         uint256 a,
730         uint256 b,
731         string memory errorMessage
732     ) internal pure returns (uint256) {
733         unchecked {
734             require(b > 0, errorMessage);
735             return a / b;
736         }
737     }
738 
739     /**
740      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
741      * reverting with custom message when dividing by zero.
742      *
743      * CAUTION: This function is deprecated because it requires allocating memory for the error
744      * message unnecessarily. For custom revert reasons use {tryMod}.
745      *
746      * Counterpart to Solidity's `%` operator. This function uses a `revert`
747      * opcode (which leaves remaining gas untouched) while Solidity uses an
748      * invalid opcode to revert (consuming all remaining gas).
749      *
750      * Requirements:
751      *
752      * - The divisor cannot be zero.
753      */
754     function mod(
755         uint256 a,
756         uint256 b,
757         string memory errorMessage
758     ) internal pure returns (uint256) {
759         unchecked {
760             require(b > 0, errorMessage);
761             return a % b;
762         }
763     }
764 }
765 
766 interface IUniswapV2Factory {
767     event PairCreated(
768         address indexed token0,
769         address indexed token1,
770         address pair,
771         uint256
772     );
773 
774     function feeTo() external view returns (address);
775 
776     function feeToSetter() external view returns (address);
777 
778     function getPair(address tokenA, address tokenB)
779         external
780         view
781         returns (address pair);
782 
783     function allPairs(uint256) external view returns (address pair);
784 
785     function allPairsLength() external view returns (uint256);
786 
787     function createPair(address tokenA, address tokenB)
788         external
789         returns (address pair);
790 
791     function setFeeTo(address) external;
792 
793     function setFeeToSetter(address) external;
794 }
795 
796 interface IUniswapV2Pair {
797     event Approval(
798         address indexed owner,
799         address indexed spender,
800         uint256 value
801     );
802     event Transfer(address indexed from, address indexed to, uint256 value);
803 
804     function name() external pure returns (string memory);
805 
806     function symbol() external pure returns (string memory);
807 
808     function decimals() external pure returns (uint8);
809 
810     function totalSupply() external view returns (uint256);
811 
812     function balanceOf(address owner) external view returns (uint256);
813 
814     function allowance(address owner, address spender)
815         external
816         view
817         returns (uint256);
818 
819     function approve(address spender, uint256 value) external returns (bool);
820 
821     function transfer(address to, uint256 value) external returns (bool);
822 
823     function transferFrom(
824         address from,
825         address to,
826         uint256 value
827     ) external returns (bool);
828 
829     function DOMAIN_SEPARATOR() external view returns (bytes32);
830 
831     function PERMIT_TYPEHASH() external pure returns (bytes32);
832 
833     function nonces(address owner) external view returns (uint256);
834 
835     function permit(
836         address owner,
837         address spender,
838         uint256 value,
839         uint256 deadline,
840         uint8 v,
841         bytes32 r,
842         bytes32 s
843     ) external;
844 
845     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
846     event Burn(
847         address indexed sender,
848         uint256 amount0,
849         uint256 amount1,
850         address indexed to
851     );
852     event Swap(
853         address indexed sender,
854         uint256 amount0In,
855         uint256 amount1In,
856         uint256 amount0Out,
857         uint256 amount1Out,
858         address indexed to
859     );
860     event Sync(uint112 reserve0, uint112 reserve1);
861 
862     function MINIMUM_LIQUIDITY() external pure returns (uint256);
863 
864     function factory() external view returns (address);
865 
866     function token0() external view returns (address);
867 
868     function token1() external view returns (address);
869 
870     function getReserves()
871         external
872         view
873         returns (
874             uint112 reserve0,
875             uint112 reserve1,
876             uint32 blockTimestampLast
877         );
878 
879     function price0CumulativeLast() external view returns (uint256);
880 
881     function price1CumulativeLast() external view returns (uint256);
882 
883     function kLast() external view returns (uint256);
884 
885     function mint(address to) external returns (uint256 liquidity);
886 
887     function burn(address to)
888         external
889         returns (uint256 amount0, uint256 amount1);
890 
891     function swap(
892         uint256 amount0Out,
893         uint256 amount1Out,
894         address to,
895         bytes calldata data
896     ) external;
897 
898     function skim(address to) external;
899 
900     function sync() external;
901 
902     function initialize(address, address) external;
903 }
904 
905 interface IUniswapV2Router02 {
906     function factory() external pure returns (address);
907 
908     function WETH() external pure returns (address);
909 
910     function addLiquidity(
911         address tokenA,
912         address tokenB,
913         uint256 amountADesired,
914         uint256 amountBDesired,
915         uint256 amountAMin,
916         uint256 amountBMin,
917         address to,
918         uint256 deadline
919     )
920         external
921         returns (
922             uint256 amountA,
923             uint256 amountB,
924             uint256 liquidity
925         );
926 
927     function addLiquidityETH(
928         address token,
929         uint256 amountTokenDesired,
930         uint256 amountTokenMin,
931         uint256 amountETHMin,
932         address to,
933         uint256 deadline
934     )
935         external
936         payable
937         returns (
938             uint256 amountToken,
939             uint256 amountETH,
940             uint256 liquidity
941         );
942 
943     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
944         uint256 amountIn,
945         uint256 amountOutMin,
946         address[] calldata path,
947         address to,
948         uint256 deadline
949     ) external;
950 
951     function swapExactETHForTokensSupportingFeeOnTransferTokens(
952         uint256 amountOutMin,
953         address[] calldata path,
954         address to,
955         uint256 deadline
956     ) external payable;
957 
958     function swapExactTokensForETHSupportingFeeOnTransferTokens(
959         uint256 amountIn,
960         uint256 amountOutMin,
961         address[] calldata path,
962         address to,
963         uint256 deadline
964     ) external;
965 }
966 
967 contract Perpbot is ERC20, Ownable {
968     using SafeMath for uint256;
969 
970     IUniswapV2Router02 public immutable uniswapV2Router;
971     address public immutable uniswapV2Pair;
972     address public constant deadAddress = address(0xdead);
973 
974     bool private swapping;
975 
976     address public revShareWallet;
977     address public teamWallet;
978 
979     uint256 public maxTransactionAmount;
980     uint256 public swapTokensAtAmount;
981     uint256 public maxWallet;
982 
983     bool public limitsInEffect = true;
984     bool public tradingActive = false;
985     bool public swapEnabled = false;
986 
987     bool public blacklistRenounced = false;
988 
989     // Anti-bot and anti-whale mappings and variables
990     mapping(address => bool) blacklisted;
991 
992     uint256 public buyTotalFees;
993     uint256 public buyRevShareFee;
994     uint256 public buyLiquidityFee;
995     uint256 public buyTeamFee;
996 
997     uint256 public sellTotalFees;
998     uint256 public sellRevShareFee;
999     uint256 public sellLiquidityFee;
1000     uint256 public sellTeamFee;
1001 
1002     uint256 public tokensForRevShare;
1003     uint256 public tokensForLiquidity;
1004     uint256 public tokensForTeam;
1005 
1006     /******************/
1007 
1008     // exclude from fees and max transaction amount
1009     mapping(address => bool) private _isExcludedFromFees;
1010     mapping(address => bool) public _isExcludedMaxTransactionAmount;
1011 
1012     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
1013     // could be subject to a maximum transfer amount
1014     mapping(address => bool) public automatedMarketMakerPairs;
1015 
1016     bool public preMigrationPhase = true;
1017     mapping(address => bool) public preMigrationTransferrable;
1018 
1019     event UpdateUniswapV2Router(
1020         address indexed newAddress,
1021         address indexed oldAddress
1022     );
1023 
1024     event ExcludeFromFees(address indexed account, bool isExcluded);
1025 
1026     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
1027 
1028     event revShareWalletUpdated(
1029         address indexed newWallet,
1030         address indexed oldWallet
1031     );
1032 
1033     event teamWalletUpdated(
1034         address indexed newWallet,
1035         address indexed oldWallet
1036     );
1037 
1038     event SwapAndLiquify(
1039         uint256 tokensSwapped,
1040         uint256 ethReceived,
1041         uint256 tokensIntoLiquidity
1042     );
1043 
1044     constructor() ERC20("Perpbot", "PB") {
1045         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
1046             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
1047         );
1048 
1049         excludeFromMaxTransaction(address(_uniswapV2Router), true);
1050         uniswapV2Router = _uniswapV2Router;
1051 
1052         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
1053             .createPair(address(this), _uniswapV2Router.WETH());
1054         excludeFromMaxTransaction(address(uniswapV2Pair), true);
1055         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
1056 
1057         uint256 _buyRevShareFee = 5;
1058         uint256 _buyLiquidityFee = 0;
1059         uint256 _buyTeamFee = 0;
1060 
1061         uint256 _sellRevShareFee = 5;
1062         uint256 _sellLiquidityFee = 0;
1063         uint256 _sellTeamFee = 0;
1064 
1065         uint256 totalSupply = 1_000_000 * 1e18;
1066 
1067         maxTransactionAmount = 10_000 * 1e18; // 1%
1068         maxWallet = 10_000 * 1e18; // 1% 
1069         swapTokensAtAmount = (totalSupply * 5) / 10000; // 0.05% 
1070 
1071         buyRevShareFee = _buyRevShareFee;
1072         buyLiquidityFee = _buyLiquidityFee;
1073         buyTeamFee = _buyTeamFee;
1074         buyTotalFees = buyRevShareFee + buyLiquidityFee + buyTeamFee;
1075 
1076         sellRevShareFee = _sellRevShareFee;
1077         sellLiquidityFee = _sellLiquidityFee;
1078         sellTeamFee = _sellTeamFee;
1079         sellTotalFees = sellRevShareFee + sellLiquidityFee + sellTeamFee;
1080 
1081         revShareWallet = address(0x6b9E17d9a8572132364679Ad505c5db67A9Ab23b); // set as revShare wallet
1082         teamWallet = owner(); // set as team wallet
1083 
1084         // exclude from paying fees or having max transaction amount
1085         excludeFromFees(owner(), true);
1086         excludeFromFees(address(this), true);
1087         excludeFromFees(address(0xdead), true);
1088 
1089         excludeFromMaxTransaction(owner(), true);
1090         excludeFromMaxTransaction(address(this), true);
1091         excludeFromMaxTransaction(address(0xdead), true);
1092 
1093         preMigrationTransferrable[owner()] = true;
1094 
1095         /*
1096             _mint is an internal function in ERC20.sol that is only called here,
1097             and CANNOT be called ever again
1098         */
1099         _mint(msg.sender, totalSupply);
1100     }
1101 
1102     receive() external payable {}
1103 
1104     // once enabled, can never be turned off
1105     function enableTrading() external onlyOwner {
1106         tradingActive = true;
1107         swapEnabled = true;
1108         preMigrationPhase = false;
1109     }
1110 
1111     // remove limits after token is stable
1112     function removeLimits() external onlyOwner returns (bool) {
1113         limitsInEffect = false;
1114         return true;
1115     }
1116 
1117     // change the minimum amount of tokens to sell from fees
1118     function updateSwapTokensAtAmount(uint256 newAmount)
1119         external
1120         onlyOwner
1121         returns (bool)
1122     {
1123         require(
1124             newAmount >= (totalSupply() * 1) / 100000,
1125             "Swap amount cannot be lower than 0.001% total supply."
1126         );
1127         require(
1128             newAmount <= (totalSupply() * 5) / 1000,
1129             "Swap amount cannot be higher than 0.5% total supply."
1130         );
1131         swapTokensAtAmount = newAmount;
1132         return true;
1133     }
1134 
1135     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
1136         require(
1137             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
1138             "Cannot set maxTransactionAmount lower than 0.5%"
1139         );
1140         maxTransactionAmount = newNum * (10**18);
1141     }
1142 
1143     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
1144         require(
1145             newNum >= ((totalSupply() * 10) / 1000) / 1e18,
1146             "Cannot set maxWallet lower than 1.0%"
1147         );
1148         maxWallet = newNum * (10**18);
1149     }
1150 
1151     function excludeFromMaxTransaction(address updAds, bool isEx)
1152         public
1153         onlyOwner
1154     {
1155         _isExcludedMaxTransactionAmount[updAds] = isEx;
1156     }
1157 
1158     // only use to disable contract sales if absolutely necessary (emergency use only)
1159     function updateSwapEnabled(bool enabled) external onlyOwner {
1160         swapEnabled = enabled;
1161     }
1162 
1163     function updateBuyFees(
1164         uint256 _revShareFee,
1165         uint256 _liquidityFee,
1166         uint256 _teamFee
1167     ) external onlyOwner {
1168         buyRevShareFee = _revShareFee;
1169         buyLiquidityFee = _liquidityFee;
1170         buyTeamFee = _teamFee;
1171         buyTotalFees = buyRevShareFee + buyLiquidityFee + buyTeamFee;
1172         require(buyTotalFees <= 20, "Buy fees must be <= 20.");
1173     }
1174 
1175     function updateSellFees(
1176         uint256 _revShareFee,
1177         uint256 _liquidityFee,
1178         uint256 _teamFee
1179     ) external onlyOwner {
1180         sellRevShareFee = _revShareFee;
1181         sellLiquidityFee = _liquidityFee;
1182         sellTeamFee = _teamFee;
1183         sellTotalFees = sellRevShareFee + sellLiquidityFee + sellTeamFee;
1184         require(sellTotalFees <= 20, "Sell fees must be <= 20.");
1185     }
1186 
1187     function excludeFromFees(address account, bool excluded) public onlyOwner {
1188         _isExcludedFromFees[account] = excluded;
1189         emit ExcludeFromFees(account, excluded);
1190     }
1191 
1192     function setAutomatedMarketMakerPair(address pair, bool value)
1193         public
1194         onlyOwner
1195     {
1196         require(
1197             pair != uniswapV2Pair,
1198             "The pair cannot be removed from automatedMarketMakerPairs"
1199         );
1200 
1201         _setAutomatedMarketMakerPair(pair, value);
1202     }
1203 
1204     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1205         automatedMarketMakerPairs[pair] = value;
1206 
1207         emit SetAutomatedMarketMakerPair(pair, value);
1208     }
1209 
1210     function updateRevShareWallet(address newRevShareWallet) external onlyOwner {
1211         emit revShareWalletUpdated(newRevShareWallet, revShareWallet);
1212         revShareWallet = newRevShareWallet;
1213     }
1214 
1215     function updateTeamWallet(address newWallet) external onlyOwner {
1216         emit teamWalletUpdated(newWallet, teamWallet);
1217         teamWallet = newWallet;
1218     }
1219 
1220     function isExcludedFromFees(address account) public view returns (bool) {
1221         return _isExcludedFromFees[account];
1222     }
1223 
1224     function isBlacklisted(address account) public view returns (bool) {
1225         return blacklisted[account];
1226     }
1227 
1228     function _transfer(
1229         address from,
1230         address to,
1231         uint256 amount
1232     ) internal override {
1233         require(from != address(0), "ERC20: transfer from the zero address");
1234         require(to != address(0), "ERC20: transfer to the zero address");
1235         require(!blacklisted[from],"Sender blacklisted");
1236         require(!blacklisted[to],"Receiver blacklisted");
1237 
1238         if (preMigrationPhase) {
1239             require(preMigrationTransferrable[from], "Not authorized to transfer pre-migration.");
1240         }
1241 
1242         if (amount == 0) {
1243             super._transfer(from, to, 0);
1244             return;
1245         }
1246 
1247         if (limitsInEffect) {
1248             if (
1249                 from != owner() &&
1250                 to != owner() &&
1251                 to != address(0) &&
1252                 to != address(0xdead) &&
1253                 !swapping
1254             ) {
1255                 if (!tradingActive) {
1256                     require(
1257                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
1258                         "Trading is not active."
1259                     );
1260                 }
1261 
1262                 //when buy
1263                 if (
1264                     automatedMarketMakerPairs[from] &&
1265                     !_isExcludedMaxTransactionAmount[to]
1266                 ) {
1267                     require(
1268                         amount <= maxTransactionAmount,
1269                         "Buy transfer amount exceeds the maxTransactionAmount."
1270                     );
1271                     require(
1272                         amount + balanceOf(to) <= maxWallet,
1273                         "Max wallet exceeded"
1274                     );
1275                 }
1276                 //when sell
1277                 else if (
1278                     automatedMarketMakerPairs[to] &&
1279                     !_isExcludedMaxTransactionAmount[from]
1280                 ) {
1281                     require(
1282                         amount <= maxTransactionAmount,
1283                         "Sell transfer amount exceeds the maxTransactionAmount."
1284                     );
1285                 } else if (!_isExcludedMaxTransactionAmount[to]) {
1286                     require(
1287                         amount + balanceOf(to) <= maxWallet,
1288                         "Max wallet exceeded"
1289                     );
1290                 }
1291             }
1292         }
1293 
1294         uint256 contractTokenBalance = balanceOf(address(this));
1295 
1296         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1297 
1298         if (
1299             canSwap &&
1300             swapEnabled &&
1301             !swapping &&
1302             !automatedMarketMakerPairs[from] &&
1303             !_isExcludedFromFees[from] &&
1304             !_isExcludedFromFees[to]
1305         ) {
1306             swapping = true;
1307 
1308             swapBack();
1309 
1310             swapping = false;
1311         }
1312 
1313         bool takeFee = !swapping;
1314 
1315         // if any account belongs to _isExcludedFromFee account then remove the fee
1316         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1317             takeFee = false;
1318         }
1319 
1320         uint256 fees = 0;
1321         // only take fees on buys/sells, do not take on wallet transfers
1322         if (takeFee) {
1323             // on sell
1324             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
1325                 fees = amount.mul(sellTotalFees).div(100);
1326                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
1327                 tokensForTeam += (fees * sellTeamFee) / sellTotalFees;
1328                 tokensForRevShare += (fees * sellRevShareFee) / sellTotalFees;
1329             }
1330             // on buy
1331             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1332                 fees = amount.mul(buyTotalFees).div(100);
1333                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
1334                 tokensForTeam += (fees * buyTeamFee) / buyTotalFees;
1335                 tokensForRevShare += (fees * buyRevShareFee) / buyTotalFees;
1336             }
1337 
1338             if (fees > 0) {
1339                 super._transfer(from, address(this), fees);
1340             }
1341 
1342             amount -= fees;
1343         }
1344 
1345         super._transfer(from, to, amount);
1346     }
1347 
1348     function swapTokensForEth(uint256 tokenAmount) private {
1349         // generate the uniswap pair path of token -> weth
1350         address[] memory path = new address[](2);
1351         path[0] = address(this);
1352         path[1] = uniswapV2Router.WETH();
1353 
1354         _approve(address(this), address(uniswapV2Router), tokenAmount);
1355 
1356         // make the swap
1357         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1358             tokenAmount,
1359             0, // accept any amount of ETH
1360             path,
1361             address(this),
1362             block.timestamp
1363         );
1364     }
1365 
1366     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1367         // approve token transfer to cover all possible scenarios
1368         _approve(address(this), address(uniswapV2Router), tokenAmount);
1369 
1370         // add the liquidity
1371         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1372             address(this),
1373             tokenAmount,
1374             0, // slippage is unavoidable
1375             0, // slippage is unavoidable
1376             owner(),
1377             block.timestamp
1378         );
1379     }
1380 
1381     function swapBack() private {
1382         uint256 contractBalance = balanceOf(address(this));
1383         uint256 totalTokensToSwap = tokensForLiquidity +
1384             tokensForRevShare +
1385             tokensForTeam;
1386         bool success;
1387 
1388         if (contractBalance == 0 || totalTokensToSwap == 0) {
1389             return;
1390         }
1391 
1392         if (contractBalance > swapTokensAtAmount * 20) {
1393             contractBalance = swapTokensAtAmount * 20;
1394         }
1395 
1396         // Halve the amount of liquidity tokens
1397         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) /
1398             totalTokensToSwap /
1399             2;
1400         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1401 
1402         uint256 initialETHBalance = address(this).balance;
1403 
1404         swapTokensForEth(amountToSwapForETH);
1405 
1406         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1407 
1408         uint256 ethForRevShare = ethBalance.mul(tokensForRevShare).div(totalTokensToSwap - (tokensForLiquidity / 2));
1409         
1410         uint256 ethForTeam = ethBalance.mul(tokensForTeam).div(totalTokensToSwap - (tokensForLiquidity / 2));
1411 
1412         uint256 ethForLiquidity = ethBalance - ethForRevShare - ethForTeam;
1413 
1414         tokensForLiquidity = 0;
1415         tokensForRevShare = 0;
1416         tokensForTeam = 0;
1417 
1418         (success, ) = address(teamWallet).call{value: ethForTeam}("");
1419 
1420         if (liquidityTokens > 0 && ethForLiquidity > 0) {
1421             addLiquidity(liquidityTokens, ethForLiquidity);
1422             emit SwapAndLiquify(
1423                 amountToSwapForETH,
1424                 ethForLiquidity,
1425                 tokensForLiquidity
1426             );
1427         }
1428 
1429         (success, ) = address(revShareWallet).call{value: address(this).balance}("");
1430     }
1431 
1432     function withdrawStuckPerpbot() external onlyOwner {
1433         uint256 balance = IERC20(address(this)).balanceOf(address(this));
1434         IERC20(address(this)).transfer(msg.sender, balance);
1435         payable(msg.sender).transfer(address(this).balance);
1436     }
1437 
1438     function withdrawStuckToken(address _token, address _to) external onlyOwner {
1439         require(_token != address(0), "_token address cannot be 0");
1440         uint256 _contractBalance = IERC20(_token).balanceOf(address(this));
1441         IERC20(_token).transfer(_to, _contractBalance);
1442     }
1443 
1444     function withdrawStuckEth(address toAddr) external onlyOwner {
1445         (bool success, ) = toAddr.call{
1446             value: address(this).balance
1447         } ("");
1448         require(success);
1449     }
1450 
1451     // @dev team renounce blacklist commands
1452     function renounceBlacklist() public onlyOwner {
1453         blacklistRenounced = true;
1454     }
1455 
1456     function blacklist(address _addr) public onlyOwner {
1457         require(!blacklistRenounced, "Team has revoked blacklist rights");
1458         require(
1459             _addr != address(uniswapV2Pair) && _addr != address(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D), 
1460             "Cannot blacklist token's v2 router or v2 pool."
1461         );
1462         blacklisted[_addr] = true;
1463     }
1464 
1465     // @dev blacklist v3 pools; can unblacklist() down the road to suit project and community
1466     function blacklistLiquidityPool(address lpAddress) public onlyOwner {
1467         require(!blacklistRenounced, "Team has revoked blacklist rights");
1468         require(
1469             lpAddress != address(uniswapV2Pair) && lpAddress != address(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D), 
1470             "Cannot blacklist token's v2 router or v2 pool."
1471         );
1472         blacklisted[lpAddress] = true;
1473     }
1474 
1475     // @dev unblacklist address; not affected by blacklistRenounced incase team wants to unblacklist v3 pools down the road
1476     function unblacklist(address _addr) public onlyOwner {
1477         blacklisted[_addr] = false;
1478     }
1479 
1480     function setPreMigrationTransferable(address _addr, bool isAuthorized) public onlyOwner {
1481         preMigrationTransferrable[_addr] = isAuthorized;
1482         excludeFromFees(_addr, isAuthorized);
1483         excludeFromMaxTransaction(_addr, isAuthorized);
1484     }
1485 }