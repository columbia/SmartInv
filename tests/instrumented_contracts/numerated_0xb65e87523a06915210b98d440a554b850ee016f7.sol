1 pragma solidity 0.5.1;
2 
3 /**
4 * @dev Base contract for teams
5 */
6 contract CryptoTeam {
7     using SafeMath for uint256;
8 
9     //Developers fund
10     address payable public teamAddressOne = 0x5947D8b85c5D3f8655b136B5De5D0Dd33f8E93D9;
11     address payable public teamAddressTwo = 0xC923728AD95f71BC77186D6Fb091B3B30Ba42247;
12     address payable public teamAddressThree = 0x763BFB050F9b973Dd32693B1e2181A68508CdA54;
13 
14     Bank public BankContract;
15     CBCToken public CBCTokenContract;
16 
17     /**
18     * @dev Payable function. 10% will send to Developers fund and 90% will send to JackPot contract.
19     * Also setting info about player.
20     */
21     function () external payable {
22         require(BankContract.getState() && msg.value >= 0.05 ether);
23 
24         BankContract.setInfo(msg.sender, msg.value.mul(90).div(100));
25 
26         teamAddressOne.transfer(msg.value.mul(4).div(100));
27         teamAddressTwo.transfer(msg.value.mul(4).div(100));
28         teamAddressThree.transfer(msg.value.mul(2).div(100));
29         address(BankContract).transfer(msg.value.mul(90).div(100));
30     }
31 }
32 
33 /*
34 * @dev Bears contract. To play game with Bears send ETH to this contract
35 */
36 contract Bears is CryptoTeam {
37     constructor(address payable _bankAddress, address payable _CBCTokenAddress) public {
38         BankContract = Bank(_bankAddress);
39         BankContract.setBearsAddress(address(this));
40         CBCTokenContract = CBCToken(_CBCTokenAddress);
41         CBCTokenContract.approve(_bankAddress, 9999999999999999999000000000000000000);
42     }
43 }
44 
45 /*
46 * @dev Bulls contract. To play game with Bulls send ETH to this contract
47 */
48 contract Bulls is CryptoTeam {
49     constructor(address payable _bankAddress, address payable _CBCTokenAddress) public {
50         BankContract = Bank(_bankAddress);
51         BankContract.setBullsAddress(address(this));
52         CBCTokenContract = CBCToken(_CBCTokenAddress);
53         CBCTokenContract.approve(_bankAddress, 9999999999999999999000000000000000000);
54     }
55 }
56 
57 /*
58 * @title Bank
59 * @dev Bank contract which contained all ETH from Dragons and Hamsters teams.
60 * When time in blockchain will be grater then current deadline or last deadline need call getWinner function
61 * then participants able get prizes.
62 *
63 * Last participant(last hero) win 10% from all bank
64 *
65 * - To get prize send 0 ETH to this contract
66 */
67 contract Bank {
68 
69     using SafeMath for uint256;
70 
71     mapping (address => uint256) public depositBears;
72     mapping (address => uint256) public depositBulls;
73     uint256 public currentDeadline;
74     uint256 public lastDeadline = 1546257600;
75     uint256 public countOfBears;
76     uint256 public countOfBulls;
77     uint256 public totalSupplyOfBulls;
78     uint256 public totalSupplyOfBears;
79     uint256 public totalCBCSupplyOfBulls;
80     uint256 public totalCBCSupplyOfBears;
81     uint256 public probabilityOfBulls;
82     uint256 public probabilityOfBears;
83     address public lastHero;
84     address public lastHeroHistory;
85     uint256 public jackPot;
86     uint256 public winner;
87     bool public finished = false;
88 
89     Bears public BearsContract;
90     Bulls public BullsContract;
91     CBCToken public CBCTokenContract;
92 
93     /*
94     * @dev Constructor create first deadline
95     */
96     constructor() public {
97         currentDeadline = block.timestamp + 60 * 60 * 24 * 3;
98     }
99 
100     /**
101     * @dev Setter the CryptoBossCoin contract address. Address can be set at once.
102     * @param _CBCTokenAddress Address of the CryptoBossCoin contract
103     */
104     function setCBCTokenAddress(address _CBCTokenAddress) public {
105         require(address(CBCTokenContract) == address(0x0));
106         CBCTokenContract = CBCToken(_CBCTokenAddress);
107     }
108 
109     /**
110     * @dev Setter the Bears contract address. Address can be set at once.
111     * @param _bearsAddress Address of the Bears contract
112     */
113     function setBearsAddress(address payable _bearsAddress) external {
114         require(address(BearsContract) == address(0x0));
115         BearsContract = Bears(_bearsAddress);
116     }
117 
118     /**
119     * @dev Setter the Bulls contract address. Address can be set at once.
120     * @param _bullsAddress Address of the Bulls contract
121     */
122     function setBullsAddress(address payable _bullsAddress) external {
123         require(address(BullsContract) == address(0x0));
124         BullsContract = Bulls(_bullsAddress);
125     }
126 
127     /**
128     * @dev Getting time from blockchain for timer
129     */
130     function getNow() view public returns(uint){
131         return block.timestamp;
132     }
133 
134     /**
135     * @dev Getting state of game. True - game continue, False - game stopped
136     */
137     function getState() view public returns(bool) {
138         if (block.timestamp > currentDeadline) {
139             return false;
140         }
141         return true;
142     }
143 
144     /**
145     * @dev Setting info about participant from Bears or Bulls contract
146     * @param _lastHero Address of participant
147     * @param _deposit Amount of deposit
148     */
149     function setInfo(address _lastHero, uint256 _deposit) public {
150         require(address(BearsContract) == msg.sender || address(BullsContract) == msg.sender);
151 
152         if (address(BearsContract) == msg.sender) {
153             require(depositBulls[_lastHero] == 0, "You are already in bulls team");
154             if (depositBears[_lastHero] == 0)
155                 countOfBears++;
156             totalSupplyOfBears = totalSupplyOfBears.add(_deposit.mul(90).div(100));
157             depositBears[_lastHero] = depositBears[_lastHero].add(_deposit.mul(90).div(100));
158         }
159 
160         if (address(BullsContract) == msg.sender) {
161             require(depositBears[_lastHero] == 0, "You are already in bears team");
162             if (depositBulls[_lastHero] == 0)
163                 countOfBulls++;
164             totalSupplyOfBulls = totalSupplyOfBulls.add(_deposit.mul(90).div(100));
165             depositBulls[_lastHero] = depositBulls[_lastHero].add(_deposit.mul(90).div(100));
166         }
167 
168         lastHero = _lastHero;
169 
170         if (currentDeadline.add(120) <= lastDeadline) {
171             currentDeadline = currentDeadline.add(120);
172         } else {
173             currentDeadline = lastDeadline;
174         }
175 
176         jackPot = (address(this).balance.add(_deposit)).mul(10).div(100);
177 
178         calculateProbability();
179     }
180 
181     /**
182     * @dev Calculation probability for team's win
183     */
184     function calculateProbability() public {
185         require(winner == 0 && getState());
186 
187         totalCBCSupplyOfBulls = CBCTokenContract.balanceOf(address(BullsContract));
188         totalCBCSupplyOfBears = CBCTokenContract.balanceOf(address(BearsContract));
189         uint256 percent = (totalSupplyOfBulls.add(totalSupplyOfBears)).div(100);
190 
191         if (totalCBCSupplyOfBulls < 1 ether) {
192             totalCBCSupplyOfBulls = 0;
193         }
194 
195         if (totalCBCSupplyOfBears < 1 ether) {
196             totalCBCSupplyOfBears = 0;
197         }
198 
199         if (totalCBCSupplyOfBulls <= totalCBCSupplyOfBears) {
200             uint256 difference = totalCBCSupplyOfBears.sub(totalCBCSupplyOfBulls).div(0.01 ether);
201             probabilityOfBears = totalSupplyOfBears.mul(100).div(percent).add(difference);
202 
203             if (probabilityOfBears > 8000) {
204                 probabilityOfBears = 8000;
205             }
206             if (probabilityOfBears < 2000) {
207                 probabilityOfBears = 2000;
208             }
209             probabilityOfBulls = 10000 - probabilityOfBears;
210         } else {
211             uint256 difference = totalCBCSupplyOfBulls.sub(totalCBCSupplyOfBears).div(0.01 ether);
212             probabilityOfBulls = totalSupplyOfBulls.mul(100).div(percent).add(difference);
213 
214             if (probabilityOfBulls > 8000) {
215                 probabilityOfBulls = 8000;
216             }
217             if (probabilityOfBulls < 2000) {
218                 probabilityOfBulls = 2000;
219             }
220             probabilityOfBears = 10000 - probabilityOfBulls;
221         }
222 
223         totalCBCSupplyOfBulls = CBCTokenContract.balanceOf(address(BullsContract));
224         totalCBCSupplyOfBears = CBCTokenContract.balanceOf(address(BearsContract));
225     }
226 
227     /**
228     * @dev Getting winner team
229     */
230     function getWinners() public {
231         require(winner == 0 && !getState());
232 
233         uint256 seed1 = address(this).balance;
234         uint256 seed2 = totalSupplyOfBulls;
235         uint256 seed3 = totalSupplyOfBears;
236         uint256 seed4 = totalCBCSupplyOfBulls;
237         uint256 seed5 = totalCBCSupplyOfBulls;
238         uint256 seed6 = block.difficulty;
239         uint256 seed7 = block.timestamp;
240 
241         bytes32 randomHash = keccak256(abi.encodePacked(seed1, seed2, seed3, seed4, seed5, seed6, seed7));
242         uint randomNumber = uint(randomHash);
243 
244         if (randomNumber == 0){
245             randomNumber = 1;
246         }
247 
248         uint winningNumber = randomNumber % 10000;
249 
250         if (1 <= winningNumber && winningNumber <= probabilityOfBears){
251             winner = 1;
252         }
253 
254         if (probabilityOfBears < winningNumber && winningNumber <= 10000){
255             winner = 2;
256         }
257     }
258 
259     /**
260     * @dev Payable function for take prize
261     */
262     function () external payable {
263         if (msg.value == 0 &&  !getState() && winner > 0){
264             require(depositBears[msg.sender] > 0 || depositBulls[msg.sender] > 0);
265 
266             uint payout = 0;
267             uint payoutCBC = 0;
268 
269             if (winner == 1 && depositBears[msg.sender] > 0) {
270                 payout = calculateETHPrize(msg.sender);
271             }
272             if (winner == 2 && depositBulls[msg.sender] > 0) {
273                 payout = calculateETHPrize(msg.sender);
274             }
275 
276             if (payout > 0) {
277                 depositBears[msg.sender] = 0;
278                 depositBulls[msg.sender] = 0;
279                 msg.sender.transfer(payout);
280             }
281 
282             if ((winner == 1 && depositBears[msg.sender] == 0) || (winner == 2 && depositBulls[msg.sender] == 0)) {
283                 payoutCBC = calculateCBCPrize(msg.sender);
284                 if (CBCTokenContract.balanceOf(address(BullsContract)) > 0)
285                     CBCTokenContract.transferFrom(
286                         address(BullsContract),
287                         address(this),
288                         CBCTokenContract.balanceOf(address(BullsContract))
289                     );
290                 if (CBCTokenContract.balanceOf(address(BearsContract)) > 0)
291                     CBCTokenContract.transferFrom(
292                         address(BearsContract),
293                         address(this),
294                         CBCTokenContract.balanceOf(address(BearsContract))
295                     );
296                 CBCTokenContract.transfer(msg.sender, payoutCBC);
297             }
298 
299             if (msg.sender == lastHero) {
300                 lastHeroHistory = lastHero;
301                 lastHero = address(0x0);
302                 msg.sender.transfer(jackPot);
303             }
304         }
305     }
306 
307     /**
308     * @dev Getting ETH prize of participant
309     * @param participant Address of participant
310     */
311     function calculateETHPrize(address participant) public view returns(uint) {
312 
313         uint payout = 0;
314         uint256 totalSupply = (totalSupplyOfBears.add(totalSupplyOfBulls));
315 
316         if (depositBears[participant] > 0) {
317             payout = totalSupply.mul(depositBears[participant]).div(totalSupplyOfBears);
318         }
319 
320         if (depositBulls[participant] > 0) {
321             payout = totalSupply.mul(depositBulls[participant]).div(totalSupplyOfBulls);
322         }
323 
324         return payout;
325     }
326 
327     /**
328     * @dev Getting CBC Token prize of participant
329     * @param participant Address of participant
330     */
331     function calculateCBCPrize(address participant) public view returns(uint) {
332 
333         uint payout = 0;
334         uint totalSupply = (totalCBCSupplyOfBears.add(totalCBCSupplyOfBulls)).mul(80).div(100);
335 
336         if (depositBears[participant] > 0) {
337             payout = totalSupply.mul(depositBears[participant]).div(totalSupplyOfBears);
338         }
339 
340         if (depositBulls[participant] > 0) {
341             payout = totalSupply.mul(depositBulls[participant]).div(totalSupplyOfBulls);
342         }
343 
344         return payout;
345     }
346 }
347 
348 /**
349  * @title Ownable
350  * @dev The Ownable contract has an owner address, and provides basic authorization control
351  * functions, this simplifies the implementation of "user permissions".
352  */
353 contract Ownable {
354     address public owner;
355 
356 
357     /**
358      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
359      * account.
360      */
361     constructor() public {
362         owner = msg.sender;
363     }
364 
365 
366     /**
367      * @dev Throws if called by any account other than the owner.
368      */
369     modifier onlyOwner() {
370         require (msg.sender == owner);
371         _;
372     }
373 
374 
375     /**
376      * @dev Allows the current owner to transfer control of the contract to a newOwner.
377      * @param newOwner The address to transfer ownership to.
378      */
379     function transferOwnership(address newOwner) public onlyOwner {
380         require(newOwner != address(0));
381         owner = newOwner;
382     }
383 }
384 
385 
386 
387 /**
388  * @title Authorizable
389  * @dev Allows to authorize access to certain function calls
390  *
391  * ABI
392  * [{"constant":true,"inputs":[{"name":"authorizerIndex","type":"uint256"}],"name":"getAuthorizer","outputs":[{"name":"","type":"address"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_addr","type":"address"}],"name":"addAuthorized","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[{"name":"_addr","type":"address"}],"name":"isAuthorized","outputs":[{"name":"","type":"bool"}],"payable":false,"type":"function"},{"inputs":[],"payable":false,"type":"constructor"}]
393  */
394 contract Authorizable {
395 
396     address[] authorizers;
397     mapping(address => uint) authorizerIndex;
398 
399     /**
400      * @dev Throws if called by any account tat is not authorized.
401      */
402     modifier onlyAuthorized {
403         require(isAuthorized(msg.sender));
404         _;
405     }
406 
407     /**
408      * @dev Contructor that authorizes the msg.sender.
409      */
410     constructor() public {
411         authorizers.length = 2;
412         authorizers[1] = msg.sender;
413         authorizerIndex[msg.sender] = 1;
414     }
415 
416     /**
417      * @dev Function to get a specific authorizer
418      * @param authorizerIndex index of the authorizer to be retrieved.
419      * @return The address of the authorizer.
420      */
421     function getAuthorizer(uint authorizerIndex) external view returns(address) {
422         return address(authorizers[authorizerIndex + 1]);
423     }
424 
425     /**
426      * @dev Function to check if an address is authorized
427      * @param _addr the address to check if it is authorized.
428      * @return boolean flag if address is authorized.
429      */
430     function isAuthorized(address _addr) public view returns(bool) {
431         return authorizerIndex[_addr] > 0;
432     }
433 
434     /**
435      * @dev Function to add a new authorizer
436      * @param _addr the address to add as a new authorizer.
437      */
438     function addAuthorized(address _addr) external onlyAuthorized {
439         authorizerIndex[_addr] = authorizers.length;
440         authorizers.length++;
441         authorizers[authorizers.length - 1] = _addr;
442     }
443 
444 }
445 
446 /**
447  * @title ExchangeRate
448  * @dev Allows updating and retrieveing of Conversion Rates for PAY tokens
449  *
450  * ABI
451  * [{"constant":false,"inputs":[{"name":"_symbol","type":"string"},{"name":"_rate","type":"uint256"}],"name":"updateRate","outputs":[],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"data","type":"uint256[]"}],"name":"updateRates","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[{"name":"_symbol","type":"string"}],"name":"getRate","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"owner","outputs":[{"name":"","type":"address"}],"payable":false,"type":"function"},{"constant":true,"inputs":[{"name":"","type":"bytes32"}],"name":"rates","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"newOwner","type":"address"}],"name":"transferOwnership","outputs":[],"payable":false,"type":"function"},{"anonymous":false,"inputs":[{"indexed":false,"name":"timestamp","type":"uint256"},{"indexed":false,"name":"symbol","type":"bytes32"},{"indexed":false,"name":"rate","type":"uint256"}],"name":"RateUpdated","type":"event"}]
452  */
453 contract ExchangeRate is Ownable {
454 
455     event RateUpdated(uint timestamp, bytes32 symbol, uint rate);
456 
457     mapping(bytes32 => uint) public rates;
458 
459     /**
460      * @dev Allows the current owner to update a single rate.
461      * @param _symbol The symbol to be updated.
462      * @param _rate the rate for the symbol.
463      */
464     function updateRate(string memory _symbol, uint _rate) public onlyOwner {
465         rates[keccak256(abi.encodePacked(_symbol))] = _rate;
466         emit RateUpdated(now, keccak256(bytes(_symbol)), _rate);
467     }
468 
469     /**
470      * @dev Allows the current owner to update multiple rates.
471      * @param data an array that alternates keccak256 hashes of the symbol and the corresponding rate .
472      */
473     function updateRates(uint[] memory data) public onlyOwner {
474         require (data.length % 2 <= 0);
475         uint i = 0;
476         while (i < data.length / 2) {
477             bytes32 symbol = bytes32(data[i * 2]);
478             uint rate = data[i * 2 + 1];
479             rates[symbol] = rate;
480             emit RateUpdated(now, symbol, rate);
481             i++;
482         }
483     }
484 
485     /**
486      * @dev Allows the anyone to read the current rate.
487      * @param _symbol the symbol to be retrieved.
488      */
489     function getRate(string memory _symbol) public view returns(uint) {
490         return rates[keccak256(abi.encodePacked(_symbol))];
491     }
492 
493 }
494 
495 /**
496  * @title SafeMath
497  * @dev Math operations with safety checks that revert on error
498  */
499 library SafeMath {
500     /**
501     * @dev Multiplies two numbers, reverts on overflow.
502     */
503     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
504         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
505         // benefit is lost if 'b' is also tested.
506         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
507         if (a == 0) {
508             return 0;
509         }
510 
511         uint256 c = a * b;
512         require(c / a == b);
513 
514         return c;
515     }
516 
517     /**
518     * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
519     */
520     function div(uint256 a, uint256 b) internal pure returns (uint256) {
521         // Solidity only automatically asserts when dividing by 0
522         require(b > 0);
523         uint256 c = a / b;
524         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
525 
526         return c;
527     }
528 
529     /**
530     * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
531     */
532     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
533         require(b <= a);
534         uint256 c = a - b;
535 
536         return c;
537     }
538 
539     /**
540     * @dev Adds two numbers, reverts on overflow.
541     */
542     function add(uint256 a, uint256 b) internal pure returns (uint256) {
543         uint256 c = a + b;
544         require(c >= a);
545 
546         return c;
547     }
548 
549     /**
550     * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
551     * reverts when dividing by zero.
552     */
553     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
554         require(b != 0);
555         return a % b;
556     }
557 }
558 
559 
560 /**
561  * @title ERC20Basic
562  * @dev Simpler version of ERC20 interface
563  * @dev see https://github.com/ethereum/EIPs/issues/20
564  */
565 contract ERC20Basic {
566     uint public totalSupply;
567     function balanceOf(address who) public view returns (uint);
568     function transfer(address to, uint value) public;
569     event Transfer(address indexed from, address indexed to, uint value);
570 }
571 
572 
573 
574 
575 /**
576  * @title ERC20 interface
577  * @dev see https://github.com/ethereum/EIPs/issues/20
578  */
579 contract ERC20 is ERC20Basic {
580     function allowance(address owner, address spender) view public returns (uint);
581     function transferFrom(address from, address to, uint value) public;
582     function approve(address spender, uint value) public;
583     event Approval(address indexed owner, address indexed spender, uint value);
584 }
585 
586 
587 
588 
589 /**
590  * @title Basic token
591  * @dev Basic version of StandardToken, with no allowances.
592  */
593 contract BasicToken is ERC20Basic {
594     using SafeMath for uint;
595 
596     mapping(address => uint) balances;
597 
598     /**
599      * @dev Fix for the ERC20 short address attack.
600      */
601     modifier onlyPayloadSize(uint size) {
602         require (size + 4 <= msg.data.length);
603         _;
604     }
605 
606     /**
607     * @dev transfer token for a specified address
608     * @param _to The address to transfer to.
609     * @param _value The amount to be transferred.
610     */
611     function transfer(address _to, uint _value) public onlyPayloadSize(2 * 32) {
612         balances[msg.sender] = balances[msg.sender].sub(_value);
613         balances[_to] = balances[_to].add(_value);
614         emit Transfer(msg.sender, _to, _value);
615     }
616 
617     /**
618     * @dev Gets the balance of the specified address.
619     * @param _owner The address to query the the balance of.
620     * @return An uint representing the amount owned by the passed address.
621     */
622     function balanceOf(address _owner) view public returns (uint balance) {
623         return balances[_owner];
624     }
625 
626 }
627 
628 
629 
630 
631 /**
632  * @title Standard ERC20 token
633  *
634  * @dev Implemantation of the basic standart token.
635  * @dev https://github.com/ethereum/EIPs/issues/20
636  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
637  */
638 contract StandardToken is BasicToken, ERC20 {
639 
640     mapping (address => mapping (address => uint)) allowed;
641 
642 
643     /**
644      * @dev Transfer tokens from one address to another
645      * @param _from address The address which you want to send tokens from
646      * @param _to address The address which you want to transfer to
647      * @param _value uint the amout of tokens to be transfered
648      */
649     function transferFrom(address _from, address _to, uint _value) public onlyPayloadSize(3 * 32) {
650         uint256 _allowance = allowed[_from][msg.sender];
651 
652         // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
653         // if (_value > _allowance) throw;
654 
655         balances[_to] = balances[_to].add(_value);
656         balances[_from] = balances[_from].sub(_value);
657         allowed[_from][msg.sender] = _allowance.sub(_value);
658         emit Transfer(_from, _to, _value);
659     }
660 
661     /**
662      * @dev Aprove the passed address to spend the specified amount of tokens on beahlf of msg.sender.
663      * @param _spender The address which will spend the funds.
664      * @param _value The amount of tokens to be spent.
665      */
666     function approve(address _spender, uint _value) public {
667 
668         // To change the approve amount you first have to reduce the addresses`
669         //  allowance to zero by calling `approve(_spender, 0)` if it is not
670         //  already 0 to mitigate the race condition described here:
671         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
672         if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) revert();
673 
674         allowed[msg.sender][_spender] = _value;
675         emit Approval(msg.sender, _spender, _value);
676     }
677 
678     /**
679      * @dev Function to check the amount of tokens than an owner allowed to a spender.
680      * @param _owner address The address which owns the funds.
681      * @param _spender address The address which will spend the funds.
682      * @return A uint specifing the amount of tokens still avaible for the spender.
683      */
684     function allowance(address _owner, address _spender) view public returns (uint remaining) {
685         return allowed[_owner][_spender];
686     }
687 
688 }
689 
690 
691 /**
692  * @title Mintable token
693  * @dev Simple ERC20 Token example, with mintable token creation
694  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
695  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
696  */
697 
698 contract MintableToken is StandardToken, Ownable {
699     event Mint(address indexed to, uint value);
700     event MintFinished();
701     event Burn(address indexed burner, uint256 value);
702 
703     bool public mintingFinished = false;
704     uint public totalSupply = 0;
705 
706 
707     modifier canMint() {
708         require(!mintingFinished);
709         _;
710     }
711 
712     /**
713      * @dev Function to mint tokens
714      * @param _to The address that will recieve the minted tokens.
715      * @param _amount The amount of tokens to mint.
716      * @return A boolean that indicates if the operation was successful.
717      */
718     function mint(address _to, uint _amount) onlyOwner canMint public returns (bool) {
719         totalSupply = totalSupply.add(_amount);
720         balances[_to] = balances[_to].add(_amount);
721         emit Mint(_to, _amount);
722         return true;
723     }
724 
725     /**
726      * @dev Function to stop minting new tokens.
727      * @return True if the operation was successful.
728      */
729     function finishMinting() onlyOwner public returns (bool) {
730         mintingFinished = true;
731         emit MintFinished();
732         return true;
733     }
734 
735 
736     /**
737      * @dev Burns a specific amount of tokens.
738      * @param _value The amount of token to be burned.
739      */
740     function burn(address _who, uint256 _value) onlyOwner public {
741         _burn(_who, _value);
742     }
743 
744     function _burn(address _who, uint256 _value) internal {
745         require(_value <= balances[_who]);
746         // no need to require value <= totalSupply, since that would imply the
747         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
748 
749         balances[_who] = balances[_who].sub(_value);
750         totalSupply = totalSupply.sub(_value);
751         emit Burn(_who, _value);
752         emit Transfer(_who, address(0), _value);
753     }
754 }
755 
756 
757 /**
758  * @title CBCToken
759  * @dev The main CBC token contract
760  *
761  * ABI
762  * [{"constant":true,"inputs":[],"name":"mintingFinished","outputs":[{"name":"","type":"bool"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"name","outputs":[{"name":"","type":"string"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_spender","type":"address"},{"name":"_value","type":"uint256"}],"name":"approve","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"totalSupply","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_from","type":"address"},{"name":"_to","type":"address"},{"name":"_value","type":"uint256"}],"name":"transferFrom","outputs":[],"payable":false,"type":"function"},{"constant":false,"inputs":[],"name":"startTrading","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"decimals","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_to","type":"address"},{"name":"_amount","type":"uint256"}],"name":"mint","outputs":[{"name":"","type":"bool"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"tradingStarted","outputs":[{"name":"","type":"bool"}],"payable":false,"type":"function"},{"constant":true,"inputs":[{"name":"_owner","type":"address"}],"name":"balanceOf","outputs":[{"name":"balance","type":"uint256"}],"payable":false,"type":"function"},{"constant":false,"inputs":[],"name":"finishMinting","outputs":[{"name":"","type":"bool"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"owner","outputs":[{"name":"","type":"address"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"symbol","outputs":[{"name":"","type":"string"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_to","type":"address"},{"name":"_value","type":"uint256"}],"name":"transfer","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[{"name":"_owner","type":"address"},{"name":"_spender","type":"address"}],"name":"allowance","outputs":[{"name":"remaining","type":"uint256"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"newOwner","type":"address"}],"name":"transferOwnership","outputs":[],"payable":false,"type":"function"},{"anonymous":false,"inputs":[{"indexed":true,"name":"to","type":"address"},{"indexed":false,"name":"value","type":"uint256"}],"name":"Mint","type":"event"},{"anonymous":false,"inputs":[],"name":"MintFinished","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"name":"owner","type":"address"},{"indexed":true,"name":"spender","type":"address"},{"indexed":false,"name":"value","type":"uint256"}],"name":"Approval","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"name":"from","type":"address"},{"indexed":true,"name":"to","type":"address"},{"indexed":false,"name":"value","type":"uint256"}],"name":"Transfer","type":"event"}]
763  */
764 contract CBCToken is MintableToken {
765 
766     string public name = "Crypto Boss Coin";
767     string public symbol = "CBC";
768     uint public decimals = 18;
769 
770     bool public tradingStarted = false;
771     /**
772      * @dev modifier that throws if trading has not started yet
773      */
774     modifier hasStartedTrading() {
775         require(tradingStarted);
776         _;
777     }
778 
779 
780     /**
781      * @dev Allows the owner to enable the trading. This can not be undone
782      */
783     function startTrading() onlyOwner public {
784         tradingStarted = true;
785     }
786 
787     /**
788      * @dev Allows anyone to transfer the PAY tokens once trading has started
789      * @param _to the recipient address of the tokens.
790      * @param _value number of tokens to be transfered.
791      */
792     function transfer(address _to, uint _value) hasStartedTrading public {
793         super.transfer(_to, _value);
794     }
795 
796     /**
797     * @dev Allows anyone to transfer the CBC tokens once trading has started
798     * @param _from address The address which you want to send tokens from
799     * @param _to address The address which you want to transfer to
800     * @param _value uint the amout of tokens to be transfered
801     */
802     function transferFrom(address _from, address _to, uint _value) hasStartedTrading public{
803         super.transferFrom(_from, _to, _value);
804     }
805 
806 }
807 
808 /**
809  * @title MainSale
810  * @dev The main CBC token sale contract
811  *
812  * ABI
813  * [{"constant":false,"inputs":[{"name":"_multisigVault","type":"address"}],"name":"setMultisigVault","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[{"name":"authorizerIndex","type":"uint256"}],"name":"getAuthorizer","outputs":[{"name":"","type":"address"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"exchangeRate","outputs":[{"name":"","type":"address"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"altDeposits","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"recipient","type":"address"},{"name":"tokens","type":"uint256"}],"name":"authorizedCreateTokens","outputs":[],"payable":false,"type":"function"},{"constant":false,"inputs":[],"name":"finishMinting","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"owner","outputs":[{"name":"","type":"address"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_exchangeRate","type":"address"}],"name":"setExchangeRate","outputs":[],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_token","type":"address"}],"name":"retrieveTokens","outputs":[],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"totalAltDeposits","type":"uint256"}],"name":"setAltDeposit","outputs":[],"payable":false,"type":"function"},{"constant":!1,"inputs":[{"name":"victim","type":"address"},{"name":"amount","type":"uint256"}],"name":"burnTokens","outputs":[],"payable":!1,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[],"name":"start","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"recipient","type":"address"}],"name":"createTokens","outputs":[],"payable":true,"type":"function"},{"constant":false,"inputs":[{"name":"_addr","type":"address"}],"name":"addAuthorized","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"multisigVault","outputs":[{"name":"","type":"address"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_hardcap","type":"uint256"}],"name":"setHardCap","outputs":[],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"newOwner","type":"address"}],"name":"transferOwnership","outputs":[],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_start","type":"uint256"}],"name":"setStart","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"token","outputs":[{"name":"","type":"address"}],"payable":false,"type":"function"},{"constant":true,"inputs":[{"name":"_addr","type":"address"}],"name":"isAuthorized","outputs":[{"name":"","type":"bool"}],"payable":false,"type":"function"},{"payable":true,"type":"fallback"},{"anonymous":false,"inputs":[{"indexed":false,"name":"recipient","type":"address"},{"indexed":false,"name":"ether_amount","type":"uint256"},{"indexed":false,"name":"pay_amount","type":"uint256"},{"indexed":false,"name":"exchangerate","type":"uint256"}],"name":"TokenSold","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"name":"recipient","type":"address"},{"indexed":false,"name":"pay_amount","type":"uint256"}],"name":"AuthorizedCreate","type":"event"},{"anonymous":false,"inputs":[],"name":"MainSaleClosed","type":"event"}]
814  */
815 contract MainSale is Ownable, Authorizable {
816     using SafeMath for uint;
817     event TokenSold(address recipient, uint ether_amount, uint pay_amount, uint exchangerate);
818     event AuthorizedCreate(address recipient, uint pay_amount);
819     event AuthorizedBurn(address receiver, uint value);
820     event AuthorizedStartTrading();
821     event MainSaleClosed();
822     CBCToken public token = new CBCToken();
823 
824     address payable public multisigVault;
825 
826     uint hardcap = 100000000000000 ether;
827     ExchangeRate public exchangeRate;
828 
829     uint public altDeposits = 0;
830     uint public start = 1525996800;
831 
832     /**
833      * @dev modifier to allow token creation only when the sale IS ON
834      */
835     modifier saleIsOn() {
836         require(now > start && now < start + 28 days);
837         _;
838     }
839 
840     /**
841      * @dev modifier to allow token creation only when the hardcap has not been reached
842      */
843     modifier isUnderHardCap() {
844         require(multisigVault.balance + altDeposits <= hardcap);
845         _;
846     }
847 
848     /**
849      * @dev Allows anyone to create tokens by depositing ether.
850      * @param recipient the recipient to receive tokens.
851      */
852     function createTokens(address recipient) public isUnderHardCap saleIsOn payable {
853         uint rate = exchangeRate.getRate("ETH");
854         uint tokens = rate.mul(msg.value).div(1 ether);
855         token.mint(recipient, tokens);
856         require(multisigVault.send(msg.value));
857         emit TokenSold(recipient, msg.value, tokens, rate);
858     }
859 
860     /**
861      * @dev Allows to set the toal alt deposit measured in ETH to make sure the hardcap includes other deposits
862      * @param totalAltDeposits total amount ETH equivalent
863      */
864     function setAltDeposit(uint totalAltDeposits) public onlyOwner {
865         altDeposits = totalAltDeposits;
866     }
867 
868     /**
869      * @dev Allows authorized acces to create tokens. This is used for Bitcoin and ERC20 deposits
870      * @param recipient the recipient to receive tokens.
871      * @param tokens number of tokens to be created.
872      */
873     function authorizedCreateTokens(address recipient, uint tokens) public onlyAuthorized {
874         token.mint(recipient, tokens);
875         emit AuthorizedCreate(recipient, tokens);
876     }
877 
878     function authorizedStartTrading() public onlyAuthorized {
879         token.startTrading();
880         emit AuthorizedStartTrading();
881     }
882 
883     /**
884      * @dev Allows authorized acces to burn tokens.
885      * @param receiver the receiver to receive tokens.
886      * @param value number of tokens to be created.
887      */
888     function authorizedBurnTokens(address receiver, uint value) public onlyAuthorized {
889         token.burn(receiver, value);
890         emit AuthorizedBurn(receiver, value);
891     }
892 
893     /**
894      * @dev Allows the owner to set the hardcap.
895      * @param _hardcap the new hardcap
896      */
897     function setHardCap(uint _hardcap) public onlyOwner {
898         hardcap = _hardcap;
899     }
900 
901     /**
902      * @dev Allows the owner to set the starting time.
903      * @param _start the new _start
904      */
905     function setStart(uint _start) public onlyOwner {
906         start = _start;
907     }
908 
909     /**
910      * @dev Allows the owner to set the multisig contract.
911      * @param _multisigVault the multisig contract address
912      */
913     function setMultisigVault(address payable _multisigVault) public onlyOwner {
914         if (_multisigVault != address(0)) {
915             multisigVault = _multisigVault;
916         }
917     }
918 
919     /**
920      * @dev Allows the owner to set the exchangerate contract.
921      * @param _exchangeRate the exchangerate address
922      */
923     function setExchangeRate(address _exchangeRate) public onlyOwner {
924         exchangeRate = ExchangeRate(_exchangeRate);
925     }
926 
927     /**
928      * @dev Allows the owner to finish the minting. This will create the
929      * restricted tokens and then close the minting.
930      * Then the ownership of the PAY token contract is transfered
931      * to this owner.
932      */
933     function finishMinting() public onlyOwner {
934         uint issuedTokenSupply = token.totalSupply();
935         uint restrictedTokens = issuedTokenSupply.mul(49).div(51);
936         token.mint(multisigVault, restrictedTokens);
937         token.finishMinting();
938         token.transferOwnership(owner);
939         emit MainSaleClosed();
940     }
941 
942     /**
943      * @dev Allows the owner to transfer ERC20 tokens to the multi sig vault
944      * @param _token the contract address of the ERC20 contract
945      */
946     function retrieveTokens(address _token) public onlyOwner {
947         ERC20 token = ERC20(_token);
948         token.transfer(multisigVault, token.balanceOf(address(this)));
949     }
950 
951     /**
952      * @dev Fallback function which receives ether and created the appropriate number of tokens for the
953      * msg.sender.
954      */
955     function() external payable {
956         createTokens(msg.sender);
957     }
958 
959 }