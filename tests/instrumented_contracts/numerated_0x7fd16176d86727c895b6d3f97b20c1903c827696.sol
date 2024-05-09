1 // File: @openzeppelin/contracts/utils/Context.sol
2 
3 
4 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev Provides information about the current execution context, including the
10  * sender of the transaction and its data. While these are generally available
11  * via msg.sender and msg.data, they should not be accessed in such a direct
12  * manner, since when dealing with meta-transactions the account sending and
13  * paying for execution may not be the actual sender (as far as an application
14  * is concerned).
15  *
16  * This contract is only required for intermediate, library-like contracts.
17  */
18 abstract contract Context {
19     function _msgSender() internal view virtual returns (address) {
20         return msg.sender;
21     }
22 
23     function _msgData() internal view virtual returns (bytes calldata) {
24         return msg.data;
25     }
26 }
27 
28 // File: @openzeppelin/contracts/access/Ownable.sol
29 
30 
31 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
32 
33 pragma solidity ^0.8.0;
34 
35 
36 /**
37  * @dev Contract module which provides a basic access control mechanism, where
38  * there is an account (an owner) that can be granted exclusive access to
39  * specific functions.
40  *
41  * By default, the owner account will be the one that deploys the contract. This
42  * can later be changed with {transferOwnership}.
43  *
44  * This module is used through inheritance. It will make available the modifier
45  * `onlyOwner`, which can be applied to your functions to restrict their use to
46  * the owner.
47  */
48 abstract contract Ownable is Context {
49     address private _owner;
50 
51     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
52 
53     /**
54      * @dev Initializes the contract setting the deployer as the initial owner.
55      */
56     constructor() {
57         _transferOwnership(_msgSender());
58     }
59 
60     /**
61      * @dev Returns the address of the current owner.
62      */
63     function owner() public view virtual returns (address) {
64         return _owner;
65     }
66 
67     /**
68      * @dev Throws if called by any account other than the owner.
69      */
70     modifier onlyOwner() {
71         require(owner() == _msgSender(), "Ownable: caller is not the owner");
72         _;
73     }
74 
75     /**
76      * @dev Leaves the contract without owner. It will not be possible to call
77      * `onlyOwner` functions anymore. Can only be called by the current owner.
78      *
79      * NOTE: Renouncing ownership will leave the contract without an owner,
80      * thereby removing any functionality that is only available to the owner.
81      */
82     function renounceOwnership() public virtual onlyOwner {
83         _transferOwnership(address(0));
84     }
85 
86     /**
87      * @dev Transfers ownership of the contract to a new account (`newOwner`).
88      * Can only be called by the current owner.
89      */
90     function transferOwnership(address newOwner) public virtual onlyOwner {
91         require(newOwner != address(0), "Ownable: new owner is the zero address");
92         _transferOwnership(newOwner);
93     }
94 
95     /**
96      * @dev Transfers ownership of the contract to a new account (`newOwner`).
97      * Internal function without access restriction.
98      */
99     function _transferOwnership(address newOwner) internal virtual {
100         address oldOwner = _owner;
101         _owner = newOwner;
102         emit OwnershipTransferred(oldOwner, newOwner);
103     }
104 }
105 
106 // File: @openzeppelin/contracts/utils/Address.sol
107 
108 
109 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
110 
111 pragma solidity ^0.8.1;
112 
113 /**
114  * @dev Collection of functions related to the address type
115  */
116 library Address {
117     /**
118      * @dev Returns true if `account` is a contract.
119      *
120      * [IMPORTANT]
121      * ====
122      * It is unsafe to assume that an address for which this function returns
123      * false is an externally-owned account (EOA) and not a contract.
124      *
125      * Among others, `isContract` will return false for the following
126      * types of addresses:
127      *
128      *  - an externally-owned account
129      *  - a contract in construction
130      *  - an address where a contract will be created
131      *  - an address where a contract lived, but was destroyed
132      * ====
133      *
134      * [IMPORTANT]
135      * ====
136      * You shouldn't rely on `isContract` to protect against flash loan attacks!
137      *
138      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
139      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
140      * constructor.
141      * ====
142      */
143     function isContract(address account) internal view returns (bool) {
144         // This method relies on extcodesize/address.code.length, which returns 0
145         // for contracts in construction, since the code is only stored at the end
146         // of the constructor execution.
147 
148         return account.code.length > 0;
149     }
150 
151     /**
152      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
153      * `recipient`, forwarding all available gas and reverting on errors.
154      *
155      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
156      * of certain opcodes, possibly making contracts go over the 2300 gas limit
157      * imposed by `transfer`, making them unable to receive funds via
158      * `transfer`. {sendValue} removes this limitation.
159      *
160      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
161      *
162      * IMPORTANT: because control is transferred to `recipient`, care must be
163      * taken to not create reentrancy vulnerabilities. Consider using
164      * {ReentrancyGuard} or the
165      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
166      */
167     function sendValue(address payable recipient, uint256 amount) internal {
168         require(address(this).balance >= amount, "Address: insufficient balance");
169 
170         (bool success, ) = recipient.call{value: amount}("");
171         require(success, "Address: unable to send value, recipient may have reverted");
172     }
173 
174     /**
175      * @dev Performs a Solidity function call using a low level `call`. A
176      * plain `call` is an unsafe replacement for a function call: use this
177      * function instead.
178      *
179      * If `target` reverts with a revert reason, it is bubbled up by this
180      * function (like regular Solidity function calls).
181      *
182      * Returns the raw returned data. To convert to the expected return value,
183      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
184      *
185      * Requirements:
186      *
187      * - `target` must be a contract.
188      * - calling `target` with `data` must not revert.
189      *
190      * _Available since v3.1._
191      */
192     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
193         return functionCall(target, data, "Address: low-level call failed");
194     }
195 
196     /**
197      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
198      * `errorMessage` as a fallback revert reason when `target` reverts.
199      *
200      * _Available since v3.1._
201      */
202     function functionCall(
203         address target,
204         bytes memory data,
205         string memory errorMessage
206     ) internal returns (bytes memory) {
207         return functionCallWithValue(target, data, 0, errorMessage);
208     }
209 
210     /**
211      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
212      * but also transferring `value` wei to `target`.
213      *
214      * Requirements:
215      *
216      * - the calling contract must have an ETH balance of at least `value`.
217      * - the called Solidity function must be `payable`.
218      *
219      * _Available since v3.1._
220      */
221     function functionCallWithValue(
222         address target,
223         bytes memory data,
224         uint256 value
225     ) internal returns (bytes memory) {
226         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
227     }
228 
229     /**
230      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
231      * with `errorMessage` as a fallback revert reason when `target` reverts.
232      *
233      * _Available since v3.1._
234      */
235     function functionCallWithValue(
236         address target,
237         bytes memory data,
238         uint256 value,
239         string memory errorMessage
240     ) internal returns (bytes memory) {
241         require(address(this).balance >= value, "Address: insufficient balance for call");
242         require(isContract(target), "Address: call to non-contract");
243 
244         (bool success, bytes memory returndata) = target.call{value: value}(data);
245         return verifyCallResult(success, returndata, errorMessage);
246     }
247 
248     /**
249      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
250      * but performing a static call.
251      *
252      * _Available since v3.3._
253      */
254     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
255         return functionStaticCall(target, data, "Address: low-level static call failed");
256     }
257 
258     /**
259      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
260      * but performing a static call.
261      *
262      * _Available since v3.3._
263      */
264     function functionStaticCall(
265         address target,
266         bytes memory data,
267         string memory errorMessage
268     ) internal view returns (bytes memory) {
269         require(isContract(target), "Address: static call to non-contract");
270 
271         (bool success, bytes memory returndata) = target.staticcall(data);
272         return verifyCallResult(success, returndata, errorMessage);
273     }
274 
275     /**
276      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
277      * but performing a delegate call.
278      *
279      * _Available since v3.4._
280      */
281     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
282         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
283     }
284 
285     /**
286      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
287      * but performing a delegate call.
288      *
289      * _Available since v3.4._
290      */
291     function functionDelegateCall(
292         address target,
293         bytes memory data,
294         string memory errorMessage
295     ) internal returns (bytes memory) {
296         require(isContract(target), "Address: delegate call to non-contract");
297 
298         (bool success, bytes memory returndata) = target.delegatecall(data);
299         return verifyCallResult(success, returndata, errorMessage);
300     }
301 
302     /**
303      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
304      * revert reason using the provided one.
305      *
306      * _Available since v4.3._
307      */
308     function verifyCallResult(
309         bool success,
310         bytes memory returndata,
311         string memory errorMessage
312     ) internal pure returns (bytes memory) {
313         if (success) {
314             return returndata;
315         } else {
316             // Look for revert reason and bubble it up if present
317             if (returndata.length > 0) {
318                 // The easiest way to bubble the revert reason is using memory via assembly
319 
320                 assembly {
321                     let returndata_size := mload(returndata)
322                     revert(add(32, returndata), returndata_size)
323                 }
324             } else {
325                 revert(errorMessage);
326             }
327         }
328     }
329 }
330 
331 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
332 
333 
334 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/IERC20.sol)
335 
336 pragma solidity ^0.8.0;
337 
338 /**
339  * @dev Interface of the ERC20 standard as defined in the EIP.
340  */
341 interface IERC20 {
342     /**
343      * @dev Returns the amount of tokens in existence.
344      */
345     function totalSupply() external view returns (uint256);
346 
347     /**
348      * @dev Returns the amount of tokens owned by `account`.
349      */
350     function balanceOf(address account) external view returns (uint256);
351 
352     /**
353      * @dev Moves `amount` tokens from the caller's account to `to`.
354      *
355      * Returns a boolean value indicating whether the operation succeeded.
356      *
357      * Emits a {Transfer} event.
358      */
359     function transfer(address to, uint256 amount) external returns (bool);
360 
361     /**
362      * @dev Returns the remaining number of tokens that `spender` will be
363      * allowed to spend on behalf of `owner` through {transferFrom}. This is
364      * zero by default.
365      *
366      * This value changes when {approve} or {transferFrom} are called.
367      */
368     function allowance(address owner, address spender) external view returns (uint256);
369 
370     /**
371      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
372      *
373      * Returns a boolean value indicating whether the operation succeeded.
374      *
375      * IMPORTANT: Beware that changing an allowance with this method brings the risk
376      * that someone may use both the old and the new allowance by unfortunate
377      * transaction ordering. One possible solution to mitigate this race
378      * condition is to first reduce the spender's allowance to 0 and set the
379      * desired value afterwards:
380      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
381      *
382      * Emits an {Approval} event.
383      */
384     function approve(address spender, uint256 amount) external returns (bool);
385 
386     /**
387      * @dev Moves `amount` tokens from `from` to `to` using the
388      * allowance mechanism. `amount` is then deducted from the caller's
389      * allowance.
390      *
391      * Returns a boolean value indicating whether the operation succeeded.
392      *
393      * Emits a {Transfer} event.
394      */
395     function transferFrom(
396         address from,
397         address to,
398         uint256 amount
399     ) external returns (bool);
400 
401     /**
402      * @dev Emitted when `value` tokens are moved from one account (`from`) to
403      * another (`to`).
404      *
405      * Note that `value` may be zero.
406      */
407     event Transfer(address indexed from, address indexed to, uint256 value);
408 
409     /**
410      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
411      * a call to {approve}. `value` is the new allowance.
412      */
413     event Approval(address indexed owner, address indexed spender, uint256 value);
414 }
415 
416 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
417 
418 
419 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
420 
421 pragma solidity ^0.8.0;
422 
423 
424 /**
425  * @dev Interface for the optional metadata functions from the ERC20 standard.
426  *
427  * _Available since v4.1._
428  */
429 interface IERC20Metadata is IERC20 {
430     /**
431      * @dev Returns the name of the token.
432      */
433     function name() external view returns (string memory);
434 
435     /**
436      * @dev Returns the symbol of the token.
437      */
438     function symbol() external view returns (string memory);
439 
440     /**
441      * @dev Returns the decimals places of the token.
442      */
443     function decimals() external view returns (uint8);
444 }
445 
446 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
447 
448 
449 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/ERC20.sol)
450 
451 pragma solidity ^0.8.0;
452 
453 
454 
455 
456 /**
457  * @dev Implementation of the {IERC20} interface.
458  *
459  * This implementation is agnostic to the way tokens are created. This means
460  * that a supply mechanism has to be added in a derived contract using {_mint}.
461  * For a generic mechanism see {ERC20PresetMinterPauser}.
462  *
463  * TIP: For a detailed writeup see our guide
464  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
465  * to implement supply mechanisms].
466  *
467  * We have followed general OpenZeppelin Contracts guidelines: functions revert
468  * instead returning `false` on failure. This behavior is nonetheless
469  * conventional and does not conflict with the expectations of ERC20
470  * applications.
471  *
472  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
473  * This allows applications to reconstruct the allowance for all accounts just
474  * by listening to said events. Other implementations of the EIP may not emit
475  * these events, as it isn't required by the specification.
476  *
477  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
478  * functions have been added to mitigate the well-known issues around setting
479  * allowances. See {IERC20-approve}.
480  */
481 contract ERC20 is Context, IERC20, IERC20Metadata {
482     mapping(address => uint256) private _balances;
483 
484     mapping(address => mapping(address => uint256)) private _allowances;
485 
486     uint256 private _totalSupply;
487 
488     string private _name;
489     string private _symbol;
490 
491     /**
492      * @dev Sets the values for {name} and {symbol}.
493      *
494      * The default value of {decimals} is 18. To select a different value for
495      * {decimals} you should overload it.
496      *
497      * All two of these values are immutable: they can only be set once during
498      * construction.
499      */
500     constructor(string memory name_, string memory symbol_) {
501         _name = name_;
502         _symbol = symbol_;
503     }
504 
505     /**
506      * @dev Returns the name of the token.
507      */
508     function name() public view virtual override returns (string memory) {
509         return _name;
510     }
511 
512     /**
513      * @dev Returns the symbol of the token, usually a shorter version of the
514      * name.
515      */
516     function symbol() public view virtual override returns (string memory) {
517         return _symbol;
518     }
519 
520     /**
521      * @dev Returns the number of decimals used to get its user representation.
522      * For example, if `decimals` equals `2`, a balance of `505` tokens should
523      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
524      *
525      * Tokens usually opt for a value of 18, imitating the relationship between
526      * Ether and Wei. This is the value {ERC20} uses, unless this function is
527      * overridden;
528      *
529      * NOTE: This information is only used for _display_ purposes: it in
530      * no way affects any of the arithmetic of the contract, including
531      * {IERC20-balanceOf} and {IERC20-transfer}.
532      */
533     function decimals() public view virtual override returns (uint8) {
534         return 18;
535     }
536 
537     /**
538      * @dev See {IERC20-totalSupply}.
539      */
540     function totalSupply() public view virtual override returns (uint256) {
541         return _totalSupply;
542     }
543 
544     /**
545      * @dev See {IERC20-balanceOf}.
546      */
547     function balanceOf(address account) public view virtual override returns (uint256) {
548         return _balances[account];
549     }
550 
551     /**
552      * @dev See {IERC20-transfer}.
553      *
554      * Requirements:
555      *
556      * - `to` cannot be the zero address.
557      * - the caller must have a balance of at least `amount`.
558      */
559     function transfer(address to, uint256 amount) public virtual override returns (bool) {
560         address owner = _msgSender();
561         _transfer(owner, to, amount);
562         return true;
563     }
564 
565     /**
566      * @dev See {IERC20-allowance}.
567      */
568     function allowance(address owner, address spender) public view virtual override returns (uint256) {
569         return _allowances[owner][spender];
570     }
571 
572     /**
573      * @dev See {IERC20-approve}.
574      *
575      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
576      * `transferFrom`. This is semantically equivalent to an infinite approval.
577      *
578      * Requirements:
579      *
580      * - `spender` cannot be the zero address.
581      */
582     function approve(address spender, uint256 amount) public virtual override returns (bool) {
583         address owner = _msgSender();
584         _approve(owner, spender, amount);
585         return true;
586     }
587 
588     /**
589      * @dev See {IERC20-transferFrom}.
590      *
591      * Emits an {Approval} event indicating the updated allowance. This is not
592      * required by the EIP. See the note at the beginning of {ERC20}.
593      *
594      * NOTE: Does not update the allowance if the current allowance
595      * is the maximum `uint256`.
596      *
597      * Requirements:
598      *
599      * - `from` and `to` cannot be the zero address.
600      * - `from` must have a balance of at least `amount`.
601      * - the caller must have allowance for ``from``'s tokens of at least
602      * `amount`.
603      */
604     function transferFrom(
605         address from,
606         address to,
607         uint256 amount
608     ) public virtual override returns (bool) {
609         address spender = _msgSender();
610         _spendAllowance(from, spender, amount);
611         _transfer(from, to, amount);
612         return true;
613     }
614 
615     /**
616      * @dev Atomically increases the allowance granted to `spender` by the caller.
617      *
618      * This is an alternative to {approve} that can be used as a mitigation for
619      * problems described in {IERC20-approve}.
620      *
621      * Emits an {Approval} event indicating the updated allowance.
622      *
623      * Requirements:
624      *
625      * - `spender` cannot be the zero address.
626      */
627     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
628         address owner = _msgSender();
629         _approve(owner, spender, _allowances[owner][spender] + addedValue);
630         return true;
631     }
632 
633     /**
634      * @dev Atomically decreases the allowance granted to `spender` by the caller.
635      *
636      * This is an alternative to {approve} that can be used as a mitigation for
637      * problems described in {IERC20-approve}.
638      *
639      * Emits an {Approval} event indicating the updated allowance.
640      *
641      * Requirements:
642      *
643      * - `spender` cannot be the zero address.
644      * - `spender` must have allowance for the caller of at least
645      * `subtractedValue`.
646      */
647     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
648         address owner = _msgSender();
649         uint256 currentAllowance = _allowances[owner][spender];
650         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
651         unchecked {
652             _approve(owner, spender, currentAllowance - subtractedValue);
653         }
654 
655         return true;
656     }
657 
658     /**
659      * @dev Moves `amount` of tokens from `sender` to `recipient`.
660      *
661      * This internal function is equivalent to {transfer}, and can be used to
662      * e.g. implement automatic token fees, slashing mechanisms, etc.
663      *
664      * Emits a {Transfer} event.
665      *
666      * Requirements:
667      *
668      * - `from` cannot be the zero address.
669      * - `to` cannot be the zero address.
670      * - `from` must have a balance of at least `amount`.
671      */
672     function _transfer(
673         address from,
674         address to,
675         uint256 amount
676     ) internal virtual {
677         require(from != address(0), "ERC20: transfer from the zero address");
678         require(to != address(0), "ERC20: transfer to the zero address");
679 
680         _beforeTokenTransfer(from, to, amount);
681 
682         uint256 fromBalance = _balances[from];
683         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
684         unchecked {
685             _balances[from] = fromBalance - amount;
686         }
687         _balances[to] += amount;
688 
689         emit Transfer(from, to, amount);
690 
691         _afterTokenTransfer(from, to, amount);
692     }
693 
694     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
695      * the total supply.
696      *
697      * Emits a {Transfer} event with `from` set to the zero address.
698      *
699      * Requirements:
700      *
701      * - `account` cannot be the zero address.
702      */
703     function _mint(address account, uint256 amount) internal virtual {
704         require(account != address(0), "ERC20: mint to the zero address");
705 
706         _beforeTokenTransfer(address(0), account, amount);
707 
708         _totalSupply += amount;
709         _balances[account] += amount;
710         emit Transfer(address(0), account, amount);
711 
712         _afterTokenTransfer(address(0), account, amount);
713     }
714 
715     /**
716      * @dev Destroys `amount` tokens from `account`, reducing the
717      * total supply.
718      *
719      * Emits a {Transfer} event with `to` set to the zero address.
720      *
721      * Requirements:
722      *
723      * - `account` cannot be the zero address.
724      * - `account` must have at least `amount` tokens.
725      */
726     function _burn(address account, uint256 amount) internal virtual {
727         require(account != address(0), "ERC20: burn from the zero address");
728 
729         _beforeTokenTransfer(account, address(0), amount);
730 
731         uint256 accountBalance = _balances[account];
732         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
733         unchecked {
734             _balances[account] = accountBalance - amount;
735         }
736         _totalSupply -= amount;
737 
738         emit Transfer(account, address(0), amount);
739 
740         _afterTokenTransfer(account, address(0), amount);
741     }
742 
743     /**
744      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
745      *
746      * This internal function is equivalent to `approve`, and can be used to
747      * e.g. set automatic allowances for certain subsystems, etc.
748      *
749      * Emits an {Approval} event.
750      *
751      * Requirements:
752      *
753      * - `owner` cannot be the zero address.
754      * - `spender` cannot be the zero address.
755      */
756     function _approve(
757         address owner,
758         address spender,
759         uint256 amount
760     ) internal virtual {
761         require(owner != address(0), "ERC20: approve from the zero address");
762         require(spender != address(0), "ERC20: approve to the zero address");
763 
764         _allowances[owner][spender] = amount;
765         emit Approval(owner, spender, amount);
766     }
767 
768     /**
769      * @dev Spend `amount` form the allowance of `owner` toward `spender`.
770      *
771      * Does not update the allowance amount in case of infinite allowance.
772      * Revert if not enough allowance is available.
773      *
774      * Might emit an {Approval} event.
775      */
776     function _spendAllowance(
777         address owner,
778         address spender,
779         uint256 amount
780     ) internal virtual {
781         uint256 currentAllowance = allowance(owner, spender);
782         if (currentAllowance != type(uint256).max) {
783             require(currentAllowance >= amount, "ERC20: insufficient allowance");
784             unchecked {
785                 _approve(owner, spender, currentAllowance - amount);
786             }
787         }
788     }
789 
790     /**
791      * @dev Hook that is called before any transfer of tokens. This includes
792      * minting and burning.
793      *
794      * Calling conditions:
795      *
796      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
797      * will be transferred to `to`.
798      * - when `from` is zero, `amount` tokens will be minted for `to`.
799      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
800      * - `from` and `to` are never both zero.
801      *
802      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
803      */
804     function _beforeTokenTransfer(
805         address from,
806         address to,
807         uint256 amount
808     ) internal virtual {}
809 
810     /**
811      * @dev Hook that is called after any transfer of tokens. This includes
812      * minting and burning.
813      *
814      * Calling conditions:
815      *
816      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
817      * has been transferred to `to`.
818      * - when `from` is zero, `amount` tokens have been minted for `to`.
819      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
820      * - `from` and `to` are never both zero.
821      *
822      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
823      */
824     function _afterTokenTransfer(
825         address from,
826         address to,
827         uint256 amount
828     ) internal virtual {}
829 }
830 
831 // File: @openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol
832 
833 
834 // OpenZeppelin Contracts v4.4.1 (token/ERC20/utils/SafeERC20.sol)
835 
836 pragma solidity ^0.8.0;
837 
838 
839 
840 /**
841  * @title SafeERC20
842  * @dev Wrappers around ERC20 operations that throw on failure (when the token
843  * contract returns false). Tokens that return no value (and instead revert or
844  * throw on failure) are also supported, non-reverting calls are assumed to be
845  * successful.
846  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
847  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
848  */
849 library SafeERC20 {
850     using Address for address;
851 
852     function safeTransfer(
853         IERC20 token,
854         address to,
855         uint256 value
856     ) internal {
857         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
858     }
859 
860     function safeTransferFrom(
861         IERC20 token,
862         address from,
863         address to,
864         uint256 value
865     ) internal {
866         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
867     }
868 
869     /**
870      * @dev Deprecated. This function has issues similar to the ones found in
871      * {IERC20-approve}, and its usage is discouraged.
872      *
873      * Whenever possible, use {safeIncreaseAllowance} and
874      * {safeDecreaseAllowance} instead.
875      */
876     function safeApprove(
877         IERC20 token,
878         address spender,
879         uint256 value
880     ) internal {
881         // safeApprove should only be called when setting an initial allowance,
882         // or when resetting it to zero. To increase and decrease it, use
883         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
884         require(
885             (value == 0) || (token.allowance(address(this), spender) == 0),
886             "SafeERC20: approve from non-zero to non-zero allowance"
887         );
888         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
889     }
890 
891     function safeIncreaseAllowance(
892         IERC20 token,
893         address spender,
894         uint256 value
895     ) internal {
896         uint256 newAllowance = token.allowance(address(this), spender) + value;
897         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
898     }
899 
900     function safeDecreaseAllowance(
901         IERC20 token,
902         address spender,
903         uint256 value
904     ) internal {
905         unchecked {
906             uint256 oldAllowance = token.allowance(address(this), spender);
907             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
908             uint256 newAllowance = oldAllowance - value;
909             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
910         }
911     }
912 
913     /**
914      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
915      * on the return value: the return value is optional (but if data is returned, it must not be false).
916      * @param token The token targeted by the call.
917      * @param data The call data (encoded using abi.encode or one of its variants).
918      */
919     function _callOptionalReturn(IERC20 token, bytes memory data) private {
920         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
921         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
922         // the target address contains contract code and also asserts for success in the low-level call.
923 
924         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
925         if (returndata.length > 0) {
926             // Return data is optional
927             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
928         }
929     }
930 }
931 
932 // File: contracts/ExpoCompoundVault.sol
933 
934 pragma solidity ^0.8.0;
935 
936 
937 
938 
939 interface IUniswapV2Router01 {
940     function WETH() external pure returns (address);
941 }
942 
943 interface IUniswapV2Router02 is IUniswapV2Router01 {
944     function swapExactETHForTokensSupportingFeeOnTransferTokens(
945         uint256 amountOutMin,
946         address[] calldata path,
947         address to,
948         uint256 deadline
949     ) external payable;
950 }
951 
952 interface IEXPO {
953     function withdrawableDividendOf(address account) external view returns (uint256);
954     function claim() external;
955     function transferFrom(address, address, uint256) external returns (bool);
956     function transfer(address, uint256) external returns (bool);
957     function balanceOf(address account) external view returns (uint256);
958 }
959 
960 contract ExpoCompoundVault is Ownable {
961     using SafeERC20 for IERC20;
962 
963     // Info of each user.
964     struct UserInfo {
965         uint256 amount;
966         uint256 rewardDebt;
967         uint256 compoundedExpo;
968     }
969 
970     IEXPO public immutable expo;
971     uint256 public accExpoPerShare;
972     uint256 public totalDeposited;
973     uint256 public compoundAtAmount = 0.1 ether;
974     uint256 public startTime;
975     uint256 public lastRewardTime;
976     uint256 public totalPeriods;
977     uint256 public totalCompoundedExpo;
978     uint256 public totalETHCompounded;
979     bool public launched;
980     IUniswapV2Router02 public uniswapV2Router;
981     mapping (address => UserInfo) public userInfo;
982     mapping (address => bool) public isAuthorized;
983 
984     event Deposit(address indexed user, uint256 amount);
985     event Compound(address indexed user, uint256 amount);
986     event Withdraw(address indexed user, uint256 amount);
987     event EmergencyWithdraw(address indexed user, uint256 amount);
988 
989     constructor(
990         IEXPO _expo
991     ) {
992         expo = _expo;
993         startTime = block.timestamp;
994         lastRewardTime = block.timestamp;
995         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
996         uniswapV2Router = _uniswapV2Router;
997         isAuthorized[owner()] = true;
998     }
999 
1000     receive() external payable {}
1001 
1002     function _update() internal {
1003         if (block.timestamp > lastRewardTime) {
1004             uint256 stakedEXPO = totalDeposited;
1005             if (stakedEXPO > 0) {
1006                 uint256 ethToCompound = IEXPO(expo).withdrawableDividendOf(address(this));
1007                 uint256 threshold = compoundAtAmount;
1008                 if (address(this).balance + ethToCompound >= threshold) {
1009                     if (address(this).balance < threshold) {
1010                         IEXPO(expo).claim();
1011                     }
1012 
1013                     uint256 expoReward = swapForEXPO(threshold);
1014 
1015                     totalETHCompounded += threshold;
1016                     totalCompoundedExpo += expoReward;
1017                     accExpoPerShare += (expoReward * 1e18) / stakedEXPO;
1018                     totalPeriods++;
1019                 }
1020             }
1021             lastRewardTime = block.timestamp;
1022         }
1023     }
1024 
1025     function deposit(uint256 _amount) public {
1026         UserInfo storage user = userInfo[msg.sender];
1027         _update();
1028         uint256 pending;
1029         if (user.amount > 0) {
1030             pending = (user.amount * accExpoPerShare / 1e18) - user.rewardDebt;
1031             user.compoundedExpo += pending;
1032             emit Compound(msg.sender, pending);
1033         }
1034         user.amount += _amount + pending;
1035         totalDeposited += _amount + pending;
1036         user.rewardDebt = user.amount * accExpoPerShare / 1e18;
1037         expo.transferFrom(address(msg.sender), address(this), _amount);
1038         emit Deposit(msg.sender, _amount);
1039     }
1040 
1041     function withdraw(uint256 _amount) public {
1042         UserInfo storage user = userInfo[msg.sender];
1043         uint256 uAmount = user.amount;
1044         _update();
1045         uint256 pending = (uAmount * accExpoPerShare / 1e18) - user.rewardDebt;
1046         require(uAmount + pending >= _amount, "withdraw: not good");
1047         if (pending > _amount) {
1048             user.compoundedExpo += (pending - _amount);
1049             emit Compound(msg.sender, pending - _amount);
1050         }
1051         uAmount = uAmount + pending - _amount;
1052         totalDeposited = totalDeposited + pending - _amount;
1053         user.amount = uAmount;
1054         user.rewardDebt = uAmount * accExpoPerShare / 1e18;
1055         safeExpoTransfer(msg.sender, _amount);
1056         emit Withdraw(msg.sender, _amount);
1057     }
1058 
1059     // Withdraw without updating rewards. EMERGENCY ONLY.
1060     function emergencyWithdraw() public {
1061         UserInfo storage user = userInfo[msg.sender];
1062         uint amount = user.amount;
1063         uint256 pending = (amount * accExpoPerShare / 1e18) - user.rewardDebt;
1064         user.amount = 0;
1065         totalDeposited -= amount;
1066         user.rewardDebt = 0;
1067 
1068         safeExpoTransfer(address(msg.sender), amount + pending);
1069         emit EmergencyWithdraw(msg.sender, amount + pending);
1070 
1071     }
1072 
1073     // Safe EXPO transfer function, just in case if rounding error causes pool to not have enough EXPO.
1074     function safeExpoTransfer(address _to, uint256 _amount) internal {
1075         uint256 expoBal = expo.balanceOf(address(this));
1076         if (_amount > expoBal) {
1077             expo.transfer(_to, expoBal);
1078         } else {
1079             expo.transfer(_to, _amount);
1080         }
1081     }
1082 
1083     function update() public {
1084         require(isAuthorized[msg.sender]);
1085         uint256 stakedEXPO = totalDeposited;
1086         if (stakedEXPO > 0) {
1087             IEXPO(expo).claim();
1088 
1089             uint256 ethToCompound = address(this).balance;
1090             uint256 expoReward = swapForEXPO(ethToCompound);
1091 
1092             totalETHCompounded += ethToCompound;
1093             totalCompoundedExpo += expoReward;
1094             accExpoPerShare += (expoReward * 1e18) / stakedEXPO;
1095             totalPeriods++;
1096         }
1097         lastRewardTime = block.timestamp;
1098 
1099     }
1100 
1101     function swapForEXPO(uint256 amount) private returns (uint256) {
1102         uint256 before = expo.balanceOf(address(this));
1103         address[] memory path = new address[](2);
1104         path[0] = uniswapV2Router.WETH();
1105         path[1] = address(expo);
1106 
1107         uniswapV2Router.swapExactETHForTokensSupportingFeeOnTransferTokens{value: amount}(
1108             0,
1109             path,
1110             address(this),
1111             block.timestamp
1112         );
1113 
1114         return expo.balanceOf(address(this)) - before;
1115     }
1116 
1117     function setCompoundAtAmount(uint256 amount) external onlyOwner {
1118         compoundAtAmount = amount;
1119     }
1120 
1121     function setAuthorized(address user, bool value) external onlyOwner {
1122          isAuthorized[user] = value;
1123     }
1124 
1125     function launch() public onlyOwner {
1126         require(!launched, "Already launched.");
1127         totalDeposited = 0;
1128         totalCompoundedExpo = 0;
1129         totalETHCompounded = 0;
1130         totalPeriods = 0;
1131         startTime = block.timestamp;
1132         lastRewardTime = block.timestamp;
1133         launched = true;
1134     }
1135 
1136     function emergencyERC20Withdraw(address token, address recipient) external onlyOwner {
1137          require(token != address(expo), "Cannot withdraw EXPO");
1138          IERC20(token).transfer(recipient, IERC20(token).balanceOf(address(this)));
1139     }
1140 
1141     function emergencyETHWithdraw(address recipient) external onlyOwner {
1142          (bool success, ) = recipient.call{value: address(this).balance}("");
1143          require(success, "Unable to withdraw ETH.");
1144     }
1145 
1146     function balance(address user) public view returns (uint256) {
1147         UserInfo memory _user = userInfo[user];
1148         uint256 pending = (_user.amount * accExpoPerShare / 1e18) - _user.rewardDebt;
1149         return _user.amount + pending;
1150     }
1151 
1152     function pendingRewards(address user) public view returns (uint256) {
1153         UserInfo memory _user = userInfo[user];
1154         return (_user.amount * accExpoPerShare / 1e18) - _user.rewardDebt;
1155     }
1156 
1157     function getPlatformAPR() public view returns (uint256) {
1158         if (totalDeposited > totalCompoundedExpo) {
1159             return (((totalCompoundedExpo * 365 days * 100 * 10**6) / (totalDeposited - totalCompoundedExpo)) / (lastRewardTime - startTime));
1160         }
1161         return 0;
1162     }
1163 
1164     function getPlatformAPY() public view returns (uint256) {
1165         uint256 principal = totalDeposited - totalCompoundedExpo;
1166         uint256 periodsPerYear = (totalPeriods * 365 days) / (lastRewardTime - startTime);
1167 
1168         uint256 APRPerPeriod = getPlatformAPR() / periodsPerYear;
1169 
1170         uint256 compBal = principal;
1171         for (uint256 i = 0; i < periodsPerYear; i++) {
1172             compBal = ( compBal * ((100 * 10**8) + APRPerPeriod) ) / (100 * 10**8);
1173         }
1174 
1175         return ((compBal - principal) * 100 * 10**2) / principal;
1176     }
1177 
1178     function getUserAPY(address user) public view returns (uint256) {
1179         UserInfo memory _user = userInfo[user];
1180         uint256 principal = _user.amount - _user.compoundedExpo;
1181         uint256 periodsPerYear = (totalPeriods * 365 days) / (lastRewardTime - startTime);
1182 
1183         uint256 APRPerPeriod = getPlatformAPR() / periodsPerYear;
1184 
1185         uint256 compBal = principal;
1186         for (uint256 i = 0; i < periodsPerYear; i++) {
1187             compBal = ( compBal * ((100 * 10**8) + APRPerPeriod) ) / (100 * 10**8);
1188         }
1189 
1190         return ((compBal - principal) * 100 * 10**2) / principal;
1191     }
1192 
1193 }