1 // SPDX-License-Identifier: UNLICENSED
2 
3 
4 
5 // File: contracts/Address.sol
6 
7 pragma solidity ^0.8.0;
8 
9 /**
10  * @dev Collection of functions related to the address type
11  */
12 library Address {
13     /**
14      * @dev Returns true if `account` is a contract.
15      *
16      * [IMPORTANT]
17      * ====
18      * It is unsafe to assume that an address for which this function returns
19      * false is an externally-owned account (EOA) and not a contract.
20      *
21      * Among others, `isContract` will return false for the following
22      * types of addresses:
23      *
24      *  - an externally-owned account
25      *  - a contract in construction
26      *  - an address where a contract will be created
27      *  - an address where a contract lived, but was destroyed
28      * ====
29      */
30     function isContract(address account) internal view returns (bool) {
31         // This method relies on extcodesize, which returns 0 for contracts in
32         // construction, since the code is only stored at the end of the
33         // constructor execution.
34 
35         uint256 size;
36         // solhint-disable-next-line no-inline-assembly
37         assembly { size := extcodesize(account) }
38         return size > 0;
39     }
40 
41     /**
42      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
43      * `recipient`, forwarding all available gas and reverting on errors.
44      *
45      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
46      * of certain opcodes, possibly making contracts go over the 2300 gas limit
47      * imposed by `transfer`, making them unable to receive funds via
48      * `transfer`. {sendValue} removes this limitation.
49      *
50      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
51      *
52      * IMPORTANT: because control is transferred to `recipient`, care must be
53      * taken to not create reentrancy vulnerabilities. Consider using
54      * {ReentrancyGuard} or the
55      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
56      */
57     function sendValue(address payable recipient, uint256 amount) internal {
58         require(address(this).balance >= amount, "Address: insufficient balance");
59 
60         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
61         (bool success, ) = recipient.call{ value: amount }("");
62         require(success, "Address: unable to send value, recipient may have reverted");
63     }
64 
65     /**
66      * @dev Performs a Solidity function call using a low level `call`. A
67      * plain`call` is an unsafe replacement for a function call: use this
68      * function instead.
69      *
70      * If `target` reverts with a revert reason, it is bubbled up by this
71      * function (like regular Solidity function calls).
72      *
73      * Returns the raw returned data. To convert to the expected return value,
74      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
75      *
76      * Requirements:
77      *
78      * - `target` must be a contract.
79      * - calling `target` with `data` must not revert.
80      *
81      * _Available since v3.1._
82      */
83     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
84       return functionCall(target, data, "Address: low-level call failed");
85     }
86 
87     /**
88      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
89      * `errorMessage` as a fallback revert reason when `target` reverts.
90      *
91      * _Available since v3.1._
92      */
93     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
94         return functionCallWithValue(target, data, 0, errorMessage);
95     }
96 
97     /**
98      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
99      * but also transferring `value` wei to `target`.
100      *
101      * Requirements:
102      *
103      * - the calling contract must have an ETH balance of at least `value`.
104      * - the called Solidity function must be `payable`.
105      *
106      * _Available since v3.1._
107      */
108     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
109         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
110     }
111 
112     /**
113      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
114      * with `errorMessage` as a fallback revert reason when `target` reverts.
115      *
116      * _Available since v3.1._
117      */
118     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
119         require(address(this).balance >= value, "Address: insufficient balance for call");
120         require(isContract(target), "Address: call to non-contract");
121 
122         // solhint-disable-next-line avoid-low-level-calls
123         (bool success, bytes memory returndata) = target.call{ value: value }(data);
124         return _verifyCallResult(success, returndata, errorMessage);
125     }
126 
127     /**
128      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
129      * but performing a static call.
130      *
131      * _Available since v3.3._
132      */
133     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
134         return functionStaticCall(target, data, "Address: low-level static call failed");
135     }
136 
137     /**
138      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
139      * but performing a static call.
140      *
141      * _Available since v3.3._
142      */
143     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
144         require(isContract(target), "Address: static call to non-contract");
145 
146         // solhint-disable-next-line avoid-low-level-calls
147         (bool success, bytes memory returndata) = target.staticcall(data);
148         return _verifyCallResult(success, returndata, errorMessage);
149     }
150 
151     /**
152      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
153      * but performing a delegate call.
154      *
155      * _Available since v3.4._
156      */
157     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
158         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
159     }
160 
161     /**
162      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
163      * but performing a delegate call.
164      *
165      * _Available since v3.4._
166      */
167     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
168         require(isContract(target), "Address: delegate call to non-contract");
169 
170         // solhint-disable-next-line avoid-low-level-calls
171         (bool success, bytes memory returndata) = target.delegatecall(data);
172         return _verifyCallResult(success, returndata, errorMessage);
173     }
174 
175     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
176         if (success) {
177             return returndata;
178         } else {
179             // Look for revert reason and bubble it up if present
180             if (returndata.length > 0) {
181                 // The easiest way to bubble the revert reason is using memory via assembly
182 
183                 // solhint-disable-next-line no-inline-assembly
184                 assembly {
185                     let returndata_size := mload(returndata)
186                     revert(add(32, returndata), returndata_size)
187                 }
188             } else {
189                 revert(errorMessage);
190             }
191         }
192     }
193 }
194 // File: contracts/SafeERC20.sol
195 
196 
197 pragma solidity ^0.8.0;
198 
199 
200 
201 /**
202  * @title SafeERC20
203  * @dev Wrappers around ERC20 operations that throw on failure (when the token
204  * contract returns false). Tokens that return no value (and instead revert or
205  * throw on failure) are also supported, non-reverting calls are assumed to be
206  * successful.
207  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
208  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
209  */
210 library SafeERC20 {
211     using Address for address;
212 
213     function safeTransfer(IERC20 token, address to, uint256 value) internal {
214         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
215     }
216 
217     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
218         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
219     }
220 
221     /**
222      * @dev Deprecated. This function has issues similar to the ones found in
223      * {IERC20-approve}, and its usage is discouraged.
224      *
225      * Whenever possible, use {safeIncreaseAllowance} and
226      * {safeDecreaseAllowance} instead.
227      */
228     function safeApprove(IERC20 token, address spender, uint256 value) internal {
229         // safeApprove should only be called when setting an initial allowance,
230         // or when resetting it to zero. To increase and decrease it, use
231         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
232         // solhint-disable-next-line max-line-length
233         require((value == 0) || (token.allowance(address(this), spender) == 0),
234             "SafeERC20: approve from non-zero to non-zero allowance"
235         );
236         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
237     }
238 
239     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
240         uint256 newAllowance = token.allowance(address(this), spender) + value;
241         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
242     }
243 
244     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
245         unchecked {
246             uint256 oldAllowance = token.allowance(address(this), spender);
247             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
248             uint256 newAllowance = oldAllowance - value;
249             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
250         }
251     }
252 
253     /**
254      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
255      * on the return value: the return value is optional (but if data is returned, it must not be false).
256      * @param token The token targeted by the call.
257      * @param data The call data (encoded using abi.encode or one of its variants).
258      */
259     function _callOptionalReturn(IERC20 token, bytes memory data) private {
260         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
261         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
262         // the target address contains contract code and also asserts for success in the low-level call.
263 
264         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
265         if (returndata.length > 0) { // Return data is optional
266             // solhint-disable-next-line max-line-length
267             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
268         }
269     }
270 }
271 
272 // File: contracts/Context.sol
273 
274 pragma solidity ^0.8.0;
275 
276 /*
277  * @dev Provides information about the current execution context, including the
278  * sender of the transaction and its data. While these are generally available
279  * via msg.sender and msg.data, they should not be accessed in such a direct
280  * manner, since when dealing with meta-transactions the account sending and
281  * paying for execution may not be the actual sender (as far as an application
282  * is concerned).
283  *
284  * This contract is only required for intermediate, library-like contracts.
285  */
286 abstract contract Context {
287     function _msgSender() internal view virtual returns (address) {
288         return msg.sender;
289     }
290 
291     function _msgData() internal view virtual returns (bytes calldata) {
292         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
293         return msg.data;
294     }
295 }
296 
297 
298 
299 // File: contracts/IERC20.sol
300 
301 pragma solidity ^0.8.0;
302 
303 /**
304  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
305  * the optional functions; to access them see {ERC20Detailed}.
306  */
307 interface IERC20 {
308     /**
309      * @dev Returns the amount of tokens in existence.
310      */
311     function totalSupply() external view returns (uint256);
312 
313     /**
314      * @dev Returns the amount of tokens owned by `account`.
315      */
316     function balanceOf(address account) external view returns (uint256);
317 
318     /**
319      * @dev Moves `amount` tokens from the caller's account to `recipient`.
320      *
321      * Returns a boolean value indicating whether the operation succeeded.
322      *
323      * Emits a {Transfer} event.
324      */
325     function transfer(address recipient, uint256 amount) external returns (bool);
326 
327     /**
328      * @dev Returns the remaining number of tokens that `spender` will be
329      * allowed to spend on behalf of `owner` through {transferFrom}. This is
330      * zero by default.
331      *
332      * This value changes when {approve} or {transferFrom} are called.
333      */
334     function allowance(address owner, address spender) external view returns (uint256);
335 
336     /**
337      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
338      *
339      * Returns a boolean value indicating whether the operation succeeded.
340      *
341      * IMPORTANT: Beware that changing an allowance with this method brings the risk
342      * that someone may use both the old and the new allowance by unfortunate
343      * transaction ordering. One possible solution to mitigate this race
344      * condition is to first reduce the spender's allowance to 0 and set the
345      * desired value afterwards:
346      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
347      *
348      * Emits an {Approval} event.
349      */
350     function approve(address spender, uint256 amount) external returns (bool);
351 
352     /**
353      * @dev Moves `amount` tokens from `sender` to `recipient` using the
354      * allowance mechanism. `amount` is then deducted from the caller's
355      * allowance.
356      *
357      * Returns a boolean value indicating whether the operation succeeded.
358      *
359      * Emits a {Transfer} event.
360      */
361     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
362 
363     /**
364      * @dev Emitted when `value` tokens are moved from one account (`from`) to
365      * another (`to`).
366      *
367      * Note that `value` may be zero.
368      */
369     event Transfer(address indexed from, address indexed to, uint256 value);
370 
371     /**
372      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
373      * a call to {approve}. `value` is the new allowance.
374      */
375     event Approval(address indexed owner, address indexed spender, uint256 value);
376 }
377 
378 
379 
380 
381 // File: contracts/IERC20Metadata.sol
382 
383 pragma solidity ^0.8.0;
384 
385 
386 /**
387  * @dev Interface for the optional metadata functions from the ERC20 standard.
388  *
389  * _Available since v4.1._
390  */
391 interface IERC20Metadata is IERC20 {
392     /**
393      * @dev Returns the name of the token.
394      */
395     function name() external view returns (string memory);
396 
397     /**
398      * @dev Returns the symbol of the token.
399      */
400     function symbol() external view returns (string memory);
401 
402     /**
403      * @dev Returns the decimals places of the token.
404      */
405     function decimals() external view returns (uint8);
406 }
407 
408 
409 
410 // File: contracts/ERC20.sol
411 
412 pragma solidity ^0.8.0;
413 
414 
415 
416 
417 /**
418  * @dev Implementation of the {IERC20} interface.
419  *
420  * This implementation is agnostic to the way tokens are created. This means
421  * that a supply mechanism has to be added in a derived contract using {_mint}.
422  * For a generic mechanism see {ERC20PresetMinterPauser}.
423  *
424  * TIP: For a detailed writeup see our guide
425  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
426  * to implement supply mechanisms].
427  *
428  * We have followed general OpenZeppelin guidelines: functions revert instead
429  * of returning `false` on failure. This behavior is nonetheless conventional
430  * and does not conflict with the expectations of ERC20 applications.
431  *
432  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
433  * This allows applications to reconstruct the allowance for all accounts just
434  * by listening to said events. Other implementations of the EIP may not emit
435  * these events, as it isn't required by the specification.
436  *
437  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
438  * functions have been added to mitigate the well-known issues around setting
439  * allowances. See {IERC20-approve}.
440  */
441 contract ERC20 is Context, IERC20, IERC20Metadata {
442     mapping (address => uint256) private _balances;
443 
444     mapping (address => mapping (address => uint256)) private _allowances;
445 
446     uint256 private _totalSupply;
447 
448     string private _name;
449     string private _symbol;
450 
451     /**
452      * @dev Sets the values for {name} and {symbol}.
453      *
454      * The defaut value of {decimals} is 18. To select a different value for
455      * {decimals} you should overload it.
456      *
457      * All two of these values are immutable: they can only be set once during
458      * construction.
459      */
460     constructor (string memory name_, string memory symbol_) {
461         _name = name_;
462         _symbol = symbol_;
463     }
464 
465     /**
466      * @dev Returns the name of the token.
467      */
468     function name() public view virtual override returns (string memory) {
469         return _name;
470     }
471 
472     /**
473      * @dev Returns the symbol of the token, usually a shorter version of the
474      * name.
475      */
476     function symbol() public view virtual override returns (string memory) {
477         return _symbol;
478     }
479 
480     /**
481      * @dev Returns the number of decimals used to get its user representation.
482      * For example, if `decimals` equals `2`, a balance of `505` tokens should
483      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
484      *
485      * Tokens usually opt for a value of 18, imitating the relationship between
486      * Ether and Wei. This is the value {ERC20} uses, unless this function is
487      * overridden;
488      *
489      * NOTE: This information is only used for _display_ purposes: it in
490      * no way affects any of the arithmetic of the contract, including
491      * {IERC20-balanceOf} and {IERC20-transfer}.
492      */
493     function decimals() public view virtual override returns (uint8) {
494         return 18;
495     }
496 
497     /**
498      * @dev See {IERC20-totalSupply}.
499      */
500     function totalSupply() public view virtual override returns (uint256) {
501         return _totalSupply;
502     }
503 
504     /**
505      * @dev See {IERC20-balanceOf}.
506      */
507     function balanceOf(address account) public view virtual override returns (uint256) {
508         return _balances[account];
509     }
510 
511     /**
512      * @dev See {IERC20-transfer}.
513      *
514      * Requirements:
515      *
516      * - `recipient` cannot be the zero address.
517      * - the caller must have a balance of at least `amount`.
518      */
519     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
520         _transfer(_msgSender(), recipient, amount);
521         return true;
522     }
523 
524     /**
525      * @dev See {IERC20-allowance}.
526      */
527     function allowance(address owner, address spender) public view virtual override returns (uint256) {
528         return _allowances[owner][spender];
529     }
530 
531     /**
532      * @dev See {IERC20-approve}.
533      *
534      * Requirements:
535      *
536      * - `spender` cannot be the zero address.
537      */
538     function approve(address spender, uint256 amount) public virtual override returns (bool) {
539         _approve(_msgSender(), spender, amount);
540         return true;
541     }
542 
543     /**
544      * @dev See {IERC20-transferFrom}.
545      *
546      * Emits an {Approval} event indicating the updated allowance. This is not
547      * required by the EIP. See the note at the beginning of {ERC20}.
548      *
549      * Requirements:
550      *
551      * - `sender` and `recipient` cannot be the zero address.
552      * - `sender` must have a balance of at least `amount`.
553      * - the caller must have allowance for ``sender``'s tokens of at least
554      * `amount`.
555      */
556     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
557         _transfer(sender, recipient, amount);
558 
559         uint256 currentAllowance = _allowances[sender][_msgSender()];
560         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
561         _approve(sender, _msgSender(), currentAllowance - amount);
562 
563         return true;
564     }
565 
566     /**
567      * @dev Atomically increases the allowance granted to `spender` by the caller.
568      *
569      * This is an alternative to {approve} that can be used as a mitigation for
570      * problems described in {IERC20-approve}.
571      *
572      * Emits an {Approval} event indicating the updated allowance.
573      *
574      * Requirements:
575      *
576      * - `spender` cannot be the zero address.
577      */
578     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
579         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
580         return true;
581     }
582 
583     /**
584      * @dev Atomically decreases the allowance granted to `spender` by the caller.
585      *
586      * This is an alternative to {approve} that can be used as a mitigation for
587      * problems described in {IERC20-approve}.
588      *
589      * Emits an {Approval} event indicating the updated allowance.
590      *
591      * Requirements:
592      *
593      * - `spender` cannot be the zero address.
594      * - `spender` must have allowance for the caller of at least
595      * `subtractedValue`.
596      */
597     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
598         uint256 currentAllowance = _allowances[_msgSender()][spender];
599         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
600         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
601 
602         return true;
603     }
604 
605     /**
606      * @dev Moves tokens `amount` from `sender` to `recipient`.
607      *
608      * This is internal function is equivalent to {transfer}, and can be used to
609      * e.g. implement automatic token fees, slashing mechanisms, etc.
610      *
611      * Emits a {Transfer} event.
612      *
613      * Requirements:
614      *
615      * - `sender` cannot be the zero address.
616      * - `recipient` cannot be the zero address.
617      * - `sender` must have a balance of at least `amount`.
618      */
619     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
620         require(sender != address(0), "ERC20: transfer from the zero address");
621         require(recipient != address(0), "ERC20: transfer to the zero address");
622 
623         _beforeTokenTransfer(sender, recipient, amount);
624 
625         uint256 senderBalance = _balances[sender];
626         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
627         _balances[sender] = senderBalance - amount;
628         _balances[recipient] += amount;
629 
630         emit Transfer(sender, recipient, amount);
631     }
632 
633     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
634      * the total supply.
635      *
636      * Emits a {Transfer} event with `from` set to the zero address.
637      *
638      * Requirements:
639      *
640      * - `account` cannot be the zero address.
641      */
642     function _mint(address account, uint256 amount) internal virtual {
643         require(account != address(0), "ERC20: mint to the zero address");
644 
645         _beforeTokenTransfer(address(0), account, amount);
646 
647         _totalSupply += amount;
648         _balances[account] += amount;
649         emit Transfer(address(0), account, amount);
650     }
651 
652     /**
653      * @dev Destroys `amount` tokens from `account`, reducing the
654      * total supply.
655      *
656      * Emits a {Transfer} event with `to` set to the zero address.
657      *
658      * Requirements:
659      *
660      * - `account` cannot be the zero address.
661      * - `account` must have at least `amount` tokens.
662      */
663     function _burn(address account, uint256 amount) internal virtual {
664         require(account != address(0), "ERC20: burn from the zero address");
665 
666         _beforeTokenTransfer(account, address(0), amount);
667 
668         uint256 accountBalance = _balances[account];
669         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
670         _balances[account] = accountBalance - amount;
671         _totalSupply -= amount;
672 
673         emit Transfer(account, address(0), amount);
674     }
675 
676     /**
677      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
678      *
679      * This internal function is equivalent to `approve`, and can be used to
680      * e.g. set automatic allowances for certain subsystems, etc.
681      *
682      * Emits an {Approval} event.
683      *
684      * Requirements:
685      *
686      * - `owner` cannot be the zero address.
687      * - `spender` cannot be the zero address.
688      */
689     function _approve(address owner, address spender, uint256 amount) internal virtual {
690         require(owner != address(0), "ERC20: approve from the zero address");
691         require(spender != address(0), "ERC20: approve to the zero address");
692 
693         _allowances[owner][spender] = amount;
694         emit Approval(owner, spender, amount);
695     }
696 
697     /**
698      * @dev Hook that is called before any transfer of tokens. This includes
699      * minting and burning.
700      *
701      * Calling conditions:
702      *
703      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
704      * will be to transferred to `to`.
705      * - when `from` is zero, `amount` tokens will be minted for `to`.
706      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
707      * - `from` and `to` are never both zero.
708      *
709      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
710      */
711     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
712 }
713 
714 
715 
716 
717 // File: contracts/ERC20Burnable.sol
718 
719 
720 pragma solidity ^0.8.0;
721 
722 
723 
724 /**
725  * @dev Extension of {ERC20} that allows token holders to destroy both their own
726  * tokens and those that they have an allowance for, in a way that can be
727  * recognized off-chain (via event analysis).
728  */
729 abstract contract ERC20Burnable is Context, ERC20 {
730     /**
731      * @dev Destroys `amount` tokens from the caller.
732      *
733      * See {ERC20-_burn}.
734      */
735     function burn(uint256 amount) public virtual {
736         _burn(_msgSender(), amount);
737     }
738 
739     /**
740      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
741      * allowance.
742      *
743      * See {ERC20-_burn} and {ERC20-allowance}.
744      *
745      * Requirements:
746      *
747      * - the caller must have allowance for ``accounts``'s tokens of at least
748      * `amount`.
749      */
750     function burnFrom(address account, uint256 amount) public virtual {
751         uint256 currentAllowance = allowance(account, _msgSender());
752         require(currentAllowance >= amount, "ERC20: burn amount exceeds allowance");
753         _approve(account, _msgSender(), currentAllowance - amount);
754         _burn(account, amount);
755     }
756 }
757 
758 
759 
760 // File: contracts/POPKET.sol
761 
762 pragma solidity ^0.8.0;
763 
764 
765 
766 
767 
768 /**
769  * @dev {ERC20} token, including:
770  *
771  *  - Preminted initial supply
772  *  - Ability for holders to burn (destroy) their tokens
773  *  - No access control mechanism (for minting/pausing) and hence no governance
774  *
775  * This contract uses {ERC20Burnable} to include burn capabilities - head to
776  * its documentation for details.
777  *
778  * _Available since v3.4._
779  */
780 contract POPKET is ERC20, ERC20Burnable {
781        uint public INITIAL_SUPPLY = 4463000000000000000000000000; //44억 6천 3백
782     
783     constructor() public ERC20("POPKET","POPKET"){ 
784         _mint(msg.sender, INITIAL_SUPPLY); 
785         }
786 }