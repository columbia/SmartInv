1 // ERC20/ERC223 Token for iOWN
2 
3 // File: contracts/math/SafeMath.sol
4 
5 pragma solidity ^0.5.11;
6 
7 /**
8  * @dev Wrappers over Solidity's arithmetic operations with added overflow
9  * checks.
10  *
11  * Arithmetic operations in Solidity wrap on overflow. This can easily result
12  * in bugs, because programmers usually assume that an overflow raises an
13  * error, which is the standard behavior in high level programming languages.
14  * `SafeMath` restores this intuition by reverting the transaction when an
15  * operation overflows.
16  *
17  * Using this library instead of the unchecked operations eliminates an entire
18  * class of bugs, so it's recommended to use it always.
19  */
20 library SafeMath {
21     /**
22      * @dev Returns the addition of two unsigned integers, reverting on
23      * overflow.
24      *
25      * Counterpart to Solidity's `+` operator.
26      *
27      * Requirements:
28      * - Addition cannot overflow.
29      */
30     function add(uint256 a, uint256 b) internal pure returns (uint256) {
31         uint256 c = a + b;
32         require(c >= a, "SafeMath: addition overflow");
33 
34         return c;
35     }
36 
37     /**
38      * @dev Returns the subtraction of two unsigned integers, reverting on
39      * overflow (when the result is negative).
40      *
41      * Counterpart to Solidity's `-` operator.
42      *
43      * Requirements:
44      * - Subtraction cannot overflow.
45      */
46     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
47         return sub(a, b, "SafeMath: subtraction overflow");
48     }
49 
50     /**
51      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
52      * overflow (when the result is negative).
53      *
54      * Counterpart to Solidity's `-` operator.
55      *
56      * Requirements:
57      * - Subtraction cannot overflow.
58      *
59      * NOTE: This is a feature of the next version of OpenZeppelin Contracts.
60      * @dev Get it via `npm install @openzeppelin/contracts@next`.
61      */
62     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
63         require(b <= a, errorMessage);
64         uint256 c = a - b;
65 
66         return c;
67     }
68 
69     /**
70      * @dev Returns the multiplication of two unsigned integers, reverting on
71      * overflow.
72      *
73      * Counterpart to Solidity's `*` operator.
74      *
75      * Requirements:
76      * - Multiplication cannot overflow.
77      */
78     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
79         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
80         // benefit is lost if 'b' is also tested.
81         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
82         if (a == 0) {
83             return 0;
84         }
85 
86         uint256 c = a * b;
87         require(c / a == b, "SafeMath: multiplication overflow");
88 
89         return c;
90     }
91 
92     /**
93      * @dev Returns the integer division of two unsigned integers. Reverts on
94      * division by zero. The result is rounded towards zero.
95      *
96      * Counterpart to Solidity's `/` operator. Note: this function uses a
97      * `revert` opcode (which leaves remaining gas untouched) while Solidity
98      * uses an invalid opcode to revert (consuming all remaining gas).
99      *
100      * Requirements:
101      * - The divisor cannot be zero.
102      */
103     function div(uint256 a, uint256 b) internal pure returns (uint256) {
104         return div(a, b, "SafeMath: division by zero");
105     }
106 
107     /**
108      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
109      * division by zero. The result is rounded towards zero.
110      *
111      * Counterpart to Solidity's `/` operator. Note: this function uses a
112      * `revert` opcode (which leaves remaining gas untouched) while Solidity
113      * uses an invalid opcode to revert (consuming all remaining gas).
114      *
115      * Requirements:
116      * - The divisor cannot be zero.
117 
118      * NOTE: This is a feature of the next version of OpenZeppelin Contracts.
119      * @dev Get it via `npm install @openzeppelin/contracts@next`.
120      */
121     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
122         // Solidity only automatically asserts when dividing by 0
123         require(b > 0, errorMessage);
124         uint256 c = a / b;
125         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
126 
127         return c;
128     }
129 
130     /**
131      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
132      * Reverts when dividing by zero.
133      *
134      * Counterpart to Solidity's `%` operator. This function uses a `revert`
135      * opcode (which leaves remaining gas untouched) while Solidity uses an
136      * invalid opcode to revert (consuming all remaining gas).
137      *
138      * Requirements:
139      * - The divisor cannot be zero.
140      */
141     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
142         return mod(a, b, "SafeMath: modulo by zero");
143     }
144 
145     /**
146      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
147      * Reverts with custom message when dividing by zero.
148      *
149      * Counterpart to Solidity's `%` operator. This function uses a `revert`
150      * opcode (which leaves remaining gas untouched) while Solidity uses an
151      * invalid opcode to revert (consuming all remaining gas).
152      *
153      * Requirements:
154      * - The divisor cannot be zero.
155      *
156      * NOTE: This is a feature of the next version of OpenZeppelin Contracts.
157      * @dev Get it via `npm install @openzeppelin/contracts@next`.
158      */
159     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
160         require(b != 0, errorMessage);
161         return a % b;
162     }
163 }
164 
165 // File: contracts/token/ERC20/IERC20.sol
166 
167 pragma solidity ^0.5.11;
168 
169 /**
170  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
171  * the optional functions; to access them see {ERC20Detailed}.
172  */
173 interface IERC20 {
174     /**
175      * @dev Returns the amount of tokens in existence.
176      */
177     function totalSupply() external view returns (uint256);
178 
179     /**
180      * @dev Returns the amount of tokens owned by `account`.
181      */
182     function balanceOf(address account) external view returns (uint256);
183 
184     /**
185      * @dev Moves `amount` tokens from the caller's account to `recipient`.
186      *
187      * Returns a boolean value indicating whether the operation succeeded.
188      *
189      * Emits a {Transfer} event.
190      */
191     function transfer(address recipient, uint256 amount) external returns (bool);
192 
193     /**
194      * @dev Returns the remaining number of tokens that `spender` will be
195      * allowed to spend on behalf of `owner` through {transferFrom}. This is
196      * zero by default.
197      *
198      * This value changes when {approve} or {transferFrom} are called.
199      */
200     function allowance(address owner, address spender) external view returns (uint256);
201 
202     /**
203      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
204      *
205      * Returns a boolean value indicating whether the operation succeeded.
206      *
207      * IMPORTANT: Beware that changing an allowance with this method brings the risk
208      * that someone may use both the old and the new allowance by unfortunate
209      * transaction ordering. One possible solution to mitigate this race
210      * condition is to first reduce the spender's allowance to 0 and set the
211      * desired value afterwards:
212      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
213      *
214      * Emits an {Approval} event.
215      */
216     function approve(address spender, uint256 amount) external returns (bool);
217 
218     /**
219      * @dev Moves `amount` tokens from `sender` to `recipient` using the
220      * allowance mechanism. `amount` is then deducted from the caller's
221      * allowance.
222      *
223      * Returns a boolean value indicating whether the operation succeeded.
224      *
225      * Emits a {Transfer} event.
226      */
227     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
228 
229     /**
230      * @dev Emitted when `value` tokens are moved from one account (`from`) to
231      * another (`to`).
232      *
233      * Note that `value` may be zero.
234      */
235     event Transfer(address indexed from, address indexed to, uint256 value);
236 
237     /**
238      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
239      * a call to {approve}. `value` is the new allowance.
240      */
241     event Approval(address indexed owner, address indexed spender, uint256 value);
242 }
243 
244 // File: contracts/token/ERC223/IERC223.sol
245 
246 pragma solidity ^0.5.11;
247 
248 /**
249  * @dev Extension interface for IERC20 which defines logic specific to ERC223
250  */
251 interface IERC223 {
252 
253 	/**
254 	 * Events are actually ERC20 compatible, since etherscan/exhcanges don't support the newer event
255 	 */
256     event Transfer(address indexed from, address indexed to, uint256 value);
257 
258     /**
259 	 * Events are actually ERC20 compatible, since etherscan/exhcanges don't support the newer event
260 	 */
261     event Approval(address indexed owner, address indexed spender, uint256 value);
262 
263     function approve(address spender, uint256 amount, bytes calldata data) external returns (bool);
264 
265     function transfer(address to, uint value, bytes calldata data) external returns (bool);
266 
267     function transferFrom(address sender, address recipient, uint256 amount, bytes calldata data) external returns (bool);
268 
269 }
270 
271 // File: contracts/token/ERC223/ERC223Detailed.sol
272 
273 pragma solidity ^0.5.11;
274 
275 
276 
277 /**
278  * @dev Optional functions from the ERC20 standard.
279  */
280 contract ERC223Detailed is IERC20, IERC223 {
281     string private _name;
282     string private _symbol;
283     uint8 private _decimals;
284 
285     /**
286      * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of
287      * these values are immutable: they can only be set once during
288      * construction.
289      */
290     constructor (string memory name, string memory symbol, uint8 decimals) public {
291         _name = name;
292         _symbol = symbol;
293         _decimals = decimals;
294     }
295 
296     /**
297      * @dev Returns the name of the token.
298      */
299     function name() public view returns (string memory) {
300         return _name;
301     }
302 
303     /**
304      * @dev Returns the symbol of the token, usually a shorter version of the
305      * name.
306      */
307     function symbol() public view returns (string memory) {
308         return _symbol;
309     }
310 
311     /**
312      * @dev Returns the number of decimals used to get its user representation.
313      * For example, if `decimals` equals `2`, a balance of `505` tokens should
314      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
315      *
316      * Tokens usually opt for a value of 18, imitating the relationship between
317      * Ether and Wei.
318      *
319      * NOTE: This information is only used for _display_ purposes: it in
320      * no way affects any of the arithmetic of the contract, including
321      * {IERC20-balanceOf} and {IERC20-transfer}.
322      */
323     function decimals() public view returns (uint8) {
324         return _decimals;
325     }
326 }
327 
328 // File: contracts/GSN/Context.sol
329 
330 pragma solidity ^0.5.11;
331 
332 /*
333  * @dev Provides information about the current execution context, including the
334  * sender of the transaction and its data. While these are generally available
335  * via msg.sender and msg.data, they should not be accessed in such a direct
336  * manner, since when dealing with GSN meta-transactions the account sending and
337  * paying for execution may not be the actual sender (as far as an application
338  * is concerned).
339  *
340  * This contract is only required for intermediate, library-like contracts.
341  */
342 contract Context {
343     // Empty internal constructor, to prevent people from mistakenly deploying
344     // an instance of this contract, which should be used via inheritance.
345     constructor () internal { }
346     // solhint-disable-previous-line no-empty-blocks
347 
348     function _msgSender() internal view returns (address) {
349         return msg.sender;
350     }
351 
352     function _msgData() internal view returns (bytes memory) {
353         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
354         return msg.data;
355     }
356 }
357 
358 // File: contracts/utils/Address.sol
359 
360 pragma solidity ^0.5.11;
361 
362 /**
363  * @dev Collection of functions related to the address type
364  * Orginally https://github.com/Dexaran/ERC223-token-standard/blob/development/utils/Address.sol
365  */
366 library Address {
367     /**
368      * @dev Returns true if `account` is a contract.
369      *
370      * This test is non-exhaustive, and there may be false-negatives: during the
371      * execution of a contract's constructor, its address will be reported as
372      * not containing a contract.
373      *
374      * > It is unsafe to assume that an address for which this function returns
375      * false is an externally-owned account (EOA) and not a contract.
376      */
377     function isContract(address account) internal view returns (bool) {
378         // This method relies in extcodesize, which returns 0 for contracts in
379         // construction, since the code is only stored at the end of the
380         // constructor execution.
381 
382         uint256 size;
383         // solhint-disable-next-line no-inline-assembly
384         assembly { size := extcodesize(account) }
385         return size > 0;
386     }
387 
388     /**
389      * @dev Converts an `address` into `address payable`. Note that this is
390      * simply a type cast: the actual underlying value is not changed.
391      */
392     function toPayable(address account) internal pure returns (address payable) {
393         return address(uint160(account));
394     }
395 }
396 
397 // File: contracts/token/ERC223/IERC223Extras.sol
398 
399 pragma solidity ^0.5.11;
400 
401 /**
402  * @dev Extension interface for IERC223 which idenfies agent like behaviour
403  */
404 interface IERC223Extras {
405     function transferFor(address beneficiary, address recipient, uint256 amount, bytes calldata data) external returns (bool);
406 
407     function approveFor(address beneficiary, address spender, uint256 amount, bytes calldata data) external returns (bool);
408 }
409 
410 // File: contracts/token/ERC223/IERC223Recipient.sol
411 
412 pragma solidity ^0.5.11;
413 
414  /**
415  * @title Contract that will work with ERC223 tokens.
416  * Originally https://github.com/Dexaran/ERC223-token-standard/blob/development/token/ERC223/IERC223Recipient.sol
417  */
418 interface IERC223Recipient {
419     /**
420     * @dev Standard ERC223 function that will handle incoming token transfers.
421     *
422     * @param _from  Token sender address.
423     * @param _value Amount of tokens.
424     * @param _data  Transaction metadata.
425     */
426     function tokenFallback(address _from, uint _value, bytes calldata _data) external;
427 }
428 
429 // File: contracts/token/ERC223/IERC223ExtendedRecipient.sol
430 
431 pragma solidity ^0.5.11;
432 
433  /**
434  * @title Contract that will work with ERC223 tokens which have extended fallback methods triggered on approve,
435  * transferFor and approveFor (which are non standard logic)
436  */
437 interface IERC223ExtendedRecipient {
438     /**
439     * @dev Extra ERC223 like function that will handle incoming approvals.
440     *
441     * @param _from  Token sender address.
442     * @param _value Amount of tokens.
443     * @param _data  Transaction metadata.
444     */
445     function approveFallback(address _from, uint _value, bytes calldata _data) external;
446 
447     /**
448     * @dev ERC223 like function that will handle incoming token transfers for someone else
449     *
450     * @param _from  Token sender address.
451     * @param _beneficiary Token beneficiary.
452     * @param _value Amount of tokens.
453     * @param _data  Transaction metadata.
454     */
455     function tokenForFallback(address _from, address _beneficiary, uint _value, bytes calldata _data) external;
456 
457     /**
458     * @dev Extra ERC223 like function that will handle incoming approvals.
459     *
460     * @param _from  Token sender address.
461     * @param _beneficiary Token beneficiary.
462     * @param _value Amount of tokens.
463     * @param _data  Transaction metadata.
464     */
465     function approveForFallback(address _from, address _beneficiary, uint _value, bytes calldata _data) external;
466 }
467 
468 // File: contracts/token/ERC223/ERC223.sol
469 
470 pragma solidity ^0.5.11;
471 
472 
473 
474 
475 
476 
477 
478 
479 /**
480  * @dev Implementation of the {IERC223} interface.
481  *
482  * This implementation is agnostic to the way tokens are created. This means
483  * that a supply mechanism has to be added in a derived contract using {_mint}.
484  * For a generic mechanism see {ERC20Mintable}.
485  *
486  * TIP: For a detailed writeup see our guide
487  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
488  * to implement supply mechanisms].
489  *
490  * We have followed general OpenZeppelin guidelines: functions revert instead
491  * of returning `false` on failure. This behavior is nonetheless conventional
492  * and does not conflict with the expectations of ERC20 applications.
493  *
494  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
495  * This allows applications to reconstruct the allowance for all accounts just
496  * by listening to said events. Other implementations of the EIP may not emit
497  * these events, as it isn't required by the specification.
498  *
499  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
500  * functions have been added to mitigate the well-known issues around setting
501  * allowances. See {IERC223-approve}.
502  */
503 contract ERC223 is Context, IERC20, IERC223, IERC223Extras {
504     using SafeMath for uint256;
505 
506     mapping (address => uint256) private _balances;
507 
508     mapping (address => mapping (address => uint256)) private _allowances;
509 
510     uint256 private _totalSupply;
511 
512     /**
513      * @dev See {IERC223-totalSupply}.
514      */
515     function totalSupply() public view returns (uint256) {
516         return _totalSupply;
517     }
518 
519     /**
520      * @dev See {IERC223-balanceOf}.
521      */
522     function balanceOf(address account) public view returns (uint256) {
523         return _balances[account];
524     }
525 
526     /**
527      * @dev See {IERC223-transfer}.
528      *
529      * Requirements:
530      *
531      * - `recipient` cannot be the zero address.
532      * - the caller must have a balance of at least `amount`.
533      */
534     function transfer(address recipient, uint256 amount) public returns (bool) {
535         bytes memory _empty = hex"00000000";
536         _transfer(_msgSender(), recipient, amount, _empty);
537         return true;
538     }
539 
540     /**
541      * @dev See {IERC223-allowance}.
542      */
543     function allowance(address owner, address spender) public view returns (uint256) {
544         return _allowances[owner][spender];
545     }
546 
547     /**
548      * @dev See {IERC223-approve}.
549      *
550      * Requirements:
551      *
552      * - `spender` cannot be the zero address.
553      */
554     function approve(address spender, uint256 amount) public returns (bool) {
555         _approve(_msgSender(), spender, amount);
556         return true;
557     }
558 
559     /**
560      * @dev See {IERC2223-transferFrom}.
561      *
562      * Emits an {Approval} event indicating the updated allowance. This is not
563      * required by the EIP. See the note at the beginning of {ERC223};
564      *
565      * Requirements:
566      * - `sender` and `recipient` cannot be the zero address.
567      * - `sender` must have a balance of at least `amount`.
568      * - the caller must have allowance for `sender`'s tokens of at least
569      * `amount`.
570      *
571      * Has non-standard implementation: approval and transfer trigger fallback on special conditions
572      */
573     function transferFrom(address sender, address recipient, uint256 amount, bytes memory data) public returns (bool) {
574         _transfer(sender, recipient, amount, data); //has fallback if recipient isn't msg.sender
575          //has fallback if not msg sender:
576         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC223: transfer amount exceeds allowance"), data);
577         return true;
578     }
579 
580     /**
581      * @dev See {IERC223-transferFrom}.
582      *
583      * Emits an {Approval} event indicating the updated allowance. This is not
584      * required by the EIP. See the note at the beginning of {ERC223};
585      *
586      * Requirements:
587      * - `sender` and `recipient` cannot be the zero address.
588      * - `sender` must have a balance of at least `amount`.
589      * - the caller must have allowance for `sender`'s tokens of at least
590      * `amount`.
591      *
592      * Has standard implementation where no approveFallback is triggered
593      */
594     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
595         bytes memory _empty = hex"00000000";
596         _transfer(sender, recipient, amount, _empty); //Has standard ERC223 fallback
597         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC223: transfer amount exceeds allowance")); //no fallback
598         return true;
599     }
600 
601     /**
602      * @dev Atomically increases the allowance granted to `spender` by the caller.
603      *
604      * This is an alternative to {approve} that can be used as a mitigation for
605      * problems described in {IERC223-approve}.
606      *
607      * Emits an {Approval} event indicating the updated allowance.
608      *
609      * Requirements:
610      *
611      * - `spender` cannot be the zero address.
612      */
613     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
614         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
615         return true;
616     }
617 
618     /**
619      * @dev Atomically decreases the allowance granted to `spender` by the caller.
620      *
621      * This is an alternative to {approve} that can be used as a mitigation for
622      * problems described in {IERC223-approve}.
623      *
624      * Emits an {Approval} event indicating the updated allowance.
625      *
626      * Requirements:
627      *
628      * - `spender` cannot be the zero address.
629      * - `spender` must have allowance for the caller of at least
630      * `subtractedValue`.
631      */
632     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
633         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
634         return true;
635     }
636 
637     /**
638      * @dev Transfer the specified amount of tokens to the specified address.
639      *      Invokes the `tokenFallback` function if the recipient is a contract.
640      *      The token transfer fails if the recipient is a contract
641      *      but does not implement the `tokenFallback` function
642      *      or the fallback function to receive funds.
643      *
644      * @param recipient    Receiver address.
645      * @param amount Amount of tokens that will be transferred.
646      * @param data Transaction metadata.
647      */
648     function transfer(address recipient, uint256 amount, bytes memory data) public returns (bool success){
649         _transfer(_msgSender(), recipient, amount, data);
650         return true;
651     }
652 
653     /**
654      * @dev See {IERC223-approve}.
655      *
656      * Requirements:
657      *
658      * - `spender` cannot be the zero address.
659      */
660     function approve(address spender, uint256 amount, bytes memory data) public returns (bool) {
661         _approve(_msgSender(), spender, amount, data);
662         return true;
663     }
664 
665     /**
666      * @dev Moves tokens `amount` from `sender` to `recipient`.
667      *
668      * This is internal function is equivalent to {transfer}, and can be used to
669      * e.g. implement automatic token fees, slashing mechanisms, etc.
670      *
671      * Emits a {Transfer} event.
672      *
673      * Requirements:
674      *
675      * - `sender` cannot be the zero address.
676      * - `recipient` cannot be the zero address.
677      * - `sender` must have a balance of at least `amount`.
678      */
679     function _transfer(address sender, address recipient, uint256 amount, bytes memory data) internal {
680         require(sender != address(0), "ERC223: transfer from the zero address");
681         require(recipient != address(0), "ERC223: transfer to the zero address");
682 
683         _balances[sender] = _balances[sender].sub(amount, "ERC223: transfer amount exceeds balance");
684         _balances[recipient] = _balances[recipient].add(amount);
685         //ERC223 logic:
686         // No fallback if there's a transfer initiated by a contract to itself (transferFrom)
687         if(Address.isContract(recipient) && _msgSender() != recipient) {
688             IERC223Recipient receiver = IERC223Recipient(recipient);
689             receiver.tokenFallback(sender, amount, data);
690         }
691         emit Transfer(sender, recipient, amount);
692     }
693 
694     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
695      * the total supply.
696      *
697      * Emits a {Transfer} event with `from` set to the zero address.
698      *
699      * Requirements
700      *
701      * - `to` cannot be the zero address.
702      */
703     function _mint(address account, uint256 amount) internal {
704         require(account != address(0), "ERC223: mint to the zero address");
705 
706         _totalSupply = _totalSupply.add(amount);
707         _balances[account] = _balances[account].add(amount);
708         emit Transfer(address(0), account, amount);
709     }
710 
711      /**
712      * @dev Destroys `amount` tokens from `account`, reducing the
713      * total supply.
714      *
715      * Emits a {Transfer} event with `to` set to the zero address.
716      *
717      * Requirements
718      *
719      * - `account` cannot be the zero address.
720      * - `account` must have at least `amount` tokens.
721      */
722     function _burn(address account, uint256 amount) internal {
723         require(account != address(0), "ERC223: burn from the zero address");
724 
725         _balances[account] = _balances[account].sub(amount, "ERC223: burn amount exceeds balance");
726         _totalSupply = _totalSupply.sub(amount);
727         emit Transfer(account, address(0), amount);
728     }
729 
730     /**
731      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
732      *
733      * This is internal function is equivalent to `approve`, and can be used to
734      * e.g. set automatic allowances for certain subsystems, etc.
735      *
736      * Emits an {Approval} event.
737      *
738      * Requirements:
739      *
740      * - `owner` cannot be the zero address.
741      * - `spender` cannot be the zero address.
742      *
743      * This Function is non-standard to ERC223, and been modified to reflect same behaviour as _transfer with regards to fallback
744      */
745     function _approve(address owner, address spender, uint256 amount, bytes memory data) internal {
746         require(owner != address(0), "ERC223: approve from the zero address");
747         require(spender != address(0), "ERC223: approve to the zero address");
748 
749         _allowances[owner][spender] = amount;
750         // ERC223 Extra logic:
751         // No fallback when msg.sender is triggering this transaction (transferFrom) which it is also receiving
752         if(Address.isContract(spender) && _msgSender() != spender) {
753             IERC223ExtendedRecipient receiver = IERC223ExtendedRecipient(spender);
754             receiver.approveFallback(owner, amount, data);
755         }
756         emit Approval(owner, spender, amount);
757     }
758 
759     /**
760      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
761      *
762      * This is internal function is equivalent to `approve`, and can be used to
763      * e.g. set automatic allowances for certain subsystems, etc.
764      *
765      * Emits an {Approval} event.
766      *
767      * Requirements:
768      *
769      * - `owner` cannot be the zero address.
770      * - `spender` cannot be the zero address.
771      */
772     function _approve(address owner, address spender, uint256 amount) internal {
773         require(owner != address(0), "ERC223: approve from the zero address");
774         require(spender != address(0), "ERC223: approve to the zero address");
775         _allowances[owner][spender] = amount;
776         emit Approval(owner, spender, amount);
777     }
778 
779     /**
780      * @dev Destroys `amount` tokens from `account`.`amount` is then deducted
781      * from the caller's allowance.
782      *
783      * See {_burn} and {_approve}.
784      */
785     function _burnFrom(address account, uint256 amount) internal {
786         _burn(account, amount);
787         _approve(account, _msgSender(), _allowances[account][_msgSender()].sub(amount, "ERC223: burn amount exceeds allowance"));
788     }
789 
790     /**
791      * @dev Special extended functionality: Allows transferring tokens to a contract for the benefit of someone else
792      * Non-standard to ERC20 or ERC223
793      */
794     function transferFor(address beneficiary, address recipient, uint256 amount, bytes memory data) public returns (bool) {
795         address sender = _msgSender();
796         require(beneficiary != address(0), "ERC223E: transfer for the zero address");
797         require(recipient != address(0), "ERC223: transfer to the zero address");
798         require(beneficiary != sender, "ERC223: sender and beneficiary cannot be the same");
799 
800         _balances[sender] = _balances[sender].sub(amount, "ERC223: transfer amount exceeds balance");
801         _balances[recipient] = _balances[recipient].add(amount);
802         //ERC223 Extra logic:
803         if(Address.isContract(recipient) && _msgSender() != recipient) {
804             IERC223ExtendedRecipient receiver = IERC223ExtendedRecipient(recipient);
805             receiver.tokenForFallback(sender, beneficiary, amount, data);
806         }
807         emit Transfer(sender, recipient, amount);
808         return true;
809     }
810 
811     /**
812      * @dev  Special extended functionality: Allows approving tokens to a contract but for the benefit of someone else,
813      * transferFrom logic that follows doesn't change, but the spender here can track that the amount is deduced from someone for
814      * the benefit of someone else, thus allowing refunds to original sender, while giving service/utility being paid for to beneficiary
815      */
816     function approveFor(address beneficiary, address spender, uint256 amount, bytes memory data) public returns (bool) {
817         address agent = _msgSender();
818         require(agent != address(0), "ERC223: approve from the zero address");
819         require(spender != address(0), "ERC223: approve to the zero address");
820         require(beneficiary != agent, "ERC223: sender and beneficiary cannot be the same");
821 
822         _allowances[agent][spender] = amount;
823         //ERC223 Extra logic:
824         if(Address.isContract(spender) && _msgSender() != spender) {
825             IERC223ExtendedRecipient receiver = IERC223ExtendedRecipient(spender);
826             receiver.approveForFallback(agent, beneficiary, amount, data);
827         }
828         emit Approval(agent, spender, amount);
829         return true;
830     }
831 }
832 
833 // File: contracts/access/Roles.sol
834 
835 pragma solidity ^0.5.11;
836 
837 /**
838  * @title Roles
839  * @dev Library for managing addresses assigned to a Role.
840  */
841 library Roles {
842     struct Role {
843         mapping (address => bool) bearer;
844     }
845 
846     /**
847      * @dev Give an account access to this role.
848      */
849     function add(Role storage role, address account) internal {
850         require(!has(role, account), "Roles: account already has role");
851         role.bearer[account] = true;
852     }
853 
854     /**
855      * @dev Remove an account's access to this role.
856      */
857     function remove(Role storage role, address account) internal {
858         require(has(role, account), "Roles: account does not have role");
859         role.bearer[account] = false;
860     }
861 
862     /**
863      * @dev Check if an account has this role.
864      * @return bool
865      */
866     function has(Role storage role, address account) internal view returns (bool) {
867         require(account != address(0), "Roles: account is the zero address");
868         return role.bearer[account];
869     }
870 }
871 
872 // File: contracts/access/roles/PauserRole.sol
873 
874 pragma solidity ^0.5.11;
875 
876 contract PauserRole is Context {
877     using Roles for Roles.Role;
878 
879     event PauserAdded(address indexed account);
880     event PauserRemoved(address indexed account);
881 
882     Roles.Role private _pausers;
883 
884     constructor () internal {
885         _addPauser(_msgSender());
886     }
887 
888     modifier onlyPauser() {
889         require(isPauser(_msgSender()), "PauserRole: caller does not have the Pauser role");
890         _;
891     }
892 
893     function isPauser(address account) public view returns (bool) {
894         return _pausers.has(account);
895     }
896 
897     function addPauser(address account) public onlyPauser {
898         _addPauser(account);
899     }
900 
901     function renouncePauser() public {
902         _removePauser(_msgSender());
903     }
904 
905     function _addPauser(address account) internal {
906         _pausers.add(account);
907         emit PauserAdded(account);
908     }
909 
910     function _removePauser(address account) internal {
911         _pausers.remove(account);
912         emit PauserRemoved(account);
913     }
914 }
915 
916 // File: contracts/lifecycle/Pausable.sol
917 
918 pragma solidity ^0.5.11;
919 
920 /**
921  * @dev Contract module which allows children to implement an emergency stop
922  * mechanism that can be triggered by an authorized account.
923  *
924  * This module is used through inheritance. It will make available the
925  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
926  * the functions of your contract. Note that they will not be pausable by
927  * simply including this module, only once the modifiers are put in place.
928  */
929 contract Pausable is Context, PauserRole {
930     /**
931      * @dev Emitted when the pause is triggered by a pauser (`account`).
932      */
933     event Paused(address account);
934 
935     /**
936      * @dev Emitted when the pause is lifted by a pauser (`account`).
937      */
938     event Unpaused(address account);
939 
940     bool private _paused;
941 
942     /**
943      * @dev Initializes the contract in unpaused state. Assigns the Pauser role
944      * to the deployer.
945      */
946     constructor () internal {
947         _paused = false;
948     }
949 
950     /**
951      * @dev Returns true if the contract is paused, and false otherwise.
952      */
953     function paused() public view returns (bool) {
954         return _paused;
955     }
956 
957     /**
958      * @dev Modifier to make a function callable only when the contract is not paused.
959      */
960     modifier whenNotPaused() {
961         require(!_paused, "Pausable: paused");
962         _;
963     }
964 
965     /**
966      * @dev Modifier to make a function callable only when the contract is paused.
967      */
968     modifier whenPaused() {
969         require(_paused, "Pausable: not paused");
970         _;
971     }
972 
973     /**
974      * @dev Called by a pauser to pause, triggers stopped state.
975      */
976     function pause() public onlyPauser whenNotPaused {
977         _paused = true;
978         emit Paused(_msgSender());
979     }
980 
981     /**
982      * @dev Called by a pauser to unpause, returns to normal state.
983      */
984     function unpause() public onlyPauser whenPaused {
985         _paused = false;
986         emit Unpaused(_msgSender());
987     }
988 }
989 
990 // File: contracts/token/ERC223/ERC223Pausable.sol
991 
992 pragma solidity ^0.5.11;
993 
994 /**
995  * @title Pausable token
996  * @dev ERC223 an extension of ERC20Pausable which applies to ERC223 functions
997  *
998  */
999 contract ERC223Pausable is ERC223, Pausable {
1000     function transfer(address to, uint256 value) public whenNotPaused returns (bool) {
1001         return super.transfer(to, value);
1002     }
1003 
1004     function transferFrom(address from, address to, uint256 value) public whenNotPaused returns (bool) {
1005         return super.transferFrom(from, to, value);
1006     }
1007 
1008     function approve(address spender, uint256 value) public whenNotPaused returns (bool) {
1009         return super.approve(spender, value);
1010     }
1011 
1012     function increaseAllowance(address spender, uint256 addedValue) public whenNotPaused returns (bool) {
1013         return super.increaseAllowance(spender, addedValue);
1014     }
1015 
1016     function decreaseAllowance(address spender, uint256 subtractedValue) public whenNotPaused returns (bool) {
1017         return super.decreaseAllowance(spender, subtractedValue);
1018     }
1019 
1020     /**
1021      * ERC223
1022      */
1023     function transfer(address recipient, uint256 amount, bytes memory data) public whenNotPaused returns (bool success) {
1024         return super.transfer(recipient, amount, data);
1025     }
1026 
1027 	/**
1028      * ERC223
1029      */
1030     function approve(address spender, uint256 amount, bytes memory data) public whenNotPaused returns (bool) {
1031         return super.approve(spender, amount, data);
1032     }
1033 
1034     /**
1035      * ERC223Extra
1036      */
1037     function transferFor(address beneficiary, address recipient, uint256 amount, bytes memory data) public whenNotPaused returns (bool) {
1038         return super.transferFor(beneficiary, recipient, amount, data);
1039     }
1040 
1041     /**
1042      * ERC223Extra
1043      */
1044     function approveFor(address beneficiary, address spender, uint256 amount, bytes memory data) public whenNotPaused returns (bool) {
1045         return super.approveFor(beneficiary, spender, amount, data);
1046     }
1047 }
1048 
1049 // File: contracts/ownership/Ownable.sol
1050 
1051 pragma solidity ^0.5.11;
1052 
1053 /**
1054  * @dev Contract module which provides a basic access control mechanism, where
1055  * there is an account (an owner) that can be granted exclusive access to
1056  * specific functions.
1057  *
1058  * This module is used through inheritance. It will make available the modifier
1059  * `onlyOwner`, which can be applied to your functions to restrict their use to
1060  * the owner.
1061  */
1062 contract Ownable is Context {
1063     address private _owner;
1064 
1065     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1066 
1067     /**
1068      * @dev Initializes the contract setting the deployer as the initial owner.
1069      */
1070     constructor () internal {
1071         _owner = _msgSender();
1072         emit OwnershipTransferred(address(0), _owner);
1073     }
1074 
1075     /**
1076      * @dev Returns the address of the current owner.
1077      */
1078     function owner() public view returns (address) {
1079         return _owner;
1080     }
1081 
1082     /**
1083      * @dev Throws if called by any account other than the owner.
1084      */
1085     modifier onlyOwner() {
1086         require(isOwner(), "Ownable: caller is not the owner");
1087         _;
1088     }
1089 
1090     /**
1091      * @dev Returns true if the caller is the current owner.
1092      */
1093     function isOwner() public view returns (bool) {
1094         return _msgSender() == _owner;
1095     }
1096 
1097     /**
1098      * @dev Leaves the contract without owner. It will not be possible to call
1099      * `onlyOwner` functions anymore. Can only be called by the current owner.
1100      *
1101      * NOTE: Renouncing ownership will leave the contract without an owner,
1102      * thereby removing any functionality that is only available to the owner.
1103      */
1104     function renounceOwnership() public onlyOwner {
1105         emit OwnershipTransferred(_owner, address(0));
1106         _owner = address(0);
1107     }
1108 
1109     /**
1110      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1111      * Can only be called by the current owner.
1112      */
1113     function transferOwnership(address newOwner) public onlyOwner {
1114         _transferOwnership(newOwner);
1115     }
1116 
1117     /**
1118      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1119      */
1120     function _transferOwnership(address newOwner) internal {
1121         require(newOwner != address(0), "Ownable: new owner is the zero address");
1122         emit OwnershipTransferred(_owner, newOwner);
1123         _owner = newOwner;
1124     }
1125 }
1126 
1127 // File: contracts/access/roles/MinterRole.sol
1128 
1129 pragma solidity ^0.5.11;
1130 
1131 /**
1132  * @dev MinterRole inherites from openzeppelin.
1133  */
1134 contract MinterRole is Context {
1135     using Roles for Roles.Role;
1136 
1137     event MinterAdded(address indexed account);
1138     event MinterRemoved(address indexed account);
1139 
1140     Roles.Role private _minters;
1141 
1142     constructor () internal {
1143         _addMinter(_msgSender());
1144     }
1145 
1146     modifier onlyMinter() {
1147         require(isMinter(_msgSender()), "MinterRole: caller does not have the Minter role");
1148         _;
1149     }
1150 
1151     function isMinter(address account) public view returns (bool) {
1152         return _minters.has(account);
1153     }
1154 
1155     function addMinter(address account) public onlyMinter {
1156         _addMinter(account);
1157     }
1158 
1159     function renounceMinter() public {
1160         _removeMinter(_msgSender());
1161     }
1162 
1163     function _addMinter(address account) internal {
1164         _minters.add(account);
1165         emit MinterAdded(account);
1166     }
1167 
1168     function _removeMinter(address account) internal {
1169         _minters.remove(account);
1170         emit MinterRemoved(account);
1171     }
1172 }
1173 
1174 // File: contracts/token/ERC223/ERC223Mintable.sol
1175 
1176 pragma solidity ^0.5.11;
1177 
1178 /**
1179  * @dev Extension of {ERC20} that adds a set of accounts with the {MinterRole},
1180  * which have permission to mint (create) new tokens as they see fit.
1181  *
1182  * At construction, the deployer of the contract is the only minter.
1183  */
1184 contract ERC223Mintable is ERC223, MinterRole {
1185     /**
1186      * @dev See {ERC20-_mint}.
1187      *
1188      * Requirements:
1189      *
1190      * - the caller must have the {MinterRole}.
1191      */
1192     function mint(address account, uint256 amount) public onlyMinter returns (bool) {
1193         _mint(account, amount);
1194         return true;
1195     }
1196 }
1197 
1198 // File: contracts/token/ERC223/ERC223Capped.sol
1199 
1200 pragma solidity ^0.5.11;
1201 
1202 /**
1203  * @dev Extension of {ERC223Mintable} that adds a cap to the supply of tokens.
1204  */
1205 contract ERC223Capped is ERC223Mintable {
1206     uint256 private _cap;
1207 
1208     /**
1209      * @dev Sets the value of the `cap`. This value is immutable, it can only be
1210      * set once during construction.
1211      */
1212     constructor (uint256 cap) public {
1213         require(cap > 0, "ERC223Capped: cap is 0");
1214         _cap = cap;
1215     }
1216 
1217     /**
1218      * @dev Returns the cap on the token's total supply.
1219      */
1220     function cap() public view returns (uint256) {
1221         return _cap;
1222     }
1223 
1224     /**
1225      * @dev See {ERC223Mintable-mint}.
1226      *
1227      * Requirements:
1228      *
1229      * - `value` must not cause the total supply to go over the cap.
1230      */
1231     function _mint(address account, uint256 value) internal {
1232         require(totalSupply().add(value) <= _cap, "ERC223Capped: cap exceeded");
1233         super._mint(account, value);
1234     }
1235 }
1236 
1237 // File: contracts/token/ERC223/ERC223Burnable.sol
1238 
1239 pragma solidity ^0.5.11;
1240 
1241 /**
1242  * @dev Extension of {ERC20} that allows token holders to destroy both their own
1243  * tokens and those that they have an allowance for, in a way that can be
1244  * recognized off-chain (via event analysis).
1245  */
1246 contract ERC223Burnable is Context, ERC223 {
1247     /**
1248      * @dev Destroys `amount` tokens from the caller.
1249      *
1250      * See {ERC20-_burn}.
1251      */
1252     function burn(uint256 amount) public {
1253         _burn(_msgSender(), amount);
1254     }
1255 
1256     /**
1257      * @dev See {ERC20-_burnFrom}.
1258      */
1259     function burnFrom(address account, uint256 amount) public {
1260         _burnFrom(account, amount);
1261     }
1262 }
1263 
1264 // File: contracts/token/ERC223/ERC223UpgradeAgent.sol
1265 
1266 pragma solidity ^0.5.11;
1267 
1268 /**
1269  * @dev Upgrade agent interface inspired by Lunyr.
1270  *
1271  * Upgrade agent transfers tokens to a new contract.
1272  * Upgrade agent itself can be the token contract, or just a middle man contract doing the heavy lifting.
1273  * Originally https://github.com/TokenMarketNet/smart-contracts/blob/master/contracts/UpgradeAgent.sol
1274  */
1275 contract ERC223UpgradeAgent {
1276 
1277 	/** Original supply of token*/
1278     uint public originalSupply;
1279 
1280     /** Interface marker */
1281     function isUpgradeAgent() public pure returns (bool) {
1282         return true;
1283     }
1284 
1285     /**
1286      * @dev Upgrade a set of tokens
1287      */
1288     function upgradeFrom(address from, uint256 value) public;
1289 
1290 }
1291 
1292 // File: contracts/token/ERC223/ERC223Upgradeable.sol
1293 
1294 pragma solidity ^0.5.11;
1295 
1296 /**
1297  * @dev A capped burnable token which can be upgraded to a newer version of its self.
1298  */
1299 contract ERC223Upgradeable is ERC223Capped, ERC223Burnable, Ownable {
1300 
1301 	/** The next contract where the tokens will be migrated. */
1302     address private _upgradeAgent;
1303 
1304     /** How many tokens we have upgraded by now. */
1305     uint256 private _totalUpgraded = 0;
1306 
1307     /** Set to true if we have an upgrade agent and we're ready to update tokens */
1308     bool private _upgradeReady = false;
1309 
1310     /** Somebody has upgraded some of his tokens. */
1311     event Upgrade(address indexed _from, address indexed _to, uint256 _amount);
1312 
1313     /** New upgrade agent available. */
1314     event UpgradeAgentSet(address agent);
1315 
1316     /** New token information was set */
1317     event InformationUpdate(string name, string symbol);
1318 
1319     /**
1320     * @dev Modifier to check if upgrading is allowed
1321     */
1322     modifier upgradeAllowed() {
1323         require(_upgradeReady == true, "Upgrade not allowed");
1324         _;
1325     }
1326 
1327     /**
1328      * @dev Modifier to check if setting upgrade agent is allowed for owner
1329      */
1330     modifier upgradeAgentAllowed() {
1331         require(_totalUpgraded == 0, "Upgrade is already in progress");
1332         _;
1333     }
1334 
1335     /**
1336      * @dev Returns the upgrade agent
1337      */
1338     function upgradeAgent() public view returns (address) {
1339         return _upgradeAgent;
1340     }
1341 
1342     /**
1343      * @dev Allow the token holder to upgrade some of their tokens to a new contract.
1344      * @param amount An amount to upgrade to the next contract
1345      */
1346     function upgrade(uint256 amount) public upgradeAllowed {
1347         require(amount > 0, "Amount should be greater than zero");
1348         require(balanceOf(msg.sender) >= amount, "Amount exceeds tokens owned");
1349         //Burn user's tokens:
1350         burn(amount);
1351         _totalUpgraded = _totalUpgraded.add(amount);
1352         // Upgrade agent reissues the tokens in the new contract
1353         ERC223UpgradeAgent(_upgradeAgent).upgradeFrom(msg.sender, amount);
1354         emit Upgrade(msg.sender, _upgradeAgent, amount);
1355     }
1356 
1357     /**
1358      * @dev Set an upgrade agent that handles transition of tokens from this contract
1359      * @param agent Sets the address of the ERC223UpgradeAgent (new token)
1360      */
1361     function setUpgradeAgent(address agent) external onlyOwner upgradeAgentAllowed {
1362         require(agent != address(0), "Upgrade agent can not be at address 0");
1363         ERC223UpgradeAgent target = ERC223UpgradeAgent(agent);
1364         // Basic validation for target contract
1365         require(target.isUpgradeAgent() == true, "Address provided is an invalid agent");
1366         require(target.originalSupply() == cap(), "Upgrade agent should have the same cap");
1367         _upgradeAgent = agent;
1368         _upgradeReady = true;
1369         emit UpgradeAgentSet(agent);
1370     }
1371 
1372 }
1373 
1374 // File: contracts/iown/OdrToken.sol
1375 
1376 pragma solidity ^0.5.11;
1377 
1378 /**
1379  * @title Odr
1380  * @dev ODR (On Demand Release) is a contract which holds tokens to be released for special purposes only,
1381  *  from a token perspective, the ODR is an adress which receives all remainder of token cap
1382  */
1383 contract OdrToken is ERC223Upgradeable {
1384 
1385  	/** Holds the ODR address: where remainder of hard cap goes*/
1386     address private _odrAddress;
1387 
1388     /** The date before which release must be triggered or token MUST be upgraded. */
1389     uint private _releaseDate;
1390 
1391     /** Token release switch. */
1392     bool private _released = false;
1393 
1394     constructor(uint releaseDate) public {
1395         _releaseDate = releaseDate;
1396     }
1397 
1398     /**
1399      * @dev Modifier for checked whether the token has not been released yet
1400      */
1401     modifier whenNotReleased() {
1402         require(_released == false, "Not allowed after token release");
1403         _;
1404     }
1405 
1406     /**
1407      * @dev Releases the token by marking it as released after minting all tokens to ODR
1408      */
1409     function releaseToken() external onlyOwner returns (bool isSuccess) {
1410         require(_odrAddress != address(0), "ODR Address must be set before releasing token");
1411         uint256 remainder = cap().sub(totalSupply());
1412         if(remainder > 0) mint(_odrAddress, remainder); //Mint remainder of tokens to ODR wallet
1413         _released = true;
1414         return _released;
1415     }
1416 
1417     /**
1418      * @dev Allows Owner to set the ODR address which will hold the remainder of the tokens on release
1419      * @param odrAddress The address of the ODR wallet
1420      */
1421     function setODR(address odrAddress) external onlyOwner returns (bool isSuccess) {
1422         require(odrAddress != address(0), "Invalid ODR address");
1423         require(Address.isContract(odrAddress), "ODR address must be a contract");
1424         _odrAddress = odrAddress;
1425         return true;
1426     }
1427 
1428     /**
1429      * @dev Is token released yet
1430      * @return true if released
1431      */
1432     function released() public view returns (bool) {
1433         return _released;
1434     }
1435 
1436     /**
1437      * @dev Getter for ODR address
1438      * @return address of ODR
1439      */
1440     function odr() public view returns (address) {
1441         return _odrAddress;
1442     }
1443 }
1444 
1445 // File: contracts/iown/IownToken.sol
1446 
1447 pragma solidity ^0.5.11;
1448 
1449 /**
1450  * @title IownToken
1451  * @dev iOWN Token is an ERC223 Token for iOWN Project, intended to allow users to access iOWN Services
1452  */
1453 contract IownToken is OdrToken, ERC223Pausable, ERC223Detailed {
1454     using SafeMath for uint256;
1455 
1456     constructor(
1457         string memory name,
1458         string memory symbol,
1459         uint totalSupply,
1460         uint8 decimals,
1461         uint releaseDate,
1462         address managingWallet
1463     )
1464         Context()
1465         ERC223Detailed(name, symbol, decimals)
1466         Ownable()
1467         PauserRole()
1468         Pausable()
1469         MinterRole()
1470         ERC223Capped(totalSupply)
1471         OdrToken(releaseDate)
1472         public
1473     {
1474         transferOwnership(managingWallet);
1475     }
1476 
1477     /**
1478      * @dev Function to transfer ownership of contract to another address
1479      * Guarantees newOwner has also minter and pauser roles
1480      */
1481     function transferOwnership(address newOwner) public onlyOwner {
1482         require(newOwner != address(0), "Invalid new owner address");
1483         address oldOwner = owner();
1484         _addMinter(newOwner);
1485         _addPauser(newOwner);
1486         super.transferOwnership(newOwner);
1487         if(oldOwner != address(0)) {
1488             _removeMinter(oldOwner);
1489             _removePauser(oldOwner);
1490         }
1491     }
1492 }