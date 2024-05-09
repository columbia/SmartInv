1 /*
2    Find us on Twitter https://twitter.com/JPEGMorganCap
3    https://jpegmorgan.capital/
4    https://t.me/jpegmorgan
5 
6    A labor of love for @sodefi from Misa. 
7    WGMI
8     
9 */
10 
11 // SPDX-License-Identifier: MIT
12 
13 pragma solidity =0.8.10 >=0.8.0 <0.9.0;
14 pragma experimental ABIEncoderV2;
15 
16 
17 abstract contract Context {
18     function _msgSender() internal view virtual returns (address) {
19         return msg.sender;
20     }
21 
22     function _msgData() internal view virtual returns (bytes calldata) {
23         return msg.data;
24     }
25 }
26 
27 abstract contract Ownable is Context {
28     address private _owner;
29 
30     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
31 
32     constructor() {
33         _transferOwnership(_msgSender());
34     }
35 
36     function owner() public view virtual returns (address) {
37         return _owner;
38     }
39 
40     modifier onlyOwner() {
41         require(owner() == _msgSender(), "Ownable: caller is not the owner");
42         _;
43     }
44 
45     /**
46      * @dev Transfers ownership of the contract to a new account (`newOwner`).
47      * Can only be called by the current owner.
48      */
49     function transferOwnership(address newOwner) public virtual onlyOwner {
50         require(newOwner != address(0), "Ownable: new owner is the zero address");
51         _transferOwnership(newOwner);
52     }
53 
54     /**
55      * @dev Transfers ownership of the contract to a new account (`newOwner`).
56      * Internal function without access restriction.
57      */
58     function _transferOwnership(address newOwner) internal virtual {
59         address oldOwner = _owner;
60         _owner = newOwner;
61         emit OwnershipTransferred(oldOwner, newOwner);
62     }
63 }
64 
65 interface IERC20 {
66     /**
67      * @dev Returns the amount of tokens in existence.
68      */
69     function totalSupply() external view returns (uint256);
70 
71     /**
72      * @dev Returns the amount of tokens owned by `account`.
73      */
74     function balanceOf(address account) external view returns (uint256);
75 
76     /**
77      * @dev Moves `amount` tokens from the caller's account to `recipient`.
78      *
79      * Returns a boolean value indicating whether the operation succeeded.
80      *
81      * Emits a {Transfer} event.
82      */
83     function transfer(address recipient, uint256 amount) external returns (bool);
84 
85     /**
86      * @dev Returns the remaining number of tokens that `spender` will be
87      * allowed to spend on behalf of `owner` through {transferFrom}. This is
88      * zero by default.
89      *
90      * This value changes when {approve} or {transferFrom} are called.
91      */
92     function allowance(address owner, address spender) external view returns (uint256);
93 
94     /**
95      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
96      *
97      * Returns a boolean value indicating whether the operation succeeded.
98      *
99      * IMPORTANT: Beware that changing an allowance with this method brings the risk
100      * that someone may use both the old and the new allowance by unfortunate
101      * transaction ordering. One possible solution to mitigate this race
102      * condition is to first reduce the spender's allowance to 0 and set the
103      * desired value afterwards:
104      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
105      *
106      * Emits an {Approval} event.
107      */
108     function approve(address spender, uint256 amount) external returns (bool);
109 
110     /**
111      * @dev Moves `amount` tokens from `sender` to `recipient` using the
112      * allowance mechanism. `amount` is then deducted from the caller's
113      * allowance.
114      *
115      * Returns a boolean value indicating whether the operation succeeded.
116      *
117      * Emits a {Transfer} event.
118      */
119     function transferFrom(
120         address sender,
121         address recipient,
122         uint256 amount
123     ) external returns (bool);
124 
125     /**
126      * @dev Emitted when `value` tokens are moved from one account (`from`) to
127      * another (`to`).
128      *
129      * Note that `value` may be zero.
130      */
131     event Transfer(address indexed from, address indexed to, uint256 value);
132 
133     /**
134      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
135      * a call to {approve}. `value` is the new allowance.
136      */
137     event Approval(address indexed owner, address indexed spender, uint256 value);
138 }
139 
140 interface IERC20Metadata is IERC20 {
141     /**
142      * @dev Returns the name of the token.
143      */
144     function name() external view returns (string memory);
145 
146     /**
147      * @dev Returns the symbol of the token.
148      */
149     function symbol() external view returns (string memory);
150 
151     /**
152      * @dev Returns the decimals places of the token.
153      */
154     function decimals() external view returns (uint8);
155 }
156 
157 contract ERC20 is Context, IERC20, IERC20Metadata {
158     mapping(address => uint256) private _balances;
159 
160     mapping(address => mapping(address => uint256)) private _allowances;
161 
162     uint256 private _totalSupply;
163 
164     string private _name;
165     string private _symbol;
166 
167     /**
168      * @dev Sets the values for {name} and {symbol}.
169      *
170      * The default value of {decimals} is 18. To select a different value for
171      * {decimals} you should overload it.
172      *
173      * All two of these values are immutable: they can only be set once during
174      * construction.
175      */
176     constructor(string memory name_, string memory symbol_) {
177         _name = name_;
178         _symbol = symbol_;
179     }
180 
181     /**
182      * @dev Returns the name of the token.
183      */
184     function name() public view virtual override returns (string memory) {
185         return _name;
186     }
187 
188     /**
189      * @dev Returns the symbol of the token, usually a shorter version of the
190      * name.
191      */
192     function symbol() public view virtual override returns (string memory) {
193         return _symbol;
194     }
195 
196     /**
197      * @dev Returns the number of decimals used to get its user representation.
198      * For example, if `decimals` equals `2`, a balance of `505` tokens should
199      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
200      *
201      * Tokens usually opt for a value of 18, imitating the relationship between
202      * Ether and Wei. This is the value {ERC20} uses, unless this function is
203      * overridden;
204      *
205      * NOTE: This information is only used for _display_ purposes: it in
206      * no way affects any of the arithmetic of the contract, including
207      * {IERC20-balanceOf} and {IERC20-transfer}.
208      */
209     function decimals() public view virtual override returns (uint8) {
210         return 18;
211     }
212 
213     /**
214      * @dev See {IERC20-totalSupply}.
215      */
216     function totalSupply() public view virtual override returns (uint256) {
217         return _totalSupply;
218     }
219 
220     /**
221      * @dev See {IERC20-balanceOf}.
222      */
223     function balanceOf(address account) public view virtual override returns (uint256) {
224         return _balances[account];
225     }
226 
227     /**
228      * @dev See {IERC20-transfer}.
229      *
230      * Requirements:
231      *
232      * - `recipient` cannot be the zero address.
233      * - the caller must have a balance of at least `amount`.
234      */
235     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
236         _transfer(_msgSender(), recipient, amount);
237         return true;
238     }
239 
240     /**
241      * @dev See {IERC20-allowance}.
242      */
243     function allowance(address owner, address spender) public view virtual override returns (uint256) {
244         return _allowances[owner][spender];
245     }
246 
247     /**
248      * @dev See {IERC20-approve}.
249      *
250      * Requirements:
251      *
252      * - `spender` cannot be the zero address.
253      */
254     function approve(address spender, uint256 amount) public virtual override returns (bool) {
255         _approve(_msgSender(), spender, amount);
256         return true;
257     }
258 
259     /**
260      * @dev See {IERC20-transferFrom}.
261      *
262      * Emits an {Approval} event indicating the updated allowance. This is not
263      * required by the EIP. See the note at the beginning of {ERC20}.
264      *
265      * Requirements:
266      *
267      * - `sender` and `recipient` cannot be the zero address.
268      * - `sender` must have a balance of at least `amount`.
269      * - the caller must have allowance for ``sender``'s tokens of at least
270      * `amount`.
271      */
272     function transferFrom(
273         address sender,
274         address recipient,
275         uint256 amount
276     ) public virtual override returns (bool) {
277         _transfer(sender, recipient, amount);
278 
279         uint256 currentAllowance = _allowances[sender][_msgSender()];
280         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
281         unchecked {
282             _approve(sender, _msgSender(), currentAllowance - amount);
283         }
284 
285         return true;
286     }
287 
288     /**
289      * @dev Atomically increases the allowance granted to `spender` by the caller.
290      *
291      * This is an alternative to {approve} that can be used as a mitigation for
292      * problems described in {IERC20-approve}.
293      *
294      * Emits an {Approval} event indicating the updated allowance.
295      *
296      * Requirements:
297      *
298      * - `spender` cannot be the zero address.
299      */
300     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
301         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
302         return true;
303     }
304 
305     /**
306      * @dev Atomically decreases the allowance granted to `spender` by the caller.
307      *
308      * This is an alternative to {approve} that can be used as a mitigation for
309      * problems described in {IERC20-approve}.
310      *
311      * Emits an {Approval} event indicating the updated allowance.
312      *
313      * Requirements:
314      *
315      * - `spender` cannot be the zero address.
316      * - `spender` must have allowance for the caller of at least
317      * `subtractedValue`.
318      */
319     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
320         uint256 currentAllowance = _allowances[_msgSender()][spender];
321         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
322         unchecked {
323             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
324         }
325 
326         return true;
327     }
328 
329     /**
330      * @dev Moves `amount` of tokens from `sender` to `recipient`.
331      *
332      * This internal function is equivalent to {transfer}, and can be used to
333      * e.g. implement automatic token fees, slashing mechanisms, etc.
334      *
335      * Emits a {Transfer} event.
336      *
337      * Requirements:
338      *
339      * - `sender` cannot be the zero address.
340      * - `recipient` cannot be the zero address.
341      * - `sender` must have a balance of at least `amount`.
342      */
343     function _transfer(
344         address sender,
345         address recipient,
346         uint256 amount
347     ) internal virtual {
348         require(sender != address(0), "ERC20: transfer from the zero address");
349         require(recipient != address(0), "ERC20: transfer to the zero address");
350 
351         _beforeTokenTransfer(sender, recipient, amount);
352 
353         uint256 senderBalance = _balances[sender];
354         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
355         unchecked {
356             _balances[sender] = senderBalance - amount;
357         }
358         _balances[recipient] += amount;
359 
360         emit Transfer(sender, recipient, amount);
361 
362         _afterTokenTransfer(sender, recipient, amount);
363     }
364 
365     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
366      * the total supply.
367      *
368      * Emits a {Transfer} event with `from` set to the zero address.
369      *
370      * Requirements:
371      *
372      * - `account` cannot be the zero address.
373      */
374     function _mint(address account, uint256 amount) internal virtual {
375         require(account != address(0), "ERC20: mint to the zero address");
376 
377         _beforeTokenTransfer(address(0), account, amount);
378 
379         _totalSupply += amount;
380         _balances[account] += amount;
381         emit Transfer(address(0), account, amount);
382 
383         _afterTokenTransfer(address(0), account, amount);
384     }
385 
386     /**
387      * @dev Destroys `amount` tokens from `account`, reducing the
388      * total supply.
389      *
390      * Emits a {Transfer} event with `to` set to the zero address.
391      *
392      * Requirements:
393      *
394      * - `account` cannot be the zero address.
395      * - `account` must have at least `amount` tokens.
396      */
397     function _burn(address account, uint256 amount) internal virtual {
398         require(account != address(0), "ERC20: burn from the zero address");
399 
400         _beforeTokenTransfer(account, address(0), amount);
401 
402         uint256 accountBalance = _balances[account];
403         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
404         unchecked {
405             _balances[account] = accountBalance - amount;
406         }
407         _totalSupply -= amount;
408 
409         emit Transfer(account, address(0), amount);
410 
411         _afterTokenTransfer(account, address(0), amount);
412     }
413 
414     /**
415      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
416      *
417      * This internal function is equivalent to `approve`, and can be used to
418      * e.g. set automatic allowances for certain subsystems, etc.
419      *
420      * Emits an {Approval} event.
421      *
422      * Requirements:
423      *
424      * - `owner` cannot be the zero address.
425      * - `spender` cannot be the zero address.
426      */
427     function _approve(
428         address owner,
429         address spender,
430         uint256 amount
431     ) internal virtual {
432         require(owner != address(0), "ERC20: approve from the zero address");
433         require(spender != address(0), "ERC20: approve to the zero address");
434 
435         _allowances[owner][spender] = amount;
436         emit Approval(owner, spender, amount);
437     }
438 
439     /**
440      * @dev Hook that is called before any transfer of tokens. This includes
441      * minting and burning.
442      *
443      * Calling conditions:
444      *
445      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
446      * will be transferred to `to`.
447      * - when `from` is zero, `amount` tokens will be minted for `to`.
448      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
449      * - `from` and `to` are never both zero.
450      *
451      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
452      */
453     function _beforeTokenTransfer(
454         address from,
455         address to,
456         uint256 amount
457     ) internal virtual {}
458 
459     /**
460      * @dev Hook that is called after any transfer of tokens. This includes
461      * minting and burning.
462      *
463      * Calling conditions:
464      *
465      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
466      * has been transferred to `to`.
467      * - when `from` is zero, `amount` tokens have been minted for `to`.
468      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
469      * - `from` and `to` are never both zero.
470      *
471      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
472      */
473     function _afterTokenTransfer(
474         address from,
475         address to,
476         uint256 amount
477     ) internal virtual {}
478 }
479 
480 library Address {
481     /**
482      * @dev Returns true if `account` is a contract.
483      *
484      * [IMPORTANT]
485      * ====
486      * It is unsafe to assume that an address for which this function returns
487      * false is an externally-owned account (EOA) and not a contract.
488      *
489      * Among others, `isContract` will return false for the following
490      * types of addresses:
491      *
492      *  - an externally-owned account
493      *  - a contract in construction
494      *  - an address where a contract will be created
495      *  - an address where a contract lived, but was destroyed
496      * ====
497      */
498     function isContract(address account) internal view returns (bool) {
499         // This method relies on extcodesize, which returns 0 for contracts in
500         // construction, since the code is only stored at the end of the
501         // constructor execution.
502 
503         uint256 size;
504         assembly {
505             size := extcodesize(account)
506         }
507         return size > 0;
508     }
509 
510     /**
511      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
512      * `recipient`, forwarding all available gas and reverting on errors.
513      *
514      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
515      * of certain opcodes, possibly making contracts go over the 2300 gas limit
516      * imposed by `transfer`, making them unable to receive funds via
517      * `transfer`. {sendValue} removes this limitation.
518      *
519      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
520      *
521      * IMPORTANT: because control is transferred to `recipient`, care must be
522      * taken to not create reentrancy vulnerabilities. Consider using
523      * {ReentrancyGuard} or the
524      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
525      */
526     function sendValue(address payable recipient, uint256 amount) internal {
527         require(address(this).balance >= amount, "Address: insufficient balance");
528 
529         (bool success, ) = recipient.call{value: amount}("");
530         require(success, "Address: unable to send value, recipient may have reverted");
531     }
532 
533     /**
534      * @dev Performs a Solidity function call using a low level `call`. A
535      * plain `call` is an unsafe replacement for a function call: use this
536      * function instead.
537      *
538      * If `target` reverts with a revert reason, it is bubbled up by this
539      * function (like regular Solidity function calls).
540      *
541      * Returns the raw returned data. To convert to the expected return value,
542      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
543      *
544      * Requirements:
545      *
546      * - `target` must be a contract.
547      * - calling `target` with `data` must not revert.
548      *
549      * _Available since v3.1._
550      */
551     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
552         return functionCall(target, data, "Address: low-level call failed");
553     }
554 
555     /**
556      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
557      * `errorMessage` as a fallback revert reason when `target` reverts.
558      *
559      * _Available since v3.1._
560      */
561     function functionCall(
562         address target,
563         bytes memory data,
564         string memory errorMessage
565     ) internal returns (bytes memory) {
566         return functionCallWithValue(target, data, 0, errorMessage);
567     }
568 
569     /**
570      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
571      * but also transferring `value` wei to `target`.
572      *
573      * Requirements:
574      *
575      * - the calling contract must have an ETH balance of at least `value`.
576      * - the called Solidity function must be `payable`.
577      *
578      * _Available since v3.1._
579      */
580     function functionCallWithValue(
581         address target,
582         bytes memory data,
583         uint256 value
584     ) internal returns (bytes memory) {
585         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
586     }
587 
588     /**
589      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
590      * with `errorMessage` as a fallback revert reason when `target` reverts.
591      *
592      * _Available since v3.1._
593      */
594     function functionCallWithValue(
595         address target,
596         bytes memory data,
597         uint256 value,
598         string memory errorMessage
599     ) internal returns (bytes memory) {
600         require(address(this).balance >= value, "Address: insufficient balance for call");
601         require(isContract(target), "Address: call to non-contract");
602 
603         (bool success, bytes memory returndata) = target.call{value: value}(data);
604         return verifyCallResult(success, returndata, errorMessage);
605     }
606 
607     /**
608      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
609      * but performing a static call.
610      *
611      * _Available since v3.3._
612      */
613     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
614         return functionStaticCall(target, data, "Address: low-level static call failed");
615     }
616 
617     /**
618      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
619      * but performing a static call.
620      *
621      * _Available since v3.3._
622      */
623     function functionStaticCall(
624         address target,
625         bytes memory data,
626         string memory errorMessage
627     ) internal view returns (bytes memory) {
628         require(isContract(target), "Address: static call to non-contract");
629 
630         (bool success, bytes memory returndata) = target.staticcall(data);
631         return verifyCallResult(success, returndata, errorMessage);
632     }
633 
634     /**
635      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
636      * but performing a delegate call.
637      *
638      * _Available since v3.4._
639      */
640     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
641         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
642     }
643 
644     /**
645      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
646      * but performing a delegate call.
647      *
648      * _Available since v3.4._
649      */
650     function functionDelegateCall(
651         address target,
652         bytes memory data,
653         string memory errorMessage
654     ) internal returns (bytes memory) {
655         require(isContract(target), "Address: delegate call to non-contract");
656 
657         (bool success, bytes memory returndata) = target.delegatecall(data);
658         return verifyCallResult(success, returndata, errorMessage);
659     }
660 
661     /**
662      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
663      * revert reason using the provided one.
664      *
665      * _Available since v4.3._
666      */
667     function verifyCallResult(
668         bool success,
669         bytes memory returndata,
670         string memory errorMessage
671     ) internal pure returns (bytes memory) {
672         if (success) {
673             return returndata;
674         } else {
675             // Look for revert reason and bubble it up if present
676             if (returndata.length > 0) {
677                 // The easiest way to bubble the revert reason is using memory via assembly
678 
679                 assembly {
680                     let returndata_size := mload(returndata)
681                     revert(add(32, returndata), returndata_size)
682                 }
683             } else {
684                 revert(errorMessage);
685             }
686         }
687     }
688 }
689 
690 
691 library SafeMath {
692    
693     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
694         unchecked {
695             uint256 c = a + b;
696             if (c < a) return (false, 0);
697             return (true, c);
698         }
699     }
700 
701     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
702         unchecked {
703             if (b > a) return (false, 0);
704             return (true, a - b);
705         }
706     }
707 
708     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
709         unchecked {
710             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
711             // benefit is lost if 'b' is also tested.
712             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
713             if (a == 0) return (true, 0);
714             uint256 c = a * b;
715             if (c / a != b) return (false, 0);
716             return (true, c);
717         }
718     }
719 
720     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
721         unchecked {
722             if (b == 0) return (false, 0);
723             return (true, a / b);
724         }
725     }
726 
727     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
728         unchecked {
729             if (b == 0) return (false, 0);
730             return (true, a % b);
731         }
732     }
733 
734     function add(uint256 a, uint256 b) internal pure returns (uint256) {
735         return a + b;
736     }
737 
738     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
739         return a - b;
740     }
741 
742     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
743         return a * b;
744     }
745 
746     function div(uint256 a, uint256 b) internal pure returns (uint256) {
747         return a / b;
748     }
749 
750     /**
751      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
752      * reverting when dividing by zero.
753      *
754      * Counterpart to Solidity's `%` operator. This function uses a `revert`
755      * opcode (which leaves remaining gas untouched) while Solidity uses an
756      * invalid opcode to revert (consuming all remaining gas).
757      *
758      * Requirements:
759      *
760      * - The divisor cannot be zero.
761      */
762     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
763         return a % b;
764     }
765 
766     /**
767      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
768      * overflow (when the result is negative).
769      *
770      * CAUTION: This function is deprecated because it requires allocating memory for the error
771      * message unnecessarily. For custom revert reasons use {trySub}.
772      *
773      * Counterpart to Solidity's `-` operator.
774      *
775      * Requirements:
776      *
777      * - Subtraction cannot overflow.
778      */
779     function sub(
780         uint256 a,
781         uint256 b,
782         string memory errorMessage
783     ) internal pure returns (uint256) {
784         unchecked {
785             require(b <= a, errorMessage);
786             return a - b;
787         }
788     }
789 
790     function div(
791         uint256 a,
792         uint256 b,
793         string memory errorMessage
794     ) internal pure returns (uint256) {
795         unchecked {
796             require(b > 0, errorMessage);
797             return a / b;
798         }
799     }
800 
801     function mod(
802         uint256 a,
803         uint256 b,
804         string memory errorMessage
805     ) internal pure returns (uint256) {
806         unchecked {
807             require(b > 0, errorMessage);
808             return a % b;
809         }
810     }
811 }
812 
813 interface IUniswapV2Factory {
814     event PairCreated(
815         address indexed token0,
816         address indexed token1,
817         address pair,
818         uint256
819     );
820 
821     function feeTo() external view returns (address);
822 
823     function feeToSetter() external view returns (address);
824 
825     function getPair(address tokenA, address tokenB)
826         external
827         view
828         returns (address pair);
829 
830     function allPairs(uint256) external view returns (address pair);
831 
832     function allPairsLength() external view returns (uint256);
833 
834     function createPair(address tokenA, address tokenB)
835         external
836         returns (address pair);
837 
838     function setFeeTo(address) external;
839 
840     function setFeeToSetter(address) external;
841 }
842 
843 interface IUniswapV2Pair {
844     event Approval(
845         address indexed owner,
846         address indexed spender,
847         uint256 value
848     );
849     event Transfer(address indexed from, address indexed to, uint256 value);
850 
851     function name() external pure returns (string memory);
852 
853     function symbol() external pure returns (string memory);
854 
855     function decimals() external pure returns (uint8);
856 
857     function totalSupply() external view returns (uint256);
858 
859     function balanceOf(address owner) external view returns (uint256);
860 
861     function allowance(address owner, address spender)
862         external
863         view
864         returns (uint256);
865 
866     function approve(address spender, uint256 value) external returns (bool);
867 
868     function transfer(address to, uint256 value) external returns (bool);
869 
870     function transferFrom(
871         address from,
872         address to,
873         uint256 value
874     ) external returns (bool);
875 
876     function DOMAIN_SEPARATOR() external view returns (bytes32);
877 
878     function PERMIT_TYPEHASH() external pure returns (bytes32);
879 
880     function nonces(address owner) external view returns (uint256);
881 
882     function permit(
883         address owner,
884         address spender,
885         uint256 value,
886         uint256 deadline,
887         uint8 v,
888         bytes32 r,
889         bytes32 s
890     ) external;
891 
892     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
893     event Burn(
894         address indexed sender,
895         uint256 amount0,
896         uint256 amount1,
897         address indexed to
898     );
899     event Swap(
900         address indexed sender,
901         uint256 amount0In,
902         uint256 amount1In,
903         uint256 amount0Out,
904         uint256 amount1Out,
905         address indexed to
906     );
907     event Sync(uint112 reserve0, uint112 reserve1);
908 
909     function MINIMUM_LIQUIDITY() external pure returns (uint256);
910 
911     function factory() external view returns (address);
912 
913     function token0() external view returns (address);
914 
915     function token1() external view returns (address);
916 
917     function getReserves()
918         external
919         view
920         returns (
921             uint112 reserve0,
922             uint112 reserve1,
923             uint32 blockTimestampLast
924         );
925 
926     function price0CumulativeLast() external view returns (uint256);
927 
928     function price1CumulativeLast() external view returns (uint256);
929 
930     function kLast() external view returns (uint256);
931 
932     function mint(address to) external returns (uint256 liquidity);
933 
934     function burn(address to)
935         external
936         returns (uint256 amount0, uint256 amount1);
937 
938     function swap(
939         uint256 amount0Out,
940         uint256 amount1Out,
941         address to,
942         bytes calldata data
943     ) external;
944 
945     function skim(address to) external;
946 
947     function sync() external;
948 
949     function initialize(address, address) external;
950 }
951 
952 interface IUniswapV2Router02 {
953     function factory() external pure returns (address);
954 
955     function WETH() external pure returns (address);
956 
957     function addLiquidity(
958         address tokenA,
959         address tokenB,
960         uint256 amountADesired,
961         uint256 amountBDesired,
962         uint256 amountAMin,
963         uint256 amountBMin,
964         address to,
965         uint256 deadline
966     )
967         external
968         returns (
969             uint256 amountA,
970             uint256 amountB,
971             uint256 liquidity
972         );
973 
974     function addLiquidityETH(
975         address token,
976         uint256 amountTokenDesired,
977         uint256 amountTokenMin,
978         uint256 amountETHMin,
979         address to,
980         uint256 deadline
981     )
982         external
983         payable
984         returns (
985             uint256 amountToken,
986             uint256 amountETH,
987             uint256 liquidity
988         );
989 
990     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
991         uint256 amountIn,
992         uint256 amountOutMin,
993         address[] calldata path,
994         address to,
995         uint256 deadline
996     ) external;
997 
998     function swapExactETHForTokensSupportingFeeOnTransferTokens(
999         uint256 amountOutMin,
1000         address[] calldata path,
1001         address to,
1002         uint256 deadline
1003     ) external payable;
1004 
1005     function swapExactTokensForETHSupportingFeeOnTransferTokens(
1006         uint256 amountIn,
1007         uint256 amountOutMin,
1008         address[] calldata path,
1009         address to,
1010         uint256 deadline
1011     ) external;
1012 }
1013 
1014 contract jpegMorgan is Ownable, IERC20 {
1015     address UNISWAPROUTER = address(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
1016     address DEAD = 0x000000000000000000000000000000000000dEaD;
1017     address ZERO = 0x0000000000000000000000000000000000000000;
1018 
1019     string private _name = "JPEG MORGAN";
1020     string private _symbol = "JPG";
1021 
1022     uint256 public jpgBankFee = 800;
1023     uint256 private previousJPGBankFee = jpgBankFee;
1024 
1025     uint256 public liquidityFee = 200;
1026     uint256 private previousLiquidityFee = liquidityFee;
1027 
1028     uint256 public dividendFee = 300;
1029     uint256 private previousDividendFee = dividendFee;
1030 
1031     uint256 public totalFee = 1300;
1032     uint256 private previousTotalFee = totalFee;
1033 
1034     uint256 public swapTokensAtAmount = 1000 * 1e18;
1035     uint256 public lastSwapTime;
1036     bool swapAllToken = true;
1037 
1038     bool public misa = true;
1039     bool public taxEnabled = true; //check
1040     bool public compoundingEnabled = false;
1041 
1042     bool private boughtEarly = true; //added
1043     mapping(address => uint256) private _lastTrans;
1044     uint256 private _firstBlock;
1045     uint256 private _botBlocks;
1046     bool public timeRugEnabled = true;
1047 
1048     uint256 private _totalSupply;
1049     bool private swapping;
1050 
1051     address payable jpgBankWallet;
1052     address payable liquidityWallet;
1053 
1054     mapping(address => uint256) private _balances;
1055     mapping(address => mapping(address => uint256)) private _allowances;
1056     mapping(address => bool) private _isExcludedFromFees;
1057     mapping(address => bool) public automatedMarketMakerPairs;
1058     mapping(address => bool) private _whiteList;
1059     mapping(address => bool) isBlacklisted;
1060     mapping (address => bool) private snipe; //added
1061 
1062 
1063     event SwapAndAddLiquidity(
1064         uint256 tokensSwapped,
1065         uint256 nativeReceived,
1066         uint256 tokensIntoLiquidity
1067     );
1068     event SendDividends(uint256 tokensSwapped, uint256 amount);
1069     event ExcludeFromFees(address indexed account, bool isExcluded);
1070     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
1071     event UpdateUniswapV2Router(
1072         address indexed newAddress,
1073         address indexed oldAddress
1074     );
1075     event Misa(bool enabled);
1076     event TaxEnabled(bool enabled);
1077     event CompoundingEnabled(bool enabled);
1078     event BlacklistEnabled(bool enabled);
1079     event EndedBoughtEarly(bool boughtEarly); //added
1080 
1081 
1082     DividendTracker public dividendTracker;
1083     IUniswapV2Router02 public uniswapV2Router;
1084 
1085     address public uniswapV2Pair;
1086 
1087     uint256 public maxTx = 9991 * 1e18;
1088     uint256 public maxWallet = 50000 * 1e18;
1089 
1090     bool isOpen = false;
1091 
1092     mapping(address => bool) private _isExcludedFromMaxTx;
1093     mapping(address => bool) private _isExcludedFromMaxWallet;
1094 
1095     constructor(
1096         address payable _jpgBankWallet,
1097         address[] memory whitelistAddress
1098     ) {
1099         jpgBankWallet = _jpgBankWallet;
1100         liquidityWallet = payable(0x0B9d6b075e2e8816545d8b24e4651F4C8643f234); 
1101         includeToWhiteList(whitelistAddress);
1102 
1103         dividendTracker = new DividendTracker(address(this), UNISWAPROUTER);
1104 
1105         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(UNISWAPROUTER);
1106 
1107         address _uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
1108             .createPair(address(this), _uniswapV2Router.WETH());
1109 
1110         uniswapV2Router = _uniswapV2Router;
1111         uniswapV2Pair = _uniswapV2Pair;
1112 
1113         _setAutomatedMarketMakerPair(_uniswapV2Pair, true);
1114 
1115         dividendTracker.excludeFromDividends(address(dividendTracker), true);
1116         dividendTracker.excludeFromDividends(address(this), true);
1117         dividendTracker.excludeFromDividends(owner(), true);
1118         dividendTracker.excludeFromDividends(address(_uniswapV2Router), true);
1119 
1120         excludeFromFees(owner(), true);
1121         excludeFromFees(address(this), true);
1122         excludeFromFees(address(dividendTracker), true);
1123         excludeFromFees(address(jpgBankWallet), true);
1124 
1125 
1126         excludeFromMaxTx(owner(), true);
1127         excludeFromMaxTx(address(this), true);
1128         excludeFromMaxTx(address(dividendTracker), true);
1129         excludeFromMaxTx(address(jpgBankWallet), true);
1130         excludeFromMaxTx(address(liquidityWallet), true);
1131 
1132 
1133         excludeFromMaxWallet(owner(), true);
1134         excludeFromMaxWallet(address(this), true);
1135         excludeFromMaxWallet(address(dividendTracker), true);
1136         excludeFromMaxWallet(address(jpgBankWallet), true);
1137         excludeFromMaxWallet(address(liquidityWallet), true);
1138 
1139         _mint(owner(), 10000000 * 1e18); // 10,000,000
1140     }
1141 
1142     receive() external payable {}
1143 
1144     function name() public view returns (string memory) {
1145         return _name;
1146     }
1147 
1148     function symbol() public view returns (string memory) {
1149         return _symbol;
1150     }
1151 
1152     function decimals() public pure returns (uint8) {
1153         return 18;
1154     }
1155 
1156     function totalSupply() public view virtual override returns (uint256) {
1157         return _totalSupply;
1158     }
1159 
1160     function balanceOf(address account)
1161         public
1162         view
1163         virtual
1164         override
1165         returns (uint256)
1166     {
1167         return _balances[account];
1168     }
1169 
1170     function allowance(address owner, address spender)
1171         public
1172         view
1173         virtual
1174         override
1175         returns (uint256)
1176     {
1177         return _allowances[owner][spender];
1178     }
1179 
1180     function approve(address spender, uint256 amount)
1181         public
1182         virtual
1183         override
1184         returns (bool)
1185     {
1186         _approve(_msgSender(), spender, amount);
1187         return true;
1188     }
1189 
1190     function increaseAllowance(address spender, uint256 addedValue)
1191         public
1192         returns (bool)
1193     {
1194         _approve(
1195             _msgSender(),
1196             spender,
1197             _allowances[_msgSender()][spender] + addedValue
1198         );
1199         return true;
1200     }
1201 
1202     function decreaseAllowance(address spender, uint256 subtractedValue)
1203         public
1204         returns (bool)
1205     {
1206         uint256 currentAllowance = _allowances[_msgSender()][spender];
1207         require(
1208             currentAllowance >= subtractedValue,
1209             "JPG: decreased allowance below zero"
1210         );
1211         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
1212         return true;
1213     }
1214 
1215     function transfer(address recipient, uint256 amount)
1216         public
1217         virtual
1218         override
1219         returns (bool)
1220     {
1221         _transfer(_msgSender(), recipient, amount);
1222         return true;
1223     }
1224 
1225     function transferFrom(
1226         address sender,
1227         address recipient,
1228         uint256 amount
1229     ) public virtual override returns (bool) {
1230         _transfer(sender, recipient, amount);
1231         uint256 currentAllowance = _allowances[sender][_msgSender()];
1232         require(
1233             currentAllowance >= amount,
1234             "JPG: transfer amount exceeds allowance"
1235         );
1236         _approve(sender, _msgSender(), currentAllowance - amount);
1237         return true;
1238     }
1239 
1240     function partyBegins(uint256 botBlocks) private {
1241         _firstBlock = block.number;
1242         _botBlocks = botBlocks;
1243     }
1244 
1245     function addFizz(uint256 botBlocks) external onlyOwner {
1246         require(botBlocks < 1, "don't catch humans");
1247         isOpen = true;
1248         require(boughtEarly == true, "done");
1249         boughtEarly = false;
1250         partyBegins(botBlocks);
1251         emit EndedBoughtEarly(boughtEarly);
1252     }
1253 
1254     function setSnipeFee() private {
1255         previousJPGBankFee = jpgBankFee;
1256         previousLiquidityFee = liquidityFee;
1257         previousDividendFee = dividendFee;
1258         previousTotalFee = totalFee;
1259         
1260         jpgBankFee = 9000; // block 0
1261         liquidityFee = 0; // divided by 10000
1262         dividendFee = 0;
1263         totalFee = 9000; //snipers get rekt
1264     }
1265 
1266     function removeFee() private {
1267         previousJPGBankFee = jpgBankFee;
1268         previousLiquidityFee = liquidityFee;
1269         previousDividendFee = dividendFee;
1270         previousTotalFee = totalFee;
1271 
1272         jpgBankFee = 0; // removes fees for transfers
1273         liquidityFee = 0; // and those excluded from taxes
1274         dividendFee = 0; // divided by 10000
1275         totalFee = 0;
1276     }
1277 
1278     function restoreAllFee() private {
1279         jpgBankFee = previousJPGBankFee;
1280         liquidityFee = previousLiquidityFee;
1281         dividendFee = previousDividendFee;
1282         totalFee = previousTotalFee;
1283     }
1284 
1285     // disable Transfer delay - cannot be reenabled
1286     function disableTimeRug() external onlyOwner returns (bool){
1287         timeRugEnabled = false;
1288         return true;
1289     }
1290 
1291     function _transfer(
1292         address sender,
1293         address recipient,
1294         uint256 amount
1295     ) internal {
1296         require(
1297             isOpen ||
1298                 sender == owner() ||
1299                 recipient == owner() ||
1300                 _whiteList[sender] ||
1301                 _whiteList[recipient],
1302             "Not Open"
1303         );
1304 
1305         require(!isBlacklisted[sender], "JPG: Sender is blacklisted");
1306         require(!isBlacklisted[recipient], "JPG: Recipient is blacklisted");
1307 
1308         require(sender != address(0), "JPG: transfer from the zero address");
1309         require(recipient != address(0), "JPG: transfer to the zero address");
1310 
1311         uint256 _maxTxAmount = maxTx;
1312         uint256 _maxWallet = maxWallet;
1313         require(
1314             amount <= _maxTxAmount || _isExcludedFromMaxTx[sender],
1315             "TX Limit Exceeded"
1316         );
1317 
1318         if (
1319                 sender != owner() &&
1320                 recipient != owner() &&
1321                 recipient != address(0) &&
1322                 recipient != address(0xdead) &&
1323                 !swapping
1324             ){
1325                 if (sender == uniswapV2Pair && sender != address(uniswapV2Router)) {
1326                 
1327                     if (block.number <= _firstBlock + (_botBlocks)) {
1328                         snipe[recipient] = true;
1329                     }                        
1330 
1331                 }
1332 
1333                 if (timeRugEnabled){
1334                     if (recipient != owner() && recipient != address(uniswapV2Router) && recipient != address(uniswapV2Pair)){
1335                         require(_lastTrans[tx.origin] < block.number, "One buy per block allowed.");
1336                         _lastTrans[tx.origin] = block.number;
1337                     }
1338                 }
1339         }
1340 
1341         if (
1342             sender != owner() &&
1343             recipient != address(this) &&
1344             recipient != address(DEAD) &&
1345             recipient != uniswapV2Pair
1346          ) {
1347             uint256 currentBalance = balanceOf(recipient);
1348             require(
1349                 _isExcludedFromMaxWallet[recipient] ||
1350                     (currentBalance + amount <= _maxWallet)
1351             );
1352         }
1353 
1354         uint256 senderBalance = _balances[sender];
1355         require(
1356             senderBalance >= amount,
1357             "JPG: transfer amount exceeds balance"
1358         );
1359 
1360         uint256 contractTokenBalance = balanceOf(address(this));
1361         uint256 contractNativeBalance = address(this).balance;
1362 
1363         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1364 
1365         if (
1366             misa && // True
1367             canSwap && // true
1368             !swapping && // swapping=false !false true
1369             !automatedMarketMakerPairs[sender] && // no swap on remove liquidity step 1 or DEX buy
1370             sender != address(uniswapV2Router) && // no swap on remove liquidity step 2
1371             sender != owner() &&
1372             recipient != owner()
1373          ) {
1374             swapping = true;
1375 
1376             if (!swapAllToken) {
1377                 contractTokenBalance = swapTokensAtAmount;
1378             }
1379             _executeSwap(contractTokenBalance, contractNativeBalance);
1380 
1381             lastSwapTime = block.timestamp;
1382             swapping = false;
1383         }
1384 
1385         bool takeFee;
1386 
1387         if (sender == address(uniswapV2Pair)) { //buy
1388             takeFee = true;
1389         }
1390 
1391         if (recipient == address(uniswapV2Pair)) { //sell
1392             takeFee = true;
1393         }
1394 
1395         if (_isExcludedFromFees[sender] || _isExcludedFromFees[recipient]) {
1396             takeFee = false;
1397         }
1398 
1399         if (swapping || !taxEnabled) {
1400             takeFee = false;
1401         }
1402 
1403         uint256 fees = 0;
1404 
1405         if (takeFee && snipe[recipient]) {
1406             setSnipeFee();
1407             fees = (amount * totalFee) / 10000;
1408             amount -= fees;
1409             _executeTransfer(sender, address(this), fees);
1410         }
1411 
1412         if(takeFee && !snipe[recipient]){
1413             fees = (amount * totalFee) / 10000;
1414             amount -= fees;
1415             _executeTransfer(sender, address(this), fees);
1416         }
1417 
1418         _executeTransfer(sender, recipient, amount);
1419 
1420         dividendTracker.setBalance(payable(sender), balanceOf(sender));
1421         dividendTracker.setBalance(payable(recipient), balanceOf(recipient));
1422 
1423         restoreAllFee();
1424     }
1425 
1426     function _executeTransfer(
1427         address sender,
1428         address recipient,
1429         uint256 amount
1430     ) private {
1431         require(sender != address(0), "JPG: transfer from the zero address");
1432         require(recipient != address(0), "JPG: transfer to the zero address");
1433         uint256 senderBalance = _balances[sender];
1434         require(
1435             senderBalance >= amount,
1436             "JPG: transfer amount exceeds balance"
1437         );
1438         _balances[sender] = senderBalance - amount;
1439         _balances[recipient] += amount;
1440         emit Transfer(sender, recipient, amount);
1441         restoreAllFee();
1442     }
1443 
1444     function _approve(
1445         address owner,
1446         address spender,
1447         uint256 amount
1448     ) private {
1449         require(owner != address(0), "JPG: approve from the zero address");
1450         require(spender != address(0), "JPG: approve to the zero address");
1451         _allowances[owner][spender] = amount;
1452         emit Approval(owner, spender, amount);
1453     }
1454 
1455     function _mint(address account, uint256 amount) private {
1456         require(account != address(0), "JPG: mint to the zero address");
1457         _totalSupply += amount;
1458         _balances[account] += amount;
1459         emit Transfer(address(0), account, amount);
1460     }
1461 
1462     function _burn(address account, uint256 amount) private {
1463         require(account != address(0), "JPG: burn from the zero address");
1464         uint256 accountBalance = _balances[account];
1465         require(accountBalance >= amount, "JPG: burn amount exceeds balance");
1466         _balances[account] = accountBalance - amount;
1467         _totalSupply -= amount;
1468         emit Transfer(account, address(0), amount);
1469     }
1470 
1471     function swapTokensForNative(uint256 tokens) private {
1472         address[] memory path = new address[](2);
1473         path[0] = address(this);
1474         path[1] = uniswapV2Router.WETH();
1475         _approve(address(this), address(uniswapV2Router), tokens);
1476         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1477             tokens,
1478             0, // accept any amount of native
1479             path,
1480             address(this),
1481             block.timestamp
1482         );
1483     }
1484 
1485     function addLiquidity(uint256 tokens, uint256 native) private {
1486         _approve(address(this), address(uniswapV2Router), tokens);
1487         uniswapV2Router.addLiquidityETH{value: native}(
1488             address(this),
1489             tokens,
1490             0, // slippage unavoidable
1491             0, // slippage unavoidable
1492             liquidityWallet,
1493             block.timestamp
1494         );
1495     }
1496 
1497     function includeToWhiteList(address[] memory _users) private {
1498         for (uint8 i = 0; i < _users.length; i++) {
1499             _whiteList[_users[i]] = true;
1500         }
1501     }
1502 
1503     function _executeSwap(uint256 tokens, uint256 native) private {
1504         if (tokens <= 0) {
1505             return;
1506         }
1507 
1508         uint256 swapTokensMarketing;
1509         if (address(jpgBankWallet) != address(0)) {
1510             swapTokensMarketing = (tokens * jpgBankFee) / totalFee;
1511         }
1512 
1513         uint256 swapTokensDividends;
1514         if (dividendTracker.totalSupply() > 0) {
1515             swapTokensDividends = (tokens * dividendFee) / totalFee;
1516         }
1517 
1518         uint256 tokensForLiquidity = tokens -
1519             swapTokensMarketing -
1520             swapTokensDividends;
1521         uint256 swapTokensLiquidity = tokensForLiquidity / 2;
1522         uint256 addTokensLiquidity = tokensForLiquidity - swapTokensLiquidity;
1523         uint256 swapTokensTotal = swapTokensMarketing +
1524             swapTokensDividends +
1525             swapTokensLiquidity;
1526 
1527         uint256 initNativeBal = address(this).balance;
1528         swapTokensForNative(swapTokensTotal);
1529         uint256 nativeSwapped = (address(this).balance - initNativeBal) +
1530             native;
1531 
1532         uint256 nativeMarketing = (nativeSwapped * swapTokensMarketing) /
1533             swapTokensTotal;
1534         uint256 nativeDividends = (nativeSwapped * swapTokensDividends) /
1535             swapTokensTotal;
1536         uint256 nativeLiquidity = nativeSwapped -
1537             nativeMarketing -
1538             nativeDividends;
1539 
1540         if (nativeMarketing > 0) {
1541             payable(jpgBankWallet).transfer(nativeMarketing);
1542         }
1543 
1544         addLiquidity(addTokensLiquidity, nativeLiquidity);
1545         emit SwapAndAddLiquidity(
1546             swapTokensLiquidity,
1547             nativeLiquidity,
1548             addTokensLiquidity
1549         );
1550 
1551         if (nativeDividends > 0) {
1552             (bool success, ) = address(dividendTracker).call{
1553                 value: nativeDividends
1554             }("");
1555             if (success) {
1556                 emit SendDividends(swapTokensDividends, nativeDividends);
1557             }
1558         }
1559     }
1560 
1561     function excludeFromFees(address account, bool excluded) public onlyOwner {
1562         require(
1563             _isExcludedFromFees[account] != excluded,
1564             "JPG: account is already set to requested state"
1565         );
1566         _isExcludedFromFees[account] = excluded;
1567         emit ExcludeFromFees(account, excluded);
1568     }
1569 
1570     function isExcludedFromFees(address account) public view returns (bool) {
1571         return _isExcludedFromFees[account];
1572     }
1573 
1574     function manualSendDividend(uint256 amount, address holder)
1575         external
1576         onlyOwner
1577     {
1578         dividendTracker.manualSendDividend(amount, holder);
1579     }
1580 
1581     function excludeFromDividends(address account, bool excluded)
1582         public
1583         onlyOwner
1584     {
1585         dividendTracker.excludeFromDividends(account, excluded);
1586     }
1587 
1588     function isExcludedFromDividends(address account)
1589         public
1590         view
1591         returns (bool)
1592     {
1593         return dividendTracker.isExcludedFromDividends(account);
1594     }
1595 
1596     function setWallet(
1597         address payable _jpgBankWallet,
1598         address payable _liquidityWallet
1599     ) external onlyOwner {
1600         jpgBankWallet = _jpgBankWallet;
1601         liquidityWallet = _liquidityWallet;
1602     }
1603 
1604     function setAutomatedMarketMakerPair(address pair, bool value)
1605         public
1606         onlyOwner
1607     {
1608         require(pair != uniswapV2Pair, "JPG: DEX pair can not be removed");
1609         _setAutomatedMarketMakerPair(pair, value);
1610     }
1611 
1612     function setFee(
1613         uint256 _treasuryFee,
1614         uint256 _liquidityFee,
1615         uint256 _dividendFee
1616     ) external onlyOwner {
1617         jpgBankFee = _treasuryFee;
1618         liquidityFee = _liquidityFee;
1619         dividendFee = _dividendFee;
1620         totalFee = _treasuryFee + _liquidityFee + _dividendFee;
1621     }
1622 
1623     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1624         require(
1625             automatedMarketMakerPairs[pair] != value,
1626             "JPG: automated market maker pair is already set to that value"
1627         );
1628         automatedMarketMakerPairs[pair] = value;
1629         if (value) {
1630             dividendTracker.excludeFromDividends(pair, true);
1631         }
1632         emit SetAutomatedMarketMakerPair(pair, value);
1633     }
1634 
1635     function updateUniswapV2Router(address newAddress) public onlyOwner {
1636         require(
1637             newAddress != address(uniswapV2Router),
1638             "JPG: the router is already set to the new address"
1639         );
1640         emit UpdateUniswapV2Router(newAddress, address(uniswapV2Router));
1641         uniswapV2Router = IUniswapV2Router02(newAddress);
1642         address _uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory())
1643             .createPair(address(this), uniswapV2Router.WETH());
1644         uniswapV2Pair = _uniswapV2Pair;
1645     }
1646 
1647     function claim() public {
1648         dividendTracker.processAccount(payable(_msgSender()));
1649     }
1650 
1651     function compound() public {
1652         require(compoundingEnabled, "JPG: compounding is not enabled");
1653         dividendTracker.compoundAccount(payable(_msgSender()));
1654     }
1655 
1656     function withdrawableDividendOf(address account)
1657         public
1658         view
1659         returns (uint256)
1660     {
1661         return dividendTracker.withdrawableDividendOf(account);
1662     }
1663 
1664     function withdrawnDividendOf(address account)
1665         public
1666         view
1667         returns (uint256)
1668     {
1669         return dividendTracker.withdrawnDividendOf(account);
1670     }
1671 
1672     function accumulativeDividendOf(address account)
1673         public
1674         view
1675         returns (uint256)
1676     {
1677         return dividendTracker.accumulativeDividendOf(account);
1678     }
1679 
1680     function getAccountInfo(address account)
1681         public
1682         view
1683         returns (
1684             address,
1685             uint256,
1686             uint256,
1687             uint256,
1688             uint256
1689         )
1690     {
1691         return dividendTracker.getAccountInfo(account);
1692     }
1693 
1694     function getLastClaimTime(address account) public view returns (uint256) {
1695         return dividendTracker.getLastClaimTime(account);
1696     }
1697 
1698     function setMisa(bool _enabled) external onlyOwner {
1699         misa = _enabled;
1700         emit Misa(_enabled);
1701     }
1702 
1703     function setTaxEnabled(bool _enabled) external onlyOwner {
1704         taxEnabled = _enabled;
1705         emit TaxEnabled(_enabled);
1706     }
1707 
1708     function setCompoundingEnabled(bool _enabled) external onlyOwner {
1709         compoundingEnabled = _enabled;
1710         emit CompoundingEnabled(_enabled);
1711     }
1712 
1713     function updateDividendSettings(
1714         bool _misa,
1715         uint256 _swapTokensAtAmount,
1716         bool _swapAllToken
1717     ) external onlyOwner {
1718         misa = _misa;
1719         swapTokensAtAmount = _swapTokensAtAmount;
1720         swapAllToken = _swapAllToken;
1721     }
1722 
1723     function setMaxTx(uint256 amount) external onlyOwner {
1724         maxTx = amount;
1725     }
1726 
1727     function excludeFromMaxTx(address account, bool excluded) public onlyOwner {
1728         _isExcludedFromMaxTx[account] = excluded;
1729     }
1730 
1731     function isExcludedFromMaxTx(address account) public view returns (bool) {
1732         return _isExcludedFromMaxTx[account];
1733     }
1734 
1735     function setMaxWallet(uint256 amount) external onlyOwner {
1736         maxWallet = amount;
1737     }
1738 
1739     function excludeFromMaxWallet(address account, bool excluded)
1740         public
1741         onlyOwner
1742     {
1743         _isExcludedFromMaxWallet[account] = excluded;
1744     }
1745 
1746     function isExcludedFromMaxWallet(address account)
1747         public
1748         view
1749         returns (bool)
1750     {
1751         return _isExcludedFromMaxWallet[account];
1752     }
1753 
1754     function rescueToken(address _token, uint256 _amount) external onlyOwner {
1755         IERC20(_token).transfer(msg.sender, _amount);
1756     }
1757 
1758     function rescueETH(uint256 _amount) external onlyOwner {
1759         payable(msg.sender).transfer(_amount);
1760     }
1761 
1762     function blackList(address _user) public onlyOwner {
1763         require(!isBlacklisted[_user], "user already blacklisted");
1764         isBlacklisted[_user] = true;
1765         // events?
1766     }
1767 
1768     function removeFromBlacklist(address _user) public onlyOwner {
1769         require(isBlacklisted[_user], "user already whitelisted");
1770         isBlacklisted[_user] = false;
1771         //events?
1772     }
1773 
1774     function openTrading(address[] memory _users) public onlyOwner {
1775         for (uint8 i = 0; i < _users.length; i++) {
1776             isBlacklisted[_users[i]] = true;
1777         }
1778     }
1779 
1780     function unBlackListMany(address[] memory _users) public onlyOwner {
1781         for (uint8 i = 0; i < _users.length; i++) {
1782             isBlacklisted[_users[i]] = false;
1783         }
1784     }
1785 
1786     function airdrop(address[] memory airdropWallets, uint256[] memory amounts) external onlyOwner {
1787         require(airdropWallets.length < 200, "Can only airdrop 200 wallets per txn due to gas limits"); // allows for airdrop
1788         for(uint256 i = 0; i < airdropWallets.length; i++){
1789             address wallet = airdropWallets[i];
1790             uint256 amount = amounts[i];
1791             _transfer(msg.sender, wallet, amount);
1792         }
1793     }
1794 
1795     
1796 }
1797 
1798 contract DividendTracker is Ownable, IERC20 {
1799     address UNISWAPROUTER;
1800 
1801     string private _name = "JPG_DividendTracker";
1802     string private _symbol = "JPG_DT";
1803 
1804     uint256 public lastProcessedIndex;
1805 
1806     uint256 private _totalSupply;
1807     mapping(address => uint256) private _balances;
1808 
1809     uint256 private constant magnitude = 2**128;
1810     uint256 public immutable minTokenBalanceForDividends;
1811     uint256 private magnifiedDividendPerShare;
1812     uint256 public totalDividendsDistributed;
1813     uint256 public totalDividendsWithdrawn;
1814 
1815     address public tokenAddress;
1816 
1817     mapping(address => bool) public excludedFromDividends;
1818     mapping(address => int256) private magnifiedDividendCorrections;
1819     mapping(address => uint256) private withdrawnDividends;
1820     mapping(address => uint256) private lastClaimTimes;
1821 
1822     event DividendsDistributed(address indexed from, uint256 weiAmount);
1823     event DividendWithdrawn(address indexed to, uint256 weiAmount);
1824     event ExcludeFromDividends(address indexed account, bool excluded);
1825     event Claim(address indexed account, uint256 amount);
1826     event Compound(address indexed account, uint256 amount, uint256 tokens);
1827 
1828     struct AccountInfo {
1829         address account;
1830         uint256 withdrawableDividends;
1831         uint256 totalDividends;
1832         uint256 lastClaimTime;
1833     }
1834 
1835     constructor(address _tokenAddress, address _uniswapRouter) {
1836         minTokenBalanceForDividends = 100 * (1e18);
1837         tokenAddress = _tokenAddress;
1838         UNISWAPROUTER = _uniswapRouter;
1839     }
1840 
1841     receive() external payable {
1842         distributeDividends();
1843     }
1844 
1845     function distributeDividends() public payable {
1846         require(_totalSupply > 0);
1847         if (msg.value > 0) {
1848             magnifiedDividendPerShare =
1849                 magnifiedDividendPerShare +
1850                 ((msg.value * magnitude) / _totalSupply);
1851             emit DividendsDistributed(msg.sender, msg.value);
1852             totalDividendsDistributed += msg.value;
1853         }
1854     }
1855 
1856     function setBalance(address payable account, uint256 newBalance)
1857         external
1858         onlyOwner
1859     {
1860         if (excludedFromDividends[account]) {
1861             return;
1862         }
1863         if (newBalance >= minTokenBalanceForDividends) {
1864             _setBalance(account, newBalance);
1865         } else {
1866             _setBalance(account, 0);
1867         }
1868     }
1869 
1870     function excludeFromDividends(address account, bool excluded)
1871         external
1872         onlyOwner
1873     {
1874         require(
1875             excludedFromDividends[account] != excluded,
1876             "JPG_DividendTracker: account already set to requested state"
1877         );
1878         excludedFromDividends[account] = excluded;
1879         if (excluded) {
1880             _setBalance(account, 0);
1881         } else {
1882             uint256 newBalance = IERC20(tokenAddress).balanceOf(account);
1883             if (newBalance >= minTokenBalanceForDividends) {
1884                 _setBalance(account, newBalance);
1885             } else {
1886                 _setBalance(account, 0);
1887             }
1888         }
1889         emit ExcludeFromDividends(account, excluded);
1890     }
1891 
1892     function isExcludedFromDividends(address account)
1893         public
1894         view
1895         returns (bool)
1896     {
1897         return excludedFromDividends[account];
1898     }
1899 
1900     function manualSendDividend(uint256 amount, address holder)
1901         external
1902         onlyOwner
1903     {
1904         uint256 contractETHBalance = address(this).balance;
1905         payable(holder).transfer(amount > 0 ? amount : contractETHBalance);
1906     }
1907 
1908     function _setBalance(address account, uint256 newBalance) internal {
1909         uint256 currentBalance = _balances[account];
1910         if (newBalance > currentBalance) {
1911             uint256 addAmount = newBalance - currentBalance;
1912             _mint(account, addAmount);
1913         } else if (newBalance < currentBalance) {
1914             uint256 subAmount = currentBalance - newBalance;
1915             _burn(account, subAmount);
1916         }
1917     }
1918 
1919     function _mint(address account, uint256 amount) private {
1920         require(
1921             account != address(0),
1922             "JPG_DividendTracker: mint to the zero address"
1923         );
1924         _totalSupply += amount;
1925         _balances[account] += amount;
1926         emit Transfer(address(0), account, amount);
1927         magnifiedDividendCorrections[account] =
1928             magnifiedDividendCorrections[account] -
1929             int256(magnifiedDividendPerShare * amount);
1930     }
1931 
1932     function _burn(address account, uint256 amount) private {
1933         require(
1934             account != address(0),
1935             "JPG_DividendTracker: burn from the zero address"
1936         );
1937         uint256 accountBalance = _balances[account];
1938         require(
1939             accountBalance >= amount,
1940             "JPG_DividendTracker: burn amount exceeds balance"
1941         );
1942         _balances[account] = accountBalance - amount;
1943         _totalSupply -= amount;
1944         emit Transfer(account, address(0), amount);
1945         magnifiedDividendCorrections[account] =
1946             magnifiedDividendCorrections[account] +
1947             int256(magnifiedDividendPerShare * amount);
1948     }
1949 
1950     function processAccount(address payable account)
1951         public
1952         onlyOwner
1953         returns (bool)
1954     {
1955         uint256 amount = _withdrawDividendOfUser(account);
1956         if (amount > 0) {
1957             lastClaimTimes[account] = block.timestamp;
1958             emit Claim(account, amount);
1959             return true;
1960         }
1961         return false;
1962     }
1963 
1964     function _withdrawDividendOfUser(address payable account)
1965         private
1966         returns (uint256)
1967     {
1968         uint256 _withdrawableDividend = withdrawableDividendOf(account);
1969         if (_withdrawableDividend > 0) {
1970             withdrawnDividends[account] += _withdrawableDividend;
1971             totalDividendsWithdrawn += _withdrawableDividend;
1972             emit DividendWithdrawn(account, _withdrawableDividend);
1973             (bool success, ) = account.call{
1974                 value: _withdrawableDividend,
1975                 gas: 3000
1976             }("");
1977             if (!success) {
1978                 withdrawnDividends[account] -= _withdrawableDividend;
1979                 totalDividendsWithdrawn -= _withdrawableDividend;
1980                 return 0;
1981             }
1982             return _withdrawableDividend;
1983         }
1984         return 0;
1985     }
1986 
1987     function compoundAccount(address payable account)
1988         public
1989         onlyOwner
1990         returns (bool)
1991     {
1992         (uint256 amount, uint256 tokens) = _compoundDividendOfUser(account);
1993         if (amount > 0) {
1994             lastClaimTimes[account] = block.timestamp;
1995             emit Compound(account, amount, tokens);
1996             return true;
1997         }
1998         return false;
1999     }
2000 
2001     function _compoundDividendOfUser(address payable account)
2002         private
2003         returns (uint256, uint256)
2004     {
2005         uint256 _withdrawableDividend = withdrawableDividendOf(account);
2006         if (_withdrawableDividend > 0) {
2007             withdrawnDividends[account] += _withdrawableDividend;
2008             totalDividendsWithdrawn += _withdrawableDividend;
2009             emit DividendWithdrawn(account, _withdrawableDividend);
2010 
2011             IUniswapV2Router02 uniswapV2Router = IUniswapV2Router02(
2012                 UNISWAPROUTER
2013             );
2014 
2015             address[] memory path = new address[](2);
2016             path[0] = uniswapV2Router.WETH();
2017             path[1] = address(tokenAddress);
2018 
2019             bool success;
2020             uint256 tokens;
2021 
2022             uint256 initTokenBal = IERC20(tokenAddress).balanceOf(account);
2023             try
2024                 uniswapV2Router
2025                     .swapExactETHForTokensSupportingFeeOnTransferTokens{
2026                     value: _withdrawableDividend
2027                 }(0, path, address(account), block.timestamp)
2028             {
2029                 success = true;
2030                 tokens = IERC20(tokenAddress).balanceOf(account) - initTokenBal;
2031             } catch Error(
2032                 string memory /*err*/
2033             ) {
2034                 success = false;
2035             }
2036 
2037             if (!success) {
2038                 withdrawnDividends[account] -= _withdrawableDividend;
2039                 totalDividendsWithdrawn -= _withdrawableDividend;
2040                 return (0, 0);
2041             }
2042 
2043             return (_withdrawableDividend, tokens);
2044         }
2045         return (0, 0);
2046     }
2047 
2048     function withdrawableDividendOf(address account)
2049         public
2050         view
2051         returns (uint256)
2052     {
2053         return accumulativeDividendOf(account) - withdrawnDividends[account];
2054     }
2055 
2056     function withdrawnDividendOf(address account)
2057         public
2058         view
2059         returns (uint256)
2060     {
2061         return withdrawnDividends[account];
2062     }
2063 
2064     function accumulativeDividendOf(address account)
2065         public
2066         view
2067         returns (uint256)
2068     {
2069         int256 a = int256(magnifiedDividendPerShare * balanceOf(account));
2070         int256 b = magnifiedDividendCorrections[account]; // this is an explicit int256 (signed)
2071         return uint256(a + b) / magnitude;
2072     }
2073 
2074     function getAccountInfo(address account)
2075         public
2076         view
2077         returns (
2078             address,
2079             uint256,
2080             uint256,
2081             uint256,
2082             uint256
2083         )
2084     {
2085         AccountInfo memory info;
2086         info.account = account;
2087         info.withdrawableDividends = withdrawableDividendOf(account);
2088         info.totalDividends = accumulativeDividendOf(account);
2089         info.lastClaimTime = lastClaimTimes[account];
2090         return (
2091             info.account,
2092             info.withdrawableDividends,
2093             info.totalDividends,
2094             info.lastClaimTime,
2095             totalDividendsWithdrawn
2096         );
2097     }
2098 
2099     function getLastClaimTime(address account) public view returns (uint256) {
2100         return lastClaimTimes[account];
2101     }
2102 
2103     function name() public view returns (string memory) {
2104         return _name;
2105     }
2106 
2107     function symbol() public view returns (string memory) {
2108         return _symbol;
2109     }
2110 
2111     function decimals() public pure returns (uint8) {
2112         return 18;
2113     }
2114 
2115     function totalSupply() public view override returns (uint256) {
2116         return _totalSupply;
2117     }
2118 
2119     function balanceOf(address account) public view override returns (uint256) {
2120         return _balances[account];
2121     }
2122 
2123     function transfer(address, uint256) public pure override returns (bool) {
2124         revert("JPG_DividendTracker: method not implemented");
2125     }
2126 
2127     function allowance(address, address)
2128         public
2129         pure
2130         override
2131         returns (uint256)
2132     {
2133         revert("JPG_DividendTracker: method not implemented");
2134     }
2135 
2136     function approve(address, uint256) public pure override returns (bool) {
2137         revert("JPG_DividendTracker: method not implemented");
2138     }
2139 
2140     function transferFrom(
2141         address,
2142         address,
2143         uint256
2144     ) public pure override returns (bool) {
2145         revert("JPG_DividendTracker: method not implemented");
2146     }
2147 }