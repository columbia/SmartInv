1 // SPDX-License-Identifier: UNLICENSED
2 // Sources flattened with hardhat v2.9.2 https://hardhat.org
3 
4 // File @openzeppelin/contracts/utils/Context.sol@v3.4.2-solc-0.7
5 
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
31 // File @openzeppelin/contracts/access/Ownable.sol@v3.4.2-solc-0.7
32 
33 
34 pragma solidity ^0.7.0;
35 
36 /**
37  * @dev Contract module which provides a basic access control mechanism, where
38  * there is an account (an owner) that can be granted exclusive access to
39  * specific functions.
40  *
41  * By default, the owner account will be the one that deploys the contract. This
42  * can later be changed with {transferOwnership}.
43  *
44  * This module is used through inheritance. It will make available the modifier
45  * `onlyOwner`, which can be applied to your functions to restrict their use to
46  * the owner.
47  */
48 abstract contract Ownable is Context {
49     address private _owner;
50 
51     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
52 
53     /**
54      * @dev Initializes the contract setting the deployer as the initial owner.
55      */
56     constructor () {
57         address msgSender = _msgSender();
58         _owner = msgSender;
59         emit OwnershipTransferred(address(0), msgSender);
60     }
61 
62     /**
63      * @dev Returns the address of the current owner.
64      */
65     function owner() public view virtual returns (address) {
66         return _owner;
67     }
68 
69     /**
70      * @dev Throws if called by any account other than the owner.
71      */
72     modifier onlyOwner() {
73         require(owner() == _msgSender(), "Ownable: caller is not the owner");
74         _;
75     }
76 
77     /**
78      * @dev Leaves the contract without owner. It will not be possible to call
79      * `onlyOwner` functions anymore. Can only be called by the current owner.
80      *
81      * NOTE: Renouncing ownership will leave the contract without an owner,
82      * thereby removing any functionality that is only available to the owner.
83      */
84     function renounceOwnership() public virtual onlyOwner {
85         emit OwnershipTransferred(_owner, address(0));
86         _owner = address(0);
87     }
88 
89     /**
90      * @dev Transfers ownership of the contract to a new account (`newOwner`).
91      * Can only be called by the current owner.
92      */
93     function transferOwnership(address newOwner) public virtual onlyOwner {
94         require(newOwner != address(0), "Ownable: new owner is the zero address");
95         emit OwnershipTransferred(_owner, newOwner);
96         _owner = newOwner;
97     }
98 }
99 
100 
101 // File @openzeppelin/contracts/token/ERC20/IERC20.sol@v3.4.2-solc-0.7
102 
103 
104 pragma solidity ^0.7.0;
105 
106 /**
107  * @dev Interface of the ERC20 standard as defined in the EIP.
108  */
109 interface IERC20 {
110     /**
111      * @dev Returns the amount of tokens in existence.
112      */
113     function totalSupply() external view returns (uint256);
114 
115     /**
116      * @dev Returns the amount of tokens owned by `account`.
117      */
118     function balanceOf(address account) external view returns (uint256);
119 
120     /**
121      * @dev Moves `amount` tokens from the caller's account to `recipient`.
122      *
123      * Returns a boolean value indicating whether the operation succeeded.
124      *
125      * Emits a {Transfer} event.
126      */
127     function transfer(address recipient, uint256 amount) external returns (bool);
128 
129     /**
130      * @dev Returns the remaining number of tokens that `spender` will be
131      * allowed to spend on behalf of `owner` through {transferFrom}. This is
132      * zero by default.
133      *
134      * This value changes when {approve} or {transferFrom} are called.
135      */
136     function allowance(address owner, address spender) external view returns (uint256);
137 
138     /**
139      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
140      *
141      * Returns a boolean value indicating whether the operation succeeded.
142      *
143      * IMPORTANT: Beware that changing an allowance with this method brings the risk
144      * that someone may use both the old and the new allowance by unfortunate
145      * transaction ordering. One possible solution to mitigate this race
146      * condition is to first reduce the spender's allowance to 0 and set the
147      * desired value afterwards:
148      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
149      *
150      * Emits an {Approval} event.
151      */
152     function approve(address spender, uint256 amount) external returns (bool);
153 
154     /**
155      * @dev Moves `amount` tokens from `sender` to `recipient` using the
156      * allowance mechanism. `amount` is then deducted from the caller's
157      * allowance.
158      *
159      * Returns a boolean value indicating whether the operation succeeded.
160      *
161      * Emits a {Transfer} event.
162      */
163     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
164 
165     /**
166      * @dev Emitted when `value` tokens are moved from one account (`from`) to
167      * another (`to`).
168      *
169      * Note that `value` may be zero.
170      */
171     event Transfer(address indexed from, address indexed to, uint256 value);
172 
173     /**
174      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
175      * a call to {approve}. `value` is the new allowance.
176      */
177     event Approval(address indexed owner, address indexed spender, uint256 value);
178 }
179 
180 
181 // File @openzeppelin/contracts/math/SafeMath.sol@v3.4.2-solc-0.7
182 
183 
184 pragma solidity ^0.7.0;
185 
186 /**
187  * @dev Wrappers over Solidity's arithmetic operations with added overflow
188  * checks.
189  *
190  * Arithmetic operations in Solidity wrap on overflow. This can easily result
191  * in bugs, because programmers usually assume that an overflow raises an
192  * error, which is the standard behavior in high level programming languages.
193  * `SafeMath` restores this intuition by reverting the transaction when an
194  * operation overflows.
195  *
196  * Using this library instead of the unchecked operations eliminates an entire
197  * class of bugs, so it's recommended to use it always.
198  */
199 library SafeMath {
200     /**
201      * @dev Returns the addition of two unsigned integers, with an overflow flag.
202      *
203      * _Available since v3.4._
204      */
205     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
206         uint256 c = a + b;
207         if (c < a) return (false, 0);
208         return (true, c);
209     }
210 
211     /**
212      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
213      *
214      * _Available since v3.4._
215      */
216     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
217         if (b > a) return (false, 0);
218         return (true, a - b);
219     }
220 
221     /**
222      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
223      *
224      * _Available since v3.4._
225      */
226     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
227         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
228         // benefit is lost if 'b' is also tested.
229         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
230         if (a == 0) return (true, 0);
231         uint256 c = a * b;
232         if (c / a != b) return (false, 0);
233         return (true, c);
234     }
235 
236     /**
237      * @dev Returns the division of two unsigned integers, with a division by zero flag.
238      *
239      * _Available since v3.4._
240      */
241     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
242         if (b == 0) return (false, 0);
243         return (true, a / b);
244     }
245 
246     /**
247      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
248      *
249      * _Available since v3.4._
250      */
251     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
252         if (b == 0) return (false, 0);
253         return (true, a % b);
254     }
255 
256     /**
257      * @dev Returns the addition of two unsigned integers, reverting on
258      * overflow.
259      *
260      * Counterpart to Solidity's `+` operator.
261      *
262      * Requirements:
263      *
264      * - Addition cannot overflow.
265      */
266     function add(uint256 a, uint256 b) internal pure returns (uint256) {
267         uint256 c = a + b;
268         require(c >= a, "SafeMath: addition overflow");
269         return c;
270     }
271 
272     /**
273      * @dev Returns the subtraction of two unsigned integers, reverting on
274      * overflow (when the result is negative).
275      *
276      * Counterpart to Solidity's `-` operator.
277      *
278      * Requirements:
279      *
280      * - Subtraction cannot overflow.
281      */
282     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
283         require(b <= a, "SafeMath: subtraction overflow");
284         return a - b;
285     }
286 
287     /**
288      * @dev Returns the multiplication of two unsigned integers, reverting on
289      * overflow.
290      *
291      * Counterpart to Solidity's `*` operator.
292      *
293      * Requirements:
294      *
295      * - Multiplication cannot overflow.
296      */
297     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
298         if (a == 0) return 0;
299         uint256 c = a * b;
300         require(c / a == b, "SafeMath: multiplication overflow");
301         return c;
302     }
303 
304     /**
305      * @dev Returns the integer division of two unsigned integers, reverting on
306      * division by zero. The result is rounded towards zero.
307      *
308      * Counterpart to Solidity's `/` operator. Note: this function uses a
309      * `revert` opcode (which leaves remaining gas untouched) while Solidity
310      * uses an invalid opcode to revert (consuming all remaining gas).
311      *
312      * Requirements:
313      *
314      * - The divisor cannot be zero.
315      */
316     function div(uint256 a, uint256 b) internal pure returns (uint256) {
317         require(b > 0, "SafeMath: division by zero");
318         return a / b;
319     }
320 
321     /**
322      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
323      * reverting when dividing by zero.
324      *
325      * Counterpart to Solidity's `%` operator. This function uses a `revert`
326      * opcode (which leaves remaining gas untouched) while Solidity uses an
327      * invalid opcode to revert (consuming all remaining gas).
328      *
329      * Requirements:
330      *
331      * - The divisor cannot be zero.
332      */
333     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
334         require(b > 0, "SafeMath: modulo by zero");
335         return a % b;
336     }
337 
338     /**
339      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
340      * overflow (when the result is negative).
341      *
342      * CAUTION: This function is deprecated because it requires allocating memory for the error
343      * message unnecessarily. For custom revert reasons use {trySub}.
344      *
345      * Counterpart to Solidity's `-` operator.
346      *
347      * Requirements:
348      *
349      * - Subtraction cannot overflow.
350      */
351     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
352         require(b <= a, errorMessage);
353         return a - b;
354     }
355 
356     /**
357      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
358      * division by zero. The result is rounded towards zero.
359      *
360      * CAUTION: This function is deprecated because it requires allocating memory for the error
361      * message unnecessarily. For custom revert reasons use {tryDiv}.
362      *
363      * Counterpart to Solidity's `/` operator. Note: this function uses a
364      * `revert` opcode (which leaves remaining gas untouched) while Solidity
365      * uses an invalid opcode to revert (consuming all remaining gas).
366      *
367      * Requirements:
368      *
369      * - The divisor cannot be zero.
370      */
371     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
372         require(b > 0, errorMessage);
373         return a / b;
374     }
375 
376     /**
377      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
378      * reverting with custom message when dividing by zero.
379      *
380      * CAUTION: This function is deprecated because it requires allocating memory for the error
381      * message unnecessarily. For custom revert reasons use {tryMod}.
382      *
383      * Counterpart to Solidity's `%` operator. This function uses a `revert`
384      * opcode (which leaves remaining gas untouched) while Solidity uses an
385      * invalid opcode to revert (consuming all remaining gas).
386      *
387      * Requirements:
388      *
389      * - The divisor cannot be zero.
390      */
391     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
392         require(b > 0, errorMessage);
393         return a % b;
394     }
395 }
396 
397 
398 // File @openzeppelin/contracts/token/ERC20/ERC20.sol@v3.4.2-solc-0.7
399 
400 
401 pragma solidity ^0.7.0;
402 
403 
404 
405 /**
406  * @dev Implementation of the {IERC20} interface.
407  *
408  * This implementation is agnostic to the way tokens are created. This means
409  * that a supply mechanism has to be added in a derived contract using {_mint}.
410  * For a generic mechanism see {ERC20PresetMinterPauser}.
411  *
412  * TIP: For a detailed writeup see our guide
413  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
414  * to implement supply mechanisms].
415  *
416  * We have followed general OpenZeppelin guidelines: functions revert instead
417  * of returning `false` on failure. This behavior is nonetheless conventional
418  * and does not conflict with the expectations of ERC20 applications.
419  *
420  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
421  * This allows applications to reconstruct the allowance for all accounts just
422  * by listening to said events. Other implementations of the EIP may not emit
423  * these events, as it isn't required by the specification.
424  *
425  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
426  * functions have been added to mitigate the well-known issues around setting
427  * allowances. See {IERC20-approve}.
428  */
429 contract ERC20 is Context, IERC20 {
430     using SafeMath for uint256;
431 
432     mapping (address => uint256) private _balances;
433 
434     mapping (address => mapping (address => uint256)) private _allowances;
435 
436     uint256 private _totalSupply;
437 
438     string private _name;
439     string private _symbol;
440     uint8 private _decimals;
441 
442     /**
443      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
444      * a default value of 18.
445      *
446      * To select a different value for {decimals}, use {_setupDecimals}.
447      *
448      * All three of these values are immutable: they can only be set once during
449      * construction.
450      */
451     constructor (string memory name_, string memory symbol_) {
452         _name = name_;
453         _symbol = symbol_;
454         _decimals = 18;
455     }
456 
457     /**
458      * @dev Returns the name of the token.
459      */
460     function name() public view virtual returns (string memory) {
461         return _name;
462     }
463 
464     /**
465      * @dev Returns the symbol of the token, usually a shorter version of the
466      * name.
467      */
468     function symbol() public view virtual returns (string memory) {
469         return _symbol;
470     }
471 
472     /**
473      * @dev Returns the number of decimals used to get its user representation.
474      * For example, if `decimals` equals `2`, a balance of `505` tokens should
475      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
476      *
477      * Tokens usually opt for a value of 18, imitating the relationship between
478      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
479      * called.
480      *
481      * NOTE: This information is only used for _display_ purposes: it in
482      * no way affects any of the arithmetic of the contract, including
483      * {IERC20-balanceOf} and {IERC20-transfer}.
484      */
485     function decimals() public view virtual returns (uint8) {
486         return _decimals;
487     }
488 
489     /**
490      * @dev See {IERC20-totalSupply}.
491      */
492     function totalSupply() public view virtual override returns (uint256) {
493         return _totalSupply;
494     }
495 
496     /**
497      * @dev See {IERC20-balanceOf}.
498      */
499     function balanceOf(address account) public view virtual override returns (uint256) {
500         return _balances[account];
501     }
502 
503     /**
504      * @dev See {IERC20-transfer}.
505      *
506      * Requirements:
507      *
508      * - `recipient` cannot be the zero address.
509      * - the caller must have a balance of at least `amount`.
510      */
511     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
512         _transfer(_msgSender(), recipient, amount);
513         return true;
514     }
515 
516     /**
517      * @dev See {IERC20-allowance}.
518      */
519     function allowance(address owner, address spender) public view virtual override returns (uint256) {
520         return _allowances[owner][spender];
521     }
522 
523     /**
524      * @dev See {IERC20-approve}.
525      *
526      * Requirements:
527      *
528      * - `spender` cannot be the zero address.
529      */
530     function approve(address spender, uint256 amount) public virtual override returns (bool) {
531         _approve(_msgSender(), spender, amount);
532         return true;
533     }
534 
535     /**
536      * @dev See {IERC20-transferFrom}.
537      *
538      * Emits an {Approval} event indicating the updated allowance. This is not
539      * required by the EIP. See the note at the beginning of {ERC20}.
540      *
541      * Requirements:
542      *
543      * - `sender` and `recipient` cannot be the zero address.
544      * - `sender` must have a balance of at least `amount`.
545      * - the caller must have allowance for ``sender``'s tokens of at least
546      * `amount`.
547      */
548     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
549         _transfer(sender, recipient, amount);
550         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
551         return true;
552     }
553 
554     /**
555      * @dev Atomically increases the allowance granted to `spender` by the caller.
556      *
557      * This is an alternative to {approve} that can be used as a mitigation for
558      * problems described in {IERC20-approve}.
559      *
560      * Emits an {Approval} event indicating the updated allowance.
561      *
562      * Requirements:
563      *
564      * - `spender` cannot be the zero address.
565      */
566     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
567         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
568         return true;
569     }
570 
571     /**
572      * @dev Atomically decreases the allowance granted to `spender` by the caller.
573      *
574      * This is an alternative to {approve} that can be used as a mitigation for
575      * problems described in {IERC20-approve}.
576      *
577      * Emits an {Approval} event indicating the updated allowance.
578      *
579      * Requirements:
580      *
581      * - `spender` cannot be the zero address.
582      * - `spender` must have allowance for the caller of at least
583      * `subtractedValue`.
584      */
585     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
586         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
587         return true;
588     }
589 
590     /**
591      * @dev Moves tokens `amount` from `sender` to `recipient`.
592      *
593      * This is internal function is equivalent to {transfer}, and can be used to
594      * e.g. implement automatic token fees, slashing mechanisms, etc.
595      *
596      * Emits a {Transfer} event.
597      *
598      * Requirements:
599      *
600      * - `sender` cannot be the zero address.
601      * - `recipient` cannot be the zero address.
602      * - `sender` must have a balance of at least `amount`.
603      */
604     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
605         require(sender != address(0), "ERC20: transfer from the zero address");
606         require(recipient != address(0), "ERC20: transfer to the zero address");
607 
608         _beforeTokenTransfer(sender, recipient, amount);
609 
610         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
611         _balances[recipient] = _balances[recipient].add(amount);
612         emit Transfer(sender, recipient, amount);
613     }
614 
615     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
616      * the total supply.
617      *
618      * Emits a {Transfer} event with `from` set to the zero address.
619      *
620      * Requirements:
621      *
622      * - `to` cannot be the zero address.
623      */
624     function _mint(address account, uint256 amount) internal virtual {
625         require(account != address(0), "ERC20: mint to the zero address");
626 
627         _beforeTokenTransfer(address(0), account, amount);
628 
629         _totalSupply = _totalSupply.add(amount);
630         _balances[account] = _balances[account].add(amount);
631         emit Transfer(address(0), account, amount);
632     }
633 
634     /**
635      * @dev Destroys `amount` tokens from `account`, reducing the
636      * total supply.
637      *
638      * Emits a {Transfer} event with `to` set to the zero address.
639      *
640      * Requirements:
641      *
642      * - `account` cannot be the zero address.
643      * - `account` must have at least `amount` tokens.
644      */
645     function _burn(address account, uint256 amount) internal virtual {
646         require(account != address(0), "ERC20: burn from the zero address");
647 
648         _beforeTokenTransfer(account, address(0), amount);
649 
650         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
651         _totalSupply = _totalSupply.sub(amount);
652         emit Transfer(account, address(0), amount);
653     }
654 
655     /**
656      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
657      *
658      * This internal function is equivalent to `approve`, and can be used to
659      * e.g. set automatic allowances for certain subsystems, etc.
660      *
661      * Emits an {Approval} event.
662      *
663      * Requirements:
664      *
665      * - `owner` cannot be the zero address.
666      * - `spender` cannot be the zero address.
667      */
668     function _approve(address owner, address spender, uint256 amount) internal virtual {
669         require(owner != address(0), "ERC20: approve from the zero address");
670         require(spender != address(0), "ERC20: approve to the zero address");
671 
672         _allowances[owner][spender] = amount;
673         emit Approval(owner, spender, amount);
674     }
675 
676     /**
677      * @dev Sets {decimals} to a value other than the default one of 18.
678      *
679      * WARNING: This function should only be called from the constructor. Most
680      * applications that interact with token contracts will not expect
681      * {decimals} to ever change, and may work incorrectly if it does.
682      */
683     function _setupDecimals(uint8 decimals_) internal virtual {
684         _decimals = decimals_;
685     }
686 
687     /**
688      * @dev Hook that is called before any transfer of tokens. This includes
689      * minting and burning.
690      *
691      * Calling conditions:
692      *
693      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
694      * will be to transferred to `to`.
695      * - when `from` is zero, `amount` tokens will be minted for `to`.
696      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
697      * - `from` and `to` are never both zero.
698      *
699      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
700      */
701     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
702 }
703 
704 
705 // File @openzeppelin/contracts/utils/Address.sol@v3.4.2-solc-0.7
706 
707 
708 pragma solidity ^0.7.0;
709 
710 /**
711  * @dev Collection of functions related to the address type
712  */
713 library Address {
714     /**
715      * @dev Returns true if `account` is a contract.
716      *
717      * [IMPORTANT]
718      * ====
719      * It is unsafe to assume that an address for which this function returns
720      * false is an externally-owned account (EOA) and not a contract.
721      *
722      * Among others, `isContract` will return false for the following
723      * types of addresses:
724      *
725      *  - an externally-owned account
726      *  - a contract in construction
727      *  - an address where a contract will be created
728      *  - an address where a contract lived, but was destroyed
729      * ====
730      */
731     function isContract(address account) internal view returns (bool) {
732         // This method relies on extcodesize, which returns 0 for contracts in
733         // construction, since the code is only stored at the end of the
734         // constructor execution.
735 
736         uint256 size;
737         // solhint-disable-next-line no-inline-assembly
738         assembly { size := extcodesize(account) }
739         return size > 0;
740     }
741 
742     /**
743      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
744      * `recipient`, forwarding all available gas and reverting on errors.
745      *
746      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
747      * of certain opcodes, possibly making contracts go over the 2300 gas limit
748      * imposed by `transfer`, making them unable to receive funds via
749      * `transfer`. {sendValue} removes this limitation.
750      *
751      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
752      *
753      * IMPORTANT: because control is transferred to `recipient`, care must be
754      * taken to not create reentrancy vulnerabilities. Consider using
755      * {ReentrancyGuard} or the
756      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
757      */
758     function sendValue(address payable recipient, uint256 amount) internal {
759         require(address(this).balance >= amount, "Address: insufficient balance");
760 
761         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
762         (bool success, ) = recipient.call{ value: amount }("");
763         require(success, "Address: unable to send value, recipient may have reverted");
764     }
765 
766     /**
767      * @dev Performs a Solidity function call using a low level `call`. A
768      * plain`call` is an unsafe replacement for a function call: use this
769      * function instead.
770      *
771      * If `target` reverts with a revert reason, it is bubbled up by this
772      * function (like regular Solidity function calls).
773      *
774      * Returns the raw returned data. To convert to the expected return value,
775      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
776      *
777      * Requirements:
778      *
779      * - `target` must be a contract.
780      * - calling `target` with `data` must not revert.
781      *
782      * _Available since v3.1._
783      */
784     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
785       return functionCall(target, data, "Address: low-level call failed");
786     }
787 
788     /**
789      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
790      * `errorMessage` as a fallback revert reason when `target` reverts.
791      *
792      * _Available since v3.1._
793      */
794     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
795         return functionCallWithValue(target, data, 0, errorMessage);
796     }
797 
798     /**
799      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
800      * but also transferring `value` wei to `target`.
801      *
802      * Requirements:
803      *
804      * - the calling contract must have an ETH balance of at least `value`.
805      * - the called Solidity function must be `payable`.
806      *
807      * _Available since v3.1._
808      */
809     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
810         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
811     }
812 
813     /**
814      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
815      * with `errorMessage` as a fallback revert reason when `target` reverts.
816      *
817      * _Available since v3.1._
818      */
819     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
820         require(address(this).balance >= value, "Address: insufficient balance for call");
821         require(isContract(target), "Address: call to non-contract");
822 
823         // solhint-disable-next-line avoid-low-level-calls
824         (bool success, bytes memory returndata) = target.call{ value: value }(data);
825         return _verifyCallResult(success, returndata, errorMessage);
826     }
827 
828     /**
829      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
830      * but performing a static call.
831      *
832      * _Available since v3.3._
833      */
834     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
835         return functionStaticCall(target, data, "Address: low-level static call failed");
836     }
837 
838     /**
839      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
840      * but performing a static call.
841      *
842      * _Available since v3.3._
843      */
844     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
845         require(isContract(target), "Address: static call to non-contract");
846 
847         // solhint-disable-next-line avoid-low-level-calls
848         (bool success, bytes memory returndata) = target.staticcall(data);
849         return _verifyCallResult(success, returndata, errorMessage);
850     }
851 
852     /**
853      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
854      * but performing a delegate call.
855      *
856      * _Available since v3.4._
857      */
858     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
859         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
860     }
861 
862     /**
863      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
864      * but performing a delegate call.
865      *
866      * _Available since v3.4._
867      */
868     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
869         require(isContract(target), "Address: delegate call to non-contract");
870 
871         // solhint-disable-next-line avoid-low-level-calls
872         (bool success, bytes memory returndata) = target.delegatecall(data);
873         return _verifyCallResult(success, returndata, errorMessage);
874     }
875 
876     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
877         if (success) {
878             return returndata;
879         } else {
880             // Look for revert reason and bubble it up if present
881             if (returndata.length > 0) {
882                 // The easiest way to bubble the revert reason is using memory via assembly
883 
884                 // solhint-disable-next-line no-inline-assembly
885                 assembly {
886                     let returndata_size := mload(returndata)
887                     revert(add(32, returndata), returndata_size)
888                 }
889             } else {
890                 revert(errorMessage);
891             }
892         }
893     }
894 }
895 
896 
897 // File @openzeppelin/contracts/token/ERC20/SafeERC20.sol@v3.4.2-solc-0.7
898 
899 
900 pragma solidity ^0.7.0;
901 
902 
903 
904 /**
905  * @title SafeERC20
906  * @dev Wrappers around ERC20 operations that throw on failure (when the token
907  * contract returns false). Tokens that return no value (and instead revert or
908  * throw on failure) are also supported, non-reverting calls are assumed to be
909  * successful.
910  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
911  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
912  */
913 library SafeERC20 {
914     using SafeMath for uint256;
915     using Address for address;
916 
917     function safeTransfer(IERC20 token, address to, uint256 value) internal {
918         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
919     }
920 
921     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
922         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
923     }
924 
925     /**
926      * @dev Deprecated. This function has issues similar to the ones found in
927      * {IERC20-approve}, and its usage is discouraged.
928      *
929      * Whenever possible, use {safeIncreaseAllowance} and
930      * {safeDecreaseAllowance} instead.
931      */
932     function safeApprove(IERC20 token, address spender, uint256 value) internal {
933         // safeApprove should only be called when setting an initial allowance,
934         // or when resetting it to zero. To increase and decrease it, use
935         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
936         // solhint-disable-next-line max-line-length
937         require((value == 0) || (token.allowance(address(this), spender) == 0),
938             "SafeERC20: approve from non-zero to non-zero allowance"
939         );
940         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
941     }
942 
943     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
944         uint256 newAllowance = token.allowance(address(this), spender).add(value);
945         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
946     }
947 
948     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
949         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
950         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
951     }
952 
953     /**
954      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
955      * on the return value: the return value is optional (but if data is returned, it must not be false).
956      * @param token The token targeted by the call.
957      * @param data The call data (encoded using abi.encode or one of its variants).
958      */
959     function _callOptionalReturn(IERC20 token, bytes memory data) private {
960         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
961         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
962         // the target address contains contract code and also asserts for success in the low-level call.
963 
964         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
965         if (returndata.length > 0) { // Return data is optional
966             // solhint-disable-next-line max-line-length
967             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
968         }
969     }
970 }
971 
972 
973 // File @openzeppelin/contracts/utils/Pausable.sol@v3.4.2-solc-0.7
974 
975 
976 pragma solidity ^0.7.0;
977 
978 /**
979  * @dev Contract module which allows children to implement an emergency stop
980  * mechanism that can be triggered by an authorized account.
981  *
982  * This module is used through inheritance. It will make available the
983  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
984  * the functions of your contract. Note that they will not be pausable by
985  * simply including this module, only once the modifiers are put in place.
986  */
987 abstract contract Pausable is Context {
988     /**
989      * @dev Emitted when the pause is triggered by `account`.
990      */
991     event Paused(address account);
992 
993     /**
994      * @dev Emitted when the pause is lifted by `account`.
995      */
996     event Unpaused(address account);
997 
998     bool private _paused;
999 
1000     /**
1001      * @dev Initializes the contract in unpaused state.
1002      */
1003     constructor () {
1004         _paused = false;
1005     }
1006 
1007     /**
1008      * @dev Returns true if the contract is paused, and false otherwise.
1009      */
1010     function paused() public view virtual returns (bool) {
1011         return _paused;
1012     }
1013 
1014     /**
1015      * @dev Modifier to make a function callable only when the contract is not paused.
1016      *
1017      * Requirements:
1018      *
1019      * - The contract must not be paused.
1020      */
1021     modifier whenNotPaused() {
1022         require(!paused(), "Pausable: paused");
1023         _;
1024     }
1025 
1026     /**
1027      * @dev Modifier to make a function callable only when the contract is paused.
1028      *
1029      * Requirements:
1030      *
1031      * - The contract must be paused.
1032      */
1033     modifier whenPaused() {
1034         require(paused(), "Pausable: not paused");
1035         _;
1036     }
1037 
1038     /**
1039      * @dev Triggers stopped state.
1040      *
1041      * Requirements:
1042      *
1043      * - The contract must not be paused.
1044      */
1045     function _pause() internal virtual whenNotPaused {
1046         _paused = true;
1047         emit Paused(_msgSender());
1048     }
1049 
1050     /**
1051      * @dev Returns to normal state.
1052      *
1053      * Requirements:
1054      *
1055      * - The contract must be paused.
1056      */
1057     function _unpause() internal virtual whenPaused {
1058         _paused = false;
1059         emit Unpaused(_msgSender());
1060     }
1061 }
1062 
1063 
1064 // File @uniswap/v3-core/contracts/libraries/FullMath.sol@v1.0.1
1065 
1066 pragma solidity >=0.4.0 <0.8.0;
1067 
1068 /// @title Contains 512-bit math functions
1069 /// @notice Facilitates multiplication and division that can have overflow of an intermediate value without any loss of precision
1070 /// @dev Handles "phantom overflow" i.e., allows multiplication and division where an intermediate value overflows 256 bits
1071 library FullMath {
1072     /// @notice Calculates floor(a×b÷denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
1073     /// @param a The multiplicand
1074     /// @param b The multiplier
1075     /// @param denominator The divisor
1076     /// @return result The 256-bit result
1077     /// @dev Credit to Remco Bloemen under MIT license https://xn--2-umb.com/21/muldiv
1078     function mulDiv(
1079         uint256 a,
1080         uint256 b,
1081         uint256 denominator
1082     ) internal pure returns (uint256 result) {
1083         // 512-bit multiply [prod1 prod0] = a * b
1084         // Compute the product mod 2**256 and mod 2**256 - 1
1085         // then use the Chinese Remainder Theorem to reconstruct
1086         // the 512 bit result. The result is stored in two 256
1087         // variables such that product = prod1 * 2**256 + prod0
1088         uint256 prod0; // Least significant 256 bits of the product
1089         uint256 prod1; // Most significant 256 bits of the product
1090         assembly {
1091             let mm := mulmod(a, b, not(0))
1092             prod0 := mul(a, b)
1093             prod1 := sub(sub(mm, prod0), lt(mm, prod0))
1094         }
1095 
1096         // Handle non-overflow cases, 256 by 256 division
1097         if (prod1 == 0) {
1098             require(denominator > 0);
1099             assembly {
1100                 result := div(prod0, denominator)
1101             }
1102             return result;
1103         }
1104 
1105         // Make sure the result is less than 2**256.
1106         // Also prevents denominator == 0
1107         require(denominator > prod1);
1108 
1109         ///////////////////////////////////////////////
1110         // 512 by 256 division.
1111         ///////////////////////////////////////////////
1112 
1113         // Make division exact by subtracting the remainder from [prod1 prod0]
1114         // Compute remainder using mulmod
1115         uint256 remainder;
1116         assembly {
1117             remainder := mulmod(a, b, denominator)
1118         }
1119         // Subtract 256 bit number from 512 bit number
1120         assembly {
1121             prod1 := sub(prod1, gt(remainder, prod0))
1122             prod0 := sub(prod0, remainder)
1123         }
1124 
1125         // Factor powers of two out of denominator
1126         // Compute largest power of two divisor of denominator.
1127         // Always >= 1.
1128         uint256 twos = -denominator & denominator;
1129         // Divide denominator by power of two
1130         assembly {
1131             denominator := div(denominator, twos)
1132         }
1133 
1134         // Divide [prod1 prod0] by the factors of two
1135         assembly {
1136             prod0 := div(prod0, twos)
1137         }
1138         // Shift in bits from prod1 into prod0. For this we need
1139         // to flip `twos` such that it is 2**256 / twos.
1140         // If twos is zero, then it becomes one
1141         assembly {
1142             twos := add(div(sub(0, twos), twos), 1)
1143         }
1144         prod0 |= prod1 * twos;
1145 
1146         // Invert denominator mod 2**256
1147         // Now that denominator is an odd number, it has an inverse
1148         // modulo 2**256 such that denominator * inv = 1 mod 2**256.
1149         // Compute the inverse by starting with a seed that is correct
1150         // correct for four bits. That is, denominator * inv = 1 mod 2**4
1151         uint256 inv = (3 * denominator) ^ 2;
1152         // Now use Newton-Raphson iteration to improve the precision.
1153         // Thanks to Hensel's lifting lemma, this also works in modular
1154         // arithmetic, doubling the correct bits in each step.
1155         inv *= 2 - denominator * inv; // inverse mod 2**8
1156         inv *= 2 - denominator * inv; // inverse mod 2**16
1157         inv *= 2 - denominator * inv; // inverse mod 2**32
1158         inv *= 2 - denominator * inv; // inverse mod 2**64
1159         inv *= 2 - denominator * inv; // inverse mod 2**128
1160         inv *= 2 - denominator * inv; // inverse mod 2**256
1161 
1162         // Because the division is now exact we can divide by multiplying
1163         // with the modular inverse of denominator. This will give us the
1164         // correct result modulo 2**256. Since the precoditions guarantee
1165         // that the outcome is less than 2**256, this is the final result.
1166         // We don't need to compute the high bits of the result and prod1
1167         // is no longer required.
1168         result = prod0 * inv;
1169         return result;
1170     }
1171 
1172     /// @notice Calculates ceil(a×b÷denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
1173     /// @param a The multiplicand
1174     /// @param b The multiplier
1175     /// @param denominator The divisor
1176     /// @return result The 256-bit result
1177     function mulDivRoundingUp(
1178         uint256 a,
1179         uint256 b,
1180         uint256 denominator
1181     ) internal pure returns (uint256 result) {
1182         result = mulDiv(a, b, denominator);
1183         if (mulmod(a, b, denominator) > 0) {
1184             require(result < type(uint256).max);
1185             result++;
1186         }
1187     }
1188 }
1189 
1190 
1191 // File @uniswap/v3-core/contracts/libraries/LowGasSafeMath.sol@v1.0.1
1192 
1193 pragma solidity >=0.7.0;
1194 
1195 /// @title Optimized overflow and underflow safe math operations
1196 /// @notice Contains methods for doing math operations that revert on overflow or underflow for minimal gas cost
1197 library LowGasSafeMath {
1198     /// @notice Returns x + y, reverts if sum overflows uint256
1199     /// @param x The augend
1200     /// @param y The addend
1201     /// @return z The sum of x and y
1202     function add(uint256 x, uint256 y) internal pure returns (uint256 z) {
1203         require((z = x + y) >= x);
1204     }
1205 
1206     /// @notice Returns x - y, reverts if underflows
1207     /// @param x The minuend
1208     /// @param y The subtrahend
1209     /// @return z The difference of x and y
1210     function sub(uint256 x, uint256 y) internal pure returns (uint256 z) {
1211         require((z = x - y) <= x);
1212     }
1213 
1214     /// @notice Returns x * y, reverts if overflows
1215     /// @param x The multiplicand
1216     /// @param y The multiplier
1217     /// @return z The product of x and y
1218     function mul(uint256 x, uint256 y) internal pure returns (uint256 z) {
1219         require(x == 0 || (z = x * y) / x == y);
1220     }
1221 
1222     /// @notice Returns x + y, reverts if overflows or underflows
1223     /// @param x The augend
1224     /// @param y The addend
1225     /// @return z The sum of x and y
1226     function add(int256 x, int256 y) internal pure returns (int256 z) {
1227         require((z = x + y) >= x == (y >= 0));
1228     }
1229 
1230     /// @notice Returns x - y, reverts if overflows or underflows
1231     /// @param x The minuend
1232     /// @param y The subtrahend
1233     /// @return z The difference of x and y
1234     function sub(int256 x, int256 y) internal pure returns (int256 z) {
1235         require((z = x - y) <= x == (y >= 0));
1236     }
1237 }
1238 
1239 
1240 // File contracts/Stone.sol
1241 
1242 pragma solidity ^0.7.6;
1243 
1244 
1245 
1246 
1247 
1248 
1249 /**
1250  * @title Stone ERC-20 token Contract
1251  */
1252 
1253 contract Stone is Ownable, ERC20, Pausable {
1254     using LowGasSafeMath for uint256;
1255     using FullMath for uint256;
1256     using SafeERC20 for IERC20;
1257 
1258     /// @notice Event emitted when tax rate changes
1259     event taxChanged(uint256 _taxRate);
1260 
1261     /// @notice Event emitted when bot tax rate changes
1262     event botTaxChanged(uint256 _botTaxRate);
1263 
1264     /// @notice Event emitted when add or remove size free account
1265     event sizeFreeChanged(address _sizeFreeAccount);
1266 
1267     /// @notice Event emitted when add or remove tax free account
1268     event taxFreeChanged(address _taxFreeAccount);
1269 
1270     /// @notice Event emitted when add or remove blacklistWallet
1271     event blacklistWalletChanged(address _blacklistWalletAccount);
1272 
1273     /// @notice Event emitted when add or remove botWallet
1274     event botWalletChanged(address _botWalletAccount);
1275 
1276     /// @notice Event emitted when burn address changes
1277     event burnAddressChanged(address _newBurnAddress);
1278 
1279     /// @notice Event emitted when transfer stone token with fee
1280     event transferWithTax(
1281         address _sender,
1282         address _recipient,
1283         uint256 amount,
1284         uint256 _burnAmount
1285     );
1286 
1287     address public burnWallet = 0xd26Cc7C8D96F6Ca5291758d266447f6879A66E16;
1288     uint256 internal constant maxSupply = 10**33;
1289     mapping(address => bool) public taxFree;
1290     mapping(address => bool) public sizeFree;
1291     mapping(address => bool) public blacklistWallet;
1292     mapping(address => bool) public botWallet;
1293     uint256 public taxRate = 9999; // basis points, 10000 is 100%; start high for anti-sniping
1294     uint256 public botTaxRate = 900; // 9% bot tax
1295 
1296     /**
1297      * @dev Constructor
1298      */
1299     constructor() ERC20("Stone", "0NE") {
1300         _mint(_msgSender(), 2 * 10**32);
1301         taxFree[_msgSender()] = true;
1302         sizeFree[_msgSender()] = true;
1303     }
1304 
1305     /**
1306      * @dev External function to set tax Rate
1307      * @param _taxRate New tax Rate in basis points
1308      */
1309     function setTaxRate(uint256 _taxRate) external onlyOwner {
1310         require(_taxRate >= 0, "TaxRate above zero");
1311         require(_taxRate <= 10000, "TaxRate below max");
1312 
1313         taxRate = _taxRate;
1314         emit taxChanged(_taxRate);
1315     }
1316 
1317     /**
1318      * @dev External function to set bot tax Rate
1319      * @param _botTaxRate New tax Rate in basis points
1320      */
1321     function setBotRate(uint256 _botTaxRate) external onlyOwner {
1322         require(_botTaxRate >= 0, "TaxRate above zero");
1323         require(_botTaxRate <= 10000, "TaxRate below max");
1324 
1325         botTaxRate = _botTaxRate;
1326         emit botTaxChanged(_botTaxRate);
1327     }
1328 
1329     /**
1330      * @dev Add or remove tax free accounts
1331      * @param _account target address to set or remove from the tax free account list
1332      */
1333     function setTaxFree(address _account) external onlyOwner {
1334         if (taxFree[_account]) {
1335             delete taxFree[_account];
1336         } else {
1337             taxFree[_account] = true;
1338         }
1339 
1340         emit taxFreeChanged(_account);
1341     }
1342 
1343     /**
1344      * @dev Add or remove size free accounts
1345      * @param _account target address to set or remove from the size free account list
1346      */
1347     function setSizeFree(address _account) external onlyOwner {
1348         if (sizeFree[_account]) {
1349             delete sizeFree[_account];
1350         } else {
1351             sizeFree[_account] = true;
1352         }
1353 
1354         emit sizeFreeChanged(_account);
1355     }
1356 
1357     /**
1358      * @dev Add or remove blacklist wallet accounts
1359      * @param _account target address to set or remove from the blacklist account list
1360      */
1361     function setBlacklistWallet(address _account) external onlyOwner {
1362         if (blacklistWallet[_account]) {
1363             delete blacklistWallet[_account];
1364         } else {
1365             blacklistWallet[_account] = true;
1366         }
1367 
1368         emit blacklistWalletChanged(_account);
1369     }
1370 
1371     /**
1372      * @dev Add or remove bot wallet accounts
1373      * @param _account target address to set or remove from the bot account list
1374      */
1375     function setBotWallet(address _account) external onlyOwner {
1376         if (botWallet[_account]) {
1377             delete botWallet[_account];
1378         } else {
1379             botWallet[_account] = true;
1380         }
1381 
1382         emit botWalletChanged(_account);
1383     }
1384 
1385     /**
1386      * @dev Custom transfer function
1387      * @param sender Sender address
1388      * @param recipient Recipient address
1389      * @param amount Amount to transfer
1390      */
1391     function _transfer(
1392         address sender,
1393         address recipient,
1394         uint256 amount
1395     ) internal override whenNotPaused {
1396         require(balanceOf(sender) >= amount, "Not enough tokens");
1397 
1398         //black listed wallets are not welcome, sorry!
1399         require(
1400             !blacklistWallet[sender] && !blacklistWallet[recipient],
1401             "Not welcome!"
1402         );
1403 
1404         if (!sizeFree[recipient]) {
1405             require(
1406                 balanceOf(recipient).add(amount) <= 3 * 10**31,
1407                 "Transfer exceeds max wallet"
1408             ); //3% max
1409         }
1410 
1411         //bots pay higher tax, sorry!
1412         uint256 _taxApplied = (botWallet[sender] || botWallet[recipient])
1413             ? botTaxRate
1414             : taxRate;
1415 
1416         //Divide by 20000 for the 50-50% split
1417         uint256 _burnAmount = (taxFree[sender] || taxFree[recipient])
1418             ? 0
1419             : FullMath.mulDiv(amount, _taxApplied, 20000);
1420 
1421         if (_burnAmount > 0) {
1422             _burn(sender, _burnAmount); //burn Stone
1423             ERC20._transfer(sender, burnWallet, _burnAmount); //burn Civ to dedicated wallet
1424         }
1425 
1426         ERC20._transfer(sender, recipient, amount - (_burnAmount.mul(2))); //then transfer
1427 
1428         emit transferWithTax(sender, recipient, amount, _burnAmount);
1429     }
1430 
1431     /**
1432      * @dev Set burn address
1433      * @param _burnAddress New burn address
1434      */
1435     function setBurnAddress(address _burnAddress) external onlyOwner {
1436         burnWallet = _burnAddress;
1437         emit burnAddressChanged(burnWallet);
1438     }
1439 
1440     /**
1441      * @dev Mint new stone tokens
1442      * @param count Amount to mint
1443      */
1444     function mintToken(uint256 count) external onlyOwner {
1445         require(totalSupply() + count <= maxSupply, "Mint above maxSupply");
1446         _mint(_msgSender(), count);
1447     }
1448 
1449     function pause() external onlyOwner {
1450         _pause();
1451     }
1452 
1453     function unpause() external onlyOwner {
1454         _unpause();
1455     }
1456 
1457     /* Just in case anyone sends tokens by accident to this contract */
1458 
1459     /// @notice Transfers ETH to the recipient address
1460     /// @dev Fails with `STE`
1461     /// @param to The destination of the transfer
1462     /// @param value The value to be transferred
1463     function safeTransferETH(address to, uint256 value) internal {
1464         (bool success, ) = to.call{value: value}(new bytes(0));
1465         require(success, "STE");
1466     }
1467 
1468     function withdrawETH() external payable onlyOwner {
1469         safeTransferETH(_msgSender(), address(this).balance);
1470     }
1471 
1472     function withdrawERC20(IERC20 _tokenContract) external onlyOwner {
1473         _tokenContract.safeTransfer(
1474             _msgSender(),
1475             _tokenContract.balanceOf(address(this))
1476         );
1477     }
1478 
1479     /**
1480      * @dev allow the contract to receive ETH
1481      * without payable fallback and receive, it would fail
1482      */
1483     fallback() external payable {}
1484 
1485     receive() external payable {}
1486 }