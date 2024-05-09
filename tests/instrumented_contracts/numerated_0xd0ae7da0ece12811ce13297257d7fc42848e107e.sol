1 // Sources flattened with hardhat v2.3.0 https://hardhat.org
2 
3 // File @openzeppelin/contracts/token/ERC20/IERC20.sol@v4.1.0
4 
5 // SPDX-License-Identifier: MIT AND UNLICENSED
6 
7 pragma solidity ^0.8.0;
8 
9 /**
10  * @dev Interface of the ERC20 standard as defined in the EIP.
11  */
12 interface IERC20 {
13     /**
14      * @dev Returns the amount of tokens in existence.
15      */
16     function totalSupply() external view returns (uint256);
17 
18     /**
19      * @dev Returns the amount of tokens owned by `account`.
20      */
21     function balanceOf(address account) external view returns (uint256);
22 
23     /**
24      * @dev Moves `amount` tokens from the caller's account to `recipient`.
25      *
26      * Returns a boolean value indicating whether the operation succeeded.
27      *
28      * Emits a {Transfer} event.
29      */
30     function transfer(address recipient, uint256 amount) external returns (bool);
31 
32     /**
33      * @dev Returns the remaining number of tokens that `spender` will be
34      * allowed to spend on behalf of `owner` through {transferFrom}. This is
35      * zero by default.
36      *
37      * This value changes when {approve} or {transferFrom} are called.
38      */
39     function allowance(address owner, address spender) external view returns (uint256);
40 
41     /**
42      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
43      *
44      * Returns a boolean value indicating whether the operation succeeded.
45      *
46      * IMPORTANT: Beware that changing an allowance with this method brings the risk
47      * that someone may use both the old and the new allowance by unfortunate
48      * transaction ordering. One possible solution to mitigate this race
49      * condition is to first reduce the spender's allowance to 0 and set the
50      * desired value afterwards:
51      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
52      *
53      * Emits an {Approval} event.
54      */
55     function approve(address spender, uint256 amount) external returns (bool);
56 
57     /**
58      * @dev Moves `amount` tokens from `sender` to `recipient` using the
59      * allowance mechanism. `amount` is then deducted from the caller's
60      * allowance.
61      *
62      * Returns a boolean value indicating whether the operation succeeded.
63      *
64      * Emits a {Transfer} event.
65      */
66     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
67 
68     /**
69      * @dev Emitted when `value` tokens are moved from one account (`from`) to
70      * another (`to`).
71      *
72      * Note that `value` may be zero.
73      */
74     event Transfer(address indexed from, address indexed to, uint256 value);
75 
76     /**
77      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
78      * a call to {approve}. `value` is the new allowance.
79      */
80     event Approval(address indexed owner, address indexed spender, uint256 value);
81 }
82 
83 
84 // File @openzeppelin/contracts/utils/Address.sol@v4.1.0
85 
86 
87 pragma solidity ^0.8.0;
88 
89 /**
90  * @dev Collection of functions related to the address type
91  */
92 library Address {
93     /**
94      * @dev Returns true if `account` is a contract.
95      *
96      * [IMPORTANT]
97      * ====
98      * It is unsafe to assume that an address for which this function returns
99      * false is an externally-owned account (EOA) and not a contract.
100      *
101      * Among others, `isContract` will return false for the following
102      * types of addresses:
103      *
104      *  - an externally-owned account
105      *  - a contract in construction
106      *  - an address where a contract will be created
107      *  - an address where a contract lived, but was destroyed
108      * ====
109      */
110     function isContract(address account) internal view returns (bool) {
111         // This method relies on extcodesize, which returns 0 for contracts in
112         // construction, since the code is only stored at the end of the
113         // constructor execution.
114 
115         uint256 size;
116         // solhint-disable-next-line no-inline-assembly
117         assembly { size := extcodesize(account) }
118         return size > 0;
119     }
120 
121     /**
122      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
123      * `recipient`, forwarding all available gas and reverting on errors.
124      *
125      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
126      * of certain opcodes, possibly making contracts go over the 2300 gas limit
127      * imposed by `transfer`, making them unable to receive funds via
128      * `transfer`. {sendValue} removes this limitation.
129      *
130      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
131      *
132      * IMPORTANT: because control is transferred to `recipient`, care must be
133      * taken to not create reentrancy vulnerabilities. Consider using
134      * {ReentrancyGuard} or the
135      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
136      */
137     function sendValue(address payable recipient, uint256 amount) internal {
138         require(address(this).balance >= amount, "Address: insufficient balance");
139 
140         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
141         (bool success, ) = recipient.call{ value: amount }("");
142         require(success, "Address: unable to send value, recipient may have reverted");
143     }
144 
145     /**
146      * @dev Performs a Solidity function call using a low level `call`. A
147      * plain`call` is an unsafe replacement for a function call: use this
148      * function instead.
149      *
150      * If `target` reverts with a revert reason, it is bubbled up by this
151      * function (like regular Solidity function calls).
152      *
153      * Returns the raw returned data. To convert to the expected return value,
154      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
155      *
156      * Requirements:
157      *
158      * - `target` must be a contract.
159      * - calling `target` with `data` must not revert.
160      *
161      * _Available since v3.1._
162      */
163     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
164       return functionCall(target, data, "Address: low-level call failed");
165     }
166 
167     /**
168      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
169      * `errorMessage` as a fallback revert reason when `target` reverts.
170      *
171      * _Available since v3.1._
172      */
173     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
174         return functionCallWithValue(target, data, 0, errorMessage);
175     }
176 
177     /**
178      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
179      * but also transferring `value` wei to `target`.
180      *
181      * Requirements:
182      *
183      * - the calling contract must have an ETH balance of at least `value`.
184      * - the called Solidity function must be `payable`.
185      *
186      * _Available since v3.1._
187      */
188     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
189         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
190     }
191 
192     /**
193      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
194      * with `errorMessage` as a fallback revert reason when `target` reverts.
195      *
196      * _Available since v3.1._
197      */
198     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
199         require(address(this).balance >= value, "Address: insufficient balance for call");
200         require(isContract(target), "Address: call to non-contract");
201 
202         // solhint-disable-next-line avoid-low-level-calls
203         (bool success, bytes memory returndata) = target.call{ value: value }(data);
204         return _verifyCallResult(success, returndata, errorMessage);
205     }
206 
207     /**
208      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
209      * but performing a static call.
210      *
211      * _Available since v3.3._
212      */
213     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
214         return functionStaticCall(target, data, "Address: low-level static call failed");
215     }
216 
217     /**
218      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
219      * but performing a static call.
220      *
221      * _Available since v3.3._
222      */
223     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
224         require(isContract(target), "Address: static call to non-contract");
225 
226         // solhint-disable-next-line avoid-low-level-calls
227         (bool success, bytes memory returndata) = target.staticcall(data);
228         return _verifyCallResult(success, returndata, errorMessage);
229     }
230 
231     /**
232      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
233      * but performing a delegate call.
234      *
235      * _Available since v3.4._
236      */
237     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
238         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
239     }
240 
241     /**
242      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
243      * but performing a delegate call.
244      *
245      * _Available since v3.4._
246      */
247     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
248         require(isContract(target), "Address: delegate call to non-contract");
249 
250         // solhint-disable-next-line avoid-low-level-calls
251         (bool success, bytes memory returndata) = target.delegatecall(data);
252         return _verifyCallResult(success, returndata, errorMessage);
253     }
254 
255     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
256         if (success) {
257             return returndata;
258         } else {
259             // Look for revert reason and bubble it up if present
260             if (returndata.length > 0) {
261                 // The easiest way to bubble the revert reason is using memory via assembly
262 
263                 // solhint-disable-next-line no-inline-assembly
264                 assembly {
265                     let returndata_size := mload(returndata)
266                     revert(add(32, returndata), returndata_size)
267                 }
268             } else {
269                 revert(errorMessage);
270             }
271         }
272     }
273 }
274 
275 
276 // File @openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol@v4.1.0
277 
278 
279 pragma solidity ^0.8.0;
280 
281 
282 /**
283  * @title SafeERC20
284  * @dev Wrappers around ERC20 operations that throw on failure (when the token
285  * contract returns false). Tokens that return no value (and instead revert or
286  * throw on failure) are also supported, non-reverting calls are assumed to be
287  * successful.
288  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
289  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
290  */
291 library SafeERC20 {
292     using Address for address;
293 
294     function safeTransfer(IERC20 token, address to, uint256 value) internal {
295         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
296     }
297 
298     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
299         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
300     }
301 
302     /**
303      * @dev Deprecated. This function has issues similar to the ones found in
304      * {IERC20-approve}, and its usage is discouraged.
305      *
306      * Whenever possible, use {safeIncreaseAllowance} and
307      * {safeDecreaseAllowance} instead.
308      */
309     function safeApprove(IERC20 token, address spender, uint256 value) internal {
310         // safeApprove should only be called when setting an initial allowance,
311         // or when resetting it to zero. To increase and decrease it, use
312         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
313         // solhint-disable-next-line max-line-length
314         require((value == 0) || (token.allowance(address(this), spender) == 0),
315             "SafeERC20: approve from non-zero to non-zero allowance"
316         );
317         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
318     }
319 
320     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
321         uint256 newAllowance = token.allowance(address(this), spender) + value;
322         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
323     }
324 
325     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
326         unchecked {
327             uint256 oldAllowance = token.allowance(address(this), spender);
328             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
329             uint256 newAllowance = oldAllowance - value;
330             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
331         }
332     }
333 
334     /**
335      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
336      * on the return value: the return value is optional (but if data is returned, it must not be false).
337      * @param token The token targeted by the call.
338      * @param data The call data (encoded using abi.encode or one of its variants).
339      */
340     function _callOptionalReturn(IERC20 token, bytes memory data) private {
341         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
342         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
343         // the target address contains contract code and also asserts for success in the low-level call.
344 
345         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
346         if (returndata.length > 0) { // Return data is optional
347             // solhint-disable-next-line max-line-length
348             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
349         }
350     }
351 }
352 
353 
354 // File @openzeppelin/contracts/utils/Context.sol@v4.1.0
355 
356 
357 pragma solidity ^0.8.0;
358 
359 /*
360  * @dev Provides information about the current execution context, including the
361  * sender of the transaction and its data. While these are generally available
362  * via msg.sender and msg.data, they should not be accessed in such a direct
363  * manner, since when dealing with meta-transactions the account sending and
364  * paying for execution may not be the actual sender (as far as an application
365  * is concerned).
366  *
367  * This contract is only required for intermediate, library-like contracts.
368  */
369 abstract contract Context {
370     function _msgSender() internal view virtual returns (address) {
371         return msg.sender;
372     }
373 
374     function _msgData() internal view virtual returns (bytes calldata) {
375         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
376         return msg.data;
377     }
378 }
379 
380 
381 // File @openzeppelin/contracts/access/Ownable.sol@v4.1.0
382 
383 
384 pragma solidity ^0.8.0;
385 
386 /**
387  * @dev Contract module which provides a basic access control mechanism, where
388  * there is an account (an owner) that can be granted exclusive access to
389  * specific functions.
390  *
391  * By default, the owner account will be the one that deploys the contract. This
392  * can later be changed with {transferOwnership}.
393  *
394  * This module is used through inheritance. It will make available the modifier
395  * `onlyOwner`, which can be applied to your functions to restrict their use to
396  * the owner.
397  */
398 abstract contract Ownable is Context {
399     address private _owner;
400 
401     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
402 
403     /**
404      * @dev Initializes the contract setting the deployer as the initial owner.
405      */
406     constructor () {
407         address msgSender = _msgSender();
408         _owner = msgSender;
409         emit OwnershipTransferred(address(0), msgSender);
410     }
411 
412     /**
413      * @dev Returns the address of the current owner.
414      */
415     function owner() public view virtual returns (address) {
416         return _owner;
417     }
418 
419     /**
420      * @dev Throws if called by any account other than the owner.
421      */
422     modifier onlyOwner() {
423         require(owner() == _msgSender(), "Ownable: caller is not the owner");
424         _;
425     }
426 
427     /**
428      * @dev Leaves the contract without owner. It will not be possible to call
429      * `onlyOwner` functions anymore. Can only be called by the current owner.
430      *
431      * NOTE: Renouncing ownership will leave the contract without an owner,
432      * thereby removing any functionality that is only available to the owner.
433      */
434     function renounceOwnership() public virtual onlyOwner {
435         emit OwnershipTransferred(_owner, address(0));
436         _owner = address(0);
437     }
438 
439     /**
440      * @dev Transfers ownership of the contract to a new account (`newOwner`).
441      * Can only be called by the current owner.
442      */
443     function transferOwnership(address newOwner) public virtual onlyOwner {
444         require(newOwner != address(0), "Ownable: new owner is the zero address");
445         emit OwnershipTransferred(_owner, newOwner);
446         _owner = newOwner;
447     }
448 }
449 
450 
451 // File contracts/Custodian.sol
452 
453 pragma solidity ^0.8.4;
454 contract Custodian is Ownable {
455     using SafeERC20 for IERC20;
456 
457     event Withdraw(address indexed account, uint256 amount);
458 
459     mapping(address => bool) private _authorized;
460 
461     modifier validAddress(address addr){
462         require(addr != address(0), "Zero address");
463         _;
464     }
465 
466     function withdrawTo(address token, address recipient, uint256 amount) public validAddress(token) validAddress(recipient) {
467         require(_authorized[msg.sender], "Not authorized");
468         IERC20(token).safeTransfer(recipient, amount);
469         emit Withdraw(recipient, amount);
470     }
471 
472     function withdraw(address token, uint256 amount) external {
473         withdrawTo(token, msg.sender, amount);
474     }
475 
476     function addAuthorized(address addr) external onlyOwner validAddress(addr) {
477         require(!_authorized[addr], "Already authorized");
478         _authorized[addr] = true;
479     }
480 
481     function removeAuthorized(address addr) external onlyOwner validAddress(addr) {
482         require(_authorized[addr], "Already de-authorized");
483         _authorized[addr] = false;
484     }
485 
486     function isAuthorized(address addr) external view validAddress(addr) returns (bool) {
487         return _authorized[addr];
488     }
489 }
490 
491 
492 // File @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol@v4.1.0
493 
494 
495 pragma solidity ^0.8.0;
496 
497 /**
498  * @dev Interface for the optional metadata functions from the ERC20 standard.
499  *
500  * _Available since v4.1._
501  */
502 interface IERC20Metadata is IERC20 {
503     /**
504      * @dev Returns the name of the token.
505      */
506     function name() external view returns (string memory);
507 
508     /**
509      * @dev Returns the symbol of the token.
510      */
511     function symbol() external view returns (string memory);
512 
513     /**
514      * @dev Returns the decimals places of the token.
515      */
516     function decimals() external view returns (uint8);
517 }
518 
519 
520 // File @openzeppelin/contracts/token/ERC20/ERC20.sol@v4.1.0
521 
522 
523 pragma solidity ^0.8.0;
524 
525 
526 
527 /**
528  * @dev Implementation of the {IERC20} interface.
529  *
530  * This implementation is agnostic to the way tokens are created. This means
531  * that a supply mechanism has to be added in a derived contract using {_mint}.
532  * For a generic mechanism see {ERC20PresetMinterPauser}.
533  *
534  * TIP: For a detailed writeup see our guide
535  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
536  * to implement supply mechanisms].
537  *
538  * We have followed general OpenZeppelin guidelines: functions revert instead
539  * of returning `false` on failure. This behavior is nonetheless conventional
540  * and does not conflict with the expectations of ERC20 applications.
541  *
542  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
543  * This allows applications to reconstruct the allowance for all accounts just
544  * by listening to said events. Other implementations of the EIP may not emit
545  * these events, as it isn't required by the specification.
546  *
547  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
548  * functions have been added to mitigate the well-known issues around setting
549  * allowances. See {IERC20-approve}.
550  */
551 contract ERC20 is Context, IERC20, IERC20Metadata {
552     mapping (address => uint256) private _balances;
553 
554     mapping (address => mapping (address => uint256)) private _allowances;
555 
556     uint256 private _totalSupply;
557 
558     string private _name;
559     string private _symbol;
560 
561     /**
562      * @dev Sets the values for {name} and {symbol}.
563      *
564      * The defaut value of {decimals} is 18. To select a different value for
565      * {decimals} you should overload it.
566      *
567      * All two of these values are immutable: they can only be set once during
568      * construction.
569      */
570     constructor (string memory name_, string memory symbol_) {
571         _name = name_;
572         _symbol = symbol_;
573     }
574 
575     /**
576      * @dev Returns the name of the token.
577      */
578     function name() public view virtual override returns (string memory) {
579         return _name;
580     }
581 
582     /**
583      * @dev Returns the symbol of the token, usually a shorter version of the
584      * name.
585      */
586     function symbol() public view virtual override returns (string memory) {
587         return _symbol;
588     }
589 
590     /**
591      * @dev Returns the number of decimals used to get its user representation.
592      * For example, if `decimals` equals `2`, a balance of `505` tokens should
593      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
594      *
595      * Tokens usually opt for a value of 18, imitating the relationship between
596      * Ether and Wei. This is the value {ERC20} uses, unless this function is
597      * overridden;
598      *
599      * NOTE: This information is only used for _display_ purposes: it in
600      * no way affects any of the arithmetic of the contract, including
601      * {IERC20-balanceOf} and {IERC20-transfer}.
602      */
603     function decimals() public view virtual override returns (uint8) {
604         return 18;
605     }
606 
607     /**
608      * @dev See {IERC20-totalSupply}.
609      */
610     function totalSupply() public view virtual override returns (uint256) {
611         return _totalSupply;
612     }
613 
614     /**
615      * @dev See {IERC20-balanceOf}.
616      */
617     function balanceOf(address account) public view virtual override returns (uint256) {
618         return _balances[account];
619     }
620 
621     /**
622      * @dev See {IERC20-transfer}.
623      *
624      * Requirements:
625      *
626      * - `recipient` cannot be the zero address.
627      * - the caller must have a balance of at least `amount`.
628      */
629     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
630         _transfer(_msgSender(), recipient, amount);
631         return true;
632     }
633 
634     /**
635      * @dev See {IERC20-allowance}.
636      */
637     function allowance(address owner, address spender) public view virtual override returns (uint256) {
638         return _allowances[owner][spender];
639     }
640 
641     /**
642      * @dev See {IERC20-approve}.
643      *
644      * Requirements:
645      *
646      * - `spender` cannot be the zero address.
647      */
648     function approve(address spender, uint256 amount) public virtual override returns (bool) {
649         _approve(_msgSender(), spender, amount);
650         return true;
651     }
652 
653     /**
654      * @dev See {IERC20-transferFrom}.
655      *
656      * Emits an {Approval} event indicating the updated allowance. This is not
657      * required by the EIP. See the note at the beginning of {ERC20}.
658      *
659      * Requirements:
660      *
661      * - `sender` and `recipient` cannot be the zero address.
662      * - `sender` must have a balance of at least `amount`.
663      * - the caller must have allowance for ``sender``'s tokens of at least
664      * `amount`.
665      */
666     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
667         _transfer(sender, recipient, amount);
668 
669         uint256 currentAllowance = _allowances[sender][_msgSender()];
670         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
671         _approve(sender, _msgSender(), currentAllowance - amount);
672 
673         return true;
674     }
675 
676     /**
677      * @dev Atomically increases the allowance granted to `spender` by the caller.
678      *
679      * This is an alternative to {approve} that can be used as a mitigation for
680      * problems described in {IERC20-approve}.
681      *
682      * Emits an {Approval} event indicating the updated allowance.
683      *
684      * Requirements:
685      *
686      * - `spender` cannot be the zero address.
687      */
688     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
689         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
690         return true;
691     }
692 
693     /**
694      * @dev Atomically decreases the allowance granted to `spender` by the caller.
695      *
696      * This is an alternative to {approve} that can be used as a mitigation for
697      * problems described in {IERC20-approve}.
698      *
699      * Emits an {Approval} event indicating the updated allowance.
700      *
701      * Requirements:
702      *
703      * - `spender` cannot be the zero address.
704      * - `spender` must have allowance for the caller of at least
705      * `subtractedValue`.
706      */
707     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
708         uint256 currentAllowance = _allowances[_msgSender()][spender];
709         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
710         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
711 
712         return true;
713     }
714 
715     /**
716      * @dev Moves tokens `amount` from `sender` to `recipient`.
717      *
718      * This is internal function is equivalent to {transfer}, and can be used to
719      * e.g. implement automatic token fees, slashing mechanisms, etc.
720      *
721      * Emits a {Transfer} event.
722      *
723      * Requirements:
724      *
725      * - `sender` cannot be the zero address.
726      * - `recipient` cannot be the zero address.
727      * - `sender` must have a balance of at least `amount`.
728      */
729     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
730         require(sender != address(0), "ERC20: transfer from the zero address");
731         require(recipient != address(0), "ERC20: transfer to the zero address");
732 
733         _beforeTokenTransfer(sender, recipient, amount);
734 
735         uint256 senderBalance = _balances[sender];
736         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
737         _balances[sender] = senderBalance - amount;
738         _balances[recipient] += amount;
739 
740         emit Transfer(sender, recipient, amount);
741     }
742 
743     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
744      * the total supply.
745      *
746      * Emits a {Transfer} event with `from` set to the zero address.
747      *
748      * Requirements:
749      *
750      * - `to` cannot be the zero address.
751      */
752     function _mint(address account, uint256 amount) internal virtual {
753         require(account != address(0), "ERC20: mint to the zero address");
754 
755         _beforeTokenTransfer(address(0), account, amount);
756 
757         _totalSupply += amount;
758         _balances[account] += amount;
759         emit Transfer(address(0), account, amount);
760     }
761 
762     /**
763      * @dev Destroys `amount` tokens from `account`, reducing the
764      * total supply.
765      *
766      * Emits a {Transfer} event with `to` set to the zero address.
767      *
768      * Requirements:
769      *
770      * - `account` cannot be the zero address.
771      * - `account` must have at least `amount` tokens.
772      */
773     function _burn(address account, uint256 amount) internal virtual {
774         require(account != address(0), "ERC20: burn from the zero address");
775 
776         _beforeTokenTransfer(account, address(0), amount);
777 
778         uint256 accountBalance = _balances[account];
779         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
780         _balances[account] = accountBalance - amount;
781         _totalSupply -= amount;
782 
783         emit Transfer(account, address(0), amount);
784     }
785 
786     /**
787      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
788      *
789      * This internal function is equivalent to `approve`, and can be used to
790      * e.g. set automatic allowances for certain subsystems, etc.
791      *
792      * Emits an {Approval} event.
793      *
794      * Requirements:
795      *
796      * - `owner` cannot be the zero address.
797      * - `spender` cannot be the zero address.
798      */
799     function _approve(address owner, address spender, uint256 amount) internal virtual {
800         require(owner != address(0), "ERC20: approve from the zero address");
801         require(spender != address(0), "ERC20: approve to the zero address");
802 
803         _allowances[owner][spender] = amount;
804         emit Approval(owner, spender, amount);
805     }
806 
807     /**
808      * @dev Hook that is called before any transfer of tokens. This includes
809      * minting and burning.
810      *
811      * Calling conditions:
812      *
813      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
814      * will be to transferred to `to`.
815      * - when `from` is zero, `amount` tokens will be minted for `to`.
816      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
817      * - `from` and `to` are never both zero.
818      *
819      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
820      */
821     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
822 }
823 
824 
825 // File contracts/mocks/ERC20Mock.sol
826 
827 pragma solidity ^0.8.4;
828 contract ERC20Mock is ERC20 {
829     constructor(
830         string memory name,
831         string memory symbol,
832         uint256 totalSupply
833     ) ERC20(name, symbol) {
834         _mint(msg.sender, totalSupply);
835     }
836 }
837 
838 
839 // File @openzeppelin/contracts/utils/cryptography/MerkleProof.sol@v4.1.0
840 
841 
842 pragma solidity ^0.8.0;
843 
844 /**
845  * @dev These functions deal with verification of Merkle Trees proofs.
846  *
847  * The proofs can be generated using the JavaScript library
848  * https://github.com/miguelmota/merkletreejs[merkletreejs].
849  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
850  *
851  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
852  */
853 library MerkleProof {
854     /**
855      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
856      * defined by `root`. For this, a `proof` must be provided, containing
857      * sibling hashes on the branch from the leaf to the root of the tree. Each
858      * pair of leaves and each pair of pre-images are assumed to be sorted.
859      */
860     function verify(bytes32[] memory proof, bytes32 root, bytes32 leaf) internal pure returns (bool) {
861         bytes32 computedHash = leaf;
862 
863         for (uint256 i = 0; i < proof.length; i++) {
864             bytes32 proofElement = proof[i];
865 
866             if (computedHash <= proofElement) {
867                 // Hash(current computed hash + current element of the proof)
868                 computedHash = keccak256(abi.encodePacked(computedHash, proofElement));
869             } else {
870                 // Hash(current element of the proof + current computed hash)
871                 computedHash = keccak256(abi.encodePacked(proofElement, computedHash));
872             }
873         }
874 
875         // Check if the computed hash (root) is equal to the provided root
876         return computedHash == root;
877     }
878 }
879 
880 
881 // File contracts/NominatorOwner.sol
882 
883 pragma solidity ^0.8.4;
884 
885 abstract contract NominatorOwner is Ownable {
886     event RootUpdated(bytes32 claimRoot, uint256 blockNumber);
887     event InflationRateBaseUpdated(uint16 inflationRateBase);
888     event InflationRateTargetUpdated(uint16 inflationRateTarget);
889     event StakeRateTargetUpdated(uint16 inflationRateTarget);
890     event BondingPeriodUpdated(uint32 bondingPeriod);
891 
892     uint16 public inflationRateBase = 50; //0.5%
893     uint16 public inflationRateTarget = 225; //2.25%
894     uint16 public stakeRateTarget = 1500; //15%
895 
896     uint32 public bondingPeriod = 7 days;
897 
898     uint256 public lastRootBlock;
899     mapping(uint256 => bytes32) public claimRoots;
900 
901     modifier validAddress(address addr) {
902         require(addr != address(0), "Zero address");
903         _;
904     }
905 
906     function setInflationRateBase(uint16 value) external onlyOwner {
907         inflationRateBase = value;
908         emit InflationRateBaseUpdated(value);
909     }
910 
911     function setInflationRateTarget(uint16 value) external onlyOwner {
912         inflationRateTarget = value;
913         emit InflationRateTargetUpdated(value);
914     }
915 
916     function setStakeRateTarget(uint16 value) external onlyOwner {
917         stakeRateTarget = value;
918         emit StakeRateTargetUpdated(value);
919     }
920 
921     function updateRoot(bytes32 claimRoot, uint256 blockNumber) external onlyOwner {
922         require(lastRootBlock < blockNumber && blockNumber < block.number, "Invalid block number");
923         lastRootBlock = blockNumber;
924         claimRoots[blockNumber] = claimRoot;
925         emit RootUpdated(claimRoot, blockNumber);
926     }
927 
928     function setBondingPeriod(uint32 time) external onlyOwner {
929         bondingPeriod = time;
930         emit BondingPeriodUpdated(time);
931     }
932 }
933 
934 
935 // File contracts/Nominator.sol
936 
937 pragma solidity ^0.8.4;
938 
939 
940 
941 
942 
943 contract Nominator is NominatorOwner {
944     using SafeERC20 for IERC20;
945     using MerkleProof for bytes32[];
946 
947     event Withdrawn(address indexed addr, uint256 amount);
948     event RewardWithdrawn(address indexed addr);
949     event WithdrawRequested(address indexed addr, uint256 amount);
950 
951     uint256 public constant stakeMin = 100e18;
952     uint256 public constant stakeMax = 5_000_000e18;
953     uint16 public constant decayRate = 1500; //5%
954     uint32 public constant rewardPeriod = 365 days;
955 
956     address private immutable token;
957     address private immutable custodian;
958 
959     mapping(address => uint256) public balances;
960     mapping(address => uint256) public totalPayoutsFor;
961 
962     struct WithdrawRequest {
963         uint192 amount;
964         uint64 timestamp;
965     }
966 
967     mapping(address => WithdrawRequest[]) public withdrawalRequests;
968 
969     constructor(address _token, address _custodian) {
970         token = _token;
971         custodian = _custodian;
972     }
973 
974     function deposit(uint256 amount) external {
975         balances[msg.sender] += amount;
976 
977         IERC20(token).safeTransferFrom(msg.sender, address(this), amount);
978     }
979 
980     function requestWithdraw(uint256 amount) external {
981         require(amount > 0 && amount <= balances[msg.sender], "Invalid amount");
982 
983         withdrawalRequests[msg.sender].push(WithdrawRequest(uint192(amount), uint64(block.timestamp + bondingPeriod)));
984 
985         balances[msg.sender] -= amount;
986 
987         emit WithdrawRequested(msg.sender, amount);
988     }
989 
990     function maxWithdrawAmount(address beneficiary) public view returns (uint256) {
991         uint256 result;
992         WithdrawRequest[] storage accountRequests = withdrawalRequests[beneficiary];
993         uint256 n = accountRequests.length;
994         for (uint256 i; i < n; i++) {
995             WithdrawRequest memory request = accountRequests[i];
996             if (request.timestamp <= block.timestamp) {
997                 result += request.amount;
998             }
999         }
1000         return result;
1001     }
1002 
1003     function withdraw(address beneficiary, uint256 amount) external {
1004         require(amount <= maxWithdrawAmount(beneficiary), "Invalid amount");
1005 
1006         WithdrawRequest[] storage accountRequests = withdrawalRequests[beneficiary];
1007         uint256 requestedAmount = amount;
1008         uint256 i;
1009         uint256 lastIndex = accountRequests.length - 1;
1010         while (requestedAmount > 0 && i <= lastIndex) {
1011             WithdrawRequest memory request = accountRequests[i];
1012             if (request.timestamp > block.timestamp) {
1013                 i++;
1014                 continue;
1015             }
1016             if (request.amount > requestedAmount) {
1017                 accountRequests[i].amount = uint192(request.amount - requestedAmount);
1018                 break;
1019             }
1020             requestedAmount -= request.amount;
1021             if (i < lastIndex) {
1022                 accountRequests[i] = accountRequests[lastIndex];
1023             }
1024             accountRequests.pop();
1025             if (lastIndex > 0) {
1026                 lastIndex--;
1027             }
1028         }
1029 
1030         IERC20(token).safeTransfer(beneficiary, amount);
1031 
1032         emit Withdrawn(beneficiary, amount);
1033     }
1034 
1035     function stakeOf(address addr) external view validAddress(addr) returns (uint256) {
1036         uint256 balance = balances[addr];
1037 
1038         if (balance < stakeMin) return 0;
1039         if (balance > stakeMax) return stakeMax;
1040 
1041         return balance;
1042     }
1043 
1044     function isValidProof(
1045         address recipient,
1046         uint256 totalEarned,
1047         uint256 blockNumber,
1048         bytes32[] calldata proof
1049     ) public view returns (bool) {
1050         bytes32 leaf = keccak256(abi.encodePacked(recipient, totalEarned, block.chainid, address(this)));
1051         bytes32 root = claimRoots[blockNumber];
1052         return proof.verify(root, leaf);
1053     }
1054 
1055     function withdrawReward(
1056         address recipient,
1057         uint256 totalEarned,
1058         uint256 blockNumber,
1059         bytes32[] calldata proof
1060     ) external {
1061         require(isValidProof(recipient, totalEarned, blockNumber, proof), "Invalid proof");
1062         uint256 totalReceived = totalPayoutsFor[recipient];
1063         require(totalEarned >= totalReceived, "Already paid");
1064         uint256 amount = totalEarned - totalReceived;
1065         if (amount == 0) return;
1066         totalPayoutsFor[recipient] = totalEarned;
1067 
1068         Custodian(custodian).withdrawTo(token, recipient, amount);
1069 
1070         emit RewardWithdrawn(recipient);
1071     }
1072 }
1073 
1074 
1075 // File contracts/ValidatorOwner.sol
1076 
1077 pragma solidity ^0.8.4;
1078 abstract contract ValidatorOwner is Ownable {
1079     event RootUpdated(bytes32 claimRoot, uint256 blockNumber);
1080     event AddedToWhitelist(address addr);
1081     event RemovedFromWhitelist(address addr);
1082     event InflationRateBaseUpdated(uint16 inflationRateBase);
1083     event InflationRateTargetUpdated(uint16 inflationRateTarget);
1084     event SlotsMaxUpdated(uint256 slotsMax);
1085 
1086     uint256 public slotsMax = 500;
1087     uint16 public inflationRateBase = 200; //2%
1088     uint16 public inflationRateTarget = 250; //2.5%
1089 
1090     mapping(address => bool) public whitelist;
1091 
1092     uint256 public lastRootBlock;
1093     mapping(uint256 => bytes32) public claimRoots;
1094 
1095     modifier validAddress(address addr) {
1096         require(addr != address(0), "Zero address");
1097         _;
1098     }
1099 
1100     function whitelistAdd(address addr) external onlyOwner validAddress(addr) {
1101         require(!whitelist[addr], "Already whitelisted");
1102 
1103         whitelist[addr] = true;
1104 
1105         emit AddedToWhitelist(addr);
1106     }
1107 
1108     function whitelistRemove(address addr) external onlyOwner validAddress(addr) {
1109         require(whitelist[addr], "Already removed from whitelist");
1110 
1111         whitelist[addr] = false;
1112 
1113         emit RemovedFromWhitelist(addr);
1114     }
1115 
1116     function setInflationRateBase(uint16 value) external onlyOwner {
1117         inflationRateBase = value;
1118         emit InflationRateBaseUpdated(value);
1119     }
1120 
1121     function setInflationRateTarget(uint16 value) external onlyOwner {
1122         inflationRateTarget = value;
1123         emit InflationRateTargetUpdated(value);
1124     }
1125 
1126     function setSlotsMax(uint256 value) external onlyOwner {
1127         slotsMax = value;
1128         emit SlotsMaxUpdated(value);
1129     }
1130 
1131     function updateRoot(bytes32 claimRoot, uint256 blockNumber) external onlyOwner {
1132         require(lastRootBlock < blockNumber && blockNumber < block.number, "Invalid block number");
1133         lastRootBlock = blockNumber;
1134         claimRoots[blockNumber] = claimRoot;
1135         emit RootUpdated(claimRoot, blockNumber);
1136     }
1137 }
1138 
1139 
1140 // File contracts/Validator.sol
1141 
1142 pragma solidity ^0.8.4;
1143 contract Validator is ValidatorOwner {
1144     using SafeERC20 for IERC20;
1145     using MerkleProof for bytes32[];
1146 
1147     event Withdrawn(address indexed addr, uint256 amount);
1148     event RewardWithdrawn(address indexed addr);
1149 
1150     uint256 public constant stakeMin = 20_000e18;
1151     uint256 public constant stakeMax = 200_000e18;
1152     uint16 public constant decayRate = 500; //5%
1153     uint32 public constant rewardPeriod = 365 days;
1154 
1155     address private immutable token;
1156     address private immutable custodian;
1157 
1158     mapping(address => uint256) public balances;
1159 
1160     mapping(address => uint256) public totalPayoutsFor;
1161 
1162     constructor(address _token, address _custodian) {
1163         token = _token;
1164         custodian = _custodian;
1165     }
1166 
1167     function deposit(uint256 amount) external {
1168         balances[msg.sender] += amount;
1169 
1170         IERC20(token).safeTransferFrom(msg.sender, address(this), amount);
1171     }
1172 
1173     function withdraw(uint256 amount) external {
1174         require(amount > 0 && amount <= balances[msg.sender], "Invalid amount");
1175 
1176         balances[msg.sender] -= amount;
1177 
1178         IERC20(token).safeTransfer(msg.sender, amount);
1179 
1180         emit Withdrawn(msg.sender, amount);
1181     }
1182 
1183     function stakeOf(address addr) external view validAddress(addr) returns (uint256) {
1184         uint256 balance = balances[addr];
1185 
1186         if (!whitelist[addr]) return 0;
1187         if (balance < stakeMin) return 0;
1188         if (balance > stakeMax) return stakeMax;
1189 
1190         return balance;
1191     }
1192 
1193     function isValidProof(
1194         address recipient,
1195         uint256 totalEarned,
1196         uint256 blockNumber,
1197         bytes32[] calldata proof
1198     ) public view returns (bool) {
1199         bytes32 leaf = keccak256(abi.encodePacked(recipient, totalEarned, block.chainid, address(this)));
1200         bytes32 root = claimRoots[blockNumber];
1201         return proof.verify(root, leaf);
1202     }
1203 
1204     function withdrawReward(
1205         address recipient,
1206         uint256 totalEarned,
1207         uint256 blockNumber,
1208         bytes32[] calldata proof
1209     ) external {
1210         require(isValidProof(recipient, totalEarned, blockNumber, proof), "Invalid proof");
1211         uint256 totalReceived = totalPayoutsFor[recipient];
1212         require(totalEarned >= totalReceived, "Already paid");
1213         uint256 amount = totalEarned - totalReceived;
1214         if (amount == 0) return;
1215         totalPayoutsFor[recipient] = totalEarned;
1216 
1217         Custodian(custodian).withdrawTo(token, recipient, amount);
1218 
1219         emit RewardWithdrawn(recipient);
1220     }
1221 }