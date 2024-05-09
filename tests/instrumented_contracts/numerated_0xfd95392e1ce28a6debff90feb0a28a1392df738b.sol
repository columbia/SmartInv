1 pragma solidity ^0.4.11;
2 
3 /**
4  * Math operations with safety checks
5  */
6 library SafeMath {
7   function mul(uint256 a, uint256 b) internal returns (uint256) {
8     uint256 c = a * b;
9     assert(a == 0 || c / a == b);
10     return c;
11   }
12 
13   function div(uint256 a, uint256 b) internal returns (uint256) {
14     // assert(b > 0); // Solidity automatically throws when dividing by 0
15     uint256 c = a / b;
16     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
17     return c;
18   }
19 
20   function sub(uint256 a, uint256 b) internal returns (uint256) {
21     assert(b <= a);
22     return a - b;
23   }
24 
25   function add(uint256 a, uint256 b) internal returns (uint256) {
26     uint256 c = a + b;
27     assert(c >= a);
28     return c;
29   }
30 
31   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
32     return a >= b ? a : b;
33   }
34 
35   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
36     return a < b ? a : b;
37   }
38 
39   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
40     return a >= b ? a : b;
41   }
42 
43   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
44     return a < b ? a : b;
45   }
46 
47 }
48 
49 /**
50  * @title Ownable
51  * @dev The Ownable contract has an owner address, and provides basic authorization control 
52  * functions, this simplifies the implementation of "user permissions". 
53  */
54 contract Ownable {
55   address public owner;
56 
57 
58   /** 
59    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
60    * account.
61    */
62   function Ownable() {
63     owner = msg.sender;
64   }
65 
66 
67   /**
68    * @dev Throws if called by any account other than the owner. 
69    */
70   modifier onlyOwner() {
71     if (msg.sender != owner) {
72       throw;
73     }
74     _;
75   }
76 
77 
78   /**
79    * @dev Allows the current owner to transfer control of the contract to a newOwner.
80    * @param newOwner The address to transfer ownership to. 
81    */
82   function transferOwnership(address newOwner) onlyOwner {
83     if (newOwner != address(0)) {
84       owner = newOwner;
85     }
86   }
87 
88 }
89 
90 /**
91  * @title ERC20Basic
92  * @dev Simpler version of ERC20 interface
93  * @dev see https://github.com/ethereum/EIPs/issues/20
94  */
95 contract ERC20Basic {
96   uint256 public totalSupply;
97   function balanceOf(address who) constant returns (uint256);
98   function transfer(address to, uint256 value);
99   event Transfer(address indexed from, address indexed to, uint256 value);
100 }
101 
102 /**
103  * @title ERC20 interface
104  * @dev see https://github.com/ethereum/EIPs/issues/20
105  */
106 contract ERC20 is ERC20Basic {
107   function allowance(address owner, address spender) constant returns (uint256);
108   function transferFrom(address from, address to, uint256 value);
109   function approve(address spender, uint256 value);
110   event Approval(address indexed owner, address indexed spender, uint256 value);
111 }
112 
113 contract BasicToken is ERC20Basic {
114   using SafeMath for uint256;
115 
116   mapping(address => uint256) balances;
117 
118   /**
119    * @dev Fix for the ERC20 short address attack.
120    */
121   modifier onlyPayloadSize(uint256 size) {
122      if(msg.data.length < size + 4) {
123        throw;
124      }
125      _;
126   }
127 
128   /**
129   * @dev transfer token for a specified address
130   * @param _to The address to transfer to.
131   * @param _value The amount to be transferred.
132   */
133   function transfer(address _to, uint256 _value) onlyPayloadSize(2 * 32) {
134     balances[msg.sender] = balances[msg.sender].sub(_value);
135     balances[_to] = balances[_to].add(_value);
136     Transfer(msg.sender, _to, _value);
137   }
138 
139   /**
140   * @dev Gets the balance of the specified address.
141   * @param _owner The address to query the the balance of. 
142   * @return An uint256 representing the amount owned by the passed address.
143   */
144   function balanceOf(address _owner) constant returns (uint256 balance) {
145     return balances[_owner];
146   }
147 
148 }
149 
150 /**
151  * @title Standard ERC20 token
152  *
153  * @dev Implemantation of the basic standart token.
154  * @dev https://github.com/ethereum/EIPs/issues/20
155  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
156  */
157 contract StandardToken is BasicToken, ERC20 {
158 
159   mapping (address => mapping (address => uint256)) allowed;
160 
161 
162   /**
163    * @dev Transfer tokens from one address to another
164    * @param _from address The address which you want to send tokens from
165    * @param _to address The address which you want to transfer to
166    * @param _value uint256 the amout of tokens to be transfered
167    */
168   function transferFrom(address _from, address _to, uint256 _value) onlyPayloadSize(3 * 32) {
169     var _allowance = allowed[_from][msg.sender];
170 
171     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
172     // if (_value > _allowance) throw;
173 
174     balances[_to] = balances[_to].add(_value);
175     balances[_from] = balances[_from].sub(_value);
176     allowed[_from][msg.sender] = _allowance.sub(_value);
177     Transfer(_from, _to, _value);
178   }
179 
180   /**
181    * @dev Aprove the passed address to spend the specified amount of tokens on beahlf of msg.sender.
182    * @param _spender The address which will spend the funds.
183    * @param _value The amount of tokens to be spent.
184    */
185   function approve(address _spender, uint256 _value) {
186 
187     // To change the approve amount you first have to reduce the addresses`
188     //  allowance to zero by calling `approve(_spender, 0)` if it is not
189     //  already 0 to mitigate the race condition described here:
190     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
191     if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;
192 
193     allowed[msg.sender][_spender] = _value;
194     Approval(msg.sender, _spender, _value);
195   }
196 
197   /**
198    * @dev Function to check the amount of tokens than an owner allowed to a spender.
199    * @param _owner address The address which owns the funds.
200    * @param _spender address The address which will spend the funds.
201    * @return A uint256 specifing the amount of tokens still avaible for the spender.
202    */
203   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
204     return allowed[_owner][_spender];
205   }
206 
207 }
208 
209 contract CryptoABS is StandardToken, Ownable {
210   string public name;                                   // 名稱
211   string public symbol;                                 // token 代號
212   uint256 public decimals = 0;                          // decimals
213   address public contractAddress;                       // contract address
214 
215   uint256 public minInvestInWei;                        // 最低投資金額 in wei
216   uint256 public tokenExchangeRateInWei;                // 1 Token = n ETH in wei
217 
218   uint256 public startBlock;                            // ICO 起始的 block number
219   uint256 public endBlock;                              // ICO 結束的 block number
220   uint256 public maxTokenSupply;                        // ICO 的 max token，透過 USD to ETH 換算出來
221   
222   uint256 public initializedTime;                       // 起始時間，合約部署的時候會寫入
223   uint256 public financingPeriod;                       // token 籌資期間
224   uint256 public tokenLockoutPeriod;                    // token 閉鎖期，閉鎖期內不得 transfer
225   uint256 public tokenMaturityPeriod;                   // token 到期日
226 
227   bool public paused;                                   // 暫停合約功能執行
228   bool public initialized;                              // 合約啟動
229   uint256 public finalizedBlock;                        // 合約終止投資的區塊編號
230   uint256 public finalizedTime;                         // 合約終止投資的時間
231   uint256 public finalizedCapital;                      // 合約到期的 ETH 金額
232 
233   struct ExchangeRate {
234     uint256 blockNumber;                                // block number
235     uint256 exchangeRateInWei;                          // 1 USD = n ETH in wei, 派發利息使用的利率基準
236   }
237 
238   ExchangeRate[] public exchangeRateArray;              // exchange rate array
239   uint256 public nextExchangeRateIndex;                 // exchange rate last index
240   
241   uint256[] public interestArray;                       // interest array
242 
243   struct Payee {
244     bool isExists;                                      // payee 存在
245     bool isPayable;                                     // payee 允許領錢
246     uint256 interestInWei;                              // 待領利息金額
247   }
248 
249   mapping (address => Payee) public payees; 
250   address[] public payeeArray;                          // payee array
251   uint256 public nextPayeeIndex;                        // payee deposite interest index
252 
253   struct Asset {
254     string data;                                        // asset data
255   }
256 
257   Asset[] public assetArray;                            // asset array
258 
259   /**
260    * @dev Throws if contract paused.
261    */
262   modifier notPaused() {
263     require(paused == false);
264     _;
265   }
266 
267   /**
268    * @dev Throws if contract is paused.
269    */
270   modifier isPaused() {
271     require(paused == true);
272     _;
273   }
274 
275   /**
276    * @dev Throws if not a payee. 
277    */
278   modifier isPayee() {
279     require(payees[msg.sender].isPayable == true);
280     _;
281   }
282 
283   /**
284    * @dev Throws if contract not initialized. 
285    */
286   modifier isInitialized() {
287     require(initialized == true);
288     _;
289   }
290 
291   /**
292    * @dev Throws if contract not open. 
293    */
294   modifier isContractOpen() {
295     require(
296       getBlockNumber() >= startBlock &&
297       getBlockNumber() <= endBlock &&
298       finalizedBlock == 0);
299     _;
300   }
301 
302   /**
303    * @dev Throws if token in lockout period. 
304    */
305   modifier notLockout() {
306     require(now > (initializedTime + financingPeriod + tokenLockoutPeriod));
307     _;
308   }
309   
310   /**
311    * @dev Throws if not over maturity date. 
312    */
313   modifier overMaturity() {
314     require(now > (initializedTime + financingPeriod + tokenMaturityPeriod));
315     _;
316   }
317 
318   /**
319    * @dev Contract constructor.
320    */
321   function CryptoABS() {
322     paused = false;
323   }
324 
325   /**
326    * @dev Initialize contract with inital parameters. 
327    * @param _name name of token
328    * @param _symbol symbol of token
329    * @param _contractAddress contract deployed address
330    * @param _startBlock start block number
331    * @param _endBlock end block number
332    * @param _initializedTime contract initalized time
333    * @param _financingPeriod contract financing period
334    * @param _tokenLockoutPeriod contract token lockout period
335    * @param _tokenMaturityPeriod contract token maturity period
336    * @param _minInvestInWei minimum wei accept of invest
337    * @param _maxTokenSupply maximum toke supply
338    * @param _tokenExchangeRateInWei token exchange rate in wei
339    * @param _exchangeRateInWei eth exchange rate in wei
340    */
341   function initialize(
342       string _name,
343       string _symbol,
344       uint256 _decimals,
345       address _contractAddress,
346       uint256 _startBlock,
347       uint256 _endBlock,
348       uint256 _initializedTime,
349       uint256 _financingPeriod,
350       uint256 _tokenLockoutPeriod,
351       uint256 _tokenMaturityPeriod,
352       uint256 _minInvestInWei,
353       uint256 _maxTokenSupply,
354       uint256 _tokenExchangeRateInWei,
355       uint256 _exchangeRateInWei) onlyOwner {
356     require(bytes(name).length == 0);
357     require(bytes(symbol).length == 0);
358     require(decimals == 0);
359     require(contractAddress == 0x0);
360     require(totalSupply == 0);
361     require(decimals == 0);
362     require(_startBlock >= getBlockNumber());
363     require(_startBlock < _endBlock);
364     require(financingPeriod == 0);
365     require(tokenLockoutPeriod == 0);
366     require(tokenMaturityPeriod == 0);
367     require(initializedTime == 0);
368     require(_maxTokenSupply >= totalSupply);
369     name = _name;
370     symbol = _symbol;
371     decimals = _decimals;
372     contractAddress = _contractAddress;
373     startBlock = _startBlock;
374     endBlock = _endBlock;
375     initializedTime = _initializedTime;
376     financingPeriod = _financingPeriod;
377     tokenLockoutPeriod = _tokenLockoutPeriod;
378     tokenMaturityPeriod = _tokenMaturityPeriod;
379     minInvestInWei = _minInvestInWei;
380     maxTokenSupply = _maxTokenSupply;
381     tokenExchangeRateInWei = _tokenExchangeRateInWei;
382     ownerSetExchangeRateInWei(_exchangeRateInWei);
383     initialized = true;
384   }
385 
386   /**
387    * @dev Finalize contract
388    */
389   function finalize() public isInitialized {
390     require(getBlockNumber() >= startBlock);
391     require(msg.sender == owner || getBlockNumber() > endBlock);
392 
393     finalizedBlock = getBlockNumber();
394     finalizedTime = now;
395 
396     Finalized();
397   }
398 
399   /**
400    * @dev fallback function accept ether
401    */
402   function () payable notPaused {
403     proxyPayment(msg.sender);
404   }
405 
406   /**
407    * @dev payment function, transfer eth to token
408    * @param _payee The payee address
409    */
410   function proxyPayment(address _payee) public payable notPaused isInitialized isContractOpen returns (bool) {
411     require(msg.value > 0);
412 
413     uint256 amount = msg.value;
414     require(amount >= minInvestInWei); 
415 
416     uint256 refund = amount % tokenExchangeRateInWei;
417     uint256 tokens = (amount - refund) / tokenExchangeRateInWei;
418     require(totalSupply.add(tokens) <= maxTokenSupply);
419     totalSupply = totalSupply.add(tokens);
420     balances[_payee] = balances[_payee].add(tokens);
421 
422     if (payees[msg.sender].isExists != true) {
423       payees[msg.sender].isExists = true;
424       payees[msg.sender].isPayable = true;
425       payeeArray.push(msg.sender);
426     }
427 
428     require(owner.send(amount - refund));
429     if (refund > 0) {
430       require(msg.sender.send(refund));
431     }
432     return true;
433   }
434 
435   /**
436    * @dev transfer token
437    * @param _to The address to transfer to.
438    * @param _value The amount to be transferred.
439    */
440   function transfer(address _to, uint256 _value) onlyPayloadSize(2 * 32) notLockout notPaused isInitialized {
441     require(_to != contractAddress);
442     balances[msg.sender] = balances[msg.sender].sub(_value);
443     balances[_to] = balances[_to].add(_value);
444     if (payees[_to].isExists != true) {
445       payees[_to].isExists = true;
446       payees[_to].isPayable = true;
447       payeeArray.push(_to);
448     }
449     Transfer(msg.sender, _to, _value);
450   }
451 
452   /**
453    * @dev Transfer tokens from one address to another
454    * @param _from address The address which you want to send tokens from
455    * @param _to address The address which you want to transfer to
456    * @param _value uint the amout of tokens to be transfered
457    */
458   function transferFrom(address _from, address _to, uint _value) onlyPayloadSize(3 * 32) notLockout notPaused isInitialized {
459     require(_to != contractAddress);
460     require(_from != contractAddress);
461     var _allowance = allowed[_from][msg.sender];
462 
463     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
464     // if (_value > _allowance) throw;
465     require(_allowance >= _value);
466 
467     balances[_to] = balances[_to].add(_value);
468     balances[_from] = balances[_from].sub(_value);
469     allowed[_from][msg.sender] = _allowance.sub(_value);
470     if (payees[_to].isExists != true) {
471       payees[_to].isExists = true;
472       payees[_to].isPayable = true;
473       payeeArray.push(_to);
474     }
475     Transfer(_from, _to, _value);
476   }
477 
478   /**
479    * @dev add interest to each payees
480    */
481   function ownerDepositInterest() onlyOwner isPaused isInitialized {
482     uint256 i = nextPayeeIndex;
483     uint256 payeesLength = payeeArray.length;
484     while (i < payeesLength && msg.gas > 2000000) {
485       address _payee = payeeArray[i];
486       uint256 _balance = balances[_payee];
487       if (payees[_payee].isPayable == true && _balance > 0) {
488         uint256 _interestInWei = (_balance * interestArray[getInterestCount() - 1]) / totalSupply;
489         payees[_payee].interestInWei += _interestInWei;
490         DepositInterest(getInterestCount(), _payee, _balance, _interestInWei);
491       }
492       i++;
493     }
494     nextPayeeIndex = i;
495   }
496 
497   /**
498    * @dev return interest by address, unit `wei`
499    * @param _address The payee address
500    */
501   function interestOf(address _address) isInitialized constant returns (uint256 result)  {
502     require(payees[_address].isExists == true);
503     return payees[_address].interestInWei;
504   }
505 
506   /**
507    * @dev withdraw interest by payee
508    * @param _interestInWei Withdraw interest amount in wei
509    */
510   function payeeWithdrawInterest(uint256 _interestInWei) payable isPayee isInitialized notLockout {
511     require(msg.value == 0);
512     uint256 interestInWei = _interestInWei;
513     require(payees[msg.sender].isPayable == true && _interestInWei <= payees[msg.sender].interestInWei);
514     require(msg.sender.send(interestInWei));
515     payees[msg.sender].interestInWei -= interestInWei;
516     PayeeWithdrawInterest(msg.sender, interestInWei, payees[msg.sender].interestInWei);
517   }
518 
519   /**
520    * @dev withdraw capital by payee
521    */
522   function payeeWithdrawCapital() payable isPayee isPaused isInitialized overMaturity {
523     require(msg.value == 0);
524     require(balances[msg.sender] > 0 && totalSupply > 0);
525     uint256 capital = (balances[msg.sender] * finalizedCapital) / totalSupply;
526     balances[msg.sender] = 0;
527     require(msg.sender.send(capital));
528     PayeeWithdrawCapital(msg.sender, capital);
529   }
530 
531   /**
532    * @dev pause contract
533    */
534   function ownerPauseContract() onlyOwner {
535     paused = true;
536   }
537 
538   /**
539    * @dev resume contract
540    */
541   function ownerResumeContract() onlyOwner {
542     paused = false;
543   }
544 
545   /**
546    * @dev set exchange rate in wei, 1 Token = n ETH in wei
547    * @param _exchangeRateInWei change rate of ether
548    */
549   function ownerSetExchangeRateInWei(uint256 _exchangeRateInWei) onlyOwner {
550     require(_exchangeRateInWei > 0);
551     var _exchangeRate = ExchangeRate( getBlockNumber(), _exchangeRateInWei);
552     exchangeRateArray.push(_exchangeRate);
553     nextExchangeRateIndex = exchangeRateArray.length;
554   }
555 
556   /**
557    * @dev disable single payee in emergency
558    * @param _address Disable payee address
559    */
560   function ownerDisablePayee(address _address) onlyOwner {
561     require(_address != owner);
562     payees[_address].isPayable = false;
563   }
564 
565   /**
566    * @dev enable single payee
567    * @param _address Enable payee address
568    */
569   function ownerEnablePayee(address _address) onlyOwner {
570     payees[_address].isPayable = true;
571   }
572 
573   /**
574    * @dev get payee count
575    */
576   function getPayeeCount() constant returns (uint256) {
577     return payeeArray.length;
578   }
579 
580   /**
581    * @dev get block number
582    */
583   function getBlockNumber() internal constant returns (uint256) {
584     return block.number;
585   }
586 
587   /**
588    * @dev add asset data, audit information
589    * @param _data asset data
590    */
591   function ownerAddAsset(string _data) onlyOwner {
592     var _asset = Asset(_data);
593     assetArray.push(_asset);
594   }
595 
596   /**
597    * @dev get asset count
598    */
599   function getAssetCount() constant returns (uint256 result) {
600     return assetArray.length;
601   }
602 
603   /**
604    * @dev put all capital in this contract
605    */
606   function ownerPutCapital() payable isInitialized isPaused onlyOwner {
607     require(msg.value > 0);
608     finalizedCapital = msg.value;
609   }
610 
611   /**
612    * @dev put interest in this contract
613    * @param _terms Number of interest
614    */
615   function ownerPutInterest(uint256 _terms) payable isInitialized isPaused onlyOwner {
616     require(_terms == (getInterestCount() + 1));
617     interestArray.push(msg.value);
618   }
619 
620   /**
621    * @dev get interest count
622    */
623   function getInterestCount() constant returns (uint256 result) {
624     return interestArray.length;
625   }
626 
627   /**
628    * @dev withdraw balance from contract if emergency
629    */
630   function ownerWithdraw() payable isInitialized onlyOwner {
631     require(owner.send(this.balance));
632   }
633 
634   event PayeeWithdrawCapital(address _payee, uint256 _capital);
635   event PayeeWithdrawInterest(address _payee, uint256 _interest, uint256 _remainInterest);
636   event DepositInterest(uint256 _terms, address _payee, uint256 _balance, uint256 _interest);
637   event Finalized();
638 }