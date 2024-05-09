1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.6.12;
3 
4 
5 // 
6 /**
7  * @dev Wrappers over Solidity's arithmetic operations with added overflow
8  * checks.
9  *
10  * Arithmetic operations in Solidity wrap on overflow. This can easily result
11  * in bugs, because programmers usually assume that an overflow raises an
12  * error, which is the standard behavior in high level programming languages.
13  * `SafeMath` restores this intuition by reverting the transaction when an
14  * operation overflows.
15  *
16  * Using this library instead of the unchecked operations eliminates an entire
17  * class of bugs, so it's recommended to use it always.
18  */
19 library SafeMath {
20     /**
21      * @dev Returns the addition of two unsigned integers, reverting on
22      * overflow.
23      *
24      * Counterpart to Solidity's `+` operator.
25      *
26      * Requirements:
27      *
28      * - Addition cannot overflow.
29      */
30     function add(uint256 a, uint256 b) internal pure returns (uint256) {
31         uint256 c = a + b;
32         require(c >= a, 'SafeMath: addition overflow');
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
44      *
45      * - Subtraction cannot overflow.
46      */
47     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
48         return sub(a, b, 'SafeMath: subtraction overflow');
49     }
50 
51     /**
52      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
53      * overflow (when the result is negative).
54      *
55      * Counterpart to Solidity's `-` operator.
56      *
57      * Requirements:
58      *
59      * - Subtraction cannot overflow.
60      */
61     function sub(
62         uint256 a,
63         uint256 b,
64         string memory errorMessage
65     ) internal pure returns (uint256) {
66         require(b <= a, errorMessage);
67         uint256 c = a - b;
68 
69         return c;
70     }
71 
72     /**
73      * @dev Returns the multiplication of two unsigned integers, reverting on
74      * overflow.
75      *
76      * Counterpart to Solidity's `*` operator.
77      *
78      * Requirements:
79      *
80      * - Multiplication cannot overflow.
81      */
82     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
83         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
84         // benefit is lost if 'b' is also tested.
85         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
86         if (a == 0) {
87             return 0;
88         }
89 
90         uint256 c = a * b;
91         require(c / a == b, 'SafeMath: multiplication overflow');
92 
93         return c;
94     }
95 
96     /**
97      * @dev Returns the integer division of two unsigned integers. Reverts on
98      * division by zero. The result is rounded towards zero.
99      *
100      * Counterpart to Solidity's `/` operator. Note: this function uses a
101      * `revert` opcode (which leaves remaining gas untouched) while Solidity
102      * uses an invalid opcode to revert (consuming all remaining gas).
103      *
104      * Requirements:
105      *
106      * - The divisor cannot be zero.
107      */
108     function div(uint256 a, uint256 b) internal pure returns (uint256) {
109         return div(a, b, 'SafeMath: division by zero');
110     }
111 
112     /**
113      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
114      * division by zero. The result is rounded towards zero.
115      *
116      * Counterpart to Solidity's `/` operator. Note: this function uses a
117      * `revert` opcode (which leaves remaining gas untouched) while Solidity
118      * uses an invalid opcode to revert (consuming all remaining gas).
119      *
120      * Requirements:
121      *
122      * - The divisor cannot be zero.
123      */
124     function div(
125         uint256 a,
126         uint256 b,
127         string memory errorMessage
128     ) internal pure returns (uint256) {
129         require(b > 0, errorMessage);
130         uint256 c = a / b;
131         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
132 
133         return c;
134     }
135 
136     /**
137      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
138      * Reverts when dividing by zero.
139      *
140      * Counterpart to Solidity's `%` operator. This function uses a `revert`
141      * opcode (which leaves remaining gas untouched) while Solidity uses an
142      * invalid opcode to revert (consuming all remaining gas).
143      *
144      * Requirements:
145      *
146      * - The divisor cannot be zero.
147      */
148     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
149         return mod(a, b, 'SafeMath: modulo by zero');
150     }
151 
152     /**
153      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
154      * Reverts with custom message when dividing by zero.
155      *
156      * Counterpart to Solidity's `%` operator. This function uses a `revert`
157      * opcode (which leaves remaining gas untouched) while Solidity uses an
158      * invalid opcode to revert (consuming all remaining gas).
159      *
160      * Requirements:
161      *
162      * - The divisor cannot be zero.
163      */
164     function mod(
165         uint256 a,
166         uint256 b,
167         string memory errorMessage
168     ) internal pure returns (uint256) {
169         require(b != 0, errorMessage);
170         return a % b;
171     }
172 
173     function min(uint256 x, uint256 y) internal pure returns (uint256 z) {
174         z = x < y ? x : y;
175     }
176 
177     // babylonian method (https://en.wikipedia.org/wiki/Methods_of_computing_square_roots#Babylonian_method)
178     function sqrt(uint256 y) internal pure returns (uint256 z) {
179         if (y > 3) {
180             z = y;
181             uint256 x = y / 2 + 1;
182             while (x < z) {
183                 z = x;
184                 x = (y / x + x) / 2;
185             }
186         } else if (y != 0) {
187             z = 1;
188         }
189     }
190 }
191 
192 // 
193 interface IBEP20 {
194     /**
195      * @dev Returns the amount of tokens in existence.
196      */
197     function totalSupply() external view returns (uint256);
198 
199     /**
200      * @dev Returns the token decimals.
201      */
202     function decimals() external view returns (uint8);
203 
204     /**
205      * @dev Returns the token symbol.
206      */
207     function symbol() external view returns (string memory);
208 
209     /**
210      * @dev Returns the token name.
211      */
212     function name() external view returns (string memory);
213 
214     /**
215      * @dev Returns the bep token owner.
216      */
217     function getOwner() external view returns (address);
218 
219     /**
220      * @dev Returns the amount of tokens owned by `account`.
221      */
222     function balanceOf(address account) external view returns (uint256);
223 
224     /**
225      * @dev Moves `amount` tokens from the caller's account to `recipient`.
226      *
227      * Returns a boolean value indicating whether the operation succeeded.
228      *
229      * Emits a {Transfer} event.
230      */
231     function transfer(address recipient, uint256 amount) external returns (bool);
232 
233     /**
234      * @dev Returns the remaining number of tokens that `spender` will be
235      * allowed to spend on behalf of `owner` through {transferFrom}. This is
236      * zero by default.
237      *
238      * This value changes when {approve} or {transferFrom} are called.
239      */
240     function allowance(address _owner, address spender) external view returns (uint256);
241 
242     /**
243      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
244      *
245      * Returns a boolean value indicating whether the operation succeeded.
246      *
247      * IMPORTANT: Beware that changing an allowance with this method brings the risk
248      * that someone may use both the old and the new allowance by unfortunate
249      * transaction ordering. One possible solution to mitigate this race
250      * condition is to first reduce the spender's allowance to 0 and set the
251      * desired value afterwards:
252      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
253      *
254      * Emits an {Approval} event.
255      */
256     function approve(address spender, uint256 amount) external returns (bool);
257 
258     /**
259      * @dev Moves `amount` tokens from `sender` to `recipient` using the
260      * allowance mechanism. `amount` is then deducted from the caller's
261      * allowance.
262      *
263      * Returns a boolean value indicating whether the operation succeeded.
264      *
265      * Emits a {Transfer} event.
266      */
267     function transferFrom(
268         address sender,
269         address recipient,
270         uint256 amount
271     ) external returns (bool);
272 
273     /**
274      * @dev Emitted when `value` tokens are moved from one account (`from`) to
275      * another (`to`).
276      *
277      * Note that `value` may be zero.
278      */
279     event Transfer(address indexed from, address indexed to, uint256 value);
280 
281     /**
282      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
283      * a call to {approve}. `value` is the new allowance.
284      */
285     event Approval(address indexed owner, address indexed spender, uint256 value);
286 }
287 
288 // 
289 /**
290  * @dev Collection of functions related to the address type
291  */
292 library Address {
293     /**
294      * @dev Returns true if `account` is a contract.
295      *
296      * [IMPORTANT]
297      * ====
298      * It is unsafe to assume that an address for which this function returns
299      * false is an externally-owned account (EOA) and not a contract.
300      *
301      * Among others, `isContract` will return false for the following
302      * types of addresses:
303      *
304      *  - an externally-owned account
305      *  - a contract in construction
306      *  - an address where a contract will be created
307      *  - an address where a contract lived, but was destroyed
308      * ====
309      */
310     function isContract(address account) internal view returns (bool) {
311         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
312         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
313         // for accounts without code, i.e. `keccak256('')`
314         bytes32 codehash;
315         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
316         // solhint-disable-next-line no-inline-assembly
317         assembly {
318             codehash := extcodehash(account)
319         }
320         return (codehash != accountHash && codehash != 0x0);
321     }
322 
323     /**
324      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
325      * `recipient`, forwarding all available gas and reverting on errors.
326      *
327      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
328      * of certain opcodes, possibly making contracts go over the 2300 gas limit
329      * imposed by `transfer`, making them unable to receive funds via
330      * `transfer`. {sendValue} removes this limitation.
331      *
332      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
333      *
334      * IMPORTANT: because control is transferred to `recipient`, care must be
335      * taken to not create reentrancy vulnerabilities. Consider using
336      * {ReentrancyGuard} or the
337      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
338      */
339     function sendValue(address payable recipient, uint256 amount) internal {
340         require(address(this).balance >= amount, 'Address: insufficient balance');
341 
342         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
343         (bool success, ) = recipient.call{value: amount}('');
344         require(success, 'Address: unable to send value, recipient may have reverted');
345     }
346 
347     /**
348      * @dev Performs a Solidity function call using a low level `call`. A
349      * plain`call` is an unsafe replacement for a function call: use this
350      * function instead.
351      *
352      * If `target` reverts with a revert reason, it is bubbled up by this
353      * function (like regular Solidity function calls).
354      *
355      * Returns the raw returned data. To convert to the expected return value,
356      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
357      *
358      * Requirements:
359      *
360      * - `target` must be a contract.
361      * - calling `target` with `data` must not revert.
362      *
363      * _Available since v3.1._
364      */
365     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
366         return functionCall(target, data, 'Address: low-level call failed');
367     }
368 
369     /**
370      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
371      * `errorMessage` as a fallback revert reason when `target` reverts.
372      *
373      * _Available since v3.1._
374      */
375     function functionCall(
376         address target,
377         bytes memory data,
378         string memory errorMessage
379     ) internal returns (bytes memory) {
380         return _functionCallWithValue(target, data, 0, errorMessage);
381     }
382 
383     /**
384      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
385      * but also transferring `value` wei to `target`.
386      *
387      * Requirements:
388      *
389      * - the calling contract must have an ETH balance of at least `value`.
390      * - the called Solidity function must be `payable`.
391      *
392      * _Available since v3.1._
393      */
394     function functionCallWithValue(
395         address target,
396         bytes memory data,
397         uint256 value
398     ) internal returns (bytes memory) {
399         return functionCallWithValue(target, data, value, 'Address: low-level call with value failed');
400     }
401 
402     /**
403      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
404      * with `errorMessage` as a fallback revert reason when `target` reverts.
405      *
406      * _Available since v3.1._
407      */
408     function functionCallWithValue(
409         address target,
410         bytes memory data,
411         uint256 value,
412         string memory errorMessage
413     ) internal returns (bytes memory) {
414         require(address(this).balance >= value, 'Address: insufficient balance for call');
415         return _functionCallWithValue(target, data, value, errorMessage);
416     }
417 
418     function _functionCallWithValue(
419         address target,
420         bytes memory data,
421         uint256 weiValue,
422         string memory errorMessage
423     ) private returns (bytes memory) {
424         require(isContract(target), 'Address: call to non-contract');
425 
426         // solhint-disable-next-line avoid-low-level-calls
427         (bool success, bytes memory returndata) = target.call{value: weiValue}(data);
428         if (success) {
429             return returndata;
430         } else {
431             // Look for revert reason and bubble it up if present
432             if (returndata.length > 0) {
433                 // The easiest way to bubble the revert reason is using memory via assembly
434 
435                 // solhint-disable-next-line no-inline-assembly
436                 assembly {
437                     let returndata_size := mload(returndata)
438                     revert(add(32, returndata), returndata_size)
439                 }
440             } else {
441                 revert(errorMessage);
442             }
443         }
444     }
445 }
446 
447 // 
448 /**
449  * @title SafeBEP20
450  * @dev Wrappers around BEP20 operations that throw on failure (when the token
451  * contract returns false). Tokens that return no value (and instead revert or
452  * throw on failure) are also supported, non-reverting calls are assumed to be
453  * successful.
454  * To use this library you can add a `using SafeBEP20 for IBEP20;` statement to your contract,
455  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
456  */
457 library SafeBEP20 {
458     using SafeMath for uint256;
459     using Address for address;
460 
461     function safeTransfer(
462         IBEP20 token,
463         address to,
464         uint256 value
465     ) internal {
466         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
467     }
468 
469     function safeTransferFrom(
470         IBEP20 token,
471         address from,
472         address to,
473         uint256 value
474     ) internal {
475         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
476     }
477 
478     /**
479      * @dev Deprecated. This function has issues similar to the ones found in
480      * {IBEP20-approve}, and its usage is discouraged.
481      *
482      * Whenever possible, use {safeIncreaseAllowance} and
483      * {safeDecreaseAllowance} instead.
484      */
485     function safeApprove(
486         IBEP20 token,
487         address spender,
488         uint256 value
489     ) internal {
490         // safeApprove should only be called when setting an initial allowance,
491         // or when resetting it to zero. To increase and decrease it, use
492         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
493         // solhint-disable-next-line max-line-length
494         require(
495             (value == 0) || (token.allowance(address(this), spender) == 0),
496             'SafeBEP20: approve from non-zero to non-zero allowance'
497         );
498         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
499     }
500 
501     function safeIncreaseAllowance(
502         IBEP20 token,
503         address spender,
504         uint256 value
505     ) internal {
506         uint256 newAllowance = token.allowance(address(this), spender).add(value);
507         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
508     }
509 
510     function safeDecreaseAllowance(
511         IBEP20 token,
512         address spender,
513         uint256 value
514     ) internal {
515         uint256 newAllowance = token.allowance(address(this), spender).sub(
516             value,
517             'SafeBEP20: decreased allowance below zero'
518         );
519         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
520     }
521 
522     /**
523      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
524      * on the return value: the return value is optional (but if data is returned, it must not be false).
525      * @param token The token targeted by the call.
526      * @param data The call data (encoded using abi.encode or one of its variants).
527      */
528     function _callOptionalReturn(IBEP20 token, bytes memory data) private {
529         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
530         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
531         // the target address contains contract code and also asserts for success in the low-level call.
532 
533         bytes memory returndata = address(token).functionCall(data, 'SafeBEP20: low-level call failed');
534         if (returndata.length > 0) {
535             // Return data is optional
536             // solhint-disable-next-line max-line-length
537             require(abi.decode(returndata, (bool)), 'SafeBEP20: BEP20 operation did not succeed');
538         }
539     }
540 }
541 
542 // 
543 /*
544  * @dev Provides information about the current execution context, including the
545  * sender of the transaction and its data. While these are generally available
546  * via msg.sender and msg.data, they should not be accessed in such a direct
547  * manner, since when dealing with GSN meta-transactions the account sending and
548  * paying for execution may not be the actual sender (as far as an application
549  * is concerned).
550  *
551  * This contract is only required for intermediate, library-like contracts.
552  */
553 contract Context {
554     // Empty internal constructor, to prevent people from mistakenly deploying
555     // an instance of this contract, which should be used via inheritance.
556     constructor() internal {}
557 
558     function _msgSender() internal view returns (address payable) {
559         return msg.sender;
560     }
561 
562     function _msgData() internal view returns (bytes memory) {
563         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
564         return msg.data;
565     }
566 }
567 
568 // 
569 /**
570  * @dev Contract module which provides a basic access control mechanism, where
571  * there is an account (an owner) that can be granted exclusive access to
572  * specific functions.
573  *
574  * By default, the owner account will be the one that deploys the contract. This
575  * can later be changed with {transferOwnership}.
576  *
577  * This module is used through inheritance. It will make available the modifier
578  * `onlyOwner`, which can be applied to your functions to restrict their use to
579  * the owner.
580  */
581 contract Ownable is Context {
582     address private _owner;
583 
584     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
585 
586     /**
587      * @dev Initializes the contract setting the deployer as the initial owner.
588      */
589     constructor() internal {
590         address msgSender = _msgSender();
591         _owner = msgSender;
592         emit OwnershipTransferred(address(0), msgSender);
593     }
594 
595     /**
596      * @dev Returns the address of the current owner.
597      */
598     function owner() public view returns (address) {
599         return _owner;
600     }
601 
602     /**
603      * @dev Throws if called by any account other than the owner.
604      */
605     modifier onlyOwner() {
606         require(_owner == _msgSender(), 'Ownable: caller is not the owner');
607         _;
608     }
609 
610     /**
611      * @dev Leaves the contract without owner. It will not be possible to call
612      * `onlyOwner` functions anymore. Can only be called by the current owner.
613      *
614      * NOTE: Renouncing ownership will leave the contract without an owner,
615      * thereby removing any functionality that is only available to the owner.
616      */
617     function renounceOwnership() public onlyOwner {
618         emit OwnershipTransferred(_owner, address(0));
619         _owner = address(0);
620     }
621 
622     /**
623      * @dev Transfers ownership of the contract to a new account (`newOwner`).
624      * Can only be called by the current owner.
625      */
626     function transferOwnership(address newOwner) public onlyOwner {
627         _transferOwnership(newOwner);
628     }
629 
630     /**
631      * @dev Transfers ownership of the contract to a new account (`newOwner`).
632      */
633     function _transferOwnership(address newOwner) internal {
634         require(newOwner != address(0), 'Ownable: new owner is the zero address');
635         emit OwnershipTransferred(_owner, newOwner);
636         _owner = newOwner;
637     }
638 }
639 
640 // 
641 /**
642  * @dev Implementation of the {IBEP20} interface.
643  *
644  * This implementation is agnostic to the way tokens are created. This means
645  * that a supply mechanism has to be added in a derived contract using {_mint}.
646  * For a generic mechanism see {BEP20PresetMinterPauser}.
647  *
648  * TIP: For a detailed writeup see our guide
649  * https://forum.zeppelin.solutions/t/how-to-implement-BEP20-supply-mechanisms/226[How
650  * to implement supply mechanisms].
651  *
652  * We have followed general OpenZeppelin guidelines: functions revert instead
653  * of returning `false` on failure. This behavior is nonetheless conventional
654  * and does not conflict with the expectations of BEP20 applications.
655  *
656  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
657  * This allows applications to reconstruct the allowance for all accounts just
658  * by listening to said events. Other implementations of the EIP may not emit
659  * these events, as it isn't required by the specification.
660  *
661  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
662  * functions have been added to mitigate the well-known issues around setting
663  * allowances. See {IBEP20-approve}.
664  */
665 contract BEP20 is Context, IBEP20, Ownable {
666     using SafeMath for uint256;
667     using Address for address;
668 
669     mapping(address => uint256) private _balances;
670 
671     mapping(address => mapping(address => uint256)) private _allowances;
672 
673     uint256 private _totalSupply;
674 
675     string private _name;
676     string private _symbol;
677     uint8 private _decimals;
678 
679     /**
680      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
681      * a default value of 18.
682      *
683      * To select a different value for {decimals}, use {_setupDecimals}.
684      *
685      * All three of these values are immutable: they can only be set once during
686      * construction.
687      */
688     constructor(string memory name, string memory symbol) public {
689         _name = name;
690         _symbol = symbol;
691         _decimals = 18;
692     }
693 
694     /**
695      * @dev Returns the bep token owner.
696      */
697     function getOwner() external override view returns (address) {
698         return owner();
699     }
700 
701     /**
702      * @dev Returns the token name.
703      */
704     function name() public override view returns (string memory) {
705         return _name;
706     }
707 
708     /**
709      * @dev Returns the token decimals.
710      */
711     function decimals() public override view returns (uint8) {
712         return _decimals;
713     }
714 
715     /**
716      * @dev Returns the token symbol.
717      */
718     function symbol() public override view returns (string memory) {
719         return _symbol;
720     }
721 
722     /**
723      * @dev See {BEP20-totalSupply}.
724      */
725     function totalSupply() public override view returns (uint256) {
726         return _totalSupply;
727     }
728 
729     /**
730      * @dev See {BEP20-balanceOf}.
731      */
732     function balanceOf(address account) public override view returns (uint256) {
733         return _balances[account];
734     }
735 
736     /**
737      * @dev See {BEP20-transfer}.
738      *
739      * Requirements:
740      *
741      * - `recipient` cannot be the zero address.
742      * - the caller must have a balance of at least `amount`.
743      */
744     function transfer(address recipient, uint256 amount) public override returns (bool) {
745         _transfer(_msgSender(), recipient, amount);
746         return true;
747     }
748 
749     /**
750      * @dev See {BEP20-allowance}.
751      */
752     function allowance(address owner, address spender) public override view returns (uint256) {
753         return _allowances[owner][spender];
754     }
755 
756     /**
757      * @dev See {BEP20-approve}.
758      *
759      * Requirements:
760      *
761      * - `spender` cannot be the zero address.
762      */
763     function approve(address spender, uint256 amount) public override returns (bool) {
764         _approve(_msgSender(), spender, amount);
765         return true;
766     }
767 
768     /**
769      * @dev See {BEP20-transferFrom}.
770      *
771      * Emits an {Approval} event indicating the updated allowance. This is not
772      * required by the EIP. See the note at the beginning of {BEP20};
773      *
774      * Requirements:
775      * - `sender` and `recipient` cannot be the zero address.
776      * - `sender` must have a balance of at least `amount`.
777      * - the caller must have allowance for `sender`'s tokens of at least
778      * `amount`.
779      */
780     function transferFrom(
781         address sender,
782         address recipient,
783         uint256 amount
784     ) public override returns (bool) {
785         _transfer(sender, recipient, amount);
786         _approve(
787             sender,
788             _msgSender(),
789             _allowances[sender][_msgSender()].sub(amount, 'BEP20: transfer amount exceeds allowance')
790         );
791         return true;
792     }
793 
794     /**
795      * @dev Atomically increases the allowance granted to `spender` by the caller.
796      *
797      * This is an alternative to {approve} that can be used as a mitigation for
798      * problems described in {BEP20-approve}.
799      *
800      * Emits an {Approval} event indicating the updated allowance.
801      *
802      * Requirements:
803      *
804      * - `spender` cannot be the zero address.
805      */
806     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
807         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
808         return true;
809     }
810 
811     /**
812      * @dev Atomically decreases the allowance granted to `spender` by the caller.
813      *
814      * This is an alternative to {approve} that can be used as a mitigation for
815      * problems described in {BEP20-approve}.
816      *
817      * Emits an {Approval} event indicating the updated allowance.
818      *
819      * Requirements:
820      *
821      * - `spender` cannot be the zero address.
822      * - `spender` must have allowance for the caller of at least
823      * `subtractedValue`.
824      */
825     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
826         _approve(
827             _msgSender(),
828             spender,
829             _allowances[_msgSender()][spender].sub(subtractedValue, 'BEP20: decreased allowance below zero')
830         );
831         return true;
832     }
833 
834     /**
835      * @dev Creates `amount` tokens and assigns them to `msg.sender`, increasing
836      * the total supply.
837      *
838      * Requirements
839      *
840      * - `msg.sender` must be the token owner
841      */
842     function mint(uint256 amount) public onlyOwner returns (bool) {
843         _mint(_msgSender(), amount);
844         return true;
845     }
846 
847     /**
848      * @dev Moves tokens `amount` from `sender` to `recipient`.
849      *
850      * This is internal function is equivalent to {transfer}, and can be used to
851      * e.g. implement automatic token fees, slashing mechanisms, etc.
852      *
853      * Emits a {Transfer} event.
854      *
855      * Requirements:
856      *
857      * - `sender` cannot be the zero address.
858      * - `recipient` cannot be the zero address.
859      * - `sender` must have a balance of at least `amount`.
860      */
861     function _transfer(
862         address sender,
863         address recipient,
864         uint256 amount
865     ) internal {
866         require(sender != address(0), 'BEP20: transfer from the zero address');
867         require(recipient != address(0), 'BEP20: transfer to the zero address');
868 
869         _balances[sender] = _balances[sender].sub(amount, 'BEP20: transfer amount exceeds balance');
870         _balances[recipient] = _balances[recipient].add(amount);
871         emit Transfer(sender, recipient, amount);
872     }
873 
874     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
875      * the total supply.
876      *
877      * Emits a {Transfer} event with `from` set to the zero address.
878      *
879      * Requirements
880      *
881      * - `to` cannot be the zero address.
882      */
883     function _mint(address account, uint256 amount) internal {
884         require(account != address(0), 'BEP20: mint to the zero address');
885 
886         _totalSupply = _totalSupply.add(amount);
887         _balances[account] = _balances[account].add(amount);
888         emit Transfer(address(0), account, amount);
889     }
890 
891     /**
892      * @dev Destroys `amount` tokens from `account`, reducing the
893      * total supply.
894      *
895      * Emits a {Transfer} event with `to` set to the zero address.
896      *
897      * Requirements
898      *
899      * - `account` cannot be the zero address.
900      * - `account` must have at least `amount` tokens.
901      */
902     function _burn(address account, uint256 amount) internal {
903         require(account != address(0), 'BEP20: burn from the zero address');
904 
905         _balances[account] = _balances[account].sub(amount, 'BEP20: burn amount exceeds balance');
906         _totalSupply = _totalSupply.sub(amount);
907         emit Transfer(account, address(0), amount);
908     }
909 
910     /**
911      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
912      *
913      * This is internal function is equivalent to `approve`, and can be used to
914      * e.g. set automatic allowances for certain subsystems, etc.
915      *
916      * Emits an {Approval} event.
917      *
918      * Requirements:
919      *
920      * - `owner` cannot be the zero address.
921      * - `spender` cannot be the zero address.
922      */
923     function _approve(
924         address owner,
925         address spender,
926         uint256 amount
927     ) internal {
928         require(owner != address(0), 'BEP20: approve from the zero address');
929         require(spender != address(0), 'BEP20: approve to the zero address');
930 
931         _allowances[owner][spender] = amount;
932         emit Approval(owner, spender, amount);
933     }
934 
935     /**
936      * @dev Destroys `amount` tokens from `account`.`amount` is then deducted
937      * from the caller's allowance.
938      *
939      * See {_burn} and {_approve}.
940      */
941     function _burnFrom(address account, uint256 amount) internal {
942         _burn(account, amount);
943         _approve(
944             account,
945             _msgSender(),
946             _allowances[account][_msgSender()].sub(amount, 'BEP20: burn amount exceeds allowance')
947         );
948     }
949 }
950 
951 // CakeToken with Governance.
952 contract CakeToken is BEP20('PancakeSwap Token', 'Cake') {
953     /// @notice Creates `_amount` token to `_to`. Must only be called by the owner (MasterChef).
954     function mint(address _to, uint256 _amount) public onlyOwner {
955         _mint(_to, _amount);
956         _moveDelegates(address(0), _delegates[_to], _amount);
957     }
958 
959     // Copied and modified from YAM code:
960     // https://github.com/yam-finance/yam-protocol/blob/master/contracts/token/YAMGovernanceStorage.sol
961     // https://github.com/yam-finance/yam-protocol/blob/master/contracts/token/YAMGovernance.sol
962     // Which is copied and modified from COMPOUND:
963     // https://github.com/compound-finance/compound-protocol/blob/master/contracts/Governance/Comp.sol
964 
965     mapping (address => address) internal _delegates;
966 
967     /// @notice A checkpoint for marking number of votes from a given block
968     struct Checkpoint {
969         uint32 fromBlock;
970         uint256 votes;
971     }
972 
973     /// @notice A record of votes checkpoints for each account, by index
974     mapping (address => mapping (uint32 => Checkpoint)) public checkpoints;
975 
976     /// @notice The number of checkpoints for each account
977     mapping (address => uint32) public numCheckpoints;
978 
979     /// @notice The EIP-712 typehash for the contract's domain
980     bytes32 public constant DOMAIN_TYPEHASH = keccak256("EIP712Domain(string name,uint256 chainId,address verifyingContract)");
981 
982     /// @notice The EIP-712 typehash for the delegation struct used by the contract
983     bytes32 public constant DELEGATION_TYPEHASH = keccak256("Delegation(address delegatee,uint256 nonce,uint256 expiry)");
984 
985     /// @notice A record of states for signing / validating signatures
986     mapping (address => uint) public nonces;
987 
988       /// @notice An event thats emitted when an account changes its delegate
989     event DelegateChanged(address indexed delegator, address indexed fromDelegate, address indexed toDelegate);
990 
991     /// @notice An event thats emitted when a delegate account's vote balance changes
992     event DelegateVotesChanged(address indexed delegate, uint previousBalance, uint newBalance);
993 
994     /**
995      * @notice Delegate votes from `msg.sender` to `delegatee`
996      * @param delegator The address to get delegatee for
997      */
998     function delegates(address delegator)
999         external
1000         view
1001         returns (address)
1002     {
1003         return _delegates[delegator];
1004     }
1005 
1006    /**
1007     * @notice Delegate votes from `msg.sender` to `delegatee`
1008     * @param delegatee The address to delegate votes to
1009     */
1010     function delegate(address delegatee) external {
1011         return _delegate(msg.sender, delegatee);
1012     }
1013 
1014     /**
1015      * @notice Delegates votes from signatory to `delegatee`
1016      * @param delegatee The address to delegate votes to
1017      * @param nonce The contract state required to match the signature
1018      * @param expiry The time at which to expire the signature
1019      * @param v The recovery byte of the signature
1020      * @param r Half of the ECDSA signature pair
1021      * @param s Half of the ECDSA signature pair
1022      */
1023     function delegateBySig(
1024         address delegatee,
1025         uint nonce,
1026         uint expiry,
1027         uint8 v,
1028         bytes32 r,
1029         bytes32 s
1030     )
1031         external
1032     {
1033         bytes32 domainSeparator = keccak256(
1034             abi.encode(
1035                 DOMAIN_TYPEHASH,
1036                 keccak256(bytes(name())),
1037                 getChainId(),
1038                 address(this)
1039             )
1040         );
1041 
1042         bytes32 structHash = keccak256(
1043             abi.encode(
1044                 DELEGATION_TYPEHASH,
1045                 delegatee,
1046                 nonce,
1047                 expiry
1048             )
1049         );
1050 
1051         bytes32 digest = keccak256(
1052             abi.encodePacked(
1053                 "\x19\x01",
1054                 domainSeparator,
1055                 structHash
1056             )
1057         );
1058 
1059         address signatory = ecrecover(digest, v, r, s);
1060         require(signatory != address(0), "CAKE::delegateBySig: invalid signature");
1061         require(nonce == nonces[signatory]++, "CAKE::delegateBySig: invalid nonce");
1062         require(now <= expiry, "CAKE::delegateBySig: signature expired");
1063         return _delegate(signatory, delegatee);
1064     }
1065 
1066     /**
1067      * @notice Gets the current votes balance for `account`
1068      * @param account The address to get votes balance
1069      * @return The number of current votes for `account`
1070      */
1071     function getCurrentVotes(address account)
1072         external
1073         view
1074         returns (uint256)
1075     {
1076         uint32 nCheckpoints = numCheckpoints[account];
1077         return nCheckpoints > 0 ? checkpoints[account][nCheckpoints - 1].votes : 0;
1078     }
1079 
1080     /**
1081      * @notice Determine the prior number of votes for an account as of a block number
1082      * @dev Block number must be a finalized block or else this function will revert to prevent misinformation.
1083      * @param account The address of the account to check
1084      * @param blockNumber The block number to get the vote balance at
1085      * @return The number of votes the account had as of the given block
1086      */
1087     function getPriorVotes(address account, uint blockNumber)
1088         external
1089         view
1090         returns (uint256)
1091     {
1092         require(blockNumber < block.number, "CAKE::getPriorVotes: not yet determined");
1093 
1094         uint32 nCheckpoints = numCheckpoints[account];
1095         if (nCheckpoints == 0) {
1096             return 0;
1097         }
1098 
1099         // First check most recent balance
1100         if (checkpoints[account][nCheckpoints - 1].fromBlock <= blockNumber) {
1101             return checkpoints[account][nCheckpoints - 1].votes;
1102         }
1103 
1104         // Next check implicit zero balance
1105         if (checkpoints[account][0].fromBlock > blockNumber) {
1106             return 0;
1107         }
1108 
1109         uint32 lower = 0;
1110         uint32 upper = nCheckpoints - 1;
1111         while (upper > lower) {
1112             uint32 center = upper - (upper - lower) / 2; // ceil, avoiding overflow
1113             Checkpoint memory cp = checkpoints[account][center];
1114             if (cp.fromBlock == blockNumber) {
1115                 return cp.votes;
1116             } else if (cp.fromBlock < blockNumber) {
1117                 lower = center;
1118             } else {
1119                 upper = center - 1;
1120             }
1121         }
1122         return checkpoints[account][lower].votes;
1123     }
1124 
1125     function _delegate(address delegator, address delegatee)
1126         internal
1127     {
1128         address currentDelegate = _delegates[delegator];
1129         uint256 delegatorBalance = balanceOf(delegator); // balance of underlying CAKEs (not scaled);
1130         _delegates[delegator] = delegatee;
1131 
1132         emit DelegateChanged(delegator, currentDelegate, delegatee);
1133 
1134         _moveDelegates(currentDelegate, delegatee, delegatorBalance);
1135     }
1136 
1137     function _moveDelegates(address srcRep, address dstRep, uint256 amount) internal {
1138         if (srcRep != dstRep && amount > 0) {
1139             if (srcRep != address(0)) {
1140                 // decrease old representative
1141                 uint32 srcRepNum = numCheckpoints[srcRep];
1142                 uint256 srcRepOld = srcRepNum > 0 ? checkpoints[srcRep][srcRepNum - 1].votes : 0;
1143                 uint256 srcRepNew = srcRepOld.sub(amount);
1144                 _writeCheckpoint(srcRep, srcRepNum, srcRepOld, srcRepNew);
1145             }
1146 
1147             if (dstRep != address(0)) {
1148                 // increase new representative
1149                 uint32 dstRepNum = numCheckpoints[dstRep];
1150                 uint256 dstRepOld = dstRepNum > 0 ? checkpoints[dstRep][dstRepNum - 1].votes : 0;
1151                 uint256 dstRepNew = dstRepOld.add(amount);
1152                 _writeCheckpoint(dstRep, dstRepNum, dstRepOld, dstRepNew);
1153             }
1154         }
1155     }
1156 
1157     function _writeCheckpoint(
1158         address delegatee,
1159         uint32 nCheckpoints,
1160         uint256 oldVotes,
1161         uint256 newVotes
1162     )
1163         internal
1164     {
1165         uint32 blockNumber = safe32(block.number, "CAKE::_writeCheckpoint: block number exceeds 32 bits");
1166 
1167         if (nCheckpoints > 0 && checkpoints[delegatee][nCheckpoints - 1].fromBlock == blockNumber) {
1168             checkpoints[delegatee][nCheckpoints - 1].votes = newVotes;
1169         } else {
1170             checkpoints[delegatee][nCheckpoints] = Checkpoint(blockNumber, newVotes);
1171             numCheckpoints[delegatee] = nCheckpoints + 1;
1172         }
1173 
1174         emit DelegateVotesChanged(delegatee, oldVotes, newVotes);
1175     }
1176 
1177     function safe32(uint n, string memory errorMessage) internal pure returns (uint32) {
1178         require(n < 2**32, errorMessage);
1179         return uint32(n);
1180     }
1181 
1182     function getChainId() internal pure returns (uint) {
1183         uint256 chainId;
1184         assembly { chainId := chainid() }
1185         return chainId;
1186     }
1187 }
1188 
1189 // SyrupBar with Governance.
1190 contract SyrupBar is BEP20('SyrupBar Token', 'SYRUP') {
1191     /// @notice Creates `_amount` token to `_to`. Must only be called by the owner (MasterChef).
1192     function mint(address _to, uint256 _amount) public onlyOwner {
1193         _mint(_to, _amount);
1194         _moveDelegates(address(0), _delegates[_to], _amount);
1195     }
1196 
1197     function burn(address _from ,uint256 _amount) public onlyOwner {
1198         _burn(_from, _amount);
1199         _moveDelegates(address(0), _delegates[_from], _amount);
1200     }
1201 
1202     // The CAKE TOKEN!
1203     CakeToken public cake;
1204 
1205 
1206     constructor(
1207         CakeToken _cake
1208     ) public {
1209         cake = _cake;
1210     }
1211 
1212     // Safe cake transfer function, just in case if rounding error causes pool to not have enough CAKEs.
1213     function safeCakeTransfer(address _to, uint256 _amount) public onlyOwner {
1214         uint256 cakeBal = cake.balanceOf(address(this));
1215         if (_amount > cakeBal) {
1216             cake.transfer(_to, cakeBal);
1217         } else {
1218             cake.transfer(_to, _amount);
1219         }
1220     }
1221 
1222     // Copied and modified from YAM code:
1223     // https://github.com/yam-finance/yam-protocol/blob/master/contracts/token/YAMGovernanceStorage.sol
1224     // https://github.com/yam-finance/yam-protocol/blob/master/contracts/token/YAMGovernance.sol
1225     // Which is copied and modified from COMPOUND:
1226     // https://github.com/compound-finance/compound-protocol/blob/master/contracts/Governance/Comp.sol
1227 
1228     mapping (address => address) internal _delegates;
1229 
1230     /// @notice A checkpoint for marking number of votes from a given block
1231     struct Checkpoint {
1232         uint32 fromBlock;
1233         uint256 votes;
1234     }
1235 
1236     /// @notice A record of votes checkpoints for each account, by index
1237     mapping (address => mapping (uint32 => Checkpoint)) public checkpoints;
1238 
1239     /// @notice The number of checkpoints for each account
1240     mapping (address => uint32) public numCheckpoints;
1241 
1242     /// @notice The EIP-712 typehash for the contract's domain
1243     bytes32 public constant DOMAIN_TYPEHASH = keccak256("EIP712Domain(string name,uint256 chainId,address verifyingContract)");
1244 
1245     /// @notice The EIP-712 typehash for the delegation struct used by the contract
1246     bytes32 public constant DELEGATION_TYPEHASH = keccak256("Delegation(address delegatee,uint256 nonce,uint256 expiry)");
1247 
1248     /// @notice A record of states for signing / validating signatures
1249     mapping (address => uint) public nonces;
1250 
1251       /// @notice An event thats emitted when an account changes its delegate
1252     event DelegateChanged(address indexed delegator, address indexed fromDelegate, address indexed toDelegate);
1253 
1254     /// @notice An event thats emitted when a delegate account's vote balance changes
1255     event DelegateVotesChanged(address indexed delegate, uint previousBalance, uint newBalance);
1256 
1257     /**
1258      * @notice Delegate votes from `msg.sender` to `delegatee`
1259      * @param delegator The address to get delegatee for
1260      */
1261     function delegates(address delegator)
1262         external
1263         view
1264         returns (address)
1265     {
1266         return _delegates[delegator];
1267     }
1268 
1269    /**
1270     * @notice Delegate votes from `msg.sender` to `delegatee`
1271     * @param delegatee The address to delegate votes to
1272     */
1273     function delegate(address delegatee) external {
1274         return _delegate(msg.sender, delegatee);
1275     }
1276 
1277     /**
1278      * @notice Delegates votes from signatory to `delegatee`
1279      * @param delegatee The address to delegate votes to
1280      * @param nonce The contract state required to match the signature
1281      * @param expiry The time at which to expire the signature
1282      * @param v The recovery byte of the signature
1283      * @param r Half of the ECDSA signature pair
1284      * @param s Half of the ECDSA signature pair
1285      */
1286     function delegateBySig(
1287         address delegatee,
1288         uint nonce,
1289         uint expiry,
1290         uint8 v,
1291         bytes32 r,
1292         bytes32 s
1293     )
1294         external
1295     {
1296         bytes32 domainSeparator = keccak256(
1297             abi.encode(
1298                 DOMAIN_TYPEHASH,
1299                 keccak256(bytes(name())),
1300                 getChainId(),
1301                 address(this)
1302             )
1303         );
1304 
1305         bytes32 structHash = keccak256(
1306             abi.encode(
1307                 DELEGATION_TYPEHASH,
1308                 delegatee,
1309                 nonce,
1310                 expiry
1311             )
1312         );
1313 
1314         bytes32 digest = keccak256(
1315             abi.encodePacked(
1316                 "\x19\x01",
1317                 domainSeparator,
1318                 structHash
1319             )
1320         );
1321 
1322         address signatory = ecrecover(digest, v, r, s);
1323         require(signatory != address(0), "CAKE::delegateBySig: invalid signature");
1324         require(nonce == nonces[signatory]++, "CAKE::delegateBySig: invalid nonce");
1325         require(now <= expiry, "CAKE::delegateBySig: signature expired");
1326         return _delegate(signatory, delegatee);
1327     }
1328 
1329     /**
1330      * @notice Gets the current votes balance for `account`
1331      * @param account The address to get votes balance
1332      * @return The number of current votes for `account`
1333      */
1334     function getCurrentVotes(address account)
1335         external
1336         view
1337         returns (uint256)
1338     {
1339         uint32 nCheckpoints = numCheckpoints[account];
1340         return nCheckpoints > 0 ? checkpoints[account][nCheckpoints - 1].votes : 0;
1341     }
1342 
1343     /**
1344      * @notice Determine the prior number of votes for an account as of a block number
1345      * @dev Block number must be a finalized block or else this function will revert to prevent misinformation.
1346      * @param account The address of the account to check
1347      * @param blockNumber The block number to get the vote balance at
1348      * @return The number of votes the account had as of the given block
1349      */
1350     function getPriorVotes(address account, uint blockNumber)
1351         external
1352         view
1353         returns (uint256)
1354     {
1355         require(blockNumber < block.number, "CAKE::getPriorVotes: not yet determined");
1356 
1357         uint32 nCheckpoints = numCheckpoints[account];
1358         if (nCheckpoints == 0) {
1359             return 0;
1360         }
1361 
1362         // First check most recent balance
1363         if (checkpoints[account][nCheckpoints - 1].fromBlock <= blockNumber) {
1364             return checkpoints[account][nCheckpoints - 1].votes;
1365         }
1366 
1367         // Next check implicit zero balance
1368         if (checkpoints[account][0].fromBlock > blockNumber) {
1369             return 0;
1370         }
1371 
1372         uint32 lower = 0;
1373         uint32 upper = nCheckpoints - 1;
1374         while (upper > lower) {
1375             uint32 center = upper - (upper - lower) / 2; // ceil, avoiding overflow
1376             Checkpoint memory cp = checkpoints[account][center];
1377             if (cp.fromBlock == blockNumber) {
1378                 return cp.votes;
1379             } else if (cp.fromBlock < blockNumber) {
1380                 lower = center;
1381             } else {
1382                 upper = center - 1;
1383             }
1384         }
1385         return checkpoints[account][lower].votes;
1386     }
1387 
1388     function _delegate(address delegator, address delegatee)
1389         internal
1390     {
1391         address currentDelegate = _delegates[delegator];
1392         uint256 delegatorBalance = balanceOf(delegator); // balance of underlying CAKEs (not scaled);
1393         _delegates[delegator] = delegatee;
1394 
1395         emit DelegateChanged(delegator, currentDelegate, delegatee);
1396 
1397         _moveDelegates(currentDelegate, delegatee, delegatorBalance);
1398     }
1399 
1400     function _moveDelegates(address srcRep, address dstRep, uint256 amount) internal {
1401         if (srcRep != dstRep && amount > 0) {
1402             if (srcRep != address(0)) {
1403                 // decrease old representative
1404                 uint32 srcRepNum = numCheckpoints[srcRep];
1405                 uint256 srcRepOld = srcRepNum > 0 ? checkpoints[srcRep][srcRepNum - 1].votes : 0;
1406                 uint256 srcRepNew = srcRepOld.sub(amount);
1407                 _writeCheckpoint(srcRep, srcRepNum, srcRepOld, srcRepNew);
1408             }
1409 
1410             if (dstRep != address(0)) {
1411                 // increase new representative
1412                 uint32 dstRepNum = numCheckpoints[dstRep];
1413                 uint256 dstRepOld = dstRepNum > 0 ? checkpoints[dstRep][dstRepNum - 1].votes : 0;
1414                 uint256 dstRepNew = dstRepOld.add(amount);
1415                 _writeCheckpoint(dstRep, dstRepNum, dstRepOld, dstRepNew);
1416             }
1417         }
1418     }
1419 
1420     function _writeCheckpoint(
1421         address delegatee,
1422         uint32 nCheckpoints,
1423         uint256 oldVotes,
1424         uint256 newVotes
1425     )
1426         internal
1427     {
1428         uint32 blockNumber = safe32(block.number, "CAKE::_writeCheckpoint: block number exceeds 32 bits");
1429 
1430         if (nCheckpoints > 0 && checkpoints[delegatee][nCheckpoints - 1].fromBlock == blockNumber) {
1431             checkpoints[delegatee][nCheckpoints - 1].votes = newVotes;
1432         } else {
1433             checkpoints[delegatee][nCheckpoints] = Checkpoint(blockNumber, newVotes);
1434             numCheckpoints[delegatee] = nCheckpoints + 1;
1435         }
1436 
1437         emit DelegateVotesChanged(delegatee, oldVotes, newVotes);
1438     }
1439 
1440     function safe32(uint n, string memory errorMessage) internal pure returns (uint32) {
1441         require(n < 2**32, errorMessage);
1442         return uint32(n);
1443     }
1444 
1445     function getChainId() internal pure returns (uint) {
1446         uint256 chainId;
1447         assembly { chainId := chainid() }
1448         return chainId;
1449     }
1450 }
1451 
1452 // import "@nomiclabs/buidler/console.sol";
1453 interface IMigratorChef {
1454     // Perform LP token migration from legacy PancakeSwap to CakeSwap.
1455     // Take the current LP token address and return the new LP token address.
1456     // Migrator should have full access to the caller's LP token.
1457     // Return the new LP token address.
1458     //
1459     // XXX Migrator must have allowance access to PancakeSwap LP tokens.
1460     // CakeSwap must mint EXACTLY the same amount of CakeSwap LP tokens or
1461     // else something bad will happen. Traditional PancakeSwap does not
1462     // do that so be careful!
1463     function migrate(IBEP20 token) external returns (IBEP20);
1464 }
1465 
1466 // MasterChef is the master of Cake. He can make Cake and he is a fair guy.
1467 //
1468 // Note that it's ownable and the owner wields tremendous power. The ownership
1469 // will be transferred to a governance smart contract once CAKE is sufficiently
1470 // distributed and the community can show to govern itself.
1471 //
1472 // Have fun reading it. Hopefully it's bug-free. God bless.
1473 contract MasterChef is Ownable {
1474     using SafeMath for uint256;
1475     using SafeBEP20 for IBEP20;
1476 
1477     // Info of each user.
1478     struct UserInfo {
1479         uint256 amount;     // How many LP tokens the user has provided.
1480         uint256 rewardDebt; // Reward debt. See explanation below.
1481         //
1482         // We do some fancy math here. Basically, any point in time, the amount of CAKEs
1483         // entitled to a user but is pending to be distributed is:
1484         //
1485         //   pending reward = (user.amount * pool.accCakePerShare) - user.rewardDebt
1486         //
1487         // Whenever a user deposits or withdraws LP tokens to a pool. Here's what happens:
1488         //   1. The pool's `accCakePerShare` (and `lastRewardBlock`) gets updated.
1489         //   2. User receives the pending reward sent to his/her address.
1490         //   3. User's `amount` gets updated.
1491         //   4. User's `rewardDebt` gets updated.
1492     }
1493 
1494     // Info of each pool.
1495     struct PoolInfo {
1496         IBEP20 lpToken;           // Address of LP token contract.
1497         uint256 allocPoint;       // How many allocation points assigned to this pool. CAKEs to distribute per block.
1498         uint256 lastRewardBlock;  // Last block number that CAKEs distribution occurs.
1499         uint256 accCakePerShare; // Accumulated CAKEs per share, times 1e12. See below.
1500         uint256 harvestFee;
1501     }
1502 
1503     // The CAKE TOKEN!
1504     CakeToken public cake;
1505     // The SYRUP TOKEN!
1506     SyrupBar public syrup;
1507     // Dev address.
1508     address public devaddr;
1509     // Fee address.
1510     address public feeaddr;
1511     // CAKE tokens created per block.
1512     uint256 public cakePerBlock;
1513     // Bonus muliplier for early cake makers.
1514     uint256 public BONUS_MULTIPLIER = 1;
1515     // The migrator contract. It has a lot of power. Can only be set through governance (owner).
1516     IMigratorChef public migrator;
1517 
1518     // Info of each pool.
1519     PoolInfo[] public poolInfo;
1520     // Info of each user that stakes LP tokens.
1521     mapping (uint256 => mapping (address => UserInfo)) public userInfo;
1522     // Total allocation poitns. Must be the sum of all allocation points in all pools.
1523     uint256 public totalAllocPoint = 0;
1524     // The block number when CAKE mining starts.
1525     uint256 public startBlock;
1526 
1527     event Deposit(address indexed user, uint256 indexed pid, uint256 amount);
1528     event Withdraw(address indexed user, uint256 indexed pid, uint256 amount);
1529     event EmergencyWithdraw(address indexed user, uint256 indexed pid, uint256 amount);
1530 
1531     constructor(
1532         CakeToken _cake,
1533         SyrupBar _syrup,
1534         address _devaddr,
1535         address _feeaddr,
1536         uint256 _cakePerBlock,
1537         uint256 _startBlock
1538     ) public {
1539         cake = _cake;
1540         syrup = _syrup;
1541         devaddr = _devaddr;
1542         feeaddr = _feeaddr;
1543         cakePerBlock = _cakePerBlock;
1544         startBlock = _startBlock;
1545 
1546         // staking pool
1547         poolInfo.push(PoolInfo({
1548             lpToken: _cake,
1549             allocPoint: 1000,
1550             lastRewardBlock: startBlock,
1551             accCakePerShare: 0,
1552             harvestFee: 200
1553         }));
1554 
1555         totalAllocPoint = 1000;
1556 
1557     }
1558 
1559     function updateMultiplier(uint256 multiplierNumber) public onlyOwner {
1560         BONUS_MULTIPLIER = multiplierNumber;
1561     }
1562 
1563     function updateEmissionRate(uint256 _cakePerBlock) public onlyOwner {
1564         cakePerBlock = _cakePerBlock;
1565     }
1566 
1567     function poolLength() external view returns (uint256) {
1568         return poolInfo.length;
1569     }
1570 
1571     // Add a new lp to the pool. Can only be called by the owner.
1572     // XXX DO NOT add the same LP token more than once. Rewards will be messed up if you do.
1573     function add(uint256 _allocPoint, IBEP20 _lpToken, bool _withUpdate, uint256 _harvestFee) public onlyOwner {
1574         if (_withUpdate) {
1575             massUpdatePools();
1576         }
1577         uint256 lastRewardBlock = block.number > startBlock ? block.number : startBlock;
1578         totalAllocPoint = totalAllocPoint.add(_allocPoint);
1579         poolInfo.push(PoolInfo({
1580             lpToken: _lpToken,
1581             allocPoint: _allocPoint,
1582             lastRewardBlock: lastRewardBlock,
1583             accCakePerShare: 0,
1584             harvestFee: _harvestFee
1585         }));
1586         updateStakingPool();
1587     }
1588 
1589     // Update the given pool's CAKE allocation point. Can only be called by the owner.
1590     function set(uint256 _pid, uint256 _allocPoint, bool _withUpdate) public onlyOwner {
1591         if (_withUpdate) {
1592             massUpdatePools();
1593         }
1594         totalAllocPoint = totalAllocPoint.sub(poolInfo[_pid].allocPoint).add(_allocPoint);
1595         uint256 prevAllocPoint = poolInfo[_pid].allocPoint;
1596         poolInfo[_pid].allocPoint = _allocPoint;
1597         if (prevAllocPoint != _allocPoint) {
1598             updateStakingPool();
1599         }
1600     }
1601 
1602     function updateStakingPool() internal {
1603         uint256 length = poolInfo.length;
1604         uint256 points = 0;
1605         for (uint256 pid = 1; pid < length; ++pid) {
1606             points = points.add(poolInfo[pid].allocPoint);
1607         }
1608         if (points != 0) {
1609             points = points.div(3);
1610             totalAllocPoint = totalAllocPoint.sub(poolInfo[0].allocPoint).add(points);
1611             poolInfo[0].allocPoint = points;
1612         }
1613     }
1614 
1615     // Set the migrator contract. Can only be called by the owner.
1616     function setMigrator(IMigratorChef _migrator) public onlyOwner {
1617         migrator = _migrator;
1618     }
1619 
1620     // Set the migrator contract. Can only be called by the owner.
1621     function setFeeAddress(address _feeaddr) public onlyOwner {
1622         feeaddr = _feeaddr;
1623     }
1624 
1625     // Migrate lp token to another lp contract. Can be called by anyone. We trust that migrator contract is good.
1626     function migrate(uint256 _pid) public {
1627         require(address(migrator) != address(0), "migrate: no migrator");
1628         PoolInfo storage pool = poolInfo[_pid];
1629         IBEP20 lpToken = pool.lpToken;
1630         uint256 bal = lpToken.balanceOf(address(this));
1631         lpToken.safeApprove(address(migrator), bal);
1632         IBEP20 newLpToken = migrator.migrate(lpToken);
1633         require(bal == newLpToken.balanceOf(address(this)), "migrate: bad");
1634         pool.lpToken = newLpToken;
1635     }
1636 
1637     // Return reward multiplier over the given _from to _to block.
1638     function getMultiplier(uint256 _from, uint256 _to) public view returns (uint256) {
1639         return _to.sub(_from).mul(BONUS_MULTIPLIER);
1640     }
1641 
1642     // View function to see pending CAKEs on frontend.
1643     function pendingCake(uint256 _pid, address _user) external view returns (uint256) {
1644         PoolInfo storage pool = poolInfo[_pid];
1645         UserInfo storage user = userInfo[_pid][_user];
1646         uint256 accCakePerShare = pool.accCakePerShare;
1647         uint256 lpSupply = pool.lpToken.balanceOf(address(this));
1648         if (block.number > pool.lastRewardBlock && lpSupply != 0) {
1649             uint256 multiplier = getMultiplier(pool.lastRewardBlock, block.number);
1650             uint256 cakeReward = multiplier.mul(cakePerBlock).mul(pool.allocPoint).div(totalAllocPoint);
1651             accCakePerShare = accCakePerShare.add(cakeReward.mul(1e12).div(lpSupply));
1652         }
1653         return user.amount.mul(accCakePerShare).div(1e12).sub(user.rewardDebt);
1654     }
1655 
1656     // Update reward variables for all pools. Be careful of gas spending!
1657     function massUpdatePools() public {
1658         uint256 length = poolInfo.length;
1659         for (uint256 pid = 0; pid < length; ++pid) {
1660             updatePool(pid);
1661         }
1662     }
1663 
1664 
1665     // Update reward variables of the given pool to be up-to-date.
1666     function updatePool(uint256 _pid) public {
1667         PoolInfo storage pool = poolInfo[_pid];
1668         if (block.number <= pool.lastRewardBlock) {
1669             return;
1670         }
1671         uint256 lpSupply = pool.lpToken.balanceOf(address(this));
1672         if (lpSupply == 0) {
1673             pool.lastRewardBlock = block.number;
1674             return;
1675         }
1676         uint256 multiplier = getMultiplier(pool.lastRewardBlock, block.number);
1677         uint256 cakeReward = multiplier.mul(cakePerBlock).mul(pool.allocPoint).div(totalAllocPoint);
1678         cake.mint(devaddr, cakeReward.div(10));
1679         cake.mint(address(syrup), cakeReward);
1680         pool.accCakePerShare = pool.accCakePerShare.add(cakeReward.mul(1e12).div(lpSupply));
1681         pool.lastRewardBlock = block.number;
1682     }
1683 
1684     // Deposit LP tokens to MasterChef for CAKE allocation.
1685     function deposit(uint256 _pid, uint256 _amount) public {
1686 
1687         require (_pid != 0, 'deposit CAKE by staking');
1688 
1689         PoolInfo storage pool = poolInfo[_pid];
1690         UserInfo storage user = userInfo[_pid][msg.sender];
1691         updatePool(_pid);
1692         if (user.amount > 0) {
1693             uint256 pending = user.amount.mul(pool.accCakePerShare).div(1e12).sub(user.rewardDebt);
1694             if(pending > 0) {
1695                 uint256 fee = pending.mul(pool.harvestFee).div(10000);
1696                 safeCakeTransfer(feeaddr, fee);
1697                 safeCakeTransfer(msg.sender, pending.sub(fee));
1698             }
1699         }
1700         if (_amount > 0) {
1701             pool.lpToken.safeTransferFrom(address(msg.sender), address(this), _amount);
1702             user.amount = user.amount.add(_amount);
1703         }
1704         user.rewardDebt = user.amount.mul(pool.accCakePerShare).div(1e12);
1705         emit Deposit(msg.sender, _pid, _amount);
1706     }
1707 
1708     // Withdraw LP tokens from MasterChef.
1709     function withdraw(uint256 _pid, uint256 _amount) public {
1710 
1711         require (_pid != 0, 'withdraw CAKE by unstaking');
1712 
1713         PoolInfo storage pool = poolInfo[_pid];
1714         UserInfo storage user = userInfo[_pid][msg.sender];
1715         require(user.amount >= _amount, "withdraw: not good");
1716         updatePool(_pid);
1717         uint256 pending = user.amount.mul(pool.accCakePerShare).div(1e12).sub(user.rewardDebt);
1718         if(pending > 0) {
1719             uint256 fee = pending.mul(pool.harvestFee).div(10000);
1720             safeCakeTransfer(feeaddr, fee);
1721             safeCakeTransfer(msg.sender, pending.sub(fee));
1722         }
1723         if(_amount > 0) {
1724             user.amount = user.amount.sub(_amount);
1725             pool.lpToken.safeTransfer(address(msg.sender), _amount);
1726         }
1727         user.rewardDebt = user.amount.mul(pool.accCakePerShare).div(1e12);
1728         emit Withdraw(msg.sender, _pid, _amount);
1729     }
1730 
1731     // Stake CAKE tokens to MasterChef
1732     function enterStaking(uint256 _amount) public {
1733         PoolInfo storage pool = poolInfo[0];
1734         UserInfo storage user = userInfo[0][msg.sender];
1735         updatePool(0);
1736         if (user.amount > 0) {
1737             uint256 pending = user.amount.mul(pool.accCakePerShare).div(1e12).sub(user.rewardDebt);
1738             if(pending > 0) {
1739                 uint256 fee = pending.mul(pool.harvestFee).div(10000);
1740                 safeCakeTransfer(feeaddr, fee);
1741                 safeCakeTransfer(msg.sender, pending.sub(fee));
1742             }
1743         }
1744         if(_amount > 0) {
1745             pool.lpToken.safeTransferFrom(address(msg.sender), address(this), _amount);
1746             user.amount = user.amount.add(_amount);
1747         }
1748         user.rewardDebt = user.amount.mul(pool.accCakePerShare).div(1e12);
1749 
1750         syrup.mint(msg.sender, _amount);
1751         emit Deposit(msg.sender, 0, _amount);
1752     }
1753 
1754     // Withdraw CAKE tokens from STAKING.
1755     function leaveStaking(uint256 _amount) public {
1756         PoolInfo storage pool = poolInfo[0];
1757         UserInfo storage user = userInfo[0][msg.sender];
1758         require(user.amount >= _amount, "withdraw: not good");
1759         updatePool(0);
1760         uint256 pending = user.amount.mul(pool.accCakePerShare).div(1e12).sub(user.rewardDebt);
1761         if(pending > 0) {
1762             uint256 fee = pending.mul(pool.harvestFee).div(10000);
1763             safeCakeTransfer(feeaddr, fee);
1764             safeCakeTransfer(msg.sender, pending.sub(fee));
1765         }
1766         if(_amount > 0) {
1767             user.amount = user.amount.sub(_amount);
1768             pool.lpToken.safeTransfer(address(msg.sender), _amount);
1769         }
1770         user.rewardDebt = user.amount.mul(pool.accCakePerShare).div(1e12);
1771 
1772         syrup.burn(msg.sender, _amount);
1773         emit Withdraw(msg.sender, 0, _amount);
1774     }
1775 
1776     // Withdraw without caring about rewards. EMERGENCY ONLY.
1777     function emergencyWithdraw(uint256 _pid) public {
1778         PoolInfo storage pool = poolInfo[_pid];
1779         UserInfo storage user = userInfo[_pid][msg.sender];
1780         pool.lpToken.safeTransfer(address(msg.sender), user.amount);
1781         emit EmergencyWithdraw(msg.sender, _pid, user.amount);
1782         user.amount = 0;
1783         user.rewardDebt = 0;
1784     }
1785 
1786     // Safe cake transfer function, just in case if rounding error causes pool to not have enough CAKEs.
1787     function safeCakeTransfer(address _to, uint256 _amount) internal {
1788         syrup.safeCakeTransfer(_to, _amount);
1789     }
1790 
1791     // Update dev address by the previous dev.
1792     function dev(address _devaddr) public {
1793         require(msg.sender == devaddr, "dev: wut?");
1794         devaddr = _devaddr;
1795     }
1796 }