1 // Sources flattened with hardhat v2.8.0 https://hardhat.org
2 
3 // File @openzeppelin/contracts-upgradeable/token/ERC20/IERC20Upgradeable.sol@v4.5.2
4 
5 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/IERC20.sol)
6 // SPDX-License-Identifier: MIT
7 
8 pragma solidity ^0.8.0;
9 
10 /**
11  * @dev Interface of the ERC20 standard as defined in the EIP.
12  */
13 interface IERC20Upgradeable {
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
25      * @dev Moves `amount` tokens from the caller's account to `to`.
26      *
27      * Returns a boolean value indicating whether the operation succeeded.
28      *
29      * Emits a {Transfer} event.
30      */
31     function transfer(address to, uint256 amount) external returns (bool);
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
59      * @dev Moves `amount` tokens from `from` to `to` using the
60      * allowance mechanism. `amount` is then deducted from the caller's
61      * allowance.
62      *
63      * Returns a boolean value indicating whether the operation succeeded.
64      *
65      * Emits a {Transfer} event.
66      */
67     function transferFrom(
68         address from,
69         address to,
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
88 
89 // File @openzeppelin/contracts-upgradeable/token/ERC20/extensions/IERC20MetadataUpgradeable.sol@v4.5.2
90 
91 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
92 
93 pragma solidity ^0.8.0;
94 
95 /**
96  * @dev Interface for the optional metadata functions from the ERC20 standard.
97  *
98  * _Available since v4.1._
99  */
100 interface IERC20MetadataUpgradeable is IERC20Upgradeable {
101     /**
102      * @dev Returns the name of the token.
103      */
104     function name() external view returns (string memory);
105 
106     /**
107      * @dev Returns the symbol of the token.
108      */
109     function symbol() external view returns (string memory);
110 
111     /**
112      * @dev Returns the decimals places of the token.
113      */
114     function decimals() external view returns (uint8);
115 }
116 
117 
118 // File @openzeppelin/contracts-upgradeable/utils/AddressUpgradeable.sol@v4.5.2
119 
120 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
121 
122 pragma solidity ^0.8.1;
123 
124 /**
125  * @dev Collection of functions related to the address type
126  */
127 library AddressUpgradeable {
128     /**
129      * @dev Returns true if `account` is a contract.
130      *
131      * [IMPORTANT]
132      * ====
133      * It is unsafe to assume that an address for which this function returns
134      * false is an externally-owned account (EOA) and not a contract.
135      *
136      * Among others, `isContract` will return false for the following
137      * types of addresses:
138      *
139      *  - an externally-owned account
140      *  - a contract in construction
141      *  - an address where a contract will be created
142      *  - an address where a contract lived, but was destroyed
143      * ====
144      *
145      * [IMPORTANT]
146      * ====
147      * You shouldn't rely on `isContract` to protect against flash loan attacks!
148      *
149      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
150      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
151      * constructor.
152      * ====
153      */
154     function isContract(address account) internal view returns (bool) {
155         // This method relies on extcodesize/address.code.length, which returns 0
156         // for contracts in construction, since the code is only stored at the end
157         // of the constructor execution.
158 
159         return account.code.length > 0;
160     }
161 
162     /**
163      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
164      * `recipient`, forwarding all available gas and reverting on errors.
165      *
166      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
167      * of certain opcodes, possibly making contracts go over the 2300 gas limit
168      * imposed by `transfer`, making them unable to receive funds via
169      * `transfer`. {sendValue} removes this limitation.
170      *
171      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
172      *
173      * IMPORTANT: because control is transferred to `recipient`, care must be
174      * taken to not create reentrancy vulnerabilities. Consider using
175      * {ReentrancyGuard} or the
176      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
177      */
178     function sendValue(address payable recipient, uint256 amount) internal {
179         require(address(this).balance >= amount, "Address: insufficient balance");
180 
181         (bool success, ) = recipient.call{value: amount}("");
182         require(success, "Address: unable to send value, recipient may have reverted");
183     }
184 
185     /**
186      * @dev Performs a Solidity function call using a low level `call`. A
187      * plain `call` is an unsafe replacement for a function call: use this
188      * function instead.
189      *
190      * If `target` reverts with a revert reason, it is bubbled up by this
191      * function (like regular Solidity function calls).
192      *
193      * Returns the raw returned data. To convert to the expected return value,
194      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
195      *
196      * Requirements:
197      *
198      * - `target` must be a contract.
199      * - calling `target` with `data` must not revert.
200      *
201      * _Available since v3.1._
202      */
203     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
204         return functionCall(target, data, "Address: low-level call failed");
205     }
206 
207     /**
208      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
209      * `errorMessage` as a fallback revert reason when `target` reverts.
210      *
211      * _Available since v3.1._
212      */
213     function functionCall(
214         address target,
215         bytes memory data,
216         string memory errorMessage
217     ) internal returns (bytes memory) {
218         return functionCallWithValue(target, data, 0, errorMessage);
219     }
220 
221     /**
222      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
223      * but also transferring `value` wei to `target`.
224      *
225      * Requirements:
226      *
227      * - the calling contract must have an ETH balance of at least `value`.
228      * - the called Solidity function must be `payable`.
229      *
230      * _Available since v3.1._
231      */
232     function functionCallWithValue(
233         address target,
234         bytes memory data,
235         uint256 value
236     ) internal returns (bytes memory) {
237         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
238     }
239 
240     /**
241      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
242      * with `errorMessage` as a fallback revert reason when `target` reverts.
243      *
244      * _Available since v3.1._
245      */
246     function functionCallWithValue(
247         address target,
248         bytes memory data,
249         uint256 value,
250         string memory errorMessage
251     ) internal returns (bytes memory) {
252         require(address(this).balance >= value, "Address: insufficient balance for call");
253         require(isContract(target), "Address: call to non-contract");
254 
255         (bool success, bytes memory returndata) = target.call{value: value}(data);
256         return verifyCallResult(success, returndata, errorMessage);
257     }
258 
259     /**
260      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
261      * but performing a static call.
262      *
263      * _Available since v3.3._
264      */
265     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
266         return functionStaticCall(target, data, "Address: low-level static call failed");
267     }
268 
269     /**
270      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
271      * but performing a static call.
272      *
273      * _Available since v3.3._
274      */
275     function functionStaticCall(
276         address target,
277         bytes memory data,
278         string memory errorMessage
279     ) internal view returns (bytes memory) {
280         require(isContract(target), "Address: static call to non-contract");
281 
282         (bool success, bytes memory returndata) = target.staticcall(data);
283         return verifyCallResult(success, returndata, errorMessage);
284     }
285 
286     /**
287      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
288      * revert reason using the provided one.
289      *
290      * _Available since v4.3._
291      */
292     function verifyCallResult(
293         bool success,
294         bytes memory returndata,
295         string memory errorMessage
296     ) internal pure returns (bytes memory) {
297         if (success) {
298             return returndata;
299         } else {
300             // Look for revert reason and bubble it up if present
301             if (returndata.length > 0) {
302                 // The easiest way to bubble the revert reason is using memory via assembly
303 
304                 assembly {
305                     let returndata_size := mload(returndata)
306                     revert(add(32, returndata), returndata_size)
307                 }
308             } else {
309                 revert(errorMessage);
310             }
311         }
312     }
313 }
314 
315 
316 // File @openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol@v4.5.2
317 
318 // OpenZeppelin Contracts (last updated v4.5.0) (proxy/utils/Initializable.sol)
319 
320 pragma solidity ^0.8.0;
321 
322 /**
323  * @dev This is a base contract to aid in writing upgradeable contracts, or any kind of contract that will be deployed
324  * behind a proxy. Since proxied contracts do not make use of a constructor, it's common to move constructor logic to an
325  * external initializer function, usually called `initialize`. It then becomes necessary to protect this initializer
326  * function so it can only be called once. The {initializer} modifier provided by this contract will have this effect.
327  *
328  * TIP: To avoid leaving the proxy in an uninitialized state, the initializer function should be called as early as
329  * possible by providing the encoded function call as the `_data` argument to {ERC1967Proxy-constructor}.
330  *
331  * CAUTION: When used with inheritance, manual care must be taken to not invoke a parent initializer twice, or to ensure
332  * that all initializers are idempotent. This is not verified automatically as constructors are by Solidity.
333  *
334  * [CAUTION]
335  * ====
336  * Avoid leaving a contract uninitialized.
337  *
338  * An uninitialized contract can be taken over by an attacker. This applies to both a proxy and its implementation
339  * contract, which may impact the proxy. To initialize the implementation contract, you can either invoke the
340  * initializer manually, or you can include a constructor to automatically mark it as initialized when it is deployed:
341  *
342  * [.hljs-theme-light.nopadding]
343  * ```
344  * /// @custom:oz-upgrades-unsafe-allow constructor
345  * constructor() initializer {}
346  * ```
347  * ====
348  */
349 abstract contract Initializable {
350     /**
351      * @dev Indicates that the contract has been initialized.
352      */
353     bool private _initialized;
354 
355     /**
356      * @dev Indicates that the contract is in the process of being initialized.
357      */
358     bool private _initializing;
359 
360     /**
361      * @dev Modifier to protect an initializer function from being invoked twice.
362      */
363     modifier initializer() {
364         // If the contract is initializing we ignore whether _initialized is set in order to support multiple
365         // inheritance patterns, but we only do this in the context of a constructor, because in other contexts the
366         // contract may have been reentered.
367         require(_initializing ? _isConstructor() : !_initialized, "Initializable: contract is already initialized");
368 
369         bool isTopLevelCall = !_initializing;
370         if (isTopLevelCall) {
371             _initializing = true;
372             _initialized = true;
373         }
374 
375         _;
376 
377         if (isTopLevelCall) {
378             _initializing = false;
379         }
380     }
381 
382     /**
383      * @dev Modifier to protect an initialization function so that it can only be invoked by functions with the
384      * {initializer} modifier, directly or indirectly.
385      */
386     modifier onlyInitializing() {
387         require(_initializing, "Initializable: contract is not initializing");
388         _;
389     }
390 
391     function _isConstructor() private view returns (bool) {
392         return !AddressUpgradeable.isContract(address(this));
393     }
394 }
395 
396 
397 // File @openzeppelin/contracts-upgradeable/utils/ContextUpgradeable.sol@v4.5.2
398 
399 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
400 
401 pragma solidity ^0.8.0;
402 
403 /**
404  * @dev Provides information about the current execution context, including the
405  * sender of the transaction and its data. While these are generally available
406  * via msg.sender and msg.data, they should not be accessed in such a direct
407  * manner, since when dealing with meta-transactions the account sending and
408  * paying for execution may not be the actual sender (as far as an application
409  * is concerned).
410  *
411  * This contract is only required for intermediate, library-like contracts.
412  */
413 abstract contract ContextUpgradeable is Initializable {
414     function __Context_init() internal onlyInitializing {
415     }
416 
417     function __Context_init_unchained() internal onlyInitializing {
418     }
419     function _msgSender() internal view virtual returns (address) {
420         return msg.sender;
421     }
422 
423     function _msgData() internal view virtual returns (bytes calldata) {
424         return msg.data;
425     }
426 
427     /**
428      * @dev This empty reserved space is put in place to allow future versions to add new
429      * variables without shifting down storage in the inheritance chain.
430      * See https://docs.openzeppelin.com/contracts/4.x/upgradeable#storage_gaps
431      */
432     uint256[50] private __gap;
433 }
434 
435 
436 // File @openzeppelin/contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol@v4.5.2
437 
438 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/ERC20.sol)
439 
440 pragma solidity ^0.8.0;
441 
442 
443 
444 
445 /**
446  * @dev Implementation of the {IERC20} interface.
447  *
448  * This implementation is agnostic to the way tokens are created. This means
449  * that a supply mechanism has to be added in a derived contract using {_mint}.
450  * For a generic mechanism see {ERC20PresetMinterPauser}.
451  *
452  * TIP: For a detailed writeup see our guide
453  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
454  * to implement supply mechanisms].
455  *
456  * We have followed general OpenZeppelin Contracts guidelines: functions revert
457  * instead returning `false` on failure. This behavior is nonetheless
458  * conventional and does not conflict with the expectations of ERC20
459  * applications.
460  *
461  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
462  * This allows applications to reconstruct the allowance for all accounts just
463  * by listening to said events. Other implementations of the EIP may not emit
464  * these events, as it isn't required by the specification.
465  *
466  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
467  * functions have been added to mitigate the well-known issues around setting
468  * allowances. See {IERC20-approve}.
469  */
470 contract ERC20Upgradeable is Initializable, ContextUpgradeable, IERC20Upgradeable, IERC20MetadataUpgradeable {
471     mapping(address => uint256) private _balances;
472 
473     mapping(address => mapping(address => uint256)) private _allowances;
474 
475     uint256 private _totalSupply;
476 
477     string private _name;
478     string private _symbol;
479 
480     /**
481      * @dev Sets the values for {name} and {symbol}.
482      *
483      * The default value of {decimals} is 18. To select a different value for
484      * {decimals} you should overload it.
485      *
486      * All two of these values are immutable: they can only be set once during
487      * construction.
488      */
489     function __ERC20_init(string memory name_, string memory symbol_) internal onlyInitializing {
490         __ERC20_init_unchained(name_, symbol_);
491     }
492 
493     function __ERC20_init_unchained(string memory name_, string memory symbol_) internal onlyInitializing {
494         _name = name_;
495         _symbol = symbol_;
496     }
497 
498     /**
499      * @dev Returns the name of the token.
500      */
501     function name() public view virtual override returns (string memory) {
502         return _name;
503     }
504 
505     /**
506      * @dev Returns the symbol of the token, usually a shorter version of the
507      * name.
508      */
509     function symbol() public view virtual override returns (string memory) {
510         return _symbol;
511     }
512 
513     /**
514      * @dev Returns the number of decimals used to get its user representation.
515      * For example, if `decimals` equals `2`, a balance of `505` tokens should
516      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
517      *
518      * Tokens usually opt for a value of 18, imitating the relationship between
519      * Ether and Wei. This is the value {ERC20} uses, unless this function is
520      * overridden;
521      *
522      * NOTE: This information is only used for _display_ purposes: it in
523      * no way affects any of the arithmetic of the contract, including
524      * {IERC20-balanceOf} and {IERC20-transfer}.
525      */
526     function decimals() public view virtual override returns (uint8) {
527         return 18;
528     }
529 
530     /**
531      * @dev See {IERC20-totalSupply}.
532      */
533     function totalSupply() public view virtual override returns (uint256) {
534         return _totalSupply;
535     }
536 
537     /**
538      * @dev See {IERC20-balanceOf}.
539      */
540     function balanceOf(address account) public view virtual override returns (uint256) {
541         return _balances[account];
542     }
543 
544     /**
545      * @dev See {IERC20-transfer}.
546      *
547      * Requirements:
548      *
549      * - `to` cannot be the zero address.
550      * - the caller must have a balance of at least `amount`.
551      */
552     function transfer(address to, uint256 amount) public virtual override returns (bool) {
553         address owner = _msgSender();
554         _transfer(owner, to, amount);
555         return true;
556     }
557 
558     /**
559      * @dev See {IERC20-allowance}.
560      */
561     function allowance(address owner, address spender) public view virtual override returns (uint256) {
562         return _allowances[owner][spender];
563     }
564 
565     /**
566      * @dev See {IERC20-approve}.
567      *
568      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
569      * `transferFrom`. This is semantically equivalent to an infinite approval.
570      *
571      * Requirements:
572      *
573      * - `spender` cannot be the zero address.
574      */
575     function approve(address spender, uint256 amount) public virtual override returns (bool) {
576         address owner = _msgSender();
577         _approve(owner, spender, amount);
578         return true;
579     }
580 
581     /**
582      * @dev See {IERC20-transferFrom}.
583      *
584      * Emits an {Approval} event indicating the updated allowance. This is not
585      * required by the EIP. See the note at the beginning of {ERC20}.
586      *
587      * NOTE: Does not update the allowance if the current allowance
588      * is the maximum `uint256`.
589      *
590      * Requirements:
591      *
592      * - `from` and `to` cannot be the zero address.
593      * - `from` must have a balance of at least `amount`.
594      * - the caller must have allowance for ``from``'s tokens of at least
595      * `amount`.
596      */
597     function transferFrom(
598         address from,
599         address to,
600         uint256 amount
601     ) public virtual override returns (bool) {
602         address spender = _msgSender();
603         _spendAllowance(from, spender, amount);
604         _transfer(from, to, amount);
605         return true;
606     }
607 
608     /**
609      * @dev Atomically increases the allowance granted to `spender` by the caller.
610      *
611      * This is an alternative to {approve} that can be used as a mitigation for
612      * problems described in {IERC20-approve}.
613      *
614      * Emits an {Approval} event indicating the updated allowance.
615      *
616      * Requirements:
617      *
618      * - `spender` cannot be the zero address.
619      */
620     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
621         address owner = _msgSender();
622         _approve(owner, spender, _allowances[owner][spender] + addedValue);
623         return true;
624     }
625 
626     /**
627      * @dev Atomically decreases the allowance granted to `spender` by the caller.
628      *
629      * This is an alternative to {approve} that can be used as a mitigation for
630      * problems described in {IERC20-approve}.
631      *
632      * Emits an {Approval} event indicating the updated allowance.
633      *
634      * Requirements:
635      *
636      * - `spender` cannot be the zero address.
637      * - `spender` must have allowance for the caller of at least
638      * `subtractedValue`.
639      */
640     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
641         address owner = _msgSender();
642         uint256 currentAllowance = _allowances[owner][spender];
643         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
644         unchecked {
645             _approve(owner, spender, currentAllowance - subtractedValue);
646         }
647 
648         return true;
649     }
650 
651     /**
652      * @dev Moves `amount` of tokens from `sender` to `recipient`.
653      *
654      * This internal function is equivalent to {transfer}, and can be used to
655      * e.g. implement automatic token fees, slashing mechanisms, etc.
656      *
657      * Emits a {Transfer} event.
658      *
659      * Requirements:
660      *
661      * - `from` cannot be the zero address.
662      * - `to` cannot be the zero address.
663      * - `from` must have a balance of at least `amount`.
664      */
665     function _transfer(
666         address from,
667         address to,
668         uint256 amount
669     ) internal virtual {
670         require(from != address(0), "ERC20: transfer from the zero address");
671         require(to != address(0), "ERC20: transfer to the zero address");
672 
673         _beforeTokenTransfer(from, to, amount);
674 
675         uint256 fromBalance = _balances[from];
676         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
677         unchecked {
678             _balances[from] = fromBalance - amount;
679         }
680         _balances[to] += amount;
681 
682         emit Transfer(from, to, amount);
683 
684         _afterTokenTransfer(from, to, amount);
685     }
686 
687     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
688      * the total supply.
689      *
690      * Emits a {Transfer} event with `from` set to the zero address.
691      *
692      * Requirements:
693      *
694      * - `account` cannot be the zero address.
695      */
696     function _mint(address account, uint256 amount) internal virtual {
697         require(account != address(0), "ERC20: mint to the zero address");
698 
699         _beforeTokenTransfer(address(0), account, amount);
700 
701         _totalSupply += amount;
702         _balances[account] += amount;
703         emit Transfer(address(0), account, amount);
704 
705         _afterTokenTransfer(address(0), account, amount);
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
726         unchecked {
727             _balances[account] = accountBalance - amount;
728         }
729         _totalSupply -= amount;
730 
731         emit Transfer(account, address(0), amount);
732 
733         _afterTokenTransfer(account, address(0), amount);
734     }
735 
736     /**
737      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
738      *
739      * This internal function is equivalent to `approve`, and can be used to
740      * e.g. set automatic allowances for certain subsystems, etc.
741      *
742      * Emits an {Approval} event.
743      *
744      * Requirements:
745      *
746      * - `owner` cannot be the zero address.
747      * - `spender` cannot be the zero address.
748      */
749     function _approve(
750         address owner,
751         address spender,
752         uint256 amount
753     ) internal virtual {
754         require(owner != address(0), "ERC20: approve from the zero address");
755         require(spender != address(0), "ERC20: approve to the zero address");
756 
757         _allowances[owner][spender] = amount;
758         emit Approval(owner, spender, amount);
759     }
760 
761     /**
762      * @dev Spend `amount` form the allowance of `owner` toward `spender`.
763      *
764      * Does not update the allowance amount in case of infinite allowance.
765      * Revert if not enough allowance is available.
766      *
767      * Might emit an {Approval} event.
768      */
769     function _spendAllowance(
770         address owner,
771         address spender,
772         uint256 amount
773     ) internal virtual {
774         uint256 currentAllowance = allowance(owner, spender);
775         if (currentAllowance != type(uint256).max) {
776             require(currentAllowance >= amount, "ERC20: insufficient allowance");
777             unchecked {
778                 _approve(owner, spender, currentAllowance - amount);
779             }
780         }
781     }
782 
783     /**
784      * @dev Hook that is called before any transfer of tokens. This includes
785      * minting and burning.
786      *
787      * Calling conditions:
788      *
789      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
790      * will be transferred to `to`.
791      * - when `from` is zero, `amount` tokens will be minted for `to`.
792      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
793      * - `from` and `to` are never both zero.
794      *
795      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
796      */
797     function _beforeTokenTransfer(
798         address from,
799         address to,
800         uint256 amount
801     ) internal virtual {}
802 
803     /**
804      * @dev Hook that is called after any transfer of tokens. This includes
805      * minting and burning.
806      *
807      * Calling conditions:
808      *
809      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
810      * has been transferred to `to`.
811      * - when `from` is zero, `amount` tokens have been minted for `to`.
812      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
813      * - `from` and `to` are never both zero.
814      *
815      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
816      */
817     function _afterTokenTransfer(
818         address from,
819         address to,
820         uint256 amount
821     ) internal virtual {}
822 
823     /**
824      * @dev This empty reserved space is put in place to allow future versions to add new
825      * variables without shifting down storage in the inheritance chain.
826      * See https://docs.openzeppelin.com/contracts/4.x/upgradeable#storage_gaps
827      */
828     uint256[45] private __gap;
829 }
830 
831 
832 // File @openzeppelin/contracts-upgradeable/access/IAccessControlUpgradeable.sol@v4.5.2
833 
834 // OpenZeppelin Contracts v4.4.1 (access/IAccessControl.sol)
835 
836 pragma solidity ^0.8.0;
837 
838 /**
839  * @dev External interface of AccessControl declared to support ERC165 detection.
840  */
841 interface IAccessControlUpgradeable {
842     /**
843      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
844      *
845      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
846      * {RoleAdminChanged} not being emitted signaling this.
847      *
848      * _Available since v3.1._
849      */
850     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
851 
852     /**
853      * @dev Emitted when `account` is granted `role`.
854      *
855      * `sender` is the account that originated the contract call, an admin role
856      * bearer except when using {AccessControl-_setupRole}.
857      */
858     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
859 
860     /**
861      * @dev Emitted when `account` is revoked `role`.
862      *
863      * `sender` is the account that originated the contract call:
864      *   - if using `revokeRole`, it is the admin role bearer
865      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
866      */
867     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
868 
869     /**
870      * @dev Returns `true` if `account` has been granted `role`.
871      */
872     function hasRole(bytes32 role, address account) external view returns (bool);
873 
874     /**
875      * @dev Returns the admin role that controls `role`. See {grantRole} and
876      * {revokeRole}.
877      *
878      * To change a role's admin, use {AccessControl-_setRoleAdmin}.
879      */
880     function getRoleAdmin(bytes32 role) external view returns (bytes32);
881 
882     /**
883      * @dev Grants `role` to `account`.
884      *
885      * If `account` had not been already granted `role`, emits a {RoleGranted}
886      * event.
887      *
888      * Requirements:
889      *
890      * - the caller must have ``role``'s admin role.
891      */
892     function grantRole(bytes32 role, address account) external;
893 
894     /**
895      * @dev Revokes `role` from `account`.
896      *
897      * If `account` had been granted `role`, emits a {RoleRevoked} event.
898      *
899      * Requirements:
900      *
901      * - the caller must have ``role``'s admin role.
902      */
903     function revokeRole(bytes32 role, address account) external;
904 
905     /**
906      * @dev Revokes `role` from the calling account.
907      *
908      * Roles are often managed via {grantRole} and {revokeRole}: this function's
909      * purpose is to provide a mechanism for accounts to lose their privileges
910      * if they are compromised (such as when a trusted device is misplaced).
911      *
912      * If the calling account had been granted `role`, emits a {RoleRevoked}
913      * event.
914      *
915      * Requirements:
916      *
917      * - the caller must be `account`.
918      */
919     function renounceRole(bytes32 role, address account) external;
920 }
921 
922 
923 // File @openzeppelin/contracts-upgradeable/utils/StringsUpgradeable.sol@v4.5.2
924 
925 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
926 
927 pragma solidity ^0.8.0;
928 
929 /**
930  * @dev String operations.
931  */
932 library StringsUpgradeable {
933     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
934 
935     /**
936      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
937      */
938     function toString(uint256 value) internal pure returns (string memory) {
939         // Inspired by OraclizeAPI's implementation - MIT licence
940         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
941 
942         if (value == 0) {
943             return "0";
944         }
945         uint256 temp = value;
946         uint256 digits;
947         while (temp != 0) {
948             digits++;
949             temp /= 10;
950         }
951         bytes memory buffer = new bytes(digits);
952         while (value != 0) {
953             digits -= 1;
954             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
955             value /= 10;
956         }
957         return string(buffer);
958     }
959 
960     /**
961      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
962      */
963     function toHexString(uint256 value) internal pure returns (string memory) {
964         if (value == 0) {
965             return "0x00";
966         }
967         uint256 temp = value;
968         uint256 length = 0;
969         while (temp != 0) {
970             length++;
971             temp >>= 8;
972         }
973         return toHexString(value, length);
974     }
975 
976     /**
977      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
978      */
979     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
980         bytes memory buffer = new bytes(2 * length + 2);
981         buffer[0] = "0";
982         buffer[1] = "x";
983         for (uint256 i = 2 * length + 1; i > 1; --i) {
984             buffer[i] = _HEX_SYMBOLS[value & 0xf];
985             value >>= 4;
986         }
987         require(value == 0, "Strings: hex length insufficient");
988         return string(buffer);
989     }
990 }
991 
992 
993 // File @openzeppelin/contracts-upgradeable/utils/introspection/IERC165Upgradeable.sol@v4.5.2
994 
995 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
996 
997 pragma solidity ^0.8.0;
998 
999 /**
1000  * @dev Interface of the ERC165 standard, as defined in the
1001  * https://eips.ethereum.org/EIPS/eip-165[EIP].
1002  *
1003  * Implementers can declare support of contract interfaces, which can then be
1004  * queried by others ({ERC165Checker}).
1005  *
1006  * For an implementation, see {ERC165}.
1007  */
1008 interface IERC165Upgradeable {
1009     /**
1010      * @dev Returns true if this contract implements the interface defined by
1011      * `interfaceId`. See the corresponding
1012      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
1013      * to learn more about how these ids are created.
1014      *
1015      * This function call must use less than 30 000 gas.
1016      */
1017     function supportsInterface(bytes4 interfaceId) external view returns (bool);
1018 }
1019 
1020 
1021 // File @openzeppelin/contracts-upgradeable/utils/introspection/ERC165Upgradeable.sol@v4.5.2
1022 
1023 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
1024 
1025 pragma solidity ^0.8.0;
1026 
1027 
1028 /**
1029  * @dev Implementation of the {IERC165} interface.
1030  *
1031  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
1032  * for the additional interface id that will be supported. For example:
1033  *
1034  * ```solidity
1035  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1036  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
1037  * }
1038  * ```
1039  *
1040  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
1041  */
1042 abstract contract ERC165Upgradeable is Initializable, IERC165Upgradeable {
1043     function __ERC165_init() internal onlyInitializing {
1044     }
1045 
1046     function __ERC165_init_unchained() internal onlyInitializing {
1047     }
1048     /**
1049      * @dev See {IERC165-supportsInterface}.
1050      */
1051     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1052         return interfaceId == type(IERC165Upgradeable).interfaceId;
1053     }
1054 
1055     /**
1056      * @dev This empty reserved space is put in place to allow future versions to add new
1057      * variables without shifting down storage in the inheritance chain.
1058      * See https://docs.openzeppelin.com/contracts/4.x/upgradeable#storage_gaps
1059      */
1060     uint256[50] private __gap;
1061 }
1062 
1063 
1064 // File @openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol@v4.5.2
1065 
1066 // OpenZeppelin Contracts (last updated v4.5.0) (access/AccessControl.sol)
1067 
1068 pragma solidity ^0.8.0;
1069 
1070 
1071 
1072 
1073 
1074 /**
1075  * @dev Contract module that allows children to implement role-based access
1076  * control mechanisms. This is a lightweight version that doesn't allow enumerating role
1077  * members except through off-chain means by accessing the contract event logs. Some
1078  * applications may benefit from on-chain enumerability, for those cases see
1079  * {AccessControlEnumerable}.
1080  *
1081  * Roles are referred to by their `bytes32` identifier. These should be exposed
1082  * in the external API and be unique. The best way to achieve this is by
1083  * using `public constant` hash digests:
1084  *
1085  * ```
1086  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
1087  * ```
1088  *
1089  * Roles can be used to represent a set of permissions. To restrict access to a
1090  * function call, use {hasRole}:
1091  *
1092  * ```
1093  * function foo() public {
1094  *     require(hasRole(MY_ROLE, msg.sender));
1095  *     ...
1096  * }
1097  * ```
1098  *
1099  * Roles can be granted and revoked dynamically via the {grantRole} and
1100  * {revokeRole} functions. Each role has an associated admin role, and only
1101  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
1102  *
1103  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
1104  * that only accounts with this role will be able to grant or revoke other
1105  * roles. More complex role relationships can be created by using
1106  * {_setRoleAdmin}.
1107  *
1108  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
1109  * grant and revoke this role. Extra precautions should be taken to secure
1110  * accounts that have been granted it.
1111  */
1112 abstract contract AccessControlUpgradeable is Initializable, ContextUpgradeable, IAccessControlUpgradeable, ERC165Upgradeable {
1113     function __AccessControl_init() internal onlyInitializing {
1114     }
1115 
1116     function __AccessControl_init_unchained() internal onlyInitializing {
1117     }
1118     struct RoleData {
1119         mapping(address => bool) members;
1120         bytes32 adminRole;
1121     }
1122 
1123     mapping(bytes32 => RoleData) private _roles;
1124 
1125     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
1126 
1127     /**
1128      * @dev Modifier that checks that an account has a specific role. Reverts
1129      * with a standardized message including the required role.
1130      *
1131      * The format of the revert reason is given by the following regular expression:
1132      *
1133      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
1134      *
1135      * _Available since v4.1._
1136      */
1137     modifier onlyRole(bytes32 role) {
1138         _checkRole(role, _msgSender());
1139         _;
1140     }
1141 
1142     /**
1143      * @dev See {IERC165-supportsInterface}.
1144      */
1145     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1146         return interfaceId == type(IAccessControlUpgradeable).interfaceId || super.supportsInterface(interfaceId);
1147     }
1148 
1149     /**
1150      * @dev Returns `true` if `account` has been granted `role`.
1151      */
1152     function hasRole(bytes32 role, address account) public view virtual override returns (bool) {
1153         return _roles[role].members[account];
1154     }
1155 
1156     /**
1157      * @dev Revert with a standard message if `account` is missing `role`.
1158      *
1159      * The format of the revert reason is given by the following regular expression:
1160      *
1161      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
1162      */
1163     function _checkRole(bytes32 role, address account) internal view virtual {
1164         if (!hasRole(role, account)) {
1165             revert(
1166                 string(
1167                     abi.encodePacked(
1168                         "AccessControl: account ",
1169                         StringsUpgradeable.toHexString(uint160(account), 20),
1170                         " is missing role ",
1171                         StringsUpgradeable.toHexString(uint256(role), 32)
1172                     )
1173                 )
1174             );
1175         }
1176     }
1177 
1178     /**
1179      * @dev Returns the admin role that controls `role`. See {grantRole} and
1180      * {revokeRole}.
1181      *
1182      * To change a role's admin, use {_setRoleAdmin}.
1183      */
1184     function getRoleAdmin(bytes32 role) public view virtual override returns (bytes32) {
1185         return _roles[role].adminRole;
1186     }
1187 
1188     /**
1189      * @dev Grants `role` to `account`.
1190      *
1191      * If `account` had not been already granted `role`, emits a {RoleGranted}
1192      * event.
1193      *
1194      * Requirements:
1195      *
1196      * - the caller must have ``role``'s admin role.
1197      */
1198     function grantRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
1199         _grantRole(role, account);
1200     }
1201 
1202     /**
1203      * @dev Revokes `role` from `account`.
1204      *
1205      * If `account` had been granted `role`, emits a {RoleRevoked} event.
1206      *
1207      * Requirements:
1208      *
1209      * - the caller must have ``role``'s admin role.
1210      */
1211     function revokeRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
1212         _revokeRole(role, account);
1213     }
1214 
1215     /**
1216      * @dev Revokes `role` from the calling account.
1217      *
1218      * Roles are often managed via {grantRole} and {revokeRole}: this function's
1219      * purpose is to provide a mechanism for accounts to lose their privileges
1220      * if they are compromised (such as when a trusted device is misplaced).
1221      *
1222      * If the calling account had been revoked `role`, emits a {RoleRevoked}
1223      * event.
1224      *
1225      * Requirements:
1226      *
1227      * - the caller must be `account`.
1228      */
1229     function renounceRole(bytes32 role, address account) public virtual override {
1230         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
1231 
1232         _revokeRole(role, account);
1233     }
1234 
1235     /**
1236      * @dev Grants `role` to `account`.
1237      *
1238      * If `account` had not been already granted `role`, emits a {RoleGranted}
1239      * event. Note that unlike {grantRole}, this function doesn't perform any
1240      * checks on the calling account.
1241      *
1242      * [WARNING]
1243      * ====
1244      * This function should only be called from the constructor when setting
1245      * up the initial roles for the system.
1246      *
1247      * Using this function in any other way is effectively circumventing the admin
1248      * system imposed by {AccessControl}.
1249      * ====
1250      *
1251      * NOTE: This function is deprecated in favor of {_grantRole}.
1252      */
1253     function _setupRole(bytes32 role, address account) internal virtual {
1254         _grantRole(role, account);
1255     }
1256 
1257     /**
1258      * @dev Sets `adminRole` as ``role``'s admin role.
1259      *
1260      * Emits a {RoleAdminChanged} event.
1261      */
1262     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
1263         bytes32 previousAdminRole = getRoleAdmin(role);
1264         _roles[role].adminRole = adminRole;
1265         emit RoleAdminChanged(role, previousAdminRole, adminRole);
1266     }
1267 
1268     /**
1269      * @dev Grants `role` to `account`.
1270      *
1271      * Internal function without access restriction.
1272      */
1273     function _grantRole(bytes32 role, address account) internal virtual {
1274         if (!hasRole(role, account)) {
1275             _roles[role].members[account] = true;
1276             emit RoleGranted(role, account, _msgSender());
1277         }
1278     }
1279 
1280     /**
1281      * @dev Revokes `role` from `account`.
1282      *
1283      * Internal function without access restriction.
1284      */
1285     function _revokeRole(bytes32 role, address account) internal virtual {
1286         if (hasRole(role, account)) {
1287             _roles[role].members[account] = false;
1288             emit RoleRevoked(role, account, _msgSender());
1289         }
1290     }
1291 
1292     /**
1293      * @dev This empty reserved space is put in place to allow future versions to add new
1294      * variables without shifting down storage in the inheritance chain.
1295      * See https://docs.openzeppelin.com/contracts/4.x/upgradeable#storage_gaps
1296      */
1297     uint256[49] private __gap;
1298 }
1299 
1300 
1301 // File @openzeppelin/contracts-upgradeable/security/PausableUpgradeable.sol@v4.5.2
1302 
1303 // OpenZeppelin Contracts v4.4.1 (security/Pausable.sol)
1304 
1305 pragma solidity ^0.8.0;
1306 
1307 
1308 /**
1309  * @dev Contract module which allows children to implement an emergency stop
1310  * mechanism that can be triggered by an authorized account.
1311  *
1312  * This module is used through inheritance. It will make available the
1313  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
1314  * the functions of your contract. Note that they will not be pausable by
1315  * simply including this module, only once the modifiers are put in place.
1316  */
1317 abstract contract PausableUpgradeable is Initializable, ContextUpgradeable {
1318     /**
1319      * @dev Emitted when the pause is triggered by `account`.
1320      */
1321     event Paused(address account);
1322 
1323     /**
1324      * @dev Emitted when the pause is lifted by `account`.
1325      */
1326     event Unpaused(address account);
1327 
1328     bool private _paused;
1329 
1330     /**
1331      * @dev Initializes the contract in unpaused state.
1332      */
1333     function __Pausable_init() internal onlyInitializing {
1334         __Pausable_init_unchained();
1335     }
1336 
1337     function __Pausable_init_unchained() internal onlyInitializing {
1338         _paused = false;
1339     }
1340 
1341     /**
1342      * @dev Returns true if the contract is paused, and false otherwise.
1343      */
1344     function paused() public view virtual returns (bool) {
1345         return _paused;
1346     }
1347 
1348     /**
1349      * @dev Modifier to make a function callable only when the contract is not paused.
1350      *
1351      * Requirements:
1352      *
1353      * - The contract must not be paused.
1354      */
1355     modifier whenNotPaused() {
1356         require(!paused(), "Pausable: paused");
1357         _;
1358     }
1359 
1360     /**
1361      * @dev Modifier to make a function callable only when the contract is paused.
1362      *
1363      * Requirements:
1364      *
1365      * - The contract must be paused.
1366      */
1367     modifier whenPaused() {
1368         require(paused(), "Pausable: not paused");
1369         _;
1370     }
1371 
1372     /**
1373      * @dev Triggers stopped state.
1374      *
1375      * Requirements:
1376      *
1377      * - The contract must not be paused.
1378      */
1379     function _pause() internal virtual whenNotPaused {
1380         _paused = true;
1381         emit Paused(_msgSender());
1382     }
1383 
1384     /**
1385      * @dev Returns to normal state.
1386      *
1387      * Requirements:
1388      *
1389      * - The contract must be paused.
1390      */
1391     function _unpause() internal virtual whenPaused {
1392         _paused = false;
1393         emit Unpaused(_msgSender());
1394     }
1395 
1396     /**
1397      * @dev This empty reserved space is put in place to allow future versions to add new
1398      * variables without shifting down storage in the inheritance chain.
1399      * See https://docs.openzeppelin.com/contracts/4.x/upgradeable#storage_gaps
1400      */
1401     uint256[49] private __gap;
1402 }
1403 
1404 
1405 // File @openzeppelin/contracts-upgradeable/token/ERC20/extensions/draft-IERC20PermitUpgradeable.sol@v4.5.2
1406 
1407 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/draft-IERC20Permit.sol)
1408 
1409 pragma solidity ^0.8.0;
1410 
1411 /**
1412  * @dev Interface of the ERC20 Permit extension allowing approvals to be made via signatures, as defined in
1413  * https://eips.ethereum.org/EIPS/eip-2612[EIP-2612].
1414  *
1415  * Adds the {permit} method, which can be used to change an account's ERC20 allowance (see {IERC20-allowance}) by
1416  * presenting a message signed by the account. By not relying on {IERC20-approve}, the token holder account doesn't
1417  * need to send a transaction, and thus is not required to hold Ether at all.
1418  */
1419 interface IERC20PermitUpgradeable {
1420     /**
1421      * @dev Sets `value` as the allowance of `spender` over ``owner``'s tokens,
1422      * given ``owner``'s signed approval.
1423      *
1424      * IMPORTANT: The same issues {IERC20-approve} has related to transaction
1425      * ordering also apply here.
1426      *
1427      * Emits an {Approval} event.
1428      *
1429      * Requirements:
1430      *
1431      * - `spender` cannot be the zero address.
1432      * - `deadline` must be a timestamp in the future.
1433      * - `v`, `r` and `s` must be a valid `secp256k1` signature from `owner`
1434      * over the EIP712-formatted function arguments.
1435      * - the signature must use ``owner``'s current nonce (see {nonces}).
1436      *
1437      * For more information on the signature format, see the
1438      * https://eips.ethereum.org/EIPS/eip-2612#specification[relevant EIP
1439      * section].
1440      */
1441     function permit(
1442         address owner,
1443         address spender,
1444         uint256 value,
1445         uint256 deadline,
1446         uint8 v,
1447         bytes32 r,
1448         bytes32 s
1449     ) external;
1450 
1451     /**
1452      * @dev Returns the current nonce for `owner`. This value must be
1453      * included whenever a signature is generated for {permit}.
1454      *
1455      * Every successful call to {permit} increases ``owner``'s nonce by one. This
1456      * prevents a signature from being used multiple times.
1457      */
1458     function nonces(address owner) external view returns (uint256);
1459 
1460     /**
1461      * @dev Returns the domain separator used in the encoding of the signature for {permit}, as defined by {EIP712}.
1462      */
1463     // solhint-disable-next-line func-name-mixedcase
1464     function DOMAIN_SEPARATOR() external view returns (bytes32);
1465 }
1466 
1467 
1468 // File @openzeppelin/contracts-upgradeable/utils/cryptography/ECDSAUpgradeable.sol@v4.5.2
1469 
1470 // OpenZeppelin Contracts (last updated v4.5.0) (utils/cryptography/ECDSA.sol)
1471 
1472 pragma solidity ^0.8.0;
1473 
1474 /**
1475  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
1476  *
1477  * These functions can be used to verify that a message was signed by the holder
1478  * of the private keys of a given address.
1479  */
1480 library ECDSAUpgradeable {
1481     enum RecoverError {
1482         NoError,
1483         InvalidSignature,
1484         InvalidSignatureLength,
1485         InvalidSignatureS,
1486         InvalidSignatureV
1487     }
1488 
1489     function _throwError(RecoverError error) private pure {
1490         if (error == RecoverError.NoError) {
1491             return; // no error: do nothing
1492         } else if (error == RecoverError.InvalidSignature) {
1493             revert("ECDSA: invalid signature");
1494         } else if (error == RecoverError.InvalidSignatureLength) {
1495             revert("ECDSA: invalid signature length");
1496         } else if (error == RecoverError.InvalidSignatureS) {
1497             revert("ECDSA: invalid signature 's' value");
1498         } else if (error == RecoverError.InvalidSignatureV) {
1499             revert("ECDSA: invalid signature 'v' value");
1500         }
1501     }
1502 
1503     /**
1504      * @dev Returns the address that signed a hashed message (`hash`) with
1505      * `signature` or error string. This address can then be used for verification purposes.
1506      *
1507      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
1508      * this function rejects them by requiring the `s` value to be in the lower
1509      * half order, and the `v` value to be either 27 or 28.
1510      *
1511      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
1512      * verification to be secure: it is possible to craft signatures that
1513      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
1514      * this is by receiving a hash of the original message (which may otherwise
1515      * be too long), and then calling {toEthSignedMessageHash} on it.
1516      *
1517      * Documentation for signature generation:
1518      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
1519      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
1520      *
1521      * _Available since v4.3._
1522      */
1523     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
1524         // Check the signature length
1525         // - case 65: r,s,v signature (standard)
1526         // - case 64: r,vs signature (cf https://eips.ethereum.org/EIPS/eip-2098) _Available since v4.1._
1527         if (signature.length == 65) {
1528             bytes32 r;
1529             bytes32 s;
1530             uint8 v;
1531             // ecrecover takes the signature parameters, and the only way to get them
1532             // currently is to use assembly.
1533             assembly {
1534                 r := mload(add(signature, 0x20))
1535                 s := mload(add(signature, 0x40))
1536                 v := byte(0, mload(add(signature, 0x60)))
1537             }
1538             return tryRecover(hash, v, r, s);
1539         } else if (signature.length == 64) {
1540             bytes32 r;
1541             bytes32 vs;
1542             // ecrecover takes the signature parameters, and the only way to get them
1543             // currently is to use assembly.
1544             assembly {
1545                 r := mload(add(signature, 0x20))
1546                 vs := mload(add(signature, 0x40))
1547             }
1548             return tryRecover(hash, r, vs);
1549         } else {
1550             return (address(0), RecoverError.InvalidSignatureLength);
1551         }
1552     }
1553 
1554     /**
1555      * @dev Returns the address that signed a hashed message (`hash`) with
1556      * `signature`. This address can then be used for verification purposes.
1557      *
1558      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
1559      * this function rejects them by requiring the `s` value to be in the lower
1560      * half order, and the `v` value to be either 27 or 28.
1561      *
1562      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
1563      * verification to be secure: it is possible to craft signatures that
1564      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
1565      * this is by receiving a hash of the original message (which may otherwise
1566      * be too long), and then calling {toEthSignedMessageHash} on it.
1567      */
1568     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
1569         (address recovered, RecoverError error) = tryRecover(hash, signature);
1570         _throwError(error);
1571         return recovered;
1572     }
1573 
1574     /**
1575      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
1576      *
1577      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
1578      *
1579      * _Available since v4.3._
1580      */
1581     function tryRecover(
1582         bytes32 hash,
1583         bytes32 r,
1584         bytes32 vs
1585     ) internal pure returns (address, RecoverError) {
1586         bytes32 s = vs & bytes32(0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff);
1587         uint8 v = uint8((uint256(vs) >> 255) + 27);
1588         return tryRecover(hash, v, r, s);
1589     }
1590 
1591     /**
1592      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
1593      *
1594      * _Available since v4.2._
1595      */
1596     function recover(
1597         bytes32 hash,
1598         bytes32 r,
1599         bytes32 vs
1600     ) internal pure returns (address) {
1601         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
1602         _throwError(error);
1603         return recovered;
1604     }
1605 
1606     /**
1607      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
1608      * `r` and `s` signature fields separately.
1609      *
1610      * _Available since v4.3._
1611      */
1612     function tryRecover(
1613         bytes32 hash,
1614         uint8 v,
1615         bytes32 r,
1616         bytes32 s
1617     ) internal pure returns (address, RecoverError) {
1618         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
1619         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
1620         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
1621         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
1622         //
1623         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
1624         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
1625         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
1626         // these malleable signatures as well.
1627         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
1628             return (address(0), RecoverError.InvalidSignatureS);
1629         }
1630         if (v != 27 && v != 28) {
1631             return (address(0), RecoverError.InvalidSignatureV);
1632         }
1633 
1634         // If the signature is valid (and not malleable), return the signer address
1635         address signer = ecrecover(hash, v, r, s);
1636         if (signer == address(0)) {
1637             return (address(0), RecoverError.InvalidSignature);
1638         }
1639 
1640         return (signer, RecoverError.NoError);
1641     }
1642 
1643     /**
1644      * @dev Overload of {ECDSA-recover} that receives the `v`,
1645      * `r` and `s` signature fields separately.
1646      */
1647     function recover(
1648         bytes32 hash,
1649         uint8 v,
1650         bytes32 r,
1651         bytes32 s
1652     ) internal pure returns (address) {
1653         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
1654         _throwError(error);
1655         return recovered;
1656     }
1657 
1658     /**
1659      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
1660      * produces hash corresponding to the one signed with the
1661      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
1662      * JSON-RPC method as part of EIP-191.
1663      *
1664      * See {recover}.
1665      */
1666     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
1667         // 32 is the length in bytes of hash,
1668         // enforced by the type signature above
1669         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
1670     }
1671 
1672     /**
1673      * @dev Returns an Ethereum Signed Message, created from `s`. This
1674      * produces hash corresponding to the one signed with the
1675      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
1676      * JSON-RPC method as part of EIP-191.
1677      *
1678      * See {recover}.
1679      */
1680     function toEthSignedMessageHash(bytes memory s) internal pure returns (bytes32) {
1681         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n", StringsUpgradeable.toString(s.length), s));
1682     }
1683 
1684     /**
1685      * @dev Returns an Ethereum Signed Typed Data, created from a
1686      * `domainSeparator` and a `structHash`. This produces hash corresponding
1687      * to the one signed with the
1688      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
1689      * JSON-RPC method as part of EIP-712.
1690      *
1691      * See {recover}.
1692      */
1693     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
1694         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
1695     }
1696 }
1697 
1698 
1699 // File @openzeppelin/contracts-upgradeable/utils/cryptography/draft-EIP712Upgradeable.sol@v4.5.2
1700 
1701 // OpenZeppelin Contracts v4.4.1 (utils/cryptography/draft-EIP712.sol)
1702 
1703 pragma solidity ^0.8.0;
1704 
1705 
1706 /**
1707  * @dev https://eips.ethereum.org/EIPS/eip-712[EIP 712] is a standard for hashing and signing of typed structured data.
1708  *
1709  * The encoding specified in the EIP is very generic, and such a generic implementation in Solidity is not feasible,
1710  * thus this contract does not implement the encoding itself. Protocols need to implement the type-specific encoding
1711  * they need in their contracts using a combination of `abi.encode` and `keccak256`.
1712  *
1713  * This contract implements the EIP 712 domain separator ({_domainSeparatorV4}) that is used as part of the encoding
1714  * scheme, and the final step of the encoding to obtain the message digest that is then signed via ECDSA
1715  * ({_hashTypedDataV4}).
1716  *
1717  * The implementation of the domain separator was designed to be as efficient as possible while still properly updating
1718  * the chain id to protect against replay attacks on an eventual fork of the chain.
1719  *
1720  * NOTE: This contract implements the version of the encoding known as "v4", as implemented by the JSON RPC method
1721  * https://docs.metamask.io/guide/signing-data.html[`eth_signTypedDataV4` in MetaMask].
1722  *
1723  * _Available since v3.4._
1724  */
1725 abstract contract EIP712Upgradeable is Initializable {
1726     /* solhint-disable var-name-mixedcase */
1727     bytes32 private _HASHED_NAME;
1728     bytes32 private _HASHED_VERSION;
1729     bytes32 private constant _TYPE_HASH = keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)");
1730 
1731     /* solhint-enable var-name-mixedcase */
1732 
1733     /**
1734      * @dev Initializes the domain separator and parameter caches.
1735      *
1736      * The meaning of `name` and `version` is specified in
1737      * https://eips.ethereum.org/EIPS/eip-712#definition-of-domainseparator[EIP 712]:
1738      *
1739      * - `name`: the user readable name of the signing domain, i.e. the name of the DApp or the protocol.
1740      * - `version`: the current major version of the signing domain.
1741      *
1742      * NOTE: These parameters cannot be changed except through a xref:learn::upgrading-smart-contracts.adoc[smart
1743      * contract upgrade].
1744      */
1745     function __EIP712_init(string memory name, string memory version) internal onlyInitializing {
1746         __EIP712_init_unchained(name, version);
1747     }
1748 
1749     function __EIP712_init_unchained(string memory name, string memory version) internal onlyInitializing {
1750         bytes32 hashedName = keccak256(bytes(name));
1751         bytes32 hashedVersion = keccak256(bytes(version));
1752         _HASHED_NAME = hashedName;
1753         _HASHED_VERSION = hashedVersion;
1754     }
1755 
1756     /**
1757      * @dev Returns the domain separator for the current chain.
1758      */
1759     function _domainSeparatorV4() internal view returns (bytes32) {
1760         return _buildDomainSeparator(_TYPE_HASH, _EIP712NameHash(), _EIP712VersionHash());
1761     }
1762 
1763     function _buildDomainSeparator(
1764         bytes32 typeHash,
1765         bytes32 nameHash,
1766         bytes32 versionHash
1767     ) private view returns (bytes32) {
1768         return keccak256(abi.encode(typeHash, nameHash, versionHash, block.chainid, address(this)));
1769     }
1770 
1771     /**
1772      * @dev Given an already https://eips.ethereum.org/EIPS/eip-712#definition-of-hashstruct[hashed struct], this
1773      * function returns the hash of the fully encoded EIP712 message for this domain.
1774      *
1775      * This hash can be used together with {ECDSA-recover} to obtain the signer of a message. For example:
1776      *
1777      * ```solidity
1778      * bytes32 digest = _hashTypedDataV4(keccak256(abi.encode(
1779      *     keccak256("Mail(address to,string contents)"),
1780      *     mailTo,
1781      *     keccak256(bytes(mailContents))
1782      * )));
1783      * address signer = ECDSA.recover(digest, signature);
1784      * ```
1785      */
1786     function _hashTypedDataV4(bytes32 structHash) internal view virtual returns (bytes32) {
1787         return ECDSAUpgradeable.toTypedDataHash(_domainSeparatorV4(), structHash);
1788     }
1789 
1790     /**
1791      * @dev The hash of the name parameter for the EIP712 domain.
1792      *
1793      * NOTE: This function reads from storage by default, but can be redefined to return a constant value if gas costs
1794      * are a concern.
1795      */
1796     function _EIP712NameHash() internal virtual view returns (bytes32) {
1797         return _HASHED_NAME;
1798     }
1799 
1800     /**
1801      * @dev The hash of the version parameter for the EIP712 domain.
1802      *
1803      * NOTE: This function reads from storage by default, but can be redefined to return a constant value if gas costs
1804      * are a concern.
1805      */
1806     function _EIP712VersionHash() internal virtual view returns (bytes32) {
1807         return _HASHED_VERSION;
1808     }
1809 
1810     /**
1811      * @dev This empty reserved space is put in place to allow future versions to add new
1812      * variables without shifting down storage in the inheritance chain.
1813      * See https://docs.openzeppelin.com/contracts/4.x/upgradeable#storage_gaps
1814      */
1815     uint256[50] private __gap;
1816 }
1817 
1818 
1819 // File @openzeppelin/contracts-upgradeable/utils/CountersUpgradeable.sol@v4.5.2
1820 
1821 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
1822 
1823 pragma solidity ^0.8.0;
1824 
1825 /**
1826  * @title Counters
1827  * @author Matt Condon (@shrugs)
1828  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
1829  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
1830  *
1831  * Include with `using Counters for Counters.Counter;`
1832  */
1833 library CountersUpgradeable {
1834     struct Counter {
1835         // This variable should never be directly accessed by users of the library: interactions must be restricted to
1836         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
1837         // this feature: see https://github.com/ethereum/solidity/issues/4637
1838         uint256 _value; // default: 0
1839     }
1840 
1841     function current(Counter storage counter) internal view returns (uint256) {
1842         return counter._value;
1843     }
1844 
1845     function increment(Counter storage counter) internal {
1846         unchecked {
1847             counter._value += 1;
1848         }
1849     }
1850 
1851     function decrement(Counter storage counter) internal {
1852         uint256 value = counter._value;
1853         require(value > 0, "Counter: decrement overflow");
1854         unchecked {
1855             counter._value = value - 1;
1856         }
1857     }
1858 
1859     function reset(Counter storage counter) internal {
1860         counter._value = 0;
1861     }
1862 }
1863 
1864 
1865 // File @openzeppelin/contracts-upgradeable/token/ERC20/extensions/draft-ERC20PermitUpgradeable.sol@v4.5.2
1866 
1867 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/draft-ERC20Permit.sol)
1868 
1869 pragma solidity ^0.8.0;
1870 
1871 
1872 
1873 
1874 
1875 
1876 /**
1877  * @dev Implementation of the ERC20 Permit extension allowing approvals to be made via signatures, as defined in
1878  * https://eips.ethereum.org/EIPS/eip-2612[EIP-2612].
1879  *
1880  * Adds the {permit} method, which can be used to change an account's ERC20 allowance (see {IERC20-allowance}) by
1881  * presenting a message signed by the account. By not relying on `{IERC20-approve}`, the token holder account doesn't
1882  * need to send a transaction, and thus is not required to hold Ether at all.
1883  *
1884  * _Available since v3.4._
1885  */
1886 abstract contract ERC20PermitUpgradeable is Initializable, ERC20Upgradeable, IERC20PermitUpgradeable, EIP712Upgradeable {
1887     using CountersUpgradeable for CountersUpgradeable.Counter;
1888 
1889     mapping(address => CountersUpgradeable.Counter) private _nonces;
1890 
1891     // solhint-disable-next-line var-name-mixedcase
1892     bytes32 private _PERMIT_TYPEHASH;
1893 
1894     /**
1895      * @dev Initializes the {EIP712} domain separator using the `name` parameter, and setting `version` to `"1"`.
1896      *
1897      * It's a good idea to use the same `name` that is defined as the ERC20 token name.
1898      */
1899     function __ERC20Permit_init(string memory name) internal onlyInitializing {
1900         __EIP712_init_unchained(name, "1");
1901         __ERC20Permit_init_unchained(name);
1902     }
1903 
1904     function __ERC20Permit_init_unchained(string memory) internal onlyInitializing {
1905         _PERMIT_TYPEHASH = keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");}
1906 
1907     /**
1908      * @dev See {IERC20Permit-permit}.
1909      */
1910     function permit(
1911         address owner,
1912         address spender,
1913         uint256 value,
1914         uint256 deadline,
1915         uint8 v,
1916         bytes32 r,
1917         bytes32 s
1918     ) public virtual override {
1919         require(block.timestamp <= deadline, "ERC20Permit: expired deadline");
1920 
1921         bytes32 structHash = keccak256(abi.encode(_PERMIT_TYPEHASH, owner, spender, value, _useNonce(owner), deadline));
1922 
1923         bytes32 hash = _hashTypedDataV4(structHash);
1924 
1925         address signer = ECDSAUpgradeable.recover(hash, v, r, s);
1926         require(signer == owner, "ERC20Permit: invalid signature");
1927 
1928         _approve(owner, spender, value);
1929     }
1930 
1931     /**
1932      * @dev See {IERC20Permit-nonces}.
1933      */
1934     function nonces(address owner) public view virtual override returns (uint256) {
1935         return _nonces[owner].current();
1936     }
1937 
1938     /**
1939      * @dev See {IERC20Permit-DOMAIN_SEPARATOR}.
1940      */
1941     // solhint-disable-next-line func-name-mixedcase
1942     function DOMAIN_SEPARATOR() external view override returns (bytes32) {
1943         return _domainSeparatorV4();
1944     }
1945 
1946     /**
1947      * @dev "Consume a nonce": return the current value and increment.
1948      *
1949      * _Available since v4.1._
1950      */
1951     function _useNonce(address owner) internal virtual returns (uint256 current) {
1952         CountersUpgradeable.Counter storage nonce = _nonces[owner];
1953         current = nonce.current();
1954         nonce.increment();
1955     }
1956 
1957     /**
1958      * @dev This empty reserved space is put in place to allow future versions to add new
1959      * variables without shifting down storage in the inheritance chain.
1960      * See https://docs.openzeppelin.com/contracts/4.x/upgradeable#storage_gaps
1961      */
1962     uint256[49] private __gap;
1963 }
1964 
1965 
1966 // File contracts/interfaces/IDIAMOND.sol
1967 
1968 
1969 pragma solidity ^0.8.0;
1970 
1971 interface IDIAMOND {
1972     function mint(address to, uint256 amount) external;
1973     function burn(address from, uint256 amount) external;
1974 }
1975 
1976 
1977 // File contracts/DIAMOND.sol
1978 
1979 pragma solidity ^0.8.4;
1980 
1981 
1982 
1983 
1984 
1985 
1986 contract DIAMOND is Initializable, ERC20Upgradeable, AccessControlUpgradeable, PausableUpgradeable, ERC20PermitUpgradeable, IDIAMOND {
1987     bytes32 public constant PAUSER_ROLE = keccak256("PAUSER_ROLE");
1988     bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
1989     bytes32 public constant BURNER_ROLE = keccak256("BURNER_ROLE");
1990 
1991     /// @custom:oz-upgrades-unsafe-allow constructor
1992     constructor() initializer {}
1993 
1994     function initialize() initializer public {
1995         __ERC20_init("DIAMOND", "DIAMOND");
1996         __AccessControl_init();
1997         __Pausable_init();
1998         __ERC20Permit_init("DIAMOND");
1999 
2000         _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
2001         _grantRole(PAUSER_ROLE, msg.sender);
2002         _grantRole(MINTER_ROLE, msg.sender);
2003         _grantRole(BURNER_ROLE, msg.sender);
2004     }
2005 
2006     function pause() public onlyRole(PAUSER_ROLE) {
2007         _pause();
2008     }
2009 
2010     function unpause() public onlyRole(PAUSER_ROLE) {
2011         _unpause();
2012     }
2013 
2014     function mint(address to, uint256 amount) external override onlyRole(MINTER_ROLE) {
2015         _mint(to, amount);
2016     }
2017 
2018     function burn(address to, uint256 amount) external override onlyRole(BURNER_ROLE) {
2019         _burn(to, amount);
2020     }
2021 
2022     function _beforeTokenTransfer(address from, address to, uint256 amount)
2023         internal
2024         whenNotPaused
2025         override
2026     {
2027         super._beforeTokenTransfer(from, to, amount);
2028     }
2029 }
2030 
2031 
2032 // File @openzeppelin/contracts/utils/cryptography/MerkleProof.sol@v4.5.0
2033 
2034 // OpenZeppelin Contracts (last updated v4.5.0) (utils/cryptography/MerkleProof.sol)
2035 
2036 pragma solidity ^0.8.0;
2037 
2038 /**
2039  * @dev These functions deal with verification of Merkle Trees proofs.
2040  *
2041  * The proofs can be generated using the JavaScript library
2042  * https://github.com/miguelmota/merkletreejs[merkletreejs].
2043  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
2044  *
2045  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
2046  */
2047 library MerkleProof {
2048     /**
2049      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
2050      * defined by `root`. For this, a `proof` must be provided, containing
2051      * sibling hashes on the branch from the leaf to the root of the tree. Each
2052      * pair of leaves and each pair of pre-images are assumed to be sorted.
2053      */
2054     function verify(
2055         bytes32[] memory proof,
2056         bytes32 root,
2057         bytes32 leaf
2058     ) internal pure returns (bool) {
2059         return processProof(proof, leaf) == root;
2060     }
2061 
2062     /**
2063      * @dev Returns the rebuilt hash obtained by traversing a Merklee tree up
2064      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
2065      * hash matches the root of the tree. When processing the proof, the pairs
2066      * of leafs & pre-images are assumed to be sorted.
2067      *
2068      * _Available since v4.4._
2069      */
2070     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
2071         bytes32 computedHash = leaf;
2072         for (uint256 i = 0; i < proof.length; i++) {
2073             bytes32 proofElement = proof[i];
2074             if (computedHash <= proofElement) {
2075                 // Hash(current computed hash + current element of the proof)
2076                 computedHash = _efficientHash(computedHash, proofElement);
2077             } else {
2078                 // Hash(current element of the proof + current computed hash)
2079                 computedHash = _efficientHash(proofElement, computedHash);
2080             }
2081         }
2082         return computedHash;
2083     }
2084 
2085     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
2086         assembly {
2087             mstore(0x00, a)
2088             mstore(0x20, b)
2089             value := keccak256(0x00, 0x40)
2090         }
2091     }
2092 }
2093 
2094 
2095 // File @openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol@v4.5.2
2096 
2097 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
2098 
2099 pragma solidity ^0.8.0;
2100 
2101 
2102 /**
2103  * @dev Contract module which provides a basic access control mechanism, where
2104  * there is an account (an owner) that can be granted exclusive access to
2105  * specific functions.
2106  *
2107  * By default, the owner account will be the one that deploys the contract. This
2108  * can later be changed with {transferOwnership}.
2109  *
2110  * This module is used through inheritance. It will make available the modifier
2111  * `onlyOwner`, which can be applied to your functions to restrict their use to
2112  * the owner.
2113  */
2114 abstract contract OwnableUpgradeable is Initializable, ContextUpgradeable {
2115     address private _owner;
2116 
2117     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
2118 
2119     /**
2120      * @dev Initializes the contract setting the deployer as the initial owner.
2121      */
2122     function __Ownable_init() internal onlyInitializing {
2123         __Ownable_init_unchained();
2124     }
2125 
2126     function __Ownable_init_unchained() internal onlyInitializing {
2127         _transferOwnership(_msgSender());
2128     }
2129 
2130     /**
2131      * @dev Returns the address of the current owner.
2132      */
2133     function owner() public view virtual returns (address) {
2134         return _owner;
2135     }
2136 
2137     /**
2138      * @dev Throws if called by any account other than the owner.
2139      */
2140     modifier onlyOwner() {
2141         require(owner() == _msgSender(), "Ownable: caller is not the owner");
2142         _;
2143     }
2144 
2145     /**
2146      * @dev Leaves the contract without owner. It will not be possible to call
2147      * `onlyOwner` functions anymore. Can only be called by the current owner.
2148      *
2149      * NOTE: Renouncing ownership will leave the contract without an owner,
2150      * thereby removing any functionality that is only available to the owner.
2151      */
2152     function renounceOwnership() public virtual onlyOwner {
2153         _transferOwnership(address(0));
2154     }
2155 
2156     /**
2157      * @dev Transfers ownership of the contract to a new account (`newOwner`).
2158      * Can only be called by the current owner.
2159      */
2160     function transferOwnership(address newOwner) public virtual onlyOwner {
2161         require(newOwner != address(0), "Ownable: new owner is the zero address");
2162         _transferOwnership(newOwner);
2163     }
2164 
2165     /**
2166      * @dev Transfers ownership of the contract to a new account (`newOwner`).
2167      * Internal function without access restriction.
2168      */
2169     function _transferOwnership(address newOwner) internal virtual {
2170         address oldOwner = _owner;
2171         _owner = newOwner;
2172         emit OwnershipTransferred(oldOwner, newOwner);
2173     }
2174 
2175     /**
2176      * @dev This empty reserved space is put in place to allow future versions to add new
2177      * variables without shifting down storage in the inheritance chain.
2178      * See https://docs.openzeppelin.com/contracts/4.x/upgradeable#storage_gaps
2179      */
2180     uint256[49] private __gap;
2181 }
2182 
2183 
2184 // File @openzeppelin/contracts-upgradeable/security/ReentrancyGuardUpgradeable.sol@v4.5.2
2185 
2186 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
2187 
2188 pragma solidity ^0.8.0;
2189 
2190 /**
2191  * @dev Contract module that helps prevent reentrant calls to a function.
2192  *
2193  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
2194  * available, which can be applied to functions to make sure there are no nested
2195  * (reentrant) calls to them.
2196  *
2197  * Note that because there is a single `nonReentrant` guard, functions marked as
2198  * `nonReentrant` may not call one another. This can be worked around by making
2199  * those functions `private`, and then adding `external` `nonReentrant` entry
2200  * points to them.
2201  *
2202  * TIP: If you would like to learn more about reentrancy and alternative ways
2203  * to protect against it, check out our blog post
2204  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
2205  */
2206 abstract contract ReentrancyGuardUpgradeable is Initializable {
2207     // Booleans are more expensive than uint256 or any type that takes up a full
2208     // word because each write operation emits an extra SLOAD to first read the
2209     // slot's contents, replace the bits taken up by the boolean, and then write
2210     // back. This is the compiler's defense against contract upgrades and
2211     // pointer aliasing, and it cannot be disabled.
2212 
2213     // The values being non-zero value makes deployment a bit more expensive,
2214     // but in exchange the refund on every call to nonReentrant will be lower in
2215     // amount. Since refunds are capped to a percentage of the total
2216     // transaction's gas, it is best to keep them low in cases like this one, to
2217     // increase the likelihood of the full refund coming into effect.
2218     uint256 private constant _NOT_ENTERED = 1;
2219     uint256 private constant _ENTERED = 2;
2220 
2221     uint256 private _status;
2222 
2223     function __ReentrancyGuard_init() internal onlyInitializing {
2224         __ReentrancyGuard_init_unchained();
2225     }
2226 
2227     function __ReentrancyGuard_init_unchained() internal onlyInitializing {
2228         _status = _NOT_ENTERED;
2229     }
2230 
2231     /**
2232      * @dev Prevents a contract from calling itself, directly or indirectly.
2233      * Calling a `nonReentrant` function from another `nonReentrant`
2234      * function is not supported. It is possible to prevent this from happening
2235      * by making the `nonReentrant` function external, and making it call a
2236      * `private` function that does the actual work.
2237      */
2238     modifier nonReentrant() {
2239         // On the first call to nonReentrant, _notEntered will be true
2240         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
2241 
2242         // Any calls to nonReentrant after this point will fail
2243         _status = _ENTERED;
2244 
2245         _;
2246 
2247         // By storing the original value once again, a refund is triggered (see
2248         // https://eips.ethereum.org/EIPS/eip-2200)
2249         _status = _NOT_ENTERED;
2250     }
2251 
2252     /**
2253      * @dev This empty reserved space is put in place to allow future versions to add new
2254      * variables without shifting down storage in the inheritance chain.
2255      * See https://docs.openzeppelin.com/contracts/4.x/upgradeable#storage_gaps
2256      */
2257     uint256[49] private __gap;
2258 }
2259 
2260 
2261 // File @openzeppelin/contracts-upgradeable/token/ERC721/IERC721Upgradeable.sol@v4.5.2
2262 
2263 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
2264 
2265 pragma solidity ^0.8.0;
2266 
2267 /**
2268  * @dev Required interface of an ERC721 compliant contract.
2269  */
2270 interface IERC721Upgradeable is IERC165Upgradeable {
2271     /**
2272      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
2273      */
2274     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
2275 
2276     /**
2277      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
2278      */
2279     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
2280 
2281     /**
2282      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
2283      */
2284     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
2285 
2286     /**
2287      * @dev Returns the number of tokens in ``owner``'s account.
2288      */
2289     function balanceOf(address owner) external view returns (uint256 balance);
2290 
2291     /**
2292      * @dev Returns the owner of the `tokenId` token.
2293      *
2294      * Requirements:
2295      *
2296      * - `tokenId` must exist.
2297      */
2298     function ownerOf(uint256 tokenId) external view returns (address owner);
2299 
2300     /**
2301      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
2302      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
2303      *
2304      * Requirements:
2305      *
2306      * - `from` cannot be the zero address.
2307      * - `to` cannot be the zero address.
2308      * - `tokenId` token must exist and be owned by `from`.
2309      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
2310      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
2311      *
2312      * Emits a {Transfer} event.
2313      */
2314     function safeTransferFrom(
2315         address from,
2316         address to,
2317         uint256 tokenId
2318     ) external;
2319 
2320     /**
2321      * @dev Transfers `tokenId` token from `from` to `to`.
2322      *
2323      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
2324      *
2325      * Requirements:
2326      *
2327      * - `from` cannot be the zero address.
2328      * - `to` cannot be the zero address.
2329      * - `tokenId` token must be owned by `from`.
2330      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
2331      *
2332      * Emits a {Transfer} event.
2333      */
2334     function transferFrom(
2335         address from,
2336         address to,
2337         uint256 tokenId
2338     ) external;
2339 
2340     /**
2341      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
2342      * The approval is cleared when the token is transferred.
2343      *
2344      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
2345      *
2346      * Requirements:
2347      *
2348      * - The caller must own the token or be an approved operator.
2349      * - `tokenId` must exist.
2350      *
2351      * Emits an {Approval} event.
2352      */
2353     function approve(address to, uint256 tokenId) external;
2354 
2355     /**
2356      * @dev Returns the account approved for `tokenId` token.
2357      *
2358      * Requirements:
2359      *
2360      * - `tokenId` must exist.
2361      */
2362     function getApproved(uint256 tokenId) external view returns (address operator);
2363 
2364     /**
2365      * @dev Approve or remove `operator` as an operator for the caller.
2366      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
2367      *
2368      * Requirements:
2369      *
2370      * - The `operator` cannot be the caller.
2371      *
2372      * Emits an {ApprovalForAll} event.
2373      */
2374     function setApprovalForAll(address operator, bool _approved) external;
2375 
2376     /**
2377      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
2378      *
2379      * See {setApprovalForAll}
2380      */
2381     function isApprovedForAll(address owner, address operator) external view returns (bool);
2382 
2383     /**
2384      * @dev Safely transfers `tokenId` token from `from` to `to`.
2385      *
2386      * Requirements:
2387      *
2388      * - `from` cannot be the zero address.
2389      * - `to` cannot be the zero address.
2390      * - `tokenId` token must exist and be owned by `from`.
2391      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
2392      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
2393      *
2394      * Emits a {Transfer} event.
2395      */
2396     function safeTransferFrom(
2397         address from,
2398         address to,
2399         uint256 tokenId,
2400         bytes calldata data
2401     ) external;
2402 }
2403 
2404 
2405 // File @openzeppelin/contracts-upgradeable/token/ERC721/IERC721ReceiverUpgradeable.sol@v4.5.2
2406 
2407 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
2408 
2409 pragma solidity ^0.8.0;
2410 
2411 /**
2412  * @title ERC721 token receiver interface
2413  * @dev Interface for any contract that wants to support safeTransfers
2414  * from ERC721 asset contracts.
2415  */
2416 interface IERC721ReceiverUpgradeable {
2417     /**
2418      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
2419      * by `operator` from `from`, this function is called.
2420      *
2421      * It must return its Solidity selector to confirm the token transfer.
2422      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
2423      *
2424      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
2425      */
2426     function onERC721Received(
2427         address operator,
2428         address from,
2429         uint256 tokenId,
2430         bytes calldata data
2431     ) external returns (bytes4);
2432 }
2433 
2434 
2435 // File @openzeppelin/contracts-upgradeable/token/ERC721/extensions/IERC721MetadataUpgradeable.sol@v4.5.2
2436 
2437 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
2438 
2439 pragma solidity ^0.8.0;
2440 
2441 /**
2442  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
2443  * @dev See https://eips.ethereum.org/EIPS/eip-721
2444  */
2445 interface IERC721MetadataUpgradeable is IERC721Upgradeable {
2446     /**
2447      * @dev Returns the token collection name.
2448      */
2449     function name() external view returns (string memory);
2450 
2451     /**
2452      * @dev Returns the token collection symbol.
2453      */
2454     function symbol() external view returns (string memory);
2455 
2456     /**
2457      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
2458      */
2459     function tokenURI(uint256 tokenId) external view returns (string memory);
2460 }
2461 
2462 
2463 // File contracts/interfaces/ERC721AUpgradeable.sol
2464 
2465 // Creator: Chiru Labs
2466 
2467 pragma solidity ^0.8.4;
2468 
2469 
2470 
2471 
2472 
2473 
2474 
2475 
2476 error ApprovalCallerNotOwnerNorApproved();
2477 error ApprovalQueryForNonexistentToken();
2478 error ApproveToCaller();
2479 error ApprovalToCurrentOwner();
2480 error BalanceQueryForZeroAddress();
2481 error MintToZeroAddress();
2482 error MintZeroQuantity();
2483 error OwnerQueryForNonexistentToken();
2484 error TransferCallerNotOwnerNorApproved();
2485 error TransferFromIncorrectOwner();
2486 error TransferToNonERC721ReceiverImplementer();
2487 error TransferToZeroAddress();
2488 error URIQueryForNonexistentToken();
2489 
2490 /**
2491  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
2492  * the Metadata extension. Built to optimize for lower gas during batch mints.
2493  *
2494  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
2495  *
2496  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
2497  *
2498  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
2499  */
2500 contract ERC721AUpgradeable is Initializable, ContextUpgradeable, ERC165Upgradeable, IERC721Upgradeable, IERC721MetadataUpgradeable {
2501     using AddressUpgradeable for address;
2502     using StringsUpgradeable for uint256;
2503 
2504     // Compiler will pack this into a single 256bit word.
2505     struct TokenOwnership {
2506         // The address of the owner.
2507         address addr;
2508         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
2509         uint64 startTimestamp;
2510         // Whether the token has been burned.
2511         bool burned;
2512     }
2513 
2514     // Compiler will pack this into a single 256bit word.
2515     struct AddressData {
2516         // Realistically, 2**64-1 is more than enough.
2517         uint64 balance;
2518         // Keeps track of mint count with minimal overhead for tokenomics.
2519         uint64 numberMinted;
2520         // Keeps track of burn count with minimal overhead for tokenomics.
2521         uint64 numberBurned;
2522         // For miscellaneous variable(s) pertaining to the address
2523         // (e.g. number of whitelist mint slots used).
2524         // If there are multiple variables, please pack them into a uint64.
2525         uint64 aux;
2526     }
2527 
2528     // The tokenId of the next token to be minted.
2529     uint256 internal _currentIndex;
2530 
2531     // The number of tokens burned.
2532     uint256 internal _burnCounter;
2533 
2534     // Token name
2535     string private _name;
2536 
2537     // Token symbol
2538     string private _symbol;
2539 
2540     // Mapping from token ID to ownership details
2541     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
2542     mapping(uint256 => TokenOwnership) internal _ownerships;
2543 
2544     // Mapping owner address to address data
2545     mapping(address => AddressData) private _addressData;
2546 
2547     // Mapping from token ID to approved address
2548     mapping(uint256 => address) private _tokenApprovals;
2549 
2550     // Mapping from owner to operator approvals
2551     mapping(address => mapping(address => bool)) private _operatorApprovals;
2552 
2553     function __ERC721A_init(string memory name_, string memory symbol_) internal onlyInitializing {
2554         __ERC721A_init_unchained(name_, symbol_);
2555     }
2556 
2557     function __ERC721A_init_unchained(string memory name_, string memory symbol_) internal onlyInitializing {
2558         _name = name_;
2559         _symbol = symbol_;
2560         _currentIndex = _startTokenId();
2561     }
2562 
2563     /**
2564      * To change the starting tokenId, please override this function.
2565      */
2566     function _startTokenId() internal view virtual returns (uint256) {
2567         return 1;
2568     }
2569 
2570     /**
2571      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
2572      */
2573     function totalSupply() public view returns (uint256) {
2574         // Counter underflow is impossible as _burnCounter cannot be incremented
2575         // more than _currentIndex - _startTokenId() times
2576         unchecked {
2577             return _currentIndex - _burnCounter - _startTokenId();
2578         }
2579     }
2580 
2581     /**
2582      * Returns the total amount of tokens minted in the contract.
2583      */
2584     function _totalMinted() internal view returns (uint256) {
2585         // Counter underflow is impossible as _currentIndex does not decrement,
2586         // and it is initialized to _startTokenId()
2587         unchecked {
2588             return _currentIndex - _startTokenId();
2589         }
2590     }
2591 
2592     /**
2593      * @dev See {IERC165-supportsInterface}.
2594      */
2595     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165Upgradeable, IERC165Upgradeable) returns (bool) {
2596         return
2597             interfaceId == type(IERC721Upgradeable).interfaceId ||
2598             interfaceId == type(IERC721MetadataUpgradeable).interfaceId ||
2599             super.supportsInterface(interfaceId);
2600     }
2601 
2602     /**
2603      * @dev See {IERC721-balanceOf}.
2604      */
2605     function balanceOf(address owner) public view override returns (uint256) {
2606         if (owner == address(0)) revert BalanceQueryForZeroAddress();
2607         return uint256(_addressData[owner].balance);
2608     }
2609 
2610     /**
2611      * Returns the number of tokens minted by `owner`.
2612      */
2613     function _numberMinted(address owner) internal view returns (uint256) {
2614         return uint256(_addressData[owner].numberMinted);
2615     }
2616 
2617     /**
2618      * Returns the number of tokens burned by or on behalf of `owner`.
2619      */
2620     function _numberBurned(address owner) internal view returns (uint256) {
2621         return uint256(_addressData[owner].numberBurned);
2622     }
2623 
2624     /**
2625      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
2626      */
2627     function _getAux(address owner) internal view returns (uint64) {
2628         return _addressData[owner].aux;
2629     }
2630 
2631     /**
2632      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
2633      * If there are multiple variables, please pack them into a uint64.
2634      */
2635     function _setAux(address owner, uint64 aux) internal {
2636         _addressData[owner].aux = aux;
2637     }
2638 
2639     /**
2640      * Gas spent here starts off proportional to the maximum mint batch size.
2641      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
2642      */
2643     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
2644         uint256 curr = tokenId;
2645 
2646         unchecked {
2647             if (_startTokenId() <= curr && curr < _currentIndex) {
2648                 TokenOwnership memory ownership = _ownerships[curr];
2649                 if (!ownership.burned) {
2650                     if (ownership.addr != address(0)) {
2651                         return ownership;
2652                     }
2653                     // Invariant:
2654                     // There will always be an ownership that has an address and is not burned
2655                     // before an ownership that does not have an address and is not burned.
2656                     // Hence, curr will not underflow.
2657                     while (true) {
2658                         curr--;
2659                         ownership = _ownerships[curr];
2660                         if (ownership.addr != address(0)) {
2661                             return ownership;
2662                         }
2663                     }
2664                 }
2665             }
2666         }
2667         revert OwnerQueryForNonexistentToken();
2668     }
2669 
2670     /**
2671      * @dev See {IERC721-ownerOf}.
2672      */
2673     function ownerOf(uint256 tokenId) public view override returns (address) {
2674         return _ownershipOf(tokenId).addr;
2675     }
2676 
2677     /**
2678      * @dev See {IERC721Metadata-name}.
2679      */
2680     function name() public view virtual override returns (string memory) {
2681         return _name;
2682     }
2683 
2684     /**
2685      * @dev See {IERC721Metadata-symbol}.
2686      */
2687     function symbol() public view virtual override returns (string memory) {
2688         return _symbol;
2689     }
2690 
2691     /**
2692      * @dev See {IERC721Metadata-tokenURI}.
2693      */
2694     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
2695         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
2696 
2697         string memory baseURI = _baseURI();
2698         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
2699     }
2700 
2701     /**
2702      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
2703      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
2704      * by default, can be overriden in child contracts.
2705      */
2706     function _baseURI() internal view virtual returns (string memory) {
2707         return '';
2708     }
2709 
2710     /**
2711      * @dev See {IERC721-approve}.
2712      */
2713     function approve(address to, uint256 tokenId) public override {
2714         address owner = ERC721AUpgradeable.ownerOf(tokenId);
2715         if (to == owner) revert ApprovalToCurrentOwner();
2716 
2717         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
2718             revert ApprovalCallerNotOwnerNorApproved();
2719         }
2720 
2721         _approve(to, tokenId, owner);
2722     }
2723 
2724     /**
2725      * @dev See {IERC721-getApproved}.
2726      */
2727     function getApproved(uint256 tokenId) public view override returns (address) {
2728         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
2729 
2730         return _tokenApprovals[tokenId];
2731     }
2732 
2733     /**
2734      * @dev See {IERC721-setApprovalForAll}.
2735      */
2736     function setApprovalForAll(address operator, bool approved) public virtual override {
2737         if (operator == _msgSender()) revert ApproveToCaller();
2738 
2739         _operatorApprovals[_msgSender()][operator] = approved;
2740         emit ApprovalForAll(_msgSender(), operator, approved);
2741     }
2742 
2743     /**
2744      * @dev See {IERC721-isApprovedForAll}.
2745      */
2746     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
2747         return _operatorApprovals[owner][operator];
2748     }
2749 
2750     /**
2751      * @dev See {IERC721-transferFrom}.
2752      */
2753     function transferFrom(
2754         address from,
2755         address to,
2756         uint256 tokenId
2757     ) public virtual override {
2758         _transfer(from, to, tokenId);
2759     }
2760 
2761     /**
2762      * @dev See {IERC721-safeTransferFrom}.
2763      */
2764     function safeTransferFrom(
2765         address from,
2766         address to,
2767         uint256 tokenId
2768     ) public virtual override {
2769         safeTransferFrom(from, to, tokenId, '');
2770     }
2771 
2772     /**
2773      * @dev See {IERC721-safeTransferFrom}.
2774      */
2775     function safeTransferFrom(
2776         address from,
2777         address to,
2778         uint256 tokenId,
2779         bytes memory _data
2780     ) public virtual override {
2781         _transfer(from, to, tokenId);
2782         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
2783             revert TransferToNonERC721ReceiverImplementer();
2784         }
2785     }
2786 
2787     /**
2788      * @dev Returns whether `tokenId` exists.
2789      *
2790      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
2791      *
2792      * Tokens start existing when they are minted (`_mint`),
2793      */
2794     function _exists(uint256 tokenId) internal view returns (bool) {
2795         return _startTokenId() <= tokenId && tokenId < _currentIndex && !_ownerships[tokenId].burned;
2796     }
2797 
2798     function _safeMint(address to, uint256 quantity) internal {
2799         _safeMint(to, quantity, '');
2800     }
2801 
2802     /**
2803      * @dev Safely mints `quantity` tokens and transfers them to `to`.
2804      *
2805      * Requirements:
2806      *
2807      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
2808      * - `quantity` must be greater than 0.
2809      *
2810      * Emits a {Transfer} event.
2811      */
2812     function _safeMint(
2813         address to,
2814         uint256 quantity,
2815         bytes memory _data
2816     ) internal {
2817         _mint(to, quantity, _data, true);
2818     }
2819 
2820     /**
2821      * @dev Mints `quantity` tokens and transfers them to `to`.
2822      *
2823      * Requirements:
2824      *
2825      * - `to` cannot be the zero address.
2826      * - `quantity` must be greater than 0.
2827      *
2828      * Emits a {Transfer} event.
2829      */
2830     function _mint(
2831         address to,
2832         uint256 quantity,
2833         bytes memory _data,
2834         bool safe
2835     ) internal {
2836         uint256 startTokenId = _currentIndex;
2837         if (to == address(0)) revert MintToZeroAddress();
2838         if (quantity == 0) revert MintZeroQuantity();
2839 
2840         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
2841 
2842         // Overflows are incredibly unrealistic.
2843         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
2844         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
2845         unchecked {
2846             _addressData[to].balance += uint64(quantity);
2847             _addressData[to].numberMinted += uint64(quantity);
2848 
2849             _ownerships[startTokenId].addr = to;
2850             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
2851 
2852             uint256 updatedIndex = startTokenId;
2853             uint256 end = updatedIndex + quantity;
2854 
2855             if (safe && to.isContract()) {
2856                 do {
2857                     emit Transfer(address(0), to, updatedIndex);
2858                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
2859                         revert TransferToNonERC721ReceiverImplementer();
2860                     }
2861                 } while (updatedIndex != end);
2862                 // Reentrancy protection
2863                 if (_currentIndex != startTokenId) revert();
2864             } else {
2865                 do {
2866                     emit Transfer(address(0), to, updatedIndex++);
2867                 } while (updatedIndex != end);
2868             }
2869             _currentIndex = updatedIndex;
2870         }
2871         _afterTokenTransfers(address(0), to, startTokenId, quantity);
2872     }
2873 
2874 
2875     /**
2876      * @dev Equivalent to _mint(to, quantity, '', false).
2877      */
2878     function _mint(address to, uint256 quantity) internal {
2879         uint256 startTokenId = _currentIndex;
2880         if (to == address(0)) revert MintToZeroAddress();
2881         if (quantity == 0) revert MintZeroQuantity();
2882 
2883         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
2884 
2885         // Overflows are incredibly unrealistic.
2886         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
2887         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
2888         unchecked {
2889             _addressData[to].balance += uint64(quantity);
2890             _addressData[to].numberMinted += uint64(quantity);
2891 
2892             _ownerships[startTokenId].addr = to;
2893             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
2894 
2895             uint256 updatedIndex = startTokenId;
2896             uint256 end = updatedIndex + quantity;
2897 
2898             do {
2899                 emit Transfer(address(0), to, updatedIndex++);
2900             } while (updatedIndex != end);
2901 
2902             _currentIndex = updatedIndex;
2903         }
2904         _afterTokenTransfers(address(0), to, startTokenId, quantity);
2905     }
2906 
2907     /**
2908      * @dev Transfers `tokenId` from `from` to `to`.
2909      *
2910      * Requirements:
2911      *
2912      * - `to` cannot be the zero address.
2913      * - `tokenId` token must be owned by `from`.
2914      *
2915      * Emits a {Transfer} event.
2916      */
2917     function _transfer(
2918         address from,
2919         address to,
2920         uint256 tokenId
2921     ) private {
2922         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
2923 
2924         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
2925 
2926         bool isApprovedOrOwner = (_msgSender() == from ||
2927             isApprovedForAll(from, _msgSender()) ||
2928             getApproved(tokenId) == _msgSender());
2929 
2930         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
2931         if (to == address(0)) revert TransferToZeroAddress();
2932 
2933         _beforeTokenTransfers(from, to, tokenId, 1);
2934 
2935         // Clear approvals from the previous owner
2936         _approve(address(0), tokenId, from);
2937 
2938         // Underflow of the sender's balance is impossible because we check for
2939         // ownership above and the recipient's balance can't realistically overflow.
2940         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
2941         unchecked {
2942             _addressData[from].balance -= 1;
2943             _addressData[to].balance += 1;
2944 
2945             TokenOwnership storage currSlot = _ownerships[tokenId];
2946             currSlot.addr = to;
2947             currSlot.startTimestamp = uint64(block.timestamp);
2948 
2949             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
2950             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
2951             uint256 nextTokenId = tokenId + 1;
2952             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
2953             if (nextSlot.addr == address(0)) {
2954                 // This will suffice for checking _exists(nextTokenId),
2955                 // as a burned slot cannot contain the zero address.
2956                 if (nextTokenId != _currentIndex) {
2957                     nextSlot.addr = from;
2958                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
2959                 }
2960             }
2961         }
2962 
2963         emit Transfer(from, to, tokenId);
2964         _afterTokenTransfers(from, to, tokenId, 1);
2965     }
2966 
2967     /**
2968      * @dev This is equivalent to _burn(tokenId, false)
2969      */
2970     function _burn(uint256 tokenId) internal virtual {
2971         _burn(tokenId, false);
2972     }
2973 
2974     /**
2975      * @dev Destroys `tokenId`.
2976      * The approval is cleared when the token is burned.
2977      *
2978      * Requirements:
2979      *
2980      * - `tokenId` must exist.
2981      *
2982      * Emits a {Transfer} event.
2983      */
2984     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
2985         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
2986 
2987         address from = prevOwnership.addr;
2988 
2989         if (approvalCheck) {
2990             bool isApprovedOrOwner = (_msgSender() == from ||
2991                 isApprovedForAll(from, _msgSender()) ||
2992                 getApproved(tokenId) == _msgSender());
2993 
2994             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
2995         }
2996 
2997         _beforeTokenTransfers(from, address(0), tokenId, 1);
2998 
2999         // Clear approvals from the previous owner
3000         _approve(address(0), tokenId, from);
3001 
3002         // Underflow of the sender's balance is impossible because we check for
3003         // ownership above and the recipient's balance can't realistically overflow.
3004         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
3005         unchecked {
3006             AddressData storage addressData = _addressData[from];
3007             addressData.balance -= 1;
3008             addressData.numberBurned += 1;
3009 
3010             // Keep track of who burned the token, and the timestamp of burning.
3011             TokenOwnership storage currSlot = _ownerships[tokenId];
3012             currSlot.addr = from;
3013             currSlot.startTimestamp = uint64(block.timestamp);
3014             currSlot.burned = true;
3015 
3016             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
3017             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
3018             uint256 nextTokenId = tokenId + 1;
3019             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
3020             if (nextSlot.addr == address(0)) {
3021                 // This will suffice for checking _exists(nextTokenId),
3022                 // as a burned slot cannot contain the zero address.
3023                 if (nextTokenId != _currentIndex) {
3024                     nextSlot.addr = from;
3025                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
3026                 }
3027             }
3028         }
3029 
3030         emit Transfer(from, address(0), tokenId);
3031         _afterTokenTransfers(from, address(0), tokenId, 1);
3032 
3033         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
3034         unchecked {
3035             _burnCounter++;
3036         }
3037     }
3038 
3039     /**
3040      * @dev Approve `to` to operate on `tokenId`
3041      *
3042      * Emits a {Approval} event.
3043      */
3044     function _approve(
3045         address to,
3046         uint256 tokenId,
3047         address owner
3048     ) private {
3049         _tokenApprovals[tokenId] = to;
3050         emit Approval(owner, to, tokenId);
3051     }
3052 
3053     /**
3054      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
3055      *
3056      * @param from address representing the previous owner of the given token ID
3057      * @param to target address that will receive the tokens
3058      * @param tokenId uint256 ID of the token to be transferred
3059      * @param _data bytes optional data to send along with the call
3060      * @return bool whether the call correctly returned the expected magic value
3061      */
3062     function _checkContractOnERC721Received(
3063         address from,
3064         address to,
3065         uint256 tokenId,
3066         bytes memory _data
3067     ) private returns (bool) {
3068         try IERC721ReceiverUpgradeable(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
3069             return retval == IERC721ReceiverUpgradeable(to).onERC721Received.selector;
3070         } catch (bytes memory reason) {
3071             if (reason.length == 0) {
3072                 revert TransferToNonERC721ReceiverImplementer();
3073             } else {
3074                 assembly {
3075                     revert(add(32, reason), mload(reason))
3076                 }
3077             }
3078         }
3079     }
3080 
3081     /**
3082      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
3083      * And also called before burning one token.
3084      *
3085      * startTokenId - the first token id to be transferred
3086      * quantity - the amount to be transferred
3087      *
3088      * Calling conditions:
3089      *
3090      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
3091      * transferred to `to`.
3092      * - When `from` is zero, `tokenId` will be minted for `to`.
3093      * - When `to` is zero, `tokenId` will be burned by `from`.
3094      * - `from` and `to` are never both zero.
3095      */
3096     function _beforeTokenTransfers(
3097         address from,
3098         address to,
3099         uint256 startTokenId,
3100         uint256 quantity
3101     ) internal virtual {}
3102 
3103     /**
3104      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
3105      * minting.
3106      * And also called after one token has been burned.
3107      *
3108      * startTokenId - the first token id to be transferred
3109      * quantity - the amount to be transferred
3110      *
3111      * Calling conditions:
3112      *
3113      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
3114      * transferred to `to`.
3115      * - When `from` is zero, `tokenId` has been minted for `to`.
3116      * - When `to` is zero, `tokenId` has been burned by `from`.
3117      * - `from` and `to` are never both zero.
3118      */
3119     function _afterTokenTransfers(
3120         address from,
3121         address to,
3122         uint256 startTokenId,
3123         uint256 quantity
3124     ) internal virtual {}
3125 
3126 
3127     /// @dev Returns the tokenIds of the address. O(totalSupply) in complexity.
3128     function tokensOfOwner(address owner) external view returns (uint256[] memory) {
3129         unchecked {
3130             uint256[] memory a = new uint256[](balanceOf(owner)); 
3131             uint256 end = _currentIndex;
3132             uint256 tokenIdsIdx;
3133             address currOwnershipAddr;
3134             for (uint256 i; i < end; i++) {
3135                 TokenOwnership memory ownership = _ownerships[i];
3136                 if (ownership.burned) {
3137                     continue;
3138                 }
3139                 if (ownership.addr != address(0)) {
3140                     currOwnershipAddr = ownership.addr;
3141                 }
3142                 if (currOwnershipAddr == owner) {
3143                     a[tokenIdsIdx++] = i;
3144                 }
3145             }
3146             return a;    
3147         }
3148     }
3149 
3150 
3151     /**
3152      * @dev This empty reserved space is put in place to allow future versions to add new
3153      * variables without shifting down storage in the inheritance chain.
3154      * See https://docs.openzeppelin.com/contracts/4.x/upgradeable#storage_gaps
3155      */
3156     uint256[42] private __gap;
3157 }
3158 
3159 
3160 // File contracts/interfaces/IDiamondHeist.sol
3161 
3162 
3163 pragma solidity ^0.8.0;
3164 
3165 
3166 interface IDiamondHeist is IERC721Upgradeable, IERC721MetadataUpgradeable {
3167 
3168   // struct to store each token's traits
3169   struct LlamaDog {
3170     bool isLlama;
3171     uint8 body;
3172     uint8 hat;
3173     uint8 eye;
3174     uint8 mouth;
3175     uint8 clothes;
3176     uint8 tail;
3177     uint8 alphaIndex;
3178   }
3179 
3180   function getPaidTokens() external view returns (uint256);
3181   function getTokenTraits(uint256 tokenId) external view returns (LlamaDog memory);
3182   function isLlama(uint256 tokenId) external view returns(bool);
3183 }
3184 
3185 
3186 // File contracts/interfaces/IStaking.sol
3187 
3188 
3189 pragma solidity ^0.8.0;
3190 
3191 interface IStaking {
3192   function addManyToStaking(address account, uint16[] calldata tokenIds) external;
3193 }
3194 
3195 
3196 // File contracts/interfaces/ITraits.sol
3197 
3198 
3199 pragma solidity ^0.8.0;
3200 
3201 interface ITraits {
3202   function tokenURI(uint256 tokenId) external view returns (string memory);
3203 }
3204 
3205 
3206 // File contracts/DiamondHeist.sol
3207 
3208 
3209 /**
3210        .     '     ,      '     ,     .     '   .    
3211       _________        _________       _________    
3212    _ /_|_____|_\ _  _ /_|_____|_\ _ _ /_|_____|_\ _ 
3213      '. \   / .'      '. \   / .'     '. \   / .'   
3214        '.\ /.'          '.\ /.'         '.\ /.'     
3215          '.'              '.'             '.'
3216  
3217  ██████╗ ██╗ █████╗ ███╗   ███╗ ██████╗ ███╗   ██╗██████╗  
3218  ██╔══██╗██║██╔══██╗████╗ ████║██╔═══██╗████╗  ██║██╔══██╗ 
3219  ██║  ██║██║███████║██╔████╔██║██║   ██║██╔██╗ ██║██║  ██║ 
3220  ██║  ██║██║██╔══██║██║╚██╔╝██║██║   ██║██║╚██╗██║██║  ██║ 
3221  ██████╔╝██║██║  ██║██║ ╚═╝ ██║╚██████╔╝██║ ╚████║██████╔╝ 
3222  ╚═════╝ ╚═╝╚═╝  ╚═╝╚═╝     ╚═╝ ╚═════╝ ╚═╝  ╚═══╝╚═════╝  
3223            ██╗  ██╗███████╗██╗███████╗████████╗
3224            ██║  ██║██╔════╝██║██╔════╝╚══██╔══╝   <'l    
3225       __   ███████║█████╗  ██║███████╗   ██║       ll    
3226  (___()'`; ██╔══██║██╔══╝  ██║╚════██║   ██║       llama~
3227  /,    /`  ██║  ██║███████╗██║███████║   ██║       || || 
3228  \\"--\\   ╚═╝  ╚═╝╚══════╝╚═╝╚══════╝   ╚═╝       '' '' 
3229 
3230 */
3231 
3232 pragma solidity ^0.8.0;
3233 
3234 
3235 
3236 
3237 
3238 
3239 
3240 
3241 
3242 contract DiamondHeist is
3243     ERC721AUpgradeable,
3244     IDiamondHeist,
3245     OwnableUpgradeable,
3246     PausableUpgradeable,
3247     ReentrancyGuardUpgradeable
3248 {
3249     event LlamaMinted(uint256 indexed tokenId);
3250     event DogMinted(uint256 indexed tokenId);
3251     event LlamaBurned(uint256 indexed tokenId);
3252     event DogBurned(uint256 indexed tokenId);
3253 
3254     // max number of tokens that can be minted - 37,500 in production
3255     uint256 public constant MAX_TOKENS = 37500;
3256     // number of tokens that can be claimed for a fee - 20% of MAX_TOKENS
3257     uint256 public PAID_TOKENS;
3258 
3259     uint256 public MINT_PRICE;
3260 
3261     // whitelist, 10 mints, get a discount, 1 free
3262     uint16 public constant MAX_COMMUNITY_AMOUNT = 5;
3263     uint256 public COMMUNITY_SALE_MINT_PRICE;
3264     bytes32 public whitelistMerkleRoot;
3265     mapping(address => uint256) public claimed;
3266 
3267     // mapping from tokenId to a struct containing the token's traits
3268     mapping(uint256 => LlamaDog) public tokenTraits;
3269     // mapping from hashed(tokenTrait) to the tokenId it's associated with
3270     // used to ensure there are no duplicates
3271     mapping(uint256 => uint256) public existingCombinations;
3272 
3273     // list of probabilities for each trait type
3274     uint8[][14] public rarities;
3275     // list of aliases for Walker's Alias algorithm
3276     uint8[][14] public aliases;
3277 
3278     // reference to the Staking for choosing random Dog thieves
3279     IStaking public staking;
3280     // reference to $DIAMOND for burning on mint
3281     IDIAMOND public diamond;
3282     // reference to Traits
3283     ITraits public traits;
3284 
3285     /// @custom:oz-upgrades-unsafe-allow constructor
3286     constructor() initializer {}
3287 
3288     function initialize() initializer public {
3289         __ERC721A_init("Diamond Heist", "DIAMONDHEIST");
3290         __Pausable_init();
3291         __Ownable_init();
3292         __ReentrancyGuard_init();
3293         _pause();
3294 
3295         PAID_TOKENS = 7500;
3296         MINT_PRICE = .06 ether;
3297         COMMUNITY_SALE_MINT_PRICE = .04 ether;
3298 
3299         // Llama/Body
3300         rarities[0] = [255, 61, 122, 30, 183, 224, 142, 30, 214, 173, 214, 122];
3301         aliases[0] = [0, 0, 0, 7, 7, 0, 5, 6, 7, 8, 8, 9];
3302         
3303         // Llama/Hat
3304         rarities[1] = [114, 254, 191, 152, 242, 152, 191, 229, 242, 114, 254, 76, 76, 203, 191];
3305         aliases[1] = [6, 0, 6, 6, 1, 6, 4, 6, 6, 6, 8, 6, 8, 10, 13];
3306         
3307         // Llama/Eye
3308         rarities[2] = [165, 66, 198, 255, 165, 211, 168, 165, 107, 99, 186, 175, 165];
3309         aliases[2] = [6, 6, 6, 0, 6, 3, 5, 6, 6, 8, 8, 10, 11];
3310         
3311         // Llama/Mouth
3312         rarities[3] = [140, 224, 28, 112, 112, 112, 254, 229, 160, 221, 140];
3313         aliases[3] = [7, 7, 7, 7, 7, 8, 0, 6, 7, 8, 9];
3314         
3315         // Llama/Clothes
3316         rarities[4] = [229, 254, 191, 216, 127, 152, 152, 165, 76, 114, 254, 152, 203, 76, 191];
3317         aliases[4] = [1, 0, 1, 2, 3, 2, 2, 4, 2, 4, 7, 4, 10, 7, 12];
3318         
3319         // Llama/Tail
3320         rarities[5] = [127, 255, 127, 127, 229, 102, 255, 255, 178, 51];
3321         aliases[5] = [7, 0, 7, 7, 7, 7, 0, 0, 7, 8];
3322         
3323         // Llama/alphaIndex
3324         rarities[6] = [255];
3325         aliases[6] = [0];
3326         
3327         // Dog/Body
3328         rarities[7] = [140, 254, 28, 224, 56, 181, 244, 84, 219, 28, 193];
3329         aliases[7] = [1, 0, 1, 1, 5, 1, 5, 5, 6, 10, 8];
3330         
3331         // Dog/Hat
3332         rarities[8] = [99, 165, 255, 178, 33, 232, 102, 33, 198, 232, 209, 198, 132];
3333         aliases[8] = [6, 6, 0, 2, 6, 6, 3, 6, 6, 6, 6, 6, 10];
3334         
3335         // Dog/Eye
3336         rarities[9] = [254, 30, 224, 153, 203, 30, 153, 214, 91, 91, 214, 153];
3337         aliases[9] = [0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 4];
3338         
3339         // Dog/Mouth
3340         rarities[10] = [254, 122, 61, 30, 61, 122, 142, 91, 91, 183, 244, 244];
3341         aliases[10] = [0, 0, 0, 0, 8, 8, 0, 9, 6, 8, 9, 9];
3342         
3343         // Dog/Clothes
3344         rarities[11] = [254, 107, 107, 35, 152, 198, 35, 107, 117, 132, 107, 107, 107, 107];
3345         aliases[11] = [0, 4, 5, 5, 0, 4, 5, 5, 5, 8, 8, 8, 9, 9];
3346         
3347         // Dog/Tail
3348         rarities[12] = [140, 254, 84, 84, 84, 203, 140, 196, 196, 140, 140];
3349         aliases[12] = [1, 0, 5, 5, 5, 1, 5, 5, 5, 5, 5];
3350         
3351         // Dog/alphaIndex
3352         rarities[13] = [254, 101, 153, 51];
3353         aliases[13] = [0, 0, 0, 1];
3354     }
3355 
3356     modifier requireContractsSet() {
3357         require(
3358             address(traits) != address(0) && address(staking) != address(0),
3359             "Contracts not set"
3360         );
3361         _;
3362     }
3363 
3364     function setContracts(ITraits _traits, IStaking _staking, IDIAMOND _diamond)
3365         external
3366         onlyOwner
3367     {
3368         traits = _traits;
3369         staking = _staking;
3370         diamond = _diamond;
3371     }
3372 
3373     function setWhiteListMerkleRoot(bytes32 _root) external onlyOwner {
3374         whitelistMerkleRoot = _root;
3375     }
3376 
3377     modifier isValidMerkleProof(bytes32[] memory proof) {
3378         require(
3379             MerkleProof.verify(
3380                 proof,
3381                 whitelistMerkleRoot,
3382                 bytes32(uint256(uint160(_msgSender())))
3383             ),
3384             "INVALID_MERKLE_PROOF"
3385         );
3386         _;
3387     }
3388 
3389     /** EXTERNAL */
3390     /**
3391      * Returns the total amount of tokens minted in the contract.
3392      */
3393     function minted() external view returns (uint256) {
3394         return _totalMinted();
3395     }
3396 
3397     function communitySaleLeft(bytes32[] memory merkleProof)
3398         external
3399         view
3400         isValidMerkleProof(merkleProof)
3401         returns (uint256)
3402     {
3403         if (_totalMinted() >= PAID_TOKENS) return 0;
3404         return MAX_COMMUNITY_AMOUNT - claimed[_msgSender()];
3405     }
3406 
3407     /**
3408      * mint a token - 90% Llama, 10% Dog
3409      * The first 20% are free to claim, the remaining cost $DIAMOND
3410      */
3411     function mintGame(uint256 amount, bool stake)
3412         internal
3413         whenNotPaused
3414         nonReentrant
3415         returns (uint16[] memory tokenIds)
3416     {
3417         require(tx.origin == _msgSender(), "ONLY_EOA");
3418         require(_totalMinted() + amount <= MAX_TOKENS, "MINT_ENDED");
3419         require(amount > 0 && amount <= 15, "MINT_AMOUNT_INVALID");
3420 
3421         uint256 totalDiamondCost = 0;
3422         tokenIds = new uint16[](amount);
3423         
3424         uint16 token = uint16(_totalMinted());
3425         for (uint256 i = 0; i < amount; i++) {
3426             token++;
3427             generate(token, random(token));
3428             tokenIds[i] = token;
3429             totalDiamondCost += mintCost(token);
3430         }
3431 
3432         if (totalDiamondCost > 0) diamond.burn(_msgSender(), totalDiamondCost);
3433 
3434         _mint(stake ? address(staking) : _msgSender(), amount, "", false);
3435         if (stake) staking.addManyToStaking(_msgSender(), tokenIds);
3436 
3437         return tokenIds;
3438     }
3439 
3440     /**
3441      * mint a token - 90% Llama, 10% Dog
3442      * The first 20% are free to claim, the remaining cost $DIAMOND
3443      */
3444     function mint(uint256 amount, bool stake) external payable {
3445         if (_totalMinted() < PAID_TOKENS) {
3446             // we have to still pay in ETH, we can make a transaction that pays both in ETH and DIAMOND
3447             // check how many tokens should be paid in ETH, the DIAMOND will be burned in mintGame function
3448             require(msg.value == (amount > (PAID_TOKENS - _totalMinted()) ? (PAID_TOKENS - _totalMinted()) : amount) * MINT_PRICE, "MINT_PAID_PRICE_INVALID");
3449         } else {
3450             require(msg.value == 0, "MINT_PAID_IN_DIAMONDS");
3451         }
3452         mintGame(amount, stake);
3453     }
3454 
3455     function mintCommunitySale(
3456         bytes32[] memory merkleProof,
3457         uint256 amount,
3458         bool stake
3459     ) external payable isValidMerkleProof(merkleProof) {
3460         require(
3461             claimed[_msgSender()] + amount <= MAX_COMMUNITY_AMOUNT,
3462             "MINT_COMMUNITY_ENDED"
3463         );
3464         require(_totalMinted() + amount <= PAID_TOKENS, "MINT_ENDED");
3465         require(msg.value == COMMUNITY_SALE_MINT_PRICE * (claimed[_msgSender()] == 0 ? amount - 1 : amount), "MINT_COMMUNITY_PRICE_INVALID");
3466         claimed[_msgSender()] += amount;
3467         mintGame(amount, stake);
3468     }
3469 
3470     /**
3471      * 0 - 20% = eth
3472      * 20 - 40% = 200 DIAMONDS
3473      * 40 - 60% = 300 DIAMONDS
3474      * 60 - 80% = 400 DIAMONDS
3475      * 80 - 100% = 500 DIAMONDS
3476      * @param tokenId the ID to check the cost of to mint
3477      * @return the cost of the given token ID
3478      */
3479     function mintCost(uint256 tokenId) public view returns (uint256) {
3480         if (tokenId <= PAID_TOKENS) return 0; // 1 / 5 = PAID_TOKENS
3481         if (tokenId <= (MAX_TOKENS * 2) / 5) return 200 ether;
3482         if (tokenId <= (MAX_TOKENS * 3) / 5) return 300 ether;
3483         if (tokenId <= (MAX_TOKENS * 4) / 5) return 400 ether;
3484         return 500 ether;
3485     }
3486 
3487     function isApprovedForAll(address owner, address operator) public view override(ERC721AUpgradeable, IERC721Upgradeable) returns (bool) {
3488         return (address(staking) == operator || ERC721AUpgradeable.isApprovedForAll(owner, operator));
3489     }
3490 
3491     /** INTERNAL */
3492 
3493     /**
3494      * generates traits for a specific token, checking to make sure it's unique
3495      * @param tokenId the id of the token to generate traits for
3496      * @param seed a pseudorandom 256 bit number to derive traits from
3497      * @return t - a struct of traits for the given token ID
3498      */
3499     function generate(uint256 tokenId, uint256 seed)
3500         internal
3501         returns (LlamaDog memory t)
3502     {
3503         t = selectTraits(tokenId, seed);
3504         if (existingCombinations[structToHash(t)] == 0) {
3505             tokenTraits[tokenId] = t;
3506             existingCombinations[structToHash(t)] = tokenId;
3507             if (t.isLlama) {
3508                 emit LlamaMinted(tokenId);
3509             } else {
3510                 emit DogMinted(tokenId);
3511             }
3512             return t;
3513         }
3514         return generate(tokenId, random(seed));
3515     }
3516 
3517     /**
3518      * uses A.J. Walker's Alias algorithm for O(1) rarity table lookup
3519      * ensuring O(1) instead of O(n) reduces mint cost by more than 50%
3520      * probability & alias tables are generated off-chain beforehand
3521      * @param seed portion of the 256 bit seed to remove trait correlation
3522      * @param traitType the trait type to select a trait for
3523      * @return the ID of the randomly selected trait
3524      */
3525     function selectTrait(uint16 seed, uint8 traitType)
3526         internal
3527         view
3528         returns (uint8)
3529     {
3530         uint8 trait = uint8(seed) % uint8(rarities[traitType].length);
3531         // If a selected random trait probability is selected (biased coin) return that trait
3532         if (seed >> 8 <= rarities[traitType][trait]) return trait;
3533         return aliases[traitType][trait];
3534     }
3535 
3536     /**
3537      * selects the species and all of its traits based on the seed value
3538      * @param seed a pseudorandom 256 bit number to derive traits from
3539      * @return t -  a struct of randomly selected traits
3540      */
3541     function selectTraits(uint256 tokenId, uint256 seed)
3542         internal
3543         view
3544         returns (LlamaDog memory t)
3545     {
3546         // if tokenId < PAID_TOKENS, 2 in 10 chance of a dog, otherwise 1 in 10 chance of a dog
3547         t.isLlama = tokenId < PAID_TOKENS ? (seed & 0xFFFF) % 10 < 9 : (seed & 0xFFFF) % 10 < 1;
3548         uint8 shift = t.isLlama ? 0 : 7;
3549 
3550         // what happens here is that we check the 16 least signficial bits of the seed
3551         // and then remove them from the seed, so that the next 16 bits are used for the next trait
3552         // Before: EBD302F8B72AB0883F98D59C3BB7C25C61E30A77AB5F93924D234A620A32
3553         // After:  EBD302F8B72AB0883F98D59C3BB7C25C61E30A77AB5F93924D234A62
3554         // trait 1: 0A32 -> 00001010 00110010
3555         seed >>= 16;
3556         t.body = selectTrait(uint16(seed & 0xFFFF), 0 + shift);
3557         seed >>= 16;
3558         t.hat = selectTrait(uint16(seed & 0xFFFF), 1 + shift);
3559         seed >>= 16;
3560         t.eye = selectTrait(uint16(seed & 0xFFFF), 2 + shift);
3561         seed >>= 16;
3562         t.mouth = selectTrait(uint16(seed & 0xFFFF), 3 + shift);
3563         seed >>= 16;
3564         t.clothes = selectTrait(uint16(seed & 0xFFFF), 4 + shift);
3565         seed >>= 16;
3566         t.tail = selectTrait(uint16(seed & 0xFFFF), 5 + shift);
3567         seed >>= 16;
3568         t.alphaIndex = selectTrait(uint16(seed & 0xFFFF), 6 + shift);
3569     }
3570 
3571     /**
3572      * converts a struct to a 256 bit hash to check for uniqueness
3573      * @param s the struct to pack into a hash
3574      * @return the 256 bit hash of the struct
3575      */
3576     function structToHash(LlamaDog memory s) internal pure returns (uint256) {
3577         return
3578             uint256(
3579                 bytes32(
3580                     abi.encodePacked(
3581                         s.isLlama,
3582                         s.body,
3583                         s.hat,
3584                         s.eye,
3585                         s.mouth,
3586                         s.clothes,
3587                         s.tail,
3588                         s.alphaIndex
3589                     )
3590                 )
3591             );
3592     }
3593 
3594     /**
3595      * generates a pseudorandom number
3596      * @param seed a value ensure different outcomes for different sources in the same block
3597      * @return a pseudorandom value
3598      */
3599     function random(uint256 seed) internal view returns (uint256) {
3600         return
3601             uint256(
3602                 keccak256(
3603                     abi.encodePacked(
3604                         tx.origin,
3605                         blockhash(block.number - 1),
3606                         block.timestamp,
3607                         seed
3608                     )
3609                 )
3610             );
3611     }
3612 
3613     /** READ */
3614 
3615     function getTokenTraits(uint256 tokenId)
3616         external
3617         view
3618         override
3619         returns (LlamaDog memory)
3620     {
3621         require(
3622             _exists(tokenId),
3623             "ERC721Metadata: token traits query for nonexistent token"
3624         );
3625         return tokenTraits[tokenId];
3626     }
3627 
3628     function getPaidTokens() external view override returns (uint256) {
3629         return PAID_TOKENS;
3630     }
3631 
3632     /**
3633      * checks if a token is a Wizards
3634      * @param tokenId the ID of the token to check
3635      * @return wizard - whether or not a token is a Wizards
3636      */
3637     function isLlama(uint256 tokenId)
3638         external
3639         view
3640         override
3641         returns (bool)
3642     {
3643         IDiamondHeist.LlamaDog memory s = tokenTraits[tokenId];
3644         return s.isLlama;
3645     }
3646 
3647     /** ADMIN */
3648     /**
3649      * allows owner to withdraw funds from minting
3650      */
3651     function withdraw() external onlyOwner {
3652         payable(owner()).transfer(address(this).balance);
3653     }
3654 
3655     /**
3656      * updates the number of tokens for sale
3657      */
3658     function setPaidTokens(uint256 _paidTokens) external onlyOwner {
3659         PAID_TOKENS = _paidTokens;
3660     }
3661 
3662     /**
3663      * updates the mint price
3664      */
3665     function setMintPrice(uint256 _mintPrice) external onlyOwner {
3666         MINT_PRICE = _mintPrice;
3667         COMMUNITY_SALE_MINT_PRICE = _mintPrice / 4 * 3;
3668     }
3669 
3670     /**
3671      * enables owner to pause / unpause minting
3672      */
3673     function setPaused(bool _paused) external requireContractsSet onlyOwner {
3674         if (_paused) _pause();
3675         else _unpause();
3676     }
3677 
3678     /** RENDER */
3679 
3680     function tokenURI(uint256 tokenId)
3681         public
3682         view
3683         override(ERC721AUpgradeable, IERC721MetadataUpgradeable)
3684         returns (string memory)
3685     {
3686         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
3687         return traits.tokenURI(tokenId);
3688     }
3689 }
3690 
3691 
3692 // File @openzeppelin/contracts/utils/Context.sol@v4.5.0
3693 
3694 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
3695 
3696 pragma solidity ^0.8.0;
3697 
3698 /**
3699  * @dev Provides information about the current execution context, including the
3700  * sender of the transaction and its data. While these are generally available
3701  * via msg.sender and msg.data, they should not be accessed in such a direct
3702  * manner, since when dealing with meta-transactions the account sending and
3703  * paying for execution may not be the actual sender (as far as an application
3704  * is concerned).
3705  *
3706  * This contract is only required for intermediate, library-like contracts.
3707  */
3708 abstract contract Context {
3709     function _msgSender() internal view virtual returns (address) {
3710         return msg.sender;
3711     }
3712 
3713     function _msgData() internal view virtual returns (bytes calldata) {
3714         return msg.data;
3715     }
3716 }
3717 
3718 
3719 // File @openzeppelin/contracts/access/Ownable.sol@v4.5.0
3720 
3721 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
3722 
3723 pragma solidity ^0.8.0;
3724 
3725 /**
3726  * @dev Contract module which provides a basic access control mechanism, where
3727  * there is an account (an owner) that can be granted exclusive access to
3728  * specific functions.
3729  *
3730  * By default, the owner account will be the one that deploys the contract. This
3731  * can later be changed with {transferOwnership}.
3732  *
3733  * This module is used through inheritance. It will make available the modifier
3734  * `onlyOwner`, which can be applied to your functions to restrict their use to
3735  * the owner.
3736  */
3737 abstract contract Ownable is Context {
3738     address private _owner;
3739 
3740     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
3741 
3742     /**
3743      * @dev Initializes the contract setting the deployer as the initial owner.
3744      */
3745     constructor() {
3746         _transferOwnership(_msgSender());
3747     }
3748 
3749     /**
3750      * @dev Returns the address of the current owner.
3751      */
3752     function owner() public view virtual returns (address) {
3753         return _owner;
3754     }
3755 
3756     /**
3757      * @dev Throws if called by any account other than the owner.
3758      */
3759     modifier onlyOwner() {
3760         require(owner() == _msgSender(), "Ownable: caller is not the owner");
3761         _;
3762     }
3763 
3764     /**
3765      * @dev Leaves the contract without owner. It will not be possible to call
3766      * `onlyOwner` functions anymore. Can only be called by the current owner.
3767      *
3768      * NOTE: Renouncing ownership will leave the contract without an owner,
3769      * thereby removing any functionality that is only available to the owner.
3770      */
3771     function renounceOwnership() public virtual onlyOwner {
3772         _transferOwnership(address(0));
3773     }
3774 
3775     /**
3776      * @dev Transfers ownership of the contract to a new account (`newOwner`).
3777      * Can only be called by the current owner.
3778      */
3779     function transferOwnership(address newOwner) public virtual onlyOwner {
3780         require(newOwner != address(0), "Ownable: new owner is the zero address");
3781         _transferOwnership(newOwner);
3782     }
3783 
3784     /**
3785      * @dev Transfers ownership of the contract to a new account (`newOwner`).
3786      * Internal function without access restriction.
3787      */
3788     function _transferOwnership(address newOwner) internal virtual {
3789         address oldOwner = _owner;
3790         _owner = newOwner;
3791         emit OwnershipTransferred(oldOwner, newOwner);
3792     }
3793 }
3794 
3795 
3796 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v4.5.0
3797 
3798 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
3799 
3800 pragma solidity ^0.8.0;
3801 
3802 /**
3803  * @title ERC721 token receiver interface
3804  * @dev Interface for any contract that wants to support safeTransfers
3805  * from ERC721 asset contracts.
3806  */
3807 interface IERC721Receiver {
3808     /**
3809      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
3810      * by `operator` from `from`, this function is called.
3811      *
3812      * It must return its Solidity selector to confirm the token transfer.
3813      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
3814      *
3815      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
3816      */
3817     function onERC721Received(
3818         address operator,
3819         address from,
3820         uint256 tokenId,
3821         bytes calldata data
3822     ) external returns (bytes4);
3823 }
3824 
3825 
3826 // File @openzeppelin/contracts/security/ReentrancyGuard.sol@v4.5.0
3827 
3828 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
3829 
3830 pragma solidity ^0.8.0;
3831 
3832 /**
3833  * @dev Contract module that helps prevent reentrant calls to a function.
3834  *
3835  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
3836  * available, which can be applied to functions to make sure there are no nested
3837  * (reentrant) calls to them.
3838  *
3839  * Note that because there is a single `nonReentrant` guard, functions marked as
3840  * `nonReentrant` may not call one another. This can be worked around by making
3841  * those functions `private`, and then adding `external` `nonReentrant` entry
3842  * points to them.
3843  *
3844  * TIP: If you would like to learn more about reentrancy and alternative ways
3845  * to protect against it, check out our blog post
3846  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
3847  */
3848 abstract contract ReentrancyGuard {
3849     // Booleans are more expensive than uint256 or any type that takes up a full
3850     // word because each write operation emits an extra SLOAD to first read the
3851     // slot's contents, replace the bits taken up by the boolean, and then write
3852     // back. This is the compiler's defense against contract upgrades and
3853     // pointer aliasing, and it cannot be disabled.
3854 
3855     // The values being non-zero value makes deployment a bit more expensive,
3856     // but in exchange the refund on every call to nonReentrant will be lower in
3857     // amount. Since refunds are capped to a percentage of the total
3858     // transaction's gas, it is best to keep them low in cases like this one, to
3859     // increase the likelihood of the full refund coming into effect.
3860     uint256 private constant _NOT_ENTERED = 1;
3861     uint256 private constant _ENTERED = 2;
3862 
3863     uint256 private _status;
3864 
3865     constructor() {
3866         _status = _NOT_ENTERED;
3867     }
3868 
3869     /**
3870      * @dev Prevents a contract from calling itself, directly or indirectly.
3871      * Calling a `nonReentrant` function from another `nonReentrant`
3872      * function is not supported. It is possible to prevent this from happening
3873      * by making the `nonReentrant` function external, and making it call a
3874      * `private` function that does the actual work.
3875      */
3876     modifier nonReentrant() {
3877         // On the first call to nonReentrant, _notEntered will be true
3878         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
3879 
3880         // Any calls to nonReentrant after this point will fail
3881         _status = _ENTERED;
3882 
3883         _;
3884 
3885         // By storing the original value once again, a refund is triggered (see
3886         // https://eips.ethereum.org/EIPS/eip-2200)
3887         _status = _NOT_ENTERED;
3888     }
3889 }
3890 
3891 
3892 // File @openzeppelin/contracts/security/Pausable.sol@v4.5.0
3893 
3894 // OpenZeppelin Contracts v4.4.1 (security/Pausable.sol)
3895 
3896 pragma solidity ^0.8.0;
3897 
3898 /**
3899  * @dev Contract module which allows children to implement an emergency stop
3900  * mechanism that can be triggered by an authorized account.
3901  *
3902  * This module is used through inheritance. It will make available the
3903  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
3904  * the functions of your contract. Note that they will not be pausable by
3905  * simply including this module, only once the modifiers are put in place.
3906  */
3907 abstract contract Pausable is Context {
3908     /**
3909      * @dev Emitted when the pause is triggered by `account`.
3910      */
3911     event Paused(address account);
3912 
3913     /**
3914      * @dev Emitted when the pause is lifted by `account`.
3915      */
3916     event Unpaused(address account);
3917 
3918     bool private _paused;
3919 
3920     /**
3921      * @dev Initializes the contract in unpaused state.
3922      */
3923     constructor() {
3924         _paused = false;
3925     }
3926 
3927     /**
3928      * @dev Returns true if the contract is paused, and false otherwise.
3929      */
3930     function paused() public view virtual returns (bool) {
3931         return _paused;
3932     }
3933 
3934     /**
3935      * @dev Modifier to make a function callable only when the contract is not paused.
3936      *
3937      * Requirements:
3938      *
3939      * - The contract must not be paused.
3940      */
3941     modifier whenNotPaused() {
3942         require(!paused(), "Pausable: paused");
3943         _;
3944     }
3945 
3946     /**
3947      * @dev Modifier to make a function callable only when the contract is paused.
3948      *
3949      * Requirements:
3950      *
3951      * - The contract must be paused.
3952      */
3953     modifier whenPaused() {
3954         require(paused(), "Pausable: not paused");
3955         _;
3956     }
3957 
3958     /**
3959      * @dev Triggers stopped state.
3960      *
3961      * Requirements:
3962      *
3963      * - The contract must not be paused.
3964      */
3965     function _pause() internal virtual whenNotPaused {
3966         _paused = true;
3967         emit Paused(_msgSender());
3968     }
3969 
3970     /**
3971      * @dev Returns to normal state.
3972      *
3973      * Requirements:
3974      *
3975      * - The contract must be paused.
3976      */
3977     function _unpause() internal virtual whenPaused {
3978         _paused = false;
3979         emit Unpaused(_msgSender());
3980     }
3981 }
3982 
3983 
3984 // File contracts/Staking.sol
3985 
3986 
3987 pragma solidity ^0.8.0;
3988 
3989 
3990 
3991 
3992 
3993 
3994 contract Staking is IStaking, Ownable, ReentrancyGuard, IERC721Receiver, Pausable {
3995   // maximum alpha score for a Dog
3996   uint8 public constant MAX_ALPHA = 8;
3997 
3998   // struct to store a stake's token, owner, and earning values
3999   struct Stake {
4000     uint16 tokenId;
4001     uint80 value;
4002     address owner;
4003   }
4004 
4005   uint256 private totalAlphaStaked;
4006   uint256 public numLlamaStaked;
4007 
4008   event TokenStaked(address indexed owner, uint256 indexed tokenId, bool indexed isLlama, uint256 value);
4009   event LlamaClaimed(uint256 indexed tokenId, bool indexed unstaked, uint256 earned);
4010   event DogClaimed(uint256 indexed tokenId, bool indexed unstaked, uint256 earned);
4011 
4012   // reference to the DiamondHeist NFT contract
4013   IDiamondHeist public game;
4014   // reference to the $DIAMOND contract for minting $DIAMOND earnings
4015   IDIAMOND public diamond;
4016 
4017   // maps tokenId to stake for llamas
4018   mapping(uint256 => Stake) public staking; 
4019   // maps alpha to all Dog stakes with that alpha
4020   mapping(uint256 => Stake[]) public dogStaking; 
4021   // tracks location of each Dog in Staking
4022   mapping(uint256 => uint256) public dogIndices;
4023   // any rewards distributed when no dogs are staked
4024   uint256 public unaccountedRewards = 0; 
4025   // amount of $DIAMOND due for each alpha point staked
4026   uint256 public diamondPerAlpha = 0; 
4027 
4028   // llama earn 100 $DIAMOND per day
4029   uint256 public constant DAILY_DIAMOND_RATE = 100 ether;
4030   // llamas must have 2 days worth of $DIAMOND to unstake or else they're still staked
4031   uint256 public constant MINIMUM_TO_EXIT = 2 days;
4032   // dogs take a 20% tax on all $DIAMOND claimed
4033   uint256 public constant DIAMOND_CLAIM_TAX_PERCENTAGE = 20;
4034   // there will only ever be (roughly) 24 million $DIAMOND earned through staking
4035   uint256 public constant MAXIMUM_GLOBAL_DIAMOND = 24000000 ether;
4036 
4037   // amount of $DIAMOND earned so far
4038   uint256 public totalDiamondEarned;
4039   // the last time $DIAMOND was claimed
4040   uint256 public lastClaimTimestamp;
4041 
4042   // emergency rescue to allow unstaking without any checks but without $DIAMOND
4043   bool public rescueEnabled = false;
4044 
4045   modifier onlyDuringDay {
4046     require((block.timestamp % (6*3600)) > (3*3600), "ONLY DURING DAY");
4047     _;
4048   }
4049 
4050   constructor() {
4051     _pause();
4052   }
4053 
4054   modifier requireContractsSet() {
4055       require(address(game) != address(0) && address(diamond) != address(0), "CONTRACTS NOT SET");
4056       _;
4057   }
4058 
4059   function setContracts(IDiamondHeist _diamondheist, IDIAMOND _diamond) external onlyOwner {
4060     game = _diamondheist;
4061     diamond = _diamond;
4062   }
4063 
4064   /** STAKING */
4065 
4066   /**
4067    * Stakes Llamas and Dogs
4068    * @param account the address of the staker
4069    * @param tokenIds the IDs of the Llamas and Dogs to stake
4070    */
4071   function addManyToStaking(address account, uint16[] calldata tokenIds) external override whenNotPaused nonReentrant {
4072     require(tx.origin == _msgSender() || _msgSender() == address(game), "Only EOA");
4073     require(account == tx.origin, "account to sender mismatch");
4074 
4075     for (uint i = 0; i < tokenIds.length; i++) {
4076       if (tokenIds[i] == 0) {
4077           continue;
4078       }
4079 
4080       if (_msgSender() != address(game)) { // dont do this step if its a mint + stake
4081         require(game.ownerOf(tokenIds[i]) == _msgSender(), "You don't own this token");
4082         game.transferFrom(_msgSender(), address(this), tokenIds[i]);
4083       }
4084 
4085       if (game.isLlama(tokenIds[i])) 
4086         _addLlama(account, tokenIds[i]);
4087       else 
4088         _addDog(account, tokenIds[i]);
4089     }
4090   }
4091 
4092   /**
4093    * adds a single Llamas to the Staking
4094    * @param account the address of the staker
4095    * @param tokenId the ID of the Llamas to add to the Staking
4096    */
4097   function _addLlama(address account, uint256 tokenId) internal whenNotPaused _updateEarnings {
4098     staking[tokenId] = Stake({
4099       owner: account,
4100       tokenId: uint16(tokenId),
4101       value: uint80(block.timestamp)
4102     });
4103     numLlamaStaked += 1;
4104     emit TokenStaked(account, tokenId, true, block.timestamp);
4105   }
4106 
4107   /**
4108    * Stake a Dog
4109    * @param account the address of the staker
4110    * @param tokenId the ID of the Dog to add to Staking
4111    */
4112   function _addDog(address account, uint256 tokenId) internal {
4113     uint256 alpha = _alphaForDog(tokenId);
4114     totalAlphaStaked += alpha; // Portion of earnings ranges from 8 to 5
4115     dogIndices[tokenId] = dogStaking[alpha].length; // Store the location of the dog in the Staking
4116     dogStaking[alpha].push(Stake({
4117       owner: account,
4118       tokenId: uint16(tokenId),
4119       value: uint80(diamondPerAlpha)
4120     })); // Add the dog to the Staking
4121     emit TokenStaked(account, tokenId, false, diamondPerAlpha);
4122   }
4123 
4124   /** CLAIMING / UNSTAKING */
4125 
4126   /**
4127    * realize $DIAMOND earnings and optionally unstake tokens from the Staking / Staking
4128    * to unstake a Llamas it will require it has 2 days worth of $DIAMOND unclaimed
4129    * @param tokenIds the IDs of the tokens to claim earnings from
4130    * @param unstake whether or not to unstake ALL of the tokens listed in tokenIds
4131    */
4132   function claimMany(uint16[] calldata tokenIds, bool unstake) external whenNotPaused _updateEarnings onlyDuringDay nonReentrant {
4133     require(tx.origin == _msgSender() || _msgSender() == address(game), "Only EOA");
4134     uint256 owed = 0;
4135     for (uint i = 0; i < tokenIds.length; i++) {
4136       if (game.isLlama(tokenIds[i]))
4137         owed += _claimLlama(tokenIds[i], unstake);
4138       else
4139         owed += _claimDog(tokenIds[i], unstake);
4140     }
4141     if (owed == 0) return;
4142     diamond.mint(_msgSender(), owed);
4143   }
4144 
4145   /**
4146    * realize $DIAMOND earnings for a single Llamas and optionally unstake it
4147    * if not unstaking, pay a 20% tax to the staked Dogs
4148    * if unstaking, there is a 50% chance all $DIAMOND is stolen
4149    * @param tokenId the ID of the Llamas to claim earnings from
4150    * @param unstake whether or not to unstake the Llamas
4151    * @return owed - the amount of $DIAMOND earned
4152    */
4153   function _claimLlama(uint256 tokenId, bool unstake) internal returns (uint256 owed) {
4154     Stake memory stake = staking[tokenId];
4155     require(stake.owner == _msgSender(), "Don't own the given token");
4156     require(!(unstake && block.timestamp - stake.value < MINIMUM_TO_EXIT), "Wait 2 days to unstake");
4157     if (totalDiamondEarned < MAXIMUM_GLOBAL_DIAMOND) {
4158       owed = (block.timestamp - stake.value) * DAILY_DIAMOND_RATE / 1 days;
4159     } else if (stake.value > lastClaimTimestamp) {
4160       // $DIAMOND production stopped already
4161       owed = 0;
4162     } else {
4163       // stop earning additional $DIAMOND if it's all been earned
4164       owed = (lastClaimTimestamp - stake.value) * DAILY_DIAMOND_RATE / 1 days;
4165     }
4166     if (unstake) {
4167       if (random(tokenId) & 1 == 1) { // 50% chance of all $DIAMOND stolen
4168         _payDogTax(owed);
4169         owed = 0;
4170       }
4171       delete staking[tokenId];
4172       numLlamaStaked -= 1;
4173       // Always transfer last to guard against reentrance
4174       game.safeTransferFrom(address(this), _msgSender(), tokenId, ""); // send back Llamas
4175     } else {
4176       _payDogTax(owed * DIAMOND_CLAIM_TAX_PERCENTAGE / 100); // percentage tax to staked dogs
4177       owed = owed * (100 - DIAMOND_CLAIM_TAX_PERCENTAGE) / 100; // remainder goes to Llamas owner
4178       staking[tokenId] = Stake({
4179         owner: _msgSender(),
4180         tokenId: uint16(tokenId),
4181         value: uint80(block.timestamp)
4182       }); // reset stake
4183     }
4184     emit LlamaClaimed(tokenId, unstake, owed);
4185   }
4186 
4187   /**
4188    * realize $DIAMOND earnings for a single Dog and optionally unstake it
4189    * Dogs earn $DIAMOND proportional to their Alpha rank
4190    * @param tokenId the ID of the Dog to claim earnings from
4191    * @param unstake whether or not to unstake the Dog
4192    * @return owed - the amount of $DIAMOND earned
4193    */
4194   function _claimDog(uint256 tokenId, bool unstake) internal returns (uint256 owed) {
4195     require(game.ownerOf(tokenId) == address(this), "Not staked");
4196     uint256 alpha = _alphaForDog(tokenId);
4197     Stake memory stake = dogStaking[alpha][dogIndices[tokenId]];
4198     require(stake.owner == _msgSender(), "Doesn't own token");
4199     owed = (alpha) * (diamondPerAlpha - stake.value); // Calculate portion of tokens based on Alpha
4200     if (unstake) {
4201       totalAlphaStaked -= alpha; // Remove Alpha from total staked
4202       Stake memory lastStake = dogStaking[alpha][dogStaking[alpha].length - 1];
4203 
4204       dogStaking[alpha][dogIndices[tokenId]] = lastStake; // Shuffle last Dog to current position
4205       dogIndices[lastStake.tokenId] = dogIndices[tokenId];
4206       dogStaking[alpha].pop(); // Remove duplicate
4207       delete dogIndices[tokenId]; // Delete old mapping
4208 
4209       // Always remove last to guard against reentrance
4210       game.safeTransferFrom(address(this), _msgSender(), tokenId, ""); // Send back Dog
4211     } else {
4212       dogStaking[alpha][dogIndices[tokenId]] = Stake({
4213         owner: _msgSender(),
4214         tokenId: uint16(tokenId),
4215         value: uint80(diamondPerAlpha)
4216       }); // reset stake
4217     }
4218     emit DogClaimed(tokenId, unstake, owed);
4219   }
4220 
4221   /**
4222    * emergency unstake tokens
4223    * @param tokenIds the IDs of the tokens to claim earnings from
4224    */
4225   function rescue(uint256[] calldata tokenIds) external nonReentrant {
4226     require(rescueEnabled, "RESCUE DISABLED");
4227     uint256 tokenId;
4228     Stake memory stake;
4229     Stake memory lastStake;
4230     uint256 alpha;
4231     for (uint i = 0; i < tokenIds.length; i++) {
4232       tokenId = tokenIds[i];
4233       if (game.isLlama(tokenId)) {
4234         stake = staking[tokenId];
4235         require(stake.owner == _msgSender(), "SWIPER, NO SWIPING");
4236         delete staking[tokenId];
4237         numLlamaStaked -= 1;
4238         game.safeTransferFrom(address(this), _msgSender(), tokenId, ""); // send back Llamas
4239         emit LlamaClaimed(tokenId, true, 0);
4240       } else {
4241         alpha = _alphaForDog(tokenId);
4242         stake = dogStaking[alpha][dogIndices[tokenId]];
4243         require(stake.owner == _msgSender(), "SWIPER, NO SWIPING");
4244         totalAlphaStaked -= alpha; // Remove Alpha from total staked
4245 
4246         lastStake = dogStaking[alpha][dogStaking[alpha].length - 1];
4247         dogStaking[alpha][dogIndices[tokenId]] = lastStake; // Shuffle last Dog to current position
4248         dogIndices[lastStake.tokenId] = dogIndices[tokenId];
4249         dogStaking[alpha].pop(); // Remove duplicate
4250         delete dogIndices[tokenId]; // Delete old mapping
4251 
4252         game.safeTransferFrom(address(this), _msgSender(), tokenId, ""); // Send back Dog
4253         emit DogClaimed(tokenId, true, 0);
4254       }
4255     }
4256   }
4257 
4258   /** 
4259    * add $DIAMOND to claimable pot for the Staking
4260    * @param amount $DIAMOND to add to the pot
4261    */
4262   function _payDogTax(uint256 amount) internal {
4263     if (totalAlphaStaked == 0) { // if there's no staked dogs
4264       unaccountedRewards += amount; // keep track of $DIAMOND due to dogs
4265       return;
4266     }
4267     // makes sure to include any unaccounted $DIAMOND 
4268     diamondPerAlpha += (amount + unaccountedRewards) / totalAlphaStaked;
4269     unaccountedRewards = 0;
4270   }
4271 
4272   /**
4273    * tracks $DIAMOND earnings to ensure it stops once 2.4 billion is eclipsed
4274    */
4275   modifier _updateEarnings() {
4276     if (totalDiamondEarned < MAXIMUM_GLOBAL_DIAMOND) {
4277       totalDiamondEarned += 
4278         (block.timestamp - lastClaimTimestamp)
4279         * numLlamaStaked
4280         * DAILY_DIAMOND_RATE / 1 days; 
4281       lastClaimTimestamp = block.timestamp;
4282     }
4283     _;
4284   }
4285 
4286   /** ADMIN */
4287 
4288   /**
4289    * allows owner to enable "rescue mode"
4290    * simplifies accounting, prioritizes tokens out in emergency
4291    */
4292   function setRescueEnabled(bool _enabled) external onlyOwner {
4293     rescueEnabled = _enabled;
4294   }
4295 
4296   /**
4297    * enables owner to pause / unpause contract
4298    */
4299   function setPaused(bool _paused) external requireContractsSet onlyOwner {
4300     if (_paused) _pause();
4301     else _unpause();
4302   }
4303 
4304   /** READ ONLY */
4305   /**
4306    * gets the alpha score for a Dog
4307    * @param tokenId the ID of the Dog to get the alpha score for
4308    * @return the alpha score of the Dog (5-8)
4309    */
4310   function _alphaForDog(uint256 tokenId) internal view returns (uint8) {
4311     IDiamondHeist.LlamaDog memory s = game.getTokenTraits(tokenId);
4312     return MAX_ALPHA - s.alphaIndex; // alpha index is 0-3
4313   }
4314 
4315   /**
4316    * generates a pseudorandom number
4317    * @param seed a value ensure different outcomes for different sources in the same block
4318    * @return a pseudorandom value
4319    */
4320   function random(uint256 seed) internal view returns (uint256) {
4321     return uint256(keccak256(abi.encodePacked(
4322       tx.origin,
4323       blockhash(block.number - 1),
4324       block.timestamp,
4325       seed
4326     )));
4327   }
4328 
4329   function onERC721Received(
4330         address,
4331         address from,
4332         uint256,
4333         bytes calldata
4334     ) external pure override returns (bytes4) {
4335       require(from == address(0x0), "Cannot send tokens to Staking directly");
4336       return IERC721Receiver.onERC721Received.selector;
4337     }
4338 
4339 }
4340 
4341 
4342 // File @openzeppelin/contracts/utils/Strings.sol@v4.5.0
4343 
4344 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
4345 
4346 pragma solidity ^0.8.0;
4347 
4348 /**
4349  * @dev String operations.
4350  */
4351 library Strings {
4352     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
4353 
4354     /**
4355      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
4356      */
4357     function toString(uint256 value) internal pure returns (string memory) {
4358         // Inspired by OraclizeAPI's implementation - MIT licence
4359         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
4360 
4361         if (value == 0) {
4362             return "0";
4363         }
4364         uint256 temp = value;
4365         uint256 digits;
4366         while (temp != 0) {
4367             digits++;
4368             temp /= 10;
4369         }
4370         bytes memory buffer = new bytes(digits);
4371         while (value != 0) {
4372             digits -= 1;
4373             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
4374             value /= 10;
4375         }
4376         return string(buffer);
4377     }
4378 
4379     /**
4380      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
4381      */
4382     function toHexString(uint256 value) internal pure returns (string memory) {
4383         if (value == 0) {
4384             return "0x00";
4385         }
4386         uint256 temp = value;
4387         uint256 length = 0;
4388         while (temp != 0) {
4389             length++;
4390             temp >>= 8;
4391         }
4392         return toHexString(value, length);
4393     }
4394 
4395     /**
4396      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
4397      */
4398     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
4399         bytes memory buffer = new bytes(2 * length + 2);
4400         buffer[0] = "0";
4401         buffer[1] = "x";
4402         for (uint256 i = 2 * length + 1; i > 1; --i) {
4403             buffer[i] = _HEX_SYMBOLS[value & 0xf];
4404             value >>= 4;
4405         }
4406         require(value == 0, "Strings: hex length insufficient");
4407         return string(buffer);
4408     }
4409 }
4410 
4411 
4412 // File contracts/Traits.sol
4413 
4414 
4415 pragma solidity ^0.8.0;
4416 
4417 
4418 
4419 
4420 contract Traits is Ownable, ITraits {
4421   using Strings for uint256;
4422 
4423   // struct to store each trait's data for metadata and rendering
4424   struct Trait {
4425     string name;
4426     string png;
4427   }
4428 
4429   // mapping from trait type (index) to its name
4430   string[9] _traitTypes = [
4431     "Body",
4432     "Hat",
4433     "Eye",
4434     "Mouth",
4435     "Clothes",
4436     "Tail",
4437     "Alpha"
4438   ];
4439 
4440   // storage of each traits name and base64 PNG data
4441   mapping(uint8 => mapping(uint8 => Trait)) public traitData;
4442   // mapping from alphaIndex to its score
4443   string[4] _alphas = [
4444     "8",
4445     "7",
4446     "6",
4447     "5"
4448   ];
4449 
4450   IDiamondHeist public diamondheist;
4451 
4452   string private llamaDescription;
4453   string private dogDescription;
4454 
4455   constructor() {}
4456 
4457   /** ADMIN */
4458 
4459   function setGame(address _diamondheist) external onlyOwner {
4460     diamondheist = IDiamondHeist(_diamondheist);
4461   }
4462 
4463   /**
4464    * administrative to upload the names and images associated with each trait
4465    * @param traitType the trait type to upload the traits for (see traitTypes for a mapping)
4466    * @param traits the names and base64 encoded PNGs for each trait
4467    */
4468   function uploadTraits(uint8 traitType, uint8[] calldata traitIds, Trait[] calldata traits) external onlyOwner {
4469     require(traitIds.length == traits.length, "Mismatched inputs");
4470     for (uint i = 0; i < traits.length; i++) {
4471       traitData[traitType][traitIds[i]] = Trait(
4472         traits[i].name,
4473         traits[i].png
4474       );
4475     }
4476   }
4477 
4478   /** RENDER */
4479 
4480   /**
4481    * generates an <image> element using base64 encoded PNGs
4482    * @param trait the trait storing the PNG data
4483    * @return the <image> element
4484    */
4485   function drawTrait(Trait memory trait) internal pure returns (string memory) {
4486     return string(abi.encodePacked(
4487       '<image x="4" y="4" width="32" height="32" image-rendering="pixelated" preserveAspectRatio="xMidYMid" xlink:href="data:image/png;base64,',
4488       trait.png,
4489       '"/>'
4490     ));
4491   }
4492 
4493   /**
4494    * generates an entire SVG by composing multiple <image> elements of PNGs
4495    * @param tokenId the ID of the token to generate an SVG for
4496    * @return a valid SVG of the Llama / Dog
4497    */
4498   function drawSVG(uint256 tokenId) public view returns (string memory) {
4499     IDiamondHeist.LlamaDog memory s = diamondheist.getTokenTraits(tokenId);
4500     uint8 shift = s.isLlama ? 0 : 7;
4501 
4502     string memory svgString = string(abi.encodePacked(
4503       drawTrait(traitData[0 + shift][s.body]),
4504       drawTrait(traitData[1 + shift][s.hat]),
4505       drawTrait(traitData[2 + shift][s.eye]),
4506       drawTrait(traitData[3 + shift][s.mouth]),
4507       drawTrait(traitData[4 + shift][s.clothes]),
4508       drawTrait(traitData[5 + shift][s.tail])
4509     ));
4510 
4511     return string(abi.encodePacked(
4512       '<svg id="diamondheist" width="100%" height="100%" version="1.1" viewBox="0 0 40 40" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">',
4513       svgString,
4514       "</svg>"
4515     ));
4516   }
4517 
4518   /**
4519    * generates an attribute for the attributes array in the ERC721 metadata standard
4520    * @param traitType the trait type to reference as the metadata key
4521    * @param value the token's trait associated with the key
4522    * @return a JSON dictionary for the single attribute
4523    */
4524   function attributeForTypeAndValue(string memory traitType, string memory value) internal pure returns (string memory) {
4525     return string(abi.encodePacked(
4526       '{"trait_type":"',
4527       traitType,
4528       '","value":"',
4529       value,
4530       '"}'
4531     ));
4532   }
4533 
4534   /**
4535    * generates an attribute for the attributes array in the ERC721 metadata standard
4536    * @param traitType the trait type to reference as the metadata key
4537    * @param value the token's trait associated with the key
4538    * @return a JSON dictionary for the single attribute
4539    */
4540   function attributeForTypeAndValueNumber(string memory traitType, string memory value) internal pure returns (string memory) {
4541     return string(abi.encodePacked(
4542       '{"display_type": "number", "trait_type":"',
4543       traitType,
4544       '","value":"',
4545       value,
4546       '"}'
4547     ));
4548   }
4549 
4550   /**
4551    * generates an array composed of all the individual traits and values
4552    * @param tokenId the ID of the token to compose the metadata for
4553    * @return a JSON array of all of the attributes for given token ID
4554    */
4555   function compileAttributes(uint256 tokenId) public view returns (string memory) {
4556     IDiamondHeist.LlamaDog memory s = diamondheist.getTokenTraits(tokenId);
4557     string memory traits;
4558     if (s.isLlama) {
4559       traits = string(abi.encodePacked(
4560         attributeForTypeAndValue(_traitTypes[0], traitData[0][s.body].name),",",
4561         attributeForTypeAndValue(_traitTypes[1], traitData[1][s.hat].name),",",
4562         attributeForTypeAndValue(_traitTypes[2], traitData[2][s.eye].name),",",
4563         attributeForTypeAndValue(_traitTypes[3], traitData[3][s.mouth].name),",",
4564         attributeForTypeAndValue(_traitTypes[4], traitData[4][s.clothes].name),",",
4565         attributeForTypeAndValue(_traitTypes[5], traitData[5][s.tail].name),","
4566         // traitData 6 = alpha score, but not visible
4567       ));
4568     } else {
4569       traits = string(abi.encodePacked(
4570         attributeForTypeAndValue(_traitTypes[0], traitData[7][s.body].name),",",
4571         attributeForTypeAndValue(_traitTypes[1], traitData[8][s.hat].name),",",
4572         attributeForTypeAndValue(_traitTypes[2], traitData[9][s.eye].name),",",
4573         attributeForTypeAndValue(_traitTypes[3], traitData[10][s.mouth].name),",",
4574         attributeForTypeAndValue(_traitTypes[4], traitData[11][s.clothes].name),",",
4575         attributeForTypeAndValue(_traitTypes[5], traitData[12][s.tail].name),",",
4576         attributeForTypeAndValueNumber("Alpha Score", _alphas[s.alphaIndex]),","
4577       ));
4578     }
4579     return string(abi.encodePacked(
4580       '[',
4581       traits,
4582       '{"trait_type":"Generation","value":',
4583       tokenId <= diamondheist.getPaidTokens() ? '"Gen 0"' : '"Gen 1"',
4584       '},{"trait_type":"Type","value":',
4585       s.isLlama ? '"Llama"' : '"Dog"',
4586       '}]'
4587     ));
4588   }
4589 
4590   /**
4591    * generates a base64 encoded metadata response without referencing off-chain content
4592    * @param tokenId the ID of the token to generate the metadata for
4593    * @return a base64 encoded JSON dictionary of the token's metadata and SVG
4594    */
4595   function tokenURI(uint256 tokenId) public view override returns (string memory) {
4596     IDiamondHeist.LlamaDog memory s = diamondheist.getTokenTraits(tokenId);
4597 
4598     string memory metadata = string(abi.encodePacked(
4599       '{"name": "',
4600       s.isLlama ? 'Llama #' : 'Dog #',
4601       tokenId.toString(),
4602       '", "description": "',
4603       s.isLlama ? llamaDescription : dogDescription,
4604       '", "image": "data:image/svg+xml;base64,',
4605       base64(bytes(drawSVG(tokenId))),
4606       '", "attributes":',
4607       compileAttributes(tokenId),
4608       "}"
4609     ));
4610 
4611     return string(abi.encodePacked(
4612       "data:application/json;base64,",
4613       base64(bytes(metadata))
4614     ));
4615   }
4616 
4617   function setDescription(string memory _llama, string memory _dog) external onlyOwner {
4618     llamaDescription = _llama;
4619     dogDescription = _dog;
4620   }
4621 
4622   /** BASE 64 - Written by Brech Devos */
4623   
4624   string internal constant TABLE = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
4625 
4626   function base64(bytes memory data) internal pure returns (string memory) {
4627     if (data.length == 0) return "";
4628     
4629     // load the table into memory
4630     string memory table = TABLE;
4631 
4632     // multiply by 4/3 rounded up
4633     uint256 encodedLen = 4 * ((data.length + 2) / 3);
4634 
4635     // add some extra buffer at the end required for the writing
4636     string memory result = new string(encodedLen + 32);
4637 
4638     assembly {
4639       // set the actual output length
4640       mstore(result, encodedLen)
4641       
4642       // prepare the lookup table
4643       let tablePtr := add(table, 1)
4644       
4645       // input ptr
4646       let dataPtr := data
4647       let endPtr := add(dataPtr, mload(data))
4648       
4649       // result ptr, jump over length
4650       let resultPtr := add(result, 32)
4651       
4652       // run over the input, 3 bytes at a time
4653       for {} lt(dataPtr, endPtr) {}
4654       {
4655           dataPtr := add(dataPtr, 3)
4656           
4657           // read 3 bytes
4658           let input := mload(dataPtr)
4659           
4660           // write 4 characters
4661           mstore(resultPtr, shl(248, mload(add(tablePtr, and(shr(18, input), 0x3F)))))
4662           resultPtr := add(resultPtr, 1)
4663           mstore(resultPtr, shl(248, mload(add(tablePtr, and(shr(12, input), 0x3F)))))
4664           resultPtr := add(resultPtr, 1)
4665           mstore(resultPtr, shl(248, mload(add(tablePtr, and(shr( 6, input), 0x3F)))))
4666           resultPtr := add(resultPtr, 1)
4667           mstore(resultPtr, shl(248, mload(add(tablePtr, and(        input,  0x3F)))))
4668           resultPtr := add(resultPtr, 1)
4669       }
4670       
4671       // padding with '='
4672       switch mod(mload(data), 3)
4673       case 1 { mstore(sub(resultPtr, 2), shl(240, 0x3d3d)) }
4674       case 2 { mstore(sub(resultPtr, 1), shl(248, 0x3d)) }
4675     }
4676     
4677     return result;
4678   }
4679 }