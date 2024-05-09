1 pragma solidity ^0.4.18;
2 
3 /// @title Kinguin ICO
4 
5 pragma solidity ^0.4.18;
6 
7 /// @title Kinguin Krowns [KRS]
8 
9  /* ERC223 additions to ERC20 */
10 pragma solidity ^0.4.8;
11 
12  /*
13   ERC223 additions to ERC20
14 
15   Interface wise is ERC20 + data parameter to transfer and transferFrom.
16  */
17 
18 pragma solidity ^0.4.8;
19 
20 
21 /*
22  * ERC20 interface
23  * see https://github.com/ethereum/EIPs/issues/20
24  */
25 contract ERC20 {
26   uint public totalSupply;
27   function balanceOf(address who) constant returns (uint);
28   function allowance(address owner, address spender) constant returns (uint);
29 
30   function transfer(address to, uint value) returns (bool ok);
31   function transferFrom(address from, address to, uint value) returns (bool ok);
32   function approve(address spender, uint value) returns (bool ok);
33   event Transfer(address indexed from, address indexed to, uint value);
34   event Approval(address indexed owner, address indexed spender, uint value);
35 }
36 
37 
38 contract ERC223 is ERC20 {
39   function transfer(address to, uint value, bytes data) returns (bool ok);
40   function transferFrom(address from, address to, uint value, bytes data) returns (bool ok);
41 }
42 
43 pragma solidity ^0.4.8;
44 
45 /*
46 Base class contracts willing to accept ERC223 token transfers must conform to.
47 
48 Sender: msg.sender to the token contract, the address originating the token transfer.
49           - For user originated transfers sender will be equal to tx.origin
50           - For contract originated transfers, tx.origin will be the user that made the tx that produced the transfer.
51 Origin: the origin address from whose balance the tokens are sent
52           - For transfer(), origin = msg.sender
53           - For transferFrom() origin = _from to token contract
54 Value is the amount of tokens sent
55 Data is arbitrary data sent with the token transfer. Simulates ether tx.data
56 
57 From, origin and value shouldn't be trusted unless the token contract is trusted.
58 If sender == tx.origin, it is safe to trust it regardless of the token.
59 */
60 
61 contract ERC223Receiver {
62   function tokenFallback(address _sender, address _origin, uint _value, bytes _data) returns (bool ok);
63 }
64 
65 pragma solidity ^0.4.8;
66 
67 
68 pragma solidity ^0.4.18;
69 
70 
71 /**
72  * Math operations with safety checks
73  */
74 contract SafeMath {
75   function safeMul(uint a, uint b) internal returns (uint) {
76     uint c = a * b;
77     assert(a == 0 || c / a == b);
78     return c;
79   }
80 
81   function safeDiv(uint a, uint b) internal returns (uint) {
82     assert(b > 0);
83     uint c = a / b;
84     assert(a == b * c + a % b);
85     return c;
86   }
87 
88   function safeSub(uint a, uint b) internal returns (uint) {
89     assert(b <= a);
90     return a - b;
91   }
92 
93   function safeAdd(uint a, uint b) internal returns (uint) {
94     uint c = a + b;
95     assert(c>=a && c>=b);
96     return c;
97   }
98 
99   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
100     return a >= b ? a : b;
101   }
102 
103   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
104     return a < b ? a : b;
105   }
106 
107   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
108     return a >= b ? a : b;
109   }
110 
111   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
112     return a < b ? a : b;
113   }
114 
115   /*function assert(bool assertion) internal {
116     if (!assertion) {
117       throw;
118     }
119   }*/
120 }
121 
122 
123 /**
124  * Standard ERC20 token
125  *
126  * https://github.com/ethereum/EIPs/issues/20
127  * Based on code by FirstBlood:
128  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
129  */
130 contract StandardToken is ERC20, SafeMath {
131   mapping(address => uint) balances;
132   mapping (address => mapping (address => uint)) allowed;
133   function transfer(address _to, uint _value) returns (bool success) {
134     require(_to != address(0));
135     require(_value <= balances[msg.sender]);
136     balances[msg.sender] = safeSub(balances[msg.sender], _value);
137     balances[_to] = safeAdd(balances[_to], _value);
138     Transfer(msg.sender, _to, _value);
139     return true;
140   }
141   function transferFrom(address _from, address _to, uint _value) returns (bool success) {
142     var _allowance = allowed[_from][msg.sender];
143     // Check is not needed because safeSub(_allowance, _value) will already throw if this condition is not met
144     // if (_value > _allowance) throw;
145     balances[_to] = safeAdd(balances[_to], _value);
146     balances[_from] = safeSub(balances[_from], _value);
147     allowed[_from][msg.sender] = safeSub(_allowance, _value);
148     Transfer(_from, _to, _value);
149     return true;
150   }
151   function balanceOf(address _owner) constant returns (uint balance) {
152     return balances[_owner];
153   }
154   function approve(address _spender, uint _value) returns (bool success) {
155     allowed[msg.sender][_spender] = _value;
156     Approval(msg.sender, _spender, _value);
157     return true;
158   }
159   function allowance(address _owner, address _spender) constant returns (uint remaining) {
160     return allowed[_owner][_spender];
161   }
162 }
163 
164 contract KinguinKrowns is ERC223, StandardToken {
165   address public owner;  // token owner adddres
166   string public constant name = "Kinguin Krowns";
167   string public constant symbol = "KRS";
168   uint8 public constant decimals = 18;
169   // uint256 public totalSupply; // defined in ERC20 contract
170 		
171   function KinguinKrowns() {
172 	owner = msg.sender;
173     totalSupply = 100000000 * (10**18); // 100 mln
174     balances[msg.sender] = totalSupply;
175   } 
176   
177   /*
178   //only do if call is from owner modifier
179   modifier onlyOwner() {
180     if (msg.sender != owner) throw;
181     _;
182   }*/
183   
184   //function that is called when a user or another contract wants to transfer funds
185   function transfer(address _to, uint _value, bytes _data) returns (bool success) {
186     //filtering if the target is a contract with bytecode inside it
187     if (!super.transfer(_to, _value)) throw; // do a normal token transfer
188     if (isContract(_to)) return contractFallback(msg.sender, _to, _value, _data);
189     return true;
190   }
191 
192   function transferFrom(address _from, address _to, uint _value, bytes _data) returns (bool success) {
193     if (!super.transferFrom(_from, _to, _value)) throw; // do a normal token transfer
194     if (isContract(_to)) return contractFallback(_from, _to, _value, _data);
195     return true;
196   }
197 
198   function transfer(address _to, uint _value) returns (bool success) {
199     return transfer(_to, _value, new bytes(0));
200   }
201 
202   function transferFrom(address _from, address _to, uint _value) returns (bool success) {
203     return transferFrom(_from, _to, _value, new bytes(0));
204   }
205 
206   //function that is called when transaction target is a contract
207   function contractFallback(address _origin, address _to, uint _value, bytes _data) private returns (bool success) {
208     ERC223Receiver receiver = ERC223Receiver(_to);
209     return receiver.tokenFallback(msg.sender, _origin, _value, _data);
210   }
211 
212   //assemble the given address bytecode. If bytecode exists then the _addr is a contract.
213   function isContract(address _addr) private returns (bool is_contract) {
214     // retrieve the size of the code on target address, this needs assembly
215     uint length;
216     assembly { length := extcodesize(_addr) }
217     return length > 0;
218   }
219   
220   // returns krown balance of given address 	
221   function balanceOf(address _owner) constant returns (uint balance) {
222     return balances[_owner];
223   }
224 	
225 }
226 
227 contract KinguinIco is SafeMath, ERC223Receiver {
228   address constant public superOwner = 0xcEbb7454429830C92606836350569A17207dA857;
229   address public owner;             // contract owner address
230   address public api;               // address of api manager
231   KinguinKrowns public krs;     // handler to KRS token contract
232   
233   // rounds data storage:
234   struct IcoRoundData {
235     uint rMinEthPayment;            // set minimum ETH payment
236     uint rKrsUsdFixed;              // set KRS/USD fixed ratio for calculation of krown amount to be sent, 
237     uint rKycTreshold;              // KYC treshold in EUR (needed for check whether incoming payment requires KYC/AML verified address)
238     uint rMinKrsCap;                // minimum amount of KRS to be sent during a round
239     uint rMaxKrsCap;                // maximum amount of KRS to be sent during a round
240     uint rStartBlock;               // number of blockchain start block for a round
241     uint rEndBlock;                 // number of blockchain end block for a round
242     uint rEthPaymentsAmount;        // sum of ETH tokens received from participants during a round
243     uint rEthPaymentsCount;         // counter of ETH payments during a round 
244     uint rSentKrownsAmount;         // sum of ETH tokens received from participants during a round
245     uint rSentKrownsCount;          // counter of KRS transactions during a round
246     bool roundCompleted;            // flag whether a round has finished
247   }
248   mapping(uint => IcoRoundData) public icoRounds;  // table of rounds data: ico number, ico record
249   
250   mapping(address => bool) public allowedAdresses; // list of KYC/AML approved wallets: participant address, allowed/not allowed
251   
252   struct RoundPayments {            // structure for storing sum of payments
253     uint round;
254     uint amount;
255   }
256   // amount of payments from the same address during each round 
257   //  (to catch multiple payments to check KYC/AML approvance): participant address, payments record
258   mapping(address => RoundPayments) public paymentsFromAddress; 
259 
260   uint public ethEur;               // current EUR/ETH exchange rate (for AML check)
261   uint public ethUsd;               // current ETH/USD exchange rate (sending KRS for ETH calc) 
262   uint public krsUsd;               // current KRS/USD exchange rate (sending KRS for ETH calc)
263   uint public rNo;                  // counter for rounds
264   bool public icoInProgress;        // ico status flag
265   bool public apiAccessDisabled;    // api access security flag
266   
267   event LogReceivedEth(address from, uint value, uint block); // publish an event about incoming ETH
268   event LogSentKrs(address to, uint value, uint block); // publish an event about sent KRS
269 
270   // execution allowed only for contract superowner
271   modifier onlySuperOwner() {
272 	require(msg.sender == superOwner);
273     _;
274   }
275 
276   // execution allowed only for contract owner
277   modifier onlyOwner() {
278 	require(msg.sender == owner);
279     _;
280   }
281   
282   // execution allowed only for contract owner or api address
283   modifier onlyOwnerOrApi() {
284 	require(msg.sender == owner || msg.sender == api);
285     if (msg.sender == api && api != owner) {
286       require(!apiAccessDisabled);
287 	}
288     _;
289   }
290  
291   function KinguinIco() {
292     owner = msg.sender; // this contract owner
293     api = msg.sender; // initially api address is the contract owner's address 
294     krs = KinguinKrowns(0xdfb410994b66778bd6cc2c82e8ffe4f7b2870006); // KRS token 
295   } 
296  
297   // receiving ETH and sending KRS
298   function () payable {
299     if(msg.sender != owner) { // if ETH comes from other than the contract owner address
300       if(block.number >= icoRounds[rNo].rStartBlock && block.number <= icoRounds[rNo].rEndBlock && !icoInProgress) {
301         icoInProgress = true;
302       }  
303       require(block.number >= icoRounds[rNo].rStartBlock && block.number <= icoRounds[rNo].rEndBlock && !icoRounds[rNo].roundCompleted); // allow payments only during the ico round
304       require(msg.value >= icoRounds[rNo].rMinEthPayment); // minimum eth payment
305 	  require(ethEur > 0); // ETH/EUR rate for AML must be set earlier
306 	  require(ethUsd > 0); // ETH/USD rate for conversion to KRS
307 	  uint krowns4eth;
308 	  if(icoRounds[rNo].rKrsUsdFixed > 0) { // KRS has fixed ratio to USD
309         krowns4eth = safeDiv(safeMul(safeMul(msg.value, ethUsd), uint(100)), icoRounds[rNo].rKrsUsdFixed);
310 	  } else { // KRS/USD is traded on exchanges
311 		require(krsUsd > 0); // KRS/USD rate for conversion to KRS
312         krowns4eth = safeDiv(safeMul(safeMul(msg.value, ethUsd), uint(100)), krsUsd);
313   	  }
314       require(safeAdd(icoRounds[rNo].rSentKrownsAmount, krowns4eth) <= icoRounds[rNo].rMaxKrsCap); // krs cap per round
315 
316       if(paymentsFromAddress[msg.sender].round != rNo) { // on mappings all keys are possible, so there is no checking for its existence
317         paymentsFromAddress[msg.sender].round = rNo; // on new round set to current round
318         paymentsFromAddress[msg.sender].amount = 0; // zeroing amount on new round
319       }   
320       if(safeMul(ethEur, safeDiv(msg.value, 10**18)) >= icoRounds[rNo].rKycTreshold || // if payment from this sender requires to be from KYC/AML approved address
321         // if sum of payments from this sender address requires to be from KYC/AML approved address
322         safeMul(ethEur, safeDiv(safeAdd(paymentsFromAddress[msg.sender].amount, msg.value), 10**18)) >= icoRounds[rNo].rKycTreshold) { 
323 		require(allowedAdresses[msg.sender]); // only KYC/AML allowed address
324       }
325 
326       icoRounds[rNo].rEthPaymentsAmount = safeAdd(icoRounds[rNo].rEthPaymentsAmount, msg.value);
327       icoRounds[rNo].rEthPaymentsCount += 1; 
328       paymentsFromAddress[msg.sender].amount = safeAdd(paymentsFromAddress[msg.sender].amount, msg.value);
329       LogReceivedEth(msg.sender, msg.value, block.number);
330       icoRounds[rNo].rSentKrownsAmount = safeAdd(icoRounds[rNo].rSentKrownsAmount, krowns4eth);
331       icoRounds[rNo].rSentKrownsCount += 1;
332       krs.transfer(msg.sender, krowns4eth);
333       LogSentKrs(msg.sender, krowns4eth, block.number);
334     } else { // owner can always pay-in (and trigger round start/stop)
335 	    if(block.number >= icoRounds[rNo].rStartBlock && block.number <= icoRounds[rNo].rEndBlock && !icoInProgress) {
336           icoInProgress = true;
337         }
338         if(block.number > icoRounds[rNo].rEndBlock && icoInProgress) {
339           endIcoRound();
340         }
341     }
342   }
343 
344   // receiving tokens other than ETH
345   
346   // ERC223 receiver implementation - https://github.com/aragon/ERC23/blob/master/contracts/implementation/Standard223Receiver.sol
347   Tkn tkn;
348 
349   struct Tkn {
350     address addr;
351     address sender;
352     address origin;
353     uint256 value;
354     bytes data;
355     bytes4 sig;
356   }
357 
358   function tokenFallback(address _sender, address _origin, uint _value, bytes _data) returns (bool ok) {
359     if (!supportsToken(msg.sender)) return false;
360     return true;
361   }
362 
363   function getSig(bytes _data) private returns (bytes4 sig) {
364     uint l = _data.length < 4 ? _data.length : 4;
365     for (uint i = 0; i < l; i++) {
366       sig = bytes4(uint(sig) + uint(_data[i]) * (2 ** (8 * (l - 1 - i))));
367     }
368   }
369 
370   bool __isTokenFallback;
371 
372   modifier tokenPayable {
373     if (!__isTokenFallback) throw;
374     _;
375   }
376   
377   function supportsToken(address token) returns (bool) {
378     if (token == address(krs)) {
379 	  return true; 
380     } else {
381       revert();
382 	}
383   }
384   // end of ERC223 receiver implementation ------------------------------------
385 
386 
387   // set up a new ico round  
388   function newIcoRound(uint _rMinEthPayment, uint _rKrsUsdFixed, uint _rKycTreshold,
389     uint _rMinKrsCap, uint _rMaxKrsCap, uint _rStartBlock, uint _rEndBlock) public onlyOwner {
390     require(!icoInProgress);            // new round can be set up only after finished/cancelled the active one
391     require(rNo < 25);                  // limit of 25 rounds (with pre-ico)
392 	rNo += 1;                           // increment round number, pre-ico has number 1
393 	icoRounds[rNo] = IcoRoundData(_rMinEthPayment, _rKrsUsdFixed, _rKycTreshold, _rMinKrsCap, _rMaxKrsCap, 
394 	  _rStartBlock, _rEndBlock, 0, 0, 0, 0, false); // rEthPaymentsAmount, rEthPaymentsCount, rSentKrownsAmount, rSentKrownsCount); 
395   }
396   
397   // remove current round, params only - it does not refund any ETH!
398   function removeCurrentIcoRound() public onlyOwner {
399     require(icoRounds[rNo].rEthPaymentsAmount == 0); // only if there was no payment already
400 	require(!icoRounds[rNo].roundCompleted); // only current round can be removed
401     icoInProgress = false;
402     icoRounds[rNo].rMinEthPayment = 0;
403     icoRounds[rNo].rKrsUsdFixed = 0;
404     icoRounds[rNo].rKycTreshold = 0;
405     icoRounds[rNo].rMinKrsCap = 0;
406     icoRounds[rNo].rMaxKrsCap = 0;
407     icoRounds[rNo].rStartBlock = 0;
408     icoRounds[rNo].rEndBlock = 0;
409     icoRounds[rNo].rEthPaymentsAmount = 0;
410     icoRounds[rNo].rEthPaymentsCount = 0;
411     icoRounds[rNo].rSentKrownsAmount = 0;
412     icoRounds[rNo].rSentKrownsCount = 0;
413     if(rNo > 0) rNo -= 1;
414   }
415 
416   function changeIcoRoundEnding(uint _rEndBlock) public onlyOwner {
417     require(icoRounds[rNo].rStartBlock > 0); // round must be set up earlier
418     icoRounds[rNo].rEndBlock = _rEndBlock;  
419   }
420  
421   // closes round automatically
422   function endIcoRound() private {
423     icoInProgress = false;
424 	icoRounds[rNo].rEndBlock = block.number;
425 	icoRounds[rNo].roundCompleted = true;
426   }
427 
428   // close round manually - if needed  
429   function endIcoRoundManually() public onlyOwner {
430     endIcoRound();
431   }
432   
433   // add a verified KYC/AML address
434   function addAllowedAddress(address _address) public onlyOwnerOrApi {
435     allowedAdresses[_address] = true;
436   }
437   function removeAllowedAddress(address _address) public onlyOwnerOrApi {
438     delete allowedAdresses[_address];
439   }
440 
441   // set exchange rate for ETH/EUR - needed for check whether incoming payment
442   //  is more than xxxx EUR (thus requires KYC/AML verified address)
443   function setEthEurRate(uint _ethEur) public onlyOwnerOrApi {
444     ethEur = _ethEur;
445   }
446 
447   // set exchange rate for ETH/USD
448   function setEthUsdRate(uint _ethUsd) public onlyOwnerOrApi {
449     ethUsd = _ethUsd;
450   }
451 
452   // set exchange rate for KRS/USD
453   function setKrsUsdRate(uint _krsUsd) public onlyOwnerOrApi {
454     krsUsd = _krsUsd;
455   }
456   
457   // set all three exchange rates: ETH/EUR, ETH/USD, KRS/USD
458   function setAllRates(uint _ethEur, uint _ethUsd, uint _krsUsd) public onlyOwnerOrApi {
459     ethEur = _ethEur;
460     ethUsd = _ethUsd;
461 	  krsUsd = _krsUsd;
462   }
463   
464   // send KRS from the contract to a given address (for BTC and FIAT payments)
465   function sendKrs(address _receiver, uint _amount) public onlyOwnerOrApi {
466     krs.transfer(_receiver, _amount);
467   }
468 
469   // transfer KRS from other holder, up to amount allowed through krs.approve() function
470   function getKrsFromApproved(address _from, uint _amount) public onlyOwnerOrApi {
471     krs.transferFrom(_from, address(this), _amount);
472   }
473   
474   // send ETH from the contract to a given address
475   function sendEth(address _receiver, uint _amount) public onlyOwner {
476     _receiver.transfer(_amount);
477   }
478  
479   // disable/enable access from API - for security reasons
480   function disableApiAccess(bool _disabled) public onlyOwner {
481     apiAccessDisabled = _disabled;
482   }
483   
484   // change API wallet address - for security reasons
485   function changeApi(address _address) public onlyOwner {
486     api = _address;
487   }
488 
489   // change owner address
490   function changeOwner(address _address) public onlySuperOwner {
491     owner = _address;
492   }
493   
494 }