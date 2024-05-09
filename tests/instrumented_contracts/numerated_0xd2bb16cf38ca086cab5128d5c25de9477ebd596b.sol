1 /*
2 Copyright 2018 Binod Nirvan @ xCrypt (https://www.xcrypt.club)
3 Licensed under the Apache License, Version 2.0 (the "License");
4 you may not use this file except in compliance with the License.
5 You may obtain a copy of the License at
6     http://www.apache.org/licenses/LICENSE-2.0
7 Unless required by applicable law or agreed to in writing, software
8 distributed under the License is distributed on an "AS IS" BASIS,
9 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
10 See the License for the specific language governing permissions and
11 limitations under the License.
12 */
13 
14 pragma solidity ^0.4.24;
15 
16 /*
17 Copyright 2018 Binod Nirvan @ xCrypt (https://www.xcrypt.club)
18 Licensed under the Apache License, Version 2.0 (the "License");
19 you may not use this file except in compliance with the License.
20 You may obtain a copy of the License at
21     http://www.apache.org/licenses/LICENSE-2.0
22 Unless required by applicable law or agreed to in writing, software
23 distributed under the License is distributed on an "AS IS" BASIS,
24 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
25 See the License for the specific language governing permissions and
26 limitations under the License.
27 */
28 
29 
30 
31 
32 
33 
34 
35 
36 
37 
38 /**
39  * @title ERC20Basic
40  * @dev Simpler version of ERC20 interface
41  * See https://github.com/ethereum/EIPs/issues/179
42  */
43 contract ERC20Basic {
44   function totalSupply() public view returns (uint256);
45   function balanceOf(address _who) public view returns (uint256);
46   function transfer(address _to, uint256 _value) public returns (bool);
47   event Transfer(address indexed from, address indexed to, uint256 value);
48 }
49 
50 
51 
52 
53 /**
54  * @title SafeMath
55  * @dev Math operations with safety checks that throw on error
56  */
57 library SafeMath {
58 
59   /**
60   * @dev Multiplies two numbers, throws on overflow.
61   */
62   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
63     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
64     // benefit is lost if 'b' is also tested.
65     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
66     if (_a == 0) {
67       return 0;
68     }
69 
70     c = _a * _b;
71     assert(c / _a == _b);
72     return c;
73   }
74 
75   /**
76   * @dev Integer division of two numbers, truncating the quotient.
77   */
78   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
79     // assert(_b > 0); // Solidity automatically throws when dividing by 0
80     // uint256 c = _a / _b;
81     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
82     return _a / _b;
83   }
84 
85   /**
86   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
87   */
88   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
89     assert(_b <= _a);
90     return _a - _b;
91   }
92 
93   /**
94   * @dev Adds two numbers, throws on overflow.
95   */
96   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
97     c = _a + _b;
98     assert(c >= _a);
99     return c;
100   }
101 }
102 
103 
104 
105 /**
106  * @title Basic token
107  * @dev Basic version of StandardToken, with no allowances.
108  */
109 contract BasicToken is ERC20Basic {
110   using SafeMath for uint256;
111 
112   mapping(address => uint256) internal balances;
113 
114   uint256 internal totalSupply_;
115 
116   /**
117   * @dev Total number of tokens in existence
118   */
119   function totalSupply() public view returns (uint256) {
120     return totalSupply_;
121   }
122 
123   /**
124   * @dev Transfer token for a specified address
125   * @param _to The address to transfer to.
126   * @param _value The amount to be transferred.
127   */
128   function transfer(address _to, uint256 _value) public returns (bool) {
129     require(_value <= balances[msg.sender]);
130     require(_to != address(0));
131 
132     balances[msg.sender] = balances[msg.sender].sub(_value);
133     balances[_to] = balances[_to].add(_value);
134     emit Transfer(msg.sender, _to, _value);
135     return true;
136   }
137 
138   /**
139   * @dev Gets the balance of the specified address.
140   * @param _owner The address to query the the balance of.
141   * @return An uint256 representing the amount owned by the passed address.
142   */
143   function balanceOf(address _owner) public view returns (uint256) {
144     return balances[_owner];
145   }
146 
147 }
148 
149 
150 
151 
152 
153 
154 /**
155  * @title ERC20 interface
156  * @dev see https://github.com/ethereum/EIPs/issues/20
157  */
158 contract ERC20 is ERC20Basic {
159   function allowance(address _owner, address _spender)
160     public view returns (uint256);
161 
162   function transferFrom(address _from, address _to, uint256 _value)
163     public returns (bool);
164 
165   function approve(address _spender, uint256 _value) public returns (bool);
166   event Approval(
167     address indexed owner,
168     address indexed spender,
169     uint256 value
170   );
171 }
172 
173 
174 
175 /**
176  * @title Standard ERC20 token
177  *
178  * @dev Implementation of the basic standard token.
179  * https://github.com/ethereum/EIPs/issues/20
180  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
181  */
182 contract StandardToken is ERC20, BasicToken {
183 
184   mapping (address => mapping (address => uint256)) internal allowed;
185 
186 
187   /**
188    * @dev Transfer tokens from one address to another
189    * @param _from address The address which you want to send tokens from
190    * @param _to address The address which you want to transfer to
191    * @param _value uint256 the amount of tokens to be transferred
192    */
193   function transferFrom(
194     address _from,
195     address _to,
196     uint256 _value
197   )
198     public
199     returns (bool)
200   {
201     require(_value <= balances[_from]);
202     require(_value <= allowed[_from][msg.sender]);
203     require(_to != address(0));
204 
205     balances[_from] = balances[_from].sub(_value);
206     balances[_to] = balances[_to].add(_value);
207     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
208     emit Transfer(_from, _to, _value);
209     return true;
210   }
211 
212   /**
213    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
214    * Beware that changing an allowance with this method brings the risk that someone may use both the old
215    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
216    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
217    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
218    * @param _spender The address which will spend the funds.
219    * @param _value The amount of tokens to be spent.
220    */
221   function approve(address _spender, uint256 _value) public returns (bool) {
222     allowed[msg.sender][_spender] = _value;
223     emit Approval(msg.sender, _spender, _value);
224     return true;
225   }
226 
227   /**
228    * @dev Function to check the amount of tokens that an owner allowed to a spender.
229    * @param _owner address The address which owns the funds.
230    * @param _spender address The address which will spend the funds.
231    * @return A uint256 specifying the amount of tokens still available for the spender.
232    */
233   function allowance(
234     address _owner,
235     address _spender
236    )
237     public
238     view
239     returns (uint256)
240   {
241     return allowed[_owner][_spender];
242   }
243 
244   /**
245    * @dev Increase the amount of tokens that an owner allowed to a spender.
246    * approve should be called when allowed[_spender] == 0. To increment
247    * allowed value is better to use this function to avoid 2 calls (and wait until
248    * the first transaction is mined)
249    * From MonolithDAO Token.sol
250    * @param _spender The address which will spend the funds.
251    * @param _addedValue The amount of tokens to increase the allowance by.
252    */
253   function increaseApproval(
254     address _spender,
255     uint256 _addedValue
256   )
257     public
258     returns (bool)
259   {
260     allowed[msg.sender][_spender] = (
261       allowed[msg.sender][_spender].add(_addedValue));
262     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
263     return true;
264   }
265 
266   /**
267    * @dev Decrease the amount of tokens that an owner allowed to a spender.
268    * approve should be called when allowed[_spender] == 0. To decrement
269    * allowed value is better to use this function to avoid 2 calls (and wait until
270    * the first transaction is mined)
271    * From MonolithDAO Token.sol
272    * @param _spender The address which will spend the funds.
273    * @param _subtractedValue The amount of tokens to decrease the allowance by.
274    */
275   function decreaseApproval(
276     address _spender,
277     uint256 _subtractedValue
278   )
279     public
280     returns (bool)
281   {
282     uint256 oldValue = allowed[msg.sender][_spender];
283     if (_subtractedValue >= oldValue) {
284       allowed[msg.sender][_spender] = 0;
285     } else {
286       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
287     }
288     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
289     return true;
290   }
291 
292 }
293 
294 
295 
296 
297 
298 
299 /**
300  * @title Burnable Token
301  * @dev Token that can be irreversibly burned (destroyed).
302  */
303 contract BurnableToken is BasicToken {
304 
305   event Burn(address indexed burner, uint256 value);
306 
307   /**
308    * @dev Burns a specific amount of tokens.
309    * @param _value The amount of token to be burned.
310    */
311   function burn(uint256 _value) public {
312     _burn(msg.sender, _value);
313   }
314 
315   function _burn(address _who, uint256 _value) internal {
316     require(_value <= balances[_who]);
317     // no need to require value <= totalSupply, since that would imply the
318     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
319 
320     balances[_who] = balances[_who].sub(_value);
321     totalSupply_ = totalSupply_.sub(_value);
322     emit Burn(_who, _value);
323     emit Transfer(_who, address(0), _value);
324   }
325 }
326 
327 /*
328 Copyright 2018 Binod Nirvan
329 
330 Licensed under the Apache License, Version 2.0 (the "License");
331 you may not use this file except in compliance with the License.
332 You may obtain a copy of the License at
333 
334     http://www.apache.org/licenses/LICENSE-2.0
335 
336 Unless required by applicable law or agreed to in writing, software
337 distributed under the License is distributed on an "AS IS" BASIS,
338 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
339 See the License for the specific language governing permissions and
340 limitations under the License.
341  */
342 
343 
344 
345 /*
346 Copyright 2018 Binod Nirvan
347 
348 Licensed under the Apache License, Version 2.0 (the "License");
349 you may not use this file except in compliance with the License.
350 You may obtain a copy of the License at
351 
352     http://www.apache.org/licenses/LICENSE-2.0
353 
354 Unless required by applicable law or agreed to in writing, software
355 distributed under the License is distributed on an "AS IS" BASIS,
356 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
357 See the License for the specific language governing permissions and
358 limitations under the License.
359  */
360 
361 
362 
363 
364 
365 
366 /**
367  * @title Ownable
368  * @dev The Ownable contract has an owner address, and provides basic authorization control
369  * functions, this simplifies the implementation of "user permissions".
370  */
371 contract Ownable {
372   address public owner;
373 
374 
375   event OwnershipRenounced(address indexed previousOwner);
376   event OwnershipTransferred(
377     address indexed previousOwner,
378     address indexed newOwner
379   );
380 
381 
382   /**
383    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
384    * account.
385    */
386   constructor() public {
387     owner = msg.sender;
388   }
389 
390   /**
391    * @dev Throws if called by any account other than the owner.
392    */
393   modifier onlyOwner() {
394     require(msg.sender == owner);
395     _;
396   }
397 
398   /**
399    * @dev Allows the current owner to relinquish control of the contract.
400    * @notice Renouncing to ownership will leave the contract without an owner.
401    * It will not be possible to call the functions with the `onlyOwner`
402    * modifier anymore.
403    */
404   function renounceOwnership() public onlyOwner {
405     emit OwnershipRenounced(owner);
406     owner = address(0);
407   }
408 
409   /**
410    * @dev Allows the current owner to transfer control of the contract to a newOwner.
411    * @param _newOwner The address to transfer ownership to.
412    */
413   function transferOwnership(address _newOwner) public onlyOwner {
414     _transferOwnership(_newOwner);
415   }
416 
417   /**
418    * @dev Transfers control of the contract to a newOwner.
419    * @param _newOwner The address to transfer ownership to.
420    */
421   function _transferOwnership(address _newOwner) internal {
422     require(_newOwner != address(0));
423     emit OwnershipTransferred(owner, _newOwner);
424     owner = _newOwner;
425   }
426 }
427 
428 
429 
430 ///@title This contract enables to create multiple contract administrators.
431 contract CustomAdmin is Ownable {
432   ///List of administrators.
433   mapping(address => bool) public admins;
434 
435   event AdminAdded(address indexed _address);
436   event AdminRemoved(address indexed _address);
437 
438   ///@notice Validates if the sender is actually an administrator.
439   modifier onlyAdmin() {
440     require(isAdmin(msg.sender), "Access is denied.");
441     _;
442   }
443 
444   ///@notice Adds the specified address to the list of administrators.
445   ///@param _address The address to add to the administrator list.
446   function addAdmin(address _address) external onlyAdmin returns(bool) {
447     require(_address != address(0), "Invalid address.");
448     require(!admins[_address], "This address is already an administrator.");
449 
450     require(_address != owner, "The owner cannot be added or removed to or from the administrator list.");
451 
452     admins[_address] = true;
453 
454     emit AdminAdded(_address);
455     return true;
456   }
457 
458   ///@notice Adds multiple addresses to the administrator list.
459   ///@param _accounts The wallet addresses to add to the administrator list.
460   function addManyAdmins(address[] _accounts) external onlyAdmin returns(bool) {
461     for(uint8 i = 0; i < _accounts.length; i++) {
462       address account = _accounts[i];
463 
464       ///Zero address cannot be an admin.
465       ///The owner is already an admin and cannot be assigned.
466       ///The address cannot be an existing admin.
467       if(account != address(0) && !admins[account] && account != owner) {
468         admins[account] = true;
469 
470         emit AdminAdded(_accounts[i]);
471       }
472     }
473 
474     return true;
475   }
476 
477   ///@notice Removes the specified address from the list of administrators.
478   ///@param _address The address to remove from the administrator list.
479   function removeAdmin(address _address) external onlyAdmin returns(bool) {
480     require(_address != address(0), "Invalid address.");
481     require(admins[_address], "This address isn't an administrator.");
482 
483     //The owner cannot be removed as admin.
484     require(_address != owner, "The owner cannot be added or removed to or from the administrator list.");
485 
486     admins[_address] = false;
487     emit AdminRemoved(_address);
488     return true;
489   }
490 
491   ///@notice Removes multiple addresses to the administrator list.
492   ///@param _accounts The wallet addresses to add to the administrator list.
493   function removeManyAdmins(address[] _accounts) external onlyAdmin returns(bool) {
494     for(uint8 i = 0; i < _accounts.length; i++) {
495       address account = _accounts[i];
496 
497       ///Zero address can neither be added or removed from this list.
498       ///The owner is the super admin and cannot be removed.
499       ///The address must be an existing admin in order for it to be removed.
500       if(account != address(0) && admins[account] && account != owner) {
501         admins[account] = false;
502 
503         emit AdminRemoved(_accounts[i]);
504       }
505     }
506 
507     return true;
508   }
509 
510   ///@notice Checks if an address is an administrator.
511   function isAdmin(address _address) public view returns(bool) {
512     if(_address == owner) {
513       return true;
514     }
515 
516     return admins[_address];
517   }
518 }
519 
520 
521 
522 ///@title This contract enables you to create pausable mechanism to stop in case of emergency.
523 contract CustomPausable is CustomAdmin {
524   event Paused();
525   event Unpaused();
526 
527   bool public paused = false;
528 
529   ///@notice Verifies whether the contract is not paused.
530   modifier whenNotPaused() {
531     require(!paused, "Sorry but the contract isn't paused.");
532     _;
533   }
534 
535   ///@notice Verifies whether the contract is paused.
536   modifier whenPaused() {
537     require(paused, "Sorry but the contract is paused.");
538     _;
539   }
540 
541   ///@notice Pauses the contract.
542   function pause() external onlyAdmin whenNotPaused {
543     paused = true;
544     emit Paused();
545   }
546 
547   ///@notice Unpauses the contract and returns to normal state.
548   function unpause() external onlyAdmin whenPaused {
549     paused = false;
550     emit Unpaused();
551   }
552 }
553 /*
554 Copyright 2018 Binod Nirvan
555 Licensed under the Apache License, Version 2.0 (the "License");
556 you may not use this file except in compliance with the License.
557 You may obtain a copy of the License at
558     http://www.apache.org/licenses/LICENSE-2.0
559 Unless required by applicable law or agreed to in writing, software
560 distributed under the License is distributed on an "AS IS" BASIS,
561 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
562 See the License for the specific language governing permissions and
563 limitations under the License.
564 */
565 
566 
567 
568 
569 
570 
571 ///@title Transfer State Contract
572 ///@author Binod Nirvan
573 ///@notice Enables the admins to maintain the transfer state.
574 ///Transfer state when disabled disallows everyone but admins to transfer tokens.
575 contract TransferState is CustomPausable {
576   bool public released = false;
577 
578   event TokenReleased(bool _state);
579 
580   ///@notice Checks if the supplied address is able to perform transfers.
581   ///@param _from The address to check against if the transfer is allowed.
582   modifier canTransfer(address _from) {
583     if(paused || !released) {
584       if(!isAdmin(_from)) {
585         revert("Operation not allowed. The transfer state is restricted.");
586       }
587     }
588 
589     _;
590   }
591 
592   ///@notice This function enables token transfers for everyone.
593   function enableTransfers() external onlyAdmin whenNotPaused returns(bool) {
594     require(!released, "Invalid operation. The transfer state is no more restricted.");
595 
596     released = true;
597 
598     emit TokenReleased(released);
599     return true;
600   }
601 
602   ///@notice This function disables token transfers for everyone.
603   function disableTransfers() external onlyAdmin whenNotPaused returns(bool) {
604     require(released, "Invalid operation. The transfer state is already restricted.");
605 
606     released = false;
607 
608     emit TokenReleased(released);
609     return true;
610   }
611 }
612 /*
613 Copyright 2018 Binod Nirvan
614 Licensed under the Apache License, Version 2.0 (the "License");
615 you may not use this file except in compliance with the License.
616 You may obtain a copy of the License at
617     http://www.apache.org/licenses/LICENSE-2.0
618 Unless required by applicable law or agreed to in writing, software
619 distributed under the License is distributed on an "AS IS" BASIS,
620 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
621 See the License for the specific language governing permissions and
622 limitations under the License.
623 */
624 
625 
626 
627 
628 
629 
630 
631 ///@title Bulk Transfer Contract
632 ///@author Binod Nirvan
633 ///@notice This contract provides features for admins to perform bulk transfers.
634 contract BulkTransfer is StandardToken, CustomAdmin {
635   event BulkTransferPerformed(address[] _destinations, uint256[] _amounts);
636 
637   ///@notice Allows only the admins and/or whitelisted applications to perform bulk transfer operation.
638   ///@param _destinations The destination wallet addresses to send funds to.
639   ///@param _amounts The respective amount of fund to send to the specified addresses.
640   function bulkTransfer(address[] _destinations, uint256[] _amounts) public onlyAdmin returns(bool) {
641     require(_destinations.length == _amounts.length, "Invalid operation.");
642 
643     //Saving gas by determining if the sender has enough balance
644     //to post this transaction.
645     uint256 requiredBalance = sumOf(_amounts);
646     require(balances[msg.sender] >= requiredBalance, "You don't have sufficient funds to transfer amount that large.");
647     
648     for (uint256 i = 0; i < _destinations.length; i++) {
649       transfer(_destinations[i], _amounts[i]);
650     }
651 
652     emit BulkTransferPerformed(_destinations, _amounts);
653     return true;
654   }
655   
656   ///@notice Returns the sum of supplied values.
657   ///@param _values The collection of values to create the sum from.
658   function sumOf(uint256[] _values) private pure returns(uint256) {
659     uint256 total = 0;
660 
661     for (uint256 i = 0; i < _values.length; i++) {
662       total = total.add(_values[i]);
663     }
664 
665     return total;
666   }
667 }
668 /*
669 Copyright 2018 Binod Nirvan
670 Licensed under the Apache License, Version 2.0 (the "License");
671 you may not use this file except in compliance with the License.
672 You may obtain a copy of the License at
673     http://www.apache.org/licenses/LICENSE-2.0
674 Unless required by applicable law or agreed to in writing, software
675 distributed under the License is distributed on an "AS IS" BASIS,
676 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
677 See the License for the specific language governing permissions and
678 limitations under the License.
679 */
680 
681 
682 
683 
684 
685 
686 
687 
688 
689 
690 /**
691  * @title SafeERC20
692  * @dev Wrappers around ERC20 operations that throw on failure.
693  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
694  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
695  */
696 library SafeERC20 {
697   function safeTransfer(
698     ERC20Basic _token,
699     address _to,
700     uint256 _value
701   )
702     internal
703   {
704     require(_token.transfer(_to, _value));
705   }
706 
707   function safeTransferFrom(
708     ERC20 _token,
709     address _from,
710     address _to,
711     uint256 _value
712   )
713     internal
714   {
715     require(_token.transferFrom(_from, _to, _value));
716   }
717 
718   function safeApprove(
719     ERC20 _token,
720     address _spender,
721     uint256 _value
722   )
723     internal
724   {
725     require(_token.approve(_spender, _value));
726   }
727 }
728 
729 
730 
731 
732 ///@title Reclaimable Contract
733 ///@author Binod Nirvan
734 ///@notice Reclaimable contract enables the administrators
735 ///to reclaim accidentally sent Ethers and ERC20 token(s)
736 ///to this contract.
737 contract Reclaimable is CustomAdmin {
738   using SafeERC20 for ERC20;
739 
740   ///@notice Transfers all Ether held by the contract to the owner.
741   function reclaimEther() external onlyAdmin {
742     msg.sender.transfer(address(this).balance);
743   }
744 
745   ///@notice Transfers all ERC20 tokens held by the contract to the owner.
746   ///@param _token The amount of token to reclaim.
747   function reclaimToken(address _token) external onlyAdmin {
748     ERC20 erc20 = ERC20(_token);
749     uint256 balance = erc20.balanceOf(this);
750     erc20.safeTransfer(msg.sender, balance);
751   }
752 }
753 /*
754 Copyright 2018 Binod Nirvan
755 
756 Licensed under the Apache License, Version 2.0 (the "License");
757 you may not use this file except in compliance with the License.
758 You may obtain a copy of the License at
759 
760     http:///www.apache.org/licenses/LICENSE-2.0
761 
762 Unless required by applicable law or agreed to in writing, software
763 distributed under the License is distributed on an "AS IS" BASIS,
764 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
765 See the License for the specific language governing permissions and
766 limitations under the License.
767  */
768 
769 
770 
771 
772 
773 
774 ///@title Custom Lockable Contract
775 ///@author Binod Nirvan
776 ///@notice This contract enables xCrypt token admins
777 ///to lock tokens on an individual-wallet basis.
778 ///When tokens are locked for specific wallet,
779 ///they cannot transfer their balances
780 ///until the end of their locking period.
781 ///Furthermore, this feature is created to specifically
782 ///lock bounty, advisory, and team tokens
783 ///for a set period of time.
784 ///This feature once turned off cannot be switched on back again.
785 contract CustomLockable is CustomAdmin {
786   ///Locking list contains list of wallets and their respective release dates.
787   mapping(address => uint256) public lockingList;
788 
789   ///Signifies if the locking feature can be used.
790   ///This feature should be turned off as soon as lockings are created.
791   bool public canLock = true;
792 
793   event TokenLocked(address indexed _address, uint256 _releaseDate);
794   event TokenUnlocked(address indexed _address);
795   event LockingDisabled();
796 
797   ///@notice Reverts this transfer if the wallet is in the locking list.
798   modifier revertIfLocked(address _wallet) {
799     require(!isLocked(_wallet), "The operation was cancelled because your tokens are locked.");
800     _;
801   }
802 
803   ///@notice Checks if a wallet is locked for transfers.
804   function isLocked(address _wallet) public view returns(bool) {
805     uint256 _lockedUntil = lockingList[_wallet];
806 
807     if(_lockedUntil > 0 && _lockedUntil > now) {
808       return true;
809     }
810 
811     return false;
812   }
813 
814   ///@notice Adds the specified address to the locking list.
815   ///@param _address The address to add to the locking list.
816   ///@param _releaseDate The date when the tokens become avaiable for transfer.
817   function addLock(address _address, uint256 _releaseDate) external onlyAdmin returns(bool) {
818     require(canLock, "Access is denied. This feature was already disabled by an administrator.");
819     require(_address != address(0), "Invalid address.");
820     require(!admins[_address], "Cannot lock administrators.");
821     require(_address != owner, "Cannot lock the owner.");
822 
823     lockingList[_address] = _releaseDate;
824 
825     if(_releaseDate > 0) {
826       emit TokenLocked(_address, _releaseDate);
827     } else {
828       emit TokenUnlocked(_address);
829     }
830 
831     return true;
832   }
833 
834   ///@notice Adds multiple addresses to the locking list.
835   ///@param _accounts The wallet addresses to add to the locking list.
836   ///@param _releaseDate The date when the tokens become avaiable for transfer.
837   function addManyLocks(address[] _accounts, uint256 _releaseDate) external onlyAdmin returns(bool) {
838     require(canLock, "Access is denied. This feature was already disabled by an administrator.");
839     require(_releaseDate > 0, "Invalid release date.");
840 
841     for(uint8 i = 0; i < _accounts.length; i++) {
842       address account = _accounts[i];
843 
844       ///Zero address, admins, and owner cannot be locked.
845       if(account != address(0) && !admins[account] && account != owner) {
846         lockingList[account] = _releaseDate;
847         emit TokenLocked(account, _releaseDate);
848       }
849     }
850 
851     return true;
852   }
853 
854   ///@notice Since locking feature is intended to be used
855   ///only for a short span of time, calling this function
856   ///will disable the feature completely.
857   ///Once locking feature is disable, it cannot be
858   ///truned back on thenceforth.
859   function disableLocking() external onlyAdmin returns(bool) {
860     require(canLock, "The token lock feature is already disabled.");
861 
862     canLock = false;
863     emit LockingDisabled();
864     return true;
865   }
866 }
867 
868 
869 ///@title xCrypt Token Base Contract
870 ///@author Binod Nirvan
871 ///@notice XCRYPT is the first crypto ecosystem with a high added value
872 ///with the heart in its exchange: Hybrid, ready for STO
873 ///and for a marketplace made for the ERC721. We created this
874 ///end to end system which includes a Debit Card
875 ///and a Social Media Trading system which is
876 ///an advanced investment solution, which enables trading
877 ///on one account managed by a skillfull and experienced trader
878 ///using his own funds and joint funds invested by other traders
879 ///in his SMT account. This ecosystem is made to be at the same level
880 ///as the world’s big players, and even surpass them, for we are already
881 ///suitable in this field’s future.
882 contract TokenBase is StandardToken, TransferState, BulkTransfer, Reclaimable, BurnableToken, CustomLockable {
883   //solhint-disable
884   uint8 public constant decimals = 18;
885   string public constant name = "xCrypt Token";
886   string public constant symbol = "XCT";
887   //solhint-enable
888 
889   uint256 internal constant MILLION = 1000000 * 1 ether;
890   uint256 public constant MAX_SUPPLY = 200 * MILLION;
891   uint256 public constant INITIAL_SUPPLY = 130 * MILLION;
892 
893   event Mint(address indexed to, uint256 amount);
894 
895   constructor() public {
896     mintTokens(msg.sender, INITIAL_SUPPLY);
897   }
898 
899   ///@notice Transfers the specified value of XCT tokens to the destination address.
900   //Transfers can only happen when the transfer state is enabled.
901   //Transfer state can only be enabled after the end of the crowdsale.
902   ///@dev This function is overridden to leverage transfer state and lockable feature.
903   ///@param _to The destination wallet address to transfer funds to.
904   ///@param _value The amount of tokens to send to the destination address.
905   function transfer(address _to, uint256 _value)
906   public
907   canTransfer(msg.sender)
908   revertIfLocked(msg.sender)
909   returns(bool) {
910     require(_to != address(0), "Invalid address.");
911     return super.transfer(_to, _value);
912   }
913 
914   ///@notice Transfers tokens from a specified wallet address.
915   ///@dev This function is overridden to leverage transfer state and lockable feature.
916   ///@param _from The address to transfer funds from.
917   ///@param _to The address to transfer funds to.
918   ///@param _value The amount of tokens to transfer.
919   function transferFrom(address _from, address _to, uint256 _value)
920   public
921   canTransfer(_from)
922   revertIfLocked(_from)
923   returns(bool) {
924     require(_to != address(0), "Invalid address.");
925     return super.transferFrom(_from, _to, _value);
926   }
927 
928   ///@notice Approves a wallet address to spend on behalf of the sender.
929   ///@dev This function is overridden to leverage transfer state and lockable feature.
930   ///@param _spender The address which is approved to spend on behalf of the sender.
931   ///@param _value The amount of tokens approve to spend.
932   function approve(address _spender, uint256 _value)
933   public
934   canTransfer(msg.sender)
935   revertIfLocked(msg.sender)
936   returns(bool) {
937     require(_spender != address(0), "Invalid address.");
938     return super.approve(_spender, _value);
939   }
940 
941   ///@notice Increases the approval of the spender.
942   ///@dev This function is overridden to leverage transfer state and lockable feature.
943   ///@param _spender The address which is approved to spend on behalf of the sender.
944   ///@param _addedValue The added amount of tokens approved to spend.
945   function increaseApproval(address _spender, uint256 _addedValue)
946   public
947   canTransfer(msg.sender)
948   revertIfLocked(msg.sender)
949   returns(bool) {
950     require(_spender != address(0), "Invalid address.");
951     return super.increaseApproval(_spender, _addedValue);
952   }
953 
954   ///@notice Decreases the approval of the spender.
955   ///@dev This function is overridden to leverage transfer state and lockable feature.
956   ///@param _spender The address of the spender to decrease the allocation from.
957   ///@param _subtractedValue The amount of tokens to subtract from the approved allocation.
958   function decreaseApproval(address _spender, uint256 _subtractedValue)
959   public
960   canTransfer(msg.sender)
961   revertIfLocked(msg.sender)
962   returns(bool) {
963     require(_spender != address(0), "Invalid address.");
964     return super.decreaseApproval(_spender, _subtractedValue);
965   }
966 
967   ///@notice Burns the coins held by the sender.
968   ///@param _value The amount of coins to burn.
969   ///@dev This function is overridden to leverage Pausable feature.
970   function burn(uint256 _value) public whenNotPaused {
971     super.burn(_value);
972   }
973 
974   ///@notice Mints the supplied value of the tokens to the destination address.
975   //Minting cannot be performed any further once the maximum supply is reached.
976   //This function cannot be used by anyone except for this contract.
977   ///@param _to The address which will receive the minted tokens.
978   ///@param _value The amount of tokens to mint.
979   function mintTokens(address _to, uint _value) internal returns(bool) {
980     require(_to != address(0), "Invalid address.");
981     require(totalSupply_.add(_value) <= MAX_SUPPLY, "Sorry but the total supply can't exceed the maximum supply.");
982 
983     balances[_to] = balances[_to].add(_value);
984     totalSupply_ = totalSupply_.add(_value);
985 
986     emit Transfer(address(0), _to, _value);
987     emit Mint(_to, _value);
988 
989     return true;
990   }
991 }
992 
993 ///@title xCrypt Token
994 ///@author Binod Nirvan
995 ///@notice XCRYPT is the first crypto ecosystem with a high added value
996 ///with the heart in its exchange: Hybrid, ready for STO
997 ///and for a marketplace made for the ERC721. We created this
998 ///end to end system which includes a Debit Card
999 ///and a Social Media Trading system which is
1000 ///an advanced investment solution, which enables trading
1001 ///on one account managed by a skillfull and experienced trader
1002 ///using his own funds and joint funds invested by other traders
1003 ///in his SMT account. This ecosystem is made to be at the same level
1004 ///as the world’s big players, and even surpass them, for we are already
1005 ///suitable in this field’s future.
1006 contract xCryptToken is TokenBase {
1007   uint256 public constant ALLOCATION_FOR_PARTNERS_AND_ADVISORS = 16 * MILLION;
1008   uint256 public constant ALLOCATION_FOR_TEAM = 30 * MILLION;
1009   uint256 public constant ALLOCATION_FOR_BONUS_AND_RESERVES = 18 * MILLION;
1010   uint256 public constant ALLOCATION_FOR_BOUNTIES = 6 * MILLION;
1011 
1012   mapping(bytes32 => bool) private mintingList;
1013 
1014   ///@notice Checks if the minting for the supplied key was already performed.
1015   ///@param _key The key or category name of minting.
1016   modifier whenNotMinted(string _key) {
1017     if(mintingList[computeHash(_key)]) {
1018       revert("Duplicate minting key supplied.");
1019     }
1020 
1021     _;
1022   }
1023 
1024   ///@notice Mints the below-mentioned amount of tokens allocated to the partners and advisors.
1025   function mintPartnerAndAdvisorTokens() external onlyAdmin returns(bool) {
1026     return mintOnce("partnerAndAdvisor", msg.sender, ALLOCATION_FOR_PARTNERS_AND_ADVISORS);
1027   }
1028 
1029   ///@notice Mints the below-mentioned amount of tokens allocated to the xCrypt team.
1030   function mintTeamTokens() external onlyAdmin returns(bool) {
1031     return mintOnce("team", msg.sender, ALLOCATION_FOR_TEAM);
1032   }
1033 
1034   ///@notice Mints the below-mentioned amount of tokens allocated to bonus and reserves.
1035   function mintBonusAndReservesTokens() external onlyAdmin returns(bool) {
1036     return mintOnce("bonusAndReserves", msg.sender, ALLOCATION_FOR_BONUS_AND_RESERVES);
1037   }
1038 
1039   ///@notice Mints the below-mentioned amount of tokens allocated to bounties.
1040   function mintBountyTokens() external onlyAdmin returns(bool) {
1041     return mintOnce("bounty", msg.sender, ALLOCATION_FOR_BOUNTIES);
1042   }
1043 
1044   ///@notice Computes keccak256 hash of the supplied value.
1045   ///@param _key The string value to compute hash from.
1046   function computeHash(string _key) private pure returns(bytes32) {
1047     return keccak256(abi.encodePacked(_key));
1048   }
1049 
1050   ///@notice Mints the tokens only once against the supplied key (category).
1051   ///@param _key The key or the category of the allocation to mint the tokens for.
1052   ///@param _to The address receiving the minted tokens.
1053   ///@param _amount The amount of tokens to mint.
1054   function mintOnce(string _key, address _to, uint256 _amount) private whenNotPaused whenNotMinted(_key) returns(bool) {
1055     mintingList[computeHash(_key)] = true;
1056     return mintTokens(_to, _amount);
1057   }
1058 }