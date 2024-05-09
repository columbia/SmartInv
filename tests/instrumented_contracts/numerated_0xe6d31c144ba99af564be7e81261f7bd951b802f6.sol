1 // SPDX-License-Identifier: GPL-2.0-or-later
2 pragma solidity >=0.8.0;
3 
4 // Sources flattened with hardhat v2.12.5 https://hardhat.org
5 
6 // File contracts/Common/Context.sol
7 
8 
9 /*
10  * @dev Provides information about the current execution context, including the
11  * sender of the transaction and its data. While these are generally available
12  * via msg.sender and msg.data, they should not be accessed in such a direct
13  * manner, since when dealing with GSN meta-transactions the account sending and
14  * paying for execution may not be the actual sender (as far as an application
15  * is concerned).
16  *
17  * This contract is only required for intermediate, library-like contracts.
18  */
19 abstract contract Context {
20     function _msgSender() internal view virtual returns (address payable) {
21         return payable(msg.sender);
22     }
23 
24     function _msgData() internal view virtual returns (bytes memory) {
25         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
26         return msg.data;
27     }
28 }
29 
30 
31 // File contracts/Math/SafeMath.sol
32 
33 
34 /**
35  * @dev Wrappers over Solidity's arithmetic operations with added overflow
36  * checks.
37  *
38  * Arithmetic operations in Solidity wrap on overflow. This can easily result
39  * in bugs, because programmers usually assume that an overflow raises an
40  * error, which is the standard behavior in high level programming languages.
41  * `SafeMath` restores this intuition by reverting the transaction when an
42  * operation overflows.
43  *
44  * Using this library instead of the unchecked operations eliminates an entire
45  * class of bugs, so it's recommended to use it always.
46  */
47 library SafeMath {
48     /**
49      * @dev Returns the addition of two unsigned integers, reverting on
50      * overflow.
51      *
52      * Counterpart to Solidity's `+` operator.
53      *
54      * Requirements:
55      * - Addition cannot overflow.
56      */
57     function add(uint256 a, uint256 b) internal pure returns (uint256) {
58         uint256 c = a + b;
59         require(c >= a, "SafeMath: addition overflow");
60 
61         return c;
62     }
63 
64     /**
65      * @dev Returns the subtraction of two unsigned integers, reverting on
66      * overflow (when the result is negative).
67      *
68      * Counterpart to Solidity's `-` operator.
69      *
70      * Requirements:
71      * - Subtraction cannot overflow.
72      */
73     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
74         return sub(a, b, "SafeMath: subtraction overflow");
75     }
76 
77     /**
78      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
79      * overflow (when the result is negative).
80      *
81      * Counterpart to Solidity's `-` operator.
82      *
83      * Requirements:
84      * - Subtraction cannot overflow.
85      *
86      * _Available since v2.4.0._
87      */
88     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
89         require(b <= a, errorMessage);
90         uint256 c = a - b;
91 
92         return c;
93     }
94 
95     /**
96      * @dev Returns the multiplication of two unsigned integers, reverting on
97      * overflow.
98      *
99      * Counterpart to Solidity's `*` operator.
100      *
101      * Requirements:
102      * - Multiplication cannot overflow.
103      */
104     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
105         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
106         // benefit is lost if 'b' is also tested.
107         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
108         if (a == 0) {
109             return 0;
110         }
111 
112         uint256 c = a * b;
113         require(c / a == b, "SafeMath: multiplication overflow");
114 
115         return c;
116     }
117 
118     /**
119      * @dev Returns the integer division of two unsigned integers. Reverts on
120      * division by zero. The result is rounded towards zero.
121      *
122      * Counterpart to Solidity's `/` operator. Note: this function uses a
123      * `revert` opcode (which leaves remaining gas untouched) while Solidity
124      * uses an invalid opcode to revert (consuming all remaining gas).
125      *
126      * Requirements:
127      * - The divisor cannot be zero.
128      */
129     function div(uint256 a, uint256 b) internal pure returns (uint256) {
130         return div(a, b, "SafeMath: division by zero");
131     }
132 
133     /**
134      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
135      * division by zero. The result is rounded towards zero.
136      *
137      * Counterpart to Solidity's `/` operator. Note: this function uses a
138      * `revert` opcode (which leaves remaining gas untouched) while Solidity
139      * uses an invalid opcode to revert (consuming all remaining gas).
140      *
141      * Requirements:
142      * - The divisor cannot be zero.
143      *
144      * _Available since v2.4.0._
145      */
146     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
147         // Solidity only automatically asserts when dividing by 0
148         require(b > 0, errorMessage);
149         uint256 c = a / b;
150         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
151 
152         return c;
153     }
154 
155     /**
156      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
157      * Reverts when dividing by zero.
158      *
159      * Counterpart to Solidity's `%` operator. This function uses a `revert`
160      * opcode (which leaves remaining gas untouched) while Solidity uses an
161      * invalid opcode to revert (consuming all remaining gas).
162      *
163      * Requirements:
164      * - The divisor cannot be zero.
165      */
166     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
167         return mod(a, b, "SafeMath: modulo by zero");
168     }
169 
170     /**
171      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
172      * Reverts with custom message when dividing by zero.
173      *
174      * Counterpart to Solidity's `%` operator. This function uses a `revert`
175      * opcode (which leaves remaining gas untouched) while Solidity uses an
176      * invalid opcode to revert (consuming all remaining gas).
177      *
178      * Requirements:
179      * - The divisor cannot be zero.
180      *
181      * _Available since v2.4.0._
182      */
183     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
184         require(b != 0, errorMessage);
185         return a % b;
186     }
187 }
188 
189 
190 // File contracts/ERC20/IERC20.sol
191 
192 
193 
194 /**
195  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
196  * the optional functions; to access them see {ERC20Detailed}.
197  */
198 interface IERC20 {
199     /**
200      * @dev Returns the amount of tokens in existence.
201      */
202     function totalSupply() external view returns (uint256);
203 
204     /**
205      * @dev Returns the amount of tokens owned by `account`.
206      */
207     function balanceOf(address account) external view returns (uint256);
208 
209     /**
210      * @dev Moves `amount` tokens from the caller's account to `recipient`.
211      *
212      * Returns a boolean value indicating whether the operation succeeded.
213      *
214      * Emits a {Transfer} event.
215      */
216     function transfer(address recipient, uint256 amount) external returns (bool);
217 
218     /**
219      * @dev Returns the remaining number of tokens that `spender` will be
220      * allowed to spend on behalf of `owner` through {transferFrom}. This is
221      * zero by default.
222      *
223      * This value changes when {approve} or {transferFrom} are called.
224      */
225     function allowance(address owner, address spender) external view returns (uint256);
226 
227     /**
228      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
229      *
230      * Returns a boolean value indicating whether the operation succeeded.
231      *
232      * IMPORTANT: Beware that changing an allowance with this method brings the risk
233      * that someone may use both the old and the new allowance by unfortunate
234      * transaction ordering. One possible solution to mitigate this race
235      * condition is to first reduce the spender's allowance to 0 and set the
236      * desired value afterwards:
237      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
238      *
239      * Emits an {Approval} event.
240      */
241     function approve(address spender, uint256 amount) external returns (bool);
242 
243     /**
244      * @dev Moves `amount` tokens from `sender` to `recipient` using the
245      * allowance mechanism. `amount` is then deducted from the caller's
246      * allowance.
247      *
248      * Returns a boolean value indicating whether the operation succeeded.
249      *
250      * Emits a {Transfer} event.
251      */
252     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
253 
254     /**
255      * @dev Emitted when `value` tokens are moved from one account (`from`) to
256      * another (`to`).
257      *
258      * Note that `value` may be zero.
259      */
260     event Transfer(address indexed from, address indexed to, uint256 value);
261 
262     /**
263      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
264      * a call to {approve}. `value` is the new allowance.
265      */
266     event Approval(address indexed owner, address indexed spender, uint256 value);
267 }
268 
269 
270 // File contracts/Utils/Address.sol
271 
272 
273 /**
274  * @dev Collection of functions related to the address type
275  */
276 library Address {
277     /**
278      * @dev Returns true if `account` is a contract.
279      *
280      * [IMPORTANT]
281      * ====
282      * It is unsafe to assume that an address for which this function returns
283      * false is an externally-owned account (EOA) and not a contract.
284      *
285      * Among others, `isContract` will return false for the following
286      * types of addresses:
287      *
288      *  - an externally-owned account
289      *  - a contract in construction
290      *  - an address where a contract will be created
291      *  - an address where a contract lived, but was destroyed
292      * ====
293      */
294     function isContract(address account) internal view returns (bool) {
295         // This method relies on extcodesize, which returns 0 for contracts in
296         // construction, since the code is only stored at the end of the
297         // constructor execution.
298 
299         uint256 size;
300         // solhint-disable-next-line no-inline-assembly
301         assembly { size := extcodesize(account) }
302         return size > 0;
303     }
304 
305     /**
306      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
307      * `recipient`, forwarding all available gas and reverting on errors.
308      *
309      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
310      * of certain opcodes, possibly making contracts go over the 2300 gas limit
311      * imposed by `transfer`, making them unable to receive funds via
312      * `transfer`. {sendValue} removes this limitation.
313      *
314      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
315      *
316      * IMPORTANT: because control is transferred to `recipient`, care must be
317      * taken to not create reentrancy vulnerabilities. Consider using
318      * {ReentrancyGuard} or the
319      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
320      */
321     function sendValue(address payable recipient, uint256 amount) internal {
322         require(address(this).balance >= amount, "Address: insufficient balance");
323 
324         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
325         (bool success, ) = recipient.call{ value: amount }("");
326         require(success, "Address: unable to send value, recipient may have reverted");
327     }
328 
329     /**
330      * @dev Performs a Solidity function call using a low level `call`. A
331      * plain`call` is an unsafe replacement for a function call: use this
332      * function instead.
333      *
334      * If `target` reverts with a revert reason, it is bubbled up by this
335      * function (like regular Solidity function calls).
336      *
337      * Returns the raw returned data. To convert to the expected return value,
338      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
339      *
340      * Requirements:
341      *
342      * - `target` must be a contract.
343      * - calling `target` with `data` must not revert.
344      *
345      * _Available since v3.1._
346      */
347     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
348       return functionCall(target, data, "Address: low-level call failed");
349     }
350 
351     /**
352      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
353      * `errorMessage` as a fallback revert reason when `target` reverts.
354      *
355      * _Available since v3.1._
356      */
357     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
358         return functionCallWithValue(target, data, 0, errorMessage);
359     }
360 
361     /**
362      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
363      * but also transferring `value` wei to `target`.
364      *
365      * Requirements:
366      *
367      * - the calling contract must have an ETH balance of at least `value`.
368      * - the called Solidity function must be `payable`.
369      *
370      * _Available since v3.1._
371      */
372     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
373         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
374     }
375 
376     /**
377      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
378      * with `errorMessage` as a fallback revert reason when `target` reverts.
379      *
380      * _Available since v3.1._
381      */
382     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
383         require(address(this).balance >= value, "Address: insufficient balance for call");
384         require(isContract(target), "Address: call to non-contract");
385 
386         // solhint-disable-next-line avoid-low-level-calls
387         (bool success, bytes memory returndata) = target.call{ value: value }(data);
388         return _verifyCallResult(success, returndata, errorMessage);
389     }
390 
391     /**
392      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
393      * but performing a static call.
394      *
395      * _Available since v3.3._
396      */
397     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
398         return functionStaticCall(target, data, "Address: low-level static call failed");
399     }
400 
401     /**
402      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
403      * but performing a static call.
404      *
405      * _Available since v3.3._
406      */
407     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
408         require(isContract(target), "Address: static call to non-contract");
409 
410         // solhint-disable-next-line avoid-low-level-calls
411         (bool success, bytes memory returndata) = target.staticcall(data);
412         return _verifyCallResult(success, returndata, errorMessage);
413     }
414 
415     /**
416      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
417      * but performing a delegate call.
418      *
419      * _Available since v3.4._
420      */
421     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
422         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
423     }
424 
425     /**
426      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
427      * but performing a delegate call.
428      *
429      * _Available since v3.4._
430      */
431     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
432         require(isContract(target), "Address: delegate call to non-contract");
433 
434         // solhint-disable-next-line avoid-low-level-calls
435         (bool success, bytes memory returndata) = target.delegatecall(data);
436         return _verifyCallResult(success, returndata, errorMessage);
437     }
438 
439     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
440         if (success) {
441             return returndata;
442         } else {
443             // Look for revert reason and bubble it up if present
444             if (returndata.length > 0) {
445                 // The easiest way to bubble the revert reason is using memory via assembly
446 
447                 // solhint-disable-next-line no-inline-assembly
448                 assembly {
449                     let returndata_size := mload(returndata)
450                     revert(add(32, returndata), returndata_size)
451                 }
452             } else {
453                 revert(errorMessage);
454             }
455         }
456     }
457 }
458 
459 
460 // File contracts/ERC20/ERC20.sol
461 
462 
463 
464 
465 
466 /**
467  * @dev Implementation of the {IERC20} interface.
468  *
469  * This implementation is agnostic to the way tokens are created. This means
470  * that a supply mechanism has to be added in a derived contract using {_mint}.
471  * For a generic mechanism see {ERC20Mintable}.
472  *
473  * TIP: For a detailed writeup see our guide
474  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
475  * to implement supply mechanisms].
476  *
477  * We have followed general OpenZeppelin guidelines: functions revert instead
478  * of returning `false` on failure. This behavior is nonetheless conventional
479  * and does not conflict with the expectations of ERC20 applications.
480  *
481  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
482  * This allows applications to reconstruct the allowance for all accounts just
483  * by listening to said events. Other implementations of the EIP may not emit
484  * these events, as it isn't required by the specification.
485  *
486  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
487  * functions have been added to mitigate the well-known issues around setting
488  * allowances. See {IERC20-approve}.
489  */
490  
491 contract ERC20 is Context, IERC20 {
492     using SafeMath for uint256;
493 
494     mapping (address => uint256) private _balances;
495 
496     mapping (address => mapping (address => uint256)) private _allowances;
497 
498     uint256 private _totalSupply;
499 
500     string private _name;
501     string private _symbol;
502     uint8 private _decimals;
503     
504     /**
505      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
506      * a default value of 18.
507      *
508      * To select a different value for {decimals}, use {_setupDecimals}.
509      *
510      * All three of these values are immutable: they can only be set once during
511      * construction.
512      */
513     constructor (string memory __name, string memory __symbol) public {
514         _name = __name;
515         _symbol = __symbol;
516         _decimals = 18;
517     }
518 
519     /**
520      * @dev Returns the name of the token.
521      */
522     function name() public view returns (string memory) {
523         return _name;
524     }
525 
526     /**
527      * @dev Returns the symbol of the token, usually a shorter version of the
528      * name.
529      */
530     function symbol() public view returns (string memory) {
531         return _symbol;
532     }
533 
534     /**
535      * @dev Returns the number of decimals used to get its user representation.
536      * For example, if `decimals` equals `2`, a balance of `505` tokens should
537      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
538      *
539      * Tokens usually opt for a value of 18, imitating the relationship between
540      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
541      * called.
542      *
543      * NOTE: This information is only used for _display_ purposes: it in
544      * no way affects any of the arithmetic of the contract, including
545      * {IERC20-balanceOf} and {IERC20-transfer}.
546      */
547     function decimals() public view returns (uint8) {
548         return _decimals;
549     }
550 
551     /**
552      * @dev See {IERC20-totalSupply}.
553      */
554     function totalSupply() public view override returns (uint256) {
555         return _totalSupply;
556     }
557 
558     /**
559      * @dev See {IERC20-balanceOf}.
560      */
561     function balanceOf(address account) public view override returns (uint256) {
562         return _balances[account];
563     }
564 
565     /**
566      * @dev See {IERC20-transfer}.
567      *
568      * Requirements:
569      *
570      * - `recipient` cannot be the zero address.
571      * - the caller must have a balance of at least `amount`.
572      */
573     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
574         _transfer(_msgSender(), recipient, amount);
575         return true;
576     }
577 
578     /**
579      * @dev See {IERC20-allowance}.
580      */
581     function allowance(address owner, address spender) public view virtual override returns (uint256) {
582         return _allowances[owner][spender];
583     }
584 
585     /**
586      * @dev See {IERC20-approve}.
587      *
588      * Requirements:
589      *
590      * - `spender` cannot be the zero address.approve(address spender, uint256 amount)
591      */
592     function approve(address spender, uint256 amount) public virtual override returns (bool) {
593         _approve(_msgSender(), spender, amount);
594         return true;
595     }
596 
597     /**
598      * @dev See {IERC20-transferFrom}.
599      *
600      * Emits an {Approval} event indicating the updated allowance. This is not
601      * required by the EIP. See the note at the beginning of {ERC20};
602      *
603      * Requirements:
604      * - `sender` and `recipient` cannot be the zero address.
605      * - `sender` must have a balance of at least `amount`.
606      * - the caller must have allowance for `sender`'s tokens of at least
607      * `amount`.
608      */
609     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
610         _transfer(sender, recipient, amount);
611         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
612         return true;
613     }
614 
615     /**
616      * @dev Atomically increases the allowance granted to `spender` by the caller.
617      *
618      * This is an alternative to {approve} that can be used as a mitigation for
619      * problems described in {IERC20-approve}.
620      *
621      * Emits an {Approval} event indicating the updated allowance.
622      *
623      * Requirements:
624      *
625      * - `spender` cannot be the zero address.
626      */
627     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
628         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
629         return true;
630     }
631 
632     /**
633      * @dev Atomically decreases the allowance granted to `spender` by the caller.
634      *
635      * This is an alternative to {approve} that can be used as a mitigation for
636      * problems described in {IERC20-approve}.
637      *
638      * Emits an {Approval} event indicating the updated allowance.
639      *
640      * Requirements:
641      *
642      * - `spender` cannot be the zero address.
643      * - `spender` must have allowance for the caller of at least
644      * `subtractedValue`.
645      */
646     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
647         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
648         return true;
649     }
650 
651     /**
652      * @dev Moves tokens `amount` from `sender` to `recipient`.
653      *
654      * This is internal function is equivalent to {transfer}, and can be used to
655      * e.g. implement automatic token fees, slashing mechanisms, etc.
656      *
657      * Emits a {Transfer} event.
658      *
659      * Requirements:
660      *
661      * - `sender` cannot be the zero address.
662      * - `recipient` cannot be the zero address.
663      * - `sender` must have a balance of at least `amount`.
664      */
665     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
666         require(sender != address(0), "ERC20: transfer from the zero address");
667         require(recipient != address(0), "ERC20: transfer to the zero address");
668 
669         _beforeTokenTransfer(sender, recipient, amount);
670 
671         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
672         _balances[recipient] = _balances[recipient].add(amount);
673         emit Transfer(sender, recipient, amount);
674     }
675 
676     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
677      * the total supply.
678      *
679      * Emits a {Transfer} event with `from` set to the zero address.
680      *
681      * Requirements
682      *
683      * - `to` cannot be the zero address.
684      */
685     function _mint(address account, uint256 amount) internal virtual {
686         require(account != address(0), "ERC20: mint to the zero address");
687 
688         _beforeTokenTransfer(address(0), account, amount);
689 
690         _totalSupply = _totalSupply.add(amount);
691         _balances[account] = _balances[account].add(amount);
692         emit Transfer(address(0), account, amount);
693     }
694 
695     /**
696      * @dev Destroys `amount` tokens from the caller.
697      *
698      * See {ERC20-_burn}.
699      */
700     function burn(uint256 amount) public virtual {
701         _burn(_msgSender(), amount);
702     }
703 
704     /**
705      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
706      * allowance.
707      *
708      * See {ERC20-_burn} and {ERC20-allowance}.
709      *
710      * Requirements:
711      *
712      * - the caller must have allowance for `accounts`'s tokens of at least
713      * `amount`.
714      */
715     function burnFrom(address account, uint256 amount) public virtual {
716         uint256 decreasedAllowance = allowance(account, _msgSender()).sub(amount, "ERC20: burn amount exceeds allowance");
717 
718         _approve(account, _msgSender(), decreasedAllowance);
719         _burn(account, amount);
720     }
721 
722 
723     /**
724      * @dev Destroys `amount` tokens from `account`, reducing the
725      * total supply.
726      *
727      * Emits a {Transfer} event with `to` set to the zero address.
728      *
729      * Requirements
730      *
731      * - `account` cannot be the zero address.
732      * - `account` must have at least `amount` tokens.
733      */
734     function _burn(address account, uint256 amount) internal virtual {
735         require(account != address(0), "ERC20: burn from the zero address");
736 
737         _beforeTokenTransfer(account, address(0), amount);
738 
739         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
740         _totalSupply = _totalSupply.sub(amount);
741         emit Transfer(account, address(0), amount);
742     }
743 
744     /**
745      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
746      *
747      * This is internal function is equivalent to `approve`, and can be used to
748      * e.g. set automatic allowances for certain subsystems, etc.
749      *
750      * Emits an {Approval} event.
751      *
752      * Requirements:
753      *
754      * - `owner` cannot be the zero address.
755      * - `spender` cannot be the zero address.
756      */
757     function _approve(address owner, address spender, uint256 amount) internal virtual {
758         require(owner != address(0), "ERC20: approve from the zero address");
759         require(spender != address(0), "ERC20: approve to the zero address");
760 
761         _allowances[owner][spender] = amount;
762         emit Approval(owner, spender, amount);
763     }
764 
765     /**
766      * @dev Destroys `amount` tokens from `account`.`amount` is then deducted
767      * from the caller's allowance.
768      *
769      * See {_burn} and {_approve}.
770      */
771     function _burnFrom(address account, uint256 amount) internal virtual {
772         _burn(account, amount);
773         _approve(account, _msgSender(), _allowances[account][_msgSender()].sub(amount, "ERC20: burn amount exceeds allowance"));
774     }
775 
776     /**
777      * @dev Hook that is called before any transfer of tokens. This includes
778      * minting and burning.
779      *
780      * Calling conditions:
781      *
782      * - when `from` and `to` are both non-zero, `amount` of `from`'s tokens
783      * will be to transferred to `to`.
784      * - when `from` is zero, `amount` tokens will be minted for `to`.
785      * - when `to` is zero, `amount` of `from`'s tokens will be burned.
786      * - `from` and `to` are never both zero.
787      *
788      * To learn more about hooks, head to xref:ROOT:using-hooks.adoc[Using Hooks].
789      */
790     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
791 }
792 
793 
794 // File contracts/ERC20/SafeERC20.sol
795 
796 
797 
798 
799 /**
800  * @title SafeERC20
801  * @dev Wrappers around ERC20 operations that throw on failure (when the token
802  * contract returns false). Tokens that return no value (and instead revert or
803  * throw on failure) are also supported, non-reverting calls are assumed to be
804  * successful.
805  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
806  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
807  */
808 library SafeERC20 {
809     using SafeMath for uint256;
810     using Address for address;
811 
812     function safeTransfer(IERC20 token, address to, uint256 value) internal {
813         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
814     }
815 
816     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
817         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
818     }
819 
820     /**
821      * @dev Deprecated. This function has issues similar to the ones found in
822      * {IERC20-approve}, and its usage is discouraged.
823      *
824      * Whenever possible, use {safeIncreaseAllowance} and
825      * {safeDecreaseAllowance} instead.
826      */
827     function safeApprove(IERC20 token, address spender, uint256 value) internal {
828         // safeApprove should only be called when setting an initial allowance,
829         // or when resetting it to zero. To increase and decrease it, use
830         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
831         // solhint-disable-next-line max-line-length
832         require((value == 0) || (token.allowance(address(this), spender) == 0),
833             "SafeERC20: approve from non-zero to non-zero allowance"
834         );
835         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
836     }
837 
838     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
839         uint256 newAllowance = token.allowance(address(this), spender).add(value);
840         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
841     }
842 
843     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
844         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
845         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
846     }
847 
848     /**
849      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
850      * on the return value: the return value is optional (but if data is returned, it must not be false).
851      * @param token The token targeted by the call.
852      * @param data The call data (encoded using abi.encode or one of its variants).
853      */
854     function _callOptionalReturn(IERC20 token, bytes memory data) private {
855         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
856         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
857         // the target address contains contract code and also asserts for success in the low-level call.
858 
859         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
860         if (returndata.length > 0) { // Return data is optional
861             // solhint-disable-next-line max-line-length
862             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
863         }
864     }
865 }
866 
867 
868 // File contracts/Curve/IveFPIS.sol
869 
870 pragma abicoder v2;
871 
872 interface IveFPIS {
873 
874     struct Point {
875         int128 bias;
876         int128 slope;
877         uint256 ts;
878         uint256 blk;
879         uint256 fpis_amt;
880     }
881 
882     struct LockedBalance {
883         int128 amount;
884         uint256 end;
885     }
886 
887   function commit_transfer_ownership ( address addr ) external;
888   function apply_transfer_ownership (  ) external;
889   function commit_smart_wallet_checker ( address addr ) external;
890   function apply_smart_wallet_checker (  ) external;
891   function recoverERC20 ( address token_addr, uint256 amount ) external;
892   function get_last_user_slope ( address addr ) external view returns ( int128 );
893   function get_last_user_bias ( address addr ) external view returns ( int128 );
894   function get_last_user_point ( address addr ) external view returns ( Point memory);
895   function user_point_history__ts ( address _addr, uint256 _idx ) external view returns ( uint256 );
896   function get_last_point (  ) external view returns ( Point memory);
897   function locked__end ( address _addr ) external view returns ( uint256 );
898   function locked__amount ( address _addr ) external view returns ( int128 );
899   function curr_period_start (  ) external view returns ( uint256 );
900   function next_period_start (  ) external view returns ( uint256 );
901   function checkpoint (  ) external;
902   function create_lock ( uint256 _value, uint256 _unlock_time ) external;
903   function increase_amount ( uint256 _value ) external;
904   function app_increase_amount_for ( address _staker_addr, address _app_addr, uint256 _value ) external;
905   function increase_unlock_time ( uint256 _unlock_time ) external;
906   function proxy_add ( address _staker_addr, uint256 _add_amt ) external;
907   function proxy_slash ( address _staker_addr, uint256 _slash_amt ) external;
908   function withdraw (  ) external;
909   function transfer_from_app ( address _staker_addr, address _app_addr, int128 _transfer_amt ) external;
910   function transfer_to_app ( address _staker_addr, address _app_addr, int128 _transfer_amt ) external;
911   function balanceOf ( address addr ) external view returns ( uint256 );
912   function balanceOf ( address addr, uint256 _t ) external view returns ( uint256 );
913   function balanceOfAt ( address addr, uint256 _block ) external view returns ( uint256 );
914   function totalSupply (  ) external view returns ( uint256 );
915   function totalSupply ( uint256 t ) external view returns ( uint256 );
916   function totalSupplyAt ( uint256 _block ) external view returns ( uint256 );
917   function totalFPISSupply (  ) external view returns ( uint256 );
918   function totalFPISSupplyAt ( uint256 _block ) external view returns ( uint256 );
919   function toggleEmergencyUnlock (  ) external;
920   function toggleAppIncreaseAmountFors (  ) external;
921   function toggleTransferFromApp (  ) external;
922   function toggleTransferToApp (  ) external;
923   function toggleProxyAdds (  ) external;
924   function toggleProxySlashes (  ) external;
925   function adminSetProxy ( address _proxy ) external;
926   function adminToggleHistoricalProxy ( address _proxy ) external;
927   function stakerSetProxy ( address _proxy ) external;
928   function token (  ) external view returns ( address );
929   function supply (  ) external view returns ( uint256 );
930   function locked ( address arg0 ) external view returns ( LockedBalance memory );
931   function epoch (  ) external view returns ( uint256 );
932   function point_history ( uint256 arg0 ) external view returns ( Point memory );
933   function user_point_history ( address arg0, uint256 arg1 ) external view returns ( Point memory );
934   function user_point_epoch ( address arg0 ) external view returns ( uint256 );
935   function slope_changes ( uint256 arg0 ) external view returns ( int128 );
936   function appIncreaseAmountForsEnabled (  ) external view returns ( bool );
937   function appTransferFromsEnabled (  ) external view returns ( bool );
938   function appTransferTosEnabled (  ) external view returns ( bool );
939   function proxyAddsEnabled (  ) external view returns ( bool );
940   function proxySlashesEnabled (  ) external view returns ( bool );
941   function emergencyUnlockActive (  ) external view returns ( bool );
942   function current_proxy (  ) external view returns ( address );
943   function historical_proxies ( address arg0 ) external view returns ( bool );
944   function staker_whitelisted_proxy ( address arg0 ) external view returns ( address );
945   function user_proxy_balance ( address arg0 ) external view returns ( uint256 );
946   function name (  ) external view returns ( string memory);
947   function symbol (  ) external view returns ( string memory);
948   function version (  ) external view returns ( string memory);
949   function decimals (  ) external view returns ( uint256 );
950   function future_smart_wallet_checker (  ) external view returns ( address );
951   function smart_wallet_checker (  ) external view returns ( address );
952   function admin (  ) external view returns ( address );
953   function future_admin (  ) external view returns ( address );
954 }
955 
956 
957 // File contracts/Math/Math.sol
958 
959 
960 /**
961  * @dev Standard math utilities missing in the Solidity language.
962  */
963 library Math {
964     /**
965      * @dev Returns the largest of two numbers.
966      */
967     function max(uint256 a, uint256 b) internal pure returns (uint256) {
968         return a >= b ? a : b;
969     }
970 
971     /**
972      * @dev Returns the smallest of two numbers.
973      */
974     function min(uint256 a, uint256 b) internal pure returns (uint256) {
975         return a < b ? a : b;
976     }
977 
978     /**
979      * @dev Returns the average of two numbers. The result is rounded towards
980      * zero.
981      */
982     function average(uint256 a, uint256 b) internal pure returns (uint256) {
983         // (a + b) / 2 can overflow, so we distribute
984         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
985     }
986 
987     // babylonian method (https://en.wikipedia.org/wiki/Methods_of_computing_square_roots#Babylonian_method)
988     function sqrt(uint y) internal pure returns (uint z) {
989         if (y > 3) {
990             z = y;
991             uint x = y / 2 + 1;
992             while (x < z) {
993                 z = x;
994                 x = (y / x + x) / 2;
995             }
996         } else if (y != 0) {
997             z = 1;
998         }
999     }
1000 }
1001 
1002 
1003 // File contracts/Staking/Owned.sol
1004 
1005 
1006 // https://docs.synthetix.io/contracts/Owned
1007 contract Owned {
1008     address public owner;
1009     address public nominatedOwner;
1010 
1011     constructor (address _owner) public {
1012         require(_owner != address(0), "Owner address cannot be 0");
1013         owner = _owner;
1014         emit OwnerChanged(address(0), _owner);
1015     }
1016 
1017     function nominateNewOwner(address _owner) external onlyOwner {
1018         nominatedOwner = _owner;
1019         emit OwnerNominated(_owner);
1020     }
1021 
1022     function acceptOwnership() external {
1023         require(msg.sender == nominatedOwner, "You must be nominated before you can accept ownership");
1024         emit OwnerChanged(owner, nominatedOwner);
1025         owner = nominatedOwner;
1026         nominatedOwner = address(0);
1027     }
1028 
1029     modifier onlyOwner {
1030         require(msg.sender == owner, "Only the contract owner may perform this action");
1031         _;
1032     }
1033 
1034     event OwnerNominated(address newOwner);
1035     event OwnerChanged(address oldOwner, address newOwner);
1036 }
1037 
1038 
1039 // File contracts/Uniswap/TransferHelper.sol
1040 
1041 
1042 // helper methods for interacting with ERC20 tokens and sending ETH that do not consistently return true/false
1043 library TransferHelper {
1044     function safeApprove(address token, address to, uint value) internal {
1045         // bytes4(keccak256(bytes('approve(address,uint256)')));
1046         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x095ea7b3, to, value));
1047         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: APPROVE_FAILED');
1048     }
1049 
1050     function safeTransfer(address token, address to, uint value) internal {
1051         // bytes4(keccak256(bytes('transfer(address,uint256)')));
1052         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0xa9059cbb, to, value));
1053         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FAILED');
1054     }
1055 
1056     function safeTransferFrom(address token, address from, address to, uint value) internal {
1057         // bytes4(keccak256(bytes('transferFrom(address,address,uint256)')));
1058         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x23b872dd, from, to, value));
1059         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FROM_FAILED');
1060     }
1061 
1062     function safeTransferETH(address to, uint value) internal {
1063         (bool success,) = to.call{value:value}(new bytes(0));
1064         require(success, 'TransferHelper: ETH_TRANSFER_FAILED');
1065     }
1066 }
1067 
1068 
1069 // File contracts/Utils/ReentrancyGuard.sol
1070 
1071 
1072 /**
1073  * @dev Contract module that helps prevent reentrant calls to a function.
1074  *
1075  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1076  * available, which can be applied to functions to make sure there are no nested
1077  * (reentrant) calls to them.
1078  *
1079  * Note that because there is a single `nonReentrant` guard, functions marked as
1080  * `nonReentrant` may not call one another. This can be worked around by making
1081  * those functions `private`, and then adding `external` `nonReentrant` entry
1082  * points to them.
1083  *
1084  * TIP: If you would like to learn more about reentrancy and alternative ways
1085  * to protect against it, check out our blog post
1086  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1087  */
1088 abstract contract ReentrancyGuard {
1089     // Booleans are more expensive than uint256 or any type that takes up a full
1090     // word because each write operation emits an extra SLOAD to first read the
1091     // slot's contents, replace the bits taken up by the boolean, and then write
1092     // back. This is the compiler's defense against contract upgrades and
1093     // pointer aliasing, and it cannot be disabled.
1094 
1095     // The values being non-zero value makes deployment a bit more expensive,
1096     // but in exchange the refund on every call to nonReentrant will be lower in
1097     // amount. Since refunds are capped to a percentage of the total
1098     // transaction's gas, it is best to keep them low in cases like this one, to
1099     // increase the likelihood of the full refund coming into effect.
1100     uint256 private constant _NOT_ENTERED = 1;
1101     uint256 private constant _ENTERED = 2;
1102 
1103     uint256 private _status;
1104 
1105     constructor () internal {
1106         _status = _NOT_ENTERED;
1107     }
1108 
1109     /**
1110      * @dev Prevents a contract from calling itself, directly or indirectly.
1111      * Calling a `nonReentrant` function from another `nonReentrant`
1112      * function is not supported. It is possible to prevent this from happening
1113      * by making the `nonReentrant` function external, and make it call a
1114      * `private` function that does the actual work.
1115      */
1116     modifier nonReentrant() {
1117         // On the first call to nonReentrant, _notEntered will be true
1118         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1119 
1120         // Any calls to nonReentrant after this point will fail
1121         _status = _ENTERED;
1122 
1123         _;
1124 
1125         // By storing the original value once again, a refund is triggered (see
1126         // https://eips.ethereum.org/EIPS/eip-2200)
1127         _status = _NOT_ENTERED;
1128     }
1129 }
1130 
1131 
1132 // File contracts/Staking/veFPISYieldDistributorV5.sol
1133 
1134 
1135 // ====================================================================
1136 // |     ______                   _______                             |
1137 // |    / _____________ __  __   / ____(_____  ____ _____  ________   |
1138 // |   / /_  / ___/ __ `| |/_/  / /_  / / __ \/ __ `/ __ \/ ___/ _ \  |
1139 // |  / __/ / /  / /_/ _>  <   / __/ / / / / / /_/ / / / / /__/  __/  |
1140 // | /_/   /_/   \__,_/_/|_|  /_/   /_/_/ /_/\__,_/_/ /_/\___/\___/   |
1141 // |                                                                  |
1142 // ====================================================================
1143 // ======================veFPISYieldDistributorV5=======================
1144 // ====================================================================
1145 // Distributes Frax protocol yield based on the claimer's veFPIS balance
1146 // V3: Yield will now not accrue for unlocked veFPIS
1147 
1148 // Frax Finance: https://github.com/FraxFinance
1149 
1150 // Primary Author(s)
1151 // Travis Moore: https://github.com/FortisFortuna
1152 
1153 // Reviewer(s) / Contributor(s)
1154 // Jason Huan: https://github.com/jasonhuan
1155 // Sam Kazemian: https://github.com/samkazemian
1156 // Dennis: https://github.com/denett
1157 
1158 // Originally inspired by Synthetix.io, but heavily modified by the Frax team (veFPIS portion)
1159 // https://github.com/Synthetixio/synthetix/blob/develop/contracts/StakingRewards.sol
1160 
1161 
1162 
1163 
1164 
1165 
1166 
1167 
1168 contract veFPISYieldDistributorV5 is Owned, ReentrancyGuard {
1169     using SafeMath for uint256;
1170     using SafeERC20 for ERC20;
1171 
1172     /* ========== STATE VARIABLES ========== */
1173 
1174     // Instances
1175     IveFPIS private veFPIS;
1176     ERC20 public emittedToken;
1177 
1178     // Addresses
1179     address public emitted_token_address;
1180 
1181     // Admin addresses
1182     address public timelock_address;
1183 
1184     // Constant for price precision
1185     uint256 private constant PRICE_PRECISION = 1e6;
1186 
1187     // Yield and period related
1188     uint256 public periodFinish;
1189     uint256 public lastUpdateTime;
1190     uint256 public yieldRate;
1191     uint256 public yieldDuration = 604800; // 7 * 86400  (7 days)
1192     mapping(address => bool) public reward_notifiers;
1193 
1194     // Yield tracking
1195     uint256 public yieldPerVeFPISStored = 0;
1196     mapping(address => uint256) public userYieldPerTokenPaid;
1197     mapping(address => uint256) public yields;
1198 
1199     // veFPIS tracking
1200     uint256 public totalVeFPISParticipating = 0;
1201     uint256 public totalVeFPISSupplyStored = 0;
1202     mapping(address => bool) public userIsInitialized;
1203     mapping(address => uint256) public userVeFPISCheckpointed;
1204     mapping(address => uint256) public userVeFPISEndpointCheckpointed;
1205     mapping(address => uint256) private lastRewardClaimTime; // staker addr -> timestamp
1206 
1207     // Greylists
1208     mapping(address => bool) public greylist;
1209 
1210     // Admin booleans for emergencies
1211     bool public yieldCollectionPaused = false; // For emergencies
1212 
1213     struct LockedBalance {
1214         int128 amount;
1215         uint256 end;
1216     }
1217 
1218     /* ========== MODIFIERS ========== */
1219 
1220     modifier onlyByOwnGov() {
1221         require( msg.sender == owner || msg.sender == timelock_address, "Not owner or timelock");
1222         _;
1223     }
1224 
1225     modifier notYieldCollectionPaused() {
1226         require(yieldCollectionPaused == false, "Yield collection is paused");
1227         _;
1228     }
1229 
1230     modifier checkpointUser(address account) {
1231         _checkpointUser(account);
1232         _;
1233     }
1234 
1235     /* ========== CONSTRUCTOR ========== */
1236 
1237     constructor (
1238         address _owner,
1239         address _emittedToken,
1240         address _timelock_address,
1241         address _veFPIS_address
1242     ) Owned(_owner) {
1243         emitted_token_address = _emittedToken;
1244         emittedToken = ERC20(_emittedToken);
1245 
1246         veFPIS = IveFPIS(_veFPIS_address);
1247         lastUpdateTime = block.timestamp;
1248         timelock_address = _timelock_address;
1249 
1250         reward_notifiers[_owner] = true;
1251     }
1252 
1253     /* ========== VIEWS ========== */
1254 
1255     function fractionParticipating() external view returns (uint256) {
1256         return totalVeFPISParticipating.mul(PRICE_PRECISION).div(totalVeFPISSupplyStored);
1257     }
1258 
1259     // Only positions with locked veFPIS can accrue yield. Otherwise, expired-locked veFPIS
1260     // is de-facto rewards for FPIS.
1261     function eligibleCurrentVeFPIS(address account) public view returns (uint256 eligible_vefpis_bal, uint256 stored_ending_timestamp) {
1262         uint256 curr_vefpis_bal = veFPIS.balanceOf(account);
1263         
1264         // Stored is used to prevent abuse
1265         stored_ending_timestamp = userVeFPISEndpointCheckpointed[account];
1266 
1267         // Only unexpired veFPIS should be eligible
1268         if (stored_ending_timestamp != 0 && (block.timestamp >= stored_ending_timestamp)){
1269             eligible_vefpis_bal = 0;
1270         }
1271         else if (block.timestamp >= stored_ending_timestamp){
1272             eligible_vefpis_bal = 0;
1273         }
1274         else {
1275             eligible_vefpis_bal = curr_vefpis_bal;
1276         }
1277     }
1278 
1279     function lastTimeYieldApplicable() public view returns (uint256) {
1280         return Math.min(block.timestamp, periodFinish);
1281     }
1282 
1283     function yieldPerVeFPIS() public view returns (uint256) {
1284         if (totalVeFPISSupplyStored == 0) {
1285             return yieldPerVeFPISStored;
1286         } else {
1287             return (
1288                 yieldPerVeFPISStored.add(
1289                     lastTimeYieldApplicable()
1290                         .sub(lastUpdateTime)
1291                         .mul(yieldRate)
1292                         .mul(1e18)
1293                         .div(totalVeFPISSupplyStored)
1294                 )
1295             );
1296         }
1297     }
1298 
1299     function earned(address account) public view returns (uint256) {
1300         // Uninitialized users should not earn anything yet
1301         if (!userIsInitialized[account]) return 0;
1302 
1303         // Get eligible veFPIS balances
1304         (uint256 eligible_current_vefpis, uint256 ending_timestamp) = eligibleCurrentVeFPIS(account);
1305 
1306         // If your veFPIS is unlocked
1307         uint256 eligible_time_fraction = PRICE_PRECISION;
1308         if (eligible_current_vefpis == 0){
1309             // And you already claimed after expiration
1310             if (lastRewardClaimTime[account] >= ending_timestamp) {
1311                 // You get NOTHING. You LOSE. Good DAY ser!
1312                 return 0;
1313             }
1314             // You haven't claimed yet
1315             else {
1316                 // Slow rewards decay
1317                 uint256 eligible_time = (ending_timestamp).sub(lastRewardClaimTime[account]);
1318                 uint256 total_time = (block.timestamp).sub(lastRewardClaimTime[account]);
1319                 eligible_time_fraction = PRICE_PRECISION.mul(eligible_time).div(total_time);
1320             }
1321         }
1322 
1323         // If the amount of veFPIS increased, only pay off based on the old balance to prevent people from staking little,
1324         // waiting, staking a lot, then claiming.
1325         // Otherwise, take the midpoint
1326         uint256 vefpis_balance_to_use;
1327         {
1328             uint256 old_vefpis_balance = userVeFPISCheckpointed[account];
1329             if (eligible_current_vefpis > old_vefpis_balance){
1330                 vefpis_balance_to_use = old_vefpis_balance;
1331             }
1332             else if (eligible_current_vefpis == 0) {
1333                 // Will get multiplied by eligible_time_fraction anyways.
1334                 vefpis_balance_to_use = old_vefpis_balance.add(uint256(uint128(veFPIS.locked(account).amount))).div(2);
1335             }
1336             else {
1337                 // Average the two veFPIS balances
1338                 vefpis_balance_to_use = ((eligible_current_vefpis).add(old_vefpis_balance)).div(2); 
1339             }
1340         }
1341 
1342         return (
1343             vefpis_balance_to_use
1344                 .mul(yieldPerVeFPIS().sub(userYieldPerTokenPaid[account]))
1345                 .mul(eligible_time_fraction)
1346                 .div(1e18 * PRICE_PRECISION)
1347                 .add(yields[account])
1348         );
1349     }
1350 
1351     function getYieldForDuration() external view returns (uint256) {
1352         return (yieldRate.mul(yieldDuration));
1353     }
1354 
1355     /* ========== MUTATIVE FUNCTIONS ========== */
1356 
1357     function _checkpointUser(address account) internal {
1358         // Need to retro-adjust some things if the period hasn't been renewed, then start a new one
1359         sync();
1360 
1361         // Calculate the earnings first
1362         _syncEarned(account);
1363 
1364         // Get the old and the new veFPIS balances
1365         uint256 old_vefpis_balance = userVeFPISCheckpointed[account];
1366         uint256 new_vefpis_balance = veFPIS.balanceOf(account);
1367 
1368         // Update the user's stored veFPIS balance
1369         userVeFPISCheckpointed[account] = new_vefpis_balance;
1370 
1371         // Update the user's stored ending timestamp
1372         IveFPIS.LockedBalance memory curr_locked_bal_pack = veFPIS.locked(account);
1373         userVeFPISEndpointCheckpointed[account] = curr_locked_bal_pack.end;
1374 
1375         // Update the total amount participating
1376         if (new_vefpis_balance >= old_vefpis_balance) {
1377             uint256 weight_diff = new_vefpis_balance.sub(old_vefpis_balance);
1378             totalVeFPISParticipating = totalVeFPISParticipating.add(weight_diff);
1379         } else {
1380             uint256 weight_diff = old_vefpis_balance.sub(new_vefpis_balance);
1381             totalVeFPISParticipating = totalVeFPISParticipating.sub(weight_diff);
1382         }
1383 
1384         // Mark the user as initialized
1385         if (!userIsInitialized[account]) {
1386             userIsInitialized[account] = true;
1387             lastRewardClaimTime[account] = block.timestamp;
1388         }
1389     }
1390 
1391     function _syncEarned(address account) internal {
1392         if (account != address(0)) {
1393             uint256 earned0 = earned(account);
1394             yields[account] = earned0;
1395             userYieldPerTokenPaid[account] = yieldPerVeFPISStored;
1396         }
1397     }
1398 
1399     // Anyone can checkpoint another user
1400     function checkpointOtherUser(address user_addr) external {
1401         _checkpointUser(user_addr);
1402     }
1403 
1404     // Checkpoints the user
1405     function checkpoint() external {
1406         _checkpointUser(msg.sender);
1407     }
1408 
1409     function getYield() external nonReentrant notYieldCollectionPaused checkpointUser(msg.sender) returns (uint256 yield0) {
1410         require(greylist[msg.sender] == false, "Address has been greylisted");
1411 
1412         yield0 = yields[msg.sender];
1413         if (yield0 > 0) {
1414             yields[msg.sender] = 0;
1415             TransferHelper.safeTransfer(
1416                 emitted_token_address,
1417                 msg.sender,
1418                 yield0
1419             );
1420             emit YieldCollected(msg.sender, yield0, emitted_token_address);
1421         }
1422 
1423         lastRewardClaimTime[msg.sender] = block.timestamp;
1424     }
1425 
1426 
1427     function sync() public {
1428         // Update the total veFPIS supply
1429         yieldPerVeFPISStored = yieldPerVeFPIS();
1430         totalVeFPISSupplyStored = veFPIS.totalSupply();
1431         lastUpdateTime = lastTimeYieldApplicable();
1432     }
1433 
1434     function notifyRewardAmount(uint256 amount) external {
1435         // Only whitelisted addresses can notify rewards
1436         require(reward_notifiers[msg.sender], "Sender not whitelisted");
1437 
1438         // Handle the transfer of emission tokens via `transferFrom` to reduce the number
1439         // of transactions required and ensure correctness of the smission amount
1440         emittedToken.safeTransferFrom(msg.sender, address(this), amount);
1441 
1442         // Update some values beforehand
1443         sync();
1444 
1445         // Update the new yieldRate
1446         if (block.timestamp >= periodFinish) {
1447             yieldRate = amount.div(yieldDuration);
1448         } else {
1449             uint256 remaining = periodFinish.sub(block.timestamp);
1450             uint256 leftover = remaining.mul(yieldRate);
1451             yieldRate = amount.add(leftover).div(yieldDuration);
1452         }
1453         
1454         // Update duration-related info
1455         lastUpdateTime = block.timestamp;
1456         periodFinish = block.timestamp.add(yieldDuration);
1457 
1458         emit RewardAdded(amount, yieldRate);
1459     }
1460 
1461     /* ========== RESTRICTED FUNCTIONS ========== */
1462 
1463     // Added to support recovering LP Yield and other mistaken tokens from other systems to be distributed to holders
1464     function recoverERC20(address tokenAddress, uint256 tokenAmount) external onlyByOwnGov {
1465         // Only the owner address can ever receive the recovery withdrawal
1466         TransferHelper.safeTransfer(tokenAddress, owner, tokenAmount);
1467         emit RecoveredERC20(tokenAddress, tokenAmount);
1468     }
1469 
1470     function setYieldDuration(uint256 _yieldDuration) external onlyByOwnGov {
1471         require( periodFinish == 0 || block.timestamp > periodFinish, "Previous yield period must be complete before changing the duration for the new period");
1472         yieldDuration = _yieldDuration;
1473         emit YieldDurationUpdated(yieldDuration);
1474     }
1475 
1476     function greylistAddress(address _address) external onlyByOwnGov {
1477         greylist[_address] = !(greylist[_address]);
1478     }
1479 
1480     function toggleRewardNotifier(address notifier_addr) external onlyByOwnGov {
1481         reward_notifiers[notifier_addr] = !reward_notifiers[notifier_addr];
1482     }
1483 
1484     function setPauses(bool _yieldCollectionPaused) external onlyByOwnGov {
1485         yieldCollectionPaused = _yieldCollectionPaused;
1486     }
1487 
1488     function setYieldRate(uint256 _new_rate0, bool sync_too) external onlyByOwnGov {
1489         yieldRate = _new_rate0;
1490 
1491         if (sync_too) {
1492             sync();
1493         }
1494     }
1495 
1496     function setTimelock(address _new_timelock) external onlyByOwnGov {
1497         timelock_address = _new_timelock;
1498     }
1499 
1500     /* ========== EVENTS ========== */
1501 
1502     event RewardAdded(uint256 reward, uint256 yieldRate);
1503     event OldYieldCollected(address indexed user, uint256 yield, address token_address);
1504     event YieldCollected(address indexed user, uint256 yield, address token_address);
1505     event YieldDurationUpdated(uint256 newDuration);
1506     event RecoveredERC20(address token, uint256 amount);
1507     event YieldPeriodRenewed(address token, uint256 yieldRate);
1508     event DefaultInitialization();
1509 
1510     /* ========== A CHICKEN ========== */
1511     //
1512     //         ,~.
1513     //      ,-'__ `-,
1514     //     {,-'  `. }              ,')
1515     //    ,( a )   `-.__         ,',')~,
1516     //   <=.) (         `-.__,==' ' ' '}
1517     //     (   )                      /)
1518     //      `-'\   ,                    )
1519     //          |  \        `~.        /
1520     //          \   `._        \      /
1521     //           \     `._____,'    ,'
1522     //            `-.             ,'
1523     //               `-._     _,-'
1524     //                   77jj'
1525     //                  //_||
1526     //               __//--'/`
1527     //             ,--'/`  '
1528     //
1529     // [hjw] https://textart.io/art/vw6Sa3iwqIRGkZsN1BC2vweF/chicken
1530 }