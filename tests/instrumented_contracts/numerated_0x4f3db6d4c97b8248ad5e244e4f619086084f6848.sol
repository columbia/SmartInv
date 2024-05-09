1 pragma solidity ^0.4.24;
2 
3 /**
4 * It is "Smart Contract Bank" smart-contract.
5 * - You can take profit 4% per day.
6 * - You can buy insurance and receive part of insurance fund when balance will be lesser then 0.01 ETH.
7 * - You can increase your percent on 0.5% if you have 10 CBC Token (0x790bFaCaE71576107C068f494c8A6302aea640cb ico.cryptoboss.me)
8 *    1. To buy CBC Tokens send 0.01 ETH on Sale Token Address 0x369fc7de8aee87a167244eb10b87eb3005780872
9 *    2. To increase your profit percent if you already have tokens, you should send to SmartContractBank address 0.0001 ETH
10 * - If your percent balance will be beyond of 200% you will able to take your profit only once time.
11 * HODL your profit and take more then 200% percents.
12 * - If balance of contract will be lesser then 0.1 ETH every user able stop contract and start insurance payments.
13 *
14 * - Percent of profit depends on balance of contract. Percent chart below:
15 * - If balance < 100 ETH - 4% per day
16 * - If balance >= 100 ETH and < 600 - 2% per day
17 * - If balance >= 600 ETH and < 1000 - 1% per day
18 * - If balance >= 1000 ETH and < 3000 - 0.9% per day
19 * - If balance >= 3000 ETH and < 5000 - 0.8% per day
20 * - If balance >= 5000  - 0.7% per day
21 * - If balance of contract will be beyond threshold, your payout will be reevaluate depends on currently balance of contract
22 * -
23 * - You can calm your profit every 5 minutes
24 *
25 * To invest:
26 * - Send minimum 0.01 ETH to contract address
27 *
28 * To calm profit:
29 * - Send 0 ETH to contract address
30 */
31 contract SmartContractBank {
32     using SafeMath for uint256;
33     struct Investor {
34         uint256 deposit;
35         uint256 paymentTime;
36         uint256 withdrawals;
37         bool increasedPercent;
38         bool insured;
39     }
40     uint public countOfInvestors;
41     mapping (address => Investor) public investors;
42 
43     uint256 public minimum = 0.01 ether;
44     uint step = 5 minutes;
45     uint ownerPercent = 4;
46     uint promotionPercent = 8;
47     uint insurancePercent = 2;
48     bool public closed = false;
49 
50     address public ownerAddressOne = 0xaB5007407d8A686B9198079816ebBaaa2912ecC1;
51     address public ownerAddressTwo = 0x4A5b00cDDAeE928B8De7a7939545f372d6727C06;
52     address public promotionAddress = 0x3878E2231f7CA61c0c1D0Aa3e6962d7D23Df1B3b;
53     address public insuranceFundAddress;
54     address public CBCTokenAddress = 0x790bFaCaE71576107C068f494c8A6302aea640cb;
55     address public MainSaleAddress = 0x369fc7de8aee87a167244eb10b87eb3005780872;
56 
57     InsuranceFund IFContract;
58     CBCToken CBCTokenContract = CBCToken(CBCTokenAddress);
59     MainSale MainSaleContract = MainSale(MainSaleAddress);
60     
61     event Invest(address investor, uint256 amount);
62     event Withdraw(address investor, uint256 amount);
63     event UserDelete(address investor);
64 
65     /**
66     * @dev Modifier for access from the InsuranceFund
67     */
68     modifier onlyIF() {
69         require(insuranceFundAddress == msg.sender, "access denied");
70         _;
71     }
72 
73     /**
74     * @dev  Setter the InsuranceFund address. Address can be set only once.
75     * @param _insuranceFundAddress Address of the InsuranceFund
76     */
77     function setInsuranceFundAddress(address _insuranceFundAddress) public{
78         require(insuranceFundAddress == address(0x0));
79         insuranceFundAddress = _insuranceFundAddress;
80         IFContract = InsuranceFund(insuranceFundAddress);
81     }
82 
83     /**
84     * @dev  Set insured from the InsuranceFund.
85     * @param _address Investor's address
86     * @return Object of investor's information
87     */
88     function setInsured(address _address) public onlyIF returns(uint256, uint256, bool){
89         Investor storage investor = investors[_address];
90         investor.insured = true;
91         return (investor.deposit, investor.withdrawals, investor.insured);
92     }
93 
94     /**
95     * @dev  Function for close entrance.
96     */
97     function closeEntrance() public {
98         require(address(this).balance < 0.1 ether && !closed);
99         closed = true;
100     }
101 
102     /**
103     * @dev Get percent depends on balance of contract
104     * @return Percent
105     */
106     function getPhasePercent() view public returns (uint){
107         Investor storage investor = investors[msg.sender];
108         uint contractBalance = address(this).balance;
109         uint percent;
110         if (contractBalance < 100 ether) {
111             percent = 40;
112         }
113         if (contractBalance >= 100 ether && contractBalance < 600 ether) {
114             percent = 20;
115         }
116         if (contractBalance >= 600 ether && contractBalance < 1000 ether) {
117             percent = 10;
118         }
119         if (contractBalance >= 1000 ether && contractBalance < 3000 ether) {
120             percent = 9;
121         }
122         if (contractBalance >= 3000 ether && contractBalance < 5000 ether) {
123             percent = 8;
124         }
125         if (contractBalance >= 5000 ether) {
126             percent = 7;
127         }
128 
129         if (investor.increasedPercent){
130             percent = percent.add(5);
131         }
132 
133         return percent;
134     }
135 
136     /**
137     * @dev Allocation budgets
138     */
139     function allocation() private{
140         ownerAddressOne.transfer(msg.value.mul(ownerPercent.div(2)).div(100));
141         ownerAddressTwo.transfer(msg.value.mul(ownerPercent.div(2)).div(100));
142         promotionAddress.transfer(msg.value.mul(promotionPercent).div(100));
143         insuranceFundAddress.transfer(msg.value.mul(insurancePercent).div(100));
144     }
145 
146     /**
147     * @dev Evaluate current balance
148     * @param _address Address of investor
149     * @return Payout amount
150     */
151     function getUserBalance(address _address) view public returns (uint256) {
152         Investor storage investor = investors[_address];
153         uint percent = getPhasePercent();
154         uint256 differentTime = now.sub(investor.paymentTime).div(step);
155         uint256 differentPercent = investor.deposit.mul(percent).div(1000);
156         uint256 payout = differentPercent.mul(differentTime).div(288);
157 
158         return payout;
159     }
160 
161     /**
162     * @dev Withdraw profit from contract. Investor will be deleted if he will try withdraw after received x2
163     */
164     function withdraw() private {
165         Investor storage investor = investors[msg.sender];
166         uint256 balance = getUserBalance(msg.sender);
167         if (investor.deposit > 0 && address(this).balance > balance && balance > 0) {
168             uint256 tempWithdrawals = investor.withdrawals;
169 
170             investor.withdrawals = investor.withdrawals.add(balance);
171             investor.paymentTime = now;
172 
173             if (investor.withdrawals >= investor.deposit.mul(2)){
174                 investor.deposit = 0;
175                 investor.paymentTime = 0;
176                 investor.withdrawals = 0;
177                 investor.increasedPercent = false;
178                 investor.insured = false;
179                 countOfInvestors--;
180                 if (investor.insured)
181                     IFContract.deleteInsured(msg.sender);
182                 emit UserDelete(msg.sender);
183             } else {
184                 if (investor.insured && tempWithdrawals < investor.deposit){
185                     IFContract.setInfo(msg.sender, investor.deposit, investor.withdrawals);
186                 }
187             }
188             msg.sender.transfer(balance);
189             emit Withdraw(msg.sender, balance);
190         }
191 
192     }
193 
194     /**
195     * @dev Increase percent with CBC Token
196     */
197     function increasePercent() public {
198         Investor storage investor = investors[msg.sender];
199         if (CBCTokenContract.balanceOf(msg.sender) >= 10 ether){
200             MainSaleContract.authorizedBurnTokens(msg.sender, 10 ether);
201             investor.increasedPercent = true;
202         }
203     }
204 
205     /**
206     * @dev  Payable function for
207     * - receive funds (send minimum 0.01 ETH),
208     * - increase percent and receive profit (send 0.0001 ETH if you already have CBC Tokens on your address).
209     * - calm your profit (send 0 ETH)
210     */
211     function () external payable {
212         require(!closed);
213         Investor storage investor = investors[msg.sender];
214         if (msg.value >= minimum){
215         
216             withdraw();
217 
218             if (investor.deposit == 0){
219                 countOfInvestors++;
220             }
221 
222             investor.deposit = investor.deposit.add(msg.value);
223             investor.paymentTime = now;
224 
225             if (investor.insured){
226                 IFContract.setInfo(msg.sender, investor.deposit, investor.withdrawals);
227             }
228             allocation();
229             emit Invest(msg.sender, msg.value);
230         } else if (msg.value == 0.0001 ether) {
231             increasePercent();
232         } else {
233             withdraw();
234         }
235     }
236 }
237 
238 
239 /**
240  * @title Ownable
241  * @dev The Ownable contract has an owner address, and provides basic authorization control
242  * functions, this simplifies the implementation of "user permissions".
243  */
244 contract Ownable {
245     address public owner;
246 
247 
248     /**
249      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
250      * account.
251      */
252     function Ownable() public {
253         owner = msg.sender;
254     }
255 
256 
257     /**
258      * @dev Throws if called by any account other than the owner.
259      */
260     modifier onlyOwner() {
261         require (msg.sender == owner);
262         _;
263     }
264 
265 
266     /**
267      * @dev Allows the current owner to transfer control of the contract to a newOwner.
268      * @param newOwner The address to transfer ownership to.
269      */
270     function transferOwnership(address newOwner) onlyOwner {
271         require(newOwner != address(0));
272         owner = newOwner;
273     }
274 }
275 
276 
277 
278 /**
279  * @title Authorizable
280  * @dev Allows to authorize access to certain function calls
281  *
282  * ABI
283  * [{"constant":true,"inputs":[{"name":"authorizerIndex","type":"uint256"}],"name":"getAuthorizer","outputs":[{"name":"","type":"address"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_addr","type":"address"}],"name":"addAuthorized","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[{"name":"_addr","type":"address"}],"name":"isAuthorized","outputs":[{"name":"","type":"bool"}],"payable":false,"type":"function"},{"inputs":[],"payable":false,"type":"constructor"}]
284  */
285 contract Authorizable {
286 
287     address[] authorizers;
288     mapping(address => uint) authorizerIndex;
289 
290     /**
291      * @dev Throws if called by any account tat is not authorized.
292      */
293     modifier onlyAuthorized {
294         require(isAuthorized(msg.sender));
295         _;
296     }
297 
298     /**
299      * @dev Contructor that authorizes the msg.sender.
300      */
301     function Authorizable() public {
302         authorizers.length = 2;
303         authorizers[1] = msg.sender;
304         authorizerIndex[msg.sender] = 1;
305     }
306 
307     /**
308      * @dev Function to get a specific authorizer
309      * @param authorizerIndex index of the authorizer to be retrieved.
310      * @return The address of the authorizer.
311      */
312     function getAuthorizer(uint authorizerIndex) external constant returns(address) {
313         return address(authorizers[authorizerIndex + 1]);
314     }
315 
316     /**
317      * @dev Function to check if an address is authorized
318      * @param _addr the address to check if it is authorized.
319      * @return boolean flag if address is authorized.
320      */
321     function isAuthorized(address _addr) public constant returns(bool) {
322         return authorizerIndex[_addr] > 0;
323     }
324 
325     /**
326      * @dev Function to add a new authorizer
327      * @param _addr the address to add as a new authorizer.
328      */
329     function addAuthorized(address _addr) external onlyAuthorized {
330         authorizerIndex[_addr] = authorizers.length;
331         authorizers.length++;
332         authorizers[authorizers.length - 1] = _addr;
333     }
334 
335 }
336 
337 /**
338  * @title ExchangeRate
339  * @dev Allows updating and retrieveing of Conversion Rates for PAY tokens
340  *
341  * ABI
342  * [{"constant":false,"inputs":[{"name":"_symbol","type":"string"},{"name":"_rate","type":"uint256"}],"name":"updateRate","outputs":[],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"data","type":"uint256[]"}],"name":"updateRates","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[{"name":"_symbol","type":"string"}],"name":"getRate","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"owner","outputs":[{"name":"","type":"address"}],"payable":false,"type":"function"},{"constant":true,"inputs":[{"name":"","type":"bytes32"}],"name":"rates","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"newOwner","type":"address"}],"name":"transferOwnership","outputs":[],"payable":false,"type":"function"},{"anonymous":false,"inputs":[{"indexed":false,"name":"timestamp","type":"uint256"},{"indexed":false,"name":"symbol","type":"bytes32"},{"indexed":false,"name":"rate","type":"uint256"}],"name":"RateUpdated","type":"event"}]
343  */
344 contract ExchangeRate is Ownable {
345 
346     event RateUpdated(uint timestamp, bytes32 symbol, uint rate);
347 
348     mapping(bytes32 => uint) public rates;
349 
350     /**
351      * @dev Allows the current owner to update a single rate.
352      * @param _symbol The symbol to be updated.
353      * @param _rate the rate for the symbol.
354      */
355     function updateRate(string _symbol, uint _rate) public onlyOwner {
356         rates[keccak256(_symbol)] = _rate;
357         RateUpdated(now, keccak256(_symbol), _rate);
358     }
359 
360     /**
361      * @dev Allows the current owner to update multiple rates.
362      * @param data an array that alternates keccak256 hashes of the symbol and the corresponding rate .
363      */
364     function updateRates(uint[] data) public onlyOwner {
365         require (data.length % 2 <= 0);
366         uint i = 0;
367         while (i < data.length / 2) {
368             bytes32 symbol = bytes32(data[i * 2]);
369             uint rate = data[i * 2 + 1];
370             rates[symbol] = rate;
371             RateUpdated(now, symbol, rate);
372             i++;
373         }
374     }
375 
376     /**
377      * @dev Allows the anyone to read the current rate.
378      * @param _symbol the symbol to be retrieved.
379      */
380     function getRate(string _symbol) public constant returns(uint) {
381         return rates[keccak256(_symbol)];
382     }
383 
384 }
385 
386 /**
387  * Math operations with safety checks
388  */
389 library SafeMath {
390     function mul(uint a, uint b) internal returns (uint) {
391         uint c = a * b;
392         assert(a == 0 || c / a == b);
393         return c;
394     }
395 
396     function div(uint a, uint b) internal returns (uint) {
397         // assert(b > 0); // Solidity automatically throws when dividing by 0
398         uint c = a / b;
399         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
400         return c;
401     }
402 
403     function sub(uint a, uint b) internal returns (uint) {
404         assert(b <= a);
405         return a - b;
406     }
407 
408     function add(uint a, uint b) internal returns (uint) {
409         uint c = a + b;
410         assert(c >= a);
411         return c;
412     }
413 
414     function max64(uint64 a, uint64 b) internal constant returns (uint64) {
415         return a >= b ? a : b;
416     }
417 
418     function min64(uint64 a, uint64 b) internal constant returns (uint64) {
419         return a < b ? a : b;
420     }
421 
422     function max256(uint256 a, uint256 b) internal constant returns (uint256) {
423         return a >= b ? a : b;
424     }
425 
426     function min256(uint256 a, uint256 b) internal constant returns (uint256) {
427         return a < b ? a : b;
428     }
429 
430     function assert(bool assertion) internal {
431         require(assertion);
432     }
433 }
434 
435 
436 /**
437  * @title ERC20Basic
438  * @dev Simpler version of ERC20 interface
439  * @dev see https://github.com/ethereum/EIPs/issues/20
440  */
441 contract ERC20Basic {
442     uint public totalSupply;
443     function balanceOf(address who) public constant returns (uint);
444     function transfer(address to, uint value) public;
445     event Transfer(address indexed from, address indexed to, uint value);
446 }
447 
448 
449 
450 
451 /**
452  * @title ERC20 interface
453  * @dev see https://github.com/ethereum/EIPs/issues/20
454  */
455 contract ERC20 is ERC20Basic {
456     function allowance(address owner, address spender) constant returns (uint);
457     function transferFrom(address from, address to, uint value);
458     function approve(address spender, uint value);
459     event Approval(address indexed owner, address indexed spender, uint value);
460 }
461 
462 
463 
464 
465 /**
466  * @title Basic token
467  * @dev Basic version of StandardToken, with no allowances.
468  */
469 contract BasicToken is ERC20Basic {
470     using SafeMath for uint;
471 
472     mapping(address => uint) balances;
473 
474     /**
475      * @dev Fix for the ERC20 short address attack.
476      */
477     modifier onlyPayloadSize(uint size) {
478         require (size + 4 <= msg.data.length);
479         _;
480     }
481 
482     /**
483     * @dev transfer token for a specified address
484     * @param _to The address to transfer to.
485     * @param _value The amount to be transferred.
486     */
487     function transfer(address _to, uint _value) onlyPayloadSize(2 * 32) {
488         balances[msg.sender] = balances[msg.sender].sub(_value);
489         balances[_to] = balances[_to].add(_value);
490         Transfer(msg.sender, _to, _value);
491     }
492 
493     /**
494     * @dev Gets the balance of the specified address.
495     * @param _owner The address to query the the balance of.
496     * @return An uint representing the amount owned by the passed address.
497     */
498     function balanceOf(address _owner) constant returns (uint balance) {
499         return balances[_owner];
500     }
501 
502 }
503 
504 
505 
506 
507 /**
508  * @title Standard ERC20 token
509  *
510  * @dev Implemantation of the basic standart token.
511  * @dev https://github.com/ethereum/EIPs/issues/20
512  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
513  */
514 contract StandardToken is BasicToken, ERC20 {
515 
516     mapping (address => mapping (address => uint)) allowed;
517 
518 
519     /**
520      * @dev Transfer tokens from one address to another
521      * @param _from address The address which you want to send tokens from
522      * @param _to address The address which you want to transfer to
523      * @param _value uint the amout of tokens to be transfered
524      */
525     function transferFrom(address _from, address _to, uint _value) onlyPayloadSize(3 * 32) {
526         var _allowance = allowed[_from][msg.sender];
527 
528         // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
529         // if (_value > _allowance) throw;
530 
531         balances[_to] = balances[_to].add(_value);
532         balances[_from] = balances[_from].sub(_value);
533         allowed[_from][msg.sender] = _allowance.sub(_value);
534         Transfer(_from, _to, _value);
535     }
536 
537     /**
538      * @dev Aprove the passed address to spend the specified amount of tokens on beahlf of msg.sender.
539      * @param _spender The address which will spend the funds.
540      * @param _value The amount of tokens to be spent.
541      */
542     function approve(address _spender, uint _value) {
543 
544         // To change the approve amount you first have to reduce the addresses`
545         //  allowance to zero by calling `approve(_spender, 0)` if it is not
546         //  already 0 to mitigate the race condition described here:
547         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
548         if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;
549 
550         allowed[msg.sender][_spender] = _value;
551         Approval(msg.sender, _spender, _value);
552     }
553 
554     /**
555      * @dev Function to check the amount of tokens than an owner allowed to a spender.
556      * @param _owner address The address which owns the funds.
557      * @param _spender address The address which will spend the funds.
558      * @return A uint specifing the amount of tokens still avaible for the spender.
559      */
560     function allowance(address _owner, address _spender) constant returns (uint remaining) {
561         return allowed[_owner][_spender];
562     }
563 
564 }
565 
566 
567 /**
568  * @title Mintable token
569  * @dev Simple ERC20 Token example, with mintable token creation
570  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
571  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
572  */
573 
574 contract MintableToken is StandardToken, Ownable {
575     event Mint(address indexed to, uint value);
576     event MintFinished();
577     event Burn(address indexed burner, uint256 value);
578 
579     bool public mintingFinished = false;
580     uint public totalSupply = 0;
581 
582 
583     modifier canMint() {
584         require(!mintingFinished);
585         _;
586     }
587 
588     /**
589      * @dev Function to mint tokens
590      * @param _to The address that will recieve the minted tokens.
591      * @param _amount The amount of tokens to mint.
592      * @return A boolean that indicates if the operation was successful.
593      */
594     function mint(address _to, uint _amount) onlyOwner canMint returns (bool) {
595         totalSupply = totalSupply.add(_amount);
596         balances[_to] = balances[_to].add(_amount);
597         Mint(_to, _amount);
598         return true;
599     }
600 
601     /**
602      * @dev Function to stop minting new tokens.
603      * @return True if the operation was successful.
604      */
605     function finishMinting() onlyOwner returns (bool) {
606         mintingFinished = true;
607         MintFinished();
608         return true;
609     }
610 
611 
612     /**
613      * @dev Burns a specific amount of tokens.
614      * @param _value The amount of token to be burned.
615      */
616     function burn(address _who, uint256 _value) onlyOwner public {
617         _burn(_who, _value);
618     }
619 
620     function _burn(address _who, uint256 _value) internal {
621         require(_value <= balances[_who]);
622         // no need to require value <= totalSupply, since that would imply the
623         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
624 
625         balances[_who] = balances[_who].sub(_value);
626         totalSupply = totalSupply.sub(_value);
627         Burn(_who, _value);
628         Transfer(_who, address(0), _value);
629     }
630 }
631 
632 
633 /**
634  * @title CBCToken
635  * @dev The main CBC token contract
636  *
637  * ABI
638  * [{"constant":true,"inputs":[],"name":"mintingFinished","outputs":[{"name":"","type":"bool"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"name","outputs":[{"name":"","type":"string"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_spender","type":"address"},{"name":"_value","type":"uint256"}],"name":"approve","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"totalSupply","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_from","type":"address"},{"name":"_to","type":"address"},{"name":"_value","type":"uint256"}],"name":"transferFrom","outputs":[],"payable":false,"type":"function"},{"constant":false,"inputs":[],"name":"startTrading","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"decimals","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_to","type":"address"},{"name":"_amount","type":"uint256"}],"name":"mint","outputs":[{"name":"","type":"bool"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"tradingStarted","outputs":[{"name":"","type":"bool"}],"payable":false,"type":"function"},{"constant":true,"inputs":[{"name":"_owner","type":"address"}],"name":"balanceOf","outputs":[{"name":"balance","type":"uint256"}],"payable":false,"type":"function"},{"constant":false,"inputs":[],"name":"finishMinting","outputs":[{"name":"","type":"bool"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"owner","outputs":[{"name":"","type":"address"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"symbol","outputs":[{"name":"","type":"string"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_to","type":"address"},{"name":"_value","type":"uint256"}],"name":"transfer","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[{"name":"_owner","type":"address"},{"name":"_spender","type":"address"}],"name":"allowance","outputs":[{"name":"remaining","type":"uint256"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"newOwner","type":"address"}],"name":"transferOwnership","outputs":[],"payable":false,"type":"function"},{"anonymous":false,"inputs":[{"indexed":true,"name":"to","type":"address"},{"indexed":false,"name":"value","type":"uint256"}],"name":"Mint","type":"event"},{"anonymous":false,"inputs":[],"name":"MintFinished","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"name":"owner","type":"address"},{"indexed":true,"name":"spender","type":"address"},{"indexed":false,"name":"value","type":"uint256"}],"name":"Approval","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"name":"from","type":"address"},{"indexed":true,"name":"to","type":"address"},{"indexed":false,"name":"value","type":"uint256"}],"name":"Transfer","type":"event"}]
639  */
640 contract CBCToken is MintableToken {
641 
642     string public name = "Crypto Boss Coin";
643     string public symbol = "CBC";
644     uint public decimals = 18;
645 
646     bool public tradingStarted = false;
647     /**
648      * @dev modifier that throws if trading has not started yet
649      */
650     modifier hasStartedTrading() {
651         require(tradingStarted);
652         _;
653     }
654 
655 
656     /**
657      * @dev Allows the owner to enable the trading. This can not be undone
658      */
659     function startTrading() onlyOwner {
660         tradingStarted = true;
661     }
662 
663     /**
664      * @dev Allows anyone to transfer the PAY tokens once trading has started
665      * @param _to the recipient address of the tokens.
666      * @param _value number of tokens to be transfered.
667      */
668     function transfer(address _to, uint _value) hasStartedTrading {
669         super.transfer(_to, _value);
670     }
671 
672     /**
673     * @dev Allows anyone to transfer the CBC tokens once trading has started
674     * @param _from address The address which you want to send tokens from
675     * @param _to address The address which you want to transfer to
676     * @param _value uint the amout of tokens to be transfered
677     */
678     function transferFrom(address _from, address _to, uint _value) hasStartedTrading {
679         super.transferFrom(_from, _to, _value);
680     }
681 
682 }
683 
684 /**
685  * @title MainSale
686  * @dev The main CBC token sale contract
687  *
688  * ABI
689  * [{"constant":false,"inputs":[{"name":"_multisigVault","type":"address"}],"name":"setMultisigVault","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[{"name":"authorizerIndex","type":"uint256"}],"name":"getAuthorizer","outputs":[{"name":"","type":"address"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"exchangeRate","outputs":[{"name":"","type":"address"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"altDeposits","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"recipient","type":"address"},{"name":"tokens","type":"uint256"}],"name":"authorizedCreateTokens","outputs":[],"payable":false,"type":"function"},{"constant":false,"inputs":[],"name":"finishMinting","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"owner","outputs":[{"name":"","type":"address"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_exchangeRate","type":"address"}],"name":"setExchangeRate","outputs":[],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_token","type":"address"}],"name":"retrieveTokens","outputs":[],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"totalAltDeposits","type":"uint256"}],"name":"setAltDeposit","outputs":[],"payable":false,"type":"function"},{"constant":!1,"inputs":[{"name":"victim","type":"address"},{"name":"amount","type":"uint256"}],"name":"burnTokens","outputs":[],"payable":!1,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[],"name":"start","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"recipient","type":"address"}],"name":"createTokens","outputs":[],"payable":true,"type":"function"},{"constant":false,"inputs":[{"name":"_addr","type":"address"}],"name":"addAuthorized","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"multisigVault","outputs":[{"name":"","type":"address"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_hardcap","type":"uint256"}],"name":"setHardCap","outputs":[],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"newOwner","type":"address"}],"name":"transferOwnership","outputs":[],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_start","type":"uint256"}],"name":"setStart","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"token","outputs":[{"name":"","type":"address"}],"payable":false,"type":"function"},{"constant":true,"inputs":[{"name":"_addr","type":"address"}],"name":"isAuthorized","outputs":[{"name":"","type":"bool"}],"payable":false,"type":"function"},{"payable":true,"type":"fallback"},{"anonymous":false,"inputs":[{"indexed":false,"name":"recipient","type":"address"},{"indexed":false,"name":"ether_amount","type":"uint256"},{"indexed":false,"name":"pay_amount","type":"uint256"},{"indexed":false,"name":"exchangerate","type":"uint256"}],"name":"TokenSold","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"name":"recipient","type":"address"},{"indexed":false,"name":"pay_amount","type":"uint256"}],"name":"AuthorizedCreate","type":"event"},{"anonymous":false,"inputs":[],"name":"MainSaleClosed","type":"event"}]
690  */
691 contract MainSale is Ownable, Authorizable {
692     using SafeMath for uint;
693     event TokenSold(address recipient, uint ether_amount, uint pay_amount, uint exchangerate);
694     event AuthorizedCreate(address recipient, uint pay_amount);
695     event AuthorizedBurn(address receiver, uint value);
696     event AuthorizedStartTrading();
697     event MainSaleClosed();
698     CBCToken public token = new CBCToken();
699 
700     address public multisigVault;
701 
702     uint hardcap = 100000000000000 ether;
703     ExchangeRate public exchangeRate;
704 
705     uint public altDeposits = 0;
706     uint public start = 1525996800;
707 
708     /**
709      * @dev modifier to allow token creation only when the sale IS ON
710      */
711     modifier saleIsOn() {
712         require(now > start && now < start + 28 days);
713         _;
714     }
715 
716     /**
717      * @dev modifier to allow token creation only when the hardcap has not been reached
718      */
719     modifier isUnderHardCap() {
720         require(multisigVault.balance + altDeposits <= hardcap);
721         _;
722     }
723 
724     /**
725      * @dev Allows anyone to create tokens by depositing ether.
726      * @param recipient the recipient to receive tokens.
727      */
728     function createTokens(address recipient) public isUnderHardCap saleIsOn payable {
729         uint rate = exchangeRate.getRate("ETH");
730         uint tokens = rate.mul(msg.value).div(1 ether);
731         token.mint(recipient, tokens);
732         require(multisigVault.send(msg.value));
733         TokenSold(recipient, msg.value, tokens, rate);
734     }
735 
736     /**
737      * @dev Allows to set the toal alt deposit measured in ETH to make sure the hardcap includes other deposits
738      * @param totalAltDeposits total amount ETH equivalent
739      */
740     function setAltDeposit(uint totalAltDeposits) public onlyOwner {
741         altDeposits = totalAltDeposits;
742     }
743 
744     /**
745      * @dev Allows authorized acces to create tokens. This is used for Bitcoin and ERC20 deposits
746      * @param recipient the recipient to receive tokens.
747      * @param tokens number of tokens to be created.
748      */
749     function authorizedCreateTokens(address recipient, uint tokens) public onlyAuthorized {
750         token.mint(recipient, tokens);
751         AuthorizedCreate(recipient, tokens);
752     }
753 
754     function authorizedStartTrading() public onlyAuthorized {
755         token.startTrading();
756         AuthorizedStartTrading();
757     }
758 
759     /**
760      * @dev Allows authorized acces to burn tokens.
761      * @param receiver the receiver to receive tokens.
762      * @param value number of tokens to be created.
763      */
764     function authorizedBurnTokens(address receiver, uint value) public onlyAuthorized {
765         token.burn(receiver, value);
766         AuthorizedBurn(receiver, value);
767     }
768 
769     /**
770      * @dev Allows the owner to set the hardcap.
771      * @param _hardcap the new hardcap
772      */
773     function setHardCap(uint _hardcap) public onlyOwner {
774         hardcap = _hardcap;
775     }
776 
777     /**
778      * @dev Allows the owner to set the starting time.
779      * @param _start the new _start
780      */
781     function setStart(uint _start) public onlyOwner {
782         start = _start;
783     }
784 
785     /**
786      * @dev Allows the owner to set the multisig contract.
787      * @param _multisigVault the multisig contract address
788      */
789     function setMultisigVault(address _multisigVault) public onlyOwner {
790         if (_multisigVault != address(0)) {
791             multisigVault = _multisigVault;
792         }
793     }
794 
795     /**
796      * @dev Allows the owner to set the exchangerate contract.
797      * @param _exchangeRate the exchangerate address
798      */
799     function setExchangeRate(address _exchangeRate) public onlyOwner {
800         exchangeRate = ExchangeRate(_exchangeRate);
801     }
802 
803     /**
804      * @dev Allows the owner to finish the minting. This will create the
805      * restricted tokens and then close the minting.
806      * Then the ownership of the PAY token contract is transfered
807      * to this owner.
808      */
809     function finishMinting() public onlyOwner {
810         uint issuedTokenSupply = token.totalSupply();
811         uint restrictedTokens = issuedTokenSupply.mul(49).div(51);
812         token.mint(multisigVault, restrictedTokens);
813         token.finishMinting();
814         token.transferOwnership(owner);
815         MainSaleClosed();
816     }
817 
818     /**
819      * @dev Allows the owner to transfer ERC20 tokens to the multi sig vault
820      * @param _token the contract address of the ERC20 contract
821      */
822     function retrieveTokens(address _token) public onlyOwner {
823         ERC20 token = ERC20(_token);
824         token.transfer(multisigVault, token.balanceOf(this));
825     }
826 
827     /**
828      * @dev Fallback function which receives ether and created the appropriate number of tokens for the
829      * msg.sender.
830      */
831     function() external payable {
832         createTokens(msg.sender);
833     }
834 
835 }
836 
837 /**
838 * It is insurance smart-contract for the SmartContractBank.
839 * You can buy insurance for 0.1 ETH and if you do not take 100% profit when balance of
840 * the SmartContractBank will be lesser then 0.01 you can receive part of insurance fund depend on your not received money.
841 *
842 * To buy insurance:
843 * Send to the contract address 0.01 ETH, and you will be accounted to.
844 *
845 * To receive insurance payout:
846 * Send to the contract address 0 ETH, and you will receive part of insurance depend on your not received money.
847 * If you already received 100% from your deposit, you will take error.
848 */
849 contract InsuranceFund {
850     using SafeMath for uint256;
851 
852     /**
853     * @dev Structure for evaluating payout
854     * @param deposit Duplicated from SmartContractBank deposit
855     * @param withdrawals Duplicated from SmartContractBank withdrawals
856     * @param insured Flag for available payout
857     */
858     struct Investor {
859         uint256 deposit;
860         uint256 withdrawals;
861         bool insured;
862     }
863     mapping (address => Investor) public investors;
864     uint public countOfInvestors;
865 
866     bool public startOfPayments = false;
867     uint256 public totalSupply;
868 
869     uint256 public totalNotReceived;
870     address public SCBAddress;
871 
872     SmartContractBank SCBContract;
873 
874     event Paid(address investor, uint256 amount, uint256  notRecieve, uint256  partOfNotReceived);
875     event SetInfo(address investor, uint256  notRecieve, uint256 deposit, uint256 withdrawals);
876 
877     /**
878     * @dev  Modifier for access from the SmartContractBank
879     */
880     modifier onlySCB() {
881         require(msg.sender == SCBAddress, "access denied");
882         _;
883     }
884 
885     /**
886     * @dev  Setter the SmartContractBank address. Address can be set only once.
887     * @param _SCBAddress Address of the SmartContractBank
888     */
889     function setSCBAddress(address _SCBAddress) public {
890         require(SCBAddress == address(0x0));
891         SCBAddress = _SCBAddress;
892         SCBContract = SmartContractBank(SCBAddress);
893     }
894 
895     /**
896     * @dev  Private setter info about investor. Can be call if payouts not started.
897     * Needing for evaluating not received total amount without loops.
898     * @param _address Investor's address
899     * @param _address Investor's deposit
900     * @param _address Investor's withdrawals
901     */
902     function privateSetInfo(address _address, uint256 deposit, uint256 withdrawals) private{
903         if (!startOfPayments) {
904             Investor storage investor = investors[_address];
905 
906             if (investor.deposit != deposit){
907                 totalNotReceived = totalNotReceived.add(deposit.sub(investor.deposit));
908                 investor.deposit = deposit;
909             }
910 
911             if (investor.withdrawals != withdrawals){
912                 uint256 different;
913                 if (deposit <= withdrawals){
914                     different = deposit.sub(withdrawals);
915                     if (totalNotReceived >= different)
916                         totalNotReceived = totalNotReceived.sub(different);
917                     else
918                         totalNotReceived = 0;
919                 } else {
920                     different = withdrawals.sub(investor.withdrawals);
921                     if (totalNotReceived >= different)
922                         totalNotReceived = totalNotReceived.sub(different);
923                     else
924                         totalNotReceived = 0;
925                 }
926                 investor.withdrawals = withdrawals;
927             }
928 
929             emit SetInfo(_address, totalNotReceived, investor.deposit, investor.withdrawals);
930         }
931     }
932 
933     /**
934     * @dev  Setter info about investor from the SmartContractBank.
935     * @param _address Investor's address
936     * @param _address Investor's deposit
937     * @param _address Investor's withdrawals
938     */
939     function setInfo(address _address, uint256 deposit, uint256 withdrawals) public onlySCB {
940         privateSetInfo(_address, deposit, withdrawals);
941     }
942 
943     /**
944     * @dev  Delete insured from the SmartContractBank.
945     * @param _address Investor's address
946     */
947     function deleteInsured(address _address) public onlySCB {
948         Investor storage investor = investors[_address];
949         investor.deposit = 0;
950         investor.withdrawals = 0;
951         investor.insured = false;
952         countOfInvestors--;
953     }
954 
955     /**
956     * @dev  Function for starting payouts and stopping receive funds.
957     */
958     function beginOfPayments() public {
959         require(address(SCBAddress).balance < 0.1 ether && !startOfPayments);
960         startOfPayments = true;
961         totalSupply = address(this).balance;
962     }
963 
964     /**
965     * @dev  Payable function for receive funds, buying insurance and receive insurance payouts .
966     */
967     function () external payable {
968         Investor storage investor = investors[msg.sender];
969         if (msg.value > 0 ether){
970             require(!startOfPayments);
971             if (msg.sender != SCBAddress && msg.value >= 0.1 ether) {
972                 uint256 deposit;
973                 uint256 withdrawals;
974                 (deposit, withdrawals, investor.insured) = SCBContract.setInsured(msg.sender);
975                 countOfInvestors++;
976                 privateSetInfo(msg.sender, deposit, withdrawals);
977             }
978         } else if (msg.value == 0){
979             uint256 notReceived = investor.deposit.sub(investor.withdrawals);
980             uint256 partOfNotReceived = notReceived.mul(100).div(totalNotReceived);
981             uint256 payAmount = totalSupply.div(100).mul(partOfNotReceived);
982             require(startOfPayments && investor.insured && notReceived > 0);
983             investor.insured = false;
984             msg.sender.transfer(payAmount);
985             emit Paid(msg.sender, payAmount, notReceived, partOfNotReceived);
986         }
987     }
988 }