1 pragma solidity 0.6.12;
2 pragma experimental ABIEncoderV2;
3 
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
27  * @dev Interface of the ERC20 standard as defined in the EIP.
28  */
29 interface IERC20 {
30     /**
31      * @dev Returns the amount of tokens in existence.
32      */
33     function totalSupply() external view returns (uint256);
34 
35     /**
36      * @dev Returns the amount of tokens owned by `account`.
37      */
38     function balanceOf(address account) external view returns (uint256);
39 
40     /**
41      * @dev Moves `amount` tokens from the caller's account to `recipient`.
42      *
43      * Returns a boolean value indicating whether the operation succeeded.
44      *
45      * Emits a {Transfer} event.
46      */
47     function transfer(address recipient, uint256 amount) external returns (bool);
48 
49     /**
50      * @dev Returns the remaining number of tokens that `spender` will be
51      * allowed to spend on behalf of `owner` through {transferFrom}. This is
52      * zero by default.
53      *
54      * This value changes when {approve} or {transferFrom} are called.
55      */
56     function allowance(address owner, address spender) external view returns (uint256);
57 
58     /**
59      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
60      *
61      * Returns a boolean value indicating whether the operation succeeded.
62      *
63      * IMPORTANT: Beware that changing an allowance with this method brings the risk
64      * that someone may use both the old and the new allowance by unfortunate
65      * transaction ordering. One possible solution to mitigate this race
66      * condition is to first reduce the spender's allowance to 0 and set the
67      * desired value afterwards:
68      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
69      *
70      * Emits an {Approval} event.
71      */
72     function approve(address spender, uint256 amount) external returns (bool);
73 
74     /**
75      * @dev Moves `amount` tokens from `sender` to `recipient` using the
76      * allowance mechanism. `amount` is then deducted from the caller's
77      * allowance.
78      *
79      * Returns a boolean value indicating whether the operation succeeded.
80      *
81      * Emits a {Transfer} event.
82      */
83     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
84 
85     /**
86      * @dev Emitted when `value` tokens are moved from one account (`from`) to
87      * another (`to`).
88      *
89      * Note that `value` may be zero.
90      */
91     event Transfer(address indexed from, address indexed to, uint256 value);
92 
93     /**
94      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
95      * a call to {approve}. `value` is the new allowance.
96      */
97     event Approval(address indexed owner, address indexed spender, uint256 value);
98 }
99 
100 /**
101  * @dev Wrappers over Solidity's arithmetic operations with added overflow
102  * checks.
103  *
104  * Arithmetic operations in Solidity wrap on overflow. This can easily result
105  * in bugs, because programmers usually assume that an overflow raises an
106  * error, which is the standard behavior in high level programming languages.
107  * `SafeMath` restores this intuition by reverting the transaction when an
108  * operation overflows.
109  *
110  * Using this library instead of the unchecked operations eliminates an entire
111  * class of bugs, so it's recommended to use it always.
112  */
113 library SafeMath {
114     /**
115      * @dev Returns the addition of two unsigned integers, reverting on
116      * overflow.
117      *
118      * Counterpart to Solidity's `+` operator.
119      *
120      * Requirements:
121      *
122      * - Addition cannot overflow.
123      */
124     function add(uint256 a, uint256 b) internal pure returns (uint256) {
125         uint256 c = a + b;
126         require(c >= a, "SafeMath: addition overflow");
127 
128         return c;
129     }
130 
131     /**
132      * @dev Returns the subtraction of two unsigned integers, reverting on
133      * overflow (when the result is negative).
134      *
135      * Counterpart to Solidity's `-` operator.
136      *
137      * Requirements:
138      *
139      * - Subtraction cannot overflow.
140      */
141     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
142         return sub(a, b, "SafeMath: subtraction overflow");
143     }
144 
145     /**
146      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
147      * overflow (when the result is negative).
148      *
149      * Counterpart to Solidity's `-` operator.
150      *
151      * Requirements:
152      *
153      * - Subtraction cannot overflow.
154      */
155     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
156         require(b <= a, errorMessage);
157         uint256 c = a - b;
158 
159         return c;
160     }
161 
162     /**
163      * @dev Returns the multiplication of two unsigned integers, reverting on
164      * overflow.
165      *
166      * Counterpart to Solidity's `*` operator.
167      *
168      * Requirements:
169      *
170      * - Multiplication cannot overflow.
171      */
172     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
173         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
174         // benefit is lost if 'b' is also tested.
175         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
176         if (a == 0) {
177             return 0;
178         }
179 
180         uint256 c = a * b;
181         require(c / a == b, "SafeMath: multiplication overflow");
182 
183         return c;
184     }
185 
186     /**
187      * @dev Returns the integer division of two unsigned integers. Reverts on
188      * division by zero. The result is rounded towards zero.
189      *
190      * Counterpart to Solidity's `/` operator. Note: this function uses a
191      * `revert` opcode (which leaves remaining gas untouched) while Solidity
192      * uses an invalid opcode to revert (consuming all remaining gas).
193      *
194      * Requirements:
195      *
196      * - The divisor cannot be zero.
197      */
198     function div(uint256 a, uint256 b) internal pure returns (uint256) {
199         return div(a, b, "SafeMath: division by zero");
200     }
201 
202     /**
203      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
204      * division by zero. The result is rounded towards zero.
205      *
206      * Counterpart to Solidity's `/` operator. Note: this function uses a
207      * `revert` opcode (which leaves remaining gas untouched) while Solidity
208      * uses an invalid opcode to revert (consuming all remaining gas).
209      *
210      * Requirements:
211      *
212      * - The divisor cannot be zero.
213      */
214     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
215         require(b > 0, errorMessage);
216         uint256 c = a / b;
217         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
218 
219         return c;
220     }
221 
222     /**
223      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
224      * Reverts when dividing by zero.
225      *
226      * Counterpart to Solidity's `%` operator. This function uses a `revert`
227      * opcode (which leaves remaining gas untouched) while Solidity uses an
228      * invalid opcode to revert (consuming all remaining gas).
229      *
230      * Requirements:
231      *
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
246      * Requirements:
247      *
248      * - The divisor cannot be zero.
249      */
250     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
251         require(b != 0, errorMessage);
252         return a % b;
253     }
254 }
255 
256 /**
257  * @dev Collection of functions related to the address type
258  */
259 library Address {
260     /**
261      * @dev Returns true if `account` is a contract.
262      *
263      * [IMPORTANT]
264      * ====
265      * It is unsafe to assume that an address for which this function returns
266      * false is an externally-owned account (EOA) and not a contract.
267      *
268      * Among others, `isContract` will return false for the following
269      * types of addresses:
270      *
271      *  - an externally-owned account
272      *  - a contract in construction
273      *  - an address where a contract will be created
274      *  - an address where a contract lived, but was destroyed
275      * ====
276      */
277     function isContract(address account) internal view returns (bool) {
278         // This method relies in extcodesize, which returns 0 for contracts in
279         // construction, since the code is only stored at the end of the
280         // constructor execution.
281 
282         uint256 size;
283         // solhint-disable-next-line no-inline-assembly
284         assembly { size := extcodesize(account) }
285         return size > 0;
286     }
287 
288     /**
289      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
290      * `recipient`, forwarding all available gas and reverting on errors.
291      *
292      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
293      * of certain opcodes, possibly making contracts go over the 2300 gas limit
294      * imposed by `transfer`, making them unable to receive funds via
295      * `transfer`. {sendValue} removes this limitation.
296      *
297      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
298      *
299      * IMPORTANT: because control is transferred to `recipient`, care must be
300      * taken to not create reentrancy vulnerabilities. Consider using
301      * {ReentrancyGuard} or the
302      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
303      */
304     function sendValue(address payable recipient, uint256 amount) internal {
305         require(address(this).balance >= amount, "Address: insufficient balance");
306 
307         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
308         (bool success, ) = recipient.call{ value: amount }("");
309         require(success, "Address: unable to send value, recipient may have reverted");
310     }
311 
312     /**
313      * @dev Performs a Solidity function call using a low level `call`. A
314      * plain`call` is an unsafe replacement for a function call: use this
315      * function instead.
316      *
317      * If `target` reverts with a revert reason, it is bubbled up by this
318      * function (like regular Solidity function calls).
319      *
320      * Returns the raw returned data. To convert to the expected return value,
321      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
322      *
323      * Requirements:
324      *
325      * - `target` must be a contract.
326      * - calling `target` with `data` must not revert.
327      *
328      * _Available since v3.1._
329      */
330     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
331       return functionCall(target, data, "Address: low-level call failed");
332     }
333 
334     /**
335      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
336      * `errorMessage` as a fallback revert reason when `target` reverts.
337      *
338      * _Available since v3.1._
339      */
340     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
341         return _functionCallWithValue(target, data, 0, errorMessage);
342     }
343 
344     /**
345      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
346      * but also transferring `value` wei to `target`.
347      *
348      * Requirements:
349      *
350      * - the calling contract must have an ETH balance of at least `value`.
351      * - the called Solidity function must be `payable`.
352      *
353      * _Available since v3.1._
354      */
355     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
356         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
357     }
358 
359     /**
360      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
361      * with `errorMessage` as a fallback revert reason when `target` reverts.
362      *
363      * _Available since v3.1._
364      */
365     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
366         require(address(this).balance >= value, "Address: insufficient balance for call");
367         return _functionCallWithValue(target, data, value, errorMessage);
368     }
369 
370     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
371         require(isContract(target), "Address: call to non-contract");
372 
373         // solhint-disable-next-line avoid-low-level-calls
374         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
375         if (success) {
376             return returndata;
377         } else {
378             // Look for revert reason and bubble it up if present
379             if (returndata.length > 0) {
380                 // The easiest way to bubble the revert reason is using memory via assembly
381 
382                 // solhint-disable-next-line no-inline-assembly
383                 assembly {
384                     let returndata_size := mload(returndata)
385                     revert(add(32, returndata), returndata_size)
386                 }
387             } else {
388                 revert(errorMessage);
389             }
390         }
391     }
392 }
393 
394 contract ERC20 is Context, IERC20 {
395     using SafeMath for uint256;
396     using Address for address;
397 
398     mapping (address => uint256) private _balances;
399 
400     mapping (address => mapping (address => uint256)) private _allowances;
401 
402     uint256 private _totalSupply;
403 
404     string private _name;
405     string private _symbol;
406     uint8 private _decimals;
407 
408     /**
409      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
410      * a default value of 18.
411      *
412      * To select a different value for {decimals}, use {_setupDecimals}.
413      *
414      * All three of these values are immutable: they can only be set once during
415      * construction.
416      */
417     constructor (string memory name, string memory symbol) public {
418         _name = name;
419         _symbol = symbol;
420         _decimals = 18;
421     }
422 
423     /**
424      * @dev Returns the name of the token.
425      */
426     function name() public view returns (string memory) {
427         return _name;
428     }
429 
430     /**
431      * @dev Returns the symbol of the token, usually a shorter version of the
432      * name.
433      */
434     function symbol() public view returns (string memory) {
435         return _symbol;
436     }
437 
438     /**
439      * @dev Returns the number of decimals used to get its user representation.
440      * For example, if `decimals` equals `2`, a balance of `505` tokens should
441      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
442      *
443      * Tokens usually opt for a value of 18, imitating the relationship between
444      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
445      * called.
446      *
447      * NOTE: This information is only used for _display_ purposes: it in
448      * no way affects any of the arithmetic of the contract, including
449      * {IERC20-balanceOf} and {IERC20-transfer}.
450      */
451     function decimals() public view returns (uint8) {
452         return _decimals;
453     }
454 
455     /**
456      * @dev See {IERC20-totalSupply}.
457      */
458     function totalSupply() public view override returns (uint256) {
459         return _totalSupply;
460     }
461 
462     /**
463      * @dev See {IERC20-balanceOf}.
464      */
465     function balanceOf(address account) public view override returns (uint256) {
466         return _balances[account];
467     }
468 
469     /**
470      * @dev See {IERC20-transfer}.
471      *
472      * Requirements:
473      *
474      * - `recipient` cannot be the zero address.
475      * - the caller must have a balance of at least `amount`.
476      */
477     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
478         _transfer(_msgSender(), recipient, amount);
479         return true;
480     }
481 
482     /**
483      * @dev See {IERC20-allowance}.
484      */
485     function allowance(address owner, address spender) public view virtual override returns (uint256) {
486         return _allowances[owner][spender];
487     }
488 
489     /**
490      * @dev See {IERC20-approve}.
491      *
492      * Requirements:
493      *
494      * - `spender` cannot be the zero address.
495      */
496     function approve(address spender, uint256 amount) public virtual override returns (bool) {
497         _approve(_msgSender(), spender, amount);
498         return true;
499     }
500 
501     /**
502      * @dev See {IERC20-transferFrom}.
503      *
504      * Emits an {Approval} event indicating the updated allowance. This is not
505      * required by the EIP. See the note at the beginning of {ERC20};
506      *
507      * Requirements:
508      * - `sender` and `recipient` cannot be the zero address.
509      * - `sender` must have a balance of at least `amount`.
510      * - the caller must have allowance for ``sender``'s tokens of at least
511      * `amount`.
512      */
513     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
514         _transfer(sender, recipient, amount);
515         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
516         return true;
517     }
518 
519     /**
520      * @dev Atomically increases the allowance granted to `spender` by the caller.
521      *
522      * This is an alternative to {approve} that can be used as a mitigation for
523      * problems described in {IERC20-approve}.
524      *
525      * Emits an {Approval} event indicating the updated allowance.
526      *
527      * Requirements:
528      *
529      * - `spender` cannot be the zero address.
530      */
531     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
532         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
533         return true;
534     }
535 
536     /**
537      * @dev Atomically decreases the allowance granted to `spender` by the caller.
538      *
539      * This is an alternative to {approve} that can be used as a mitigation for
540      * problems described in {IERC20-approve}.
541      *
542      * Emits an {Approval} event indicating the updated allowance.
543      *
544      * Requirements:
545      *
546      * - `spender` cannot be the zero address.
547      * - `spender` must have allowance for the caller of at least
548      * `subtractedValue`.
549      */
550     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
551         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
552         return true;
553     }
554 
555     /**
556      * @dev Moves tokens `amount` from `sender` to `recipient`.
557      *
558      * This is internal function is equivalent to {transfer}, and can be used to
559      * e.g. implement automatic token fees, slashing mechanisms, etc.
560      *
561      * Emits a {Transfer} event.
562      *
563      * Requirements:
564      *
565      * - `sender` cannot be the zero address.
566      * - `recipient` cannot be the zero address.
567      * - `sender` must have a balance of at least `amount`.
568      */
569     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
570         require(sender != address(0), "ERC20: transfer from the zero address");
571         require(recipient != address(0), "ERC20: transfer to the zero address");
572 
573         _beforeTokenTransfer(sender, recipient, amount);
574 
575         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
576         _balances[recipient] = _balances[recipient].add(amount);
577         emit Transfer(sender, recipient, amount);
578     }
579 
580     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
581      * the total supply.
582      *
583      * Emits a {Transfer} event with `from` set to the zero address.
584      *
585      * Requirements
586      *
587      * - `to` cannot be the zero address.
588      */
589     function _mint(address account, uint256 amount) internal virtual {
590         require(account != address(0), "ERC20: mint to the zero address");
591 
592         _beforeTokenTransfer(address(0), account, amount);
593 
594         _totalSupply = _totalSupply.add(amount);
595         _balances[account] = _balances[account].add(amount);
596         emit Transfer(address(0), account, amount);
597     }
598 
599     /**
600      * @dev Destroys `amount` tokens from `account`, reducing the
601      * total supply.
602      *
603      * Emits a {Transfer} event with `to` set to the zero address.
604      *
605      * Requirements
606      *
607      * - `account` cannot be the zero address.
608      * - `account` must have at least `amount` tokens.
609      */
610     function _burn(address account, uint256 amount) internal virtual {
611         require(account != address(0), "ERC20: burn from the zero address");
612 
613         _beforeTokenTransfer(account, address(0), amount);
614 
615         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
616         _totalSupply = _totalSupply.sub(amount);
617         emit Transfer(account, address(0), amount);
618     }
619 
620     /**
621      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
622      *
623      * This internal function is equivalent to `approve`, and can be used to
624      * e.g. set automatic allowances for certain subsystems, etc.
625      *
626      * Emits an {Approval} event.
627      *
628      * Requirements:
629      *
630      * - `owner` cannot be the zero address.
631      * - `spender` cannot be the zero address.
632      */
633     function _approve(address owner, address spender, uint256 amount) internal virtual {
634         require(owner != address(0), "ERC20: approve from the zero address");
635         require(spender != address(0), "ERC20: approve to the zero address");
636 
637         _allowances[owner][spender] = amount;
638         emit Approval(owner, spender, amount);
639     }
640 
641     /**
642      * @dev Sets {decimals} to a value other than the default one of 18.
643      *
644      * WARNING: This function should only be called from the constructor. Most
645      * applications that interact with token contracts will not expect
646      * {decimals} to ever change, and may work incorrectly if it does.
647      */
648     function _setupDecimals(uint8 decimals_) internal {
649         _decimals = decimals_;
650     }
651 
652     /**
653      * @dev Hook that is called before any transfer of tokens. This includes
654      * minting and burning.
655      *
656      * Calling conditions:
657      *
658      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
659      * will be to transferred to `to`.
660      * - when `from` is zero, `amount` tokens will be minted for `to`.
661      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
662      * - `from` and `to` are never both zero.
663      *
664      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
665      */
666     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
667 }
668 
669 contract Fnk is ERC20 {
670 
671     constructor() public ERC20("Finiko", "FNK") {
672         _mint(msg.sender, 100000000e18);
673     }
674 }