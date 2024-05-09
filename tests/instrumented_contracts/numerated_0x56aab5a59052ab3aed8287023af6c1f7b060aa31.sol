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
219   event TrusteeAssigned(address indexed account);
220 
221   ///@notice Validates if the sender is actually an administrator.
222   modifier onlyAdmin() {
223     require(isAdmin(msg.sender), "Access is denied.");
224     _;
225   }
226 
227   ///@notice Adds the specified address to the list of administrators.
228   ///@param account The address to add to the administrator list.
229   ///@return Returns true if the operation was successful.
230   function addAdmin(address account) external onlyAdmin returns(bool) {
231     require(account != address(0), "Invalid address.");
232     require(!_admins[account], "This address is already an administrator.");
233 
234     require(account != super.owner(), "The owner cannot be added or removed to or from the administrator list.");
235 
236     _admins[account] = true;
237 
238     emit AdminAdded(account);
239     return true;
240   }
241 
242   ///@notice Adds multiple addresses to the administrator list.
243   ///@param accounts The account addresses to add to the administrator list.
244   ///@return Returns true if the operation was successful.
245   function addManyAdmins(address[] calldata accounts) external onlyAdmin returns(bool) {
246     for(uint8 i = 0; i < accounts.length; i++) {
247       address account = accounts[i];
248 
249       ///Zero address cannot be an admin.
250       ///The owner is already an admin and cannot be assigned.
251       ///The address cannot be an existing admin.
252       if(account != address(0) && !_admins[account] && account != super.owner()) {
253         _admins[account] = true;
254 
255         emit AdminAdded(accounts[i]);
256       }
257     }
258 
259     return true;
260   }
261 
262   ///@notice Removes the specified address from the list of administrators.
263   ///@param account The address to remove from the administrator list.
264   ///@return Returns true if the operation was successful.
265   function removeAdmin(address account) external onlyAdmin returns(bool) {
266     require(account != address(0), "Invalid address.");
267     require(_admins[account], "This address isn't an administrator.");
268 
269     //The owner cannot be removed as admin.
270     require(account != super.owner(), "The owner cannot be added or removed to or from the administrator list.");
271 
272     _admins[account] = false;
273     emit AdminRemoved(account);
274     return true;
275   }
276 
277   ///@notice Removes multiple addresses to the administrator list.
278   ///@param accounts The account addresses to add to the administrator list.
279   ///@return Returns true if the operation was successful.
280   function removeManyAdmins(address[] calldata accounts) external onlyAdmin returns(bool) {
281     for(uint8 i = 0; i < accounts.length; i++) {
282       address account = accounts[i];
283 
284       ///Zero address can neither be added or removed from this list.
285       ///The owner is the super admin and cannot be removed.
286       ///The address must be an existing admin in order for it to be removed.
287       if(account != address(0) && _admins[account] && account != super.owner()) {
288         _admins[account] = false;
289 
290         emit AdminRemoved(accounts[i]);
291       }
292     }
293 
294     return true;
295   }
296 
297   ///@notice Checks if an address is an administrator.
298   ///@return Returns true if the specified wallet is infact an administrator.
299   function isAdmin(address account) public view returns(bool) {
300     if(account == super.owner()) {
301       //The owner has all rights and privileges assigned to the admins.
302       return true;
303     }
304 
305     return _admins[account];
306   }
307 }
308 
309 ///@title Custom Pausable Contract
310 ///@notice This contract provides pausable mechanism to stop in case of emergency.
311 /// The "pausable" features can be used and set by the contract administrators
312 /// and the owner.
313 contract CustomPausable is CustomAdmin {
314   event Paused();
315   event Unpaused();
316 
317   bool private _paused = false;
318 
319   ///@notice Ensures that the contract is not paused.
320   modifier whenNotPaused() {
321     require(!_paused, "Sorry but the contract is paused.");
322     _;
323   }
324 
325   ///@notice Ensures that the contract is paused.
326   modifier whenPaused() {
327     require(_paused, "Sorry but the contract isn't paused.");
328     _;
329   }
330 
331   ///@notice Pauses the contract.
332   function pause() external onlyAdmin whenNotPaused {
333     _paused = true;
334     emit Paused();
335   }
336 
337   ///@notice Unpauses the contract and returns to normal state.
338   function unpause() external onlyAdmin whenPaused {
339     _paused = false;
340     emit Unpaused();
341   }
342 
343   ///@notice Indicates if the contract is paused.
344   ///@return Returns true if this contract is paused.
345   function isPaused() external view returns(bool) {
346     return _paused;
347   }
348 }
349 /*
350 Copyright 2018 Binod Nirvan
351 
352 Licensed under the Apache License, Version 2.0 (the "License");
353 you may not use this file except in compliance with the License.
354 You may obtain a copy of the License at
355 
356     http://www.apache.org/licenses/LICENSE-2.0
357 
358 Unless required by applicable law or agreed to in writing, software
359 distributed under the License is distributed on an "AS IS" BASIS,
360 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
361 See the License for the specific language governing permissions and
362 limitations under the License.
363  */
364 
365 
366 
367 
368 
369 
370 
371 /**
372  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
373  * the optional functions; to access them see `ERC20Detailed`.
374  */
375 interface IERC20 {
376     /**
377      * @dev Returns the amount of tokens in existence.
378      */
379     function totalSupply() external view returns (uint256);
380 
381     /**
382      * @dev Returns the amount of tokens owned by `account`.
383      */
384     function balanceOf(address account) external view returns (uint256);
385 
386     /**
387      * @dev Moves `amount` tokens from the caller's account to `recipient`.
388      *
389      * Returns a boolean value indicating whether the operation succeeded.
390      *
391      * Emits a `Transfer` event.
392      */
393     function transfer(address recipient, uint256 amount) external returns (bool);
394 
395     /**
396      * @dev Returns the remaining number of tokens that `spender` will be
397      * allowed to spend on behalf of `owner` through `transferFrom`. This is
398      * zero by default.
399      *
400      * This value changes when `approve` or `transferFrom` are called.
401      */
402     function allowance(address owner, address spender) external view returns (uint256);
403 
404     /**
405      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
406      *
407      * Returns a boolean value indicating whether the operation succeeded.
408      *
409      * > Beware that changing an allowance with this method brings the risk
410      * that someone may use both the old and the new allowance by unfortunate
411      * transaction ordering. One possible solution to mitigate this race
412      * condition is to first reduce the spender's allowance to 0 and set the
413      * desired value afterwards:
414      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
415      *
416      * Emits an `Approval` event.
417      */
418     function approve(address spender, uint256 amount) external returns (bool);
419 
420     /**
421      * @dev Moves `amount` tokens from `sender` to `recipient` using the
422      * allowance mechanism. `amount` is then deducted from the caller's
423      * allowance.
424      *
425      * Returns a boolean value indicating whether the operation succeeded.
426      *
427      * Emits a `Transfer` event.
428      */
429     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
430 
431     /**
432      * @dev Emitted when `value` tokens are moved from one account (`from`) to
433      * another (`to`).
434      *
435      * Note that `value` may be zero.
436      */
437     event Transfer(address indexed from, address indexed to, uint256 value);
438 
439     /**
440      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
441      * a call to `approve`. `value` is the new allowance.
442      */
443     event Approval(address indexed owner, address indexed spender, uint256 value);
444 }
445 
446 
447 
448 /**
449  * @dev Wrappers over Solidity's arithmetic operations with added overflow
450  * checks.
451  *
452  * Arithmetic operations in Solidity wrap on overflow. This can easily result
453  * in bugs, because programmers usually assume that an overflow raises an
454  * error, which is the standard behavior in high level programming languages.
455  * `SafeMath` restores this intuition by reverting the transaction when an
456  * operation overflows.
457  *
458  * Using this library instead of the unchecked operations eliminates an entire
459  * class of bugs, so it's recommended to use it always.
460  */
461 library SafeMath {
462     /**
463      * @dev Returns the addition of two unsigned integers, reverting on
464      * overflow.
465      *
466      * Counterpart to Solidity's `+` operator.
467      *
468      * Requirements:
469      * - Addition cannot overflow.
470      */
471     function add(uint256 a, uint256 b) internal pure returns (uint256) {
472         uint256 c = a + b;
473         require(c >= a, "SafeMath: addition overflow");
474 
475         return c;
476     }
477 
478     /**
479      * @dev Returns the subtraction of two unsigned integers, reverting on
480      * overflow (when the result is negative).
481      *
482      * Counterpart to Solidity's `-` operator.
483      *
484      * Requirements:
485      * - Subtraction cannot overflow.
486      */
487     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
488         require(b <= a, "SafeMath: subtraction overflow");
489         uint256 c = a - b;
490 
491         return c;
492     }
493 
494     /**
495      * @dev Returns the multiplication of two unsigned integers, reverting on
496      * overflow.
497      *
498      * Counterpart to Solidity's `*` operator.
499      *
500      * Requirements:
501      * - Multiplication cannot overflow.
502      */
503     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
504         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
505         // benefit is lost if 'b' is also tested.
506         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
507         if (a == 0) {
508             return 0;
509         }
510 
511         uint256 c = a * b;
512         require(c / a == b, "SafeMath: multiplication overflow");
513 
514         return c;
515     }
516 
517     /**
518      * @dev Returns the integer division of two unsigned integers. Reverts on
519      * division by zero. The result is rounded towards zero.
520      *
521      * Counterpart to Solidity's `/` operator. Note: this function uses a
522      * `revert` opcode (which leaves remaining gas untouched) while Solidity
523      * uses an invalid opcode to revert (consuming all remaining gas).
524      *
525      * Requirements:
526      * - The divisor cannot be zero.
527      */
528     function div(uint256 a, uint256 b) internal pure returns (uint256) {
529         // Solidity only automatically asserts when dividing by 0
530         require(b > 0, "SafeMath: division by zero");
531         uint256 c = a / b;
532         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
533 
534         return c;
535     }
536 
537     /**
538      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
539      * Reverts when dividing by zero.
540      *
541      * Counterpart to Solidity's `%` operator. This function uses a `revert`
542      * opcode (which leaves remaining gas untouched) while Solidity uses an
543      * invalid opcode to revert (consuming all remaining gas).
544      *
545      * Requirements:
546      * - The divisor cannot be zero.
547      */
548     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
549         require(b != 0, "SafeMath: modulo by zero");
550         return a % b;
551     }
552 }
553 
554 
555 /**
556  * @dev Implementation of the `IERC20` interface.
557  *
558  * This implementation is agnostic to the way tokens are created. This means
559  * that a supply mechanism has to be added in a derived contract using `_mint`.
560  * For a generic mechanism see `ERC20Mintable`.
561  *
562  * *For a detailed writeup see our guide [How to implement supply
563  * mechanisms](https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226).*
564  *
565  * We have followed general OpenZeppelin guidelines: functions revert instead
566  * of returning `false` on failure. This behavior is nonetheless conventional
567  * and does not conflict with the expectations of ERC20 applications.
568  *
569  * Additionally, an `Approval` event is emitted on calls to `transferFrom`.
570  * This allows applications to reconstruct the allowance for all accounts just
571  * by listening to said events. Other implementations of the EIP may not emit
572  * these events, as it isn't required by the specification.
573  *
574  * Finally, the non-standard `decreaseAllowance` and `increaseAllowance`
575  * functions have been added to mitigate the well-known issues around setting
576  * allowances. See `IERC20.approve`.
577  */
578 contract ERC20 is IERC20 {
579     using SafeMath for uint256;
580 
581     mapping (address => uint256) private _balances;
582 
583     mapping (address => mapping (address => uint256)) private _allowances;
584 
585     uint256 private _totalSupply;
586 
587     /**
588      * @dev See `IERC20.totalSupply`.
589      */
590     function totalSupply() public view returns (uint256) {
591         return _totalSupply;
592     }
593 
594     /**
595      * @dev See `IERC20.balanceOf`.
596      */
597     function balanceOf(address account) public view returns (uint256) {
598         return _balances[account];
599     }
600 
601     /**
602      * @dev See `IERC20.transfer`.
603      *
604      * Requirements:
605      *
606      * - `recipient` cannot be the zero address.
607      * - the caller must have a balance of at least `amount`.
608      */
609     function transfer(address recipient, uint256 amount) public returns (bool) {
610         _transfer(msg.sender, recipient, amount);
611         return true;
612     }
613 
614     /**
615      * @dev See `IERC20.allowance`.
616      */
617     function allowance(address owner, address spender) public view returns (uint256) {
618         return _allowances[owner][spender];
619     }
620 
621     /**
622      * @dev See `IERC20.approve`.
623      *
624      * Requirements:
625      *
626      * - `spender` cannot be the zero address.
627      */
628     function approve(address spender, uint256 value) public returns (bool) {
629         _approve(msg.sender, spender, value);
630         return true;
631     }
632 
633     /**
634      * @dev See `IERC20.transferFrom`.
635      *
636      * Emits an `Approval` event indicating the updated allowance. This is not
637      * required by the EIP. See the note at the beginning of `ERC20`;
638      *
639      * Requirements:
640      * - `sender` and `recipient` cannot be the zero address.
641      * - `sender` must have a balance of at least `value`.
642      * - the caller must have allowance for `sender`'s tokens of at least
643      * `amount`.
644      */
645     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
646         _transfer(sender, recipient, amount);
647         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount));
648         return true;
649     }
650 
651     /**
652      * @dev Atomically increases the allowance granted to `spender` by the caller.
653      *
654      * This is an alternative to `approve` that can be used as a mitigation for
655      * problems described in `IERC20.approve`.
656      *
657      * Emits an `Approval` event indicating the updated allowance.
658      *
659      * Requirements:
660      *
661      * - `spender` cannot be the zero address.
662      */
663     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
664         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
665         return true;
666     }
667 
668     /**
669      * @dev Atomically decreases the allowance granted to `spender` by the caller.
670      *
671      * This is an alternative to `approve` that can be used as a mitigation for
672      * problems described in `IERC20.approve`.
673      *
674      * Emits an `Approval` event indicating the updated allowance.
675      *
676      * Requirements:
677      *
678      * - `spender` cannot be the zero address.
679      * - `spender` must have allowance for the caller of at least
680      * `subtractedValue`.
681      */
682     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
683         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue));
684         return true;
685     }
686 
687     /**
688      * @dev Moves tokens `amount` from `sender` to `recipient`.
689      *
690      * This is internal function is equivalent to `transfer`, and can be used to
691      * e.g. implement automatic token fees, slashing mechanisms, etc.
692      *
693      * Emits a `Transfer` event.
694      *
695      * Requirements:
696      *
697      * - `sender` cannot be the zero address.
698      * - `recipient` cannot be the zero address.
699      * - `sender` must have a balance of at least `amount`.
700      */
701     function _transfer(address sender, address recipient, uint256 amount) internal {
702         require(sender != address(0), "ERC20: transfer from the zero address");
703         require(recipient != address(0), "ERC20: transfer to the zero address");
704 
705         _balances[sender] = _balances[sender].sub(amount);
706         _balances[recipient] = _balances[recipient].add(amount);
707         emit Transfer(sender, recipient, amount);
708     }
709 
710     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
711      * the total supply.
712      *
713      * Emits a `Transfer` event with `from` set to the zero address.
714      *
715      * Requirements
716      *
717      * - `to` cannot be the zero address.
718      */
719     function _mint(address account, uint256 amount) internal {
720         require(account != address(0), "ERC20: mint to the zero address");
721 
722         _totalSupply = _totalSupply.add(amount);
723         _balances[account] = _balances[account].add(amount);
724         emit Transfer(address(0), account, amount);
725     }
726 
727      /**
728      * @dev Destoys `amount` tokens from `account`, reducing the
729      * total supply.
730      *
731      * Emits a `Transfer` event with `to` set to the zero address.
732      *
733      * Requirements
734      *
735      * - `account` cannot be the zero address.
736      * - `account` must have at least `amount` tokens.
737      */
738     function _burn(address account, uint256 value) internal {
739         require(account != address(0), "ERC20: burn from the zero address");
740 
741         _totalSupply = _totalSupply.sub(value);
742         _balances[account] = _balances[account].sub(value);
743         emit Transfer(account, address(0), value);
744     }
745 
746     /**
747      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
748      *
749      * This is internal function is equivalent to `approve`, and can be used to
750      * e.g. set automatic allowances for certain subsystems, etc.
751      *
752      * Emits an `Approval` event.
753      *
754      * Requirements:
755      *
756      * - `owner` cannot be the zero address.
757      * - `spender` cannot be the zero address.
758      */
759     function _approve(address owner, address spender, uint256 value) internal {
760         require(owner != address(0), "ERC20: approve from the zero address");
761         require(spender != address(0), "ERC20: approve to the zero address");
762 
763         _allowances[owner][spender] = value;
764         emit Approval(owner, spender, value);
765     }
766 
767     /**
768      * @dev Destoys `amount` tokens from `account`.`amount` is then deducted
769      * from the caller's allowance.
770      *
771      * See `_burn` and `_approve`.
772      */
773     function _burnFrom(address account, uint256 amount) internal {
774         _burn(account, amount);
775         _approve(account, msg.sender, _allowances[account][msg.sender].sub(amount));
776     }
777 }
778 
779 
780 
781 
782 
783 
784 
785 /**
786  * @dev Collection of functions related to the address type,
787  */
788 library Address {
789     /**
790      * @dev Returns true if `account` is a contract.
791      *
792      * This test is non-exhaustive, and there may be false-negatives: during the
793      * execution of a contract's constructor, its address will be reported as
794      * not containing a contract.
795      *
796      * > It is unsafe to assume that an address for which this function returns
797      * false is an externally-owned account (EOA) and not a contract.
798      */
799     function isContract(address account) internal view returns (bool) {
800         // This method relies in extcodesize, which returns 0 for contracts in
801         // construction, since the code is only stored at the end of the
802         // constructor execution.
803 
804         uint256 size;
805         // solhint-disable-next-line no-inline-assembly
806         assembly { size := extcodesize(account) }
807         return size > 0;
808     }
809 }
810 
811 
812 /**
813  * @title SafeERC20
814  * @dev Wrappers around ERC20 operations that throw on failure (when the token
815  * contract returns false). Tokens that return no value (and instead revert or
816  * throw on failure) are also supported, non-reverting calls are assumed to be
817  * successful.
818  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
819  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
820  */
821 library SafeERC20 {
822     using SafeMath for uint256;
823     using Address for address;
824 
825     function safeTransfer(IERC20 token, address to, uint256 value) internal {
826         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
827     }
828 
829     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
830         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
831     }
832 
833     function safeApprove(IERC20 token, address spender, uint256 value) internal {
834         // safeApprove should only be called when setting an initial allowance,
835         // or when resetting it to zero. To increase and decrease it, use
836         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
837         // solhint-disable-next-line max-line-length
838         require((value == 0) || (token.allowance(address(this), spender) == 0),
839             "SafeERC20: approve from non-zero to non-zero allowance"
840         );
841         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
842     }
843 
844     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
845         uint256 newAllowance = token.allowance(address(this), spender).add(value);
846         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
847     }
848 
849     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
850         uint256 newAllowance = token.allowance(address(this), spender).sub(value);
851         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
852     }
853 
854     /**
855      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
856      * on the return value: the return value is optional (but if data is returned, it must not be false).
857      * @param token The token targeted by the call.
858      * @param data The call data (encoded using abi.encode or one of its variants).
859      */
860     function callOptionalReturn(IERC20 token, bytes memory data) private {
861         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
862         // we're implementing it ourselves.
863 
864         // A Solidity high level call has three parts:
865         //  1. The target address is checked to verify it contains contract code
866         //  2. The call itself is made, and success asserted
867         //  3. The return value is decoded, which in turn checks the size of the returned data.
868         // solhint-disable-next-line max-line-length
869         require(address(token).isContract(), "SafeERC20: call to non-contract");
870 
871         // solhint-disable-next-line avoid-low-level-calls
872         (bool success, bytes memory returndata) = address(token).call(data);
873         require(success, "SafeERC20: low-level call failed");
874 
875         if (returndata.length > 0) { // Return data is optional
876             // solhint-disable-next-line max-line-length
877             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
878         }
879     }
880 }
881 
882 /*
883 Copyright 2018 Binod Nirvan
884 
885 Licensed under the Apache License, Version 2.0 (the "License");
886 you may not use this file except in compliance with the License.
887 You may obtain a copy of the License at
888 
889     http://www.apache.org/licenses/LICENSE-2.0
890 
891 Unless required by applicable law or agreed to in writing, software
892 distributed under the License is distributed on an "AS IS" BASIS,
893 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
894 See the License for the specific language governing permissions and
895 limitations under the License.
896  */
897 
898 
899 
900 
901 
902 ///@title Capped Transfer
903 ///@author Binod Nirvan
904 ///@notice The capped transfer contract outlines the rules on the maximum amount of ERC20 or Ether transfer for each transaction.
905 contract CappedTransfer is CustomPausable {
906   event CapChanged(uint256 maximumTransfer, uint256 maximumTransferWei, uint256 oldMaximumTransfer, uint256 oldMaximumTransferWei);
907 
908   //Zero means unlimited transfer
909   uint256 private _maximumTransfer = 0;
910   uint256 private _maximumTransferWei = 0;
911 
912   ///@notice Ensures that the requested ERC20 transfer amount is within the maximum allowed limit.
913   ///@param amount The amount being requested to be transferred out of this contract.
914   ///@return Returns true if the transfer request is valid and acceptable.
915   function checkIfValidTransfer(uint256 amount) public view returns(bool) {
916     require(amount > 0, "Access is denied.");
917 
918     if(_maximumTransfer > 0) {
919       require(amount <= _maximumTransfer, "Sorry but the amount you're transferring is too much.");
920     }
921 
922     return true;
923   }
924 
925   ///@notice Ensures that the requested wei transfer amount is within the maximum allowed limit.
926   ///@param amount The Ether wei unit amount being requested to be transferred out of this contract.
927   ///@return Returns true if the transfer request is valid and acceptable.
928   function checkIfValidWeiTransfer(uint256 amount) public view returns(bool) {
929     require(amount > 0, "Access is denied.");
930 
931     if(_maximumTransferWei > 0) {
932       require(amount <= _maximumTransferWei, "Sorry but the amount you're transferring is too much.");
933     }
934 
935     return true;
936   }
937 
938   ///@notice Sets the maximum cap for a single ERC20 and Ether transfer.
939   ///@return Returns true if the operation was successful.
940   function setCap(uint256 cap, uint256 weiCap) external onlyOwner whenNotPaused returns(bool) {
941     emit CapChanged(cap, weiCap, _maximumTransfer, _maximumTransferWei);
942 
943     _maximumTransfer = cap;
944     _maximumTransferWei = weiCap;
945     return true;
946   }
947 
948   ///@notice Gets the transfer cap defined in this contract.
949   ///@return Returns maximum allowed value for a single transfer operation of ERC20 token and Ethereum.
950   function getCap() external view returns(uint256, uint256) {
951     return (_maximumTransfer, _maximumTransferWei);
952   }
953 }
954 
955 ///@title Transfer Base Contract
956 ///@author Binod Nirvan
957 ///@notice The base contract which contains features related to token transfers.
958 contract TransferBase is CappedTransfer {
959   using SafeMath for uint256;
960   using SafeERC20 for ERC20;
961 
962   event TransferPerformed(address indexed token, address indexed transferredBy, address indexed destination, uint256 amount);
963   event EtherTransferPerformed(address indexed transferredBy, address indexed destination, uint256 amount);
964 
965   ///@notice Allows the sender to transfer tokens to the beneficiary.
966   ///@param token The ERC20 token to transfer.
967   ///@param destination The destination wallet address to send funds to.
968   ///@param amount The amount of tokens to send to the specified address.
969   ///@return Returns true if the operation was successful.
970   function transferTokens(address token, address destination, uint256 amount)
971   external onlyAdmin whenNotPaused
972   returns(bool) {
973     require(checkIfValidTransfer(amount), "Access is denied.");
974 
975     ERC20 erc20 = ERC20(token);
976 
977     require
978     (
979       erc20.balanceOf(address(this)) >= amount,
980       "You don't have sufficient funds to transfer amount that large."
981     );
982 
983 
984     erc20.safeTransfer(destination, amount);
985 
986 
987     emit TransferPerformed(token, msg.sender, destination, amount);
988     return true;
989   }
990 
991   ///@notice Allows the sender to transfer Ethers to the beneficiary.
992   ///@param destination The destination wallet address to send funds to.
993   ///@param amount The amount of Ether in wei to send to the specified address.
994   ///@return Returns true if the operation was successful.
995   function transferEthers(address payable destination, uint256 amount)
996   external onlyAdmin whenNotPaused
997   returns(bool) {
998     require(checkIfValidWeiTransfer(amount), "Access is denied.");
999 
1000     require
1001     (
1002       address(this).balance >= amount,
1003       "You don't have sufficient funds to transfer amount that large."
1004     );
1005 
1006 
1007     destination.transfer(amount);
1008 
1009 
1010     emit EtherTransferPerformed(msg.sender, destination, amount);
1011     return true;
1012   }
1013 
1014   ///@return Returns balance of the ERC20 token held by this contract.
1015   function tokenBalanceOf(address token) external view returns(uint256) {
1016     ERC20 erc20 = ERC20(token);
1017     return erc20.balanceOf(address(this));
1018   }
1019 
1020   ///@notice Accepts incoming funds
1021   function () external payable whenNotPaused {
1022     //nothing to do
1023   }
1024 }
1025 
1026 ///@title Bulk Transfer Contract
1027 ///@author Binod Nirvan
1028 ///@notice The bulk transfer contract enables administrators to transfer an ERC20 token
1029 /// or Ethereum in batches. Every single feature of this contract is strictly restricted to be used by admin(s) only.
1030 contract BulkTransfer is TransferBase {
1031   event BulkTransferPerformed(address indexed token, address indexed transferredBy, uint256 length, uint256 totalAmount);
1032   event EtherBulkTransferPerformed(address indexed transferredBy, uint256 length, uint256 totalAmount);
1033 
1034   ///@notice Creates a sum total of the supplied values.
1035   ///@param values The collection of values to create the sum from.
1036   ///@return Returns the sum total of the supplied values.
1037   function sumOf(uint256[] memory values) private pure returns(uint256) {
1038     uint256 total = 0;
1039 
1040     for (uint256 i = 0; i < values.length; i++) {
1041       total = total.add(values[i]);
1042     }
1043 
1044     return total;
1045   }
1046 
1047 
1048   ///@notice Allows the requester to perform ERC20 bulk transfer operation.
1049   ///@param token The ERC20 token to bulk transfer.
1050   ///@param destinations The destination wallet addresses to send funds to.
1051   ///@param amounts The respective amount of funds to send to the specified addresses.
1052   ///@return Returns true if the operation was successful.
1053   function bulkTransfer(address token, address[] calldata destinations, uint256[] calldata amounts)
1054   external onlyAdmin whenNotPaused
1055   returns(bool) {
1056     require(destinations.length == amounts.length, "Invalid operation.");
1057 
1058     //Saving gas by first determining if the sender actually has sufficient balance
1059     //to post this transaction.
1060     uint256 requiredBalance = sumOf(amounts);
1061 
1062     //Verifying whether or not this transaction exceeds the maximum allowed ERC20 transfer cap.
1063     require(checkIfValidTransfer(requiredBalance), "Access is denied.");
1064 
1065     ERC20 erc20 = ERC20(token);
1066 
1067     require
1068     (
1069       erc20.balanceOf(address(this)) >= requiredBalance,
1070       "You don't have sufficient funds to transfer amount this big."
1071     );
1072 
1073 
1074     for (uint256 i = 0; i < destinations.length; i++) {
1075       erc20.safeTransfer(destinations[i], amounts[i]);
1076     }
1077 
1078     emit BulkTransferPerformed(token, msg.sender, destinations.length, requiredBalance);
1079     return true;
1080   }
1081 
1082 
1083   ///@notice Allows the requester to perform Ethereum bulk transfer operation.
1084   ///@param destinations The destination wallet addresses to send funds to.
1085   ///@param amounts The respective amount of funds to send to the specified addresses.
1086   ///@return Returns true if the operation was successful.
1087   function bulkTransferEther(address[] calldata destinations, uint256[] calldata amounts)
1088   external onlyAdmin whenNotPaused
1089   returns(bool) {
1090     require(destinations.length == amounts.length, "Invalid operation.");
1091 
1092     //Saving gas by first determining if the sender actually has sufficient balance
1093     //to post this transaction.
1094     uint256 requiredBalance = sumOf(amounts);
1095 
1096     //Verifying whether or not this transaction exceeds the maximum allowed Ethereum transfer cap.
1097     require(checkIfValidWeiTransfer(requiredBalance), "Access is denied.");
1098 
1099     require
1100     (
1101       address(this).balance >= requiredBalance,
1102       "You don't have sufficient funds to transfer amount this big."
1103     );
1104 
1105 
1106     for (uint256 i = 0; i < destinations.length; i++) {
1107       address payable beneficiary = address(uint160(destinations[i]));
1108       beneficiary.transfer(amounts[i]);
1109     }
1110 
1111 
1112     emit EtherBulkTransferPerformed(msg.sender, destinations.length, requiredBalance);
1113     return true;
1114   }
1115 }
1116 /*
1117 Copyright 2018 Binod Nirvan
1118 Licensed under the Apache License, Version 2.0 (the "License");
1119 you may not use this file except in compliance with the License.
1120 You may obtain a copy of the License at
1121     http://www.apache.org/licenses/LICENSE-2.0
1122 Unless required by applicable law or agreed to in writing, software
1123 distributed under the License is distributed on an "AS IS" BASIS,
1124 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1125 See the License for the specific language governing permissions and
1126 limitations under the License.
1127 */
1128 
1129 
1130 
1131 
1132 
1133 
1134 
1135 
1136 ///@title Reclaimable Contract
1137 ///@author Binod Nirvan
1138 ///@notice Reclaimable contract enables the owner
1139 ///to reclaim accidentally sent Ethers and ERC20 token(s)
1140 ///to this contract.
1141 contract Reclaimable is CustomPausable {
1142   using SafeERC20 for ERC20;
1143 
1144   ///@notice Transfers all Ether held by the contract to the caller.
1145   function reclaimEther() external whenNotPaused onlyOwner {
1146     msg.sender.transfer(address(this).balance);
1147   }
1148 
1149   ///@notice Transfers all ERC20 tokens held by the contract to the caller.
1150   ///@param token The amount of token to reclaim.
1151   function reclaimToken(address token) external whenNotPaused onlyOwner {
1152     ERC20 erc20 = ERC20(token);
1153     uint256 balance = erc20.balanceOf(address(this));
1154     erc20.safeTransfer(msg.sender, balance);
1155   }
1156 }
1157 
1158 contract CYBRSharedWallet is BulkTransfer, Reclaimable {
1159 }