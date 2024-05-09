1 // File: @openzeppelin/contracts/utils/Address.sol
2 
3 
4 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
5 
6 pragma solidity ^0.8.9;
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
35         assembly {
36             size := extcodesize(account)
37         }
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
60         (bool success, ) = recipient.call{value: amount}("");
61         require(success, "Address: unable to send value, recipient may have reverted");
62     }
63 
64     /**
65      * @dev Performs a Solidity function call using a low level `call`. A
66      * plain `call` is an unsafe replacement for a function call: use this
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
83         return functionCall(target, data, "Address: low-level call failed");
84     }
85 
86     /**
87      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
88      * `errorMessage` as a fallback revert reason when `target` reverts.
89      *
90      * _Available since v3.1._
91      */
92     function functionCall(
93         address target,
94         bytes memory data,
95         string memory errorMessage
96     ) internal returns (bytes memory) {
97         return functionCallWithValue(target, data, 0, errorMessage);
98     }
99 
100     /**
101      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
102      * but also transferring `value` wei to `target`.
103      *
104      * Requirements:
105      *
106      * - the calling contract must have an ETH balance of at least `value`.
107      * - the called Solidity function must be `payable`.
108      *
109      * _Available since v3.1._
110      */
111     function functionCallWithValue(
112         address target,
113         bytes memory data,
114         uint256 value
115     ) internal returns (bytes memory) {
116         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
117     }
118 
119     /**
120      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
121      * with `errorMessage` as a fallback revert reason when `target` reverts.
122      *
123      * _Available since v3.1._
124      */
125     function functionCallWithValue(
126         address target,
127         bytes memory data,
128         uint256 value,
129         string memory errorMessage
130     ) internal returns (bytes memory) {
131         require(address(this).balance >= value, "Address: insufficient balance for call");
132         require(isContract(target), "Address: call to non-contract");
133 
134         (bool success, bytes memory returndata) = target.call{value: value}(data);
135         return verifyCallResult(success, returndata, errorMessage);
136     }
137 
138     /**
139      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
140      * but performing a static call.
141      *
142      * _Available since v3.3._
143      */
144     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
145         return functionStaticCall(target, data, "Address: low-level static call failed");
146     }
147 
148     /**
149      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
150      * but performing a static call.
151      *
152      * _Available since v3.3._
153      */
154     function functionStaticCall(
155         address target,
156         bytes memory data,
157         string memory errorMessage
158     ) internal view returns (bytes memory) {
159         require(isContract(target), "Address: static call to non-contract");
160 
161         (bool success, bytes memory returndata) = target.staticcall(data);
162         return verifyCallResult(success, returndata, errorMessage);
163     }
164 
165     /**
166      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
167      * but performing a delegate call.
168      *
169      * _Available since v3.4._
170      */
171     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
172         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
173     }
174 
175     /**
176      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
177      * but performing a delegate call.
178      *
179      * _Available since v3.4._
180      */
181     function functionDelegateCall(
182         address target,
183         bytes memory data,
184         string memory errorMessage
185     ) internal returns (bytes memory) {
186         require(isContract(target), "Address: delegate call to non-contract");
187 
188         (bool success, bytes memory returndata) = target.delegatecall(data);
189         return verifyCallResult(success, returndata, errorMessage);
190     }
191 
192     /**
193      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
194      * revert reason using the provided one.
195      *
196      * _Available since v4.3._
197      */
198     function verifyCallResult(
199         bool success,
200         bytes memory returndata,
201         string memory errorMessage
202     ) internal pure returns (bytes memory) {
203         if (success) {
204             return returndata;
205         } else {
206             // Look for revert reason and bubble it up if present
207             if (returndata.length > 0) {
208                 // The easiest way to bubble the revert reason is using memory via assembly
209 
210                 assembly {
211                     let returndata_size := mload(returndata)
212                     revert(add(32, returndata), returndata_size)
213                 }
214             } else {
215                 revert(errorMessage);
216             }
217         }
218     }
219 }
220 
221 // File: @openzeppelin/contracts/utils/Context.sol
222 
223 
224 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
225 
226 //pragma solidity ^0.8.0;
227 
228 /**
229  * @dev Provides information about the current execution context, including the
230  * sender of the transaction and its data. While these are generally available
231  * via msg.sender and msg.data, they should not be accessed in such a direct
232  * manner, since when dealing with meta-transactions the account sending and
233  * paying for execution may not be the actual sender (as far as an application
234  * is concerned).
235  *
236  * This contract is only required for intermediate, library-like contracts.
237  */
238 abstract contract Context {
239     function _msgSender() internal view virtual returns (address) {
240         return msg.sender;
241     }
242 
243     function _msgData() internal view virtual returns (bytes calldata) {
244         return msg.data;
245     }
246 }
247 
248 // File: @openzeppelin/contracts/security/Pausable.sol
249 
250 
251 // OpenZeppelin Contracts v4.4.1 (security/Pausable.sol)
252 
253 //pragma solidity ^0.8.0;
254 
255 
256 /**
257  * @dev Contract module which allows children to implement an emergency stop
258  * mechanism that can be triggered by an authorized account.
259  *
260  * This module is used through inheritance. It will make available the
261  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
262  * the functions of your contract. Note that they will not be pausable by
263  * simply including this module, only once the modifiers are put in place.
264  */
265 abstract contract Pausable is Context {
266     /**
267      * @dev Emitted when the pause is triggered by `account`.
268      */
269     event Paused(address account);
270 
271     /**
272      * @dev Emitted when the pause is lifted by `account`.
273      */
274     event Unpaused(address account);
275 
276     bool private _paused;
277 
278     /**
279      * @dev Initializes the contract in unpaused state.
280      */
281     constructor() {
282         _paused = false;
283     }
284 
285     /**
286      * @dev Returns true if the contract is paused, and false otherwise.
287      */
288     function paused() public view virtual returns (bool) {
289         return _paused;
290     }
291 
292     /**
293      * @dev Modifier to make a function callable only when the contract is not paused.
294      *
295      * Requirements:
296      *
297      * - The contract must not be paused.
298      */
299     modifier whenNotPaused() {
300         require(!paused(), "Pausable: paused");
301         _;
302     }
303 
304     /**
305      * @dev Modifier to make a function callable only when the contract is paused.
306      *
307      * Requirements:
308      *
309      * - The contract must be paused.
310      */
311     modifier whenPaused() {
312         require(paused(), "Pausable: not paused");
313         _;
314     }
315 
316     /**
317      * @dev Triggers stopped state.
318      *
319      * Requirements:
320      *
321      * - The contract must not be paused.
322      */
323     function _pause() internal virtual whenNotPaused {
324         _paused = true;
325         emit Paused(_msgSender());
326     }
327 
328     /**
329      * @dev Returns to normal state.
330      *
331      * Requirements:
332      *
333      * - The contract must be paused.
334      */
335     function _unpause() internal virtual whenPaused {
336         _paused = false;
337         emit Unpaused(_msgSender());
338     }
339 }
340 
341 // File: @openzeppelin/contracts/access/Ownable.sol
342 
343 
344 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
345 
346 //pragma solidity ^0.8.0;
347 
348 
349 /**
350  * @dev Contract module which provides a basic access control mechanism, where
351  * there is an account (an owner) that can be granted exclusive access to
352  * specific functions.
353  *
354  * By default, the owner account will be the one that deploys the contract. This
355  * can later be changed with {transferOwnership}.
356  *
357  * This module is used through inheritance. It will make available the modifier
358  * `onlyOwner`, which can be applied to your functions to restrict their use to
359  * the owner.
360  */
361 abstract contract Ownable is Context {
362     address private _owner;
363 
364     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
365 
366     /**
367      * @dev Initializes the contract setting the deployer as the initial owner.
368      */
369     constructor() {
370         _transferOwnership(_msgSender());
371     }
372 
373     /**
374      * @dev Returns the address of the current owner.
375      */
376     function owner() public view virtual returns (address) {
377         return _owner;
378     }
379 
380     /**
381      * @dev Throws if called by any account other than the owner.
382      */
383     modifier onlyOwner() {
384         require(owner() == _msgSender(), "Ownable: caller is not the owner");
385         _;
386     }
387 
388     /**
389      * @dev Leaves the contract without owner. It will not be possible to call
390      * `onlyOwner` functions anymore. Can only be called by the current owner.
391      *
392      * NOTE: Renouncing ownership will leave the contract without an owner,
393      * thereby removing any functionality that is only available to the owner.
394      */
395     function renounceOwnership() public virtual onlyOwner {
396         _transferOwnership(address(0));
397     }
398 
399     /**
400      * @dev Transfers ownership of the contract to a new account (`newOwner`).
401      * Can only be called by the current owner.
402      */
403     function transferOwnership(address newOwner) public virtual onlyOwner {
404         require(newOwner != address(0), "Ownable: new owner is the zero address");
405         _transferOwnership(newOwner);
406     }
407 
408     /**
409      * @dev Transfers ownership of the contract to a new account (`newOwner`).
410      * Internal function without access restriction.
411      */
412     function _transferOwnership(address newOwner) internal virtual {
413         address oldOwner = _owner;
414         _owner = newOwner;
415         emit OwnershipTransferred(oldOwner, newOwner);
416     }
417 }
418 
419 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
420 
421 
422 // OpenZeppelin Contracts v4.4.1 (token/ERC20/IERC20.sol)
423 
424 //pragma solidity ^0.8.0;
425 
426 /**
427  * @dev Interface of the ERC20 standard as defined in the EIP.
428  */
429 interface IERC20 {
430     /**
431      * @dev Returns the amount of tokens in existence.
432      */
433     function totalSupply() external view returns (uint256);
434 
435     /**
436      * @dev Returns the amount of tokens owned by `account`.
437      */
438     function balanceOf(address account) external view returns (uint256);
439 
440     /**
441      * @dev Moves `amount` tokens from the caller's account to `recipient`.
442      *
443      * Returns a boolean value indicating whether the operation succeeded.
444      *
445      * Emits a {Transfer} event.
446      */
447     function transfer(address recipient, uint256 amount) external returns (bool);
448 
449     /**
450      * @dev Returns the remaining number of tokens that `spender` will be
451      * allowed to spend on behalf of `owner` through {transferFrom}. This is
452      * zero by default.
453      *
454      * This value changes when {approve} or {transferFrom} are called.
455      */
456     function allowance(address owner, address spender) external view returns (uint256);
457 
458     /**
459      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
460      *
461      * Returns a boolean value indicating whether the operation succeeded.
462      *
463      * IMPORTANT: Beware that changing an allowance with this method brings the risk
464      * that someone may use both the old and the new allowance by unfortunate
465      * transaction ordering. One possible solution to mitigate this race
466      * condition is to first reduce the spender's allowance to 0 and set the
467      * desired value afterwards:
468      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
469      *
470      * Emits an {Approval} event.
471      */
472     function approve(address spender, uint256 amount) external returns (bool);
473 
474     /**
475      * @dev Moves `amount` tokens from `sender` to `recipient` using the
476      * allowance mechanism. `amount` is then deducted from the caller's
477      * allowance.
478      *
479      * Returns a boolean value indicating whether the operation succeeded.
480      *
481      * Emits a {Transfer} event.
482      */
483     function transferFrom(
484         address sender,
485         address recipient,
486         uint256 amount
487     ) external returns (bool);
488 
489     /**
490      * @dev Emitted when `value` tokens are moved from one account (`from`) to
491      * another (`to`).
492      *
493      * Note that `value` may be zero.
494      */
495     event Transfer(address indexed from, address indexed to, uint256 value);
496 
497     /**
498      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
499      * a call to {approve}. `value` is the new allowance.
500      */
501     event Approval(address indexed owner, address indexed spender, uint256 value);
502 }
503 
504 // File: @openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol
505 
506 
507 // OpenZeppelin Contracts v4.4.1 (token/ERC20/utils/SafeERC20.sol)
508 
509 //pragma solidity ^0.8.0;
510 
511 
512 
513 /**
514  * @title SafeERC20
515  * @dev Wrappers around ERC20 operations that throw on failure (when the token
516  * contract returns false). Tokens that return no value (and instead revert or
517  * throw on failure) are also supported, non-reverting calls are assumed to be
518  * successful.
519  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
520  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
521  */
522 library SafeERC20 {
523     using Address for address;
524 
525     function safeTransfer(
526         IERC20 token,
527         address to,
528         uint256 value
529     ) internal {
530         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
531     }
532 
533     function safeTransferFrom(
534         IERC20 token,
535         address from,
536         address to,
537         uint256 value
538     ) internal {
539         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
540     }
541 
542     /**
543      * @dev Deprecated. This function has issues similar to the ones found in
544      * {IERC20-approve}, and its usage is discouraged.
545      *
546      * Whenever possible, use {safeIncreaseAllowance} and
547      * {safeDecreaseAllowance} instead.
548      */
549     function safeApprove(
550         IERC20 token,
551         address spender,
552         uint256 value
553     ) internal {
554         // safeApprove should only be called when setting an initial allowance,
555         // or when resetting it to zero. To increase and decrease it, use
556         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
557         require(
558             (value == 0) || (token.allowance(address(this), spender) == 0),
559             "SafeERC20: approve from non-zero to non-zero allowance"
560         );
561         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
562     }
563 
564     function safeIncreaseAllowance(
565         IERC20 token,
566         address spender,
567         uint256 value
568     ) internal {
569         uint256 newAllowance = token.allowance(address(this), spender) + value;
570         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
571     }
572 
573     function safeDecreaseAllowance(
574         IERC20 token,
575         address spender,
576         uint256 value
577     ) internal {
578         unchecked {
579             uint256 oldAllowance = token.allowance(address(this), spender);
580             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
581             uint256 newAllowance = oldAllowance - value;
582             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
583         }
584     }
585 
586     /**
587      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
588      * on the return value: the return value is optional (but if data is returned, it must not be false).
589      * @param token The token targeted by the call.
590      * @param data The call data (encoded using abi.encode or one of its variants).
591      */
592     function _callOptionalReturn(IERC20 token, bytes memory data) private {
593         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
594         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
595         // the target address contains contract code and also asserts for success in the low-level call.
596 
597         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
598         if (returndata.length > 0) {
599             // Return data is optional
600             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
601         }
602     }
603 }
604 
605 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
606 
607 
608 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
609 
610 //pragma solidity ^0.8.0;
611 
612 
613 /**
614  * @dev Interface for the optional metadata functions from the ERC20 standard.
615  *
616  * _Available since v4.1._
617  */
618 interface IERC20Metadata is IERC20 {
619     /**
620      * @dev Returns the name of the token.
621      */
622     function name() external view returns (string memory);
623 
624     /**
625      * @dev Returns the symbol of the token.
626      */
627     function symbol() external view returns (string memory);
628 
629     /**
630      * @dev Returns the decimals places of the token.
631      */
632     function decimals() external view returns (uint8);
633 }
634 
635 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
636 
637 
638 // OpenZeppelin Contracts v4.4.1 (token/ERC20/ERC20.sol)
639 
640 //pragma solidity ^0.8.0;
641 
642 
643 
644 
645 /**
646  * @dev Implementation of the {IERC20} interface.
647  *
648  * This implementation is agnostic to the way tokens are created. This means
649  * that a supply mechanism has to be added in a derived contract using {_mint}.
650  * For a generic mechanism see {ERC20PresetMinterPauser}.
651  *
652  * TIP: For a detailed writeup see our guide
653  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
654  * to implement supply mechanisms].
655  *
656  * We have followed general OpenZeppelin Contracts guidelines: functions revert
657  * instead returning `false` on failure. This behavior is nonetheless
658  * conventional and does not conflict with the expectations of ERC20
659  * applications.
660  *
661  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
662  * This allows applications to reconstruct the allowance for all accounts just
663  * by listening to said events. Other implementations of the EIP may not emit
664  * these events, as it isn't required by the specification.
665  *
666  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
667  * functions have been added to mitigate the well-known issues around setting
668  * allowances. See {IERC20-approve}.
669  */
670 contract ERC20 is Context, IERC20, IERC20Metadata {
671     mapping(address => uint256) private _balances;
672 
673     mapping(address => mapping(address => uint256)) private _allowances;
674 
675     uint256 private _totalSupply;
676 
677     string private _name;
678     string private _symbol;
679 
680     /**
681      * @dev Sets the values for {name} and {symbol}.
682      *
683      * The default value of {decimals} is 18. To select a different value for
684      * {decimals} you should overload it.
685      *
686      * All two of these values are immutable: they can only be set once during
687      * construction.
688      */
689     constructor(string memory name_, string memory symbol_) {
690         _name = name_;
691         _symbol = symbol_;
692     }
693 
694     /**
695      * @dev Returns the name of the token.
696      */
697     function name() public view virtual override returns (string memory) {
698         return _name;
699     }
700 
701     /**
702      * @dev Returns the symbol of the token, usually a shorter version of the
703      * name.
704      */
705     function symbol() public view virtual override returns (string memory) {
706         return _symbol;
707     }
708 
709     /**
710      * @dev Returns the number of decimals used to get its user representation.
711      * For example, if `decimals` equals `2`, a balance of `505` tokens should
712      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
713      *
714      * Tokens usually opt for a value of 18, imitating the relationship between
715      * Ether and Wei. This is the value {ERC20} uses, unless this function is
716      * overridden;
717      *
718      * NOTE: This information is only used for _display_ purposes: it in
719      * no way affects any of the arithmetic of the contract, including
720      * {IERC20-balanceOf} and {IERC20-transfer}.
721      */
722     function decimals() public view virtual override returns (uint8) {
723         return 18;
724     }
725 
726     /**
727      * @dev See {IERC20-totalSupply}.
728      */
729     function totalSupply() public view virtual override returns (uint256) {
730         return _totalSupply;
731     }
732 
733     /**
734      * @dev See {IERC20-balanceOf}.
735      */
736     function balanceOf(address account) public view virtual override returns (uint256) {
737         return _balances[account];
738     }
739 
740     /**
741      * @dev See {IERC20-transfer}.
742      *
743      * Requirements:
744      *
745      * - `recipient` cannot be the zero address.
746      * - the caller must have a balance of at least `amount`.
747      */
748     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
749         _transfer(_msgSender(), recipient, amount);
750         return true;
751     }
752 
753     /**
754      * @dev See {IERC20-allowance}.
755      */
756     function allowance(address owner, address spender) public view virtual override returns (uint256) {
757         return _allowances[owner][spender];
758     }
759 
760     /**
761      * @dev See {IERC20-approve}.
762      *
763      * Requirements:
764      *
765      * - `spender` cannot be the zero address.
766      */
767     function approve(address spender, uint256 amount) public virtual override returns (bool) {
768         _approve(_msgSender(), spender, amount);
769         return true;
770     }
771 
772     /**
773      * @dev See {IERC20-transferFrom}.
774      *
775      * Emits an {Approval} event indicating the updated allowance. This is not
776      * required by the EIP. See the note at the beginning of {ERC20}.
777      *
778      * Requirements:
779      *
780      * - `sender` and `recipient` cannot be the zero address.
781      * - `sender` must have a balance of at least `amount`.
782      * - the caller must have allowance for ``sender``'s tokens of at least
783      * `amount`.
784      */
785     function transferFrom(
786         address sender,
787         address recipient,
788         uint256 amount
789     ) public virtual override returns (bool) {
790         _transfer(sender, recipient, amount);
791 
792         uint256 currentAllowance = _allowances[sender][_msgSender()];
793         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
794         unchecked {
795             _approve(sender, _msgSender(), currentAllowance - amount);
796         }
797 
798         return true;
799     }
800 
801     /**
802      * @dev Atomically increases the allowance granted to `spender` by the caller.
803      *
804      * This is an alternative to {approve} that can be used as a mitigation for
805      * problems described in {IERC20-approve}.
806      *
807      * Emits an {Approval} event indicating the updated allowance.
808      *
809      * Requirements:
810      *
811      * - `spender` cannot be the zero address.
812      */
813     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
814         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
815         return true;
816     }
817 
818     /**
819      * @dev Atomically decreases the allowance granted to `spender` by the caller.
820      *
821      * This is an alternative to {approve} that can be used as a mitigation for
822      * problems described in {IERC20-approve}.
823      *
824      * Emits an {Approval} event indicating the updated allowance.
825      *
826      * Requirements:
827      *
828      * - `spender` cannot be the zero address.
829      * - `spender` must have allowance for the caller of at least
830      * `subtractedValue`.
831      */
832     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
833         uint256 currentAllowance = _allowances[_msgSender()][spender];
834         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
835         unchecked {
836             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
837         }
838 
839         return true;
840     }
841 
842     /**
843      * @dev Moves `amount` of tokens from `sender` to `recipient`.
844      *
845      * This internal function is equivalent to {transfer}, and can be used to
846      * e.g. implement automatic token fees, slashing mechanisms, etc.
847      *
848      * Emits a {Transfer} event.
849      *
850      * Requirements:
851      *
852      * - `sender` cannot be the zero address.
853      * - `recipient` cannot be the zero address.
854      * - `sender` must have a balance of at least `amount`.
855      */
856     function _transfer(
857         address sender,
858         address recipient,
859         uint256 amount
860     ) internal virtual {
861         require(sender != address(0), "ERC20: transfer from the zero address");
862         require(recipient != address(0), "ERC20: transfer to the zero address");
863 
864         _beforeTokenTransfer(sender, recipient, amount);
865 
866         uint256 senderBalance = _balances[sender];
867         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
868         unchecked {
869             _balances[sender] = senderBalance - amount;
870         }
871         _balances[recipient] += amount;
872 
873         emit Transfer(sender, recipient, amount);
874 
875         _afterTokenTransfer(sender, recipient, amount);
876     }
877 
878     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
879      * the total supply.
880      *
881      * Emits a {Transfer} event with `from` set to the zero address.
882      *
883      * Requirements:
884      *
885      * - `account` cannot be the zero address.
886      */
887     function _mint(address account, uint256 amount) internal virtual {
888         require(account != address(0), "ERC20: mint to the zero address");
889 
890         _beforeTokenTransfer(address(0), account, amount);
891 
892         _totalSupply += amount;
893         _balances[account] += amount;
894         emit Transfer(address(0), account, amount);
895 
896         _afterTokenTransfer(address(0), account, amount);
897     }
898 
899     /**
900      * @dev Destroys `amount` tokens from `account`, reducing the
901      * total supply.
902      *
903      * Emits a {Transfer} event with `to` set to the zero address.
904      *
905      * Requirements:
906      *
907      * - `account` cannot be the zero address.
908      * - `account` must have at least `amount` tokens.
909      */
910     function _burn(address account, uint256 amount) internal virtual {
911         require(account != address(0), "ERC20: burn from the zero address");
912 
913         _beforeTokenTransfer(account, address(0), amount);
914 
915         uint256 accountBalance = _balances[account];
916         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
917         unchecked {
918             _balances[account] = accountBalance - amount;
919         }
920         _totalSupply -= amount;
921 
922         emit Transfer(account, address(0), amount);
923 
924         _afterTokenTransfer(account, address(0), amount);
925     }
926 
927     /**
928      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
929      *
930      * This internal function is equivalent to `approve`, and can be used to
931      * e.g. set automatic allowances for certain subsystems, etc.
932      *
933      * Emits an {Approval} event.
934      *
935      * Requirements:
936      *
937      * - `owner` cannot be the zero address.
938      * - `spender` cannot be the zero address.
939      */
940     function _approve(
941         address owner,
942         address spender,
943         uint256 amount
944     ) internal virtual {
945         require(owner != address(0), "ERC20: approve from the zero address");
946         require(spender != address(0), "ERC20: approve to the zero address");
947 
948         _allowances[owner][spender] = amount;
949         emit Approval(owner, spender, amount);
950     }
951 
952     /**
953      * @dev Hook that is called before any transfer of tokens. This includes
954      * minting and burning.
955      *
956      * Calling conditions:
957      *
958      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
959      * will be transferred to `to`.
960      * - when `from` is zero, `amount` tokens will be minted for `to`.
961      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
962      * - `from` and `to` are never both zero.
963      *
964      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
965      */
966     function _beforeTokenTransfer(
967         address from,
968         address to,
969         uint256 amount
970     ) internal virtual {}
971 
972     /**
973      * @dev Hook that is called after any transfer of tokens. This includes
974      * minting and burning.
975      *
976      * Calling conditions:
977      *
978      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
979      * has been transferred to `to`.
980      * - when `from` is zero, `amount` tokens have been minted for `to`.
981      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
982      * - `from` and `to` are never both zero.
983      *
984      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
985      */
986     function _afterTokenTransfer(
987         address from,
988         address to,
989         uint256 amount
990     ) internal virtual {}
991 }
992 
993 // File: contracts/oneWaySwap.sol
994 
995 
996 //pragma solidity ^0.8.9;
997 
998 
999 
1000 
1001 
1002 /** 
1003 @dev Performs a one-way 1:1 token swap
1004 1) code of the tokens is known, 
1005 2) both tokens have the same number of decimal places,
1006 3) both tokens revert on failure
1007 some effort was taken to create clear, self documenting, code.
1008  **/
1009 contract OneWaySwap is Ownable, Pausable{
1010 
1011     using SafeERC20 for ERC20;
1012 
1013 
1014     ERC20 oldToken;
1015     ERC20 newToken;
1016 
1017     address public burnAddress;
1018 
1019     event Burned(address who, uint256 amount, string why);
1020 
1021     constructor(ERC20 oldToken_, ERC20 newToken_, address burnAddress_)
1022     {
1023         require(address(oldToken_) != address(0) && address(newToken_) != address(0) && address(burnAddress_) != address(0), "Zero address not allowed");
1024         oldToken = oldToken_;
1025         newToken = newToken_;        
1026         burnAddress = burnAddress_;
1027         _pause();
1028     }
1029 
1030     function swap(uint256 amount) 
1031         external
1032         whenNotPaused
1033     {
1034         //oldToken.transferFrom(msg.sender, burnAddress, amount);
1035         oldToken.safeTransferFrom( msg.sender, burnAddress, amount);
1036         //newToken.transfer(msg.sender, amount);
1037         newToken.safeTransfer( msg.sender, amount);
1038     }
1039 
1040     function burn(uint256 amount, string memory why)
1041         external
1042         whenNotPaused
1043     {
1044         //oldToken.transferFrom(msg.sender, burnAddress, amount);
1045         oldToken.safeTransferFrom( msg.sender, burnAddress, amount);
1046         emit Burned(msg.sender, amount, why);
1047     }
1048     
1049     function pause() 
1050         external 
1051         onlyOwner
1052     {
1053         _pause();
1054     }
1055 
1056     function unPause() 
1057         external 
1058         onlyOwner
1059     {
1060         _unpause();
1061     }
1062 
1063     /**
1064     @dev at some point may wish to end the swap, and reallocate the newToken
1065     allows an `amount` of `token` to be withdrawn to `destination`
1066     **/
1067     function walletWithdraw(ERC20 token, uint256 amount, address destination)
1068         external
1069         onlyOwner
1070     {
1071         token.transfer(destination, amount);
1072     }
1073 
1074 }