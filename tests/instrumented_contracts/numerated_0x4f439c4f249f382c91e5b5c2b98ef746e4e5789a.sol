1 // SPDX-License-Identifier: MIT
2 
3 // File: @openzeppelin/contracts/math/Math.sol
4 
5 
6 pragma solidity ^0.6.0;
7 
8 /**
9  * @dev Standard math utilities missing in the Solidity language.
10  */
11 library Math {
12     /**
13      * @dev Returns the largest of two numbers.
14      */
15     function max(uint256 a, uint256 b) internal pure returns (uint256) {
16         return a >= b ? a : b;
17     }
18 
19     /**
20      * @dev Returns the smallest of two numbers.
21      */
22     function min(uint256 a, uint256 b) internal pure returns (uint256) {
23         return a < b ? a : b;
24     }
25 
26     /**
27      * @dev Returns the average of two numbers. The result is rounded towards
28      * zero.
29      */
30     function average(uint256 a, uint256 b) internal pure returns (uint256) {
31         // (a + b) / 2 can overflow, so we distribute
32         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
33     }
34 }
35 
36 // File: @openzeppelin/contracts/math/SafeMath.sol
37 
38 
39 pragma solidity ^0.6.0;
40 
41 /**
42  * @dev Wrappers over Solidity's arithmetic operations with added overflow
43  * checks.
44  *
45  * Arithmetic operations in Solidity wrap on overflow. This can easily result
46  * in bugs, because programmers usually assume that an overflow raises an
47  * error, which is the standard behavior in high level programming languages.
48  * `SafeMath` restores this intuition by reverting the transaction when an
49  * operation overflows.
50  *
51  * Using this library instead of the unchecked operations eliminates an entire
52  * class of bugs, so it's recommended to use it always.
53  */
54 library SafeMath {
55     /**
56      * @dev Returns the addition of two unsigned integers, reverting on
57      * overflow.
58      *
59      * Counterpart to Solidity's `+` operator.
60      *
61      * Requirements:
62      *
63      * - Addition cannot overflow.
64      */
65     function add(uint256 a, uint256 b) internal pure returns (uint256) {
66         uint256 c = a + b;
67         require(c >= a, "SafeMath: addition overflow");
68 
69         return c;
70     }
71 
72     /**
73      * @dev Returns the subtraction of two unsigned integers, reverting on
74      * overflow (when the result is negative).
75      *
76      * Counterpart to Solidity's `-` operator.
77      *
78      * Requirements:
79      *
80      * - Subtraction cannot overflow.
81      */
82     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
83         return sub(a, b, "SafeMath: subtraction overflow");
84     }
85 
86     /**
87      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
88      * overflow (when the result is negative).
89      *
90      * Counterpart to Solidity's `-` operator.
91      *
92      * Requirements:
93      *
94      * - Subtraction cannot overflow.
95      */
96     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
97         require(b <= a, errorMessage);
98         uint256 c = a - b;
99 
100         return c;
101     }
102 
103     /**
104      * @dev Returns the multiplication of two unsigned integers, reverting on
105      * overflow.
106      *
107      * Counterpart to Solidity's `*` operator.
108      *
109      * Requirements:
110      *
111      * - Multiplication cannot overflow.
112      */
113     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
114         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
115         // benefit is lost if 'b' is also tested.
116         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
117         if (a == 0) {
118             return 0;
119         }
120 
121         uint256 c = a * b;
122         require(c / a == b, "SafeMath: multiplication overflow");
123 
124         return c;
125     }
126 
127     /**
128      * @dev Returns the integer division of two unsigned integers. Reverts on
129      * division by zero. The result is rounded towards zero.
130      *
131      * Counterpart to Solidity's `/` operator. Note: this function uses a
132      * `revert` opcode (which leaves remaining gas untouched) while Solidity
133      * uses an invalid opcode to revert (consuming all remaining gas).
134      *
135      * Requirements:
136      *
137      * - The divisor cannot be zero.
138      */
139     function div(uint256 a, uint256 b) internal pure returns (uint256) {
140         return div(a, b, "SafeMath: division by zero");
141     }
142 
143     /**
144      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
145      * division by zero. The result is rounded towards zero.
146      *
147      * Counterpart to Solidity's `/` operator. Note: this function uses a
148      * `revert` opcode (which leaves remaining gas untouched) while Solidity
149      * uses an invalid opcode to revert (consuming all remaining gas).
150      *
151      * Requirements:
152      *
153      * - The divisor cannot be zero.
154      */
155     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
156         require(b > 0, errorMessage);
157         uint256 c = a / b;
158         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
159 
160         return c;
161     }
162 
163     /**
164      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
165      * Reverts when dividing by zero.
166      *
167      * Counterpart to Solidity's `%` operator. This function uses a `revert`
168      * opcode (which leaves remaining gas untouched) while Solidity uses an
169      * invalid opcode to revert (consuming all remaining gas).
170      *
171      * Requirements:
172      *
173      * - The divisor cannot be zero.
174      */
175     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
176         return mod(a, b, "SafeMath: modulo by zero");
177     }
178 
179     /**
180      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
181      * Reverts with custom message when dividing by zero.
182      *
183      * Counterpart to Solidity's `%` operator. This function uses a `revert`
184      * opcode (which leaves remaining gas untouched) while Solidity uses an
185      * invalid opcode to revert (consuming all remaining gas).
186      *
187      * Requirements:
188      *
189      * - The divisor cannot be zero.
190      */
191     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
192         require(b != 0, errorMessage);
193         return a % b;
194     }
195 }
196 
197 // File: @openzeppelin/contracts/GSN/Context.sol
198 
199 
200 pragma solidity ^0.6.0;
201 
202 /*
203  * @dev Provides information about the current execution context, including the
204  * sender of the transaction and its data. While these are generally available
205  * via msg.sender and msg.data, they should not be accessed in such a direct
206  * manner, since when dealing with GSN meta-transactions the account sending and
207  * paying for execution may not be the actual sender (as far as an application
208  * is concerned).
209  *
210  * This contract is only required for intermediate, library-like contracts.
211  */
212 abstract contract Context {
213     function _msgSender() internal view virtual returns (address payable) {
214         return msg.sender;
215     }
216 
217     function _msgData() internal view virtual returns (bytes memory) {
218         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
219         return msg.data;
220     }
221 }
222 
223 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
224 
225 
226 pragma solidity ^0.6.0;
227 
228 /**
229  * @dev Interface of the ERC20 standard as defined in the EIP.
230  */
231 interface IERC20 {
232     /**
233      * @dev Returns the amount of tokens in existence.
234      */
235     function totalSupply() external view returns (uint256);
236 
237     /**
238      * @dev Returns the amount of tokens owned by `account`.
239      */
240     function balanceOf(address account) external view returns (uint256);
241 
242     /**
243      * @dev Moves `amount` tokens from the caller's account to `recipient`.
244      *
245      * Returns a boolean value indicating whether the operation succeeded.
246      *
247      * Emits a {Transfer} event.
248      */
249     function transfer(address recipient, uint256 amount) external returns (bool);
250 
251     /**
252      * @dev Returns the remaining number of tokens that `spender` will be
253      * allowed to spend on behalf of `owner` through {transferFrom}. This is
254      * zero by default.
255      *
256      * This value changes when {approve} or {transferFrom} are called.
257      */
258     function allowance(address owner, address spender) external view returns (uint256);
259 
260     /**
261      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
262      *
263      * Returns a boolean value indicating whether the operation succeeded.
264      *
265      * IMPORTANT: Beware that changing an allowance with this method brings the risk
266      * that someone may use both the old and the new allowance by unfortunate
267      * transaction ordering. One possible solution to mitigate this race
268      * condition is to first reduce the spender's allowance to 0 and set the
269      * desired value afterwards:
270      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
271      *
272      * Emits an {Approval} event.
273      */
274     function approve(address spender, uint256 amount) external returns (bool);
275 
276     /**
277      * @dev Moves `amount` tokens from `sender` to `recipient` using the
278      * allowance mechanism. `amount` is then deducted from the caller's
279      * allowance.
280      *
281      * Returns a boolean value indicating whether the operation succeeded.
282      *
283      * Emits a {Transfer} event.
284      */
285     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
286 
287     /**
288      * @dev Emitted when `value` tokens are moved from one account (`from`) to
289      * another (`to`).
290      *
291      * Note that `value` may be zero.
292      */
293     event Transfer(address indexed from, address indexed to, uint256 value);
294 
295     /**
296      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
297      * a call to {approve}. `value` is the new allowance.
298      */
299     event Approval(address indexed owner, address indexed spender, uint256 value);
300 }
301 
302 // File: @openzeppelin/contracts/utils/Address.sol
303 
304 
305 pragma solidity ^0.6.2;
306 
307 /**
308  * @dev Collection of functions related to the address type
309  */
310 library Address {
311     /**
312      * @dev Returns true if `account` is a contract.
313      *
314      * [IMPORTANT]
315      * ====
316      * It is unsafe to assume that an address for which this function returns
317      * false is an externally-owned account (EOA) and not a contract.
318      *
319      * Among others, `isContract` will return false for the following
320      * types of addresses:
321      *
322      *  - an externally-owned account
323      *  - a contract in construction
324      *  - an address where a contract will be created
325      *  - an address where a contract lived, but was destroyed
326      * ====
327      */
328     function isContract(address account) internal view returns (bool) {
329         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
330         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
331         // for accounts without code, i.e. `keccak256('')`
332         bytes32 codehash;
333         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
334         // solhint-disable-next-line no-inline-assembly
335         assembly { codehash := extcodehash(account) }
336         return (codehash != accountHash && codehash != 0x0);
337     }
338 
339     /**
340      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
341      * `recipient`, forwarding all available gas and reverting on errors.
342      *
343      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
344      * of certain opcodes, possibly making contracts go over the 2300 gas limit
345      * imposed by `transfer`, making them unable to receive funds via
346      * `transfer`. {sendValue} removes this limitation.
347      *
348      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
349      *
350      * IMPORTANT: because control is transferred to `recipient`, care must be
351      * taken to not create reentrancy vulnerabilities. Consider using
352      * {ReentrancyGuard} or the
353      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
354      */
355     function sendValue(address payable recipient, uint256 amount) internal {
356         require(address(this).balance >= amount, "Address: insufficient balance");
357 
358         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
359         (bool success, ) = recipient.call{ value: amount }("");
360         require(success, "Address: unable to send value, recipient may have reverted");
361     }
362 
363     /**
364      * @dev Performs a Solidity function call using a low level `call`. A
365      * plain`call` is an unsafe replacement for a function call: use this
366      * function instead.
367      *
368      * If `target` reverts with a revert reason, it is bubbled up by this
369      * function (like regular Solidity function calls).
370      *
371      * Returns the raw returned data. To convert to the expected return value,
372      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
373      *
374      * Requirements:
375      *
376      * - `target` must be a contract.
377      * - calling `target` with `data` must not revert.
378      *
379      * _Available since v3.1._
380      */
381     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
382       return functionCall(target, data, "Address: low-level call failed");
383     }
384 
385     /**
386      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
387      * `errorMessage` as a fallback revert reason when `target` reverts.
388      *
389      * _Available since v3.1._
390      */
391     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
392         return _functionCallWithValue(target, data, 0, errorMessage);
393     }
394 
395     /**
396      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
397      * but also transferring `value` wei to `target`.
398      *
399      * Requirements:
400      *
401      * - the calling contract must have an ETH balance of at least `value`.
402      * - the called Solidity function must be `payable`.
403      *
404      * _Available since v3.1._
405      */
406     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
407         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
408     }
409 
410     /**
411      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
412      * with `errorMessage` as a fallback revert reason when `target` reverts.
413      *
414      * _Available since v3.1._
415      */
416     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
417         require(address(this).balance >= value, "Address: insufficient balance for call");
418         return _functionCallWithValue(target, data, value, errorMessage);
419     }
420 
421     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
422         require(isContract(target), "Address: call to non-contract");
423 
424         // solhint-disable-next-line avoid-low-level-calls
425         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
426         if (success) {
427             return returndata;
428         } else {
429             // Look for revert reason and bubble it up if present
430             if (returndata.length > 0) {
431                 // The easiest way to bubble the revert reason is using memory via assembly
432 
433                 // solhint-disable-next-line no-inline-assembly
434                 assembly {
435                     let returndata_size := mload(returndata)
436                     revert(add(32, returndata), returndata_size)
437                 }
438             } else {
439                 revert(errorMessage);
440             }
441         }
442     }
443 }
444 
445 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
446 
447 
448 pragma solidity ^0.6.0;
449 
450 
451 
452 
453 
454 /**
455  * @dev Implementation of the {IERC20} interface.
456  *
457  * This implementation is agnostic to the way tokens are created. This means
458  * that a supply mechanism has to be added in a derived contract using {_mint}.
459  * For a generic mechanism see {ERC20PresetMinterPauser}.
460  *
461  * TIP: For a detailed writeup see our guide
462  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
463  * to implement supply mechanisms].
464  *
465  * We have followed general OpenZeppelin guidelines: functions revert instead
466  * of returning `false` on failure. This behavior is nonetheless conventional
467  * and does not conflict with the expectations of ERC20 applications.
468  *
469  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
470  * This allows applications to reconstruct the allowance for all accounts just
471  * by listening to said events. Other implementations of the EIP may not emit
472  * these events, as it isn't required by the specification.
473  *
474  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
475  * functions have been added to mitigate the well-known issues around setting
476  * allowances. See {IERC20-approve}.
477  */
478 contract ERC20 is Context, IERC20 {
479     using SafeMath for uint256;
480     using Address for address;
481 
482     mapping (address => uint256) private _balances;
483 
484     mapping (address => mapping (address => uint256)) private _allowances;
485 
486     uint256 private _totalSupply;
487 
488     string private _name;
489     string private _symbol;
490     uint8 private _decimals;
491 
492     /**
493      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
494      * a default value of 18.
495      *
496      * To select a different value for {decimals}, use {_setupDecimals}.
497      *
498      * All three of these values are immutable: they can only be set once during
499      * construction.
500      */
501     constructor (string memory name, string memory symbol) public {
502         _name = name;
503         _symbol = symbol;
504         _decimals = 18;
505     }
506 
507     /**
508      * @dev Returns the name of the token.
509      */
510     function name() public view returns (string memory) {
511         return _name;
512     }
513 
514     /**
515      * @dev Returns the symbol of the token, usually a shorter version of the
516      * name.
517      */
518     function symbol() public view returns (string memory) {
519         return _symbol;
520     }
521 
522     /**
523      * @dev Returns the number of decimals used to get its user representation.
524      * For example, if `decimals` equals `2`, a balance of `505` tokens should
525      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
526      *
527      * Tokens usually opt for a value of 18, imitating the relationship between
528      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
529      * called.
530      *
531      * NOTE: This information is only used for _display_ purposes: it in
532      * no way affects any of the arithmetic of the contract, including
533      * {IERC20-balanceOf} and {IERC20-transfer}.
534      */
535     function decimals() public view returns (uint8) {
536         return _decimals;
537     }
538 
539     /**
540      * @dev See {IERC20-totalSupply}.
541      */
542     function totalSupply() public view override returns (uint256) {
543         return _totalSupply;
544     }
545 
546     /**
547      * @dev See {IERC20-balanceOf}.
548      */
549     function balanceOf(address account) public view override returns (uint256) {
550         return _balances[account];
551     }
552 
553     /**
554      * @dev See {IERC20-transfer}.
555      *
556      * Requirements:
557      *
558      * - `recipient` cannot be the zero address.
559      * - the caller must have a balance of at least `amount`.
560      */
561     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
562         _transfer(_msgSender(), recipient, amount);
563         return true;
564     }
565 
566     /**
567      * @dev See {IERC20-allowance}.
568      */
569     function allowance(address owner, address spender) public view virtual override returns (uint256) {
570         return _allowances[owner][spender];
571     }
572 
573     /**
574      * @dev See {IERC20-approve}.
575      *
576      * Requirements:
577      *
578      * - `spender` cannot be the zero address.
579      */
580     function approve(address spender, uint256 amount) public virtual override returns (bool) {
581         _approve(_msgSender(), spender, amount);
582         return true;
583     }
584 
585     /**
586      * @dev See {IERC20-transferFrom}.
587      *
588      * Emits an {Approval} event indicating the updated allowance. This is not
589      * required by the EIP. See the note at the beginning of {ERC20};
590      *
591      * Requirements:
592      * - `sender` and `recipient` cannot be the zero address.
593      * - `sender` must have a balance of at least `amount`.
594      * - the caller must have allowance for ``sender``'s tokens of at least
595      * `amount`.
596      */
597     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
598         _transfer(sender, recipient, amount);
599         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
600         return true;
601     }
602 
603     /**
604      * @dev Atomically increases the allowance granted to `spender` by the caller.
605      *
606      * This is an alternative to {approve} that can be used as a mitigation for
607      * problems described in {IERC20-approve}.
608      *
609      * Emits an {Approval} event indicating the updated allowance.
610      *
611      * Requirements:
612      *
613      * - `spender` cannot be the zero address.
614      */
615     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
616         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
617         return true;
618     }
619 
620     /**
621      * @dev Atomically decreases the allowance granted to `spender` by the caller.
622      *
623      * This is an alternative to {approve} that can be used as a mitigation for
624      * problems described in {IERC20-approve}.
625      *
626      * Emits an {Approval} event indicating the updated allowance.
627      *
628      * Requirements:
629      *
630      * - `spender` cannot be the zero address.
631      * - `spender` must have allowance for the caller of at least
632      * `subtractedValue`.
633      */
634     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
635         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
636         return true;
637     }
638 
639     /**
640      * @dev Moves tokens `amount` from `sender` to `recipient`.
641      *
642      * This is internal function is equivalent to {transfer}, and can be used to
643      * e.g. implement automatic token fees, slashing mechanisms, etc.
644      *
645      * Emits a {Transfer} event.
646      *
647      * Requirements:
648      *
649      * - `sender` cannot be the zero address.
650      * - `recipient` cannot be the zero address.
651      * - `sender` must have a balance of at least `amount`.
652      */
653     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
654         require(sender != address(0), "ERC20: transfer from the zero address");
655         require(recipient != address(0), "ERC20: transfer to the zero address");
656 
657         _beforeTokenTransfer(sender, recipient, amount);
658 
659         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
660         _balances[recipient] = _balances[recipient].add(amount);
661         emit Transfer(sender, recipient, amount);
662     }
663 
664     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
665      * the total supply.
666      *
667      * Emits a {Transfer} event with `from` set to the zero address.
668      *
669      * Requirements
670      *
671      * - `to` cannot be the zero address.
672      */
673     function _mint(address account, uint256 amount) internal virtual {
674         require(account != address(0), "ERC20: mint to the zero address");
675 
676         _beforeTokenTransfer(address(0), account, amount);
677 
678         _totalSupply = _totalSupply.add(amount);
679         _balances[account] = _balances[account].add(amount);
680         emit Transfer(address(0), account, amount);
681     }
682 
683     /**
684      * @dev Destroys `amount` tokens from `account`, reducing the
685      * total supply.
686      *
687      * Emits a {Transfer} event with `to` set to the zero address.
688      *
689      * Requirements
690      *
691      * - `account` cannot be the zero address.
692      * - `account` must have at least `amount` tokens.
693      */
694     function _burn(address account, uint256 amount) internal virtual {
695         require(account != address(0), "ERC20: burn from the zero address");
696 
697         _beforeTokenTransfer(account, address(0), amount);
698 
699         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
700         _totalSupply = _totalSupply.sub(amount);
701         emit Transfer(account, address(0), amount);
702     }
703 
704     /**
705      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
706      *
707      * This is internal function is equivalent to `approve`, and can be used to
708      * e.g. set automatic allowances for certain subsystems, etc.
709      *
710      * Emits an {Approval} event.
711      *
712      * Requirements:
713      *
714      * - `owner` cannot be the zero address.
715      * - `spender` cannot be the zero address.
716      */
717     function _approve(address owner, address spender, uint256 amount) internal virtual {
718         require(owner != address(0), "ERC20: approve from the zero address");
719         require(spender != address(0), "ERC20: approve to the zero address");
720 
721         _allowances[owner][spender] = amount;
722         emit Approval(owner, spender, amount);
723     }
724 
725     /**
726      * @dev Sets {decimals} to a value other than the default one of 18.
727      *
728      * WARNING: This function should only be called from the constructor. Most
729      * applications that interact with token contracts will not expect
730      * {decimals} to ever change, and may work incorrectly if it does.
731      */
732     function _setupDecimals(uint8 decimals_) internal {
733         _decimals = decimals_;
734     }
735 
736     /**
737      * @dev Hook that is called before any transfer of tokens. This includes
738      * minting and burning.
739      *
740      * Calling conditions:
741      *
742      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
743      * will be to transferred to `to`.
744      * - when `from` is zero, `amount` tokens will be minted for `to`.
745      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
746      * - `from` and `to` are never both zero.
747      *
748      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
749      */
750     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
751 }
752 
753 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
754 
755 
756 pragma solidity ^0.6.0;
757 
758 
759 
760 
761 /**
762  * @title SafeERC20
763  * @dev Wrappers around ERC20 operations that throw on failure (when the token
764  * contract returns false). Tokens that return no value (and instead revert or
765  * throw on failure) are also supported, non-reverting calls are assumed to be
766  * successful.
767  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
768  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
769  */
770 library SafeERC20 {
771     using SafeMath for uint256;
772     using Address for address;
773 
774     function safeTransfer(IERC20 token, address to, uint256 value) internal {
775         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
776     }
777 
778     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
779         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
780     }
781 
782     /**
783      * @dev Deprecated. This function has issues similar to the ones found in
784      * {IERC20-approve}, and its usage is discouraged.
785      *
786      * Whenever possible, use {safeIncreaseAllowance} and
787      * {safeDecreaseAllowance} instead.
788      */
789     function safeApprove(IERC20 token, address spender, uint256 value) internal {
790         // safeApprove should only be called when setting an initial allowance,
791         // or when resetting it to zero. To increase and decrease it, use
792         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
793         // solhint-disable-next-line max-line-length
794         require((value == 0) || (token.allowance(address(this), spender) == 0),
795             "SafeERC20: approve from non-zero to non-zero allowance"
796         );
797         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
798     }
799 
800     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
801         uint256 newAllowance = token.allowance(address(this), spender).add(value);
802         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
803     }
804 
805     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
806         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
807         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
808     }
809 
810     /**
811      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
812      * on the return value: the return value is optional (but if data is returned, it must not be false).
813      * @param token The token targeted by the call.
814      * @param data The call data (encoded using abi.encode or one of its variants).
815      */
816     function _callOptionalReturn(IERC20 token, bytes memory data) private {
817         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
818         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
819         // the target address contains contract code and also asserts for success in the low-level call.
820 
821         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
822         if (returndata.length > 0) { // Return data is optional
823             // solhint-disable-next-line max-line-length
824             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
825         }
826     }
827 }
828 
829 // File: @openzeppelin/contracts/utils/ReentrancyGuard.sol
830 
831 
832 pragma solidity ^0.6.0;
833 
834 /**
835  * @dev Contract module that helps prevent reentrant calls to a function.
836  *
837  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
838  * available, which can be applied to functions to make sure there are no nested
839  * (reentrant) calls to them.
840  *
841  * Note that because there is a single `nonReentrant` guard, functions marked as
842  * `nonReentrant` may not call one another. This can be worked around by making
843  * those functions `private`, and then adding `external` `nonReentrant` entry
844  * points to them.
845  *
846  * TIP: If you would like to learn more about reentrancy and alternative ways
847  * to protect against it, check out our blog post
848  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
849  */
850 contract ReentrancyGuard {
851     // Booleans are more expensive than uint256 or any type that takes up a full
852     // word because each write operation emits an extra SLOAD to first read the
853     // slot's contents, replace the bits taken up by the boolean, and then write
854     // back. This is the compiler's defense against contract upgrades and
855     // pointer aliasing, and it cannot be disabled.
856 
857     // The values being non-zero value makes deployment a bit more expensive,
858     // but in exchange the refund on every call to nonReentrant will be lower in
859     // amount. Since refunds are capped to a percentage of the total
860     // transaction's gas, it is best to keep them low in cases like this one, to
861     // increase the likelihood of the full refund coming into effect.
862     uint256 private constant _NOT_ENTERED = 1;
863     uint256 private constant _ENTERED = 2;
864 
865     uint256 private _status;
866 
867     constructor () internal {
868         _status = _NOT_ENTERED;
869     }
870 
871     /**
872      * @dev Prevents a contract from calling itself, directly or indirectly.
873      * Calling a `nonReentrant` function from another `nonReentrant`
874      * function is not supported. It is possible to prevent this from happening
875      * by making the `nonReentrant` function external, and make it call a
876      * `private` function that does the actual work.
877      */
878     modifier nonReentrant() {
879         // On the first call to nonReentrant, _notEntered will be true
880         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
881 
882         // Any calls to nonReentrant after this point will fail
883         _status = _ENTERED;
884 
885         _;
886 
887         // By storing the original value once again, a refund is triggered (see
888         // https://eips.ethereum.org/EIPS/eip-2200)
889         _status = _NOT_ENTERED;
890     }
891 }
892 
893 // File: contracts/Rewards/Synthetix/StakingRewards.sol
894 
895 pragma solidity ^0.6.12;
896 
897 
898 
899 
900 
901 
902 // Inheritance
903 // import "./interfaces/IStakingRewards.sol";
904 // import "./RewardsDistributionRecipient.sol";
905 // import "./Pausable.sol";
906 // import "./Owned.sol";
907 
908 
909 
910 // https://docs.synthetix.io/contracts/Owned
911 contract Owned {
912     address public owner;
913     address public nominatedOwner;
914 
915     constructor(address _owner) public {
916         require(_owner != address(0), "Owner address cannot be 0");
917         owner = _owner;
918         emit OwnerChanged(address(0), _owner);
919     }
920 
921     function nominateNewOwner(address _owner) external onlyOwner {
922         nominatedOwner = _owner;
923         emit OwnerNominated(_owner);
924     }
925 
926     function acceptOwnership() external {
927         require(msg.sender == nominatedOwner, "You must be nominated before you can accept ownership");
928         emit OwnerChanged(owner, nominatedOwner);
929         owner = nominatedOwner;
930         nominatedOwner = address(0);
931     }
932 
933     modifier onlyOwner {
934         _onlyOwner();
935         _;
936     }
937 
938     function _onlyOwner() private view {
939         require(msg.sender == owner, "Only the contract owner may perform this action");
940     }
941 
942     event OwnerNominated(address newOwner);
943     event OwnerChanged(address oldOwner, address newOwner);
944 }
945 
946 
947 
948 // https://docs.synthetix.io/contracts/Pausable
949 abstract
950 contract Pausable is Owned {
951     uint public lastPauseTime;
952     bool public paused;
953 
954     constructor() internal {
955         // This contract is abstract, and thus cannot be instantiated directly
956         require(owner != address(0), "Owner must be set");
957         // Paused will be false, and lastPauseTime will be 0 upon initialisation
958     }
959 
960     /**
961      * @notice Change the paused state of the contract
962      * @dev Only the contract owner may call this.
963      */
964     function setPaused(bool _paused) external onlyOwner {
965         // Ensure we're actually changing the state before we do anything
966         if (_paused == paused) {
967             return;
968         }
969 
970         // Set our paused state.
971         paused = _paused;
972 
973         // If applicable, set the last pause time.
974         if (paused) {
975             lastPauseTime = now;
976         }
977 
978         // Let everyone know that our pause state has changed.
979         emit PauseChanged(paused);
980     }
981 
982     event PauseChanged(bool isPaused);
983 
984     modifier notPaused {
985         require(!paused, "This action cannot be performed while the contract is paused");
986         _;
987     }
988 }
989 
990 
991 // https://docs.synthetix.io/contracts/RewardsDistributionRecipient
992 abstract
993 contract RewardsDistributionRecipient is Owned {
994     address public rewardsDistribution;
995 
996     function notifyRewardAmount(uint256 reward) external virtual;
997 
998     modifier onlyRewardsDistribution() {
999         require(msg.sender == rewardsDistribution, "Caller is not RewardsDistribution contract");
1000         _;
1001     }
1002 
1003     function setRewardsDistribution(address _rewardsDistribution) external onlyOwner {
1004         rewardsDistribution = _rewardsDistribution;
1005     }
1006 }
1007 
1008 
1009 interface IStakingRewards {
1010     // Views
1011     function lastTimeRewardApplicable() external view returns (uint256);
1012 
1013     function rewardPerToken() external view returns (uint256);
1014 
1015     function earned(address account) external view returns (uint256);
1016 
1017     function getRewardForDuration() external view returns (uint256);
1018 
1019     function totalSupply() external view returns (uint256);
1020 
1021     function balanceOf(address account) external view returns (uint256);
1022 
1023     // Mutative
1024 
1025     function stake(uint256 amount) external;
1026 
1027     function withdraw(uint256 amount) external;
1028 
1029     function getReward() external;
1030 
1031     function exit() external;
1032 }
1033 
1034 
1035 contract StakingRewards is IStakingRewards, RewardsDistributionRecipient, ReentrancyGuard, Pausable {
1036     using SafeMath for uint256;
1037     using SafeERC20 for IERC20;
1038 
1039     /* ========== STATE VARIABLES ========== */
1040 
1041     IERC20 public rewardsToken;
1042     IERC20 public stakingToken;
1043     uint256 public periodFinish = 0;
1044     uint256 public rewardRate = 0;
1045     uint256 public rewardsDuration = 7 days;
1046     uint256 public lastUpdateTime;
1047     uint256 public rewardPerTokenStored;
1048 
1049     mapping(address => uint256) public userRewardPerTokenPaid;
1050     mapping(address => uint256) public rewards;
1051 
1052     uint256 private _totalSupply;
1053     mapping(address => uint256) private _balances;
1054 
1055     /* ========== CONSTRUCTOR ========== */
1056 
1057     constructor(
1058         address _owner,
1059         address _rewardsDistribution,
1060         address _rewardsToken,
1061         address _stakingToken
1062     ) public Owned(_owner) {
1063         rewardsToken = IERC20(_rewardsToken);
1064         stakingToken = IERC20(_stakingToken);
1065         rewardsDistribution = _rewardsDistribution;
1066     }
1067 
1068     /* ========== VIEWS ========== */
1069 
1070     function totalSupply() external view override returns (uint256) {
1071         return _totalSupply;
1072     }
1073 
1074     function balanceOf(address account) external view override returns (uint256) {
1075         return _balances[account];
1076     }
1077 
1078     function lastTimeRewardApplicable() public view override returns (uint256) {
1079         return Math.min(block.timestamp, periodFinish);
1080     }
1081 
1082     function rewardPerToken() public view override returns (uint256) {
1083         if (_totalSupply == 0) {
1084             return rewardPerTokenStored;
1085         }
1086         return
1087             rewardPerTokenStored.add(
1088                 lastTimeRewardApplicable().sub(lastUpdateTime).mul(rewardRate).mul(1e18).div(_totalSupply)
1089             );
1090     }
1091 
1092     function earned(address account) public view override returns (uint256) {
1093         return _balances[account].mul(rewardPerToken().sub(userRewardPerTokenPaid[account])).div(1e18).add(rewards[account]);
1094     }
1095 
1096     function getRewardForDuration() external view override returns (uint256) {
1097         return rewardRate.mul(rewardsDuration);
1098     }
1099 
1100     /* ========== MUTATIVE FUNCTIONS ========== */
1101 
1102     function stake(uint256 amount) external override nonReentrant notPaused updateReward(msg.sender) {
1103         require(amount > 0, "Cannot stake 0");
1104         _totalSupply = _totalSupply.add(amount);
1105         _balances[msg.sender] = _balances[msg.sender].add(amount);
1106         stakingToken.safeTransferFrom(msg.sender, address(this), amount);
1107         emit Staked(msg.sender, amount);
1108     }
1109 
1110     function withdraw(uint256 amount) public override nonReentrant updateReward(msg.sender) {
1111         require(amount > 0, "Cannot withdraw 0");
1112         _totalSupply = _totalSupply.sub(amount);
1113         _balances[msg.sender] = _balances[msg.sender].sub(amount);
1114         stakingToken.safeTransfer(msg.sender, amount);
1115         emit Withdrawn(msg.sender, amount);
1116     }
1117 
1118     function getReward() public override nonReentrant updateReward(msg.sender) {
1119         uint256 reward = rewards[msg.sender];
1120         if (reward > 0) {
1121             rewards[msg.sender] = 0;
1122             rewardsToken.safeTransfer(msg.sender, reward);
1123             emit RewardPaid(msg.sender, reward);
1124         }
1125     }
1126 
1127     function exit() external override {
1128         withdraw(_balances[msg.sender]);
1129         getReward();
1130     }
1131 
1132     /* ========== RESTRICTED FUNCTIONS ========== */
1133 
1134     function notifyRewardAmount(uint256 reward) external override onlyRewardsDistribution updateReward(address(0)) {
1135         if (block.timestamp >= periodFinish) {
1136             rewardRate = reward.div(rewardsDuration);
1137         } else {
1138             uint256 remaining = periodFinish.sub(block.timestamp);
1139             uint256 leftover = remaining.mul(rewardRate);
1140             rewardRate = reward.add(leftover).div(rewardsDuration);
1141         }
1142 
1143         // Ensure the provided reward amount is not more than the balance in the contract.
1144         // This keeps the reward rate in the right range, preventing overflows due to
1145         // very high values of rewardRate in the earned and rewardsPerToken functions;
1146         // Reward + leftover must be less than 2^256 / 10^18 to avoid overflow.
1147         uint balance = rewardsToken.balanceOf(address(this));
1148         require(rewardRate <= balance.div(rewardsDuration), "Provided reward too high");
1149 
1150         lastUpdateTime = block.timestamp;
1151         periodFinish = block.timestamp.add(rewardsDuration);
1152         emit RewardAdded(reward);
1153     }
1154 
1155     // Added to support recovering LP Rewards from other systems to be distributed to holders
1156     function recoverERC20(address tokenAddress, uint256 tokenAmount) external onlyOwner {
1157         // If it's SNX we have to query the token symbol to ensure its not a proxy or underlying
1158         bool isSNX = (keccak256(bytes("SNX")) == keccak256(bytes(ERC20(tokenAddress).symbol())));
1159         // Cannot recover the staking token or the rewards token
1160         require(
1161             tokenAddress != address(stakingToken) && tokenAddress != address(rewardsToken) && !isSNX,
1162             "Cannot withdraw the staking or rewards tokens"
1163         );
1164         IERC20(tokenAddress).safeTransfer(owner, tokenAmount);
1165         emit Recovered(tokenAddress, tokenAmount);
1166     }
1167 
1168     function setRewardsDuration(uint256 _rewardsDuration) external onlyOwner {
1169         require(
1170             periodFinish == 0 || block.timestamp > periodFinish,
1171             "Previous rewards period must be complete before changing the duration for the new period"
1172         );
1173         rewardsDuration = _rewardsDuration;
1174         emit RewardsDurationUpdated(rewardsDuration);
1175     }
1176 
1177     /* ========== MODIFIERS ========== */
1178 
1179     modifier updateReward(address account) {
1180         rewardPerTokenStored = rewardPerToken();
1181         lastUpdateTime = lastTimeRewardApplicable();
1182         if (account != address(0)) {
1183             rewards[account] = earned(account);
1184             userRewardPerTokenPaid[account] = rewardPerTokenStored;
1185         }
1186         _;
1187     }
1188 
1189     /* ========== EVENTS ========== */
1190 
1191     event RewardAdded(uint256 reward);
1192     event Staked(address indexed user, uint256 amount);
1193     event Withdrawn(address indexed user, uint256 amount);
1194     event RewardPaid(address indexed user, uint256 reward);
1195     event RewardsDurationUpdated(uint256 newDuration);
1196     event Recovered(address token, uint256 amount);
1197 }