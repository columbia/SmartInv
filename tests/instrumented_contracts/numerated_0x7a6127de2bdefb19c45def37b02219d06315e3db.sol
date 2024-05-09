1 /*
2 Copyright 2018 Virtual Rehab (http://virtualrehab.co)
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
17  pragma solidity 0.4.24;
18 
19 
20 
21 
22 
23 
24 
25 
26 /**
27  * @title ERC20Basic
28  * @dev Simpler version of ERC20 interface
29  * See https://github.com/ethereum/EIPs/issues/179
30  */
31 contract ERC20Basic {
32   function totalSupply() public view returns (uint256);
33   function balanceOf(address _who) public view returns (uint256);
34   function transfer(address _to, uint256 _value) public returns (bool);
35   event Transfer(address indexed from, address indexed to, uint256 value);
36 }
37 
38 
39 
40 
41 /**
42  * @title SafeMath
43  * @dev Math operations with safety checks that throw on error
44  */
45 library SafeMath {
46 
47   /**
48   * @dev Multiplies two numbers, throws on overflow.
49   */
50   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
51     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
52     // benefit is lost if 'b' is also tested.
53     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
54     if (_a == 0) {
55       return 0;
56     }
57 
58     c = _a * _b;
59     assert(c / _a == _b);
60     return c;
61   }
62 
63   /**
64   * @dev Integer division of two numbers, truncating the quotient.
65   */
66   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
67     // assert(_b > 0); // Solidity automatically throws when dividing by 0
68     // uint256 c = _a / _b;
69     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
70     return _a / _b;
71   }
72 
73   /**
74   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
75   */
76   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
77     assert(_b <= _a);
78     return _a - _b;
79   }
80 
81   /**
82   * @dev Adds two numbers, throws on overflow.
83   */
84   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
85     c = _a + _b;
86     assert(c >= _a);
87     return c;
88   }
89 }
90 
91 
92 
93 /**
94  * @title Basic token
95  * @dev Basic version of StandardToken, with no allowances.
96  */
97 contract BasicToken is ERC20Basic {
98   using SafeMath for uint256;
99 
100   mapping(address => uint256) internal balances;
101 
102   uint256 internal totalSupply_;
103 
104   /**
105   * @dev Total number of tokens in existence
106   */
107   function totalSupply() public view returns (uint256) {
108     return totalSupply_;
109   }
110 
111   /**
112   * @dev Transfer token for a specified address
113   * @param _to The address to transfer to.
114   * @param _value The amount to be transferred.
115   */
116   function transfer(address _to, uint256 _value) public returns (bool) {
117     require(_value <= balances[msg.sender]);
118     require(_to != address(0));
119 
120     balances[msg.sender] = balances[msg.sender].sub(_value);
121     balances[_to] = balances[_to].add(_value);
122     emit Transfer(msg.sender, _to, _value);
123     return true;
124   }
125 
126   /**
127   * @dev Gets the balance of the specified address.
128   * @param _owner The address to query the the balance of.
129   * @return An uint256 representing the amount owned by the passed address.
130   */
131   function balanceOf(address _owner) public view returns (uint256) {
132     return balances[_owner];
133   }
134 
135 }
136 
137 
138 
139 
140 
141 
142 /**
143  * @title ERC20 interface
144  * @dev see https://github.com/ethereum/EIPs/issues/20
145  */
146 contract ERC20 is ERC20Basic {
147   function allowance(address _owner, address _spender)
148     public view returns (uint256);
149 
150   function transferFrom(address _from, address _to, uint256 _value)
151     public returns (bool);
152 
153   function approve(address _spender, uint256 _value) public returns (bool);
154   event Approval(
155     address indexed owner,
156     address indexed spender,
157     uint256 value
158   );
159 }
160 
161 
162 
163 /**
164  * @title Standard ERC20 token
165  *
166  * @dev Implementation of the basic standard token.
167  * https://github.com/ethereum/EIPs/issues/20
168  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
169  */
170 contract StandardToken is ERC20, BasicToken {
171 
172   mapping (address => mapping (address => uint256)) internal allowed;
173 
174 
175   /**
176    * @dev Transfer tokens from one address to another
177    * @param _from address The address which you want to send tokens from
178    * @param _to address The address which you want to transfer to
179    * @param _value uint256 the amount of tokens to be transferred
180    */
181   function transferFrom(
182     address _from,
183     address _to,
184     uint256 _value
185   )
186     public
187     returns (bool)
188   {
189     require(_value <= balances[_from]);
190     require(_value <= allowed[_from][msg.sender]);
191     require(_to != address(0));
192 
193     balances[_from] = balances[_from].sub(_value);
194     balances[_to] = balances[_to].add(_value);
195     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
196     emit Transfer(_from, _to, _value);
197     return true;
198   }
199 
200   /**
201    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
202    * Beware that changing an allowance with this method brings the risk that someone may use both the old
203    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
204    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
205    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
206    * @param _spender The address which will spend the funds.
207    * @param _value The amount of tokens to be spent.
208    */
209   function approve(address _spender, uint256 _value) public returns (bool) {
210     allowed[msg.sender][_spender] = _value;
211     emit Approval(msg.sender, _spender, _value);
212     return true;
213   }
214 
215   /**
216    * @dev Function to check the amount of tokens that an owner allowed to a spender.
217    * @param _owner address The address which owns the funds.
218    * @param _spender address The address which will spend the funds.
219    * @return A uint256 specifying the amount of tokens still available for the spender.
220    */
221   function allowance(
222     address _owner,
223     address _spender
224    )
225     public
226     view
227     returns (uint256)
228   {
229     return allowed[_owner][_spender];
230   }
231 
232   /**
233    * @dev Increase the amount of tokens that an owner allowed to a spender.
234    * approve should be called when allowed[_spender] == 0. To increment
235    * allowed value is better to use this function to avoid 2 calls (and wait until
236    * the first transaction is mined)
237    * From MonolithDAO Token.sol
238    * @param _spender The address which will spend the funds.
239    * @param _addedValue The amount of tokens to increase the allowance by.
240    */
241   function increaseApproval(
242     address _spender,
243     uint256 _addedValue
244   )
245     public
246     returns (bool)
247   {
248     allowed[msg.sender][_spender] = (
249       allowed[msg.sender][_spender].add(_addedValue));
250     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
251     return true;
252   }
253 
254   /**
255    * @dev Decrease the amount of tokens that an owner allowed to a spender.
256    * approve should be called when allowed[_spender] == 0. To decrement
257    * allowed value is better to use this function to avoid 2 calls (and wait until
258    * the first transaction is mined)
259    * From MonolithDAO Token.sol
260    * @param _spender The address which will spend the funds.
261    * @param _subtractedValue The amount of tokens to decrease the allowance by.
262    */
263   function decreaseApproval(
264     address _spender,
265     uint256 _subtractedValue
266   )
267     public
268     returns (bool)
269   {
270     uint256 oldValue = allowed[msg.sender][_spender];
271     if (_subtractedValue >= oldValue) {
272       allowed[msg.sender][_spender] = 0;
273     } else {
274       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
275     }
276     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
277     return true;
278   }
279 
280 }
281 
282 
283 
284 
285 
286 
287 /**
288  * @title Burnable Token
289  * @dev Token that can be irreversibly burned (destroyed).
290  */
291 contract BurnableToken is BasicToken {
292 
293   event Burn(address indexed burner, uint256 value);
294 
295   /**
296    * @dev Burns a specific amount of tokens.
297    * @param _value The amount of token to be burned.
298    */
299   function burn(uint256 _value) public {
300     _burn(msg.sender, _value);
301   }
302 
303   function _burn(address _who, uint256 _value) internal {
304     require(_value <= balances[_who]);
305     // no need to require value <= totalSupply, since that would imply the
306     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
307 
308     balances[_who] = balances[_who].sub(_value);
309     totalSupply_ = totalSupply_.sub(_value);
310     emit Burn(_who, _value);
311     emit Transfer(_who, address(0), _value);
312   }
313 }
314 
315 /*
316 Copyright 2018 Binod Nirvan
317 
318 Licensed under the Apache License, Version 2.0 (the "License");
319 you may not use this file except in compliance with the License.
320 You may obtain a copy of the License at
321 
322     http://www.apache.org/licenses/LICENSE-2.0
323 
324 Unless required by applicable law or agreed to in writing, software
325 distributed under the License is distributed on an "AS IS" BASIS,
326 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
327 See the License for the specific language governing permissions and
328 limitations under the License.
329  */
330 
331 
332 
333 
334 
335 /*
336 Copyright 2018 Binod Nirvan
337 
338 Licensed under the Apache License, Version 2.0 (the "License");
339 you may not use this file except in compliance with the License.
340 You may obtain a copy of the License at
341 
342     http://www.apache.org/licenses/LICENSE-2.0
343 
344 Unless required by applicable law or agreed to in writing, software
345 distributed under the License is distributed on an "AS IS" BASIS,
346 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
347 See the License for the specific language governing permissions and
348 limitations under the License.
349  */
350 
351 
352 
353 
354 
355 
356 /**
357  * @title Ownable
358  * @dev The Ownable contract has an owner address, and provides basic authorization control
359  * functions, this simplifies the implementation of "user permissions".
360  */
361 contract Ownable {
362   address public owner;
363 
364 
365   event OwnershipRenounced(address indexed previousOwner);
366   event OwnershipTransferred(
367     address indexed previousOwner,
368     address indexed newOwner
369   );
370 
371 
372   /**
373    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
374    * account.
375    */
376   constructor() public {
377     owner = msg.sender;
378   }
379 
380   /**
381    * @dev Throws if called by any account other than the owner.
382    */
383   modifier onlyOwner() {
384     require(msg.sender == owner);
385     _;
386   }
387 
388   /**
389    * @dev Allows the current owner to relinquish control of the contract.
390    * @notice Renouncing to ownership will leave the contract without an owner.
391    * It will not be possible to call the functions with the `onlyOwner`
392    * modifier anymore.
393    */
394   function renounceOwnership() public onlyOwner {
395     emit OwnershipRenounced(owner);
396     owner = address(0);
397   }
398 
399   /**
400    * @dev Allows the current owner to transfer control of the contract to a newOwner.
401    * @param _newOwner The address to transfer ownership to.
402    */
403   function transferOwnership(address _newOwner) public onlyOwner {
404     _transferOwnership(_newOwner);
405   }
406 
407   /**
408    * @dev Transfers control of the contract to a newOwner.
409    * @param _newOwner The address to transfer ownership to.
410    */
411   function _transferOwnership(address _newOwner) internal {
412     require(_newOwner != address(0));
413     emit OwnershipTransferred(owner, _newOwner);
414     owner = _newOwner;
415   }
416 }
417 
418 
419 contract CustomAdmin is Ownable {
420   mapping(address => bool) public admins;
421   uint256 public numberOfAdmins;
422 
423   event AdminAdded(address indexed addr);
424   event AdminRemoved(address indexed addr);
425 
426   /**
427    * @dev Throws if called by any account that's not an administrator.
428    */
429   modifier onlyAdmin() {
430     require(admins[msg.sender] || msg.sender == owner);
431     _;
432   }
433 
434   constructor() public {
435     admins[msg.sender] = true;
436     numberOfAdmins = 1;
437 
438     emit AdminAdded(msg.sender);
439   }
440   /**
441    * @dev Add an address to the adminstrator list.
442    * @param addr address
443    */
444   function addAdmin(address addr) onlyAdmin  public {
445     require(addr != address(0));
446     require(!admins[addr]);
447 
448     admins[addr] = true;
449     numberOfAdmins++;
450 
451     emit AdminAdded(addr);
452   }
453 
454   /**
455    * @dev Remove an address from the administrator list.
456    * @param addr address
457    */
458   function removeAdmin(address addr) onlyAdmin  public {
459     require(addr != address(0));
460     require(admins[addr]);
461     //the owner can not be unadminsed
462     require(addr != owner);
463 
464     admins[addr] = false;
465     numberOfAdmins--;
466 
467     emit AdminRemoved(addr);
468   }
469 }
470 
471 
472 
473 /**
474  * @title Pausable
475  * @dev Base contract which allows children to implement an emergency stop mechanism.
476  */
477 contract CustomPausable is CustomAdmin {
478   event Pause();
479   event Unpause();
480 
481   bool public paused = false;
482 
483   /**
484    * @dev Modifier to make a function callable only when the contract is not paused.
485    */
486   modifier whenNotPaused() {
487     require(!paused);
488     _;
489   }
490 
491   /**
492    * @dev Modifier to make a function callable only when the contract is paused.
493    */
494   modifier whenPaused() {
495     require(paused);
496     _;
497   }
498 
499   /**
500    * @dev called by the owner to pause, triggers stopped state
501    */
502   function pause() onlyAdmin whenNotPaused public {
503     paused = true;
504     emit Pause();
505   }
506 
507   /**
508    * @dev called by the owner to unpause, returns to normal state
509    */
510   function unpause() onlyAdmin whenPaused public {
511     paused = false;
512     emit Unpause();
513   }
514 }
515 
516 
517 ///@title Virtual Rehab Token (VRH) ERC20 Token Contract
518 ///@author Binod Nirvan, Subramanian Venkatesan (http://virtualrehab.co)
519 ///@notice The Virtual Rehab Token (VRH) has been created as a centralized currency
520 ///to be used within the Virtual Rehab network. Users will be able to purchase and sell
521 ///VRH tokens in exchanges. The token follows the standards of Ethereum ERC20 Standard token.
522 ///Its design follows the widely adopted token implementation standards.
523 ///This allows token holders to easily store and manage their VRH tokens using existing solutions
524 ///including ERC20-compatible Ethereum wallets. The VRH Token is a utility token
525 ///and is core to Virtual Rehab’s end-to-end operations.
526 ///
527 ///VRH utility use cases include:
528 ///1- Order & Download Virtual Rehab programs through the Virtual Rehab Online Portal
529 ///2- Request further analysis, conducted by Virtual Rehab's unique expert system (which leverages Artificial Intelligence), of the executed programs
530 ///3- Receive incentives (VRH rewards) for seeking help and counselling from psychologists, therapists, or medical doctors
531 contract VRHToken is StandardToken, CustomPausable, BurnableToken {
532   uint8 public constant decimals = 18;
533   string public constant name = "Virtual Rehab";
534   string public constant symbol = "VRH";
535 
536   uint public constant MAX_SUPPLY = 400000000 * (10 ** uint256(decimals));
537   uint public constant INITIAL_SUPPLY = (400000000 - 750000 - 2085000 - 60000000) * (10 ** uint256(decimals));
538 
539   bool public released = false;
540   uint public ICOEndDate;
541 
542 
543   mapping(bytes32 => bool) private mintingList;
544 
545   event Mint(address indexed to, uint256 amount);
546   event BulkTransferPerformed(address[] _destinations, uint256[] _amounts);
547   event TokenReleased(bool _state);
548   event ICOEndDateSet(uint256 _date);
549 
550   ///@notice Checks if the supplied address is able to perform transfers.
551   ///@param _from The address to check against if the transfer is allowed.
552   modifier canTransfer(address _from) {
553     if(paused || !released) {
554       if(!admins[_from]) {
555         revert();
556       }
557     }
558 
559     _;
560   }
561 
562   ///@notice Computes keccak256 hash of the supplied value.
563   ///@param _key The string value to compute hash from.
564   function computeHash(string _key) private pure returns(bytes32){
565     return keccak256(abi.encodePacked(_key));
566   }
567 
568   ///@notice Checks if the minting for the supplied key was already performed.
569   ///@param _key The key or category name of minting.
570   modifier whenNotMinted(string _key) {
571     if(mintingList[computeHash(_key)]) {
572       revert();
573     }
574 
575     _;
576   }
577 
578   constructor() public {
579     mintTokens(msg.sender, INITIAL_SUPPLY);
580     emit Transfer(address(0), msg.sender, totalSupply_);
581   }
582 
583 
584 
585   ///@notice This function enables token transfers for everyone.
586   ///Can only be enabled after the end of the ICO.
587   function releaseTokenForTransfer() public onlyAdmin whenNotPaused {
588     require(!released);
589 
590     released = true;
591 
592     emit TokenReleased(released);
593   }
594 
595   ///@notice This function disables token transfers for everyone.
596   function disableTokenTransfers() public onlyAdmin whenNotPaused {
597     require(released);
598 
599     released = false;
600 
601     emit TokenReleased(released);
602   }
603 
604   ///@notice This function enables the whitelisted application (internal application) to set the ICO end date and can only be used once.
605   ///@param _date The date to set as the ICO end date.
606   function setICOEndDate(uint _date) public onlyAdmin {
607     require(ICOEndDate == 0);
608     require(_date > now);
609 
610     ICOEndDate = _date;
611 
612     emit ICOEndDateSet(_date);
613   }
614 
615   ///@notice Mints the supplied value of the tokens to the destination address.
616   //Minting cannot be performed any further once the maximum supply is reached.
617   //This function is private and cannot be used by anyone except for this contract.
618   ///@param _to The address which will receive the minted tokens.
619   ///@param _value The amount of tokens to mint.
620   function mintTokens(address _to, uint _value) private {
621     require(_to != address(0));
622     require(totalSupply_.add(_value) <= MAX_SUPPLY);
623 
624     balances[_to] = balances[_to].add(_value);
625     totalSupply_ = totalSupply_.add(_value);
626 
627     emit Mint(_to, _value);
628     emit Transfer(address(0), _to, _value);
629   }
630 
631   ///@notice Mints the tokens only once against the supplied key (category).
632   ///@param _key The key or the category of the allocation to mint the tokens for.
633   ///@param _to The address receiving the minted tokens.
634   ///@param _amount The amount of tokens to mint.
635   function mintOnce(string _key, address _to, uint256 _amount) private whenNotPaused whenNotMinted(_key) {
636     _amount = _amount * (10 ** uint256(decimals));
637     mintTokens(_to, _amount);
638     mintingList[computeHash(_key)] = true;
639   }
640 
641   ///@notice Mints the below-mentioned amount of tokens allocated to the Virtual Rehab advisors.
642   //The tokens are only available to the advisors after 1 year of the ICO end.
643   function mintTokensForAdvisors() public onlyAdmin {
644     require(ICOEndDate != 0);
645 
646     require(now > (ICOEndDate + 365 days));
647     mintOnce("advisors", msg.sender, 750000);
648   }
649 
650   ///@notice Mints the below-mentioned amount of tokens allocated to the Virtual Rehab founders.
651   //The tokens are only available to the founders after 1 year of the ICO end.
652   function mintTokensForFounders() public onlyAdmin {
653     require(ICOEndDate != 0);
654     require(now > (ICOEndDate + 365 days));
655 
656     mintOnce("founders", msg.sender, 60000000);
657   }
658 
659   ///@notice Mints the below-mentioned amount of tokens allocated to Virtual Rehab services.
660   //The tokens are only available to the services after 1 year of the ICO end.
661   function mintTokensForServices() public onlyAdmin  {
662     require(ICOEndDate != 0);
663     require(now > (ICOEndDate + 60 days));
664 
665     mintOnce("services", msg.sender, 2085000);
666   }
667 
668   ///@notice Transfers the specified value of VRH tokens to the destination address.
669   //Transfers can only happen when the tranfer state is enabled.
670   //Transfer state can only be enabled after the end of the crowdsale.
671   ///@param _to The destination wallet address to transfer funds to.
672   ///@param _value The amount of tokens to send to the destination address.
673   function transfer(address _to, uint256 _value) public canTransfer(msg.sender) returns (bool) {
674     require(_to != address(0));
675     return super.transfer(_to, _value);
676   }
677 
678   ///@notice Transfers tokens from a specified wallet address.
679   ///@dev This function is overriden to leverage transfer state feature.
680   ///@param _from The address to transfer funds from.
681   ///@param _to The address to transfer funds to.
682   ///@param _value The amount of tokens to transfer.
683   function transferFrom(address _from, address _to, uint256 _value) canTransfer(_from) public returns (bool) {
684     require(_to != address(0));
685     return super.transferFrom(_from, _to, _value);
686   }
687 
688   ///@notice Approves a wallet address to spend on behalf of the sender.
689   ///@dev This function is overriden to leverage transfer state feature.
690   ///@param _spender The address which is approved to spend on behalf of the sender.
691   ///@param _value The amount of tokens approve to spend.
692   function approve(address _spender, uint256 _value) public canTransfer(msg.sender) returns (bool) {
693     require(_spender != address(0));
694     return super.approve(_spender, _value);
695   }
696 
697 
698   ///@notice Increases the approval of the spender.
699   ///@dev This function is overriden to leverage transfer state feature.
700   ///@param _spender The address which is approved to spend on behalf of the sender.
701   ///@param _addedValue The added amount of tokens approved to spend.
702   function increaseApproval(address _spender, uint256 _addedValue) public canTransfer(msg.sender) returns(bool) {
703     require(_spender != address(0));
704     return super.increaseApproval(_spender, _addedValue);
705   }
706 
707   ///@notice Decreases the approval of the spender.
708   ///@dev This function is overriden to leverage transfer state feature.
709   ///@param _spender The address of the spender to decrease the allocation from.
710   ///@param _subtractedValue The amount of tokens to subtract from the approved allocation.
711   function decreaseApproval(address _spender, uint256 _subtractedValue) public canTransfer(msg.sender) returns (bool) {
712     require(_spender != address(0));
713     return super.decreaseApproval(_spender, _subtractedValue);
714   }
715 
716   ///@notice Returns the sum of supplied values.
717   ///@param _values The collection of values to create the sum from.
718   function sumOf(uint256[] _values) private pure returns(uint256) {
719     uint256 total = 0;
720 
721     for (uint256 i = 0; i < _values.length; i++) {
722       total = total.add(_values[i]);
723     }
724 
725     return total;
726   }
727 
728   ///@notice Allows only the admins and/or whitelisted applications to perform bulk transfer operation.
729   ///@param _destinations The destination wallet addresses to send funds to.
730   ///@param _amounts The respective amount of fund to send to the specified addresses.
731   function bulkTransfer(address[] _destinations, uint256[] _amounts) public onlyAdmin {
732     require(_destinations.length == _amounts.length);
733 
734     //Saving gas by determining if the sender has enough balance
735     //to post this transaction.
736     uint256 requiredBalance = sumOf(_amounts);
737     require(balances[msg.sender] >= requiredBalance);
738 
739     for (uint256 i = 0; i < _destinations.length; i++) {
740      transfer(_destinations[i], _amounts[i]);
741     }
742 
743     emit BulkTransferPerformed(_destinations, _amounts);
744   }
745 
746   ///@notice Burns the coins held by the sender.
747   ///@param _value The amount of coins to burn.
748   ///@dev This function is overriden to leverage Pausable feature.
749   function burn(uint256 _value) public whenNotPaused {
750     super.burn(_value);
751   }
752 }