1 /*
2  * @dev Provides information about the current execution context, including the
3  * sender of the transaction and its data. While these are generally available
4  * via msg.sender and msg.data, they should not be accessed in such a direct
5  * manner, since when dealing with GSN meta-transactions the account sending and
6  * paying for execution may not be the actual sender (as far as an application
7  * is concerned).
8  *
9  * This contract is only required for intermediate, library-like contracts.
10  */
11 abstract contract Context {
12     function _msgSender() internal view virtual returns (address payable) {
13         return msg.sender;
14     }
15 
16     function _msgData() internal view virtual returns (bytes memory) {
17         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
18         return msg.data;
19     }
20 }
21 
22 /**
23  * @dev Interface of the ERC20 standard as defined in the EIP.
24  */
25 interface IERC20 {
26     /**
27      * @dev Returns the amount of tokens in existence.
28      */
29     function totalSupply() external view returns (uint256);
30 
31     /**
32      * @dev Returns the amount of tokens owned by `account`.
33      */
34     function balanceOf(address account) external view returns (uint256);
35 
36     /**
37      * @dev Moves `amount` tokens from the caller's account to `recipient`.
38      *
39      * Returns a boolean value indicating whether the operation succeeded.
40      *
41      * Emits a {Transfer} event.
42      */
43     function transfer(address recipient, uint256 amount) external returns (bool);
44 
45     /**
46      * @dev Returns the remaining number of tokens that `spender` will be
47      * allowed to spend on behalf of `owner` through {transferFrom}. This is
48      * zero by default.
49      *
50      * This value changes when {approve} or {transferFrom} are called.
51      */
52     function allowance(address owner, address spender) external view returns (uint256);
53 
54     /**
55      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
56      *
57      * Returns a boolean value indicating whether the operation succeeded.
58      *
59      * IMPORTANT: Beware that changing an allowance with this method brings the risk
60      * that someone may use both the old and the new allowance by unfortunate
61      * transaction ordering. One possible solution to mitigate this race
62      * condition is to first reduce the spender's allowance to 0 and set the
63      * desired value afterwards:
64      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
65      *
66      * Emits an {Approval} event.
67      */
68     function approve(address spender, uint256 amount) external returns (bool);
69 
70     /**
71      * @dev Moves `amount` tokens from `sender` to `recipient` using the
72      * allowance mechanism. `amount` is then deducted from the caller's
73      * allowance.
74      *
75      * Returns a boolean value indicating whether the operation succeeded.
76      *
77      * Emits a {Transfer} event.
78      */
79     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
80 
81     /**
82      * @dev Emitted when `value` tokens are moved from one account (`from`) to
83      * another (`to`).
84      *
85      * Note that `value` may be zero.
86      */
87     event Transfer(address indexed from, address indexed to, uint256 value);
88 
89     /**
90      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
91      * a call to {approve}. `value` is the new allowance.
92      */
93     event Approval(address indexed owner, address indexed spender, uint256 value);
94 }
95 /**
96  * @dev Wrappers over Solidity's arithmetic operations with added overflow
97  * checks.
98  *
99  * Arithmetic operations in Solidity wrap on overflow. This can easily result
100  * in bugs, because programmers usually assume that an overflow raises an
101  * error, which is the standard behavior in high level programming languages.
102  * `SafeMath` restores this intuition by reverting the transaction when an
103  * operation overflows.
104  *
105  * Using this library instead of the unchecked operations eliminates an entire
106  * class of bugs, so it's recommended to use it always.
107  */
108 library SafeMath {
109     /**
110      * @dev Returns the addition of two unsigned integers, reverting on
111      * overflow.
112      *
113      * Counterpart to Solidity's `+` operator.
114      *
115      * Requirements:
116      *
117      * - Addition cannot overflow.
118      */
119     function add(uint256 a, uint256 b) internal pure returns (uint256) {
120         uint256 c = a + b;
121         require(c >= a, "SafeMath: addition overflow");
122 
123         return c;
124     }
125 
126     /**
127      * @dev Returns the subtraction of two unsigned integers, reverting on
128      * overflow (when the result is negative).
129      *
130      * Counterpart to Solidity's `-` operator.
131      *
132      * Requirements:
133      *
134      * - Subtraction cannot overflow.
135      */
136     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
137         return sub(a, b, "SafeMath: subtraction overflow");
138     }
139 
140     /**
141      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
142      * overflow (when the result is negative).
143      *
144      * Counterpart to Solidity's `-` operator.
145      *
146      * Requirements:
147      *
148      * - Subtraction cannot overflow.
149      */
150     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
151         require(b <= a, errorMessage);
152         uint256 c = a - b;
153 
154         return c;
155     }
156 
157     /**
158      * @dev Returns the multiplication of two unsigned integers, reverting on
159      * overflow.
160      *
161      * Counterpart to Solidity's `*` operator.
162      *
163      * Requirements:
164      *
165      * - Multiplication cannot overflow.
166      */
167     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
168         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
169         // benefit is lost if 'b' is also tested.
170         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
171         if (a == 0) {
172             return 0;
173         }
174 
175         uint256 c = a * b;
176         require(c / a == b, "SafeMath: multiplication overflow");
177 
178         return c;
179     }
180 
181     /**
182      * @dev Returns the integer division of two unsigned integers. Reverts on
183      * division by zero. The result is rounded towards zero.
184      *
185      * Counterpart to Solidity's `/` operator. Note: this function uses a
186      * `revert` opcode (which leaves remaining gas untouched) while Solidity
187      * uses an invalid opcode to revert (consuming all remaining gas).
188      *
189      * Requirements:
190      *
191      * - The divisor cannot be zero.
192      */
193     function div(uint256 a, uint256 b) internal pure returns (uint256) {
194         return div(a, b, "SafeMath: division by zero");
195     }
196 
197     /**
198      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
199      * division by zero. The result is rounded towards zero.
200      *
201      * Counterpart to Solidity's `/` operator. Note: this function uses a
202      * `revert` opcode (which leaves remaining gas untouched) while Solidity
203      * uses an invalid opcode to revert (consuming all remaining gas).
204      *
205      * Requirements:
206      *
207      * - The divisor cannot be zero.
208      */
209     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
210         require(b > 0, errorMessage);
211         uint256 c = a / b;
212         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
213 
214         return c;
215     }
216 
217     /**
218      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
219      * Reverts when dividing by zero.
220      *
221      * Counterpart to Solidity's `%` operator. This function uses a `revert`
222      * opcode (which leaves remaining gas untouched) while Solidity uses an
223      * invalid opcode to revert (consuming all remaining gas).
224      *
225      * Requirements:
226      *
227      * - The divisor cannot be zero.
228      */
229     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
230         return mod(a, b, "SafeMath: modulo by zero");
231     }
232 
233     /**
234      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
235      * Reverts with custom message when dividing by zero.
236      *
237      * Counterpart to Solidity's `%` operator. This function uses a `revert`
238      * opcode (which leaves remaining gas untouched) while Solidity uses an
239      * invalid opcode to revert (consuming all remaining gas).
240      *
241      * Requirements:
242      *
243      * - The divisor cannot be zero.
244      */
245     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
246         require(b != 0, errorMessage);
247         return a % b;
248     }
249 }
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
261  * We have followed general OpenZeppelin guidelines: functions revert instead
262  * of returning `false` on failure. This behavior is nonetheless conventional
263  * and does not conflict with the expectations of ERC20 applications.
264  *
265  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
266  * This allows applications to reconstruct the allowance for all accounts just
267  * by listening to said events. Other implementations of the EIP may not emit
268  * these events, as it isn't required by the specification.
269  *
270  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
271  * functions have been added to mitigate the well-known issues around setting
272  * allowances. See {IERC20-approve}.
273  */
274 contract ERC20 is Context, IERC20 {
275     using SafeMath for uint256;
276 
277     mapping (address => uint256) private _balances;
278 
279     mapping (address => mapping (address => uint256)) private _allowances;
280 
281     uint256 private _totalSupply;
282 
283     string private _name;
284     string private _symbol;
285     uint8 private _decimals;
286 
287     /**
288      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
289      * a default value of 18.
290      *
291      * To select a different value for {decimals}, use {_setupDecimals}.
292      *
293      * All three of these values are immutable: they can only be set once during
294      * construction.
295      */
296     constructor (string memory name, string memory symbol) public {
297         _name = name;
298         _symbol = symbol;
299         _decimals = 18;
300     }
301 
302     /**
303      * @dev Returns the name of the token.
304      */
305     function name() public view returns (string memory) {
306         return _name;
307     }
308 
309     /**
310      * @dev Returns the symbol of the token, usually a shorter version of the
311      * name.
312      */
313     function symbol() public view returns (string memory) {
314         return _symbol;
315     }
316 
317     /**
318      * @dev Returns the number of decimals used to get its user representation.
319      * For example, if `decimals` equals `2`, a balance of `505` tokens should
320      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
321      *
322      * Tokens usually opt for a value of 18, imitating the relationship between
323      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
324      * called.
325      *
326      * NOTE: This information is only used for _display_ purposes: it in
327      * no way affects any of the arithmetic of the contract, including
328      * {IERC20-balanceOf} and {IERC20-transfer}.
329      */
330     function decimals() public view returns (uint8) {
331         return _decimals;
332     }
333 
334     /**
335      * @dev See {IERC20-totalSupply}.
336      */
337     function totalSupply() public view override returns (uint256) {
338         return _totalSupply;
339     }
340 
341     /**
342      * @dev See {IERC20-balanceOf}.
343      */
344     function balanceOf(address account) public view override returns (uint256) {
345         return _balances[account];
346     }
347 
348     /**
349      * @dev See {IERC20-transfer}.
350      *
351      * Requirements:
352      *
353      * - `recipient` cannot be the zero address.
354      * - the caller must have a balance of at least `amount`.
355      */
356     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
357         _transfer(_msgSender(), recipient, amount);
358         return true;
359     }
360 
361     /**
362      * @dev See {IERC20-allowance}.
363      */
364     function allowance(address owner, address spender) public view virtual override returns (uint256) {
365         return _allowances[owner][spender];
366     }
367 
368     /**
369      * @dev See {IERC20-approve}.
370      *
371      * Requirements:
372      *
373      * - `spender` cannot be the zero address.
374      */
375     function approve(address spender, uint256 amount) public virtual override returns (bool) {
376         _approve(_msgSender(), spender, amount);
377         return true;
378     }
379 
380     /**
381      * @dev See {IERC20-transferFrom}.
382      *
383      * Emits an {Approval} event indicating the updated allowance. This is not
384      * required by the EIP. See the note at the beginning of {ERC20}.
385      *
386      * Requirements:
387      *
388      * - `sender` and `recipient` cannot be the zero address.
389      * - `sender` must have a balance of at least `amount`.
390      * - the caller must have allowance for ``sender``'s tokens of at least
391      * `amount`.
392      */
393     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
394         _transfer(sender, recipient, amount);
395         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
396         return true;
397     }
398 
399     /**
400      * @dev Atomically increases the allowance granted to `spender` by the caller.
401      *
402      * This is an alternative to {approve} that can be used as a mitigation for
403      * problems described in {IERC20-approve}.
404      *
405      * Emits an {Approval} event indicating the updated allowance.
406      *
407      * Requirements:
408      *
409      * - `spender` cannot be the zero address.
410      */
411     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
412         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
413         return true;
414     }
415 
416     /**
417      * @dev Atomically decreases the allowance granted to `spender` by the caller.
418      *
419      * This is an alternative to {approve} that can be used as a mitigation for
420      * problems described in {IERC20-approve}.
421      *
422      * Emits an {Approval} event indicating the updated allowance.
423      *
424      * Requirements:
425      *
426      * - `spender` cannot be the zero address.
427      * - `spender` must have allowance for the caller of at least
428      * `subtractedValue`.
429      */
430     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
431         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
432         return true;
433     }
434 
435     /**
436      * @dev Moves tokens `amount` from `sender` to `recipient`.
437      *
438      * This is internal function is equivalent to {transfer}, and can be used to
439      * e.g. implement automatic token fees, slashing mechanisms, etc.
440      *
441      * Emits a {Transfer} event.
442      *
443      * Requirements:
444      *
445      * - `sender` cannot be the zero address.
446      * - `recipient` cannot be the zero address.
447      * - `sender` must have a balance of at least `amount`.
448      */
449     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
450         require(sender != address(0), "ERC20: transfer from the zero address");
451         require(recipient != address(0), "ERC20: transfer to the zero address");
452 
453         _beforeTokenTransfer(sender, recipient, amount);
454 
455         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
456         _balances[recipient] = _balances[recipient].add(amount);
457         emit Transfer(sender, recipient, amount);
458     }
459 
460     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
461      * the total supply.
462      *
463      * Emits a {Transfer} event with `from` set to the zero address.
464      *
465      * Requirements:
466      *
467      * - `to` cannot be the zero address.
468      */
469     function _mint(address account, uint256 amount) internal virtual {
470         require(account != address(0), "ERC20: mint to the zero address");
471 
472         _beforeTokenTransfer(address(0), account, amount);
473 
474         _totalSupply = _totalSupply.add(amount);
475         _balances[account] = _balances[account].add(amount);
476         emit Transfer(address(0), account, amount);
477     }
478 
479     /**
480      * @dev Destroys `amount` tokens from `account`, reducing the
481      * total supply.
482      *
483      * Emits a {Transfer} event with `to` set to the zero address.
484      *
485      * Requirements:
486      *
487      * - `account` cannot be the zero address.
488      * - `account` must have at least `amount` tokens.
489      */
490     function _burn(address account, uint256 amount) internal virtual {
491         require(account != address(0), "ERC20: burn from the zero address");
492 
493         _beforeTokenTransfer(account, address(0), amount);
494 
495         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
496         _totalSupply = _totalSupply.sub(amount);
497         emit Transfer(account, address(0), amount);
498     }
499 
500     /**
501      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
502      *
503      * This internal function is equivalent to `approve`, and can be used to
504      * e.g. set automatic allowances for certain subsystems, etc.
505      *
506      * Emits an {Approval} event.
507      *
508      * Requirements:
509      *
510      * - `owner` cannot be the zero address.
511      * - `spender` cannot be the zero address.
512      */
513     function _approve(address owner, address spender, uint256 amount) internal virtual {
514         require(owner != address(0), "ERC20: approve from the zero address");
515         require(spender != address(0), "ERC20: approve to the zero address");
516 
517         _allowances[owner][spender] = amount;
518         emit Approval(owner, spender, amount);
519     }
520 
521     /**
522      * @dev Sets {decimals} to a value other than the default one of 18.
523      *
524      * WARNING: This function should only be called from the constructor. Most
525      * applications that interact with token contracts will not expect
526      * {decimals} to ever change, and may work incorrectly if it does.
527      */
528     function _setupDecimals(uint8 decimals_) internal {
529         _decimals = decimals_;
530     }
531 
532     /**
533      * @dev Hook that is called before any transfer of tokens. This includes
534      * minting and burning.
535      *
536      * Calling conditions:
537      *
538      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
539      * will be to transferred to `to`.
540      * - when `from` is zero, `amount` tokens will be minted for `to`.
541      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
542      * - `from` and `to` are never both zero.
543      *
544      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
545      */
546     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
547 }
548 
549 
550 pragma solidity ^0.6.0;
551 
552 
553 /**
554  * @dev Contract module which provides a basic access control mechanism, where
555  * there is an account (an owner) that can be granted exclusive access to
556  * specific functions.
557  *
558  * By default, the owner account will be the one that deploys the contract. This
559  * can later be changed with {transferOwnership}.
560  *
561  * This module is used through inheritance. It will make available the modifier
562  * `onlyOwner`, which can be applied to your functions to restrict their use to
563  * the owner.
564  */
565 contract Ownable {
566     address private _owner;
567 
568     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
569 
570     /**
571      * @dev Initializes the contract setting the deployer as the initial owner.
572      */
573     constructor () public {
574         _owner = msg.sender;
575         emit OwnershipTransferred(address(0), _owner);
576     }
577 
578     /**
579      * @dev Returns the address of the current owner.
580      */
581     function owner() public view returns (address) {
582         return _owner;
583     }
584 
585     /**
586      * @dev Throws if called by any account other than the owner.
587      */
588     modifier onlyOwner() {
589         require(_owner == msg.sender, "Ownable: caller is not the owner");
590         _;
591     }
592 
593     /**
594      * @dev Leaves the contract without owner. It will not be possible to call
595      * `onlyOwner` functions anymore. Can only be called by the current owner.
596      *
597      * NOTE: Renouncing ownership will leave the contract without an owner,
598      * thereby removing any functionality that is only available to the owner.
599      */
600     function renounceOwnership() public virtual onlyOwner {
601         emit OwnershipTransferred(_owner, address(0));
602         _owner = address(0);
603     }
604 
605     /**
606      * @dev Transfers ownership of the contract to a new account (`newOwner`).
607      * Can only be called by the current owner.
608      */
609     function transferOwnership(address newOwner) public virtual onlyOwner {
610         require(newOwner != address(0), "Ownable: new owner is the zero address");
611         emit OwnershipTransferred(_owner, newOwner);
612         _owner = newOwner;
613     }
614 }
615 
616 
617 contract BlackList is Ownable {
618     
619     mapping (address => bool) private _blackList;
620     
621     modifier onlyNotBanned(address user) {
622         require(!isBanned(user), "Access is denied");
623         _;
624     }
625     
626     function isBanned(address user) public view returns (bool) {
627         return _blackList[user];
628     }
629     
630     function setBanState(address user, bool state) public onlyOwner {
631         _blackList[user] = state;
632     }
633 }
634 
635 
636 contract CyberFiToken is ERC20("CyberFi Token", "CFi"), BlackList {
637     
638     constructor () public {
639         _mint(msg.sender, 2_400_000 ether);
640     }
641     
642     function transfer(address _to, uint256 _value) public onlyNotBanned(msg.sender) onlyNotBanned(_to) override returns (bool success)  {
643         _transfer(msg.sender, _to, _value);
644         return true;
645     }
646 
647     function transferFrom(address _from, address _to, uint256 _value) public onlyNotBanned(msg.sender) onlyNotBanned(_from) onlyNotBanned(_to) override returns (bool success) {
648         _transfer(_from, _to, _value);
649         _approve(_from, msg.sender, allowance(_from, msg.sender).sub(_value, "ERC20: transfer amount exceeds allowance"));
650         return true;
651     }
652 }