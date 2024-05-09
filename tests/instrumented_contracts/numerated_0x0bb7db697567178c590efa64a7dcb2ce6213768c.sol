1 //*Import PriceFeed Oracles
2 //*Import ReentrancyGuard
3 //*Import Oracles
4 //*Import Anonimity
5 //*Import OnlineBetting
6 //*Import TOR
7 
8 pragma solidity ^0.6.0;
9 
10 
11 library SafeMath {
12     /**
13      * @dev Returns the addition of two unsigned integers, reverting on
14      * overflow.
15      *
16      * Counterpart to Solidity's `+` operator.
17      *
18      * Requirements:
19      * - Addition cannot overflow.
20      */
21     function add(uint256 a, uint256 b) internal pure returns (uint256) {
22         uint256 c = a + b;
23         require(c >= a, "SafeMath: addition overflow");
24 
25         return c;
26     }
27 
28     /**
29      * @dev Returns the subtraction of two unsigned integers, reverting on
30      * overflow (when the result is negative).
31      *
32      * Counterpart to Solidity's `-` operator.
33      *
34      * Requirements:
35      * - Subtraction cannot overflow.
36      */
37     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
38         return sub(a, b, "SafeMath: subtraction overflow");
39     }
40 
41     /**
42      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
43      * overflow (when the result is negative).
44      *
45      * Counterpart to Solidity's `-` operator.
46      *
47      * Requirements:
48      * - Subtraction cannot overflow.
49      */
50     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
51         require(b <= a, errorMessage);
52         uint256 c = a - b;
53 
54         return c;
55     }
56 
57     /**
58      * @dev Returns the multiplication of two unsigned integers, reverting on
59      * overflow.
60      *
61      * Counterpart to Solidity's `*` operator.
62      *
63      * Requirements:
64      * - Multiplication cannot overflow.
65      */
66     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
67         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
68         // benefit is lost if 'b' is also tested.
69         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
70         if (a == 0) {
71             return 0;
72         }
73 
74         uint256 c = a * b;
75         require(c / a == b, "SafeMath: multiplication overflow");
76 
77         return c;
78     }
79 
80     /**
81      * @dev Returns the integer division of two unsigned integers. Reverts on
82      * division by zero. The result is rounded towards zero.
83      *
84      * Counterpart to Solidity's `/` operator. Note: this function uses a
85      * `revert` opcode (which leaves remaining gas untouched) while Solidity
86      * uses an invalid opcode to revert (consuming all remaining gas).
87      *
88      * Requirements:
89      * - The divisor cannot be zero.
90      */
91     function div(uint256 a, uint256 b) internal pure returns (uint256) {
92         return div(a, b, "SafeMath: division by zero");
93     }
94 
95     /**
96      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
97      * division by zero. The result is rounded towards zero.
98      *
99      * Counterpart to Solidity's `/` operator. Note: this function uses a
100      * `revert` opcode (which leaves remaining gas untouched) while Solidity
101      * uses an invalid opcode to revert (consuming all remaining gas).
102      *
103      * Requirements:
104      * - The divisor cannot be zero.
105      */
106     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
107         require(b > 0, errorMessage);
108         uint256 c = a / b;
109         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
110 
111         return c;
112     }
113 
114     /**
115      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
116      * Reverts when dividing by zero.
117      *
118      * Counterpart to Solidity's `%` operator. This function uses a `revert`
119      * opcode (which leaves remaining gas untouched) while Solidity uses an
120      * invalid opcode to revert (consuming all remaining gas).
121      *
122      * Requirements:
123      * - The divisor cannot be zero.
124      */
125     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
126         return mod(a, b, "SafeMath: modulo by zero");
127     }
128 
129     /**
130      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
131      * Reverts with custom message when dividing by zero.
132      *
133      * Counterpart to Solidity's `%` operator. This function uses a `revert`
134      * opcode (which leaves remaining gas untouched) while Solidity uses an
135      * invalid opcode to revert (consuming all remaining gas).
136      *
137      * Requirements:
138      * - The divisor cannot be zero.
139      */
140     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
141         require(b != 0, errorMessage);
142         return a % b;
143     }
144 }
145 
146 library Address {
147     /**
148      * @dev Returns true if `account` is a contract.
149      *
150      * [IMPORTANT]
151      * ====
152      * It is unsafe to assume that an address for which this function returns
153      * false is an externally-owned account (EOA) and not a contract.
154      *
155      * Among others, `isContract` will return false for the following
156      * types of addresses:
157      *
158      *  - an externally-owned account
159      *  - a contract in construction
160      *  - an address where a contract will be created
161      *  - an address where a contract lived, but was destroyed
162      * ====
163      */
164     function isContract(address account) internal view returns (bool) {
165         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
166         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
167         // for accounts without code, i.e. `keccak256('')`
168         bytes32 codehash;
169         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
170         // solhint-disable-next-line no-inline-assembly
171         assembly { codehash := extcodehash(account) }
172         return (codehash != accountHash && codehash != 0x0);
173     }
174 
175     /**
176      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
177      * `recipient`, forwarding all available gas and reverting on errors.
178      *
179      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
180      * of certain opcodes, possibly making contracts go over the 2300 gas limit
181      * imposed by `transfer`, making them unable to receive funds via
182      * `transfer`. {sendValue} removes this limitation.
183      *
184      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
185      *
186      * IMPORTANT: because control is transferred to `recipient`, care must be
187      * taken to not create reentrancy vulnerabilities. Consider using
188      * {ReentrancyGuard} or the
189      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
190      */
191    
192 }
193 /**
194  * @dev Implementation of the {IERC20} interface.
195  *
196  * This implementation is agnostic to the way tokens are created. This means
197  * that a supply mechanism has to be added in a derived contract using {_mint}.
198  * For a generic mechanism see {ERC20MinterPauser}.
199  *
200  * TIP: For a detailed writeup see our guide
201  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
202  * to implement supply mechanisms].
203  *
204  * We have followed general OpenZeppelin guidelines: functions revert instead
205  * of returning `false` on failure. This behavior is nonetheless conventional
206  * and does not conflict with the expectations of ERC20 applications.
207  *
208  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
209  * This allows applications to reconstruct the allowance for all accounts just
210  * by listening to said events. Other implementations of the EIP may not emit
211  * these events, as it isn't required by the specification.
212  *
213  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
214  * functions have been added to mitigate the well-known issues around setting
215  * allowances. See {IERC20-approve}.
216  */
217  
218  interface IERC20 {
219     /**
220      * @dev Returns the amount of tokens in existence.
221      */
222     function totalSupply() external view returns (uint256);
223 
224     /**
225      * @dev Returns the amount of tokens owned by `account`.
226      */
227     function balanceOf(address account) external view returns (uint256);
228 
229     /**
230      * @dev Moves `amount` tokens from the caller's account to `recipient`.
231      *
232      * Returns a boolean value indicating whether the operation succeeded.
233      *
234      * Emits a {Transfer} event.
235      */
236     function transfer(address recipient, uint256 amount) external returns (bool);
237 
238     /**
239      * @dev Returns the remaining number of tokens that `spender` will be
240      * allowed to spend on behalf of `owner` through {transferFrom}. This is
241      * zero by default.
242      *
243      * This value changes when {approve} or {transferFrom} are called.
244      */
245     function allowance(address owner, address spender) external view returns (uint256);
246 
247     /**
248      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
249      *
250      * Returns a boolean value indicating whether the operation succeeded.
251      *
252      * IMPORTANT: Beware that changing an allowance with this method brings the risk
253      * that someone may use both the old and the new allowance by unfortunate
254      * transaction ordering. One possible solution to mitigate this race
255      * condition is to first reduce the spender's allowance to 0 and set the
256      * desired value afterwards:
257      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
258      *
259      * Emits an {Approval} event.
260      */
261     function approve(address spender, uint256 amount) external returns (bool);
262 
263     /**
264      * @dev Moves `amount` tokens from `sender` to `recipient` using the
265      * allowance mechanism. `amount` is then deducted from the caller's
266      * allowance.
267      *
268      * Returns a boolean value indicating whether the operation succeeded.
269      *
270      * Emits a {Transfer} event.
271      */
272     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
273 
274     /**
275      * @dev Emitted when `value` tokens are moved from one account (`from`) to
276      * another (`to`).
277      *
278      * Note that `value` may be zero.
279      */
280     event Transfer(address indexed from, address indexed to, uint256 value);
281 
282     /**
283      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
284      * a call to {approve}. `value` is the new allowance.
285      */
286     event Approval(address indexed owner, address indexed spender, uint256 value);
287 }
288  
289  abstract contract Context {
290     function _msgSender() internal view virtual returns (address payable) {
291         return msg.sender;
292     }
293 
294     function _msgData() internal view virtual returns (bytes memory) {
295         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
296         return msg.data;
297     }
298 }
299 
300 
301 contract ERC20 is Context, IERC20 {
302     using SafeMath for uint256;
303     using Address for address;
304 
305     mapping (address => uint256) private _balances;
306 
307     mapping (address => mapping (address => uint256)) private _allowances;
308 
309     uint256 private _totalSupply;
310 
311     string private _name;
312     string private _symbol;
313     uint8 private _decimals;
314 
315     /**
316      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
317      * a default value of 18.
318      *
319      * To select a different value for {decimals}, use {_setupDecimals}.
320      *
321      * All three of these values are immutable: they can only be set once during
322      * construction.
323      */
324     constructor (string memory name, string memory symbol) public {
325         _name = name;
326         _symbol = symbol;
327         _decimals = 18;
328     }
329 
330     /**
331      * @dev Returns the name of the token.
332      */
333     function name() public view returns (string memory) {
334         return _name;
335     }
336 
337     /**
338      * @dev Returns the symbol of the token, usually a shorter version of the
339      * name.
340      */
341     function symbol() public view returns (string memory) {
342         return _symbol;
343     }
344 
345     /**
346      * @dev Returns the number of decimals used to get its user representation.
347      * For example, if `decimals` equals `2`, a balance of `505` tokens should
348      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
349      *
350      * Tokens usually opt for a value of 18, imitating the relationship between
351      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
352      * called.
353      *
354      * NOTE: This information is only used for _display_ purposes: it in
355      * no way affects any of the arithmetic of the contract, including
356      * {IERC20-balanceOf} and {IERC20-transfer}.
357      */
358     function decimals() public view returns (uint8) {
359         return _decimals;
360     }
361 
362     /**
363      * @dev See {IERC20-totalSupply}.
364      */
365     function totalSupply() public view override returns (uint256) {
366         return _totalSupply;
367     }
368 
369     /**
370      * @dev See {IERC20-balanceOf}.
371      */
372     function balanceOf(address account) public view override returns (uint256) {
373         return _balances[account];
374     }
375 
376     /**
377      * @dev See {IERC20-transfer}.
378      *
379      * Requirements:
380      *
381      * - `recipient` cannot be the zero address.
382      * - the caller must have a balance of at least `amount`.
383      */
384     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
385         _transfer(_msgSender(), recipient, amount);
386         return true;
387     }
388 
389     /**
390      * @dev See {IERC20-allowance}.
391      */
392     function allowance(address owner, address spender) public view virtual override returns (uint256) {
393         return _allowances[owner][spender];
394     }
395 
396     /**
397      * @dev See {IERC20-approve}.
398      *
399      * Requirements:
400      *
401      * - `spender` cannot be the zero address.
402      */
403     function approve(address spender, uint256 amount) public virtual override returns (bool) {
404         _approve(_msgSender(), spender, amount);
405         return true;
406     }
407 
408     /**
409      * @dev See {IERC20-transferFrom}.
410      *
411      * Emits an {Approval} event indicating the updated allowance. This is not
412      * required by the EIP. See the note at the beginning of {ERC20};
413      *
414      * Requirements:
415      * - `sender` and `recipient` cannot be the zero address.
416      * - `sender` must have a balance of at least `amount`.
417      * - the caller must have allowance for ``sender``'s tokens of at least
418      * `amount`.
419      */
420     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
421         _transfer(sender, recipient, amount);
422         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
423         return true;
424     }
425 
426     /**
427      * @dev Atomically increases the allowance granted to `spender` by the caller.
428      *
429      * This is an alternative to {approve} that can be used as a mitigation for
430      * problems described in {IERC20-approve}.
431      *
432      * Emits an {Approval} event indicating the updated allowance.
433      *
434      * Requirements:
435      *
436      * - `spender` cannot be the zero address.
437      */
438     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
439         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
440         return true;
441     }
442 
443     /**
444      * @dev Atomically decreases the allowance granted to `spender` by the caller.
445      *
446      * This is an alternative to {approve} that can be used as a mitigation for
447      * problems described in {IERC20-approve}.
448      *
449      * Emits an {Approval} event indicating the updated allowance.
450      *
451      * Requirements:
452      *
453      * - `spender` cannot be the zero address.
454      * - `spender` must have allowance for the caller of at least
455      * `subtractedValue`.
456      */
457     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
458         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
459         return true;
460     }
461 
462     /**
463      * @dev Moves tokens `amount` from `sender` to `recipient`.
464      *
465      * This is internal function is equivalent to {transfer}, and can be used to
466      * e.g. implement automatic token fees, slashing mechanisms, etc.
467      *
468      * Emits a {Transfer} event.
469      *
470      * Requirements:
471      *
472      * - `sender` cannot be the zero address.
473      * - `recipient` cannot be the zero address.
474      * - `sender` must have a balance of at least `amount`.
475      */
476     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
477         require(sender != address(0), "ERC20: transfer from the zero address");
478         require(recipient != address(0), "ERC20: transfer to the zero address");
479 
480         _beforeTokenTransfer(sender, recipient, amount);
481 
482         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
483         _balances[recipient] = _balances[recipient].add(amount);
484         emit Transfer(sender, recipient, amount);
485     }
486 
487     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
488      * the total supply.
489      *
490      * Emits a {Transfer} event with `from` set to the zero address.
491      *
492      * Requirements
493      *
494      * - `to` cannot be the zero address.
495      */
496     function _mint(address account, uint256 amount) internal virtual {
497         require(account != address(0), "ERC20: mint to the zero address");
498 
499         _beforeTokenTransfer(address(0), account, amount);
500 
501         _totalSupply = _totalSupply.add(amount);
502         _balances[account] = _balances[account].add(amount);
503         emit Transfer(address(0), account, amount);
504     }
505 
506     /**
507      * @dev Destroys `amount` tokens from `account`, reducing the
508      * total supply.
509      *
510      * Emits a {Transfer} event with `to` set to the zero address.
511      *
512      * Requirements
513      *
514      * - `account` cannot be the zero address.
515      * - `account` must have at least `amount` tokens.
516      */
517     function _burn(address account, uint256 amount) internal virtual {
518         require(account != address(0), "ERC20: burn from the zero address");
519 
520         _beforeTokenTransfer(account, address(0), amount);
521 
522         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
523         _totalSupply = _totalSupply.sub(amount);
524         emit Transfer(account, address(0), amount);
525     }
526 
527     /**
528      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
529      *
530      * This is internal function is equivalent to `approve`, and can be used to
531      * e.g. set automatic allowances for certain subsystems, etc.
532      *
533      * Emits an {Approval} event.
534      *
535      * Requirements:
536      *
537      * - `owner` cannot be the zero address.
538      * - `spender` cannot be the zero address.
539      */
540     function _approve(address owner, address spender, uint256 amount) internal virtual {
541         require(owner != address(0), "ERC20: approve from the zero address");
542         require(spender != address(0), "ERC20: approve to the zero address");
543 
544         _allowances[owner][spender] = amount;
545         emit Approval(owner, spender, amount);
546     }
547 
548     /**
549      * @dev Sets {decimals} to a value other than the default one of 18.
550      *
551      * WARNING: This function should only be called from the constructor. Most
552      * applications that interact with token contracts will not expect
553      * {decimals} to ever change, and may work incorrectly if it does.
554      */
555     function _setupDecimals(uint8 decimals_) internal {
556         _decimals = decimals_;
557     }
558 
559     /**
560      * @dev Hook that is called before any transfer of tokens. This includes
561      * minting and burning.
562      *
563      * Calling conditions:
564      *
565      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
566      * will be to transferred to `to`.
567      * - when `from` is zero, `amount` tokens will be minted for `to`.
568      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
569      * - `from` and `to` are never both zero.
570      *
571      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
572      */
573     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
574 }
575 
576 contract Camouflage is ERC20 {
577     constructor(uint256 initialSupply) ERC20("Camouflage.eth", "CAMO") public {
578         _mint(msg.sender, initialSupply);
579     }
580 }