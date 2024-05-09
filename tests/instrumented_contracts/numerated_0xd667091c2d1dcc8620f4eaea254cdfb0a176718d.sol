1 // SPDX-License-Identifier: MIT
2 
3 /*
4  * @title OGV Mandatory Lockup Merkle Distributor
5  * @author Origin Protocol Labs
6  *
7  * Origin Protocol
8  * https://originprotocol.com
9  * https://ousd.com
10  *
11  * Released under the MIT license
12  * https://github.com/OriginProtocol/origin-dollar
13  * https://github.com/OriginProtocol/ousd-governance
14  *
15  * Copyright 2022 Origin Protocol Labs
16  *
17  * Permission is hereby granted, free of charge, to any person obtaining a copy
18  * of this software and associated documentation files (the "Software"), to deal
19  * in the Software without restriction, including without limitation the rights
20  * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
21  * copies of the Software, and to permit persons to whom the Software is
22  * furnished to do so, subject to the following conditions:
23  *
24  * The above copyright notice and this permission notice shall be included in
25  * all copies or substantial portions of the Software.
26  *
27  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
28  * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
29  * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
30  * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
31  * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
32  * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
33  * SOFTWARE.
34  */
35 
36 pragma solidity ^0.8.4;
37 
38 /**
39  * @dev Interface of the ERC20 standard as defined in the EIP.
40  */
41 interface IERC20Upgradeable {
42     /**
43      * @dev Emitted when `value` tokens are moved from one account (`from`) to
44      * another (`to`).
45      *
46      * Note that `value` may be zero.
47      */
48     event Transfer(address indexed from, address indexed to, uint256 value);
49 
50     /**
51      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
52      * a call to {approve}. `value` is the new allowance.
53      */
54     event Approval(address indexed owner, address indexed spender, uint256 value);
55 
56     /**
57      * @dev Returns the amount of tokens in existence.
58      */
59     function totalSupply() external view returns (uint256);
60 
61     /**
62      * @dev Returns the amount of tokens owned by `account`.
63      */
64     function balanceOf(address account) external view returns (uint256);
65 
66     /**
67      * @dev Moves `amount` tokens from the caller's account to `to`.
68      *
69      * Returns a boolean value indicating whether the operation succeeded.
70      *
71      * Emits a {Transfer} event.
72      */
73     function transfer(address to, uint256 amount) external returns (bool);
74 
75     /**
76      * @dev Returns the remaining number of tokens that `spender` will be
77      * allowed to spend on behalf of `owner` through {transferFrom}. This is
78      * zero by default.
79      *
80      * This value changes when {approve} or {transferFrom} are called.
81      */
82     function allowance(address owner, address spender) external view returns (uint256);
83 
84     /**
85      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
86      *
87      * Returns a boolean value indicating whether the operation succeeded.
88      *
89      * IMPORTANT: Beware that changing an allowance with this method brings the risk
90      * that someone may use both the old and the new allowance by unfortunate
91      * transaction ordering. One possible solution to mitigate this race
92      * condition is to first reduce the spender's allowance to 0 and set the
93      * desired value afterwards:
94      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
95      *
96      * Emits an {Approval} event.
97      */
98     function approve(address spender, uint256 amount) external returns (bool);
99 
100     /**
101      * @dev Moves `amount` tokens from `from` to `to` using the
102      * allowance mechanism. `amount` is then deducted from the caller's
103      * allowance.
104      *
105      * Returns a boolean value indicating whether the operation succeeded.
106      *
107      * Emits a {Transfer} event.
108      */
109     function transferFrom(
110         address from,
111         address to,
112         uint256 amount
113     ) external returns (bool);
114 }
115 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
116 
117 
118 
119 
120 
121 /**
122  * @dev Interface for the optional metadata functions from the ERC20 standard.
123  *
124  * _Available since v4.1._
125  */
126 interface IERC20MetadataUpgradeable is IERC20Upgradeable {
127     /**
128      * @dev Returns the name of the token.
129      */
130     function name() external view returns (string memory);
131 
132     /**
133      * @dev Returns the symbol of the token.
134      */
135     function symbol() external view returns (string memory);
136 
137     /**
138      * @dev Returns the decimals places of the token.
139      */
140     function decimals() external view returns (uint8);
141 }
142 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
143 
144 
145 // OpenZeppelin Contracts (last updated v4.6.0) (proxy/utils/Initializable.sol)
146 
147 
148 
149 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
150 
151 
152 
153 /**
154  * @dev Collection of functions related to the address type
155  */
156 library AddressUpgradeable {
157     /**
158      * @dev Returns true if `account` is a contract.
159      *
160      * [IMPORTANT]
161      * ====
162      * It is unsafe to assume that an address for which this function returns
163      * false is an externally-owned account (EOA) and not a contract.
164      *
165      * Among others, `isContract` will return false for the following
166      * types of addresses:
167      *
168      *  - an externally-owned account
169      *  - a contract in construction
170      *  - an address where a contract will be created
171      *  - an address where a contract lived, but was destroyed
172      * ====
173      *
174      * [IMPORTANT]
175      * ====
176      * You shouldn't rely on `isContract` to protect against flash loan attacks!
177      *
178      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
179      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
180      * constructor.
181      * ====
182      */
183     function isContract(address account) internal view returns (bool) {
184         // This method relies on extcodesize/address.code.length, which returns 0
185         // for contracts in construction, since the code is only stored at the end
186         // of the constructor execution.
187 
188         return account.code.length > 0;
189     }
190 
191     /**
192      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
193      * `recipient`, forwarding all available gas and reverting on errors.
194      *
195      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
196      * of certain opcodes, possibly making contracts go over the 2300 gas limit
197      * imposed by `transfer`, making them unable to receive funds via
198      * `transfer`. {sendValue} removes this limitation.
199      *
200      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
201      *
202      * IMPORTANT: because control is transferred to `recipient`, care must be
203      * taken to not create reentrancy vulnerabilities. Consider using
204      * {ReentrancyGuard} or the
205      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
206      */
207     function sendValue(address payable recipient, uint256 amount) internal {
208         require(address(this).balance >= amount, "Address: insufficient balance");
209 
210         (bool success, ) = recipient.call{value: amount}("");
211         require(success, "Address: unable to send value, recipient may have reverted");
212     }
213 
214     /**
215      * @dev Performs a Solidity function call using a low level `call`. A
216      * plain `call` is an unsafe replacement for a function call: use this
217      * function instead.
218      *
219      * If `target` reverts with a revert reason, it is bubbled up by this
220      * function (like regular Solidity function calls).
221      *
222      * Returns the raw returned data. To convert to the expected return value,
223      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
224      *
225      * Requirements:
226      *
227      * - `target` must be a contract.
228      * - calling `target` with `data` must not revert.
229      *
230      * _Available since v3.1._
231      */
232     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
233         return functionCallWithValue(target, data, 0, "Address: low-level call failed");
234     }
235 
236     /**
237      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
238      * `errorMessage` as a fallback revert reason when `target` reverts.
239      *
240      * _Available since v3.1._
241      */
242     function functionCall(
243         address target,
244         bytes memory data,
245         string memory errorMessage
246     ) internal returns (bytes memory) {
247         return functionCallWithValue(target, data, 0, errorMessage);
248     }
249 
250     /**
251      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
252      * but also transferring `value` wei to `target`.
253      *
254      * Requirements:
255      *
256      * - the calling contract must have an ETH balance of at least `value`.
257      * - the called Solidity function must be `payable`.
258      *
259      * _Available since v3.1._
260      */
261     function functionCallWithValue(
262         address target,
263         bytes memory data,
264         uint256 value
265     ) internal returns (bytes memory) {
266         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
267     }
268 
269     /**
270      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
271      * with `errorMessage` as a fallback revert reason when `target` reverts.
272      *
273      * _Available since v3.1._
274      */
275     function functionCallWithValue(
276         address target,
277         bytes memory data,
278         uint256 value,
279         string memory errorMessage
280     ) internal returns (bytes memory) {
281         require(address(this).balance >= value, "Address: insufficient balance for call");
282         require(isContract(target), "Address: call to non-contract");
283 
284         (bool success, bytes memory returndata) = target.call{value: value}(data);
285         return verifyCallResult(success, returndata, errorMessage);
286     }
287 
288     /**
289      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
290      * but performing a static call.
291      *
292      * _Available since v3.3._
293      */
294     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
295         return functionStaticCall(target, data, "Address: low-level static call failed");
296     }
297 
298     /**
299      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
300      * but performing a static call.
301      *
302      * _Available since v3.3._
303      */
304     function functionStaticCall(
305         address target,
306         bytes memory data,
307         string memory errorMessage
308     ) internal view returns (bytes memory) {
309         require(isContract(target), "Address: static call to non-contract");
310 
311         (bool success, bytes memory returndata) = target.staticcall(data);
312         return verifyCallResult(success, returndata, errorMessage);
313     }
314 
315     /**
316      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
317      * revert reason using the provided one.
318      *
319      * _Available since v4.3._
320      */
321     function verifyCallResult(
322         bool success,
323         bytes memory returndata,
324         string memory errorMessage
325     ) internal pure returns (bytes memory) {
326         if (success) {
327             return returndata;
328         } else {
329             // Look for revert reason and bubble it up if present
330             if (returndata.length > 0) {
331                 // The easiest way to bubble the revert reason is using memory via assembly
332                 /// @solidity memory-safe-assembly
333                 assembly {
334                     let returndata_size := mload(returndata)
335                     revert(add(32, returndata), returndata_size)
336                 }
337             } else {
338                 revert(errorMessage);
339             }
340         }
341     }
342 }
343 
344 /**
345  * @dev This is a base contract to aid in writing upgradeable contracts, or any kind of contract that will be deployed
346  * behind a proxy. Since proxied contracts do not make use of a constructor, it's common to move constructor logic to an
347  * external initializer function, usually called `initialize`. It then becomes necessary to protect this initializer
348  * function so it can only be called once. The {initializer} modifier provided by this contract will have this effect.
349  *
350  * The initialization functions use a version number. Once a version number is used, it is consumed and cannot be
351  * reused. This mechanism prevents re-execution of each "step" but allows the creation of new initialization steps in
352  * case an upgrade adds a module that needs to be initialized.
353  *
354  * For example:
355  *
356  * [.hljs-theme-light.nopadding]
357  * ```
358  * contract MyToken is ERC20Upgradeable {
359  *     function initialize() initializer public {
360  *         __ERC20_init("MyToken", "MTK");
361  *     }
362  * }
363  * contract MyTokenV2 is MyToken, ERC20PermitUpgradeable {
364  *     function initializeV2() reinitializer(2) public {
365  *         __ERC20Permit_init("MyToken");
366  *     }
367  * }
368  * ```
369  *
370  * TIP: To avoid leaving the proxy in an uninitialized state, the initializer function should be called as early as
371  * possible by providing the encoded function call as the `_data` argument to {ERC1967Proxy-constructor}.
372  *
373  * CAUTION: When used with inheritance, manual care must be taken to not invoke a parent initializer twice, or to ensure
374  * that all initializers are idempotent. This is not verified automatically as constructors are by Solidity.
375  *
376  * [CAUTION]
377  * ====
378  * Avoid leaving a contract uninitialized.
379  *
380  * An uninitialized contract can be taken over by an attacker. This applies to both a proxy and its implementation
381  * contract, which may impact the proxy. To prevent the implementation contract from being used, you should invoke
382  * the {_disableInitializers} function in the constructor to automatically lock it when it is deployed:
383  *
384  * [.hljs-theme-light.nopadding]
385  * ```
386  * /// @custom:oz-upgrades-unsafe-allow constructor
387  * constructor() {
388  *     _disableInitializers();
389  * }
390  * ```
391  * ====
392  */
393 abstract contract Initializable {
394     /**
395      * @dev Indicates that the contract has been initialized.
396      * @custom:oz-retyped-from bool
397      */
398     uint8 private _initialized;
399 
400     /**
401      * @dev Indicates that the contract is in the process of being initialized.
402      */
403     bool private _initializing;
404 
405     /**
406      * @dev Triggered when the contract has been initialized or reinitialized.
407      */
408     event Initialized(uint8 version);
409 
410     /**
411      * @dev A modifier that defines a protected initializer function that can be invoked at most once. In its scope,
412      * `onlyInitializing` functions can be used to initialize parent contracts. Equivalent to `reinitializer(1)`.
413      */
414     modifier initializer() {
415         bool isTopLevelCall = !_initializing;
416         require(
417             (isTopLevelCall && _initialized < 1) || (!AddressUpgradeable.isContract(address(this)) && _initialized == 1),
418             "Initializable: contract is already initialized"
419         );
420         _initialized = 1;
421         if (isTopLevelCall) {
422             _initializing = true;
423         }
424         _;
425         if (isTopLevelCall) {
426             _initializing = false;
427             emit Initialized(1);
428         }
429     }
430 
431     /**
432      * @dev A modifier that defines a protected reinitializer function that can be invoked at most once, and only if the
433      * contract hasn't been initialized to a greater version before. In its scope, `onlyInitializing` functions can be
434      * used to initialize parent contracts.
435      *
436      * `initializer` is equivalent to `reinitializer(1)`, so a reinitializer may be used after the original
437      * initialization step. This is essential to configure modules that are added through upgrades and that require
438      * initialization.
439      *
440      * Note that versions can jump in increments greater than 1; this implies that if multiple reinitializers coexist in
441      * a contract, executing them in the right order is up to the developer or operator.
442      */
443     modifier reinitializer(uint8 version) {
444         require(!_initializing && _initialized < version, "Initializable: contract is already initialized");
445         _initialized = version;
446         _initializing = true;
447         _;
448         _initializing = false;
449         emit Initialized(version);
450     }
451 
452     /**
453      * @dev Modifier to protect an initialization function so that it can only be invoked by functions with the
454      * {initializer} and {reinitializer} modifiers, directly or indirectly.
455      */
456     modifier onlyInitializing() {
457         require(_initializing, "Initializable: contract is not initializing");
458         _;
459     }
460 
461     /**
462      * @dev Locks the contract, preventing any future reinitialization. This cannot be part of an initializer call.
463      * Calling this in the constructor of a contract will prevent that contract from being initialized or reinitialized
464      * to any version. It is recommended to use this to lock implementation contracts that are designed to be called
465      * through proxies.
466      */
467     function _disableInitializers() internal virtual {
468         require(!_initializing, "Initializable: contract is initializing");
469         if (_initialized < type(uint8).max) {
470             _initialized = type(uint8).max;
471             emit Initialized(type(uint8).max);
472         }
473     }
474 }
475 
476 /**
477  * @dev Provides information about the current execution context, including the
478  * sender of the transaction and its data. While these are generally available
479  * via msg.sender and msg.data, they should not be accessed in such a direct
480  * manner, since when dealing with meta-transactions the account sending and
481  * paying for execution may not be the actual sender (as far as an application
482  * is concerned).
483  *
484  * This contract is only required for intermediate, library-like contracts.
485  */
486 abstract contract ContextUpgradeable is Initializable {
487     function __Context_init() internal onlyInitializing {
488     }
489 
490     function __Context_init_unchained() internal onlyInitializing {
491     }
492     function _msgSender() internal view virtual returns (address) {
493         return msg.sender;
494     }
495 
496     function _msgData() internal view virtual returns (bytes calldata) {
497         return msg.data;
498     }
499 
500     /**
501      * @dev This empty reserved space is put in place to allow future versions to add new
502      * variables without shifting down storage in the inheritance chain.
503      * See https://docs.openzeppelin.com/contracts/4.x/upgradeable#storage_gaps
504      */
505     uint256[50] private __gap;
506 }
507 
508 
509 /**
510  * @dev Implementation of the {IERC20} interface.
511  *
512  * This implementation is agnostic to the way tokens are created. This means
513  * that a supply mechanism has to be added in a derived contract using {_mint}.
514  * For a generic mechanism see {ERC20PresetMinterPauser}.
515  *
516  * TIP: For a detailed writeup see our guide
517  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
518  * to implement supply mechanisms].
519  *
520  * We have followed general OpenZeppelin Contracts guidelines: functions revert
521  * instead returning `false` on failure. This behavior is nonetheless
522  * conventional and does not conflict with the expectations of ERC20
523  * applications.
524  *
525  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
526  * This allows applications to reconstruct the allowance for all accounts just
527  * by listening to said events. Other implementations of the EIP may not emit
528  * these events, as it isn't required by the specification.
529  *
530  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
531  * functions have been added to mitigate the well-known issues around setting
532  * allowances. See {IERC20-approve}.
533  */
534 contract ERC20Upgradeable is Initializable, ContextUpgradeable, IERC20Upgradeable, IERC20MetadataUpgradeable {
535     mapping(address => uint256) private _balances;
536 
537     mapping(address => mapping(address => uint256)) private _allowances;
538 
539     uint256 private _totalSupply;
540 
541     string private _name;
542     string private _symbol;
543 
544     /**
545      * @dev Sets the values for {name} and {symbol}.
546      *
547      * The default value of {decimals} is 18. To select a different value for
548      * {decimals} you should overload it.
549      *
550      * All two of these values are immutable: they can only be set once during
551      * construction.
552      */
553     function __ERC20_init(string memory name_, string memory symbol_) internal onlyInitializing {
554         __ERC20_init_unchained(name_, symbol_);
555     }
556 
557     function __ERC20_init_unchained(string memory name_, string memory symbol_) internal onlyInitializing {
558         _name = name_;
559         _symbol = symbol_;
560     }
561 
562     /**
563      * @dev Returns the name of the token.
564      */
565     function name() public view virtual override returns (string memory) {
566         return _name;
567     }
568 
569     /**
570      * @dev Returns the symbol of the token, usually a shorter version of the
571      * name.
572      */
573     function symbol() public view virtual override returns (string memory) {
574         return _symbol;
575     }
576 
577     /**
578      * @dev Returns the number of decimals used to get its user representation.
579      * For example, if `decimals` equals `2`, a balance of `505` tokens should
580      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
581      *
582      * Tokens usually opt for a value of 18, imitating the relationship between
583      * Ether and Wei. This is the value {ERC20} uses, unless this function is
584      * overridden;
585      *
586      * NOTE: This information is only used for _display_ purposes: it in
587      * no way affects any of the arithmetic of the contract, including
588      * {IERC20-balanceOf} and {IERC20-transfer}.
589      */
590     function decimals() public view virtual override returns (uint8) {
591         return 18;
592     }
593 
594     /**
595      * @dev See {IERC20-totalSupply}.
596      */
597     function totalSupply() public view virtual override returns (uint256) {
598         return _totalSupply;
599     }
600 
601     /**
602      * @dev See {IERC20-balanceOf}.
603      */
604     function balanceOf(address account) public view virtual override returns (uint256) {
605         return _balances[account];
606     }
607 
608     /**
609      * @dev See {IERC20-transfer}.
610      *
611      * Requirements:
612      *
613      * - `to` cannot be the zero address.
614      * - the caller must have a balance of at least `amount`.
615      */
616     function transfer(address to, uint256 amount) public virtual override returns (bool) {
617         address owner = _msgSender();
618         _transfer(owner, to, amount);
619         return true;
620     }
621 
622     /**
623      * @dev See {IERC20-allowance}.
624      */
625     function allowance(address owner, address spender) public view virtual override returns (uint256) {
626         return _allowances[owner][spender];
627     }
628 
629     /**
630      * @dev See {IERC20-approve}.
631      *
632      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
633      * `transferFrom`. This is semantically equivalent to an infinite approval.
634      *
635      * Requirements:
636      *
637      * - `spender` cannot be the zero address.
638      */
639     function approve(address spender, uint256 amount) public virtual override returns (bool) {
640         address owner = _msgSender();
641         _approve(owner, spender, amount);
642         return true;
643     }
644 
645     /**
646      * @dev See {IERC20-transferFrom}.
647      *
648      * Emits an {Approval} event indicating the updated allowance. This is not
649      * required by the EIP. See the note at the beginning of {ERC20}.
650      *
651      * NOTE: Does not update the allowance if the current allowance
652      * is the maximum `uint256`.
653      *
654      * Requirements:
655      *
656      * - `from` and `to` cannot be the zero address.
657      * - `from` must have a balance of at least `amount`.
658      * - the caller must have allowance for ``from``'s tokens of at least
659      * `amount`.
660      */
661     function transferFrom(
662         address from,
663         address to,
664         uint256 amount
665     ) public virtual override returns (bool) {
666         address spender = _msgSender();
667         _spendAllowance(from, spender, amount);
668         _transfer(from, to, amount);
669         return true;
670     }
671 
672     /**
673      * @dev Atomically increases the allowance granted to `spender` by the caller.
674      *
675      * This is an alternative to {approve} that can be used as a mitigation for
676      * problems described in {IERC20-approve}.
677      *
678      * Emits an {Approval} event indicating the updated allowance.
679      *
680      * Requirements:
681      *
682      * - `spender` cannot be the zero address.
683      */
684     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
685         address owner = _msgSender();
686         _approve(owner, spender, allowance(owner, spender) + addedValue);
687         return true;
688     }
689 
690     /**
691      * @dev Atomically decreases the allowance granted to `spender` by the caller.
692      *
693      * This is an alternative to {approve} that can be used as a mitigation for
694      * problems described in {IERC20-approve}.
695      *
696      * Emits an {Approval} event indicating the updated allowance.
697      *
698      * Requirements:
699      *
700      * - `spender` cannot be the zero address.
701      * - `spender` must have allowance for the caller of at least
702      * `subtractedValue`.
703      */
704     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
705         address owner = _msgSender();
706         uint256 currentAllowance = allowance(owner, spender);
707         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
708         unchecked {
709             _approve(owner, spender, currentAllowance - subtractedValue);
710         }
711 
712         return true;
713     }
714 
715     /**
716      * @dev Moves `amount` of tokens from `from` to `to`.
717      *
718      * This internal function is equivalent to {transfer}, and can be used to
719      * e.g. implement automatic token fees, slashing mechanisms, etc.
720      *
721      * Emits a {Transfer} event.
722      *
723      * Requirements:
724      *
725      * - `from` cannot be the zero address.
726      * - `to` cannot be the zero address.
727      * - `from` must have a balance of at least `amount`.
728      */
729     function _transfer(
730         address from,
731         address to,
732         uint256 amount
733     ) internal virtual {
734         require(from != address(0), "ERC20: transfer from the zero address");
735         require(to != address(0), "ERC20: transfer to the zero address");
736 
737         _beforeTokenTransfer(from, to, amount);
738 
739         uint256 fromBalance = _balances[from];
740         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
741         unchecked {
742             _balances[from] = fromBalance - amount;
743         }
744         _balances[to] += amount;
745 
746         emit Transfer(from, to, amount);
747 
748         _afterTokenTransfer(from, to, amount);
749     }
750 
751     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
752      * the total supply.
753      *
754      * Emits a {Transfer} event with `from` set to the zero address.
755      *
756      * Requirements:
757      *
758      * - `account` cannot be the zero address.
759      */
760     function _mint(address account, uint256 amount) internal virtual {
761         require(account != address(0), "ERC20: mint to the zero address");
762 
763         _beforeTokenTransfer(address(0), account, amount);
764 
765         _totalSupply += amount;
766         _balances[account] += amount;
767         emit Transfer(address(0), account, amount);
768 
769         _afterTokenTransfer(address(0), account, amount);
770     }
771 
772     /**
773      * @dev Destroys `amount` tokens from `account`, reducing the
774      * total supply.
775      *
776      * Emits a {Transfer} event with `to` set to the zero address.
777      *
778      * Requirements:
779      *
780      * - `account` cannot be the zero address.
781      * - `account` must have at least `amount` tokens.
782      */
783     function _burn(address account, uint256 amount) internal virtual {
784         require(account != address(0), "ERC20: burn from the zero address");
785 
786         _beforeTokenTransfer(account, address(0), amount);
787 
788         uint256 accountBalance = _balances[account];
789         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
790         unchecked {
791             _balances[account] = accountBalance - amount;
792         }
793         _totalSupply -= amount;
794 
795         emit Transfer(account, address(0), amount);
796 
797         _afterTokenTransfer(account, address(0), amount);
798     }
799 
800     /**
801      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
802      *
803      * This internal function is equivalent to `approve`, and can be used to
804      * e.g. set automatic allowances for certain subsystems, etc.
805      *
806      * Emits an {Approval} event.
807      *
808      * Requirements:
809      *
810      * - `owner` cannot be the zero address.
811      * - `spender` cannot be the zero address.
812      */
813     function _approve(
814         address owner,
815         address spender,
816         uint256 amount
817     ) internal virtual {
818         require(owner != address(0), "ERC20: approve from the zero address");
819         require(spender != address(0), "ERC20: approve to the zero address");
820 
821         _allowances[owner][spender] = amount;
822         emit Approval(owner, spender, amount);
823     }
824 
825     /**
826      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
827      *
828      * Does not update the allowance amount in case of infinite allowance.
829      * Revert if not enough allowance is available.
830      *
831      * Might emit an {Approval} event.
832      */
833     function _spendAllowance(
834         address owner,
835         address spender,
836         uint256 amount
837     ) internal virtual {
838         uint256 currentAllowance = allowance(owner, spender);
839         if (currentAllowance != type(uint256).max) {
840             require(currentAllowance >= amount, "ERC20: insufficient allowance");
841             unchecked {
842                 _approve(owner, spender, currentAllowance - amount);
843             }
844         }
845     }
846 
847     /**
848      * @dev Hook that is called before any transfer of tokens. This includes
849      * minting and burning.
850      *
851      * Calling conditions:
852      *
853      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
854      * will be transferred to `to`.
855      * - when `from` is zero, `amount` tokens will be minted for `to`.
856      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
857      * - `from` and `to` are never both zero.
858      *
859      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
860      */
861     function _beforeTokenTransfer(
862         address from,
863         address to,
864         uint256 amount
865     ) internal virtual {}
866 
867     /**
868      * @dev Hook that is called after any transfer of tokens. This includes
869      * minting and burning.
870      *
871      * Calling conditions:
872      *
873      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
874      * has been transferred to `to`.
875      * - when `from` is zero, `amount` tokens have been minted for `to`.
876      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
877      * - `from` and `to` are never both zero.
878      *
879      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
880      */
881     function _afterTokenTransfer(
882         address from,
883         address to,
884         uint256 amount
885     ) internal virtual {}
886 
887     /**
888      * @dev This empty reserved space is put in place to allow future versions to add new
889      * variables without shifting down storage in the inheritance chain.
890      * See https://docs.openzeppelin.com/contracts/4.x/upgradeable#storage_gaps
891      */
892     uint256[45] private __gap;
893 }
894 
895 
896 
897 /**
898  * @dev Extension of {ERC20} that allows token holders to destroy both their own
899  * tokens and those that they have an allowance for, in a way that can be
900  * recognized off-chain (via event analysis).
901  */
902 abstract contract ERC20BurnableUpgradeable is Initializable, ContextUpgradeable, ERC20Upgradeable {
903     function __ERC20Burnable_init() internal onlyInitializing {
904     }
905 
906     function __ERC20Burnable_init_unchained() internal onlyInitializing {
907     }
908     /**
909      * @dev Destroys `amount` tokens from the caller.
910      *
911      * See {ERC20-_burn}.
912      */
913     function burn(uint256 amount) public virtual {
914         _burn(_msgSender(), amount);
915     }
916 
917     /**
918      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
919      * allowance.
920      *
921      * See {ERC20-_burn} and {ERC20-allowance}.
922      *
923      * Requirements:
924      *
925      * - the caller must have allowance for ``accounts``'s tokens of at least
926      * `amount`.
927      */
928     function burnFrom(address account, uint256 amount) public virtual {
929         _spendAllowance(account, _msgSender(), amount);
930         _burn(account, amount);
931     }
932 
933     /**
934      * @dev This empty reserved space is put in place to allow future versions to add new
935      * variables without shifting down storage in the inheritance chain.
936      * See https://docs.openzeppelin.com/contracts/4.x/upgradeable#storage_gaps
937      */
938     uint256[50] private __gap;
939 }
940 // OpenZeppelin Contracts (last updated v4.5.0) (utils/cryptography/MerkleProof.sol)
941 
942 
943 
944 /**
945  * @dev These functions deal with verification of Merkle Trees proofs.
946  *
947  * The proofs can be generated using the JavaScript library
948  * https://github.com/miguelmota/merkletreejs[merkletreejs].
949  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
950  *
951  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
952  *
953  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
954  * hashing, or use a hash function other than keccak256 for hashing leaves.
955  * This is because the concatenation of a sorted pair of internal nodes in
956  * the merkle tree could be reinterpreted as a leaf value.
957  */
958 library MerkleProof {
959     /**
960      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
961      * defined by `root`. For this, a `proof` must be provided, containing
962      * sibling hashes on the branch from the leaf to the root of the tree. Each
963      * pair of leaves and each pair of pre-images are assumed to be sorted.
964      */
965     function verify(
966         bytes32[] memory proof,
967         bytes32 root,
968         bytes32 leaf
969     ) internal pure returns (bool) {
970         return processProof(proof, leaf) == root;
971     }
972 
973     /**
974      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
975      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
976      * hash matches the root of the tree. When processing the proof, the pairs
977      * of leafs & pre-images are assumed to be sorted.
978      *
979      * _Available since v4.4._
980      */
981     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
982         bytes32 computedHash = leaf;
983         for (uint256 i = 0; i < proof.length; i++) {
984             bytes32 proofElement = proof[i];
985             if (computedHash <= proofElement) {
986                 // Hash(current computed hash + current element of the proof)
987                 computedHash = _efficientHash(computedHash, proofElement);
988             } else {
989                 // Hash(current element of the proof + current computed hash)
990                 computedHash = _efficientHash(proofElement, computedHash);
991             }
992         }
993         return computedHash;
994     }
995 
996     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
997         assembly {
998             mstore(0x00, a)
999             mstore(0x20, b)
1000             value := keccak256(0x00, 0x40)
1001         }
1002     }
1003 }
1004 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/IERC20.sol)
1005 
1006 
1007 
1008 /**
1009  * @dev Interface of the ERC20 standard as defined in the EIP.
1010  */
1011 interface IERC20 {
1012     /**
1013      * @dev Returns the amount of tokens in existence.
1014      */
1015     function totalSupply() external view returns (uint256);
1016 
1017     /**
1018      * @dev Returns the amount of tokens owned by `account`.
1019      */
1020     function balanceOf(address account) external view returns (uint256);
1021 
1022     /**
1023      * @dev Moves `amount` tokens from the caller's account to `to`.
1024      *
1025      * Returns a boolean value indicating whether the operation succeeded.
1026      *
1027      * Emits a {Transfer} event.
1028      */
1029     function transfer(address to, uint256 amount) external returns (bool);
1030 
1031     /**
1032      * @dev Returns the remaining number of tokens that `spender` will be
1033      * allowed to spend on behalf of `owner` through {transferFrom}. This is
1034      * zero by default.
1035      *
1036      * This value changes when {approve} or {transferFrom} are called.
1037      */
1038     function allowance(address owner, address spender) external view returns (uint256);
1039 
1040     /**
1041      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
1042      *
1043      * Returns a boolean value indicating whether the operation succeeded.
1044      *
1045      * IMPORTANT: Beware that changing an allowance with this method brings the risk
1046      * that someone may use both the old and the new allowance by unfortunate
1047      * transaction ordering. One possible solution to mitigate this race
1048      * condition is to first reduce the spender's allowance to 0 and set the
1049      * desired value afterwards:
1050      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
1051      *
1052      * Emits an {Approval} event.
1053      */
1054     function approve(address spender, uint256 amount) external returns (bool);
1055 
1056     /**
1057      * @dev Moves `amount` tokens from `from` to `to` using the
1058      * allowance mechanism. `amount` is then deducted from the caller's
1059      * allowance.
1060      *
1061      * Returns a boolean value indicating whether the operation succeeded.
1062      *
1063      * Emits a {Transfer} event.
1064      */
1065     function transferFrom(
1066         address from,
1067         address to,
1068         uint256 amount
1069     ) external returns (bool);
1070 
1071     /**
1072      * @dev Emitted when `value` tokens are moved from one account (`from`) to
1073      * another (`to`).
1074      *
1075      * Note that `value` may be zero.
1076      */
1077     event Transfer(address indexed from, address indexed to, uint256 value);
1078 
1079     /**
1080      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
1081      * a call to {approve}. `value` is the new allowance.
1082      */
1083     event Approval(address indexed owner, address indexed spender, uint256 value);
1084 }
1085 
1086 abstract contract AbstractLockupDistributor {
1087     //@notice This event is triggered whenever a call to #claim succeeds.
1088     event Claimed(uint256 indexed index, address indexed account, uint256 amount);
1089 
1090     event OGVBurned(uint256 amount);
1091 
1092     address public immutable token;
1093     bytes32 public immutable merkleRoot;
1094     address public immutable stakingContract;
1095     uint256 public immutable endBlock;
1096 
1097     // This is a packed array of booleans.
1098     mapping(uint256 => uint256) private claimedBitMap;
1099 
1100     constructor(
1101         address _token,
1102         bytes32 _merkleRoot,
1103         address _stakingContract,
1104         uint256 _endBlock
1105     ) {
1106         token = _token;
1107         merkleRoot = _merkleRoot;
1108         stakingContract = _stakingContract;
1109         endBlock = _endBlock;
1110     }
1111 
1112     /**
1113      * @dev
1114      * @param _index Index in the tree
1115      */
1116     function isClaimed(uint256 _index) public view returns (bool) {
1117         uint256 claimedWordIndex = _index / 256;
1118         uint256 claimedBitIndex = _index % 256;
1119         uint256 claimedWord = claimedBitMap[claimedWordIndex];
1120         uint256 mask = (1 << claimedBitIndex);
1121         return claimedWord & mask == mask;
1122     }
1123 
1124     /**
1125      * @dev
1126      * @param _index Index in the tree
1127      */
1128     function setClaimed(uint256 _index) internal {
1129         uint256 claimedWordIndex = _index / 256;
1130         uint256 claimedBitIndex = _index % 256;
1131         claimedBitMap[claimedWordIndex] =
1132             claimedBitMap[claimedWordIndex] |
1133             (1 << claimedBitIndex);
1134     }
1135 
1136     function isProofValid(
1137         uint256 _index,
1138         uint256 _amount,
1139         address _account,
1140         bytes32[] calldata _merkleProof
1141     ) external view returns (bool) {
1142         // Verify the Merkle proof.
1143         bytes32 node = keccak256(abi.encodePacked(_index, _account, _amount));
1144         return MerkleProof.verify(_merkleProof, merkleRoot, node);
1145     }
1146 
1147     /**
1148      * @dev burn all the remaining OGV balance
1149      */
1150     function burnRemainingOGV() external {
1151     	require(block.number >= endBlock, "Can not yet burn the remaining OGV");
1152     	uint256 burnAmount = IERC20(token).balanceOf(address(this));
1153 
1154     	ERC20BurnableUpgradeable(token).burn(burnAmount);
1155     	emit OGVBurned(burnAmount);
1156 
1157     }
1158 }
1159 
1160 interface IOGVStaking {
1161     function stake(
1162         uint256 amount,
1163         uint256 end,
1164         address to
1165     ) external;
1166 }
1167 
1168 contract MandatoryLockupDistributor is AbstractLockupDistributor {
1169 
1170     constructor(
1171         address _token,
1172         bytes32 _merkleRoot,
1173         address _stakingContract,
1174         uint256 _endBlock
1175     ) AbstractLockupDistributor(_token, _merkleRoot, _stakingContract, _endBlock) {}
1176 
1177     /**
1178      * @dev Execute a claim using a merkle proof with optional lockup in the staking contract.
1179      * @param _index Index in the tree
1180      * @param _amount Amount eligible to claim
1181      * @param _merkleProof The proof
1182      */
1183     function claim(
1184         uint256 _index,
1185         uint256 _amount,
1186         bytes32[] calldata _merkleProof
1187     ) external {
1188         require(!isClaimed(_index), "MerkleDistributor: Drop already claimed.");
1189         require(block.number < endBlock, "Can no longer claim. Claim period expired");
1190 
1191         // Verify the merkle proof.
1192         bytes32 node = keccak256(abi.encodePacked(_index, msg.sender, _amount));
1193         require(
1194             MerkleProof.verify(_merkleProof, merkleRoot, node),
1195             "MerkleDistributor: Invalid proof."
1196         );
1197 
1198         // Mark it claimed and send the token.
1199         setClaimed(_index);
1200 
1201         IERC20(token).approve(stakingContract, _amount);
1202 
1203         // Create four lockups in 12 month increments (1 month = 2629800 seconds)
1204         IOGVStaking(stakingContract).stake(_amount / 4, 2629800 * 12, msg.sender);
1205         IOGVStaking(stakingContract).stake(_amount / 4, 2629800 * 24, msg.sender);
1206         IOGVStaking(stakingContract).stake(_amount / 4, 2629800 * 36, msg.sender);
1207         IOGVStaking(stakingContract).stake(_amount / 4, 2629800 * 48, msg.sender);
1208 
1209         emit Claimed(_index, msg.sender, _amount);
1210     }
1211 }