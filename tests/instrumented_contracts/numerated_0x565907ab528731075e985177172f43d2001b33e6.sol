1 pragma solidity 0.8.19;
2 
3 // SPDX-License-Identifier: MIT
4 
5 abstract contract Context {
6     function _msgSender() internal view virtual returns (address) {
7         return msg.sender;
8     }
9 
10     function _msgData() internal view virtual returns (bytes calldata) {
11         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
12         return msg.data;
13     }
14 }
15 
16 interface IERC20 {
17     /**
18      * @dev Returns the amount of tokens in existence.
19      */
20     function totalSupply() external view returns (uint256);
21 
22     /**
23      * @dev Returns the amount of tokens owned by `account`.
24      */
25     function balanceOf(address account) external view returns (uint256);
26 
27     /**
28      * @dev Moves `amount` tokens from the caller's account to `recipient`.
29      *
30      * Returns a boolean value indicating whether the operation succeeded.
31      *
32      * Emits a {Transfer} event.
33      */
34     function transfer(address recipient, uint256 amount) external returns (bool);
35 
36     /**
37      * @dev Returns the remaining number of tokens that `spender` will be
38      * allowed to spend on behalf of `owner` through {transferFrom}. This is
39      * zero by default.
40      *
41      * This value changes when {approve} or {transferFrom} are called.
42      */
43     function allowance(address owner, address spender) external view returns (uint256);
44 
45     /**
46      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
47      *
48      * Returns a boolean value indicating whether the operation succeeded.
49      *
50      * IMPORTANT: Beware that changing an allowance with this method brings the risk
51      * that someone may use both the old and the new allowance by unfortunate
52      * transaction ordering. One possible solution to mitigate this race
53      * condition is to first reduce the spender's allowance to 0 and set the
54      * desired value afterwards:
55      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
56      *
57      * Emits an {Approval} event.
58      */
59     function approve(address spender, uint256 amount) external returns (bool);
60 
61     /**
62      * @dev Moves `amount` tokens from `sender` to `recipient` using the
63      * allowance mechanism. `amount` is then deducted from the caller's
64      * allowance.
65      *
66      * Returns a boolean value indicating whether the operation succeeded.
67      *
68      * Emits a {Transfer} event.
69      */
70     function transferFrom(
71         address sender,
72         address recipient,
73         uint256 amount
74     ) external returns (bool);
75 
76     /**
77      * @dev Emitted when `value` tokens are moved from one account (`from`) to
78      * another (`to`).
79      *
80      * Note that `value` may be zero.
81      */
82     event Transfer(address indexed from, address indexed to, uint256 value);
83 
84     /**
85      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
86      * a call to {approve}. `value` is the new allowance.
87      */
88     event Approval(address indexed owner, address indexed spender, uint256 value);
89 }
90 
91 interface IERC20Metadata is IERC20{
92     /**
93      * @dev Returns the name of the token.
94      */
95     function name() external view returns (string memory);
96 
97     /**
98      * @dev Returns the symbol of the token.
99      */
100     function symbol() external view returns (string memory);
101 
102     /**
103      * @dev Returns the decimals places of the token.
104      */
105     function decimals() external view returns (uint8);
106 }
107 
108 contract ERC20 is Context, IERC20, IERC20Metadata {
109     mapping(address => uint256) private _balances;
110 
111     mapping(address => mapping(address => uint256)) private _allowances;
112 
113     uint256 private _totalSupply;
114 
115     string private _name;
116     string private _symbol;
117 
118     /**
119      * @dev Sets the values for {name} and {symbol}.
120      *
121      * All two of these values are immutable: they can only be set once during
122      * construction.
123      */
124     constructor(string memory name_, string memory symbol_) {
125         _name = name_;
126         _symbol = symbol_;
127     }
128 
129     /**
130      * @dev Returns the name of the token.
131      */
132     function name() public view virtual override returns (string memory) {
133         return _name;
134     }
135 
136     /**
137      * @dev Returns the symbol of the token, usually a shorter version of the
138      * name.
139      */
140     function symbol() public view virtual override returns (string memory) {
141         return _symbol;
142     }
143 
144     /**
145      * @dev Returns the number of decimals used to get its user representation.
146      * For example, if `decimals` equals `2`, a balance of `505` tokens should
147      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
148      *
149      * Tokens usually opt for a value of 18, imitating the relationship between
150      * Ether and Wei. This is the default value returned by this function, unless
151      * it's overridden.
152      *
153      * NOTE: This information is only used for _display_ purposes: it in
154      * no way affects any of the arithmetic of the contract, including
155      * {IERC20-balanceOf} and {IERC20-transfer}.
156      */
157     function decimals() public view virtual override returns (uint8) {
158         return 18;
159     }
160 
161     /**
162      * @dev See {IERC20-totalSupply}.
163      */
164     function totalSupply() public view virtual override returns (uint256) {
165         return _totalSupply;
166     }
167 
168     /**
169      * @dev See {IERC20-balanceOf}.
170      */
171     function balanceOf(address account) public view virtual override returns (uint256) {
172         return _balances[account];
173     }
174 
175     /**
176      * @dev See {IERC20-transfer}.
177      *
178      * Requirements:
179      *
180      * - `to` cannot be the zero address.
181      * - the caller must have a balance of at least `amount`.
182      */
183     function transfer(address to, uint256 amount) public virtual override returns (bool) {
184         address owner = _msgSender();
185         _transfer(owner, to, amount);
186         return true;
187     }
188 
189     /**
190      * @dev See {IERC20-allowance}.
191      */
192     function allowance(address owner, address spender) public view virtual override returns (uint256) {
193         return _allowances[owner][spender];
194     }
195 
196     /**
197      * @dev See {IERC20-approve}.
198      *
199      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
200      * `transferFrom`. This is semantically equivalent to an infinite approval.
201      *
202      * Requirements:
203      *
204      * - `spender` cannot be the zero address.
205      */
206     function approve(address spender, uint256 amount) public virtual override returns (bool) {
207         address owner = _msgSender();
208         _approve(owner, spender, amount);
209         return true;
210     }
211 
212     /**
213      * @dev See {IERC20-transferFrom}.
214      *
215      * Emits an {Approval} event indicating the updated allowance. This is not
216      * required by the EIP. See the note at the beginning of {ERC20}.
217      *
218      * NOTE: Does not update the allowance if the current allowance
219      * is the maximum `uint256`.
220      *
221      * Requirements:
222      *
223      * - `from` and `to` cannot be the zero address.
224      * - `from` must have a balance of at least `amount`.
225      * - the caller must have allowance for ``from``'s tokens of at least
226      * `amount`.
227      */
228     function transferFrom(address from, address to, uint256 amount) public virtual override returns (bool) {
229         address spender = _msgSender();
230         _spendAllowance(from, spender, amount);
231         _transfer(from, to, amount);
232         return true;
233     }
234 
235     /**
236      * @dev Atomically increases the allowance granted to `spender` by the caller.
237      *
238      * This is an alternative to {approve} that can be used as a mitigation for
239      * problems described in {IERC20-approve}.
240      *
241      * Emits an {Approval} event indicating the updated allowance.
242      *
243      * Requirements:
244      *
245      * - `spender` cannot be the zero address.
246      */
247     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
248         address owner = _msgSender();
249         _approve(owner, spender, allowance(owner, spender) + addedValue);
250         return true;
251     }
252 
253     /**
254      * @dev Atomically decreases the allowance granted to `spender` by the caller.
255      *
256      * This is an alternative to {approve} that can be used as a mitigation for
257      * problems described in {IERC20-approve}.
258      *
259      * Emits an {Approval} event indicating the updated allowance.
260      *
261      * Requirements:
262      *
263      * - `spender` cannot be the zero address.
264      * - `spender` must have allowance for the caller of at least
265      * `subtractedValue`.
266      */
267     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
268         address owner = _msgSender();
269         uint256 currentAllowance = allowance(owner, spender);
270         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
271         unchecked {
272             _approve(owner, spender, currentAllowance - subtractedValue);
273         }
274 
275         return true;
276     }
277 
278     /**
279      * @dev Moves `amount` of tokens from `from` to `to`.
280      *
281      * This internal function is equivalent to {transfer}, and can be used to
282      * e.g. implement automatic token fees, slashing mechanisms, etc.
283      *
284      * Emits a {Transfer} event.
285      *
286      * Requirements:
287      *
288      * - `from` cannot be the zero address.
289      * - `to` cannot be the zero address.
290      * - `from` must have a balance of at least `amount`.
291      */
292     function _transfer(address from, address to, uint256 amount) internal virtual {
293         require(from != address(0), "ERC20: transfer from the zero address");
294         require(to != address(0), "ERC20: transfer to the zero address");
295 
296         _beforeTokenTransfer(from, to, amount);
297 
298         uint256 fromBalance = _balances[from];
299         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
300         unchecked {
301             _balances[from] = fromBalance - amount;
302             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
303             // decrementing then incrementing.
304             _balances[to] += amount;
305         }
306 
307         emit Transfer(from, to, amount);
308 
309         _afterTokenTransfer(from, to, amount);
310     }
311 
312     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
313      * the total supply.
314      *
315      * Emits a {Transfer} event with `from` set to the zero address.
316      *
317      * Requirements:
318      *
319      * - `account` cannot be the zero address.
320      */
321     function _mint(address account, uint256 amount) internal virtual {
322         require(account != address(0), "ERC20: mint to the zero address");
323 
324         _beforeTokenTransfer(address(0), account, amount);
325 
326         _totalSupply += amount;
327         unchecked {
328             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
329             _balances[account] += amount;
330         }
331         emit Transfer(address(0), account, amount);
332 
333         _afterTokenTransfer(address(0), account, amount);
334     }
335 
336     /**
337      * @dev Destroys `amount` tokens from `account`, reducing the
338      * total supply.
339      *
340      * Emits a {Transfer} event with `to` set to the zero address.
341      *
342      * Requirements:
343      *
344      * - `account` cannot be the zero address.
345      * - `account` must have at least `amount` tokens.
346      */
347     function _burn(address account, uint256 amount) internal virtual {
348         require(account != address(0), "ERC20: burn from the zero address");
349 
350         _beforeTokenTransfer(account, address(0), amount);
351 
352         uint256 accountBalance = _balances[account];
353         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
354         unchecked {
355             _balances[account] = accountBalance - amount;
356             // Overflow not possible: amount <= accountBalance <= totalSupply.
357             _totalSupply -= amount;
358         }
359 
360         emit Transfer(account, address(0), amount);
361 
362         _afterTokenTransfer(account, address(0), amount);
363     }
364 
365     /**
366      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
367      *
368      * This internal function is equivalent to `approve`, and can be used to
369      * e.g. set automatic allowances for certain subsystems, etc.
370      *
371      * Emits an {Approval} event.
372      *
373      * Requirements:
374      *
375      * - `owner` cannot be the zero address.
376      * - `spender` cannot be the zero address.
377      */
378     function _approve(address owner, address spender, uint256 amount) internal virtual {
379         require(owner != address(0), "ERC20: approve from the zero address");
380         require(spender != address(0), "ERC20: approve to the zero address");
381 
382         _allowances[owner][spender] = amount;
383         emit Approval(owner, spender, amount);
384     }
385 
386     /**
387      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
388      *
389      * Does not update the allowance amount in case of infinite allowance.
390      * Revert if not enough allowance is available.
391      *
392      * Might emit an {Approval} event.
393      */
394     function _spendAllowance(address owner, address spender, uint256 amount) internal virtual {
395         uint256 currentAllowance = allowance(owner, spender);
396         if (currentAllowance != type(uint256).max) {
397             require(currentAllowance >= amount, "ERC20: insufficient allowance");
398             unchecked {
399                 _approve(owner, spender, currentAllowance - amount);
400             }
401         }
402     }
403 
404     /**
405      * @dev Hook that is called before any transfer of tokens. This includes
406      * minting and burning.
407      *
408      * Calling conditions:
409      *
410      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
411      * will be transferred to `to`.
412      * - when `from` is zero, `amount` tokens will be minted for `to`.
413      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
414      * - `from` and `to` are never both zero.
415      *
416      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
417      */
418     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual {}
419 
420     /**
421      * @dev Hook that is called after any transfer of tokens. This includes
422      * minting and burning.
423      *
424      * Calling conditions:
425      *
426      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
427      * has been transferred to `to`.
428      * - when `from` is zero, `amount` tokens have been minted for `to`.
429      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
430      * - `from` and `to` are never both zero.
431      *
432      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
433      */
434     function _afterTokenTransfer(address from, address to, uint256 amount) internal virtual {}
435 }
436 
437 contract Ownable is Context {
438     address private _owner;
439 
440     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
441     
442     constructor () {
443         address msgSender = _msgSender();
444         _owner = msgSender;
445         emit OwnershipTransferred(address(0), msgSender);
446     }
447 
448     function owner() public view returns (address) {
449         return _owner;
450     }
451 
452     modifier onlyOwner() {
453         require(_owner == _msgSender(), "Ownable: caller is not the owner");
454         _;
455     }
456 
457     function renounceOwnership() external virtual onlyOwner {
458         emit OwnershipTransferred(_owner, address(0));
459         _owner = address(0);
460     }
461 
462     function transferOwnership(address newOwner) public virtual onlyOwner {
463         require(newOwner != address(0), "Ownable: new owner is the zero address");
464         emit OwnershipTransferred(_owner, newOwner);
465         _owner = newOwner;
466     }
467 }
468 
469 library Address {
470     function isContract(address account) internal view returns (bool) {
471         return account.code.length > 0;
472     }
473 
474     function sendValue(address payable recipient, uint256 amount) internal {
475         require(address(this).balance >= amount, "Address: insufficient balance");
476 
477         (bool success, ) = recipient.call{value: amount}("");
478         require(success, "Address: unable to send value, recipient may have reverted");
479     }
480 
481     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
482         return functionCallWithValue(target, data, 0, "Address: low-level call failed");
483     }
484 
485     function functionCall(
486         address target,
487         bytes memory data,
488         string memory errorMessage
489     ) internal returns (bytes memory) {
490         return functionCallWithValue(target, data, 0, errorMessage);
491     }
492 
493     /**
494      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
495      * but also transferring `value` wei to `target`.
496      *
497      * Requirements:
498      *
499      * - the calling contract must have an ETH balance of at least `value`.
500      * - the called Solidity function must be `payable`.
501      *
502      * _Available since v3.1._
503      */
504     function functionCallWithValue(
505         address target,
506         bytes memory data,
507         uint256 value
508     ) internal returns (bytes memory) {
509         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
510     }
511 
512     /**
513      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
514      * with `errorMessage` as a fallback revert reason when `target` reverts.
515      *
516      * _Available since v3.1._
517      */
518     function functionCallWithValue(
519         address target,
520         bytes memory data,
521         uint256 value,
522         string memory errorMessage
523     ) internal returns (bytes memory) {
524         require(address(this).balance >= value, "Address: insufficient balance for call");
525         (bool success, bytes memory returndata) = target.call{value: value}(data);
526         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
527     }
528 
529     /**
530      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
531      * but performing a static call.
532      *
533      * _Available since v3.3._
534      */
535     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
536         return functionStaticCall(target, data, "Address: low-level static call failed");
537     }
538 
539     /**
540      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
541      * but performing a static call.
542      *
543      * _Available since v3.3._
544      */
545     function functionStaticCall(
546         address target,
547         bytes memory data,
548         string memory errorMessage
549     ) internal view returns (bytes memory) {
550         (bool success, bytes memory returndata) = target.staticcall(data);
551         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
552     }
553 
554     /**
555      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
556      * but performing a delegate call.
557      *
558      * _Available since v3.4._
559      */
560     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
561         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
562     }
563 
564     /**
565      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
566      * but performing a delegate call.
567      *
568      * _Available since v3.4._
569      */
570     function functionDelegateCall(
571         address target,
572         bytes memory data,
573         string memory errorMessage
574     ) internal returns (bytes memory) {
575         (bool success, bytes memory returndata) = target.delegatecall(data);
576         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
577     }
578 
579     /**
580      * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
581      * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
582      *
583      * _Available since v4.8._
584      */
585     function verifyCallResultFromTarget(
586         address target,
587         bool success,
588         bytes memory returndata,
589         string memory errorMessage
590     ) internal view returns (bytes memory) {
591         if (success) {
592             if (returndata.length == 0) {
593                 // only check isContract if the call was successful and the return data is empty
594                 // otherwise we already know that it was a contract
595                 require(isContract(target), "Address: call to non-contract");
596             }
597             return returndata;
598         } else {
599             _revert(returndata, errorMessage);
600         }
601     }
602 
603     /**
604      * @dev Tool to verify that a low level call was successful, and revert if it wasn't, either by bubbling the
605      * revert reason or using the provided one.
606      *
607      * _Available since v4.3._
608      */
609     function verifyCallResult(
610         bool success,
611         bytes memory returndata,
612         string memory errorMessage
613     ) internal pure returns (bytes memory) {
614         if (success) {
615             return returndata;
616         } else {
617             _revert(returndata, errorMessage);
618         }
619     }
620 
621     function _revert(bytes memory returndata, string memory errorMessage) private pure {
622         // Look for revert reason and bubble it up if present
623         if (returndata.length > 0) {
624             // The easiest way to bubble the revert reason is using memory via assembly
625             /// @solidity memory-safe-assembly
626             assembly {
627                 let returndata_size := mload(returndata)
628                 revert(add(32, returndata), returndata_size)
629             }
630         } else {
631             revert(errorMessage);
632         }
633     }
634 }
635 
636 library SafeERC20 {
637     using Address for address;
638 
639     function safeTransfer(IERC20 token, address to, uint256 value) internal {
640         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
641     }
642 
643     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
644         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
645     }
646 
647     function _callOptionalReturn(IERC20 token, bytes memory data) private {
648         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
649         if (returndata.length > 0) {
650             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
651         }
652     }
653 
654     function safeApprove(IERC20 token, address spender, uint256 value) internal {
655         // safeApprove should only be called when setting an initial allowance,
656         // or when resetting it to zero. To increase and decrease it, use
657         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
658         require(
659             (value == 0) || (token.allowance(address(this), spender) == 0),
660             "SafeERC20: approve from non-zero to non-zero allowance"
661         );
662         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
663     }
664 }
665 
666 interface IDexRouter {
667     function factory() external pure returns (address);
668     function WETH() external pure returns (address);
669     function swapExactTokensForETHSupportingFeeOnTransferTokens(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline) external;
670     function swapExactETHForTokensSupportingFeeOnTransferTokens(uint amountOutMin, address[] calldata path, address to, uint deadline) external payable;
671     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline) external payable returns (uint[] memory amounts);
672     function swapExactTokensForTokensSupportingFeeOnTransferTokens(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline) external;
673     function swapTokensForExactTokens(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline) external returns (uint[] memory amounts);
674     function addLiquidityETH(address token, uint256 amountTokenDesired, uint256 amountTokenMin, uint256 amountETHMin, address to, uint256 deadline) external payable returns (uint256 amountToken, uint256 amountETH, uint256 liquidity);
675     function addLiquidity(address tokenA, address tokenB, uint amountADesired, uint amountBDesired, uint amountAMin, uint amountBMin, address to, uint deadline) external returns (uint amountA, uint amountB, uint liquidity);
676     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
677 }
678 
679 interface IDexFactory {
680     function createPair(address tokenA, address tokenB) external returns (address pair);
681 }
682 
683 contract SuperMemeBros is ERC20, Ownable {
684 
685     mapping (address => bool) public exemptFromFees;
686     mapping (address => bool) public exemptFromLimits;
687 
688     bool public tradingActive;
689 
690     mapping (address => bool) public isAMMPair;
691 
692     uint256 public maxTransaction;
693     uint256 public maxWallet;
694 
695     address public taxReceiverAddress;
696 
697     uint256 public buyTotalTax;
698 
699     uint256 public sellTotalTax;
700 
701     bool public limitsInEffect = true;
702 
703     bool public swapEnabled = true;
704     bool private swapping;
705     uint256 public swapTokensAtAmt;
706 
707     address public lpPair;
708     IDexRouter public dexRouter;
709 
710     uint256 public constant FEE_DIVISOR = 10000;
711 
712     // events
713 
714     event UpdatedMaxTransaction(uint256 newMax);
715     event UpdatedMaxWallet(uint256 newMax);
716     event SetExemptFromFees(address _address, bool _isExempt);
717     event SetExemptFromLimits(address _address, bool _isExempt);
718     event RemovedLimits();
719     event UpdatedBuyTax(uint256 newAmt);
720     event UpdatedSellTax(uint256 newAmt);
721 
722     // constructor
723 
724     constructor(string memory _name, string memory _symbol, uint256 _totalSupplyInTokens)
725         ERC20(_name, _symbol)
726     {   
727         address newOwner = msg.sender;
728         _mint(newOwner, _totalSupplyInTokens * (10** decimals()));
729 
730         address _v2Router;
731 
732         // @dev assumes WETH pair
733         if(block.chainid == 1){
734             _v2Router = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
735         } else if(block.chainid == 5){
736             _v2Router = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
737         } else if(block.chainid == 97){
738             _v2Router = 0xD99D1c33F9fC3444f8101754aBC46c52416550D1;
739         } else if(block.chainid == 42161){
740             _v2Router = 0x1b02dA8Cb0d097eB8D57A175b88c7D8b47997506;
741         } else {
742             revert("Chain not configured");
743         }
744 
745         dexRouter = IDexRouter(_v2Router);
746 
747         maxTransaction = totalSupply() * 5 / 1000;
748         maxWallet = totalSupply() * 15 / 1000;
749         swapTokensAtAmt = totalSupply() * 25 / 100000;
750 
751         taxReceiverAddress = 0x392FdBb24D55019eBB3feFAEa5E2DD29c564F6a2;
752 
753         buyTotalTax = 1200;
754 
755         sellTotalTax = 1200;
756 
757         lpPair = IDexFactory(dexRouter.factory()).createPair(address(this), dexRouter.WETH());
758 
759         isAMMPair[lpPair] = true;
760 
761         exemptFromLimits[lpPair] = true;
762         exemptFromLimits[msg.sender] = true;
763         exemptFromLimits[address(this)] = true;
764     
765         exemptFromFees[msg.sender] = true;
766         exemptFromFees[address(this)] = true;
767         exemptFromFees[0x1d1417750408FA6Ebb2B6992a742472eFde89298] = true; // LS
768  
769         _approve(address(this), address(dexRouter), type(uint256).max);
770         _approve(address(msg.sender), address(dexRouter), totalSupply());
771     }
772 
773     function _transfer(
774         address from,
775         address to,
776         uint256 amount
777     ) internal virtual override {
778 
779         if(exemptFromFees[from] || exemptFromFees[to]){
780             super._transfer(from,to,amount);
781             return;
782         }
783         
784         checkLimits(from, to, amount);
785 
786         amount -= handleTax(from, to, amount);
787 
788         super._transfer(from,to,amount);
789     }
790 
791     function checkLimits(address from, address to, uint256 amount) internal view {
792 
793         require(tradingActive, "Trading not active");
794 
795         if(limitsInEffect){
796             // buy
797             if (isAMMPair[from] && !exemptFromLimits[to]) {
798                 require(amount <= maxTransaction, "Buy transfer amount exceeded.");
799                 require(amount + balanceOf(to) <= maxWallet, "Unable to exceed Max Wallet");
800             } 
801             // sell
802             else if (isAMMPair[to] && !exemptFromLimits[from]) {
803                 require(amount <= maxTransaction, "Sell transfer amount exceeds the maxTransactionAmt.");
804             }
805             else if(!exemptFromLimits[to]) {
806                 require(amount + balanceOf(to) <= maxWallet, "Unable to exceed Max Wallet");
807             }
808         }
809     }
810 
811     function handleTax(address from, address to, uint256 amount) internal returns (uint256){
812 
813         if(balanceOf(address(this)) >= swapTokensAtAmt && swapEnabled && !swapping && isAMMPair[to]) {
814             swapping = true;
815             swapBack();
816             swapping = false;
817         }
818         
819         uint256 tax = 0;
820 
821         // on sell
822         if (isAMMPair[to] && sellTotalTax > 0){
823             tax = amount * sellTotalTax / FEE_DIVISOR;
824         }
825 
826         // on buy
827         else if(isAMMPair[from] && buyTotalTax > 0) {
828             tax = amount * buyTotalTax / FEE_DIVISOR;
829 
830         }
831         
832         if(tax > 0){    
833             super._transfer(from, address(this), tax);
834         }
835 
836         return tax;
837     }
838 
839     function swapTokensForETH(uint256 tokenAmt) private {
840 
841         address[] memory path = new address[](2);
842         path[0] = address(this);
843         path[1] = address(dexRouter.WETH());
844 
845         dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
846             tokenAmt,
847             0,
848             path,
849             address(taxReceiverAddress),
850             block.timestamp
851         );
852     }
853 
854 
855     function swapBack() private {
856 
857         uint256 contractBalance = balanceOf(address(this));
858 
859         if(contractBalance > swapTokensAtAmt * 40){
860             contractBalance = swapTokensAtAmt * 40;
861         }
862         
863         swapTokensForETH(contractBalance);
864     }
865 
866     // owner functions
867     function setExemptFromFees(address _address, bool _isExempt) external onlyOwner {
868         require(_address != address(0), "Zero Address");
869         exemptFromFees[_address] = _isExempt;
870         emit SetExemptFromFees(_address, _isExempt);
871     }
872 
873     function setExemptFromLimits(address _address, bool _isExempt) external onlyOwner {
874         require(_address != address(0), "Zero Address");
875         if(!_isExempt){
876             require(_address != lpPair, "Cannot remove pair");
877         }
878         exemptFromLimits[_address] = _isExempt;
879         emit SetExemptFromLimits(_address, _isExempt);
880     }
881 
882     function updateMaxTransaction(uint256 newNumInTokens) external onlyOwner {
883         require(newNumInTokens >= (totalSupply() * 5 / 1000)/(10**decimals()), "Too low");
884         maxTransaction = newNumInTokens * (10**decimals());
885         emit UpdatedMaxTransaction(maxTransaction);
886     }
887 
888     function updateMaxWallet(uint256 newNumInTokens) external onlyOwner {
889         require(newNumInTokens >= (totalSupply() * 15 / 1000)/(10**decimals()), "Too low");
890         maxWallet = newNumInTokens * (10**decimals());
891         emit UpdatedMaxWallet(maxWallet);
892     }
893 
894     function updateBuyTax(uint256 _taxWithTwoDecimals) external onlyOwner {
895         buyTotalTax = _taxWithTwoDecimals;
896         require(buyTotalTax <= 1200, "Keep tax below 12%");
897         emit UpdatedBuyTax(buyTotalTax);
898     }
899 
900     function updateSellTax(uint256 _taxWithTwoDecimals) external onlyOwner {
901         sellTotalTax = _taxWithTwoDecimals;
902         require(sellTotalTax <= 1200, "Keep tax below 12%");
903         emit UpdatedSellTax(sellTotalTax);
904     }
905 
906     function enableTrading() external onlyOwner {
907         tradingActive = true;
908     }
909 
910     function removeLimits() external onlyOwner {
911         limitsInEffect = false;
912         maxTransaction = totalSupply();
913         maxWallet = totalSupply();
914         emit RemovedLimits();
915     }
916 
917     function airdropToWallets(address[] calldata wallets, uint256[] calldata amountsInWei) external onlyOwner {
918         require(wallets.length == amountsInWei.length, "arrays length mismatch");
919         for(uint256 i = 0; i < wallets.length; i++){
920             super._transfer(msg.sender, wallets[i], amountsInWei[i]);
921         }
922     }
923 
924     function rescueTokens(address _token, address _to) external onlyOwner {
925         require(_token != address(0), "_token address cannot be 0");
926         uint256 _contractBalance = IERC20(_token).balanceOf(address(this));
927         SafeERC20.safeTransfer(IERC20(_token),_to, _contractBalance);
928     }
929 
930     function updateTaxAddress(address _address) external onlyOwner {
931         require(_address != address(0), "zero address");
932         taxReceiverAddress = _address;
933     }
934 }