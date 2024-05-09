1 pragma solidity ^0.6.7;
2 
3 
4 /*
5  * @dev Provides information about the current execution context, including the
6  * sender of the transaction and its data. While these are generally available
7  * via msg.sender and msg.data, they should not be accessed in such a direct
8  * manner, since when dealing with GSN meta-transactions the account sending and
9  * paying for execution may not be the actual sender (as far as an application
10  * is concerned).
11  *
12  * This contract is only required for intermediate, library-like contracts.
13  */
14  
15 contract Context {
16     // Empty internal constructor, to prevent people from mistakenly deploying
17     // an instance of this contract, which should be used via inheritance.
18     constructor () internal { }
19 
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
31 /**
32  * @dev Interface of the ERC20 standard as defined in the EIP.
33  */
34 interface IERC20 {
35     /**
36      * @dev Returns the amount of tokens in existence.
37      */
38     function totalSupply() external view returns (uint256);
39 
40     /**
41      * @dev Returns the amount of tokens owned by `account`.
42      */
43     function balanceOf(address account) external view returns (uint256);
44 
45     /**
46      * @dev Moves `amount` tokens from the caller's account to `recipient`.
47      *
48      * Returns a boolean value indicating whether the operation succeeded.
49      *
50      * Emits a {Transfer} event.
51      */
52     function transfer(address recipient, uint256 amount) external returns (bool);
53 
54     /**
55      * @dev Returns the remaining number of tokens that `spender` will be
56      * allowed to spend on behalf of `owner` through {transferFrom}. This is
57      * zero by default.
58      *
59      * This value changes when {approve} or {transferFrom} are called.
60      */
61     function allowance(address owner, address spender) external view returns (uint256);
62 
63     /**
64      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
65      *
66      * Returns a boolean value indicating whether the operation succeeded.
67      *
68      * IMPORTANT: Beware that changing an allowance with this method brings the risk
69      * that someone may use both the old and the new allowance by unfortunate
70      * transaction ordering. One possible solution to mitigate this race
71      * condition is to first reduce the spender's allowance to 0 and set the
72      * desired value afterwards:
73      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
74      *
75      * Emits an {Approval} event.
76      */
77     function approve(address spender, uint256 amount) external returns (bool);
78 
79     /**
80      * @dev Moves `amount` tokens from `sender` to `recipient` using the
81      * allowance mechanism. `amount` is then deducted from the caller's
82      * allowance.
83      *
84      * Returns a boolean value indicating whether the operation succeeded.
85      *
86      * Emits a {Transfer} event.
87      */
88      
89     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
90 
91     /**
92      * @dev Emitted when `value` tokens are moved from one account (`from`) to
93      * another (`to`).
94      *
95      * Note that `value` may be zero.
96      */
97     event Transfer(address indexed from, address indexed to, uint256 value);
98 
99     /**
100      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
101      * a call to {approve}. `value` is the new allowance.
102      */
103     event Approval(address indexed owner, address indexed spender, uint256 value);
104 }
105 
106 /**
107  * @dev Wrappers over Solidity's arithmetic operations with added overflow
108  * checks.
109  *
110  * Arithmetic operations in Solidity wrap on overflow. This can easily result
111  * in bugs, because programmers usually assume that an overflow raises an
112  * error, which is the standard behavior in high level programming languages.
113  * `SafeMath` restores this intuition by reverting the transaction when an
114  * operation overflows.
115  *
116  * Using this library instead of the unchecked operations eliminates an entire
117  * class of bugs, so it's recommended to use it always.
118  */
119 library SafeMath {
120     /**
121      * @dev Returns the addition of two unsigned integers, reverting on
122      * overflow.
123      *
124      * Counterpart to Solidity's `+` operator.
125      *
126      * Requirements Are:
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
142      * Requirements Are:
143      * - Subtraction cannot overflow.
144      */
145     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
146         return sub(a, b, "SafeMath: subtraction overflow");
147     }
148 
149     /**
150      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
151      * overflow (when the result is negative).
152      *
153      * Counterpart to Solidity's `-` operator.
154      *
155      * Requirements Are:
156      * - Subtraction cannot overflow.
157      */
158     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
159         require(b <= a, errorMessage);
160         uint256 c = a - b;
161 
162         return c;
163     }
164 
165     /**
166      * @dev Returns the multiplication of two unsigned integers, reverting on
167      * overflow.
168      *
169      * Counterpart to Solidity's `*` operator.
170      *
171      * Requirements Are:
172      * - Multiplication cannot overflow.
173      */
174     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
175         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
176         // benefit is lost if 'b' is also tested.
177         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
178         if (a == 0) {
179             return 0;
180         }
181 
182         uint256 c = a * b;
183         require(c / a == b, "SafeMath: multiplication overflow");
184 
185         return c;
186     }
187 
188     /**
189      * @dev Returns the integer division of two unsigned integers. Reverts on
190      * division by zero. The result is rounded towards zero.
191      *
192      * Counterpart to Solidity's `/` operator. Note: this function uses a
193      * `revert` opcode (which leaves remaining gas untouched) while Solidity
194      * uses an invalid opcode to revert (consuming all remaining gas).
195      *
196      * Requirements Are:
197      * - The divisor cannot be zero.
198      */
199     function div(uint256 a, uint256 b) internal pure returns (uint256) {
200         return div(a, b, "SafeMath: division by zero");
201     }
202 
203     /**
204      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
205      * division by zero. The result is rounded towards zero.
206      *
207      * Counterpart to Solidity's `/` operator. Note: this function uses a
208      * `revert` opcode (which leaves remaining gas untouched) while Solidity
209      * uses an invalid opcode to revert (consuming all remaining gas).
210      *
211      * Requirements Are:
212      * - The divisor cannot be zero.
213      */
214     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
215         // Solidity only automatically asserts when dividing by 0
216         require(b > 0, errorMessage);
217         uint256 c = a / b;
218         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
219 
220         return c;
221     }
222 
223     /**
224      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
225      * Reverts when dividing by zero.
226      *
227      * Counterpart to Solidity's `%` operator. This function uses a `revert`
228      * opcode (which leaves remaining gas untouched) while Solidity uses an
229      * invalid opcode to revert (consuming all remaining gas).
230      *
231      * Requirements Are:
232      * - The divisor cannot be zero.
233      */
234     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
235         return mod(a, b, "SafeMath: modulo by zero");
236     }
237 
238     /**
239      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
240      * Reverts with custom message when dividing by zero.
241      *
242      * Counterpart to Solidity's `%` operator. This function uses a `revert`
243      * opcode (which leaves remaining gas untouched) while Solidity uses an
244      * invalid opcode to revert (consuming all remaining gas).
245      *
246      * Requirements Are:
247      * - The divisor cannot be zero.
248      */
249     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
250         require(b != 0, errorMessage);
251         return a % b;
252     }
253 }
254 
255 
256 /**
257  * 
258  * @dev Collection of functions related to the address type
259  */
260  
261 library Address {
262     /**
263      * @dev Returns true if `account` is a contract.
264      *
265      * [IMPORTANT]
266      * ====
267      * It is unsafe to assume that an address for which this function returns
268      * false is an externally-owned account (EOA) and not a contract.
269      *
270      * Among others, `isContract` will return false for the following
271      * types of addresses:
272      *
273      *  - an externally-owned account
274      *  - a contract in construction
275      *  - an address where a contract will be created
276      *  - an address where a contract lived, but was destroyed
277      * ====
278      */
279     function isContract(address account) internal view returns (bool) {
280         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
281         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
282         // for accounts without code, i.e. `keccak256('')`
283         bytes32 codehash;
284         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
285         // solhint-disable-next-line no-inline-assembly
286         assembly { codehash := extcodehash(account) }
287         return (codehash != accountHash && codehash != 0x0);
288     }
289 
290     /**
291      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
292      * `recipient`, forwarding all available gas and reverting on errors.
293      *
294      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
295      * of certain opcodes, possibly making contracts go over the 2300 gas limit
296      * imposed by `transfer`, making them unable to receive funds via
297      * `transfer`. {sendValue} removes this limitation.
298      *
299      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
300      *
301      * IMPORTANT: because control is transferred to `recipient`, care must be
302      * taken to not create reentrancy vulnerabilities. Consider using
303      * {ReentrancyGuard} or the
304      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
305      */
306     function sendValue(address payable recipient, uint256 amount) internal {
307         require(address(this).balance >= amount, "Address: insufficient balance");
308 
309         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
310         (bool success, ) = recipient.call{ value: amount }("");
311         require(success, "Address: unable to send value, recipient may have reverted");
312     }
313 }
314 
315 /**
316  * @dev Implementation of the {IERC20} interface.
317  *
318  * This implementation is agnostic to the way tokens are created. This means
319  * that a supply mechanism has to be added in a derived contract using {_mint}.
320  * For a generic mechanism see {ERC20MinterPauser}.
321  *
322  * TIP: For a detailed writeup see our guide
323  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
324  * to implement supply mechanisms].
325  *
326  * We have followed general OpenZeppelin guidelines: functions revert instead
327  * of returning `false` on failure. This behavior is nonetheless conventional
328  * and does not conflict with the expectations of ERC20 applications.
329  *
330  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
331  * This allows applications to reconstruct the allowance for all accounts just
332  * by listening to said events. Other implementations of the EIP may not emit
333  * these events, as it isn't required by the specification.
334  *
335  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
336  * functions have been added to mitigate the well-known issues around setting
337  * allowances. See {IERC20-approve}.
338  */
339  
340 contract ERC20 is Context, IERC20 {
341     using SafeMath for uint256;
342     using Address for address;
343 
344     mapping (address => uint256) private _balances;
345 
346     mapping (address => mapping (address => uint256)) private _allowances;
347 
348     uint256 private _totalSupply;
349 
350     string private _name;
351     string private _symbol;
352     uint8 private _decimals;
353 
354     /**
355      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
356      * a default value of 18.
357      *
358      * To select a different value for {decimals}, use {_setupDecimals}.
359      *
360      * All three of these values are immutable: they can only be set once during
361      * construction.
362      */
363     constructor (string memory name, string memory symbol) public {
364         _name = name;
365         _symbol = symbol;
366         _decimals = 18;
367     }
368 
369     /**
370      * @dev Returns the name of the token.
371      */
372     function name() public view returns (string memory) {
373         return _name;
374     }
375 
376     /**
377      * @dev Returns the symbol of the token, usually a shorter version of the
378      * name.
379      */
380     function symbol() public view returns (string memory) {
381         return _symbol;
382     }
383 
384     /**
385      * @dev Returns the number of decimals used to get its user representation.
386      * For example, if `decimals` equals `2`, a balance of `505` tokens should
387      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
388      *
389      * Tokens usually opt for a value of 18, imitating the relationship between
390      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
391      * called.
392      *
393      * NOTE: This information is only used for _display_ purposes: it in
394      * no way affects any of the arithmetic of the contract, including
395      * {IERC20-balanceOf} and {IERC20-transfer}.
396      */
397     function decimals() public view returns (uint8) {
398         return _decimals;
399     }
400 
401     /**
402      * @dev See {IERC20-totalSupply}.
403      */
404     function totalSupply() public view override returns (uint256) {
405         return _totalSupply;
406     }
407 
408     /**
409      * @dev See {IERC20-balanceOf}.
410      */
411     function balanceOf(address account) public view override returns (uint256) {
412         return _balances[account];
413     }
414 
415     /**
416      * @dev See {IERC20-transfer}.
417      *
418      * Requirements Are:
419      *
420      * - `recipient` cannot be the zero address.
421      * - the caller must have a balance of at least `amount`.
422      */
423     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
424         _transfer(_msgSender(), recipient, amount);
425         return true;
426     }
427 
428     /**
429      * @dev See {IERC20-allowance}.
430      */
431     function allowance(address owner, address spender) public view virtual override returns (uint256) {
432         return _allowances[owner][spender];
433     }
434 
435     /**
436      * @dev See {IERC20-approve}.
437      *
438      * Requirements Are:
439      *
440      * - `spender` cannot be the zero address.
441      */
442     function approve(address spender, uint256 amount) public virtual override returns (bool) {
443         _approve(_msgSender(), spender, amount);
444         return true;
445     }
446 
447     /**
448      * @dev See {IERC20-transferFrom}.
449      *
450      * Emits an {Approval} event indicating the updated allowance. This is not
451      * required by the EIP. See the note at the beginning of {ERC20};
452      *
453      * Requirements Are:
454      * - `sender` and `recipient` cannot be the zero address.
455      * - `sender` must have a balance of at least `amount`.
456      * - the caller must have allowance for ``sender``'s tokens of at least
457      * `amount`.
458      */
459     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
460         _transfer(sender, recipient, amount);
461         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
462         return true;
463     }
464 
465     /**
466      * @dev Atomically increases the allowance granted to `spender` by the caller.
467      *
468      * This is an alternative to {approve} that can be used as a mitigation for
469      * problems described in {IERC20-approve}.
470      *
471      * Emits an {Approval} event indicating the updated allowance.
472      *
473      * Requirements Are:
474      *
475      * - `spender` cannot be the zero address.
476      */
477     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
478         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
479         return true;
480     }
481 
482     /**
483      * @dev Atomically decreases the allowance granted to `spender` by the caller.
484      *
485      * This is an alternative to {approve} that can be used as a mitigation for
486      * problems described in {IERC20-approve}.
487      *
488      * Emits an {Approval} event indicating the updated allowance.
489      *
490      * Requirements Are:
491      *
492      * - `spender` cannot be the zero address.
493      * - `spender` must have allowance for the caller of at least
494      * `subtractedValue`.
495      */
496     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
497         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
498         return true;
499     }
500 
501     /**
502      * @dev Moves tokens `amount` from `sender` to `recipient`.
503      *
504      * This is internal function is equivalent to {transfer}, and can be used to
505      * e.g. implement automatic token fees, slashing mechanisms, etc.
506      *
507      * Emits a {Transfer} event.
508      *
509      * Requirements Are:
510      *
511      * - `sender` cannot be the zero address.
512      * - `recipient` cannot be the zero address.
513      * - `sender` must have a balance of at least `amount`.
514      */
515     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
516         require(sender != address(0), "ERC20: transfer from the zero address");
517         require(recipient != address(0), "ERC20: transfer to the zero address");
518 
519         _beforeTokenTransfer(sender, recipient, amount);
520 
521         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
522         _balances[recipient] = _balances[recipient].add(amount);
523         emit Transfer(sender, recipient, amount);
524     }
525 
526     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
527      * the total supply.
528      *
529      * Emits a {Transfer} event with `from` set to the zero address.
530      *
531      * Requirements
532      *
533      * - `to` cannot be the zero address.
534      */
535     function _mint(address account, uint256 amount) internal virtual {
536         require(account != address(0), "ERC20: mint to the zero address");
537 
538         _beforeTokenTransfer(address(0), account, amount);
539 
540         _totalSupply = _totalSupply.add(amount);
541         _balances[account] = _balances[account].add(amount);
542         emit Transfer(address(0), account, amount);
543     }
544 
545     /**
546      * @dev Destroys `amount` tokens from `account`, reducing the
547      * total supply.
548      *
549      * Emits a {Transfer} event with `to` set to the zero address.
550      *
551      * Requirements
552      *
553      * - `account` cannot be the zero address.
554      * - `account` must have at least `amount` tokens.
555      */
556     function _burn(address account, uint256 amount) internal virtual {
557         require(account != address(0), "ERC20: burn from the zero address");
558 
559         _beforeTokenTransfer(account, address(0), amount);
560 
561         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
562         _totalSupply = _totalSupply.sub(amount);
563         emit Transfer(account, address(0), amount);
564     }
565 
566     /**
567      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
568      *
569      * This is internal function is equivalent to `approve`, and can be used to
570      * e.g. set automatic allowances for certain subsystems, etc.
571      *
572      * Emits an {Approval} event.
573      *
574      * Requirements Are:
575      *
576      * - `owner` cannot be the zero address.
577      * - `spender` cannot be the zero address.
578      */
579     function _approve(address owner, address spender, uint256 amount) internal virtual {
580         require(owner != address(0), "ERC20: approve from the zero address");
581         require(spender != address(0), "ERC20: approve to the zero address");
582 
583         _allowances[owner][spender] = amount;
584         emit Approval(owner, spender, amount);
585     }
586 
587     /**
588      * @dev Sets {decimals} to a value other than the default one of 18.
589      *
590      * WARNING: This function should only be called from the constructor. Most
591      * applications that interact with token contracts will not expect
592      * {decimals} to ever change, and may work incorrectly if it does.
593      */
594     function _setupDecimals(uint8 decimals_) internal {
595         _decimals = decimals_;
596     }
597 
598     /**
599      * @dev Hook that is called before any transfer of tokens. This includes
600      * minting and burning.
601      *
602      * Calling conditions:
603      *
604      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
605      * will be to transferred to `to`.
606      * - when `from` is zero, `amount` tokens will be minted for `to`.
607      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
608      * - `from` and `to` are never both zero.
609      *
610      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
611      */
612     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
613 }
614 
615 contract ERCToken is ERC20 {
616     constructor () public ERC20("Crypto User Base", "CUB")
617     {
618         _setupDecimals(18);
619         _mint(msg.sender, 1000000 * (10 ** uint256(decimals())));
620     }
621 }