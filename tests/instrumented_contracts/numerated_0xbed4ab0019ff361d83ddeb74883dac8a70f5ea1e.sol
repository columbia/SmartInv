1 // Sources flattened with hardhat v2.0.9 https://hardhat.org
2 
3 // File @openzeppelin/contracts/utils/Context.sol@v3.4.0
4 
5 // SPDX-License-Identifier: MIT
6 
7 pragma solidity >=0.6.0 <0.8.0;
8 
9 /*
10  * @dev Provides information about the current execution context, including the
11  * sender of the transaction and its data. While these are generally available
12  * via msg.sender and msg.data, they should not be accessed in such a direct
13  * manner, since when dealing with GSN meta-transactions the account sending and
14  * paying for execution may not be the actual sender (as far as an application
15  * is concerned).
16  *
17  * This contract is only required for intermediate, library-like contracts.
18  */
19 abstract contract Context {
20     function _msgSender() internal view virtual returns (address payable) {
21         return msg.sender;
22     }
23 
24     function _msgData() internal view virtual returns (bytes memory) {
25         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
26         return msg.data;
27     }
28 }
29 
30 
31 // File @openzeppelin/contracts/token/ERC20/IERC20.sol@v3.4.0
32 
33 pragma solidity >=0.6.0 <0.8.0;
34 
35 /**
36  * @dev Interface of the ERC20 standard as defined in the EIP.
37  */
38 interface IERC20 {
39     /**
40      * @dev Returns the amount of tokens in existence.
41      */
42     function totalSupply() external view returns (uint256);
43 
44     /**
45      * @dev Returns the amount of tokens owned by `account`.
46      */
47     function balanceOf(address account) external view returns (uint256);
48 
49     /**
50      * @dev Moves `amount` tokens from the caller's account to `recipient`.
51      *
52      * Returns a boolean value indicating whether the operation succeeded.
53      *
54      * Emits a {Transfer} event.
55      */
56     function transfer(address recipient, uint256 amount) external returns (bool);
57 
58     /**
59      * @dev Returns the remaining number of tokens that `spender` will be
60      * allowed to spend on behalf of `owner` through {transferFrom}. This is
61      * zero by default.
62      *
63      * This value changes when {approve} or {transferFrom} are called.
64      */
65     function allowance(address owner, address spender) external view returns (uint256);
66 
67     /**
68      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
69      *
70      * Returns a boolean value indicating whether the operation succeeded.
71      *
72      * IMPORTANT: Beware that changing an allowance with this method brings the risk
73      * that someone may use both the old and the new allowance by unfortunate
74      * transaction ordering. One possible solution to mitigate this race
75      * condition is to first reduce the spender's allowance to 0 and set the
76      * desired value afterwards:
77      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
78      *
79      * Emits an {Approval} event.
80      */
81     function approve(address spender, uint256 amount) external returns (bool);
82 
83     /**
84      * @dev Moves `amount` tokens from `sender` to `recipient` using the
85      * allowance mechanism. `amount` is then deducted from the caller's
86      * allowance.
87      *
88      * Returns a boolean value indicating whether the operation succeeded.
89      *
90      * Emits a {Transfer} event.
91      */
92     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
93 
94     /**
95      * @dev Emitted when `value` tokens are moved from one account (`from`) to
96      * another (`to`).
97      *
98      * Note that `value` may be zero.
99      */
100     event Transfer(address indexed from, address indexed to, uint256 value);
101 
102     /**
103      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
104      * a call to {approve}. `value` is the new allowance.
105      */
106     event Approval(address indexed owner, address indexed spender, uint256 value);
107 }
108 
109 
110 // File @openzeppelin/contracts/math/SafeMath.sol@v3.4.0
111 
112 pragma solidity >=0.6.0 <0.8.0;
113 
114 /**
115  * @dev Wrappers over Solidity's arithmetic operations with added overflow
116  * checks.
117  *
118  * Arithmetic operations in Solidity wrap on overflow. This can easily result
119  * in bugs, because programmers usually assume that an overflow raises an
120  * error, which is the standard behavior in high level programming languages.
121  * `SafeMath` restores this intuition by reverting the transaction when an
122  * operation overflows.
123  *
124  * Using this library instead of the unchecked operations eliminates an entire
125  * class of bugs, so it's recommended to use it always.
126  */
127 library SafeMath {
128     /**
129      * @dev Returns the addition of two unsigned integers, with an overflow flag.
130      *
131      * _Available since v3.4._
132      */
133     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
134         uint256 c = a + b;
135         if (c < a) return (false, 0);
136         return (true, c);
137     }
138 
139     /**
140      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
141      *
142      * _Available since v3.4._
143      */
144     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
145         if (b > a) return (false, 0);
146         return (true, a - b);
147     }
148 
149     /**
150      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
151      *
152      * _Available since v3.4._
153      */
154     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
155         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
156         // benefit is lost if 'b' is also tested.
157         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
158         if (a == 0) return (true, 0);
159         uint256 c = a * b;
160         if (c / a != b) return (false, 0);
161         return (true, c);
162     }
163 
164     /**
165      * @dev Returns the division of two unsigned integers, with a division by zero flag.
166      *
167      * _Available since v3.4._
168      */
169     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
170         if (b == 0) return (false, 0);
171         return (true, a / b);
172     }
173 
174     /**
175      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
176      *
177      * _Available since v3.4._
178      */
179     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
180         if (b == 0) return (false, 0);
181         return (true, a % b);
182     }
183 
184     /**
185      * @dev Returns the addition of two unsigned integers, reverting on
186      * overflow.
187      *
188      * Counterpart to Solidity's `+` operator.
189      *
190      * Requirements:
191      *
192      * - Addition cannot overflow.
193      */
194     function add(uint256 a, uint256 b) internal pure returns (uint256) {
195         uint256 c = a + b;
196         require(c >= a, "SafeMath: addition overflow");
197         return c;
198     }
199 
200     /**
201      * @dev Returns the subtraction of two unsigned integers, reverting on
202      * overflow (when the result is negative).
203      *
204      * Counterpart to Solidity's `-` operator.
205      *
206      * Requirements:
207      *
208      * - Subtraction cannot overflow.
209      */
210     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
211         require(b <= a, "SafeMath: subtraction overflow");
212         return a - b;
213     }
214 
215     /**
216      * @dev Returns the multiplication of two unsigned integers, reverting on
217      * overflow.
218      *
219      * Counterpart to Solidity's `*` operator.
220      *
221      * Requirements:
222      *
223      * - Multiplication cannot overflow.
224      */
225     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
226         if (a == 0) return 0;
227         uint256 c = a * b;
228         require(c / a == b, "SafeMath: multiplication overflow");
229         return c;
230     }
231 
232     /**
233      * @dev Returns the integer division of two unsigned integers, reverting on
234      * division by zero. The result is rounded towards zero.
235      *
236      * Counterpart to Solidity's `/` operator. Note: this function uses a
237      * `revert` opcode (which leaves remaining gas untouched) while Solidity
238      * uses an invalid opcode to revert (consuming all remaining gas).
239      *
240      * Requirements:
241      *
242      * - The divisor cannot be zero.
243      */
244     function div(uint256 a, uint256 b) internal pure returns (uint256) {
245         require(b > 0, "SafeMath: division by zero");
246         return a / b;
247     }
248 
249     /**
250      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
251      * reverting when dividing by zero.
252      *
253      * Counterpart to Solidity's `%` operator. This function uses a `revert`
254      * opcode (which leaves remaining gas untouched) while Solidity uses an
255      * invalid opcode to revert (consuming all remaining gas).
256      *
257      * Requirements:
258      *
259      * - The divisor cannot be zero.
260      */
261     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
262         require(b > 0, "SafeMath: modulo by zero");
263         return a % b;
264     }
265 
266     /**
267      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
268      * overflow (when the result is negative).
269      *
270      * CAUTION: This function is deprecated because it requires allocating memory for the error
271      * message unnecessarily. For custom revert reasons use {trySub}.
272      *
273      * Counterpart to Solidity's `-` operator.
274      *
275      * Requirements:
276      *
277      * - Subtraction cannot overflow.
278      */
279     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
280         require(b <= a, errorMessage);
281         return a - b;
282     }
283 
284     /**
285      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
286      * division by zero. The result is rounded towards zero.
287      *
288      * CAUTION: This function is deprecated because it requires allocating memory for the error
289      * message unnecessarily. For custom revert reasons use {tryDiv}.
290      *
291      * Counterpart to Solidity's `/` operator. Note: this function uses a
292      * `revert` opcode (which leaves remaining gas untouched) while Solidity
293      * uses an invalid opcode to revert (consuming all remaining gas).
294      *
295      * Requirements:
296      *
297      * - The divisor cannot be zero.
298      */
299     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
300         require(b > 0, errorMessage);
301         return a / b;
302     }
303 
304     /**
305      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
306      * reverting with custom message when dividing by zero.
307      *
308      * CAUTION: This function is deprecated because it requires allocating memory for the error
309      * message unnecessarily. For custom revert reasons use {tryMod}.
310      *
311      * Counterpart to Solidity's `%` operator. This function uses a `revert`
312      * opcode (which leaves remaining gas untouched) while Solidity uses an
313      * invalid opcode to revert (consuming all remaining gas).
314      *
315      * Requirements:
316      *
317      * - The divisor cannot be zero.
318      */
319     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
320         require(b > 0, errorMessage);
321         return a % b;
322     }
323 }
324 
325 
326 // File @openzeppelin/contracts/token/ERC20/ERC20.sol@v3.4.0
327 
328 pragma solidity >=0.6.0 <0.8.0;
329 
330 
331 
332 /**
333  * @dev Implementation of the {IERC20} interface.
334  *
335  * This implementation is agnostic to the way tokens are created. This means
336  * that a supply mechanism has to be added in a derived contract using {_mint}.
337  * For a generic mechanism see {ERC20PresetMinterPauser}.
338  *
339  * TIP: For a detailed writeup see our guide
340  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
341  * to implement supply mechanisms].
342  *
343  * We have followed general OpenZeppelin guidelines: functions revert instead
344  * of returning `false` on failure. This behavior is nonetheless conventional
345  * and does not conflict with the expectations of ERC20 applications.
346  *
347  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
348  * This allows applications to reconstruct the allowance for all accounts just
349  * by listening to said events. Other implementations of the EIP may not emit
350  * these events, as it isn't required by the specification.
351  *
352  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
353  * functions have been added to mitigate the well-known issues around setting
354  * allowances. See {IERC20-approve}.
355  */
356 contract ERC20 is Context, IERC20 {
357     using SafeMath for uint256;
358 
359     mapping (address => uint256) private _balances;
360 
361     mapping (address => mapping (address => uint256)) private _allowances;
362 
363     uint256 private _totalSupply;
364 
365     string private _name;
366     string private _symbol;
367     uint8 private _decimals;
368 
369     /**
370      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
371      * a default value of 18.
372      *
373      * To select a different value for {decimals}, use {_setupDecimals}.
374      *
375      * All three of these values are immutable: they can only be set once during
376      * construction.
377      */
378     constructor (string memory name_, string memory symbol_) public {
379         _name = name_;
380         _symbol = symbol_;
381         _decimals = 18;
382     }
383 
384     /**
385      * @dev Returns the name of the token.
386      */
387     function name() public view virtual returns (string memory) {
388         return _name;
389     }
390 
391     /**
392      * @dev Returns the symbol of the token, usually a shorter version of the
393      * name.
394      */
395     function symbol() public view virtual returns (string memory) {
396         return _symbol;
397     }
398 
399     /**
400      * @dev Returns the number of decimals used to get its user representation.
401      * For example, if `decimals` equals `2`, a balance of `505` tokens should
402      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
403      *
404      * Tokens usually opt for a value of 18, imitating the relationship between
405      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
406      * called.
407      *
408      * NOTE: This information is only used for _display_ purposes: it in
409      * no way affects any of the arithmetic of the contract, including
410      * {IERC20-balanceOf} and {IERC20-transfer}.
411      */
412     function decimals() public view virtual returns (uint8) {
413         return _decimals;
414     }
415 
416     /**
417      * @dev See {IERC20-totalSupply}.
418      */
419     function totalSupply() public view virtual override returns (uint256) {
420         return _totalSupply;
421     }
422 
423     /**
424      * @dev See {IERC20-balanceOf}.
425      */
426     function balanceOf(address account) public view virtual override returns (uint256) {
427         return _balances[account];
428     }
429 
430     /**
431      * @dev See {IERC20-transfer}.
432      *
433      * Requirements:
434      *
435      * - `recipient` cannot be the zero address.
436      * - the caller must have a balance of at least `amount`.
437      */
438     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
439         _transfer(_msgSender(), recipient, amount);
440         return true;
441     }
442 
443     /**
444      * @dev See {IERC20-allowance}.
445      */
446     function allowance(address owner, address spender) public view virtual override returns (uint256) {
447         return _allowances[owner][spender];
448     }
449 
450     /**
451      * @dev See {IERC20-approve}.
452      *
453      * Requirements:
454      *
455      * - `spender` cannot be the zero address.
456      */
457     function approve(address spender, uint256 amount) public virtual override returns (bool) {
458         _approve(_msgSender(), spender, amount);
459         return true;
460     }
461 
462     /**
463      * @dev See {IERC20-transferFrom}.
464      *
465      * Emits an {Approval} event indicating the updated allowance. This is not
466      * required by the EIP. See the note at the beginning of {ERC20}.
467      *
468      * Requirements:
469      *
470      * - `sender` and `recipient` cannot be the zero address.
471      * - `sender` must have a balance of at least `amount`.
472      * - the caller must have allowance for ``sender``'s tokens of at least
473      * `amount`.
474      */
475     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
476         _transfer(sender, recipient, amount);
477         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
478         return true;
479     }
480 
481     /**
482      * @dev Atomically increases the allowance granted to `spender` by the caller.
483      *
484      * This is an alternative to {approve} that can be used as a mitigation for
485      * problems described in {IERC20-approve}.
486      *
487      * Emits an {Approval} event indicating the updated allowance.
488      *
489      * Requirements:
490      *
491      * - `spender` cannot be the zero address.
492      */
493     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
494         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
495         return true;
496     }
497 
498     /**
499      * @dev Atomically decreases the allowance granted to `spender` by the caller.
500      *
501      * This is an alternative to {approve} that can be used as a mitigation for
502      * problems described in {IERC20-approve}.
503      *
504      * Emits an {Approval} event indicating the updated allowance.
505      *
506      * Requirements:
507      *
508      * - `spender` cannot be the zero address.
509      * - `spender` must have allowance for the caller of at least
510      * `subtractedValue`.
511      */
512     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
513         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
514         return true;
515     }
516 
517     /**
518      * @dev Moves tokens `amount` from `sender` to `recipient`.
519      *
520      * This is internal function is equivalent to {transfer}, and can be used to
521      * e.g. implement automatic token fees, slashing mechanisms, etc.
522      *
523      * Emits a {Transfer} event.
524      *
525      * Requirements:
526      *
527      * - `sender` cannot be the zero address.
528      * - `recipient` cannot be the zero address.
529      * - `sender` must have a balance of at least `amount`.
530      */
531     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
532         require(sender != address(0), "ERC20: transfer from the zero address");
533         require(recipient != address(0), "ERC20: transfer to the zero address");
534 
535         _beforeTokenTransfer(sender, recipient, amount);
536 
537         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
538         _balances[recipient] = _balances[recipient].add(amount);
539         emit Transfer(sender, recipient, amount);
540     }
541 
542     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
543      * the total supply.
544      *
545      * Emits a {Transfer} event with `from` set to the zero address.
546      *
547      * Requirements:
548      *
549      * - `to` cannot be the zero address.
550      */
551     function _mint(address account, uint256 amount) internal virtual {
552         require(account != address(0), "ERC20: mint to the zero address");
553 
554         _beforeTokenTransfer(address(0), account, amount);
555 
556         _totalSupply = _totalSupply.add(amount);
557         _balances[account] = _balances[account].add(amount);
558         emit Transfer(address(0), account, amount);
559     }
560 
561     /**
562      * @dev Destroys `amount` tokens from `account`, reducing the
563      * total supply.
564      *
565      * Emits a {Transfer} event with `to` set to the zero address.
566      *
567      * Requirements:
568      *
569      * - `account` cannot be the zero address.
570      * - `account` must have at least `amount` tokens.
571      */
572     function _burn(address account, uint256 amount) internal virtual {
573         require(account != address(0), "ERC20: burn from the zero address");
574 
575         _beforeTokenTransfer(account, address(0), amount);
576 
577         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
578         _totalSupply = _totalSupply.sub(amount);
579         emit Transfer(account, address(0), amount);
580     }
581 
582     /**
583      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
584      *
585      * This internal function is equivalent to `approve`, and can be used to
586      * e.g. set automatic allowances for certain subsystems, etc.
587      *
588      * Emits an {Approval} event.
589      *
590      * Requirements:
591      *
592      * - `owner` cannot be the zero address.
593      * - `spender` cannot be the zero address.
594      */
595     function _approve(address owner, address spender, uint256 amount) internal virtual {
596         require(owner != address(0), "ERC20: approve from the zero address");
597         require(spender != address(0), "ERC20: approve to the zero address");
598 
599         _allowances[owner][spender] = amount;
600         emit Approval(owner, spender, amount);
601     }
602 
603     /**
604      * @dev Sets {decimals} to a value other than the default one of 18.
605      *
606      * WARNING: This function should only be called from the constructor. Most
607      * applications that interact with token contracts will not expect
608      * {decimals} to ever change, and may work incorrectly if it does.
609      */
610     function _setupDecimals(uint8 decimals_) internal virtual {
611         _decimals = decimals_;
612     }
613 
614     /**
615      * @dev Hook that is called before any transfer of tokens. This includes
616      * minting and burning.
617      *
618      * Calling conditions:
619      *
620      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
621      * will be to transferred to `to`.
622      * - when `from` is zero, `amount` tokens will be minted for `to`.
623      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
624      * - `from` and `to` are never both zero.
625      *
626      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
627      */
628     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
629 }
630 
631 
632 // File @openzeppelin/contracts/access/Ownable.sol@v3.4.0
633 
634 pragma solidity >=0.6.0 <0.8.0;
635 
636 /**
637  * @dev Contract module which provides a basic access control mechanism, where
638  * there is an account (an owner) that can be granted exclusive access to
639  * specific functions.
640  *
641  * By default, the owner account will be the one that deploys the contract. This
642  * can later be changed with {transferOwnership}.
643  *
644  * This module is used through inheritance. It will make available the modifier
645  * `onlyOwner`, which can be applied to your functions to restrict their use to
646  * the owner.
647  */
648 abstract contract Ownable is Context {
649     address private _owner;
650 
651     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
652 
653     /**
654      * @dev Initializes the contract setting the deployer as the initial owner.
655      */
656     constructor () internal {
657         address msgSender = _msgSender();
658         _owner = msgSender;
659         emit OwnershipTransferred(address(0), msgSender);
660     }
661 
662     /**
663      * @dev Returns the address of the current owner.
664      */
665     function owner() public view virtual returns (address) {
666         return _owner;
667     }
668 
669     /**
670      * @dev Throws if called by any account other than the owner.
671      */
672     modifier onlyOwner() {
673         require(owner() == _msgSender(), "Ownable: caller is not the owner");
674         _;
675     }
676 
677     /**
678      * @dev Leaves the contract without owner. It will not be possible to call
679      * `onlyOwner` functions anymore. Can only be called by the current owner.
680      *
681      * NOTE: Renouncing ownership will leave the contract without an owner,
682      * thereby removing any functionality that is only available to the owner.
683      */
684     function renounceOwnership() public virtual onlyOwner {
685         emit OwnershipTransferred(_owner, address(0));
686         _owner = address(0);
687     }
688 
689     /**
690      * @dev Transfers ownership of the contract to a new account (`newOwner`).
691      * Can only be called by the current owner.
692      */
693     function transferOwnership(address newOwner) public virtual onlyOwner {
694         require(newOwner != address(0), "Ownable: new owner is the zero address");
695         emit OwnershipTransferred(_owner, newOwner);
696         _owner = newOwner;
697     }
698 }
699 
700 
701 // File contracts/MerchDAO.sol
702 
703 pragma solidity ^0.7.6;
704 
705 
706 contract MerchDAO is ERC20("MerchDAO", "MRCH"), Ownable {
707     
708     uint public constant TOTAL_SUPPLY = 10000000 * (10 ** 18);
709     
710     constructor() public {    
711         _mint(msg.sender, TOTAL_SUPPLY);
712     }
713 }