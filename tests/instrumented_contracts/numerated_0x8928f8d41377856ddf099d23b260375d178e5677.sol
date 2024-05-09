1 pragma solidity 0.8.20;
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
296         uint256 fromBalance = _balances[from];
297         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
298         unchecked {
299             _balances[from] = fromBalance - amount;
300             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
301             // decrementing then incrementing.
302             _balances[to] += amount;
303         }
304 
305         emit Transfer(from, to, amount);
306     }
307 
308     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
309      * the total supply.
310      *
311      * Emits a {Transfer} event with `from` set to the zero address.
312      *
313      * Requirements:
314      *
315      * - `account` cannot be the zero address.
316      */
317     function _mint(address account, uint256 amount) internal virtual {
318         require(account != address(0), "ERC20: mint to the zero address");
319 
320         _totalSupply += amount;
321         unchecked {
322             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
323             _balances[account] += amount;
324         }
325         emit Transfer(address(0), account, amount);
326     }
327 
328     /**
329      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
330      *
331      * This internal function is equivalent to `approve`, and can be used to
332      * e.g. set automatic allowances for certain subsystems, etc.
333      *
334      * Emits an {Approval} event.
335      *
336      * Requirements:
337      *
338      * - `owner` cannot be the zero address.
339      * - `spender` cannot be the zero address.
340      */
341     function _approve(address owner, address spender, uint256 amount) internal virtual {
342         require(owner != address(0), "ERC20: approve from the zero address");
343         require(spender != address(0), "ERC20: approve to the zero address");
344 
345         _allowances[owner][spender] = amount;
346         emit Approval(owner, spender, amount);
347     }
348 
349     /**
350      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
351      *
352      * Does not update the allowance amount in case of infinite allowance.
353      * Revert if not enough allowance is available.
354      *
355      * Might emit an {Approval} event.
356      */
357     function _spendAllowance(address owner, address spender, uint256 amount) internal virtual {
358         uint256 currentAllowance = allowance(owner, spender);
359         if (currentAllowance != type(uint256).max) {
360             require(currentAllowance >= amount, "ERC20: insufficient allowance");
361             unchecked {
362                 _approve(owner, spender, currentAllowance - amount);
363             }
364         }
365     }
366 }
367 
368 contract Ownable is Context {
369     address private _owner;
370 
371     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
372     
373     constructor () {
374         address msgSender = _msgSender();
375         _owner = msgSender;
376         emit OwnershipTransferred(address(0), msgSender);
377     }
378 
379     function owner() public view returns (address) {
380         return _owner;
381     }
382 
383     modifier onlyOwner() {
384         require(_owner == _msgSender(), "Ownable: caller is not the owner");
385         _;
386     }
387 
388     function renounceOwnership() external virtual onlyOwner {
389         emit OwnershipTransferred(_owner, address(0));
390         _owner = address(0);
391     }
392 
393     function transferOwnership(address newOwner) public virtual onlyOwner {
394         require(newOwner != address(0), "Ownable: new owner is the zero address");
395         emit OwnershipTransferred(_owner, newOwner);
396         _owner = newOwner;
397     }
398 }
399 
400 library Address {
401     function isContract(address account) internal view returns (bool) {
402         return account.code.length > 0;
403     }
404 
405     function sendValue(address payable recipient, uint256 amount) internal {
406         require(address(this).balance >= amount, "Address: insufficient balance");
407 
408         (bool success, ) = recipient.call{value: amount}("");
409         require(success, "Address: unable to send value, recipient may have reverted");
410     }
411 
412     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
413         return functionCallWithValue(target, data, 0, "Address: low-level call failed");
414     }
415 
416     function functionCall(
417         address target,
418         bytes memory data,
419         string memory errorMessage
420     ) internal returns (bytes memory) {
421         return functionCallWithValue(target, data, 0, errorMessage);
422     }
423 
424     /**
425      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
426      * but also transferring `value` wei to `target`.
427      *
428      * Requirements:
429      *
430      * - the calling contract must have an ETH balance of at least `value`.
431      * - the called Solidity function must be `payable`.
432      *
433      * _Available since v3.1._
434      */
435     function functionCallWithValue(
436         address target,
437         bytes memory data,
438         uint256 value
439     ) internal returns (bytes memory) {
440         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
441     }
442 
443     /**
444      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
445      * with `errorMessage` as a fallback revert reason when `target` reverts.
446      *
447      * _Available since v3.1._
448      */
449     function functionCallWithValue(
450         address target,
451         bytes memory data,
452         uint256 value,
453         string memory errorMessage
454     ) internal returns (bytes memory) {
455         require(address(this).balance >= value, "Address: insufficient balance for call");
456         (bool success, bytes memory returndata) = target.call{value: value}(data);
457         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
458     }
459 
460     /**
461      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
462      * but performing a static call.
463      *
464      * _Available since v3.3._
465      */
466     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
467         return functionStaticCall(target, data, "Address: low-level static call failed");
468     }
469 
470     /**
471      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
472      * but performing a static call.
473      *
474      * _Available since v3.3._
475      */
476     function functionStaticCall(
477         address target,
478         bytes memory data,
479         string memory errorMessage
480     ) internal view returns (bytes memory) {
481         (bool success, bytes memory returndata) = target.staticcall(data);
482         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
483     }
484 
485     /**
486      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
487      * but performing a delegate call.
488      *
489      * _Available since v3.4._
490      */
491     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
492         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
493     }
494 
495     /**
496      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
497      * but performing a delegate call.
498      *
499      * _Available since v3.4._
500      */
501     function functionDelegateCall(
502         address target,
503         bytes memory data,
504         string memory errorMessage
505     ) internal returns (bytes memory) {
506         (bool success, bytes memory returndata) = target.delegatecall(data);
507         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
508     }
509 
510     /**
511      * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
512      * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
513      *
514      * _Available since v4.8._
515      */
516     function verifyCallResultFromTarget(
517         address target,
518         bool success,
519         bytes memory returndata,
520         string memory errorMessage
521     ) internal view returns (bytes memory) {
522         if (success) {
523             if (returndata.length == 0) {
524                 // only check isContract if the call was successful and the return data is empty
525                 // otherwise we already know that it was a contract
526                 require(isContract(target), "Address: call to non-contract");
527             }
528             return returndata;
529         } else {
530             _revert(returndata, errorMessage);
531         }
532     }
533 
534     /**
535      * @dev Tool to verify that a low level call was successful, and revert if it wasn't, either by bubbling the
536      * revert reason or using the provided one.
537      *
538      * _Available since v4.3._
539      */
540     function verifyCallResult(
541         bool success,
542         bytes memory returndata,
543         string memory errorMessage
544     ) internal pure returns (bytes memory) {
545         if (success) {
546             return returndata;
547         } else {
548             _revert(returndata, errorMessage);
549         }
550     }
551 
552     function _revert(bytes memory returndata, string memory errorMessage) private pure {
553         // Look for revert reason and bubble it up if present
554         if (returndata.length > 0) {
555             // The easiest way to bubble the revert reason is using memory via assembly
556             /// @solidity memory-safe-assembly
557             assembly {
558                 let returndata_size := mload(returndata)
559                 revert(add(32, returndata), returndata_size)
560             }
561         } else {
562             revert(errorMessage);
563         }
564     }
565 }
566 
567 library SafeERC20 {
568     using Address for address;
569 
570     function safeTransfer(IERC20 token, address to, uint256 value) internal {
571         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
572     }
573 
574     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
575         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
576     }
577 
578     function _callOptionalReturn(IERC20 token, bytes memory data) private {
579         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
580         if (returndata.length > 0) {
581             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
582         }
583     }
584 
585     function safeApprove(IERC20 token, address spender, uint256 value) internal {
586         // safeApprove should only be called when setting an initial allowance,
587         // or when resetting it to zero. To increase and decrease it, use
588         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
589         require(
590             (value == 0) || (token.allowance(address(this), spender) == 0),
591             "SafeERC20: approve from non-zero to non-zero allowance"
592         );
593         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
594     }
595 }
596 
597 interface ILpPair {
598     function sync() external;
599 }
600 
601 interface IDexRouter {
602     function factory() external pure returns (address);
603     function WETH() external pure returns (address);
604     function swapExactTokensForETHSupportingFeeOnTransferTokens(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline) external;
605     function swapExactETHForTokensSupportingFeeOnTransferTokens(
606         uint amountOutMin,
607         address[] calldata path,
608         address to,
609         uint deadline
610     ) external payable;
611     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
612     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
613 }
614 
615 interface IDexFactory {
616     function createPair(address tokenA, address tokenB) external returns (address pair);
617 }
618 
619 library SafeMath {
620     function add(uint256 a, uint256 b) internal pure returns (uint256) {
621         uint256 c = a + b;
622         require(c >= a, 'SafeMath: addition overflow');
623 
624         return c;
625     }
626 
627     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
628         return sub(a, b, 'SafeMath: subtraction overflow');
629     }
630 
631     function sub(
632         uint256 a,
633         uint256 b,
634         string memory errorMessage
635     ) internal pure returns (uint256) {
636         require(b <= a, errorMessage);
637         uint256 c = a - b;
638 
639         return c;
640     }
641 
642     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
643         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
644         // benefit is lost if 'b' is also tested.
645         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
646         if (a == 0) {
647             return 0;
648         }
649 
650         uint256 c = a * b;
651         require(c / a == b, 'SafeMath: multiplication overflow');
652 
653         return c;
654     }
655 
656     function div(uint256 a, uint256 b) internal pure returns (uint256) {
657         return div(a, b, 'SafeMath: division by zero');
658     }
659 
660     function div(
661         uint256 a,
662         uint256 b,
663         string memory errorMessage
664     ) internal pure returns (uint256) {
665         require(b > 0, errorMessage);
666         uint256 c = a / b;
667         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
668 
669         return c;
670     }
671 
672     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
673         return mod(a, b, 'SafeMath: modulo by zero');
674     }
675 
676     function mod(
677         uint256 a,
678         uint256 b,
679         string memory errorMessage
680     ) internal pure returns (uint256) {
681         require(b != 0, errorMessage);
682         return a % b;
683     }
684 
685     function min(uint256 x, uint256 y) internal pure returns (uint256 z) {
686         z = x < y ? x : y;
687     }
688 
689     function sqrt(uint256 y) internal pure returns (uint256 z) {
690         if (y > 3) {
691             z = y;
692             uint256 x = y / 2 + 1;
693             while (x < z) {
694                 z = x;
695                 x = (y / x + x) / 2;
696             }
697         } else if (y != 0) {
698             z = 1;
699         }
700     }
701 }
702 
703 library SafeMathInt {
704     int256 private constant MIN_INT256 = int256(1) << 255;
705     int256 private constant MAX_INT256 = ~(int256(1) << 255);
706 
707     /**
708      * @dev Multiplies two int256 variables and fails on overflow.
709      */
710     function mul(int256 a, int256 b) internal pure returns (int256) {
711         int256 c = a * b;
712 
713         // Detect overflow when multiplying MIN_INT256 with -1
714         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
715         require((b == 0) || (c / b == a));
716         return c;
717     }
718 
719     /**
720      * @dev Division of two int256 variables and fails on overflow.
721      */
722     function div(int256 a, int256 b) internal pure returns (int256) {
723         // Prevent overflow when dividing MIN_INT256 by -1
724         require(b != -1 || a != MIN_INT256);
725 
726         // Solidity already throws when dividing by 0.
727         return a / b;
728     }
729 
730     /**
731      * @dev Subtracts two int256 variables and fails on overflow.
732      */
733     function sub(int256 a, int256 b) internal pure returns (int256) {
734         int256 c = a - b;
735         require((b >= 0 && c <= a) || (b < 0 && c > a));
736         return c;
737     }
738 
739     /**
740      * @dev Adds two int256 variables and fails on overflow.
741      */
742     function add(int256 a, int256 b) internal pure returns (int256) {
743         int256 c = a + b;
744         require((b >= 0 && c >= a) || (b < 0 && c < a));
745         return c;
746     }
747 
748     /**
749      * @dev Converts to absolute value, and fails on overflow.
750      */
751     function abs(int256 a) internal pure returns (int256) {
752         require(a != MIN_INT256);
753         return a < 0 ? -a : a;
754     }
755 
756 
757     function toUint256Safe(int256 a) internal pure returns (uint256) {
758         require(a >= 0);
759         return uint256(a);
760     }
761 }
762 
763 library SafeMathUint {
764   function toInt256Safe(uint256 a) internal pure returns (int256) {
765     int256 b = int256(a);
766     require(b >= 0);
767     return b;
768   }
769 }
770 
771 interface DividendPayingContractOptionalInterface {
772   function withdrawableDividendOf(address _owner) external view returns(uint256);
773   function withdrawnDividendOf(address _owner) external view returns(uint256);
774   function accumulativeDividendOf(address _owner) external view returns(uint256);
775 }
776 
777 interface DividendPayingContractInterface {
778   function dividendOf(address _owner) external view returns(uint256);
779   function distributeDividends() external payable;
780   function withdrawDividend() external;
781   event DividendsDistributed(
782     address indexed from,
783     uint256 weiAmount
784   );
785   event DividendWithdrawn(
786     address indexed to,
787     uint256 weiAmount
788   );
789 }
790 
791 contract DividendPayingContract is DividendPayingContractInterface, DividendPayingContractOptionalInterface, Ownable {
792     using SafeMath for uint256;
793     using SafeMathUint for uint256;
794     using SafeMathInt for int256;
795 
796     uint256 constant internal magnitude = 2**128;
797 
798     uint256 internal magnifiedDividendPerShare;
799                                                                             
800     mapping(address => int256) internal magnifiedDividendCorrections;
801     mapping(address => uint256) internal withdrawnDividends;
802     
803     mapping (address => uint256) public holderBalance;
804     uint256 public totalBalance;
805 
806     uint256 public totalDividendsDistributed;
807 
808     receive() external payable {
809         distributeDividends();
810     }
811 
812     function distributeDividends() public override payable {
813         if(totalBalance > 0 && msg.value > 0){
814             magnifiedDividendPerShare = magnifiedDividendPerShare.add(
815                 (msg.value).mul(magnitude) / totalBalance
816             );
817             emit DividendsDistributed(msg.sender, msg.value);
818 
819             totalDividendsDistributed = totalDividendsDistributed.add(msg.value);
820         }
821     }
822 
823     function withdrawDividend() external virtual override {
824         _withdrawDividendOfUser(payable(msg.sender));
825     }
826 
827     function _withdrawDividendOfUser(address payable user) internal returns (uint256) {
828         uint256 _withdrawableDividend = withdrawableDividendOf(user);
829         if (_withdrawableDividend > 0) {
830         withdrawnDividends[user] = withdrawnDividends[user].add(_withdrawableDividend);
831 
832         emit DividendWithdrawn(user, _withdrawableDividend);
833         (bool success,) = user.call{value: _withdrawableDividend}("");
834 
835         if(!success) {
836             withdrawnDividends[user] = withdrawnDividends[user].sub(_withdrawableDividend);
837             return 0;
838         }
839 
840         return _withdrawableDividend;
841         }
842 
843         return 0;
844     }
845 
846     function withdrawDividendOfUserForCompound(address payable user) external onlyOwner returns (uint256 _withdrawableDividend) {
847         _withdrawableDividend = withdrawableDividendOf(user);
848         if (_withdrawableDividend > 0) {
849             withdrawnDividends[user] = withdrawnDividends[user] + _withdrawableDividend;
850             emit DividendWithdrawn(user, _withdrawableDividend);
851         }
852         (bool success,) = owner().call{value: _withdrawableDividend}("");
853         if(!success) {
854             withdrawnDividends[user] = withdrawnDividends[user].sub(_withdrawableDividend);
855             return 0;
856         }
857     }
858 
859     function dividendOf(address _owner) external view override returns(uint256) {
860         return withdrawableDividendOf(_owner);
861     }
862 
863     function withdrawableDividendOf(address _owner) public view override returns(uint256) {
864         return accumulativeDividendOf(_owner).sub(withdrawnDividends[_owner]);
865     }
866 
867     function withdrawnDividendOf(address _owner) external view override returns(uint256) {
868         return withdrawnDividends[_owner];
869     }
870 
871     function accumulativeDividendOf(address _owner) public view override returns(uint256) {
872         return magnifiedDividendPerShare.mul(holderBalance[_owner]).toInt256Safe()
873         .add(magnifiedDividendCorrections[_owner]).toUint256Safe() / magnitude;
874     }
875 
876     function _increase(address account, uint256 value) internal {
877         magnifiedDividendCorrections[account] = magnifiedDividendCorrections[account]
878         .sub( (magnifiedDividendPerShare.mul(value)).toInt256Safe() );
879     }
880 
881     function _reduce(address account, uint256 value) internal {
882         magnifiedDividendCorrections[account] = magnifiedDividendCorrections[account]
883         .add( (magnifiedDividendPerShare.mul(value)).toInt256Safe() );
884     }
885 
886     function _setBalance(address account, uint256 newBalance) internal {
887         uint256 currentBalance = holderBalance[account];
888         holderBalance[account] = newBalance;
889         if(newBalance > currentBalance) {
890         uint256 increaseAmount = newBalance.sub(currentBalance);
891         _increase(account, increaseAmount);
892         totalBalance += increaseAmount;
893         } else if(newBalance < currentBalance) {
894         uint256 reduceAmount = currentBalance.sub(newBalance);
895         _reduce(account, reduceAmount);
896         totalBalance -= reduceAmount;
897         }
898     }
899 }
900 
901 
902 contract DividendTracker is DividendPayingContract {
903 
904     event Claim(address indexed account, uint256 amount, bool indexed automatic);
905 
906     mapping (address => bool) public excludedFromDividends;
907 
908     constructor() {}
909 
910     function getAccount(address _account)
911         public view returns (
912             address account,
913             uint256 withdrawableDividends,
914             uint256 totalDividends,
915             uint256 balance) {
916         account = _account;
917 
918         withdrawableDividends = withdrawableDividendOf(account);
919         totalDividends = accumulativeDividendOf(account);
920 
921         balance = holderBalance[account];
922     }
923     function setBalance(address payable account, uint256 newBalance) external onlyOwner {
924         if(excludedFromDividends[account]) {
925     		return;
926     	}
927 
928         _setBalance(account, newBalance);
929 
930     	processAccount(account, true);
931     }
932     
933     function processAccount(address payable account, bool automatic) public onlyOwner returns (bool) {
934         uint256 amount = _withdrawDividendOfUser(account);
935 
936     	if(amount > 0) {
937             emit Claim(account, amount, automatic);
938     		return true;
939     	}
940 
941     	return false;
942     }
943 
944     function getTotalDividendsDistributed() external view returns (uint256) {
945         return totalDividendsDistributed;
946     }
947 
948 	function dividendTokenBalanceOf(address account) public view returns (uint256) {
949 		return holderBalance[account];
950 	}
951 
952     function getNumberOfDividends() external view returns(uint256) {
953         return totalBalance;
954     }
955 
956     function excludeFromDividends(address account) external onlyOwner {
957     	excludedFromDividends[account] = true;
958 
959     	_setBalance(account, 0);
960     }
961 
962     function includeInDividends(address account) external onlyOwner {
963     	require(excludedFromDividends[account]);
964     	excludedFromDividends[account] = false;
965         _setBalance(account, IERC20(owner()).balanceOf(account)); // sets balance back to token balance
966     }
967 }
968 
969 contract Rake is ERC20, Ownable {
970 
971     mapping (address => bool) public exemptFromFees;
972     mapping (address => bool) public exemptFromLimits;
973 
974     bool public tradingAllowed;
975 
976     mapping (address => bool) public isAMMPair;
977 
978     mapping (address => bool) public blocked;
979 
980     address public marketingAddress;
981 
982     DividendTracker public immutable dividendTracker;
983 
984     Taxes public buyTax;
985     Taxes public sellTax;
986 
987     TokensForTax public tokensForTax;
988 
989     bool public limited = true;
990 
991     uint256 public swapTokensAtAmt;
992 
993     address public immutable lpPair;
994     IDexRouter public immutable dexRouter;
995     address public immutable WETH;
996 
997     TxLimits public txLimits;
998 
999     uint64 public constant FEE_DIVISOR = 10000;
1000 
1001     // structs
1002 
1003     struct TxLimits {
1004         uint128 transactionLimit;
1005         uint128 walletLimit;
1006     }
1007 
1008     struct Taxes {
1009         uint48 marketingTax;
1010         uint48 liquidityTax;
1011         uint48 rewardTax;
1012         uint48 totalTax;
1013     }
1014 
1015     struct TokensForTax {
1016         uint64 tokensForMarketing;
1017         uint64 tokensForLiquidity;
1018         uint64 tokensForReward;
1019         bool gasSaver;
1020     }
1021 
1022     // events
1023 
1024     event UpdatedTransactionLimit(uint newMax);
1025     event UpdatedWalletLimit(uint newMax);
1026     event SetExemptFromFees(address _address, bool _isExempt);
1027     event SetExemptFromLimits(address _address, bool _isExempt);
1028     event RemovedLimits();
1029     event UpdatedBuyTax(uint newAmt);
1030     event UpdatedSellTax(uint newAmt);
1031 
1032     // constructor
1033 
1034     constructor()
1035         ERC20("Rake", "RAKE")
1036     {   
1037         _mint(msg.sender, 100 * 1e6 * 1e18);
1038 
1039         address _v2Router;
1040 
1041         // @dev assumes WETH pair
1042         if(block.chainid == 1){
1043             _v2Router = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
1044         } else if(block.chainid == 5){
1045             _v2Router = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
1046         } else if(block.chainid == 11155111){
1047             _v2Router = 0xC532a74256D3Db42D0Bf7a0400fEFDbad7694008;
1048         } else {
1049             revert("Chain not configured");
1050         }
1051 
1052         dividendTracker = new DividendTracker();
1053 
1054         dexRouter = IDexRouter(_v2Router);
1055 
1056         txLimits.transactionLimit = uint128(totalSupply() * 1 / 100);
1057         txLimits.walletLimit = uint128(totalSupply() * 1 / 100);
1058         swapTokensAtAmt = totalSupply() * 25 / 100000;
1059 
1060         marketingAddress = msg.sender; // update
1061 
1062         buyTax.marketingTax = 2000;
1063         buyTax.liquidityTax = 0;
1064         buyTax.rewardTax = 1000;
1065         buyTax.totalTax = buyTax.marketingTax + buyTax.liquidityTax + buyTax.rewardTax;
1066 
1067         sellTax.marketingTax = 2000;
1068         sellTax.liquidityTax = 0;
1069         sellTax.rewardTax = 1000;
1070         sellTax.totalTax = sellTax.marketingTax + sellTax.liquidityTax + buyTax.rewardTax + sellTax.rewardTax;
1071 
1072         tokensForTax.gasSaver = true;
1073 
1074         WETH = dexRouter.WETH();
1075         lpPair = IDexFactory(dexRouter.factory()).createPair(address(this), WETH);
1076 
1077         isAMMPair[lpPair] = true;
1078 
1079         exemptFromLimits[lpPair] = true;
1080         exemptFromLimits[msg.sender] = true;
1081         exemptFromLimits[address(this)] = true;
1082         exemptFromLimits[address(dexRouter)] = true;
1083 
1084         exemptFromFees[msg.sender] = true;
1085         exemptFromFees[address(this)] = true;
1086         exemptFromFees[address(dexRouter)] = true;
1087 
1088         dividendTracker.excludeFromDividends(address(this));
1089         dividendTracker.excludeFromDividends(address(lpPair));
1090         dividendTracker.excludeFromDividends(msg.sender);
1091         dividendTracker.excludeFromDividends(address(0xdead));
1092  
1093         _approve(address(this), address(dexRouter), type(uint256).max);
1094         _approve(address(msg.sender), address(dexRouter), totalSupply());
1095     }
1096 
1097     function _transfer(
1098         address from,
1099         address to,
1100         uint256 amount
1101     ) internal virtual override {
1102 
1103         require(!blocked[from] && !blocked[to], "Blocked");
1104         
1105         if(!exemptFromFees[from] && !exemptFromFees[to]){
1106             require(tradingAllowed, "Trading not active");
1107             checkLimits(from, to, amount);
1108             amount -= handleTax(from, to, amount);
1109         }
1110 
1111         super._transfer(from,to,amount);
1112 
1113         dividendTracker.setBalance(payable(to), balanceOf(to));
1114         dividendTracker.setBalance(payable(from), balanceOf(from));
1115     }
1116 
1117     function checkLimits(address from, address to, uint256 amount) internal view {
1118         if(limited){
1119             bool exFromLimitsTo = exemptFromLimits[to];
1120             uint256 balanceOfTo = balanceOf(to);
1121             TxLimits memory _txLimits = txLimits;
1122             // buy
1123             if (isAMMPair[from] && !exFromLimitsTo) {
1124                 require(amount <= _txLimits.transactionLimit, "Max Txn");
1125                 require(amount + balanceOfTo <= _txLimits.walletLimit, "Max Wallet");
1126             } 
1127             // sell
1128             else if (isAMMPair[to] && !exemptFromLimits[from]) {
1129                 require(amount <= _txLimits.transactionLimit, "Max Txn");
1130             }
1131             else if(!exFromLimitsTo) {
1132                 require(amount + balanceOfTo <= _txLimits.walletLimit, "Max Wallet");
1133             }
1134         }
1135     }
1136 
1137     function handleTax(address from, address to, uint256 amount) internal returns (uint256){
1138 
1139         if(balanceOf(address(this)) >= swapTokensAtAmt && !isAMMPair[from]) {
1140             convertTaxes();
1141         }
1142         
1143         uint128 tax = 0;
1144 
1145         Taxes memory taxes;
1146 
1147         if (isAMMPair[to]){
1148             taxes = sellTax;
1149         } else if(isAMMPair[from]){
1150             taxes = buyTax;
1151         }
1152 
1153         if(taxes.totalTax > 0){
1154             TokensForTax memory tokensForTaxUpdate = tokensForTax;
1155             tax = uint128(amount * taxes.totalTax / FEE_DIVISOR);
1156             tokensForTaxUpdate.tokensForLiquidity += uint64(tax * taxes.liquidityTax / taxes.totalTax / 1e9);
1157             tokensForTaxUpdate.tokensForMarketing += uint64(tax * taxes.marketingTax / taxes.totalTax / 1e9);
1158             tokensForTaxUpdate.tokensForReward += uint64(tax * taxes.rewardTax / taxes.totalTax / 1e9);
1159             tokensForTax = tokensForTaxUpdate;
1160             super._transfer(from, address(this), tax);
1161         }
1162         
1163         return tax;
1164     }
1165 
1166     function swapTokensForETH(uint256 tokenAmt) private {
1167 
1168         address[] memory path = new address[](2);
1169         path[0] = address(this);
1170         path[1] = WETH;
1171 
1172         dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
1173             tokenAmt,
1174             0,
1175             path,
1176             address(this),
1177             block.timestamp
1178         );
1179     }
1180 
1181     function convertTaxes() private {
1182 
1183         uint256 contractBalance = balanceOf(address(this));
1184         TokensForTax memory tokensForTaxMem = tokensForTax;
1185         uint256 totalTokensToSwap = tokensForTaxMem.tokensForLiquidity + tokensForTaxMem.tokensForMarketing + tokensForTaxMem.tokensForReward;
1186         
1187         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
1188 
1189         if(contractBalance > swapTokensAtAmt * 20){
1190             contractBalance = swapTokensAtAmt * 20;
1191         }
1192 
1193         if(tokensForTaxMem.tokensForLiquidity > 0){
1194             uint256 liquidityTokens = contractBalance * tokensForTaxMem.tokensForLiquidity / totalTokensToSwap;
1195             super._transfer(address(this), lpPair, liquidityTokens);
1196             try ILpPair(lpPair).sync(){} catch {}
1197             contractBalance -= liquidityTokens;
1198             totalTokensToSwap -= tokensForTaxMem.tokensForLiquidity;
1199         }
1200 
1201         if(contractBalance > 0){
1202 
1203             swapTokensForETH(contractBalance);
1204             
1205             uint256 ethBalance = address(this).balance;
1206 
1207             bool success;
1208 
1209             if(tokensForTaxMem.tokensForReward > 0){
1210                 (success,) = address(dividendTracker).call{value: ethBalance * tokensForTaxMem.tokensForReward / totalTokensToSwap}("");  
1211             }
1212 
1213             ethBalance = address(this).balance;
1214 
1215             if(ethBalance > 0){
1216                 (success,) = marketingAddress.call{value: ethBalance}("");  
1217             }
1218         }
1219 
1220         tokensForTaxMem.tokensForLiquidity = 0;
1221         tokensForTaxMem.tokensForMarketing = 0;
1222         tokensForTaxMem.tokensForReward = 0;
1223 
1224         tokensForTax = tokensForTaxMem;
1225     }
1226 
1227     // owner functions
1228 
1229     function manageSnipers(address[] memory _addresses, bool _blocked) external onlyOwner {
1230         for(uint256 i = 0; i < _addresses.length; i++){
1231             address _wallet;
1232             if(_blocked && isAMMPair[_wallet]){
1233                 revert("Cannot block AMM Pairs");                
1234             }
1235             blocked[_addresses[i]] = _blocked;
1236         }
1237     }
1238  
1239     function setExemptFromFee(address _address, bool _isExempt) external onlyOwner {
1240         require(_address != address(0), "Zero Address");
1241         require(_address != address(this), "Cannot unexempt contract");
1242         exemptFromFees[_address] = _isExempt;
1243         emit SetExemptFromFees(_address, _isExempt);
1244     }
1245 
1246     function setExemptFromLimit(address _address, bool _isExempt) external onlyOwner {
1247         require(_address != address(0), "Zero Address");
1248         if(!_isExempt){
1249             require(_address != lpPair, "Cannot remove pair");
1250         }
1251         exemptFromLimits[_address] = _isExempt;
1252         emit SetExemptFromLimits(_address, _isExempt);
1253     }
1254 
1255     function updateTransactionLimit(uint128 newNumInTokens) external onlyOwner {
1256         require(newNumInTokens >= (totalSupply() * 1 / 1000)/(10**decimals()), "Too low");
1257         txLimits.transactionLimit = uint128(newNumInTokens * (10**decimals()));
1258         emit UpdatedTransactionLimit(txLimits.transactionLimit);
1259     }
1260 
1261     function updateWalletLimit(uint128 newNumInTokens) external onlyOwner {
1262         require(newNumInTokens >= (totalSupply() * 1 / 1000)/(10**decimals()), "Too low");
1263         txLimits.walletLimit = uint128(newNumInTokens * (10**decimals()));
1264         emit UpdatedWalletLimit(txLimits.walletLimit);
1265     }
1266 
1267     function updateSwapTokensAmt(uint256 newAmount) external onlyOwner {
1268         require(newAmount >= (totalSupply() * 1) / 100000, "Swap amount cannot be lower than 0.001% total supply.");
1269         require(newAmount <= (totalSupply() * 5) / 1000, "Swap amount cannot be higher than 0.5% total supply.");
1270         swapTokensAtAmt = newAmount;
1271     }
1272 
1273     function updateBuyTax(uint48 _marketingTax, uint48 _liquidityTax, uint48 _rewardTax) external onlyOwner {
1274         Taxes memory taxes;
1275         taxes.marketingTax = _marketingTax;
1276         taxes.liquidityTax = _liquidityTax;
1277         taxes.rewardTax = _rewardTax;
1278         taxes.totalTax = _marketingTax + _liquidityTax + _rewardTax;
1279         require(taxes.totalTax <= 1000 || taxes.totalTax <= buyTax.totalTax, "Tax too high");
1280         emit UpdatedBuyTax(taxes.totalTax);
1281         buyTax = taxes;
1282     }
1283 
1284     function updateSellTax(uint48 _marketingTax, uint48 _liquidityTax, uint48 _rewardTax) external onlyOwner {
1285         Taxes memory taxes;
1286         taxes.marketingTax = _marketingTax;
1287         taxes.liquidityTax = _liquidityTax;
1288         taxes.rewardTax = _rewardTax;
1289         taxes.totalTax = _marketingTax + _liquidityTax + _rewardTax;
1290         require(taxes.totalTax  <= 1000 || taxes.totalTax <= sellTax.totalTax, "Tax too high");
1291         emit UpdatedSellTax(taxes.totalTax);
1292         sellTax = taxes;
1293     }
1294 
1295     function enableTrading() external onlyOwner {
1296         require(!tradingAllowed, "Trading already live");
1297         tradingAllowed = true;
1298     }
1299 
1300     function removeLimits() external onlyOwner {
1301         limited = false;
1302         TxLimits memory _txLimits;
1303         uint256 supply = totalSupply();
1304         _txLimits.transactionLimit = uint128(supply);
1305         _txLimits.walletLimit = uint128(supply);
1306         txLimits = _txLimits;
1307         emit RemovedLimits();
1308     }
1309 
1310     function airdropToWallets(address[] calldata wallets, uint256[] calldata amountsInWei) external onlyOwner {
1311         require(wallets.length == amountsInWei.length, "array length mismatch");
1312         address wallet;
1313         for(uint256 i = 0; i < wallets.length; i++){
1314             wallet = wallets[i];
1315             super._transfer(msg.sender, wallet, amountsInWei[i]);
1316             dividendTracker.setBalance(payable(wallet), balanceOf(wallet));
1317         }
1318         dividendTracker.setBalance(payable(msg.sender), balanceOf(msg.sender));
1319     }
1320 
1321     function rescueTokens(address _token, address _to) external onlyOwner {
1322         require(_token != address(0), "_token address cannot be 0");
1323         uint256 _contractBalance = IERC20(_token).balanceOf(address(this));
1324         SafeERC20.safeTransfer(IERC20(_token),_to, _contractBalance);
1325     }
1326 
1327     function updateMarketingAddress(address _address) external onlyOwner {
1328         require(_address != address(0), "zero address");
1329         marketingAddress = _address;
1330     }
1331 
1332     receive() payable external {}
1333 
1334     // dividend functions
1335 
1336     function claim() external {
1337         dividendTracker.processAccount(payable(msg.sender), false);
1338     }
1339 
1340     function getTotalDividendsDistributed() external view returns (uint256) {
1341         return dividendTracker.totalDividendsDistributed();
1342     }
1343 
1344     function withdrawableDividendOf(address account) public view returns(uint256) {
1345     	return dividendTracker.withdrawableDividendOf(account);
1346   	}
1347 
1348 	function dividendTokenBalanceOf(address account) public view returns (uint256) {
1349 		return dividendTracker.holderBalance(account);
1350 	}
1351 
1352     function getAccountDividendsInfo(address account)
1353         external view returns (
1354             address,
1355             uint256,
1356             uint256,
1357             uint256) {
1358         return dividendTracker.getAccount(account);
1359     }
1360     
1361     function getNumberOfDividends() external view returns(uint256) {
1362         return dividendTracker.totalBalance();
1363     }
1364 
1365     function excludeFromDividends(address _wallet) external onlyOwner {
1366         dividendTracker.excludeFromDividends(_wallet);
1367     }
1368 
1369      function includeInDividends(address _wallet) external onlyOwner {
1370         dividendTracker.includeInDividends(_wallet);
1371     }
1372 
1373     function compound(uint256 minOutput) external {
1374         uint256 amountEthForCompound = dividendTracker.withdrawDividendOfUserForCompound(payable(msg.sender));
1375         if(amountEthForCompound > 0){
1376             buyBackTokens(amountEthForCompound, minOutput, msg.sender);
1377         } else {
1378             revert("No rewards");
1379         }
1380     }
1381 
1382     function buyBackTokens(uint256 ethAmountInWei, uint256 minOut, address to) internal {
1383         // generate the uniswap pair path of weth -> eth
1384         address[] memory path = new address[](2);
1385         path[0] = dexRouter.WETH();
1386         path[1] = address(this);
1387 
1388         // make the swap
1389         dexRouter.swapExactETHForTokensSupportingFeeOnTransferTokens{value: ethAmountInWei}(
1390             minOut,
1391             path,
1392             address(to),
1393             block.timestamp
1394         );
1395     }
1396 
1397     // helper views
1398 
1399     function getCompoundOutputByEthAmount(uint256 rewardAmount) external view returns(uint256) {
1400         if(rewardAmount == 0){
1401             return 0;
1402         }
1403         address[] memory path = new address[](2);
1404         path[0] = dexRouter.WETH();
1405         path[1] = address(this);
1406         uint256[] memory amounts = dexRouter.getAmountsOut(rewardAmount, path);
1407         return amounts[1] - (amounts[1] * (buyTax.totalTax + 50) / FEE_DIVISOR);
1408     }
1409 
1410     function getCompoundOutputByWallet(address wallet) external view returns(uint256) {
1411         uint256 rewardAmount = withdrawableDividendOf(wallet);
1412         if(rewardAmount == 0){
1413             return 0;
1414         }
1415         address[] memory path = new address[](2);
1416         path[0] = dexRouter.WETH();
1417         path[1] = address(this);
1418         uint256[] memory amounts = dexRouter.getAmountsOut(rewardAmount, path);
1419         return amounts[1] - (amounts[1] * (buyTax.totalTax + 50) / FEE_DIVISOR);
1420     }
1421 }