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
364 
365 
366 
367 /**
368  * @title Ownable
369  * @dev The Ownable contract has an owner address, and provides basic authorization control
370  * functions, this simplifies the implementation of "user permissions".
371  */
372 contract Ownable {
373   address public owner;
374 
375 
376   event OwnershipRenounced(address indexed previousOwner);
377   event OwnershipTransferred(
378     address indexed previousOwner,
379     address indexed newOwner
380   );
381 
382 
383   /**
384    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
385    * account.
386    */
387   constructor() public {
388     owner = msg.sender;
389   }
390 
391   /**
392    * @dev Throws if called by any account other than the owner.
393    */
394   modifier onlyOwner() {
395     require(msg.sender == owner);
396     _;
397   }
398 
399   /**
400    * @dev Allows the current owner to relinquish control of the contract.
401    * @notice Renouncing to ownership will leave the contract without an owner.
402    * It will not be possible to call the functions with the `onlyOwner`
403    * modifier anymore.
404    */
405   function renounceOwnership() public onlyOwner {
406     emit OwnershipRenounced(owner);
407     owner = address(0);
408   }
409 
410   /**
411    * @dev Allows the current owner to transfer control of the contract to a newOwner.
412    * @param _newOwner The address to transfer ownership to.
413    */
414   function transferOwnership(address _newOwner) public onlyOwner {
415     _transferOwnership(_newOwner);
416   }
417 
418   /**
419    * @dev Transfers control of the contract to a newOwner.
420    * @param _newOwner The address to transfer ownership to.
421    */
422   function _transferOwnership(address _newOwner) internal {
423     require(_newOwner != address(0));
424     emit OwnershipTransferred(owner, _newOwner);
425     owner = _newOwner;
426   }
427 }
428 
429 
430 
431 ///@title This contract enables to create multiple contract administrators.
432 contract CustomAdmin is Ownable {
433   ///@notice List of administrators.
434   mapping(address => bool) public admins;
435 
436   event AdminAdded(address indexed _address);
437   event AdminRemoved(address indexed _address);
438 
439   ///@notice Validates if the sender is actually an administrator.
440   modifier onlyAdmin() {
441     require(isAdmin(msg.sender), "Access is denied.");
442     _;
443   }
444 
445   ///@notice Adds the specified address to the list of administrators.
446   ///@param _address The address to add to the administrator list.
447   function addAdmin(address _address) external onlyAdmin returns(bool) {
448     require(_address != address(0), "Invalid address.");
449     require(!admins[_address], "This address is already an administrator.");
450 
451     require(_address != owner, "The owner cannot be added or removed to or from the administrator list.");
452 
453     admins[_address] = true;
454 
455     emit AdminAdded(_address);
456     return true;
457   }
458 
459   ///@notice Adds multiple addresses to the administrator list.
460   ///@param _accounts The wallet addresses to add to the administrator list.
461   function addManyAdmins(address[] _accounts) external onlyAdmin returns(bool) {
462     for(uint8 i = 0; i < _accounts.length; i++) {
463       address account = _accounts[i];
464 
465       ///Zero address cannot be an admin.
466       ///The owner is already an admin and cannot be assigned.
467       ///The address cannot be an existing admin.
468       if(account != address(0) && !admins[account] && account != owner) {
469         admins[account] = true;
470 
471         emit AdminAdded(_accounts[i]);
472       }
473     }
474 
475     return true;
476   }
477 
478   ///@notice Removes the specified address from the list of administrators.
479   ///@param _address The address to remove from the administrator list.
480   function removeAdmin(address _address) external onlyAdmin returns(bool) {
481     require(_address != address(0), "Invalid address.");
482     require(admins[_address], "This address isn't an administrator.");
483 
484     //The owner cannot be removed as admin.
485     require(_address != owner, "The owner cannot be added or removed to or from the administrator list.");
486 
487     admins[_address] = false;
488     emit AdminRemoved(_address);
489     return true;
490   }
491 
492   ///@notice Removes multiple addresses to the administrator list.
493   ///@param _accounts The wallet addresses to add to the administrator list.
494   function removeManyAdmins(address[] _accounts) external onlyAdmin returns(bool) {
495     for(uint8 i = 0; i < _accounts.length; i++) {
496       address account = _accounts[i];
497 
498       ///Zero address can neither be added or removed from this list.
499       ///The owner is the super admin and cannot be removed.
500       ///The address must be an existing admin in order for it to be removed.
501       if(account != address(0) && admins[account] && account != owner) {
502         admins[account] = false;
503 
504         emit AdminRemoved(_accounts[i]);
505       }
506     }
507 
508     return true;
509   }
510 
511   ///@notice Checks if an address is an administrator.
512   function isAdmin(address _address) public view returns(bool) {
513     if(_address == owner) {
514       return true;
515     }
516 
517     return admins[_address];
518   }
519 }
520 
521 
522 
523 ///@title This contract enables you to create pausable mechanism to stop in case of emergency.
524 contract CustomPausable is CustomAdmin {
525   event Paused();
526   event Unpaused();
527 
528   bool public paused = false;
529 
530   ///@notice Verifies whether the contract is not paused.
531   modifier whenNotPaused() {
532     require(!paused, "Sorry but the contract isn't paused.");
533     _;
534   }
535 
536   ///@notice Verifies whether the contract is paused.
537   modifier whenPaused() {
538     require(paused, "Sorry but the contract is paused.");
539     _;
540   }
541 
542   ///@notice Pauses the contract.
543   function pause() external onlyAdmin whenNotPaused {
544     paused = true;
545     emit Paused();
546   }
547 
548   ///@notice Unpauses the contract and returns to normal state.
549   function unpause() external onlyAdmin whenPaused {
550     paused = false;
551     emit Unpaused();
552   }
553 }
554 /*
555 Copyright 2018 Binod Nirvan
556 Licensed under the Apache License, Version 2.0 (the "License");
557 you may not use this file except in compliance with the License.
558 You may obtain a copy of the License at
559     http://www.apache.org/licenses/LICENSE-2.0
560 Unless required by applicable law or agreed to in writing, software
561 distributed under the License is distributed on an "AS IS" BASIS,
562 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
563 See the License for the specific language governing permissions and
564 limitations under the License.
565 */
566 
567 
568 
569 
570 
571 
572 ///@title Transfer State Contract
573 ///@author Binod Nirvan
574 ///@notice Enables the admins to maintain the transfer state.
575 ///Transfer state when disabled disallows everyone but admins to transfer tokens.
576 contract TransferState is CustomPausable {
577   bool public released = false;
578 
579   event TokenReleased(bool _state);
580 
581   ///@notice Checks if the supplied address is able to perform transfers.
582   ///@param _from The address to check against if the transfer is allowed.
583   modifier canTransfer(address _from) {
584     if(paused || !released) {
585       if(!isAdmin(_from)) {
586         revert("Operation not allowed. The transfer state is restricted.");
587       }
588     }
589 
590     _;
591   }
592 
593   ///@notice This function enables token transfers for everyone.
594   ///Can only be enabled after the end of the ICO.
595   function enableTransfers() external onlyAdmin whenNotPaused returns(bool) {
596     require(!released, "Invalid operation. The transfer state is no more restricted.");
597 
598     released = true;
599 
600     emit TokenReleased(released);
601     return true;
602   }
603 
604   ///@notice This function disables token transfers for everyone.
605   function disableTransfers() external onlyAdmin whenNotPaused returns(bool) {
606     require(released, "Invalid operation. The transfer state is already restricted.");
607 
608     released = false;
609 
610     emit TokenReleased(released);
611     return true;
612   }
613 }
614 /*
615 Copyright 2018 Binod Nirvan
616 Licensed under the Apache License, Version 2.0 (the "License");
617 you may not use this file except in compliance with the License.
618 You may obtain a copy of the License at
619     http://www.apache.org/licenses/LICENSE-2.0
620 Unless required by applicable law or agreed to in writing, software
621 distributed under the License is distributed on an "AS IS" BASIS,
622 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
623 See the License for the specific language governing permissions and
624 limitations under the License.
625 */
626 
627 
628 
629 
630 
631 
632 
633 ///@title Bulk Transfer Contract
634 ///@author Binod Nirvan
635 ///@notice This contract provides features for admins to perform bulk transfers.
636 contract BulkTransfer is StandardToken, CustomAdmin {
637   event BulkTransferPerformed(address[] _destinations, uint256[] _amounts);
638 
639   ///@notice Allows only the admins and/or whitelisted applications to perform bulk transfer operation.
640   ///@param _destinations The destination wallet addresses to send funds to.
641   ///@param _amounts The respective amount of fund to send to the specified addresses. 
642   function bulkTransfer(address[] _destinations, uint256[] _amounts) public onlyAdmin returns(bool) {
643     require(_destinations.length == _amounts.length, "Invalid operation.");
644 
645     //Saving gas by determining if the sender has enough balance
646     //to post this transaction.
647     uint256 requiredBalance = sumOf(_amounts);
648     require(balances[msg.sender] >= requiredBalance, "You don't have sufficient funds to transfer amount that large.");
649     
650     for (uint256 i = 0; i < _destinations.length; i++) {
651       transfer(_destinations[i], _amounts[i]);
652     }
653 
654     emit BulkTransferPerformed(_destinations, _amounts);
655     return true;
656   }
657   
658   ///@notice Returns the sum of supplied values.
659   ///@param _values The collection of values to create the sum from.  
660   function sumOf(uint256[] _values) private pure returns(uint256) {
661     uint256 total = 0;
662 
663     for (uint256 i = 0; i < _values.length; i++) {
664       total = total.add(_values[i]);
665     }
666 
667     return total;
668   }
669 }
670 /*
671 Copyright 2018 Binod Nirvan
672 Licensed under the Apache License, Version 2.0 (the "License");
673 you may not use this file except in compliance with the License.
674 You may obtain a copy of the License at
675     http://www.apache.org/licenses/LICENSE-2.0
676 Unless required by applicable law or agreed to in writing, software
677 distributed under the License is distributed on an "AS IS" BASIS,
678 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
679 See the License for the specific language governing permissions and
680 limitations under the License.
681 */
682 
683 
684 
685 
686 
687 
688 
689 
690 
691 
692 /**
693  * @title SafeERC20
694  * @dev Wrappers around ERC20 operations that throw on failure.
695  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
696  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
697  */
698 library SafeERC20 {
699   function safeTransfer(
700     ERC20Basic _token,
701     address _to,
702     uint256 _value
703   )
704     internal
705   {
706     require(_token.transfer(_to, _value));
707   }
708 
709   function safeTransferFrom(
710     ERC20 _token,
711     address _from,
712     address _to,
713     uint256 _value
714   )
715     internal
716   {
717     require(_token.transferFrom(_from, _to, _value));
718   }
719 
720   function safeApprove(
721     ERC20 _token,
722     address _spender,
723     uint256 _value
724   )
725     internal
726   {
727     require(_token.approve(_spender, _value));
728   }
729 }
730 
731 
732 
733 
734 ///@title Reclaimable Contract
735 ///@author Binod Nirvan
736 ///@notice Reclaimable contract enables the administrators 
737 ///to reclaim accidentally sent Ethers and ERC20 token(s)
738 ///to this contract.
739 contract Reclaimable is CustomAdmin {
740   using SafeERC20 for ERC20;
741 
742   ///@notice Transfers all Ether held by the contract to the owner.
743   function reclaimEther() external onlyAdmin {
744     msg.sender.transfer(address(this).balance);
745   }
746 
747   ///@notice Transfers all ERC20 tokens held by the contract to the owner.
748   ///@param _token The amount of token to reclaim.
749   function reclaimToken(address _token) external onlyAdmin {
750     ERC20 erc20 = ERC20(_token);
751     uint256 balance = erc20.balanceOf(this);
752     erc20.safeTransfer(msg.sender, balance);
753   }
754 }
755 
756 
757 ///@title CYBRToken Base Contract
758 ///@author Binod Nirvan
759 ///@notice CYBR Tokens are designed to incentivize and provide 
760 ///functionality for the three-pronged CYBR solution. 
761 ///Subscription services and the provision of blockchain related services 
762 ///will be solely transacted utilizing CYBR Tokens. 
763 ///Rewards for CYBR community members will be a determined allocation of CYBR Tokens. 
764 ///CYBR is a standard ERC20 smart contract-based to- ken running 
765 ///on the Ethereum network and is implemented 
766 ///within the business logic set forth by the Company’s developers.
767 /// 
768 ///The CYBR utility token is redeemable for usage with BlindSpot 
769 ///and global threat intelligence feeds. The CYBR initiative provides 
770 ///protection to individual networks, SMEs and large-scale enterprise users. 
771 ///Intelligence feeds are based on risk scores; packaged in a series of 
772 ///products/services and delivered via a subscription model which can provide:
773 /// 
774 ///- Assessed zero-day global threat feeds o Json, CSV and XML formats 
775 ///  - Utilizing IP tables firewall rules
776 ///  - Magento, Wordpress and related plugins
777 ///- Global threat intelligence reports
778 ///- Email alerts
779 ///- Mobile apps
780 ///- API key to access CYBR via apps/dapps
781 /// 
782 ///Data feeds will be based on number of user licenses, to be purchased 
783 ///on a yearly-based subscription model. Special needs assessments, customized solutions, 
784 ///or any appliance applications can be purchased at an additional cost.
785 /// 
786 ///The CYBR business model is simple: a subscription-based value-added service 
787 ///with recurring revenues. The company has identified a number of ancillary 
788 ///revenue streams, ranging from customized packages to the sale of propriety 
789 ///and modded hardware devices. However, it should be noted that the potent
790 ///solution that is BlindSpot will drive our quest for adoption.
791 contract TokenBase is StandardToken, TransferState, BulkTransfer, Reclaimable, BurnableToken {
792   //solhint-disable
793   uint8 public constant decimals = 18;
794   string public constant name = "CYBR Token";
795   string public constant symbol = "CYBR";
796   //solhint-enable
797 
798   uint256 internal constant MILLION = 1000000 * 1 ether; 
799   uint256 internal constant BILLION = 1000000000 * 1 ether; 
800   uint256 public constant MAX_SUPPLY = 1 * BILLION;
801   uint256 public constant INITIAL_SUPPLY = 510 * MILLION;//51%
802 
803   event Mint(address indexed to, uint256 amount);
804 
805   constructor() public {
806     mintTokens(msg.sender, INITIAL_SUPPLY);
807   }
808 
809   ///@notice Transfers the specified value of CYBR tokens to the destination address. 
810   //Transfers can only happen when the transfer state is enabled. 
811   //Transfer state can only be enabled after the end of the crowdsale.
812   ///@param _to The destination wallet address to transfer funds to.
813   ///@param _value The amount of tokens to send to the destination address.
814   function transfer(address _to, uint256 _value) public canTransfer(msg.sender) returns(bool) {
815     require(_to != address(0), "Invalid address.");
816     return super.transfer(_to, _value);
817   }
818 
819   ///@notice Transfers tokens from a specified wallet address.
820   ///@dev This function is overridden to leverage transfer state feature.
821   ///@param _from The address to transfer funds from.
822   ///@param _to The address to transfer funds to.
823   ///@param _value The amount of tokens to transfer.
824   function transferFrom(address _from, address _to, uint256 _value) public canTransfer(_from) returns(bool) {
825     require(_to != address(0), "Invalid address.");
826     return super.transferFrom(_from, _to, _value);
827   }
828 
829   ///@notice Approves a wallet address to spend on behalf of the sender.
830   ///@dev This function is overridden to leverage transfer state feature.
831   ///@param _spender The address which is approved to spend on behalf of the sender.
832   ///@param _value The amount of tokens approve to spend. 
833   function approve(address _spender, uint256 _value) public canTransfer(msg.sender) returns(bool) {
834     require(_spender != address(0), "Invalid address.");
835     return super.approve(_spender, _value);
836   }
837 
838   ///@notice Increases the approval of the spender.
839   ///@dev This function is overridden to leverage transfer state feature.
840   ///@param _spender The address which is approved to spend on behalf of the sender.
841   ///@param _addedValue The added amount of tokens approved to spend.
842   function increaseApproval(address _spender, uint256 _addedValue) public canTransfer(msg.sender) returns(bool) {
843     require(_spender != address(0), "Invalid address.");
844     return super.increaseApproval(_spender, _addedValue);
845   }
846 
847   ///@notice Decreases the approval of the spender.
848   ///@dev This function is overridden to leverage transfer state feature.
849   ///@param _spender The address of the spender to decrease the allocation from.
850   ///@param _subtractedValue The amount of tokens to subtract from the approved allocation.
851   function decreaseApproval(address _spender, uint256 _subtractedValue) public canTransfer(msg.sender) returns(bool) {
852     require(_spender != address(0), "Invalid address.");
853     return super.decreaseApproval(_spender, _subtractedValue);
854   }
855   
856   ///@notice Burns the coins held by the sender.
857   ///@param _value The amount of coins to burn.
858   ///@dev This function is overridden to leverage Pausable feature.
859   function burn(uint256 _value) public whenNotPaused {
860     super.burn(_value);
861   }
862 
863   ///@notice Mints the supplied value of the tokens to the destination address.
864   //Minting cannot be performed any further once the maximum supply is reached.
865   //This function cannot be used by anyone except for this contract.
866   ///@param _to The address which will receive the minted tokens.
867   ///@param _value The amount of tokens to mint.
868   function mintTokens(address _to, uint _value) internal returns(bool) {
869     require(_to != address(0), "Invalid address.");
870     require(totalSupply_.add(_value) <= MAX_SUPPLY, "Sorry but the total supply can't exceed the maximum supply.");
871 
872     balances[_to] = balances[_to].add(_value);
873     totalSupply_ = totalSupply_.add(_value);
874 
875     emit Transfer(address(0), _to, _value);
876     emit Mint(_to, _value);
877 
878     return true;
879   }
880 }
881 
882 
883 ///@title CYBR Token
884 ///@author Binod Nirvan
885 ///@notice CYBR Tokens are designed to incentivize and provide 
886 ///functionality for the three-pronged CYBR solution. 
887 ///Subscription services and the provision of blockchain related services 
888 ///will be solely transacted utilizing CYBR Tokens. 
889 ///Rewards for CYBR community members will be a determined allocation of CYBR Tokens. 
890 ///CYBR is a standard ERC20 smart contract-based to- ken running 
891 ///on the Ethereum network and is implemented 
892 ///within the business logic set forth by the Company’s developers.
893 /// 
894 ///The CYBR utility token is redeemable for usage with BlindSpot 
895 ///and global threat intelligence feeds. The CYBR initiative provides 
896 ///protection to individual networks, SMEs and large-scale enterprise users. 
897 ///Intelligence feeds are based on risk scores; packaged in a series of 
898 ///products/services and delivered via a subscription model which can provide:
899 /// 
900 ///- Assessed zero-day global threat feeds o Json, CSV and XML formats 
901 ///  - Utilizing IP tables firewall rules
902 ///  - Magento, Wordpress and related plugins
903 ///- Global threat intelligence reports
904 ///- Email alerts
905   ///- Mobile apps
906 ///- API key to access CYBR via apps/dapps
907 /// 
908 ///Data feeds will be based on number of user licenses, to be purchased 
909 ///on a yearly-based subscription model. Special needs assessments, customized solutions, 
910 ///or any appliance applications can be purchased at an additional cost.
911 /// 
912 ///The CYBR business model is simple: a subscription-based value-added service 
913 ///with recurring revenues. The company has identified a number of ancillary 
914 ///revenue streams, ranging from customized packages to the sale of propriety 
915 ///and modded hardware devices. However, it should be noted that the potent
916 ///solution that is BlindSpot will drive our quest for adoption.
917 contract CYBRToken is TokenBase {
918   //solhint-disable not-rely-on-time
919   //solium-disable security/no-block-members
920 
921   uint256 public icoEndDate;
922 
923   uint256 public constant ALLOCATION_FOR_FOUNDERS = 100 * MILLION;//10%
924   uint256 public constant ALLOCATION_FOR_TEAM = 100 * MILLION;//10%
925   uint256 public constant ALLOCATION_FOR_RESERVE = 100 * MILLION;//10%
926   uint256 public constant ALLOCATION_FOR_INITIAL_PARTNERSHIPS = 50 * MILLION;//5%
927   uint256 public constant ALLOCATION_FOR_PARTNERSHIPS = 50 * MILLION;//5%
928   uint256 public constant ALLOCATION_FOR_ADVISORS = 60 * MILLION;//6%
929   uint256 public constant ALLOCATION_FOR_PROMOTION = 30 * MILLION;//3%
930 
931   bool public targetReached = false;
932 
933   mapping(bytes32 => bool) private mintingList;
934 
935   event ICOEndDateSet(uint256 _date);
936   event TargetReached();
937 
938   ///@notice Checks if the minting for the supplied key was already performed.
939   ///@param _key The key or category name of minting.
940   modifier whenNotMinted(string _key) {
941     if(mintingList[computeHash(_key)]) {
942       revert("Duplicate minting key supplied.");
943     }
944 
945     _;
946   }
947 
948   ///@notice This function signifies that the minimum fundraising target was met.
949   ///Please note that this can only be called once.
950   function setSuccess() external onlyAdmin returns(bool) {
951     require(!targetReached, "Access is denied.");
952     targetReached = true;
953 
954     emit TargetReached();
955   }
956 
957   ///@notice This function enables the whitelisted application (internal application) to set the 
958   /// ICO end date and can only be used once.
959   ///@param _date The date to set as the ICO end date.
960   function setICOEndDate(uint _date) external onlyAdmin returns(bool) {
961     require(icoEndDate == 0, "The ICO end date was already set.");
962 
963     icoEndDate = _date;
964     
965     emit ICOEndDateSet(_date);
966     return true;
967   }
968 
969   ///@notice Mints the 100 million CYBR tokens allocated to the CYBRToken founders.
970   //The tokens are only available to the founders after 18 months of the ICO end.
971   function mintTokensForFounders() external onlyAdmin returns(bool) {
972     require(targetReached, "Sorry, you can't mint at this time because the target hasn't been reached yet.");
973     require(icoEndDate != 0, "You need to specify the ICO end date before minting the tokens.");
974     require(now > (icoEndDate + 548 days), "Access is denied, it's too early to mint founder tokens.");
975 
976     return mintOnce("founders", msg.sender, ALLOCATION_FOR_FOUNDERS);
977   }
978 
979   ///@notice Mints 100 million CYBR tokens allocated to the CYBRToken team.
980   //The tokens are only available to the founders after 1 year of the ICO end.
981   function mintTokensForTeam() external onlyAdmin returns(bool) {
982     require(targetReached, "Sorry, you can't mint at this time because the target hasn't been reached yet.");
983     require(icoEndDate != 0, "You need to specify the ICO end date before minting the tokens.");
984     require(now > (icoEndDate + 365 days), "Access is denied, it's too early to mint team tokens.");
985 
986     return mintOnce("team", msg.sender, ALLOCATION_FOR_TEAM);
987   }
988 
989   ///@notice Mints the 100 million CYBR tokens allocated to the operational reserves.
990   //The tokens are only available in the reserves after 1 year of the ICO end.
991   function mintReserveTokens() external onlyAdmin returns(bool) {
992     require(targetReached, "Sorry, you can't mint at this time because the target hasn't been reached yet.");
993     require(icoEndDate != 0, "You need to specify the ICO end date before minting the tokens.");
994     require(now > (icoEndDate + 365 days), "Access is denied, it's too early to mint the reserve tokens.");
995 
996     return mintOnce("reserve", msg.sender, ALLOCATION_FOR_RESERVE);
997   }
998 
999   ///@notice Mints the 50 million tokens allocated for initial partnerships.
1000   //The tokens are only available to the partners after 6 months of the ICO end.
1001   function mintTokensForInitialPartnerships() external onlyAdmin returns(bool) {
1002     return mintOnce("initialPartnerships", msg.sender, ALLOCATION_FOR_INITIAL_PARTNERSHIPS);
1003   }
1004 
1005   ///@notice Mints the 50 million tokens allocated for partnerships.
1006   //The tokens are only available to the partners after 6 months of the ICO end.
1007   function mintTokensForPartnerships() external onlyAdmin returns(bool) {
1008     require(targetReached, "Sorry, you can't mint at this time because the target hasn't been reached yet.");
1009     require(icoEndDate != 0, "You need to specify the ICO end date before minting the tokens.");
1010     require(now > (icoEndDate + 182 days), "Access is denied, it's too early to mint the partnership tokens.");
1011 
1012     return mintOnce("partnerships", msg.sender, ALLOCATION_FOR_PARTNERSHIPS);
1013   }
1014 
1015   ///@notice Mints the 60 million tokens allocated to the CYBRToken advisors.
1016   //The tokens are only available to the advisors after 1 year of the ICO end.
1017   function mintTokensForAdvisors() external onlyAdmin returns(bool) {
1018     require(targetReached, "Sorry, you can't mint at this time because the target hasn't been reached yet.");
1019     require(icoEndDate != 0, "You need to specify the ICO end date before minting the tokens.");
1020     require(now > (icoEndDate + 365 days), "Access is denied, it's too early to mint advisory tokens.");
1021 
1022     return mintOnce("advisors", msg.sender, ALLOCATION_FOR_ADVISORS);
1023   }
1024 
1025   ///@notice Mints the 30 million CYBR tokens allocated to promotion.
1026   //The tokens are available at the end of the ICO.
1027   function mintTokensForPromotion() external onlyAdmin returns(bool) {
1028     require(targetReached, "Sorry, you can't mint at this time because the target hasn't been reached yet.");
1029     require(icoEndDate != 0, "You need to specify the ICO end date before minting the tokens.");
1030     require(now > icoEndDate, "Access is denied, it's too early to mint the promotion tokens.");
1031 
1032     return mintOnce("promotion", msg.sender, ALLOCATION_FOR_PROMOTION);
1033   }
1034 
1035   ///@notice Computes keccak256 hash of the supplied value.
1036   ///@param _key The string value to compute hash from.
1037   function computeHash(string _key) private pure returns(bytes32) {
1038     return keccak256(abi.encodePacked(_key));
1039   }
1040 
1041   ///@notice Mints the tokens only once against the supplied key (category).
1042   ///@param _key The key or the category of the allocation to mint the tokens for.
1043   ///@param _to The address receiving the minted tokens.
1044   ///@param _amount The amount of tokens to mint.
1045   function mintOnce(string _key, address _to, uint256 _amount) private whenNotPaused whenNotMinted(_key) returns(bool) {
1046     mintingList[computeHash(_key)] = true;
1047     return mintTokens(_to, _amount);
1048   }
1049 }