1 pragma solidity 0.6.2;
2 
3 // File: @openzeppelin/contracts/GSN/Context.sol
4 // SPDX-License-Identifier: MIT
5 
6 /*
7  * @dev Provides information about the current execution context, including the
8  * sender of the transaction and its data. While these are generally available
9  * via msg.sender and msg.data, they should not be accessed in such a direct
10  * manner, since when dealing with GSN meta-transactions the account sending and
11  * paying for execution may not be the actual sender (as far as an application
12  * is concerned).
13  *
14  * This contract is only required for intermediate, library-like contracts.
15  */
16 abstract contract Context {
17     function _msgSender() internal view virtual returns (address payable) {
18         return msg.sender;
19     }
20 
21     function _msgData() internal view virtual returns (bytes memory) {
22         this;
23         // silence state mutability warning without generating bytecode -
24         //see https://github.com/ethereum/solidity/issues/2691
25         return msg.data;
26     }
27 }
28 
29 
30 /**
31  * @dev Interface of the ERC20 standard as defined in the EIP.
32  */
33 interface IERC20 {
34     /**
35      * @dev Returns the amount of tokens in existence.
36      */
37     function totalSupply() external view returns (uint256);
38 
39     /**
40      * @dev Returns the amount of tokens owned by `account`.
41      */
42     function balanceOf(address account) external view returns (uint256);
43 
44     /**
45      * @dev Moves `amount` tokens from the caller's account to `recipient`.
46      *
47      * Returns a boolean value indicating whether the operation succeeded.
48      *
49      * Emits a {Transfer} event.
50      */
51     function transfer(address recipient, uint256 amount) external returns (bool);
52 
53     /**
54      * @dev Returns the remaining number of tokens that `spender` will be
55      * allowed to spend on behalf of `owner` through {transferFrom}. This is
56      * zero by default.
57      *
58      * This value changes when {approve} or {transferFrom} are called.
59      */
60     function allowance(address owner, address spender) external view returns (uint256);
61 
62     /**
63      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
64      *
65      * Returns a boolean value indicating whether the operation succeeded.
66      *
67      * IMPORTANT: Beware that changing an allowance with this method brings the risk
68      * that someone may use both the old and the new allowance by unfortunate
69      * transaction ordering. One possible solution to mitigate this race
70      * condition is to first reduce the spender's allowance to 0 and set the
71      * desired value afterwards:
72      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
73      *
74      * Emits an {Approval} event.
75      */
76     function approve(address spender, uint256 amount) external returns (bool);
77 
78     /**
79      * @dev Moves `amount` tokens from `sender` to `recipient` using the
80      * allowance mechanism. `amount` is then deducted from the caller's
81      * allowance.
82      *
83      * Returns a boolean value indicating whether the operation succeeded.
84      *
85      * Emits a {Transfer} event.
86      */
87     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
88 
89     /**
90      * @dev Emitted when `value` tokens are moved from one account (`from`) to
91      * another (`to`).
92      *
93      * Note that `value` may be zero.
94      */
95     event Transfer(address indexed from, address indexed to, uint256 value);
96 
97     /**
98      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
99      * a call to {approve}. `value` is the new allowance.
100      */
101     event Approval(address indexed owner, address indexed spender, uint256 value);
102 }
103 
104 
105 /**
106  * @dev Wrappers over Solidity's arithmetic operations with added overflow
107  * checks.
108  *
109  * Arithmetic operations in Solidity wrap on overflow. This can easily result
110  * in bugs, because programmers usually assume that an overflow raises an
111  * error, which is the standard behavior in high level programming languages.
112  * `SafeMath` restores this intuition by reverting the transaction when an
113  * operation overflows.
114  *
115  * Using this library instead of the unchecked operations eliminates an entire
116  * class of bugs, so it's recommended to use it always.
117  */
118 library SafeMath {
119     /**
120      * @dev Returns the addition of two unsigned integers, reverting on
121      * overflow.
122      *
123      * Counterpart to Solidity's `+` operator.
124      *
125      * Requirements:
126      *
127      * - Addition cannot overflow.
128      */
129     function add(uint256 a, uint256 b) internal pure returns (uint256) {
130         uint256 c = a + b;
131         require(c >= a, "SafeMath: addition overflow");
132 
133         return c;
134     }
135 
136     /**
137      * @dev Returns the subtraction of two unsigned integers, reverting on
138      * overflow (when the result is negative).
139      *
140      * Counterpart to Solidity's `-` operator.
141      *
142      * Requirements:
143      *
144      * - Subtraction cannot overflow.
145      */
146     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
147         return sub(a, b, "SafeMath: subtraction overflow");
148     }
149 
150     /**
151      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
152      * overflow (when the result is negative).
153      *
154      * Counterpart to Solidity's `-` operator.
155      *
156      * Requirements:
157      *
158      * - Subtraction cannot overflow.
159      */
160     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
161         require(b <= a, errorMessage);
162         uint256 c = a - b;
163 
164         return c;
165     }
166 
167     /**
168      * @dev Returns the multiplication of two unsigned integers, reverting on
169      * overflow.
170      *
171      * Counterpart to Solidity's `*` operator.
172      *
173      * Requirements:
174      *
175      * - Multiplication cannot overflow.
176      */
177     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
178         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
179         // benefit is lost if 'b' is also tested.
180         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
181         if (a == 0) {
182             return 0;
183         }
184 
185         uint256 c = a * b;
186         require(c / a == b, "SafeMath: multiplication overflow");
187 
188         return c;
189     }
190 
191     /**
192      * @dev Returns the integer division of two unsigned integers. Reverts on
193      * division by zero. The result is rounded towards zero.
194      *
195      * Counterpart to Solidity's `/` operator. Note: this function uses a
196      * `revert` opcode (which leaves remaining gas untouched) while Solidity
197      * uses an invalid opcode to revert (consuming all remaining gas).
198      *
199      * Requirements:
200      *
201      * - The divisor cannot be zero.
202      */
203     function div(uint256 a, uint256 b) internal pure returns (uint256) {
204         return div(a, b, "SafeMath: division by zero");
205     }
206 
207     /**
208      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
209      * division by zero. The result is rounded towards zero.
210      *
211      * Counterpart to Solidity's `/` operator. Note: this function uses a
212      * `revert` opcode (which leaves remaining gas untouched) while Solidity
213      * uses an invalid opcode to revert (consuming all remaining gas).
214      *
215      * Requirements:
216      *
217      * - The divisor cannot be zero.
218      */
219     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
220         require(b > 0, errorMessage);
221         uint256 c = a / b;
222         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
223 
224         return c;
225     }
226 
227     /**
228      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
229      * Reverts when dividing by zero.
230      *
231      * Counterpart to Solidity's `%` operator. This function uses a `revert`
232      * opcode (which leaves remaining gas untouched) while Solidity uses an
233      * invalid opcode to revert (consuming all remaining gas).
234      *
235      * Requirements:
236      *
237      * - The divisor cannot be zero.
238      */
239     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
240         return mod(a, b, "SafeMath: modulo by zero");
241     }
242 
243     /**
244      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
245      * Reverts with custom message when dividing by zero.
246      *
247      * Counterpart to Solidity's `%` operator. This function uses a `revert`
248      * opcode (which leaves remaining gas untouched) while Solidity uses an
249      * invalid opcode to revert (consuming all remaining gas).
250      *
251      * Requirements:
252      *
253      * - The divisor cannot be zero.
254      */
255     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
256         require(b != 0, errorMessage);
257         return a % b;
258     }
259 }
260 
261 
262 contract ERC20 is Context, IERC20 {
263     using SafeMath for uint256;
264 
265     mapping (address => uint256) private _balances;
266     mapping (address => mapping (address => uint256)) private _allowances;
267     uint256 private _totalSupply = 0;
268 
269     string private _name;
270     string private _symbol;
271     uint8 private _decimals;
272 
273     /**
274      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
275      * a default value of 18.
276      *
277      * To select a different value for {decimals}, use {_setupDecimals}.
278      *
279      * All three of these values are immutable: they can only be set once during
280      * construction.
281      */
282     constructor (string memory name_, string memory symbol_) public {
283         _name = name_;
284         _symbol = symbol_;
285         _decimals = 18;
286     }
287 
288     /**
289      * @dev Returns the name of the token.
290      */
291     function name() public view returns (string memory) {
292         return _name;
293     }
294 
295     /**
296      * @dev Returns the symbol of the token, usually a shorter version of the
297      * name.
298      */
299     function symbol() public view returns (string memory) {
300         return _symbol;
301     }
302 
303     /**
304      * @dev Returns the number of decimals used to get its user representation.
305      * For example, if `decimals` equals `2`, a balance of `505` tokens should
306      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
307      *
308      * Tokens usually opt for a value of 18, imitating the relationship between
309      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
310      * called.
311      *
312      * NOTE: This information is only used for _display_ purposes: it in
313      * no way affects any of the arithmetic of the contract, including
314      * {IERC20-balanceOf} and {IERC20-transfer}.
315      */
316     function decimals() public view returns (uint8) {
317         return _decimals;
318     }
319 
320     /**
321      * @dev See {IERC20-totalSupply}.
322      */
323     function totalSupply() public view override returns (uint256) {
324         return _totalSupply;
325     }
326 
327     /**
328      * @dev See {IERC20-balanceOf}.
329      */
330     function balanceOf(address account) public view override returns (uint256) {
331         return _balances[account];
332     }
333 
334     /**
335      * @dev See {IERC20-transfer}.
336      *
337      * Requirements:
338      *
339      * - `recipient` cannot be the zero address.
340      * - the caller must have a balance of at least `amount`.
341      */
342     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
343         _transfer(_msgSender(), recipient, amount);
344         return true;
345     }
346 
347     /**
348      * @dev See {IERC20-allowance}.
349      */
350     function allowance(address owner, address spender) public view virtual override returns (uint256) {
351         return _allowances[owner][spender];
352     }
353 
354     /**
355      * @dev See {IERC20-approve}.
356      *
357      * Requirements:
358      *
359      * - `spender` cannot be the zero address.
360      */
361     function approve(address spender, uint256 amount) public virtual override returns (bool) {
362         _approve(_msgSender(), spender, amount);
363         return true;
364     }
365 
366     /**
367      * @dev See {IERC20-transferFrom}.
368      *
369      * Emits an {Approval} event indicating the updated allowance. This is not
370      * required by the EIP. See the note at the beginning of {ERC20}.
371      *
372      * Requirements:
373      *
374      * - `sender` and `recipient` cannot be the zero address.
375      * - `sender` must have a balance of at least `amount`.
376      * - the caller must have allowance for ``sender``'s tokens of at least
377      * `amount`.
378      */
379     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
380         _transfer(sender, recipient, amount);
381         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount,
382             "ERC20: transfer amount exceeds allowance"));
383         return true;
384     }
385 
386     /**
387      * @dev Atomically increases the allowance granted to `spender` by the caller.
388      *
389      * This is an alternative to {approve} that can be used as a mitigation for
390      * problems described in {IERC20-approve}.
391      *
392      * Emits an {Approval} event indicating the updated allowance.
393      *
394      * Requirements:
395      *
396      * - `spender` cannot be the zero address.
397      */
398     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
399         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
400         return true;
401     }
402 
403     /**
404      * @dev Atomically decreases the allowance granted to `spender` by the caller.
405      *
406      * This is an alternative to {approve} that can be used as a mitigation for
407      * problems described in {IERC20-approve}.
408      *
409      * Emits an {Approval} event indicating the updated allowance.
410      *
411      * Requirements:
412      *
413      * - `spender` cannot be the zero address.
414      * - `spender` must have allowance for the caller of at least
415      * `subtractedValue`.
416      */
417     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
418         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue,
419             "ERC20: decreased allowance below zero"));
420         return true;
421     }
422 
423     /**
424      * @dev Moves tokens `amount` from `sender` to `recipient`.
425      *
426      * This is internal function is equivalent to {transfer}, and can be used to
427      * e.g. implement automatic token fees, slashing mechanisms, etc.
428      *
429      * Emits a {Transfer} event.
430      *
431      * Requirements:
432      *
433      * - `sender` cannot be the zero address.
434      * - `recipient` cannot be the zero address.
435      * - `sender` must have a balance of at least `amount`.
436      */
437     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
438         require(sender != address(0), "ERC20: transfer from the zero address");
439         require(recipient != address(0), "ERC20: transfer to the zero address");
440 
441         _beforeTokenTransfer(sender, recipient, amount);
442 
443         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
444         _balances[recipient] = _balances[recipient].add(amount);
445         emit Transfer(sender, recipient, amount);
446     }
447 
448     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
449      * the total supply.
450      *
451      * Emits a {Transfer} event with `from` set to the zero address.
452      *
453      * Requirements:
454      *
455      * - `to` cannot be the zero address.
456      */
457     function _mint(address account, uint256 amount) internal virtual {
458         require(account != address(0), "ERC20: mint to the zero address");
459         _beforeTokenTransfer(address(0), account, amount);
460         _totalSupply = _totalSupply.add(amount);
461         _balances[account] = _balances[account].add(amount);
462         emit Transfer(address(0), account, amount);
463     }
464 
465     /**
466      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
467      *
468      * This internal function is equivalent to `approve`, and can be used to
469      * e.g. set automatic allowances for certain subsystems, etc.
470      *
471      * Emits an {Approval} event.
472      *
473      * Requirements:
474      *
475      * - `owner` cannot be the zero address.
476      * - `spender` cannot be the zero address.
477      */
478     function _approve(address owner, address spender, uint256 amount) internal virtual {
479         require(owner != address(0), "ERC20: approve from the zero address");
480         require(spender != address(0), "ERC20: approve to the zero address");
481         _allowances[owner][spender] = amount;
482         emit Approval(owner, spender, amount);
483     }
484 
485     /**
486      * @dev Sets {decimals} to a value other than the default one of 18.
487      *
488      * WARNING: This function should only be called from the constructor. Most
489      * applications that interact with token contracts will not expect
490      * {decimals} to ever change, and may work incorrectly if it does.
491      */
492     function _setupDecimals(uint8 decimals_) internal {
493         _decimals = decimals_;
494     }
495 
496     /**
497      * @dev Hook that is called before any transfer of tokens. This includes
498      * minting and burning.
499      *
500      * Calling conditions:
501      *
502      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
503      * will be to transferred to `to`.
504      * - when `from` is zero, `amount` tokens will be minted for `to`.
505      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
506      * - `from` and `to` are never both zero.
507      *
508      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
509      */
510     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual {}
511 }
512 
513 
514 /**
515  * @dev Contract module which provides a basic access control mechanism, where
516  * there is an account (an owner) that can be granted exclusive access to
517  * specific functions.
518  *
519  * By default, the owner account will be the one that deploys the contract. This
520  * can later be changed with {transferOwnership}.
521  *
522  * This module is used through inheritance. It will make available the modifier
523  * `onlyOwner`, which can be applied to your functions to restrict their use to
524  * the owner.
525  */
526 abstract contract Ownable is Context {
527     address private _owner;
528 
529     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
530 
531     /**
532      * @dev Initializes the contract setting the deployer as the initial owner.
533      */
534     constructor ()public {
535         address msgSender = _msgSender();
536         _owner = msgSender;
537         emit OwnershipTransferred(address(0), msgSender);
538     }
539 
540     /**
541      * @dev Returns the address of the current owner.
542      */
543     function owner() public view returns (address) {
544         return _owner;
545     }
546 
547     /**
548      * @dev Throws if called by any account other than the owner.
549      */
550     modifier onlyOwner() {
551         require(_owner == _msgSender(), "Ownable: caller is not the owner");
552         _;
553     }
554 
555     /**
556      * @dev Leaves the contract without owner. It will not be possible to call
557      * `onlyOwner` functions anymore. Can only be called by the current owner.
558      *
559      * NOTE: Renouncing ownership will leave the contract without an owner,
560      * thereby removing any functionality that is only available to the owner.
561      */
562     function renounceOwnership() public virtual onlyOwner {
563         emit OwnershipTransferred(_owner, address(0));
564         _owner = address(0);
565     }
566 
567     /**
568      * @dev Transfers ownership of the contract to a new account (`newOwner`).
569      * Can only be called by the current owner.
570      */
571     function transferOwnership(address newOwner) public virtual onlyOwner {
572         require(newOwner != address(0), "Ownable: new owner is the zero address");
573         emit OwnershipTransferred(_owner, newOwner);
574         _owner = newOwner;
575     }
576 }
577 //PIB Contract 
578 contract PassiveIncomeBot is ERC20("Passive Income Bot", "PIB"), Ownable {
579     uint256 private constant _total = 1900000;
580     constructor () public {
581         // mint initial tokens
582         _mint(msg.sender, _total.mul(10 ** 18));
583     }
584 }