1 pragma solidity ^0.6.0;// SPDX-License-Identifier: MIT
2 
3 
4 
5 /*
6  * @dev Provides information about the current execution context, including the
7  * sender of the transaction and its data. While these are generally available
8  * via msg.sender and msg.data, they should not be accessed in such a direct
9  * manner, since when dealing with GSN meta-transactions the account sending and
10  * paying for execution may not be the actual sender (as far as an application
11  * is concerned).
12  *
13  * This contract is only required for intermediate, library-like contracts.
14  */
15 abstract contract Context {
16     function _msgSender() internal view virtual returns (address payable) {
17         return msg.sender;
18     }
19 
20     function _msgData() internal view virtual returns (bytes memory) {
21         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
22         return msg.data;
23     }
24 }
25 
26 
27 
28 /**
29  * @dev Interface of the ERC20 standard as defined in the EIP.
30  */
31 interface IERC20 {
32     /**
33      * @dev Returns the amount of tokens in existence.
34      */
35     function totalSupply() external view returns (uint256);
36 
37     /**
38      * @dev Returns the amount of tokens owned by `account`.
39      */
40     function balanceOf(address account) external view returns (uint256);
41 
42     /**
43      * @dev Moves `amount` tokens from the caller's account to `recipient`.
44      *
45      * Returns a boolean value indicating whether the operation succeeded.
46      *
47      * Emits a {Transfer} event.
48      */
49     function transfer(address recipient, uint256 amount) external returns (bool);
50 
51     /**
52      * @dev Returns the remaining number of tokens that `spender` will be
53      * allowed to spend on behalf of `owner` through {transferFrom}. This is
54      * zero by default.
55      *
56      * This value changes when {approve} or {transferFrom} are called.
57      */
58     function allowance(address owner, address spender) external view returns (uint256);
59 
60     /**
61      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
62      *
63      * Returns a boolean value indicating whether the operation succeeded.
64      *
65      * IMPORTANT: Beware that changing an allowance with this method brings the risk
66      * that someone may use both the old and the new allowance by unfortunate
67      * transaction ordering. One possible solution to mitigate this race
68      * condition is to first reduce the spender's allowance to 0 and set the
69      * desired value afterwards:
70      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
71      *
72      * Emits an {Approval} event.
73      */
74     function approve(address spender, uint256 amount) external returns (bool);
75 
76     /**
77      * @dev Moves `amount` tokens from `sender` to `recipient` using the
78      * allowance mechanism. `amount` is then deducted from the caller's
79      * allowance.
80      *
81      * Returns a boolean value indicating whether the operation succeeded.
82      *
83      * Emits a {Transfer} event.
84      */
85     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
86 
87     /**
88      * @dev Emitted when `value` tokens are moved from one account (`from`) to
89      * another (`to`).
90      *
91      * Note that `value` may be zero.
92      */
93     event Transfer(address indexed from, address indexed to, uint256 value);
94 
95     /**
96      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
97      * a call to {approve}. `value` is the new allowance.
98      */
99     event Approval(address indexed owner, address indexed spender, uint256 value);
100 }
101 
102 
103 
104 /**
105  * @dev Wrappers over Solidity's arithmetic operations with added overflow
106  * checks.
107  *
108  * Arithmetic operations in Solidity wrap on overflow. This can easily result
109  * in bugs, because programmers usually assume that an overflow raises an
110  * error, which is the standard behavior in high level programming languages.
111  * `SafeMath` restores this intuition by reverting the transaction when an
112  * operation overflows.
113  *
114  * Using this library instead of the unchecked operations eliminates an entire
115  * class of bugs, so it's recommended to use it always.
116  */
117 library SafeMath {
118     /**
119      * @dev Returns the addition of two unsigned integers, with an overflow flag.
120      *
121      * _Available since v3.4._
122      */
123     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
124         uint256 c = a + b;
125         if (c < a) return (false, 0);
126         return (true, c);
127     }
128 
129     /**
130      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
131      *
132      * _Available since v3.4._
133      */
134     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
135         if (b > a) return (false, 0);
136         return (true, a - b);
137     }
138 
139     /**
140      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
141      *
142      * _Available since v3.4._
143      */
144     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
145         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
146         // benefit is lost if 'b' is also tested.
147         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
148         if (a == 0) return (true, 0);
149         uint256 c = a * b;
150         if (c / a != b) return (false, 0);
151         return (true, c);
152     }
153 
154     /**
155      * @dev Returns the division of two unsigned integers, with a division by zero flag.
156      *
157      * _Available since v3.4._
158      */
159     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
160         if (b == 0) return (false, 0);
161         return (true, a / b);
162     }
163 
164     /**
165      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
166      *
167      * _Available since v3.4._
168      */
169     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
170         if (b == 0) return (false, 0);
171         return (true, a % b);
172     }
173 
174     /**
175      * @dev Returns the addition of two unsigned integers, reverting on
176      * overflow.
177      *
178      * Counterpart to Solidity's `+` operator.
179      *
180      * Requirements:
181      *
182      * - Addition cannot overflow.
183      */
184     function add(uint256 a, uint256 b) internal pure returns (uint256) {
185         uint256 c = a + b;
186         require(c >= a, "SafeMath: addition overflow");
187         return c;
188     }
189 
190     /**
191      * @dev Returns the subtraction of two unsigned integers, reverting on
192      * overflow (when the result is negative).
193      *
194      * Counterpart to Solidity's `-` operator.
195      *
196      * Requirements:
197      *
198      * - Subtraction cannot overflow.
199      */
200     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
201         require(b <= a, "SafeMath: subtraction overflow");
202         return a - b;
203     }
204 
205     /**
206      * @dev Returns the multiplication of two unsigned integers, reverting on
207      * overflow.
208      *
209      * Counterpart to Solidity's `*` operator.
210      *
211      * Requirements:
212      *
213      * - Multiplication cannot overflow.
214      */
215     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
216         if (a == 0) return 0;
217         uint256 c = a * b;
218         require(c / a == b, "SafeMath: multiplication overflow");
219         return c;
220     }
221 
222     /**
223      * @dev Returns the integer division of two unsigned integers, reverting on
224      * division by zero. The result is rounded towards zero.
225      *
226      * Counterpart to Solidity's `/` operator. Note: this function uses a
227      * `revert` opcode (which leaves remaining gas untouched) while Solidity
228      * uses an invalid opcode to revert (consuming all remaining gas).
229      *
230      * Requirements:
231      *
232      * - The divisor cannot be zero.
233      */
234     function div(uint256 a, uint256 b) internal pure returns (uint256) {
235         require(b > 0, "SafeMath: division by zero");
236         return a / b;
237     }
238 
239     /**
240      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
241      * reverting when dividing by zero.
242      *
243      * Counterpart to Solidity's `%` operator. This function uses a `revert`
244      * opcode (which leaves remaining gas untouched) while Solidity uses an
245      * invalid opcode to revert (consuming all remaining gas).
246      *
247      * Requirements:
248      *
249      * - The divisor cannot be zero.
250      */
251     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
252         require(b > 0, "SafeMath: modulo by zero");
253         return a % b;
254     }
255 
256     /**
257      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
258      * overflow (when the result is negative).
259      *
260      * CAUTION: This function is deprecated because it requires allocating memory for the error
261      * message unnecessarily. For custom revert reasons use {trySub}.
262      *
263      * Counterpart to Solidity's `-` operator.
264      *
265      * Requirements:
266      *
267      * - Subtraction cannot overflow.
268      */
269     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
270         require(b <= a, errorMessage);
271         return a - b;
272     }
273 
274     /**
275      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
276      * division by zero. The result is rounded towards zero.
277      *
278      * CAUTION: This function is deprecated because it requires allocating memory for the error
279      * message unnecessarily. For custom revert reasons use {tryDiv}.
280      *
281      * Counterpart to Solidity's `/` operator. Note: this function uses a
282      * `revert` opcode (which leaves remaining gas untouched) while Solidity
283      * uses an invalid opcode to revert (consuming all remaining gas).
284      *
285      * Requirements:
286      *
287      * - The divisor cannot be zero.
288      */
289     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
290         require(b > 0, errorMessage);
291         return a / b;
292     }
293 
294     /**
295      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
296      * reverting with custom message when dividing by zero.
297      *
298      * CAUTION: This function is deprecated because it requires allocating memory for the error
299      * message unnecessarily. For custom revert reasons use {tryMod}.
300      *
301      * Counterpart to Solidity's `%` operator. This function uses a `revert`
302      * opcode (which leaves remaining gas untouched) while Solidity uses an
303      * invalid opcode to revert (consuming all remaining gas).
304      *
305      * Requirements:
306      *
307      * - The divisor cannot be zero.
308      */
309     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
310         require(b > 0, errorMessage);
311         return a % b;
312     }
313 }
314 
315 
316 
317 
318 
319 
320 
321 /**
322  * @dev Implementation of the {IERC20} interface.
323  *
324  * This implementation is agnostic to the way tokens are created. This means
325  * that a supply mechanism has to be added in a derived contract using {_mint}.
326  * For a generic mechanism see {ERC20PresetMinterPauser}.
327  *
328  * TIP: For a detailed writeup see our guide
329  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
330  * to implement supply mechanisms].
331  *
332  * We have followed general OpenZeppelin guidelines: functions revert instead
333  * of returning `false` on failure. This behavior is nonetheless conventional
334  * and does not conflict with the expectations of ERC20 applications.
335  *
336  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
337  * This allows applications to reconstruct the allowance for all accounts just
338  * by listening to said events. Other implementations of the EIP may not emit
339  * these events, as it isn't required by the specification.
340  *
341  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
342  * functions have been added to mitigate the well-known issues around setting
343  * allowances. See {IERC20-approve}.
344  */
345 contract ERC20 is Context, IERC20 {
346     using SafeMath for uint256;
347 
348     mapping (address => uint256) private _balances;
349 
350     mapping (address => mapping (address => uint256)) private _allowances;
351 
352     uint256 private _totalSupply;
353 
354     string private _name;
355     string private _symbol;
356     uint8 private _decimals;
357 
358     /**
359      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
360      * a default value of 18.
361      *
362      * To select a different value for {decimals}, use {_setupDecimals}.
363      *
364      * All three of these values are immutable: they can only be set once during
365      * construction.
366      */
367     constructor (string memory name_, string memory symbol_) public {
368         _name = name_;
369         _symbol = symbol_;
370         _decimals = 18;
371     }
372 
373     /**
374      * @dev Returns the name of the token.
375      */
376     function name() public view virtual returns (string memory) {
377         return _name;
378     }
379 
380     /**
381      * @dev Returns the symbol of the token, usually a shorter version of the
382      * name.
383      */
384     function symbol() public view virtual returns (string memory) {
385         return _symbol;
386     }
387 
388     /**
389      * @dev Returns the number of decimals used to get its user representation.
390      * For example, if `decimals` equals `2`, a balance of `505` tokens should
391      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
392      *
393      * Tokens usually opt for a value of 18, imitating the relationship between
394      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
395      * called.
396      *
397      * NOTE: This information is only used for _display_ purposes: it in
398      * no way affects any of the arithmetic of the contract, including
399      * {IERC20-balanceOf} and {IERC20-transfer}.
400      */
401     function decimals() public view virtual returns (uint8) {
402         return _decimals;
403     }
404 
405     /**
406      * @dev See {IERC20-totalSupply}.
407      */
408     function totalSupply() public view virtual override returns (uint256) {
409         return _totalSupply;
410     }
411 
412     /**
413      * @dev See {IERC20-balanceOf}.
414      */
415     function balanceOf(address account) public view virtual override returns (uint256) {
416         return _balances[account];
417     }
418 
419     /**
420      * @dev See {IERC20-transfer}.
421      *
422      * Requirements:
423      *
424      * - `recipient` cannot be the zero address.
425      * - the caller must have a balance of at least `amount`.
426      */
427     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
428         _transfer(_msgSender(), recipient, amount);
429         return true;
430     }
431 
432     /**
433      * @dev See {IERC20-allowance}.
434      */
435     function allowance(address owner, address spender) public view virtual override returns (uint256) {
436         return _allowances[owner][spender];
437     }
438 
439     /**
440      * @dev See {IERC20-approve}.
441      *
442      * Requirements:
443      *
444      * - `spender` cannot be the zero address.
445      */
446     function approve(address spender, uint256 amount) public virtual override returns (bool) {
447         _approve(_msgSender(), spender, amount);
448         return true;
449     }
450 
451     /**
452      * @dev See {IERC20-transferFrom}.
453      *
454      * Emits an {Approval} event indicating the updated allowance. This is not
455      * required by the EIP. See the note at the beginning of {ERC20}.
456      *
457      * Requirements:
458      *
459      * - `sender` and `recipient` cannot be the zero address.
460      * - `sender` must have a balance of at least `amount`.
461      * - the caller must have allowance for ``sender``'s tokens of at least
462      * `amount`.
463      */
464     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
465         _transfer(sender, recipient, amount);
466         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
467         return true;
468     }
469 
470     /**
471      * @dev Atomically increases the allowance granted to `spender` by the caller.
472      *
473      * This is an alternative to {approve} that can be used as a mitigation for
474      * problems described in {IERC20-approve}.
475      *
476      * Emits an {Approval} event indicating the updated allowance.
477      *
478      * Requirements:
479      *
480      * - `spender` cannot be the zero address.
481      */
482     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
483         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
484         return true;
485     }
486 
487     /**
488      * @dev Atomically decreases the allowance granted to `spender` by the caller.
489      *
490      * This is an alternative to {approve} that can be used as a mitigation for
491      * problems described in {IERC20-approve}.
492      *
493      * Emits an {Approval} event indicating the updated allowance.
494      *
495      * Requirements:
496      *
497      * - `spender` cannot be the zero address.
498      * - `spender` must have allowance for the caller of at least
499      * `subtractedValue`.
500      */
501     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
502         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
503         return true;
504     }
505 
506     /**
507      * @dev Moves tokens `amount` from `sender` to `recipient`.
508      *
509      * This is internal function is equivalent to {transfer}, and can be used to
510      * e.g. implement automatic token fees, slashing mechanisms, etc.
511      *
512      * Emits a {Transfer} event.
513      *
514      * Requirements:
515      *
516      * - `sender` cannot be the zero address.
517      * - `recipient` cannot be the zero address.
518      * - `sender` must have a balance of at least `amount`.
519      */
520     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
521         require(sender != address(0), "ERC20: transfer from the zero address");
522         require(recipient != address(0), "ERC20: transfer to the zero address");
523 
524         _beforeTokenTransfer(sender, recipient, amount);
525 
526         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
527         _balances[recipient] = _balances[recipient].add(amount);
528         emit Transfer(sender, recipient, amount);
529     }
530 
531     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
532      * the total supply.
533      *
534      * Emits a {Transfer} event with `from` set to the zero address.
535      *
536      * Requirements:
537      *
538      * - `to` cannot be the zero address.
539      */
540     function _mint(address account, uint256 amount) internal virtual {
541         require(account != address(0), "ERC20: mint to the zero address");
542 
543         _beforeTokenTransfer(address(0), account, amount);
544 
545         _totalSupply = _totalSupply.add(amount);
546         _balances[account] = _balances[account].add(amount);
547         emit Transfer(address(0), account, amount);
548     }
549 
550     /**
551      * @dev Destroys `amount` tokens from `account`, reducing the
552      * total supply.
553      *
554      * Emits a {Transfer} event with `to` set to the zero address.
555      *
556      * Requirements:
557      *
558      * - `account` cannot be the zero address.
559      * - `account` must have at least `amount` tokens.
560      */
561     function _burn(address account, uint256 amount) internal virtual {
562         require(account != address(0), "ERC20: burn from the zero address");
563 
564         _beforeTokenTransfer(account, address(0), amount);
565 
566         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
567         _totalSupply = _totalSupply.sub(amount);
568         emit Transfer(account, address(0), amount);
569     }
570 
571     /**
572      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
573      *
574      * This internal function is equivalent to `approve`, and can be used to
575      * e.g. set automatic allowances for certain subsystems, etc.
576      *
577      * Emits an {Approval} event.
578      *
579      * Requirements:
580      *
581      * - `owner` cannot be the zero address.
582      * - `spender` cannot be the zero address.
583      */
584     function _approve(address owner, address spender, uint256 amount) internal virtual {
585         require(owner != address(0), "ERC20: approve from the zero address");
586         require(spender != address(0), "ERC20: approve to the zero address");
587 
588         _allowances[owner][spender] = amount;
589         emit Approval(owner, spender, amount);
590     }
591 
592     /**
593      * @dev Sets {decimals} to a value other than the default one of 18.
594      *
595      * WARNING: This function should only be called from the constructor. Most
596      * applications that interact with token contracts will not expect
597      * {decimals} to ever change, and may work incorrectly if it does.
598      */
599     function _setupDecimals(uint8 decimals_) internal virtual {
600         _decimals = decimals_;
601     }
602 
603     /**
604      * @dev Hook that is called before any transfer of tokens. This includes
605      * minting and burning.
606      *
607      * Calling conditions:
608      *
609      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
610      * will be to transferred to `to`.
611      * - when `from` is zero, `amount` tokens will be minted for `to`.
612      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
613      * - `from` and `to` are never both zero.
614      *
615      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
616      */
617     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
618 }
619 
620 
621 
622 
623 
624 
625 contract ERC20Helper  {
626     event TransferOut(uint256 Amount, address To, address Token);
627     event TransferIn(uint256 Amount, address From, address Token);
628     modifier TestAllownce(
629         address _token,
630         address _owner,
631         uint256 _amount
632     ) {
633         require(
634             ERC20(_token).allowance(_owner, address(this)) >= _amount,
635             "no allowance"
636         );
637         _;
638     }
639 
640     function TransferToken(
641         address _Token,
642         address _Reciver,
643         uint256 _Amount
644     ) internal {
645         uint256 OldBalance = CheckBalance(_Token, address(this));
646         emit TransferOut(_Amount, _Reciver, _Token);
647         ERC20(_Token).transfer(_Reciver, _Amount);
648         require(
649             (SafeMath.add(CheckBalance(_Token, address(this)), _Amount)) == OldBalance
650                 ,
651             "recive wrong amount of tokens"
652         );
653     }
654 
655     function CheckBalance(address _Token, address _Subject)
656         internal
657         view
658         returns (uint256)
659     {
660         return ERC20(_Token).balanceOf(_Subject);
661     }
662 
663     function TransferInToken(
664         address _Token,
665         address _Subject,
666         uint256 _Amount
667     ) internal TestAllownce(_Token, _Subject, _Amount) {
668         require(_Amount > 0);
669         uint256 OldBalance = CheckBalance(_Token, address(this));
670         ERC20(_Token).transferFrom(_Subject, address(this), _Amount);
671         emit TransferIn(_Amount, _Subject, _Token);
672         require(
673             (SafeMath.add(OldBalance, _Amount)) ==
674                 CheckBalance(_Token, address(this)),
675             "recive wrong amount of tokens"
676         );
677     }
678 
679     function ApproveAllowanceERC20(
680         address _Token,
681         address _Subject,
682         uint256 _Amount
683     ) internal {
684         require(_Amount > 0);
685         ERC20(_Token).approve(_Subject, _Amount);
686     }
687 }
688 
689 
690 
691 
692 /**
693  * @dev Contract module which provides a basic access control mechanism, where
694  * there is an account (an owner) that can be granted exclusive access to
695  * specific functions.
696  *
697  * By default, the owner account will be the one that deploys the contract. This
698  * can later be changed with {transferOwnership}.
699  *
700  * This module is used through inheritance. It will make available the modifier
701  * `onlyOwner`, which can be applied to your functions to restrict their use to
702  * the owner.
703  */
704 abstract contract Ownable is Context {
705     address private _owner;
706 
707     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
708 
709     /**
710      * @dev Initializes the contract setting the deployer as the initial owner.
711      */
712     constructor () internal {
713         address msgSender = _msgSender();
714         _owner = msgSender;
715         emit OwnershipTransferred(address(0), msgSender);
716     }
717 
718     /**
719      * @dev Returns the address of the current owner.
720      */
721     function owner() public view virtual returns (address) {
722         return _owner;
723     }
724 
725     /**
726      * @dev Throws if called by any account other than the owner.
727      */
728     modifier onlyOwner() {
729         require(owner() == _msgSender(), "Ownable: caller is not the owner");
730         _;
731     }
732 
733     /**
734      * @dev Leaves the contract without owner. It will not be possible to call
735      * `onlyOwner` functions anymore. Can only be called by the current owner.
736      *
737      * NOTE: Renouncing ownership will leave the contract without an owner,
738      * thereby removing any functionality that is only available to the owner.
739      */
740     function renounceOwnership() public virtual onlyOwner {
741         emit OwnershipTransferred(_owner, address(0));
742         _owner = address(0);
743     }
744 
745     /**
746      * @dev Transfers ownership of the contract to a new account (`newOwner`).
747      * Can only be called by the current owner.
748      */
749     function transferOwnership(address newOwner) public virtual onlyOwner {
750         require(newOwner != address(0), "Ownable: new owner is the zero address");
751         emit OwnershipTransferred(_owner, newOwner);
752         _owner = newOwner;
753     }
754 }
755 
756 
757 
758 
759 
760 contract GovManager is Ownable {
761     address public GovernerContract;
762 
763     modifier onlyOwnerOrGov() {
764         require(msg.sender == owner() || msg.sender == GovernerContract, "Authorization Error");
765         _;
766     }
767 
768     function setGovernerContract(address _address) external onlyOwnerOrGov{
769         GovernerContract = _address;
770     }
771 
772     constructor() public {
773         GovernerContract = address(0);
774     }
775 }
776 
777 
778 
779 
780 
781 contract PozBenefit is GovManager {
782     constructor() public {
783         PozFee = 15; // *10000
784         PozTimer = 1000; // *10000
785     
786        // POZ_Address = address(0x0);
787        // POZBenefit_Address = address(0x0);
788     }
789 
790     uint256 public PozFee; // the fee for the first part of the pool
791     uint256 public PozTimer; //the timer for the first part fo the pool
792     
793     modifier PercentCheckOk(uint256 _percent) {
794         if (_percent < 10000) _;
795         else revert("Not in range");
796     }
797     modifier LeftIsBigger(uint256 _left, uint256 _right) {
798         if (_left > _right) _;
799         else revert("Not bigger");
800     }
801 
802     function SetPozTimer(uint256 _pozTimer)
803         public
804         onlyOwnerOrGov
805         PercentCheckOk(_pozTimer)
806     {
807         PozTimer = _pozTimer;
808     }
809 
810     
811 }
812 
813 
814 
815 
816 
817 contract ETHHelper is Ownable {
818     constructor() public {
819         IsPayble = false;
820     }
821 
822     modifier ReceivETH(uint256 msgValue, address msgSender, uint256 _MinETHInvest) {
823         require(msgValue >= _MinETHInvest, "Send ETH to invest");
824         emit TransferInETH(msgValue, msgSender);
825         _;
826     }
827 
828     //@dev not/allow contract to receive funds
829     receive() external payable {
830         if (!IsPayble) revert();
831     }
832 
833     event TransferOutETH(uint256 Amount, address To);
834     event TransferInETH(uint256 Amount, address From);
835 
836     bool public IsPayble;
837  
838     function SwitchIsPayble() public onlyOwner {
839         IsPayble = !IsPayble;
840     }
841 
842     function TransferETH(address payable _Reciver, uint256 _ammount) internal {
843         emit TransferOutETH(_ammount, _Reciver);
844         uint256 beforeBalance = address(_Reciver).balance;
845         _Reciver.transfer(_ammount);
846         require(
847             SafeMath.add(beforeBalance, _ammount) == address(_Reciver).balance,
848             "The transfer did not complite"
849         );
850     }
851  
852 }
853 
854 
855 
856 //For whitelist, 
857 interface IWhiteList {
858     function Check(address _Subject, uint256 _Id) external view returns(uint);
859     function Register(address _Subject,uint256 _Id,uint256 _Amount) external;
860     function IsNeedRegister(uint256 _Id) external view returns(bool);
861     function LastRoundRegister(address _Subject,uint256 _Id) external;
862 }
863 
864 
865 
866 
867 
868 
869 
870 contract Manageable is ETHHelper, ERC20Helper, PozBenefit {
871     constructor() public {
872         Fee = 20; // *10000
873         MinDuration = 0; //need to set
874         maxTransactionLimit = 400;
875     }
876     mapping (address => uint256) FeeMap;
877     //@dev for percent use uint16
878     uint16 internal Fee; //the fee for the pool
879     uint16 internal MinDuration; //the minimum duration of a pool, in seconds
880 
881     address public WhiteList_Address;
882     bool public isTokenFilterOn;
883     uint public WhiteListId;
884     uint256 public maxTransactionLimit;
885     
886     function setWhiteListAddress(address _address) external onlyOwner{
887         WhiteList_Address = _address;
888     }
889 
890     function setWhiteListId(uint256 _id) external onlyOwner{
891         WhiteListId= _id;
892     }
893 
894     function swapTokenFilter() external onlyOwner{
895         isTokenFilterOn = !isTokenFilterOn;
896     }
897 
898     function isTokenWhiteListed(address _tokenAddress) public view returns(bool) {
899         return !isTokenFilterOn || IWhiteList(WhiteList_Address).Check(_tokenAddress, WhiteListId) > 0;
900     }
901 
902     function setMaxTransactionLimit(uint256 _newLimit) external onlyOwner{
903         maxTransactionLimit = _newLimit;
904     }
905 
906     function GetMinDuration() public view returns (uint16) {
907         return MinDuration;
908     }
909 
910     function SetMinDuration(uint16 _minDuration) public onlyOwner {
911         MinDuration = _minDuration;
912     }
913 
914     function GetFee() public view returns (uint16) {
915         return Fee;
916     }
917 
918     function SetFee(uint16 _fee) public onlyOwner
919         PercentCheckOk(_fee)
920         LeftIsBigger( _fee, PozFee) {
921         Fee = _fee;
922     }
923 
924     function SetPOZFee(uint16 _fee)
925         public
926         onlyOwner
927         PercentCheckOk(_fee)
928         LeftIsBigger( Fee,_fee)
929     {
930         PozFee = _fee;
931     }
932 
933     function WithdrawETHFee(address payable _to) public onlyOwner {
934         _to.transfer(address(this).balance); // keeps only fee eth on contract //To Do need to take 16% to burn!!!
935     }
936 
937     function WithdrawERC20Fee(address _Token, address _to) public onlyOwner {    
938         ERC20(_Token).transfer(_to, FeeMap[_Token]);
939         FeeMap[_Token] = 0 ;
940     }
941 }
942 
943 
944 
945 
946 
947 contract LockedPoolz is Manageable {
948     constructor() public {
949         Index = 0;
950     }
951     
952     // add contract name
953     string public name;
954 
955     event NewPoolCreated(uint256 PoolId, address Token, uint64 FinishTime, uint256 StartAmount, address Owner);
956     event PoolOwnershipTransfered(uint256 PoolId, address NewOwner, address OldOwner);
957     event PoolApproval(uint256 PoolId, address Spender, uint256 Amount);
958 
959     struct Pool {
960         uint64 UnlockTime;
961         uint256 Amount;
962         address Owner;
963         address Token;
964         mapping(address => uint) Allowance;
965     }
966     // transfer ownership
967     // allowance
968     // split amount
969 
970     mapping(uint256 => Pool) AllPoolz;
971     mapping(address => uint256[]) MyPoolz;
972     uint256 internal Index;
973 
974     modifier isTokenValid(address _Token){
975         require(isTokenWhiteListed(_Token), "Need Valid ERC20 Token"); //check if _Token is ERC20
976         _;
977     }
978 
979     modifier isPoolValid(uint256 _PoolId){
980         require(_PoolId < Index, "Pool does not exist");
981         _;
982     }
983 
984     modifier isPoolOwner(uint256 _PoolId){
985         require(AllPoolz[_PoolId].Owner == msg.sender, "You are not Pool Owner");
986         _;
987     }
988 
989     modifier isAllowed(uint256 _PoolId, uint256 _amount){
990         require(_amount <= AllPoolz[_PoolId].Allowance[msg.sender], "Not enough Allowance");
991         _;
992     }
993 
994     modifier isLocked(uint256 _PoolId){
995         require(AllPoolz[_PoolId].UnlockTime > now, "Pool is Unlocked");
996         _;
997     }
998 
999     modifier notZeroAddress(address _address){
1000         require(_address != address(0x0), "Zero Address is not allowed");
1001         _;
1002     }
1003 
1004     modifier isGreaterThanZero(uint256 _num){
1005         require(_num > 0, "Array length should be greater than zero");
1006         _;
1007     }
1008 
1009     modifier isBelowLimit(uint256 _num){
1010         require(_num <= maxTransactionLimit, "Max array length limit exceeded");
1011         _;
1012     }
1013 
1014     function SplitPool(uint256 _PoolId, uint256 _NewAmount , address _NewOwner) internal returns(uint256) {
1015         Pool storage pool = AllPoolz[_PoolId];
1016         require(pool.Amount >= _NewAmount, "Not Enough Amount Balance");
1017         uint256 poolAmount = SafeMath.sub(pool.Amount, _NewAmount);
1018         pool.Amount = poolAmount;
1019         uint256 poolId = CreatePool(pool.Token, pool.UnlockTime, _NewAmount, _NewOwner);
1020         return poolId;
1021     }
1022 
1023     //create a new pool
1024     function CreatePool(
1025         address _Token, //token to lock address
1026         uint64 _FinishTime, //Until what time the pool will work
1027         uint256 _StartAmount, //Total amount of the tokens to sell in the pool
1028         address _Owner // Who the tokens belong to
1029     ) internal returns(uint256){
1030         //register the pool
1031         AllPoolz[Index] = Pool(_FinishTime, _StartAmount, _Owner, _Token);
1032         MyPoolz[_Owner].push(Index);
1033         emit NewPoolCreated(Index, _Token, _FinishTime, _StartAmount, _Owner);
1034         uint256 poolId = Index;
1035         Index = SafeMath.add(Index, 1); //joke - overflowfrom 0 on int256 = 1.16E77
1036         return poolId;
1037     }
1038 }
1039 
1040 
1041 
1042 
1043 contract LockedControl is LockedPoolz{
1044 
1045     function TransferPoolOwnership(
1046         uint256 _PoolId,
1047         address _NewOwner
1048     ) external isPoolValid(_PoolId) isPoolOwner(_PoolId) isLocked(_PoolId) notZeroAddress(_NewOwner) {
1049         Pool storage pool = AllPoolz[_PoolId];
1050         pool.Owner = _NewOwner;
1051         emit PoolOwnershipTransfered(_PoolId, _NewOwner, msg.sender);
1052     }
1053 
1054     function SplitPoolAmount(
1055         uint256 _PoolId,
1056         uint256 _NewAmount,
1057         address _NewOwner
1058     ) external isPoolValid(_PoolId) isPoolOwner(_PoolId) isLocked(_PoolId) returns(uint256) {
1059         uint256 poolId = SplitPool(_PoolId, _NewAmount, _NewOwner);
1060         return poolId;
1061     }
1062 
1063     function ApproveAllowance(
1064         uint256 _PoolId,
1065         uint256 _Amount,
1066         address _Spender
1067     ) external isPoolValid(_PoolId) isPoolOwner(_PoolId) isLocked(_PoolId) notZeroAddress(_Spender) {
1068         Pool storage pool = AllPoolz[_PoolId];
1069         pool.Allowance[_Spender] = _Amount;
1070         emit PoolApproval(_PoolId, _Spender, _Amount);
1071     }
1072 
1073     function GetPoolAllowance(uint256 _PoolId, address _Address) public view isPoolValid(_PoolId) returns(uint256){
1074         return AllPoolz[_PoolId].Allowance[_Address];
1075     }
1076 
1077     function SplitPoolAmountFrom(
1078         uint256 _PoolId,
1079         uint256 _Amount,
1080         address _Address
1081     ) external isPoolValid(_PoolId) isAllowed(_PoolId, _Amount) isLocked(_PoolId) returns(uint256) {
1082         uint256 poolId = SplitPool(_PoolId, _Amount, _Address);
1083         Pool storage pool = AllPoolz[_PoolId];
1084         uint256 _NewAmount = SafeMath.sub(pool.Allowance[msg.sender], _Amount);
1085         pool.Allowance[_Address]  = _NewAmount;
1086         return poolId;
1087     }
1088 
1089     function CreateNewPool(
1090         address _Token, //token to lock address
1091         uint64 _FinishTime, //Until what time the pool will work
1092         uint256 _StartAmount, //Total amount of the tokens to sell in the pool
1093         address _Owner // Who the tokens belong to
1094     ) public isTokenValid(_Token) notZeroAddress(_Owner) returns(uint256) {
1095         TransferInToken(_Token, msg.sender, _StartAmount);
1096         uint256 poolId = CreatePool(_Token, _FinishTime, _StartAmount, _Owner);
1097         return poolId;
1098     }
1099 
1100     function CreateMassPools(
1101         address _Token,
1102         uint64[] calldata _FinishTime,
1103         uint256[] calldata _StartAmount,
1104         address[] calldata _Owner
1105     ) external isGreaterThanZero(_Owner.length) isBelowLimit(_Owner.length) returns(uint256, uint256) {
1106         require(_Owner.length == _FinishTime.length, "Date Array Invalid");
1107         require(_Owner.length == _StartAmount.length, "Amount Array Invalid");
1108         TransferInToken(_Token, msg.sender, getArraySum(_StartAmount));
1109         uint256 firstPoolId = Index;
1110         for(uint i=0 ; i < _Owner.length; i++){
1111             CreatePool(_Token, _FinishTime[i], _StartAmount[i], _Owner[i]);
1112         }
1113         uint256 lastPoolId = SafeMath.sub(Index, 1);
1114         return (firstPoolId, lastPoolId);
1115     }
1116 
1117     // create pools with respect to finish time
1118     function CreatePoolsWrtTime(
1119         address _Token,
1120         uint64[] calldata _FinishTime,
1121         uint256[] calldata _StartAmount,
1122         address[] calldata _Owner
1123     )   external 
1124         isGreaterThanZero(_Owner.length)
1125         isGreaterThanZero(_FinishTime.length)
1126         isBelowLimit(_Owner.length * _FinishTime.length)
1127         returns(uint256, uint256)
1128     {
1129         require(_Owner.length == _StartAmount.length, "Amount Array Invalid");
1130         TransferInToken(_Token, msg.sender, getArraySum(_StartAmount) * _FinishTime.length);
1131         uint256 firstPoolId = Index;
1132         for(uint i=0 ; i < _FinishTime.length ; i++){
1133             for(uint j=0 ; j < _Owner.length ; j++){
1134                 CreatePool(_Token, _FinishTime[i], _StartAmount[j], _Owner[j]);
1135             }
1136         }
1137         uint256 lastPoolId = SafeMath.sub(Index, 1);
1138         return (firstPoolId, lastPoolId);
1139     }
1140 
1141     function getArraySum(uint256[] calldata _array) internal pure returns(uint256) {
1142         uint256 sum = 0;
1143         for(uint i=0 ; i<_array.length ; i++){
1144             sum = sum + _array[i];
1145         }
1146         return sum;
1147     }
1148 
1149 }
1150 
1151 
1152 
1153 
1154 contract LockedPoolzData is LockedControl {
1155     function GetMyPoolsId() public view returns (uint256[] memory) {
1156         return MyPoolz[msg.sender];
1157     }
1158 
1159     function GetPoolData(uint256 _id)
1160         public
1161         view
1162         isPoolValid(_id)
1163         returns (
1164             uint64,
1165             uint256,
1166             address,
1167             address
1168         )
1169     {
1170         Pool storage pool = AllPoolz[_id];
1171         require(pool.Owner == msg.sender || pool.Allowance[msg.sender] > 0, "Private Information");
1172         return (
1173             AllPoolz[_id].UnlockTime,
1174             AllPoolz[_id].Amount,
1175             AllPoolz[_id].Owner,
1176             AllPoolz[_id].Token
1177         );
1178     }
1179 }
1180 
1181 
1182 
1183 
1184 contract LockedDeal is LockedPoolzData {
1185     constructor() public {
1186         StartIndex = 0;
1187     }
1188 
1189     uint256 internal StartIndex;
1190 
1191     //@dev no use of revert to make sure the loop will work
1192     function WithdrawToken(uint256 _PoolId) public returns (bool) {
1193         //pool is finished + got left overs + did not took them
1194         if (
1195             _PoolId < Index &&
1196             AllPoolz[_PoolId].UnlockTime <= now &&
1197             AllPoolz[_PoolId].Amount > 0
1198         ) {
1199             TransferToken(
1200                 AllPoolz[_PoolId].Token,
1201                 AllPoolz[_PoolId].Owner,
1202                 AllPoolz[_PoolId].Amount
1203             );
1204             AllPoolz[_PoolId].Amount = 0;
1205             return true;
1206         }
1207         return false;
1208     }
1209 }