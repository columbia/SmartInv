1 /*
2 Copyright 2018 Binod Nirvan @ Accept (http://accept.io)
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
161 
162 /**
163  * @title Burnable Token
164  * @dev Token that can be irreversibly burned (destroyed).
165  */
166 contract BurnableToken is BasicToken {
167 
168   event Burn(address indexed burner, uint256 value);
169 
170   /**
171    * @dev Burns a specific amount of tokens.
172    * @param _value The amount of token to be burned.
173    */
174   function burn(uint256 _value) public {
175     _burn(msg.sender, _value);
176   }
177 
178   function _burn(address _who, uint256 _value) internal {
179     require(_value <= balances[_who]);
180     // no need to require value <= totalSupply, since that would imply the
181     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
182 
183     balances[_who] = balances[_who].sub(_value);
184     totalSupply_ = totalSupply_.sub(_value);
185     emit Burn(_who, _value);
186     emit Transfer(_who, address(0), _value);
187   }
188 }
189 
190 /*
191 Copyright 2018 Binod Nirvan
192 
193 Licensed under the Apache License, Version 2.0 (the "License");
194 you may not use this file except in compliance with the License.
195 You may obtain a copy of the License at
196 
197     http://www.apache.org/licenses/LICENSE-2.0
198 
199 Unless required by applicable law or agreed to in writing, software
200 distributed under the License is distributed on an "AS IS" BASIS,
201 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
202 See the License for the specific language governing permissions and
203 limitations under the License.
204  */
205 
206 
207 
208 /*
209 Copyright 2018 Binod Nirvan
210 
211 Licensed under the Apache License, Version 2.0 (the "License");
212 you may not use this file except in compliance with the License.
213 You may obtain a copy of the License at
214 
215     http://www.apache.org/licenses/LICENSE-2.0
216 
217 Unless required by applicable law or agreed to in writing, software
218 distributed under the License is distributed on an "AS IS" BASIS,
219 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
220 See the License for the specific language governing permissions and
221 limitations under the License.
222  */
223 
224 
225 
226 
227 
228 
229 /**
230  * @title Ownable
231  * @dev The Ownable contract has an owner address, and provides basic authorization control
232  * functions, this simplifies the implementation of "user permissions".
233  */
234 contract Ownable {
235   address public owner;
236 
237 
238   event OwnershipRenounced(address indexed previousOwner);
239   event OwnershipTransferred(
240     address indexed previousOwner,
241     address indexed newOwner
242   );
243 
244 
245   /**
246    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
247    * account.
248    */
249   constructor() public {
250     owner = msg.sender;
251   }
252 
253   /**
254    * @dev Throws if called by any account other than the owner.
255    */
256   modifier onlyOwner() {
257     require(msg.sender == owner);
258     _;
259   }
260 
261   /**
262    * @dev Allows the current owner to relinquish control of the contract.
263    * @notice Renouncing to ownership will leave the contract without an owner.
264    * It will not be possible to call the functions with the `onlyOwner`
265    * modifier anymore.
266    */
267   function renounceOwnership() public onlyOwner {
268     emit OwnershipRenounced(owner);
269     owner = address(0);
270   }
271 
272   /**
273    * @dev Allows the current owner to transfer control of the contract to a newOwner.
274    * @param _newOwner The address to transfer ownership to.
275    */
276   function transferOwnership(address _newOwner) public onlyOwner {
277     _transferOwnership(_newOwner);
278   }
279 
280   /**
281    * @dev Transfers control of the contract to a newOwner.
282    * @param _newOwner The address to transfer ownership to.
283    */
284   function _transferOwnership(address _newOwner) internal {
285     require(_newOwner != address(0));
286     emit OwnershipTransferred(owner, _newOwner);
287     owner = _newOwner;
288   }
289 }
290 
291 
292 
293 ///@title This contract enables to create multiple contract administrators.
294 contract CustomAdmin is Ownable {
295   ///@notice List of administrators.
296   mapping(address => bool) public admins;
297 
298   event AdminAdded(address indexed _address);
299   event AdminRemoved(address indexed _address);
300 
301   ///@notice Validates if the sender is actually an administrator.
302   modifier onlyAdmin() {
303     require(isAdmin(msg.sender), "Access is denied.");
304     _;
305   }
306 
307   ///@notice Adds the specified address to the list of administrators.
308   ///@param _address The address to add to the administrator list.
309   function addAdmin(address _address) external onlyAdmin returns(bool) {
310     require(_address != address(0), "Invalid address.");
311     require(!admins[_address], "This address is already an administrator.");
312 
313     require(_address != owner, "The owner cannot be added or removed to or from the administrator list.");
314 
315     admins[_address] = true;
316 
317     emit AdminAdded(_address);
318     return true;
319   }
320 
321   ///@notice Adds multiple addresses to the administrator list.
322   ///@param _accounts The wallet addresses to add to the administrator list.
323   function addManyAdmins(address[] _accounts) external onlyAdmin returns(bool) {
324     for(uint8 i = 0; i < _accounts.length; i++) {
325       address account = _accounts[i];
326 
327       ///Zero address cannot be an admin.
328       ///The owner is already an admin and cannot be assigned.
329       ///The address cannot be an existing admin.
330       if(account != address(0) && !admins[account] && account != owner) {
331         admins[account] = true;
332 
333         emit AdminAdded(_accounts[i]);
334       }
335     }
336 
337     return true;
338   }
339 
340   ///@notice Removes the specified address from the list of administrators.
341   ///@param _address The address to remove from the administrator list.
342   function removeAdmin(address _address) external onlyAdmin returns(bool) {
343     require(_address != address(0), "Invalid address.");
344     require(admins[_address], "This address isn't an administrator.");
345 
346     //The owner cannot be removed as admin.
347     require(_address != owner, "The owner cannot be added or removed to or from the administrator list.");
348 
349     admins[_address] = false;
350     emit AdminRemoved(_address);
351     return true;
352   }
353 
354   ///@notice Removes multiple addresses to the administrator list.
355   ///@param _accounts The wallet addresses to add to the administrator list.
356   function removeManyAdmins(address[] _accounts) external onlyAdmin returns(bool) {
357     for(uint8 i = 0; i < _accounts.length; i++) {
358       address account = _accounts[i];
359 
360       ///Zero address can neither be added or removed from this list.
361       ///The owner is the super admin and cannot be removed.
362       ///The address must be an existing admin in order for it to be removed.
363       if(account != address(0) && admins[account] && account != owner) {
364         admins[account] = false;
365 
366         emit AdminRemoved(_accounts[i]);
367       }
368     }
369 
370     return true;
371   }
372 
373   ///@notice Checks if an address is an administrator.
374   function isAdmin(address _address) public view returns(bool) {
375     if(_address == owner) {
376       return true;
377     }
378 
379     return admins[_address];
380   }
381 }
382 
383 
384 
385 ///@title This contract enables you to create pausable mechanism to stop in case of emergency.
386 contract CustomPausable is CustomAdmin {
387   event Paused();
388   event Unpaused();
389 
390   bool public paused = false;
391 
392   ///@notice Verifies whether the contract is not paused.
393   modifier whenNotPaused() {
394     require(!paused, "Sorry but the contract isn't paused.");
395     _;
396   }
397 
398   ///@notice Verifies whether the contract is paused.
399   modifier whenPaused() {
400     require(paused, "Sorry but the contract is paused.");
401     _;
402   }
403 
404   ///@notice Pauses the contract.
405   function pause() external onlyAdmin whenNotPaused {
406     paused = true;
407     emit Paused();
408   }
409 
410   ///@notice Unpauses the contract and returns to normal state.
411   function unpause() external onlyAdmin whenPaused {
412     paused = false;
413     emit Unpaused();
414   }
415 }
416 /*
417 Copyright 2018 Binod Nirvan
418 Licensed under the Apache License, Version 2.0 (the "License");
419 you may not use this file except in compliance with the License.
420 You may obtain a copy of the License at
421     http://www.apache.org/licenses/LICENSE-2.0
422 Unless required by applicable law or agreed to in writing, software
423 distributed under the License is distributed on an "AS IS" BASIS,
424 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
425 See the License for the specific language governing permissions and
426 limitations under the License.
427 */
428 
429 
430 
431 
432 
433 
434 ///@title Transfer State Contract
435 ///@author Binod Nirvan
436 ///@notice Enables the admins to maintain the transfer state.
437 ///Transfer state when disabled disallows everyone but admins to transfer tokens.
438 contract TransferState is CustomPausable {
439   bool public released = false;
440 
441   event TokenReleased(bool _state);
442 
443   ///@notice Checks if the supplied address is able to perform transfers.
444   ///@param _from The address to check against if the transfer is allowed.
445   modifier canTransfer(address _from) {
446     if(paused || !released) {
447       if(!isAdmin(_from)) {
448         revert("Operation not allowed. The transfer state is restricted.");
449       }
450     }
451 
452     _;
453   }
454 
455   ///@notice This function enables token transfers for everyone.
456   ///Can only be enabled after the end of the ICO.
457   function enableTransfers() external onlyAdmin whenNotPaused returns(bool) {
458     require(!released, "Invalid operation. The transfer state is no more restricted.");
459 
460     released = true;
461 
462     emit TokenReleased(released);
463     return true;
464   }
465 
466   ///@notice This function disables token transfers for everyone.
467   function disableTransfers() external onlyAdmin whenNotPaused returns(bool) {
468     require(released, "Invalid operation. The transfer state is already restricted.");
469 
470     released = false;
471 
472     emit TokenReleased(released);
473     return true;
474   }
475 }
476 /*
477 Copyright 2018 Binod Nirvan
478 Licensed under the Apache License, Version 2.0 (the "License");
479 you may not use this file except in compliance with the License.
480 You may obtain a copy of the License at
481     http://www.apache.org/licenses/LICENSE-2.0
482 Unless required by applicable law or agreed to in writing, software
483 distributed under the License is distributed on an "AS IS" BASIS,
484 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
485 See the License for the specific language governing permissions and
486 limitations under the License.
487 */
488 
489 
490 
491 
492 
493 
494 
495 
496 
497 /**
498  * @title Standard ERC20 token
499  *
500  * @dev Implementation of the basic standard token.
501  * https://github.com/ethereum/EIPs/issues/20
502  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
503  */
504 contract StandardToken is ERC20, BasicToken {
505 
506   mapping (address => mapping (address => uint256)) internal allowed;
507 
508 
509   /**
510    * @dev Transfer tokens from one address to another
511    * @param _from address The address which you want to send tokens from
512    * @param _to address The address which you want to transfer to
513    * @param _value uint256 the amount of tokens to be transferred
514    */
515   function transferFrom(
516     address _from,
517     address _to,
518     uint256 _value
519   )
520     public
521     returns (bool)
522   {
523     require(_value <= balances[_from]);
524     require(_value <= allowed[_from][msg.sender]);
525     require(_to != address(0));
526 
527     balances[_from] = balances[_from].sub(_value);
528     balances[_to] = balances[_to].add(_value);
529     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
530     emit Transfer(_from, _to, _value);
531     return true;
532   }
533 
534   /**
535    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
536    * Beware that changing an allowance with this method brings the risk that someone may use both the old
537    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
538    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
539    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
540    * @param _spender The address which will spend the funds.
541    * @param _value The amount of tokens to be spent.
542    */
543   function approve(address _spender, uint256 _value) public returns (bool) {
544     allowed[msg.sender][_spender] = _value;
545     emit Approval(msg.sender, _spender, _value);
546     return true;
547   }
548 
549   /**
550    * @dev Function to check the amount of tokens that an owner allowed to a spender.
551    * @param _owner address The address which owns the funds.
552    * @param _spender address The address which will spend the funds.
553    * @return A uint256 specifying the amount of tokens still available for the spender.
554    */
555   function allowance(
556     address _owner,
557     address _spender
558    )
559     public
560     view
561     returns (uint256)
562   {
563     return allowed[_owner][_spender];
564   }
565 
566   /**
567    * @dev Increase the amount of tokens that an owner allowed to a spender.
568    * approve should be called when allowed[_spender] == 0. To increment
569    * allowed value is better to use this function to avoid 2 calls (and wait until
570    * the first transaction is mined)
571    * From MonolithDAO Token.sol
572    * @param _spender The address which will spend the funds.
573    * @param _addedValue The amount of tokens to increase the allowance by.
574    */
575   function increaseApproval(
576     address _spender,
577     uint256 _addedValue
578   )
579     public
580     returns (bool)
581   {
582     allowed[msg.sender][_spender] = (
583       allowed[msg.sender][_spender].add(_addedValue));
584     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
585     return true;
586   }
587 
588   /**
589    * @dev Decrease the amount of tokens that an owner allowed to a spender.
590    * approve should be called when allowed[_spender] == 0. To decrement
591    * allowed value is better to use this function to avoid 2 calls (and wait until
592    * the first transaction is mined)
593    * From MonolithDAO Token.sol
594    * @param _spender The address which will spend the funds.
595    * @param _subtractedValue The amount of tokens to decrease the allowance by.
596    */
597   function decreaseApproval(
598     address _spender,
599     uint256 _subtractedValue
600   )
601     public
602     returns (bool)
603   {
604     uint256 oldValue = allowed[msg.sender][_spender];
605     if (_subtractedValue >= oldValue) {
606       allowed[msg.sender][_spender] = 0;
607     } else {
608       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
609     }
610     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
611     return true;
612   }
613 
614 }
615 
616 
617 
618 
619 ///@title Bulk Transfer Contract
620 ///@author Binod Nirvan
621 ///@notice This contract provides features for admins to perform bulk transfers.
622 contract BulkTransfer is StandardToken, CustomAdmin {
623   event BulkTransferPerformed(address[] _destinations, uint256[] _amounts);
624 
625   ///@notice Allows only the admins and/or whitelisted applications to perform bulk transfer operation.
626   ///@param _destinations The destination wallet addresses to send funds to.
627   ///@param _amounts The respective amount of fund to send to the specified addresses. 
628   function bulkTransfer(address[] _destinations, uint256[] _amounts) public onlyAdmin returns(bool) {
629     require(_destinations.length == _amounts.length, "Invalid operation.");
630 
631     //Saving gas by determining if the sender has enough balance
632     //to post this transaction.
633     uint256 requiredBalance = sumOf(_amounts);
634     require(balances[msg.sender] >= requiredBalance, "You don't have sufficient funds to transfer amount that large.");
635     
636     for (uint256 i = 0; i < _destinations.length; i++) {
637       transfer(_destinations[i], _amounts[i]);
638     }
639 
640     emit BulkTransferPerformed(_destinations, _amounts);
641     return true;
642   }
643   
644   ///@notice Returns the sum of supplied values.
645   ///@param _values The collection of values to create the sum from.  
646   function sumOf(uint256[] _values) private pure returns(uint256) {
647     uint256 total = 0;
648 
649     for (uint256 i = 0; i < _values.length; i++) {
650       total = total.add(_values[i]);
651     }
652 
653     return total;
654   }
655 }
656 /*
657 Copyright 2018 Binod Nirvan
658 Licensed under the Apache License, Version 2.0 (the "License");
659 you may not use this file except in compliance with the License.
660 You may obtain a copy of the License at
661     http://www.apache.org/licenses/LICENSE-2.0
662 Unless required by applicable law or agreed to in writing, software
663 distributed under the License is distributed on an "AS IS" BASIS,
664 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
665 See the License for the specific language governing permissions and
666 limitations under the License.
667 */
668 
669 
670 
671 
672 
673 
674 
675 
676 
677 
678 /**
679  * @title SafeERC20
680  * @dev Wrappers around ERC20 operations that throw on failure.
681  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
682  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
683  */
684 library SafeERC20 {
685   function safeTransfer(
686     ERC20Basic _token,
687     address _to,
688     uint256 _value
689   )
690     internal
691   {
692     require(_token.transfer(_to, _value));
693   }
694 
695   function safeTransferFrom(
696     ERC20 _token,
697     address _from,
698     address _to,
699     uint256 _value
700   )
701     internal
702   {
703     require(_token.transferFrom(_from, _to, _value));
704   }
705 
706   function safeApprove(
707     ERC20 _token,
708     address _spender,
709     uint256 _value
710   )
711     internal
712   {
713     require(_token.approve(_spender, _value));
714   }
715 }
716 
717 
718 
719 
720 ///@title Reclaimable Contract
721 ///@author Binod Nirvan
722 ///@notice Reclaimable contract enables the administrators 
723 ///to reclaim accidentally sent Ethers and ERC20 token(s)
724 ///to this contract.
725 contract Reclaimable is CustomAdmin {
726   using SafeERC20 for ERC20;
727 
728   ///@notice Transfers all Ether held by the contract to the owner.
729   function reclaimEther() external onlyAdmin {
730     msg.sender.transfer(address(this).balance);
731   }
732 
733   ///@notice Transfers all ERC20 tokens held by the contract to the owner.
734   ///@param _token The amount of token to reclaim.
735   function reclaimToken(address _token) external onlyAdmin {
736     ERC20 erc20 = ERC20(_token);
737     uint256 balance = erc20.balanceOf(this);
738     erc20.safeTransfer(msg.sender, balance);
739   }
740 }
741 
742 
743 ///@title Fileora Equity Token
744 ///@author Binod Nirvan
745 ///@notice Fileora Equity Token
746 contract FileoraEquityToken is StandardToken, TransferState, BulkTransfer, Reclaimable, BurnableToken {
747   //solhint-disable
748   uint8 public constant decimals = 18;
749   string public constant name = "Fileora Equity Token";
750   string public constant symbol = "FET";
751   //solhint-enable
752 
753   uint256 public constant MAX_SUPPLY = 249392500 * 1 ether;
754   uint256 public constant INITIAL_SUPPLY = 100000 * 1 ether;
755 
756   event Mint(address indexed to, uint256 amount);
757 
758   constructor() public {
759     mintTokens(msg.sender, INITIAL_SUPPLY);
760   }
761 
762   ///@notice Transfers the specified value of FET tokens to the destination address. 
763   //Transfers can only happen when the transfer state is enabled. 
764   //Transfer state can only be enabled after the end of the crowdsale.
765   ///@param _to The destination wallet address to transfer funds to.
766   ///@param _value The amount of tokens to send to the destination address.
767   function transfer(address _to, uint256 _value) public canTransfer(msg.sender) returns(bool) {
768     require(_to != address(0), "Invalid address.");
769     return super.transfer(_to, _value);
770   }
771 
772   ///@notice Transfers tokens from a specified wallet address.
773   ///@dev This function is overridden to leverage transfer state feature.
774   ///@param _from The address to transfer funds from.
775   ///@param _to The address to transfer funds to.
776   ///@param _value The amount of tokens to transfer.
777   function transferFrom(address _from, address _to, uint256 _value) public canTransfer(_from) returns(bool) {
778     require(_to != address(0), "Invalid address.");
779     return super.transferFrom(_from, _to, _value);
780   }
781 
782   ///@notice Approves a wallet address to spend on behalf of the sender.
783   ///@dev This function is overridden to leverage transfer state feature.
784   ///@param _spender The address which is approved to spend on behalf of the sender.
785   ///@param _value The amount of tokens approve to spend. 
786   function approve(address _spender, uint256 _value) public canTransfer(msg.sender) returns(bool) {
787     require(_spender != address(0), "Invalid address.");
788     return super.approve(_spender, _value);
789   }
790 
791   ///@notice Increases the approval of the spender.
792   ///@dev This function is overridden to leverage transfer state feature.
793   ///@param _spender The address which is approved to spend on behalf of the sender.
794   ///@param _addedValue The added amount of tokens approved to spend.
795   function increaseApproval(address _spender, uint256 _addedValue) public canTransfer(msg.sender) returns(bool) {
796     require(_spender != address(0), "Invalid address.");
797     return super.increaseApproval(_spender, _addedValue);
798   }
799 
800   ///@notice Decreases the approval of the spender.
801   ///@dev This function is overridden to leverage transfer state feature.
802   ///@param _spender The address of the spender to decrease the allocation from.
803   ///@param _subtractedValue The amount of tokens to subtract from the approved allocation.
804   function decreaseApproval(address _spender, uint256 _subtractedValue) public canTransfer(msg.sender) returns(bool) {
805     require(_spender != address(0), "Invalid address.");
806     return super.decreaseApproval(_spender, _subtractedValue);
807   }
808 
809   ///@notice Burns the coins held by the sender.
810   ///@param _value The amount of coins to burn.
811   ///@dev This function is overridden to leverage Pausable feature.
812   function burn(uint256 _value) public whenNotPaused {
813     super.burn(_value);
814   }
815 
816   ///@notice Mints the supplied value of the tokens to the destination address.
817   //Minting cannot be performed any further once the maximum supply is reached.
818   //This function cannot be used by anyone except for this contract.
819   ///@param _to The address which will receive the minted tokens.
820   ///@param _value The amount of tokens to mint.
821   function mintTokens(address _to, uint _value) internal returns(bool) {
822     require(_to != address(0), "Invalid address.");
823     require(totalSupply_.add(_value) <= MAX_SUPPLY, "Sorry but the total supply can't exceed the maximum supply.");
824 
825     balances[_to] = balances[_to].add(_value);
826     totalSupply_ = totalSupply_.add(_value);
827 
828     emit Transfer(address(0), _to, _value);
829     emit Mint(_to, _value);
830 
831     return true;
832   }  
833 }