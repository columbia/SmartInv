1 /**
2  *Submitted for verification at BscScan.com on 2022-10-20
3 */
4 
5 // SPDX-License-Identifier: MIT
6 
7 pragma solidity ^0.8.0;
8 pragma experimental ABIEncoderV2;
9 
10 /**
11  * @dev Interface of the ERC20 standard as defined in the EIP.
12  */
13 interface IERC20 {
14     /**
15      * @dev Returns the amount of tokens in existence.
16      */
17     function totalSupply() external view returns (uint256);
18 
19     /**
20      * @dev Returns the amount of tokens owned by `account`.
21      */
22     function balanceOf(address account) external view returns (uint256);
23 
24     /**
25      * @dev Moves `amount` tokens from the caller's account to `recipient`.
26      *
27      * Returns a boolean value indicating whether the operation succeeded.
28      *
29      * Emits a {Transfer} event.
30      */
31     function transfer(address recipient, uint256 amount) external returns (bool);
32 
33     /**
34      * @dev Returns the remaining number of tokens that `spender` will be
35      * allowed to spend on behalf of `owner` through {transferFrom}. This is
36      * zero by default.
37      *
38      * This value changes when {approve} or {transferFrom} are called.
39      */
40     function allowance(address owner, address spender) external view returns (uint256);
41 
42     /**
43      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
44      *
45      * Returns a boolean value indicating whether the operation succeeded.
46      *
47      * IMPORTANT: Beware that changing an allowance with this method brings the risk
48      * that someone may use both the old and the new allowance by unfortunate
49      * transaction ordering. One possible solution to mitigate this race
50      * condition is to first reduce the spender's allowance to 0 and set the
51      * desired value afterwards:
52      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
53      *
54      * Emits an {Approval} event.
55      */
56     function approve(address spender, uint256 amount) external returns (bool);
57 
58     /**
59      * @dev Moves `amount` tokens from `sender` to `recipient` using the
60      * allowance mechanism. `amount` is then deducted from the caller's
61      * allowance.
62      *
63      * Returns a boolean value indicating whether the operation succeeded.
64      *
65      * Emits a {Transfer} event.
66      */
67     function transferFrom(
68         address sender,
69         address recipient,
70         uint256 amount
71     ) external returns (bool);
72 
73     /**
74      * @dev Emitted when `value` tokens are moved from one account (`from`) to
75      * another (`to`).
76      *
77      * Note that `value` may be zero.
78      */
79     event Transfer(address indexed from, address indexed to, uint256 value);
80 
81     /**
82      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
83      * a call to {approve}. `value` is the new allowance.
84      */
85     event Approval(address indexed owner, address indexed spender, uint256 value);
86 }
87 
88 /**
89  * @dev Collection of functions related to the address type
90  */
91 library Address {
92     /**
93      * @dev Returns true if `account` is a contract.
94      *
95      * [IMPORTANT]
96      * ====
97      * It is unsafe to assume that an address for which this function returns
98      * false is an externally-owned account (EOA) and not a contract.
99      *
100      * Among others, `isContract` will return false for the following
101      * types of addresses:
102      *
103      *  - an externally-owned account
104      *  - a contract in construction
105      *  - an address where a contract will be created
106      *  - an address where a contract lived, but was destroyed
107      * ====
108      */
109     function isContract(address account) internal view returns (bool) {
110         // This method relies on extcodesize, which returns 0 for contracts in
111         // construction, since the code is only stored at the end of the
112         // constructor execution.
113 
114         uint256 size;
115         assembly {
116             size := extcodesize(account)
117         }
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
140         (bool success, ) = recipient.call{value: amount}("");
141         require(success, "Address: unable to send value, recipient may have reverted");
142     }
143 
144     /**
145      * @dev Performs a Solidity function call using a low level `call`. A
146      * plain `call` is an unsafe replacement for a function call: use this
147      * function instead.
148      *
149      * If `target` reverts with a revert reason, it is bubbled up by this
150      * function (like regular Solidity function calls).
151      *
152      * Returns the raw returned data. To convert to the expected return value,
153      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
154      *
155      * Requirements:
156      *
157      * - `target` must be a contract.
158      * - calling `target` with `data` must not revert.
159      *
160      * _Available since v3.1._
161      */
162     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
163         return functionCall(target, data, "Address: low-level call failed");
164     }
165 
166     /**
167      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
168      * `errorMessage` as a fallback revert reason when `target` reverts.
169      *
170      * _Available since v3.1._
171      */
172     function functionCall(
173         address target,
174         bytes memory data,
175         string memory errorMessage
176     ) internal returns (bytes memory) {
177         return functionCallWithValue(target, data, 0, errorMessage);
178     }
179 
180     /**
181      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
182      * but also transferring `value` wei to `target`.
183      *
184      * Requirements:
185      *
186      * - the calling contract must have an ETH balance of at least `value`.
187      * - the called Solidity function must be `payable`.
188      *
189      * _Available since v3.1._
190      */
191     function functionCallWithValue(
192         address target,
193         bytes memory data,
194         uint256 value
195     ) internal returns (bytes memory) {
196         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
197     }
198 
199     /**
200      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
201      * with `errorMessage` as a fallback revert reason when `target` reverts.
202      *
203      * _Available since v3.1._
204      */
205     function functionCallWithValue(
206         address target,
207         bytes memory data,
208         uint256 value,
209         string memory errorMessage
210     ) internal returns (bytes memory) {
211         require(address(this).balance >= value, "Address: insufficient balance for call");
212         require(isContract(target), "Address: call to non-contract");
213 
214         (bool success, bytes memory returndata) = target.call{value: value}(data);
215         return verifyCallResult(success, returndata, errorMessage);
216     }
217 
218     /**
219      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
220      * but performing a static call.
221      *
222      * _Available since v3.3._
223      */
224     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
225         return functionStaticCall(target, data, "Address: low-level static call failed");
226     }
227 
228     /**
229      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
230      * but performing a static call.
231      *
232      * _Available since v3.3._
233      */
234     function functionStaticCall(
235         address target,
236         bytes memory data,
237         string memory errorMessage
238     ) internal view returns (bytes memory) {
239         require(isContract(target), "Address: static call to non-contract");
240 
241         (bool success, bytes memory returndata) = target.staticcall(data);
242         return verifyCallResult(success, returndata, errorMessage);
243     }
244 
245     /**
246      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
247      * but performing a delegate call.
248      *
249      * _Available since v3.4._
250      */
251     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
252         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
253     }
254 
255     /**
256      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
257      * but performing a delegate call.
258      *
259      * _Available since v3.4._
260      */
261     function functionDelegateCall(
262         address target,
263         bytes memory data,
264         string memory errorMessage
265     ) internal returns (bytes memory) {
266         require(isContract(target), "Address: delegate call to non-contract");
267 
268         (bool success, bytes memory returndata) = target.delegatecall(data);
269         return verifyCallResult(success, returndata, errorMessage);
270     }
271 
272     /**
273      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
274      * revert reason using the provided one.
275      *
276      * _Available since v4.3._
277      */
278     function verifyCallResult(
279         bool success,
280         bytes memory returndata,
281         string memory errorMessage
282     ) internal pure returns (bytes memory) {
283         if (success) {
284             return returndata;
285         } else {
286             // Look for revert reason and bubble it up if present
287             if (returndata.length > 0) {
288                 // The easiest way to bubble the revert reason is using memory via assembly
289 
290                 assembly {
291                     let returndata_size := mload(returndata)
292                     revert(add(32, returndata), returndata_size)
293                 }
294             } else {
295                 revert(errorMessage);
296             }
297         }
298     }
299 }
300 
301 /**
302  * @title SafeERC20
303  * @dev Wrappers around ERC20 operations that throw on failure (when the token
304  * contract returns false). Tokens that return no value (and instead revert or
305  * throw on failure) are also supported, non-reverting calls are assumed to be
306  * successful.
307  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
308  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
309  */
310 library SafeERC20 {
311     using Address for address;
312 
313     function safeTransfer(
314         IERC20 token,
315         address to,
316         uint256 value
317     ) internal {
318         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
319     }
320 
321     function safeTransferFrom(
322         IERC20 token,
323         address from,
324         address to,
325         uint256 value
326     ) internal {
327         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
328     }
329 
330     /**
331      * @dev Deprecated. This function has issues similar to the ones found in
332      * {IERC20-approve}, and its usage is discouraged.
333      *
334      * Whenever possible, use {safeIncreaseAllowance} and
335      * {safeDecreaseAllowance} instead.
336      */
337     function safeApprove(
338         IERC20 token,
339         address spender,
340         uint256 value
341     ) internal {
342         // safeApprove should only be called when setting an initial allowance,
343         // or when resetting it to zero. To increase and decrease it, use
344         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
345         require(
346             (value == 0) || (token.allowance(address(this), spender) == 0),
347             "SafeERC20: approve from non-zero to non-zero allowance"
348         );
349         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
350     }
351 
352     function safeIncreaseAllowance(
353         IERC20 token,
354         address spender,
355         uint256 value
356     ) internal {
357         uint256 newAllowance = token.allowance(address(this), spender) + value;
358         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
359     }
360 
361     function safeDecreaseAllowance(
362         IERC20 token,
363         address spender,
364         uint256 value
365     ) internal {
366         unchecked {
367             uint256 oldAllowance = token.allowance(address(this), spender);
368             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
369             uint256 newAllowance = oldAllowance - value;
370             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
371         }
372     }
373 
374     /**
375      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
376      * on the return value: the return value is optional (but if data is returned, it must not be false).
377      * @param token The token targeted by the call.
378      * @param data The call data (encoded using abi.encode or one of its variants).
379      */
380     function _callOptionalReturn(IERC20 token, bytes memory data) private {
381         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
382         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
383         // the target address contains contract code and also asserts for success in the low-level call.
384 
385         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
386         if (returndata.length > 0) {
387             // Return data is optional
388             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
389         }
390     }
391 }
392 
393 /**
394  * @dev Interface for the optional metadata functions from the ERC20 standard.
395  *
396  * _Available since v4.1._
397  */
398 interface IERC20Metadata is IERC20 {
399     /**
400      * @dev Returns the name of the token.
401      */
402     function name() external view returns (string memory);
403 
404     /**
405      * @dev Returns the symbol of the token.
406      */
407     function symbol() external view returns (string memory);
408 
409     /**
410      * @dev Returns the decimals places of the token.
411      */
412     function decimals() external view returns (uint8);
413 }
414 
415 /**
416  * @dev Provides information about the current execution context, including the
417  * sender of the transaction and its data. While these are generally available
418  * via msg.sender and msg.data, they should not be accessed in such a direct
419  * manner, since when dealing with meta-transactions the account sending and
420  * paying for execution may not be the actual sender (as far as an application
421  * is concerned).
422  *
423  * This contract is only required for intermediate, library-like contracts.
424  */
425 abstract contract Context {
426     function _msgSender() internal view virtual returns (address) {
427         return msg.sender;
428     }
429 
430     function _msgData() internal view virtual returns (bytes calldata) {
431         return msg.data;
432     }
433 }
434 
435 /**
436  * @dev Implementation of the {IERC20} interface.
437  *
438  * This implementation is agnostic to the way tokens are created. This means
439  * that a supply mechanism has to be added in a derived contract using {_mint}.
440  * For a generic mechanism see {ERC20PresetMinterPauser}.
441  *
442  * TIP: For a detailed writeup see our guide
443  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
444  * to implement supply mechanisms].
445  *
446  * We have followed general OpenZeppelin Contracts guidelines: functions revert
447  * instead returning `false` on failure. This behavior is nonetheless
448  * conventional and does not conflict with the expectations of ERC20
449  * applications.
450  *
451  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
452  * This allows applications to reconstruct the allowance for all accounts just
453  * by listening to said events. Other implementations of the EIP may not emit
454  * these events, as it isn't required by the specification.
455  *
456  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
457  * functions have been added to mitigate the well-known issues around setting
458  * allowances. See {IERC20-approve}.
459  */
460 contract ERC20 is Context, IERC20, IERC20Metadata {
461     mapping(address => uint256) private _balances;
462 
463     mapping(address => mapping(address => uint256)) private _allowances;
464 
465     uint256 private _totalSupply;
466 
467     string private _name;
468     string private _symbol;
469 
470     /**
471      * @dev Sets the values for {name} and {symbol}.
472      *
473      * The default value of {decimals} is 18. To select a different value for
474      * {decimals} you should overload it.
475      *
476      * All two of these values are immutable: they can only be set once during
477      * construction.
478      */
479     constructor(string memory name_, string memory symbol_) {
480         _name = name_;
481         _symbol = symbol_;
482     }
483 
484     /**
485      * @dev Returns the name of the token.
486      */
487     function name() public view virtual override returns (string memory) {
488         return _name;
489     }
490 
491     /**
492      * @dev Returns the symbol of the token, usually a shorter version of the
493      * name.
494      */
495     function symbol() public view virtual override returns (string memory) {
496         return _symbol;
497     }
498 
499     /**
500      * @dev Returns the number of decimals used to get its user representation.
501      * For example, if `decimals` equals `2`, a balance of `505` tokens should
502      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
503      *
504      * Tokens usually opt for a value of 18, imitating the relationship between
505      * Ether and Wei. This is the value {ERC20} uses, unless this function is
506      * overridden;
507      *
508      * NOTE: This information is only used for _display_ purposes: it in
509      * no way affects any of the arithmetic of the contract, including
510      * {IERC20-balanceOf} and {IERC20-transfer}.
511      */
512     function decimals() public view virtual override returns (uint8) {
513         return 18;
514     }
515 
516     /**
517      * @dev See {IERC20-totalSupply}.
518      */
519     function totalSupply() public view virtual override returns (uint256) {
520         return _totalSupply;
521     }
522 
523     /**
524      * @dev See {IERC20-balanceOf}.
525      */
526     function balanceOf(address account) public view virtual override returns (uint256) {
527         return _balances[account];
528     }
529 
530     /**
531      * @dev See {IERC20-transfer}.
532      *
533      * Requirements:
534      *
535      * - `recipient` cannot be the zero address.
536      * - the caller must have a balance of at least `amount`.
537      */
538     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
539         _transfer(_msgSender(), recipient, amount);
540         return true;
541     }
542 
543     /**
544      * @dev See {IERC20-allowance}.
545      */
546     function allowance(address owner, address spender) public view virtual override returns (uint256) {
547         return _allowances[owner][spender];
548     }
549 
550     /**
551      * @dev See {IERC20-approve}.
552      *
553      * Requirements:
554      *
555      * - `spender` cannot be the zero address.
556      */
557     function approve(address spender, uint256 amount) public virtual override returns (bool) {
558         _approve(_msgSender(), spender, amount);
559         return true;
560     }
561 
562     /**
563      * @dev See {IERC20-transferFrom}.
564      *
565      * Emits an {Approval} event indicating the updated allowance. This is not
566      * required by the EIP. See the note at the beginning of {ERC20}.
567      *
568      * Requirements:
569      *
570      * - `sender` and `recipient` cannot be the zero address.
571      * - `sender` must have a balance of at least `amount`.
572      * - the caller must have allowance for ``sender``'s tokens of at least
573      * `amount`.
574      */
575     function transferFrom(
576         address sender,
577         address recipient,
578         uint256 amount
579     ) public virtual override returns (bool) {
580         _transfer(sender, recipient, amount);
581 
582         uint256 currentAllowance = _allowances[sender][_msgSender()];
583         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
584         unchecked {
585             _approve(sender, _msgSender(), currentAllowance - amount);
586         }
587 
588         return true;
589     }
590 
591     /**
592      * @dev Atomically increases the allowance granted to `spender` by the caller.
593      *
594      * This is an alternative to {approve} that can be used as a mitigation for
595      * problems described in {IERC20-approve}.
596      *
597      * Emits an {Approval} event indicating the updated allowance.
598      *
599      * Requirements:
600      *
601      * - `spender` cannot be the zero address.
602      */
603     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
604         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
605         return true;
606     }
607 
608     /**
609      * @dev Atomically decreases the allowance granted to `spender` by the caller.
610      *
611      * This is an alternative to {approve} that can be used as a mitigation for
612      * problems described in {IERC20-approve}.
613      *
614      * Emits an {Approval} event indicating the updated allowance.
615      *
616      * Requirements:
617      *
618      * - `spender` cannot be the zero address.
619      * - `spender` must have allowance for the caller of at least
620      * `subtractedValue`.
621      */
622     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
623         uint256 currentAllowance = _allowances[_msgSender()][spender];
624         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
625         unchecked {
626             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
627         }
628 
629         return true;
630     }
631 
632     /**
633      * @dev Moves `amount` of tokens from `sender` to `recipient`.
634      *
635      * This internal function is equivalent to {transfer}, and can be used to
636      * e.g. implement automatic token fees, slashing mechanisms, etc.
637      *
638      * Emits a {Transfer} event.
639      *
640      * Requirements:
641      *
642      * - `sender` cannot be the zero address.
643      * - `recipient` cannot be the zero address.
644      * - `sender` must have a balance of at least `amount`.
645      */
646     function _transfer(
647         address sender,
648         address recipient,
649         uint256 amount
650     ) internal virtual {
651         require(sender != address(0), "ERC20: transfer from the zero address");
652         require(recipient != address(0), "ERC20: transfer to the zero address");
653 
654         _beforeTokenTransfer(sender, recipient, amount);
655 
656         uint256 senderBalance = _balances[sender];
657         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
658         unchecked {
659             _balances[sender] = senderBalance - amount;
660         }
661         _balances[recipient] += amount;
662 
663         emit Transfer(sender, recipient, amount);
664 
665         _afterTokenTransfer(sender, recipient, amount);
666     }
667 
668     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
669      * the total supply.
670      *
671      * Emits a {Transfer} event with `from` set to the zero address.
672      *
673      * Requirements:
674      *
675      * - `account` cannot be the zero address.
676      */
677     function _mint(address account, uint256 amount) internal virtual {
678         require(account != address(0), "ERC20: mint to the zero address");
679 
680         _beforeTokenTransfer(address(0), account, amount);
681 
682         _totalSupply += amount;
683         _balances[account] += amount;
684         emit Transfer(address(0), account, amount);
685 
686         _afterTokenTransfer(address(0), account, amount);
687     }
688 
689     /**
690      * @dev Destroys `amount` tokens from `account`, reducing the
691      * total supply.
692      *
693      * Emits a {Transfer} event with `to` set to the zero address.
694      *
695      * Requirements:
696      *
697      * - `account` cannot be the zero address.
698      * - `account` must have at least `amount` tokens.
699      */
700     function _burn(address account, uint256 amount) internal virtual {
701         require(account != address(0), "ERC20: burn from the zero address");
702 
703         _beforeTokenTransfer(account, address(0), amount);
704 
705         uint256 accountBalance = _balances[account];
706         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
707         unchecked {
708             _balances[account] = accountBalance - amount;
709         }
710         _totalSupply -= amount;
711 
712         emit Transfer(account, address(0), amount);
713 
714         _afterTokenTransfer(account, address(0), amount);
715     }
716 
717     /**
718      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
719      *
720      * This internal function is equivalent to `approve`, and can be used to
721      * e.g. set automatic allowances for certain subsystems, etc.
722      *
723      * Emits an {Approval} event.
724      *
725      * Requirements:
726      *
727      * - `owner` cannot be the zero address.
728      * - `spender` cannot be the zero address.
729      */
730     function _approve(
731         address owner,
732         address spender,
733         uint256 amount
734     ) internal virtual {
735         require(owner != address(0), "ERC20: approve from the zero address");
736         require(spender != address(0), "ERC20: approve to the zero address");
737 
738         _allowances[owner][spender] = amount;
739         emit Approval(owner, spender, amount);
740     }
741 
742     /**
743      * @dev Hook that is called before any transfer of tokens. This includes
744      * minting and burning.
745      *
746      * Calling conditions:
747      *
748      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
749      * will be transferred to `to`.
750      * - when `from` is zero, `amount` tokens will be minted for `to`.
751      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
752      * - `from` and `to` are never both zero.
753      *
754      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
755      */
756     function _beforeTokenTransfer(
757         address from,
758         address to,
759         uint256 amount
760     ) internal virtual {}
761 
762     /**
763      * @dev Hook that is called after any transfer of tokens. This includes
764      * minting and burning.
765      *
766      * Calling conditions:
767      *
768      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
769      * has been transferred to `to`.
770      * - when `from` is zero, `amount` tokens have been minted for `to`.
771      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
772      * - `from` and `to` are never both zero.
773      *
774      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
775      */
776     function _afterTokenTransfer(
777         address from,
778         address to,
779         uint256 amount
780     ) internal virtual {}
781 }
782 
783 /**
784  * @dev Contract module which provides a basic access control mechanism, where
785  * there is an account (an owner) that can be granted exclusive access to
786  * specific functions.
787  *
788  * By default, the owner account will be the one that deploys the contract. This
789  * can later be changed with {transferOwnership}.
790  *
791  * This module is used through inheritance. It will make available the modifier
792  * `onlyOwner`, which can be applied to your functions to restrict their use to
793  * the owner.
794  */
795 abstract contract Ownable is Context {
796     address private _owner;
797 
798     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
799 
800     /**
801      * @dev Initializes the contract setting the deployer as the initial owner.
802      */
803     constructor() {
804         _setOwner(_msgSender());
805     }
806 
807     /**
808      * @dev Returns the address of the current owner.
809      */
810     function owner() public view virtual returns (address) {
811         return _owner;
812     }
813 
814     /**
815      * @dev Throws if called by any account other than the owner.
816      */
817     modifier onlyOwner() {
818         require(owner() == _msgSender(), "Ownable: caller is not the owner");
819         _;
820     }
821 
822     /**
823      * @dev Leaves the contract without owner. It will not be possible to call
824      * `onlyOwner` functions anymore. Can only be called by the current owner.
825      *
826      * NOTE: Renouncing ownership will leave the contract without an owner,
827      * thereby removing any functionality that is only available to the owner.
828      */
829     function renounceOwnership() public virtual onlyOwner {
830         _setOwner(address(0));
831     }
832 
833     /**
834      * @dev Transfers ownership of the contract to a new account (`newOwner`).
835      * Can only be called by the current owner.
836      */
837     function transferOwnership(address newOwner) public virtual onlyOwner {
838         require(newOwner != address(0), "Ownable: new owner is the zero address");
839         _setOwner(newOwner);
840     }
841 
842     function _setOwner(address newOwner) private {
843         address oldOwner = _owner;
844         _owner = newOwner;
845         emit OwnershipTransferred(oldOwner, newOwner);
846     }
847 }
848 
849 /**
850  * @dev External interface of AccessControl declared to support ERC165 detection.
851  */
852 interface IAccessControl {
853     /**
854      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
855      *
856      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
857      * {RoleAdminChanged} not being emitted signaling this.
858      *
859      * _Available since v3.1._
860      */
861     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
862 
863     /**
864      * @dev Emitted when `account` is granted `role`.
865      *
866      * `sender` is the account that originated the contract call, an admin role
867      * bearer except when using {AccessControl-_setupRole}.
868      */
869     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
870 
871     /**
872      * @dev Emitted when `account` is revoked `role`.
873      *
874      * `sender` is the account that originated the contract call:
875      *   - if using `revokeRole`, it is the admin role bearer
876      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
877      */
878     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
879 
880     /**
881      * @dev Returns `true` if `account` has been granted `role`.
882      */
883     function hasRole(bytes32 role, address account) external view returns (bool);
884 
885     /**
886      * @dev Returns the admin role that controls `role`. See {grantRole} and
887      * {revokeRole}.
888      *
889      * To change a role's admin, use {AccessControl-_setRoleAdmin}.
890      */
891     function getRoleAdmin(bytes32 role) external view returns (bytes32);
892 
893     /**
894      * @dev Grants `role` to `account`.
895      *
896      * If `account` had not been already granted `role`, emits a {RoleGranted}
897      * event.
898      *
899      * Requirements:
900      *
901      * - the caller must have ``role``'s admin role.
902      */
903     function grantRole(bytes32 role, address account) external;
904 
905     /**
906      * @dev Revokes `role` from `account`.
907      *
908      * If `account` had been granted `role`, emits a {RoleRevoked} event.
909      *
910      * Requirements:
911      *
912      * - the caller must have ``role``'s admin role.
913      */
914     function revokeRole(bytes32 role, address account) external;
915 
916     /**
917      * @dev Revokes `role` from the calling account.
918      *
919      * Roles are often managed via {grantRole} and {revokeRole}: this function's
920      * purpose is to provide a mechanism for accounts to lose their privileges
921      * if they are compromised (such as when a trusted device is misplaced).
922      *
923      * If the calling account had been granted `role`, emits a {RoleRevoked}
924      * event.
925      *
926      * Requirements:
927      *
928      * - the caller must be `account`.
929      */
930     function renounceRole(bytes32 role, address account) external;
931 }
932 
933 /**
934  * @dev String operations.
935  */
936 library Strings {
937     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
938 
939     /**
940      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
941      */
942     function toString(uint256 value) internal pure returns (string memory) {
943         // Inspired by OraclizeAPI's implementation - MIT licence
944         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
945 
946         if (value == 0) {
947             return "0";
948         }
949         uint256 temp = value;
950         uint256 digits;
951         while (temp != 0) {
952             digits++;
953             temp /= 10;
954         }
955         bytes memory buffer = new bytes(digits);
956         while (value != 0) {
957             digits -= 1;
958             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
959             value /= 10;
960         }
961         return string(buffer);
962     }
963 
964     /**
965      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
966      */
967     function toHexString(uint256 value) internal pure returns (string memory) {
968         if (value == 0) {
969             return "0x00";
970         }
971         uint256 temp = value;
972         uint256 length = 0;
973         while (temp != 0) {
974             length++;
975             temp >>= 8;
976         }
977         return toHexString(value, length);
978     }
979 
980     /**
981      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
982      */
983     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
984         bytes memory buffer = new bytes(2 * length + 2);
985         buffer[0] = "0";
986         buffer[1] = "x";
987         for (uint256 i = 2 * length + 1; i > 1; --i) {
988             buffer[i] = _HEX_SYMBOLS[value & 0xf];
989             value >>= 4;
990         }
991         require(value == 0, "Strings: hex length insufficient");
992         return string(buffer);
993     }
994 }
995 
996 /**
997  * @dev Interface of the ERC165 standard, as defined in the
998  * https://eips.ethereum.org/EIPS/eip-165[EIP].
999  *
1000  * Implementers can declare support of contract interfaces, which can then be
1001  * queried by others ({ERC165Checker}).
1002  *
1003  * For an implementation, see {ERC165}.
1004  */
1005 interface IERC165 {
1006     /**
1007      * @dev Returns true if this contract implements the interface defined by
1008      * `interfaceId`. See the corresponding
1009      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
1010      * to learn more about how these ids are created.
1011      *
1012      * This function call must use less than 30 000 gas.
1013      */
1014     function supportsInterface(bytes4 interfaceId) external view returns (bool);
1015 }
1016 
1017 /**
1018  * @dev Implementation of the {IERC165} interface.
1019  *
1020  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
1021  * for the additional interface id that will be supported. For example:
1022  *
1023  * ```solidity
1024  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1025  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
1026  * }
1027  * ```
1028  *
1029  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
1030  */
1031 abstract contract ERC165 is IERC165 {
1032     /**
1033      * @dev See {IERC165-supportsInterface}.
1034      */
1035     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1036         return interfaceId == type(IERC165).interfaceId;
1037     }
1038 }
1039 /**
1040  * @dev Contract module that allows children to implement role-based access
1041  * control mechanisms. This is a lightweight version that doesn't allow enumerating role
1042  * members except through off-chain means by accessing the contract event logs. Some
1043  * applications may benefit from on-chain enumerability, for those cases see
1044  * {AccessControlEnumerable}.
1045  *
1046  * Roles are referred to by their `bytes32` identifier. These should be exposed
1047  * in the external API and be unique. The best way to achieve this is by
1048  * using `public constant` hash digests:
1049  *
1050  * ```
1051  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
1052  * ```
1053  *
1054  * Roles can be used to represent a set of permissions. To restrict access to a
1055  * function call, use {hasRole}:
1056  *
1057  * ```
1058  * function foo() public {
1059  *     require(hasRole(MY_ROLE, msg.sender));
1060  *     ...
1061  * }
1062  * ```
1063  *
1064  * Roles can be granted and revoked dynamically via the {grantRole} and
1065  * {revokeRole} functions. Each role has an associated admin role, and only
1066  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
1067  *
1068  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
1069  * that only accounts with this role will be able to grant or revoke other
1070  * roles. More complex role relationships can be created by using
1071  * {_setRoleAdmin}.
1072  *
1073  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
1074  * grant and revoke this role. Extra precautions should be taken to secure
1075  * accounts that have been granted it.
1076  */
1077 abstract contract AccessControl is Context, IAccessControl, ERC165 {
1078     struct RoleData {
1079         mapping(address => bool) members;
1080         bytes32 adminRole;
1081     }
1082 
1083     mapping(bytes32 => RoleData) private _roles;
1084 
1085     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
1086 
1087     /**
1088      * @dev Modifier that checks that an account has a specific role. Reverts
1089      * with a standardized message including the required role.
1090      *
1091      * The format of the revert reason is given by the following regular expression:
1092      *
1093      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
1094      *
1095      * _Available since v4.1._
1096      */
1097     modifier onlyRole(bytes32 role) {
1098         _checkRole(role, _msgSender());
1099         _;
1100     }
1101 
1102     /**
1103      * @dev See {IERC165-supportsInterface}.
1104      */
1105     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1106         return interfaceId == type(IAccessControl).interfaceId || super.supportsInterface(interfaceId);
1107     }
1108 
1109     /**
1110      * @dev Returns `true` if `account` has been granted `role`.
1111      */
1112     function hasRole(bytes32 role, address account) public view override returns (bool) {
1113         return _roles[role].members[account];
1114     }
1115 
1116     /**
1117      * @dev Revert with a standard message if `account` is missing `role`.
1118      *
1119      * The format of the revert reason is given by the following regular expression:
1120      *
1121      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
1122      */
1123     function _checkRole(bytes32 role, address account) internal view {
1124         if (!hasRole(role, account)) {
1125             revert(
1126                 string(
1127                     abi.encodePacked(
1128                         "AccessControl: account ",
1129                         Strings.toHexString(uint160(account), 20),
1130                         " is missing role ",
1131                         Strings.toHexString(uint256(role), 32)
1132                     )
1133                 )
1134             );
1135         }
1136     }
1137 
1138     /**
1139      * @dev Returns the admin role that controls `role`. See {grantRole} and
1140      * {revokeRole}.
1141      *
1142      * To change a role's admin, use {_setRoleAdmin}.
1143      */
1144     function getRoleAdmin(bytes32 role) public view override returns (bytes32) {
1145         return _roles[role].adminRole;
1146     }
1147 
1148     /**
1149      * @dev Grants `role` to `account`.
1150      *
1151      * If `account` had not been already granted `role`, emits a {RoleGranted}
1152      * event.
1153      *
1154      * Requirements:
1155      *
1156      * - the caller must have ``role``'s admin role.
1157      */
1158     function grantRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
1159         _grantRole(role, account);
1160     }
1161 
1162     /**
1163      * @dev Revokes `role` from `account`.
1164      *
1165      * If `account` had been granted `role`, emits a {RoleRevoked} event.
1166      *
1167      * Requirements:
1168      *
1169      * - the caller must have ``role``'s admin role.
1170      */
1171     function revokeRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
1172         _revokeRole(role, account);
1173     }
1174 
1175     /**
1176      * @dev Revokes `role` from the calling account.
1177      *
1178      * Roles are often managed via {grantRole} and {revokeRole}: this function's
1179      * purpose is to provide a mechanism for accounts to lose their privileges
1180      * if they are compromised (such as when a trusted device is misplaced).
1181      *
1182      * If the calling account had been granted `role`, emits a {RoleRevoked}
1183      * event.
1184      *
1185      * Requirements:
1186      *
1187      * - the caller must be `account`.
1188      */
1189     function renounceRole(bytes32 role, address account) public virtual override {
1190         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
1191 
1192         _revokeRole(role, account);
1193     }
1194 
1195     /**
1196      * @dev Grants `role` to `account`.
1197      *
1198      * If `account` had not been already granted `role`, emits a {RoleGranted}
1199      * event. Note that unlike {grantRole}, this function doesn't perform any
1200      * checks on the calling account.
1201      *
1202      * [WARNING]
1203      * ====
1204      * This function should only be called from the constructor when setting
1205      * up the initial roles for the system.
1206      *
1207      * Using this function in any other way is effectively circumventing the admin
1208      * system imposed by {AccessControl}.
1209      * ====
1210      */
1211     function _setupRole(bytes32 role, address account) internal virtual {
1212         _grantRole(role, account);
1213     }
1214 
1215     /**
1216      * @dev Sets `adminRole` as ``role``'s admin role.
1217      *
1218      * Emits a {RoleAdminChanged} event.
1219      */
1220     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
1221         bytes32 previousAdminRole = getRoleAdmin(role);
1222         _roles[role].adminRole = adminRole;
1223         emit RoleAdminChanged(role, previousAdminRole, adminRole);
1224     }
1225 
1226     function _grantRole(bytes32 role, address account) private {
1227         if (!hasRole(role, account)) {
1228             _roles[role].members[account] = true;
1229             emit RoleGranted(role, account, _msgSender());
1230         }
1231     }
1232 
1233     function _revokeRole(bytes32 role, address account) private {
1234         if (hasRole(role, account)) {
1235             _roles[role].members[account] = false;
1236             emit RoleRevoked(role, account, _msgSender());
1237         }
1238     }
1239 }
1240 
1241 contract WrappedToken is Context, Ownable, ERC20 {
1242     uint8 private _decimals;
1243     bytes4 public source;
1244     bytes32 public sourceAddress;
1245 
1246     constructor(
1247         bytes4 source_,
1248         bytes32 sourceAddress_,
1249         uint8 decimals_,
1250         string memory name,
1251         string memory symbol
1252     ) ERC20(name, symbol) {
1253         source = source_;
1254         sourceAddress = sourceAddress_;
1255         _decimals = decimals_;
1256     }
1257 
1258     function decimals() public view virtual override returns (uint8) {
1259         return _decimals;
1260     }
1261 
1262     function mint(address to, uint256 amount) public virtual onlyOwner {
1263         _mint(to, amount);
1264     }
1265 
1266     function burn(address from, uint256 amount) public virtual onlyOwner {
1267         _burn(from, amount);
1268     }
1269 }
1270 
1271 /**
1272  * @dev Standard math utilities missing in the Solidity language.
1273  */
1274 library Math {
1275     /**
1276      * @dev Returns the largest of two numbers.
1277      */
1278     function max(uint256 a, uint256 b) internal pure returns (uint256) {
1279         return a >= b ? a : b;
1280     }
1281 
1282     /**
1283      * @dev Returns the smallest of two numbers.
1284      */
1285     function min(uint256 a, uint256 b) internal pure returns (uint256) {
1286         return a < b ? a : b;
1287     }
1288 
1289     /**
1290      * @dev Returns the average of two numbers. The result is rounded towards
1291      * zero.
1292      */
1293     function average(uint256 a, uint256 b) internal pure returns (uint256) {
1294         // (a + b) / 2 can overflow.
1295         return (a & b) + (a ^ b) / 2;
1296     }
1297 
1298     /**
1299      * @dev Returns the ceiling of the division of two numbers.
1300      *
1301      * This differs from standard division with `/` in that it rounds up instead
1302      * of rounding down.
1303      */
1304     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
1305         // (a + b - 1) / b can overflow on addition, so we distribute.
1306         return a / b + (a % b == 0 ? 0 : 1);
1307     }
1308 }
1309 // This contract handles swapping to and from xABR, Allbridge's staking token.
1310 contract Staking is ERC20("xABR", "xABR"){
1311     IERC20 public ABR;
1312 
1313     // Define the ABR token contract
1314     constructor(IERC20 _ABR) {
1315         ABR = _ABR;
1316     }
1317 
1318     // Locks ABR and mints xABR
1319     function deposit(uint256 _amount) public {
1320         // Gets the amount of ABR locked in the contract
1321         uint256 totalABR = ABR.balanceOf(address(this));
1322         // Gets the amount of xABR in existence
1323         uint256 totalShares = totalSupply();
1324         // If no xABR exists, mint it 1:1 to the amount put in
1325         if (totalShares == 0 || totalABR == 0) {
1326             _mint(msg.sender, _amount);
1327         }
1328         // Calculate and mint the amount of xABR the ABR is worth. The ratio will change overtime, 
1329         // as xABR is burned/minted and ABR deposited + gained from fees / withdrawn.
1330         else {
1331             uint256 what = _amount * totalShares / totalABR;
1332             _mint(msg.sender, what);
1333         }
1334         // Lock the ABR in the contract
1335         ABR.transferFrom(msg.sender, address(this), _amount);
1336     }
1337 
1338     // Unlocks the staked + gained ABR and burns xABR
1339     function withdraw(uint256 _share) public {
1340         // Gets the amount of xABR in existence
1341         uint256 totalShares = totalSupply();
1342         // Calculates the amount of ABR the xABR is worth
1343         uint256 what = _share * ABR.balanceOf(address(this)) / totalShares;
1344         _burn(msg.sender, _share);
1345         ABR.transfer(msg.sender, what);
1346     }
1347 }
1348 
1349 contract FeeOracle is Ownable {
1350     using Math for uint256;
1351 
1352     // tokenAddress => mintFee
1353     mapping(address => uint256) public minFee;
1354 
1355     // poolId => multiplier
1356     uint256 public feeMultiplier;
1357     uint256 public baseFeeRateBP;
1358 
1359     uint256 public constant BP = 10000;
1360 
1361     IERC20 public xABR;
1362 
1363     constructor(IERC20 xABR_, uint256 baseFeeRateBP_, uint256 feeMultiplier_) {
1364         xABR = xABR_;
1365         baseFeeRateBP = baseFeeRateBP_;
1366         feeMultiplier = feeMultiplier_;
1367     }
1368 
1369     function setFeeMultiplier(uint256 multiplier) public onlyOwner {
1370         feeMultiplier = multiplier;
1371     }
1372 
1373     function setMinFee(address token, uint256 _minFee) public onlyOwner {
1374         minFee[token] = _minFee;
1375     }
1376 
1377     function setBaseFeeRate(uint256 baseFeeRateBP_) public onlyOwner {
1378         baseFeeRateBP = baseFeeRateBP_;
1379     }
1380 
1381     // Fourth argument is destination
1382     function fee(address token, address sender, uint256 amount, bytes4) public view returns (uint256) {
1383         uint256 _minFee = minFee[token];
1384         if (xABR.totalSupply() == 0 || baseFeeRateBP == 0 || amount == 0) {
1385             return _minFee;
1386         }
1387         uint256 userShareBP = xABR.balanceOf(sender) * feeMultiplier * BP / xABR.totalSupply();
1388 
1389         uint256 result = (amount * BP) / (userShareBP + (BP * BP / baseFeeRateBP));
1390         if (_minFee > 0 && result < _minFee) {
1391             return _minFee;
1392         } else {
1393             return result;
1394         }
1395     }
1396 
1397 }
1398 
1399 interface IValidator {
1400     function createLock(
1401         uint128 lockId,
1402         address sender,
1403         bytes32 recipient,
1404         uint256 amount,
1405         bytes4 destination,
1406         bytes4 tokenSource,
1407         bytes32 tokenSourceAddress
1408     ) external;
1409 
1410     function createUnlock(
1411         uint128 lockId,
1412         address recipient,
1413         uint256 amount,
1414         bytes4 lockSource,
1415         bytes4 tokenSource,
1416         bytes32 tokenSourceAddress,
1417         bytes calldata signature
1418     ) external;
1419 }
1420 
1421 interface IWrappedTokenV0 {
1422     function changeAuthority(address newAuthority) external;
1423     function mint(address account, uint256 amount) external;
1424     function burn(address account, uint256 amount) external;
1425 }
1426 
1427 contract Bridge is AccessControl {
1428     using SafeERC20 for IERC20;
1429 
1430     bytes32 public constant TOKEN_MANAGER = keccak256("TOKEN_MANAGER");
1431     bytes32 public constant BRIDGE_MANAGER = keccak256("BRIDGE_MANAGER");
1432     bytes32 public constant STOP_MANAGER = keccak256("STOP_MANAGER");
1433 
1434     bool active;
1435 
1436     enum TokenType {
1437         Base,
1438         Native,
1439         WrappedV0,
1440         Wrapped
1441     }
1442 
1443     enum TokenStatus {
1444         Disabled,
1445         Enabled
1446     }
1447 
1448     uint256 private constant SYSTEM_PRECISION = 9;
1449 
1450     event Sent(
1451         bytes4 tokenSource,
1452         bytes32 tokenSourceAddress,
1453         address sender,
1454         bytes32 indexed recipient,
1455         uint256 amount,
1456         uint128 indexed lockId,
1457         bytes4 destination
1458     );
1459     event Received(address indexed recipient, address token, uint256 amount, uint128 indexed lockId, bytes4 source);
1460 
1461     // Validator contract address
1462     address public validator;
1463 
1464     // Address to collect fee
1465     address public feeCollector;
1466 
1467     // Fee manager address
1468     address public feeOracle;
1469 
1470     // Fee manager address
1471     address public unlockSigner;
1472 
1473     // Structure for token info
1474     struct TokenInfo {
1475         bytes4 tokenSource;
1476         bytes32 tokenSourceAddress;
1477         uint8 precision;
1478         TokenType tokenType;
1479         TokenStatus tokenStatus;
1480     }
1481 
1482     // Map to get token info by its address
1483     mapping(address => TokenInfo) public tokenInfos;
1484 
1485     // Structure for getting tokenAddress by tokenSource and tokenSourceAddress
1486     // tokenSource => tokenSourceAddress => nativeAddress
1487     mapping(bytes4 => mapping(bytes32 => address)) public tokenSourceMap;
1488 
1489     modifier isActive() {
1490         require(active, "Bridge: is not active");
1491         _;
1492     }
1493 
1494     constructor(
1495         address feeCollector_,
1496         address admin_,
1497         address validator_,
1498         address feeOracle_,
1499         address unlockSigner_
1500     ) {
1501         feeCollector = feeCollector_;
1502         validator = validator_;
1503         feeOracle = feeOracle_;
1504         _setupRole(DEFAULT_ADMIN_ROLE, admin_);
1505         unlockSigner = unlockSigner_;
1506         active = false;
1507     }
1508 
1509     // Method to lock tokens
1510     function lock(
1511         uint128 lockId,
1512         address tokenAddress,
1513         bytes32 recipient,
1514         bytes4 destination,
1515         uint256 amount
1516     ) external isActive {
1517         (uint256 amountToLock, uint256 fee, TokenInfo memory tokenInfo) = _createLock(
1518             lockId,
1519             tokenAddress,
1520             amount,
1521             recipient,
1522             destination
1523         );
1524 
1525         require(tokenInfo.tokenStatus == TokenStatus.Enabled, "Bridge: disabled token");
1526 
1527         if (tokenInfo.tokenType == TokenType.Native) {
1528             // If token is native - transfer tokens from user to contract
1529             IERC20(tokenAddress).safeTransferFrom(
1530                 msg.sender,
1531                 address(this),
1532                 amountToLock
1533             );
1534         } else if (tokenInfo.tokenType == TokenType.Wrapped) {
1535             // If wrapped then butn the token
1536             WrappedToken(tokenAddress).burn(msg.sender, amountToLock);
1537         } else if (tokenInfo.tokenType == TokenType.WrappedV0) {
1538             // Legacy wrapped tokens burn
1539             IWrappedTokenV0(tokenAddress).burn(msg.sender, amountToLock);
1540         } else {
1541             revert("Bridge: invalid token type");
1542         }
1543 
1544         if (fee > 0) {
1545             // If there is fee - transfer it to fee collector address
1546             IERC20(tokenAddress).safeTransferFrom(
1547                 msg.sender,
1548                 feeCollector,
1549                 fee
1550             );
1551         }
1552     }
1553 
1554     function lockBase(
1555         uint128 lockId, 
1556         address wrappedBaseTokenAddress, 
1557         bytes32 recipient, 
1558         bytes4 destination) external payable isActive {
1559         (, uint256 fee, TokenInfo memory tokenInfo) = _createLock(
1560             lockId,
1561             wrappedBaseTokenAddress,
1562             msg.value,
1563             recipient,
1564             destination
1565         );
1566 
1567         require(tokenInfo.tokenStatus == TokenStatus.Enabled, "Bridge: disabled token");
1568         require(tokenInfo.tokenType == TokenType.Base, "Bridge: invalid token type");
1569 
1570         if (fee > 0) {
1571             // If there is fee - transfer ETH to fee collector address
1572             payable(feeCollector).transfer(fee);
1573         }
1574     }
1575 
1576     // Method unlock funds. Amount has to be in system precision
1577     function unlock(
1578         uint128 lockId,
1579         address recipient, uint256 amount,
1580         bytes4 lockSource, bytes4 tokenSource,
1581         bytes32 tokenSourceAddress,
1582         bytes calldata signature) external isActive {
1583         // Create message hash and validate the signature
1584         IValidator(validator).createUnlock(
1585                 lockId,
1586                 recipient,
1587                 amount,
1588                 lockSource,
1589                 tokenSource,
1590                 tokenSourceAddress,
1591                 signature);
1592 
1593         // Mark lock as received
1594         address tokenAddress = tokenSourceMap[tokenSource][tokenSourceAddress];
1595         require(tokenAddress != address(0), "Bridge: unsupported token");
1596         TokenInfo memory tokenInfo = tokenInfos[tokenAddress];
1597 
1598         // Transform amount form system to token precision
1599         uint256 amountWithTokenPrecision = fromSystemPrecision(amount, tokenInfo.precision);
1600         uint256 fee = 0;
1601         if (msg.sender == unlockSigner) {
1602             fee = FeeOracle(feeOracle).minFee(tokenAddress);
1603             require(amountWithTokenPrecision > fee, "Bridge: amount too small");
1604             amountWithTokenPrecision = amountWithTokenPrecision - fee;
1605         }
1606 
1607         if (tokenInfo.tokenType == TokenType.Base) {
1608             // If token is WETH - transfer ETH
1609             payable(recipient).transfer(amountWithTokenPrecision);
1610             if (fee > 0) {
1611                 payable(feeCollector).transfer(fee);
1612             }
1613         } else if (tokenInfo.tokenType == TokenType.Native) {
1614             // If token is native - transfer the token
1615             IERC20(tokenAddress).safeTransfer(recipient, amountWithTokenPrecision);
1616             if (fee > 0) {
1617                 IERC20(tokenAddress).safeTransfer(feeCollector, fee);
1618             }
1619         } else if (tokenInfo.tokenType == TokenType.Wrapped) {
1620             // Else token is wrapped - mint tokens to the user
1621             WrappedToken(tokenAddress).mint(recipient, amountWithTokenPrecision);
1622             if (fee > 0) {
1623                 WrappedToken(tokenAddress).mint(feeCollector, fee);
1624             }
1625         } else if (tokenInfo.tokenType == TokenType.WrappedV0) {
1626             // Legacy wrapped token
1627             IWrappedTokenV0(tokenAddress).mint(recipient, amountWithTokenPrecision);
1628             if (fee > 0) {
1629                 IWrappedTokenV0(tokenAddress).mint(feeCollector, fee);
1630             }
1631         }
1632 
1633         emit Received(recipient, tokenAddress, amountWithTokenPrecision, lockId, lockSource);
1634     }
1635 
1636     // Method to add token that already exist in the current blockchain
1637     // Fee has to be in system precision
1638     // If token is wrapped, but it was deployed manually, isManualWrapped must be true
1639     function addToken(
1640         bytes4 tokenSource, 
1641         bytes32 tokenSourceAddress, 
1642         address nativeTokenAddress, 
1643         TokenType tokenType) external onlyRole(TOKEN_MANAGER) {
1644         require(
1645             tokenInfos[nativeTokenAddress].tokenSourceAddress == bytes32(0) &&
1646             tokenSourceMap[tokenSource][tokenSourceAddress] == address(0), "Bridge: exists");
1647         uint8 precision = ERC20(nativeTokenAddress).decimals();
1648 
1649         tokenSourceMap[tokenSource][tokenSourceAddress] = nativeTokenAddress;
1650         tokenInfos[nativeTokenAddress] = TokenInfo(
1651             tokenSource, 
1652             tokenSourceAddress, 
1653             precision, 
1654             tokenType, 
1655             TokenStatus.Enabled);
1656     }
1657 
1658     // Method to remove token from lists
1659     function removeToken(
1660         bytes4 tokenSource, 
1661         bytes32 tokenSourceAddress, 
1662         address newAuthority) external onlyRole(TOKEN_MANAGER) {
1663         require(newAuthority != address(0), "Bridge: zero address authority");
1664         address tokenAddress = tokenSourceMap[tokenSource][tokenSourceAddress];
1665         require(tokenAddress != address(0), "Bridge: token not found");
1666         TokenInfo memory tokenInfo = tokenInfos[tokenAddress];
1667 
1668         if (tokenInfo.tokenType == TokenType.Base && address(this).balance > 0) {
1669             payable(newAuthority).transfer(address(this).balance);
1670         }
1671 
1672         uint256 tokenBalance = IERC20(tokenAddress).balanceOf(address(this));
1673         if (tokenBalance > 0) {
1674             IERC20(tokenAddress).safeTransfer(newAuthority, tokenBalance);
1675         }
1676 
1677         if (tokenInfo.tokenType == TokenType.Wrapped) {
1678             WrappedToken(tokenAddress).transferOwnership(newAuthority);
1679         } else if (tokenInfo.tokenType == TokenType.WrappedV0) {
1680             IWrappedTokenV0(tokenAddress).changeAuthority(newAuthority);
1681         }
1682 
1683         delete tokenInfos[tokenAddress];
1684         delete tokenSourceMap[tokenSource][tokenSourceAddress];
1685     }
1686 
1687     function setFeeOracle(address _feeOracle) external onlyRole(TOKEN_MANAGER) {
1688         feeOracle = _feeOracle;
1689     }
1690 
1691     function setFeeCollector(address _feeCollector) external onlyRole(TOKEN_MANAGER) {
1692         feeCollector = _feeCollector;
1693     }
1694 
1695     function setValidator(address _validator ) external onlyRole(BRIDGE_MANAGER) {
1696         validator = _validator;
1697     }
1698 
1699     function setUnlockSigner(address _unlockSigner ) external onlyRole(BRIDGE_MANAGER) {
1700         unlockSigner = _unlockSigner;
1701     }
1702 
1703     function setTokenStatus(address tokenAddress, TokenStatus status)  external onlyRole(TOKEN_MANAGER) {
1704         require(tokenInfos[tokenAddress].tokenSourceAddress != bytes32(0), "Bridge: unsupported token");
1705         tokenInfos[tokenAddress].tokenStatus = status;
1706     }
1707 
1708     function startBridge() external onlyRole(BRIDGE_MANAGER) {
1709         active = true;
1710     }
1711 
1712     function stopBridge() external onlyRole(STOP_MANAGER) {
1713         active = false;
1714     }
1715 
1716     // Private method to validate lock, create lock record, and emmit the event
1717     // Method returns amount to lock and token info structure
1718     function _createLock(
1719         uint128 lockId,
1720         address tokenAddress,
1721         uint256 amount,
1722         bytes32 recipient,
1723         bytes4 destination
1724     ) private returns (uint256, uint256, TokenInfo memory) {
1725         require(amount > 0, "Bridge: amount is 0");
1726         TokenInfo memory tokenInfo = tokenInfos[tokenAddress];
1727         require(
1728             tokenInfo.tokenSourceAddress != bytes32(0),
1729             "Bridge: unsupported token"
1730         );
1731 
1732         uint256 fee = FeeOracle(feeOracle).fee(tokenAddress, msg.sender, amount, destination);
1733 
1734         require(amount > fee, "Bridge: amount too small");
1735 
1736         // Amount to lock is amount without fee
1737         uint256 amountToLock = amount - fee;
1738 
1739         // Create and add lock structure to the locks list
1740         IValidator(validator).createLock(
1741             lockId,
1742             msg.sender,
1743             recipient,
1744             toSystemPrecision(amountToLock, tokenInfo.precision),
1745             destination,
1746             tokenInfo.tokenSource,
1747             tokenInfo.tokenSourceAddress
1748         );
1749 
1750         emit Sent(
1751             tokenInfo.tokenSource,
1752             tokenInfo.tokenSourceAddress,
1753             msg.sender,
1754             recipient,
1755             amountToLock,
1756             lockId,
1757             destination
1758         );
1759         return (amountToLock, fee, tokenInfo);
1760     }
1761 
1762     // Convert amount from token precision to system precision
1763     function toSystemPrecision(uint256 amount, uint8 precision)
1764         private
1765         pure
1766         returns (uint256)
1767     {
1768         if (precision > SYSTEM_PRECISION) {
1769             return amount / (10**(precision - SYSTEM_PRECISION));
1770         } else if (precision < SYSTEM_PRECISION) {
1771             return amount * (10**(SYSTEM_PRECISION - precision));
1772         } else {
1773             return amount;
1774         }
1775     }
1776 
1777     // Convert amount from system precision to token precision
1778     function fromSystemPrecision(uint256 amount, uint8 precision)
1779         private
1780         pure
1781         returns (uint256)
1782     {
1783         if (precision > SYSTEM_PRECISION) {
1784             return amount * (10**(precision - SYSTEM_PRECISION));
1785         } else if (precision < SYSTEM_PRECISION) {
1786             return amount / (10**(SYSTEM_PRECISION - precision));
1787         } else {
1788             return amount;
1789         }
1790     }
1791 }