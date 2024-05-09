1 //Reserved for Uniswap Community Network
2 //Do not be fooled by other smart contract, this is the only authentic smart contract for $UCN
3 //All rights reserved 2020
4 
5 
6 
7 
8 
9 
10 
11 
12 
13 
14 
15 
16 
17 
18 
19 
20 
21 
22 
23 
24 
25 pragma solidity ^0.6.0;
26 
27 
28 library SafeMath {
29     /**
30      * @dev Returns the addition of two unsigned integers, reverting on
31      * overflow.
32      *
33      * Counterpart to Solidity's `+` operator.
34      *
35      * Requirements:
36      * - Addition cannot overflow.
37      */
38     function add(uint256 a, uint256 b) internal pure returns (uint256) {
39         uint256 c = a + b;
40         require(c >= a, "SafeMath: addition overflow");
41 
42         return c;
43     }
44 
45     /**
46      * @dev Returns the subtraction of two unsigned integers, reverting on
47      * overflow (when the result is negative).
48      *
49      * Counterpart to Solidity's `-` operator.
50      *
51      * Requirements:
52      * - Subtraction cannot overflow.
53      */
54     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
55         return sub(a, b, "SafeMath: subtraction overflow");
56     }
57 
58     /**
59      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
60      * overflow (when the result is negative).
61      *
62      * Counterpart to Solidity's `-` operator.
63      *
64      * Requirements:
65      * - Subtraction cannot overflow.
66      */
67     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
68         require(b <= a, errorMessage);
69         uint256 c = a - b;
70 
71         return c;
72     }
73 
74     /**
75      * @dev Returns the multiplication of two unsigned integers, reverting on
76      * overflow.
77      *
78      * Counterpart to Solidity's `*` operator.
79      *
80      * Requirements:
81      * - Multiplication cannot overflow.
82      */
83     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
84         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
85         // benefit is lost if 'b' is also tested.
86         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
87         if (a == 0) {
88             return 0;
89         }
90 
91         uint256 c = a * b;
92         require(c / a == b, "SafeMath: multiplication overflow");
93 
94         return c;
95     }
96 
97     /**
98      * @dev Returns the integer division of two unsigned integers. Reverts on
99      * division by zero. The result is rounded towards zero.
100      *
101      * Counterpart to Solidity's `/` operator. Note: this function uses a
102      * `revert` opcode (which leaves remaining gas untouched) while Solidity
103      * uses an invalid opcode to revert (consuming all remaining gas).
104      *
105      * Requirements:
106      * - The divisor cannot be zero.
107      */
108     function div(uint256 a, uint256 b) internal pure returns (uint256) {
109         return div(a, b, "SafeMath: division by zero");
110     }
111 
112     /**
113      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
114      * division by zero. The result is rounded towards zero.
115      *
116      * Counterpart to Solidity's `/` operator. Note: this function uses a
117      * `revert` opcode (which leaves remaining gas untouched) while Solidity
118      * uses an invalid opcode to revert (consuming all remaining gas).
119      *
120      * Requirements:
121      * - The divisor cannot be zero.
122      */
123     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
124         require(b > 0, errorMessage);
125         uint256 c = a / b;
126         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
127 
128         return c;
129     }
130 
131     /**
132      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
133      * Reverts when dividing by zero.
134      *
135      * Counterpart to Solidity's `%` operator. This function uses a `revert`
136      * opcode (which leaves remaining gas untouched) while Solidity uses an
137      * invalid opcode to revert (consuming all remaining gas).
138      *
139      * Requirements:
140      * - The divisor cannot be zero.
141      */
142     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
143         return mod(a, b, "SafeMath: modulo by zero");
144     }
145 
146     /**
147      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
148      * Reverts with custom message when dividing by zero.
149      *
150      * Counterpart to Solidity's `%` operator. This function uses a `revert`
151      * opcode (which leaves remaining gas untouched) while Solidity uses an
152      * invalid opcode to revert (consuming all remaining gas).
153      *
154      * Requirements:
155      * - The divisor cannot be zero.
156      */
157     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
158         require(b != 0, errorMessage);
159         return a % b;
160     }
161 }
162 
163 library Address {
164     /**
165      * @dev Returns true if `account` is a contract.
166      *
167      * [IMPORTANT]
168      * ====
169      * It is unsafe to assume that an address for which this function returns
170      * false is an externally-owned account (EOA) and not a contract.
171      *
172      * Among others, `isContract` will return false for the following
173      * types of addresses:
174      *
175      *  - an externally-owned account
176      *  - a contract in construction
177      *  - an address where a contract will be created
178      *  - an address where a contract lived, but was destroyed
179      * ====
180      */
181     function isContract(address account) internal view returns (bool) {
182         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
183         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
184         // for accounts without code, i.e. `keccak256('')`
185         bytes32 codehash;
186         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
187         // solhint-disable-next-line no-inline-assembly
188         assembly { codehash := extcodehash(account) }
189         return (codehash != accountHash && codehash != 0x0);
190     }
191 
192     /**
193      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
194      * `recipient`, forwarding all available gas and reverting on errors.
195      *
196      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
197      * of certain opcodes, possibly making contracts go over the 2300 gas limit
198      * imposed by `transfer`, making them unable to receive funds via
199      * `transfer`. {sendValue} removes this limitation.
200      *
201      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
202      *
203      * IMPORTANT: because control is transferred to `recipient`, care must be
204      * taken to not create reentrancy vulnerabilities. Consider using
205      * {ReentrancyGuard} or the
206      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
207      */
208    
209 }
210 /**
211  * @dev Implementation of the {IERC20} interface.
212  *
213  * This implementation is agnostic to the way tokens are created. This means
214  * that a supply mechanism has to be added in a derived contract using {_mint}.
215  * For a generic mechanism see {ERC20MinterPauser}.
216  *
217  * TIP: For a detailed writeup see our guide
218  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
219  * to implement supply mechanisms].
220  *
221  * We have followed general OpenZeppelin guidelines: functions revert instead
222  * of returning `false` on failure. This behavior is nonetheless conventional
223  * and does not conflict with the expectations of ERC20 applications.
224  *
225  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
226  * This allows applications to reconstruct the allowance for all accounts just
227  * by listening to said events. Other implementations of the EIP may not emit
228  * these events, as it isn't required by the specification.
229  *
230  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
231  * functions have been added to mitigate the well-known issues around setting
232  * allowances. See {IERC20-approve}.
233  */
234  
235  interface IERC20 {
236     /**
237      * @dev Returns the amount of tokens in existence.
238      */
239     function totalSupply() external view returns (uint256);
240 
241     /**
242      * @dev Returns the amount of tokens owned by `account`.
243      */
244     function balanceOf(address account) external view returns (uint256);
245 
246     /**
247      * @dev Moves `amount` tokens from the caller's account to `recipient`.
248      *
249      * Returns a boolean value indicating whether the operation succeeded.
250      *
251      * Emits a {Transfer} event.
252      */
253     function transfer(address recipient, uint256 amount) external returns (bool);
254 
255     /**
256      * @dev Returns the remaining number of tokens that `spender` will be
257      * allowed to spend on behalf of `owner` through {transferFrom}. This is
258      * zero by default.
259      *
260      * This value changes when {approve} or {transferFrom} are called.
261      */
262     function allowance(address owner, address spender) external view returns (uint256);
263 
264     /**
265      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
266      *
267      * Returns a boolean value indicating whether the operation succeeded.
268      *
269      * IMPORTANT: Beware that changing an allowance with this method brings the risk
270      * that someone may use both the old and the new allowance by unfortunate
271      * transaction ordering. One possible solution to mitigate this race
272      * condition is to first reduce the spender's allowance to 0 and set the
273      * desired value afterwards:
274      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
275      *
276      * Emits an {Approval} event.
277      */
278     function approve(address spender, uint256 amount) external returns (bool);
279 
280     /**
281      * @dev Moves `amount` tokens from `sender` to `recipient` using the
282      * allowance mechanism. `amount` is then deducted from the caller's
283      * allowance.
284      *
285      * Returns a boolean value indicating whether the operation succeeded.
286      *
287      * Emits a {Transfer} event.
288      */
289     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
290 
291     /**
292      * @dev Emitted when `value` tokens are moved from one account (`from`) to
293      * another (`to`).
294      *
295      * Note that `value` may be zero.
296      */
297     event Transfer(address indexed from, address indexed to, uint256 value);
298 
299     /**
300      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
301      * a call to {approve}. `value` is the new allowance.
302      */
303     event Approval(address indexed owner, address indexed spender, uint256 value);
304 }
305  
306  abstract contract Context {
307     function _msgSender() internal view virtual returns (address payable) {
308         return msg.sender;
309     }
310 
311     function _msgData() internal view virtual returns (bytes memory) {
312         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
313         return msg.data;
314     }
315 }
316 
317 
318 contract ERC20 is Context, IERC20 {
319     using SafeMath for uint256;
320     using Address for address;
321 
322     mapping (address => uint256) private _balances;
323 
324     mapping (address => mapping (address => uint256)) private _allowances;
325 
326     uint256 private _totalSupply;
327 
328     string private _name;
329     string private _symbol;
330     uint8 private _decimals;
331 
332     /**
333      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
334      * a default value of 18.
335      *
336      * To select a different value for {decimals}, use {_setupDecimals}.
337      *
338      * All three of these values are immutable: they can only be set once during
339      * construction.
340      */
341     constructor (string memory name, string memory symbol) public {
342         _name = name;
343         _symbol = symbol;
344         _decimals = 18;
345     }
346 
347     /**
348      * @dev Returns the name of the token.
349      */
350     function name() public view returns (string memory) {
351         return _name;
352     }
353 
354     /**
355      * @dev Returns the symbol of the token, usually a shorter version of the
356      * name.
357      */
358     function symbol() public view returns (string memory) {
359         return _symbol;
360     }
361 
362     /**
363      * @dev Returns the number of decimals used to get its user representation.
364      * For example, if `decimals` equals `2`, a balance of `505` tokens should
365      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
366      *
367      * Tokens usually opt for a value of 18, imitating the relationship between
368      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
369      * called.
370      *
371      * NOTE: This information is only used for _display_ purposes: it in
372      * no way affects any of the arithmetic of the contract, including
373      * {IERC20-balanceOf} and {IERC20-transfer}.
374      */
375     function decimals() public view returns (uint8) {
376         return _decimals;
377     }
378 
379     /**
380      * @dev See {IERC20-totalSupply}.
381      */
382     function totalSupply() public view override returns (uint256) {
383         return _totalSupply;
384     }
385 
386     /**
387      * @dev See {IERC20-balanceOf}.
388      */
389     function balanceOf(address account) public view override returns (uint256) {
390         return _balances[account];
391     }
392 
393     /**
394      * @dev See {IERC20-transfer}.
395      *
396      * Requirements:
397      *
398      * - `recipient` cannot be the zero address.
399      * - the caller must have a balance of at least `amount`.
400      */
401     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
402         _transfer(_msgSender(), recipient, amount);
403         return true;
404     }
405 
406     /**
407      * @dev See {IERC20-allowance}.
408      */
409     function allowance(address owner, address spender) public view virtual override returns (uint256) {
410         return _allowances[owner][spender];
411     }
412 
413     /**
414      * @dev See {IERC20-approve}.
415      *
416      * Requirements:
417      *
418      * - `spender` cannot be the zero address.
419      */
420     function approve(address spender, uint256 amount) public virtual override returns (bool) {
421         _approve(_msgSender(), spender, amount);
422         return true;
423     }
424 
425     /**
426      * @dev See {IERC20-transferFrom}.
427      *
428      * Emits an {Approval} event indicating the updated allowance. This is not
429      * required by the EIP. See the note at the beginning of {ERC20};
430      *
431      * Requirements:
432      * - `sender` and `recipient` cannot be the zero address.
433      * - `sender` must have a balance of at least `amount`.
434      * - the caller must have allowance for ``sender``'s tokens of at least
435      * `amount`.
436      */
437     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
438         _transfer(sender, recipient, amount);
439         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
440         return true;
441     }
442 
443     /**
444      * @dev Atomically increases the allowance granted to `spender` by the caller.
445      *
446      * This is an alternative to {approve} that can be used as a mitigation for
447      * problems described in {IERC20-approve}.
448      *
449      * Emits an {Approval} event indicating the updated allowance.
450      *
451      * Requirements:
452      *
453      * - `spender` cannot be the zero address.
454      */
455     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
456         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
457         return true;
458     }
459 
460     /**
461      * @dev Atomically decreases the allowance granted to `spender` by the caller.
462      *
463      * This is an alternative to {approve} that can be used as a mitigation for
464      * problems described in {IERC20-approve}.
465      *
466      * Emits an {Approval} event indicating the updated allowance.
467      *
468      * Requirements:
469      *
470      * - `spender` cannot be the zero address.
471      * - `spender` must have allowance for the caller of at least
472      * `subtractedValue`.
473      */
474     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
475         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
476         return true;
477     }
478 
479     /**
480      * @dev Moves tokens `amount` from `sender` to `recipient`.
481      *
482      * This is internal function is equivalent to {transfer}, and can be used to
483      * e.g. implement automatic token fees, slashing mechanisms, etc.
484      *
485      * Emits a {Transfer} event.
486      *
487      * Requirements:
488      *
489      * - `sender` cannot be the zero address.
490      * - `recipient` cannot be the zero address.
491      * - `sender` must have a balance of at least `amount`.
492      */
493     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
494         require(sender != address(0), "ERC20: transfer from the zero address");
495         require(recipient != address(0), "ERC20: transfer to the zero address");
496 
497         _beforeTokenTransfer(sender, recipient, amount);
498 
499         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
500         _balances[recipient] = _balances[recipient].add(amount);
501         emit Transfer(sender, recipient, amount);
502     }
503 
504     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
505      * the total supply.
506      *
507      * Emits a {Transfer} event with `from` set to the zero address.
508      *
509      * Requirements
510      *
511      * - `to` cannot be the zero address.
512      */
513     function _mint(address account, uint256 amount) internal virtual {
514         require(account != address(0), "ERC20: mint to the zero address");
515 
516         _beforeTokenTransfer(address(0), account, amount);
517 
518         _totalSupply = _totalSupply.add(amount);
519         _balances[account] = _balances[account].add(amount);
520         emit Transfer(address(0), account, amount);
521     }
522 
523     /**
524      * @dev Destroys `amount` tokens from `account`, reducing the
525      * total supply.
526      *
527      * Emits a {Transfer} event with `to` set to the zero address.
528      *
529      * Requirements
530      *
531      * - `account` cannot be the zero address.
532      * - `account` must have at least `amount` tokens.
533      */
534     function _burn(address account, uint256 amount) internal virtual {
535         require(account != address(0), "ERC20: burn from the zero address");
536 
537         _beforeTokenTransfer(account, address(0), amount);
538 
539         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
540         _totalSupply = _totalSupply.sub(amount);
541         emit Transfer(account, address(0), amount);
542     }
543 
544     /**
545      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
546      *
547      * This is internal function is equivalent to `approve`, and can be used to
548      * e.g. set automatic allowances for certain subsystems, etc.
549      *
550      * Emits an {Approval} event.
551      *
552      * Requirements:
553      *
554      * - `owner` cannot be the zero address.
555      * - `spender` cannot be the zero address.
556      */
557     function _approve(address owner, address spender, uint256 amount) internal virtual {
558         require(owner != address(0), "ERC20: approve from the zero address");
559         require(spender != address(0), "ERC20: approve to the zero address");
560 
561         _allowances[owner][spender] = amount;
562         emit Approval(owner, spender, amount);
563     }
564 
565     /**
566      * @dev Sets {decimals} to a value other than the default one of 18.
567      *
568      * WARNING: This function should only be called from the constructor. Most
569      * applications that interact with token contracts will not expect
570      * {decimals} to ever change, and may work incorrectly if it does.
571      */
572     function _setupDecimals(uint8 decimals_) internal {
573         _decimals = decimals_;
574     }
575 
576     /**
577      * @dev Hook that is called before any transfer of tokens. This includes
578      * minting and burning.
579      *
580      * Calling conditions:
581      *
582      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
583      * will be to transferred to `to`.
584      * - when `from` is zero, `amount` tokens will be minted for `to`.
585      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
586      * - `from` and `to` are never both zero.
587      *
588      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
589      */
590     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
591 }
592 
593 contract UCN is ERC20 {
594     constructor(uint256 initialSupply) ERC20("Uniswap Community Network", "UCN") public {
595         _mint(msg.sender, initialSupply);
596     }
597 }