1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity =0.8.4;
4 
5 /**
6  * @dev Interface of the ERC20 standard as defined in the EIP.
7  */
8 interface IERC20 {
9     /**
10      * @dev Returns the amount of tokens in existence.
11      */
12     function totalSupply() external view returns (uint256);
13 
14     /**
15      * @dev Returns the amount of tokens owned by `account`.
16      */
17     function balanceOf(address account) external view returns (uint256);
18 
19     /**
20      * @dev Moves `amount` tokens from the caller's account to `recipient`.
21      *
22      * Returns a boolean value indicating whether the operation succeeded.
23      *
24      * Emits a {Transfer} event.
25      */
26     function transfer(address recipient, uint256 amount) external returns (bool);
27 
28     /**
29      * @dev Returns the remaining number of tokens that `spender` will be
30      * allowed to spend on behalf of `owner` through {transferFrom}. This is
31      * zero by default.
32      *
33      * This value changes when {approve} or {transferFrom} are called.
34      */
35     function allowance(address owner, address spender) external view returns (uint256);
36 
37     /**
38      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
39      *
40      * Returns a boolean value indicating whether the operation succeeded.
41      *
42      * IMPORTANT: Beware that changing an allowance with this method brings the risk
43      * that someone may use both the old and the new allowance by unfortunate
44      * transaction ordering. One possible solution to mitigate this race
45      * condition is to first reduce the spender's allowance to 0 and set the
46      * desired value afterwards:
47      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
48      *
49      * Emits an {Approval} event.
50      */
51     function approve(address spender, uint256 amount) external returns (bool);
52 
53     /**
54      * @dev Moves `amount` tokens from `sender` to `recipient` using the
55      * allowance mechanism. `amount` is then deducted from the caller's
56      * allowance.
57      *
58      * Returns a boolean value indicating whether the operation succeeded.
59      *
60      * Emits a {Transfer} event.
61      */
62     function transferFrom(
63         address sender,
64         address recipient,
65         uint256 amount
66     ) external returns (bool);
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
83 /**
84  * @dev Interface for the optional metadata functions from the ERC20 standard.
85  *
86  * _Available since v4.1._
87  */
88 interface IERC20Metadata is IERC20 {
89     /**
90      * @dev Returns the name of the token.
91      */
92     function name() external view returns (string memory);
93 
94     /**
95      * @dev Returns the symbol of the token.
96      */
97     function symbol() external view returns (string memory);
98 
99     /**
100      * @dev Returns the decimals places of the token.
101      */
102     function decimals() external view returns (uint8);
103 }
104 
105 /**
106  * @dev Collection of functions related to the address type
107  */
108 library Address {
109     /**
110      * @dev Returns true if `account` is a contract.
111      *
112      * [IMPORTANT]
113      * ====
114      * It is unsafe to assume that an address for which this function returns
115      * false is an externally-owned account (EOA) and not a contract.
116      *
117      * Among others, `isContract` will return false for the following
118      * types of addresses:
119      *
120      *  - an externally-owned account
121      *  - a contract in construction
122      *  - an address where a contract will be created
123      *  - an address where a contract lived, but was destroyed
124      * ====
125      */
126     function isContract(address account) internal view returns (bool) {
127         // This method relies on extcodesize, which returns 0 for contracts in
128         // construction, since the code is only stored at the end of the
129         // constructor execution.
130 
131         uint256 size;
132         assembly {
133             size := extcodesize(account)
134         }
135         return size > 0;
136     }
137 
138     /**
139      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
140      * `recipient`, forwarding all available gas and reverting on errors.
141      *
142      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
143      * of certain opcodes, possibly making contracts go over the 2300 gas limit
144      * imposed by `transfer`, making them unable to receive funds via
145      * `transfer`. {sendValue} removes this limitation.
146      *
147      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
148      *
149      * IMPORTANT: because control is transferred to `recipient`, care must be
150      * taken to not create reentrancy vulnerabilities. Consider using
151      * {ReentrancyGuard} or the
152      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
153      */
154     function sendValue(address payable recipient, uint256 amount) internal {
155         require(address(this).balance >= amount, "Address: insufficient balance");
156 
157         (bool success, ) = recipient.call{value: amount}("");
158         require(success, "Address: unable to send value, recipient may have reverted");
159     }
160 
161     /**
162      * @dev Performs a Solidity function call using a low level `call`. A
163      * plain`call` is an unsafe replacement for a function call: use this
164      * function instead.
165      *
166      * If `target` reverts with a revert reason, it is bubbled up by this
167      * function (like regular Solidity function calls).
168      *
169      * Returns the raw returned data. To convert to the expected return value,
170      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
171      *
172      * Requirements:
173      *
174      * - `target` must be a contract.
175      * - calling `target` with `data` must not revert.
176      *
177      * _Available since v3.1._
178      */
179     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
180         return functionCall(target, data, "Address: low-level call failed");
181     }
182 
183     /**
184      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
185      * `errorMessage` as a fallback revert reason when `target` reverts.
186      *
187      * _Available since v3.1._
188      */
189     function functionCall(
190         address target,
191         bytes memory data,
192         string memory errorMessage
193     ) internal returns (bytes memory) {
194         return functionCallWithValue(target, data, 0, errorMessage);
195     }
196 
197     /**
198      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
199      * but also transferring `value` wei to `target`.
200      *
201      * Requirements:
202      *
203      * - the calling contract must have an ETH balance of at least `value`.
204      * - the called Solidity function must be `payable`.
205      *
206      * _Available since v3.1._
207      */
208     function functionCallWithValue(
209         address target,
210         bytes memory data,
211         uint256 value
212     ) internal returns (bytes memory) {
213         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
214     }
215 
216     /**
217      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
218      * with `errorMessage` as a fallback revert reason when `target` reverts.
219      *
220      * _Available since v3.1._
221      */
222     function functionCallWithValue(
223         address target,
224         bytes memory data,
225         uint256 value,
226         string memory errorMessage
227     ) internal returns (bytes memory) {
228         require(address(this).balance >= value, "Address: insufficient balance for call");
229         require(isContract(target), "Address: call to non-contract");
230 
231         (bool success, bytes memory returndata) = target.call{value: value}(data);
232         return _verifyCallResult(success, returndata, errorMessage);
233     }
234 
235     /**
236      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
237      * but performing a static call.
238      *
239      * _Available since v3.3._
240      */
241     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
242         return functionStaticCall(target, data, "Address: low-level static call failed");
243     }
244 
245     /**
246      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
247      * but performing a static call.
248      *
249      * _Available since v3.3._
250      */
251     function functionStaticCall(
252         address target,
253         bytes memory data,
254         string memory errorMessage
255     ) internal view returns (bytes memory) {
256         require(isContract(target), "Address: static call to non-contract");
257 
258         (bool success, bytes memory returndata) = target.staticcall(data);
259         return _verifyCallResult(success, returndata, errorMessage);
260     }
261 
262     /**
263      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
264      * but performing a delegate call.
265      *
266      * _Available since v3.4._
267      */
268     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
269         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
270     }
271 
272     /**
273      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
274      * but performing a delegate call.
275      *
276      * _Available since v3.4._
277      */
278     function functionDelegateCall(
279         address target,
280         bytes memory data,
281         string memory errorMessage
282     ) internal returns (bytes memory) {
283         require(isContract(target), "Address: delegate call to non-contract");
284 
285         (bool success, bytes memory returndata) = target.delegatecall(data);
286         return _verifyCallResult(success, returndata, errorMessage);
287     }
288 
289     function _verifyCallResult(
290         bool success,
291         bytes memory returndata,
292         string memory errorMessage
293     ) private pure returns (bytes memory) {
294         if (success) {
295             return returndata;
296         } else {
297             // Look for revert reason and bubble it up if present
298             if (returndata.length > 0) {
299                 // The easiest way to bubble the revert reason is using memory via assembly
300 
301                 assembly {
302                     let returndata_size := mload(returndata)
303                     revert(add(32, returndata), returndata_size)
304                 }
305             } else {
306                 revert(errorMessage);
307             }
308         }
309     }
310 }
311 
312 /*
313  * @dev Provides information about the current execution context, including the
314  * sender of the transaction and its data. While these are generally available
315  * via msg.sender and msg.data, they should not be accessed in such a direct
316  * manner, since when dealing with meta-transactions the account sending and
317  * paying for execution may not be the actual sender (as far as an application
318  * is concerned).
319  *
320  * This contract is only required for intermediate, library-like contracts.
321  */
322 abstract contract Context {
323     function _msgSender() internal view virtual returns (address) {
324         return msg.sender;
325     }
326 
327     function _msgData() internal view virtual returns (bytes calldata) {
328         return msg.data;
329     }
330 }
331 
332 /**
333  * @dev Implementation of the {IERC20} interface.
334  *
335  * This implementation is agnostic to the way tokens are created. This means
336  * that a supply mechanism has to be added in a derived contract using {_mint}.
337  * For a generic mechanism see {ERC20PresetMinterPauser}.
338  *
339  * TIP: For a detailed writeup see our guide
340  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
341  * to implement supply mechanisms].
342  *
343  * We have followed general OpenZeppelin guidelines: functions revert instead
344  * of returning `false` on failure. This behavior is nonetheless conventional
345  * and does not conflict with the expectations of ERC20 applications.
346  *
347  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
348  * This allows applications to reconstruct the allowance for all accounts just
349  * by listening to said events. Other implementations of the EIP may not emit
350  * these events, as it isn't required by the specification.
351  *
352  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
353  * functions have been added to mitigate the well-known issues around setting
354  * allowances. See {IERC20-approve}.
355  */
356 contract ERC20 is Context, IERC20, IERC20Metadata {
357     mapping(address => uint256) private _balances;
358 
359     mapping(address => mapping(address => uint256)) private _allowances;
360 
361     uint256 private _totalSupply;
362 
363     string private _name;
364     string private _symbol;
365     uint8 private _decimals;
366 
367     /**
368      * @dev Sets the values for {name}, {symbol} and {desimals}.
369      *
370      * All two of these values are immutable: they can only be set once during
371      * construction.
372      */
373     constructor(string memory name_, string memory symbol_, uint8 decimals_) {
374         _name = name_;
375         _symbol = symbol_;
376         _decimals = decimals_;
377     }
378 
379     /**
380      * @dev Returns the name of the token.
381      */
382     function name() public view virtual override returns (string memory) {
383         return _name;
384     }
385 
386     /**
387      * @dev Returns the symbol of the token, usually a shorter version of the
388      * name.
389      */
390     function symbol() public view virtual override returns (string memory) {
391         return _symbol;
392     }
393 
394     /**
395      * @dev Returns the number of decimals used to get its user representation.
396      * For example, if `decimals` equals `2`, a balance of `505` tokens should
397      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
398      *
399      * NOTE: This information is only used for _display_ purposes: it in
400      * no way affects any of the arithmetic of the contract, including
401      * {IERC20-balanceOf} and {IERC20-transfer}.
402      */
403     function decimals() public view virtual override returns (uint8) {
404         return _decimals;
405     }
406 
407     /**
408      * @dev See {IERC20-totalSupply}.
409      */
410     function totalSupply() public view virtual override returns (uint256) {
411         return _totalSupply;
412     }
413 
414     /**
415      * @dev See {IERC20-balanceOf}.
416      */
417     function balanceOf(address account) public view virtual override returns (uint256) {
418         return _balances[account];
419     }
420 
421     /**
422      * @dev See {IERC20-transfer}.
423      *
424      * Requirements:
425      *
426      * - `recipient` cannot be the zero address.
427      * - the caller must have a balance of at least `amount`.
428      */
429     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
430         _transfer(_msgSender(), recipient, amount);
431         return true;
432     }
433 
434     /**
435      * @dev See {IERC20-allowance}.
436      */
437     function allowance(address owner, address spender) public view virtual override returns (uint256) {
438         return _allowances[owner][spender];
439     }
440 
441     /**
442      * @dev See {IERC20-approve}.
443      *
444      * Requirements:
445      *
446      * - `spender` cannot be the zero address.
447      */
448     function approve(address spender, uint256 amount) public virtual override returns (bool) {
449         _approve(_msgSender(), spender, amount);
450         return true;
451     }
452 
453     /**
454      * @dev See {IERC20-transferFrom}.
455      *
456      * Emits an {Approval} event indicating the updated allowance. This is not
457      * required by the EIP. See the note at the beginning of {ERC20}.
458      *
459      * Requirements:
460      *
461      * - `sender` and `recipient` cannot be the zero address.
462      * - `sender` must have a balance of at least `amount`.
463      * - the caller must have allowance for ``sender``'s tokens of at least
464      * `amount`.
465      */
466     function transferFrom(
467         address sender,
468         address recipient,
469         uint256 amount
470     ) public virtual override returns (bool) {
471         _transfer(sender, recipient, amount);
472 
473         uint256 currentAllowance = _allowances[sender][_msgSender()];
474         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
475         unchecked {
476             _approve(sender, _msgSender(), currentAllowance - amount);
477         }
478 
479         return true;
480     }
481 
482     /**
483      * @dev Atomically increases the allowance granted to `spender` by the caller.
484      *
485      * This is an alternative to {approve} that can be used as a mitigation for
486      * problems described in {IERC20-approve}.
487      *
488      * Emits an {Approval} event indicating the updated allowance.
489      *
490      * Requirements:
491      *
492      * - `spender` cannot be the zero address.
493      */
494     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
495         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
496         return true;
497     }
498 
499     /**
500      * @dev Atomically decreases the allowance granted to `spender` by the caller.
501      *
502      * This is an alternative to {approve} that can be used as a mitigation for
503      * problems described in {IERC20-approve}.
504      *
505      * Emits an {Approval} event indicating the updated allowance.
506      *
507      * Requirements:
508      *
509      * - `spender` cannot be the zero address.
510      * - `spender` must have allowance for the caller of at least
511      * `subtractedValue`.
512      */
513     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
514         uint256 currentAllowance = _allowances[_msgSender()][spender];
515         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
516         unchecked {
517             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
518         }
519 
520         return true;
521     }
522 
523     /**
524      * @dev Moves `amount` of tokens from `sender` to `recipient`.
525      *
526      * This internal function is equivalent to {transfer}, and can be used to
527      * e.g. implement automatic token fees, slashing mechanisms, etc.
528      *
529      * Emits a {Transfer} event.
530      *
531      * Requirements:
532      *
533      * - `sender` cannot be the zero address.
534      * - `recipient` cannot be the zero address.
535      * - `sender` must have a balance of at least `amount`.
536      */
537     function _transfer(
538         address sender,
539         address recipient,
540         uint256 amount
541     ) internal virtual {
542         require(sender != address(0), "ERC20: transfer from the zero address");
543         require(recipient != address(0), "ERC20: transfer to the zero address");
544 
545         _beforeTokenTransfer(sender, recipient, amount);
546 
547         uint256 senderBalance = _balances[sender];
548         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
549         unchecked {
550             _balances[sender] = senderBalance - amount;
551         }
552         _balances[recipient] += amount;
553 
554         emit Transfer(sender, recipient, amount);
555     }
556 
557     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
558      * the total supply.
559      *
560      * Emits a {Transfer} event with `from` set to the zero address.
561      *
562      * Requirements:
563      *
564      * - `account` cannot be the zero address.
565      */
566     function _mint(address account, uint256 amount) internal virtual {
567         require(account != address(0), "ERC20: mint to the zero address");
568 
569         _beforeTokenTransfer(address(0), account, amount);
570 
571         _totalSupply += amount;
572         _balances[account] += amount;
573         emit Transfer(address(0), account, amount);
574     }
575 
576     /**
577      * @dev Destroys `amount` tokens from `account`, reducing the
578      * total supply.
579      *
580      * Emits a {Transfer} event with `to` set to the zero address.
581      *
582      * Requirements:
583      *
584      * - `account` cannot be the zero address.
585      * - `account` must have at least `amount` tokens.
586      */
587     function _burn(address account, uint256 amount) internal virtual {
588         require(account != address(0), "ERC20: burn from the zero address");
589 
590         _beforeTokenTransfer(account, address(0), amount);
591 
592         uint256 accountBalance = _balances[account];
593         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
594         unchecked {
595             _balances[account] = accountBalance - amount;
596         }
597         _totalSupply -= amount;
598 
599         emit Transfer(account, address(0), amount);
600     }
601 
602     /**
603      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
604      *
605      * This internal function is equivalent to `approve`, and can be used to
606      * e.g. set automatic allowances for certain subsystems, etc.
607      *
608      * Emits an {Approval} event.
609      *
610      * Requirements:
611      *
612      * - `owner` cannot be the zero address.
613      * - `spender` cannot be the zero address.
614      */
615     function _approve(
616         address owner,
617         address spender,
618         uint256 amount
619     ) internal virtual {
620         require(owner != address(0), "ERC20: approve from the zero address");
621         require(spender != address(0), "ERC20: approve to the zero address");
622 
623         _allowances[owner][spender] = amount;
624         emit Approval(owner, spender, amount);
625     }
626 
627     /**
628      * @dev Hook that is called before any transfer of tokens. This includes
629      * minting and burning.
630      *
631      * Calling conditions:
632      *
633      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
634      * will be to transferred to `to`.
635      * - when `from` is zero, `amount` tokens will be minted for `to`.
636      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
637      * - `from` and `to` are never both zero.
638      *
639      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
640      */
641     function _beforeTokenTransfer(
642         address from,
643         address to,
644         uint256 amount
645     ) internal virtual {}
646 }
647 
648 /**
649  * @title SafeERC20
650  * @dev Wrappers around ERC20 operations that throw on failure (when the token
651  * contract returns false). Tokens that return no value (and instead revert or
652  * throw on failure) are also supported, non-reverting calls are assumed to be
653  * successful.
654  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
655  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
656  */
657 library SafeERC20 {
658     using Address for address;
659     
660     function validate(IERC20 token) internal view {
661         require(address(token).isContract(), "SafeERC20: not a contract");
662     }
663 
664     function safeTransfer(
665         IERC20 token,
666         address to,
667         uint256 value
668     ) internal {
669         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
670     }
671 
672     function safeTransferFrom(
673         IERC20 token,
674         address from,
675         address to,
676         uint256 value
677     ) internal {
678         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
679     }
680 
681     /**
682      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
683      * on the return value: the return value is optional (but if data is returned, it must not be false).
684      * @param token The token targeted by the call.
685      * @param data The call data (encoded using abi.encode or one of its variants).
686      */
687     function _callOptionalReturn(IERC20 token, bytes memory data) private {
688         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
689         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
690         // the target address contains contract code and also asserts for success in the low-level call.
691 
692         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
693         if (returndata.length > 0) {
694             // Return data is optional
695             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
696         }
697     }
698 }
699 
700 struct User {
701     uint256 totalOriginalTaken;
702     uint256 lastUpdateTick;
703     uint256 goldenBalance;
704     uint256 cooldownAmount;
705     uint256 cooldownTick;
706 }
707 
708 library UserLib {
709     function addCooldownAmount(User storage _user, uint256 _currentTick, uint256 _amount) internal {
710         if(_user.cooldownTick == _currentTick) {
711             _user.cooldownAmount += _amount;
712         } else {
713            _user.cooldownTick = _currentTick;
714            _user.cooldownAmount = _amount;
715         }
716     }
717 }
718 
719 struct Vesting {
720     uint256 totalAmount;
721     uint256 startBlock;
722     uint256 endBlock;
723 }
724 
725 library VestingLib {
726     function validate(Vesting storage _vesting) internal view {
727         require(_vesting.totalAmount > 0, "zero total vesting amount");
728         require(_vesting.startBlock < _vesting.endBlock, "invalid vesting blocks");
729     }
730     
731     function isInitialized(Vesting storage _vesting) internal view returns (bool) {
732         return _vesting.endBlock > 0;
733     }
734     
735     function currentTick(Vesting storage _vesting) internal view returns (uint256) {
736         if(_vesting.endBlock == 0) return 0; // vesting is not yet initialized
737         
738         if(block.number < _vesting.startBlock) return 0;
739             
740         if(block.number > _vesting.endBlock) {
741             return _vesting.endBlock - _vesting.startBlock + 1;
742         }
743 
744         return block.number - _vesting.startBlock + 1;
745     }
746     
747     function lastTick(Vesting storage _vesting) internal view returns (uint256) {
748         return _vesting.endBlock - _vesting.startBlock;
749     }
750     
751     function unlockAtATickAmount(Vesting storage _vesting) internal view returns (uint256) {
752         return _vesting.totalAmount / (_vesting.endBlock - _vesting.startBlock);
753     }
754 }
755 
756 struct Price {
757     address asset;
758     uint256 value;
759 }
760 
761 contract DeferredVestingPool is ERC20 {
762     using SafeERC20 for IERC20;
763     using SafeERC20 for IERC20Metadata;
764     using UserLib for User;
765     using VestingLib for Vesting;
766 
767     bool public isSalePaused_;
768     address public admin_;
769     address public revenueOwner_;
770     IERC20Metadata public originalToken_;
771     address public originalTokenOwner_;
772     uint256 public precisionDecimals_;
773     mapping(address => User) public users_;
774     mapping(address => uint256) public assets_;
775     Vesting public vesting_;
776     
777     string private constant ERR_AUTH_FAILED = "auth failed";
778     
779     event WithdrawCoin(address indexed msgSender, bool isMsgSenderAdmin, address indexed to, uint256 amount);
780     event WithdrawOriginalToken(address indexed msgSender, bool isMsgSenderAdmin, address indexed to, uint256 amount);
781     event SetPrice(address indexed asset, uint256 price);
782     event PauseCollateralizedSale(bool on);
783     event SetRevenueOwner(address indexed msgSender, address indexed newRevenueOwner);
784     event SetOriginalTokenOwner(address indexed msgSender, address indexed newOriginalTokenOwner);
785     event SwapToCollateralized(address indexed msgSender, address indexed fromAsset, uint256 fromAmount, uint256 toAmount, uint32 indexed refCode);
786     event SwapCollateralizedToOriginal(address indexed msgSender, uint256 amount);
787     
788     constructor(
789         string memory _name,
790         string memory _symbol,
791         address _admin,
792         address _revenueOwner,
793         IERC20Metadata _originalToken,
794         address _originalTokenOwner,
795         uint256 _precisionDecimals,
796         Price[] memory _prices) ERC20(_name, _symbol, _originalToken.decimals()) {
797             
798         _originalToken.validate();
799         
800         admin_ = _admin;
801         revenueOwner_ = _revenueOwner;
802         originalToken_ = _originalToken;
803         originalTokenOwner_ = _originalTokenOwner;
804         precisionDecimals_ = _precisionDecimals;
805         
806         emit SetRevenueOwner(_msgSender(), _revenueOwner);
807         emit SetOriginalTokenOwner(_msgSender(), _originalTokenOwner);
808         
809          for(uint32 i = 0; i < _prices.length; ++i) {
810             assets_[_prices[i].asset] = _prices[i].value;
811             emit SetPrice(_prices[i].asset, _prices[i].value);
812         }
813         
814         emit PauseCollateralizedSale(false);
815     }
816     
817     function totalOriginalBalance() external view returns (uint256) {
818         return originalToken_.balanceOf(address(this));
819     }
820     
821     function availableForSellCollateralizedAmount() public view returns (uint256) {
822         if(isSalePaused_) return 0;
823         
824         if(vesting_.isInitialized()) return 0;
825         
826         return originalToken_.balanceOf(address(this)) - totalSupply();
827     }
828     
829     function unusedCollateralAmount() public view returns (uint256) {
830         return originalToken_.balanceOf(address(this)) - totalSupply();
831     }
832     
833     modifier onlyAdmin() {
834         require(admin_ == _msgSender(), ERR_AUTH_FAILED);
835         _;
836     }
837     
838     function initializeVesting(uint256 _startBlock, uint256 _endBlock) external onlyAdmin {
839         require(!vesting_.isInitialized(), "already initialized");
840         
841         vesting_.totalAmount = totalSupply();
842         vesting_.startBlock = _startBlock;
843         vesting_.endBlock = _endBlock;
844 
845         vesting_.validate();
846     }
847     
848     function withdrawCoin(uint256 _amount) external onlyAdmin {
849         _withdrawCoin(payable(revenueOwner_), _amount);
850     }
851     
852     function withdrawOriginalToken(uint256 _amount) external onlyAdmin {
853         _withdrawOriginalToken(originalTokenOwner_, _amount);
854     }
855     
856     function setPrices(Price[] calldata _prices) external onlyAdmin {
857         for(uint32 i = 0; i < _prices.length; ++i) {
858             assets_[_prices[i].asset] = _prices[i].value;
859             emit SetPrice(_prices[i].asset, _prices[i].value);
860         }
861     }
862     
863     function pauseCollateralizedSale(bool _on) external onlyAdmin {
864         require(isSalePaused_ != _on);
865         isSalePaused_ = _on;
866         emit PauseCollateralizedSale(_on);
867     }
868     
869     modifier onlyRevenueOwner() {
870         require(revenueOwner_ == _msgSender(), ERR_AUTH_FAILED);
871         _;
872     }
873     
874     function setRevenueOwner(address _newRevenueOwner) external onlyRevenueOwner {
875         revenueOwner_ = _newRevenueOwner;
876         
877         emit SetRevenueOwner(_msgSender(), _newRevenueOwner);
878     }
879     
880     function withdrawCoin(address payable _to, uint256 _amount) external onlyRevenueOwner {
881         _withdrawCoin(_to, _amount);
882     }
883     
884     modifier onlyOriginalTokenOwner() {
885         require(originalTokenOwner_ == _msgSender(), ERR_AUTH_FAILED);
886         _;
887     }
888     
889     function setOriginalTokenOwner(address _newOriginalTokenOwner) external onlyOriginalTokenOwner {
890         originalTokenOwner_ = _newOriginalTokenOwner;
891         
892         emit SetOriginalTokenOwner(_msgSender(), _newOriginalTokenOwner);
893     }
894     
895     function withdrawOriginalToken(address _to, uint256 _amount) external onlyOriginalTokenOwner {
896         _withdrawOriginalToken(_to, _amount);
897     }
898     
899     function _withdrawCoin(address payable _to, uint256 _amount) private {
900         if(_amount == 0) {
901             _amount = address(this).balance;
902         }
903         
904         _to.transfer(_amount);
905         
906         emit WithdrawCoin(_msgSender(), _msgSender() == admin_, _to, _amount);
907     }
908     
909     function _withdrawOriginalToken(address _to, uint256 _amount) private {
910         uint256 maxWithdrawAmount = unusedCollateralAmount();
911         
912         if(_amount == 0) {
913             _amount = maxWithdrawAmount;
914         }
915         
916         require(_amount > 0, "zero withdraw amount");
917         require(_amount <= maxWithdrawAmount, "invalid withdraw amount");
918         
919         originalToken_.safeTransfer(_to, _amount);
920         
921         emit WithdrawOriginalToken(_msgSender(), _msgSender() == admin_, _to, _amount);
922     }
923     
924     function calcCollateralizedPrice(address _fromAsset, uint256 _fromAmount) public view
925         returns (uint256 toActualAmount_, uint256 fromActualAmount_) {
926 
927         require(_fromAmount > 0, "zero payment");
928         
929         uint256 fromAssetPrice = assets_[_fromAsset];
930         require(fromAssetPrice > 0, "asset not supported");
931         
932         if(isSalePaused_) return (0, 0);
933         
934         uint256 toAvailableForSell = availableForSellCollateralizedAmount();
935         uint256 oneOriginalToken = 10 ** originalToken_.decimals();
936         
937         fromActualAmount_ = _fromAmount;
938         toActualAmount_ = (_fromAmount * oneOriginalToken) / fromAssetPrice;
939         
940         if(toActualAmount_ > toAvailableForSell) {
941             toActualAmount_ = toAvailableForSell;
942             fromActualAmount_ = (toAvailableForSell * fromAssetPrice) / oneOriginalToken;
943         }
944     }
945     
946     function swapCoinToCollateralized(uint256 _toExpectedAmount, uint32 _refCode) external payable {
947         _swapToCollateralized(address(0), msg.value, _toExpectedAmount, _refCode);
948     }
949     
950     function swapTokenToCollateralized(IERC20 _fromAsset, uint256 _fromAmount, uint256 _toExpectedAmount, uint32 _refCode) external {
951         require(address(_fromAsset) != address(0), "wrong swap function");
952         
953         uint256 fromAmount = _fromAmount == 0 ? _fromAsset.allowance(_msgSender(), address(this)) : _fromAmount;
954         _fromAsset.safeTransferFrom(_msgSender(), revenueOwner_, fromAmount);
955         
956         _swapToCollateralized(address(_fromAsset), fromAmount, _toExpectedAmount, _refCode);
957     }
958     
959     function _swapToCollateralized(address _fromAsset, uint256 _fromAmount, uint256 _toExpectedAmount, uint32 _refCode) private {
960         require(!isSalePaused_, "swap paused");
961         require(!vesting_.isInitialized(), "can't do this after vesting init");
962         require(_toExpectedAmount > 0, "zero expected amount");
963         
964         (uint256 toActualAmount, uint256 fromActualAmount) = calcCollateralizedPrice(_fromAsset, _fromAmount);
965         
966         toActualAmount = _fixAmount(toActualAmount, _toExpectedAmount);
967             
968         require(_fromAmount >= fromActualAmount, "wrong payment amount");
969         
970         _mint(_msgSender(), toActualAmount);
971      
972         emit SwapToCollateralized(_msgSender(), _fromAsset, _fromAmount, toActualAmount, _refCode);
973     }
974     
975     function _fixAmount(uint256 _actual, uint256 _expected) private view returns (uint256) {
976         if(_expected < _actual) return _expected;
977         
978         require(_expected - _actual <= 10 ** precisionDecimals_, "expected amount mismatch");
979         
980         return _actual;
981     }
982     
983     function collateralizedBalance(address _userAddr) external view
984         returns (
985             uint256 blockNumber,
986             uint256 totalOriginalTakenAmount,
987             uint256 totalCollateralizedAmount,
988             uint256 goldenAmount,
989             uint256 grayAmount,
990             uint256 cooldownAmount) {
991 
992         uint256 currentTick = vesting_.currentTick();
993 
994         blockNumber = block.number;
995         totalOriginalTakenAmount = users_[_userAddr].totalOriginalTaken;
996         totalCollateralizedAmount = balanceOf(_userAddr);
997         goldenAmount = users_[_userAddr].goldenBalance + _calcNewGoldenAmount(_userAddr, currentTick);
998         grayAmount = totalCollateralizedAmount - goldenAmount;
999         cooldownAmount = _getCooldownAmount(users_[_userAddr], currentTick);
1000     }
1001 
1002     function swapCollateralizedToOriginal(uint256 _amount) external {
1003         address msgSender = _msgSender();
1004 
1005         _updateUserGoldenBalance(msgSender, vesting_.currentTick());
1006 
1007         User storage user = users_[msgSender];
1008 
1009         if(_amount == 0) _amount = user.goldenBalance;
1010 
1011         require(_amount > 0, "zero swap amount");
1012         require(_amount <= user.goldenBalance, "invalid amount");
1013 
1014         user.totalOriginalTaken += _amount;
1015         user.goldenBalance -= _amount;
1016 
1017         _burn(msgSender, _amount);
1018         originalToken_.safeTransfer(msgSender, _amount);
1019         
1020         emit SwapCollateralizedToOriginal(msgSender, _amount);
1021     }
1022 
1023     function _beforeTokenTransfer(address _from, address _to, uint256 _amount) internal virtual override {
1024         // mint or burn
1025         if(_from == address(0) || _to == address(0)) return;
1026 
1027         uint256 currentTick = vesting_.currentTick();
1028 
1029         _updateUserGoldenBalance(_from, currentTick);
1030         _updateUserGoldenBalance(_to, currentTick);
1031 
1032         User storage userTo = users_[_to];
1033         User storage userFrom = users_[_from];
1034 
1035         uint256 fromGoldenAmount = userFrom.goldenBalance;
1036         uint256 fromGrayAmount = balanceOf(_from) - fromGoldenAmount;
1037 
1038         // change cooldown amount of sender
1039         if(fromGrayAmount > 0
1040             && userFrom.cooldownTick == currentTick
1041             && userFrom.cooldownAmount > 0) {
1042 
1043             if(_getCooldownAmount(userFrom, currentTick) > _amount) {
1044                 userFrom.cooldownAmount -= _amount;
1045             } else {
1046                 userFrom.cooldownAmount = 0;
1047             }
1048         }
1049 
1050         if(_amount > fromGrayAmount) { // golden amount is also transfered
1051             uint256 transferGoldenAmount = _amount - fromGrayAmount;
1052             //require(transferGoldenAmount <= fromGoldenAmount, "math error");
1053             
1054             userTo.addCooldownAmount(currentTick, fromGrayAmount);
1055             
1056             userFrom.goldenBalance -= transferGoldenAmount;
1057             userTo.goldenBalance += transferGoldenAmount;
1058         } else { // only gray amount is transfered
1059             userTo.addCooldownAmount(currentTick, _amount);
1060         }
1061     }
1062 
1063     function _updateUserGoldenBalance(address _userAddr, uint256 _currentTick) private {
1064         if(_currentTick == 0) return;
1065         
1066         User storage user = users_[_userAddr];
1067         
1068         if(user.lastUpdateTick == vesting_.lastTick()) return;
1069 
1070         user.goldenBalance += _calcNewGoldenAmount(_userAddr, _currentTick);
1071         user.lastUpdateTick = _currentTick;
1072     }
1073 
1074     function _calcNewGoldenAmount(address _userAddr, uint256 _currentTick) private view returns (uint256) {
1075         if(_currentTick == 0) return 0;
1076         
1077         User storage user = users_[_userAddr];
1078 
1079         if(user.goldenBalance == balanceOf(_userAddr)) return 0;
1080 
1081         if(_currentTick >= vesting_.lastTick()) {
1082             return balanceOf(_userAddr) - user.goldenBalance;
1083         }
1084 
1085         uint256 result = balanceOf(_userAddr) - _getCooldownAmount(user, _currentTick) + user.totalOriginalTaken;
1086         result *= _currentTick - user.lastUpdateTick;
1087         result *= vesting_.unlockAtATickAmount();
1088         result /= vesting_.totalAmount;
1089         result = _min(result, balanceOf(_userAddr) - user.goldenBalance);
1090 
1091         return result;
1092     }
1093 
1094     function _getCooldownAmount(User storage _user, uint256 _currentTick) private view returns (uint256) {
1095         if(_currentTick >= vesting_.lastTick()) return 0;
1096 
1097         return _currentTick == _user.cooldownTick ? _user.cooldownAmount : 0;
1098     }
1099 
1100     function _min(uint256 a, uint256 b) private pure returns (uint256) {
1101         return a <= b ? a : b;
1102     }
1103 }