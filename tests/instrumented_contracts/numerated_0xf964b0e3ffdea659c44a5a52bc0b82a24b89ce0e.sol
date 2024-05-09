1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.8.9;
4 
5 
6 
7 // Part: IStrategy
8 
9 interface IStrategy {
10     function harvest(address caller) external returns (uint256 harvested);
11 
12     function totalUnderlying() external view returns (uint256 total);
13 
14     function stake(uint256 _amount) external;
15 
16     function withdraw(uint256 _amount) external;
17 
18     function setApprovals() external;
19 }
20 
21 // Part: OpenZeppelin/openzeppelin-contracts@4.1.0/Address
22 
23 /**
24  * @dev Collection of functions related to the address type
25  */
26 library Address {
27     /**
28      * @dev Returns true if `account` is a contract.
29      *
30      * [IMPORTANT]
31      * ====
32      * It is unsafe to assume that an address for which this function returns
33      * false is an externally-owned account (EOA) and not a contract.
34      *
35      * Among others, `isContract` will return false for the following
36      * types of addresses:
37      *
38      *  - an externally-owned account
39      *  - a contract in construction
40      *  - an address where a contract will be created
41      *  - an address where a contract lived, but was destroyed
42      * ====
43      */
44     function isContract(address account) internal view returns (bool) {
45         // This method relies on extcodesize, which returns 0 for contracts in
46         // construction, since the code is only stored at the end of the
47         // constructor execution.
48 
49         uint256 size;
50         // solhint-disable-next-line no-inline-assembly
51         assembly { size := extcodesize(account) }
52         return size > 0;
53     }
54 
55     /**
56      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
57      * `recipient`, forwarding all available gas and reverting on errors.
58      *
59      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
60      * of certain opcodes, possibly making contracts go over the 2300 gas limit
61      * imposed by `transfer`, making them unable to receive funds via
62      * `transfer`. {sendValue} removes this limitation.
63      *
64      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
65      *
66      * IMPORTANT: because control is transferred to `recipient`, care must be
67      * taken to not create reentrancy vulnerabilities. Consider using
68      * {ReentrancyGuard} or the
69      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
70      */
71     function sendValue(address payable recipient, uint256 amount) internal {
72         require(address(this).balance >= amount, "Address: insufficient balance");
73 
74         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
75         (bool success, ) = recipient.call{ value: amount }("");
76         require(success, "Address: unable to send value, recipient may have reverted");
77     }
78 
79     /**
80      * @dev Performs a Solidity function call using a low level `call`. A
81      * plain`call` is an unsafe replacement for a function call: use this
82      * function instead.
83      *
84      * If `target` reverts with a revert reason, it is bubbled up by this
85      * function (like regular Solidity function calls).
86      *
87      * Returns the raw returned data. To convert to the expected return value,
88      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
89      *
90      * Requirements:
91      *
92      * - `target` must be a contract.
93      * - calling `target` with `data` must not revert.
94      *
95      * _Available since v3.1._
96      */
97     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
98       return functionCall(target, data, "Address: low-level call failed");
99     }
100 
101     /**
102      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
103      * `errorMessage` as a fallback revert reason when `target` reverts.
104      *
105      * _Available since v3.1._
106      */
107     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
108         return functionCallWithValue(target, data, 0, errorMessage);
109     }
110 
111     /**
112      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
113      * but also transferring `value` wei to `target`.
114      *
115      * Requirements:
116      *
117      * - the calling contract must have an ETH balance of at least `value`.
118      * - the called Solidity function must be `payable`.
119      *
120      * _Available since v3.1._
121      */
122     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
123         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
124     }
125 
126     /**
127      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
128      * with `errorMessage` as a fallback revert reason when `target` reverts.
129      *
130      * _Available since v3.1._
131      */
132     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
133         require(address(this).balance >= value, "Address: insufficient balance for call");
134         require(isContract(target), "Address: call to non-contract");
135 
136         // solhint-disable-next-line avoid-low-level-calls
137         (bool success, bytes memory returndata) = target.call{ value: value }(data);
138         return _verifyCallResult(success, returndata, errorMessage);
139     }
140 
141     /**
142      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
143      * but performing a static call.
144      *
145      * _Available since v3.3._
146      */
147     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
148         return functionStaticCall(target, data, "Address: low-level static call failed");
149     }
150 
151     /**
152      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
153      * but performing a static call.
154      *
155      * _Available since v3.3._
156      */
157     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
158         require(isContract(target), "Address: static call to non-contract");
159 
160         // solhint-disable-next-line avoid-low-level-calls
161         (bool success, bytes memory returndata) = target.staticcall(data);
162         return _verifyCallResult(success, returndata, errorMessage);
163     }
164 
165     /**
166      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
167      * but performing a delegate call.
168      *
169      * _Available since v3.4._
170      */
171     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
172         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
173     }
174 
175     /**
176      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
177      * but performing a delegate call.
178      *
179      * _Available since v3.4._
180      */
181     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
182         require(isContract(target), "Address: delegate call to non-contract");
183 
184         // solhint-disable-next-line avoid-low-level-calls
185         (bool success, bytes memory returndata) = target.delegatecall(data);
186         return _verifyCallResult(success, returndata, errorMessage);
187     }
188 
189     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
190         if (success) {
191             return returndata;
192         } else {
193             // Look for revert reason and bubble it up if present
194             if (returndata.length > 0) {
195                 // The easiest way to bubble the revert reason is using memory via assembly
196 
197                 // solhint-disable-next-line no-inline-assembly
198                 assembly {
199                     let returndata_size := mload(returndata)
200                     revert(add(32, returndata), returndata_size)
201                 }
202             } else {
203                 revert(errorMessage);
204             }
205         }
206     }
207 }
208 
209 // Part: OpenZeppelin/openzeppelin-contracts@4.1.0/Context
210 
211 /*
212  * @dev Provides information about the current execution context, including the
213  * sender of the transaction and its data. While these are generally available
214  * via msg.sender and msg.data, they should not be accessed in such a direct
215  * manner, since when dealing with meta-transactions the account sending and
216  * paying for execution may not be the actual sender (as far as an application
217  * is concerned).
218  *
219  * This contract is only required for intermediate, library-like contracts.
220  */
221 abstract contract Context {
222     function _msgSender() internal view virtual returns (address) {
223         return msg.sender;
224     }
225 
226     function _msgData() internal view virtual returns (bytes calldata) {
227         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
228         return msg.data;
229     }
230 }
231 
232 // Part: OpenZeppelin/openzeppelin-contracts@4.1.0/IERC20
233 
234 /**
235  * @dev Interface of the ERC20 standard as defined in the EIP.
236  */
237 interface IERC20 {
238     /**
239      * @dev Returns the amount of tokens in existence.
240      */
241     function totalSupply() external view returns (uint256);
242 
243     /**
244      * @dev Returns the amount of tokens owned by `account`.
245      */
246     function balanceOf(address account) external view returns (uint256);
247 
248     /**
249      * @dev Moves `amount` tokens from the caller's account to `recipient`.
250      *
251      * Returns a boolean value indicating whether the operation succeeded.
252      *
253      * Emits a {Transfer} event.
254      */
255     function transfer(address recipient, uint256 amount) external returns (bool);
256 
257     /**
258      * @dev Returns the remaining number of tokens that `spender` will be
259      * allowed to spend on behalf of `owner` through {transferFrom}. This is
260      * zero by default.
261      *
262      * This value changes when {approve} or {transferFrom} are called.
263      */
264     function allowance(address owner, address spender) external view returns (uint256);
265 
266     /**
267      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
268      *
269      * Returns a boolean value indicating whether the operation succeeded.
270      *
271      * IMPORTANT: Beware that changing an allowance with this method brings the risk
272      * that someone may use both the old and the new allowance by unfortunate
273      * transaction ordering. One possible solution to mitigate this race
274      * condition is to first reduce the spender's allowance to 0 and set the
275      * desired value afterwards:
276      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
277      *
278      * Emits an {Approval} event.
279      */
280     function approve(address spender, uint256 amount) external returns (bool);
281 
282     /**
283      * @dev Moves `amount` tokens from `sender` to `recipient` using the
284      * allowance mechanism. `amount` is then deducted from the caller's
285      * allowance.
286      *
287      * Returns a boolean value indicating whether the operation succeeded.
288      *
289      * Emits a {Transfer} event.
290      */
291     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
292 
293     /**
294      * @dev Emitted when `value` tokens are moved from one account (`from`) to
295      * another (`to`).
296      *
297      * Note that `value` may be zero.
298      */
299     event Transfer(address indexed from, address indexed to, uint256 value);
300 
301     /**
302      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
303      * a call to {approve}. `value` is the new allowance.
304      */
305     event Approval(address indexed owner, address indexed spender, uint256 value);
306 }
307 
308 // Part: OpenZeppelin/openzeppelin-contracts@4.1.0/IERC20Metadata
309 
310 /**
311  * @dev Interface for the optional metadata functions from the ERC20 standard.
312  *
313  * _Available since v4.1._
314  */
315 interface IERC20Metadata is IERC20 {
316     /**
317      * @dev Returns the name of the token.
318      */
319     function name() external view returns (string memory);
320 
321     /**
322      * @dev Returns the symbol of the token.
323      */
324     function symbol() external view returns (string memory);
325 
326     /**
327      * @dev Returns the decimals places of the token.
328      */
329     function decimals() external view returns (uint8);
330 }
331 
332 // Part: OpenZeppelin/openzeppelin-contracts@4.1.0/Ownable
333 
334 /**
335  * @dev Contract module which provides a basic access control mechanism, where
336  * there is an account (an owner) that can be granted exclusive access to
337  * specific functions.
338  *
339  * By default, the owner account will be the one that deploys the contract. This
340  * can later be changed with {transferOwnership}.
341  *
342  * This module is used through inheritance. It will make available the modifier
343  * `onlyOwner`, which can be applied to your functions to restrict their use to
344  * the owner.
345  */
346 abstract contract Ownable is Context {
347     address private _owner;
348 
349     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
350 
351     /**
352      * @dev Initializes the contract setting the deployer as the initial owner.
353      */
354     constructor () {
355         address msgSender = _msgSender();
356         _owner = msgSender;
357         emit OwnershipTransferred(address(0), msgSender);
358     }
359 
360     /**
361      * @dev Returns the address of the current owner.
362      */
363     function owner() public view virtual returns (address) {
364         return _owner;
365     }
366 
367     /**
368      * @dev Throws if called by any account other than the owner.
369      */
370     modifier onlyOwner() {
371         require(owner() == _msgSender(), "Ownable: caller is not the owner");
372         _;
373     }
374 
375     /**
376      * @dev Leaves the contract without owner. It will not be possible to call
377      * `onlyOwner` functions anymore. Can only be called by the current owner.
378      *
379      * NOTE: Renouncing ownership will leave the contract without an owner,
380      * thereby removing any functionality that is only available to the owner.
381      */
382     function renounceOwnership() public virtual onlyOwner {
383         emit OwnershipTransferred(_owner, address(0));
384         _owner = address(0);
385     }
386 
387     /**
388      * @dev Transfers ownership of the contract to a new account (`newOwner`).
389      * Can only be called by the current owner.
390      */
391     function transferOwnership(address newOwner) public virtual onlyOwner {
392         require(newOwner != address(0), "Ownable: new owner is the zero address");
393         emit OwnershipTransferred(_owner, newOwner);
394         _owner = newOwner;
395     }
396 }
397 
398 // Part: OpenZeppelin/openzeppelin-contracts@4.1.0/SafeERC20
399 
400 /**
401  * @title SafeERC20
402  * @dev Wrappers around ERC20 operations that throw on failure (when the token
403  * contract returns false). Tokens that return no value (and instead revert or
404  * throw on failure) are also supported, non-reverting calls are assumed to be
405  * successful.
406  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
407  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
408  */
409 library SafeERC20 {
410     using Address for address;
411 
412     function safeTransfer(IERC20 token, address to, uint256 value) internal {
413         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
414     }
415 
416     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
417         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
418     }
419 
420     /**
421      * @dev Deprecated. This function has issues similar to the ones found in
422      * {IERC20-approve}, and its usage is discouraged.
423      *
424      * Whenever possible, use {safeIncreaseAllowance} and
425      * {safeDecreaseAllowance} instead.
426      */
427     function safeApprove(IERC20 token, address spender, uint256 value) internal {
428         // safeApprove should only be called when setting an initial allowance,
429         // or when resetting it to zero. To increase and decrease it, use
430         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
431         // solhint-disable-next-line max-line-length
432         require((value == 0) || (token.allowance(address(this), spender) == 0),
433             "SafeERC20: approve from non-zero to non-zero allowance"
434         );
435         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
436     }
437 
438     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
439         uint256 newAllowance = token.allowance(address(this), spender) + value;
440         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
441     }
442 
443     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
444         unchecked {
445             uint256 oldAllowance = token.allowance(address(this), spender);
446             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
447             uint256 newAllowance = oldAllowance - value;
448             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
449         }
450     }
451 
452     /**
453      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
454      * on the return value: the return value is optional (but if data is returned, it must not be false).
455      * @param token The token targeted by the call.
456      * @param data The call data (encoded using abi.encode or one of its variants).
457      */
458     function _callOptionalReturn(IERC20 token, bytes memory data) private {
459         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
460         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
461         // the target address contains contract code and also asserts for success in the low-level call.
462 
463         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
464         if (returndata.length > 0) { // Return data is optional
465             // solhint-disable-next-line max-line-length
466             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
467         }
468     }
469 }
470 
471 // Part: OpenZeppelin/openzeppelin-contracts@4.1.0/ERC20
472 
473 /**
474  * @dev Implementation of the {IERC20} interface.
475  *
476  * This implementation is agnostic to the way tokens are created. This means
477  * that a supply mechanism has to be added in a derived contract using {_mint}.
478  * For a generic mechanism see {ERC20PresetMinterPauser}.
479  *
480  * TIP: For a detailed writeup see our guide
481  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
482  * to implement supply mechanisms].
483  *
484  * We have followed general OpenZeppelin guidelines: functions revert instead
485  * of returning `false` on failure. This behavior is nonetheless conventional
486  * and does not conflict with the expectations of ERC20 applications.
487  *
488  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
489  * This allows applications to reconstruct the allowance for all accounts just
490  * by listening to said events. Other implementations of the EIP may not emit
491  * these events, as it isn't required by the specification.
492  *
493  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
494  * functions have been added to mitigate the well-known issues around setting
495  * allowances. See {IERC20-approve}.
496  */
497 contract ERC20 is Context, IERC20, IERC20Metadata {
498     mapping (address => uint256) private _balances;
499 
500     mapping (address => mapping (address => uint256)) private _allowances;
501 
502     uint256 private _totalSupply;
503 
504     string private _name;
505     string private _symbol;
506 
507     /**
508      * @dev Sets the values for {name} and {symbol}.
509      *
510      * The defaut value of {decimals} is 18. To select a different value for
511      * {decimals} you should overload it.
512      *
513      * All two of these values are immutable: they can only be set once during
514      * construction.
515      */
516     constructor (string memory name_, string memory symbol_) {
517         _name = name_;
518         _symbol = symbol_;
519     }
520 
521     /**
522      * @dev Returns the name of the token.
523      */
524     function name() public view virtual override returns (string memory) {
525         return _name;
526     }
527 
528     /**
529      * @dev Returns the symbol of the token, usually a shorter version of the
530      * name.
531      */
532     function symbol() public view virtual override returns (string memory) {
533         return _symbol;
534     }
535 
536     /**
537      * @dev Returns the number of decimals used to get its user representation.
538      * For example, if `decimals` equals `2`, a balance of `505` tokens should
539      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
540      *
541      * Tokens usually opt for a value of 18, imitating the relationship between
542      * Ether and Wei. This is the value {ERC20} uses, unless this function is
543      * overridden;
544      *
545      * NOTE: This information is only used for _display_ purposes: it in
546      * no way affects any of the arithmetic of the contract, including
547      * {IERC20-balanceOf} and {IERC20-transfer}.
548      */
549     function decimals() public view virtual override returns (uint8) {
550         return 18;
551     }
552 
553     /**
554      * @dev See {IERC20-totalSupply}.
555      */
556     function totalSupply() public view virtual override returns (uint256) {
557         return _totalSupply;
558     }
559 
560     /**
561      * @dev See {IERC20-balanceOf}.
562      */
563     function balanceOf(address account) public view virtual override returns (uint256) {
564         return _balances[account];
565     }
566 
567     /**
568      * @dev See {IERC20-transfer}.
569      *
570      * Requirements:
571      *
572      * - `recipient` cannot be the zero address.
573      * - the caller must have a balance of at least `amount`.
574      */
575     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
576         _transfer(_msgSender(), recipient, amount);
577         return true;
578     }
579 
580     /**
581      * @dev See {IERC20-allowance}.
582      */
583     function allowance(address owner, address spender) public view virtual override returns (uint256) {
584         return _allowances[owner][spender];
585     }
586 
587     /**
588      * @dev See {IERC20-approve}.
589      *
590      * Requirements:
591      *
592      * - `spender` cannot be the zero address.
593      */
594     function approve(address spender, uint256 amount) public virtual override returns (bool) {
595         _approve(_msgSender(), spender, amount);
596         return true;
597     }
598 
599     /**
600      * @dev See {IERC20-transferFrom}.
601      *
602      * Emits an {Approval} event indicating the updated allowance. This is not
603      * required by the EIP. See the note at the beginning of {ERC20}.
604      *
605      * Requirements:
606      *
607      * - `sender` and `recipient` cannot be the zero address.
608      * - `sender` must have a balance of at least `amount`.
609      * - the caller must have allowance for ``sender``'s tokens of at least
610      * `amount`.
611      */
612     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
613         _transfer(sender, recipient, amount);
614 
615         uint256 currentAllowance = _allowances[sender][_msgSender()];
616         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
617         _approve(sender, _msgSender(), currentAllowance - amount);
618 
619         return true;
620     }
621 
622     /**
623      * @dev Atomically increases the allowance granted to `spender` by the caller.
624      *
625      * This is an alternative to {approve} that can be used as a mitigation for
626      * problems described in {IERC20-approve}.
627      *
628      * Emits an {Approval} event indicating the updated allowance.
629      *
630      * Requirements:
631      *
632      * - `spender` cannot be the zero address.
633      */
634     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
635         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
636         return true;
637     }
638 
639     /**
640      * @dev Atomically decreases the allowance granted to `spender` by the caller.
641      *
642      * This is an alternative to {approve} that can be used as a mitigation for
643      * problems described in {IERC20-approve}.
644      *
645      * Emits an {Approval} event indicating the updated allowance.
646      *
647      * Requirements:
648      *
649      * - `spender` cannot be the zero address.
650      * - `spender` must have allowance for the caller of at least
651      * `subtractedValue`.
652      */
653     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
654         uint256 currentAllowance = _allowances[_msgSender()][spender];
655         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
656         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
657 
658         return true;
659     }
660 
661     /**
662      * @dev Moves tokens `amount` from `sender` to `recipient`.
663      *
664      * This is internal function is equivalent to {transfer}, and can be used to
665      * e.g. implement automatic token fees, slashing mechanisms, etc.
666      *
667      * Emits a {Transfer} event.
668      *
669      * Requirements:
670      *
671      * - `sender` cannot be the zero address.
672      * - `recipient` cannot be the zero address.
673      * - `sender` must have a balance of at least `amount`.
674      */
675     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
676         require(sender != address(0), "ERC20: transfer from the zero address");
677         require(recipient != address(0), "ERC20: transfer to the zero address");
678 
679         _beforeTokenTransfer(sender, recipient, amount);
680 
681         uint256 senderBalance = _balances[sender];
682         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
683         _balances[sender] = senderBalance - amount;
684         _balances[recipient] += amount;
685 
686         emit Transfer(sender, recipient, amount);
687     }
688 
689     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
690      * the total supply.
691      *
692      * Emits a {Transfer} event with `from` set to the zero address.
693      *
694      * Requirements:
695      *
696      * - `to` cannot be the zero address.
697      */
698     function _mint(address account, uint256 amount) internal virtual {
699         require(account != address(0), "ERC20: mint to the zero address");
700 
701         _beforeTokenTransfer(address(0), account, amount);
702 
703         _totalSupply += amount;
704         _balances[account] += amount;
705         emit Transfer(address(0), account, amount);
706     }
707 
708     /**
709      * @dev Destroys `amount` tokens from `account`, reducing the
710      * total supply.
711      *
712      * Emits a {Transfer} event with `to` set to the zero address.
713      *
714      * Requirements:
715      *
716      * - `account` cannot be the zero address.
717      * - `account` must have at least `amount` tokens.
718      */
719     function _burn(address account, uint256 amount) internal virtual {
720         require(account != address(0), "ERC20: burn from the zero address");
721 
722         _beforeTokenTransfer(account, address(0), amount);
723 
724         uint256 accountBalance = _balances[account];
725         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
726         _balances[account] = accountBalance - amount;
727         _totalSupply -= amount;
728 
729         emit Transfer(account, address(0), amount);
730     }
731 
732     /**
733      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
734      *
735      * This internal function is equivalent to `approve`, and can be used to
736      * e.g. set automatic allowances for certain subsystems, etc.
737      *
738      * Emits an {Approval} event.
739      *
740      * Requirements:
741      *
742      * - `owner` cannot be the zero address.
743      * - `spender` cannot be the zero address.
744      */
745     function _approve(address owner, address spender, uint256 amount) internal virtual {
746         require(owner != address(0), "ERC20: approve from the zero address");
747         require(spender != address(0), "ERC20: approve to the zero address");
748 
749         _allowances[owner][spender] = amount;
750         emit Approval(owner, spender, amount);
751     }
752 
753     /**
754      * @dev Hook that is called before any transfer of tokens. This includes
755      * minting and burning.
756      *
757      * Calling conditions:
758      *
759      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
760      * will be to transferred to `to`.
761      * - when `from` is zero, `amount` tokens will be minted for `to`.
762      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
763      * - `from` and `to` are never both zero.
764      *
765      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
766      */
767     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
768 }
769 
770 // File: GenericVault.sol
771 
772 contract GenericUnionVault is ERC20, Ownable {
773     using SafeERC20 for IERC20;
774 
775     uint256 public withdrawalPenalty = 100;
776     uint256 public constant MAX_WITHDRAWAL_PENALTY = 150;
777     uint256 public platformFee = 500;
778     uint256 public constant MAX_PLATFORM_FEE = 2000;
779     uint256 public callIncentive = 500;
780     uint256 public constant MAX_CALL_INCENTIVE = 500;
781     uint256 public constant FEE_DENOMINATOR = 10000;
782 
783     address public immutable underlying;
784     address public strategy;
785     address public platform;
786 
787     event Harvest(address indexed _caller, uint256 _value);
788     event Deposit(address indexed _from, address indexed _to, uint256 _value);
789     event Withdraw(address indexed _from, address indexed _to, uint256 _value);
790 
791     event WithdrawalPenaltyUpdated(uint256 _penalty);
792     event CallerIncentiveUpdated(uint256 _incentive);
793     event PlatformFeeUpdated(uint256 _fee);
794     event PlatformUpdated(address indexed _platform);
795     event StrategySet(address indexed _strategy);
796 
797     constructor(address _token)
798         ERC20(
799             string(abi.encodePacked("Unionized ", ERC20(_token).name())),
800             string(abi.encodePacked("u", ERC20(_token).symbol()))
801         )
802     {
803         underlying = _token;
804     }
805 
806     /// @notice Updates the withdrawal penalty
807     /// @param _penalty - the amount of the new penalty (in BIPS)
808     function setWithdrawalPenalty(uint256 _penalty) external onlyOwner {
809         require(_penalty <= MAX_WITHDRAWAL_PENALTY);
810         withdrawalPenalty = _penalty;
811         emit WithdrawalPenaltyUpdated(_penalty);
812     }
813 
814     /// @notice Updates the caller incentive for harvests
815     /// @param _incentive - the amount of the new incentive (in BIPS)
816     function setCallIncentive(uint256 _incentive) external onlyOwner {
817         require(_incentive <= MAX_CALL_INCENTIVE);
818         callIncentive = _incentive;
819         emit CallerIncentiveUpdated(_incentive);
820     }
821 
822     /// @notice Updates the part of yield redirected to the platform
823     /// @param _fee - the amount of the new platform fee (in BIPS)
824     function setPlatformFee(uint256 _fee) external onlyOwner {
825         require(_fee <= MAX_PLATFORM_FEE);
826         platformFee = _fee;
827         emit PlatformFeeUpdated(_fee);
828     }
829 
830     /// @notice Updates the address to which platform fees are paid out
831     /// @param _platform - the new platform wallet address
832     function setPlatform(address _platform)
833         external
834         onlyOwner
835         notToZeroAddress(_platform)
836     {
837         platform = _platform;
838         emit PlatformUpdated(_platform);
839     }
840 
841     /// @notice Set the address of the strategy contract
842     /// @dev Can only be set once
843     /// @param _strategy - address of the strategy contract
844     function setStrategy(address _strategy)
845         external
846         onlyOwner
847         notToZeroAddress(_strategy)
848     {
849         require(strategy == address(0), "Strategy already set");
850         strategy = _strategy;
851         emit StrategySet(_strategy);
852     }
853 
854     /// @notice Query the amount currently staked
855     /// @return total - the total amount of tokens staked
856     function totalUnderlying() public view returns (uint256 total) {
857         return IStrategy(strategy).totalUnderlying();
858     }
859 
860     /// @notice Returns the amount of underlying a user can claim
861     /// @param user - address whose claimable amount to query
862     /// @return amount - claimable amount
863     /// @dev Does not account for penalties and fees
864     function balanceOfUnderlying(address user)
865         external
866         view
867         returns (uint256 amount)
868     {
869         require(totalSupply() > 0, "No users");
870         return ((balanceOf(user) * totalUnderlying()) / totalSupply());
871     }
872 
873     /// @notice Deposit user funds in the autocompounder and mints tokens
874     /// representing user's share of the pool in exchange
875     /// @param _to - the address that will receive the shares
876     /// @param _amount - the amount of underlying to deposit
877     /// @return _shares - the amount of shares issued
878     function deposit(address _to, uint256 _amount)
879         public
880         notToZeroAddress(_to)
881         returns (uint256 _shares)
882     {
883         require(_amount > 0, "Deposit too small");
884 
885         uint256 _before = totalUnderlying();
886         IERC20(underlying).safeTransferFrom(msg.sender, strategy, _amount);
887         IStrategy(strategy).stake(_amount);
888 
889         // Issues shares in proportion of deposit to pool amount
890         uint256 shares = 0;
891         if (totalSupply() == 0) {
892             shares = _amount;
893         } else {
894             shares = (_amount * totalSupply()) / _before;
895         }
896         _mint(_to, shares);
897         emit Deposit(msg.sender, _to, _amount);
898         return shares;
899     }
900 
901     /// @notice Deposit all of user's underlying balance
902     /// @param _to - the address that will receive the shares
903     /// @return _shares - the amount of shares issued
904     function depositAll(address _to) external returns (uint256 _shares) {
905         return deposit(_to, IERC20(underlying).balanceOf(msg.sender));
906     }
907 
908     /// @notice Unstake underlying in proportion to the amount of shares sent
909     /// @param _shares - the number of shares sent
910     /// @return _withdrawable - the withdrawable underlying amount
911     function _withdraw(uint256 _shares)
912         internal
913         returns (uint256 _withdrawable)
914     {
915         require(totalSupply() > 0);
916         // Computes the amount withdrawable based on the number of shares sent
917         uint256 amount = (_shares * totalUnderlying()) / totalSupply();
918         // Burn the shares before retrieving tokens
919         _burn(msg.sender, _shares);
920         // If user is last to withdraw, harvest before exit
921         if (totalSupply() == 0) {
922             harvest();
923             IStrategy(strategy).withdraw(totalUnderlying());
924             _withdrawable = IERC20(underlying).balanceOf(address(this));
925         }
926         // Otherwise compute share and unstake
927         else {
928             _withdrawable = amount;
929             // Substract a small withdrawal fee to prevent users "timing"
930             // the harvests. The fee stays staked and is therefore
931             // redistributed to all remaining participants.
932             uint256 _penalty = (_withdrawable * withdrawalPenalty) /
933                 FEE_DENOMINATOR;
934             _withdrawable = _withdrawable - _penalty;
935             IStrategy(strategy).withdraw(_withdrawable);
936         }
937         return _withdrawable;
938     }
939 
940     /// @notice Unstake underlying token in proportion to the amount of shares sent
941     /// @param _to - address to send underlying to
942     /// @param _shares - the number of shares sent
943     /// @return withdrawn - the amount of underlying returned to the user
944     function withdraw(address _to, uint256 _shares)
945         public
946         notToZeroAddress(_to)
947         returns (uint256 withdrawn)
948     {
949         // Withdraw requested amount of underlying
950         uint256 _withdrawable = _withdraw(_shares);
951         // And sends back underlying to user
952         IERC20(underlying).safeTransfer(_to, _withdrawable);
953         emit Withdraw(msg.sender, _to, _withdrawable);
954         return _withdrawable;
955     }
956 
957     /// @notice Withdraw all of a users' position as underlying
958     /// @param _to - address to send underlying to
959     /// @return withdrawn - the amount of underlying returned to the user
960     function withdrawAll(address _to)
961         external
962         notToZeroAddress(_to)
963         returns (uint256 withdrawn)
964     {
965         return withdraw(_to, balanceOf(msg.sender));
966     }
967 
968     /// @notice Claim rewards and swaps them to FXS for restaking
969     /// @dev Can be called by anyone against an incentive in FXS
970     /// @dev Harvest logic in the strategy contract
971     function harvest() public {
972         uint256 _harvested = IStrategy(strategy).harvest(msg.sender);
973         emit Harvest(msg.sender, _harvested);
974     }
975 
976     modifier notToZeroAddress(address _to) {
977         require(_to != address(0), "Invalid address!");
978         _;
979     }
980 }
