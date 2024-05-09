1 /*
2 Copyright 2018 Binod Nirvan @ CYBRToken (https://cybrtoken.io)
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
17 Copyright 2018 Binod Nirvan @ CYBRToken (https://cybrtoken.io)
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
38 
39 /**
40  * @title ERC20Basic
41  * @dev Simpler version of ERC20 interface
42  * See https://github.com/ethereum/EIPs/issues/179
43  */
44 contract ERC20Basic {
45   function totalSupply() public view returns (uint256);
46   function balanceOf(address _who) public view returns (uint256);
47   function transfer(address _to, uint256 _value) public returns (bool);
48   event Transfer(address indexed from, address indexed to, uint256 value);
49 }
50 
51 
52 
53 
54 /**
55  * @title SafeMath
56  * @dev Math operations with safety checks that throw on error
57  */
58 library SafeMath {
59 
60   /**
61   * @dev Multiplies two numbers, throws on overflow.
62   */
63   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
64     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
65     // benefit is lost if 'b' is also tested.
66     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
67     if (_a == 0) {
68       return 0;
69     }
70 
71     c = _a * _b;
72     assert(c / _a == _b);
73     return c;
74   }
75 
76   /**
77   * @dev Integer division of two numbers, truncating the quotient.
78   */
79   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
80     // assert(_b > 0); // Solidity automatically throws when dividing by 0
81     // uint256 c = _a / _b;
82     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
83     return _a / _b;
84   }
85 
86   /**
87   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
88   */
89   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
90     assert(_b <= _a);
91     return _a - _b;
92   }
93 
94   /**
95   * @dev Adds two numbers, throws on overflow.
96   */
97   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
98     c = _a + _b;
99     assert(c >= _a);
100     return c;
101   }
102 }
103 
104 
105 
106 /**
107  * @title Basic token
108  * @dev Basic version of StandardToken, with no allowances.
109  */
110 contract BasicToken is ERC20Basic {
111   using SafeMath for uint256;
112 
113   mapping(address => uint256) internal balances;
114 
115   uint256 internal totalSupply_;
116 
117   /**
118   * @dev Total number of tokens in existence
119   */
120   function totalSupply() public view returns (uint256) {
121     return totalSupply_;
122   }
123 
124   /**
125   * @dev Transfer token for a specified address
126   * @param _to The address to transfer to.
127   * @param _value The amount to be transferred.
128   */
129   function transfer(address _to, uint256 _value) public returns (bool) {
130     require(_value <= balances[msg.sender]);
131     require(_to != address(0));
132 
133     balances[msg.sender] = balances[msg.sender].sub(_value);
134     balances[_to] = balances[_to].add(_value);
135     emit Transfer(msg.sender, _to, _value);
136     return true;
137   }
138 
139   /**
140   * @dev Gets the balance of the specified address.
141   * @param _owner The address to query the the balance of.
142   * @return An uint256 representing the amount owned by the passed address.
143   */
144   function balanceOf(address _owner) public view returns (uint256) {
145     return balances[_owner];
146   }
147 
148 }
149 
150 
151 
152 
153 
154 
155 /**
156  * @title ERC20 interface
157  * @dev see https://github.com/ethereum/EIPs/issues/20
158  */
159 contract ERC20 is ERC20Basic {
160   function allowance(address _owner, address _spender)
161     public view returns (uint256);
162 
163   function transferFrom(address _from, address _to, uint256 _value)
164     public returns (bool);
165 
166   function approve(address _spender, uint256 _value) public returns (bool);
167   event Approval(
168     address indexed owner,
169     address indexed spender,
170     uint256 value
171   );
172 }
173 
174 
175 
176 /**
177  * @title Standard ERC20 token
178  *
179  * @dev Implementation of the basic standard token.
180  * https://github.com/ethereum/EIPs/issues/20
181  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
182  */
183 contract StandardToken is ERC20, BasicToken {
184 
185   mapping (address => mapping (address => uint256)) internal allowed;
186 
187 
188   /**
189    * @dev Transfer tokens from one address to another
190    * @param _from address The address which you want to send tokens from
191    * @param _to address The address which you want to transfer to
192    * @param _value uint256 the amount of tokens to be transferred
193    */
194   function transferFrom(
195     address _from,
196     address _to,
197     uint256 _value
198   )
199     public
200     returns (bool)
201   {
202     require(_value <= balances[_from]);
203     require(_value <= allowed[_from][msg.sender]);
204     require(_to != address(0));
205 
206     balances[_from] = balances[_from].sub(_value);
207     balances[_to] = balances[_to].add(_value);
208     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
209     emit Transfer(_from, _to, _value);
210     return true;
211   }
212 
213   /**
214    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
215    * Beware that changing an allowance with this method brings the risk that someone may use both the old
216    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
217    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
218    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
219    * @param _spender The address which will spend the funds.
220    * @param _value The amount of tokens to be spent.
221    */
222   function approve(address _spender, uint256 _value) public returns (bool) {
223     allowed[msg.sender][_spender] = _value;
224     emit Approval(msg.sender, _spender, _value);
225     return true;
226   }
227 
228   /**
229    * @dev Function to check the amount of tokens that an owner allowed to a spender.
230    * @param _owner address The address which owns the funds.
231    * @param _spender address The address which will spend the funds.
232    * @return A uint256 specifying the amount of tokens still available for the spender.
233    */
234   function allowance(
235     address _owner,
236     address _spender
237    )
238     public
239     view
240     returns (uint256)
241   {
242     return allowed[_owner][_spender];
243   }
244 
245   /**
246    * @dev Increase the amount of tokens that an owner allowed to a spender.
247    * approve should be called when allowed[_spender] == 0. To increment
248    * allowed value is better to use this function to avoid 2 calls (and wait until
249    * the first transaction is mined)
250    * From MonolithDAO Token.sol
251    * @param _spender The address which will spend the funds.
252    * @param _addedValue The amount of tokens to increase the allowance by.
253    */
254   function increaseApproval(
255     address _spender,
256     uint256 _addedValue
257   )
258     public
259     returns (bool)
260   {
261     allowed[msg.sender][_spender] = (
262       allowed[msg.sender][_spender].add(_addedValue));
263     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
264     return true;
265   }
266 
267   /**
268    * @dev Decrease the amount of tokens that an owner allowed to a spender.
269    * approve should be called when allowed[_spender] == 0. To decrement
270    * allowed value is better to use this function to avoid 2 calls (and wait until
271    * the first transaction is mined)
272    * From MonolithDAO Token.sol
273    * @param _spender The address which will spend the funds.
274    * @param _subtractedValue The amount of tokens to decrease the allowance by.
275    */
276   function decreaseApproval(
277     address _spender,
278     uint256 _subtractedValue
279   )
280     public
281     returns (bool)
282   {
283     uint256 oldValue = allowed[msg.sender][_spender];
284     if (_subtractedValue >= oldValue) {
285       allowed[msg.sender][_spender] = 0;
286     } else {
287       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
288     }
289     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
290     return true;
291   }
292 
293 }
294 
295 
296 
297 
298 
299 
300 /**
301  * @title Burnable Token
302  * @dev Token that can be irreversibly burned (destroyed).
303  */
304 contract BurnableToken is BasicToken {
305 
306   event Burn(address indexed burner, uint256 value);
307 
308   /**
309    * @dev Burns a specific amount of tokens.
310    * @param _value The amount of token to be burned.
311    */
312   function burn(uint256 _value) public {
313     _burn(msg.sender, _value);
314   }
315 
316   function _burn(address _who, uint256 _value) internal {
317     require(_value <= balances[_who]);
318     // no need to require value <= totalSupply, since that would imply the
319     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
320 
321     balances[_who] = balances[_who].sub(_value);
322     totalSupply_ = totalSupply_.sub(_value);
323     emit Burn(_who, _value);
324     emit Transfer(_who, address(0), _value);
325   }
326 }
327 
328 /*
329 Copyright 2018 Binod Nirvan
330 
331 Licensed under the Apache License, Version 2.0 (the "License");
332 you may not use this file except in compliance with the License.
333 You may obtain a copy of the License at
334 
335     http://www.apache.org/licenses/LICENSE-2.0
336 
337 Unless required by applicable law or agreed to in writing, software
338 distributed under the License is distributed on an "AS IS" BASIS,
339 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
340 See the License for the specific language governing permissions and
341 limitations under the License.
342  */
343 
344 
345 
346 /*
347 Copyright 2018 Binod Nirvan
348 
349 Licensed under the Apache License, Version 2.0 (the "License");
350 you may not use this file except in compliance with the License.
351 You may obtain a copy of the License at
352 
353     http://www.apache.org/licenses/LICENSE-2.0
354 
355 Unless required by applicable law or agreed to in writing, software
356 distributed under the License is distributed on an "AS IS" BASIS,
357 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
358 See the License for the specific language governing permissions and
359 limitations under the License.
360  */
361 
362 
363 
364 /*
365 Copyright 2018 Binod Nirvan
366 
367 Licensed under the Apache License, Version 2.0 (the "License");
368 you may not use this file except in compliance with the License.
369 You may obtain a copy of the License at
370 
371     http://www.apache.org/licenses/LICENSE-2.0
372 
373 Unless required by applicable law or agreed to in writing, software
374 distributed under the License is distributed on an "AS IS" BASIS,
375 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
376 See the License for the specific language governing permissions and
377 limitations under the License.
378  */
379 
380 
381 
382 
383 
384 /**
385  * @title Ownable
386  * @dev The Ownable contract has an owner address, and provides basic authorization control
387  * functions, this simplifies the implementation of "user permissions".
388  */
389 contract Ownable {
390   address public owner;
391 
392 
393   event OwnershipRenounced(address indexed previousOwner);
394   event OwnershipTransferred(
395     address indexed previousOwner,
396     address indexed newOwner
397   );
398 
399 
400   /**
401    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
402    * account.
403    */
404   constructor() public {
405     owner = msg.sender;
406   }
407 
408   /**
409    * @dev Throws if called by any account other than the owner.
410    */
411   modifier onlyOwner() {
412     require(msg.sender == owner);
413     _;
414   }
415 
416   /**
417    * @dev Allows the current owner to relinquish control of the contract.
418    * @notice Renouncing to ownership will leave the contract without an owner.
419    * It will not be possible to call the functions with the `onlyOwner`
420    * modifier anymore.
421    */
422   function renounceOwnership() public onlyOwner {
423     emit OwnershipRenounced(owner);
424     owner = address(0);
425   }
426 
427   /**
428    * @dev Allows the current owner to transfer control of the contract to a newOwner.
429    * @param _newOwner The address to transfer ownership to.
430    */
431   function transferOwnership(address _newOwner) public onlyOwner {
432     _transferOwnership(_newOwner);
433   }
434 
435   /**
436    * @dev Transfers control of the contract to a newOwner.
437    * @param _newOwner The address to transfer ownership to.
438    */
439   function _transferOwnership(address _newOwner) internal {
440     require(_newOwner != address(0));
441     emit OwnershipTransferred(owner, _newOwner);
442     owner = _newOwner;
443   }
444 }
445 
446 
447 ///@title Custom Ownable
448 ///@notice Custom ownable contract.
449 contract CustomOwnable is Ownable {
450   ///The trustee wallet.
451   address private _trustee;
452 
453   event TrusteeAssigned(address indexed account);
454 
455   ///@notice Validates if the sender is actually the trustee.
456   modifier onlyTrustee() {
457     require(msg.sender == _trustee, "Access is denied.");
458     _;
459   }
460 
461   ///@notice Assigns or changes the trustee wallet.
462   ///@param _account A wallet address which will become the new trustee.
463   ///@return Returns true if the operation was successful.
464   function assignTrustee(address _account) external onlyOwner returns(bool) {
465     require(_account != address(0), "Please provide a valid address for trustee.");
466 
467     _trustee = _account;
468     emit TrusteeAssigned(_account);
469     return true;
470   }
471 
472   ///@notice Changes the owner of this contract.
473   ///@param _newOwner Specify a wallet address which will become the new owner.
474   ///@return Returns true if the operation was successful.
475   function reassignOwner(address _newOwner) external onlyTrustee returns(bool) {
476     super._transferOwnership(_newOwner);
477     return true;
478   }
479 
480   ///@notice The trustee wallet has the power to change the owner in case of unforeseen or unavoidable situation.
481   ///@return Wallet address of the trustee account.
482   function getTrustee() external view returns(address) {
483     return _trustee;
484   }
485 }
486 
487 
488 ///@title This contract enables to create multiple contract administrators.
489 contract CustomAdmin is CustomOwnable {
490   ///@notice List of administrators.
491   mapping(address => bool) public admins;
492 
493   event AdminAdded(address indexed _address);
494   event AdminRemoved(address indexed _address);
495 
496   ///@notice Validates if the sender is actually an administrator.
497   modifier onlyAdmin() {
498     require(isAdmin(msg.sender), "Access is denied.");
499     _;
500   }
501 
502   ///@notice Adds the specified address to the list of administrators.
503   ///@param _address The address to add to the administrator list.
504   function addAdmin(address _address) external onlyAdmin returns(bool) {
505     require(_address != address(0), "Invalid address.");
506     require(!admins[_address], "This address is already an administrator.");
507 
508     require(_address != owner, "The owner cannot be added or removed to or from the administrator list.");
509 
510     admins[_address] = true;
511 
512     emit AdminAdded(_address);
513     return true;
514   }
515 
516   ///@notice Adds multiple addresses to the administrator list.
517   ///@param _accounts The wallet addresses to add to the administrator list.
518   function addManyAdmins(address[] _accounts) external onlyAdmin returns(bool) {
519     for(uint8 i = 0; i < _accounts.length; i++) {
520       address account = _accounts[i];
521 
522       ///Zero address cannot be an admin.
523       ///The owner is already an admin and cannot be assigned.
524       ///The address cannot be an existing admin.
525       if(account != address(0) && !admins[account] && account != owner) {
526         admins[account] = true;
527 
528         emit AdminAdded(_accounts[i]);
529       }
530     }
531 
532     return true;
533   }
534 
535   ///@notice Removes the specified address from the list of administrators.
536   ///@param _address The address to remove from the administrator list.
537   function removeAdmin(address _address) external onlyAdmin returns(bool) {
538     require(_address != address(0), "Invalid address.");
539     require(admins[_address], "This address isn't an administrator.");
540 
541     //The owner cannot be removed as admin.
542     require(_address != owner, "The owner cannot be added or removed to or from the administrator list.");
543 
544     admins[_address] = false;
545     emit AdminRemoved(_address);
546     return true;
547   }
548 
549   ///@notice Removes multiple addresses to the administrator list.
550   ///@param _accounts The wallet addresses to add to the administrator list.
551   function removeManyAdmins(address[] _accounts) external onlyAdmin returns(bool) {
552     for(uint8 i = 0; i < _accounts.length; i++) {
553       address account = _accounts[i];
554 
555       ///Zero address can neither be added or removed from this list.
556       ///The owner is the super admin and cannot be removed.
557       ///The address must be an existing admin in order for it to be removed.
558       if(account != address(0) && admins[account] && account != owner) {
559         admins[account] = false;
560 
561         emit AdminRemoved(_accounts[i]);
562       }
563     }
564 
565     return true;
566   }
567 
568   ///@notice Checks if an address is an administrator.
569   function isAdmin(address _address) public view returns(bool) {
570     if(_address == owner) {
571       return true;
572     }
573 
574     return admins[_address];
575   }
576 }
577 
578 
579 
580 ///@title This contract enables you to create pausable mechanism to stop in case of emergency.
581 contract CustomPausable is CustomAdmin {
582   event Paused();
583   event Unpaused();
584 
585   bool public paused = false;
586 
587   ///@notice Verifies whether the contract is not paused.
588   modifier whenNotPaused() {
589     require(!paused, "Sorry but the contract isn't paused.");
590     _;
591   }
592 
593   ///@notice Verifies whether the contract is paused.
594   modifier whenPaused() {
595     require(paused, "Sorry but the contract is paused.");
596     _;
597   }
598 
599   ///@notice Pauses the contract.
600   function pause() external onlyAdmin whenNotPaused {
601     paused = true;
602     emit Paused();
603   }
604 
605   ///@notice Unpauses the contract and returns to normal state.
606   function unpause() external onlyAdmin whenPaused {
607     paused = false;
608     emit Unpaused();
609   }
610 }
611 /*
612 Copyright 2018 Binod Nirvan
613 
614 Licensed under the Apache License, Version 2.0 (the "License");
615 you may not use this file except in compliance with the License.
616 You may obtain a copy of the License at
617 
618     http:///www.apache.org/licenses/LICENSE-2.0
619 
620 Unless required by applicable law or agreed to in writing, software
621 distributed under the License is distributed on an "AS IS" BASIS,
622 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
623 See the License for the specific language governing permissions and
624 limitations under the License.
625  */
626 
627 
628 
629 
630 
631 
632 ///@title Custom Lockable Contract
633 ///@author Binod Nirvan
634 ///@notice This contract enables Cyber Security Ecosystem Token admins
635 ///to lock tokens on an individual-wallet basis.
636 ///When tokens are locked for specific wallet,
637 ///they cannot transfer their balances
638 ///until the end of their locking period.
639 ///Furthermore, this feature is created to specifically
640 ///lock bounty, advisory, and team tokens
641 ///for a set period of time.
642 ///This feature once turned off cannot be switched on back again.
643 contract CustomLockable is CustomAdmin {
644   ///Locking list contains list of wallets and their respective release dates.
645   mapping(address => uint256) public lockingList;
646 
647   ///Signifies if the locking feature can be used.
648   bool public canLock = true;
649 
650   event TokenLocked(address indexed _address, uint256 _releaseDate);
651   event TokenUnlocked(address indexed _address);
652   event LockingDisabled();
653 
654   ///@notice Reverts this transfer if the wallet is in the locking list.
655   modifier revertIfLocked(address _wallet) {
656     require(!isLocked(_wallet), "The operation was cancelled because your tokens are locked.");
657     _;
658   }
659 
660   ///@notice Checks if a wallet is locked for transfers.
661   function isLocked(address _wallet) public view returns(bool) {
662     uint256 _lockedUntil = lockingList[_wallet];
663 
664     //solium-disable-next-line
665     if(_lockedUntil > now) {
666       return true;
667     }
668 
669     return false;
670   }
671 
672   ///@notice Adds the specified address to the locking list.
673   ///@param _address The address to add to the locking list.
674   ///@param _releaseDate The date when the tokens become avaiable for transfer.
675   function addLock(address _address, uint256 _releaseDate) external onlyAdmin returns(bool) {
676     require(canLock, "Access is denied. This feature was already disabled by an administrator.");
677     require(_address != address(0), "Invalid address.");
678     require(!admins[_address], "Cannot lock administrators.");
679     require(_address != owner, "Cannot lock the owner.");
680 
681     lockingList[_address] = _releaseDate;
682 
683     if(_releaseDate > 0) {
684       emit TokenLocked(_address, _releaseDate);
685     } else {
686       emit TokenUnlocked(_address);
687     }
688 
689     return true;
690   }
691 
692   ///@notice Adds multiple addresses to the locking list.
693   ///@param _accounts The wallet addresses to add to the locking list.
694   ///@param _releaseDate The date when the tokens become avaiable for transfer.
695   function addManyLocks(address[] _accounts, uint256 _releaseDate) external onlyAdmin returns(bool) {
696     require(canLock, "Access is denied. This feature was already disabled by an administrator.");
697     require(_releaseDate > 0, "Invalid release date.");
698 
699     for(uint8 i = 0; i < _accounts.length; i++) {
700       address _account = _accounts[i];
701 
702       ///Zero address, admins, and owner cannot be locked.
703       if(_account != address(0) && !admins[_account] && _account != owner) {
704         lockingList[_account] = _releaseDate;
705         emit TokenLocked(_account, _releaseDate);
706       }
707     }
708 
709     return true;
710   }
711 
712   ///@notice Removes multiple addresses from the locking list.
713   ///@param _accounts The wallet addresses to unlock.
714   function removeManyLocks(address[] _accounts) external onlyAdmin returns(bool) {
715     require(canLock, "Access is denied. This feature was already disabled by an administrator.");
716 
717     for(uint8 i = 0; i < _accounts.length; i++) {
718       address _account = _accounts[i];
719 
720       lockingList[_account] = 0;
721       emit TokenUnlocked(_account);
722     }
723 
724     return true;
725   }
726 
727   ///@notice Once locking feature is disable, it cannot be
728   ///truned back on thenceforth.
729   function disableLocking() external onlyAdmin returns(bool) {
730     require(canLock, "The token lock feature is already disabled.");
731 
732     canLock = false;
733     emit LockingDisabled();
734     return true;
735   }
736 }
737 /*
738 Copyright 2018 Binod Nirvan
739 Licensed under the Apache License, Version 2.0 (the "License");
740 you may not use this file except in compliance with the License.
741 You may obtain a copy of the License at
742     http://www.apache.org/licenses/LICENSE-2.0
743 Unless required by applicable law or agreed to in writing, software
744 distributed under the License is distributed on an "AS IS" BASIS,
745 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
746 See the License for the specific language governing permissions and
747 limitations under the License.
748 */
749 
750 
751 
752 
753 
754 
755 ///@title Transfer State Contract
756 ///@author Binod Nirvan
757 ///@notice Enables the admins to maintain the transfer state.
758 ///Transfer state when disabled disallows everyone but admins to transfer tokens.
759 contract TransferState is CustomPausable {
760   bool public released = false;
761 
762   event TokenReleased(bool _state);
763 
764   ///@notice Checks if the supplied address is able to perform transfers.
765   ///@param _from The address to check against if the transfer is allowed.
766   modifier canTransfer(address _from) {
767     if(paused || !released) {
768       if(!isAdmin(_from)) {
769         revert("Operation not allowed. The transfer state is restricted.");
770       }
771     }
772 
773     _;
774   }
775 
776   ///@notice This function enables token transfers for everyone.
777   ///Can only be enabled after the end of the ICO.
778   function enableTransfers() external onlyAdmin whenNotPaused returns(bool) {
779     require(!released, "Invalid operation. The transfer state is no more restricted.");
780 
781     released = true;
782 
783     emit TokenReleased(released);
784     return true;
785   }
786 
787   ///@notice This function disables token transfers for everyone.
788   function disableTransfers() external onlyAdmin whenNotPaused returns(bool) {
789     require(released, "Invalid operation. The transfer state is already restricted.");
790 
791     released = false;
792 
793     emit TokenReleased(released);
794     return true;
795   }
796 }
797 /*
798 Copyright 2018 Binod Nirvan
799 Licensed under the Apache License, Version 2.0 (the "License");
800 you may not use this file except in compliance with the License.
801 You may obtain a copy of the License at
802     http://www.apache.org/licenses/LICENSE-2.0
803 Unless required by applicable law or agreed to in writing, software
804 distributed under the License is distributed on an "AS IS" BASIS,
805 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
806 See the License for the specific language governing permissions and
807 limitations under the License.
808 */
809 
810 
811 
812 
813 
814 
815 
816 ///@title Bulk Transfer Contract
817 ///@author Binod Nirvan
818 ///@notice This contract provides features for admins to perform bulk transfers.
819 contract BulkTransfer is StandardToken, CustomAdmin {
820   event BulkTransferPerformed(address[] _destinations, uint256[] _amounts);
821 
822   ///@notice Allows only the admins and/or whitelisted applications to perform bulk transfer operation.
823   ///@param _destinations The destination wallet addresses to send funds to.
824   ///@param _amounts The respective amount of fund to send to the specified addresses.
825   function bulkTransfer(address[] _destinations, uint256[] _amounts) public onlyAdmin returns(bool) {
826     require(_destinations.length == _amounts.length, "Invalid operation.");
827 
828     //Saving gas by determining if the sender has enough balance
829     //to post this transaction.
830     uint256 requiredBalance = sumOf(_amounts);
831     require(balances[msg.sender] >= requiredBalance, "You don't have sufficient funds to transfer amount that large.");
832 
833     for (uint256 i = 0; i < _destinations.length; i++) {
834       transfer(_destinations[i], _amounts[i]);
835     }
836 
837     emit BulkTransferPerformed(_destinations, _amounts);
838     return true;
839   }
840 
841   ///@notice Returns the sum of supplied values.
842   ///@param _values The collection of values to create the sum from.
843   function sumOf(uint256[] _values) private pure returns(uint256) {
844     uint256 total = 0;
845 
846     for (uint256 i = 0; i < _values.length; i++) {
847       total = total.add(_values[i]);
848     }
849 
850     return total;
851   }
852 }
853 /*
854 Copyright 2018 Binod Nirvan
855 Licensed under the Apache License, Version 2.0 (the "License");
856 you may not use this file except in compliance with the License.
857 You may obtain a copy of the License at
858     http://www.apache.org/licenses/LICENSE-2.0
859 Unless required by applicable law or agreed to in writing, software
860 distributed under the License is distributed on an "AS IS" BASIS,
861 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
862 See the License for the specific language governing permissions and
863 limitations under the License.
864 */
865 
866 
867 
868 
869 
870 
871 
872 
873 
874 
875 /**
876  * @title SafeERC20
877  * @dev Wrappers around ERC20 operations that throw on failure.
878  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
879  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
880  */
881 library SafeERC20 {
882   function safeTransfer(
883     ERC20Basic _token,
884     address _to,
885     uint256 _value
886   )
887     internal
888   {
889     require(_token.transfer(_to, _value));
890   }
891 
892   function safeTransferFrom(
893     ERC20 _token,
894     address _from,
895     address _to,
896     uint256 _value
897   )
898     internal
899   {
900     require(_token.transferFrom(_from, _to, _value));
901   }
902 
903   function safeApprove(
904     ERC20 _token,
905     address _spender,
906     uint256 _value
907   )
908     internal
909   {
910     require(_token.approve(_spender, _value));
911   }
912 }
913 
914 
915 
916 
917 ///@title Reclaimable Contract
918 ///@author Binod Nirvan
919 ///@notice Reclaimable contract enables the administrators
920 ///to reclaim accidentally sent Ethers and ERC20 token(s)
921 ///to this contract.
922 contract Reclaimable is CustomAdmin {
923   using SafeERC20 for ERC20;
924 
925   ///@notice Transfers all Ether held by the contract to the owner.
926   function reclaimEther() external onlyAdmin {
927     msg.sender.transfer(address(this).balance);
928   }
929 
930   ///@notice Transfers all ERC20 tokens held by the contract to the owner.
931   ///@param _token The amount of token to reclaim.
932   function reclaimToken(address _token) external onlyAdmin {
933     ERC20 erc20 = ERC20(_token);
934     uint256 balance = erc20.balanceOf(this);
935     erc20.safeTransfer(msg.sender, balance);
936   }
937 }
938 
939 
940 ///@title CYBRToken Base Contract
941 ///@author Binod Nirvan
942 ///@notice Cyber Security Ecosystem Tokens are designed to incentivize and provide
943 ///functionality for the three-pronged CYBR solution.
944 ///Subscription services and the provision of blockchain related services
945 ///will be solely transacted utilizing Cyber Security Ecosystem Tokens.
946 ///Rewards for CYBR community members will be a determined allocation of Cyber Security Ecosystem Tokens.
947 ///CYBR is a standard ERC20 smart contract-based to- ken running
948 ///on the Ethereum network and is implemented
949 ///within the business logic set forth by the Company’s developers.
950 ///&nbsp;
951 ///The CYBR utility token is redeemable for usage with BlindSpot
952 ///and global threat intelligence feeds. The CYBR initiative provides
953 ///protection to individual networks, SMEs and large-scale enterprise users.
954 ///Intelligence feeds are based on risk scores; packaged in a series of
955 ///products/services and delivered via a subscription model which can provide:
956 ///&nbsp;
957 ///- Assessed zero-day global threat feeds o Json, CSV and XML formats
958 ///  - Utilizing IP tables firewall rules
959 ///  - Magento, Wordpress and related plugins
960 ///- Global threat intelligence reports
961 ///- Email alerts
962 ///- Mobile apps
963 ///- API key to access CYBR via apps/dapps
964 ///&nbsp;
965 ///Data feeds will be based on number of user licenses, to be purchased
966 ///on a yearly-based subscription model. Special needs assessments, customized solutions,
967 ///or any appliance applications can be purchased at an additional cost.
968 ///&nbsp;
969 ///The CYBR business model is simple: a subscription-based value-added service
970 ///with recurring revenues. The company has identified a number of ancillary
971 ///revenue streams, ranging from customized packages to the sale of propriety
972 ///and modded hardware devices. However, it should be noted that the potent
973 ///solution that is BlindSpot will drive our quest for adoption.
974 contract TokenBase is StandardToken, TransferState, BulkTransfer, Reclaimable, BurnableToken, CustomLockable {
975   //solhint-disable
976   uint8 public constant decimals = 18;
977   string public constant name = "CYBR - Cyber Security Ecosystem Token";
978   string public constant symbol = "CYBR";
979   //solhint-enable
980 
981   uint256 internal constant MILLION = 1000000 * 1 ether;
982   uint256 internal constant BILLION = 1000000000 * 1 ether;
983   uint256 public constant MAX_SUPPLY = BILLION;
984   uint256 public constant INITIAL_SUPPLY = 510 * MILLION;//51%
985 
986   event Mint(address indexed to, uint256 amount);
987 
988   constructor() public {
989     mintTokens(msg.sender, INITIAL_SUPPLY);
990   }
991 
992   ///@notice Transfers the specified value of Cyber Security Ecosystem Tokens to the destination address.
993   //Transfers can only happen when the transfer state is enabled.
994   //Transfer state can only be enabled after the end of the crowdsale.
995   ///@param _to The destination wallet address to transfer funds to.
996   ///@param _value The amount of tokens to send to the destination address.
997   function transfer(address _to, uint256 _value)
998   public
999   revertIfLocked(msg.sender)
1000   canTransfer(msg.sender)
1001   returns(bool) {
1002     require(_to != address(0), "Invalid address.");
1003     return super.transfer(_to, _value);
1004   }
1005 
1006   ///@notice Transfers tokens from a specified wallet address.
1007   ///@dev This function is overridden to leverage transfer state feature.
1008   ///@param _from The address to transfer funds from.
1009   ///@param _to The address to transfer funds to.
1010   ///@param _value The amount of tokens to transfer.
1011   function transferFrom(address _from, address _to, uint256 _value)
1012   public
1013   revertIfLocked(_from)
1014   canTransfer(_from)
1015   returns(bool) {
1016     require(_to != address(0), "Invalid address.");
1017     return super.transferFrom(_from, _to, _value);
1018   }
1019 
1020   ///@notice Approves a wallet address to spend on behalf of the sender.
1021   ///@dev This function is overridden to leverage transfer state feature.
1022   ///@param _spender The address which is approved to spend on behalf of the sender.
1023   ///@param _value The amount of tokens approve to spend.
1024   function approve(address _spender, uint256 _value)
1025   public
1026   revertIfLocked(msg.sender)
1027   canTransfer(msg.sender)
1028   returns(bool) {
1029     require(_spender != address(0), "Invalid address.");
1030     return super.approve(_spender, _value);
1031   }
1032 
1033   ///@notice Increases the approval of the spender.
1034   ///@dev This function is overridden to leverage transfer state feature.
1035   ///@param _spender The address which is approved to spend on behalf of the sender.
1036   ///@param _addedValue The added amount of tokens approved to spend.
1037   function increaseApproval(address _spender, uint256 _addedValue)
1038   public
1039   revertIfLocked(msg.sender)
1040   canTransfer(msg.sender)
1041   returns(bool) {
1042     require(_spender != address(0), "Invalid address.");
1043     return super.increaseApproval(_spender, _addedValue);
1044   }
1045 
1046   ///@notice Decreases the approval of the spender.
1047   ///@dev This function is overridden to leverage transfer state feature.
1048   ///@param _spender The address of the spender to decrease the allocation from.
1049   ///@param _subtractedValue The amount of tokens to subtract from the approved allocation.
1050   function decreaseApproval(address _spender, uint256 _subtractedValue)
1051   public
1052   revertIfLocked(msg.sender)
1053   canTransfer(msg.sender)
1054   returns(bool) {
1055     require(_spender != address(0), "Invalid address.");
1056     return super.decreaseApproval(_spender, _subtractedValue);
1057   }
1058 
1059   ///@notice Burns the coins held by the sender.
1060   ///@param _value The amount of coins to burn.
1061   ///@dev This function is overridden to leverage Pausable feature.
1062   function burn(uint256 _value)
1063   public
1064   revertIfLocked(msg.sender)
1065   canTransfer(msg.sender)
1066   whenNotPaused {
1067     super.burn(_value);
1068   }
1069 
1070   ///@notice Mints the supplied value of the tokens to the destination address.
1071   //Minting cannot be performed any further once the maximum supply is reached.
1072   //This function cannot be used by anyone except for this contract.
1073   ///@param _to The address which will receive the minted tokens.
1074   ///@param _value The amount of tokens to mint.
1075   function mintTokens(address _to, uint _value) internal returns(bool) {
1076     require(_to != address(0), "Invalid address.");
1077     require(totalSupply_.add(_value) <= MAX_SUPPLY, "Sorry but the total supply can't exceed the maximum supply.");
1078 
1079     balances[_to] = balances[_to].add(_value);
1080     totalSupply_ = totalSupply_.add(_value);
1081 
1082     emit Transfer(address(0), _to, _value);
1083     emit Mint(_to, _value);
1084 
1085     return true;
1086   }
1087 }
1088 
1089 
1090 ///@title Cyber Security Ecosystem Token
1091 ///@author Binod Nirvan
1092 ///@notice Cyber Security Ecosystem Tokens are designed to incentivize and provide
1093 ///functionality for the three-pronged CYBR solution.
1094 ///Subscription services and the provision of blockchain related services
1095 ///will be solely transacted utilizing Cyber Security Ecosystem Tokens.
1096 ///Rewards for CYBR community members will be a determined allocation of Cyber Security Ecosystem Tokens.
1097 ///CYBR is a standard ERC20 smart contract-based to- ken running
1098 ///on the Ethereum network and is implemented
1099 ///within the business logic set forth by the Company’s developers.
1100 ///&nbsp;
1101 ///The CYBR utility token is redeemable for usage with BlindSpot
1102 ///and global threat intelligence feeds. The CYBR initiative provides
1103 ///protection to individual networks, SMEs and large-scale enterprise users.
1104 ///Intelligence feeds are based on risk scores; packaged in a series of
1105 ///products/services and delivered via a subscription model which can provide:
1106 ///&nbsp;
1107 ///- Assessed zero-day global threat feeds o Json, CSV and XML formats
1108 ///  - Utilizing IP tables firewall rules
1109 ///  - Magento, Wordpress and related plugins
1110 ///- Global threat intelligence reports
1111 ///- Email alerts
1112 ///- Mobile apps
1113 ///- API key to access CYBR via apps/dapps
1114 ///&nbsp;
1115 ///Data feeds will be based on number of user licenses, to be purchased
1116 ///on a yearly-based subscription model. Special needs assessments, customized solutions,
1117 ///or any appliance applications can be purchased at an additional cost.
1118 ///&nbsp;
1119 ///The CYBR business model is simple: a subscription-based value-added service
1120 ///with recurring revenues. The company has identified a number of ancillary
1121 ///revenue streams, ranging from customized packages to the sale of propriety
1122 ///and modded hardware devices. However, it should be noted that the potent
1123 ///solution that is BlindSpot will drive our quest for adoption.
1124 contract CYBRToken is TokenBase {
1125   //solhint-disable not-rely-on-time
1126   //solium-disable security/no-block-members
1127 
1128   uint256 public icoEndDate;
1129 
1130   uint256 public constant ALLOCATION_FOR_FOUNDERS = 100 * MILLION;//10%
1131   uint256 public constant ALLOCATION_FOR_TEAM = 100 * MILLION;//10%
1132   uint256 public constant ALLOCATION_FOR_RESERVE = 100 * MILLION;//10%
1133   uint256 public constant ALLOCATION_FOR_INITIAL_PARTNERSHIPS = 50 * MILLION;//5%
1134   uint256 public constant ALLOCATION_FOR_PARTNERSHIPS = 50 * MILLION;//5%
1135   uint256 public constant ALLOCATION_FOR_ADVISORS = 60 * MILLION;//6%
1136   uint256 public constant ALLOCATION_FOR_PROMOTION = 30 * MILLION;//3%
1137 
1138   bool public targetReached = false;
1139 
1140   mapping(bytes32 => bool) private mintingList;
1141 
1142   event ICOEndDateSet(uint256 _date);
1143   event TargetReached();
1144 
1145   ///@notice Checks if the minting for the supplied key was already performed.
1146   ///@param _key The key or category name of minting.
1147   modifier whenNotMinted(string _key) {
1148     if(mintingList[computeHash(_key)]) {
1149       revert("Duplicate minting key supplied.");
1150     }
1151 
1152     _;
1153   }
1154 
1155   ///@notice This function signifies that the minimum fundraising target was met.
1156   ///Please note that this can only be called once.
1157   function setSuccess() external onlyAdmin returns(bool) {
1158     require(!targetReached, "Access is denied.");
1159     targetReached = true;
1160 
1161     emit TargetReached();
1162   }
1163 
1164   ///@notice This function enables the whitelisted application (internal application) to set the
1165   ///ICO end date and can only be used once.
1166   ///@param _date The date to set as the ICO end date.
1167   function setICOEndDate(uint _date) external onlyAdmin returns(bool) {
1168     require(icoEndDate == 0, "The ICO end date was already set.");
1169 
1170     icoEndDate = _date;
1171 
1172     emit ICOEndDateSet(_date);
1173     return true;
1174   }
1175 
1176   ///@notice Mints the 100 million Cyber Security Ecosystem Tokens allocated to the CYBRToken founders.
1177   ///The tokens are only available to the founders after 18 months of the ICO end.
1178   function mintTokensForFounders() external onlyAdmin returns(bool) {
1179     require(targetReached, "Sorry, you can't mint at this time because the target hasn't been reached yet.");
1180     require(icoEndDate != 0, "You need to specify the ICO end date before minting the tokens.");
1181     require(now > (icoEndDate + 548 days), "Access is denied, it's too early to mint founder tokens.");
1182 
1183     return mintOnce("founders", msg.sender, ALLOCATION_FOR_FOUNDERS);
1184   }
1185 
1186   ///@notice Mints 100 million Cyber Security Ecosystem Tokens allocated to the CYBRToken team.
1187   ///The tokens are only available to the founders after 1 year of the ICO end.
1188   function mintTokensForTeam() external onlyAdmin returns(bool) {
1189     require(targetReached, "Sorry, you can't mint at this time because the target hasn't been reached yet.");
1190     require(icoEndDate != 0, "You need to specify the ICO end date before minting the tokens.");
1191     require(now > (icoEndDate + 365 days), "Access is denied, it's too early to mint team tokens.");
1192 
1193     return mintOnce("team", msg.sender, ALLOCATION_FOR_TEAM);
1194   }
1195 
1196   ///@notice Mints the 100 million Cyber Security Ecosystem Tokens allocated to the operational reserves.
1197   ///The tokens are only available in the reserves after 1 year of the ICO end.
1198   function mintReserveTokens() external onlyAdmin returns(bool) {
1199     require(targetReached, "Sorry, you can't mint at this time because the target hasn't been reached yet.");
1200     require(icoEndDate != 0, "You need to specify the ICO end date before minting the tokens.");
1201     require(now > (icoEndDate + 365 days), "Access is denied, it's too early to mint the reserve tokens.");
1202 
1203     return mintOnce("reserve", msg.sender, ALLOCATION_FOR_RESERVE);
1204   }
1205 
1206   ///@notice Mints the 50 million tokens allocated for initial partnerships.
1207   ///The tokens are only available to the partners after 6 months of the ICO end.
1208   function mintTokensForInitialPartnerships() external onlyAdmin returns(bool) {
1209     return mintOnce("initialPartnerships", msg.sender, ALLOCATION_FOR_INITIAL_PARTNERSHIPS);
1210   }
1211 
1212   ///@notice Mints the 50 million tokens allocated for partnerships.
1213   ///The tokens are only available to the partners after 6 months of the ICO end.
1214   function mintTokensForPartnerships() external onlyAdmin returns(bool) {
1215     require(targetReached, "Sorry, you can't mint at this time because the target hasn't been reached yet.");
1216     require(icoEndDate != 0, "You need to specify the ICO end date before minting the tokens.");
1217     require(now > (icoEndDate + 182 days), "Access is denied, it's too early to mint the partnership tokens.");
1218 
1219     return mintOnce("partnerships", msg.sender, ALLOCATION_FOR_PARTNERSHIPS);
1220   }
1221 
1222   ///@notice Mints the 60 million tokens allocated to the CYBRToken advisors.
1223   ///The tokens are only available to the advisors after 1 year of the ICO end.
1224   function mintTokensForAdvisors() external onlyAdmin returns(bool) {
1225     require(targetReached, "Sorry, you can't mint at this time because the target hasn't been reached yet.");
1226     require(icoEndDate != 0, "You need to specify the ICO end date before minting the tokens.");
1227     require(now > (icoEndDate + 365 days), "Access is denied, it's too early to mint advisory tokens.");
1228 
1229     return mintOnce("advisors", msg.sender, ALLOCATION_FOR_ADVISORS);
1230   }
1231 
1232   ///@notice Mints the 30 million Cyber Security Ecosystem Tokens allocated to promotion.
1233   ///The tokens are available at the end of the ICO.
1234   function mintTokensForPromotion() external onlyAdmin returns(bool) {
1235     require(targetReached, "Sorry, you can't mint at this time because the target hasn't been reached yet.");
1236     require(icoEndDate != 0, "You need to specify the ICO end date before minting the tokens.");
1237     require(now > icoEndDate, "Access is denied, it's too early to mint the promotion tokens.");
1238 
1239     return mintOnce("promotion", msg.sender, ALLOCATION_FOR_PROMOTION);
1240   }
1241 
1242   ///@notice Computes keccak256 hash of the supplied value.
1243   ///@param _key The string value to compute hash from.
1244   function computeHash(string _key) private pure returns(bytes32) {
1245     return keccak256(abi.encodePacked(_key));
1246   }
1247 
1248   ///@notice Mints the tokens only once against the supplied key (category).
1249   ///@param _key The key or the category of the allocation to mint the tokens for.
1250   ///@param _to The address receiving the minted tokens.
1251   ///@param _amount The amount of tokens to mint.
1252   function mintOnce(string _key, address _to, uint256 _amount) private whenNotPaused whenNotMinted(_key) returns(bool) {
1253     mintingList[computeHash(_key)] = true;
1254     return mintTokens(_to, _amount);
1255   }
1256 }