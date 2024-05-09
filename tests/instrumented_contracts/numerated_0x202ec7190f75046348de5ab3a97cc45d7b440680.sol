1 /**
2  *Submitted for verification at Etherscan.io on 2020-10-10
3 */
4 
5 // SPDX-License-Identifier: MIT
6 
7 // File: @openzeppelin/contracts/math/Math.sol
8 
9 
10 pragma solidity ^0.6.0;
11 
12 /**
13  * @dev Standard math utilities missing in the Solidity language.
14  */
15 library Math {
16     /**
17      * @dev Returns the largest of two numbers.
18      */
19     function max(uint256 a, uint256 b) internal pure returns (uint256) {
20         return a >= b ? a : b;
21     }
22 
23     /**
24      * @dev Returns the smallest of two numbers.
25      */
26     function min(uint256 a, uint256 b) internal pure returns (uint256) {
27         return a < b ? a : b;
28     }
29 
30     /**
31      * @dev Returns the average of two numbers. The result is rounded towards
32      * zero.
33      */
34     function average(uint256 a, uint256 b) internal pure returns (uint256) {
35         // (a + b) / 2 can overflow, so we distribute
36         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
37     }
38 }
39 
40 // File: @openzeppelin/contracts/math/SafeMath.sol
41 
42 
43 pragma solidity ^0.6.0;
44 
45 /**
46  * @dev Wrappers over Solidity's arithmetic operations with added overflow
47  * checks.
48  *
49  * Arithmetic operations in Solidity wrap on overflow. This can easily result
50  * in bugs, because programmers usually assume that an overflow raises an
51  * error, which is the standard behavior in high level programming languages.
52  * `SafeMath` restores this intuition by reverting the transaction when an
53  * operation overflows.
54  *
55  * Using this library instead of the unchecked operations eliminates an entire
56  * class of bugs, so it's recommended to use it always.
57  */
58 library SafeMath {
59     /**
60      * @dev Returns the addition of two unsigned integers, reverting on
61      * overflow.
62      *
63      * Counterpart to Solidity's `+` operator.
64      *
65      * Requirements:
66      *
67      * - Addition cannot overflow.
68      */
69     function add(uint256 a, uint256 b) internal pure returns (uint256) {
70         uint256 c = a + b;
71         require(c >= a, "SafeMath: addition overflow");
72 
73         return c;
74     }
75 
76     /**
77      * @dev Returns the subtraction of two unsigned integers, reverting on
78      * overflow (when the result is negative).
79      *
80      * Counterpart to Solidity's `-` operator.
81      *
82      * Requirements:
83      *
84      * - Subtraction cannot overflow.
85      */
86     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
87         return sub(a, b, "SafeMath: subtraction overflow");
88     }
89 
90     /**
91      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
92      * overflow (when the result is negative).
93      *
94      * Counterpart to Solidity's `-` operator.
95      *
96      * Requirements:
97      *
98      * - Subtraction cannot overflow.
99      */
100     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
101         require(b <= a, errorMessage);
102         uint256 c = a - b;
103 
104         return c;
105     }
106 
107     /**
108      * @dev Returns the multiplication of two unsigned integers, reverting on
109      * overflow.
110      *
111      * Counterpart to Solidity's `*` operator.
112      *
113      * Requirements:
114      *
115      * - Multiplication cannot overflow.
116      */
117     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
118         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
119         // benefit is lost if 'b' is also tested.
120         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
121         if (a == 0) {
122             return 0;
123         }
124 
125         uint256 c = a * b;
126         require(c / a == b, "SafeMath: multiplication overflow");
127 
128         return c;
129     }
130 
131     /**
132      * @dev Returns the integer division of two unsigned integers. Reverts on
133      * division by zero. The result is rounded towards zero.
134      *
135      * Counterpart to Solidity's `/` operator. Note: this function uses a
136      * `revert` opcode (which leaves remaining gas untouched) while Solidity
137      * uses an invalid opcode to revert (consuming all remaining gas).
138      *
139      * Requirements:
140      *
141      * - The divisor cannot be zero.
142      */
143     function div(uint256 a, uint256 b) internal pure returns (uint256) {
144         return div(a, b, "SafeMath: division by zero");
145     }
146 
147     /**
148      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
149      * division by zero. The result is rounded towards zero.
150      *
151      * Counterpart to Solidity's `/` operator. Note: this function uses a
152      * `revert` opcode (which leaves remaining gas untouched) while Solidity
153      * uses an invalid opcode to revert (consuming all remaining gas).
154      *
155      * Requirements:
156      *
157      * - The divisor cannot be zero.
158      */
159     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
160         require(b > 0, errorMessage);
161         uint256 c = a / b;
162         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
163 
164         return c;
165     }
166 
167     /**
168      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
169      * Reverts when dividing by zero.
170      *
171      * Counterpart to Solidity's `%` operator. This function uses a `revert`
172      * opcode (which leaves remaining gas untouched) while Solidity uses an
173      * invalid opcode to revert (consuming all remaining gas).
174      *
175      * Requirements:
176      *
177      * - The divisor cannot be zero.
178      */
179     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
180         return mod(a, b, "SafeMath: modulo by zero");
181     }
182 
183     /**
184      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
185      * Reverts with custom message when dividing by zero.
186      *
187      * Counterpart to Solidity's `%` operator. This function uses a `revert`
188      * opcode (which leaves remaining gas untouched) while Solidity uses an
189      * invalid opcode to revert (consuming all remaining gas).
190      *
191      * Requirements:
192      *
193      * - The divisor cannot be zero.
194      */
195     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
196         require(b != 0, errorMessage);
197         return a % b;
198     }
199 }
200 
201 // File: @openzeppelin/contracts/GSN/Context.sol
202 
203 
204 pragma solidity ^0.6.0;
205 
206 /*
207  * @dev Provides information about the current execution context, including the
208  * sender of the transaction and its data. While these are generally available
209  * via msg.sender and msg.data, they should not be accessed in such a direct
210  * manner, since when dealing with GSN meta-transactions the account sending and
211  * paying for execution may not be the actual sender (as far as an application
212  * is concerned).
213  *
214  * This contract is only required for intermediate, library-like contracts.
215  */
216 abstract contract Context {
217     function _msgSender() internal view virtual returns (address payable) {
218         return msg.sender;
219     }
220 
221     function _msgData() internal view virtual returns (bytes memory) {
222         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
223         return msg.data;
224     }
225 }
226 
227 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
228 
229 
230 pragma solidity ^0.6.0;
231 
232 /**
233  * @dev Interface of the ERC20 standard as defined in the EIP.
234  */
235 interface IERC20 {
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
306 // File: @openzeppelin/contracts/utils/Address.sol
307 
308 
309 pragma solidity ^0.6.2;
310 
311 /**
312  * @dev Collection of functions related to the address type
313  */
314 library Address {
315     /**
316      * @dev Returns true if `account` is a contract.
317      *
318      * [IMPORTANT]
319      * ====
320      * It is unsafe to assume that an address for which this function returns
321      * false is an externally-owned account (EOA) and not a contract.
322      *
323      * Among others, `isContract` will return false for the following
324      * types of addresses:
325      *
326      *  - an externally-owned account
327      *  - a contract in construction
328      *  - an address where a contract will be created
329      *  - an address where a contract lived, but was destroyed
330      * ====
331      */
332     function isContract(address account) internal view returns (bool) {
333         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
334         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
335         // for accounts without code, i.e. `keccak256('')`
336         bytes32 codehash;
337         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
338         // solhint-disable-next-line no-inline-assembly
339         assembly { codehash := extcodehash(account) }
340         return (codehash != accountHash && codehash != 0x0);
341     }
342 
343     /**
344      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
345      * `recipient`, forwarding all available gas and reverting on errors.
346      *
347      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
348      * of certain opcodes, possibly making contracts go over the 2300 gas limit
349      * imposed by `transfer`, making them unable to receive funds via
350      * `transfer`. {sendValue} removes this limitation.
351      *
352      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
353      *
354      * IMPORTANT: because control is transferred to `recipient`, care must be
355      * taken to not create reentrancy vulnerabilities. Consider using
356      * {ReentrancyGuard} or the
357      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
358      */
359     function sendValue(address payable recipient, uint256 amount) internal {
360         require(address(this).balance >= amount, "Address: insufficient balance");
361 
362         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
363         (bool success, ) = recipient.call{ value: amount }("");
364         require(success, "Address: unable to send value, recipient may have reverted");
365     }
366 
367     /**
368      * @dev Performs a Solidity function call using a low level `call`. A
369      * plain`call` is an unsafe replacement for a function call: use this
370      * function instead.
371      *
372      * If `target` reverts with a revert reason, it is bubbled up by this
373      * function (like regular Solidity function calls).
374      *
375      * Returns the raw returned data. To convert to the expected return value,
376      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
377      *
378      * Requirements:
379      *
380      * - `target` must be a contract.
381      * - calling `target` with `data` must not revert.
382      *
383      * _Available since v3.1._
384      */
385     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
386       return functionCall(target, data, "Address: low-level call failed");
387     }
388 
389     /**
390      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
391      * `errorMessage` as a fallback revert reason when `target` reverts.
392      *
393      * _Available since v3.1._
394      */
395     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
396         return _functionCallWithValue(target, data, 0, errorMessage);
397     }
398 
399     /**
400      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
401      * but also transferring `value` wei to `target`.
402      *
403      * Requirements:
404      *
405      * - the calling contract must have an ETH balance of at least `value`.
406      * - the called Solidity function must be `payable`.
407      *
408      * _Available since v3.1._
409      */
410     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
411         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
412     }
413 
414     /**
415      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
416      * with `errorMessage` as a fallback revert reason when `target` reverts.
417      *
418      * _Available since v3.1._
419      */
420     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
421         require(address(this).balance >= value, "Address: insufficient balance for call");
422         return _functionCallWithValue(target, data, value, errorMessage);
423     }
424 
425     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
426         require(isContract(target), "Address: call to non-contract");
427 
428         // solhint-disable-next-line avoid-low-level-calls
429         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
430         if (success) {
431             return returndata;
432         } else {
433             // Look for revert reason and bubble it up if present
434             if (returndata.length > 0) {
435                 // The easiest way to bubble the revert reason is using memory via assembly
436 
437                 // solhint-disable-next-line no-inline-assembly
438                 assembly {
439                     let returndata_size := mload(returndata)
440                     revert(add(32, returndata), returndata_size)
441                 }
442             } else {
443                 revert(errorMessage);
444             }
445         }
446     }
447 }
448 
449 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
450 
451 
452 pragma solidity ^0.6.0;
453 
454 
455 
456 
457 
458 /**
459  * @dev Implementation of the {IERC20} interface.
460  *
461  * This implementation is agnostic to the way tokens are created. This means
462  * that a supply mechanism has to be added in a derived contract using {_mint}.
463  * For a generic mechanism see {ERC20PresetMinterPauser}.
464  *
465  * TIP: For a detailed writeup see our guide
466  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
467  * to implement supply mechanisms].
468  *
469  * We have followed general OpenZeppelin guidelines: functions revert instead
470  * of returning `false` on failure. This behavior is nonetheless conventional
471  * and does not conflict with the expectations of ERC20 applications.
472  *
473  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
474  * This allows applications to reconstruct the allowance for all accounts just
475  * by listening to said events. Other implementations of the EIP may not emit
476  * these events, as it isn't required by the specification.
477  *
478  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
479  * functions have been added to mitigate the well-known issues around setting
480  * allowances. See {IERC20-approve}.
481  */
482 contract ERC20 is Context, IERC20 {
483     using SafeMath for uint256;
484     using Address for address;
485 
486     mapping (address => uint256) private _balances;
487 
488     mapping (address => mapping (address => uint256)) private _allowances;
489 
490     uint256 private _totalSupply;
491 
492     string private _name;
493     string private _symbol;
494     uint8 private _decimals;
495 
496     /**
497      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
498      * a default value of 18.
499      *
500      * To select a different value for {decimals}, use {_setupDecimals}.
501      *
502      * All three of these values are immutable: they can only be set once during
503      * construction.
504      */
505     constructor (string memory name, string memory symbol) public {
506         _name = name;
507         _symbol = symbol;
508         _decimals = 18;
509     }
510 
511     /**
512      * @dev Returns the name of the token.
513      */
514     function name() public view returns (string memory) {
515         return _name;
516     }
517 
518     /**
519      * @dev Returns the symbol of the token, usually a shorter version of the
520      * name.
521      */
522     function symbol() public view returns (string memory) {
523         return _symbol;
524     }
525 
526     /**
527      * @dev Returns the number of decimals used to get its user representation.
528      * For example, if `decimals` equals `2`, a balance of `505` tokens should
529      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
530      *
531      * Tokens usually opt for a value of 18, imitating the relationship between
532      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
533      * called.
534      *
535      * NOTE: This information is only used for _display_ purposes: it in
536      * no way affects any of the arithmetic of the contract, including
537      * {IERC20-balanceOf} and {IERC20-transfer}.
538      */
539     function decimals() public view returns (uint8) {
540         return _decimals;
541     }
542 
543     /**
544      * @dev See {IERC20-totalSupply}.
545      */
546     function totalSupply() public view override returns (uint256) {
547         return _totalSupply;
548     }
549 
550     /**
551      * @dev See {IERC20-balanceOf}.
552      */
553     function balanceOf(address account) public view override returns (uint256) {
554         return _balances[account];
555     }
556 
557     /**
558      * @dev See {IERC20-transfer}.
559      *
560      * Requirements:
561      *
562      * - `recipient` cannot be the zero address.
563      * - the caller must have a balance of at least `amount`.
564      */
565     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
566         _transfer(_msgSender(), recipient, amount);
567         return true;
568     }
569 
570     /**
571      * @dev See {IERC20-allowance}.
572      */
573     function allowance(address owner, address spender) public view virtual override returns (uint256) {
574         return _allowances[owner][spender];
575     }
576 
577     /**
578      * @dev See {IERC20-approve}.
579      *
580      * Requirements:
581      *
582      * - `spender` cannot be the zero address.
583      */
584     function approve(address spender, uint256 amount) public virtual override returns (bool) {
585         _approve(_msgSender(), spender, amount);
586         return true;
587     }
588 
589     /**
590      * @dev See {IERC20-transferFrom}.
591      *
592      * Emits an {Approval} event indicating the updated allowance. This is not
593      * required by the EIP. See the note at the beginning of {ERC20};
594      *
595      * Requirements:
596      * - `sender` and `recipient` cannot be the zero address.
597      * - `sender` must have a balance of at least `amount`.
598      * - the caller must have allowance for ``sender``'s tokens of at least
599      * `amount`.
600      */
601     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
602         _transfer(sender, recipient, amount);
603         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
604         return true;
605     }
606 
607     /**
608      * @dev Atomically increases the allowance granted to `spender` by the caller.
609      *
610      * This is an alternative to {approve} that can be used as a mitigation for
611      * problems described in {IERC20-approve}.
612      *
613      * Emits an {Approval} event indicating the updated allowance.
614      *
615      * Requirements:
616      *
617      * - `spender` cannot be the zero address.
618      */
619     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
620         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
621         return true;
622     }
623 
624     /**
625      * @dev Atomically decreases the allowance granted to `spender` by the caller.
626      *
627      * This is an alternative to {approve} that can be used as a mitigation for
628      * problems described in {IERC20-approve}.
629      *
630      * Emits an {Approval} event indicating the updated allowance.
631      *
632      * Requirements:
633      *
634      * - `spender` cannot be the zero address.
635      * - `spender` must have allowance for the caller of at least
636      * `subtractedValue`.
637      */
638     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
639         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
640         return true;
641     }
642 
643     /**
644      * @dev Moves tokens `amount` from `sender` to `recipient`.
645      *
646      * This is internal function is equivalent to {transfer}, and can be used to
647      * e.g. implement automatic token fees, slashing mechanisms, etc.
648      *
649      * Emits a {Transfer} event.
650      *
651      * Requirements:
652      *
653      * - `sender` cannot be the zero address.
654      * - `recipient` cannot be the zero address.
655      * - `sender` must have a balance of at least `amount`.
656      */
657     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
658         require(sender != address(0), "ERC20: transfer from the zero address");
659         require(recipient != address(0), "ERC20: transfer to the zero address");
660 
661         _beforeTokenTransfer(sender, recipient, amount);
662 
663         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
664         _balances[recipient] = _balances[recipient].add(amount);
665         emit Transfer(sender, recipient, amount);
666     }
667 
668     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
669      * the total supply.
670      *
671      * Emits a {Transfer} event with `from` set to the zero address.
672      *
673      * Requirements
674      *
675      * - `to` cannot be the zero address.
676      */
677     function _mint(address account, uint256 amount) internal virtual {
678         require(account != address(0), "ERC20: mint to the zero address");
679 
680         _beforeTokenTransfer(address(0), account, amount);
681 
682         _totalSupply = _totalSupply.add(amount);
683         _balances[account] = _balances[account].add(amount);
684         emit Transfer(address(0), account, amount);
685     }
686 
687     /**
688      * @dev Destroys `amount` tokens from `account`, reducing the
689      * total supply.
690      *
691      * Emits a {Transfer} event with `to` set to the zero address.
692      *
693      * Requirements
694      *
695      * - `account` cannot be the zero address.
696      * - `account` must have at least `amount` tokens.
697      */
698     function _burn(address account, uint256 amount) internal virtual {
699         require(account != address(0), "ERC20: burn from the zero address");
700 
701         _beforeTokenTransfer(account, address(0), amount);
702 
703         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
704         _totalSupply = _totalSupply.sub(amount);
705         emit Transfer(account, address(0), amount);
706     }
707 
708     /**
709      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
710      *
711      * This is internal function is equivalent to `approve`, and can be used to
712      * e.g. set automatic allowances for certain subsystems, etc.
713      *
714      * Emits an {Approval} event.
715      *
716      * Requirements:
717      *
718      * - `owner` cannot be the zero address.
719      * - `spender` cannot be the zero address.
720      */
721     function _approve(address owner, address spender, uint256 amount) internal virtual {
722         require(owner != address(0), "ERC20: approve from the zero address");
723         require(spender != address(0), "ERC20: approve to the zero address");
724 
725         _allowances[owner][spender] = amount;
726         emit Approval(owner, spender, amount);
727     }
728 
729     /**
730      * @dev Sets {decimals} to a value other than the default one of 18.
731      *
732      * WARNING: This function should only be called from the constructor. Most
733      * applications that interact with token contracts will not expect
734      * {decimals} to ever change, and may work incorrectly if it does.
735      */
736     function _setupDecimals(uint8 decimals_) internal {
737         _decimals = decimals_;
738     }
739 
740     /**
741      * @dev Hook that is called before any transfer of tokens. This includes
742      * minting and burning.
743      *
744      * Calling conditions:
745      *
746      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
747      * will be to transferred to `to`.
748      * - when `from` is zero, `amount` tokens will be minted for `to`.
749      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
750      * - `from` and `to` are never both zero.
751      *
752      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
753      */
754     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
755 }
756 
757 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
758 
759 
760 pragma solidity ^0.6.0;
761 
762 
763 
764 
765 /**
766  * @title SafeERC20
767  * @dev Wrappers around ERC20 operations that throw on failure (when the token
768  * contract returns false). Tokens that return no value (and instead revert or
769  * throw on failure) are also supported, non-reverting calls are assumed to be
770  * successful.
771  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
772  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
773  */
774 library SafeERC20 {
775     using SafeMath for uint256;
776     using Address for address;
777 
778     function safeTransfer(IERC20 token, address to, uint256 value) internal {
779         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
780     }
781 
782     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
783         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
784     }
785 
786     /**
787      * @dev Deprecated. This function has issues similar to the ones found in
788      * {IERC20-approve}, and its usage is discouraged.
789      *
790      * Whenever possible, use {safeIncreaseAllowance} and
791      * {safeDecreaseAllowance} instead.
792      */
793     function safeApprove(IERC20 token, address spender, uint256 value) internal {
794         // safeApprove should only be called when setting an initial allowance,
795         // or when resetting it to zero. To increase and decrease it, use
796         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
797         // solhint-disable-next-line max-line-length
798         require((value == 0) || (token.allowance(address(this), spender) == 0),
799             "SafeERC20: approve from non-zero to non-zero allowance"
800         );
801         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
802     }
803 
804     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
805         uint256 newAllowance = token.allowance(address(this), spender).add(value);
806         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
807     }
808 
809     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
810         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
811         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
812     }
813 
814     /**
815      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
816      * on the return value: the return value is optional (but if data is returned, it must not be false).
817      * @param token The token targeted by the call.
818      * @param data The call data (encoded using abi.encode or one of its variants).
819      */
820     function _callOptionalReturn(IERC20 token, bytes memory data) private {
821         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
822         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
823         // the target address contains contract code and also asserts for success in the low-level call.
824 
825         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
826         if (returndata.length > 0) { // Return data is optional
827             // solhint-disable-next-line max-line-length
828             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
829         }
830     }
831 }
832 
833 // File: @openzeppelin/contracts/utils/ReentrancyGuard.sol
834 
835 
836 pragma solidity ^0.6.0;
837 
838 /**
839  * @dev Contract module that helps prevent reentrant calls to a function.
840  *
841  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
842  * available, which can be applied to functions to make sure there are no nested
843  * (reentrant) calls to them.
844  *
845  * Note that because there is a single `nonReentrant` guard, functions marked as
846  * `nonReentrant` may not call one another. This can be worked around by making
847  * those functions `private`, and then adding `external` `nonReentrant` entry
848  * points to them.
849  *
850  * TIP: If you would like to learn more about reentrancy and alternative ways
851  * to protect against it, check out our blog post
852  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
853  */
854 contract ReentrancyGuard {
855     // Booleans are more expensive than uint256 or any type that takes up a full
856     // word because each write operation emits an extra SLOAD to first read the
857     // slot's contents, replace the bits taken up by the boolean, and then write
858     // back. This is the compiler's defense against contract upgrades and
859     // pointer aliasing, and it cannot be disabled.
860 
861     // The values being non-zero value makes deployment a bit more expensive,
862     // but in exchange the refund on every call to nonReentrant will be lower in
863     // amount. Since refunds are capped to a percentage of the total
864     // transaction's gas, it is best to keep them low in cases like this one, to
865     // increase the likelihood of the full refund coming into effect.
866     uint256 private constant _NOT_ENTERED = 1;
867     uint256 private constant _ENTERED = 2;
868 
869     uint256 private _status;
870 
871     constructor () internal {
872         _status = _NOT_ENTERED;
873     }
874 
875     /**
876      * @dev Prevents a contract from calling itself, directly or indirectly.
877      * Calling a `nonReentrant` function from another `nonReentrant`
878      * function is not supported. It is possible to prevent this from happening
879      * by making the `nonReentrant` function external, and make it call a
880      * `private` function that does the actual work.
881      */
882     modifier nonReentrant() {
883         // On the first call to nonReentrant, _notEntered will be true
884         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
885 
886         // Any calls to nonReentrant after this point will fail
887         _status = _ENTERED;
888 
889         _;
890 
891         // By storing the original value once again, a refund is triggered (see
892         // https://eips.ethereum.org/EIPS/eip-2200)
893         _status = _NOT_ENTERED;
894     }
895 }
896 
897 // File: contracts/Rewards/Synthetix/StakingRewards.sol
898 
899 pragma solidity ^0.6.12;
900 
901 
902 
903 
904 
905 
906 // Inheritance
907 // import "./interfaces/IStakingRewards.sol";
908 // import "./RewardsDistributionRecipient.sol";
909 // import "./Pausable.sol";
910 // import "./Owned.sol";
911 
912 
913 
914 // https://docs.synthetix.io/contracts/Owned
915 contract Owned {
916     address public owner;
917     address public nominatedOwner;
918 
919     constructor(address _owner) public {
920         require(_owner != address(0), "Owner address cannot be 0");
921         owner = _owner;
922         emit OwnerChanged(address(0), _owner);
923     }
924 
925     function nominateNewOwner(address _owner) external onlyOwner {
926         nominatedOwner = _owner;
927         emit OwnerNominated(_owner);
928     }
929 
930     function acceptOwnership() external {
931         require(msg.sender == nominatedOwner, "You must be nominated before you can accept ownership");
932         emit OwnerChanged(owner, nominatedOwner);
933         owner = nominatedOwner;
934         nominatedOwner = address(0);
935     }
936 
937     modifier onlyOwner {
938         _onlyOwner();
939         _;
940     }
941 
942     function _onlyOwner() private view {
943         require(msg.sender == owner, "Only the contract owner may perform this action");
944     }
945 
946     event OwnerNominated(address newOwner);
947     event OwnerChanged(address oldOwner, address newOwner);
948 }
949 
950 
951 
952 // https://docs.synthetix.io/contracts/Pausable
953 abstract
954 contract Pausable is Owned {
955     uint public lastPauseTime;
956     bool public paused;
957 
958     constructor() internal {
959         // This contract is abstract, and thus cannot be instantiated directly
960         require(owner != address(0), "Owner must be set");
961         // Paused will be false, and lastPauseTime will be 0 upon initialisation
962     }
963 
964     /**
965      * @notice Change the paused state of the contract
966      * @dev Only the contract owner may call this.
967      */
968     function setPaused(bool _paused) external onlyOwner {
969         // Ensure we're actually changing the state before we do anything
970         if (_paused == paused) {
971             return;
972         }
973 
974         // Set our paused state.
975         paused = _paused;
976 
977         // If applicable, set the last pause time.
978         if (paused) {
979             lastPauseTime = now;
980         }
981 
982         // Let everyone know that our pause state has changed.
983         emit PauseChanged(paused);
984     }
985 
986     event PauseChanged(bool isPaused);
987 
988     modifier notPaused {
989         require(!paused, "This action cannot be performed while the contract is paused");
990         _;
991     }
992 }
993 
994 
995 // https://docs.synthetix.io/contracts/RewardsDistributionRecipient
996 abstract
997 contract RewardsDistributionRecipient is Owned {
998     address public rewardsDistribution;
999 
1000     function notifyRewardAmount(uint256 reward) external virtual;
1001 
1002     modifier onlyRewardsDistribution() {
1003         require(msg.sender == rewardsDistribution, "Caller is not RewardsDistribution contract");
1004         _;
1005     }
1006 
1007     function setRewardsDistribution(address _rewardsDistribution) external onlyOwner {
1008         rewardsDistribution = _rewardsDistribution;
1009     }
1010 }
1011 
1012 
1013 interface IStakingRewards {
1014     // Views
1015     function lastTimeRewardApplicable() external view returns (uint256);
1016 
1017     function rewardPerToken() external view returns (uint256);
1018 
1019     function earned(address account) external view returns (uint256);
1020 
1021     function getRewardForDuration() external view returns (uint256);
1022 
1023     function totalSupply() external view returns (uint256);
1024 
1025     function balanceOf(address account) external view returns (uint256);
1026 
1027     // Mutative
1028 
1029     function stake(uint256 amount) external;
1030 
1031     function withdraw(uint256 amount) external;
1032 
1033     function getReward() external;
1034 
1035     function exit() external;
1036 }
1037 
1038 
1039 contract StakingRewards is IStakingRewards, RewardsDistributionRecipient, ReentrancyGuard, Pausable {
1040     using SafeMath for uint256;
1041     using SafeERC20 for IERC20;
1042 
1043     /* ========== STATE VARIABLES ========== */
1044 
1045     IERC20 public rewardsToken;
1046     IERC20 public stakingToken;
1047     uint256 public periodFinish = 0;
1048     uint256 public rewardRate = 0;
1049     uint256 public rewardsDuration = 7 days;
1050     uint256 public lastUpdateTime;
1051     uint256 public rewardPerTokenStored;
1052 
1053     mapping(address => uint256) public userRewardPerTokenPaid;
1054     mapping(address => uint256) public rewards;
1055 
1056     uint256 private _totalSupply;
1057     mapping(address => uint256) private _balances;
1058 
1059     /* ========== CONSTRUCTOR ========== */
1060 
1061     constructor(
1062         address _owner,
1063         address _rewardsDistribution,
1064         address _rewardsToken,
1065         address _stakingToken
1066     ) public Owned(_owner) {
1067         rewardsToken = IERC20(_rewardsToken);
1068         stakingToken = IERC20(_stakingToken);
1069         rewardsDistribution = _rewardsDistribution;
1070     }
1071 
1072     /* ========== VIEWS ========== */
1073 
1074     function totalSupply() external view override returns (uint256) {
1075         return _totalSupply;
1076     }
1077 
1078     function balanceOf(address account) external view override returns (uint256) {
1079         return _balances[account];
1080     }
1081 
1082     function lastTimeRewardApplicable() public view override returns (uint256) {
1083         return Math.min(block.timestamp, periodFinish);
1084     }
1085 
1086     function rewardPerToken() public view override returns (uint256) {
1087         if (_totalSupply == 0) {
1088             return rewardPerTokenStored;
1089         }
1090         return
1091             rewardPerTokenStored.add(
1092                 lastTimeRewardApplicable().sub(lastUpdateTime).mul(rewardRate).mul(1e18).div(_totalSupply)
1093             );
1094     }
1095 
1096     function earned(address account) public view override returns (uint256) {
1097         return _balances[account].mul(rewardPerToken().sub(userRewardPerTokenPaid[account])).div(1e18).add(rewards[account]);
1098     }
1099 
1100     function getRewardForDuration() external view override returns (uint256) {
1101         return rewardRate.mul(rewardsDuration);
1102     }
1103 
1104     /* ========== MUTATIVE FUNCTIONS ========== */
1105 
1106     function stake(uint256 amount) external override nonReentrant notPaused updateReward(msg.sender) {
1107         require(amount > 0, "Cannot stake 0");
1108         _totalSupply = _totalSupply.add(amount);
1109         _balances[msg.sender] = _balances[msg.sender].add(amount);
1110         stakingToken.safeTransferFrom(msg.sender, address(this), amount);
1111         emit Staked(msg.sender, amount);
1112     }
1113 
1114     function withdraw(uint256 amount) public override nonReentrant updateReward(msg.sender) {
1115         require(amount > 0, "Cannot withdraw 0");
1116         _totalSupply = _totalSupply.sub(amount);
1117         _balances[msg.sender] = _balances[msg.sender].sub(amount);
1118         stakingToken.safeTransfer(msg.sender, amount);
1119         emit Withdrawn(msg.sender, amount);
1120     }
1121 
1122     function getReward() public override nonReentrant updateReward(msg.sender) {
1123         uint256 reward = rewards[msg.sender];
1124         if (reward > 0) {
1125             rewards[msg.sender] = 0;
1126             rewardsToken.safeTransfer(msg.sender, reward);
1127             emit RewardPaid(msg.sender, reward);
1128         }
1129     }
1130 
1131     function exit() external override {
1132         withdraw(_balances[msg.sender]);
1133         getReward();
1134     }
1135 
1136     /* ========== RESTRICTED FUNCTIONS ========== */
1137 
1138     function notifyRewardAmount(uint256 reward) external override onlyRewardsDistribution updateReward(address(0)) {
1139         if (block.timestamp >= periodFinish) {
1140             rewardRate = reward.div(rewardsDuration);
1141         } else {
1142             uint256 remaining = periodFinish.sub(block.timestamp);
1143             uint256 leftover = remaining.mul(rewardRate);
1144             rewardRate = reward.add(leftover).div(rewardsDuration);
1145         }
1146 
1147         // Ensure the provided reward amount is not more than the balance in the contract.
1148         // This keeps the reward rate in the right range, preventing overflows due to
1149         // very high values of rewardRate in the earned and rewardsPerToken functions;
1150         // Reward + leftover must be less than 2^256 / 10^18 to avoid overflow.
1151         uint balance = rewardsToken.balanceOf(address(this));
1152         require(rewardRate <= balance.div(rewardsDuration), "Provided reward too high");
1153 
1154         lastUpdateTime = block.timestamp;
1155         periodFinish = block.timestamp.add(rewardsDuration);
1156         emit RewardAdded(reward);
1157     }
1158 
1159     // Added to support recovering LP Rewards from other systems to be distributed to holders
1160     function recoverERC20(address tokenAddress, uint256 tokenAmount) external onlyOwner {
1161         // If it's SNX we have to query the token symbol to ensure its not a proxy or underlying
1162         bool isSNX = (keccak256(bytes("SNX")) == keccak256(bytes(ERC20(tokenAddress).symbol())));
1163         // Cannot recover the staking token or the rewards token
1164         require(
1165             tokenAddress != address(stakingToken) && tokenAddress != address(rewardsToken) && !isSNX,
1166             "Cannot withdraw the staking or rewards tokens"
1167         );
1168         IERC20(tokenAddress).safeTransfer(owner, tokenAmount);
1169         emit Recovered(tokenAddress, tokenAmount);
1170     }
1171 
1172     function setRewardsDuration(uint256 _rewardsDuration) external onlyOwner {
1173         require(
1174             periodFinish == 0 || block.timestamp > periodFinish,
1175             "Previous rewards period must be complete before changing the duration for the new period"
1176         );
1177         rewardsDuration = _rewardsDuration;
1178         emit RewardsDurationUpdated(rewardsDuration);
1179     }
1180 
1181     /* ========== MODIFIERS ========== */
1182 
1183     modifier updateReward(address account) {
1184         rewardPerTokenStored = rewardPerToken();
1185         lastUpdateTime = lastTimeRewardApplicable();
1186         if (account != address(0)) {
1187             rewards[account] = earned(account);
1188             userRewardPerTokenPaid[account] = rewardPerTokenStored;
1189         }
1190         _;
1191     }
1192 
1193     /* ========== EVENTS ========== */
1194 
1195     event RewardAdded(uint256 reward);
1196     event Staked(address indexed user, uint256 amount);
1197     event Withdrawn(address indexed user, uint256 amount);
1198     event RewardPaid(address indexed user, uint256 reward);
1199     event RewardsDurationUpdated(uint256 newDuration);
1200     event Recovered(address token, uint256 amount);
1201 }