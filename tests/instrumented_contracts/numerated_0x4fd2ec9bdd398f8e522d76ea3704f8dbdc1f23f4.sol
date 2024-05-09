1 pragma solidity ^0.6.0;
2 
3 
4 /**
5  * @dev Implementation of the {IERC20} interface.
6  *
7  * This implementation is agnostic to the way tokens are created. This means
8  * that a supply mechanism has to be added in a derived contract using {_mint}.
9  * For a generic mechanism see {ERC20PresetMinterPauser}.
10  *
11  * TIP: For a detailed writeup see our guide
12  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
13  * to implement supply mechanisms].
14  *
15  * We have followed general OpenZeppelin guidelines: functions revert instead
16  * of returning `false` on failure. This behavior is nonetheless conventional
17  * and does not conflict with the expectations of ERC20 applications.
18  *
19  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
20  * This allows applications to reconstruct the allowance for all accounts just
21  * by listening to said events. Other implementations of the EIP may not emit
22  * these events, as it isn't required by the specification.
23  *
24  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
25  * functions have been added to mitigate the well-known issues around setting
26  * allowances. See {IERC20-approve}.
27  */
28 
29 
30 // SPDX-License-Identifier: MIT
31 
32 
33 /*
34  * @dev Provides information about the current execution context, including the
35  * sender of the transaction and its data. While these are generally available
36  * via msg.sender and msg.data, they should not be accessed in such a direct
37  * manner, since when dealing with GSN meta-transactions the account sending and
38  * paying for execution may not be the actual sender (as far as an application
39  * is concerned).
40  *
41  * This contract is only required for intermediate, library-like contracts.
42  */
43 abstract contract Context {
44     function _msgSender() internal view virtual returns (address payable) {
45         return msg.sender;
46     }
47 
48     function _msgData() internal view virtual returns (bytes memory) {
49         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
50         return msg.data;
51     }
52 }
53 
54 // SPDX-License-Identifier: MIT
55 
56 /**
57  * @dev Wrappers over Solidity's arithmetic operations with added overflow
58  * checks.
59  *
60  * Arithmetic operations in Solidity wrap on overflow. This can easily result
61  * in bugs, because programmers usually assume that an overflow raises an
62  * error, which is the standard behavior in high level programming languages.
63  * `SafeMath` restores this intuition by reverting the transaction when an
64  * operation overflows.
65  *
66  * Using this library instead of the unchecked operations eliminates an entire
67  * class of bugs, so it's recommended to use it always.
68  */
69 library SafeMath {
70     /**
71      * @dev Returns the addition of two unsigned integers, reverting on
72      * overflow.
73      *
74      * Counterpart to Solidity's `+` operator.
75      *
76      * Requirements:
77      *
78      * - Addition cannot overflow.
79      */
80     function add(uint256 a, uint256 b) internal pure returns (uint256) {
81         uint256 c = a + b;
82         require(c >= a, "SafeMath: addition overflow");
83 
84         return c;
85     }
86 
87     /**
88      * @dev Returns the subtraction of two unsigned integers, reverting on
89      * overflow (when the result is negative).
90      *
91      * Counterpart to Solidity's `-` operator.
92      *
93      * Requirements:
94      *
95      * - Subtraction cannot overflow.
96      */
97     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
98         return sub(a, b, "SafeMath: subtraction overflow");
99     }
100 
101     /**
102      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
103      * overflow (when the result is negative).
104      *
105      * Counterpart to Solidity's `-` operator.
106      *
107      * Requirements:
108      *
109      * - Subtraction cannot overflow.
110      */
111     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
112         require(b <= a, errorMessage);
113         uint256 c = a - b;
114 
115         return c;
116     }
117 
118     /**
119      * @dev Returns the multiplication of two unsigned integers, reverting on
120      * overflow.
121      *
122      * Counterpart to Solidity's `*` operator.
123      *
124      * Requirements:
125      *
126      * - Multiplication cannot overflow.
127      */
128     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
129         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
130         // benefit is lost if 'b' is also tested.
131         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
132         if (a == 0) {
133             return 0;
134         }
135 
136         uint256 c = a * b;
137         require(c / a == b, "SafeMath: multiplication overflow");
138 
139         return c;
140     }
141 
142     /**
143      * @dev Returns the integer division of two unsigned integers. Reverts on
144      * division by zero. The result is rounded towards zero.
145      *
146      * Counterpart to Solidity's `/` operator. Note: this function uses a
147      * `revert` opcode (which leaves remaining gas untouched) while Solidity
148      * uses an invalid opcode to revert (consuming all remaining gas).
149      *
150      * Requirements:
151      *
152      * - The divisor cannot be zero.
153      */
154     function div(uint256 a, uint256 b) internal pure returns (uint256) {
155         return div(a, b, "SafeMath: division by zero");
156     }
157 
158     /**
159      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
160      * division by zero. The result is rounded towards zero.
161      *
162      * Counterpart to Solidity's `/` operator. Note: this function uses a
163      * `revert` opcode (which leaves remaining gas untouched) while Solidity
164      * uses an invalid opcode to revert (consuming all remaining gas).
165      *
166      * Requirements:
167      *
168      * - The divisor cannot be zero.
169      */
170     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
171         require(b > 0, errorMessage);
172         uint256 c = a / b;
173         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
174 
175         return c;
176     }
177 
178     /**
179      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
180      * Reverts when dividing by zero.
181      *
182      * Counterpart to Solidity's `%` operator. This function uses a `revert`
183      * opcode (which leaves remaining gas untouched) while Solidity uses an
184      * invalid opcode to revert (consuming all remaining gas).
185      *
186      * Requirements:
187      *
188      * - The divisor cannot be zero.
189      */
190     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
191         return mod(a, b, "SafeMath: modulo by zero");
192     }
193 
194     /**
195      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
196      * Reverts with custom message when dividing by zero.
197      *
198      * Counterpart to Solidity's `%` operator. This function uses a `revert`
199      * opcode (which leaves remaining gas untouched) while Solidity uses an
200      * invalid opcode to revert (consuming all remaining gas).
201      *
202      * Requirements:
203      *
204      * - The divisor cannot be zero.
205      */
206     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
207         require(b != 0, errorMessage);
208         return a % b;
209     }
210 }
211 
212 // SPDX-License-Identifier: MIT
213 
214 
215 /**
216  * @dev Interface of the ERC20 standard as defined in the EIP.
217  */
218 interface IERC20 {
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
289 // SPDX-License-Identifier: MIT
290 
291 pragma solidity ^0.6.2;
292 
293 /**
294  * @dev Collection of functions related to the address type
295  */
296 library Address {
297     /**
298      * @dev Returns true if `account` is a contract.
299      *
300      * [IMPORTANT]
301      * ====
302      * It is unsafe to assume that an address for which this function returns
303      * false is an externally-owned account (EOA) and not a contract.
304      *
305      * Among others, `isContract` will return false for the following
306      * types of addresses:
307      *
308      *  - an externally-owned account
309      *  - a contract in construction
310      *  - an address where a contract will be created
311      *  - an address where a contract lived, but was destroyed
312      * ====
313      */
314     function isContract(address account) internal view returns (bool) {
315         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
316         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
317         // for accounts without code, i.e. `keccak256('')`
318         bytes32 codehash;
319         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
320         // solhint-disable-next-line no-inline-assembly
321         assembly { codehash := extcodehash(account) }
322         return (codehash != accountHash && codehash != 0x0);
323     }
324 
325     /**
326      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
327      * `recipient`, forwarding all available gas and reverting on errors.
328      *
329      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
330      * of certain opcodes, possibly making contracts go over the 2300 gas limit
331      * imposed by `transfer`, making them unable to receive funds via
332      * `transfer`. {sendValue} removes this limitation.
333      *
334      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
335      *
336      * IMPORTANT: because control is transferred to `recipient`, care must be
337      * taken to not create reentrancy vulnerabilities. Consider using
338      * {ReentrancyGuard} or the
339      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
340      */
341     function sendValue(address payable recipient, uint256 amount) internal {
342         require(address(this).balance >= amount, "Address: insufficient balance");
343 
344         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
345         (bool success, ) = recipient.call{ value: amount }("");
346         require(success, "Address: unable to send value, recipient may have reverted");
347     }
348 
349     /**
350      * @dev Performs a Solidity function call using a low level `call`. A
351      * plain`call` is an unsafe replacement for a function call: use this
352      * function instead.
353      *
354      * If `target` reverts with a revert reason, it is bubbled up by this
355      * function (like regular Solidity function calls).
356      *
357      * Returns the raw returned data. To convert to the expected return value,
358      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
359      *
360      * Requirements:
361      *
362      * - `target` must be a contract.
363      * - calling `target` with `data` must not revert.
364      *
365      * _Available since v3.1._
366      */
367     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
368       return functionCall(target, data, "Address: low-level call failed");
369     }
370 
371     /**
372      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
373      * `errorMessage` as a fallback revert reason when `target` reverts.
374      *
375      * _Available since v3.1._
376      */
377     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
378         return _functionCallWithValue(target, data, 0, errorMessage);
379     }
380 
381     /**
382      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
383      * but also transferring `value` wei to `target`.
384      *
385      * Requirements:
386      *
387      * - the calling contract must have an ETH balance of at least `value`.
388      * - the called Solidity function must be `payable`.
389      *
390      * _Available since v3.1._
391      */
392     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
393         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
394     }
395 
396     /**
397      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
398      * with `errorMessage` as a fallback revert reason when `target` reverts.
399      *
400      * _Available since v3.1._
401      */
402     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
403         require(address(this).balance >= value, "Address: insufficient balance for call");
404         return _functionCallWithValue(target, data, value, errorMessage);
405     }
406 
407     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
408         require(isContract(target), "Address: call to non-contract");
409 
410         // solhint-disable-next-line avoid-low-level-calls
411         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
412         if (success) {
413             return returndata;
414         } else {
415             // Look for revert reason and bubble it up if present
416             if (returndata.length > 0) {
417                 // The easiest way to bubble the revert reason is using memory via assembly
418 
419                 // solhint-disable-next-line no-inline-assembly
420                 assembly {
421                     let returndata_size := mload(returndata)
422                     revert(add(32, returndata), returndata_size)
423                 }
424             } else {
425                 revert(errorMessage);
426             }
427         }
428     }
429 }
430 
431 // SPDX-License-Identifier: MIT
432 
433 pragma solidity ^0.6.0;
434 
435 contract Wojak is Context, IERC20 {
436     using SafeMath for uint256;
437     using Address for address;
438 
439     mapping (address => uint256) private _balances;
440 
441     mapping (address => mapping (address => uint256)) private _allowances;
442 
443     uint256 private _totalSupply;
444     string private _name;
445     string private _symbol;
446     uint8 private _decimals;
447     
448 
449 
450     /**
451      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
452      * a default value of 18.
453      *
454      * To select a different value for {decimals}, use {_setupDecimals}.
455      *
456      * All three of these values are immutable: they can only be set once during
457      * construction.
458      */
459     constructor (string memory name, string memory symbol) public {
460         _name = name;
461         _symbol = symbol;
462         _decimals = 18;
463         _totalSupply = 11000 ether;
464         _balances[msg.sender] = _totalSupply;
465 
466     }
467 
468     /**
469      * @dev Returns the name of the token.
470      */
471     function name() public view returns (string memory) {
472         return _name;
473     }
474 
475     /**
476      * @dev Returns the symbol of the token, usually a shorter version of the
477      * name.
478      */
479     function symbol() public view returns (string memory) {
480         return _symbol;
481     }
482 
483     /**
484      * @dev Returns the number of decimals used to get its user representation.
485      * For example, if `decimals` equals `2`, a balance of `505` tokens should
486      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
487      *
488      * Tokens usually opt for a value of 18, imitating the relationship between
489      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
490      * called.
491      *
492      * NOTE: This information is only used for _display_ purposes: it in
493      * no way affects any of the arithmetic of the contract, including
494      * {IERC20-balanceOf} and {IERC20-transfer}.
495      */
496     function decimals() public view returns (uint8) {
497         return _decimals;
498     }
499 
500     /**
501      * @dev See {IERC20-totalSupply}.
502      */
503     function totalSupply() public view override returns (uint256) {
504         return _totalSupply;
505     }
506 
507     /**
508      * @dev See {IERC20-balanceOf}.
509      */
510     function balanceOf(address account) public view override returns (uint256) {
511         return _balances[account];
512     }
513 
514     
515 
516 
517     /**
518      * @dev See {IERC20-transfer}.
519      *
520      * Requirements:
521      *
522      * - `recipient` cannot be the zero address.
523      * - the caller must have a balance of at least `amount`.
524      */
525     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
526         _transfer(_msgSender(), recipient, amount);
527         return true;
528     }
529 
530     /**
531      * @dev See {IERC20-allowance}.
532      */
533     function allowance(address owner, address spender) public view virtual override returns (uint256) {
534         return _allowances[owner][spender];
535     }
536 
537     /**
538      * @dev See {IERC20-approve}.
539      *
540      * Requirements:
541      *
542      * - `spender` cannot be the zero address.
543      */
544     function approve(address spender, uint256 amount) public virtual override returns (bool) {
545         _approve(_msgSender(), spender, amount);
546         return true;
547     }
548 
549     /**
550      * @dev See {IERC20-transferFrom}.
551      *
552      * Emits an {Approval} event indicating the updated allowance. This is not
553      * required by the EIP. See the note at the beginning of {ERC20};
554      *
555      * Requirements:
556      * - `sender` and `recipient` cannot be the zero address.
557      * - `sender` must have a balance of at least `amount`.
558      * - the caller must have allowance for ``sender``'s tokens of at least
559      * `amount`.
560      */
561     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
562         _transfer(sender, recipient, amount);
563         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
564         return true;
565     }
566 
567     /**
568      * @dev Atomically increases the allowance granted to `spender` by the caller.
569      *
570      * This is an alternative to {approve} that can be used as a mitigation for
571      * problems described in {IERC20-approve}.
572      *
573      * Emits an {Approval} event indicating the updated allowance.
574      *
575      * Requirements:
576      *
577      * - `spender` cannot be the zero address.
578      */
579     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
580         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
581         return true;
582     }
583 
584     /**
585      * @dev Atomically decreases the allowance granted to `spender` by the caller.
586      *
587      * This is an alternative to {approve} that can be used as a mitigation for
588      * problems described in {IERC20-approve}.
589      *
590      * Emits an {Approval} event indicating the updated allowance.
591      *
592      * Requirements:
593      *
594      * - `spender` cannot be the zero address.
595      * - `spender` must have allowance for the caller of at least
596      * `subtractedValue`.
597      */
598     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
599         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
600         return true;
601     }
602 
603     /**
604      * @dev Moves tokens `amount` from `sender` to `recipient`.
605      *
606      * This is internal function is equivalent to {transfer}, and can be used to
607      * e.g. implement automatic token fees, slashing mechanisms, etc.
608      *
609      * Emits a {Transfer} event.
610      *
611      * Requirements:
612      *
613      * - `sender` cannot be the zero address.
614      * - `recipient` cannot be the zero address.
615      * - `sender` must have a balance of at least `amount`.
616      */
617     
618     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
619         require(sender != address(0), "ERC20: transfer from the zero address");
620         require(recipient != address(0), "ERC20: transfer to the zero address");
621 
622 
623         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
624         _balances[recipient] = _balances[recipient].add(amount);
625         emit Transfer(sender, recipient, amount);
626     }
627 
628 
629 
630     /**
631      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
632      *
633      * This is internal function is equivalent to `approve`, and can be used to
634      * e.g. set automatic allowances for certain subsystems, etc.
635      *
636      * Emits an {Approval} event.
637      *
638      * Requirements:
639      *
640      * - `owner` cannot be the zero address.
641      * - `spender` cannot be the zero address.
642      */
643     function _approve(address owner, address spender, uint256 amount) internal virtual {
644         require(owner != address(0), "ERC20: approve from the zero address");
645         require(spender != address(0), "ERC20: approve to the zero address");
646 
647         _allowances[owner][spender] = amount;
648         emit Approval(owner, spender, amount);
649     }
650 }