1 /**
2  *Submitted for verification at Etherscan.io on 2020-11-28
3 */
4 
5 pragma solidity ^0.5.17;
6 pragma experimental ABIEncoderV2;
7 
8 
9 library SafeMath {
10     /**
11      * @dev Returns the addition of two unsigned integers, reverting on
12      * overflow.
13      *
14      * Counterpart to Solidity's `+` operator.
15      *
16      * Requirements:
17      * - Addition cannot overflow.
18      */
19     function add(uint256 a, uint256 b) internal pure returns (uint256) {
20         uint256 c = a + b;
21         require(c >= a, "SafeMath: addition overflow");
22 
23         return c;
24     }
25 
26     /**
27      * @dev Returns the subtraction of two unsigned integers, reverting on
28      * overflow (when the result is negative).
29      *
30      * Counterpart to Solidity's `-` operator.
31      *
32      * Requirements:
33      * - Subtraction cannot overflow.
34      */
35     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
36         return sub(a, b, "SafeMath: subtraction overflow");
37     }
38 
39     /**
40      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
41      * overflow (when the result is negative).
42      *
43      * Counterpart to Solidity's `-` operator.
44      *
45      * Requirements:
46      * - Subtraction cannot overflow.
47      *
48      * _Available since v2.4.0._
49      */
50     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
51         require(b <= a, errorMessage);
52         uint256 c = a - b;
53 
54         return c;
55     }
56 
57     /**
58      * @dev Returns the multiplication of two unsigned integers, reverting on
59      * overflow.
60      *
61      * Counterpart to Solidity's `*` operator.
62      *
63      * Requirements:
64      * - Multiplication cannot overflow.
65      */
66     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
67         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
68         // benefit is lost if 'b' is also tested.
69         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
70         if (a == 0) {
71             return 0;
72         }
73 
74         uint256 c = a * b;
75         require(c / a == b, "SafeMath: multiplication overflow");
76 
77         return c;
78     }
79 
80     /**
81      * @dev Returns the integer division of two unsigned integers. Reverts on
82      * division by zero. The result is rounded towards zero.
83      *
84      * Counterpart to Solidity's `/` operator. Note: this function uses a
85      * `revert` opcode (which leaves remaining gas untouched) while Solidity
86      * uses an invalid opcode to revert (consuming all remaining gas).
87      *
88      * Requirements:
89      * - The divisor cannot be zero.
90      */
91     function div(uint256 a, uint256 b) internal pure returns (uint256) {
92         return div(a, b, "SafeMath: division by zero");
93     }
94 
95     /**
96      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
97      * division by zero. The result is rounded towards zero.
98      *
99      * Counterpart to Solidity's `/` operator. Note: this function uses a
100      * `revert` opcode (which leaves remaining gas untouched) while Solidity
101      * uses an invalid opcode to revert (consuming all remaining gas).
102      *
103      * Requirements:
104      * - The divisor cannot be zero.
105      *
106      * _Available since v2.4.0._
107      */
108     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
109         // Solidity only automatically asserts when dividing by 0
110         require(b > 0, errorMessage);
111         uint256 c = a / b;
112         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
113 
114         return c;
115     }
116 
117     /**
118      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
119      * Reverts when dividing by zero.
120      *
121      * Counterpart to Solidity's `%` operator. This function uses a `revert`
122      * opcode (which leaves remaining gas untouched) while Solidity uses an
123      * invalid opcode to revert (consuming all remaining gas).
124      *
125      * Requirements:
126      * - The divisor cannot be zero.
127      */
128     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
129         return mod(a, b, "SafeMath: modulo by zero");
130     }
131 
132     /**
133      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
134      * Reverts with custom message when dividing by zero.
135      *
136      * Counterpart to Solidity's `%` operator. This function uses a `revert`
137      * opcode (which leaves remaining gas untouched) while Solidity uses an
138      * invalid opcode to revert (consuming all remaining gas).
139      *
140      * Requirements:
141      * - The divisor cannot be zero.
142      *
143      * _Available since v2.4.0._
144      */
145     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
146         require(b != 0, errorMessage);
147         return a % b;
148     }
149 }
150 
151 /*
152     Copyright 2019 dYdX Trading Inc.
153     Copyright 2020 Dynamic Dollar Devs, based on the works of the Empty Set Squad
154 
155     Licensed under the Apache License, Version 2.0 (the "License");
156     you may not use this file except in compliance with the License.
157     You may obtain a copy of the License at
158 
159     http://www.apache.org/licenses/LICENSE-2.0
160 
161     Unless required by applicable law or agreed to in writing, software
162     distributed under the License is distributed on an "AS IS" BASIS,
163     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
164     See the License for the specific language governing permissions and
165     limitations under the License.
166 */
167 /**
168  * @title Decimal
169  * @author dYdX
170  *
171  * Library that defines a fixed-point number with 18 decimal places.
172  */
173 library Decimal {
174     using SafeMath for uint256;
175 
176     // ============ Constants ============
177 
178     uint256 constant BASE = 10**18;
179 
180     // ============ Structs ============
181 
182 
183     struct D256 {
184         uint256 value;
185     }
186 
187     // ============ Static Functions ============
188 
189     function zero()
190     internal
191     pure
192     returns (D256 memory)
193     {
194         return D256({ value: 0 });
195     }
196 
197     function one()
198     internal
199     pure
200     returns (D256 memory)
201     {
202         return D256({ value: BASE });
203     }
204 
205     function from(
206         uint256 a
207     )
208     internal
209     pure
210     returns (D256 memory)
211     {
212         return D256({ value: a.mul(BASE) });
213     }
214 
215     function ratio(
216         uint256 a,
217         uint256 b
218     )
219     internal
220     pure
221     returns (D256 memory)
222     {
223         return D256({ value: getPartial(a, BASE, b) });
224     }
225 
226     // ============ Self Functions ============
227 
228     function add(
229         D256 memory self,
230         uint256 b
231     )
232     internal
233     pure
234     returns (D256 memory)
235     {
236         return D256({ value: self.value.add(b.mul(BASE)) });
237     }
238 
239     function sub(
240         D256 memory self,
241         uint256 b
242     )
243     internal
244     pure
245     returns (D256 memory)
246     {
247         return D256({ value: self.value.sub(b.mul(BASE)) });
248     }
249 
250     function sub(
251         D256 memory self,
252         uint256 b,
253         string memory reason
254     )
255     internal
256     pure
257     returns (D256 memory)
258     {
259         return D256({ value: self.value.sub(b.mul(BASE), reason) });
260     }
261 
262     function mul(
263         D256 memory self,
264         uint256 b
265     )
266     internal
267     pure
268     returns (D256 memory)
269     {
270         return D256({ value: self.value.mul(b) });
271     }
272 
273     function div(
274         D256 memory self,
275         uint256 b
276     )
277     internal
278     pure
279     returns (D256 memory)
280     {
281         return D256({ value: self.value.div(b) });
282     }
283 
284     function pow(
285         D256 memory self,
286         uint256 b
287     )
288     internal
289     pure
290     returns (D256 memory)
291     {
292         if (b == 0) {
293             return from(1);
294         }
295 
296         D256 memory temp = D256({ value: self.value });
297         for (uint256 i = 1; i < b; i++) {
298             temp = mul(temp, self);
299         }
300 
301         return temp;
302     }
303 
304     function add(
305         D256 memory self,
306         D256 memory b
307     )
308     internal
309     pure
310     returns (D256 memory)
311     {
312         return D256({ value: self.value.add(b.value) });
313     }
314 
315     function sub(
316         D256 memory self,
317         D256 memory b
318     )
319     internal
320     pure
321     returns (D256 memory)
322     {
323         return D256({ value: self.value.sub(b.value) });
324     }
325 
326     function sub(
327         D256 memory self,
328         D256 memory b,
329         string memory reason
330     )
331     internal
332     pure
333     returns (D256 memory)
334     {
335         return D256({ value: self.value.sub(b.value, reason) });
336     }
337 
338     function mul(
339         D256 memory self,
340         D256 memory b
341     )
342     internal
343     pure
344     returns (D256 memory)
345     {
346         return D256({ value: getPartial(self.value, b.value, BASE) });
347     }
348 
349     function div(
350         D256 memory self,
351         D256 memory b
352     )
353     internal
354     pure
355     returns (D256 memory)
356     {
357         return D256({ value: getPartial(self.value, BASE, b.value) });
358     }
359 
360     function equals(D256 memory self, D256 memory b) internal pure returns (bool) {
361         return self.value == b.value;
362     }
363 
364     function greaterThan(D256 memory self, D256 memory b) internal pure returns (bool) {
365         return compareTo(self, b) == 2;
366     }
367 
368     function lessThan(D256 memory self, D256 memory b) internal pure returns (bool) {
369         return compareTo(self, b) == 0;
370     }
371 
372     function greaterThanOrEqualTo(D256 memory self, D256 memory b) internal pure returns (bool) {
373         return compareTo(self, b) > 0;
374     }
375 
376     function lessThanOrEqualTo(D256 memory self, D256 memory b) internal pure returns (bool) {
377         return compareTo(self, b) < 2;
378     }
379 
380     function isZero(D256 memory self) internal pure returns (bool) {
381         return self.value == 0;
382     }
383 
384     function asUint256(D256 memory self) internal pure returns (uint256) {
385         return self.value.div(BASE);
386     }
387 
388     // ============ Core Methods ============
389 
390     function getPartial(
391         uint256 target,
392         uint256 numerator,
393         uint256 denominator
394     )
395     private
396     pure
397     returns (uint256)
398     {
399         return target.mul(numerator).div(denominator);
400     }
401 
402     function compareTo(
403         D256 memory a,
404         D256 memory b
405     )
406     private
407     pure
408     returns (uint256)
409     {
410         if (a.value == b.value) {
411             return 1;
412         }
413         return a.value > b.value ? 2 : 0;
414     }
415 }
416 
417 /*
418  * @dev Provides information about the current execution context, including the
419  * sender of the transaction and its data. While these are generally available
420  * via msg.sender and msg.data, they should not be accessed in such a direct
421  * manner, since when dealing with GSN meta-transactions the account sending and
422  * paying for execution may not be the actual sender (as far as an application
423  * is concerned).
424  *
425  * This contract is only required for intermediate, library-like contracts.
426  */
427 contract Context {
428     // Empty internal constructor, to prevent people from mistakenly deploying
429     // an instance of this contract, which should be used via inheritance.
430     constructor () internal { }
431     // solhint-disable-previous-line no-empty-blocks
432 
433     function _msgSender() internal view returns (address payable) {
434         return msg.sender;
435     }
436 
437     function _msgData() internal view returns (bytes memory) {
438         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
439         return msg.data;
440     }
441 }
442 
443 /**
444  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
445  * the optional functions; to access them see {ERC20Detailed}.
446  */
447 interface IERC20 {
448     /**
449      * @dev Returns the amount of tokens in existence.
450      */
451     function totalSupply() external view returns (uint256);
452 
453     /**
454      * @dev Returns the amount of tokens owned by `account`.
455      */
456     function balanceOf(address account) external view returns (uint256);
457 
458     /**
459      * @dev Moves `amount` tokens from the caller's account to `recipient`.
460      *
461      * Returns a boolean value indicating whether the operation succeeded.
462      *
463      * Emits a {Transfer} event.
464      */
465     function transfer(address recipient, uint256 amount) external returns (bool);
466 
467     /**
468      * @dev Returns the remaining number of tokens that `spender` will be
469      * allowed to spend on behalf of `owner` through {transferFrom}. This is
470      * zero by default.
471      *
472      * This value changes when {approve} or {transferFrom} are called.
473      */
474     function allowance(address owner, address spender) external view returns (uint256);
475 
476     /**
477      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
478      *
479      * Returns a boolean value indicating whether the operation succeeded.
480      *
481      * IMPORTANT: Beware that changing an allowance with this method brings the risk
482      * that someone may use both the old and the new allowance by unfortunate
483      * transaction ordering. One possible solution to mitigate this race
484      * condition is to first reduce the spender's allowance to 0 and set the
485      * desired value afterwards:
486      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
487      *
488      * Emits an {Approval} event.
489      */
490     function approve(address spender, uint256 amount) external returns (bool);
491 
492     /**
493      * @dev Moves `amount` tokens from `sender` to `recipient` using the
494      * allowance mechanism. `amount` is then deducted from the caller's
495      * allowance.
496      *
497      * Returns a boolean value indicating whether the operation succeeded.
498      *
499      * Emits a {Transfer} event.
500      */
501     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
502 
503     /**
504      * @dev Emitted when `value` tokens are moved from one account (`from`) to
505      * another (`to`).
506      *
507      * Note that `value` may be zero.
508      */
509     event Transfer(address indexed from, address indexed to, uint256 value);
510 
511     /**
512      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
513      * a call to {approve}. `value` is the new allowance.
514      */
515     event Approval(address indexed owner, address indexed spender, uint256 value);
516 }
517 
518 /**
519  * @dev Wrappers over Solidity's arithmetic operations with added overflow
520  * checks.
521  *
522  * Arithmetic operations in Solidity wrap on overflow. This can easily result
523  * in bugs, because programmers usually assume that an overflow raises an
524  * error, which is the standard behavior in high level programming languages.
525  * `SafeMath` restores this intuition by reverting the transaction when an
526  * operation overflows.
527  *
528  * Using this library instead of the unchecked operations eliminates an entire
529  * class of bugs, so it's recommended to use it always.
530  */
531 
532 /**
533  * @dev Implementation of the {IERC20} interface.
534  *
535  * This implementation is agnostic to the way tokens are created. This means
536  * that a supply mechanism has to be added in a derived contract using {_mint}.
537  * For a generic mechanism see {ERC20Mintable}.
538  *
539  * TIP: For a detailed writeup see our guide
540  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
541  * to implement supply mechanisms].
542  *
543  * We have followed general OpenZeppelin guidelines: functions revert instead
544  * of returning `false` on failure. This behavior is nonetheless conventional
545  * and does not conflict with the expectations of ERC20 applications.
546  *
547  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
548  * This allows applications to reconstruct the allowance for all accounts just
549  * by listening to said events. Other implementations of the EIP may not emit
550  * these events, as it isn't required by the specification.
551  *
552  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
553  * functions have been added to mitigate the well-known issues around setting
554  * allowances. See {IERC20-approve}.
555  */
556 contract ERC20 is Context, IERC20 {
557     using SafeMath for uint256;
558 
559     mapping (address => uint256) private _balances;
560 
561     mapping (address => mapping (address => uint256)) private _allowances;
562 
563     uint256 private _totalSupply;
564 
565     /**
566      * @dev See {IERC20-totalSupply}.
567      */
568     function totalSupply() public view returns (uint256) {
569         return _totalSupply;
570     }
571 
572     /**
573      * @dev See {IERC20-balanceOf}.
574      */
575     function balanceOf(address account) public view returns (uint256) {
576         return _balances[account];
577     }
578 
579     /**
580      * @dev See {IERC20-transfer}.
581      *
582      * Requirements:
583      *
584      * - `recipient` cannot be the zero address.
585      * - the caller must have a balance of at least `amount`.
586      */
587     function transfer(address recipient, uint256 amount) public returns (bool) {
588         _transfer(_msgSender(), recipient, amount);
589         return true;
590     }
591 
592     /**
593      * @dev See {IERC20-allowance}.
594      */
595     function allowance(address owner, address spender) public view returns (uint256) {
596         return _allowances[owner][spender];
597     }
598 
599     /**
600      * @dev See {IERC20-approve}.
601      *
602      * Requirements:
603      *
604      * - `spender` cannot be the zero address.
605      */
606     function approve(address spender, uint256 amount) public returns (bool) {
607         _approve(_msgSender(), spender, amount);
608         return true;
609     }
610 
611     /**
612      * @dev See {IERC20-transferFrom}.
613      *
614      * Emits an {Approval} event indicating the updated allowance. This is not
615      * required by the EIP. See the note at the beginning of {ERC20};
616      *
617      * Requirements:
618      * - `sender` and `recipient` cannot be the zero address.
619      * - `sender` must have a balance of at least `amount`.
620      * - the caller must have allowance for `sender`'s tokens of at least
621      * `amount`.
622      */
623     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
624         _transfer(sender, recipient, amount);
625         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
626         return true;
627     }
628 
629     /**
630      * @dev Atomically increases the allowance granted to `spender` by the caller.
631      *
632      * This is an alternative to {approve} that can be used as a mitigation for
633      * problems described in {IERC20-approve}.
634      *
635      * Emits an {Approval} event indicating the updated allowance.
636      *
637      * Requirements:
638      *
639      * - `spender` cannot be the zero address.
640      */
641     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
642         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
643         return true;
644     }
645 
646     /**
647      * @dev Atomically decreases the allowance granted to `spender` by the caller.
648      *
649      * This is an alternative to {approve} that can be used as a mitigation for
650      * problems described in {IERC20-approve}.
651      *
652      * Emits an {Approval} event indicating the updated allowance.
653      *
654      * Requirements:
655      *
656      * - `spender` cannot be the zero address.
657      * - `spender` must have allowance for the caller of at least
658      * `subtractedValue`.
659      */
660     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
661         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
662         return true;
663     }
664 
665     /**
666      * @dev Moves tokens `amount` from `sender` to `recipient`.
667      *
668      * This is internal function is equivalent to {transfer}, and can be used to
669      * e.g. implement automatic token fees, slashing mechanisms, etc.
670      *
671      * Emits a {Transfer} event.
672      *
673      * Requirements:
674      *
675      * - `sender` cannot be the zero address.
676      * - `recipient` cannot be the zero address.
677      * - `sender` must have a balance of at least `amount`.
678      */
679     function _transfer(address sender, address recipient, uint256 amount) internal {
680         require(sender != address(0), "ERC20: transfer from the zero address");
681         require(recipient != address(0), "ERC20: transfer to the zero address");
682 
683         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
684         _balances[recipient] = _balances[recipient].add(amount);
685         emit Transfer(sender, recipient, amount);
686     }
687 
688     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
689      * the total supply.
690      *
691      * Emits a {Transfer} event with `from` set to the zero address.
692      *
693      * Requirements
694      *
695      * - `to` cannot be the zero address.
696      */
697     function _mint(address account, uint256 amount) internal {
698         require(account != address(0), "ERC20: mint to the zero address");
699 
700         _totalSupply = _totalSupply.add(amount);
701         _balances[account] = _balances[account].add(amount);
702         emit Transfer(address(0), account, amount);
703     }
704 
705     /**
706      * @dev Destroys `amount` tokens from `account`, reducing the
707      * total supply.
708      *
709      * Emits a {Transfer} event with `to` set to the zero address.
710      *
711      * Requirements
712      *
713      * - `account` cannot be the zero address.
714      * - `account` must have at least `amount` tokens.
715      */
716     function _burn(address account, uint256 amount) internal {
717         require(account != address(0), "ERC20: burn from the zero address");
718 
719         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
720         _totalSupply = _totalSupply.sub(amount);
721         emit Transfer(account, address(0), amount);
722     }
723 
724     /**
725      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
726      *
727      * This is internal function is equivalent to `approve`, and can be used to
728      * e.g. set automatic allowances for certain subsystems, etc.
729      *
730      * Emits an {Approval} event.
731      *
732      * Requirements:
733      *
734      * - `owner` cannot be the zero address.
735      * - `spender` cannot be the zero address.
736      */
737     function _approve(address owner, address spender, uint256 amount) internal {
738         require(owner != address(0), "ERC20: approve from the zero address");
739         require(spender != address(0), "ERC20: approve to the zero address");
740 
741         _allowances[owner][spender] = amount;
742         emit Approval(owner, spender, amount);
743     }
744 
745     /**
746      * @dev Destroys `amount` tokens from `account`.`amount` is then deducted
747      * from the caller's allowance.
748      *
749      * See {_burn} and {_approve}.
750      */
751     function _burnFrom(address account, uint256 amount) internal {
752         _burn(account, amount);
753         _approve(account, _msgSender(), _allowances[account][_msgSender()].sub(amount, "ERC20: burn amount exceeds allowance"));
754     }
755 }
756 
757 /**
758  * @dev Extension of {ERC20} that allows token holders to destroy both their own
759  * tokens and those that they have an allowance for, in a way that can be
760  * recognized off-chain (via event analysis).
761  */
762 contract ERC20Burnable is Context, ERC20 {
763     /**
764      * @dev Destroys `amount` tokens from the caller.
765      *
766      * See {ERC20-_burn}.
767      */
768     function burn(uint256 amount) public {
769         _burn(_msgSender(), amount);
770     }
771 
772     /**
773      * @dev See {ERC20-_burnFrom}.
774      */
775     function burnFrom(address account, uint256 amount) public {
776         _burnFrom(account, amount);
777     }
778 }
779 
780 /**
781  * @dev Optional functions from the ERC20 standard.
782  */
783 contract ERC20Detailed is IERC20 {
784     string private _name;
785     string private _symbol;
786     uint8 private _decimals;
787 
788     /**
789      * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of
790      * these values are immutable: they can only be set once during
791      * construction.
792      */
793     constructor (string memory name, string memory symbol, uint8 decimals) public {
794         _name = name;
795         _symbol = symbol;
796         _decimals = decimals;
797     }
798 
799     /**
800      * @dev Returns the name of the token.
801      */
802     function name() public view returns (string memory) {
803         return _name;
804     }
805 
806     /**
807      * @dev Returns the symbol of the token, usually a shorter version of the
808      * name.
809      */
810     function symbol() public view returns (string memory) {
811         return _symbol;
812     }
813 
814     /**
815      * @dev Returns the number of decimals used to get its user representation.
816      * For example, if `decimals` equals `2`, a balance of `505` tokens should
817      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
818      *
819      * Tokens usually opt for a value of 18, imitating the relationship between
820      * Ether and Wei.
821      *
822      * NOTE: This information is only used for _display_ purposes: it in
823      * no way affects any of the arithmetic of the contract, including
824      * {IERC20-balanceOf} and {IERC20-transfer}.
825      */
826     function decimals() public view returns (uint8) {
827         return _decimals;
828     }
829 }
830 
831 /**
832  * @title Roles
833  * @dev Library for managing addresses assigned to a Role.
834  */
835 library Roles {
836     struct Role {
837         mapping (address => bool) bearer;
838     }
839 
840     /**
841      * @dev Give an account access to this role.
842      */
843     function add(Role storage role, address account) internal {
844         require(!has(role, account), "Roles: account already has role");
845         role.bearer[account] = true;
846     }
847 
848     /**
849      * @dev Remove an account's access to this role.
850      */
851     function remove(Role storage role, address account) internal {
852         require(has(role, account), "Roles: account does not have role");
853         role.bearer[account] = false;
854     }
855 
856     /**
857      * @dev Check if an account has this role.
858      * @return bool
859      */
860     function has(Role storage role, address account) internal view returns (bool) {
861         require(account != address(0), "Roles: account is the zero address");
862         return role.bearer[account];
863     }
864 }
865 
866 contract MinterRole is Context {
867     using Roles for Roles.Role;
868 
869     event MinterAdded(address indexed account);
870     event MinterRemoved(address indexed account);
871 
872     Roles.Role private _minters;
873 
874     constructor () internal {
875         _addMinter(_msgSender());
876     }
877 
878     modifier onlyMinter() {
879         require(isMinter(_msgSender()), "MinterRole: caller does not have the Minter role");
880         _;
881     }
882 
883     function isMinter(address account) public view returns (bool) {
884         return _minters.has(account);
885     }
886 
887     function addMinter(address account) public onlyMinter {
888         _addMinter(account);
889     }
890 
891     function renounceMinter() public {
892         _removeMinter(_msgSender());
893     }
894 
895     function _addMinter(address account) internal {
896         _minters.add(account);
897         emit MinterAdded(account);
898     }
899 
900     function _removeMinter(address account) internal {
901         _minters.remove(account);
902         emit MinterRemoved(account);
903     }
904 }
905 
906 /*
907     Copyright 2019 dYdX Trading Inc.
908 
909     Licensed under the Apache License, Version 2.0 (the "License");
910     you may not use this file except in compliance with the License.
911     You may obtain a copy of the License at
912 
913     http://www.apache.org/licenses/LICENSE-2.0
914 
915     Unless required by applicable law or agreed to in writing, software
916     distributed under the License is distributed on an "AS IS" BASIS,
917     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
918     See the License for the specific language governing permissions and
919     limitations under the License.
920 */
921 /**
922  * @title Require
923  * @author dYdX
924  *
925  * Stringifies parameters to pretty-print revert messages. Costs more gas than regular require()
926  */
927 library Require {
928 
929     // ============ Constants ============
930 
931     uint256 constant ASCII_ZERO = 48; // '0'
932     uint256 constant ASCII_RELATIVE_ZERO = 87; // 'a' - 10
933     uint256 constant ASCII_LOWER_EX = 120; // 'x'
934     bytes2 constant COLON = 0x3a20; // ': '
935     bytes2 constant COMMA = 0x2c20; // ', '
936     bytes2 constant LPAREN = 0x203c; // ' <'
937     byte constant RPAREN = 0x3e; // '>'
938     uint256 constant FOUR_BIT_MASK = 0xf;
939 
940     // ============ Library Functions ============
941 
942     function that(
943         bool must,
944         bytes32 file,
945         bytes32 reason
946     )
947     internal
948     pure
949     {
950         if (!must) {
951             revert(
952                 string(
953                     abi.encodePacked(
954                         stringifyTruncated(file),
955                         COLON,
956                         stringifyTruncated(reason)
957                     )
958                 )
959             );
960         }
961     }
962 
963     function that(
964         bool must,
965         bytes32 file,
966         bytes32 reason,
967         uint256 payloadA
968     )
969     internal
970     pure
971     {
972         if (!must) {
973             revert(
974                 string(
975                     abi.encodePacked(
976                         stringifyTruncated(file),
977                         COLON,
978                         stringifyTruncated(reason),
979                         LPAREN,
980                         stringify(payloadA),
981                         RPAREN
982                     )
983                 )
984             );
985         }
986     }
987 
988     function that(
989         bool must,
990         bytes32 file,
991         bytes32 reason,
992         uint256 payloadA,
993         uint256 payloadB
994     )
995     internal
996     pure
997     {
998         if (!must) {
999             revert(
1000                 string(
1001                     abi.encodePacked(
1002                         stringifyTruncated(file),
1003                         COLON,
1004                         stringifyTruncated(reason),
1005                         LPAREN,
1006                         stringify(payloadA),
1007                         COMMA,
1008                         stringify(payloadB),
1009                         RPAREN
1010                     )
1011                 )
1012             );
1013         }
1014     }
1015 
1016     function that(
1017         bool must,
1018         bytes32 file,
1019         bytes32 reason,
1020         address payloadA
1021     )
1022     internal
1023     pure
1024     {
1025         if (!must) {
1026             revert(
1027                 string(
1028                     abi.encodePacked(
1029                         stringifyTruncated(file),
1030                         COLON,
1031                         stringifyTruncated(reason),
1032                         LPAREN,
1033                         stringify(payloadA),
1034                         RPAREN
1035                     )
1036                 )
1037             );
1038         }
1039     }
1040 
1041     function that(
1042         bool must,
1043         bytes32 file,
1044         bytes32 reason,
1045         address payloadA,
1046         uint256 payloadB
1047     )
1048     internal
1049     pure
1050     {
1051         if (!must) {
1052             revert(
1053                 string(
1054                     abi.encodePacked(
1055                         stringifyTruncated(file),
1056                         COLON,
1057                         stringifyTruncated(reason),
1058                         LPAREN,
1059                         stringify(payloadA),
1060                         COMMA,
1061                         stringify(payloadB),
1062                         RPAREN
1063                     )
1064                 )
1065             );
1066         }
1067     }
1068 
1069     function that(
1070         bool must,
1071         bytes32 file,
1072         bytes32 reason,
1073         address payloadA,
1074         uint256 payloadB,
1075         uint256 payloadC
1076     )
1077     internal
1078     pure
1079     {
1080         if (!must) {
1081             revert(
1082                 string(
1083                     abi.encodePacked(
1084                         stringifyTruncated(file),
1085                         COLON,
1086                         stringifyTruncated(reason),
1087                         LPAREN,
1088                         stringify(payloadA),
1089                         COMMA,
1090                         stringify(payloadB),
1091                         COMMA,
1092                         stringify(payloadC),
1093                         RPAREN
1094                     )
1095                 )
1096             );
1097         }
1098     }
1099 
1100     function that(
1101         bool must,
1102         bytes32 file,
1103         bytes32 reason,
1104         bytes32 payloadA
1105     )
1106     internal
1107     pure
1108     {
1109         if (!must) {
1110             revert(
1111                 string(
1112                     abi.encodePacked(
1113                         stringifyTruncated(file),
1114                         COLON,
1115                         stringifyTruncated(reason),
1116                         LPAREN,
1117                         stringify(payloadA),
1118                         RPAREN
1119                     )
1120                 )
1121             );
1122         }
1123     }
1124 
1125     function that(
1126         bool must,
1127         bytes32 file,
1128         bytes32 reason,
1129         bytes32 payloadA,
1130         uint256 payloadB,
1131         uint256 payloadC
1132     )
1133     internal
1134     pure
1135     {
1136         if (!must) {
1137             revert(
1138                 string(
1139                     abi.encodePacked(
1140                         stringifyTruncated(file),
1141                         COLON,
1142                         stringifyTruncated(reason),
1143                         LPAREN,
1144                         stringify(payloadA),
1145                         COMMA,
1146                         stringify(payloadB),
1147                         COMMA,
1148                         stringify(payloadC),
1149                         RPAREN
1150                     )
1151                 )
1152             );
1153         }
1154     }
1155 
1156     // ============ Private Functions ============
1157 
1158     function stringifyTruncated(
1159         bytes32 input
1160     )
1161     private
1162     pure
1163     returns (bytes memory)
1164     {
1165         // put the input bytes into the result
1166         bytes memory result = abi.encodePacked(input);
1167 
1168         // determine the length of the input by finding the location of the last non-zero byte
1169         for (uint256 i = 32; i > 0; ) {
1170             // reverse-for-loops with unsigned integer
1171             /* solium-disable-next-line security/no-modify-for-iter-var */
1172             i--;
1173 
1174             // find the last non-zero byte in order to determine the length
1175             if (result[i] != 0) {
1176                 uint256 length = i + 1;
1177 
1178                 /* solium-disable-next-line security/no-inline-assembly */
1179                 assembly {
1180                     mstore(result, length) // r.length = length;
1181                 }
1182 
1183                 return result;
1184             }
1185         }
1186 
1187         // all bytes are zero
1188         return new bytes(0);
1189     }
1190 
1191     function stringify(
1192         uint256 input
1193     )
1194     private
1195     pure
1196     returns (bytes memory)
1197     {
1198         if (input == 0) {
1199             return "0";
1200         }
1201 
1202         // get the final string length
1203         uint256 j = input;
1204         uint256 length;
1205         while (j != 0) {
1206             length++;
1207             j /= 10;
1208         }
1209 
1210         // allocate the string
1211         bytes memory bstr = new bytes(length);
1212 
1213         // populate the string starting with the least-significant character
1214         j = input;
1215         for (uint256 i = length; i > 0; ) {
1216             // reverse-for-loops with unsigned integer
1217             /* solium-disable-next-line security/no-modify-for-iter-var */
1218             i--;
1219 
1220             // take last decimal digit
1221             bstr[i] = byte(uint8(ASCII_ZERO + (j % 10)));
1222 
1223             // remove the last decimal digit
1224             j /= 10;
1225         }
1226 
1227         return bstr;
1228     }
1229 
1230     function stringify(
1231         address input
1232     )
1233     private
1234     pure
1235     returns (bytes memory)
1236     {
1237         uint256 z = uint256(input);
1238 
1239         // addresses are "0x" followed by 20 bytes of data which take up 2 characters each
1240         bytes memory result = new bytes(42);
1241 
1242         // populate the result with "0x"
1243         result[0] = byte(uint8(ASCII_ZERO));
1244         result[1] = byte(uint8(ASCII_LOWER_EX));
1245 
1246         // for each byte (starting from the lowest byte), populate the result with two characters
1247         for (uint256 i = 0; i < 20; i++) {
1248             // each byte takes two characters
1249             uint256 shift = i * 2;
1250 
1251             // populate the least-significant character
1252             result[41 - shift] = char(z & FOUR_BIT_MASK);
1253             z = z >> 4;
1254 
1255             // populate the most-significant character
1256             result[40 - shift] = char(z & FOUR_BIT_MASK);
1257             z = z >> 4;
1258         }
1259 
1260         return result;
1261     }
1262 
1263     function stringify(
1264         bytes32 input
1265     )
1266     private
1267     pure
1268     returns (bytes memory)
1269     {
1270         uint256 z = uint256(input);
1271 
1272         // bytes32 are "0x" followed by 32 bytes of data which take up 2 characters each
1273         bytes memory result = new bytes(66);
1274 
1275         // populate the result with "0x"
1276         result[0] = byte(uint8(ASCII_ZERO));
1277         result[1] = byte(uint8(ASCII_LOWER_EX));
1278 
1279         // for each byte (starting from the lowest byte), populate the result with two characters
1280         for (uint256 i = 0; i < 32; i++) {
1281             // each byte takes two characters
1282             uint256 shift = i * 2;
1283 
1284             // populate the least-significant character
1285             result[65 - shift] = char(z & FOUR_BIT_MASK);
1286             z = z >> 4;
1287 
1288             // populate the most-significant character
1289             result[64 - shift] = char(z & FOUR_BIT_MASK);
1290             z = z >> 4;
1291         }
1292 
1293         return result;
1294     }
1295 
1296     function char(
1297         uint256 input
1298     )
1299     private
1300     pure
1301     returns (byte)
1302     {
1303         // return ASCII digit (0-9)
1304         if (input < 10) {
1305             return byte(uint8(input + ASCII_ZERO));
1306         }
1307 
1308         // return ASCII letter (a-f)
1309         return byte(uint8(input + ASCII_RELATIVE_ZERO));
1310     }
1311 }
1312 
1313 /*
1314     Copyright 2019 ZeroEx Intl.
1315 
1316     Licensed under the Apache License, Version 2.0 (the "License");
1317     you may not use this file except in compliance with the License.
1318     You may obtain a copy of the License at
1319 
1320     http://www.apache.org/licenses/LICENSE-2.0
1321 
1322     Unless required by applicable law or agreed to in writing, software
1323     distributed under the License is distributed on an "AS IS" BASIS,
1324     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1325     See the License for the specific language governing permissions and
1326     limitations under the License.
1327 */
1328 library LibEIP712 {
1329 
1330     // Hash of the EIP712 Domain Separator Schema
1331     // keccak256(abi.encodePacked(
1332     //     "EIP712Domain(",
1333     //     "string name,",
1334     //     "string version,",
1335     //     "uint256 chainId,",
1336     //     "address verifyingContract",
1337     //     ")"
1338     // ))
1339     bytes32 constant internal _EIP712_DOMAIN_SEPARATOR_SCHEMA_HASH = 0x8b73c3c69bb8fe3d512ecc4cf759cc79239f7b179b0ffacaa9a75d522b39400f;
1340 
1341     /// @dev Calculates a EIP712 domain separator.
1342     /// @param name The EIP712 domain name.
1343     /// @param version The EIP712 domain version.
1344     /// @param verifyingContract The EIP712 verifying contract.
1345     /// @return EIP712 domain separator.
1346     function hashEIP712Domain(
1347         string memory name,
1348         string memory version,
1349         uint256 chainId,
1350         address verifyingContract
1351     )
1352     internal
1353     pure
1354     returns (bytes32 result)
1355     {
1356         bytes32 schemaHash = _EIP712_DOMAIN_SEPARATOR_SCHEMA_HASH;
1357 
1358         // Assembly for more efficient computing:
1359         // keccak256(abi.encodePacked(
1360         //     _EIP712_DOMAIN_SEPARATOR_SCHEMA_HASH,
1361         //     keccak256(bytes(name)),
1362         //     keccak256(bytes(version)),
1363         //     chainId,
1364         //     uint256(verifyingContract)
1365         // ))
1366 
1367         assembly {
1368         // Calculate hashes of dynamic data
1369             let nameHash := keccak256(add(name, 32), mload(name))
1370             let versionHash := keccak256(add(version, 32), mload(version))
1371 
1372         // Load free memory pointer
1373             let memPtr := mload(64)
1374 
1375         // Store params in memory
1376             mstore(memPtr, schemaHash)
1377             mstore(add(memPtr, 32), nameHash)
1378             mstore(add(memPtr, 64), versionHash)
1379             mstore(add(memPtr, 96), chainId)
1380             mstore(add(memPtr, 128), verifyingContract)
1381 
1382         // Compute hash
1383             result := keccak256(memPtr, 160)
1384         }
1385         return result;
1386     }
1387 
1388     /// @dev Calculates EIP712 encoding for a hash struct with a given domain hash.
1389     /// @param eip712DomainHash Hash of the domain domain separator data, computed
1390     ///                         with getDomainHash().
1391     /// @param hashStruct The EIP712 hash struct.
1392     /// @return EIP712 hash applied to the given EIP712 Domain.
1393     function hashEIP712Message(bytes32 eip712DomainHash, bytes32 hashStruct)
1394     internal
1395     pure
1396     returns (bytes32 result)
1397     {
1398         // Assembly for more efficient computing:
1399         // keccak256(abi.encodePacked(
1400         //     EIP191_HEADER,
1401         //     EIP712_DOMAIN_HASH,
1402         //     hashStruct
1403         // ));
1404 
1405         assembly {
1406         // Load free memory pointer
1407             let memPtr := mload(64)
1408 
1409             mstore(memPtr, 0x1901000000000000000000000000000000000000000000000000000000000000)  // EIP191 header
1410             mstore(add(memPtr, 2), eip712DomainHash)                                            // EIP712 domain hash
1411             mstore(add(memPtr, 34), hashStruct)                                                 // Hash of struct
1412 
1413         // Compute hash
1414             result := keccak256(memPtr, 66)
1415         }
1416         return result;
1417     }
1418 }
1419 
1420 /*
1421     Copyright 2020 Dynamic Dollar Devs, based on the works of the Empty Set Squad
1422 
1423     Licensed under the Apache License, Version 2.0 (the "License");
1424     you may not use this file except in compliance with the License.
1425     You may obtain a copy of the License at
1426 
1427     http://www.apache.org/licenses/LICENSE-2.0
1428 
1429     Unless required by applicable law or agreed to in writing, software
1430     distributed under the License is distributed on an "AS IS" BASIS,
1431     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1432     See the License for the specific language governing permissions and
1433     limitations under the License.
1434 */
1435 library Constants {
1436     /* Chain */
1437     uint256 private constant CHAIN_ID = 1; // Mainnet
1438 
1439     /* Bootstrapping */
1440     uint256 private constant BOOTSTRAPPING_PERIOD = 150; // 150 epochs
1441     uint256 private constant BOOTSTRAPPING_PRICE = 154e16; // 1.54 USDC (targeting 4.5% inflation)
1442 
1443     /* Oracle */
1444     address private constant USDC = address(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48);
1445     uint256 private constant ORACLE_RESERVE_MINIMUM = 1e10; // 10,000 USDC
1446 
1447     /* Bonding */
1448     uint256 private constant INITIAL_STAKE_MULTIPLE = 1e6; // 100 DSD -> 100M DSDS
1449 
1450     /* Epoch */
1451     struct EpochStrategy {
1452         uint256 offset;
1453         uint256 start;
1454         uint256 period;
1455     }
1456 
1457     uint256 private constant EPOCH_OFFSET = 0;
1458     uint256 private constant EPOCH_START = 1606348800;
1459     uint256 private constant EPOCH_PERIOD = 7200;
1460 
1461     /* Governance */
1462     uint256 private constant GOVERNANCE_PERIOD = 36;
1463     uint256 private constant GOVERNANCE_QUORUM = 33e16; // 33%
1464     uint256 private constant GOVERNANCE_SUPER_MAJORITY = 66e16; // 66%
1465     uint256 private constant GOVERNANCE_EMERGENCY_DELAY = 6; // 6 epochs
1466 
1467     /* DAO */
1468     uint256 private constant ADVANCE_INCENTIVE = 1e20; // 100 DSD
1469     uint256 private constant DAO_EXIT_LOCKUP_EPOCHS = 36; // 36 epochs fluid
1470 
1471     /* Pool */
1472     uint256 private constant POOL_EXIT_LOCKUP_EPOCHS = 12; // 12 epochs fluid
1473 
1474     /* Market */
1475     uint256 private constant COUPON_EXPIRATION = 360;
1476     uint256 private constant DEBT_RATIO_CAP = 35e16; // 35%
1477 
1478     /* Regulator */
1479     uint256 private constant SUPPLY_CHANGE_DIVISOR = 12e18; // 12
1480     uint256 private constant SUPPLY_CHANGE_LIMIT = 10e16; // 10%
1481     uint256 private constant ORACLE_POOL_RATIO = 40; // 40%
1482 
1483     /**
1484      * Getters
1485      */
1486     function getUsdcAddress() internal pure returns (address) {
1487         return USDC;
1488     }
1489 
1490     function getOracleReserveMinimum() internal pure returns (uint256) {
1491         return ORACLE_RESERVE_MINIMUM;
1492     }
1493 
1494     function getEpochStrategy() internal pure returns (EpochStrategy memory) {
1495         return EpochStrategy({
1496             offset: EPOCH_OFFSET,
1497             start: EPOCH_START,
1498             period: EPOCH_PERIOD
1499         });
1500     }
1501 
1502     function getInitialStakeMultiple() internal pure returns (uint256) {
1503         return INITIAL_STAKE_MULTIPLE;
1504     }
1505 
1506     function getBootstrappingPeriod() internal pure returns (uint256) {
1507         return BOOTSTRAPPING_PERIOD;
1508     }
1509 
1510     function getBootstrappingPrice() internal pure returns (Decimal.D256 memory) {
1511         return Decimal.D256({value: BOOTSTRAPPING_PRICE});
1512     }
1513 
1514     function getGovernancePeriod() internal pure returns (uint256) {
1515         return GOVERNANCE_PERIOD;
1516     }
1517 
1518     function getGovernanceQuorum() internal pure returns (Decimal.D256 memory) {
1519         return Decimal.D256({value: GOVERNANCE_QUORUM});
1520     }
1521 
1522     function getGovernanceSuperMajority() internal pure returns (Decimal.D256 memory) {
1523         return Decimal.D256({value: GOVERNANCE_SUPER_MAJORITY});
1524     }
1525 
1526     function getGovernanceEmergencyDelay() internal pure returns (uint256) {
1527         return GOVERNANCE_EMERGENCY_DELAY;
1528     }
1529 
1530     function getAdvanceIncentive() internal pure returns (uint256) {
1531         return ADVANCE_INCENTIVE;
1532     }
1533 
1534     function getDAOExitLockupEpochs() internal pure returns (uint256) {
1535         return DAO_EXIT_LOCKUP_EPOCHS;
1536     }
1537 
1538     function getPoolExitLockupEpochs() internal pure returns (uint256) {
1539         return POOL_EXIT_LOCKUP_EPOCHS;
1540     }
1541 
1542     function getCouponExpiration() internal pure returns (uint256) {
1543         return COUPON_EXPIRATION;
1544     }
1545 
1546     function getDebtRatioCap() internal pure returns (Decimal.D256 memory) {
1547         return Decimal.D256({value: DEBT_RATIO_CAP});
1548     }
1549 
1550     function getSupplyChangeLimit() internal pure returns (Decimal.D256 memory) {
1551         return Decimal.D256({value: SUPPLY_CHANGE_LIMIT});
1552     }
1553 
1554     function getSupplyChangeDivisor() internal pure returns (Decimal.D256 memory) {
1555         return Decimal.D256({value: SUPPLY_CHANGE_DIVISOR});
1556     }
1557 
1558     function getOraclePoolRatio() internal pure returns (uint256) {
1559         return ORACLE_POOL_RATIO;
1560     }
1561 
1562     function getChainId() internal pure returns (uint256) {
1563         return CHAIN_ID;
1564     }
1565 }
1566 
1567 /*
1568     Copyright 2020 Dynamic Dollar Devs, based on the works of the Empty Set Squad
1569 
1570     Licensed under the Apache License, Version 2.0 (the "License");
1571     you may not use this file except in compliance with the License.
1572     You may obtain a copy of the License at
1573 
1574     http://www.apache.org/licenses/LICENSE-2.0
1575 
1576     Unless required by applicable law or agreed to in writing, software
1577     distributed under the License is distributed on an "AS IS" BASIS,
1578     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1579     See the License for the specific language governing permissions and
1580     limitations under the License.
1581 */
1582 contract Permittable is ERC20Detailed, ERC20 {
1583     bytes32 constant FILE = "Permittable";
1584 
1585     // keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");
1586     bytes32 public constant EIP712_PERMIT_TYPEHASH = 0x6e71edae12b1b97f4d1f60370fef10105fa2faae0126114a169c64845d6126c9;
1587     string private constant EIP712_VERSION = "1";
1588 
1589     bytes32 public EIP712_DOMAIN_SEPARATOR;
1590 
1591     mapping(address => uint256) nonces;
1592 
1593     constructor() public {
1594         EIP712_DOMAIN_SEPARATOR = LibEIP712.hashEIP712Domain(name(), EIP712_VERSION, Constants.getChainId(), address(this));
1595     }
1596 
1597     function permit(
1598         address owner,
1599         address spender,
1600         uint256 value,
1601         uint256 deadline,
1602         uint8 v,
1603         bytes32 r,
1604         bytes32 s
1605     ) external {
1606         bytes32 digest = LibEIP712.hashEIP712Message(
1607             EIP712_DOMAIN_SEPARATOR,
1608             keccak256(abi.encode(
1609                 EIP712_PERMIT_TYPEHASH,
1610                 owner,
1611                 spender,
1612                 value,
1613                 nonces[owner]++,
1614                 deadline
1615             ))
1616         );
1617 
1618         address recovered = ecrecover(digest, v, r, s);
1619         Require.that(
1620             recovered == owner,
1621             FILE,
1622             "Invalid signature"
1623         );
1624 
1625         Require.that(
1626             recovered != address(0),
1627             FILE,
1628             "Zero address"
1629         );
1630 
1631         Require.that(
1632             now <= deadline,
1633             FILE,
1634             "Expired"
1635         );
1636 
1637         _approve(owner, spender, value);
1638     }
1639 }
1640 
1641 /*
1642     Copyright 2020 Dynamic Dollar Devs, based on the works of the Empty Set Squad
1643 
1644     Licensed under the Apache License, Version 2.0 (the "License");
1645     you may not use this file except in compliance with the License.
1646     You may obtain a copy of the License at
1647 
1648     http://www.apache.org/licenses/LICENSE-2.0
1649 
1650     Unless required by applicable law or agreed to in writing, software
1651     distributed under the License is distributed on an "AS IS" BASIS,
1652     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1653     See the License for the specific language governing permissions and
1654     limitations under the License.
1655 */
1656 contract IDollar is IERC20 {
1657     function burn(uint256 amount) public;
1658     function burnFrom(address account, uint256 amount) public;
1659     function mint(address account, uint256 amount) public returns (bool);
1660 }
1661 
1662 /*
1663     Copyright 2020 Dynamic Dollar Devs, based on the works of the Empty Set Squad
1664 
1665     Licensed under the Apache License, Version 2.0 (the "License");
1666     you may not use this file except in compliance with the License.
1667     You may obtain a copy of the License at
1668 
1669     http://www.apache.org/licenses/LICENSE-2.0
1670 
1671     Unless required by applicable law or agreed to in writing, software
1672     distributed under the License is distributed on an "AS IS" BASIS,
1673     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1674     See the License for the specific language governing permissions and
1675     limitations under the License.
1676 */
1677 contract Dollar is IDollar, MinterRole, ERC20Detailed, Permittable, ERC20Burnable {
1678 
1679     constructor()
1680     ERC20Detailed("Dynamic Set Dollar", "DSD", 18)
1681     Permittable()
1682     public
1683     { }
1684 
1685     function mint(address account, uint256 amount) public onlyMinter returns (bool) {
1686         _mint(account, amount);
1687         return true;
1688     }
1689 
1690     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
1691         _transfer(sender, recipient, amount);
1692         if (allowance(sender, _msgSender()) != uint256(-1)) {
1693             _approve(
1694                 sender,
1695                 _msgSender(),
1696                 allowance(sender, _msgSender()).sub(amount, "Dollar: transfer amount exceeds allowance"));
1697         }
1698         return true;
1699     }
1700 }
1701 
1702 interface IUniswapV2Factory {
1703     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
1704 
1705     function feeTo() external view returns (address);
1706     function feeToSetter() external view returns (address);
1707 
1708     function getPair(address tokenA, address tokenB) external view returns (address pair);
1709     function allPairs(uint) external view returns (address pair);
1710     function allPairsLength() external view returns (uint);
1711 
1712     function createPair(address tokenA, address tokenB) external returns (address pair);
1713 
1714     function setFeeTo(address) external;
1715     function setFeeToSetter(address) external;
1716 }
1717 
1718 interface IUniswapV2Pair {
1719     event Approval(address indexed owner, address indexed spender, uint value);
1720     event Transfer(address indexed from, address indexed to, uint value);
1721 
1722     function name() external pure returns (string memory);
1723     function symbol() external pure returns (string memory);
1724     function decimals() external pure returns (uint8);
1725     function totalSupply() external view returns (uint);
1726     function balanceOf(address owner) external view returns (uint);
1727     function allowance(address owner, address spender) external view returns (uint);
1728 
1729     function approve(address spender, uint value) external returns (bool);
1730     function transfer(address to, uint value) external returns (bool);
1731     function transferFrom(address from, address to, uint value) external returns (bool);
1732 
1733     function DOMAIN_SEPARATOR() external view returns (bytes32);
1734     function PERMIT_TYPEHASH() external pure returns (bytes32);
1735     function nonces(address owner) external view returns (uint);
1736 
1737     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
1738 
1739     event Mint(address indexed sender, uint amount0, uint amount1);
1740     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
1741     event Swap(
1742         address indexed sender,
1743         uint amount0In,
1744         uint amount1In,
1745         uint amount0Out,
1746         uint amount1Out,
1747         address indexed to
1748     );
1749     event Sync(uint112 reserve0, uint112 reserve1);
1750 
1751     function MINIMUM_LIQUIDITY() external pure returns (uint);
1752     function factory() external view returns (address);
1753     function token0() external view returns (address);
1754     function token1() external view returns (address);
1755     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
1756     function price0CumulativeLast() external view returns (uint);
1757     function price1CumulativeLast() external view returns (uint);
1758     function kLast() external view returns (uint);
1759 
1760     function mint(address to) external returns (uint liquidity);
1761     function burn(address to) external returns (uint amount0, uint amount1);
1762     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
1763     function skim(address to) external;
1764     function sync() external;
1765 
1766     function initialize(address, address) external;
1767 }
1768 
1769 // computes square roots using the babylonian method
1770 // https://en.wikipedia.org/wiki/Methods_of_computing_square_roots#Babylonian_method
1771 library Babylonian {
1772     function sqrt(uint y) internal pure returns (uint z) {
1773         if (y > 3) {
1774             z = y;
1775             uint x = y / 2 + 1;
1776             while (x < z) {
1777                 z = x;
1778                 x = (y / x + x) / 2;
1779             }
1780         } else if (y != 0) {
1781             z = 1;
1782         }
1783         // else z = 0
1784     }
1785 }
1786 
1787 // a library for handling binary fixed point numbers (https://en.wikipedia.org/wiki/Q_(number_format))
1788 library FixedPoint {
1789     // range: [0, 2**112 - 1]
1790     // resolution: 1 / 2**112
1791     struct uq112x112 {
1792         uint224 _x;
1793     }
1794 
1795     // range: [0, 2**144 - 1]
1796     // resolution: 1 / 2**112
1797     struct uq144x112 {
1798         uint _x;
1799     }
1800 
1801     uint8 private constant RESOLUTION = 112;
1802     uint private constant Q112 = uint(1) << RESOLUTION;
1803     uint private constant Q224 = Q112 << RESOLUTION;
1804 
1805     // encode a uint112 as a UQ112x112
1806     function encode(uint112 x) internal pure returns (uq112x112 memory) {
1807         return uq112x112(uint224(x) << RESOLUTION);
1808     }
1809 
1810     // encodes a uint144 as a UQ144x112
1811     function encode144(uint144 x) internal pure returns (uq144x112 memory) {
1812         return uq144x112(uint256(x) << RESOLUTION);
1813     }
1814 
1815     // divide a UQ112x112 by a uint112, returning a UQ112x112
1816     function div(uq112x112 memory self, uint112 x) internal pure returns (uq112x112 memory) {
1817         require(x != 0, 'FixedPoint: DIV_BY_ZERO');
1818         return uq112x112(self._x / uint224(x));
1819     }
1820 
1821     // multiply a UQ112x112 by a uint, returning a UQ144x112
1822     // reverts on overflow
1823     function mul(uq112x112 memory self, uint y) internal pure returns (uq144x112 memory) {
1824         uint z;
1825         require(y == 0 || (z = uint(self._x) * y) / y == uint(self._x), "FixedPoint: MULTIPLICATION_OVERFLOW");
1826         return uq144x112(z);
1827     }
1828 
1829     // returns a UQ112x112 which represents the ratio of the numerator to the denominator
1830     // equivalent to encode(numerator).div(denominator)
1831     function fraction(uint112 numerator, uint112 denominator) internal pure returns (uq112x112 memory) {
1832         require(denominator > 0, "FixedPoint: DIV_BY_ZERO");
1833         return uq112x112((uint224(numerator) << RESOLUTION) / denominator);
1834     }
1835 
1836     // decode a UQ112x112 into a uint112 by truncating after the radix point
1837     function decode(uq112x112 memory self) internal pure returns (uint112) {
1838         return uint112(self._x >> RESOLUTION);
1839     }
1840 
1841     // decode a UQ144x112 into a uint144 by truncating after the radix point
1842     function decode144(uq144x112 memory self) internal pure returns (uint144) {
1843         return uint144(self._x >> RESOLUTION);
1844     }
1845 
1846     // take the reciprocal of a UQ112x112
1847     function reciprocal(uq112x112 memory self) internal pure returns (uq112x112 memory) {
1848         require(self._x != 0, 'FixedPoint: ZERO_RECIPROCAL');
1849         return uq112x112(uint224(Q224 / self._x));
1850     }
1851 
1852     // square root of a UQ112x112
1853     function sqrt(uq112x112 memory self) internal pure returns (uq112x112 memory) {
1854         return uq112x112(uint224(Babylonian.sqrt(uint256(self._x)) << 56));
1855     }
1856 }
1857 
1858 // library with helper methods for oracles that are concerned with computing average prices
1859 library UniswapV2OracleLibrary {
1860     using FixedPoint for *;
1861 
1862     // helper function that returns the current block timestamp within the range of uint32, i.e. [0, 2**32 - 1]
1863     function currentBlockTimestamp() internal view returns (uint32) {
1864         return uint32(block.timestamp % 2 ** 32);
1865     }
1866 
1867     // produces the cumulative price using counterfactuals to save gas and avoid a call to sync.
1868     function currentCumulativePrices(address pair)
1869     internal
1870     view
1871     returns (uint price0Cumulative, uint price1Cumulative, uint32 blockTimestamp) {
1872         blockTimestamp = currentBlockTimestamp();
1873         price0Cumulative = IUniswapV2Pair(pair).price0CumulativeLast();
1874         price1Cumulative = IUniswapV2Pair(pair).price1CumulativeLast();
1875 
1876         // if time has elapsed since the last update on the pair, mock the accumulated price values
1877         (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast) = IUniswapV2Pair(pair).getReserves();
1878         if (blockTimestampLast != blockTimestamp) {
1879             // subtraction overflow is desired
1880             uint32 timeElapsed = blockTimestamp - blockTimestampLast;
1881             // addition overflow is desired
1882             // counterfactual
1883             price0Cumulative += uint(FixedPoint.fraction(reserve1, reserve0)._x) * timeElapsed;
1884             // counterfactual
1885             price1Cumulative += uint(FixedPoint.fraction(reserve0, reserve1)._x) * timeElapsed;
1886         }
1887     }
1888 }
1889 
1890 library UniswapV2Library {
1891     using SafeMath for uint;
1892 
1893     // returns sorted token addresses, used to handle return values from pairs sorted in this order
1894     function sortTokens(address tokenA, address tokenB) internal pure returns (address token0, address token1) {
1895         require(tokenA != tokenB, 'UniswapV2Library: IDENTICAL_ADDRESSES');
1896         (token0, token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);
1897         require(token0 != address(0), 'UniswapV2Library: ZERO_ADDRESS');
1898     }
1899 
1900     // calculates the CREATE2 address for a pair without making any external calls
1901     function pairFor(address factory, address tokenA, address tokenB) internal pure returns (address pair) {
1902         (address token0, address token1) = sortTokens(tokenA, tokenB);
1903         pair = address(uint(keccak256(abi.encodePacked(
1904                 hex'ff',
1905                 factory,
1906                 keccak256(abi.encodePacked(token0, token1)),
1907                 hex'96e8ac4277198ff8b6f785478aa9a39f403cb768dd02cbee326c3e7da348845f' // init code hash
1908             ))));
1909     }
1910 
1911     // fetches and sorts the reserves for a pair
1912     function getReserves(address factory, address tokenA, address tokenB) internal view returns (uint reserveA, uint reserveB) {
1913         (address token0,) = sortTokens(tokenA, tokenB);
1914         (uint reserve0, uint reserve1,) = IUniswapV2Pair(pairFor(factory, tokenA, tokenB)).getReserves();
1915         (reserveA, reserveB) = tokenA == token0 ? (reserve0, reserve1) : (reserve1, reserve0);
1916     }
1917 
1918     // given some amount of an asset and pair reserves, returns an equivalent amount of the other asset
1919     function quote(uint amountA, uint reserveA, uint reserveB) internal pure returns (uint amountB) {
1920         require(amountA > 0, 'UniswapV2Library: INSUFFICIENT_AMOUNT');
1921         require(reserveA > 0 && reserveB > 0, 'UniswapV2Library: INSUFFICIENT_LIQUIDITY');
1922         amountB = amountA.mul(reserveB) / reserveA;
1923     }
1924 }
1925 
1926 /*
1927     Copyright 2020 Dynamic Dollar Devs, based on the works of the Empty Set Squad
1928 
1929     Licensed under the Apache License, Version 2.0 (the "License");
1930     you may not use this file except in compliance with the License.
1931     You may obtain a copy of the License at
1932 
1933     http://www.apache.org/licenses/LICENSE-2.0
1934 
1935     Unless required by applicable law or agreed to in writing, software
1936     distributed under the License is distributed on an "AS IS" BASIS,
1937     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1938     See the License for the specific language governing permissions and
1939     limitations under the License.
1940 */
1941 contract IOracle {
1942     function setup() public;
1943     function capture() public returns (Decimal.D256 memory, bool);
1944     function pair() external view returns (address);
1945 }
1946 
1947 /*
1948     Copyright 2020 Dynamic Dollar Devs, based on the works of the Empty Set Squad
1949 
1950     Licensed under the Apache License, Version 2.0 (the "License");
1951     you may not use this file except in compliance with the License.
1952     You may obtain a copy of the License at
1953 
1954     http://www.apache.org/licenses/LICENSE-2.0
1955 
1956     Unless required by applicable law or agreed to in writing, software
1957     distributed under the License is distributed on an "AS IS" BASIS,
1958     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1959     See the License for the specific language governing permissions and
1960     limitations under the License.
1961 */
1962 contract IUSDC {
1963     function isBlacklisted(address _account) external view returns (bool);
1964 }
1965 
1966 /*
1967     Copyright 2020 Dynamic Dollar Devs, based on the works of the Empty Set Squad
1968 
1969     Licensed under the Apache License, Version 2.0 (the "License");
1970     you may not use this file except in compliance with the License.
1971     You may obtain a copy of the License at
1972 
1973     http://www.apache.org/licenses/LICENSE-2.0
1974 
1975     Unless required by applicable law or agreed to in writing, software
1976     distributed under the License is distributed on an "AS IS" BASIS,
1977     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1978     See the License for the specific language governing permissions and
1979     limitations under the License.
1980 */
1981 contract Oracle is IOracle {
1982     using Decimal for Decimal.D256;
1983 
1984     bytes32 private constant FILE = "Oracle";
1985     address private constant UNISWAP_FACTORY = address(0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f);
1986 
1987     address internal _dao;
1988     address internal _dollar;
1989 
1990     bool internal _initialized;
1991     IUniswapV2Pair internal _pair;
1992     uint256 internal _index;
1993     uint256 internal _cumulative;
1994     uint32 internal _timestamp;
1995 
1996     uint256 internal _reserve;
1997 
1998     constructor (address dollar) public {
1999         _dao = msg.sender;
2000         _dollar = dollar;
2001     }
2002 
2003     function setup() public onlyDao {
2004         _pair = IUniswapV2Pair(IUniswapV2Factory(UNISWAP_FACTORY).createPair(_dollar, usdc()));
2005 
2006         (address token0, address token1) = (_pair.token0(), _pair.token1());
2007         _index = _dollar == token0 ? 0 : 1;
2008 
2009         Require.that(
2010             _index == 0 || _dollar == token1,
2011             FILE,
2012             "Døllar not found"
2013         );
2014     }
2015 
2016     /**
2017      * Trades/Liquidity: (1) Initializes reserve and blockTimestampLast (can calculate a price)
2018      *                   (2) Has non-zero cumulative prices
2019      *
2020      * Steps: (1) Captures a reference blockTimestampLast
2021      *        (2) First reported value
2022      */
2023     function capture() public onlyDao returns (Decimal.D256 memory, bool) {
2024         if (_initialized) {
2025             return updateOracle();
2026         } else {
2027             initializeOracle();
2028             return (Decimal.one(), false);
2029         }
2030     }
2031 
2032     function initializeOracle() private {
2033         IUniswapV2Pair pair = _pair;
2034         uint256 priceCumulative = _index == 0 ?
2035             pair.price0CumulativeLast() :
2036             pair.price1CumulativeLast();
2037         (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast) = pair.getReserves();
2038         if(reserve0 != 0 && reserve1 != 0 && blockTimestampLast != 0) {
2039             _cumulative = priceCumulative;
2040             _timestamp = blockTimestampLast;
2041             _initialized = true;
2042             _reserve = _index == 0 ? reserve1 : reserve0; // get counter's reserve
2043         }
2044     }
2045 
2046     function updateOracle() private returns (Decimal.D256 memory, bool) {
2047         Decimal.D256 memory price = updatePrice();
2048         uint256 lastReserve = updateReserve();
2049         bool isBlacklisted = IUSDC(usdc()).isBlacklisted(address(_pair));
2050 
2051         bool valid = true;
2052         if (lastReserve < Constants.getOracleReserveMinimum()) {
2053             valid = false;
2054         }
2055         if (_reserve < Constants.getOracleReserveMinimum()) {
2056             valid = false;
2057         }
2058         if (isBlacklisted) {
2059             valid = false;
2060         }
2061 
2062         return (price, valid);
2063     }
2064 
2065     function updatePrice() private returns (Decimal.D256 memory) {
2066         (uint256 price0Cumulative, uint256 price1Cumulative, uint32 blockTimestamp) =
2067         UniswapV2OracleLibrary.currentCumulativePrices(address(_pair));
2068         uint32 timeElapsed = blockTimestamp - _timestamp; // overflow is desired
2069         uint256 priceCumulative = _index == 0 ? price0Cumulative : price1Cumulative;
2070         Decimal.D256 memory price = Decimal.ratio((priceCumulative - _cumulative) / timeElapsed, 2**112);
2071 
2072         _timestamp = blockTimestamp;
2073         _cumulative = priceCumulative;
2074 
2075         return price.mul(1e12);
2076     }
2077 
2078     function updateReserve() private returns (uint256) {
2079         uint256 lastReserve = _reserve;
2080         (uint112 reserve0, uint112 reserve1,) = _pair.getReserves();
2081         _reserve = _index == 0 ? reserve1 : reserve0; // get counter's reserve
2082 
2083         return lastReserve;
2084     }
2085 
2086     function usdc() internal view returns (address) {
2087         return Constants.getUsdcAddress();
2088     }
2089 
2090     function pair() external view returns (address) {
2091         return address(_pair);
2092     }
2093 
2094     function reserve() external view returns (uint256) {
2095         return _reserve;
2096     }
2097 
2098     modifier onlyDao() {
2099         Require.that(
2100             msg.sender == _dao,
2101             FILE,
2102             "Not dao"
2103         );
2104 
2105         _;
2106     }
2107 }
2108 
2109 /*
2110     Copyright 2020 Dynamic Dollar Devs, based on the works of the Empty Set Squad
2111 
2112     Licensed under the Apache License, Version 2.0 (the "License");
2113     you may not use this file except in compliance with the License.
2114     You may obtain a copy of the License at
2115 
2116     http://www.apache.org/licenses/LICENSE-2.0
2117 
2118     Unless required by applicable law or agreed to in writing, software
2119     distributed under the License is distributed on an "AS IS" BASIS,
2120     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
2121     See the License for the specific language governing permissions and
2122     limitations under the License.
2123 */
2124 contract IDAO {
2125     function epoch() external view returns (uint256);
2126 }
2127 
2128 /*
2129     Copyright 2020 Dynamic Dollar Devs, based on the works of the Empty Set Squad
2130 
2131     Licensed under the Apache License, Version 2.0 (the "License");
2132     you may not use this file except in compliance with the License.
2133     You may obtain a copy of the License at
2134 
2135     http://www.apache.org/licenses/LICENSE-2.0
2136 
2137     Unless required by applicable law or agreed to in writing, software
2138     distributed under the License is distributed on an "AS IS" BASIS,
2139     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
2140     See the License for the specific language governing permissions and
2141     limitations under the License.
2142 */
2143 contract PoolAccount {
2144     enum Status {
2145         Frozen,
2146         Fluid,
2147         Locked
2148     }
2149 
2150     struct State {
2151         uint256 staged;
2152         uint256 claimable;
2153         uint256 bonded;
2154         uint256 phantom;
2155         uint256 fluidUntil;
2156     }
2157 }
2158 
2159 contract PoolStorage {
2160     struct Provider {
2161         IDAO dao;
2162         IDollar dollar;
2163         IERC20 univ2;
2164     }
2165     
2166     struct Balance {
2167         uint256 staged;
2168         uint256 claimable;
2169         uint256 bonded;
2170         uint256 phantom;
2171     }
2172 
2173     struct State {
2174         Balance balance;
2175         Provider provider;
2176 
2177         bool paused;
2178 
2179         mapping(address => PoolAccount.State) accounts;
2180     }
2181 }
2182 
2183 contract PoolState {
2184     PoolStorage.State _state;
2185 }
2186 
2187 /*
2188     Copyright 2020 Dynamic Dollar Devs, based on the works of the Empty Set Squad
2189 
2190     Licensed under the Apache License, Version 2.0 (the "License");
2191     you may not use this file except in compliance with the License.
2192     You may obtain a copy of the License at
2193 
2194     http://www.apache.org/licenses/LICENSE-2.0
2195 
2196     Unless required by applicable law or agreed to in writing, software
2197     distributed under the License is distributed on an "AS IS" BASIS,
2198     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
2199     See the License for the specific language governing permissions and
2200     limitations under the License.
2201 */
2202 contract PoolGetters is PoolState {
2203     using SafeMath for uint256;
2204 
2205     /**
2206      * Global
2207      */
2208 
2209     function usdc() public view returns (address) {
2210         return Constants.getUsdcAddress();
2211     }
2212 
2213     function dao() public view returns (IDAO) {
2214         return _state.provider.dao;
2215     }
2216 
2217     function dollar() public view returns (IDollar) {
2218         return _state.provider.dollar;
2219     }
2220 
2221     function univ2() public view returns (IERC20) {
2222         return _state.provider.univ2;
2223     }
2224 
2225     function totalBonded() public view returns (uint256) {
2226         return _state.balance.bonded;
2227     }
2228 
2229     function totalStaged() public view returns (uint256) {
2230         return _state.balance.staged;
2231     }
2232 
2233     function totalClaimable() public view returns (uint256) {
2234         return _state.balance.claimable;
2235     }
2236 
2237     function totalPhantom() public view returns (uint256) {
2238         return _state.balance.phantom;
2239     }
2240 
2241     function totalRewarded() public view returns (uint256) {
2242         return dollar().balanceOf(address(this)).sub(totalClaimable());
2243     }
2244 
2245     function paused() public view returns (bool) {
2246         return _state.paused;
2247     }
2248 
2249     /**
2250      * Account
2251      */
2252 
2253     function balanceOfStaged(address account) public view returns (uint256) {
2254         return _state.accounts[account].staged;
2255     }
2256 
2257     function balanceOfClaimable(address account) public view returns (uint256) {
2258         return _state.accounts[account].claimable;
2259     }
2260 
2261     function balanceOfBonded(address account) public view returns (uint256) {
2262         return _state.accounts[account].bonded;
2263     }
2264 
2265     function balanceOfPhantom(address account) public view returns (uint256) {
2266         return _state.accounts[account].phantom;
2267     }
2268 
2269     function balanceOfRewarded(address account) public view returns (uint256) {
2270         uint256 totalBonded = totalBonded();
2271         if (totalBonded == 0) {
2272             return 0;
2273         }
2274 
2275         uint256 totalRewardedWithPhantom = totalRewarded().add(totalPhantom());
2276         uint256 balanceOfRewardedWithPhantom = totalRewardedWithPhantom
2277             .mul(balanceOfBonded(account))
2278             .div(totalBonded);
2279 
2280         uint256 balanceOfPhantom = balanceOfPhantom(account);
2281         if (balanceOfRewardedWithPhantom > balanceOfPhantom) {
2282             return balanceOfRewardedWithPhantom.sub(balanceOfPhantom);
2283         }
2284         return 0;
2285     }
2286 
2287     function statusOf(address account) public view returns (PoolAccount.Status) {
2288         return epoch() >= _state.accounts[account].fluidUntil ?
2289             PoolAccount.Status.Frozen :
2290             PoolAccount.Status.Fluid;
2291     }
2292 
2293     /**
2294      * Epoch
2295      */
2296 
2297     function epoch() internal view returns (uint256) {
2298         return dao().epoch();
2299     }
2300 }
2301 
2302 /*
2303     Copyright 2020 Dynamic Dollar Devs, based on the works of the Empty Set Squad
2304 
2305     Licensed under the Apache License, Version 2.0 (the "License");
2306     you may not use this file except in compliance with the License.
2307     You may obtain a copy of the License at
2308 
2309     http://www.apache.org/licenses/LICENSE-2.0
2310 
2311     Unless required by applicable law or agreed to in writing, software
2312     distributed under the License is distributed on an "AS IS" BASIS,
2313     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
2314     See the License for the specific language governing permissions and
2315     limitations under the License.
2316 */
2317 contract PoolSetters is PoolState, PoolGetters {
2318     using SafeMath for uint256;
2319 
2320     /**
2321      * Global
2322      */
2323 
2324     function pause() internal {
2325         _state.paused = true;
2326     }
2327 
2328     /**
2329      * Account
2330      */
2331 
2332     function incrementBalanceOfBonded(address account, uint256 amount) internal {
2333         _state.accounts[account].bonded = _state.accounts[account].bonded.add(amount);
2334         _state.balance.bonded = _state.balance.bonded.add(amount);
2335     }
2336 
2337     function decrementBalanceOfBonded(address account, uint256 amount, string memory reason) internal {
2338         _state.accounts[account].bonded = _state.accounts[account].bonded.sub(amount, reason);
2339         _state.balance.bonded = _state.balance.bonded.sub(amount, reason);
2340     }
2341 
2342     function incrementBalanceOfStaged(address account, uint256 amount) internal {
2343         _state.accounts[account].staged = _state.accounts[account].staged.add(amount);
2344         _state.balance.staged = _state.balance.staged.add(amount);
2345     }
2346 
2347     function decrementBalanceOfStaged(address account, uint256 amount, string memory reason) internal {
2348         _state.accounts[account].staged = _state.accounts[account].staged.sub(amount, reason);
2349         _state.balance.staged = _state.balance.staged.sub(amount, reason);
2350     }
2351 
2352     function incrementBalanceOfClaimable(address account, uint256 amount) internal {
2353         _state.accounts[account].claimable = _state.accounts[account].claimable.add(amount);
2354         _state.balance.claimable = _state.balance.claimable.add(amount);
2355     }
2356 
2357     function decrementBalanceOfClaimable(address account, uint256 amount, string memory reason) internal {
2358         _state.accounts[account].claimable = _state.accounts[account].claimable.sub(amount, reason);
2359         _state.balance.claimable = _state.balance.claimable.sub(amount, reason);
2360     }
2361 
2362     function incrementBalanceOfPhantom(address account, uint256 amount) internal {
2363         _state.accounts[account].phantom = _state.accounts[account].phantom.add(amount);
2364         _state.balance.phantom = _state.balance.phantom.add(amount);
2365     }
2366 
2367     function decrementBalanceOfPhantom(address account, uint256 amount, string memory reason) internal {
2368         _state.accounts[account].phantom = _state.accounts[account].phantom.sub(amount, reason);
2369         _state.balance.phantom = _state.balance.phantom.sub(amount, reason);
2370     }
2371 
2372     function unfreeze(address account) internal {
2373         _state.accounts[account].fluidUntil = epoch().add(Constants.getPoolExitLockupEpochs());
2374     }
2375 }
2376 
2377 /*
2378     Copyright 2020 Dynamic Dollar Devs, based on the works of the Empty Set Squad
2379 
2380     Licensed under the Apache License, Version 2.0 (the "License");
2381     you may not use this file except in compliance with the License.
2382     You may obtain a copy of the License at
2383 
2384     http://www.apache.org/licenses/LICENSE-2.0
2385 
2386     Unless required by applicable law or agreed to in writing, software
2387     distributed under the License is distributed on an "AS IS" BASIS,
2388     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
2389     See the License for the specific language governing permissions and
2390     limitations under the License.
2391 */
2392 contract Liquidity is PoolGetters {
2393     address private constant UNISWAP_FACTORY = address(0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f);
2394 
2395     function addLiquidity(uint256 dollarAmount) internal returns (uint256, uint256) {
2396         (address dollar, address usdc) = (address(dollar()), usdc());
2397         (uint reserveA, uint reserveB) = getReserves(dollar, usdc);
2398 
2399         uint256 usdcAmount = (reserveA == 0 && reserveB == 0) ?
2400              dollarAmount :
2401              UniswapV2Library.quote(dollarAmount, reserveA, reserveB);
2402 
2403         address pair = address(univ2());
2404         IERC20(dollar).transfer(pair, dollarAmount);
2405         IERC20(usdc).transferFrom(msg.sender, pair, usdcAmount);
2406         return (usdcAmount, IUniswapV2Pair(pair).mint(address(this)));
2407     }
2408 
2409     // overridable for testing
2410     function getReserves(address tokenA, address tokenB) internal view returns (uint reserveA, uint reserveB) {
2411         (address token0,) = UniswapV2Library.sortTokens(tokenA, tokenB);
2412         (uint reserve0, uint reserve1,) = IUniswapV2Pair(UniswapV2Library.pairFor(UNISWAP_FACTORY, tokenA, tokenB)).getReserves();
2413         (reserveA, reserveB) = tokenA == token0 ? (reserve0, reserve1) : (reserve1, reserve0);
2414     }
2415 }
2416 
2417 /*
2418     Copyright 2020 Dynamic Dollar Devs, based on the works of the Empty Set Squad
2419 
2420     Licensed under the Apache License, Version 2.0 (the "License");
2421     you may not use this file except in compliance with the License.
2422     You may obtain a copy of the License at
2423 
2424     http://www.apache.org/licenses/LICENSE-2.0
2425 
2426     Unless required by applicable law or agreed to in writing, software
2427     distributed under the License is distributed on an "AS IS" BASIS,
2428     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
2429     See the License for the specific language governing permissions and
2430     limitations under the License.
2431 */
2432 contract Pool is PoolSetters, Liquidity {
2433     using SafeMath for uint256;
2434 
2435     constructor(address dollar, address univ2) public {
2436         _state.provider.dao = IDAO(msg.sender);
2437         _state.provider.dollar = IDollar(dollar);
2438         _state.provider.univ2 = IERC20(univ2);
2439     }
2440 
2441     bytes32 private constant FILE = "Pool";
2442 
2443     event Deposit(address indexed account, uint256 value);
2444     event Withdraw(address indexed account, uint256 value);
2445     event Claim(address indexed account, uint256 value);
2446     event Bond(address indexed account, uint256 start, uint256 value);
2447     event Unbond(address indexed account, uint256 start, uint256 value, uint256 newClaimable);
2448     event Provide(address indexed account, uint256 value, uint256 lessUsdc, uint256 newUniv2);
2449 
2450     function deposit(uint256 value) external onlyFrozen(msg.sender) notPaused {
2451         univ2().transferFrom(msg.sender, address(this), value);
2452         incrementBalanceOfStaged(msg.sender, value);
2453 
2454         balanceCheck();
2455 
2456         emit Deposit(msg.sender, value);
2457     }
2458 
2459     function withdraw(uint256 value) external onlyFrozen(msg.sender) {
2460         univ2().transfer(msg.sender, value);
2461         decrementBalanceOfStaged(msg.sender, value, "Pool: insufficient staged balance");
2462 
2463         balanceCheck();
2464 
2465         emit Withdraw(msg.sender, value);
2466     }
2467 
2468     function claim(uint256 value) external onlyFrozen(msg.sender) {
2469         dollar().transfer(msg.sender, value);
2470         decrementBalanceOfClaimable(msg.sender, value, "Pool: insufficient claimable balance");
2471 
2472         balanceCheck();
2473 
2474         emit Claim(msg.sender, value);
2475     }
2476 
2477     function bond(uint256 value) external notPaused {
2478         unfreeze(msg.sender);
2479 
2480         uint256 totalRewardedWithPhantom = totalRewarded().add(totalPhantom());
2481         uint256 newPhantom = totalBonded() == 0 ?
2482             totalRewarded() == 0 ? Constants.getInitialStakeMultiple().mul(value) : 0 :
2483             totalRewardedWithPhantom.mul(value).div(totalBonded());
2484 
2485         incrementBalanceOfBonded(msg.sender, value);
2486         incrementBalanceOfPhantom(msg.sender, newPhantom);
2487         decrementBalanceOfStaged(msg.sender, value, "Pool: insufficient staged balance");
2488 
2489         balanceCheck();
2490 
2491         emit Bond(msg.sender, epoch().add(1), value);
2492     }
2493 
2494     function unbond(uint256 value) external {
2495         unfreeze(msg.sender);
2496 
2497         uint256 balanceOfBonded = balanceOfBonded(msg.sender);
2498         Require.that(
2499             balanceOfBonded > 0,
2500             FILE,
2501             "insufficient bonded balance"
2502         );
2503 
2504         uint256 newClaimable = balanceOfRewarded(msg.sender).mul(value).div(balanceOfBonded);
2505         uint256 lessPhantom = balanceOfPhantom(msg.sender).mul(value).div(balanceOfBonded);
2506 
2507         incrementBalanceOfStaged(msg.sender, value);
2508         incrementBalanceOfClaimable(msg.sender, newClaimable);
2509         decrementBalanceOfBonded(msg.sender, value, "Pool: insufficient bonded balance");
2510         decrementBalanceOfPhantom(msg.sender, lessPhantom, "Pool: insufficient phantom balance");
2511 
2512         balanceCheck();
2513 
2514         emit Unbond(msg.sender, epoch().add(1), value, newClaimable);
2515     }
2516 
2517     function provide(uint256 value) external onlyFrozen(msg.sender) notPaused {
2518         Require.that(
2519             totalBonded() > 0,
2520             FILE,
2521             "insufficient total bonded"
2522         );
2523 
2524         Require.that(
2525             totalRewarded() > 0,
2526             FILE,
2527             "insufficient total rewarded"
2528         );
2529 
2530         Require.that(
2531             balanceOfRewarded(msg.sender) >= value,
2532             FILE,
2533             "insufficient rewarded balance"
2534         );
2535 
2536         (uint256 lessUsdc, uint256 newUniv2) = addLiquidity(value);
2537 
2538         uint256 totalRewardedWithPhantom = totalRewarded().add(totalPhantom()).add(value);
2539         uint256 newPhantomFromBonded = totalRewardedWithPhantom.mul(newUniv2).div(totalBonded());
2540 
2541         incrementBalanceOfBonded(msg.sender, newUniv2);
2542         incrementBalanceOfPhantom(msg.sender, value.add(newPhantomFromBonded));
2543 
2544 
2545         balanceCheck();
2546 
2547         emit Provide(msg.sender, value, lessUsdc, newUniv2);
2548     }
2549 
2550     function emergencyWithdraw(address token, uint256 value) external onlyDao {
2551         IERC20(token).transfer(address(dao()), value);
2552     }
2553 
2554     function emergencyPause() external onlyDao {
2555         pause();
2556     }
2557 
2558     function balanceCheck() private {
2559         Require.that(
2560             univ2().balanceOf(address(this)) >= totalStaged().add(totalBonded()),
2561             FILE,
2562             "Inconsistent UNI-V2 balances"
2563         );
2564     }
2565 
2566     modifier onlyFrozen(address account) {
2567         Require.that(
2568             statusOf(account) == PoolAccount.Status.Frozen,
2569             FILE,
2570             "Not frozen"
2571         );
2572 
2573         _;
2574     }
2575 
2576     modifier onlyDao() {
2577         Require.that(
2578             msg.sender == address(dao()),
2579             FILE,
2580             "Not dao"
2581         );
2582 
2583         _;
2584     }
2585 
2586     modifier notPaused() {
2587         Require.that(
2588             !paused(),
2589             FILE,
2590             "Paused"
2591         );
2592 
2593         _;
2594     }
2595 }
2596 
2597 /**
2598  * Utility library of inline functions on addresses
2599  *
2600  * Source https://raw.githubusercontent.com/OpenZeppelin/openzeppelin-solidity/v2.1.3/contracts/utils/Address.sol
2601  * This contract is copied here and renamed from the original to avoid clashes in the compiled artifacts
2602  * when the user imports a zos-lib contract (that transitively causes this contract to be compiled and added to the
2603  * build/artifacts folder) as well as the vanilla Address implementation from an openzeppelin version.
2604  */
2605 library OpenZeppelinUpgradesAddress {
2606     /**
2607      * Returns whether the target address is a contract
2608      * @dev This function will return false if invoked during the constructor of a contract,
2609      * as the code is not actually created until after the constructor finishes.
2610      * @param account address of the account to check
2611      * @return whether the target address is a contract
2612      */
2613     function isContract(address account) internal view returns (bool) {
2614         uint256 size;
2615         // XXX Currently there is no better way to check if there is a contract in an address
2616         // than to check the size of the code at that address.
2617         // See https://ethereum.stackexchange.com/a/14016/36603
2618         // for more details about how this works.
2619         // TODO Check this again before the Serenity release, because all addresses will be
2620         // contracts then.
2621         // solhint-disable-next-line no-inline-assembly
2622         assembly { size := extcodesize(account) }
2623         return size > 0;
2624     }
2625 }
2626 
2627 /*
2628     Copyright 2020 Dynamic Dollar Devs, based on the works of the Empty Set Squad
2629 
2630     Licensed under the Apache License, Version 2.0 (the "License");
2631     you may not use this file except in compliance with the License.
2632     You may obtain a copy of the License at
2633 
2634     http://www.apache.org/licenses/LICENSE-2.0
2635 
2636     Unless required by applicable law or agreed to in writing, software
2637     distributed under the License is distributed on an "AS IS" BASIS,
2638     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
2639     See the License for the specific language governing permissions and
2640     limitations under the License.
2641 */
2642 contract Account {
2643     enum Status {
2644         Frozen,
2645         Fluid,
2646         Locked
2647     }
2648 
2649     struct State {
2650         uint256 staged;
2651         uint256 balance;
2652         mapping(uint256 => uint256) coupons;
2653         mapping(address => uint256) couponAllowances;
2654         uint256 fluidUntil;
2655         uint256 lockedUntil;
2656     }
2657 }
2658 
2659 contract Epoch {
2660     struct Global {
2661         uint256 start;
2662         uint256 period;
2663         uint256 current;
2664     }
2665 
2666     struct Coupons {
2667         uint256 outstanding;
2668         uint256 expiration;
2669         uint256[] expiring;
2670     }
2671 
2672     struct State {
2673         uint256 bonded;
2674         Coupons coupons;
2675     }
2676 }
2677 
2678 contract Candidate {
2679     enum Vote {
2680         UNDECIDED,
2681         APPROVE,
2682         REJECT
2683     }
2684 
2685     struct State {
2686         uint256 start;
2687         uint256 period;
2688         uint256 approve;
2689         uint256 reject;
2690         mapping(address => Vote) votes;
2691         bool initialized;
2692     }
2693 }
2694 
2695 contract Storage {
2696     struct Provider {
2697         IDollar dollar;
2698         IOracle oracle;
2699         address pool;
2700     }
2701 
2702     struct Balance {
2703         uint256 supply;
2704         uint256 bonded;
2705         uint256 staged;
2706         uint256 redeemable;
2707         uint256 debt;
2708         uint256 coupons;
2709     }
2710 
2711     struct State {
2712         Epoch.Global epoch;
2713         Balance balance;
2714         Provider provider;
2715 
2716         mapping(address => Account.State) accounts;
2717         mapping(uint256 => Epoch.State) epochs;
2718         mapping(address => Candidate.State) candidates;
2719     }
2720 }
2721 
2722 contract State {
2723     Storage.State _state;
2724 }
2725 
2726 /*
2727     Copyright 2018-2019 zOS Global Limited
2728     Copyright 2020 Dynamic Dollar Devs, based on the works of the Empty Set Squad
2729 
2730     Licensed under the Apache License, Version 2.0 (the "License");
2731     you may not use this file except in compliance with the License.
2732     You may obtain a copy of the License at
2733 
2734     http://www.apache.org/licenses/LICENSE-2.0
2735 
2736     Unless required by applicable law or agreed to in writing, software
2737     distributed under the License is distributed on an "AS IS" BASIS,
2738     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
2739     See the License for the specific language governing permissions and
2740     limitations under the License.
2741 */
2742 /**
2743  * Based off of, and designed to interface with, openzeppelin/upgrades package
2744  */
2745 contract Upgradeable is State {
2746     /**
2747      * @dev Storage slot with the address of the current implementation.
2748      * This is the keccak-256 hash of "eip1967.proxy.implementation" subtracted by 1, and is
2749      * validated in the constructor.
2750      */
2751     bytes32 private constant IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
2752 
2753     /**
2754      * @dev Emitted when the implementation is upgraded.
2755      * @param implementation Address of the new implementation.
2756      */
2757     event Upgraded(address indexed implementation);
2758 
2759     function initialize() public;
2760 
2761     /**
2762      * @dev Upgrades the proxy to a new implementation.
2763      * @param newImplementation Address of the new implementation.
2764      */
2765     function upgradeTo(address newImplementation) internal {
2766         setImplementation(newImplementation);
2767 
2768         (bool success, bytes memory reason) = newImplementation.delegatecall(abi.encodeWithSignature("initialize()"));
2769         require(success, string(reason));
2770 
2771         emit Upgraded(newImplementation);
2772     }
2773 
2774     /**
2775      * @dev Sets the implementation address of the proxy.
2776      * @param newImplementation Address of the new implementation.
2777      */
2778     function setImplementation(address newImplementation) private {
2779         require(OpenZeppelinUpgradesAddress.isContract(newImplementation), "Cannot set a proxy implementation to a non-contract address");
2780 
2781         bytes32 slot = IMPLEMENTATION_SLOT;
2782 
2783         assembly {
2784             sstore(slot, newImplementation)
2785         }
2786     }
2787 }
2788 
2789 /*
2790     Copyright 2020 Dynamic Dollar Devs, based on the works of the Empty Set Squad
2791 
2792     Licensed under the Apache License, Version 2.0 (the "License");
2793     you may not use this file except in compliance with the License.
2794     You may obtain a copy of the License at
2795 
2796     http://www.apache.org/licenses/LICENSE-2.0
2797 
2798     Unless required by applicable law or agreed to in writing, software
2799     distributed under the License is distributed on an "AS IS" BASIS,
2800     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
2801     See the License for the specific language governing permissions and
2802     limitations under the License.
2803 */
2804 contract Getters is State {
2805     using SafeMath for uint256;
2806     using Decimal for Decimal.D256;
2807 
2808     bytes32 private constant IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
2809 
2810     /**
2811      * ERC20 Interface
2812      */
2813 
2814     function name() public view returns (string memory) {
2815         return "Dynamic Set Dollar Stake";
2816     }
2817 
2818     function symbol() public view returns (string memory) {
2819         return "DSDS";
2820     }
2821 
2822     function decimals() public view returns (uint8) {
2823         return 18;
2824     }
2825 
2826     function balanceOf(address account) public view returns (uint256) {
2827         return _state.accounts[account].balance;
2828     }
2829 
2830     function totalSupply() public view returns (uint256) {
2831         return _state.balance.supply;
2832     }
2833 
2834     function allowance(address owner, address spender) external view returns (uint256) {
2835         return 0;
2836     }
2837 
2838     /**
2839      * Global
2840      */
2841 
2842     function dollar() public view returns (IDollar) {
2843         return _state.provider.dollar;
2844     }
2845 
2846     function oracle() public view returns (IOracle) {
2847         return _state.provider.oracle;
2848     }
2849 
2850     function pool() public view returns (address) {
2851         return _state.provider.pool;
2852     }
2853 
2854     function totalBonded() public view returns (uint256) {
2855         return _state.balance.bonded;
2856     }
2857 
2858     function totalStaged() public view returns (uint256) {
2859         return _state.balance.staged;
2860     }
2861 
2862     function totalDebt() public view returns (uint256) {
2863         return _state.balance.debt;
2864     }
2865 
2866     function totalRedeemable() public view returns (uint256) {
2867         return _state.balance.redeemable;
2868     }
2869 
2870     function totalCoupons() public view returns (uint256) {
2871         return _state.balance.coupons;
2872     }
2873 
2874     function totalNet() public view returns (uint256) {
2875         return dollar().totalSupply().sub(totalDebt());
2876     }
2877 
2878     /**
2879      * Account
2880      */
2881 
2882     function balanceOfStaged(address account) public view returns (uint256) {
2883         return _state.accounts[account].staged;
2884     }
2885 
2886     function balanceOfBonded(address account) public view returns (uint256) {
2887         uint256 totalSupply = totalSupply();
2888         if (totalSupply == 0) {
2889             return 0;
2890         }
2891         return totalBonded().mul(balanceOf(account)).div(totalSupply);
2892     }
2893 
2894     function balanceOfCoupons(address account, uint256 epoch) public view returns (uint256) {
2895         if (outstandingCoupons(epoch) == 0) {
2896             return 0;
2897         }
2898         return _state.accounts[account].coupons[epoch];
2899     }
2900 
2901     function statusOf(address account) public view returns (Account.Status) {
2902         if (_state.accounts[account].lockedUntil > epoch()) {
2903             return Account.Status.Locked;
2904         }
2905 
2906         return epoch() >= _state.accounts[account].fluidUntil ? Account.Status.Frozen : Account.Status.Fluid;
2907     }
2908 
2909     function allowanceCoupons(address owner, address spender) public view returns (uint256) {
2910         return _state.accounts[owner].couponAllowances[spender];
2911     }
2912 
2913     /**
2914      * Epoch
2915      */
2916 
2917     function epoch() public view returns (uint256) {
2918         return _state.epoch.current;
2919     }
2920 
2921     function epochTime() public view returns (uint256) {
2922         Constants.EpochStrategy memory current = Constants.getEpochStrategy();
2923 
2924         return epochTimeWithStrategy(current);
2925     }
2926 
2927     function epochTimeWithStrategy(Constants.EpochStrategy memory strategy) private view returns (uint256) {
2928         return blockTimestamp()
2929             .sub(strategy.start)
2930             .div(strategy.period)
2931             .add(strategy.offset);
2932     }
2933 
2934     // Overridable for testing
2935     function blockTimestamp() internal view returns (uint256) {
2936         return block.timestamp;
2937     }
2938 
2939     function outstandingCoupons(uint256 epoch) public view returns (uint256) {
2940         return _state.epochs[epoch].coupons.outstanding;
2941     }
2942 
2943     function couponsExpiration(uint256 epoch) public view returns (uint256) {
2944         return _state.epochs[epoch].coupons.expiration;
2945     }
2946 
2947     function expiringCoupons(uint256 epoch) public view returns (uint256) {
2948         return _state.epochs[epoch].coupons.expiring.length;
2949     }
2950 
2951     function expiringCouponsAtIndex(uint256 epoch, uint256 i) public view returns (uint256) {
2952         return _state.epochs[epoch].coupons.expiring[i];
2953     }
2954 
2955     function totalBondedAt(uint256 epoch) public view returns (uint256) {
2956         return _state.epochs[epoch].bonded;
2957     }
2958 
2959     function bootstrappingAt(uint256 epoch) public view returns (bool) {
2960         return epoch <= Constants.getBootstrappingPeriod();
2961     }
2962 
2963     /**
2964      * Governance
2965      */
2966 
2967     function recordedVote(address account, address candidate) public view returns (Candidate.Vote) {
2968         return _state.candidates[candidate].votes[account];
2969     }
2970 
2971     function startFor(address candidate) public view returns (uint256) {
2972         return _state.candidates[candidate].start;
2973     }
2974 
2975     function periodFor(address candidate) public view returns (uint256) {
2976         return _state.candidates[candidate].period;
2977     }
2978 
2979     function approveFor(address candidate) public view returns (uint256) {
2980         return _state.candidates[candidate].approve;
2981     }
2982 
2983     function rejectFor(address candidate) public view returns (uint256) {
2984         return _state.candidates[candidate].reject;
2985     }
2986 
2987     function votesFor(address candidate) public view returns (uint256) {
2988         return approveFor(candidate).add(rejectFor(candidate));
2989     }
2990 
2991     function isNominated(address candidate) public view returns (bool) {
2992         return _state.candidates[candidate].start > 0;
2993     }
2994 
2995     function isInitialized(address candidate) public view returns (bool) {
2996         return _state.candidates[candidate].initialized;
2997     }
2998 
2999     function implementation() public view returns (address impl) {
3000         bytes32 slot = IMPLEMENTATION_SLOT;
3001         assembly {
3002             impl := sload(slot)
3003         }
3004     }
3005 }
3006 
3007 /*
3008     Copyright 2020 Dynamic Dollar Devs, based on the works of the Empty Set Squad
3009 
3010     Licensed under the Apache License, Version 2.0 (the "License");
3011     you may not use this file except in compliance with the License.
3012     You may obtain a copy of the License at
3013 
3014     http://www.apache.org/licenses/LICENSE-2.0
3015 
3016     Unless required by applicable law or agreed to in writing, software
3017     distributed under the License is distributed on an "AS IS" BASIS,
3018     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
3019     See the License for the specific language governing permissions and
3020     limitations under the License.
3021 */
3022 contract Setters is State, Getters {
3023     using SafeMath for uint256;
3024 
3025     event Transfer(address indexed from, address indexed to, uint256 value);
3026 
3027     /**
3028      * ERC20 Interface
3029      */
3030 
3031     function transfer(address recipient, uint256 amount) external returns (bool) {
3032         return false;
3033     }
3034 
3035     function approve(address spender, uint256 amount) external returns (bool) {
3036         return false;
3037     }
3038 
3039     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool) {
3040         return false;
3041     }
3042 
3043     /**
3044      * Global
3045      */
3046 
3047     function incrementTotalBonded(uint256 amount) internal {
3048         _state.balance.bonded = _state.balance.bonded.add(amount);
3049     }
3050 
3051     function decrementTotalBonded(uint256 amount, string memory reason) internal {
3052         _state.balance.bonded = _state.balance.bonded.sub(amount, reason);
3053     }
3054 
3055     function incrementTotalDebt(uint256 amount) internal {
3056         _state.balance.debt = _state.balance.debt.add(amount);
3057     }
3058 
3059     function decrementTotalDebt(uint256 amount, string memory reason) internal {
3060         _state.balance.debt = _state.balance.debt.sub(amount, reason);
3061     }
3062 
3063     function setDebtToZero() internal {
3064         _state.balance.debt = 0;
3065     }
3066 
3067     function incrementTotalRedeemable(uint256 amount) internal {
3068         _state.balance.redeemable = _state.balance.redeemable.add(amount);
3069     }
3070 
3071     function decrementTotalRedeemable(uint256 amount, string memory reason) internal {
3072         _state.balance.redeemable = _state.balance.redeemable.sub(amount, reason);
3073     }
3074 
3075     /**
3076      * Account
3077      */
3078 
3079     function incrementBalanceOf(address account, uint256 amount) internal {
3080         _state.accounts[account].balance = _state.accounts[account].balance.add(amount);
3081         _state.balance.supply = _state.balance.supply.add(amount);
3082 
3083         emit Transfer(address(0), account, amount);
3084     }
3085 
3086     function decrementBalanceOf(address account, uint256 amount, string memory reason) internal {
3087         _state.accounts[account].balance = _state.accounts[account].balance.sub(amount, reason);
3088         _state.balance.supply = _state.balance.supply.sub(amount, reason);
3089 
3090         emit Transfer(account, address(0), amount);
3091     }
3092 
3093     function incrementBalanceOfStaged(address account, uint256 amount) internal {
3094         _state.accounts[account].staged = _state.accounts[account].staged.add(amount);
3095         _state.balance.staged = _state.balance.staged.add(amount);
3096     }
3097 
3098     function decrementBalanceOfStaged(address account, uint256 amount, string memory reason) internal {
3099         _state.accounts[account].staged = _state.accounts[account].staged.sub(amount, reason);
3100         _state.balance.staged = _state.balance.staged.sub(amount, reason);
3101     }
3102 
3103     function incrementBalanceOfCoupons(address account, uint256 epoch, uint256 amount) internal {
3104         _state.accounts[account].coupons[epoch] = _state.accounts[account].coupons[epoch].add(amount);
3105         _state.epochs[epoch].coupons.outstanding = _state.epochs[epoch].coupons.outstanding.add(amount);
3106         _state.balance.coupons = _state.balance.coupons.add(amount);
3107     }
3108 
3109     function decrementBalanceOfCoupons(address account, uint256 epoch, uint256 amount, string memory reason) internal {
3110         _state.accounts[account].coupons[epoch] = _state.accounts[account].coupons[epoch].sub(amount, reason);
3111         _state.epochs[epoch].coupons.outstanding = _state.epochs[epoch].coupons.outstanding.sub(amount, reason);
3112         _state.balance.coupons = _state.balance.coupons.sub(amount, reason);
3113     }
3114 
3115     function unfreeze(address account) internal {
3116         _state.accounts[account].fluidUntil = epoch().add(Constants.getDAOExitLockupEpochs());
3117     }
3118 
3119     function updateAllowanceCoupons(address owner, address spender, uint256 amount) internal {
3120         _state.accounts[owner].couponAllowances[spender] = amount;
3121     }
3122 
3123     function decrementAllowanceCoupons(address owner, address spender, uint256 amount, string memory reason) internal {
3124         _state.accounts[owner].couponAllowances[spender] =
3125             _state.accounts[owner].couponAllowances[spender].sub(amount, reason);
3126     }
3127 
3128     /**
3129      * Epoch
3130      */
3131 
3132     function incrementEpoch() internal {
3133         _state.epoch.current = _state.epoch.current.add(1);
3134     }
3135 
3136     function snapshotTotalBonded() internal {
3137         _state.epochs[epoch()].bonded = totalSupply();
3138     }
3139 
3140     function initializeCouponsExpiration(uint256 epoch, uint256 expiration) internal {
3141         _state.epochs[epoch].coupons.expiration = expiration;
3142         _state.epochs[expiration].coupons.expiring.push(epoch);
3143     }
3144 
3145     function eliminateOutstandingCoupons(uint256 epoch) internal {
3146         uint256 outstandingCouponsForEpoch = outstandingCoupons(epoch);
3147         if(outstandingCouponsForEpoch == 0) {
3148             return;
3149         }
3150         _state.balance.coupons = _state.balance.coupons.sub(outstandingCouponsForEpoch);
3151         _state.epochs[epoch].coupons.outstanding = 0;
3152     }
3153 
3154     /**
3155      * Governance
3156      */
3157 
3158     function createCandidate(address candidate, uint256 period) internal {
3159         _state.candidates[candidate].start = epoch();
3160         _state.candidates[candidate].period = period;
3161     }
3162 
3163     function recordVote(address account, address candidate, Candidate.Vote vote) internal {
3164         _state.candidates[candidate].votes[account] = vote;
3165     }
3166 
3167     function incrementApproveFor(address candidate, uint256 amount) internal {
3168         _state.candidates[candidate].approve = _state.candidates[candidate].approve.add(amount);
3169     }
3170 
3171     function decrementApproveFor(address candidate, uint256 amount, string memory reason) internal {
3172         _state.candidates[candidate].approve = _state.candidates[candidate].approve.sub(amount, reason);
3173     }
3174 
3175     function incrementRejectFor(address candidate, uint256 amount) internal {
3176         _state.candidates[candidate].reject = _state.candidates[candidate].reject.add(amount);
3177     }
3178 
3179     function decrementRejectFor(address candidate, uint256 amount, string memory reason) internal {
3180         _state.candidates[candidate].reject = _state.candidates[candidate].reject.sub(amount, reason);
3181     }
3182 
3183     function placeLock(address account, address candidate) internal {
3184         uint256 currentLock = _state.accounts[account].lockedUntil;
3185         uint256 newLock = startFor(candidate).add(periodFor(candidate));
3186         if (newLock > currentLock) {
3187             _state.accounts[account].lockedUntil = newLock;
3188         }
3189     }
3190 
3191     function initialized(address candidate) internal {
3192         _state.candidates[candidate].initialized = true;
3193     }
3194 }
3195 
3196 /*
3197     Copyright 2020 Dynamic Dollar Devs, based on the works of the Empty Set Squad
3198 
3199     Licensed under the Apache License, Version 2.0 (the "License");
3200     you may not use this file except in compliance with the License.
3201     You may obtain a copy of the License at
3202 
3203     http://www.apache.org/licenses/LICENSE-2.0
3204 
3205     Unless required by applicable law or agreed to in writing, software
3206     distributed under the License is distributed on an "AS IS" BASIS,
3207     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
3208     See the License for the specific language governing permissions and
3209     limitations under the License.
3210 */
3211 contract Permission is Setters {
3212 
3213     bytes32 private constant FILE = "Permission";
3214 
3215     // Can modify account state
3216     modifier onlyFrozenOrFluid(address account) {
3217         Require.that(
3218             statusOf(account) != Account.Status.Locked,
3219             FILE,
3220             "Not frozen or fluid"
3221         );
3222 
3223         _;
3224     }
3225 
3226     // Can participate in balance-dependant activities
3227     modifier onlyFrozenOrLocked(address account) {
3228         Require.that(
3229             statusOf(account) != Account.Status.Fluid,
3230             FILE,
3231             "Not frozen or locked"
3232         );
3233 
3234         _;
3235     }
3236 
3237     modifier initializer() {
3238         Require.that(
3239             !isInitialized(implementation()),
3240             FILE,
3241             "Already initialized"
3242         );
3243 
3244         initialized(implementation());
3245 
3246         _;
3247     }
3248 }
3249 
3250 /*
3251     Copyright 2020 Dynamic Dollar Devs, based on the works of the Empty Set Squad
3252 
3253     Licensed under the Apache License, Version 2.0 (the "License");
3254     you may not use this file except in compliance with the License.
3255     You may obtain a copy of the License at
3256 
3257     http://www.apache.org/licenses/LICENSE-2.0
3258 
3259     Unless required by applicable law or agreed to in writing, software
3260     distributed under the License is distributed on an "AS IS" BASIS,
3261     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
3262     See the License for the specific language governing permissions and
3263     limitations under the License.
3264 */
3265 contract Deployer1 is State, Permission, Upgradeable {
3266     function initialize() initializer public {
3267         _state.provider.dollar = new Dollar();
3268     }
3269 
3270     function implement(address implementation) external {
3271         upgradeTo(implementation);
3272     }
3273 }
3274 
3275 contract Deployer2 is State, Permission, Upgradeable {
3276     function initialize() initializer public {
3277         _state.provider.oracle = new Oracle(address(dollar()));
3278         oracle().setup();
3279     }
3280 
3281     function implement(address implementation) external {
3282         upgradeTo(implementation);
3283     }
3284 }
3285 
3286 contract Deployer3 is State, Permission, Upgradeable {
3287     function initialize() initializer public {
3288         _state.provider.pool = address(new Pool(address(dollar()), address(oracle().pair())));
3289     }
3290 
3291     function implement(address implementation) external {
3292         upgradeTo(implementation);
3293     }
3294 }