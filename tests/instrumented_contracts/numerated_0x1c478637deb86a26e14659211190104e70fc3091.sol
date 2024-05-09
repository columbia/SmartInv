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
20 /**
21  * @dev Collection of functions related to the address type
22  */
23 library Address {
24     /**
25      * @dev Returns true if `account` is a contract.
26      *
27      * [IMPORTANT]
28      * ====
29      * It is unsafe to assume that an address for which this function returns
30      * false is an externally-owned account (EOA) and not a contract.
31      *
32      * Among others, `isContract` will return false for the following
33      * types of addresses:
34      *
35      *  - an externally-owned account
36      *  - a contract in construction
37      *  - an address where a contract will be created
38      *  - an address where a contract lived, but was destroyed
39      * ====
40      */
41     function isContract(address account) internal view returns (bool) {
42         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
43         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
44         // for accounts without code, i.e. `keccak256('')`
45         bytes32 codehash;
46         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
47         // solhint-disable-next-line no-inline-assembly
48         assembly { codehash := extcodehash(account) }
49         return (codehash != accountHash && codehash != 0x0);
50     }
51 
52     /**
53      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
54      * `recipient`, forwarding all available gas and reverting on errors.
55      *
56      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
57      * of certain opcodes, possibly making contracts go over the 2300 gas limit
58      * imposed by `transfer`, making them unable to receive funds via
59      * `transfer`. {sendValue} removes this limitation.
60      *
61      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
62      *
63      * IMPORTANT: because control is transferred to `recipient`, care must be
64      * taken to not create reentrancy vulnerabilities. Consider using
65      * {ReentrancyGuard} or the
66      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
67      */
68     function sendValue(address payable recipient, uint256 amount) internal {
69         require(address(this).balance >= amount, "Address: insufficient balance");
70 
71         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
72         (bool success, ) = recipient.call{ value: amount }("");
73         require(success, "Address: unable to send value, recipient may have reverted");
74     }
75 
76     /**
77      * @dev Performs a Solidity function call using a low level `call`. A
78      * plain`call` is an unsafe replacement for a function call: use this
79      * function instead.
80      *
81      * If `target` reverts with a revert reason, it is bubbled up by this
82      * function (like regular Solidity function calls).
83      *
84      * Returns the raw returned data. To convert to the expected return value,
85      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
86      *
87      * Requirements:
88      *
89      * - `target` must be a contract.
90      * - calling `target` with `data` must not revert.
91      *
92      * _Available since v3.1._
93      */
94     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
95         return functionCall(target, data, "Address: low-level call failed");
96     }
97 
98     /**
99      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
100      * `errorMessage` as a fallback revert reason when `target` reverts.
101      *
102      * _Available since v3.1._
103      */
104     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
105         return _functionCallWithValue(target, data, 0, errorMessage);
106     }
107 
108     /**
109      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
110      * but also transferring `value` wei to `target`.
111      *
112      * Requirements:
113      *
114      * - the calling contract must have an ETH balance of at least `value`.
115      * - the called Solidity function must be `payable`.
116      *
117      * _Available since v3.1._
118      */
119     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
120         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
121     }
122 
123     /**
124      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
125      * with `errorMessage` as a fallback revert reason when `target` reverts.
126      *
127      * _Available since v3.1._
128      */
129     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
130         require(address(this).balance >= value, "Address: insufficient balance for call");
131         return _functionCallWithValue(target, data, value, errorMessage);
132     }
133 
134     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
135         require(isContract(target), "Address: call to non-contract");
136 
137         // solhint-disable-next-line avoid-low-level-calls
138         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
139         if (success) {
140             return returndata;
141         } else {
142             // Look for revert reason and bubble it up if present
143             if (returndata.length > 0) {
144                 // The easiest way to bubble the revert reason is using memory via assembly
145 
146                 // solhint-disable-next-line no-inline-assembly
147                 assembly {
148                     let returndata_size := mload(returndata)
149                     revert(add(32, returndata), returndata_size)
150                 }
151             } else {
152                 revert(errorMessage);
153             }
154         }
155     }
156 }
157 
158 /*
159  * @dev Provides information about the current execution context, including the
160  * sender of the transaction and its data. While these are generally available
161  * via msg.sender and msg.data, they should not be accessed in such a direct
162  * manner, since when dealing with GSN meta-transactions the account sending and
163  * paying for execution may not be the actual sender (as far as an application
164  * is concerned).
165  *
166  * This contract is only required for intermediate, library-like contracts.
167  */
168 abstract contract Context {
169     function _msgSender() internal view virtual returns (address payable) {
170         return msg.sender;
171     }
172 
173     function _msgData() internal view virtual returns (bytes memory) {
174         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
175         return msg.data;
176     }
177 }
178 
179 /**
180  * @dev Interface of the ERC20 standard as defined in the EIP.
181  */
182 interface IERC20 {
183     /**
184      * @dev Returns the amount of tokens in existence.
185      */
186     function totalSupply() external view returns (uint256);
187 
188     /**
189      * @dev Returns the amount of tokens owned by `account`.
190      */
191     function balanceOf(address account) external view returns (uint256);
192 
193     /**
194      * @dev Moves `amount` tokens from the caller's account to `recipient`.
195      *
196      * Returns a boolean value indicating whether the operation succeeded.
197      *
198      * Emits a {Transfer} event.
199      */
200     function transfer(address recipient, uint256 amount) external returns (bool);
201 
202     /**
203      * @dev Returns the remaining number of tokens that `spender` will be
204      * allowed to spend on behalf of `owner` through {transferFrom}. This is
205      * zero by default.
206      *
207      * This value changes when {approve} or {transferFrom} are called.
208      */
209     function allowance(address owner, address spender) external view returns (uint256);
210 
211     /**
212      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
213      *
214      * Returns a boolean value indicating whether the operation succeeded.
215      *
216      * IMPORTANT: Beware that changing an allowance with this method brings the risk
217      * that someone may use both the old and the new allowance by unfortunate
218      * transaction ordering. One possible solution to mitigate this race
219      * condition is to first reduce the spender's allowance to 0 and set the
220      * desired value afterwards:
221      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
222      *
223      * Emits an {Approval} event.
224      */
225     function approve(address spender, uint256 amount) external returns (bool);
226 
227     /**
228      * @dev Moves `amount` tokens from `sender` to `recipient` using the
229      * allowance mechanism. `amount` is then deducted from the caller's
230      * allowance.
231      *
232      * Returns a boolean value indicating whether the operation succeeded.
233      *
234      * Emits a {Transfer} event.
235      */
236     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
237 
238     /**
239      * @dev Emitted when `value` tokens are moved from one account (`from`) to
240      * another (`to`).
241      *
242      * Note that `value` may be zero.
243      */
244     event Transfer(address indexed from, address indexed to, uint256 value);
245 
246     /**
247      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
248      * a call to {approve}. `value` is the new allowance.
249      */
250     event Approval(address indexed owner, address indexed spender, uint256 value);
251 }
252 
253 /**
254  * @dev Implementation of the {IERC20} interface.
255  *
256  * This implementation is agnostic to the way tokens are created. This means
257  * that a supply mechanism has to be added in a derived contract using {_mint}.
258  * For a generic mechanism see {ERC20PresetMinterPauser}.
259  *
260  * TIP: For a detailed writeup see our guide
261  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
262  * to implement supply mechanisms].
263  *
264  * We have followed general OpenZeppelin guidelines: functions revert instead
265  * of returning `false` on failure. This behavior is nonetheless conventional
266  * and does not conflict with the expectations of ERC20 applications.
267  *
268  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
269  * This allows applications to reconstruct the allowance for all accounts just
270  * by listening to said events. Other implementations of the EIP may not emit
271  * these events, as it isn't required by the specification.
272  *
273  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
274  * functions have been added to mitigate the well-known issues around setting
275  * allowances. See {IERC20-approve}.
276  */
277 contract ERC20 is Context, IERC20 {
278     using SafeMath for uint256;
279     using Address for address;
280 
281     mapping (address => uint256) private _balances;
282 
283     mapping (address => mapping (address => uint256)) private _allowances;
284 
285     uint256 private _totalSupply;
286 
287     string private _name;
288     string private _symbol;
289     uint8 private _decimals;
290 
291     /**
292      * after an initial amount of tokens are minted when the token is created,
293      * the _mint() function will be locked until this time (set upon creation).
294      */
295     //    uint private _mintLockedUntilTimestamp;
296 
297     /**
298      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
299      * a default value of 18.
300      *
301      * To select a different value for {decimals}, use {_setupDecimals}.
302      *
303      * All three of these values are immutable: they can only be set once during
304      * construction.
305      */
306     // constructor (string memory name, string memory symbol, uint256 amountToMintOnCreation, uint256 mintLockedDays) public {
307     constructor (string memory name, string memory symbol) public {
308         _name = name;
309         _symbol = symbol;
310         _decimals = 18;
311         //
312         //        // mint to creator
313         //        _mint(msg.sender, amountToMintOnCreation);
314         //
315         //        // now lock minting for X days,
316         //        // by setting `_mintLockedUntilTimestamp` to prevent _mint()'ing until future time
317         //        _mintLockedUntilTimestamp = now.add(mintLockedDays.mul(1 days));
318     }
319 
320     /**
321      * @dev Returns the name of the token.
322      */
323     function name() public view returns (string memory) {
324         return _name;
325     }
326 
327     /**
328      * @dev Returns the symbol of the token, usually a shorter version of the
329      * name.
330      */
331     function symbol() public view returns (string memory) {
332         return _symbol;
333     }
334 
335     /**
336      * @dev Returns the number of decimals used to get its user representation.
337      * For example, if `decimals` equals `2`, a balance of `505` tokens should
338      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
339      *
340      * Tokens usually opt for a value of 18, imitating the relationship between
341      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
342      * called.
343      *
344      * NOTE: This information is only used for _display_ purposes: it in
345      * no way affects any of the arithmetic of the contract, including
346      * {IERC20-balanceOf} and {IERC20-transfer}.
347      */
348     function decimals() public view returns (uint8) {
349         return _decimals;
350     }
351 
352     /**
353      * @dev See {IERC20-totalSupply}.
354      */
355     function totalSupply() public view override returns (uint256) {
356         return _totalSupply;
357     }
358 
359     /**
360      * @dev See {IERC20-balanceOf}.
361      */
362     function balanceOf(address account) public view override returns (uint256) {
363         return _balances[account];
364     }
365 
366     /**
367      * @dev See {IERC20-transfer}.
368      *
369      * Requirements:
370      *
371      * - `recipient` cannot be the zero address.
372      * - the caller must have a balance of at least `amount`.
373      */
374     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
375         _transfer(_msgSender(), recipient, amount);
376         return true;
377     }
378 
379     /**
380      * @dev See {IERC20-allowance}.
381      */
382     function allowance(address owner, address spender) public view virtual override returns (uint256) {
383         return _allowances[owner][spender];
384     }
385 
386     /**
387      * @dev See {IERC20-approve}.
388      *
389      * Requirements:
390      *
391      * - `spender` cannot be the zero address.
392      */
393     function approve(address spender, uint256 amount) public virtual override returns (bool) {
394         _approve(_msgSender(), spender, amount);
395         return true;
396     }
397 
398     /**
399      * @dev See {IERC20-transferFrom}.
400      *
401      * Emits an {Approval} event indicating the updated allowance. This is not
402      * required by the EIP. See the note at the beginning of {ERC20};
403      *
404      * Requirements:
405      * - `sender` and `recipient` cannot be the zero address.
406      * - `sender` must have a balance of at least `amount`.
407      * - the caller must have allowance for ``sender``'s tokens of at least
408      * `amount`.
409      */
410     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
411         _transfer(sender, recipient, amount);
412         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
413         return true;
414     }
415 
416     /**
417      * @dev Atomically increases the allowance granted to `spender` by the caller.
418      *
419      * This is an alternative to {approve} that can be used as a mitigation for
420      * problems described in {IERC20-approve}.
421      *
422      * Emits an {Approval} event indicating the updated allowance.
423      *
424      * Requirements:
425      *
426      * - `spender` cannot be the zero address.
427      */
428     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
429         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
430         return true;
431     }
432 
433     /**
434      * @dev Atomically decreases the allowance granted to `spender` by the caller.
435      *
436      * This is an alternative to {approve} that can be used as a mitigation for
437      * problems described in {IERC20-approve}.
438      *
439      * Emits an {Approval} event indicating the updated allowance.
440      *
441      * Requirements:
442      *
443      * - `spender` cannot be the zero address.
444      * - `spender` must have allowance for the caller of at least
445      * `subtractedValue`.
446      */
447     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
448         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
449         return true;
450     }
451 
452     /**
453      * @dev Moves tokens `amount` from `sender` to `recipient`.
454      *
455      * This is internal function is equivalent to {transfer}, and can be used to
456      * e.g. implement automatic token fees, slashing mechanisms, etc.
457      *
458      * Emits a {Transfer} event.
459      *
460      * Requirements:
461      *
462      * - `sender` cannot be the zero address.
463      * - `recipient` cannot be the zero address.
464      * - `sender` must have a balance of at least `amount`.
465      */
466     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
467         require(sender != address(0), "ERC20: transfer from the zero address");
468         require(recipient != address(0), "ERC20: transfer to the zero address");
469 
470         _beforeTokenTransfer(sender, recipient, amount);
471 
472         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
473         _balances[recipient] = _balances[recipient].add(amount);
474         emit Transfer(sender, recipient, amount);
475     }
476 
477     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
478      * the total supply.
479      *
480      * Emits a {Transfer} event with `from` set to the zero address.
481      *
482      * Requirements
483      *
484      * - `to` cannot be the zero address.
485      */
486     function _mint(address account, uint256 amount) internal virtual {
487         require(account != address(0), "ERC20: mint to the zero address");
488 
489         _beforeTokenTransfer(address(0), account, amount);
490 
491         _totalSupply = _totalSupply.add(amount);
492         _balances[account] = _balances[account].add(amount);
493         emit Transfer(address(0), account, amount);
494     }
495 
496     /**
497      * @dev Destroys `amount` tokens from `account`, reducing the
498      * total supply.
499      *
500      * Emits a {Transfer} event with `to` set to the zero address.
501      *
502      * Requirements
503      *
504      * - `account` cannot be the zero address.
505      * - `account` must have at least `amount` tokens.
506      */
507     function _burn(address account, uint256 amount) internal virtual {
508         require(account != address(0), "ERC20: burn from the zero address");
509 
510         _beforeTokenTransfer(account, address(0), amount);
511 
512         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
513         _totalSupply = _totalSupply.sub(amount);
514         emit Transfer(account, address(0), amount);
515     }
516 
517     /**
518      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
519      *
520      * This is internal function is equivalent to `approve`, and can be used to
521      * e.g. set automatic allowances for certain subsystems, etc.
522      *
523      * Emits an {Approval} event.
524      *
525      * Requirements:
526      *
527      * - `owner` cannot be the zero address.
528      * - `spender` cannot be the zero address.
529      */
530     function _approve(address owner, address spender, uint256 amount) internal virtual {
531         require(owner != address(0), "ERC20: approve from the zero address");
532         require(spender != address(0), "ERC20: approve to the zero address");
533 
534         _allowances[owner][spender] = amount;
535         emit Approval(owner, spender, amount);
536     }
537 
538     /**
539      * @dev Sets {decimals} to a value other than the default one of 18.
540      *
541      * WARNING: This function should only be called from the constructor. Most
542      * applications that interact with token contracts will not expect
543      * {decimals} to ever change, and may work incorrectly if it does.
544      */
545     function _setupDecimals(uint8 decimals_) internal {
546         _decimals = decimals_;
547     }
548 
549     /**
550      * @dev Hook that is called before any transfer of tokens. This includes
551      * minting and burning.
552      *
553      * Calling conditions:
554      *
555      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
556      * will be to transferred to `to`.
557      * - when `from` is zero, `amount` tokens will be minted for `to`.
558      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
559      * - `from` and `to` are never both zero.
560      *
561      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
562      */
563     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
564 }
565 
566 
567 
568 /**
569  * @dev Contract module which provides a basic access control mechanism, where
570  * there is an account (an owner) that can be granted exclusive access to
571  * specific functions.
572  *
573  * By default, the owner account will be the one that deploys the contract. This
574  * can later be changed with {transferOwnership}.
575  *
576  * This module is used through inheritance. It will make available the modifier
577  * `onlyOwner`, which can be applied to your functions to restrict their use to
578  * the owner.
579  */
580 contract Ownable is Context {
581     address private _owner;
582 
583     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
584 
585     /**
586      * @dev Initializes the contract setting the deployer as the initial owner.
587      */
588     constructor () internal {
589         address msgSender = _msgSender();
590         _owner = msgSender;
591         emit OwnershipTransferred(address(0), msgSender);
592     }
593 
594     /**
595      * @dev Returns the address of the current owner.
596      */
597     function owner() public view returns (address) {
598         return _owner;
599     }
600 
601     /**
602      * @dev Throws if called by any account other than the owner.
603      */
604     modifier onlyOwner() {
605         require(_owner == _msgSender(), "Ownable: caller is not the owner");
606         _;
607     }
608 
609     /**
610      * @dev Leaves the contract without owner. It will not be possible to call
611      * `onlyOwner` functions anymore. Can only be called by the current owner.
612      *
613      * NOTE: Renouncing ownership will leave the contract without an owner,
614      * thereby removing any functionality that is only available to the owner.
615      */
616     function renounceOwnership() public virtual onlyOwner {
617         emit OwnershipTransferred(_owner, address(0));
618         _owner = address(0);
619     }
620 
621     /**
622      * @dev Transfers ownership of the contract to a new account (`newOwner`).
623      * Can only be called by the current owner.
624      */
625     function transferOwnership(address newOwner) public virtual onlyOwner {
626         require(newOwner != address(0), "Ownable: new owner is the zero address");
627         emit OwnershipTransferred(_owner, newOwner);
628         _owner = newOwner;
629     }
630 }
631 
632 /**
633  * @title SafeERC20
634  * @dev Wrappers around ERC20 operations that throw on failure (when the token
635  * contract returns false). Tokens that return no value (and instead revert or
636  * throw on failure) are also supported, non-reverting calls are assumed to be
637  * successful.
638  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
639  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
640  */
641 library SafeERC20 {
642     using SafeMath for uint256;
643     using Address for address;
644 
645     function safeTransfer(IERC20 token, address to, uint256 value) internal {
646         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
647     }
648 
649     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
650         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
651     }
652 
653     /**
654      * @dev Deprecated. This function has issues similar to the ones found in
655      * {IERC20-approve}, and its usage is discouraged.
656      *
657      * Whenever possible, use {safeIncreaseAllowance} and
658      * {safeDecreaseAllowance} instead.
659      */
660     function safeApprove(IERC20 token, address spender, uint256 value) internal {
661         // safeApprove should only be called when setting an initial allowance,
662         // or when resetting it to zero. To increase and decrease it, use
663         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
664         // solhint-disable-next-line max-line-length
665         require((value == 0) || (token.allowance(address(this), spender) == 0),
666             "SafeERC20: approve from non-zero to non-zero allowance"
667         );
668         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
669     }
670 
671     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
672         uint256 newAllowance = token.allowance(address(this), spender).add(value);
673         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
674     }
675 
676     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
677         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
678         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
679     }
680 
681     /**
682      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
683      * on the return value: the return value is optional (but if data is returned, it must not be false).
684      * @param token The token targeted by the call.
685      * @param data The call data (encoded using abi.encode or one of its variants).
686      */
687     function _callOptionalReturn(IERC20 token, bytes memory data) private {
688         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
689         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
690         // the target address contains contract code and also asserts for success in the low-level call.
691 
692         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
693         if (returndata.length > 0) { // Return data is optional
694             // solhint-disable-next-line max-line-length
695             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
696         }
697     }
698 }
699 
700 /**
701  * @dev Wrappers over Solidity's arithmetic operations with added overflow
702  * checks.
703  *
704  * Arithmetic operations in Solidity wrap on overflow. This can easily result
705  * in bugs, because programmers usually assume that an overflow raises an
706  * error, which is the standard behavior in high level programming languages.
707  * `SafeMath` restores this intuition by reverting the transaction when an
708  * operation overflows.
709  *
710  * Using this library instead of the unchecked operations eliminates an entire
711  * class of bugs, so it's recommended to use it always.
712  */
713 library SafeMath {
714     /**
715      * @dev Returns the addition of two unsigned integers, reverting on
716      * overflow.
717      *
718      * Counterpart to Solidity's `+` operator.
719      *
720      * Requirements:
721      *
722      * - Addition cannot overflow.
723      */
724     function add(uint256 a, uint256 b) internal pure returns (uint256) {
725         uint256 c = a + b;
726         require(c >= a, "SafeMath: addition overflow");
727 
728         return c;
729     }
730 
731     /**
732      * @dev Returns the subtraction of two unsigned integers, reverting on
733      * overflow (when the result is negative).
734      *
735      * Counterpart to Solidity's `-` operator.
736      *
737      * Requirements:
738      *
739      * - Subtraction cannot overflow.
740      */
741     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
742         return sub(a, b, "SafeMath: subtraction overflow");
743     }
744 
745     /**
746      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
747      * overflow (when the result is negative).
748      *
749      * Counterpart to Solidity's `-` operator.
750      *
751      * Requirements:
752      *
753      * - Subtraction cannot overflow.
754      */
755     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
756         require(b <= a, errorMessage);
757         uint256 c = a - b;
758 
759         return c;
760     }
761 
762     /**
763      * @dev Returns the multiplication of two unsigned integers, reverting on
764      * overflow.
765      *
766      * Counterpart to Solidity's `*` operator.
767      *
768      * Requirements:
769      *
770      * - Multiplication cannot overflow.
771      */
772     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
773         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
774         // benefit is lost if 'b' is also tested.
775         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
776         if (a == 0) {
777             return 0;
778         }
779 
780         uint256 c = a * b;
781         require(c / a == b, "SafeMath: multiplication overflow");
782 
783         return c;
784     }
785 
786     /**
787      * @dev Returns the integer division of two unsigned integers. Reverts on
788      * division by zero. The result is rounded towards zero.
789      *
790      * Counterpart to Solidity's `/` operator. Note: this function uses a
791      * `revert` opcode (which leaves remaining gas untouched) while Solidity
792      * uses an invalid opcode to revert (consuming all remaining gas).
793      *
794      * Requirements:
795      *
796      * - The divisor cannot be zero.
797      */
798     function div(uint256 a, uint256 b) internal pure returns (uint256) {
799         return div(a, b, "SafeMath: division by zero");
800     }
801 
802     /**
803      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
804      * division by zero. The result is rounded towards zero.
805      *
806      * Counterpart to Solidity's `/` operator. Note: this function uses a
807      * `revert` opcode (which leaves remaining gas untouched) while Solidity
808      * uses an invalid opcode to revert (consuming all remaining gas).
809      *
810      * Requirements:
811      *
812      * - The divisor cannot be zero.
813      */
814     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
815         require(b > 0, errorMessage);
816         uint256 c = a / b;
817         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
818 
819         return c;
820     }
821 
822     /**
823      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
824      * Reverts when dividing by zero.
825      *
826      * Counterpart to Solidity's `%` operator. This function uses a `revert`
827      * opcode (which leaves remaining gas untouched) while Solidity uses an
828      * invalid opcode to revert (consuming all remaining gas).
829      *
830      * Requirements:
831      *
832      * - The divisor cannot be zero.
833      */
834     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
835         return mod(a, b, "SafeMath: modulo by zero");
836     }
837 
838     /**
839      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
840      * Reverts with custom message when dividing by zero.
841      *
842      * Counterpart to Solidity's `%` operator. This function uses a `revert`
843      * opcode (which leaves remaining gas untouched) while Solidity uses an
844      * invalid opcode to revert (consuming all remaining gas).
845      *
846      * Requirements:
847      *
848      * - The divisor cannot be zero.
849      */
850     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
851         require(b != 0, errorMessage);
852         return a % b;
853     }
854 }
855 
856 // PubToken
857 contract PubToken is ERC20("PUB.finance","PUB"), Ownable {
858 
859     /// @notice Creates `_amount` token to `_to`. Must only be called by the owner (Bartender).
860     function mint(address _to, uint256 _amount) public onlyOwner {
861         _mint(_to, _amount);
862     }
863 }