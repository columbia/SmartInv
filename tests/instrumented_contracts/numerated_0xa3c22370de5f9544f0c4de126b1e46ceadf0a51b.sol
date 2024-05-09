1 // contracts/WrappedStrax.sol
2 // SPDX-License-Identifier: MIT
3 pragma solidity ^0.6.0;
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
26 /**
27  * @dev Contract module which provides a basic access control mechanism, where
28  * there is an account (an owner) that can be granted exclusive access to
29  * specific functions.
30  *
31  * By default, the owner account will be the one that deploys the contract. This
32  * can later be changed with {transferOwnership}.
33  *
34  * This module is used through inheritance. It will make available the modifier
35  * `onlyOwner`, which can be applied to your functions to restrict their use to
36  * the owner.
37  */
38 abstract contract Ownable is Context {
39     address private _owner;
40 
41     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
42 
43     /**
44      * @dev Initializes the contract setting the deployer as the initial owner.
45      */
46     constructor () internal {
47         address msgSender = _msgSender();
48         _owner = msgSender;
49         emit OwnershipTransferred(address(0), msgSender);
50     }
51 
52     /**
53      * @dev Returns the address of the current owner.
54      */
55     function owner() public view returns (address) {
56         return _owner;
57     }
58 
59     /**
60      * @dev Throws if called by any account other than the owner.
61      */
62     modifier onlyOwner() {
63         require(_owner == _msgSender(), "Ownable: caller is not the owner");
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
75         emit OwnershipTransferred(_owner, address(0));
76         _owner = address(0);
77     }
78 
79     /**
80      * @dev Transfers ownership of the contract to a new account (`newOwner`).
81      * Can only be called by the current owner.
82      */
83     function transferOwnership(address newOwner) public virtual onlyOwner {
84         require(newOwner != address(0), "Ownable: new owner is the zero address");
85         emit OwnershipTransferred(_owner, newOwner);
86         _owner = newOwner;
87     }
88 }
89 
90 /**
91  * @dev Interface of the ERC20 standard as defined in the EIP.
92  */
93 interface IERC20 {
94     /**
95      * @dev Returns the amount of tokens in existence.
96      */
97     function totalSupply() external view returns (uint256);
98 
99     /**
100      * @dev Returns the amount of tokens owned by `account`.
101      */
102     function balanceOf(address account) external view returns (uint256);
103 
104     /**
105      * @dev Moves `amount` tokens from the caller's account to `recipient`.
106      *
107      * Returns a boolean value indicating whether the operation succeeded.
108      *
109      * Emits a {Transfer} event.
110      */
111     function transfer(address recipient, uint256 amount) external returns (bool);
112 
113     /**
114      * @dev Returns the remaining number of tokens that `spender` will be
115      * allowed to spend on behalf of `owner` through {transferFrom}. This is
116      * zero by default.
117      *
118      * This value changes when {approve} or {transferFrom} are called.
119      */
120     function allowance(address owner, address spender) external view returns (uint256);
121 
122     /**
123      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
124      *
125      * Returns a boolean value indicating whether the operation succeeded.
126      *
127      * IMPORTANT: Beware that changing an allowance with this method brings the risk
128      * that someone may use both the old and the new allowance by unfortunate
129      * transaction ordering. One possible solution to mitigate this race
130      * condition is to first reduce the spender's allowance to 0 and set the
131      * desired value afterwards:
132      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
133      *
134      * Emits an {Approval} event.
135      */
136     function approve(address spender, uint256 amount) external returns (bool);
137 
138     /**
139      * @dev Moves `amount` tokens from `sender` to `recipient` using the
140      * allowance mechanism. `amount` is then deducted from the caller's
141      * allowance.
142      *
143      * Returns a boolean value indicating whether the operation succeeded.
144      *
145      * Emits a {Transfer} event.
146      */
147     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
148 
149     /**
150      * @dev Emitted when `value` tokens are moved from one account (`from`) to
151      * another (`to`).
152      *
153      * Note that `value` may be zero.
154      */
155     event Transfer(address indexed from, address indexed to, uint256 value);
156 
157     /**
158      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
159      * a call to {approve}. `value` is the new allowance.
160      */
161     event Approval(address indexed owner, address indexed spender, uint256 value);
162 }
163 
164 /**
165  * @dev Wrappers over Solidity's arithmetic operations with added overflow
166  * checks.
167  *
168  * Arithmetic operations in Solidity wrap on overflow. This can easily result
169  * in bugs, because programmers usually assume that an overflow raises an
170  * error, which is the standard behavior in high level programming languages.
171  * `SafeMath` restores this intuition by reverting the transaction when an
172  * operation overflows.
173  *
174  * Using this library instead of the unchecked operations eliminates an entire
175  * class of bugs, so it's recommended to use it always.
176  */
177 library SafeMath {
178     /**
179      * @dev Returns the addition of two unsigned integers, reverting on
180      * overflow.
181      *
182      * Counterpart to Solidity's `+` operator.
183      *
184      * Requirements:
185      *
186      * - Addition cannot overflow.
187      */
188     function add(uint256 a, uint256 b) internal pure returns (uint256) {
189         uint256 c = a + b;
190         require(c >= a, "SafeMath: addition overflow");
191 
192         return c;
193     }
194 
195     /**
196      * @dev Returns the subtraction of two unsigned integers, reverting on
197      * overflow (when the result is negative).
198      *
199      * Counterpart to Solidity's `-` operator.
200      *
201      * Requirements:
202      *
203      * - Subtraction cannot overflow.
204      */
205     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
206         return sub(a, b, "SafeMath: subtraction overflow");
207     }
208 
209     /**
210      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
211      * overflow (when the result is negative).
212      *
213      * Counterpart to Solidity's `-` operator.
214      *
215      * Requirements:
216      *
217      * - Subtraction cannot overflow.
218      */
219     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
220         require(b <= a, errorMessage);
221         uint256 c = a - b;
222 
223         return c;
224     }
225 
226     /**
227      * @dev Returns the multiplication of two unsigned integers, reverting on
228      * overflow.
229      *
230      * Counterpart to Solidity's `*` operator.
231      *
232      * Requirements:
233      *
234      * - Multiplication cannot overflow.
235      */
236     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
237         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
238         // benefit is lost if 'b' is also tested.
239         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
240         if (a == 0) {
241             return 0;
242         }
243 
244         uint256 c = a * b;
245         require(c / a == b, "SafeMath: multiplication overflow");
246 
247         return c;
248     }
249 
250     /**
251      * @dev Returns the integer division of two unsigned integers. Reverts on
252      * division by zero. The result is rounded towards zero.
253      *
254      * Counterpart to Solidity's `/` operator. Note: this function uses a
255      * `revert` opcode (which leaves remaining gas untouched) while Solidity
256      * uses an invalid opcode to revert (consuming all remaining gas).
257      *
258      * Requirements:
259      *
260      * - The divisor cannot be zero.
261      */
262     function div(uint256 a, uint256 b) internal pure returns (uint256) {
263         return div(a, b, "SafeMath: division by zero");
264     }
265 
266     /**
267      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
268      * division by zero. The result is rounded towards zero.
269      *
270      * Counterpart to Solidity's `/` operator. Note: this function uses a
271      * `revert` opcode (which leaves remaining gas untouched) while Solidity
272      * uses an invalid opcode to revert (consuming all remaining gas).
273      *
274      * Requirements:
275      *
276      * - The divisor cannot be zero.
277      */
278     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
279         require(b > 0, errorMessage);
280         uint256 c = a / b;
281         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
282 
283         return c;
284     }
285 
286     /**
287      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
288      * Reverts when dividing by zero.
289      *
290      * Counterpart to Solidity's `%` operator. This function uses a `revert`
291      * opcode (which leaves remaining gas untouched) while Solidity uses an
292      * invalid opcode to revert (consuming all remaining gas).
293      *
294      * Requirements:
295      *
296      * - The divisor cannot be zero.
297      */
298     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
299         return mod(a, b, "SafeMath: modulo by zero");
300     }
301 
302     /**
303      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
304      * Reverts with custom message when dividing by zero.
305      *
306      * Counterpart to Solidity's `%` operator. This function uses a `revert`
307      * opcode (which leaves remaining gas untouched) while Solidity uses an
308      * invalid opcode to revert (consuming all remaining gas).
309      *
310      * Requirements:
311      *
312      * - The divisor cannot be zero.
313      */
314     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
315         require(b != 0, errorMessage);
316         return a % b;
317     }
318 }
319 
320 /**
321  * @dev Implementation of the {IERC20} interface.
322  *
323  * This implementation is agnostic to the way tokens are created. This means
324  * that a supply mechanism has to be added in a derived contract using {_mint}.
325  * For a generic mechanism see {ERC20PresetMinterPauser}.
326  *
327  * TIP: For a detailed writeup see our guide
328  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
329  * to implement supply mechanisms].
330  *
331  * We have followed general OpenZeppelin guidelines: functions revert instead
332  * of returning `false` on failure. This behavior is nonetheless conventional
333  * and does not conflict with the expectations of ERC20 applications.
334  *
335  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
336  * This allows applications to reconstruct the allowance for all accounts just
337  * by listening to said events. Other implementations of the EIP may not emit
338  * these events, as it isn't required by the specification.
339  *
340  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
341  * functions have been added to mitigate the well-known issues around setting
342  * allowances. See {IERC20-approve}.
343  */
344 contract ERC20 is Context, IERC20 {
345     using SafeMath for uint256;
346 
347     mapping (address => uint256) private _balances;
348 
349     mapping (address => mapping (address => uint256)) private _allowances;
350 
351     uint256 private _totalSupply;
352 
353     string private _name;
354     string private _symbol;
355     uint8 private _decimals;
356 
357     /**
358      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
359      * a default value of 18.
360      *
361      * To select a different value for {decimals}, use {_setupDecimals}.
362      *
363      * All three of these values are immutable: they can only be set once during
364      * construction.
365      */
366     constructor (string memory name_, string memory symbol_) public {
367         _name = name_;
368         _symbol = symbol_;
369         _decimals = 18;
370     }
371 
372     /**
373      * @dev Returns the name of the token.
374      */
375     function name() public view returns (string memory) {
376         return _name;
377     }
378 
379     /**
380      * @dev Returns the symbol of the token, usually a shorter version of the
381      * name.
382      */
383     function symbol() public view returns (string memory) {
384         return _symbol;
385     }
386 
387     /**
388      * @dev Returns the number of decimals used to get its user representation.
389      * For example, if `decimals` equals `2`, a balance of `505` tokens should
390      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
391      *
392      * Tokens usually opt for a value of 18, imitating the relationship between
393      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
394      * called.
395      *
396      * NOTE: This information is only used for _display_ purposes: it in
397      * no way affects any of the arithmetic of the contract, including
398      * {IERC20-balanceOf} and {IERC20-transfer}.
399      */
400     function decimals() public view returns (uint8) {
401         return _decimals;
402     }
403 
404     /**
405      * @dev See {IERC20-totalSupply}.
406      */
407     function totalSupply() public view override returns (uint256) {
408         return _totalSupply;
409     }
410 
411     /**
412      * @dev See {IERC20-balanceOf}.
413      */
414     function balanceOf(address account) public view override returns (uint256) {
415         return _balances[account];
416     }
417 
418     /**
419      * @dev See {IERC20-transfer}.
420      *
421      * Requirements:
422      *
423      * - `recipient` cannot be the zero address.
424      * - the caller must have a balance of at least `amount`.
425      */
426     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
427         _transfer(_msgSender(), recipient, amount);
428         return true;
429     }
430 
431     /**
432      * @dev See {IERC20-allowance}.
433      */
434     function allowance(address owner, address spender) public view virtual override returns (uint256) {
435         return _allowances[owner][spender];
436     }
437 
438     /**
439      * @dev See {IERC20-approve}.
440      *
441      * Requirements:
442      *
443      * - `spender` cannot be the zero address.
444      */
445     function approve(address spender, uint256 amount) public virtual override returns (bool) {
446         _approve(_msgSender(), spender, amount);
447         return true;
448     }
449 
450     /**
451      * @dev See {IERC20-transferFrom}.
452      *
453      * Emits an {Approval} event indicating the updated allowance. This is not
454      * required by the EIP. See the note at the beginning of {ERC20}.
455      *
456      * Requirements:
457      *
458      * - `sender` and `recipient` cannot be the zero address.
459      * - `sender` must have a balance of at least `amount`.
460      * - the caller must have allowance for ``sender``'s tokens of at least
461      * `amount`.
462      */
463     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
464         _transfer(sender, recipient, amount);
465         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
466         return true;
467     }
468 
469     /**
470      * @dev Atomically increases the allowance granted to `spender` by the caller.
471      *
472      * This is an alternative to {approve} that can be used as a mitigation for
473      * problems described in {IERC20-approve}.
474      *
475      * Emits an {Approval} event indicating the updated allowance.
476      *
477      * Requirements:
478      *
479      * - `spender` cannot be the zero address.
480      */
481     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
482         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
483         return true;
484     }
485 
486     /**
487      * @dev Atomically decreases the allowance granted to `spender` by the caller.
488      *
489      * This is an alternative to {approve} that can be used as a mitigation for
490      * problems described in {IERC20-approve}.
491      *
492      * Emits an {Approval} event indicating the updated allowance.
493      *
494      * Requirements:
495      *
496      * - `spender` cannot be the zero address.
497      * - `spender` must have allowance for the caller of at least
498      * `subtractedValue`.
499      */
500     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
501         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
502         return true;
503     }
504 
505     /**
506      * @dev Moves tokens `amount` from `sender` to `recipient`.
507      *
508      * This is internal function is equivalent to {transfer}, and can be used to
509      * e.g. implement automatic token fees, slashing mechanisms, etc.
510      *
511      * Emits a {Transfer} event.
512      *
513      * Requirements:
514      *
515      * - `sender` cannot be the zero address.
516      * - `recipient` cannot be the zero address.
517      * - `sender` must have a balance of at least `amount`.
518      */
519     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
520         require(sender != address(0), "ERC20: transfer from the zero address");
521         require(recipient != address(0), "ERC20: transfer to the zero address");
522 
523         _beforeTokenTransfer(sender, recipient, amount);
524 
525         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
526         _balances[recipient] = _balances[recipient].add(amount);
527         emit Transfer(sender, recipient, amount);
528     }
529 
530     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
531      * the total supply.
532      *
533      * Emits a {Transfer} event with `from` set to the zero address.
534      *
535      * Requirements:
536      *
537      * - `to` cannot be the zero address.
538      */
539     function _mint(address account, uint256 amount) internal virtual {
540         require(account != address(0), "ERC20: mint to the zero address");
541 
542         _beforeTokenTransfer(address(0), account, amount);
543 
544         _totalSupply = _totalSupply.add(amount);
545         _balances[account] = _balances[account].add(amount);
546         emit Transfer(address(0), account, amount);
547     }
548 
549     /**
550      * @dev Destroys `amount` tokens from `account`, reducing the
551      * total supply.
552      *
553      * Emits a {Transfer} event with `to` set to the zero address.
554      *
555      * Requirements:
556      *
557      * - `account` cannot be the zero address.
558      * - `account` must have at least `amount` tokens.
559      */
560     function _burn(address account, uint256 amount) internal virtual {
561         require(account != address(0), "ERC20: burn from the zero address");
562 
563         _beforeTokenTransfer(account, address(0), amount);
564 
565         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
566         _totalSupply = _totalSupply.sub(amount);
567         emit Transfer(account, address(0), amount);
568     }
569 
570     /**
571      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
572      *
573      * This internal function is equivalent to `approve`, and can be used to
574      * e.g. set automatic allowances for certain subsystems, etc.
575      *
576      * Emits an {Approval} event.
577      *
578      * Requirements:
579      *
580      * - `owner` cannot be the zero address.
581      * - `spender` cannot be the zero address.
582      */
583     function _approve(address owner, address spender, uint256 amount) internal virtual {
584         require(owner != address(0), "ERC20: approve from the zero address");
585         require(spender != address(0), "ERC20: approve to the zero address");
586 
587         _allowances[owner][spender] = amount;
588         emit Approval(owner, spender, amount);
589     }
590 
591     /**
592      * @dev Sets {decimals} to a value other than the default one of 18.
593      *
594      * WARNING: This function should only be called from the constructor. Most
595      * applications that interact with token contracts will not expect
596      * {decimals} to ever change, and may work incorrectly if it does.
597      */
598     function _setupDecimals(uint8 decimals_) internal {
599         _decimals = decimals_;
600     }
601 
602     /**
603      * @dev Hook that is called before any transfer of tokens. This includes
604      * minting and burning.
605      *
606      * Calling conditions:
607      *
608      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
609      * will be to transferred to `to`.
610      * - when `from` is zero, `amount` tokens will be minted for `to`.
611      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
612      * - `from` and `to` are never both zero.
613      *
614      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
615      */
616     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
617 }
618 
619 contract WrappedStraxToken is ERC20, Ownable {
620     mapping (address => string) public withdrawalAddresses;
621     
622     constructor(uint256 initialSupply) public ERC20("WrappedStrax", "WSTRAX") {
623         _mint(msg.sender, initialSupply);
624     }
625     
626     /**
627      * @dev Creates `amount` new tokens and assigns them to `account`.
628      *
629      * See {ERC20-_mint}.
630      */
631     function mint(address account, uint256 amount) public onlyOwner {
632         _mint(account, amount);
633     }
634     
635     /**
636      * @dev Destroys `amount` tokens from the caller.
637      *
638      * See {ERC20-_burn}.
639      */
640     function burn(uint256 amount, string memory straxAddress) public {
641         _burn(_msgSender(), amount);
642         
643         // When the tokens are burnt we need to know where to credit the equivalent value on the Stratis chain.
644         // Currently it is only possible to assign a single address here, so if multiple recipients are required
645         // the burner will have to wait until each burn is processed before proceeding with the next.
646         withdrawalAddresses[msg.sender] = straxAddress;
647     }
648 
649     /**
650      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
651      * allowance.
652      *
653      * See {ERC20-_burn} and {ERC20-allowance}.
654      *
655      * Requirements:
656      *
657      * - the caller must have allowance for ``accounts``'s tokens of at least
658      * `amount`.
659      */
660     function burnFrom(address account, uint256 amount, string memory straxAddress) public {
661         uint256 decreasedAllowance = allowance(account, _msgSender()).sub(amount, "ERC20: burn amount exceeds allowance");
662 
663         _approve(account, _msgSender(), decreasedAllowance);
664         _burn(account, amount);
665         
666         // When the tokens are burnt we need to know where to credit the equivalent value on the Stratis chain.
667         // Currently it is only possible to assign a single address here, so if multiple recipients are required
668         // the burner will have to wait until each burn is processed before proceeding with the next.
669         withdrawalAddresses[msg.sender] = straxAddress;
670     }
671 }