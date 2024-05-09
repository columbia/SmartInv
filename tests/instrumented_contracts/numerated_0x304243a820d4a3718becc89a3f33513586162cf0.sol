1 pragma solidity 0.8.11;
2 //SPDX-License-Identifier: none
3 
4 interface IERC20 {
5 
6     function totalSupply() external view returns (uint256);
7 
8     function balanceOf(address account) external view returns (uint256);
9 
10     function transfer(address recipient, uint256 amount) external returns (bool);
11 
12     function allowance(address owner, address spender) external view returns (uint256);
13 
14     function approve(address spender, uint256 amount) external returns (bool);
15 
16     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
17 
18     event Transfer(address indexed from, address indexed to, uint256 value);
19 
20     event Approval(address indexed owner, address indexed spender, uint256 value);
21 }
22 
23 interface IERC20Metadata is IERC20 {
24     /**
25      * @dev Returns the name of the token.
26      */
27     function name() external view returns (string memory);
28 
29     /**
30      * @dev Returns the symbol of the token.
31      */
32     function symbol() external view returns (string memory);
33 
34     /**
35      * @dev Returns the decimals places of the token.
36      */
37     function decimals() external view returns (uint8);
38 }
39 
40 abstract contract Context {
41     function _msgSender() internal view virtual returns (address payable) {
42         return payable(msg.sender);
43     }
44 
45     function _msgData() internal view virtual returns (bytes memory) {
46         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
47         return msg.data;
48     }
49 }
50 
51 contract ERC20 is Context, IERC20, IERC20Metadata {
52     mapping(address => uint256) private _balances;
53 
54     mapping(address => mapping(address => uint256)) private _allowances;
55 
56     uint256 private _totalSupply;
57 
58     string private _name;
59     string private _symbol;
60 
61     /**
62      * @dev Sets the values for {name} and {symbol}.
63      *
64      * The default value of {decimals} is 18. To select a different value for
65      * {decimals} you should overload it.
66      *
67      * All two of these values are immutable: they can only be set once during
68      * construction.
69      */
70     constructor(string memory name_, string memory symbol_) {
71         _name = name_;
72         _symbol = symbol_;
73     }
74 
75     /**
76      * @dev Returns the name of the token.
77      */
78     function name() public view virtual override returns (string memory) {
79         return _name;
80     }
81 
82     /**
83      * @dev Returns the symbol of the token, usually a shorter version of the
84      * name.
85      */
86     function symbol() public view virtual override returns (string memory) {
87         return _symbol;
88     }
89 
90     /**
91      * @dev Returns the number of decimals used to get its user representation.
92      * For example, if `decimals` equals `2`, a balance of `505` tokens should
93      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
94      *
95      * Tokens usually opt for a value of 18, imitating the relationship between
96      * Ether and Wei. This is the value {ERC20} uses, unless this function is
97      * overridden;
98      *
99      * NOTE: This information is only used for _display_ purposes: it in
100      * no way affects any of the arithmetic of the contract, including
101      * {IERC20-balanceOf} and {IERC20-transfer}.
102      */
103     function decimals() public view virtual override returns (uint8) {
104         return 18;
105     }
106 
107     /**
108      * @dev See {IERC20-totalSupply}.
109      */
110     function totalSupply() public view virtual override returns (uint256) {
111         return _totalSupply;
112     }
113 
114     /**
115      * @dev See {IERC20-balanceOf}.
116      */
117     function balanceOf(address account) public view virtual override returns (uint256) {
118         return _balances[account];
119     }
120 
121     /**
122      * @dev See {IERC20-transfer}.
123      *
124      * Requirements:
125      *
126      * - `recipient` cannot be the zero address.
127      * - the caller must have a balance of at least `amount`.
128      */
129     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
130         _transfer(_msgSender(), recipient, amount);
131         return true;
132     }
133 
134     /**
135      * @dev See {IERC20-allowance}.
136      */
137     function allowance(address owner, address spender) public view virtual override returns (uint256) {
138         return _allowances[owner][spender];
139     }
140 
141     /**
142      * @dev See {IERC20-approve}.
143      *
144      * Requirements:
145      *
146      * - `spender` cannot be the zero address.
147      */
148     function approve(address spender, uint256 amount) public virtual override returns (bool) {
149         _approve(_msgSender(), spender, amount);
150         return true;
151     }
152 
153     /**
154      * @dev See {IERC20-transferFrom}.
155      *
156      * Emits an {Approval} event indicating the updated allowance. This is not
157      * required by the EIP. See the note at the beginning of {ERC20}.
158      *
159      * Requirements:
160      *
161      * - `sender` and `recipient` cannot be the zero address.
162      * - `sender` must have a balance of at least `amount`.
163      * - the caller must have allowance for ``sender``'s tokens of at least
164      * `amount`.
165      */
166     function transferFrom(
167         address sender,
168         address recipient,
169         uint256 amount
170     ) public virtual override returns (bool) {
171         _transfer(sender, recipient, amount);
172 
173         uint256 currentAllowance = _allowances[sender][_msgSender()];
174         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
175         unchecked {
176             _approve(sender, _msgSender(), currentAllowance - amount);
177         }
178 
179         return true;
180     }
181 
182     /**
183      * @dev Atomically increases the allowance granted to `spender` by the caller.
184      *
185      * This is an alternative to {approve} that can be used as a mitigation for
186      * problems described in {IERC20-approve}.
187      *
188      * Emits an {Approval} event indicating the updated allowance.
189      *
190      * Requirements:
191      *
192      * - `spender` cannot be the zero address.
193      */
194     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
195         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
196         return true;
197     }
198 
199     /**
200      * @dev Atomically decreases the allowance granted to `spender` by the caller.
201      *
202      * This is an alternative to {approve} that can be used as a mitigation for
203      * problems described in {IERC20-approve}.
204      *
205      * Emits an {Approval} event indicating the updated allowance.
206      *
207      * Requirements:
208      *
209      * - `spender` cannot be the zero address.
210      * - `spender` must have allowance for the caller of at least
211      * `subtractedValue`.
212      */
213     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
214         uint256 currentAllowance = _allowances[_msgSender()][spender];
215         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
216         unchecked {
217             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
218         }
219 
220         return true;
221     }
222 
223     /**
224      * @dev Moves `amount` of tokens from `sender` to `recipient`.
225      *
226      * This internal function is equivalent to {transfer}, and can be used to
227      * e.g. implement automatic token fees, slashing mechanisms, etc.
228      *
229      * Emits a {Transfer} event.
230      *
231      * Requirements:
232      *
233      * - `sender` cannot be the zero address.
234      * - `recipient` cannot be the zero address.
235      * - `sender` must have a balance of at least `amount`.
236      */
237     function _transfer(
238         address sender,
239         address recipient,
240         uint256 amount
241     ) internal virtual {
242         require(sender != address(0), "ERC20: transfer from the zero address");
243         require(recipient != address(0), "ERC20: transfer to the zero address");
244 
245         _beforeTokenTransfer(sender, recipient, amount);
246 
247         uint256 senderBalance = _balances[sender];
248         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
249         unchecked {
250             _balances[sender] = senderBalance - amount;
251         }
252         _balances[recipient] += amount;
253 
254         emit Transfer(sender, recipient, amount);
255 
256         _afterTokenTransfer(sender, recipient, amount);
257     }
258 
259     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
260      * the total supply.
261      *
262      * Emits a {Transfer} event with `from` set to the zero address.
263      *
264      * Requirements:
265      *
266      * - `account` cannot be the zero address.
267      */
268     function _mint(address account, uint256 amount) internal virtual {
269         require(account != address(0), "ERC20: mint to the zero address");
270 
271         _beforeTokenTransfer(address(0), account, amount);
272 
273         _totalSupply += amount;
274         _balances[account] += amount;
275         emit Transfer(address(0), account, amount);
276 
277         _afterTokenTransfer(address(0), account, amount);
278     }
279 
280     /**
281      * @dev Destroys `amount` tokens from `account`, reducing the
282      * total supply.
283      *
284      * Emits a {Transfer} event with `to` set to the zero address.
285      *
286      * Requirements:
287      *
288      * - `account` cannot be the zero address.
289      * - `account` must have at least `amount` tokens.
290      */
291     function _burn(address account, uint256 amount) internal virtual {
292         require(account != address(0), "ERC20: burn from the zero address");
293 
294         _beforeTokenTransfer(account, address(0), amount);
295 
296         uint256 accountBalance = _balances[account];
297         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
298         unchecked {
299             _balances[account] = accountBalance - amount;
300         }
301         _totalSupply -= amount;
302 
303         emit Transfer(account, address(0), amount);
304 
305         _afterTokenTransfer(account, address(0), amount);
306     }
307 
308     /**
309      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
310      *
311      * This internal function is equivalent to `approve`, and can be used to
312      * e.g. set automatic allowances for certain subsystems, etc.
313      *
314      * Emits an {Approval} event.
315      *
316      * Requirements:
317      *
318      * - `owner` cannot be the zero address.
319      * - `spender` cannot be the zero address.
320      */
321     function _approve(
322         address owner,
323         address spender,
324         uint256 amount
325     ) internal virtual {
326         require(owner != address(0), "ERC20: approve from the zero address");
327         require(spender != address(0), "ERC20: approve to the zero address");
328 
329         _allowances[owner][spender] = amount;
330         emit Approval(owner, spender, amount);
331     }
332 
333     /**
334      * @dev Hook that is called before any transfer of tokens. This includes
335      * minting and burning.
336      *
337      * Calling conditions:
338      *
339      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
340      * will be transferred to `to`.
341      * - when `from` is zero, `amount` tokens will be minted for `to`.
342      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
343      * - `from` and `to` are never both zero.
344      *
345      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
346      */
347     function _beforeTokenTransfer(
348         address from,
349         address to,
350         uint256 amount
351     ) internal virtual {}
352 
353     /**
354      * @dev Hook that is called after any transfer of tokens. This includes
355      * minting and burning.
356      *
357      * Calling conditions:
358      *
359      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
360      * has been transferred to `to`.
361      * - when `from` is zero, `amount` tokens have been minted for `to`.
362      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
363      * - `from` and `to` are never both zero.
364      *
365      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
366      */
367     function _afterTokenTransfer(
368         address from,
369         address to,
370         uint256 amount
371     ) internal virtual {}
372 }
373 
374 library Address {
375     /**
376      * @dev Returns true if `account` is a contract.
377      *
378      * [IMPORTANT]
379      * ====
380      * It is unsafe to assume that an address for which this function returns
381      * false is an externally-owned account (EOA) and not a contract.
382      *
383      * Among others, `isContract` will return false for the following
384      * types of addresses:
385      *
386      *  - an externally-owned account
387      *  - a contract in construction
388      *  - an address where a contract will be created
389      *  - an address where a contract lived, but was destroyed
390      * ====
391      */
392     function isContract(address account) internal view returns (bool) {
393         // This method relies on extcodesize, which returns 0 for contracts in
394         // construction, since the code is only stored at the end of the
395         // constructor execution.
396 
397         uint256 size;
398         assembly {
399             size := extcodesize(account)
400         }
401         return size > 0;
402     }
403 
404     /**
405      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
406      * `recipient`, forwarding all available gas and reverting on errors.
407      *
408      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
409      * of certain opcodes, possibly making contracts go over the 2300 gas limit
410      * imposed by `transfer`, making them unable to receive funds via
411      * `transfer`. {sendValue} removes this limitation.
412      *
413      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
414      *
415      * IMPORTANT: because control is transferred to `recipient`, care must be
416      * taken to not create reentrancy vulnerabilities. Consider using
417      * {ReentrancyGuard} or the
418      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
419      */
420     function sendValue(address payable recipient, uint256 amount) internal {
421         require(address(this).balance >= amount, "Address: insufficient balance");
422 
423         (bool success, ) = recipient.call{value: amount}("");
424         require(success, "Address: unable to send value, recipient may have reverted");
425     }
426 
427     /**
428      * @dev Performs a Solidity function call using a low level `call`. A
429      * plain `call` is an unsafe replacement for a function call: use this
430      * function instead.
431      *
432      * If `target` reverts with a revert reason, it is bubbled up by this
433      * function (like regular Solidity function calls).
434      *
435      * Returns the raw returned data. To convert to the expected return value,
436      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
437      *
438      * Requirements:
439      *
440      * - `target` must be a contract.
441      * - calling `target` with `data` must not revert.
442      *
443      * _Available since v3.1._
444      */
445     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
446         return functionCall(target, data, "Address: low-level call failed");
447     }
448 
449     /**
450      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
451      * `errorMessage` as a fallback revert reason when `target` reverts.
452      *
453      * _Available since v3.1._
454      */
455     function functionCall(
456         address target,
457         bytes memory data,
458         string memory errorMessage
459     ) internal returns (bytes memory) {
460         return functionCallWithValue(target, data, 0, errorMessage);
461     }
462 
463     /**
464      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
465      * but also transferring `value` wei to `target`.
466      *
467      * Requirements:
468      *
469      * - the calling contract must have an ETH balance of at least `value`.
470      * - the called Solidity function must be `payable`.
471      *
472      * _Available since v3.1._
473      */
474     function functionCallWithValue(
475         address target,
476         bytes memory data,
477         uint256 value
478     ) internal returns (bytes memory) {
479         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
480     }
481 
482     /**
483      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
484      * with `errorMessage` as a fallback revert reason when `target` reverts.
485      *
486      * _Available since v3.1._
487      */
488     function functionCallWithValue(
489         address target,
490         bytes memory data,
491         uint256 value,
492         string memory errorMessage
493     ) internal returns (bytes memory) {
494         require(address(this).balance >= value, "Address: insufficient balance for call");
495         require(isContract(target), "Address: call to non-contract");
496 
497         (bool success, bytes memory returndata) = target.call{value: value}(data);
498         return verifyCallResult(success, returndata, errorMessage);
499     }
500 
501     /**
502      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
503      * but performing a static call.
504      *
505      * _Available since v3.3._
506      */
507     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
508         return functionStaticCall(target, data, "Address: low-level static call failed");
509     }
510 
511     /**
512      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
513      * but performing a static call.
514      *
515      * _Available since v3.3._
516      */
517     function functionStaticCall(
518         address target,
519         bytes memory data,
520         string memory errorMessage
521     ) internal view returns (bytes memory) {
522         require(isContract(target), "Address: static call to non-contract");
523 
524         (bool success, bytes memory returndata) = target.staticcall(data);
525         return verifyCallResult(success, returndata, errorMessage);
526     }
527 
528     /**
529      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
530      * but performing a delegate call.
531      *
532      * _Available since v3.4._
533      */
534     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
535         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
536     }
537 
538     /**
539      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
540      * but performing a delegate call.
541      *
542      * _Available since v3.4._
543      */
544     function functionDelegateCall(
545         address target,
546         bytes memory data,
547         string memory errorMessage
548     ) internal returns (bytes memory) {
549         require(isContract(target), "Address: delegate call to non-contract");
550 
551         (bool success, bytes memory returndata) = target.delegatecall(data);
552         return verifyCallResult(success, returndata, errorMessage);
553     }
554 
555     /**
556      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
557      * revert reason using the provided one.
558      *
559      * _Available since v4.3._
560      */
561     function verifyCallResult(
562         bool success,
563         bytes memory returndata,
564         string memory errorMessage
565     ) internal pure returns (bytes memory) {
566         if (success) {
567             return returndata;
568         } else {
569             // Look for revert reason and bubble it up if present
570             if (returndata.length > 0) {
571                 // The easiest way to bubble the revert reason is using memory via assembly
572 
573                 assembly {
574                     let returndata_size := mload(returndata)
575                     revert(add(32, returndata), returndata_size)
576                 }
577             } else {
578                 revert(errorMessage);
579             }
580         }
581     }
582 }
583 
584 library SafeERC20 {
585     using Address for address;
586 
587     function safeTransfer(
588         IERC20 token,
589         address to,
590         uint256 value
591     ) internal {
592         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
593     }
594 
595     function safeTransferFrom(
596         IERC20 token,
597         address from,
598         address to,
599         uint256 value
600     ) internal {
601         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
602     }
603 
604     /**
605      * @dev Deprecated. This function has issues similar to the ones found in
606      * {IERC20-approve}, and its usage is discouraged.
607      *
608      * Whenever possible, use {safeIncreaseAllowance} and
609      * {safeDecreaseAllowance} instead.
610      */
611     function safeApprove(
612         IERC20 token,
613         address spender,
614         uint256 value
615     ) internal {
616         // safeApprove should only be called when setting an initial allowance,
617         // or when resetting it to zero. To increase and decrease it, use
618         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
619         require(
620             (value == 0) || (token.allowance(address(this), spender) == 0),
621             "SafeERC20: approve from non-zero to non-zero allowance"
622         );
623         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
624     }
625 
626     function safeIncreaseAllowance(
627         IERC20 token,
628         address spender,
629         uint256 value
630     ) internal {
631         uint256 newAllowance = token.allowance(address(this), spender) + value;
632         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
633     }
634 
635     function safeDecreaseAllowance(
636         IERC20 token,
637         address spender,
638         uint256 value
639     ) internal {
640         unchecked {
641             uint256 oldAllowance = token.allowance(address(this), spender);
642             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
643             uint256 newAllowance = oldAllowance - value;
644             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
645         }
646     }
647 
648     /**
649      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
650      * on the return value: the return value is optional (but if data is returned, it must not be false).
651      * @param token The token targeted by the call.
652      * @param data The call data (encoded using abi.encode or one of its variants).
653      */
654     function _callOptionalReturn(IERC20 token, bytes memory data) private {
655         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
656         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
657         // the target address contains contract code and also asserts for success in the low-level call.
658 
659         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
660         if (returndata.length > 0) {
661             // Return data is optional
662             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
663         }
664     }
665 }
666 
667 abstract contract Ownable is Context {
668     address private _owner;
669 
670     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
671 
672     /**
673      * @dev Initializes the contract setting the deployer as the initial owner.
674      */
675     constructor() {
676         _setOwner(_msgSender());
677     }
678 
679     /**
680      * @dev Returns the address of the current owner.
681      */
682     function owner() public view virtual returns (address) {
683         return _owner;
684     }
685 
686     /**
687      * @dev Throws if called by any account other than the owner.
688      */
689     modifier onlyOwner() {
690         require(owner() == _msgSender(), "Ownable: caller is not the owner");
691         _;
692     }
693 
694     /**
695      * @dev Leaves the contract without owner. It will not be possible to call
696      * `onlyOwner` functions anymore. Can only be called by the current owner.
697      *
698      * NOTE: Renouncing ownership will leave the contract without an owner,
699      * thereby removing any functionality that is only available to the owner.
700      */
701     function renounceOwnership() public virtual onlyOwner {
702         _setOwner(address(0));
703     }
704 
705     /**
706      * @dev Transfers ownership of the contract to a new account (`newOwner`).
707      * Can only be called by the current owner.
708      */
709     function transferOwnership(address newOwner) public virtual onlyOwner {
710         require(newOwner != address(0), "Ownable: new owner is the zero address");
711         _setOwner(newOwner);
712     }
713 
714     function _setOwner(address newOwner) private {
715         address oldOwner = _owner;
716         _owner = newOwner;
717         emit OwnershipTransferred(oldOwner, newOwner);
718     }
719 }
720 
721 interface IUniswapV2Router01 {
722     function factory() external pure returns (address);
723     function WETH() external pure returns (address);
724 
725     function addLiquidity(
726         address tokenA,
727         address tokenB,
728         uint amountADesired,
729         uint amountBDesired,
730         uint amountAMin,
731         uint amountBMin,
732         address to,
733         uint deadline
734     ) external returns (uint amountA, uint amountB, uint liquidity);
735     function addLiquidityETH(
736         address token,
737         uint amountTokenDesired,
738         uint amountTokenMin,
739         uint amountETHMin,
740         address to,
741         uint deadline
742     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
743     function removeLiquidity(
744         address tokenA,
745         address tokenB,
746         uint liquidity,
747         uint amountAMin,
748         uint amountBMin,
749         address to,
750         uint deadline
751     ) external returns (uint amountA, uint amountB);
752     function removeLiquidityETH(
753         address token,
754         uint liquidity,
755         uint amountTokenMin,
756         uint amountETHMin,
757         address to,
758         uint deadline
759     ) external returns (uint amountToken, uint amountETH);
760     function removeLiquidityWithPermit(
761         address tokenA,
762         address tokenB,
763         uint liquidity,
764         uint amountAMin,
765         uint amountBMin,
766         address to,
767         uint deadline,
768         bool approveMax, uint8 v, bytes32 r, bytes32 s
769     ) external returns (uint amountA, uint amountB);
770     function removeLiquidityETHWithPermit(
771         address token,
772         uint liquidity,
773         uint amountTokenMin,
774         uint amountETHMin,
775         address to,
776         uint deadline,
777         bool approveMax, uint8 v, bytes32 r, bytes32 s
778     ) external returns (uint amountToken, uint amountETH);
779     function swapExactTokensForTokens(
780         uint amountIn,
781         uint amountOutMin,
782         address[] calldata path,
783         address to,
784         uint deadline
785     ) external returns (uint[] memory amounts);
786     function swapTokensForExactTokens(
787         uint amountOut,
788         uint amountInMax,
789         address[] calldata path,
790         address to,
791         uint deadline
792     ) external returns (uint[] memory amounts);
793     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
794         external
795         payable
796         returns (uint[] memory amounts);
797     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
798         external
799         returns (uint[] memory amounts);
800     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
801         external
802         returns (uint[] memory amounts);
803     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
804         external
805         payable
806         returns (uint[] memory amounts);
807 
808     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
809     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
810     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
811     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
812     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
813 }
814 
815 interface IUniswapV2Router02 is IUniswapV2Router01 {
816     function removeLiquidityETHSupportingFeeOnTransferTokens(
817         address token,
818         uint liquidity,
819         uint amountTokenMin,
820         uint amountETHMin,
821         address to,
822         uint deadline
823     ) external returns (uint amountETH);
824     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
825         address token,
826         uint liquidity,
827         uint amountTokenMin,
828         uint amountETHMin,
829         address to,
830         uint deadline,
831         bool approveMax, uint8 v, bytes32 r, bytes32 s
832     ) external returns (uint amountETH);
833 
834     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
835         uint amountIn,
836         uint amountOutMin,
837         address[] calldata path,
838         address to,
839         uint deadline
840     ) external;
841     function swapExactETHForTokensSupportingFeeOnTransferTokens(
842         uint amountOutMin,
843         address[] calldata path,
844         address to,
845         uint deadline
846     ) external payable;
847     function swapExactTokensForETHSupportingFeeOnTransferTokens(
848         uint amountIn,
849         uint amountOutMin,
850         address[] calldata path,
851         address to,
852         uint deadline
853     ) external;
854 }
855 
856 interface IUniswapV2Factory {
857     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
858 
859     function feeTo() external view returns (address);
860     function feeToSetter() external view returns (address);
861 
862     function getPair(address tokenA, address tokenB) external view returns (address pair);
863     function allPairs(uint) external view returns (address pair);
864     function allPairsLength() external view returns (uint);
865 
866     function createPair(address tokenA, address tokenB) external returns (address pair);
867 
868     function setFeeTo(address) external;
869     function setFeeToSetter(address) external;
870 }
871 
872 interface IUniswapV2Pair {
873     event Approval(address indexed owner, address indexed spender, uint value);
874     event Transfer(address indexed from, address indexed to, uint value);
875 
876     function name() external pure returns (string memory);
877     function symbol() external pure returns (string memory);
878     function decimals() external pure returns (uint8);
879     function totalSupply() external view returns (uint);
880     function balanceOf(address owner) external view returns (uint);
881     function allowance(address owner, address spender) external view returns (uint);
882 
883     function approve(address spender, uint value) external returns (bool);
884     function transfer(address to, uint value) external returns (bool);
885     function transferFrom(address from, address to, uint value) external returns (bool);
886 
887     function DOMAIN_SEPARATOR() external view returns (bytes32);
888     function PERMIT_TYPEHASH() external pure returns (bytes32);
889     function nonces(address owner) external view returns (uint);
890 
891     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
892 
893     event Mint(address indexed sender, uint amount0, uint amount1);
894     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
895     event Swap(
896         address indexed sender,
897         uint amount0In,
898         uint amount1In,
899         uint amount0Out,
900         uint amount1Out,
901         address indexed to
902     );
903     event Sync(uint112 reserve0, uint112 reserve1);
904 
905     function MINIMUM_LIQUIDITY() external pure returns (uint);
906     function factory() external view returns (address);
907     function token0() external view returns (address);
908     function token1() external view returns (address);
909     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
910     function price0CumulativeLast() external view returns (uint);
911     function price1CumulativeLast() external view returns (uint);
912     function kLast() external view returns (uint);
913 
914     function mint(address to) external returns (uint liquidity);
915     function burn(address to) external returns (uint amount0, uint amount1);
916     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
917     function skim(address to) external;
918     function sync() external;
919 
920     function initialize(address, address) external;
921 }
922 
923 library SafeMathInt {
924   function mul(int256 a, int256 b) internal pure returns (int256) {
925 
926     require(!(a == - 2**255 && b == -1) && !(b == - 2**255 && a == -1));
927 
928     int256 c = a * b;
929     require((b == 0) || (c / b == a));
930     return c;
931   }
932 
933   function div(int256 a, int256 b) internal pure returns (int256) {
934 
935     require(!(a == - 2**255 && b == -1) && (b > 0));
936 
937     return a / b;
938   }
939 
940   function sub(int256 a, int256 b) internal pure returns (int256) {
941     require((b >= 0 && a - b <= a) || (b < 0 && a - b > a));
942 
943     return a - b;
944   }
945 
946   function add(int256 a, int256 b) internal pure returns (int256) {
947     int256 c = a + b;
948     require((b >= 0 && c >= a) || (b < 0 && c < a));
949     return c;
950   }
951 
952   function toUint256Safe(int256 a) internal pure returns (uint256) {
953     require(a >= 0);
954     return uint256(a);
955   }
956 }
957 
958 library SafeMathUint {
959   function toInt256Safe(uint256 a) internal pure returns (int256) {
960     int256 b = int256(a);
961     require(b >= 0);
962     return b;
963   }
964 }
965 
966 library SafeMath {
967 
968     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
969         uint256 c = a + b;
970         if (c < a) return (false, 0);
971         return (true, c);
972     }
973 
974     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
975         if (b > a) return (false, 0);
976         return (true, a - b);
977     }
978 
979     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
980         if (a == 0) return (true, 0);
981         uint256 c = a * b;
982         if (c / a != b) return (false, 0);
983         return (true, c);
984     }
985 
986     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
987         if (b == 0) return (false, 0);
988         return (true, a / b);
989     }
990 
991     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
992         if (b == 0) return (false, 0);
993         return (true, a % b);
994     }
995 
996     function add(uint256 a, uint256 b) internal pure returns (uint256) {
997         uint256 c = a + b;
998         require(c >= a, "SafeMath: addition overflow");
999         return c;
1000     }
1001 
1002     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1003         require(b <= a, "SafeMath: subtraction overflow");
1004         return a - b;
1005     }
1006 
1007     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1008         if (a == 0) return 0;
1009         uint256 c = a * b;
1010         require(c / a == b, "SafeMath: multiplication overflow");
1011         return c;
1012     }
1013 
1014     function div(uint256 a, uint256 b) internal pure returns (uint256) {
1015         require(b > 0, "SafeMath: division by zero");
1016         return a / b;
1017     }
1018 
1019     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
1020         require(b > 0, "SafeMath: modulo by zero");
1021         return a % b;
1022     }
1023 
1024     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
1025         require(b <= a, errorMessage);
1026         return a - b;
1027     }
1028 
1029     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
1030         require(b > 0, errorMessage);
1031         return a / b;
1032     }
1033 
1034     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
1035         require(b > 0, errorMessage);
1036         return a % b;
1037     }
1038 }
1039 
1040 contract Retrogression is Context, ERC20, Ownable {
1041     using SafeMath for uint256;
1042     using SafeERC20 for IERC20;
1043     using Address for address;
1044 
1045     IUniswapV2Router02 public uniswapV2Router;
1046     address public immutable uniswapV2Pair;
1047 
1048 	bool private trading;
1049     bool private starting;
1050     bool private alreadyStarted;
1051     bool private stakingAllowed;
1052     bool private lpAdded;
1053     bool public sendTokens;
1054     bool public swapping;
1055 
1056 	address public productionWallet;
1057     address public marketingWallet;
1058     address public filmCribWallet;
1059 
1060     uint256 public swapTokensAtAmount;
1061 
1062     uint256 private _buyProductionFee;
1063     uint256 private _buyMarketingFee;
1064     uint256 private _buyFilmCribFee;
1065 
1066     uint256 private _sellProductionFee;
1067     uint256 private _sellMarketingFee;
1068     uint256 private _sellFilmCribFee;
1069 
1070     uint256 private blacklistFee;
1071 
1072     uint256 public _maxWallet;
1073     uint256 public _maxBuy;
1074     uint256 public _maxSell;
1075 
1076     uint256 public totalBuyFees;
1077     uint256 public totalSellFees;
1078 
1079     mapping (address => bool) private _isExcludedFromFees;
1080 
1081     mapping (address => bool) public automatedMarketMakerPairs;
1082     mapping (address => bool) public _isBlacklisted;
1083     mapping (address => bool) public _canAddLiquidity;
1084 
1085     event UpdateUniswapV2Router(address indexed newAddress, address indexed oldAddress);
1086     event ExcludeFromFees(address indexed account, bool isExcluded);
1087     event blacklist(address indexed account, bool isBlacklisted);
1088     event addLiquidityAddress(address indexed account, bool enabled);
1089     event ExcludeMultipleAccountsFromFees(address[] accounts, bool isExcluded);
1090     event tradingUpdated(bool _enabled);
1091     event burningUpdated(bool _enabled);
1092     event allowStaking(bool _enabled);
1093     event sendTokensUpdated(bool _enabled);
1094     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
1095     event WalletUpdated(address indexed newMarketingWallet, address indexed oldMarketingWallet);
1096     event UpdateSwapAmount(uint256 amount, uint256 swapTokensAtAmount);
1097     event UpdateMaxWallet(uint256 newMaxWallet, uint256 _maxWallet);
1098     event UpdateMaxBuySell(
1099         uint256 newMaxBuy,
1100         uint256 _maxBuy,
1101         uint256 newMaxSell,
1102         uint256 _maxSell
1103     );
1104     event UpdateBuyFees(
1105         uint256 newBuyProductionFee,
1106         uint256 _buyProductionFee,
1107         uint256 newBuyMarketingFee,
1108         uint256 _buyMarketingFee,
1109         uint256 newBuyFilmCribFee,
1110         uint256 _buyFilmCribFee
1111     );
1112     event UpdateSellFees(
1113         uint256 newSellProductionFee,
1114         uint256 _sellProductionFee,
1115         uint256 newSellMarketingFee,
1116         uint256 _sellMarketingFee,
1117         uint256 newSellFilmCribFee,
1118         uint256 _sellFilmCribFee
1119     );
1120     event SwapAndLiquify(
1121         uint256 tokensSwapped,
1122         uint256 ethReceived,
1123         uint256 tokensIntoLiquidity
1124     );
1125 
1126     constructor() ERC20 ("Retrogression", "RTGN") {
1127 
1128         _buyProductionFee = 11;
1129         _buyMarketingFee = 2;
1130         _buyFilmCribFee = 1;
1131 
1132         _sellProductionFee = 11;
1133         _sellMarketingFee = 2;
1134         _sellFilmCribFee = 1;
1135 
1136         blacklistFee = 99;
1137 
1138         alreadyStarted = false;
1139         stakingAllowed = false;
1140         trading = false;
1141         lpAdded = false;
1142         sendTokens = true;
1143 
1144         swapTokensAtAmount = 2500000 * (10**18);
1145         _maxWallet = 5000000 * (10**18);
1146         _maxBuy = 2500000 * (10**18);
1147         _maxSell = 2500000 * (10**18);
1148 
1149         totalBuyFees = _buyProductionFee.add(_buyMarketingFee).add(_buyFilmCribFee);
1150         totalSellFees = _sellProductionFee.add(_sellMarketingFee).add(_sellFilmCribFee);
1151 
1152         productionWallet = address(payable(0x1D80A03B5b7E13cc785547149bfa14ebF8D3Dd4C));
1153         marketingWallet = address(payable(0x6B1d1e793cCF87aDd7D8Ac44e0f26c2088088bBa));
1154         filmCribWallet = address(payable(0xA381A36f084c5C8082a48f7F4596dC0a6FE0AC18));
1155 
1156     	IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
1157     	//0x9Ac64Cc6e4415144C455BD8E4837Fea55603e5c3 Testnet
1158     	//0x10ED43C718714eb63d5aA57B78B54704E256024E BSC Mainnet
1159     	//0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D Ropsten
1160     	//0xCDe540d7eAFE93aC5fE6233Bee57E1270D3E330F BakerySwap
1161          // Create a uniswap pair for this new token
1162         address _uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
1163             .createPair(address(this), _uniswapV2Router.WETH());
1164 
1165         uniswapV2Router = _uniswapV2Router;
1166         uniswapV2Pair = _uniswapV2Pair;
1167 
1168         _setAutomatedMarketMakerPair(_uniswapV2Pair, true);
1169 
1170         // exclude from paying fees
1171         excludeFromFees(owner(), true);
1172         excludeFromFees(marketingWallet, true);
1173         excludeFromFees(productionWallet, true);
1174         excludeFromFees(address(this), true);
1175         
1176         /*
1177             _mint is an internal function in ERC20.sol that is only called here,
1178             and CANNOT be called ever again
1179         */
1180         _mint(owner(), 1000000000 * (10**18));
1181     }
1182 
1183     receive() external payable {
1184 
1185   	}
1186 
1187 	function updateSwapAmount(uint256 amount) public onlyOwner {
1188 	    swapTokensAtAmount = amount * (10**18);
1189         
1190         emit UpdateSwapAmount(amount, swapTokensAtAmount);
1191 	}
1192     
1193     function updateUniswapV2Router(address newAddress) public onlyOwner {
1194         require(newAddress != address(uniswapV2Router), "Retrogression: The router already has that address");
1195         emit UpdateUniswapV2Router(newAddress, address(uniswapV2Router));
1196         uniswapV2Router = IUniswapV2Router02(newAddress);
1197     }
1198 
1199     function excludeFromFees(address account, bool excluded) public onlyOwner {
1200         require(_isExcludedFromFees[account] != excluded, "Retrogression: Account is already the value of 'excluded'");
1201         _isExcludedFromFees[account] = excluded;
1202 
1203         emit ExcludeFromFees(account, excluded);
1204     }
1205 
1206     function addToBlacklist(address account, bool isBlacklisted) public onlyOwner {
1207         require(_isBlacklisted[account] != isBlacklisted, "Retrogression: Account is already the value of 'elon'");
1208         _isBlacklisted[account] = isBlacklisted;
1209 
1210         emit blacklist(account, isBlacklisted);
1211     }
1212 
1213     function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
1214         require(pair != uniswapV2Pair, "Retrogression: The Uniswap pair cannot be removed from automatedMarketMakerPairs");
1215 
1216         _setAutomatedMarketMakerPair(pair, value);
1217     }
1218 
1219     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1220         require(automatedMarketMakerPairs[pair] != value, "Retrogression: Automated market maker pair is already set to that value");
1221         automatedMarketMakerPairs[pair] = value;
1222 
1223         emit SetAutomatedMarketMakerPair(pair, value);
1224     }
1225 
1226     function updateMarketingWallet(address newMarketingWallet) public onlyOwner {
1227     	require(newMarketingWallet != address(0), "ERC20: transfer to the zero address");
1228         require(newMarketingWallet != marketingWallet, "Retrogression: The marketing wallet is already this address");
1229         excludeFromFees(newMarketingWallet, true);
1230         emit WalletUpdated(newMarketingWallet, marketingWallet);
1231         marketingWallet = newMarketingWallet;
1232     }
1233 
1234     function updateProductionWallet(address newProductionWallet) public onlyOwner {
1235     	require(newProductionWallet != address(0), "ERC20: transfer to the zero address");
1236         require(newProductionWallet != productionWallet, "Retrogression: The marketing wallet is already this address");
1237         excludeFromFees(newProductionWallet, true);
1238         emit WalletUpdated(newProductionWallet, productionWallet);
1239         productionWallet = newProductionWallet;
1240     }
1241 
1242     function updateFilmCribWallet(address newFilmCribWallet) public onlyOwner {
1243     	require(newFilmCribWallet != address(0), "ERC20: transfer to the zero address");
1244         require(newFilmCribWallet != filmCribWallet, "Retrogression: The film crib wallet is already this address");
1245         excludeFromFees(newFilmCribWallet, true);
1246         emit WalletUpdated(newFilmCribWallet, filmCribWallet);
1247         filmCribWallet = newFilmCribWallet;
1248     }
1249 
1250     function isExcludedFromFees(address account) public view returns(bool) {
1251         return _isExcludedFromFees[account];
1252     }
1253 
1254     function allowStakingAddress(bool enabled) public onlyOwner {
1255         stakingAllowed = enabled;
1256         emit allowStaking(enabled);
1257     }
1258 
1259     function SendTokensToFilmCrib(bool enabled) public onlyOwner {
1260         sendTokens = enabled;
1261         emit sendTokensUpdated(enabled);
1262     }
1263 
1264     function _transfer(
1265         address from,
1266         address to,
1267         uint256 amount
1268     ) internal override {
1269         require(from != address(0), "ERC20: transfer from the zero address");
1270         require(to != address(0), "ERC20: transfer to the zero address");
1271 
1272         if (to == uniswapV2Pair && !trading) {
1273             if (!stakingAllowed) {
1274             require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "You do not have permission to add liquidity");
1275             }
1276         }
1277 
1278         if (from != owner() && to != owner() && to != address(0) && to != address(0xdead) && to != uniswapV2Pair && !_isExcludedFromFees[to] && !_isExcludedFromFees[from]) 
1279         {
1280             require(trading == true, "Trading is not yet enabled");
1281             require(amount <= _maxBuy, "Transfer amount exceeds the maxTxAmount.");
1282             uint256 contractBalanceRecipient = balanceOf(to);
1283             require(contractBalanceRecipient + amount <= _maxWallet, "Exceeds maximum wallet token amount.");
1284         }
1285 
1286         if(amount == 0) {
1287             super._transfer(from, to, 0);
1288             return;
1289         }
1290 
1291         if(!swapping && automatedMarketMakerPairs[to] && from != address(uniswapV2Router) && from != owner() && to != owner() && !_isExcludedFromFees[to] && !_isExcludedFromFees[from])
1292         {
1293             require(trading == true, "Trading is not yet enabled");
1294 
1295             require(amount <= _maxSell, "Sell transfer amount exceeds the maxSellTransactionAmount.");
1296         }
1297 
1298 		uint256 contractTokenBalance = balanceOf(address(this));
1299 
1300         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1301 		
1302 		if(canSwap && !swapping && automatedMarketMakerPairs[to] && !_isExcludedFromFees[to] && !_isExcludedFromFees[from]) {
1303 		    
1304 		    contractTokenBalance = swapTokensAtAmount;
1305 		    uint256 swapTokens;
1306             uint256 swapTokensAmount;
1307             
1308             swapping = true;
1309 
1310             if (totalSellFees > 0 && !sendTokens) {
1311             swapTokens = contractTokenBalance;
1312             swapTokensForEth(swapTokens);
1313             swapTokensAmount = totalSellFees;
1314 
1315             uint256 filmCribAmount = address(this).balance.mul(_sellFilmCribFee).div(swapTokensAmount);
1316             (bool success, ) = filmCribWallet.call{value: filmCribAmount}("");
1317             require(success, "Failed to send film crib amount");
1318             }
1319 
1320             else if (totalSellFees > 0 && sendTokens) {
1321                 swapTokens = contractTokenBalance;
1322                 uint256 filmCribAmount = swapTokens.mul(_sellFilmCribFee).div(100);
1323                 swapTokens = swapTokens.sub(filmCribAmount);
1324                 swapTokensAmount = totalSellFees.sub(_sellFilmCribFee);
1325 
1326                 swapTokensForEth(swapTokens);
1327                 super._transfer(address(this), filmCribWallet, filmCribAmount);
1328 
1329             }
1330 
1331             if (_sellProductionFee > 0) {
1332             uint256 productionAmount = address(this).balance.mul(_sellProductionFee).div(swapTokensAmount);
1333             (bool success, ) = productionWallet.call{value: productionAmount}("");
1334             require(success, "Failed to send production amount");
1335             }
1336             
1337             if (_sellMarketingFee > 0) {
1338             uint256 marketingAmount = address(this).balance;
1339             (bool success, ) = marketingWallet.call{value: marketingAmount}("");
1340             require(success, "Failed to send marketing amount");
1341             }
1342 			
1343             swapping = false;
1344         }
1345 
1346         bool takeFee = !swapping;
1347 
1348         // if any account belongs to _isExcludedFromFee account then remove the fee
1349         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1350             takeFee = false;
1351             super._transfer(from, to, amount);
1352         }
1353 
1354         else if(!automatedMarketMakerPairs[to] && !automatedMarketMakerPairs[from] && !_isExcludedFromFees[from] && !_isExcludedFromFees[to]) {
1355             takeFee = false;
1356             super._transfer(from, to, amount);
1357         }
1358 
1359         if(takeFee) {
1360             uint256 BuyFees = amount.mul(totalBuyFees).div(100);
1361             uint256 SellFees = amount.mul(totalSellFees).div(100);
1362             uint256 BlacklistFee = amount.mul(blacklistFee).div(100);
1363 
1364             if(_isBlacklisted[to] && automatedMarketMakerPairs[from]) {
1365                 amount = amount.sub(BlacklistFee);
1366                 super._transfer(from, address(this), BlacklistFee);
1367                 super._transfer(from, to, amount);
1368             }
1369 
1370             // if sell
1371             else if(automatedMarketMakerPairs[to] && totalSellFees > 0) {
1372                 amount = amount.sub(SellFees);
1373                 super._transfer(from, address(this), SellFees);
1374                 super._transfer(from, to, amount);
1375             }
1376 
1377             // if buy transfer
1378             else if(automatedMarketMakerPairs[from] && totalBuyFees > 0) {
1379                 amount = amount.sub(BuyFees);
1380                 super._transfer(from, address(this), BuyFees);
1381                 super._transfer(from, to, amount);
1382                 
1383                 if(starting && !_isBlacklisted[to] && !_isExcludedFromFees[from] && !_isExcludedFromFees[to]) {
1384                 _isBlacklisted[to] = true;
1385                 }
1386                 }
1387 
1388             else {
1389                 super._transfer(from, to, amount);
1390             }
1391         }
1392     }
1393 
1394     function swapTokensForEth(uint256 tokenAmount) private {
1395 
1396         // generate the uniswap pair path of token -> weth
1397         address[] memory path = new address[](2);
1398         path[0] = address(this);
1399         path[1] = uniswapV2Router.WETH();
1400 
1401         _approve(address(this), address(uniswapV2Router), tokenAmount);
1402 
1403         // make the swap
1404         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1405             tokenAmount,
1406             0, // accept any amount of ETH
1407             path,
1408             address(this),
1409             block.timestamp
1410         );
1411     }
1412 
1413     function addLP() external onlyOwner() {
1414         require(!lpAdded, "This project is already launched");
1415         updateBuyFees(0,0,0);
1416         updateSellFees(0,0,0);
1417 
1418 		trading = false;
1419 
1420         updateMaxWallet(1000000000);
1421         updateMaxBuySell((1000000000), (1000000000));
1422 
1423         lpAdded = true;
1424     }
1425     
1426 	function letsGoLive() external onlyOwner() {
1427         updateBuyFees(11,2,1);
1428         updateSellFees(11,2,1);
1429 
1430         updateMaxWallet(5000000);
1431         updateMaxBuySell(2500000, 2500000);
1432 
1433         starting = false;
1434         if(!trading) {
1435             trading = true;
1436         }
1437         
1438         if(!stakingAllowed) {
1439             stakingAllowed = true;
1440         }
1441     }
1442 
1443     function letsBegin() external onlyOwner() {
1444         require(!alreadyStarted, "This project is already launched");
1445         _buyMarketingFee = 33;
1446         _buyProductionFee = 33;
1447         _buyFilmCribFee = 33;
1448         updateSellFees(11,2,1);
1449 
1450         updateMaxWallet(5000000);
1451         updateMaxBuySell(2500000, 2500000);
1452 
1453 		trading = true;
1454         starting = true;
1455         alreadyStarted = true;
1456         stakingAllowed = true;
1457     }
1458 
1459     function updateBuyFees(uint256 newBuyProductionFee, uint256 newBuyMarketingFee, uint256 newBuyFilmCribFee) public onlyOwner {
1460         require(newBuyProductionFee.add(newBuyMarketingFee).add(newBuyFilmCribFee) <= 25, "Total buy taxes cannot exceed 25%");
1461         _buyProductionFee = newBuyProductionFee;
1462         _buyMarketingFee = newBuyMarketingFee;
1463         _buyFilmCribFee = newBuyFilmCribFee;
1464         
1465         totalFees();
1466 
1467         emit UpdateBuyFees(newBuyProductionFee, _buyProductionFee, newBuyMarketingFee, _buyMarketingFee, newBuyFilmCribFee, _buyFilmCribFee);
1468     }
1469 
1470     function updateSellFees(uint256 newSellProductionFee, uint256 newSellMarketingFee, uint256 newSellFilmCribFee) public onlyOwner {
1471         require(newSellProductionFee.add(newSellMarketingFee).add(newSellFilmCribFee) <= 25, "Total sell taxes cannot exceed 25%");
1472         _sellProductionFee = newSellProductionFee;
1473         _sellMarketingFee = newSellMarketingFee;
1474         _sellFilmCribFee = newSellFilmCribFee;
1475         
1476         totalFees();
1477 
1478         emit UpdateSellFees(newSellProductionFee, _sellProductionFee, newSellMarketingFee, _sellMarketingFee, newSellFilmCribFee, _sellFilmCribFee);
1479     }
1480 
1481     function updateMaxWallet(uint256 newMaxWallet) public onlyOwner {
1482         require(newMaxWallet >= 5000000, "Cannot lower max wallet below .5% of total supply");
1483         _maxWallet = newMaxWallet * (10**18);
1484 
1485         emit UpdateMaxWallet(newMaxWallet, _maxWallet);
1486     }
1487 
1488     function updateMaxBuySell(uint256 newMaxBuy, uint256 newMaxSell) public onlyOwner {
1489         require(newMaxBuy >= 2500000, "Cannot lower max buy below .25% of total supply");
1490         require(newMaxSell >= 2500000, "Cannot lower max sell below .25% of total supply");
1491         _maxBuy = newMaxBuy * (10**18);
1492         _maxSell = newMaxSell * (10**18);
1493 
1494         emit UpdateMaxBuySell(newMaxBuy, _maxBuy, newMaxSell, _maxSell);
1495     }
1496 
1497     function totalFees() private {
1498         totalBuyFees = _buyProductionFee.add(_buyMarketingFee).add(_buyFilmCribFee);
1499         totalSellFees = _sellProductionFee.add(_sellMarketingFee).add(_sellFilmCribFee);
1500     }
1501 
1502     function withdrawRemainingETH(address account, uint256 percent) public onlyOwner {
1503         require(percent > 0 && percent <= 100, "Must be a valid percent");
1504         require(account != address(0), "ERC20: transfer to the zero address");
1505         uint256 percentage = percent.div(100);
1506         uint256 balance = address(this).balance.mul(percentage);
1507         
1508         (bool success, ) = account.call{value: balance}("");
1509         require(success, "Failed to send withdraw ETH");
1510     }
1511 
1512     function withdrawRemainingToken(address account, uint256 amount) public onlyOwner {
1513         require(amount <= balanceOf(address(this)), "Amount cannot exceed tokens in contract");
1514         super._transfer(address(this), account, amount);
1515     }
1516 
1517     function withdrawRemainingERC20Token(address token, address account) public onlyOwner {
1518         ERC20 Token = ERC20(token);
1519         uint256 balance = Token.balanceOf(address(this));
1520         Token.transfer(account, balance);
1521     }
1522 
1523     function burnTokenManual(uint256 amount) public onlyOwner {
1524         require(amount <= balanceOf(address(this)), "Amount cannot exceed tokens in contract");
1525         super._transfer(address(this), 0x000000000000000000000000000000000000dEaD, amount * 10**18);
1526     }
1527 }