1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.1;
3 
4 /**
5  * @dev Collection of functions related to the address type
6  */
7 library Address {
8     /**
9      * @dev Returns true if `account` is a contract.
10      *
11      * [IMPORTANT]
12      * ====
13      * It is unsafe to assume that an address for which this function returns
14      * false is an externally-owned account (EOA) and not a contract.
15      *
16      * Among others, `isContract` will return false for the following
17      * types of addresses:
18      *
19      *  - an externally-owned account
20      *  - a contract in construction
21      *  - an address where a contract will be created
22      *  - an address where a contract lived, but was destroyed
23      * ====
24      *
25      * [IMPORTANT]
26      * ====
27      * You shouldn't rely on `isContract` to protect against flash loan attacks!
28      *
29      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
30      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
31      * constructor.
32      * ====
33      */
34     function isContract(address account) internal view returns (bool) {
35         // This method relies on extcodesize/address.code.length, which returns 0
36         // for contracts in construction, since the code is only stored at the end
37         // of the constructor execution.
38 
39         return account.code.length > 0;
40     }
41 
42     /**
43      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
44      * `recipient`, forwarding all available gas and reverting on errors.
45      *
46      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
47      * of certain opcodes, possibly making contracts go over the 2300 gas limit
48      * imposed by `transfer`, making them unable to receive funds via
49      * `transfer`. {sendValue} removes this limitation.
50      *
51      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
52      *
53      * IMPORTANT: because control is transferred to `recipient`, care must be
54      * taken to not create reentrancy vulnerabilities. Consider using
55      * {ReentrancyGuard} or the
56      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
57      */
58     function sendValue(address payable recipient, uint256 amount) internal {
59         require(address(this).balance >= amount, "Address: insufficient balance");
60 
61         (bool success, ) = recipient.call{value: amount}("");
62         require(success, "Address: unable to send value, recipient may have reverted");
63     }
64 
65     /**
66      * @dev Performs a Solidity function call using a low level `call`. A
67      * plain `call` is an unsafe replacement for a function call: use this
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
84         return functionCall(target, data, "Address: low-level call failed");
85     }
86 
87     /**
88      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
89      * `errorMessage` as a fallback revert reason when `target` reverts.
90      *
91      * _Available since v3.1._
92      */
93     function functionCall(
94         address target,
95         bytes memory data,
96         string memory errorMessage
97     ) internal returns (bytes memory) {
98         return functionCallWithValue(target, data, 0, errorMessage);
99     }
100 
101     /**
102      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
103      * but also transferring `value` wei to `target`.
104      *
105      * Requirements:
106      *
107      * - the calling contract must have an ETH balance of at least `value`.
108      * - the called Solidity function must be `payable`.
109      *
110      * _Available since v3.1._
111      */
112     function functionCallWithValue(
113         address target,
114         bytes memory data,
115         uint256 value
116     ) internal returns (bytes memory) {
117         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
118     }
119 
120     /**
121      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
122      * with `errorMessage` as a fallback revert reason when `target` reverts.
123      *
124      * _Available since v3.1._
125      */
126     function functionCallWithValue(
127         address target,
128         bytes memory data,
129         uint256 value,
130         string memory errorMessage
131     ) internal returns (bytes memory) {
132         require(address(this).balance >= value, "Address: insufficient balance for call");
133         require(isContract(target), "Address: call to non-contract");
134 
135         (bool success, bytes memory returndata) = target.call{value: value}(data);
136         return verifyCallResult(success, returndata, errorMessage);
137     }
138 
139     /**
140      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
141      * but performing a static call.
142      *
143      * _Available since v3.3._
144      */
145     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
146         return functionStaticCall(target, data, "Address: low-level static call failed");
147     }
148 
149     /**
150      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
151      * but performing a static call.
152      *
153      * _Available since v3.3._
154      */
155     function functionStaticCall(
156         address target,
157         bytes memory data,
158         string memory errorMessage
159     ) internal view returns (bytes memory) {
160         require(isContract(target), "Address: static call to non-contract");
161 
162         (bool success, bytes memory returndata) = target.staticcall(data);
163         return verifyCallResult(success, returndata, errorMessage);
164     }
165 
166     /**
167      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
168      * but performing a delegate call.
169      *
170      * _Available since v3.4._
171      */
172     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
173         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
174     }
175 
176     /**
177      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
178      * but performing a delegate call.
179      *
180      * _Available since v3.4._
181      */
182     function functionDelegateCall(
183         address target,
184         bytes memory data,
185         string memory errorMessage
186     ) internal returns (bytes memory) {
187         require(isContract(target), "Address: delegate call to non-contract");
188 
189         (bool success, bytes memory returndata) = target.delegatecall(data);
190         return verifyCallResult(success, returndata, errorMessage);
191     }
192 
193     /**
194      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
195      * revert reason using the provided one.
196      *
197      * _Available since v4.3._
198      */
199     function verifyCallResult(
200         bool success,
201         bytes memory returndata,
202         string memory errorMessage
203     ) internal pure returns (bytes memory) {
204         if (success) {
205             return returndata;
206         } else {
207             // Look for revert reason and bubble it up if present
208             if (returndata.length > 0) {
209                 // The easiest way to bubble the revert reason is using memory via assembly
210 
211                 assembly {
212                     let returndata_size := mload(returndata)
213                     revert(add(32, returndata), returndata_size)
214                 }
215             } else {
216                 revert(errorMessage);
217             }
218         }
219     }
220 }
221 
222 pragma solidity ^0.8.0;
223 
224 /**
225  * @dev Interface of the ERC20 standard as defined in the EIP.
226  */
227 interface IERC20 {
228     /**
229      * @dev Returns the amount of tokens in existence.
230      */
231     function totalSupply() external view returns (uint256);
232 
233     /**
234      * @dev Returns the amount of tokens owned by `account`.
235      */
236     function balanceOf(address account) external view returns (uint256);
237 
238     /**
239      * @dev Moves `amount` tokens from the caller's account to `to`.
240      *
241      * Returns a boolean value indicating whether the operation succeeded.
242      *
243      * Emits a {Transfer} event.
244      */
245     function transfer(address to, uint256 amount) external returns (bool);
246 
247     /**
248      * @dev Returns the remaining number of tokens that `spender` will be
249      * allowed to spend on behalf of `owner` through {transferFrom}. This is
250      * zero by default.
251      *
252      * This value changes when {approve} or {transferFrom} are called.
253      */
254     function allowance(address owner, address spender) external view returns (uint256);
255 
256     /**
257      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
258      *
259      * Returns a boolean value indicating whether the operation succeeded.
260      *
261      * IMPORTANT: Beware that changing an allowance with this method brings the risk
262      * that someone may use both the old and the new allowance by unfortunate
263      * transaction ordering. One possible solution to mitigate this race
264      * condition is to first reduce the spender's allowance to 0 and set the
265      * desired value afterwards:
266      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
267      *
268      * Emits an {Approval} event.
269      */
270     function approve(address spender, uint256 amount) external returns (bool);
271 
272     /**
273      * @dev Moves `amount` tokens from `from` to `to` using the
274      * allowance mechanism. `amount` is then deducted from the caller's
275      * allowance.
276      *
277      * Returns a boolean value indicating whether the operation succeeded.
278      *
279      * Emits a {Transfer} event.
280      */
281     function transferFrom(
282         address from,
283         address to,
284         uint256 amount
285     ) external returns (bool);
286 
287     /**
288      * @dev Emitted when `value` tokens are moved from one account (`from`) to
289      * another (`to`).
290      *
291      * Note that `value` may be zero.
292      */
293     event Transfer(address indexed from, address indexed to, uint256 value);
294 
295     /**
296      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
297      * a call to {approve}. `value` is the new allowance.
298      */
299     event Approval(address indexed owner, address indexed spender, uint256 value);
300 }
301 
302 interface IERC20Metadata is IERC20 {
303     /**
304      * @dev Returns the name of the token.
305      */
306     function name() external view returns (string memory);
307 
308     /**
309      * @dev Returns the symbol of the token.
310      */
311     function symbol() external view returns (string memory);
312 
313     /**
314      * @dev Returns the decimals places of the token.
315      */
316     function decimals() external view returns (uint8);
317 }
318 
319 abstract contract Context {
320     function _msgSender() internal view virtual returns (address) {
321         return msg.sender;
322     }
323 
324     function _msgData() internal view virtual returns (bytes calldata) {
325         return msg.data;
326     }
327 }
328 
329 /**
330  * @dev Implementation of the {IERC20} interface.
331  *
332  * This implementation is agnostic to the way tokens are created. This means
333  * that a supply mechanism has to be added in a derived contract using {_mint}.
334  * For a generic mechanism see {ERC20PresetMinterPauser}.
335  *
336  * TIP: For a detailed writeup see our guide
337  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
338  * to implement supply mechanisms].
339  *
340  * We have followed general OpenZeppelin Contracts guidelines: functions revert
341  * instead returning `false` on failure. This behavior is nonetheless
342  * conventional and does not conflict with the expectations of ERC20
343  * applications.
344  *
345  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
346  * This allows applications to reconstruct the allowance for all accounts just
347  * by listening to said events. Other implementations of the EIP may not emit
348  * these events, as it isn't required by the specification.
349  *
350  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
351  * functions have been added to mitigate the well-known issues around setting
352  * allowances. See {IERC20-approve}.
353  */
354 contract ERC20 is Context, IERC20, IERC20Metadata {
355     mapping(address => uint256) private _balances;
356 
357     mapping(address => mapping(address => uint256)) private _allowances;
358 
359     uint256 private _totalSupply;
360 
361     string private _name;
362     string private _symbol;
363 
364     /**
365      * @dev Sets the values for {name} and {symbol}.
366      *
367      * The default value of {decimals} is 18. To select a different value for
368      * {decimals} you should overload it.
369      *
370      * All two of these values are immutable: they can only be set once during
371      * construction.
372      */
373     constructor(string memory name_, string memory symbol_) {
374         _name = name_;
375         _symbol = symbol_;
376     }
377 
378     /**
379      * @dev Returns the name of the token.
380      */
381     function name() public view virtual override returns (string memory) {
382         return _name;
383     }
384 
385     /**
386      * @dev Returns the symbol of the token, usually a shorter version of the
387      * name.
388      */
389     function symbol() public view virtual override returns (string memory) {
390         return _symbol;
391     }
392 
393     /**
394      * @dev Returns the number of decimals used to get its user representation.
395      * For example, if `decimals` equals `2`, a balance of `505` tokens should
396      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
397      *
398      * Tokens usually opt for a value of 18, imitating the relationship between
399      * Ether and Wei. This is the value {ERC20} uses, unless this function is
400      * overridden;
401      *
402      * NOTE: This information is only used for _display_ purposes: it in
403      * no way affects any of the arithmetic of the contract, including
404      * {IERC20-balanceOf} and {IERC20-transfer}.
405      */
406     function decimals() public view virtual override returns (uint8) {
407         return 18;
408     }
409 
410     /**
411      * @dev See {IERC20-totalSupply}.
412      */
413     function totalSupply() public view virtual override returns (uint256) {
414         return _totalSupply;
415     }
416 
417     /**
418      * @dev See {IERC20-balanceOf}.
419      */
420     function balanceOf(address account) public view virtual override returns (uint256) {
421         return _balances[account];
422     }
423 
424     /**
425      * @dev See {IERC20-transfer}.
426      *
427      * Requirements:
428      *
429      * - `to` cannot be the zero address.
430      * - the caller must have a balance of at least `amount`.
431      */
432     function transfer(address to, uint256 amount) public virtual override returns (bool) {
433         address owner = _msgSender();
434         _transfer(owner, to, amount);
435         return true;
436     }
437 
438     /**
439      * @dev See {IERC20-allowance}.
440      */
441     function allowance(address owner, address spender) public view virtual override returns (uint256) {
442         return _allowances[owner][spender];
443     }
444 
445     /**
446      * @dev See {IERC20-approve}.
447      *
448      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
449      * `transferFrom`. This is semantically equivalent to an infinite approval.
450      *
451      * Requirements:
452      *
453      * - `spender` cannot be the zero address.
454      */
455     function approve(address spender, uint256 amount) public virtual override returns (bool) {
456         address owner = _msgSender();
457         _approve(owner, spender, amount);
458         return true;
459     }
460 
461     /**
462      * @dev See {IERC20-transferFrom}.
463      *
464      * Emits an {Approval} event indicating the updated allowance. This is not
465      * required by the EIP. See the note at the beginning of {ERC20}.
466      *
467      * NOTE: Does not update the allowance if the current allowance
468      * is the maximum `uint256`.
469      *
470      * Requirements:
471      *
472      * - `from` and `to` cannot be the zero address.
473      * - `from` must have a balance of at least `amount`.
474      * - the caller must have allowance for ``from``'s tokens of at least
475      * `amount`.
476      */
477     function transferFrom(
478         address from,
479         address to,
480         uint256 amount
481     ) public virtual override returns (bool) {
482         address spender = _msgSender();
483         _spendAllowance(from, spender, amount);
484         _transfer(from, to, amount);
485         return true;
486     }
487 
488     /**
489      * @dev Atomically increases the allowance granted to `spender` by the caller.
490      *
491      * This is an alternative to {approve} that can be used as a mitigation for
492      * problems described in {IERC20-approve}.
493      *
494      * Emits an {Approval} event indicating the updated allowance.
495      *
496      * Requirements:
497      *
498      * - `spender` cannot be the zero address.
499      */
500     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
501         address owner = _msgSender();
502         _approve(owner, spender, _allowances[owner][spender] + addedValue);
503         return true;
504     }
505 
506     /**
507      * @dev Atomically decreases the allowance granted to `spender` by the caller.
508      *
509      * This is an alternative to {approve} that can be used as a mitigation for
510      * problems described in {IERC20-approve}.
511      *
512      * Emits an {Approval} event indicating the updated allowance.
513      *
514      * Requirements:
515      *
516      * - `spender` cannot be the zero address.
517      * - `spender` must have allowance for the caller of at least
518      * `subtractedValue`.
519      */
520     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
521         address owner = _msgSender();
522         uint256 currentAllowance = _allowances[owner][spender];
523         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
524         unchecked {
525             _approve(owner, spender, currentAllowance - subtractedValue);
526         }
527 
528         return true;
529     }
530 
531     /**
532      * @dev Moves `amount` of tokens from `sender` to `recipient`.
533      *
534      * This internal function is equivalent to {transfer}, and can be used to
535      * e.g. implement automatic token fees, slashing mechanisms, etc.
536      *
537      * Emits a {Transfer} event.
538      *
539      * Requirements:
540      *
541      * - `from` cannot be the zero address.
542      * - `to` cannot be the zero address.
543      * - `from` must have a balance of at least `amount`.
544      */
545     function _transfer(
546         address from,
547         address to,
548         uint256 amount
549     ) internal virtual {
550         require(from != address(0), "ERC20: transfer from the zero address");
551         require(to != address(0), "ERC20: transfer to the zero address");
552 
553         _beforeTokenTransfer(from, to, amount);
554 
555         uint256 fromBalance = _balances[from];
556         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
557         unchecked {
558             _balances[from] = fromBalance - amount;
559         }
560         _balances[to] += amount;
561 
562         emit Transfer(from, to, amount);
563 
564         _afterTokenTransfer(from, to, amount);
565     }
566 
567     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
568      * the total supply.
569      *
570      * Emits a {Transfer} event with `from` set to the zero address.
571      *
572      * Requirements:
573      *
574      * - `account` cannot be the zero address.
575      */
576     function _mint(address account, uint256 amount) internal virtual {
577         require(account != address(0), "ERC20: mint to the zero address");
578 
579         _beforeTokenTransfer(address(0), account, amount);
580 
581         _totalSupply += amount;
582         _balances[account] += amount;
583         emit Transfer(address(0), account, amount);
584 
585         _afterTokenTransfer(address(0), account, amount);
586     }
587 
588     /**
589      * @dev Destroys `amount` tokens from `account`, reducing the
590      * total supply.
591      *
592      * Emits a {Transfer} event with `to` set to the zero address.
593      *
594      * Requirements:
595      *
596      * - `account` cannot be the zero address.
597      * - `account` must have at least `amount` tokens.
598      */
599     function _burn(address account, uint256 amount) internal virtual {
600         require(account != address(0), "ERC20: burn from the zero address");
601 
602         _beforeTokenTransfer(account, address(0), amount);
603 
604         uint256 accountBalance = _balances[account];
605         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
606         unchecked {
607             _balances[account] = accountBalance - amount;
608         }
609         _totalSupply -= amount;
610 
611         emit Transfer(account, address(0), amount);
612 
613         _afterTokenTransfer(account, address(0), amount);
614     }
615 
616     /**
617      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
618      *
619      * This internal function is equivalent to `approve`, and can be used to
620      * e.g. set automatic allowances for certain subsystems, etc.
621      *
622      * Emits an {Approval} event.
623      *
624      * Requirements:
625      *
626      * - `owner` cannot be the zero address.
627      * - `spender` cannot be the zero address.
628      */
629     function _approve(
630         address owner,
631         address spender,
632         uint256 amount
633     ) internal virtual {
634         require(owner != address(0), "ERC20: approve from the zero address");
635         require(spender != address(0), "ERC20: approve to the zero address");
636 
637         _allowances[owner][spender] = amount;
638         emit Approval(owner, spender, amount);
639     }
640 
641     /**
642      * @dev Spend `amount` form the allowance of `owner` toward `spender`.
643      *
644      * Does not update the allowance amount in case of infinite allowance.
645      * Revert if not enough allowance is available.
646      *
647      * Might emit an {Approval} event.
648      */
649     function _spendAllowance(
650         address owner,
651         address spender,
652         uint256 amount
653     ) internal virtual {
654         uint256 currentAllowance = allowance(owner, spender);
655         if (currentAllowance != type(uint256).max) {
656             require(currentAllowance >= amount, "ERC20: insufficient allowance");
657             unchecked {
658                 _approve(owner, spender, currentAllowance - amount);
659             }
660         }
661     }
662 
663     /**
664      * @dev Hook that is called before any transfer of tokens. This includes
665      * minting and burning.
666      *
667      * Calling conditions:
668      *
669      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
670      * will be transferred to `to`.
671      * - when `from` is zero, `amount` tokens will be minted for `to`.
672      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
673      * - `from` and `to` are never both zero.
674      *
675      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
676      */
677     function _beforeTokenTransfer(
678         address from,
679         address to,
680         uint256 amount
681     ) internal virtual {}
682 
683     /**
684      * @dev Hook that is called after any transfer of tokens. This includes
685      * minting and burning.
686      *
687      * Calling conditions:
688      *
689      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
690      * has been transferred to `to`.
691      * - when `from` is zero, `amount` tokens have been minted for `to`.
692      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
693      * - `from` and `to` are never both zero.
694      *
695      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
696      */
697     function _afterTokenTransfer(
698         address from,
699         address to,
700         uint256 amount
701     ) internal virtual {}
702 }
703 
704 abstract contract Ownable is Context {
705     address private _owner;
706 
707     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
708 
709     /**
710      * @dev Initializes the contract setting the deployer as the initial owner.
711      */
712     constructor() {
713         _transferOwnership(_msgSender());
714     }
715 
716     /**
717      * @dev Returns the address of the current owner.
718      */
719     function owner() public view virtual returns (address) {
720         return _owner;
721     }
722 
723     /**
724      * @dev Throws if called by any account other than the owner.
725      */
726     modifier onlyOwner() {
727         require(owner() == _msgSender(), "Ownable: caller is not the owner");
728         _;
729     }
730 
731     /**
732      * @dev Leaves the contract without owner. It will not be possible to call
733      * `onlyOwner` functions anymore. Can only be called by the current owner.
734      *
735      * NOTE: Renouncing ownership will leave the contract without an owner,
736      * thereby removing any functionality that is only available to the owner.
737      */
738     function renounceOwnership() public virtual onlyOwner {
739         _transferOwnership(address(0));
740     }
741 
742     /**
743      * @dev Transfers ownership of the contract to a new account (`newOwner`).
744      * Can only be called by the current owner.
745      */
746     function transferOwnership(address newOwner) public virtual onlyOwner {
747         require(newOwner != address(0), "Ownable: new owner is the zero address");
748         _transferOwnership(newOwner);
749     }
750 
751     /**
752      * @dev Transfers ownership of the contract to a new account (`newOwner`).
753      * Internal function without access restriction.
754      */
755     function _transferOwnership(address newOwner) internal virtual {
756         address oldOwner = _owner;
757         _owner = newOwner;
758         emit OwnershipTransferred(oldOwner, newOwner);
759     }
760 }
761 
762 library SafeERC20 {
763     using Address for address;
764 
765     function safeTransfer(
766         IERC20 token,
767         address to,
768         uint256 value
769     ) internal {
770         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
771     }
772 
773     function safeTransferFrom(
774         IERC20 token,
775         address from,
776         address to,
777         uint256 value
778     ) internal {
779         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
780     }
781 
782     /**
783      * @dev Deprecated. This function has issues similar to the ones found in
784      * {IERC20-approve}, and its usage is discouraged.
785      *
786      * Whenever possible, use {safeIncreaseAllowance} and
787      * {safeDecreaseAllowance} instead.
788      */
789     function safeApprove(
790         IERC20 token,
791         address spender,
792         uint256 value
793     ) internal {
794         // safeApprove should only be called when setting an initial allowance,
795         // or when resetting it to zero. To increase and decrease it, use
796         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
797         require(
798             (value == 0) || (token.allowance(address(this), spender) == 0),
799             "SafeERC20: approve from non-zero to non-zero allowance"
800         );
801         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
802     }
803 
804     function safeIncreaseAllowance(
805         IERC20 token,
806         address spender,
807         uint256 value
808     ) internal {
809         uint256 newAllowance = token.allowance(address(this), spender) + value;
810         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
811     }
812 
813     function safeDecreaseAllowance(
814         IERC20 token,
815         address spender,
816         uint256 value
817     ) internal {
818         unchecked {
819             uint256 oldAllowance = token.allowance(address(this), spender);
820             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
821             uint256 newAllowance = oldAllowance - value;
822             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
823         }
824     }
825 
826     /**
827      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
828      * on the return value: the return value is optional (but if data is returned, it must not be false).
829      * @param token The token targeted by the call.
830      * @param data The call data (encoded using abi.encode or one of its variants).
831      */
832     function _callOptionalReturn(IERC20 token, bytes memory data) private {
833         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
834         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
835         // the target address contains contract code and also asserts for success in the low-level call.
836 
837         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
838         if (returndata.length > 0) {
839             // Return data is optional
840             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
841         }
842     }
843 }
844 pragma solidity 0.8.18;
845 
846 interface IUniswapV2Router01 {
847     function factory() external pure returns (address);
848 
849     function WETH() external pure returns (address);
850 
851     function addLiquidity(
852         address tokenA,
853         address tokenB,
854         uint256 amountADesired,
855         uint256 amountBDesired,
856         uint256 amountAMin,
857         uint256 amountBMin,
858         address to,
859         uint256 deadline
860     )
861         external
862         returns (
863             uint256 amountA,
864             uint256 amountB,
865             uint256 liquidity
866         );
867 
868     function addLiquidityETH(
869         address token,
870         uint256 amountTokenDesired,
871         uint256 amountTokenMin,
872         uint256 amountETHMin,
873         address to,
874         uint256 deadline
875     )
876         external
877         payable
878         returns (
879             uint256 amountToken,
880             uint256 amountETH,
881             uint256 liquidity
882         );
883 
884     function removeLiquidity(
885         address tokenA,
886         address tokenB,
887         uint256 liquidity,
888         uint256 amountAMin,
889         uint256 amountBMin,
890         address to,
891         uint256 deadline
892     ) external returns (uint256 amountA, uint256 amountB);
893 
894     function removeLiquidityETH(
895         address token,
896         uint256 liquidity,
897         uint256 amountTokenMin,
898         uint256 amountETHMin,
899         address to,
900         uint256 deadline
901     ) external returns (uint256 amountToken, uint256 amountETH);
902 
903     function removeLiquidityWithPermit(
904         address tokenA,
905         address tokenB,
906         uint256 liquidity,
907         uint256 amountAMin,
908         uint256 amountBMin,
909         address to,
910         uint256 deadline,
911         bool approveMax,
912         uint8 v,
913         bytes32 r,
914         bytes32 s
915     ) external returns (uint256 amountA, uint256 amountB);
916 
917     function removeLiquidityETHWithPermit(
918         address token,
919         uint256 liquidity,
920         uint256 amountTokenMin,
921         uint256 amountETHMin,
922         address to,
923         uint256 deadline,
924         bool approveMax,
925         uint8 v,
926         bytes32 r,
927         bytes32 s
928     ) external returns (uint256 amountToken, uint256 amountETH);
929 
930     function swapExactTokensForTokens(
931         uint256 amountIn,
932         uint256 amountOutMin,
933         address[] calldata path,
934         address to,
935         uint256 deadline
936     ) external returns (uint256[] memory amounts);
937 
938     function swapTokensForExactTokens(
939         uint256 amountOut,
940         uint256 amountInMax,
941         address[] calldata path,
942         address to,
943         uint256 deadline
944     ) external returns (uint256[] memory amounts);
945 
946     function swapExactETHForTokens(
947         uint256 amountOutMin,
948         address[] calldata path,
949         address to,
950         uint256 deadline
951     ) external payable returns (uint256[] memory amounts);
952 
953     function swapTokensForExactETH(
954         uint256 amountOut,
955         uint256 amountInMax,
956         address[] calldata path,
957         address to,
958         uint256 deadline
959     ) external returns (uint256[] memory amounts);
960 
961     function swapExactTokensForETH(
962         uint256 amountIn,
963         uint256 amountOutMin,
964         address[] calldata path,
965         address to,
966         uint256 deadline
967     ) external returns (uint256[] memory amounts);
968 
969     function swapETHForExactTokens(
970         uint256 amountOut,
971         address[] calldata path,
972         address to,
973         uint256 deadline
974     ) external payable returns (uint256[] memory amounts);
975 
976     function quote(
977         uint256 amountA,
978         uint256 reserveA,
979         uint256 reserveB
980     ) external pure returns (uint256 amountB);
981 
982     function getAmountOut(
983         uint256 amountIn,
984         uint256 reserveIn,
985         uint256 reserveOut
986     ) external pure returns (uint256 amountOut);
987 
988     function getAmountIn(
989         uint256 amountOut,
990         uint256 reserveIn,
991         uint256 reserveOut
992     ) external pure returns (uint256 amountIn);
993 
994     function getAmountsOut(uint256 amountIn, address[] calldata path)
995         external
996         view
997         returns (uint256[] memory amounts);
998 
999     function getAmountsIn(uint256 amountOut, address[] calldata path)
1000         external
1001         view
1002         returns (uint256[] memory amounts);
1003 }
1004 
1005 interface IUniswapV2Router02 is IUniswapV2Router01 {
1006     function removeLiquidityETHSupportingFeeOnTransferTokens(
1007         address token,
1008         uint256 liquidity,
1009         uint256 amountTokenMin,
1010         uint256 amountETHMin,
1011         address to,
1012         uint256 deadline
1013     ) external returns (uint256 amountETH);
1014 
1015     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
1016         address token,
1017         uint256 liquidity,
1018         uint256 amountTokenMin,
1019         uint256 amountETHMin,
1020         address to,
1021         uint256 deadline,
1022         bool approveMax,
1023         uint8 v,
1024         bytes32 r,
1025         bytes32 s
1026     ) external returns (uint256 amountETH);
1027 
1028     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
1029         uint256 amountIn,
1030         uint256 amountOutMin,
1031         address[] calldata path,
1032         address to,
1033         uint256 deadline
1034     ) external;
1035 
1036     function swapExactETHForTokensSupportingFeeOnTransferTokens(
1037         uint256 amountOutMin,
1038         address[] calldata path,
1039         address to,
1040         uint256 deadline
1041     ) external payable;
1042 
1043     function swapExactTokensForETHSupportingFeeOnTransferTokens(
1044         uint256 amountIn,
1045         uint256 amountOutMin,
1046         address[] calldata path,
1047         address to,
1048         uint256 deadline
1049     ) external;
1050 }
1051 
1052 interface IUniswapV2Pair {
1053     event Approval(
1054         address indexed owner,
1055         address indexed spender,
1056         uint256 value
1057     );
1058     event Transfer(address indexed from, address indexed to, uint256 value);
1059 
1060     function name() external pure returns (string memory);
1061 
1062     function symbol() external pure returns (string memory);
1063 
1064     function decimals() external pure returns (uint8);
1065 
1066     function totalSupply() external view returns (uint256);
1067 
1068     function balanceOf(address owner) external view returns (uint256);
1069 
1070     function allowance(address owner, address spender)
1071         external
1072         view
1073         returns (uint256);
1074 
1075     function approve(address spender, uint256 value) external returns (bool);
1076 
1077     function transfer(address to, uint256 value) external returns (bool);
1078 
1079     function transferFrom(
1080         address from,
1081         address to,
1082         uint256 value
1083     ) external returns (bool);
1084 
1085     function DOMAIN_SEPARATOR() external view returns (bytes32);
1086 
1087     function PERMIT_TYPEHASH() external pure returns (bytes32);
1088 
1089     function nonces(address owner) external view returns (uint256);
1090 
1091     function permit(
1092         address owner,
1093         address spender,
1094         uint256 value,
1095         uint256 deadline,
1096         uint8 v,
1097         bytes32 r,
1098         bytes32 s
1099     ) external;
1100 
1101     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
1102     event Burn(
1103         address indexed sender,
1104         uint256 amount0,
1105         uint256 amount1,
1106         address indexed to
1107     );
1108     event Swap(
1109         address indexed sender,
1110         uint256 amount0In,
1111         uint256 amount1In,
1112         uint256 amount0Out,
1113         uint256 amount1Out,
1114         address indexed to
1115     );
1116     event Sync(uint112 reserve0, uint112 reserve1);
1117 
1118     function MINIMUM_LIQUIDITY() external pure returns (uint256);
1119 
1120     function factory() external view returns (address);
1121 
1122     function token0() external view returns (address);
1123 
1124     function token1() external view returns (address);
1125 
1126     function getReserves()
1127         external
1128         view
1129         returns (
1130             uint112 reserve0,
1131             uint112 reserve1,
1132             uint32 blockTimestampLast
1133         );
1134 
1135     function price0CumulativeLast() external view returns (uint256);
1136 
1137     function price1CumulativeLast() external view returns (uint256);
1138 
1139     function kLast() external view returns (uint256);
1140 
1141     function mint(address to) external returns (uint256 liquidity);
1142 
1143     function burn(address to)
1144         external
1145         returns (uint256 amount0, uint256 amount1);
1146 
1147     function swap(
1148         uint256 amount0Out,
1149         uint256 amount1Out,
1150         address to,
1151         bytes calldata data
1152     ) external;
1153 
1154     function skim(address to) external;
1155 
1156     function sync() external;
1157 
1158     function initialize(address, address) external;
1159 }
1160 
1161 interface IUniswapV2Factory {
1162     event PairCreated(
1163         address indexed token0,
1164         address indexed token1,
1165         address pair,
1166         uint256
1167     );
1168 
1169     function feeTo() external view returns (address);
1170 
1171     function feeToSetter() external view returns (address);
1172 
1173     function getPair(address tokenA, address tokenB)
1174         external
1175         view
1176         returns (address pair);
1177 
1178     function allPairs(uint256) external view returns (address pair);
1179 
1180     function allPairsLength() external view returns (uint256);
1181 
1182     function createPair(address tokenA, address tokenB)
1183         external
1184         returns (address pair);
1185 
1186     function setFeeTo(address) external;
1187 
1188     function setFeeToSetter(address) external;
1189 
1190     function INIT_CODE_PAIR_HASH() external view returns (bytes32);
1191 }
1192 
1193 interface IUniswapV2Caller {
1194     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
1195         address router,
1196         uint256 amountIn,
1197         uint256 amountOutMin,
1198         address[] calldata path,
1199         uint256 deadline
1200     ) external;
1201 }
1202 interface IFee {
1203     function payFee(
1204         uint256 _tokenType
1205     ) external payable;
1206 }
1207 contract StandardToken is ERC20, Ownable {
1208     using SafeERC20 for IERC20;
1209     uint256 private constant MAX = ~uint256(0);
1210     IUniswapV2Caller public constant uniswapV2Caller =
1211         IUniswapV2Caller(0x1CcFE8c40eF259566433716002E379dFfFbf5a3e);
1212     IFee public constant feeContract = IFee(0xfd6439AEfF9d2389856B7486b9e74a6DacaDcDCe);
1213     uint8 private _decimals;
1214     ///////////////////////////////////////////////////////////////////////////
1215     address public baseTokenForPair;
1216     bool private inSwapAndLiquify;
1217     uint16 public sellLiquidityFee;
1218     uint16 public buyLiquidityFee;
1219 
1220     uint16 public sellMarketingFee;
1221     uint16 public buyMarketingFee;
1222 
1223     address public marketingWallet;
1224     bool public isMarketingFeeBaseToken;
1225 
1226     uint256 public minAmountToTakeFee;
1227     uint256 public maxWallet;
1228     uint256 public maxTransactionAmount;
1229 
1230     IUniswapV2Router02 public mainRouter;
1231     address public mainPair;
1232 
1233     mapping(address => bool) public isExcludedFromMaxTransactionAmount;
1234     mapping(address => bool) public isExcludedFromFee;
1235     mapping(address => bool) public automatedMarketMakerPairs;
1236 
1237     uint256 private _liquidityFeeTokens;
1238     uint256 private _marketingFeeTokens;
1239     event UpdateLiquidityFee(
1240         uint16 newSellLiquidityFee,
1241         uint16 newBuyLiquidityFee,
1242         uint16 oldSellLiquidityFee,
1243         uint16 oldBuyLiquidityFee
1244     );
1245     event UpdateMarketingFee(
1246         uint16 newSellMarketingFee,
1247         uint16 newBuyMarketingFee,
1248         uint16 oldSellMarketingFee,
1249         uint16 oldBuyMarketingFee
1250     );
1251     event UpdateMarketingWallet(
1252         address indexed newMarketingWallet,
1253         bool newIsMarketingFeeBaseToken,
1254         address indexed oldMarketingWallet,
1255         bool oldIsMarketingFeeBaseToken
1256     );
1257     event ExcludedFromMaxTransactionAmount(address indexed account, bool isExcluded);
1258     event UpdateMinAmountToTakeFee(uint256 newMinAmountToTakeFee, uint256 oldMinAmountToTakeFee);
1259     event SetAutomatedMarketMakerPair(address indexed pair, bool value);
1260     event ExcludedFromFee(address indexed account, bool isEx);
1261     event SwapAndLiquify(
1262         uint256 tokensForLiquidity,
1263         uint256 baseTokenForLiquidity
1264     );
1265     event MarketingFeeTaken(
1266         uint256 marketingFeeTokens,
1267         uint256 marketingFeeBaseTokenSwapped
1268     );
1269     event UpdateUniswapV2Router(address indexed newAddress, address indexed oldRouter);
1270     event UpdateMaxWallet(uint256 newMaxWallet, uint256 oldMaxWallet);
1271     event UpdateMaxTransactionAmount(uint256 newMaxTransactionAmount, uint256 oldMaxTransactionAmount);
1272     ///////////////////////////////////////////////////////////////////////////////
1273  
1274 
1275     constructor(
1276         string memory _name,
1277         string memory _symbol,
1278         uint8 __decimals,
1279         uint256 _totalSupply,
1280         uint256 _maxWallet,
1281         uint256 _maxTransactionAmount,
1282         address[3] memory _accounts,
1283         bool _isMarketingFeeBaseToken,
1284         uint16[4] memory _fees
1285     ) payable ERC20(_name, _symbol) {
1286         feeContract.payFee{value: msg.value}(1);   
1287         _decimals = __decimals;
1288         _mint(msg.sender, _totalSupply );
1289         baseTokenForPair=_accounts[2];
1290         require(_accounts[0]!=address(0), "marketing wallet can not be 0");
1291         require(_accounts[1]!=address(0), "Router address can not be 0");
1292         require(_fees[0]+(_fees[2])<=200, "sell fee <= 20%");
1293         require(_fees[1]+(_fees[3])<=200, "buy fee <= 20%");
1294 
1295         marketingWallet=_accounts[0];
1296         isMarketingFeeBaseToken=_isMarketingFeeBaseToken;
1297         emit UpdateMarketingWallet(
1298             marketingWallet,
1299             isMarketingFeeBaseToken,
1300             address(0),
1301             false
1302         );
1303         mainRouter=IUniswapV2Router02(_accounts[1]);
1304         if(baseTokenForPair != mainRouter.WETH()){            
1305             IERC20(baseTokenForPair).approve(address(mainRouter), MAX);            
1306         }
1307         _approve(address(this), address(uniswapV2Caller), MAX);
1308         _approve(address(this), address(mainRouter), MAX);
1309         
1310         
1311         emit UpdateUniswapV2Router(address(mainRouter), address(0));
1312         mainPair = IUniswapV2Factory(mainRouter.factory()).createPair(
1313             address(this),
1314             baseTokenForPair
1315         );
1316         require(_maxTransactionAmount>=_totalSupply / 10000, "maxTransactionAmount >= total supply / 10000");
1317         require(_maxWallet>=_totalSupply / 10000, "maxWallet >= total supply / 10000");
1318         maxWallet=_maxWallet;
1319         emit UpdateMaxWallet(maxWallet, 0);
1320         maxTransactionAmount=_maxTransactionAmount;
1321         emit UpdateMaxTransactionAmount(maxTransactionAmount, 0);
1322         
1323         sellLiquidityFee=_fees[0];
1324         buyLiquidityFee=_fees[1];
1325         emit UpdateLiquidityFee(sellLiquidityFee, buyLiquidityFee, 0, 0);        
1326         sellMarketingFee=_fees[2];
1327         buyMarketingFee=_fees[3];
1328         emit UpdateMarketingFee(
1329             sellMarketingFee,
1330             buyMarketingFee,
1331             0,
1332             0
1333         );
1334         minAmountToTakeFee=_totalSupply/10000;
1335         emit UpdateMinAmountToTakeFee(minAmountToTakeFee, 0);
1336         isExcludedFromFee[address(this)]=true;
1337         isExcludedFromFee[marketingWallet]=true;
1338         isExcludedFromFee[_msgSender()]=true;
1339         isExcludedFromFee[address(0xdead)] = true;
1340         isExcludedFromMaxTransactionAmount[address(0xdead)]=true;
1341         isExcludedFromMaxTransactionAmount[address(this)]=true;
1342         isExcludedFromMaxTransactionAmount[marketingWallet]=true;
1343         isExcludedFromMaxTransactionAmount[_msgSender()]=true;
1344         _setAutomatedMarketMakerPair(mainPair, true);
1345     }
1346 
1347     function decimals() public view override returns (uint8) {
1348         return _decimals;
1349     }
1350 
1351     function updateUniswapV2Pair(address _baseTokenForPair) external onlyOwner {
1352         baseTokenForPair = _baseTokenForPair;
1353         mainPair = IUniswapV2Factory(mainRouter.factory()).createPair(
1354             address(this),
1355             baseTokenForPair
1356         );
1357         if(baseTokenForPair != mainRouter.WETH()){
1358             IERC20(baseTokenForPair).approve(address(mainRouter), MAX);            
1359         }
1360         _setAutomatedMarketMakerPair(mainPair, true);
1361     }
1362 
1363     function updateUniswapV2Router(address newAddress) public onlyOwner {
1364         require(
1365             newAddress != address(mainRouter),
1366             "The router already has that address"
1367         );
1368         emit UpdateUniswapV2Router(newAddress, address(mainRouter));
1369         mainRouter = IUniswapV2Router02(newAddress);
1370         _approve(address(this), address(mainRouter), MAX);
1371         if(baseTokenForPair != mainRouter.WETH()){
1372             IERC20(baseTokenForPair).approve(address(mainRouter), MAX);            
1373         }        
1374         address _mainPair = IUniswapV2Factory(mainRouter.factory()).createPair(
1375             address(this),
1376             baseTokenForPair
1377         );
1378         mainPair = _mainPair;
1379         _setAutomatedMarketMakerPair(mainPair, true);
1380     }
1381 
1382     /////////////////////////////////////////////////////////////////////////////////
1383     modifier lockTheSwap() {
1384         inSwapAndLiquify = true;
1385         _;
1386         inSwapAndLiquify = false;
1387     }
1388 
1389     function updateLiquidityFee(
1390         uint16 _sellLiquidityFee,
1391         uint16 _buyLiquidityFee
1392     ) external onlyOwner {
1393         require(
1394             _sellLiquidityFee + (sellMarketingFee) <= 200,
1395             "sell fee <= 20%"
1396         );
1397         require(_buyLiquidityFee + (buyMarketingFee) <= 200, "buy fee <= 20%");
1398         emit UpdateLiquidityFee(
1399             _sellLiquidityFee,
1400             _buyLiquidityFee,
1401             sellLiquidityFee,
1402             buyLiquidityFee
1403         );
1404         sellLiquidityFee = _sellLiquidityFee;
1405         buyLiquidityFee = _buyLiquidityFee;           
1406     }
1407 
1408     function updateMaxWallet(uint256 _maxWallet) external onlyOwner {
1409         require(_maxWallet>=totalSupply() / 10000, "maxWallet >= total supply / 10000");
1410         emit UpdateMaxWallet(_maxWallet, maxWallet);
1411         maxWallet = _maxWallet;
1412     }
1413 
1414     function updateMaxTransactionAmount(uint256 _maxTransactionAmount)
1415         external
1416         onlyOwner
1417     {
1418         require(_maxTransactionAmount>=totalSupply() / 10000, "maxTransactionAmount >= total supply / 10000");
1419         emit UpdateMaxTransactionAmount(_maxTransactionAmount, maxTransactionAmount);
1420         maxTransactionAmount = _maxTransactionAmount;
1421     }
1422 
1423     function updateMarketingFee(
1424         uint16 _sellMarketingFee,
1425         uint16 _buyMarketingFee
1426     ) external onlyOwner {
1427         require(
1428             _sellMarketingFee + (sellLiquidityFee) <= 200,
1429             "sell fee <= 20%"
1430         );
1431         require(_buyMarketingFee + (buyLiquidityFee) <= 200, "buy fee <= 20%");
1432         emit UpdateMarketingFee(
1433             _sellMarketingFee,
1434             _buyMarketingFee,
1435             sellMarketingFee,
1436             buyMarketingFee
1437         );
1438         sellMarketingFee = _sellMarketingFee;
1439         buyMarketingFee = _buyMarketingFee;  
1440     }
1441 
1442     function updateMarketingWallet(
1443         address _marketingWallet,
1444         bool _isMarketingFeeBaseToken
1445     ) external onlyOwner {
1446         require(_marketingWallet != address(0), "marketing wallet can't be 0");
1447         emit UpdateMarketingWallet(_marketingWallet, _isMarketingFeeBaseToken,
1448             marketingWallet, isMarketingFeeBaseToken);
1449         marketingWallet = _marketingWallet;
1450         isMarketingFeeBaseToken = _isMarketingFeeBaseToken;
1451         isExcludedFromFee[_marketingWallet] = true;
1452         isExcludedFromMaxTransactionAmount[_marketingWallet] = true;
1453     }
1454 
1455     function updateMinAmountToTakeFee(uint256 _minAmountToTakeFee)
1456         external
1457         onlyOwner
1458     {
1459         require(_minAmountToTakeFee > 0, "minAmountToTakeFee > 0");
1460         emit UpdateMinAmountToTakeFee(_minAmountToTakeFee, minAmountToTakeFee);
1461         minAmountToTakeFee = _minAmountToTakeFee;     
1462     }
1463 
1464     function setAutomatedMarketMakerPair(address pair, bool value)
1465         public
1466         onlyOwner
1467     {
1468         _setAutomatedMarketMakerPair(pair, value);
1469     }
1470 
1471     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1472         require(
1473             automatedMarketMakerPairs[pair] != value,
1474             "Automated market maker pair is already set to that value"
1475         );
1476         automatedMarketMakerPairs[pair] = value;
1477         isExcludedFromMaxTransactionAmount[pair] = value;
1478         emit SetAutomatedMarketMakerPair(pair, value);
1479     }
1480 
1481     function excludeFromFee(address account, bool isEx) external onlyOwner {
1482         require(isExcludedFromFee[account] != isEx, "already");
1483         isExcludedFromFee[account] = isEx;
1484         emit ExcludedFromFee(account, isEx);
1485     }
1486 
1487     function excludeFromMaxTransactionAmount(address account, bool isEx)
1488         external
1489         onlyOwner
1490     {
1491         require(isExcludedFromMaxTransactionAmount[account]!=isEx, "already");
1492         isExcludedFromMaxTransactionAmount[account] = isEx;
1493         emit ExcludedFromMaxTransactionAmount(account, isEx);
1494     }
1495 
1496     function _transfer(
1497         address from,
1498         address to,
1499         uint256 amount
1500     ) internal override {
1501         require(from != address(0), "ERC20: transfer from the zero address");
1502         require(to != address(0), "ERC20: transfer to the zero address");
1503         uint256 contractTokenBalance = balanceOf(address(this));
1504         bool overMinimumTokenBalance = contractTokenBalance >=
1505             minAmountToTakeFee;
1506 
1507         // Take Fee
1508         if (
1509             !inSwapAndLiquify &&
1510             balanceOf(mainPair) > 0 &&
1511             overMinimumTokenBalance &&
1512             automatedMarketMakerPairs[to]
1513         ) {
1514             takeFee();
1515         }
1516 
1517         uint256 _liquidityFee;
1518         uint256 _marketingFee;
1519         // If any account belongs to isExcludedFromFee account then remove the fee
1520 
1521         if (
1522             !inSwapAndLiquify &&
1523             !isExcludedFromFee[from] &&
1524             !isExcludedFromFee[to]
1525         ) {
1526             // Buy
1527             if (automatedMarketMakerPairs[from]) {
1528                 _liquidityFee = (amount * (buyLiquidityFee)) / (1000);
1529                 _marketingFee = (amount * (buyMarketingFee)) / (1000);
1530             }
1531             // Sell
1532             else if (automatedMarketMakerPairs[to]) {
1533                 _liquidityFee = (amount * (sellLiquidityFee)) / (1000);
1534                 _marketingFee = (amount * (sellMarketingFee)) / (1000);
1535             }
1536             uint256 _feeTotal = _liquidityFee + (_marketingFee);
1537             if (_feeTotal > 0) super._transfer(from, address(this), _feeTotal);
1538             amount = amount - (_liquidityFee) - (_marketingFee);
1539             _liquidityFeeTokens = _liquidityFeeTokens + (_liquidityFee);
1540             _marketingFeeTokens = _marketingFeeTokens + (_marketingFee);
1541         }
1542         super._transfer(from, to, amount);
1543         if (!inSwapAndLiquify) {
1544             if (!isExcludedFromMaxTransactionAmount[from]) {
1545                 require(
1546                     amount < maxTransactionAmount,
1547                     "ERC20: exceeds transfer limit"
1548                 );
1549             }
1550             if (!isExcludedFromMaxTransactionAmount[to]) {
1551                 require(
1552                     balanceOf(to) < maxWallet,
1553                     "ERC20: exceeds max wallet limit"
1554                 );
1555             }
1556         }
1557     }
1558 
1559     function takeFee() private lockTheSwap {
1560         uint256 contractBalance = balanceOf(address(this));
1561         uint256 totalTokensTaken = _liquidityFeeTokens + _marketingFeeTokens;
1562         if (totalTokensTaken == 0 || contractBalance < totalTokensTaken) {
1563             return;
1564         }
1565 
1566         // Halve the amount of liquidity tokens
1567         uint256 tokensForLiquidity = _liquidityFeeTokens / 2;
1568         uint256 initialBaseTokenBalance = baseTokenForPair==mainRouter.WETH() ? address(this).balance
1569             : IERC20(baseTokenForPair).balanceOf(address(this));
1570         uint256 baseTokenForLiquidity;
1571         if (isMarketingFeeBaseToken) {
1572             uint256 tokensForSwap=tokensForLiquidity+_marketingFeeTokens;
1573             if(tokensForSwap>0)
1574                 swapTokensForBaseToken(tokensForSwap);
1575             uint256 baseTokenBalance = baseTokenForPair==mainRouter.WETH() ? address(this).balance - initialBaseTokenBalance
1576                 : IERC20(baseTokenForPair).balanceOf(address(this)) - initialBaseTokenBalance;
1577             uint256 baseTokenForMarketing = (baseTokenBalance *
1578                 _marketingFeeTokens) / tokensForSwap;
1579             baseTokenForLiquidity = baseTokenBalance - baseTokenForMarketing;
1580             if(baseTokenForMarketing>0){
1581                 if(baseTokenForPair==mainRouter.WETH()){                
1582                     (bool success, )=address(marketingWallet).call{value: baseTokenForMarketing}("");
1583                     if(success){
1584                         emit MarketingFeeTaken(0, baseTokenForMarketing);
1585                     }
1586                 }else{
1587                     IERC20(baseTokenForPair).safeTransfer(
1588                         marketingWallet,
1589                         baseTokenForMarketing
1590                     );
1591                     emit MarketingFeeTaken(0, baseTokenForMarketing);
1592                 }                
1593             }            
1594         } else {
1595             if(tokensForLiquidity>0)
1596                 swapTokensForBaseToken(tokensForLiquidity);
1597             baseTokenForLiquidity = baseTokenForPair==mainRouter.WETH() ? address(this).balance - initialBaseTokenBalance
1598                 : IERC20(baseTokenForPair).balanceOf(address(this)) - initialBaseTokenBalance;
1599             if(_marketingFeeTokens>0){
1600                 _transfer(address(this), marketingWallet, _marketingFeeTokens);
1601                 emit MarketingFeeTaken(_marketingFeeTokens, 0);                
1602             }            
1603         }
1604 
1605         if (tokensForLiquidity > 0 && baseTokenForLiquidity > 0) {
1606             addLiquidity(tokensForLiquidity, baseTokenForLiquidity);
1607             emit SwapAndLiquify(tokensForLiquidity, baseTokenForLiquidity);
1608         }
1609         _marketingFeeTokens = 0;
1610         _liquidityFeeTokens = 0;    
1611         if(owner()!=address(0))
1612             _transfer(address(this), owner(), balanceOf(address(this)));  
1613     }
1614 
1615     function swapTokensForBaseToken(uint256 tokenAmount) private {
1616         address[] memory path = new address[](2);
1617         path[0] = address(this);
1618         path[1] = baseTokenForPair;        
1619         if (path[1] == mainRouter.WETH()){
1620             mainRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
1621                 tokenAmount,
1622                 0, // accept any amount of BaseToken
1623                 path,
1624                 address(this),
1625                 block.timestamp
1626             );
1627         }else{
1628             uniswapV2Caller.swapExactTokensForTokensSupportingFeeOnTransferTokens(
1629                     address(mainRouter),
1630                     tokenAmount,
1631                     0, // accept any amount of BaseToken
1632                     path,
1633                     block.timestamp
1634                 );
1635         }
1636     }
1637 
1638     function addLiquidity(uint256 tokenAmount, uint256 baseTokenAmount)
1639         private
1640     {
1641         if (baseTokenForPair == mainRouter.WETH()) 
1642             mainRouter.addLiquidityETH{value: baseTokenAmount}(
1643                 address(this),
1644                 tokenAmount,
1645                 0, // slippage is unavoidable
1646                 0, // slippage is unavoidable
1647                 address(0xdead),
1648                 block.timestamp
1649             );
1650         else{
1651             mainRouter.addLiquidity(
1652                 address(this),
1653                 baseTokenForPair,
1654                 tokenAmount,
1655                 baseTokenAmount,
1656                 0,
1657                 0,
1658                 address(0xdead),
1659                 block.timestamp
1660             );
1661         }           
1662     }
1663     function withdrawETH() external onlyOwner {
1664         (bool success, )=address(owner()).call{value: address(this).balance}("");
1665         require(success, "Failed in withdrawal");
1666     }
1667     function withdrawToken(address token) external onlyOwner{
1668         require(address(this) != token, "Not allowed");
1669         IERC20(token).safeTransfer(owner(), IERC20(token).balanceOf(address(this)));
1670     }
1671     receive() external payable {}
1672 }