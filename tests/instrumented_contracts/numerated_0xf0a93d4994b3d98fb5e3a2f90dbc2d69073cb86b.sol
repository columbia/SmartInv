1 // SPDX-License-Identifier: AGPLv3
2 // File: @openzeppelin/contracts/GSN/Context.sol
3 
4 
5 pragma solidity >=0.6.0 <0.8.0;
6 
7 /*
8  * @dev Provides information about the current execution context, including the
9  * sender of the transaction and its data. While these are generally available
10  * via msg.sender and msg.data, they should not be accessed in such a direct
11  * manner, since when dealing with GSN meta-transactions the account sending and
12  * paying for execution may not be the actual sender (as far as an application
13  * is concerned).
14  *
15  * This contract is only required for intermediate, library-like contracts.
16  */
17 abstract contract Context {
18     function _msgSender() internal view virtual returns (address payable) {
19         return msg.sender;
20     }
21 
22     function _msgData() internal view virtual returns (bytes memory) {
23         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
24         return msg.data;
25     }
26 }
27 
28 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
29 
30 
31 pragma solidity >=0.6.0 <0.8.0;
32 
33 /**
34  * @dev Interface of the ERC20 standard as defined in the EIP.
35  */
36 interface IERC20 {
37     /**
38      * @dev Returns the amount of tokens in existence.
39      */
40     function totalSupply() external view returns (uint256);
41 
42     /**
43      * @dev Returns the amount of tokens owned by `account`.
44      */
45     function balanceOf(address account) external view returns (uint256);
46 
47     /**
48      * @dev Moves `amount` tokens from the caller's account to `recipient`.
49      *
50      * Returns a boolean value indicating whether the operation succeeded.
51      *
52      * Emits a {Transfer} event.
53      */
54     function transfer(address recipient, uint256 amount) external returns (bool);
55 
56     /**
57      * @dev Returns the remaining number of tokens that `spender` will be
58      * allowed to spend on behalf of `owner` through {transferFrom}. This is
59      * zero by default.
60      *
61      * This value changes when {approve} or {transferFrom} are called.
62      */
63     function allowance(address owner, address spender) external view returns (uint256);
64 
65     /**
66      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
67      *
68      * Returns a boolean value indicating whether the operation succeeded.
69      *
70      * IMPORTANT: Beware that changing an allowance with this method brings the risk
71      * that someone may use both the old and the new allowance by unfortunate
72      * transaction ordering. One possible solution to mitigate this race
73      * condition is to first reduce the spender's allowance to 0 and set the
74      * desired value afterwards:
75      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
76      *
77      * Emits an {Approval} event.
78      */
79     function approve(address spender, uint256 amount) external returns (bool);
80 
81     /**
82      * @dev Moves `amount` tokens from `sender` to `recipient` using the
83      * allowance mechanism. `amount` is then deducted from the caller's
84      * allowance.
85      *
86      * Returns a boolean value indicating whether the operation succeeded.
87      *
88      * Emits a {Transfer} event.
89      */
90     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
91 
92     /**
93      * @dev Emitted when `value` tokens are moved from one account (`from`) to
94      * another (`to`).
95      *
96      * Note that `value` may be zero.
97      */
98     event Transfer(address indexed from, address indexed to, uint256 value);
99 
100     /**
101      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
102      * a call to {approve}. `value` is the new allowance.
103      */
104     event Approval(address indexed owner, address indexed spender, uint256 value);
105 }
106 
107 // File: @openzeppelin/contracts/math/SafeMath.sol
108 
109 
110 pragma solidity >=0.6.0 <0.8.0;
111 
112 /**
113  * @dev Wrappers over Solidity's arithmetic operations with added overflow
114  * checks.
115  *
116  * Arithmetic operations in Solidity wrap on overflow. This can easily result
117  * in bugs, because programmers usually assume that an overflow raises an
118  * error, which is the standard behavior in high level programming languages.
119  * `SafeMath` restores this intuition by reverting the transaction when an
120  * operation overflows.
121  *
122  * Using this library instead of the unchecked operations eliminates an entire
123  * class of bugs, so it's recommended to use it always.
124  */
125 library SafeMath {
126     /**
127      * @dev Returns the addition of two unsigned integers, reverting on
128      * overflow.
129      *
130      * Counterpart to Solidity's `+` operator.
131      *
132      * Requirements:
133      *
134      * - Addition cannot overflow.
135      */
136     function add(uint256 a, uint256 b) internal pure returns (uint256) {
137         uint256 c = a + b;
138         require(c >= a, "SafeMath: addition overflow");
139 
140         return c;
141     }
142 
143     /**
144      * @dev Returns the subtraction of two unsigned integers, reverting on
145      * overflow (when the result is negative).
146      *
147      * Counterpart to Solidity's `-` operator.
148      *
149      * Requirements:
150      *
151      * - Subtraction cannot overflow.
152      */
153     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
154         return sub(a, b, "SafeMath: subtraction overflow");
155     }
156 
157     /**
158      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
159      * overflow (when the result is negative).
160      *
161      * Counterpart to Solidity's `-` operator.
162      *
163      * Requirements:
164      *
165      * - Subtraction cannot overflow.
166      */
167     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
168         require(b <= a, errorMessage);
169         uint256 c = a - b;
170 
171         return c;
172     }
173 
174     /**
175      * @dev Returns the multiplication of two unsigned integers, reverting on
176      * overflow.
177      *
178      * Counterpart to Solidity's `*` operator.
179      *
180      * Requirements:
181      *
182      * - Multiplication cannot overflow.
183      */
184     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
185         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
186         // benefit is lost if 'b' is also tested.
187         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
188         if (a == 0) {
189             return 0;
190         }
191 
192         uint256 c = a * b;
193         require(c / a == b, "SafeMath: multiplication overflow");
194 
195         return c;
196     }
197 
198     /**
199      * @dev Returns the integer division of two unsigned integers. Reverts on
200      * division by zero. The result is rounded towards zero.
201      *
202      * Counterpart to Solidity's `/` operator. Note: this function uses a
203      * `revert` opcode (which leaves remaining gas untouched) while Solidity
204      * uses an invalid opcode to revert (consuming all remaining gas).
205      *
206      * Requirements:
207      *
208      * - The divisor cannot be zero.
209      */
210     function div(uint256 a, uint256 b) internal pure returns (uint256) {
211         return div(a, b, "SafeMath: division by zero");
212     }
213 
214     /**
215      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
216      * division by zero. The result is rounded towards zero.
217      *
218      * Counterpart to Solidity's `/` operator. Note: this function uses a
219      * `revert` opcode (which leaves remaining gas untouched) while Solidity
220      * uses an invalid opcode to revert (consuming all remaining gas).
221      *
222      * Requirements:
223      *
224      * - The divisor cannot be zero.
225      */
226     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
227         require(b > 0, errorMessage);
228         uint256 c = a / b;
229         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
230 
231         return c;
232     }
233 
234     /**
235      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
236      * Reverts when dividing by zero.
237      *
238      * Counterpart to Solidity's `%` operator. This function uses a `revert`
239      * opcode (which leaves remaining gas untouched) while Solidity uses an
240      * invalid opcode to revert (consuming all remaining gas).
241      *
242      * Requirements:
243      *
244      * - The divisor cannot be zero.
245      */
246     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
247         return mod(a, b, "SafeMath: modulo by zero");
248     }
249 
250     /**
251      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
252      * Reverts with custom message when dividing by zero.
253      *
254      * Counterpart to Solidity's `%` operator. This function uses a `revert`
255      * opcode (which leaves remaining gas untouched) while Solidity uses an
256      * invalid opcode to revert (consuming all remaining gas).
257      *
258      * Requirements:
259      *
260      * - The divisor cannot be zero.
261      */
262     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
263         require(b != 0, errorMessage);
264         return a % b;
265     }
266 }
267 
268 // File: @openzeppelin/contracts/utils/Address.sol
269 
270 
271 pragma solidity >=0.6.2 <0.8.0;
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
415     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
416         if (success) {
417             return returndata;
418         } else {
419             // Look for revert reason and bubble it up if present
420             if (returndata.length > 0) {
421                 // The easiest way to bubble the revert reason is using memory via assembly
422 
423                 // solhint-disable-next-line no-inline-assembly
424                 assembly {
425                     let returndata_size := mload(returndata)
426                     revert(add(32, returndata), returndata_size)
427                 }
428             } else {
429                 revert(errorMessage);
430             }
431         }
432     }
433 }
434 
435 // File: contracts/tokens/GERC20.sol
436 
437 pragma solidity >=0.6.0 <0.7.0;
438 
439 
440 
441 
442 
443 /**
444  * @dev Implementation of the {IERC20} interface.
445  *
446  * This implementation is agnostic to the way tokens are created. This means
447  * that a supply mechanism has to be added in a derived contract using {_mint}.
448  * For a generic mechanism see {ERC20MinterPauser}.
449  *
450  * TIP: For a detailed writeup see our guide
451  * https:
452  * to implement supply mechanisms].
453  *
454  * We have followed general OpenZeppelin guidelines: functions revert instead
455  * of returning `false` on failure. This behavior is nonetheless conventional
456  * and does not conflict with the expectations of ERC20 applications.
457  *
458  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
459  * This allows applications to reconstruct the allowance for all accounts just
460  * by listening to said events. Other implementations of the EIP may not emit
461  * these events, as it isn't required by the specification.
462  *
463  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
464  * functions have been added to mitigate the well-known issues around setting
465  * allowances. See {IERC20-approve}.
466  *
467  * ################### GERC20 additions to IERC20 ###################
468  *      _burn: Added paramater - burnAmount added to take rebased amount into account,
469  *          affects the Transfer event
470  *      _mint: Added paramater - mintAmount added to take rebased amount into account,
471  *          affects the Transfer event
472  *      _transfer: Added paramater - transferAmount added to take rebased amount into account,
473  *          affects the Transfer event
474  *      _decreaseApproved: Added function - internal function to allowed override of transferFrom
475  *
476  */
477 abstract contract GERC20 is Context, IERC20 {
478     using SafeMath for uint256;
479     using Address for address;
480 
481     mapping(address => uint256) private _balances;
482 
483     mapping(address => mapping(address => uint256)) private _allowances;
484 
485     uint256 private _totalSupply;
486 
487     string private _name;
488     string private _symbol;
489     uint8 private _decimals;
490 
491     constructor(
492         string memory name,
493         string memory symbol,
494         uint8 decimals
495     ) public {
496         _name = name;
497         _symbol = symbol;
498         _decimals = decimals;
499     }
500 
501     /**
502      * @dev Returns the name of the token.
503      */
504     function name() public view returns (string memory) {
505         return _name;
506     }
507 
508     /**
509      * @dev Returns the symbol of the token, usually a shorter version of the
510      * name.
511      */
512     function symbol() public view returns (string memory) {
513         return _symbol;
514     }
515 
516     /**
517      * @dev Returns the number of decimals used to get its user representation.
518      * For example, if `decimals` equals `2`, a balance of `505` tokens should
519      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
520      *
521      * Tokens usually opt for a value of 18, imitating the relationship between
522      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
523      * called.
524      *
525      * NOTE: This information is only used for _display_ purposes: it in
526      * no way affects any of the arithmetic of the contract, including
527      * {IERC20-balanceOf} and {IERC20-transfer}.
528      */
529     function decimals() public view returns (uint8) {
530         return _decimals;
531     }
532 
533     /**
534      * @dev See {IERC20-totalSupply}.
535      */
536     function totalSupplyBase() public view returns (uint256) {
537         return _totalSupply;
538     }
539 
540     /**
541      * @dev See {IERC20-balanceOf}.
542      */
543     function balanceOfBase(address account) public view returns (uint256) {
544         return _balances[account];
545     }
546 
547     /**
548      * @dev See {IERC20-transfer}.
549      *
550      * Requirements:
551      *
552      * - `recipient` cannot be the zero address.
553      * - the caller must have a balance of at least `amount`.
554      */
555     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
556         _transfer(_msgSender(), recipient, amount, amount);
557         return true;
558     }
559 
560     /**
561      * @dev See {IERC20-allowance}.
562      */
563     function allowance(address owner, address spender) public view override returns (uint256) {
564         return _allowances[owner][spender];
565     }
566 
567     /**
568      * @dev See {IERC20-approve}.
569      *
570      * Requirements:
571      *
572      * - `spender` cannot be the zero address.
573      */
574     function approve(address spender, uint256 amount) public virtual override returns (bool) {
575         _approve(_msgSender(), spender, amount);
576         return true;
577     }
578 
579     /**
580      * @dev See {IERC20-transferFrom}.
581      *
582      * Emits an {Approval} event indicating the updated allowance. This is not
583      * required by the EIP. See the note at the beginning of {ERC20};
584      *
585      * Requirements:
586      * - `sender` and `recipient` cannot be the zero address.
587      * - `sender` must have a balance of at least `amount`.
588      * - the caller must have allowance for ``sender``'s tokens of at least
589      * `amount`.
590      */
591     function transferFrom(
592         address sender,
593         address recipient,
594         uint256 amount
595     ) public virtual override returns (bool) {
596         _transfer(sender, recipient, amount, amount);
597         _approve(
598             sender,
599             _msgSender(),
600             _allowances[sender][_msgSender()].sub(
601                 amount,
602                 "ERC20: transfer amount exceeds allowance"
603             )
604         );
605         return true;
606     }
607 
608     /**
609      * @dev Atomically increases the allowance granted to `spender` by the caller.
610      *
611      * This is an alternative to {approve} that can be used as a mitigation for
612      * problems described in {IERC20-approve}.
613      *
614      * Emits an {Approval} event indicating the updated allowance.
615      *
616      * Requirements:
617      *
618      * - `spender` cannot be the zero address.
619      */
620     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
621         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
622         return true;
623     }
624 
625     /**
626      * @dev Atomically decreases the allowance granted to `spender` by the caller.
627      *
628      * This is an alternative to {approve} that can be used as a mitigation for
629      * problems described in {IERC20-approve}.
630      *
631      * Emits an {Approval} event indicating the updated allowance.
632      *
633      * Requirements:
634      *
635      * - `spender` cannot be the zero address.
636      * - `spender` must have allowance for the caller of at least
637      * `subtractedValue`.
638      */
639     function decreaseAllowance(address spender, uint256 subtractedValue)
640         public
641         virtual
642         returns (bool)
643     {
644         _approve(
645             _msgSender(),
646             spender,
647             _allowances[_msgSender()][spender].sub(
648                 subtractedValue,
649                 "ERC20: decreased allowance below zero"
650             )
651         );
652         return true;
653     }
654 
655     /**
656      * @dev Moves tokens `amount` from `sender` to `recipient`.
657      *      GERC20 addition - transferAmount added to take rebased amount into account
658      * This is internal function is equivalent to {transfer}, and can be used to
659      * e.g. implement automatic token fees, slashing mechanisms, etc.
660      *
661      * Emits a {Transfer} event.
662      *
663      * Requirements:
664      *
665      * - `sender` cannot be the zero address.
666      * - `recipient` cannot be the zero address.
667      * - `sender` must have a balance of at least `amount`.
668      */
669     function _transfer(
670         address sender,
671         address recipient,
672         uint256 transferAmount,
673         uint256 amount
674     ) internal virtual {
675         require(sender != address(0), "ERC20: transfer from the zero address");
676         require(recipient != address(0), "ERC20: transfer to the zero address");
677 
678         _beforeTokenTransfer(sender, recipient, transferAmount);
679 
680         _balances[sender] = _balances[sender].sub(
681             transferAmount,
682             "ERC20: transfer amount exceeds balance"
683         );
684         _balances[recipient] = _balances[recipient].add(transferAmount);
685         emit Transfer(sender, recipient, amount);
686     }
687 
688     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
689      * the total supply.
690      *      GERC20 addition - mintAmount added to take rebased amount into account
691      *
692      * Emits a {Transfer} event with `from` set to the zero address.
693      *
694      * Requirements
695      *
696      * - `to` cannot be the zero address.
697      */
698     function _mint(
699         address account,
700         uint256 mintAmount,
701         uint256 amount
702     ) internal virtual {
703         require(account != address(0), "ERC20: mint to the zero address");
704 
705         _beforeTokenTransfer(address(0), account, mintAmount);
706 
707         _totalSupply = _totalSupply.add(mintAmount);
708         _balances[account] = _balances[account].add(mintAmount);
709         emit Transfer(address(0), account, amount);
710     }
711 
712     /**
713      * @dev Destroys `amount` tokens from `account`, reducing the
714      * total supply.
715      *      GERC20 addition - burnAmount added to take rebased amount into account
716      *
717      * Emits a {Transfer} event with `to` set to the zero address.
718      *
719      * Requirements
720      *
721      * - `account` cannot be the zero address.
722      * - `account` must have at least `amount` tokens.
723      */
724     function _burn(
725         address account,
726         uint256 burnAmount,
727         uint256 amount
728     ) internal virtual {
729         require(account != address(0), "ERC20: burn from the zero address");
730 
731         _beforeTokenTransfer(account, address(0), burnAmount);
732 
733         _balances[account] = _balances[account].sub(
734             burnAmount,
735             "ERC20: burn amount exceeds balance"
736         );
737         _totalSupply = _totalSupply.sub(burnAmount);
738         emit Transfer(account, address(0), amount);
739     }
740 
741     /**
742      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
743      *
744      * This is internal function is equivalent to `approve`, and can be used to
745      * e.g. set automatic allowances for certain subsystems, etc.
746      *
747      * Emits an {Approval} event.
748      *
749      * Requirements:
750      *
751      * - `owner` cannot be the zero address.
752      * - `spender` cannot be the zero address.
753      */
754     function _approve(
755         address owner,
756         address spender,
757         uint256 amount
758     ) internal virtual {
759         require(owner != address(0), "ERC20: approve from the zero address");
760         require(spender != address(0), "ERC20: approve to the zero address");
761 
762         _allowances[owner][spender] = amount;
763         emit Approval(owner, spender, amount);
764     }
765 
766     function _decreaseApproved(
767         address owner,
768         address spender,
769         uint256 amount
770     ) internal virtual {
771         require(owner != address(0), "ERC20: approve from the zero address");
772         require(spender != address(0), "ERC20: approve to the zero address");
773 
774         _allowances[owner][spender] = _allowances[owner][spender].sub(amount);
775         emit Approval(owner, spender, _allowances[owner][spender]);
776     }
777 
778     /**
779      * @dev Sets {decimals} to a value other than the default one of 18.
780      *
781      * WARNING: This function should only be called from the constructor. Most
782      * applications that interact with token contracts will not expect
783      * {decimals} to ever change, and may work incorrectly if it does.
784      */
785     function _setupDecimals(uint8 decimals_) internal {
786         _decimals = decimals_;
787     }
788 
789     /**
790      * @dev Hook that is called before any transfer of tokens. This includes
791      * minting and burning.
792      *
793      * Calling conditions:
794      *
795      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
796      * will be to transferred to `to`.
797      * - when `from` is zero, `amount` tokens will be minted for `to`.
798      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
799      * - `from` and `to` are never both zero.
800      *
801      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
802      */
803     function _beforeTokenTransfer(
804         address from,
805         address to,
806         uint256 amount
807     ) internal virtual {}
808 }
809 
810 // File: contracts/common/DecimalConstants.sol
811 
812 pragma solidity >=0.6.0 <0.7.0;
813 
814 contract DecimalConstants {
815     uint8 public constant DEFAULT_DECIMALS = 18; // GToken and Controller use this decimals
816     uint256 public constant DEFAULT_DECIMALS_FACTOR = uint256(10)**DEFAULT_DECIMALS;
817     uint8 public constant CHAINLINK_PRICE_DECIMALS = 8;
818     uint256 public constant CHAINLINK_PRICE_DECIMAL_FACTOR = uint256(10)**CHAINLINK_PRICE_DECIMALS;
819     uint8 public constant PERCENTAGE_DECIMALS = 4;
820     uint256 public constant PERCENTAGE_DECIMAL_FACTOR = uint256(10)**PERCENTAGE_DECIMALS;
821 }
822 
823 // File: @openzeppelin/contracts/access/Ownable.sol
824 
825 
826 pragma solidity >=0.6.0 <0.8.0;
827 
828 /**
829  * @dev Contract module which provides a basic access control mechanism, where
830  * there is an account (an owner) that can be granted exclusive access to
831  * specific functions.
832  *
833  * By default, the owner account will be the one that deploys the contract. This
834  * can later be changed with {transferOwnership}.
835  *
836  * This module is used through inheritance. It will make available the modifier
837  * `onlyOwner`, which can be applied to your functions to restrict their use to
838  * the owner.
839  */
840 abstract contract Ownable is Context {
841     address private _owner;
842 
843     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
844 
845     /**
846      * @dev Initializes the contract setting the deployer as the initial owner.
847      */
848     constructor () internal {
849         address msgSender = _msgSender();
850         _owner = msgSender;
851         emit OwnershipTransferred(address(0), msgSender);
852     }
853 
854     /**
855      * @dev Returns the address of the current owner.
856      */
857     function owner() public view returns (address) {
858         return _owner;
859     }
860 
861     /**
862      * @dev Throws if called by any account other than the owner.
863      */
864     modifier onlyOwner() {
865         require(_owner == _msgSender(), "Ownable: caller is not the owner");
866         _;
867     }
868 
869     /**
870      * @dev Leaves the contract without owner. It will not be possible to call
871      * `onlyOwner` functions anymore. Can only be called by the current owner.
872      *
873      * NOTE: Renouncing ownership will leave the contract without an owner,
874      * thereby removing any functionality that is only available to the owner.
875      */
876     function renounceOwnership() public virtual onlyOwner {
877         emit OwnershipTransferred(_owner, address(0));
878         _owner = address(0);
879     }
880 
881     /**
882      * @dev Transfers ownership of the contract to a new account (`newOwner`).
883      * Can only be called by the current owner.
884      */
885     function transferOwnership(address newOwner) public virtual onlyOwner {
886         require(newOwner != address(0), "Ownable: new owner is the zero address");
887         emit OwnershipTransferred(_owner, newOwner);
888         _owner = newOwner;
889     }
890 }
891 
892 // File: contracts/common/Whitelist.sol
893 
894 pragma solidity >=0.6.0 <0.7.0;
895 
896 
897 contract Whitelist is Ownable {
898     mapping(address => bool) public whitelist;
899 
900     event LogAddToWhitelist(address indexed user);
901     event LogRemoveFromWhitelist(address indexed user);
902 
903     modifier onlyWhitelist() {
904         require(whitelist[msg.sender], "only whitelist");
905         _;
906     }
907 
908     function addToWhitelist(address user) external onlyOwner {
909         require(user != address(0), 'WhiteList: 0x');
910         whitelist[user] = true;
911         emit LogAddToWhitelist(user);
912     }
913 
914     function removeFromWhitelist(address user) external onlyOwner {
915         require(user != address(0), 'WhiteList: 0x');
916         whitelist[user] = false;
917         emit LogRemoveFromWhitelist(user);
918     }
919 }
920 
921 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
922 
923 
924 pragma solidity >=0.6.0 <0.8.0;
925 
926 
927 
928 
929 /**
930  * @title SafeERC20
931  * @dev Wrappers around ERC20 operations that throw on failure (when the token
932  * contract returns false). Tokens that return no value (and instead revert or
933  * throw on failure) are also supported, non-reverting calls are assumed to be
934  * successful.
935  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
936  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
937  */
938 library SafeERC20 {
939     using SafeMath for uint256;
940     using Address for address;
941 
942     function safeTransfer(IERC20 token, address to, uint256 value) internal {
943         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
944     }
945 
946     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
947         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
948     }
949 
950     /**
951      * @dev Deprecated. This function has issues similar to the ones found in
952      * {IERC20-approve}, and its usage is discouraged.
953      *
954      * Whenever possible, use {safeIncreaseAllowance} and
955      * {safeDecreaseAllowance} instead.
956      */
957     function safeApprove(IERC20 token, address spender, uint256 value) internal {
958         // safeApprove should only be called when setting an initial allowance,
959         // or when resetting it to zero. To increase and decrease it, use
960         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
961         // solhint-disable-next-line max-line-length
962         require((value == 0) || (token.allowance(address(this), spender) == 0),
963             "SafeERC20: approve from non-zero to non-zero allowance"
964         );
965         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
966     }
967 
968     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
969         uint256 newAllowance = token.allowance(address(this), spender).add(value);
970         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
971     }
972 
973     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
974         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
975         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
976     }
977 
978     /**
979      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
980      * on the return value: the return value is optional (but if data is returned, it must not be false).
981      * @param token The token targeted by the call.
982      * @param data The call data (encoded using abi.encode or one of its variants).
983      */
984     function _callOptionalReturn(IERC20 token, bytes memory data) private {
985         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
986         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
987         // the target address contains contract code and also asserts for success in the low-level call.
988 
989         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
990         if (returndata.length > 0) { // Return data is optional
991             // solhint-disable-next-line max-line-length
992             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
993         }
994     }
995 }
996 
997 // File: contracts/interfaces/IController.sol
998 
999 pragma solidity >=0.6.0 <0.7.0;
1000 
1001 interface IController {
1002     function stablecoins() external view returns (address[] memory);
1003 
1004     function stablecoinsCount() external view returns (uint256);
1005 
1006     function vaults() external view returns (address[] memory);
1007 
1008     function underlyingVaults(uint256 i) external view returns (address vault);
1009 
1010     function curveVault() external view returns (address);
1011 
1012     function pnl() external view returns (address);
1013 
1014     function insurance() external view returns (address);
1015 
1016     function lifeGuard() external view returns (address);
1017 
1018     function buoy() external view returns (address);
1019 
1020     function gvt() external view returns (address);
1021 
1022     function pwrd() external view returns (address);
1023 
1024     function reward() external view returns (address);
1025 
1026     function isBigFish(uint256 amount, bool _pwrd) external view returns (bool);
1027 
1028     function withdrawHandler() external view returns (address);
1029 
1030     function depositHandler() external view returns (address);
1031 
1032     function totalAssets() external view returns (uint256);
1033 
1034     function gTokenTotalAssets() external view returns (uint256);
1035 
1036     function eoaOnly(address sender) external;
1037 
1038     function getSkimPercent() external view returns (uint256);
1039 
1040     function gToken(bool _pwrd) external view returns (address);
1041 
1042     function emergencyState() external view returns (bool);
1043 
1044     function deadCoin() external view returns (uint256);
1045 }
1046 
1047 // File: contracts/interfaces/IERC20Detailed.sol
1048 
1049 pragma solidity >=0.6.0 <0.7.0;
1050 
1051 interface IERC20Detailed {
1052 
1053     function name() external view returns (string memory);
1054 
1055     function symbol() external view returns (string memory);
1056 
1057     function decimals() external view returns (uint8);
1058 }
1059 
1060 // File: contracts/interfaces/IToken.sol
1061 
1062 pragma solidity >=0.6.0 <0.7.0;
1063 
1064 interface IToken {
1065     function factor() external view returns (uint256);
1066 
1067     function factor(uint256 totalAssets) external view returns (uint256);
1068 
1069     function mint(
1070         address account,
1071         uint256 _factor,
1072         uint256 amount
1073     ) external;
1074 
1075     function burn(
1076         address account,
1077         uint256 _factor,
1078         uint256 amount
1079     ) external;
1080 
1081     function burnAll(address account) external;
1082 
1083     function totalAssets() external view returns (uint256);
1084 
1085     function getPricePerShare() external view returns (uint256);
1086 
1087     function getShareAssets(uint256 shares) external view returns (uint256);
1088 
1089     function getAssets(address account) external view returns (uint256);
1090 }
1091 
1092 // File: contracts/tokens/GToken.sol
1093 
1094 pragma solidity >=0.6.0 <0.7.0;
1095 
1096 
1097 
1098 
1099 
1100 
1101 
1102 
1103 
1104 abstract contract GToken is GERC20, DecimalConstants, Whitelist, IToken {
1105     uint256 public constant BASE = DEFAULT_DECIMALS_FACTOR;
1106 
1107     using SafeERC20 for IERC20;
1108     using SafeMath for uint256;
1109 
1110     IController public ctrl;
1111 
1112     constructor(
1113         string memory name,
1114         string memory symbol,
1115         address controller
1116     ) public GERC20(name, symbol, DEFAULT_DECIMALS) {
1117         ctrl = IController(controller);
1118     }
1119 
1120     function setController(address controller) external onlyOwner {
1121         ctrl = IController(controller);
1122     }
1123 
1124     function factor() public view override returns (uint256) {
1125         return factor(totalAssets());
1126     }
1127 
1128     function applyFactor(
1129         uint256 a,
1130         uint256 b,
1131         bool base
1132     ) internal pure returns (uint256 resultant) {
1133         uint256 _BASE = BASE;
1134         uint256 diff;
1135         if (base) {
1136             diff = a.mul(b) % _BASE;
1137             resultant = a.mul(b).div(_BASE);
1138         } else {
1139             diff = a.mul(_BASE) % b;
1140             resultant = a.mul(_BASE).div(b);
1141         }
1142         if (diff >= 5E17) {
1143             resultant = resultant.add(1);
1144         }
1145     }
1146 
1147     function factor(uint256 totalAssets) public view override returns (uint256) {
1148         if (totalSupplyBase() == 0) {
1149             return getInitialBase();
1150         }
1151 
1152         if (totalAssets > 0) {
1153             return totalSupplyBase().mul(BASE).div(totalAssets);
1154         }
1155 
1156         return 0;
1157     }
1158 
1159     function totalAssets() public view override returns (uint256) {
1160         return ctrl.gTokenTotalAssets();
1161     }
1162 
1163     function getInitialBase() internal pure virtual returns (uint256) {
1164         return BASE;
1165     }
1166 }
1167 
1168 // File: hardhat/console.sol
1169 
1170 pragma solidity >= 0.4.22 <0.9.0;
1171 
1172 library console {
1173 	address constant CONSOLE_ADDRESS = address(0x000000000000000000636F6e736F6c652e6c6f67);
1174 
1175 	function _sendLogPayload(bytes memory payload) private view {
1176 		uint256 payloadLength = payload.length;
1177 		address consoleAddress = CONSOLE_ADDRESS;
1178 		assembly {
1179 			let payloadStart := add(payload, 32)
1180 			let r := staticcall(gas(), consoleAddress, payloadStart, payloadLength, 0, 0)
1181 		}
1182 	}
1183 
1184 	function log() internal view {
1185 		_sendLogPayload(abi.encodeWithSignature("log()"));
1186 	}
1187 
1188 	function logInt(int p0) internal view {
1189 		_sendLogPayload(abi.encodeWithSignature("log(int)", p0));
1190 	}
1191 
1192 	function logUint(uint p0) internal view {
1193 		_sendLogPayload(abi.encodeWithSignature("log(uint)", p0));
1194 	}
1195 
1196 	function logString(string memory p0) internal view {
1197 		_sendLogPayload(abi.encodeWithSignature("log(string)", p0));
1198 	}
1199 
1200 	function logBool(bool p0) internal view {
1201 		_sendLogPayload(abi.encodeWithSignature("log(bool)", p0));
1202 	}
1203 
1204 	function logAddress(address p0) internal view {
1205 		_sendLogPayload(abi.encodeWithSignature("log(address)", p0));
1206 	}
1207 
1208 	function logBytes(bytes memory p0) internal view {
1209 		_sendLogPayload(abi.encodeWithSignature("log(bytes)", p0));
1210 	}
1211 
1212 	function logBytes1(bytes1 p0) internal view {
1213 		_sendLogPayload(abi.encodeWithSignature("log(bytes1)", p0));
1214 	}
1215 
1216 	function logBytes2(bytes2 p0) internal view {
1217 		_sendLogPayload(abi.encodeWithSignature("log(bytes2)", p0));
1218 	}
1219 
1220 	function logBytes3(bytes3 p0) internal view {
1221 		_sendLogPayload(abi.encodeWithSignature("log(bytes3)", p0));
1222 	}
1223 
1224 	function logBytes4(bytes4 p0) internal view {
1225 		_sendLogPayload(abi.encodeWithSignature("log(bytes4)", p0));
1226 	}
1227 
1228 	function logBytes5(bytes5 p0) internal view {
1229 		_sendLogPayload(abi.encodeWithSignature("log(bytes5)", p0));
1230 	}
1231 
1232 	function logBytes6(bytes6 p0) internal view {
1233 		_sendLogPayload(abi.encodeWithSignature("log(bytes6)", p0));
1234 	}
1235 
1236 	function logBytes7(bytes7 p0) internal view {
1237 		_sendLogPayload(abi.encodeWithSignature("log(bytes7)", p0));
1238 	}
1239 
1240 	function logBytes8(bytes8 p0) internal view {
1241 		_sendLogPayload(abi.encodeWithSignature("log(bytes8)", p0));
1242 	}
1243 
1244 	function logBytes9(bytes9 p0) internal view {
1245 		_sendLogPayload(abi.encodeWithSignature("log(bytes9)", p0));
1246 	}
1247 
1248 	function logBytes10(bytes10 p0) internal view {
1249 		_sendLogPayload(abi.encodeWithSignature("log(bytes10)", p0));
1250 	}
1251 
1252 	function logBytes11(bytes11 p0) internal view {
1253 		_sendLogPayload(abi.encodeWithSignature("log(bytes11)", p0));
1254 	}
1255 
1256 	function logBytes12(bytes12 p0) internal view {
1257 		_sendLogPayload(abi.encodeWithSignature("log(bytes12)", p0));
1258 	}
1259 
1260 	function logBytes13(bytes13 p0) internal view {
1261 		_sendLogPayload(abi.encodeWithSignature("log(bytes13)", p0));
1262 	}
1263 
1264 	function logBytes14(bytes14 p0) internal view {
1265 		_sendLogPayload(abi.encodeWithSignature("log(bytes14)", p0));
1266 	}
1267 
1268 	function logBytes15(bytes15 p0) internal view {
1269 		_sendLogPayload(abi.encodeWithSignature("log(bytes15)", p0));
1270 	}
1271 
1272 	function logBytes16(bytes16 p0) internal view {
1273 		_sendLogPayload(abi.encodeWithSignature("log(bytes16)", p0));
1274 	}
1275 
1276 	function logBytes17(bytes17 p0) internal view {
1277 		_sendLogPayload(abi.encodeWithSignature("log(bytes17)", p0));
1278 	}
1279 
1280 	function logBytes18(bytes18 p0) internal view {
1281 		_sendLogPayload(abi.encodeWithSignature("log(bytes18)", p0));
1282 	}
1283 
1284 	function logBytes19(bytes19 p0) internal view {
1285 		_sendLogPayload(abi.encodeWithSignature("log(bytes19)", p0));
1286 	}
1287 
1288 	function logBytes20(bytes20 p0) internal view {
1289 		_sendLogPayload(abi.encodeWithSignature("log(bytes20)", p0));
1290 	}
1291 
1292 	function logBytes21(bytes21 p0) internal view {
1293 		_sendLogPayload(abi.encodeWithSignature("log(bytes21)", p0));
1294 	}
1295 
1296 	function logBytes22(bytes22 p0) internal view {
1297 		_sendLogPayload(abi.encodeWithSignature("log(bytes22)", p0));
1298 	}
1299 
1300 	function logBytes23(bytes23 p0) internal view {
1301 		_sendLogPayload(abi.encodeWithSignature("log(bytes23)", p0));
1302 	}
1303 
1304 	function logBytes24(bytes24 p0) internal view {
1305 		_sendLogPayload(abi.encodeWithSignature("log(bytes24)", p0));
1306 	}
1307 
1308 	function logBytes25(bytes25 p0) internal view {
1309 		_sendLogPayload(abi.encodeWithSignature("log(bytes25)", p0));
1310 	}
1311 
1312 	function logBytes26(bytes26 p0) internal view {
1313 		_sendLogPayload(abi.encodeWithSignature("log(bytes26)", p0));
1314 	}
1315 
1316 	function logBytes27(bytes27 p0) internal view {
1317 		_sendLogPayload(abi.encodeWithSignature("log(bytes27)", p0));
1318 	}
1319 
1320 	function logBytes28(bytes28 p0) internal view {
1321 		_sendLogPayload(abi.encodeWithSignature("log(bytes28)", p0));
1322 	}
1323 
1324 	function logBytes29(bytes29 p0) internal view {
1325 		_sendLogPayload(abi.encodeWithSignature("log(bytes29)", p0));
1326 	}
1327 
1328 	function logBytes30(bytes30 p0) internal view {
1329 		_sendLogPayload(abi.encodeWithSignature("log(bytes30)", p0));
1330 	}
1331 
1332 	function logBytes31(bytes31 p0) internal view {
1333 		_sendLogPayload(abi.encodeWithSignature("log(bytes31)", p0));
1334 	}
1335 
1336 	function logBytes32(bytes32 p0) internal view {
1337 		_sendLogPayload(abi.encodeWithSignature("log(bytes32)", p0));
1338 	}
1339 
1340 	function log(uint p0) internal view {
1341 		_sendLogPayload(abi.encodeWithSignature("log(uint)", p0));
1342 	}
1343 
1344 	function log(string memory p0) internal view {
1345 		_sendLogPayload(abi.encodeWithSignature("log(string)", p0));
1346 	}
1347 
1348 	function log(bool p0) internal view {
1349 		_sendLogPayload(abi.encodeWithSignature("log(bool)", p0));
1350 	}
1351 
1352 	function log(address p0) internal view {
1353 		_sendLogPayload(abi.encodeWithSignature("log(address)", p0));
1354 	}
1355 
1356 	function log(uint p0, uint p1) internal view {
1357 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint)", p0, p1));
1358 	}
1359 
1360 	function log(uint p0, string memory p1) internal view {
1361 		_sendLogPayload(abi.encodeWithSignature("log(uint,string)", p0, p1));
1362 	}
1363 
1364 	function log(uint p0, bool p1) internal view {
1365 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool)", p0, p1));
1366 	}
1367 
1368 	function log(uint p0, address p1) internal view {
1369 		_sendLogPayload(abi.encodeWithSignature("log(uint,address)", p0, p1));
1370 	}
1371 
1372 	function log(string memory p0, uint p1) internal view {
1373 		_sendLogPayload(abi.encodeWithSignature("log(string,uint)", p0, p1));
1374 	}
1375 
1376 	function log(string memory p0, string memory p1) internal view {
1377 		_sendLogPayload(abi.encodeWithSignature("log(string,string)", p0, p1));
1378 	}
1379 
1380 	function log(string memory p0, bool p1) internal view {
1381 		_sendLogPayload(abi.encodeWithSignature("log(string,bool)", p0, p1));
1382 	}
1383 
1384 	function log(string memory p0, address p1) internal view {
1385 		_sendLogPayload(abi.encodeWithSignature("log(string,address)", p0, p1));
1386 	}
1387 
1388 	function log(bool p0, uint p1) internal view {
1389 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint)", p0, p1));
1390 	}
1391 
1392 	function log(bool p0, string memory p1) internal view {
1393 		_sendLogPayload(abi.encodeWithSignature("log(bool,string)", p0, p1));
1394 	}
1395 
1396 	function log(bool p0, bool p1) internal view {
1397 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool)", p0, p1));
1398 	}
1399 
1400 	function log(bool p0, address p1) internal view {
1401 		_sendLogPayload(abi.encodeWithSignature("log(bool,address)", p0, p1));
1402 	}
1403 
1404 	function log(address p0, uint p1) internal view {
1405 		_sendLogPayload(abi.encodeWithSignature("log(address,uint)", p0, p1));
1406 	}
1407 
1408 	function log(address p0, string memory p1) internal view {
1409 		_sendLogPayload(abi.encodeWithSignature("log(address,string)", p0, p1));
1410 	}
1411 
1412 	function log(address p0, bool p1) internal view {
1413 		_sendLogPayload(abi.encodeWithSignature("log(address,bool)", p0, p1));
1414 	}
1415 
1416 	function log(address p0, address p1) internal view {
1417 		_sendLogPayload(abi.encodeWithSignature("log(address,address)", p0, p1));
1418 	}
1419 
1420 	function log(uint p0, uint p1, uint p2) internal view {
1421 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,uint)", p0, p1, p2));
1422 	}
1423 
1424 	function log(uint p0, uint p1, string memory p2) internal view {
1425 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,string)", p0, p1, p2));
1426 	}
1427 
1428 	function log(uint p0, uint p1, bool p2) internal view {
1429 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,bool)", p0, p1, p2));
1430 	}
1431 
1432 	function log(uint p0, uint p1, address p2) internal view {
1433 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,address)", p0, p1, p2));
1434 	}
1435 
1436 	function log(uint p0, string memory p1, uint p2) internal view {
1437 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,uint)", p0, p1, p2));
1438 	}
1439 
1440 	function log(uint p0, string memory p1, string memory p2) internal view {
1441 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,string)", p0, p1, p2));
1442 	}
1443 
1444 	function log(uint p0, string memory p1, bool p2) internal view {
1445 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,bool)", p0, p1, p2));
1446 	}
1447 
1448 	function log(uint p0, string memory p1, address p2) internal view {
1449 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,address)", p0, p1, p2));
1450 	}
1451 
1452 	function log(uint p0, bool p1, uint p2) internal view {
1453 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,uint)", p0, p1, p2));
1454 	}
1455 
1456 	function log(uint p0, bool p1, string memory p2) internal view {
1457 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,string)", p0, p1, p2));
1458 	}
1459 
1460 	function log(uint p0, bool p1, bool p2) internal view {
1461 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,bool)", p0, p1, p2));
1462 	}
1463 
1464 	function log(uint p0, bool p1, address p2) internal view {
1465 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,address)", p0, p1, p2));
1466 	}
1467 
1468 	function log(uint p0, address p1, uint p2) internal view {
1469 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,uint)", p0, p1, p2));
1470 	}
1471 
1472 	function log(uint p0, address p1, string memory p2) internal view {
1473 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,string)", p0, p1, p2));
1474 	}
1475 
1476 	function log(uint p0, address p1, bool p2) internal view {
1477 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,bool)", p0, p1, p2));
1478 	}
1479 
1480 	function log(uint p0, address p1, address p2) internal view {
1481 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,address)", p0, p1, p2));
1482 	}
1483 
1484 	function log(string memory p0, uint p1, uint p2) internal view {
1485 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,uint)", p0, p1, p2));
1486 	}
1487 
1488 	function log(string memory p0, uint p1, string memory p2) internal view {
1489 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,string)", p0, p1, p2));
1490 	}
1491 
1492 	function log(string memory p0, uint p1, bool p2) internal view {
1493 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,bool)", p0, p1, p2));
1494 	}
1495 
1496 	function log(string memory p0, uint p1, address p2) internal view {
1497 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,address)", p0, p1, p2));
1498 	}
1499 
1500 	function log(string memory p0, string memory p1, uint p2) internal view {
1501 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint)", p0, p1, p2));
1502 	}
1503 
1504 	function log(string memory p0, string memory p1, string memory p2) internal view {
1505 		_sendLogPayload(abi.encodeWithSignature("log(string,string,string)", p0, p1, p2));
1506 	}
1507 
1508 	function log(string memory p0, string memory p1, bool p2) internal view {
1509 		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool)", p0, p1, p2));
1510 	}
1511 
1512 	function log(string memory p0, string memory p1, address p2) internal view {
1513 		_sendLogPayload(abi.encodeWithSignature("log(string,string,address)", p0, p1, p2));
1514 	}
1515 
1516 	function log(string memory p0, bool p1, uint p2) internal view {
1517 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint)", p0, p1, p2));
1518 	}
1519 
1520 	function log(string memory p0, bool p1, string memory p2) internal view {
1521 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string)", p0, p1, p2));
1522 	}
1523 
1524 	function log(string memory p0, bool p1, bool p2) internal view {
1525 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool)", p0, p1, p2));
1526 	}
1527 
1528 	function log(string memory p0, bool p1, address p2) internal view {
1529 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address)", p0, p1, p2));
1530 	}
1531 
1532 	function log(string memory p0, address p1, uint p2) internal view {
1533 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint)", p0, p1, p2));
1534 	}
1535 
1536 	function log(string memory p0, address p1, string memory p2) internal view {
1537 		_sendLogPayload(abi.encodeWithSignature("log(string,address,string)", p0, p1, p2));
1538 	}
1539 
1540 	function log(string memory p0, address p1, bool p2) internal view {
1541 		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool)", p0, p1, p2));
1542 	}
1543 
1544 	function log(string memory p0, address p1, address p2) internal view {
1545 		_sendLogPayload(abi.encodeWithSignature("log(string,address,address)", p0, p1, p2));
1546 	}
1547 
1548 	function log(bool p0, uint p1, uint p2) internal view {
1549 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,uint)", p0, p1, p2));
1550 	}
1551 
1552 	function log(bool p0, uint p1, string memory p2) internal view {
1553 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,string)", p0, p1, p2));
1554 	}
1555 
1556 	function log(bool p0, uint p1, bool p2) internal view {
1557 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,bool)", p0, p1, p2));
1558 	}
1559 
1560 	function log(bool p0, uint p1, address p2) internal view {
1561 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,address)", p0, p1, p2));
1562 	}
1563 
1564 	function log(bool p0, string memory p1, uint p2) internal view {
1565 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint)", p0, p1, p2));
1566 	}
1567 
1568 	function log(bool p0, string memory p1, string memory p2) internal view {
1569 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string)", p0, p1, p2));
1570 	}
1571 
1572 	function log(bool p0, string memory p1, bool p2) internal view {
1573 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool)", p0, p1, p2));
1574 	}
1575 
1576 	function log(bool p0, string memory p1, address p2) internal view {
1577 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address)", p0, p1, p2));
1578 	}
1579 
1580 	function log(bool p0, bool p1, uint p2) internal view {
1581 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint)", p0, p1, p2));
1582 	}
1583 
1584 	function log(bool p0, bool p1, string memory p2) internal view {
1585 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string)", p0, p1, p2));
1586 	}
1587 
1588 	function log(bool p0, bool p1, bool p2) internal view {
1589 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool)", p0, p1, p2));
1590 	}
1591 
1592 	function log(bool p0, bool p1, address p2) internal view {
1593 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address)", p0, p1, p2));
1594 	}
1595 
1596 	function log(bool p0, address p1, uint p2) internal view {
1597 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint)", p0, p1, p2));
1598 	}
1599 
1600 	function log(bool p0, address p1, string memory p2) internal view {
1601 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string)", p0, p1, p2));
1602 	}
1603 
1604 	function log(bool p0, address p1, bool p2) internal view {
1605 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool)", p0, p1, p2));
1606 	}
1607 
1608 	function log(bool p0, address p1, address p2) internal view {
1609 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address)", p0, p1, p2));
1610 	}
1611 
1612 	function log(address p0, uint p1, uint p2) internal view {
1613 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,uint)", p0, p1, p2));
1614 	}
1615 
1616 	function log(address p0, uint p1, string memory p2) internal view {
1617 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,string)", p0, p1, p2));
1618 	}
1619 
1620 	function log(address p0, uint p1, bool p2) internal view {
1621 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,bool)", p0, p1, p2));
1622 	}
1623 
1624 	function log(address p0, uint p1, address p2) internal view {
1625 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,address)", p0, p1, p2));
1626 	}
1627 
1628 	function log(address p0, string memory p1, uint p2) internal view {
1629 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint)", p0, p1, p2));
1630 	}
1631 
1632 	function log(address p0, string memory p1, string memory p2) internal view {
1633 		_sendLogPayload(abi.encodeWithSignature("log(address,string,string)", p0, p1, p2));
1634 	}
1635 
1636 	function log(address p0, string memory p1, bool p2) internal view {
1637 		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool)", p0, p1, p2));
1638 	}
1639 
1640 	function log(address p0, string memory p1, address p2) internal view {
1641 		_sendLogPayload(abi.encodeWithSignature("log(address,string,address)", p0, p1, p2));
1642 	}
1643 
1644 	function log(address p0, bool p1, uint p2) internal view {
1645 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint)", p0, p1, p2));
1646 	}
1647 
1648 	function log(address p0, bool p1, string memory p2) internal view {
1649 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string)", p0, p1, p2));
1650 	}
1651 
1652 	function log(address p0, bool p1, bool p2) internal view {
1653 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool)", p0, p1, p2));
1654 	}
1655 
1656 	function log(address p0, bool p1, address p2) internal view {
1657 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address)", p0, p1, p2));
1658 	}
1659 
1660 	function log(address p0, address p1, uint p2) internal view {
1661 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint)", p0, p1, p2));
1662 	}
1663 
1664 	function log(address p0, address p1, string memory p2) internal view {
1665 		_sendLogPayload(abi.encodeWithSignature("log(address,address,string)", p0, p1, p2));
1666 	}
1667 
1668 	function log(address p0, address p1, bool p2) internal view {
1669 		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool)", p0, p1, p2));
1670 	}
1671 
1672 	function log(address p0, address p1, address p2) internal view {
1673 		_sendLogPayload(abi.encodeWithSignature("log(address,address,address)", p0, p1, p2));
1674 	}
1675 
1676 	function log(uint p0, uint p1, uint p2, uint p3) internal view {
1677 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,uint,uint)", p0, p1, p2, p3));
1678 	}
1679 
1680 	function log(uint p0, uint p1, uint p2, string memory p3) internal view {
1681 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,uint,string)", p0, p1, p2, p3));
1682 	}
1683 
1684 	function log(uint p0, uint p1, uint p2, bool p3) internal view {
1685 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,uint,bool)", p0, p1, p2, p3));
1686 	}
1687 
1688 	function log(uint p0, uint p1, uint p2, address p3) internal view {
1689 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,uint,address)", p0, p1, p2, p3));
1690 	}
1691 
1692 	function log(uint p0, uint p1, string memory p2, uint p3) internal view {
1693 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,string,uint)", p0, p1, p2, p3));
1694 	}
1695 
1696 	function log(uint p0, uint p1, string memory p2, string memory p3) internal view {
1697 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,string,string)", p0, p1, p2, p3));
1698 	}
1699 
1700 	function log(uint p0, uint p1, string memory p2, bool p3) internal view {
1701 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,string,bool)", p0, p1, p2, p3));
1702 	}
1703 
1704 	function log(uint p0, uint p1, string memory p2, address p3) internal view {
1705 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,string,address)", p0, p1, p2, p3));
1706 	}
1707 
1708 	function log(uint p0, uint p1, bool p2, uint p3) internal view {
1709 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,bool,uint)", p0, p1, p2, p3));
1710 	}
1711 
1712 	function log(uint p0, uint p1, bool p2, string memory p3) internal view {
1713 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,bool,string)", p0, p1, p2, p3));
1714 	}
1715 
1716 	function log(uint p0, uint p1, bool p2, bool p3) internal view {
1717 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,bool,bool)", p0, p1, p2, p3));
1718 	}
1719 
1720 	function log(uint p0, uint p1, bool p2, address p3) internal view {
1721 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,bool,address)", p0, p1, p2, p3));
1722 	}
1723 
1724 	function log(uint p0, uint p1, address p2, uint p3) internal view {
1725 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,address,uint)", p0, p1, p2, p3));
1726 	}
1727 
1728 	function log(uint p0, uint p1, address p2, string memory p3) internal view {
1729 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,address,string)", p0, p1, p2, p3));
1730 	}
1731 
1732 	function log(uint p0, uint p1, address p2, bool p3) internal view {
1733 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,address,bool)", p0, p1, p2, p3));
1734 	}
1735 
1736 	function log(uint p0, uint p1, address p2, address p3) internal view {
1737 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,address,address)", p0, p1, p2, p3));
1738 	}
1739 
1740 	function log(uint p0, string memory p1, uint p2, uint p3) internal view {
1741 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,uint,uint)", p0, p1, p2, p3));
1742 	}
1743 
1744 	function log(uint p0, string memory p1, uint p2, string memory p3) internal view {
1745 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,uint,string)", p0, p1, p2, p3));
1746 	}
1747 
1748 	function log(uint p0, string memory p1, uint p2, bool p3) internal view {
1749 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,uint,bool)", p0, p1, p2, p3));
1750 	}
1751 
1752 	function log(uint p0, string memory p1, uint p2, address p3) internal view {
1753 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,uint,address)", p0, p1, p2, p3));
1754 	}
1755 
1756 	function log(uint p0, string memory p1, string memory p2, uint p3) internal view {
1757 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,string,uint)", p0, p1, p2, p3));
1758 	}
1759 
1760 	function log(uint p0, string memory p1, string memory p2, string memory p3) internal view {
1761 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,string,string)", p0, p1, p2, p3));
1762 	}
1763 
1764 	function log(uint p0, string memory p1, string memory p2, bool p3) internal view {
1765 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,string,bool)", p0, p1, p2, p3));
1766 	}
1767 
1768 	function log(uint p0, string memory p1, string memory p2, address p3) internal view {
1769 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,string,address)", p0, p1, p2, p3));
1770 	}
1771 
1772 	function log(uint p0, string memory p1, bool p2, uint p3) internal view {
1773 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,bool,uint)", p0, p1, p2, p3));
1774 	}
1775 
1776 	function log(uint p0, string memory p1, bool p2, string memory p3) internal view {
1777 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,bool,string)", p0, p1, p2, p3));
1778 	}
1779 
1780 	function log(uint p0, string memory p1, bool p2, bool p3) internal view {
1781 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,bool,bool)", p0, p1, p2, p3));
1782 	}
1783 
1784 	function log(uint p0, string memory p1, bool p2, address p3) internal view {
1785 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,bool,address)", p0, p1, p2, p3));
1786 	}
1787 
1788 	function log(uint p0, string memory p1, address p2, uint p3) internal view {
1789 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,address,uint)", p0, p1, p2, p3));
1790 	}
1791 
1792 	function log(uint p0, string memory p1, address p2, string memory p3) internal view {
1793 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,address,string)", p0, p1, p2, p3));
1794 	}
1795 
1796 	function log(uint p0, string memory p1, address p2, bool p3) internal view {
1797 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,address,bool)", p0, p1, p2, p3));
1798 	}
1799 
1800 	function log(uint p0, string memory p1, address p2, address p3) internal view {
1801 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,address,address)", p0, p1, p2, p3));
1802 	}
1803 
1804 	function log(uint p0, bool p1, uint p2, uint p3) internal view {
1805 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,uint,uint)", p0, p1, p2, p3));
1806 	}
1807 
1808 	function log(uint p0, bool p1, uint p2, string memory p3) internal view {
1809 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,uint,string)", p0, p1, p2, p3));
1810 	}
1811 
1812 	function log(uint p0, bool p1, uint p2, bool p3) internal view {
1813 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,uint,bool)", p0, p1, p2, p3));
1814 	}
1815 
1816 	function log(uint p0, bool p1, uint p2, address p3) internal view {
1817 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,uint,address)", p0, p1, p2, p3));
1818 	}
1819 
1820 	function log(uint p0, bool p1, string memory p2, uint p3) internal view {
1821 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,string,uint)", p0, p1, p2, p3));
1822 	}
1823 
1824 	function log(uint p0, bool p1, string memory p2, string memory p3) internal view {
1825 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,string,string)", p0, p1, p2, p3));
1826 	}
1827 
1828 	function log(uint p0, bool p1, string memory p2, bool p3) internal view {
1829 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,string,bool)", p0, p1, p2, p3));
1830 	}
1831 
1832 	function log(uint p0, bool p1, string memory p2, address p3) internal view {
1833 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,string,address)", p0, p1, p2, p3));
1834 	}
1835 
1836 	function log(uint p0, bool p1, bool p2, uint p3) internal view {
1837 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,bool,uint)", p0, p1, p2, p3));
1838 	}
1839 
1840 	function log(uint p0, bool p1, bool p2, string memory p3) internal view {
1841 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,bool,string)", p0, p1, p2, p3));
1842 	}
1843 
1844 	function log(uint p0, bool p1, bool p2, bool p3) internal view {
1845 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,bool,bool)", p0, p1, p2, p3));
1846 	}
1847 
1848 	function log(uint p0, bool p1, bool p2, address p3) internal view {
1849 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,bool,address)", p0, p1, p2, p3));
1850 	}
1851 
1852 	function log(uint p0, bool p1, address p2, uint p3) internal view {
1853 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,address,uint)", p0, p1, p2, p3));
1854 	}
1855 
1856 	function log(uint p0, bool p1, address p2, string memory p3) internal view {
1857 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,address,string)", p0, p1, p2, p3));
1858 	}
1859 
1860 	function log(uint p0, bool p1, address p2, bool p3) internal view {
1861 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,address,bool)", p0, p1, p2, p3));
1862 	}
1863 
1864 	function log(uint p0, bool p1, address p2, address p3) internal view {
1865 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,address,address)", p0, p1, p2, p3));
1866 	}
1867 
1868 	function log(uint p0, address p1, uint p2, uint p3) internal view {
1869 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,uint,uint)", p0, p1, p2, p3));
1870 	}
1871 
1872 	function log(uint p0, address p1, uint p2, string memory p3) internal view {
1873 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,uint,string)", p0, p1, p2, p3));
1874 	}
1875 
1876 	function log(uint p0, address p1, uint p2, bool p3) internal view {
1877 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,uint,bool)", p0, p1, p2, p3));
1878 	}
1879 
1880 	function log(uint p0, address p1, uint p2, address p3) internal view {
1881 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,uint,address)", p0, p1, p2, p3));
1882 	}
1883 
1884 	function log(uint p0, address p1, string memory p2, uint p3) internal view {
1885 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,string,uint)", p0, p1, p2, p3));
1886 	}
1887 
1888 	function log(uint p0, address p1, string memory p2, string memory p3) internal view {
1889 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,string,string)", p0, p1, p2, p3));
1890 	}
1891 
1892 	function log(uint p0, address p1, string memory p2, bool p3) internal view {
1893 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,string,bool)", p0, p1, p2, p3));
1894 	}
1895 
1896 	function log(uint p0, address p1, string memory p2, address p3) internal view {
1897 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,string,address)", p0, p1, p2, p3));
1898 	}
1899 
1900 	function log(uint p0, address p1, bool p2, uint p3) internal view {
1901 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,bool,uint)", p0, p1, p2, p3));
1902 	}
1903 
1904 	function log(uint p0, address p1, bool p2, string memory p3) internal view {
1905 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,bool,string)", p0, p1, p2, p3));
1906 	}
1907 
1908 	function log(uint p0, address p1, bool p2, bool p3) internal view {
1909 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,bool,bool)", p0, p1, p2, p3));
1910 	}
1911 
1912 	function log(uint p0, address p1, bool p2, address p3) internal view {
1913 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,bool,address)", p0, p1, p2, p3));
1914 	}
1915 
1916 	function log(uint p0, address p1, address p2, uint p3) internal view {
1917 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,address,uint)", p0, p1, p2, p3));
1918 	}
1919 
1920 	function log(uint p0, address p1, address p2, string memory p3) internal view {
1921 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,address,string)", p0, p1, p2, p3));
1922 	}
1923 
1924 	function log(uint p0, address p1, address p2, bool p3) internal view {
1925 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,address,bool)", p0, p1, p2, p3));
1926 	}
1927 
1928 	function log(uint p0, address p1, address p2, address p3) internal view {
1929 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,address,address)", p0, p1, p2, p3));
1930 	}
1931 
1932 	function log(string memory p0, uint p1, uint p2, uint p3) internal view {
1933 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,uint,uint)", p0, p1, p2, p3));
1934 	}
1935 
1936 	function log(string memory p0, uint p1, uint p2, string memory p3) internal view {
1937 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,uint,string)", p0, p1, p2, p3));
1938 	}
1939 
1940 	function log(string memory p0, uint p1, uint p2, bool p3) internal view {
1941 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,uint,bool)", p0, p1, p2, p3));
1942 	}
1943 
1944 	function log(string memory p0, uint p1, uint p2, address p3) internal view {
1945 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,uint,address)", p0, p1, p2, p3));
1946 	}
1947 
1948 	function log(string memory p0, uint p1, string memory p2, uint p3) internal view {
1949 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,string,uint)", p0, p1, p2, p3));
1950 	}
1951 
1952 	function log(string memory p0, uint p1, string memory p2, string memory p3) internal view {
1953 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,string,string)", p0, p1, p2, p3));
1954 	}
1955 
1956 	function log(string memory p0, uint p1, string memory p2, bool p3) internal view {
1957 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,string,bool)", p0, p1, p2, p3));
1958 	}
1959 
1960 	function log(string memory p0, uint p1, string memory p2, address p3) internal view {
1961 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,string,address)", p0, p1, p2, p3));
1962 	}
1963 
1964 	function log(string memory p0, uint p1, bool p2, uint p3) internal view {
1965 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,bool,uint)", p0, p1, p2, p3));
1966 	}
1967 
1968 	function log(string memory p0, uint p1, bool p2, string memory p3) internal view {
1969 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,bool,string)", p0, p1, p2, p3));
1970 	}
1971 
1972 	function log(string memory p0, uint p1, bool p2, bool p3) internal view {
1973 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,bool,bool)", p0, p1, p2, p3));
1974 	}
1975 
1976 	function log(string memory p0, uint p1, bool p2, address p3) internal view {
1977 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,bool,address)", p0, p1, p2, p3));
1978 	}
1979 
1980 	function log(string memory p0, uint p1, address p2, uint p3) internal view {
1981 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,address,uint)", p0, p1, p2, p3));
1982 	}
1983 
1984 	function log(string memory p0, uint p1, address p2, string memory p3) internal view {
1985 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,address,string)", p0, p1, p2, p3));
1986 	}
1987 
1988 	function log(string memory p0, uint p1, address p2, bool p3) internal view {
1989 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,address,bool)", p0, p1, p2, p3));
1990 	}
1991 
1992 	function log(string memory p0, uint p1, address p2, address p3) internal view {
1993 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,address,address)", p0, p1, p2, p3));
1994 	}
1995 
1996 	function log(string memory p0, string memory p1, uint p2, uint p3) internal view {
1997 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint,uint)", p0, p1, p2, p3));
1998 	}
1999 
2000 	function log(string memory p0, string memory p1, uint p2, string memory p3) internal view {
2001 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint,string)", p0, p1, p2, p3));
2002 	}
2003 
2004 	function log(string memory p0, string memory p1, uint p2, bool p3) internal view {
2005 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint,bool)", p0, p1, p2, p3));
2006 	}
2007 
2008 	function log(string memory p0, string memory p1, uint p2, address p3) internal view {
2009 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint,address)", p0, p1, p2, p3));
2010 	}
2011 
2012 	function log(string memory p0, string memory p1, string memory p2, uint p3) internal view {
2013 		_sendLogPayload(abi.encodeWithSignature("log(string,string,string,uint)", p0, p1, p2, p3));
2014 	}
2015 
2016 	function log(string memory p0, string memory p1, string memory p2, string memory p3) internal view {
2017 		_sendLogPayload(abi.encodeWithSignature("log(string,string,string,string)", p0, p1, p2, p3));
2018 	}
2019 
2020 	function log(string memory p0, string memory p1, string memory p2, bool p3) internal view {
2021 		_sendLogPayload(abi.encodeWithSignature("log(string,string,string,bool)", p0, p1, p2, p3));
2022 	}
2023 
2024 	function log(string memory p0, string memory p1, string memory p2, address p3) internal view {
2025 		_sendLogPayload(abi.encodeWithSignature("log(string,string,string,address)", p0, p1, p2, p3));
2026 	}
2027 
2028 	function log(string memory p0, string memory p1, bool p2, uint p3) internal view {
2029 		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool,uint)", p0, p1, p2, p3));
2030 	}
2031 
2032 	function log(string memory p0, string memory p1, bool p2, string memory p3) internal view {
2033 		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool,string)", p0, p1, p2, p3));
2034 	}
2035 
2036 	function log(string memory p0, string memory p1, bool p2, bool p3) internal view {
2037 		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool,bool)", p0, p1, p2, p3));
2038 	}
2039 
2040 	function log(string memory p0, string memory p1, bool p2, address p3) internal view {
2041 		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool,address)", p0, p1, p2, p3));
2042 	}
2043 
2044 	function log(string memory p0, string memory p1, address p2, uint p3) internal view {
2045 		_sendLogPayload(abi.encodeWithSignature("log(string,string,address,uint)", p0, p1, p2, p3));
2046 	}
2047 
2048 	function log(string memory p0, string memory p1, address p2, string memory p3) internal view {
2049 		_sendLogPayload(abi.encodeWithSignature("log(string,string,address,string)", p0, p1, p2, p3));
2050 	}
2051 
2052 	function log(string memory p0, string memory p1, address p2, bool p3) internal view {
2053 		_sendLogPayload(abi.encodeWithSignature("log(string,string,address,bool)", p0, p1, p2, p3));
2054 	}
2055 
2056 	function log(string memory p0, string memory p1, address p2, address p3) internal view {
2057 		_sendLogPayload(abi.encodeWithSignature("log(string,string,address,address)", p0, p1, p2, p3));
2058 	}
2059 
2060 	function log(string memory p0, bool p1, uint p2, uint p3) internal view {
2061 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint,uint)", p0, p1, p2, p3));
2062 	}
2063 
2064 	function log(string memory p0, bool p1, uint p2, string memory p3) internal view {
2065 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint,string)", p0, p1, p2, p3));
2066 	}
2067 
2068 	function log(string memory p0, bool p1, uint p2, bool p3) internal view {
2069 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint,bool)", p0, p1, p2, p3));
2070 	}
2071 
2072 	function log(string memory p0, bool p1, uint p2, address p3) internal view {
2073 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint,address)", p0, p1, p2, p3));
2074 	}
2075 
2076 	function log(string memory p0, bool p1, string memory p2, uint p3) internal view {
2077 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string,uint)", p0, p1, p2, p3));
2078 	}
2079 
2080 	function log(string memory p0, bool p1, string memory p2, string memory p3) internal view {
2081 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string,string)", p0, p1, p2, p3));
2082 	}
2083 
2084 	function log(string memory p0, bool p1, string memory p2, bool p3) internal view {
2085 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string,bool)", p0, p1, p2, p3));
2086 	}
2087 
2088 	function log(string memory p0, bool p1, string memory p2, address p3) internal view {
2089 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string,address)", p0, p1, p2, p3));
2090 	}
2091 
2092 	function log(string memory p0, bool p1, bool p2, uint p3) internal view {
2093 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool,uint)", p0, p1, p2, p3));
2094 	}
2095 
2096 	function log(string memory p0, bool p1, bool p2, string memory p3) internal view {
2097 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool,string)", p0, p1, p2, p3));
2098 	}
2099 
2100 	function log(string memory p0, bool p1, bool p2, bool p3) internal view {
2101 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool,bool)", p0, p1, p2, p3));
2102 	}
2103 
2104 	function log(string memory p0, bool p1, bool p2, address p3) internal view {
2105 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool,address)", p0, p1, p2, p3));
2106 	}
2107 
2108 	function log(string memory p0, bool p1, address p2, uint p3) internal view {
2109 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address,uint)", p0, p1, p2, p3));
2110 	}
2111 
2112 	function log(string memory p0, bool p1, address p2, string memory p3) internal view {
2113 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address,string)", p0, p1, p2, p3));
2114 	}
2115 
2116 	function log(string memory p0, bool p1, address p2, bool p3) internal view {
2117 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address,bool)", p0, p1, p2, p3));
2118 	}
2119 
2120 	function log(string memory p0, bool p1, address p2, address p3) internal view {
2121 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address,address)", p0, p1, p2, p3));
2122 	}
2123 
2124 	function log(string memory p0, address p1, uint p2, uint p3) internal view {
2125 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint,uint)", p0, p1, p2, p3));
2126 	}
2127 
2128 	function log(string memory p0, address p1, uint p2, string memory p3) internal view {
2129 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint,string)", p0, p1, p2, p3));
2130 	}
2131 
2132 	function log(string memory p0, address p1, uint p2, bool p3) internal view {
2133 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint,bool)", p0, p1, p2, p3));
2134 	}
2135 
2136 	function log(string memory p0, address p1, uint p2, address p3) internal view {
2137 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint,address)", p0, p1, p2, p3));
2138 	}
2139 
2140 	function log(string memory p0, address p1, string memory p2, uint p3) internal view {
2141 		_sendLogPayload(abi.encodeWithSignature("log(string,address,string,uint)", p0, p1, p2, p3));
2142 	}
2143 
2144 	function log(string memory p0, address p1, string memory p2, string memory p3) internal view {
2145 		_sendLogPayload(abi.encodeWithSignature("log(string,address,string,string)", p0, p1, p2, p3));
2146 	}
2147 
2148 	function log(string memory p0, address p1, string memory p2, bool p3) internal view {
2149 		_sendLogPayload(abi.encodeWithSignature("log(string,address,string,bool)", p0, p1, p2, p3));
2150 	}
2151 
2152 	function log(string memory p0, address p1, string memory p2, address p3) internal view {
2153 		_sendLogPayload(abi.encodeWithSignature("log(string,address,string,address)", p0, p1, p2, p3));
2154 	}
2155 
2156 	function log(string memory p0, address p1, bool p2, uint p3) internal view {
2157 		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool,uint)", p0, p1, p2, p3));
2158 	}
2159 
2160 	function log(string memory p0, address p1, bool p2, string memory p3) internal view {
2161 		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool,string)", p0, p1, p2, p3));
2162 	}
2163 
2164 	function log(string memory p0, address p1, bool p2, bool p3) internal view {
2165 		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool,bool)", p0, p1, p2, p3));
2166 	}
2167 
2168 	function log(string memory p0, address p1, bool p2, address p3) internal view {
2169 		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool,address)", p0, p1, p2, p3));
2170 	}
2171 
2172 	function log(string memory p0, address p1, address p2, uint p3) internal view {
2173 		_sendLogPayload(abi.encodeWithSignature("log(string,address,address,uint)", p0, p1, p2, p3));
2174 	}
2175 
2176 	function log(string memory p0, address p1, address p2, string memory p3) internal view {
2177 		_sendLogPayload(abi.encodeWithSignature("log(string,address,address,string)", p0, p1, p2, p3));
2178 	}
2179 
2180 	function log(string memory p0, address p1, address p2, bool p3) internal view {
2181 		_sendLogPayload(abi.encodeWithSignature("log(string,address,address,bool)", p0, p1, p2, p3));
2182 	}
2183 
2184 	function log(string memory p0, address p1, address p2, address p3) internal view {
2185 		_sendLogPayload(abi.encodeWithSignature("log(string,address,address,address)", p0, p1, p2, p3));
2186 	}
2187 
2188 	function log(bool p0, uint p1, uint p2, uint p3) internal view {
2189 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,uint,uint)", p0, p1, p2, p3));
2190 	}
2191 
2192 	function log(bool p0, uint p1, uint p2, string memory p3) internal view {
2193 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,uint,string)", p0, p1, p2, p3));
2194 	}
2195 
2196 	function log(bool p0, uint p1, uint p2, bool p3) internal view {
2197 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,uint,bool)", p0, p1, p2, p3));
2198 	}
2199 
2200 	function log(bool p0, uint p1, uint p2, address p3) internal view {
2201 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,uint,address)", p0, p1, p2, p3));
2202 	}
2203 
2204 	function log(bool p0, uint p1, string memory p2, uint p3) internal view {
2205 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,string,uint)", p0, p1, p2, p3));
2206 	}
2207 
2208 	function log(bool p0, uint p1, string memory p2, string memory p3) internal view {
2209 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,string,string)", p0, p1, p2, p3));
2210 	}
2211 
2212 	function log(bool p0, uint p1, string memory p2, bool p3) internal view {
2213 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,string,bool)", p0, p1, p2, p3));
2214 	}
2215 
2216 	function log(bool p0, uint p1, string memory p2, address p3) internal view {
2217 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,string,address)", p0, p1, p2, p3));
2218 	}
2219 
2220 	function log(bool p0, uint p1, bool p2, uint p3) internal view {
2221 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,bool,uint)", p0, p1, p2, p3));
2222 	}
2223 
2224 	function log(bool p0, uint p1, bool p2, string memory p3) internal view {
2225 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,bool,string)", p0, p1, p2, p3));
2226 	}
2227 
2228 	function log(bool p0, uint p1, bool p2, bool p3) internal view {
2229 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,bool,bool)", p0, p1, p2, p3));
2230 	}
2231 
2232 	function log(bool p0, uint p1, bool p2, address p3) internal view {
2233 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,bool,address)", p0, p1, p2, p3));
2234 	}
2235 
2236 	function log(bool p0, uint p1, address p2, uint p3) internal view {
2237 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,address,uint)", p0, p1, p2, p3));
2238 	}
2239 
2240 	function log(bool p0, uint p1, address p2, string memory p3) internal view {
2241 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,address,string)", p0, p1, p2, p3));
2242 	}
2243 
2244 	function log(bool p0, uint p1, address p2, bool p3) internal view {
2245 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,address,bool)", p0, p1, p2, p3));
2246 	}
2247 
2248 	function log(bool p0, uint p1, address p2, address p3) internal view {
2249 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,address,address)", p0, p1, p2, p3));
2250 	}
2251 
2252 	function log(bool p0, string memory p1, uint p2, uint p3) internal view {
2253 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint,uint)", p0, p1, p2, p3));
2254 	}
2255 
2256 	function log(bool p0, string memory p1, uint p2, string memory p3) internal view {
2257 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint,string)", p0, p1, p2, p3));
2258 	}
2259 
2260 	function log(bool p0, string memory p1, uint p2, bool p3) internal view {
2261 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint,bool)", p0, p1, p2, p3));
2262 	}
2263 
2264 	function log(bool p0, string memory p1, uint p2, address p3) internal view {
2265 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint,address)", p0, p1, p2, p3));
2266 	}
2267 
2268 	function log(bool p0, string memory p1, string memory p2, uint p3) internal view {
2269 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string,uint)", p0, p1, p2, p3));
2270 	}
2271 
2272 	function log(bool p0, string memory p1, string memory p2, string memory p3) internal view {
2273 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string,string)", p0, p1, p2, p3));
2274 	}
2275 
2276 	function log(bool p0, string memory p1, string memory p2, bool p3) internal view {
2277 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string,bool)", p0, p1, p2, p3));
2278 	}
2279 
2280 	function log(bool p0, string memory p1, string memory p2, address p3) internal view {
2281 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string,address)", p0, p1, p2, p3));
2282 	}
2283 
2284 	function log(bool p0, string memory p1, bool p2, uint p3) internal view {
2285 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool,uint)", p0, p1, p2, p3));
2286 	}
2287 
2288 	function log(bool p0, string memory p1, bool p2, string memory p3) internal view {
2289 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool,string)", p0, p1, p2, p3));
2290 	}
2291 
2292 	function log(bool p0, string memory p1, bool p2, bool p3) internal view {
2293 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool,bool)", p0, p1, p2, p3));
2294 	}
2295 
2296 	function log(bool p0, string memory p1, bool p2, address p3) internal view {
2297 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool,address)", p0, p1, p2, p3));
2298 	}
2299 
2300 	function log(bool p0, string memory p1, address p2, uint p3) internal view {
2301 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address,uint)", p0, p1, p2, p3));
2302 	}
2303 
2304 	function log(bool p0, string memory p1, address p2, string memory p3) internal view {
2305 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address,string)", p0, p1, p2, p3));
2306 	}
2307 
2308 	function log(bool p0, string memory p1, address p2, bool p3) internal view {
2309 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address,bool)", p0, p1, p2, p3));
2310 	}
2311 
2312 	function log(bool p0, string memory p1, address p2, address p3) internal view {
2313 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address,address)", p0, p1, p2, p3));
2314 	}
2315 
2316 	function log(bool p0, bool p1, uint p2, uint p3) internal view {
2317 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint,uint)", p0, p1, p2, p3));
2318 	}
2319 
2320 	function log(bool p0, bool p1, uint p2, string memory p3) internal view {
2321 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint,string)", p0, p1, p2, p3));
2322 	}
2323 
2324 	function log(bool p0, bool p1, uint p2, bool p3) internal view {
2325 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint,bool)", p0, p1, p2, p3));
2326 	}
2327 
2328 	function log(bool p0, bool p1, uint p2, address p3) internal view {
2329 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint,address)", p0, p1, p2, p3));
2330 	}
2331 
2332 	function log(bool p0, bool p1, string memory p2, uint p3) internal view {
2333 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string,uint)", p0, p1, p2, p3));
2334 	}
2335 
2336 	function log(bool p0, bool p1, string memory p2, string memory p3) internal view {
2337 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string,string)", p0, p1, p2, p3));
2338 	}
2339 
2340 	function log(bool p0, bool p1, string memory p2, bool p3) internal view {
2341 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string,bool)", p0, p1, p2, p3));
2342 	}
2343 
2344 	function log(bool p0, bool p1, string memory p2, address p3) internal view {
2345 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string,address)", p0, p1, p2, p3));
2346 	}
2347 
2348 	function log(bool p0, bool p1, bool p2, uint p3) internal view {
2349 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool,uint)", p0, p1, p2, p3));
2350 	}
2351 
2352 	function log(bool p0, bool p1, bool p2, string memory p3) internal view {
2353 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool,string)", p0, p1, p2, p3));
2354 	}
2355 
2356 	function log(bool p0, bool p1, bool p2, bool p3) internal view {
2357 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool,bool)", p0, p1, p2, p3));
2358 	}
2359 
2360 	function log(bool p0, bool p1, bool p2, address p3) internal view {
2361 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool,address)", p0, p1, p2, p3));
2362 	}
2363 
2364 	function log(bool p0, bool p1, address p2, uint p3) internal view {
2365 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address,uint)", p0, p1, p2, p3));
2366 	}
2367 
2368 	function log(bool p0, bool p1, address p2, string memory p3) internal view {
2369 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address,string)", p0, p1, p2, p3));
2370 	}
2371 
2372 	function log(bool p0, bool p1, address p2, bool p3) internal view {
2373 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address,bool)", p0, p1, p2, p3));
2374 	}
2375 
2376 	function log(bool p0, bool p1, address p2, address p3) internal view {
2377 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address,address)", p0, p1, p2, p3));
2378 	}
2379 
2380 	function log(bool p0, address p1, uint p2, uint p3) internal view {
2381 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint,uint)", p0, p1, p2, p3));
2382 	}
2383 
2384 	function log(bool p0, address p1, uint p2, string memory p3) internal view {
2385 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint,string)", p0, p1, p2, p3));
2386 	}
2387 
2388 	function log(bool p0, address p1, uint p2, bool p3) internal view {
2389 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint,bool)", p0, p1, p2, p3));
2390 	}
2391 
2392 	function log(bool p0, address p1, uint p2, address p3) internal view {
2393 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint,address)", p0, p1, p2, p3));
2394 	}
2395 
2396 	function log(bool p0, address p1, string memory p2, uint p3) internal view {
2397 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string,uint)", p0, p1, p2, p3));
2398 	}
2399 
2400 	function log(bool p0, address p1, string memory p2, string memory p3) internal view {
2401 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string,string)", p0, p1, p2, p3));
2402 	}
2403 
2404 	function log(bool p0, address p1, string memory p2, bool p3) internal view {
2405 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string,bool)", p0, p1, p2, p3));
2406 	}
2407 
2408 	function log(bool p0, address p1, string memory p2, address p3) internal view {
2409 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string,address)", p0, p1, p2, p3));
2410 	}
2411 
2412 	function log(bool p0, address p1, bool p2, uint p3) internal view {
2413 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool,uint)", p0, p1, p2, p3));
2414 	}
2415 
2416 	function log(bool p0, address p1, bool p2, string memory p3) internal view {
2417 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool,string)", p0, p1, p2, p3));
2418 	}
2419 
2420 	function log(bool p0, address p1, bool p2, bool p3) internal view {
2421 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool,bool)", p0, p1, p2, p3));
2422 	}
2423 
2424 	function log(bool p0, address p1, bool p2, address p3) internal view {
2425 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool,address)", p0, p1, p2, p3));
2426 	}
2427 
2428 	function log(bool p0, address p1, address p2, uint p3) internal view {
2429 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address,uint)", p0, p1, p2, p3));
2430 	}
2431 
2432 	function log(bool p0, address p1, address p2, string memory p3) internal view {
2433 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address,string)", p0, p1, p2, p3));
2434 	}
2435 
2436 	function log(bool p0, address p1, address p2, bool p3) internal view {
2437 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address,bool)", p0, p1, p2, p3));
2438 	}
2439 
2440 	function log(bool p0, address p1, address p2, address p3) internal view {
2441 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address,address)", p0, p1, p2, p3));
2442 	}
2443 
2444 	function log(address p0, uint p1, uint p2, uint p3) internal view {
2445 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,uint,uint)", p0, p1, p2, p3));
2446 	}
2447 
2448 	function log(address p0, uint p1, uint p2, string memory p3) internal view {
2449 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,uint,string)", p0, p1, p2, p3));
2450 	}
2451 
2452 	function log(address p0, uint p1, uint p2, bool p3) internal view {
2453 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,uint,bool)", p0, p1, p2, p3));
2454 	}
2455 
2456 	function log(address p0, uint p1, uint p2, address p3) internal view {
2457 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,uint,address)", p0, p1, p2, p3));
2458 	}
2459 
2460 	function log(address p0, uint p1, string memory p2, uint p3) internal view {
2461 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,string,uint)", p0, p1, p2, p3));
2462 	}
2463 
2464 	function log(address p0, uint p1, string memory p2, string memory p3) internal view {
2465 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,string,string)", p0, p1, p2, p3));
2466 	}
2467 
2468 	function log(address p0, uint p1, string memory p2, bool p3) internal view {
2469 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,string,bool)", p0, p1, p2, p3));
2470 	}
2471 
2472 	function log(address p0, uint p1, string memory p2, address p3) internal view {
2473 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,string,address)", p0, p1, p2, p3));
2474 	}
2475 
2476 	function log(address p0, uint p1, bool p2, uint p3) internal view {
2477 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,bool,uint)", p0, p1, p2, p3));
2478 	}
2479 
2480 	function log(address p0, uint p1, bool p2, string memory p3) internal view {
2481 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,bool,string)", p0, p1, p2, p3));
2482 	}
2483 
2484 	function log(address p0, uint p1, bool p2, bool p3) internal view {
2485 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,bool,bool)", p0, p1, p2, p3));
2486 	}
2487 
2488 	function log(address p0, uint p1, bool p2, address p3) internal view {
2489 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,bool,address)", p0, p1, p2, p3));
2490 	}
2491 
2492 	function log(address p0, uint p1, address p2, uint p3) internal view {
2493 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,address,uint)", p0, p1, p2, p3));
2494 	}
2495 
2496 	function log(address p0, uint p1, address p2, string memory p3) internal view {
2497 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,address,string)", p0, p1, p2, p3));
2498 	}
2499 
2500 	function log(address p0, uint p1, address p2, bool p3) internal view {
2501 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,address,bool)", p0, p1, p2, p3));
2502 	}
2503 
2504 	function log(address p0, uint p1, address p2, address p3) internal view {
2505 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,address,address)", p0, p1, p2, p3));
2506 	}
2507 
2508 	function log(address p0, string memory p1, uint p2, uint p3) internal view {
2509 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint,uint)", p0, p1, p2, p3));
2510 	}
2511 
2512 	function log(address p0, string memory p1, uint p2, string memory p3) internal view {
2513 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint,string)", p0, p1, p2, p3));
2514 	}
2515 
2516 	function log(address p0, string memory p1, uint p2, bool p3) internal view {
2517 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint,bool)", p0, p1, p2, p3));
2518 	}
2519 
2520 	function log(address p0, string memory p1, uint p2, address p3) internal view {
2521 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint,address)", p0, p1, p2, p3));
2522 	}
2523 
2524 	function log(address p0, string memory p1, string memory p2, uint p3) internal view {
2525 		_sendLogPayload(abi.encodeWithSignature("log(address,string,string,uint)", p0, p1, p2, p3));
2526 	}
2527 
2528 	function log(address p0, string memory p1, string memory p2, string memory p3) internal view {
2529 		_sendLogPayload(abi.encodeWithSignature("log(address,string,string,string)", p0, p1, p2, p3));
2530 	}
2531 
2532 	function log(address p0, string memory p1, string memory p2, bool p3) internal view {
2533 		_sendLogPayload(abi.encodeWithSignature("log(address,string,string,bool)", p0, p1, p2, p3));
2534 	}
2535 
2536 	function log(address p0, string memory p1, string memory p2, address p3) internal view {
2537 		_sendLogPayload(abi.encodeWithSignature("log(address,string,string,address)", p0, p1, p2, p3));
2538 	}
2539 
2540 	function log(address p0, string memory p1, bool p2, uint p3) internal view {
2541 		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool,uint)", p0, p1, p2, p3));
2542 	}
2543 
2544 	function log(address p0, string memory p1, bool p2, string memory p3) internal view {
2545 		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool,string)", p0, p1, p2, p3));
2546 	}
2547 
2548 	function log(address p0, string memory p1, bool p2, bool p3) internal view {
2549 		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool,bool)", p0, p1, p2, p3));
2550 	}
2551 
2552 	function log(address p0, string memory p1, bool p2, address p3) internal view {
2553 		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool,address)", p0, p1, p2, p3));
2554 	}
2555 
2556 	function log(address p0, string memory p1, address p2, uint p3) internal view {
2557 		_sendLogPayload(abi.encodeWithSignature("log(address,string,address,uint)", p0, p1, p2, p3));
2558 	}
2559 
2560 	function log(address p0, string memory p1, address p2, string memory p3) internal view {
2561 		_sendLogPayload(abi.encodeWithSignature("log(address,string,address,string)", p0, p1, p2, p3));
2562 	}
2563 
2564 	function log(address p0, string memory p1, address p2, bool p3) internal view {
2565 		_sendLogPayload(abi.encodeWithSignature("log(address,string,address,bool)", p0, p1, p2, p3));
2566 	}
2567 
2568 	function log(address p0, string memory p1, address p2, address p3) internal view {
2569 		_sendLogPayload(abi.encodeWithSignature("log(address,string,address,address)", p0, p1, p2, p3));
2570 	}
2571 
2572 	function log(address p0, bool p1, uint p2, uint p3) internal view {
2573 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint,uint)", p0, p1, p2, p3));
2574 	}
2575 
2576 	function log(address p0, bool p1, uint p2, string memory p3) internal view {
2577 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint,string)", p0, p1, p2, p3));
2578 	}
2579 
2580 	function log(address p0, bool p1, uint p2, bool p3) internal view {
2581 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint,bool)", p0, p1, p2, p3));
2582 	}
2583 
2584 	function log(address p0, bool p1, uint p2, address p3) internal view {
2585 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint,address)", p0, p1, p2, p3));
2586 	}
2587 
2588 	function log(address p0, bool p1, string memory p2, uint p3) internal view {
2589 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string,uint)", p0, p1, p2, p3));
2590 	}
2591 
2592 	function log(address p0, bool p1, string memory p2, string memory p3) internal view {
2593 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string,string)", p0, p1, p2, p3));
2594 	}
2595 
2596 	function log(address p0, bool p1, string memory p2, bool p3) internal view {
2597 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string,bool)", p0, p1, p2, p3));
2598 	}
2599 
2600 	function log(address p0, bool p1, string memory p2, address p3) internal view {
2601 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string,address)", p0, p1, p2, p3));
2602 	}
2603 
2604 	function log(address p0, bool p1, bool p2, uint p3) internal view {
2605 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool,uint)", p0, p1, p2, p3));
2606 	}
2607 
2608 	function log(address p0, bool p1, bool p2, string memory p3) internal view {
2609 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool,string)", p0, p1, p2, p3));
2610 	}
2611 
2612 	function log(address p0, bool p1, bool p2, bool p3) internal view {
2613 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool,bool)", p0, p1, p2, p3));
2614 	}
2615 
2616 	function log(address p0, bool p1, bool p2, address p3) internal view {
2617 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool,address)", p0, p1, p2, p3));
2618 	}
2619 
2620 	function log(address p0, bool p1, address p2, uint p3) internal view {
2621 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address,uint)", p0, p1, p2, p3));
2622 	}
2623 
2624 	function log(address p0, bool p1, address p2, string memory p3) internal view {
2625 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address,string)", p0, p1, p2, p3));
2626 	}
2627 
2628 	function log(address p0, bool p1, address p2, bool p3) internal view {
2629 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address,bool)", p0, p1, p2, p3));
2630 	}
2631 
2632 	function log(address p0, bool p1, address p2, address p3) internal view {
2633 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address,address)", p0, p1, p2, p3));
2634 	}
2635 
2636 	function log(address p0, address p1, uint p2, uint p3) internal view {
2637 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint,uint)", p0, p1, p2, p3));
2638 	}
2639 
2640 	function log(address p0, address p1, uint p2, string memory p3) internal view {
2641 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint,string)", p0, p1, p2, p3));
2642 	}
2643 
2644 	function log(address p0, address p1, uint p2, bool p3) internal view {
2645 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint,bool)", p0, p1, p2, p3));
2646 	}
2647 
2648 	function log(address p0, address p1, uint p2, address p3) internal view {
2649 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint,address)", p0, p1, p2, p3));
2650 	}
2651 
2652 	function log(address p0, address p1, string memory p2, uint p3) internal view {
2653 		_sendLogPayload(abi.encodeWithSignature("log(address,address,string,uint)", p0, p1, p2, p3));
2654 	}
2655 
2656 	function log(address p0, address p1, string memory p2, string memory p3) internal view {
2657 		_sendLogPayload(abi.encodeWithSignature("log(address,address,string,string)", p0, p1, p2, p3));
2658 	}
2659 
2660 	function log(address p0, address p1, string memory p2, bool p3) internal view {
2661 		_sendLogPayload(abi.encodeWithSignature("log(address,address,string,bool)", p0, p1, p2, p3));
2662 	}
2663 
2664 	function log(address p0, address p1, string memory p2, address p3) internal view {
2665 		_sendLogPayload(abi.encodeWithSignature("log(address,address,string,address)", p0, p1, p2, p3));
2666 	}
2667 
2668 	function log(address p0, address p1, bool p2, uint p3) internal view {
2669 		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool,uint)", p0, p1, p2, p3));
2670 	}
2671 
2672 	function log(address p0, address p1, bool p2, string memory p3) internal view {
2673 		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool,string)", p0, p1, p2, p3));
2674 	}
2675 
2676 	function log(address p0, address p1, bool p2, bool p3) internal view {
2677 		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool,bool)", p0, p1, p2, p3));
2678 	}
2679 
2680 	function log(address p0, address p1, bool p2, address p3) internal view {
2681 		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool,address)", p0, p1, p2, p3));
2682 	}
2683 
2684 	function log(address p0, address p1, address p2, uint p3) internal view {
2685 		_sendLogPayload(abi.encodeWithSignature("log(address,address,address,uint)", p0, p1, p2, p3));
2686 	}
2687 
2688 	function log(address p0, address p1, address p2, string memory p3) internal view {
2689 		_sendLogPayload(abi.encodeWithSignature("log(address,address,address,string)", p0, p1, p2, p3));
2690 	}
2691 
2692 	function log(address p0, address p1, address p2, bool p3) internal view {
2693 		_sendLogPayload(abi.encodeWithSignature("log(address,address,address,bool)", p0, p1, p2, p3));
2694 	}
2695 
2696 	function log(address p0, address p1, address p2, address p3) internal view {
2697 		_sendLogPayload(abi.encodeWithSignature("log(address,address,address,address)", p0, p1, p2, p3));
2698 	}
2699 
2700 }
2701 
2702 // File: contracts/tokens/RebasingGToken.sol
2703 
2704 pragma solidity >=0.6.0 <0.7.0;
2705 
2706 
2707 
2708 
2709 
2710 contract RebasingGToken is GToken {
2711     using SafeERC20 for IERC20;
2712     using SafeMath for uint256;
2713 
2714     event LogTransfer(address indexed sender, address indexed recipient, uint256 indexed amount);
2715 
2716     constructor(
2717         string memory name,
2718         string memory symbol,
2719         address controller
2720     ) public GToken(name, symbol, controller) {}
2721 
2722     function totalSupply() public view override returns (uint256) {
2723         uint256 f = factor();
2724         return f > 0 ? applyFactor(totalSupplyBase(), f, false) : 0;
2725     }
2726 
2727     function balanceOf(address account) public view override returns (uint256) {
2728         uint256 f = factor();
2729         return f > 0 ? applyFactor(balanceOfBase(account), f, false) : 0;
2730     }
2731 
2732     function transfer(address recipient, uint256 amount) public override returns (bool) {
2733         uint256 transferAmount = applyFactor(amount, factor(), true);
2734         super._transfer(msg.sender, recipient, transferAmount, amount);
2735         emit LogTransfer(msg.sender, recipient, amount);
2736         return true;
2737     }
2738 
2739     function getPricePerShare() external view override returns (uint256) {
2740         return BASE;
2741     }
2742 
2743     function getShareAssets(uint256 shares) external view override returns (uint256) {
2744         return shares;
2745     }
2746 
2747     function getAssets(address account) external view override returns (uint256) {
2748         return balanceOf(account);
2749     }
2750 
2751     function mint(
2752         address account,
2753         uint256 _factor,
2754         uint256 amount
2755     ) external override onlyWhitelist {
2756         require(account != address(0), "mint: 0x");
2757         require(amount > 0, "Amount is zero.");
2758         uint256 mintAmount = applyFactor(amount, _factor, true);
2759         _mint(account, mintAmount, amount);
2760     }
2761 
2762     function burn(
2763         address account,
2764         uint256 _factor,
2765         uint256 amount
2766     ) external override onlyWhitelist {
2767         require(account != address(0), "burn: 0x");
2768         require(amount > 0, "Amount is zero.");
2769         uint256 burnAmount = applyFactor(amount, _factor, true);
2770         _burn(account, burnAmount, amount);
2771     }
2772 
2773     function burnAll(address account) external override onlyWhitelist {
2774         require(account != address(0), "burnAll: 0x");
2775         uint256 burnAmount = balanceOfBase(account);
2776         uint256 amount = applyFactor(burnAmount, factor(), false);
2777         _burn(account, burnAmount, amount);
2778     }
2779 
2780     function transferFrom(
2781         address sender,
2782         address recipient,
2783         uint256 amount
2784     ) public virtual override returns (bool) {
2785         super._decreaseApproved(sender, msg.sender, amount);
2786         uint256 transferAmount = applyFactor(amount, factor(), true);
2787         super._transfer(sender, recipient, transferAmount, amount);
2788         return true;
2789     }
2790 }