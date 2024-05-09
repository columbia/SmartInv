1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.6.0;
4 
5 
6 library SafeMath {
7     /**
8      * @dev Returns the addition of two unsigned integers, reverting on
9      * overflow.
10      *
11      * Counterpart to Solidity's `+` operator.
12      *
13      * Requirements:
14      * - Addition cannot overflow.
15      */
16     function add(uint256 a, uint256 b) internal pure returns (uint256) {
17         uint256 c = a + b;
18         require(c >= a, "SafeMath: addition overflow");
19 
20         return c;
21     }
22 
23     /**
24      * @dev Returns the subtraction of two unsigned integers, reverting on
25      * overflow (when the result is negative).
26      *
27      * Counterpart to Solidity's `-` operator.
28      *
29      * Requirements:
30      * - Subtraction cannot overflow.
31      */
32     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
33         return sub(a, b, "SafeMath: subtraction overflow");
34     }
35 
36     /**
37      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
38      * overflow (when the result is negative).
39      *
40      * Counterpart to Solidity's `-` operator.
41      *
42      * Requirements:
43      * - Subtraction cannot overflow.
44      */
45     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
46         require(b <= a, errorMessage);
47         uint256 c = a - b;
48 
49         return c;
50     }
51 
52     /**
53      * @dev Returns the multiplication of two unsigned integers, reverting on
54      * overflow.
55      *
56      * Counterpart to Solidity's `*` operator.
57      *
58      * Requirements:
59      * - Multiplication cannot overflow.
60      */
61     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
62         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
63         // benefit is lost if 'b' is also tested.
64         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
65         if (a == 0) {
66             return 0;
67         }
68 
69         uint256 c = a * b;
70         require(c / a == b, "SafeMath: multiplication overflow");
71 
72         return c;
73     }
74 
75     /**
76      * @dev Returns the integer division of two unsigned integers. Reverts on
77      * division by zero. The result is rounded towards zero.
78      *
79      * Counterpart to Solidity's `/` operator. Note: this function uses a
80      * `revert` opcode (which leaves remaining gas untouched) while Solidity
81      * uses an invalid opcode to revert (consuming all remaining gas).
82      *
83      * Requirements:
84      * - The divisor cannot be zero.
85      */
86     function div(uint256 a, uint256 b) internal pure returns (uint256) {
87         return div(a, b, "SafeMath: division by zero");
88     }
89 
90     /**
91      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
92      * division by zero. The result is rounded towards zero.
93      *
94      * Counterpart to Solidity's `/` operator. Note: this function uses a
95      * `revert` opcode (which leaves remaining gas untouched) while Solidity
96      * uses an invalid opcode to revert (consuming all remaining gas).
97      *
98      * Requirements:
99      * - The divisor cannot be zero.
100      */
101     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
102         require(b > 0, errorMessage);
103         uint256 c = a / b;
104         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
105 
106         return c;
107     }
108 
109     /**
110      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
111      * Reverts when dividing by zero.
112      *
113      * Counterpart to Solidity's `%` operator. This function uses a `revert`
114      * opcode (which leaves remaining gas untouched) while Solidity uses an
115      * invalid opcode to revert (consuming all remaining gas).
116      *
117      * Requirements:
118      * - The divisor cannot be zero.
119      */
120     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
121         return mod(a, b, "SafeMath: modulo by zero");
122     }
123 
124     /**
125      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
126      * Reverts with custom message when dividing by zero.
127      *
128      * Counterpart to Solidity's `%` operator. This function uses a `revert`
129      * opcode (which leaves remaining gas untouched) while Solidity uses an
130      * invalid opcode to revert (consuming all remaining gas).
131      *
132      * Requirements:
133      * - The divisor cannot be zero.
134      */
135     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
136         require(b != 0, errorMessage);
137         return a % b;
138     }
139 }
140 
141 library Address {
142     /**
143      * @dev Returns true if `account` is a contract.
144      *
145      * [IMPORTANT]
146      * ====
147      * It is unsafe to assume that an address for which this function returns
148      * false is an externally-owned account (EOA) and not a contract.
149      *
150      * Among others, `isContract` will return false for the following
151      * types of addresses:
152      *
153      *  - an externally-owned account
154      *  - a contract in construction
155      *  - an address where a contract will be created
156      *  - an address where a contract lived, but was destroyed
157      * ====
158      */
159     function isContract(address account) internal view returns (bool) {
160         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
161         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
162         // for accounts without code, i.e. `keccak256('')`
163         bytes32 codehash;
164         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
165         // solhint-disable-next-line no-inline-assembly
166         assembly { codehash := extcodehash(account) }
167         return (codehash != accountHash && codehash != 0x0);
168     }
169 
170     /**
171      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
172      * `recipient`, forwarding all available gas and reverting on errors.
173      *
174      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
175      * of certain opcodes, possibly making contracts go over the 2300 gas limit
176      * imposed by `transfer`, making them unable to receive funds via
177      * `transfer`. {sendValue} removes this limitation.
178      *
179      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
180      *
181      * IMPORTANT: because control is transferred to `recipient`, care must be
182      * taken to not create reentrancy vulnerabilities. Consider using
183      * {ReentrancyGuard} or the
184      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
185      */
186     function sendValue(address payable recipient, uint256 amount) internal {
187         require(address(this).balance >= amount, "Address: insufficient balance");
188 
189         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
190         (bool success, ) = recipient.call{ value: amount }("");
191         require(success, "Address: unable to send value, recipient may have reverted");
192     }
193 }
194 /**
195  * @dev Implementation of the {IERC20} interface.
196  *
197  * This implementation is agnostic to the way tokens are created. This means
198  * that a supply mechanism has to be added in a derived contract using {_mint}.
199  * For a generic mechanism see {ERC20MinterPauser}.
200  *
201  * TIP: For a detailed writeup see our guide
202  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
203  * to implement supply mechanisms].
204  *
205  * We have followed general OpenZeppelin guidelines: functions revert instead
206  * of returning `false` on failure. This behavior is nonetheless conventional
207  * and does not conflict with the expectations of ERC20 applications.
208  *
209  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
210  * This allows applications to reconstruct the allowance for all accounts just
211  * by listening to said events. Other implementations of the EIP may not emit
212  * these events, as it isn't required by the specification.
213  *
214  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
215  * functions have been added to mitigate the well-known issues around setting
216  * allowances. See {IERC20-approve}.
217  */
218  
219  interface IERC20 {
220     /**
221      * @dev Returns the amount of tokens in existence.
222      */
223     function totalSupply() external view returns (uint256);
224 
225     /**
226      * @dev Returns the amount of tokens owned by `account`.
227      */
228     function balanceOf(address account) external view returns (uint256);
229 
230     /**
231      * @dev Moves `amount` tokens from the caller's account to `recipient`.
232      *
233      * Returns a boolean value indicating whether the operation succeeded.
234      *
235      * Emits a {Transfer} event.
236      */
237     function transfer(address recipient, uint256 amount) external returns (bool);
238 
239     /**
240      * @dev Returns the remaining number of tokens that `spender` will be
241      * allowed to spend on behalf of `owner` through {transferFrom}. This is
242      * zero by default.
243      *
244      * This value changes when {approve} or {transferFrom} are called.
245      */
246     function allowance(address owner, address spender) external view returns (uint256);
247 
248     /**
249      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
250      *
251      * Returns a boolean value indicating whether the operation succeeded.
252      *
253      * IMPORTANT: Beware that changing an allowance with this method brings the risk
254      * that someone may use both the old and the new allowance by unfortunate
255      * transaction ordering. One possible solution to mitigate this race
256      * condition is to first reduce the spender's allowance to 0 and set the
257      * desired value afterwards:
258      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
259      *
260      * Emits an {Approval} event.
261      */
262     function approve(address spender, uint256 amount) external returns (bool);
263 
264     /**
265      * @dev Moves `amount` tokens from `sender` to `recipient` using the
266      * allowance mechanism. `amount` is then deducted from the caller's
267      * allowance.
268      *
269      * Returns a boolean value indicating whether the operation succeeded.
270      *
271      * Emits a {Transfer} event.
272      */
273     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
274 
275     /**
276      * @dev Emitted when `value` tokens are moved from one account (`from`) to
277      * another (`to`).
278      *
279      * Note that `value` may be zero.
280      */
281     event Transfer(address indexed from, address indexed to, uint256 value);
282 
283     /**
284      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
285      * a call to {approve}. `value` is the new allowance.
286      */
287     event Approval(address indexed owner, address indexed spender, uint256 value);
288 }
289  
290  abstract contract Context {
291     function _msgSender() internal view virtual returns (address payable) {
292         return msg.sender;
293     }
294 
295     function _msgData() internal view virtual returns (bytes memory) {
296         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
297         return msg.data;
298     }
299 }
300 
301 
302 contract ERC20 is Context, IERC20 {
303     using SafeMath for uint256;
304     using Address for address;
305 
306     mapping (address => uint256) private _balances;
307 
308     mapping (address => mapping (address => uint256)) private _allowances;
309 
310     uint256 private _totalSupply;
311 
312     string private _name;
313     string private _symbol;
314     uint8 private _decimals;
315 
316     /**
317      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
318      * a default value of 18.
319      *
320      * To select a different value for {decimals}, use {_setupDecimals}.
321      *
322      * All three of these values are immutable: they can only be set once during
323      * construction.
324      */
325     constructor (string memory name, string memory symbol) public {
326         _name = name;
327         _symbol = symbol;
328         _decimals = 18;
329     }
330 
331     /**
332      * @dev Returns the name of the token.
333      */
334     function name() public view returns (string memory) {
335         return _name;
336     }
337 
338     /**
339      * @dev Returns the symbol of the token, usually a shorter version of the
340      * name.
341      */
342     function symbol() public view returns (string memory) {
343         return _symbol;
344     }
345 
346     /**
347      * @dev Returns the number of decimals used to get its user representation.
348      * For example, if `decimals` equals `2`, a balance of `505` tokens should
349      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
350      *
351      * Tokens usually opt for a value of 18, imitating the relationship between
352      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
353      * called.
354      *
355      * NOTE: This information is only used for _display_ purposes: it in
356      * no way affects any of the arithmetic of the contract, including
357      * {IERC20-balanceOf} and {IERC20-transfer}.
358      */
359     function decimals() public view returns (uint8) {
360         return _decimals;
361     }
362 
363     /**
364      * @dev See {IERC20-totalSupply}.
365      */
366     function totalSupply() public view override returns (uint256) {
367         return _totalSupply;
368     }
369 
370     /**
371      * @dev See {IERC20-balanceOf}.
372      */
373     function balanceOf(address account) public view override returns (uint256) {
374         return _balances[account];
375     }
376 
377     /**
378      * @dev See {IERC20-transfer}.
379      *
380      * Requirements:
381      *
382      * - `recipient` cannot be the zero address.
383      * - the caller must have a balance of at least `amount`.
384      */
385     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
386         _transfer(_msgSender(), recipient, amount);
387         return true;
388     }
389 
390     /**
391      * @dev See {IERC20-allowance}.
392      */
393     function allowance(address owner, address spender) public view virtual override returns (uint256) {
394         return _allowances[owner][spender];
395     }
396 
397     /**
398      * @dev See {IERC20-approve}.
399      *
400      * Requirements:
401      *
402      * - `spender` cannot be the zero address.
403      */
404     function approve(address spender, uint256 amount) public virtual override returns (bool) {
405         _approve(_msgSender(), spender, amount);
406         return true;
407     }
408 
409     /**
410      * @dev See {IERC20-transferFrom}.
411      *
412      * Emits an {Approval} event indicating the updated allowance. This is not
413      * required by the EIP. See the note at the beginning of {ERC20};
414      *
415      * Requirements:
416      * - `sender` and `recipient` cannot be the zero address.
417      * - `sender` must have a balance of at least `amount`.
418      * - the caller must have allowance for ``sender``'s tokens of at least
419      * `amount`.
420      */
421     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
422         _transfer(sender, recipient, amount);
423         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
424         return true;
425     }
426 
427     /**
428      * @dev Atomically increases the allowance granted to `spender` by the caller.
429      *
430      * This is an alternative to {approve} that can be used as a mitigation for
431      * problems described in {IERC20-approve}.
432      *
433      * Emits an {Approval} event indicating the updated allowance.
434      *
435      * Requirements:
436      *
437      * - `spender` cannot be the zero address.
438      */
439     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
440         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
441         return true;
442     }
443 
444     /**
445      * @dev Atomically decreases the allowance granted to `spender` by the caller.
446      *
447      * This is an alternative to {approve} that can be used as a mitigation for
448      * problems described in {IERC20-approve}.
449      *
450      * Emits an {Approval} event indicating the updated allowance.
451      *
452      * Requirements:
453      *
454      * - `spender` cannot be the zero address.
455      * - `spender` must have allowance for the caller of at least
456      * `subtractedValue`.
457      */
458     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
459         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
460         return true;
461     }
462 
463     /**
464      * @dev Moves tokens `amount` from `sender` to `recipient`.
465      *
466      * This is internal function is equivalent to {transfer}, and can be used to
467      * e.g. implement automatic token fees, slashing mechanisms, etc.
468      *
469      * Emits a {Transfer} event.
470      *
471      * Requirements:
472      *
473      * - `sender` cannot be the zero address.
474      * - `recipient` cannot be the zero address.
475      * - `sender` must have a balance of at least `amount`.
476      */
477     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
478         require(sender != address(0), "ERC20: transfer from the zero address");
479         require(recipient != address(0), "ERC20: transfer to the zero address");
480 
481         _beforeTokenTransfer(sender, recipient, amount);
482 
483         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
484         _balances[recipient] = _balances[recipient].add(amount);
485         emit Transfer(sender, recipient, amount);
486     }
487 
488     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
489      * the total supply.
490      *
491      * Emits a {Transfer} event with `from` set to the zero address.
492      *
493      * Requirements
494      *
495      * - `to` cannot be the zero address.
496      */
497     function _mint(address account, uint256 amount) internal virtual {
498         require(account != address(0), "ERC20: mint to the zero address");
499 
500         _beforeTokenTransfer(address(0), account, amount);
501 
502         _totalSupply = _totalSupply.add(amount);
503         _balances[account] = _balances[account].add(amount);
504         emit Transfer(address(0), account, amount);
505     }
506 
507     /**
508      * @dev Destroys `amount` tokens from `account`, reducing the
509      * total supply.
510      *
511      * Emits a {Transfer} event with `to` set to the zero address.
512      *
513      * Requirements
514      *
515      * - `account` cannot be the zero address.
516      * - `account` must have at least `amount` tokens.
517      */
518     function _burn(address account, uint256 amount) internal virtual {
519         require(account != address(0), "ERC20: burn from the zero address");
520 
521         _beforeTokenTransfer(account, address(0), amount);
522 
523         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
524         _totalSupply = _totalSupply.sub(amount);
525         emit Transfer(account, address(0), amount);
526     }
527 
528     /**
529      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
530      *
531      * This is internal function is equivalent to `approve`, and can be used to
532      * e.g. set automatic allowances for certain subsystems, etc.
533      *
534      * Emits an {Approval} event.
535      *
536      * Requirements:
537      *
538      * - `owner` cannot be the zero address.
539      * - `spender` cannot be the zero address.
540      */
541     function _approve(address owner, address spender, uint256 amount) internal virtual {
542         require(owner != address(0), "ERC20: approve from the zero address");
543         require(spender != address(0), "ERC20: approve to the zero address");
544 
545         _allowances[owner][spender] = amount;
546         emit Approval(owner, spender, amount);
547     }
548 
549     /**
550      * @dev Sets {decimals} to a value other than the default one of 18.
551      *
552      * WARNING: This function should only be called from the constructor. Most
553      * applications that interact with token contracts will not expect
554      * {decimals} to ever change, and may work incorrectly if it does.
555      */
556     function _setupDecimals(uint8 decimals_) internal {
557         _decimals = decimals_;
558     }
559 
560     /**
561      * @dev Hook that is called before any transfer of tokens. This includes
562      * minting and burning.
563      *
564      * Calling conditions:
565      *
566      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
567      * will be to transferred to `to`.
568      * - when `from` is zero, `amount` tokens will be minted for `to`.
569      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
570      * - `from` and `to` are never both zero.
571      *
572      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
573      */
574     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
575 }
576 
577 contract ROCKET is ERC20 {
578     constructor(uint256 initialSupply) ERC20("Rocket", "RCKT") public {
579         _mint(msg.sender, initialSupply);
580     }
581 }