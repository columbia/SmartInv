1 pragma solidity ^0.4.15;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9   address public owner;
10 
11 
12   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
13 
14 
15   /**
16    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
17    * account.
18    */
19   function Ownable() {
20     owner = msg.sender;
21   }
22 
23 
24   /**
25    * @dev Throws if called by any account other than the owner.
26    */
27   modifier onlyOwner() {
28     require(msg.sender == owner);
29     _;
30   }
31 
32 
33   /**
34    * @dev Allows the current owner to transfer control of the contract to a newOwner.
35    * @param newOwner The address to transfer ownership to.
36    */
37   function transferOwnership(address newOwner) onlyOwner public {
38     require(newOwner != address(0));
39     OwnershipTransferred(owner, newOwner);
40     owner = newOwner;
41   }
42 
43 }
44 
45 /**
46  * @title Pausable
47  * @dev Base contract which allows children to implement an emergency stop mechanism.
48  */
49 contract Pausable is Ownable {
50   event Pause();
51   event Unpause();
52 
53   bool public paused = false;
54 
55 
56   /**
57    * @dev Modifier to make a function callable only when the contract is not paused.
58    */
59   modifier whenNotPaused() {
60     require(!paused);
61     _;
62   }
63 
64   /**
65    * @dev Modifier to make a function callable only when the contract is paused.
66    */
67   modifier whenPaused() {
68     require(paused);
69     _;
70   }
71 
72   /**
73    * @dev called by the owner to pause, triggers stopped state
74    */
75   function pause() onlyOwner whenNotPaused public {
76     paused = true;
77     Pause();
78   }
79 
80   /**
81    * @dev called by the owner to unpause, returns to normal state
82    */
83   function unpause() onlyOwner whenPaused public {
84     paused = false;
85     Unpause();
86   }
87 }
88 
89 /**
90  * @title ERC20Basic
91  * @dev Simpler version of ERC20 interface
92  * @dev see https://github.com/ethereum/EIPs/issues/179
93  */
94 contract ERC20Basic {
95   uint256 public totalSupply;
96   function balanceOf(address who) public constant returns (uint256);
97   function transfer(address to, uint256 value) public returns (bool);
98   event Transfer(address indexed from, address indexed to, uint256 value);
99 }
100 
101 /**
102  * @title ERC20 interface
103  * @dev see https://github.com/ethereum/EIPs/issues/20
104  */
105 contract ERC20 is ERC20Basic {
106   function allowance(address owner, address spender) public constant returns (uint256);
107   function transferFrom(address from, address to, uint256 value) public returns (bool);
108   function approve(address spender, uint256 value) public returns (bool);
109   event Approval(address indexed owner, address indexed spender, uint256 value);
110 }
111 
112 /**
113  * @title Basic token
114  * @dev Basic version of StandardToken, with no allowances.
115  */
116 contract BasicToken is ERC20Basic {
117   using SafeMath for uint256;
118 
119   mapping(address => uint256) balances;
120 
121   /**
122   * @dev transfer token for a specified address
123   * @param _to The address to transfer to.
124   * @param _value The amount to be transferred.
125   */
126   function transfer(address _to, uint256 _value) public returns (bool) {
127     require(_to != address(0));
128 
129     // SafeMath.sub will throw if there is not enough balance.
130     balances[msg.sender] = balances[msg.sender].sub(_value);
131     balances[_to] = balances[_to].add(_value);
132     Transfer(msg.sender, _to, _value);
133     return true;
134   }
135 
136   /**
137   * @dev Gets the balance of the specified address.
138   * @param _owner The address to query the the balance of.
139   * @return An uint256 representing the amount owned by the passed address.
140   */
141   function balanceOf(address _owner) public constant returns (uint256 balance) {
142     return balances[_owner];
143   }
144 
145 }
146 contract StandardToken is ERC20, BasicToken {
147 
148   mapping (address => mapping (address => uint256)) allowed;
149 
150 
151   /**
152    * @dev Transfer tokens from one address to another
153    * @param _from address The address which you want to send tokens from
154    * @param _to address The address which you want to transfer to
155    * @param _value uint256 the amount of tokens to be transferred
156    */
157   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
158     require(_to != address(0));
159 
160     uint256 _allowance = allowed[_from][msg.sender];
161 
162     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
163     // require (_value <= _allowance);
164 
165     balances[_from] = balances[_from].sub(_value);
166     balances[_to] = balances[_to].add(_value);
167     allowed[_from][msg.sender] = _allowance.sub(_value);
168     Transfer(_from, _to, _value);
169     return true;
170   }
171 
172   /**
173    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
174    *
175    * Beware that changing an allowance with this method brings the risk that someone may use both the old
176    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
177    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
178    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
179    * @param _spender The address which will spend the funds.
180    * @param _value The amount of tokens to be spent.
181    */
182   function approve(address _spender, uint256 _value) public returns (bool) {
183     allowed[msg.sender][_spender] = _value;
184     Approval(msg.sender, _spender, _value);
185     return true;
186   }
187 
188   /**
189    * @dev Function to check the amount of tokens that an owner allowed to a spender.
190    * @param _owner address The address which owns the funds.
191    * @param _spender address The address which will spend the funds.
192    * @return A uint256 specifying the amount of tokens still available for the spender.
193    */
194   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
195     return allowed[_owner][_spender];
196   }
197 
198   /**
199    * approve should be called when allowed[_spender] == 0. To increment
200    * allowed value is better to use this function to avoid 2 calls (and wait until
201    * the first transaction is mined)
202    * From MonolithDAO Token.sol
203    */
204   function increaseApproval (address _spender, uint _addedValue)
205     returns (bool success) {
206     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
207     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
208     return true;
209   }
210 
211   function decreaseApproval (address _spender, uint _subtractedValue)
212     returns (bool success) {
213     uint oldValue = allowed[msg.sender][_spender];
214     if (_subtractedValue > oldValue) {
215       allowed[msg.sender][_spender] = 0;
216     } else {
217       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
218     }
219     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
220     return true;
221   }
222 
223 }
224 
225 
226 /**
227  * @title Math
228  * @dev Assorted math operations
229  */
230 
231 library Math {
232   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
233     return a >= b ? a : b;
234   }
235 
236   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
237     return a < b ? a : b;
238   }
239 
240   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
241     return a >= b ? a : b;
242   }
243 
244   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
245     return a < b ? a : b;
246   }
247 }
248 
249 /**
250  * @title SafeMath
251  * @dev Math operations with safety checks that throw on error
252  */
253 library SafeMath {
254   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
255     uint256 c = a * b;
256     assert(a == 0 || c / a == b);
257     return c;
258   }
259 
260   function div(uint256 a, uint256 b) internal constant returns (uint256) {
261     // assert(b > 0); // Solidity automatically throws when dividing by 0
262     uint256 c = a / b;
263     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
264     return c;
265   }
266 
267   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
268     assert(b <= a);
269     return a - b;
270   }
271 
272   function add(uint256 a, uint256 b) internal constant returns (uint256) {
273     uint256 c = a + b;
274     assert(c >= a);
275     return c;
276   }
277 }
278 
279  /*
280  * Contract that is working with ERC223 tokens
281  * This is an implementation of ContractReceiver provided here:
282  * https://github.com/Dexaran/ERC223-token-standard/blob/Recommended/Receiver_Interface.sol
283  */
284 
285  contract ContractReceiver {
286 
287     function tokenFallback(address _from, uint _value, bytes _data);
288 
289 }
290 /*
291     Copyright 2016, Jordi Baylina
292 
293     This program is free software: you can redistribute it and/or modify
294     it under the terms of the GNU General Public License as published by
295     the Free Software Foundation, either version 3 of the License, or
296     (at your option) any later version.
297 
298     This program is distributed in the hope that it will be useful,
299     but WITHOUT ANY WARRANTY; without even the implied warranty of
300     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
301     GNU General Public License for more details.
302 
303     You should have received a copy of the GNU General Public License
304     along with this program.  If not, see <http://www.gnu.org/licenses/>.
305  */
306 
307 /// @title MiniMeToken Contract
308 /// @author Jordi Baylina
309 /// @dev This token contract's goal is to make it easy for anyone to clone this
310 ///  token using the token distribution at a given block, this will allow DAO's
311 ///  and DApps to upgrade their features in a decentralized manner without
312 ///  affecting the original token
313 /// @dev It is ERC20 compliant, but still needs to under go further testing.
314 
315 
316 /// @dev The token controller contract must implement these functions
317 contract TokenController {
318     /// @notice Called when `_owner` sends ether to the MiniMe Token contract
319     /// @param _owner The address that sent the ether to create tokens
320     /// @return True if the ether is accepted, false if it throws
321     function proxyPayment(address _owner) payable returns(bool);
322 
323     /// @notice Notifies the controller about a token transfer allowing the
324     ///  controller to react if desired
325     /// @param _from The origin of the transfer
326     /// @param _to The destination of the transfer
327     /// @param _amount The amount of the transfer
328     /// @return False if the controller does not authorize the transfer
329     function onTransfer(address _from, address _to, uint _amount) returns(bool);
330 
331     /// @notice Notifies the controller about an approval allowing the
332     ///  controller to react if desired
333     /// @param _owner The address that calls `approve()`
334     /// @param _spender The spender in the `approve()` call
335     /// @param _amount The amount in the `approve()` call
336     /// @return False if the controller does not authorize the approval
337     function onApprove(address _owner, address _spender, uint _amount)
338         returns(bool);
339 }
340 
341 contract Controlled {
342     /// @notice The address of the controller is the only address that can call
343     ///  a function with this modifier
344     modifier onlyController { require(msg.sender == controller); _; }
345 
346     address public controller;
347 
348     function Controlled() { controller = msg.sender;}
349 
350     /// @notice Changes the controller of the contract
351     /// @param _newController The new controller of the contract
352     function changeController(address _newController) onlyController {
353         controller = _newController;
354     }
355 }
356 
357 /// @title SpecToken - Crowdfunding code for the Spectre.ai Token Sale
358 /// @author Parthasarathy Ramanujam
359 contract SpectreSubscriberToken is StandardToken, Pausable, TokenController {
360   using SafeMath for uint;
361 
362   string public constant name = "SPECTRE SUBSCRIBER TOKEN";
363   string public constant symbol = "SXS";
364   uint256 public constant decimals = 18;
365 
366   uint256 constant public TOKENS_AVAILABLE             = 240000000 * 10**decimals;
367   uint256 constant public BONUS_SLAB                   = 100000000 * 10**decimals;
368   uint256 constant public MIN_CAP                      = 5000000 * 10**decimals;
369   uint256 constant public MIN_FUND_AMOUNT              = 1 ether;
370   uint256 constant public TOKEN_PRICE                  = 0.0005 ether;
371   uint256 constant public WHITELIST_PERIOD             = 3 days;
372 
373   address public specWallet;
374   address public specDWallet;
375   address public specUWallet;
376 
377   bool public refundable = false;
378   bool public configured = false;
379   bool public tokenAddressesSet = false;
380   //presale start and end blocks
381   uint256 public presaleStart;
382   uint256 public presaleEnd;
383   //main sale start and end blocks
384   uint256 public saleStart;
385   uint256 public saleEnd;
386   //discount end block for main sale
387   uint256 public discountSaleEnd;
388 
389   //whitelisting
390   mapping(address => uint256) public whitelist;
391   uint256 constant D160 = 0x0010000000000000000000000000000000000000000;
392 
393   //bonus earned
394   mapping(address => uint256) public bonus;
395 
396   event Refund(address indexed _to, uint256 _value);
397   event ContractFunded(address indexed _from, uint256 _value, uint256 _total);
398   event Refundable();
399   event WhiteListSet(address indexed _subscriber, uint256 _value);
400   event OwnerTransfer(address indexed _from, address indexed _to, uint256 _value);
401 
402   modifier isRefundable() {
403     require(refundable);
404     _;
405   }
406 
407   modifier isNotRefundable() {
408     require(!refundable);
409     _;
410   }
411 
412   modifier isTransferable() {
413     require(tokenAddressesSet);
414     require(getNow() > saleEnd);
415     require(totalSupply >= MIN_CAP);
416     _;
417   }
418 
419   modifier onlyWalletOrOwner() {
420     require(msg.sender == owner || msg.sender == specWallet);
421     _;
422   }
423 
424   //@notice function to initilaize the token contract
425   //@notice _specWallet - The wallet that receives the proceeds from the token sale
426   //@notice _specDWallet - Wallet that would receive tokens chosen for dividend
427   //@notice _specUWallet - Wallet that would receive tokens chosen for utility
428   function SpectreSubscriberToken(address _specWallet) {
429     require(_specWallet != address(0));
430     specWallet = _specWallet;
431     pause();
432   }
433 
434   //@notice Fallback function that accepts the ether and allocates tokens to
435   //the msg.sender corresponding to msg.value
436   function() payable whenNotPaused public {
437     require(msg.value >= MIN_FUND_AMOUNT);
438     if(getNow() >= presaleStart && getNow() <= presaleEnd) {
439       purchasePresale();
440     } else if (getNow() >= saleStart && getNow() <= saleEnd) {
441       purchase();
442     } else {
443       revert();
444     }
445   }
446 
447   //@notice function to be used for presale purchase
448   function purchasePresale() internal {
449     //Only check whitelist for the first 3 days of presale
450     if (getNow() < (presaleStart + WHITELIST_PERIOD)) {
451       require(whitelist[msg.sender] > 0);
452       //Accept if the subsciber 95% to 120% of whitelisted amount
453       uint256 minAllowed = whitelist[msg.sender].mul(95).div(100);
454       uint256 maxAllowed = whitelist[msg.sender].mul(120).div(100);
455       require(msg.value >= minAllowed && msg.value <= maxAllowed);
456       //remove the address from whitelist
457       whitelist[msg.sender] = 0;
458     }
459 
460     uint256 numTokens = msg.value.mul(10**decimals).div(TOKEN_PRICE);
461     uint256 bonusTokens = 0;
462 
463     if(totalSupply < BONUS_SLAB) {
464       //Any portion of tokens less than BONUS_SLAB are eligable for 33% bonus, otherwise 22% bonus
465       uint256 remainingBonusSlabTokens = SafeMath.sub(BONUS_SLAB, totalSupply);
466       uint256 bonusSlabTokens = Math.min256(remainingBonusSlabTokens, numTokens);
467       uint256 nonBonusSlabTokens = SafeMath.sub(numTokens, bonusSlabTokens);
468       bonusTokens = bonusSlabTokens.mul(33).div(100);
469       bonusTokens = bonusTokens.add(nonBonusSlabTokens.mul(22).div(100));
470     } else {
471       //calculate 22% bonus for tokens purchased on presale
472       bonusTokens = numTokens.mul(22).div(100);
473     }
474     //
475     numTokens = numTokens.add(bonusTokens);
476     bonus[msg.sender] = bonus[msg.sender].add(bonusTokens);
477 
478     //transfer money to Spectre MultisigWallet (could be msg.value)
479     specWallet.transfer(msg.value);
480 
481     totalSupply = totalSupply.add(numTokens);
482     require(totalSupply <= TOKENS_AVAILABLE);
483 
484     balances[msg.sender] = balances[msg.sender].add(numTokens);
485     //fire the event notifying the transfer of tokens
486     Transfer(0, msg.sender, numTokens);
487 
488   }
489 
490   //@notice function to be used for mainsale purchase
491   function purchase() internal {
492 
493     uint256 numTokens = msg.value.mul(10**decimals).div(TOKEN_PRICE);
494     uint256 bonusTokens = 0;
495 
496     if(getNow() <= discountSaleEnd) {
497       //calculate 11% bonus for tokens purchased on discount period
498       bonusTokens = numTokens.mul(11).div(100);
499     }
500 
501     numTokens = numTokens.add(bonusTokens);
502     bonus[msg.sender] = bonus[msg.sender].add(bonusTokens);
503 
504     //transfer money to Spectre MultisigWallet
505     specWallet.transfer(msg.value);
506 
507     totalSupply = totalSupply.add(numTokens);
508 
509     require(totalSupply <= TOKENS_AVAILABLE);
510     balances[msg.sender] = balances[msg.sender].add(numTokens);
511     //fire the event notifying the transfer of tokens
512     Transfer(0, msg.sender, numTokens);
513   }
514 
515   //@notice Function reports the number of tokens available for sale
516   function numberOfTokensLeft() constant returns (uint256) {
517     return TOKENS_AVAILABLE.sub(totalSupply);
518   }
519 
520   //Override unpause function to only allow once configured
521   function unpause() onlyOwner whenPaused public {
522     require(configured);
523     paused = false;
524     Unpause();
525   }
526 
527   //@notice Function to configure contract addresses
528   //@param `_specUWallet` - address of Utility contract
529   //@param `_specDWallet` - address of Dividend contract
530   function setTokenAddresses(address _specUWallet, address _specDWallet) onlyOwner public {
531     require(!tokenAddressesSet);
532     require(_specDWallet != address(0));
533     require(_specUWallet != address(0));
534     require(isContract(_specDWallet));
535     require(isContract(_specUWallet));
536     specUWallet = _specUWallet;
537     specDWallet = _specDWallet;
538     tokenAddressesSet = true;
539     if (configured) {
540       unpause();
541     }
542   }
543 
544   //@notice Function to configure contract parameters
545   //@param `_startPresaleBlock` - block from when presale begins.
546   //@param `_endPresaleBlock` - block from when presale ends.
547   //@param `_saleStart` - block from when main sale begins.
548   //@param `_saleEnd` - block from when main sale ends.
549   //@param `_discountEnd` - block from when the discounts would end.
550   //@notice Can be called only when funding is not active and only by the owner
551   function configure(uint256 _presaleStart, uint256 _presaleEnd, uint256 _saleStart, uint256 _saleEnd, uint256 _discountSaleEnd) onlyOwner public {
552     require(!configured);
553     require(_presaleStart > getNow());
554     require(_presaleEnd > _presaleStart);
555     require(_saleStart > _presaleEnd);
556     require(_saleEnd > _saleStart);
557     require(_discountSaleEnd > _saleStart && _discountSaleEnd <= _saleEnd);
558     presaleStart = _presaleStart;
559     presaleEnd = _presaleEnd;
560     saleStart = _saleStart;
561     saleEnd = _saleEnd;
562     discountSaleEnd = _discountSaleEnd;
563     configured = true;
564     if (tokenAddressesSet) {
565       unpause();
566     }
567   }
568 
569   //@notice Function that can be called by purchasers to refund
570   //@notice Used only in case the ICO isn't successful.
571   function refund() isRefundable public {
572     require(balances[msg.sender] > 0);
573 
574     uint256 tokenValue = balances[msg.sender].sub(bonus[msg.sender]);
575     balances[msg.sender] = 0;
576     tokenValue = tokenValue.mul(TOKEN_PRICE).div(10**decimals);
577 
578     //transfer to the requesters wallet
579     msg.sender.transfer(tokenValue);
580     Refund(msg.sender, tokenValue);
581   }
582 
583   function withdrawEther() public isNotRefundable onlyOwner {
584     //In case ether is sent, even though not refundable
585     msg.sender.transfer(this.balance);
586   }
587 
588   //@notice Function used for funding in case of refund.
589   //@notice Can be called only by the Owner or Wallet
590   function fundContract() public payable onlyWalletOrOwner {
591     //does nothing just accepts and stores the ether
592     ContractFunded(msg.sender, msg.value, this.balance);
593   }
594 
595   function setRefundable() onlyOwner {
596     require(this.balance > 0);
597     require(getNow() > saleEnd);
598     require(totalSupply < MIN_CAP);
599     Refundable();
600     refundable = true;
601   }
602 
603   //@notice Standard function transfer similar to ERC20 transfer with no _data .
604   //@notice Added due to backwards compatibility reasons .
605   function transfer(address _to, uint256 _value) isTransferable returns (bool success) {
606     //standard function transfer similar to ERC20 transfer with no _data
607     //added due to backwards compatibility reasons
608     require(_to == specDWallet || _to == specUWallet);
609     require(isContract(_to));
610     bytes memory empty;
611     return transferToContract(msg.sender, _to, _value, empty);
612   }
613 
614   //@notice assemble the given address bytecode. If bytecode exists then the _addr is a contract.
615   function isContract(address _addr) private returns (bool is_contract) {
616     uint256 length;
617     assembly {
618       //retrieve the size of the code on target address, this needs assembly
619       length := extcodesize(_addr)
620     }
621     return (length>0);
622   }
623 
624   //@notice function that is called when transaction target is a contract
625   function transferToContract(address _from, address _to, uint256 _value, bytes _data) internal returns (bool success) {
626     require(balanceOf(_from) >= _value);
627     balances[_from] = balanceOf(_from).sub(_value);
628     balances[_to] = balanceOf(_to).add(_value);
629     ContractReceiver receiver = ContractReceiver(_to);
630     receiver.tokenFallback(_from, _value, _data);
631     Transfer(_from, _to, _value);
632     return true;
633   }
634 
635   /**
636    * @dev Transfer tokens from one address to another - needed for owner transfers
637    * @param _from address The address which you want to send tokens from
638    * @param _to address The address which you want to transfer to
639    * @param _value uint256 the amount of tokens to be transferred
640    */
641   function transferFrom(address _from, address _to, uint256 _value) public isTransferable returns (bool) {
642     require(_to == specDWallet || _to == specUWallet);
643     require(isContract(_to));
644     //owner can transfer tokens on behalf of users after 28 days
645     if (msg.sender == owner && getNow() > saleEnd + 28 days) {
646       OwnerTransfer(_from, _to, _value);
647     } else {
648       uint256 _allowance = allowed[_from][msg.sender];
649       allowed[_from][msg.sender] = _allowance.sub(_value);
650     }
651 
652     //Now make the transfer
653     bytes memory empty;
654     return transferToContract(_from, _to, _value, empty);
655 
656   }
657 
658   //@notice function that is used for whitelisting an address
659   function setWhiteList(address _subscriber, uint256 _amount) public onlyOwner {
660     require(_subscriber != address(0));
661     require(_amount != 0);
662     whitelist[_subscriber] = _amount;
663     WhiteListSet(_subscriber, _amount);
664   }
665 
666   // data is an array of uint256s. Each uint256 represents a address and amount.
667   // The 160 LSB is the address that wants to be added
668   // The 96 MSB is the amount of to be set for the whitelist for that address
669   function multiSetWhiteList(uint256[] data) public onlyOwner {
670     for (uint256 i = 0; i < data.length; i++) {
671       address addr = address(data[i] & (D160 - 1));
672       uint256 amount = data[i] / D160;
673       setWhiteList(addr, amount);
674     }
675   }
676 
677   /////////////////
678   // TokenController interface
679   /////////////////
680 
681   /// @notice `proxyPayment()` returns false, meaning ether is not accepted at
682   ///  the token address, only the address of FiinuCrowdSale
683   /// @param _owner The address that will hold the newly created tokens
684 
685   function proxyPayment(address _owner) payable returns(bool) {
686       return false;
687   }
688 
689   /// @notice Notifies the controller about a transfer, for this Campaign all
690   ///  transfers are allowed by default and no extra notifications are needed
691   /// @param _from The origin of the transfer
692   /// @param _to The destination of the transfer
693   /// @param _amount The amount of the transfer
694   /// @return False if the controller does not authorize the transfer
695   function onTransfer(address _from, address _to, uint _amount) returns(bool) {
696       return true;
697   }
698 
699   /// @notice Notifies the controller about an approval, for this Campaign all
700   ///  approvals are allowed by default and no extra notifications are needed
701   /// @param _owner The address that calls `approve()`
702   /// @param _spender The spender in the `approve()` call
703   /// @param _amount The amount in the `approve()` call
704   /// @return False if the controller does not authorize the approval
705   function onApprove(address _owner, address _spender, uint _amount)
706       returns(bool)
707   {
708       return true;
709   }
710 
711   function getNow() constant internal returns (uint256) {
712     return now;
713   }
714 
715 }