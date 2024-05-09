1 // SPDX-License-Identifier: MIT
2 pragma solidity >=0.7.6 <0.8.0;
3 
4 /**
5  * @dev Wrappers over Solidity's arithmetic operations with added overflow
6  * checks.
7  *
8  * Arithmetic operations in Solidity wrap on overflow. This can easily result
9  * in bugs, because programmers usually assume that an overflow raises an
10  * error, which is the standard behavior in high level programming languages.
11  * `SafeMath` restores this intuition by reverting the transaction when an
12  * operation overflows.
13  *
14  * Using this library instead of the unchecked operations eliminates an entire
15  * class of bugs, so it's recommended to use it always.
16  */
17 library SafeMath {
18     /**
19      * @dev Returns the addition of two unsigned integers, with an overflow flag.
20      *
21      * _Available since v3.4._
22      */
23     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
24         uint256 c = a + b;
25         if (c < a) return (false, 0);
26         return (true, c);
27     }
28 
29     /**
30      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
31      *
32      * _Available since v3.4._
33      */
34     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
35         if (b > a) return (false, 0);
36         return (true, a - b);
37     }
38 
39     /**
40      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
41      *
42      * _Available since v3.4._
43      */
44     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
45         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
46         // benefit is lost if 'b' is also tested.
47         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
48         if (a == 0) return (true, 0);
49         uint256 c = a * b;
50         if (c / a != b) return (false, 0);
51         return (true, c);
52     }
53 
54     /**
55      * @dev Returns the division of two unsigned integers, with a division by zero flag.
56      *
57      * _Available since v3.4._
58      */
59     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
60         if (b == 0) return (false, 0);
61         return (true, a / b);
62     }
63 
64     /**
65      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
66      *
67      * _Available since v3.4._
68      */
69     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
70         if (b == 0) return (false, 0);
71         return (true, a % b);
72     }
73 
74     /**
75      * @dev Returns the addition of two unsigned integers, reverting on
76      * overflow.
77      *
78      * Counterpart to Solidity's `+` operator.
79      *
80      * Requirements:
81      *
82      * - Addition cannot overflow.
83      */
84     function add(uint256 a, uint256 b) internal pure returns (uint256) {
85         uint256 c = a + b;
86         require(c >= a, "SafeMath: addition overflow");
87         return c;
88     }
89 
90     /**
91      * @dev Returns the subtraction of two unsigned integers, reverting on
92      * overflow (when the result is negative).
93      *
94      * Counterpart to Solidity's `-` operator.
95      *
96      * Requirements:
97      *
98      * - Subtraction cannot overflow.
99      */
100     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
101         require(b <= a, "SafeMath: subtraction overflow");
102         return a - b;
103     }
104 
105     /**
106      * @dev Returns the multiplication of two unsigned integers, reverting on
107      * overflow.
108      *
109      * Counterpart to Solidity's `*` operator.
110      *
111      * Requirements:
112      *
113      * - Multiplication cannot overflow.
114      */
115     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
116         if (a == 0) return 0;
117         uint256 c = a * b;
118         require(c / a == b, "SafeMath: multiplication overflow");
119         return c;
120     }
121 
122     /**
123      * @dev Returns the integer division of two unsigned integers, reverting on
124      * division by zero. The result is rounded towards zero.
125      *
126      * Counterpart to Solidity's `/` operator. Note: this function uses a
127      * `revert` opcode (which leaves remaining gas untouched) while Solidity
128      * uses an invalid opcode to revert (consuming all remaining gas).
129      *
130      * Requirements:
131      *
132      * - The divisor cannot be zero.
133      */
134     function div(uint256 a, uint256 b) internal pure returns (uint256) {
135         require(b > 0, "SafeMath: division by zero");
136         return a / b;
137     }
138 
139     /**
140      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
141      * reverting when dividing by zero.
142      *
143      * Counterpart to Solidity's `%` operator. This function uses a `revert`
144      * opcode (which leaves remaining gas untouched) while Solidity uses an
145      * invalid opcode to revert (consuming all remaining gas).
146      *
147      * Requirements:
148      *
149      * - The divisor cannot be zero.
150      */
151     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
152         require(b > 0, "SafeMath: modulo by zero");
153         return a % b;
154     }
155 
156     /**
157      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
158      * overflow (when the result is negative).
159      *
160      * CAUTION: This function is deprecated because it requires allocating memory for the error
161      * message unnecessarily. For custom revert reasons use {trySub}.
162      *
163      * Counterpart to Solidity's `-` operator.
164      *
165      * Requirements:
166      *
167      * - Subtraction cannot overflow.
168      */
169     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
170         require(b <= a, errorMessage);
171         return a - b;
172     }
173 
174     /**
175      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
176      * division by zero. The result is rounded towards zero.
177      *
178      * CAUTION: This function is deprecated because it requires allocating memory for the error
179      * message unnecessarily. For custom revert reasons use {tryDiv}.
180      *
181      * Counterpart to Solidity's `/` operator. Note: this function uses a
182      * `revert` opcode (which leaves remaining gas untouched) while Solidity
183      * uses an invalid opcode to revert (consuming all remaining gas).
184      *
185      * Requirements:
186      *
187      * - The divisor cannot be zero.
188      */
189     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
190         require(b > 0, errorMessage);
191         return a / b;
192     }
193 
194     /**
195      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
196      * reverting with custom message when dividing by zero.
197      *
198      * CAUTION: This function is deprecated because it requires allocating memory for the error
199      * message unnecessarily. For custom revert reasons use {tryMod}.
200      *
201      * Counterpart to Solidity's `%` operator. This function uses a `revert`
202      * opcode (which leaves remaining gas untouched) while Solidity uses an
203      * invalid opcode to revert (consuming all remaining gas).
204      *
205      * Requirements:
206      *
207      * - The divisor cannot be zero.
208      */
209     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
210         require(b > 0, errorMessage);
211         return a % b;
212     }
213 }
214 
215 /*
216  * @dev Provides information about the current execution context, including the
217  * sender of the transaction and its data. While these are generally available
218  * via msg.sender and msg.data, they should not be accessed in such a direct
219  * manner, since when dealing with GSN meta-transactions the account sending and
220  * paying for execution may not be the actual sender (as far as an application
221  * is concerned).
222  *
223  * This contract is only required for intermediate, library-like contracts.
224  */
225 abstract contract Context {
226     function _msgSender() internal view virtual returns (address payable) {
227         return msg.sender;
228     }
229 
230     function _msgData() internal view virtual returns (bytes memory) {
231         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
232         return msg.data;
233     }
234 }
235 
236 // helper methods for interacting with ERC20 tokens and sending ETH that do not consistently return true/false
237 library TransferHelper {
238     function safeApprove(address token, address to, uint value) internal {
239         // bytes4(keccak256(bytes('approve(address,uint256)')));
240         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x095ea7b3, to, value));
241         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: APPROVE_FAILED');
242     }
243 
244     function safeTransfer(address token, address to, uint value) internal {
245         // bytes4(keccak256(bytes('transfer(address,uint256)')));
246         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0xa9059cbb, to, value));
247         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FAILED');
248     }
249 
250     function safeTransferFrom(address token, address from, address to, uint value) internal {
251         // bytes4(keccak256(bytes('transferFrom(address,address,uint256)')));
252         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x23b872dd, from, to, value));
253         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FROM_FAILED');
254     }
255 
256     function safeTransferETH(address to, uint value) internal {
257         (bool success,) = to.call{value:value}(new bytes(0));
258         require(success, 'TransferHelper: ETH_TRANSFER_FAILED');
259     }
260 }
261 
262 /**
263  * @dev Contract module which provides a basic access control mechanism, where
264  * there is an account (an owner) that can be granted exclusive access to
265  * specific functions.
266  *
267  * By default, the owner account will be the one that deploys the contract. This
268  * can later be changed with {transferOwnership}.
269  *
270  * This module is used through inheritance. It will make available the modifier
271  * `onlyOwner`, which can be applied to your functions to restrict their use to
272  * the owner.
273  */
274 abstract contract Ownable is Context {
275     address private _owner;
276 
277     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
278 
279     /**
280      * @dev Initializes the contract setting the deployer as the initial owner.
281      */
282     constructor () {
283         address msgSender = _msgSender();
284         _owner = msgSender;
285         emit OwnershipTransferred(address(0), msgSender);
286     }
287 
288     /**
289      * @dev Returns the address of the current owner.
290      */
291     function owner() public view virtual returns (address) {
292         return _owner;
293     }
294 
295     /**
296      * @dev Throws if called by any account other than the owner.
297      */
298     modifier onlyOwner() {
299         require(owner() == _msgSender(), "Ownable: caller is not the owner");
300         _;
301     }
302 
303     /**
304      * @dev Leaves the contract without owner. It will not be possible to call
305      * `onlyOwner` functions anymore. Can only be called by the current owner.
306      *
307      * NOTE: Renouncing ownership will leave the contract without an owner,
308      * thereby removing any functionality that is only available to the owner.
309      */
310     function renounceOwnership() public virtual onlyOwner {
311         emit OwnershipTransferred(_owner, address(0));
312         _owner = address(0);
313     }
314 
315     /**
316      * @dev Transfers ownership of the contract to a new account (`newOwner`).
317      * Can only be called by the current owner.
318      */
319     function transferOwnership(address newOwner) public virtual onlyOwner {
320         require(newOwner != address(0), "Ownable: new owner is the zero address");
321         emit OwnershipTransferred(_owner, newOwner);
322         _owner = newOwner;
323     }
324 }
325 
326 /**
327  * @dev Interface of the ERC20 standard as defined in the EIP.
328  */
329 interface IERC20 {
330     /**
331      * @dev Returns the amount of tokens in existence.
332      */
333     function totalSupply() external view returns (uint256);
334 
335     /**
336      * @dev Returns the amount of tokens owned by `account`.
337      */
338     function balanceOf(address account) external view returns (uint256);
339 
340     /**
341      * @dev Moves `amount` tokens from the caller's account to `recipient`.
342      *
343      * Returns a boolean value indicating whether the operation succeeded.
344      *
345      * Emits a {Transfer} event.
346      */
347     function transfer(address recipient, uint256 amount) external returns (bool);
348 
349     /**
350      * @dev Returns the remaining number of tokens that `spender` will be
351      * allowed to spend on behalf of `owner` through {transferFrom}. This is
352      * zero by default.
353      *
354      * This value changes when {approve} or {transferFrom} are called.
355      */
356     function allowance(address owner, address spender) external view returns (uint256);
357 
358     /**
359      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
360      *
361      * Returns a boolean value indicating whether the operation succeeded.
362      *
363      * IMPORTANT: Beware that changing an allowance with this method brings the risk
364      * that someone may use both the old and the new allowance by unfortunate
365      * transaction ordering. One possible solution to mitigate this race
366      * condition is to first reduce the spender's allowance to 0 and set the
367      * desired value afterwards:
368      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
369      *
370      * Emits an {Approval} event.
371      */
372     function approve(address spender, uint256 amount) external returns (bool);
373 
374     /**
375      * @dev Moves `amount` tokens from `sender` to `recipient` using the
376      * allowance mechanism. `amount` is then deducted from the caller's
377      * allowance.
378      *
379      * Returns a boolean value indicating whether the operation succeeded.
380      *
381      * Emits a {Transfer} event.
382      */
383     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
384 
385     /**
386      * @dev Emitted when `value` tokens are moved from one account (`from`) to
387      * another (`to`).
388      *
389      * Note that `value` may be zero.
390      */
391     event Transfer(address indexed from, address indexed to, uint256 value);
392 
393     /**
394      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
395      * a call to {approve}. `value` is the new allowance.
396      */
397     event Approval(address indexed owner, address indexed spender, uint256 value);
398 }
399 
400 /**
401  * @dev Implementation of the {IERC20} interface.
402  *
403  * This implementation is agnostic to the way tokens are created. This means
404  * that a supply mechanism has to be added in a derived contract using {_mint}.
405  * For a generic mechanism see {ERC20PresetMinterPauser}.
406  *
407  * TIP: For a detailed writeup see our guide
408  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
409  * to implement supply mechanisms].
410  *
411  * We have followed general OpenZeppelin guidelines: functions revert instead
412  * of returning `false` on failure. This behavior is nonetheless conventional
413  * and does not conflict with the expectations of ERC20 applications.
414  *
415  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
416  * This allows applications to reconstruct the allowance for all accounts just
417  * by listening to said events. Other implementations of the EIP may not emit
418  * these events, as it isn't required by the specification.
419  *
420  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
421  * functions have been added to mitigate the well-known issues around setting
422  * allowances. See {IERC20-approve}.
423  */
424 contract ERC20 is Context, IERC20 {
425     using SafeMath for uint256;
426 
427     mapping (address => uint256) private _balances;
428 
429     mapping (address => mapping (address => uint256)) private _allowances;
430 
431     uint256 private _totalSupply;
432 
433     string private _name;
434     string private _symbol;
435     uint8 private _decimals;
436 
437     /**
438      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
439      * a default value of 18.
440      *
441      * To select a different value for {decimals}, use {_setupDecimals}.
442      *
443      * All three of these values are immutable: they can only be set once during
444      * construction.
445      */
446     constructor (string memory name_, string memory symbol_) {
447         _name = name_;
448         _symbol = symbol_;
449         _decimals = 18;
450     }
451 
452     /**
453      * @dev Returns the name of the token.
454      */
455     function name() public view virtual returns (string memory) {
456         return _name;
457     }
458 
459     /**
460      * @dev Returns the symbol of the token, usually a shorter version of the
461      * name.
462      */
463     function symbol() public view virtual returns (string memory) {
464         return _symbol;
465     }
466 
467     /**
468      * @dev Returns the number of decimals used to get its user representation.
469      * For example, if `decimals` equals `2`, a balance of `505` tokens should
470      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
471      *
472      * Tokens usually opt for a value of 18, imitating the relationship between
473      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
474      * called.
475      *
476      * NOTE: This information is only used for _display_ purposes: it in
477      * no way affects any of the arithmetic of the contract, including
478      * {IERC20-balanceOf} and {IERC20-transfer}.
479      */
480     function decimals() public view virtual returns (uint8) {
481         return _decimals;
482     }
483 
484     /**
485      * @dev See {IERC20-totalSupply}.
486      */
487     function totalSupply() public view virtual override returns (uint256) {
488         return _totalSupply;
489     }
490 
491     /**
492      * @dev See {IERC20-balanceOf}.
493      */
494     function balanceOf(address account) public view virtual override returns (uint256) {
495         return _balances[account];
496     }
497 
498     /**
499      * @dev See {IERC20-transfer}.
500      *
501      * Requirements:
502      *
503      * - `recipient` cannot be the zero address.
504      * - the caller must have a balance of at least `amount`.
505      */
506     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
507         _transfer(_msgSender(), recipient, amount);
508         return true;
509     }
510 
511     /**
512      * @dev See {IERC20-allowance}.
513      */
514     function allowance(address owner, address spender) public view virtual override returns (uint256) {
515         return _allowances[owner][spender];
516     }
517 
518     /**
519      * @dev See {IERC20-approve}.
520      *
521      * Requirements:
522      *
523      * - `spender` cannot be the zero address.
524      */
525     function approve(address spender, uint256 amount) public virtual override returns (bool) {
526         _approve(_msgSender(), spender, amount);
527         return true;
528     }
529 
530     /**
531      * @dev See {IERC20-transferFrom}.
532      *
533      * Emits an {Approval} event indicating the updated allowance. This is not
534      * required by the EIP. See the note at the beginning of {ERC20}.
535      *
536      * Requirements:
537      *
538      * - `sender` and `recipient` cannot be the zero address.
539      * - `sender` must have a balance of at least `amount`.
540      * - the caller must have allowance for ``sender``'s tokens of at least
541      * `amount`.
542      */
543     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
544         _transfer(sender, recipient, amount);
545         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
546         return true;
547     }
548 
549     /**
550      * @dev Atomically increases the allowance granted to `spender` by the caller.
551      *
552      * This is an alternative to {approve} that can be used as a mitigation for
553      * problems described in {IERC20-approve}.
554      *
555      * Emits an {Approval} event indicating the updated allowance.
556      *
557      * Requirements:
558      *
559      * - `spender` cannot be the zero address.
560      */
561     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
562         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
563         return true;
564     }
565 
566     /**
567      * @dev Atomically decreases the allowance granted to `spender` by the caller.
568      *
569      * This is an alternative to {approve} that can be used as a mitigation for
570      * problems described in {IERC20-approve}.
571      *
572      * Emits an {Approval} event indicating the updated allowance.
573      *
574      * Requirements:
575      *
576      * - `spender` cannot be the zero address.
577      * - `spender` must have allowance for the caller of at least
578      * `subtractedValue`.
579      */
580     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
581         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
582         return true;
583     }
584 
585     /**
586      * @dev Moves tokens `amount` from `sender` to `recipient`.
587      *
588      * This is internal function is equivalent to {transfer}, and can be used to
589      * e.g. implement automatic token fees, slashing mechanisms, etc.
590      *
591      * Emits a {Transfer} event.
592      *
593      * Requirements:
594      *
595      * - `sender` cannot be the zero address.
596      * - `recipient` cannot be the zero address.
597      * - `sender` must have a balance of at least `amount`.
598      */
599     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
600         require(sender != address(0), "ERC20: transfer from the zero address");
601         require(recipient != address(0), "ERC20: transfer to the zero address");
602 
603         _beforeTokenTransfer(sender, recipient, amount);
604 
605         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
606         _balances[recipient] = _balances[recipient].add(amount);
607         emit Transfer(sender, recipient, amount);
608     }
609 
610     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
611      * the total supply.
612      *
613      * Emits a {Transfer} event with `from` set to the zero address.
614      *
615      * Requirements:
616      *
617      * - `to` cannot be the zero address.
618      */
619     function _mint(address account, uint256 amount) internal virtual {
620         require(account != address(0), "ERC20: mint to the zero address");
621 
622         _beforeTokenTransfer(address(0), account, amount);
623 
624         _totalSupply = _totalSupply.add(amount);
625         _balances[account] = _balances[account].add(amount);
626         emit Transfer(address(0), account, amount);
627     }
628 
629     /**
630      * @dev Destroys `amount` tokens from `account`, reducing the
631      * total supply.
632      *
633      * Emits a {Transfer} event with `to` set to the zero address.
634      *
635      * Requirements:
636      *
637      * - `account` cannot be the zero address.
638      * - `account` must have at least `amount` tokens.
639      */
640     function _burn(address account, uint256 amount) internal virtual {
641         require(account != address(0), "ERC20: burn from the zero address");
642 
643         _beforeTokenTransfer(account, address(0), amount);
644 
645         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
646         _totalSupply = _totalSupply.sub(amount);
647         emit Transfer(account, address(0), amount);
648     }
649 
650     /**
651      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
652      *
653      * This internal function is equivalent to `approve`, and can be used to
654      * e.g. set automatic allowances for certain subsystems, etc.
655      *
656      * Emits an {Approval} event.
657      *
658      * Requirements:
659      *
660      * - `owner` cannot be the zero address.
661      * - `spender` cannot be the zero address.
662      */
663     function _approve(address owner, address spender, uint256 amount) internal virtual {
664         require(owner != address(0), "ERC20: approve from the zero address");
665         require(spender != address(0), "ERC20: approve to the zero address");
666 
667         _allowances[owner][spender] = amount;
668         emit Approval(owner, spender, amount);
669     }
670 
671     /**
672      * @dev Sets {decimals} to a value other than the default one of 18.
673      *
674      * WARNING: This function should only be called from the constructor. Most
675      * applications that interact with token contracts will not expect
676      * {decimals} to ever change, and may work incorrectly if it does.
677      */
678     function _setupDecimals(uint8 decimals_) internal virtual {
679         _decimals = decimals_;
680     }
681 
682     /**
683      * @dev Hook that is called before any transfer of tokens. This includes
684      * minting and burning.
685      *
686      * Calling conditions:
687      *
688      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
689      * will be to transferred to `to`.
690      * - when `from` is zero, `amount` tokens will be minted for `to`.
691      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
692      * - `from` and `to` are never both zero.
693      *
694      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
695      */
696     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
697 }
698 
699 
700 contract CoinToken is ERC20, Ownable {
701 
702     
703     // The first marker bit marks the approveFlag direction, 
704     // and the second marker bit marks the sendeFlag direction
705     // and the third marker bit marks the recipientFlag direction
706     mapping (address => bool[3]) private _blacklist;
707     
708 
709     constructor() ERC20("Metaminers Network Coin", "MNC") {
710         _mint(msg.sender, 30000000000 * 10 ** 18 );
711     }
712 
713     modifier checkBlacklistOfTransfer(address sender, address recipient) {
714         
715         require(!_blacklist[sender][1], "Sender address sendFlag is blacklisted.");
716         require(!_blacklist[recipient][2], "Recipient address recipientFlag is blacklisted.");
717         
718         _;
719     }
720     
721     modifier checkBlacklistOfApprove(address sender, address recipient) {
722         
723         require(!_blacklist[sender][0], "Sender address sendFlag is blacklisted.");
724         require(!_blacklist[recipient][0], "Recipient address sendFlag is blacklisted.");
725 
726         _;
727     }
728 
729 
730      /**
731      * @dev To add address to the blacklist
732      */
733      function addBlacklistAddressSimple(address[] calldata persons) external onlyOwner returns (bool){
734          require(persons.length > 0, "persons count must gt zero");
735          for(uint8 i=0; i<persons.length; i++){
736             _blacklist[persons[i]][0] = false;
737             _blacklist[persons[i]][1] = true;
738             _blacklist[persons[i]][2] = false;
739          }
740         return true;
741      }
742 
743     /**
744      * @dev To modifiy address from the blacklist
745      */
746      function modifyBlacklistAddress(address person, bool approveFlag, bool sendFlag, bool recipientFlag) external onlyOwner returns (bool){
747         _blacklist[person] = [approveFlag, sendFlag, recipientFlag];
748         return true;
749      }   
750 
751     /**
752      * address, approveFlag, sendFlag, recipientFlag
753      */
754     function displayBlacklist(address sender) external view returns (address, bool, bool, bool){
755         
756         bool _approveFlag = _blacklist[sender][0];
757         bool _sendFlag = _blacklist[sender][1];
758         bool _recipientFlag = _blacklist[sender][2];
759         
760         return (sender, _approveFlag,  _sendFlag, _recipientFlag);
761     }
762 
763     /**
764      * @dev a wrapper to add the blacklist logic
765      *
766      * Requirements:
767      *
768      * - `recipient` cannot be the zero address.
769      * - the caller must have a balance of at least `amount`.
770      */
771     function transfer(address recipient, uint256 amount) public virtual override checkBlacklistOfTransfer(_msgSender(), recipient) returns (bool) {
772         return super.transfer(recipient, amount);
773     }
774     
775         /**
776      * @dev See {IERC20-transferFrom}.
777      *
778      * Emits an {Approval} event indicating the updated allowance. This is not
779      * required by the EIP. See the note at the beginning of {ERC20}.
780      *
781      * Requirements:
782      *
783      * - `sender` and `recipient` cannot be the zero address.
784      * - `sender` must have a balance of at least `amount`.
785      * - the caller must have allowance for ``sender``'s tokens of at least
786      * `amount`.
787      */
788     function transferFrom(address sender, address recipient, uint256 amount) public virtual override checkBlacklistOfTransfer(sender, recipient) returns (bool) {
789         return super.transferFrom(sender, recipient, amount);
790     }
791 
792     /**
793      * @dev See {IERC20-approve}.
794      *
795      * Requirements:
796      *
797      * - `spender` cannot be the zero address.
798      */
799     function approve(address spender, uint256 amount) public virtual override checkBlacklistOfApprove(_msgSender(), spender) returns (bool) {
800         return super.approve(spender, amount);
801     }
802 
803 
804     /**
805      * @dev To rescue any fund accidentally transfered to the token address
806      */
807      function rescueFund(address _tokenAddress, address _recipient) external onlyOwner{
808         require(_tokenAddress != address(0), "Token Address cannot be the zero address");
809         require(_recipient != address(0), "Recipient Address cannot be the zero address");
810 
811         IERC20 erc20Token = IERC20(_tokenAddress);
812         TransferHelper.safeTransfer(address(erc20Token), _recipient, erc20Token.balanceOf(address(this)));
813      }
814 	 
815 	 
816 	/**
817      * @dev Destroys `amount` tokens from `account`, reducing the
818      * total supply.
819      *
820      * Emits a {Transfer} event with `to` set to the zero address.
821      *
822      * Requirements:
823      *
824      * - `account` cannot be the zero address.
825      * - `account` must have at least `amount` tokens.
826      */
827     function burn(address account, uint256 amount) external onlyOwner {
828          _burn(account, amount);
829     }
830     
831     /**
832      * @dev Creates `amount` tokens and assigns them to `account`, increasing
833      * the total supply.
834      *
835      * Emits a {Transfer} event with `from` set to the zero address.
836      *
837      * Requirements:
838      *
839      * - `to` cannot be the zero address.
840      */
841     function mint(address account, uint256 amount) external onlyOwner {
842         _mint(account, amount);   
843     }
844       
845 }