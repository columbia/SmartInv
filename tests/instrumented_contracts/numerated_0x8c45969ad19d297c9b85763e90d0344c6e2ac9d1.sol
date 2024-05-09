1 // Sources flattened with hardhat v2.9.6 https://hardhat.org
2 
3 // File @openzeppelin/contracts/utils/Context.sol@v4.6.0
4 
5 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
6 
7 pragma solidity ^0.8.0;
8 
9 /**
10  * @dev Provides information about the current execution context, including the
11  * sender of the transaction and its data. While these are generally available
12  * via msg.sender and msg.data, they should not be accessed in such a direct
13  * manner, since when dealing with meta-transactions the account sending and
14  * paying for execution may not be the actual sender (as far as an application
15  * is concerned).
16  *
17  * This contract is only required for intermediate, library-like contracts.
18  */
19 abstract contract Context {
20     function _msgSender() internal view virtual returns (address) {
21         return msg.sender;
22     }
23 
24     function _msgData() internal view virtual returns (bytes calldata) {
25         return msg.data;
26     }
27 }
28 
29 
30 // File @openzeppelin/contracts/access/Ownable.sol@v4.6.0
31 
32 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
33 
34 pragma solidity ^0.8.0;
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
106 
107 // File @openzeppelin/contracts/token/ERC20/IERC20.sol@v4.6.0
108 
109 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
110 
111 pragma solidity ^0.8.0;
112 
113 /**
114  * @dev Interface of the ERC20 standard as defined in the EIP.
115  */
116 interface IERC20 {
117     /**
118      * @dev Emitted when `value` tokens are moved from one account (`from`) to
119      * another (`to`).
120      *
121      * Note that `value` may be zero.
122      */
123     event Transfer(address indexed from, address indexed to, uint256 value);
124 
125     /**
126      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
127      * a call to {approve}. `value` is the new allowance.
128      */
129     event Approval(address indexed owner, address indexed spender, uint256 value);
130 
131     /**
132      * @dev Returns the amount of tokens in existence.
133      */
134     function totalSupply() external view returns (uint256);
135 
136     /**
137      * @dev Returns the amount of tokens owned by `account`.
138      */
139     function balanceOf(address account) external view returns (uint256);
140 
141     /**
142      * @dev Moves `amount` tokens from the caller's account to `to`.
143      *
144      * Returns a boolean value indicating whether the operation succeeded.
145      *
146      * Emits a {Transfer} event.
147      */
148     function transfer(address to, uint256 amount) external returns (bool);
149 
150     /**
151      * @dev Returns the remaining number of tokens that `spender` will be
152      * allowed to spend on behalf of `owner` through {transferFrom}. This is
153      * zero by default.
154      *
155      * This value changes when {approve} or {transferFrom} are called.
156      */
157     function allowance(address owner, address spender) external view returns (uint256);
158 
159     /**
160      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
161      *
162      * Returns a boolean value indicating whether the operation succeeded.
163      *
164      * IMPORTANT: Beware that changing an allowance with this method brings the risk
165      * that someone may use both the old and the new allowance by unfortunate
166      * transaction ordering. One possible solution to mitigate this race
167      * condition is to first reduce the spender's allowance to 0 and set the
168      * desired value afterwards:
169      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
170      *
171      * Emits an {Approval} event.
172      */
173     function approve(address spender, uint256 amount) external returns (bool);
174 
175     /**
176      * @dev Moves `amount` tokens from `from` to `to` using the
177      * allowance mechanism. `amount` is then deducted from the caller's
178      * allowance.
179      *
180      * Returns a boolean value indicating whether the operation succeeded.
181      *
182      * Emits a {Transfer} event.
183      */
184     function transferFrom(
185         address from,
186         address to,
187         uint256 amount
188     ) external returns (bool);
189 }
190 
191 
192 // File @openzeppelin/contracts/utils/Address.sol@v4.6.0
193 
194 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
195 
196 pragma solidity ^0.8.1;
197 
198 /**
199  * @dev Collection of functions related to the address type
200  */
201 library Address {
202     /**
203      * @dev Returns true if `account` is a contract.
204      *
205      * [IMPORTANT]
206      * ====
207      * It is unsafe to assume that an address for which this function returns
208      * false is an externally-owned account (EOA) and not a contract.
209      *
210      * Among others, `isContract` will return false for the following
211      * types of addresses:
212      *
213      *  - an externally-owned account
214      *  - a contract in construction
215      *  - an address where a contract will be created
216      *  - an address where a contract lived, but was destroyed
217      * ====
218      *
219      * [IMPORTANT]
220      * ====
221      * You shouldn't rely on `isContract` to protect against flash loan attacks!
222      *
223      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
224      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
225      * constructor.
226      * ====
227      */
228     function isContract(address account) internal view returns (bool) {
229         // This method relies on extcodesize/address.code.length, which returns 0
230         // for contracts in construction, since the code is only stored at the end
231         // of the constructor execution.
232 
233         return account.code.length > 0;
234     }
235 
236     /**
237      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
238      * `recipient`, forwarding all available gas and reverting on errors.
239      *
240      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
241      * of certain opcodes, possibly making contracts go over the 2300 gas limit
242      * imposed by `transfer`, making them unable to receive funds via
243      * `transfer`. {sendValue} removes this limitation.
244      *
245      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
246      *
247      * IMPORTANT: because control is transferred to `recipient`, care must be
248      * taken to not create reentrancy vulnerabilities. Consider using
249      * {ReentrancyGuard} or the
250      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
251      */
252     function sendValue(address payable recipient, uint256 amount) internal {
253         require(address(this).balance >= amount, "Address: insufficient balance");
254 
255         (bool success, ) = recipient.call{value: amount}("");
256         require(success, "Address: unable to send value, recipient may have reverted");
257     }
258 
259     /**
260      * @dev Performs a Solidity function call using a low level `call`. A
261      * plain `call` is an unsafe replacement for a function call: use this
262      * function instead.
263      *
264      * If `target` reverts with a revert reason, it is bubbled up by this
265      * function (like regular Solidity function calls).
266      *
267      * Returns the raw returned data. To convert to the expected return value,
268      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
269      *
270      * Requirements:
271      *
272      * - `target` must be a contract.
273      * - calling `target` with `data` must not revert.
274      *
275      * _Available since v3.1._
276      */
277     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
278         return functionCall(target, data, "Address: low-level call failed");
279     }
280 
281     /**
282      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
283      * `errorMessage` as a fallback revert reason when `target` reverts.
284      *
285      * _Available since v3.1._
286      */
287     function functionCall(
288         address target,
289         bytes memory data,
290         string memory errorMessage
291     ) internal returns (bytes memory) {
292         return functionCallWithValue(target, data, 0, errorMessage);
293     }
294 
295     /**
296      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
297      * but also transferring `value` wei to `target`.
298      *
299      * Requirements:
300      *
301      * - the calling contract must have an ETH balance of at least `value`.
302      * - the called Solidity function must be `payable`.
303      *
304      * _Available since v3.1._
305      */
306     function functionCallWithValue(
307         address target,
308         bytes memory data,
309         uint256 value
310     ) internal returns (bytes memory) {
311         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
312     }
313 
314     /**
315      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
316      * with `errorMessage` as a fallback revert reason when `target` reverts.
317      *
318      * _Available since v3.1._
319      */
320     function functionCallWithValue(
321         address target,
322         bytes memory data,
323         uint256 value,
324         string memory errorMessage
325     ) internal returns (bytes memory) {
326         require(address(this).balance >= value, "Address: insufficient balance for call");
327         require(isContract(target), "Address: call to non-contract");
328 
329         (bool success, bytes memory returndata) = target.call{value: value}(data);
330         return verifyCallResult(success, returndata, errorMessage);
331     }
332 
333     /**
334      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
335      * but performing a static call.
336      *
337      * _Available since v3.3._
338      */
339     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
340         return functionStaticCall(target, data, "Address: low-level static call failed");
341     }
342 
343     /**
344      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
345      * but performing a static call.
346      *
347      * _Available since v3.3._
348      */
349     function functionStaticCall(
350         address target,
351         bytes memory data,
352         string memory errorMessage
353     ) internal view returns (bytes memory) {
354         require(isContract(target), "Address: static call to non-contract");
355 
356         (bool success, bytes memory returndata) = target.staticcall(data);
357         return verifyCallResult(success, returndata, errorMessage);
358     }
359 
360     /**
361      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
362      * but performing a delegate call.
363      *
364      * _Available since v3.4._
365      */
366     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
367         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
368     }
369 
370     /**
371      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
372      * but performing a delegate call.
373      *
374      * _Available since v3.4._
375      */
376     function functionDelegateCall(
377         address target,
378         bytes memory data,
379         string memory errorMessage
380     ) internal returns (bytes memory) {
381         require(isContract(target), "Address: delegate call to non-contract");
382 
383         (bool success, bytes memory returndata) = target.delegatecall(data);
384         return verifyCallResult(success, returndata, errorMessage);
385     }
386 
387     /**
388      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
389      * revert reason using the provided one.
390      *
391      * _Available since v4.3._
392      */
393     function verifyCallResult(
394         bool success,
395         bytes memory returndata,
396         string memory errorMessage
397     ) internal pure returns (bytes memory) {
398         if (success) {
399             return returndata;
400         } else {
401             // Look for revert reason and bubble it up if present
402             if (returndata.length > 0) {
403                 // The easiest way to bubble the revert reason is using memory via assembly
404 
405                 assembly {
406                     let returndata_size := mload(returndata)
407                     revert(add(32, returndata), returndata_size)
408                 }
409             } else {
410                 revert(errorMessage);
411             }
412         }
413     }
414 }
415 
416 
417 // File @openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol@v4.6.0
418 
419 // OpenZeppelin Contracts v4.4.1 (token/ERC20/utils/SafeERC20.sol)
420 
421 pragma solidity ^0.8.0;
422 
423 
424 /**
425  * @title SafeERC20
426  * @dev Wrappers around ERC20 operations that throw on failure (when the token
427  * contract returns false). Tokens that return no value (and instead revert or
428  * throw on failure) are also supported, non-reverting calls are assumed to be
429  * successful.
430  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
431  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
432  */
433 library SafeERC20 {
434     using Address for address;
435 
436     function safeTransfer(
437         IERC20 token,
438         address to,
439         uint256 value
440     ) internal {
441         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
442     }
443 
444     function safeTransferFrom(
445         IERC20 token,
446         address from,
447         address to,
448         uint256 value
449     ) internal {
450         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
451     }
452 
453     /**
454      * @dev Deprecated. This function has issues similar to the ones found in
455      * {IERC20-approve}, and its usage is discouraged.
456      *
457      * Whenever possible, use {safeIncreaseAllowance} and
458      * {safeDecreaseAllowance} instead.
459      */
460     function safeApprove(
461         IERC20 token,
462         address spender,
463         uint256 value
464     ) internal {
465         // safeApprove should only be called when setting an initial allowance,
466         // or when resetting it to zero. To increase and decrease it, use
467         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
468         require(
469             (value == 0) || (token.allowance(address(this), spender) == 0),
470             "SafeERC20: approve from non-zero to non-zero allowance"
471         );
472         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
473     }
474 
475     function safeIncreaseAllowance(
476         IERC20 token,
477         address spender,
478         uint256 value
479     ) internal {
480         uint256 newAllowance = token.allowance(address(this), spender) + value;
481         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
482     }
483 
484     function safeDecreaseAllowance(
485         IERC20 token,
486         address spender,
487         uint256 value
488     ) internal {
489         unchecked {
490             uint256 oldAllowance = token.allowance(address(this), spender);
491             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
492             uint256 newAllowance = oldAllowance - value;
493             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
494         }
495     }
496 
497     /**
498      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
499      * on the return value: the return value is optional (but if data is returned, it must not be false).
500      * @param token The token targeted by the call.
501      * @param data The call data (encoded using abi.encode or one of its variants).
502      */
503     function _callOptionalReturn(IERC20 token, bytes memory data) private {
504         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
505         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
506         // the target address contains contract code and also asserts for success in the low-level call.
507 
508         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
509         if (returndata.length > 0) {
510             // Return data is optional
511             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
512         }
513     }
514 }
515 
516 
517 // File @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol@v4.6.0
518 
519 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
520 
521 pragma solidity ^0.8.0;
522 
523 /**
524  * @dev Interface for the optional metadata functions from the ERC20 standard.
525  *
526  * _Available since v4.1._
527  */
528 interface IERC20Metadata is IERC20 {
529     /**
530      * @dev Returns the name of the token.
531      */
532     function name() external view returns (string memory);
533 
534     /**
535      * @dev Returns the symbol of the token.
536      */
537     function symbol() external view returns (string memory);
538 
539     /**
540      * @dev Returns the decimals places of the token.
541      */
542     function decimals() external view returns (uint8);
543 }
544 
545 
546 // File @openzeppelin/contracts/token/ERC20/ERC20.sol@v4.6.0
547 
548 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/ERC20.sol)
549 
550 pragma solidity ^0.8.0;
551 
552 
553 
554 /**
555  * @dev Implementation of the {IERC20} interface.
556  *
557  * This implementation is agnostic to the way tokens are created. This means
558  * that a supply mechanism has to be added in a derived contract using {_mint}.
559  * For a generic mechanism see {ERC20PresetMinterPauser}.
560  *
561  * TIP: For a detailed writeup see our guide
562  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
563  * to implement supply mechanisms].
564  *
565  * We have followed general OpenZeppelin Contracts guidelines: functions revert
566  * instead returning `false` on failure. This behavior is nonetheless
567  * conventional and does not conflict with the expectations of ERC20
568  * applications.
569  *
570  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
571  * This allows applications to reconstruct the allowance for all accounts just
572  * by listening to said events. Other implementations of the EIP may not emit
573  * these events, as it isn't required by the specification.
574  *
575  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
576  * functions have been added to mitigate the well-known issues around setting
577  * allowances. See {IERC20-approve}.
578  */
579 contract ERC20 is Context, IERC20, IERC20Metadata {
580     mapping(address => uint256) private _balances;
581 
582     mapping(address => mapping(address => uint256)) private _allowances;
583 
584     uint256 private _totalSupply;
585 
586     string private _name;
587     string private _symbol;
588 
589     /**
590      * @dev Sets the values for {name} and {symbol}.
591      *
592      * The default value of {decimals} is 18. To select a different value for
593      * {decimals} you should overload it.
594      *
595      * All two of these values are immutable: they can only be set once during
596      * construction.
597      */
598     constructor(string memory name_, string memory symbol_) {
599         _name = name_;
600         _symbol = symbol_;
601     }
602 
603     /**
604      * @dev Returns the name of the token.
605      */
606     function name() public view virtual override returns (string memory) {
607         return _name;
608     }
609 
610     /**
611      * @dev Returns the symbol of the token, usually a shorter version of the
612      * name.
613      */
614     function symbol() public view virtual override returns (string memory) {
615         return _symbol;
616     }
617 
618     /**
619      * @dev Returns the number of decimals used to get its user representation.
620      * For example, if `decimals` equals `2`, a balance of `505` tokens should
621      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
622      *
623      * Tokens usually opt for a value of 18, imitating the relationship between
624      * Ether and Wei. This is the value {ERC20} uses, unless this function is
625      * overridden;
626      *
627      * NOTE: This information is only used for _display_ purposes: it in
628      * no way affects any of the arithmetic of the contract, including
629      * {IERC20-balanceOf} and {IERC20-transfer}.
630      */
631     function decimals() public view virtual override returns (uint8) {
632         return 18;
633     }
634 
635     /**
636      * @dev See {IERC20-totalSupply}.
637      */
638     function totalSupply() public view virtual override returns (uint256) {
639         return _totalSupply;
640     }
641 
642     /**
643      * @dev See {IERC20-balanceOf}.
644      */
645     function balanceOf(address account) public view virtual override returns (uint256) {
646         return _balances[account];
647     }
648 
649     /**
650      * @dev See {IERC20-transfer}.
651      *
652      * Requirements:
653      *
654      * - `to` cannot be the zero address.
655      * - the caller must have a balance of at least `amount`.
656      */
657     function transfer(address to, uint256 amount) public virtual override returns (bool) {
658         address owner = _msgSender();
659         _transfer(owner, to, amount);
660         return true;
661     }
662 
663     /**
664      * @dev See {IERC20-allowance}.
665      */
666     function allowance(address owner, address spender) public view virtual override returns (uint256) {
667         return _allowances[owner][spender];
668     }
669 
670     /**
671      * @dev See {IERC20-approve}.
672      *
673      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
674      * `transferFrom`. This is semantically equivalent to an infinite approval.
675      *
676      * Requirements:
677      *
678      * - `spender` cannot be the zero address.
679      */
680     function approve(address spender, uint256 amount) public virtual override returns (bool) {
681         address owner = _msgSender();
682         _approve(owner, spender, amount);
683         return true;
684     }
685 
686     /**
687      * @dev See {IERC20-transferFrom}.
688      *
689      * Emits an {Approval} event indicating the updated allowance. This is not
690      * required by the EIP. See the note at the beginning of {ERC20}.
691      *
692      * NOTE: Does not update the allowance if the current allowance
693      * is the maximum `uint256`.
694      *
695      * Requirements:
696      *
697      * - `from` and `to` cannot be the zero address.
698      * - `from` must have a balance of at least `amount`.
699      * - the caller must have allowance for ``from``'s tokens of at least
700      * `amount`.
701      */
702     function transferFrom(
703         address from,
704         address to,
705         uint256 amount
706     ) public virtual override returns (bool) {
707         address spender = _msgSender();
708         _spendAllowance(from, spender, amount);
709         _transfer(from, to, amount);
710         return true;
711     }
712 
713     /**
714      * @dev Atomically increases the allowance granted to `spender` by the caller.
715      *
716      * This is an alternative to {approve} that can be used as a mitigation for
717      * problems described in {IERC20-approve}.
718      *
719      * Emits an {Approval} event indicating the updated allowance.
720      *
721      * Requirements:
722      *
723      * - `spender` cannot be the zero address.
724      */
725     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
726         address owner = _msgSender();
727         _approve(owner, spender, allowance(owner, spender) + addedValue);
728         return true;
729     }
730 
731     /**
732      * @dev Atomically decreases the allowance granted to `spender` by the caller.
733      *
734      * This is an alternative to {approve} that can be used as a mitigation for
735      * problems described in {IERC20-approve}.
736      *
737      * Emits an {Approval} event indicating the updated allowance.
738      *
739      * Requirements:
740      *
741      * - `spender` cannot be the zero address.
742      * - `spender` must have allowance for the caller of at least
743      * `subtractedValue`.
744      */
745     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
746         address owner = _msgSender();
747         uint256 currentAllowance = allowance(owner, spender);
748         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
749         unchecked {
750             _approve(owner, spender, currentAllowance - subtractedValue);
751         }
752 
753         return true;
754     }
755 
756     /**
757      * @dev Moves `amount` of tokens from `sender` to `recipient`.
758      *
759      * This internal function is equivalent to {transfer}, and can be used to
760      * e.g. implement automatic token fees, slashing mechanisms, etc.
761      *
762      * Emits a {Transfer} event.
763      *
764      * Requirements:
765      *
766      * - `from` cannot be the zero address.
767      * - `to` cannot be the zero address.
768      * - `from` must have a balance of at least `amount`.
769      */
770     function _transfer(
771         address from,
772         address to,
773         uint256 amount
774     ) internal virtual {
775         require(from != address(0), "ERC20: transfer from the zero address");
776         require(to != address(0), "ERC20: transfer to the zero address");
777 
778         _beforeTokenTransfer(from, to, amount);
779 
780         uint256 fromBalance = _balances[from];
781         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
782         unchecked {
783             _balances[from] = fromBalance - amount;
784         }
785         _balances[to] += amount;
786 
787         emit Transfer(from, to, amount);
788 
789         _afterTokenTransfer(from, to, amount);
790     }
791 
792     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
793      * the total supply.
794      *
795      * Emits a {Transfer} event with `from` set to the zero address.
796      *
797      * Requirements:
798      *
799      * - `account` cannot be the zero address.
800      */
801     function _mint(address account, uint256 amount) internal virtual {
802         require(account != address(0), "ERC20: mint to the zero address");
803 
804         _beforeTokenTransfer(address(0), account, amount);
805 
806         _totalSupply += amount;
807         _balances[account] += amount;
808         emit Transfer(address(0), account, amount);
809 
810         _afterTokenTransfer(address(0), account, amount);
811     }
812 
813     /**
814      * @dev Destroys `amount` tokens from `account`, reducing the
815      * total supply.
816      *
817      * Emits a {Transfer} event with `to` set to the zero address.
818      *
819      * Requirements:
820      *
821      * - `account` cannot be the zero address.
822      * - `account` must have at least `amount` tokens.
823      */
824     function _burn(address account, uint256 amount) internal virtual {
825         require(account != address(0), "ERC20: burn from the zero address");
826 
827         _beforeTokenTransfer(account, address(0), amount);
828 
829         uint256 accountBalance = _balances[account];
830         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
831         unchecked {
832             _balances[account] = accountBalance - amount;
833         }
834         _totalSupply -= amount;
835 
836         emit Transfer(account, address(0), amount);
837 
838         _afterTokenTransfer(account, address(0), amount);
839     }
840 
841     /**
842      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
843      *
844      * This internal function is equivalent to `approve`, and can be used to
845      * e.g. set automatic allowances for certain subsystems, etc.
846      *
847      * Emits an {Approval} event.
848      *
849      * Requirements:
850      *
851      * - `owner` cannot be the zero address.
852      * - `spender` cannot be the zero address.
853      */
854     function _approve(
855         address owner,
856         address spender,
857         uint256 amount
858     ) internal virtual {
859         require(owner != address(0), "ERC20: approve from the zero address");
860         require(spender != address(0), "ERC20: approve to the zero address");
861 
862         _allowances[owner][spender] = amount;
863         emit Approval(owner, spender, amount);
864     }
865 
866     /**
867      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
868      *
869      * Does not update the allowance amount in case of infinite allowance.
870      * Revert if not enough allowance is available.
871      *
872      * Might emit an {Approval} event.
873      */
874     function _spendAllowance(
875         address owner,
876         address spender,
877         uint256 amount
878     ) internal virtual {
879         uint256 currentAllowance = allowance(owner, spender);
880         if (currentAllowance != type(uint256).max) {
881             require(currentAllowance >= amount, "ERC20: insufficient allowance");
882             unchecked {
883                 _approve(owner, spender, currentAllowance - amount);
884             }
885         }
886     }
887 
888     /**
889      * @dev Hook that is called before any transfer of tokens. This includes
890      * minting and burning.
891      *
892      * Calling conditions:
893      *
894      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
895      * will be transferred to `to`.
896      * - when `from` is zero, `amount` tokens will be minted for `to`.
897      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
898      * - `from` and `to` are never both zero.
899      *
900      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
901      */
902     function _beforeTokenTransfer(
903         address from,
904         address to,
905         uint256 amount
906     ) internal virtual {}
907 
908     /**
909      * @dev Hook that is called after any transfer of tokens. This includes
910      * minting and burning.
911      *
912      * Calling conditions:
913      *
914      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
915      * has been transferred to `to`.
916      * - when `from` is zero, `amount` tokens have been minted for `to`.
917      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
918      * - `from` and `to` are never both zero.
919      *
920      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
921      */
922     function _afterTokenTransfer(
923         address from,
924         address to,
925         uint256 amount
926     ) internal virtual {}
927 }
928 
929 
930 // File @openzeppelin/contracts/security/ReentrancyGuard.sol@v4.6.0
931 
932 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
933 
934 pragma solidity ^0.8.0;
935 
936 /**
937  * @dev Contract module that helps prevent reentrant calls to a function.
938  *
939  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
940  * available, which can be applied to functions to make sure there are no nested
941  * (reentrant) calls to them.
942  *
943  * Note that because there is a single `nonReentrant` guard, functions marked as
944  * `nonReentrant` may not call one another. This can be worked around by making
945  * those functions `private`, and then adding `external` `nonReentrant` entry
946  * points to them.
947  *
948  * TIP: If you would like to learn more about reentrancy and alternative ways
949  * to protect against it, check out our blog post
950  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
951  */
952 abstract contract ReentrancyGuard {
953     // Booleans are more expensive than uint256 or any type that takes up a full
954     // word because each write operation emits an extra SLOAD to first read the
955     // slot's contents, replace the bits taken up by the boolean, and then write
956     // back. This is the compiler's defense against contract upgrades and
957     // pointer aliasing, and it cannot be disabled.
958 
959     // The values being non-zero value makes deployment a bit more expensive,
960     // but in exchange the refund on every call to nonReentrant will be lower in
961     // amount. Since refunds are capped to a percentage of the total
962     // transaction's gas, it is best to keep them low in cases like this one, to
963     // increase the likelihood of the full refund coming into effect.
964     uint256 private constant _NOT_ENTERED = 1;
965     uint256 private constant _ENTERED = 2;
966 
967     uint256 private _status;
968 
969     constructor() {
970         _status = _NOT_ENTERED;
971     }
972 
973     /**
974      * @dev Prevents a contract from calling itself, directly or indirectly.
975      * Calling a `nonReentrant` function from another `nonReentrant`
976      * function is not supported. It is possible to prevent this from happening
977      * by making the `nonReentrant` function external, and making it call a
978      * `private` function that does the actual work.
979      */
980     modifier nonReentrant() {
981         // On the first call to nonReentrant, _notEntered will be true
982         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
983 
984         // Any calls to nonReentrant after this point will fail
985         _status = _ENTERED;
986 
987         _;
988 
989         // By storing the original value once again, a refund is triggered (see
990         // https://eips.ethereum.org/EIPS/eip-2200)
991         _status = _NOT_ENTERED;
992     }
993 }
994 
995 
996 // File contracts/interfaces/IPriceSourceAll.sol
997 
998 pragma solidity 0.8.11;
999 interface IPriceSource {
1000     function latestRoundData() external view returns (uint256);
1001     function latestAnswer() external view returns (uint256);
1002     function decimals() external view returns (uint8);
1003 }
1004 
1005 
1006 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.6.0
1007 
1008 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
1009 
1010 pragma solidity ^0.8.0;
1011 
1012 /**
1013  * @dev Interface of the ERC165 standard, as defined in the
1014  * https://eips.ethereum.org/EIPS/eip-165[EIP].
1015  *
1016  * Implementers can declare support of contract interfaces, which can then be
1017  * queried by others ({ERC165Checker}).
1018  *
1019  * For an implementation, see {ERC165}.
1020  */
1021 interface IERC165 {
1022     /**
1023      * @dev Returns true if this contract implements the interface defined by
1024      * `interfaceId`. See the corresponding
1025      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
1026      * to learn more about how these ids are created.
1027      *
1028      * This function call must use less than 30 000 gas.
1029      */
1030     function supportsInterface(bytes4 interfaceId) external view returns (bool);
1031 }
1032 
1033 
1034 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.6.0
1035 
1036 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
1037 
1038 pragma solidity ^0.8.0;
1039 
1040 /**
1041  * @dev Required interface of an ERC721 compliant contract.
1042  */
1043 interface IERC721 is IERC165 {
1044     /**
1045      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
1046      */
1047     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1048 
1049     /**
1050      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1051      */
1052     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1053 
1054     /**
1055      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
1056      */
1057     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1058 
1059     /**
1060      * @dev Returns the number of tokens in ``owner``'s account.
1061      */
1062     function balanceOf(address owner) external view returns (uint256 balance);
1063 
1064     /**
1065      * @dev Returns the owner of the `tokenId` token.
1066      *
1067      * Requirements:
1068      *
1069      * - `tokenId` must exist.
1070      */
1071     function ownerOf(uint256 tokenId) external view returns (address owner);
1072 
1073     /**
1074      * @dev Safely transfers `tokenId` token from `from` to `to`.
1075      *
1076      * Requirements:
1077      *
1078      * - `from` cannot be the zero address.
1079      * - `to` cannot be the zero address.
1080      * - `tokenId` token must exist and be owned by `from`.
1081      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1082      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1083      *
1084      * Emits a {Transfer} event.
1085      */
1086     function safeTransferFrom(
1087         address from,
1088         address to,
1089         uint256 tokenId,
1090         bytes calldata data
1091     ) external;
1092 
1093     /**
1094      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1095      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1096      *
1097      * Requirements:
1098      *
1099      * - `from` cannot be the zero address.
1100      * - `to` cannot be the zero address.
1101      * - `tokenId` token must exist and be owned by `from`.
1102      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
1103      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1104      *
1105      * Emits a {Transfer} event.
1106      */
1107     function safeTransferFrom(
1108         address from,
1109         address to,
1110         uint256 tokenId
1111     ) external;
1112 
1113     /**
1114      * @dev Transfers `tokenId` token from `from` to `to`.
1115      *
1116      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
1117      *
1118      * Requirements:
1119      *
1120      * - `from` cannot be the zero address.
1121      * - `to` cannot be the zero address.
1122      * - `tokenId` token must be owned by `from`.
1123      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1124      *
1125      * Emits a {Transfer} event.
1126      */
1127     function transferFrom(
1128         address from,
1129         address to,
1130         uint256 tokenId
1131     ) external;
1132 
1133     /**
1134      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1135      * The approval is cleared when the token is transferred.
1136      *
1137      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1138      *
1139      * Requirements:
1140      *
1141      * - The caller must own the token or be an approved operator.
1142      * - `tokenId` must exist.
1143      *
1144      * Emits an {Approval} event.
1145      */
1146     function approve(address to, uint256 tokenId) external;
1147 
1148     /**
1149      * @dev Approve or remove `operator` as an operator for the caller.
1150      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1151      *
1152      * Requirements:
1153      *
1154      * - The `operator` cannot be the caller.
1155      *
1156      * Emits an {ApprovalForAll} event.
1157      */
1158     function setApprovalForAll(address operator, bool _approved) external;
1159 
1160     /**
1161      * @dev Returns the account approved for `tokenId` token.
1162      *
1163      * Requirements:
1164      *
1165      * - `tokenId` must exist.
1166      */
1167     function getApproved(uint256 tokenId) external view returns (address operator);
1168 
1169     /**
1170      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1171      *
1172      * See {setApprovalForAll}
1173      */
1174     function isApprovedForAll(address owner, address operator) external view returns (bool);
1175 }
1176 
1177 
1178 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v4.6.0
1179 
1180 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
1181 
1182 pragma solidity ^0.8.0;
1183 
1184 /**
1185  * @title ERC721 token receiver interface
1186  * @dev Interface for any contract that wants to support safeTransfers
1187  * from ERC721 asset contracts.
1188  */
1189 interface IERC721Receiver {
1190     /**
1191      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
1192      * by `operator` from `from`, this function is called.
1193      *
1194      * It must return its Solidity selector to confirm the token transfer.
1195      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
1196      *
1197      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
1198      */
1199     function onERC721Received(
1200         address operator,
1201         address from,
1202         uint256 tokenId,
1203         bytes calldata data
1204     ) external returns (bytes4);
1205 }
1206 
1207 
1208 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol@v4.6.0
1209 
1210 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
1211 
1212 pragma solidity ^0.8.0;
1213 
1214 /**
1215  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1216  * @dev See https://eips.ethereum.org/EIPS/eip-721
1217  */
1218 interface IERC721Metadata is IERC721 {
1219     /**
1220      * @dev Returns the token collection name.
1221      */
1222     function name() external view returns (string memory);
1223 
1224     /**
1225      * @dev Returns the token collection symbol.
1226      */
1227     function symbol() external view returns (string memory);
1228 
1229     /**
1230      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1231      */
1232     function tokenURI(uint256 tokenId) external view returns (string memory);
1233 }
1234 
1235 
1236 // File @openzeppelin/contracts/utils/Strings.sol@v4.6.0
1237 
1238 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
1239 
1240 pragma solidity ^0.8.0;
1241 
1242 /**
1243  * @dev String operations.
1244  */
1245 library Strings {
1246     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
1247 
1248     /**
1249      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1250      */
1251     function toString(uint256 value) internal pure returns (string memory) {
1252         // Inspired by OraclizeAPI's implementation - MIT licence
1253         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1254 
1255         if (value == 0) {
1256             return "0";
1257         }
1258         uint256 temp = value;
1259         uint256 digits;
1260         while (temp != 0) {
1261             digits++;
1262             temp /= 10;
1263         }
1264         bytes memory buffer = new bytes(digits);
1265         while (value != 0) {
1266             digits -= 1;
1267             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
1268             value /= 10;
1269         }
1270         return string(buffer);
1271     }
1272 
1273     /**
1274      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
1275      */
1276     function toHexString(uint256 value) internal pure returns (string memory) {
1277         if (value == 0) {
1278             return "0x00";
1279         }
1280         uint256 temp = value;
1281         uint256 length = 0;
1282         while (temp != 0) {
1283             length++;
1284             temp >>= 8;
1285         }
1286         return toHexString(value, length);
1287     }
1288 
1289     /**
1290      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
1291      */
1292     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
1293         bytes memory buffer = new bytes(2 * length + 2);
1294         buffer[0] = "0";
1295         buffer[1] = "x";
1296         for (uint256 i = 2 * length + 1; i > 1; --i) {
1297             buffer[i] = _HEX_SYMBOLS[value & 0xf];
1298             value >>= 4;
1299         }
1300         require(value == 0, "Strings: hex length insufficient");
1301         return string(buffer);
1302     }
1303 }
1304 
1305 
1306 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.6.0
1307 
1308 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
1309 
1310 pragma solidity ^0.8.0;
1311 
1312 /**
1313  * @dev Implementation of the {IERC165} interface.
1314  *
1315  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
1316  * for the additional interface id that will be supported. For example:
1317  *
1318  * ```solidity
1319  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1320  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
1321  * }
1322  * ```
1323  *
1324  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
1325  */
1326 abstract contract ERC165 is IERC165 {
1327     /**
1328      * @dev See {IERC165-supportsInterface}.
1329      */
1330     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1331         return interfaceId == type(IERC165).interfaceId;
1332     }
1333 }
1334 
1335 
1336 // File @openzeppelin/contracts/token/ERC721/ERC721.sol@v4.6.0
1337 
1338 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/ERC721.sol)
1339 
1340 pragma solidity ^0.8.0;
1341 
1342 
1343 
1344 
1345 
1346 
1347 
1348 /**
1349  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1350  * the Metadata extension, but not including the Enumerable extension, which is available separately as
1351  * {ERC721Enumerable}.
1352  */
1353 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
1354     using Address for address;
1355     using Strings for uint256;
1356 
1357     // Token name
1358     string private _name;
1359 
1360     // Token symbol
1361     string private _symbol;
1362 
1363     // Mapping from token ID to owner address
1364     mapping(uint256 => address) private _owners;
1365 
1366     // Mapping owner address to token count
1367     mapping(address => uint256) private _balances;
1368 
1369     // Mapping from token ID to approved address
1370     mapping(uint256 => address) private _tokenApprovals;
1371 
1372     // Mapping from owner to operator approvals
1373     mapping(address => mapping(address => bool)) private _operatorApprovals;
1374 
1375     /**
1376      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1377      */
1378     constructor(string memory name_, string memory symbol_) {
1379         _name = name_;
1380         _symbol = symbol_;
1381     }
1382 
1383     /**
1384      * @dev See {IERC165-supportsInterface}.
1385      */
1386     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1387         return
1388             interfaceId == type(IERC721).interfaceId ||
1389             interfaceId == type(IERC721Metadata).interfaceId ||
1390             super.supportsInterface(interfaceId);
1391     }
1392 
1393     /**
1394      * @dev See {IERC721-balanceOf}.
1395      */
1396     function balanceOf(address owner) public view virtual override returns (uint256) {
1397         require(owner != address(0), "ERC721: balance query for the zero address");
1398         return _balances[owner];
1399     }
1400 
1401     /**
1402      * @dev See {IERC721-ownerOf}.
1403      */
1404     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1405         address owner = _owners[tokenId];
1406         require(owner != address(0), "ERC721: owner query for nonexistent token");
1407         return owner;
1408     }
1409 
1410     /**
1411      * @dev See {IERC721Metadata-name}.
1412      */
1413     function name() public view virtual override returns (string memory) {
1414         return _name;
1415     }
1416 
1417     /**
1418      * @dev See {IERC721Metadata-symbol}.
1419      */
1420     function symbol() public view virtual override returns (string memory) {
1421         return _symbol;
1422     }
1423 
1424     /**
1425      * @dev See {IERC721Metadata-tokenURI}.
1426      */
1427     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1428         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1429 
1430         string memory baseURI = _baseURI();
1431         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1432     }
1433 
1434     /**
1435      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1436      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1437      * by default, can be overridden in child contracts.
1438      */
1439     function _baseURI() internal view virtual returns (string memory) {
1440         return "";
1441     }
1442 
1443     /**
1444      * @dev See {IERC721-approve}.
1445      */
1446     function approve(address to, uint256 tokenId) public virtual override {
1447         address owner = ERC721.ownerOf(tokenId);
1448         require(to != owner, "ERC721: approval to current owner");
1449 
1450         require(
1451             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1452             "ERC721: approve caller is not owner nor approved for all"
1453         );
1454 
1455         _approve(to, tokenId);
1456     }
1457 
1458     /**
1459      * @dev See {IERC721-getApproved}.
1460      */
1461     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1462         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1463 
1464         return _tokenApprovals[tokenId];
1465     }
1466 
1467     /**
1468      * @dev See {IERC721-setApprovalForAll}.
1469      */
1470     function setApprovalForAll(address operator, bool approved) public virtual override {
1471         _setApprovalForAll(_msgSender(), operator, approved);
1472     }
1473 
1474     /**
1475      * @dev See {IERC721-isApprovedForAll}.
1476      */
1477     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1478         return _operatorApprovals[owner][operator];
1479     }
1480 
1481     /**
1482      * @dev See {IERC721-transferFrom}.
1483      */
1484     function transferFrom(
1485         address from,
1486         address to,
1487         uint256 tokenId
1488     ) public virtual override {
1489         //solhint-disable-next-line max-line-length
1490         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1491 
1492         _transfer(from, to, tokenId);
1493     }
1494 
1495     /**
1496      * @dev See {IERC721-safeTransferFrom}.
1497      */
1498     function safeTransferFrom(
1499         address from,
1500         address to,
1501         uint256 tokenId
1502     ) public virtual override {
1503         safeTransferFrom(from, to, tokenId, "");
1504     }
1505 
1506     /**
1507      * @dev See {IERC721-safeTransferFrom}.
1508      */
1509     function safeTransferFrom(
1510         address from,
1511         address to,
1512         uint256 tokenId,
1513         bytes memory _data
1514     ) public virtual override {
1515         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1516         _safeTransfer(from, to, tokenId, _data);
1517     }
1518 
1519     /**
1520      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1521      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1522      *
1523      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1524      *
1525      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1526      * implement alternative mechanisms to perform token transfer, such as signature-based.
1527      *
1528      * Requirements:
1529      *
1530      * - `from` cannot be the zero address.
1531      * - `to` cannot be the zero address.
1532      * - `tokenId` token must exist and be owned by `from`.
1533      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1534      *
1535      * Emits a {Transfer} event.
1536      */
1537     function _safeTransfer(
1538         address from,
1539         address to,
1540         uint256 tokenId,
1541         bytes memory _data
1542     ) internal virtual {
1543         _transfer(from, to, tokenId);
1544         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1545     }
1546 
1547     /**
1548      * @dev Returns whether `tokenId` exists.
1549      *
1550      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1551      *
1552      * Tokens start existing when they are minted (`_mint`),
1553      * and stop existing when they are burned (`_burn`).
1554      */
1555     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1556         return _owners[tokenId] != address(0);
1557     }
1558 
1559     /**
1560      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1561      *
1562      * Requirements:
1563      *
1564      * - `tokenId` must exist.
1565      */
1566     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1567         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1568         address owner = ERC721.ownerOf(tokenId);
1569         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
1570     }
1571 
1572     /**
1573      * @dev Safely mints `tokenId` and transfers it to `to`.
1574      *
1575      * Requirements:
1576      *
1577      * - `tokenId` must not exist.
1578      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1579      *
1580      * Emits a {Transfer} event.
1581      */
1582     function _safeMint(address to, uint256 tokenId) internal virtual {
1583         _safeMint(to, tokenId, "");
1584     }
1585 
1586     /**
1587      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1588      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1589      */
1590     function _safeMint(
1591         address to,
1592         uint256 tokenId,
1593         bytes memory _data
1594     ) internal virtual {
1595         _mint(to, tokenId);
1596         require(
1597             _checkOnERC721Received(address(0), to, tokenId, _data),
1598             "ERC721: transfer to non ERC721Receiver implementer"
1599         );
1600     }
1601 
1602     /**
1603      * @dev Mints `tokenId` and transfers it to `to`.
1604      *
1605      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1606      *
1607      * Requirements:
1608      *
1609      * - `tokenId` must not exist.
1610      * - `to` cannot be the zero address.
1611      *
1612      * Emits a {Transfer} event.
1613      */
1614     function _mint(address to, uint256 tokenId) internal virtual {
1615         require(to != address(0), "ERC721: mint to the zero address");
1616         require(!_exists(tokenId), "ERC721: token already minted");
1617 
1618         _beforeTokenTransfer(address(0), to, tokenId);
1619 
1620         _balances[to] += 1;
1621         _owners[tokenId] = to;
1622 
1623         emit Transfer(address(0), to, tokenId);
1624 
1625         _afterTokenTransfer(address(0), to, tokenId);
1626     }
1627 
1628     /**
1629      * @dev Destroys `tokenId`.
1630      * The approval is cleared when the token is burned.
1631      *
1632      * Requirements:
1633      *
1634      * - `tokenId` must exist.
1635      *
1636      * Emits a {Transfer} event.
1637      */
1638     function _burn(uint256 tokenId) internal virtual {
1639         address owner = ERC721.ownerOf(tokenId);
1640 
1641         _beforeTokenTransfer(owner, address(0), tokenId);
1642 
1643         // Clear approvals
1644         _approve(address(0), tokenId);
1645 
1646         _balances[owner] -= 1;
1647         delete _owners[tokenId];
1648 
1649         emit Transfer(owner, address(0), tokenId);
1650 
1651         _afterTokenTransfer(owner, address(0), tokenId);
1652     }
1653 
1654     /**
1655      * @dev Transfers `tokenId` from `from` to `to`.
1656      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1657      *
1658      * Requirements:
1659      *
1660      * - `to` cannot be the zero address.
1661      * - `tokenId` token must be owned by `from`.
1662      *
1663      * Emits a {Transfer} event.
1664      */
1665     function _transfer(
1666         address from,
1667         address to,
1668         uint256 tokenId
1669     ) internal virtual {
1670         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1671         require(to != address(0), "ERC721: transfer to the zero address");
1672 
1673         _beforeTokenTransfer(from, to, tokenId);
1674 
1675         // Clear approvals from the previous owner
1676         _approve(address(0), tokenId);
1677 
1678         _balances[from] -= 1;
1679         _balances[to] += 1;
1680         _owners[tokenId] = to;
1681 
1682         emit Transfer(from, to, tokenId);
1683 
1684         _afterTokenTransfer(from, to, tokenId);
1685     }
1686 
1687     /**
1688      * @dev Approve `to` to operate on `tokenId`
1689      *
1690      * Emits a {Approval} event.
1691      */
1692     function _approve(address to, uint256 tokenId) internal virtual {
1693         _tokenApprovals[tokenId] = to;
1694         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1695     }
1696 
1697     /**
1698      * @dev Approve `operator` to operate on all of `owner` tokens
1699      *
1700      * Emits a {ApprovalForAll} event.
1701      */
1702     function _setApprovalForAll(
1703         address owner,
1704         address operator,
1705         bool approved
1706     ) internal virtual {
1707         require(owner != operator, "ERC721: approve to caller");
1708         _operatorApprovals[owner][operator] = approved;
1709         emit ApprovalForAll(owner, operator, approved);
1710     }
1711 
1712     /**
1713      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1714      * The call is not executed if the target address is not a contract.
1715      *
1716      * @param from address representing the previous owner of the given token ID
1717      * @param to target address that will receive the tokens
1718      * @param tokenId uint256 ID of the token to be transferred
1719      * @param _data bytes optional data to send along with the call
1720      * @return bool whether the call correctly returned the expected magic value
1721      */
1722     function _checkOnERC721Received(
1723         address from,
1724         address to,
1725         uint256 tokenId,
1726         bytes memory _data
1727     ) private returns (bool) {
1728         if (to.isContract()) {
1729             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1730                 return retval == IERC721Receiver.onERC721Received.selector;
1731             } catch (bytes memory reason) {
1732                 if (reason.length == 0) {
1733                     revert("ERC721: transfer to non ERC721Receiver implementer");
1734                 } else {
1735                     assembly {
1736                         revert(add(32, reason), mload(reason))
1737                     }
1738                 }
1739             }
1740         } else {
1741             return true;
1742         }
1743     }
1744 
1745     /**
1746      * @dev Hook that is called before any token transfer. This includes minting
1747      * and burning.
1748      *
1749      * Calling conditions:
1750      *
1751      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1752      * transferred to `to`.
1753      * - When `from` is zero, `tokenId` will be minted for `to`.
1754      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1755      * - `from` and `to` are never both zero.
1756      *
1757      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1758      */
1759     function _beforeTokenTransfer(
1760         address from,
1761         address to,
1762         uint256 tokenId
1763     ) internal virtual {}
1764 
1765     /**
1766      * @dev Hook that is called after any transfer of tokens. This includes
1767      * minting and burning.
1768      *
1769      * Calling conditions:
1770      *
1771      * - when `from` and `to` are both non-zero.
1772      * - `from` and `to` are never both zero.
1773      *
1774      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1775      */
1776     function _afterTokenTransfer(
1777         address from,
1778         address to,
1779         uint256 tokenId
1780     ) internal virtual {}
1781 }
1782 
1783 
1784 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol@v4.6.0
1785 
1786 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
1787 
1788 pragma solidity ^0.8.0;
1789 
1790 /**
1791  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1792  * @dev See https://eips.ethereum.org/EIPS/eip-721
1793  */
1794 interface IERC721Enumerable is IERC721 {
1795     /**
1796      * @dev Returns the total amount of tokens stored by the contract.
1797      */
1798     function totalSupply() external view returns (uint256);
1799 
1800     /**
1801      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1802      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1803      */
1804     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
1805 
1806     /**
1807      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1808      * Use along with {totalSupply} to enumerate all tokens.
1809      */
1810     function tokenByIndex(uint256 index) external view returns (uint256);
1811 }
1812 
1813 
1814 // File @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol@v4.6.0
1815 
1816 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/ERC721Enumerable.sol)
1817 
1818 pragma solidity ^0.8.0;
1819 
1820 
1821 /**
1822  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1823  * enumerability of all the token ids in the contract as well as all token ids owned by each
1824  * account.
1825  */
1826 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1827     // Mapping from owner to list of owned token IDs
1828     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1829 
1830     // Mapping from token ID to index of the owner tokens list
1831     mapping(uint256 => uint256) private _ownedTokensIndex;
1832 
1833     // Array with all token ids, used for enumeration
1834     uint256[] private _allTokens;
1835 
1836     // Mapping from token id to position in the allTokens array
1837     mapping(uint256 => uint256) private _allTokensIndex;
1838 
1839     /**
1840      * @dev See {IERC165-supportsInterface}.
1841      */
1842     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1843         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1844     }
1845 
1846     /**
1847      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1848      */
1849     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1850         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1851         return _ownedTokens[owner][index];
1852     }
1853 
1854     /**
1855      * @dev See {IERC721Enumerable-totalSupply}.
1856      */
1857     function totalSupply() public view virtual override returns (uint256) {
1858         return _allTokens.length;
1859     }
1860 
1861     /**
1862      * @dev See {IERC721Enumerable-tokenByIndex}.
1863      */
1864     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1865         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1866         return _allTokens[index];
1867     }
1868 
1869     /**
1870      * @dev Hook that is called before any token transfer. This includes minting
1871      * and burning.
1872      *
1873      * Calling conditions:
1874      *
1875      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1876      * transferred to `to`.
1877      * - When `from` is zero, `tokenId` will be minted for `to`.
1878      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1879      * - `from` cannot be the zero address.
1880      * - `to` cannot be the zero address.
1881      *
1882      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1883      */
1884     function _beforeTokenTransfer(
1885         address from,
1886         address to,
1887         uint256 tokenId
1888     ) internal virtual override {
1889         super._beforeTokenTransfer(from, to, tokenId);
1890 
1891         if (from == address(0)) {
1892             _addTokenToAllTokensEnumeration(tokenId);
1893         } else if (from != to) {
1894             _removeTokenFromOwnerEnumeration(from, tokenId);
1895         }
1896         if (to == address(0)) {
1897             _removeTokenFromAllTokensEnumeration(tokenId);
1898         } else if (to != from) {
1899             _addTokenToOwnerEnumeration(to, tokenId);
1900         }
1901     }
1902 
1903     /**
1904      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1905      * @param to address representing the new owner of the given token ID
1906      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1907      */
1908     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1909         uint256 length = ERC721.balanceOf(to);
1910         _ownedTokens[to][length] = tokenId;
1911         _ownedTokensIndex[tokenId] = length;
1912     }
1913 
1914     /**
1915      * @dev Private function to add a token to this extension's token tracking data structures.
1916      * @param tokenId uint256 ID of the token to be added to the tokens list
1917      */
1918     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1919         _allTokensIndex[tokenId] = _allTokens.length;
1920         _allTokens.push(tokenId);
1921     }
1922 
1923     /**
1924      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1925      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1926      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1927      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1928      * @param from address representing the previous owner of the given token ID
1929      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1930      */
1931     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1932         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1933         // then delete the last slot (swap and pop).
1934 
1935         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1936         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1937 
1938         // When the token to delete is the last token, the swap operation is unnecessary
1939         if (tokenIndex != lastTokenIndex) {
1940             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1941 
1942             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1943             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1944         }
1945 
1946         // This also deletes the contents at the last position of the array
1947         delete _ownedTokensIndex[tokenId];
1948         delete _ownedTokens[from][lastTokenIndex];
1949     }
1950 
1951     /**
1952      * @dev Private function to remove a token from this extension's token tracking data structures.
1953      * This has O(1) time complexity, but alters the order of the _allTokens array.
1954      * @param tokenId uint256 ID of the token to be removed from the tokens list
1955      */
1956     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1957         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1958         // then delete the last slot (swap and pop).
1959 
1960         uint256 lastTokenIndex = _allTokens.length - 1;
1961         uint256 tokenIndex = _allTokensIndex[tokenId];
1962 
1963         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1964         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1965         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1966         uint256 lastTokenId = _allTokens[lastTokenIndex];
1967 
1968         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1969         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1970 
1971         // This also deletes the contents at the last position of the array
1972         delete _allTokensIndex[tokenId];
1973         _allTokens.pop();
1974     }
1975 }
1976 
1977 
1978 // File contracts/token/MyVaultV4.sol
1979 
1980 // contracts/MyVaultNFT.sol
1981 pragma solidity 0.8.11;
1982 
1983 
1984 contract VaultNFTv4 is ERC721, ERC721Enumerable {
1985 
1986     string public uri;
1987 
1988     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal override(ERC721, ERC721Enumerable) {
1989         super._beforeTokenTransfer(from, to, tokenId);
1990     }
1991 
1992     function supportsInterface(bytes4 interfaceId) public view override(ERC721, ERC721Enumerable) returns (bool) {
1993         return super.supportsInterface(interfaceId);
1994     }
1995 
1996     constructor(string memory name, string memory symbol, string memory _uri)
1997         ERC721(name, symbol)
1998     {
1999         uri = _uri;
2000     }
2001 
2002     function tokenURI(uint256 tokenId) public override view returns (string memory) {
2003         require(_exists(tokenId));
2004 
2005         return uri;
2006     }
2007 }
2008 
2009 
2010 // File contracts/fixedInterestVaults/fixedVault.sol
2011 
2012 pragma solidity 0.8.11;
2013 
2014 
2015 
2016 
2017 contract fixedVault is ReentrancyGuard, VaultNFTv4 {
2018     using SafeERC20 for ERC20;
2019 
2020     /// @dev Constants used across the contract.
2021     uint256 constant TEN_THOUSAND = 10000;
2022     uint256 constant ONE_YEAR = 31556952;
2023     uint256 constant THOUSAND = 1000;
2024 
2025     IPriceSource public ethPriceSource;
2026 
2027     uint256 public _minimumCollateralPercentage;
2028 
2029     uint256 public vaultCount;
2030     
2031     uint256 public closingFee;
2032     uint256 public openingFee;
2033 
2034     uint256 public minDebt;
2035     uint256 public maxDebt;
2036 
2037     uint256 constant public tokenPeg = 1e8; // $1
2038 
2039     uint256 public iR;
2040 
2041     mapping(uint256 => uint256) public vaultCollateral;
2042     mapping(uint256 => uint256) public accumulatedVaultDebt;
2043 
2044     mapping(uint256 => uint256) public lastInterest;
2045     mapping(uint256 => uint256) public promoter;
2046 
2047     uint256 public adminFee; // 10% of the earned interest
2048     uint256 public refFee; // 90% of the earned interest
2049 
2050     uint256 public debtRatio;
2051     uint256 public gainRatio;
2052 
2053     ERC20 public collateral;
2054     ERC20 public mai;
2055 
2056     uint256 public decimalDifferenceRaisedToTen;
2057 
2058     uint256 public priceSourceDecimals;
2059     uint256 public totalBorrowed;
2060 
2061     mapping(address => uint256) public maticDebt;
2062     uint256 public maiDebt;
2063 
2064     address public stabilityPool;
2065     address public adm;
2066     address public ref;
2067     address public router;
2068     uint8 public version = 7;
2069 
2070     event CreateVault(uint256 vaultID, address creator);
2071     event DestroyVault(uint256 vaultID);
2072     event DepositCollateral(uint256 vaultID, uint256 amount);
2073     event WithdrawCollateral(uint256 vaultID, uint256 amount);
2074     event BorrowToken(uint256 vaultID, uint256 amount);
2075     event PayBackToken(uint256 vaultID, uint256 amount, uint256 closingFee);
2076     event LiquidateVault(
2077         uint256 vaultID,
2078         address owner,
2079         address buyer,
2080         uint256 debtRepaid,
2081         uint256 collateralLiquidated,
2082         uint256 closingFee
2083     );
2084     event BoughtRiskyDebtVault(uint256 riskyVault, uint256 newVault, address riskyVaultBuyer, uint256 amountPaidtoBuy);
2085 
2086     constructor(
2087         address ethPriceSourceAddress,
2088         uint256 minimumCollateralPercentage,
2089         string memory name,
2090         string memory symbol,
2091         address _mai,
2092         address _collateral,
2093         string memory baseURI
2094     ) VaultNFTv4(name, symbol, baseURI) {
2095         
2096         require(ethPriceSourceAddress != address(0));
2097         require(minimumCollateralPercentage != 0);
2098 
2099         closingFee = 50; // 0.5%
2100         openingFee = 0; // 0.0% 
2101 
2102         ethPriceSource = IPriceSource(ethPriceSourceAddress);
2103         stabilityPool = address(0);
2104         
2105         maxDebt = 500000 ether; //Keeping maxDebt at 500K * 10^(18)
2106 
2107 
2108         debtRatio = 2; // 1/2, pay back 50%
2109         gainRatio = 1100; // /10 so 1.1
2110 
2111         _minimumCollateralPercentage = minimumCollateralPercentage;
2112 
2113         collateral = ERC20(_collateral);
2114         mai = ERC20(_mai);
2115         priceSourceDecimals = 8;
2116         
2117         /*
2118             This works only for collaterals with decimals < 18
2119         */
2120         decimalDifferenceRaisedToTen =
2121             10**(mai.decimals() - collateral.decimals());
2122         
2123         adm = msg.sender;
2124         ref = msg.sender;
2125     }
2126 
2127     modifier onlyVaultOwner(uint256 vaultID) {
2128         require(_exists(vaultID), "Vault does not exist");
2129         require(ownerOf(vaultID) == msg.sender, "Vault is not owned by you");
2130         _;
2131     }
2132 
2133     modifier onlyRouter() {
2134         require(
2135             router == address(0) || msg.sender == router,
2136             "must use router"
2137         );
2138         _;
2139     }
2140 
2141     modifier vaultExists(uint256 vaultID) {
2142         require(_exists(vaultID), "Vault does not exist");
2143         _;
2144     }
2145 
2146     modifier frontExists(uint256 vaultID) {
2147         require(_exists(vaultID), "front end vault does not exist");
2148         require(promoter[vaultID] <= TEN_THOUSAND && promoter[vaultID] > 0, "Front end not added");
2149         _;
2150     }
2151 
2152     /// @notice Return the current debt available to borrow.
2153     /// @dev checks the outstanding balance of the borrowable asset within the contract.
2154     /// @return available balance of borrowable asset.
2155     function getDebtCeiling() public view returns (uint256) {
2156         return mai.balanceOf(address(this));
2157     }
2158 
2159     /// @param vaultID is the token id of the vault being checked.
2160     /// @notice Returns true if a vault exists
2161     /// @dev the erc721 spec allows users to burn/destroy their nft
2162     /// @return boolean if the vault exists
2163     function exists(uint256 vaultID) external view returns (bool) {
2164         return _exists(vaultID);
2165     }
2166 
2167     /// @notice Returns the total value locked in the vault, based on the oracle price.
2168     /// @return uint256 total value locked in vault
2169     function getTotalValueLocked() external view returns (uint256) {
2170         return ( getEthPriceSource() * decimalDifferenceRaisedToTen * collateral.balanceOf(address(this)) ) ; //extra 1e8, to get fraction in ui
2171                 // 1e8 * 1eDelta 
2172     }
2173 
2174     /// @notice Return the fee charged when repaying a vault.
2175     /// @return uint256 is the fee charged to a vault when repaying.
2176     function getClosingFee() external view returns (uint256) {
2177         return closingFee;
2178     }
2179 
2180     /// @notice Return the peg maintained by the vault.
2181     /// @return uint256 is the value with 8 decimals used to calculate borrowable debt.
2182     function getTokenPriceSource() public view returns (uint256) {
2183         return tokenPeg;
2184     }
2185 
2186     /// @notice Return the collateral value
2187     /// @return uint256 is the value retrieved from the oracle used
2188     /// to calculate the available borrowable amounts.
2189     function getEthPriceSource() public view returns (uint256) {
2190         return ethPriceSource.latestAnswer();
2191     }
2192 
2193     /// @param vaultID is the token id of the vault being checked.
2194     /// @notice Returns the debt owned by the vault and the interest accrued over time.
2195     /// @return uint256 fee earned in the time between updates
2196     /// @return uint256 debt owed by the vault for further calculation.
2197     function _vaultDebtAndFee(uint256 vaultID)
2198         internal
2199         view
2200         returns (uint256, uint256)
2201     {
2202         uint256 currentTime = block.timestamp;
2203         uint256 debt = accumulatedVaultDebt[vaultID];
2204         uint256 fee = 0;
2205         if (lastInterest[vaultID] != 0 && iR > 0) {
2206             uint256 timeDelta = currentTime - lastInterest[vaultID];
2207 
2208             uint256 feeAccrued = (((iR * debt) * timeDelta) / ONE_YEAR) / TEN_THOUSAND;
2209             fee = feeAccrued;
2210             debt = feeAccrued + debt;
2211         }
2212         return (fee, debt);
2213     }
2214 
2215     /// @param vaultID is the token id of the vault being checked.
2216     /// @notice Returns the debt owned by the vault without tracking the interest
2217     /// @return uint256 debt owed by the vault for further calculation.
2218     function vaultDebt(uint256 vaultID) public view returns (uint256) {
2219         (, uint256 debt) = _vaultDebtAndFee(vaultID);
2220         return debt;
2221     }
2222 
2223     /// @param vaultID is the token id of the vault being checked.
2224     /// @notice Adds the interest charged to the vault over the previous time called.
2225     /// @return uint256 latest vault debt
2226     function updateVaultDebt(uint256 vaultID) public returns (uint256) {
2227         (uint256 fee, uint256 debt) = _vaultDebtAndFee(vaultID);
2228 
2229         maiDebt = maiDebt + fee;
2230 
2231         totalBorrowed = totalBorrowed + fee;
2232 
2233         if(iR > 0) {
2234             lastInterest[vaultID] = block.timestamp;
2235         }
2236 
2237         // we can just update the current vault debt here instead
2238         accumulatedVaultDebt[vaultID] = debt;
2239 
2240         return debt;
2241     }
2242 
2243     /// @param _collateral is the amount of collateral tokens to be valued.
2244     /// @param _debt is the debt owed by the vault.
2245     /// @notice Returns collateral value and debt based on the oracle prices
2246     /// @return uint256 coolateral value * 100. used to calculate the CDR
2247     /// @return uint256 debt value. Uses token price source to derive.
2248     function calculateCollateralProperties(uint256 _collateral, uint256 _debt)
2249         private
2250         view
2251         returns (uint256, uint256)
2252     {
2253         require(getEthPriceSource() != 0);
2254         require(getTokenPriceSource() != 0);
2255 
2256         uint256 collateralValue = _collateral *
2257             getEthPriceSource() *
2258             decimalDifferenceRaisedToTen;
2259 
2260         require(collateralValue >= _collateral);
2261 
2262         uint256 debtValue = _debt * getTokenPriceSource();
2263 
2264         require(debtValue >= _debt);
2265 
2266         uint256 collateralValueTimes100 = collateralValue * 100;
2267         require(collateralValueTimes100 > collateralValue);
2268 
2269         return (collateralValueTimes100, debtValue);
2270     }
2271 
2272     
2273     /// @param _collateral is the amount of collateral tokens held by vault.
2274     /// @param debt is the debt owed by the vault.
2275     /// @notice Calculates if the CDR is valid before taking a further action with a user
2276     /// @return boolean describing if the new CDR is valid.
2277     function isValidCollateral(uint256 _collateral, uint256 debt)
2278         public
2279         view
2280         returns (bool)
2281     {
2282         (
2283             uint256 collateralValueTimes100,
2284             uint256 debtValue
2285         ) = calculateCollateralProperties(_collateral, debt);
2286 
2287         uint256 collateralPercentage = collateralValueTimes100 / debtValue;
2288         return collateralPercentage >= _minimumCollateralPercentage;
2289     }
2290 
2291     
2292 
2293     /// @param fee is the amount of basis points (BP) to charge
2294     /// @param amount is the total value to calculate the BPs from
2295     /// @param promoFee is the fee charged by the front end
2296     /// @notice Returns fee to charge based on the collateral amount
2297     /// @return uint256 fee to charge the collateral.
2298     /// @dev fee can be called on web app to compare charges.
2299     function calculateFee(
2300         uint256 fee,
2301         uint256 amount,
2302         uint256 promoFee
2303     ) public view returns (uint256) {
2304         uint256 _fee;
2305         if (promoFee>0) {
2306             _fee = ((amount * fee * getTokenPriceSource() * promoFee) /
2307                 (getEthPriceSource() * TEN_THOUSAND * TEN_THOUSAND));
2308         } else {
2309             _fee = (amount * fee * getTokenPriceSource()) /
2310                 (getEthPriceSource() * TEN_THOUSAND);
2311         }
2312         return _fee / decimalDifferenceRaisedToTen;
2313     }
2314 
2315     /// @notice Creates a new ERC721 Vault NFT
2316     /// @return uint256 the token id of the vault created.
2317     function createVault() public returns (uint256) {
2318         uint256 id = vaultCount;
2319         vaultCount = vaultCount + 1;
2320         require(vaultCount >= id);
2321         _mint(msg.sender, id);
2322         emit CreateVault(id, msg.sender);
2323         return id;
2324     }
2325 
2326     /// @notice Destroys an ERC721 Vault NFT
2327     /// @param vaultID the vault ID to destroy
2328     /// @dev vault must not have any debt owed to be able to be destroyed.
2329     function destroyVault(uint256 vaultID)
2330         external
2331         onlyVaultOwner(vaultID)
2332         nonReentrant
2333     {
2334         require(vaultDebt(vaultID) == 0, "Vault has outstanding debt");
2335 
2336         if (vaultCollateral[vaultID] != 0) {
2337             // withdraw leftover collateral
2338             collateral.safeTransfer(ownerOf(vaultID), vaultCollateral[vaultID]);
2339         }
2340 
2341         _burn(vaultID);
2342 
2343         delete vaultCollateral[vaultID];
2344         delete accumulatedVaultDebt[vaultID];
2345         delete lastInterest[vaultID];
2346         emit DestroyVault(vaultID);
2347     }
2348 
2349     /// @param vaultID is the token id of the vault being interacted with.
2350     /// @param amount is the amount of collateral to deposit from msg.sender
2351     /// @notice Adds collateral to a specific vault by token id
2352     /// @dev Any address can deposit into a vault
2353     function depositCollateral(uint256 vaultID, uint256 amount)
2354         external
2355         vaultExists(vaultID)
2356         onlyRouter
2357     {
2358         uint256 newCollateral = vaultCollateral[vaultID] + (amount);
2359 
2360         require(newCollateral >= vaultCollateral[vaultID]);
2361 
2362         vaultCollateral[vaultID] = newCollateral;
2363 
2364         collateral.safeTransferFrom(msg.sender, address(this), amount);
2365 
2366         emit DepositCollateral(vaultID, amount);
2367     }
2368 
2369     /// @param vaultID is the token id of the vault being interacted with.
2370     /// @param amount is the amount of collateral to withdraw
2371     /// @notice withdraws collateral to a specific vault by token id
2372     /// @dev If there is debt, then it can only withdraw up to the min CDR.
2373     function withdrawCollateral(uint256 vaultID, uint256 amount)
2374         external
2375         onlyVaultOwner(vaultID)
2376         nonReentrant
2377     {
2378         require(
2379             vaultCollateral[vaultID] >= amount,
2380             "Vault does not have enough collateral"
2381         );
2382 
2383         uint256 newCollateral = vaultCollateral[vaultID] - amount;
2384         uint256 debt = updateVaultDebt(vaultID);
2385 
2386         if (debt != 0) {
2387             require(
2388                 isValidCollateral(newCollateral, debt),
2389                 "Withdrawal would put vault below minimum collateral percentage"
2390             );
2391         }
2392 
2393         vaultCollateral[vaultID] = newCollateral;
2394         collateral.safeTransfer(msg.sender, amount);
2395 
2396         emit WithdrawCollateral(vaultID, amount);
2397     }
2398 
2399     /// @param vaultID is the token id of the vault being interacted with.
2400     /// @param amount is the amount of borrowable asset to borrow
2401     /// @notice borrows asset based on the collateral held and the price of the collateral.
2402     /// @dev Borrowing is limited by the CDR of the vault
2403     /// If there's opening fee, it will be charged here.
2404     function borrowToken(
2405         uint256 vaultID,
2406         uint256 amount,
2407         uint256 _front
2408     ) external 
2409     frontExists(_front) 
2410     onlyVaultOwner(vaultID) 
2411     nonReentrant
2412     {
2413 
2414         require(amount > 0, "Must borrow non-zero amount");
2415         require(
2416             amount <= getDebtCeiling(),
2417             "borrowToken: Cannot mint over available supply."
2418         );
2419 
2420         uint256 newDebt = updateVaultDebt(vaultID) + amount;
2421 
2422         require(newDebt<=maxDebt, "borrowToken: max loan cap reached.");
2423 
2424         require(newDebt > vaultDebt(vaultID));
2425 
2426 
2427         require(
2428             isValidCollateral(vaultCollateral[vaultID], newDebt),
2429             "Borrow would put vault below minimum collateral percentage"
2430         );
2431 
2432         require(
2433             ((vaultDebt(vaultID)) + amount) >= minDebt,
2434             "Vault debt can't be under minDebt"
2435         );
2436 
2437         accumulatedVaultDebt[vaultID] = newDebt;
2438 
2439         uint256 _openingFee = calculateFee(openingFee, newDebt, promoter[_front]);
2440 
2441         vaultCollateral[vaultID] = vaultCollateral[vaultID] - (_openingFee);
2442         vaultCollateral[_front] = vaultCollateral[_front] + (_openingFee);
2443         
2444         // mai
2445         mai.safeTransfer(msg.sender, amount);
2446         totalBorrowed = totalBorrowed + (amount);
2447 
2448         emit BorrowToken(vaultID, amount);
2449     }
2450 
2451     function paybackTokenAll(
2452         uint256 vaultID,
2453         uint256 deadline,
2454         uint256 _front
2455     ) external frontExists(_front) vaultExists(vaultID) onlyRouter {
2456         require(
2457             deadline >= block.timestamp,
2458             "paybackTokenAll: deadline expired."
2459         );
2460 
2461         uint256 _amount = updateVaultDebt(vaultID);
2462         payBackToken(vaultID, _amount, _front);
2463     }
2464 
2465     /// @param vaultID is the token id of the vault being interacted with.
2466     /// @param amount is the amount of borrowable asset to repay
2467     /// @param _front is the front end that will get the opening
2468     /// @notice payback asset to close loan.
2469     /// @dev If there is debt, then it can only withdraw up to the min CDR.
2470     function payBackToken(
2471         uint256 vaultID,
2472         uint256 amount,
2473         uint256 _front
2474     ) public frontExists(_front) vaultExists(vaultID) onlyRouter {
2475         require(mai.balanceOf(msg.sender) >= amount, "Token balance too low");
2476 
2477         uint256 vaultDebtNow = updateVaultDebt(vaultID);
2478 
2479         require(
2480             vaultDebtNow >= amount,
2481             "Vault debt less than amount to pay back"
2482         );
2483 
2484         require(
2485             ((vaultDebtNow) - amount) >= minDebt || amount == (vaultDebtNow),
2486             "Vault debt can't be under minDebt"
2487         );
2488 
2489         uint256 _closingFee = calculateFee(
2490             closingFee,
2491             amount,
2492             promoter[_front]
2493         );
2494 
2495         accumulatedVaultDebt[vaultID] = vaultDebtNow - amount;
2496 
2497         vaultCollateral[vaultID] = vaultCollateral[vaultID] - _closingFee;
2498         vaultCollateral[_front] = vaultCollateral[_front] + _closingFee;
2499 
2500         totalBorrowed = totalBorrowed - amount;
2501 
2502         //mai
2503         mai.safeTransferFrom(msg.sender, address(this), amount);
2504         
2505         emit PayBackToken(vaultID, amount, _closingFee);
2506     }
2507 
2508     /// @notice withdraws liquidator earnings.
2509     /// @dev reverts if there's no collateral to withdraw.
2510     function getPaid() external nonReentrant {
2511         require(maticDebt[msg.sender] != 0, "Don't have anything for you.");
2512         uint256 amount = maticDebt[msg.sender];
2513         maticDebt[msg.sender] = 0;
2514         collateral.safeTransfer(msg.sender, amount);
2515     }
2516 
2517     /// @param pay is address of the person to getPaid
2518     /// @notice withdraws liquidator earnings.
2519     /// @dev reverts if there's no collateral to withdraw.
2520     function getPaid(address pay) external nonReentrant {
2521         require(maticDebt[pay] != 0, "Don't have anything for you.");
2522         uint256 amount = maticDebt[pay];
2523         maticDebt[pay] = 0;
2524         collateral.safeTransfer(pay, amount);
2525     }
2526 
2527     /// @param vaultID is the token id of the vault being interacted with.
2528     /// @notice Calculates cost to liquidate a vault
2529     /// @dev Can be used to calculate balance required to liquidate a vault. 
2530     function checkCost(uint256 vaultID) public view returns (uint256) {
2531         uint256 vaultDebtNow = vaultDebt(vaultID);
2532 
2533         if (
2534             vaultCollateral[vaultID] == 0 ||
2535             vaultDebtNow == 0 ||
2536             !checkLiquidation(vaultID)
2537         ) {
2538             return 0;
2539         }
2540 
2541         (,
2542             uint256 debtValue
2543         ) = calculateCollateralProperties(
2544                 vaultCollateral[vaultID],
2545                 vaultDebtNow
2546             );
2547 
2548         if (debtValue == 0) {
2549             return 0;
2550         }
2551 
2552         debtValue = debtValue / (10**priceSourceDecimals);
2553 
2554         uint256 halfDebt = debtValue / debtRatio; //debtRatio (2)
2555 
2556         if (halfDebt <= minDebt) {
2557             halfDebt = debtValue;
2558         }
2559 
2560         return (halfDebt);
2561     }
2562 
2563     /// @param vaultID is the token id of the vault being interacted with.
2564     /// @notice Calculates collateral to extract when liquidating a vault
2565     /// @dev Can be used to calculate earnings from liquidating a vault. 
2566     function checkExtract(uint256 vaultID) public view returns (uint256) {
2567         if (vaultCollateral[vaultID] == 0 || !checkLiquidation(vaultID)) {
2568             return 0;
2569         }
2570         uint256 vaultDebtNow = vaultDebt(vaultID);
2571 
2572         (, uint256 debtValue) = calculateCollateralProperties(
2573             vaultCollateral[vaultID],
2574             vaultDebtNow
2575         );
2576 
2577         uint256 halfDebt = debtValue / debtRatio; //debtRatio (2)
2578 
2579         if (halfDebt == 0) {
2580             return 0;
2581         }
2582         if ((halfDebt) / (10**priceSourceDecimals) <= minDebt) {
2583             // full liquidation if under the min debt.
2584             return (debtValue * ( gainRatio)) / (THOUSAND) / (getEthPriceSource()) / decimalDifferenceRaisedToTen;
2585         } else {
2586             return (halfDebt * (gainRatio)) / THOUSAND / (getEthPriceSource()) / decimalDifferenceRaisedToTen;
2587         }
2588     }
2589 
2590     /// @param vaultID is the token id of the vault being interacted with.
2591     /// @notice Calculates the collateral percentage of a vault.
2592     function checkCollateralPercentage(uint256 vaultID)
2593         public
2594         view
2595         vaultExists(vaultID)
2596         returns (uint256)
2597     {
2598         uint256 vaultDebtNow = vaultDebt(vaultID);
2599 
2600         if (vaultCollateral[vaultID] == 0 || vaultDebtNow == 0) {
2601             return 0;
2602         }
2603         (
2604             uint256 collateralValueTimes100,
2605             uint256 debtValue
2606         ) = calculateCollateralProperties(
2607                 vaultCollateral[vaultID],
2608                 vaultDebtNow
2609             );
2610 
2611         return collateralValueTimes100 / (debtValue);
2612     }
2613 
2614     /// @param vaultID is the token id of the vault being interacted with.
2615     /// @notice Calculates if a vault is liquidatable.
2616     /// @return bool if vault is liquidatable or not.
2617     function checkLiquidation(uint256 vaultID)
2618         public
2619         view
2620         vaultExists(vaultID)
2621         returns (bool)
2622     {
2623         uint256 vaultDebtNow = vaultDebt(vaultID);
2624 
2625         if (vaultCollateral[vaultID] == 0 || vaultDebtNow == 0) {
2626             return false;
2627         }
2628 
2629         (
2630             uint256 collateralValueTimes100,
2631             uint256 debtValue
2632         ) = calculateCollateralProperties(
2633                 vaultCollateral[vaultID],
2634                 vaultDebtNow
2635             );
2636 
2637         uint256 collateralPercentage = collateralValueTimes100 / (debtValue);
2638         if (collateralPercentage < _minimumCollateralPercentage) {
2639             return true;
2640         } else {
2641             return false;
2642         }
2643     }
2644 
2645     /// @param vaultID is the token id of the vault being interacted with.
2646     /// @notice Calculates if a vault is risky and can be bought.
2647     /// @return bool if vault is risky or not.
2648     function checkRiskyVault(uint256 vaultID) public view vaultExists(vaultID) returns (bool) {
2649 
2650         uint256 vaultDebtNow = vaultDebt(vaultID);
2651 
2652         if (vaultCollateral[vaultID] == 0 || vaultDebtNow == 0) {
2653             return false;
2654         }
2655 
2656         (
2657             uint256 collateralValueTimes100,
2658             uint256 debtValue
2659         ) = calculateCollateralProperties(
2660                 vaultCollateral[vaultID],
2661                 vaultDebtNow
2662             );
2663 
2664         uint256 collateralPercentage = collateralValueTimes100 / (debtValue);
2665 
2666         if ((collateralPercentage*10) <= gainRatio) {
2667             return true;
2668         } else {
2669             return false;
2670         }
2671     }
2672 
2673 
2674     /// @param vaultID is the token id of the vault being interacted with.
2675     /// @notice Pays back the part of the debt owed by the vault and removes a 
2676     /// comparable amount of collateral plus bonus
2677     /// @dev if vault CDR is under the bonus ratio,
2678     /// then it will only be able to be bought through buy risky.
2679     /// Amount to pay back is based on debtRatio variable.
2680     function liquidateVault(uint256 vaultID, uint256 _front)
2681         external
2682         frontExists(_front)
2683         vaultExists(vaultID)
2684     {
2685         require(
2686             stabilityPool == address(0) || msg.sender == stabilityPool,
2687             "liquidation is disabled for public"
2688         );
2689 
2690         uint256 vaultDebtNow = updateVaultDebt(vaultID);
2691         (
2692             uint256 collateralValueTimes100,
2693             uint256 debtValue
2694         ) = calculateCollateralProperties(
2695                 vaultCollateral[vaultID],
2696                 vaultDebtNow
2697             );
2698         require(vaultDebtNow != 0, "Vault debt is 0");
2699 
2700         uint256 collateralPercentage = collateralValueTimes100 / (debtValue);
2701 
2702         require(
2703             collateralPercentage < _minimumCollateralPercentage,
2704             "Vault is not below minimum collateral percentage"
2705         );
2706 
2707         require(collateralPercentage * 10 > gainRatio , "Vault is not above gain ratio");
2708 
2709         debtValue = debtValue / (10**priceSourceDecimals);
2710 
2711         uint256 halfDebt = debtValue / (debtRatio); //debtRatio (2)
2712 
2713         if (halfDebt <= minDebt) {
2714             halfDebt = debtValue;
2715         }
2716 
2717         require(
2718             mai.balanceOf(msg.sender) >= halfDebt,
2719             "Token balance too low to pay off outstanding debt"
2720         );
2721 
2722         totalBorrowed = totalBorrowed - (halfDebt);
2723 
2724         uint256 maticExtract = checkExtract(vaultID);
2725 
2726         accumulatedVaultDebt[vaultID] = vaultDebtNow - (halfDebt); // we paid back half of its debt.
2727 
2728         uint256 _closingFee = calculateFee(closingFee, halfDebt, promoter[_front]);
2729         vaultCollateral[vaultID] = vaultCollateral[vaultID] - (_closingFee);
2730         vaultCollateral[_front] = vaultCollateral[_front] + (_closingFee);
2731 
2732         
2733         // deduct the amount from the vault's collateral
2734         vaultCollateral[vaultID] = vaultCollateral[vaultID] - (maticExtract);
2735 
2736         // let liquidator take the collateral
2737         maticDebt[msg.sender] = maticDebt[msg.sender] + (maticExtract);
2738 
2739         //mai
2740         mai.safeTransferFrom(msg.sender, address(this), halfDebt);
2741 
2742         emit LiquidateVault(
2743             vaultID,
2744             ownerOf(vaultID),
2745             msg.sender,
2746             halfDebt,
2747             maticExtract,
2748             _closingFee
2749         );
2750     }
2751 
2752     /// @param vaultID is the token id of the vault being interacted with.
2753     /// @notice Pays back the debt owed to bring it back to min CDR. 
2754     /// And transfers ownership of it to the liquidator with a new vault
2755     /// @return uint256 new vault created with the debt and collateral.
2756     /// @dev this function can only be called if vault CDR is under the bonus ratio.
2757     /// address who calls it will now own the debt and the collateral.
2758     function buyRiskDebtVault(uint256 vaultID) external vaultExists(vaultID) returns(uint256) {
2759         require(
2760             stabilityPool == address(0) || msg.sender == stabilityPool,
2761             "buy risky is disabled for public"
2762         );        uint256 vaultDebtNow = updateVaultDebt(vaultID);
2763 
2764         require(vaultDebtNow != 0, "Vault debt is 0");
2765 
2766         (
2767             uint256 collateralValueTimes100,
2768             uint256 debtValue
2769         ) = calculateCollateralProperties(
2770                 vaultCollateral[vaultID],
2771                 vaultDebtNow
2772             );
2773 
2774         uint256 collateralPercentage = collateralValueTimes100 / (debtValue);
2775         require(
2776             (collateralPercentage*10) <= gainRatio,
2777             "Vault is not below risky collateral percentage" 
2778         );
2779 
2780         uint256 maiDebtTobePaid = (debtValue / (10**priceSourceDecimals)) - 
2781                                     (collateralValueTimes100 / 
2782                                     ( _minimumCollateralPercentage * (10**priceSourceDecimals)));
2783 
2784         //have enough MAI to bring vault to X CDR (presumably min)
2785         require(mai.balanceOf(msg.sender) >= maiDebtTobePaid, "Not enough mai to buy the risky vault");
2786         //mai
2787         mai.safeTransferFrom(msg.sender, address(this), maiDebtTobePaid);
2788         totalBorrowed = totalBorrowed - (maiDebtTobePaid);
2789         // newVault for msg.sender
2790         uint256 newVault = createVault();
2791         // updating vault collateral and debt details for the transfer of risky vault
2792         vaultCollateral[newVault] = vaultCollateral[vaultID];
2793         accumulatedVaultDebt[newVault] = vaultDebtNow - maiDebtTobePaid;
2794         lastInterest[newVault] = block.timestamp;
2795         // resetting the vaultID vault info
2796         delete vaultCollateral[vaultID];
2797         delete accumulatedVaultDebt[vaultID];
2798         // lastInterest of vaultID would be block.timestamp, not reseting its timestamp
2799         emit BoughtRiskyDebtVault(vaultID, newVault, msg.sender, maiDebtTobePaid);
2800         return newVault;
2801 
2802     }
2803 }
2804 
2805 
2806 // File contracts/fixedInterestVaults/fixedQiVault.sol
2807 
2808 pragma solidity 0.8.11;
2809 
2810 
2811 /// @title Fixed Interest Vault
2812 /// @notice Single collateral lending manager with fixed rate interest.
2813 contract stableQiVault is fixedVault, Ownable {
2814 
2815     /// @dev Used to restrain the fee. Can only be up to 5% of the amount.
2816     uint256 constant FEE_MAX = 500;
2817     
2818     string private oracleType;
2819     
2820     constructor(
2821         address ethPriceSourceAddress,
2822         uint256 minimumCollateralPercentage,
2823         string memory name,
2824         string memory symbol,
2825         address _mai,
2826         address _collateral,
2827         string memory baseURI
2828     )
2829         fixedVault(
2830             ethPriceSourceAddress,
2831             minimumCollateralPercentage,
2832             name,
2833             symbol,
2834             _mai,
2835             _collateral,
2836             baseURI
2837         )
2838     {
2839         createVault();
2840         addFrontEnd(0);
2841     }
2842 
2843     event UpdatedClosingFee(uint256 newFee);
2844     event UpdatedOpeningFee(uint256 newFee);
2845     event WithdrawInterest(uint256 earned);
2846     event UpdatedMinDebt(uint256 newMinDebt);
2847     event UpdatedMaxDebt(uint256 newMaxDebt);
2848     event UpdatedDebtRatio(uint256 _debtRatio);
2849     event UpdatedGainRatio(uint256 _gainRatio);
2850     event UpdatedEthPriceSource(address _ethPriceSourceAddress);
2851     
2852     event AddedFrontEnd(uint256 promoter);
2853     event RemovedFrontEnd(uint256 promoter);
2854     event UpdatedFrontEnd(uint256 promoter, uint256 newFee);
2855 
2856     event UpdatedFees(uint256 _adminFee, uint256 _refFee);
2857 
2858     event UpdatedMinCollateralRatio(uint256 newMinCollateralRatio);
2859     event UpdatedStabilityPool(address pool);
2860     event UpdatedInterestRate(uint256 interestRate);
2861     event BurnedToken(uint256 amount);
2862     event UpdatedTokenURI(string uri);
2863 
2864     event UpdatedAdmin(address newAdmin);
2865     event UpdatedRef(address newRef);
2866     event UpdatedOracleName(string oracle);
2867 
2868     modifier onlyOperators() {
2869         require(ref == msg.sender || adm == msg.sender || owner() == msg.sender, "Needs to be called by operators");
2870         _;
2871     }
2872 
2873     modifier onlyAdmin() {
2874         require(adm == msg.sender, "Needs to be called by admin");
2875         _;
2876     }
2877 
2878     /// @param _oracle name of the oracle used by the contract
2879     /// @notice sets the oracle name used by the contract. for visual purposes.
2880     function updateOracleName(string memory _oracle) external onlyOwner {
2881         oracleType = _oracle;
2882         emit UpdatedOracleName(_oracle);
2883     }
2884 
2885     /// @param _gainRatio sets the bonus earned from a liquidator
2886     /// @notice implements a setter for the bonus earned by a liquidator
2887     /// @dev fails if the bonus is less than 1
2888     function setGainRatio(uint256 _gainRatio) external onlyOwner {
2889         require(_gainRatio >= 1000, "gainRatio cannot be less than or equal to 1000");
2890         gainRatio = _gainRatio;
2891         emit UpdatedGainRatio(gainRatio);
2892     }
2893 
2894     /// @param _debtRatio sets the ratio of debt paid back by a liquidator
2895     /// @notice sets the ratio of the debt to be paid back
2896     /// @dev it divides the debt. 1/debtRatio.
2897     function setDebtRatio(uint256 _debtRatio) external onlyOwner {
2898         require(_debtRatio != 0, "Debt Ratio cannot be 0");
2899         debtRatio = _debtRatio;
2900         emit UpdatedDebtRatio(debtRatio);
2901     }
2902 
2903         /// @param ethPriceSourceAddress is the address that provides the price of the collateral
2904     /// @notice sets the address used as oracle
2905     /// @dev Oracle price feed is used in here. Interface's available in the at /interfaces/IPriceSourceAll.sol
2906     function changeEthPriceSource(address ethPriceSourceAddress)
2907         external
2908         onlyOwner
2909     {
2910         require(ethPriceSourceAddress != address(0), "Ethpricesource cannot be zero address" );
2911         ethPriceSource = IPriceSource(ethPriceSourceAddress);
2912         emit UpdatedEthPriceSource(ethPriceSourceAddress);
2913     }
2914 
2915     /// @param _pool is the address that can execute liquidations
2916     /// @notice sets the address used as stability pool for liquidations
2917     /// @dev if not set to address(0) then _pool is the only address able to liquidate
2918     function setStabilityPool(address _pool) external onlyOwner {
2919         require(_pool != address(0), "StabilityPool cannot be zero address" );
2920         stabilityPool = _pool;
2921         emit UpdatedStabilityPool(stabilityPool);
2922     }
2923 
2924     /// @param _admin is the ratio earned by the address that maintains the market
2925     /// @param _ref is the ratio earned by the address that provides the borrowable asset
2926     /// @notice sets the interest rate split between the admin and ref
2927     /// @dev if not set to address(0) then _pool is the only address able to liquidate
2928     function setFees(uint256 _admin, uint256 _ref) external onlyOwner {
2929         require((_admin+_ref)==TEN_THOUSAND, "setFees: must equal 10000.");
2930         adminFee=_admin;
2931         refFee=_ref;
2932         emit UpdatedFees(adminFee, refFee);
2933     }
2934 
2935     /// @param minimumCollateralPercentage is the CDR that limits the amount borrowed
2936     /// @notice sets the CDR
2937     /// @dev only callable by owner of the contract
2938     function setMinCollateralRatio(uint256 minimumCollateralPercentage)
2939         external
2940         onlyOwner
2941     {
2942         _minimumCollateralPercentage = minimumCollateralPercentage;
2943         emit UpdatedMinCollateralRatio(_minimumCollateralPercentage);
2944     }
2945 
2946     /// @param _minDebt is minimum debt able to be borrowed by a vault.
2947     /// @notice sets the minimum debt.
2948     /// @dev dust protection
2949     function setMinDebt(uint256 _minDebt)
2950         external
2951         onlyOwner
2952     {
2953         require(_minDebt >=0, "setMinDebt: must be over 0.");
2954         minDebt = _minDebt;
2955         emit UpdatedMinDebt(minDebt);
2956     }
2957 
2958     /// @param _maxDebt is maximum debt able to be borrowed by a vault.
2959     /// @notice sets the maximum debt.
2960     /// @dev whale and liquidity protection.
2961     function setMaxDebt(uint256 _maxDebt)
2962         external
2963         onlyOwner
2964     {
2965         require(_maxDebt >=0, "setMaxDebt: must be over 0.");
2966         maxDebt = _maxDebt;
2967         emit UpdatedMaxDebt(maxDebt);
2968     }
2969 
2970     /// @param _ref is the address that provides the borrowable asset
2971     /// @notice sets the address that earns interest for providing a borrowable asset
2972     /// @dev cannot be address(0)
2973     function setRef(address _ref) external onlyOwner {
2974         require(_ref != address(0), "Reference Address cannot be zero");
2975         ref = _ref;
2976         emit UpdatedRef(ref);
2977     }
2978 
2979     /// @param _adm is the ratio earned by the address that maintains the market
2980     /// @notice sets the address that earns interest for maintaining the market
2981     /// @dev cannot be address(0)
2982     function setAdmin(address _adm) external onlyOwner {
2983         require(_adm != address(0), "Admin Address cannot be zero");
2984         adm = _adm;
2985         emit UpdatedAdmin(adm);
2986     }
2987 
2988     /// @param _openingFee is the fee charged to a vault when borrowing.
2989     /// @notice sets opening fee.
2990     /// @dev can only be up to 5% (FEE_MAX) of the amount.
2991     function setOpeningFee(uint256 _openingFee) external onlyOwner {
2992         require(_openingFee >= 0 && _openingFee <= FEE_MAX, "setOpeningFee: cannot be more than 5%");
2993         openingFee = _openingFee;
2994         // emit event
2995         emit UpdatedOpeningFee(openingFee);
2996     }
2997 
2998     /// @param _closingFee is the fee charged to a vault when repaying.
2999     /// @notice sets closing fee.
3000     /// @dev can only be up to 5% (FEE_MAX) of the amount.
3001     function setClosingFee(uint256 _closingFee) external onlyOwner {
3002         require(_closingFee >= 0 && _closingFee <= FEE_MAX, "setClosingFee: cannot be more than 5%");
3003         closingFee = _closingFee;
3004         // emit event
3005         emit UpdatedClosingFee(closingFee);
3006     }
3007 
3008     /// @param _promoter is a front end for the contract
3009     /// @notice adds a front end to earn opening/closing fees from borrowing/repaying.
3010     /// @dev can only be up to 5% (FEE_MAX) of the amount.
3011     function addFrontEnd(uint256 _promoter) public onlyOwner {
3012         require(_exists(_promoter), "addFrontEnd: Vault does not exist");    
3013         require(promoter[_promoter] == 0, "addFrontEnd: already added");
3014         promoter[_promoter] = TEN_THOUSAND;
3015         emit AddedFrontEnd(_promoter);
3016     }
3017 
3018     /// @param _promoter is a front end for the contract
3019     /// @param cashback is the amount of fee not taken from a user.
3020     /// @notice updates the cashback variable for a given front end
3021     /// @dev can only be updated by the front end vault's owner
3022     function updateFrontEnd(uint256 _promoter, uint256 cashback) external frontExists(_promoter) onlyVaultOwner(_promoter) {
3023         require(cashback > 0 && cashback <= TEN_THOUSAND, "updateFrontEnd: cannot be 0");
3024         promoter[_promoter] = cashback;
3025         emit UpdatedFrontEnd(_promoter, cashback);
3026     }
3027 
3028     /// @param _promoter is a front end for the contract
3029     /// @notice removes the ability for a front end to earn fees
3030     function removeFrontEnd(uint256 _promoter) external frontExists(_promoter) onlyOwner {
3031         require(_exists(_promoter), "removeFrontEnd: Vault does not exist");
3032         require(promoter[_promoter] > 0, "removeFrontEnd: not a front end");
3033         promoter[_promoter] = 0;
3034         emit RemovedFrontEnd(_promoter);
3035     }
3036 
3037     /// @notice withdraws earned interest by vault.
3038     function withdrawInterest() external onlyOperators nonReentrant {
3039 
3040         uint256 adm_fee = maiDebt*adminFee / TEN_THOUSAND;
3041 
3042         // Transfer
3043         mai.transfer(ref, (maiDebt-adm_fee) ); // cheaper and equivalent.
3044         mai.transfer(adm, adm_fee);
3045         emit WithdrawInterest(maiDebt);
3046         maiDebt = 0;
3047     }
3048 
3049     /// @param _iR is the fixed interest charged by a vault
3050     /// @notice sets the interest charged by a vault.
3051     function setInterestRate(uint256 _iR) external onlyOwner {
3052         iR = _iR;
3053         emit UpdatedInterestRate(iR);
3054     }
3055 
3056     /// @param amountToken is the amount of borrowable asset that is removed from the debt ceiling.
3057     /// @notice removes debt ceiling from the vault.
3058     /// @dev returns the asset to the owner so it can be redeployed at a later time.
3059     function burn(uint256 amountToken) external onlyAdmin {
3060         // Burn
3061         require(amountToken < mai.balanceOf(address(this)), "burn: Balance not enough");
3062         mai.transfer(ref, amountToken);
3063         emit BurnedToken(amountToken);
3064     }
3065 
3066     /// @param _uri is the url for the nft metadata
3067     /// @notice updates the metadata
3068     /// @dev it currently uses an ipfs json
3069     function setTokenURI(string calldata _uri) external onlyOwner {
3070         uri = _uri;
3071         emit UpdatedTokenURI(uri);
3072     }
3073 
3074     function setRouter(address _router) external onlyOwner {
3075         router=_router;
3076     }
3077 }