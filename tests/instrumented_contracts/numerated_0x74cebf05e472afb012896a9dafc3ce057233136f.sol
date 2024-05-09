1 pragma solidity ^0.4.18;
2 
3 // File: contracts/ERC20.sol
4 
5 /*
6  * @title ERC20 interface
7  * @dev see https://github.com/ethereum/EIPs/issues/20
8  */
9 contract ERC20 {
10   uint public totalSupply;
11 
12   function balanceOf(address who) public constant returns (uint);
13 
14   function allowance(address owner, address spender) public constant returns (uint);
15 
16   function transfer(address to, uint value) public returns (bool ok);
17 
18   function transferFrom(address from, address to, uint value) public returns (bool ok);
19 
20   function approve(address spender, uint value) public returns (bool ok);
21 
22   event Transfer(address indexed from, address indexed to, uint value);
23 
24   event Approval(address indexed owner, address indexed spender, uint value);
25 }
26 
27 // ERC223
28 contract ContractReceiver {
29   function tokenFallback(address from, uint value) public;
30 }
31 
32 // File: contracts/Ownable.sol
33 
34 /*
35  * Ownable
36  *
37  * Base contract with an owner.
38  * Provides onlyOwner modifier, which prevents function from running if it is called by anyone other than the owner.
39  */
40 contract Ownable {
41 
42   address public owner;
43 
44   function Ownable() public { owner = msg.sender; }
45 
46   modifier onlyOwner() {
47     require(msg.sender == owner);
48     _;
49   }
50 
51   function transferOwnership(address newOwner) public onlyOwner {
52 
53     if (newOwner != address(0)) {
54       owner = newOwner;
55     }
56 
57   }
58 }
59 
60 // File: contracts/Deployer.sol
61 
62 contract Deployer {
63 
64   address public deployer;
65 
66   function Deployer() public { deployer = msg.sender; }
67 
68   modifier onlyDeployer() {
69     require(msg.sender == deployer);
70     _;
71   }
72 }
73 
74 // File: contracts/OracleOwnable.sol
75 
76 contract OracleOwnable is Ownable {
77 
78   address public oracle;
79 
80   modifier onlyOracle() {
81     require(msg.sender == oracle);
82     _;
83   }
84 
85   modifier onlyOracleOrOwner() {
86     require(msg.sender == oracle || msg.sender == owner);
87     _;
88   }
89 
90   function setOracle(address newOracle) public onlyOracleOrOwner {
91     if (newOracle != address(0)) {
92       oracle = newOracle;
93     }
94 
95   }
96 
97 }
98 
99 // File: contracts/ModultradeLibrary.sol
100 
101 library ModultradeLibrary {
102   enum Currencies {
103   ETH, MTR
104   }
105 
106   enum ProposalStates {
107   Created, Paid, Delivery, Closed, Canceled
108   }
109 }
110 
111 // File: contracts/ModultradeStorage.sol
112 
113 contract ModultradeStorage is Ownable, Deployer {
114 
115   bool private _doMigrate = true;
116 
117   mapping (address => address[]) public sellerProposals;
118 
119   mapping (uint => address) public proposalListAddress;
120 
121   address[] public proposals;
122 
123   event InsertProposalEvent (address _proposal, uint _id, address _seller);
124 
125   event PaidProposalEvent (address _proposal, uint _id);
126 
127   function ModultradeStorage() public {}
128 
129   function insertProposal(address seller, uint id, address proposal) public onlyOwner {
130     sellerProposals[seller].push(proposal);
131     proposalListAddress[id] = proposal;
132     proposals.push(proposal);
133 
134     InsertProposalEvent(proposal, id, seller);
135   }
136 
137   function getProposalsBySeller(address seller) public constant returns (address[]){
138     return sellerProposals[seller];
139   }
140 
141   function getProposals() public constant returns (address[]){
142     return proposals;
143   }
144 
145   function getProposalById(uint id) public constant returns (address){
146     return proposalListAddress[id];
147   }
148 
149   function getCount() public constant returns (uint) {
150     return proposals.length;
151   }
152 
153   function getCountBySeller(address seller) public constant returns (uint) {
154     return sellerProposals[seller].length;
155   }
156 
157   function firePaidProposalEvent(address proposal, uint id) public {
158     require(proposalListAddress[id] == proposal);
159 
160     PaidProposalEvent(proposal, id);
161   }
162 
163   function changeOwner(address newOwner) public onlyDeployer {
164     if (newOwner != address(0)) {
165       owner = newOwner;
166     }
167   }
168 
169 }
170 
171 // File: contracts/ModultradeProposal.sol
172 
173 contract ModultradeProposal is OracleOwnable, ContractReceiver {
174 
175   address public seller;
176 
177   address public buyer;
178 
179   uint public id;
180 
181   string public title;
182 
183   uint public price;
184 
185   ModultradeLibrary.Currencies public currency;
186 
187   uint public units;
188 
189   uint public total;
190 
191   uint public validUntil;
192 
193   ModultradeLibrary.ProposalStates public state;
194 
195   uint public payDate;
196 
197   string public deliveryId;
198 
199   uint public fee;
200 
201   address public feeAddress;
202 
203   ERC20 mtrContract;
204 
205   Modultrade modultrade;
206 
207   bytes public tokenFallbackData;
208 
209   event CreatedEvent(uint _id, ModultradeLibrary.ProposalStates _state);
210 
211   event PaidEvent(uint _id, ModultradeLibrary.ProposalStates _state, address _buyer);
212 
213   event DeliveryEvent(uint _id, ModultradeLibrary.ProposalStates _state, string _deliveryId);
214 
215   event ClosedEvent(uint _id, ModultradeLibrary.ProposalStates _state, address _seller, uint _amount);
216 
217   event CanceledEvent(uint _id, ModultradeLibrary.ProposalStates _state, address _buyer, uint _amount);
218 
219   function ModultradeProposal(address _modultrade, address _seller, address _mtrContractAddress) public {
220     seller = _seller;
221     state = ModultradeLibrary.ProposalStates.Created;
222     mtrContract = ERC20(_mtrContractAddress);
223     modultrade = Modultrade(_modultrade);
224   }
225 
226   function setProposal(uint _id,
227   string _title,
228   uint _price,
229   ModultradeLibrary.Currencies _currency,
230   uint _units,
231   uint _total,
232   uint _validUntil
233   ) public onlyOracleOrOwner {
234     require(state == ModultradeLibrary.ProposalStates.Created);
235     id = _id;
236     title = _title;
237     price = _price;
238     currency = _currency;
239     units = _units;
240     total = _total;
241     validUntil = _validUntil;
242   }
243 
244   function setFee(uint _fee, address _feeAddress) public onlyOracleOrOwner {
245     require(state == ModultradeLibrary.ProposalStates.Created);
246     fee = _fee;
247     feeAddress = _feeAddress;
248   }
249 
250   function() public payable {purchase();}
251 
252   function purchase() public payable {
253     require(currency == ModultradeLibrary.Currencies.ETH);
254     require(msg.value >= total);
255     setPaid(msg.sender);
256   }
257 
258   function setPaid(address _buyer) internal {
259     require(state == ModultradeLibrary.ProposalStates.Created);
260     state = ModultradeLibrary.ProposalStates.Paid;
261     buyer = _buyer;
262     payDate = now;
263     PaidEvent(id, state, buyer);
264     modultrade.firePaidProposalEvent(address(this), id);
265   }
266 
267   function paid(address _buyer) public onlyOracleOrOwner {
268     require(getBalance() >= total);
269     setPaid(_buyer);
270   }
271 
272   function mtrTokenFallBack(address from, uint value) internal {
273     require(currency == ModultradeLibrary.Currencies.MTR);
274     require(msg.sender == address(mtrContract));
275     require(value >= total);
276     setPaid(from);
277   }
278 
279   function tokenFallback(address from, uint value) public {
280     mtrTokenFallBack(from, value);
281   }
282 
283   function tokenFallback(address from, uint value, bytes data) public {
284     tokenFallbackData = data;
285     mtrTokenFallBack(from, value);
286   }
287 
288   function delivery(string _deliveryId) public onlyOracleOrOwner {
289     require(state == ModultradeLibrary.ProposalStates.Paid);
290     deliveryId = _deliveryId;
291     state = ModultradeLibrary.ProposalStates.Delivery;
292     DeliveryEvent(id, state, deliveryId);
293     modultrade.fireDeliveryProposalEvent(address(this), id);
294   }
295 
296   function close() public onlyOracleOrOwner {
297     require(state != ModultradeLibrary.ProposalStates.Closed);
298     require(state != ModultradeLibrary.ProposalStates.Canceled);
299 
300     if (currency == ModultradeLibrary.Currencies.ETH) {
301       closeEth();
302     }
303     if (currency == ModultradeLibrary.Currencies.MTR) {
304       closeMtr();
305     }
306 
307     state = ModultradeLibrary.ProposalStates.Closed;
308     ClosedEvent(id, state, seller, this.balance);
309     modultrade.fireCloseProposalEvent(address(this), id);
310   }
311 
312   function closeEth() private {
313     if (fee > 0) {
314       feeAddress.transfer(fee);
315     }
316     seller.transfer(this.balance);
317   }
318 
319   function closeMtr() private {
320     if (fee > 0) {
321       mtrContract.transfer(feeAddress, fee);
322     }
323     mtrContract.transfer(seller, getBalance());
324   }
325 
326   function cancel(uint cancelFee) public onlyOracleOrOwner {
327     require(state != ModultradeLibrary.ProposalStates.Closed);
328     require(state != ModultradeLibrary.ProposalStates.Canceled);
329     uint _balance = getBalance();
330     if (_balance > 0) {
331       if (currency == ModultradeLibrary.Currencies.ETH) {
332         cancelEth(cancelFee);
333       }
334       if (currency == ModultradeLibrary.Currencies.MTR) {
335         cancelMtr(cancelFee);
336       }
337     }
338     state = ModultradeLibrary.ProposalStates.Canceled;
339     CanceledEvent(id, state, buyer, this.balance);
340     modultrade.fireCancelProposalEvent(address(this), id);
341   }
342 
343   function cancelEth(uint cancelFee) private {
344     uint _fee = cancelFee;
345     if (cancelFee > this.balance) {
346       _fee = this.balance;
347     }
348     feeAddress.transfer(_fee);
349     if (this.balance > 0 && buyer != address(0)) {
350       buyer.transfer(this.balance);
351     }
352   }
353 
354   function cancelMtr(uint cancelFee) private {
355     uint _fee = cancelFee;
356     uint _balance = getBalance();
357     if (cancelFee > _balance) {
358       _fee = _balance;
359     }
360     mtrContract.transfer(feeAddress, _fee);
361     _balance = getBalance();
362     if (_balance > 0 && buyer != address(0)) {
363       mtrContract.transfer(buyer, _balance);
364     }
365   }
366 
367   function getBalance() public constant returns (uint) {
368     if (currency == ModultradeLibrary.Currencies.MTR) {
369       return mtrContract.balanceOf(address(this));
370     }
371 
372     return this.balance;
373   }
374 }
375 
376 // File: contracts/Modultrade.sol
377 
378 contract Modultrade is OracleOwnable, Deployer {
379 
380   address public mtrContractAddress;
381 
382   ModultradeStorage public modultradeStorage;
383 
384   event ProposalCreatedEvent(uint _id, address _proposal);
385 
386   event PaidProposalEvent (address _proposal, uint _id);
387   event CancelProposalEvent (address _proposal, uint _id);
388   event CloseProposalEvent (address _proposal, uint _id);
389   event DeliveryProposalEvent (address _proposal, uint _id);
390 
391   event LogEvent (address _addr, string _log, uint _i);
392 
393   function Modultrade(address _owner, address _oracle, address _mtrContractAddress, address _storageAddress) public {
394     transferOwnership(_owner);
395     setOracle(_oracle);
396     mtrContractAddress = _mtrContractAddress;
397     modultradeStorage = ModultradeStorage(_storageAddress);
398   }
399 
400   function createProposal(
401   address seller,
402   uint id,
403   string title,
404   uint price,
405   ModultradeLibrary.Currencies currency,
406   uint units,
407   uint total,
408   uint validUntil,
409   uint fee,
410   address feeAddress
411   ) public onlyOracleOrOwner {
412     ModultradeProposal proposal = new ModultradeProposal(address(this), seller, mtrContractAddress);
413     LogEvent (address(proposal), 'ModultradeProposal', 1);
414     proposal.setProposal(id, title, price, currency, units, total, validUntil);
415     proposal.setFee(fee, feeAddress);
416     proposal.setOracle(oracle);
417     proposal.transferOwnership(owner);
418 
419     modultradeStorage.insertProposal(seller, id, address(proposal));
420     ProposalCreatedEvent(proposal.id(), address(proposal));
421   }
422 
423 
424   function transferStorage(address _owner) public onlyOracleOrOwner {
425     modultradeStorage.transferOwnership(_owner);
426   }
427 
428   function firePaidProposalEvent(address proposal, uint id) public {
429     var _proposal = modultradeStorage.getProposalById(id);
430     require(_proposal == proposal);
431     PaidProposalEvent(proposal, id);
432   }
433 
434   function fireCancelProposalEvent(address proposal, uint id) public {
435     var _proposal = modultradeStorage.getProposalById(id);
436     require(_proposal == proposal);
437     CancelProposalEvent(proposal, id);
438   }
439 
440   function fireCloseProposalEvent(address proposal, uint id) public {
441     var _proposal = modultradeStorage.getProposalById(id);
442     require(_proposal == proposal);
443     CloseProposalEvent(proposal, id);
444   }
445 
446   function fireDeliveryProposalEvent(address proposal, uint id) public {
447     var _proposal = modultradeStorage.getProposalById(id);
448     require(_proposal == proposal);
449     DeliveryProposalEvent(proposal, id);
450   }
451 
452 }