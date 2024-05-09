1 /*
2 
3 website: pub.finance
4 
5 This project was forked from the KIMCHI.finance project.
6 
7  ,ggggggggggg,   ,ggg,         gg  ,ggggggggggg,
8 dP"""88""""""Y8,dP""Y8a        88 dP"""88""""""Y8,
9 Yb,  88      `8bYb, `88        88 Yb,  88      `8b
10  `"  88      ,8P `"  88        88  `"  88      ,8P
11      88aaaad8P"      88        88      88aaaad8P"
12      88"""""         88        88      88""""Y8ba
13      88              88        88      88      `8b
14      88              88        88      88      ,8P
15      88              Y8b,____,d88,     88_____,d8'
16      88               "Y888888P"Y8    88888888P"
17 
18 */
19 
20 pragma solidity ^0.6.12;
21 
22 /**
23  * @dev Collection of functions related to the address type
24  */
25 library Address {
26     /**
27      * @dev Returns true if `account` is a contract.
28      *
29      * [IMPORTANT]
30      * ====
31      * It is unsafe to assume that an address for which this function returns
32      * false is an externally-owned account (EOA) and not a contract.
33      *
34      * Among others, `isContract` will return false for the following
35      * types of addresses:
36      *
37      *  - an externally-owned account
38      *  - a contract in construction
39      *  - an address where a contract will be created
40      *  - an address where a contract lived, but was destroyed
41      * ====
42      */
43     function isContract(address account) internal view returns (bool) {
44         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
45         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
46         // for accounts without code, i.e. `keccak256('')`
47         bytes32 codehash;
48         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
49         // solhint-disable-next-line no-inline-assembly
50         assembly { codehash := extcodehash(account) }
51         return (codehash != accountHash && codehash != 0x0);
52     }
53 
54     /**
55      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
56      * `recipient`, forwarding all available gas and reverting on errors.
57      *
58      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
59      * of certain opcodes, possibly making contracts go over the 2300 gas limit
60      * imposed by `transfer`, making them unable to receive funds via
61      * `transfer`. {sendValue} removes this limitation.
62      *
63      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
64      *
65      * IMPORTANT: because control is transferred to `recipient`, care must be
66      * taken to not create reentrancy vulnerabilities. Consider using
67      * {ReentrancyGuard} or the
68      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
69      */
70     function sendValue(address payable recipient, uint256 amount) internal {
71         require(address(this).balance >= amount, "Address: insufficient balance");
72 
73         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
74         (bool success, ) = recipient.call{ value: amount }("");
75         require(success, "Address: unable to send value, recipient may have reverted");
76     }
77 
78     /**
79      * @dev Performs a Solidity function call using a low level `call`. A
80      * plain`call` is an unsafe replacement for a function call: use this
81      * function instead.
82      *
83      * If `target` reverts with a revert reason, it is bubbled up by this
84      * function (like regular Solidity function calls).
85      *
86      * Returns the raw returned data. To convert to the expected return value,
87      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
88      *
89      * Requirements:
90      *
91      * - `target` must be a contract.
92      * - calling `target` with `data` must not revert.
93      *
94      * _Available since v3.1._
95      */
96     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
97         return functionCall(target, data, "Address: low-level call failed");
98     }
99 
100     /**
101      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
102      * `errorMessage` as a fallback revert reason when `target` reverts.
103      *
104      * _Available since v3.1._
105      */
106     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
107         return _functionCallWithValue(target, data, 0, errorMessage);
108     }
109 
110     /**
111      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
112      * but also transferring `value` wei to `target`.
113      *
114      * Requirements:
115      *
116      * - the calling contract must have an ETH balance of at least `value`.
117      * - the called Solidity function must be `payable`.
118      *
119      * _Available since v3.1._
120      */
121     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
122         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
123     }
124 
125     /**
126      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
127      * with `errorMessage` as a fallback revert reason when `target` reverts.
128      *
129      * _Available since v3.1._
130      */
131     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
132         require(address(this).balance >= value, "Address: insufficient balance for call");
133         return _functionCallWithValue(target, data, value, errorMessage);
134     }
135 
136     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
137         require(isContract(target), "Address: call to non-contract");
138 
139         // solhint-disable-next-line avoid-low-level-calls
140         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
141         if (success) {
142             return returndata;
143         } else {
144             // Look for revert reason and bubble it up if present
145             if (returndata.length > 0) {
146                 // The easiest way to bubble the revert reason is using memory via assembly
147 
148                 // solhint-disable-next-line no-inline-assembly
149                 assembly {
150                     let returndata_size := mload(returndata)
151                     revert(add(32, returndata), returndata_size)
152                 }
153             } else {
154                 revert(errorMessage);
155             }
156         }
157     }
158 }
159 
160 /*
161  * @dev Provides information about the current execution context, including the
162  * sender of the transaction and its data. While these are generally available
163  * via msg.sender and msg.data, they should not be accessed in such a direct
164  * manner, since when dealing with GSN meta-transactions the account sending and
165  * paying for execution may not be the actual sender (as far as an application
166  * is concerned).
167  *
168  * This contract is only required for intermediate, library-like contracts.
169  */
170 abstract contract Context {
171     function _msgSender() internal view virtual returns (address payable) {
172         return msg.sender;
173     }
174 
175     function _msgData() internal view virtual returns (bytes memory) {
176         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
177         return msg.data;
178     }
179 }
180 
181 /**
182  * @dev Interface of the ERC20 standard as defined in the EIP.
183  */
184 interface IERC20 {
185     /**
186      * @dev Returns the amount of tokens in existence.
187      */
188     function totalSupply() external view returns (uint256);
189 
190     /**
191      * @dev Returns the amount of tokens owned by `account`.
192      */
193     function balanceOf(address account) external view returns (uint256);
194 
195     /**
196      * @dev Moves `amount` tokens from the caller's account to `recipient`.
197      *
198      * Returns a boolean value indicating whether the operation succeeded.
199      *
200      * Emits a {Transfer} event.
201      */
202     function transfer(address recipient, uint256 amount) external returns (bool);
203 
204     /**
205      * @dev Returns the remaining number of tokens that `spender` will be
206      * allowed to spend on behalf of `owner` through {transferFrom}. This is
207      * zero by default.
208      *
209      * This value changes when {approve} or {transferFrom} are called.
210      */
211     function allowance(address owner, address spender) external view returns (uint256);
212 
213     /**
214      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
215      *
216      * Returns a boolean value indicating whether the operation succeeded.
217      *
218      * IMPORTANT: Beware that changing an allowance with this method brings the risk
219      * that someone may use both the old and the new allowance by unfortunate
220      * transaction ordering. One possible solution to mitigate this race
221      * condition is to first reduce the spender's allowance to 0 and set the
222      * desired value afterwards:
223      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
224      *
225      * Emits an {Approval} event.
226      */
227     function approve(address spender, uint256 amount) external returns (bool);
228 
229     /**
230      * @dev Moves `amount` tokens from `sender` to `recipient` using the
231      * allowance mechanism. `amount` is then deducted from the caller's
232      * allowance.
233      *
234      * Returns a boolean value indicating whether the operation succeeded.
235      *
236      * Emits a {Transfer} event.
237      */
238     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
239 
240     /**
241      * @dev Emitted when `value` tokens are moved from one account (`from`) to
242      * another (`to`).
243      *
244      * Note that `value` may be zero.
245      */
246     event Transfer(address indexed from, address indexed to, uint256 value);
247 
248     /**
249      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
250      * a call to {approve}. `value` is the new allowance.
251      */
252     event Approval(address indexed owner, address indexed spender, uint256 value);
253 }
254 
255 /**
256  * @dev Implementation of the {IERC20} interface.
257  *
258  * This implementation is agnostic to the way tokens are created. This means
259  * that a supply mechanism has to be added in a derived contract using {_mint}.
260  * For a generic mechanism see {ERC20PresetMinterPauser}.
261  *
262  * TIP: For a detailed writeup see our guide
263  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
264  * to implement supply mechanisms].
265  *
266  * We have followed general OpenZeppelin guidelines: functions revert instead
267  * of returning `false` on failure. This behavior is nonetheless conventional
268  * and does not conflict with the expectations of ERC20 applications.
269  *
270  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
271  * This allows applications to reconstruct the allowance for all accounts just
272  * by listening to said events. Other implementations of the EIP may not emit
273  * these events, as it isn't required by the specification.
274  *
275  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
276  * functions have been added to mitigate the well-known issues around setting
277  * allowances. See {IERC20-approve}.
278  */
279 contract ERC20 is Context, IERC20 {
280     using SafeMath for uint256;
281     using Address for address;
282 
283     mapping (address => uint256) private _balances;
284 
285     mapping (address => mapping (address => uint256)) private _allowances;
286 
287     uint256 private _totalSupply;
288 
289     string private _name;
290     string private _symbol;
291     uint8 private _decimals;
292 
293     /**
294      * after an initial amount of tokens are minted when the token is created,
295      * the _mint() function will be locked until this time (set upon creation).
296      */
297     //    uint private _mintLockedUntilTimestamp;
298 
299     /**
300      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
301      * a default value of 18.
302      *
303      * To select a different value for {decimals}, use {_setupDecimals}.
304      *
305      * All three of these values are immutable: they can only be set once during
306      * construction.
307      */
308     // constructor (string memory name, string memory symbol, uint256 amountToMintOnCreation, uint256 mintLockedDays) public {
309     constructor (string memory name, string memory symbol) public {
310         _name = name;
311         _symbol = symbol;
312         _decimals = 18;
313         //
314         //        // mint to creator
315         //        _mint(msg.sender, amountToMintOnCreation);
316         //
317         //        // now lock minting for X days,
318         //        // by setting `_mintLockedUntilTimestamp` to prevent _mint()'ing until future time
319         //        _mintLockedUntilTimestamp = now.add(mintLockedDays.mul(1 days));
320     }
321 
322     /**
323      * @dev Returns the name of the token.
324      */
325     function name() public view returns (string memory) {
326         return _name;
327     }
328 
329     /**
330      * @dev Returns the symbol of the token, usually a shorter version of the
331      * name.
332      */
333     function symbol() public view returns (string memory) {
334         return _symbol;
335     }
336 
337     /**
338      * @dev Returns the number of decimals used to get its user representation.
339      * For example, if `decimals` equals `2`, a balance of `505` tokens should
340      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
341      *
342      * Tokens usually opt for a value of 18, imitating the relationship between
343      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
344      * called.
345      *
346      * NOTE: This information is only used for _display_ purposes: it in
347      * no way affects any of the arithmetic of the contract, including
348      * {IERC20-balanceOf} and {IERC20-transfer}.
349      */
350     function decimals() public view returns (uint8) {
351         return _decimals;
352     }
353 
354     /**
355      * @dev See {IERC20-totalSupply}.
356      */
357     function totalSupply() public view override returns (uint256) {
358         return _totalSupply;
359     }
360 
361     /**
362      * @dev See {IERC20-balanceOf}.
363      */
364     function balanceOf(address account) public view override returns (uint256) {
365         return _balances[account];
366     }
367 
368     /**
369      * @dev See {IERC20-transfer}.
370      *
371      * Requirements:
372      *
373      * - `recipient` cannot be the zero address.
374      * - the caller must have a balance of at least `amount`.
375      */
376     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
377         _transfer(_msgSender(), recipient, amount);
378         return true;
379     }
380 
381     /**
382      * @dev See {IERC20-allowance}.
383      */
384     function allowance(address owner, address spender) public view virtual override returns (uint256) {
385         return _allowances[owner][spender];
386     }
387 
388     /**
389      * @dev See {IERC20-approve}.
390      *
391      * Requirements:
392      *
393      * - `spender` cannot be the zero address.
394      */
395     function approve(address spender, uint256 amount) public virtual override returns (bool) {
396         _approve(_msgSender(), spender, amount);
397         return true;
398     }
399 
400     /**
401      * @dev See {IERC20-transferFrom}.
402      *
403      * Emits an {Approval} event indicating the updated allowance. This is not
404      * required by the EIP. See the note at the beginning of {ERC20};
405      *
406      * Requirements:
407      * - `sender` and `recipient` cannot be the zero address.
408      * - `sender` must have a balance of at least `amount`.
409      * - the caller must have allowance for ``sender``'s tokens of at least
410      * `amount`.
411      */
412     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
413         _transfer(sender, recipient, amount);
414         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
415         return true;
416     }
417 
418     /**
419      * @dev Atomically increases the allowance granted to `spender` by the caller.
420      *
421      * This is an alternative to {approve} that can be used as a mitigation for
422      * problems described in {IERC20-approve}.
423      *
424      * Emits an {Approval} event indicating the updated allowance.
425      *
426      * Requirements:
427      *
428      * - `spender` cannot be the zero address.
429      */
430     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
431         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
432         return true;
433     }
434 
435     /**
436      * @dev Atomically decreases the allowance granted to `spender` by the caller.
437      *
438      * This is an alternative to {approve} that can be used as a mitigation for
439      * problems described in {IERC20-approve}.
440      *
441      * Emits an {Approval} event indicating the updated allowance.
442      *
443      * Requirements:
444      *
445      * - `spender` cannot be the zero address.
446      * - `spender` must have allowance for the caller of at least
447      * `subtractedValue`.
448      */
449     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
450         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
451         return true;
452     }
453 
454     /**
455      * @dev Moves tokens `amount` from `sender` to `recipient`.
456      *
457      * This is internal function is equivalent to {transfer}, and can be used to
458      * e.g. implement automatic token fees, slashing mechanisms, etc.
459      *
460      * Emits a {Transfer} event.
461      *
462      * Requirements:
463      *
464      * - `sender` cannot be the zero address.
465      * - `recipient` cannot be the zero address.
466      * - `sender` must have a balance of at least `amount`.
467      */
468     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
469         require(sender != address(0), "ERC20: transfer from the zero address");
470         require(recipient != address(0), "ERC20: transfer to the zero address");
471 
472         _beforeTokenTransfer(sender, recipient, amount);
473 
474         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
475         _balances[recipient] = _balances[recipient].add(amount);
476         emit Transfer(sender, recipient, amount);
477     }
478 
479     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
480      * the total supply.
481      *
482      * Emits a {Transfer} event with `from` set to the zero address.
483      *
484      * Requirements
485      *
486      * - `to` cannot be the zero address.
487      */
488     function _mint(address account, uint256 amount) internal virtual {
489         require(account != address(0), "ERC20: mint to the zero address");
490 
491         _beforeTokenTransfer(address(0), account, amount);
492 
493         _totalSupply = _totalSupply.add(amount);
494         _balances[account] = _balances[account].add(amount);
495         emit Transfer(address(0), account, amount);
496     }
497 
498     /**
499      * @dev Destroys `amount` tokens from `account`, reducing the
500      * total supply.
501      *
502      * Emits a {Transfer} event with `to` set to the zero address.
503      *
504      * Requirements
505      *
506      * - `account` cannot be the zero address.
507      * - `account` must have at least `amount` tokens.
508      */
509     function _burn(address account, uint256 amount) internal virtual {
510         require(account != address(0), "ERC20: burn from the zero address");
511 
512         _beforeTokenTransfer(account, address(0), amount);
513 
514         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
515         _totalSupply = _totalSupply.sub(amount);
516         emit Transfer(account, address(0), amount);
517     }
518 
519     /**
520      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
521      *
522      * This is internal function is equivalent to `approve`, and can be used to
523      * e.g. set automatic allowances for certain subsystems, etc.
524      *
525      * Emits an {Approval} event.
526      *
527      * Requirements:
528      *
529      * - `owner` cannot be the zero address.
530      * - `spender` cannot be the zero address.
531      */
532     function _approve(address owner, address spender, uint256 amount) internal virtual {
533         require(owner != address(0), "ERC20: approve from the zero address");
534         require(spender != address(0), "ERC20: approve to the zero address");
535 
536         _allowances[owner][spender] = amount;
537         emit Approval(owner, spender, amount);
538     }
539 
540     /**
541      * @dev Sets {decimals} to a value other than the default one of 18.
542      *
543      * WARNING: This function should only be called from the constructor. Most
544      * applications that interact with token contracts will not expect
545      * {decimals} to ever change, and may work incorrectly if it does.
546      */
547     function _setupDecimals(uint8 decimals_) internal {
548         _decimals = decimals_;
549     }
550 
551     /**
552      * @dev Hook that is called before any transfer of tokens. This includes
553      * minting and burning.
554      *
555      * Calling conditions:
556      *
557      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
558      * will be to transferred to `to`.
559      * - when `from` is zero, `amount` tokens will be minted for `to`.
560      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
561      * - `from` and `to` are never both zero.
562      *
563      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
564      */
565     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
566 }
567 
568 
569 
570 /**
571  * @dev Contract module which provides a basic access control mechanism, where
572  * there is an account (an owner) that can be granted exclusive access to
573  * specific functions.
574  *
575  * By default, the owner account will be the one that deploys the contract. This
576  * can later be changed with {transferOwnership}.
577  *
578  * This module is used through inheritance. It will make available the modifier
579  * `onlyOwner`, which can be applied to your functions to restrict their use to
580  * the owner.
581  */
582 contract Ownable is Context {
583     address private _owner;
584 
585     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
586 
587     /**
588      * @dev Initializes the contract setting the deployer as the initial owner.
589      */
590     constructor () internal {
591         address msgSender = _msgSender();
592         _owner = msgSender;
593         emit OwnershipTransferred(address(0), msgSender);
594     }
595 
596     /**
597      * @dev Returns the address of the current owner.
598      */
599     function owner() public view returns (address) {
600         return _owner;
601     }
602 
603     /**
604      * @dev Throws if called by any account other than the owner.
605      */
606     modifier onlyOwner() {
607         require(_owner == _msgSender(), "Ownable: caller is not the owner");
608         _;
609     }
610 
611     /**
612      * @dev Leaves the contract without owner. It will not be possible to call
613      * `onlyOwner` functions anymore. Can only be called by the current owner.
614      *
615      * NOTE: Renouncing ownership will leave the contract without an owner,
616      * thereby removing any functionality that is only available to the owner.
617      */
618     function renounceOwnership() public virtual onlyOwner {
619         emit OwnershipTransferred(_owner, address(0));
620         _owner = address(0);
621     }
622 
623     /**
624      * @dev Transfers ownership of the contract to a new account (`newOwner`).
625      * Can only be called by the current owner.
626      */
627     function transferOwnership(address newOwner) public virtual onlyOwner {
628         require(newOwner != address(0), "Ownable: new owner is the zero address");
629         emit OwnershipTransferred(_owner, newOwner);
630         _owner = newOwner;
631     }
632 }
633 
634 /**
635  * @title SafeERC20
636  * @dev Wrappers around ERC20 operations that throw on failure (when the token
637  * contract returns false). Tokens that return no value (and instead revert or
638  * throw on failure) are also supported, non-reverting calls are assumed to be
639  * successful.
640  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
641  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
642  */
643 library SafeERC20 {
644     using SafeMath for uint256;
645     using Address for address;
646 
647     function safeTransfer(IERC20 token, address to, uint256 value) internal {
648         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
649     }
650 
651     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
652         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
653     }
654 
655     /**
656      * @dev Deprecated. This function has issues similar to the ones found in
657      * {IERC20-approve}, and its usage is discouraged.
658      *
659      * Whenever possible, use {safeIncreaseAllowance} and
660      * {safeDecreaseAllowance} instead.
661      */
662     function safeApprove(IERC20 token, address spender, uint256 value) internal {
663         // safeApprove should only be called when setting an initial allowance,
664         // or when resetting it to zero. To increase and decrease it, use
665         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
666         // solhint-disable-next-line max-line-length
667         require((value == 0) || (token.allowance(address(this), spender) == 0),
668             "SafeERC20: approve from non-zero to non-zero allowance"
669         );
670         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
671     }
672 
673     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
674         uint256 newAllowance = token.allowance(address(this), spender).add(value);
675         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
676     }
677 
678     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
679         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
680         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
681     }
682 
683     /**
684      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
685      * on the return value: the return value is optional (but if data is returned, it must not be false).
686      * @param token The token targeted by the call.
687      * @param data The call data (encoded using abi.encode or one of its variants).
688      */
689     function _callOptionalReturn(IERC20 token, bytes memory data) private {
690         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
691         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
692         // the target address contains contract code and also asserts for success in the low-level call.
693 
694         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
695         if (returndata.length > 0) { // Return data is optional
696             // solhint-disable-next-line max-line-length
697             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
698         }
699     }
700 }
701 
702 /**
703  * @dev Wrappers over Solidity's arithmetic operations with added overflow
704  * checks.
705  *
706  * Arithmetic operations in Solidity wrap on overflow. This can easily result
707  * in bugs, because programmers usually assume that an overflow raises an
708  * error, which is the standard behavior in high level programming languages.
709  * `SafeMath` restores this intuition by reverting the transaction when an
710  * operation overflows.
711  *
712  * Using this library instead of the unchecked operations eliminates an entire
713  * class of bugs, so it's recommended to use it always.
714  */
715 library SafeMath {
716     /**
717      * @dev Returns the addition of two unsigned integers, reverting on
718      * overflow.
719      *
720      * Counterpart to Solidity's `+` operator.
721      *
722      * Requirements:
723      *
724      * - Addition cannot overflow.
725      */
726     function add(uint256 a, uint256 b) internal pure returns (uint256) {
727         uint256 c = a + b;
728         require(c >= a, "SafeMath: addition overflow");
729 
730         return c;
731     }
732 
733     /**
734      * @dev Returns the subtraction of two unsigned integers, reverting on
735      * overflow (when the result is negative).
736      *
737      * Counterpart to Solidity's `-` operator.
738      *
739      * Requirements:
740      *
741      * - Subtraction cannot overflow.
742      */
743     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
744         return sub(a, b, "SafeMath: subtraction overflow");
745     }
746 
747     /**
748      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
749      * overflow (when the result is negative).
750      *
751      * Counterpart to Solidity's `-` operator.
752      *
753      * Requirements:
754      *
755      * - Subtraction cannot overflow.
756      */
757     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
758         require(b <= a, errorMessage);
759         uint256 c = a - b;
760 
761         return c;
762     }
763 
764     /**
765      * @dev Returns the multiplication of two unsigned integers, reverting on
766      * overflow.
767      *
768      * Counterpart to Solidity's `*` operator.
769      *
770      * Requirements:
771      *
772      * - Multiplication cannot overflow.
773      */
774     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
775         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
776         // benefit is lost if 'b' is also tested.
777         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
778         if (a == 0) {
779             return 0;
780         }
781 
782         uint256 c = a * b;
783         require(c / a == b, "SafeMath: multiplication overflow");
784 
785         return c;
786     }
787 
788     /**
789      * @dev Returns the integer division of two unsigned integers. Reverts on
790      * division by zero. The result is rounded towards zero.
791      *
792      * Counterpart to Solidity's `/` operator. Note: this function uses a
793      * `revert` opcode (which leaves remaining gas untouched) while Solidity
794      * uses an invalid opcode to revert (consuming all remaining gas).
795      *
796      * Requirements:
797      *
798      * - The divisor cannot be zero.
799      */
800     function div(uint256 a, uint256 b) internal pure returns (uint256) {
801         return div(a, b, "SafeMath: division by zero");
802     }
803 
804     /**
805      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
806      * division by zero. The result is rounded towards zero.
807      *
808      * Counterpart to Solidity's `/` operator. Note: this function uses a
809      * `revert` opcode (which leaves remaining gas untouched) while Solidity
810      * uses an invalid opcode to revert (consuming all remaining gas).
811      *
812      * Requirements:
813      *
814      * - The divisor cannot be zero.
815      */
816     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
817         require(b > 0, errorMessage);
818         uint256 c = a / b;
819         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
820 
821         return c;
822     }
823 
824     /**
825      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
826      * Reverts when dividing by zero.
827      *
828      * Counterpart to Solidity's `%` operator. This function uses a `revert`
829      * opcode (which leaves remaining gas untouched) while Solidity uses an
830      * invalid opcode to revert (consuming all remaining gas).
831      *
832      * Requirements:
833      *
834      * - The divisor cannot be zero.
835      */
836     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
837         return mod(a, b, "SafeMath: modulo by zero");
838     }
839 
840     /**
841      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
842      * Reverts with custom message when dividing by zero.
843      *
844      * Counterpart to Solidity's `%` operator. This function uses a `revert`
845      * opcode (which leaves remaining gas untouched) while Solidity uses an
846      * invalid opcode to revert (consuming all remaining gas).
847      *
848      * Requirements:
849      *
850      * - The divisor cannot be zero.
851      */
852     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
853         require(b != 0, errorMessage);
854         return a % b;
855     }
856 }
857 
858 // PubToken
859 contract PubToken is ERC20("PUB.finance","PUB"), Ownable {
860 
861     /// @notice Creates `_amount` token to `_to`. Must only be called by the owner (Bartender).
862     function mint(address _to, uint256 _amount) public onlyOwner {
863         _mint(_to, _amount);
864     }
865 }
866 
867 
868 contract Bartender is Ownable {
869     using SafeMath for uint256;
870     using SafeERC20 for IERC20;
871 
872     // Info of each user.
873     struct UserInfo {
874         uint256 amount;     // How many LP tokens the user has provided.
875         uint256 rewardDebt; // Reward debt. See explanation below.
876         //
877         // We do some fancy math here. Basically, any point in time, the amount of PUBs
878         // entitled to a user but is pending to be distributed is:
879         //
880         //   pending reward = (user.amount * pool.accPubPerShare) - user.rewardDebt
881         //
882         // Whenever a user deposits or withdraws LP tokens to a pool. Here's what happens:
883         //   1. The pool's `accPubPerShare` (and `lastRewardBlock`) gets updated.
884         //   2. User receives the pending reward sent to his/her address.
885         //   3. User's `amount` gets updated.
886         //   4. User's `rewardDebt` gets updated.
887     }
888 
889     // Info of each pool.
890     struct PoolInfo {
891         IERC20 lpToken;           // Address of LP token contract.
892         uint256 allocPoint;       // How many allocation points assigned to this pool. PUBs to distribute per block.
893         uint256 lastRewardBlock;  // Last block number that PUBs distribution occurs.
894         uint256 accPubPerShare;   // Accumulated PUBs per share, times 1e12. See below.
895     }
896 
897     // The PUB TOKEN!
898     PubToken public pub;
899     // Block number when bonus PUB period ends.
900     uint256 public bonusEndBlock;
901     // PUB tokens created per block.
902     uint256 public pubPerBlock;
903     // Bonus multiplier for early pub makers.
904     uint256 public constant BONUS_MULTIPLIER = 1; // no bonus
905 
906     // numerator of the owner fee
907     uint256 public constant OWNER_FEE_NUMERATOR = 5;
908     // denominator of the owner fee
909     uint256 public constant OWNER_FEE_DENOMINATOR = 1000;
910 
911     // Info of each pool.
912     PoolInfo[] public poolInfo;
913     // Info of each user that stakes LP tokens.
914     mapping (uint256 => mapping (address => UserInfo)) public userInfo;
915     // Total allocation points. Must be the sum of all allocation points in all pools.
916     uint256 public totalAllocPoint = 0;
917     // The block number when PUB mining starts.
918     uint256 public startBlock; // on creation, set to _bonusEndBlock, so set to 99999999, far in the future.
919 
920     event Deposit(address indexed user, uint256 indexed pid, uint256 amount);
921     event Withdraw(address indexed user, uint256 indexed pid, uint256 amount);
922     event EmergencyWithdraw(address indexed user, uint256 indexed pid, uint256 amount);
923 
924     constructor(
925         //uint256 _pubPerBlock,
926         uint256 _bonusEndBlock,
927         uint256 _startBlock
928     ) public {
929         // we are going to deploy the token from within this
930         // contructor to grant onlyOwner just to this contract.
931         // mint a couple tokens for the express purpose of creating the Uniswap LPs
932         pub = new PubToken();
933 
934         pubPerBlock = 0; // initial value
935         bonusEndBlock = _bonusEndBlock;
936         startBlock = _startBlock;
937     }
938 
939     // get the number of farms
940     function poolLength() external view returns (uint256) {
941         return poolInfo.length;
942     }
943 
944     // get the owner of the PUB token (should be this contract)
945     function pubOwner() external view returns (address) {
946         return pub.owner();
947     }
948 
949     // get the PUB balance of the caller
950     function myPubTokenBalance() external view returns (uint256) {
951         return pub.balanceOf(msg.sender);
952     }
953 
954     // Add a new lp to the pool. Can only be called by the owner.
955     // XXX DO NOT add the same LP token more than once. Rewards will be messed up if you do.
956     function add(uint256 _allocPoint, IERC20 _lpToken, bool _withUpdate) public onlyOwner {
957         if (_withUpdate) {
958             massUpdatePools();
959         }
960         uint256 lastRewardBlock = block.number > startBlock ? block.number : startBlock;
961         totalAllocPoint = totalAllocPoint.add(_allocPoint);
962         poolInfo.push(PoolInfo({
963             lpToken: _lpToken,
964             allocPoint: _allocPoint,
965             lastRewardBlock: lastRewardBlock,
966             accPubPerShare: 0
967             }));
968     }
969 
970     // get the current number of PUB per block
971     function getPubPerBlock() public view returns (uint256){
972         return pubPerBlock;
973     }
974 
975     // update the number of PUB per block, with a value in wei
976     function setPubPerBlock(uint256 _pubPerBlock) public onlyOwner {
977         require(_pubPerBlock > 0, "_pubPerBlock must be non-zero");
978 
979         // update all pools prior to changing the block rewards
980         massUpdatePools();
981 
982         // update the block rewards
983         pubPerBlock = _pubPerBlock;
984     }
985 
986     // Update the given pool's PUB allocation point. Can only be called by the owner.
987     function set(uint256 _pid, uint256 _allocPoint, bool _withUpdate) public onlyOwner {
988         if (_withUpdate) {
989             massUpdatePools();
990         }
991         totalAllocPoint = totalAllocPoint.sub(poolInfo[_pid].allocPoint).add(_allocPoint);
992         poolInfo[_pid].allocPoint = _allocPoint;
993     }
994 
995     // Return reward multiplier over the given _from to _to block.
996     function getMultiplier(uint256 _from, uint256 _to) public view returns (uint256) {
997         if (_to <= bonusEndBlock) {
998             return _to.sub(_from).mul(BONUS_MULTIPLIER);
999         } else if (_from >= bonusEndBlock) {
1000             return _to.sub(_from);
1001         } else {
1002             return bonusEndBlock.sub(_from).mul(BONUS_MULTIPLIER).add(
1003                 _to.sub(bonusEndBlock)
1004             );
1005         }
1006     }
1007 
1008     // View function to see pending PUBs on frontend.
1009     function pendingPubs(uint256 _pid, address _user) external view returns (uint256) {
1010         PoolInfo storage pool = poolInfo[_pid];
1011         UserInfo storage user = userInfo[_pid][_user];
1012         uint256 accPubPerShare = pool.accPubPerShare;
1013         uint256 lpSupply = pool.lpToken.balanceOf(address(this));
1014         if (block.number > pool.lastRewardBlock && lpSupply != 0) {
1015             uint256 multiplier = getMultiplier(pool.lastRewardBlock, block.number);
1016             uint256 pubReward = multiplier.mul(pubPerBlock).mul(pool.allocPoint).div(totalAllocPoint);
1017             accPubPerShare = accPubPerShare.add(pubReward.mul(1e12).div(lpSupply));
1018         }
1019         return user.amount.mul(accPubPerShare).div(1e12).sub(user.rewardDebt);
1020     }
1021 
1022     // Update reward variables for all pools. Be careful of gas spending!
1023     function massUpdatePools() public {
1024         uint256 length = poolInfo.length;
1025         for (uint256 pid = 0; pid < length; ++pid) {
1026             updatePool(pid);
1027         }
1028     }
1029 
1030     // Update reward variables of the given pool to be up-to-date.
1031     // updates starting with the 0 index
1032     function updatePool(uint256 _pid) public {
1033         PoolInfo storage pool = poolInfo[_pid];
1034         if (block.number <= pool.lastRewardBlock) {
1035             return;
1036         }
1037         uint256 lpSupply = pool.lpToken.balanceOf(address(this));
1038         if (lpSupply == 0) {
1039             pool.lastRewardBlock = block.number;
1040             return;
1041         }
1042         uint256 multiplier = getMultiplier(pool.lastRewardBlock, block.number);
1043         uint256 pubReward = multiplier.mul(pubPerBlock).mul(pool.allocPoint).div(totalAllocPoint);
1044 
1045         if(pubReward > 0){
1046             pub.mint(address(this), pubReward);
1047         }
1048         pool.accPubPerShare = pool.accPubPerShare.add(pubReward.mul(1e12).div(lpSupply));
1049         pool.lastRewardBlock = block.number;
1050     }
1051 
1052     // Deposit LP tokens to Bartender for PUB allocation.
1053     function deposit(uint256 _pid, uint256 _amount) public {
1054         PoolInfo storage pool = poolInfo[_pid];
1055         UserInfo storage user = userInfo[_pid][msg.sender];
1056         updatePool(_pid);
1057         if (user.amount > 0) {
1058             uint256 pending = user.amount.mul(pool.accPubPerShare).div(1e12).sub(user.rewardDebt);
1059             safePubTransfer(msg.sender, pending);
1060         }
1061         pool.lpToken.safeTransferFrom(address(msg.sender), address(this), _amount);
1062         user.amount = user.amount.add(_amount);
1063         user.rewardDebt = user.amount.mul(pool.accPubPerShare).div(1e12);
1064         emit Deposit(msg.sender, _pid, _amount);
1065     }
1066 
1067     // Withdraw LP tokens from Bartender.
1068     function withdraw(uint256 _pid, uint256 _amount) public {
1069         PoolInfo storage pool = poolInfo[_pid];
1070         UserInfo storage user = userInfo[_pid][msg.sender];
1071         require(user.amount >= _amount, "withdraw: not good");
1072         updatePool(_pid);
1073         uint256 pending = user.amount.mul(pool.accPubPerShare).div(1e12).sub(user.rewardDebt);
1074         safePubTransfer(msg.sender, pending);
1075         user.amount = user.amount.sub(_amount);
1076         user.rewardDebt = user.amount.mul(pool.accPubPerShare).div(1e12);
1077 
1078         if(msg.sender != owner()){
1079             // transfer the 0.5% fee to owner
1080             uint256 feeAmount = _amount.mul(OWNER_FEE_NUMERATOR).div(OWNER_FEE_DENOMINATOR);
1081             _amount = _amount.sub(feeAmount);
1082             // transfer the feeAmount to the owner using deposit
1083             pool.lpToken.safeTransfer(address(owner()), feeAmount);
1084         }
1085 
1086         // withdraw, using safeTransfer
1087         pool.lpToken.safeTransfer(address(msg.sender), _amount);
1088         emit Withdraw(msg.sender, _pid, _amount);
1089     }
1090 
1091     // Withdraw without caring about rewards. EMERGENCY ONLY.
1092     function emergencyWithdraw(uint256 _pid) public {
1093         PoolInfo storage pool = poolInfo[_pid];
1094         UserInfo storage user = userInfo[_pid][msg.sender];
1095 
1096         uint256 amount = user.amount;
1097         if(msg.sender != owner()){
1098             // transfer the 0.5% fee to owner
1099             uint256 feeAmount = amount.mul(OWNER_FEE_NUMERATOR).div(OWNER_FEE_DENOMINATOR);
1100             amount = amount.sub(feeAmount);
1101             // transfer the feeAmount to the owner using deposit
1102             pool.lpToken.safeTransfer(address(owner()), feeAmount);
1103         }
1104 
1105         pool.lpToken.safeTransfer(address(msg.sender), amount);
1106         emit EmergencyWithdraw(msg.sender, _pid, amount);
1107         user.amount = 0;
1108         user.rewardDebt = 0;
1109     }
1110 
1111     // Safe pub transfer function, just in case if rounding error causes pool to not have enough PUBs.
1112     function safePubTransfer(address _to, uint256 _amount) internal {
1113         uint256 pubBal = pub.balanceOf(address(this));
1114         if (_amount > pubBal) {
1115             pub.transfer(_to, pubBal);
1116         } else {
1117             pub.transfer(_to, _amount);
1118         }
1119     }
1120 
1121 }