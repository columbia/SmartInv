1 pragma solidity ^0.4.24;
2 
3 
4 
5 /**
6 * It is insurance smart-contract for the SmartContractBank.
7 * You can buy insurance for 0.1 ETH and if you do not take 100% profit when balance of
8 * the SmartContractBank will be lesser then 0.01 you can receive part of insurance fund depend on your not received money.
9 *
10 * To buy insurance:
11 * Send to the contract address 0.01 ETH, and you will be accounted to.
12 *
13 * To receive insurance payout:
14 * Send to the contract address 0 ETH, and you will receive part of insurance depend on your not received money.
15 * If you already received 100% from your deposit, you will take error.
16 */
17 contract InsuranceFund {
18     using SafeMath for uint256;
19 
20     /**
21     * @dev Structure for evaluating payout
22     * @param deposit Duplicated from SmartContractBank deposit
23     * @param withdrawals Duplicated from SmartContractBank withdrawals
24     * @param insured Flag for available payout
25     */
26     struct Investor {
27         uint256 deposit;
28         uint256 withdrawals;
29         bool insured;
30     }
31     mapping (address => Investor) public investors;
32     uint public countOfInvestors;
33 
34     bool public startOfPayments = false;
35     uint256 public totalSupply;
36 
37     uint256 public totalNotReceived;
38     address public SCBAddress;
39 
40     SmartContractBank SCBContract;
41 
42     event Paid(address investor, uint256 amount, uint256  notRecieve, uint256  partOfNotReceived);
43     event SetInfo(address investor, uint256  notRecieve, uint256 deposit, uint256 withdrawals);
44 
45     /**
46     * @dev  Modifier for access from the SmartContractBank
47     */
48     modifier onlySCB() {
49         require(msg.sender == SCBAddress, "access denied");
50         _;
51     }
52 
53     /**
54     * @dev  Setter the SmartContractBank address. Address can be set only once.
55     * @param _SCBAddress Address of the SmartContractBank
56     */
57     function setSCBAddress(address _SCBAddress) public {
58         require(SCBAddress == address(0x0));
59         SCBAddress = _SCBAddress;
60         SCBContract = SmartContractBank(SCBAddress);
61     }
62 
63     /**
64     * @dev  Private setter info about investor. Can be call if payouts not started.
65     * Needing for evaluating not received total amount without loops.
66     * @param _address Investor's address
67     * @param _address Investor's deposit
68     * @param _address Investor's withdrawals
69     */
70     function privateSetInfo(address _address, uint256 deposit, uint256 withdrawals) private{
71         if (!startOfPayments) {
72             Investor storage investor = investors[_address];
73 
74             if (investor.deposit != deposit){
75                 totalNotReceived = totalNotReceived.add(deposit.sub(investor.deposit));
76                 investor.deposit = deposit;
77             }
78 
79             if (investor.withdrawals != withdrawals){
80                 uint256 different;
81                 if (deposit <= withdrawals){
82                     different = deposit.sub(withdrawals);
83                     if (totalNotReceived >= different)
84                         totalNotReceived = totalNotReceived.sub(different);
85                     else
86                         totalNotReceived = 0;
87                 } else {
88                     different = withdrawals.sub(investor.withdrawals);
89                     if (totalNotReceived >= different)
90                         totalNotReceived = totalNotReceived.sub(different);
91                     else
92                         totalNotReceived = 0;
93                 }
94                 investor.withdrawals = withdrawals;
95             }
96 
97             emit SetInfo(_address, totalNotReceived, investor.deposit, investor.withdrawals);
98         }
99     }
100 
101     /**
102     * @dev  Setter info about investor from the SmartContractBank.
103     * @param _address Investor's address
104     * @param _address Investor's deposit
105     * @param _address Investor's withdrawals
106     */
107     function setInfo(address _address, uint256 deposit, uint256 withdrawals) public onlySCB {
108         privateSetInfo(_address, deposit, withdrawals);
109     }
110 
111     /**
112     * @dev  Delete insured from the SmartContractBank.
113     * @param _address Investor's address
114     */
115     function deleteInsured(address _address) public onlySCB {
116         Investor storage investor = investors[_address];
117         investor.deposit = 0;
118         investor.withdrawals = 0;
119         investor.insured = false;
120         countOfInvestors--;
121     }
122 
123     /**
124     * @dev  Function for starting payouts and stopping receive funds.
125     */
126     function beginOfPayments() public {
127         require(address(SCBAddress).balance < 0.1 ether && !startOfPayments);
128         startOfPayments = true;
129         totalSupply = address(this).balance;
130     }
131 
132     /**
133     * @dev  Payable function for receive funds, buying insurance and receive insurance payouts .
134     */
135     function () external payable {
136         Investor storage investor = investors[msg.sender];
137         if (msg.value > 0 ether){
138             require(!startOfPayments);
139             if (msg.sender != SCBAddress && msg.value >= 0.1 ether) {
140                 uint256 deposit;
141                 uint256 withdrawals;
142                 (deposit, withdrawals, investor.insured) = SCBContract.setInsured(msg.sender);
143                 countOfInvestors++;
144                 privateSetInfo(msg.sender, deposit, withdrawals);
145             }
146         } else if (msg.value == 0){
147             uint256 notReceived = investor.deposit.sub(investor.withdrawals);
148             uint256 partOfNotReceived = notReceived.mul(100).div(totalNotReceived);
149             uint256 payAmount = totalSupply.div(100).mul(partOfNotReceived);
150             require(startOfPayments && investor.insured && notReceived > 0);
151             investor.insured = false;
152             msg.sender.transfer(payAmount);
153             emit Paid(msg.sender, payAmount, notReceived, partOfNotReceived);
154         }
155     }
156 }
157 
158 /**
159 * It is "Smart Contract Bank" smart-contract.
160 * - You can take profit 4% per day.
161 * - You can buy insurance and receive part of insurance fund when balance will be lesser then 0.01 ETH.
162 * - You can increase your percent on 0.5% if you have 10 CBC Token (0x790bFaCaE71576107C068f494c8A6302aea640cb ico.cryptoboss.me)
163 *    1. To buy CBC Tokens send 0.01 ETH on Sale Token Address 0x369fc7de8aee87a167244eb10b87eb3005780872
164 *    2. To increase your profit percent if you already have tokens, you should send to SmartContractBank address 0.0001 ETH
165 * - If your percent balance will be beyond of 200% you will able to take your profit only once time.
166 * HODL your profit and take more then 200% percents.
167 * - If balance of contract will be lesser then 0.1 ETH every user able stop contract and start insurance payments.
168 *
169 * - Percent of profit depends on balance of contract. Percent chart below:
170 * - If balance < 100 ETH - 4% per day
171 * - If balance >= 100 ETH and < 600 - 2% per day
172 * - If balance >= 600 ETH and < 1000 - 1% per day
173 * - If balance >= 1000 ETH and < 3000 - 0.9% per day
174 * - If balance >= 3000 ETH and < 5000 - 0.8% per day
175 * - If balance >= 5000  - 0.7% per day
176 * - If balance of contract will be beyond threshold, your payout will be reevaluate depends on currently balance of contract
177 * -
178 * - You can calm your profit every 5 minutes
179 *
180 * To invest:
181 * - Send minimum 0.01 ETH to contract address
182 *
183 * To calm profit:
184 * - Send 0 ETH to contract address
185 */
186 contract SmartContractBank {
187     using SafeMath for uint256;
188     struct Investor {
189         uint256 deposit;
190         uint256 paymentTime;
191         uint256 withdrawals;
192         bool increasedPercent;
193         bool insured;
194     }
195     uint public countOfInvestors;
196     mapping (address => Investor) public investors;
197 
198     uint256 public minimum = 0.01 ether;
199     uint step = 5 minutes;
200     uint ownerPercent = 4;
201     uint promotionPercent = 8;
202     uint insurancePercent = 2;
203     bool public closed = false;
204     
205     address public ownerAddressOne = 0xaB5007407d8A686B9198079816ebBaaa2912ecC1;
206     address public ownerAddressTwo = 0x4A5b00cDDAeE928B8De7a7939545f372d6727C06;
207     address public promotionAddress = 0x3878E2231f7CA61c0c1D0Aa3e6962d7D23Df1B3b;
208     address public insuranceFundAddress;
209     address CBCTokenAddress = 0x790bFaCaE71576107C068f494c8A6302aea640cb;
210     address MainSaleAddress = 0x369fc7de8aee87a167244eb10b87eb3005780872;
211 
212     InsuranceFund IFContract;
213 
214     event Invest(address investor, uint256 amount);
215     event Withdraw(address investor, uint256 amount);
216     event UserDelete(address investor);
217 
218     /**
219     * @dev Modifier for access from the InsuranceFund
220     */
221     modifier onlyIF() {
222         require(insuranceFundAddress == msg.sender, "access denied");
223         _;
224     }
225 
226     /**
227     * @dev  Setter the InsuranceFund address. Address can be set only once.
228     * @param _insuranceFundAddress Address of the InsuranceFund
229     */
230     function setInsuranceFundAddress(address _insuranceFundAddress) public{
231         require(insuranceFundAddress == address(0x0));
232         insuranceFundAddress = _insuranceFundAddress;
233         IFContract = InsuranceFund(insuranceFundAddress);
234     }
235 
236     /**
237     * @dev  Set insured from the InsuranceFund.
238     * @param _address Investor's address
239     * @return Object of investor's information
240     */
241     function setInsured(address _address) public onlyIF returns(uint256, uint256, bool){
242         Investor storage investor = investors[_address];
243         investor.insured = true;
244         return (investor.deposit, investor.withdrawals, investor.insured);
245     }
246 
247     /**
248     * @dev  Function for close entrance.
249     */
250     function closeEntrance() public {
251         require(address(this).balance < 0.1 ether && !closed);
252         closed = true;
253     }
254 
255     /**
256     * @dev Get percent depends on balance of contract
257     * @return Percent
258     */
259     function getPhasePercent() view public returns (uint){
260         Investor storage investor = investors[msg.sender];
261         uint contractBalance = address(this).balance;
262         uint percent;
263         if (contractBalance < 100 ether) {
264             percent = 40;
265         }
266         if (contractBalance >= 100 ether && contractBalance < 600 ether) {
267             percent = 20;
268         }
269         if (contractBalance >= 600 ether && contractBalance < 1000 ether) {
270             percent = 10;
271         }
272         if (contractBalance >= 1000 ether && contractBalance < 3000 ether) {
273             percent = 9;
274         }
275         if (contractBalance >= 3000 ether && contractBalance < 5000 ether) {
276             percent = 8;
277         }
278         if (contractBalance >= 5000 ether) {
279             percent = 7;
280         }
281 
282         if (investor.increasedPercent){
283             percent = percent.add(5);
284         }
285 
286         return percent;
287     }
288 
289     /**
290     * @dev Allocation budgets
291     */
292     function allocation() private{
293         ownerAddressOne.transfer(msg.value.mul(ownerPercent.div(2)).div(100));
294         ownerAddressTwo.transfer(msg.value.mul(ownerPercent.div(2)).div(100));
295         promotionAddress.transfer(msg.value.mul(promotionPercent).div(100));
296         insuranceFundAddress.transfer(msg.value.mul(insurancePercent).div(100));
297     }
298 
299     /**
300     * @dev Evaluate current balance
301     * @param _address Address of investor
302     * @return Payout amount
303     */
304     function getUserBalance(address _address) view public returns (uint256) {
305         Investor storage investor = investors[_address];
306         uint percent = getPhasePercent();
307         uint256 differentTime = now.sub(investor.paymentTime).div(step);
308         uint256 differentPercent = investor.deposit.mul(percent).div(1000);
309         uint256 payout = differentPercent.mul(differentTime).div(288);
310 
311         return payout;
312     }
313 
314     /**
315     * @dev Withdraw profit from contract. Investor will be deleted if he will try withdraw after received x2
316     */
317     function withdraw() private {
318         Investor storage investor = investors[msg.sender];
319         uint256 balance = getUserBalance(msg.sender);
320         if (investor.deposit > 0 && address(this).balance > balance && balance > 0) {
321             uint256 tempWithdrawals = investor.withdrawals;
322 
323             investor.withdrawals = investor.withdrawals.add(balance);
324             investor.paymentTime = now;
325 
326             if (investor.withdrawals >= investor.deposit.mul(2)){
327                 investor.deposit = 0;
328                 investor.paymentTime = 0;
329                 investor.withdrawals = 0;
330                 investor.increasedPercent = false;
331                 investor.insured = false;
332                 countOfInvestors--;
333                 if (investor.insured)
334                     IFContract.deleteInsured(msg.sender);
335                 emit UserDelete(msg.sender);
336             } else {
337                 if (investor.insured && tempWithdrawals < investor.deposit){
338                     IFContract.setInfo(msg.sender, investor.deposit, investor.withdrawals);
339                 }
340             }
341             msg.sender.transfer(balance);
342             emit Withdraw(msg.sender, balance);
343         }
344 
345     }
346 
347     /**
348     * @dev Increase percent with CBC Token
349     */
350     function increasePercent() private {
351         CBCToken CBCTokenContract = CBCToken(CBCTokenAddress);
352         MainSale MainSaleContract = MainSale(MainSaleAddress);
353         Investor storage investor = investors[msg.sender];
354         if (CBCTokenContract.balanceOf(msg.sender) >= 10){
355             MainSaleContract.authorizedBurnTokens(msg.sender, 10);
356             investor.increasedPercent = true;
357         }
358     }
359 
360     /**
361     * @dev  Payable function for
362     * - receive funds (send minimum 0.01 ETH),
363     * - increase percent and receive profit (send 0.0001 ETH if you already have CBC Tokens on your address).
364     * - calm your profit (send 0 ETH)
365     */
366     function () external payable {
367         require(!closed);
368         Investor storage investor = investors[msg.sender];
369         if (msg.value > 0){
370             require(msg.value >= minimum);
371 
372             withdraw();
373 
374             if (investor.deposit == 0){
375                 countOfInvestors++;
376             }
377 
378             investor.deposit = investor.deposit.add(msg.value);
379             investor.paymentTime = now;
380 
381             if (investor.insured){
382                 IFContract.setInfo(msg.sender, investor.deposit, investor.withdrawals);
383             }
384             allocation();
385             emit Invest(msg.sender, msg.value);
386         } if (msg.value == 0.0001 ether) {
387             increasePercent();
388         } else {
389             withdraw();
390         }
391     }
392 }
393 
394 /**
395  * @title Ownable
396  * @dev The Ownable contract has an owner address, and provides basic authorization control
397  * functions, this simplifies the implementation of "user permissions".
398  */
399 contract Ownable {
400     address public owner;
401 
402 
403     /**
404      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
405      * account.
406      */
407     function Ownable() public {
408         owner = msg.sender;
409     }
410 
411 
412     /**
413      * @dev Throws if called by any account other than the owner.
414      */
415     modifier onlyOwner() {
416         require (msg.sender == owner);
417         _;
418     }
419 
420 
421     /**
422      * @dev Allows the current owner to transfer control of the contract to a newOwner.
423      * @param newOwner The address to transfer ownership to.
424      */
425     function transferOwnership(address newOwner) onlyOwner {
426         require(newOwner != address(0));
427         owner = newOwner;
428     }
429 }
430 
431 
432 
433 /**
434  * @title Authorizable
435  * @dev Allows to authorize access to certain function calls
436  *
437  * ABI
438  * [{"constant":true,"inputs":[{"name":"authorizerIndex","type":"uint256"}],"name":"getAuthorizer","outputs":[{"name":"","type":"address"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_addr","type":"address"}],"name":"addAuthorized","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[{"name":"_addr","type":"address"}],"name":"isAuthorized","outputs":[{"name":"","type":"bool"}],"payable":false,"type":"function"},{"inputs":[],"payable":false,"type":"constructor"}]
439  */
440 contract Authorizable {
441 
442     address[] authorizers;
443     mapping(address => uint) authorizerIndex;
444 
445     /**
446      * @dev Throws if called by any account tat is not authorized.
447      */
448     modifier onlyAuthorized {
449         require(isAuthorized(msg.sender));
450         _;
451     }
452 
453     /**
454      * @dev Contructor that authorizes the msg.sender.
455      */
456     function Authorizable() public {
457         authorizers.length = 2;
458         authorizers[1] = msg.sender;
459         authorizerIndex[msg.sender] = 1;
460     }
461 
462     /**
463      * @dev Function to get a specific authorizer
464      * @param authorizerIndex index of the authorizer to be retrieved.
465      * @return The address of the authorizer.
466      */
467     function getAuthorizer(uint authorizerIndex) external constant returns(address) {
468         return address(authorizers[authorizerIndex + 1]);
469     }
470 
471     /**
472      * @dev Function to check if an address is authorized
473      * @param _addr the address to check if it is authorized.
474      * @return boolean flag if address is authorized.
475      */
476     function isAuthorized(address _addr) public constant returns(bool) {
477         return authorizerIndex[_addr] > 0;
478     }
479 
480     /**
481      * @dev Function to add a new authorizer
482      * @param _addr the address to add as a new authorizer.
483      */
484     function addAuthorized(address _addr) external onlyAuthorized {
485         authorizerIndex[_addr] = authorizers.length;
486         authorizers.length++;
487         authorizers[authorizers.length - 1] = _addr;
488     }
489 
490 }
491 
492 /**
493  * @title ExchangeRate
494  * @dev Allows updating and retrieveing of Conversion Rates for PAY tokens
495  *
496  * ABI
497  * [{"constant":false,"inputs":[{"name":"_symbol","type":"string"},{"name":"_rate","type":"uint256"}],"name":"updateRate","outputs":[],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"data","type":"uint256[]"}],"name":"updateRates","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[{"name":"_symbol","type":"string"}],"name":"getRate","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"owner","outputs":[{"name":"","type":"address"}],"payable":false,"type":"function"},{"constant":true,"inputs":[{"name":"","type":"bytes32"}],"name":"rates","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"newOwner","type":"address"}],"name":"transferOwnership","outputs":[],"payable":false,"type":"function"},{"anonymous":false,"inputs":[{"indexed":false,"name":"timestamp","type":"uint256"},{"indexed":false,"name":"symbol","type":"bytes32"},{"indexed":false,"name":"rate","type":"uint256"}],"name":"RateUpdated","type":"event"}]
498  */
499 contract ExchangeRate is Ownable {
500 
501     event RateUpdated(uint timestamp, bytes32 symbol, uint rate);
502 
503     mapping(bytes32 => uint) public rates;
504 
505     /**
506      * @dev Allows the current owner to update a single rate.
507      * @param _symbol The symbol to be updated.
508      * @param _rate the rate for the symbol.
509      */
510     function updateRate(string _symbol, uint _rate) public onlyOwner {
511         rates[keccak256(_symbol)] = _rate;
512         RateUpdated(now, keccak256(_symbol), _rate);
513     }
514 
515     /**
516      * @dev Allows the current owner to update multiple rates.
517      * @param data an array that alternates keccak256 hashes of the symbol and the corresponding rate .
518      */
519     function updateRates(uint[] data) public onlyOwner {
520         require (data.length % 2 <= 0);
521         uint i = 0;
522         while (i < data.length / 2) {
523             bytes32 symbol = bytes32(data[i * 2]);
524             uint rate = data[i * 2 + 1];
525             rates[symbol] = rate;
526             RateUpdated(now, symbol, rate);
527             i++;
528         }
529     }
530 
531     /**
532      * @dev Allows the anyone to read the current rate.
533      * @param _symbol the symbol to be retrieved.
534      */
535     function getRate(string _symbol) public constant returns(uint) {
536         return rates[keccak256(_symbol)];
537     }
538 
539 }
540 
541 /**
542  * Math operations with safety checks
543  */
544 library SafeMath {
545     function mul(uint a, uint b) internal returns (uint) {
546         uint c = a * b;
547         assert(a == 0 || c / a == b);
548         return c;
549     }
550 
551     function div(uint a, uint b) internal returns (uint) {
552         // assert(b > 0); // Solidity automatically throws when dividing by 0
553         uint c = a / b;
554         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
555         return c;
556     }
557 
558     function sub(uint a, uint b) internal returns (uint) {
559         assert(b <= a);
560         return a - b;
561     }
562 
563     function add(uint a, uint b) internal returns (uint) {
564         uint c = a + b;
565         assert(c >= a);
566         return c;
567     }
568 
569     function max64(uint64 a, uint64 b) internal constant returns (uint64) {
570         return a >= b ? a : b;
571     }
572 
573     function min64(uint64 a, uint64 b) internal constant returns (uint64) {
574         return a < b ? a : b;
575     }
576 
577     function max256(uint256 a, uint256 b) internal constant returns (uint256) {
578         return a >= b ? a : b;
579     }
580 
581     function min256(uint256 a, uint256 b) internal constant returns (uint256) {
582         return a < b ? a : b;
583     }
584 
585     function assert(bool assertion) internal {
586         require(assertion);
587     }
588 }
589 
590 
591 /**
592  * @title ERC20Basic
593  * @dev Simpler version of ERC20 interface
594  * @dev see https://github.com/ethereum/EIPs/issues/20
595  */
596 contract ERC20Basic {
597     uint public totalSupply;
598     function balanceOf(address who) public constant returns (uint);
599     function transfer(address to, uint value) public;
600     event Transfer(address indexed from, address indexed to, uint value);
601 }
602 
603 
604 
605 
606 /**
607  * @title ERC20 interface
608  * @dev see https://github.com/ethereum/EIPs/issues/20
609  */
610 contract ERC20 is ERC20Basic {
611     function allowance(address owner, address spender) constant returns (uint);
612     function transferFrom(address from, address to, uint value);
613     function approve(address spender, uint value);
614     event Approval(address indexed owner, address indexed spender, uint value);
615 }
616 
617 
618 
619 
620 /**
621  * @title Basic token
622  * @dev Basic version of StandardToken, with no allowances.
623  */
624 contract BasicToken is ERC20Basic {
625     using SafeMath for uint;
626 
627     mapping(address => uint) balances;
628 
629     /**
630      * @dev Fix for the ERC20 short address attack.
631      */
632     modifier onlyPayloadSize(uint size) {
633         require (size + 4 <= msg.data.length);
634         _;
635     }
636 
637     /**
638     * @dev transfer token for a specified address
639     * @param _to The address to transfer to.
640     * @param _value The amount to be transferred.
641     */
642     function transfer(address _to, uint _value) onlyPayloadSize(2 * 32) {
643         balances[msg.sender] = balances[msg.sender].sub(_value);
644         balances[_to] = balances[_to].add(_value);
645         Transfer(msg.sender, _to, _value);
646     }
647 
648     /**
649     * @dev Gets the balance of the specified address.
650     * @param _owner The address to query the the balance of.
651     * @return An uint representing the amount owned by the passed address.
652     */
653     function balanceOf(address _owner) constant returns (uint balance) {
654         return balances[_owner];
655     }
656 
657 }
658 
659 
660 
661 
662 /**
663  * @title Standard ERC20 token
664  *
665  * @dev Implemantation of the basic standart token.
666  * @dev https://github.com/ethereum/EIPs/issues/20
667  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
668  */
669 contract StandardToken is BasicToken, ERC20 {
670 
671     mapping (address => mapping (address => uint)) allowed;
672 
673 
674     /**
675      * @dev Transfer tokens from one address to another
676      * @param _from address The address which you want to send tokens from
677      * @param _to address The address which you want to transfer to
678      * @param _value uint the amout of tokens to be transfered
679      */
680     function transferFrom(address _from, address _to, uint _value) onlyPayloadSize(3 * 32) {
681         var _allowance = allowed[_from][msg.sender];
682 
683         // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
684         // if (_value > _allowance) throw;
685 
686         balances[_to] = balances[_to].add(_value);
687         balances[_from] = balances[_from].sub(_value);
688         allowed[_from][msg.sender] = _allowance.sub(_value);
689         Transfer(_from, _to, _value);
690     }
691 
692     /**
693      * @dev Aprove the passed address to spend the specified amount of tokens on beahlf of msg.sender.
694      * @param _spender The address which will spend the funds.
695      * @param _value The amount of tokens to be spent.
696      */
697     function approve(address _spender, uint _value) {
698 
699         // To change the approve amount you first have to reduce the addresses`
700         //  allowance to zero by calling `approve(_spender, 0)` if it is not
701         //  already 0 to mitigate the race condition described here:
702         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
703         if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;
704 
705         allowed[msg.sender][_spender] = _value;
706         Approval(msg.sender, _spender, _value);
707     }
708 
709     /**
710      * @dev Function to check the amount of tokens than an owner allowed to a spender.
711      * @param _owner address The address which owns the funds.
712      * @param _spender address The address which will spend the funds.
713      * @return A uint specifing the amount of tokens still avaible for the spender.
714      */
715     function allowance(address _owner, address _spender) constant returns (uint remaining) {
716         return allowed[_owner][_spender];
717     }
718 
719 }
720 
721 
722 /**
723  * @title Mintable token
724  * @dev Simple ERC20 Token example, with mintable token creation
725  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
726  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
727  */
728 
729 contract MintableToken is StandardToken, Ownable {
730     event Mint(address indexed to, uint value);
731     event MintFinished();
732     event Burn(address indexed burner, uint256 value);
733 
734     bool public mintingFinished = false;
735     uint public totalSupply = 0;
736 
737 
738     modifier canMint() {
739         require(!mintingFinished);
740         _;
741     }
742 
743     /**
744      * @dev Function to mint tokens
745      * @param _to The address that will recieve the minted tokens.
746      * @param _amount The amount of tokens to mint.
747      * @return A boolean that indicates if the operation was successful.
748      */
749     function mint(address _to, uint _amount) onlyOwner canMint returns (bool) {
750         totalSupply = totalSupply.add(_amount);
751         balances[_to] = balances[_to].add(_amount);
752         Mint(_to, _amount);
753         return true;
754     }
755 
756     /**
757      * @dev Function to stop minting new tokens.
758      * @return True if the operation was successful.
759      */
760     function finishMinting() onlyOwner returns (bool) {
761         mintingFinished = true;
762         MintFinished();
763         return true;
764     }
765 
766 
767     /**
768      * @dev Burns a specific amount of tokens.
769      * @param _value The amount of token to be burned.
770      */
771     function burn(address _who, uint256 _value) onlyOwner public {
772         _burn(_who, _value);
773     }
774 
775     function _burn(address _who, uint256 _value) internal {
776         require(_value <= balances[_who]);
777         // no need to require value <= totalSupply, since that would imply the
778         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
779 
780         balances[_who] = balances[_who].sub(_value);
781         totalSupply = totalSupply.sub(_value);
782         Burn(_who, _value);
783         Transfer(_who, address(0), _value);
784     }
785 }
786 
787 
788 /**
789  * @title CBCToken
790  * @dev The main CBC token contract
791  *
792  * ABI
793  * [{"constant":true,"inputs":[],"name":"mintingFinished","outputs":[{"name":"","type":"bool"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"name","outputs":[{"name":"","type":"string"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_spender","type":"address"},{"name":"_value","type":"uint256"}],"name":"approve","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"totalSupply","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_from","type":"address"},{"name":"_to","type":"address"},{"name":"_value","type":"uint256"}],"name":"transferFrom","outputs":[],"payable":false,"type":"function"},{"constant":false,"inputs":[],"name":"startTrading","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"decimals","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_to","type":"address"},{"name":"_amount","type":"uint256"}],"name":"mint","outputs":[{"name":"","type":"bool"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"tradingStarted","outputs":[{"name":"","type":"bool"}],"payable":false,"type":"function"},{"constant":true,"inputs":[{"name":"_owner","type":"address"}],"name":"balanceOf","outputs":[{"name":"balance","type":"uint256"}],"payable":false,"type":"function"},{"constant":false,"inputs":[],"name":"finishMinting","outputs":[{"name":"","type":"bool"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"owner","outputs":[{"name":"","type":"address"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"symbol","outputs":[{"name":"","type":"string"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_to","type":"address"},{"name":"_value","type":"uint256"}],"name":"transfer","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[{"name":"_owner","type":"address"},{"name":"_spender","type":"address"}],"name":"allowance","outputs":[{"name":"remaining","type":"uint256"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"newOwner","type":"address"}],"name":"transferOwnership","outputs":[],"payable":false,"type":"function"},{"anonymous":false,"inputs":[{"indexed":true,"name":"to","type":"address"},{"indexed":false,"name":"value","type":"uint256"}],"name":"Mint","type":"event"},{"anonymous":false,"inputs":[],"name":"MintFinished","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"name":"owner","type":"address"},{"indexed":true,"name":"spender","type":"address"},{"indexed":false,"name":"value","type":"uint256"}],"name":"Approval","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"name":"from","type":"address"},{"indexed":true,"name":"to","type":"address"},{"indexed":false,"name":"value","type":"uint256"}],"name":"Transfer","type":"event"}]
794  */
795 contract CBCToken is MintableToken {
796 
797     string public name = "Crypto Boss Coin";
798     string public symbol = "CBC";
799     uint public decimals = 18;
800 
801     bool public tradingStarted = false;
802     /**
803      * @dev modifier that throws if trading has not started yet
804      */
805     modifier hasStartedTrading() {
806         require(tradingStarted);
807         _;
808     }
809 
810 
811     /**
812      * @dev Allows the owner to enable the trading. This can not be undone
813      */
814     function startTrading() onlyOwner {
815         tradingStarted = true;
816     }
817 
818     /**
819      * @dev Allows anyone to transfer the PAY tokens once trading has started
820      * @param _to the recipient address of the tokens.
821      * @param _value number of tokens to be transfered.
822      */
823     function transfer(address _to, uint _value) hasStartedTrading {
824         super.transfer(_to, _value);
825     }
826 
827     /**
828     * @dev Allows anyone to transfer the CBC tokens once trading has started
829     * @param _from address The address which you want to send tokens from
830     * @param _to address The address which you want to transfer to
831     * @param _value uint the amout of tokens to be transfered
832     */
833     function transferFrom(address _from, address _to, uint _value) hasStartedTrading {
834         super.transferFrom(_from, _to, _value);
835     }
836 
837 }
838 
839 /**
840  * @title MainSale
841  * @dev The main CBC token sale contract
842  *
843  * ABI
844  * [{"constant":false,"inputs":[{"name":"_multisigVault","type":"address"}],"name":"setMultisigVault","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[{"name":"authorizerIndex","type":"uint256"}],"name":"getAuthorizer","outputs":[{"name":"","type":"address"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"exchangeRate","outputs":[{"name":"","type":"address"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"altDeposits","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"recipient","type":"address"},{"name":"tokens","type":"uint256"}],"name":"authorizedCreateTokens","outputs":[],"payable":false,"type":"function"},{"constant":false,"inputs":[],"name":"finishMinting","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"owner","outputs":[{"name":"","type":"address"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_exchangeRate","type":"address"}],"name":"setExchangeRate","outputs":[],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_token","type":"address"}],"name":"retrieveTokens","outputs":[],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"totalAltDeposits","type":"uint256"}],"name":"setAltDeposit","outputs":[],"payable":false,"type":"function"},{"constant":!1,"inputs":[{"name":"victim","type":"address"},{"name":"amount","type":"uint256"}],"name":"burnTokens","outputs":[],"payable":!1,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[],"name":"start","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"recipient","type":"address"}],"name":"createTokens","outputs":[],"payable":true,"type":"function"},{"constant":false,"inputs":[{"name":"_addr","type":"address"}],"name":"addAuthorized","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"multisigVault","outputs":[{"name":"","type":"address"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_hardcap","type":"uint256"}],"name":"setHardCap","outputs":[],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"newOwner","type":"address"}],"name":"transferOwnership","outputs":[],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_start","type":"uint256"}],"name":"setStart","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"token","outputs":[{"name":"","type":"address"}],"payable":false,"type":"function"},{"constant":true,"inputs":[{"name":"_addr","type":"address"}],"name":"isAuthorized","outputs":[{"name":"","type":"bool"}],"payable":false,"type":"function"},{"payable":true,"type":"fallback"},{"anonymous":false,"inputs":[{"indexed":false,"name":"recipient","type":"address"},{"indexed":false,"name":"ether_amount","type":"uint256"},{"indexed":false,"name":"pay_amount","type":"uint256"},{"indexed":false,"name":"exchangerate","type":"uint256"}],"name":"TokenSold","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"name":"recipient","type":"address"},{"indexed":false,"name":"pay_amount","type":"uint256"}],"name":"AuthorizedCreate","type":"event"},{"anonymous":false,"inputs":[],"name":"MainSaleClosed","type":"event"}]
845  */
846 contract MainSale is Ownable, Authorizable {
847     using SafeMath for uint;
848     event TokenSold(address recipient, uint ether_amount, uint pay_amount, uint exchangerate);
849     event AuthorizedCreate(address recipient, uint pay_amount);
850     event AuthorizedBurn(address receiver, uint value);
851     event AuthorizedStartTrading();
852     event MainSaleClosed();
853     CBCToken public token = new CBCToken();
854 
855     address public multisigVault;
856 
857     uint hardcap = 100000000000000 ether;
858     ExchangeRate public exchangeRate;
859 
860     uint public altDeposits = 0;
861     uint public start = 1525996800;
862 
863     /**
864      * @dev modifier to allow token creation only when the sale IS ON
865      */
866     modifier saleIsOn() {
867         require(now > start && now < start + 28 days);
868         _;
869     }
870 
871     /**
872      * @dev modifier to allow token creation only when the hardcap has not been reached
873      */
874     modifier isUnderHardCap() {
875         require(multisigVault.balance + altDeposits <= hardcap);
876         _;
877     }
878 
879     /**
880      * @dev Allows anyone to create tokens by depositing ether.
881      * @param recipient the recipient to receive tokens.
882      */
883     function createTokens(address recipient) public isUnderHardCap saleIsOn payable {
884         uint rate = exchangeRate.getRate("ETH");
885         uint tokens = rate.mul(msg.value).div(1 ether);
886         token.mint(recipient, tokens);
887         require(multisigVault.send(msg.value));
888         TokenSold(recipient, msg.value, tokens, rate);
889     }
890 
891     /**
892      * @dev Allows to set the toal alt deposit measured in ETH to make sure the hardcap includes other deposits
893      * @param totalAltDeposits total amount ETH equivalent
894      */
895     function setAltDeposit(uint totalAltDeposits) public onlyOwner {
896         altDeposits = totalAltDeposits;
897     }
898 
899     /**
900      * @dev Allows authorized acces to create tokens. This is used for Bitcoin and ERC20 deposits
901      * @param recipient the recipient to receive tokens.
902      * @param tokens number of tokens to be created.
903      */
904     function authorizedCreateTokens(address recipient, uint tokens) public onlyAuthorized {
905         token.mint(recipient, tokens);
906         AuthorizedCreate(recipient, tokens);
907     }
908 
909     function authorizedStartTrading() public onlyAuthorized {
910         token.startTrading();
911         AuthorizedStartTrading();
912     }
913 
914     /**
915      * @dev Allows authorized acces to burn tokens.
916      * @param receiver the receiver to receive tokens.
917      * @param value number of tokens to be created.
918      */
919     function authorizedBurnTokens(address receiver, uint value) public onlyAuthorized {
920         token.burn(receiver, value);
921         AuthorizedBurn(receiver, value);
922     }
923 
924     /**
925      * @dev Allows the owner to set the hardcap.
926      * @param _hardcap the new hardcap
927      */
928     function setHardCap(uint _hardcap) public onlyOwner {
929         hardcap = _hardcap;
930     }
931 
932     /**
933      * @dev Allows the owner to set the starting time.
934      * @param _start the new _start
935      */
936     function setStart(uint _start) public onlyOwner {
937         start = _start;
938     }
939 
940     /**
941      * @dev Allows the owner to set the multisig contract.
942      * @param _multisigVault the multisig contract address
943      */
944     function setMultisigVault(address _multisigVault) public onlyOwner {
945         if (_multisigVault != address(0)) {
946             multisigVault = _multisigVault;
947         }
948     }
949 
950     /**
951      * @dev Allows the owner to set the exchangerate contract.
952      * @param _exchangeRate the exchangerate address
953      */
954     function setExchangeRate(address _exchangeRate) public onlyOwner {
955         exchangeRate = ExchangeRate(_exchangeRate);
956     }
957 
958     /**
959      * @dev Allows the owner to finish the minting. This will create the
960      * restricted tokens and then close the minting.
961      * Then the ownership of the PAY token contract is transfered
962      * to this owner.
963      */
964     function finishMinting() public onlyOwner {
965         uint issuedTokenSupply = token.totalSupply();
966         uint restrictedTokens = issuedTokenSupply.mul(49).div(51);
967         token.mint(multisigVault, restrictedTokens);
968         token.finishMinting();
969         token.transferOwnership(owner);
970         MainSaleClosed();
971     }
972 
973     /**
974      * @dev Allows the owner to transfer ERC20 tokens to the multi sig vault
975      * @param _token the contract address of the ERC20 contract
976      */
977     function retrieveTokens(address _token) public onlyOwner {
978         ERC20 token = ERC20(_token);
979         token.transfer(multisigVault, token.balanceOf(this));
980     }
981 
982     /**
983      * @dev Fallback function which receives ether and created the appropriate number of tokens for the
984      * msg.sender.
985      */
986     function() external payable {
987         createTokens(msg.sender);
988     }
989 
990 }