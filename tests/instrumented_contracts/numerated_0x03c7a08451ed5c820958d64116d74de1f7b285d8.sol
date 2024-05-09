1 //SPDX-License-Identifier: Unlicensed
2 pragma solidity >=0.5.0 <0.9.0;
3 
4 abstract contract Context {
5     function _msgSender() internal view returns (address payable) {
6         return payable(msg.sender);
7     }
8 
9     function _msgData() internal view returns (bytes memory) {
10         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
11         return msg.data;
12     }
13 }
14 
15 /**
16  * @dev Collection of functions related to the address type
17  */
18 library Address {
19     /**
20      * @dev Returns true if `account` is a contract.
21      *
22      * [IMPORTANT]
23      * ====
24      * It is unsafe to assume that an address for which this function returns
25      * false is an externally-owned account (EOA) and not a contract.
26      *
27      * Among others, `isContract` will return false for the following
28      * types of addresses:
29      *
30      *  - an externally-owned account
31      *  - a contract in construction
32      *  - an address where a contract will be created
33      *  - an address where a contract lived, but was destroyed
34      * ====
35      *
36      * [IMPORTANT]
37      * ====
38      * You shouldn't rely on `isContract` to protect against flash loan attacks!
39      *
40      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
41      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
42      * constructor.
43      * ====
44      */
45     function isContract(address account) internal view returns (bool) {
46         // This method relies on extcodesize/address.code.length, which returns 0
47         // for contracts in construction, since the code is only stored at the end
48         // of the constructor execution.
49 
50         return account.code.length > 0;
51     }
52 
53     /**
54      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
55      * `recipient`, forwarding all available gas and reverting on errors.
56      *
57      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
58      * of certain opcodes, possibly making contracts go over the 2300 gas limit
59      * imposed by `transfer`, making them unable to receive funds via
60      * `transfer`. {sendValue} removes this limitation.
61      *
62      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
63      *
64      * IMPORTANT: because control is transferred to `recipient`, care must be
65      * taken to not create reentrancy vulnerabilities. Consider using
66      * {ReentrancyGuard} or the
67      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
68      */
69     function sendValue(address payable recipient, uint256 amount) internal {
70         require(address(this).balance >= amount, "Address: insufficient balance");
71 
72         (bool success, ) = recipient.call{value: amount}("");
73         require(success, "Address: unable to send value, recipient may have reverted");
74     }
75 
76     /**
77      * @dev Performs a Solidity function call using a low level `call`. A
78      * plain `call` is an unsafe replacement for a function call: use this
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
95         return functionCallWithValue(target, data, 0, "Address: low-level call failed");
96     }
97 
98     /**
99      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
100      * `errorMessage` as a fallback revert reason when `target` reverts.
101      *
102      * _Available since v3.1._
103      */
104     function functionCall(
105         address target,
106         bytes memory data,
107         string memory errorMessage
108     ) internal returns (bytes memory) {
109         return functionCallWithValue(target, data, 0, errorMessage);
110     }
111 
112     /**
113      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
114      * but also transferring `value` wei to `target`.
115      *
116      * Requirements:
117      *
118      * - the calling contract must have an ETH balance of at least `value`.
119      * - the called Solidity function must be `payable`.
120      *
121      * _Available since v3.1._
122      */
123     function functionCallWithValue(
124         address target,
125         bytes memory data,
126         uint256 value
127     ) internal returns (bytes memory) {
128         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
129     }
130 
131     /**
132      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
133      * with `errorMessage` as a fallback revert reason when `target` reverts.
134      *
135      * _Available since v3.1._
136      */
137     function functionCallWithValue(
138         address target,
139         bytes memory data,
140         uint256 value,
141         string memory errorMessage
142     ) internal returns (bytes memory) {
143         require(address(this).balance >= value, "Address: insufficient balance for call");
144         (bool success, bytes memory returndata) = target.call{value: value}(data);
145         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
146     }
147 
148     /**
149      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
150      * but performing a static call.
151      *
152      * _Available since v3.3._
153      */
154     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
155         return functionStaticCall(target, data, "Address: low-level static call failed");
156     }
157 
158     /**
159      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
160      * but performing a static call.
161      *
162      * _Available since v3.3._
163      */
164     function functionStaticCall(
165         address target,
166         bytes memory data,
167         string memory errorMessage
168     ) internal view returns (bytes memory) {
169         (bool success, bytes memory returndata) = target.staticcall(data);
170         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
171     }
172 
173     /**
174      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
175      * but performing a delegate call.
176      *
177      * _Available since v3.4._
178      */
179     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
180         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
181     }
182 
183     /**
184      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
185      * but performing a delegate call.
186      *
187      * _Available since v3.4._
188      */
189     function functionDelegateCall(
190         address target,
191         bytes memory data,
192         string memory errorMessage
193     ) internal returns (bytes memory) {
194         (bool success, bytes memory returndata) = target.delegatecall(data);
195         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
196     }
197 
198     /**
199      * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
200      * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
201      *
202      * _Available since v4.8._
203      */
204     function verifyCallResultFromTarget(
205         address target,
206         bool success,
207         bytes memory returndata,
208         string memory errorMessage
209     ) internal view returns (bytes memory) {
210         if (success) {
211             if (returndata.length == 0) {
212                 // only check isContract if the call was successful and the return data is empty
213                 // otherwise we already know that it was a contract
214                 require(isContract(target), "Address: call to non-contract");
215             }
216             return returndata;
217         } else {
218             _revert(returndata, errorMessage);
219         }
220     }
221 
222     /**
223      * @dev Tool to verify that a low level call was successful, and revert if it wasn't, either by bubbling the
224      * revert reason or using the provided one.
225      *
226      * _Available since v4.3._
227      */
228     function verifyCallResult(
229         bool success,
230         bytes memory returndata,
231         string memory errorMessage
232     ) internal pure returns (bytes memory) {
233         if (success) {
234             return returndata;
235         } else {
236             _revert(returndata, errorMessage);
237         }
238     }
239 
240     function _revert(bytes memory returndata, string memory errorMessage) private pure {
241         // Look for revert reason and bubble it up if present
242         if (returndata.length > 0) {
243             // The easiest way to bubble the revert reason is using memory via assembly
244             /// @solidity memory-safe-assembly
245             assembly {
246                 let returndata_size := mload(returndata)
247                 revert(add(32, returndata), returndata_size)
248             }
249         } else {
250             revert(errorMessage);
251         }
252     }
253 }
254 
255 library SafeMath {
256     function add(uint256 a, uint256 b) internal pure returns (uint256) {
257         uint256 c = a + b;
258         require(c >= a, "SafeMath: addition overflow");
259     
260         return c;
261     }
262     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
263         return sub(a, b, "SafeMath: subtraction overflow");
264     }
265     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
266         require(b <= a, errorMessage);
267         uint256 c = a - b;
268     
269         return c;
270     }
271     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
272         if (a == 0) {
273             return 0;
274         }
275     
276         uint256 c = a * b;
277         require(c / a == b, "SafeMath: multiplication overflow");
278     
279         return c;
280     }
281     function div(uint256 a, uint256 b) internal pure returns (uint256) {
282         return div(a, b, "SafeMath: division by zero");
283     }
284     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
285         // Solidity only automatically asserts when dividing by 0
286         require(b > 0, errorMessage);
287         uint256 c = a / b;
288         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
289     
290         return c;
291     }
292 }
293 
294 interface IERC20 {
295     function totalSupply() external view returns (uint256);
296     function decimals() external view returns (uint8);
297     function symbol() external view returns (string memory);
298     function name() external view returns (string memory);
299     function balanceOf(address account) external view returns (uint256);
300     function transfer(address recipient, uint256 amount) external returns (bool);
301     function allowance(address _owner, address spender) external view returns (uint256);
302     function approve(address spender, uint256 amount) external returns (bool);
303     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
304     event Transfer(address indexed from, address indexed to, uint256 value);
305     event Approval(address indexed owner, address indexed spender, uint256 value);
306 }
307 
308 /**
309  * @dev Implementation of the {IERC20} interface.
310  *
311  * This implementation is agnostic to the way tokens are created. This means
312  * that a supply mechanism has to be added in a derived contract using {_mint}.
313  * For a generic mechanism see {ERC20PresetMinterPauser}.
314  *
315  * TIP: For a detailed writeup see our guide
316  * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
317  * to implement supply mechanisms].
318  *
319  * We have followed general OpenZeppelin Contracts guidelines: functions revert
320  * instead returning `false` on failure. This behavior is nonetheless
321  * conventional and does not conflict with the expectations of ERC20
322  * applications.
323  *
324  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
325  * This allows applications to reconstruct the allowance for all accounts just
326  * by listening to said events. Other implementations of the EIP may not emit
327  * these events, as it isn't required by the specification.
328  *
329  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
330  * functions have been added to mitigate the well-known issues around setting
331  * allowances. See {IERC20-approve}.
332  */
333 contract ERC20 is Context, IERC20 {
334     mapping(address => uint256) private _balances;
335 
336     mapping(address => mapping(address => uint256)) private _allowances;
337 
338     uint256 private _totalSupply;
339 
340     string private _name;
341     string private _symbol;
342 
343     /**
344      * @dev Sets the values for {name} and {symbol}.
345      *
346      * The default value of {decimals} is 18. To select a different value for
347      * {decimals} you should overload it.
348      *
349      * All two of these values are immutable: they can only be set once during
350      * construction.
351      */
352     constructor(string memory name_, string memory symbol_) {
353         _name = name_;
354         _symbol = symbol_;
355     }
356 
357     /**
358      * @dev Returns the name of the token.
359      */
360     function name() public view virtual override returns (string memory) {
361         return _name;
362     }
363 
364     /**
365      * @dev Returns the symbol of the token, usually a shorter version of the
366      * name.
367      */
368     function symbol() public view virtual override returns (string memory) {
369         return _symbol;
370     }
371 
372     /**
373      * @dev Returns the number of decimals used to get its user representation.
374      * For example, if `decimals` equals `2`, a balance of `505` tokens should
375      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
376      *
377      * Tokens usually opt for a value of 18, imitating the relationship between
378      * Ether and Wei. This is the value {ERC20} uses, unless this function is
379      * overridden;
380      *
381      * NOTE: This information is only used for _display_ purposes: it in
382      * no way affects any of the arithmetic of the contract, including
383      * {IERC20-balanceOf} and {IERC20-transfer}.
384      */
385     function decimals() public view virtual override returns (uint8) {
386         return 18;
387     }
388 
389     /**
390      * @dev See {IERC20-totalSupply}.
391      */
392     function totalSupply() public view virtual override returns (uint256) {
393         return _totalSupply;
394     }
395 
396     /**
397      * @dev See {IERC20-balanceOf}.
398      */
399     function balanceOf(address account) public view virtual override returns (uint256) {
400         return _balances[account];
401     }
402 
403     /**
404      * @dev See {IERC20-transfer}.
405      *
406      * Requirements:
407      *
408      * - `to` cannot be the zero address.
409      * - the caller must have a balance of at least `amount`.
410      */
411     function transfer(address to, uint256 amount) public virtual override returns (bool) {
412         address owner = _msgSender();
413         _transfer(owner, to, amount);
414         return true;
415     }
416 
417     /**
418      * @dev See {IERC20-allowance}.
419      */
420     function allowance(address owner, address spender) public view virtual override returns (uint256) {
421         return _allowances[owner][spender];
422     }
423 
424     /**
425      * @dev See {IERC20-approve}.
426      *
427      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
428      * `transferFrom`. This is semantically equivalent to an infinite approval.
429      *
430      * Requirements:
431      *
432      * - `spender` cannot be the zero address.
433      */
434     function approve(address spender, uint256 amount) public virtual override returns (bool) {
435         address owner = _msgSender();
436         _approve(owner, spender, amount);
437         return true;
438     }
439 
440     /**
441      * @dev See {IERC20-transferFrom}.
442      *
443      * Emits an {Approval} event indicating the updated allowance. This is not
444      * required by the EIP. See the note at the beginning of {ERC20}.
445      *
446      * NOTE: Does not update the allowance if the current allowance
447      * is the maximum `uint256`.
448      *
449      * Requirements:
450      *
451      * - `from` and `to` cannot be the zero address.
452      * - `from` must have a balance of at least `amount`.
453      * - the caller must have allowance for ``from``'s tokens of at least
454      * `amount`.
455      */
456     function transferFrom(
457         address from,
458         address to,
459         uint256 amount
460     ) public virtual override returns (bool) {
461         address spender = _msgSender();
462         _spendAllowance(from, spender, amount);
463         _transfer(from, to, amount);
464         return true;
465     }
466 
467     /**
468      * @dev Atomically increases the allowance granted to `spender` by the caller.
469      *
470      * This is an alternative to {approve} that can be used as a mitigation for
471      * problems described in {IERC20-approve}.
472      *
473      * Emits an {Approval} event indicating the updated allowance.
474      *
475      * Requirements:
476      *
477      * - `spender` cannot be the zero address.
478      */
479     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
480         address owner = _msgSender();
481         _approve(owner, spender, allowance(owner, spender) + addedValue);
482         return true;
483     }
484 
485     /**
486      * @dev Atomically decreases the allowance granted to `spender` by the caller.
487      *
488      * This is an alternative to {approve} that can be used as a mitigation for
489      * problems described in {IERC20-approve}.
490      *
491      * Emits an {Approval} event indicating the updated allowance.
492      *
493      * Requirements:
494      *
495      * - `spender` cannot be the zero address.
496      * - `spender` must have allowance for the caller of at least
497      * `subtractedValue`.
498      */
499     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
500         address owner = _msgSender();
501         uint256 currentAllowance = allowance(owner, spender);
502         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
503         unchecked {
504             _approve(owner, spender, currentAllowance - subtractedValue);
505         }
506 
507         return true;
508     }
509 
510     /**
511      * @dev Moves `amount` of tokens from `from` to `to`.
512      *
513      * This internal function is equivalent to {transfer}, and can be used to
514      * e.g. implement automatic token fees, slashing mechanisms, etc.
515      *
516      * Emits a {Transfer} event.
517      *
518      * Requirements:
519      *
520      * - `from` cannot be the zero address.
521      * - `to` cannot be the zero address.
522      * - `from` must have a balance of at least `amount`.
523      */
524     function _transfer(
525         address from,
526         address to,
527         uint256 amount
528     ) internal virtual {
529         require(from != address(0), "ERC20: transfer from the zero address");
530         require(to != address(0), "ERC20: transfer to the zero address");
531 
532         _beforeTokenTransfer(from, to, amount);
533 
534         uint256 fromBalance = _balances[from];
535         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
536         unchecked {
537             _balances[from] = fromBalance - amount;
538             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
539             // decrementing then incrementing.
540             _balances[to] += amount;
541         }
542 
543         emit Transfer(from, to, amount);
544 
545         _afterTokenTransfer(from, to, amount);
546     }
547 
548     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
549      * the total supply.
550      *
551      * Emits a {Transfer} event with `from` set to the zero address.
552      *
553      * Requirements:
554      *
555      * - `account` cannot be the zero address.
556      */
557     function _mint(address account, uint256 amount) internal virtual {
558         require(account != address(0), "ERC20: mint to the zero address");
559 
560         _beforeTokenTransfer(address(0), account, amount);
561 
562         _totalSupply += amount;
563         unchecked {
564             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
565             _balances[account] += amount;
566         }
567         emit Transfer(address(0), account, amount);
568 
569         _afterTokenTransfer(address(0), account, amount);
570     }
571 
572     /**
573      * @dev Destroys `amount` tokens from `account`, reducing the
574      * total supply.
575      *
576      * Emits a {Transfer} event with `to` set to the zero address.
577      *
578      * Requirements:
579      *
580      * - `account` cannot be the zero address.
581      * - `account` must have at least `amount` tokens.
582      */
583     function _burn(address account, uint256 amount) internal virtual {
584         require(account != address(0), "ERC20: burn from the zero address");
585 
586         _beforeTokenTransfer(account, address(0), amount);
587 
588         uint256 accountBalance = _balances[account];
589         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
590         unchecked {
591             _balances[account] = accountBalance - amount;
592             // Overflow not possible: amount <= accountBalance <= totalSupply.
593             _totalSupply -= amount;
594         }
595 
596         emit Transfer(account, address(0), amount);
597 
598         _afterTokenTransfer(account, address(0), amount);
599     }
600 
601     /**
602      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
603      *
604      * This internal function is equivalent to `approve`, and can be used to
605      * e.g. set automatic allowances for certain subsystems, etc.
606      *
607      * Emits an {Approval} event.
608      *
609      * Requirements:
610      *
611      * - `owner` cannot be the zero address.
612      * - `spender` cannot be the zero address.
613      */
614     function _approve(
615         address owner,
616         address spender,
617         uint256 amount
618     ) internal virtual {
619         require(owner != address(0), "ERC20: approve from the zero address");
620         require(spender != address(0), "ERC20: approve to the zero address");
621 
622         _allowances[owner][spender] = amount;
623         emit Approval(owner, spender, amount);
624     }
625 
626     /**
627      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
628      *
629      * Does not update the allowance amount in case of infinite allowance.
630      * Revert if not enough allowance is available.
631      *
632      * Might emit an {Approval} event.
633      */
634     function _spendAllowance(
635         address owner,
636         address spender,
637         uint256 amount
638     ) internal virtual {
639         uint256 currentAllowance = allowance(owner, spender);
640         if (currentAllowance != type(uint256).max) {
641             require(currentAllowance >= amount, "ERC20: insufficient allowance");
642             unchecked {
643                 _approve(owner, spender, currentAllowance - amount);
644             }
645         }
646     }
647 
648     /**
649      * @dev Hook that is called before any transfer of tokens. This includes
650      * minting and burning.
651      *
652      * Calling conditions:
653      *
654      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
655      * will be transferred to `to`.
656      * - when `from` is zero, `amount` tokens will be minted for `to`.
657      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
658      * - `from` and `to` are never both zero.
659      *
660      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
661      */
662     function _beforeTokenTransfer(
663         address from,
664         address to,
665         uint256 amount
666     ) internal virtual {}
667 
668     /**
669      * @dev Hook that is called after any transfer of tokens. This includes
670      * minting and burning.
671      *
672      * Calling conditions:
673      *
674      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
675      * has been transferred to `to`.
676      * - when `from` is zero, `amount` tokens have been minted for `to`.
677      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
678      * - `from` and `to` are never both zero.
679      *
680      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
681      */
682     function _afterTokenTransfer(
683         address from,
684         address to,
685         uint256 amount
686     ) internal virtual {}
687 }
688 
689 interface IUniswapV2Factory {
690     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
691 
692     function feeTo() external view returns (address);
693     function feeToSetter() external view returns (address);
694 
695     function getPair(address tokenA, address tokenB) external view returns (address pair);
696     function allPairs(uint) external view returns (address pair);
697     function allPairsLength() external view returns (uint);
698 
699     function createPair(address tokenA, address tokenB) external returns (address pair);
700 
701     function setFeeTo(address) external;
702     function setFeeToSetter(address) external;
703 }
704 
705 interface IUniswapV2Pair {
706     event Approval(address indexed owner, address indexed spender, uint value);
707     event Transfer(address indexed from, address indexed to, uint value);
708 
709     function name() external pure returns (string memory);
710     function symbol() external pure returns (string memory);
711     function decimals() external pure returns (uint8);
712     function totalSupply() external view returns (uint);
713     function balanceOf(address owner) external view returns (uint);
714     function allowance(address owner, address spender) external view returns (uint);
715 
716     function approve(address spender, uint value) external returns (bool);
717     function transfer(address to, uint value) external returns (bool);
718     function transferFrom(address from, address to, uint value) external returns (bool);
719 
720     function DOMAIN_SEPARATOR() external view returns (bytes32);
721     function PERMIT_TYPEHASH() external pure returns (bytes32);
722     function nonces(address owner) external view returns (uint);
723 
724     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
725 
726     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
727     event Swap(
728         address indexed sender,
729         uint amount0In,
730         uint amount1In,
731         uint amount0Out,
732         uint amount1Out,
733         address indexed to
734     );
735     event Sync(uint112 reserve0, uint112 reserve1);
736 
737     function MINIMUM_LIQUIDITY() external pure returns (uint);
738     function factory() external view returns (address);
739     function token0() external view returns (address);
740     function token1() external view returns (address);
741     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
742     function price0CumulativeLast() external view returns (uint);
743     function price1CumulativeLast() external view returns (uint);
744     function kLast() external view returns (uint);
745 
746     function burn(address to) external returns (uint amount0, uint amount1);
747     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
748     function skim(address to) external;
749     function sync() external;
750 
751     function initialize(address, address) external;
752 }
753 
754 interface IUniswapV2Router01 {
755     function factory() external pure returns (address);
756     function WETH() external pure returns (address);
757 
758     function addLiquidity(
759         address tokenA,
760         address tokenB,
761         uint amountADesired,
762         uint amountBDesired,
763         uint amountAMin,
764         uint amountBMin,
765         address to,
766         uint deadline
767     ) external returns (uint amountA, uint amountB, uint liquidity);
768     function addLiquidityETH(
769         address token,
770         uint amountTokenDesired,
771         uint amountTokenMin,
772         uint amountETHMin,
773         address to,
774         uint deadline
775     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
776     function removeLiquidity(
777         address tokenA,
778         address tokenB,
779         uint liquidity,
780         uint amountAMin,
781         uint amountBMin,
782         address to,
783         uint deadline
784     ) external returns (uint amountA, uint amountB);
785     function removeLiquidityETH(
786         address token,
787         uint liquidity,
788         uint amountTokenMin,
789         uint amountETHMin,
790         address to,
791         uint deadline
792     ) external returns (uint amountToken, uint amountETH);
793     function removeLiquidityWithPermit(
794         address tokenA,
795         address tokenB,
796         uint liquidity,
797         uint amountAMin,
798         uint amountBMin,
799         address to,
800         uint deadline,
801         bool approveMax, uint8 v, bytes32 r, bytes32 s
802     ) external returns (uint amountA, uint amountB);
803     function removeLiquidityETHWithPermit(
804         address token,
805         uint liquidity,
806         uint amountTokenMin,
807         uint amountETHMin,
808         address to,
809         uint deadline,
810         bool approveMax, uint8 v, bytes32 r, bytes32 s
811     ) external returns (uint amountToken, uint amountETH);
812     function swapExactTokensForTokens(
813         uint amountIn,
814         uint amountOutMin,
815         address[] calldata path,
816         address to,
817         uint deadline
818     ) external returns (uint[] memory amounts);
819     function swapTokensForExactTokens(
820         uint amountOut,
821         uint amountInMax,
822         address[] calldata path,
823         address to,
824         uint deadline
825     ) external returns (uint[] memory amounts);
826     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
827         external
828         payable
829         returns (uint[] memory amounts);
830     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
831         external
832         returns (uint[] memory amounts);
833     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
834         external
835         returns (uint[] memory amounts);
836     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
837         external
838         payable
839         returns (uint[] memory amounts);
840 
841     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
842     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
843     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
844     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
845     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
846 }
847 
848 interface IUniswapV2Router02 is IUniswapV2Router01 {
849     function removeLiquidityETHSupportingFeeOnTransferTokens(
850         address token,
851         uint liquidity,
852         uint amountTokenMin,
853         uint amountETHMin,
854         address to,
855         uint deadline
856     ) external returns (uint amountETH);
857     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
858         address token,
859         uint liquidity,
860         uint amountTokenMin,
861         uint amountETHMin,
862         address to,
863         uint deadline,
864         bool approveMax, uint8 v, bytes32 r, bytes32 s
865     ) external returns (uint amountETH);
866 
867     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
868         uint amountIn,
869         uint amountOutMin,
870         address[] calldata path,
871         address to,
872         uint deadline
873     ) external;
874     function swapExactETHForTokensSupportingFeeOnTransferTokens(
875         uint amountOutMin,
876         address[] calldata path,
877         address to,
878         uint deadline
879     ) external payable;
880     function swapExactTokensForETHSupportingFeeOnTransferTokens(
881         uint amountIn,
882         uint amountOutMin,
883         address[] calldata path,
884         address to,
885         uint deadline
886     ) external;
887 }
888 
889 /**
890  * @dev String operations.
891  */
892 library Strings {
893     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
894     uint8 private constant _ADDRESS_LENGTH = 20;
895 
896     /**
897      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
898      */
899     function toString(uint256 value) internal pure returns (string memory) {
900         // Inspired by OraclizeAPI's implementation - MIT licence
901         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
902 
903         if (value == 0) {
904             return "0";
905         }
906         uint256 temp = value;
907         uint256 digits;
908         while (temp != 0) {
909             digits++;
910             temp /= 10;
911         }
912         bytes memory buffer = new bytes(digits);
913         while (value != 0) {
914             digits -= 1;
915             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
916             value /= 10;
917         }
918         return string(buffer);
919     }
920 
921     /**
922      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
923      */
924     function toHexString(uint256 value) internal pure returns (string memory) {
925         if (value == 0) {
926             return "0x00";
927         }
928         uint256 temp = value;
929         uint256 length = 0;
930         while (temp != 0) {
931             length++;
932             temp >>= 8;
933         }
934         return toHexString(value, length);
935     }
936 
937     /**
938      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
939      */
940     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
941         bytes memory buffer = new bytes(2 * length + 2);
942         buffer[0] = "0";
943         buffer[1] = "x";
944         for (uint256 i = 2 * length + 1; i > 1; --i) {
945             buffer[i] = _HEX_SYMBOLS[value & 0xf];
946             value >>= 4;
947         }
948         require(value == 0, "Strings: hex length insufficient");
949         return string(buffer);
950     }
951 
952     /**
953      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
954      */
955     function toHexString(address addr) internal pure returns (string memory) {
956         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
957     }
958 }
959 
960 /**
961  * @dev Interface of the ERC165 standard, as defined in the
962  * https://eips.ethereum.org/EIPS/eip-165[EIP].
963  *
964  * Implementers can declare support of contract interfaces, which can then be
965  * queried by others ({ERC165Checker}).
966  *
967  * For an implementation, see {ERC165}.
968  */
969 interface IERC165 {
970     /**
971      * @dev Returns true if this contract implements the interface defined by
972      * `interfaceId`. See the corresponding
973      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
974      * to learn more about how these ids are created.
975      *
976      * This function call must use less than 30 000 gas.
977      */
978     function supportsInterface(bytes4 interfaceId) external view returns (bool);
979 }
980 
981 /**
982  * @dev Implementation of the {IERC165} interface.
983  *
984  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
985  * for the additional interface id that will be supported. For example:
986  *
987  * ```solidity
988  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
989  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
990  * }
991  * ```
992  *
993  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
994  */
995 abstract contract ERC165 is IERC165 {
996     /**
997      * @dev See {IERC165-supportsInterface}.
998      */
999     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1000         return interfaceId == type(IERC165).interfaceId;
1001     }
1002 }
1003 
1004 /**
1005  * @dev External interface of AccessControl declared to support ERC165 detection.
1006  */
1007 interface IAccessControl {
1008     /**
1009      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
1010      *
1011      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
1012      * {RoleAdminChanged} not being emitted signaling this.
1013      *
1014      * _Available since v3.1._
1015      */
1016     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
1017 
1018     /**
1019      * @dev Emitted when `account` is granted `role`.
1020      *
1021      * `sender` is the account that originated the contract call, an admin role
1022      * bearer except when using {AccessControl-_setupRole}.
1023      */
1024     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
1025 
1026     /**
1027      * @dev Emitted when `account` is revoked `role`.
1028      *
1029      * `sender` is the account that originated the contract call:
1030      *   - if using `revokeRole`, it is the admin role bearer
1031      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
1032      */
1033     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
1034 
1035     /**
1036      * @dev Returns `true` if `account` has been granted `role`.
1037      */
1038     function hasRole(bytes32 role, address account) external view returns (bool);
1039 
1040     /**
1041      * @dev Returns the admin role that controls `role`. See {grantRole} and
1042      * {revokeRole}.
1043      *
1044      * To change a role's admin, use {AccessControl-_setRoleAdmin}.
1045      */
1046     function getRoleAdmin(bytes32 role) external view returns (bytes32);
1047 
1048     /**
1049      * @dev Grants `role` to `account`.
1050      *
1051      * If `account` had not been already granted `role`, emits a {RoleGranted}
1052      * event.
1053      *
1054      * Requirements:
1055      *
1056      * - the caller must have ``role``'s admin role.
1057      */
1058     function grantRole(bytes32 role, address account) external;
1059 
1060     /**
1061      * @dev Revokes `role` from `account`.
1062      *
1063      * If `account` had been granted `role`, emits a {RoleRevoked} event.
1064      *
1065      * Requirements:
1066      *
1067      * - the caller must have ``role``'s admin role.
1068      */
1069     function revokeRole(bytes32 role, address account) external;
1070 
1071     /**
1072      * @dev Revokes `role` from the calling account.
1073      *
1074      * Roles are often managed via {grantRole} and {revokeRole}: this function's
1075      * purpose is to provide a mechanism for accounts to lose their privileges
1076      * if they are compromised (such as when a trusted device is misplaced).
1077      *
1078      * If the calling account had been granted `role`, emits a {RoleRevoked}
1079      * event.
1080      *
1081      * Requirements:
1082      *
1083      * - the caller must be `account`.
1084      */
1085     function renounceRole(bytes32 role, address account) external;
1086 }
1087 
1088 /**
1089  * @dev Contract module that allows children to implement role-based access
1090  * control mechanisms. This is a lightweight version that doesn't allow enumerating role
1091  * members except through off-chain means by accessing the contract event logs. Some
1092  * applications may benefit from on-chain enumerability, for those cases see
1093  * {AccessControlEnumerable}.
1094  *
1095  * Roles are referred to by their `bytes32` identifier. These should be exposed
1096  * in the external API and be unique. The best way to achieve this is by
1097  * using `public constant` hash digests:
1098  *
1099  * ```
1100  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
1101  * ```
1102  *
1103  * Roles can be used to represent a set of permissions. To restrict access to a
1104  * function call, use {hasRole}:
1105  *
1106  * ```
1107  * function foo() public {
1108  *     require(hasRole(MY_ROLE, msg.sender));
1109  *     ...
1110  * }
1111  * ```
1112  *
1113  * Roles can be granted and revoked dynamically via the {grantRole} and
1114  * {revokeRole} functions. Each role has an associated admin role, and only
1115  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
1116  *
1117  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
1118  * that only accounts with this role will be able to grant or revoke other
1119  * roles. More complex role relationships can be created by using
1120  * {_setRoleAdmin}.
1121  *
1122  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
1123  * grant and revoke this role. Extra precautions should be taken to secure
1124  * accounts that have been granted it.
1125  */
1126 abstract contract AccessControl is Context, IAccessControl, ERC165 {
1127     struct RoleData {
1128         mapping(address => bool) members;
1129         bytes32 adminRole;
1130     }
1131 
1132     mapping(bytes32 => RoleData) private _roles;
1133 
1134     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
1135 
1136     /**
1137      * @dev Modifier that checks that an account has a specific role. Reverts
1138      * with a standardized message including the required role.
1139      *
1140      * The format of the revert reason is given by the following regular expression:
1141      *
1142      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
1143      *
1144      * _Available since v4.1._
1145      */
1146     modifier onlyRole(bytes32 role) {
1147         _checkRole(role);
1148         _;
1149     }
1150 
1151     /**
1152      * @dev See {IERC165-supportsInterface}.
1153      */
1154     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1155         return interfaceId == type(IAccessControl).interfaceId || super.supportsInterface(interfaceId);
1156     }
1157 
1158     /**
1159      * @dev Returns `true` if `account` has been granted `role`.
1160      */
1161     function hasRole(bytes32 role, address account) public view virtual override returns (bool) {
1162         return _roles[role].members[account];
1163     }
1164 
1165     /**
1166      * @dev Revert with a standard message if `_msgSender()` is missing `role`.
1167      * Overriding this function changes the behavior of the {onlyRole} modifier.
1168      *
1169      * Format of the revert message is described in {_checkRole}.
1170      *
1171      * _Available since v4.6._
1172      */
1173     function _checkRole(bytes32 role) internal view virtual {
1174         _checkRole(role, _msgSender());
1175     }
1176 
1177     /**
1178      * @dev Revert with a standard message if `account` is missing `role`.
1179      *
1180      * The format of the revert reason is given by the following regular expression:
1181      *
1182      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
1183      */
1184     function _checkRole(bytes32 role, address account) internal view virtual {
1185         if (!hasRole(role, account)) {
1186             revert(
1187                 string(
1188                     abi.encodePacked(
1189                         "AccessControl: account ",
1190                         Strings.toHexString(account),
1191                         " is missing role ",
1192                         Strings.toHexString(uint256(role), 32)
1193                     )
1194                 )
1195             );
1196         }
1197     }
1198 
1199     /**
1200      * @dev Returns the admin role that controls `role`. See {grantRole} and
1201      * {revokeRole}.
1202      *
1203      * To change a role's admin, use {_setRoleAdmin}.
1204      */
1205     function getRoleAdmin(bytes32 role) public view virtual override returns (bytes32) {
1206         return _roles[role].adminRole;
1207     }
1208 
1209     /**
1210      * @dev Grants `role` to `account`.
1211      *
1212      * If `account` had not been already granted `role`, emits a {RoleGranted}
1213      * event.
1214      *
1215      * Requirements:
1216      *
1217      * - the caller must have ``role``'s admin role.
1218      *
1219      * May emit a {RoleGranted} event.
1220      */
1221     function grantRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
1222         _grantRole(role, account);
1223     }
1224 
1225     /**
1226      * @dev Revokes `role` from `account`.
1227      *
1228      * If `account` had been granted `role`, emits a {RoleRevoked} event.
1229      *
1230      * Requirements:
1231      *
1232      * - the caller must have ``role``'s admin role.
1233      *
1234      * May emit a {RoleRevoked} event.
1235      */
1236     function revokeRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
1237         _revokeRole(role, account);
1238     }
1239 
1240     /**
1241      * @dev Revokes `role` from the calling account.
1242      *
1243      * Roles are often managed via {grantRole} and {revokeRole}: this function's
1244      * purpose is to provide a mechanism for accounts to lose their privileges
1245      * if they are compromised (such as when a trusted device is misplaced).
1246      *
1247      * If the calling account had been revoked `role`, emits a {RoleRevoked}
1248      * event.
1249      *
1250      * Requirements:
1251      *
1252      * - the caller must be `account`.
1253      *
1254      * May emit a {RoleRevoked} event.
1255      */
1256     function renounceRole(bytes32 role, address account) public virtual override {
1257         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
1258 
1259         _revokeRole(role, account);
1260     }
1261 
1262     /**
1263      * @dev Grants `role` to `account`.
1264      *
1265      * If `account` had not been already granted `role`, emits a {RoleGranted}
1266      * event. Note that unlike {grantRole}, this function doesn't perform any
1267      * checks on the calling account.
1268      *
1269      * May emit a {RoleGranted} event.
1270      *
1271      * [WARNING]
1272      * ====
1273      * This function should only be called from the constructor when setting
1274      * up the initial roles for the system.
1275      *
1276      * Using this function in any other way is effectively circumventing the admin
1277      * system imposed by {AccessControl}.
1278      * ====
1279      *
1280      * NOTE: This function is deprecated in favor of {_grantRole}.
1281      */
1282     function _setupRole(bytes32 role, address account) internal virtual {
1283         _grantRole(role, account);
1284     }
1285 
1286     /**
1287      * @dev Sets `adminRole` as ``role``'s admin role.
1288      *
1289      * Emits a {RoleAdminChanged} event.
1290      */
1291     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
1292         bytes32 previousAdminRole = getRoleAdmin(role);
1293         _roles[role].adminRole = adminRole;
1294         emit RoleAdminChanged(role, previousAdminRole, adminRole);
1295     }
1296 
1297     /**
1298      * @dev Grants `role` to `account`.
1299      *
1300      * Internal function without access restriction.
1301      *
1302      * May emit a {RoleGranted} event.
1303      */
1304     function _grantRole(bytes32 role, address account) internal virtual {
1305         if (!hasRole(role, account)) {
1306             _roles[role].members[account] = true;
1307             emit RoleGranted(role, account, _msgSender());
1308         }
1309     }
1310 
1311     /**
1312      * @dev Revokes `role` from `account`.
1313      *
1314      * Internal function without access restriction.
1315      *
1316      * May emit a {RoleRevoked} event.
1317      */
1318     function _revokeRole(bytes32 role, address account) internal virtual {
1319         if (hasRole(role, account)) {
1320             _roles[role].members[account] = false;
1321             emit RoleRevoked(role, account, _msgSender());
1322         }
1323     }
1324 }
1325 
1326 contract BlackSwan is AccessControl, ERC20 {
1327     using Address for address;
1328     address public autoLiquidityReceiver;
1329     address public treasuryFeeReceiver;
1330     address pair;
1331     bytes32 public constant ADMIN_ROLE = keccak256("ADMIN_ROLE");
1332     uint256 _totalSupply = 100_000 * (10**9); // total supply amount
1333     uint256 treasuryFees;
1334     uint256 feeAmount;
1335     uint16 feeDenominator = 10000;
1336     uint16 feeType;
1337     uint16[4] liquidityFee;
1338     uint16[4] treasuryFee;
1339     uint16[4] totalFee;
1340 
1341     bool public feeEnabled;
1342     bool public tradingOpen;
1343     mapping(address => bool) public lpPairs;    
1344     mapping(address => bool) lpHolder;
1345     mapping(address => uint256) cooldown;
1346     mapping(address => bool) isFeeExempt;
1347     mapping(address => bool) maxWalletExempt;
1348     mapping(address => bool) public bannedUsers;
1349 
1350     struct ICooldown {
1351         bool buycooldownEnabled;
1352         bool sellcooldownEnabled;
1353         uint8 cooldownLimit;
1354         uint8 cooldownTime;
1355     }
1356     struct ILiquiditySettings {
1357         uint256 liquidityFeeAccumulator;
1358         uint256 numTokensToSwap;
1359         uint256 lastSwap;
1360         uint8 swapInterval;
1361         bool swapEnabled;
1362         bool inSwap;
1363         bool autoLiquifyEnabled;
1364     }
1365 
1366     struct ITransactionSettings {
1367         uint256 maxTxAmount;
1368         uint256 maxWalletAmount;
1369         bool txLimits;
1370     }        
1371     IUniswapV2Router02 router;
1372     ILiquiditySettings public LiquiditySettings;
1373     ICooldown public cooldownInfo;    
1374     ITransactionSettings public TransactionSettings;
1375     modifier swapping() {
1376         LiquiditySettings.inSwap = true;
1377         _;
1378         LiquiditySettings.inSwap = false;
1379     }
1380 
1381     constructor() ERC20("BlackSwan", "SWAN") {
1382         _setRoleAdmin(ADMIN_ROLE, DEFAULT_ADMIN_ROLE);
1383 
1384         _grantRole(ADMIN_ROLE, _msgSender());        
1385         _grantRole(DEFAULT_ADMIN_ROLE, _msgSender());
1386 
1387         router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
1388         pair = IUniswapV2Factory(router.factory()).createPair(router.WETH(), address(this));
1389         lpPairs[pair] = true;
1390         lpHolder[_msgSender()] = true;
1391 
1392         _approve(address(this), address(router), type(uint256).max);
1393         _approve(_msgSender(), address(router), type(uint256).max);
1394 
1395         isFeeExempt[address(this)] = true;
1396         isFeeExempt[_msgSender()] = true;
1397 
1398         maxWalletExempt[_msgSender()] = true;
1399         maxWalletExempt[address(this)] = true;
1400         maxWalletExempt[pair] = true;
1401 
1402         setFeeReceivers(_msgSender(),_msgSender());
1403         cooldownInfo.cooldownLimit = 60; // cooldown cannot go over 60 seconds
1404         totalFee[3] = 2000; // 20% Max Fee
1405 
1406         _mint(_msgSender(), _totalSupply);
1407     }
1408     receive() external payable {}
1409     
1410     function decimals() public view virtual override returns (uint8) {
1411         return 9;
1412     }
1413 
1414     function setLp(address _holder, bool pairing, bool holder) external onlyRole(ADMIN_ROLE){
1415         lpPairs[_holder] = pairing;
1416         lpHolder[_holder] = holder;
1417     }
1418 
1419     function setRouter(IUniswapV2Router02 newRouter) external onlyRole(ADMIN_ROLE) {
1420         address newPair = IUniswapV2Factory(newRouter.factory()).getPair(router.WETH(), address(this));
1421         if (newPair == address(0)) {
1422             pair = IUniswapV2Factory(newRouter.factory()).createPair(router.WETH(), address(this));
1423             lpPairs[pair] = true;
1424             maxWalletExempt[pair] = true;
1425         } else {
1426             pair = newPair;
1427             lpPairs[pair] = true;
1428             maxWalletExempt[pair] = true;
1429         }
1430         router = newRouter;
1431         _approve(address(this), address(router), type(uint256).max);
1432     }
1433 
1434     function getFees(uint8 _feeType) external view returns(uint16 _totalFee, uint16 _treasuryFee,uint16 _liquidityFee, string memory Type){
1435         require(_feeType < 4);
1436         _totalFee = totalFee[_feeType];
1437         _treasuryFee = treasuryFee[_feeType];
1438         _liquidityFee = liquidityFee[_feeType];
1439         if(_feeType == 0)
1440         Type = 'Sell';
1441         else if(_feeType == 1)
1442         Type = 'Buy';
1443         else if(_feeType == 2)
1444         Type = 'Transfer';
1445         else
1446         Type = 'Max';
1447     }
1448 
1449     function getAccumulatedFees() external view returns (uint256 treasuryAmount) {
1450         treasuryAmount = treasuryFees;
1451     }
1452 
1453     function limits(address from, address to) private view returns (bool) {
1454         return !hasRole(ADMIN_ROLE, from)
1455             && !hasRole(ADMIN_ROLE, to)
1456             && !hasRole(ADMIN_ROLE, tx.origin)
1457             && !lpHolder[from]
1458             && !lpHolder[to]
1459             && to != address(0xdead)
1460             && from != address(this);
1461     }
1462 
1463     function airDropTokens(address[] memory addresses, uint256[] memory amounts) external onlyRole(ADMIN_ROLE) {
1464         require(addresses.length == amounts.length, "Lengths do not match.");
1465         for (uint8 i = 0; i < addresses.length; i++) {
1466             require(balanceOf(_msgSender()) >= amounts[i]);
1467             _basicTransfer(_msgSender(), addresses[i], amounts[i]*10**9);
1468         }
1469     }
1470 
1471     function _basicTransfer(address from, address to, uint256 amount) internal {
1472         super._transfer(from, to, amount);
1473     }
1474 
1475     function _setBlacklistStatus(address account, bool blacklisted) internal {
1476         if (blacklisted) {
1477             bannedUsers[account] = true;
1478         } else {
1479             bannedUsers[account] = false;
1480         }           
1481     }
1482     
1483     function setWalletBanStatus(address[] memory user, bool banned) external onlyRole(ADMIN_ROLE) {
1484         for(uint256 i; i < user.length; i++) {
1485             _setBlacklistStatus(user[i], banned);
1486             emit WalletBanStatusUpdated(user[i], banned);
1487         }
1488     }
1489 
1490     function _transfer(address from, address to, uint256 amount ) internal override {
1491         if (LiquiditySettings.inSwap) {
1492             _basicTransfer(from, to, amount);
1493         } else {
1494             require(!bannedUsers[from]);
1495             require(!bannedUsers[to]);
1496             if(!tradingOpen) checkLaunched(from);
1497             if(limits(from, to) && tradingOpen && TransactionSettings.txLimits){
1498                 require(amount <= TransactionSettings.maxTxAmount);
1499                 if(!maxWalletExempt[to]){
1500                     require(balanceOf(to) + amount <= TransactionSettings.maxWalletAmount, "TOKEN: Amount exceeds Transaction size");
1501                 }
1502                 if (lpPairs[from] && to != address(router) && !isFeeExempt[to] && cooldownInfo.buycooldownEnabled) {
1503                     require(cooldown[to] < block.timestamp);
1504                     cooldown[to] = block.timestamp + (cooldownInfo.cooldownTime);
1505                 } else if (!lpPairs[from] && !isFeeExempt[from] && cooldownInfo.sellcooldownEnabled){
1506                     require(cooldown[from] <= block.timestamp);
1507                     cooldown[from] = block.timestamp + (cooldownInfo.cooldownTime);
1508                 } 
1509             }
1510             if (shouldSwapBack()) {
1511                 swapBack();
1512             }
1513             uint256 amountReceived = shouldTakeFee(from) ? takeFee(from, to, amount) : amount;
1514             _basicTransfer(from, to, amountReceived);
1515         }
1516     }
1517 
1518 
1519     function checkLaunched(address from) internal view {
1520         require(tradingOpen || lpHolder[from], "Pre-Launch Protection");
1521     }
1522 
1523     function shouldTakeFee(address from) internal view returns (bool) {
1524         return feeEnabled && !isFeeExempt[from];
1525     }
1526 
1527     function takeFee(address from, address to, uint256 amount) internal returns (uint256) {
1528         if (isFeeExempt[to]) {
1529             return amount;
1530         }
1531         if(lpPairs[to]) {
1532             if(feeType != 0)
1533                 feeType = 0;
1534         } else if(lpPairs[from]){
1535             if(feeType != 1)
1536                 feeType = 1;
1537         } else {
1538             if(feeType != 2)
1539                 feeType = 2;
1540         }
1541 
1542         feeAmount = (amount * totalFee[feeType]) / feeDenominator;
1543         if(LiquiditySettings.autoLiquifyEnabled){
1544             LiquiditySettings.liquidityFeeAccumulator += (feeAmount * (liquidityFee[1] + liquidityFee[0])) / ((totalFee[1] + totalFee[0]) + (liquidityFee[1] + liquidityFee[0]));
1545         }
1546 
1547         _basicTransfer(from, address(this), feeAmount);
1548 
1549         return amount - feeAmount;
1550     }
1551 
1552     function shouldSwapBack() internal view returns (bool) {
1553         return
1554             !lpPairs[_msgSender()] &&
1555             !LiquiditySettings.inSwap &&
1556             LiquiditySettings.swapEnabled &&
1557             block.timestamp >= LiquiditySettings.lastSwap + LiquiditySettings.swapInterval &&
1558             balanceOf(address(this)) >= LiquiditySettings.numTokensToSwap;
1559     }
1560 
1561     function swapTokens(uint256 amount) internal {
1562         address[] memory path = new address[](2);
1563         path[0] = address(this);
1564         path[1] = router.WETH();
1565 
1566         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1567             amount,
1568             0,
1569             path,
1570             address(this),
1571             block.timestamp
1572         );
1573     }
1574 
1575     function swapBack() internal swapping {
1576         if(allowance(address(this), address(router)) < LiquiditySettings.numTokensToSwap){
1577             _approve(address(this), address(router), type(uint256).max);
1578         }
1579         LiquiditySettings.lastSwap = block.timestamp;
1580         if (LiquiditySettings.liquidityFeeAccumulator >= LiquiditySettings.numTokensToSwap && LiquiditySettings.autoLiquifyEnabled) {
1581             LiquiditySettings.liquidityFeeAccumulator -= LiquiditySettings.numTokensToSwap;
1582             uint256 amountToLiquify = LiquiditySettings.numTokensToSwap / 2;
1583 
1584             uint256 balanceBefore = address(this).balance;
1585             swapTokens(amountToLiquify);
1586             uint256 amountEth = address(this).balance - (balanceBefore);
1587 
1588             router.addLiquidityETH{value: amountEth}(
1589                 address(this),
1590                 amountToLiquify,
1591                 0,
1592                 0,
1593                 autoLiquidityReceiver,
1594                 block.timestamp
1595             );
1596 
1597             emit AutoLiquify(amountEth, amountToLiquify);
1598         } else {
1599 
1600             uint256 balanceBefore = address(this).balance;
1601             swapTokens(LiquiditySettings.numTokensToSwap);
1602             uint256 amountEth = address(this).balance - (balanceBefore);
1603 
1604             uint256 amountEthTreasury = (amountEth * (treasuryFee[0] + treasuryFee[1])) / (totalFee[0] + totalFee[1]);
1605             payTreasury(amountEthTreasury);
1606 
1607             emit SwapBack(LiquiditySettings.numTokensToSwap, amountEth);
1608         }
1609     }
1610 
1611     function payTreasury(uint256 treasuryAmount) internal returns(bool treasury) {
1612         require(treasuryAmount < address(this).balance);
1613         (treasury, ) = payable(treasuryFeeReceiver).call{ value: treasuryAmount, gas: 30000}("");
1614         treasuryFees += treasuryAmount;
1615     }
1616 
1617     function launch() public onlyRole(ADMIN_ROLE) {
1618         LiquiditySettings.autoLiquifyEnabled = true;        
1619         TransactionSettings.txLimits = true;
1620         LiquiditySettings.swapEnabled = true;
1621         LiquiditySettings.numTokensToSwap = (_totalSupply * 10) / (10000);
1622         cooldownInfo.cooldownTime = 30;
1623         cooldownInfo.buycooldownEnabled = true;
1624         cooldownInfo.sellcooldownEnabled = true;
1625         TransactionSettings.maxTxAmount = (_totalSupply * 1) / 100;
1626         TransactionSettings.maxWalletAmount = (_totalSupply * 15) / 1000;
1627         feeEnabled = true;
1628         setFees(100, 400, 0);
1629         setFees(100, 400, 1);
1630         setFees(0, 0, 2);   
1631         tradingOpen = true;
1632         emit Launched();
1633     }
1634 
1635     function setTransactionLimits(bool enabled) external onlyRole(ADMIN_ROLE) {
1636         TransactionSettings.txLimits = enabled;
1637     }
1638 
1639     function setTxLimit(uint256 percent, uint256 divisor) external onlyRole(ADMIN_ROLE) {
1640         require(percent >= 1 && divisor <= 1000);
1641         TransactionSettings.maxTxAmount = (_totalSupply * (percent)) / (divisor);
1642         emit TxLimitUpdated(TransactionSettings.maxTxAmount);
1643     }
1644 
1645     function setMaxWallet(uint256 percent, uint256 divisor) external onlyRole(ADMIN_ROLE) {
1646         require(percent >= 1 && divisor <= 1000);
1647         TransactionSettings.maxWalletAmount = (_totalSupply * percent) / divisor;
1648         emit WalletLimitUpdated(TransactionSettings.maxWalletAmount);
1649     }
1650 
1651     function setExempt(address holder, bool fee, bool wallet) external onlyRole(ADMIN_ROLE) {
1652         isFeeExempt[holder] = fee;
1653         maxWalletExempt[holder] = wallet;
1654     }
1655 
1656     function setFees(uint16 _liquidityFee, uint16 _treasuryFee, uint8 _feeType) public onlyRole(ADMIN_ROLE) {
1657         require(_feeType < 4);
1658         require(_liquidityFee + _treasuryFee <= totalFee[3]);
1659         liquidityFee[_feeType] = _liquidityFee;
1660         treasuryFee[_feeType] = _treasuryFee;
1661         totalFee[_feeType] = _liquidityFee + _treasuryFee;
1662     }
1663 
1664     function setFeesEnabled(bool _enabled) external onlyRole(ADMIN_ROLE) {
1665         feeEnabled = _enabled;
1666         emit FeesEnabled(_enabled);
1667     }
1668 
1669     function setFeeReceivers(address _autoLiquidityReceiver, address _treasuryFeeReceiver) public onlyRole(ADMIN_ROLE) {
1670         autoLiquidityReceiver = _autoLiquidityReceiver;
1671         treasuryFeeReceiver = _treasuryFeeReceiver;
1672         emit FeeReceiversUpdated(_autoLiquidityReceiver, _treasuryFeeReceiver);
1673     }
1674 
1675     function setCooldownEnabled(bool buy, bool sell, uint8 _cooldown) external onlyRole(ADMIN_ROLE) {
1676         require(_cooldown <= cooldownInfo.cooldownLimit);
1677         cooldownInfo.cooldownTime = _cooldown;
1678         cooldownInfo.buycooldownEnabled = buy;
1679         cooldownInfo.sellcooldownEnabled = sell;
1680     }
1681 
1682     function setSwapBackSettings(bool _enabled, uint256 _amount) external onlyRole(ADMIN_ROLE) {
1683         LiquiditySettings.swapEnabled = _enabled;
1684         LiquiditySettings.numTokensToSwap = (_totalSupply * (_amount)) / (10000);
1685         emit SwapBackSettingsUpdated(_enabled, _amount);
1686     }
1687 
1688    function setAutoLiquifyEnabled(bool _enabled) external onlyRole(ADMIN_ROLE) {
1689         LiquiditySettings.autoLiquifyEnabled = _enabled;
1690         emit AutoLiquifyUpdated(_enabled);
1691     }
1692 
1693     function clearStuckBalance(uint256 amountPercentage) external onlyRole(ADMIN_ROLE) {
1694         require(amountPercentage <= 100);
1695         uint256 amountEth = address(this).balance;
1696         payTreasury((amountEth * amountPercentage) / 100);
1697     }
1698 
1699     function clearStuckToken(address to) external onlyRole(ADMIN_ROLE) {
1700         uint256 _balance = balanceOf(address(this));
1701         _basicTransfer(address(this), to, _balance);
1702     }
1703 
1704     function clearStuckTokens(address _token, address _to) external onlyRole(ADMIN_ROLE) returns (bool _sent) {
1705         require(_token != address(0));
1706         uint256 _contractBalance = IERC20(_token).balanceOf(address(this));
1707         _sent = IERC20(_token).transfer(_to, _contractBalance);
1708     }
1709 
1710     event WalletLimitUpdated(uint256 amount);
1711     event Launched();
1712     event AutoLiquify(uint256 amountEth, uint256 amountToken);
1713     event SwapBack(uint256 amountToken, uint256 amountEth);
1714     event TxLimitUpdated(uint256 amount);
1715     event FeeReceiversUpdated(address autoLiquidityReceiver, address treasuryFeeReceiver);
1716     event SwapBackSettingsUpdated(bool enabled, uint256 amount);
1717     event FeesEnabled(bool _enabled);
1718     event AutoLiquifyUpdated(bool enabled);
1719     event WalletBanStatusUpdated(address user, bool banned);
1720 }