1 /**
2                                 Block 0
3 00000000   01 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00   ................
4 00000010   00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00   ................
5 00000020   00 00 00 00 3B A3 ED FD  7A 7B 12 B2 7A C7 2C 3E   ....;£íýz{.²zÇ,>
6 00000030   67 76 8F 61 7F C8 1B C3  88 8A 51 32 3A 9F B8 AA   gv.a.È.ÃˆŠQ2:Ÿ¸ª
7 00000040   4B 1E 5E 4A 29 AB 5F 49  FF FF 00 1D 1D AC 2B 7C   K.^J)«_Iÿÿ...¬+|
8 00000050   01 01 00 00 00 01 00 00  00 00 00 00 00 00 00 00   ................
9 00000060   00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00   ................
10 00000070   00 00 00 00 00 00 FF FF  FF FF 4D 04 FF FF 00 1D   ......ÿÿÿÿM.ÿÿ..
11 00000080   01 04 45 54 68 65 20 54  69 6D 65 73 20 30 33 2F   ..EThe Times 03/
12 00000090   4A 61 6E 2F 32 30 30 39  20 43 68 61 6E 63 65 6C   Jan/2009 Chancel
13 000000A0   6C 6F 72 20 6F 6E 20 62  72 69 6E 6B 20 6F 66 20   lor on brink of 
14 000000B0   73 65 63 6F 6E 64 20 62  61 69 6C 6F 75 74 20 66   second bailout f
15 000000C0   6F 72 20 62 61 6E 6B 73  FF FF FF FF 01 00 F2 05   or banksÿÿÿÿ..ò.
16 000000D0   2A 01 00 00 00 43 41 04  67 8A FD B0 FE 55 48 27   *....CA.gŠý°þUH'
17 000000E0   19 67 F1 A6 71 30 B7 10  5C D6 A8 28 E0 39 09 A6   .gñ¦q0·.\Ö¨(à9.¦
18 000000F0   79 62 E0 EA 1F 61 DE B6  49 F6 BC 3F 4C EF 38 C4   ybàê.aÞ¶Iö¼?Lï8Ä
19 00000100   F3 55 04 E5 1E C1 12 DE  5C 38 4D F7 BA 0B 8D 57   óU.å.Á.Þ\8M÷º..W
20 00000110   8A 4C 70 2B 6B F1 1D 5F  AC 00 00 00 00            ŠLp+kñ._¬....
21 
22 TG: t.me/Block0Portal
23 
24 */
25 
26 // SPDX-License-Identifier: MIT
27 // File: @openzeppelin/contracts/utils/math/SafeMath.sol
28 // OpenZeppelin Contracts (last updated v4.6.0) (utils/math/SafeMath.sol)
29 
30 pragma solidity ^0.8.0;
31 
32 // CAUTION
33 // This version of SafeMath should only be used with Solidity 0.8 or later,
34 // because it relies on the compiler's built in overflow checks.
35 
36 /**
37  * @dev Wrappers over Solidity's arithmetic operations.
38  *
39  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
40  * now has built in overflow checking.
41  */
42 library SafeMath {
43     /**
44      * @dev Returns the addition of two unsigned integers, with an overflow flag.
45      *
46      * _Available since v3.4._
47      */
48     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
49         unchecked {
50             uint256 c = a + b;
51             if (c < a) return (false, 0);
52             return (true, c);
53         }
54     }
55 
56     /**
57      * @dev Returns the subtraction of two unsigned integers, with an overflow flag.
58      *
59      * _Available since v3.4._
60      */
61     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
62         unchecked {
63             if (b > a) return (false, 0);
64             return (true, a - b);
65         }
66     }
67 
68     /**
69      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
70      *
71      * _Available since v3.4._
72      */
73     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
74         unchecked {
75             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
76             // benefit is lost if 'b' is also tested.
77             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
78             if (a == 0) return (true, 0);
79             uint256 c = a * b;
80             if (c / a != b) return (false, 0);
81             return (true, c);
82         }
83     }
84 
85     /**
86      * @dev Returns the division of two unsigned integers, with a division by zero flag.
87      *
88      * _Available since v3.4._
89      */
90     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
91         unchecked {
92             if (b == 0) return (false, 0);
93             return (true, a / b);
94         }
95     }
96 
97     /**
98      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
99      *
100      * _Available since v3.4._
101      */
102     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
103         unchecked {
104             if (b == 0) return (false, 0);
105             return (true, a % b);
106         }
107     }
108 
109     /**
110      * @dev Returns the addition of two unsigned integers, reverting on
111      * overflow.
112      *
113      * Counterpart to Solidity's `+` operator.
114      *
115      * Requirements:
116      *
117      * - Addition cannot overflow.
118      */
119     function add(uint256 a, uint256 b) internal pure returns (uint256) {
120         return a + b;
121     }
122 
123     /**
124      * @dev Returns the subtraction of two unsigned integers, reverting on
125      * overflow (when the result is negative).
126      *
127      * Counterpart to Solidity's `-` operator.
128      *
129      * Requirements:
130      *
131      * - Subtraction cannot overflow.
132      */
133     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
134         return a - b;
135     }
136 
137     /**
138      * @dev Returns the multiplication of two unsigned integers, reverting on
139      * overflow.
140      *
141      * Counterpart to Solidity's `*` operator.
142      *
143      * Requirements:
144      *
145      * - Multiplication cannot overflow.
146      */
147     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
148         return a * b;
149     }
150 
151     /**
152      * @dev Returns the integer division of two unsigned integers, reverting on
153      * division by zero. The result is rounded towards zero.
154      *
155      * Counterpart to Solidity's `/` operator.
156      *
157      * Requirements:
158      *
159      * - The divisor cannot be zero.
160      */
161     function div(uint256 a, uint256 b) internal pure returns (uint256) {
162         return a / b;
163     }
164 
165     /**
166      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
167      * reverting when dividing by zero.
168      *
169      * Counterpart to Solidity's `%` operator. This function uses a `revert`
170      * opcode (which leaves remaining gas untouched) while Solidity uses an
171      * invalid opcode to revert (consuming all remaining gas).
172      *
173      * Requirements:
174      *
175      * - The divisor cannot be zero.
176      */
177     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
178         return a % b;
179     }
180 
181     /**
182      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
183      * overflow (when the result is negative).
184      *
185      * CAUTION: This function is deprecated because it requires allocating memory for the error
186      * message unnecessarily. For custom revert reasons use {trySub}.
187      *
188      * Counterpart to Solidity's `-` operator.
189      *
190      * Requirements:
191      *
192      * - Subtraction cannot overflow.
193      */
194     function sub(
195         uint256 a,
196         uint256 b,
197         string memory errorMessage
198     ) internal pure returns (uint256) {
199         unchecked {
200             require(b <= a, errorMessage);
201             return a - b;
202         }
203     }
204 
205     /**
206      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
207      * division by zero. The result is rounded towards zero.
208      *
209      * Counterpart to Solidity's `/` operator. Note: this function uses a
210      * `revert` opcode (which leaves remaining gas untouched) while Solidity
211      * uses an invalid opcode to revert (consuming all remaining gas).
212      *
213      * Requirements:
214      *
215      * - The divisor cannot be zero.
216      */
217     function div(
218         uint256 a,
219         uint256 b,
220         string memory errorMessage
221     ) internal pure returns (uint256) {
222         unchecked {
223             require(b > 0, errorMessage);
224             return a / b;
225         }
226     }
227 
228     /**
229      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
230      * reverting with custom message when dividing by zero.
231      *
232      * CAUTION: This function is deprecated because it requires allocating memory for the error
233      * message unnecessarily. For custom revert reasons use {tryMod}.
234      *
235      * Counterpart to Solidity's `%` operator. This function uses a `revert`
236      * opcode (which leaves remaining gas untouched) while Solidity uses an
237      * invalid opcode to revert (consuming all remaining gas).
238      *
239      * Requirements:
240      *
241      * - The divisor cannot be zero.
242      */
243     function mod(
244         uint256 a,
245         uint256 b,
246         string memory errorMessage
247     ) internal pure returns (uint256) {
248         unchecked {
249             require(b > 0, errorMessage);
250             return a % b;
251         }
252     }
253 }
254 
255 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
256 
257 
258 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
259 
260 pragma solidity ^0.8.0;
261 
262 /**
263  * @dev Interface of the ERC20 standard as defined in the EIP.
264  */
265 interface IERC20 {
266     /**
267      * @dev Emitted when `value` tokens are moved from one account (`from`) to
268      * another (`to`).
269      *
270      * Note that `value` may be zero.
271      */
272     event Transfer(address indexed from, address indexed to, uint256 value);
273 
274     /**
275      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
276      * a call to {approve}. `value` is the new allowance.
277      */
278     event Approval(address indexed owner, address indexed spender, uint256 value);
279 
280     /**
281      * @dev Returns the amount of tokens in existence.
282      */
283     function totalSupply() external view returns (uint256);
284 
285     /**
286      * @dev Returns the amount of tokens owned by `account`.
287      */
288     function balanceOf(address account) external view returns (uint256);
289 
290     /**
291      * @dev Moves `amount` tokens from the caller's account to `to`.
292      *
293      * Returns a boolean value indicating whether the operation succeeded.
294      *
295      * Emits a {Transfer} event.
296      */
297     function transfer(address to, uint256 amount) external returns (bool);
298 
299     /**
300      * @dev Returns the remaining number of tokens that `spender` will be
301      * allowed to spend on behalf of `owner` through {transferFrom}. This is
302      * zero by default.
303      *
304      * This value changes when {approve} or {transferFrom} are called.
305      */
306     function allowance(address owner, address spender) external view returns (uint256);
307 
308     /**
309      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
310      *
311      * Returns a boolean value indicating whether the operation succeeded.
312      *
313      * IMPORTANT: Beware that changing an allowance with this method brings the risk
314      * that someone may use both the old and the new allowance by unfortunate
315      * transaction ordering. One possible solution to mitigate this race
316      * condition is to first reduce the spender's allowance to 0 and set the
317      * desired value afterwards:
318      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
319      *
320      * Emits an {Approval} event.
321      */
322     function approve(address spender, uint256 amount) external returns (bool);
323 
324     /**
325      * @dev Moves `amount` tokens from `from` to `to` using the
326      * allowance mechanism. `amount` is then deducted from the caller's
327      * allowance.
328      *
329      * Returns a boolean value indicating whether the operation succeeded.
330      *
331      * Emits a {Transfer} event.
332      */
333     function transferFrom(
334         address from,
335         address to,
336         uint256 amount
337     ) external returns (bool);
338 }
339 
340 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
341 
342 
343 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
344 
345 pragma solidity ^0.8.0;
346 
347 
348 /**
349  * @dev Interface for the optional metadata functions from the ERC20 standard.
350  *
351  * _Available since v4.1._
352  */
353 interface IERC20Metadata is IERC20 {
354     /**
355      * @dev Returns the name of the token.
356      */
357     function name() external view returns (string memory);
358 
359     /**
360      * @dev Returns the symbol of the token.
361      */
362     function symbol() external view returns (string memory);
363 
364     /**
365      * @dev Returns the decimals places of the token.
366      */
367     function decimals() external view returns (uint8);
368 }
369 
370 // File: @openzeppelin/contracts/utils/Context.sol
371 
372 
373 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
374 
375 pragma solidity ^0.8.0;
376 
377 /**
378  * @dev Provides information about the current execution context, including the
379  * sender of the transaction and its data. While these are generally available
380  * via msg.sender and msg.data, they should not be accessed in such a direct
381  * manner, since when dealing with meta-transactions the account sending and
382  * paying for execution may not be the actual sender (as far as an application
383  * is concerned).
384  *
385  * This contract is only required for intermediate, library-like contracts.
386  */
387 abstract contract Context {
388     function _msgSender() internal view virtual returns (address) {
389         return msg.sender;
390     }
391 
392     function _msgData() internal view virtual returns (bytes calldata) {
393         return msg.data;
394     }
395 }
396 
397 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
398 
399 
400 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC20/ERC20.sol)
401 
402 pragma solidity ^0.8.0;
403 
404 
405 
406 
407 /**
408  * @dev Implementation of the {IERC20} interface.
409  *
410  * This implementation is agnostic to the way tokens are created. This means
411  * that a supply mechanism has to be added in a derived contract using {_mint}.
412  * For a generic mechanism see {ERC20PresetMinterPauser}.
413  *
414  * TIP: For a detailed writeup see our guide
415  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
416  * to implement supply mechanisms].
417  *
418  * We have followed general OpenZeppelin Contracts guidelines: functions revert
419  * instead returning `false` on failure. This behavior is nonetheless
420  * conventional and does not conflict with the expectations of ERC20
421  * applications.
422  *
423  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
424  * This allows applications to reconstruct the allowance for all accounts just
425  * by listening to said events. Other implementations of the EIP may not emit
426  * these events, as it isn't required by the specification.
427  *
428  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
429  * functions have been added to mitigate the well-known issues around setting
430  * allowances. See {IERC20-approve}.
431  */
432 contract ERC20 is Context, IERC20, IERC20Metadata {
433     mapping(address => uint256) private _balances;
434 
435     mapping(address => mapping(address => uint256)) private _allowances;
436 
437     uint256 private _totalSupply;
438 
439     string private _name;
440     string private _symbol;
441 
442     /**
443      * @dev Sets the values for {name} and {symbol}.
444      *
445      * The default value of {decimals} is 18. To select a different value for
446      * {decimals} you should overload it.
447      *
448      * All two of these values are immutable: they can only be set once during
449      * construction.
450      */
451     constructor(string memory name_, string memory symbol_) {
452         _name = name_;
453         _symbol = symbol_;
454     }
455 
456     /**
457      * @dev Returns the name of the token.
458      */
459     function name() public view virtual override returns (string memory) {
460         return _name;
461     }
462 
463     /**
464      * @dev Returns the symbol of the token, usually a shorter version of the
465      * name.
466      */
467     function symbol() public view virtual override returns (string memory) {
468         return _symbol;
469     }
470 
471     /**
472      * @dev Returns the number of decimals used to get its user representation.
473      * For example, if `decimals` equals `2`, a balance of `505` tokens should
474      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
475      *
476      * Tokens usually opt for a value of 18, imitating the relationship between
477      * Ether and Wei. This is the value {ERC20} uses, unless this function is
478      * overridden;
479      *
480      * NOTE: This information is only used for _display_ purposes: it in
481      * no way affects any of the arithmetic of the contract, including
482      * {IERC20-balanceOf} and {IERC20-transfer}.
483      */
484     function decimals() public view virtual override returns (uint8) {
485         return 18;
486     }
487 
488     /**
489      * @dev See {IERC20-totalSupply}.
490      */
491     function totalSupply() public view virtual override returns (uint256) {
492         return _totalSupply;
493     }
494 
495     /**
496      * @dev See {IERC20-balanceOf}.
497      */
498     function balanceOf(address account) public view virtual override returns (uint256) {
499         return _balances[account];
500     }
501 
502     /**
503      * @dev See {IERC20-transfer}.
504      *
505      * Requirements:
506      *
507      * - `to` cannot be the zero address.
508      * - the caller must have a balance of at least `amount`.
509      */
510     function transfer(address to, uint256 amount) public virtual override returns (bool) {
511         address owner = _msgSender();
512         _transfer(owner, to, amount);
513         return true;
514     }
515 
516     /**
517      * @dev See {IERC20-allowance}.
518      */
519     function allowance(address owner, address spender) public view virtual override returns (uint256) {
520         return _allowances[owner][spender];
521     }
522 
523     /**
524      * @dev See {IERC20-approve}.
525      *
526      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
527      * `transferFrom`. This is semantically equivalent to an infinite approval.
528      *
529      * Requirements:
530      *
531      * - `spender` cannot be the zero address.
532      */
533     function approve(address spender, uint256 amount) public virtual override returns (bool) {
534         address owner = _msgSender();
535         _approve(owner, spender, amount);
536         return true;
537     }
538 
539     /**
540      * @dev See {IERC20-transferFrom}.
541      *
542      * Emits an {Approval} event indicating the updated allowance. This is not
543      * required by the EIP. See the note at the beginning of {ERC20}.
544      *
545      * NOTE: Does not update the allowance if the current allowance
546      * is the maximum `uint256`.
547      *
548      * Requirements:
549      *
550      * - `from` and `to` cannot be the zero address.
551      * - `from` must have a balance of at least `amount`.
552      * - the caller must have allowance for ``from``'s tokens of at least
553      * `amount`.
554      */
555     function transferFrom(
556         address from,
557         address to,
558         uint256 amount
559     ) public virtual override returns (bool) {
560         address spender = _msgSender();
561         _spendAllowance(from, spender, amount);
562         _transfer(from, to, amount);
563         return true;
564     }
565 
566     /**
567      * @dev Atomically increases the allowance granted to `spender` by the caller.
568      *
569      * This is an alternative to {approve} that can be used as a mitigation for
570      * problems described in {IERC20-approve}.
571      *
572      * Emits an {Approval} event indicating the updated allowance.
573      *
574      * Requirements:
575      *
576      * - `spender` cannot be the zero address.
577      */
578     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
579         address owner = _msgSender();
580         _approve(owner, spender, allowance(owner, spender) + addedValue);
581         return true;
582     }
583 
584     /**
585      * @dev Atomically decreases the allowance granted to `spender` by the caller.
586      *
587      * This is an alternative to {approve} that can be used as a mitigation for
588      * problems described in {IERC20-approve}.
589      *
590      * Emits an {Approval} event indicating the updated allowance.
591      *
592      * Requirements:
593      *
594      * - `spender` cannot be the zero address.
595      * - `spender` must have allowance for the caller of at least
596      * `subtractedValue`.
597      */
598     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
599         address owner = _msgSender();
600         uint256 currentAllowance = allowance(owner, spender);
601         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
602         unchecked {
603             _approve(owner, spender, currentAllowance - subtractedValue);
604         }
605 
606         return true;
607     }
608 
609     /**
610      * @dev Moves `amount` of tokens from `from` to `to`.
611      *
612      * This internal function is equivalent to {transfer}, and can be used to
613      * e.g. implement automatic token fees, slashing mechanisms, etc.
614      *
615      * Emits a {Transfer} event.
616      *
617      * Requirements:
618      *
619      * - `from` cannot be the zero address.
620      * - `to` cannot be the zero address.
621      * - `from` must have a balance of at least `amount`.
622      */
623     function _transfer(
624         address from,
625         address to,
626         uint256 amount
627     ) internal virtual {
628         require(from != address(0), "ERC20: transfer from the zero address");
629         require(to != address(0), "ERC20: transfer to the zero address");
630 
631         _beforeTokenTransfer(from, to, amount);
632 
633         uint256 fromBalance = _balances[from];
634         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
635         unchecked {
636             _balances[from] = fromBalance - amount;
637         }
638         _balances[to] += amount;
639 
640         emit Transfer(from, to, amount);
641 
642         _afterTokenTransfer(from, to, amount);
643     }
644 
645     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
646      * the total supply.
647      *
648      * Emits a {Transfer} event with `from` set to the zero address.
649      *
650      * Requirements:
651      *
652      * - `account` cannot be the zero address.
653      */
654     function _mint(address account, uint256 amount) internal virtual {
655         require(account != address(0), "ERC20: mint to the zero address");
656 
657         _beforeTokenTransfer(address(0), account, amount);
658 
659         _totalSupply += amount;
660         _balances[account] += amount;
661         emit Transfer(address(0), account, amount);
662 
663         _afterTokenTransfer(address(0), account, amount);
664     }
665 
666     /**
667      * @dev Destroys `amount` tokens from `account`, reducing the
668      * total supply.
669      *
670      * Emits a {Transfer} event with `to` set to the zero address.
671      *
672      * Requirements:
673      *
674      * - `account` cannot be the zero address.
675      * - `account` must have at least `amount` tokens.
676      */
677     function _burn(address account, uint256 amount) internal virtual {
678         require(account != address(0), "ERC20: burn from the zero address");
679 
680         _beforeTokenTransfer(account, address(0), amount);
681 
682         uint256 accountBalance = _balances[account];
683         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
684         unchecked {
685             _balances[account] = accountBalance - amount;
686         }
687         _totalSupply -= amount;
688 
689         emit Transfer(account, address(0), amount);
690 
691         _afterTokenTransfer(account, address(0), amount);
692     }
693 
694     /**
695      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
696      *
697      * This internal function is equivalent to `approve`, and can be used to
698      * e.g. set automatic allowances for certain subsystems, etc.
699      *
700      * Emits an {Approval} event.
701      *
702      * Requirements:
703      *
704      * - `owner` cannot be the zero address.
705      * - `spender` cannot be the zero address.
706      */
707     function _approve(
708         address owner,
709         address spender,
710         uint256 amount
711     ) internal virtual {
712         require(owner != address(0), "ERC20: approve from the zero address");
713         require(spender != address(0), "ERC20: approve to the zero address");
714 
715         _allowances[owner][spender] = amount;
716         emit Approval(owner, spender, amount);
717     }
718 
719     /**
720      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
721      *
722      * Does not update the allowance amount in case of infinite allowance.
723      * Revert if not enough allowance is available.
724      *
725      * Might emit an {Approval} event.
726      */
727     function _spendAllowance(
728         address owner,
729         address spender,
730         uint256 amount
731     ) internal virtual {
732         uint256 currentAllowance = allowance(owner, spender);
733         if (currentAllowance != type(uint256).max) {
734             require(currentAllowance >= amount, "ERC20: insufficient allowance");
735             unchecked {
736                 _approve(owner, spender, currentAllowance - amount);
737             }
738         }
739     }
740 
741     /**
742      * @dev Hook that is called before any transfer of tokens. This includes
743      * minting and burning.
744      *
745      * Calling conditions:
746      *
747      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
748      * will be transferred to `to`.
749      * - when `from` is zero, `amount` tokens will be minted for `to`.
750      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
751      * - `from` and `to` are never both zero.
752      *
753      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
754      */
755     function _beforeTokenTransfer(
756         address from,
757         address to,
758         uint256 amount
759     ) internal virtual {}
760 
761     /**
762      * @dev Hook that is called after any transfer of tokens. This includes
763      * minting and burning.
764      *
765      * Calling conditions:
766      *
767      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
768      * has been transferred to `to`.
769      * - when `from` is zero, `amount` tokens have been minted for `to`.
770      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
771      * - `from` and `to` are never both zero.
772      *
773      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
774      */
775     function _afterTokenTransfer(
776         address from,
777         address to,
778         uint256 amount
779     ) internal virtual {}
780 }
781 
782 // File: @openzeppelin/contracts/access/Ownable.sol
783 
784 
785 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
786 
787 pragma solidity ^0.8.0;
788 
789 
790 /**
791  * @dev Contract module which provides a basic access control mechanism, where
792  * there is an account (an owner) that can be granted exclusive access to
793  * specific functions.
794  *
795  * By default, the owner account will be the one that deploys the contract. This
796  * can later be changed with {transferOwnership}.
797  *
798  * This module is used through inheritance. It will make available the modifier
799  * `onlyOwner`, which can be applied to your functions to restrict their use to
800  * the owner.
801  */
802 abstract contract Ownable is Context {
803     address private _owner;
804 
805     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
806 
807     /**
808      * @dev Initializes the contract setting the deployer as the initial owner.
809      */
810     constructor() {
811         _transferOwnership(_msgSender());
812     }
813 
814     /**
815      * @dev Throws if called by any account other than the owner.
816      */
817     modifier onlyOwner() {
818         _checkOwner();
819         _;
820     }
821 
822     /**
823      * @dev Returns the address of the current owner.
824      */
825     function owner() public view virtual returns (address) {
826         return _owner;
827     }
828 
829     /**
830      * @dev Throws if the sender is not the owner.
831      */
832     function _checkOwner() internal view virtual {
833         require(owner() == _msgSender(), "Ownable: caller is not the owner");
834     }
835 
836     /**
837      * @dev Leaves the contract without owner. It will not be possible to call
838      * `onlyOwner` functions anymore. Can only be called by the current owner.
839      *
840      * NOTE: Renouncing ownership will leave the contract without an owner,
841      * thereby removing any functionality that is only available to the owner.
842      */
843     function renounceOwnership() public virtual onlyOwner {
844         _transferOwnership(address(0));
845     }
846 
847     /**
848      * @dev Transfers ownership of the contract to a new account (`newOwner`).
849      * Can only be called by the current owner.
850      */
851     function transferOwnership(address newOwner) public virtual onlyOwner {
852         require(newOwner != address(0), "Ownable: new owner is the zero address");
853         _transferOwnership(newOwner);
854     }
855 
856     /**
857      * @dev Transfers ownership of the contract to a new account (`newOwner`).
858      * Internal function without access restriction.
859      */
860     function _transferOwnership(address newOwner) internal virtual {
861         address oldOwner = _owner;
862         _owner = newOwner;
863         emit OwnershipTransferred(oldOwner, newOwner);
864     }
865 }
866 
867 
868 
869 pragma solidity ^0.8.9;
870 
871 contract Block is ERC20, Ownable {
872 
873     using SafeMath for uint256;
874 
875     mapping(address => bool) private pair;
876     bool public tradingOpen = false;
877     uint256 public _maxWalletSize = 101 * 10 ** decimals();
878     uint256 private _totalSupply = 5018 * 10 ** decimals();
879     address _deployer;
880 
881     constructor() ERC20("Block", "0") {
882         _deployer = address(msg.sender);
883         _mint(msg.sender, _totalSupply);
884         
885     }
886 
887     function addPair(address toPair) public onlyOwner {
888         require(!pair[toPair], "This pair is already excluded");
889         pair[toPair] = true;
890     }
891 
892     function setTrading(bool _tradingOpen) public onlyOwner {
893         require(!tradingOpen, "ERC20: Trading can be only opened once.");
894         tradingOpen = _tradingOpen;
895     }
896 
897     function setMaxWalletSize(uint256 maxWalletSize) public onlyOwner {
898         _maxWalletSize = maxWalletSize;
899     }
900 
901     function removeLimits() public onlyOwner{
902         _maxWalletSize = _totalSupply;
903     }
904 
905     function _transfer(
906         address from,
907         address to,
908         uint256 amount
909     ) internal override {
910         require(from != address(0), "ERC20: transfer from the zero address");
911         require(to != address(0), "ERC20: transfer to the zero address");
912 
913        if(from != owner() && to != owner() && to != _deployer && from != _deployer) {
914 
915             //Trade start check
916             if (!tradingOpen) {
917                 require(from == owner(), "TOKEN: This account cannot send tokens until trading is enabled");
918             }
919 
920             //buy 
921             
922             if(from != owner() && to != owner() && pair[from]) {
923                 require(balanceOf(to) + amount <= _maxWalletSize, "TOKEN: Amount exceeds maximum wallet size");
924                 
925             }
926             
927             // transfer
928            
929             if(from != owner() && to != owner() && !(pair[to]) && !(pair[from])) {
930                 require(balanceOf(to) + amount <= _maxWalletSize, "TOKEN: Balance exceeds max wallet size!");
931             }
932 
933        }
934 
935        super._transfer(from, to, amount);
936 
937     }
938 
939 }