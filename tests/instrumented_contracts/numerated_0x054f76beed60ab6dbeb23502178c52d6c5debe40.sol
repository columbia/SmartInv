1 /**
2  *Submitted for verification at Etherscan.io on 2020-09-08
3 */
4 
5 // SPDX-License-Identifier: MIT
6 
7 pragma solidity ^0.6.0;
8 
9 /**
10  * @dev Interface of the ERC20 standard as defined in the EIP.
11  */
12 interface IERC20 {
13     /**
14      * @dev Returns the amount of tokens in existence.
15      */
16     function totalSupply() external view returns (uint256);
17 
18     /**
19      * @dev Returns the amount of tokens owned by `account`.
20      */
21     function balanceOf(address account) external view returns (uint256);
22 
23     /**
24      * @dev Moves `amount` tokens from the caller's account to `recipient`.
25      *
26      * Returns a boolean value indicating whether the operation succeeded.
27      *
28      * Emits a {Transfer} event.
29      */
30     function transfer(address recipient, uint256 amount) external returns (bool);
31 
32     /**
33      * @dev Returns the remaining number of tokens that `spender` will be
34      * allowed to spend on behalf of `owner` through {transferFrom}. This is
35      * zero by default.
36      *
37      * This value changes when {approve} or {transferFrom} are called.
38      */
39     function allowance(address owner, address spender) external view returns (uint256);
40 
41     /**
42      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
43      *
44      * Returns a boolean value indicating whether the operation succeeded.
45      *
46      * IMPORTANT: Beware that changing an allowance with this method brings the risk
47      * that someone may use both the old and the new allowance by unfortunate
48      * transaction ordering. One possible solution to mitigate this race
49      * condition is to first reduce the spender's allowance to 0 and set the
50      * desired value afterwards:
51      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
52      *
53      * Emits an {Approval} event.
54      */
55     function approve(address spender, uint256 amount) external returns (bool);
56 
57     /**
58      * @dev Moves `amount` tokens from `sender` to `recipient` using the
59      * allowance mechanism. `amount` is then deducted from the caller's
60      * allowance.
61      *
62      * Returns a boolean value indicating whether the operation succeeded.
63      *
64      * Emits a {Transfer} event.
65      */
66     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
67 
68     /**
69      * @dev Emitted when `value` tokens are moved from one account (`from`) to
70      * another (`to`).
71      *
72      * Note that `value` may be zero.
73      */
74     event Transfer(address indexed from, address indexed to, uint256 value);
75 
76     /**
77      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
78      * a call to {approve}. `value` is the new allowance.
79      */
80     event Approval(address indexed owner, address indexed spender, uint256 value);
81 }
82 
83 // SPDX-License-Identifier: MIT
84 
85 pragma solidity ^0.6.0;
86 
87 /**
88  * @dev Wrappers over Solidity's arithmetic operations with added overflow
89  * checks.
90  *
91  * Arithmetic operations in Solidity wrap on overflow. This can easily result
92  * in bugs, because programmers usually assume that an overflow raises an
93  * error, which is the standard behavior in high level programming languages.
94  * `SafeMath` restores this intuition by reverting the transaction when an
95  * operation overflows.
96  *
97  * Using this library instead of the unchecked operations eliminates an entire
98  * class of bugs, so it's recommended to use it always.
99  */
100 library SafeMath {
101     /**
102      * @dev Returns the addition of two unsigned integers, reverting on
103      * overflow.
104      *
105      * Counterpart to Solidity's `+` operator.
106      *
107      * Requirements:
108      *
109      * - Addition cannot overflow.
110      */
111     function add(uint256 a, uint256 b) internal pure returns (uint256) {
112         uint256 c = a + b;
113         require(c >= a, "SafeMath: addition overflow");
114 
115         return c;
116     }
117 
118     /**
119      * @dev Returns the subtraction of two unsigned integers, reverting on
120      * overflow (when the result is negative).
121      *
122      * Counterpart to Solidity's `-` operator.
123      *
124      * Requirements:
125      *
126      * - Subtraction cannot overflow.
127      */
128     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
129         return sub(a, b, "SafeMath: subtraction overflow");
130     }
131 
132     /**
133      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
134      * overflow (when the result is negative).
135      *
136      * Counterpart to Solidity's `-` operator.
137      *
138      * Requirements:
139      *
140      * - Subtraction cannot overflow.
141      */
142     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
143         require(b <= a, errorMessage);
144         uint256 c = a - b;
145 
146         return c;
147     }
148 
149     /**
150      * @dev Returns the multiplication of two unsigned integers, reverting on
151      * overflow.
152      *
153      * Counterpart to Solidity's `*` operator.
154      *
155      * Requirements:
156      *
157      * - Multiplication cannot overflow.
158      */
159     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
160         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
161         // benefit is lost if 'b' is also tested.
162         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
163         if (a == 0) {
164             return 0;
165         }
166 
167         uint256 c = a * b;
168         require(c / a == b, "SafeMath: multiplication overflow");
169 
170         return c;
171     }
172 
173     /**
174      * @dev Returns the integer division of two unsigned integers. Reverts on
175      * division by zero. The result is rounded towards zero.
176      *
177      * Counterpart to Solidity's `/` operator. Note: this function uses a
178      * `revert` opcode (which leaves remaining gas untouched) while Solidity
179      * uses an invalid opcode to revert (consuming all remaining gas).
180      *
181      * Requirements:
182      *
183      * - The divisor cannot be zero.
184      */
185     function div(uint256 a, uint256 b) internal pure returns (uint256) {
186         return div(a, b, "SafeMath: division by zero");
187     }
188 
189     /**
190      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
191      * division by zero. The result is rounded towards zero.
192      *
193      * Counterpart to Solidity's `/` operator. Note: this function uses a
194      * `revert` opcode (which leaves remaining gas untouched) while Solidity
195      * uses an invalid opcode to revert (consuming all remaining gas).
196      *
197      * Requirements:
198      *
199      * - The divisor cannot be zero.
200      */
201     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
202         require(b > 0, errorMessage);
203         uint256 c = a / b;
204         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
205 
206         return c;
207     }
208 
209     /**
210      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
211      * Reverts when dividing by zero.
212      *
213      * Counterpart to Solidity's `%` operator. This function uses a `revert`
214      * opcode (which leaves remaining gas untouched) while Solidity uses an
215      * invalid opcode to revert (consuming all remaining gas).
216      *
217      * Requirements:
218      *
219      * - The divisor cannot be zero.
220      */
221     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
222         return mod(a, b, "SafeMath: modulo by zero");
223     }
224 
225     /**
226      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
227      * Reverts with custom message when dividing by zero.
228      *
229      * Counterpart to Solidity's `%` operator. This function uses a `revert`
230      * opcode (which leaves remaining gas untouched) while Solidity uses an
231      * invalid opcode to revert (consuming all remaining gas).
232      *
233      * Requirements:
234      *
235      * - The divisor cannot be zero.
236      */
237     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
238         require(b != 0, errorMessage);
239         return a % b;
240     }
241 }
242 
243 // SPDX-License-Identifier: MIT
244 
245 pragma solidity ^0.6.2;
246 
247 /**
248  * @dev Collection of functions related to the address type
249  */
250 library Address {
251     /**
252      * @dev Returns true if `account` is a contract.
253      *
254      * [IMPORTANT]
255      * ====
256      * It is unsafe to assume that an address for which this function returns
257      * false is an externally-owned account (EOA) and not a contract.
258      *
259      * Among others, `isContract` will return false for the following
260      * types of addresses:
261      *
262      *  - an externally-owned account
263      *  - a contract in construction
264      *  - an address where a contract will be created
265      *  - an address where a contract lived, but was destroyed
266      * ====
267      */
268     function isContract(address account) internal view returns (bool) {
269         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
270         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
271         // for accounts without code, i.e. `keccak256('')`
272         bytes32 codehash;
273         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
274         // solhint-disable-next-line no-inline-assembly
275         assembly { codehash := extcodehash(account) }
276         return (codehash != accountHash && codehash != 0x0);
277     }
278 
279     /**
280      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
281      * `recipient`, forwarding all available gas and reverting on errors.
282      *
283      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
284      * of certain opcodes, possibly making contracts go over the 2300 gas limit
285      * imposed by `transfer`, making them unable to receive funds via
286      * `transfer`. {sendValue} removes this limitation.
287      *
288      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
289      *
290      * IMPORTANT: because control is transferred to `recipient`, care must be
291      * taken to not create reentrancy vulnerabilities. Consider using
292      * {ReentrancyGuard} or the
293      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
294      */
295     function sendValue(address payable recipient, uint256 amount) internal {
296         require(address(this).balance >= amount, "Address: insufficient balance");
297 
298         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
299         (bool success, ) = recipient.call{ value: amount }("");
300         require(success, "Address: unable to send value, recipient may have reverted");
301     }
302 
303     /**
304      * @dev Performs a Solidity function call using a low level `call`. A
305      * plain`call` is an unsafe replacement for a function call: use this
306      * function instead.
307      *
308      * If `target` reverts with a revert reason, it is bubbled up by this
309      * function (like regular Solidity function calls).
310      *
311      * Returns the raw returned data. To convert to the expected return value,
312      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
313      *
314      * Requirements:
315      *
316      * - `target` must be a contract.
317      * - calling `target` with `data` must not revert.
318      *
319      * _Available since v3.1._
320      */
321     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
322       return functionCall(target, data, "Address: low-level call failed");
323     }
324 
325     /**
326      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
327      * `errorMessage` as a fallback revert reason when `target` reverts.
328      *
329      * _Available since v3.1._
330      */
331     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
332         return _functionCallWithValue(target, data, 0, errorMessage);
333     }
334 
335     /**
336      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
337      * but also transferring `value` wei to `target`.
338      *
339      * Requirements:
340      *
341      * - the calling contract must have an ETH balance of at least `value`.
342      * - the called Solidity function must be `payable`.
343      *
344      * _Available since v3.1._
345      */
346     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
347         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
348     }
349 
350     /**
351      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
352      * with `errorMessage` as a fallback revert reason when `target` reverts.
353      *
354      * _Available since v3.1._
355      */
356     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
357         require(address(this).balance >= value, "Address: insufficient balance for call");
358         return _functionCallWithValue(target, data, value, errorMessage);
359     }
360 
361     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
362         require(isContract(target), "Address: call to non-contract");
363 
364         // solhint-disable-next-line avoid-low-level-calls
365         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
366         if (success) {
367             return returndata;
368         } else {
369             // Look for revert reason and bubble it up if present
370             if (returndata.length > 0) {
371                 // The easiest way to bubble the revert reason is using memory via assembly
372 
373                 // solhint-disable-next-line no-inline-assembly
374                 assembly {
375                     let returndata_size := mload(returndata)
376                     revert(add(32, returndata), returndata_size)
377                 }
378             } else {
379                 revert(errorMessage);
380             }
381         }
382     }
383 }
384 
385 // SPDX-License-Identifier: MIT
386 
387 pragma solidity ^0.6.0;
388 
389 /*
390  * @dev Provides information about the current execution context, including the
391  * sender of the transaction and its data. While these are generally available
392  * via msg.sender and msg.data, they should not be accessed in such a direct
393  * manner, since when dealing with GSN meta-transactions the account sending and
394  * paying for execution may not be the actual sender (as far as an application
395  * is concerned).
396  *
397  * This contract is only required for intermediate, library-like contracts.
398  */
399 abstract contract Context {
400     function _msgSender() internal view virtual returns (address payable) {
401         return msg.sender;
402     }
403 
404     function _msgData() internal view virtual returns (bytes memory) {
405         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
406         return msg.data;
407     }
408 }
409 
410 // SPDX-License-Identifier: MIT
411 
412 pragma solidity ^0.6.0;
413 
414 /**
415  * @dev Implementation of the {IERC20} interface.
416  *
417  * This implementation is agnostic to the way tokens are created. This means
418  * that a supply mechanism has to be added in a derived contract using {_mint}.
419  * For a generic mechanism see {ERC20PresetMinterPauser}.
420  *
421  * TIP: For a detailed writeup see our guide
422  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
423  * to implement supply mechanisms].
424  *
425  * We have followed general OpenZeppelin guidelines: functions revert instead
426  * of returning `false` on failure. This behavior is nonetheless conventional
427  * and does not conflict with the expectations of ERC20 applications.
428  *
429  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
430  * This allows applications to reconstruct the allowance for all accounts just
431  * by listening to said events. Other implementations of the EIP may not emit
432  * these events, as it isn't required by the specification.
433  *
434  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
435  * functions have been added to mitigate the well-known issues around setting
436  * allowances. See {IERC20-approve}.
437  */
438 contract ERC20 is Context, IERC20 {
439     using SafeMath for uint256;
440     using Address for address;
441 
442     mapping (address => uint256) private _balances;
443 
444     mapping (address => mapping (address => uint256)) private _allowances;
445 
446     uint256 private _totalSupply;
447 
448     string private _name;
449     string private _symbol;
450     uint8 private _decimals;
451 
452     /**
453      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
454      * a default value of 18.
455      *
456      * To select a different value for {decimals}, use {_setupDecimals}.
457      *
458      * All three of these values are immutable: they can only be set once during
459      * construction.
460      */
461     constructor (string memory name, string memory symbol) public {
462         _name = name;
463         _symbol = symbol;
464         _decimals = 18;
465     }
466 
467     /**
468      * @dev Returns the name of the token.
469      */
470     function name() public view returns (string memory) {
471         return _name;
472     }
473 
474     /**
475      * @dev Returns the symbol of the token, usually a shorter version of the
476      * name.
477      */
478     function symbol() public view returns (string memory) {
479         return _symbol;
480     }
481 
482     /**
483      * @dev Returns the number of decimals used to get its user representation.
484      * For example, if `decimals` equals `2`, a balance of `505` tokens should
485      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
486      *
487      * Tokens usually opt for a value of 18, imitating the relationship between
488      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
489      * called.
490      *
491      * NOTE: This information is only used for _display_ purposes: it in
492      * no way affects any of the arithmetic of the contract, including
493      * {IERC20-balanceOf} and {IERC20-transfer}.
494      */
495     function decimals() public view returns (uint8) {
496         return _decimals;
497     }
498 
499     /**
500      * @dev See {IERC20-totalSupply}.
501      */
502     function totalSupply() public view override returns (uint256) {
503         return _totalSupply;
504     }
505 
506     /**
507      * @dev See {IERC20-balanceOf}.
508      */
509     function balanceOf(address account) public view override returns (uint256) {
510         return _balances[account];
511     }
512 
513     /**
514      * @dev See {IERC20-transfer}.
515      *
516      * Requirements:
517      *
518      * - `recipient` cannot be the zero address.
519      * - the caller must have a balance of at least `amount`.
520      */
521     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
522         _transfer(_msgSender(), recipient, amount);
523         return true;
524     }
525 
526     /**
527      * @dev See {IERC20-allowance}.
528      */
529     function allowance(address owner, address spender) public view virtual override returns (uint256) {
530         return _allowances[owner][spender];
531     }
532 
533     /**
534      * @dev See {IERC20-approve}.
535      *
536      * Requirements:
537      *
538      * - `spender` cannot be the zero address.
539      */
540     function approve(address spender, uint256 amount) public virtual override returns (bool) {
541         _approve(_msgSender(), spender, amount);
542         return true;
543     }
544 
545     /**
546      * @dev See {IERC20-transferFrom}.
547      *
548      * Emits an {Approval} event indicating the updated allowance. This is not
549      * required by the EIP. See the note at the beginning of {ERC20};
550      *
551      * Requirements:
552      * - `sender` and `recipient` cannot be the zero address.
553      * - `sender` must have a balance of at least `amount`.
554      * - the caller must have allowance for ``sender``'s tokens of at least
555      * `amount`.
556      */
557     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
558         _transfer(sender, recipient, amount);
559         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
560         return true;
561     }
562 
563     /**
564      * @dev Atomically increases the allowance granted to `spender` by the caller.
565      *
566      * This is an alternative to {approve} that can be used as a mitigation for
567      * problems described in {IERC20-approve}.
568      *
569      * Emits an {Approval} event indicating the updated allowance.
570      *
571      * Requirements:
572      *
573      * - `spender` cannot be the zero address.
574      */
575     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
576         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
577         return true;
578     }
579 
580     /**
581      * @dev Atomically decreases the allowance granted to `spender` by the caller.
582      *
583      * This is an alternative to {approve} that can be used as a mitigation for
584      * problems described in {IERC20-approve}.
585      *
586      * Emits an {Approval} event indicating the updated allowance.
587      *
588      * Requirements:
589      *
590      * - `spender` cannot be the zero address.
591      * - `spender` must have allowance for the caller of at least
592      * `subtractedValue`.
593      */
594     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
595         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
596         return true;
597     }
598 
599     /**
600      * @dev Moves tokens `amount` from `sender` to `recipient`.
601      *
602      * This is internal function is equivalent to {transfer}, and can be used to
603      * e.g. implement automatic token fees, slashing mechanisms, etc.
604      *
605      * Emits a {Transfer} event.
606      *
607      * Requirements:
608      *
609      * - `sender` cannot be the zero address.
610      * - `recipient` cannot be the zero address.
611      * - `sender` must have a balance of at least `amount`.
612      */
613     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
614         require(sender != address(0), "ERC20: transfer from the zero address");
615         require(recipient != address(0), "ERC20: transfer to the zero address");
616 
617         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
618         _balances[recipient] = _balances[recipient].add(amount);
619         emit Transfer(sender, recipient, amount);
620     }
621 
622     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
623      * the total supply.
624      *
625      * Emits a {Transfer} event with `from` set to the zero address.
626      *
627      * Requirements
628      *
629      * - `to` cannot be the zero address.
630      */
631     function _mint(address account, uint256 amount) internal virtual {
632         require(account != address(0), "ERC20: mint to the zero address");
633 
634         _totalSupply = _totalSupply.add(amount);
635         _balances[account] = _balances[account].add(amount);
636         emit Transfer(address(0), account, amount);
637     }
638 
639     /**
640      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
641      *
642      * This is internal function is equivalent to `approve`, and can be used to
643      * e.g. set automatic allowances for certain subsystems, etc.
644      *
645      * Emits an {Approval} event.
646      *
647      * Requirements:
648      *
649      * - `owner` cannot be the zero address.
650      * - `spender` cannot be the zero address.
651      */
652     function _approve(address owner, address spender, uint256 amount) internal virtual {
653         require(owner != address(0), "ERC20: approve from the zero address");
654         require(spender != address(0), "ERC20: approve to the zero address");
655 
656         _allowances[owner][spender] = amount;
657         emit Approval(owner, spender, amount);
658     }
659 }
660 
661 pragma solidity ^0.6.0;
662 
663 contract FINToken is ERC20 {
664     constructor(uint256 initialSupply) public ERC20("DeFiner", "FIN") {
665         _mint(msg.sender, initialSupply);
666     }
667 }