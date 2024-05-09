1 // Sources flattened with hardhat v2.9.7 https://hardhat.org
2 
3 // File @openzeppelin/contracts/utils/Address.sol@v4.6.0
4 
5 // SPDX-License-Identifier: MIT
6 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
7 
8 pragma solidity ^0.8.1;
9 
10 /**
11  * @dev Collection of functions related to the address type
12  */
13 library Address {
14     /**
15      * @dev Returns true if `account` is a contract.
16      *
17      * [IMPORTANT]
18      * ====
19      * It is unsafe to assume that an address for which this function returns
20      * false is an externally-owned account (EOA) and not a contract.
21      *
22      * Among others, `isContract` will return false for the following
23      * types of addresses:
24      *
25      *  - an externally-owned account
26      *  - a contract in construction
27      *  - an address where a contract will be created
28      *  - an address where a contract lived, but was destroyed
29      * ====
30      *
31      * [IMPORTANT]
32      * ====
33      * You shouldn't rely on `isContract` to protect against flash loan attacks!
34      *
35      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
36      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
37      * constructor.
38      * ====
39      */
40     function isContract(address account) internal view returns (bool) {
41         // This method relies on extcodesize/address.code.length, which returns 0
42         // for contracts in construction, since the code is only stored at the end
43         // of the constructor execution.
44 
45         return account.code.length > 0;
46     }
47 
48     /**
49      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
50      * `recipient`, forwarding all available gas and reverting on errors.
51      *
52      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
53      * of certain opcodes, possibly making contracts go over the 2300 gas limit
54      * imposed by `transfer`, making them unable to receive funds via
55      * `transfer`. {sendValue} removes this limitation.
56      *
57      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
58      *
59      * IMPORTANT: because control is transferred to `recipient`, care must be
60      * taken to not create reentrancy vulnerabilities. Consider using
61      * {ReentrancyGuard} or the
62      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
63      */
64     function sendValue(address payable recipient, uint256 amount) internal {
65         require(address(this).balance >= amount, "Address: insufficient balance");
66 
67         (bool success, ) = recipient.call{value: amount}("");
68         require(success, "Address: unable to send value, recipient may have reverted");
69     }
70 
71     /**
72      * @dev Performs a Solidity function call using a low level `call`. A
73      * plain `call` is an unsafe replacement for a function call: use this
74      * function instead.
75      *
76      * If `target` reverts with a revert reason, it is bubbled up by this
77      * function (like regular Solidity function calls).
78      *
79      * Returns the raw returned data. To convert to the expected return value,
80      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
81      *
82      * Requirements:
83      *
84      * - `target` must be a contract.
85      * - calling `target` with `data` must not revert.
86      *
87      * _Available since v3.1._
88      */
89     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
90         return functionCall(target, data, "Address: low-level call failed");
91     }
92 
93     /**
94      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
95      * `errorMessage` as a fallback revert reason when `target` reverts.
96      *
97      * _Available since v3.1._
98      */
99     function functionCall(
100         address target,
101         bytes memory data,
102         string memory errorMessage
103     ) internal returns (bytes memory) {
104         return functionCallWithValue(target, data, 0, errorMessage);
105     }
106 
107     /**
108      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
109      * but also transferring `value` wei to `target`.
110      *
111      * Requirements:
112      *
113      * - the calling contract must have an ETH balance of at least `value`.
114      * - the called Solidity function must be `payable`.
115      *
116      * _Available since v3.1._
117      */
118     function functionCallWithValue(
119         address target,
120         bytes memory data,
121         uint256 value
122     ) internal returns (bytes memory) {
123         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
124     }
125 
126     /**
127      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
128      * with `errorMessage` as a fallback revert reason when `target` reverts.
129      *
130      * _Available since v3.1._
131      */
132     function functionCallWithValue(
133         address target,
134         bytes memory data,
135         uint256 value,
136         string memory errorMessage
137     ) internal returns (bytes memory) {
138         require(address(this).balance >= value, "Address: insufficient balance for call");
139         require(isContract(target), "Address: call to non-contract");
140 
141         (bool success, bytes memory returndata) = target.call{value: value}(data);
142         return verifyCallResult(success, returndata, errorMessage);
143     }
144 
145     /**
146      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
147      * but performing a static call.
148      *
149      * _Available since v3.3._
150      */
151     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
152         return functionStaticCall(target, data, "Address: low-level static call failed");
153     }
154 
155     /**
156      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
157      * but performing a static call.
158      *
159      * _Available since v3.3._
160      */
161     function functionStaticCall(
162         address target,
163         bytes memory data,
164         string memory errorMessage
165     ) internal view returns (bytes memory) {
166         require(isContract(target), "Address: static call to non-contract");
167 
168         (bool success, bytes memory returndata) = target.staticcall(data);
169         return verifyCallResult(success, returndata, errorMessage);
170     }
171 
172     /**
173      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
174      * but performing a delegate call.
175      *
176      * _Available since v3.4._
177      */
178     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
179         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
180     }
181 
182     /**
183      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
184      * but performing a delegate call.
185      *
186      * _Available since v3.4._
187      */
188     function functionDelegateCall(
189         address target,
190         bytes memory data,
191         string memory errorMessage
192     ) internal returns (bytes memory) {
193         require(isContract(target), "Address: delegate call to non-contract");
194 
195         (bool success, bytes memory returndata) = target.delegatecall(data);
196         return verifyCallResult(success, returndata, errorMessage);
197     }
198 
199     /**
200      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
201      * revert reason using the provided one.
202      *
203      * _Available since v4.3._
204      */
205     function verifyCallResult(
206         bool success,
207         bytes memory returndata,
208         string memory errorMessage
209     ) internal pure returns (bytes memory) {
210         if (success) {
211             return returndata;
212         } else {
213             // Look for revert reason and bubble it up if present
214             if (returndata.length > 0) {
215                 // The easiest way to bubble the revert reason is using memory via assembly
216 
217                 assembly {
218                     let returndata_size := mload(returndata)
219                     revert(add(32, returndata), returndata_size)
220                 }
221             } else {
222                 revert(errorMessage);
223             }
224         }
225     }
226 }
227 
228 
229 // File @openzeppelin/contracts/utils/Context.sol@v4.6.0
230 
231 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
232 
233 pragma solidity ^0.8.0;
234 
235 /**
236  * @dev Provides information about the current execution context, including the
237  * sender of the transaction and its data. While these are generally available
238  * via msg.sender and msg.data, they should not be accessed in such a direct
239  * manner, since when dealing with meta-transactions the account sending and
240  * paying for execution may not be the actual sender (as far as an application
241  * is concerned).
242  *
243  * This contract is only required for intermediate, library-like contracts.
244  */
245 abstract contract Context {
246     function _msgSender() internal view virtual returns (address) {
247         return msg.sender;
248     }
249 
250     function _msgData() internal view virtual returns (bytes calldata) {
251         return msg.data;
252     }
253 }
254 
255 
256 // File @openzeppelin/contracts/token/ERC20/IERC20.sol@v4.6.0
257 
258 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
259 
260 pragma solidity ^0.8.0;
261 
262 /**
263  * @dev Interface of the ERC20 standard as defined in the EIP.
264  */
265 interface IERC20 {
266     /**
267      * @dev Emitted when `value` tokens are moved from one account (`from`) to
268      * another (`to`).
269      *
270      * Note that `value` may be zero.
271      */
272     event Transfer(address indexed from, address indexed to, uint256 value);
273 
274     /**
275      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
276      * a call to {approve}. `value` is the new allowance.
277      */
278     event Approval(address indexed owner, address indexed spender, uint256 value);
279 
280     /**
281      * @dev Returns the amount of tokens in existence.
282      */
283     function totalSupply() external view returns (uint256);
284 
285     /**
286      * @dev Returns the amount of tokens owned by `account`.
287      */
288     function balanceOf(address account) external view returns (uint256);
289 
290     /**
291      * @dev Moves `amount` tokens from the caller's account to `to`.
292      *
293      * Returns a boolean value indicating whether the operation succeeded.
294      *
295      * Emits a {Transfer} event.
296      */
297     function transfer(address to, uint256 amount) external returns (bool);
298 
299     /**
300      * @dev Returns the remaining number of tokens that `spender` will be
301      * allowed to spend on behalf of `owner` through {transferFrom}. This is
302      * zero by default.
303      *
304      * This value changes when {approve} or {transferFrom} are called.
305      */
306     function allowance(address owner, address spender) external view returns (uint256);
307 
308     /**
309      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
310      *
311      * Returns a boolean value indicating whether the operation succeeded.
312      *
313      * IMPORTANT: Beware that changing an allowance with this method brings the risk
314      * that someone may use both the old and the new allowance by unfortunate
315      * transaction ordering. One possible solution to mitigate this race
316      * condition is to first reduce the spender's allowance to 0 and set the
317      * desired value afterwards:
318      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
319      *
320      * Emits an {Approval} event.
321      */
322     function approve(address spender, uint256 amount) external returns (bool);
323 
324     /**
325      * @dev Moves `amount` tokens from `from` to `to` using the
326      * allowance mechanism. `amount` is then deducted from the caller's
327      * allowance.
328      *
329      * Returns a boolean value indicating whether the operation succeeded.
330      *
331      * Emits a {Transfer} event.
332      */
333     function transferFrom(
334         address from,
335         address to,
336         uint256 amount
337     ) external returns (bool);
338 }
339 
340 
341 // File contracts/lib/IERC20Internal.sol
342 
343 
344 pragma solidity ^0.8.0;
345 
346 abstract contract IERC20Internal {
347     function _transfer(
348         address sender,
349         address recipient,
350         uint256 amount
351     ) internal virtual;
352 
353     function _transferFrom(
354         address sender,
355         address recipient,
356         uint256 amount
357     ) internal virtual;
358 
359     function _approve(
360         address owner,
361         address spender,
362         uint256 amount
363     ) internal virtual;
364 
365     function _increaseAllowance(
366         address owner,
367         address spender,
368         uint256 increment
369     ) internal virtual;
370 
371     function _decreaseAllowance(
372         address owner,
373         address spender,
374         uint256 decrement
375     ) internal virtual;
376 
377     function _mint(address account, uint256 amount) internal virtual;
378 
379     function _burn(address account, uint256 amount) internal virtual;
380 }
381 
382 
383 // File contracts/lib/ERC20.sol
384 
385 
386 pragma solidity ^0.8.0;
387 
388 
389 
390 contract ERC20 is Context, IERC20, IERC20Internal {
391     using Address for address;
392 
393     mapping(address => uint256) private _balances;
394 
395     mapping(address => mapping(address => uint256)) private _allowances;
396 
397     uint256 private _totalSupply;
398 
399     string private _name;
400     string private _symbol;
401     uint8 private _decimals;
402 
403     /**
404      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
405      * a default value of 18.
406      *
407      * To select a different value for {decimals}, use {_setupDecimals}.
408      *
409      * All three of these values are immutable: they can only be set once during
410      * construction.
411      */
412     constructor(string memory n, string memory s) {
413         _name = n;
414         _symbol = s;
415         _decimals = 18;
416     }
417 
418     /**
419      * @dev Returns the name of the token.
420      */
421     function name() public view returns (string memory) {
422         return _name;
423     }
424 
425     function _setName(string memory newName) internal {
426         _name = newName;
427     }
428 
429     /**
430      * @dev Returns the symbol of the token, usually a shorter version of the
431      * name.
432      */
433     function symbol() public view returns (string memory) {
434         return _symbol;
435     }
436 
437     function _setSymbol(string memory newSymbol) internal {
438         _symbol = newSymbol;
439     }
440 
441     /**
442      * @dev Returns the number of decimals used to get its user representation.
443      * For example, if `decimals` equals `2`, a balance of `505` tokens should
444      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
445      *
446      * Tokens usually opt for a value of 18, imitating the relationship between
447      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
448      * called.
449      *
450      * NOTE: This information is only used for _display_ purposes: it in
451      * no way affects any of the arithmetic of the contract, including
452      * {IERC20-balanceOf} and {IERC20-transfer}.
453      */
454     function decimals() public view returns (uint8) {
455         return _decimals;
456     }
457 
458     function _setDecimals(uint8 newDecimals) internal {
459         _decimals = newDecimals;
460     }
461 
462     /**
463      * @dev See {IERC20-totalSupply}.
464      */
465     function totalSupply() public override view returns (uint256) {
466         return _totalSupply;
467     }
468 
469     /**
470      * @dev See {IERC20-balanceOf}.
471      */
472     function balanceOf(address account)
473         public
474         override
475         view
476         returns (uint256)
477     {
478         return _balances[account];
479     }
480 
481     /**
482      * @dev See {IERC20-transfer}.
483      *
484      * Requirements:
485      *
486      * - `recipient` cannot be the zero address.
487      * - the caller must have a balance of at least `amount`.
488      */
489     function transfer(address recipient, uint256 amount)
490         public
491         virtual
492         override
493         returns (bool)
494     {
495         _transfer(_msgSender(), recipient, amount);
496         return true;
497     }
498 
499     /**
500      * @dev See {IERC20-allowance}.
501      */
502     function allowance(address owner, address spender)
503         public
504         virtual
505         override
506         view
507         returns (uint256)
508     {
509         return _allowances[owner][spender];
510     }
511 
512     /**
513      * @dev See {IERC20-approve}.
514      *
515      * Requirements:
516      *
517      * - `spender` cannot be the zero address.
518      */
519     function approve(address spender, uint256 amount)
520         public
521         virtual
522         override
523         returns (bool)
524     {
525         _approve(_msgSender(), spender, amount);
526         return true;
527     }
528 
529     /**
530      * @dev See {IERC20-transferFrom}.
531      *
532      * Emits an {Approval} event indicating the updated allowance. This is not
533      * required by the EIP. See the note at the beginning of {ERC20};
534      *
535      * Requirements:
536      * - `sender` and `recipient` cannot be the zero address.
537      * - `sender` must have a balance of at least `amount`.
538      * - the caller must have allowance for ``sender``'s tokens of at least
539      * `amount`.
540      */
541     function transferFrom(
542         address sender,
543         address recipient,
544         uint256 amount
545     ) public virtual override returns (bool) {
546         _transferFrom(sender, recipient, amount);
547         return true;
548     }
549 
550     /**
551      * @dev Atomically increases the allowance granted to `spender` by the caller.
552      *
553      * This is an alternative to {approve} that can be used as a mitigation for
554      * problems described in {IERC20-approve}.
555      *
556      * Emits an {Approval} event indicating the updated allowance.
557      *
558      * Requirements:
559      *
560      * - `spender` cannot be the zero address.
561      */
562     function increaseAllowance(address spender, uint256 addedValue)
563         public
564         virtual
565         returns (bool)
566     {
567         _increaseAllowance(_msgSender(), spender, addedValue);
568         return true;
569     }
570 
571     /**
572      * @dev Atomically decreases the allowance granted to `spender` by the caller.
573      *
574      * This is an alternative to {approve} that can be used as a mitigation for
575      * problems described in {IERC20-approve}.
576      *
577      * Emits an {Approval} event indicating the updated allowance.
578      *
579      * Requirements:
580      *
581      * - `spender` cannot be the zero address.
582      * - `spender` must have allowance for the caller of at least
583      * `subtractedValue`.
584      */
585     function decreaseAllowance(address spender, uint256 subtractedValue)
586         public
587         virtual
588         returns (bool)
589     {
590         _decreaseAllowance(_msgSender(), spender, subtractedValue);
591         return true;
592     }
593 
594     /**
595      * @dev Moves tokens `amount` from `sender` to `recipient`.
596      *
597      * This is internal function is equivalent to {transfer}, and can be used to
598      * e.g. implement automatic token fees, slashing mechanisms, etc.
599      *
600      * Emits a {Transfer} event.
601      *
602      * Requirements:
603      *
604      * - `sender` cannot be the zero address.
605      * - `recipient` cannot be the zero address.
606      * - `sender` must have a balance of at least `amount`.
607      */
608     function _transfer(
609         address sender,
610         address recipient,
611         uint256 amount
612     ) internal virtual override {
613         require(sender != address(0), "ERC20: transfer from the zero address");
614         require(recipient != address(0), "ERC20: transfer to the zero address");
615 
616         _beforeTokenTransfer(sender, recipient, amount);
617 
618         _balances[sender] = _balances[sender] - amount;
619         _balances[recipient] = _balances[recipient] + amount;
620         emit Transfer(sender, recipient, amount);
621     }
622 
623     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
624      * the total supply.
625      *
626      * Emits a {Transfer} event with `from` set to the zero address.
627      *
628      * Requirements
629      *
630      * - `to` cannot be the zero address.
631      */
632     function _mint(address account, uint256 amount) internal virtual override {
633         require(account != address(0), "ERC20: mint to the zero address");
634 
635         _beforeTokenTransfer(address(0), account, amount);
636 
637         _totalSupply = _totalSupply + amount;
638         _balances[account] = _balances[account] + amount;
639         emit Transfer(address(0), account, amount);
640     }
641 
642     /**
643      * @dev Destroys `amount` tokens from `account`, reducing the
644      * total supply.
645      *
646      * Emits a {Transfer} event with `to` set to the zero address.
647      *
648      * Requirements
649      *
650      * - `account` cannot be the zero address.
651      * - `account` must have at least `amount` tokens.
652      */
653     function _burn(address account, uint256 amount) internal virtual override {
654         require(account != address(0), "ERC20: burn from the zero address");
655 
656         _beforeTokenTransfer(account, address(0), amount);
657 
658         _balances[account] = _balances[account] - amount;
659         _totalSupply = _totalSupply - amount;
660         emit Transfer(account, address(0), amount);
661     }
662 
663     /**
664      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
665      *
666      * This is internal function is equivalent to `approve`, and can be used to
667      * e.g. set automatic allowances for certain subsystems, etc.
668      *
669      * Emits an {Approval} event.
670      *
671      * Requirements:
672      *
673      * - `owner` cannot be the zero address.
674      * - `spender` cannot be the zero address.
675      */
676     function _approve(
677         address owner,
678         address spender,
679         uint256 amount
680     ) internal virtual override {
681         require(owner != address(0), "ERC20: approve from the zero address");
682         require(spender != address(0), "ERC20: approve to the zero address");
683 
684         _allowances[owner][spender] = amount;
685         emit Approval(owner, spender, amount);
686     }
687 
688     /**
689      * @dev Sets {decimals} to a value other than the default one of 18.
690      *
691      * WARNING: This function should only be called from the constructor. Most
692      * applications that interact with token contracts will not expect
693      * {decimals} to ever change, and may work incorrectly if it does.
694      */
695     function _setupDecimals(uint8 decimals_) internal {
696         _decimals = decimals_;
697     }
698 
699     /**
700      * @dev Hook that is called before any transfer of tokens. This includes
701      * minting and burning.
702      *
703      * Calling conditions:
704      *
705      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
706      * will be to transferred to `to`.
707      * - when `from` is zero, `amount` tokens will be minted for `to`.
708      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
709      * - `from` and `to` are never both zero.
710      *
711      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
712      */
713     function _beforeTokenTransfer(
714         address from,
715         address to,
716         uint256 amount
717     ) internal virtual {}
718 
719     function _transferFrom(
720         address sender,
721         address recipient,
722         uint256 amount
723     ) internal virtual override {
724         _transfer(sender, recipient, amount);
725         _approve(
726             sender,
727             _msgSender(),
728             _allowances[sender][_msgSender()] - amount
729         );
730     }
731 
732     function _increaseAllowance(
733         address owner,
734         address spender,
735         uint256 addedValue
736     ) internal virtual override {
737         _approve(owner, spender, _allowances[owner][spender] + addedValue);
738     }
739 
740     function _decreaseAllowance(
741         address owner,
742         address spender,
743         uint256 subtractedValue
744     ) internal virtual override {
745         _approve(
746             owner,
747             spender,
748             _allowances[owner][spender] -subtractedValue
749         );
750     }
751 }
752 
753 
754 // File @openzeppelin/contracts/access/IAccessControl.sol@v4.6.0
755 
756 // OpenZeppelin Contracts v4.4.1 (access/IAccessControl.sol)
757 
758 pragma solidity ^0.8.0;
759 
760 /**
761  * @dev External interface of AccessControl declared to support ERC165 detection.
762  */
763 interface IAccessControl {
764     /**
765      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
766      *
767      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
768      * {RoleAdminChanged} not being emitted signaling this.
769      *
770      * _Available since v3.1._
771      */
772     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
773 
774     /**
775      * @dev Emitted when `account` is granted `role`.
776      *
777      * `sender` is the account that originated the contract call, an admin role
778      * bearer except when using {AccessControl-_setupRole}.
779      */
780     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
781 
782     /**
783      * @dev Emitted when `account` is revoked `role`.
784      *
785      * `sender` is the account that originated the contract call:
786      *   - if using `revokeRole`, it is the admin role bearer
787      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
788      */
789     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
790 
791     /**
792      * @dev Returns `true` if `account` has been granted `role`.
793      */
794     function hasRole(bytes32 role, address account) external view returns (bool);
795 
796     /**
797      * @dev Returns the admin role that controls `role`. See {grantRole} and
798      * {revokeRole}.
799      *
800      * To change a role's admin, use {AccessControl-_setRoleAdmin}.
801      */
802     function getRoleAdmin(bytes32 role) external view returns (bytes32);
803 
804     /**
805      * @dev Grants `role` to `account`.
806      *
807      * If `account` had not been already granted `role`, emits a {RoleGranted}
808      * event.
809      *
810      * Requirements:
811      *
812      * - the caller must have ``role``'s admin role.
813      */
814     function grantRole(bytes32 role, address account) external;
815 
816     /**
817      * @dev Revokes `role` from `account`.
818      *
819      * If `account` had been granted `role`, emits a {RoleRevoked} event.
820      *
821      * Requirements:
822      *
823      * - the caller must have ``role``'s admin role.
824      */
825     function revokeRole(bytes32 role, address account) external;
826 
827     /**
828      * @dev Revokes `role` from the calling account.
829      *
830      * Roles are often managed via {grantRole} and {revokeRole}: this function's
831      * purpose is to provide a mechanism for accounts to lose their privileges
832      * if they are compromised (such as when a trusted device is misplaced).
833      *
834      * If the calling account had been granted `role`, emits a {RoleRevoked}
835      * event.
836      *
837      * Requirements:
838      *
839      * - the caller must be `account`.
840      */
841     function renounceRole(bytes32 role, address account) external;
842 }
843 
844 
845 // File @openzeppelin/contracts/access/IAccessControlEnumerable.sol@v4.6.0
846 
847 // OpenZeppelin Contracts v4.4.1 (access/IAccessControlEnumerable.sol)
848 
849 pragma solidity ^0.8.0;
850 
851 /**
852  * @dev External interface of AccessControlEnumerable declared to support ERC165 detection.
853  */
854 interface IAccessControlEnumerable is IAccessControl {
855     /**
856      * @dev Returns one of the accounts that have `role`. `index` must be a
857      * value between 0 and {getRoleMemberCount}, non-inclusive.
858      *
859      * Role bearers are not sorted in any particular way, and their ordering may
860      * change at any point.
861      *
862      * WARNING: When using {getRoleMember} and {getRoleMemberCount}, make sure
863      * you perform all queries on the same block. See the following
864      * https://forum.openzeppelin.com/t/iterating-over-elements-on-enumerableset-in-openzeppelin-contracts/2296[forum post]
865      * for more information.
866      */
867     function getRoleMember(bytes32 role, uint256 index) external view returns (address);
868 
869     /**
870      * @dev Returns the number of accounts that have `role`. Can be used
871      * together with {getRoleMember} to enumerate all bearers of a role.
872      */
873     function getRoleMemberCount(bytes32 role) external view returns (uint256);
874 }
875 
876 
877 // File @openzeppelin/contracts/utils/Strings.sol@v4.6.0
878 
879 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
880 
881 pragma solidity ^0.8.0;
882 
883 /**
884  * @dev String operations.
885  */
886 library Strings {
887     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
888 
889     /**
890      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
891      */
892     function toString(uint256 value) internal pure returns (string memory) {
893         // Inspired by OraclizeAPI's implementation - MIT licence
894         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
895 
896         if (value == 0) {
897             return "0";
898         }
899         uint256 temp = value;
900         uint256 digits;
901         while (temp != 0) {
902             digits++;
903             temp /= 10;
904         }
905         bytes memory buffer = new bytes(digits);
906         while (value != 0) {
907             digits -= 1;
908             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
909             value /= 10;
910         }
911         return string(buffer);
912     }
913 
914     /**
915      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
916      */
917     function toHexString(uint256 value) internal pure returns (string memory) {
918         if (value == 0) {
919             return "0x00";
920         }
921         uint256 temp = value;
922         uint256 length = 0;
923         while (temp != 0) {
924             length++;
925             temp >>= 8;
926         }
927         return toHexString(value, length);
928     }
929 
930     /**
931      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
932      */
933     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
934         bytes memory buffer = new bytes(2 * length + 2);
935         buffer[0] = "0";
936         buffer[1] = "x";
937         for (uint256 i = 2 * length + 1; i > 1; --i) {
938             buffer[i] = _HEX_SYMBOLS[value & 0xf];
939             value >>= 4;
940         }
941         require(value == 0, "Strings: hex length insufficient");
942         return string(buffer);
943     }
944 }
945 
946 
947 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.6.0
948 
949 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
950 
951 pragma solidity ^0.8.0;
952 
953 /**
954  * @dev Interface of the ERC165 standard, as defined in the
955  * https://eips.ethereum.org/EIPS/eip-165[EIP].
956  *
957  * Implementers can declare support of contract interfaces, which can then be
958  * queried by others ({ERC165Checker}).
959  *
960  * For an implementation, see {ERC165}.
961  */
962 interface IERC165 {
963     /**
964      * @dev Returns true if this contract implements the interface defined by
965      * `interfaceId`. See the corresponding
966      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
967      * to learn more about how these ids are created.
968      *
969      * This function call must use less than 30 000 gas.
970      */
971     function supportsInterface(bytes4 interfaceId) external view returns (bool);
972 }
973 
974 
975 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.6.0
976 
977 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
978 
979 pragma solidity ^0.8.0;
980 
981 /**
982  * @dev Implementation of the {IERC165} interface.
983  *
984  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
985  * for the additional interface id that will be supported. For example:
986  *
987  * ```solidity
988  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
989  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
990  * }
991  * ```
992  *
993  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
994  */
995 abstract contract ERC165 is IERC165 {
996     /**
997      * @dev See {IERC165-supportsInterface}.
998      */
999     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1000         return interfaceId == type(IERC165).interfaceId;
1001     }
1002 }
1003 
1004 
1005 // File @openzeppelin/contracts/access/AccessControl.sol@v4.6.0
1006 
1007 // OpenZeppelin Contracts (last updated v4.6.0) (access/AccessControl.sol)
1008 
1009 pragma solidity ^0.8.0;
1010 
1011 
1012 
1013 
1014 /**
1015  * @dev Contract module that allows children to implement role-based access
1016  * control mechanisms. This is a lightweight version that doesn't allow enumerating role
1017  * members except through off-chain means by accessing the contract event logs. Some
1018  * applications may benefit from on-chain enumerability, for those cases see
1019  * {AccessControlEnumerable}.
1020  *
1021  * Roles are referred to by their `bytes32` identifier. These should be exposed
1022  * in the external API and be unique. The best way to achieve this is by
1023  * using `public constant` hash digests:
1024  *
1025  * ```
1026  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
1027  * ```
1028  *
1029  * Roles can be used to represent a set of permissions. To restrict access to a
1030  * function call, use {hasRole}:
1031  *
1032  * ```
1033  * function foo() public {
1034  *     require(hasRole(MY_ROLE, msg.sender));
1035  *     ...
1036  * }
1037  * ```
1038  *
1039  * Roles can be granted and revoked dynamically via the {grantRole} and
1040  * {revokeRole} functions. Each role has an associated admin role, and only
1041  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
1042  *
1043  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
1044  * that only accounts with this role will be able to grant or revoke other
1045  * roles. More complex role relationships can be created by using
1046  * {_setRoleAdmin}.
1047  *
1048  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
1049  * grant and revoke this role. Extra precautions should be taken to secure
1050  * accounts that have been granted it.
1051  */
1052 abstract contract AccessControl is Context, IAccessControl, ERC165 {
1053     struct RoleData {
1054         mapping(address => bool) members;
1055         bytes32 adminRole;
1056     }
1057 
1058     mapping(bytes32 => RoleData) private _roles;
1059 
1060     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
1061 
1062     /**
1063      * @dev Modifier that checks that an account has a specific role. Reverts
1064      * with a standardized message including the required role.
1065      *
1066      * The format of the revert reason is given by the following regular expression:
1067      *
1068      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
1069      *
1070      * _Available since v4.1._
1071      */
1072     modifier onlyRole(bytes32 role) {
1073         _checkRole(role);
1074         _;
1075     }
1076 
1077     /**
1078      * @dev See {IERC165-supportsInterface}.
1079      */
1080     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1081         return interfaceId == type(IAccessControl).interfaceId || super.supportsInterface(interfaceId);
1082     }
1083 
1084     /**
1085      * @dev Returns `true` if `account` has been granted `role`.
1086      */
1087     function hasRole(bytes32 role, address account) public view virtual override returns (bool) {
1088         return _roles[role].members[account];
1089     }
1090 
1091     /**
1092      * @dev Revert with a standard message if `_msgSender()` is missing `role`.
1093      * Overriding this function changes the behavior of the {onlyRole} modifier.
1094      *
1095      * Format of the revert message is described in {_checkRole}.
1096      *
1097      * _Available since v4.6._
1098      */
1099     function _checkRole(bytes32 role) internal view virtual {
1100         _checkRole(role, _msgSender());
1101     }
1102 
1103     /**
1104      * @dev Revert with a standard message if `account` is missing `role`.
1105      *
1106      * The format of the revert reason is given by the following regular expression:
1107      *
1108      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
1109      */
1110     function _checkRole(bytes32 role, address account) internal view virtual {
1111         if (!hasRole(role, account)) {
1112             revert(
1113                 string(
1114                     abi.encodePacked(
1115                         "AccessControl: account ",
1116                         Strings.toHexString(uint160(account), 20),
1117                         " is missing role ",
1118                         Strings.toHexString(uint256(role), 32)
1119                     )
1120                 )
1121             );
1122         }
1123     }
1124 
1125     /**
1126      * @dev Returns the admin role that controls `role`. See {grantRole} and
1127      * {revokeRole}.
1128      *
1129      * To change a role's admin, use {_setRoleAdmin}.
1130      */
1131     function getRoleAdmin(bytes32 role) public view virtual override returns (bytes32) {
1132         return _roles[role].adminRole;
1133     }
1134 
1135     /**
1136      * @dev Grants `role` to `account`.
1137      *
1138      * If `account` had not been already granted `role`, emits a {RoleGranted}
1139      * event.
1140      *
1141      * Requirements:
1142      *
1143      * - the caller must have ``role``'s admin role.
1144      */
1145     function grantRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
1146         _grantRole(role, account);
1147     }
1148 
1149     /**
1150      * @dev Revokes `role` from `account`.
1151      *
1152      * If `account` had been granted `role`, emits a {RoleRevoked} event.
1153      *
1154      * Requirements:
1155      *
1156      * - the caller must have ``role``'s admin role.
1157      */
1158     function revokeRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
1159         _revokeRole(role, account);
1160     }
1161 
1162     /**
1163      * @dev Revokes `role` from the calling account.
1164      *
1165      * Roles are often managed via {grantRole} and {revokeRole}: this function's
1166      * purpose is to provide a mechanism for accounts to lose their privileges
1167      * if they are compromised (such as when a trusted device is misplaced).
1168      *
1169      * If the calling account had been revoked `role`, emits a {RoleRevoked}
1170      * event.
1171      *
1172      * Requirements:
1173      *
1174      * - the caller must be `account`.
1175      */
1176     function renounceRole(bytes32 role, address account) public virtual override {
1177         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
1178 
1179         _revokeRole(role, account);
1180     }
1181 
1182     /**
1183      * @dev Grants `role` to `account`.
1184      *
1185      * If `account` had not been already granted `role`, emits a {RoleGranted}
1186      * event. Note that unlike {grantRole}, this function doesn't perform any
1187      * checks on the calling account.
1188      *
1189      * [WARNING]
1190      * ====
1191      * This function should only be called from the constructor when setting
1192      * up the initial roles for the system.
1193      *
1194      * Using this function in any other way is effectively circumventing the admin
1195      * system imposed by {AccessControl}.
1196      * ====
1197      *
1198      * NOTE: This function is deprecated in favor of {_grantRole}.
1199      */
1200     function _setupRole(bytes32 role, address account) internal virtual {
1201         _grantRole(role, account);
1202     }
1203 
1204     /**
1205      * @dev Sets `adminRole` as ``role``'s admin role.
1206      *
1207      * Emits a {RoleAdminChanged} event.
1208      */
1209     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
1210         bytes32 previousAdminRole = getRoleAdmin(role);
1211         _roles[role].adminRole = adminRole;
1212         emit RoleAdminChanged(role, previousAdminRole, adminRole);
1213     }
1214 
1215     /**
1216      * @dev Grants `role` to `account`.
1217      *
1218      * Internal function without access restriction.
1219      */
1220     function _grantRole(bytes32 role, address account) internal virtual {
1221         if (!hasRole(role, account)) {
1222             _roles[role].members[account] = true;
1223             emit RoleGranted(role, account, _msgSender());
1224         }
1225     }
1226 
1227     /**
1228      * @dev Revokes `role` from `account`.
1229      *
1230      * Internal function without access restriction.
1231      */
1232     function _revokeRole(bytes32 role, address account) internal virtual {
1233         if (hasRole(role, account)) {
1234             _roles[role].members[account] = false;
1235             emit RoleRevoked(role, account, _msgSender());
1236         }
1237     }
1238 }
1239 
1240 
1241 // File @openzeppelin/contracts/utils/structs/EnumerableSet.sol@v4.6.0
1242 
1243 // OpenZeppelin Contracts (last updated v4.6.0) (utils/structs/EnumerableSet.sol)
1244 
1245 pragma solidity ^0.8.0;
1246 
1247 /**
1248  * @dev Library for managing
1249  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
1250  * types.
1251  *
1252  * Sets have the following properties:
1253  *
1254  * - Elements are added, removed, and checked for existence in constant time
1255  * (O(1)).
1256  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
1257  *
1258  * ```
1259  * contract Example {
1260  *     // Add the library methods
1261  *     using EnumerableSet for EnumerableSet.AddressSet;
1262  *
1263  *     // Declare a set state variable
1264  *     EnumerableSet.AddressSet private mySet;
1265  * }
1266  * ```
1267  *
1268  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
1269  * and `uint256` (`UintSet`) are supported.
1270  */
1271 library EnumerableSet {
1272     // To implement this library for multiple types with as little code
1273     // repetition as possible, we write it in terms of a generic Set type with
1274     // bytes32 values.
1275     // The Set implementation uses private functions, and user-facing
1276     // implementations (such as AddressSet) are just wrappers around the
1277     // underlying Set.
1278     // This means that we can only create new EnumerableSets for types that fit
1279     // in bytes32.
1280 
1281     struct Set {
1282         // Storage of set values
1283         bytes32[] _values;
1284         // Position of the value in the `values` array, plus 1 because index 0
1285         // means a value is not in the set.
1286         mapping(bytes32 => uint256) _indexes;
1287     }
1288 
1289     /**
1290      * @dev Add a value to a set. O(1).
1291      *
1292      * Returns true if the value was added to the set, that is if it was not
1293      * already present.
1294      */
1295     function _add(Set storage set, bytes32 value) private returns (bool) {
1296         if (!_contains(set, value)) {
1297             set._values.push(value);
1298             // The value is stored at length-1, but we add 1 to all indexes
1299             // and use 0 as a sentinel value
1300             set._indexes[value] = set._values.length;
1301             return true;
1302         } else {
1303             return false;
1304         }
1305     }
1306 
1307     /**
1308      * @dev Removes a value from a set. O(1).
1309      *
1310      * Returns true if the value was removed from the set, that is if it was
1311      * present.
1312      */
1313     function _remove(Set storage set, bytes32 value) private returns (bool) {
1314         // We read and store the value's index to prevent multiple reads from the same storage slot
1315         uint256 valueIndex = set._indexes[value];
1316 
1317         if (valueIndex != 0) {
1318             // Equivalent to contains(set, value)
1319             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
1320             // the array, and then remove the last element (sometimes called as 'swap and pop').
1321             // This modifies the order of the array, as noted in {at}.
1322 
1323             uint256 toDeleteIndex = valueIndex - 1;
1324             uint256 lastIndex = set._values.length - 1;
1325 
1326             if (lastIndex != toDeleteIndex) {
1327                 bytes32 lastValue = set._values[lastIndex];
1328 
1329                 // Move the last value to the index where the value to delete is
1330                 set._values[toDeleteIndex] = lastValue;
1331                 // Update the index for the moved value
1332                 set._indexes[lastValue] = valueIndex; // Replace lastValue's index to valueIndex
1333             }
1334 
1335             // Delete the slot where the moved value was stored
1336             set._values.pop();
1337 
1338             // Delete the index for the deleted slot
1339             delete set._indexes[value];
1340 
1341             return true;
1342         } else {
1343             return false;
1344         }
1345     }
1346 
1347     /**
1348      * @dev Returns true if the value is in the set. O(1).
1349      */
1350     function _contains(Set storage set, bytes32 value) private view returns (bool) {
1351         return set._indexes[value] != 0;
1352     }
1353 
1354     /**
1355      * @dev Returns the number of values on the set. O(1).
1356      */
1357     function _length(Set storage set) private view returns (uint256) {
1358         return set._values.length;
1359     }
1360 
1361     /**
1362      * @dev Returns the value stored at position `index` in the set. O(1).
1363      *
1364      * Note that there are no guarantees on the ordering of values inside the
1365      * array, and it may change when more values are added or removed.
1366      *
1367      * Requirements:
1368      *
1369      * - `index` must be strictly less than {length}.
1370      */
1371     function _at(Set storage set, uint256 index) private view returns (bytes32) {
1372         return set._values[index];
1373     }
1374 
1375     /**
1376      * @dev Return the entire set in an array
1377      *
1378      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
1379      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
1380      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
1381      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
1382      */
1383     function _values(Set storage set) private view returns (bytes32[] memory) {
1384         return set._values;
1385     }
1386 
1387     // Bytes32Set
1388 
1389     struct Bytes32Set {
1390         Set _inner;
1391     }
1392 
1393     /**
1394      * @dev Add a value to a set. O(1).
1395      *
1396      * Returns true if the value was added to the set, that is if it was not
1397      * already present.
1398      */
1399     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
1400         return _add(set._inner, value);
1401     }
1402 
1403     /**
1404      * @dev Removes a value from a set. O(1).
1405      *
1406      * Returns true if the value was removed from the set, that is if it was
1407      * present.
1408      */
1409     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
1410         return _remove(set._inner, value);
1411     }
1412 
1413     /**
1414      * @dev Returns true if the value is in the set. O(1).
1415      */
1416     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
1417         return _contains(set._inner, value);
1418     }
1419 
1420     /**
1421      * @dev Returns the number of values in the set. O(1).
1422      */
1423     function length(Bytes32Set storage set) internal view returns (uint256) {
1424         return _length(set._inner);
1425     }
1426 
1427     /**
1428      * @dev Returns the value stored at position `index` in the set. O(1).
1429      *
1430      * Note that there are no guarantees on the ordering of values inside the
1431      * array, and it may change when more values are added or removed.
1432      *
1433      * Requirements:
1434      *
1435      * - `index` must be strictly less than {length}.
1436      */
1437     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
1438         return _at(set._inner, index);
1439     }
1440 
1441     /**
1442      * @dev Return the entire set in an array
1443      *
1444      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
1445      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
1446      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
1447      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
1448      */
1449     function values(Bytes32Set storage set) internal view returns (bytes32[] memory) {
1450         return _values(set._inner);
1451     }
1452 
1453     // AddressSet
1454 
1455     struct AddressSet {
1456         Set _inner;
1457     }
1458 
1459     /**
1460      * @dev Add a value to a set. O(1).
1461      *
1462      * Returns true if the value was added to the set, that is if it was not
1463      * already present.
1464      */
1465     function add(AddressSet storage set, address value) internal returns (bool) {
1466         return _add(set._inner, bytes32(uint256(uint160(value))));
1467     }
1468 
1469     /**
1470      * @dev Removes a value from a set. O(1).
1471      *
1472      * Returns true if the value was removed from the set, that is if it was
1473      * present.
1474      */
1475     function remove(AddressSet storage set, address value) internal returns (bool) {
1476         return _remove(set._inner, bytes32(uint256(uint160(value))));
1477     }
1478 
1479     /**
1480      * @dev Returns true if the value is in the set. O(1).
1481      */
1482     function contains(AddressSet storage set, address value) internal view returns (bool) {
1483         return _contains(set._inner, bytes32(uint256(uint160(value))));
1484     }
1485 
1486     /**
1487      * @dev Returns the number of values in the set. O(1).
1488      */
1489     function length(AddressSet storage set) internal view returns (uint256) {
1490         return _length(set._inner);
1491     }
1492 
1493     /**
1494      * @dev Returns the value stored at position `index` in the set. O(1).
1495      *
1496      * Note that there are no guarantees on the ordering of values inside the
1497      * array, and it may change when more values are added or removed.
1498      *
1499      * Requirements:
1500      *
1501      * - `index` must be strictly less than {length}.
1502      */
1503     function at(AddressSet storage set, uint256 index) internal view returns (address) {
1504         return address(uint160(uint256(_at(set._inner, index))));
1505     }
1506 
1507     /**
1508      * @dev Return the entire set in an array
1509      *
1510      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
1511      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
1512      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
1513      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
1514      */
1515     function values(AddressSet storage set) internal view returns (address[] memory) {
1516         bytes32[] memory store = _values(set._inner);
1517         address[] memory result;
1518 
1519         assembly {
1520             result := store
1521         }
1522 
1523         return result;
1524     }
1525 
1526     // UintSet
1527 
1528     struct UintSet {
1529         Set _inner;
1530     }
1531 
1532     /**
1533      * @dev Add a value to a set. O(1).
1534      *
1535      * Returns true if the value was added to the set, that is if it was not
1536      * already present.
1537      */
1538     function add(UintSet storage set, uint256 value) internal returns (bool) {
1539         return _add(set._inner, bytes32(value));
1540     }
1541 
1542     /**
1543      * @dev Removes a value from a set. O(1).
1544      *
1545      * Returns true if the value was removed from the set, that is if it was
1546      * present.
1547      */
1548     function remove(UintSet storage set, uint256 value) internal returns (bool) {
1549         return _remove(set._inner, bytes32(value));
1550     }
1551 
1552     /**
1553      * @dev Returns true if the value is in the set. O(1).
1554      */
1555     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
1556         return _contains(set._inner, bytes32(value));
1557     }
1558 
1559     /**
1560      * @dev Returns the number of values on the set. O(1).
1561      */
1562     function length(UintSet storage set) internal view returns (uint256) {
1563         return _length(set._inner);
1564     }
1565 
1566     /**
1567      * @dev Returns the value stored at position `index` in the set. O(1).
1568      *
1569      * Note that there are no guarantees on the ordering of values inside the
1570      * array, and it may change when more values are added or removed.
1571      *
1572      * Requirements:
1573      *
1574      * - `index` must be strictly less than {length}.
1575      */
1576     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
1577         return uint256(_at(set._inner, index));
1578     }
1579 
1580     /**
1581      * @dev Return the entire set in an array
1582      *
1583      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
1584      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
1585      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
1586      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
1587      */
1588     function values(UintSet storage set) internal view returns (uint256[] memory) {
1589         bytes32[] memory store = _values(set._inner);
1590         uint256[] memory result;
1591 
1592         assembly {
1593             result := store
1594         }
1595 
1596         return result;
1597     }
1598 }
1599 
1600 
1601 // File @openzeppelin/contracts/access/AccessControlEnumerable.sol@v4.6.0
1602 
1603 // OpenZeppelin Contracts (last updated v4.5.0) (access/AccessControlEnumerable.sol)
1604 
1605 pragma solidity ^0.8.0;
1606 
1607 
1608 
1609 /**
1610  * @dev Extension of {AccessControl} that allows enumerating the members of each role.
1611  */
1612 abstract contract AccessControlEnumerable is IAccessControlEnumerable, AccessControl {
1613     using EnumerableSet for EnumerableSet.AddressSet;
1614 
1615     mapping(bytes32 => EnumerableSet.AddressSet) private _roleMembers;
1616 
1617     /**
1618      * @dev See {IERC165-supportsInterface}.
1619      */
1620     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1621         return interfaceId == type(IAccessControlEnumerable).interfaceId || super.supportsInterface(interfaceId);
1622     }
1623 
1624     /**
1625      * @dev Returns one of the accounts that have `role`. `index` must be a
1626      * value between 0 and {getRoleMemberCount}, non-inclusive.
1627      *
1628      * Role bearers are not sorted in any particular way, and their ordering may
1629      * change at any point.
1630      *
1631      * WARNING: When using {getRoleMember} and {getRoleMemberCount}, make sure
1632      * you perform all queries on the same block. See the following
1633      * https://forum.openzeppelin.com/t/iterating-over-elements-on-enumerableset-in-openzeppelin-contracts/2296[forum post]
1634      * for more information.
1635      */
1636     function getRoleMember(bytes32 role, uint256 index) public view virtual override returns (address) {
1637         return _roleMembers[role].at(index);
1638     }
1639 
1640     /**
1641      * @dev Returns the number of accounts that have `role`. Can be used
1642      * together with {getRoleMember} to enumerate all bearers of a role.
1643      */
1644     function getRoleMemberCount(bytes32 role) public view virtual override returns (uint256) {
1645         return _roleMembers[role].length();
1646     }
1647 
1648     /**
1649      * @dev Overload {_grantRole} to track enumerable memberships
1650      */
1651     function _grantRole(bytes32 role, address account) internal virtual override {
1652         super._grantRole(role, account);
1653         _roleMembers[role].add(account);
1654     }
1655 
1656     /**
1657      * @dev Overload {_revokeRole} to track enumerable memberships
1658      */
1659     function _revokeRole(bytes32 role, address account) internal virtual override {
1660         super._revokeRole(role, account);
1661         _roleMembers[role].remove(account);
1662     }
1663 }
1664 
1665 
1666 // File contracts/lib/AccessControlMixin.sol
1667 
1668 pragma solidity ^0.8.0;
1669 
1670 contract AccessControlMixin is AccessControlEnumerable {
1671     string private _revertMsg;
1672 
1673     function _setupContractId(string memory contractId) internal {
1674         _revertMsg = string(
1675             abi.encodePacked(contractId, ": INSUFFICIENT_PERMISSIONS")
1676         );
1677     }
1678 
1679     modifier only(bytes32 role) {
1680         require(hasRole(role, _msgSender()), "role not granted");
1681         _;
1682     }
1683 
1684     function getAllRoles(bytes32 role) internal view returns(address[] memory) {
1685         uint256 count = getRoleMemberCount(role);
1686         address[] memory list = new address[](count);
1687 
1688         for (uint256 i = 0; i < count; i++) {
1689             list[i] = getRoleMember(role, i);
1690         }
1691 
1692         return list;
1693     }
1694 
1695     function removeAllRoles(bytes32 role) internal {
1696         address[] memory roles = getAllRoles(role);
1697 
1698         for (uint i = 0 ; i < roles.length; i++) {
1699             _revokeRole(role, roles[i]);
1700         }
1701     }
1702 }
1703 
1704 
1705 // File contracts/lib/IPegERC20.sol
1706 
1707 pragma solidity ^0.8.0;
1708 
1709 interface IPegERC20 {
1710     function domainSeparator() external view returns (string memory);
1711 
1712     function metaTransfer(
1713         address sender,
1714         address recipient,
1715         uint256 amount
1716     ) external;
1717 
1718     function metaApprove(
1719         address owner,
1720         address spender,
1721         uint256 amount
1722     ) external;
1723 
1724     function metaIncreaseAllowance(
1725         address owner,
1726         address spender,
1727         uint256 increment
1728     ) external;
1729 
1730     function metaDecreaseAllowance(
1731         address owner,
1732         address spender,
1733         uint256 decrement
1734     ) external;
1735 }
1736 
1737 
1738 // File contracts/lib/PegERC20.sol
1739 
1740 pragma solidity ^0.8.0;
1741 
1742 
1743 
1744 contract PegERC20 is IPegERC20, ERC20, AccessControlMixin {
1745     using Address for address;
1746 
1747     bytes32 public constant META_TX_ROLE = keccak256("META_TX_ROLE");
1748 
1749 
1750     constructor(string memory name_, string memory symbol_) ERC20(name_, symbol_) {
1751     }
1752     // ************ peg functions ********************
1753     function domainSeparator()
1754         public
1755         view
1756         override
1757         returns (string memory)
1758     {
1759         return symbol();
1760     }
1761     function metaTransfer(address sender, address recipient, uint256 amount)
1762         public
1763         override
1764         only(META_TX_ROLE)
1765     {
1766         _transfer(sender, recipient, amount);
1767     }
1768 
1769     function metaApprove(
1770         address owner,
1771         address spender,
1772         uint256 amount
1773     )
1774         public
1775         override
1776         only(META_TX_ROLE)
1777     {
1778         _approve(owner, spender, amount);
1779     }
1780 
1781     function metaIncreaseAllowance(
1782         address owner,
1783         address spender,
1784         uint256 increment
1785     )
1786         public
1787         override
1788         only(META_TX_ROLE)
1789     {
1790         _increaseAllowance(owner, spender, increment);
1791     }
1792 
1793     function metaDecreaseAllowance(
1794         address owner,
1795         address spender,
1796         uint256 decrement
1797     )
1798         public
1799         override
1800         only(META_TX_ROLE)
1801     {
1802         _decreaseAllowance(owner, spender, decrement);
1803     }
1804 }
1805 
1806 
1807 // File contracts/lib/Administrable/Pausable.sol
1808 
1809 pragma solidity ^0.8.0;
1810 
1811 abstract contract Pausable is AccessControlMixin {
1812     bytes32 public constant PAUSER_ROLE = keccak256("PAUSER_ROLE");
1813 
1814     event Pause();
1815     event Unpause();
1816 
1817     bool internal _paused = false;
1818 
1819     /**
1820      * @notice Throws if this contract is paused
1821      */
1822     modifier whenNotPaused() {
1823         require(!_paused, "Pausable: paused");
1824         _;
1825     }
1826 
1827     /**
1828      * @notice Return the members of the pauser role
1829      * @return Addresses
1830      */
1831     function pausers() public view returns (address[] memory) {
1832         uint256 count = getRoleMemberCount(PAUSER_ROLE);
1833         address[] memory list = new address[](count);
1834 
1835         for (uint256 i = 0; i < count; i++) {
1836             list[i] = getRoleMember(PAUSER_ROLE, i);
1837         }
1838 
1839         return list;
1840     }
1841 
1842     /**
1843      * @notice Returns whether this contract is paused
1844      * @return True if paused
1845      */
1846     function paused() public view returns (bool) {
1847         return _paused;
1848     }
1849 
1850     /**
1851      * @notice Pause this contract
1852      */
1853     function pause() public only(PAUSER_ROLE) {
1854         _paused = true;
1855         emit Pause();
1856     }
1857 
1858     /**
1859      * @notice Unpause this contract
1860      */
1861     function unpause() public only(PAUSER_ROLE) {
1862         _paused = false;
1863         emit Unpause();
1864     }
1865 }
1866 
1867 
1868 // File contracts/CubePegERC20.sol
1869 
1870 pragma solidity ^0.8.0;
1871 
1872 
1873 contract CubePegERC20 is PegERC20, Pausable {
1874     bytes32 public constant OWNER_ROLE = keccak256("OWNER_ROLE");
1875     bytes32 public constant OPERATOR_ROLE = keccak256("OPERATOR_ROLE");
1876 
1877     using Address for address;
1878 
1879     event AdminTransfered(address indexed oldAdmin, address indexed newAdmin);
1880     event MetaRoleSet(address indexed metaAddr, bool toGrant);
1881 
1882     constructor(address operator,address pauser,string memory name, string memory symbol,uint8 decimal) PegERC20(name, symbol) {
1883         _grantRole(OWNER_ROLE, msg.sender);
1884         _grantRole(OPERATOR_ROLE, operator);
1885         _grantRole(PAUSER_ROLE, pauser);
1886         _setupDecimals(decimal);
1887     }
1888 
1889     function transferAdmin(address oldAdmin, address newAdmin)
1890         public
1891         only(OWNER_ROLE)
1892     {
1893         _revokeRole(OWNER_ROLE, oldAdmin);
1894         _grantRole(OWNER_ROLE, newAdmin);
1895 
1896         emit AdminTransfered(oldAdmin, newAdmin);
1897     }
1898 
1899     /**
1900     * @notice to set meta peg contract address as caller of MetaPegERC20
1901     * @param metaAddr the address of meta peg contact
1902     * @param toGrant true to set up role, false to remove role
1903     */
1904     function setMetaRole(address metaAddr, bool toGrant)
1905         public
1906         only(OWNER_ROLE)
1907     {
1908         require(metaAddr.isContract(), "meta peg should be contract address");
1909 
1910         if (toGrant) {
1911             _grantRole(META_TX_ROLE, metaAddr);
1912         } else {
1913             _revokeRole(META_TX_ROLE, metaAddr);
1914         }
1915 
1916         emit MetaRoleSet(metaAddr, toGrant);
1917     }
1918 
1919     function mint(address recipient, uint256 amount)
1920         public
1921         only(OPERATOR_ROLE)
1922     {
1923         _mint(recipient, amount);
1924     }
1925 
1926     function burn(address account, uint256 amount)
1927         public
1928         only(OPERATOR_ROLE)
1929     {
1930         _burn(account, amount);
1931     }
1932 
1933     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override {
1934         super._beforeTokenTransfer(from, to, amount);
1935 
1936         require(!paused(), "ERC20Pausable: token transfer while paused");
1937     }
1938 
1939     function addRole(bytes32 role, address account)
1940         public
1941         only(OWNER_ROLE)
1942     {
1943         require(account != address(0), "can not grant to null address");
1944         _grantRole(role, account);
1945         emit RoleGranted(role, account, msg.sender);
1946     }
1947 
1948     function removeRole(bytes32 role, address account)
1949         public
1950         only(OWNER_ROLE)
1951     {
1952         _revokeRole(role, account);
1953         emit RoleRevoked(role, account, msg.sender);
1954     }
1955 }