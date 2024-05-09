1 pragma solidity ^0.5.0;
2 
3 /**
4  * @dev Wrappers over Solidity's arithmetic operations with added overflow
5  * checks.
6  *
7  * Arithmetic operations in Solidity wrap on overflow. This can easily result
8  * in bugs, because programmers usually assume that an overflow raises an
9  * error, which is the standard behavior in high level programming languages.
10  * `SafeMath` restores this intuition by reverting the transaction when an
11  * operation overflows.
12  *
13  * Using this library instead of the unchecked operations eliminates an entire
14  * class of bugs, so it's recommended to use it always.
15  */
16 library SafeMath {
17     /**
18      * @dev Returns the addition of two unsigned integers, reverting on
19      * overflow.
20      *
21      * Counterpart to Solidity's `+` operator.
22      *
23      * Requirements:
24      * - Addition cannot overflow.
25      */
26     function add(uint256 a, uint256 b) internal pure returns (uint256) {
27         uint256 c = a + b;
28         require(c >= a, "SafeMath: addition overflow");
29 
30         return c;
31     }
32 
33     /**
34      * @dev Returns the subtraction of two unsigned integers, reverting on
35      * overflow (when the result is negative).
36      *
37      * Counterpart to Solidity's `-` operator.
38      *
39      * Requirements:
40      * - Subtraction cannot overflow.
41      */
42     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
43         require(b <= a, "SafeMath: subtraction overflow");
44         uint256 c = a - b;
45 
46         return c;
47     }
48 
49     /**
50      * @dev Returns the multiplication of two unsigned integers, reverting on
51      * overflow.
52      *
53      * Counterpart to Solidity's `*` operator.
54      *
55      * Requirements:
56      * - Multiplication cannot overflow.
57      */
58     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
59         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
60         // benefit is lost if 'b' is also tested.
61         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
62         if (a == 0) {
63             return 0;
64         }
65 
66         uint256 c = a * b;
67         require(c / a == b, "SafeMath: multiplication overflow");
68 
69         return c;
70     }
71 
72     /**
73      * @dev Returns the integer division of two unsigned integers. Reverts on
74      * division by zero. The result is rounded towards zero.
75      *
76      * Counterpart to Solidity's `/` operator. Note: this function uses a
77      * `revert` opcode (which leaves remaining gas untouched) while Solidity
78      * uses an invalid opcode to revert (consuming all remaining gas).
79      *
80      * Requirements:
81      * - The divisor cannot be zero.
82      */
83     function div(uint256 a, uint256 b) internal pure returns (uint256) {
84         // Solidity only automatically asserts when dividing by 0
85         require(b > 0, "SafeMath: division by zero");
86         uint256 c = a / b;
87         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
88 
89         return c;
90     }
91 
92     /**
93      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
94      * Reverts when dividing by zero.
95      *
96      * Counterpart to Solidity's `%` operator. This function uses a `revert`
97      * opcode (which leaves remaining gas untouched) while Solidity uses an
98      * invalid opcode to revert (consuming all remaining gas).
99      *
100      * Requirements:
101      * - The divisor cannot be zero.
102      */
103     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
104         require(b != 0, "SafeMath: modulo by zero");
105         return a % b;
106     }
107 }
108 
109 
110 /**
111 * @title WadRayMath library
112 * @author Aave
113 * @dev Provides mul and div function for wads (decimal numbers with 18 digits precision) and rays (decimals with 27 digits)
114 **/
115 
116 library WadRayMath {
117     using SafeMath for uint256;
118 
119     uint256 internal constant WAD = 1e18;
120     uint256 internal constant halfWAD = WAD / 2;
121 
122     uint256 internal constant RAY = 1e27;
123     uint256 internal constant halfRAY = RAY / 2;
124 
125     uint256 internal constant WAD_RAY_RATIO = 1e9;
126 
127     /**
128     * @return one ray, 1e27
129     **/
130     function ray() internal pure returns (uint256) {
131         return RAY;
132     }
133 
134     /**
135     * @return one wad, 1e18
136     **/
137 
138     function wad() internal pure returns (uint256) {
139         return WAD;
140     }
141 
142     /**
143     * @return half ray, 1e27/2
144     **/
145     function halfRay() internal pure returns (uint256) {
146         return halfRAY;
147     }
148 
149     /**
150     * @return half ray, 1e18/2
151     **/
152     function halfWad() internal pure returns (uint256) {
153         return halfWAD;
154     }
155 
156     /**
157     * @dev multiplies two wad, rounding half up to the nearest wad
158     * @param a wad
159     * @param b wad
160     * @return the result of a*b, in wad
161     **/
162     function wadMul(uint256 a, uint256 b) internal pure returns (uint256) {
163         return halfWAD.add(a.mul(b)).div(WAD);
164     }
165 
166     /**
167     * @dev divides two wad, rounding half up to the nearest wad
168     * @param a wad
169     * @param b wad
170     * @return the result of a/b, in wad
171     **/
172     function wadDiv(uint256 a, uint256 b) internal pure returns (uint256) {
173         uint256 halfB = b / 2;
174 
175         return halfB.add(a.mul(WAD)).div(b);
176     }
177 
178     /**
179     * @dev multiplies two ray, rounding half up to the nearest ray
180     * @param a ray
181     * @param b ray
182     * @return the result of a*b, in ray
183     **/
184     function rayMul(uint256 a, uint256 b) internal pure returns (uint256) {
185         return halfRAY.add(a.mul(b)).div(RAY);
186     }
187 
188     /**
189     * @dev divides two ray, rounding half up to the nearest ray
190     * @param a ray
191     * @param b ray
192     * @return the result of a/b, in ray
193     **/
194     function rayDiv(uint256 a, uint256 b) internal pure returns (uint256) {
195         uint256 halfB = b / 2;
196 
197         return halfB.add(a.mul(RAY)).div(b);
198     }
199 
200     /**
201     * @dev casts ray down to wad
202     * @param a ray
203     * @return a casted to wad, rounded half up to the nearest wad
204     **/
205     function rayToWad(uint256 a) internal pure returns (uint256) {
206         uint256 halfRatio = WAD_RAY_RATIO / 2;
207 
208         return halfRatio.add(a).div(WAD_RAY_RATIO);
209     }
210 
211     /**
212     * @dev convert wad up to ray
213     * @param a wad
214     * @return a converted in ray
215     **/
216     function wadToRay(uint256 a) internal pure returns (uint256) {
217         return a.mul(WAD_RAY_RATIO);
218     }
219 
220     /**
221     * @dev calculates base^exp. The code uses the ModExp precompile
222     * @return base^exp, in ray
223     */
224     //solium-disable-next-line
225     function rayPow(uint256 x, uint256 n) internal pure returns (uint256 z) {
226 
227         z = n % 2 != 0 ? x : RAY;
228 
229         for (n /= 2; n != 0; n /= 2) {
230             x = rayMul(x, x);
231 
232             if (n % 2 != 0) {
233                 z = rayMul(z, x);
234             }
235         }
236     }
237 
238 }
239 
240 
241 /**
242  * @dev Contract module that helps prevent reentrant calls to a function.
243  *
244  * Inheriting from `ReentrancyGuard` will make the `nonReentrant` modifier
245  * available, which can be aplied to functions to make sure there are no nested
246  * (reentrant) calls to them.
247  *
248  * Note that because there is a single `nonReentrant` guard, functions marked as
249  * `nonReentrant` may not call one another. This can be worked around by making
250  * those functions `private`, and then adding `external` `nonReentrant` entry
251  * points to them.
252  */
253 contract ReentrancyGuard {
254     /// @dev counter to allow mutex lock with only one SSTORE operation
255     uint256 private _guardCounter;
256 
257     constructor () internal {
258         // The counter starts at one to prevent changing it from zero to a non-zero
259         // value, which is a more expensive operation.
260         _guardCounter = 1;
261     }
262 
263     /**
264      * @dev Prevents a contract from calling itself, directly or indirectly.
265      * Calling a `nonReentrant` function from another `nonReentrant`
266      * function is not supported. It is possible to prevent this from happening
267      * by making the `nonReentrant` function external, and make it call a
268      * `private` function that does the actual work.
269      */
270     modifier nonReentrant() {
271         _guardCounter += 1;
272         uint256 localCounter = _guardCounter;
273         _;
274         require(localCounter == _guardCounter, "ReentrancyGuard: reentrant call");
275     }
276 }
277 
278 
279 
280 /**
281  * @dev Collection of functions related to the address type,
282  */
283 library Address {
284     /**
285      * @dev Returns true if `account` is a contract.
286      *
287      * This test is non-exhaustive, and there may be false-negatives: during the
288      * execution of a contract's constructor, its address will be reported as
289      * not containing a contract.
290      *
291      * > It is unsafe to assume that an address for which this function returns
292      * false is an externally-owned account (EOA) and not a contract.
293      */
294     function isContract(address account) internal view returns (bool) {
295         // This method relies in extcodesize, which returns 0 for contracts in
296         // construction, since the code is only stored at the end of the
297         // constructor execution.
298 
299         uint256 size;
300         // solhint-disable-next-line no-inline-assembly
301         assembly { size := extcodesize(account) }
302         return size > 0;
303     }
304 }
305 
306 
307 /**
308  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
309  * the optional functions; to access them see `ERC20Detailed`.
310  */
311 interface IERC20 {
312     /**
313      * @dev Returns the amount of tokens in existence.
314      */
315     function totalSupply() external view returns (uint256);
316 
317     /**
318      * @dev Returns the amount of tokens owned by `account`.
319      */
320     function balanceOf(address account) external view returns (uint256);
321 
322     /**
323      * @dev Moves `amount` tokens from the caller's account to `recipient`.
324      *
325      * Returns a boolean value indicating whether the operation succeeded.
326      *
327      * Emits a `Transfer` event.
328      */
329     function transfer(address recipient, uint256 amount) external returns (bool);
330 
331     /**
332      * @dev Returns the remaining number of tokens that `spender` will be
333      * allowed to spend on behalf of `owner` through `transferFrom`. This is
334      * zero by default.
335      *
336      * This value changes when `approve` or `transferFrom` are called.
337      */
338     function allowance(address owner, address spender) external view returns (uint256);
339 
340     /**
341      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
342      *
343      * Returns a boolean value indicating whether the operation succeeded.
344      *
345      * > Beware that changing an allowance with this method brings the risk
346      * that someone may use both the old and the new allowance by unfortunate
347      * transaction ordering. One possible solution to mitigate this race
348      * condition is to first reduce the spender's allowance to 0 and set the
349      * desired value afterwards:
350      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
351      *
352      * Emits an `Approval` event.
353      */
354     function approve(address spender, uint256 amount) external returns (bool);
355 
356     /**
357      * @dev Moves `amount` tokens from `sender` to `recipient` using the
358      * allowance mechanism. `amount` is then deducted from the caller's
359      * allowance.
360      *
361      * Returns a boolean value indicating whether the operation succeeded.
362      *
363      * Emits a `Transfer` event.
364      */
365     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
366 
367     /**
368      * @dev Emitted when `value` tokens are moved from one account (`from`) to
369      * another (`to`).
370      *
371      * Note that `value` may be zero.
372      */
373     event Transfer(address indexed from, address indexed to, uint256 value);
374 
375     /**
376      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
377      * a call to `approve`. `value` is the new allowance.
378      */
379     event Approval(address indexed owner, address indexed spender, uint256 value);
380 }
381 
382 /**
383  * @dev Implementation of the `IERC20` interface.
384  *
385  * This implementation is agnostic to the way tokens are created. This means
386  * that a supply mechanism has to be added in a derived contract using `_mint`.
387  * For a generic mechanism see `ERC20Mintable`.
388  *
389  * *For a detailed writeup see our guide [How to implement supply
390  * mechanisms](https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226).*
391  *
392  * We have followed general OpenZeppelin guidelines: functions revert instead
393  * of returning `false` on failure. This behavior is nonetheless conventional
394  * and does not conflict with the expectations of ERC20 applications.
395  *
396  * Additionally, an `Approval` event is emitted on calls to `transferFrom`.
397  * This allows applications to reconstruct the allowance for all accounts just
398  * by listening to said events. Other implementations of the EIP may not emit
399  * these events, as it isn't required by the specification.
400  *
401  * Finally, the non-standard `decreaseAllowance` and `increaseAllowance`
402  * functions have been added to mitigate the well-known issues around setting
403  * allowances. See `IERC20.approve`.
404  */
405 contract ERC20 is IERC20 {
406     using SafeMath for uint256;
407 
408     mapping (address => uint256) private _balances;
409 
410     mapping (address => mapping (address => uint256)) private _allowances;
411 
412     uint256 private _totalSupply;
413 
414     /**
415      * @dev See `IERC20.totalSupply`.
416      */
417     function totalSupply() public view returns (uint256) {
418         return _totalSupply;
419     }
420 
421     /**
422      * @dev See `IERC20.balanceOf`.
423      */
424     function balanceOf(address account) public view returns (uint256) {
425         return _balances[account];
426     }
427 
428     /**
429      * @dev See `IERC20.transfer`.
430      *
431      * Requirements:
432      *
433      * - `recipient` cannot be the zero address.
434      * - the caller must have a balance of at least `amount`.
435      */
436     function transfer(address recipient, uint256 amount) public returns (bool) {
437         _transfer(msg.sender, recipient, amount);
438         return true;
439     }
440 
441     /**
442      * @dev See `IERC20.allowance`.
443      */
444     function allowance(address owner, address spender) public view returns (uint256) {
445         return _allowances[owner][spender];
446     }
447 
448     /**
449      * @dev See `IERC20.approve`.
450      *
451      * Requirements:
452      *
453      * - `spender` cannot be the zero address.
454      */
455     function approve(address spender, uint256 value) public returns (bool) {
456         _approve(msg.sender, spender, value);
457         return true;
458     }
459 
460     /**
461      * @dev See `IERC20.transferFrom`.
462      *
463      * Emits an `Approval` event indicating the updated allowance. This is not
464      * required by the EIP. See the note at the beginning of `ERC20`;
465      *
466      * Requirements:
467      * - `sender` and `recipient` cannot be the zero address.
468      * - `sender` must have a balance of at least `value`.
469      * - the caller must have allowance for `sender`'s tokens of at least
470      * `amount`.
471      */
472     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
473         _transfer(sender, recipient, amount);
474         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount));
475         return true;
476     }
477 
478     /**
479      * @dev Atomically increases the allowance granted to `spender` by the caller.
480      *
481      * This is an alternative to `approve` that can be used as a mitigation for
482      * problems described in `IERC20.approve`.
483      *
484      * Emits an `Approval` event indicating the updated allowance.
485      *
486      * Requirements:
487      *
488      * - `spender` cannot be the zero address.
489      */
490     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
491         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
492         return true;
493     }
494 
495     /**
496      * @dev Atomically decreases the allowance granted to `spender` by the caller.
497      *
498      * This is an alternative to `approve` that can be used as a mitigation for
499      * problems described in `IERC20.approve`.
500      *
501      * Emits an `Approval` event indicating the updated allowance.
502      *
503      * Requirements:
504      *
505      * - `spender` cannot be the zero address.
506      * - `spender` must have allowance for the caller of at least
507      * `subtractedValue`.
508      */
509     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
510         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue));
511         return true;
512     }
513 
514     /**
515      * @dev Moves tokens `amount` from `sender` to `recipient`.
516      *
517      * This is internal function is equivalent to `transfer`, and can be used to
518      * e.g. implement automatic token fees, slashing mechanisms, etc.
519      *
520      * Emits a `Transfer` event.
521      *
522      * Requirements:
523      *
524      * - `sender` cannot be the zero address.
525      * - `recipient` cannot be the zero address.
526      * - `sender` must have a balance of at least `amount`.
527      */
528     function _transfer(address sender, address recipient, uint256 amount) internal {
529         require(sender != address(0), "ERC20: transfer from the zero address");
530         require(recipient != address(0), "ERC20: transfer to the zero address");
531 
532         _balances[sender] = _balances[sender].sub(amount);
533         _balances[recipient] = _balances[recipient].add(amount);
534         emit Transfer(sender, recipient, amount);
535     }
536 
537     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
538      * the total supply.
539      *
540      * Emits a `Transfer` event with `from` set to the zero address.
541      *
542      * Requirements
543      *
544      * - `to` cannot be the zero address.
545      */
546     function _mint(address account, uint256 amount) internal {
547         require(account != address(0), "ERC20: mint to the zero address");
548 
549         _totalSupply = _totalSupply.add(amount);
550         _balances[account] = _balances[account].add(amount);
551         emit Transfer(address(0), account, amount);
552     }
553 
554      /**
555      * @dev Destoys `amount` tokens from `account`, reducing the
556      * total supply.
557      *
558      * Emits a `Transfer` event with `to` set to the zero address.
559      *
560      * Requirements
561      *
562      * - `account` cannot be the zero address.
563      * - `account` must have at least `amount` tokens.
564      */
565     function _burn(address account, uint256 value) internal {
566         require(account != address(0), "ERC20: burn from the zero address");
567 
568         _totalSupply = _totalSupply.sub(value);
569         _balances[account] = _balances[account].sub(value);
570         emit Transfer(account, address(0), value);
571     }
572 
573     /**
574      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
575      *
576      * This is internal function is equivalent to `approve`, and can be used to
577      * e.g. set automatic allowances for certain subsystems, etc.
578      *
579      * Emits an `Approval` event.
580      *
581      * Requirements:
582      *
583      * - `owner` cannot be the zero address.
584      * - `spender` cannot be the zero address.
585      */
586     function _approve(address owner, address spender, uint256 value) internal {
587         require(owner != address(0), "ERC20: approve from the zero address");
588         require(spender != address(0), "ERC20: approve to the zero address");
589 
590         _allowances[owner][spender] = value;
591         emit Approval(owner, spender, value);
592     }
593 
594     /**
595      * @dev Destoys `amount` tokens from `account`.`amount` is then deducted
596      * from the caller's allowance.
597      *
598      * See `_burn` and `_approve`.
599      */
600     function _burnFrom(address account, uint256 amount) internal {
601         _burn(account, amount);
602         _approve(account, msg.sender, _allowances[account][msg.sender].sub(amount));
603     }
604 }
605 
606 /**
607  * @dev Optional functions from the ERC20 standard.
608  */
609 contract ERC20Detailed is IERC20 {
610     string private _name;
611     string private _symbol;
612     uint8 private _decimals;
613 
614     /**
615      * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of
616      * these values are immutable: they can only be set once during
617      * construction.
618      */
619     constructor (string memory name, string memory symbol, uint8 decimals) public {
620         _name = name;
621         _symbol = symbol;
622         _decimals = decimals;
623     }
624 
625     /**
626      * @dev Returns the name of the token.
627      */
628     function name() public view returns (string memory) {
629         return _name;
630     }
631 
632     /**
633      * @dev Returns the symbol of the token, usually a shorter version of the
634      * name.
635      */
636     function symbol() public view returns (string memory) {
637         return _symbol;
638     }
639 
640     /**
641      * @dev Returns the number of decimals used to get its user representation.
642      * For example, if `decimals` equals `2`, a balance of `505` tokens should
643      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
644      *
645      * Tokens usually opt for a value of 18, imitating the relationship between
646      * Ether and Wei.
647      *
648      * > Note that this information is only used for _display_ purposes: it in
649      * no way affects any of the arithmetic of the contract, including
650      * `IERC20.balanceOf` and `IERC20.transfer`.
651      */
652     function decimals() public view returns (uint8) {
653         return _decimals;
654     }
655 }
656 
657 /**
658  * @title SafeERC20
659  * @dev Wrappers around ERC20 operations that throw on failure (when the token
660  * contract returns false). Tokens that return no value (and instead revert or
661  * throw on failure) are also supported, non-reverting calls are assumed to be
662  * successful.
663  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
664  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
665  */
666 library SafeERC20 {
667     using SafeMath for uint256;
668     using Address for address;
669 
670     function safeTransfer(IERC20 token, address to, uint256 value) internal {
671         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
672     }
673 
674     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
675         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
676     }
677 
678     function safeApprove(IERC20 token, address spender, uint256 value) internal {
679         // safeApprove should only be called when setting an initial allowance,
680         // or when resetting it to zero. To increase and decrease it, use
681         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
682         // solhint-disable-next-line max-line-length
683         require((value == 0) || (token.allowance(address(this), spender) == 0),
684             "SafeERC20: approve from non-zero to non-zero allowance"
685         );
686         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
687     }
688 
689     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
690         uint256 newAllowance = token.allowance(address(this), spender).add(value);
691         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
692     }
693 
694     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
695         uint256 newAllowance = token.allowance(address(this), spender).sub(value);
696         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
697     }
698 
699     /**
700      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
701      * on the return value: the return value is optional (but if data is returned, it must not be false).
702      * @param token The token targeted by the call.
703      * @param data The call data (encoded using abi.encode or one of its variants).
704      */
705     function callOptionalReturn(IERC20 token, bytes memory data) private {
706         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
707         // we're implementing it ourselves.
708 
709         // A Solidity high level call has three parts:
710         //  1. The target address is checked to verify it contains contract code
711         //  2. The call itself is made, and success asserted
712         //  3. The return value is decoded, which in turn checks the size of the returned data.
713         // solhint-disable-next-line max-line-length
714         require(address(token).isContract(), "SafeERC20: call to non-contract");
715 
716         // solhint-disable-next-line avoid-low-level-calls
717         (bool success, bytes memory returndata) = address(token).call(data);
718         require(success, "SafeERC20: low-level call failed");
719 
720         if (returndata.length > 0) { // Return data is optional
721             // solhint-disable-next-line max-line-length
722             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
723         }
724     }
725 }
726 
727 /**
728  * @title VersionedInitializable
729  *
730  * @dev Helper contract to support initializer functions. To use it, replace
731  * the constructor with a function that has the `initializer` modifier.
732  * WARNING: Unlike constructors, initializer functions must be manually
733  * invoked. This applies both to deploying an Initializable contract, as well
734  * as extending an Initializable contract via inheritance.
735  * WARNING: When used with inheritance, manual care must be taken to not invoke
736  * a parent initializer twice, or ensure that all initializers are idempotent,
737  * because this is not dealt with automatically as with constructors.
738  *
739  * @author Aave, inspired by the OpenZeppelin Initializable contract
740  */
741 contract VersionedInitializable {
742     /**
743    * @dev Indicates that the contract has been initialized.
744    */
745     uint256 private lastInitializedRevision = 0;
746 
747     /**
748    * @dev Indicates that the contract is in the process of being initialized.
749    */
750     bool private initializing;
751 
752     /**
753    * @dev Modifier to use in the initializer function of a contract.
754    */
755     modifier initializer() {
756         uint256 revision = getRevision();
757         require(initializing || isConstructor() || revision > lastInitializedRevision, "Contract instance has already been initialized");
758 
759         bool isTopLevelCall = !initializing;
760         if (isTopLevelCall) {
761             initializing = true;
762             lastInitializedRevision = revision;
763         }
764 
765         _;
766 
767         if (isTopLevelCall) {
768             initializing = false;
769         }
770     }
771 
772     /// @dev returns the revision number of the contract.
773     /// Needs to be defined in the inherited class as a constant.
774     function getRevision() internal pure returns(uint256);
775 
776 
777     /// @dev Returns true if and only if the function is running in the constructor
778     function isConstructor() private view returns (bool) {
779         // extcodesize checks the size of the code stored in an address, and
780         // address returns the current address. Since the code is still not
781         // deployed when running a constructor, any checks on its code size will
782         // yield zero, making it an effective way to detect if a contract is
783         // under construction or not.
784         uint256 cs;
785         //solium-disable-next-line
786         assembly {
787             cs := extcodesize(address)
788         }
789         return cs == 0;
790     }
791 
792     // Reserved storage space to allow for layout changes in the future.
793     uint256[50] private ______gap;
794 }
795 
796 
797 /**
798  * @dev Contract module which provides a basic access control mechanism, where
799  * there is an account (an owner) that can be granted exclusive access to
800  * specific functions.
801  *
802  * This module is used through inheritance. It will make available the modifier
803  * `onlyOwner`, which can be aplied to your functions to restrict their use to
804  * the owner.
805  */
806 contract Ownable {
807     address private _owner;
808 
809     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
810 
811     /**
812      * @dev Initializes the contract setting the deployer as the initial owner.
813      */
814     constructor () internal {
815         _owner = msg.sender;
816         emit OwnershipTransferred(address(0), _owner);
817     }
818 
819     /**
820      * @dev Returns the address of the current owner.
821      */
822     function owner() public view returns (address) {
823         return _owner;
824     }
825 
826     /**
827      * @dev Throws if called by any account other than the owner.
828      */
829     modifier onlyOwner() {
830         require(isOwner(), "Ownable: caller is not the owner");
831         _;
832     }
833 
834     /**
835      * @dev Returns true if the caller is the current owner.
836      */
837     function isOwner() public view returns (bool) {
838         return msg.sender == _owner;
839     }
840 
841     /**
842      * @dev Leaves the contract without owner. It will not be possible to call
843      * `onlyOwner` functions anymore. Can only be called by the current owner.
844      *
845      * > Note: Renouncing ownership will leave the contract without an owner,
846      * thereby removing any functionality that is only available to the owner.
847      */
848     function renounceOwnership() public onlyOwner {
849         emit OwnershipTransferred(_owner, address(0));
850         _owner = address(0);
851     }
852 
853     /**
854      * @dev Transfers ownership of the contract to a new account (`newOwner`).
855      * Can only be called by the current owner.
856      */
857     function transferOwnership(address newOwner) public onlyOwner {
858         _transferOwnership(newOwner);
859     }
860 
861     /**
862      * @dev Transfers ownership of the contract to a new account (`newOwner`).
863      */
864     function _transferOwnership(address newOwner) internal {
865         require(newOwner != address(0), "Ownable: new owner is the zero address");
866         emit OwnershipTransferred(_owner, newOwner);
867         _owner = newOwner;
868     }
869 }
870 
871 /**
872  * @title Proxy
873  * @dev Implements delegation of calls to other contracts, with proper
874  * forwarding of return values and bubbling of failures.
875  * It defines a fallback function that delegates all calls to the address
876  * returned by the abstract _implementation() internal function.
877  */
878 contract Proxy {
879     /**
880    * @dev Fallback function.
881    * Implemented entirely in `_fallback`.
882    */
883     function() external payable {
884         _fallback();
885     }
886 
887     /**
888    * @return The Address of the implementation.
889    */
890     function _implementation() internal view returns (address);
891 
892     /**
893    * @dev Delegates execution to an implementation contract.
894    * This is a low level function that doesn't return to its internal call site.
895    * It will return to the external caller whatever the implementation returns.
896    * @param implementation Address to delegate.
897    */
898     function _delegate(address implementation) internal {
899         //solium-disable-next-line
900         assembly {
901             // Copy msg.data. We take full control of memory in this inline assembly
902             // block because it will not return to Solidity code. We overwrite the
903             // Solidity scratch pad at memory position 0.
904             calldatacopy(0, 0, calldatasize)
905 
906             // Call the implementation.
907             // out and outsize are 0 because we don't know the size yet.
908             let result := delegatecall(gas, implementation, 0, calldatasize, 0, 0)
909 
910             // Copy the returned data.
911             returndatacopy(0, 0, returndatasize)
912 
913             switch result
914                 // delegatecall returns 0 on error.
915                 case 0 {
916                     revert(0, returndatasize)
917                 }
918                 default {
919                     return(0, returndatasize)
920                 }
921         }
922     }
923 
924     /**
925    * @dev Function that is run as the first thing in the fallback function.
926    * Can be redefined in derived contracts to add functionality.
927    * Redefinitions must call super._willFallback().
928    */
929     function _willFallback() internal {}
930 
931     /**
932    * @dev fallback implementation.
933    * Extracted to enable manual triggering.
934    */
935     function _fallback() internal {
936         _willFallback();
937         _delegate(_implementation());
938     }
939 }
940 
941 /**
942  * @title BaseUpgradeabilityProxy
943  * @dev This contract implements a proxy that allows to change the
944  * implementation address to which it will delegate.
945  * Such a change is called an implementation upgrade.
946  */
947 contract BaseUpgradeabilityProxy is Proxy {
948     /**
949    * @dev Emitted when the implementation is upgraded.
950    * @param implementation Address of the new implementation.
951    */
952     event Upgraded(address indexed implementation);
953 
954     /**
955    * @dev Storage slot with the address of the current implementation.
956    * This is the keccak-256 hash of "eip1967.proxy.implementation" subtracted by 1, and is
957    * validated in the constructor.
958    */
959     bytes32 internal constant IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
960 
961     /**
962    * @dev Returns the current implementation.
963    * @return Address of the current implementation
964    */
965     function _implementation() internal view returns (address impl) {
966         bytes32 slot = IMPLEMENTATION_SLOT;
967         //solium-disable-next-line
968         assembly {
969             impl := sload(slot)
970         }
971     }
972 
973     /**
974    * @dev Upgrades the proxy to a new implementation.
975    * @param newImplementation Address of the new implementation.
976    */
977     function _upgradeTo(address newImplementation) internal {
978         _setImplementation(newImplementation);
979         emit Upgraded(newImplementation);
980     }
981 
982     /**
983    * @dev Sets the implementation address of the proxy.
984    * @param newImplementation Address of the new implementation.
985    */
986     function _setImplementation(address newImplementation) internal {
987         require(
988             Address.isContract(newImplementation),
989             "Cannot set a proxy implementation to a non-contract address"
990         );
991 
992         bytes32 slot = IMPLEMENTATION_SLOT;
993 
994         //solium-disable-next-line
995         assembly {
996             sstore(slot, newImplementation)
997         }
998     }
999 }
1000 
1001 
1002 
1003 /**
1004  * @title BaseAdminUpgradeabilityProxy
1005  * @dev This contract combines an upgradeability proxy with an authorization
1006  * mechanism for administrative tasks.
1007  * All external functions in this contract must be guarded by the
1008  * `ifAdmin` modifier. See ethereum/solidity#3864 for a Solidity
1009  * feature proposal that would enable this to be done automatically.
1010  */
1011 contract BaseAdminUpgradeabilityProxy is BaseUpgradeabilityProxy {
1012     /**
1013    * @dev Emitted when the administration has been transferred.
1014    * @param previousAdmin Address of the previous admin.
1015    * @param newAdmin Address of the new admin.
1016    */
1017     event AdminChanged(address previousAdmin, address newAdmin);
1018 
1019     /**
1020    * @dev Storage slot with the admin of the contract.
1021    * This is the keccak-256 hash of "eip1967.proxy.admin" subtracted by 1, and is
1022    * validated in the constructor.
1023    */
1024 
1025     bytes32 internal constant ADMIN_SLOT = 0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103;
1026 
1027     /**
1028    * @dev Modifier to check whether the `msg.sender` is the admin.
1029    * If it is, it will run the function. Otherwise, it will delegate the call
1030    * to the implementation.
1031    */
1032     modifier ifAdmin() {
1033         if (msg.sender == _admin()) {
1034             _;
1035         } else {
1036             _fallback();
1037         }
1038     }
1039 
1040     /**
1041    * @return The address of the proxy admin.
1042    */
1043     function admin() external ifAdmin returns (address) {
1044         return _admin();
1045     }
1046 
1047     /**
1048    * @return The address of the implementation.
1049    */
1050     function implementation() external ifAdmin returns (address) {
1051         return _implementation();
1052     }
1053 
1054     /**
1055    * @dev Changes the admin of the proxy.
1056    * Only the current admin can call this function.
1057    * @param newAdmin Address to transfer proxy administration to.
1058    */
1059     function changeAdmin(address newAdmin) external ifAdmin {
1060         require(newAdmin != address(0), "Cannot change the admin of a proxy to the zero address");
1061         emit AdminChanged(_admin(), newAdmin);
1062         _setAdmin(newAdmin);
1063     }
1064 
1065     /**
1066    * @dev Upgrade the backing implementation of the proxy.
1067    * Only the admin can call this function.
1068    * @param newImplementation Address of the new implementation.
1069    */
1070     function upgradeTo(address newImplementation) external ifAdmin {
1071         _upgradeTo(newImplementation);
1072     }
1073 
1074     /**
1075    * @dev Upgrade the backing implementation of the proxy and call a function
1076    * on the new implementation.
1077    * This is useful to initialize the proxied contract.
1078    * @param newImplementation Address of the new implementation.
1079    * @param data Data to send as msg.data in the low level call.
1080    * It should include the signature and the parameters of the function to be called, as described in
1081    * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
1082    */
1083     function upgradeToAndCall(address newImplementation, bytes calldata data) external payable ifAdmin {
1084         _upgradeTo(newImplementation);
1085         (bool success, ) = newImplementation.delegatecall(data);
1086         require(success);
1087     }
1088 
1089     /**
1090    * @return The admin slot.
1091    */
1092     function _admin() internal view returns (address adm) {
1093         bytes32 slot = ADMIN_SLOT;
1094         //solium-disable-next-line
1095         assembly {
1096             adm := sload(slot)
1097         }
1098     }
1099 
1100     /**
1101    * @dev Sets the address of the proxy admin.
1102    * @param newAdmin Address of the new proxy admin.
1103    */
1104     function _setAdmin(address newAdmin) internal {
1105         bytes32 slot = ADMIN_SLOT;
1106         //solium-disable-next-line
1107         assembly {
1108             sstore(slot, newAdmin)
1109         }
1110     }
1111 
1112     /**
1113    * @dev Only fall back when the sender is not the admin.
1114    */
1115     function _willFallback() internal {
1116         require(msg.sender != _admin(), "Cannot call fallback function from the proxy admin");
1117         super._willFallback();
1118     }
1119 }
1120 
1121 /**
1122  * @title UpgradeabilityProxy
1123  * @dev Extends BaseUpgradeabilityProxy with a constructor for initializing
1124  * implementation and init data.
1125  */
1126 contract UpgradeabilityProxy is BaseUpgradeabilityProxy {
1127     /**
1128    * @dev Contract constructor.
1129    * @param _logic Address of the initial implementation.
1130    * @param _data Data to send as msg.data to the implementation to initialize the proxied contract.
1131    * It should include the signature and the parameters of the function to be called, as described in
1132    * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
1133    * This parameter is optional, if no data is given the initialization call to proxied contract will be skipped.
1134    */
1135     constructor(address _logic, bytes memory _data) public payable {
1136         assert(IMPLEMENTATION_SLOT == bytes32(uint256(keccak256("eip1967.proxy.implementation")) - 1));
1137         _setImplementation(_logic);
1138         if (_data.length > 0) {
1139             (bool success, ) = _logic.delegatecall(_data);
1140             require(success);
1141         }
1142     }
1143 }
1144 
1145 
1146 
1147 
1148 /**
1149  * @title AdminUpgradeabilityProxy
1150  * @dev Extends from BaseAdminUpgradeabilityProxy with a constructor for 
1151  * initializing the implementation, admin, and init data.
1152  */
1153 contract AdminUpgradeabilityProxy is BaseAdminUpgradeabilityProxy, UpgradeabilityProxy {
1154     /**
1155    * Contract constructor.
1156    * @param _logic address of the initial implementation.
1157    * @param _admin Address of the proxy administrator.
1158    * @param _data Data to send as msg.data to the implementation to initialize the proxied contract.
1159    * It should include the signature and the parameters of the function to be called, as described in
1160    * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
1161    * This parameter is optional, if no data is given the initialization call to proxied contract will be skipped.
1162    */
1163     constructor(address _logic, address _admin, bytes memory _data) public payable UpgradeabilityProxy(_logic, _data) {
1164         assert(ADMIN_SLOT == bytes32(uint256(keccak256("eip1967.proxy.admin")) - 1));
1165         _setAdmin(_admin);
1166     }
1167 }
1168 
1169 
1170 
1171 /**
1172  * @title InitializableUpgradeabilityProxy
1173  * @dev Extends BaseUpgradeabilityProxy with an initializer for initializing
1174  * implementation and init data.
1175  */
1176 contract InitializableUpgradeabilityProxy is BaseUpgradeabilityProxy {
1177     /**
1178    * @dev Contract initializer.
1179    * @param _logic Address of the initial implementation.
1180    * @param _data Data to send as msg.data to the implementation to initialize the proxied contract.
1181    * It should include the signature and the parameters of the function to be called, as described in
1182    * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
1183    * This parameter is optional, if no data is given the initialization call to proxied contract will be skipped.
1184    */
1185     function initialize(address _logic, bytes memory _data) public payable {
1186         require(_implementation() == address(0));
1187         assert(IMPLEMENTATION_SLOT == bytes32(uint256(keccak256("eip1967.proxy.implementation")) - 1));
1188         _setImplementation(_logic);
1189         if (_data.length > 0) {
1190             (bool success, ) = _logic.delegatecall(_data);
1191             require(success);
1192         }
1193     }
1194 }
1195 
1196 contract AddressStorage {
1197     mapping(bytes32 => address) private addresses;
1198 
1199     function getAddress(bytes32 _key) public view returns (address) {
1200         return addresses[_key];
1201     }
1202 
1203     function _setAddress(bytes32 _key, address _value) internal {
1204         addresses[_key] = _value;
1205     }
1206 
1207 }
1208 
1209 /**
1210  * @title InitializableAdminUpgradeabilityProxy
1211  * @dev Extends from BaseAdminUpgradeabilityProxy with an initializer for 
1212  * initializing the implementation, admin, and init data.
1213  */
1214 contract InitializableAdminUpgradeabilityProxy is BaseAdminUpgradeabilityProxy, InitializableUpgradeabilityProxy {
1215     /**
1216    * Contract initializer.
1217    * @param _logic address of the initial implementation.
1218    * @param _admin Address of the proxy administrator.
1219    * @param _data Data to send as msg.data to the implementation to initialize the proxied contract.
1220    * It should include the signature and the parameters of the function to be called, as described in
1221    * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
1222    * This parameter is optional, if no data is given the initialization call to proxied contract will be skipped.
1223    */
1224     function initialize(address _logic, address _admin, bytes memory _data) public payable {
1225         require(_implementation() == address(0));
1226         InitializableUpgradeabilityProxy.initialize(_logic, _data);
1227         assert(ADMIN_SLOT == bytes32(uint256(keccak256("eip1967.proxy.admin")) - 1));
1228         _setAdmin(_admin);
1229     }
1230 }
1231 
1232 
1233 
1234 /**
1235 @title ILendingPoolAddressesProvider interface
1236 @notice provides the interface to fetch the LendingPoolCore address
1237  */
1238 
1239 contract ILendingPoolAddressesProvider {
1240 
1241     function getLendingPool() public view returns (address);
1242     function setLendingPoolImpl(address _pool) public;
1243 
1244     function getLendingPoolCore() public view returns (address payable);
1245     function setLendingPoolCoreImpl(address _lendingPoolCore) public;
1246 
1247     function getLendingPoolConfigurator() public view returns (address);
1248     function setLendingPoolConfiguratorImpl(address _configurator) public;
1249 
1250     function getLendingPoolDataProvider() public view returns (address);
1251     function setLendingPoolDataProviderImpl(address _provider) public;
1252 
1253     function getLendingPoolParametersProvider() public view returns (address);
1254     function setLendingPoolParametersProviderImpl(address _parametersProvider) public;
1255 
1256     function getTokenDistributor() public view returns (address);
1257     function setTokenDistributor(address _tokenDistributor) public;
1258 
1259 
1260     function getFeeProvider() public view returns (address);
1261     function setFeeProviderImpl(address _feeProvider) public;
1262 
1263     function getLendingPoolLiquidationManager() public view returns (address);
1264     function setLendingPoolLiquidationManager(address _manager) public;
1265 
1266     function getLendingPoolManager() public view returns (address);
1267     function setLendingPoolManager(address _lendingPoolManager) public;
1268 
1269     function getPriceOracle() public view returns (address);
1270     function setPriceOracle(address _priceOracle) public;
1271 
1272     function getLendingRateOracle() public view returns (address);
1273     function setLendingRateOracle(address _lendingRateOracle) public;
1274 
1275 }
1276 
1277 
1278 
1279 
1280 /**
1281 * @title LendingPoolAddressesProvider contract
1282 * @notice Is the main registry of the protocol. All the different components of the protocol are accessible
1283 * through the addresses provider.
1284 * @author Aave
1285 **/
1286 
1287 contract LendingPoolAddressesProvider is Ownable, ILendingPoolAddressesProvider, AddressStorage {
1288     //events
1289     event LendingPoolUpdated(address indexed newAddress);
1290     event LendingPoolCoreUpdated(address indexed newAddress);
1291     event LendingPoolParametersProviderUpdated(address indexed newAddress);
1292     event LendingPoolManagerUpdated(address indexed newAddress);
1293     event LendingPoolConfiguratorUpdated(address indexed newAddress);
1294     event LendingPoolLiquidationManagerUpdated(address indexed newAddress);
1295     event LendingPoolDataProviderUpdated(address indexed newAddress);
1296     event EthereumAddressUpdated(address indexed newAddress);
1297     event PriceOracleUpdated(address indexed newAddress);
1298     event LendingRateOracleUpdated(address indexed newAddress);
1299     event FeeProviderUpdated(address indexed newAddress);
1300     event TokenDistributorUpdated(address indexed newAddress);
1301 
1302     event ProxyCreated(bytes32 id, address indexed newAddress);
1303 
1304     bytes32 private constant LENDING_POOL = "LENDING_POOL";
1305     bytes32 private constant LENDING_POOL_CORE = "LENDING_POOL_CORE";
1306     bytes32 private constant LENDING_POOL_CONFIGURATOR = "LENDING_POOL_CONFIGURATOR";
1307     bytes32 private constant LENDING_POOL_PARAMETERS_PROVIDER = "PARAMETERS_PROVIDER";
1308     bytes32 private constant LENDING_POOL_MANAGER = "LENDING_POOL_MANAGER";
1309     bytes32 private constant LENDING_POOL_LIQUIDATION_MANAGER = "LIQUIDATION_MANAGER";
1310     bytes32 private constant LENDING_POOL_FLASHLOAN_PROVIDER = "FLASHLOAN_PROVIDER";
1311     bytes32 private constant DATA_PROVIDER = "DATA_PROVIDER";
1312     bytes32 private constant ETHEREUM_ADDRESS = "ETHEREUM_ADDRESS";
1313     bytes32 private constant PRICE_ORACLE = "PRICE_ORACLE";
1314     bytes32 private constant LENDING_RATE_ORACLE = "LENDING_RATE_ORACLE";
1315     bytes32 private constant FEE_PROVIDER = "FEE_PROVIDER";
1316     bytes32 private constant WALLET_BALANCE_PROVIDER = "WALLET_BALANCE_PROVIDER";
1317     bytes32 private constant TOKEN_DISTRIBUTOR = "TOKEN_DISTRIBUTOR";
1318 
1319 
1320     /**
1321     * @dev returns the address of the LendingPool proxy
1322     * @return the lending pool proxy address
1323     **/
1324     function getLendingPool() public view returns (address) {
1325         return getAddress(LENDING_POOL);
1326     }
1327 
1328 
1329     /**
1330     * @dev updates the implementation of the lending pool
1331     * @param _pool the new lending pool implementation
1332     **/
1333     function setLendingPoolImpl(address _pool) public onlyOwner {
1334         updateImplInternal(LENDING_POOL, _pool);
1335         emit LendingPoolUpdated(_pool);
1336     }
1337 
1338     /**
1339     * @dev returns the address of the LendingPoolCore proxy
1340     * @return the lending pool core proxy address
1341      */
1342     function getLendingPoolCore() public view returns (address payable) {
1343         address payable core = address(uint160(getAddress(LENDING_POOL_CORE)));
1344         return core;
1345     }
1346 
1347     /**
1348     * @dev updates the implementation of the lending pool core
1349     * @param _lendingPoolCore the new lending pool core implementation
1350     **/
1351     function setLendingPoolCoreImpl(address _lendingPoolCore) public onlyOwner {
1352         updateImplInternal(LENDING_POOL_CORE, _lendingPoolCore);
1353         emit LendingPoolCoreUpdated(_lendingPoolCore);
1354     }
1355 
1356     /**
1357     * @dev returns the address of the LendingPoolConfigurator proxy
1358     * @return the lending pool configurator proxy address
1359     **/
1360     function getLendingPoolConfigurator() public view returns (address) {
1361         return getAddress(LENDING_POOL_CONFIGURATOR);
1362     }
1363 
1364     /**
1365     * @dev updates the implementation of the lending pool configurator
1366     * @param _configurator the new lending pool configurator implementation
1367     **/
1368     function setLendingPoolConfiguratorImpl(address _configurator) public onlyOwner {
1369         updateImplInternal(LENDING_POOL_CONFIGURATOR, _configurator);
1370         emit LendingPoolConfiguratorUpdated(_configurator);
1371     }
1372 
1373     /**
1374     * @dev returns the address of the LendingPoolDataProvider proxy
1375     * @return the lending pool data provider proxy address
1376      */
1377     function getLendingPoolDataProvider() public view returns (address) {
1378         return getAddress(DATA_PROVIDER);
1379     }
1380 
1381     /**
1382     * @dev updates the implementation of the lending pool data provider
1383     * @param _provider the new lending pool data provider implementation
1384     **/
1385     function setLendingPoolDataProviderImpl(address _provider) public onlyOwner {
1386         updateImplInternal(DATA_PROVIDER, _provider);
1387         emit LendingPoolDataProviderUpdated(_provider);
1388     }
1389 
1390     /**
1391     * @dev returns the address of the LendingPoolParametersProvider proxy
1392     * @return the address of the Lending pool parameters provider proxy
1393     **/
1394     function getLendingPoolParametersProvider() public view returns (address) {
1395         return getAddress(LENDING_POOL_PARAMETERS_PROVIDER);
1396     }
1397 
1398     /**
1399     * @dev updates the implementation of the lending pool parameters provider
1400     * @param _parametersProvider the new lending pool parameters provider implementation
1401     **/
1402     function setLendingPoolParametersProviderImpl(address _parametersProvider) public onlyOwner {
1403         updateImplInternal(LENDING_POOL_PARAMETERS_PROVIDER, _parametersProvider);
1404         emit LendingPoolParametersProviderUpdated(_parametersProvider);
1405     }
1406 
1407     /**
1408     * @dev returns the address of the FeeProvider proxy
1409     * @return the address of the Fee provider proxy
1410     **/
1411     function getFeeProvider() public view returns (address) {
1412         return getAddress(FEE_PROVIDER);
1413     }
1414 
1415     /**
1416     * @dev updates the implementation of the FeeProvider proxy
1417     * @param _feeProvider the new lending pool fee provider implementation
1418     **/
1419     function setFeeProviderImpl(address _feeProvider) public onlyOwner {
1420         updateImplInternal(FEE_PROVIDER, _feeProvider);
1421         emit FeeProviderUpdated(_feeProvider);
1422     }
1423 
1424     /**
1425     * @dev returns the address of the LendingPoolLiquidationManager. Since the manager is used
1426     * through delegateCall within the LendingPool contract, the proxy contract pattern does not work properly hence
1427     * the addresses are changed directly.
1428     * @return the address of the Lending pool liquidation manager
1429     **/
1430 
1431     function getLendingPoolLiquidationManager() public view returns (address) {
1432         return getAddress(LENDING_POOL_LIQUIDATION_MANAGER);
1433     }
1434 
1435     /**
1436     * @dev updates the address of the Lending pool liquidation manager
1437     * @param _manager the new lending pool liquidation manager address
1438     **/
1439     function setLendingPoolLiquidationManager(address _manager) public onlyOwner {
1440         _setAddress(LENDING_POOL_LIQUIDATION_MANAGER, _manager);
1441         emit LendingPoolLiquidationManagerUpdated(_manager);
1442     }
1443 
1444     /**
1445     * @dev the functions below are storing specific addresses that are outside the context of the protocol
1446     * hence the upgradable proxy pattern is not used
1447     **/
1448 
1449 
1450     function getLendingPoolManager() public view returns (address) {
1451         return getAddress(LENDING_POOL_MANAGER);
1452     }
1453 
1454     function setLendingPoolManager(address _lendingPoolManager) public onlyOwner {
1455         _setAddress(LENDING_POOL_MANAGER, _lendingPoolManager);
1456         emit LendingPoolManagerUpdated(_lendingPoolManager);
1457     }
1458 
1459     function getPriceOracle() public view returns (address) {
1460         return getAddress(PRICE_ORACLE);
1461     }
1462 
1463     function setPriceOracle(address _priceOracle) public onlyOwner {
1464         _setAddress(PRICE_ORACLE, _priceOracle);
1465         emit PriceOracleUpdated(_priceOracle);
1466     }
1467 
1468     function getLendingRateOracle() public view returns (address) {
1469         return getAddress(LENDING_RATE_ORACLE);
1470     }
1471 
1472     function setLendingRateOracle(address _lendingRateOracle) public onlyOwner {
1473         _setAddress(LENDING_RATE_ORACLE, _lendingRateOracle);
1474         emit LendingRateOracleUpdated(_lendingRateOracle);
1475     }
1476 
1477 
1478     function getTokenDistributor() public view returns (address) {
1479         return getAddress(TOKEN_DISTRIBUTOR);
1480     }
1481 
1482     function setTokenDistributor(address _tokenDistributor) public onlyOwner {
1483         _setAddress(TOKEN_DISTRIBUTOR, _tokenDistributor);
1484         emit TokenDistributorUpdated(_tokenDistributor);
1485     }
1486 
1487 
1488     /**
1489     * @dev internal function to update the implementation of a specific component of the protocol
1490     * @param _id the id of the contract to be updated
1491     * @param _newAddress the address of the new implementation
1492     **/
1493     function updateImplInternal(bytes32 _id, address _newAddress) internal {
1494         address payable proxyAddress = address(uint160(getAddress(_id)));
1495 
1496         InitializableAdminUpgradeabilityProxy proxy = InitializableAdminUpgradeabilityProxy(proxyAddress);
1497         bytes memory params = abi.encodeWithSignature("initialize(address)", address(this));
1498 
1499         if (proxyAddress == address(0)) {
1500             proxy = new InitializableAdminUpgradeabilityProxy();
1501             proxy.initialize(_newAddress, address(this), params);
1502             _setAddress(_id, address(proxy));
1503             emit ProxyCreated(_id, address(proxy));
1504         } else {
1505             proxy.upgradeToAndCall(_newAddress, params);
1506         }
1507 
1508     }
1509 }
1510 
1511 contract UintStorage {
1512     mapping(bytes32 => uint256) private uints;
1513 
1514     function getUint(bytes32 _key) public view returns (uint256) {
1515         return uints[_key];
1516     }
1517 
1518     function _setUint(bytes32 _key, uint256 _value) internal {
1519         uints[_key] = _value;
1520     }
1521 
1522 }
1523 
1524 
1525 /**
1526 * @title LendingPoolParametersProvider
1527 * @author Aave
1528 * @notice stores the configuration parameters of the Lending Pool contract
1529 **/
1530 
1531 contract LendingPoolParametersProvider is VersionedInitializable {
1532 
1533     uint256 private constant MAX_STABLE_RATE_BORROW_SIZE_PERCENT = 25;
1534     uint256 private constant REBALANCE_DOWN_RATE_DELTA = (1e27)/5;
1535     uint256 private constant FLASHLOAN_FEE_TOTAL = 35;
1536     uint256 private constant FLASHLOAN_FEE_PROTOCOL = 3000;
1537 
1538     uint256 constant private DATA_PROVIDER_REVISION = 0x1;
1539 
1540     function getRevision() internal pure returns(uint256) {
1541         return DATA_PROVIDER_REVISION;
1542     }
1543 
1544     /**
1545     * @dev initializes the LendingPoolParametersProvider after it's added to the proxy
1546     * @param _addressesProvider the address of the LendingPoolAddressesProvider
1547     */
1548     function initialize(address _addressesProvider) public initializer {
1549     }
1550     /**
1551     * @dev returns the maximum stable rate borrow size, in percentage of the available liquidity.
1552     **/
1553     function getMaxStableRateBorrowSizePercent() external pure returns (uint256)  {
1554         return MAX_STABLE_RATE_BORROW_SIZE_PERCENT;
1555     }
1556 
1557     /**
1558     * @dev returns the delta between the current stable rate and the user stable rate at
1559     *      which the borrow position of the user will be rebalanced (scaled down)
1560     **/
1561     function getRebalanceDownRateDelta() external pure returns (uint256) {
1562         return REBALANCE_DOWN_RATE_DELTA;
1563     }
1564 
1565     /**
1566     * @dev returns the fee applied to a flashloan and the portion to redirect to the protocol, in basis points.
1567     **/
1568     function getFlashLoanFeesInBips() external pure returns (uint256, uint256) {
1569         return (FLASHLOAN_FEE_TOTAL, FLASHLOAN_FEE_PROTOCOL);
1570     }
1571 }
1572 
1573 /**
1574 * @title CoreLibrary library
1575 * @author Aave
1576 * @notice Defines the data structures of the reserves and the user data
1577 **/
1578 library CoreLibrary {
1579     using SafeMath for uint256;
1580     using WadRayMath for uint256;
1581 
1582     enum InterestRateMode {NONE, STABLE, VARIABLE}
1583 
1584     uint256 internal constant SECONDS_PER_YEAR = 365 days;
1585 
1586     struct UserReserveData {
1587         //principal amount borrowed by the user.
1588         uint256 principalBorrowBalance;
1589         //cumulated variable borrow index for the user. Expressed in ray
1590         uint256 lastVariableBorrowCumulativeIndex;
1591         //origination fee cumulated by the user
1592         uint256 originationFee;
1593         // stable borrow rate at which the user has borrowed. Expressed in ray
1594         uint256 stableBorrowRate;
1595         uint40 lastUpdateTimestamp;
1596         //defines if a specific deposit should or not be used as a collateral in borrows
1597         bool useAsCollateral;
1598     }
1599 
1600     struct ReserveData {
1601         /**
1602         * @dev refer to the whitepaper, section 1.1 basic concepts for a formal description of these properties.
1603         **/
1604         //the liquidity index. Expressed in ray
1605         uint256 lastLiquidityCumulativeIndex;
1606         //the current supply rate. Expressed in ray
1607         uint256 currentLiquidityRate;
1608         //the total borrows of the reserve at a stable rate. Expressed in the currency decimals
1609         uint256 totalBorrowsStable;
1610         //the total borrows of the reserve at a variable rate. Expressed in the currency decimals
1611         uint256 totalBorrowsVariable;
1612         //the current variable borrow rate. Expressed in ray
1613         uint256 currentVariableBorrowRate;
1614         //the current stable borrow rate. Expressed in ray
1615         uint256 currentStableBorrowRate;
1616         //the current average stable borrow rate (weighted average of all the different stable rate loans). Expressed in ray
1617         uint256 currentAverageStableBorrowRate;
1618         //variable borrow index. Expressed in ray
1619         uint256 lastVariableBorrowCumulativeIndex;
1620         //the ltv of the reserve. Expressed in percentage (0-100)
1621         uint256 baseLTVasCollateral;
1622         //the liquidation threshold of the reserve. Expressed in percentage (0-100)
1623         uint256 liquidationThreshold;
1624         //the liquidation bonus of the reserve. Expressed in percentage
1625         uint256 liquidationBonus;
1626         //the decimals of the reserve asset
1627         uint256 decimals;
1628         /**
1629         * @dev address of the aToken representing the asset
1630         **/
1631         address aTokenAddress;
1632         /**
1633         * @dev address of the interest rate strategy contract
1634         **/
1635         address interestRateStrategyAddress;
1636         uint40 lastUpdateTimestamp;
1637         // borrowingEnabled = true means users can borrow from this reserve
1638         bool borrowingEnabled;
1639         // usageAsCollateralEnabled = true means users can use this reserve as collateral
1640         bool usageAsCollateralEnabled;
1641         // isStableBorrowRateEnabled = true means users can borrow at a stable rate
1642         bool isStableBorrowRateEnabled;
1643         // isActive = true means the reserve has been activated and properly configured
1644         bool isActive;
1645         // isFreezed = true means the reserve only allows repays and redeems, but not deposits, new borrowings or rate swap
1646         bool isFreezed;
1647     }
1648 
1649     /**
1650     * @dev returns the ongoing normalized income for the reserve.
1651     * a value of 1e27 means there is no income. As time passes, the income is accrued.
1652     * A value of 2*1e27 means that the income of the reserve is double the initial amount.
1653     * @param _reserve the reserve object
1654     * @return the normalized income. expressed in ray
1655     **/
1656     function getNormalizedIncome(CoreLibrary.ReserveData storage _reserve)
1657         internal
1658         view
1659         returns (uint256)
1660     {
1661         uint256 cumulated = calculateLinearInterest(
1662             _reserve
1663                 .currentLiquidityRate,
1664             _reserve
1665                 .lastUpdateTimestamp
1666         )
1667             .rayMul(_reserve.lastLiquidityCumulativeIndex);
1668 
1669         return cumulated;
1670 
1671     }
1672 
1673     /**
1674     * @dev Updates the liquidity cumulative index Ci and variable borrow cumulative index Bvc. Refer to the whitepaper for
1675     * a formal specification.
1676     * @param _self the reserve object
1677     **/
1678     function updateCumulativeIndexes(ReserveData storage _self) internal {
1679         uint256 totalBorrows = getTotalBorrows(_self);
1680 
1681         if (totalBorrows > 0) {
1682             //only cumulating if there is any income being produced
1683             uint256 cumulatedLiquidityInterest = calculateLinearInterest(
1684                 _self.currentLiquidityRate,
1685                 _self.lastUpdateTimestamp
1686             );
1687 
1688             _self.lastLiquidityCumulativeIndex = cumulatedLiquidityInterest.rayMul(
1689                 _self.lastLiquidityCumulativeIndex
1690             );
1691 
1692             uint256 cumulatedVariableBorrowInterest = calculateCompoundedInterest(
1693                 _self.currentVariableBorrowRate,
1694                 _self.lastUpdateTimestamp
1695             );
1696             _self.lastVariableBorrowCumulativeIndex = cumulatedVariableBorrowInterest.rayMul(
1697                 _self.lastVariableBorrowCumulativeIndex
1698             );
1699         }
1700     }
1701 
1702     /**
1703     * @dev accumulates a predefined amount of asset to the reserve as a fixed, one time income. Used for example to accumulate
1704     * the flashloan fee to the reserve, and spread it through the depositors.
1705     * @param _self the reserve object
1706     * @param _totalLiquidity the total liquidity available in the reserve
1707     * @param _amount the amount to accomulate
1708     **/
1709     function cumulateToLiquidityIndex(
1710         ReserveData storage _self,
1711         uint256 _totalLiquidity,
1712         uint256 _amount
1713     ) internal {
1714         uint256 amountToLiquidityRatio = _amount.wadToRay().rayDiv(_totalLiquidity.wadToRay());
1715 
1716         uint256 cumulatedLiquidity = amountToLiquidityRatio.add(WadRayMath.ray());
1717 
1718         _self.lastLiquidityCumulativeIndex = cumulatedLiquidity.rayMul(
1719             _self.lastLiquidityCumulativeIndex
1720         );
1721     }
1722 
1723     /**
1724     * @dev initializes a reserve
1725     * @param _self the reserve object
1726     * @param _aTokenAddress the address of the overlying atoken contract
1727     * @param _decimals the number of decimals of the underlying asset
1728     * @param _interestRateStrategyAddress the address of the interest rate strategy contract
1729     **/
1730     function init(
1731         ReserveData storage _self,
1732         address _aTokenAddress,
1733         uint256 _decimals,
1734         address _interestRateStrategyAddress
1735     ) external {
1736         require(_self.aTokenAddress == address(0), "Reserve has already been initialized");
1737 
1738         if (_self.lastLiquidityCumulativeIndex == 0) {
1739             //if the reserve has not been initialized yet
1740             _self.lastLiquidityCumulativeIndex = WadRayMath.ray();
1741         }
1742 
1743         if (_self.lastVariableBorrowCumulativeIndex == 0) {
1744             _self.lastVariableBorrowCumulativeIndex = WadRayMath.ray();
1745         }
1746 
1747         _self.aTokenAddress = _aTokenAddress;
1748         _self.decimals = _decimals;
1749 
1750         _self.interestRateStrategyAddress = _interestRateStrategyAddress;
1751         _self.isActive = true;
1752         _self.isFreezed = false;
1753 
1754     }
1755 
1756     /**
1757     * @dev enables borrowing on a reserve
1758     * @param _self the reserve object
1759     * @param _stableBorrowRateEnabled true if the stable borrow rate must be enabled by default, false otherwise
1760     **/
1761     function enableBorrowing(ReserveData storage _self, bool _stableBorrowRateEnabled) external {
1762         require(_self.borrowingEnabled == false, "Reserve is already enabled");
1763 
1764         _self.borrowingEnabled = true;
1765         _self.isStableBorrowRateEnabled = _stableBorrowRateEnabled;
1766 
1767     }
1768 
1769     /**
1770     * @dev disables borrowing on a reserve
1771     * @param _self the reserve object
1772     **/
1773     function disableBorrowing(ReserveData storage _self) external {
1774         _self.borrowingEnabled = false;
1775     }
1776 
1777     /**
1778     * @dev enables a reserve to be used as collateral
1779     * @param _self the reserve object
1780     * @param _baseLTVasCollateral the loan to value of the asset when used as collateral
1781     * @param _liquidationThreshold the threshold at which loans using this asset as collateral will be considered undercollateralized
1782     * @param _liquidationBonus the bonus liquidators receive to liquidate this asset
1783     **/
1784     function enableAsCollateral(
1785         ReserveData storage _self,
1786         uint256 _baseLTVasCollateral,
1787         uint256 _liquidationThreshold,
1788         uint256 _liquidationBonus
1789     ) external {
1790         require(
1791             _self.usageAsCollateralEnabled == false,
1792             "Reserve is already enabled as collateral"
1793         );
1794 
1795         _self.usageAsCollateralEnabled = true;
1796         _self.baseLTVasCollateral = _baseLTVasCollateral;
1797         _self.liquidationThreshold = _liquidationThreshold;
1798         _self.liquidationBonus = _liquidationBonus;
1799 
1800         if (_self.lastLiquidityCumulativeIndex == 0)
1801             _self.lastLiquidityCumulativeIndex = WadRayMath.ray();
1802 
1803     }
1804 
1805     /**
1806     * @dev disables a reserve as collateral
1807     * @param _self the reserve object
1808     **/
1809     function disableAsCollateral(ReserveData storage _self) external {
1810         _self.usageAsCollateralEnabled = false;
1811     }
1812 
1813 
1814 
1815     /**
1816     * @dev calculates the compounded borrow balance of a user
1817     * @param _self the userReserve object
1818     * @param _reserve the reserve object
1819     * @return the user compounded borrow balance
1820     **/
1821     function getCompoundedBorrowBalance(
1822         CoreLibrary.UserReserveData storage _self,
1823         CoreLibrary.ReserveData storage _reserve
1824     ) internal view returns (uint256) {
1825         if (_self.principalBorrowBalance == 0) return 0;
1826 
1827         uint256 principalBorrowBalanceRay = _self.principalBorrowBalance.wadToRay();
1828         uint256 compoundedBalance = 0;
1829         uint256 cumulatedInterest = 0;
1830 
1831         if (_self.stableBorrowRate > 0) {
1832             cumulatedInterest = calculateCompoundedInterest(
1833                 _self.stableBorrowRate,
1834                 _self.lastUpdateTimestamp
1835             );
1836         } else {
1837             //variable interest
1838             cumulatedInterest = calculateCompoundedInterest(
1839                 _reserve
1840                     .currentVariableBorrowRate,
1841                 _reserve
1842                     .lastUpdateTimestamp
1843             )
1844                 .rayMul(_reserve.lastVariableBorrowCumulativeIndex)
1845                 .rayDiv(_self.lastVariableBorrowCumulativeIndex);
1846         }
1847 
1848         compoundedBalance = principalBorrowBalanceRay.rayMul(cumulatedInterest).rayToWad();
1849 
1850         if (compoundedBalance == _self.principalBorrowBalance) {
1851             //solium-disable-next-line
1852             if (_self.lastUpdateTimestamp != block.timestamp) {
1853                 //no interest cumulation because of the rounding - we add 1 wei
1854                 //as symbolic cumulated interest to avoid interest free loans.
1855 
1856                 return _self.principalBorrowBalance.add(1 wei);
1857             }
1858         }
1859 
1860         return compoundedBalance;
1861     }
1862 
1863     /**
1864     * @dev increases the total borrows at a stable rate on a specific reserve and updates the
1865     * average stable rate consequently
1866     * @param _reserve the reserve object
1867     * @param _amount the amount to add to the total borrows stable
1868     * @param _rate the rate at which the amount has been borrowed
1869     **/
1870     function increaseTotalBorrowsStableAndUpdateAverageRate(
1871         ReserveData storage _reserve,
1872         uint256 _amount,
1873         uint256 _rate
1874     ) internal {
1875         uint256 previousTotalBorrowStable = _reserve.totalBorrowsStable;
1876         //updating reserve borrows stable
1877         _reserve.totalBorrowsStable = _reserve.totalBorrowsStable.add(_amount);
1878 
1879         //update the average stable rate
1880         //weighted average of all the borrows
1881         uint256 weightedLastBorrow = _amount.wadToRay().rayMul(_rate);
1882         uint256 weightedPreviousTotalBorrows = previousTotalBorrowStable.wadToRay().rayMul(
1883             _reserve.currentAverageStableBorrowRate
1884         );
1885 
1886         _reserve.currentAverageStableBorrowRate = weightedLastBorrow
1887             .add(weightedPreviousTotalBorrows)
1888             .rayDiv(_reserve.totalBorrowsStable.wadToRay());
1889     }
1890 
1891     /**
1892     * @dev decreases the total borrows at a stable rate on a specific reserve and updates the
1893     * average stable rate consequently
1894     * @param _reserve the reserve object
1895     * @param _amount the amount to substract to the total borrows stable
1896     * @param _rate the rate at which the amount has been repaid
1897     **/
1898     function decreaseTotalBorrowsStableAndUpdateAverageRate(
1899         ReserveData storage _reserve,
1900         uint256 _amount,
1901         uint256 _rate
1902     ) internal {
1903         require(_reserve.totalBorrowsStable >= _amount, "Invalid amount to decrease");
1904 
1905         uint256 previousTotalBorrowStable = _reserve.totalBorrowsStable;
1906 
1907         //updating reserve borrows stable
1908         _reserve.totalBorrowsStable = _reserve.totalBorrowsStable.sub(_amount);
1909 
1910         if (_reserve.totalBorrowsStable == 0) {
1911             _reserve.currentAverageStableBorrowRate = 0; //no income if there are no stable rate borrows
1912             return;
1913         }
1914 
1915         //update the average stable rate
1916         //weighted average of all the borrows
1917         uint256 weightedLastBorrow = _amount.wadToRay().rayMul(_rate);
1918         uint256 weightedPreviousTotalBorrows = previousTotalBorrowStable.wadToRay().rayMul(
1919             _reserve.currentAverageStableBorrowRate
1920         );
1921 
1922         require(
1923             weightedPreviousTotalBorrows >= weightedLastBorrow,
1924             "The amounts to subtract don't match"
1925         );
1926 
1927         _reserve.currentAverageStableBorrowRate = weightedPreviousTotalBorrows
1928             .sub(weightedLastBorrow)
1929             .rayDiv(_reserve.totalBorrowsStable.wadToRay());
1930     }
1931 
1932     /**
1933     * @dev increases the total borrows at a variable rate
1934     * @param _reserve the reserve object
1935     * @param _amount the amount to add to the total borrows variable
1936     **/
1937     function increaseTotalBorrowsVariable(ReserveData storage _reserve, uint256 _amount) internal {
1938         _reserve.totalBorrowsVariable = _reserve.totalBorrowsVariable.add(_amount);
1939     }
1940 
1941     /**
1942     * @dev decreases the total borrows at a variable rate
1943     * @param _reserve the reserve object
1944     * @param _amount the amount to substract to the total borrows variable
1945     **/
1946     function decreaseTotalBorrowsVariable(ReserveData storage _reserve, uint256 _amount) internal {
1947         require(
1948             _reserve.totalBorrowsVariable >= _amount,
1949             "The amount that is being subtracted from the variable total borrows is incorrect"
1950         );
1951         _reserve.totalBorrowsVariable = _reserve.totalBorrowsVariable.sub(_amount);
1952     }
1953 
1954     /**
1955     * @dev function to calculate the interest using a linear interest rate formula
1956     * @param _rate the interest rate, in ray
1957     * @param _lastUpdateTimestamp the timestamp of the last update of the interest
1958     * @return the interest rate linearly accumulated during the timeDelta, in ray
1959     **/
1960 
1961     function calculateLinearInterest(uint256 _rate, uint40 _lastUpdateTimestamp)
1962         internal
1963         view
1964         returns (uint256)
1965     {
1966         //solium-disable-next-line
1967         uint256 timeDifference = block.timestamp.sub(uint256(_lastUpdateTimestamp));
1968 
1969         uint256 timeDelta = timeDifference.wadToRay().rayDiv(SECONDS_PER_YEAR.wadToRay());
1970 
1971         return _rate.rayMul(timeDelta).add(WadRayMath.ray());
1972     }
1973 
1974     /**
1975     * @dev function to calculate the interest using a compounded interest rate formula
1976     * @param _rate the interest rate, in ray
1977     * @param _lastUpdateTimestamp the timestamp of the last update of the interest
1978     * @return the interest rate compounded during the timeDelta, in ray
1979     **/
1980     function calculateCompoundedInterest(uint256 _rate, uint40 _lastUpdateTimestamp)
1981         internal
1982         view
1983         returns (uint256)
1984     {
1985         //solium-disable-next-line
1986         uint256 timeDifference = block.timestamp.sub(uint256(_lastUpdateTimestamp));
1987 
1988         uint256 ratePerSecond = _rate.div(SECONDS_PER_YEAR);
1989 
1990         return ratePerSecond.add(WadRayMath.ray()).rayPow(timeDifference);
1991     }
1992 
1993     /**
1994     * @dev returns the total borrows on the reserve
1995     * @param _reserve the reserve object
1996     * @return the total borrows (stable + variable)
1997     **/
1998     function getTotalBorrows(CoreLibrary.ReserveData storage _reserve)
1999         internal
2000         view
2001         returns (uint256)
2002     {
2003         return _reserve.totalBorrowsStable.add(_reserve.totalBorrowsVariable);
2004     }
2005 
2006 }
2007 
2008 
2009 
2010 /**
2011 * @title IPriceOracleGetter interface
2012 * @notice Interface for the Aave price oracle.
2013 **/
2014 
2015 interface IPriceOracleGetter {
2016     /**
2017     * @dev returns the asset price in ETH
2018     * @param _asset the address of the asset
2019     * @return the ETH price of the asset
2020     **/
2021     function getAssetPrice(address _asset) external view returns (uint256);
2022 }
2023 
2024 /**
2025 * @title IFeeProvider interface
2026 * @notice Interface for the Aave fee provider.
2027 **/
2028 
2029 interface IFeeProvider {
2030     function calculateLoanOriginationFee(address _user, uint256 _amount) external view returns (uint256);
2031     function getLoanOriginationFeePercentage() external view returns (uint256);
2032 }
2033 
2034 /**
2035 * @title LendingPoolDataProvider contract
2036 * @author Aave
2037 * @notice Implements functions to fetch data from the core, and aggregate them in order to allow computation
2038 * on the compounded balances and the account balances in ETH
2039 **/
2040 contract LendingPoolDataProvider is VersionedInitializable {
2041     using SafeMath for uint256;
2042     using WadRayMath for uint256;
2043 
2044     LendingPoolCore public core;
2045     LendingPoolAddressesProvider public addressesProvider;
2046 
2047     /**
2048     * @dev specifies the health factor threshold at which the user position is liquidated.
2049     * 1e18 by default, if the health factor drops below 1e18, the loan can be liquidated.
2050     **/
2051     uint256 public constant HEALTH_FACTOR_LIQUIDATION_THRESHOLD = 1e18;
2052 
2053     uint256 public constant DATA_PROVIDER_REVISION = 0x1;
2054 
2055     function getRevision() internal pure returns (uint256) {
2056         return DATA_PROVIDER_REVISION;
2057     }
2058 
2059     function initialize(LendingPoolAddressesProvider _addressesProvider) public initializer {
2060         addressesProvider = _addressesProvider;
2061         core = LendingPoolCore(_addressesProvider.getLendingPoolCore());
2062     }
2063 
2064     /**
2065     * @dev struct to hold calculateUserGlobalData() local computations
2066     **/
2067     struct UserGlobalDataLocalVars {
2068         uint256 reserveUnitPrice;
2069         uint256 tokenUnit;
2070         uint256 compoundedLiquidityBalance;
2071         uint256 compoundedBorrowBalance;
2072         uint256 reserveDecimals;
2073         uint256 baseLtv;
2074         uint256 liquidationThreshold;
2075         uint256 originationFee;
2076         bool usageAsCollateralEnabled;
2077         bool userUsesReserveAsCollateral;
2078         address currentReserve;
2079     }
2080 
2081     /**
2082     * @dev calculates the user data across the reserves.
2083     * this includes the total liquidity/collateral/borrow balances in ETH,
2084     * the average Loan To Value, the average Liquidation Ratio, and the Health factor.
2085     * @param _user the address of the user
2086     * @return the total liquidity, total collateral, total borrow balances of the user in ETH.
2087     * also the average Ltv, liquidation threshold, and the health factor
2088     **/
2089     function calculateUserGlobalData(address _user)
2090         public
2091         view
2092         returns (
2093             uint256 totalLiquidityBalanceETH,
2094             uint256 totalCollateralBalanceETH,
2095             uint256 totalBorrowBalanceETH,
2096             uint256 totalFeesETH,
2097             uint256 currentLtv,
2098             uint256 currentLiquidationThreshold,
2099             uint256 healthFactor,
2100             bool healthFactorBelowThreshold
2101         )
2102     {
2103         IPriceOracleGetter oracle = IPriceOracleGetter(addressesProvider.getPriceOracle());
2104 
2105         // Usage of a memory struct of vars to avoid "Stack too deep" errors due to local variables
2106         UserGlobalDataLocalVars memory vars;
2107 
2108         address[] memory reserves = core.getReserves();
2109 
2110         for (uint256 i = 0; i < reserves.length; i++) {
2111             vars.currentReserve = reserves[i];
2112 
2113             (
2114                 vars.compoundedLiquidityBalance,
2115                 vars.compoundedBorrowBalance,
2116                 vars.originationFee,
2117                 vars.userUsesReserveAsCollateral
2118             ) = core.getUserBasicReserveData(vars.currentReserve, _user);
2119 
2120             if (vars.compoundedLiquidityBalance == 0 && vars.compoundedBorrowBalance == 0) {
2121                 continue;
2122             }
2123 
2124             //fetch reserve data
2125             (
2126                 vars.reserveDecimals,
2127                 vars.baseLtv,
2128                 vars.liquidationThreshold,
2129                 vars.usageAsCollateralEnabled
2130             ) = core.getReserveConfiguration(vars.currentReserve);
2131 
2132             vars.tokenUnit = 10 ** vars.reserveDecimals;
2133             vars.reserveUnitPrice = oracle.getAssetPrice(vars.currentReserve);
2134 
2135             //liquidity and collateral balance
2136             if (vars.compoundedLiquidityBalance > 0) {
2137                 uint256 liquidityBalanceETH = vars
2138                     .reserveUnitPrice
2139                     .mul(vars.compoundedLiquidityBalance)
2140                     .div(vars.tokenUnit);
2141                 totalLiquidityBalanceETH = totalLiquidityBalanceETH.add(liquidityBalanceETH);
2142 
2143                 if (vars.usageAsCollateralEnabled && vars.userUsesReserveAsCollateral) {
2144                     totalCollateralBalanceETH = totalCollateralBalanceETH.add(liquidityBalanceETH);
2145                     currentLtv = currentLtv.add(liquidityBalanceETH.mul(vars.baseLtv));
2146                     currentLiquidationThreshold = currentLiquidationThreshold.add(
2147                         liquidityBalanceETH.mul(vars.liquidationThreshold)
2148                     );
2149                 }
2150             }
2151 
2152             if (vars.compoundedBorrowBalance > 0) {
2153                 totalBorrowBalanceETH = totalBorrowBalanceETH.add(
2154                     vars.reserveUnitPrice.mul(vars.compoundedBorrowBalance).div(vars.tokenUnit)
2155                 );
2156                 totalFeesETH = totalFeesETH.add(
2157                     vars.originationFee.mul(vars.reserveUnitPrice).div(vars.tokenUnit)
2158                 );
2159             }
2160         }
2161 
2162         currentLtv = totalCollateralBalanceETH > 0 ? currentLtv.div(totalCollateralBalanceETH) : 0;
2163         currentLiquidationThreshold = totalCollateralBalanceETH > 0
2164             ? currentLiquidationThreshold.div(totalCollateralBalanceETH)
2165             : 0;
2166 
2167         healthFactor = calculateHealthFactorFromBalancesInternal(
2168             totalCollateralBalanceETH,
2169             totalBorrowBalanceETH,
2170             totalFeesETH,
2171             currentLiquidationThreshold
2172         );
2173         healthFactorBelowThreshold = healthFactor < HEALTH_FACTOR_LIQUIDATION_THRESHOLD;
2174 
2175     }
2176 
2177     struct balanceDecreaseAllowedLocalVars {
2178         uint256 decimals;
2179         uint256 collateralBalanceETH;
2180         uint256 borrowBalanceETH;
2181         uint256 totalFeesETH;
2182         uint256 currentLiquidationThreshold;
2183         uint256 reserveLiquidationThreshold;
2184         uint256 amountToDecreaseETH;
2185         uint256 collateralBalancefterDecrease;
2186         uint256 liquidationThresholdAfterDecrease;
2187         uint256 healthFactorAfterDecrease;
2188         bool reserveUsageAsCollateralEnabled;
2189     }
2190 
2191     /**
2192     * @dev check if a specific balance decrease is allowed (i.e. doesn't bring the user borrow position health factor under 1e18)
2193     * @param _reserve the address of the reserve
2194     * @param _user the address of the user
2195     * @param _amount the amount to decrease
2196     * @return true if the decrease of the balance is allowed
2197     **/
2198 
2199     function balanceDecreaseAllowed(address _reserve, address _user, uint256 _amount)
2200         external
2201         view
2202         returns (bool)
2203     {
2204         // Usage of a memory struct of vars to avoid "Stack too deep" errors due to local variables
2205         balanceDecreaseAllowedLocalVars memory vars;
2206 
2207         (
2208             vars.decimals,
2209             ,
2210             vars.reserveLiquidationThreshold,
2211             vars.reserveUsageAsCollateralEnabled
2212         ) = core.getReserveConfiguration(_reserve);
2213 
2214         if (
2215             !vars.reserveUsageAsCollateralEnabled ||
2216             !core.isUserUseReserveAsCollateralEnabled(_reserve, _user)
2217         ) {
2218             return true; //if reserve is not used as collateral, no reasons to block the transfer
2219         }
2220 
2221         (
2222             ,
2223             vars.collateralBalanceETH,
2224             vars.borrowBalanceETH,
2225             vars.totalFeesETH,
2226             ,
2227             vars.currentLiquidationThreshold,
2228             ,
2229 
2230         ) = calculateUserGlobalData(_user);
2231 
2232         if (vars.borrowBalanceETH == 0) {
2233             return true; //no borrows - no reasons to block the transfer
2234         }
2235 
2236         IPriceOracleGetter oracle = IPriceOracleGetter(addressesProvider.getPriceOracle());
2237 
2238         vars.amountToDecreaseETH = oracle.getAssetPrice(_reserve).mul(_amount).div(
2239             10 ** vars.decimals
2240         );
2241 
2242         vars.collateralBalancefterDecrease = vars.collateralBalanceETH.sub(
2243             vars.amountToDecreaseETH
2244         );
2245 
2246         //if there is a borrow, there can't be 0 collateral
2247         if (vars.collateralBalancefterDecrease == 0) {
2248             return false;
2249         }
2250 
2251         vars.liquidationThresholdAfterDecrease = vars
2252             .collateralBalanceETH
2253             .mul(vars.currentLiquidationThreshold)
2254             .sub(vars.amountToDecreaseETH.mul(vars.reserveLiquidationThreshold))
2255             .div(vars.collateralBalancefterDecrease);
2256 
2257         uint256 healthFactorAfterDecrease = calculateHealthFactorFromBalancesInternal(
2258             vars.collateralBalancefterDecrease,
2259             vars.borrowBalanceETH,
2260             vars.totalFeesETH,
2261             vars.liquidationThresholdAfterDecrease
2262         );
2263 
2264         return healthFactorAfterDecrease > HEALTH_FACTOR_LIQUIDATION_THRESHOLD;
2265 
2266     }
2267 
2268     /**
2269    * @notice calculates the amount of collateral needed in ETH to cover a new borrow.
2270    * @param _reserve the reserve from which the user wants to borrow
2271    * @param _amount the amount the user wants to borrow
2272    * @param _fee the fee for the amount that the user needs to cover
2273    * @param _userCurrentBorrowBalanceTH the current borrow balance of the user (before the borrow)
2274    * @param _userCurrentLtv the average ltv of the user given his current collateral
2275    * @return the total amount of collateral in ETH to cover the current borrow balance + the new amount + fee
2276    **/
2277     function calculateCollateralNeededInETH(
2278         address _reserve,
2279         uint256 _amount,
2280         uint256 _fee,
2281         uint256 _userCurrentBorrowBalanceTH,
2282         uint256 _userCurrentFeesETH,
2283         uint256 _userCurrentLtv
2284     ) external view returns (uint256) {
2285         uint256 reserveDecimals = core.getReserveDecimals(_reserve);
2286 
2287         IPriceOracleGetter oracle = IPriceOracleGetter(addressesProvider.getPriceOracle());
2288 
2289         uint256 requestedBorrowAmountETH = oracle
2290             .getAssetPrice(_reserve)
2291             .mul(_amount.add(_fee))
2292             .div(10 ** reserveDecimals); //price is in ether
2293 
2294         //add the current already borrowed amount to the amount requested to calculate the total collateral needed.
2295         uint256 collateralNeededInETH = _userCurrentBorrowBalanceTH
2296             .add(_userCurrentFeesETH)
2297             .add(requestedBorrowAmountETH)
2298             .mul(100)
2299             .div(_userCurrentLtv); //LTV is calculated in percentage
2300 
2301         return collateralNeededInETH;
2302 
2303     }
2304 
2305     /**
2306     * @dev calculates the equivalent amount in ETH that an user can borrow, depending on the available collateral and the
2307     * average Loan To Value.
2308     * @param collateralBalanceETH the total collateral balance
2309     * @param borrowBalanceETH the total borrow balance
2310     * @param totalFeesETH the total fees
2311     * @param ltv the average loan to value
2312     * @return the amount available to borrow in ETH for the user
2313     **/
2314 
2315     function calculateAvailableBorrowsETHInternal(
2316         uint256 collateralBalanceETH,
2317         uint256 borrowBalanceETH,
2318         uint256 totalFeesETH,
2319         uint256 ltv
2320     ) internal view returns (uint256) {
2321         uint256 availableBorrowsETH = collateralBalanceETH.mul(ltv).div(100); //ltv is in percentage
2322 
2323         if (availableBorrowsETH < borrowBalanceETH) {
2324             return 0;
2325         }
2326 
2327         availableBorrowsETH = availableBorrowsETH.sub(borrowBalanceETH.add(totalFeesETH));
2328         //calculate fee
2329         uint256 borrowFee = IFeeProvider(addressesProvider.getFeeProvider())
2330             .calculateLoanOriginationFee(msg.sender, availableBorrowsETH);
2331         return availableBorrowsETH.sub(borrowFee);
2332     }
2333 
2334     /**
2335     * @dev calculates the health factor from the corresponding balances
2336     * @param collateralBalanceETH the total collateral balance in ETH
2337     * @param borrowBalanceETH the total borrow balance in ETH
2338     * @param totalFeesETH the total fees in ETH
2339     * @param liquidationThreshold the avg liquidation threshold
2340     **/
2341     function calculateHealthFactorFromBalancesInternal(
2342         uint256 collateralBalanceETH,
2343         uint256 borrowBalanceETH,
2344         uint256 totalFeesETH,
2345         uint256 liquidationThreshold
2346     ) internal pure returns (uint256) {
2347         if (borrowBalanceETH == 0) return uint256(-1);
2348 
2349         return
2350             (collateralBalanceETH.mul(liquidationThreshold).div(100)).wadDiv(
2351                 borrowBalanceETH.add(totalFeesETH)
2352             );
2353     }
2354 
2355     /**
2356     * @dev returns the health factor liquidation threshold
2357     **/
2358     function getHealthFactorLiquidationThreshold() public pure returns (uint256) {
2359         return HEALTH_FACTOR_LIQUIDATION_THRESHOLD;
2360     }
2361 
2362     /**
2363     * @dev accessory functions to fetch data from the lendingPoolCore
2364     **/
2365     function getReserveConfigurationData(address _reserve)
2366         external
2367         view
2368         returns (
2369             uint256 ltv,
2370             uint256 liquidationThreshold,
2371             uint256 liquidationBonus,
2372             address rateStrategyAddress,
2373             bool usageAsCollateralEnabled,
2374             bool borrowingEnabled,
2375             bool stableBorrowRateEnabled,
2376             bool isActive
2377         )
2378     {
2379         (, ltv, liquidationThreshold, usageAsCollateralEnabled) = core.getReserveConfiguration(
2380             _reserve
2381         );
2382         stableBorrowRateEnabled = core.getReserveIsStableBorrowRateEnabled(_reserve);
2383         borrowingEnabled = core.isReserveBorrowingEnabled(_reserve);
2384         isActive = core.getReserveIsActive(_reserve);
2385         liquidationBonus = core.getReserveLiquidationBonus(_reserve);
2386 
2387         rateStrategyAddress = core.getReserveInterestRateStrategyAddress(_reserve);
2388     }
2389 
2390     function getReserveData(address _reserve)
2391         external
2392         view
2393         returns (
2394             uint256 totalLiquidity,
2395             uint256 availableLiquidity,
2396             uint256 totalBorrowsStable,
2397             uint256 totalBorrowsVariable,
2398             uint256 liquidityRate,
2399             uint256 variableBorrowRate,
2400             uint256 stableBorrowRate,
2401             uint256 averageStableBorrowRate,
2402             uint256 utilizationRate,
2403             uint256 liquidityIndex,
2404             uint256 variableBorrowIndex,
2405             address aTokenAddress,
2406             uint40 lastUpdateTimestamp
2407         )
2408     {
2409         totalLiquidity = core.getReserveTotalLiquidity(_reserve);
2410         availableLiquidity = core.getReserveAvailableLiquidity(_reserve);
2411         totalBorrowsStable = core.getReserveTotalBorrowsStable(_reserve);
2412         totalBorrowsVariable = core.getReserveTotalBorrowsVariable(_reserve);
2413         liquidityRate = core.getReserveCurrentLiquidityRate(_reserve);
2414         variableBorrowRate = core.getReserveCurrentVariableBorrowRate(_reserve);
2415         stableBorrowRate = core.getReserveCurrentStableBorrowRate(_reserve);
2416         averageStableBorrowRate = core.getReserveCurrentAverageStableBorrowRate(_reserve);
2417         utilizationRate = core.getReserveUtilizationRate(_reserve);
2418         liquidityIndex = core.getReserveLiquidityCumulativeIndex(_reserve);
2419         variableBorrowIndex = core.getReserveVariableBorrowsCumulativeIndex(_reserve);
2420         aTokenAddress = core.getReserveATokenAddress(_reserve);
2421         lastUpdateTimestamp = core.getReserveLastUpdate(_reserve);
2422     }
2423 
2424     function getUserAccountData(address _user)
2425         external
2426         view
2427         returns (
2428             uint256 totalLiquidityETH,
2429             uint256 totalCollateralETH,
2430             uint256 totalBorrowsETH,
2431             uint256 totalFeesETH,
2432             uint256 availableBorrowsETH,
2433             uint256 currentLiquidationThreshold,
2434             uint256 ltv,
2435             uint256 healthFactor
2436         )
2437     {
2438         (
2439             totalLiquidityETH,
2440             totalCollateralETH,
2441             totalBorrowsETH,
2442             totalFeesETH,
2443             ltv,
2444             currentLiquidationThreshold,
2445             healthFactor,
2446 
2447         ) = calculateUserGlobalData(_user);
2448 
2449         availableBorrowsETH = calculateAvailableBorrowsETHInternal(
2450             totalCollateralETH,
2451             totalBorrowsETH,
2452             totalFeesETH,
2453             ltv
2454         );
2455     }
2456 
2457     function getUserReserveData(address _reserve, address _user)
2458         external
2459         view
2460         returns (
2461             uint256 currentATokenBalance,
2462             uint256 currentBorrowBalance,
2463             uint256 principalBorrowBalance,
2464             uint256 borrowRateMode,
2465             uint256 borrowRate,
2466             uint256 liquidityRate,
2467             uint256 originationFee,
2468             uint256 variableBorrowIndex,
2469             uint256 lastUpdateTimestamp,
2470             bool usageAsCollateralEnabled
2471         )
2472     {
2473         currentATokenBalance = AToken(core.getReserveATokenAddress(_reserve)).balanceOf(_user);
2474         CoreLibrary.InterestRateMode mode = core.getUserCurrentBorrowRateMode(_reserve, _user);
2475         (principalBorrowBalance, currentBorrowBalance, ) = core.getUserBorrowBalances(
2476             _reserve,
2477             _user
2478         );
2479 
2480         //default is 0, if mode == CoreLibrary.InterestRateMode.NONE
2481         if (mode == CoreLibrary.InterestRateMode.STABLE) {
2482             borrowRate = core.getUserCurrentStableBorrowRate(_reserve, _user);
2483         } else if (mode == CoreLibrary.InterestRateMode.VARIABLE) {
2484             borrowRate = core.getReserveCurrentVariableBorrowRate(_reserve);
2485         }
2486 
2487         borrowRateMode = uint256(mode);
2488         liquidityRate = core.getReserveCurrentLiquidityRate(_reserve);
2489         originationFee = core.getUserOriginationFee(_reserve, _user);
2490         variableBorrowIndex = core.getUserVariableBorrowCumulativeIndex(_reserve, _user);
2491         lastUpdateTimestamp = core.getUserLastUpdate(_reserve, _user);
2492         usageAsCollateralEnabled = core.isUserUseReserveAsCollateralEnabled(_reserve, _user);
2493     }
2494 }
2495 
2496 
2497 /**
2498  * @title Aave ERC20 AToken
2499  *
2500  * @dev Implementation of the interest bearing token for the DLP protocol.
2501  * @author Aave
2502  */
2503 contract AToken is ERC20, ERC20Detailed {
2504     using WadRayMath for uint256;
2505 
2506     uint256 public constant UINT_MAX_VALUE = uint256(-1);
2507 
2508     /**
2509     * @dev emitted after the redeem action
2510     * @param _from the address performing the redeem
2511     * @param _value the amount to be redeemed
2512     * @param _fromBalanceIncrease the cumulated balance since the last update of the user
2513     * @param _fromIndex the last index of the user
2514     **/
2515     event Redeem(
2516         address indexed _from,
2517         uint256 _value,
2518         uint256 _fromBalanceIncrease,
2519         uint256 _fromIndex
2520     );
2521 
2522     /**
2523     * @dev emitted after the mint action
2524     * @param _from the address performing the mint
2525     * @param _value the amount to be minted
2526     * @param _fromBalanceIncrease the cumulated balance since the last update of the user
2527     * @param _fromIndex the last index of the user
2528     **/
2529     event MintOnDeposit(
2530         address indexed _from,
2531         uint256 _value,
2532         uint256 _fromBalanceIncrease,
2533         uint256 _fromIndex
2534     );
2535 
2536     /**
2537     * @dev emitted during the liquidation action, when the liquidator reclaims the underlying
2538     * asset
2539     * @param _from the address from which the tokens are being burned
2540     * @param _value the amount to be burned
2541     * @param _fromBalanceIncrease the cumulated balance since the last update of the user
2542     * @param _fromIndex the last index of the user
2543     **/
2544     event BurnOnLiquidation(
2545         address indexed _from,
2546         uint256 _value,
2547         uint256 _fromBalanceIncrease,
2548         uint256 _fromIndex
2549     );
2550 
2551     /**
2552     * @dev emitted during the transfer action
2553     * @param _from the address from which the tokens are being transferred
2554     * @param _to the adress of the destination
2555     * @param _value the amount to be minted
2556     * @param _fromBalanceIncrease the cumulated balance since the last update of the user
2557     * @param _toBalanceIncrease the cumulated balance since the last update of the destination
2558     * @param _fromIndex the last index of the user
2559     * @param _toIndex the last index of the liquidator
2560     **/
2561     event BalanceTransfer(
2562         address indexed _from,
2563         address indexed _to,
2564         uint256 _value,
2565         uint256 _fromBalanceIncrease,
2566         uint256 _toBalanceIncrease,
2567         uint256 _fromIndex,
2568         uint256 _toIndex
2569     );
2570 
2571     /**
2572     * @dev emitted when the accumulation of the interest
2573     * by an user is redirected to another user
2574     * @param _from the address from which the interest is being redirected
2575     * @param _to the adress of the destination
2576     * @param _fromBalanceIncrease the cumulated balance since the last update of the user
2577     * @param _fromIndex the last index of the user
2578     **/
2579     event InterestStreamRedirected(
2580         address indexed _from,
2581         address indexed _to,
2582         uint256 _redirectedBalance,
2583         uint256 _fromBalanceIncrease,
2584         uint256 _fromIndex
2585     );
2586 
2587     /**
2588     * @dev emitted when the redirected balance of an user is being updated
2589     * @param _targetAddress the address of which the balance is being updated
2590     * @param _targetBalanceIncrease the cumulated balance since the last update of the target
2591     * @param _targetIndex the last index of the user
2592     * @param _redirectedBalanceAdded the redirected balance being added
2593     * @param _redirectedBalanceRemoved the redirected balance being removed
2594     **/
2595     event RedirectedBalanceUpdated(
2596         address indexed _targetAddress,
2597         uint256 _targetBalanceIncrease,
2598         uint256 _targetIndex,
2599         uint256 _redirectedBalanceAdded,
2600         uint256 _redirectedBalanceRemoved
2601     );
2602 
2603     event InterestRedirectionAllowanceChanged(
2604         address indexed _from,
2605         address indexed _to
2606     );
2607 
2608     address public underlyingAssetAddress;
2609 
2610     mapping (address => uint256) private userIndexes;
2611     mapping (address => address) private interestRedirectionAddresses;
2612     mapping (address => uint256) private redirectedBalances;
2613     mapping (address => address) private interestRedirectionAllowances;
2614 
2615     LendingPoolAddressesProvider private addressesProvider;
2616     LendingPoolCore private core;
2617     LendingPool private pool;
2618     LendingPoolDataProvider private dataProvider;
2619 
2620     modifier onlyLendingPool {
2621         require(
2622             msg.sender == address(pool),
2623             "The caller of this function must be a lending pool"
2624         );
2625         _;
2626     }
2627 
2628     modifier whenTransferAllowed(address _from, uint256 _amount) {
2629         require(isTransferAllowed(_from, _amount), "Transfer cannot be allowed.");
2630         _;
2631     }
2632 
2633     constructor(
2634         LendingPoolAddressesProvider _addressesProvider,
2635         address _underlyingAsset,
2636         uint8 _underlyingAssetDecimals,
2637         string memory _name,
2638         string memory _symbol
2639     ) public ERC20Detailed(_name, _symbol, _underlyingAssetDecimals) {
2640 
2641         addressesProvider = _addressesProvider;
2642         core = LendingPoolCore(addressesProvider.getLendingPoolCore());
2643         pool = LendingPool(addressesProvider.getLendingPool());
2644         dataProvider = LendingPoolDataProvider(addressesProvider.getLendingPoolDataProvider());
2645         underlyingAssetAddress = _underlyingAsset;
2646     }
2647 
2648     /**
2649      * @notice ERC20 implementation internal function backing transfer() and transferFrom()
2650      * @dev validates the transfer before allowing it. NOTE: This is not standard ERC20 behavior
2651      **/
2652     function _transfer(address _from, address _to, uint256 _amount) internal whenTransferAllowed(_from, _amount) {
2653 
2654         executeTransferInternal(_from, _to, _amount);
2655     }
2656 
2657 
2658     /**
2659     * @dev redirects the interest generated to a target address.
2660     * when the interest is redirected, the user balance is added to
2661     * the recepient redirected balance.
2662     * @param _to the address to which the interest will be redirected
2663     **/
2664     function redirectInterestStream(address _to) external {
2665         redirectInterestStreamInternal(msg.sender, _to);
2666     }
2667 
2668     /**
2669     * @dev redirects the interest generated by _from to a target address.
2670     * when the interest is redirected, the user balance is added to
2671     * the recepient redirected balance. The caller needs to have allowance on
2672     * the interest redirection to be able to execute the function.
2673     * @param _from the address of the user whom interest is being redirected
2674     * @param _to the address to which the interest will be redirected
2675     **/
2676     function redirectInterestStreamOf(address _from, address _to) external {
2677         require(
2678             msg.sender == interestRedirectionAllowances[_from],
2679             "Caller is not allowed to redirect the interest of the user"
2680         );
2681         redirectInterestStreamInternal(_from,_to);
2682     }
2683 
2684     /**
2685     * @dev gives allowance to an address to execute the interest redirection
2686     * on behalf of the caller.
2687     * @param _to the address to which the interest will be redirected. Pass address(0) to reset
2688     * the allowance.
2689     **/
2690     function allowInterestRedirectionTo(address _to) external {
2691         require(_to != msg.sender, "User cannot give allowance to himself");
2692         interestRedirectionAllowances[msg.sender] = _to;
2693         emit InterestRedirectionAllowanceChanged(
2694             msg.sender,
2695             _to
2696         );
2697     }
2698 
2699     /**
2700     * @dev redeems aToken for the underlying asset
2701     * @param _amount the amount being redeemed
2702     **/
2703     function redeem(uint256 _amount) external {
2704 
2705         require(_amount > 0, "Amount to redeem needs to be > 0");
2706 
2707         //cumulates the balance of the user
2708         (,
2709         uint256 currentBalance,
2710         uint256 balanceIncrease,
2711         uint256 index) = cumulateBalanceInternal(msg.sender);
2712 
2713         uint256 amountToRedeem = _amount;
2714 
2715         //if amount is equal to uint(-1), the user wants to redeem everything
2716         if(_amount == UINT_MAX_VALUE){
2717             amountToRedeem = currentBalance;
2718         }
2719 
2720         require(amountToRedeem <= currentBalance, "User cannot redeem more than the available balance");
2721 
2722         //check that the user is allowed to redeem the amount
2723         require(isTransferAllowed(msg.sender, amountToRedeem), "Transfer cannot be allowed.");
2724 
2725         //if the user is redirecting his interest towards someone else,
2726         //we update the redirected balance of the redirection address by adding the accrued interest,
2727         //and removing the amount to redeem
2728         updateRedirectedBalanceOfRedirectionAddressInternal(msg.sender, balanceIncrease, amountToRedeem);
2729 
2730         // burns tokens equivalent to the amount requested
2731         _burn(msg.sender, amountToRedeem);
2732 
2733         bool userIndexReset = false;
2734         //reset the user data if the remaining balance is 0
2735         if(currentBalance.sub(amountToRedeem) == 0){
2736             userIndexReset = resetDataOnZeroBalanceInternal(msg.sender);
2737         }
2738 
2739         // executes redeem of the underlying asset
2740         pool.redeemUnderlying(
2741             underlyingAssetAddress,
2742             msg.sender,
2743             amountToRedeem,
2744             currentBalance.sub(amountToRedeem)
2745         );
2746 
2747         emit Redeem(msg.sender, amountToRedeem, balanceIncrease, userIndexReset ? 0 : index);
2748     }
2749 
2750     /**
2751      * @dev mints token in the event of users depositing the underlying asset into the lending pool
2752      * only lending pools can call this function
2753      * @param _account the address receiving the minted tokens
2754      * @param _amount the amount of tokens to mint
2755      */
2756     function mintOnDeposit(address _account, uint256 _amount) external onlyLendingPool {
2757 
2758         //cumulates the balance of the user
2759         (,
2760         ,
2761         uint256 balanceIncrease,
2762         uint256 index) = cumulateBalanceInternal(_account);
2763 
2764          //if the user is redirecting his interest towards someone else,
2765         //we update the redirected balance of the redirection address by adding the accrued interest
2766         //and the amount deposited
2767         updateRedirectedBalanceOfRedirectionAddressInternal(_account, balanceIncrease.add(_amount), 0);
2768 
2769         //mint an equivalent amount of tokens to cover the new deposit
2770         _mint(_account, _amount);
2771 
2772         emit MintOnDeposit(_account, _amount, balanceIncrease, index);
2773     }
2774 
2775     /**
2776      * @dev burns token in the event of a borrow being liquidated, in case the liquidators reclaims the underlying asset
2777      * Transfer of the liquidated asset is executed by the lending pool contract.
2778      * only lending pools can call this function
2779      * @param _account the address from which burn the aTokens
2780      * @param _value the amount to burn
2781      **/
2782     function burnOnLiquidation(address _account, uint256 _value) external onlyLendingPool {
2783 
2784         //cumulates the balance of the user being liquidated
2785         (,uint256 accountBalance,uint256 balanceIncrease,uint256 index) = cumulateBalanceInternal(_account);
2786 
2787         //adds the accrued interest and substracts the burned amount to
2788         //the redirected balance
2789         updateRedirectedBalanceOfRedirectionAddressInternal(_account, balanceIncrease, _value);
2790 
2791         //burns the requested amount of tokens
2792         _burn(_account, _value);
2793 
2794         bool userIndexReset = false;
2795         //reset the user data if the remaining balance is 0
2796         if(accountBalance.sub(_value) == 0){
2797             userIndexReset = resetDataOnZeroBalanceInternal(_account);
2798         }
2799 
2800         emit BurnOnLiquidation(_account, _value, balanceIncrease, userIndexReset ? 0 : index);
2801     }
2802 
2803     /**
2804      * @dev transfers tokens in the event of a borrow being liquidated, in case the liquidators reclaims the aToken
2805      *      only lending pools can call this function
2806      * @param _from the address from which transfer the aTokens
2807      * @param _to the destination address
2808      * @param _value the amount to transfer
2809      **/
2810     function transferOnLiquidation(address _from, address _to, uint256 _value) external onlyLendingPool {
2811 
2812         //being a normal transfer, the Transfer() and BalanceTransfer() are emitted
2813         //so no need to emit a specific event here
2814         executeTransferInternal(_from, _to, _value);
2815     }
2816 
2817     /**
2818     * @dev calculates the balance of the user, which is the
2819     * principal balance + interest generated by the principal balance + interest generated by the redirected balance
2820     * @param _user the user for which the balance is being calculated
2821     * @return the total balance of the user
2822     **/
2823     function balanceOf(address _user) public view returns(uint256) {
2824 
2825         //current principal balance of the user
2826         uint256 currentPrincipalBalance = super.balanceOf(_user);
2827         //balance redirected by other users to _user for interest rate accrual
2828         uint256 redirectedBalance = redirectedBalances[_user];
2829 
2830         if(currentPrincipalBalance == 0 && redirectedBalance == 0){
2831             return 0;
2832         }
2833         //if the _user is not redirecting the interest to anybody, accrues
2834         //the interest for himself
2835 
2836         if(interestRedirectionAddresses[_user] == address(0)){
2837 
2838             //accruing for himself means that both the principal balance and
2839             //the redirected balance partecipate in the interest
2840             return calculateCumulatedBalanceInternal(
2841                 _user,
2842                 currentPrincipalBalance.add(redirectedBalance)
2843                 )
2844                 .sub(redirectedBalance);
2845         }
2846         else {
2847             //if the user redirected the interest, then only the redirected
2848             //balance generates interest. In that case, the interest generated
2849             //by the redirected balance is added to the current principal balance.
2850             return currentPrincipalBalance.add(
2851                 calculateCumulatedBalanceInternal(
2852                     _user,
2853                     redirectedBalance
2854                 )
2855                 .sub(redirectedBalance)
2856             );
2857         }
2858     }
2859 
2860     /**
2861     * @dev returns the principal balance of the user. The principal balance is the last
2862     * updated stored balance, which does not consider the perpetually accruing interest.
2863     * @param _user the address of the user
2864     * @return the principal balance of the user
2865     **/
2866     function principalBalanceOf(address _user) external view returns(uint256) {
2867         return super.balanceOf(_user);
2868     }
2869 
2870 
2871     /**
2872     * @dev calculates the total supply of the specific aToken
2873     * since the balance of every single user increases over time, the total supply
2874     * does that too.
2875     * @return the current total supply
2876     **/
2877     function totalSupply() public view returns(uint256) {
2878 
2879         uint256 currentSupplyPrincipal = super.totalSupply();
2880 
2881         if(currentSupplyPrincipal == 0){
2882             return 0;
2883         }
2884 
2885         return currentSupplyPrincipal
2886             .wadToRay()
2887             .rayMul(core.getReserveNormalizedIncome(underlyingAssetAddress))
2888             .rayToWad();
2889     }
2890 
2891 
2892     /**
2893      * @dev Used to validate transfers before actually executing them.
2894      * @param _user address of the user to check
2895      * @param _amount the amount to check
2896      * @return true if the _user can transfer _amount, false otherwise
2897      **/
2898     function isTransferAllowed(address _user, uint256 _amount) public view returns (bool) {
2899         return dataProvider.balanceDecreaseAllowed(underlyingAssetAddress, _user, _amount);
2900     }
2901 
2902     /**
2903     * @dev returns the last index of the user, used to calculate the balance of the user
2904     * @param _user address of the user
2905     * @return the last user index
2906     **/
2907     function getUserIndex(address _user) external view returns(uint256) {
2908         return userIndexes[_user];
2909     }
2910 
2911 
2912     /**
2913     * @dev returns the address to which the interest is redirected
2914     * @param _user address of the user
2915     * @return 0 if there is no redirection, an address otherwise
2916     **/
2917     function getInterestRedirectionAddress(address _user) external view returns(address) {
2918         return interestRedirectionAddresses[_user];
2919     }
2920 
2921     /**
2922     * @dev returns the redirected balance of the user. The redirected balance is the balance
2923     * redirected by other accounts to the user, that is accrueing interest for him.
2924     * @param _user address of the user
2925     * @return the total redirected balance
2926     **/
2927     function getRedirectedBalance(address _user) external view returns(uint256) {
2928         return redirectedBalances[_user];
2929     }
2930 
2931     /**
2932     * @dev accumulates the accrued interest of the user to the principal balance
2933     * @param _user the address of the user for which the interest is being accumulated
2934     * @return the previous principal balance, the new principal balance, the balance increase
2935     * and the new user index
2936     **/
2937     function cumulateBalanceInternal(address _user)
2938         internal
2939         returns(uint256, uint256, uint256, uint256) {
2940 
2941         uint256 previousPrincipalBalance = super.balanceOf(_user);
2942 
2943         //calculate the accrued interest since the last accumulation
2944         uint256 balanceIncrease = balanceOf(_user).sub(previousPrincipalBalance);
2945         //mints an amount of tokens equivalent to the amount accumulated
2946         _mint(_user, balanceIncrease);
2947         //updates the user index
2948         uint256 index = userIndexes[_user] = core.getReserveNormalizedIncome(underlyingAssetAddress);
2949         return (
2950             previousPrincipalBalance,
2951             previousPrincipalBalance.add(balanceIncrease),
2952             balanceIncrease,
2953             index
2954         );
2955     }
2956 
2957     /**
2958     * @dev updates the redirected balance of the user. If the user is not redirecting his
2959     * interest, nothing is executed.
2960     * @param _user the address of the user for which the interest is being accumulated
2961     * @param _balanceToAdd the amount to add to the redirected balance
2962     * @param _balanceToRemove the amount to remove from the redirected balance
2963     **/
2964     function updateRedirectedBalanceOfRedirectionAddressInternal(
2965         address _user,
2966         uint256 _balanceToAdd,
2967         uint256 _balanceToRemove
2968     ) internal {
2969 
2970         address redirectionAddress = interestRedirectionAddresses[_user];
2971         //if there isn't any redirection, nothing to be done
2972         if(redirectionAddress == address(0)){
2973             return;
2974         }
2975 
2976         //compound balances of the redirected address
2977         (,,uint256 balanceIncrease, uint256 index) = cumulateBalanceInternal(redirectionAddress);
2978 
2979         //updating the redirected balance
2980         redirectedBalances[redirectionAddress] = redirectedBalances[redirectionAddress]
2981             .add(_balanceToAdd)
2982             .sub(_balanceToRemove);
2983 
2984         //if the interest of redirectionAddress is also being redirected, we need to update
2985         //the redirected balance of the redirection target by adding the balance increase
2986         address targetOfRedirectionAddress = interestRedirectionAddresses[redirectionAddress];
2987 
2988         if(targetOfRedirectionAddress != address(0)){
2989             redirectedBalances[targetOfRedirectionAddress] = redirectedBalances[targetOfRedirectionAddress].add(balanceIncrease);
2990         }
2991 
2992         emit RedirectedBalanceUpdated(
2993             redirectionAddress,
2994             balanceIncrease,
2995             index,
2996             _balanceToAdd,
2997             _balanceToRemove
2998         );
2999     }
3000 
3001     /**
3002     * @dev calculate the interest accrued by _user on a specific balance
3003     * @param _user the address of the user for which the interest is being accumulated
3004     * @param _balance the balance on which the interest is calculated
3005     * @return the interest rate accrued
3006     **/
3007     function calculateCumulatedBalanceInternal(
3008         address _user,
3009         uint256 _balance
3010     ) internal view returns (uint256) {
3011         return _balance
3012             .wadToRay()
3013             .rayMul(core.getReserveNormalizedIncome(underlyingAssetAddress))
3014             .rayDiv(userIndexes[_user])
3015             .rayToWad();
3016     }
3017 
3018     /**
3019     * @dev executes the transfer of aTokens, invoked by both _transfer() and
3020     *      transferOnLiquidation()
3021     * @param _from the address from which transfer the aTokens
3022     * @param _to the destination address
3023     * @param _value the amount to transfer
3024     **/
3025     function executeTransferInternal(
3026         address _from,
3027         address _to,
3028         uint256 _value
3029     ) internal {
3030 
3031         require(_value > 0, "Transferred amount needs to be greater than zero");
3032 
3033         //cumulate the balance of the sender
3034         (,
3035         uint256 fromBalance,
3036         uint256 fromBalanceIncrease,
3037         uint256 fromIndex
3038         ) = cumulateBalanceInternal(_from);
3039 
3040         //cumulate the balance of the receiver
3041         (,
3042         ,
3043         uint256 toBalanceIncrease,
3044         uint256 toIndex
3045         ) = cumulateBalanceInternal(_to);
3046 
3047         //if the sender is redirecting his interest towards someone else,
3048         //adds to the redirected balance the accrued interest and removes the amount
3049         //being transferred
3050         updateRedirectedBalanceOfRedirectionAddressInternal(_from, fromBalanceIncrease, _value);
3051 
3052         //if the receiver is redirecting his interest towards someone else,
3053         //adds to the redirected balance the accrued interest and the amount
3054         //being transferred
3055         updateRedirectedBalanceOfRedirectionAddressInternal(_to, toBalanceIncrease.add(_value), 0);
3056 
3057         //performs the transfer
3058         super._transfer(_from, _to, _value);
3059 
3060         bool fromIndexReset = false;
3061         //reset the user data if the remaining balance is 0
3062         if(fromBalance.sub(_value) == 0){
3063             fromIndexReset = resetDataOnZeroBalanceInternal(_from);
3064         }
3065 
3066         emit BalanceTransfer(
3067             _from,
3068             _to,
3069             _value,
3070             fromBalanceIncrease,
3071             toBalanceIncrease,
3072             fromIndexReset ? 0 : fromIndex,
3073             toIndex
3074         );
3075     }
3076 
3077     /**
3078     * @dev executes the redirection of the interest from one address to another.
3079     * immediately after redirection, the destination address will start to accrue interest.
3080     * @param _from the address from which transfer the aTokens
3081     * @param _to the destination address
3082     **/
3083     function redirectInterestStreamInternal(
3084         address _from,
3085         address _to
3086     ) internal {
3087 
3088         address currentRedirectionAddress = interestRedirectionAddresses[_from];
3089 
3090         require(_to != currentRedirectionAddress, "Interest is already redirected to the user");
3091 
3092         //accumulates the accrued interest to the principal
3093         (uint256 previousPrincipalBalance,
3094         uint256 fromBalance,
3095         uint256 balanceIncrease,
3096         uint256 fromIndex) = cumulateBalanceInternal(_from);
3097 
3098         require(fromBalance > 0, "Interest stream can only be redirected if there is a valid balance");
3099 
3100         //if the user is already redirecting the interest to someone, before changing
3101         //the redirection address we substract the redirected balance of the previous
3102         //recipient
3103         if(currentRedirectionAddress != address(0)){
3104             updateRedirectedBalanceOfRedirectionAddressInternal(_from,0, previousPrincipalBalance);
3105         }
3106 
3107         //if the user is redirecting the interest back to himself,
3108         //we simply set to 0 the interest redirection address
3109         if(_to == _from) {
3110             interestRedirectionAddresses[_from] = address(0);
3111             emit InterestStreamRedirected(
3112                 _from,
3113                 address(0),
3114                 fromBalance,
3115                 balanceIncrease,
3116                 fromIndex
3117             );
3118             return;
3119         }
3120 
3121         //first set the redirection address to the new recipient
3122         interestRedirectionAddresses[_from] = _to;
3123 
3124         //adds the user balance to the redirected balance of the destination
3125         updateRedirectedBalanceOfRedirectionAddressInternal(_from,fromBalance,0);
3126 
3127         emit InterestStreamRedirected(
3128             _from,
3129             _to,
3130             fromBalance,
3131             balanceIncrease,
3132             fromIndex
3133         );
3134     }
3135 
3136     /**
3137     * @dev function to reset the interest stream redirection and the user index, if the
3138     * user has no balance left.
3139     * @param _user the address of the user
3140     * @return true if the user index has also been reset, false otherwise. useful to emit the proper user index value
3141     **/
3142     function resetDataOnZeroBalanceInternal(address _user) internal returns(bool) {
3143 
3144         //if the user has 0 principal balance, the interest stream redirection gets reset
3145         interestRedirectionAddresses[_user] = address(0);
3146 
3147         //emits a InterestStreamRedirected event to notify that the redirection has been reset
3148         emit InterestStreamRedirected(_user, address(0),0,0,0);
3149 
3150         //if the redirected balance is also 0, we clear up the user index
3151         if(redirectedBalances[_user] == 0){
3152             userIndexes[_user] = 0;
3153             return true;
3154         }
3155         else{
3156             return false;
3157         }
3158     }
3159 }
3160 
3161 /**
3162 * @title IFlashLoanReceiver interface
3163 * @notice Interface for the Aave fee IFlashLoanReceiver.
3164 * @author Aave
3165 * @dev implement this interface to develop a flashloan-compatible flashLoanReceiver contract
3166 **/
3167 interface IFlashLoanReceiver {
3168 
3169     function executeOperation(address _reserve, uint256 _amount, uint256 _fee, bytes calldata _params) external;
3170 }
3171 
3172 /**
3173 * @title ILendingRateOracle interface
3174 * @notice Interface for the Aave borrow rate oracle. Provides the average market borrow rate to be used as a base for the stable borrow rate calculations
3175 **/
3176 
3177 interface ILendingRateOracle {
3178     /**
3179     @dev returns the market borrow rate in ray
3180     **/
3181     function getMarketBorrowRate(address _asset) external view returns (uint256);
3182 
3183     /**
3184     @dev sets the market borrow rate. Rate value must be in ray
3185     **/
3186     function setMarketBorrowRate(address _asset, uint256 _rate) external;
3187 }
3188 
3189 /**
3190 @title IReserveInterestRateStrategyInterface interface
3191 @notice Interface for the calculation of the interest rates.
3192 */
3193 
3194 interface IReserveInterestRateStrategy {
3195 
3196     /**
3197     * @dev returns the base variable borrow rate, in rays
3198     */
3199 
3200     function getBaseVariableBorrowRate() external view returns (uint256);
3201     /**
3202     * @dev calculates the liquidity, stable, and variable rates depending on the current utilization rate
3203     *      and the base parameters
3204     *
3205     */
3206     function calculateInterestRates(
3207         address _reserve,
3208         uint256 _utilizationRate,
3209         uint256 _totalBorrowsStable,
3210         uint256 _totalBorrowsVariable,
3211         uint256 _averageStableBorrowRate)
3212     external
3213     view
3214     returns (uint256 liquidityRate, uint256 stableBorrowRate, uint256 variableBorrowRate);
3215 }
3216 
3217 library EthAddressLib {
3218 
3219     /**
3220     * @dev returns the address used within the protocol to identify ETH
3221     * @return the address assigned to ETH
3222      */
3223     function ethAddress() internal pure returns(address) {
3224         return 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
3225     }
3226 }
3227 
3228 /**
3229 * @title LendingPoolCore contract
3230 * @author Aave
3231 * @notice Holds the state of the lending pool and all the funds deposited
3232 * @dev NOTE: The core does not enforce security checks on the update of the state
3233 * (eg, updateStateOnBorrow() does not enforce that borrowed is enabled on the reserve).
3234 * The check that an action can be performed is a duty of the overlying LendingPool contract.
3235 **/
3236 
3237 contract LendingPoolCore is VersionedInitializable {
3238     using SafeMath for uint256;
3239     using WadRayMath for uint256;
3240     using CoreLibrary for CoreLibrary.ReserveData;
3241     using CoreLibrary for CoreLibrary.UserReserveData;
3242     using SafeERC20 for ERC20;
3243     using Address for address payable;
3244 
3245     /**
3246     * @dev Emitted when the state of a reserve is updated
3247     * @param reserve the address of the reserve
3248     * @param liquidityRate the new liquidity rate
3249     * @param stableBorrowRate the new stable borrow rate
3250     * @param variableBorrowRate the new variable borrow rate
3251     * @param liquidityIndex the new liquidity index
3252     * @param variableBorrowIndex the new variable borrow index
3253     **/
3254     event ReserveUpdated(
3255         address indexed reserve,
3256         uint256 liquidityRate,
3257         uint256 stableBorrowRate,
3258         uint256 variableBorrowRate,
3259         uint256 liquidityIndex,
3260         uint256 variableBorrowIndex
3261     );
3262 
3263     address public lendingPoolAddress;
3264 
3265     LendingPoolAddressesProvider public addressesProvider;
3266 
3267     /**
3268     * @dev only lending pools can use functions affected by this modifier
3269     **/
3270     modifier onlyLendingPool {
3271         require(lendingPoolAddress == msg.sender, "The caller must be a lending pool contract");
3272         _;
3273     }
3274 
3275     /**
3276     * @dev only lending pools configurator can use functions affected by this modifier
3277     **/
3278     modifier onlyLendingPoolConfigurator {
3279         require(
3280             addressesProvider.getLendingPoolConfigurator() == msg.sender,
3281             "The caller must be a lending pool configurator contract"
3282         );
3283         _;
3284     }
3285 
3286     mapping(address => CoreLibrary.ReserveData) internal reserves;
3287     mapping(address => mapping(address => CoreLibrary.UserReserveData)) internal usersReserveData;
3288 
3289     address[] public reservesList;
3290 
3291     uint256 public constant CORE_REVISION = 0x4;
3292 
3293     /**
3294     * @dev returns the revision number of the contract
3295     **/
3296     function getRevision() internal pure returns (uint256) {
3297         return CORE_REVISION;
3298     }
3299 
3300     /**
3301     * @dev initializes the Core contract, invoked upon registration on the AddressesProvider
3302     * @param _addressesProvider the addressesProvider contract
3303     **/
3304 
3305     function initialize(LendingPoolAddressesProvider _addressesProvider) public initializer {
3306         addressesProvider = _addressesProvider;
3307         refreshConfigInternal();
3308     }
3309 
3310     /**
3311     * @dev updates the state of the core as a result of a deposit action
3312     * @param _reserve the address of the reserve in which the deposit is happening
3313     * @param _user the address of the the user depositing
3314     * @param _amount the amount being deposited
3315     * @param _isFirstDeposit true if the user is depositing for the first time
3316     **/
3317 
3318     function updateStateOnDeposit(
3319         address _reserve,
3320         address _user,
3321         uint256 _amount,
3322         bool _isFirstDeposit
3323     ) external onlyLendingPool {
3324         reserves[_reserve].updateCumulativeIndexes();
3325         updateReserveInterestRatesAndTimestampInternal(_reserve, _amount, 0);
3326 
3327         if (_isFirstDeposit) {
3328             //if this is the first deposit of the user, we configure the deposit as enabled to be used as collateral
3329             setUserUseReserveAsCollateral(_reserve, _user, true);
3330         }
3331     }
3332 
3333     /**
3334     * @dev updates the state of the core as a result of a redeem action
3335     * @param _reserve the address of the reserve in which the redeem is happening
3336     * @param _user the address of the the user redeeming
3337     * @param _amountRedeemed the amount being redeemed
3338     * @param _userRedeemedEverything true if the user is redeeming everything
3339     **/
3340     function updateStateOnRedeem(
3341         address _reserve,
3342         address _user,
3343         uint256 _amountRedeemed,
3344         bool _userRedeemedEverything
3345     ) external onlyLendingPool {
3346         //compound liquidity and variable borrow interests
3347         reserves[_reserve].updateCumulativeIndexes();
3348         updateReserveInterestRatesAndTimestampInternal(_reserve, 0, _amountRedeemed);
3349 
3350         //if user redeemed everything the useReserveAsCollateral flag is reset
3351         if (_userRedeemedEverything) {
3352             setUserUseReserveAsCollateral(_reserve, _user, false);
3353         }
3354     }
3355 
3356     /**
3357     * @dev updates the state of the core as a result of a flashloan action
3358     * @param _reserve the address of the reserve in which the flashloan is happening
3359     * @param _income the income of the protocol as a result of the action
3360     **/
3361     function updateStateOnFlashLoan(
3362         address _reserve,
3363         uint256 _availableLiquidityBefore,
3364         uint256 _income,
3365         uint256 _protocolFee
3366     ) external onlyLendingPool {
3367         transferFlashLoanProtocolFeeInternal(_reserve, _protocolFee);
3368 
3369         //compounding the cumulated interest
3370         reserves[_reserve].updateCumulativeIndexes();
3371 
3372         uint256 totalLiquidityBefore = _availableLiquidityBefore.add(
3373             getReserveTotalBorrows(_reserve)
3374         );
3375 
3376         //compounding the received fee into the reserve
3377         reserves[_reserve].cumulateToLiquidityIndex(totalLiquidityBefore, _income);
3378 
3379         //refresh interest rates
3380         updateReserveInterestRatesAndTimestampInternal(_reserve, _income, 0);
3381     }
3382 
3383     /**
3384     * @dev updates the state of the core as a consequence of a borrow action.
3385     * @param _reserve the address of the reserve on which the user is borrowing
3386     * @param _user the address of the borrower
3387     * @param _amountBorrowed the new amount borrowed
3388     * @param _borrowFee the fee on the amount borrowed
3389     * @param _rateMode the borrow rate mode (stable, variable)
3390     * @return the new borrow rate for the user
3391     **/
3392     function updateStateOnBorrow(
3393         address _reserve,
3394         address _user,
3395         uint256 _amountBorrowed,
3396         uint256 _borrowFee,
3397         CoreLibrary.InterestRateMode _rateMode
3398     ) external onlyLendingPool returns (uint256, uint256) {
3399         // getting the previous borrow data of the user
3400         (uint256 principalBorrowBalance, , uint256 balanceIncrease) = getUserBorrowBalances(
3401             _reserve,
3402             _user
3403         );
3404 
3405         updateReserveStateOnBorrowInternal(
3406             _reserve,
3407             _user,
3408             principalBorrowBalance,
3409             balanceIncrease,
3410             _amountBorrowed,
3411             _rateMode
3412         );
3413 
3414         updateUserStateOnBorrowInternal(
3415             _reserve,
3416             _user,
3417             _amountBorrowed,
3418             balanceIncrease,
3419             _borrowFee,
3420             _rateMode
3421         );
3422 
3423         updateReserveInterestRatesAndTimestampInternal(_reserve, 0, _amountBorrowed);
3424 
3425         return (getUserCurrentBorrowRate(_reserve, _user), balanceIncrease);
3426     }
3427 
3428     /**
3429     * @dev updates the state of the core as a consequence of a repay action.
3430     * @param _reserve the address of the reserve on which the user is repaying
3431     * @param _user the address of the borrower
3432     * @param _paybackAmountMinusFees the amount being paid back minus fees
3433     * @param _originationFeeRepaid the fee on the amount that is being repaid
3434     * @param _balanceIncrease the accrued interest on the borrowed amount
3435     * @param _repaidWholeLoan true if the user is repaying the whole loan
3436     **/
3437 
3438     function updateStateOnRepay(
3439         address _reserve,
3440         address _user,
3441         uint256 _paybackAmountMinusFees,
3442         uint256 _originationFeeRepaid,
3443         uint256 _balanceIncrease,
3444         bool _repaidWholeLoan
3445     ) external onlyLendingPool {
3446         updateReserveStateOnRepayInternal(
3447             _reserve,
3448             _user,
3449             _paybackAmountMinusFees,
3450             _balanceIncrease
3451         );
3452         updateUserStateOnRepayInternal(
3453             _reserve,
3454             _user,
3455             _paybackAmountMinusFees,
3456             _originationFeeRepaid,
3457             _balanceIncrease,
3458             _repaidWholeLoan
3459         );
3460 
3461         updateReserveInterestRatesAndTimestampInternal(_reserve, _paybackAmountMinusFees, 0);
3462     }
3463 
3464     /**
3465     * @dev updates the state of the core as a consequence of a swap rate action.
3466     * @param _reserve the address of the reserve on which the user is repaying
3467     * @param _user the address of the borrower
3468     * @param _principalBorrowBalance the amount borrowed by the user
3469     * @param _compoundedBorrowBalance the amount borrowed plus accrued interest
3470     * @param _balanceIncrease the accrued interest on the borrowed amount
3471     * @param _currentRateMode the current interest rate mode for the user
3472     **/
3473     function updateStateOnSwapRate(
3474         address _reserve,
3475         address _user,
3476         uint256 _principalBorrowBalance,
3477         uint256 _compoundedBorrowBalance,
3478         uint256 _balanceIncrease,
3479         CoreLibrary.InterestRateMode _currentRateMode
3480     ) external onlyLendingPool returns (CoreLibrary.InterestRateMode, uint256) {
3481         updateReserveStateOnSwapRateInternal(
3482             _reserve,
3483             _user,
3484             _principalBorrowBalance,
3485             _compoundedBorrowBalance,
3486             _currentRateMode
3487         );
3488 
3489         CoreLibrary.InterestRateMode newRateMode = updateUserStateOnSwapRateInternal(
3490             _reserve,
3491             _user,
3492             _balanceIncrease,
3493             _currentRateMode
3494         );
3495 
3496         updateReserveInterestRatesAndTimestampInternal(_reserve, 0, 0);
3497 
3498         return (newRateMode, getUserCurrentBorrowRate(_reserve, _user));
3499     }
3500 
3501     /**
3502     * @dev updates the state of the core as a consequence of a liquidation action.
3503     * @param _principalReserve the address of the principal reserve that is being repaid
3504     * @param _collateralReserve the address of the collateral reserve that is being liquidated
3505     * @param _user the address of the borrower
3506     * @param _amountToLiquidate the amount being repaid by the liquidator
3507     * @param _collateralToLiquidate the amount of collateral being liquidated
3508     * @param _feeLiquidated the amount of origination fee being liquidated
3509     * @param _liquidatedCollateralForFee the amount of collateral equivalent to the origination fee + bonus
3510     * @param _balanceIncrease the accrued interest on the borrowed amount
3511     * @param _liquidatorReceivesAToken true if the liquidator will receive aTokens, false otherwise
3512     **/
3513     function updateStateOnLiquidation(
3514         address _principalReserve,
3515         address _collateralReserve,
3516         address _user,
3517         uint256 _amountToLiquidate,
3518         uint256 _collateralToLiquidate,
3519         uint256 _feeLiquidated,
3520         uint256 _liquidatedCollateralForFee,
3521         uint256 _balanceIncrease,
3522         bool _liquidatorReceivesAToken
3523     ) external onlyLendingPool {
3524         updatePrincipalReserveStateOnLiquidationInternal(
3525             _principalReserve,
3526             _user,
3527             _amountToLiquidate,
3528             _balanceIncrease
3529         );
3530 
3531         updateCollateralReserveStateOnLiquidationInternal(
3532             _collateralReserve
3533         );
3534 
3535         updateUserStateOnLiquidationInternal(
3536             _principalReserve,
3537             _user,
3538             _amountToLiquidate,
3539             _feeLiquidated,
3540             _balanceIncrease
3541         );
3542 
3543         updateReserveInterestRatesAndTimestampInternal(_principalReserve, _amountToLiquidate, 0);
3544 
3545         if (!_liquidatorReceivesAToken) {
3546             updateReserveInterestRatesAndTimestampInternal(
3547                 _collateralReserve,
3548                 0,
3549                 _collateralToLiquidate.add(_liquidatedCollateralForFee)
3550             );
3551         }
3552 
3553     }
3554 
3555     /**
3556     * @dev updates the state of the core as a consequence of a stable rate rebalance
3557     * @param _reserve the address of the principal reserve where the user borrowed
3558     * @param _user the address of the borrower
3559     * @param _balanceIncrease the accrued interest on the borrowed amount
3560     * @return the new stable rate for the user
3561     **/
3562     function updateStateOnRebalance(address _reserve, address _user, uint256 _balanceIncrease)
3563         external
3564         onlyLendingPool
3565         returns (uint256)
3566     {
3567         updateReserveStateOnRebalanceInternal(_reserve, _user, _balanceIncrease);
3568 
3569         //update user data and rebalance the rate
3570         updateUserStateOnRebalanceInternal(_reserve, _user, _balanceIncrease);
3571         updateReserveInterestRatesAndTimestampInternal(_reserve, 0, 0);
3572         return usersReserveData[_user][_reserve].stableBorrowRate;
3573     }
3574 
3575     /**
3576     * @dev enables or disables a reserve as collateral
3577     * @param _reserve the address of the principal reserve where the user deposited
3578     * @param _user the address of the depositor
3579     * @param _useAsCollateral true if the depositor wants to use the reserve as collateral
3580     **/
3581     function setUserUseReserveAsCollateral(address _reserve, address _user, bool _useAsCollateral)
3582         public
3583         onlyLendingPool
3584     {
3585         CoreLibrary.UserReserveData storage user = usersReserveData[_user][_reserve];
3586         user.useAsCollateral = _useAsCollateral;
3587     }
3588 
3589     /**
3590     * @notice ETH/token transfer functions
3591     **/
3592 
3593     /**
3594     * @dev fallback function enforces that the caller is a contract, to support flashloan transfers
3595     **/
3596     function() external payable {
3597         //only contracts can send ETH to the core
3598         require(msg.sender.isContract(), "Only contracts can send ether to the Lending pool core");
3599 
3600     }
3601 
3602     /**
3603     * @dev transfers to the user a specific amount from the reserve.
3604     * @param _reserve the address of the reserve where the transfer is happening
3605     * @param _user the address of the user receiving the transfer
3606     * @param _amount the amount being transferred
3607     **/
3608     function transferToUser(address _reserve, address payable _user, uint256 _amount)
3609         external
3610         onlyLendingPool
3611     {
3612         if (_reserve != EthAddressLib.ethAddress()) {
3613             ERC20(_reserve).safeTransfer(_user, _amount);
3614         } else {
3615             //solium-disable-next-line
3616             (bool result, ) = _user.call.value(_amount).gas(50000)("");
3617             require(result, "Transfer of ETH failed");
3618         }
3619     }
3620 
3621     /**
3622     * @dev transfers the protocol fees to the fees collection address
3623     * @param _token the address of the token being transferred
3624     * @param _user the address of the user from where the transfer is happening
3625     * @param _amount the amount being transferred
3626     * @param _destination the fee receiver address
3627     **/
3628 
3629     function transferToFeeCollectionAddress(
3630         address _token,
3631         address _user,
3632         uint256 _amount,
3633         address _destination
3634     ) external payable onlyLendingPool {
3635         address payable feeAddress = address(uint160(_destination)); //cast the address to payable
3636 
3637         if (_token != EthAddressLib.ethAddress()) {
3638             require(
3639                 msg.value == 0,
3640                 "User is sending ETH along with the ERC20 transfer. Check the value attribute of the transaction"
3641             );
3642             ERC20(_token).safeTransferFrom(_user, feeAddress, _amount);
3643         } else {
3644             require(msg.value >= _amount, "The amount and the value sent to deposit do not match");
3645             //solium-disable-next-line
3646             (bool result, ) = feeAddress.call.value(_amount).gas(50000)("");
3647             require(result, "Transfer of ETH failed");
3648         }
3649     }
3650 
3651     /**
3652     * @dev transfers the fees to the fees collection address in the case of liquidation
3653     * @param _token the address of the token being transferred
3654     * @param _amount the amount being transferred
3655     * @param _destination the fee receiver address
3656     **/
3657     function liquidateFee(
3658         address _token,
3659         uint256 _amount,
3660         address _destination
3661     ) external payable onlyLendingPool {
3662         address payable feeAddress = address(uint160(_destination)); //cast the address to payable
3663         require(
3664             msg.value == 0,
3665             "Fee liquidation does not require any transfer of value"
3666         );
3667 
3668         if (_token != EthAddressLib.ethAddress()) {
3669             ERC20(_token).safeTransfer(feeAddress, _amount);
3670         } else {
3671             //solium-disable-next-line
3672             (bool result, ) = feeAddress.call.value(_amount).gas(50000)("");
3673             require(result, "Transfer of ETH failed");
3674         }
3675     }
3676 
3677     /**
3678     * @dev transfers an amount from a user to the destination reserve
3679     * @param _reserve the address of the reserve where the amount is being transferred
3680     * @param _user the address of the user from where the transfer is happening
3681     * @param _amount the amount being transferred
3682     **/
3683     function transferToReserve(address _reserve, address payable _user, uint256 _amount)
3684         external
3685         payable
3686         onlyLendingPool
3687     {
3688         if (_reserve != EthAddressLib.ethAddress()) {
3689             require(msg.value == 0, "User is sending ETH along with the ERC20 transfer.");
3690             ERC20(_reserve).safeTransferFrom(_user, address(this), _amount);
3691 
3692         } else {
3693             require(msg.value >= _amount, "The amount and the value sent to deposit do not match");
3694 
3695             if (msg.value > _amount) {
3696                 //send back excess ETH
3697                 uint256 excessAmount = msg.value.sub(_amount);
3698                 //solium-disable-next-line
3699                 (bool result, ) = _user.call.value(excessAmount).gas(50000)("");
3700                 require(result, "Transfer of ETH failed");
3701             }
3702         }
3703     }
3704 
3705     /**
3706     * @notice data access functions
3707     **/
3708 
3709     /**
3710     * @dev returns the basic data (balances, fee accrued, reserve enabled/disabled as collateral)
3711     * needed to calculate the global account data in the LendingPoolDataProvider
3712     * @param _reserve the address of the reserve
3713     * @param _user the address of the user
3714     * @return the user deposited balance, the principal borrow balance, the fee, and if the reserve is enabled as collateral or not
3715     **/
3716     function getUserBasicReserveData(address _reserve, address _user)
3717         external
3718         view
3719         returns (uint256, uint256, uint256, bool)
3720     {
3721         CoreLibrary.ReserveData storage reserve = reserves[_reserve];
3722         CoreLibrary.UserReserveData storage user = usersReserveData[_user][_reserve];
3723 
3724         uint256 underlyingBalance = getUserUnderlyingAssetBalance(_reserve, _user);
3725 
3726         if (user.principalBorrowBalance == 0) {
3727             return (underlyingBalance, 0, 0, user.useAsCollateral);
3728         }
3729 
3730         return (
3731             underlyingBalance,
3732             user.getCompoundedBorrowBalance(reserve),
3733             user.originationFee,
3734             user.useAsCollateral
3735         );
3736     }
3737 
3738     /**
3739     * @dev checks if a user is allowed to borrow at a stable rate
3740     * @param _reserve the reserve address
3741     * @param _user the user
3742     * @param _amount the amount the the user wants to borrow
3743     * @return true if the user is allowed to borrow at a stable rate, false otherwise
3744     **/
3745 
3746     function isUserAllowedToBorrowAtStable(address _reserve, address _user, uint256 _amount)
3747         external
3748         view
3749         returns (bool)
3750     {
3751         CoreLibrary.ReserveData storage reserve = reserves[_reserve];
3752         CoreLibrary.UserReserveData storage user = usersReserveData[_user][_reserve];
3753 
3754         if (!reserve.isStableBorrowRateEnabled) return false;
3755 
3756         return
3757             !user.useAsCollateral ||
3758             !reserve.usageAsCollateralEnabled ||
3759             _amount > getUserUnderlyingAssetBalance(_reserve, _user);
3760     }
3761 
3762     /**
3763     * @dev gets the underlying asset balance of a user based on the corresponding aToken balance.
3764     * @param _reserve the reserve address
3765     * @param _user the user address
3766     * @return the underlying deposit balance of the user
3767     **/
3768 
3769     function getUserUnderlyingAssetBalance(address _reserve, address _user)
3770         public
3771         view
3772         returns (uint256)
3773     {
3774         AToken aToken = AToken(reserves[_reserve].aTokenAddress);
3775         return aToken.balanceOf(_user);
3776 
3777     }
3778 
3779     /**
3780     * @dev gets the interest rate strategy contract address for the reserve
3781     * @param _reserve the reserve address
3782     * @return the address of the interest rate strategy contract
3783     **/
3784     function getReserveInterestRateStrategyAddress(address _reserve) public view returns (address) {
3785         CoreLibrary.ReserveData storage reserve = reserves[_reserve];
3786         return reserve.interestRateStrategyAddress;
3787     }
3788 
3789     /**
3790     * @dev gets the aToken contract address for the reserve
3791     * @param _reserve the reserve address
3792     * @return the address of the aToken contract
3793     **/
3794 
3795     function getReserveATokenAddress(address _reserve) public view returns (address) {
3796         CoreLibrary.ReserveData storage reserve = reserves[_reserve];
3797         return reserve.aTokenAddress;
3798     }
3799 
3800     /**
3801     * @dev gets the available liquidity in the reserve. The available liquidity is the balance of the core contract
3802     * @param _reserve the reserve address
3803     * @return the available liquidity
3804     **/
3805     function getReserveAvailableLiquidity(address _reserve) public view returns (uint256) {
3806         uint256 balance = 0;
3807 
3808         if (_reserve == EthAddressLib.ethAddress()) {
3809             balance = address(this).balance;
3810         } else {
3811             balance = IERC20(_reserve).balanceOf(address(this));
3812         }
3813         return balance;
3814     }
3815 
3816     /**
3817     * @dev gets the total liquidity in the reserve. The total liquidity is the balance of the core contract + total borrows
3818     * @param _reserve the reserve address
3819     * @return the total liquidity
3820     **/
3821     function getReserveTotalLiquidity(address _reserve) public view returns (uint256) {
3822         CoreLibrary.ReserveData storage reserve = reserves[_reserve];
3823         return getReserveAvailableLiquidity(_reserve).add(reserve.getTotalBorrows());
3824     }
3825 
3826     /**
3827     * @dev gets the normalized income of the reserve. a value of 1e27 means there is no income. A value of 2e27 means there
3828     * there has been 100% income.
3829     * @param _reserve the reserve address
3830     * @return the reserve normalized income
3831     **/
3832     function getReserveNormalizedIncome(address _reserve) external view returns (uint256) {
3833         CoreLibrary.ReserveData storage reserve = reserves[_reserve];
3834         return reserve.getNormalizedIncome();
3835     }
3836 
3837     /**
3838     * @dev gets the reserve total borrows
3839     * @param _reserve the reserve address
3840     * @return the total borrows (stable + variable)
3841     **/
3842     function getReserveTotalBorrows(address _reserve) public view returns (uint256) {
3843         return reserves[_reserve].getTotalBorrows();
3844     }
3845 
3846     /**
3847     * @dev gets the reserve total borrows stable
3848     * @param _reserve the reserve address
3849     * @return the total borrows stable
3850     **/
3851     function getReserveTotalBorrowsStable(address _reserve) external view returns (uint256) {
3852         CoreLibrary.ReserveData storage reserve = reserves[_reserve];
3853         return reserve.totalBorrowsStable;
3854     }
3855 
3856     /**
3857     * @dev gets the reserve total borrows variable
3858     * @param _reserve the reserve address
3859     * @return the total borrows variable
3860     **/
3861 
3862     function getReserveTotalBorrowsVariable(address _reserve) external view returns (uint256) {
3863         CoreLibrary.ReserveData storage reserve = reserves[_reserve];
3864         return reserve.totalBorrowsVariable;
3865     }
3866 
3867     /**
3868     * @dev gets the reserve liquidation threshold
3869     * @param _reserve the reserve address
3870     * @return the reserve liquidation threshold
3871     **/
3872 
3873     function getReserveLiquidationThreshold(address _reserve) external view returns (uint256) {
3874         CoreLibrary.ReserveData storage reserve = reserves[_reserve];
3875         return reserve.liquidationThreshold;
3876     }
3877 
3878     /**
3879     * @dev gets the reserve liquidation bonus
3880     * @param _reserve the reserve address
3881     * @return the reserve liquidation bonus
3882     **/
3883 
3884     function getReserveLiquidationBonus(address _reserve) external view returns (uint256) {
3885         CoreLibrary.ReserveData storage reserve = reserves[_reserve];
3886         return reserve.liquidationBonus;
3887     }
3888 
3889     /**
3890     * @dev gets the reserve current variable borrow rate. Is the base variable borrow rate if the reserve is empty
3891     * @param _reserve the reserve address
3892     * @return the reserve current variable borrow rate
3893     **/
3894 
3895     function getReserveCurrentVariableBorrowRate(address _reserve) external view returns (uint256) {
3896         CoreLibrary.ReserveData storage reserve = reserves[_reserve];
3897 
3898         if (reserve.currentVariableBorrowRate == 0) {
3899             return
3900                 IReserveInterestRateStrategy(reserve.interestRateStrategyAddress)
3901                 .getBaseVariableBorrowRate();
3902         }
3903         return reserve.currentVariableBorrowRate;
3904     }
3905 
3906     /**
3907     * @dev gets the reserve current stable borrow rate. Is the market rate if the reserve is empty
3908     * @param _reserve the reserve address
3909     * @return the reserve current stable borrow rate
3910     **/
3911 
3912     function getReserveCurrentStableBorrowRate(address _reserve) public view returns (uint256) {
3913         CoreLibrary.ReserveData storage reserve = reserves[_reserve];
3914         ILendingRateOracle oracle = ILendingRateOracle(addressesProvider.getLendingRateOracle());
3915 
3916         if (reserve.currentStableBorrowRate == 0) {
3917             //no stable rate borrows yet
3918             return oracle.getMarketBorrowRate(_reserve);
3919         }
3920 
3921         return reserve.currentStableBorrowRate;
3922     }
3923 
3924     /**
3925     * @dev gets the reserve average stable borrow rate. The average stable rate is the weighted average
3926     * of all the loans taken at stable rate.
3927     * @param _reserve the reserve address
3928     * @return the reserve current average borrow rate
3929     **/
3930     function getReserveCurrentAverageStableBorrowRate(address _reserve)
3931         external
3932         view
3933         returns (uint256)
3934     {
3935         CoreLibrary.ReserveData storage reserve = reserves[_reserve];
3936         return reserve.currentAverageStableBorrowRate;
3937     }
3938 
3939     /**
3940     * @dev gets the reserve liquidity rate
3941     * @param _reserve the reserve address
3942     * @return the reserve liquidity rate
3943     **/
3944     function getReserveCurrentLiquidityRate(address _reserve) external view returns (uint256) {
3945         CoreLibrary.ReserveData storage reserve = reserves[_reserve];
3946         return reserve.currentLiquidityRate;
3947     }
3948 
3949     /**
3950     * @dev gets the reserve liquidity cumulative index
3951     * @param _reserve the reserve address
3952     * @return the reserve liquidity cumulative index
3953     **/
3954     function getReserveLiquidityCumulativeIndex(address _reserve) external view returns (uint256) {
3955         CoreLibrary.ReserveData storage reserve = reserves[_reserve];
3956         return reserve.lastLiquidityCumulativeIndex;
3957     }
3958 
3959     /**
3960     * @dev gets the reserve variable borrow index
3961     * @param _reserve the reserve address
3962     * @return the reserve variable borrow index
3963     **/
3964     function getReserveVariableBorrowsCumulativeIndex(address _reserve)
3965         external
3966         view
3967         returns (uint256)
3968     {
3969         CoreLibrary.ReserveData storage reserve = reserves[_reserve];
3970         return reserve.lastVariableBorrowCumulativeIndex;
3971     }
3972 
3973     /**
3974     * @dev this function aggregates the configuration parameters of the reserve.
3975     * It's used in the LendingPoolDataProvider specifically to save gas, and avoid
3976     * multiple external contract calls to fetch the same data.
3977     * @param _reserve the reserve address
3978     * @return the reserve decimals
3979     * @return the base ltv as collateral
3980     * @return the liquidation threshold
3981     * @return if the reserve is used as collateral or not
3982     **/
3983     function getReserveConfiguration(address _reserve)
3984         external
3985         view
3986         returns (uint256, uint256, uint256, bool)
3987     {
3988         uint256 decimals;
3989         uint256 baseLTVasCollateral;
3990         uint256 liquidationThreshold;
3991         bool usageAsCollateralEnabled;
3992 
3993         CoreLibrary.ReserveData storage reserve = reserves[_reserve];
3994         decimals = reserve.decimals;
3995         baseLTVasCollateral = reserve.baseLTVasCollateral;
3996         liquidationThreshold = reserve.liquidationThreshold;
3997         usageAsCollateralEnabled = reserve.usageAsCollateralEnabled;
3998 
3999         return (decimals, baseLTVasCollateral, liquidationThreshold, usageAsCollateralEnabled);
4000     }
4001 
4002     /**
4003     * @dev returns the decimals of the reserve
4004     * @param _reserve the reserve address
4005     * @return the reserve decimals
4006     **/
4007     function getReserveDecimals(address _reserve) external view returns (uint256) {
4008         return reserves[_reserve].decimals;
4009     }
4010 
4011     /**
4012     * @dev returns true if the reserve is enabled for borrowing
4013     * @param _reserve the reserve address
4014     * @return true if the reserve is enabled for borrowing, false otherwise
4015     **/
4016 
4017     function isReserveBorrowingEnabled(address _reserve) external view returns (bool) {
4018         CoreLibrary.ReserveData storage reserve = reserves[_reserve];
4019         return reserve.borrowingEnabled;
4020     }
4021 
4022     /**
4023     * @dev returns true if the reserve is enabled as collateral
4024     * @param _reserve the reserve address
4025     * @return true if the reserve is enabled as collateral, false otherwise
4026     **/
4027 
4028     function isReserveUsageAsCollateralEnabled(address _reserve) external view returns (bool) {
4029         CoreLibrary.ReserveData storage reserve = reserves[_reserve];
4030         return reserve.usageAsCollateralEnabled;
4031     }
4032 
4033     /**
4034     * @dev returns true if the stable rate is enabled on reserve
4035     * @param _reserve the reserve address
4036     * @return true if the stable rate is enabled on reserve, false otherwise
4037     **/
4038     function getReserveIsStableBorrowRateEnabled(address _reserve) external view returns (bool) {
4039         CoreLibrary.ReserveData storage reserve = reserves[_reserve];
4040         return reserve.isStableBorrowRateEnabled;
4041     }
4042 
4043     /**
4044     * @dev returns true if the reserve is active
4045     * @param _reserve the reserve address
4046     * @return true if the reserve is active, false otherwise
4047     **/
4048     function getReserveIsActive(address _reserve) external view returns (bool) {
4049         CoreLibrary.ReserveData storage reserve = reserves[_reserve];
4050         return reserve.isActive;
4051     }
4052 
4053     /**
4054     * @notice returns if a reserve is freezed
4055     * @param _reserve the reserve for which the information is needed
4056     * @return true if the reserve is freezed, false otherwise
4057     **/
4058 
4059     function getReserveIsFreezed(address _reserve) external view returns (bool) {
4060         CoreLibrary.ReserveData storage reserve = reserves[_reserve];
4061         return reserve.isFreezed;
4062     }
4063 
4064     /**
4065     * @notice returns the timestamp of the last action on the reserve
4066     * @param _reserve the reserve for which the information is needed
4067     * @return the last updated timestamp of the reserve
4068     **/
4069 
4070     function getReserveLastUpdate(address _reserve) external view returns (uint40 timestamp) {
4071         CoreLibrary.ReserveData storage reserve = reserves[_reserve];
4072         timestamp = reserve.lastUpdateTimestamp;
4073     }
4074 
4075     /**
4076     * @dev returns the utilization rate U of a specific reserve
4077     * @param _reserve the reserve for which the information is needed
4078     * @return the utilization rate in ray
4079     **/
4080 
4081     function getReserveUtilizationRate(address _reserve) public view returns (uint256) {
4082         CoreLibrary.ReserveData storage reserve = reserves[_reserve];
4083 
4084         uint256 totalBorrows = reserve.getTotalBorrows();
4085 
4086         if (totalBorrows == 0) {
4087             return 0;
4088         }
4089 
4090         uint256 availableLiquidity = getReserveAvailableLiquidity(_reserve);
4091 
4092         return totalBorrows.rayDiv(availableLiquidity.add(totalBorrows));
4093     }
4094 
4095     /**
4096     * @return the array of reserves configured on the core
4097     **/
4098     function getReserves() external view returns (address[] memory) {
4099         return reservesList;
4100     }
4101 
4102     /**
4103     * @param _reserve the address of the reserve for which the information is needed
4104     * @param _user the address of the user for which the information is needed
4105     * @return true if the user has chosen to use the reserve as collateral, false otherwise
4106     **/
4107     function isUserUseReserveAsCollateralEnabled(address _reserve, address _user)
4108         external
4109         view
4110         returns (bool)
4111     {
4112         CoreLibrary.UserReserveData storage user = usersReserveData[_user][_reserve];
4113         return user.useAsCollateral;
4114     }
4115 
4116     /**
4117     * @param _reserve the address of the reserve for which the information is needed
4118     * @param _user the address of the user for which the information is needed
4119     * @return the origination fee for the user
4120     **/
4121     function getUserOriginationFee(address _reserve, address _user)
4122         external
4123         view
4124         returns (uint256)
4125     {
4126         CoreLibrary.UserReserveData storage user = usersReserveData[_user][_reserve];
4127         return user.originationFee;
4128     }
4129 
4130     /**
4131     * @dev users with no loans in progress have NONE as borrow rate mode
4132     * @param _reserve the address of the reserve for which the information is needed
4133     * @param _user the address of the user for which the information is needed
4134     * @return the borrow rate mode for the user,
4135     **/
4136 
4137     function getUserCurrentBorrowRateMode(address _reserve, address _user)
4138         public
4139         view
4140         returns (CoreLibrary.InterestRateMode)
4141     {
4142         CoreLibrary.UserReserveData storage user = usersReserveData[_user][_reserve];
4143 
4144         if (user.principalBorrowBalance == 0) {
4145             return CoreLibrary.InterestRateMode.NONE;
4146         }
4147 
4148         return
4149             user.stableBorrowRate > 0
4150             ? CoreLibrary.InterestRateMode.STABLE
4151             : CoreLibrary.InterestRateMode.VARIABLE;
4152     }
4153 
4154     /**
4155     * @dev gets the current borrow rate of the user
4156     * @param _reserve the address of the reserve for which the information is needed
4157     * @param _user the address of the user for which the information is needed
4158     * @return the borrow rate for the user,
4159     **/
4160     function getUserCurrentBorrowRate(address _reserve, address _user)
4161         internal
4162         view
4163         returns (uint256)
4164     {
4165         CoreLibrary.InterestRateMode rateMode = getUserCurrentBorrowRateMode(_reserve, _user);
4166 
4167         if (rateMode == CoreLibrary.InterestRateMode.NONE) {
4168             return 0;
4169         }
4170 
4171         return
4172             rateMode == CoreLibrary.InterestRateMode.STABLE
4173             ? usersReserveData[_user][_reserve].stableBorrowRate
4174             : reserves[_reserve].currentVariableBorrowRate;
4175     }
4176 
4177     /**
4178     * @dev the stable rate returned is 0 if the user is borrowing at variable or not borrowing at all
4179     * @param _reserve the address of the reserve for which the information is needed
4180     * @param _user the address of the user for which the information is needed
4181     * @return the user stable rate
4182     **/
4183     function getUserCurrentStableBorrowRate(address _reserve, address _user)
4184         external
4185         view
4186         returns (uint256)
4187     {
4188         CoreLibrary.UserReserveData storage user = usersReserveData[_user][_reserve];
4189         return user.stableBorrowRate;
4190     }
4191 
4192     /**
4193     * @dev calculates and returns the borrow balances of the user
4194     * @param _reserve the address of the reserve
4195     * @param _user the address of the user
4196     * @return the principal borrow balance, the compounded balance and the balance increase since the last borrow/repay/swap/rebalance
4197     **/
4198 
4199     function getUserBorrowBalances(address _reserve, address _user)
4200         public
4201         view
4202         returns (uint256, uint256, uint256)
4203     {
4204         CoreLibrary.UserReserveData storage user = usersReserveData[_user][_reserve];
4205         if (user.principalBorrowBalance == 0) {
4206             return (0, 0, 0);
4207         }
4208 
4209         uint256 principal = user.principalBorrowBalance;
4210         uint256 compoundedBalance = CoreLibrary.getCompoundedBorrowBalance(
4211             user,
4212             reserves[_reserve]
4213         );
4214         return (principal, compoundedBalance, compoundedBalance.sub(principal));
4215     }
4216 
4217     /**
4218     * @dev the variable borrow index of the user is 0 if the user is not borrowing or borrowing at stable
4219     * @param _reserve the address of the reserve for which the information is needed
4220     * @param _user the address of the user for which the information is needed
4221     * @return the variable borrow index for the user
4222     **/
4223 
4224     function getUserVariableBorrowCumulativeIndex(address _reserve, address _user)
4225         external
4226         view
4227         returns (uint256)
4228     {
4229         CoreLibrary.UserReserveData storage user = usersReserveData[_user][_reserve];
4230         return user.lastVariableBorrowCumulativeIndex;
4231     }
4232 
4233     /**
4234     * @dev the variable borrow index of the user is 0 if the user is not borrowing or borrowing at stable
4235     * @param _reserve the address of the reserve for which the information is needed
4236     * @param _user the address of the user for which the information is needed
4237     * @return the variable borrow index for the user
4238     **/
4239 
4240     function getUserLastUpdate(address _reserve, address _user)
4241         external
4242         view
4243         returns (uint256 timestamp)
4244     {
4245         CoreLibrary.UserReserveData storage user = usersReserveData[_user][_reserve];
4246         timestamp = user.lastUpdateTimestamp;
4247     }
4248 
4249     /**
4250     * @dev updates the lending pool core configuration
4251     **/
4252     function refreshConfiguration() external onlyLendingPoolConfigurator {
4253         refreshConfigInternal();
4254     }
4255 
4256     /**
4257     * @dev initializes a reserve
4258     * @param _reserve the address of the reserve
4259     * @param _aTokenAddress the address of the overlying aToken contract
4260     * @param _decimals the decimals of the reserve currency
4261     * @param _interestRateStrategyAddress the address of the interest rate strategy contract
4262     **/
4263     function initReserve(
4264         address _reserve,
4265         address _aTokenAddress,
4266         uint256 _decimals,
4267         address _interestRateStrategyAddress
4268     ) external onlyLendingPoolConfigurator {
4269         reserves[_reserve].init(_aTokenAddress, _decimals, _interestRateStrategyAddress);
4270         addReserveToListInternal(_reserve);
4271 
4272     }
4273 
4274 
4275 
4276     /**
4277     * @dev removes the last added reserve in the reservesList array
4278     * @param _reserveToRemove the address of the reserve
4279     **/
4280     function removeLastAddedReserve(address _reserveToRemove)
4281      external onlyLendingPoolConfigurator {
4282 
4283         address lastReserve = reservesList[reservesList.length-1];
4284 
4285         require(lastReserve == _reserveToRemove, "Reserve being removed is different than the reserve requested");
4286 
4287         //as we can't check if totalLiquidity is 0 (since the reserve added might not be an ERC20) we at least check that there is nothing borrowed
4288         require(getReserveTotalBorrows(lastReserve) == 0, "Cannot remove a reserve with liquidity deposited");
4289 
4290         reserves[lastReserve].isActive = false;
4291         reserves[lastReserve].aTokenAddress = address(0);
4292         reserves[lastReserve].decimals = 0;
4293         reserves[lastReserve].lastLiquidityCumulativeIndex = 0;
4294         reserves[lastReserve].lastVariableBorrowCumulativeIndex = 0;
4295         reserves[lastReserve].borrowingEnabled = false;
4296         reserves[lastReserve].usageAsCollateralEnabled = false;
4297         reserves[lastReserve].baseLTVasCollateral = 0;
4298         reserves[lastReserve].liquidationThreshold = 0;
4299         reserves[lastReserve].liquidationBonus = 0;
4300         reserves[lastReserve].interestRateStrategyAddress = address(0);
4301 
4302         reservesList.pop();
4303     }
4304 
4305     /**
4306     * @dev updates the address of the interest rate strategy contract
4307     * @param _reserve the address of the reserve
4308     * @param _rateStrategyAddress the address of the interest rate strategy contract
4309     **/
4310 
4311     function setReserveInterestRateStrategyAddress(address _reserve, address _rateStrategyAddress)
4312         external
4313         onlyLendingPoolConfigurator
4314     {
4315         reserves[_reserve].interestRateStrategyAddress = _rateStrategyAddress;
4316     }
4317 
4318     /**
4319     * @dev enables borrowing on a reserve. Also sets the stable rate borrowing
4320     * @param _reserve the address of the reserve
4321     * @param _stableBorrowRateEnabled true if the stable rate needs to be enabled, false otherwise
4322     **/
4323 
4324     function enableBorrowingOnReserve(address _reserve, bool _stableBorrowRateEnabled)
4325         external
4326         onlyLendingPoolConfigurator
4327     {
4328         reserves[_reserve].enableBorrowing(_stableBorrowRateEnabled);
4329     }
4330 
4331     /**
4332     * @dev disables borrowing on a reserve
4333     * @param _reserve the address of the reserve
4334     **/
4335 
4336     function disableBorrowingOnReserve(address _reserve) external onlyLendingPoolConfigurator {
4337         reserves[_reserve].disableBorrowing();
4338     }
4339 
4340     /**
4341     * @dev enables a reserve to be used as collateral
4342     * @param _reserve the address of the reserve
4343     **/
4344     function enableReserveAsCollateral(
4345         address _reserve,
4346         uint256 _baseLTVasCollateral,
4347         uint256 _liquidationThreshold,
4348         uint256 _liquidationBonus
4349     ) external onlyLendingPoolConfigurator {
4350         reserves[_reserve].enableAsCollateral(
4351             _baseLTVasCollateral,
4352             _liquidationThreshold,
4353             _liquidationBonus
4354         );
4355     }
4356 
4357     /**
4358     * @dev disables a reserve to be used as collateral
4359     * @param _reserve the address of the reserve
4360     **/
4361     function disableReserveAsCollateral(address _reserve) external onlyLendingPoolConfigurator {
4362         reserves[_reserve].disableAsCollateral();
4363     }
4364 
4365     /**
4366     * @dev enable the stable borrow rate mode on a reserve
4367     * @param _reserve the address of the reserve
4368     **/
4369     function enableReserveStableBorrowRate(address _reserve) external onlyLendingPoolConfigurator {
4370         CoreLibrary.ReserveData storage reserve = reserves[_reserve];
4371         reserve.isStableBorrowRateEnabled = true;
4372     }
4373 
4374     /**
4375     * @dev disable the stable borrow rate mode on a reserve
4376     * @param _reserve the address of the reserve
4377     **/
4378     function disableReserveStableBorrowRate(address _reserve) external onlyLendingPoolConfigurator {
4379         CoreLibrary.ReserveData storage reserve = reserves[_reserve];
4380         reserve.isStableBorrowRateEnabled = false;
4381     }
4382 
4383     /**
4384     * @dev activates a reserve
4385     * @param _reserve the address of the reserve
4386     **/
4387     function activateReserve(address _reserve) external onlyLendingPoolConfigurator {
4388         CoreLibrary.ReserveData storage reserve = reserves[_reserve];
4389 
4390         require(
4391             reserve.lastLiquidityCumulativeIndex > 0 &&
4392                 reserve.lastVariableBorrowCumulativeIndex > 0,
4393             "Reserve has not been initialized yet"
4394         );
4395         reserve.isActive = true;
4396     }
4397 
4398     /**
4399     * @dev deactivates a reserve
4400     * @param _reserve the address of the reserve
4401     **/
4402     function deactivateReserve(address _reserve) external onlyLendingPoolConfigurator {
4403         CoreLibrary.ReserveData storage reserve = reserves[_reserve];
4404         reserve.isActive = false;
4405     }
4406 
4407     /**
4408     * @notice allows the configurator to freeze the reserve.
4409     * A freezed reserve does not allow any action apart from repay, redeem, liquidationCall, rebalance.
4410     * @param _reserve the address of the reserve
4411     **/
4412     function freezeReserve(address _reserve) external onlyLendingPoolConfigurator {
4413         CoreLibrary.ReserveData storage reserve = reserves[_reserve];
4414         reserve.isFreezed = true;
4415     }
4416 
4417     /**
4418     * @notice allows the configurator to unfreeze the reserve. A unfreezed reserve allows any action to be executed.
4419     * @param _reserve the address of the reserve
4420     **/
4421     function unfreezeReserve(address _reserve) external onlyLendingPoolConfigurator {
4422         CoreLibrary.ReserveData storage reserve = reserves[_reserve];
4423         reserve.isFreezed = false;
4424     }
4425 
4426     /**
4427     * @notice allows the configurator to update the loan to value of a reserve
4428     * @param _reserve the address of the reserve
4429     * @param _ltv the new loan to value
4430     **/
4431     function setReserveBaseLTVasCollateral(address _reserve, uint256 _ltv)
4432         external
4433         onlyLendingPoolConfigurator
4434     {
4435         CoreLibrary.ReserveData storage reserve = reserves[_reserve];
4436         reserve.baseLTVasCollateral = _ltv;
4437     }
4438 
4439     /**
4440     * @notice allows the configurator to update the liquidation threshold of a reserve
4441     * @param _reserve the address of the reserve
4442     * @param _threshold the new liquidation threshold
4443     **/
4444     function setReserveLiquidationThreshold(address _reserve, uint256 _threshold)
4445         external
4446         onlyLendingPoolConfigurator
4447     {
4448         CoreLibrary.ReserveData storage reserve = reserves[_reserve];
4449         reserve.liquidationThreshold = _threshold;
4450     }
4451 
4452     /**
4453     * @notice allows the configurator to update the liquidation bonus of a reserve
4454     * @param _reserve the address of the reserve
4455     * @param _bonus the new liquidation bonus
4456     **/
4457     function setReserveLiquidationBonus(address _reserve, uint256 _bonus)
4458         external
4459         onlyLendingPoolConfigurator
4460     {
4461         CoreLibrary.ReserveData storage reserve = reserves[_reserve];
4462         reserve.liquidationBonus = _bonus;
4463     }
4464 
4465     /**
4466     * @notice allows the configurator to update the reserve decimals
4467     * @param _reserve the address of the reserve
4468     * @param _decimals the decimals of the reserve
4469     **/
4470     function setReserveDecimals(address _reserve, uint256 _decimals)
4471         external
4472         onlyLendingPoolConfigurator
4473     {
4474         CoreLibrary.ReserveData storage reserve = reserves[_reserve];
4475         reserve.decimals = _decimals;
4476     }
4477 
4478     /**
4479     * @notice internal functions
4480     **/
4481 
4482     /**
4483     * @dev updates the state of a reserve as a consequence of a borrow action.
4484     * @param _reserve the address of the reserve on which the user is borrowing
4485     * @param _user the address of the borrower
4486     * @param _principalBorrowBalance the previous borrow balance of the borrower before the action
4487     * @param _balanceIncrease the accrued interest of the user on the previous borrowed amount
4488     * @param _amountBorrowed the new amount borrowed
4489     * @param _rateMode the borrow rate mode (stable, variable)
4490     **/
4491 
4492     function updateReserveStateOnBorrowInternal(
4493         address _reserve,
4494         address _user,
4495         uint256 _principalBorrowBalance,
4496         uint256 _balanceIncrease,
4497         uint256 _amountBorrowed,
4498         CoreLibrary.InterestRateMode _rateMode
4499     ) internal {
4500         reserves[_reserve].updateCumulativeIndexes();
4501 
4502         //increasing reserve total borrows to account for the new borrow balance of the user
4503         //NOTE: Depending on the previous borrow mode, the borrows might need to be switched from variable to stable or vice versa
4504 
4505         updateReserveTotalBorrowsByRateModeInternal(
4506             _reserve,
4507             _user,
4508             _principalBorrowBalance,
4509             _balanceIncrease,
4510             _amountBorrowed,
4511             _rateMode
4512         );
4513     }
4514 
4515     /**
4516     * @dev updates the state of a user as a consequence of a borrow action.
4517     * @param _reserve the address of the reserve on which the user is borrowing
4518     * @param _user the address of the borrower
4519     * @param _amountBorrowed the amount borrowed
4520     * @param _balanceIncrease the accrued interest of the user on the previous borrowed amount
4521     * @param _rateMode the borrow rate mode (stable, variable)
4522     * @return the final borrow rate for the user. Emitted by the borrow() event
4523     **/
4524 
4525     function updateUserStateOnBorrowInternal(
4526         address _reserve,
4527         address _user,
4528         uint256 _amountBorrowed,
4529         uint256 _balanceIncrease,
4530         uint256 _fee,
4531         CoreLibrary.InterestRateMode _rateMode
4532     ) internal {
4533         CoreLibrary.ReserveData storage reserve = reserves[_reserve];
4534         CoreLibrary.UserReserveData storage user = usersReserveData[_user][_reserve];
4535 
4536         if (_rateMode == CoreLibrary.InterestRateMode.STABLE) {
4537             //stable
4538             //reset the user variable index, and update the stable rate
4539             user.stableBorrowRate = reserve.currentStableBorrowRate;
4540             user.lastVariableBorrowCumulativeIndex = 0;
4541         } else if (_rateMode == CoreLibrary.InterestRateMode.VARIABLE) {
4542             //variable
4543             //reset the user stable rate, and store the new borrow index
4544             user.stableBorrowRate = 0;
4545             user.lastVariableBorrowCumulativeIndex = reserve.lastVariableBorrowCumulativeIndex;
4546         } else {
4547             revert("Invalid borrow rate mode");
4548         }
4549         //increase the principal borrows and the origination fee
4550         user.principalBorrowBalance = user.principalBorrowBalance.add(_amountBorrowed).add(
4551             _balanceIncrease
4552         );
4553         user.originationFee = user.originationFee.add(_fee);
4554 
4555         //solium-disable-next-line
4556         user.lastUpdateTimestamp = uint40(block.timestamp);
4557 
4558     }
4559 
4560     /**
4561     * @dev updates the state of the reserve as a consequence of a repay action.
4562     * @param _reserve the address of the reserve on which the user is repaying
4563     * @param _user the address of the borrower
4564     * @param _paybackAmountMinusFees the amount being paid back minus fees
4565     * @param _balanceIncrease the accrued interest on the borrowed amount
4566     **/
4567 
4568     function updateReserveStateOnRepayInternal(
4569         address _reserve,
4570         address _user,
4571         uint256 _paybackAmountMinusFees,
4572         uint256 _balanceIncrease
4573     ) internal {
4574         CoreLibrary.ReserveData storage reserve = reserves[_reserve];
4575         CoreLibrary.UserReserveData storage user = usersReserveData[_reserve][_user];
4576 
4577         CoreLibrary.InterestRateMode borrowRateMode = getUserCurrentBorrowRateMode(_reserve, _user);
4578 
4579         //update the indexes
4580         reserves[_reserve].updateCumulativeIndexes();
4581 
4582         //compound the cumulated interest to the borrow balance and then subtracting the payback amount
4583         if (borrowRateMode == CoreLibrary.InterestRateMode.STABLE) {
4584             reserve.increaseTotalBorrowsStableAndUpdateAverageRate(
4585                 _balanceIncrease,
4586                 user.stableBorrowRate
4587             );
4588             reserve.decreaseTotalBorrowsStableAndUpdateAverageRate(
4589                 _paybackAmountMinusFees,
4590                 user.stableBorrowRate
4591             );
4592         } else {
4593             reserve.increaseTotalBorrowsVariable(_balanceIncrease);
4594             reserve.decreaseTotalBorrowsVariable(_paybackAmountMinusFees);
4595         }
4596     }
4597 
4598     /**
4599     * @dev updates the state of the user as a consequence of a repay action.
4600     * @param _reserve the address of the reserve on which the user is repaying
4601     * @param _user the address of the borrower
4602     * @param _paybackAmountMinusFees the amount being paid back minus fees
4603     * @param _originationFeeRepaid the fee on the amount that is being repaid
4604     * @param _balanceIncrease the accrued interest on the borrowed amount
4605     * @param _repaidWholeLoan true if the user is repaying the whole loan
4606     **/
4607     function updateUserStateOnRepayInternal(
4608         address _reserve,
4609         address _user,
4610         uint256 _paybackAmountMinusFees,
4611         uint256 _originationFeeRepaid,
4612         uint256 _balanceIncrease,
4613         bool _repaidWholeLoan
4614     ) internal {
4615         CoreLibrary.ReserveData storage reserve = reserves[_reserve];
4616         CoreLibrary.UserReserveData storage user = usersReserveData[_user][_reserve];
4617 
4618         //update the user principal borrow balance, adding the cumulated interest and then subtracting the payback amount
4619         user.principalBorrowBalance = user.principalBorrowBalance.add(_balanceIncrease).sub(
4620             _paybackAmountMinusFees
4621         );
4622         user.lastVariableBorrowCumulativeIndex = reserve.lastVariableBorrowCumulativeIndex;
4623 
4624         //if the balance decrease is equal to the previous principal (user is repaying the whole loan)
4625         //and the rate mode is stable, we reset the interest rate mode of the user
4626         if (_repaidWholeLoan) {
4627             user.stableBorrowRate = 0;
4628             user.lastVariableBorrowCumulativeIndex = 0;
4629         }
4630         user.originationFee = user.originationFee.sub(_originationFeeRepaid);
4631 
4632         //solium-disable-next-line
4633         user.lastUpdateTimestamp = uint40(block.timestamp);
4634 
4635     }
4636 
4637     /**
4638     * @dev updates the state of the user as a consequence of a swap rate action.
4639     * @param _reserve the address of the reserve on which the user is performing the rate swap
4640     * @param _user the address of the borrower
4641     * @param _principalBorrowBalance the the principal amount borrowed by the user
4642     * @param _compoundedBorrowBalance the principal amount plus the accrued interest
4643     * @param _currentRateMode the rate mode at which the user borrowed
4644     **/
4645     function updateReserveStateOnSwapRateInternal(
4646         address _reserve,
4647         address _user,
4648         uint256 _principalBorrowBalance,
4649         uint256 _compoundedBorrowBalance,
4650         CoreLibrary.InterestRateMode _currentRateMode
4651     ) internal {
4652         CoreLibrary.ReserveData storage reserve = reserves[_reserve];
4653         CoreLibrary.UserReserveData storage user = usersReserveData[_user][_reserve];
4654 
4655         //compounding reserve indexes
4656         reserve.updateCumulativeIndexes();
4657 
4658         if (_currentRateMode == CoreLibrary.InterestRateMode.STABLE) {
4659             uint256 userCurrentStableRate = user.stableBorrowRate;
4660 
4661             //swap to variable
4662             reserve.decreaseTotalBorrowsStableAndUpdateAverageRate(
4663                 _principalBorrowBalance,
4664                 userCurrentStableRate
4665             ); //decreasing stable from old principal balance
4666             reserve.increaseTotalBorrowsVariable(_compoundedBorrowBalance); //increase variable borrows
4667         } else if (_currentRateMode == CoreLibrary.InterestRateMode.VARIABLE) {
4668             //swap to stable
4669             uint256 currentStableRate = reserve.currentStableBorrowRate;
4670             reserve.decreaseTotalBorrowsVariable(_principalBorrowBalance);
4671             reserve.increaseTotalBorrowsStableAndUpdateAverageRate(
4672                 _compoundedBorrowBalance,
4673                 currentStableRate
4674             );
4675 
4676         } else {
4677             revert("Invalid rate mode received");
4678         }
4679     }
4680 
4681     /**
4682     * @dev updates the state of the user as a consequence of a swap rate action.
4683     * @param _reserve the address of the reserve on which the user is performing the swap
4684     * @param _user the address of the borrower
4685     * @param _balanceIncrease the accrued interest on the borrowed amount
4686     * @param _currentRateMode the current rate mode of the user
4687     **/
4688 
4689     function updateUserStateOnSwapRateInternal(
4690         address _reserve,
4691         address _user,
4692         uint256 _balanceIncrease,
4693         CoreLibrary.InterestRateMode _currentRateMode
4694     ) internal returns (CoreLibrary.InterestRateMode) {
4695         CoreLibrary.UserReserveData storage user = usersReserveData[_user][_reserve];
4696         CoreLibrary.ReserveData storage reserve = reserves[_reserve];
4697 
4698         CoreLibrary.InterestRateMode newMode = CoreLibrary.InterestRateMode.NONE;
4699 
4700         if (_currentRateMode == CoreLibrary.InterestRateMode.VARIABLE) {
4701             //switch to stable
4702             newMode = CoreLibrary.InterestRateMode.STABLE;
4703             user.stableBorrowRate = reserve.currentStableBorrowRate;
4704             user.lastVariableBorrowCumulativeIndex = 0;
4705         } else if (_currentRateMode == CoreLibrary.InterestRateMode.STABLE) {
4706             newMode = CoreLibrary.InterestRateMode.VARIABLE;
4707             user.stableBorrowRate = 0;
4708             user.lastVariableBorrowCumulativeIndex = reserve.lastVariableBorrowCumulativeIndex;
4709         } else {
4710             revert("Invalid interest rate mode received");
4711         }
4712         //compounding cumulated interest
4713         user.principalBorrowBalance = user.principalBorrowBalance.add(_balanceIncrease);
4714         //solium-disable-next-line
4715         user.lastUpdateTimestamp = uint40(block.timestamp);
4716 
4717         return newMode;
4718     }
4719 
4720     /**
4721     * @dev updates the state of the principal reserve as a consequence of a liquidation action.
4722     * @param _principalReserve the address of the principal reserve that is being repaid
4723     * @param _user the address of the borrower
4724     * @param _amountToLiquidate the amount being repaid by the liquidator
4725     * @param _balanceIncrease the accrued interest on the borrowed amount
4726     **/
4727 
4728     function updatePrincipalReserveStateOnLiquidationInternal(
4729         address _principalReserve,
4730         address _user,
4731         uint256 _amountToLiquidate,
4732         uint256 _balanceIncrease
4733     ) internal {
4734         CoreLibrary.ReserveData storage reserve = reserves[_principalReserve];
4735         CoreLibrary.UserReserveData storage user = usersReserveData[_user][_principalReserve];
4736 
4737         //update principal reserve data
4738         reserve.updateCumulativeIndexes();
4739 
4740         CoreLibrary.InterestRateMode borrowRateMode = getUserCurrentBorrowRateMode(
4741             _principalReserve,
4742             _user
4743         );
4744 
4745         if (borrowRateMode == CoreLibrary.InterestRateMode.STABLE) {
4746             //increase the total borrows by the compounded interest
4747             reserve.increaseTotalBorrowsStableAndUpdateAverageRate(
4748                 _balanceIncrease,
4749                 user.stableBorrowRate
4750             );
4751 
4752             //decrease by the actual amount to liquidate
4753             reserve.decreaseTotalBorrowsStableAndUpdateAverageRate(
4754                 _amountToLiquidate,
4755                 user.stableBorrowRate
4756             );
4757 
4758         } else {
4759             //increase the total borrows by the compounded interest
4760             reserve.increaseTotalBorrowsVariable(_balanceIncrease);
4761 
4762             //decrease by the actual amount to liquidate
4763             reserve.decreaseTotalBorrowsVariable(_amountToLiquidate);
4764         }
4765 
4766     }
4767 
4768     /**
4769     * @dev updates the state of the collateral reserve as a consequence of a liquidation action.
4770     * @param _collateralReserve the address of the collateral reserve that is being liquidated
4771     **/
4772     function updateCollateralReserveStateOnLiquidationInternal(
4773         address _collateralReserve
4774     ) internal {
4775         //update collateral reserve
4776         reserves[_collateralReserve].updateCumulativeIndexes();
4777 
4778     }
4779 
4780     /**
4781     * @dev updates the state of the user being liquidated as a consequence of a liquidation action.
4782     * @param _reserve the address of the principal reserve that is being repaid
4783     * @param _user the address of the borrower
4784     * @param _amountToLiquidate the amount being repaid by the liquidator
4785     * @param _feeLiquidated the amount of origination fee being liquidated
4786     * @param _balanceIncrease the accrued interest on the borrowed amount
4787     **/
4788     function updateUserStateOnLiquidationInternal(
4789         address _reserve,
4790         address _user,
4791         uint256 _amountToLiquidate,
4792         uint256 _feeLiquidated,
4793         uint256 _balanceIncrease
4794     ) internal {
4795         CoreLibrary.UserReserveData storage user = usersReserveData[_user][_reserve];
4796         CoreLibrary.ReserveData storage reserve = reserves[_reserve];
4797         //first increase by the compounded interest, then decrease by the liquidated amount
4798         user.principalBorrowBalance = user.principalBorrowBalance.add(_balanceIncrease).sub(
4799             _amountToLiquidate
4800         );
4801 
4802         if (
4803             getUserCurrentBorrowRateMode(_reserve, _user) == CoreLibrary.InterestRateMode.VARIABLE
4804         ) {
4805             user.lastVariableBorrowCumulativeIndex = reserve.lastVariableBorrowCumulativeIndex;
4806         }
4807 
4808         if(_feeLiquidated > 0){
4809             user.originationFee = user.originationFee.sub(_feeLiquidated);
4810         }
4811 
4812         //solium-disable-next-line
4813         user.lastUpdateTimestamp = uint40(block.timestamp);
4814     }
4815 
4816     /**
4817     * @dev updates the state of the reserve as a consequence of a stable rate rebalance
4818     * @param _reserve the address of the principal reserve where the user borrowed
4819     * @param _user the address of the borrower
4820     * @param _balanceIncrease the accrued interest on the borrowed amount
4821     **/
4822 
4823     function updateReserveStateOnRebalanceInternal(
4824         address _reserve,
4825         address _user,
4826         uint256 _balanceIncrease
4827     ) internal {
4828         CoreLibrary.ReserveData storage reserve = reserves[_reserve];
4829         CoreLibrary.UserReserveData storage user = usersReserveData[_user][_reserve];
4830 
4831         reserve.updateCumulativeIndexes();
4832 
4833         reserve.increaseTotalBorrowsStableAndUpdateAverageRate(
4834             _balanceIncrease,
4835             user.stableBorrowRate
4836         );
4837 
4838     }
4839 
4840     /**
4841     * @dev updates the state of the user as a consequence of a stable rate rebalance
4842     * @param _reserve the address of the principal reserve where the user borrowed
4843     * @param _user the address of the borrower
4844     * @param _balanceIncrease the accrued interest on the borrowed amount
4845     **/
4846 
4847     function updateUserStateOnRebalanceInternal(
4848         address _reserve,
4849         address _user,
4850         uint256 _balanceIncrease
4851     ) internal {
4852         CoreLibrary.UserReserveData storage user = usersReserveData[_user][_reserve];
4853         CoreLibrary.ReserveData storage reserve = reserves[_reserve];
4854 
4855         user.principalBorrowBalance = user.principalBorrowBalance.add(_balanceIncrease);
4856         user.stableBorrowRate = reserve.currentStableBorrowRate;
4857 
4858         //solium-disable-next-line
4859         user.lastUpdateTimestamp = uint40(block.timestamp);
4860     }
4861 
4862     /**
4863     * @dev updates the state of the user as a consequence of a stable rate rebalance
4864     * @param _reserve the address of the principal reserve where the user borrowed
4865     * @param _user the address of the borrower
4866     * @param _balanceIncrease the accrued interest on the borrowed amount
4867     * @param _amountBorrowed the accrued interest on the borrowed amount
4868     **/
4869     function updateReserveTotalBorrowsByRateModeInternal(
4870         address _reserve,
4871         address _user,
4872         uint256 _principalBalance,
4873         uint256 _balanceIncrease,
4874         uint256 _amountBorrowed,
4875         CoreLibrary.InterestRateMode _newBorrowRateMode
4876     ) internal {
4877         CoreLibrary.InterestRateMode previousRateMode = getUserCurrentBorrowRateMode(
4878             _reserve,
4879             _user
4880         );
4881         CoreLibrary.ReserveData storage reserve = reserves[_reserve];
4882 
4883         if (previousRateMode == CoreLibrary.InterestRateMode.STABLE) {
4884             CoreLibrary.UserReserveData storage user = usersReserveData[_user][_reserve];
4885             reserve.decreaseTotalBorrowsStableAndUpdateAverageRate(
4886                 _principalBalance,
4887                 user.stableBorrowRate
4888             );
4889         } else if (previousRateMode == CoreLibrary.InterestRateMode.VARIABLE) {
4890             reserve.decreaseTotalBorrowsVariable(_principalBalance);
4891         }
4892 
4893         uint256 newPrincipalAmount = _principalBalance.add(_balanceIncrease).add(_amountBorrowed);
4894         if (_newBorrowRateMode == CoreLibrary.InterestRateMode.STABLE) {
4895             reserve.increaseTotalBorrowsStableAndUpdateAverageRate(
4896                 newPrincipalAmount,
4897                 reserve.currentStableBorrowRate
4898             );
4899         } else if (_newBorrowRateMode == CoreLibrary.InterestRateMode.VARIABLE) {
4900             reserve.increaseTotalBorrowsVariable(newPrincipalAmount);
4901         } else {
4902             revert("Invalid new borrow rate mode");
4903         }
4904     }
4905 
4906     /**
4907     * @dev Updates the reserve current stable borrow rate Rf, the current variable borrow rate Rv and the current liquidity rate Rl.
4908     * Also updates the lastUpdateTimestamp value. Please refer to the whitepaper for further information.
4909     * @param _reserve the address of the reserve to be updated
4910     * @param _liquidityAdded the amount of liquidity added to the protocol (deposit or repay) in the previous action
4911     * @param _liquidityTaken the amount of liquidity taken from the protocol (redeem or borrow)
4912     **/
4913 
4914     function updateReserveInterestRatesAndTimestampInternal(
4915         address _reserve,
4916         uint256 _liquidityAdded,
4917         uint256 _liquidityTaken
4918     ) internal {
4919         CoreLibrary.ReserveData storage reserve = reserves[_reserve];
4920         (uint256 newLiquidityRate, uint256 newStableRate, uint256 newVariableRate) = IReserveInterestRateStrategy(
4921             reserve
4922                 .interestRateStrategyAddress
4923         )
4924             .calculateInterestRates(
4925             _reserve,
4926             getReserveAvailableLiquidity(_reserve).add(_liquidityAdded).sub(_liquidityTaken),
4927             reserve.totalBorrowsStable,
4928             reserve.totalBorrowsVariable,
4929             reserve.currentAverageStableBorrowRate
4930         );
4931 
4932         reserve.currentLiquidityRate = newLiquidityRate;
4933         reserve.currentStableBorrowRate = newStableRate;
4934         reserve.currentVariableBorrowRate = newVariableRate;
4935 
4936         //solium-disable-next-line
4937         reserve.lastUpdateTimestamp = uint40(block.timestamp);
4938 
4939         emit ReserveUpdated(
4940             _reserve,
4941             newLiquidityRate,
4942             newStableRate,
4943             newVariableRate,
4944             reserve.lastLiquidityCumulativeIndex,
4945             reserve.lastVariableBorrowCumulativeIndex
4946         );
4947     }
4948 
4949     /**
4950     * @dev transfers to the protocol fees of a flashloan to the fees collection address
4951     * @param _token the address of the token being transferred
4952     * @param _amount the amount being transferred
4953     **/
4954 
4955     function transferFlashLoanProtocolFeeInternal(address _token, uint256 _amount) internal {
4956         address payable receiver = address(uint160(addressesProvider.getTokenDistributor()));
4957 
4958         if (_token != EthAddressLib.ethAddress()) {
4959             ERC20(_token).safeTransfer(receiver, _amount);
4960         } else {
4961             receiver.transfer(_amount);
4962         }
4963     }
4964 
4965     /**
4966     * @dev updates the internal configuration of the core
4967     **/
4968     function refreshConfigInternal() internal {
4969         lendingPoolAddress = addressesProvider.getLendingPool();
4970     }
4971 
4972     /**
4973     * @dev adds a reserve to the array of the reserves address
4974     **/
4975     function addReserveToListInternal(address _reserve) internal {
4976         bool reserveAlreadyAdded = false;
4977         for (uint256 i = 0; i < reservesList.length; i++)
4978             if (reservesList[i] == _reserve) {
4979                 reserveAlreadyAdded = true;
4980             }
4981         if (!reserveAlreadyAdded) reservesList.push(_reserve);
4982     }
4983 
4984 }
4985 
4986 /**
4987 * @title LendingPool contract
4988 * @notice Implements the actions of the LendingPool, and exposes accessory methods to fetch the users and reserve data
4989 * @author Aave
4990  **/
4991 
4992 contract LendingPool is ReentrancyGuard, VersionedInitializable {
4993     using SafeMath for uint256;
4994     using WadRayMath for uint256;
4995     using Address for address;
4996 
4997     LendingPoolAddressesProvider public addressesProvider;
4998     LendingPoolCore public core;
4999     LendingPoolDataProvider public dataProvider;
5000     LendingPoolParametersProvider public parametersProvider;
5001     IFeeProvider feeProvider;
5002 
5003     /**
5004     * @dev emitted on deposit
5005     * @param _reserve the address of the reserve
5006     * @param _user the address of the user
5007     * @param _amount the amount to be deposited
5008     * @param _referral the referral number of the action
5009     * @param _timestamp the timestamp of the action
5010     **/
5011     event Deposit(
5012         address indexed _reserve,
5013         address indexed _user,
5014         uint256 _amount,
5015         uint16 indexed _referral,
5016         uint256 _timestamp
5017     );
5018 
5019     /**
5020     * @dev emitted during a redeem action.
5021     * @param _reserve the address of the reserve
5022     * @param _user the address of the user
5023     * @param _amount the amount to be deposited
5024     * @param _timestamp the timestamp of the action
5025     **/
5026     event RedeemUnderlying(
5027         address indexed _reserve,
5028         address indexed _user,
5029         uint256 _amount,
5030         uint256 _timestamp
5031     );
5032 
5033     /**
5034     * @dev emitted on borrow
5035     * @param _reserve the address of the reserve
5036     * @param _user the address of the user
5037     * @param _amount the amount to be deposited
5038     * @param _borrowRateMode the rate mode, can be either 1-stable or 2-variable
5039     * @param _borrowRate the rate at which the user has borrowed
5040     * @param _originationFee the origination fee to be paid by the user
5041     * @param _borrowBalanceIncrease the balance increase since the last borrow, 0 if it's the first time borrowing
5042     * @param _referral the referral number of the action
5043     * @param _timestamp the timestamp of the action
5044     **/
5045     event Borrow(
5046         address indexed _reserve,
5047         address indexed _user,
5048         uint256 _amount,
5049         uint256 _borrowRateMode,
5050         uint256 _borrowRate,
5051         uint256 _originationFee,
5052         uint256 _borrowBalanceIncrease,
5053         uint16 indexed _referral,
5054         uint256 _timestamp
5055     );
5056 
5057     /**
5058     * @dev emitted on repay
5059     * @param _reserve the address of the reserve
5060     * @param _user the address of the user for which the repay has been executed
5061     * @param _repayer the address of the user that has performed the repay action
5062     * @param _amountMinusFees the amount repaid minus fees
5063     * @param _fees the fees repaid
5064     * @param _borrowBalanceIncrease the balance increase since the last action
5065     * @param _timestamp the timestamp of the action
5066     **/
5067     event Repay(
5068         address indexed _reserve,
5069         address indexed _user,
5070         address indexed _repayer,
5071         uint256 _amountMinusFees,
5072         uint256 _fees,
5073         uint256 _borrowBalanceIncrease,
5074         uint256 _timestamp
5075     );
5076 
5077     /**
5078     * @dev emitted when a user performs a rate swap
5079     * @param _reserve the address of the reserve
5080     * @param _user the address of the user executing the swap
5081     * @param _newRateMode the new interest rate mode
5082     * @param _newRate the new borrow rate
5083     * @param _borrowBalanceIncrease the balance increase since the last action
5084     * @param _timestamp the timestamp of the action
5085     **/
5086     event Swap(
5087         address indexed _reserve,
5088         address indexed _user,
5089         uint256 _newRateMode,
5090         uint256 _newRate,
5091         uint256 _borrowBalanceIncrease,
5092         uint256 _timestamp
5093     );
5094 
5095     /**
5096     * @dev emitted when a user enables a reserve as collateral
5097     * @param _reserve the address of the reserve
5098     * @param _user the address of the user
5099     **/
5100     event ReserveUsedAsCollateralEnabled(address indexed _reserve, address indexed _user);
5101 
5102     /**
5103     * @dev emitted when a user disables a reserve as collateral
5104     * @param _reserve the address of the reserve
5105     * @param _user the address of the user
5106     **/
5107     event ReserveUsedAsCollateralDisabled(address indexed _reserve, address indexed _user);
5108 
5109     /**
5110     * @dev emitted when the stable rate of a user gets rebalanced
5111     * @param _reserve the address of the reserve
5112     * @param _user the address of the user for which the rebalance has been executed
5113     * @param _newStableRate the new stable borrow rate after the rebalance
5114     * @param _borrowBalanceIncrease the balance increase since the last action
5115     * @param _timestamp the timestamp of the action
5116     **/
5117     event RebalanceStableBorrowRate(
5118         address indexed _reserve,
5119         address indexed _user,
5120         uint256 _newStableRate,
5121         uint256 _borrowBalanceIncrease,
5122         uint256 _timestamp
5123     );
5124 
5125     /**
5126     * @dev emitted when a flashloan is executed
5127     * @param _target the address of the flashLoanReceiver
5128     * @param _reserve the address of the reserve
5129     * @param _amount the amount requested
5130     * @param _totalFee the total fee on the amount
5131     * @param _protocolFee the part of the fee for the protocol
5132     * @param _timestamp the timestamp of the action
5133     **/
5134     event FlashLoan(
5135         address indexed _target,
5136         address indexed _reserve,
5137         uint256 _amount,
5138         uint256 _totalFee,
5139         uint256 _protocolFee,
5140         uint256 _timestamp
5141     );
5142 
5143     /**
5144     * @dev these events are not emitted directly by the LendingPool
5145     * but they are declared here as the LendingPoolLiquidationManager
5146     * is executed using a delegateCall().
5147     * This allows to have the events in the generated ABI for LendingPool.
5148     **/
5149 
5150     /**
5151     * @dev emitted when a borrow fee is liquidated
5152     * @param _collateral the address of the collateral being liquidated
5153     * @param _reserve the address of the reserve
5154     * @param _user the address of the user being liquidated
5155     * @param _feeLiquidated the total fee liquidated
5156     * @param _liquidatedCollateralForFee the amount of collateral received by the protocol in exchange for the fee
5157     * @param _timestamp the timestamp of the action
5158     **/
5159     event OriginationFeeLiquidated(
5160         address indexed _collateral,
5161         address indexed _reserve,
5162         address indexed _user,
5163         uint256 _feeLiquidated,
5164         uint256 _liquidatedCollateralForFee,
5165         uint256 _timestamp
5166     );
5167 
5168     /**
5169     * @dev emitted when a borrower is liquidated
5170     * @param _collateral the address of the collateral being liquidated
5171     * @param _reserve the address of the reserve
5172     * @param _user the address of the user being liquidated
5173     * @param _purchaseAmount the total amount liquidated
5174     * @param _liquidatedCollateralAmount the amount of collateral being liquidated
5175     * @param _accruedBorrowInterest the amount of interest accrued by the borrower since the last action
5176     * @param _liquidator the address of the liquidator
5177     * @param _receiveAToken true if the liquidator wants to receive aTokens, false otherwise
5178     * @param _timestamp the timestamp of the action
5179     **/
5180     event LiquidationCall(
5181         address indexed _collateral,
5182         address indexed _reserve,
5183         address indexed _user,
5184         uint256 _purchaseAmount,
5185         uint256 _liquidatedCollateralAmount,
5186         uint256 _accruedBorrowInterest,
5187         address _liquidator,
5188         bool _receiveAToken,
5189         uint256 _timestamp
5190     );
5191 
5192     /**
5193     * @dev functions affected by this modifier can only be invoked by the
5194     * aToken.sol contract
5195     * @param _reserve the address of the reserve
5196     **/
5197     modifier onlyOverlyingAToken(address _reserve) {
5198         require(
5199             msg.sender == core.getReserveATokenAddress(_reserve),
5200             "The caller of this function can only be the aToken contract of this reserve"
5201         );
5202         _;
5203     }
5204 
5205     /**
5206     * @dev functions affected by this modifier can only be invoked if the reserve is active
5207     * @param _reserve the address of the reserve
5208     **/
5209     modifier onlyActiveReserve(address _reserve) {
5210         requireReserveActiveInternal(_reserve);
5211         _;
5212     }
5213 
5214     /**
5215     * @dev functions affected by this modifier can only be invoked if the reserve is not freezed.
5216     * A freezed reserve only allows redeems, repays, rebalances and liquidations.
5217     * @param _reserve the address of the reserve
5218     **/
5219     modifier onlyUnfreezedReserve(address _reserve) {
5220         requireReserveNotFreezedInternal(_reserve);
5221         _;
5222     }
5223 
5224     /**
5225     * @dev functions affected by this modifier can only be invoked if the provided _amount input parameter
5226     * is not zero.
5227     * @param _amount the amount provided
5228     **/
5229     modifier onlyAmountGreaterThanZero(uint256 _amount) {
5230         requireAmountGreaterThanZeroInternal(_amount);
5231         _;
5232     }
5233 
5234     uint256 public constant UINT_MAX_VALUE = uint256(-1);
5235 
5236     uint256 public constant LENDINGPOOL_REVISION = 0x2;
5237 
5238     function getRevision() internal pure returns (uint256) {
5239         return LENDINGPOOL_REVISION;
5240     }
5241 
5242     /**
5243     * @dev this function is invoked by the proxy contract when the LendingPool contract is added to the
5244     * AddressesProvider.
5245     * @param _addressesProvider the address of the LendingPoolAddressesProvider registry
5246     **/
5247     function initialize(LendingPoolAddressesProvider _addressesProvider) public initializer {
5248         addressesProvider = _addressesProvider;
5249         core = LendingPoolCore(addressesProvider.getLendingPoolCore());
5250         dataProvider = LendingPoolDataProvider(addressesProvider.getLendingPoolDataProvider());
5251         parametersProvider = LendingPoolParametersProvider(
5252             addressesProvider.getLendingPoolParametersProvider()
5253         );
5254         feeProvider = IFeeProvider(addressesProvider.getFeeProvider());
5255     }
5256 
5257     /**
5258     * @dev deposits The underlying asset into the reserve. A corresponding amount of the overlying asset (aTokens)
5259     * is minted.
5260     * @param _reserve the address of the reserve
5261     * @param _amount the amount to be deposited
5262     * @param _referralCode integrators are assigned a referral code and can potentially receive rewards.
5263     **/
5264     function deposit(address _reserve, uint256 _amount, uint16 _referralCode)
5265         external
5266         payable
5267         nonReentrant
5268         onlyActiveReserve(_reserve)
5269         onlyUnfreezedReserve(_reserve)
5270         onlyAmountGreaterThanZero(_amount)
5271     {
5272         AToken aToken = AToken(core.getReserveATokenAddress(_reserve));
5273 
5274         bool isFirstDeposit = aToken.balanceOf(msg.sender) == 0;
5275 
5276         core.updateStateOnDeposit(_reserve, msg.sender, _amount, isFirstDeposit);
5277 
5278         //minting AToken to user 1:1 with the specific exchange rate
5279         aToken.mintOnDeposit(msg.sender, _amount);
5280 
5281         //transfer to the core contract
5282         core.transferToReserve.value(msg.value)(_reserve, msg.sender, _amount);
5283 
5284         //solium-disable-next-line
5285         emit Deposit(_reserve, msg.sender, _amount, _referralCode, block.timestamp);
5286 
5287     }
5288 
5289     /**
5290     * @dev Redeems the underlying amount of assets requested by _user.
5291     * This function is executed by the overlying aToken contract in response to a redeem action.
5292     * @param _reserve the address of the reserve
5293     * @param _user the address of the user performing the action
5294     * @param _amount the underlying amount to be redeemed
5295     **/
5296     function redeemUnderlying(
5297         address _reserve,
5298         address payable _user,
5299         uint256 _amount,
5300         uint256 _aTokenBalanceAfterRedeem
5301     )
5302         external
5303         nonReentrant
5304         onlyOverlyingAToken(_reserve)
5305         onlyActiveReserve(_reserve)
5306         onlyAmountGreaterThanZero(_amount)
5307     {
5308         uint256 currentAvailableLiquidity = core.getReserveAvailableLiquidity(_reserve);
5309         require(
5310             currentAvailableLiquidity >= _amount,
5311             "There is not enough liquidity available to redeem"
5312         );
5313 
5314         core.updateStateOnRedeem(_reserve, _user, _amount, _aTokenBalanceAfterRedeem == 0);
5315 
5316         core.transferToUser(_reserve, _user, _amount);
5317 
5318         //solium-disable-next-line
5319         emit RedeemUnderlying(_reserve, _user, _amount, block.timestamp);
5320 
5321     }
5322 
5323     /**
5324     * @dev data structures for local computations in the borrow() method.
5325     */
5326 
5327     struct BorrowLocalVars {
5328         uint256 principalBorrowBalance;
5329         uint256 currentLtv;
5330         uint256 currentLiquidationThreshold;
5331         uint256 borrowFee;
5332         uint256 requestedBorrowAmountETH;
5333         uint256 amountOfCollateralNeededETH;
5334         uint256 userCollateralBalanceETH;
5335         uint256 userBorrowBalanceETH;
5336         uint256 userTotalFeesETH;
5337         uint256 borrowBalanceIncrease;
5338         uint256 currentReserveStableRate;
5339         uint256 availableLiquidity;
5340         uint256 reserveDecimals;
5341         uint256 finalUserBorrowRate;
5342         CoreLibrary.InterestRateMode rateMode;
5343         bool healthFactorBelowThreshold;
5344     }
5345 
5346     /**
5347     * @dev Allows users to borrow a specific amount of the reserve currency, provided that the borrower
5348     * already deposited enough collateral.
5349     * @param _reserve the address of the reserve
5350     * @param _amount the amount to be borrowed
5351     * @param _interestRateMode the interest rate mode at which the user wants to borrow. Can be 0 (STABLE) or 1 (VARIABLE)
5352     **/
5353     function borrow(
5354         address _reserve,
5355         uint256 _amount,
5356         uint256 _interestRateMode,
5357         uint16 _referralCode
5358     )
5359         external
5360         nonReentrant
5361         onlyActiveReserve(_reserve)
5362         onlyUnfreezedReserve(_reserve)
5363         onlyAmountGreaterThanZero(_amount)
5364     {
5365         // Usage of a memory struct of vars to avoid "Stack too deep" errors due to local variables
5366         BorrowLocalVars memory vars;
5367 
5368         //check that the reserve is enabled for borrowing
5369         require(core.isReserveBorrowingEnabled(_reserve), "Reserve is not enabled for borrowing");
5370         //validate interest rate mode
5371         require(
5372             uint256(CoreLibrary.InterestRateMode.VARIABLE) == _interestRateMode ||
5373                 uint256(CoreLibrary.InterestRateMode.STABLE) == _interestRateMode,
5374             "Invalid interest rate mode selected"
5375         );
5376 
5377         //cast the rateMode to coreLibrary.interestRateMode
5378         vars.rateMode = CoreLibrary.InterestRateMode(_interestRateMode);
5379 
5380         //check that the amount is available in the reserve
5381         vars.availableLiquidity = core.getReserveAvailableLiquidity(_reserve);
5382 
5383         require(
5384             vars.availableLiquidity >= _amount,
5385             "There is not enough liquidity available in the reserve"
5386         );
5387 
5388         (
5389             ,
5390             vars.userCollateralBalanceETH,
5391             vars.userBorrowBalanceETH,
5392             vars.userTotalFeesETH,
5393             vars.currentLtv,
5394             vars.currentLiquidationThreshold,
5395             ,
5396             vars.healthFactorBelowThreshold
5397         ) = dataProvider.calculateUserGlobalData(msg.sender);
5398 
5399         require(vars.userCollateralBalanceETH > 0, "The collateral balance is 0");
5400 
5401         require(
5402             !vars.healthFactorBelowThreshold,
5403             "The borrower can already be liquidated so he cannot borrow more"
5404         );
5405 
5406         //calculating fees
5407         vars.borrowFee = feeProvider.calculateLoanOriginationFee(msg.sender, _amount);
5408 
5409         require(vars.borrowFee > 0, "The amount to borrow is too small");
5410 
5411         vars.amountOfCollateralNeededETH = dataProvider.calculateCollateralNeededInETH(
5412             _reserve,
5413             _amount,
5414             vars.borrowFee,
5415             vars.userBorrowBalanceETH,
5416             vars.userTotalFeesETH,
5417             vars.currentLtv
5418         );
5419 
5420         require(
5421             vars.amountOfCollateralNeededETH <= vars.userCollateralBalanceETH,
5422             "There is not enough collateral to cover a new borrow"
5423         );
5424 
5425         /**
5426         * Following conditions need to be met if the user is borrowing at a stable rate:
5427         * 1. Reserve must be enabled for stable rate borrowing
5428         * 2. Users cannot borrow from the reserve if their collateral is (mostly) the same currency
5429         *    they are borrowing, to prevent abuses.
5430         * 3. Users will be able to borrow only a relatively small, configurable amount of the total
5431         *    liquidity
5432         **/
5433 
5434         if (vars.rateMode == CoreLibrary.InterestRateMode.STABLE) {
5435             //check if the borrow mode is stable and if stable rate borrowing is enabled on this reserve
5436             require(
5437                 core.isUserAllowedToBorrowAtStable(_reserve, msg.sender, _amount),
5438                 "User cannot borrow the selected amount with a stable rate"
5439             );
5440 
5441             //calculate the max available loan size in stable rate mode as a percentage of the
5442             //available liquidity
5443             uint256 maxLoanPercent = parametersProvider.getMaxStableRateBorrowSizePercent();
5444             uint256 maxLoanSizeStable = vars.availableLiquidity.mul(maxLoanPercent).div(100);
5445 
5446             require(
5447                 _amount <= maxLoanSizeStable,
5448                 "User is trying to borrow too much liquidity at a stable rate"
5449             );
5450         }
5451 
5452         //all conditions passed - borrow is accepted
5453         (vars.finalUserBorrowRate, vars.borrowBalanceIncrease) = core.updateStateOnBorrow(
5454             _reserve,
5455             msg.sender,
5456             _amount,
5457             vars.borrowFee,
5458             vars.rateMode
5459         );
5460 
5461         //if we reached this point, we can transfer
5462         core.transferToUser(_reserve, msg.sender, _amount);
5463 
5464         emit Borrow(
5465             _reserve,
5466             msg.sender,
5467             _amount,
5468             _interestRateMode,
5469             vars.finalUserBorrowRate,
5470             vars.borrowFee,
5471             vars.borrowBalanceIncrease,
5472             _referralCode,
5473             //solium-disable-next-line
5474             block.timestamp
5475         );
5476     }
5477 
5478     /**
5479     * @notice repays a borrow on the specific reserve, for the specified amount (or for the whole amount, if uint256(-1) is specified).
5480     * @dev the target user is defined by _onBehalfOf. If there is no repayment on behalf of another account,
5481     * _onBehalfOf must be equal to msg.sender.
5482     * @param _reserve the address of the reserve on which the user borrowed
5483     * @param _amount the amount to repay, or uint256(-1) if the user wants to repay everything
5484     * @param _onBehalfOf the address for which msg.sender is repaying.
5485     **/
5486 
5487     struct RepayLocalVars {
5488         uint256 principalBorrowBalance;
5489         uint256 compoundedBorrowBalance;
5490         uint256 borrowBalanceIncrease;
5491         bool isETH;
5492         uint256 paybackAmount;
5493         uint256 paybackAmountMinusFees;
5494         uint256 currentStableRate;
5495         uint256 originationFee;
5496     }
5497 
5498     function repay(address _reserve, uint256 _amount, address payable _onBehalfOf)
5499         external
5500         payable
5501         nonReentrant
5502         onlyActiveReserve(_reserve)
5503         onlyAmountGreaterThanZero(_amount)
5504     {
5505         // Usage of a memory struct of vars to avoid "Stack too deep" errors due to local variables
5506         RepayLocalVars memory vars;
5507 
5508         (
5509             vars.principalBorrowBalance,
5510             vars.compoundedBorrowBalance,
5511             vars.borrowBalanceIncrease
5512         ) = core.getUserBorrowBalances(_reserve, _onBehalfOf);
5513 
5514         vars.originationFee = core.getUserOriginationFee(_reserve, _onBehalfOf);
5515         vars.isETH = EthAddressLib.ethAddress() == _reserve;
5516 
5517         require(vars.compoundedBorrowBalance > 0, "The user does not have any borrow pending");
5518 
5519         require(
5520             _amount != UINT_MAX_VALUE || msg.sender == _onBehalfOf,
5521             "To repay on behalf of an user an explicit amount to repay is needed."
5522         );
5523 
5524         //default to max amount
5525         vars.paybackAmount = vars.compoundedBorrowBalance.add(vars.originationFee);
5526 
5527         if (_amount != UINT_MAX_VALUE && _amount < vars.paybackAmount) {
5528             vars.paybackAmount = _amount;
5529         }
5530 
5531         require(
5532             !vars.isETH || msg.value >= vars.paybackAmount,
5533             "Invalid msg.value sent for the repayment"
5534         );
5535 
5536         //if the amount is smaller than the origination fee, just transfer the amount to the fee destination address
5537         if (vars.paybackAmount <= vars.originationFee) {
5538             core.updateStateOnRepay(
5539                 _reserve,
5540                 _onBehalfOf,
5541                 0,
5542                 vars.paybackAmount,
5543                 vars.borrowBalanceIncrease,
5544                 false
5545             );
5546 
5547             core.transferToFeeCollectionAddress.value(vars.isETH ? vars.paybackAmount : 0)(
5548                 _reserve,
5549                 _onBehalfOf,
5550                 vars.paybackAmount,
5551                 addressesProvider.getTokenDistributor()
5552             );
5553 
5554             emit Repay(
5555                 _reserve,
5556                 _onBehalfOf,
5557                 msg.sender,
5558                 0,
5559                 vars.paybackAmount,
5560                 vars.borrowBalanceIncrease,
5561                 //solium-disable-next-line
5562                 block.timestamp
5563             );
5564             return;
5565         }
5566 
5567         vars.paybackAmountMinusFees = vars.paybackAmount.sub(vars.originationFee);
5568 
5569         core.updateStateOnRepay(
5570             _reserve,
5571             _onBehalfOf,
5572             vars.paybackAmountMinusFees,
5573             vars.originationFee,
5574             vars.borrowBalanceIncrease,
5575             vars.compoundedBorrowBalance == vars.paybackAmountMinusFees
5576         );
5577 
5578         //if the user didn't repay the origination fee, transfer the fee to the fee collection address
5579         if(vars.originationFee > 0) {
5580             core.transferToFeeCollectionAddress.value(vars.isETH ? vars.originationFee : 0)(
5581                 _reserve,
5582                 _onBehalfOf,
5583                 vars.originationFee,
5584                 addressesProvider.getTokenDistributor()
5585             );
5586         }
5587 
5588         //sending the total msg.value if the transfer is ETH.
5589         //the transferToReserve() function will take care of sending the
5590         //excess ETH back to the caller
5591         core.transferToReserve.value(vars.isETH ? msg.value.sub(vars.originationFee) : 0)(
5592             _reserve,
5593             msg.sender,
5594             vars.paybackAmountMinusFees
5595         );
5596 
5597         emit Repay(
5598             _reserve,
5599             _onBehalfOf,
5600             msg.sender,
5601             vars.paybackAmountMinusFees,
5602             vars.originationFee,
5603             vars.borrowBalanceIncrease,
5604             //solium-disable-next-line
5605             block.timestamp
5606         );
5607     }
5608 
5609     /**
5610     * @dev borrowers can user this function to swap between stable and variable borrow rate modes.
5611     * @param _reserve the address of the reserve on which the user borrowed
5612     **/
5613     function swapBorrowRateMode(address _reserve)
5614         external
5615         nonReentrant
5616         onlyActiveReserve(_reserve)
5617         onlyUnfreezedReserve(_reserve)
5618     {
5619         (uint256 principalBorrowBalance, uint256 compoundedBorrowBalance, uint256 borrowBalanceIncrease) = core
5620             .getUserBorrowBalances(_reserve, msg.sender);
5621 
5622         require(
5623             compoundedBorrowBalance > 0,
5624             "User does not have a borrow in progress on this reserve"
5625         );
5626 
5627         CoreLibrary.InterestRateMode currentRateMode = core.getUserCurrentBorrowRateMode(
5628             _reserve,
5629             msg.sender
5630         );
5631 
5632         if (currentRateMode == CoreLibrary.InterestRateMode.VARIABLE) {
5633             /**
5634             * user wants to swap to stable, before swapping we need to ensure that
5635             * 1. stable borrow rate is enabled on the reserve
5636             * 2. user is not trying to abuse the reserve by depositing
5637             * more collateral than he is borrowing, artificially lowering
5638             * the interest rate, borrowing at variable, and switching to stable
5639             **/
5640             require(
5641                 core.isUserAllowedToBorrowAtStable(_reserve, msg.sender, compoundedBorrowBalance),
5642                 "User cannot borrow the selected amount at stable"
5643             );
5644         }
5645 
5646         (CoreLibrary.InterestRateMode newRateMode, uint256 newBorrowRate) = core
5647             .updateStateOnSwapRate(
5648             _reserve,
5649             msg.sender,
5650             principalBorrowBalance,
5651             compoundedBorrowBalance,
5652             borrowBalanceIncrease,
5653             currentRateMode
5654         );
5655 
5656         emit Swap(
5657             _reserve,
5658             msg.sender,
5659             uint256(newRateMode),
5660             newBorrowRate,
5661             borrowBalanceIncrease,
5662             //solium-disable-next-line
5663             block.timestamp
5664         );
5665     }
5666 
5667     /**
5668     * @dev rebalances the stable interest rate of a user if current liquidity rate > user stable rate.
5669     * this is regulated by Aave to ensure that the protocol is not abused, and the user is paying a fair
5670     * rate. Anyone can call this function though.
5671     * @param _reserve the address of the reserve
5672     * @param _user the address of the user to be rebalanced
5673     **/
5674     function rebalanceStableBorrowRate(address _reserve, address _user)
5675         external
5676         nonReentrant
5677         onlyActiveReserve(_reserve)
5678     {
5679         (, uint256 compoundedBalance, uint256 borrowBalanceIncrease) = core.getUserBorrowBalances(
5680             _reserve,
5681             _user
5682         );
5683 
5684         //step 1: user must be borrowing on _reserve at a stable rate
5685         require(compoundedBalance > 0, "User does not have any borrow for this reserve");
5686 
5687         require(
5688             core.getUserCurrentBorrowRateMode(_reserve, _user) ==
5689                 CoreLibrary.InterestRateMode.STABLE,
5690             "The user borrow is variable and cannot be rebalanced"
5691         );
5692 
5693         uint256 userCurrentStableRate = core.getUserCurrentStableBorrowRate(_reserve, _user);
5694         uint256 liquidityRate = core.getReserveCurrentLiquidityRate(_reserve);
5695         uint256 reserveCurrentStableRate = core.getReserveCurrentStableBorrowRate(_reserve);
5696         uint256 rebalanceDownRateThreshold = reserveCurrentStableRate.rayMul(
5697             WadRayMath.ray().add(parametersProvider.getRebalanceDownRateDelta())
5698         );
5699 
5700         //step 2: we have two possible situations to rebalance:
5701 
5702         //1. user stable borrow rate is below the current liquidity rate. The loan needs to be rebalanced,
5703         //as this situation can be abused (user putting back the borrowed liquidity in the same reserve to earn on it)
5704         //2. user stable rate is above the market avg borrow rate of a certain delta, and utilization rate is low.
5705         //In this case, the user is paying an interest that is too high, and needs to be rescaled down.
5706         if (
5707             userCurrentStableRate < liquidityRate ||
5708             userCurrentStableRate > rebalanceDownRateThreshold
5709         ) {
5710             uint256 newStableRate = core.updateStateOnRebalance(
5711                 _reserve,
5712                 _user,
5713                 borrowBalanceIncrease
5714             );
5715 
5716             emit RebalanceStableBorrowRate(
5717                 _reserve,
5718                 _user,
5719                 newStableRate,
5720                 borrowBalanceIncrease,
5721                 //solium-disable-next-line
5722                 block.timestamp
5723             );
5724 
5725             return;
5726 
5727         }
5728 
5729         revert("Interest rate rebalance conditions were not met");
5730     }
5731 
5732     /**
5733     * @dev allows depositors to enable or disable a specific deposit as collateral.
5734     * @param _reserve the address of the reserve
5735     * @param _useAsCollateral true if the user wants to user the deposit as collateral, false otherwise.
5736     **/
5737     function setUserUseReserveAsCollateral(address _reserve, bool _useAsCollateral)
5738         external
5739         nonReentrant
5740         onlyActiveReserve(_reserve)
5741         onlyUnfreezedReserve(_reserve)
5742     {
5743         uint256 underlyingBalance = core.getUserUnderlyingAssetBalance(_reserve, msg.sender);
5744 
5745         require(underlyingBalance > 0, "User does not have any liquidity deposited");
5746 
5747         require(
5748             dataProvider.balanceDecreaseAllowed(_reserve, msg.sender, underlyingBalance),
5749             "User deposit is already being used as collateral"
5750         );
5751 
5752         core.setUserUseReserveAsCollateral(_reserve, msg.sender, _useAsCollateral);
5753 
5754         if (_useAsCollateral) {
5755             emit ReserveUsedAsCollateralEnabled(_reserve, msg.sender);
5756         } else {
5757             emit ReserveUsedAsCollateralDisabled(_reserve, msg.sender);
5758         }
5759     }
5760 
5761     /**
5762     * @dev users can invoke this function to liquidate an undercollateralized position.
5763     * @param _reserve the address of the collateral to liquidated
5764     * @param _reserve the address of the principal reserve
5765     * @param _user the address of the borrower
5766     * @param _purchaseAmount the amount of principal that the liquidator wants to repay
5767     * @param _receiveAToken true if the liquidators wants to receive the aTokens, false if
5768     * he wants to receive the underlying asset directly
5769     **/
5770     function liquidationCall(
5771         address _collateral,
5772         address _reserve,
5773         address _user,
5774         uint256 _purchaseAmount,
5775         bool _receiveAToken
5776     ) external payable nonReentrant onlyActiveReserve(_reserve) onlyActiveReserve(_collateral) {
5777         address liquidationManager = addressesProvider.getLendingPoolLiquidationManager();
5778 
5779         //solium-disable-next-line
5780         (bool success, bytes memory result) = liquidationManager.delegatecall(
5781             abi.encodeWithSignature(
5782                 "liquidationCall(address,address,address,uint256,bool)",
5783                 _collateral,
5784                 _reserve,
5785                 _user,
5786                 _purchaseAmount,
5787                 _receiveAToken
5788             )
5789         );
5790         require(success, "Liquidation call failed");
5791 
5792         (uint256 returnCode, string memory returnMessage) = abi.decode(result, (uint256, string));
5793 
5794         if (returnCode != 0) {
5795             //error found
5796             revert(string(abi.encodePacked("Liquidation failed: ", returnMessage)));
5797         }
5798     }
5799 
5800     /**
5801     * @dev allows smartcontracts to access the liquidity of the pool within one transaction,
5802     * as long as the amount taken plus a fee is returned. NOTE There are security concerns for developers of flashloan receiver contracts
5803     * that must be kept into consideration. For further details please visit https://developers.aave.com
5804     * @param _receiver The address of the contract receiving the funds. The receiver should implement the IFlashLoanReceiver interface.
5805     * @param _reserve the address of the principal reserve
5806     * @param _amount the amount requested for this flashloan
5807     **/
5808     function flashLoan(address _receiver, address _reserve, uint256 _amount, bytes memory _params)
5809         public
5810         nonReentrant
5811         onlyActiveReserve(_reserve)
5812         onlyAmountGreaterThanZero(_amount)
5813     {
5814         //check that the reserve has enough available liquidity
5815         //we avoid using the getAvailableLiquidity() function in LendingPoolCore to save gas
5816         uint256 availableLiquidityBefore = _reserve == EthAddressLib.ethAddress()
5817             ? address(core).balance
5818             : IERC20(_reserve).balanceOf(address(core));
5819 
5820         require(
5821             availableLiquidityBefore >= _amount,
5822             "There is not enough liquidity available to borrow"
5823         );
5824 
5825         (uint256 totalFeeBips, uint256 protocolFeeBips) = parametersProvider
5826             .getFlashLoanFeesInBips();
5827         //calculate amount fee
5828         uint256 amountFee = _amount.mul(totalFeeBips).div(10000);
5829 
5830         //protocol fee is the part of the amountFee reserved for the protocol - the rest goes to depositors
5831         uint256 protocolFee = amountFee.mul(protocolFeeBips).div(10000);
5832         require(
5833             amountFee > 0 && protocolFee > 0,
5834             "The requested amount is too small for a flashLoan."
5835         );
5836 
5837         //get the FlashLoanReceiver instance
5838         IFlashLoanReceiver receiver = IFlashLoanReceiver(_receiver);
5839 
5840         address payable userPayable = address(uint160(_receiver));
5841 
5842         //transfer funds to the receiver
5843         core.transferToUser(_reserve, userPayable, _amount);
5844 
5845         //execute action of the receiver
5846         receiver.executeOperation(_reserve, _amount, amountFee, _params);
5847 
5848         //check that the actual balance of the core contract includes the returned amount
5849         uint256 availableLiquidityAfter = _reserve == EthAddressLib.ethAddress()
5850             ? address(core).balance
5851             : IERC20(_reserve).balanceOf(address(core));
5852 
5853         require(
5854             availableLiquidityAfter == availableLiquidityBefore.add(amountFee),
5855             "The actual balance of the protocol is inconsistent"
5856         );
5857 
5858         core.updateStateOnFlashLoan(
5859             _reserve,
5860             availableLiquidityBefore,
5861             amountFee.sub(protocolFee),
5862             protocolFee
5863         );
5864 
5865         //solium-disable-next-line
5866         emit FlashLoan(_receiver, _reserve, _amount, amountFee, protocolFee, block.timestamp);
5867     }
5868 
5869     /**
5870     * @dev accessory functions to fetch data from the core contract
5871     **/
5872 
5873     function getReserveConfigurationData(address _reserve)
5874         external
5875         view
5876         returns (
5877             uint256 ltv,
5878             uint256 liquidationThreshold,
5879             uint256 liquidationBonus,
5880             address interestRateStrategyAddress,
5881             bool usageAsCollateralEnabled,
5882             bool borrowingEnabled,
5883             bool stableBorrowRateEnabled,
5884             bool isActive
5885         )
5886     {
5887         return dataProvider.getReserveConfigurationData(_reserve);
5888     }
5889 
5890     function getReserveData(address _reserve)
5891         external
5892         view
5893         returns (
5894             uint256 totalLiquidity,
5895             uint256 availableLiquidity,
5896             uint256 totalBorrowsStable,
5897             uint256 totalBorrowsVariable,
5898             uint256 liquidityRate,
5899             uint256 variableBorrowRate,
5900             uint256 stableBorrowRate,
5901             uint256 averageStableBorrowRate,
5902             uint256 utilizationRate,
5903             uint256 liquidityIndex,
5904             uint256 variableBorrowIndex,
5905             address aTokenAddress,
5906             uint40 lastUpdateTimestamp
5907         )
5908     {
5909         return dataProvider.getReserveData(_reserve);
5910     }
5911 
5912     function getUserAccountData(address _user)
5913         external
5914         view
5915         returns (
5916             uint256 totalLiquidityETH,
5917             uint256 totalCollateralETH,
5918             uint256 totalBorrowsETH,
5919             uint256 totalFeesETH,
5920             uint256 availableBorrowsETH,
5921             uint256 currentLiquidationThreshold,
5922             uint256 ltv,
5923             uint256 healthFactor
5924         )
5925     {
5926         return dataProvider.getUserAccountData(_user);
5927     }
5928 
5929     function getUserReserveData(address _reserve, address _user)
5930         external
5931         view
5932         returns (
5933             uint256 currentATokenBalance,
5934             uint256 currentBorrowBalance,
5935             uint256 principalBorrowBalance,
5936             uint256 borrowRateMode,
5937             uint256 borrowRate,
5938             uint256 liquidityRate,
5939             uint256 originationFee,
5940             uint256 variableBorrowIndex,
5941             uint256 lastUpdateTimestamp,
5942             bool usageAsCollateralEnabled
5943         )
5944     {
5945         return dataProvider.getUserReserveData(_reserve, _user);
5946     }
5947 
5948     function getReserves() external view returns (address[] memory) {
5949         return core.getReserves();
5950     }
5951 
5952     /**
5953     * @dev internal function to save on code size for the onlyActiveReserve modifier
5954     **/
5955     function requireReserveActiveInternal(address _reserve) internal view {
5956         require(core.getReserveIsActive(_reserve), "Action requires an active reserve");
5957     }
5958 
5959     /**
5960     * @notice internal function to save on code size for the onlyUnfreezedReserve modifier
5961     **/
5962     function requireReserveNotFreezedInternal(address _reserve) internal view {
5963         require(!core.getReserveIsFreezed(_reserve), "Action requires an unfreezed reserve");
5964     }
5965 
5966     /**
5967     * @notice internal function to save on code size for the onlyAmountGreaterThanZero modifier
5968     **/
5969     function requireAmountGreaterThanZeroInternal(uint256 _amount) internal pure {
5970         require(_amount > 0, "Amount must be greater than 0");
5971     }
5972 }
5973 
5974 /**
5975 * @title LendingPoolLiquidationManager contract
5976 * @author Aave
5977 * @notice Implements the liquidation function.
5978 **/
5979 contract LendingPoolLiquidationManager is ReentrancyGuard, VersionedInitializable {
5980     using SafeMath for uint256;
5981     using WadRayMath for uint256;
5982     using Address for address;
5983 
5984     LendingPoolAddressesProvider public addressesProvider;
5985     LendingPoolCore core;
5986     LendingPoolDataProvider dataProvider;
5987     LendingPoolParametersProvider parametersProvider;
5988     IFeeProvider feeProvider;
5989     address ethereumAddress;
5990 
5991     uint256 constant LIQUIDATION_CLOSE_FACTOR_PERCENT = 50;
5992 
5993     /**
5994     * @dev emitted when a borrow fee is liquidated
5995     * @param _collateral the address of the collateral being liquidated
5996     * @param _reserve the address of the reserve
5997     * @param _user the address of the user being liquidated
5998     * @param _feeLiquidated the total fee liquidated
5999     * @param _liquidatedCollateralForFee the amount of collateral received by the protocol in exchange for the fee
6000     * @param _timestamp the timestamp of the action
6001     **/
6002     event OriginationFeeLiquidated(
6003         address indexed _collateral,
6004         address indexed _reserve,
6005         address indexed _user,
6006         uint256 _feeLiquidated,
6007         uint256 _liquidatedCollateralForFee,
6008         uint256 _timestamp
6009     );
6010 
6011     /**
6012     * @dev emitted when a borrower is liquidated
6013     * @param _collateral the address of the collateral being liquidated
6014     * @param _reserve the address of the reserve
6015     * @param _user the address of the user being liquidated
6016     * @param _purchaseAmount the total amount liquidated
6017     * @param _liquidatedCollateralAmount the amount of collateral being liquidated
6018     * @param _accruedBorrowInterest the amount of interest accrued by the borrower since the last action
6019     * @param _liquidator the address of the liquidator
6020     * @param _receiveAToken true if the liquidator wants to receive aTokens, false otherwise
6021     * @param _timestamp the timestamp of the action
6022     **/
6023     event LiquidationCall(
6024         address indexed _collateral,
6025         address indexed _reserve,
6026         address indexed _user,
6027         uint256 _purchaseAmount,
6028         uint256 _liquidatedCollateralAmount,
6029         uint256 _accruedBorrowInterest,
6030         address _liquidator,
6031         bool _receiveAToken,
6032         uint256 _timestamp
6033     );
6034 
6035     enum LiquidationErrors {
6036         NO_ERROR,
6037         NO_COLLATERAL_AVAILABLE,
6038         COLLATERAL_CANNOT_BE_LIQUIDATED,
6039         CURRRENCY_NOT_BORROWED,
6040         HEALTH_FACTOR_ABOVE_THRESHOLD,
6041         NOT_ENOUGH_LIQUIDITY
6042     }
6043 
6044     struct LiquidationCallLocalVars {
6045         uint256 userCollateralBalance;
6046         uint256 userCompoundedBorrowBalance;
6047         uint256 borrowBalanceIncrease;
6048         uint256 maxPrincipalAmountToLiquidate;
6049         uint256 actualAmountToLiquidate;
6050         uint256 liquidationRatio;
6051         uint256 collateralPrice;
6052         uint256 principalCurrencyPrice;
6053         uint256 maxAmountCollateralToLiquidate;
6054         uint256 originationFee;
6055         uint256 feeLiquidated;
6056         uint256 liquidatedCollateralForFee;
6057         CoreLibrary.InterestRateMode borrowRateMode;
6058         uint256 userStableRate;
6059         bool isCollateralEnabled;
6060         bool healthFactorBelowThreshold;
6061     }
6062 
6063     /**
6064     * @dev as the contract extends the VersionedInitializable contract to match the state
6065     * of the LendingPool contract, the getRevision() function is needed.
6066     */
6067     function getRevision() internal pure returns (uint256) {
6068         return 0;
6069     }
6070 
6071     /**
6072     * @dev users can invoke this function to liquidate an undercollateralized position.
6073     * @param _reserve the address of the collateral to liquidated
6074     * @param _reserve the address of the principal reserve
6075     * @param _user the address of the borrower
6076     * @param _purchaseAmount the amount of principal that the liquidator wants to repay
6077     * @param _receiveAToken true if the liquidators wants to receive the aTokens, false if
6078     * he wants to receive the underlying asset directly
6079     **/
6080     function liquidationCall(
6081         address _collateral,
6082         address _reserve,
6083         address _user,
6084         uint256 _purchaseAmount,
6085         bool _receiveAToken
6086     ) external payable returns (uint256, string memory) {
6087         // Usage of a memory struct of vars to avoid "Stack too deep" errors due to local variables
6088         LiquidationCallLocalVars memory vars;
6089 
6090         (, , , , , , , vars.healthFactorBelowThreshold) = dataProvider.calculateUserGlobalData(
6091             _user
6092         );
6093 
6094         if (!vars.healthFactorBelowThreshold) {
6095             return (
6096                 uint256(LiquidationErrors.HEALTH_FACTOR_ABOVE_THRESHOLD),
6097                 "Health factor is not below the threshold"
6098             );
6099         }
6100 
6101         vars.userCollateralBalance = core.getUserUnderlyingAssetBalance(_collateral, _user);
6102 
6103         //if _user hasn't deposited this specific collateral, nothing can be liquidated
6104         if (vars.userCollateralBalance == 0) {
6105             return (
6106                 uint256(LiquidationErrors.NO_COLLATERAL_AVAILABLE),
6107                 "Invalid collateral to liquidate"
6108             );
6109         }
6110 
6111         vars.isCollateralEnabled =
6112             core.isReserveUsageAsCollateralEnabled(_collateral) &&
6113             core.isUserUseReserveAsCollateralEnabled(_collateral, _user);
6114 
6115         //if _collateral isn't enabled as collateral by _user, it cannot be liquidated
6116         if (!vars.isCollateralEnabled) {
6117             return (
6118                 uint256(LiquidationErrors.COLLATERAL_CANNOT_BE_LIQUIDATED),
6119                 "The collateral chosen cannot be liquidated"
6120             );
6121         }
6122 
6123         //if the user hasn't borrowed the specific currency defined by _reserve, it cannot be liquidated
6124         (, vars.userCompoundedBorrowBalance, vars.borrowBalanceIncrease) = core
6125             .getUserBorrowBalances(_reserve, _user);
6126 
6127         if (vars.userCompoundedBorrowBalance == 0) {
6128             return (
6129                 uint256(LiquidationErrors.CURRRENCY_NOT_BORROWED),
6130                 "User did not borrow the specified currency"
6131             );
6132         }
6133 
6134         //all clear - calculate the max principal amount that can be liquidated
6135         vars.maxPrincipalAmountToLiquidate = vars
6136             .userCompoundedBorrowBalance
6137             .mul(LIQUIDATION_CLOSE_FACTOR_PERCENT)
6138             .div(100);
6139 
6140         vars.actualAmountToLiquidate = _purchaseAmount > vars.maxPrincipalAmountToLiquidate
6141             ? vars.maxPrincipalAmountToLiquidate
6142             : _purchaseAmount;
6143 
6144         (uint256 maxCollateralToLiquidate, uint256 principalAmountNeeded) = calculateAvailableCollateralToLiquidate(
6145             _collateral,
6146             _reserve,
6147             vars.actualAmountToLiquidate,
6148             vars.userCollateralBalance
6149         );
6150 
6151         vars.originationFee = core.getUserOriginationFee(_reserve, _user);
6152 
6153         //if there is a fee to liquidate, calculate the maximum amount of fee that can be liquidated
6154         if (vars.originationFee > 0) {
6155             (
6156                 vars.liquidatedCollateralForFee,
6157                 vars.feeLiquidated
6158             ) = calculateAvailableCollateralToLiquidate(
6159                 _collateral,
6160                 _reserve,
6161                 vars.originationFee,
6162                 vars.userCollateralBalance.sub(maxCollateralToLiquidate)
6163             );
6164         }
6165 
6166         //if principalAmountNeeded < vars.ActualAmountToLiquidate, there isn't enough
6167         //of _collateral to cover the actual amount that is being liquidated, hence we liquidate
6168         //a smaller amount
6169 
6170         if (principalAmountNeeded < vars.actualAmountToLiquidate) {
6171             vars.actualAmountToLiquidate = principalAmountNeeded;
6172         }
6173 
6174         //if liquidator reclaims the underlying asset, we make sure there is enough available collateral in the reserve
6175         if (!_receiveAToken) {
6176             uint256 currentAvailableCollateral = core.getReserveAvailableLiquidity(_collateral);
6177             if (currentAvailableCollateral < maxCollateralToLiquidate) {
6178                 return (
6179                     uint256(LiquidationErrors.NOT_ENOUGH_LIQUIDITY),
6180                     "There isn't enough liquidity available to liquidate"
6181                 );
6182             }
6183         }
6184 
6185         core.updateStateOnLiquidation(
6186             _reserve,
6187             _collateral,
6188             _user,
6189             vars.actualAmountToLiquidate,
6190             maxCollateralToLiquidate,
6191             vars.feeLiquidated,
6192             vars.liquidatedCollateralForFee,
6193             vars.borrowBalanceIncrease,
6194             _receiveAToken
6195         );
6196 
6197         AToken collateralAtoken = AToken(core.getReserveATokenAddress(_collateral));
6198 
6199         //if liquidator reclaims the aToken, he receives the equivalent atoken amount
6200         if (_receiveAToken) {
6201             collateralAtoken.transferOnLiquidation(_user, msg.sender, maxCollateralToLiquidate);
6202         } else {
6203             //otherwise receives the underlying asset
6204             //burn the equivalent amount of atoken
6205             collateralAtoken.burnOnLiquidation(_user, maxCollateralToLiquidate);
6206             core.transferToUser(_collateral, msg.sender, maxCollateralToLiquidate);
6207         }
6208 
6209         //transfers the principal currency to the pool
6210         core.transferToReserve.value(msg.value)(_reserve, msg.sender, vars.actualAmountToLiquidate);
6211 
6212         if (vars.feeLiquidated > 0) {
6213             //if there is enough collateral to liquidate the fee, first transfer burn an equivalent amount of
6214             //aTokens of the user
6215             collateralAtoken.burnOnLiquidation(_user, vars.liquidatedCollateralForFee);
6216 
6217             //then liquidate the fee by transferring it to the fee collection address
6218             core.liquidateFee(
6219                 _collateral,
6220                 vars.liquidatedCollateralForFee,
6221                 addressesProvider.getTokenDistributor()
6222             );
6223 
6224             emit OriginationFeeLiquidated(
6225                 _collateral,
6226                 _reserve,
6227                 _user,
6228                 vars.feeLiquidated,
6229                 vars.liquidatedCollateralForFee,
6230                 //solium-disable-next-line
6231                 block.timestamp
6232             );
6233 
6234         }
6235         emit LiquidationCall(
6236             _collateral,
6237             _reserve,
6238             _user,
6239             vars.actualAmountToLiquidate,
6240             maxCollateralToLiquidate,
6241             vars.borrowBalanceIncrease,
6242             msg.sender,
6243             _receiveAToken,
6244             //solium-disable-next-line
6245             block.timestamp
6246         );
6247 
6248         return (uint256(LiquidationErrors.NO_ERROR), "No errors");
6249     }
6250 
6251     struct AvailableCollateralToLiquidateLocalVars {
6252         uint256 userCompoundedBorrowBalance;
6253         uint256 liquidationBonus;
6254         uint256 collateralPrice;
6255         uint256 principalCurrencyPrice;
6256         uint256 maxAmountCollateralToLiquidate;
6257     }
6258 
6259     /**
6260     * @dev calculates how much of a specific collateral can be liquidated, given
6261     * a certain amount of principal currency. This function needs to be called after
6262     * all the checks to validate the liquidation have been performed, otherwise it might fail.
6263     * @param _collateral the collateral to be liquidated
6264     * @param _principal the principal currency to be liquidated
6265     * @param _purchaseAmount the amount of principal being liquidated
6266     * @param _userCollateralBalance the collatera balance for the specific _collateral asset of the user being liquidated
6267     * @return the maximum amount that is possible to liquidated given all the liquidation constraints (user balance, close factor) and
6268     * the purchase amount
6269     **/
6270     function calculateAvailableCollateralToLiquidate(
6271         address _collateral,
6272         address _principal,
6273         uint256 _purchaseAmount,
6274         uint256 _userCollateralBalance
6275     ) internal view returns (uint256 collateralAmount, uint256 principalAmountNeeded) {
6276         collateralAmount = 0;
6277         principalAmountNeeded = 0;
6278         IPriceOracleGetter oracle = IPriceOracleGetter(addressesProvider.getPriceOracle());
6279 
6280         // Usage of a memory struct of vars to avoid "Stack too deep" errors due to local variables
6281         AvailableCollateralToLiquidateLocalVars memory vars;
6282 
6283         vars.collateralPrice = oracle.getAssetPrice(_collateral);
6284         vars.principalCurrencyPrice = oracle.getAssetPrice(_principal);
6285         vars.liquidationBonus = core.getReserveLiquidationBonus(_collateral);
6286 
6287         //this is the maximum possible amount of the selected collateral that can be liquidated, given the
6288         //max amount of principal currency that is available for liquidation.
6289         vars.maxAmountCollateralToLiquidate = vars
6290             .principalCurrencyPrice
6291             .mul(_purchaseAmount)
6292             .div(vars.collateralPrice)
6293             .mul(vars.liquidationBonus)
6294             .div(100);
6295 
6296         if (vars.maxAmountCollateralToLiquidate > _userCollateralBalance) {
6297             collateralAmount = _userCollateralBalance;
6298             principalAmountNeeded = vars
6299                 .collateralPrice
6300                 .mul(collateralAmount)
6301                 .div(vars.principalCurrencyPrice)
6302                 .mul(100)
6303                 .div(vars.liquidationBonus);
6304         } else {
6305             collateralAmount = vars.maxAmountCollateralToLiquidate;
6306             principalAmountNeeded = _purchaseAmount;
6307         }
6308 
6309         return (collateralAmount, principalAmountNeeded);
6310     }
6311 }