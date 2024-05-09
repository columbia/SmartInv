1 /**
2  *Submitted for verification at Etherscan.io on 2019-06-17
3 */
4 
5 /*
6 Copyright 2018 Binod Nirvan
7 
8 Licensed under the Apache License, Version 2.0 (the "License");
9 you may not use this file except in compliance with the License.
10 You may obtain a copy of the License at
11 
12     http://www.apache.org/licenses/LICENSE-2.0
13 
14 Unless required by applicable law or agreed to in writing, software
15 distributed under the License is distributed on an "AS IS" BASIS,
16 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
17 See the License for the specific language governing permissions and
18 limitations under the License.
19  */
20 
21 pragma solidity >=0.4.21 <0.6.0;
22 
23 /*
24 Copyright 2018 Binod Nirvan
25 
26 Licensed under the Apache License, Version 2.0 (the "License");
27 you may not use this file except in compliance with the License.
28 You may obtain a copy of the License at
29 
30     http://www.apache.org/licenses/LICENSE-2.0
31 
32 Unless required by applicable law or agreed to in writing, software
33 distributed under the License is distributed on an "AS IS" BASIS,
34 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
35 See the License for the specific language governing permissions and
36 limitations under the License.
37  */
38 
39 
40 
41 /*
42 Copyright 2018 Binod Nirvan
43 
44 Licensed under the Apache License, Version 2.0 (the "License");
45 you may not use this file except in compliance with the License.
46 You may obtain a copy of the License at
47 
48     http://www.apache.org/licenses/LICENSE-2.0
49 
50 Unless required by applicable law or agreed to in writing, software
51 distributed under the License is distributed on an "AS IS" BASIS,
52 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
53 See the License for the specific language governing permissions and
54 limitations under the License.
55  */
56 
57 
58 
59 /*
60 Copyright 2018 Binod Nirvan
61 
62 Licensed under the Apache License, Version 2.0 (the "License");
63 you may not use this file except in compliance with the License.
64 You may obtain a copy of the License at
65 
66     http://www.apache.org/licenses/LICENSE-2.0
67 
68 Unless required by applicable law or agreed to in writing, software
69 distributed under the License is distributed on an "AS IS" BASIS,
70 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
71 See the License for the specific language governing permissions and
72 limitations under the License.
73  */
74 
75 
76 /*
77 Copyright 2018 Binod Nirvan
78 
79 Licensed under the Apache License, Version 2.0 (the "License");
80 you may not use this file except in compliance with the License.
81 You may obtain a copy of the License at
82 
83     http://www.apache.org/licenses/LICENSE-2.0
84 
85 Unless required by applicable law or agreed to in writing, software
86 distributed under the License is distributed on an "AS IS" BASIS,
87 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
88 See the License for the specific language governing permissions and
89 limitations under the License.
90  */
91 
92 
93 
94 
95 /**
96  * @dev Contract module which provides a basic access control mechanism, where
97  * there is an account (an owner) that can be granted exclusive access to
98  * specific functions.
99  *
100  * This module is used through inheritance. It will make available the modifier
101  * `onlyOwner`, which can be aplied to your functions to restrict their use to
102  * the owner.
103  */
104 contract Ownable {
105     address private _owner;
106 
107     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
108 
109     /**
110      * @dev Initializes the contract setting the deployer as the initial owner.
111      */
112     constructor () internal {
113         _owner = msg.sender;
114         emit OwnershipTransferred(address(0), _owner);
115     }
116 
117     /**
118      * @dev Returns the address of the current owner.
119      */
120     function owner() public view returns (address) {
121         return _owner;
122     }
123 
124     /**
125      * @dev Throws if called by any account other than the owner.
126      */
127     modifier onlyOwner() {
128         require(isOwner(), "Ownable: caller is not the owner");
129         _;
130     }
131 
132     /**
133      * @dev Returns true if the caller is the current owner.
134      */
135     function isOwner() public view returns (bool) {
136         return msg.sender == _owner;
137     }
138 
139     /**
140      * @dev Leaves the contract without owner. It will not be possible to call
141      * `onlyOwner` functions anymore. Can only be called by the current owner.
142      *
143      * > Note: Renouncing ownership will leave the contract without an owner,
144      * thereby removing any functionality that is only available to the owner.
145      */
146     function renounceOwnership() public onlyOwner {
147         emit OwnershipTransferred(_owner, address(0));
148         _owner = address(0);
149     }
150 
151     /**
152      * @dev Transfers ownership of the contract to a new account (`newOwner`).
153      * Can only be called by the current owner.
154      */
155     function transferOwnership(address newOwner) public onlyOwner {
156         _transferOwnership(newOwner);
157     }
158 
159     /**
160      * @dev Transfers ownership of the contract to a new account (`newOwner`).
161      */
162     function _transferOwnership(address newOwner) internal {
163         require(newOwner != address(0), "Ownable: new owner is the zero address");
164         emit OwnershipTransferred(_owner, newOwner);
165         _owner = newOwner;
166     }
167 }
168 
169 
170 ///@title Custom Ownable
171 ///@notice Custom ownable contract.
172 contract CustomOwnable is Ownable {
173   ///The trustee wallet.
174   address private _trustee;
175 
176   event TrusteeAssigned(address indexed account);
177 
178   ///@notice Validates if the sender is actually the trustee.
179   modifier onlyTrustee() {
180     require(msg.sender == _trustee, "Access is denied.");
181     _;
182   }
183 
184   ///@notice Assigns or changes the trustee wallet.
185   ///@param account A wallet address which will become the new trustee.
186   ///@return Returns true if the operation was successful.
187   function assignTrustee(address account) external onlyOwner returns(bool) {
188     require(account != address(0), "Please provide a valid address for trustee.");
189 
190     _trustee = account;
191     emit TrusteeAssigned(account);
192     return true;
193   }
194 
195   ///@notice Changes the owner of this contract.
196   ///@param newOwner Specify a wallet address which will become the new owner.
197   ///@return Returns true if the operation was successful.
198   function reassignOwner(address newOwner) external onlyTrustee returns(bool) {
199     super._transferOwnership(newOwner);
200     return true;
201   }
202 
203   ///@notice The trustee wallet has the power to change the owner in case of unforeseen or unavoidable situation.
204   ///@return Wallet address of the trustee account.
205   function getTrustee() external view returns(address) {
206     return _trustee;
207   }
208 }
209 
210 ///@title Custom Admin
211 ///@notice Custom admin contract provides features to have multiple administrators
212 /// who can collective perform admin-related tasks instead of depending on the owner.
213 /// &nbsp;
214 /// It is assumed by default that the owner is more power than admins
215 /// and therefore cannot be added to or removed from the admin list.
216 contract CustomAdmin is CustomOwnable {
217   ///List of administrators.
218   mapping(address => bool) private _admins;
219 
220   event AdminAdded(address indexed account);
221   event AdminRemoved(address indexed account);
222 
223   event TrusteeAssigned(address indexed account);
224 
225   ///@notice Validates if the sender is actually an administrator.
226   modifier onlyAdmin() {
227     require(isAdmin(msg.sender), "Access is denied.");
228     _;
229   }
230 
231   ///@notice Adds the specified address to the list of administrators.
232   ///@param account The address to add to the administrator list.
233   ///@return Returns true if the operation was successful.
234   function addAdmin(address account) external onlyAdmin returns(bool) {
235     require(account != address(0), "Invalid address.");
236     require(!_admins[account], "This address is already an administrator.");
237 
238     require(account != super.owner(), "The owner cannot be added or removed to or from the administrator list.");
239 
240     _admins[account] = true;
241 
242     emit AdminAdded(account);
243     return true;
244   }
245 
246   ///@notice Adds multiple addresses to the administrator list.
247   ///@param accounts The account addresses to add to the administrator list.
248   ///@return Returns true if the operation was successful.
249   function addManyAdmins(address[] calldata accounts) external onlyAdmin returns(bool) {
250     for(uint8 i = 0; i < accounts.length; i++) {
251       address account = accounts[i];
252 
253       ///Zero address cannot be an admin.
254       ///The owner is already an admin and cannot be assigned.
255       ///The address cannot be an existing admin.
256       if(account != address(0) && !_admins[account] && account != super.owner()) {
257         _admins[account] = true;
258 
259         emit AdminAdded(accounts[i]);
260       }
261     }
262 
263     return true;
264   }
265 
266   ///@notice Removes the specified address from the list of administrators.
267   ///@param account The address to remove from the administrator list.
268   ///@return Returns true if the operation was successful.
269   function removeAdmin(address account) external onlyAdmin returns(bool) {
270     require(account != address(0), "Invalid address.");
271     require(_admins[account], "This address isn't an administrator.");
272 
273     //The owner cannot be removed as admin.
274     require(account != super.owner(), "The owner cannot be added or removed to or from the administrator list.");
275 
276     _admins[account] = false;
277     emit AdminRemoved(account);
278     return true;
279   }
280 
281   ///@notice Removes multiple addresses to the administrator list.
282   ///@param accounts The account addresses to add to the administrator list.
283   ///@return Returns true if the operation was successful.
284   function removeManyAdmins(address[] calldata accounts) external onlyAdmin returns(bool) {
285     for(uint8 i = 0; i < accounts.length; i++) {
286       address account = accounts[i];
287 
288       ///Zero address can neither be added or removed from this list.
289       ///The owner is the super admin and cannot be removed.
290       ///The address must be an existing admin in order for it to be removed.
291       if(account != address(0) && _admins[account] && account != super.owner()) {
292         _admins[account] = false;
293 
294         emit AdminRemoved(accounts[i]);
295       }
296     }
297 
298     return true;
299   }
300 
301   ///@notice Checks if an address is an administrator.
302   ///@return Returns true if the specified wallet is infact an administrator.
303   function isAdmin(address account) public view returns(bool) {
304     if(account == super.owner()) {
305       //The owner has all rights and privileges assigned to the admins.
306       return true;
307     }
308 
309     return _admins[account];
310   }
311 }
312 
313 ///@title Custom Pausable Contract
314 ///@notice This contract provides pausable mechanism to stop in case of emergency.
315 /// The "pausable" features can be used and set by the contract administrators
316 /// and the owner.
317 contract CustomPausable is CustomAdmin {
318   event Paused();
319   event Unpaused();
320 
321   bool private _paused = false;
322 
323   ///@notice Ensures that the contract is not paused.
324   modifier whenNotPaused() {
325     require(!_paused, "Sorry but the contract is paused.");
326     _;
327   }
328 
329   ///@notice Ensures that the contract is paused.
330   modifier whenPaused() {
331     require(_paused, "Sorry but the contract isn't paused.");
332     _;
333   }
334 
335   ///@notice Pauses the contract.
336   function pause() external onlyAdmin whenNotPaused {
337     _paused = true;
338     emit Paused();
339   }
340 
341   ///@notice Unpauses the contract and returns to normal state.
342   function unpause() external onlyAdmin whenPaused {
343     _paused = false;
344     emit Unpaused();
345   }
346 
347   ///@notice Indicates if the contract is paused.
348   ///@return Returns true if this contract is paused.
349   function isPaused() external view returns(bool) {
350     return _paused;
351   }
352 }
353 /*
354 Copyright 2018 Binod Nirvan
355 
356 Licensed under the Apache License, Version 2.0 (the "License");
357 you may not use this file except in compliance with the License.
358 You may obtain a copy of the License at
359 
360     http://www.apache.org/licenses/LICENSE-2.0
361 
362 Unless required by applicable law or agreed to in writing, software
363 distributed under the License is distributed on an "AS IS" BASIS,
364 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
365 See the License for the specific language governing permissions and
366 limitations under the License.
367  */
368 
369 
370 
371 
372 
373 
374 
375 /**
376  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
377  * the optional functions; to access them see `ERC20Detailed`.
378  */
379 interface IERC20 {
380     /**
381      * @dev Returns the amount of tokens in existence.
382      */
383     function totalSupply() external view returns (uint256);
384 
385     /**
386      * @dev Returns the amount of tokens owned by `account`.
387      */
388     function balanceOf(address account) external view returns (uint256);
389 
390     /**
391      * @dev Moves `amount` tokens from the caller's account to `recipient`.
392      *
393      * Returns a boolean value indicating whether the operation succeeded.
394      *
395      * Emits a `Transfer` event.
396      */
397     function transfer(address recipient, uint256 amount) external returns (bool);
398 
399     /**
400      * @dev Returns the remaining number of tokens that `spender` will be
401      * allowed to spend on behalf of `owner` through `transferFrom`. This is
402      * zero by default.
403      *
404      * This value changes when `approve` or `transferFrom` are called.
405      */
406     function allowance(address owner, address spender) external view returns (uint256);
407 
408     /**
409      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
410      *
411      * Returns a boolean value indicating whether the operation succeeded.
412      *
413      * > Beware that changing an allowance with this method brings the risk
414      * that someone may use both the old and the new allowance by unfortunate
415      * transaction ordering. One possible solution to mitigate this race
416      * condition is to first reduce the spender's allowance to 0 and set the
417      * desired value afterwards:
418      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
419      *
420      * Emits an `Approval` event.
421      */
422     function approve(address spender, uint256 amount) external returns (bool);
423 
424     /**
425      * @dev Moves `amount` tokens from `sender` to `recipient` using the
426      * allowance mechanism. `amount` is then deducted from the caller's
427      * allowance.
428      *
429      * Returns a boolean value indicating whether the operation succeeded.
430      *
431      * Emits a `Transfer` event.
432      */
433     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
434 
435     /**
436      * @dev Emitted when `value` tokens are moved from one account (`from`) to
437      * another (`to`).
438      *
439      * Note that `value` may be zero.
440      */
441     event Transfer(address indexed from, address indexed to, uint256 value);
442 
443     /**
444      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
445      * a call to `approve`. `value` is the new allowance.
446      */
447     event Approval(address indexed owner, address indexed spender, uint256 value);
448 }
449 
450 
451 
452 /**
453  * @dev Wrappers over Solidity's arithmetic operations with added overflow
454  * checks.
455  *
456  * Arithmetic operations in Solidity wrap on overflow. This can easily result
457  * in bugs, because programmers usually assume that an overflow raises an
458  * error, which is the standard behavior in high level programming languages.
459  * `SafeMath` restores this intuition by reverting the transaction when an
460  * operation overflows.
461  *
462  * Using this library instead of the unchecked operations eliminates an entire
463  * class of bugs, so it's recommended to use it always.
464  */
465 library SafeMath {
466     /**
467      * @dev Returns the addition of two unsigned integers, reverting on
468      * overflow.
469      *
470      * Counterpart to Solidity's `+` operator.
471      *
472      * Requirements:
473      * - Addition cannot overflow.
474      */
475     function add(uint256 a, uint256 b) internal pure returns (uint256) {
476         uint256 c = a + b;
477         require(c >= a, "SafeMath: addition overflow");
478 
479         return c;
480     }
481 
482     /**
483      * @dev Returns the subtraction of two unsigned integers, reverting on
484      * overflow (when the result is negative).
485      *
486      * Counterpart to Solidity's `-` operator.
487      *
488      * Requirements:
489      * - Subtraction cannot overflow.
490      */
491     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
492         require(b <= a, "SafeMath: subtraction overflow");
493         uint256 c = a - b;
494 
495         return c;
496     }
497 
498     /**
499      * @dev Returns the multiplication of two unsigned integers, reverting on
500      * overflow.
501      *
502      * Counterpart to Solidity's `*` operator.
503      *
504      * Requirements:
505      * - Multiplication cannot overflow.
506      */
507     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
508         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
509         // benefit is lost if 'b' is also tested.
510         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
511         if (a == 0) {
512             return 0;
513         }
514 
515         uint256 c = a * b;
516         require(c / a == b, "SafeMath: multiplication overflow");
517 
518         return c;
519     }
520 
521     /**
522      * @dev Returns the integer division of two unsigned integers. Reverts on
523      * division by zero. The result is rounded towards zero.
524      *
525      * Counterpart to Solidity's `/` operator. Note: this function uses a
526      * `revert` opcode (which leaves remaining gas untouched) while Solidity
527      * uses an invalid opcode to revert (consuming all remaining gas).
528      *
529      * Requirements:
530      * - The divisor cannot be zero.
531      */
532     function div(uint256 a, uint256 b) internal pure returns (uint256) {
533         // Solidity only automatically asserts when dividing by 0
534         require(b > 0, "SafeMath: division by zero");
535         uint256 c = a / b;
536         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
537 
538         return c;
539     }
540 
541     /**
542      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
543      * Reverts when dividing by zero.
544      *
545      * Counterpart to Solidity's `%` operator. This function uses a `revert`
546      * opcode (which leaves remaining gas untouched) while Solidity uses an
547      * invalid opcode to revert (consuming all remaining gas).
548      *
549      * Requirements:
550      * - The divisor cannot be zero.
551      */
552     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
553         require(b != 0, "SafeMath: modulo by zero");
554         return a % b;
555     }
556 }
557 
558 
559 /**
560  * @dev Implementation of the `IERC20` interface.
561  *
562  * This implementation is agnostic to the way tokens are created. This means
563  * that a supply mechanism has to be added in a derived contract using `_mint`.
564  * For a generic mechanism see `ERC20Mintable`.
565  *
566  * *For a detailed writeup see our guide [How to implement supply
567  * mechanisms](https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226).*
568  *
569  * We have followed general OpenZeppelin guidelines: functions revert instead
570  * of returning `false` on failure. This behavior is nonetheless conventional
571  * and does not conflict with the expectations of ERC20 applications.
572  *
573  * Additionally, an `Approval` event is emitted on calls to `transferFrom`.
574  * This allows applications to reconstruct the allowance for all accounts just
575  * by listening to said events. Other implementations of the EIP may not emit
576  * these events, as it isn't required by the specification.
577  *
578  * Finally, the non-standard `decreaseAllowance` and `increaseAllowance`
579  * functions have been added to mitigate the well-known issues around setting
580  * allowances. See `IERC20.approve`.
581  */
582 contract ERC20 is IERC20 {
583     using SafeMath for uint256;
584 
585     mapping (address => uint256) private _balances;
586 
587     mapping (address => mapping (address => uint256)) private _allowances;
588 
589     uint256 private _totalSupply;
590 
591     /**
592      * @dev See `IERC20.totalSupply`.
593      */
594     function totalSupply() public view returns (uint256) {
595         return _totalSupply;
596     }
597 
598     /**
599      * @dev See `IERC20.balanceOf`.
600      */
601     function balanceOf(address account) public view returns (uint256) {
602         return _balances[account];
603     }
604 
605     /**
606      * @dev See `IERC20.transfer`.
607      *
608      * Requirements:
609      *
610      * - `recipient` cannot be the zero address.
611      * - the caller must have a balance of at least `amount`.
612      */
613     function transfer(address recipient, uint256 amount) public returns (bool) {
614         _transfer(msg.sender, recipient, amount);
615         return true;
616     }
617 
618     /**
619      * @dev See `IERC20.allowance`.
620      */
621     function allowance(address owner, address spender) public view returns (uint256) {
622         return _allowances[owner][spender];
623     }
624 
625     /**
626      * @dev See `IERC20.approve`.
627      *
628      * Requirements:
629      *
630      * - `spender` cannot be the zero address.
631      */
632     function approve(address spender, uint256 value) public returns (bool) {
633         _approve(msg.sender, spender, value);
634         return true;
635     }
636 
637     /**
638      * @dev See `IERC20.transferFrom`.
639      *
640      * Emits an `Approval` event indicating the updated allowance. This is not
641      * required by the EIP. See the note at the beginning of `ERC20`;
642      *
643      * Requirements:
644      * - `sender` and `recipient` cannot be the zero address.
645      * - `sender` must have a balance of at least `value`.
646      * - the caller must have allowance for `sender`'s tokens of at least
647      * `amount`.
648      */
649     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
650         _transfer(sender, recipient, amount);
651         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount));
652         return true;
653     }
654 
655     /**
656      * @dev Atomically increases the allowance granted to `spender` by the caller.
657      *
658      * This is an alternative to `approve` that can be used as a mitigation for
659      * problems described in `IERC20.approve`.
660      *
661      * Emits an `Approval` event indicating the updated allowance.
662      *
663      * Requirements:
664      *
665      * - `spender` cannot be the zero address.
666      */
667     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
668         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
669         return true;
670     }
671 
672     /**
673      * @dev Atomically decreases the allowance granted to `spender` by the caller.
674      *
675      * This is an alternative to `approve` that can be used as a mitigation for
676      * problems described in `IERC20.approve`.
677      *
678      * Emits an `Approval` event indicating the updated allowance.
679      *
680      * Requirements:
681      *
682      * - `spender` cannot be the zero address.
683      * - `spender` must have allowance for the caller of at least
684      * `subtractedValue`.
685      */
686     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
687         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue));
688         return true;
689     }
690 
691     /**
692      * @dev Moves tokens `amount` from `sender` to `recipient`.
693      *
694      * This is internal function is equivalent to `transfer`, and can be used to
695      * e.g. implement automatic token fees, slashing mechanisms, etc.
696      *
697      * Emits a `Transfer` event.
698      *
699      * Requirements:
700      *
701      * - `sender` cannot be the zero address.
702      * - `recipient` cannot be the zero address.
703      * - `sender` must have a balance of at least `amount`.
704      */
705     function _transfer(address sender, address recipient, uint256 amount) internal {
706         require(sender != address(0), "ERC20: transfer from the zero address");
707         require(recipient != address(0), "ERC20: transfer to the zero address");
708 
709         _balances[sender] = _balances[sender].sub(amount);
710         _balances[recipient] = _balances[recipient].add(amount);
711         emit Transfer(sender, recipient, amount);
712     }
713 
714     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
715      * the total supply.
716      *
717      * Emits a `Transfer` event with `from` set to the zero address.
718      *
719      * Requirements
720      *
721      * - `to` cannot be the zero address.
722      */
723     function _mint(address account, uint256 amount) internal {
724         require(account != address(0), "ERC20: mint to the zero address");
725 
726         _totalSupply = _totalSupply.add(amount);
727         _balances[account] = _balances[account].add(amount);
728         emit Transfer(address(0), account, amount);
729     }
730 
731      /**
732      * @dev Destoys `amount` tokens from `account`, reducing the
733      * total supply.
734      *
735      * Emits a `Transfer` event with `to` set to the zero address.
736      *
737      * Requirements
738      *
739      * - `account` cannot be the zero address.
740      * - `account` must have at least `amount` tokens.
741      */
742     function _burn(address account, uint256 value) internal {
743         require(account != address(0), "ERC20: burn from the zero address");
744 
745         _totalSupply = _totalSupply.sub(value);
746         _balances[account] = _balances[account].sub(value);
747         emit Transfer(account, address(0), value);
748     }
749 
750     /**
751      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
752      *
753      * This is internal function is equivalent to `approve`, and can be used to
754      * e.g. set automatic allowances for certain subsystems, etc.
755      *
756      * Emits an `Approval` event.
757      *
758      * Requirements:
759      *
760      * - `owner` cannot be the zero address.
761      * - `spender` cannot be the zero address.
762      */
763     function _approve(address owner, address spender, uint256 value) internal {
764         require(owner != address(0), "ERC20: approve from the zero address");
765         require(spender != address(0), "ERC20: approve to the zero address");
766 
767         _allowances[owner][spender] = value;
768         emit Approval(owner, spender, value);
769     }
770 
771     /**
772      * @dev Destoys `amount` tokens from `account`.`amount` is then deducted
773      * from the caller's allowance.
774      *
775      * See `_burn` and `_approve`.
776      */
777     function _burnFrom(address account, uint256 amount) internal {
778         _burn(account, amount);
779         _approve(account, msg.sender, _allowances[account][msg.sender].sub(amount));
780     }
781 }
782 
783 
784 
785 
786 
787 
788 
789 /**
790  * @dev Collection of functions related to the address type,
791  */
792 library Address {
793     /**
794      * @dev Returns true if `account` is a contract.
795      *
796      * This test is non-exhaustive, and there may be false-negatives: during the
797      * execution of a contract's constructor, its address will be reported as
798      * not containing a contract.
799      *
800      * > It is unsafe to assume that an address for which this function returns
801      * false is an externally-owned account (EOA) and not a contract.
802      */
803     function isContract(address account) internal view returns (bool) {
804         // This method relies in extcodesize, which returns 0 for contracts in
805         // construction, since the code is only stored at the end of the
806         // constructor execution.
807 
808         uint256 size;
809         // solhint-disable-next-line no-inline-assembly
810         assembly { size := extcodesize(account) }
811         return size > 0;
812     }
813 }
814 
815 
816 /**
817  * @title SafeERC20
818  * @dev Wrappers around ERC20 operations that throw on failure (when the token
819  * contract returns false). Tokens that return no value (and instead revert or
820  * throw on failure) are also supported, non-reverting calls are assumed to be
821  * successful.
822  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
823  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
824  */
825 library SafeERC20 {
826     using SafeMath for uint256;
827     using Address for address;
828 
829     function safeTransfer(IERC20 token, address to, uint256 value) internal {
830         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
831     }
832 
833     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
834         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
835     }
836 
837     function safeApprove(IERC20 token, address spender, uint256 value) internal {
838         // safeApprove should only be called when setting an initial allowance,
839         // or when resetting it to zero. To increase and decrease it, use
840         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
841         // solhint-disable-next-line max-line-length
842         require((value == 0) || (token.allowance(address(this), spender) == 0),
843             "SafeERC20: approve from non-zero to non-zero allowance"
844         );
845         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
846     }
847 
848     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
849         uint256 newAllowance = token.allowance(address(this), spender).add(value);
850         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
851     }
852 
853     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
854         uint256 newAllowance = token.allowance(address(this), spender).sub(value);
855         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
856     }
857 
858     /**
859      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
860      * on the return value: the return value is optional (but if data is returned, it must not be false).
861      * @param token The token targeted by the call.
862      * @param data The call data (encoded using abi.encode or one of its variants).
863      */
864     function callOptionalReturn(IERC20 token, bytes memory data) private {
865         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
866         // we're implementing it ourselves.
867 
868         // A Solidity high level call has three parts:
869         //  1. The target address is checked to verify it contains contract code
870         //  2. The call itself is made, and success asserted
871         //  3. The return value is decoded, which in turn checks the size of the returned data.
872         // solhint-disable-next-line max-line-length
873         require(address(token).isContract(), "SafeERC20: call to non-contract");
874 
875         // solhint-disable-next-line avoid-low-level-calls
876         (bool success, bytes memory returndata) = address(token).call(data);
877         require(success, "SafeERC20: low-level call failed");
878 
879         if (returndata.length > 0) { // Return data is optional
880             // solhint-disable-next-line max-line-length
881             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
882         }
883     }
884 }
885 
886 /*
887 Copyright 2018 Binod Nirvan
888 
889 Licensed under the Apache License, Version 2.0 (the "License");
890 you may not use this file except in compliance with the License.
891 You may obtain a copy of the License at
892 
893     http://www.apache.org/licenses/LICENSE-2.0
894 
895 Unless required by applicable law or agreed to in writing, software
896 distributed under the License is distributed on an "AS IS" BASIS,
897 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
898 See the License for the specific language governing permissions and
899 limitations under the License.
900  */
901 
902 
903 
904 
905 
906 ///@title Capped Transfer
907 ///@author Binod Nirvan
908 ///@notice The capped transfer contract outlines the rules on the maximum amount of ERC20 or Ether transfer for each transaction.
909 contract CappedTransfer is CustomPausable {
910   event CapChanged(uint256 maximumTransfer, uint256 maximumTransferWei, uint256 oldMaximumTransfer, uint256 oldMaximumTransferWei);
911 
912   //Zero means unlimited transfer
913   uint256 private _maximumTransfer = 0;
914   uint256 private _maximumTransferWei = 0;
915 
916   ///@notice Ensures that the requested ERC20 transfer amount is within the maximum allowed limit.
917   ///@param amount The amount being requested to be transferred out of this contract.
918   ///@return Returns true if the transfer request is valid and acceptable.
919   function checkIfValidTransfer(uint256 amount) public view returns(bool) {
920     require(amount > 0, "Access is denied.");
921 
922     if(_maximumTransfer > 0) {
923       require(amount <= _maximumTransfer, "Sorry but the amount you're transferring is too much.");
924     }
925 
926     return true;
927   }
928 
929   ///@notice Ensures that the requested wei transfer amount is within the maximum allowed limit.
930   ///@param amount The Ether wei unit amount being requested to be transferred out of this contract.
931   ///@return Returns true if the transfer request is valid and acceptable.
932   function checkIfValidWeiTransfer(uint256 amount) public view returns(bool) {
933     require(amount > 0, "Access is denied.");
934 
935     if(_maximumTransferWei > 0) {
936       require(amount <= _maximumTransferWei, "Sorry but the amount you're transferring is too much.");
937     }
938 
939     return true;
940   }
941 
942   ///@notice Sets the maximum cap for a single ERC20 and Ether transfer.
943   ///@return Returns true if the operation was successful.
944   function setCap(uint256 cap, uint256 weiCap) external onlyOwner whenNotPaused returns(bool) {
945     emit CapChanged(cap, weiCap, _maximumTransfer, _maximumTransferWei);
946 
947     _maximumTransfer = cap;
948     _maximumTransferWei = weiCap;
949     return true;
950   }
951 
952   ///@notice Gets the transfer cap defined in this contract.
953   ///@return Returns maximum allowed value for a single transfer operation of ERC20 token and Ethereum.
954   function getCap() external view returns(uint256, uint256) {
955     return (_maximumTransfer, _maximumTransferWei);
956   }
957 }
958 
959 ///@title Transfer Base Contract
960 ///@author Binod Nirvan
961 ///@notice The base contract which contains features related to token transfers.
962 contract TransferBase is CappedTransfer {
963   using SafeMath for uint256;
964   using SafeERC20 for ERC20;
965 
966   event TransferPerformed(address indexed token, address indexed transferredBy, address indexed destination, uint256 amount);
967   event EtherTransferPerformed(address indexed transferredBy, address indexed destination, uint256 amount);
968 
969   ///@notice Allows the sender to transfer tokens to the beneficiary.
970   ///@param token The ERC20 token to transfer.
971   ///@param destination The destination wallet address to send funds to.
972   ///@param amount The amount of tokens to send to the specified address.
973   ///@return Returns true if the operation was successful.
974   function transferTokens(address token, address destination, uint256 amount)
975   external onlyAdmin whenNotPaused
976   returns(bool) {
977     require(checkIfValidTransfer(amount), "Access is denied.");
978 
979     ERC20 erc20 = ERC20(token);
980 
981     require
982     (
983       erc20.balanceOf(address(this)) >= amount,
984       "You don't have sufficient funds to transfer amount that large."
985     );
986 
987 
988     erc20.safeTransfer(destination, amount);
989 
990 
991     emit TransferPerformed(token, msg.sender, destination, amount);
992     return true;
993   }
994 
995   ///@notice Allows the sender to transfer Ethers to the beneficiary.
996   ///@param destination The destination wallet address to send funds to.
997   ///@param amount The amount of Ether in wei to send to the specified address.
998   ///@return Returns true if the operation was successful.
999   function transferEthers(address payable destination, uint256 amount)
1000   external onlyAdmin whenNotPaused
1001   returns(bool) {
1002     require(checkIfValidWeiTransfer(amount), "Access is denied.");
1003 
1004     require
1005     (
1006       address(this).balance >= amount,
1007       "You don't have sufficient funds to transfer amount that large."
1008     );
1009 
1010 
1011     destination.transfer(amount);
1012 
1013 
1014     emit EtherTransferPerformed(msg.sender, destination, amount);
1015     return true;
1016   }
1017 
1018   ///@return Returns balance of the ERC20 token held by this contract.
1019   function tokenBalanceOf(address token) external view returns(uint256) {
1020     ERC20 erc20 = ERC20(token);
1021     return erc20.balanceOf(address(this));
1022   }
1023 
1024   ///@notice Accepts incoming funds
1025   function () external payable whenNotPaused {
1026     //nothing to do
1027   }
1028 }
1029 
1030 ///@title Bulk Transfer Contract
1031 ///@author Binod Nirvan
1032 ///@notice The bulk transfer contract enables administrators to transfer an ERC20 token
1033 /// or Ethereum in batches. Every single feature of this contract is strictly restricted to be used by admin(s) only.
1034 contract BulkTransfer is TransferBase {
1035   event BulkTransferPerformed(address indexed token, address indexed transferredBy, uint256 length, uint256 totalAmount);
1036   event EtherBulkTransferPerformed(address indexed transferredBy, uint256 length, uint256 totalAmount);
1037 
1038   ///@notice Creates a sum total of the supplied values.
1039   ///@param values The collection of values to create the sum from.
1040   ///@return Returns the sum total of the supplied values.
1041   function sumOf(uint256[] memory values) private pure returns(uint256) {
1042     uint256 total = 0;
1043 
1044     for (uint256 i = 0; i < values.length; i++) {
1045       total = total.add(values[i]);
1046     }
1047 
1048     return total;
1049   }
1050 
1051 
1052   ///@notice Allows the requester to perform ERC20 bulk transfer operation.
1053   ///@param token The ERC20 token to bulk transfer.
1054   ///@param destinations The destination wallet addresses to send funds to.
1055   ///@param amounts The respective amount of funds to send to the specified addresses.
1056   ///@return Returns true if the operation was successful.
1057   function bulkTransfer(address token, address[] calldata destinations, uint256[] calldata amounts)
1058   external onlyAdmin whenNotPaused
1059   returns(bool) {
1060     require(destinations.length == amounts.length, "Invalid operation.");
1061 
1062     //Saving gas by first determining if the sender actually has sufficient balance
1063     //to post this transaction.
1064     uint256 requiredBalance = sumOf(amounts);
1065 
1066     //Verifying whether or not this transaction exceeds the maximum allowed ERC20 transfer cap.
1067     require(checkIfValidTransfer(requiredBalance), "Access is denied.");
1068 
1069     ERC20 erc20 = ERC20(token);
1070 
1071     require
1072     (
1073       erc20.balanceOf(address(this)) >= requiredBalance,
1074       "You don't have sufficient funds to transfer amount this big."
1075     );
1076 
1077 
1078     for (uint256 i = 0; i < destinations.length; i++) {
1079       erc20.safeTransfer(destinations[i], amounts[i]);
1080     }
1081 
1082     emit BulkTransferPerformed(token, msg.sender, destinations.length, requiredBalance);
1083     return true;
1084   }
1085 
1086 
1087   ///@notice Allows the requester to perform Ethereum bulk transfer operation.
1088   ///@param destinations The destination wallet addresses to send funds to.
1089   ///@param amounts The respective amount of funds to send to the specified addresses.
1090   ///@return Returns true if the operation was successful.
1091   function bulkTransferEther(address[] calldata destinations, uint256[] calldata amounts)
1092   external onlyAdmin whenNotPaused
1093   returns(bool) {
1094     require(destinations.length == amounts.length, "Invalid operation.");
1095 
1096     //Saving gas by first determining if the sender actually has sufficient balance
1097     //to post this transaction.
1098     uint256 requiredBalance = sumOf(amounts);
1099 
1100     //Verifying whether or not this transaction exceeds the maximum allowed Ethereum transfer cap.
1101     require(checkIfValidWeiTransfer(requiredBalance), "Access is denied.");
1102 
1103     require
1104     (
1105       address(this).balance >= requiredBalance,
1106       "You don't have sufficient funds to transfer amount this big."
1107     );
1108 
1109 
1110     for (uint256 i = 0; i < destinations.length; i++) {
1111       address payable beneficiary = address(uint160(destinations[i]));
1112       beneficiary.transfer(amounts[i]);
1113     }
1114 
1115 
1116     emit EtherBulkTransferPerformed(msg.sender, destinations.length, requiredBalance);
1117     return true;
1118   }
1119 }
1120 /*
1121 Copyright 2018 Binod Nirvan
1122 Licensed under the Apache License, Version 2.0 (the "License");
1123 you may not use this file except in compliance with the License.
1124 You may obtain a copy of the License at
1125     http://www.apache.org/licenses/LICENSE-2.0
1126 Unless required by applicable law or agreed to in writing, software
1127 distributed under the License is distributed on an "AS IS" BASIS,
1128 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1129 See the License for the specific language governing permissions and
1130 limitations under the License.
1131 */
1132 
1133 
1134 
1135 
1136 
1137 
1138 
1139 
1140 ///@title Reclaimable Contract
1141 ///@author Binod Nirvan
1142 ///@notice Reclaimable contract enables the owner
1143 ///to reclaim accidentally sent Ethers and ERC20 token(s)
1144 ///to this contract.
1145 contract Reclaimable is CustomPausable {
1146   using SafeERC20 for ERC20;
1147 
1148   ///@notice Transfers all Ether held by the contract to the caller.
1149   function reclaimEther() external whenNotPaused onlyOwner {
1150     msg.sender.transfer(address(this).balance);
1151   }
1152 
1153   ///@notice Transfers all ERC20 tokens held by the contract to the caller.
1154   ///@param token The amount of token to reclaim.
1155   function reclaimToken(address token) external whenNotPaused onlyOwner {
1156     ERC20 erc20 = ERC20(token);
1157     uint256 balance = erc20.balanceOf(address(this));
1158     erc20.safeTransfer(msg.sender, balance);
1159   }
1160 }
1161 
1162 contract xCryptSharedWallet is BulkTransfer, Reclaimable {
1163 }