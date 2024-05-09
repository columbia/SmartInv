1 // SPDX-License-Identifier: GPL-3.0
2 
3 pragma solidity ^0.6.0;
4 
5 abstract contract Context {
6     function _msgSender() internal view virtual returns (address payable) {
7         return msg.sender;
8     }
9 
10     function _msgData() internal view virtual returns (bytes memory) {
11         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
12         return msg.data;
13     }
14 }
15 
16 abstract contract ReentrancyGuard {
17     // Booleans are more expensive than uint256 or any type that takes up a full
18     // word because each write operation emits an extra SLOAD to first read the
19     // slot's contents, replace the bits taken up by the boolean, and then write
20     // back. This is the compiler's defense against contract upgrades and
21     // pointer aliasing, and it cannot be disabled.
22 
23     // The values being non-zero value makes deployment a bit more expensive,
24     // but in exchange the refund on every call to nonReentrant will be lower in
25     // amount. Since refunds are capped to a percentage of the total
26     // transaction's gas, it is best to keep them low in cases like this one, to
27     // increase the likelihood of the full refund coming into effect.
28     uint256 private constant _NOT_ENTERED = 1;
29     uint256 private constant _ENTERED = 2;
30 
31     uint256 private _status;
32 
33     constructor () internal {
34         _status = _NOT_ENTERED;
35     }
36 
37     /**
38      * @dev Prevents a contract from calling itself, directly or indirectly.
39      * Calling a `nonReentrant` function from another `nonReentrant`
40      * function is not supported. It is possible to prevent this from happening
41      * by making the `nonReentrant` function external, and make it call a
42      * `private` function that does the actual work.
43      */
44     modifier nonReentrant() {
45         // On the first call to nonReentrant, _notEntered will be true
46         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
47 
48         // Any calls to nonReentrant after this point will fail
49         _status = _ENTERED;
50 
51         _;
52 
53         // By storing the original value once again, a refund is triggered (see
54         // https://eips.ethereum.org/EIPS/eip-2200)
55         _status = _NOT_ENTERED;
56     }
57 }
58 
59 library Address {
60     /**
61      * @dev Returns true if `account` is a contract.
62      *
63      * [IMPORTANT]
64      * ====
65      * It is unsafe to assume that an address for which this function returns
66      * false is an externally-owned account (EOA) and not a contract.
67      *
68      * Among others, `isContract` will return false for the following
69      * types of addresses:
70      *
71      *  - an externally-owned account
72      *  - a contract in construction
73      *  - an address where a contract will be created
74      *  - an address where a contract lived, but was destroyed
75      * ====
76      */
77     function isContract(address account) internal view returns (bool) {
78         // This method relies on extcodesize, which returns 0 for contracts in
79         // construction, since the code is only stored at the end of the
80         // constructor execution.
81 
82         uint256 size;
83         // solhint-disable-next-line no-inline-assembly
84         assembly { size := extcodesize(account) }
85         return size > 0;
86     }
87 
88     /**
89      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
90      * `recipient`, forwarding all available gas and reverting on errors.
91      *
92      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
93      * of certain opcodes, possibly making contracts go over the 2300 gas limit
94      * imposed by `transfer`, making them unable to receive funds via
95      * `transfer`. {sendValue} removes this limitation.
96      *
97      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
98      *
99      * IMPORTANT: because control is transferred to `recipient`, care must be
100      * taken to not create reentrancy vulnerabilities. Consider using
101      * {ReentrancyGuard} or the
102      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
103      */
104     function sendValue(address payable recipient, uint256 amount) internal {
105         require(address(this).balance >= amount, "Address: insufficient balance");
106 
107         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
108         (bool success, ) = recipient.call{ value: amount }("");
109         require(success, "Address: unable to send value, recipient may have reverted");
110     }
111 
112     /**
113      * @dev Performs a Solidity function call using a low level `call`. A
114      * plain`call` is an unsafe replacement for a function call: use this
115      * function instead.
116      *
117      * If `target` reverts with a revert reason, it is bubbled up by this
118      * function (like regular Solidity function calls).
119      *
120      * Returns the raw returned data. To convert to the expected return value,
121      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
122      *
123      * Requirements:
124      *
125      * - `target` must be a contract.
126      * - calling `target` with `data` must not revert.
127      *
128      * _Available since v3.1._
129      */
130     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
131       return functionCall(target, data, "Address: low-level call failed");
132     }
133 
134     /**
135      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
136      * `errorMessage` as a fallback revert reason when `target` reverts.
137      *
138      * _Available since v3.1._
139      */
140     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
141         return functionCallWithValue(target, data, 0, errorMessage);
142     }
143 
144     /**
145      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
146      * but also transferring `value` wei to `target`.
147      *
148      * Requirements:
149      *
150      * - the calling contract must have an ETH balance of at least `value`.
151      * - the called Solidity function must be `payable`.
152      *
153      * _Available since v3.1._
154      */
155     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
156         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
157     }
158 
159     /**
160      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
161      * with `errorMessage` as a fallback revert reason when `target` reverts.
162      *
163      * _Available since v3.1._
164      */
165     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
166         require(address(this).balance >= value, "Address: insufficient balance for call");
167         require(isContract(target), "Address: call to non-contract");
168 
169         // solhint-disable-next-line avoid-low-level-calls
170         (bool success, bytes memory returndata) = target.call{ value: value }(data);
171         return _verifyCallResult(success, returndata, errorMessage);
172     }
173 
174     /**
175      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
176      * but performing a static call.
177      *
178      * _Available since v3.3._
179      */
180     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
181         return functionStaticCall(target, data, "Address: low-level static call failed");
182     }
183 
184     /**
185      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
186      * but performing a static call.
187      *
188      * _Available since v3.3._
189      */
190     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
191         require(isContract(target), "Address: static call to non-contract");
192 
193         // solhint-disable-next-line avoid-low-level-calls
194         (bool success, bytes memory returndata) = target.staticcall(data);
195         return _verifyCallResult(success, returndata, errorMessage);
196     }
197 
198     /**
199      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
200      * but performing a delegate call.
201      *
202      * _Available since v3.4._
203      */
204     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
205         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
206     }
207 
208     /**
209      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
210      * but performing a delegate call.
211      *
212      * _Available since v3.4._
213      */
214     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
215         require(isContract(target), "Address: delegate call to non-contract");
216 
217         // solhint-disable-next-line avoid-low-level-calls
218         (bool success, bytes memory returndata) = target.delegatecall(data);
219         return _verifyCallResult(success, returndata, errorMessage);
220     }
221 
222     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
223         if (success) {
224             return returndata;
225         } else {
226             // Look for revert reason and bubble it up if present
227             if (returndata.length > 0) {
228                 // The easiest way to bubble the revert reason is using memory via assembly
229 
230                 // solhint-disable-next-line no-inline-assembly
231                 assembly {
232                     let returndata_size := mload(returndata)
233                     revert(add(32, returndata), returndata_size)
234                 }
235             } else {
236                 revert(errorMessage);
237             }
238         }
239     }
240 }
241 
242 library SafeERC20 {
243     using SafeMath for uint256;
244     using Address for address;
245 
246     function safeTransfer(IERC20 token, address to, uint256 value) internal {
247         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
248     }
249 
250     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
251         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
252     }
253 
254     /**
255      * @dev Deprecated. This function has issues similar to the ones found in
256      * {IERC20-approve}, and its usage is discouraged.
257      *
258      * Whenever possible, use {safeIncreaseAllowance} and
259      * {safeDecreaseAllowance} instead.
260      */
261     function safeApprove(IERC20 token, address spender, uint256 value) internal {
262         // safeApprove should only be called when setting an initial allowance,
263         // or when resetting it to zero. To increase and decrease it, use
264         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
265         // solhint-disable-next-line max-line-length
266         require((value == 0) || (token.allowance(address(this), spender) == 0),
267             "SafeERC20: approve from non-zero to non-zero allowance"
268         );
269         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
270     }
271 
272     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
273         uint256 newAllowance = token.allowance(address(this), spender).add(value);
274         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
275     }
276 
277     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
278         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
279         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
280     }
281 
282     /**
283      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
284      * on the return value: the return value is optional (but if data is returned, it must not be false).
285      * @param token The token targeted by the call.
286      * @param data The call data (encoded using abi.encode or one of its variants).
287      */
288     function _callOptionalReturn(IERC20 token, bytes memory data) private {
289         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
290         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
291         // the target address contains contract code and also asserts for success in the low-level call.
292 
293         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
294         if (returndata.length > 0) { // Return data is optional
295             // solhint-disable-next-line max-line-length
296             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
297         }
298     }
299 }
300 
301 abstract contract Ownable is Context {
302     address private _owner;
303 
304     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
305 
306     /**
307      * @dev Initializes the contract setting the deployer as the initial owner.
308      */
309     constructor () internal {
310         address msgSender = _msgSender();
311         _owner = msgSender;
312         emit OwnershipTransferred(address(0), msgSender);
313     }
314 
315     /**
316      * @dev Returns the address of the current owner.
317      */
318     function owner() public view virtual returns (address) {
319         return _owner;
320     }
321 
322     /**
323      * @dev Throws if called by any account other than the owner.
324      */
325     modifier onlyOwner() {
326         require(owner() == _msgSender(), "Ownable: caller is not the owner");
327         _;
328     }
329 
330     /**
331      * @dev Leaves the contract without owner. It will not be possible to call
332      * `onlyOwner` functions anymore. Can only be called by the current owner.
333      *
334      * NOTE: Renouncing ownership will leave the contract without an owner,
335      * thereby removing any functionality that is only available to the owner.
336      */
337     function renounceOwnership() public virtual onlyOwner {
338         emit OwnershipTransferred(_owner, address(0));
339         _owner = address(0);
340     }
341 
342     /**
343      * @dev Transfers ownership of the contract to a new account (`newOwner`).
344      * Can only be called by the current owner.
345      */
346     function transferOwnership(address newOwner) public virtual onlyOwner {
347         require(newOwner != address(0), "Ownable: new owner is the zero address");
348         emit OwnershipTransferred(_owner, newOwner);
349         _owner = newOwner;
350     }
351 }
352 
353 interface IERC20 {
354     /**
355      * @dev Returns the amount of tokens in existence.
356      */
357     function totalSupply() external view returns (uint256);
358 
359     /**
360      * @dev Returns the amount of tokens owned by `account`.
361      */
362     function balanceOf(address account) external view returns (uint256);
363 
364     /**
365      * @dev Moves `amount` tokens from the caller's account to `recipient`.
366      *
367      * Returns a boolean value indicating whether the operation succeeded.
368      *
369      * Emits a {Transfer} event.
370      */
371     function transfer(address recipient, uint256 amount) external returns (bool);
372 
373     /**
374      * @dev Returns the remaining number of tokens that `spender` will be
375      * allowed to spend on behalf of `owner` through {transferFrom}. This is
376      * zero by default.
377      *
378      * This value changes when {approve} or {transferFrom} are called.
379      */
380     function allowance(address owner, address spender) external view returns (uint256);
381 
382     /**
383      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
384      *
385      * Returns a boolean value indicating whether the operation succeeded.
386      *
387      * IMPORTANT: Beware that changing an allowance with this method brings the risk
388      * that someone may use both the old and the new allowance by unfortunate
389      * transaction ordering. One possible solution to mitigate this race
390      * condition is to first reduce the spender's allowance to 0 and set the
391      * desired value afterwards:
392      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
393      *
394      * Emits an {Approval} event.
395      */
396     function approve(address spender, uint256 amount) external returns (bool);
397 
398     /**
399      * @dev Moves `amount` tokens from `sender` to `recipient` using the
400      * allowance mechanism. `amount` is then deducted from the caller's
401      * allowance.
402      *
403      * Returns a boolean value indicating whether the operation succeeded.
404      *
405      * Emits a {Transfer} event.
406      */
407     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
408 
409     /**
410      * @dev Emitted when `value` tokens are moved from one account (`from`) to
411      * another (`to`).
412      *
413      * Note that `value` may be zero.
414      */
415     event Transfer(address indexed from, address indexed to, uint256 value);
416 
417     /**
418      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
419      * a call to {approve}. `value` is the new allowance.
420      */
421     event Approval(address indexed owner, address indexed spender, uint256 value);
422 }
423 
424 contract ERC20 is Context, IERC20 {
425     using SafeMath for uint256;
426 
427     mapping (address => uint256) private _balances;
428 
429     mapping (address => mapping (address => uint256)) private _allowances;
430 
431     uint256 private _totalSupply;
432 
433     string private _name;
434     string private _symbol;
435     uint8 private _decimals;
436 
437     /**
438      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
439      * a default value of 18.
440      *
441      * To select a different value for {decimals}, use {_setupDecimals}.
442      *
443      * All three of these values are immutable: they can only be set once during
444      * construction.
445      */
446     constructor (string memory name_, string memory symbol_) public {
447         _name = name_;
448         _symbol = symbol_;
449         _decimals = 18;
450     }
451 
452     /**
453      * @dev Returns the name of the token.
454      */
455     function name() public view virtual returns (string memory) {
456         return _name;
457     }
458 
459     /**
460      * @dev Returns the symbol of the token, usually a shorter version of the
461      * name.
462      */
463     function symbol() public view virtual returns (string memory) {
464         return _symbol;
465     }
466 
467     /**
468      * @dev Returns the number of decimals used to get its user representation.
469      * For example, if `decimals` equals `2`, a balance of `505` tokens should
470      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
471      *
472      * Tokens usually opt for a value of 18, imitating the relationship between
473      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
474      * called.
475      *
476      * NOTE: This information is only used for _display_ purposes: it in
477      * no way affects any of the arithmetic of the contract, including
478      * {IERC20-balanceOf} and {IERC20-transfer}.
479      */
480     function decimals() public view virtual returns (uint8) {
481         return _decimals;
482     }
483 
484     /**
485      * @dev See {IERC20-totalSupply}.
486      */
487     function totalSupply() public view virtual override returns (uint256) {
488         return _totalSupply;
489     }
490 
491     /**
492      * @dev See {IERC20-balanceOf}.
493      */
494     function balanceOf(address account) public view virtual override returns (uint256) {
495         return _balances[account];
496     }
497 
498     /**
499      * @dev See {IERC20-transfer}.
500      *
501      * Requirements:
502      *
503      * - `recipient` cannot be the zero address.
504      * - the caller must have a balance of at least `amount`.
505      */
506     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
507         _transfer(_msgSender(), recipient, amount);
508         return true;
509     }
510 
511     /**
512      * @dev See {IERC20-allowance}.
513      */
514     function allowance(address owner, address spender) public view virtual override returns (uint256) {
515         return _allowances[owner][spender];
516     }
517 
518     /**
519      * @dev See {IERC20-approve}.
520      *
521      * Requirements:
522      *
523      * - `spender` cannot be the zero address.
524      */
525     function approve(address spender, uint256 amount) public virtual override returns (bool) {
526         _approve(_msgSender(), spender, amount);
527         return true;
528     }
529 
530     /**
531      * @dev See {IERC20-transferFrom}.
532      *
533      * Emits an {Approval} event indicating the updated allowance. This is not
534      * required by the EIP. See the note at the beginning of {ERC20}.
535      *
536      * Requirements:
537      *
538      * - `sender` and `recipient` cannot be the zero address.
539      * - `sender` must have a balance of at least `amount`.
540      * - the caller must have allowance for ``sender``'s tokens of at least
541      * `amount`.
542      */
543     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
544         _transfer(sender, recipient, amount);
545         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
546         return true;
547     }
548 
549     /**
550      * @dev Atomically increases the allowance granted to `spender` by the caller.
551      *
552      * This is an alternative to {approve} that can be used as a mitigation for
553      * problems described in {IERC20-approve}.
554      *
555      * Emits an {Approval} event indicating the updated allowance.
556      *
557      * Requirements:
558      *
559      * - `spender` cannot be the zero address.
560      */
561     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
562         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
563         return true;
564     }
565 
566     /**
567      * @dev Atomically decreases the allowance granted to `spender` by the caller.
568      *
569      * This is an alternative to {approve} that can be used as a mitigation for
570      * problems described in {IERC20-approve}.
571      *
572      * Emits an {Approval} event indicating the updated allowance.
573      *
574      * Requirements:
575      *
576      * - `spender` cannot be the zero address.
577      * - `spender` must have allowance for the caller of at least
578      * `subtractedValue`.
579      */
580     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
581         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
582         return true;
583     }
584 
585     /**
586      * @dev Moves tokens `amount` from `sender` to `recipient`.
587      *
588      * This is internal function is equivalent to {transfer}, and can be used to
589      * e.g. implement automatic token fees, slashing mechanisms, etc.
590      *
591      * Emits a {Transfer} event.
592      *
593      * Requirements:
594      *
595      * - `sender` cannot be the zero address.
596      * - `recipient` cannot be the zero address.
597      * - `sender` must have a balance of at least `amount`.
598      */
599     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
600         require(sender != address(0), "ERC20: transfer from the zero address");
601         require(recipient != address(0), "ERC20: transfer to the zero address");
602 
603         _beforeTokenTransfer(sender, recipient, amount);
604 
605         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
606         _balances[recipient] = _balances[recipient].add(amount);
607         emit Transfer(sender, recipient, amount);
608     }
609 
610     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
611      * the total supply.
612      *
613      * Emits a {Transfer} event with `from` set to the zero address.
614      *
615      * Requirements:
616      *
617      * - `to` cannot be the zero address.
618      */
619     function _mint(address account, uint256 amount) internal virtual {
620         require(account != address(0), "ERC20: mint to the zero address");
621 
622         _beforeTokenTransfer(address(0), account, amount);
623 
624         _totalSupply = _totalSupply.add(amount);
625         _balances[account] = _balances[account].add(amount);
626         emit Transfer(address(0), account, amount);
627     }
628 
629     /**
630      * @dev Destroys `amount` tokens from `account`, reducing the
631      * total supply.
632      *
633      * Emits a {Transfer} event with `to` set to the zero address.
634      *
635      * Requirements:
636      *
637      * - `account` cannot be the zero address.
638      * - `account` must have at least `amount` tokens.
639      */
640     function _burn(address account, uint256 amount) internal virtual {
641         require(account != address(0), "ERC20: burn from the zero address");
642 
643         _beforeTokenTransfer(account, address(0), amount);
644 
645         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
646         _totalSupply = _totalSupply.sub(amount);
647         emit Transfer(account, address(0), amount);
648     }
649 
650     /**
651      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
652      *
653      * This internal function is equivalent to `approve`, and can be used to
654      * e.g. set automatic allowances for certain subsystems, etc.
655      *
656      * Emits an {Approval} event.
657      *
658      * Requirements:
659      *
660      * - `owner` cannot be the zero address.
661      * - `spender` cannot be the zero address.
662      */
663     function _approve(address owner, address spender, uint256 amount) internal virtual {
664         require(owner != address(0), "ERC20: approve from the zero address");
665         require(spender != address(0), "ERC20: approve to the zero address");
666 
667         _allowances[owner][spender] = amount;
668         emit Approval(owner, spender, amount);
669     }
670 
671     /**
672      * @dev Sets {decimals} to a value other than the default one of 18.
673      *
674      * WARNING: This function should only be called from the constructor. Most
675      * applications that interact with token contracts will not expect
676      * {decimals} to ever change, and may work incorrectly if it does.
677      */
678     function _setupDecimals(uint8 decimals_) internal virtual {
679         _decimals = decimals_;
680     }
681 
682     /**
683      * @dev Hook that is called before any transfer of tokens. This includes
684      * minting and burning.
685      *
686      * Calling conditions:
687      *
688      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
689      * will be to transferred to `to`.
690      * - when `from` is zero, `amount` tokens will be minted for `to`.
691      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
692      * - `from` and `to` are never both zero.
693      *
694      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
695      */
696     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
697 }
698 
699 library SafeMath {
700     /**
701      * @dev Returns the addition of two unsigned integers, with an overflow flag.
702      *
703      * _Available since v3.4._
704      */
705     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
706         uint256 c = a + b;
707         if (c < a) return (false, 0);
708         return (true, c);
709     }
710 
711     /**
712      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
713      *
714      * _Available since v3.4._
715      */
716     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
717         if (b > a) return (false, 0);
718         return (true, a - b);
719     }
720 
721     /**
722      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
723      *
724      * _Available since v3.4._
725      */
726     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
727         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
728         // benefit is lost if 'b' is also tested.
729         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
730         if (a == 0) return (true, 0);
731         uint256 c = a * b;
732         if (c / a != b) return (false, 0);
733         return (true, c);
734     }
735 
736     /**
737      * @dev Returns the division of two unsigned integers, with a division by zero flag.
738      *
739      * _Available since v3.4._
740      */
741     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
742         if (b == 0) return (false, 0);
743         return (true, a / b);
744     }
745 
746     /**
747      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
748      *
749      * _Available since v3.4._
750      */
751     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
752         if (b == 0) return (false, 0);
753         return (true, a % b);
754     }
755 
756     /**
757      * @dev Returns the addition of two unsigned integers, reverting on
758      * overflow.
759      *
760      * Counterpart to Solidity's `+` operator.
761      *
762      * Requirements:
763      *
764      * - Addition cannot overflow.
765      */
766     function add(uint256 a, uint256 b) internal pure returns (uint256) {
767         uint256 c = a + b;
768         require(c >= a, "SafeMath: addition overflow");
769         return c;
770     }
771 
772     /**
773      * @dev Returns the subtraction of two unsigned integers, reverting on
774      * overflow (when the result is negative).
775      *
776      * Counterpart to Solidity's `-` operator.
777      *
778      * Requirements:
779      *
780      * - Subtraction cannot overflow.
781      */
782     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
783         require(b <= a, "SafeMath: subtraction overflow");
784         return a - b;
785     }
786 
787     /**
788      * @dev Returns the multiplication of two unsigned integers, reverting on
789      * overflow.
790      *
791      * Counterpart to Solidity's `*` operator.
792      *
793      * Requirements:
794      *
795      * - Multiplication cannot overflow.
796      */
797     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
798         if (a == 0) return 0;
799         uint256 c = a * b;
800         require(c / a == b, "SafeMath: multiplication overflow");
801         return c;
802     }
803 
804     /**
805      * @dev Returns the integer division of two unsigned integers, reverting on
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
816     function div(uint256 a, uint256 b) internal pure returns (uint256) {
817         require(b > 0, "SafeMath: division by zero");
818         return a / b;
819     }
820 
821     /**
822      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
823      * reverting when dividing by zero.
824      *
825      * Counterpart to Solidity's `%` operator. This function uses a `revert`
826      * opcode (which leaves remaining gas untouched) while Solidity uses an
827      * invalid opcode to revert (consuming all remaining gas).
828      *
829      * Requirements:
830      *
831      * - The divisor cannot be zero.
832      */
833     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
834         require(b > 0, "SafeMath: modulo by zero");
835         return a % b;
836     }
837 
838     /**
839      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
840      * overflow (when the result is negative).
841      *
842      * CAUTION: This function is deprecated because it requires allocating memory for the error
843      * message unnecessarily. For custom revert reasons use {trySub}.
844      *
845      * Counterpart to Solidity's `-` operator.
846      *
847      * Requirements:
848      *
849      * - Subtraction cannot overflow.
850      */
851     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
852         require(b <= a, errorMessage);
853         return a - b;
854     }
855 
856     /**
857      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
858      * division by zero. The result is rounded towards zero.
859      *
860      * CAUTION: This function is deprecated because it requires allocating memory for the error
861      * message unnecessarily. For custom revert reasons use {tryDiv}.
862      *
863      * Counterpart to Solidity's `/` operator. Note: this function uses a
864      * `revert` opcode (which leaves remaining gas untouched) while Solidity
865      * uses an invalid opcode to revert (consuming all remaining gas).
866      *
867      * Requirements:
868      *
869      * - The divisor cannot be zero.
870      */
871     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
872         require(b > 0, errorMessage);
873         return a / b;
874     }
875 
876     /**
877      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
878      * reverting with custom message when dividing by zero.
879      *
880      * CAUTION: This function is deprecated because it requires allocating memory for the error
881      * message unnecessarily. For custom revert reasons use {tryMod}.
882      *
883      * Counterpart to Solidity's `%` operator. This function uses a `revert`
884      * opcode (which leaves remaining gas untouched) while Solidity uses an
885      * invalid opcode to revert (consuming all remaining gas).
886      *
887      * Requirements:
888      *
889      * - The divisor cannot be zero.
890      */
891     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
892         require(b > 0, errorMessage);
893         return a % b;
894     }
895 }
896 
897 interface IO3 is IERC20 {
898     function getUnlockFactor(address token) external view returns (uint256);
899     function getUnlockBlockGap(address token) external view returns (uint256);
900 
901     function totalUnlocked() external view returns (uint256);
902     function unlockedOf(address account) external view returns (uint256);
903     function lockedOf(address account) external view returns (uint256);
904 
905     function getStaked(address token) external view returns (uint256);
906     function getUnlockSpeed(address staker, address token) external view returns (uint256);
907     function claimableUnlocked(address token) external view returns (uint256);
908 
909     function setUnlockFactor(address token, uint256 _factor) external;
910     function setUnlockBlockGap(address token, uint256 _blockGap) external;
911 
912     function stake(address token, uint256 amount) external returns (bool);
913     function unstake(address token, uint256 amount) external returns (bool);
914     function claimUnlocked(address token) external returns (bool);
915 
916     function setAuthorizedMintCaller(address caller) external;
917     function removeAuthorizedMintCaller(address caller) external;
918 
919     function mintUnlockedToken(address to, uint256 amount) external;
920     function mintLockedToken(address to, uint256 amount) external;
921 }
922 
923 contract O3 is Context, ERC20, Ownable, IO3, ReentrancyGuard {
924     using SafeMath for uint256;
925     using SafeERC20 for IERC20;
926 
927     struct LpStakeInfo {
928         uint256 amountStaked;
929         uint256 blockNumber;
930     }
931 
932     event LOG_UNLOCK_TRANSFER (
933         address indexed from,
934         address indexed to,
935         uint256 amount
936     );
937 
938     event LOG_STAKE (
939         address indexed staker,
940         address indexed token,
941         uint256 stakeAmount
942     );
943 
944     event LOG_UNSTAKE (
945         address indexed staker,
946         address indexed token,
947         uint256 unstakeAmount
948     );
949 
950     event LOG_CLAIM_UNLOCKED (
951         address indexed staker,
952         uint256 claimedAmount
953     );
954 
955     event LOG_SET_UNLOCK_FACTOR (
956         address indexed token,
957         uint256 factor
958     );
959 
960     event LOG_SET_UNLOCK_BLOCK_GAP (
961         address indexed token,
962         uint256 blockGap
963     );
964 
965     uint256 public constant FACTOR_DENOMINATOR = 10 ** 8;
966 
967     mapping (address => uint256) private _unlocks;
968     mapping (address => mapping(address => LpStakeInfo)) private _stakingRecords;
969     mapping (address => uint256) private _unlockFactor;
970     mapping (address => uint256) private _unlockBlockGap;
971     mapping (address => bool) private _authorizedMintCaller;
972 
973     uint256 private _totalUnlocked;
974 
975     modifier onlyAuthorizedMintCaller() {
976         require(_msgSender() == owner() || _authorizedMintCaller[_msgSender()],"O3: MINT_CALLER_NOT_AUTHORIZED");
977         _;
978     }
979 
980     constructor () public ERC20("O3 Swap Token", "O3") {}
981 
982     function getUnlockFactor(address token) external view override returns (uint256) {
983         return _unlockFactor[token];
984     }
985 
986     function getUnlockBlockGap(address token) external view override returns (uint256) {
987         return _unlockBlockGap[token];
988     }
989 
990     function totalUnlocked() external view override returns (uint256) {
991         return _totalUnlocked;
992     }
993 
994     function unlockedOf(address account) external view override returns (uint256) {
995         return _unlocks[account];
996     }
997 
998     function lockedOf(address account) public view override returns (uint256) {
999         return balanceOf(account).sub(_unlocks[account]);
1000     }
1001 
1002     function getStaked(address token) external view override returns (uint256) {
1003         return _stakingRecords[_msgSender()][token].amountStaked;
1004     }
1005 
1006     function getUnlockSpeed(address staker, address token) external view override returns (uint256) {
1007         LpStakeInfo storage info = _stakingRecords[staker][token];
1008         return _getUnlockSpeed(token, staker, info.amountStaked);
1009     }
1010 
1011     function claimableUnlocked(address token) external view override returns (uint256) {
1012         LpStakeInfo storage info = _stakingRecords[_msgSender()][token];
1013         return _settleUnlockAmount(_msgSender(), token, info.amountStaked, info.blockNumber);
1014     }
1015 
1016     function transfer(address recipient, uint256 amount) public override(ERC20, IERC20) returns (bool) {
1017         _transfer(_msgSender(), recipient, amount);
1018         _unlockTransfer(_msgSender(), recipient, amount);
1019         return true;
1020     }
1021 
1022     function transferFrom(address sender, address recipient, uint256 amount) public override(ERC20, IERC20) returns (bool) {
1023         _transfer(sender, recipient, amount);
1024         _unlockTransfer(sender, recipient, amount);
1025         uint256 allowance = allowance(sender, _msgSender());
1026         _approve(sender, _msgSender(), allowance.sub(amount, "O3: TRANSFER_AMOUNT_EXCEEDED"));
1027         return true;
1028     }
1029 
1030     function setUnlockFactor(address token, uint256 _factor) external override onlyOwner {
1031         _unlockFactor[token] = _factor;
1032         emit LOG_SET_UNLOCK_FACTOR(token, _factor);
1033     }
1034 
1035     function setUnlockBlockGap(address token, uint256 _blockGap) external override onlyOwner {
1036         _unlockBlockGap[token] = _blockGap;
1037         emit LOG_SET_UNLOCK_BLOCK_GAP(token, _blockGap);
1038     }
1039 
1040     function stake(address token, uint256 amount) external override nonReentrant returns (bool) {
1041         require(_unlockFactor[token] > 0, "O3: FACTOR_NOT_SET");
1042         require(_unlockBlockGap[token] > 0, "O3: BLOCK_GAP_NOT_SET");
1043         _pullToken(token, _msgSender(), amount);
1044         LpStakeInfo storage info = _stakingRecords[_msgSender()][token];
1045         uint256 unlockedAmount = _settleUnlockAmount(_msgSender(), token, info.amountStaked, info.blockNumber);
1046         _updateStakeRecord(_msgSender(), token, info.amountStaked.add(amount));
1047         _mintUnlocked(_msgSender(), unlockedAmount);
1048         emit LOG_STAKE(_msgSender(), token, amount);
1049         return true;
1050     }
1051 
1052     function unstake(address token, uint256 amount) external override nonReentrant returns (bool) {
1053         require(amount > 0, "O3: ZERO_UNSTAKE_AMOUNT");
1054         LpStakeInfo storage info = _stakingRecords[_msgSender()][token];
1055         require(amount <= info.amountStaked, "O3: UNSTAKE_AMOUNT_EXCEEDED");
1056         uint256 unlockedAmount = _settleUnlockAmount(_msgSender(), token, info.amountStaked, info.blockNumber);
1057         _updateStakeRecord(_msgSender(), token, info.amountStaked.sub(amount));
1058         _mintUnlocked(_msgSender(), unlockedAmount);
1059         _pushToken(token, _msgSender(), amount);
1060         emit LOG_UNSTAKE(_msgSender(), token, amount);
1061         return true;
1062     }
1063 
1064     function claimUnlocked(address token) external override nonReentrant returns (bool) {
1065         LpStakeInfo storage info = _stakingRecords[_msgSender()][token];
1066         uint256 unlockedAmount = _settleUnlockAmount(_msgSender(), token, info.amountStaked, info.blockNumber);
1067         _updateStakeRecord(_msgSender(), token, info.amountStaked);
1068         _mintUnlocked(_msgSender(), unlockedAmount);
1069         emit LOG_CLAIM_UNLOCKED(_msgSender(), unlockedAmount);
1070         return true;
1071     }
1072 
1073     function _updateStakeRecord(address staker, address token, uint256 _amountStaked) internal {
1074         _stakingRecords[staker][token].amountStaked = _amountStaked;
1075         _stakingRecords[staker][token].blockNumber = block.number;
1076     }
1077 
1078     function mintUnlockedToken(address to, uint256 amount) onlyAuthorizedMintCaller external override {
1079         _mint(to, amount);
1080         _mintUnlocked(to, amount);
1081         require(totalSupply() <= 10**26, "O3: TOTAL_SUPPLY_EXCEEDED");
1082     }
1083 
1084     function mintLockedToken(address to, uint256 amount) onlyAuthorizedMintCaller external override {
1085         _mint(to, amount);
1086         require(totalSupply() <= 10**26, "O3: TOTAL_SUPPLY_EXCEEDED");
1087     }
1088 
1089     function setAuthorizedMintCaller(address caller) onlyOwner external override {
1090         _authorizedMintCaller[caller] = true;
1091     }
1092 
1093     function removeAuthorizedMintCaller(address caller) onlyOwner external override {
1094         _authorizedMintCaller[caller] = false;
1095     }
1096 
1097     function _settleUnlockAmount(address staker, address token, uint256 lpStaked, uint256 upToBlockNumber) internal view returns (uint256) {
1098         uint256 unlockSpeed = _getUnlockSpeed(token, staker, lpStaked);
1099         uint256 blocks = block.number.sub(upToBlockNumber);
1100         uint256 unlockedAmount = unlockSpeed.mul(blocks).div(FACTOR_DENOMINATOR);
1101         uint256 lockedAmount = lockedOf(staker);
1102         if (unlockedAmount > lockedAmount) {
1103             unlockedAmount = lockedAmount;
1104         }
1105         return unlockedAmount;
1106     }
1107 
1108     function _mintUnlocked(address recipient, uint256 amount) internal {
1109         _unlocks[recipient] = _unlocks[recipient].add(amount);
1110         _totalUnlocked = _totalUnlocked.add(amount);
1111         emit LOG_UNLOCK_TRANSFER(address(0), recipient, amount);
1112     }
1113 
1114     function _getUnlockSpeed(address token, address staker, uint256 lpStaked) internal view returns (uint256) {
1115         uint256 toBeUnlocked = lockedOf(staker);
1116         uint256 unlockSpeed = _unlockFactor[token].mul(lpStaked);
1117         uint256 maxUnlockSpeed = toBeUnlocked.mul(FACTOR_DENOMINATOR).div(_unlockBlockGap[token]);
1118         if(unlockSpeed > maxUnlockSpeed) {
1119             unlockSpeed = maxUnlockSpeed;
1120         }
1121         return unlockSpeed;
1122     }
1123 
1124     function _unlockTransfer(address sender, address recipient, uint256 amount) internal {
1125         require(sender != address(0), "ERC20: transfer from the zero address");
1126         require(recipient != address(0), "ERC20: transfer to the zero address");
1127         _unlocks[sender] = _unlocks[sender].sub(amount, "ERC20: transfer amount exceeds unlocked balance");
1128         _unlocks[recipient] = _unlocks[recipient].add(amount);
1129         emit LOG_UNLOCK_TRANSFER(sender, recipient, amount);
1130     }
1131 
1132     function _pullToken(address token, address from, uint256 amount) internal {
1133         IERC20(token).safeTransferFrom(from, address(this), amount);
1134     }
1135 
1136     function _pushToken(address token, address to, uint256 amount) internal {
1137         IERC20(token).safeTransfer(to, amount);
1138     }
1139 }