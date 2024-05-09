1 /**
2  *
3  * MIT License
4  *
5  * Copyright (c) 2019, MEXC Program Developers & OpenZeppelin Project.
6  *
7  * Permission is hereby granted, free of charge, to any person obtaining a copy
8  * of this software and associated documentation files (the "Software"), to deal
9  * in the Software without restriction, including without limitation the rights
10  * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
11  * copies of the Software, and to permit persons to whom the Software is
12  * furnished to do so, subject to the following conditions:
13  *
14  * The above copyright notice and this permission notice shall be included in all
15  * copies or substantial portions of the Software.
16  *
17  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
18  * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
19  * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
20  * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
21  * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
22  * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
23  * SOFTWARE.
24  *
25  */
26 pragma solidity ^0.5.0;
27 
28 /**
29  * @dev Wrappers over Solidity's arithmetic operations with added overflow
30  * checks.
31  *
32  * Arithmetic operations in Solidity wrap on overflow. This can easily result
33  * in bugs, because programmers usually assume that an overflow raises an
34  * error, which is the standard behavior in high level programming languages.
35  * `SafeMath` restores this intuition by reverting the transaction when an
36  * operation overflows.
37  *
38  * Using this library instead of the unchecked operations eliminates an entire
39  * class of bugs, so it's recommended to use it always.
40  */
41 library SafeMath {
42     /**
43      * @dev Returns the addition of two unsigned integers, reverting on
44      * overflow.
45      *
46      * Counterpart to Solidity's `+` operator.
47      *
48      * Requirements:
49      * - Addition cannot overflow.
50      */
51     function add(uint256 a, uint256 b) internal pure returns (uint256) {
52         uint256 c = a + b;
53         require(c >= a, "SafeMath: addition overflow");
54 
55         return c;
56     }
57 
58     /**
59      * @dev Returns the subtraction of two unsigned integers, reverting on
60      * overflow (when the result is negative).
61      *
62      * Counterpart to Solidity's `-` operator.
63      *
64      * Requirements:
65      * - Subtraction cannot overflow.
66      */
67     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
68         require(b <= a, "SafeMath: subtraction overflow");
69         uint256 c = a - b;
70 
71         return c;
72     }
73 
74     /**
75      * @dev Returns the multiplication of two unsigned integers, reverting on
76      * overflow.
77      *
78      * Counterpart to Solidity's `*` operator.
79      *
80      * Requirements:
81      * - Multiplication cannot overflow.
82      */
83     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
84         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
85         // benefit is lost if 'b' is also tested.
86         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
87         if (a == 0) {
88             return 0;
89         }
90 
91         uint256 c = a * b;
92         require(c / a == b, "SafeMath: multiplication overflow");
93 
94         return c;
95     }
96 
97     /**
98      * @dev Returns the integer division of two unsigned integers. Reverts on
99      * division by zero. The result is rounded towards zero.
100      *
101      * Counterpart to Solidity's `/` operator. Note: this function uses a
102      * `revert` opcode (which leaves remaining gas untouched) while Solidity
103      * uses an invalid opcode to revert (consuming all remaining gas).
104      *
105      * Requirements:
106      * - The divisor cannot be zero.
107      */
108     function div(uint256 a, uint256 b) internal pure returns (uint256) {
109         // Solidity only automatically asserts when dividing by 0
110         require(b > 0, "SafeMath: division by zero");
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
129         require(b != 0, "SafeMath: modulo by zero");
130         return a % b;
131     }
132 }
133 
134 /**
135  * @dev Contract module that helps prevent reentrant calls to a function.
136  *
137  * Inheriting from `ReentrancyGuard` will make the `nonReentrant` modifier
138  * available, which can be aplied to functions to make sure there are no nested
139  * (reentrant) calls to them.
140  *
141  * Note that because there is a single `nonReentrant` guard, functions marked as
142  * `nonReentrant` may not call one another. This can be worked around by making
143  * those functions `private`, and then adding `external` `nonReentrant` entry
144  * points to them.
145  */
146 contract ReentrancyGuard {
147     /// @dev counter to allow mutex lock with only one SSTORE operation
148     uint256 private _guardCounter;
149 
150     constructor () internal {
151         // The counter starts at one to prevent changing it from zero to a non-zero
152         // value, which is a more expensive operation.
153         _guardCounter = 1;
154     }
155 
156     /**
157      * @dev Prevents a contract from calling itself, directly or indirectly.
158      * Calling a `nonReentrant` function from another `nonReentrant`
159      * function is not supported. It is possible to prevent this from happening
160      * by making the `nonReentrant` function external, and make it call a
161      * `private` function that does the actual work.
162      */
163     modifier nonReentrant() {
164         _guardCounter += 1;
165         uint256 localCounter = _guardCounter;
166         _;
167         require(localCounter == _guardCounter, "ReentrancyGuard: reentrant call");
168     }
169 }
170 
171 /**
172  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
173  * the optional functions; to access them see `ERC20Detailed`.
174  */
175 interface IERC20 {
176     /**
177      * @dev Returns the amount of tokens in existence.
178      */
179     function totalSupply() external view returns (uint256);
180 
181     /**
182      * @dev Returns the amount of tokens owned by `account`.
183      */
184     function balanceOf(address account) external view returns (uint256);
185 
186     /**
187      * @dev Moves `amount` tokens from the caller's account to `recipient`.
188      *
189      * Returns a boolean value indicating whether the operation succeeded.
190      *
191      * Emits a `Transfer` event.
192      */
193     function transfer(address recipient, uint256 amount) external returns (bool);
194 
195     /**
196      * @dev Returns the remaining number of tokens that `spender` will be
197      * allowed to spend on behalf of `owner` through `transferFrom`. This is
198      * zero by default.
199      *
200      * This value changes when `approve` or `transferFrom` are called.
201      */
202     function allowance(address owner, address spender) external view returns (uint256);
203 
204     /**
205      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
206      *
207      * Returns a boolean value indicating whether the operation succeeded.
208      *
209      * > Beware that changing an allowance with this method brings the risk
210      * that someone may use both the old and the new allowance by unfortunate
211      * transaction ordering. One possible solution to mitigate this race
212      * condition is to first reduce the spender's allowance to 0 and set the
213      * desired value afterwards:
214      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
215      *
216      * Emits an `Approval` event.
217      */
218     function approve(address spender, uint256 amount) external returns (bool);
219 
220     /**
221      * @dev Moves `amount` tokens from `sender` to `recipient` using the
222      * allowance mechanism. `amount` is then deducted from the caller's
223      * allowance.
224      *
225      * Returns a boolean value indicating whether the operation succeeded.
226      *
227      * Emits a `Transfer` event.
228      */
229     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
230 
231     /**
232      * @dev Emitted when `value` tokens are moved from one account (`from`) to
233      * another (`to`).
234      *
235      * Note that `value` may be zero.
236      */
237     event Transfer(address indexed from, address indexed to, uint256 value);
238 
239     /**
240      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
241      * a call to `approve`. `value` is the new allowance.
242      */
243     event Approval(address indexed owner, address indexed spender, uint256 value);
244 }
245 
246 /**
247  * @dev Implementation of the `IERC20` interface.
248  *
249  * This implementation is agnostic to the way tokens are created. This means
250  * that a supply mechanism has to be added in a derived contract using `_mint`.
251  * For a generic mechanism see `ERC20Mintable`.
252  *
253  * *For a detailed writeup see our guide [How to implement supply
254  * mechanisms](https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226).*
255  *
256  * We have followed general OpenZeppelin guidelines: functions revert instead
257  * of returning `false` on failure. This behavior is nonetheless conventional
258  * and does not conflict with the expectations of ERC20 applications.
259  *
260  * Additionally, an `Approval` event is emitted on calls to `transferFrom`.
261  * This allows applications to reconstruct the allowance for all accounts just
262  * by listening to said events. Other implementations of the EIP may not emit
263  * these events, as it isn't required by the specification.
264  *
265  * Finally, the non-standard `decreaseAllowance` and `increaseAllowance`
266  * functions have been added to mitigate the well-known issues around setting
267  * allowances. See `IERC20.approve`.
268  */
269 contract ERC20 is IERC20 {
270     using SafeMath for uint256;
271 
272     mapping (address => uint256) private _balances;
273 
274     mapping (address => mapping (address => uint256)) private _allowances;
275 
276     uint256 private _totalSupply;
277 
278     /**
279      * @dev See `IERC20.totalSupply`.
280      */
281     function totalSupply() public view returns (uint256) {
282         return _totalSupply;
283     }
284 
285     /**
286      * @dev See `IERC20.balanceOf`.
287      */
288     function balanceOf(address account) public view returns (uint256) {
289         return _balances[account];
290     }
291 
292     /**
293      * @dev See `IERC20.transfer`.
294      *
295      * Requirements:
296      *
297      * - `recipient` cannot be the zero address.
298      * - the caller must have a balance of at least `amount`.
299      */
300     function transfer(address recipient, uint256 amount) public returns (bool) {
301         _transfer(msg.sender, recipient, amount);
302         return true;
303     }
304 
305     /**
306      * @dev See `IERC20.allowance`.
307      */
308     function allowance(address owner, address spender) public view returns (uint256) {
309         return _allowances[owner][spender];
310     }
311 
312     /**
313      * @dev See `IERC20.approve`.
314      *
315      * Requirements:
316      *
317      * - `spender` cannot be the zero address.
318      */
319     function approve(address spender, uint256 value) public returns (bool) {
320         _approve(msg.sender, spender, value);
321         return true;
322     }
323 
324     /**
325      * @dev See `IERC20.transferFrom`.
326      *
327      * Emits an `Approval` event indicating the updated allowance. This is not
328      * required by the EIP. See the note at the beginning of `ERC20`;
329      *
330      * Requirements:
331      * - `sender` and `recipient` cannot be the zero address.
332      * - `sender` must have a balance of at least `value`.
333      * - the caller must have allowance for `sender`'s tokens of at least
334      * `amount`.
335      */
336     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
337         _transfer(sender, recipient, amount);
338         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount));
339         return true;
340     }
341 
342     /**
343      * @dev Atomically increases the allowance granted to `spender` by the caller.
344      *
345      * This is an alternative to `approve` that can be used as a mitigation for
346      * problems described in `IERC20.approve`.
347      *
348      * Emits an `Approval` event indicating the updated allowance.
349      *
350      * Requirements:
351      *
352      * - `spender` cannot be the zero address.
353      */
354     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
355         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
356         return true;
357     }
358 
359     /**
360      * @dev Atomically decreases the allowance granted to `spender` by the caller.
361      *
362      * This is an alternative to `approve` that can be used as a mitigation for
363      * problems described in `IERC20.approve`.
364      *
365      * Emits an `Approval` event indicating the updated allowance.
366      *
367      * Requirements:
368      *
369      * - `spender` cannot be the zero address.
370      * - `spender` must have allowance for the caller of at least
371      * `subtractedValue`.
372      */
373     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
374         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue));
375         return true;
376     }
377 
378     /**
379      * @dev Moves tokens `amount` from `sender` to `recipient`.
380      *
381      * This is internal function is equivalent to `transfer`, and can be used to
382      * e.g. implement automatic token fees, slashing mechanisms, etc.
383      *
384      * Emits a `Transfer` event.
385      *
386      * Requirements:
387      *
388      * - `sender` cannot be the zero address.
389      * - `recipient` cannot be the zero address.
390      * - `sender` must have a balance of at least `amount`.
391      */
392     function _transfer(address sender, address recipient, uint256 amount) internal {
393         require(sender != address(0), "ERC20: transfer from the zero address");
394         require(recipient != address(0), "ERC20: transfer to the zero address");
395 
396         _balances[sender] = _balances[sender].sub(amount);
397         _balances[recipient] = _balances[recipient].add(amount);
398         emit Transfer(sender, recipient, amount);
399     }
400 
401     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
402      * the total supply.
403      *
404      * Emits a `Transfer` event with `from` set to the zero address.
405      *
406      * Requirements
407      *
408      * - `to` cannot be the zero address.
409      */
410     function _mint(address account, uint256 amount) internal {
411         require(account != address(0), "ERC20: mint to the zero address");
412 
413         _totalSupply = _totalSupply.add(amount);
414         _balances[account] = _balances[account].add(amount);
415         emit Transfer(address(0), account, amount);
416     }
417 
418      /**
419      * @dev Destoys `amount` tokens from `account`, reducing the
420      * total supply.
421      *
422      * Emits a `Transfer` event with `to` set to the zero address.
423      *
424      * Requirements
425      *
426      * - `account` cannot be the zero address.
427      * - `account` must have at least `amount` tokens.
428      */
429     function _burn(address account, uint256 value) internal {
430         require(account != address(0), "ERC20: burn from the zero address");
431 
432         _totalSupply = _totalSupply.sub(value);
433         _balances[account] = _balances[account].sub(value);
434         emit Transfer(account, address(0), value);
435     }
436 
437     /**
438      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
439      *
440      * This is internal function is equivalent to `approve`, and can be used to
441      * e.g. set automatic allowances for certain subsystems, etc.
442      *
443      * Emits an `Approval` event.
444      *
445      * Requirements:
446      *
447      * - `owner` cannot be the zero address.
448      * - `spender` cannot be the zero address.
449      */
450     function _approve(address owner, address spender, uint256 value) internal {
451         require(owner != address(0), "ERC20: approve from the zero address");
452         require(spender != address(0), "ERC20: approve to the zero address");
453 
454         _allowances[owner][spender] = value;
455         emit Approval(owner, spender, value);
456     }
457 
458     /**
459      * @dev Destoys `amount` tokens from `account`.`amount` is then deducted
460      * from the caller's allowance.
461      *
462      * See `_burn` and `_approve`.
463      */
464     function _burnFrom(address account, uint256 amount) internal {
465         _burn(account, amount);
466         _approve(account, msg.sender, _allowances[account][msg.sender].sub(amount));
467     }
468 }
469 
470 /**
471  * @title Roles
472  * @dev Library for managing addresses assigned to a Role.
473  */
474 library Roles {
475     struct Role {
476         mapping (address => bool) bearer;
477     }
478 
479     /**
480      * @dev Give an account access to this role.
481      */
482     function add(Role storage role, address account) internal {
483         require(!has(role, account), "Roles: account already has role");
484         role.bearer[account] = true;
485     }
486 
487     /**
488      * @dev Remove an account's access to this role.
489      */
490     function remove(Role storage role, address account) internal {
491         require(has(role, account), "Roles: account does not have role");
492         role.bearer[account] = false;
493     }
494 
495     /**
496      * @dev Check if an account has this role.
497      * @return bool
498      */
499     function has(Role storage role, address account) internal view returns (bool) {
500         require(account != address(0), "Roles: account is the zero address");
501         return role.bearer[account];
502     }
503 }
504 
505 contract MinterRole {
506     using Roles for Roles.Role;
507 
508     event MinterAdded(address indexed account);
509     event MinterRemoved(address indexed account);
510 
511     Roles.Role private _minters;
512 
513     constructor () internal {
514         _addMinter(msg.sender);
515     }
516 
517     modifier onlyMinter() {
518         require(isMinter(msg.sender), "MinterRole: caller does not have the Minter role");
519         _;
520     }
521 
522     function isMinter(address account) public view returns (bool) {
523         return _minters.has(account);
524     }
525 
526     function addMinter(address account) public onlyMinter {
527         _addMinter(account);
528     }
529 
530     function renounceMinter() public {
531         _removeMinter(msg.sender);
532     }
533 
534     function removeMinter(address account) public onlyMinter {
535         _removeMinter(account);
536     }
537 
538     function _addMinter(address account) internal {
539         _minters.add(account);
540         emit MinterAdded(account);
541     }
542 
543     function _removeMinter(address account) internal {
544         _minters.remove(account);
545         emit MinterRemoved(account);
546     }
547 }
548 
549 /**
550  * @dev Extension of `ERC20` that allows token holders to destroy both their own
551  * tokens and those that they have an allowance for, in a way that can be
552  * recognized off-chain (via event analysis).
553  */
554 contract ERC20Burnable is ERC20 {
555     /**
556      * @dev Destoys `amount` tokens from the caller.
557      *
558      * See `ERC20._burn`.
559      */
560     function burn(address account, uint256 amount) public {
561         _burn(account, amount);
562     }
563 
564     /**
565      * @dev See `ERC20._burnFrom`.
566      */
567     function burnFrom(address account, uint256 amount) public {
568         _burnFrom(account, amount);
569     }
570 }
571 
572 /**
573  * @dev Extension of `ERC20` that adds a set of accounts with the `MinterRole`,
574  * which have permission to mint (create) new tokens as they see fit.
575  *
576  * At construction, the deployer of the contract is the only minter.
577  */
578 contract ERC20Mintable is ERC20, MinterRole {
579     /**
580      * @dev See `ERC20._mint`.
581      *
582      * Requirements:
583      *
584      * - the caller must have the `MinterRole`.
585      */
586     function mint(address account, uint256 amount) public onlyMinter returns (bool) {
587         _mint(account, amount);
588         return true;
589     }
590 }
591 
592 /**
593  * @dev Contract module which provides a basic access control mechanism, where
594  * there is an account (an owner) that can be granted exclusive access to
595  * specific functions.
596  *
597  * This module is used through inheritance. It will make available the modifier
598  * `onlyOwner`, which can be aplied to your functions to restrict their use to
599  * the owner.
600  */
601 contract Ownable {
602     address private _owner;
603 
604     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
605 
606     /**
607      * @dev Initializes the contract setting the deployer as the initial owner.
608      */
609     constructor () internal {
610         _owner = msg.sender;
611         emit OwnershipTransferred(address(0), _owner);
612     }
613 
614     /**
615      * @dev Returns the address of the current owner.
616      */
617     function owner() public view returns (address) {
618         return _owner;
619     }
620 
621     /**
622      * @dev Throws if called by any account other than the owner.
623      */
624     modifier onlyOwner() {
625         require(isOwner(), "Ownable: caller is not the owner");
626         _;
627     }
628 
629     /**
630      * @dev Returns true if the caller is the current owner.
631      */
632     function isOwner() public view returns (bool) {
633         return msg.sender == _owner;
634     }
635 
636     /**
637      * @dev Leaves the contract without owner. It will not be possible to call
638      * `onlyOwner` functions anymore. Can only be called by the current owner.
639      *
640      * > Note: Renouncing ownership will leave the contract without an owner,
641      * thereby removing any functionality that is only available to the owner.
642      */
643     // function renounceOwnership() public onlyOwner {
644     //     emit OwnershipTransferred(_owner, address(0));
645     //     _owner = address(0);
646     // }
647 
648     /**
649      * @dev Transfers ownership of the contract to a new account (`newOwner`).
650      * Can only be called by the current owner.
651      */
652     function transferOwnership(address newOwner) public onlyOwner {
653         _transferOwnership(newOwner);
654     }
655 
656     /**
657      * @dev Transfers ownership of the contract to a new account (`newOwner`).
658      */
659     function _transferOwnership(address newOwner) internal {
660         require(newOwner != address(0), "Ownable: new owner is the zero address");
661         emit OwnershipTransferred(_owner, newOwner);
662         _owner = newOwner;
663     }
664 }
665 
666 /**
667  * @dev Collection of functions related to the address type,
668  */
669 library Address {
670     /**
671      * @dev Returns true if `account` is a contract.
672      *
673      * This test is non-exhaustive, and there may be false-negatives: during the
674      * execution of a contract's constructor, its address will be reported as
675      * not containing a contract.
676      *
677      * > It is unsafe to assume that an address for which this function returns
678      * false is an externally-owned account (EOA) and not a contract.
679      */
680     function isContract(address account) internal view returns (bool) {
681         // This method relies in extcodesize, which returns 0 for contracts in
682         // construction, since the code is only stored at the end of the
683         // constructor execution.
684 
685         uint256 size;
686         // solhint-disable-next-line no-inline-assembly
687         assembly { size := extcodesize(account) }
688         return size > 0;
689     }
690 }
691 
692 /**
693  * @title SafeERC20
694  * @dev Wrappers around ERC20 operations that throw on failure (when the token
695  * contract returns false). Tokens that return no value (and instead revert or
696  * throw on failure) are also supported, non-reverting calls are assumed to be
697  * successful.
698  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
699  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
700  */
701 library SafeERC20 {
702     using SafeMath for uint256;
703     using Address for address;
704 
705     function safeTransfer(IERC20 token, address to, uint256 value) internal {
706         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
707     }
708 
709     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
710         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
711     }
712 
713     function safeApprove(IERC20 token, address spender, uint256 value) internal {
714         // safeApprove should only be called when setting an initial allowance,
715         // or when resetting it to zero. To increase and decrease it, use
716         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
717         // solhint-disable-next-line max-line-length
718         require((value == 0) || (token.allowance(address(this), spender) == 0),
719             "SafeERC20: approve from non-zero to non-zero allowance"
720         );
721         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
722     }
723 
724     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
725         uint256 newAllowance = token.allowance(address(this), spender).add(value);
726         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
727     }
728 
729     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
730         uint256 newAllowance = token.allowance(address(this), spender).sub(value);
731         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
732     }
733 
734     /**
735      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
736      * on the return value: the return value is optional (but if data is returned, it must not be false).
737      * @param token The token targeted by the call.
738      * @param data The call data (encoded using abi.encode or one of its variants).
739      */
740     function callOptionalReturn(IERC20 token, bytes memory data) private {
741         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
742         // we're implementing it ourselves.
743 
744         // A Solidity high level call has three parts:
745         //  1. The target address is checked to verify it contains contract code
746         //  2. The call itself is made, and success asserted
747         //  3. The return value is decoded, which in turn checks the size of the returned data.
748         // solhint-disable-next-line max-line-length
749         require(address(token).isContract(), "SafeERC20: call to non-contract");
750 
751         // solhint-disable-next-line avoid-low-level-calls
752         (bool success, bytes memory returndata) = address(token).call(data);
753         require(success, "SafeERC20: low-level call failed");
754 
755         if (returndata.length > 0) { // Return data is optional
756             // solhint-disable-next-line max-line-length
757             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
758         }
759     }
760 }
761 
762 contract MEXCToken is ERC20Mintable, ERC20Burnable, ReentrancyGuard, Ownable {
763     using SafeMath for uint256;
764     using SafeERC20 for IERC20;
765 
766     string  public name      = "MEXC Token";
767     string  public symbol    = "MEXC";
768     uint8   public decimals  = 18;
769     uint256 public maxSupply = 1714285714 ether;    // max allowable minting.
770 
771     bool    private _transferAllowed = true;        // allow/disallow transfer.
772 
773     mapping(address => bool) locked;                // locked addresses.
774 
775     modifier canTransfer() {
776         if (msg.sender == owner()) {
777             _;
778         } else {
779             require(_transferAllowed, "MEXC: transfer is not allowed");
780             require(locked[msg.sender] == false, "MEXC: account is locked");
781             _;
782         }
783     }
784     
785     event burnTokenEvent(address account, uint256 value);
786     event lockAddressEvent(address account);
787     event unlockAddressEvent(address account);
788     event tokenIsRenamed(string symbol, string name);
789     event supplyHasIncreased(uint256 newSupply);
790 
791     constructor() public {
792     }
793 
794     /**
795      * Allow the transfer of token to happen once listed on exchangers
796      */
797     function allowTransfers() onlyOwner public returns (bool) {
798         _transferAllowed = true;
799         return true;
800     }
801 
802     /**
803      * disallow the transfer
804      */
805     function disallowTransfers() onlyOwner public returns (bool) {
806         _transferAllowed = false;
807         return true;
808     } 
809 
810     function isTransferAllowed() public view returns (bool) {
811         return _transferAllowed;
812     }
813 
814     /**
815      * lock the address from any transfer
816      */
817     function lockAddress(address _addr) onlyOwner public {
818         locked[_addr] = true;
819         emit lockAddressEvent(_addr);
820     }
821 
822     /**
823      * lock the address from any transfer
824      */
825     function unlockAddress(address _addr) onlyOwner public {
826         locked[_addr] = false;
827         emit unlockAddressEvent(_addr);
828     }
829 
830     /**
831      * Check if the address is locked, or not
832      */
833     function isLocked(address _addr) public view returns (bool) {
834         return locked[_addr];
835     }
836 
837     /**
838      * Rename the token to new name, and symbol
839      */
840     function renameToken(string memory _symbol, string memory _name) onlyOwner public {
841         symbol = _symbol;
842         name = _name;
843         emit tokenIsRenamed(_symbol, _name);
844     }
845 
846     /**
847      * Increase the max supply
848      */
849     function increaseSupply(uint256 supply) onlyOwner public returns (bool) {
850         maxSupply = maxSupply.add(supply);
851         emit supplyHasIncreased(maxSupply);
852         return true;
853     }
854 
855     /**
856      * Mint the token to new owner
857      */
858     function mint(address account, uint256 amount) 
859             onlyMinter onlyOwner nonReentrant public returns (bool) {
860         require(totalSupply().add(amount) <= maxSupply, "MEXC: exceeding the maxSupply amount");
861         super.mint(account, amount);
862         return true;
863     }
864 
865     /**
866      * Mint the token to new owner
867      */
868     function mintThenLock(address account, uint256 amount) 
869             onlyMinter onlyOwner public returns (bool) {
870         require(totalSupply().add(amount) <= maxSupply, "MEXC: exceeding the maxSupply amount");
871         mint(account, amount);
872         lockAddress(account);
873         return true;
874     }
875 
876     /**
877      * Burn the amount in the address
878      */
879     function burn(address account, uint256 value) 
880             onlyMinter onlyOwner nonReentrant public {
881         super.burn(account, value);
882         emit burnTokenEvent(account, value);
883     }
884 
885     /**
886      * @dev See `IERC20.transfer`.
887      *
888      * Requirements:
889      *
890      * - `recipient` cannot be the zero address.
891      * - the caller must have a balance of at least `amount`.
892      */
893     function transfer(address recipient, uint256 amount) 
894             canTransfer nonReentrant public returns (bool) {
895         super.transfer(recipient, amount);
896         return true;
897     }
898 
899     /**
900      * - `spender` cannot be the zero address.
901      */
902     function approve(address spender, uint256 value) 
903             canTransfer nonReentrant public returns (bool) {
904         super.approve(spender, value);
905         return true;
906     }
907 
908     /**
909      * - `sender` and `recipient` cannot be the zero address.
910      * - `sender` must have a balance of at least `value`.
911      * - the caller must have allowance for `sender`'s tokens of at least
912      * `amount`.
913      */
914     function transferFrom(address sender, address recipient, uint256 amount) 
915             canTransfer nonReentrant public returns (bool) {
916         super.transferFrom(sender, recipient, amount);
917         return true;
918     }
919 
920     /**
921      *
922      * Emits an `Approval` event indicating the updated allowance.
923      *
924      * Requirements:
925      *
926      * - `spender` cannot be the zero address.
927      */
928     function increaseAllowance(address spender, uint256 addedValue) 
929             canTransfer nonReentrant public returns (bool) {
930         super.increaseAllowance(spender, addedValue);
931         return true;
932     }
933 
934     /**
935      *
936      * Emits an `Approval` event indicating the updated allowance.
937      *
938      * Requirements:
939      *
940      * - `spender` cannot be the zero address.
941      * - `spender` must have allowance for the caller of at least
942      * `subtractedValue`.
943      */
944     function decreaseAllowance(address spender, uint256 subtractedValue) 
945             canTransfer nonReentrant public returns (bool) {
946         super.decreaseAllowance(spender, subtractedValue);
947         return true;
948     }  
949 
950     /**
951      * @dev Transfers ownership of the contract to a new account (`newOwner`).
952      * Can only be called by the current owner.
953      */
954     function transferOwnership(address newOwner) public onlyOwner {
955         super.transferOwnership(newOwner);
956         super.addMinter(newOwner);
957         super.renounceMinter();
958     }
959 
960 }