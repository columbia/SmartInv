1 pragma solidity 0.4.24;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9   /**
10   * @dev Multiplies two numbers, throws on overflow.
11   */
12   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
13     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
14     // benefit is lost if 'b' is also tested.
15     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
16     if (_a == 0) {
17       return 0;
18     }
19 
20     c = _a * _b;
21     assert(c / _a == _b);
22     return c;
23   }
24 
25   /**
26   * @dev Integer division of two numbers, truncating the quotient.
27   */
28   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
29     // assert(_b > 0); // Solidity automatically throws when dividing by 0
30     // uint256 c = _a / _b;
31     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
32     return _a / _b;
33   }
34 
35   /**
36   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
37   */
38   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
39     assert(_b <= _a);
40     return _a - _b;
41   }
42 
43   /**
44   * @dev Adds two numbers, throws on overflow.
45   */
46   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
47     c = _a + _b;
48     assert(c >= _a);
49     return c;
50   }
51 }
52 
53 /**
54  * @title Ownable
55  * @dev The Ownable contract has an owner address, and provides basic authorization control
56  * functions, this simplifies the implementation of "user permissions".
57  */
58 contract Ownable {
59   address public owner;
60 
61 
62   event OwnershipRenounced(address indexed previousOwner);
63   event OwnershipTransferred(
64     address indexed previousOwner,
65     address indexed newOwner
66   );
67 
68 
69   /**
70    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
71    * account.
72    */
73   constructor() public {
74     owner = msg.sender;
75   }
76 
77   /**
78    * @dev Throws if called by any account other than the owner.
79    */
80   modifier onlyOwner() {
81     require(msg.sender == owner);
82     _;
83   }
84 
85   /**
86    * @dev Allows the current owner to relinquish control of the contract.
87    * @notice Renouncing to ownership will leave the contract without an owner.
88    * It will not be possible to call the functions with the `onlyOwner`
89    * modifier anymore.
90    */
91   function renounceOwnership() public onlyOwner {
92     emit OwnershipRenounced(owner);
93     owner = address(0);
94   }
95 
96   /**
97    * @dev Allows the current owner to transfer control of the contract to a newOwner.
98    * @param _newOwner The address to transfer ownership to.
99    */
100   function transferOwnership(address _newOwner) public onlyOwner {
101     _transferOwnership(_newOwner);
102   }
103 
104   /**
105    * @dev Transfers control of the contract to a newOwner.
106    * @param _newOwner The address to transfer ownership to.
107    */
108   function _transferOwnership(address _newOwner) internal {
109     require(_newOwner != address(0));
110     emit OwnershipTransferred(owner, _newOwner);
111     owner = _newOwner;
112   }
113 }
114 
115 /**
116  * @title ERC20Basic
117  * @dev Simpler version of ERC20 interface
118  * See https://github.com/ethereum/EIPs/issues/179
119  */
120 contract ERC20Basic {
121   function totalSupply() public view returns (uint256);
122   function balanceOf(address _who) public view returns (uint256);
123   function transfer(address _to, uint256 _value) public returns (bool);
124   event Transfer(address indexed from, address indexed to, uint256 value);
125 }
126 
127 /**
128  * @title ERC20 interface
129  * @dev see https://github.com/ethereum/EIPs/issues/20
130  */
131 contract ERC20 is ERC20Basic {
132   function allowance(address _owner, address _spender)
133     public view returns (uint256);
134 
135   function transferFrom(address _from, address _to, uint256 _value)
136     public returns (bool);
137 
138   function approve(address _spender, uint256 _value) public returns (bool);
139   event Approval(
140     address indexed owner,
141     address indexed spender,
142     uint256 value
143   );
144 }
145 
146 /**
147  * @title SafeERC20
148  * @dev Wrappers around ERC20 operations that throw on failure.
149  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
150  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
151  */
152 library SafeERC20 {
153   function safeTransfer(
154     ERC20Basic _token,
155     address _to,
156     uint256 _value
157   )
158     internal
159   {
160     require(_token.transfer(_to, _value));
161   }
162 
163   function safeTransferFrom(
164     ERC20 _token,
165     address _from,
166     address _to,
167     uint256 _value
168   )
169     internal
170   {
171     require(_token.transferFrom(_from, _to, _value));
172   }
173 
174   function safeApprove(
175     ERC20 _token,
176     address _spender,
177     uint256 _value
178   )
179     internal
180   {
181     require(_token.approve(_spender, _value));
182   }
183 }
184 
185 /**
186  * @title Crowdsale
187  * @dev Crowdsale is a base contract for managing a token crowdsale,
188  * allowing investors to purchase tokens with ether. This contract implements
189  * such functionality in its most fundamental form and can be extended to provide additional
190  * functionality and/or custom behavior.
191  * The external interface represents the basic interface for purchasing tokens, and conform
192  * the base architecture for crowdsales. They are *not* intended to be modified / overridden.
193  * The internal interface conforms the extensible and modifiable surface of crowdsales. Override
194  * the methods to add functionality. Consider using 'super' where appropriate to concatenate
195  * behavior.
196  */
197 contract Crowdsale {
198   using SafeMath for uint256;
199   using SafeERC20 for ERC20;
200 
201   // The token being sold
202   ERC20 public token;
203 
204   // Address where funds are collected
205   address public wallet;
206 
207   // How many token units a buyer gets per wei.
208   // The rate is the conversion between wei and the smallest and indivisible token unit.
209   // So, if you are using a rate of 1 with a DetailedERC20 token with 3 decimals called TOK
210   // 1 wei will give you 1 unit, or 0.001 TOK.
211   uint256 public rate;
212 
213   // Amount of wei raised
214   uint256 public weiRaised;
215 
216   /**
217    * Event for token purchase logging
218    * @param purchaser who paid for the tokens
219    * @param beneficiary who got the tokens
220    * @param value weis paid for purchase
221    * @param amount amount of tokens purchased
222    */
223   event TokenPurchase(
224     address indexed purchaser,
225     address indexed beneficiary,
226     uint256 value,
227     uint256 amount
228   );
229 
230   /**
231    * @param _rate Number of token units a buyer gets per wei
232    * @param _wallet Address where collected funds will be forwarded to
233    * @param _token Address of the token being sold
234    */
235   constructor(uint256 _rate, address _wallet, ERC20 _token) public {
236     require(_rate > 0);
237     require(_wallet != address(0));
238     require(_token != address(0));
239 
240     rate = _rate;
241     wallet = _wallet;
242     token = _token;
243   }
244 
245   // -----------------------------------------
246   // Crowdsale external interface
247   // -----------------------------------------
248 
249   /**
250    * @dev fallback function ***DO NOT OVERRIDE***
251    */
252   function () external payable {
253     buyTokens(msg.sender);
254   }
255 
256   /**
257    * @dev low level token purchase ***DO NOT OVERRIDE***
258    * @param _beneficiary Address performing the token purchase
259    */
260   function buyTokens(address _beneficiary) public payable {
261 
262     uint256 weiAmount = msg.value;
263     _preValidatePurchase(_beneficiary, weiAmount);
264 
265     // calculate token amount to be created
266     uint256 tokens = _getTokenAmount(weiAmount);
267 
268     // update state
269     weiRaised = weiRaised.add(weiAmount);
270 
271     _processPurchase(_beneficiary, tokens);
272     emit TokenPurchase(
273       msg.sender,
274       _beneficiary,
275       weiAmount,
276       tokens
277     );
278 
279     _updatePurchasingState(_beneficiary, weiAmount);
280 
281     _forwardFunds();
282     _postValidatePurchase(_beneficiary, weiAmount);
283   }
284 
285   // -----------------------------------------
286   // Internal interface (extensible)
287   // -----------------------------------------
288 
289   /**
290    * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met. Use `super` in contracts that inherit from Crowdsale to extend their validations.
291    * Example from CappedCrowdsale.sol's _preValidatePurchase method: 
292    *   super._preValidatePurchase(_beneficiary, _weiAmount);
293    *   require(weiRaised.add(_weiAmount) <= cap);
294    * @param _beneficiary Address performing the token purchase
295    * @param _weiAmount Value in wei involved in the purchase
296    */
297   function _preValidatePurchase(
298     address _beneficiary,
299     uint256 _weiAmount
300   )
301     internal
302   {
303     require(_beneficiary != address(0));
304     require(_weiAmount != 0);
305   }
306 
307   /**
308    * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid conditions are not met.
309    * @param _beneficiary Address performing the token purchase
310    * @param _weiAmount Value in wei involved in the purchase
311    */
312   function _postValidatePurchase(
313     address _beneficiary,
314     uint256 _weiAmount
315   )
316     internal
317   {
318     // optional override
319   }
320 
321   /**
322    * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
323    * @param _beneficiary Address performing the token purchase
324    * @param _tokenAmount Number of tokens to be emitted
325    */
326   function _deliverTokens(
327     address _beneficiary,
328     uint256 _tokenAmount
329   )
330     internal
331   {
332     token.safeTransfer(_beneficiary, _tokenAmount);
333   }
334 
335   /**
336    * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
337    * @param _beneficiary Address receiving the tokens
338    * @param _tokenAmount Number of tokens to be purchased
339    */
340   function _processPurchase(
341     address _beneficiary,
342     uint256 _tokenAmount
343   )
344     internal
345   {
346     _deliverTokens(_beneficiary, _tokenAmount);
347   }
348 
349   /**
350    * @dev Override for extensions that require an internal state to check for validity (current user contributions, etc.)
351    * @param _beneficiary Address receiving the tokens
352    * @param _weiAmount Value in wei involved in the purchase
353    */
354   function _updatePurchasingState(
355     address _beneficiary,
356     uint256 _weiAmount
357   )
358     internal
359   {
360     // optional override
361   }
362 
363   /**
364    * @dev Override to extend the way in which ether is converted to tokens.
365    * @param _weiAmount Value in wei to be converted into tokens
366    * @return Number of tokens that can be purchased with the specified _weiAmount
367    */
368   function _getTokenAmount(uint256 _weiAmount)
369     internal view returns (uint256)
370   {
371     return _weiAmount.mul(rate);
372   }
373 
374   /**
375    * @dev Determines how ETH is stored/forwarded on purchases.
376    */
377   function _forwardFunds() internal {
378     wallet.transfer(msg.value);
379   }
380 }
381 
382 /**
383  * @title TimedCrowdsale
384  * @dev Crowdsale accepting contributions only within a time frame.
385  */
386 contract TimedCrowdsale is Crowdsale {
387   using SafeMath for uint256;
388 
389   uint256 public openingTime;
390   uint256 public closingTime;
391 
392   /**
393    * @dev Reverts if not in crowdsale time range.
394    */
395   modifier onlyWhileOpen {
396     // solium-disable-next-line security/no-block-members
397     require(block.timestamp >= openingTime && block.timestamp <= closingTime);
398     _;
399   }
400 
401   /**
402    * @dev Constructor, takes crowdsale opening and closing times.
403    * @param _openingTime Crowdsale opening time
404    * @param _closingTime Crowdsale closing time
405    */
406   constructor(uint256 _openingTime, uint256 _closingTime) public {
407     // solium-disable-next-line security/no-block-members
408     require(_openingTime >= block.timestamp);
409     require(_closingTime >= _openingTime);
410 
411     openingTime = _openingTime;
412     closingTime = _closingTime;
413   }
414 
415   /**
416    * @dev Checks whether the period in which the crowdsale is open has already elapsed.
417    * @return Whether crowdsale period has elapsed
418    */
419   function hasClosed() public view returns (bool) {
420     // solium-disable-next-line security/no-block-members
421     return block.timestamp > closingTime;
422   }
423 
424   /**
425    * @dev Extend parent behavior requiring to be within contributing period
426    * @param _beneficiary Token purchaser
427    * @param _weiAmount Amount of wei contributed
428    */
429   function _preValidatePurchase(
430     address _beneficiary,
431     uint256 _weiAmount
432   )
433     internal
434     onlyWhileOpen
435   {
436     super._preValidatePurchase(_beneficiary, _weiAmount);
437   }
438 
439 }
440 
441 /**
442  * @title FinalizableCrowdsale
443  * @dev Extension of Crowdsale where an owner can do extra work
444  * after finishing.
445  */
446 contract FinalizableCrowdsale is Ownable, TimedCrowdsale {
447   using SafeMath for uint256;
448 
449   bool public isFinalized = false;
450 
451   event Finalized();
452 
453   /**
454    * @dev Must be called after crowdsale ends, to do some extra finalization
455    * work. Calls the contract's finalization function.
456    */
457   function finalize() public onlyOwner {
458     require(!isFinalized);
459     require(hasClosed());
460 
461     finalization();
462     emit Finalized();
463 
464     isFinalized = true;
465   }
466 
467   /**
468    * @dev Can be overridden to add finalization logic. The overriding function
469    * should call super.finalization() to ensure the chain of finalization is
470    * executed entirely.
471    */
472   function finalization() internal {
473   }
474 
475 }
476 
477 /*
478 Copyright 2018 Binod Nirvan
479 
480 Licensed under the Apache License, Version 2.0 (the "License");
481 you may not use this file except in compliance with the License.
482 You may obtain a copy of the License at
483 
484     http://www.apache.org/licenses/LICENSE-2.0
485 
486 Unless required by applicable law or agreed to in writing, software
487 distributed under the License is distributed on an "AS IS" BASIS,
488 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
489 See the License for the specific language governing permissions and
490 limitations under the License.
491  */
492 
493 
494 
495 
496 
497 ///@title This contract enables to create multiple contract administrators.
498 contract CustomAdmin is Ownable {
499   ///@notice List of administrators.
500   mapping(address => bool) public admins;
501 
502   event AdminAdded(address indexed _address);
503   event AdminRemoved(address indexed _address);
504 
505   ///@notice Validates if the sender is actually an administrator.
506   modifier onlyAdmin() {
507     require(admins[msg.sender] || msg.sender == owner);
508     _;
509   }
510 
511   ///@notice Adds the specified address to the list of administrators.
512   ///@param _address The address to add to the administrator list.
513   function addAdmin(address _address) external onlyAdmin {
514     require(_address != address(0));
515     require(!admins[_address]);
516 
517     //The owner is already an admin and cannot be added.
518     require(_address != owner);
519 
520     admins[_address] = true;
521 
522     emit AdminAdded(_address);
523   }
524 
525   ///@notice Adds multiple addresses to the administrator list.
526   ///@param _accounts The wallet addresses to add to the administrator list.
527   function addManyAdmins(address[] _accounts) external onlyAdmin {
528     for(uint8 i=0; i<_accounts.length; i++) {
529       address account = _accounts[i];
530 
531       ///Zero address cannot be an admin.
532       ///The owner is already an admin and cannot be assigned.
533       ///The address cannot be an existing admin.
534       if(account != address(0) && !admins[account] && account != owner){
535         admins[account] = true;
536 
537         emit AdminAdded(_accounts[i]);
538       }
539     }
540   }
541   
542   ///@notice Removes the specified address from the list of administrators.
543   ///@param _address The address to remove from the administrator list.
544   function removeAdmin(address _address) external onlyAdmin {
545     require(_address != address(0));
546     require(admins[_address]);
547 
548     //The owner cannot be removed as admin.
549     require(_address != owner);
550 
551     admins[_address] = false;
552     emit AdminRemoved(_address);
553   }
554 
555 
556   ///@notice Removes multiple addresses to the administrator list.
557   ///@param _accounts The wallet addresses to remove from the administrator list.
558   function removeManyAdmins(address[] _accounts) external onlyAdmin {
559     for(uint8 i=0; i<_accounts.length; i++) {
560       address account = _accounts[i];
561 
562       ///Zero address can neither be added or removed from this list.
563       ///The owner is the super admin and cannot be removed.
564       ///The address must be an existing admin in order for it to be removed.
565       if(account != address(0) && admins[account] && account != owner){
566         admins[account] = false;
567 
568         emit AdminRemoved(_accounts[i]);
569       }
570     }
571   }
572 }
573 
574 /*
575 Copyright 2018 Binod Nirvan
576 
577 Licensed under the Apache License, Version 2.0 (the "License");
578 you may not use this file except in compliance with the License.
579 You may obtain a copy of the License at
580 
581     http://www.apache.org/licenses/LICENSE-2.0
582 
583 Unless required by applicable law or agreed to in writing, software
584 distributed under the License is distributed on an "AS IS" BASIS,
585 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
586 See the License for the specific language governing permissions and
587 limitations under the License.
588  */
589 
590 
591  
592 
593 
594 
595 
596 
597 ///@title This contract enables you to create pausable mechanism to stop in case of emergency.
598 contract CustomPausable is CustomAdmin {
599   event Paused();
600   event Unpaused();
601 
602   bool public paused = false;
603 
604   ///@notice Verifies whether the contract is not paused.
605   modifier whenNotPaused() {
606     require(!paused);
607     _;
608   }
609 
610   ///@notice Verifies whether the contract is paused.
611   modifier whenPaused() {
612     require(paused);
613     _;
614   }
615 
616   ///@notice Pauses the contract.
617   function pause() external onlyAdmin whenNotPaused {
618     paused = true;
619     emit Paused();
620   }
621 
622   ///@notice Unpauses the contract and returns to normal state.
623   function unpause() external onlyAdmin whenPaused {
624     paused = false;
625     emit Unpaused();
626   }
627 }
628 
629 /*
630 Copyright 2018 Binod Nirvan
631 
632 Licensed under the Apache License, Version 2.0 (the "License");
633 you may not use this file except in compliance with the License.
634 You may obtain a copy of the License at
635 
636     http://www.apache.org/licenses/LICENSE-2.0
637 
638 Unless required by applicable law or agreed to in writing, software
639 distributed under the License is distributed on an "AS IS" BASIS,
640 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
641 See the License for the specific language governing permissions and
642 limitations under the License.
643  */
644 
645 
646 
647 
648 ///@title This contract enables to maintain a list of whitelisted wallets.
649 contract CustomWhitelist is CustomPausable {
650   mapping(address => bool) public whitelist;
651 
652   event WhitelistAdded(address indexed _account);
653   event WhitelistRemoved(address indexed _account);
654 
655   ///@notice Verifies if the account is whitelisted.
656   modifier ifWhitelisted(address _account) {
657     require(_account != address(0));
658     require(whitelist[_account]);
659 
660     _;
661   }
662 
663   ///@notice Adds an account to the whitelist.
664   ///@param _account The wallet address to add to the whitelist.
665   function addWhitelist(address _account) external whenNotPaused onlyAdmin {
666     require(_account!=address(0));
667 
668     if(!whitelist[_account]) {
669       whitelist[_account] = true;
670 
671       emit WhitelistAdded(_account);
672     }
673   }
674 
675   ///@notice Adds multiple accounts to the whitelist.
676   ///@param _accounts The wallet addresses to add to the whitelist.
677   function addManyWhitelist(address[] _accounts) external whenNotPaused onlyAdmin {
678     for(uint8 i=0;i<_accounts.length;i++) {
679       if(_accounts[i] != address(0) && !whitelist[_accounts[i]]) {
680         whitelist[_accounts[i]] = true;
681 
682         emit WhitelistAdded(_accounts[i]);
683       }
684     }
685   }
686 
687   ///@notice Removes an account from the whitelist.
688   ///@param _account The wallet address to remove from the whitelist.
689   function removeWhitelist(address _account) external whenNotPaused onlyAdmin {
690     require(_account != address(0));
691     if(whitelist[_account]) {
692       whitelist[_account] = false;
693 
694       emit WhitelistRemoved(_account);
695     }
696   }
697 
698   ///@notice Removes multiple accounts from the whitelist.
699   ///@param _accounts The wallet addresses to remove from the whitelist.
700   function removeManyWhitelist(address[] _accounts) external whenNotPaused onlyAdmin {
701     for(uint8 i=0;i<_accounts.length;i++) {
702       if(_accounts[i] != address(0) && whitelist[_accounts[i]]) {
703         whitelist[_accounts[i]] = false;
704         
705         emit WhitelistRemoved(_accounts[i]);
706       }
707     }
708   }
709 }
710 
711 /*
712 Copyright 2018 Binod Nirvan, Subramanian Venkatesan
713 
714 Licensed under the Apache License, Version 2.0 (the "License");
715 you may not use this file except in compliance with the License.
716 You may obtain a copy of the License at
717 
718     http://www.apache.org/licenses/LICENSE-2.0
719 
720 Unless required by applicable law or agreed to in writing, software
721 distributed under the License is distributed on an "AS IS" BASIS,
722 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
723 See the License for the specific language governing permissions and
724 limitations under the License.
725 */
726 
727 
728 
729 
730 ///@title This contract keeps track of the VRH token price.
731 contract TokenPrice is CustomPausable {
732   ///@notice The price per token in cents.
733   uint256 public tokenPriceInCents;
734 
735   event TokenPriceChanged(uint256 _newPrice, uint256 _oldPrice);
736 
737   function setTokenPrice(uint256 _cents) public onlyAdmin whenNotPaused {
738     require(_cents > 0);
739     
740     emit TokenPriceChanged(_cents, tokenPriceInCents );
741     tokenPriceInCents  = _cents;
742   }
743 }
744 
745 /*
746 Copyright 2018 Binod Nirvan, Subramanian Venkatesan
747 
748 Licensed under the Apache License, Version 2.0 (the "License");
749 you may not use this file except in compliance with the License.
750 You may obtain a copy of the License at
751 
752     http://www.apache.org/licenses/LICENSE-2.0
753 
754 Unless required by applicable law or agreed to in writing, software
755 distributed under the License is distributed on an "AS IS" BASIS,
756 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
757 See the License for the specific language governing permissions and
758 limitations under the License.
759 */
760 
761 
762 
763 
764 ///@title This contract keeps track of Ether price.
765 contract EtherPrice is CustomPausable {
766   uint256 public etherPriceInCents; //price of 1 ETH in cents
767 
768   event EtherPriceChanged(uint256 _newPrice, uint256 _oldPrice);
769 
770   function setEtherPrice(uint256 _cents) public whenNotPaused onlyAdmin {
771     require(_cents > 0);
772 
773     emit EtherPriceChanged(_cents, etherPriceInCents);
774     etherPriceInCents = _cents;
775   }
776 }
777 
778 /*
779 Copyright 2018 Binod Nirvan, Subramanian Venkatesan
780 
781 Licensed under the Apache License, Version 2.0 (the "License");
782 you may not use this file except in compliance with the License.
783 You may obtain a copy of the License at
784 
785     http://www.apache.org/licenses/LICENSE-2.0
786 
787 Unless required by applicable law or agreed to in writing, software
788 distributed under the License is distributed on an "AS IS" BASIS,
789 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
790 See the License for the specific language governing permissions and
791 limitations under the License.
792  */
793 
794  
795 
796 
797 ///@title This contract keeps track of Binance Coin price.
798 contract BinanceCoinPrice is CustomPausable {
799   uint256 public binanceCoinPriceInCents;
800 
801   event BinanceCoinPriceChanged(uint256 _newPrice, uint256 _oldPrice);
802 
803   function setBinanceCoinPrice(uint256 _cents) public whenNotPaused onlyAdmin {
804     require(_cents > 0);
805 
806     emit BinanceCoinPriceChanged(_cents, binanceCoinPriceInCents);
807     binanceCoinPriceInCents = _cents;
808   }
809 }
810 
811 /*
812 Copyright 2018 Binod Nirvan, Subramanian Venkatesan
813 
814 Licensed under the Apache License, Version 2.0 (the "License");
815 you may not use this file except in compliance with the License.
816 You may obtain a copy of the License at
817 
818     http://www.apache.org/licenses/LICENSE-2.0
819 
820 Unless required by applicable law or agreed to in writing, software
821 distributed under the License is distributed on an "AS IS" BASIS,
822 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
823 See the License for the specific language governing permissions and
824 limitations under the License.
825  */
826 
827  
828 
829 
830 ///@title This contract keeps track of Credits Token price.
831 contract CreditsTokenPrice is CustomPausable {
832   uint256 public creditsTokenPriceInCents;
833 
834   event CreditsTokenPriceChanged(uint256 _newPrice, uint256 _oldPrice);
835 
836   function setCreditsTokenPrice(uint256 _cents) public whenNotPaused onlyAdmin {
837     require(_cents > 0);
838 
839     emit CreditsTokenPriceChanged(_cents, creditsTokenPriceInCents);
840     creditsTokenPriceInCents = _cents;
841   }
842 }
843 
844 /*
845 Copyright 2018 Binod Nirvan, Subramanian Venkatesan
846 
847 Licensed under the Apache License, Version 2.0 (the "License");
848 you may not use this file except in compliance with the License.
849 You may obtain a copy of the License at
850 
851     http://www.apache.org/licenses/LICENSE-2.0
852 
853 Unless required by applicable law or agreed to in writing, software
854 distributed under the License is distributed on an "AS IS" BASIS,
855 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
856 See the License for the specific language governing permissions and
857 limitations under the License.
858 */
859 
860 
861 
862 
863 
864 
865 ///@title This contract enables assigning bonus to crowdsale contributors.
866 contract BonusHolder is CustomPausable {
867   using SafeMath for uint256;
868 
869   ///@notice The list of addresses and their respective bonuses.
870   mapping(address => uint256) public bonusHolders;
871 
872   ///@notice The timestamp on which bonus will be available.
873   uint256 public releaseDate;
874 
875   ///@notice The ERC20 token contract of the bonus coin.
876   ERC20 public bonusCoin;
877 
878   ///@notice The total amount of bonus coins provided to the contributors.
879   uint256 public bonusProvided;
880 
881   ///@notice The total amount of bonus withdrawn by the contributors.
882   uint256 public bonusWithdrawn;
883 
884   event BonusReleaseDateSet(uint256 _releaseDate);
885   event BonusAssigned(address indexed _address, uint _amount);
886   event BonusWithdrawn(address indexed _address, uint _amount);
887 
888   ///@notice Constructs bonus holder.
889   ///@param _bonusCoin The ERC20 token of the coin to hold bonus.
890   constructor(ERC20 _bonusCoin) internal {
891     bonusCoin = _bonusCoin;
892   }
893 
894   ///@notice Enables the administrators to set the bonus release date.
895   ///Please note that the release date can only be set once.
896   ///@param _releaseDate The timestamp after which the bonus will be available.
897   function setReleaseDate(uint256 _releaseDate) external onlyAdmin whenNotPaused {
898     require(releaseDate == 0);
899     require(_releaseDate > now);
900 
901     releaseDate = _releaseDate;
902 
903     emit BonusReleaseDateSet(_releaseDate);
904   }
905 
906   ///@notice Assigns bonus tokens to the specific contributor.
907   ///@param _investor The wallet address of the investor/contributor.
908   ///@param _bonus The amount of bonus in token value.
909   function assignBonus(address _investor, uint256 _bonus) internal {
910     if(_bonus == 0){
911       return;
912     }
913 
914     bonusProvided = bonusProvided.add(_bonus);
915     bonusHolders[_investor] = bonusHolders[_investor].add(_bonus);
916 
917     emit BonusAssigned(_investor, _bonus);
918   }
919 
920   ///@notice Enables contributors to withdraw their bonus.
921   ///The bonus can only be withdrawn after the release date.
922   function withdrawBonus() external whenNotPaused {
923     require(releaseDate != 0);
924     require(now > releaseDate);
925 
926     uint256 amount = bonusHolders[msg.sender];
927     require(amount > 0);
928 
929     bonusWithdrawn = bonusWithdrawn.add(amount);
930 
931     bonusHolders[msg.sender] = 0;
932     require(bonusCoin.transfer(msg.sender, amount));
933 
934     emit BonusWithdrawn(msg.sender, amount);
935   }
936 
937   ///@notice Returns the remaining bonus held on behalf of the crowdsale contributors by this contract.
938   function getRemainingBonus() public view returns(uint256) {
939     return bonusProvided.sub(bonusWithdrawn);
940   }
941 }
942 
943 /*
944 Copyright 2018 Virtual Rehab (http://virtualrehab.co)
945 Licensed under the Apache License, Version 2.0 (the "License");
946 you may not use this file except in compliance with the License.
947 You may obtain a copy of the License at
948     http://www.apache.org/licenses/LICENSE-2.0
949 Unless required by applicable law or agreed to in writing, software
950 distributed under the License is distributed on an "AS IS" BASIS,
951 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
952 See the License for the specific language governing permissions and
953 limitations under the License.
954  */
955 
956 
957 
958 
959 
960 
961 
962 
963 
964 
965 
966 
967 ///@title Virtual Rehab Private Sale.
968 ///@author Binod Nirvan, Subramanian Venkatesan (http://virtualrehab.co)
969 ///@notice This contract enables contributors to participate in Virtual Rehab Private Sale.
970 ///
971 ///The Virtual Rehab Private Sale provides early investors with an opportunity
972 ///to take part into the Virtual Rehab token sale ahead of the pre-sale and main sale launch.
973 ///All early investors are expected to successfully complete KYC and whitelisting
974 ///to contribute to the Virtual Rehab token sale.
975 ///
976 ///US investors must be accredited investors and must provide all requested documentation
977 ///to validate their accreditation. We, unfortunately, do not accept contributions
978 ///from non-accredited investors within the US along with any contribution
979 ///from China, Republic of Korea, and New Zealand. Any questions or additional information needed
980 ///can be sought by sending an e-mail to investors＠virtualrehab.co.
981 ///
982 ///Accepted Currencies: Ether, Binance Coin, Credits Token.
983 contract PrivateSale is TokenPrice, EtherPrice, BinanceCoinPrice, CreditsTokenPrice, BonusHolder, FinalizableCrowdsale, CustomWhitelist {
984   ///@notice The ERC20 token contract of Binance Coin. Must be: 0xB8c77482e45F1F44dE1745F52C74426C631bDD52
985   ERC20 public binanceCoin;
986 
987   ///@notice The ERC20 token contract of Credits Token. Must be: 0x46b9Ad944d1059450Da1163511069C718F699D31
988   ERC20 public creditsToken;
989 
990   ///@notice The total amount of VRH tokens sold in the private round.
991   uint256 public totalTokensSold;
992 
993   ///@notice The total amount of VRH tokens allocated for the private sale.
994   uint256 public totalSaleAllocation;
995 
996   ///@notice The minimum contribution in dollar cent value.
997   uint256 public minContributionInUSDCents;
998 
999   mapping(address => uint256) public assignedBonusRates;
1000   uint[3] public bonusLimits;
1001   uint[3] public bonusPercentages;
1002 
1003   ///@notice Signifies if the private sale was started.
1004   bool public initialized;
1005 
1006   event SaleInitialized();
1007 
1008   event MinimumContributionChanged(uint256 _newContribution, uint256 _oldContribution);
1009   event ClosingTimeChanged(uint256 _newClosingTime, uint256 _oldClosingTime);
1010   event FundsWithdrawn(address indexed _wallet, uint256 _amount);
1011   event ERC20Withdrawn(address indexed _contract, uint256 _amount);
1012   event TokensAllocatedForSale(uint256 _newAllowance, uint256 _oldAllowance);
1013 
1014   ///@notice Creates and constructs this private sale contract.
1015   ///@param _startTime The date and time of the private sale start.
1016   ///@param _endTime The date and time of the private sale end.
1017   ///@param _binanceCoin Binance coin contract. Must be: 0xB8c77482e45F1F44dE1745F52C74426C631bDD52.
1018   ///@param _creditsToken credits Token contract. Must be: 0x46b9Ad944d1059450Da1163511069C718F699D31.
1019   ///@param _vrhToken VRH token contract.
1020   constructor(uint256 _startTime, uint256 _endTime, ERC20 _binanceCoin, ERC20 _creditsToken, ERC20 _vrhToken) public
1021   TimedCrowdsale(_startTime, _endTime)
1022   Crowdsale(1, msg.sender, _vrhToken)
1023   BonusHolder(_vrhToken) {
1024     //require(address(_binanceCoin) == 0xB8c77482e45F1F44dE1745F52C74426C631bDD52);
1025     //require(address(_creditsToken) == 0x46b9Ad944d1059450Da1163511069C718F699D31);
1026     binanceCoin = _binanceCoin;
1027     creditsToken = _creditsToken;
1028   }
1029 
1030   ///@notice Initializes the private sale.
1031   ///@param _etherPriceInCents Ether Price in cents
1032   ///@param _tokenPriceInCents VRHToken Price in cents
1033   ///@param _binanceCoinPriceInCents Binance Coin Price in cents
1034   ///@param _creditsTokenPriceInCents Credits Token Price in cents
1035   ///@param _minContributionInUSDCents The minimum contribution in dollar cent value
1036   function initializePrivateSale(uint _etherPriceInCents, uint _tokenPriceInCents, uint _binanceCoinPriceInCents, uint _creditsTokenPriceInCents, uint _minContributionInUSDCents) external onlyAdmin {
1037     require(!initialized);
1038     require(_etherPriceInCents > 0);
1039     require(_tokenPriceInCents > 0);
1040     require(_binanceCoinPriceInCents > 0);
1041     require(_creditsTokenPriceInCents > 0);
1042     require(_minContributionInUSDCents > 0);
1043 
1044     setEtherPrice(_etherPriceInCents);
1045     setTokenPrice(_tokenPriceInCents);
1046     setBinanceCoinPrice(_binanceCoinPriceInCents);
1047     setCreditsTokenPrice(_creditsTokenPriceInCents);
1048     setMinimumContribution(_minContributionInUSDCents);
1049 
1050     increaseTokenSaleAllocation();
1051 
1052     bonusLimits[0] = 25000000;
1053     bonusLimits[1] = 10000000;
1054     bonusLimits[2] = 1500000;
1055 
1056     bonusPercentages[0] = 50;
1057     bonusPercentages[1] = 40;
1058     bonusPercentages[2] = 35;
1059 
1060 
1061     initialized = true;
1062 
1063     emit SaleInitialized();
1064   }
1065 
1066   ///@notice Enables a contributor to contribute using Binance coin.
1067   function contributeInBNB() external ifWhitelisted(msg.sender) whenNotPaused onlyWhileOpen {
1068     require(initialized);
1069 
1070     ///Check the amount of Binance coins allowed to (be transferred by) this contract by the contributor.
1071     uint256 allowance = binanceCoin.allowance(msg.sender, this);
1072     require (allowance > 0, "You have not approved any Binance Coin for this contract to receive.");
1073 
1074     ///Calculate equivalent amount in dollar cent value.
1075     uint256 contributionCents  = convertToCents(allowance, binanceCoinPriceInCents, 18);
1076 
1077 
1078     if(assignedBonusRates[msg.sender] == 0) {
1079       require(contributionCents >= minContributionInUSDCents);
1080       assignedBonusRates[msg.sender] = getBonusPercentage(contributionCents);
1081     }
1082 
1083     ///Calculate the amount of tokens per the contribution.
1084     uint256 numTokens = contributionCents.mul(1 ether).div(tokenPriceInCents);
1085 
1086     ///Calculate the bonus based on the number of tokens and the dollar cent value.
1087     uint256 bonus = calculateBonus(numTokens, assignedBonusRates[msg.sender]);
1088 
1089     require(totalTokensSold.add(numTokens).add(bonus) <= totalSaleAllocation);
1090 
1091     ///Receive the Binance coins immediately.
1092     require(binanceCoin.transferFrom(msg.sender, this, allowance));
1093 
1094     ///Send the VRH tokens to the contributor.
1095     require(token.transfer(msg.sender, numTokens));
1096 
1097     ///Assign the bonus to be vested and later withdrawn.
1098     assignBonus(msg.sender, bonus);
1099 
1100     totalTokensSold = totalTokensSold.add(numTokens).add(bonus);
1101   }
1102 
1103   function contributeInCreditsToken() external ifWhitelisted(msg.sender) whenNotPaused onlyWhileOpen {
1104     require(initialized);
1105 
1106     ///Check the amount of Binance coins allowed to (be transferred by) this contract by the contributor.
1107     uint256 allowance = creditsToken.allowance(msg.sender, this);
1108     require (allowance > 0, "You have not approved any Credits Token for this contract to receive.");
1109 
1110     ///Calculate equivalent amount in dollar cent value.
1111     uint256 contributionCents = convertToCents(allowance, creditsTokenPriceInCents, 6);
1112 
1113     if(assignedBonusRates[msg.sender] == 0) {
1114       require(contributionCents >= minContributionInUSDCents);
1115       assignedBonusRates[msg.sender] = getBonusPercentage(contributionCents);
1116     }
1117 
1118     ///Calculate the amount of tokens per the contribution.
1119     uint256 numTokens = contributionCents.mul(1 ether).div(tokenPriceInCents);
1120 
1121     ///Calculate the bonus based on the number of tokens and the dollar cent value.
1122     uint256 bonus = calculateBonus(numTokens, assignedBonusRates[msg.sender]);
1123 
1124     require(totalTokensSold.add(numTokens).add(bonus) <= totalSaleAllocation);
1125 
1126     ///Receive the Credits Token immediately.
1127     require(creditsToken.transferFrom(msg.sender, this, allowance));
1128 
1129     ///Send the VRH tokens to the contributor.
1130     require(token.transfer(msg.sender, numTokens));
1131 
1132     ///Assign the bonus to be vested and later withdrawn.
1133     assignBonus(msg.sender, bonus);
1134 
1135     totalTokensSold = totalTokensSold.add(numTokens).add(bonus);
1136   }
1137 
1138   function setMinimumContribution(uint256 _cents) public whenNotPaused onlyAdmin {
1139     require(_cents > 0);
1140 
1141     emit MinimumContributionChanged(minContributionInUSDCents, _cents);
1142     minContributionInUSDCents = _cents;
1143   }
1144 
1145   ///@notice The equivalent dollar amount of each contribution request.
1146   uint256 private amountInUSDCents;
1147 
1148   ///@notice Additional validation rules before token contribution is actually allowed.
1149   ///@param _beneficiary The contributor who wishes to purchase the VRH tokens.
1150   ///@param _weiAmount The amount of Ethers (in wei) wished to contribute.
1151   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal whenNotPaused ifWhitelisted(_beneficiary) {
1152     require(initialized);
1153 
1154     amountInUSDCents = convertToCents(_weiAmount, etherPriceInCents, 18);
1155 
1156     if(assignedBonusRates[_beneficiary] == 0) {
1157       require(amountInUSDCents >= minContributionInUSDCents);
1158       assignedBonusRates[_beneficiary] = getBonusPercentage(amountInUSDCents);
1159     }
1160 
1161     ///Continue validating the purchase.
1162     super._preValidatePurchase(_beneficiary, _weiAmount);
1163   }
1164 
1165   ///@notice This function is automatically called when a contribution request passes all validations.
1166   ///@dev Overridden to keep track of the bonuses.
1167   ///@param _beneficiary The contributor who wishes to purchase the VRH tokens.
1168   ///@param _tokenAmount The amount of tokens wished to purchase.
1169   function _processPurchase(address _beneficiary, uint256 _tokenAmount) internal {
1170     ///amountInUSDCents is set on _preValidatePurchase
1171     uint256 bonus = calculateBonus(_tokenAmount, assignedBonusRates[_beneficiary]);
1172 
1173     ///Ensure that the sale does not exceed allocation.
1174     require(totalTokensSold.add(_tokenAmount).add(bonus) <= totalSaleAllocation);
1175 
1176     ///Assign bonuses so that they can be later withdrawn.
1177     assignBonus(_beneficiary, bonus);
1178 
1179     ///Update the sum of tokens sold during the private sale.
1180     totalTokensSold = totalTokensSold.add(_tokenAmount).add(bonus);
1181 
1182     ///Continue processing the purchase.
1183     super._processPurchase(_beneficiary, _tokenAmount);
1184   }
1185 
1186   ///@notice Calculates bonus.
1187   ///@param _tokenAmount The total amount in VRH tokens.
1188   ///@param _percentage bonus percentage.
1189   function calculateBonus(uint256 _tokenAmount, uint256 _percentage) public pure returns (uint256) {
1190     return _tokenAmount.mul(_percentage).div(100);
1191   }
1192 
1193   ///@notice Sets the bonus structure.
1194   ///The bonus limits must be in decreasing order.
1195   function setBonuses(uint[] _bonusLimits, uint[] _bonusPercentages) public onlyAdmin {
1196     require(_bonusLimits.length == _bonusPercentages.length);
1197     require(_bonusPercentages.length == 3);
1198     for(uint8 i=0;i<_bonusLimits.length;i++) {
1199       bonusLimits[i] = _bonusLimits[i];
1200       bonusPercentages[i] = _bonusPercentages[i];
1201     }
1202   }
1203 
1204 
1205   ///@notice Gets the bonus applicable for the supplied dollar cent value.
1206   function getBonusPercentage(uint _cents) view public returns(uint256) {
1207     for(uint8 i=0;i<bonusLimits.length;i++) {
1208       if(_cents >= bonusLimits[i]) {
1209         return bonusPercentages[i];
1210       }
1211     }
1212   }
1213 
1214   ///@notice Converts the amount of Ether (wei) or amount of any token having 18 decimal place divisible
1215   ///to cent value based on the cent price supplied.
1216   function convertToCents(uint256 _tokenAmount, uint256 _priceInCents, uint256 _decimals) public pure returns (uint256) {
1217     return _tokenAmount.mul(_priceInCents).div(10**_decimals);
1218   }
1219 
1220   ///@notice Calculates the number of VRH tokens for the supplied wei value.
1221   ///@param _weiAmount The total amount of Ether in wei value.
1222   function _getTokenAmount(uint256 _weiAmount) internal view returns (uint256) {
1223     return _weiAmount.mul(etherPriceInCents).div(tokenPriceInCents);
1224   }
1225 
1226   ///@dev Used only for test, drop this function before deployment.
1227   ///@param _weiAmount The total amount of Ether in wei value.
1228   function getTokenAmountForWei(uint256 _weiAmount) external view returns (uint256) {
1229     return _getTokenAmount(_weiAmount);
1230   }
1231 
1232   ///@notice Recalculates and/or reassigns the total tokens allocated for the private sale.
1233   function increaseTokenSaleAllocation() public whenNotPaused onlyAdmin {
1234     ///Check the allowance of this contract to spend.
1235     uint256 allowance = token.allowance(msg.sender, this);
1236 
1237     ///Get the current allocation.
1238     uint256 current = totalSaleAllocation;
1239 
1240     ///Update the total token allocation for the private sale.
1241     totalSaleAllocation = totalSaleAllocation.add(allowance);
1242 
1243     ///Transfer (receive) the allocated VRH tokens.
1244     require(token.transferFrom(msg.sender, this, allowance));
1245 
1246     emit TokensAllocatedForSale(totalSaleAllocation, current);
1247   }
1248 
1249 
1250   ///@notice Enables the admins to withdraw Binance coin
1251   ///or any ERC20 token accidentally sent to this contract.
1252   function withdrawToken(address _token) external onlyAdmin {
1253     bool isVRH = _token == address(token);
1254     ERC20 erc20 = ERC20(_token);
1255 
1256     uint256 balance = erc20.balanceOf(this);
1257 
1258     //This stops admins from stealing the allocated bonus of the investors.
1259     ///The bonus VRH tokens should remain in this contract.
1260     if(isVRH) {
1261       balance = balance.sub(getRemainingBonus());
1262       changeClosingTime(now);
1263     }
1264 
1265     require(erc20.transfer(msg.sender, balance));
1266 
1267     emit ERC20Withdrawn(_token, balance);
1268   }
1269 
1270 
1271   ///@dev Must be called after crowdsale ends, to do some extra finalization work.
1272   function finalizeCrowdsale() public onlyAdmin {
1273     require(!isFinalized);
1274     require(hasClosed());
1275 
1276     uint256 unsold = token.balanceOf(this).sub(bonusProvided);
1277 
1278     if(unsold > 0) {
1279       require(token.transfer(msg.sender, unsold));
1280     }
1281 
1282     isFinalized = true;
1283 
1284     emit Finalized();
1285   }
1286 
1287   ///@notice Signifies whether or not the private sale has ended.
1288   ///@return Returns true if the private sale has ended.
1289   function hasClosed() public view returns (bool) {
1290     return (totalTokensSold >= totalSaleAllocation) || super.hasClosed();
1291   }
1292 
1293   ///@dev Reverts the finalization logic.
1294   ///Use finalizeCrowdsale instead.
1295   function finalization() internal {
1296     revert();
1297   }
1298 
1299   ///@notice Stops the crowdsale contract from sending ethers.
1300   function _forwardFunds() internal {
1301     //Nothing to do here.
1302   }
1303 
1304   ///@notice Enables the admins to withdraw Ethers present in this contract.
1305   ///@param _amount Amount of Ether in wei value to withdraw.
1306   function withdrawFunds(uint256 _amount) external whenNotPaused onlyAdmin {
1307     require(_amount <= address(this).balance);
1308 
1309     msg.sender.transfer(_amount);
1310 
1311     emit FundsWithdrawn(msg.sender, _amount);
1312   }
1313 
1314   ///@notice Adjusts the closing time of the crowdsale.
1315   ///@param _closingTime The timestamp when the crowdsale is closed.
1316   function changeClosingTime(uint256 _closingTime) public whenNotPaused onlyAdmin {
1317     emit ClosingTimeChanged(_closingTime, closingTime);
1318 
1319     closingTime = _closingTime;
1320   }
1321 
1322   function getRemainingTokensForSale() public view returns(uint256) {
1323     return totalSaleAllocation.sub(totalTokensSold);
1324   }
1325 }