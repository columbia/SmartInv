1 /**
2  *Submitted for verification at Etherscan.io on 2022-02-04
3 */
4 
5 // File: contracts/MasRelic.sol
6 
7 /**
8  *Submitted for verification at Etherscan.io on 2021-12-11
9 */
10 
11 // Verified using https://dapp.tools
12 
13 // hevm: flattened sources of src/MasRelic.sol
14 
15 pragma solidity =0.8.10 >=0.8.0 <0.9.0;
16 pragma experimental ABIEncoderV2;
17 
18 ////// lib/openzeppelin-contracts/contracts/utils/Context.sol
19 // OpenZeppelin Contracts v4.4.0 (utils/Context.sol)
20 
21 /* pragma solidity ^0.8.0; */
22 
23 /**
24  * @dev Provides information about the current execution context, including the
25  * sender of the transaction and its data. While these are generally available
26  * via msg.sender and msg.data, they should not be accessed in such a direct
27  * manner, since when dealing with meta-transactions the account sending and
28  * paying for execution may not be the actual sender (as far as an application
29  * is concerned).
30  *
31  * This contract is only required for intermediate, library-like contracts.
32  */
33 abstract contract Context {
34     function _msgSender() internal view virtual returns (address) {
35         return msg.sender;
36     }
37 
38     function _msgData() internal view virtual returns (bytes calldata) {
39         return msg.data;
40     }
41 }
42 
43 ////// lib/openzeppelin-contracts/contracts/access/Ownable.sol
44 // OpenZeppelin Contracts v4.4.0 (access/Ownable.sol)
45 
46 /* pragma solidity ^0.8.0; */
47 
48 /* import "../utils/Context.sol"; */
49 
50 /**
51  * @dev Contract module which provides a basic access control mechanism, where
52  * there is an account (an owner) that can be granted exclusive access to
53  * specific functions.
54  *
55  * By default, the owner account will be the one that deploys the contract. This
56  * can later be changed with {transferOwnership}.
57  *
58  * This module is used through inheritance. It will make available the modifier
59  * `onlyOwner`, which can be applied to your functions to restrict their use to
60  * the owner.
61  */
62 abstract contract Ownable is Context {
63     address private _owner;
64 
65     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
66 
67     /**
68      * @dev Initializes the contract setting the deployer as the initial owner.
69      */
70     constructor() {
71         _transferOwnership(_msgSender());
72     }
73 
74     /**
75      * @dev Returns the address of the current owner.
76      */
77     function owner() public view virtual returns (address) {
78         return _owner;
79     }
80 
81     /**
82      * @dev Throws if called by any account other than the owner.
83      */
84     modifier onlyOwner() {
85         require(owner() == _msgSender(), "Ownable: caller is not the owner");
86         _;
87     }
88 
89     /**
90      * @dev Leaves the contract without owner. It will not be possible to call
91      * `onlyOwner` functions anymore. Can only be called by the current owner.
92      *
93      * NOTE: Renouncing ownership will leave the contract without an owner,
94      * thereby removing any functionality that is only available to the owner.
95      */
96     function renounceOwnership() public virtual onlyOwner {
97         _transferOwnership(address(0));
98     }
99 
100     /**
101      * @dev Transfers ownership of the contract to a new account (`newOwner`).
102      * Can only be called by the current owner.
103      */
104     function transferOwnership(address newOwner) public virtual onlyOwner {
105         require(newOwner != address(0), "Ownable: new owner is the zero address");
106         _transferOwnership(newOwner);
107     }
108 
109     /**
110      * @dev Transfers ownership of the contract to a new account (`newOwner`).
111      * Internal function without access restriction.
112      */
113     function _transferOwnership(address newOwner) internal virtual {
114         address oldOwner = _owner;
115         _owner = newOwner;
116         emit OwnershipTransferred(oldOwner, newOwner);
117     }
118 }
119 
120 ////// lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol
121 // OpenZeppelin Contracts v4.4.0 (token/ERC20/IERC20.sol)
122 
123 /* pragma solidity ^0.8.0; */
124 
125 /**
126  * @dev Interface of the ERC20 standard as defined in the EIP.
127  */
128 interface IERC20 {
129     /**
130      * @dev Returns the amount of tokens in existence.
131      */
132     function totalSupply() external view returns (uint256);
133 
134     /**
135      * @dev Returns the amount of tokens owned by `account`.
136      */
137     function balanceOf(address account) external view returns (uint256);
138 
139     /**
140      * @dev Moves `amount` tokens from the caller's account to `recipient`.
141      *
142      * Returns a boolean value indicating whether the operation succeeded.
143      *
144      * Emits a {Transfer} event.
145      */
146     function transfer(address recipient, uint256 amount) external returns (bool);
147 
148     /**
149      * @dev Returns the remaining number of tokens that `spender` will be
150      * allowed to spend on behalf of `owner` through {transferFrom}. This is
151      * zero by default.
152      *
153      * This value changes when {approve} or {transferFrom} are called.
154      */
155     function allowance(address owner, address spender) external view returns (uint256);
156 
157     /**
158      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
159      *
160      * Returns a boolean value indicating whether the operation succeeded.
161      *
162      * IMPORTANT: Beware that changing an allowance with this method brings the risk
163      * that someone may use both the old and the new allowance by unfortunate
164      * transaction ordering. One possible solution to mitigate this race
165      * condition is to first reduce the spender's allowance to 0 and set the
166      * desired value afterwards:
167      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
168      *
169      * Emits an {Approval} event.
170      */
171     function approve(address spender, uint256 amount) external returns (bool);
172 
173     /**
174      * @dev Moves `amount` tokens from `sender` to `recipient` using the
175      * allowance mechanism. `amount` is then deducted from the caller's
176      * allowance.
177      *
178      * Returns a boolean value indicating whether the operation succeeded.
179      *
180      * Emits a {Transfer} event.
181      */
182     function transferFrom(
183         address sender,
184         address recipient,
185         uint256 amount
186     ) external returns (bool);
187 
188     /**
189      * @dev Emitted when `value` tokens are moved from one account (`from`) to
190      * another (`to`).
191      *
192      * Note that `value` may be zero.
193      */
194     event Transfer(address indexed from, address indexed to, uint256 value);
195 
196     /**
197      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
198      * a call to {approve}. `value` is the new allowance.
199      */
200     event Approval(address indexed owner, address indexed spender, uint256 value);
201 }
202 
203 ////// lib/openzeppelin-contracts/contracts/token/ERC20/extensions/IERC20Metadata.sol
204 // OpenZeppelin Contracts v4.4.0 (token/ERC20/extensions/IERC20Metadata.sol)
205 
206 /* pragma solidity ^0.8.0; */
207 
208 /* import "../IERC20.sol"; */
209 
210 /**
211  * @dev Interface for the optional metadata functions from the ERC20 standard.
212  *
213  * _Available since v4.1._
214  */
215 interface IERC20Metadata is IERC20 {
216     /**
217      * @dev Returns the name of the token.
218      */
219     function name() external view returns (string memory);
220 
221     /**
222      * @dev Returns the symbol of the token.
223      */
224     function symbol() external view returns (string memory);
225 
226     /**
227      * @dev Returns the decimals places of the token.
228      */
229     function decimals() external view returns (uint8);
230 }
231 
232 ////// lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol
233 // OpenZeppelin Contracts v4.4.0 (token/ERC20/ERC20.sol)
234 
235 /* pragma solidity ^0.8.0; */
236 
237 /* import "./IERC20.sol"; */
238 /* import "./extensions/IERC20Metadata.sol"; */
239 /* import "../../utils/Context.sol"; */
240 
241 /**
242  * @dev Implementation of the {IERC20} interface.
243  *
244  * This implementation is agnostic to the way tokens are created. This means
245  * that a supply mechanism has to be added in a derived contract using {_mint}.
246  * For a generic mechanism see {ERC20PresetMinterPauser}.
247  *
248  * TIP: For a detailed writeup see our guide
249  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
250  * to implement supply mechanisms].
251  *
252  * We have followed general OpenZeppelin Contracts guidelines: functions revert
253  * instead returning `false` on failure. This behavior is nonetheless
254  * conventional and does not conflict with the expectations of ERC20
255  * applications.
256  *
257  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
258  * This allows applications to reconstruct the allowance for all accounts just
259  * by listening to said events. Other implementations of the EIP may not emit
260  * these events, as it isn't required by the specification.
261  *
262  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
263  * functions have been added to mitigate the well-known issues around setting
264  * allowances. See {IERC20-approve}.
265  */
266 contract ERC20 is Context, IERC20, IERC20Metadata {
267     mapping(address => uint256) private _balances;
268 
269     mapping(address => mapping(address => uint256)) private _allowances;
270 
271     uint256 private _totalSupply;
272 
273     string private _name;
274     string private _symbol;
275 
276     /**
277      * @dev Sets the values for {name} and {symbol}.
278      *
279      * The default value of {decimals} is 18. To select a different value for
280      * {decimals} you should overload it.
281      *
282      * All two of these values are immutable: they can only be set once during
283      * construction.
284      */
285     constructor(string memory name_, string memory symbol_) {
286         _name = name_;
287         _symbol = symbol_;
288     }
289 
290     /**
291      * @dev Returns the name of the token.
292      */
293     function name() public view virtual override returns (string memory) {
294         return _name;
295     }
296 
297     /**
298      * @dev Returns the symbol of the token, usually a shorter version of the
299      * name.
300      */
301     function symbol() public view virtual override returns (string memory) {
302         return _symbol;
303     }
304 
305     /**
306      * @dev Returns the number of decimals used to get its user representation.
307      * For example, if `decimals` equals `2`, a balance of `505` tokens should
308      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
309      *
310      * Tokens usually opt for a value of 18, imitating the relationship between
311      * Ether and Wei. This is the value {ERC20} uses, unless this function is
312      * overridden;
313      *
314      * NOTE: This information is only used for _display_ purposes: it in
315      * no way affects any of the arithmetic of the contract, including
316      * {IERC20-balanceOf} and {IERC20-transfer}.
317      */
318     function decimals() public view virtual override returns (uint8) {
319         return 18;
320     }
321 
322     /**
323      * @dev See {IERC20-totalSupply}.
324      */
325     function totalSupply() public view virtual override returns (uint256) {
326         return _totalSupply;
327     }
328 
329     /**
330      * @dev See {IERC20-balanceOf}.
331      */
332     function balanceOf(address account) public view virtual override returns (uint256) {
333         return _balances[account];
334     }
335 
336     /**
337      * @dev See {IERC20-transfer}.
338      *
339      * Requirements:
340      *
341      * - `recipient` cannot be the zero address.
342      * - the caller must have a balance of at least `amount`.
343      */
344     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
345         _transfer(_msgSender(), recipient, amount);
346         return true;
347     }
348 
349     /**
350      * @dev See {IERC20-allowance}.
351      */
352     function allowance(address owner, address spender) public view virtual override returns (uint256) {
353         return _allowances[owner][spender];
354     }
355 
356     /**
357      * @dev See {IERC20-approve}.
358      *
359      * Requirements:
360      *
361      * - `spender` cannot be the zero address.
362      */
363     function approve(address spender, uint256 amount) public virtual override returns (bool) {
364         _approve(_msgSender(), spender, amount);
365         return true;
366     }
367 
368     /**
369      * @dev See {IERC20-transferFrom}.
370      *
371      * Emits an {Approval} event indicating the updated allowance. This is not
372      * required by the EIP. See the note at the beginning of {ERC20}.
373      *
374      * Requirements:
375      *
376      * - `sender` and `recipient` cannot be the zero address.
377      * - `sender` must have a balance of at least `amount`.
378      * - the caller must have allowance for ``sender``'s tokens of at least
379      * `amount`.
380      */
381     function transferFrom(
382         address sender,
383         address recipient,
384         uint256 amount
385     ) public virtual override returns (bool) {
386         _transfer(sender, recipient, amount);
387 
388         uint256 currentAllowance = _allowances[sender][_msgSender()];
389         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
390         unchecked {
391             _approve(sender, _msgSender(), currentAllowance - amount);
392         }
393 
394         return true;
395     }
396 
397     /**
398      * @dev Atomically increases the allowance granted to `spender` by the caller.
399      *
400      * This is an alternative to {approve} that can be used as a mitigation for
401      * problems described in {IERC20-approve}.
402      *
403      * Emits an {Approval} event indicating the updated allowance.
404      *
405      * Requirements:
406      *
407      * - `spender` cannot be the zero address.
408      */
409     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
410         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
411         return true;
412     }
413 
414     /**
415      * @dev Atomically decreases the allowance granted to `spender` by the caller.
416      *
417      * This is an alternative to {approve} that can be used as a mitigation for
418      * problems described in {IERC20-approve}.
419      *
420      * Emits an {Approval} event indicating the updated allowance.
421      *
422      * Requirements:
423      *
424      * - `spender` cannot be the zero address.
425      * - `spender` must have allowance for the caller of at least
426      * `subtractedValue`.
427      */
428     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
429         uint256 currentAllowance = _allowances[_msgSender()][spender];
430         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
431         unchecked {
432             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
433         }
434 
435         return true;
436     }
437 
438     /**
439      * @dev Moves `amount` of tokens from `sender` to `recipient`.
440      *
441      * This internal function is equivalent to {transfer}, and can be used to
442      * e.g. implement automatic token fees, slashing mechanisms, etc.
443      *
444      * Emits a {Transfer} event.
445      *
446      * Requirements:
447      *
448      * - `sender` cannot be the zero address.
449      * - `recipient` cannot be the zero address.
450      * - `sender` must have a balance of at least `amount`.
451      */
452     function _transfer(
453         address sender,
454         address recipient,
455         uint256 amount
456     ) internal virtual {
457         require(sender != address(0), "ERC20: transfer from the zero address");
458         require(recipient != address(0), "ERC20: transfer to the zero address");
459 
460         _beforeTokenTransfer(sender, recipient, amount);
461 
462         uint256 senderBalance = _balances[sender];
463         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
464         unchecked {
465             _balances[sender] = senderBalance - amount;
466         }
467         _balances[recipient] += amount;
468 
469         emit Transfer(sender, recipient, amount);
470 
471         _afterTokenTransfer(sender, recipient, amount);
472     }
473 
474     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
475      * the total supply.
476      *
477      * Emits a {Transfer} event with `from` set to the zero address.
478      *
479      * Requirements:
480      *
481      * - `account` cannot be the zero address.
482      */
483     function _mint(address account, uint256 amount) internal virtual {
484         require(account != address(0), "ERC20: mint to the zero address");
485 
486         _beforeTokenTransfer(address(0), account, amount);
487 
488         _totalSupply += amount;
489         _balances[account] += amount;
490         emit Transfer(address(0), account, amount);
491 
492         _afterTokenTransfer(address(0), account, amount);
493     }
494 
495     /**
496      * @dev Destroys `amount` tokens from `account`, reducing the
497      * total supply.
498      *
499      * Emits a {Transfer} event with `to` set to the zero address.
500      *
501      * Requirements:
502      *
503      * - `account` cannot be the zero address.
504      * - `account` must have at least `amount` tokens.
505      */
506     function _burn(address account, uint256 amount) internal virtual {
507         require(account != address(0), "ERC20: burn from the zero address");
508 
509         _beforeTokenTransfer(account, address(0), amount);
510 
511         uint256 accountBalance = _balances[account];
512         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
513         unchecked {
514             _balances[account] = accountBalance - amount;
515         }
516         _totalSupply -= amount;
517 
518         emit Transfer(account, address(0), amount);
519 
520         _afterTokenTransfer(account, address(0), amount);
521     }
522 
523     /**
524      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
525      *
526      * This internal function is equivalent to `approve`, and can be used to
527      * e.g. set automatic allowances for certain subsystems, etc.
528      *
529      * Emits an {Approval} event.
530      *
531      * Requirements:
532      *
533      * - `owner` cannot be the zero address.
534      * - `spender` cannot be the zero address.
535      */
536     function _approve(
537         address owner,
538         address spender,
539         uint256 amount
540     ) internal virtual {
541         require(owner != address(0), "ERC20: approve from the zero address");
542         require(spender != address(0), "ERC20: approve to the zero address");
543 
544         _allowances[owner][spender] = amount;
545         emit Approval(owner, spender, amount);
546     }
547 
548     /**
549      * @dev Hook that is called before any transfer of tokens. This includes
550      * minting and burning.
551      *
552      * Calling conditions:
553      *
554      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
555      * will be transferred to `to`.
556      * - when `from` is zero, `amount` tokens will be minted for `to`.
557      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
558      * - `from` and `to` are never both zero.
559      *
560      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
561      */
562     function _beforeTokenTransfer(
563         address from,
564         address to,
565         uint256 amount
566     ) internal virtual {}
567 
568     /**
569      * @dev Hook that is called after any transfer of tokens. This includes
570      * minting and burning.
571      *
572      * Calling conditions:
573      *
574      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
575      * has been transferred to `to`.
576      * - when `from` is zero, `amount` tokens have been minted for `to`.
577      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
578      * - `from` and `to` are never both zero.
579      *
580      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
581      */
582     function _afterTokenTransfer(
583         address from,
584         address to,
585         uint256 amount
586     ) internal virtual {}
587 }
588 
589 ////// lib/openzeppelin-contracts/contracts/utils/Address.sol
590 // OpenZeppelin Contracts v4.4.0 (utils/Address.sol)
591 
592 /* pragma solidity ^0.8.0; */
593 
594 /**
595  * @dev Collection of functions related to the address type
596  */
597 library Address {
598     /**
599      * @dev Returns true if `account` is a contract.
600      *
601      * [IMPORTANT]
602      * ====
603      * It is unsafe to assume that an address for which this function returns
604      * false is an externally-owned account (EOA) and not a contract.
605      *
606      * Among others, `isContract` will return false for the following
607      * types of addresses:
608      *
609      *  - an externally-owned account
610      *  - a contract in construction
611      *  - an address where a contract will be created
612      *  - an address where a contract lived, but was destroyed
613      * ====
614      */
615     function isContract(address account) internal view returns (bool) {
616         // This method relies on extcodesize, which returns 0 for contracts in
617         // construction, since the code is only stored at the end of the
618         // constructor execution.
619 
620         uint256 size;
621         assembly {
622             size := extcodesize(account)
623         }
624         return size > 0;
625     }
626 
627     /**
628      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
629      * `recipient`, forwarding all available gas and reverting on errors.
630      *
631      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
632      * of certain opcodes, possibly making contracts go over the 2300 gas limit
633      * imposed by `transfer`, making them unable to receive funds via
634      * `transfer`. {sendValue} removes this limitation.
635      *
636      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
637      *
638      * IMPORTANT: because control is transferred to `recipient`, care must be
639      * taken to not create reentrancy vulnerabilities. Consider using
640      * {ReentrancyGuard} or the
641      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
642      */
643     function sendValue(address payable recipient, uint256 amount) internal {
644         require(address(this).balance >= amount, "Address: insufficient balance");
645 
646         (bool success, ) = recipient.call{value: amount}("");
647         require(success, "Address: unable to send value, recipient may have reverted");
648     }
649 
650     /**
651      * @dev Performs a Solidity function call using a low level `call`. A
652      * plain `call` is an unsafe replacement for a function call: use this
653      * function instead.
654      *
655      * If `target` reverts with a revert reason, it is bubbled up by this
656      * function (like regular Solidity function calls).
657      *
658      * Returns the raw returned data. To convert to the expected return value,
659      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
660      *
661      * Requirements:
662      *
663      * - `target` must be a contract.
664      * - calling `target` with `data` must not revert.
665      *
666      * _Available since v3.1._
667      */
668     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
669         return functionCall(target, data, "Address: low-level call failed");
670     }
671 
672     /**
673      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
674      * `errorMessage` as a fallback revert reason when `target` reverts.
675      *
676      * _Available since v3.1._
677      */
678     function functionCall(
679         address target,
680         bytes memory data,
681         string memory errorMessage
682     ) internal returns (bytes memory) {
683         return functionCallWithValue(target, data, 0, errorMessage);
684     }
685 
686     /**
687      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
688      * but also transferring `value` wei to `target`.
689      *
690      * Requirements:
691      *
692      * - the calling contract must have an ETH balance of at least `value`.
693      * - the called Solidity function must be `payable`.
694      *
695      * _Available since v3.1._
696      */
697     function functionCallWithValue(
698         address target,
699         bytes memory data,
700         uint256 value
701     ) internal returns (bytes memory) {
702         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
703     }
704 
705     /**
706      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
707      * with `errorMessage` as a fallback revert reason when `target` reverts.
708      *
709      * _Available since v3.1._
710      */
711     function functionCallWithValue(
712         address target,
713         bytes memory data,
714         uint256 value,
715         string memory errorMessage
716     ) internal returns (bytes memory) {
717         require(address(this).balance >= value, "Address: insufficient balance for call");
718         require(isContract(target), "Address: call to non-contract");
719 
720         (bool success, bytes memory returndata) = target.call{value: value}(data);
721         return verifyCallResult(success, returndata, errorMessage);
722     }
723 
724     /**
725      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
726      * but performing a static call.
727      *
728      * _Available since v3.3._
729      */
730     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
731         return functionStaticCall(target, data, "Address: low-level static call failed");
732     }
733 
734     /**
735      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
736      * but performing a static call.
737      *
738      * _Available since v3.3._
739      */
740     function functionStaticCall(
741         address target,
742         bytes memory data,
743         string memory errorMessage
744     ) internal view returns (bytes memory) {
745         require(isContract(target), "Address: static call to non-contract");
746 
747         (bool success, bytes memory returndata) = target.staticcall(data);
748         return verifyCallResult(success, returndata, errorMessage);
749     }
750 
751     /**
752      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
753      * but performing a delegate call.
754      *
755      * _Available since v3.4._
756      */
757     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
758         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
759     }
760 
761     /**
762      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
763      * but performing a delegate call.
764      *
765      * _Available since v3.4._
766      */
767     function functionDelegateCall(
768         address target,
769         bytes memory data,
770         string memory errorMessage
771     ) internal returns (bytes memory) {
772         require(isContract(target), "Address: delegate call to non-contract");
773 
774         (bool success, bytes memory returndata) = target.delegatecall(data);
775         return verifyCallResult(success, returndata, errorMessage);
776     }
777 
778     /**
779      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
780      * revert reason using the provided one.
781      *
782      * _Available since v4.3._
783      */
784     function verifyCallResult(
785         bool success,
786         bytes memory returndata,
787         string memory errorMessage
788     ) internal pure returns (bytes memory) {
789         if (success) {
790             return returndata;
791         } else {
792             // Look for revert reason and bubble it up if present
793             if (returndata.length > 0) {
794                 // The easiest way to bubble the revert reason is using memory via assembly
795 
796                 assembly {
797                     let returndata_size := mload(returndata)
798                     revert(add(32, returndata), returndata_size)
799                 }
800             } else {
801                 revert(errorMessage);
802             }
803         }
804     }
805 }
806 
807 ////// lib/openzeppelin-contracts/contracts/utils/math/SafeMath.sol
808 // OpenZeppelin Contracts v4.4.0 (utils/math/SafeMath.sol)
809 
810 /* pragma solidity ^0.8.0; */
811 
812 // CAUTION
813 // This version of SafeMath should only be used with Solidity 0.8 or later,
814 // because it relies on the compiler's built in overflow checks.
815 
816 /**
817  * @dev Wrappers over Solidity's arithmetic operations.
818  *
819  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
820  * now has built in overflow checking.
821  */
822 library SafeMath {
823     /**
824      * @dev Returns the addition of two unsigned integers, with an overflow flag.
825      *
826      * _Available since v3.4._
827      */
828     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
829         unchecked {
830             uint256 c = a + b;
831             if (c < a) return (false, 0);
832             return (true, c);
833         }
834     }
835 
836     /**
837      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
838      *
839      * _Available since v3.4._
840      */
841     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
842         unchecked {
843             if (b > a) return (false, 0);
844             return (true, a - b);
845         }
846     }
847 
848     /**
849      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
850      *
851      * _Available since v3.4._
852      */
853     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
854         unchecked {
855             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
856             // benefit is lost if 'b' is also tested.
857             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
858             if (a == 0) return (true, 0);
859             uint256 c = a * b;
860             if (c / a != b) return (false, 0);
861             return (true, c);
862         }
863     }
864 
865     /**
866      * @dev Returns the division of two unsigned integers, with a division by zero flag.
867      *
868      * _Available since v3.4._
869      */
870     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
871         unchecked {
872             if (b == 0) return (false, 0);
873             return (true, a / b);
874         }
875     }
876 
877     /**
878      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
879      *
880      * _Available since v3.4._
881      */
882     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
883         unchecked {
884             if (b == 0) return (false, 0);
885             return (true, a % b);
886         }
887     }
888 
889     /**
890      * @dev Returns the addition of two unsigned integers, reverting on
891      * overflow.
892      *
893      * Counterpart to Solidity's `+` operator.
894      *
895      * Requirements:
896      *
897      * - Addition cannot overflow.
898      */
899     function add(uint256 a, uint256 b) internal pure returns (uint256) {
900         return a + b;
901     }
902 
903     /**
904      * @dev Returns the subtraction of two unsigned integers, reverting on
905      * overflow (when the result is negative).
906      *
907      * Counterpart to Solidity's `-` operator.
908      *
909      * Requirements:
910      *
911      * - Subtraction cannot overflow.
912      */
913     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
914         return a - b;
915     }
916 
917     /**
918      * @dev Returns the multiplication of two unsigned integers, reverting on
919      * overflow.
920      *
921      * Counterpart to Solidity's `*` operator.
922      *
923      * Requirements:
924      *
925      * - Multiplication cannot overflow.
926      */
927     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
928         return a * b;
929     }
930 
931     /**
932      * @dev Returns the integer division of two unsigned integers, reverting on
933      * division by zero. The result is rounded towards zero.
934      *
935      * Counterpart to Solidity's `/` operator.
936      *
937      * Requirements:
938      *
939      * - The divisor cannot be zero.
940      */
941     function div(uint256 a, uint256 b) internal pure returns (uint256) {
942         return a / b;
943     }
944 
945     /**
946      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
947      * reverting when dividing by zero.
948      *
949      * Counterpart to Solidity's `%` operator. This function uses a `revert`
950      * opcode (which leaves remaining gas untouched) while Solidity uses an
951      * invalid opcode to revert (consuming all remaining gas).
952      *
953      * Requirements:
954      *
955      * - The divisor cannot be zero.
956      */
957     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
958         return a % b;
959     }
960 
961     /**
962      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
963      * overflow (when the result is negative).
964      *
965      * CAUTION: This function is deprecated because it requires allocating memory for the error
966      * message unnecessarily. For custom revert reasons use {trySub}.
967      *
968      * Counterpart to Solidity's `-` operator.
969      *
970      * Requirements:
971      *
972      * - Subtraction cannot overflow.
973      */
974     function sub(
975         uint256 a,
976         uint256 b,
977         string memory errorMessage
978     ) internal pure returns (uint256) {
979         unchecked {
980             require(b <= a, errorMessage);
981             return a - b;
982         }
983     }
984 
985     /**
986      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
987      * division by zero. The result is rounded towards zero.
988      *
989      * Counterpart to Solidity's `/` operator. Note: this function uses a
990      * `revert` opcode (which leaves remaining gas untouched) while Solidity
991      * uses an invalid opcode to revert (consuming all remaining gas).
992      *
993      * Requirements:
994      *
995      * - The divisor cannot be zero.
996      */
997     function div(
998         uint256 a,
999         uint256 b,
1000         string memory errorMessage
1001     ) internal pure returns (uint256) {
1002         unchecked {
1003             require(b > 0, errorMessage);
1004             return a / b;
1005         }
1006     }
1007 
1008     /**
1009      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1010      * reverting with custom message when dividing by zero.
1011      *
1012      * CAUTION: This function is deprecated because it requires allocating memory for the error
1013      * message unnecessarily. For custom revert reasons use {tryMod}.
1014      *
1015      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1016      * opcode (which leaves remaining gas untouched) while Solidity uses an
1017      * invalid opcode to revert (consuming all remaining gas).
1018      *
1019      * Requirements:
1020      *
1021      * - The divisor cannot be zero.
1022      */
1023     function mod(
1024         uint256 a,
1025         uint256 b,
1026         string memory errorMessage
1027     ) internal pure returns (uint256) {
1028         unchecked {
1029             require(b > 0, errorMessage);
1030             return a % b;
1031         }
1032     }
1033 }
1034 
1035 ////// src/IUniswapV2Factory.sol
1036 /* pragma solidity 0.8.10; */
1037 /* pragma experimental ABIEncoderV2; */
1038 
1039 interface IUniswapV2Factory {
1040     event PairCreated(
1041         address indexed token0,
1042         address indexed token1,
1043         address pair,
1044         uint256
1045     );
1046 
1047     function feeTo() external view returns (address);
1048 
1049     function feeToSetter() external view returns (address);
1050 
1051     function getPair(address tokenA, address tokenB)
1052         external
1053         view
1054         returns (address pair);
1055 
1056     function allPairs(uint256) external view returns (address pair);
1057 
1058     function allPairsLength() external view returns (uint256);
1059 
1060     function createPair(address tokenA, address tokenB)
1061         external
1062         returns (address pair);
1063 
1064     function setFeeTo(address) external;
1065 
1066     function setFeeToSetter(address) external;
1067 }
1068 
1069 ////// src/IUniswapV2Pair.sol
1070 /* pragma solidity 0.8.10; */
1071 /* pragma experimental ABIEncoderV2; */
1072 
1073 interface IUniswapV2Pair {
1074     event Approval(
1075         address indexed owner,
1076         address indexed spender,
1077         uint256 value
1078     );
1079     event Transfer(address indexed from, address indexed to, uint256 value);
1080 
1081     function name() external pure returns (string memory);
1082 
1083     function symbol() external pure returns (string memory);
1084 
1085     function decimals() external pure returns (uint8);
1086 
1087     function totalSupply() external view returns (uint256);
1088 
1089     function balanceOf(address owner) external view returns (uint256);
1090 
1091     function allowance(address owner, address spender)
1092         external
1093         view
1094         returns (uint256);
1095 
1096     function approve(address spender, uint256 value) external returns (bool);
1097 
1098     function transfer(address to, uint256 value) external returns (bool);
1099 
1100     function transferFrom(
1101         address from,
1102         address to,
1103         uint256 value
1104     ) external returns (bool);
1105 
1106     function DOMAIN_SEPARATOR() external view returns (bytes32);
1107 
1108     function PERMIT_TYPEHASH() external pure returns (bytes32);
1109 
1110     function nonces(address owner) external view returns (uint256);
1111 
1112     function permit(
1113         address owner,
1114         address spender,
1115         uint256 value,
1116         uint256 deadline,
1117         uint8 v,
1118         bytes32 r,
1119         bytes32 s
1120     ) external;
1121 
1122     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
1123     event Burn(
1124         address indexed sender,
1125         uint256 amount0,
1126         uint256 amount1,
1127         address indexed to
1128     );
1129     event Swap(
1130         address indexed sender,
1131         uint256 amount0In,
1132         uint256 amount1In,
1133         uint256 amount0Out,
1134         uint256 amount1Out,
1135         address indexed to
1136     );
1137     event Sync(uint112 reserve0, uint112 reserve1);
1138 
1139     function MINIMUM_LIQUIDITY() external pure returns (uint256);
1140 
1141     function factory() external view returns (address);
1142 
1143     function token0() external view returns (address);
1144 
1145     function token1() external view returns (address);
1146 
1147     function getReserves()
1148         external
1149         view
1150         returns (
1151             uint112 reserve0,
1152             uint112 reserve1,
1153             uint32 blockTimestampLast
1154         );
1155 
1156     function price0CumulativeLast() external view returns (uint256);
1157 
1158     function price1CumulativeLast() external view returns (uint256);
1159 
1160     function kLast() external view returns (uint256);
1161 
1162     function mint(address to) external returns (uint256 liquidity);
1163 
1164     function burn(address to)
1165         external
1166         returns (uint256 amount0, uint256 amount1);
1167 
1168     function swap(
1169         uint256 amount0Out,
1170         uint256 amount1Out,
1171         address to,
1172         bytes calldata data
1173     ) external;
1174 
1175     function skim(address to) external;
1176 
1177     function sync() external;
1178 
1179     function initialize(address, address) external;
1180 }
1181 
1182 ////// src/IUniswapV2Router02.sol
1183 /* pragma solidity 0.8.10; */
1184 /* pragma experimental ABIEncoderV2; */
1185 
1186 interface IUniswapV2Router02 {
1187     function factory() external pure returns (address);
1188 
1189     function WETH() external pure returns (address);
1190 
1191     function addLiquidity(
1192         address tokenA,
1193         address tokenB,
1194         uint256 amountADesired,
1195         uint256 amountBDesired,
1196         uint256 amountAMin,
1197         uint256 amountBMin,
1198         address to,
1199         uint256 deadline
1200     )
1201         external
1202         returns (
1203             uint256 amountA,
1204             uint256 amountB,
1205             uint256 liquidity
1206         );
1207 
1208     function addLiquidityETH(
1209         address token,
1210         uint256 amountTokenDesired,
1211         uint256 amountTokenMin,
1212         uint256 amountETHMin,
1213         address to,
1214         uint256 deadline
1215     )
1216         external
1217         payable
1218         returns (
1219             uint256 amountToken,
1220             uint256 amountETH,
1221             uint256 liquidity
1222         );
1223 
1224     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
1225         uint256 amountIn,
1226         uint256 amountOutMin,
1227         address[] calldata path,
1228         address to,
1229         uint256 deadline
1230     ) external;
1231 
1232     function swapExactETHForTokensSupportingFeeOnTransferTokens(
1233         uint256 amountOutMin,
1234         address[] calldata path,
1235         address to,
1236         uint256 deadline
1237     ) external payable;
1238 
1239     function swapExactTokensForETHSupportingFeeOnTransferTokens(
1240         uint256 amountIn,
1241         uint256 amountOutMin,
1242         address[] calldata path,
1243         address to,
1244         uint256 deadline
1245     ) external;
1246 }
1247 
1248 ////// src/MasRelic.sol
1249 /**
1250 
1251 MasRelic Decentralized Finance
1252 
1253 Tax for Buying/Selling: 10%
1254     - 3% of each transaction sent to holders as ETH transactions
1255     - 4% of each transaction sent to Treasury Wallet
1256     - 3% of each transaction sent to the Liquidity Pool
1257 
1258 Tax Buying/Selling: 9%
1259     - 3% of each transaction sent to holders as ETH transactions
1260     - 3% of each transaction sent to Treasury Wallet
1261     - 3% of each transaction sent to the Liquidity Pool
1262 
1263 Earning Dashboard:
1264 https://masrelic.fi
1265 
1266 */
1267 
1268 /* pragma solidity 0.8.10; */
1269 
1270 /* import {ERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol"; */
1271 /* import {IERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol"; */
1272 /* import {Ownable} from "lib/openzeppelin-contracts/contracts/access/Ownable.sol"; */
1273 /* import {Address} from "lib/openzeppelin-contracts/contracts/utils/Address.sol"; */
1274 /* import {SafeMath} from "lib/openzeppelin-contracts/contracts/utils/math/SafeMath.sol"; */
1275 
1276 /* import {IUniswapV2Router02} from "./IUniswapV2Router02.sol"; */
1277 /* import {IUniswapV2Factory} from "./IUniswapV2Factory.sol"; */
1278 /* import {IUniswapV2Pair} from "./IUniswapV2Pair.sol"; */
1279 
1280 contract MasRelic is Ownable, 
1281                 IERC20 {
1282     address UNISWAPROUTER = address(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
1283     address DEAD = 0x000000000000000000000000000000000000dEaD;
1284     address ZERO = 0x0000000000000000000000000000000000000000;
1285 
1286     string private _name = "MasRelic";
1287     string private _symbol = "RELIC";
1288 
1289     uint256 public treasuryFeeBPS = 400;
1290     uint256 public liquidityFeeBPS = 300;
1291     uint256 public dividendFeeBPS = 300;
1292     uint256 public totalFeeBPS = 1000;
1293 
1294     uint256 public swapTokensAtAmount = 100000 * (10**18);
1295     uint256 public lastSwapTime;
1296     bool swapAllToken = true;
1297 
1298     bool public swapEnabled = true;
1299     bool public taxEnabled = true;
1300     bool public compoundingEnabled = true;
1301 
1302     uint256 private _totalSupply;
1303     bool private swapping;
1304 
1305     address marketingWallet;
1306     address liquidityWallet;
1307 
1308     mapping(address => uint256) private _balances;
1309     mapping(address => mapping(address => uint256)) private _allowances;
1310     mapping(address => bool) private _isExcludedFromFees;
1311     mapping(address => bool) public automatedMarketMakerPairs;
1312     mapping(address => bool) private _whiteList;
1313     mapping(address => bool) isBlacklisted;
1314 
1315     event SwapAndAddLiquidity(
1316         uint256 tokensSwapped,
1317         uint256 nativeReceived,
1318         uint256 tokensIntoLiquidity
1319     );
1320     event SendDividends(uint256 tokensSwapped, uint256 amount);
1321     event ExcludeFromFees(address indexed account, bool isExcluded);
1322     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
1323     event UpdateUniswapV2Router(
1324         address indexed newAddress,
1325         address indexed oldAddress
1326     );
1327     event SwapEnabled(bool enabled);
1328     event TaxEnabled(bool enabled);
1329     event CompoundingEnabled(bool enabled);
1330     event BlacklistEnabled(bool enabled);
1331 
1332     DividendTracker public dividendTracker;
1333     IUniswapV2Router02 public uniswapV2Router;
1334 
1335     address public uniswapV2Pair;
1336 
1337     uint256 public maxTxBPS = 49;
1338     uint256 public maxWalletBPS = 200;
1339 
1340     bool isOpen = false;
1341 
1342     mapping(address => bool) private _isExcludedFromMaxTx;
1343     mapping(address => bool) private _isExcludedFromMaxWallet;
1344     address public OWNER;
1345     constructor(
1346         address _marketingWallet,
1347         address _liquidityWallet,
1348         address[] memory whitelistAddress
1349     )  {
1350         marketingWallet = _marketingWallet;
1351         liquidityWallet = _liquidityWallet;
1352         includeToWhiteList(whitelistAddress);
1353 
1354 
1355         dividendTracker = new DividendTracker(address(this), UNISWAPROUTER);
1356 
1357         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(UNISWAPROUTER);
1358 
1359         address _uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
1360             .createPair(address(this), _uniswapV2Router.WETH());
1361 
1362         uniswapV2Router = _uniswapV2Router;
1363         uniswapV2Pair = _uniswapV2Pair;
1364          
1365         _setAutomatedMarketMakerPair(_uniswapV2Pair, true);
1366     
1367         dividendTracker.excludeFromDividends(address(dividendTracker), true);
1368         dividendTracker.excludeFromDividends(address(this), true);
1369         dividendTracker.excludeFromDividends(owner(), true);
1370         dividendTracker.excludeFromDividends(address(_uniswapV2Router), true);
1371 
1372         excludeFromFees(owner(), true);
1373         excludeFromFees(address(this), true);
1374         excludeFromFees(address(dividendTracker), true);
1375 
1376         excludeFromMaxTx(owner(), true);
1377         excludeFromMaxTx(address(this), true);
1378         excludeFromMaxTx(address(dividendTracker), true);
1379 
1380         excludeFromMaxWallet(owner(), true);
1381         excludeFromMaxWallet(address(this), true);
1382         excludeFromMaxWallet(address(dividendTracker), true);
1383 
1384         _mint(owner(), 1000000000 * (10**18));
1385         
1386     }
1387 
1388     receive() external payable {}
1389 
1390     function name() public view returns (string memory) {
1391         return _name;
1392     }
1393 
1394     function symbol() public view returns (string memory) {
1395         return _symbol;
1396     }
1397 
1398     function decimals() public pure returns (uint8) {
1399         return 18;
1400     }
1401 
1402     function totalSupply() public view virtual override returns (uint256) {
1403         return _totalSupply;
1404     }
1405 
1406     function balanceOf(address account)
1407         public
1408         view
1409         virtual
1410         override
1411         returns (uint256)
1412     {
1413         return _balances[account];
1414     }
1415 
1416     function allowance(address owner, address spender)
1417         public
1418         view
1419         virtual
1420         override
1421         returns (uint256)
1422     {
1423         return _allowances[owner][spender];
1424     }
1425 
1426     function approve(address spender, uint256 amount)
1427         public
1428         virtual
1429         override
1430         returns (bool)
1431     {
1432         _approve(_msgSender(), spender, amount);
1433         return true;
1434     }
1435 
1436     function increaseAllowance(address spender, uint256 addedValue)
1437         public
1438         returns (bool)
1439     {
1440         _approve(
1441             _msgSender(),
1442             spender,
1443             _allowances[_msgSender()][spender] + addedValue
1444         );
1445         return true;
1446     }
1447 
1448     function decreaseAllowance(address spender, uint256 subtractedValue)
1449         public
1450         returns (bool)
1451     {
1452         uint256 currentAllowance = _allowances[_msgSender()][spender];
1453         require(
1454             currentAllowance >= subtractedValue,
1455             "MasRelic: decreased allowance below zero"
1456         );
1457         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
1458         return true;
1459     }
1460 
1461     function transfer(address recipient, uint256 amount)
1462         public
1463         virtual
1464         override
1465         returns (bool)
1466     {
1467         _transfer(_msgSender(), recipient, amount);
1468         return true;
1469     }
1470 
1471     function transferFrom(
1472         address sender,
1473         address recipient,
1474         uint256 amount
1475     ) public virtual override returns (bool) {
1476         _transfer(sender, recipient, amount);
1477         uint256 currentAllowance = _allowances[sender][_msgSender()];
1478         require(
1479             currentAllowance >= amount,
1480             "MasRelic: transfer amount exceeds allowance"
1481         );
1482         _approve(sender, _msgSender(), currentAllowance - amount);
1483         return true;
1484     }
1485 
1486     function openTrading() external onlyOwner {
1487         isOpen = true;
1488     }
1489 
1490     function _transfer(
1491         address sender,
1492         address recipient,
1493         uint256 amount
1494     ) internal {
1495         require(
1496             isOpen ||
1497                 sender == owner() ||
1498                 recipient == owner() ||
1499                 _whiteList[sender] ||
1500                 _whiteList[recipient],
1501             "Not Open"
1502         );
1503 
1504         require(!isBlacklisted[sender], "MasRelic: Sender is blacklisted");
1505         require(!isBlacklisted[recipient], "MasRelic: Recipient is blacklisted");
1506 
1507         require(sender != address(0), "MasRelic: transfer from the zero address");
1508         require(recipient != address(0), "MasRelic: transfer to the zero address");
1509 
1510         uint256 _maxTxAmount = (totalSupply() * maxTxBPS) / 10000;
1511         uint256 _maxWallet = (totalSupply() * maxWalletBPS) / 10000;
1512         require(
1513             amount <= _maxTxAmount || _isExcludedFromMaxTx[sender],
1514             "TX Limit Exceeded"
1515         );
1516 
1517         if (
1518             sender != owner() &&
1519             recipient != address(this) &&
1520             recipient != address(DEAD) &&
1521             recipient != uniswapV2Pair
1522         ) {
1523             uint256 currentBalance = balanceOf(recipient);
1524             require(
1525                 _isExcludedFromMaxWallet[recipient] ||
1526                     (currentBalance + amount <= _maxWallet)
1527             );
1528         }
1529 
1530         uint256 senderBalance = _balances[sender];
1531         require(
1532             senderBalance >= amount,
1533             "MasRelic: transfer amount exceeds balance"
1534         );
1535 
1536         uint256 contractTokenBalance = balanceOf(address(this));
1537         uint256 contractNativeBalance = address(this).balance;
1538 
1539         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1540 
1541         if (
1542             swapEnabled && // True
1543             canSwap && // true
1544             !swapping && // swapping=false !false true
1545             !automatedMarketMakerPairs[sender] && // no swap on remove liquidity step 1 or DEX buy
1546             sender != address(uniswapV2Router) && // no swap on remove liquidity step 2
1547             sender != owner() &&
1548             recipient != owner()
1549         ) {
1550             swapping = true;
1551 
1552             if (!swapAllToken) {
1553                 contractTokenBalance = swapTokensAtAmount;
1554             }
1555             _executeSwap(contractTokenBalance, contractNativeBalance);
1556 
1557             lastSwapTime = block.timestamp;
1558             swapping = false;
1559         }
1560 
1561         bool takeFee;
1562 
1563         if (
1564             sender == address(uniswapV2Pair) ||
1565             recipient == address(uniswapV2Pair)
1566         ) {
1567             takeFee = true;
1568         }
1569 
1570         if (_isExcludedFromFees[sender] || _isExcludedFromFees[recipient]) {
1571             takeFee = false;
1572         }
1573 
1574         if (swapping || !taxEnabled) {
1575             takeFee = false;
1576         }
1577 
1578         if (takeFee) {
1579             uint256 fees = (amount * totalFeeBPS) / 10000;
1580             amount -= fees;
1581             _executeTransfer(sender, address(this), fees);
1582         }
1583 
1584         _executeTransfer(sender, recipient, amount);
1585 
1586         dividendTracker.setBalance(payable(sender), balanceOf(sender));
1587         dividendTracker.setBalance(payable(recipient), balanceOf(recipient));
1588     }
1589 
1590     function _executeTransfer(
1591         address sender,
1592         address recipient,
1593         uint256 amount
1594     ) private {
1595         require(sender != address(0), "MasRelic: transfer from the zero address");
1596         require(recipient != address(0), "MasRelic: transfer to the zero address");
1597         uint256 senderBalance = _balances[sender];
1598         require(
1599             senderBalance >= amount,
1600             "MasRelic: transfer amount exceeds balance"
1601         );
1602         _balances[sender] = senderBalance - amount;
1603         _balances[recipient] += amount;
1604         emit Transfer(sender, recipient, amount);
1605     }
1606 
1607     function _approve(
1608         address owner,
1609         address spender,
1610         uint256 amount
1611     ) private {
1612         require(owner != address(0), "MasRelic: approve from the zero address");
1613         require(spender != address(0), "MasRelic: approve to the zero address");
1614         _allowances[owner][spender] = amount;
1615         emit Approval(owner, spender, amount);
1616     }
1617 
1618     function _mint(address account, uint256 amount) private {
1619         require(account != address(0), "MasRelic: mint to the zero address");
1620         _totalSupply += amount;
1621         _balances[account] += amount;
1622         emit Transfer(address(0), account, amount);
1623     }
1624 
1625     function _burn(address account, uint256 amount) private {
1626         require(account != address(0), "MasRelic: burn from the zero address");
1627         uint256 accountBalance = _balances[account];
1628         require(accountBalance >= amount, "MasRelic: burn amount exceeds balance");
1629         _balances[account] = accountBalance - amount;
1630         _totalSupply -= amount;
1631         emit Transfer(account, address(0), amount);
1632     }
1633 
1634     function swapTokensForNative(uint256 tokens) private {
1635         address[] memory path = new address[](2);
1636         path[0] = address(this);
1637         path[1] = uniswapV2Router.WETH();
1638         _approve(address(this), address(uniswapV2Router), tokens);
1639         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1640             tokens,
1641             0, // accept any amount of native
1642             path,
1643             address(this),
1644             block.timestamp
1645         );
1646     }
1647 
1648     function addLiquidity(uint256 tokens, uint256 native) private {
1649         _approve(address(this), address(uniswapV2Router), tokens);
1650         uniswapV2Router.addLiquidityETH{value: native}(
1651             address(this),
1652             tokens,
1653             0, // slippage unavoidable
1654             0, // slippage unavoidable
1655             liquidityWallet,
1656             block.timestamp
1657         );
1658     }
1659 
1660     function includeToWhiteList(address[] memory _users) private {
1661         for (uint8 i = 0; i < _users.length; i++) {
1662             _whiteList[_users[i]] = true;
1663         }
1664     }
1665 
1666     function _executeSwap(uint256 tokens, uint256 native) private {
1667         if (tokens <= 0) {
1668             return;
1669         }
1670 
1671         uint256 swapTokensMarketing;
1672         if (address(marketingWallet) != address(0)) {
1673             swapTokensMarketing = (tokens * treasuryFeeBPS) / totalFeeBPS;
1674         }
1675 
1676         uint256 swapTokensDividends;
1677         if (dividendTracker.totalSupply() > 0) {
1678             swapTokensDividends = (tokens * dividendFeeBPS) / totalFeeBPS;
1679         }
1680 
1681         uint256 tokensForLiquidity = tokens -
1682             swapTokensMarketing -
1683             swapTokensDividends;
1684         uint256 swapTokensLiquidity = tokensForLiquidity / 2;
1685         uint256 addTokensLiquidity = tokensForLiquidity - swapTokensLiquidity;
1686         uint256 swapTokensTotal = swapTokensMarketing +
1687             swapTokensDividends +
1688             swapTokensLiquidity;
1689 
1690         uint256 initNativeBal = address(this).balance;
1691         swapTokensForNative(swapTokensTotal);
1692         uint256 nativeSwapped = (address(this).balance - initNativeBal) +
1693             native;
1694 
1695         uint256 nativeMarketing = (nativeSwapped * swapTokensMarketing) /
1696             swapTokensTotal;
1697         uint256 nativeDividends = (nativeSwapped * swapTokensDividends) /
1698             swapTokensTotal;
1699         uint256 nativeLiquidity = nativeSwapped -
1700             nativeMarketing -
1701             nativeDividends;
1702 
1703         if (nativeMarketing > 0) {
1704             payable(marketingWallet).transfer(nativeMarketing);
1705         }
1706 
1707         addLiquidity(addTokensLiquidity, nativeLiquidity);
1708         emit SwapAndAddLiquidity(
1709             swapTokensLiquidity,
1710             nativeLiquidity,
1711             addTokensLiquidity
1712         );
1713 
1714         if (nativeDividends > 0) {
1715             (bool success, ) = address(dividendTracker).call{
1716                 value: nativeDividends
1717             }("");
1718             if (success) {
1719                 emit SendDividends(swapTokensDividends, nativeDividends);
1720             }
1721         }
1722     }
1723 
1724     function excludeFromFees(address account, bool excluded) public onlyOwner {
1725         require(
1726             _isExcludedFromFees[account] != excluded,
1727             "MasRelic: account is already set to requested state"
1728         );
1729         _isExcludedFromFees[account] = excluded;
1730         emit ExcludeFromFees(account, excluded);
1731     }
1732 
1733     function isExcludedFromFees(address account) public view returns (bool) {
1734         return _isExcludedFromFees[account];
1735     }
1736 
1737     function manualSendDividend(uint256 amount, address holder)
1738         external
1739         onlyOwner
1740     {
1741         dividendTracker.manualSendDividend(amount, holder);
1742     }
1743 
1744     function excludeFromDividends(address account, bool excluded)
1745         public
1746         onlyOwner
1747     {
1748         dividendTracker.excludeFromDividends(account, excluded);
1749     }
1750 
1751     function isExcludedFromDividends(address account)
1752         public
1753         view
1754         returns (bool)
1755     {
1756         return dividendTracker.isExcludedFromDividends(account);
1757     }
1758 
1759     function setWallet(
1760         address payable _marketingWallet,
1761         address payable _liquidityWallet
1762     ) external onlyOwner {
1763         marketingWallet = _marketingWallet;
1764         liquidityWallet = _liquidityWallet;
1765     }
1766 
1767     function setAutomatedMarketMakerPair(address pair, bool value)
1768         public
1769         onlyOwner
1770     {
1771         require(pair != uniswapV2Pair, "MasRelic: DEX pair can not be removed");
1772         _setAutomatedMarketMakerPair(pair, value);
1773     }
1774 
1775     function setFee(
1776         uint256 _treasuryFee,
1777         uint256 _liquidityFee,
1778         uint256 _dividendFee
1779     ) external onlyOwner {
1780         treasuryFeeBPS = _treasuryFee;
1781         liquidityFeeBPS = _liquidityFee;
1782         dividendFeeBPS = _dividendFee;
1783         totalFeeBPS = _treasuryFee + _liquidityFee + _dividendFee;
1784     }
1785 
1786     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1787         require(
1788             automatedMarketMakerPairs[pair] != value,
1789             "MasRelic: automated market maker pair is already set to that value"
1790         );
1791         automatedMarketMakerPairs[pair] = value;
1792         if (value) {
1793             dividendTracker.excludeFromDividends(pair, true);
1794         }
1795         emit SetAutomatedMarketMakerPair(pair, value);
1796     }
1797 
1798     function updateUniswapV2Router(address newAddress) public onlyOwner {
1799         require(
1800             newAddress != address(uniswapV2Router),
1801             "MasRelic: the router is already set to the new address"
1802         );
1803         emit UpdateUniswapV2Router(newAddress, address(uniswapV2Router));
1804         uniswapV2Router = IUniswapV2Router02(newAddress);
1805         address _uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory())
1806             .createPair(address(this), uniswapV2Router.WETH());
1807         uniswapV2Pair = _uniswapV2Pair;
1808     }
1809 
1810     function claim() public {
1811         dividendTracker.processAccount(payable(_msgSender()));
1812     }
1813 
1814     function compound() public {
1815         require(compoundingEnabled, "MasRelic: compounding is not enabled");
1816         dividendTracker.compoundAccount(payable(_msgSender()));
1817     }
1818 
1819     function withdrawableDividendOf(address account)
1820         public
1821         view
1822         returns (uint256)
1823     {
1824         return dividendTracker.withdrawableDividendOf(account);
1825     }
1826 
1827     function withdrawnDividendOf(address account)
1828         public
1829         view
1830         returns (uint256)
1831     {
1832         return dividendTracker.withdrawnDividendOf(account);
1833     }
1834 
1835     function accumulativeDividendOf(address account)
1836         public
1837         view
1838         returns (uint256)
1839     {
1840         return dividendTracker.accumulativeDividendOf(account);
1841     }
1842 
1843     function getAccountInfo(address account)
1844         public
1845         view
1846         returns (
1847             address,
1848             uint256,
1849             uint256,
1850             uint256,
1851             uint256
1852         )
1853     {
1854         return dividendTracker.getAccountInfo(account);
1855     }
1856 
1857     function getLastClaimTime(address account) public view returns (uint256) {
1858         return dividendTracker.getLastClaimTime(account);
1859     }
1860 
1861     function setSwapEnabled(bool _enabled) external onlyOwner {
1862         swapEnabled = _enabled;
1863         emit SwapEnabled(_enabled);
1864     }
1865 
1866     function setTaxEnabled(bool _enabled) external onlyOwner {
1867         taxEnabled = _enabled;
1868         emit TaxEnabled(_enabled);
1869     }
1870 
1871     function setCompoundingEnabled(bool _enabled) external onlyOwner {
1872         compoundingEnabled = _enabled;
1873         emit CompoundingEnabled(_enabled);
1874     }
1875 
1876     function updateDividendSettings(
1877         bool _swapEnabled,
1878         uint256 _swapTokensAtAmount,
1879         bool _swapAllToken
1880     ) external onlyOwner {
1881         swapEnabled = _swapEnabled;
1882         swapTokensAtAmount = _swapTokensAtAmount;
1883         swapAllToken = _swapAllToken;
1884     }
1885 
1886     function setMaxTxBPS(uint256 bps) external onlyOwner {
1887         require(bps >= 75 && bps <= 10000, "BPS must be between 75 and 10000");
1888         maxTxBPS = bps;
1889     }
1890 
1891     function excludeFromMaxTx(address account, bool excluded) public onlyOwner {
1892         _isExcludedFromMaxTx[account] = excluded;
1893     }
1894 
1895     function isExcludedFromMaxTx(address account) public view returns (bool) {
1896         return _isExcludedFromMaxTx[account];
1897     }
1898 
1899     function setMaxWalletBPS(uint256 bps) external onlyOwner {
1900         require(
1901             bps >= 175 && bps <= 10000,
1902             "BPS must be between 175 and 10000"
1903         );
1904         maxWalletBPS = bps;
1905     }
1906 
1907     function excludeFromMaxWallet(address account, bool excluded)
1908         public
1909         onlyOwner
1910     {
1911         _isExcludedFromMaxWallet[account] = excluded;
1912     }
1913 
1914     function isExcludedFromMaxWallet(address account)
1915         public
1916         view
1917         returns (bool)
1918     {
1919         return _isExcludedFromMaxWallet[account];
1920     }
1921 
1922     function rescueToken(address _token, uint256 _amount) external onlyOwner {
1923         IERC20(_token).transfer(msg.sender, _amount);
1924     }
1925 
1926     function rescueETH(uint256 _amount) external onlyOwner {
1927         payable(msg.sender).transfer(_amount);
1928     }
1929 
1930     function blackList(address _user) public onlyOwner {
1931         require(!isBlacklisted[_user], "user already blacklisted");
1932         isBlacklisted[_user] = true;
1933         // events?
1934     }
1935 
1936     function removeFromBlacklist(address _user) public onlyOwner {
1937         require(isBlacklisted[_user], "user already whitelisted");
1938         isBlacklisted[_user] = false;
1939         //events?
1940     }
1941 
1942     function blackListMany(address[] memory _users) public onlyOwner {
1943         for (uint8 i = 0; i < _users.length; i++) {
1944             isBlacklisted[_users[i]] = true;
1945         }
1946     }
1947 
1948     function unBlackListMany(address[] memory _users) public onlyOwner {
1949         for (uint8 i = 0; i < _users.length; i++) {
1950             isBlacklisted[_users[i]] = false;
1951         }
1952     }
1953 }
1954 
1955 contract DividendTracker is Ownable, IERC20 {
1956     address UNISWAPROUTER;
1957 
1958     string private _name = "Mas_DividendTracker";
1959     string private _symbol = "Mas_DividendTracker";
1960 
1961     uint256 public lastProcessedIndex;
1962 
1963     uint256 private _totalSupply;
1964     mapping(address => uint256) private _balances;
1965 
1966     uint256 private constant magnitude = 2**128;
1967     uint256 public immutable minTokenBalanceForDividends;
1968     uint256 private magnifiedDividendPerShare;
1969     uint256 public totalDividendsDistributed;
1970     uint256 public totalDividendsWithdrawn;
1971 
1972     address public tokenAddress;
1973 
1974     mapping(address => bool) public excludedFromDividends;
1975     mapping(address => int256) private magnifiedDividendCorrections;
1976     mapping(address => uint256) private withdrawnDividends;
1977     mapping(address => uint256) private lastClaimTimes;
1978 
1979     event DividendsDistributed(address indexed from, uint256 weiAmount);
1980     event DividendWithdrawn(address indexed to, uint256 weiAmount);
1981     event ExcludeFromDividends(address indexed account, bool excluded);
1982     event Claim(address indexed account, uint256 amount);
1983     event Compound(address indexed account, uint256 amount, uint256 tokens);
1984 
1985     struct AccountInfo {
1986         address account;
1987         uint256 withdrawableDividends;
1988         uint256 totalDividends;
1989         uint256 lastClaimTime;
1990     }
1991 
1992     constructor(address _tokenAddress, address _uniswapRouter) {
1993         minTokenBalanceForDividends = 10000 * (10**18);
1994         tokenAddress = _tokenAddress;
1995         UNISWAPROUTER = _uniswapRouter;
1996     }
1997 
1998     receive() external payable {
1999         distributeDividends();
2000     }
2001 
2002     function distributeDividends() public payable {
2003         require(_totalSupply > 0);
2004         if (msg.value > 0) {
2005             magnifiedDividendPerShare =
2006                 magnifiedDividendPerShare +
2007                 ((msg.value * magnitude) / _totalSupply);
2008             emit DividendsDistributed(msg.sender, msg.value);
2009             totalDividendsDistributed += msg.value;
2010         }
2011     }
2012 
2013     function setBalance(address payable account, uint256 newBalance)
2014         external
2015         onlyOwner
2016     {
2017         if (excludedFromDividends[account]) {
2018             return;
2019         }
2020         if (newBalance >= minTokenBalanceForDividends) {
2021             _setBalance(account, newBalance);
2022         } else {
2023             _setBalance(account, 0);
2024         }
2025     }
2026 
2027     function excludeFromDividends(address account, bool excluded)
2028         external
2029         onlyOwner
2030     {
2031         require(
2032             excludedFromDividends[account] != excluded,
2033             "Mas_DividendTracker: account already set to requested state"
2034         );
2035         excludedFromDividends[account] = excluded;
2036         if (excluded) {
2037             _setBalance(account, 0);
2038         } else {
2039             uint256 newBalance = IERC20(tokenAddress).balanceOf(account);
2040             if (newBalance >= minTokenBalanceForDividends) {
2041                 _setBalance(account, newBalance);
2042             } else {
2043                 _setBalance(account, 0);
2044             }
2045         }
2046         emit ExcludeFromDividends(account, excluded);
2047     }
2048 
2049     function isExcludedFromDividends(address account)
2050         public
2051         view
2052         returns (bool)
2053     {
2054         return excludedFromDividends[account];
2055     }
2056 
2057     function manualSendDividend(uint256 amount, address holder)
2058         external
2059         onlyOwner
2060     {
2061         uint256 contractETHBalance = address(this).balance;
2062         payable(holder).transfer(amount > 0 ? amount : contractETHBalance);
2063     }
2064 
2065     function _setBalance(address account, uint256 newBalance) internal {
2066         uint256 currentBalance = _balances[account];
2067         if (newBalance > currentBalance) {
2068             uint256 addAmount = newBalance - currentBalance;
2069             _mint(account, addAmount);
2070         } else if (newBalance < currentBalance) {
2071             uint256 subAmount = currentBalance - newBalance;
2072             _burn(account, subAmount);
2073         }
2074     }
2075 
2076     function _mint(address account, uint256 amount) private {
2077         require(
2078             account != address(0),
2079             "Mas_DividendTracker: mint to the zero address"
2080         );
2081         _totalSupply += amount;
2082         _balances[account] += amount;
2083         emit Transfer(address(0), account, amount);
2084         magnifiedDividendCorrections[account] =
2085             magnifiedDividendCorrections[account] -
2086             int256(magnifiedDividendPerShare * amount);
2087     }
2088 
2089     function _burn(address account, uint256 amount) private {
2090         require(
2091             account != address(0),
2092             "Mas_DividendTracker: burn from the zero address"
2093         );
2094         uint256 accountBalance = _balances[account];
2095         require(
2096             accountBalance >= amount,
2097             "Mas_DividendTracker: burn amount exceeds balance"
2098         );
2099         _balances[account] = accountBalance - amount;
2100         _totalSupply -= amount;
2101         emit Transfer(account, address(0), amount);
2102         magnifiedDividendCorrections[account] =
2103             magnifiedDividendCorrections[account] +
2104             int256(magnifiedDividendPerShare * amount);
2105     }
2106 
2107     function processAccount(address payable account)
2108         public
2109         onlyOwner
2110         returns (bool)
2111     {
2112         uint256 amount = _withdrawDividendOfUser(account);
2113         if (amount > 0) {
2114             lastClaimTimes[account] = block.timestamp;
2115             emit Claim(account, amount);
2116             return true;
2117         }
2118         return false;
2119     }
2120 
2121     function _withdrawDividendOfUser(address payable account)
2122         private
2123         returns (uint256)
2124     {
2125         uint256 _withdrawableDividend = withdrawableDividendOf(account);
2126         if (_withdrawableDividend > 0) {
2127             withdrawnDividends[account] += _withdrawableDividend;
2128             totalDividendsWithdrawn += _withdrawableDividend;
2129             emit DividendWithdrawn(account, _withdrawableDividend);
2130             (bool success, ) = account.call{
2131                 value: _withdrawableDividend,
2132                 gas: 3000
2133             }("");
2134             if (!success) {
2135                 withdrawnDividends[account] -= _withdrawableDividend;
2136                 totalDividendsWithdrawn -= _withdrawableDividend;
2137                 return 0;
2138             }
2139             return _withdrawableDividend;
2140         }
2141         return 0;
2142     }
2143 
2144     function compoundAccount(address payable account)
2145         public
2146         onlyOwner
2147         returns (bool)
2148     {
2149         (uint256 amount, uint256 tokens) = _compoundDividendOfUser(account);
2150         if (amount > 0) {
2151             lastClaimTimes[account] = block.timestamp;
2152             emit Compound(account, amount, tokens);
2153             return true;
2154         }
2155         return false;
2156     }
2157 
2158     function _compoundDividendOfUser(address payable account)
2159         private
2160         returns (uint256, uint256)
2161     {
2162         uint256 _withdrawableDividend = withdrawableDividendOf(account);
2163         if (_withdrawableDividend > 0) {
2164             withdrawnDividends[account] += _withdrawableDividend;
2165             totalDividendsWithdrawn += _withdrawableDividend;
2166             emit DividendWithdrawn(account, _withdrawableDividend);
2167 
2168             IUniswapV2Router02 uniswapV2Router = IUniswapV2Router02(
2169                 UNISWAPROUTER
2170             );
2171 
2172             address[] memory path = new address[](2);
2173             path[0] = uniswapV2Router.WETH();
2174             path[1] = address(tokenAddress);
2175 
2176             bool success;
2177             uint256 tokens;
2178 
2179             uint256 initTokenBal = IERC20(tokenAddress).balanceOf(account);
2180             try
2181                 uniswapV2Router
2182                     .swapExactETHForTokensSupportingFeeOnTransferTokens{
2183                     value: _withdrawableDividend
2184                 }(0, path, address(account), block.timestamp)
2185             {
2186                 success = true;
2187                 tokens = IERC20(tokenAddress).balanceOf(account) - initTokenBal;
2188             } catch Error(
2189                 string memory /*err*/
2190             ) {
2191                 success = false;
2192             }
2193 
2194             if (!success) {
2195                 withdrawnDividends[account] -= _withdrawableDividend;
2196                 totalDividendsWithdrawn -= _withdrawableDividend;
2197                 return (0, 0);
2198             }
2199 
2200             return (_withdrawableDividend, tokens);
2201         }
2202         return (0, 0);
2203     }
2204 
2205     function withdrawableDividendOf(address account)
2206         public
2207         view
2208         returns (uint256)
2209     {
2210         return accumulativeDividendOf(account) - withdrawnDividends[account];
2211     }
2212 
2213     function withdrawnDividendOf(address account)
2214         public
2215         view
2216         returns (uint256)
2217     {
2218         return withdrawnDividends[account];
2219     }
2220 
2221     function accumulativeDividendOf(address account)
2222         public
2223         view
2224         returns (uint256)
2225     {
2226         int256 a = int256(magnifiedDividendPerShare * balanceOf(account));
2227         int256 b = magnifiedDividendCorrections[account]; // this is an explicit int256 (signed)
2228         return uint256(a + b) / magnitude;
2229     }
2230 
2231     function getAccountInfo(address account)
2232         public
2233         view
2234         returns (
2235             address,
2236             uint256,
2237             uint256,
2238             uint256,
2239             uint256
2240         )
2241     {
2242         AccountInfo memory info;
2243         info.account = account;
2244         info.withdrawableDividends = withdrawableDividendOf(account);
2245         info.totalDividends = accumulativeDividendOf(account);
2246         info.lastClaimTime = lastClaimTimes[account];
2247         return (
2248             info.account,
2249             info.withdrawableDividends,
2250             info.totalDividends,
2251             info.lastClaimTime,
2252             totalDividendsWithdrawn
2253         );
2254     }
2255 
2256     function getLastClaimTime(address account) public view returns (uint256) {
2257         return lastClaimTimes[account];
2258     }
2259 
2260     function name() public view returns (string memory) {
2261         return _name;
2262     }
2263 
2264     function symbol() public view returns (string memory) {
2265         return _symbol;
2266     }
2267 
2268     function decimals() public pure returns (uint8) {
2269         return 18;
2270     }
2271 
2272     function totalSupply() public view override returns (uint256) {
2273         return _totalSupply;
2274     }
2275 
2276     function balanceOf(address account) public view override returns (uint256) {
2277         return _balances[account];
2278     }
2279 
2280     function transfer(address, uint256) public pure override returns (bool) {
2281         revert("Mas_DividendTracker: method not implemented");
2282     }
2283 
2284     function allowance(address, address)
2285         public
2286         pure
2287         override
2288         returns (uint256)
2289     {
2290         revert("Mas_DividendTracker: method not implemented");
2291     }
2292 
2293     function approve(address, uint256) public pure override returns (bool) {
2294         revert("Mas_DividendTracker: method not implemented");
2295     }
2296 
2297     function transferFrom(
2298         address,
2299         address,
2300         uint256
2301     ) public pure override returns (bool) {
2302         revert("Mas_DividendTracker: method not implemented");
2303     }
2304 }