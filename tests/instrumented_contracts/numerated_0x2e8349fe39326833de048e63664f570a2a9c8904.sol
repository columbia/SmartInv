1 // File: openzeppelin-solidity/contracts/utils/math/SafeMath.sol
2 
3 
4 
5 pragma solidity ^0.8.0;
6 
7 // CAUTION
8 // This version of SafeMath should only be used with Solidity 0.8 or later,
9 // because it relies on the compiler's built in overflow checks.
10 
11 /**
12  * @dev Wrappers over Solidity's arithmetic operations.
13  *
14  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
15  * now has built in overflow checking.
16  */
17 library SafeMath {
18     /**
19      * @dev Returns the addition of two unsigned integers, with an overflow flag.
20      *
21      * _Available since v3.4._
22      */
23     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
24         unchecked {
25             uint256 c = a + b;
26             if (c < a) return (false, 0);
27             return (true, c);
28         }
29     }
30 
31     /**
32      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
33      *
34      * _Available since v3.4._
35      */
36     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
37         unchecked {
38             if (b > a) return (false, 0);
39             return (true, a - b);
40         }
41     }
42 
43     /**
44      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
45      *
46      * _Available since v3.4._
47      */
48     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
49         unchecked {
50             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
51             // benefit is lost if 'b' is also tested.
52             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
53             if (a == 0) return (true, 0);
54             uint256 c = a * b;
55             if (c / a != b) return (false, 0);
56             return (true, c);
57         }
58     }
59 
60     /**
61      * @dev Returns the division of two unsigned integers, with a division by zero flag.
62      *
63      * _Available since v3.4._
64      */
65     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
66         unchecked {
67             if (b == 0) return (false, 0);
68             return (true, a / b);
69         }
70     }
71 
72     /**
73      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
74      *
75      * _Available since v3.4._
76      */
77     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
78         unchecked {
79             if (b == 0) return (false, 0);
80             return (true, a % b);
81         }
82     }
83 
84     /**
85      * @dev Returns the addition of two unsigned integers, reverting on
86      * overflow.
87      *
88      * Counterpart to Solidity's `+` operator.
89      *
90      * Requirements:
91      *
92      * - Addition cannot overflow.
93      */
94     function add(uint256 a, uint256 b) internal pure returns (uint256) {
95         return a + b;
96     }
97 
98     /**
99      * @dev Returns the subtraction of two unsigned integers, reverting on
100      * overflow (when the result is negative).
101      *
102      * Counterpart to Solidity's `-` operator.
103      *
104      * Requirements:
105      *
106      * - Subtraction cannot overflow.
107      */
108     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
109         return a - b;
110     }
111 
112     /**
113      * @dev Returns the multiplication of two unsigned integers, reverting on
114      * overflow.
115      *
116      * Counterpart to Solidity's `*` operator.
117      *
118      * Requirements:
119      *
120      * - Multiplication cannot overflow.
121      */
122     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
123         return a * b;
124     }
125 
126     /**
127      * @dev Returns the integer division of two unsigned integers, reverting on
128      * division by zero. The result is rounded towards zero.
129      *
130      * Counterpart to Solidity's `/` operator.
131      *
132      * Requirements:
133      *
134      * - The divisor cannot be zero.
135      */
136     function div(uint256 a, uint256 b) internal pure returns (uint256) {
137         return a / b;
138     }
139 
140     /**
141      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
142      * reverting when dividing by zero.
143      *
144      * Counterpart to Solidity's `%` operator. This function uses a `revert`
145      * opcode (which leaves remaining gas untouched) while Solidity uses an
146      * invalid opcode to revert (consuming all remaining gas).
147      *
148      * Requirements:
149      *
150      * - The divisor cannot be zero.
151      */
152     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
153         return a % b;
154     }
155 
156     /**
157      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
158      * overflow (when the result is negative).
159      *
160      * CAUTION: This function is deprecated because it requires allocating memory for the error
161      * message unnecessarily. For custom revert reasons use {trySub}.
162      *
163      * Counterpart to Solidity's `-` operator.
164      *
165      * Requirements:
166      *
167      * - Subtraction cannot overflow.
168      */
169     function sub(
170         uint256 a,
171         uint256 b,
172         string memory errorMessage
173     ) internal pure returns (uint256) {
174         unchecked {
175             require(b <= a, errorMessage);
176             return a - b;
177         }
178     }
179 
180     /**
181      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
182      * division by zero. The result is rounded towards zero.
183      *
184      * Counterpart to Solidity's `/` operator. Note: this function uses a
185      * `revert` opcode (which leaves remaining gas untouched) while Solidity
186      * uses an invalid opcode to revert (consuming all remaining gas).
187      *
188      * Requirements:
189      *
190      * - The divisor cannot be zero.
191      */
192     function div(
193         uint256 a,
194         uint256 b,
195         string memory errorMessage
196     ) internal pure returns (uint256) {
197         unchecked {
198             require(b > 0, errorMessage);
199             return a / b;
200         }
201     }
202 
203     /**
204      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
205      * reverting with custom message when dividing by zero.
206      *
207      * CAUTION: This function is deprecated because it requires allocating memory for the error
208      * message unnecessarily. For custom revert reasons use {tryMod}.
209      *
210      * Counterpart to Solidity's `%` operator. This function uses a `revert`
211      * opcode (which leaves remaining gas untouched) while Solidity uses an
212      * invalid opcode to revert (consuming all remaining gas).
213      *
214      * Requirements:
215      *
216      * - The divisor cannot be zero.
217      */
218     function mod(
219         uint256 a,
220         uint256 b,
221         string memory errorMessage
222     ) internal pure returns (uint256) {
223         unchecked {
224             require(b > 0, errorMessage);
225             return a % b;
226         }
227     }
228 }
229 
230 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/IERC20.sol
231 
232 
233 // OpenZeppelin Contracts v4.3.2 (token/ERC20/IERC20.sol)
234 
235 pragma solidity ^0.8.0;
236 
237 /**
238  * @dev Interface of the ERC20 standard as defined in the EIP.
239  */
240 interface IERC20 {
241     /**
242      * @dev Returns the amount of tokens in existence.
243      */
244     function totalSupply() external view returns (uint256);
245 
246     /**
247      * @dev Returns the amount of tokens owned by `account`.
248      */
249     function balanceOf(address account) external view returns (uint256);
250 
251     /**
252      * @dev Moves `amount` tokens from the caller's account to `recipient`.
253      *
254      * Returns a boolean value indicating whether the operation succeeded.
255      *
256      * Emits a {Transfer} event.
257      */
258     function transfer(address recipient, uint256 amount) external returns (bool);
259 
260     /**
261      * @dev Returns the remaining number of tokens that `spender` will be
262      * allowed to spend on behalf of `owner` through {transferFrom}. This is
263      * zero by default.
264      *
265      * This value changes when {approve} or {transferFrom} are called.
266      */
267     function allowance(address owner, address spender) external view returns (uint256);
268 
269     /**
270      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
271      *
272      * Returns a boolean value indicating whether the operation succeeded.
273      *
274      * IMPORTANT: Beware that changing an allowance with this method brings the risk
275      * that someone may use both the old and the new allowance by unfortunate
276      * transaction ordering. One possible solution to mitigate this race
277      * condition is to first reduce the spender's allowance to 0 and set the
278      * desired value afterwards:
279      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
280      *
281      * Emits an {Approval} event.
282      */
283     function approve(address spender, uint256 amount) external returns (bool);
284 
285     /**
286      * @dev Moves `amount` tokens from `sender` to `recipient` using the
287      * allowance mechanism. `amount` is then deducted from the caller's
288      * allowance.
289      *
290      * Returns a boolean value indicating whether the operation succeeded.
291      *
292      * Emits a {Transfer} event.
293      */
294     function transferFrom(
295         address sender,
296         address recipient,
297         uint256 amount
298     ) external returns (bool);
299 
300     /**
301      * @dev Emitted when `value` tokens are moved from one account (`from`) to
302      * another (`to`).
303      *
304      * Note that `value` may be zero.
305      */
306     event Transfer(address indexed from, address indexed to, uint256 value);
307 
308     /**
309      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
310      * a call to {approve}. `value` is the new allowance.
311      */
312     event Approval(address indexed owner, address indexed spender, uint256 value);
313 }
314 
315 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/extensions/IERC20Metadata.sol
316 
317 
318 // OpenZeppelin Contracts v4.3.2 (token/ERC20/extensions/IERC20Metadata.sol)
319 
320 pragma solidity ^0.8.0;
321 
322 
323 /**
324  * @dev Interface for the optional metadata functions from the ERC20 standard.
325  *
326  * _Available since v4.1._
327  */
328 interface IERC20Metadata is IERC20 {
329     /**
330      * @dev Returns the name of the token.
331      */
332     function name() external view returns (string memory);
333 
334     /**
335      * @dev Returns the symbol of the token.
336      */
337     function symbol() external view returns (string memory);
338 
339     /**
340      * @dev Returns the decimals places of the token.
341      */
342     function decimals() external view returns (uint8);
343 }
344 
345 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Strings.sol
346 
347 
348 // OpenZeppelin Contracts v4.3.2 (utils/Strings.sol)
349 
350 pragma solidity ^0.8.0;
351 
352 /**
353  * @dev String operations.
354  */
355 library Strings {
356     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
357 
358     /**
359      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
360      */
361     function toString(uint256 value) internal pure returns (string memory) {
362         // Inspired by OraclizeAPI's implementation - MIT licence
363         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
364 
365         if (value == 0) {
366             return "0";
367         }
368         uint256 temp = value;
369         uint256 digits;
370         while (temp != 0) {
371             digits++;
372             temp /= 10;
373         }
374         bytes memory buffer = new bytes(digits);
375         while (value != 0) {
376             digits -= 1;
377             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
378             value /= 10;
379         }
380         return string(buffer);
381     }
382 
383     /**
384      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
385      */
386     function toHexString(uint256 value) internal pure returns (string memory) {
387         if (value == 0) {
388             return "0x00";
389         }
390         uint256 temp = value;
391         uint256 length = 0;
392         while (temp != 0) {
393             length++;
394             temp >>= 8;
395         }
396         return toHexString(value, length);
397     }
398 
399     /**
400      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
401      */
402     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
403         bytes memory buffer = new bytes(2 * length + 2);
404         buffer[0] = "0";
405         buffer[1] = "x";
406         for (uint256 i = 2 * length + 1; i > 1; --i) {
407             buffer[i] = _HEX_SYMBOLS[value & 0xf];
408             value >>= 4;
409         }
410         require(value == 0, "Strings: hex length insufficient");
411         return string(buffer);
412     }
413 }
414 
415 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Context.sol
416 
417 
418 // OpenZeppelin Contracts v4.3.2 (utils/Context.sol)
419 
420 pragma solidity ^0.8.0;
421 
422 /**
423  * @dev Provides information about the current execution context, including the
424  * sender of the transaction and its data. While these are generally available
425  * via msg.sender and msg.data, they should not be accessed in such a direct
426  * manner, since when dealing with meta-transactions the account sending and
427  * paying for execution may not be the actual sender (as far as an application
428  * is concerned).
429  *
430  * This contract is only required for intermediate, library-like contracts.
431  */
432 abstract contract Context {
433     function _msgSender() internal view virtual returns (address) {
434         return msg.sender;
435     }
436 
437     function _msgData() internal view virtual returns (bytes calldata) {
438         return msg.data;
439     }
440 }
441 
442 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/ERC20.sol
443 
444 
445 // OpenZeppelin Contracts v4.3.2 (token/ERC20/ERC20.sol)
446 
447 pragma solidity ^0.8.0;
448 
449 
450 
451 
452 /**
453  * @dev Implementation of the {IERC20} interface.
454  *
455  * This implementation is agnostic to the way tokens are created. This means
456  * that a supply mechanism has to be added in a derived contract using {_mint}.
457  * For a generic mechanism see {ERC20PresetMinterPauser}.
458  *
459  * TIP: For a detailed writeup see our guide
460  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
461  * to implement supply mechanisms].
462  *
463  * We have followed general OpenZeppelin Contracts guidelines: functions revert
464  * instead returning `false` on failure. This behavior is nonetheless
465  * conventional and does not conflict with the expectations of ERC20
466  * applications.
467  *
468  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
469  * This allows applications to reconstruct the allowance for all accounts just
470  * by listening to said events. Other implementations of the EIP may not emit
471  * these events, as it isn't required by the specification.
472  *
473  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
474  * functions have been added to mitigate the well-known issues around setting
475  * allowances. See {IERC20-approve}.
476  */
477 contract ERC20 is Context, IERC20, IERC20Metadata {
478     mapping(address => uint256) private _balances;
479 
480     mapping(address => mapping(address => uint256)) private _allowances;
481 
482     uint256 private _totalSupply;
483 
484     string private _name;
485     string private _symbol;
486 
487     /**
488      * @dev Sets the values for {name} and {symbol}.
489      *
490      * The default value of {decimals} is 18. To select a different value for
491      * {decimals} you should overload it.
492      *
493      * All two of these values are immutable: they can only be set once during
494      * construction.
495      */
496     constructor(string memory name_, string memory symbol_) {
497         _name = name_;
498         _symbol = symbol_;
499     }
500 
501     /**
502      * @dev Returns the name of the token.
503      */
504     function name() public view virtual override returns (string memory) {
505         return _name;
506     }
507 
508     /**
509      * @dev Returns the symbol of the token, usually a shorter version of the
510      * name.
511      */
512     function symbol() public view virtual override returns (string memory) {
513         return _symbol;
514     }
515 
516     /**
517      * @dev Returns the number of decimals used to get its user representation.
518      * For example, if `decimals` equals `2`, a balance of `505` tokens should
519      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
520      *
521      * Tokens usually opt for a value of 18, imitating the relationship between
522      * Ether and Wei. This is the value {ERC20} uses, unless this function is
523      * overridden;
524      *
525      * NOTE: This information is only used for _display_ purposes: it in
526      * no way affects any of the arithmetic of the contract, including
527      * {IERC20-balanceOf} and {IERC20-transfer}.
528      */
529     function decimals() public view virtual override returns (uint8) {
530         return 18;
531     }
532 
533     /**
534      * @dev See {IERC20-totalSupply}.
535      */
536     function totalSupply() public view virtual override returns (uint256) {
537         return _totalSupply;
538     }
539 
540     /**
541      * @dev See {IERC20-balanceOf}.
542      */
543     function balanceOf(address account) public view virtual override returns (uint256) {
544         return _balances[account];
545     }
546 
547     /**
548      * @dev See {IERC20-transfer}.
549      *
550      * Requirements:
551      *
552      * - `recipient` cannot be the zero address.
553      * - the caller must have a balance of at least `amount`.
554      */
555     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
556         _transfer(_msgSender(), recipient, amount);
557         return true;
558     }
559 
560     /**
561      * @dev See {IERC20-allowance}.
562      */
563     function allowance(address owner, address spender) public view virtual override returns (uint256) {
564         return _allowances[owner][spender];
565     }
566 
567     /**
568      * @dev See {IERC20-approve}.
569      *
570      * Requirements:
571      *
572      * - `spender` cannot be the zero address.
573      */
574     function approve(address spender, uint256 amount) public virtual override returns (bool) {
575         _approve(_msgSender(), spender, amount);
576         return true;
577     }
578 
579     /**
580      * @dev See {IERC20-transferFrom}.
581      *
582      * Emits an {Approval} event indicating the updated allowance. This is not
583      * required by the EIP. See the note at the beginning of {ERC20}.
584      *
585      * Requirements:
586      *
587      * - `sender` and `recipient` cannot be the zero address.
588      * - `sender` must have a balance of at least `amount`.
589      * - the caller must have allowance for ``sender``'s tokens of at least
590      * `amount`.
591      */
592     function transferFrom(
593         address sender,
594         address recipient,
595         uint256 amount
596     ) public virtual override returns (bool) {
597         _transfer(sender, recipient, amount);
598 
599         uint256 currentAllowance = _allowances[sender][_msgSender()];
600         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
601         unchecked {
602             _approve(sender, _msgSender(), currentAllowance - amount);
603         }
604 
605         return true;
606     }
607 
608     /**
609      * @dev Atomically increases the allowance granted to `spender` by the caller.
610      *
611      * This is an alternative to {approve} that can be used as a mitigation for
612      * problems described in {IERC20-approve}.
613      *
614      * Emits an {Approval} event indicating the updated allowance.
615      *
616      * Requirements:
617      *
618      * - `spender` cannot be the zero address.
619      */
620     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
621         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
622         return true;
623     }
624 
625     /**
626      * @dev Atomically decreases the allowance granted to `spender` by the caller.
627      *
628      * This is an alternative to {approve} that can be used as a mitigation for
629      * problems described in {IERC20-approve}.
630      *
631      * Emits an {Approval} event indicating the updated allowance.
632      *
633      * Requirements:
634      *
635      * - `spender` cannot be the zero address.
636      * - `spender` must have allowance for the caller of at least
637      * `subtractedValue`.
638      */
639     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
640         uint256 currentAllowance = _allowances[_msgSender()][spender];
641         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
642         unchecked {
643             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
644         }
645 
646         return true;
647     }
648 
649     /**
650      * @dev Moves `amount` of tokens from `sender` to `recipient`.
651      *
652      * This internal function is equivalent to {transfer}, and can be used to
653      * e.g. implement automatic token fees, slashing mechanisms, etc.
654      *
655      * Emits a {Transfer} event.
656      *
657      * Requirements:
658      *
659      * - `sender` cannot be the zero address.
660      * - `recipient` cannot be the zero address.
661      * - `sender` must have a balance of at least `amount`.
662      */
663     function _transfer(
664         address sender,
665         address recipient,
666         uint256 amount
667     ) internal virtual {
668         require(sender != address(0), "ERC20: transfer from the zero address");
669         require(recipient != address(0), "ERC20: transfer to the zero address");
670 
671         _beforeTokenTransfer(sender, recipient, amount);
672 
673         uint256 senderBalance = _balances[sender];
674         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
675         unchecked {
676             _balances[sender] = senderBalance - amount;
677         }
678         _balances[recipient] += amount;
679 
680         emit Transfer(sender, recipient, amount);
681 
682         _afterTokenTransfer(sender, recipient, amount);
683     }
684 
685     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
686      * the total supply.
687      *
688      * Emits a {Transfer} event with `from` set to the zero address.
689      *
690      * Requirements:
691      *
692      * - `account` cannot be the zero address.
693      */
694     function _mint(address account, uint256 amount) internal virtual {
695         require(account != address(0), "ERC20: mint to the zero address");
696 
697         _beforeTokenTransfer(address(0), account, amount);
698 
699         _totalSupply += amount;
700         _balances[account] += amount;
701         emit Transfer(address(0), account, amount);
702 
703         _afterTokenTransfer(address(0), account, amount);
704     }
705 
706     /**
707      * @dev Destroys `amount` tokens from `account`, reducing the
708      * total supply.
709      *
710      * Emits a {Transfer} event with `to` set to the zero address.
711      *
712      * Requirements:
713      *
714      * - `account` cannot be the zero address.
715      * - `account` must have at least `amount` tokens.
716      */
717     function _burn(address account, uint256 amount) internal virtual {
718         require(account != address(0), "ERC20: burn from the zero address");
719 
720         _beforeTokenTransfer(account, address(0), amount);
721 
722         uint256 accountBalance = _balances[account];
723         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
724         unchecked {
725             _balances[account] = accountBalance - amount;
726         }
727         _totalSupply -= amount;
728 
729         emit Transfer(account, address(0), amount);
730 
731         _afterTokenTransfer(account, address(0), amount);
732     }
733 
734     /**
735      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
736      *
737      * This internal function is equivalent to `approve`, and can be used to
738      * e.g. set automatic allowances for certain subsystems, etc.
739      *
740      * Emits an {Approval} event.
741      *
742      * Requirements:
743      *
744      * - `owner` cannot be the zero address.
745      * - `spender` cannot be the zero address.
746      */
747     function _approve(
748         address owner,
749         address spender,
750         uint256 amount
751     ) internal virtual {
752         require(owner != address(0), "ERC20: approve from the zero address");
753         require(spender != address(0), "ERC20: approve to the zero address");
754 
755         _allowances[owner][spender] = amount;
756         emit Approval(owner, spender, amount);
757     }
758 
759     /**
760      * @dev Hook that is called before any transfer of tokens. This includes
761      * minting and burning.
762      *
763      * Calling conditions:
764      *
765      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
766      * will be transferred to `to`.
767      * - when `from` is zero, `amount` tokens will be minted for `to`.
768      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
769      * - `from` and `to` are never both zero.
770      *
771      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
772      */
773     function _beforeTokenTransfer(
774         address from,
775         address to,
776         uint256 amount
777     ) internal virtual {}
778 
779     /**
780      * @dev Hook that is called after any transfer of tokens. This includes
781      * minting and burning.
782      *
783      * Calling conditions:
784      *
785      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
786      * has been transferred to `to`.
787      * - when `from` is zero, `amount` tokens have been minted for `to`.
788      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
789      * - `from` and `to` are never both zero.
790      *
791      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
792      */
793     function _afterTokenTransfer(
794         address from,
795         address to,
796         uint256 amount
797     ) internal virtual {}
798 }
799 
800 // File: cosmicToken.sol
801 
802 pragma solidity 0.8.7;
803 
804 
805 
806 
807 /// SPDX-License-Identifier: UNLICENSED
808 
809 interface IDuck {
810 	function balanceOG(address _user) external view returns(uint256);
811 }
812 
813 contract CosmicToken is ERC20("CosmicUtilityToken", "CUT") 
814 {
815    
816     using SafeMath for uint256;
817    
818     uint256 public totalTokensBurned = 0;
819     address[] internal stakeholders;
820     address  payable private owner;
821     
822 
823     //token Genesis per day
824     uint256 constant public GENESIS_RATE = 20 ether; 
825     
826     //token duck per day
827     uint256 constant public DUCK_RATE = 5 ether; 
828     
829     //token for  genesis minting
830 	uint256 constant public GENESIS_ISSUANCE = 280 ether;
831 	
832 	//token for duck minting
833 	uint256 constant public DUCK_ISSUANCE = 70 ether;
834 	
835 	
836 	
837 	// Tue Mar 18 2031 17:46:47 GMT+0000
838 	uint256 constant public END = 1931622407;
839 
840 	mapping(address => uint256) public rewards;
841 	mapping(address => uint256) public lastUpdate;
842 	
843 	
844     IDuck public ducksContract;
845    
846     constructor(address initDuckContract) 
847     {
848         owner = payable(msg.sender);
849         ducksContract = IDuck(initDuckContract);
850     }
851    
852 
853     function WhoOwns() public view returns (address) {
854         return owner;
855     }
856    
857     modifier Owned {
858          require(msg.sender == owner);
859          _;
860  }
861    
862     function getContractAddress() public view returns (address) {
863         return address(this);
864     }
865 
866 	function min(uint256 a, uint256 b) internal pure returns (uint256) {
867 		return a < b ? a : b;
868 	}    
869 	
870 	modifier contractAddressOnly
871     {
872          require(msg.sender == address(ducksContract));
873          _;
874     }
875     
876    	// called when minting many NFTs
877 	function updateRewardOnMint(address _user, uint256 _tokenId) external contractAddressOnly
878 	{
879 	    if(_tokenId <= 1000)
880 		{
881             _mint(_user,GENESIS_ISSUANCE);	  	        
882 		}
883 		else if(_tokenId >= 1001)
884 		{
885             _mint(_user,DUCK_ISSUANCE);	  	        	        
886 		}
887 	}
888 	
889 
890 	function getReward(address _to, uint256 totalPayout) external contractAddressOnly
891 	{
892 		_mint(_to, (totalPayout * 10 ** 18));
893 		
894 	}
895 	
896 	function burn(address _from, uint256 _amount) external 
897 	{
898 	    require(msg.sender == _from, "You do not own these tokens");
899 		_burn(_from, _amount);
900 		totalTokensBurned += _amount;
901 	}
902 
903 
904   
905    
906 }
907 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol
908 
909 
910 // OpenZeppelin Contracts v4.3.2 (access/Ownable.sol)
911 
912 pragma solidity ^0.8.0;
913 
914 
915 /**
916  * @dev Contract module which provides a basic access control mechanism, where
917  * there is an account (an owner) that can be granted exclusive access to
918  * specific functions.
919  *
920  * By default, the owner account will be the one that deploys the contract. This
921  * can later be changed with {transferOwnership}.
922  *
923  * This module is used through inheritance. It will make available the modifier
924  * `onlyOwner`, which can be applied to your functions to restrict their use to
925  * the owner.
926  */
927 abstract contract Ownable is Context {
928     address private _owner;
929 
930     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
931 
932     /**
933      * @dev Initializes the contract setting the deployer as the initial owner.
934      */
935     constructor() {
936         _transferOwnership(_msgSender());
937     }
938 
939     /**
940      * @dev Returns the address of the current owner.
941      */
942     function owner() public view virtual returns (address) {
943         return _owner;
944     }
945 
946     /**
947      * @dev Throws if called by any account other than the owner.
948      */
949     modifier onlyOwner() {
950         require(owner() == _msgSender(), "Ownable: caller is not the owner");
951         _;
952     }
953 
954     /**
955      * @dev Leaves the contract without owner. It will not be possible to call
956      * `onlyOwner` functions anymore. Can only be called by the current owner.
957      *
958      * NOTE: Renouncing ownership will leave the contract without an owner,
959      * thereby removing any functionality that is only available to the owner.
960      */
961     function renounceOwnership() public virtual onlyOwner {
962         _transferOwnership(address(0));
963     }
964 
965     /**
966      * @dev Transfers ownership of the contract to a new account (`newOwner`).
967      * Can only be called by the current owner.
968      */
969     function transferOwnership(address newOwner) public virtual onlyOwner {
970         require(newOwner != address(0), "Ownable: new owner is the zero address");
971         _transferOwnership(newOwner);
972     }
973 
974     /**
975      * @dev Transfers ownership of the contract to a new account (`newOwner`).
976      * Internal function without access restriction.
977      */
978     function _transferOwnership(address newOwner) internal virtual {
979         address oldOwner = _owner;
980         _owner = newOwner;
981         emit OwnershipTransferred(oldOwner, newOwner);
982     }
983 }
984 
985 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Address.sol
986 
987 
988 // OpenZeppelin Contracts v4.3.2 (utils/Address.sol)
989 
990 pragma solidity ^0.8.0;
991 
992 /**
993  * @dev Collection of functions related to the address type
994  */
995 library Address {
996     /**
997      * @dev Returns true if `account` is a contract.
998      *
999      * [IMPORTANT]
1000      * ====
1001      * It is unsafe to assume that an address for which this function returns
1002      * false is an externally-owned account (EOA) and not a contract.
1003      *
1004      * Among others, `isContract` will return false for the following
1005      * types of addresses:
1006      *
1007      *  - an externally-owned account
1008      *  - a contract in construction
1009      *  - an address where a contract will be created
1010      *  - an address where a contract lived, but was destroyed
1011      * ====
1012      */
1013     function isContract(address account) internal view returns (bool) {
1014         // This method relies on extcodesize, which returns 0 for contracts in
1015         // construction, since the code is only stored at the end of the
1016         // constructor execution.
1017 
1018         uint256 size;
1019         assembly {
1020             size := extcodesize(account)
1021         }
1022         return size > 0;
1023     }
1024 
1025     /**
1026      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
1027      * `recipient`, forwarding all available gas and reverting on errors.
1028      *
1029      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
1030      * of certain opcodes, possibly making contracts go over the 2300 gas limit
1031      * imposed by `transfer`, making them unable to receive funds via
1032      * `transfer`. {sendValue} removes this limitation.
1033      *
1034      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
1035      *
1036      * IMPORTANT: because control is transferred to `recipient`, care must be
1037      * taken to not create reentrancy vulnerabilities. Consider using
1038      * {ReentrancyGuard} or the
1039      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
1040      */
1041     function sendValue(address payable recipient, uint256 amount) internal {
1042         require(address(this).balance >= amount, "Address: insufficient balance");
1043 
1044         (bool success, ) = recipient.call{value: amount}("");
1045         require(success, "Address: unable to send value, recipient may have reverted");
1046     }
1047 
1048     /**
1049      * @dev Performs a Solidity function call using a low level `call`. A
1050      * plain `call` is an unsafe replacement for a function call: use this
1051      * function instead.
1052      *
1053      * If `target` reverts with a revert reason, it is bubbled up by this
1054      * function (like regular Solidity function calls).
1055      *
1056      * Returns the raw returned data. To convert to the expected return value,
1057      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
1058      *
1059      * Requirements:
1060      *
1061      * - `target` must be a contract.
1062      * - calling `target` with `data` must not revert.
1063      *
1064      * _Available since v3.1._
1065      */
1066     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
1067         return functionCall(target, data, "Address: low-level call failed");
1068     }
1069 
1070     /**
1071      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
1072      * `errorMessage` as a fallback revert reason when `target` reverts.
1073      *
1074      * _Available since v3.1._
1075      */
1076     function functionCall(
1077         address target,
1078         bytes memory data,
1079         string memory errorMessage
1080     ) internal returns (bytes memory) {
1081         return functionCallWithValue(target, data, 0, errorMessage);
1082     }
1083 
1084     /**
1085      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1086      * but also transferring `value` wei to `target`.
1087      *
1088      * Requirements:
1089      *
1090      * - the calling contract must have an ETH balance of at least `value`.
1091      * - the called Solidity function must be `payable`.
1092      *
1093      * _Available since v3.1._
1094      */
1095     function functionCallWithValue(
1096         address target,
1097         bytes memory data,
1098         uint256 value
1099     ) internal returns (bytes memory) {
1100         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
1101     }
1102 
1103     /**
1104      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
1105      * with `errorMessage` as a fallback revert reason when `target` reverts.
1106      *
1107      * _Available since v3.1._
1108      */
1109     function functionCallWithValue(
1110         address target,
1111         bytes memory data,
1112         uint256 value,
1113         string memory errorMessage
1114     ) internal returns (bytes memory) {
1115         require(address(this).balance >= value, "Address: insufficient balance for call");
1116         require(isContract(target), "Address: call to non-contract");
1117 
1118         (bool success, bytes memory returndata) = target.call{value: value}(data);
1119         return verifyCallResult(success, returndata, errorMessage);
1120     }
1121 
1122     /**
1123      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1124      * but performing a static call.
1125      *
1126      * _Available since v3.3._
1127      */
1128     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
1129         return functionStaticCall(target, data, "Address: low-level static call failed");
1130     }
1131 
1132     /**
1133      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1134      * but performing a static call.
1135      *
1136      * _Available since v3.3._
1137      */
1138     function functionStaticCall(
1139         address target,
1140         bytes memory data,
1141         string memory errorMessage
1142     ) internal view returns (bytes memory) {
1143         require(isContract(target), "Address: static call to non-contract");
1144 
1145         (bool success, bytes memory returndata) = target.staticcall(data);
1146         return verifyCallResult(success, returndata, errorMessage);
1147     }
1148 
1149     /**
1150      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1151      * but performing a delegate call.
1152      *
1153      * _Available since v3.4._
1154      */
1155     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
1156         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
1157     }
1158 
1159     /**
1160      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1161      * but performing a delegate call.
1162      *
1163      * _Available since v3.4._
1164      */
1165     function functionDelegateCall(
1166         address target,
1167         bytes memory data,
1168         string memory errorMessage
1169     ) internal returns (bytes memory) {
1170         require(isContract(target), "Address: delegate call to non-contract");
1171 
1172         (bool success, bytes memory returndata) = target.delegatecall(data);
1173         return verifyCallResult(success, returndata, errorMessage);
1174     }
1175 
1176     /**
1177      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
1178      * revert reason using the provided one.
1179      *
1180      * _Available since v4.3._
1181      */
1182     function verifyCallResult(
1183         bool success,
1184         bytes memory returndata,
1185         string memory errorMessage
1186     ) internal pure returns (bytes memory) {
1187         if (success) {
1188             return returndata;
1189         } else {
1190             // Look for revert reason and bubble it up if present
1191             if (returndata.length > 0) {
1192                 // The easiest way to bubble the revert reason is using memory via assembly
1193 
1194                 assembly {
1195                     let returndata_size := mload(returndata)
1196                     revert(add(32, returndata), returndata_size)
1197                 }
1198             } else {
1199                 revert(errorMessage);
1200             }
1201         }
1202     }
1203 }
1204 
1205 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/introspection/IERC165.sol
1206 
1207 
1208 // OpenZeppelin Contracts v4.3.2 (utils/introspection/IERC165.sol)
1209 
1210 pragma solidity ^0.8.0;
1211 
1212 /**
1213  * @dev Interface of the ERC165 standard, as defined in the
1214  * https://eips.ethereum.org/EIPS/eip-165[EIP].
1215  *
1216  * Implementers can declare support of contract interfaces, which can then be
1217  * queried by others ({ERC165Checker}).
1218  *
1219  * For an implementation, see {ERC165}.
1220  */
1221 interface IERC165 {
1222     /**
1223      * @dev Returns true if this contract implements the interface defined by
1224      * `interfaceId`. See the corresponding
1225      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
1226      * to learn more about how these ids are created.
1227      *
1228      * This function call must use less than 30 000 gas.
1229      */
1230     function supportsInterface(bytes4 interfaceId) external view returns (bool);
1231 }
1232 
1233 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/introspection/ERC165.sol
1234 
1235 
1236 // OpenZeppelin Contracts v4.3.2 (utils/introspection/ERC165.sol)
1237 
1238 pragma solidity ^0.8.0;
1239 
1240 
1241 /**
1242  * @dev Implementation of the {IERC165} interface.
1243  *
1244  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
1245  * for the additional interface id that will be supported. For example:
1246  *
1247  * ```solidity
1248  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1249  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
1250  * }
1251  * ```
1252  *
1253  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
1254  */
1255 abstract contract ERC165 is IERC165 {
1256     /**
1257      * @dev See {IERC165-supportsInterface}.
1258      */
1259     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1260         return interfaceId == type(IERC165).interfaceId;
1261     }
1262 }
1263 
1264 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC1155/IERC1155Receiver.sol
1265 
1266 
1267 // OpenZeppelin Contracts v4.3.2 (token/ERC1155/IERC1155Receiver.sol)
1268 
1269 pragma solidity ^0.8.0;
1270 
1271 
1272 /**
1273  * @dev _Available since v3.1._
1274  */
1275 interface IERC1155Receiver is IERC165 {
1276     /**
1277      * @dev Handles the receipt of a single ERC1155 token type. This function is
1278      * called at the end of a `safeTransferFrom` after the balance has been updated.
1279      *
1280      * NOTE: To accept the transfer, this must return
1281      * `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
1282      * (i.e. 0xf23a6e61, or its own function selector).
1283      *
1284      * @param operator The address which initiated the transfer (i.e. msg.sender)
1285      * @param from The address which previously owned the token
1286      * @param id The ID of the token being transferred
1287      * @param value The amount of tokens being transferred
1288      * @param data Additional data with no specified format
1289      * @return `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))` if transfer is allowed
1290      */
1291     function onERC1155Received(
1292         address operator,
1293         address from,
1294         uint256 id,
1295         uint256 value,
1296         bytes calldata data
1297     ) external returns (bytes4);
1298 
1299     /**
1300      * @dev Handles the receipt of a multiple ERC1155 token types. This function
1301      * is called at the end of a `safeBatchTransferFrom` after the balances have
1302      * been updated.
1303      *
1304      * NOTE: To accept the transfer(s), this must return
1305      * `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
1306      * (i.e. 0xbc197c81, or its own function selector).
1307      *
1308      * @param operator The address which initiated the batch transfer (i.e. msg.sender)
1309      * @param from The address which previously owned the token
1310      * @param ids An array containing ids of each token being transferred (order and length must match values array)
1311      * @param values An array containing amounts of each token being transferred (order and length must match ids array)
1312      * @param data Additional data with no specified format
1313      * @return `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))` if transfer is allowed
1314      */
1315     function onERC1155BatchReceived(
1316         address operator,
1317         address from,
1318         uint256[] calldata ids,
1319         uint256[] calldata values,
1320         bytes calldata data
1321     ) external returns (bytes4);
1322 }
1323 
1324 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC1155/IERC1155.sol
1325 
1326 
1327 // OpenZeppelin Contracts v4.3.2 (token/ERC1155/IERC1155.sol)
1328 
1329 pragma solidity ^0.8.0;
1330 
1331 
1332 /**
1333  * @dev Required interface of an ERC1155 compliant contract, as defined in the
1334  * https://eips.ethereum.org/EIPS/eip-1155[EIP].
1335  *
1336  * _Available since v3.1._
1337  */
1338 interface IERC1155 is IERC165 {
1339     /**
1340      * @dev Emitted when `value` tokens of token type `id` are transferred from `from` to `to` by `operator`.
1341      */
1342     event TransferSingle(address indexed operator, address indexed from, address indexed to, uint256 id, uint256 value);
1343 
1344     /**
1345      * @dev Equivalent to multiple {TransferSingle} events, where `operator`, `from` and `to` are the same for all
1346      * transfers.
1347      */
1348     event TransferBatch(
1349         address indexed operator,
1350         address indexed from,
1351         address indexed to,
1352         uint256[] ids,
1353         uint256[] values
1354     );
1355 
1356     /**
1357      * @dev Emitted when `account` grants or revokes permission to `operator` to transfer their tokens, according to
1358      * `approved`.
1359      */
1360     event ApprovalForAll(address indexed account, address indexed operator, bool approved);
1361 
1362     /**
1363      * @dev Emitted when the URI for token type `id` changes to `value`, if it is a non-programmatic URI.
1364      *
1365      * If an {URI} event was emitted for `id`, the standard
1366      * https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[guarantees] that `value` will equal the value
1367      * returned by {IERC1155MetadataURI-uri}.
1368      */
1369     event URI(string value, uint256 indexed id);
1370 
1371     /**
1372      * @dev Returns the amount of tokens of token type `id` owned by `account`.
1373      *
1374      * Requirements:
1375      *
1376      * - `account` cannot be the zero address.
1377      */
1378     function balanceOf(address account, uint256 id) external view returns (uint256);
1379 
1380     /**
1381      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {balanceOf}.
1382      *
1383      * Requirements:
1384      *
1385      * - `accounts` and `ids` must have the same length.
1386      */
1387     function balanceOfBatch(address[] calldata accounts, uint256[] calldata ids)
1388         external
1389         view
1390         returns (uint256[] memory);
1391 
1392     /**
1393      * @dev Grants or revokes permission to `operator` to transfer the caller's tokens, according to `approved`,
1394      *
1395      * Emits an {ApprovalForAll} event.
1396      *
1397      * Requirements:
1398      *
1399      * - `operator` cannot be the caller.
1400      */
1401     function setApprovalForAll(address operator, bool approved) external;
1402 
1403     /**
1404      * @dev Returns true if `operator` is approved to transfer ``account``'s tokens.
1405      *
1406      * See {setApprovalForAll}.
1407      */
1408     function isApprovedForAll(address account, address operator) external view returns (bool);
1409 
1410     /**
1411      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
1412      *
1413      * Emits a {TransferSingle} event.
1414      *
1415      * Requirements:
1416      *
1417      * - `to` cannot be the zero address.
1418      * - If the caller is not `from`, it must be have been approved to spend ``from``'s tokens via {setApprovalForAll}.
1419      * - `from` must have a balance of tokens of type `id` of at least `amount`.
1420      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
1421      * acceptance magic value.
1422      */
1423     function safeTransferFrom(
1424         address from,
1425         address to,
1426         uint256 id,
1427         uint256 amount,
1428         bytes calldata data
1429     ) external;
1430 
1431     /**
1432      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {safeTransferFrom}.
1433      *
1434      * Emits a {TransferBatch} event.
1435      *
1436      * Requirements:
1437      *
1438      * - `ids` and `amounts` must have the same length.
1439      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
1440      * acceptance magic value.
1441      */
1442     function safeBatchTransferFrom(
1443         address from,
1444         address to,
1445         uint256[] calldata ids,
1446         uint256[] calldata amounts,
1447         bytes calldata data
1448     ) external;
1449 }
1450 
1451 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC1155/extensions/IERC1155MetadataURI.sol
1452 
1453 
1454 // OpenZeppelin Contracts v4.3.2 (token/ERC1155/extensions/IERC1155MetadataURI.sol)
1455 
1456 pragma solidity ^0.8.0;
1457 
1458 
1459 /**
1460  * @dev Interface of the optional ERC1155MetadataExtension interface, as defined
1461  * in the https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[EIP].
1462  *
1463  * _Available since v3.1._
1464  */
1465 interface IERC1155MetadataURI is IERC1155 {
1466     /**
1467      * @dev Returns the URI for token type `id`.
1468      *
1469      * If the `\{id\}` substring is present in the URI, it must be replaced by
1470      * clients with the actual token type ID.
1471      */
1472     function uri(uint256 id) external view returns (string memory);
1473 }
1474 
1475 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC1155/ERC1155.sol
1476 
1477 
1478 // OpenZeppelin Contracts v4.3.2 (token/ERC1155/ERC1155.sol)
1479 
1480 pragma solidity ^0.8.0;
1481 
1482 
1483 
1484 
1485 
1486 
1487 
1488 /**
1489  * @dev Implementation of the basic standard multi-token.
1490  * See https://eips.ethereum.org/EIPS/eip-1155
1491  * Originally based on code by Enjin: https://github.com/enjin/erc-1155
1492  *
1493  * _Available since v3.1._
1494  */
1495 contract ERC1155 is Context, ERC165, IERC1155, IERC1155MetadataURI {
1496     using Address for address;
1497 
1498     // Mapping from token ID to account balances
1499     mapping(uint256 => mapping(address => uint256)) private _balances;
1500 
1501     // Mapping from account to operator approvals
1502     mapping(address => mapping(address => bool)) private _operatorApprovals;
1503 
1504     // Used as the URI for all token types by relying on ID substitution, e.g. https://token-cdn-domain/{id}.json
1505     string private _uri;
1506 
1507     /**
1508      * @dev See {_setURI}.
1509      */
1510     constructor(string memory uri_) {
1511         _setURI(uri_);
1512     }
1513 
1514     /**
1515      * @dev See {IERC165-supportsInterface}.
1516      */
1517     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1518         return
1519             interfaceId == type(IERC1155).interfaceId ||
1520             interfaceId == type(IERC1155MetadataURI).interfaceId ||
1521             super.supportsInterface(interfaceId);
1522     }
1523 
1524     /**
1525      * @dev See {IERC1155MetadataURI-uri}.
1526      *
1527      * This implementation returns the same URI for *all* token types. It relies
1528      * on the token type ID substitution mechanism
1529      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
1530      *
1531      * Clients calling this function must replace the `\{id\}` substring with the
1532      * actual token type ID.
1533      */
1534     function uri(uint256) public view virtual override returns (string memory) {
1535         return _uri;
1536     }
1537 
1538     /**
1539      * @dev See {IERC1155-balanceOf}.
1540      *
1541      * Requirements:
1542      *
1543      * - `account` cannot be the zero address.
1544      */
1545     function balanceOf(address account, uint256 id) public view virtual override returns (uint256) {
1546         require(account != address(0), "ERC1155: balance query for the zero address");
1547         return _balances[id][account];
1548     }
1549 
1550     /**
1551      * @dev See {IERC1155-balanceOfBatch}.
1552      *
1553      * Requirements:
1554      *
1555      * - `accounts` and `ids` must have the same length.
1556      */
1557     function balanceOfBatch(address[] memory accounts, uint256[] memory ids)
1558         public
1559         view
1560         virtual
1561         override
1562         returns (uint256[] memory)
1563     {
1564         require(accounts.length == ids.length, "ERC1155: accounts and ids length mismatch");
1565 
1566         uint256[] memory batchBalances = new uint256[](accounts.length);
1567 
1568         for (uint256 i = 0; i < accounts.length; ++i) {
1569             batchBalances[i] = balanceOf(accounts[i], ids[i]);
1570         }
1571 
1572         return batchBalances;
1573     }
1574 
1575     /**
1576      * @dev See {IERC1155-setApprovalForAll}.
1577      */
1578     function setApprovalForAll(address operator, bool approved) public virtual override {
1579         _setApprovalForAll(_msgSender(), operator, approved);
1580     }
1581 
1582     /**
1583      * @dev See {IERC1155-isApprovedForAll}.
1584      */
1585     function isApprovedForAll(address account, address operator) public view virtual override returns (bool) {
1586         return _operatorApprovals[account][operator];
1587     }
1588 
1589     /**
1590      * @dev See {IERC1155-safeTransferFrom}.
1591      */
1592     function safeTransferFrom(
1593         address from,
1594         address to,
1595         uint256 id,
1596         uint256 amount,
1597         bytes memory data
1598     ) public virtual override {
1599         require(
1600             from == _msgSender() || isApprovedForAll(from, _msgSender()),
1601             "ERC1155: caller is not owner nor approved"
1602         );
1603         _safeTransferFrom(from, to, id, amount, data);
1604     }
1605 
1606     /**
1607      * @dev See {IERC1155-safeBatchTransferFrom}.
1608      */
1609     function safeBatchTransferFrom(
1610         address from,
1611         address to,
1612         uint256[] memory ids,
1613         uint256[] memory amounts,
1614         bytes memory data
1615     ) public virtual override {
1616         require(
1617             from == _msgSender() || isApprovedForAll(from, _msgSender()),
1618             "ERC1155: transfer caller is not owner nor approved"
1619         );
1620         _safeBatchTransferFrom(from, to, ids, amounts, data);
1621     }
1622 
1623     /**
1624      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
1625      *
1626      * Emits a {TransferSingle} event.
1627      *
1628      * Requirements:
1629      *
1630      * - `to` cannot be the zero address.
1631      * - `from` must have a balance of tokens of type `id` of at least `amount`.
1632      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
1633      * acceptance magic value.
1634      */
1635     function _safeTransferFrom(
1636         address from,
1637         address to,
1638         uint256 id,
1639         uint256 amount,
1640         bytes memory data
1641     ) internal virtual {
1642         require(to != address(0), "ERC1155: transfer to the zero address");
1643 
1644         address operator = _msgSender();
1645 
1646         _beforeTokenTransfer(operator, from, to, _asSingletonArray(id), _asSingletonArray(amount), data);
1647 
1648         uint256 fromBalance = _balances[id][from];
1649         require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
1650         unchecked {
1651             _balances[id][from] = fromBalance - amount;
1652         }
1653         _balances[id][to] += amount;
1654 
1655         emit TransferSingle(operator, from, to, id, amount);
1656 
1657         _doSafeTransferAcceptanceCheck(operator, from, to, id, amount, data);
1658     }
1659 
1660     /**
1661      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_safeTransferFrom}.
1662      *
1663      * Emits a {TransferBatch} event.
1664      *
1665      * Requirements:
1666      *
1667      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
1668      * acceptance magic value.
1669      */
1670     function _safeBatchTransferFrom(
1671         address from,
1672         address to,
1673         uint256[] memory ids,
1674         uint256[] memory amounts,
1675         bytes memory data
1676     ) internal virtual {
1677         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
1678         require(to != address(0), "ERC1155: transfer to the zero address");
1679 
1680         address operator = _msgSender();
1681 
1682         _beforeTokenTransfer(operator, from, to, ids, amounts, data);
1683 
1684         for (uint256 i = 0; i < ids.length; ++i) {
1685             uint256 id = ids[i];
1686             uint256 amount = amounts[i];
1687 
1688             uint256 fromBalance = _balances[id][from];
1689             require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
1690             unchecked {
1691                 _balances[id][from] = fromBalance - amount;
1692             }
1693             _balances[id][to] += amount;
1694         }
1695 
1696         emit TransferBatch(operator, from, to, ids, amounts);
1697 
1698         _doSafeBatchTransferAcceptanceCheck(operator, from, to, ids, amounts, data);
1699     }
1700 
1701     /**
1702      * @dev Sets a new URI for all token types, by relying on the token type ID
1703      * substitution mechanism
1704      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
1705      *
1706      * By this mechanism, any occurrence of the `\{id\}` substring in either the
1707      * URI or any of the amounts in the JSON file at said URI will be replaced by
1708      * clients with the token type ID.
1709      *
1710      * For example, the `https://token-cdn-domain/\{id\}.json` URI would be
1711      * interpreted by clients as
1712      * `https://token-cdn-domain/000000000000000000000000000000000000000000000000000000000004cce0.json`
1713      * for token type ID 0x4cce0.
1714      *
1715      * See {uri}.
1716      *
1717      * Because these URIs cannot be meaningfully represented by the {URI} event,
1718      * this function emits no events.
1719      */
1720     function _setURI(string memory newuri) internal virtual {
1721         _uri = newuri;
1722     }
1723 
1724     /**
1725      * @dev Creates `amount` tokens of token type `id`, and assigns them to `to`.
1726      *
1727      * Emits a {TransferSingle} event.
1728      *
1729      * Requirements:
1730      *
1731      * - `to` cannot be the zero address.
1732      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
1733      * acceptance magic value.
1734      */
1735     function _mint(
1736         address to,
1737         uint256 id,
1738         uint256 amount,
1739         bytes memory data
1740     ) internal virtual {
1741         require(to != address(0), "ERC1155: mint to the zero address");
1742 
1743         address operator = _msgSender();
1744 
1745         _beforeTokenTransfer(operator, address(0), to, _asSingletonArray(id), _asSingletonArray(amount), data);
1746 
1747         _balances[id][to] += amount;
1748         emit TransferSingle(operator, address(0), to, id, amount);
1749 
1750         _doSafeTransferAcceptanceCheck(operator, address(0), to, id, amount, data);
1751     }
1752 
1753     /**
1754      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_mint}.
1755      *
1756      * Requirements:
1757      *
1758      * - `ids` and `amounts` must have the same length.
1759      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
1760      * acceptance magic value.
1761      */
1762     function _mintBatch(
1763         address to,
1764         uint256[] memory ids,
1765         uint256[] memory amounts,
1766         bytes memory data
1767     ) internal virtual {
1768         require(to != address(0), "ERC1155: mint to the zero address");
1769         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
1770 
1771         address operator = _msgSender();
1772 
1773         _beforeTokenTransfer(operator, address(0), to, ids, amounts, data);
1774 
1775         for (uint256 i = 0; i < ids.length; i++) {
1776             _balances[ids[i]][to] += amounts[i];
1777         }
1778 
1779         emit TransferBatch(operator, address(0), to, ids, amounts);
1780 
1781         _doSafeBatchTransferAcceptanceCheck(operator, address(0), to, ids, amounts, data);
1782     }
1783 
1784     /**
1785      * @dev Destroys `amount` tokens of token type `id` from `from`
1786      *
1787      * Requirements:
1788      *
1789      * - `from` cannot be the zero address.
1790      * - `from` must have at least `amount` tokens of token type `id`.
1791      */
1792     function _burn(
1793         address from,
1794         uint256 id,
1795         uint256 amount
1796     ) internal virtual {
1797         require(from != address(0), "ERC1155: burn from the zero address");
1798 
1799         address operator = _msgSender();
1800 
1801         _beforeTokenTransfer(operator, from, address(0), _asSingletonArray(id), _asSingletonArray(amount), "");
1802 
1803         uint256 fromBalance = _balances[id][from];
1804         require(fromBalance >= amount, "ERC1155: burn amount exceeds balance");
1805         unchecked {
1806             _balances[id][from] = fromBalance - amount;
1807         }
1808 
1809         emit TransferSingle(operator, from, address(0), id, amount);
1810     }
1811 
1812     /**
1813      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_burn}.
1814      *
1815      * Requirements:
1816      *
1817      * - `ids` and `amounts` must have the same length.
1818      */
1819     function _burnBatch(
1820         address from,
1821         uint256[] memory ids,
1822         uint256[] memory amounts
1823     ) internal virtual {
1824         require(from != address(0), "ERC1155: burn from the zero address");
1825         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
1826 
1827         address operator = _msgSender();
1828 
1829         _beforeTokenTransfer(operator, from, address(0), ids, amounts, "");
1830 
1831         for (uint256 i = 0; i < ids.length; i++) {
1832             uint256 id = ids[i];
1833             uint256 amount = amounts[i];
1834 
1835             uint256 fromBalance = _balances[id][from];
1836             require(fromBalance >= amount, "ERC1155: burn amount exceeds balance");
1837             unchecked {
1838                 _balances[id][from] = fromBalance - amount;
1839             }
1840         }
1841 
1842         emit TransferBatch(operator, from, address(0), ids, amounts);
1843     }
1844 
1845     /**
1846      * @dev Approve `operator` to operate on all of `owner` tokens
1847      *
1848      * Emits a {ApprovalForAll} event.
1849      */
1850     function _setApprovalForAll(
1851         address owner,
1852         address operator,
1853         bool approved
1854     ) internal virtual {
1855         require(owner != operator, "ERC1155: setting approval status for self");
1856         _operatorApprovals[owner][operator] = approved;
1857         emit ApprovalForAll(owner, operator, approved);
1858     }
1859 
1860     /**
1861      * @dev Hook that is called before any token transfer. This includes minting
1862      * and burning, as well as batched variants.
1863      *
1864      * The same hook is called on both single and batched variants. For single
1865      * transfers, the length of the `id` and `amount` arrays will be 1.
1866      *
1867      * Calling conditions (for each `id` and `amount` pair):
1868      *
1869      * - When `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1870      * of token type `id` will be  transferred to `to`.
1871      * - When `from` is zero, `amount` tokens of token type `id` will be minted
1872      * for `to`.
1873      * - when `to` is zero, `amount` of ``from``'s tokens of token type `id`
1874      * will be burned.
1875      * - `from` and `to` are never both zero.
1876      * - `ids` and `amounts` have the same, non-zero length.
1877      *
1878      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1879      */
1880     function _beforeTokenTransfer(
1881         address operator,
1882         address from,
1883         address to,
1884         uint256[] memory ids,
1885         uint256[] memory amounts,
1886         bytes memory data
1887     ) internal virtual {}
1888 
1889     function _doSafeTransferAcceptanceCheck(
1890         address operator,
1891         address from,
1892         address to,
1893         uint256 id,
1894         uint256 amount,
1895         bytes memory data
1896     ) private {
1897         if (to.isContract()) {
1898             try IERC1155Receiver(to).onERC1155Received(operator, from, id, amount, data) returns (bytes4 response) {
1899                 if (response != IERC1155Receiver.onERC1155Received.selector) {
1900                     revert("ERC1155: ERC1155Receiver rejected tokens");
1901                 }
1902             } catch Error(string memory reason) {
1903                 revert(reason);
1904             } catch {
1905                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
1906             }
1907         }
1908     }
1909 
1910     function _doSafeBatchTransferAcceptanceCheck(
1911         address operator,
1912         address from,
1913         address to,
1914         uint256[] memory ids,
1915         uint256[] memory amounts,
1916         bytes memory data
1917     ) private {
1918         if (to.isContract()) {
1919             try IERC1155Receiver(to).onERC1155BatchReceived(operator, from, ids, amounts, data) returns (
1920                 bytes4 response
1921             ) {
1922                 if (response != IERC1155Receiver.onERC1155BatchReceived.selector) {
1923                     revert("ERC1155: ERC1155Receiver rejected tokens");
1924                 }
1925             } catch Error(string memory reason) {
1926                 revert(reason);
1927             } catch {
1928                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
1929             }
1930         }
1931     }
1932 
1933     function _asSingletonArray(uint256 element) private pure returns (uint256[] memory) {
1934         uint256[] memory array = new uint256[](1);
1935         array[0] = element;
1936 
1937         return array;
1938     }
1939 }
1940 
1941 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC1155/extensions/ERC1155Burnable.sol
1942 
1943 
1944 // OpenZeppelin Contracts v4.3.2 (token/ERC1155/extensions/ERC1155Burnable.sol)
1945 
1946 pragma solidity ^0.8.0;
1947 
1948 
1949 /**
1950  * @dev Extension of {ERC1155} that allows token holders to destroy both their
1951  * own tokens and those that they have been approved to use.
1952  *
1953  * _Available since v3.1._
1954  */
1955 abstract contract ERC1155Burnable is ERC1155 {
1956     function burn(
1957         address account,
1958         uint256 id,
1959         uint256 value
1960     ) public virtual {
1961         require(
1962             account == _msgSender() || isApprovedForAll(account, _msgSender()),
1963             "ERC1155: caller is not owner nor approved"
1964         );
1965 
1966         _burn(account, id, value);
1967     }
1968 
1969     function burnBatch(
1970         address account,
1971         uint256[] memory ids,
1972         uint256[] memory values
1973     ) public virtual {
1974         require(
1975             account == _msgSender() || isApprovedForAll(account, _msgSender()),
1976             "ERC1155: caller is not owner nor approved"
1977         );
1978 
1979         _burnBatch(account, ids, values);
1980     }
1981 }
1982 
1983 // File: cosmicPass.sol
1984 
1985 pragma solidity 0.8.7;
1986 
1987 
1988 contract CosmicLabsShop is ERC1155Burnable, Ownable {
1989    
1990     using Strings for uint256;
1991     CosmicToken public cosmictoken;
1992    
1993     string public baseURI;
1994     string public baseExtension = ".json";
1995     
1996     uint256 public babyPrice = 250 ether;
1997     uint256 public cosmicPrice = 750 ether;
1998     uint256 public genesisPrice = 1500 ether;
1999     uint256 public generatorPrice = 700 ether;
2000     
2001     bool public fusionGeneratorOpen = false;
2002     
2003     modifier isFusionMintOpen
2004     {
2005         require(fusionGeneratorOpen == true);
2006         _;
2007     }
2008 
2009     constructor(string memory _initBaseURI, address _yield) ERC1155(_initBaseURI)
2010     {
2011         setBaseURI(_initBaseURI);
2012         cosmictoken = CosmicToken(_yield);
2013     }   
2014     
2015     function setYieldToken(address _yield) public onlyOwner
2016     {
2017         cosmictoken = CosmicToken(_yield);
2018     }
2019     
2020     function openFusionGenerator(bool _open) public onlyOwner
2021     {
2022         fusionGeneratorOpen = _open;
2023     }
2024     
2025     function setBabyPrice(uint256 _price) public onlyOwner
2026     {
2027         babyPrice = (_price * 10 ** 18);
2028     }
2029     function setCosmicPrice(uint256 _price) public onlyOwner
2030     {
2031         cosmicPrice = (_price * 10 ** 18);
2032     }
2033     function setGenesisPrice(uint256 _price) public onlyOwner
2034     {
2035         genesisPrice = (_price * 10 ** 18);
2036     }
2037     function setGeneratorPrice(uint256 _price) public onlyOwner
2038     {
2039         generatorPrice = (_price * 10 ** 18);
2040     }
2041     
2042     function doYouOwn(uint256 tokenId) internal view returns (bool) 
2043     {
2044         return balanceOf(msg.sender, tokenId) != 0;
2045     }
2046     
2047     function BabyAlphaPass() public payable 
2048     {
2049         require(cosmictoken.balanceOf(msg.sender) >= babyPrice, "You Don't Have 250 Cosmic Tokens!");
2050         
2051         cosmictoken.transferFrom(tx.origin, address(this), babyPrice);
2052         cosmictoken.burn(address(this), babyPrice);
2053         _mint(msg.sender, 1, 1, "");
2054     }
2055     
2056     function CosmicAlphaPass() public payable 
2057     {
2058         require(doYouOwn(1), "You Don't Own a Baby Alpha Pass!");
2059         require(cosmictoken.balanceOf(msg.sender) >= cosmicPrice, "You Don't Have 750 Cosmic Tokens!");
2060         
2061         cosmictoken.transferFrom(tx.origin, address(this), cosmicPrice);
2062         cosmictoken.burn(address(this), cosmicPrice);
2063         _mint(msg.sender, 2, 1, "");
2064     }
2065     
2066     function GenesisAlphaPass() public payable 
2067     {
2068         require(doYouOwn(1), "You Don't Own a Baby Alpha Pass!");
2069         require(doYouOwn(2), "You Don't Own a Cosmic Alpha Pass!");
2070         require(cosmictoken.balanceOf(msg.sender) >= genesisPrice, "You Don't Have 1500 Cosmic Tokens!");
2071         
2072         cosmictoken.transferFrom(tx.origin, address(this), genesisPrice);
2073         cosmictoken.burn(address(this), genesisPrice);
2074         _mint(msg.sender, 3, 1, "");
2075     }
2076     
2077     function FusionGenerator() public payable isFusionMintOpen
2078     {
2079         require(cosmictoken.balanceOf(msg.sender) >= generatorPrice, "You Don't Have 700 Cosmic Tokens!");
2080         
2081         cosmictoken.transferFrom(tx.origin, address(this), generatorPrice);
2082         cosmictoken.burn(address(this), generatorPrice);
2083         _mint(msg.sender, 4, 1, "");
2084     }
2085    
2086     function withdrawContractEther(address payable recipient) external onlyOwner
2087     {
2088         recipient.transfer(getBalance());
2089     }
2090     function getBalance() public view returns(uint)
2091     {
2092         return address(this).balance;
2093     }
2094    
2095     function _baseURI() internal view virtual returns (string memory) {
2096         return baseURI;
2097     }
2098    
2099     function setBaseURI(string memory _newBaseURI) public onlyOwner {
2100         baseURI = _newBaseURI;
2101     }
2102    
2103     function uri(uint256 tokenId) public view override virtual returns (string memory)
2104     {
2105         string memory currentBaseURI = _baseURI();
2106         return bytes(currentBaseURI).length > 0 ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension)) : "";
2107     }
2108    
2109 
2110 }