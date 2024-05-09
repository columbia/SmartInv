1 pragma solidity ^0.4.22;
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
14   event OwnershipRenounced(address indexed previousOwner);
15   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
16 
17 
18   /**
19    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
20    * account.
21    */
22   constructor () public {
23     owner = msg.sender;
24   }
25 
26   /**
27    * @dev Throws if called by any account other than the owner.
28    */
29   modifier onlyOwner() {
30     require(msg.sender == owner);
31     _;
32   }
33 
34   /**
35    * @dev Allows the current owner to transfer control of the contract to a newOwner.
36    * @param newOwner The address to transfer ownership to.
37    */
38   function transferOwnership(address newOwner) public onlyOwner {
39     require(newOwner != address(0));
40     emit OwnershipTransferred(owner, newOwner);
41     owner = newOwner;
42   }
43 
44   /**
45    * @dev Allows the current owner to relinquish control of the contract.
46    */
47   function renounceOwnership() public onlyOwner {
48     emit OwnershipRenounced(owner);
49     owner = address(0);
50   }
51 }
52 
53 /**
54  * @title MultiOwnable
55  * @dev The MultiOwnable contract has an owner address[], and provides basic authorization control
56  */
57 contract MultiOwnable is Ownable {
58 
59   struct Types {
60     mapping (address => bool) access;
61   }
62   mapping (uint => Types) private multiOwnersTypes;
63 
64   event AddOwner(uint _type, address addr);
65   event AddOwner(uint[] types, address addr);
66   event RemoveOwner(uint _type, address addr);
67 
68   modifier onlyMultiOwnersType(uint _type) {
69     require(multiOwnersTypes[_type].access[msg.sender] || msg.sender == owner, "403");
70     _;
71   }
72 
73   function onlyMultiOwnerType(uint _type, address _sender) public view returns(bool) {
74     if (multiOwnersTypes[_type].access[_sender] || _sender == owner) {
75       return true;
76     }
77     return false;
78   }
79 
80   function addMultiOwnerType(uint _type, address _owner) public onlyOwner returns(bool) {
81     require(_owner != address(0));
82     multiOwnersTypes[_type].access[_owner] = true;
83     emit AddOwner(_type, _owner);
84     return true;
85   }
86   
87   function addMultiOwnerTypes(uint[] types, address _owner) public onlyOwner returns(bool) {
88     require(_owner != address(0));
89     require(types.length > 0);
90     for (uint i = 0; i < types.length; i++) {
91       multiOwnersTypes[types[i]].access[_owner] = true;
92     }
93     emit AddOwner(types, _owner);
94     return true;
95   }
96 
97   function removeMultiOwnerType(uint types, address _owner) public onlyOwner returns(bool) {
98     require(_owner != address(0));
99     multiOwnersTypes[types].access[_owner] = false;
100     emit RemoveOwner(types, _owner);
101     return true;
102   }
103 }
104 
105 /**
106  * @title SafeMath
107  * @dev Math operations with safety checks that throw on error
108  */
109 library SafeMath {
110 
111   /**
112   * @dev Multiplies two numbers, throws on overflow.
113   */
114   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
115     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
116     // benefit is lost if 'b' is also tested.
117     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
118     if (a == 0) {
119       return 0;
120     }
121 
122     c = a * b;
123     assert(c / a == b);
124     return c;
125   }
126 
127   /**
128   * @dev Integer division of two numbers, truncating the quotient.
129   */
130   function div(uint256 a, uint256 b) internal pure returns (uint256) {
131     // assert(b > 0); // Solidity automatically throws when dividing by 0
132     // uint256 c = a / b;
133     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
134     return a / b;
135   }
136 
137   /**
138   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
139   */
140   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
141     assert(b <= a);
142     return a - b;
143   }
144 
145   /**
146   * @dev Adds two numbers, throws on overflow.
147   */
148   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
149     c = a + b;
150     assert(c >= a);
151     return c;
152   }
153 }
154 
155 contract IBonus {
156   function getCurrentDayBonus(uint startSaleDate, bool saleState) public view returns(uint);
157   function _currentDay(uint startSaleDate, bool saleState) public view returns(uint);
158   function getBonusData() public view returns(string);
159   function getPreSaleBonusPercent() public view returns(uint);
160   function getMinReachUsdPayInCents() public view returns(uint);
161 }
162 
163 contract ICurrency {
164   function getUsdAbsRaisedInCents() external view returns(uint);
165   function getCoinRaisedBonusInWei() external view returns(uint);
166   function getCoinRaisedInWei() public view returns(uint);
167   function getUsdFromETH(uint ethWei) public view returns(uint);
168   function getTokenFromETH(uint ethWei) public view returns(uint);
169   function getCurrencyRate(string _ticker) public view returns(uint);
170   function addPay(string _ticker, uint value, uint usdAmount, uint coinRaised, uint coinRaisedBonus) public returns(bool);
171   function checkTickerExists(string ticker) public view returns(bool);
172   function getUsdFromCurrency(string ticker, uint value) public view returns(uint);
173   function getUsdFromCurrency(string ticker, uint value, uint usd) public view returns(uint);
174   function getUsdFromCurrency(bytes32 ticker, uint value) public view returns(uint);
175   function getUsdFromCurrency(bytes32 ticker, uint value, uint usd) public view returns(uint);
176   function getTokenWeiFromUSD(uint usdCents) public view returns(uint);
177   function editPay(bytes32 ticker, uint currencyValue, uint currencyUsdRaised, uint _usdAbsRaisedInCents, uint _coinRaisedInWei, uint _coinRaisedBonusInWei) public returns(bool);
178   function getCurrencyList(string ticker) public view returns(bool active, uint usd, uint devision, uint raised, uint usdRaised, uint usdRaisedExchangeRate, uint counter, uint lastUpdate);
179   function getCurrencyList(bytes32 ticker) public view returns(bool active, uint usd, uint devision, uint raised, uint usdRaised, uint usdRaisedExchangeRate, uint counter, uint lastUpdate);
180   function getTotalUsdRaisedInCents() public view returns(uint);
181   function getAllCurrencyTicker() public view returns(string);
182   function getCoinUSDRate() public view  returns(uint);
183   function addPreSaleBonus(uint bonusToken) public returns(bool);
184   function editPreSaleBonus(uint beforeBonus, uint afterBonus) public returns(bool);
185 }
186 
187 contract IStorage {
188   function processPreSaleBonus(uint minTotalUsdAmountInCents, uint bonusPercent, uint _start, uint _limit) external returns(uint);
189   function checkNeedProcessPreSaleBonus(uint minTotalUsdAmountInCents) external view returns(bool);
190   function getCountNeedProcessPreSaleBonus(uint minTotalUsdAmountInCents, uint start, uint limit) external view returns(uint);
191   function reCountUserPreSaleBonus(uint uId, uint minTotalUsdAmountInCents, uint bonusPercent, uint maxPayTime) external returns(uint, uint);
192   function getContributorIndexes(uint index) external view returns(uint);
193   function checkNeedSendSHPC(bool proc) external view returns(bool);
194   function getCountNeedSendSHPC(uint start, uint limit) external view returns(uint);
195   function checkETHRefund(bool proc) external view returns(bool);
196   function getCountETHRefund(uint start, uint limit) external view returns(uint);
197   function addPayment(address _addr, string pType, uint _value, uint usdAmount, uint currencyUSD, uint tokenWithoutBonus, uint tokenBonus, uint bonusPercent, uint payId) public returns(bool);
198   function addPayment(uint uId, string pType, uint _value, uint usdAmount, uint currencyUSD, uint tokenWithoutBonus, uint tokenBonus, uint bonusPercent, uint payId) public returns(bool);
199   function checkUserIdExists(uint uId) public view returns(bool);
200   function getContributorAddressById(uint uId) public view returns(address);
201   function editPaymentByUserId(uint uId, uint payId, uint _payValue, uint _usdAmount, uint _currencyUSD, uint _totalToken, uint _tokenWithoutBonus, uint _tokenBonus, uint _bonusPercent) public returns(bool);
202   function getUserPaymentById(uint uId, uint payId) public view returns(uint time, bytes32 pType, uint currencyUSD, uint bonusPercent, uint payValue, uint totalToken, uint tokenBonus, uint tokenWithoutBonus, uint usdAbsRaisedInCents, bool refund);
203   function checkWalletExists(address addr) public view returns(bool result);
204   function checkReceivedCoins(address addr) public view returns(bool);
205   function getContributorId(address addr) public view returns(uint);
206   function getTotalCoin(address addr) public view returns(uint);
207   function setReceivedCoin(uint uId) public returns(bool);
208   function checkPreSaleReceivedBonus(address addr) public view returns(bool);
209   function checkRefund(address addr) public view returns(bool);
210   function setRefund(uint uId) public returns(bool);
211   function getEthPaymentContributor(address addr) public view returns(uint);
212   function refundPaymentByUserId(uint uId, uint payId) public returns(bool);
213   function changeSupportChangeMainWallet(bool support) public returns(bool);
214 }
215 
216 /**
217  * @title ERC20Basic
218  * @dev Simpler version of ERC20 interface
219  * @dev see https://github.com/ethereum/EIPs/issues/179
220  */
221 contract ERC20Basic {
222   function totalSupply() public view returns (uint256);
223   function balanceOf(address who) public view returns (uint256);
224   function transfer(address to, uint256 value) public returns (bool);
225   event Transfer(address indexed from, address indexed to, uint256 value);
226 }
227 
228 /**
229  * @title ShipCoin Crowdsale
230  */
231 contract ShipCoinCrowdsale is MultiOwnable {
232   using SafeMath for uint256;
233 
234   ERC20Basic public coinContract;
235   IStorage public storageContract;
236   ICurrency public currencyContract;
237   IBonus public bonusContract;
238 
239   enum SaleState {NEW, PRESALE, CALCPSBONUS, SALE, END, REFUND}
240   uint256 private constant ONE_DAY = 86400;
241 
242   SaleState public state;
243 
244   bool public paused = false;
245 
246   /**
247    * @dev Modifier to make a function callable only when the contract is not paused.
248    */
249   modifier whenNotPaused() {
250     require(!paused);
251     _;
252   }
253 
254   // minimum goal USD
255   uint public softCapUSD = 500000000; // 5,000,000$ in cents
256   // maximum goal USD
257   uint public hardCapUSD = 6200000000; // 62,000,000$ in cents
258   // maximum available SHPC with a bonus
259   uint public maxDistributeCoin = 600000000 * 1 ether; //600,000,000 shpc (incl. bonus)
260   // minimal accept payment
261   uint public minimalContributionUSD = 100000; // 1000$ in cents
262 
263   // start and end timestamps where investments are allowed in PreSale
264   uint public startPreSaleDate;
265   uint public endPreSaleDate;
266 
267   uint public unfreezeRefundPreSale;
268   uint public unfreezeRefundAll;
269 
270   // start and end timestamps where investments are allowed in sale
271   uint public startSaleDate;
272   uint public endSaleDate;
273 
274   bool public softCapAchieved = false;
275 
276   address public multiSig1;
277   address public multiSig2;
278 
279   bool public multiSigReceivedSoftCap = false;
280 
281 
282   /* Events */
283   event ChangeState(uint blockNumber, SaleState state);
284   event ChangeMinContribUSD(uint oldAmount, uint newAmount);
285   event ChangeStorageContract(address oldAddress, address newAddress);
286   event ChangeCurrencyContract(address oldAddress, address newAddress);
287   event ChangeCoinContract(address oldAddress, address newAddress);
288   event ChangeBonusContract(address oldAddress, address newAddress);
289   event AddPay(address contributor);
290   event EditPay(address contributor);
291   event SoftCapAchieved(uint amount);
292   event ManualChangeStartPreSaleDate(uint oldDate, uint newDate);
293   event ManualChangeEndPreSaleDate(uint oldDate, uint newDate);
294   event ManualChangeStartSaleDate(uint oldDate, uint newDate);
295   event ManualEndSaleDate(uint oldDate, uint newDate);
296   event SendSHPCtoContributor(address contributor);
297   event SoftCapChanged();
298   event Refund(address contributor);
299   event RefundPay(address contributor);
300 
301   struct PaymentInfo {
302     bytes32 pType;
303     uint currencyUSD;
304     uint bonusPercent;
305     uint payValue;
306     uint totalToken;
307     uint tokenBonus;
308     uint usdAbsRaisedInCents;
309     bool refund;
310   }
311 
312   struct CurrencyInfo {
313     uint value;
314     uint usdRaised;
315     uint usdAbsRaisedInCents;
316     uint coinRaisedInWei;
317     uint coinRaisedBonusInWei;
318   }
319 
320   struct EditPaymentInfo {
321     uint usdAmount;
322     uint currencyUSD;
323     uint bonusPercent;
324     uint totalToken;
325     uint tokenWithoutBonus;
326     uint tokenBonus;
327     CurrencyInfo currency;
328   }
329 
330   function () external whenNotPaused payable {
331     buyTokens(msg.sender);
332   }
333 
334   /**
335    * @dev Run after deploy. Initialize initial variables
336    * @param _coinAddress address coinContract
337    * @param _storageContract address storageContract
338    * @param _currencyContract address currencyContract
339    * @param _bonusContract address bonusContract
340    * @param _multiSig1 address multiSig where eth will be transferred
341    * @param _startPreSaleDate timestamp
342    * @param _endPreSaleDate timestamp
343    * @param _startSaleDate timestamp
344    * @param _endSaleDate timestamp
345    */
346   function init(
347     address _coinAddress,
348     address _storageContract,
349     address _currencyContract,
350     address _bonusContract,
351     address _multiSig1,
352     uint _startPreSaleDate,
353     uint _endPreSaleDate,
354     uint _startSaleDate,
355     uint _endSaleDate
356   )
357   public
358   onlyOwner
359   {
360     require(_coinAddress != address(0));
361     require(_storageContract != address(0));
362     require(_currencyContract != address(0));
363     require(_multiSig1 != address(0));
364     require(_bonusContract != address(0));
365     require(_startPreSaleDate > 0 && _startSaleDate > 0);
366     require(_startSaleDate > _endPreSaleDate);
367     require(_endSaleDate > _startSaleDate);
368     require(startSaleDate == 0);
369 
370     coinContract = ERC20Basic(_coinAddress);
371     storageContract = IStorage(_storageContract);
372     currencyContract = ICurrency(_currencyContract);
373     bonusContract = IBonus(_bonusContract);
374 
375     multiSig1 = _multiSig1;
376     multiSig2 = 0x231121dFCB61C929BCdc0D1E6fC760c84e9A02ad;
377 
378     startPreSaleDate = _startPreSaleDate;
379     endPreSaleDate = _endPreSaleDate;
380     startSaleDate = _startSaleDate;
381     endSaleDate = _endSaleDate;
382 
383     unfreezeRefundPreSale = _endSaleDate;
384     unfreezeRefundAll = _endSaleDate.add(ONE_DAY);
385 
386     state = SaleState.NEW;
387   }
388 
389   /**
390  * @dev called by the owner to pause, triggers stopped state
391  */
392   function pause() public onlyOwner {
393     paused = true;
394   }
395 
396   /**
397    * @dev called by the owner to unpause, returns to normal state
398    */
399   function unpause() public onlyOwner {
400     paused = false;
401   }
402 
403   /**
404    * @dev Change the minimum amount in dollars indicated in cents to accept payment.
405    * @param minContribUsd in cents
406    */
407   function setMinimalContributionUSD(uint minContribUsd) public onlyOwner {
408     require(minContribUsd > 100); // > 1$
409     uint oldMinAmount = minimalContributionUSD;
410     minimalContributionUSD = minContribUsd;
411     emit ChangeMinContribUSD(oldMinAmount, minimalContributionUSD);
412   }
413 
414   /**
415    * @dev Set the time when contributors can receive tokens
416    * @param _time timestamp
417    */
418   function setUnfreezeRefund(uint _time) public onlyOwner {
419     require(_time > startSaleDate);
420     unfreezeRefundPreSale = _time;
421     unfreezeRefundAll = _time.add(ONE_DAY);
422   }
423 
424   /**
425    * @dev Change address ShipCoinStorage contracts.
426    * @param _storageContract address ShipCoinStorage contracts
427    */
428   function setStorageContract(address _storageContract) public onlyOwner {
429     require(_storageContract != address(0));
430     address oldStorageContract = storageContract;
431     storageContract = IStorage(_storageContract);
432     emit ChangeStorageContract(oldStorageContract, storageContract);
433   }
434 
435   /**
436    * @dev Change address ShipCoin contracts.
437    * @param _coinContract address ShipCoin contracts
438    */
439   function setCoinContract(address _coinContract) public onlyOwner {
440     require(_coinContract != address(0));
441     address oldCoinContract = coinContract;
442     coinContract = ERC20Basic(_coinContract);
443     emit ChangeCoinContract(oldCoinContract, coinContract);
444   }
445 
446   /**
447    * @dev Change address ShipCoinCurrency contracts.
448    * @param _currencyContract address ShipCoinCurrency contracts
449    */
450   function setCurrencyContract(address _currencyContract) public onlyOwner {
451     require(_currencyContract != address(0));
452     address oldCurContract = currencyContract;
453     currencyContract = ICurrency(_currencyContract);
454     emit ChangeCurrencyContract(oldCurContract, currencyContract);
455   }
456 
457   /**
458    * @dev Change address ShipCoinBonusSystem contracts.
459    * @param _bonusContract address ShipCoinBonusSystem contracts
460    */
461   function setBonusContract(address _bonusContract) public onlyOwner {
462     require(_bonusContract != address(0));
463     address oldContract = _bonusContract;
464     bonusContract = IBonus(_bonusContract);
465     emit ChangeBonusContract(oldContract, bonusContract);
466   }
467 
468   /**
469    * @dev Change address multiSig1.
470    * @param _address address multiSig1
471    */
472   function setMultisig(address _address) public onlyOwner {
473     require(_address != address(0));
474     multiSig1 = _address;
475   }
476 
477   /**
478    * @dev Set softCapUSD
479    * @param _softCapUsdInCents uint softCapUSD > 100000
480    */
481   function setSoftCap(uint _softCapUsdInCents) public onlyOwner {
482     require(_softCapUsdInCents > 100000);
483     softCapUSD = _softCapUsdInCents;
484     emit SoftCapChanged();
485   }
486 
487   /**
488    * @dev Change maximum number of tokens sold
489    * @param _maxCoin maxDistributeCoin
490    */
491   function changeMaxDistributeCoin(uint _maxCoin) public onlyOwner {
492     require(_maxCoin > 0 && _maxCoin >= currencyContract.getCoinRaisedInWei());
493     maxDistributeCoin = _maxCoin;
494   }
495 
496   /**
497    * @dev Change status. Start presale.
498    */
499   function startPreSale() public onlyMultiOwnersType(1) {
500     require(block.timestamp <= endPreSaleDate);
501     require(state == SaleState.NEW);
502 
503     state = SaleState.PRESALE;
504     emit ChangeState(block.number, state);
505   }
506 
507   /**
508    * @dev Change status. Start calculate presale bonus.
509    */
510   function startCalculatePreSaleBonus() public onlyMultiOwnersType(5) {
511     require(state == SaleState.PRESALE);
512 
513     state = SaleState.CALCPSBONUS;
514     emit ChangeState(block.number, state);
515   }
516 
517   /**
518    * @dev Change status. Start sale.
519    */
520   function startSale() public onlyMultiOwnersType(2) {
521     require(block.timestamp <= endSaleDate);
522     require(state == SaleState.CALCPSBONUS);
523     //require(!storageContract.checkNeedProcessPreSaleBonus(getMinReachUsdPayInCents()));
524 
525     state = SaleState.SALE;
526     emit ChangeState(block.number, state);
527   }
528 
529   /**
530    * @dev Change status. Set end if sale it was successful.
531    */
532   function saleSetEnded() public onlyMultiOwnersType(3) {
533     require((state == SaleState.SALE) || (state == SaleState.PRESALE));
534     require(block.timestamp >= startSaleDate);
535     require(checkSoftCapAchieved());
536     state = SaleState.END;
537     storageContract.changeSupportChangeMainWallet(false);
538     emit ChangeState(block.number, state);
539   }
540 
541   /**
542    * @dev Change status. Set refund when sale did not reach softcap.
543    */
544   function saleSetRefund() public onlyMultiOwnersType(4) {
545     require((state == SaleState.SALE) || (state == SaleState.PRESALE));
546     require(block.timestamp >= endSaleDate);
547     require(!checkSoftCapAchieved());
548     state = SaleState.REFUND;
549     emit ChangeState(block.number, state);
550   }
551 
552   /**
553    * @dev Payable function. Processes contribution in ETH.
554    */
555   function buyTokens(address _beneficiary) public whenNotPaused payable {
556     require((state == SaleState.PRESALE && block.timestamp >= startPreSaleDate && block.timestamp <= endPreSaleDate) || (state == SaleState.SALE && block.timestamp >= startSaleDate && block.timestamp <= endSaleDate));
557     require(_beneficiary != address(0));
558     require(msg.value > 0);
559     uint usdAmount = currencyContract.getUsdFromETH(msg.value);
560 
561     assert(usdAmount >= minimalContributionUSD);
562 
563     uint bonusPercent = 0;
564 
565     if (state == SaleState.SALE) {
566       bonusPercent = bonusContract.getCurrentDayBonus(startSaleDate, (state == SaleState.SALE));
567     }
568 
569     (uint totalToken, uint tokenWithoutBonus, uint tokenBonus) = calcToken(usdAmount, bonusPercent);
570 
571     assert((totalToken > 0 && totalToken <= calculateMaxCoinIssued()));
572 
573     uint usdRate = currencyContract.getCurrencyRate("ETH");
574 
575     assert(storageContract.addPayment(_beneficiary, "ETH", msg.value, usdAmount, usdRate, tokenWithoutBonus, tokenBonus, bonusPercent, 0));
576     assert(currencyContract.addPay("ETH", msg.value, usdAmount, totalToken, tokenBonus));
577 
578     emit AddPay(_beneficiary);
579   }
580 
581   /**
582    * @dev Manually add alternative contribution payment.
583    * @param ticker string
584    * @param value uint
585    * @param uId uint contributor identificator
586    * @param _pId uint payment identificator
587    * @param _currencyUSD uint current ticker rate (optional field)
588    */
589   function addPay(string ticker, uint value, uint uId, uint _pId, uint _currencyUSD) public onlyMultiOwnersType(6) {
590     require(value > 0);
591     require(storageContract.checkUserIdExists(uId));
592     require(_pId > 0);
593 
594     string memory _ticker = ticker;
595     uint _value = value;
596     assert(currencyContract.checkTickerExists(_ticker));
597     uint usdAmount = currencyContract.getUsdFromCurrency(_ticker, _value, _currencyUSD);
598 
599     assert(usdAmount > 0);
600 
601     uint bonusPercent = 0;
602 
603     if (state == SaleState.SALE) {
604       bonusPercent = bonusContract.getCurrentDayBonus(startSaleDate, (state == SaleState.SALE));
605     }
606 
607     (uint totalToken, uint tokenWithoutBonus, uint tokenBonus) = calcToken(usdAmount, bonusPercent);
608 
609     assert(tokenWithoutBonus > 0);
610 
611     uint usdRate = _currencyUSD > 0 ? _currencyUSD : currencyContract.getCurrencyRate(_ticker);
612 
613     uint pId = _pId;
614 
615     assert(storageContract.addPayment(uId, _ticker, _value, usdAmount, usdRate, tokenWithoutBonus, tokenBonus, bonusPercent, pId));
616     assert(currencyContract.addPay(_ticker, _value, usdAmount, totalToken, tokenBonus));
617 
618     emit AddPay(storageContract.getContributorAddressById(uId));
619   }
620 
621   /**
622    * @dev Edit contribution payment.
623    * @param uId uint contributor identificator
624    * @param payId uint payment identificator
625    * @param value uint
626    * @param _currencyUSD uint current ticker rate (optional field)
627    * @param _bonusPercent uint current ticker rate (optional field)
628    */
629   function editPay(uint uId, uint payId, uint value, uint _currencyUSD, uint _bonusPercent) public onlyMultiOwnersType(7) {
630     require(value > 0);
631     require(storageContract.checkUserIdExists(uId));
632     require(payId > 0);
633     require((_bonusPercent == 0 || _bonusPercent <= getPreSaleBonusPercent()));
634 
635     PaymentInfo memory payment = getPaymentInfo(uId, payId);
636     EditPaymentInfo memory paymentInfo = calcEditPaymentInfo(payment, value, _currencyUSD, _bonusPercent);
637 
638     assert(paymentInfo.tokenWithoutBonus > 0);
639     assert(paymentInfo.currency.value > 0);
640     assert(paymentInfo.currency.usdRaised > 0);
641     assert(paymentInfo.currency.usdAbsRaisedInCents > 0);
642     assert(paymentInfo.currency.coinRaisedInWei > 0);
643 
644     assert(currencyContract.editPay(payment.pType, paymentInfo.currency.value, paymentInfo.currency.usdRaised, paymentInfo.currency.usdAbsRaisedInCents, paymentInfo.currency.coinRaisedInWei, paymentInfo.currency.coinRaisedBonusInWei));
645     assert(storageContract.editPaymentByUserId(uId, payId, value, paymentInfo.usdAmount, paymentInfo.currencyUSD, paymentInfo.totalToken, paymentInfo.tokenWithoutBonus, paymentInfo.tokenBonus, paymentInfo.bonusPercent));
646 
647     assert(reCountUserPreSaleBonus(uId));
648 
649     emit EditPay(storageContract.getContributorAddressById(uId));
650   }
651 
652   /**
653    * @dev Refund contribution payment.
654    * @param uId uint
655    * @param payId uint
656    */
657   function refundPay(uint uId, uint payId) public onlyMultiOwnersType(18) {
658     require(storageContract.checkUserIdExists(uId));
659     require(payId > 0);
660 
661     (CurrencyInfo memory currencyInfo, bytes32 pType) = calcCurrency(getPaymentInfo(uId, payId), 0, 0, 0, 0);
662 
663     assert(storageContract.refundPaymentByUserId(uId, payId));
664     assert(currencyContract.editPay(pType, currencyInfo.value, currencyInfo.usdRaised, currencyInfo.usdAbsRaisedInCents, currencyInfo.coinRaisedInWei, currencyInfo.coinRaisedBonusInWei));
665 
666     assert(reCountUserPreSaleBonus(uId));
667 
668     emit RefundPay(storageContract.getContributorAddressById(uId));
669   }
670 
671   /**
672    * @dev Check if softCap is reached
673    */
674   function checkSoftCapAchieved() public view returns(bool) {
675     return softCapAchieved || getTotalUsdRaisedInCents() >= softCapUSD;
676   }
677 
678   /**
679    * @dev Set softCapAchieved=true if softCap is reached
680    */
681   function activeSoftCapAchieved() public onlyMultiOwnersType(8) {
682     require(checkSoftCapAchieved());
683     require(getCoinBalance() >= maxDistributeCoin);
684     softCapAchieved = true;
685     emit SoftCapAchieved(getTotalUsdRaisedInCents());
686   }
687 
688   /**
689    * @dev Send ETH from contract balance to multiSig.
690    */
691   function getEther() public onlyMultiOwnersType(9) {
692     require(getETHBalance() > 0);
693     require(softCapAchieved && (!multiSigReceivedSoftCap || (state == SaleState.END)));
694 
695     uint sendEther = (address(this).balance / 2);
696     assert(sendEther > 0);
697 
698     address(multiSig1).transfer(sendEther);
699     address(multiSig2).transfer(sendEther);
700     multiSigReceivedSoftCap = true;
701   }
702 
703   /**
704    * @dev Return maximum amount buy token.
705    */
706   function calculateMaxCoinIssued() public view returns (uint) {
707     return maxDistributeCoin - currencyContract.getCoinRaisedInWei();
708   }
709 
710   /**
711    * @dev Return raised SHPC in wei.
712    */
713   function getCoinRaisedInWei() public view returns (uint) {
714     return currencyContract.getCoinRaisedInWei();
715   }
716 
717   /**
718    * @dev Return raised usd in cents.
719    */
720   function getTotalUsdRaisedInCents() public view returns (uint) {
721     return currencyContract.getTotalUsdRaisedInCents();
722   }
723 
724   /**
725    * @dev Return all currency rate in json.
726    */
727   function getAllCurrencyTicker() public view returns (string) {
728     return currencyContract.getAllCurrencyTicker();
729   }
730 
731   /**
732    * @dev Return SHPC price in cents.
733    */
734   function getCoinUSDRate() public view returns (uint) {
735     return currencyContract.getCoinUSDRate();
736   }
737 
738   /**
739    * @dev Retrun SHPC balance in contract.
740    */
741   function getCoinBalance() public view returns (uint) {
742     return coinContract.balanceOf(address(this));
743   }
744 
745   /**
746    * @dev Return balance ETH from contract.
747    */
748   function getETHBalance() public view returns (uint) {
749     return address(this).balance;
750   }
751 
752   /**
753    * @dev Processing of the data of the contributors. Bonus assignment for presale.
754    * @param start uint > 0
755    * @param limit uint > 0
756    */
757   function processSetPreSaleBonus(uint start, uint limit) public onlyMultiOwnersType(10) {
758     require(state == SaleState.CALCPSBONUS);
759     require(start >= 0 && limit > 0);
760     //require(storageContract.checkNeedProcessPreSaleBonus(getMinReachUsdPayInCents()));
761     uint bonusToken = storageContract.processPreSaleBonus(getMinReachUsdPayInCents(), getPreSaleBonusPercent(), start, limit);
762     if (bonusToken > 0) {
763       assert(currencyContract.addPreSaleBonus(bonusToken));
764     }
765   }
766 
767   /**
768    * @dev Processing of the data of the contributor by uId. Bonus assignment for presale.
769    * @param uId uint
770    */
771   function reCountUserPreSaleBonus(uint uId) public onlyMultiOwnersType(11) returns(bool) {
772     if (uint(state) > 1) { // > PRESALE
773       uint maxPayTime = 0;
774       if (state != SaleState.CALCPSBONUS) {
775         maxPayTime = startSaleDate;
776       }
777       (uint befTokenBonus, uint aftTokenBonus) = storageContract.reCountUserPreSaleBonus(uId, getMinReachUsdPayInCents(), getPreSaleBonusPercent(), maxPayTime);
778       assert(currencyContract.editPreSaleBonus(befTokenBonus, aftTokenBonus));
779     }
780     return true;
781   }
782 
783   /**
784    * @dev Contributor get SHPC.
785    */
786   function getCoins() public {
787     return _getCoins(msg.sender);
788   }
789 
790   /**
791    * @dev Send contributors SHPC.
792    * @param start uint
793    * @param limit uint
794    */
795   function sendSHPCtoContributors(uint start, uint limit) public onlyMultiOwnersType(12) {
796     require(state == SaleState.END);
797     require(start >= 0 && limit > 0);
798     require(getCoinBalance() > 0);
799     //require(storageContract.checkNeedSendSHPC(state == SaleState.END));
800 
801     for (uint i = start; i < limit; i++) {
802       uint uId = storageContract.getContributorIndexes(i);
803       if (uId > 0) {
804         address addr = storageContract.getContributorAddressById(uId);
805         uint coins = storageContract.getTotalCoin(addr);
806         if (!storageContract.checkReceivedCoins(addr) && storageContract.checkWalletExists(addr) && coins > 0 && ((storageContract.checkPreSaleReceivedBonus(addr) && block.timestamp >= unfreezeRefundPreSale) || (!storageContract.checkPreSaleReceivedBonus(addr) && block.timestamp >= unfreezeRefundAll))) {
807           if (coinContract.transfer(addr, coins)) {
808             storageContract.setReceivedCoin(uId);
809             emit SendSHPCtoContributor(addr);
810           }
811         }
812       }
813     }
814   }
815 
816   /**
817    * @dev Set startPreSaleDate
818    * @param date timestamp
819    */
820   function setStartPreSaleDate(uint date) public onlyMultiOwnersType(13) {
821     uint oldDate = startPreSaleDate;
822     startPreSaleDate = date;
823     emit ManualChangeStartPreSaleDate(oldDate, date);
824   }
825 
826   /**
827    * @dev Set startPreSaleDate
828    * @param date timestamp
829    */
830   function setEndPreSaleDate(uint date) public onlyMultiOwnersType(14) {
831     uint oldDate = endPreSaleDate;
832     endPreSaleDate = date;
833     emit ManualChangeEndPreSaleDate(oldDate, date);
834   }
835 
836   /**
837    * @dev Set startSaleDate
838    * @param date timestamp
839    */
840   function setStartSaleDate(uint date) public onlyMultiOwnersType(15) {
841     uint oldDate = startSaleDate;
842     startSaleDate = date;
843     emit ManualChangeStartSaleDate(oldDate, date);
844   }
845 
846   /**
847    * @dev Set endSaleDate
848    * @param date timestamp
849    */
850   function setEndSaleDate(uint date) public onlyMultiOwnersType(16) {
851     uint oldDate = endSaleDate;
852     endSaleDate = date;
853     emit ManualEndSaleDate(oldDate, date);
854   }
855 
856   /**
857    * @dev Return SHPC from contract. When sale ended end contributor got SHPC.
858    */
859   function getSHPCBack() public onlyMultiOwnersType(17) {
860     require(state == SaleState.END);
861     require(getCoinBalance() > 0);
862     //require(!storageContract.checkNeedSendSHPC(state == SaleState.END));
863     coinContract.transfer(msg.sender, getCoinBalance());
864   }
865 
866 
867   /**
868    * @dev Refund ETH contributor.
869    */
870   function refundETH() public {
871     return _refundETH(msg.sender);
872   }
873 
874   /**
875    * @dev Refund ETH contributors.
876    * @param start uint
877    * @param limit uint
878    */
879   function refundETHContributors(uint start, uint limit) public onlyMultiOwnersType(19) {
880     require(state == SaleState.REFUND);
881     require(start >= 0 && limit > 0);
882     require(getETHBalance() > 0);
883     //require(storageContract.checkETHRefund(state == SaleState.REFUND));
884 
885     for (uint i = start; i < limit; i++) {
886       uint uId = storageContract.getContributorIndexes(i);
887       if (uId > 0) {
888         address addr = storageContract.getContributorAddressById(uId);
889         uint ethAmount = storageContract.getEthPaymentContributor(addr);
890 
891         if (!storageContract.checkRefund(addr) && storageContract.checkWalletExists(addr) && ethAmount > 0) {
892           storageContract.setRefund(uId);
893           addr.transfer(ethAmount);
894           emit Refund(addr);
895         }
896       }
897     }
898   }
899 
900   /**
901    * @dev Return pre-sale bonus getPreSaleBonusPercent.
902    */
903   function getPreSaleBonusPercent() public view returns(uint) {
904     return bonusContract.getPreSaleBonusPercent();
905   }
906 
907   /**
908    * @dev Return pre-sale minReachUsdPayInCents.
909    */
910   function getMinReachUsdPayInCents() public view returns(uint) {
911     return bonusContract.getMinReachUsdPayInCents();
912   }
913 
914   /**
915    * @dev Return current sale day.
916    */
917   function _currentDay() public view returns(uint) {
918     return bonusContract._currentDay(startSaleDate, (state == SaleState.SALE));
919   }
920 
921   /**
922    * @dev Return current sale day bonus percent.
923    */
924   function getCurrentDayBonus() public view returns(uint) {
925     return bonusContract.getCurrentDayBonus(startSaleDate, (state == SaleState.SALE));
926   }
927 
928   /**
929    * @dev Return contributor payment info.
930    * @param uId uint
931    * @param pId uint
932    */
933   function getPaymentInfo(uint uId, uint pId) private view returns(PaymentInfo) {
934     (, bytes32 pType,
935     uint currencyUSD,
936     uint bonusPercent,
937     uint payValue,
938     uint totalToken,
939     uint tokenBonus,,
940     uint usdAbsRaisedInCents,
941     bool refund) = storageContract.getUserPaymentById(uId, pId);
942 
943     return PaymentInfo(pType, currencyUSD, bonusPercent, payValue, totalToken, tokenBonus, usdAbsRaisedInCents, refund);
944   }
945 
946   /**
947    * @dev Return recalculate payment data from old payment user.
948    */
949   function calcEditPaymentInfo(PaymentInfo payment, uint value, uint _currencyUSD, uint _bonusPercent) private view returns(EditPaymentInfo) {
950     (uint usdAmount, uint currencyUSD, uint bonusPercent) = getUsdAmountFromPayment(payment, value, _currencyUSD, _bonusPercent);
951     (uint totalToken, uint tokenWithoutBonus, uint tokenBonus) = calcToken(usdAmount, bonusPercent);
952     (CurrencyInfo memory currency,) = calcCurrency(payment, value, usdAmount, totalToken, tokenBonus);
953 
954     return EditPaymentInfo(usdAmount, currencyUSD, bonusPercent, totalToken, tokenWithoutBonus, tokenBonus, currency);
955   }
956 
957   /**
958    * @dev Return usd from payment amount.
959    */
960   function getUsdAmountFromPayment(PaymentInfo payment, uint value, uint _currencyUSD, uint _bonusPercent) private view returns(uint, uint, uint) {
961     _currencyUSD = _currencyUSD > 0 ? _currencyUSD : payment.currencyUSD;
962     _bonusPercent = _bonusPercent > 0 ? _bonusPercent : payment.bonusPercent;
963     uint usdAmount = currencyContract.getUsdFromCurrency(payment.pType, value, _currencyUSD);
964     return (usdAmount, _currencyUSD, _bonusPercent);
965   }
966 
967   /**
968    * @dev Return payment SHPC data from usd amount and bonusPercent
969    */
970   function calcToken(uint usdAmount, uint _bonusPercent) private view returns(uint, uint, uint) {
971     uint tokenWithoutBonus = currencyContract.getTokenWeiFromUSD(usdAmount);
972     uint tokenBonus = _bonusPercent > 0 ? tokenWithoutBonus.mul(_bonusPercent).div(100) : 0;
973     uint totalToken = tokenBonus > 0 ? tokenWithoutBonus.add(tokenBonus) : tokenWithoutBonus;
974     return (totalToken, tokenWithoutBonus, tokenBonus);
975   }
976 
977   /**
978    * @dev Calculate currency data when edit user payment data
979    */
980   function calcCurrency(PaymentInfo payment, uint value, uint usdAmount, uint totalToken, uint tokenBonus) private view returns(CurrencyInfo, bytes32) {
981     (,,, uint currencyValue, uint currencyUsdRaised,,,) = currencyContract.getCurrencyList(payment.pType);
982 
983     uint usdAbsRaisedInCents = currencyContract.getUsdAbsRaisedInCents();
984     uint coinRaisedInWei = currencyContract.getCoinRaisedInWei();
985     uint coinRaisedBonusInWei = currencyContract.getCoinRaisedBonusInWei();
986 
987     currencyValue -= payment.payValue;
988     currencyUsdRaised -= payment.usdAbsRaisedInCents;
989 
990     usdAbsRaisedInCents -= payment.usdAbsRaisedInCents;
991     coinRaisedInWei -= payment.totalToken;
992     coinRaisedBonusInWei -= payment.tokenBonus;
993 
994     currencyValue += value;
995     currencyUsdRaised += usdAmount;
996 
997     usdAbsRaisedInCents += usdAmount;
998     coinRaisedInWei += totalToken;
999     coinRaisedBonusInWei += tokenBonus;
1000 
1001     return (CurrencyInfo(currencyValue, currencyUsdRaised, usdAbsRaisedInCents, coinRaisedInWei, coinRaisedBonusInWei), payment.pType);
1002   }
1003 
1004   /**
1005    * @dev Getting the SHPC from the contributor
1006    */
1007   function _getCoins(address addr) private {
1008     require(state == SaleState.END);
1009     require(storageContract.checkWalletExists(addr));
1010     require(!storageContract.checkReceivedCoins(addr));
1011     require((storageContract.checkPreSaleReceivedBonus(addr) && block.timestamp >= unfreezeRefundPreSale) || (!storageContract.checkPreSaleReceivedBonus(addr) && block.timestamp >= unfreezeRefundAll));
1012     uint uId = storageContract.getContributorId(addr);
1013     uint coins = storageContract.getTotalCoin(addr);
1014     assert(uId > 0 && coins > 0);
1015     if (coinContract.transfer(addr, coins)) {
1016       storageContract.setReceivedCoin(uId);
1017       emit SendSHPCtoContributor(addr);
1018     }
1019   }
1020 
1021   /**
1022    * @dev Refund ETH contributor when sale not reach softcap.
1023    */
1024   function _refundETH(address addr) private {
1025     require(state == SaleState.REFUND);
1026     require(storageContract.checkWalletExists(addr));
1027     require(!storageContract.checkRefund(addr));
1028 
1029     uint uId = storageContract.getContributorId(addr);
1030     uint ethAmount = storageContract.getEthPaymentContributor(addr);
1031     assert(uId > 0 && ethAmount > 0 && getETHBalance() >= ethAmount);
1032 
1033     storageContract.setRefund(uId);
1034     addr.transfer(ethAmount);
1035     emit Refund(addr);
1036   }
1037 
1038 }