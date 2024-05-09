1 pragma solidity ^0.4.18;
2 
3 
4 
5 /**
6  * @title Ownable
7  * @dev The Ownable contract has an owner address, and provides basic authorization control
8  * functions, this simplifies the implementation of "user permissions".
9  */
10 contract Ownable {
11   address public owner;
12 
13 
14   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
15 
16   /**
17    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
18    * account.
19    */
20   function Ownable() public {
21     owner = msg.sender;
22   }
23 
24   /**
25    * @dev Throws if called by any account other than the owner.
26    */
27   modifier onlyOwner() {
28     require(msg.sender == owner);
29     _;
30   }
31 
32   /**
33    * @dev Allows the current owner to transfer control of the contract to a newOwner.
34    * @param newOwner The address to transfer ownership to.
35    */
36   function transferOwnership(address newOwner) public onlyOwner {
37     require(newOwner != address(0));
38     OwnershipTransferred(owner, newOwner);
39     owner = newOwner;
40   }
41 
42 }
43 
44 /*
45  * Manager that stores permitted addresses 
46  */
47 contract PermissionManager is Ownable {
48     mapping (address => bool) permittedAddresses;
49 
50     function addAddress(address newAddress) public onlyOwner {
51         permittedAddresses[newAddress] = true;
52     }
53 
54     function removeAddress(address remAddress) public onlyOwner {
55         permittedAddresses[remAddress] = false;
56     }
57 
58     function isPermitted(address pAddress) public view returns(bool) {
59         if (permittedAddresses[pAddress]) {
60             return true;
61         }
62         return false;
63     }
64 }
65 
66 contract Registry is Ownable {
67 
68   struct ContributorData {
69     bool isActive;
70     uint contributionETH;
71     uint contributionUSD;
72     uint tokensIssued;
73     uint quoteUSD;
74     uint contributionRNTB;
75   }
76   mapping(address => ContributorData) public contributorList;
77   mapping(uint => address) private contributorIndexes;
78 
79   uint private nextContributorIndex;
80 
81   /* Permission manager contract */
82   PermissionManager public permissionManager;
83 
84   bool public completed;
85 
86   modifier onlyPermitted() {
87     require(permissionManager.isPermitted(msg.sender));
88     _;
89   }
90 
91   event ContributionAdded(address _contributor, uint overallEth, uint overallUSD, uint overallToken, uint quote);
92   event ContributionEdited(address _contributor, uint overallEth, uint overallUSD,  uint overallToken, uint quote);
93   function Registry(address pManager) public {
94     permissionManager = PermissionManager(pManager); 
95     completed = false;
96   }
97 
98   function setPermissionManager(address _permadr) public onlyOwner {
99     require(_permadr != 0x0);
100     permissionManager = PermissionManager(_permadr);
101   }
102 
103   function isActiveContributor(address contributor) public view returns(bool) {
104     return contributorList[contributor].isActive;
105   }
106 
107   function removeContribution(address contributor) public onlyPermitted {
108     contributorList[contributor].isActive = false;
109   }
110 
111   function setCompleted(bool compl) public onlyPermitted {
112     completed = compl;
113   }
114 
115   function addContribution(address _contributor, uint _amount, uint _amusd, uint _tokens, uint _quote ) public onlyPermitted {
116     
117     if (contributorList[_contributor].isActive == false) {
118         contributorList[_contributor].isActive = true;
119         contributorList[_contributor].contributionETH = _amount;
120         contributorList[_contributor].contributionUSD = _amusd;
121         contributorList[_contributor].tokensIssued = _tokens;
122         contributorList[_contributor].quoteUSD = _quote;
123 
124         contributorIndexes[nextContributorIndex] = _contributor;
125         nextContributorIndex++;
126     } else {
127       contributorList[_contributor].contributionETH += _amount;
128       contributorList[_contributor].contributionUSD += _amusd;
129       contributorList[_contributor].tokensIssued += _tokens;
130       contributorList[_contributor].quoteUSD = _quote;
131     }
132     ContributionAdded(_contributor, contributorList[_contributor].contributionETH, contributorList[_contributor].contributionUSD, contributorList[_contributor].tokensIssued, contributorList[_contributor].quoteUSD);
133   }
134 
135   function editContribution(address _contributor, uint _amount, uint _amusd, uint _tokens, uint _quote) public onlyPermitted {
136     if (contributorList[_contributor].isActive == true) {
137         contributorList[_contributor].contributionETH = _amount;
138         contributorList[_contributor].contributionUSD = _amusd;
139         contributorList[_contributor].tokensIssued = _tokens;
140         contributorList[_contributor].quoteUSD = _quote;
141     }
142      ContributionEdited(_contributor, contributorList[_contributor].contributionETH, contributorList[_contributor].contributionUSD, contributorList[_contributor].tokensIssued, contributorList[_contributor].quoteUSD);
143   }
144 
145   function addContributor(address _contributor, uint _amount, uint _amusd, uint _tokens, uint _quote) public onlyPermitted {
146     contributorList[_contributor].isActive = true;
147     contributorList[_contributor].contributionETH = _amount;
148     contributorList[_contributor].contributionUSD = _amusd;
149     contributorList[_contributor].tokensIssued = _tokens;
150     contributorList[_contributor].quoteUSD = _quote;
151     contributorIndexes[nextContributorIndex] = _contributor;
152     nextContributorIndex++;
153     ContributionAdded(_contributor, contributorList[_contributor].contributionETH, contributorList[_contributor].contributionUSD, contributorList[_contributor].tokensIssued, contributorList[_contributor].quoteUSD);
154  
155   }
156 
157   function getContributionETH(address _contributor) public view returns (uint) {
158       return contributorList[_contributor].contributionETH;
159   }
160 
161   function getContributionUSD(address _contributor) public view returns (uint) {
162       return contributorList[_contributor].contributionUSD;
163   }
164 
165   function getContributionRNTB(address _contributor) public view returns (uint) {
166       return contributorList[_contributor].contributionRNTB;
167   }
168 
169   function getContributionTokens(address _contributor) public view returns (uint) {
170       return contributorList[_contributor].tokensIssued;
171   }
172 
173   function addRNTBContribution(address _contributor, uint _amount) public onlyPermitted {
174     if (contributorList[_contributor].isActive == false) {
175         contributorList[_contributor].isActive = true;
176         contributorList[_contributor].contributionRNTB = _amount;
177         contributorIndexes[nextContributorIndex] = _contributor;
178         nextContributorIndex++;
179     } else {
180       contributorList[_contributor].contributionETH += _amount;
181     }
182   }
183 
184   function getContributorByIndex(uint index) public view  returns (address) {
185       return contributorIndexes[index];
186   }
187 
188   function getContributorAmount() public view returns(uint) {
189       return nextContributorIndex;
190   }
191 
192 }
193 
194 /**
195  * @title SafeMath
196  * @dev Math operations with safety checks that throw on error
197  */
198 library SafeMath {
199 
200   /**
201   * @dev Multiplies two numbers, throws on overflow.
202   */
203   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
204     if (a == 0) {
205       return 0;
206     }
207     uint256 c = a * b;
208     assert(c / a == b);
209     return c;
210   }
211 
212   /**
213   * @dev Integer division of two numbers, truncating the quotient.
214   */
215   function div(uint256 a, uint256 b) internal pure returns (uint256) {
216     // assert(b > 0); // Solidity automatically throws when dividing by 0
217     uint256 c = a / b;
218     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
219     return c;
220   }
221 
222   /**
223   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
224   */
225   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
226     assert(b <= a);
227     return a - b;
228   }
229 
230   /**
231   * @dev Adds two numbers, throws on overflow.
232   */
233   function add(uint256 a, uint256 b) internal pure returns (uint256) {
234     uint256 c = a + b;
235     assert(c >= a);
236     return c;
237   }
238 }
239 
240 /**
241  * @title Contract that will work with ERC223 tokens.
242  */
243  
244 contract ERC223ReceivingContract {
245 
246   struct TKN {
247     address sender;
248     uint value;
249     bytes data;
250     bytes4 sig;
251   }
252 
253   /**
254    * @dev Standard ERC223 function that will handle incoming token transfers.
255    *
256    * @param _from  Token sender address.
257    * @param _value Amount of tokens.
258    * @param _data  Transaction metadata.
259    */
260   function tokenFallback(address _from, uint _value, bytes _data) public pure {
261     TKN memory tkn;
262     tkn.sender = _from;
263     tkn.value = _value;
264     tkn.data = _data;
265     if(_data.length > 0) {
266       uint32 u = uint32(_data[3]) + (uint32(_data[2]) << 8) + (uint32(_data[1]) << 16) + (uint32(_data[0]) << 24);
267       tkn.sig = bytes4(u);
268     }
269 
270     /* tkn variable is analogue of msg variable of Ether transaction
271     *  tkn.sender is person who initiated this token transaction   (analogue of msg.sender)
272     *  tkn.value the number of tokens that were sent   (analogue of msg.value)
273     *  tkn.data is data of token transaction   (analogue of msg.data)
274     *  tkn.sig is 4 bytes signature of function
275     *  if data of token transaction is a function execution
276     */
277   }
278 
279 }
280 
281 contract ERC223Interface {
282   uint public totalSupply;
283   function balanceOf(address who) public view returns (uint);
284   function allowedAddressesOf(address who) public view returns (bool);
285   function getTotalSupply() public view returns (uint);
286 
287   function transfer(address to, uint value) public returns (bool ok);
288   function transfer(address to, uint value, bytes data) public returns (bool ok);
289   function transfer(address to, uint value, bytes data, string custom_fallback) public returns (bool ok);
290 
291   event Transfer(address indexed from, address indexed to, uint value, bytes data);
292   event TransferContract(address indexed from, address indexed to, uint value, bytes data);
293 }
294 
295 /**
296  * @title Unity Token is ERC223 token.
297  * @author Vladimir Kovalchuk
298  */
299 
300 contract UnityToken is ERC223Interface {
301   using SafeMath for uint;
302 
303   string public constant name = "Unity Token";
304   string public constant symbol = "UNT";
305   uint8 public constant decimals = 18;
306 
307 
308   /* The supply is initially 100UNT to the precision of 18 decimals */
309   uint public constant INITIAL_SUPPLY = 100000 * (10 ** uint(decimals));
310 
311   mapping(address => uint) balances; // List of user balances.
312   mapping(address => bool) allowedAddresses;
313 
314   modifier onlyOwner() {
315     require(msg.sender == owner);
316     _;
317   }
318 
319   function addAllowed(address newAddress) public onlyOwner {
320     allowedAddresses[newAddress] = true;
321   }
322 
323   function removeAllowed(address remAddress) public onlyOwner {
324     allowedAddresses[remAddress] = false;
325   }
326 
327 
328   address public owner;
329 
330   /* Constructor initializes the owner's balance and the supply  */
331   function UnityToken() public {
332     owner = msg.sender;
333     totalSupply = INITIAL_SUPPLY;
334     balances[owner] = INITIAL_SUPPLY;
335   }
336 
337   function getTotalSupply() public view returns (uint) {
338     return totalSupply;
339   }
340 
341   // Function that is called when a user or another contract wants to transfer funds .
342   function transfer(address _to, uint _value, bytes _data, string _custom_fallback) public returns (bool success) {
343     if (isContract(_to)) {
344       require(allowedAddresses[_to]);
345       if (balanceOf(msg.sender) < _value)
346         revert();
347 
348       balances[msg.sender] = balances[msg.sender].sub(_value);
349       balances[_to] = balances[_to].add(_value);
350       assert(_to.call.value(0)(bytes4(keccak256(_custom_fallback)), msg.sender, _value, _data));
351       TransferContract(msg.sender, _to, _value, _data);
352       return true;
353     }
354     else {
355       return transferToAddress(_to, _value, _data);
356     }
357   }
358 
359 
360   // Function that is called when a user or another contract wants to transfer funds .
361   function transfer(address _to, uint _value, bytes _data) public returns (bool success) {
362 
363     if (isContract(_to)) {
364       return transferToContract(_to, _value, _data);
365     } else {
366       return transferToAddress(_to, _value, _data);
367     }
368   }
369 
370   // Standard function transfer similar to ERC20 transfer with no _data .
371   // Added due to backwards compatibility reasons .
372   function transfer(address _to, uint _value) public returns (bool success) {
373     //standard function transfer similar to ERC20 transfer with no _data
374     //added due to backwards compatibility reasons
375     bytes memory empty;
376     if (isContract(_to)) {
377       return transferToContract(_to, _value, empty);
378     }
379     else {
380       return transferToAddress(_to, _value, empty);
381     }
382   }
383 
384   //assemble the given address bytecode. If bytecode exists then the _addr is a contract.
385   function isContract(address _addr) private view returns (bool is_contract) {
386     uint length;
387     assembly {
388     //retrieve the size of the code on target address, this needs assembly
389       length := extcodesize(_addr)
390     }
391     return (length > 0);
392   }
393 
394   //function that is called when transaction target is an address
395   function transferToAddress(address _to, uint _value, bytes _data) private returns (bool success) {
396     if (balanceOf(msg.sender) < _value)
397       revert();
398     balances[msg.sender] = balances[msg.sender].sub(_value);
399     balances[_to] = balances[_to].add(_value);
400     Transfer(msg.sender, _to, _value, _data);
401     return true;
402   }
403 
404   //function that is called when transaction target is a contract
405   function transferToContract(address _to, uint _value, bytes _data) private returns (bool success) {
406     require(allowedAddresses[_to]);
407     if (balanceOf(msg.sender) < _value)
408       revert();
409     balances[msg.sender] = balances[msg.sender].sub(_value);
410     balances[_to] = balances[_to].add(_value);
411     ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
412     receiver.tokenFallback(msg.sender, _value, _data);
413     TransferContract(msg.sender, _to, _value, _data);
414     return true;
415   }
416 
417 
418   function balanceOf(address _owner) public view returns (uint balance) {
419     return balances[_owner];
420   }
421 
422   function allowedAddressesOf(address _owner) public view returns (bool allowed) {
423     return allowedAddresses[_owner];
424   }
425 }
426 
427 /**
428  * @title Hold  contract.
429  * @author Vladimir Kovalchuk
430  */
431 contract Hold is Ownable {
432 
433     uint8 stages = 5;
434     uint8 public percentage;
435     uint8 public currentStage;
436     uint public initialBalance;
437     uint public withdrawed;
438     
439     address public multisig;
440     Registry registry;
441 
442     PermissionManager public permissionManager;
443     uint nextContributorToTransferEth;
444     address public observer;
445     uint dateDeployed;
446     mapping(address => bool) private hasWithdrawedEth;
447 
448     event InitialBalanceChanged(uint balance);
449     event EthReleased(uint ethreleased);
450     event EthRefunded(address contributor, uint ethrefunded);
451     event StageChanged(uint8 newStage);
452     event EthReturnedToOwner(address owner, uint balance);
453 
454     modifier onlyPermitted() {
455         require(permissionManager.isPermitted(msg.sender) || msg.sender == owner);
456         _;
457     }
458 
459     modifier onlyObserver() {
460         require(msg.sender == observer || msg.sender == owner);
461         _;
462     }
463 
464     function Hold(address _multisig, uint cap, address pm, address registryAddress, address observerAddr) public {
465         percentage = 100 / stages;
466         currentStage = 0;
467         multisig = _multisig;
468         initialBalance = cap;
469         dateDeployed = now;
470         permissionManager = PermissionManager(pm);
471         registry = Registry(registryAddress);
472         observer = observerAddr;
473     }
474 
475     function setPermissionManager(address _permadr) public onlyOwner {
476         require(_permadr != 0x0);
477         permissionManager = PermissionManager(_permadr);
478     }
479 
480     function setObserver(address observerAddr) public onlyOwner {
481         require(observerAddr != 0x0);
482         observer = observerAddr;
483     }
484 
485     function setInitialBalance(uint inBal) public {
486         initialBalance = inBal;
487         InitialBalanceChanged(inBal);
488     }
489 
490     function releaseAllETH() onlyPermitted public {
491         uint balReleased = getBalanceReleased();
492         require(balReleased > 0);
493         require(this.balance >= balReleased);
494         multisig.transfer(balReleased);
495         withdrawed += balReleased;
496         EthReleased(balReleased);
497     }
498 
499     function releaseETH(uint n) onlyPermitted public {
500         require(this.balance >= n);
501         require(getBalanceReleased() >= n);
502         multisig.transfer(n);
503         withdrawed += n;
504         EthReleased(n);
505     } 
506 
507     function getBalance() public view returns (uint) {
508         return this.balance;
509     }
510 
511     function changeStageAndReleaseETH() public onlyObserver {
512         uint8 newStage = currentStage + 1;
513         require(newStage <= stages);
514         currentStage = newStage;
515         StageChanged(newStage);
516         releaseAllETH();
517     }
518 
519     function changeStage() public onlyObserver {
520         uint8 newStage = currentStage + 1;
521         require(newStage <= stages);
522         currentStage = newStage;
523         StageChanged(newStage);
524     }
525 
526     function getBalanceReleased() public view returns (uint) {
527         return initialBalance * percentage * currentStage / 100 - withdrawed ;
528     }
529 
530     function returnETHByOwner() public onlyOwner {
531         require(now > dateDeployed + 183 days);
532         uint balance = getBalance();
533         owner.transfer(getBalance());
534         EthReturnedToOwner(owner, balance);
535     }
536 
537     function refund(uint _numberOfReturns) public onlyOwner {
538         require(_numberOfReturns > 0);
539         address currentParticipantAddress;
540 
541         for (uint cnt = 0; cnt < _numberOfReturns; cnt++) {
542             currentParticipantAddress = registry.getContributorByIndex(nextContributorToTransferEth);
543             if (currentParticipantAddress == 0x0) 
544                 return;
545 
546             if (!hasWithdrawedEth[currentParticipantAddress]) {
547                 uint EthAmount = registry.getContributionETH(currentParticipantAddress);
548                 EthAmount -=  EthAmount * (percentage / 100 * currentStage);
549 
550                 currentParticipantAddress.transfer(EthAmount);
551                 EthRefunded(currentParticipantAddress, EthAmount);
552                 hasWithdrawedEth[currentParticipantAddress] = true;
553             }
554             nextContributorToTransferEth += 1;
555         }
556         
557     }  
558 
559     function() public payable {
560 
561     }
562 
563   function getWithdrawed(address contrib) public onlyPermitted view returns (bool) {
564     return hasWithdrawedEth[contrib];
565   }
566 }