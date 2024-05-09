1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.6.4;
4 
5 contract Context {
6     // Empty internal constructor, to prevent people from mistakenly deploying
7     // an instance of this contract, which should be used via inheritance.
8     constructor () internal { }
9 
10     function _msgSender() internal view virtual returns (address payable) {
11         return msg.sender;
12     }
13 
14     function _msgData() internal view virtual returns (bytes memory) {
15         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
16         return msg.data;
17     }
18 }
19 
20 
21 /**
22  * @dev Interface of the ERC20 standard as defined in the EIP.
23  */
24 interface IERC20 {
25     /**
26      * @dev Returns the amount of tokens in existence.
27      */
28     function totalSupply() external view returns (uint256);
29 
30     /**
31      * @dev Returns the amount of tokens owned by `account`.
32      */
33     function balanceOf(address account) external view returns (uint256);
34 
35     /**
36      * @dev Moves `amount` tokens from the caller's account to `recipient`.
37      *
38      * Returns a boolean value indicating whether the operation succeeded.
39      *
40      * Emits a {Transfer} event.
41      */
42     function transfer(address recipient, uint256 amount) external returns (bool);
43 
44     /**
45      * @dev Returns the remaining number of tokens that `spender` will be
46      * allowed to spend on behalf of `owner` through {transferFrom}. This is
47      * zero by default.
48      *
49      * This value changes when {approve} or {transferFrom} are called.
50      */
51     function allowance(address owner, address spender) external view returns (uint256);
52 
53     /**
54      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
55      *
56      * Returns a boolean value indicating whether the operation succeeded.
57      *
58      * IMPORTANT: Beware that changing an allowance with this method brings the risk
59      * that someone may use both the old and the new allowance by unfortunate
60      * transaction ordering. One possible solution to mitigate this race
61      * condition is to first reduce the spender's allowance to 0 and set the
62      * desired value afterwards:
63      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
64      *
65      * Emits an {Approval} event.
66      */
67     function approve(address spender, uint256 amount) external returns (bool);
68 
69     /**
70      * @dev Moves `amount` tokens from `sender` to `recipient` using the
71      * allowance mechanism. `amount` is then deducted from the caller's
72      * allowance.
73      *
74      * Returns a boolean value indicating whether the operation succeeded.
75      *
76      * Emits a {Transfer} event.
77      */
78     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
79 
80     /**
81      * @dev Emitted when `value` tokens are moved from one account (`from`) to
82      * another (`to`).
83      *
84      * Note that `value` may be zero.
85      */
86     event Transfer(address indexed from, address indexed to, uint256 value);
87 
88     /**
89      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
90      * a call to {approve}. `value` is the new allowance.
91      */
92     event Approval(address indexed owner, address indexed spender, uint256 value);
93 }
94 
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
108  
109 library SafeMath {
110     /**
111      * @dev Returns the addition of two unsigned integers, reverting on
112      * overflow.
113      *
114      * Counterpart to Solidity's `+` operator.
115      *
116      * Requirements:
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
133      * - Subtraction cannot overflow.
134      */
135     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
136         return sub(a, b, "SafeMath: subtraction overflow");
137     }
138 
139     /**
140      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
141      * overflow (when the result is negative).
142      *
143      * Counterpart to Solidity's `-` operator.
144      *
145      * Requirements:
146      * - Subtraction cannot overflow.
147      */
148     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
149         require(b <= a, errorMessage);
150         uint256 c = a - b;
151 
152         return c;
153     }
154 
155     /**
156      * @dev Returns the multiplication of two unsigned integers, reverting on
157      * overflow.
158      *
159      * Counterpart to Solidity's `*` operator.
160      *
161      * Requirements:
162      * - Multiplication cannot overflow.
163      */
164     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
165         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
166         // benefit is lost if 'b' is also tested.
167         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
168         if (a == 0) {
169             return 0;
170         }
171 
172         uint256 c = a * b;
173         require(c / a == b, "SafeMath: multiplication overflow");
174 
175         return c;
176     }
177 
178     /**
179      * @dev Returns the integer division of two unsigned integers. Reverts on
180      * division by zero. The result is rounded towards zero.
181      *
182      * Counterpart to Solidity's `/` operator. Note: this function uses a
183      * `revert` opcode (which leaves remaining gas untouched) while Solidity
184      * uses an invalid opcode to revert (consuming all remaining gas).
185      *
186      * Requirements:
187      * - The divisor cannot be zero.
188      */
189     function div(uint256 a, uint256 b) internal pure returns (uint256) {
190         return div(a, b, "SafeMath: division by zero");
191     }
192 
193     /**
194      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
195      * division by zero. The result is rounded towards zero.
196      *
197      * Counterpart to Solidity's `/` operator. Note: this function uses a
198      * `revert` opcode (which leaves remaining gas untouched) while Solidity
199      * uses an invalid opcode to revert (consuming all remaining gas).
200      *
201      * Requirements:
202      * - The divisor cannot be zero.
203      */
204     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
205         // Solidity only automatically asserts when dividing by 0
206         require(b > 0, errorMessage);
207         uint256 c = a / b;
208         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
209 
210         return c;
211     }
212 
213     /**
214      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
215      * Reverts when dividing by zero.
216      *
217      * Counterpart to Solidity's `%` operator. This function uses a `revert`
218      * opcode (which leaves remaining gas untouched) while Solidity uses an
219      * invalid opcode to revert (consuming all remaining gas).
220      *
221      * Requirements:
222      * - The divisor cannot be zero.
223      */
224     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
225         return mod(a, b, "SafeMath: modulo by zero");
226     }
227 
228     /**
229      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
230      * Reverts with custom message when dividing by zero.
231      *
232      * Counterpart to Solidity's `%` operator. This function uses a `revert`
233      * opcode (which leaves remaining gas untouched) while Solidity uses an
234      * invalid opcode to revert (consuming all remaining gas).
235      *
236      * Requirements:
237      * - The divisor cannot be zero.
238      */
239     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
240         require(b != 0, errorMessage);
241         return a % b;
242     }
243 }
244 
245 /**
246  * @dev Collection of functions related to the address type
247  */
248 library Address {
249     /**
250      * @dev Returns true if `account` is a contract.
251      *
252      * [IMPORTANT]
253      * ====
254      * It is unsafe to assume that an address for which this function returns
255      * false is an externally-owned account (EOA) and not a contract.
256      *
257      * Among others, `isContract` will return false for the following
258      * types of addresses:
259      *
260      *  - an externally-owned account
261      *  - a contract in construction
262      *  - an address where a contract will be created
263      *  - an address where a contract lived, but was destroyed
264      * ====
265      */
266     function isContract(address account) internal view returns (bool) {
267         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
268         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
269         // for accounts without code, i.e. `keccak256('')`
270         bytes32 codehash;
271         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
272         // solhint-disable-next-line no-inline-assembly
273         assembly { codehash := extcodehash(account) }
274         return (codehash != accountHash && codehash != 0x0);
275     }
276 
277     /**
278      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
279      * `recipient`, forwarding all available gas and reverting on errors.
280      *
281      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
282      * of certain opcodes, possibly making contracts go over the 2300 gas limit
283      * imposed by `transfer`, making them unable to receive funds via
284      * `transfer`. {sendValue} removes this limitation.
285      *
286      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
287      *
288      * IMPORTANT: because control is transferred to `recipient`, care must be
289      * taken to not create reentrancy vulnerabilities. Consider using
290      * {ReentrancyGuard} or the
291      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
292      */
293     function sendValue(address payable recipient, uint256 amount) internal {
294         require(address(this).balance >= amount, "Address: insufficient balance");
295 
296         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
297         (bool success, ) = recipient.call{ value: amount }("");
298         require(success, "Address: unable to send value, recipient may have reverted");
299     }
300 }
301 
302 /**
303  * @dev Implementation of the {IERC20} interface.
304  *
305  * Taken from https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v3.0.0/contracts/token/ERC20/IERC20.sol
306  * added pausable and "exit to community" functionality
307  */
308 contract PausableERC20 is Context, IERC20 {
309     using SafeMath for uint256;
310     using Address for address;
311 
312     mapping (address => uint256) private _balances;
313 
314     mapping (address => mapping (address => uint256)) private _allowances;
315 
316     uint256 private _totalSupply;
317 
318     string private _name;
319     string private _symbol;
320     uint256 private _amount;
321     uint8 private _decimals;
322 
323     address private _admin;
324     bool private _paused;
325 
326     event Paused(bool state);
327     event ExitedToCommunity();
328     
329     /**
330      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
331      * a default value of 18.
332      *
333      * All three of these values are immutable: they can only be set once during
334      * construction.
335      */
336     //constructor (address admin, string memory name, string memory symbol, uint256 amount) public {
337     constructor () public {
338         _admin = 0x2150Cb38ee362bceAC3d4A2704A82eeeD02E93EC;
339         _name = "MetaFactory";
340         _symbol = "ROBOT";
341         _amount = 420000;
342         _decimals = 18;
343         _mint(_admin, _amount * (10 ** uint256(_decimals)));
344     }
345 
346     /**
347      * @dev checks to ensure that only the admin can execute
348      */ 
349     modifier onlyAdmin {
350         require(msg.sender == _admin, "admin only");
351         _;
352     }
353 
354     /**
355      * @dev checks to ensure the contract is not paused
356      * only the admin can execute methods when the contract is paused
357      * or when the contract has exited to community
358      */ 
359     modifier notPaused {
360         require(msg.sender == _admin || _paused == false, "transfer is paused");
361         _;
362     }
363 
364     /**
365      * @dev once exited to community, the contract can no longer be paused 
366      */ 
367     function exitToCommunity() public onlyAdmin returns (bool) {
368         _paused = false;
369         _admin = address(0);
370         emit ExitedToCommunity();
371         return true;
372     }
373 
374     /**
375      * @dev sets the contract in a paused state, only admin can transfer tokens
376      */ 
377     function pause(bool _pause) public onlyAdmin returns (bool) {
378         _paused = _pause;
379         emit Paused(_paused);
380         return _paused;
381     }
382 
383     /**
384      * @dev Returns the admin address for the token.
385      */
386     function admin() public view returns (address) {
387         return _admin;
388     } 
389 
390     /**
391      * @dev Returns the name of the token.
392      */
393     function name() public view returns (string memory) {
394         return _name;
395     }
396 
397     /**
398      * @dev Returns the symbol of the token, usually a shorter version of the
399      * name.
400      */
401     function symbol() public view returns (string memory) {
402         return _symbol;
403     }
404 
405     /**
406      * @dev Returns the number of decimals used to get its user representation.
407      * For example, if `decimals` equals `2`, a balance of `505` tokens should
408      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
409      *
410      * Tokens usually opt for a value of 18, imitating the relationship between
411      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
412      * called.
413      *
414      * NOTE: This information is only used for _display_ purposes: it in
415      * no way affects any of the arithmetic of the contract, including
416      * {IERC20-balanceOf} and {IERC20-transfer}.
417      */
418     function decimals() public view returns (uint8) {
419         return _decimals;
420     }
421 
422     /**
423      * @dev See {IERC20-totalSupply}.
424      */
425     function totalSupply() public view override returns (uint256) {
426         return _totalSupply;
427     }
428 
429     /**
430      * @dev See {IERC20-balanceOf}.
431      */
432     function balanceOf(address account) public view override returns (uint256) {
433         return _balances[account];
434     }
435 
436     /**
437      * @dev See {IERC20-transfer}.
438      *
439      * Requirements:
440      *
441      * - `recipient` cannot be the zero address.
442      * - the caller must have a balance of at least `amount`.
443      */
444     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
445         _transfer(_msgSender(), recipient, amount);
446         return true;
447     }
448 
449     /**
450      * @dev See {IERC20-allowance}.
451      */
452     function allowance(address owner, address spender) public view virtual override returns (uint256) {
453         return _allowances[owner][spender];
454     }
455 
456     /**
457      * @dev See {IERC20-approve}.
458      *
459      * Requirements:
460      *
461      * - `spender` cannot be the zero address.
462      */
463     function approve(address spender, uint256 amount) public virtual override returns (bool) {
464         _approve(_msgSender(), spender, amount);
465         return true;
466     }
467 
468     /**
469      * @dev See {IERC20-transferFrom}.
470      *
471      * Emits an {Approval} event indicating the updated allowance. This is not
472      * required by the EIP. See the note at the beginning of {ERC20};
473      *
474      * Requirements:
475      * - `sender` and `recipient` cannot be the zero address.
476      * - `sender` must have a balance of at least `amount`.
477      * - the caller must have allowance for ``sender``'s tokens of at least
478      * `amount`.
479      */
480     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
481         _transfer(sender, recipient, amount);
482         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
483         return true;
484     }
485 
486     /**
487      * @dev Atomically increases the allowance granted to `spender` by the caller.
488      *
489      * This is an alternative to {approve} that can be used as a mitigation for
490      * problems described in {IERC20-approve}.
491      *
492      * Emits an {Approval} event indicating the updated allowance.
493      *
494      * Requirements:
495      *
496      * - `spender` cannot be the zero address.
497      */
498     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
499         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
500         return true;
501     }
502 
503     /**
504      * @dev Atomically decreases the allowance granted to `spender` by the caller.
505      *
506      * This is an alternative to {approve} that can be used as a mitigation for
507      * problems described in {IERC20-approve}.
508      *
509      * Emits an {Approval} event indicating the updated allowance.
510      *
511      * Requirements:
512      *
513      * - `spender` cannot be the zero address.
514      * - `spender` must have allowance for the caller of at least
515      * `subtractedValue`.
516      */
517     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
518         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
519         return true;
520     }
521 
522     /**
523      * @dev Moves tokens `amount` from `sender` to `recipient`.
524      *
525      * This is internal function is equivalent to {transfer}, and can be used to
526      * e.g. implement automatic token fees, slashing mechanisms, etc.
527      *
528      * Emits a {Transfer} event.
529      *
530      * Requirements:
531      *
532      * - `sender` cannot be the zero address.
533      * - `recipient` cannot be the zero address.
534      * - `sender` must have a balance of at least `amount`.
535      */
536     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
537         require(sender != address(0), "ERC20: transfer from the zero address");
538         require(recipient != address(0), "ERC20: transfer to the zero address");
539 
540         _beforeTokenTransfer(sender, recipient, amount);
541 
542         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
543         _balances[recipient] = _balances[recipient].add(amount);
544         emit Transfer(sender, recipient, amount);
545     }
546 
547     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
548      * the total supply.
549      *
550      * Emits a {Transfer} event with `from` set to the zero address.
551      *
552      * Requirements
553      *
554      * - `to` cannot be the zero address.
555      */
556     function _mint(address account, uint256 amount) internal virtual {
557         require(account != address(0), "ERC20: mint to the zero address");
558 
559         _beforeTokenTransfer(address(0), account, amount);
560 
561         _totalSupply = _totalSupply.add(amount);
562         _balances[account] = _balances[account].add(amount);
563         emit Transfer(address(0), account, amount);
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
574      * Requirements:
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
588      * @dev Hook that is called before any transfer of tokens. This includes
589      * minting and burning.
590      *
591      * Calling conditions:
592      *
593      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
594      * will be to transferred to `to`.
595      * - when `from` is zero, `amount` tokens will be minted for `to`.
596      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
597      * - `from` and `to` are never both zero.
598      *
599      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
600      */
601     function _beforeTokenTransfer(address from, address to, uint256 amount) notPaused internal virtual { }
602 }