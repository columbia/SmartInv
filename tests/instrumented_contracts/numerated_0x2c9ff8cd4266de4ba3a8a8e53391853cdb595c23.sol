1 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Address.sol
2 
3 // SPDX-License-Identifier: MIT
4 
5 pragma solidity ^0.6.2;
6 
7 /**
8  * @dev Collection of functions related to the address type
9  */
10 library Address {
11     /**
12      * @dev Returns true if `account` is a contract.
13      *
14      * [IMPORTANT]
15      * ====
16      * It is unsafe to assume that an address for which this function returns
17      * false is an externally-owned account (EOA) and not a contract.
18      *
19      * Among others, `isContract` will return false for the following
20      * types of addresses:
21      *
22      *  - an externally-owned account
23      *  - a contract in construction
24      *  - an address where a contract will be created
25      *  - an address where a contract lived, but was destroyed
26      * ====
27      */
28     function isContract(address account) internal view returns (bool) {
29         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
30         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
31         // for accounts without code, i.e. `keccak256('')`
32         bytes32 codehash;
33         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
34         // solhint-disable-next-line no-inline-assembly
35         assembly { codehash := extcodehash(account) }
36         return (codehash != accountHash && codehash != 0x0);
37     }
38 
39     /**
40      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
41      * `recipient`, forwarding all available gas and reverting on errors.
42      *
43      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
44      * of certain opcodes, possibly making contracts go over the 2300 gas limit
45      * imposed by `transfer`, making them unable to receive funds via
46      * `transfer`. {sendValue} removes this limitation.
47      *
48      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
49      *
50      * IMPORTANT: because control is transferred to `recipient`, care must be
51      * taken to not create reentrancy vulnerabilities. Consider using
52      * {ReentrancyGuard} or the
53      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
54      */
55     function sendValue(address payable recipient, uint256 amount) internal {
56         require(address(this).balance >= amount, "Address: insufficient balance");
57 
58         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
59         (bool success, ) = recipient.call{ value: amount }("");
60         require(success, "Address: unable to send value, recipient may have reverted");
61     }
62 
63     /**
64      * @dev Performs a Solidity function call using a low level `call`. A
65      * plain`call` is an unsafe replacement for a function call: use this
66      * function instead.
67      *
68      * If `target` reverts with a revert reason, it is bubbled up by this
69      * function (like regular Solidity function calls).
70      *
71      * Returns the raw returned data. To convert to the expected return value,
72      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
73      *
74      * Requirements:
75      *
76      * - `target` must be a contract.
77      * - calling `target` with `data` must not revert.
78      *
79      * _Available since v3.1._
80      */
81     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
82       return functionCall(target, data, "Address: low-level call failed");
83     }
84 
85     /**
86      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
87      * `errorMessage` as a fallback revert reason when `target` reverts.
88      *
89      * _Available since v3.1._
90      */
91     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
92         return _functionCallWithValue(target, data, 0, errorMessage);
93     }
94 
95     /**
96      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
97      * but also transferring `value` wei to `target`.
98      *
99      * Requirements:
100      *
101      * - the calling contract must have an ETH balance of at least `value`.
102      * - the called Solidity function must be `payable`.
103      *
104      * _Available since v3.1._
105      */
106     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
107         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
108     }
109 
110     /**
111      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
112      * with `errorMessage` as a fallback revert reason when `target` reverts.
113      *
114      * _Available since v3.1._
115      */
116     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
117         require(address(this).balance >= value, "Address: insufficient balance for call");
118         return _functionCallWithValue(target, data, value, errorMessage);
119     }
120 
121     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
122         require(isContract(target), "Address: call to non-contract");
123 
124         // solhint-disable-next-line avoid-low-level-calls
125         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
126         if (success) {
127             return returndata;
128         } else {
129             // Look for revert reason and bubble it up if present
130             if (returndata.length > 0) {
131                 // The easiest way to bubble the revert reason is using memory via assembly
132 
133                 // solhint-disable-next-line no-inline-assembly
134                 assembly {
135                     let returndata_size := mload(returndata)
136                     revert(add(32, returndata), returndata_size)
137                 }
138             } else {
139                 revert(errorMessage);
140             }
141         }
142     }
143 }
144 
145 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/math/SafeMath.sol
146 
147 // SPDX-License-Identifier: MIT
148 
149 pragma solidity ^0.6.0;
150 
151 /**
152  * @dev Wrappers over Solidity's arithmetic operations with added overflow
153  * checks.
154  *
155  * Arithmetic operations in Solidity wrap on overflow. This can easily result
156  * in bugs, because programmers usually assume that an overflow raises an
157  * error, which is the standard behavior in high level programming languages.
158  * `SafeMath` restores this intuition by reverting the transaction when an
159  * operation overflows.
160  *
161  * Using this library instead of the unchecked operations eliminates an entire
162  * class of bugs, so it's recommended to use it always.
163  */
164 library SafeMath {
165     /**
166      * @dev Returns the addition of two unsigned integers, reverting on
167      * overflow.
168      *
169      * Counterpart to Solidity's `+` operator.
170      *
171      * Requirements:
172      *
173      * - Addition cannot overflow.
174      */
175     function add(uint256 a, uint256 b) internal pure returns (uint256) {
176         uint256 c = a + b;
177         require(c >= a, "SafeMath: addition overflow");
178 
179         return c;
180     }
181 
182     /**
183      * @dev Returns the subtraction of two unsigned integers, reverting on
184      * overflow (when the result is negative).
185      *
186      * Counterpart to Solidity's `-` operator.
187      *
188      * Requirements:
189      *
190      * - Subtraction cannot overflow.
191      */
192     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
193         return sub(a, b, "SafeMath: subtraction overflow");
194     }
195 
196     /**
197      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
198      * overflow (when the result is negative).
199      *
200      * Counterpart to Solidity's `-` operator.
201      *
202      * Requirements:
203      *
204      * - Subtraction cannot overflow.
205      */
206     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
207         require(b <= a, errorMessage);
208         uint256 c = a - b;
209 
210         return c;
211     }
212 
213     /**
214      * @dev Returns the multiplication of two unsigned integers, reverting on
215      * overflow.
216      *
217      * Counterpart to Solidity's `*` operator.
218      *
219      * Requirements:
220      *
221      * - Multiplication cannot overflow.
222      */
223     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
224         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
225         // benefit is lost if 'b' is also tested.
226         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
227         if (a == 0) {
228             return 0;
229         }
230 
231         uint256 c = a * b;
232         require(c / a == b, "SafeMath: multiplication overflow");
233 
234         return c;
235     }
236 
237     /**
238      * @dev Returns the integer division of two unsigned integers. Reverts on
239      * division by zero. The result is rounded towards zero.
240      *
241      * Counterpart to Solidity's `/` operator. Note: this function uses a
242      * `revert` opcode (which leaves remaining gas untouched) while Solidity
243      * uses an invalid opcode to revert (consuming all remaining gas).
244      *
245      * Requirements:
246      *
247      * - The divisor cannot be zero.
248      */
249     function div(uint256 a, uint256 b) internal pure returns (uint256) {
250         return div(a, b, "SafeMath: division by zero");
251     }
252 
253     /**
254      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
255      * division by zero. The result is rounded towards zero.
256      *
257      * Counterpart to Solidity's `/` operator. Note: this function uses a
258      * `revert` opcode (which leaves remaining gas untouched) while Solidity
259      * uses an invalid opcode to revert (consuming all remaining gas).
260      *
261      * Requirements:
262      *
263      * - The divisor cannot be zero.
264      */
265     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
266         require(b > 0, errorMessage);
267         uint256 c = a / b;
268         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
269 
270         return c;
271     }
272 
273     /**
274      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
275      * Reverts when dividing by zero.
276      *
277      * Counterpart to Solidity's `%` operator. This function uses a `revert`
278      * opcode (which leaves remaining gas untouched) while Solidity uses an
279      * invalid opcode to revert (consuming all remaining gas).
280      *
281      * Requirements:
282      *
283      * - The divisor cannot be zero.
284      */
285     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
286         return mod(a, b, "SafeMath: modulo by zero");
287     }
288 
289     /**
290      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
291      * Reverts with custom message when dividing by zero.
292      *
293      * Counterpart to Solidity's `%` operator. This function uses a `revert`
294      * opcode (which leaves remaining gas untouched) while Solidity uses an
295      * invalid opcode to revert (consuming all remaining gas).
296      *
297      * Requirements:
298      *
299      * - The divisor cannot be zero.
300      */
301     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
302         require(b != 0, errorMessage);
303         return a % b;
304     }
305 }
306 
307 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/IERC20.sol
308 
309 // SPDX-License-Identifier: MIT
310 
311 pragma solidity ^0.6.0;
312 
313 /**
314  * @dev Interface of the ERC20 standard as defined in the EIP.
315  */
316 interface IERC20 {
317     /**
318      * @dev Returns the amount of tokens in existence.
319      */
320     function totalSupply() external view returns (uint256);
321 
322     /**
323      * @dev Returns the amount of tokens owned by `account`.
324      */
325     function balanceOf(address account) external view returns (uint256);
326 
327     /**
328      * @dev Moves `amount` tokens from the caller's account to `recipient`.
329      *
330      * Returns a boolean value indicating whether the operation succeeded.
331      *
332      * Emits a {Transfer} event.
333      */
334     function transfer(address recipient, uint256 amount) external returns (bool);
335 
336     /**
337      * @dev Returns the remaining number of tokens that `spender` will be
338      * allowed to spend on behalf of `owner` through {transferFrom}. This is
339      * zero by default.
340      *
341      * This value changes when {approve} or {transferFrom} are called.
342      */
343     function allowance(address owner, address spender) external view returns (uint256);
344 
345     /**
346      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
347      *
348      * Returns a boolean value indicating whether the operation succeeded.
349      *
350      * IMPORTANT: Beware that changing an allowance with this method brings the risk
351      * that someone may use both the old and the new allowance by unfortunate
352      * transaction ordering. One possible solution to mitigate this race
353      * condition is to first reduce the spender's allowance to 0 and set the
354      * desired value afterwards:
355      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
356      *
357      * Emits an {Approval} event.
358      */
359     function approve(address spender, uint256 amount) external returns (bool);
360 
361     /**
362      * @dev Moves `amount` tokens from `sender` to `recipient` using the
363      * allowance mechanism. `amount` is then deducted from the caller's
364      * allowance.
365      *
366      * Returns a boolean value indicating whether the operation succeeded.
367      *
368      * Emits a {Transfer} event.
369      */
370     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
371 
372     /**
373      * @dev Emitted when `value` tokens are moved from one account (`from`) to
374      * another (`to`).
375      *
376      * Note that `value` may be zero.
377      */
378     event Transfer(address indexed from, address indexed to, uint256 value);
379 
380     /**
381      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
382      * a call to {approve}. `value` is the new allowance.
383      */
384     event Approval(address indexed owner, address indexed spender, uint256 value);
385 }
386 
387 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/GSN/Context.sol
388 
389 // SPDX-License-Identifier: MIT
390 
391 pragma solidity ^0.6.0;
392 
393 /*
394  * @dev Provides information about the current execution context, including the
395  * sender of the transaction and its data. While these are generally available
396  * via msg.sender and msg.data, they should not be accessed in such a direct
397  * manner, since when dealing with GSN meta-transactions the account sending and
398  * paying for execution may not be the actual sender (as far as an application
399  * is concerned).
400  *
401  * This contract is only required for intermediate, library-like contracts.
402  */
403 abstract contract Context {
404     function _msgSender() internal view virtual returns (address payable) {
405         return msg.sender;
406     }
407 
408     function _msgData() internal view virtual returns (bytes memory) {
409         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
410         return msg.data;
411     }
412 }
413 
414 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/ERC20.sol
415 
416 // SPDX-License-Identifier: MIT
417 
418 pragma solidity ^0.6.0;
419 
420 
421 
422 
423 
424 /**
425  * @dev Implementation of the {IERC20} interface.
426  *
427  * This implementation is agnostic to the way tokens are created. This means
428  * that a supply mechanism has to be added in a derived contract using {_mint}.
429  * For a generic mechanism see {ERC20PresetMinterPauser}.
430  *
431  * TIP: For a detailed writeup see our guide
432  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
433  * to implement supply mechanisms].
434  *
435  * We have followed general OpenZeppelin guidelines: functions revert instead
436  * of returning `false` on failure. This behavior is nonetheless conventional
437  * and does not conflict with the expectations of ERC20 applications.
438  *
439  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
440  * This allows applications to reconstruct the allowance for all accounts just
441  * by listening to said events. Other implementations of the EIP may not emit
442  * these events, as it isn't required by the specification.
443  *
444  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
445  * functions have been added to mitigate the well-known issues around setting
446  * allowances. See {IERC20-approve}.
447  */
448 contract ERC20 is Context, IERC20 {
449     using SafeMath for uint256;
450     using Address for address;
451 
452     mapping (address => uint256) private _balances;
453 
454     mapping (address => mapping (address => uint256)) private _allowances;
455 
456     uint256 private _totalSupply;
457 
458     string private _name;
459     string private _symbol;
460     uint8 private _decimals;
461 
462     /**
463      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
464      * a default value of 18.
465      *
466      * To select a different value for {decimals}, use {_setupDecimals}.
467      *
468      * All three of these values are immutable: they can only be set once during
469      * construction.
470      */
471     constructor (string memory name, string memory symbol) public {
472         _name = name;
473         _symbol = symbol;
474         _decimals = 18;
475     }
476 
477     /**
478      * @dev Returns the name of the token.
479      */
480     function name() public view returns (string memory) {
481         return _name;
482     }
483 
484     /**
485      * @dev Returns the symbol of the token, usually a shorter version of the
486      * name.
487      */
488     function symbol() public view returns (string memory) {
489         return _symbol;
490     }
491 
492     /**
493      * @dev Returns the number of decimals used to get its user representation.
494      * For example, if `decimals` equals `2`, a balance of `505` tokens should
495      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
496      *
497      * Tokens usually opt for a value of 18, imitating the relationship between
498      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
499      * called.
500      *
501      * NOTE: This information is only used for _display_ purposes: it in
502      * no way affects any of the arithmetic of the contract, including
503      * {IERC20-balanceOf} and {IERC20-transfer}.
504      */
505     function decimals() public view returns (uint8) {
506         return _decimals;
507     }
508 
509     /**
510      * @dev See {IERC20-totalSupply}.
511      */
512     function totalSupply() public view override returns (uint256) {
513         return _totalSupply;
514     }
515 
516     /**
517      * @dev See {IERC20-balanceOf}.
518      */
519     function balanceOf(address account) public view override returns (uint256) {
520         return _balances[account];
521     }
522 
523     /**
524      * @dev See {IERC20-transfer}.
525      *
526      * Requirements:
527      *
528      * - `recipient` cannot be the zero address.
529      * - the caller must have a balance of at least `amount`.
530      */
531     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
532         _transfer(_msgSender(), recipient, amount);
533         return true;
534     }
535 
536     /**
537      * @dev See {IERC20-allowance}.
538      */
539     function allowance(address owner, address spender) public view virtual override returns (uint256) {
540         return _allowances[owner][spender];
541     }
542 
543     /**
544      * @dev See {IERC20-approve}.
545      *
546      * Requirements:
547      *
548      * - `spender` cannot be the zero address.
549      */
550     function approve(address spender, uint256 amount) public virtual override returns (bool) {
551         _approve(_msgSender(), spender, amount);
552         return true;
553     }
554 
555     /**
556      * @dev See {IERC20-transferFrom}.
557      *
558      * Emits an {Approval} event indicating the updated allowance. This is not
559      * required by the EIP. See the note at the beginning of {ERC20};
560      *
561      * Requirements:
562      * - `sender` and `recipient` cannot be the zero address.
563      * - `sender` must have a balance of at least `amount`.
564      * - the caller must have allowance for ``sender``'s tokens of at least
565      * `amount`.
566      */
567     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
568         _transfer(sender, recipient, amount);
569         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
570         return true;
571     }
572 
573     /**
574      * @dev Atomically increases the allowance granted to `spender` by the caller.
575      *
576      * This is an alternative to {approve} that can be used as a mitigation for
577      * problems described in {IERC20-approve}.
578      *
579      * Emits an {Approval} event indicating the updated allowance.
580      *
581      * Requirements:
582      *
583      * - `spender` cannot be the zero address.
584      */
585     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
586         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
587         return true;
588     }
589 
590     /**
591      * @dev Atomically decreases the allowance granted to `spender` by the caller.
592      *
593      * This is an alternative to {approve} that can be used as a mitigation for
594      * problems described in {IERC20-approve}.
595      *
596      * Emits an {Approval} event indicating the updated allowance.
597      *
598      * Requirements:
599      *
600      * - `spender` cannot be the zero address.
601      * - `spender` must have allowance for the caller of at least
602      * `subtractedValue`.
603      */
604     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
605         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
606         return true;
607     }
608 
609     /**
610      * @dev Moves tokens `amount` from `sender` to `recipient`.
611      *
612      * This is internal function is equivalent to {transfer}, and can be used to
613      * e.g. implement automatic token fees, slashing mechanisms, etc.
614      *
615      * Emits a {Transfer} event.
616      *
617      * Requirements:
618      *
619      * - `sender` cannot be the zero address.
620      * - `recipient` cannot be the zero address.
621      * - `sender` must have a balance of at least `amount`.
622      */
623     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
624         require(sender != address(0), "ERC20: transfer from the zero address");
625         require(recipient != address(0), "ERC20: transfer to the zero address");
626 
627         _beforeTokenTransfer(sender, recipient, amount);
628 
629         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
630         _balances[recipient] = _balances[recipient].add(amount);
631         emit Transfer(sender, recipient, amount);
632     }
633 
634     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
635      * the total supply.
636      *
637      * Emits a {Transfer} event with `from` set to the zero address.
638      *
639      * Requirements
640      *
641      * - `to` cannot be the zero address.
642      */
643     function _mint(address account, uint256 amount) internal virtual {
644         require(account != address(0), "ERC20: mint to the zero address");
645 
646         _beforeTokenTransfer(address(0), account, amount);
647 
648         _totalSupply = _totalSupply.add(amount);
649         _balances[account] = _balances[account].add(amount);
650         emit Transfer(address(0), account, amount);
651     }
652 
653     /**
654      * @dev Destroys `amount` tokens from `account`, reducing the
655      * total supply.
656      *
657      * Emits a {Transfer} event with `to` set to the zero address.
658      *
659      * Requirements
660      *
661      * - `account` cannot be the zero address.
662      * - `account` must have at least `amount` tokens.
663      */
664     function _burn(address account, uint256 amount) internal virtual {
665         require(account != address(0), "ERC20: burn from the zero address");
666 
667         _beforeTokenTransfer(account, address(0), amount);
668 
669         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
670         _totalSupply = _totalSupply.sub(amount);
671         emit Transfer(account, address(0), amount);
672     }
673 
674     /**
675      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
676      *
677      * This is internal function is equivalent to `approve`, and can be used to
678      * e.g. set automatic allowances for certain subsystems, etc.
679      *
680      * Emits an {Approval} event.
681      *
682      * Requirements:
683      *
684      * - `owner` cannot be the zero address.
685      * - `spender` cannot be the zero address.
686      */
687     function _approve(address owner, address spender, uint256 amount) internal virtual {
688         require(owner != address(0), "ERC20: approve from the zero address");
689         require(spender != address(0), "ERC20: approve to the zero address");
690 
691         _allowances[owner][spender] = amount;
692         emit Approval(owner, spender, amount);
693     }
694 
695     /**
696      * @dev Sets {decimals} to a value other than the default one of 18.
697      *
698      * WARNING: This function should only be called from the constructor. Most
699      * applications that interact with token contracts will not expect
700      * {decimals} to ever change, and may work incorrectly if it does.
701      */
702     function _setupDecimals(uint8 decimals_) internal {
703         _decimals = decimals_;
704     }
705 
706     /**
707      * @dev Hook that is called before any transfer of tokens. This includes
708      * minting and burning.
709      *
710      * Calling conditions:
711      *
712      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
713      * will be to transferred to `to`.
714      * - when `from` is zero, `amount` tokens will be minted for `to`.
715      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
716      * - `from` and `to` are never both zero.
717      *
718      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
719      */
720     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
721 }
722 
723 // File: browser/dac.sol
724 
725 pragma solidity 0.6.2;
726 
727 
728 contract ERC20FixedSupply is ERC20 {
729     constructor() public ERC20("DAC", "DAC") {
730         _mint(msg.sender, 10e9 * 1e18);
731     }
732 }