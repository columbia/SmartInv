1 // SPDX-License-Identifier: MIT
2 // File: @openzeppelin/contracts-upgradeable/token/ERC20/IERC20Upgradeable.sol
3 
4 // OpenZeppelin Contracts v4.4.1 (token/ERC20/IERC20.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev Interface of the ERC20 standard as defined in the EIP.
10  */
11 interface IERC20Upgradeable {
12     /**
13      * @dev Returns the amount of tokens in existence.
14      */
15     function totalSupply() external view returns (uint256);
16 
17     /**
18      * @dev Returns the amount of tokens owned by `account`.
19      */
20     function balanceOf(address account) external view returns (uint256);
21 
22     /**
23      * @dev Moves `amount` tokens from the caller's account to `recipient`.
24      *
25      * Returns a boolean value indicating whether the operation succeeded.
26      *
27      * Emits a {Transfer} event.
28      */
29     function transfer(address recipient, uint256 amount) external returns (bool);
30 
31     /**
32      * @dev Returns the remaining number of tokens that `spender` will be
33      * allowed to spend on behalf of `owner` through {transferFrom}. This is
34      * zero by default.
35      *
36      * This value changes when {approve} or {transferFrom} are called.
37      */
38     function allowance(address owner, address spender) external view returns (uint256);
39 
40     /**
41      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
42      *
43      * Returns a boolean value indicating whether the operation succeeded.
44      *
45      * IMPORTANT: Beware that changing an allowance with this method brings the risk
46      * that someone may use both the old and the new allowance by unfortunate
47      * transaction ordering. One possible solution to mitigate this race
48      * condition is to first reduce the spender's allowance to 0 and set the
49      * desired value afterwards:
50      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
51      *
52      * Emits an {Approval} event.
53      */
54     function approve(address spender, uint256 amount) external returns (bool);
55 
56     /**
57      * @dev Moves `amount` tokens from `sender` to `recipient` using the
58      * allowance mechanism. `amount` is then deducted from the caller's
59      * allowance.
60      *
61      * Returns a boolean value indicating whether the operation succeeded.
62      *
63      * Emits a {Transfer} event.
64      */
65     function transferFrom(
66         address sender,
67         address recipient,
68         uint256 amount
69     ) external returns (bool);
70 
71     /**
72      * @dev Emitted when `value` tokens are moved from one account (`from`) to
73      * another (`to`).
74      *
75      * Note that `value` may be zero.
76      */
77     event Transfer(address indexed from, address indexed to, uint256 value);
78 
79     /**
80      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
81      * a call to {approve}. `value` is the new allowance.
82      */
83     event Approval(address indexed owner, address indexed spender, uint256 value);
84 }
85 
86 // File: @openzeppelin/contracts-upgradeable/token/ERC20/extensions/IERC20MetadataUpgradeable.sol
87 
88 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
89 
90 pragma solidity ^0.8.0;
91 
92 /**
93  * @dev Interface for the optional metadata functions from the ERC20 standard.
94  *
95  * _Available since v4.1._
96  */
97 interface IERC20MetadataUpgradeable is IERC20Upgradeable {
98     /**
99      * @dev Returns the name of the token.
100      */
101     function name() external view returns (string memory);
102 
103     /**
104      * @dev Returns the symbol of the token.
105      */
106     function symbol() external view returns (string memory);
107 
108     /**
109      * @dev Returns the decimals places of the token.
110      */
111     function decimals() external view returns (uint8);
112 }
113 
114 // File: @openzeppelin/contracts-upgradeable/utils/AddressUpgradeable.sol
115 
116 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
117 
118 pragma solidity ^0.8.0;
119 
120 /**
121  * @dev Collection of functions related to the address type
122  */
123 library AddressUpgradeable {
124     /**
125      * @dev Returns true if `account` is a contract.
126      *
127      * [IMPORTANT]
128      * ====
129      * It is unsafe to assume that an address for which this function returns
130      * false is an externally-owned account (EOA) and not a contract.
131      *
132      * Among others, `isContract` will return false for the following
133      * types of addresses:
134      *
135      *  - an externally-owned account
136      *  - a contract in construction
137      *  - an address where a contract will be created
138      *  - an address where a contract lived, but was destroyed
139      * ====
140      */
141     function isContract(address account) internal view returns (bool) {
142         // This method relies on extcodesize, which returns 0 for contracts in
143         // construction, since the code is only stored at the end of the
144         // constructor execution.
145 
146         uint256 size;
147         assembly {
148             size := extcodesize(account)
149         }
150         return size > 0;
151     }
152 
153     /**
154      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
155      * `recipient`, forwarding all available gas and reverting on errors.
156      *
157      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
158      * of certain opcodes, possibly making contracts go over the 2300 gas limit
159      * imposed by `transfer`, making them unable to receive funds via
160      * `transfer`. {sendValue} removes this limitation.
161      *
162      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
163      *
164      * IMPORTANT: because control is transferred to `recipient`, care must be
165      * taken to not create reentrancy vulnerabilities. Consider using
166      * {ReentrancyGuard} or the
167      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
168      */
169     function sendValue(address payable recipient, uint256 amount) internal {
170         require(address(this).balance >= amount, "Address: insufficient balance");
171 
172         (bool success, ) = recipient.call{value: amount}("");
173         require(success, "Address: unable to send value, recipient may have reverted");
174     }
175 
176     /**
177      * @dev Performs a Solidity function call using a low level `call`. A
178      * plain `call` is an unsafe replacement for a function call: use this
179      * function instead.
180      *
181      * If `target` reverts with a revert reason, it is bubbled up by this
182      * function (like regular Solidity function calls).
183      *
184      * Returns the raw returned data. To convert to the expected return value,
185      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
186      *
187      * Requirements:
188      *
189      * - `target` must be a contract.
190      * - calling `target` with `data` must not revert.
191      *
192      * _Available since v3.1._
193      */
194     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
195         return functionCall(target, data, "Address: low-level call failed");
196     }
197 
198     /**
199      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
200      * `errorMessage` as a fallback revert reason when `target` reverts.
201      *
202      * _Available since v3.1._
203      */
204     function functionCall(
205         address target,
206         bytes memory data,
207         string memory errorMessage
208     ) internal returns (bytes memory) {
209         return functionCallWithValue(target, data, 0, errorMessage);
210     }
211 
212     /**
213      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
214      * but also transferring `value` wei to `target`.
215      *
216      * Requirements:
217      *
218      * - the calling contract must have an ETH balance of at least `value`.
219      * - the called Solidity function must be `payable`.
220      *
221      * _Available since v3.1._
222      */
223     function functionCallWithValue(
224         address target,
225         bytes memory data,
226         uint256 value
227     ) internal returns (bytes memory) {
228         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
229     }
230 
231     /**
232      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
233      * with `errorMessage` as a fallback revert reason when `target` reverts.
234      *
235      * _Available since v3.1._
236      */
237     function functionCallWithValue(
238         address target,
239         bytes memory data,
240         uint256 value,
241         string memory errorMessage
242     ) internal returns (bytes memory) {
243         require(address(this).balance >= value, "Address: insufficient balance for call");
244         require(isContract(target), "Address: call to non-contract");
245 
246         (bool success, bytes memory returndata) = target.call{value: value}(data);
247         return verifyCallResult(success, returndata, errorMessage);
248     }
249 
250     /**
251      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
252      * but performing a static call.
253      *
254      * _Available since v3.3._
255      */
256     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
257         return functionStaticCall(target, data, "Address: low-level static call failed");
258     }
259 
260     /**
261      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
262      * but performing a static call.
263      *
264      * _Available since v3.3._
265      */
266     function functionStaticCall(
267         address target,
268         bytes memory data,
269         string memory errorMessage
270     ) internal view returns (bytes memory) {
271         require(isContract(target), "Address: static call to non-contract");
272 
273         (bool success, bytes memory returndata) = target.staticcall(data);
274         return verifyCallResult(success, returndata, errorMessage);
275     }
276 
277     /**
278      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
279      * revert reason using the provided one.
280      *
281      * _Available since v4.3._
282      */
283     function verifyCallResult(
284         bool success,
285         bytes memory returndata,
286         string memory errorMessage
287     ) internal pure returns (bytes memory) {
288         if (success) {
289             return returndata;
290         } else {
291             // Look for revert reason and bubble it up if present
292             if (returndata.length > 0) {
293                 // The easiest way to bubble the revert reason is using memory via assembly
294 
295                 assembly {
296                     let returndata_size := mload(returndata)
297                     revert(add(32, returndata), returndata_size)
298                 }
299             } else {
300                 revert(errorMessage);
301             }
302         }
303     }
304 }
305 
306 // File: @openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol
307 
308 // OpenZeppelin Contracts v4.4.1 (proxy/utils/Initializable.sol)
309 
310 pragma solidity ^0.8.0;
311 
312 /**
313  * @dev This is a base contract to aid in writing upgradeable contracts, or any kind of contract that will be deployed
314  * behind a proxy. Since a proxied contract can't have a constructor, it's common to move constructor logic to an
315  * external initializer function, usually called `initialize`. It then becomes necessary to protect this initializer
316  * function so it can only be called once. The {initializer} modifier provided by this contract will have this effect.
317  *
318  * TIP: To avoid leaving the proxy in an uninitialized state, the initializer function should be called as early as
319  * possible by providing the encoded function call as the `_data` argument to {ERC1967Proxy-constructor}.
320  *
321  * CAUTION: When used with inheritance, manual care must be taken to not invoke a parent initializer twice, or to ensure
322  * that all initializers are idempotent. This is not verified automatically as constructors are by Solidity.
323  *
324  * [CAUTION]
325  * ====
326  * Avoid leaving a contract uninitialized.
327  *
328  * An uninitialized contract can be taken over by an attacker. This applies to both a proxy and its implementation
329  * contract, which may impact the proxy. To initialize the implementation contract, you can either invoke the
330  * initializer manually, or you can include a constructor to automatically mark it as initialized when it is deployed:
331  *
332  * [.hljs-theme-light.nopadding]
333  * ```
334  * /// @custom:oz-upgrades-unsafe-allow constructor
335  * constructor() initializer {}
336  * ```
337  * ====
338  */
339 abstract contract Initializable {
340     /**
341      * @dev Indicates that the contract has been initialized.
342      */
343     bool private _initialized;
344 
345     /**
346      * @dev Indicates that the contract is in the process of being initialized.
347      */
348     bool private _initializing;
349 
350     /**
351      * @dev Modifier to protect an initializer function from being invoked twice.
352      */
353     modifier initializer() {
354         // If the contract is initializing we ignore whether _initialized is set in order to support multiple
355         // inheritance patterns, but we only do this in the context of a constructor, because in other contexts the
356         // contract may have been reentered.
357         require(_initializing ? _isConstructor() : !_initialized, "Initializable: contract is already initialized");
358 
359         bool isTopLevelCall = !_initializing;
360         if (isTopLevelCall) {
361             _initializing = true;
362             _initialized = true;
363         }
364 
365         _;
366 
367         if (isTopLevelCall) {
368             _initializing = false;
369         }
370     }
371 
372     /**
373      * @dev Modifier to protect an initialization function so that it can only be invoked by functions with the
374      * {initializer} modifier, directly or indirectly.
375      */
376     modifier onlyInitializing() {
377         require(_initializing, "Initializable: contract is not initializing");
378         _;
379     }
380 
381     function _isConstructor() private view returns (bool) {
382         return !AddressUpgradeable.isContract(address(this));
383     }
384 }
385 
386 // File: @openzeppelin/contracts-upgradeable/utils/ContextUpgradeable.sol
387 
388 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
389 
390 pragma solidity ^0.8.0;
391 
392 /**
393  * @dev Provides information about the current execution context, including the
394  * sender of the transaction and its data. While these are generally available
395  * via msg.sender and msg.data, they should not be accessed in such a direct
396  * manner, since when dealing with meta-transactions the account sending and
397  * paying for execution may not be the actual sender (as far as an application
398  * is concerned).
399  *
400  * This contract is only required for intermediate, library-like contracts.
401  */
402 abstract contract ContextUpgradeable is Initializable {
403     function __Context_init() internal onlyInitializing {
404         __Context_init_unchained();
405     }
406 
407     function __Context_init_unchained() internal onlyInitializing {
408     }
409     function _msgSender() internal view virtual returns (address) {
410         return msg.sender;
411     }
412 
413     function _msgData() internal view virtual returns (bytes calldata) {
414         return msg.data;
415     }
416     uint256[50] private __gap;
417 }
418 
419 // File: @openzeppelin/contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol
420 
421 // OpenZeppelin Contracts v4.4.1 (token/ERC20/ERC20.sol)
422 
423 pragma solidity ^0.8.0;
424 
425 
426 
427 
428 /**
429  * @dev Implementation of the {IERC20} interface.
430  *
431  * This implementation is agnostic to the way tokens are created. This means
432  * that a supply mechanism has to be added in a derived contract using {_mint}.
433  * For a generic mechanism see {ERC20PresetMinterPauser}.
434  *
435  * TIP: For a detailed writeup see our guide
436  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
437  * to implement supply mechanisms].
438  *
439  * We have followed general OpenZeppelin Contracts guidelines: functions revert
440  * instead returning `false` on failure. This behavior is nonetheless
441  * conventional and does not conflict with the expectations of ERC20
442  * applications.
443  *
444  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
445  * This allows applications to reconstruct the allowance for all accounts just
446  * by listening to said events. Other implementations of the EIP may not emit
447  * these events, as it isn't required by the specification.
448  *
449  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
450  * functions have been added to mitigate the well-known issues around setting
451  * allowances. See {IERC20-approve}.
452  */
453 contract ERC20Upgradeable is Initializable, ContextUpgradeable, IERC20Upgradeable, IERC20MetadataUpgradeable {
454     mapping(address => uint256) private _balances;
455 
456     mapping(address => mapping(address => uint256)) private _allowances;
457 
458     uint256 private _totalSupply;
459 
460     string private _name;
461     string private _symbol;
462 
463     /**
464      * @dev Sets the values for {name} and {symbol}.
465      *
466      * The default value of {decimals} is 18. To select a different value for
467      * {decimals} you should overload it.
468      *
469      * All two of these values are immutable: they can only be set once during
470      * construction.
471      */
472     function __ERC20_init(string memory name_, string memory symbol_) internal onlyInitializing {
473         __Context_init_unchained();
474         __ERC20_init_unchained(name_, symbol_);
475     }
476 
477     function __ERC20_init_unchained(string memory name_, string memory symbol_) internal onlyInitializing {
478         _name = name_;
479         _symbol = symbol_;
480     }
481 
482     /**
483      * @dev Returns the name of the token.
484      */
485     function name() public view virtual override returns (string memory) {
486         return _name;
487     }
488 
489     /**
490      * @dev Returns the symbol of the token, usually a shorter version of the
491      * name.
492      */
493     function symbol() public view virtual override returns (string memory) {
494         return _symbol;
495     }
496 
497     /**
498      * @dev Returns the number of decimals used to get its user representation.
499      * For example, if `decimals` equals `2`, a balance of `505` tokens should
500      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
501      *
502      * Tokens usually opt for a value of 18, imitating the relationship between
503      * Ether and Wei. This is the value {ERC20} uses, unless this function is
504      * overridden;
505      *
506      * NOTE: This information is only used for _display_ purposes: it in
507      * no way affects any of the arithmetic of the contract, including
508      * {IERC20-balanceOf} and {IERC20-transfer}.
509      */
510     function decimals() public view virtual override returns (uint8) {
511         return 18;
512     }
513 
514     /**
515      * @dev See {IERC20-totalSupply}.
516      */
517     function totalSupply() public view virtual override returns (uint256) {
518         return _totalSupply;
519     }
520 
521     /**
522      * @dev See {IERC20-balanceOf}.
523      */
524     function balanceOf(address account) public view virtual override returns (uint256) {
525         return _balances[account];
526     }
527 
528     /**
529      * @dev See {IERC20-transfer}.
530      *
531      * Requirements:
532      *
533      * - `recipient` cannot be the zero address.
534      * - the caller must have a balance of at least `amount`.
535      */
536     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
537         _transfer(_msgSender(), recipient, amount);
538         return true;
539     }
540 
541     /**
542      * @dev See {IERC20-allowance}.
543      */
544     function allowance(address owner, address spender) public view virtual override returns (uint256) {
545         return _allowances[owner][spender];
546     }
547 
548     /**
549      * @dev See {IERC20-approve}.
550      *
551      * Requirements:
552      *
553      * - `spender` cannot be the zero address.
554      */
555     function approve(address spender, uint256 amount) public virtual override returns (bool) {
556         _approve(_msgSender(), spender, amount);
557         return true;
558     }
559 
560     /**
561      * @dev See {IERC20-transferFrom}.
562      *
563      * Emits an {Approval} event indicating the updated allowance. This is not
564      * required by the EIP. See the note at the beginning of {ERC20}.
565      *
566      * Requirements:
567      *
568      * - `sender` and `recipient` cannot be the zero address.
569      * - `sender` must have a balance of at least `amount`.
570      * - the caller must have allowance for ``sender``'s tokens of at least
571      * `amount`.
572      */
573     function transferFrom(
574         address sender,
575         address recipient,
576         uint256 amount
577     ) public virtual override returns (bool) {
578         _transfer(sender, recipient, amount);
579 
580         uint256 currentAllowance = _allowances[sender][_msgSender()];
581         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
582         unchecked {
583             _approve(sender, _msgSender(), currentAllowance - amount);
584         }
585 
586         return true;
587     }
588 
589     /**
590      * @dev Atomically increases the allowance granted to `spender` by the caller.
591      *
592      * This is an alternative to {approve} that can be used as a mitigation for
593      * problems described in {IERC20-approve}.
594      *
595      * Emits an {Approval} event indicating the updated allowance.
596      *
597      * Requirements:
598      *
599      * - `spender` cannot be the zero address.
600      */
601     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
602         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
603         return true;
604     }
605 
606     /**
607      * @dev Atomically decreases the allowance granted to `spender` by the caller.
608      *
609      * This is an alternative to {approve} that can be used as a mitigation for
610      * problems described in {IERC20-approve}.
611      *
612      * Emits an {Approval} event indicating the updated allowance.
613      *
614      * Requirements:
615      *
616      * - `spender` cannot be the zero address.
617      * - `spender` must have allowance for the caller of at least
618      * `subtractedValue`.
619      */
620     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
621         uint256 currentAllowance = _allowances[_msgSender()][spender];
622         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
623         unchecked {
624             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
625         }
626 
627         return true;
628     }
629 
630     /**
631      * @dev Moves `amount` of tokens from `sender` to `recipient`.
632      *
633      * This internal function is equivalent to {transfer}, and can be used to
634      * e.g. implement automatic token fees, slashing mechanisms, etc.
635      *
636      * Emits a {Transfer} event.
637      *
638      * Requirements:
639      *
640      * - `sender` cannot be the zero address.
641      * - `recipient` cannot be the zero address.
642      * - `sender` must have a balance of at least `amount`.
643      */
644     function _transfer(
645         address sender,
646         address recipient,
647         uint256 amount
648     ) internal virtual {
649         require(sender != address(0), "ERC20: transfer from the zero address");
650         require(recipient != address(0), "ERC20: transfer to the zero address");
651 
652         _beforeTokenTransfer(sender, recipient, amount);
653 
654         uint256 senderBalance = _balances[sender];
655         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
656         unchecked {
657             _balances[sender] = senderBalance - amount;
658         }
659         _balances[recipient] += amount;
660 
661         emit Transfer(sender, recipient, amount);
662 
663         _afterTokenTransfer(sender, recipient, amount);
664     }
665 
666     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
667      * the total supply.
668      *
669      * Emits a {Transfer} event with `from` set to the zero address.
670      *
671      * Requirements:
672      *
673      * - `account` cannot be the zero address.
674      */
675     function _mint(address account, uint256 amount) internal virtual {
676         require(account != address(0), "ERC20: mint to the zero address");
677 
678         _beforeTokenTransfer(address(0), account, amount);
679 
680         _totalSupply += amount;
681         _balances[account] += amount;
682         emit Transfer(address(0), account, amount);
683 
684         _afterTokenTransfer(address(0), account, amount);
685     }
686 
687     /**
688      * @dev Destroys `amount` tokens from `account`, reducing the
689      * total supply.
690      *
691      * Emits a {Transfer} event with `to` set to the zero address.
692      *
693      * Requirements:
694      *
695      * - `account` cannot be the zero address.
696      * - `account` must have at least `amount` tokens.
697      */
698     function _burn(address account, uint256 amount) internal virtual {
699         require(account != address(0), "ERC20: burn from the zero address");
700 
701         _beforeTokenTransfer(account, address(0), amount);
702 
703         uint256 accountBalance = _balances[account];
704         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
705         unchecked {
706             _balances[account] = accountBalance - amount;
707         }
708         _totalSupply -= amount;
709 
710         emit Transfer(account, address(0), amount);
711 
712         _afterTokenTransfer(account, address(0), amount);
713     }
714 
715     /**
716      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
717      *
718      * This internal function is equivalent to `approve`, and can be used to
719      * e.g. set automatic allowances for certain subsystems, etc.
720      *
721      * Emits an {Approval} event.
722      *
723      * Requirements:
724      *
725      * - `owner` cannot be the zero address.
726      * - `spender` cannot be the zero address.
727      */
728     function _approve(
729         address owner,
730         address spender,
731         uint256 amount
732     ) internal virtual {
733         require(owner != address(0), "ERC20: approve from the zero address");
734         require(spender != address(0), "ERC20: approve to the zero address");
735 
736         _allowances[owner][spender] = amount;
737         emit Approval(owner, spender, amount);
738     }
739 
740     /**
741      * @dev Hook that is called before any transfer of tokens. This includes
742      * minting and burning.
743      *
744      * Calling conditions:
745      *
746      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
747      * will be transferred to `to`.
748      * - when `from` is zero, `amount` tokens will be minted for `to`.
749      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
750      * - `from` and `to` are never both zero.
751      *
752      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
753      */
754     function _beforeTokenTransfer(
755         address from,
756         address to,
757         uint256 amount
758     ) internal virtual {}
759 
760     /**
761      * @dev Hook that is called after any transfer of tokens. This includes
762      * minting and burning.
763      *
764      * Calling conditions:
765      *
766      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
767      * has been transferred to `to`.
768      * - when `from` is zero, `amount` tokens have been minted for `to`.
769      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
770      * - `from` and `to` are never both zero.
771      *
772      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
773      */
774     function _afterTokenTransfer(
775         address from,
776         address to,
777         uint256 amount
778     ) internal virtual {}
779     uint256[45] private __gap;
780 }
781 
782 // File: @openzeppelin/contracts-upgradeable/token/ERC20/utils/SafeERC20Upgradeable.sol
783 
784 // OpenZeppelin Contracts v4.4.1 (token/ERC20/utils/SafeERC20.sol)
785 
786 pragma solidity ^0.8.0;
787 
788 
789 /**
790  * @title SafeERC20
791  * @dev Wrappers around ERC20 operations that throw on failure (when the token
792  * contract returns false). Tokens that return no value (and instead revert or
793  * throw on failure) are also supported, non-reverting calls are assumed to be
794  * successful.
795  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
796  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
797  */
798 library SafeERC20Upgradeable {
799     using AddressUpgradeable for address;
800 
801     function safeTransfer(
802         IERC20Upgradeable token,
803         address to,
804         uint256 value
805     ) internal {
806         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
807     }
808 
809     function safeTransferFrom(
810         IERC20Upgradeable token,
811         address from,
812         address to,
813         uint256 value
814     ) internal {
815         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
816     }
817 
818     /**
819      * @dev Deprecated. This function has issues similar to the ones found in
820      * {IERC20-approve}, and its usage is discouraged.
821      *
822      * Whenever possible, use {safeIncreaseAllowance} and
823      * {safeDecreaseAllowance} instead.
824      */
825     function safeApprove(
826         IERC20Upgradeable token,
827         address spender,
828         uint256 value
829     ) internal {
830         // safeApprove should only be called when setting an initial allowance,
831         // or when resetting it to zero. To increase and decrease it, use
832         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
833         require(
834             (value == 0) || (token.allowance(address(this), spender) == 0),
835             "SafeERC20: approve from non-zero to non-zero allowance"
836         );
837         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
838     }
839 
840     function safeIncreaseAllowance(
841         IERC20Upgradeable token,
842         address spender,
843         uint256 value
844     ) internal {
845         uint256 newAllowance = token.allowance(address(this), spender) + value;
846         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
847     }
848 
849     function safeDecreaseAllowance(
850         IERC20Upgradeable token,
851         address spender,
852         uint256 value
853     ) internal {
854         unchecked {
855             uint256 oldAllowance = token.allowance(address(this), spender);
856             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
857             uint256 newAllowance = oldAllowance - value;
858             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
859         }
860     }
861 
862     /**
863      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
864      * on the return value: the return value is optional (but if data is returned, it must not be false).
865      * @param token The token targeted by the call.
866      * @param data The call data (encoded using abi.encode or one of its variants).
867      */
868     function _callOptionalReturn(IERC20Upgradeable token, bytes memory data) private {
869         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
870         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
871         // the target address contains contract code and also asserts for success in the low-level call.
872 
873         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
874         if (returndata.length > 0) {
875             // Return data is optional
876             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
877         }
878     }
879 }
880 
881 // File: @openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol
882 
883 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
884 
885 pragma solidity ^0.8.0;
886 
887 
888 /**
889  * @dev Contract module which provides a basic access control mechanism, where
890  * there is an account (an owner) that can be granted exclusive access to
891  * specific functions.
892  *
893  * By default, the owner account will be the one that deploys the contract. This
894  * can later be changed with {transferOwnership}.
895  *
896  * This module is used through inheritance. It will make available the modifier
897  * `onlyOwner`, which can be applied to your functions to restrict their use to
898  * the owner.
899  */
900 abstract contract OwnableUpgradeable is Initializable, ContextUpgradeable {
901     address private _owner;
902 
903     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
904 
905     /**
906      * @dev Initializes the contract setting the deployer as the initial owner.
907      */
908     function __Ownable_init() internal onlyInitializing {
909         __Context_init_unchained();
910         __Ownable_init_unchained();
911     }
912 
913     function __Ownable_init_unchained() internal onlyInitializing {
914         _transferOwnership(_msgSender());
915     }
916 
917     /**
918      * @dev Returns the address of the current owner.
919      */
920     function owner() public view virtual returns (address) {
921         return _owner;
922     }
923 
924     /**
925      * @dev Throws if called by any account other than the owner.
926      */
927     modifier onlyOwner() {
928         require(owner() == _msgSender(), "Ownable: caller is not the owner");
929         _;
930     }
931 
932     /**
933      * @dev Leaves the contract without owner. It will not be possible to call
934      * `onlyOwner` functions anymore. Can only be called by the current owner.
935      *
936      * NOTE: Renouncing ownership will leave the contract without an owner,
937      * thereby removing any functionality that is only available to the owner.
938      */
939     function renounceOwnership() public virtual onlyOwner {
940         _transferOwnership(address(0));
941     }
942 
943     /**
944      * @dev Transfers ownership of the contract to a new account (`newOwner`).
945      * Can only be called by the current owner.
946      */
947     function transferOwnership(address newOwner) public virtual onlyOwner {
948         require(newOwner != address(0), "Ownable: new owner is the zero address");
949         _transferOwnership(newOwner);
950     }
951 
952     /**
953      * @dev Transfers ownership of the contract to a new account (`newOwner`).
954      * Internal function without access restriction.
955      */
956     function _transferOwnership(address newOwner) internal virtual {
957         address oldOwner = _owner;
958         _owner = newOwner;
959         emit OwnershipTransferred(oldOwner, newOwner);
960     }
961     uint256[49] private __gap;
962 }
963 
964 // File: @openzeppelin/contracts-upgradeable/security/ReentrancyGuardUpgradeable.sol
965 
966 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
967 
968 pragma solidity ^0.8.0;
969 
970 /**
971  * @dev Contract module that helps prevent reentrant calls to a function.
972  *
973  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
974  * available, which can be applied to functions to make sure there are no nested
975  * (reentrant) calls to them.
976  *
977  * Note that because there is a single `nonReentrant` guard, functions marked as
978  * `nonReentrant` may not call one another. This can be worked around by making
979  * those functions `private`, and then adding `external` `nonReentrant` entry
980  * points to them.
981  *
982  * TIP: If you would like to learn more about reentrancy and alternative ways
983  * to protect against it, check out our blog post
984  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
985  */
986 abstract contract ReentrancyGuardUpgradeable is Initializable {
987     // Booleans are more expensive than uint256 or any type that takes up a full
988     // word because each write operation emits an extra SLOAD to first read the
989     // slot's contents, replace the bits taken up by the boolean, and then write
990     // back. This is the compiler's defense against contract upgrades and
991     // pointer aliasing, and it cannot be disabled.
992 
993     // The values being non-zero value makes deployment a bit more expensive,
994     // but in exchange the refund on every call to nonReentrant will be lower in
995     // amount. Since refunds are capped to a percentage of the total
996     // transaction's gas, it is best to keep them low in cases like this one, to
997     // increase the likelihood of the full refund coming into effect.
998     uint256 private constant _NOT_ENTERED = 1;
999     uint256 private constant _ENTERED = 2;
1000 
1001     uint256 private _status;
1002 
1003     function __ReentrancyGuard_init() internal onlyInitializing {
1004         __ReentrancyGuard_init_unchained();
1005     }
1006 
1007     function __ReentrancyGuard_init_unchained() internal onlyInitializing {
1008         _status = _NOT_ENTERED;
1009     }
1010 
1011     /**
1012      * @dev Prevents a contract from calling itself, directly or indirectly.
1013      * Calling a `nonReentrant` function from another `nonReentrant`
1014      * function is not supported. It is possible to prevent this from happening
1015      * by making the `nonReentrant` function external, and making it call a
1016      * `private` function that does the actual work.
1017      */
1018     modifier nonReentrant() {
1019         // On the first call to nonReentrant, _notEntered will be true
1020         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1021 
1022         // Any calls to nonReentrant after this point will fail
1023         _status = _ENTERED;
1024 
1025         _;
1026 
1027         // By storing the original value once again, a refund is triggered (see
1028         // https://eips.ethereum.org/EIPS/eip-2200)
1029         _status = _NOT_ENTERED;
1030     }
1031     uint256[49] private __gap;
1032 }
1033 
1034 // File: contracts/BIFI/interfaces/beefy/IStrategyV7.sol
1035 
1036 
1037 pragma solidity ^0.8.0;
1038 interface IStrategyV7 {
1039     function vault() external view returns (address);
1040     function want() external view returns (IERC20Upgradeable);
1041     function beforeDeposit() external;
1042     function deposit() external;
1043     function withdraw(uint256) external;
1044     function balanceOf() external view returns (uint256);
1045     function balanceOfWant() external view returns (uint256);
1046     function balanceOfPool() external view returns (uint256);
1047     function harvest() external;
1048     function retireStrat() external;
1049     function panic() external;
1050     function pause() external;
1051     function unpause() external;
1052     function paused() external view returns (bool);
1053     function unirouter() external view returns (address);
1054 }
1055 
1056 // File: contracts/BIFI/vaults/BeefyVaultV7.sol
1057 
1058 
1059 pragma solidity ^0.8.0;
1060 /**
1061  * @dev Implementation of a vault to deposit funds for yield optimizing.
1062  * This is the contract that receives funds and that users interface with.
1063  * The yield optimizing strategy itself is implemented in a separate 'Strategy.sol' contract.
1064  */
1065 contract BeefyVaultV7 is ERC20Upgradeable, OwnableUpgradeable, ReentrancyGuardUpgradeable {
1066     using SafeERC20Upgradeable for IERC20Upgradeable;
1067 
1068     struct StratCandidate {
1069         address implementation;
1070         uint proposedTime;
1071     }
1072 
1073     // The last proposed strategy to switch to.
1074     StratCandidate public stratCandidate;
1075     // The strategy currently in use by the vault.
1076     IStrategyV7 public strategy;
1077     // The minimum time it has to pass before a strat candidate can be approved.
1078     uint256 public approvalDelay;
1079 
1080     event NewStratCandidate(address implementation);
1081     event UpgradeStrat(address implementation);
1082 
1083     /**
1084      * @dev Sets the value of {token} to the token that the vault will
1085      * hold as underlying value. It initializes the vault's own 'moo' token.
1086      * This token is minted when someone does a deposit. It is burned in order
1087      * to withdraw the corresponding portion of the underlying assets.
1088      * @param _strategy the address of the strategy.
1089      * @param _name the name of the vault token.
1090      * @param _symbol the symbol of the vault token.
1091      * @param _approvalDelay the delay before a new strat can be approved.
1092      */
1093      function initialize(
1094         IStrategyV7 _strategy,
1095         string memory _name,
1096         string memory _symbol,
1097         uint256 _approvalDelay
1098     ) public initializer {
1099         __ERC20_init(_name, _symbol);
1100         __Ownable_init();
1101         __ReentrancyGuard_init();
1102         strategy = _strategy;
1103         approvalDelay = _approvalDelay;
1104     }
1105 
1106     function want() public view returns (IERC20Upgradeable) {
1107         return IERC20Upgradeable(strategy.want());
1108     }
1109 
1110     /**
1111      * @dev It calculates the total underlying value of {token} held by the system.
1112      * It takes into account the vault contract balance, the strategy contract balance
1113      *  and the balance deployed in other contracts as part of the strategy.
1114      */
1115     function balance() public view returns (uint) {
1116         return want().balanceOf(address(this)) + IStrategyV7(strategy).balanceOf();
1117     }
1118 
1119     /**
1120      * @dev Custom logic in here for how much the vault allows to be borrowed.
1121      * We return 100% of tokens for now. Under certain conditions we might
1122      * want to keep some of the system funds at hand in the vault, instead
1123      * of putting them to work.
1124      */
1125     function available() public view returns (uint256) {
1126         return want().balanceOf(address(this));
1127     }
1128 
1129     /**
1130      * @dev Function for various UIs to display the current value of one of our yield tokens.
1131      * Returns an uint256 with 18 decimals of how much underlying asset one vault share represents.
1132      */
1133     function getPricePerFullShare() public view returns (uint256) {
1134         return totalSupply() == 0 ? 1e18 : balance() * 1e18 / totalSupply();
1135     }
1136 
1137     /**
1138      * @dev A helper function to call deposit() with all the sender's funds.
1139      */
1140     function depositAll() external {
1141         deposit(want().balanceOf(msg.sender));
1142     }
1143 
1144     /**
1145      * @dev The entrypoint of funds into the system. People deposit with this function
1146      * into the vault. The vault is then in charge of sending funds into the strategy.
1147      */
1148     function deposit(uint _amount) public nonReentrant {
1149         strategy.beforeDeposit();
1150 
1151         uint256 _pool = balance();
1152         want().safeTransferFrom(msg.sender, address(this), _amount);
1153         earn();
1154         uint256 _after = balance();
1155         _amount = _after - _pool; // Additional check for deflationary tokens
1156         uint256 shares = 0;
1157         if (totalSupply() == 0) {
1158             shares = _amount;
1159         } else {
1160             shares = (_amount * totalSupply()) / _pool;
1161         }
1162         _mint(msg.sender, shares);
1163     }
1164 
1165     /**
1166      * @dev Function to send funds into the strategy and put them to work. It's primarily called
1167      * by the vault's deposit() function.
1168      */
1169     function earn() public {
1170         uint _bal = available();
1171         want().safeTransfer(address(strategy), _bal);
1172         strategy.deposit();
1173     }
1174 
1175     /**
1176      * @dev A helper function to call withdraw() with all the sender's funds.
1177      */
1178     function withdrawAll() external {
1179         withdraw(balanceOf(msg.sender));
1180     }
1181 
1182     /**
1183      * @dev Function to exit the system. The vault will withdraw the required tokens
1184      * from the strategy and pay up the token holder. A proportional number of IOU
1185      * tokens are burned in the process.
1186      */
1187     function withdraw(uint256 _shares) public {
1188         uint256 r = (balance() * _shares) / totalSupply();
1189         _burn(msg.sender, _shares);
1190 
1191         uint b = want().balanceOf(address(this));
1192         if (b < r) {
1193             uint _withdraw = r - b;
1194             strategy.withdraw(_withdraw);
1195             uint _after = want().balanceOf(address(this));
1196             uint _diff = _after - b;
1197             if (_diff < _withdraw) {
1198                 r = b + _diff;
1199             }
1200         }
1201 
1202         want().safeTransfer(msg.sender, r);
1203     }
1204 
1205     /** 
1206      * @dev Sets the candidate for the new strat to use with this vault.
1207      * @param _implementation The address of the candidate strategy.  
1208      */
1209     function proposeStrat(address _implementation) public onlyOwner {
1210         require(address(this) == IStrategyV7(_implementation).vault(), "Proposal not valid for this Vault");
1211         require(want() == IStrategyV7(_implementation).want(), "Different want");
1212         stratCandidate = StratCandidate({
1213             implementation: _implementation,
1214             proposedTime: block.timestamp
1215          });
1216 
1217         emit NewStratCandidate(_implementation);
1218     }
1219 
1220     /** 
1221      * @dev It switches the active strat for the strat candidate. After upgrading, the 
1222      * candidate implementation is set to the 0x00 address, and proposedTime to a time 
1223      * happening in +100 years for safety. 
1224      */
1225 
1226     function upgradeStrat() public onlyOwner {
1227         require(stratCandidate.implementation != address(0), "There is no candidate");
1228         require(stratCandidate.proposedTime + approvalDelay < block.timestamp, "Delay has not passed");
1229 
1230         emit UpgradeStrat(stratCandidate.implementation);
1231 
1232         strategy.retireStrat();
1233         strategy = IStrategyV7(stratCandidate.implementation);
1234         stratCandidate.implementation = address(0);
1235         stratCandidate.proposedTime = 5000000000;
1236 
1237         earn();
1238     }
1239 
1240     /**
1241      * @dev Rescues random funds stuck that the strat can't handle.
1242      * @param _token address of the token to rescue.
1243      */
1244     function inCaseTokensGetStuck(address _token) external onlyOwner {
1245         require(_token != address(want()), "!token");
1246 
1247         uint256 amount = IERC20Upgradeable(_token).balanceOf(address(this));
1248         IERC20Upgradeable(_token).safeTransfer(msg.sender, amount);
1249     }
1250 }