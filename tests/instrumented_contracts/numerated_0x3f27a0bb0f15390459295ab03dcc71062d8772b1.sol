1 /*
2 Copyright 2018 Fileora
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
16 
17 
18 
19 
20 
21 
22 
23 
24 /**
25  * @title ERC20Basic
26  * @dev Simpler version of ERC20 interface
27  * See https://github.com/ethereum/EIPs/issues/179
28  */
29 contract ERC20Basic {
30   function totalSupply() public view returns (uint256);
31   function balanceOf(address _who) public view returns (uint256);
32   function transfer(address _to, uint256 _value) public returns (bool);
33   event Transfer(address indexed from, address indexed to, uint256 value);
34 }
35 
36 
37 
38 
39 /**
40  * @title SafeMath
41  * @dev Math operations with safety checks that throw on error
42  */
43 library SafeMath {
44 
45   /**
46   * @dev Multiplies two numbers, throws on overflow.
47   */
48   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
49     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
50     // benefit is lost if 'b' is also tested.
51     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
52     if (_a == 0) {
53       return 0;
54     }
55 
56     c = _a * _b;
57     assert(c / _a == _b);
58     return c;
59   }
60 
61   /**
62   * @dev Integer division of two numbers, truncating the quotient.
63   */
64   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
65     // assert(_b > 0); // Solidity automatically throws when dividing by 0
66     // uint256 c = _a / _b;
67     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
68     return _a / _b;
69   }
70 
71   /**
72   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
73   */
74   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
75     assert(_b <= _a);
76     return _a - _b;
77   }
78 
79   /**
80   * @dev Adds two numbers, throws on overflow.
81   */
82   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
83     c = _a + _b;
84     assert(c >= _a);
85     return c;
86   }
87 }
88 
89 
90 
91 /**
92  * @title Basic token
93  * @dev Basic version of StandardToken, with no allowances.
94  */
95 contract BasicToken is ERC20Basic {
96   using SafeMath for uint256;
97 
98   mapping(address => uint256) internal balances;
99 
100   uint256 internal totalSupply_;
101 
102   /**
103   * @dev Total number of tokens in existence
104   */
105   function totalSupply() public view returns (uint256) {
106     return totalSupply_;
107   }
108 
109   /**
110   * @dev Transfer token for a specified address
111   * @param _to The address to transfer to.
112   * @param _value The amount to be transferred.
113   */
114   function transfer(address _to, uint256 _value) public returns (bool) {
115     require(_value <= balances[msg.sender]);
116     require(_to != address(0));
117 
118     balances[msg.sender] = balances[msg.sender].sub(_value);
119     balances[_to] = balances[_to].add(_value);
120     emit Transfer(msg.sender, _to, _value);
121     return true;
122   }
123 
124   /**
125   * @dev Gets the balance of the specified address.
126   * @param _owner The address to query the the balance of.
127   * @return An uint256 representing the amount owned by the passed address.
128   */
129   function balanceOf(address _owner) public view returns (uint256) {
130     return balances[_owner];
131   }
132 
133 }
134 
135 
136 
137 
138 
139 
140 /**
141  * @title ERC20 interface
142  * @dev see https://github.com/ethereum/EIPs/issues/20
143  */
144 contract ERC20 is ERC20Basic {
145   function allowance(address _owner, address _spender)
146     public view returns (uint256);
147 
148   function transferFrom(address _from, address _to, uint256 _value)
149     public returns (bool);
150 
151   function approve(address _spender, uint256 _value) public returns (bool);
152   event Approval(
153     address indexed owner,
154     address indexed spender,
155     uint256 value
156   );
157 }
158 
159 
160 
161 /**
162  * @title Burnable Token
163  * @dev Token that can be irreversibly burned (destroyed).
164  */
165 contract BurnableToken is BasicToken {
166 
167   event Burn(address indexed burner, uint256 value);
168 
169   /**
170    * @dev Burns a specific amount of tokens.
171    * @param _value The amount of token to be burned.
172    */
173   function burn(uint256 _value) public {
174     _burn(msg.sender, _value);
175   }
176 
177   function _burn(address _who, uint256 _value) internal {
178     require(_value <= balances[_who]);
179     // no need to require value <= totalSupply, since that would imply the
180     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
181 
182     balances[_who] = balances[_who].sub(_value);
183     totalSupply_ = totalSupply_.sub(_value);
184     emit Burn(_who, _value);
185     emit Transfer(_who, address(0), _value);
186   }
187 }
188 
189 /*
190 Copyright 2018 Binod Nirvan
191 
192 Licensed under the Apache License, Version 2.0 (the "License");
193 you may not use this file except in compliance with the License.
194 You may obtain a copy of the License at
195 
196     http://www.apache.org/licenses/LICENSE-2.0
197 
198 Unless required by applicable law or agreed to in writing, software
199 distributed under the License is distributed on an "AS IS" BASIS,
200 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
201 See the License for the specific language governing permissions and
202 limitations under the License.
203  */
204 
205 
206 
207 /*
208 Copyright 2018 Binod Nirvan
209 
210 Licensed under the Apache License, Version 2.0 (the "License");
211 you may not use this file except in compliance with the License.
212 You may obtain a copy of the License at
213 
214     http://www.apache.org/licenses/LICENSE-2.0
215 
216 Unless required by applicable law or agreed to in writing, software
217 distributed under the License is distributed on an "AS IS" BASIS,
218 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
219 See the License for the specific language governing permissions and
220 limitations under the License.
221  */
222 
223 
224 
225 
226 
227 
228 /**
229  * @title Ownable
230  * @dev The Ownable contract has an owner address, and provides basic authorization control
231  * functions, this simplifies the implementation of "user permissions".
232  */
233 contract Ownable {
234   address public owner;
235 
236 
237   event OwnershipRenounced(address indexed previousOwner);
238   event OwnershipTransferred(
239     address indexed previousOwner,
240     address indexed newOwner
241   );
242 
243 
244   /**
245    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
246    * account.
247    */
248   constructor() public {
249     owner = msg.sender;
250   }
251 
252   /**
253    * @dev Throws if called by any account other than the owner.
254    */
255   modifier onlyOwner() {
256     require(msg.sender == owner);
257     _;
258   }
259 
260   /**
261    * @dev Allows the current owner to relinquish control of the contract.
262    * @notice Renouncing to ownership will leave the contract without an owner.
263    * It will not be possible to call the functions with the `onlyOwner`
264    * modifier anymore.
265    */
266   function renounceOwnership() public onlyOwner {
267     emit OwnershipRenounced(owner);
268     owner = address(0);
269   }
270 
271   /**
272    * @dev Allows the current owner to transfer control of the contract to a newOwner.
273    * @param _newOwner The address to transfer ownership to.
274    */
275   function transferOwnership(address _newOwner) public onlyOwner {
276     _transferOwnership(_newOwner);
277   }
278 
279   /**
280    * @dev Transfers control of the contract to a newOwner.
281    * @param _newOwner The address to transfer ownership to.
282    */
283   function _transferOwnership(address _newOwner) internal {
284     require(_newOwner != address(0));
285     emit OwnershipTransferred(owner, _newOwner);
286     owner = _newOwner;
287   }
288 }
289 
290 
291 
292 ///@title This contract enables to create multiple contract administrators.
293 contract CustomAdmin is Ownable {
294   ///@notice List of administrators.
295   mapping(address => bool) public admins;
296 
297   event AdminAdded(address indexed _address);
298   event AdminRemoved(address indexed _address);
299 
300   ///@notice Validates if the sender is actually an administrator.
301   modifier onlyAdmin() {
302     require(isAdmin(msg.sender), "Access is denied.");
303     _;
304   }
305 
306   ///@notice Adds the specified address to the list of administrators.
307   ///@param _address The address to add to the administrator list.
308   function addAdmin(address _address) external onlyAdmin returns(bool) {
309     require(_address != address(0), "Invalid address.");
310     require(!admins[_address], "This address is already an administrator.");
311 
312     require(_address != owner, "The owner cannot be added or removed to or from the administrator list.");
313 
314     admins[_address] = true;
315 
316     emit AdminAdded(_address);
317     return true;
318   }
319 
320   ///@notice Adds multiple addresses to the administrator list.
321   ///@param _accounts The wallet addresses to add to the administrator list.
322   function addManyAdmins(address[] _accounts) external onlyAdmin returns(bool) {
323     for(uint8 i = 0; i < _accounts.length; i++) {
324       address account = _accounts[i];
325 
326       ///Zero address cannot be an admin.
327       ///The owner is already an admin and cannot be assigned.
328       ///The address cannot be an existing admin.
329       if(account != address(0) && !admins[account] && account != owner) {
330         admins[account] = true;
331 
332         emit AdminAdded(_accounts[i]);
333       }
334     }
335 
336     return true;
337   }
338 
339   ///@notice Removes the specified address from the list of administrators.
340   ///@param _address The address to remove from the administrator list.
341   function removeAdmin(address _address) external onlyAdmin returns(bool) {
342     require(_address != address(0), "Invalid address.");
343     require(admins[_address], "This address isn't an administrator.");
344 
345     //The owner cannot be removed as admin.
346     require(_address != owner, "The owner cannot be added or removed to or from the administrator list.");
347 
348     admins[_address] = false;
349     emit AdminRemoved(_address);
350     return true;
351   }
352 
353   ///@notice Removes multiple addresses to the administrator list.
354   ///@param _accounts The wallet addresses to add to the administrator list.
355   function removeManyAdmins(address[] _accounts) external onlyAdmin returns(bool) {
356     for(uint8 i = 0; i < _accounts.length; i++) {
357       address account = _accounts[i];
358 
359       ///Zero address can neither be added or removed from this list.
360       ///The owner is the super admin and cannot be removed.
361       ///The address must be an existing admin in order for it to be removed.
362       if(account != address(0) && admins[account] && account != owner) {
363         admins[account] = false;
364 
365         emit AdminRemoved(_accounts[i]);
366       }
367     }
368 
369     return true;
370   }
371 
372   ///@notice Checks if an address is an administrator.
373   function isAdmin(address _address) public view returns(bool) {
374     if(_address == owner) {
375       return true;
376     }
377 
378     return admins[_address];
379   }
380 }
381 
382 
383 
384 ///@title This contract enables you to create pausable mechanism to stop in case of emergency.
385 contract CustomPausable is CustomAdmin {
386   event Paused();
387   event Unpaused();
388 
389   bool public paused = false;
390 
391   ///@notice Verifies whether the contract is not paused.
392   modifier whenNotPaused() {
393     require(!paused, "Sorry but the contract isn't paused.");
394     _;
395   }
396 
397   ///@notice Verifies whether the contract is paused.
398   modifier whenPaused() {
399     require(paused, "Sorry but the contract is paused.");
400     _;
401   }
402 
403   ///@notice Pauses the contract.
404   function pause() external onlyAdmin whenNotPaused {
405     paused = true;
406     emit Paused();
407   }
408 
409   ///@notice Unpauses the contract and returns to normal state.
410   function unpause() external onlyAdmin whenPaused {
411     paused = false;
412     emit Unpaused();
413   }
414 }
415 /*
416 Copyright 2018 Binod Nirvan
417 Licensed under the Apache License, Version 2.0 (the "License");
418 you may not use this file except in compliance with the License.
419 You may obtain a copy of the License at
420     http://www.apache.org/licenses/LICENSE-2.0
421 Unless required by applicable law or agreed to in writing, software
422 distributed under the License is distributed on an "AS IS" BASIS,
423 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
424 See the License for the specific language governing permissions and
425 limitations under the License.
426 */
427 
428 
429 
430 
431 
432 
433 ///@title Transfer State Contract
434 ///@author Binod Nirvan
435 ///@notice Enables the admins to maintain the transfer state.
436 ///Transfer state when disabled disallows everyone but admins to transfer tokens.
437 contract TransferState is CustomPausable {
438   bool public released = false;
439 
440   event TokenReleased(bool _state);
441 
442   ///@notice Checks if the supplied address is able to perform transfers.
443   ///@param _from The address to check against if the transfer is allowed.
444   modifier canTransfer(address _from) {
445     if(paused || !released) {
446       if(!isAdmin(_from)) {
447         revert("Operation not allowed. The transfer state is restricted.");
448       }
449     }
450 
451     _;
452   }
453 
454   ///@notice This function enables token transfers for everyone.
455   ///Can only be enabled after the end of the ICO.
456   function enableTransfers() external onlyAdmin whenNotPaused returns(bool) {
457     require(!released, "Invalid operation. The transfer state is no more restricted.");
458 
459     released = true;
460 
461     emit TokenReleased(released);
462     return true;
463   }
464 
465   ///@notice This function disables token transfers for everyone.
466   function disableTransfers() external onlyAdmin whenNotPaused returns(bool) {
467     require(released, "Invalid operation. The transfer state is already restricted.");
468 
469     released = false;
470 
471     emit TokenReleased(released);
472     return true;
473   }
474 }
475 /*
476 Copyright 2018 Binod Nirvan
477 Licensed under the Apache License, Version 2.0 (the "License");
478 you may not use this file except in compliance with the License.
479 You may obtain a copy of the License at
480     http://www.apache.org/licenses/LICENSE-2.0
481 Unless required by applicable law or agreed to in writing, software
482 distributed under the License is distributed on an "AS IS" BASIS,
483 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
484 See the License for the specific language governing permissions and
485 limitations under the License.
486 */
487 
488 
489 
490 
491 
492 
493 
494 
495 
496 /**
497  * @title Standard ERC20 token
498  *
499  * @dev Implementation of the basic standard token.
500  * https://github.com/ethereum/EIPs/issues/20
501  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
502  */
503 contract StandardToken is ERC20, BasicToken {
504 
505   mapping (address => mapping (address => uint256)) internal allowed;
506 
507 
508   /**
509    * @dev Transfer tokens from one address to another
510    * @param _from address The address which you want to send tokens from
511    * @param _to address The address which you want to transfer to
512    * @param _value uint256 the amount of tokens to be transferred
513    */
514   function transferFrom(
515     address _from,
516     address _to,
517     uint256 _value
518   )
519     public
520     returns (bool)
521   {
522     require(_value <= balances[_from]);
523     require(_value <= allowed[_from][msg.sender]);
524     require(_to != address(0));
525 
526     balances[_from] = balances[_from].sub(_value);
527     balances[_to] = balances[_to].add(_value);
528     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
529     emit Transfer(_from, _to, _value);
530     return true;
531   }
532 
533   /**
534    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
535    * Beware that changing an allowance with this method brings the risk that someone may use both the old
536    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
537    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
538    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
539    * @param _spender The address which will spend the funds.
540    * @param _value The amount of tokens to be spent.
541    */
542   function approve(address _spender, uint256 _value) public returns (bool) {
543     allowed[msg.sender][_spender] = _value;
544     emit Approval(msg.sender, _spender, _value);
545     return true;
546   }
547 
548   /**
549    * @dev Function to check the amount of tokens that an owner allowed to a spender.
550    * @param _owner address The address which owns the funds.
551    * @param _spender address The address which will spend the funds.
552    * @return A uint256 specifying the amount of tokens still available for the spender.
553    */
554   function allowance(
555     address _owner,
556     address _spender
557    )
558     public
559     view
560     returns (uint256)
561   {
562     return allowed[_owner][_spender];
563   }
564 
565   /**
566    * @dev Increase the amount of tokens that an owner allowed to a spender.
567    * approve should be called when allowed[_spender] == 0. To increment
568    * allowed value is better to use this function to avoid 2 calls (and wait until
569    * the first transaction is mined)
570    * From MonolithDAO Token.sol
571    * @param _spender The address which will spend the funds.
572    * @param _addedValue The amount of tokens to increase the allowance by.
573    */
574   function increaseApproval(
575     address _spender,
576     uint256 _addedValue
577   )
578     public
579     returns (bool)
580   {
581     allowed[msg.sender][_spender] = (
582       allowed[msg.sender][_spender].add(_addedValue));
583     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
584     return true;
585   }
586 
587   /**
588    * @dev Decrease the amount of tokens that an owner allowed to a spender.
589    * approve should be called when allowed[_spender] == 0. To decrement
590    * allowed value is better to use this function to avoid 2 calls (and wait until
591    * the first transaction is mined)
592    * From MonolithDAO Token.sol
593    * @param _spender The address which will spend the funds.
594    * @param _subtractedValue The amount of tokens to decrease the allowance by.
595    */
596   function decreaseApproval(
597     address _spender,
598     uint256 _subtractedValue
599   )
600     public
601     returns (bool)
602   {
603     uint256 oldValue = allowed[msg.sender][_spender];
604     if (_subtractedValue >= oldValue) {
605       allowed[msg.sender][_spender] = 0;
606     } else {
607       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
608     }
609     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
610     return true;
611   }
612 
613 }
614 
615 
616 
617 
618 ///@title Bulk Transfer Contract
619 ///@author Binod Nirvan
620 ///@notice This contract provides features for admins to perform bulk transfers.
621 contract BulkTransfer is StandardToken, CustomAdmin {
622   event BulkTransferPerformed(address[] _destinations, uint256[] _amounts);
623 
624   ///@notice Allows only the admins and/or whitelisted applications to perform bulk transfer operation.
625   ///@param _destinations The destination wallet addresses to send funds to.
626   ///@param _amounts The respective amount of fund to send to the specified addresses. 
627   function bulkTransfer(address[] _destinations, uint256[] _amounts) public onlyAdmin returns(bool) {
628     require(_destinations.length == _amounts.length, "Invalid operation.");
629 
630     //Saving gas by determining if the sender has enough balance
631     //to post this transaction.
632     uint256 requiredBalance = sumOf(_amounts);
633     require(balances[msg.sender] >= requiredBalance, "You don't have sufficient funds to transfer amount that large.");
634     
635     for (uint256 i = 0; i < _destinations.length; i++) {
636       transfer(_destinations[i], _amounts[i]);
637     }
638 
639     emit BulkTransferPerformed(_destinations, _amounts);
640     return true;
641   }
642   
643   ///@notice Returns the sum of supplied values.
644   ///@param _values The collection of values to create the sum from.  
645   function sumOf(uint256[] _values) private pure returns(uint256) {
646     uint256 total = 0;
647 
648     for (uint256 i = 0; i < _values.length; i++) {
649       total = total.add(_values[i]);
650     }
651 
652     return total;
653   }
654 }
655 /*
656 Copyright 2018 Binod Nirvan
657 Licensed under the Apache License, Version 2.0 (the "License");
658 you may not use this file except in compliance with the License.
659 You may obtain a copy of the License at
660     http://www.apache.org/licenses/LICENSE-2.0
661 Unless required by applicable law or agreed to in writing, software
662 distributed under the License is distributed on an "AS IS" BASIS,
663 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
664 See the License for the specific language governing permissions and
665 limitations under the License.
666 */
667 
668 
669 
670 
671 
672 
673 
674 
675 
676 
677 /**
678  * @title SafeERC20
679  * @dev Wrappers around ERC20 operations that throw on failure.
680  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
681  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
682  */
683 library SafeERC20 {
684   function safeTransfer(
685     ERC20Basic _token,
686     address _to,
687     uint256 _value
688   )
689     internal
690   {
691     require(_token.transfer(_to, _value));
692   }
693 
694   function safeTransferFrom(
695     ERC20 _token,
696     address _from,
697     address _to,
698     uint256 _value
699   )
700     internal
701   {
702     require(_token.transferFrom(_from, _to, _value));
703   }
704 
705   function safeApprove(
706     ERC20 _token,
707     address _spender,
708     uint256 _value
709   )
710     internal
711   {
712     require(_token.approve(_spender, _value));
713   }
714 }
715 
716 
717 
718 
719 ///@title Reclaimable Contract
720 ///@author Binod Nirvan
721 ///@notice Reclaimable contract enables the administrators 
722 ///to reclaim accidentally sent Ethers and ERC20 token(s)
723 ///to this contract.
724 contract Reclaimable is CustomAdmin {
725   using SafeERC20 for ERC20;
726 
727   ///@notice Transfers all Ether held by the contract to the owner.
728   function reclaimEther() external onlyAdmin {
729     msg.sender.transfer(address(this).balance);
730   }
731 
732   ///@notice Transfers all ERC20 tokens held by the contract to the owner.
733   ///@param _token The amount of token to reclaim.
734   function reclaimToken(address _token) external onlyAdmin {
735     ERC20 erc20 = ERC20(_token);
736     uint256 balance = erc20.balanceOf(this);
737     erc20.safeTransfer(msg.sender, balance);
738   }
739 }
740 
741 
742 ///@title Fileora Internal Token
743 ///@author Binod Nirvan
744 ///@notice Fileora Internal Token
745 contract FileoraInternalToken is StandardToken, TransferState, BulkTransfer, Reclaimable, BurnableToken {
746   //solhint-disable
747   uint8 public constant decimals = 18;
748   string public constant name = "Fileora Internal Token";
749   string public constant symbol = "FIT";
750   //solhint-enable
751 
752   uint256 public constant MAX_SUPPLY = 249392500 * 1 ether;
753   uint256 public constant INITIAL_SUPPLY = 100000 * 1 ether;
754 
755   event Mint(address indexed to, uint256 amount);
756 
757   constructor() public {
758     mintTokens(msg.sender, INITIAL_SUPPLY);
759   }
760 
761   ///@notice Transfers the specified value of FET tokens to the destination address. 
762   //Transfers can only happen when the transfer state is enabled. 
763   //Transfer state can only be enabled after the end of the crowdsale.
764   ///@param _to The destination wallet address to transfer funds to.
765   ///@param _value The amount of tokens to send to the destination address.
766   function transfer(address _to, uint256 _value) public canTransfer(msg.sender) returns(bool) {
767     require(_to != address(0), "Invalid address.");
768     return super.transfer(_to, _value);
769   }
770 
771   ///@notice Transfers tokens from a specified wallet address.
772   ///@dev This function is overridden to leverage transfer state feature.
773   ///@param _from The address to transfer funds from.
774   ///@param _to The address to transfer funds to.
775   ///@param _value The amount of tokens to transfer.
776   function transferFrom(address _from, address _to, uint256 _value) public canTransfer(_from) returns(bool) {
777     require(_to != address(0), "Invalid address.");
778     return super.transferFrom(_from, _to, _value);
779   }
780 
781   ///@notice Approves a wallet address to spend on behalf of the sender.
782   ///@dev This function is overridden to leverage transfer state feature.
783   ///@param _spender The address which is approved to spend on behalf of the sender.
784   ///@param _value The amount of tokens approve to spend. 
785   function approve(address _spender, uint256 _value) public canTransfer(msg.sender) returns(bool) {
786     require(_spender != address(0), "Invalid address.");
787     return super.approve(_spender, _value);
788   }
789 
790   ///@notice Increases the approval of the spender.
791   ///@dev This function is overridden to leverage transfer state feature.
792   ///@param _spender The address which is approved to spend on behalf of the sender.
793   ///@param _addedValue The added amount of tokens approved to spend.
794   function increaseApproval(address _spender, uint256 _addedValue) public canTransfer(msg.sender) returns(bool) {
795     require(_spender != address(0), "Invalid address.");
796     return super.increaseApproval(_spender, _addedValue);
797   }
798 
799   ///@notice Decreases the approval of the spender.
800   ///@dev This function is overridden to leverage transfer state feature.
801   ///@param _spender The address of the spender to decrease the allocation from.
802   ///@param _subtractedValue The amount of tokens to subtract from the approved allocation.
803   function decreaseApproval(address _spender, uint256 _subtractedValue) public canTransfer(msg.sender) returns(bool) {
804     require(_spender != address(0), "Invalid address.");
805     return super.decreaseApproval(_spender, _subtractedValue);
806   }
807 
808   ///@notice Burns the coins held by the sender.
809   ///@param _value The amount of coins to burn.
810   ///@dev This function is overridden to leverage Pausable feature.
811   function burn(uint256 _value) public whenNotPaused {
812     super.burn(_value);
813   }
814 
815   ///@notice Mints the supplied value of the tokens to the destination address.
816   //Minting cannot be performed any further once the maximum supply is reached.
817   //This function cannot be used by anyone except for this contract.
818   ///@param _to The address which will receive the minted tokens.
819   ///@param _value The amount of tokens to mint.
820   function mintTokens(address _to, uint _value) public onlyAdmin returns(bool) {
821     require(_to != address(0), "Invalid address.");
822     require(totalSupply_.add(_value) <= MAX_SUPPLY, "Sorry but the total supply can't exceed the maximum supply.");
823 
824     balances[_to] = balances[_to].add(_value);
825     totalSupply_ = totalSupply_.add(_value);
826 
827     emit Transfer(address(0), _to, _value);
828     emit Mint(_to, _value);
829 
830     return true;
831   }
832 }