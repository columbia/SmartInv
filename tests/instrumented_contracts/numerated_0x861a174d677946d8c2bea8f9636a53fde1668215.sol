1 pragma solidity ^0.4.24;
2 
3 /**
4 * It is insurance smart-contract for the SmartContractBank.
5 * You can buy insurance for 0.1 ETH and if you do not take 100% profit when balance of
6 * the SmartContractBank will be lesser then 0.01 you can receive part of insurance fund depend on your not received money.
7 *
8 * To buy insurance:
9 * Send to the contract address 0.01 ETH, and you will be accounted to.
10 *
11 * To receive insurance payout:
12 * Send to the contract address 0 ETH, and you will receive part of insurance depend on your not received money.
13 * If you already received 100% from your deposit, you will take error.
14 */
15 contract InsuranceFund {
16     using SafeMath for uint256;
17 
18     /**
19     * @dev Structure for evaluating payout
20     * @param deposit Duplicated from SmartContractBank deposit
21     * @param withdrawals Duplicated from SmartContractBank withdrawals
22     * @param insured Flag for available payout
23     */
24     struct Investor {
25         uint256 deposit;
26         uint256 withdrawals;
27         bool insured;
28     }
29     mapping (address => Investor) public investors;
30     uint public countOfInvestors;
31 
32     bool public startOfPayments = false;
33     uint256 public totalSupply;
34 
35     uint256 public totalNotReceived;
36     address public SCBAddress;
37 
38     SmartContractBank SCBContract;
39 
40     event Paid(address investor, uint256 amount, uint256  notRecieve, uint256  partOfNotReceived);
41     event SetInfo(address investor, uint256  notRecieve, uint256 deposit, uint256 withdrawals);
42 
43     /**
44     * @dev  Modifier for access from the SmartContractBank
45     */
46     modifier onlySCB() {
47         require(msg.sender == SCBAddress, "access denied");
48         _;
49     }
50 
51     /**
52     * @dev  Setter the SmartContractBank address. Address can be set only once.
53     * @param _SCBAddress Address of the SmartContractBank
54     */
55     function setSCBAddress(address _SCBAddress) public {
56         require(SCBAddress == address(0x0));
57         SCBAddress = _SCBAddress;
58         SCBContract = SmartContractBank(SCBAddress);
59     }
60 
61     /**
62     * @dev  Private setter info about investor. Can be call if payouts not started.
63     * Needing for evaluating not received total amount without loops.
64     * @param _address Investor's address
65     * @param _address Investor's deposit
66     * @param _address Investor's withdrawals
67     */
68     function privateSetInfo(address _address, uint256 deposit, uint256 withdrawals) private{
69         if (!startOfPayments) {
70             Investor storage investor = investors[_address];
71 
72             if (investor.deposit != deposit){
73                 totalNotReceived = totalNotReceived.add(deposit.sub(investor.deposit));
74                 investor.deposit = deposit;
75             }
76 
77             if (investor.withdrawals != withdrawals){
78                 uint256 different;
79                 if (deposit <= withdrawals){
80                     different = deposit.sub(withdrawals);
81                     if (totalNotReceived >= different)
82                         totalNotReceived = totalNotReceived.sub(different);
83                     else
84                         totalNotReceived = 0;
85                 } else {
86                     different = withdrawals.sub(investor.withdrawals);
87                     if (totalNotReceived >= different)
88                         totalNotReceived = totalNotReceived.sub(different);
89                     else
90                         totalNotReceived = 0;
91                 }
92                 investor.withdrawals = withdrawals;
93             }
94 
95             emit SetInfo(_address, totalNotReceived, investor.deposit, investor.withdrawals);
96         }
97     }
98 
99     /**
100     * @dev  Setter info about investor from the SmartContractBank.
101     * @param _address Investor's address
102     * @param _address Investor's deposit
103     * @param _address Investor's withdrawals
104     */
105     function setInfo(address _address, uint256 deposit, uint256 withdrawals) public onlySCB {
106         privateSetInfo(_address, deposit, withdrawals);
107     }
108 
109     /**
110     * @dev  Delete insured from the SmartContractBank.
111     * @param _address Investor's address
112     */
113     function deleteInsured(address _address) public onlySCB {
114         Investor storage investor = investors[_address];
115         investor.deposit = 0;
116         investor.withdrawals = 0;
117         investor.insured = false;
118         countOfInvestors--;
119     }
120 
121     /**
122     * @dev  Function for starting payouts and stopping receive funds.
123     */
124     function beginOfPayments() public {
125         require(address(SCBAddress).balance < 0.1 ether && !startOfPayments);
126         startOfPayments = true;
127         totalSupply = address(this).balance;
128     }
129 
130     /**
131     * @dev  Payable function for receive funds, buying insurance and receive insurance payouts .
132     */
133     function () external payable {
134         Investor storage investor = investors[msg.sender];
135         if (msg.value > 0 ether){
136             require(!startOfPayments);
137             if (msg.sender != SCBAddress && msg.value >= 0.1 ether) {
138                 uint256 deposit;
139                 uint256 withdrawals;
140                 (deposit, withdrawals, investor.insured) = SCBContract.setInsured(msg.sender);
141                 countOfInvestors++;
142                 privateSetInfo(msg.sender, deposit, withdrawals);
143             }
144         } else if (msg.value == 0){
145             uint256 notReceived = investor.deposit.sub(investor.withdrawals);
146             uint256 partOfNotReceived = notReceived.mul(100).div(totalNotReceived);
147             uint256 payAmount = totalSupply.div(100).mul(partOfNotReceived);
148             require(startOfPayments && investor.insured && notReceived > 0);
149             investor.insured = false;
150             msg.sender.transfer(payAmount);
151             emit Paid(msg.sender, payAmount, notReceived, partOfNotReceived);
152         }
153     }
154 }
155 
156 /**
157 * It is "Smart Contract Bank" smart-contract.
158 * - You can take profit 4% per day.
159 * - You can buy insurance and receive part of insurance fund when balance will be lesser then 0.01 ETH.
160 * - You can increase your percent on 0.5% if you have 10 CBC Token (0x790bFaCaE71576107C068f494c8A6302aea640cb ico.cryptoboss.me)
161 *    1. To buy CBC Tokens send 0.01 ETH on Sale Token Address 0x369fc7de8aee87a167244eb10b87eb3005780872
162 *    2. To increase your profit percent if you already have tokens, you should send to SmartContractBank address 0.0001 ETH
163 * - If your percent balance will be beyond of 200% you will able to take your profit only once time.
164 * HODL your profit and take more then 200% percents.
165 * - If balance of contract will be lesser then 0.1 ETH every user able stop contract and start insurance payments.
166 *
167 * - Percent of profit depends on balance of contract. Percent chart below:
168 * - If balance < 100 ETH - 4% per day
169 * - If balance >= 100 ETH and < 600 - 2% per day
170 * - If balance >= 600 ETH and < 1000 - 1% per day
171 * - If balance >= 1000 ETH and < 3000 - 0.9% per day
172 * - If balance >= 3000 ETH and < 5000 - 0.8% per day
173 * - If balance >= 5000  - 0.7% per day
174 * - If balance of contract will be beyond threshold, your payout will be reevaluate depends on currently balance of contract
175 * -
176 * - You can calm your profit every 5 minutes
177 *
178 * To invest:
179 * - Send minimum 0.01 ETH to contract address
180 *
181 * To calm profit:
182 * - Send 0 ETH to contract address
183 */
184 contract SmartContractBank {
185     using SafeMath for uint256;
186     struct Investor {
187         uint256 deposit;
188         uint256 paymentTime;
189         uint256 withdrawals;
190         bool increasedPercent;
191         bool insured;
192     }
193     uint public countOfInvestors;
194     mapping (address => Investor) public investors;
195 
196     uint256 public minimum = 0.01 ether;
197     uint step = 5 minutes;
198     uint ownerPercent = 4;
199     uint promotionPercent = 8;
200     uint insurancePercent = 2;
201     bool public closed = false;
202 
203     address public ownerAddressOne = 0xaB5007407d8A686B9198079816ebBaaa2912ecC1;
204     address public ownerAddressTwo = 0x4A5b00cDDAeE928B8De7a7939545f372d6727C06;
205     address public promotionAddress = 0x3878E2231f7CA61c0c1D0Aa3e6962d7D23Df1B3b;
206     address public insuranceFundAddress;
207     address public CBCTokenAddress = 0x790bFaCaE71576107C068f494c8A6302aea640cb;
208     address public MainSaleAddress = 0x369fc7de8aee87a167244eb10b87eb3005780872;
209 
210     InsuranceFund IFContract;
211     CBCToken CBCTokenContract = CBCToken(CBCTokenAddress);
212     MainSale MainSaleContract = MainSale(MainSaleAddress);
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
350     function increasePercent() public {
351         Investor storage investor = investors[msg.sender];
352         if (CBCTokenContract.balanceOf(msg.sender) >= 10 ether){
353             MainSaleContract.authorizedBurnTokens(msg.sender, 10 ether);
354             investor.increasedPercent = true;
355         }
356     }
357 
358     /**
359     * @dev  Payable function for
360     * - receive funds (send minimum 0.01 ETH),
361     * - increase percent and receive profit (send 0.0001 ETH if you already have CBC Tokens on your address).
362     * - calm your profit (send 0 ETH)
363     */
364     function () external payable {
365         require(!closed);
366         Investor storage investor = investors[msg.sender];
367         if (msg.value >= minimum){
368         
369             withdraw();
370 
371             if (investor.deposit == 0){
372                 countOfInvestors++;
373             }
374 
375             investor.deposit = investor.deposit.add(msg.value);
376             investor.paymentTime = now;
377 
378             if (investor.insured){
379                 IFContract.setInfo(msg.sender, investor.deposit, investor.withdrawals);
380             }
381             allocation();
382             emit Invest(msg.sender, msg.value);
383         } else if (msg.value == 0.0001 ether) {
384             increasePercent();
385         } else {
386             withdraw();
387         }
388     }
389 }
390 
391 
392 /**
393  * @title Ownable
394  * @dev The Ownable contract has an owner address, and provides basic authorization control
395  * functions, this simplifies the implementation of "user permissions".
396  */
397 contract Ownable {
398     address public owner;
399 
400 
401     /**
402      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
403      * account.
404      */
405     function Ownable() public {
406         owner = msg.sender;
407     }
408 
409 
410     /**
411      * @dev Throws if called by any account other than the owner.
412      */
413     modifier onlyOwner() {
414         require (msg.sender == owner);
415         _;
416     }
417 
418 
419     /**
420      * @dev Allows the current owner to transfer control of the contract to a newOwner.
421      * @param newOwner The address to transfer ownership to.
422      */
423     function transferOwnership(address newOwner) onlyOwner {
424         require(newOwner != address(0));
425         owner = newOwner;
426     }
427 }
428 
429 
430 
431 /**
432  * @title Authorizable
433  * @dev Allows to authorize access to certain function calls
434  *
435  * ABI
436  * [{"constant":true,"inputs":[{"name":"authorizerIndex","type":"uint256"}],"name":"getAuthorizer","outputs":[{"name":"","type":"address"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_addr","type":"address"}],"name":"addAuthorized","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[{"name":"_addr","type":"address"}],"name":"isAuthorized","outputs":[{"name":"","type":"bool"}],"payable":false,"type":"function"},{"inputs":[],"payable":false,"type":"constructor"}]
437  */
438 contract Authorizable {
439 
440     address[] authorizers;
441     mapping(address => uint) authorizerIndex;
442 
443     /**
444      * @dev Throws if called by any account tat is not authorized.
445      */
446     modifier onlyAuthorized {
447         require(isAuthorized(msg.sender));
448         _;
449     }
450 
451     /**
452      * @dev Contructor that authorizes the msg.sender.
453      */
454     function Authorizable() public {
455         authorizers.length = 2;
456         authorizers[1] = msg.sender;
457         authorizerIndex[msg.sender] = 1;
458     }
459 
460     /**
461      * @dev Function to get a specific authorizer
462      * @param authorizerIndex index of the authorizer to be retrieved.
463      * @return The address of the authorizer.
464      */
465     function getAuthorizer(uint authorizerIndex) external constant returns(address) {
466         return address(authorizers[authorizerIndex + 1]);
467     }
468 
469     /**
470      * @dev Function to check if an address is authorized
471      * @param _addr the address to check if it is authorized.
472      * @return boolean flag if address is authorized.
473      */
474     function isAuthorized(address _addr) public constant returns(bool) {
475         return authorizerIndex[_addr] > 0;
476     }
477 
478     /**
479      * @dev Function to add a new authorizer
480      * @param _addr the address to add as a new authorizer.
481      */
482     function addAuthorized(address _addr) external onlyAuthorized {
483         authorizerIndex[_addr] = authorizers.length;
484         authorizers.length++;
485         authorizers[authorizers.length - 1] = _addr;
486     }
487 
488 }
489 
490 /**
491  * @title ExchangeRate
492  * @dev Allows updating and retrieveing of Conversion Rates for PAY tokens
493  *
494  * ABI
495  * [{"constant":false,"inputs":[{"name":"_symbol","type":"string"},{"name":"_rate","type":"uint256"}],"name":"updateRate","outputs":[],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"data","type":"uint256[]"}],"name":"updateRates","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[{"name":"_symbol","type":"string"}],"name":"getRate","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"owner","outputs":[{"name":"","type":"address"}],"payable":false,"type":"function"},{"constant":true,"inputs":[{"name":"","type":"bytes32"}],"name":"rates","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"newOwner","type":"address"}],"name":"transferOwnership","outputs":[],"payable":false,"type":"function"},{"anonymous":false,"inputs":[{"indexed":false,"name":"timestamp","type":"uint256"},{"indexed":false,"name":"symbol","type":"bytes32"},{"indexed":false,"name":"rate","type":"uint256"}],"name":"RateUpdated","type":"event"}]
496  */
497 contract ExchangeRate is Ownable {
498 
499     event RateUpdated(uint timestamp, bytes32 symbol, uint rate);
500 
501     mapping(bytes32 => uint) public rates;
502 
503     /**
504      * @dev Allows the current owner to update a single rate.
505      * @param _symbol The symbol to be updated.
506      * @param _rate the rate for the symbol.
507      */
508     function updateRate(string _symbol, uint _rate) public onlyOwner {
509         rates[keccak256(_symbol)] = _rate;
510         RateUpdated(now, keccak256(_symbol), _rate);
511     }
512 
513     /**
514      * @dev Allows the current owner to update multiple rates.
515      * @param data an array that alternates keccak256 hashes of the symbol and the corresponding rate .
516      */
517     function updateRates(uint[] data) public onlyOwner {
518         require (data.length % 2 <= 0);
519         uint i = 0;
520         while (i < data.length / 2) {
521             bytes32 symbol = bytes32(data[i * 2]);
522             uint rate = data[i * 2 + 1];
523             rates[symbol] = rate;
524             RateUpdated(now, symbol, rate);
525             i++;
526         }
527     }
528 
529     /**
530      * @dev Allows the anyone to read the current rate.
531      * @param _symbol the symbol to be retrieved.
532      */
533     function getRate(string _symbol) public constant returns(uint) {
534         return rates[keccak256(_symbol)];
535     }
536 
537 }
538 
539 /**
540  * Math operations with safety checks
541  */
542 library SafeMath {
543     function mul(uint a, uint b) internal returns (uint) {
544         uint c = a * b;
545         assert(a == 0 || c / a == b);
546         return c;
547     }
548 
549     function div(uint a, uint b) internal returns (uint) {
550         // assert(b > 0); // Solidity automatically throws when dividing by 0
551         uint c = a / b;
552         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
553         return c;
554     }
555 
556     function sub(uint a, uint b) internal returns (uint) {
557         assert(b <= a);
558         return a - b;
559     }
560 
561     function add(uint a, uint b) internal returns (uint) {
562         uint c = a + b;
563         assert(c >= a);
564         return c;
565     }
566 
567     function max64(uint64 a, uint64 b) internal constant returns (uint64) {
568         return a >= b ? a : b;
569     }
570 
571     function min64(uint64 a, uint64 b) internal constant returns (uint64) {
572         return a < b ? a : b;
573     }
574 
575     function max256(uint256 a, uint256 b) internal constant returns (uint256) {
576         return a >= b ? a : b;
577     }
578 
579     function min256(uint256 a, uint256 b) internal constant returns (uint256) {
580         return a < b ? a : b;
581     }
582 
583     function assert(bool assertion) internal {
584         require(assertion);
585     }
586 }
587 
588 
589 /**
590  * @title ERC20Basic
591  * @dev Simpler version of ERC20 interface
592  * @dev see https://github.com/ethereum/EIPs/issues/20
593  */
594 contract ERC20Basic {
595     uint public totalSupply;
596     function balanceOf(address who) public constant returns (uint);
597     function transfer(address to, uint value) public;
598     event Transfer(address indexed from, address indexed to, uint value);
599 }
600 
601 
602 
603 
604 /**
605  * @title ERC20 interface
606  * @dev see https://github.com/ethereum/EIPs/issues/20
607  */
608 contract ERC20 is ERC20Basic {
609     function allowance(address owner, address spender) constant returns (uint);
610     function transferFrom(address from, address to, uint value);
611     function approve(address spender, uint value);
612     event Approval(address indexed owner, address indexed spender, uint value);
613 }
614 
615 
616 
617 
618 /**
619  * @title Basic token
620  * @dev Basic version of StandardToken, with no allowances.
621  */
622 contract BasicToken is ERC20Basic {
623     using SafeMath for uint;
624 
625     mapping(address => uint) balances;
626 
627     /**
628      * @dev Fix for the ERC20 short address attack.
629      */
630     modifier onlyPayloadSize(uint size) {
631         require (size + 4 <= msg.data.length);
632         _;
633     }
634 
635     /**
636     * @dev transfer token for a specified address
637     * @param _to The address to transfer to.
638     * @param _value The amount to be transferred.
639     */
640     function transfer(address _to, uint _value) onlyPayloadSize(2 * 32) {
641         balances[msg.sender] = balances[msg.sender].sub(_value);
642         balances[_to] = balances[_to].add(_value);
643         Transfer(msg.sender, _to, _value);
644     }
645 
646     /**
647     * @dev Gets the balance of the specified address.
648     * @param _owner The address to query the the balance of.
649     * @return An uint representing the amount owned by the passed address.
650     */
651     function balanceOf(address _owner) constant returns (uint balance) {
652         return balances[_owner];
653     }
654 
655 }
656 
657 
658 
659 
660 /**
661  * @title Standard ERC20 token
662  *
663  * @dev Implemantation of the basic standart token.
664  * @dev https://github.com/ethereum/EIPs/issues/20
665  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
666  */
667 contract StandardToken is BasicToken, ERC20 {
668 
669     mapping (address => mapping (address => uint)) allowed;
670 
671 
672     /**
673      * @dev Transfer tokens from one address to another
674      * @param _from address The address which you want to send tokens from
675      * @param _to address The address which you want to transfer to
676      * @param _value uint the amout of tokens to be transfered
677      */
678     function transferFrom(address _from, address _to, uint _value) onlyPayloadSize(3 * 32) {
679         var _allowance = allowed[_from][msg.sender];
680 
681         // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
682         // if (_value > _allowance) throw;
683 
684         balances[_to] = balances[_to].add(_value);
685         balances[_from] = balances[_from].sub(_value);
686         allowed[_from][msg.sender] = _allowance.sub(_value);
687         Transfer(_from, _to, _value);
688     }
689 
690     /**
691      * @dev Aprove the passed address to spend the specified amount of tokens on beahlf of msg.sender.
692      * @param _spender The address which will spend the funds.
693      * @param _value The amount of tokens to be spent.
694      */
695     function approve(address _spender, uint _value) {
696 
697         // To change the approve amount you first have to reduce the addresses`
698         //  allowance to zero by calling `approve(_spender, 0)` if it is not
699         //  already 0 to mitigate the race condition described here:
700         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
701         if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;
702 
703         allowed[msg.sender][_spender] = _value;
704         Approval(msg.sender, _spender, _value);
705     }
706 
707     /**
708      * @dev Function to check the amount of tokens than an owner allowed to a spender.
709      * @param _owner address The address which owns the funds.
710      * @param _spender address The address which will spend the funds.
711      * @return A uint specifing the amount of tokens still avaible for the spender.
712      */
713     function allowance(address _owner, address _spender) constant returns (uint remaining) {
714         return allowed[_owner][_spender];
715     }
716 
717 }
718 
719 
720 /**
721  * @title Mintable token
722  * @dev Simple ERC20 Token example, with mintable token creation
723  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
724  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
725  */
726 
727 contract MintableToken is StandardToken, Ownable {
728     event Mint(address indexed to, uint value);
729     event MintFinished();
730     event Burn(address indexed burner, uint256 value);
731 
732     bool public mintingFinished = false;
733     uint public totalSupply = 0;
734 
735 
736     modifier canMint() {
737         require(!mintingFinished);
738         _;
739     }
740 
741     /**
742      * @dev Function to mint tokens
743      * @param _to The address that will recieve the minted tokens.
744      * @param _amount The amount of tokens to mint.
745      * @return A boolean that indicates if the operation was successful.
746      */
747     function mint(address _to, uint _amount) onlyOwner canMint returns (bool) {
748         totalSupply = totalSupply.add(_amount);
749         balances[_to] = balances[_to].add(_amount);
750         Mint(_to, _amount);
751         return true;
752     }
753 
754     /**
755      * @dev Function to stop minting new tokens.
756      * @return True if the operation was successful.
757      */
758     function finishMinting() onlyOwner returns (bool) {
759         mintingFinished = true;
760         MintFinished();
761         return true;
762     }
763 
764 
765     /**
766      * @dev Burns a specific amount of tokens.
767      * @param _value The amount of token to be burned.
768      */
769     function burn(address _who, uint256 _value) onlyOwner public {
770         _burn(_who, _value);
771     }
772 
773     function _burn(address _who, uint256 _value) internal {
774         require(_value <= balances[_who]);
775         // no need to require value <= totalSupply, since that would imply the
776         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
777 
778         balances[_who] = balances[_who].sub(_value);
779         totalSupply = totalSupply.sub(_value);
780         Burn(_who, _value);
781         Transfer(_who, address(0), _value);
782     }
783 }
784 
785 
786 /**
787  * @title CBCToken
788  * @dev The main CBC token contract
789  *
790  * ABI
791  * [{"constant":true,"inputs":[],"name":"mintingFinished","outputs":[{"name":"","type":"bool"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"name","outputs":[{"name":"","type":"string"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_spender","type":"address"},{"name":"_value","type":"uint256"}],"name":"approve","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"totalSupply","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_from","type":"address"},{"name":"_to","type":"address"},{"name":"_value","type":"uint256"}],"name":"transferFrom","outputs":[],"payable":false,"type":"function"},{"constant":false,"inputs":[],"name":"startTrading","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"decimals","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_to","type":"address"},{"name":"_amount","type":"uint256"}],"name":"mint","outputs":[{"name":"","type":"bool"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"tradingStarted","outputs":[{"name":"","type":"bool"}],"payable":false,"type":"function"},{"constant":true,"inputs":[{"name":"_owner","type":"address"}],"name":"balanceOf","outputs":[{"name":"balance","type":"uint256"}],"payable":false,"type":"function"},{"constant":false,"inputs":[],"name":"finishMinting","outputs":[{"name":"","type":"bool"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"owner","outputs":[{"name":"","type":"address"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"symbol","outputs":[{"name":"","type":"string"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_to","type":"address"},{"name":"_value","type":"uint256"}],"name":"transfer","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[{"name":"_owner","type":"address"},{"name":"_spender","type":"address"}],"name":"allowance","outputs":[{"name":"remaining","type":"uint256"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"newOwner","type":"address"}],"name":"transferOwnership","outputs":[],"payable":false,"type":"function"},{"anonymous":false,"inputs":[{"indexed":true,"name":"to","type":"address"},{"indexed":false,"name":"value","type":"uint256"}],"name":"Mint","type":"event"},{"anonymous":false,"inputs":[],"name":"MintFinished","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"name":"owner","type":"address"},{"indexed":true,"name":"spender","type":"address"},{"indexed":false,"name":"value","type":"uint256"}],"name":"Approval","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"name":"from","type":"address"},{"indexed":true,"name":"to","type":"address"},{"indexed":false,"name":"value","type":"uint256"}],"name":"Transfer","type":"event"}]
792  */
793 contract CBCToken is MintableToken {
794 
795     string public name = "Crypto Boss Coin";
796     string public symbol = "CBC";
797     uint public decimals = 18;
798 
799     bool public tradingStarted = false;
800     /**
801      * @dev modifier that throws if trading has not started yet
802      */
803     modifier hasStartedTrading() {
804         require(tradingStarted);
805         _;
806     }
807 
808 
809     /**
810      * @dev Allows the owner to enable the trading. This can not be undone
811      */
812     function startTrading() onlyOwner {
813         tradingStarted = true;
814     }
815 
816     /**
817      * @dev Allows anyone to transfer the PAY tokens once trading has started
818      * @param _to the recipient address of the tokens.
819      * @param _value number of tokens to be transfered.
820      */
821     function transfer(address _to, uint _value) hasStartedTrading {
822         super.transfer(_to, _value);
823     }
824 
825     /**
826     * @dev Allows anyone to transfer the CBC tokens once trading has started
827     * @param _from address The address which you want to send tokens from
828     * @param _to address The address which you want to transfer to
829     * @param _value uint the amout of tokens to be transfered
830     */
831     function transferFrom(address _from, address _to, uint _value) hasStartedTrading {
832         super.transferFrom(_from, _to, _value);
833     }
834 
835 }
836 
837 /**
838  * @title MainSale
839  * @dev The main CBC token sale contract
840  *
841  * ABI
842  * [{"constant":false,"inputs":[{"name":"_multisigVault","type":"address"}],"name":"setMultisigVault","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[{"name":"authorizerIndex","type":"uint256"}],"name":"getAuthorizer","outputs":[{"name":"","type":"address"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"exchangeRate","outputs":[{"name":"","type":"address"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"altDeposits","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"recipient","type":"address"},{"name":"tokens","type":"uint256"}],"name":"authorizedCreateTokens","outputs":[],"payable":false,"type":"function"},{"constant":false,"inputs":[],"name":"finishMinting","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"owner","outputs":[{"name":"","type":"address"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_exchangeRate","type":"address"}],"name":"setExchangeRate","outputs":[],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_token","type":"address"}],"name":"retrieveTokens","outputs":[],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"totalAltDeposits","type":"uint256"}],"name":"setAltDeposit","outputs":[],"payable":false,"type":"function"},{"constant":!1,"inputs":[{"name":"victim","type":"address"},{"name":"amount","type":"uint256"}],"name":"burnTokens","outputs":[],"payable":!1,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[],"name":"start","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"recipient","type":"address"}],"name":"createTokens","outputs":[],"payable":true,"type":"function"},{"constant":false,"inputs":[{"name":"_addr","type":"address"}],"name":"addAuthorized","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"multisigVault","outputs":[{"name":"","type":"address"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_hardcap","type":"uint256"}],"name":"setHardCap","outputs":[],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"newOwner","type":"address"}],"name":"transferOwnership","outputs":[],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_start","type":"uint256"}],"name":"setStart","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"token","outputs":[{"name":"","type":"address"}],"payable":false,"type":"function"},{"constant":true,"inputs":[{"name":"_addr","type":"address"}],"name":"isAuthorized","outputs":[{"name":"","type":"bool"}],"payable":false,"type":"function"},{"payable":true,"type":"fallback"},{"anonymous":false,"inputs":[{"indexed":false,"name":"recipient","type":"address"},{"indexed":false,"name":"ether_amount","type":"uint256"},{"indexed":false,"name":"pay_amount","type":"uint256"},{"indexed":false,"name":"exchangerate","type":"uint256"}],"name":"TokenSold","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"name":"recipient","type":"address"},{"indexed":false,"name":"pay_amount","type":"uint256"}],"name":"AuthorizedCreate","type":"event"},{"anonymous":false,"inputs":[],"name":"MainSaleClosed","type":"event"}]
843  */
844 contract MainSale is Ownable, Authorizable {
845     using SafeMath for uint;
846     event TokenSold(address recipient, uint ether_amount, uint pay_amount, uint exchangerate);
847     event AuthorizedCreate(address recipient, uint pay_amount);
848     event AuthorizedBurn(address receiver, uint value);
849     event AuthorizedStartTrading();
850     event MainSaleClosed();
851     CBCToken public token = new CBCToken();
852 
853     address public multisigVault;
854 
855     uint hardcap = 100000000000000 ether;
856     ExchangeRate public exchangeRate;
857 
858     uint public altDeposits = 0;
859     uint public start = 1525996800;
860 
861     /**
862      * @dev modifier to allow token creation only when the sale IS ON
863      */
864     modifier saleIsOn() {
865         require(now > start && now < start + 28 days);
866         _;
867     }
868 
869     /**
870      * @dev modifier to allow token creation only when the hardcap has not been reached
871      */
872     modifier isUnderHardCap() {
873         require(multisigVault.balance + altDeposits <= hardcap);
874         _;
875     }
876 
877     /**
878      * @dev Allows anyone to create tokens by depositing ether.
879      * @param recipient the recipient to receive tokens.
880      */
881     function createTokens(address recipient) public isUnderHardCap saleIsOn payable {
882         uint rate = exchangeRate.getRate("ETH");
883         uint tokens = rate.mul(msg.value).div(1 ether);
884         token.mint(recipient, tokens);
885         require(multisigVault.send(msg.value));
886         TokenSold(recipient, msg.value, tokens, rate);
887     }
888 
889     /**
890      * @dev Allows to set the toal alt deposit measured in ETH to make sure the hardcap includes other deposits
891      * @param totalAltDeposits total amount ETH equivalent
892      */
893     function setAltDeposit(uint totalAltDeposits) public onlyOwner {
894         altDeposits = totalAltDeposits;
895     }
896 
897     /**
898      * @dev Allows authorized acces to create tokens. This is used for Bitcoin and ERC20 deposits
899      * @param recipient the recipient to receive tokens.
900      * @param tokens number of tokens to be created.
901      */
902     function authorizedCreateTokens(address recipient, uint tokens) public onlyAuthorized {
903         token.mint(recipient, tokens);
904         AuthorizedCreate(recipient, tokens);
905     }
906 
907     function authorizedStartTrading() public onlyAuthorized {
908         token.startTrading();
909         AuthorizedStartTrading();
910     }
911 
912     /**
913      * @dev Allows authorized acces to burn tokens.
914      * @param receiver the receiver to receive tokens.
915      * @param value number of tokens to be created.
916      */
917     function authorizedBurnTokens(address receiver, uint value) public onlyAuthorized {
918         token.burn(receiver, value);
919         AuthorizedBurn(receiver, value);
920     }
921 
922     /**
923      * @dev Allows the owner to set the hardcap.
924      * @param _hardcap the new hardcap
925      */
926     function setHardCap(uint _hardcap) public onlyOwner {
927         hardcap = _hardcap;
928     }
929 
930     /**
931      * @dev Allows the owner to set the starting time.
932      * @param _start the new _start
933      */
934     function setStart(uint _start) public onlyOwner {
935         start = _start;
936     }
937 
938     /**
939      * @dev Allows the owner to set the multisig contract.
940      * @param _multisigVault the multisig contract address
941      */
942     function setMultisigVault(address _multisigVault) public onlyOwner {
943         if (_multisigVault != address(0)) {
944             multisigVault = _multisigVault;
945         }
946     }
947 
948     /**
949      * @dev Allows the owner to set the exchangerate contract.
950      * @param _exchangeRate the exchangerate address
951      */
952     function setExchangeRate(address _exchangeRate) public onlyOwner {
953         exchangeRate = ExchangeRate(_exchangeRate);
954     }
955 
956     /**
957      * @dev Allows the owner to finish the minting. This will create the
958      * restricted tokens and then close the minting.
959      * Then the ownership of the PAY token contract is transfered
960      * to this owner.
961      */
962     function finishMinting() public onlyOwner {
963         uint issuedTokenSupply = token.totalSupply();
964         uint restrictedTokens = issuedTokenSupply.mul(49).div(51);
965         token.mint(multisigVault, restrictedTokens);
966         token.finishMinting();
967         token.transferOwnership(owner);
968         MainSaleClosed();
969     }
970 
971     /**
972      * @dev Allows the owner to transfer ERC20 tokens to the multi sig vault
973      * @param _token the contract address of the ERC20 contract
974      */
975     function retrieveTokens(address _token) public onlyOwner {
976         ERC20 token = ERC20(_token);
977         token.transfer(multisigVault, token.balanceOf(this));
978     }
979 
980     /**
981      * @dev Fallback function which receives ether and created the appropriate number of tokens for the
982      * msg.sender.
983      */
984     function() external payable {
985         createTokens(msg.sender);
986     }
987 
988 }