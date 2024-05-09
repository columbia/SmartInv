1 pragma solidity 0.4.24;
2 
3 /**
4  * @title ERC20Basic
5  * @dev Simpler version of ERC20 interface
6  * See https://github.com/ethereum/EIPs/issues/179
7  */
8 contract ERC20Basic {
9   function totalSupply() public view returns (uint256);
10   function balanceOf(address _who) public view returns (uint256);
11   function transfer(address _to, uint256 _value) public returns (bool);
12   event Transfer(address indexed from, address indexed to, uint256 value);
13 }
14 
15 /**
16  * @title SafeMath
17  * @dev Math operations with safety checks that throw on error
18  */
19 library SafeMath {
20 
21   /**
22   * @dev Multiplies two numbers, throws on overflow.
23   */
24   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
25     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
26     // benefit is lost if 'b' is also tested.
27     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
28     if (_a == 0) {
29       return 0;
30     }
31 
32     c = _a * _b;
33     assert(c / _a == _b);
34     return c;
35   }
36 
37   /**
38   * @dev Integer division of two numbers, truncating the quotient.
39   */
40   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
41     // assert(_b > 0); // Solidity automatically throws when dividing by 0
42     // uint256 c = _a / _b;
43     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
44     return _a / _b;
45   }
46 
47   /**
48   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
49   */
50   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
51     assert(_b <= _a);
52     return _a - _b;
53   }
54 
55   /**
56   * @dev Adds two numbers, throws on overflow.
57   */
58   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
59     c = _a + _b;
60     assert(c >= _a);
61     return c;
62   }
63 }
64 
65 /**
66  * @title Basic token
67  * @dev Basic version of StandardToken, with no allowances.
68  */
69 contract BasicToken is ERC20Basic {
70   using SafeMath for uint256;
71 
72   mapping(address => uint256) internal balances;
73 
74   uint256 internal totalSupply_;
75 
76   /**
77   * @dev Total number of tokens in existence
78   */
79   function totalSupply() public view returns (uint256) {
80     return totalSupply_;
81   }
82 
83   /**
84   * @dev Transfer token for a specified address
85   * @param _to The address to transfer to.
86   * @param _value The amount to be transferred.
87   */
88   function transfer(address _to, uint256 _value) public returns (bool) {
89     require(_value <= balances[msg.sender]);
90     require(_to != address(0));
91 
92     balances[msg.sender] = balances[msg.sender].sub(_value);
93     balances[_to] = balances[_to].add(_value);
94     emit Transfer(msg.sender, _to, _value);
95     return true;
96   }
97 
98   /**
99   * @dev Gets the balance of the specified address.
100   * @param _owner The address to query the the balance of.
101   * @return An uint256 representing the amount owned by the passed address.
102   */
103   function balanceOf(address _owner) public view returns (uint256) {
104     return balances[_owner];
105   }
106 
107 }
108 
109 /**
110  * @title ERC20 interface
111  * @dev see https://github.com/ethereum/EIPs/issues/20
112  */
113 contract ERC20 is ERC20Basic {
114   function allowance(address _owner, address _spender)
115     public view returns (uint256);
116 
117   function transferFrom(address _from, address _to, uint256 _value)
118     public returns (bool);
119 
120   function approve(address _spender, uint256 _value) public returns (bool);
121   event Approval(
122     address indexed owner,
123     address indexed spender,
124     uint256 value
125   );
126 }
127 
128 /**
129  * @title Standard ERC20 token
130  *
131  * @dev Implementation of the basic standard token.
132  * https://github.com/ethereum/EIPs/issues/20
133  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
134  */
135 contract StandardToken is ERC20, BasicToken {
136 
137   mapping (address => mapping (address => uint256)) internal allowed;
138 
139 
140   /**
141    * @dev Transfer tokens from one address to another
142    * @param _from address The address which you want to send tokens from
143    * @param _to address The address which you want to transfer to
144    * @param _value uint256 the amount of tokens to be transferred
145    */
146   function transferFrom(
147     address _from,
148     address _to,
149     uint256 _value
150   )
151     public
152     returns (bool)
153   {
154     require(_value <= balances[_from]);
155     require(_value <= allowed[_from][msg.sender]);
156     require(_to != address(0));
157 
158     balances[_from] = balances[_from].sub(_value);
159     balances[_to] = balances[_to].add(_value);
160     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
161     emit Transfer(_from, _to, _value);
162     return true;
163   }
164 
165   /**
166    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
167    * Beware that changing an allowance with this method brings the risk that someone may use both the old
168    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
169    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
170    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
171    * @param _spender The address which will spend the funds.
172    * @param _value The amount of tokens to be spent.
173    */
174   function approve(address _spender, uint256 _value) public returns (bool) {
175     allowed[msg.sender][_spender] = _value;
176     emit Approval(msg.sender, _spender, _value);
177     return true;
178   }
179 
180   /**
181    * @dev Function to check the amount of tokens that an owner allowed to a spender.
182    * @param _owner address The address which owns the funds.
183    * @param _spender address The address which will spend the funds.
184    * @return A uint256 specifying the amount of tokens still available for the spender.
185    */
186   function allowance(
187     address _owner,
188     address _spender
189    )
190     public
191     view
192     returns (uint256)
193   {
194     return allowed[_owner][_spender];
195   }
196 
197   /**
198    * @dev Increase the amount of tokens that an owner allowed to a spender.
199    * approve should be called when allowed[_spender] == 0. To increment
200    * allowed value is better to use this function to avoid 2 calls (and wait until
201    * the first transaction is mined)
202    * From MonolithDAO Token.sol
203    * @param _spender The address which will spend the funds.
204    * @param _addedValue The amount of tokens to increase the allowance by.
205    */
206   function increaseApproval(
207     address _spender,
208     uint256 _addedValue
209   )
210     public
211     returns (bool)
212   {
213     allowed[msg.sender][_spender] = (
214       allowed[msg.sender][_spender].add(_addedValue));
215     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
216     return true;
217   }
218 
219   /**
220    * @dev Decrease the amount of tokens that an owner allowed to a spender.
221    * approve should be called when allowed[_spender] == 0. To decrement
222    * allowed value is better to use this function to avoid 2 calls (and wait until
223    * the first transaction is mined)
224    * From MonolithDAO Token.sol
225    * @param _spender The address which will spend the funds.
226    * @param _subtractedValue The amount of tokens to decrease the allowance by.
227    */
228   function decreaseApproval(
229     address _spender,
230     uint256 _subtractedValue
231   )
232     public
233     returns (bool)
234   {
235     uint256 oldValue = allowed[msg.sender][_spender];
236     if (_subtractedValue >= oldValue) {
237       allowed[msg.sender][_spender] = 0;
238     } else {
239       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
240     }
241     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
242     return true;
243   }
244 
245 }
246 
247 /**
248  * @title Burnable Token
249  * @dev Token that can be irreversibly burned (destroyed).
250  */
251 contract BurnableToken is BasicToken {
252 
253   event Burn(address indexed burner, uint256 value);
254 
255   /**
256    * @dev Burns a specific amount of tokens.
257    * @param _value The amount of token to be burned.
258    */
259   function burn(uint256 _value) public {
260     _burn(msg.sender, _value);
261   }
262 
263   function _burn(address _who, uint256 _value) internal {
264     require(_value <= balances[_who]);
265     // no need to require value <= totalSupply, since that would imply the
266     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
267 
268     balances[_who] = balances[_who].sub(_value);
269     totalSupply_ = totalSupply_.sub(_value);
270     emit Burn(_who, _value);
271     emit Transfer(_who, address(0), _value);
272   }
273 }
274 
275 /**
276  * @title Ownable
277  * @dev The Ownable contract has an owner address, and provides basic authorization control
278  * functions, this simplifies the implementation of "user permissions".
279  */
280 contract Ownable {
281   address public owner;
282 
283 
284   event OwnershipRenounced(address indexed previousOwner);
285   event OwnershipTransferred(
286     address indexed previousOwner,
287     address indexed newOwner
288   );
289 
290 
291   /**
292    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
293    * account.
294    */
295   constructor() public {
296     owner = msg.sender;
297   }
298 
299   /**
300    * @dev Throws if called by any account other than the owner.
301    */
302   modifier onlyOwner() {
303     require(msg.sender == owner);
304     _;
305   }
306 
307   /**
308    * @dev Allows the current owner to relinquish control of the contract.
309    * @notice Renouncing to ownership will leave the contract without an owner.
310    * It will not be possible to call the functions with the `onlyOwner`
311    * modifier anymore.
312    */
313   function renounceOwnership() public onlyOwner {
314     emit OwnershipRenounced(owner);
315     owner = address(0);
316   }
317 
318   /**
319    * @dev Allows the current owner to transfer control of the contract to a newOwner.
320    * @param _newOwner The address to transfer ownership to.
321    */
322   function transferOwnership(address _newOwner) public onlyOwner {
323     _transferOwnership(_newOwner);
324   }
325 
326   /**
327    * @dev Transfers control of the contract to a newOwner.
328    * @param _newOwner The address to transfer ownership to.
329    */
330   function _transferOwnership(address _newOwner) internal {
331     require(_newOwner != address(0));
332     emit OwnershipTransferred(owner, _newOwner);
333     owner = _newOwner;
334   }
335 }
336 
337 /*
338 Copyright 2018 Binod Nirvan
339 
340 Licensed under the Apache License, Version 2.0 (the "License");
341 you may not use this file except in compliance with the License.
342 You may obtain a copy of the License at
343 
344     http://www.apache.org/licenses/LICENSE-2.0
345 
346 Unless required by applicable law or agreed to in writing, software
347 distributed under the License is distributed on an "AS IS" BASIS,
348 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
349 See the License for the specific language governing permissions and
350 limitations under the License.
351  */
352 
353 
354 
355 
356 
357 ///@title This contract enables to create multiple contract administrators.
358 contract CustomAdmin is Ownable {
359   ///@notice List of administrators.
360   mapping(address => bool) public admins;
361 
362   event AdminAdded(address indexed _address);
363   event AdminRemoved(address indexed _address);
364 
365   ///@notice Validates if the sender is actually an administrator.
366   modifier onlyAdmin() {
367     require(admins[msg.sender] || msg.sender == owner);
368     _;
369   }
370 
371   ///@notice Adds the specified address to the list of administrators.
372   ///@param _address The address to add to the administrator list.
373   function addAdmin(address _address) external onlyAdmin {
374     require(_address != address(0));
375     require(!admins[_address]);
376 
377     //The owner is already an admin and cannot be added.
378     require(_address != owner);
379 
380     admins[_address] = true;
381 
382     emit AdminAdded(_address);
383   }
384 
385   ///@notice Adds multiple addresses to the administrator list.
386   ///@param _accounts The wallet addresses to add to the administrator list.
387   function addManyAdmins(address[] _accounts) external onlyAdmin {
388     for(uint8 i=0; i<_accounts.length; i++) {
389       address account = _accounts[i];
390 
391       ///Zero address cannot be an admin.
392       ///The owner is already an admin and cannot be assigned.
393       ///The address cannot be an existing admin.
394       if(account != address(0) && !admins[account] && account != owner){
395         admins[account] = true;
396 
397         emit AdminAdded(_accounts[i]);
398       }
399     }
400   }
401 
402   ///@notice Removes the specified address from the list of administrators.
403   ///@param _address The address to remove from the administrator list.
404   function removeAdmin(address _address) external onlyAdmin {
405     require(_address != address(0));
406     require(admins[_address]);
407 
408     //The owner cannot be removed as admin.
409     require(_address != owner);
410 
411     admins[_address] = false;
412     emit AdminRemoved(_address);
413   }
414 
415   function isAdmin(address _account) view public returns(bool) {
416     return admins[_account] || _account == owner;
417   }
418 
419   ///@notice Removes multiple addresses to the administrator list.
420   ///@param _accounts The wallet addresses to remove from the administrator list.
421   function removeManyAdmins(address[] _accounts) external onlyAdmin {
422     for(uint8 i=0; i<_accounts.length; i++) {
423       address account = _accounts[i];
424 
425       ///Zero address can neither be added or removed from this list.
426       ///The owner is the super admin and cannot be removed.
427       ///The address must be an existing admin in order for it to be removed.
428       if(account != address(0) && admins[account] && account != owner){
429         admins[account] = false;
430 
431         emit AdminRemoved(_accounts[i]);
432       }
433     }
434   }
435 }
436 
437 /*
438 Copyright 2018 Binod Nirvan
439 
440 Licensed under the Apache License, Version 2.0 (the "License");
441 you may not use this file except in compliance with the License.
442 You may obtain a copy of the License at
443 
444     http://www.apache.org/licenses/LICENSE-2.0
445 
446 Unless required by applicable law or agreed to in writing, software
447 distributed under the License is distributed on an "AS IS" BASIS,
448 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
449 See the License for the specific language governing permissions and
450 limitations under the License.
451  */
452 
453 
454 
455 
456 
457 
458 
459 
460 ///@title This contract enables you to create pausable mechanism to stop in case of emergency.
461 contract CustomPausable is CustomAdmin {
462   event Paused();
463   event Unpaused();
464 
465   bool public paused = false;
466 
467   ///@notice Verifies whether the contract is not paused.
468   modifier whenNotPaused() {
469     require(!paused);
470     _;
471   }
472 
473   ///@notice Verifies whether the contract is paused.
474   modifier whenPaused() {
475     require(paused);
476     _;
477   }
478 
479   ///@notice Pauses the contract.
480   function pause() external onlyAdmin whenNotPaused {
481     paused = true;
482     emit Paused();
483   }
484 
485   ///@notice Unpauses the contract and returns to normal state.
486   function unpause() external onlyAdmin whenPaused {
487     paused = false;
488     emit Unpaused();
489   }
490 }
491 
492 /*
493 Copyright 2018 Virtual Rehab (http://virtualrehab.co)
494 
495 Licensed under the Apache License, Version 2.0 (the "License");
496 you may not use this file except in compliance with the License.
497 You may obtain a copy of the License at
498 
499     http://www.apache.org/licenses/LICENSE-2.0
500 
501 Unless required by applicable law or agreed to in writing, software
502 distributed under the License is distributed on an "AS IS" BASIS,
503 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
504 See the License for the specific language governing permissions and
505 limitations under the License.
506 */
507 
508 
509 
510 
511 
512 
513 
514 ///@title Virtual Rehab Token (VRH) ERC20 Token Contract
515 ///@author Binod Nirvan, Subramanian Venkatesan (http://virtualrehab.co)
516 ///@notice The Virtual Rehab Token (VRH) has been created as a centralized currency
517 ///to be used within the Virtual Rehab network. Users will be able to purchase and sell
518 ///VRH tokens in exchanges. The token follows the standards of Ethereum ERC20 Standard token.
519 ///Its design follows the widely adopted token implementation standards.
520 ///This allows token holders to easily store and manage their VRH tokens using existing solutions
521 ///including ERC20-compatible Ethereum wallets. The VRH Token is a utility token
522 ///and is core to Virtual Rehab’s end-to-end operations.
523 ///
524 ///VRH utility use cases include:
525 ///1. Order & Download Virtual Rehab programs through the Virtual Rehab Online Portal
526 ///2. Request further analysis, conducted by Virtual Rehab's unique expert system (which leverages Artificial Intelligence), of the executed programs
527 ///3. Receive incentives (VRH rewards) for seeking help and counselling from psychologists, therapists, or medical doctors
528 ///4. Allows users to pay for services received at the Virtual Rehab Therapy Center
529 contract VRHToken is StandardToken, CustomPausable, BurnableToken {
530   uint8 public constant decimals = 18;
531   string public constant name = "Virtual Rehab";
532   string public constant symbol = "VRH";
533 
534   uint public constant MAX_SUPPLY = 400000000 * (10 ** uint256(decimals));
535   uint public constant INITIAL_SUPPLY = (400000000 - 1650000 - 2085000 - 60000000) * (10 ** uint256(decimals));
536 
537   bool public released = false;
538   uint public ICOEndDate;
539 
540 
541   mapping(bytes32 => bool) private mintingList;
542 
543   event Mint(address indexed to, uint256 amount);
544   event BulkTransferPerformed(address[] _destinations, uint256[] _amounts);
545   event TokenReleased(bool _state);
546   event ICOEndDateSet(uint256 _date);
547 
548   ///@notice Checks if the supplied address is able to perform transfers.
549   ///@param _from The address to check against if the transfer is allowed.
550   modifier canTransfer(address _from) {
551     if(paused || !released) {
552       if(!isAdmin(_from)) {
553         revert();
554       }
555     }
556 
557     _;
558   }
559 
560   ///@notice Computes keccak256 hash of the supplied value.
561   ///@param _key The string value to compute hash from.
562   function computeHash(string _key) private pure returns(bytes32){
563     return keccak256(abi.encodePacked(_key));
564   }
565 
566   ///@notice Checks if the minting for the supplied key was already performed.
567   ///@param _key The key or category name of minting.
568   modifier whenNotMinted(string _key) {
569     if(mintingList[computeHash(_key)]) {
570       revert();
571     }
572 
573     _;
574   }
575 
576   constructor() public {
577     mintTokens(msg.sender, INITIAL_SUPPLY);
578   }
579 
580 
581 
582   ///@notice This function enables token transfers for everyone.
583   ///Can only be enabled after the end of the ICO.
584   function releaseTokenForTransfer() public onlyAdmin whenNotPaused {
585     require(!released);
586 
587     released = true;
588 
589     emit TokenReleased(released);
590   }
591 
592   ///@notice This function disables token transfers for everyone.
593   function disableTokenTransfers() public onlyAdmin whenNotPaused {
594     require(released);
595 
596     released = false;
597 
598     emit TokenReleased(released);
599   }
600 
601   ///@notice This function enables the whitelisted application (internal application) to set the ICO end date and can only be used once.
602   ///@param _date The date to set as the ICO end date.
603   function setICOEndDate(uint _date) public onlyAdmin {
604     require(ICOEndDate == 0);
605     require(_date > now);
606 
607     ICOEndDate = _date;
608 
609     emit ICOEndDateSet(_date);
610   }
611 
612   ///@notice Mints the supplied value of the tokens to the destination address.
613   //Minting cannot be performed any further once the maximum supply is reached.
614   //This function is private and cannot be used by anyone except for this contract.
615   ///@param _to The address which will receive the minted tokens.
616   ///@param _value The amount of tokens to mint.
617   function mintTokens(address _to, uint _value) private {
618     require(_to != address(0));
619     require(totalSupply_.add(_value) <= MAX_SUPPLY);
620 
621     balances[_to] = balances[_to].add(_value);
622     totalSupply_ = totalSupply_.add(_value);
623 
624     emit Mint(_to, _value);
625     emit Transfer(address(0), _to, _value);
626   }
627 
628   ///@notice Mints the tokens only once against the supplied key (category).
629   ///@param _key The key or the category of the allocation to mint the tokens for.
630   ///@param _to The address receiving the minted tokens.
631   ///@param _amount The amount of tokens to mint.
632   function mintOnce(string _key, address _to, uint256 _amount) private whenNotPaused whenNotMinted(_key) {
633     _amount = _amount * (10 ** uint256(decimals));
634     mintTokens(_to, _amount);
635     mintingList[computeHash(_key)] = true;
636   }
637 
638   ///@notice Mints the below-mentioned amount of tokens allocated to the Virtual Rehab advisors.
639   //The tokens are only available to the advisors after 1 year of the ICO end.
640   function mintTokensForAdvisors() public onlyAdmin {
641     require(ICOEndDate != 0);
642 
643     require(now > (ICOEndDate + 365 days));
644     mintOnce("advisors", msg.sender, 1650000);
645   }
646 
647   ///@notice Mints the below-mentioned amount of tokens allocated to the Virtual Rehab founders.
648   //The tokens are only available to the founders after 2 year of the ICO end.
649   function mintTokensForFounders() public onlyAdmin {
650     require(ICOEndDate != 0);
651     require(now > (ICOEndDate + 720 days));
652 
653     mintOnce("founders", msg.sender, 60000000);
654   }
655 
656   ///@notice Mints the below-mentioned amount of tokens allocated to Virtual Rehab services.
657   //The tokens are only available to the services after 1 year of the ICO end.
658   function mintTokensForServices() public onlyAdmin  {
659     require(ICOEndDate != 0);
660     require(now > (ICOEndDate + 60 days));
661 
662     mintOnce("services", msg.sender, 2085000);
663   }
664 
665   ///@notice Transfers the specified value of VRH tokens to the destination address.
666   //Transfers can only happen when the tranfer state is enabled.
667   //Transfer state can only be enabled after the end of the crowdsale.
668   ///@param _to The destination wallet address to transfer funds to.
669   ///@param _value The amount of tokens to send to the destination address.
670   function transfer(address _to, uint256 _value) public canTransfer(msg.sender) returns (bool) {
671     require(_to != address(0));
672     return super.transfer(_to, _value);
673   }
674 
675   ///@notice Transfers tokens from a specified wallet address.
676   ///@dev This function is overriden to leverage transfer state feature.
677   ///@param _from The address to transfer funds from.
678   ///@param _to The address to transfer funds to.
679   ///@param _value The amount of tokens to transfer.
680   function transferFrom(address _from, address _to, uint256 _value) canTransfer(_from) public returns (bool) {
681     require(_to != address(0));
682     return super.transferFrom(_from, _to, _value);
683   }
684 
685   ///@notice Approves a wallet address to spend on behalf of the sender.
686   ///@dev This function is overriden to leverage transfer state feature.
687   ///@param _spender The address which is approved to spend on behalf of the sender.
688   ///@param _value The amount of tokens approve to spend.
689   function approve(address _spender, uint256 _value) public canTransfer(msg.sender) returns (bool) {
690     require(_spender != address(0));
691     return super.approve(_spender, _value);
692   }
693 
694 
695   ///@notice Increases the approval of the spender.
696   ///@dev This function is overriden to leverage transfer state feature.
697   ///@param _spender The address which is approved to spend on behalf of the sender.
698   ///@param _addedValue The added amount of tokens approved to spend.
699   function increaseApproval(address _spender, uint256 _addedValue) public canTransfer(msg.sender) returns(bool) {
700     require(_spender != address(0));
701     return super.increaseApproval(_spender, _addedValue);
702   }
703 
704   ///@notice Decreases the approval of the spender.
705   ///@dev This function is overriden to leverage transfer state feature.
706   ///@param _spender The address of the spender to decrease the allocation from.
707   ///@param _subtractedValue The amount of tokens to subtract from the approved allocation.
708   function decreaseApproval(address _spender, uint256 _subtractedValue) public canTransfer(msg.sender) returns (bool) {
709     require(_spender != address(0));
710     return super.decreaseApproval(_spender, _subtractedValue);
711   }
712 
713   ///@notice Returns the sum of supplied values.
714   ///@param _values The collection of values to create the sum from.
715   function sumOf(uint256[] _values) private pure returns(uint256) {
716     uint256 total = 0;
717 
718     for (uint256 i = 0; i < _values.length; i++) {
719       total = total.add(_values[i]);
720     }
721 
722     return total;
723   }
724 
725   ///@notice Allows only the admins and/or whitelisted applications to perform bulk transfer operation.
726   ///@param _destinations The destination wallet addresses to send funds to.
727   ///@param _amounts The respective amount of fund to send to the specified addresses.
728   function bulkTransfer(address[] _destinations, uint256[] _amounts) public onlyAdmin {
729     require(_destinations.length == _amounts.length);
730 
731     //Saving gas by determining if the sender has enough balance
732     //to post this transaction.
733     uint256 requiredBalance = sumOf(_amounts);
734     require(balances[msg.sender] >= requiredBalance);
735 
736     for (uint256 i = 0; i < _destinations.length; i++) {
737      transfer(_destinations[i], _amounts[i]);
738     }
739 
740     emit BulkTransferPerformed(_destinations, _amounts);
741   }
742 
743   ///@notice Burns the coins held by the sender.
744   ///@param _value The amount of coins to burn.
745   ///@dev This function is overriden to leverage Pausable feature.
746   function burn(uint256 _value) public whenNotPaused {
747     super.burn(_value);
748   }
749 }