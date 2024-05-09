1 pragma solidity ^0.4.23;
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
19   function Ownable() public {
20     owner = msg.sender;
21   }
22 
23   /**
24    * @dev Throws if called by any account other than the owner.
25    */
26   modifier onlyOwner() {
27     require(msg.sender == owner);
28     _;
29   }
30 
31   /**
32    * @dev Allows the current owner to transfer control of the contract to a newOwner.
33    * @param newOwner The address to transfer ownership to.
34    */
35   function transferOwnership(address newOwner) public onlyOwner {
36     require(newOwner != address(0));
37     OwnershipTransferred(owner, newOwner);
38     owner = newOwner;
39   }
40 
41 }
42 
43 /*
44  * ERC20 interface
45  * see https://github.com/ethereum/EIPs/issues/20
46  */
47 contract ERC20 {
48   uint public totalSupply;
49   function balanceOf(address who) constant returns (uint);
50   function allowance(address owner, address spender) constant returns (uint);
51 
52   function transfer(address to, uint value) returns (bool ok);
53   function transferFrom(address from, address to, uint value) returns (bool ok);
54   function approve(address spender, uint value) returns (bool ok);
55   event Transfer(address indexed from, address indexed to, uint value);
56   event Approval(address indexed owner, address indexed spender, uint value);
57 }
58 
59 
60 contract ERC223 is ERC20 {
61   function transfer(address to, uint value, bytes data) returns (bool ok);
62   function transferFrom(address from, address to, uint value, bytes data) returns (bool ok);
63 }
64 
65 
66 
67 /*
68 Base class contracts willing to accept ERC223 token transfers must conform to.
69 
70 Sender: msg.sender to the token contract, the address originating the token transfer.
71           - For user originated transfers sender will be equal to tx.origin
72           - For contract originated transfers, tx.origin will be the user that made the tx that produced the transfer.
73 Origin: the origin address from whose balance the tokens are sent
74           - For transfer(), origin = msg.sender
75           - For transferFrom() origin = _from to token contract
76 Value is the amount of tokens sent
77 Data is arbitrary data sent with the token transfer. Simulates ether tx.data
78 
79 From, origin and value shouldn't be trusted unless the token contract is trusted.
80 If sender == tx.origin, it is safe to trust it regardless of the token.
81 */
82 
83 contract ERC223Receiver {
84   function tokenFallback(address _sender, address _origin, uint _value, bytes _data) returns (bool ok);
85 }
86 
87 
88 
89 
90 
91 
92 
93 /**
94  * Math operations with safety checks
95  */
96 contract SafeMath {
97   function safeMul(uint a, uint b) internal returns (uint) {
98     uint c = a * b;
99     assert(a == 0 || c / a == b);
100     return c;
101   }
102 
103   function safeDiv(uint a, uint b) internal returns (uint) {
104     assert(b > 0);
105     uint c = a / b;
106     assert(a == b * c + a % b);
107     return c;
108   }
109 
110   function safeSub(uint a, uint b) internal returns (uint) {
111     assert(b <= a);
112     return a - b;
113   }
114 
115   function safeAdd(uint a, uint b) internal returns (uint) {
116     uint c = a + b;
117     assert(c>=a && c>=b);
118     return c;
119   }
120 
121   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
122     return a >= b ? a : b;
123   }
124 
125   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
126     return a < b ? a : b;
127   }
128 
129   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
130     return a >= b ? a : b;
131   }
132 
133   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
134     return a < b ? a : b;
135   }
136 
137   /*function assert(bool assertion) internal {
138     if (!assertion) {
139       throw;
140     }
141   }*/
142 }
143 
144 
145 /**
146  * Standard ERC20 token
147  *
148  * https://github.com/ethereum/EIPs/issues/20
149  * Based on code by FirstBlood:
150  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
151  */
152 contract StandardToken is ERC20, SafeMath {
153   mapping(address => uint) balances;
154   mapping (address => mapping (address => uint)) allowed;
155   function transfer(address _to, uint _value) returns (bool success) {
156     require(_to != address(0));
157     require(_value <= balances[msg.sender]);
158     balances[msg.sender] = safeSub(balances[msg.sender], _value);
159     balances[_to] = safeAdd(balances[_to], _value);
160     Transfer(msg.sender, _to, _value);
161     return true;
162   }
163   function transferFrom(address _from, address _to, uint _value) returns (bool success) {
164     var _allowance = allowed[_from][msg.sender];
165     // Check is not needed because safeSub(_allowance, _value) will already throw if this condition is not met
166     // if (_value > _allowance) throw;
167     balances[_to] = safeAdd(balances[_to], _value);
168     balances[_from] = safeSub(balances[_from], _value);
169     allowed[_from][msg.sender] = safeSub(_allowance, _value);
170     Transfer(_from, _to, _value);
171     return true;
172   }
173   function balanceOf(address _owner) constant returns (uint balance) {
174     return balances[_owner];
175   }
176   function approve(address _spender, uint _value) returns (bool success) {
177     allowed[msg.sender][_spender] = _value;
178     Approval(msg.sender, _spender, _value);
179     return true;
180   }
181   function allowance(address _owner, address _spender) constant returns (uint remaining) {
182     return allowed[_owner][_spender];
183   }
184 }
185 
186 contract KinguinKrowns is ERC223, StandardToken {
187   address public owner;  // token owner adddres
188   string public constant name = "PINGUINS";
189   string public constant symbol = "PGS";
190   uint8 public constant decimals = 18;
191   // uint256 public totalSupply; // defined in ERC20 contract
192 		
193   function KinguinKrowns() {
194 	owner = msg.sender;
195     totalSupply = 100000000 * (10**18); // 100 mln
196     balances[msg.sender] = totalSupply;
197   } 
198   
199   /*
200   //only do if call is from owner modifier
201   modifier onlyOwner() {
202     if (msg.sender != owner) throw;
203     _;
204   }*/
205   
206   //function that is called when a user or another contract wants to transfer funds
207   function transfer(address _to, uint _value, bytes _data) returns (bool success) {
208     //filtering if the target is a contract with bytecode inside it
209     if (!super.transfer(_to, _value)) throw; // do a normal token transfer
210     if (isContract(_to)) return contractFallback(msg.sender, _to, _value, _data);
211     return true;
212   }
213 
214   function transferFrom(address _from, address _to, uint _value, bytes _data) returns (bool success) {
215     if (!super.transferFrom(_from, _to, _value)) throw; // do a normal token transfer
216     if (isContract(_to)) return contractFallback(_from, _to, _value, _data);
217     return true;
218   }
219 
220   function transfer(address _to, uint _value) returns (bool success) {
221     return transfer(_to, _value, new bytes(0));
222   }
223 
224   function transferFrom(address _from, address _to, uint _value) returns (bool success) {
225     return transferFrom(_from, _to, _value, new bytes(0));
226   }
227 
228   //function that is called when transaction target is a contract
229   function contractFallback(address _origin, address _to, uint _value, bytes _data) private returns (bool success) {
230     ERC223Receiver receiver = ERC223Receiver(_to);
231     return receiver.tokenFallback(msg.sender, _origin, _value, _data);
232   }
233 
234   //assemble the given address bytecode. If bytecode exists then the _addr is a contract.
235   function isContract(address _addr) private returns (bool is_contract) {
236     // retrieve the size of the code on target address, this needs assembly
237     uint length;
238     assembly { length := extcodesize(_addr) }
239     return length > 0;
240   }
241   
242   // returns krown balance of given address 	
243   function balanceOf(address _owner) constant returns (uint balance) {
244     return balances[_owner];
245   }
246 	
247 }
248 
249 contract KinguinIco is SafeMath, ERC223Receiver {
250   address constant public superOwner = 0xcEbb7454429830C92606836350569A17207dA857;
251   address public owner;             // contract owner address
252   address public api;               // address of api manager
253   KinguinKrowns public krs;     // handler to KRS token contract
254   
255   // rounds data storage:
256   struct IcoRoundData {
257     uint rMinEthPayment;            // set minimum ETH payment
258     uint rKrsUsdFixed;              // set KRS/USD fixed ratio for calculation of krown amount to be sent, 
259     uint rKycTreshold;              // KYC treshold in EUR (needed for check whether incoming payment requires KYC/AML verified address)
260     uint rMinKrsCap;                // minimum amount of KRS to be sent during a round
261     uint rMaxKrsCap;                // maximum amount of KRS to be sent during a round
262     uint rStartBlock;               // number of blockchain start block for a round
263     uint rEndBlock;                 // number of blockchain end block for a round
264     uint rEthPaymentsAmount;        // sum of ETH tokens received from participants during a round
265     uint rEthPaymentsCount;         // counter of ETH payments during a round 
266     uint rSentKrownsAmount;         // sum of ETH tokens received from participants during a round
267     uint rSentKrownsCount;          // counter of KRS transactions during a round
268     bool roundCompleted;            // flag whether a round has finished
269   }
270   mapping(uint => IcoRoundData) public icoRounds;  // table of rounds data: ico number, ico record
271   
272   mapping(address => bool) public allowedAdresses; // list of KYC/AML approved wallets: participant address, allowed/not allowed
273   
274   struct RoundPayments {            // structure for storing sum of payments
275     uint round;
276     uint amount;
277   }
278   // amount of payments from the same address during each round 
279   //  (to catch multiple payments to check KYC/AML approvance): participant address, payments record
280   mapping(address => RoundPayments) public paymentsFromAddress; 
281 
282   uint public ethEur;               // current EUR/ETH exchange rate (for AML check)
283   uint public ethUsd;               // current ETH/USD exchange rate (sending KRS for ETH calc) 
284   uint public krsUsd;               // current KRS/USD exchange rate (sending KRS for ETH calc)
285   uint public rNo;                  // counter for rounds
286   bool public icoInProgress;        // ico status flag
287   bool public apiAccessDisabled;    // api access security flag
288   
289   event LogReceivedEth(address from, uint value, uint block); // publish an event about incoming ETH
290   event LogSentKrs(address to, uint value, uint block); // publish an event about sent KRS
291 
292   // execution allowed only for contract superowner
293   modifier onlySuperOwner() {
294 	require(msg.sender == superOwner);
295     _;
296   }
297 
298   // execution allowed only for contract owner
299   modifier onlyOwner() {
300 	require(msg.sender == owner);
301     _;
302   }
303   
304   // execution allowed only for contract owner or api address
305   modifier onlyOwnerOrApi() {
306 	require(msg.sender == owner || msg.sender == api);
307     if (msg.sender == api && api != owner) {
308       require(!apiAccessDisabled);
309 	}
310     _;
311   }
312  
313   function KinguinIco() {
314     owner = msg.sender; // this contract owner
315     api = msg.sender; // initially api address is the contract owner's address 
316     krs = KinguinKrowns(0xdfb410994b66778bd6cc2c82e8ffe4f7b2870006); // KRS token 
317   } 
318  
319   // receiving ETH and sending KRS
320   function () payable {
321     if(msg.sender != owner) { // if ETH comes from other than the contract owner address
322       if(block.number >= icoRounds[rNo].rStartBlock && block.number <= icoRounds[rNo].rEndBlock && !icoInProgress) {
323         icoInProgress = true;
324       }  
325       require(block.number >= icoRounds[rNo].rStartBlock && block.number <= icoRounds[rNo].rEndBlock && !icoRounds[rNo].roundCompleted); // allow payments only during the ico round
326       require(msg.value >= icoRounds[rNo].rMinEthPayment); // minimum eth payment
327 	  require(ethEur > 0); // ETH/EUR rate for AML must be set earlier
328 	  require(ethUsd > 0); // ETH/USD rate for conversion to KRS
329 	  uint krowns4eth;
330 	  if(icoRounds[rNo].rKrsUsdFixed > 0) { // KRS has fixed ratio to USD
331         krowns4eth = safeDiv(safeMul(safeMul(msg.value, ethUsd), uint(100)), icoRounds[rNo].rKrsUsdFixed);
332 	  } else { // KRS/USD is traded on exchanges
333 		require(krsUsd > 0); // KRS/USD rate for conversion to KRS
334         krowns4eth = safeDiv(safeMul(safeMul(msg.value, ethUsd), uint(100)), krsUsd);
335   	  }
336       require(safeAdd(icoRounds[rNo].rSentKrownsAmount, krowns4eth) <= icoRounds[rNo].rMaxKrsCap); // krs cap per round
337 
338       if(paymentsFromAddress[msg.sender].round != rNo) { // on mappings all keys are possible, so there is no checking for its existence
339         paymentsFromAddress[msg.sender].round = rNo; // on new round set to current round
340         paymentsFromAddress[msg.sender].amount = 0; // zeroing amount on new round
341       }   
342       if(safeMul(ethEur, safeDiv(msg.value, 10**18)) >= icoRounds[rNo].rKycTreshold || // if payment from this sender requires to be from KYC/AML approved address
343         // if sum of payments from this sender address requires to be from KYC/AML approved address
344         safeMul(ethEur, safeDiv(safeAdd(paymentsFromAddress[msg.sender].amount, msg.value), 10**18)) >= icoRounds[rNo].rKycTreshold) { 
345 		require(allowedAdresses[msg.sender]); // only KYC/AML allowed address
346       }
347 
348       icoRounds[rNo].rEthPaymentsAmount = safeAdd(icoRounds[rNo].rEthPaymentsAmount, msg.value);
349       icoRounds[rNo].rEthPaymentsCount += 1; 
350       paymentsFromAddress[msg.sender].amount = safeAdd(paymentsFromAddress[msg.sender].amount, msg.value);
351       LogReceivedEth(msg.sender, msg.value, block.number);
352       icoRounds[rNo].rSentKrownsAmount = safeAdd(icoRounds[rNo].rSentKrownsAmount, krowns4eth);
353       icoRounds[rNo].rSentKrownsCount += 1;
354       krs.transfer(msg.sender, krowns4eth);
355       LogSentKrs(msg.sender, krowns4eth, block.number);
356     } else { // owner can always pay-in (and trigger round start/stop)
357 	    if(block.number >= icoRounds[rNo].rStartBlock && block.number <= icoRounds[rNo].rEndBlock && !icoInProgress) {
358           icoInProgress = true;
359         }
360         if(block.number > icoRounds[rNo].rEndBlock && icoInProgress) {
361           endIcoRound();
362         }
363     }
364   }
365 
366   // receiving tokens other than ETH
367   
368   // ERC223 receiver implementation - https://github.com/aragon/ERC23/blob/master/contracts/implementation/Standard223Receiver.sol
369   Tkn tkn;
370 
371   struct Tkn {
372     address addr;
373     address sender;
374     address origin;
375     uint256 value;
376     bytes data;
377     bytes4 sig;
378   }
379 
380   function tokenFallback(address _sender, address _origin, uint _value, bytes _data) returns (bool ok) {
381     if (!supportsToken(msg.sender)) return false;
382     return true;
383   }
384 
385   function getSig(bytes _data) private returns (bytes4 sig) {
386     uint l = _data.length < 4 ? _data.length : 4;
387     for (uint i = 0; i < l; i++) {
388       sig = bytes4(uint(sig) + uint(_data[i]) * (2 ** (8 * (l - 1 - i))));
389     }
390   }
391 
392   bool __isTokenFallback;
393 
394   modifier tokenPayable {
395     if (!__isTokenFallback) throw;
396     _;
397   }
398   
399   function supportsToken(address token) returns (bool) {
400     if (token == address(krs)) {
401 	  return true; 
402     } else {
403       revert();
404 	}
405   }
406   // end of ERC223 receiver implementation ------------------------------------
407 
408 
409   // set up a new ico round  
410   function newIcoRound(uint _rMinEthPayment, uint _rKrsUsdFixed, uint _rKycTreshold,
411     uint _rMinKrsCap, uint _rMaxKrsCap, uint _rStartBlock, uint _rEndBlock) public onlyOwner {
412     require(!icoInProgress);            // new round can be set up only after finished/cancelled the active one
413     require(rNo < 25);                  // limit of 25 rounds (with pre-ico)
414 	rNo += 1;                           // increment round number, pre-ico has number 1
415 	icoRounds[rNo] = IcoRoundData(_rMinEthPayment, _rKrsUsdFixed, _rKycTreshold, _rMinKrsCap, _rMaxKrsCap, 
416 	  _rStartBlock, _rEndBlock, 0, 0, 0, 0, false); // rEthPaymentsAmount, rEthPaymentsCount, rSentKrownsAmount, rSentKrownsCount); 
417   }
418   
419   // remove current round, params only - it does not refund any ETH!
420   function removeCurrentIcoRound() public onlyOwner {
421     require(icoRounds[rNo].rEthPaymentsAmount == 0); // only if there was no payment already
422 	require(!icoRounds[rNo].roundCompleted); // only current round can be removed
423     icoInProgress = false;
424     icoRounds[rNo].rMinEthPayment = 0;
425     icoRounds[rNo].rKrsUsdFixed = 0;
426     icoRounds[rNo].rKycTreshold = 0;
427     icoRounds[rNo].rMinKrsCap = 0;
428     icoRounds[rNo].rMaxKrsCap = 0;
429     icoRounds[rNo].rStartBlock = 0;
430     icoRounds[rNo].rEndBlock = 0;
431     icoRounds[rNo].rEthPaymentsAmount = 0;
432     icoRounds[rNo].rEthPaymentsCount = 0;
433     icoRounds[rNo].rSentKrownsAmount = 0;
434     icoRounds[rNo].rSentKrownsCount = 0;
435     if(rNo > 0) rNo -= 1;
436   }
437 
438   function changeIcoRoundEnding(uint _rEndBlock) public onlyOwner {
439     require(icoRounds[rNo].rStartBlock > 0); // round must be set up earlier
440     icoRounds[rNo].rEndBlock = _rEndBlock;  
441   }
442  
443   // closes round automatically
444   function endIcoRound() private {
445     icoInProgress = false;
446 	icoRounds[rNo].rEndBlock = block.number;
447 	icoRounds[rNo].roundCompleted = true;
448   }
449 
450   // close round manually - if needed  
451   function endIcoRoundManually() public onlyOwner {
452     endIcoRound();
453   }
454   
455   // add a verified KYC/AML address
456   function addAllowedAddress(address _address) public onlyOwnerOrApi {
457     allowedAdresses[_address] = true;
458   }
459   function removeAllowedAddress(address _address) public onlyOwnerOrApi {
460     delete allowedAdresses[_address];
461   }
462 
463   // set exchange rate for ETH/EUR - needed for check whether incoming payment
464   //  is more than xxxx EUR (thus requires KYC/AML verified address)
465   function setEthEurRate(uint _ethEur) public onlyOwnerOrApi {
466     ethEur = _ethEur;
467   }
468 
469   // set exchange rate for ETH/USD
470   function setEthUsdRate(uint _ethUsd) public onlyOwnerOrApi {
471     ethUsd = _ethUsd;
472   }
473 
474   // set exchange rate for KRS/USD
475   function setKrsUsdRate(uint _krsUsd) public onlyOwnerOrApi {
476     krsUsd = _krsUsd;
477   }
478   
479   // set all three exchange rates: ETH/EUR, ETH/USD, KRS/USD
480   function setAllRates(uint _ethEur, uint _ethUsd, uint _krsUsd) public onlyOwnerOrApi {
481     ethEur = _ethEur;
482     ethUsd = _ethUsd;
483 	  krsUsd = _krsUsd;
484   }
485   
486   // send KRS from the contract to a given address (for BTC and FIAT payments)
487   function sendKrs(address _receiver, uint _amount) public onlyOwnerOrApi {
488     krs.transfer(_receiver, _amount);
489   }
490 
491   // transfer KRS from other holder, up to amount allowed through krs.approve() function
492   function getKrsFromApproved(address _from, uint _amount) public onlyOwnerOrApi {
493     krs.transferFrom(_from, address(this), _amount);
494   }
495   
496   // send ETH from the contract to a given address
497   function sendEth(address _receiver, uint _amount) public onlyOwner {
498     _receiver.transfer(_amount);
499   }
500  
501   // disable/enable access from API - for security reasons
502   function disableApiAccess(bool _disabled) public onlyOwner {
503     apiAccessDisabled = _disabled;
504   }
505   
506   // change API wallet address - for security reasons
507   function changeApi(address _address) public onlyOwner {
508     api = _address;
509   }
510 
511   // change owner address
512   function changeOwner(address _address) public onlySuperOwner {
513     owner = _address;
514   }
515   
516 }
517 
518 library MicroWalletLib {
519 
520     //change to production token address
521     KinguinKrowns constant token = KinguinKrowns(0xdfb410994b66778bd6cc2c82e8ffe4f7b2870006);
522 
523     struct MicroWalletStorage {
524         uint krsAmount ;
525         address owner;
526     }
527 
528     function toBytes(address a) private pure returns (bytes b){
529         assembly {
530             let m := mload(0x40)
531             mstore(add(m, 20), xor(0x140000000000000000000000000000000000000000, a))
532             mstore(0x40, add(m, 52))
533             b := m
534         }
535     }
536 
537     function processPayment(MicroWalletStorage storage self, address _sender) public {
538         require(msg.sender == address(token));
539 
540         if (self.owner == _sender) {    //closing MicroWallet
541             self.krsAmount = 0;
542             return;
543         }
544 
545         require(self.krsAmount > 0);
546         
547         uint256 currentBalance = token.balanceOf(address(this));
548 
549         require(currentBalance >= self.krsAmount);
550 
551         if(currentBalance > self.krsAmount) {
552             //return rest of the token
553             require(token.transfer(_sender, currentBalance - self.krsAmount));
554         }
555 
556         require(token.transfer(self.owner, self.krsAmount, toBytes(_sender)));
557 
558         self.krsAmount = 0;
559     }
560 }
561 
562 contract KinguinVault is Ownable, ERC223Receiver {
563     
564     mapping(uint=>address) public microWalletPayments;
565     mapping(uint=>address) public microWalletsAddrs;
566     mapping(address=>uint) public microWalletsIDs;
567     mapping(uint=>uint) public microWalletPaymentBlockNr;
568 
569     KinguinKrowns public token;
570     uint public uncleSafeNr = 5;
571     address public withdrawAddress;
572 
573     modifier onlyWithdraw() {
574         require(withdrawAddress == msg.sender);
575         _;
576     }
577 
578     constructor(KinguinKrowns _token) public {
579         token = _token;
580         withdrawAddress = owner;
581     }
582     
583     function createMicroWallet(uint productOrderID, uint krsAmount) onlyOwner public {
584         require(productOrderID != 0 && microWalletsAddrs[productOrderID] == address(0x0));
585         microWalletsAddrs[productOrderID] = new MicroWallet(krsAmount);
586         microWalletsIDs[microWalletsAddrs[productOrderID]] = productOrderID;
587     }
588 
589     function getMicroWalletAddress(uint productOrderID) public view returns(address) {
590         return microWalletsAddrs[productOrderID];
591     }
592 
593     function closeMicroWallet(uint productOrderID) onlyOwner public {
594         token.transfer(microWalletsAddrs[productOrderID], 0);
595     }
596 
597     function checkIfOnUncle(uint currentBlockNr, uint transBlockNr) private view returns (bool) {
598         if((currentBlockNr - transBlockNr) < uncleSafeNr) {
599             return true;
600         }
601         return false;
602     }
603 
604     function setUncleSafeNr(uint newUncleSafeNr) onlyOwner public {
605         uncleSafeNr = newUncleSafeNr;
606     }
607 
608     function getProductOrderPayer(uint productOrderID) public view returns (address) {
609         if (checkIfOnUncle(block.number, microWalletPaymentBlockNr[productOrderID])) {
610             return 0;    
611         }
612         return microWalletPayments[productOrderID];
613     }
614 
615     function tokenFallback(address _sender, address _origin, uint _value, bytes _data) public returns (bool)  {
616         require(msg.sender == address(token));
617         if(microWalletsIDs[_sender] > 0) {
618             microWalletPayments[microWalletsIDs[_sender]] = bytesToAddr(_data);
619             microWalletPaymentBlockNr[microWalletsIDs[_sender]] = block.number;
620         }
621         return true;
622     }
623 
624     function setWithdrawAccount(address _addr) onlyWithdraw public {
625         withdrawAddress = _addr;
626     } 
627 
628     function withdrawKrowns(address wallet, uint amount) onlyWithdraw public {
629         require(wallet != address(0x0));
630         token.transfer(wallet, amount);
631     }
632 
633     function bytesToAddr (bytes b) private pure returns (address) {
634         uint result = 0;
635         for (uint i = b.length-1; i+1 > 0; i--) {
636             uint c = uint(b[i]);
637             uint to_inc = c * ( 16 ** ((b.length - i-1) * 2));
638             result += to_inc;
639         }
640         return address(result);
641     }
642 }
643 
644 contract MicroWallet is ERC223Receiver {
645     
646     MicroWalletLib.MicroWalletStorage private mwStorage;
647 
648     constructor(uint _krsAmount) public {
649         mwStorage.krsAmount = _krsAmount;
650         mwStorage.owner = msg.sender;
651     }
652 
653     function tokenFallback(address _sender, address _origin, uint _value, bytes _data) public returns (bool)  {
654         MicroWalletLib.processPayment(mwStorage, _sender);
655         
656         return true;
657     }
658 }