1 // SPDX-License-Identifier: MIT
2 
3 // File: openzeppelin-solidity/contracts/utils/Address.sol
4 
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev Collection of functions related to the address type
10  */
11 library Address {
12     /**
13      * @dev Returns true if `account` is a contract.
14      *
15      * [IMPORTANT]
16      * ====
17      * It is unsafe to assume that an address for which this function returns
18      * false is an externally-owned account (EOA) and not a contract.
19      *
20      * Among others, `isContract` will return false for the following
21      * types of addresses:
22      *
23      *  - an externally-owned account
24      *  - a contract in construction
25      *  - an address where a contract will be created
26      *  - an address where a contract lived, but was destroyed
27      * ====
28      */
29     function isContract(address account) internal view returns (bool) {
30         // This method relies on extcodesize, which returns 0 for contracts in
31         // construction, since the code is only stored at the end of the
32         // constructor execution.
33 
34         uint256 size;
35         // solhint-disable-next-line no-inline-assembly
36         assembly { size := extcodesize(account) }
37         return size > 0;
38     }
39 
40     /**
41      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
42      * `recipient`, forwarding all available gas and reverting on errors.
43      *
44      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
45      * of certain opcodes, possibly making contracts go over the 2300 gas limit
46      * imposed by `transfer`, making them unable to receive funds via
47      * `transfer`. {sendValue} removes this limitation.
48      *
49      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
50      *
51      * IMPORTANT: because control is transferred to `recipient`, care must be
52      * taken to not create reentrancy vulnerabilities. Consider using
53      * {ReentrancyGuard} or the
54      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
55      */
56     function sendValue(address payable recipient, uint256 amount) internal {
57         require(address(this).balance >= amount, "Address: insufficient balance");
58 
59         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
60         (bool success, ) = recipient.call{ value: amount }("");
61         require(success, "Address: unable to send value, recipient may have reverted");
62     }
63 
64     /**
65      * @dev Performs a Solidity function call using a low level `call`. A
66      * plain`call` is an unsafe replacement for a function call: use this
67      * function instead.
68      *
69      * If `target` reverts with a revert reason, it is bubbled up by this
70      * function (like regular Solidity function calls).
71      *
72      * Returns the raw returned data. To convert to the expected return value,
73      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
74      *
75      * Requirements:
76      *
77      * - `target` must be a contract.
78      * - calling `target` with `data` must not revert.
79      *
80      * _Available since v3.1._
81      */
82     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
83       return functionCall(target, data, "Address: low-level call failed");
84     }
85 
86     /**
87      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
88      * `errorMessage` as a fallback revert reason when `target` reverts.
89      *
90      * _Available since v3.1._
91      */
92     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
93         return functionCallWithValue(target, data, 0, errorMessage);
94     }
95 
96     /**
97      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
98      * but also transferring `value` wei to `target`.
99      *
100      * Requirements:
101      *
102      * - the calling contract must have an ETH balance of at least `value`.
103      * - the called Solidity function must be `payable`.
104      *
105      * _Available since v3.1._
106      */
107     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
108         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
109     }
110 
111     /**
112      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
113      * with `errorMessage` as a fallback revert reason when `target` reverts.
114      *
115      * _Available since v3.1._
116      */
117     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
118         require(address(this).balance >= value, "Address: insufficient balance for call");
119         require(isContract(target), "Address: call to non-contract");
120 
121         // solhint-disable-next-line avoid-low-level-calls
122         (bool success, bytes memory returndata) = target.call{ value: value }(data);
123         return _verifyCallResult(success, returndata, errorMessage);
124     }
125 
126     /**
127      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
128      * but performing a static call.
129      *
130      * _Available since v3.3._
131      */
132     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
133         return functionStaticCall(target, data, "Address: low-level static call failed");
134     }
135 
136     /**
137      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
138      * but performing a static call.
139      *
140      * _Available since v3.3._
141      */
142     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
143         require(isContract(target), "Address: static call to non-contract");
144 
145         // solhint-disable-next-line avoid-low-level-calls
146         (bool success, bytes memory returndata) = target.staticcall(data);
147         return _verifyCallResult(success, returndata, errorMessage);
148     }
149 
150     /**
151      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
152      * but performing a delegate call.
153      *
154      * _Available since v3.4._
155      */
156     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
157         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
158     }
159 
160     /**
161      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
162      * but performing a delegate call.
163      *
164      * _Available since v3.4._
165      */
166     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
167         require(isContract(target), "Address: delegate call to non-contract");
168 
169         // solhint-disable-next-line avoid-low-level-calls
170         (bool success, bytes memory returndata) = target.delegatecall(data);
171         return _verifyCallResult(success, returndata, errorMessage);
172     }
173 
174     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
175         if (success) {
176             return returndata;
177         } else {
178             // Look for revert reason and bubble it up if present
179             if (returndata.length > 0) {
180                 // The easiest way to bubble the revert reason is using memory via assembly
181 
182                 // solhint-disable-next-line no-inline-assembly
183                 assembly {
184                     let returndata_size := mload(returndata)
185                     revert(add(32, returndata), returndata_size)
186                 }
187             } else {
188                 revert(errorMessage);
189             }
190         }
191     }
192 }
193 
194 
195 // File: openzeppelin-solidity/contracts/utils/Context.sol
196 
197 
198 pragma solidity ^0.8.0;
199 
200 /*
201  * @dev Provides information about the current execution context, including the
202  * sender of the transaction and its data. While these are generally available
203  * via msg.sender and msg.data, they should not be accessed in such a direct
204  * manner, since when dealing with meta-transactions the account sending and
205  * paying for execution may not be the actual sender (as far as an application
206  * is concerned).
207  *
208  * This contract is only required for intermediate, library-like contracts.
209  */
210 abstract contract Context {
211     function _msgSender() internal view virtual returns (address) {
212         return msg.sender;
213     }
214 
215     function _msgData() internal view virtual returns (bytes calldata) {
216         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
217         return msg.data;
218     }
219 }
220 
221 
222 // File: openzeppelin-solidity/contracts/access/Ownable.sol
223 
224 
225 pragma solidity ^0.8.0;
226 
227 /**
228  * @dev Contract module which provides a basic access control mechanism, where
229  * there is an account (an owner) that can be granted exclusive access to
230  * specific functions.
231  *
232  * By default, the owner account will be the one that deploys the contract. This
233  * can later be changed with {transferOwnership}.
234  *
235  * This module is used through inheritance. It will make available the modifier
236  * `onlyOwner`, which can be applied to your functions to restrict their use to
237  * the owner.
238  */
239 abstract contract Ownable is Context {
240     address private _owner;
241 
242     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
243 
244     /**
245      * @dev Initializes the contract setting the deployer as the initial owner.
246      */
247     constructor () {
248         address msgSender = _msgSender();
249         _owner = msgSender;
250         emit OwnershipTransferred(address(0), msgSender);
251     }
252 
253     /**
254      * @dev Returns the address of the current owner.
255      */
256     function owner() public view virtual returns (address) {
257         return _owner;
258     }
259 
260     /**
261      * @dev Throws if called by any account other than the owner.
262      */
263     modifier onlyOwner() {
264         require(owner() == _msgSender(), "Ownable: caller is not the owner");
265         _;
266     }
267 
268     /**
269      * @dev Leaves the contract without owner. It will not be possible to call
270      * `onlyOwner` functions anymore. Can only be called by the current owner.
271      *
272      * NOTE: Renouncing ownership will leave the contract without an owner,
273      * thereby removing any functionality that is only available to the owner.
274      */
275     function renounceOwnership() public virtual onlyOwner {
276         emit OwnershipTransferred(_owner, address(0));
277         _owner = address(0);
278     }
279 
280     /**
281      * @dev Transfers ownership of the contract to a new account (`newOwner`).
282      * Can only be called by the current owner.
283      */
284     function transferOwnership(address newOwner) public virtual onlyOwner {
285         require(newOwner != address(0), "Ownable: new owner is the zero address");
286         emit OwnershipTransferred(_owner, newOwner);
287         _owner = newOwner;
288     }
289 }
290 
291 
292 // File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol
293 
294 
295 pragma solidity ^0.8.0;
296 
297 /**
298  * @dev Interface of the ERC20 standard as defined in the EIP.
299  */
300 interface IERC20 {
301     /**
302      * @dev Returns the amount of tokens in existence.
303      */
304     function totalSupply() external view returns (uint256);
305 
306     /**
307      * @dev Returns the amount of tokens owned by `account`.
308      */
309     function balanceOf(address account) external view returns (uint256);
310 
311     /**
312      * @dev Moves `amount` tokens from the caller's account to `recipient`.
313      *
314      * Returns a boolean value indicating whether the operation succeeded.
315      *
316      * Emits a {Transfer} event.
317      */
318     function transfer(address recipient, uint256 amount) external returns (bool);
319 
320     /**
321      * @dev Returns the remaining number of tokens that `spender` will be
322      * allowed to spend on behalf of `owner` through {transferFrom}. This is
323      * zero by default.
324      *
325      * This value changes when {approve} or {transferFrom} are called.
326      */
327     function allowance(address owner, address spender) external view returns (uint256);
328 
329     /**
330      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
331      *
332      * Returns a boolean value indicating whether the operation succeeded.
333      *
334      * IMPORTANT: Beware that changing an allowance with this method brings the risk
335      * that someone may use both the old and the new allowance by unfortunate
336      * transaction ordering. One possible solution to mitigate this race
337      * condition is to first reduce the spender's allowance to 0 and set the
338      * desired value afterwards:
339      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
340      *
341      * Emits an {Approval} event.
342      */
343     function approve(address spender, uint256 amount) external returns (bool);
344 
345     /**
346      * @dev Moves `amount` tokens from `sender` to `recipient` using the
347      * allowance mechanism. `amount` is then deducted from the caller's
348      * allowance.
349      *
350      * Returns a boolean value indicating whether the operation succeeded.
351      *
352      * Emits a {Transfer} event.
353      */
354     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
355 
356     /**
357      * @dev Emitted when `value` tokens are moved from one account (`from`) to
358      * another (`to`).
359      *
360      * Note that `value` may be zero.
361      */
362     event Transfer(address indexed from, address indexed to, uint256 value);
363 
364     /**
365      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
366      * a call to {approve}. `value` is the new allowance.
367      */
368     event Approval(address indexed owner, address indexed spender, uint256 value);
369 }
370 
371 
372 // File: openzeppelin-solidity/contracts/token/ERC20/extensions/IERC20Metadata.sol
373 
374 
375 pragma solidity ^0.8.0;
376 
377 
378 /**
379  * @dev Interface for the optional metadata functions from the ERC20 standard.
380  *
381  * _Available since v4.1._
382  */
383 interface IERC20Metadata is IERC20 {
384     /**
385      * @dev Returns the name of the token.
386      */
387     function name() external view returns (string memory);
388 
389     /**
390      * @dev Returns the symbol of the token.
391      */
392     function symbol() external view returns (string memory);
393 
394     /**
395      * @dev Returns the decimals places of the token.
396      */
397     function decimals() external view returns (uint8);
398 }
399 
400 
401 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
402 
403 
404 pragma solidity ^0.8.0;
405 
406 
407 
408 
409 /**
410  * @dev Implementation of the {IERC20} interface.
411  *
412  * This implementation is agnostic to the way tokens are created. This means
413  * that a supply mechanism has to be added in a derived contract using {_mint}.
414  * For a generic mechanism see {ERC20PresetMinterPauser}.
415  *
416  * TIP: For a detailed writeup see our guide
417  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
418  * to implement supply mechanisms].
419  *
420  * We have followed general OpenZeppelin guidelines: functions revert instead
421  * of returning `false` on failure. This behavior is nonetheless conventional
422  * and does not conflict with the expectations of ERC20 applications.
423  *
424  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
425  * This allows applications to reconstruct the allowance for all accounts just
426  * by listening to said events. Other implementations of the EIP may not emit
427  * these events, as it isn't required by the specification.
428  *
429  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
430  * functions have been added to mitigate the well-known issues around setting
431  * allowances. See {IERC20-approve}.
432  */
433 contract ERC20 is Context, IERC20, IERC20Metadata {
434     mapping (address => uint256) private _balances;
435 
436     mapping (address => mapping (address => uint256)) private _allowances;
437 
438     uint256 private _totalSupply;
439 
440     string private _name;
441     string private _symbol;
442 
443     /**
444      * @dev Sets the values for {name} and {symbol}.
445      *
446      * The defaut value of {decimals} is 18. To select a different value for
447      * {decimals} you should overload it.
448      *
449      * All two of these values are immutable: they can only be set once during
450      * construction.
451      */
452     constructor (string memory name_, string memory symbol_) {
453         _name = name_;
454         _symbol = symbol_;
455     }
456 
457     /**
458      * @dev Returns the name of the token.
459      */
460     function name() public view virtual override returns (string memory) {
461         return _name;
462     }
463 
464     /**
465      * @dev Returns the symbol of the token, usually a shorter version of the
466      * name.
467      */
468     function symbol() public view virtual override returns (string memory) {
469         return _symbol;
470     }
471 
472     /**
473      * @dev Returns the number of decimals used to get its user representation.
474      * For example, if `decimals` equals `2`, a balance of `505` tokens should
475      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
476      *
477      * Tokens usually opt for a value of 18, imitating the relationship between
478      * Ether and Wei. This is the value {ERC20} uses, unless this function is
479      * overridden;
480      *
481      * NOTE: This information is only used for _display_ purposes: it in
482      * no way affects any of the arithmetic of the contract, including
483      * {IERC20-balanceOf} and {IERC20-transfer}.
484      */
485     function decimals() public view virtual override returns (uint8) {
486         return 18;
487     }
488 
489     /**
490      * @dev See {IERC20-totalSupply}.
491      */
492     function totalSupply() public view virtual override returns (uint256) {
493         return _totalSupply;
494     }
495 
496     /**
497      * @dev See {IERC20-balanceOf}.
498      */
499     function balanceOf(address account) public view virtual override returns (uint256) {
500         return _balances[account];
501     }
502 
503     /**
504      * @dev See {IERC20-transfer}.
505      *
506      * Requirements:
507      *
508      * - `recipient` cannot be the zero address.
509      * - the caller must have a balance of at least `amount`.
510      */
511     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
512         _transfer(_msgSender(), recipient, amount);
513         return true;
514     }
515 
516     /**
517      * @dev See {IERC20-allowance}.
518      */
519     function allowance(address owner, address spender) public view virtual override returns (uint256) {
520         return _allowances[owner][spender];
521     }
522 
523     /**
524      * @dev See {IERC20-approve}.
525      *
526      * Requirements:
527      *
528      * - `spender` cannot be the zero address.
529      */
530     function approve(address spender, uint256 amount) public virtual override returns (bool) {
531         _approve(_msgSender(), spender, amount);
532         return true;
533     }
534 
535     /**
536      * @dev See {IERC20-transferFrom}.
537      *
538      * Emits an {Approval} event indicating the updated allowance. This is not
539      * required by the EIP. See the note at the beginning of {ERC20}.
540      *
541      * Requirements:
542      *
543      * - `sender` and `recipient` cannot be the zero address.
544      * - `sender` must have a balance of at least `amount`.
545      * - the caller must have allowance for ``sender``'s tokens of at least
546      * `amount`.
547      */
548     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
549         _transfer(sender, recipient, amount);
550 
551         uint256 currentAllowance = _allowances[sender][_msgSender()];
552         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
553         _approve(sender, _msgSender(), currentAllowance - amount);
554 
555         return true;
556     }
557 
558     /**
559      * @dev Atomically increases the allowance granted to `spender` by the caller.
560      *
561      * This is an alternative to {approve} that can be used as a mitigation for
562      * problems described in {IERC20-approve}.
563      *
564      * Emits an {Approval} event indicating the updated allowance.
565      *
566      * Requirements:
567      *
568      * - `spender` cannot be the zero address.
569      */
570     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
571         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
572         return true;
573     }
574 
575     /**
576      * @dev Atomically decreases the allowance granted to `spender` by the caller.
577      *
578      * This is an alternative to {approve} that can be used as a mitigation for
579      * problems described in {IERC20-approve}.
580      *
581      * Emits an {Approval} event indicating the updated allowance.
582      *
583      * Requirements:
584      *
585      * - `spender` cannot be the zero address.
586      * - `spender` must have allowance for the caller of at least
587      * `subtractedValue`.
588      */
589     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
590         uint256 currentAllowance = _allowances[_msgSender()][spender];
591         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
592         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
593 
594         return true;
595     }
596 
597     /**
598      * @dev Moves tokens `amount` from `sender` to `recipient`.
599      *
600      * This is internal function is equivalent to {transfer}, and can be used to
601      * e.g. implement automatic token fees, slashing mechanisms, etc.
602      *
603      * Emits a {Transfer} event.
604      *
605      * Requirements:
606      *
607      * - `sender` cannot be the zero address.
608      * - `recipient` cannot be the zero address.
609      * - `sender` must have a balance of at least `amount`.
610      */
611     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
612         require(sender != address(0), "ERC20: transfer from the zero address");
613         require(recipient != address(0), "ERC20: transfer to the zero address");
614 
615         _beforeTokenTransfer(sender, recipient, amount);
616 
617         uint256 senderBalance = _balances[sender];
618         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
619         _balances[sender] = senderBalance - amount;
620         _balances[recipient] += amount;
621 
622         emit Transfer(sender, recipient, amount);
623     }
624 
625     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
626      * the total supply.
627      *
628      * Emits a {Transfer} event with `from` set to the zero address.
629      *
630      * Requirements:
631      *
632      * - `to` cannot be the zero address.
633      */
634     function _mint(address account, uint256 amount) internal virtual {
635         require(account != address(0), "ERC20: mint to the zero address");
636 
637         _beforeTokenTransfer(address(0), account, amount);
638 
639         _totalSupply += amount;
640         _balances[account] += amount;
641         emit Transfer(address(0), account, amount);
642     }
643 
644     /**
645      * @dev Destroys `amount` tokens from `account`, reducing the
646      * total supply.
647      *
648      * Emits a {Transfer} event with `to` set to the zero address.
649      *
650      * Requirements:
651      *
652      * - `account` cannot be the zero address.
653      * - `account` must have at least `amount` tokens.
654      */
655     function _burn(address account, uint256 amount) internal virtual {
656         require(account != address(0), "ERC20: burn from the zero address");
657 
658         _beforeTokenTransfer(account, address(0), amount);
659 
660         uint256 accountBalance = _balances[account];
661         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
662         _balances[account] = accountBalance - amount;
663         _totalSupply -= amount;
664 
665         emit Transfer(account, address(0), amount);
666     }
667 
668     /**
669      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
670      *
671      * This internal function is equivalent to `approve`, and can be used to
672      * e.g. set automatic allowances for certain subsystems, etc.
673      *
674      * Emits an {Approval} event.
675      *
676      * Requirements:
677      *
678      * - `owner` cannot be the zero address.
679      * - `spender` cannot be the zero address.
680      */
681     function _approve(address owner, address spender, uint256 amount) internal virtual {
682         require(owner != address(0), "ERC20: approve from the zero address");
683         require(spender != address(0), "ERC20: approve to the zero address");
684 
685         _allowances[owner][spender] = amount;
686         emit Approval(owner, spender, amount);
687     }
688 
689     /**
690      * @dev Hook that is called before any transfer of tokens. This includes
691      * minting and burning.
692      *
693      * Calling conditions:
694      *
695      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
696      * will be to transferred to `to`.
697      * - when `from` is zero, `amount` tokens will be minted for `to`.
698      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
699      * - `from` and `to` are never both zero.
700      *
701      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
702      */
703     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
704 }
705 
706 // File: openzeppelin-solidity/contracts/token/ERC20/utils/SafeERC20.sol
707 
708 pragma solidity ^0.8.0;
709 
710 /**
711  * @title SafeERC20
712  * @dev Wrappers around ERC20 operations that throw on failure (when the token
713  * contract returns false). Tokens that return no value (and instead revert or
714  * throw on failure) are also supported, non-reverting calls are assumed to be
715  * successful.
716  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
717  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
718  */
719 library SafeERC20 {
720     using Address for address;
721 
722     function safeTransfer(IERC20 token, address to, uint256 value) internal {
723         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
724     }
725 
726     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
727         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
728     }
729 
730     /**
731      * @dev Deprecated. This function has issues similar to the ones found in
732      * {IERC20-approve}, and its usage is discouraged.
733      *
734      * Whenever possible, use {safeIncreaseAllowance} and
735      * {safeDecreaseAllowance} instead.
736      */
737     function safeApprove(IERC20 token, address spender, uint256 value) internal {
738         // safeApprove should only be called when setting an initial allowance,
739         // or when resetting it to zero. To increase and decrease it, use
740         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
741         // solhint-disable-next-line max-line-length
742         require((value == 0) || (token.allowance(address(this), spender) == 0),
743             "SafeERC20: approve from non-zero to non-zero allowance"
744         );
745         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
746     }
747 
748     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
749         uint256 newAllowance = token.allowance(address(this), spender) + value;
750         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
751     }
752 
753     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
754         unchecked {
755             uint256 oldAllowance = token.allowance(address(this), spender);
756             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
757             uint256 newAllowance = oldAllowance - value;
758             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
759         }
760     }
761 
762     /**
763      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
764      * on the return value: the return value is optional (but if data is returned, it must not be false).
765      * @param token The token targeted by the call.
766      * @param data The call data (encoded using abi.encode or one of its variants).
767      */
768     function _callOptionalReturn(IERC20 token, bytes memory data) private {
769         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
770         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
771         // the target address contains contract code and also asserts for success in the low-level call.
772 
773         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
774         if (returndata.length > 0) { // Return data is optional
775             // solhint-disable-next-line max-line-length
776             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
777         }
778     }
779 }
780 
781 
782 // File: openzeppelin-solidity/contracts/utils/math/SafeMath.sol
783 
784 
785 pragma solidity ^0.8.0;
786 
787 // CAUTION
788 // This version of SafeMath should only be used with Solidity 0.8 or later,
789 // because it relies on the compiler's built in overflow checks.
790 
791 /**
792  * @dev Wrappers over Solidity's arithmetic operations.
793  *
794  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
795  * now has built in overflow checking.
796  */
797 library SafeMath {
798     /**
799      * @dev Returns the addition of two unsigned integers, with an overflow flag.
800      *
801      * _Available since v3.4._
802      */
803     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
804         unchecked {
805             uint256 c = a + b;
806             if (c < a) return (false, 0);
807             return (true, c);
808         }
809     }
810 
811     /**
812      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
813      *
814      * _Available since v3.4._
815      */
816     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
817         unchecked {
818             if (b > a) return (false, 0);
819             return (true, a - b);
820         }
821     }
822 
823     /**
824      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
825      *
826      * _Available since v3.4._
827      */
828     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
829         unchecked {
830             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
831             // benefit is lost if 'b' is also tested.
832             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
833             if (a == 0) return (true, 0);
834             uint256 c = a * b;
835             if (c / a != b) return (false, 0);
836             return (true, c);
837         }
838     }
839 
840     /**
841      * @dev Returns the division of two unsigned integers, with a division by zero flag.
842      *
843      * _Available since v3.4._
844      */
845     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
846         unchecked {
847             if (b == 0) return (false, 0);
848             return (true, a / b);
849         }
850     }
851 
852     /**
853      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
854      *
855      * _Available since v3.4._
856      */
857     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
858         unchecked {
859             if (b == 0) return (false, 0);
860             return (true, a % b);
861         }
862     }
863 
864     /**
865      * @dev Returns the addition of two unsigned integers, reverting on
866      * overflow.
867      *
868      * Counterpart to Solidity's `+` operator.
869      *
870      * Requirements:
871      *
872      * - Addition cannot overflow.
873      */
874     function add(uint256 a, uint256 b) internal pure returns (uint256) {
875         return a + b;
876     }
877 
878     /**
879      * @dev Returns the subtraction of two unsigned integers, reverting on
880      * overflow (when the result is negative).
881      *
882      * Counterpart to Solidity's `-` operator.
883      *
884      * Requirements:
885      *
886      * - Subtraction cannot overflow.
887      */
888     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
889         return a - b;
890     }
891 
892     /**
893      * @dev Returns the multiplication of two unsigned integers, reverting on
894      * overflow.
895      *
896      * Counterpart to Solidity's `*` operator.
897      *
898      * Requirements:
899      *
900      * - Multiplication cannot overflow.
901      */
902     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
903         return a * b;
904     }
905 
906     /**
907      * @dev Returns the integer division of two unsigned integers, reverting on
908      * division by zero. The result is rounded towards zero.
909      *
910      * Counterpart to Solidity's `/` operator.
911      *
912      * Requirements:
913      *
914      * - The divisor cannot be zero.
915      */
916     function div(uint256 a, uint256 b) internal pure returns (uint256) {
917         return a / b;
918     }
919 
920     /**
921      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
922      * reverting when dividing by zero.
923      *
924      * Counterpart to Solidity's `%` operator. This function uses a `revert`
925      * opcode (which leaves remaining gas untouched) while Solidity uses an
926      * invalid opcode to revert (consuming all remaining gas).
927      *
928      * Requirements:
929      *
930      * - The divisor cannot be zero.
931      */
932     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
933         return a % b;
934     }
935 
936     /**
937      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
938      * overflow (when the result is negative).
939      *
940      * CAUTION: This function is deprecated because it requires allocating memory for the error
941      * message unnecessarily. For custom revert reasons use {trySub}.
942      *
943      * Counterpart to Solidity's `-` operator.
944      *
945      * Requirements:
946      *
947      * - Subtraction cannot overflow.
948      */
949     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
950         unchecked {
951             require(b <= a, errorMessage);
952             return a - b;
953         }
954     }
955 
956     /**
957      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
958      * division by zero. The result is rounded towards zero.
959      *
960      * Counterpart to Solidity's `%` operator. This function uses a `revert`
961      * opcode (which leaves remaining gas untouched) while Solidity uses an
962      * invalid opcode to revert (consuming all remaining gas).
963      *
964      * Counterpart to Solidity's `/` operator. Note: this function uses a
965      * `revert` opcode (which leaves remaining gas untouched) while Solidity
966      * uses an invalid opcode to revert (consuming all remaining gas).
967      *
968      * Requirements:
969      *
970      * - The divisor cannot be zero.
971      */
972     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
973         unchecked {
974             require(b > 0, errorMessage);
975             return a / b;
976         }
977     }
978 
979     /**
980      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
981      * reverting with custom message when dividing by zero.
982      *
983      * CAUTION: This function is deprecated because it requires allocating memory for the error
984      * message unnecessarily. For custom revert reasons use {tryMod}.
985      *
986      * Counterpart to Solidity's `%` operator. This function uses a `revert`
987      * opcode (which leaves remaining gas untouched) while Solidity uses an
988      * invalid opcode to revert (consuming all remaining gas).
989      *
990      * Requirements:
991      *
992      * - The divisor cannot be zero.
993      */
994     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
995         unchecked {
996             require(b > 0, errorMessage);
997             return a % b;
998         }
999     }
1000 }
1001 
1002 
1003 // File: contracts/LinearVestingVault.sol
1004 
1005 pragma solidity ^0.8.0;
1006 
1007 
1008 
1009 
1010 
1011 /**
1012  * @title LinearVestingVault
1013  * @dev A token vesting contract that will release tokens gradually like a standard
1014  * equity vesting schedule, with a cliff and vesting period but no arbitrary restrictions
1015  * on the frequency of claims. Optionally has an initial tranche claimable immediately
1016  * after the cliff expires.
1017  */
1018 contract LinearVestingVault is Ownable {
1019     using SafeMath for uint256;
1020     using SafeERC20 for ERC20;
1021 
1022     event Issued(
1023         address beneficiary,
1024         uint256 amount,
1025         uint256 start,
1026         uint256 cliff,
1027         uint256 duration
1028     );
1029 
1030     event Released(address beneficiary, uint256 amount, uint256 remaining);
1031     event Revoked(address beneficiary, uint256 allocationAmount, uint256 revokedAmount);
1032 
1033     struct Allocation {
1034         uint256 start;
1035         uint256 cliff;
1036         uint256 duration;
1037         uint256 total;
1038         uint256 claimed;
1039         uint256 initial;
1040     }
1041 
1042     ERC20 public token;
1043     mapping(address => Allocation) public allocations;
1044 
1045     /**
1046      * @dev Creates a vesting contract that releases allocations of an ERC20 token over time.
1047      * @param _token ERC20 token to be vested
1048      */
1049     constructor(ERC20 _token) {
1050         token = _token;
1051     }
1052 
1053     /**
1054      * @dev Creates a new allocation for a beneficiary. Tokens are released linearly over
1055      * time until a given number of seconds have passed since the start of the vesting
1056      * schedule.
1057      * @param _beneficiary address to which tokens will be released
1058      * @param _amount uint256 amount of the allocation (in wei)
1059      * @param _startAt uint256 the unix timestamp at which the vesting may begin
1060      * @param _cliff uint256 the number of seconds after _startAt before which no vesting occurs
1061      * @param _duration uint256 the number of seconds after which the entire allocation is vested
1062      * @param _initialPct uint256 percentage of the allocation initially available (integer, 0-100)
1063      */
1064     function issue(
1065         address _beneficiary,
1066         uint256 _amount,
1067         uint256 _startAt,
1068         uint256 _cliff,
1069         uint256 _duration,
1070         uint256 _initialPct
1071     ) public onlyOwner {
1072         require(token.allowance(msg.sender, address(this)) >= _amount, "Token allowance not sufficient");
1073         require(_beneficiary != address(0), "Cannot grant tokens to the zero address");
1074         require(_cliff <= _duration, "Cliff must not exceed duration");
1075         require(_initialPct <= 100, "Initial release percentage must be an integer 0 to 100 (inclusive)");
1076 
1077         token.safeTransferFrom(msg.sender, address(this), _amount);
1078         Allocation storage allocation = allocations[_beneficiary];
1079         require(allocation.total == 0, "Cannot overwrite existing allocations");
1080 
1081         allocation.total = _amount;
1082         allocation.start = _startAt;
1083         allocation.cliff = _cliff;
1084         allocation.duration = _duration;
1085         
1086         allocation.initial = _amount.mul(_initialPct).div(100);
1087         emit Issued(_beneficiary, _amount, _startAt, _cliff, _duration);
1088     }
1089     
1090     /**
1091      * @dev Revokes an existing allocation. Any vested tokens are transferred
1092      * to the beneficiary and the remainder are returned to the contract's owner.
1093      * @param _beneficiary The address whose allocation is to be revoked
1094      */
1095     function revoke(
1096         address _beneficiary
1097     ) public onlyOwner {
1098         Allocation storage allocation = allocations[_beneficiary];
1099         
1100         uint256 total = allocation.total;
1101         uint256 remainder = total.sub(allocation.claimed);
1102         delete allocations[_beneficiary];
1103         
1104         token.safeTransfer(msg.sender, remainder);
1105         emit Revoked(
1106             _beneficiary,
1107             total,
1108             remainder
1109         );
1110     }
1111 
1112     /**
1113      * @dev Transfers vested tokens to a given beneficiary. Callable by anyone.
1114      * @param beneficiary address which is being vested
1115      */
1116     function release(address beneficiary) public {
1117         Allocation storage allocation = allocations[beneficiary];
1118 
1119         uint256 amount = _releasableAmount(allocation);
1120         require(amount > 0, "Nothing to release");
1121         
1122         allocation.claimed = allocation.claimed.add(amount);
1123         token.safeTransfer(beneficiary, amount);
1124         emit Released(
1125             beneficiary,
1126             amount,
1127             allocation.total.sub(allocation.claimed)
1128         );
1129     }
1130     
1131     /**
1132      * @dev Calculates the amount that has already vested but has not been
1133      * released yet for a given address.
1134      * @param beneficiary Address to check
1135      */
1136     function releasableAmount(address beneficiary)
1137         public
1138         view
1139         returns (uint256)
1140     {
1141         Allocation storage allocation = allocations[beneficiary];
1142         return _releasableAmount(allocation);
1143     }
1144 
1145     /**
1146      * @dev Calculates the amount that has already vested but hasn't been released yet.
1147      * @param allocation Allocation to calculate against
1148      */
1149     function _releasableAmount(Allocation storage allocation)
1150         internal
1151         view
1152         returns (uint256)
1153     {
1154         return _vestedAmount(allocation).sub(allocation.claimed);
1155     }
1156 
1157     /**
1158      * @dev Calculates the amount that has already vested.
1159      * @param allocation Allocation to calculate against
1160      */
1161     function _vestedAmount(Allocation storage allocation)
1162         internal
1163         view
1164         returns (uint256 amount)
1165     {
1166         if (block.timestamp < allocation.start.add(allocation.cliff)) {
1167             amount = 0;
1168         } else if (block.timestamp >= allocation.start.add(allocation.duration)) {
1169             // if the entire duration has elapsed, everything is vested
1170             amount = allocation.total;
1171         } else {
1172             // the "initial" amount is available once the cliff expires, plus the
1173             // proportion of tokens vested as of the current block's timestamp
1174             amount = allocation.initial.add(
1175                 allocation.total
1176                     .sub(allocation.initial)
1177                     .sub(amount)
1178                     .mul(block.timestamp.sub(allocation.start))
1179                     .div(allocation.duration)
1180             );
1181         }
1182         
1183         return amount;
1184     }
1185 }