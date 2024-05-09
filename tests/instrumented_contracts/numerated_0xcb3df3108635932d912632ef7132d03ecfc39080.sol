1 // SPDX-License-Identifier: MIT
2 
3 //                          .
4 //                         ..
5 //                       . ..
6 //                     . ..,
7 //                  .. ...*
8 //         ,     .,  ...,/
9 //        ,., ,.,...,***.
10 //       *,/,.....,,*/
11 //     /*,,,,,,,,,*/
12 //    #**,.,,,,//(
13 //    #*,,,**/(//**,,**,**//
14 //    ./**/(****, .,/*******,*/**/*
15 //     ///******,,,,,,,,,,,*,*******//((
16 //      #(((///*********////*******//*//(%
17 //        #((/(((/((/**///////*/*(((/(/(##/
18 //          %####((((#(((#(((/(#######%%
19 //           (_)
20 //      __      ___ _ __   __ _ ___
21 //      \ \ /\ / / | '_ \ / _` / __|
22 //       \ V  V /| | | | | (_| \__ \
23 //        \_/\_/ |_|_| |_|\__, |___/
24 //                         __/ |
25 //                        |___/
26 
27 
28 pragma solidity 0.6.8;
29 
30 /*
31  * @dev Provides information about the current execution context, including the
32  * sender of the transaction and its data. While these are generally available
33  * via msg.sender and msg.data, they should not be accessed in such a direct
34  * manner, since when dealing with GSN meta-transactions the account sending and
35  * paying for execution may not be the actual sender (as far as an application
36  * is concerned).
37  *
38  * This contract is only required for intermediate, library-like contracts.
39  */
40 abstract contract Context {
41     function _msgSender() internal view virtual returns (address payable) {
42         return msg.sender;
43     }
44 
45     function _msgData() internal view virtual returns (bytes memory) {
46         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
47         return msg.data;
48     }
49 }
50 
51 //
52 /**
53  * @dev Interface of the ERC20 standard as defined in the EIP.
54  */
55 interface IERC20 {
56     /**
57      * @dev Returns the amount of tokens in existence.
58      */
59     function totalSupply() external view returns (uint256);
60 
61     /**
62      * @dev Returns the amount of tokens owned by `account`.
63      */
64     function balanceOf(address account) external view returns (uint256);
65 
66     /**
67      * @dev Moves `amount` tokens from the caller's account to `recipient`.
68      *
69      * Returns a boolean value indicating whether the operation succeeded.
70      *
71      * Emits a {Transfer} event.
72      */
73     function transfer(address recipient, uint256 amount) external returns (bool);
74 
75     /**
76      * @dev Returns the remaining number of tokens that `spender` will be
77      * allowed to spend on behalf of `owner` through {transferFrom}. This is
78      * zero by default.
79      *
80      * This value changes when {approve} or {transferFrom} are called.
81      */
82     function allowance(address owner, address spender) external view returns (uint256);
83 
84     /**
85      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
86      *
87      * Returns a boolean value indicating whether the operation succeeded.
88      *
89      * IMPORTANT: Beware that changing an allowance with this method brings the risk
90      * that someone may use both the old and the new allowance by unfortunate
91      * transaction ordering. One possible solution to mitigate this race
92      * condition is to first reduce the spender's allowance to 0 and set the
93      * desired value afterwards:
94      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
95      *
96      * Emits an {Approval} event.
97      */
98     function approve(address spender, uint256 amount) external returns (bool);
99 
100     /**
101      * @dev Moves `amount` tokens from `sender` to `recipient` using the
102      * allowance mechanism. `amount` is then deducted from the caller's
103      * allowance.
104      *
105      * Returns a boolean value indicating whether the operation succeeded.
106      *
107      * Emits a {Transfer} event.
108      */
109     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
110 
111     /**
112      * @dev Emitted when `value` tokens are moved from one account (`from`) to
113      * another (`to`).
114      *
115      * Note that `value` may be zero.
116      */
117     event Transfer(address indexed from, address indexed to, uint256 value);
118 
119     /**
120      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
121      * a call to {approve}. `value` is the new allowance.
122      */
123     event Approval(address indexed owner, address indexed spender, uint256 value);
124 }
125 
126 //
127 /**
128  * @dev Wrappers over Solidity's arithmetic operations with added overflow
129  * checks.
130  *
131  * Arithmetic operations in Solidity wrap on overflow. This can easily result
132  * in bugs, because programmers usually assume that an overflow raises an
133  * error, which is the standard behavior in high level programming languages.
134  * `SafeMath` restores this intuition by reverting the transaction when an
135  * operation overflows.
136  *
137  * Using this library instead of the unchecked operations eliminates an entire
138  * class of bugs, so it's recommended to use it always.
139  */
140 library SafeMath {
141     /**
142      * @dev Returns the addition of two unsigned integers, reverting on
143      * overflow.
144      *
145      * Counterpart to Solidity's `+` operator.
146      *
147      * Requirements:
148      *
149      * - Addition cannot overflow.
150      */
151     function add(uint256 a, uint256 b) internal pure returns (uint256) {
152         uint256 c = a + b;
153         require(c >= a, "SafeMath: addition overflow");
154 
155         return c;
156     }
157 
158     /**
159      * @dev Returns the subtraction of two unsigned integers, reverting on
160      * overflow (when the result is negative).
161      *
162      * Counterpart to Solidity's `-` operator.
163      *
164      * Requirements:
165      *
166      * - Subtraction cannot overflow.
167      */
168     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
169         return sub(a, b, "SafeMath: subtraction overflow");
170     }
171 
172     /**
173      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
174      * overflow (when the result is negative).
175      *
176      * Counterpart to Solidity's `-` operator.
177      *
178      * Requirements:
179      *
180      * - Subtraction cannot overflow.
181      */
182     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
183         require(b <= a, errorMessage);
184         uint256 c = a - b;
185 
186         return c;
187     }
188 
189     /**
190      * @dev Returns the multiplication of two unsigned integers, reverting on
191      * overflow.
192      *
193      * Counterpart to Solidity's `*` operator.
194      *
195      * Requirements:
196      *
197      * - Multiplication cannot overflow.
198      */
199     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
200         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
201         // benefit is lost if 'b' is also tested.
202         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
203         if (a == 0) {
204             return 0;
205         }
206 
207         uint256 c = a * b;
208         require(c / a == b, "SafeMath: multiplication overflow");
209 
210         return c;
211     }
212 
213     /**
214      * @dev Returns the integer division of two unsigned integers. Reverts on
215      * division by zero. The result is rounded towards zero.
216      *
217      * Counterpart to Solidity's `/` operator. Note: this function uses a
218      * `revert` opcode (which leaves remaining gas untouched) while Solidity
219      * uses an invalid opcode to revert (consuming all remaining gas).
220      *
221      * Requirements:
222      *
223      * - The divisor cannot be zero.
224      */
225     function div(uint256 a, uint256 b) internal pure returns (uint256) {
226         return div(a, b, "SafeMath: division by zero");
227     }
228 
229     /**
230      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
231      * division by zero. The result is rounded towards zero.
232      *
233      * Counterpart to Solidity's `/` operator. Note: this function uses a
234      * `revert` opcode (which leaves remaining gas untouched) while Solidity
235      * uses an invalid opcode to revert (consuming all remaining gas).
236      *
237      * Requirements:
238      *
239      * - The divisor cannot be zero.
240      */
241     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
242         require(b > 0, errorMessage);
243         uint256 c = a / b;
244         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
245 
246         return c;
247     }
248 
249     /**
250      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
251      * Reverts when dividing by zero.
252      *
253      * Counterpart to Solidity's `%` operator. This function uses a `revert`
254      * opcode (which leaves remaining gas untouched) while Solidity uses an
255      * invalid opcode to revert (consuming all remaining gas).
256      *
257      * Requirements:
258      *
259      * - The divisor cannot be zero.
260      */
261     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
262         return mod(a, b, "SafeMath: modulo by zero");
263     }
264 
265     /**
266      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
267      * Reverts with custom message when dividing by zero.
268      *
269      * Counterpart to Solidity's `%` operator. This function uses a `revert`
270      * opcode (which leaves remaining gas untouched) while Solidity uses an
271      * invalid opcode to revert (consuming all remaining gas).
272      *
273      * Requirements:
274      *
275      * - The divisor cannot be zero.
276      */
277     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
278         require(b != 0, errorMessage);
279         return a % b;
280     }
281 }
282 
283 //
284 /**
285  * @dev Collection of functions related to the address type
286  */
287 library Address {
288     /**
289      * @dev Returns true if `account` is a contract.
290      *
291      * [IMPORTANT]
292      * ====
293      * It is unsafe to assume that an address for which this function returns
294      * false is an externally-owned account (EOA) and not a contract.
295      *
296      * Among others, `isContract` will return false for the following
297      * types of addresses:
298      *
299      *  - an externally-owned account
300      *  - a contract in construction
301      *  - an address where a contract will be created
302      *  - an address where a contract lived, but was destroyed
303      * ====
304      */
305     function isContract(address account) internal view returns (bool) {
306         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
307         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
308         // for accounts without code, i.e. `keccak256('')`
309         bytes32 codehash;
310         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
311         // solhint-disable-next-line no-inline-assembly
312         assembly { codehash := extcodehash(account) }
313         return (codehash != accountHash && codehash != 0x0);
314     }
315 
316     /**
317      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
318      * `recipient`, forwarding all available gas and reverting on errors.
319      *
320      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
321      * of certain opcodes, possibly making contracts go over the 2300 gas limit
322      * imposed by `transfer`, making them unable to receive funds via
323      * `transfer`. {sendValue} removes this limitation.
324      *
325      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
326      *
327      * IMPORTANT: because control is transferred to `recipient`, care must be
328      * taken to not create reentrancy vulnerabilities. Consider using
329      * {ReentrancyGuard} or the
330      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
331      */
332     function sendValue(address payable recipient, uint256 amount) internal {
333         require(address(this).balance >= amount, "Address: insufficient balance");
334 
335         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
336         (bool success, ) = recipient.call{ value: amount }("");
337         require(success, "Address: unable to send value, recipient may have reverted");
338     }
339 
340     /**
341      * @dev Performs a Solidity function call using a low level `call`. A
342      * plain`call` is an unsafe replacement for a function call: use this
343      * function instead.
344      *
345      * If `target` reverts with a revert reason, it is bubbled up by this
346      * function (like regular Solidity function calls).
347      *
348      * Returns the raw returned data. To convert to the expected return value,
349      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
350      *
351      * Requirements:
352      *
353      * - `target` must be a contract.
354      * - calling `target` with `data` must not revert.
355      *
356      * _Available since v3.1._
357      */
358     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
359         return functionCall(target, data, "Address: low-level call failed");
360     }
361 
362     /**
363      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
364      * `errorMessage` as a fallback revert reason when `target` reverts.
365      *
366      * _Available since v3.1._
367      */
368     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
369         return _functionCallWithValue(target, data, 0, errorMessage);
370     }
371 
372     /**
373      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
374      * but also transferring `value` wei to `target`.
375      *
376      * Requirements:
377      *
378      * - the calling contract must have an ETH balance of at least `value`.
379      * - the called Solidity function must be `payable`.
380      *
381      * _Available since v3.1._
382      */
383     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
384         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
385     }
386 
387     /**
388      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
389      * with `errorMessage` as a fallback revert reason when `target` reverts.
390      *
391      * _Available since v3.1._
392      */
393     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
394         require(address(this).balance >= value, "Address: insufficient balance for call");
395         return _functionCallWithValue(target, data, value, errorMessage);
396     }
397 
398     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
399         require(isContract(target), "Address: call to non-contract");
400 
401         // solhint-disable-next-line avoid-low-level-calls
402         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
403         if (success) {
404             return returndata;
405         } else {
406             // Look for revert reason and bubble it up if present
407             if (returndata.length > 0) {
408                 // The easiest way to bubble the revert reason is using memory via assembly
409 
410                 // solhint-disable-next-line no-inline-assembly
411                 assembly {
412                     let returndata_size := mload(returndata)
413                     revert(add(32, returndata), returndata_size)
414                 }
415             } else {
416                 revert(errorMessage);
417             }
418         }
419     }
420 }
421 
422 //
423 /**
424  * @dev Implementation of the {IERC20} interface.
425  *
426  * This implementation is agnostic to the way tokens are created. This means
427  * that a supply mechanism has to be added in a derived contract using {_mint}.
428  * For a generic mechanism see {ERC20PresetMinterPauser}.
429  *
430  * TIP: For a detailed writeup see our guide
431  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
432  * to implement supply mechanisms].
433  *
434  * We have followed general OpenZeppelin guidelines: functions revert instead
435  * of returning `false` on failure. This behavior is nonetheless conventional
436  * and does not conflict with the expectations of ERC20 applications.
437  *
438  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
439  * This allows applications to reconstruct the allowance for all accounts just
440  * by listening to said events. Other implementations of the EIP may not emit
441  * these events, as it isn't required by the specification.
442  *
443  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
444  * functions have been added to mitigate the well-known issues around setting
445  * allowances. See {IERC20-approve}.
446  */
447 contract ERC20 is Context, IERC20 {
448     using SafeMath for uint256;
449     using Address for address;
450 
451     mapping (address => uint256) internal _balances;
452 
453     mapping (address => mapping (address => uint256)) private _allowances;
454 
455     uint256 internal _totalSupply;
456 
457     string private _name;
458     string private _symbol;
459     uint8 private _decimals;
460 
461     // Token holders
462     mapping (uint256 => address) public tokenHolders;
463     mapping (address => uint256) public holderIDs;
464     uint256 public holdersCount;
465     uint256 public _minHolderAmount = 1000E18;
466 
467     /**
468      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
469      * a default value of 18.
470      *
471      * To select a different value for {decimals}, use {_setupDecimals}.
472      *
473      * All three of these values are immutable: they can only be set once during
474      * construction.
475      */
476     constructor (string memory name, string memory symbol) public {
477         _name = name;
478         _symbol = symbol;
479         _decimals = 18;
480     }
481 
482     /**
483      * @dev Returns the name of the token.
484      */
485     function name() public view returns (string memory) {
486         return _name;
487     }
488 
489     /**
490      * @dev Returns the symbol of the token, usually a shorter version of the
491      * name.
492      */
493     function symbol() public view returns (string memory) {
494         return _symbol;
495     }
496 
497     /**
498      * @dev Returns the number of decimals used to get its user representation.
499      * For example, if `decimals` equals `2`, a balance of `505` tokens should
500      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
501      *
502      * Tokens usually opt for a value of 18, imitating the relationship between
503      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
504      * called.
505      *
506      * NOTE: This information is only used for _display_ purposes: it in
507      * no way affects any of the arithmetic of the contract, including
508      * {IERC20-balanceOf} and {IERC20-transfer}.
509      */
510     function decimals() public view returns (uint8) {
511         return _decimals;
512     }
513 
514     /**
515      * @dev See {IERC20-totalSupply}.
516      */
517     function totalSupply() public view override returns (uint256) {
518         return _totalSupply;
519     }
520 
521     /**
522      * @dev See {IERC20-balanceOf}.
523      */
524     function balanceOf(address account) public view override returns (uint256) {
525         return _balances[account];
526     }
527 
528     /**
529      * @dev See {IERC20-transfer}.
530      *
531      * Requirements:
532      *
533      * - `recipient` cannot be the zero address.
534      * - the caller must have a balance of at least `amount`.
535      */
536     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
537         _transfer(_msgSender(), recipient, amount);
538         return true;
539     }
540 
541     /**
542      * @dev See {IERC20-allowance}.
543      */
544     function allowance(address owner, address spender) public view virtual override returns (uint256) {
545         return _allowances[owner][spender];
546     }
547 
548     /**
549      * @dev See {IERC20-approve}.
550      *
551      * Requirements:
552      *
553      * - `spender` cannot be the zero address.
554      */
555     function approve(address spender, uint256 amount) public virtual override returns (bool) {
556         _approve(_msgSender(), spender, amount);
557         return true;
558     }
559 
560     /**
561      * @dev See {IERC20-transferFrom}.
562      *
563      * Emits an {Approval} event indicating the updated allowance. This is not
564      * required by the EIP. See the note at the beginning of {ERC20};
565      *
566      * Requirements:
567      * - `sender` and `recipient` cannot be the zero address.
568      * - `sender` must have a balance of at least `amount`.
569      * - the caller must have allowance for ``sender``'s tokens of at least
570      * `amount`.
571      */
572     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
573         _transfer(sender, recipient, amount);
574         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
575         return true;
576     }
577 
578     /**
579      * @dev Atomically increases the allowance granted to `spender` by the caller.
580      *
581      * This is an alternative to {approve} that can be used as a mitigation for
582      * problems described in {IERC20-approve}.
583      *
584      * Emits an {Approval} event indicating the updated allowance.
585      *
586      * Requirements:
587      *
588      * - `spender` cannot be the zero address.
589      */
590     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
591         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
592         return true;
593     }
594 
595     /**
596      * @dev Atomically decreases the allowance granted to `spender` by the caller.
597      *
598      * This is an alternative to {approve} that can be used as a mitigation for
599      * problems described in {IERC20-approve}.
600      *
601      * Emits an {Approval} event indicating the updated allowance.
602      *
603      * Requirements:
604      *
605      * - `spender` cannot be the zero address.
606      * - `spender` must have allowance for the caller of at least
607      * `subtractedValue`.
608      */
609     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
610         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
611         return true;
612     }
613 
614     /**
615      * @dev Moves tokens `amount` from `sender` to `recipient`.
616      *
617      * This is internal function is equivalent to {transfer}, and can be used to
618      * e.g. implement automatic token fees, slashing mechanisms, etc.
619      *
620      * Emits a {Transfer} event.
621      *
622      * Requirements:
623      *
624      * - `sender` cannot be the zero address.
625      * - `recipient` cannot be the zero address.
626      * - `sender` must have a balance of at least `amount`.
627      */
628     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
629         require(sender != address(0), "ERC20: transfer from the zero address");
630         require(recipient != address(0), "ERC20: transfer to the zero address");
631 
632         _beforeTokenTransfer(sender, recipient, amount);
633 
634         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
635         updateHolders(sender, recipient, amount);
636         _balances[recipient] = _balances[recipient].add(amount);
637 
638         emit Transfer(sender, recipient, amount);
639     }
640 
641     function updateHolders(address sender, address recipient, uint256 amount) internal {
642         if (_balances[sender] < _minHolderAmount) {
643             // remove sender from holders
644             // switch latest id to removed id
645             tokenHolders[holderIDs[sender]] = tokenHolders[holdersCount];
646             holderIDs[tokenHolders[holdersCount]] = holderIDs[sender];
647             delete tokenHolders[holdersCount];
648             delete holderIDs[sender];
649             holdersCount--;
650         }
651         if (_balances[recipient] < _minHolderAmount && (_balances[recipient].add(amount) >= _minHolderAmount)) {
652             // add recipient to holders
653             tokenHolders[holdersCount + 1] = recipient;
654             holderIDs[recipient] =  holdersCount + 1;
655             holdersCount++;
656         }
657     }
658 
659     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
660      * the total supply.
661      *
662      * Emits a {Transfer} event with `from` set to the zero address.
663      *
664      * Requirements
665      *
666      * - `to` cannot be the zero address.
667      */
668     function _mint(address account, uint256 amount) internal virtual {
669         require(account != address(0), "ERC20: mint to the zero address");
670 
671         _beforeTokenTransfer(address(0), account, amount);
672 
673         _totalSupply = _totalSupply.add(amount);
674         if (_balances[account] == 0) {
675             // add recipient to holders
676             tokenHolders[holdersCount + 1] = account;
677             holderIDs[account] =  holdersCount + 1;
678             holdersCount++;
679         }
680         _balances[account] = _balances[account].add(amount);
681         emit Transfer(address(0), account, amount);
682     }
683 
684     /**
685      * @dev Destroys `amount` tokens from `account`, reducing the
686      * total supply.
687      *
688      * Emits a {Transfer} event with `to` set to the zero address.
689      *
690      * Requirements
691      *
692      * - `account` cannot be the zero address.
693      * - `account` must have at least `amount` tokens.
694      */
695     function _burn(address account, uint256 amount) internal virtual {
696         require(account != address(0), "ERC20: burn from the zero address");
697 
698         _beforeTokenTransfer(account, address(0), amount);
699 
700         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
701         _totalSupply = _totalSupply.sub(amount);
702         emit Transfer(account, address(0), amount);
703     }
704 
705     /**
706      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
707      *
708      * This is internal function is equivalent to `approve`, and can be used to
709      * e.g. set automatic allowances for certain subsystems, etc.
710      *
711      * Emits an {Approval} event.
712      *
713      * Requirements:
714      *
715      * - `owner` cannot be the zero address.
716      * - `spender` cannot be the zero address.
717      */
718     function _approve(address owner, address spender, uint256 amount) internal virtual {
719         require(owner != address(0), "ERC20: approve from the zero address");
720         require(spender != address(0), "ERC20: approve to the zero address");
721 
722         _allowances[owner][spender] = amount;
723         emit Approval(owner, spender, amount);
724     }
725 
726     /**
727      * @dev Sets {decimals} to a value other than the default one of 18.
728      *
729      * WARNING: This function should only be called from the constructor. Most
730      * applications that interact with token contracts will not expect
731      * {decimals} to ever change, and may work incorrectly if it does.
732      */
733     function _setupDecimals(uint8 decimals_) internal {
734         _decimals = decimals_;
735     }
736 
737     /**
738      * @dev Hook that is called before any transfer of tokens. This includes
739      * minting and burning.
740      *
741      * Calling conditions:
742      *
743      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
744      * will be to transferred to `to`.
745      * - when `from` is zero, `amount` tokens will be minted for `to`.
746      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
747      * - `from` and `to` are never both zero.
748      *
749      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
750      */
751     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
752 }
753 
754 //
755 /**
756  * @dev Contract module which provides a basic access control mechanism, where
757  * there is an account (an owner) that can be granted exclusive access to
758  * specific functions.
759  *
760  * By default, the owner account will be the one that deploys the contract. This
761  * can later be changed with {transferOwnership}.
762  *
763  * This module is used through inheritance. It will make available the modifier
764  * `onlyOwner`, which can be applied to your functions to restrict their use to
765  * the owner.
766  */
767 contract Ownable is Context {
768     address private _owner;
769 
770     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
771 
772     /**
773      * @dev Initializes the contract setting the deployer as the initial owner.
774      */
775     constructor () internal {
776         address msgSender = _msgSender();
777         _owner = msgSender;
778         emit OwnershipTransferred(address(0), msgSender);
779     }
780 
781     /**
782      * @dev Returns the address of the current owner.
783      */
784     function owner() public view returns (address) {
785         return _owner;
786     }
787 
788     /**
789      * @dev Throws if called by any account other than the owner.
790      */
791     modifier onlyOwner() {
792         require(_owner == _msgSender(), "Ownable: caller is not the owner");
793         _;
794     }
795 
796     /**
797      * @dev Leaves the contract without owner. It will not be possible to call
798      * `onlyOwner` functions anymore. Can only be called by the current owner.
799      *
800      * NOTE: Renouncing ownership will leave the contract without an owner,
801      * thereby removing any functionality that is only available to the owner.
802      */
803     function renounceOwnership() public virtual onlyOwner {
804         emit OwnershipTransferred(_owner, address(0));
805         _owner = address(0);
806     }
807 
808     /**
809      * @dev Transfers ownership of the contract to a new account (`newOwner`).
810      * Can only be called by the current owner.
811      */
812     function transferOwnership(address newOwner) public virtual onlyOwner {
813         require(newOwner != address(0), "Ownable: new owner is the zero address");
814         emit OwnershipTransferred(_owner, newOwner);
815         _owner = newOwner;
816     }
817 }
818 
819 //
820 interface IUniswapV2Pair {
821     function sync() external;
822 }
823 
824 interface IUniswapV2Factory {
825     function createPair(address tokenA, address tokenB) external returns (address pair);
826 }
827 
828 contract WingsToken is ERC20, Ownable {
829     using SafeMath for uint256;
830 
831     // BAKE
832 
833     uint256 public lastBakeTime;
834 
835     uint256 public totalBaked;
836 
837     uint256 public constant BAKE_RATE = 5; // bake rate per day (5%)
838 
839     uint256 public constant BAKE_REWARD = 1;
840 
841     // REWARDS
842 
843     uint256 public constant POOL_REWARD = 48;
844 
845     uint256 public lastRewardTime;
846 
847     uint256 public rewardPool;
848 
849     mapping (address => uint256) public claimedRewards;
850 
851     mapping (address => uint256) public unclaimedRewards;
852 
853     // mapping of top holders that owner update before paying out rewards
854     mapping (uint256 => address) public topHolder;
855 
856     // maximum of top topHolder
857     uint256 public constant MAX_TOP_HOLDERS = 50;
858 
859     uint256 internal totalTopHolders;
860 
861     // Pause for allowing tokens to only become transferable at the end of sale
862 
863     address public pauser;
864 
865     bool public paused;
866 
867     // UNISWAP
868 
869     ERC20 internal WETH = ERC20(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2);
870 
871     IUniswapV2Factory public uniswapFactory = IUniswapV2Factory(0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f);
872 
873     address public uniswapPool;
874 
875     // Random Distribution Daily
876     uint256 public randomRewardAmount = 5000E18;
877     uint256 public randomWallets = 10;
878     uint256 public _lastDistribution;
879 
880     // External Caller
881     address public externalCaller;
882 
883     // MODIFIERS
884 
885     modifier onlyPauser() {
886         require(pauser == _msgSender(), "Wings: caller is not the pauser.");
887         _;
888     }
889 
890     modifier onlyExternalCaller() {
891         require(externalCaller == _msgSender(), "Wings: caller is not the external caller.");
892         _;
893     }
894 
895     modifier whenNotPaused() {
896         require(!paused, "Wings: paused");
897         _;
898     }
899 
900     modifier when3DaysBetweenLastSnapshot() {
901         require((now - lastRewardTime) >= 3 days, "Wings: not enough days since last snapshot taken.");
902         _;
903     }
904 
905     // EVENTS
906 
907     event PoolBaked(address tender, uint256 bakeAmount, uint256 newTotalSupply, uint256 newUniswapPoolSupply, uint256 userReward, uint256 newPoolReward);
908 
909     event PayoutSnapshotTaken(uint256 totalTopHolders, uint256 totalPayout, uint256 snapshot);
910 
911     event PayoutClaimed(address indexed topHolderAddress, uint256 claimedReward);
912 
913     constructor(uint256 initialSupply, address new_owner)
914     public
915     Ownable()
916     ERC20("Wings", "WING")
917     {
918         uint mint_amount = initialSupply * 10 ** uint(decimals());
919         _mint(new_owner, mint_amount);
920         setPauser(new_owner);
921         paused = true;
922         transferOwnership(new_owner);
923     }
924 
925     function setUniswapPool() external onlyOwner {
926         require(uniswapPool == address(0), "Wings: pool already created");
927         uniswapPool = uniswapFactory.createPair(address(WETH), address(this));
928     }
929 
930     // PAUSE
931 
932     function setPauser(address newPauser) public onlyOwner {
933         require(newPauser != address(0), "Wings: pauser is the zero address.");
934         pauser = newPauser;
935     }
936 
937     function unpause() external onlyPauser {
938         paused = false;
939 
940         // Start baking
941         lastBakeTime = now;
942         lastRewardTime = now;
943         rewardPool = 0;
944     }
945 
946     function pause() external onlyPauser {
947         paused = true;
948     }
949 
950     // TOKEN TRANSFER HOOK
951     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override {
952         super._beforeTokenTransfer(from, to, amount);
953         require(!paused || msg.sender == pauser, "Wings: token transfer while paused and not pauser role.");
954     }
955 
956     // BAKERS
957 
958     function getInfoFor(address addr) public view returns (uint256, uint256, uint256, uint256, uint256, uint256, uint256, uint256, uint256) {
959         return (
960         balanceOf(addr),
961         claimedRewards[addr],
962         balanceOf(uniswapPool),
963         _totalSupply,
964         totalBaked,
965         getBakeAmount(),
966         lastBakeTime,
967         lastRewardTime,
968         rewardPool
969         );
970     }
971 
972     function bakePool() external {
973         uint256 bakeAmount = getBakeAmount();
974         require(bakeAmount >= 1 * 1e18, "bakePool: min bake amount not reached.");
975 
976         // Reset last bake time
977         lastBakeTime = now;
978 
979         uint256 userReward = bakeAmount.mul(BAKE_REWARD).div(100);
980         uint256 poolReward = bakeAmount.mul(POOL_REWARD).div(100);
981         uint256 finalBake = bakeAmount.sub(userReward).sub(poolReward);
982 
983         _totalSupply = _totalSupply.sub(finalBake);
984         _balances[uniswapPool] = _balances[uniswapPool].sub(bakeAmount);
985 
986         totalBaked = totalBaked.add(finalBake);
987         rewardPool = rewardPool.add(poolReward);
988 
989         _balances[msg.sender] = _balances[msg.sender].add(userReward);
990 
991         IUniswapV2Pair(uniswapPool).sync();
992 
993         emit PoolBaked(msg.sender, bakeAmount, _totalSupply, balanceOf(uniswapPool), userReward, poolReward);
994     }
995 
996     function getBakeAmount() public view returns (uint256) {
997         if (paused) return 0;
998         uint256 timeBetweenLastBake = now - lastBakeTime;
999         uint256 tokensInUniswapPool = balanceOf(uniswapPool);
1000         uint256 dayInSeconds = 1 days;
1001         return (tokensInUniswapPool.mul(BAKE_RATE)
1002         .mul(timeBetweenLastBake))
1003         .div(dayInSeconds)
1004         .div(100);
1005     }
1006 
1007     // Rewards
1008 
1009     function updateTopHolders(address[] calldata holders) external onlyOwner when3DaysBetweenLastSnapshot {
1010         totalTopHolders = holders.length < MAX_TOP_HOLDERS ? holders.length : MAX_TOP_HOLDERS;
1011 
1012         // Calculate payout and take snapshot
1013         uint256 toPayout = rewardPool.div(totalTopHolders);
1014         uint256 totalPayoutSent = rewardPool;
1015         for (uint256 i = 0; i < totalTopHolders; i++) {
1016             unclaimedRewards[holders[i]] = unclaimedRewards[holders[i]].add(toPayout);
1017         }
1018 
1019         // Reset rewards pool
1020         lastRewardTime = now;
1021         rewardPool = 0;
1022 
1023         emit PayoutSnapshotTaken(totalTopHolders, totalPayoutSent, now);
1024     }
1025 
1026     function claimRewards() external {
1027         require(unclaimedRewards[msg.sender] > 0, "Wings: nothing left to claim.");
1028 
1029         uint256 unclaimedReward = unclaimedRewards[msg.sender];
1030         unclaimedRewards[msg.sender] = 0;
1031         claimedRewards[msg.sender] = claimedRewards[msg.sender].add(unclaimedReward);
1032         _balances[msg.sender] = _balances[msg.sender].add(unclaimedReward);
1033 
1034         emit PayoutClaimed(msg.sender, unclaimedReward);
1035     }
1036 
1037     function distributeRandomly(uint256 seed) external onlyExternalCaller {
1038         require(holdersCount > 10, "There should be at least 10 holders");
1039         require(now.sub(_lastDistribution) >= 1 days, "You can only call this function once in a day");
1040         _lastDistribution = now;
1041         uint256 randomNumber = uint256(keccak256(abi.encodePacked(seed, now, block.difficulty))).mod(holdersCount);
1042         if (holdersCount.sub(randomNumber) < randomWallets) {
1043             randomNumber = randomNumber.sub(randomWallets.sub(1));
1044         }
1045         for (uint256 i = 1; i < randomWallets + 1; i++) {
1046             _transfer(address(this), tokenHolders[randomNumber.add(i)], randomRewardAmount);
1047         }
1048     }
1049 
1050     function updateRandomWallets(uint256 randomWalletCount) external onlyOwner {
1051         randomWallets = randomWalletCount;
1052     }
1053 
1054     function updateRandomRewardAmount(uint256 rewardAmount) external onlyOwner {
1055         randomRewardAmount = rewardAmount;
1056     }
1057 
1058     function updateExternalCaller(address externalCallerAddr) external onlyOwner {
1059         externalCaller = externalCallerAddr;
1060     }
1061 
1062     function withdrawTokens() external onlyOwner {
1063         _transfer(address(this), owner(), balanceOf(address(this)));
1064     }
1065 
1066     function updateMinHolderAmount(uint256 minHolderAmount) external onlyOwner {
1067         _minHolderAmount = minHolderAmount;
1068     }
1069 }