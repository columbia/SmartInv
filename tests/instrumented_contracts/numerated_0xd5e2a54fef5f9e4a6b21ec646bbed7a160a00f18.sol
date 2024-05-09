1 // SPDX-License-Identifier: UNLICENSED
2 pragma solidity ^0.6.0;
3 
4 /**
5  * @dev Wrappers over Solidity's arithmetic operations with added overflow
6  * checks.
7  *
8  * Arithmetic operations in Solidity wrap on overflow. This can easily result
9  * in bugs, because programmers usually assume that an overflow raises an
10  * error, which is the standard behavior in high level programming languages.
11  * `SafeMath` restores this intuition by reverting the transaction when an
12  * operation overflows.
13  *
14  * Using this library instead of the unchecked operations eliminates an entire
15  * class of bugs, so it's recommended to use it always.
16  */
17 library SafeMath {
18     /**
19      * @dev Returns the addition of two unsigned integers, reverting on
20      * overflow.
21      *
22      * Counterpart to Solidity's `+` operator.
23      *
24      * Requirements:
25      *
26      * - Addition cannot overflow.
27      */
28     function add(uint256 a, uint256 b) internal pure returns (uint256) {
29         uint256 c = a + b;
30         require(c >= a, "SafeMath: addition overflow");
31 
32         return c;
33     }
34 
35     /**
36      * @dev Returns the subtraction of two unsigned integers, reverting on
37      * overflow (when the result is negative).
38      *
39      * Counterpart to Solidity's `-` operator.
40      *
41      * Requirements:
42      *
43      * - Subtraction cannot overflow.
44      */
45     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
46         return sub(a, b, "SafeMath: subtraction overflow");
47     }
48 
49     /**
50      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
51      * overflow (when the result is negative).
52      *
53      * Counterpart to Solidity's `-` operator.
54      *
55      * Requirements:
56      *
57      * - Subtraction cannot overflow.
58      */
59     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
60         require(b <= a, errorMessage);
61         uint256 c = a - b;
62 
63         return c;
64     }
65 
66     /**
67      * @dev Returns the multiplication of two unsigned integers, reverting on
68      * overflow.
69      *
70      * Counterpart to Solidity's `*` operator.
71      *
72      * Requirements:
73      *
74      * - Multiplication cannot overflow.
75      */
76     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
77         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
78         // benefit is lost if 'b' is also tested.
79         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
80         if (a == 0) {
81             return 0;
82         }
83 
84         uint256 c = a * b;
85         require(c / a == b, "SafeMath: multiplication overflow");
86 
87         return c;
88     }
89 
90     /**
91      * @dev Returns the integer division of two unsigned integers. Reverts on
92      * division by zero. The result is rounded towards zero.
93      *
94      * Counterpart to Solidity's `/` operator. Note: this function uses a
95      * `revert` opcode (which leaves remaining gas untouched) while Solidity
96      * uses an invalid opcode to revert (consuming all remaining gas).
97      *
98      * Requirements:
99      *
100      * - The divisor cannot be zero.
101      */
102     function div(uint256 a, uint256 b) internal pure returns (uint256) {
103         return div(a, b, "SafeMath: division by zero");
104     }
105 
106     /**
107      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
108      * division by zero. The result is rounded towards zero.
109      *
110      * Counterpart to Solidity's `/` operator. Note: this function uses a
111      * `revert` opcode (which leaves remaining gas untouched) while Solidity
112      * uses an invalid opcode to revert (consuming all remaining gas).
113      *
114      * Requirements:
115      *
116      * - The divisor cannot be zero.
117      */
118     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
119         require(b > 0, errorMessage);
120         uint256 c = a / b;
121         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
122 
123         return c;
124     }
125 
126     /**
127      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
128      * Reverts when dividing by zero.
129      *
130      * Counterpart to Solidity's `%` operator. This function uses a `revert`
131      * opcode (which leaves remaining gas untouched) while Solidity uses an
132      * invalid opcode to revert (consuming all remaining gas).
133      *
134      * Requirements:
135      *
136      * - The divisor cannot be zero.
137      */
138     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
139         return mod(a, b, "SafeMath: modulo by zero");
140     }
141 
142     /**
143      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
144      * Reverts with custom message when dividing by zero.
145      *
146      * Counterpart to Solidity's `%` operator. This function uses a `revert`
147      * opcode (which leaves remaining gas untouched) while Solidity uses an
148      * invalid opcode to revert (consuming all remaining gas).
149      *
150      * Requirements:
151      *
152      * - The divisor cannot be zero.
153      */
154     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
155         require(b != 0, errorMessage);
156         return a % b;
157     }
158 }
159 
160 
161 /*
162  * @dev Provides information about the current execution context, including the
163  * sender of the transaction and its data. While these are generally available
164  * via msg.sender and msg.data, they should not be accessed in such a direct
165  * manner, since when dealing with GSN meta-transactions the account sending and
166  * paying for execution may not be the actual sender (as far as an application
167  * is concerned).
168  *
169  * This contract is only required for intermediate, library-like contracts.
170  */
171 abstract contract Context {
172     function _msgSender() internal view virtual returns (address payable) {
173         return msg.sender;
174     }
175 
176     function _msgData() internal view virtual returns (bytes memory) {
177         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
178         return msg.data;
179     }
180 }
181 
182 
183 /**
184  * @dev Collection of functions related to the address type
185  */
186 library Address {
187     /**
188      * @dev Returns true if `account` is a contract.
189      *
190      * [IMPORTANT]
191      * ====
192      * It is unsafe to assume that an address for which this function returns
193      * false is an externally-owned account (EOA) and not a contract.
194      *
195      * Among others, `isContract` will return false for the following
196      * types of addresses:
197      *
198      *  - an externally-owned account
199      *  - a contract in construction
200      *  - an address where a contract will be created
201      *  - an address where a contract lived, but was destroyed
202      * ====
203      */
204     function isContract(address account) internal view returns (bool) {
205         // This method relies on extcodesize, which returns 0 for contracts in
206         // construction, since the code is only stored at the end of the
207         // constructor execution.
208 
209         uint256 size;
210         // solhint-disable-next-line no-inline-assembly
211         assembly { size := extcodesize(account) }
212         return size > 0;
213     }
214 
215     /**
216      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
217      * `recipient`, forwarding all available gas and reverting on errors.
218      *
219      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
220      * of certain opcodes, possibly making contracts go over the 2300 gas limit
221      * imposed by `transfer`, making them unable to receive funds via
222      * `transfer`. {sendValue} removes this limitation.
223      *
224      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
225      *
226      * IMPORTANT: because control is transferred to `recipient`, care must be
227      * taken to not create reentrancy vulnerabilities. Consider using
228      * {ReentrancyGuard} or the
229      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
230      */
231     function sendValue(address payable recipient, uint256 amount) internal {
232         require(address(this).balance >= amount, "Address: insufficient balance");
233 
234         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
235         (bool success, ) = recipient.call{ value: amount }("");
236         require(success, "Address: unable to send value, recipient may have reverted");
237     }
238 
239     /**
240      * @dev Performs a Solidity function call using a low level `call`. A
241      * plain`call` is an unsafe replacement for a function call: use this
242      * function instead.
243      *
244      * If `target` reverts with a revert reason, it is bubbled up by this
245      * function (like regular Solidity function calls).
246      *
247      * Returns the raw returned data. To convert to the expected return value,
248      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
249      *
250      * Requirements:
251      *
252      * - `target` must be a contract.
253      * - calling `target` with `data` must not revert.
254      *
255      * _Available since v3.1._
256      */
257     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
258       return functionCall(target, data, "Address: low-level call failed");
259     }
260 
261     /**
262      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
263      * `errorMessage` as a fallback revert reason when `target` reverts.
264      *
265      * _Available since v3.1._
266      */
267     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
268         return functionCallWithValue(target, data, 0, errorMessage);
269     }
270 
271     /**
272      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
273      * but also transferring `value` wei to `target`.
274      *
275      * Requirements:
276      *
277      * - the calling contract must have an ETH balance of at least `value`.
278      * - the called Solidity function must be `payable`.
279      *
280      * _Available since v3.1._
281      */
282     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
283         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
284     }
285 
286     /**
287      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
288      * with `errorMessage` as a fallback revert reason when `target` reverts.
289      *
290      * _Available since v3.1._
291      */
292     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
293         require(address(this).balance >= value, "Address: insufficient balance for call");
294         require(isContract(target), "Address: call to non-contract");
295 
296         // solhint-disable-next-line avoid-low-level-calls
297         (bool success, bytes memory returndata) = target.call{ value: value }(data);
298         return _verifyCallResult(success, returndata, errorMessage);
299     }
300 
301     /**
302      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
303      * but performing a static call.
304      *
305      * _Available since v3.3._
306      */
307     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
308         return functionStaticCall(target, data, "Address: low-level static call failed");
309     }
310 
311     /**
312      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
313      * but performing a static call.
314      *
315      * _Available since v3.3._
316      */
317     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
318         require(isContract(target), "Address: static call to non-contract");
319 
320         // solhint-disable-next-line avoid-low-level-calls
321         (bool success, bytes memory returndata) = target.staticcall(data);
322         return _verifyCallResult(success, returndata, errorMessage);
323     }
324 
325     /**
326      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
327      * but performing a delegate call.
328      *
329      * _Available since v3.3._
330      */
331     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
332         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
333     }
334 
335     /**
336      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
337      * but performing a delegate call.
338      *
339      * _Available since v3.3._
340      */
341     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
342         require(isContract(target), "Address: delegate call to non-contract");
343 
344         // solhint-disable-next-line avoid-low-level-calls
345         (bool success, bytes memory returndata) = target.delegatecall(data);
346         return _verifyCallResult(success, returndata, errorMessage);
347     }
348 
349     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
350         if (success) {
351             return returndata;
352         } else {
353             // Look for revert reason and bubble it up if present
354             if (returndata.length > 0) {
355                 // The easiest way to bubble the revert reason is using memory via assembly
356 
357                 // solhint-disable-next-line no-inline-assembly
358                 assembly {
359                     let returndata_size := mload(returndata)
360                     revert(add(32, returndata), returndata_size)
361                 }
362             } else {
363                 revert(errorMessage);
364             }
365         }
366     }
367 }
368 
369 
370 /**
371  * @title Ownable
372  * @dev The Ownable contract has an owner address, and provides basic authorization control
373  * functions, this simplifies the implementation of "user permissions".
374  */
375 contract Ownable {
376   address public owner;
377 
378 
379   event OwnershipTransferred(
380     address indexed previousOwner,
381     address indexed newOwner
382   );
383 
384 
385   /**
386    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
387    * account.
388    */
389   constructor() public {
390     owner = msg.sender;
391   }
392 
393   /**
394    * @dev Throws if called by any account other than the owner.
395    */
396   modifier onlyOwner() {
397     require(msg.sender == owner);
398     _;
399   }
400 
401   /**
402    * @dev Allows the current owner to transfer control of the contract to a newOwner.
403    * @param _newOwner The address to transfer ownership to.
404    */
405   function transferOwnership(address _newOwner) public onlyOwner {
406     _transferOwnership(_newOwner);
407   }
408 
409   /**
410    * @dev Transfers control of the contract to a newOwner.
411    * @param _newOwner The address to transfer ownership to.
412    */
413   function _transferOwnership(address _newOwner) internal {
414     require(_newOwner != address(0));
415     emit OwnershipTransferred(owner, _newOwner);
416     owner = _newOwner;
417   }
418 }
419 
420 
421 /**
422  * @dev Interface of the ERC20 standard as defined in the EIP.
423  */
424 interface IERC20 {
425     /**
426      * @dev Returns the amount of tokens in existence.
427      */
428     function totalSupply() external view returns (uint256);
429 
430     /**
431      * @dev Returns the amount of tokens owned by `account`.
432      */
433     function balanceOf(address account) external view returns (uint256);
434 
435     /**
436      * @dev Moves `amount` tokens from the caller's account to `recipient`.
437      *
438      * Returns a boolean value indicating whether the operation succeeded.
439      *
440      * Emits a {Transfer} event.
441      */
442     function transfer(address recipient, uint256 amount) external returns (bool);
443 
444     /**
445      * @dev Returns the remaining number of tokens that `spender` will be
446      * allowed to spend on behalf of `owner` through {transferFrom}. This is
447      * zero by default.
448      *
449      * This value changes when {approve} or {transferFrom} are called.
450      */
451     function allowance(address owner, address spender) external view returns (uint256);
452 
453     /**
454      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
455      *
456      * Returns a boolean value indicating whether the operation succeeded.
457      *
458      * IMPORTANT: Beware that changing an allowance with this method brings the risk
459      * that someone may use both the old and the new allowance by unfortunate
460      * transaction ordering. One possible solution to mitigate this race
461      * condition is to first reduce the spender's allowance to 0 and set the
462      * desired value afterwards:
463      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
464      *
465      * Emits an {Approval} event.
466      */
467     function approve(address spender, uint256 amount) external returns (bool);
468 
469     /**
470      * @dev Moves `amount` tokens from `sender` to `recipient` using the
471      * allowance mechanism. `amount` is then deducted from the caller's
472      * allowance.
473      *
474      * Returns a boolean value indicating whether the operation succeeded.
475      *
476      * Emits a {Transfer} event.
477      */
478     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
479 
480     /**
481      * @dev Emitted when `value` tokens are moved from one account (`from`) to
482      * another (`to`).
483      *
484      * Note that `value` may be zero.
485      */
486     event Transfer(address indexed from, address indexed to, uint256 value);
487 
488     /**
489      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
490      * a call to {approve}. `value` is the new allowance.
491      */
492     event Approval(address indexed owner, address indexed spender, uint256 value);
493 }
494 
495 
496 
497 /**
498  * @dev Implementation of the {IERC20} interface.
499  *
500  * This implementation is agnostic to the way tokens are created. This means
501  * that a supply mechanism has to be added in a derived contract using {_mint}.
502  * For a generic mechanism see {ERC20PresetMinterPauser}.
503  *
504  * TIP: For a detailed writeup see our guide
505  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
506  * to implement supply mechanisms].
507  *
508  * We have followed general OpenZeppelin guidelines: functions revert instead
509  * of returning `false` on failure. This behavior is nonetheless conventional
510  * and does not conflict with the expectations of ERC20 applications.
511  *
512  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
513  * This allows applications to reconstruct the allowance for all accounts just
514  * by listening to said events. Other implementations of the EIP may not emit
515  * these events, as it isn't required by the specification.
516  *
517  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
518  * functions have been added to mitigate the well-known issues around setting
519  * allowances. See {IERC20-approve}.
520  */
521 contract ERC20 is Context, IERC20 {
522     using SafeMath for uint256;
523 
524     mapping (address => uint256) private _balances;
525 
526     mapping (address => mapping (address => uint256)) private _allowances;
527 
528     uint256 private _totalSupply;
529 
530     string private _name;
531     string private _symbol;
532     uint8 private _decimals;
533 
534     /**
535      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
536      * a default value of 18.
537      *
538      * To select a different value for {decimals}, use {_setupDecimals}.
539      *
540      * All three of these values are immutable: they can only be set once during
541      * construction.
542      */
543     constructor (string memory name, string memory symbol) public {
544         _name = name;
545         _symbol = symbol;
546         _decimals = 18;
547     }
548 
549     /**
550      * @dev Returns the name of the token.
551      */
552     function name() public view returns (string memory) {
553         return _name;
554     }
555 
556     /**
557      * @dev Returns the symbol of the token, usually a shorter version of the
558      * name.
559      */
560     function symbol() public view returns (string memory) {
561         return _symbol;
562     }
563 
564     /**
565      * @dev Returns the number of decimals used to get its user representation.
566      * For example, if `decimals` equals `2`, a balance of `505` tokens should
567      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
568      *
569      * Tokens usually opt for a value of 18, imitating the relationship between
570      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
571      * called.
572      *
573      * NOTE: This information is only used for _display_ purposes: it in
574      * no way affects any of the arithmetic of the contract, including
575      * {IERC20-balanceOf} and {IERC20-transfer}.
576      */
577     function decimals() public view returns (uint8) {
578         return _decimals;
579     }
580 
581     /**
582      * @dev See {IERC20-totalSupply}.
583      */
584     function totalSupply() public view override returns (uint256) {
585         return _totalSupply;
586     }
587 
588     /**
589      * @dev See {IERC20-balanceOf}.
590      */
591     function balanceOf(address account) public view override returns (uint256) {
592         return _balances[account];
593     }
594 
595     /**
596      * @dev See {IERC20-transfer}.
597      *
598      * Requirements:
599      *
600      * - `recipient` cannot be the zero address.
601      * - the caller must have a balance of at least `amount`.
602      */
603     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
604         _transfer(_msgSender(), recipient, amount);
605         return true;
606     }
607 
608     /**
609      * @dev See {IERC20-allowance}.
610      */
611     function allowance(address owner, address spender) public view virtual override returns (uint256) {
612         return _allowances[owner][spender];
613     }
614 
615     /**
616      * @dev See {IERC20-approve}.
617      *
618      * Requirements:
619      *
620      * - `spender` cannot be the zero address.
621      */
622     function approve(address spender, uint256 amount) public virtual override returns (bool) {
623         _approve(_msgSender(), spender, amount);
624         return true;
625     }
626 
627     /**
628      * @dev See {IERC20-transferFrom}.
629      *
630      * Emits an {Approval} event indicating the updated allowance. This is not
631      * required by the EIP. See the note at the beginning of {ERC20}.
632      *
633      * Requirements:
634      *
635      * - `sender` and `recipient` cannot be the zero address.
636      * - `sender` must have a balance of at least `amount`.
637      * - the caller must have allowance for ``sender``'s tokens of at least
638      * `amount`.
639      */
640     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
641         _transfer(sender, recipient, amount);
642         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
643         return true;
644     }
645 
646     /**
647      * @dev Atomically increases the allowance granted to `spender` by the caller.
648      *
649      * This is an alternative to {approve} that can be used as a mitigation for
650      * problems described in {IERC20-approve}.
651      *
652      * Emits an {Approval} event indicating the updated allowance.
653      *
654      * Requirements:
655      *
656      * - `spender` cannot be the zero address.
657      */
658     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
659         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
660         return true;
661     }
662 
663     /**
664      * @dev Atomically decreases the allowance granted to `spender` by the caller.
665      *
666      * This is an alternative to {approve} that can be used as a mitigation for
667      * problems described in {IERC20-approve}.
668      *
669      * Emits an {Approval} event indicating the updated allowance.
670      *
671      * Requirements:
672      *
673      * - `spender` cannot be the zero address.
674      * - `spender` must have allowance for the caller of at least
675      * `subtractedValue`.
676      */
677     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
678         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
679         return true;
680     }
681 
682     /**
683      * @dev Moves tokens `amount` from `sender` to `recipient`.
684      *
685      * This is internal function is equivalent to {transfer}, and can be used to
686      * e.g. implement automatic token fees, slashing mechanisms, etc.
687      *
688      * Emits a {Transfer} event.
689      *
690      * Requirements:
691      *
692      * - `sender` cannot be the zero address.
693      * - `recipient` cannot be the zero address.
694      * - `sender` must have a balance of at least `amount`.
695      */
696     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
697         require(sender != address(0), "ERC20: transfer from the zero address");
698         require(recipient != address(0), "ERC20: transfer to the zero address");
699 
700         _beforeTokenTransfer(sender, recipient, amount);
701 
702         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
703         _balances[recipient] = _balances[recipient].add(amount);
704         emit Transfer(sender, recipient, amount);
705     }
706 
707     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
708      * the total supply.
709      *
710      * Emits a {Transfer} event with `from` set to the zero address.
711      *
712      * Requirements:
713      *
714      * - `to` cannot be the zero address.
715      */
716     function _mint(address account, uint256 amount) internal virtual {
717         require(account != address(0), "ERC20: mint to the zero address");
718 
719         _beforeTokenTransfer(address(0), account, amount);
720 
721         _totalSupply = _totalSupply.add(amount);
722         _balances[account] = _balances[account].add(amount);
723         emit Transfer(address(0), account, amount);
724     }
725 
726     /**
727      * @dev Destroys `amount` tokens from `account`, reducing the
728      * total supply.
729      *
730      * Emits a {Transfer} event with `to` set to the zero address.
731      *
732      * Requirements:
733      *
734      * - `account` cannot be the zero address.
735      * - `account` must have at least `amount` tokens.
736      */
737     function _burn(address account, uint256 amount) internal virtual {
738         require(account != address(0), "ERC20: burn from the zero address");
739 
740         _beforeTokenTransfer(account, address(0), amount);
741 
742         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
743         _totalSupply = _totalSupply.sub(amount);
744         emit Transfer(account, address(0), amount);
745     }
746 
747     /**
748      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
749      *
750      * This internal function is equivalent to `approve`, and can be used to
751      * e.g. set automatic allowances for certain subsystems, etc.
752      *
753      * Emits an {Approval} event.
754      *
755      * Requirements:
756      *
757      * - `owner` cannot be the zero address.
758      * - `spender` cannot be the zero address.
759      */
760     function _approve(address owner, address spender, uint256 amount) internal virtual {
761         require(owner != address(0), "ERC20: approve from the zero address");
762         require(spender != address(0), "ERC20: approve to the zero address");
763 
764         _allowances[owner][spender] = amount;
765         emit Approval(owner, spender, amount);
766     }
767 
768     /**
769      * @dev Sets {decimals} to a value other than the default one of 18.
770      *
771      * WARNING: This function should only be called from the constructor. Most
772      * applications that interact with token contracts will not expect
773      * {decimals} to ever change, and may work incorrectly if it does.
774      */
775     function _setupDecimals(uint8 decimals_) internal {
776         _decimals = decimals_;
777     }
778 
779     /**
780      * @dev Hook that is called before any transfer of tokens. This includes
781      * minting and burning.
782      *
783      * Calling conditions:
784      *
785      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
786      * will be to transferred to `to`.
787      * - when `from` is zero, `amount` tokens will be minted for `to`.
788      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
789      * - `from` and `to` are never both zero.
790      *
791      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
792      */
793     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
794 }
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
868 contract IERC20Stake{
869     function _beforeTokenTransfer(address from, address to, uint256 amount) public virtual { }
870 }
871 
872 
873 // https://developer.makerdao.com/feeds/
874 // eth_usd rate provider https://etherscan.io/address/0x729D19f657BD0614b4985Cf1D82531c67569197B
875 contract  IUsdMedianizer{
876    function read() view public virtual returns (bytes32) {
877        return 0;
878    }
879 }
880 
881 
882 contract BeforeCoinMarketCap is ERC20, Ownable {
883     
884     using SafeERC20 for ERC20;
885 
886     uint256 _totalSupply = 10000000000 * 1 ether;
887     
888     //team
889     uint256 public constant team_amount_1      = 105000000 * 1 ether; 
890     uint256 public constant team_amount_2      = 585000000 * 1 ether; 
891     uint256 public constant team_amount_3      = 105000000 * 1 ether; 
892     uint256 public constant investor_amount    = 505000000 * 1 ether; 
893     uint256 public constant main_wallet_amount = 8700000000 * 1 ether; 
894     
895     address public constant _wallet_team1 = 0x3C017A49ee7Ff4Db79BBc56e5876Ec6b701fb02f;
896     address public constant _wallet_team2 = 0xCF98f1003989EaccF07b91971432c80B5D9589b0;
897     address public constant _wallet_team3 = 0x4D00E7e4fF9248c0aaB6C3Ff6b491548c32F09C5;
898     address public constant _wallet_investor = 0xe74Fc57a018d04EcF0c67C765e59c5C2eb8bD652;
899     address public constant _main_wallet =  0xB51672f88b935567Ae5bc1713EE63C06a77527CE;
900     
901     //limits
902     uint public year_half_limit_date = now + 182 days;  
903     uint public year1_limit_date = now + 365 days;  
904     uint public year2_limit_date = now + 2*365 days;  
905     uint public year3_limit_date = now + 3*365 days;
906   
907     uint8 public year1_percent = 90;
908     uint8 public year2_percent = 80;
909     uint8 public year3_percent = 50;
910     
911     address public stake_contract;
912     
913     
914     constructor() public ERC20("BeforeCoinMarketCap", "BCMC1") {
915          
916          _mint(msg.sender, _totalSupply);
917          
918          transfer(_wallet_team1, team_amount_1);
919          transfer(_wallet_team2, team_amount_2);
920          transfer(_wallet_team3, team_amount_3);
921          transfer(_wallet_investor, investor_amount);
922          transfer(_main_wallet, main_wallet_amount);
923             
924     }
925     
926     function setStakeContract(address newAddress) external onlyOwner{
927         stake_contract = newAddress;
928     }
929     
930     function BurnTokens() external onlyOwner{
931         
932         require(now > year_half_limit_date, "You can burn tokens after half a year");
933         
934         _burn(address(this), balanceOf(address(this)));
935         
936     }
937     
938     function _beforeTokenTransfer(address from, address to, uint256 amount) internal override
939     {
940         uint256 limited_balance = 0;
941         
942         if(from==_wallet_team1){
943            limited_balance = team_amount_1;
944         } 
945         else if(from==_wallet_team2){
946            limited_balance = team_amount_2;
947         }  
948         else if(from==_wallet_team3){
949            limited_balance = team_amount_3;
950         }
951         else if(from==_wallet_investor){
952            limited_balance = investor_amount;
953         }
954         
955         if(limited_balance > 0){
956             
957             uint8 percent = 0;
958             
959             if(now<= year1_limit_date){
960                 percent = year1_percent;
961             } 
962             else if(now<= year2_limit_date){
963                 percent = year2_percent;
964             }
965             else if(now<= year3_limit_date){
966                 percent = year3_percent;
967             }
968             
969             if(percent > 0){
970                 require(balanceOf(from) >= limited_balance.mul(percent).div(100).add(amount), "You have limit for withdraw");
971             }
972 
973         }
974         
975         if(stake_contract != address(0)){
976             IERC20Stake(stake_contract)._beforeTokenTransfer(from, to, amount);
977         }
978         
979     }
980 
981 }