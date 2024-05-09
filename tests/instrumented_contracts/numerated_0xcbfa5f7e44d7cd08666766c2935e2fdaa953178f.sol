1 // SPDX-License-Identifier: MIT
2 pragma solidity =0.8.10 >=0.8.0 <0.9.0;
3 pragma experimental ABIEncoderV2;
4 
5 /*
6 
7     MetaFarmer Finance
8 
9     MetaFarmer Finance is pioneering gaming as a service protocol, which allows every day investors to 
10     invest across a range of gaming protocols that are within one of the fastest growing cryptocurrency subsectors.
11 
12     Website: https://metafarmer.finance
13     Telegram: https://t.me/Metafarmerfinance
14     Twitter: https://twitter.com/MetaFarmer_Fi
15     Discord: https://discord.com/invite/yXyqjezssQ
16     Medium: https://medium.com/@metafarmerfinance
17 
18     CREDIT:
19 
20     Website: https://foodfarmer.finance
21     Telegram: https://t.me/foodfarmerfinance
22     Twitter: https://twitter.com/FoodFarmerFi
23     Discord: https://discord.com/invite/xZtTzQB2
24     Gitbook: https://mindx-3.gitbook.io/FFF/
25 
26     FFF is a collective of established DeFi 3.0 innovators, advisors, developers, yield farmers, and investors who have come together to provide 
27     the community with a quality offering within the Farming-as-a-Service sector via ownership of FFF tokens.
28 
29     Website: https://ecc.capital/
30     Telegram: https://t.me/ecc_capital
31     Twitter: https://twitter.com/EmpireCapital_
32     Discord: https://discord.gg/H6JBaNPzX9
33 
34     Empire Capital enables holders of the ECC token to gain exposure to a range of multi-chain
35     yield farming strategies, aggregating the yield back into one token (ECC).
36     Empire Capital also primarily invests into EmpireDEX & Prism Network ecosystem, providing a
37     simple way for investors to gain exposure to the multitude of ways to earn yield in these
38     complex ecosystems. This includes purchasing and creation of locked LP holders to gain
39     yield from the 0.05% fee on EmpireDEX trades, as well as from PRISM LP pairs for the cross
40     chain swap volume and minting PRISM to get access to the multi-chain yield on all chains
41     PRISM is on.
42 
43 */
44 
45 abstract contract Context {
46     function _msgSender() internal view virtual returns (address) {
47         return msg.sender;
48     }
49 
50     function _msgData() internal view virtual returns (bytes calldata) {
51         return msg.data;
52     }
53 }
54 
55 abstract contract Ownable is Context {
56     address private _owner;
57 
58     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
59 
60     /**
61      * @dev Initializes the contract setting the deployer as the initial owner.
62      */
63     constructor() {
64         _transferOwnership(_msgSender());
65     }
66 
67     /**
68      * @dev Returns the address of the current owner.
69      */
70     function owner() public view virtual returns (address) {
71         return _owner;
72     }
73 
74     /**
75      * @dev Throws if called by any account other than the owner.
76      */
77     modifier onlyOwner() {
78         require(owner() == _msgSender(), "Ownable: caller is not the owner");
79         _;
80     }
81 
82     /**
83      * @dev Leaves the contract without owner. It will not be possible to call
84      * `onlyOwner` functions anymore. Can only be called by the current owner.
85      *
86      * NOTE: Renouncing ownership will leave the contract without an owner,
87      * thereby removing any functionality that is only available to the owner.
88      */
89     function renounceOwnership() public virtual onlyOwner {
90         _transferOwnership(address(0));
91     }
92 
93     /**
94      * @dev Transfers ownership of the contract to a new account (`newOwner`).
95      * Can only be called by the current owner.
96      */
97     function transferOwnership(address newOwner) public virtual onlyOwner {
98         require(newOwner != address(0), "Ownable: new owner is the zero address");
99         _transferOwnership(newOwner);
100     }
101 
102     /**
103      * @dev Transfers ownership of the contract to a new account (`newOwner`).
104      * Internal function without access restriction.
105      */
106     function _transferOwnership(address newOwner) internal virtual {
107         address oldOwner = _owner;
108         _owner = newOwner;
109         emit OwnershipTransferred(oldOwner, newOwner);
110     }
111 }
112 
113 interface IERC20 {
114     /**
115      * @dev Returns the amount of tokens in existence.
116      */
117     function totalSupply() external view returns (uint256);
118 
119     /**
120      * @dev Returns the amount of tokens owned by `account`.
121      */
122     function balanceOf(address account) external view returns (uint256);
123 
124     /**
125      * @dev Moves `amount` tokens from the caller's account to `recipient`.
126      *
127      * Returns a boolean value indicating whether the operation succeeded.
128      *
129      * Emits a {Transfer} event.
130      */
131     function transfer(address recipient, uint256 amount) external returns (bool);
132 
133     /**
134      * @dev Returns the remaining number of tokens that `spender` will be
135      * allowed to spend on behalf of `owner` through {transferFrom}. This is
136      * zero by default.
137      *
138      * This value changes when {approve} or {transferFrom} are called.
139      */
140     function allowance(address owner, address spender) external view returns (uint256);
141 
142     /**
143      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
144      *
145      * Returns a boolean value indicating whether the operation succeeded.
146      *
147      * IMPORTANT: Beware that changing an allowance with this method brings the risk
148      * that someone may use both the old and the new allowance by unfortunate
149      * transaction ordering. One possible solution to mitigate this race
150      * condition is to first reduce the spender's allowance to 0 and set the
151      * desired value afterwards:
152      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
153      *
154      * Emits an {Approval} event.
155      */
156     function approve(address spender, uint256 amount) external returns (bool);
157 
158     /**
159      * @dev Moves `amount` tokens from `sender` to `recipient` using the
160      * allowance mechanism. `amount` is then deducted from the caller's
161      * allowance.
162      *
163      * Returns a boolean value indicating whether the operation succeeded.
164      *
165      * Emits a {Transfer} event.
166      */
167     function transferFrom(
168         address sender,
169         address recipient,
170         uint256 amount
171     ) external returns (bool);
172 
173     /**
174      * @dev Emitted when `value` tokens are moved from one account (`from`) to
175      * another (`to`).
176      *
177      * Note that `value` may be zero.
178      */
179     event Transfer(address indexed from, address indexed to, uint256 value);
180 
181     /**
182      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
183      * a call to {approve}. `value` is the new allowance.
184      */
185     event Approval(address indexed owner, address indexed spender, uint256 value);
186 }
187 
188 interface IERC20Metadata is IERC20 {
189     /**
190      * @dev Returns the name of the token.
191      */
192     function name() external view returns (string memory);
193 
194     /**
195      * @dev Returns the symbol of the token.
196      */
197     function symbol() external view returns (string memory);
198 
199     /**
200      * @dev Returns the decimals places of the token.
201      */
202     function decimals() external view returns (uint8);
203 }
204 
205 contract ERC20 is Context, IERC20, IERC20Metadata {
206     mapping(address => uint256) private _balances;
207 
208     mapping(address => mapping(address => uint256)) private _allowances;
209 
210     uint256 private _totalSupply;
211 
212     string private _name;
213     string private _symbol;
214 
215     /**
216      * @dev Sets the values for {name} and {symbol}.
217      *
218      * The default value of {decimals} is 18. To select a different value for
219      * {decimals} you should overload it.
220      *
221      * All two of these values are immutable: they can only be set once during
222      * construction.
223      */
224     constructor(string memory name_, string memory symbol_) {
225         _name = name_;
226         _symbol = symbol_;
227     }
228 
229     /**
230      * @dev Returns the name of the token.
231      */
232     function name() public view virtual override returns (string memory) {
233         return _name;
234     }
235 
236     /**
237      * @dev Returns the symbol of the token, usually a shorter version of the
238      * name.
239      */
240     function symbol() public view virtual override returns (string memory) {
241         return _symbol;
242     }
243 
244     /**
245      * @dev Returns the number of decimals used to get its user representation.
246      * For example, if `decimals` equals `2`, a balance of `505` tokens should
247      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
248      *
249      * Tokens usually opt for a value of 18, imitating the relationship between
250      * Ether and Wei. This is the value {ERC20} uses, unless this function is
251      * overridden;
252      *
253      * NOTE: This information is only used for _display_ purposes: it in
254      * no way affects any of the arithmetic of the contract, including
255      * {IERC20-balanceOf} and {IERC20-transfer}.
256      */
257     function decimals() public view virtual override returns (uint8) {
258         return 18;
259     }
260 
261     /**
262      * @dev See {IERC20-totalSupply}.
263      */
264     function totalSupply() public view virtual override returns (uint256) {
265         return _totalSupply;
266     }
267 
268     /**
269      * @dev See {IERC20-balanceOf}.
270      */
271     function balanceOf(address account) public view virtual override returns (uint256) {
272         return _balances[account];
273     }
274 
275     /**
276      * @dev See {IERC20-transfer}.
277      *
278      * Requirements:
279      *
280      * - `recipient` cannot be the zero address.
281      * - the caller must have a balance of at least `amount`.
282      */
283     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
284         _transfer(_msgSender(), recipient, amount);
285         return true;
286     }
287 
288     /**
289      * @dev See {IERC20-allowance}.
290      */
291     function allowance(address owner, address spender) public view virtual override returns (uint256) {
292         return _allowances[owner][spender];
293     }
294 
295     /**
296      * @dev See {IERC20-approve}.
297      *
298      * Requirements:
299      *
300      * - `spender` cannot be the zero address.
301      */
302     function approve(address spender, uint256 amount) public virtual override returns (bool) {
303         _approve(_msgSender(), spender, amount);
304         return true;
305     }
306 
307     /**
308      * @dev See {IERC20-transferFrom}.
309      *
310      * Emits an {Approval} event indicating the updated allowance. This is not
311      * required by the EIP. See the note at the beginning of {ERC20}.
312      *
313      * Requirements:
314      *
315      * - `sender` and `recipient` cannot be the zero address.
316      * - `sender` must have a balance of at least `amount`.
317      * - the caller must have allowance for ``sender``'s tokens of at least
318      * `amount`.
319      */
320     function transferFrom(
321         address sender,
322         address recipient,
323         uint256 amount
324     ) public virtual override returns (bool) {
325         _transfer(sender, recipient, amount);
326 
327         uint256 currentAllowance = _allowances[sender][_msgSender()];
328         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
329         unchecked {
330             _approve(sender, _msgSender(), currentAllowance - amount);
331         }
332 
333         return true;
334     }
335 
336     /**
337      * @dev Atomically increases the allowance granted to `spender` by the caller.
338      *
339      * This is an alternative to {approve} that can be used as a mitigation for
340      * problems described in {IERC20-approve}.
341      *
342      * Emits an {Approval} event indicating the updated allowance.
343      *
344      * Requirements:
345      *
346      * - `spender` cannot be the zero address.
347      */
348     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
349         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
350         return true;
351     }
352 
353     /**
354      * @dev Atomically decreases the allowance granted to `spender` by the caller.
355      *
356      * This is an alternative to {approve} that can be used as a mitigation for
357      * problems described in {IERC20-approve}.
358      *
359      * Emits an {Approval} event indicating the updated allowance.
360      *
361      * Requirements:
362      *
363      * - `spender` cannot be the zero address.
364      * - `spender` must have allowance for the caller of at least
365      * `subtractedValue`.
366      */
367     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
368         uint256 currentAllowance = _allowances[_msgSender()][spender];
369         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
370         unchecked {
371             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
372         }
373 
374         return true;
375     }
376 
377     /**
378      * @dev Moves `amount` of tokens from `sender` to `recipient`.
379      *
380      * This internal function is equivalent to {transfer}, and can be used to
381      * e.g. implement automatic token fees, slashing mechanisms, etc.
382      *
383      * Emits a {Transfer} event.
384      *
385      * Requirements:
386      *
387      * - `sender` cannot be the zero address.
388      * - `recipient` cannot be the zero address.
389      * - `sender` must have a balance of at least `amount`.
390      */
391     function _transfer(
392         address sender,
393         address recipient,
394         uint256 amount
395     ) internal virtual {
396         require(sender != address(0), "ERC20: transfer from the zero address");
397         require(recipient != address(0), "ERC20: transfer to the zero address");
398 
399         _beforeTokenTransfer(sender, recipient, amount);
400 
401         uint256 senderBalance = _balances[sender];
402         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
403         unchecked {
404             _balances[sender] = senderBalance - amount;
405         }
406         _balances[recipient] += amount;
407 
408         emit Transfer(sender, recipient, amount);
409 
410         _afterTokenTransfer(sender, recipient, amount);
411     }
412 
413     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
414      * the total supply.
415      *
416      * Emits a {Transfer} event with `from` set to the zero address.
417      *
418      * Requirements:
419      *
420      * - `account` cannot be the zero address.
421      */
422     function _mint(address account, uint256 amount) internal virtual {
423         require(account != address(0), "ERC20: mint to the zero address");
424 
425         _beforeTokenTransfer(address(0), account, amount);
426 
427         _totalSupply += amount;
428         _balances[account] += amount;
429         emit Transfer(address(0), account, amount);
430 
431         _afterTokenTransfer(address(0), account, amount);
432     }
433 
434     /**
435      * @dev Destroys `amount` tokens from `account`, reducing the
436      * total supply.
437      *
438      * Emits a {Transfer} event with `to` set to the zero address.
439      *
440      * Requirements:
441      *
442      * - `account` cannot be the zero address.
443      * - `account` must have at least `amount` tokens.
444      */
445     function _burn(address account, uint256 amount) internal virtual {
446         require(account != address(0), "ERC20: burn from the zero address");
447 
448         _beforeTokenTransfer(account, address(0), amount);
449 
450         uint256 accountBalance = _balances[account];
451         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
452         unchecked {
453             _balances[account] = accountBalance - amount;
454         }
455         _totalSupply -= amount;
456 
457         emit Transfer(account, address(0), amount);
458 
459         _afterTokenTransfer(account, address(0), amount);
460     }
461 
462     /**
463      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
464      *
465      * This internal function is equivalent to `approve`, and can be used to
466      * e.g. set automatic allowances for certain subsystems, etc.
467      *
468      * Emits an {Approval} event.
469      *
470      * Requirements:
471      *
472      * - `owner` cannot be the zero address.
473      * - `spender` cannot be the zero address.
474      */
475     function _approve(
476         address owner,
477         address spender,
478         uint256 amount
479     ) internal virtual {
480         require(owner != address(0), "ERC20: approve from the zero address");
481         require(spender != address(0), "ERC20: approve to the zero address");
482 
483         _allowances[owner][spender] = amount;
484         emit Approval(owner, spender, amount);
485     }
486 
487     /**
488      * @dev Hook that is called before any transfer of tokens. This includes
489      * minting and burning.
490      *
491      * Calling conditions:
492      *
493      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
494      * will be transferred to `to`.
495      * - when `from` is zero, `amount` tokens will be minted for `to`.
496      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
497      * - `from` and `to` are never both zero.
498      *
499      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
500      */
501     function _beforeTokenTransfer(
502         address from,
503         address to,
504         uint256 amount
505     ) internal virtual {}
506 
507     /**
508      * @dev Hook that is called after any transfer of tokens. This includes
509      * minting and burning.
510      *
511      * Calling conditions:
512      *
513      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
514      * has been transferred to `to`.
515      * - when `from` is zero, `amount` tokens have been minted for `to`.
516      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
517      * - `from` and `to` are never both zero.
518      *
519      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
520      */
521     function _afterTokenTransfer(
522         address from,
523         address to,
524         uint256 amount
525     ) internal virtual {}
526 }
527 
528 library Address {
529     /**
530      * @dev Returns true if `account` is a contract.
531      *
532      * [IMPORTANT]
533      * ====
534      * It is unsafe to assume that an address for which this function returns
535      * false is an externally-owned account (EOA) and not a contract.
536      *
537      * Among others, `isContract` will return false for the following
538      * types of addresses:
539      *
540      *  - an externally-owned account
541      *  - a contract in construction
542      *  - an address where a contract will be created
543      *  - an address where a contract lived, but was destroyed
544      * ====
545      */
546     function isContract(address account) internal view returns (bool) {
547         // This method relies on extcodesize, which returns 0 for contracts in
548         // construction, since the code is only stored at the end of the
549         // constructor execution.
550 
551         uint256 size;
552         assembly {
553             size := extcodesize(account)
554         }
555         return size > 0;
556     }
557 
558     /**
559      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
560      * `recipient`, forwarding all available gas and reverting on errors.
561      *
562      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
563      * of certain opcodes, possibly making contracts go over the 2300 gas limit
564      * imposed by `transfer`, making them unable to receive funds via
565      * `transfer`. {sendValue} removes this limitation.
566      *
567      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
568      *
569      * IMPORTANT: because control is transferred to `recipient`, care must be
570      * taken to not create reentrancy vulnerabilities. Consider using
571      * {ReentrancyGuard} or the
572      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
573      */
574     function sendValue(address payable recipient, uint256 amount) internal {
575         require(address(this).balance >= amount, "Address: insufficient balance");
576 
577         (bool success, ) = recipient.call{value: amount}("");
578         require(success, "Address: unable to send value, recipient may have reverted");
579     }
580 
581     /**
582      * @dev Performs a Solidity function call using a low level `call`. A
583      * plain `call` is an unsafe replacement for a function call: use this
584      * function instead.
585      *
586      * If `target` reverts with a revert reason, it is bubbled up by this
587      * function (like regular Solidity function calls).
588      *
589      * Returns the raw returned data. To convert to the expected return value,
590      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
591      *
592      * Requirements:
593      *
594      * - `target` must be a contract.
595      * - calling `target` with `data` must not revert.
596      *
597      * _Available since v3.1._
598      */
599     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
600         return functionCall(target, data, "Address: low-level call failed");
601     }
602 
603     /**
604      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
605      * `errorMessage` as a fallback revert reason when `target` reverts.
606      *
607      * _Available since v3.1._
608      */
609     function functionCall(
610         address target,
611         bytes memory data,
612         string memory errorMessage
613     ) internal returns (bytes memory) {
614         return functionCallWithValue(target, data, 0, errorMessage);
615     }
616 
617     /**
618      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
619      * but also transferring `value` wei to `target`.
620      *
621      * Requirements:
622      *
623      * - the calling contract must have an ETH balance of at least `value`.
624      * - the called Solidity function must be `payable`.
625      *
626      * _Available since v3.1._
627      */
628     function functionCallWithValue(
629         address target,
630         bytes memory data,
631         uint256 value
632     ) internal returns (bytes memory) {
633         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
634     }
635 
636     /**
637      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
638      * with `errorMessage` as a fallback revert reason when `target` reverts.
639      *
640      * _Available since v3.1._
641      */
642     function functionCallWithValue(
643         address target,
644         bytes memory data,
645         uint256 value,
646         string memory errorMessage
647     ) internal returns (bytes memory) {
648         require(address(this).balance >= value, "Address: insufficient balance for call");
649         require(isContract(target), "Address: call to non-contract");
650 
651         (bool success, bytes memory returndata) = target.call{value: value}(data);
652         return verifyCallResult(success, returndata, errorMessage);
653     }
654 
655     /**
656      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
657      * but performing a static call.
658      *
659      * _Available since v3.3._
660      */
661     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
662         return functionStaticCall(target, data, "Address: low-level static call failed");
663     }
664 
665     /**
666      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
667      * but performing a static call.
668      *
669      * _Available since v3.3._
670      */
671     function functionStaticCall(
672         address target,
673         bytes memory data,
674         string memory errorMessage
675     ) internal view returns (bytes memory) {
676         require(isContract(target), "Address: static call to non-contract");
677 
678         (bool success, bytes memory returndata) = target.staticcall(data);
679         return verifyCallResult(success, returndata, errorMessage);
680     }
681 
682     /**
683      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
684      * but performing a delegate call.
685      *
686      * _Available since v3.4._
687      */
688     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
689         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
690     }
691 
692     /**
693      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
694      * but performing a delegate call.
695      *
696      * _Available since v3.4._
697      */
698     function functionDelegateCall(
699         address target,
700         bytes memory data,
701         string memory errorMessage
702     ) internal returns (bytes memory) {
703         require(isContract(target), "Address: delegate call to non-contract");
704 
705         (bool success, bytes memory returndata) = target.delegatecall(data);
706         return verifyCallResult(success, returndata, errorMessage);
707     }
708 
709     /**
710      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
711      * revert reason using the provided one.
712      *
713      * _Available since v4.3._
714      */
715     function verifyCallResult(
716         bool success,
717         bytes memory returndata,
718         string memory errorMessage
719     ) internal pure returns (bytes memory) {
720         if (success) {
721             return returndata;
722         } else {
723             // Look for revert reason and bubble it up if present
724             if (returndata.length > 0) {
725                 // The easiest way to bubble the revert reason is using memory via assembly
726 
727                 assembly {
728                     let returndata_size := mload(returndata)
729                     revert(add(32, returndata), returndata_size)
730                 }
731             } else {
732                 revert(errorMessage);
733             }
734         }
735     }
736 }
737 
738 library SafeMath {
739     /**
740      * @dev Returns the addition of two unsigned integers, with an overflow flag.
741      *
742      * _Available since v3.4._
743      */
744     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
745         unchecked {
746             uint256 c = a + b;
747             if (c < a) return (false, 0);
748             return (true, c);
749         }
750     }
751 
752     /**
753      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
754      *
755      * _Available since v3.4._
756      */
757     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
758         unchecked {
759             if (b > a) return (false, 0);
760             return (true, a - b);
761         }
762     }
763 
764     /**
765      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
766      *
767      * _Available since v3.4._
768      */
769     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
770         unchecked {
771             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
772             // benefit is lost if 'b' is also tested.
773             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
774             if (a == 0) return (true, 0);
775             uint256 c = a * b;
776             if (c / a != b) return (false, 0);
777             return (true, c);
778         }
779     }
780 
781     /**
782      * @dev Returns the division of two unsigned integers, with a division by zero flag.
783      *
784      * _Available since v3.4._
785      */
786     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
787         unchecked {
788             if (b == 0) return (false, 0);
789             return (true, a / b);
790         }
791     }
792 
793     /**
794      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
795      *
796      * _Available since v3.4._
797      */
798     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
799         unchecked {
800             if (b == 0) return (false, 0);
801             return (true, a % b);
802         }
803     }
804 
805     /**
806      * @dev Returns the addition of two unsigned integers, reverting on
807      * overflow.
808      *
809      * Counterpart to Solidity's `+` operator.
810      *
811      * Requirements:
812      *
813      * - Addition cannot overflow.
814      */
815     function add(uint256 a, uint256 b) internal pure returns (uint256) {
816         return a + b;
817     }
818 
819     /**
820      * @dev Returns the subtraction of two unsigned integers, reverting on
821      * overflow (when the result is negative).
822      *
823      * Counterpart to Solidity's `-` operator.
824      *
825      * Requirements:
826      *
827      * - Subtraction cannot overflow.
828      */
829     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
830         return a - b;
831     }
832 
833     /**
834      * @dev Returns the multiplication of two unsigned integers, reverting on
835      * overflow.
836      *
837      * Counterpart to Solidity's `*` operator.
838      *
839      * Requirements:
840      *
841      * - Multiplication cannot overflow.
842      */
843     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
844         return a * b;
845     }
846 
847     /**
848      * @dev Returns the integer division of two unsigned integers, reverting on
849      * division by zero. The result is rounded towards zero.
850      *
851      * Counterpart to Solidity's `/` operator.
852      *
853      * Requirements:
854      *
855      * - The divisor cannot be zero.
856      */
857     function div(uint256 a, uint256 b) internal pure returns (uint256) {
858         return a / b;
859     }
860 
861     /**
862      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
863      * reverting when dividing by zero.
864      *
865      * Counterpart to Solidity's `%` operator. This function uses a `revert`
866      * opcode (which leaves remaining gas untouched) while Solidity uses an
867      * invalid opcode to revert (consuming all remaining gas).
868      *
869      * Requirements:
870      *
871      * - The divisor cannot be zero.
872      */
873     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
874         return a % b;
875     }
876 
877     /**
878      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
879      * overflow (when the result is negative).
880      *
881      * CAUTION: This function is deprecated because it requires allocating memory for the error
882      * message unnecessarily. For custom revert reasons use {trySub}.
883      *
884      * Counterpart to Solidity's `-` operator.
885      *
886      * Requirements:
887      *
888      * - Subtraction cannot overflow.
889      */
890     function sub(
891         uint256 a,
892         uint256 b,
893         string memory errorMessage
894     ) internal pure returns (uint256) {
895         unchecked {
896             require(b <= a, errorMessage);
897             return a - b;
898         }
899     }
900 
901     /**
902      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
903      * division by zero. The result is rounded towards zero.
904      *
905      * Counterpart to Solidity's `/` operator. Note: this function uses a
906      * `revert` opcode (which leaves remaining gas untouched) while Solidity
907      * uses an invalid opcode to revert (consuming all remaining gas).
908      *
909      * Requirements:
910      *
911      * - The divisor cannot be zero.
912      */
913     function div(
914         uint256 a,
915         uint256 b,
916         string memory errorMessage
917     ) internal pure returns (uint256) {
918         unchecked {
919             require(b > 0, errorMessage);
920             return a / b;
921         }
922     }
923 
924     /**
925      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
926      * reverting with custom message when dividing by zero.
927      *
928      * CAUTION: This function is deprecated because it requires allocating memory for the error
929      * message unnecessarily. For custom revert reasons use {tryMod}.
930      *
931      * Counterpart to Solidity's `%` operator. This function uses a `revert`
932      * opcode (which leaves remaining gas untouched) while Solidity uses an
933      * invalid opcode to revert (consuming all remaining gas).
934      *
935      * Requirements:
936      *
937      * - The divisor cannot be zero.
938      */
939     function mod(
940         uint256 a,
941         uint256 b,
942         string memory errorMessage
943     ) internal pure returns (uint256) {
944         unchecked {
945             require(b > 0, errorMessage);
946             return a % b;
947         }
948     }
949 }
950 
951 interface IUniswapV2Factory {
952     event PairCreated(
953         address indexed token0,
954         address indexed token1,
955         address pair,
956         uint256
957     );
958 
959     function feeTo() external view returns (address);
960 
961     function feeToSetter() external view returns (address);
962 
963     function getPair(address tokenA, address tokenB)
964         external
965         view
966         returns (address pair);
967 
968     function allPairs(uint256) external view returns (address pair);
969 
970     function allPairsLength() external view returns (uint256);
971 
972     function createPair(address tokenA, address tokenB)
973         external
974         returns (address pair);
975 
976     function setFeeTo(address) external;
977 
978     function setFeeToSetter(address) external;
979 }
980 
981 interface IUniswapV2Pair {
982     event Approval(
983         address indexed owner,
984         address indexed spender,
985         uint256 value
986     );
987     event Transfer(address indexed from, address indexed to, uint256 value);
988 
989     function name() external pure returns (string memory);
990 
991     function symbol() external pure returns (string memory);
992 
993     function decimals() external pure returns (uint8);
994 
995     function totalSupply() external view returns (uint256);
996 
997     function balanceOf(address owner) external view returns (uint256);
998 
999     function allowance(address owner, address spender)
1000         external
1001         view
1002         returns (uint256);
1003 
1004     function approve(address spender, uint256 value) external returns (bool);
1005 
1006     function transfer(address to, uint256 value) external returns (bool);
1007 
1008     function transferFrom(
1009         address from,
1010         address to,
1011         uint256 value
1012     ) external returns (bool);
1013 
1014     function DOMAIN_SEPARATOR() external view returns (bytes32);
1015 
1016     function PERMIT_TYPEHASH() external pure returns (bytes32);
1017 
1018     function nonces(address owner) external view returns (uint256);
1019 
1020     function permit(
1021         address owner,
1022         address spender,
1023         uint256 value,
1024         uint256 deadline,
1025         uint8 v,
1026         bytes32 r,
1027         bytes32 s
1028     ) external;
1029 
1030     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
1031     event Burn(
1032         address indexed sender,
1033         uint256 amount0,
1034         uint256 amount1,
1035         address indexed to
1036     );
1037     event Swap(
1038         address indexed sender,
1039         uint256 amount0In,
1040         uint256 amount1In,
1041         uint256 amount0Out,
1042         uint256 amount1Out,
1043         address indexed to
1044     );
1045     event Sync(uint112 reserve0, uint112 reserve1);
1046 
1047     function MINIMUM_LIQUIDITY() external pure returns (uint256);
1048 
1049     function factory() external view returns (address);
1050 
1051     function token0() external view returns (address);
1052 
1053     function token1() external view returns (address);
1054 
1055     function getReserves()
1056         external
1057         view
1058         returns (
1059             uint112 reserve0,
1060             uint112 reserve1,
1061             uint32 blockTimestampLast
1062         );
1063 
1064     function price0CumulativeLast() external view returns (uint256);
1065 
1066     function price1CumulativeLast() external view returns (uint256);
1067 
1068     function kLast() external view returns (uint256);
1069 
1070     function mint(address to) external returns (uint256 liquidity);
1071 
1072     function burn(address to)
1073         external
1074         returns (uint256 amount0, uint256 amount1);
1075 
1076     function swap(
1077         uint256 amount0Out,
1078         uint256 amount1Out,
1079         address to,
1080         bytes calldata data
1081     ) external;
1082 
1083     function skim(address to) external;
1084 
1085     function sync() external;
1086 
1087     function initialize(address, address) external;
1088 }
1089 
1090 interface IUniswapV2Router02 {
1091     function factory() external pure returns (address);
1092 
1093     function WETH() external pure returns (address);
1094 
1095     function addLiquidity(
1096         address tokenA,
1097         address tokenB,
1098         uint256 amountADesired,
1099         uint256 amountBDesired,
1100         uint256 amountAMin,
1101         uint256 amountBMin,
1102         address to,
1103         uint256 deadline
1104     )
1105         external
1106         returns (
1107             uint256 amountA,
1108             uint256 amountB,
1109             uint256 liquidity
1110         );
1111 
1112     function addLiquidityETH(
1113         address token,
1114         uint256 amountTokenDesired,
1115         uint256 amountTokenMin,
1116         uint256 amountETHMin,
1117         address to,
1118         uint256 deadline
1119     )
1120         external
1121         payable
1122         returns (
1123             uint256 amountToken,
1124             uint256 amountETH,
1125             uint256 liquidity
1126         );
1127 
1128     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
1129         uint256 amountIn,
1130         uint256 amountOutMin,
1131         address[] calldata path,
1132         address to,
1133         uint256 deadline
1134     ) external;
1135 
1136     function swapExactETHForTokensSupportingFeeOnTransferTokens(
1137         uint256 amountOutMin,
1138         address[] calldata path,
1139         address to,
1140         uint256 deadline
1141     ) external payable;
1142 
1143     function swapExactTokensForETHSupportingFeeOnTransferTokens(
1144         uint256 amountIn,
1145         uint256 amountOutMin,
1146         address[] calldata path,
1147         address to,
1148         uint256 deadline
1149     ) external;
1150 }
1151 
1152 enum PairType {Common, LiquidityLocked, SweepableToken0, SweepableToken1}
1153 
1154 interface IEmpirePair {
1155     function sweep(uint256 amount, bytes calldata data) external;
1156 
1157     function unsweep(uint256 amount) external;
1158 }
1159 
1160 interface IEmpireFactory {
1161     event PairCreated(
1162         address indexed token0,
1163         address indexed token1,
1164         address pair,
1165         uint256
1166     );
1167 
1168     function createPair(address tokenA, address tokenB)
1169         external
1170         returns (address pair);
1171 
1172     function createPair(
1173         address tokenA,
1174         address tokenB,
1175         PairType pairType,
1176         uint256 unlockTime
1177     ) external returns (address pair);
1178 
1179 }
1180 
1181 contract MFF is Ownable, IERC20 {
1182     address UNISWAPROUTER = address(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
1183     address DEAD = 0x000000000000000000000000000000000000dEaD;
1184     address ZERO = 0x0000000000000000000000000000000000000000;
1185 
1186     string private _name = "MetaFarmer.Finance";
1187     string private _symbol = "MFF";
1188 
1189     uint256 public treasuryFeeBPS = 800;
1190     uint256 public liquidityFeeBPS = 200;
1191     uint256 public dividendFeeBPS = 200;
1192     uint256 public totalFeeBPS = 1200;
1193 
1194     uint256 public swapTokensAtAmount = 100000 * (10**18);
1195     uint256 public lastSwapTime;
1196     bool swapAllToken = true;
1197 
1198     bool public swapEnabled = true;
1199     bool public taxEnabled = true;
1200     bool public compoundingEnabled = true;
1201 
1202     uint256 private _totalSupply;
1203     bool private swapping;
1204 
1205     address marketingWallet;
1206     address liquidityWallet;
1207 
1208     mapping(address => uint256) private _balances;
1209     mapping(address => mapping(address => uint256)) private _allowances;
1210     mapping(address => bool) private _isExcludedFromFees;
1211     mapping(address => bool) public automatedMarketMakerPairs;
1212     mapping(address => bool) private _whiteList;
1213     mapping(address => bool) isBlacklisted;
1214 
1215     event SwapAndAddLiquidity(
1216         uint256 tokensSwapped,
1217         uint256 nativeReceived,
1218         uint256 tokensIntoLiquidity
1219     );
1220     event SendDividends(uint256 tokensSwapped, uint256 amount);
1221     event ExcludeFromFees(address indexed account, bool isExcluded);
1222     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
1223     event UpdateUniswapV2Router(
1224         address indexed newAddress,
1225         address indexed oldAddress
1226     );
1227     event SwapEnabled(bool enabled);
1228     event TaxEnabled(bool enabled);
1229     event CompoundingEnabled(bool enabled);
1230     event BlacklistEnabled(bool enabled);
1231 
1232     DividendTracker public dividendTracker;
1233     IUniswapV2Router02 public uniswapV2Router;
1234 
1235     address public uniswapV2Pair;
1236     address public sweepablePair;
1237 
1238     uint256 public maxTxBPS = 20; //max tx amount
1239     uint256 public maxWalletBPS = 200; //max wallet amount
1240 
1241     bool isOpen = false;
1242 
1243     mapping(address => bool) private _isExcludedFromMaxTx;
1244     mapping(address => bool) private _isExcludedFromMaxWallet;
1245 
1246     modifier onlyPair() {
1247         require(
1248             msg.sender == sweepablePair,
1249             "Empire::onlyPair: Insufficient Privileges"
1250         );
1251         _;
1252     }
1253 
1254     constructor(
1255         address _marketingWallet,
1256         address _liquidityWallet,
1257         address[] memory whitelistAddress
1258     ) {
1259         marketingWallet = _marketingWallet;
1260         liquidityWallet = _liquidityWallet;
1261         includeToWhiteList(whitelistAddress);
1262 
1263         dividendTracker = new DividendTracker(address(this), UNISWAPROUTER);
1264 
1265         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(UNISWAPROUTER);
1266 
1267         address _uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
1268             .createPair(address(this), _uniswapV2Router.WETH());
1269 
1270         uniswapV2Router = _uniswapV2Router;
1271         uniswapV2Pair = _uniswapV2Pair;
1272 
1273         _setAutomatedMarketMakerPair(_uniswapV2Pair, true);
1274 
1275         dividendTracker.excludeFromDividends(address(dividendTracker), true);
1276         dividendTracker.excludeFromDividends(address(this), true);
1277         dividendTracker.excludeFromDividends(owner(), true);
1278         dividendTracker.excludeFromDividends(address(_uniswapV2Router), true);
1279 
1280         excludeFromFees(owner(), true);
1281         excludeFromFees(address(this), true);
1282         excludeFromFees(address(dividendTracker), true);
1283 
1284         excludeFromMaxTx(owner(), true);
1285         excludeFromMaxTx(address(this), true);
1286         excludeFromMaxTx(address(dividendTracker), true);
1287 
1288         excludeFromMaxWallet(owner(), true);
1289         excludeFromMaxWallet(address(this), true);
1290         excludeFromMaxWallet(address(dividendTracker), true);
1291 
1292         _mint(owner(), 1000000000 * (10**18));
1293     }
1294 
1295     receive() external payable {}
1296 
1297     function name() public view returns (string memory) {
1298         return _name;
1299     }
1300 
1301     function symbol() public view returns (string memory) {
1302         return _symbol;
1303     }
1304 
1305     function decimals() public pure returns (uint8) {
1306         return 18;
1307     }
1308 
1309     function totalSupply() public view virtual override returns (uint256) {
1310         return _totalSupply;
1311     }
1312 
1313     function balanceOf(address account)
1314         public
1315         view
1316         virtual
1317         override
1318         returns (uint256)
1319     {
1320         return _balances[account];
1321     }
1322 
1323     function allowance(address owner, address spender)
1324         public
1325         view
1326         virtual
1327         override
1328         returns (uint256)
1329     {
1330         return _allowances[owner][spender];
1331     }
1332 
1333     function approve(address spender, uint256 amount)
1334         public
1335         virtual
1336         override
1337         returns (bool)
1338     {
1339         _approve(_msgSender(), spender, amount);
1340         return true;
1341     }
1342 
1343     function increaseAllowance(address spender, uint256 addedValue)
1344         public
1345         returns (bool)
1346     {
1347         _approve(
1348             _msgSender(),
1349             spender,
1350             _allowances[_msgSender()][spender] + addedValue
1351         );
1352         return true;
1353     }
1354 
1355     function decreaseAllowance(address spender, uint256 subtractedValue)
1356         public
1357         returns (bool)
1358     {
1359         uint256 currentAllowance = _allowances[_msgSender()][spender];
1360         require(
1361             currentAllowance >= subtractedValue,
1362             "MFF: decreased allowance below zero"
1363         );
1364         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
1365         return true;
1366     }
1367 
1368     function transfer(address recipient, uint256 amount)
1369         public
1370         virtual
1371         override
1372         returns (bool)
1373     {
1374         _transfer(_msgSender(), recipient, amount);
1375         return true;
1376     }
1377 
1378     function transferFrom(
1379         address sender,
1380         address recipient,
1381         uint256 amount
1382     ) public virtual override returns (bool) {
1383         _transfer(sender, recipient, amount);
1384         uint256 currentAllowance = _allowances[sender][_msgSender()];
1385         require(
1386             currentAllowance >= amount,
1387             "MFF: transfer amount exceeds allowance"
1388         );
1389         _approve(sender, _msgSender(), currentAllowance - amount);
1390         return true;
1391     }
1392 
1393     function openTrading() external onlyOwner {
1394         isOpen = true;
1395     }
1396 
1397     function _transfer(
1398         address sender,
1399         address recipient,
1400         uint256 amount
1401     ) internal {
1402         require(
1403             isOpen ||
1404                 sender == owner() ||
1405                 recipient == owner() ||
1406                 _whiteList[sender] ||
1407                 _whiteList[recipient],
1408             "Not Open"
1409         );
1410 
1411         require(!isBlacklisted[sender], "MFF: Sender is blacklisted");
1412         require(!isBlacklisted[recipient], "MFF: Recipient is blacklisted");
1413 
1414         require(sender != address(0), "MFF: transfer from the zero address");
1415         require(recipient != address(0), "MFF: transfer to the zero address");
1416 
1417         uint256 _maxTxAmount = (totalSupply() * maxTxBPS) / 10000;
1418         uint256 _maxWallet = (totalSupply() * maxWalletBPS) / 10000;
1419         require(
1420             amount <= _maxTxAmount || _isExcludedFromMaxTx[sender],
1421             "TX Limit Exceeded"
1422         );
1423 
1424         if (
1425             sender != owner() &&
1426             recipient != address(this) &&
1427             recipient != address(DEAD) &&
1428             recipient != uniswapV2Pair
1429         ) {
1430             uint256 currentBalance = balanceOf(recipient);
1431             require(
1432                 _isExcludedFromMaxWallet[recipient] ||
1433                     (currentBalance + amount <= _maxWallet)
1434             );
1435         }
1436 
1437         uint256 senderBalance = _balances[sender];
1438         require(
1439             senderBalance >= amount,
1440             "MFF: transfer amount exceeds balance"
1441         );
1442 
1443         uint256 contractTokenBalance = balanceOf(address(this));
1444         uint256 contractNativeBalance = address(this).balance;
1445 
1446         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1447 
1448         if (
1449             swapEnabled && // True
1450             canSwap && // true
1451             !swapping && // swapping=false !false true
1452             !automatedMarketMakerPairs[sender] && // no swap on remove liquidity step 1 or DEX buy
1453             sender != address(uniswapV2Router) && // no swap on remove liquidity step 2
1454             sender != owner() &&
1455             recipient != owner()
1456         ) {
1457             swapping = true;
1458 
1459             if (!swapAllToken) {
1460                 contractTokenBalance = swapTokensAtAmount;
1461             }
1462             _executeSwap(contractTokenBalance, contractNativeBalance);
1463 
1464             lastSwapTime = block.timestamp;
1465             swapping = false;
1466         }
1467 
1468         bool takeFee;
1469 
1470         if (
1471             sender == address(uniswapV2Pair) ||
1472             recipient == address(uniswapV2Pair)
1473         ) {
1474             takeFee = true;
1475         }
1476 
1477         if (_isExcludedFromFees[sender] || _isExcludedFromFees[recipient]) {
1478             takeFee = false;
1479         }
1480 
1481         if (swapping || !taxEnabled) {
1482             takeFee = false;
1483         }
1484 
1485         if (takeFee) {
1486             uint256 fees = (amount * totalFeeBPS) / 10000;
1487             amount -= fees;
1488             _executeTransfer(sender, address(this), fees);
1489         }
1490 
1491         _executeTransfer(sender, recipient, amount);
1492 
1493         dividendTracker.setBalance(payable(sender), balanceOf(sender));
1494         dividendTracker.setBalance(payable(recipient), balanceOf(recipient));
1495     }
1496 
1497     function _executeTransfer(
1498         address sender,
1499         address recipient,
1500         uint256 amount
1501     ) private {
1502         require(sender != address(0), "MFF: transfer from the zero address");
1503         require(recipient != address(0), "MFF: transfer to the zero address");
1504         uint256 senderBalance = _balances[sender];
1505         require(
1506             senderBalance >= amount,
1507             "MFF: transfer amount exceeds balance"
1508         );
1509         _balances[sender] = senderBalance - amount;
1510         _balances[recipient] += amount;
1511         emit Transfer(sender, recipient, amount);
1512     }
1513 
1514     function _approve(
1515         address owner,
1516         address spender,
1517         uint256 amount
1518     ) private {
1519         require(owner != address(0), "MFF: approve from the zero address");
1520         require(spender != address(0), "MFF: approve to the zero address");
1521         _allowances[owner][spender] = amount;
1522         emit Approval(owner, spender, amount);
1523     }
1524 
1525     function _mint(address account, uint256 amount) private {
1526         require(account != address(0), "MFF: mint to the zero address");
1527         _totalSupply += amount;
1528         _balances[account] += amount;
1529         emit Transfer(address(0), account, amount);
1530     }
1531 
1532     function _burn(address account, uint256 amount) private {
1533         require(account != address(0), "MFF: burn from the zero address");
1534         uint256 accountBalance = _balances[account];
1535         require(accountBalance >= amount, "MFF: burn amount exceeds balance");
1536         _balances[account] = accountBalance - amount;
1537         _totalSupply -= amount;
1538         emit Transfer(account, address(0), amount);
1539     }
1540 
1541     function swapTokensForNative(uint256 tokens) private {
1542         address[] memory path = new address[](2);
1543         path[0] = address(this);
1544         path[1] = uniswapV2Router.WETH();
1545         _approve(address(this), address(uniswapV2Router), tokens);
1546         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1547             tokens,
1548             0, // accept any amount of native
1549             path,
1550             address(this),
1551             block.timestamp
1552         );
1553     }
1554 
1555     function addLiquidity(uint256 tokens, uint256 native) private {
1556         _approve(address(this), address(uniswapV2Router), tokens);
1557         uniswapV2Router.addLiquidityETH{value: native}(
1558             address(this),
1559             tokens,
1560             0, // slippage unavoidable
1561             0, // slippage unavoidable
1562             liquidityWallet,
1563             block.timestamp
1564         );
1565     }
1566 
1567     function includeToWhiteList(address[] memory _users) private {
1568         for (uint8 i = 0; i < _users.length; i++) {
1569             _whiteList[_users[i]] = true;
1570         }
1571     }
1572 
1573     function _executeSwap(uint256 tokens, uint256 native) private {
1574         if (tokens <= 0) {
1575             return;
1576         }
1577 
1578         uint256 swapTokensMarketing;
1579         if (address(marketingWallet) != address(0)) {
1580             swapTokensMarketing = (tokens * treasuryFeeBPS) / totalFeeBPS;
1581         }
1582 
1583         uint256 swapTokensDividends;
1584         if (dividendTracker.totalSupply() > 0) {
1585             swapTokensDividends = (tokens * dividendFeeBPS) / totalFeeBPS;
1586         }
1587 
1588         uint256 tokensForLiquidity = tokens -
1589             swapTokensMarketing -
1590             swapTokensDividends;
1591         uint256 swapTokensLiquidity = tokensForLiquidity / 2;
1592         uint256 addTokensLiquidity = tokensForLiquidity - swapTokensLiquidity;
1593         uint256 swapTokensTotal = swapTokensMarketing +
1594             swapTokensDividends +
1595             swapTokensLiquidity;
1596 
1597         uint256 initNativeBal = address(this).balance;
1598         swapTokensForNative(swapTokensTotal);
1599         uint256 nativeSwapped = (address(this).balance - initNativeBal) +
1600             native;
1601 
1602         uint256 nativeMarketing = (nativeSwapped * swapTokensMarketing) /
1603             swapTokensTotal;
1604         uint256 nativeDividends = (nativeSwapped * swapTokensDividends) /
1605             swapTokensTotal;
1606         uint256 nativeLiquidity = nativeSwapped -
1607             nativeMarketing -
1608             nativeDividends;
1609 
1610         if (nativeMarketing > 0) {
1611             payable(marketingWallet).transfer(nativeMarketing);
1612         }
1613 
1614         addLiquidity(addTokensLiquidity, nativeLiquidity);
1615         emit SwapAndAddLiquidity(
1616             swapTokensLiquidity,
1617             nativeLiquidity,
1618             addTokensLiquidity
1619         );
1620 
1621         if (nativeDividends > 0) {
1622             (bool success, ) = address(dividendTracker).call{
1623                 value: nativeDividends
1624             }("");
1625             if (success) {
1626                 emit SendDividends(swapTokensDividends, nativeDividends);
1627             }
1628         }
1629     }
1630 
1631     function excludeFromFees(address account, bool excluded) public onlyOwner {
1632         require(
1633             _isExcludedFromFees[account] != excluded,
1634             "MFF: account is already set to requested state"
1635         );
1636         _isExcludedFromFees[account] = excluded;
1637         emit ExcludeFromFees(account, excluded);
1638     }
1639 
1640     function isExcludedFromFees(address account) public view returns (bool) {
1641         return _isExcludedFromFees[account];
1642     }
1643 
1644     function manualSendDividend(uint256 amount, address holder)
1645         external
1646         onlyOwner
1647     {
1648         dividendTracker.manualSendDividend(amount, holder);
1649     }
1650 
1651     function excludeFromDividends(address account, bool excluded)
1652         public
1653         onlyOwner
1654     {
1655         dividendTracker.excludeFromDividends(account, excluded);
1656     }
1657 
1658     function isExcludedFromDividends(address account)
1659         public
1660         view
1661         returns (bool)
1662     {
1663         return dividendTracker.isExcludedFromDividends(account);
1664     }
1665 
1666     function setWallet(
1667         address payable _marketingWallet,
1668         address payable _liquidityWallet
1669     ) external onlyOwner {
1670         marketingWallet = _marketingWallet;
1671         liquidityWallet = _liquidityWallet;
1672     }
1673 
1674     function setAutomatedMarketMakerPair(address pair, bool value)
1675         public
1676         onlyOwner
1677     {
1678         require(pair != uniswapV2Pair, "MFF: DEX pair can not be removed");
1679         _setAutomatedMarketMakerPair(pair, value);
1680     }
1681 
1682     function setFee(
1683         uint256 _treasuryFee,
1684         uint256 _liquidityFee,
1685         uint256 _dividendFee
1686     ) external onlyOwner {
1687         treasuryFeeBPS = _treasuryFee;
1688         liquidityFeeBPS = _liquidityFee;
1689         dividendFeeBPS = _dividendFee;
1690         totalFeeBPS = _treasuryFee + _liquidityFee + _dividendFee;
1691     }
1692 
1693     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1694         require(
1695             automatedMarketMakerPairs[pair] != value,
1696             "MFF: automated market maker pair is already set to that value"
1697         );
1698         automatedMarketMakerPairs[pair] = value;
1699         if (value) {
1700             dividendTracker.excludeFromDividends(pair, true);
1701         }
1702         emit SetAutomatedMarketMakerPair(pair, value);
1703     }
1704 
1705     function updateUniswapV2Router(address newAddress) public onlyOwner {
1706         require(
1707             newAddress != address(uniswapV2Router),
1708             "MFF: the router is already set to the new address"
1709         );
1710         emit UpdateUniswapV2Router(newAddress, address(uniswapV2Router));
1711         uniswapV2Router = IUniswapV2Router02(newAddress);
1712         address _uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory())
1713             .createPair(address(this), uniswapV2Router.WETH());
1714         uniswapV2Pair = _uniswapV2Pair;
1715     }
1716 
1717     function claimTeam(address payable _lockContract) external onlyOwner {
1718         dividendTracker.processAccount(payable(_lockContract));
1719     }
1720 
1721     function claim() public {
1722         dividendTracker.processAccount(payable(_msgSender()));
1723     }
1724 
1725     function compound() public {
1726         require(compoundingEnabled, "MFF: compounding is not enabled");
1727         dividendTracker.compoundAccount(payable(_msgSender()));
1728     }
1729 
1730     function withdrawableDividendOf(address account)
1731         public
1732         view
1733         returns (uint256)
1734     {
1735         return dividendTracker.withdrawableDividendOf(account);
1736     }
1737 
1738     function withdrawnDividendOf(address account)
1739         public
1740         view
1741         returns (uint256)
1742     {
1743         return dividendTracker.withdrawnDividendOf(account);
1744     }
1745 
1746     function accumulativeDividendOf(address account)
1747         public
1748         view
1749         returns (uint256)
1750     {
1751         return dividendTracker.accumulativeDividendOf(account);
1752     }
1753 
1754     function getAccountInfo(address account)
1755         public
1756         view
1757         returns (
1758             address,
1759             uint256,
1760             uint256,
1761             uint256,
1762             uint256
1763         )
1764     {
1765         return dividendTracker.getAccountInfo(account);
1766     }
1767 
1768     function getLastClaimTime(address account) public view returns (uint256) {
1769         return dividendTracker.getLastClaimTime(account);
1770     }
1771 
1772     function setSwapEnabled(bool _enabled) external onlyOwner {
1773         swapEnabled = _enabled;
1774         emit SwapEnabled(_enabled);
1775     }
1776 
1777     function setTaxEnabled(bool _enabled) external onlyOwner {
1778         taxEnabled = _enabled;
1779         emit TaxEnabled(_enabled);
1780     }
1781 
1782     function setCompoundingEnabled(bool _enabled) external onlyOwner {
1783         compoundingEnabled = _enabled;
1784         emit CompoundingEnabled(_enabled);
1785     }
1786 
1787     function updateDividendSettings(
1788         bool _swapEnabled,
1789         uint256 _swapTokensAtAmount,
1790         bool _swapAllToken
1791     ) external onlyOwner {
1792         swapEnabled = _swapEnabled;
1793         swapTokensAtAmount = _swapTokensAtAmount;
1794         swapAllToken = _swapAllToken;
1795     }
1796 
1797     function setMaxTxBPS(uint256 bps) external onlyOwner {
1798         require(bps >= 20 && bps <= 10000, "BPS must be between 20 and 10000");
1799         maxTxBPS = bps;
1800     }
1801 
1802     function excludeFromMaxTx(address account, bool excluded) public onlyOwner {
1803         _isExcludedFromMaxTx[account] = excluded;
1804     }
1805 
1806     function isExcludedFromMaxTx(address account) public view returns (bool) {
1807         return _isExcludedFromMaxTx[account];
1808     }
1809 
1810     function setMaxWalletBPS(uint256 bps) external onlyOwner {
1811         require(
1812             bps >= 175 && bps <= 10000,
1813             "BPS must be between 175 and 10000"
1814         );
1815         maxWalletBPS = bps;
1816     }
1817 
1818     function excludeFromMaxWallet(address account, bool excluded)
1819         public
1820         onlyOwner
1821     {
1822         _isExcludedFromMaxWallet[account] = excluded;
1823     }
1824 
1825     function isExcludedFromMaxWallet(address account)
1826         public
1827         view
1828         returns (bool)
1829     {
1830         return _isExcludedFromMaxWallet[account];
1831     }
1832 
1833     function rescueToken(address _token, uint256 _amount) external onlyOwner {
1834         IERC20(_token).transfer(msg.sender, _amount);
1835     }
1836 
1837     function rescueETH(uint256 _amount) external onlyOwner {
1838         payable(msg.sender).transfer(_amount);
1839     }
1840 
1841     function adminWhiteList(address[] memory _users) external onlyOwner {
1842         for (uint8 i = 0; i < _users.length; i++) {
1843             _whiteList[_users[i]] = true;
1844         }
1845     }
1846 
1847     function blackList(address _user) public onlyOwner {
1848         require(!isBlacklisted[_user], "user already blacklisted");
1849         isBlacklisted[_user] = true;
1850         // events?
1851     }
1852 
1853     function removeFromBlacklist(address _user) public onlyOwner {
1854         require(isBlacklisted[_user], "user already whitelisted");
1855         isBlacklisted[_user] = false;
1856         //events?
1857     }
1858 
1859     function blackListMany(address[] memory _users) public onlyOwner {
1860         for (uint8 i = 0; i < _users.length; i++) {
1861             isBlacklisted[_users[i]] = true;
1862         }
1863     }
1864 
1865     function unBlackListMany(address[] memory _users) public onlyOwner {
1866         for (uint8 i = 0; i < _users.length; i++) {
1867             isBlacklisted[_users[i]] = false;
1868         }
1869     }
1870 
1871      // EmpireDEX 
1872     event Sweep(uint256 sweepAmount);
1873     event Unsweep(uint256 unsweepAmount);
1874 
1875     function createSweepablePair(IEmpireFactory _factory, bool update) external onlyOwner() {
1876         PairType pairType =
1877             address(this) < uniswapV2Router.WETH()
1878                 ? PairType.SweepableToken1
1879                 : PairType.SweepableToken0;
1880         sweepablePair = _factory.createPair(uniswapV2Router.WETH(), address(this), pairType, 0);
1881 
1882         if(update) { 
1883             uniswapV2Pair = sweepablePair;
1884         }
1885     }
1886 
1887     function sweep(uint256 amount, bytes calldata data) external onlyOwner() {
1888         IEmpirePair(sweepablePair).sweep(amount, data);
1889         emit Sweep(amount);
1890     }
1891 
1892     function empireSweepCall(uint256 amount, bytes calldata) external onlyPair() {
1893         IERC20(uniswapV2Router.WETH()).transfer(owner(), amount);
1894     }
1895 
1896     function unsweep(uint256 amount) external onlyOwner() {
1897         IERC20(uniswapV2Router.WETH()).approve(sweepablePair, amount);
1898         IEmpirePair(sweepablePair).unsweep(amount);
1899         emit Unsweep(amount);
1900     }
1901 }
1902 
1903 contract DividendTracker is Ownable, IERC20 {
1904     address UNISWAPROUTER;
1905 
1906     string private _name = "MFF_DividendTracker";
1907     string private _symbol = "MFF_DividendTracker";
1908 
1909     uint256 public lastProcessedIndex;
1910 
1911     uint256 private _totalSupply;
1912     mapping(address => uint256) private _balances;
1913 
1914     uint256 private constant magnitude = 2**128;
1915     uint256 public immutable minTokenBalanceForDividends;
1916     uint256 private magnifiedDividendPerShare;
1917     uint256 public totalDividendsDistributed;
1918     uint256 public totalDividendsWithdrawn;
1919 
1920     address public tokenAddress;
1921 
1922     mapping(address => bool) public excludedFromDividends;
1923     mapping(address => int256) private magnifiedDividendCorrections;
1924     mapping(address => uint256) private withdrawnDividends;
1925     mapping(address => uint256) private lastClaimTimes;
1926 
1927     event DividendsDistributed(address indexed from, uint256 weiAmount);
1928     event DividendWithdrawn(address indexed to, uint256 weiAmount);
1929     event ExcludeFromDividends(address indexed account, bool excluded);
1930     event Claim(address indexed account, uint256 amount);
1931     event Compound(address indexed account, uint256 amount, uint256 tokens);
1932 
1933     struct AccountInfo {
1934         address account;
1935         uint256 withdrawableDividends;
1936         uint256 totalDividends;
1937         uint256 lastClaimTime;
1938     }
1939 
1940     constructor(address _tokenAddress, address _uniswapRouter) {
1941         minTokenBalanceForDividends = 10000 * (10**18);
1942         tokenAddress = _tokenAddress;
1943         UNISWAPROUTER = _uniswapRouter;
1944     }
1945 
1946     receive() external payable {
1947         distributeDividends();
1948     }
1949 
1950     function distributeDividends() public payable {
1951         require(_totalSupply > 0);
1952         if (msg.value > 0) {
1953             magnifiedDividendPerShare =
1954                 magnifiedDividendPerShare +
1955                 ((msg.value * magnitude) / _totalSupply);
1956             emit DividendsDistributed(msg.sender, msg.value);
1957             totalDividendsDistributed += msg.value;
1958         }
1959     }
1960 
1961     function setBalance(address payable account, uint256 newBalance)
1962         external
1963         onlyOwner
1964     {
1965         if (excludedFromDividends[account]) {
1966             return;
1967         }
1968         if (newBalance >= minTokenBalanceForDividends) {
1969             _setBalance(account, newBalance);
1970         } else {
1971             _setBalance(account, 0);
1972         }
1973     }
1974 
1975     function excludeFromDividends(address account, bool excluded)
1976         external
1977         onlyOwner
1978     {
1979         require(
1980             excludedFromDividends[account] != excluded,
1981             "MFF_DividendTracker: account already set to requested state"
1982         );
1983         excludedFromDividends[account] = excluded;
1984         if (excluded) {
1985             _setBalance(account, 0);
1986         } else {
1987             uint256 newBalance = IERC20(tokenAddress).balanceOf(account);
1988             if (newBalance >= minTokenBalanceForDividends) {
1989                 _setBalance(account, newBalance);
1990             } else {
1991                 _setBalance(account, 0);
1992             }
1993         }
1994         emit ExcludeFromDividends(account, excluded);
1995     }
1996 
1997     function isExcludedFromDividends(address account)
1998         public
1999         view
2000         returns (bool)
2001     {
2002         return excludedFromDividends[account];
2003     }
2004 
2005     function manualSendDividend(uint256 amount, address holder)
2006         external
2007         onlyOwner
2008     {
2009         uint256 contractETHBalance = address(this).balance;
2010         payable(holder).transfer(amount > 0 ? amount : contractETHBalance);
2011     }
2012 
2013     function _setBalance(address account, uint256 newBalance) internal {
2014         uint256 currentBalance = _balances[account];
2015         if (newBalance > currentBalance) {
2016             uint256 addAmount = newBalance - currentBalance;
2017             _mint(account, addAmount);
2018         } else if (newBalance < currentBalance) {
2019             uint256 subAmount = currentBalance - newBalance;
2020             _burn(account, subAmount);
2021         }
2022     }
2023 
2024     function _mint(address account, uint256 amount) private {
2025         require(
2026             account != address(0),
2027             "MFF_DividendTracker: mint to the zero address"
2028         );
2029         _totalSupply += amount;
2030         _balances[account] += amount;
2031         emit Transfer(address(0), account, amount);
2032         magnifiedDividendCorrections[account] =
2033             magnifiedDividendCorrections[account] -
2034             int256(magnifiedDividendPerShare * amount);
2035     }
2036 
2037     function _burn(address account, uint256 amount) private {
2038         require(
2039             account != address(0),
2040             "MFF_DividendTracker: burn from the zero address"
2041         );
2042         uint256 accountBalance = _balances[account];
2043         require(
2044             accountBalance >= amount,
2045             "MFF_DividendTracker: burn amount exceeds balance"
2046         );
2047         _balances[account] = accountBalance - amount;
2048         _totalSupply -= amount;
2049         emit Transfer(account, address(0), amount);
2050         magnifiedDividendCorrections[account] =
2051             magnifiedDividendCorrections[account] +
2052             int256(magnifiedDividendPerShare * amount);
2053     }
2054 
2055     function processAccount(address payable account)
2056         public
2057         onlyOwner
2058         returns (bool)
2059     {
2060         uint256 amount = _withdrawDividendOfUser(account);
2061         if (amount > 0) {
2062             lastClaimTimes[account] = block.timestamp;
2063             emit Claim(account, amount);
2064             return true;
2065         }
2066         return false;
2067     }
2068 
2069     function _withdrawDividendOfUser(address payable account)
2070         private
2071         returns (uint256)
2072     {
2073         uint256 _withdrawableDividend = withdrawableDividendOf(account);
2074         if (_withdrawableDividend > 0) {
2075             withdrawnDividends[account] += _withdrawableDividend;
2076             totalDividendsWithdrawn += _withdrawableDividend;
2077             emit DividendWithdrawn(account, _withdrawableDividend);
2078             (bool success, ) = account.call{
2079                 value: _withdrawableDividend,
2080                 gas: 3000
2081             }("");
2082             if (!success) {
2083                 withdrawnDividends[account] -= _withdrawableDividend;
2084                 totalDividendsWithdrawn -= _withdrawableDividend;
2085                 return 0;
2086             }
2087             return _withdrawableDividend;
2088         }
2089         return 0;
2090     }
2091 
2092     function compoundAccount(address payable account)
2093         public
2094         onlyOwner
2095         returns (bool)
2096     {
2097         (uint256 amount, uint256 tokens) = _compoundDividendOfUser(account);
2098         if (amount > 0) {
2099             lastClaimTimes[account] = block.timestamp;
2100             emit Compound(account, amount, tokens);
2101             return true;
2102         }
2103         return false;
2104     }
2105 
2106     function _compoundDividendOfUser(address payable account)
2107         private
2108         returns (uint256, uint256)
2109     {
2110         uint256 _withdrawableDividend = withdrawableDividendOf(account);
2111         if (_withdrawableDividend > 0) {
2112             withdrawnDividends[account] += _withdrawableDividend;
2113             totalDividendsWithdrawn += _withdrawableDividend;
2114             emit DividendWithdrawn(account, _withdrawableDividend);
2115 
2116             IUniswapV2Router02 uniswapV2Router = IUniswapV2Router02(
2117                 UNISWAPROUTER
2118             );
2119 
2120             address[] memory path = new address[](2);
2121             path[0] = uniswapV2Router.WETH();
2122             path[1] = address(tokenAddress);
2123 
2124             bool success;
2125             uint256 tokens;
2126 
2127             uint256 initTokenBal = IERC20(tokenAddress).balanceOf(account);
2128             try
2129                 uniswapV2Router
2130                     .swapExactETHForTokensSupportingFeeOnTransferTokens{
2131                     value: _withdrawableDividend
2132                 }(0, path, address(account), block.timestamp)
2133             {
2134                 success = true;
2135                 tokens = IERC20(tokenAddress).balanceOf(account) - initTokenBal;
2136             } catch Error(
2137                 string memory /*err*/
2138             ) {
2139                 success = false;
2140             }
2141 
2142             if (!success) {
2143                 withdrawnDividends[account] -= _withdrawableDividend;
2144                 totalDividendsWithdrawn -= _withdrawableDividend;
2145                 return (0, 0);
2146             }
2147 
2148             return (_withdrawableDividend, tokens);
2149         }
2150         return (0, 0);
2151     }
2152 
2153     function withdrawableDividendOf(address account)
2154         public
2155         view
2156         returns (uint256)
2157     {
2158         return accumulativeDividendOf(account) - withdrawnDividends[account];
2159     }
2160 
2161     function withdrawnDividendOf(address account)
2162         public
2163         view
2164         returns (uint256)
2165     {
2166         return withdrawnDividends[account];
2167     }
2168 
2169     function accumulativeDividendOf(address account)
2170         public
2171         view
2172         returns (uint256)
2173     {
2174         int256 a = int256(magnifiedDividendPerShare * balanceOf(account));
2175         int256 b = magnifiedDividendCorrections[account]; // this is an explicit int256 (signed)
2176         return uint256(a + b) / magnitude;
2177     }
2178 
2179     function getAccountInfo(address account)
2180         public
2181         view
2182         returns (
2183             address,
2184             uint256,
2185             uint256,
2186             uint256,
2187             uint256
2188         )
2189     {
2190         AccountInfo memory info;
2191         info.account = account;
2192         info.withdrawableDividends = withdrawableDividendOf(account);
2193         info.totalDividends = accumulativeDividendOf(account);
2194         info.lastClaimTime = lastClaimTimes[account];
2195         return (
2196             info.account,
2197             info.withdrawableDividends,
2198             info.totalDividends,
2199             info.lastClaimTime,
2200             totalDividendsWithdrawn
2201         );
2202     }
2203 
2204     function getLastClaimTime(address account) public view returns (uint256) {
2205         return lastClaimTimes[account];
2206     }
2207 
2208     function name() public view returns (string memory) {
2209         return _name;
2210     }
2211 
2212     function symbol() public view returns (string memory) {
2213         return _symbol;
2214     }
2215 
2216     function decimals() public pure returns (uint8) {
2217         return 18;
2218     }
2219 
2220     function totalSupply() public view override returns (uint256) {
2221         return _totalSupply;
2222     }
2223 
2224     function balanceOf(address account) public view override returns (uint256) {
2225         return _balances[account];
2226     }
2227 
2228     function transfer(address, uint256) public pure override returns (bool) {
2229         revert("MFF_DividendTracker: method not implemented");
2230     }
2231 
2232     function allowance(address, address)
2233         public
2234         pure
2235         override
2236         returns (uint256)
2237     {
2238         revert("MFF_DividendTracker: method not implemented");
2239     }
2240 
2241     function approve(address, uint256) public pure override returns (bool) {
2242         revert("MFF_DividendTracker: method not implemented");
2243     }
2244 
2245     function transferFrom(
2246         address,
2247         address,
2248         uint256
2249     ) public pure override returns (bool) {
2250         revert("MFF_DividendTracker: method not implemented");
2251     }
2252 }