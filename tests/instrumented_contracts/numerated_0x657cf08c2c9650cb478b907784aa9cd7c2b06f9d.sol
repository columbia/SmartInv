1 pragma solidity 0.8.17;
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
666 
667 contract TokenHandler is Ownable {
668     function sendTokenToOwner(address token) external onlyOwner {
669         if(IERC20(token).balanceOf(address(this)) > 0){
670             SafeERC20.safeTransfer(IERC20(token),owner(), IERC20(token).balanceOf(address(this)));
671         }
672     }
673 }
674 
675 interface IWETH {
676     function deposit() external payable; 
677 }
678 
679 interface ILpPair {
680     function sync() external;
681 }
682 
683 interface IDexRouter {
684     function factory() external pure returns (address);
685     function WETH() external pure returns (address);
686     function swapExactTokensForETHSupportingFeeOnTransferTokens(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline) external;
687     function swapExactETHForTokensSupportingFeeOnTransferTokens(uint amountOutMin, address[] calldata path, address to, uint deadline) external payable;
688     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline) external payable returns (uint[] memory amounts);
689     function swapExactTokensForTokensSupportingFeeOnTransferTokens(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline) external;
690     function swapTokensForExactTokens(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline) external returns (uint[] memory amounts);
691     function addLiquidityETH(address token, uint256 amountTokenDesired, uint256 amountTokenMin, uint256 amountETHMin, address to, uint256 deadline) external payable returns (uint256 amountToken, uint256 amountETH, uint256 liquidity);
692     function addLiquidity(address tokenA, address tokenB, uint amountADesired, uint amountBDesired, uint amountAMin, uint amountBMin, address to, uint deadline) external returns (uint amountA, uint amountB, uint liquidity);
693     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
694 }
695 
696 interface IDexFactory {
697     function createPair(address tokenA, address tokenB) external returns (address pair);
698 }
699 
700 contract ZevToken is ERC20, Ownable {
701 
702     mapping (address => bool) public exemptFromFees;
703     mapping (address => bool) public exemptFromLimits;
704 
705     uint256 public launchTime_;
706     bool public allowEarlyZ3Buyers_;
707     mapping (address => bool) verifiedAddress;
708     uint256 public constant verificationDuration = 20 minutes;
709     uint256 public constant z3BuyerDuration = 2 minutes;
710 
711     mapping (address => bool) public isAMMPair;
712 
713     IERC20Metadata public immutable Z3TOKEN;
714 
715     uint256 public maxTransaction;
716     uint256 public maxWallet;
717 
718     address public projectAddress;
719     address public zentinelAddress;
720 
721     uint256 public buyTotalTax;
722     uint256 public buyProjectTax;
723     uint256 public buyLiquidityTax;
724     uint256 public buyBurnTax;
725 
726     uint256 public initialBuyTax;
727 
728     uint256 public sellTotalTax;
729     uint256 public sellProjectTax;
730     uint256 public sellLiquidityTax;
731     uint256 public sellBurnTax;
732     
733     uint256 public initialSellTax;
734 
735     uint256 public tokensForProject;
736     uint256 public tokensForLiquidity;
737     uint256 public tokensForBurn;
738     
739     TokenHandler public immutable tokenHandler;
740 
741     bool public limitsInEffect = true;
742     bool public lpAdded;
743 
744     bool private swapping;
745     uint256 public swapTokensAtAmt;
746 
747     address public lpPair;
748     IDexRouter public dexRouter;
749     IERC20Metadata public pairedToken;
750     IWETH public WETH;
751 
752     // events
753 
754     event UpdatedMaxTransaction(uint256 newMax);
755     event UpdatedMaxWallet(uint256 newMax);
756     event SetExemptFromFees(address _address, bool _isExempt);
757     event SetExemptFromLimits(address _address, bool _isExempt);
758     event RemovedLimits();
759     event UpdatedBuyTax(uint256 newAmt);
760     event UpdatedSellTax(uint256 newAmt);
761 
762     // constructor
763 
764     constructor(StructsLibrary.CreationParams memory params, address _zentinel)
765         
766         ERC20(params._name, params._symbol)
767     {
768         _mint(msg.sender, params._supply);
769         Z3TOKEN = IERC20Metadata(params._Z3TOKEN);
770         
771 
772         zentinelAddress = _zentinel;
773 
774         launchTime_ = params._launchTime;
775         allowEarlyZ3Buyers_ = params._allowZ3EarlyBuyers;
776 
777         maxTransaction = totalSupply() * params._maxTransaction / 10000;
778         maxWallet = totalSupply() * params._maxWallet / 10000;
779         swapTokensAtAmt = totalSupply() * 5 / 10000;
780 
781         projectAddress = params._projectAddress;
782 
783         if(params._buyTaxes.length == 3){
784             buyProjectTax = params._buyTaxes[0];
785             buyLiquidityTax = params._buyTaxes[1];
786             buyBurnTax = params._buyTaxes[2];
787             buyTotalTax = buyProjectTax + buyLiquidityTax + buyBurnTax;
788             initialBuyTax = buyTotalTax;
789             require(initialBuyTax <= 8, "Tax too high");
790         }
791 
792         if(params._sellTaxes.length == 3){
793             sellProjectTax = params._sellTaxes[0];
794             sellLiquidityTax = params._sellTaxes[1];
795             sellBurnTax = params._sellTaxes[2];
796             sellTotalTax = sellProjectTax + sellLiquidityTax + sellBurnTax;
797             initialSellTax = sellTotalTax;
798             require(initialSellTax <= 8, "Tax too high");
799         }
800 
801         pairedToken = IERC20Metadata(params._pairedToken);
802         require(pairedToken.decimals()  > 0 , "Incorrect liquidity token");
803 
804         tokenHandler = new TokenHandler();
805         dexRouter = IDexRouter(params._router);
806         lpPair = IDexFactory(dexRouter.factory()).createPair(address(this), address(pairedToken));
807 
808         WETH = IWETH(dexRouter.WETH());
809         isAMMPair[lpPair] = true;
810 
811         exemptFromLimits[lpPair] = true;
812         exemptFromLimits[address(this)] = true;
813         exemptFromLimits[address(0xdead)] = true;
814 
815         exemptFromFees[msg.sender] = true;
816         exemptFromFees[address(this)] = true;
817         exemptFromLimits[address(0xdead)] = true;
818 
819         _approve(address(owner()), address(dexRouter), totalSupply());
820         _approve(address(this), address(dexRouter), type(uint256).max);
821     }
822 
823     function _transfer(
824         address from,
825         address to,
826         uint256 amount
827     ) internal virtual override {
828         
829         if(limitsInEffect){
830             checkLimits(from, to, amount);
831         }
832 
833         if(!exemptFromFees[from] && !exemptFromFees[to]){
834             amount -= handleTax(from, to, amount);
835         }
836 
837         super._transfer(from,to,amount);
838     }
839 
840     function checkLimits(address from, address to, uint256 amount) internal {
841         if(!lpAdded && from == owner() && to == lpPair){
842             lpAdded = true;
843             return;
844         }
845 
846         if(!exemptFromFees[from] && !exemptFromFees[to]){
847             require(block.timestamp >= launchTime_, "Not Launched Yet");
848         }
849         
850         if(allowEarlyZ3Buyers_ && block.timestamp <= launchTime_ + z3BuyerDuration){
851             checkZ3Eligible(to, amount); 
852         }
853 
854         if(!isAMMPair[to] && block.timestamp <= launchTime_ + verificationDuration){
855             require(verifiedAddress[to] && to == tx.origin, "Buy via Zev dapp only");
856         }
857 
858         // buy
859         if (isAMMPair[from] && !exemptFromLimits[to]) {
860             require(amount <= maxTransaction, "Max Tx exceeded");
861             require(amount + balanceOf(to) <= maxWallet, "Max Wallet Exceeded");
862         } 
863         // sell
864         else if (isAMMPair[to] && !exemptFromLimits[from]) {
865             require(amount <= maxTransaction, "Max Tx exceeded");
866         }
867         else if(!exemptFromLimits[to]) {
868             require(amount + balanceOf(to) <= maxWallet, "Max Wallet Exceeded");
869         }
870     }
871 
872     function handleTax(address from, address to, uint256 amount) internal returns (uint256){
873         uint256 contractTokenBalance = balanceOf(address(this));
874         
875         bool canSwap = contractTokenBalance >= swapTokensAtAmt;
876 
877         if(canSwap && !swapping && isAMMPair[to]) {
878             swapBack();
879         }
880         
881         uint256 tax = 0;
882 
883         // on sell
884         if (isAMMPair[to] && sellTotalTax > 0){
885             tax = amount * sellTotalTax / 100;
886             tokensForLiquidity += tax * sellLiquidityTax / sellTotalTax;
887             tokensForProject += tax * sellProjectTax / sellTotalTax;
888             tokensForBurn += tax * sellBurnTax / sellTotalTax;
889         }
890 
891         // on buy
892         else if(isAMMPair[from] && buyTotalTax > 0) {
893             tax = amount * buyTotalTax / 100;
894             tokensForProject += tax * buyProjectTax / buyTotalTax;
895             tokensForLiquidity += tax * buyLiquidityTax / buyTotalTax;
896             tokensForBurn += tax * buyBurnTax / buyTotalTax;
897         }
898         
899         if(tax > 0){    
900             super._transfer(from, address(this), tax);
901         }
902         
903         return tax;
904     }
905 
906     function swapTokensForPAIREDTOKEN(uint256 tokenAmt) private {
907 
908         // generate the uniswap pair path of token -> weth
909         address[] memory path = new address[](2);
910         path[0] = address(this);
911         path[1] = address(pairedToken);
912 
913         // make the swap
914         dexRouter.swapExactTokensForTokensSupportingFeeOnTransferTokens(
915             tokenAmt,
916             0, // accept any amt of ETH
917             path,
918             address(tokenHandler),
919             block.timestamp
920         );
921 
922         tokenHandler.sendTokenToOwner(address(pairedToken));
923     }
924 
925     function swapBack() private {
926 
927         uint256 contractBalance = balanceOf(address(this));
928         uint256 totalTokensToSwap = tokensForLiquidity + tokensForProject + tokensForBurn;
929         
930         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
931 
932         if(contractBalance > swapTokensAtAmt * 40){
933             contractBalance = swapTokensAtAmt * 40;
934         }
935         
936         if(tokensForLiquidity > 0){
937             uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap;
938             super._transfer(address(this), lpPair, liquidityTokens);
939             try ILpPair(lpPair).sync(){} catch {}
940             contractBalance -= liquidityTokens;
941             totalTokensToSwap -= tokensForLiquidity;
942             tokensForLiquidity = 0;
943         }
944 
945         if(tokensForBurn > 0){
946             uint256 burnTokens = contractBalance * tokensForBurn / totalTokensToSwap;
947             super._transfer(address(this), address(0xdead), burnTokens);
948             contractBalance -= burnTokens;
949             totalTokensToSwap -= burnTokens;
950             tokensForBurn = 0;
951         }
952 
953         tokensForProject = 0;
954         
955         if(totalTokensToSwap > 0){
956             swapTokensForPAIREDTOKEN(contractBalance);
957             
958             if(pairedToken.balanceOf(address(this)) > 0){
959                 SafeERC20.safeTransfer(pairedToken, projectAddress, pairedToken.balanceOf(address(this)));
960             }
961         }
962     }
963 
964 
965     // views
966 
967     function checkZ3Eligible(address holder, uint256 amountRequestedTobuy) internal view {
968         require(amountRequestedTobuy <= maxBuyForZ3HolderAtLaunch(holder), "Too much"); 
969     }
970     
971     function maxBuyForZ3HolderAtLaunch(address holder) public view returns (uint256) { // Can buy up to 10% of relative Z3 holdsings.  i.e. if you hold 1% of Z3, you can buy 0.1% of token in advance.
972         uint256 holderZ3Percent = Z3TOKEN.balanceOf(holder) * 10000 / Z3TOKEN.totalSupply();
973         uint256 currentHoldings = balanceOf(holder);
974         uint256 maxWalletForLaunch = holderZ3Percent * totalSupply() / 100000;
975         return (maxWalletForLaunch - currentHoldings);
976     }
977 
978     // Zentinel Function
979     function setVerified(address _address) external onlyZentinel {
980         verifiedAddress[_address] = true;
981     }
982 
983     // owner functions
984 
985     function setExemptFromFees(address _address, bool _isExempt) external ownerCanChange {
986         require(_address != address(0), "Zero Address");
987         exemptFromFees[_address] = _isExempt;
988         emit SetExemptFromFees(_address, _isExempt);
989     }
990 
991     function setExemptFromLimits(address _address, bool _isExempt) external ownerCanChange {
992         require(_address != address(0), "Zero Address");
993         if(!_isExempt){
994             require(_address != lpPair, "Cannot remove pair");
995         }
996         exemptFromLimits[_address] = _isExempt;
997         emit SetExemptFromLimits(_address, _isExempt);
998     }
999 
1000     function updateMaxTransaction(uint256 newNumInTokens) external ownerCanChange {
1001         require(newNumInTokens >= (totalSupply() * 25 / 10000)/(10**decimals()), "Too low");
1002         maxTransaction = newNumInTokens * (10**decimals());
1003         emit UpdatedMaxTransaction(maxTransaction);
1004     }
1005 
1006     function updateMaxWallet(uint256 newNumInTokens) external ownerCanChange {
1007         require(newNumInTokens >= (totalSupply() * 25 / 10000)/(10**decimals()), "Too low");
1008         maxWallet = newNumInTokens * (10**decimals());
1009         emit UpdatedMaxWallet(maxWallet);
1010     }
1011 
1012     function updateBuyTax(uint256 _projectTax, uint256 _liquidityTax, uint256 _burnTax) external ownerCanChange {
1013         buyProjectTax = _projectTax;
1014         buyLiquidityTax = _liquidityTax;
1015         buyBurnTax = _burnTax;
1016         buyTotalTax = buyProjectTax + buyLiquidityTax + buyBurnTax;
1017         require(buyTotalTax <= initialBuyTax, "Keep tax below initial tax");
1018         emit UpdatedBuyTax(buyTotalTax);
1019     }
1020 
1021     function updateSellTax(uint256 _projectTax, uint256 _liquidityTax, uint256 _burnTax) external ownerCanChange {
1022         sellProjectTax = _projectTax;
1023         sellLiquidityTax = _liquidityTax;
1024         sellBurnTax = _burnTax;
1025         sellTotalTax = sellProjectTax + sellLiquidityTax + sellBurnTax;
1026         require(sellTotalTax <= initialSellTax, "Keep tax below initial tax");
1027         emit UpdatedSellTax(sellTotalTax);
1028     }
1029 
1030     function removeLimits() external ownerCanChange {
1031         limitsInEffect = false;
1032         emit RemovedLimits();
1033     }
1034 
1035     function airdropToWallets(address[] calldata wallets, uint256[] calldata amountsInWei) external onlyOwner {
1036         require(wallets.length == amountsInWei.length, "arrays length mismatch");
1037         for(uint256 i = 0; i < wallets.length; i++){
1038             super._transfer(msg.sender, wallets[i], amountsInWei[i]);
1039         }
1040     }
1041 
1042     function rescueTokens(address _token, address _to) external onlyOwner {
1043         uint256 _contractBalance = IERC20(_token).balanceOf(address(this));
1044         SafeERC20.safeTransfer(IERC20(_token),_to, _contractBalance);
1045     }
1046 
1047     // modifiers
1048     modifier ownerCanChange {
1049         require(owner() == _msgSender(), "caller not owner");
1050         require(block.timestamp >= launchTime_ + verificationDuration, "Too early");
1051         _;
1052     }
1053 
1054     modifier onlyZentinel {
1055         require(zentinelAddress == _msgSender(), "Caller not Zentinel");
1056         _;
1057     }
1058 
1059     function updateProjectAddress(address _address) external ownerCanChange {
1060         require(_address != address(0), "zero address");
1061         projectAddress = _address;
1062     }
1063 }
1064 
1065 interface ITokenFactory {
1066     function generateToken(StructsLibrary.CreationParams memory params)
1067         external 
1068         payable returns (address);
1069 }
1070 
1071 interface ITokenLocker {
1072     function lock(
1073         address owner,
1074         address token,
1075         bool isLpToken,
1076         uint256 amount,
1077         uint256 unlockDate,
1078         string memory description
1079     ) external returns (uint256 lockId);
1080 }
1081 
1082 library StructsLibrary {
1083     struct CreationParams {
1084         address _tokenFactory;
1085         uint256 _launchTime;
1086         bool _allowZ3EarlyBuyers;
1087         string _name; 
1088         string _symbol;
1089         uint256 _supply;
1090         uint256 _maxWallet;
1091         uint256 _maxTransaction;
1092         address _pairedToken;
1093         uint256 _liquidityPercent;
1094         address _newOwner;
1095         address[] _airdropWallets;
1096         uint256[] _airdropAmounts;
1097         string _referralCode;
1098         uint256[] _buyTaxes; // limit to 3 taxes ("project" tax, lp tax, burn tax)
1099         uint256[] _sellTaxes; // limit to 3 taxes ("project" tax, lp tax, burn tax)
1100         address _verifier;
1101         address _Z3TOKEN;
1102         address _router;
1103         uint256 _amountPairedTokenIfNotEth;
1104         address _projectAddress;
1105         uint256[] _spareUints;
1106         bool[] _spareBools;
1107         address[] _spareAddresses;
1108     }
1109 }