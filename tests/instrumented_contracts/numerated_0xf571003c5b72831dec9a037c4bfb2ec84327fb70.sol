1 /*
2 Copyright 2018 Binod Nirvan
3 
4 Licensed under the Apache License, Version 2.0 (the "License");
5 you may not use this file except in compliance with the License.
6 You may obtain a copy of the License at
7 
8     http://www.apache.org/licenses/LICENSE-2.0
9 
10 Unless required by applicable law or agreed to in writing, software
11 distributed under the License is distributed on an "AS IS" BASIS,
12 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
13 See the License for the specific language governing permissions and
14 limitations under the License.
15  */
16 
17 pragma solidity >=0.4.21 <0.6.0;
18 
19 /*
20 Copyright 2018 Binod Nirvan
21 
22 Licensed under the Apache License, Version 2.0 (the "License");
23 you may not use this file except in compliance with the License.
24 You may obtain a copy of the License at
25 
26     http://www.apache.org/licenses/LICENSE-2.0
27 
28 Unless required by applicable law or agreed to in writing, software
29 distributed under the License is distributed on an "AS IS" BASIS,
30 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
31 See the License for the specific language governing permissions and
32 limitations under the License.
33  */
34 
35 
36 
37 /*
38 Copyright 2018 Binod Nirvan
39 
40 Licensed under the Apache License, Version 2.0 (the "License");
41 you may not use this file except in compliance with the License.
42 You may obtain a copy of the License at
43 
44     http://www.apache.org/licenses/LICENSE-2.0
45 
46 Unless required by applicable law or agreed to in writing, software
47 distributed under the License is distributed on an "AS IS" BASIS,
48 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
49 See the License for the specific language governing permissions and
50 limitations under the License.
51  */
52 
53 
54 
55 /*
56 Copyright 2018 Binod Nirvan
57 
58 Licensed under the Apache License, Version 2.0 (the "License");
59 you may not use this file except in compliance with the License.
60 You may obtain a copy of the License at
61 
62     http://www.apache.org/licenses/LICENSE-2.0
63 
64 Unless required by applicable law or agreed to in writing, software
65 distributed under the License is distributed on an "AS IS" BASIS,
66 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
67 See the License for the specific language governing permissions and
68 limitations under the License.
69  */
70 
71 
72 /*
73 Copyright 2018 Binod Nirvan
74 
75 Licensed under the Apache License, Version 2.0 (the "License");
76 you may not use this file except in compliance with the License.
77 You may obtain a copy of the License at
78 
79     http://www.apache.org/licenses/LICENSE-2.0
80 
81 Unless required by applicable law or agreed to in writing, software
82 distributed under the License is distributed on an "AS IS" BASIS,
83 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
84 See the License for the specific language governing permissions and
85 limitations under the License.
86  */
87 
88 
89 
90 
91 /**
92  * @dev Contract module which provides a basic access control mechanism, where
93  * there is an account (an owner) that can be granted exclusive access to
94  * specific functions.
95  *
96  * This module is used through inheritance. It will make available the modifier
97  * `onlyOwner`, which can be aplied to your functions to restrict their use to
98  * the owner.
99  */
100 contract Ownable {
101     address private _owner;
102 
103     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
104 
105     /**
106      * @dev Initializes the contract setting the deployer as the initial owner.
107      */
108     constructor () internal {
109         _owner = msg.sender;
110         emit OwnershipTransferred(address(0), _owner);
111     }
112 
113     /**
114      * @dev Returns the address of the current owner.
115      */
116     function owner() public view returns (address) {
117         return _owner;
118     }
119 
120     /**
121      * @dev Throws if called by any account other than the owner.
122      */
123     modifier onlyOwner() {
124         require(isOwner(), "Ownable: caller is not the owner");
125         _;
126     }
127 
128     /**
129      * @dev Returns true if the caller is the current owner.
130      */
131     function isOwner() public view returns (bool) {
132         return msg.sender == _owner;
133     }
134 
135     /**
136      * @dev Leaves the contract without owner. It will not be possible to call
137      * `onlyOwner` functions anymore. Can only be called by the current owner.
138      *
139      * > Note: Renouncing ownership will leave the contract without an owner,
140      * thereby removing any functionality that is only available to the owner.
141      */
142     function renounceOwnership() public onlyOwner {
143         emit OwnershipTransferred(_owner, address(0));
144         _owner = address(0);
145     }
146 
147     /**
148      * @dev Transfers ownership of the contract to a new account (`newOwner`).
149      * Can only be called by the current owner.
150      */
151     function transferOwnership(address newOwner) public onlyOwner {
152         _transferOwnership(newOwner);
153     }
154 
155     /**
156      * @dev Transfers ownership of the contract to a new account (`newOwner`).
157      */
158     function _transferOwnership(address newOwner) internal {
159         require(newOwner != address(0), "Ownable: new owner is the zero address");
160         emit OwnershipTransferred(_owner, newOwner);
161         _owner = newOwner;
162     }
163 }
164 
165 
166 ///@title Custom Ownable
167 ///@notice Custom ownable contract.
168 contract CustomOwnable is Ownable {
169   ///The trustee wallet.
170   address private _trustee;
171 
172   event TrusteeAssigned(address indexed account);
173 
174   ///@notice Validates if the sender is actually the trustee.
175   modifier onlyTrustee() {
176     require(msg.sender == _trustee, "Access is denied.");
177     _;
178   }
179 
180   ///@notice Assigns or changes the trustee wallet.
181   ///@param account A wallet address which will become the new trustee.
182   ///@return Returns true if the operation was successful.
183   function assignTrustee(address account) external onlyOwner returns(bool) {
184     require(account != address(0), "Please provide a valid address for trustee.");
185 
186     _trustee = account;
187     emit TrusteeAssigned(account);
188     return true;
189   }
190 
191   ///@notice Changes the owner of this contract.
192   ///@param newOwner Specify a wallet address which will become the new owner.
193   ///@return Returns true if the operation was successful.
194   function reassignOwner(address newOwner) external onlyTrustee returns(bool) {
195     super._transferOwnership(newOwner);
196     return true;
197   }
198 
199   ///@notice The trustee wallet has the power to change the owner in case of unforeseen or unavoidable situation.
200   ///@return Wallet address of the trustee account.
201   function getTrustee() external view returns(address) {
202     return _trustee;
203   }
204 }
205 
206 ///@title Custom Admin
207 ///@notice Custom admin contract provides features to have multiple administrators
208 /// who can collective perform admin-related tasks instead of depending on the owner.
209 /// &nbsp;
210 /// It is assumed by default that the owner is more power than admins
211 /// and therefore cannot be added to or removed from the admin list.
212 contract CustomAdmin is CustomOwnable {
213   ///List of administrators.
214   mapping(address => bool) private _admins;
215 
216   event AdminAdded(address indexed account);
217   event AdminRemoved(address indexed account);
218 
219   ///@notice Validates if the sender is actually an administrator.
220   modifier onlyAdmin() {
221     require(isAdmin(msg.sender), "Access is denied.");
222     _;
223   }
224 
225   ///@notice Adds the specified address to the list of administrators.
226   ///@param account The address to add to the administrator list.
227   ///@return Returns true if the operation was successful.
228   function addAdmin(address account) external onlyAdmin returns(bool) {
229     require(account != address(0), "Invalid address.");
230     require(!_admins[account], "This address is already an administrator.");
231 
232     require(account != super.owner(), "The owner cannot be added or removed to or from the administrator list.");
233 
234     _admins[account] = true;
235 
236     emit AdminAdded(account);
237     return true;
238   }
239 
240   ///@notice Adds multiple addresses to the administrator list.
241   ///@param accounts The account addresses to add to the administrator list.
242   ///@return Returns true if the operation was successful.
243   function addManyAdmins(address[] calldata accounts) external onlyAdmin returns(bool) {
244     for(uint8 i = 0; i < accounts.length; i++) {
245       address account = accounts[i];
246 
247       ///Zero address cannot be an admin.
248       ///The owner is already an admin and cannot be assigned.
249       ///The address cannot be an existing admin.
250       if(account != address(0) && !_admins[account] && account != super.owner()) {
251         _admins[account] = true;
252 
253         emit AdminAdded(accounts[i]);
254       }
255     }
256 
257     return true;
258   }
259 
260   ///@notice Removes the specified address from the list of administrators.
261   ///@param account The address to remove from the administrator list.
262   ///@return Returns true if the operation was successful.
263   function removeAdmin(address account) external onlyAdmin returns(bool) {
264     require(account != address(0), "Invalid address.");
265     require(_admins[account], "This address isn't an administrator.");
266 
267     //The owner cannot be removed as admin.
268     require(account != super.owner(), "The owner cannot be added or removed to or from the administrator list.");
269 
270     _admins[account] = false;
271     emit AdminRemoved(account);
272     return true;
273   }
274 
275   ///@notice Removes multiple addresses to the administrator list.
276   ///@param accounts The account addresses to add to the administrator list.
277   ///@return Returns true if the operation was successful.
278   function removeManyAdmins(address[] calldata accounts) external onlyAdmin returns(bool) {
279     for(uint8 i = 0; i < accounts.length; i++) {
280       address account = accounts[i];
281 
282       ///Zero address can neither be added or removed from this list.
283       ///The owner is the super admin and cannot be removed.
284       ///The address must be an existing admin in order for it to be removed.
285       if(account != address(0) && _admins[account] && account != super.owner()) {
286         _admins[account] = false;
287 
288         emit AdminRemoved(accounts[i]);
289       }
290     }
291 
292     return true;
293   }
294 
295   ///@notice Checks if an address is an administrator.
296   ///@return Returns true if the specified wallet is infact an administrator.
297   function isAdmin(address account) public view returns(bool) {
298     if(account == super.owner()) {
299       //The owner has all rights and privileges assigned to the admins.
300       return true;
301     }
302 
303     return _admins[account];
304   }
305 }
306 
307 ///@title Custom Pausable Contract
308 ///@notice This contract provides pausable mechanism to stop in case of emergency.
309 /// The "pausable" features can be used and set by the contract administrators
310 /// and the owner.
311 contract CustomPausable is CustomAdmin {
312   event Paused();
313   event Unpaused();
314 
315   bool private _paused = false;
316 
317   ///@notice Ensures that the contract is not paused.
318   modifier whenNotPaused() {
319     require(!_paused, "Sorry but the contract is paused.");
320     _;
321   }
322 
323   ///@notice Ensures that the contract is paused.
324   modifier whenPaused() {
325     require(_paused, "Sorry but the contract isn't paused.");
326     _;
327   }
328 
329   ///@notice Pauses the contract.
330   function pause() external onlyAdmin whenNotPaused {
331     _paused = true;
332     emit Paused();
333   }
334 
335   ///@notice Unpauses the contract and returns to normal state.
336   function unpause() external onlyAdmin whenPaused {
337     _paused = false;
338     emit Unpaused();
339   }
340 
341   ///@notice Indicates if the contract is paused.
342   ///@return Returns true if this contract is paused.
343   function isPaused() external view returns(bool) {
344     return _paused;
345   }
346 }
347 /*
348 Copyright 2018 Binod Nirvan
349 
350 Licensed under the Apache License, Version 2.0 (the "License");
351 you may not use this file except in compliance with the License.
352 You may obtain a copy of the License at
353 
354     http://www.apache.org/licenses/LICENSE-2.0
355 
356 Unless required by applicable law or agreed to in writing, software
357 distributed under the License is distributed on an "AS IS" BASIS,
358 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
359 See the License for the specific language governing permissions and
360 limitations under the License.
361  */
362 
363 
364 
365 
366 
367 
368 
369 /**
370  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
371  * the optional functions; to access them see `ERC20Detailed`.
372  */
373 interface IERC20 {
374     /**
375      * @dev Returns the amount of tokens in existence.
376      */
377     function totalSupply() external view returns (uint256);
378 
379     /**
380      * @dev Returns the amount of tokens owned by `account`.
381      */
382     function balanceOf(address account) external view returns (uint256);
383 
384     /**
385      * @dev Moves `amount` tokens from the caller's account to `recipient`.
386      *
387      * Returns a boolean value indicating whether the operation succeeded.
388      *
389      * Emits a `Transfer` event.
390      */
391     function transfer(address recipient, uint256 amount) external returns (bool);
392 
393     /**
394      * @dev Returns the remaining number of tokens that `spender` will be
395      * allowed to spend on behalf of `owner` through `transferFrom`. This is
396      * zero by default.
397      *
398      * This value changes when `approve` or `transferFrom` are called.
399      */
400     function allowance(address owner, address spender) external view returns (uint256);
401 
402     /**
403      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
404      *
405      * Returns a boolean value indicating whether the operation succeeded.
406      *
407      * > Beware that changing an allowance with this method brings the risk
408      * that someone may use both the old and the new allowance by unfortunate
409      * transaction ordering. One possible solution to mitigate this race
410      * condition is to first reduce the spender's allowance to 0 and set the
411      * desired value afterwards:
412      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
413      *
414      * Emits an `Approval` event.
415      */
416     function approve(address spender, uint256 amount) external returns (bool);
417 
418     /**
419      * @dev Moves `amount` tokens from `sender` to `recipient` using the
420      * allowance mechanism. `amount` is then deducted from the caller's
421      * allowance.
422      *
423      * Returns a boolean value indicating whether the operation succeeded.
424      *
425      * Emits a `Transfer` event.
426      */
427     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
428 
429     /**
430      * @dev Emitted when `value` tokens are moved from one account (`from`) to
431      * another (`to`).
432      *
433      * Note that `value` may be zero.
434      */
435     event Transfer(address indexed from, address indexed to, uint256 value);
436 
437     /**
438      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
439      * a call to `approve`. `value` is the new allowance.
440      */
441     event Approval(address indexed owner, address indexed spender, uint256 value);
442 }
443 
444 
445 
446 /**
447  * @dev Wrappers over Solidity's arithmetic operations with added overflow
448  * checks.
449  *
450  * Arithmetic operations in Solidity wrap on overflow. This can easily result
451  * in bugs, because programmers usually assume that an overflow raises an
452  * error, which is the standard behavior in high level programming languages.
453  * `SafeMath` restores this intuition by reverting the transaction when an
454  * operation overflows.
455  *
456  * Using this library instead of the unchecked operations eliminates an entire
457  * class of bugs, so it's recommended to use it always.
458  */
459 library SafeMath {
460     /**
461      * @dev Returns the addition of two unsigned integers, reverting on
462      * overflow.
463      *
464      * Counterpart to Solidity's `+` operator.
465      *
466      * Requirements:
467      * - Addition cannot overflow.
468      */
469     function add(uint256 a, uint256 b) internal pure returns (uint256) {
470         uint256 c = a + b;
471         require(c >= a, "SafeMath: addition overflow");
472 
473         return c;
474     }
475 
476     /**
477      * @dev Returns the subtraction of two unsigned integers, reverting on
478      * overflow (when the result is negative).
479      *
480      * Counterpart to Solidity's `-` operator.
481      *
482      * Requirements:
483      * - Subtraction cannot overflow.
484      */
485     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
486         require(b <= a, "SafeMath: subtraction overflow");
487         uint256 c = a - b;
488 
489         return c;
490     }
491 
492     /**
493      * @dev Returns the multiplication of two unsigned integers, reverting on
494      * overflow.
495      *
496      * Counterpart to Solidity's `*` operator.
497      *
498      * Requirements:
499      * - Multiplication cannot overflow.
500      */
501     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
502         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
503         // benefit is lost if 'b' is also tested.
504         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
505         if (a == 0) {
506             return 0;
507         }
508 
509         uint256 c = a * b;
510         require(c / a == b, "SafeMath: multiplication overflow");
511 
512         return c;
513     }
514 
515     /**
516      * @dev Returns the integer division of two unsigned integers. Reverts on
517      * division by zero. The result is rounded towards zero.
518      *
519      * Counterpart to Solidity's `/` operator. Note: this function uses a
520      * `revert` opcode (which leaves remaining gas untouched) while Solidity
521      * uses an invalid opcode to revert (consuming all remaining gas).
522      *
523      * Requirements:
524      * - The divisor cannot be zero.
525      */
526     function div(uint256 a, uint256 b) internal pure returns (uint256) {
527         // Solidity only automatically asserts when dividing by 0
528         require(b > 0, "SafeMath: division by zero");
529         uint256 c = a / b;
530         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
531 
532         return c;
533     }
534 
535     /**
536      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
537      * Reverts when dividing by zero.
538      *
539      * Counterpart to Solidity's `%` operator. This function uses a `revert`
540      * opcode (which leaves remaining gas untouched) while Solidity uses an
541      * invalid opcode to revert (consuming all remaining gas).
542      *
543      * Requirements:
544      * - The divisor cannot be zero.
545      */
546     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
547         require(b != 0, "SafeMath: modulo by zero");
548         return a % b;
549     }
550 }
551 
552 
553 /**
554  * @dev Implementation of the `IERC20` interface.
555  *
556  * This implementation is agnostic to the way tokens are created. This means
557  * that a supply mechanism has to be added in a derived contract using `_mint`.
558  * For a generic mechanism see `ERC20Mintable`.
559  *
560  * *For a detailed writeup see our guide [How to implement supply
561  * mechanisms](https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226).*
562  *
563  * We have followed general OpenZeppelin guidelines: functions revert instead
564  * of returning `false` on failure. This behavior is nonetheless conventional
565  * and does not conflict with the expectations of ERC20 applications.
566  *
567  * Additionally, an `Approval` event is emitted on calls to `transferFrom`.
568  * This allows applications to reconstruct the allowance for all accounts just
569  * by listening to said events. Other implementations of the EIP may not emit
570  * these events, as it isn't required by the specification.
571  *
572  * Finally, the non-standard `decreaseAllowance` and `increaseAllowance`
573  * functions have been added to mitigate the well-known issues around setting
574  * allowances. See `IERC20.approve`.
575  */
576 contract ERC20 is IERC20 {
577     using SafeMath for uint256;
578 
579     mapping (address => uint256) private _balances;
580 
581     mapping (address => mapping (address => uint256)) private _allowances;
582 
583     uint256 private _totalSupply;
584 
585     /**
586      * @dev See `IERC20.totalSupply`.
587      */
588     function totalSupply() public view returns (uint256) {
589         return _totalSupply;
590     }
591 
592     /**
593      * @dev See `IERC20.balanceOf`.
594      */
595     function balanceOf(address account) public view returns (uint256) {
596         return _balances[account];
597     }
598 
599     /**
600      * @dev See `IERC20.transfer`.
601      *
602      * Requirements:
603      *
604      * - `recipient` cannot be the zero address.
605      * - the caller must have a balance of at least `amount`.
606      */
607     function transfer(address recipient, uint256 amount) public returns (bool) {
608         _transfer(msg.sender, recipient, amount);
609         return true;
610     }
611 
612     /**
613      * @dev See `IERC20.allowance`.
614      */
615     function allowance(address owner, address spender) public view returns (uint256) {
616         return _allowances[owner][spender];
617     }
618 
619     /**
620      * @dev See `IERC20.approve`.
621      *
622      * Requirements:
623      *
624      * - `spender` cannot be the zero address.
625      */
626     function approve(address spender, uint256 value) public returns (bool) {
627         _approve(msg.sender, spender, value);
628         return true;
629     }
630 
631     /**
632      * @dev See `IERC20.transferFrom`.
633      *
634      * Emits an `Approval` event indicating the updated allowance. This is not
635      * required by the EIP. See the note at the beginning of `ERC20`;
636      *
637      * Requirements:
638      * - `sender` and `recipient` cannot be the zero address.
639      * - `sender` must have a balance of at least `value`.
640      * - the caller must have allowance for `sender`'s tokens of at least
641      * `amount`.
642      */
643     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
644         _transfer(sender, recipient, amount);
645         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount));
646         return true;
647     }
648 
649     /**
650      * @dev Atomically increases the allowance granted to `spender` by the caller.
651      *
652      * This is an alternative to `approve` that can be used as a mitigation for
653      * problems described in `IERC20.approve`.
654      *
655      * Emits an `Approval` event indicating the updated allowance.
656      *
657      * Requirements:
658      *
659      * - `spender` cannot be the zero address.
660      */
661     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
662         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
663         return true;
664     }
665 
666     /**
667      * @dev Atomically decreases the allowance granted to `spender` by the caller.
668      *
669      * This is an alternative to `approve` that can be used as a mitigation for
670      * problems described in `IERC20.approve`.
671      *
672      * Emits an `Approval` event indicating the updated allowance.
673      *
674      * Requirements:
675      *
676      * - `spender` cannot be the zero address.
677      * - `spender` must have allowance for the caller of at least
678      * `subtractedValue`.
679      */
680     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
681         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue));
682         return true;
683     }
684 
685     /**
686      * @dev Moves tokens `amount` from `sender` to `recipient`.
687      *
688      * This is internal function is equivalent to `transfer`, and can be used to
689      * e.g. implement automatic token fees, slashing mechanisms, etc.
690      *
691      * Emits a `Transfer` event.
692      *
693      * Requirements:
694      *
695      * - `sender` cannot be the zero address.
696      * - `recipient` cannot be the zero address.
697      * - `sender` must have a balance of at least `amount`.
698      */
699     function _transfer(address sender, address recipient, uint256 amount) internal {
700         require(sender != address(0), "ERC20: transfer from the zero address");
701         require(recipient != address(0), "ERC20: transfer to the zero address");
702 
703         _balances[sender] = _balances[sender].sub(amount);
704         _balances[recipient] = _balances[recipient].add(amount);
705         emit Transfer(sender, recipient, amount);
706     }
707 
708     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
709      * the total supply.
710      *
711      * Emits a `Transfer` event with `from` set to the zero address.
712      *
713      * Requirements
714      *
715      * - `to` cannot be the zero address.
716      */
717     function _mint(address account, uint256 amount) internal {
718         require(account != address(0), "ERC20: mint to the zero address");
719 
720         _totalSupply = _totalSupply.add(amount);
721         _balances[account] = _balances[account].add(amount);
722         emit Transfer(address(0), account, amount);
723     }
724 
725      /**
726      * @dev Destoys `amount` tokens from `account`, reducing the
727      * total supply.
728      *
729      * Emits a `Transfer` event with `to` set to the zero address.
730      *
731      * Requirements
732      *
733      * - `account` cannot be the zero address.
734      * - `account` must have at least `amount` tokens.
735      */
736     function _burn(address account, uint256 value) internal {
737         require(account != address(0), "ERC20: burn from the zero address");
738 
739         _totalSupply = _totalSupply.sub(value);
740         _balances[account] = _balances[account].sub(value);
741         emit Transfer(account, address(0), value);
742     }
743 
744     /**
745      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
746      *
747      * This is internal function is equivalent to `approve`, and can be used to
748      * e.g. set automatic allowances for certain subsystems, etc.
749      *
750      * Emits an `Approval` event.
751      *
752      * Requirements:
753      *
754      * - `owner` cannot be the zero address.
755      * - `spender` cannot be the zero address.
756      */
757     function _approve(address owner, address spender, uint256 value) internal {
758         require(owner != address(0), "ERC20: approve from the zero address");
759         require(spender != address(0), "ERC20: approve to the zero address");
760 
761         _allowances[owner][spender] = value;
762         emit Approval(owner, spender, value);
763     }
764 
765     /**
766      * @dev Destoys `amount` tokens from `account`.`amount` is then deducted
767      * from the caller's allowance.
768      *
769      * See `_burn` and `_approve`.
770      */
771     function _burnFrom(address account, uint256 amount) internal {
772         _burn(account, amount);
773         _approve(account, msg.sender, _allowances[account][msg.sender].sub(amount));
774     }
775 }
776 
777 
778 
779 
780 
781 
782 
783 /**
784  * @dev Collection of functions related to the address type,
785  */
786 library Address {
787     /**
788      * @dev Returns true if `account` is a contract.
789      *
790      * This test is non-exhaustive, and there may be false-negatives: during the
791      * execution of a contract's constructor, its address will be reported as
792      * not containing a contract.
793      *
794      * > It is unsafe to assume that an address for which this function returns
795      * false is an externally-owned account (EOA) and not a contract.
796      */
797     function isContract(address account) internal view returns (bool) {
798         // This method relies in extcodesize, which returns 0 for contracts in
799         // construction, since the code is only stored at the end of the
800         // constructor execution.
801 
802         uint256 size;
803         // solhint-disable-next-line no-inline-assembly
804         assembly { size := extcodesize(account) }
805         return size > 0;
806     }
807 }
808 
809 
810 /**
811  * @title SafeERC20
812  * @dev Wrappers around ERC20 operations that throw on failure (when the token
813  * contract returns false). Tokens that return no value (and instead revert or
814  * throw on failure) are also supported, non-reverting calls are assumed to be
815  * successful.
816  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
817  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
818  */
819 library SafeERC20 {
820     using SafeMath for uint256;
821     using Address for address;
822 
823     function safeTransfer(IERC20 token, address to, uint256 value) internal {
824         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
825     }
826 
827     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
828         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
829     }
830 
831     function safeApprove(IERC20 token, address spender, uint256 value) internal {
832         // safeApprove should only be called when setting an initial allowance,
833         // or when resetting it to zero. To increase and decrease it, use
834         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
835         // solhint-disable-next-line max-line-length
836         require((value == 0) || (token.allowance(address(this), spender) == 0),
837             "SafeERC20: approve from non-zero to non-zero allowance"
838         );
839         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
840     }
841 
842     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
843         uint256 newAllowance = token.allowance(address(this), spender).add(value);
844         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
845     }
846 
847     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
848         uint256 newAllowance = token.allowance(address(this), spender).sub(value);
849         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
850     }
851 
852     /**
853      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
854      * on the return value: the return value is optional (but if data is returned, it must not be false).
855      * @param token The token targeted by the call.
856      * @param data The call data (encoded using abi.encode or one of its variants).
857      */
858     function callOptionalReturn(IERC20 token, bytes memory data) private {
859         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
860         // we're implementing it ourselves.
861 
862         // A Solidity high level call has three parts:
863         //  1. The target address is checked to verify it contains contract code
864         //  2. The call itself is made, and success asserted
865         //  3. The return value is decoded, which in turn checks the size of the returned data.
866         // solhint-disable-next-line max-line-length
867         require(address(token).isContract(), "SafeERC20: call to non-contract");
868 
869         // solhint-disable-next-line avoid-low-level-calls
870         (bool success, bytes memory returndata) = address(token).call(data);
871         require(success, "SafeERC20: low-level call failed");
872 
873         if (returndata.length > 0) { // Return data is optional
874             // solhint-disable-next-line max-line-length
875             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
876         }
877     }
878 }
879 
880 /*
881 Copyright 2018 Binod Nirvan
882 
883 Licensed under the Apache License, Version 2.0 (the "License");
884 you may not use this file except in compliance with the License.
885 You may obtain a copy of the License at
886 
887     http://www.apache.org/licenses/LICENSE-2.0
888 
889 Unless required by applicable law or agreed to in writing, software
890 distributed under the License is distributed on an "AS IS" BASIS,
891 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
892 See the License for the specific language governing permissions and
893 limitations under the License.
894  */
895 
896 
897 
898 
899 
900 ///@title Capped Transfer
901 ///@author Binod Nirvan
902 ///@notice The capped transfer contract outlines the rules on the maximum amount of ERC20 or Ether transfer for each transaction.
903 contract CappedTransfer is CustomPausable {
904   event CapChanged(uint256 maximumTransfer, uint256 maximumTransferWei, uint256 oldMaximumTransfer, uint256 oldMaximumTransferWei);
905 
906   //Zero means unlimited transfer
907   uint256 private _maximumTransfer = 0;
908   uint256 private _maximumTransferWei = 0;
909 
910   ///@notice Ensures that the requested ERC20 transfer amount is within the maximum allowed limit.
911   ///@param amount The amount being requested to be transferred out of this contract.
912   ///@return Returns true if the transfer request is valid and acceptable.
913   function checkIfValidTransfer(uint256 amount) public view returns(bool) {
914     require(amount > 0, "Access is denied.");
915 
916     if(_maximumTransfer > 0) {
917       require(amount <= _maximumTransfer, "Sorry but the amount you're transferring is too much.");
918     }
919 
920     return true;
921   }
922 
923   ///@notice Ensures that the requested wei transfer amount is within the maximum allowed limit.
924   ///@param amount The Ether wei unit amount being requested to be transferred out of this contract.
925   ///@return Returns true if the transfer request is valid and acceptable.
926   function checkIfValidWeiTransfer(uint256 amount) public view returns(bool) {
927     require(amount > 0, "Access is denied.");
928 
929     if(_maximumTransferWei > 0) {
930       require(amount <= _maximumTransferWei, "Sorry but the amount you're transferring is too much.");
931     }
932 
933     return true;
934   }
935 
936   ///@notice Sets the maximum cap for a single ERC20 and Ether transfer.
937   ///@return Returns true if the operation was successful.
938   function setCap(uint256 cap, uint256 weiCap) external onlyOwner whenNotPaused returns(bool) {
939     emit CapChanged(cap, weiCap, _maximumTransfer, _maximumTransferWei);
940 
941     _maximumTransfer = cap;
942     _maximumTransferWei = weiCap;
943     return true;
944   }
945 
946   ///@notice Gets the transfer cap defined in this contract.
947   ///@return Returns maximum allowed value for a single transfer operation of ERC20 token and Ethereum.
948   function getCap() external view returns(uint256, uint256) {
949     return (_maximumTransfer, _maximumTransferWei);
950   }
951 }
952 
953 ///@title Transfer Base Contract
954 ///@author Binod Nirvan
955 ///@notice The base contract which contains features related to token transfers.
956 contract TransferBase is CappedTransfer {
957   using SafeMath for uint256;
958   using SafeERC20 for ERC20;
959 
960   event TransferPerformed(address indexed token, address indexed transferredBy, address indexed destination, uint256 amount);
961   event EtherTransferPerformed(address indexed transferredBy, address indexed destination, uint256 amount);
962 
963   ///@notice Allows the sender to transfer tokens to the beneficiary.
964   ///@param token The ERC20 token to transfer.
965   ///@param destination The destination wallet address to send funds to.
966   ///@param amount The amount of tokens to send to the specified address.
967   ///@return Returns true if the operation was successful.
968   function transferTokens(address token, address destination, uint256 amount)
969   external onlyAdmin whenNotPaused
970   returns(bool) {
971     require(checkIfValidTransfer(amount), "Access is denied.");
972 
973     ERC20 erc20 = ERC20(token);
974 
975     require
976     (
977       erc20.balanceOf(address(this)) >= amount,
978       "You don't have sufficient funds to transfer amount that large."
979     );
980 
981 
982     erc20.safeTransfer(destination, amount);
983 
984 
985     emit TransferPerformed(token, msg.sender, destination, amount);
986     return true;
987   }
988 
989   ///@notice Allows the sender to transfer Ethers to the beneficiary.
990   ///@param destination The destination wallet address to send funds to.
991   ///@param amount The amount of Ether in wei to send to the specified address.
992   ///@return Returns true if the operation was successful.
993   function transferEthers(address payable destination, uint256 amount)
994   external onlyAdmin whenNotPaused
995   returns(bool) {
996     require(checkIfValidWeiTransfer(amount), "Access is denied.");
997 
998     require
999     (
1000       address(this).balance >= amount,
1001       "You don't have sufficient funds to transfer amount that large."
1002     );
1003 
1004 
1005     destination.transfer(amount);
1006 
1007 
1008     emit EtherTransferPerformed(msg.sender, destination, amount);
1009     return true;
1010   }
1011 
1012   ///@return Returns balance of the ERC20 token held by this contract.
1013   function tokenBalanceOf(address token) external view returns(uint256) {
1014     ERC20 erc20 = ERC20(token);
1015     return erc20.balanceOf(address(this));
1016   }
1017 
1018   ///@notice Accepts incoming funds
1019   function () external payable whenNotPaused {
1020     //nothing to do
1021   }
1022 }
1023 
1024 ///@title Bulk Transfer Contract
1025 ///@author Binod Nirvan
1026 ///@notice The bulk transfer contract enables administrators to transfer an ERC20 token
1027 /// or Ethereum in batches. Every single feature of this contract is strictly restricted to be used by admin(s) only.
1028 contract BulkTransfer is TransferBase {
1029   event BulkTransferPerformed(address indexed token, address indexed transferredBy, uint256 length, uint256 totalAmount);
1030   event EtherBulkTransferPerformed(address indexed transferredBy, uint256 length, uint256 totalAmount);
1031 
1032   ///@notice Creates a sum total of the supplied values.
1033   ///@param values The collection of values to create the sum from.
1034   ///@return Returns the sum total of the supplied values.
1035   function sumOf(uint256[] memory values) private pure returns(uint256) {
1036     uint256 total = 0;
1037 
1038     for (uint256 i = 0; i < values.length; i++) {
1039       total = total.add(values[i]);
1040     }
1041 
1042     return total;
1043   }
1044 
1045 
1046   ///@notice Allows the requester to perform ERC20 bulk transfer operation.
1047   ///@param token The ERC20 token to bulk transfer.
1048   ///@param destinations The destination wallet addresses to send funds to.
1049   ///@param amounts The respective amount of funds to send to the specified addresses.
1050   ///@return Returns true if the operation was successful.
1051   function bulkTransfer(address token, address[] calldata destinations, uint256[] calldata amounts)
1052   external onlyAdmin whenNotPaused
1053   returns(bool) {
1054     require(destinations.length == amounts.length, "Invalid operation.");
1055 
1056     //Saving gas by first determining if the sender actually has sufficient balance
1057     //to post this transaction.
1058     uint256 requiredBalance = sumOf(amounts);
1059 
1060     //Verifying whether or not this transaction exceeds the maximum allowed ERC20 transfer cap.
1061     require(checkIfValidTransfer(requiredBalance), "Access is denied.");
1062 
1063     ERC20 erc20 = ERC20(token);
1064 
1065     require
1066     (
1067       erc20.balanceOf(address(this)) >= requiredBalance,
1068       "You don't have sufficient funds to transfer amount this big."
1069     );
1070 
1071 
1072     for (uint256 i = 0; i < destinations.length; i++) {
1073       erc20.safeTransfer(destinations[i], amounts[i]);
1074     }
1075 
1076     emit BulkTransferPerformed(token, msg.sender, destinations.length, requiredBalance);
1077     return true;
1078   }
1079 
1080 
1081   ///@notice Allows the requester to perform Ethereum bulk transfer operation.
1082   ///@param destinations The destination wallet addresses to send funds to.
1083   ///@param amounts The respective amount of funds to send to the specified addresses.
1084   ///@return Returns true if the operation was successful.
1085   function bulkTransferEther(address[] calldata destinations, uint256[] calldata amounts)
1086   external onlyAdmin whenNotPaused
1087   returns(bool) {
1088     require(destinations.length == amounts.length, "Invalid operation.");
1089 
1090     //Saving gas by first determining if the sender actually has sufficient balance
1091     //to post this transaction.
1092     uint256 requiredBalance = sumOf(amounts);
1093 
1094     //Verifying whether or not this transaction exceeds the maximum allowed Ethereum transfer cap.
1095     require(checkIfValidWeiTransfer(requiredBalance), "Access is denied.");
1096 
1097     require
1098     (
1099       address(this).balance >= requiredBalance,
1100       "You don't have sufficient funds to transfer amount this big."
1101     );
1102 
1103 
1104     for (uint256 i = 0; i < destinations.length; i++) {
1105       address payable beneficiary = address(uint160(destinations[i]));
1106       beneficiary.transfer(amounts[i]);
1107     }
1108 
1109 
1110     emit EtherBulkTransferPerformed(msg.sender, destinations.length, requiredBalance);
1111     return true;
1112   }
1113 }
1114 /*
1115 Copyright 2018 Binod Nirvan
1116 Licensed under the Apache License, Version 2.0 (the "License");
1117 you may not use this file except in compliance with the License.
1118 You may obtain a copy of the License at
1119     http://www.apache.org/licenses/LICENSE-2.0
1120 Unless required by applicable law or agreed to in writing, software
1121 distributed under the License is distributed on an "AS IS" BASIS,
1122 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1123 See the License for the specific language governing permissions and
1124 limitations under the License.
1125 */
1126 
1127 
1128 
1129 
1130 
1131 
1132 
1133 
1134 ///@title Reclaimable Contract
1135 ///@author Binod Nirvan
1136 ///@notice Reclaimable contract enables the owner
1137 ///to reclaim accidentally sent Ethers and ERC20 token(s)
1138 ///to this contract.
1139 contract Reclaimable is CustomPausable {
1140   using SafeERC20 for ERC20;
1141 
1142   ///@notice Transfers all Ether held by the contract to the caller.
1143   function reclaimEther() external whenNotPaused onlyOwner {
1144     msg.sender.transfer(address(this).balance);
1145   }
1146 
1147   ///@notice Transfers all ERC20 tokens held by the contract to the caller.
1148   ///@param token The amount of token to reclaim.
1149   function reclaimToken(address token) external whenNotPaused onlyOwner {
1150     ERC20 erc20 = ERC20(token);
1151     uint256 balance = erc20.balanceOf(address(this));
1152     erc20.safeTransfer(msg.sender, balance);
1153   }
1154 }
1155 
1156 contract SimpleWallet is BulkTransfer, Reclaimable {
1157 }