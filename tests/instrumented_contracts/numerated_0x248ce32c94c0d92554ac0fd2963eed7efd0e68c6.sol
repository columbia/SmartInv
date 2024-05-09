1 pragma solidity 0.5.1;
2 
3 /*
4 * @title Bank
5 * @dev Bank contract which contained all ETH from Dragons and Hamsters teams.
6 * When time in blockchain will be grater then current deadline or last deadline need call getWinner function
7 * then participants able get prizes.
8 *
9 * Last participant(last hero) win 10% from all bank
10 *
11 * - To get prize send 0 ETH to this contract
12 */
13 contract Bank {
14 
15     using SafeMath for uint256;
16 
17     mapping (address => uint256) public depositBears;
18     mapping (address => uint256) public depositBulls;
19     uint256 public currentDeadline;
20     uint256 public lastDeadline = 1546257600;
21     uint256 public countOfBears;
22     uint256 public countOfBulls;
23     uint256 public totalSupplyOfBulls;
24     uint256 public totalSupplyOfBears;
25     uint256 public totalCBCSupplyOfBulls;
26     uint256 public totalCBCSupplyOfBears;
27     uint256 public probabilityOfBulls;
28     uint256 public probabilityOfBears;
29     address public lastHero;
30     address public lastHeroHistory;
31     uint256 public jackPot;
32     uint256 public winner;
33     bool public finished = false;
34 
35     Bears public BearsContract;
36     Bulls public BullsContract;
37     CBCToken public CBCTokenContract;
38 
39     /*
40     * @dev Constructor create first deadline
41     */
42     constructor() public {
43         currentDeadline = block.timestamp + 60 * 60 * 24 * 3;
44     }
45 
46     /**
47     * @dev Setter the CryptoBossCoin contract address. Address can be set at once.
48     * @param _CBCTokenAddress Address of the CryptoBossCoin contract
49     */
50     function setCBCTokenAddress(address _CBCTokenAddress) public {
51         require(address(CBCTokenContract) == address(0x0));
52         CBCTokenContract = CBCToken(_CBCTokenAddress);
53     }
54 
55     /**
56     * @dev Setter the Bears contract address. Address can be set at once.
57     * @param _bearsAddress Address of the Bears contract
58     */
59     function setBearsAddress(address payable _bearsAddress) external {
60         require(address(BearsContract) == address(0x0));
61         BearsContract = Bears(_bearsAddress);
62     }
63 
64     /**
65     * @dev Setter the Bulls contract address. Address can be set at once.
66     * @param _bullsAddress Address of the Bulls contract
67     */
68     function setBullsAddress(address payable _bullsAddress) external {
69         require(address(BullsContract) == address(0x0));
70         BullsContract = Bulls(_bullsAddress);
71     }
72 
73     /**
74     * @dev Getting time from blockchain for timer
75     */
76     function getNow() view public returns(uint){
77         return block.timestamp;
78     }
79 
80     /**
81     * @dev Getting state of game. True - game continue, False - game stopped
82     */
83     function getState() view public returns(bool) {
84         if (block.timestamp > currentDeadline) {
85             return false;
86         }
87         return true;
88     }
89 
90     /**
91     * @dev Setting info about participant from Bears or Bulls contract
92     * @param _lastHero Address of participant
93     * @param _deposit Amount of deposit
94     */
95     function setInfo(address _lastHero, uint256 _deposit) public {
96         require(address(BearsContract) == msg.sender || address(BullsContract) == msg.sender);
97 
98         if (address(BearsContract) == msg.sender) {
99             require(depositBulls[_lastHero] == 0, "You are already in bulls team");
100             if (depositBears[_lastHero] == 0)
101                 countOfBears++;
102             totalSupplyOfBears = totalSupplyOfBears.add(_deposit.mul(90).div(100));
103             depositBears[_lastHero] = depositBears[_lastHero].add(_deposit.mul(90).div(100));
104         }
105 
106         if (address(BullsContract) == msg.sender) {
107             require(depositBears[_lastHero] == 0, "You are already in bears team");
108             if (depositBulls[_lastHero] == 0)
109                 countOfBulls++;
110             totalSupplyOfBulls = totalSupplyOfBulls.add(_deposit.mul(90).div(100));
111             depositBulls[_lastHero] = depositBulls[_lastHero].add(_deposit.mul(90).div(100));
112         }
113 
114         lastHero = _lastHero;
115 
116         if (currentDeadline.add(120) <= lastDeadline) {
117             currentDeadline = currentDeadline.add(120);
118         } else {
119             currentDeadline = lastDeadline;
120         }
121 
122         jackPot = (address(this).balance.add(_deposit)).mul(10).div(100);
123 
124         calculateProbability();
125     }
126 
127     /**
128     * @dev Calculation probability for team's win
129     */
130     function calculateProbability() public {
131         require(winner == 0 && getState());
132 
133         totalCBCSupplyOfBulls = CBCTokenContract.balanceOf(address(BullsContract));
134         totalCBCSupplyOfBears = CBCTokenContract.balanceOf(address(BearsContract));
135         uint256 percent = (totalSupplyOfBulls.add(totalSupplyOfBears)).div(100);
136 
137         if (totalCBCSupplyOfBulls < 1 ether) {
138             totalCBCSupplyOfBulls = 0;
139         }
140 
141         if (totalCBCSupplyOfBears < 1 ether) {
142             totalCBCSupplyOfBears = 0;
143         }
144 
145         if (totalCBCSupplyOfBulls <= totalCBCSupplyOfBears) {
146             uint256 difference = totalCBCSupplyOfBears.sub(totalCBCSupplyOfBulls).div(0.01 ether);
147             probabilityOfBears = totalSupplyOfBears.mul(100).div(percent).add(difference);
148 
149             if (probabilityOfBears > 8000) {
150                 probabilityOfBears = 8000;
151             }
152             if (probabilityOfBears < 2000) {
153                 probabilityOfBears = 2000;
154             }
155             probabilityOfBulls = 10000 - probabilityOfBears;
156         } else {
157             uint256 difference = totalCBCSupplyOfBulls.sub(totalCBCSupplyOfBears).div(0.01 ether);
158             probabilityOfBulls = totalSupplyOfBulls.mul(100).div(percent).add(difference);
159 
160             if (probabilityOfBulls > 8000) {
161                 probabilityOfBulls = 8000;
162             }
163             if (probabilityOfBulls < 2000) {
164                 probabilityOfBulls = 2000;
165             }
166             probabilityOfBears = 10000 - probabilityOfBulls;
167         }
168 
169         totalCBCSupplyOfBulls = CBCTokenContract.balanceOf(address(BullsContract));
170         totalCBCSupplyOfBears = CBCTokenContract.balanceOf(address(BearsContract));
171     }
172 
173     /**
174     * @dev Getting winner team
175     */
176     function getWinners() public {
177         require(winner == 0 && !getState());
178 
179         uint256 seed1 = address(this).balance;
180         uint256 seed2 = totalSupplyOfBulls;
181         uint256 seed3 = totalSupplyOfBears;
182         uint256 seed4 = totalCBCSupplyOfBulls;
183         uint256 seed5 = totalCBCSupplyOfBulls;
184         uint256 seed6 = block.difficulty;
185         uint256 seed7 = block.timestamp;
186 
187         bytes32 randomHash = keccak256(abi.encodePacked(seed1, seed2, seed3, seed4, seed5, seed6, seed7));
188         uint randomNumber = uint(randomHash);
189 
190         if (randomNumber == 0){
191             randomNumber = 1;
192         }
193 
194         uint winningNumber = randomNumber % 10000;
195 
196         if (1 <= winningNumber && winningNumber <= probabilityOfBears){
197             winner = 1;
198         }
199 
200         if (probabilityOfBears < winningNumber && winningNumber <= 10000){
201             winner = 2;
202         }
203     }
204 
205     /**
206     * @dev Payable function for take prize
207     */
208     function () external payable {
209         if (msg.value == 0 &&  !getState() && winner > 0){
210             require(depositBears[msg.sender] > 0 || depositBulls[msg.sender] > 0);
211 
212             uint payout = 0;
213             uint payoutCBC = 0;
214 
215             if (winner == 1 && depositBears[msg.sender] > 0) {
216                 payout = calculateETHPrize(msg.sender);
217             }
218             if (winner == 2 && depositBulls[msg.sender] > 0) {
219                 payout = calculateETHPrize(msg.sender);
220             }
221 
222             if (payout > 0) {
223                 depositBears[msg.sender] = 0;
224                 depositBulls[msg.sender] = 0;
225                 msg.sender.transfer(payout);
226             }
227 
228             if ((winner == 1 && depositBears[msg.sender] == 0) || (winner == 2 && depositBulls[msg.sender] == 0)) {
229                 payoutCBC = calculateCBCPrize(msg.sender);
230                 if (CBCTokenContract.balanceOf(address(BullsContract)) > 0)
231                     CBCTokenContract.transferFrom(
232                         address(BullsContract),
233                         address(this),
234                         CBCTokenContract.balanceOf(address(BullsContract))
235                     );
236                 if (CBCTokenContract.balanceOf(address(BearsContract)) > 0)
237                     CBCTokenContract.transferFrom(
238                         address(BearsContract),
239                         address(this),
240                         CBCTokenContract.balanceOf(address(BearsContract))
241                     );
242                 CBCTokenContract.transfer(msg.sender, payoutCBC);
243             }
244 
245             if (msg.sender == lastHero) {
246                 lastHeroHistory = lastHero;
247                 lastHero = address(0x0);
248                 msg.sender.transfer(jackPot);
249             }
250         }
251     }
252 
253     /**
254     * @dev Getting ETH prize of participant
255     * @param participant Address of participant
256     */
257     function calculateETHPrize(address participant) public view returns(uint) {
258 
259         uint payout = 0;
260         uint256 totalSupply = (totalSupplyOfBears.add(totalSupplyOfBulls));
261 
262         if (depositBears[participant] > 0) {
263             payout = totalSupply.mul(depositBears[participant]).div(totalSupplyOfBears);
264         }
265 
266         if (depositBulls[participant] > 0) {
267             payout = totalSupply.mul(depositBulls[participant]).div(totalSupplyOfBulls);
268         }
269 
270         return payout;
271     }
272 
273     /**
274     * @dev Getting CBC Token prize of participant
275     * @param participant Address of participant
276     */
277     function calculateCBCPrize(address participant) public view returns(uint) {
278 
279         uint payout = 0;
280         uint totalSupply = (totalCBCSupplyOfBears.add(totalCBCSupplyOfBulls)).mul(80).div(100);
281 
282         if (depositBears[participant] > 0) {
283             payout = totalSupply.mul(depositBears[participant]).div(totalSupplyOfBears);
284         }
285 
286         if (depositBulls[participant] > 0) {
287             payout = totalSupply.mul(depositBulls[participant]).div(totalSupplyOfBulls);
288         }
289 
290         return payout;
291     }
292 }
293 
294 /**
295 * @dev Base contract for teams
296 */
297 contract CryptoTeam {
298     using SafeMath for uint256;
299 
300     //Developers fund
301     address payable public teamAddressOne = 0x5947D8b85c5D3f8655b136B5De5D0Dd33f8E93D9;
302     address payable public teamAddressTwo = 0xC923728AD95f71BC77186D6Fb091B3B30Ba42247;
303     address payable public teamAddressThree = 0x763BFB050F9b973Dd32693B1e2181A68508CdA54;
304 
305     Bank public BankContract;
306     CBCToken public CBCTokenContract;
307 
308     /**
309     * @dev Payable function. 10% will send to Developers fund and 90% will send to JackPot contract.
310     * Also setting info about player.
311     */
312     function () external payable {
313         require(BankContract.getState() && msg.value >= 0.05 ether);
314 
315         BankContract.setInfo(msg.sender, msg.value.mul(90).div(100));
316 
317         teamAddressOne.transfer(msg.value.mul(4).div(100));
318         teamAddressTwo.transfer(msg.value.mul(4).div(100));
319         teamAddressThree.transfer(msg.value.mul(2).div(100));
320         address(BankContract).transfer(msg.value.mul(90).div(100));
321     }
322 }
323 
324 /*
325 * @dev Bears contract. To play game with Bears send ETH to this contract
326 */
327 contract Bears is CryptoTeam {
328     constructor(address payable _bankAddress, address payable _CBCTokenAddress) public {
329         BankContract = Bank(_bankAddress);
330         BankContract.setBearsAddress(address(this));
331         CBCTokenContract = CBCToken(_CBCTokenAddress);
332         CBCTokenContract.approve(_bankAddress, 9999999999999999999000000000000000000);
333     }
334 }
335 
336 /*
337 * @dev Bulls contract. To play game with Bulls send ETH to this contract
338 */
339 contract Bulls is CryptoTeam {
340     constructor(address payable _bankAddress, address payable _CBCTokenAddress) public {
341         BankContract = Bank(_bankAddress);
342         BankContract.setBullsAddress(address(this));
343         CBCTokenContract = CBCToken(_CBCTokenAddress);
344         CBCTokenContract.approve(_bankAddress, 9999999999999999999000000000000000000);
345     }
346 }
347 
348 
349 /**
350  * @title Ownable
351  * @dev The Ownable contract has an owner address, and provides basic authorization control
352  * functions, this simplifies the implementation of "user permissions".
353  */
354 contract Ownable {
355     address public owner;
356 
357 
358     /**
359      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
360      * account.
361      */
362     constructor() public {
363         owner = msg.sender;
364     }
365 
366 
367     /**
368      * @dev Throws if called by any account other than the owner.
369      */
370     modifier onlyOwner() {
371         require (msg.sender == owner);
372         _;
373     }
374 
375 
376     /**
377      * @dev Allows the current owner to transfer control of the contract to a newOwner.
378      * @param newOwner The address to transfer ownership to.
379      */
380     function transferOwnership(address newOwner) public onlyOwner {
381         require(newOwner != address(0));
382         owner = newOwner;
383     }
384 }
385 
386 
387 
388 /**
389  * @title Authorizable
390  * @dev Allows to authorize access to certain function calls
391  *
392  * ABI
393  * [{"constant":true,"inputs":[{"name":"authorizerIndex","type":"uint256"}],"name":"getAuthorizer","outputs":[{"name":"","type":"address"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_addr","type":"address"}],"name":"addAuthorized","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[{"name":"_addr","type":"address"}],"name":"isAuthorized","outputs":[{"name":"","type":"bool"}],"payable":false,"type":"function"},{"inputs":[],"payable":false,"type":"constructor"}]
394  */
395 contract Authorizable {
396 
397     address[] authorizers;
398     mapping(address => uint) authorizerIndex;
399 
400     /**
401      * @dev Throws if called by any account tat is not authorized.
402      */
403     modifier onlyAuthorized {
404         require(isAuthorized(msg.sender));
405         _;
406     }
407 
408     /**
409      * @dev Contructor that authorizes the msg.sender.
410      */
411     constructor() public {
412         authorizers.length = 2;
413         authorizers[1] = msg.sender;
414         authorizerIndex[msg.sender] = 1;
415     }
416 
417     /**
418      * @dev Function to get a specific authorizer
419      * @param authorizerIndex index of the authorizer to be retrieved.
420      * @return The address of the authorizer.
421      */
422     function getAuthorizer(uint authorizerIndex) external view returns(address) {
423         return address(authorizers[authorizerIndex + 1]);
424     }
425 
426     /**
427      * @dev Function to check if an address is authorized
428      * @param _addr the address to check if it is authorized.
429      * @return boolean flag if address is authorized.
430      */
431     function isAuthorized(address _addr) public view returns(bool) {
432         return authorizerIndex[_addr] > 0;
433     }
434 
435     /**
436      * @dev Function to add a new authorizer
437      * @param _addr the address to add as a new authorizer.
438      */
439     function addAuthorized(address _addr) external onlyAuthorized {
440         authorizerIndex[_addr] = authorizers.length;
441         authorizers.length++;
442         authorizers[authorizers.length - 1] = _addr;
443     }
444 
445 }
446 
447 /**
448  * @title ExchangeRate
449  * @dev Allows updating and retrieveing of Conversion Rates for PAY tokens
450  *
451  * ABI
452  * [{"constant":false,"inputs":[{"name":"_symbol","type":"string"},{"name":"_rate","type":"uint256"}],"name":"updateRate","outputs":[],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"data","type":"uint256[]"}],"name":"updateRates","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[{"name":"_symbol","type":"string"}],"name":"getRate","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"owner","outputs":[{"name":"","type":"address"}],"payable":false,"type":"function"},{"constant":true,"inputs":[{"name":"","type":"bytes32"}],"name":"rates","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"newOwner","type":"address"}],"name":"transferOwnership","outputs":[],"payable":false,"type":"function"},{"anonymous":false,"inputs":[{"indexed":false,"name":"timestamp","type":"uint256"},{"indexed":false,"name":"symbol","type":"bytes32"},{"indexed":false,"name":"rate","type":"uint256"}],"name":"RateUpdated","type":"event"}]
453  */
454 contract ExchangeRate is Ownable {
455 
456     event RateUpdated(uint timestamp, bytes32 symbol, uint rate);
457 
458     mapping(bytes32 => uint) public rates;
459 
460     /**
461      * @dev Allows the current owner to update a single rate.
462      * @param _symbol The symbol to be updated.
463      * @param _rate the rate for the symbol.
464      */
465     function updateRate(string memory _symbol, uint _rate) public onlyOwner {
466         rates[keccak256(abi.encodePacked(_symbol))] = _rate;
467         emit RateUpdated(now, keccak256(bytes(_symbol)), _rate);
468     }
469 
470     /**
471      * @dev Allows the current owner to update multiple rates.
472      * @param data an array that alternates keccak256 hashes of the symbol and the corresponding rate .
473      */
474     function updateRates(uint[] memory data) public onlyOwner {
475         require (data.length % 2 <= 0);
476         uint i = 0;
477         while (i < data.length / 2) {
478             bytes32 symbol = bytes32(data[i * 2]);
479             uint rate = data[i * 2 + 1];
480             rates[symbol] = rate;
481             emit RateUpdated(now, symbol, rate);
482             i++;
483         }
484     }
485 
486     /**
487      * @dev Allows the anyone to read the current rate.
488      * @param _symbol the symbol to be retrieved.
489      */
490     function getRate(string memory _symbol) public view returns(uint) {
491         return rates[keccak256(abi.encodePacked(_symbol))];
492     }
493 
494 }
495 
496 /**
497  * @title SafeMath
498  * @dev Math operations with safety checks that revert on error
499  */
500 library SafeMath {
501     /**
502     * @dev Multiplies two numbers, reverts on overflow.
503     */
504     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
505         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
506         // benefit is lost if 'b' is also tested.
507         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
508         if (a == 0) {
509             return 0;
510         }
511 
512         uint256 c = a * b;
513         require(c / a == b);
514 
515         return c;
516     }
517 
518     /**
519     * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
520     */
521     function div(uint256 a, uint256 b) internal pure returns (uint256) {
522         // Solidity only automatically asserts when dividing by 0
523         require(b > 0);
524         uint256 c = a / b;
525         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
526 
527         return c;
528     }
529 
530     /**
531     * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
532     */
533     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
534         require(b <= a);
535         uint256 c = a - b;
536 
537         return c;
538     }
539 
540     /**
541     * @dev Adds two numbers, reverts on overflow.
542     */
543     function add(uint256 a, uint256 b) internal pure returns (uint256) {
544         uint256 c = a + b;
545         require(c >= a);
546 
547         return c;
548     }
549 
550     /**
551     * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
552     * reverts when dividing by zero.
553     */
554     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
555         require(b != 0);
556         return a % b;
557     }
558 }
559 
560 
561 /**
562  * @title ERC20Basic
563  * @dev Simpler version of ERC20 interface
564  * @dev see https://github.com/ethereum/EIPs/issues/20
565  */
566 contract ERC20Basic {
567     uint public totalSupply;
568     function balanceOf(address who) public view returns (uint);
569     function transfer(address to, uint value) public;
570     event Transfer(address indexed from, address indexed to, uint value);
571 }
572 
573 
574 
575 
576 /**
577  * @title ERC20 interface
578  * @dev see https://github.com/ethereum/EIPs/issues/20
579  */
580 contract ERC20 is ERC20Basic {
581     function allowance(address owner, address spender) view public returns (uint);
582     function transferFrom(address from, address to, uint value) public;
583     function approve(address spender, uint value) public;
584     event Approval(address indexed owner, address indexed spender, uint value);
585 }
586 
587 
588 
589 
590 /**
591  * @title Basic token
592  * @dev Basic version of StandardToken, with no allowances.
593  */
594 contract BasicToken is ERC20Basic {
595     using SafeMath for uint;
596 
597     mapping(address => uint) balances;
598 
599     /**
600      * @dev Fix for the ERC20 short address attack.
601      */
602     modifier onlyPayloadSize(uint size) {
603         require (size + 4 <= msg.data.length);
604         _;
605     }
606 
607     /**
608     * @dev transfer token for a specified address
609     * @param _to The address to transfer to.
610     * @param _value The amount to be transferred.
611     */
612     function transfer(address _to, uint _value) public onlyPayloadSize(2 * 32) {
613         balances[msg.sender] = balances[msg.sender].sub(_value);
614         balances[_to] = balances[_to].add(_value);
615         emit Transfer(msg.sender, _to, _value);
616     }
617 
618     /**
619     * @dev Gets the balance of the specified address.
620     * @param _owner The address to query the the balance of.
621     * @return An uint representing the amount owned by the passed address.
622     */
623     function balanceOf(address _owner) view public returns (uint balance) {
624         return balances[_owner];
625     }
626 
627 }
628 
629 
630 
631 
632 /**
633  * @title Standard ERC20 token
634  *
635  * @dev Implemantation of the basic standart token.
636  * @dev https://github.com/ethereum/EIPs/issues/20
637  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
638  */
639 contract StandardToken is BasicToken, ERC20 {
640 
641     mapping (address => mapping (address => uint)) allowed;
642 
643 
644     /**
645      * @dev Transfer tokens from one address to another
646      * @param _from address The address which you want to send tokens from
647      * @param _to address The address which you want to transfer to
648      * @param _value uint the amout of tokens to be transfered
649      */
650     function transferFrom(address _from, address _to, uint _value) public onlyPayloadSize(3 * 32) {
651         uint256 _allowance = allowed[_from][msg.sender];
652 
653         // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
654         // if (_value > _allowance) throw;
655 
656         balances[_to] = balances[_to].add(_value);
657         balances[_from] = balances[_from].sub(_value);
658         allowed[_from][msg.sender] = _allowance.sub(_value);
659         emit Transfer(_from, _to, _value);
660     }
661 
662     /**
663      * @dev Aprove the passed address to spend the specified amount of tokens on beahlf of msg.sender.
664      * @param _spender The address which will spend the funds.
665      * @param _value The amount of tokens to be spent.
666      */
667     function approve(address _spender, uint _value) public {
668 
669         // To change the approve amount you first have to reduce the addresses`
670         //  allowance to zero by calling `approve(_spender, 0)` if it is not
671         //  already 0 to mitigate the race condition described here:
672         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
673         if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) revert();
674 
675         allowed[msg.sender][_spender] = _value;
676         emit Approval(msg.sender, _spender, _value);
677     }
678 
679     /**
680      * @dev Function to check the amount of tokens than an owner allowed to a spender.
681      * @param _owner address The address which owns the funds.
682      * @param _spender address The address which will spend the funds.
683      * @return A uint specifing the amount of tokens still avaible for the spender.
684      */
685     function allowance(address _owner, address _spender) view public returns (uint remaining) {
686         return allowed[_owner][_spender];
687     }
688 
689 }
690 
691 
692 /**
693  * @title Mintable token
694  * @dev Simple ERC20 Token example, with mintable token creation
695  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
696  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
697  */
698 
699 contract MintableToken is StandardToken, Ownable {
700     event Mint(address indexed to, uint value);
701     event MintFinished();
702     event Burn(address indexed burner, uint256 value);
703 
704     bool public mintingFinished = false;
705     uint public totalSupply = 0;
706 
707 
708     modifier canMint() {
709         require(!mintingFinished);
710         _;
711     }
712 
713     /**
714      * @dev Function to mint tokens
715      * @param _to The address that will recieve the minted tokens.
716      * @param _amount The amount of tokens to mint.
717      * @return A boolean that indicates if the operation was successful.
718      */
719     function mint(address _to, uint _amount) onlyOwner canMint public returns (bool) {
720         totalSupply = totalSupply.add(_amount);
721         balances[_to] = balances[_to].add(_amount);
722         emit Mint(_to, _amount);
723         return true;
724     }
725 
726     /**
727      * @dev Function to stop minting new tokens.
728      * @return True if the operation was successful.
729      */
730     function finishMinting() onlyOwner public returns (bool) {
731         mintingFinished = true;
732         emit MintFinished();
733         return true;
734     }
735 
736 
737     /**
738      * @dev Burns a specific amount of tokens.
739      * @param _value The amount of token to be burned.
740      */
741     function burn(address _who, uint256 _value) onlyOwner public {
742         _burn(_who, _value);
743     }
744 
745     function _burn(address _who, uint256 _value) internal {
746         require(_value <= balances[_who]);
747         // no need to require value <= totalSupply, since that would imply the
748         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
749 
750         balances[_who] = balances[_who].sub(_value);
751         totalSupply = totalSupply.sub(_value);
752         emit Burn(_who, _value);
753         emit Transfer(_who, address(0), _value);
754     }
755 }
756 
757 
758 /**
759  * @title CBCToken
760  * @dev The main CBC token contract
761  *
762  * ABI
763  * [{"constant":true,"inputs":[],"name":"mintingFinished","outputs":[{"name":"","type":"bool"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"name","outputs":[{"name":"","type":"string"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_spender","type":"address"},{"name":"_value","type":"uint256"}],"name":"approve","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"totalSupply","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_from","type":"address"},{"name":"_to","type":"address"},{"name":"_value","type":"uint256"}],"name":"transferFrom","outputs":[],"payable":false,"type":"function"},{"constant":false,"inputs":[],"name":"startTrading","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"decimals","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_to","type":"address"},{"name":"_amount","type":"uint256"}],"name":"mint","outputs":[{"name":"","type":"bool"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"tradingStarted","outputs":[{"name":"","type":"bool"}],"payable":false,"type":"function"},{"constant":true,"inputs":[{"name":"_owner","type":"address"}],"name":"balanceOf","outputs":[{"name":"balance","type":"uint256"}],"payable":false,"type":"function"},{"constant":false,"inputs":[],"name":"finishMinting","outputs":[{"name":"","type":"bool"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"owner","outputs":[{"name":"","type":"address"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"symbol","outputs":[{"name":"","type":"string"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_to","type":"address"},{"name":"_value","type":"uint256"}],"name":"transfer","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[{"name":"_owner","type":"address"},{"name":"_spender","type":"address"}],"name":"allowance","outputs":[{"name":"remaining","type":"uint256"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"newOwner","type":"address"}],"name":"transferOwnership","outputs":[],"payable":false,"type":"function"},{"anonymous":false,"inputs":[{"indexed":true,"name":"to","type":"address"},{"indexed":false,"name":"value","type":"uint256"}],"name":"Mint","type":"event"},{"anonymous":false,"inputs":[],"name":"MintFinished","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"name":"owner","type":"address"},{"indexed":true,"name":"spender","type":"address"},{"indexed":false,"name":"value","type":"uint256"}],"name":"Approval","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"name":"from","type":"address"},{"indexed":true,"name":"to","type":"address"},{"indexed":false,"name":"value","type":"uint256"}],"name":"Transfer","type":"event"}]
764  */
765 contract CBCToken is MintableToken {
766 
767     string public name = "Crypto Boss Coin";
768     string public symbol = "CBC";
769     uint public decimals = 18;
770 
771     bool public tradingStarted = false;
772     /**
773      * @dev modifier that throws if trading has not started yet
774      */
775     modifier hasStartedTrading() {
776         require(tradingStarted);
777         _;
778     }
779 
780 
781     /**
782      * @dev Allows the owner to enable the trading. This can not be undone
783      */
784     function startTrading() onlyOwner public {
785         tradingStarted = true;
786     }
787 
788     /**
789      * @dev Allows anyone to transfer the PAY tokens once trading has started
790      * @param _to the recipient address of the tokens.
791      * @param _value number of tokens to be transfered.
792      */
793     function transfer(address _to, uint _value) hasStartedTrading public {
794         super.transfer(_to, _value);
795     }
796 
797     /**
798     * @dev Allows anyone to transfer the CBC tokens once trading has started
799     * @param _from address The address which you want to send tokens from
800     * @param _to address The address which you want to transfer to
801     * @param _value uint the amout of tokens to be transfered
802     */
803     function transferFrom(address _from, address _to, uint _value) hasStartedTrading public{
804         super.transferFrom(_from, _to, _value);
805     }
806 
807 }
808 
809 /**
810  * @title MainSale
811  * @dev The main CBC token sale contract
812  *
813  * ABI
814  * [{"constant":false,"inputs":[{"name":"_multisigVault","type":"address"}],"name":"setMultisigVault","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[{"name":"authorizerIndex","type":"uint256"}],"name":"getAuthorizer","outputs":[{"name":"","type":"address"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"exchangeRate","outputs":[{"name":"","type":"address"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"altDeposits","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"recipient","type":"address"},{"name":"tokens","type":"uint256"}],"name":"authorizedCreateTokens","outputs":[],"payable":false,"type":"function"},{"constant":false,"inputs":[],"name":"finishMinting","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"owner","outputs":[{"name":"","type":"address"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_exchangeRate","type":"address"}],"name":"setExchangeRate","outputs":[],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_token","type":"address"}],"name":"retrieveTokens","outputs":[],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"totalAltDeposits","type":"uint256"}],"name":"setAltDeposit","outputs":[],"payable":false,"type":"function"},{"constant":!1,"inputs":[{"name":"victim","type":"address"},{"name":"amount","type":"uint256"}],"name":"burnTokens","outputs":[],"payable":!1,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[],"name":"start","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"recipient","type":"address"}],"name":"createTokens","outputs":[],"payable":true,"type":"function"},{"constant":false,"inputs":[{"name":"_addr","type":"address"}],"name":"addAuthorized","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"multisigVault","outputs":[{"name":"","type":"address"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_hardcap","type":"uint256"}],"name":"setHardCap","outputs":[],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"newOwner","type":"address"}],"name":"transferOwnership","outputs":[],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_start","type":"uint256"}],"name":"setStart","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"token","outputs":[{"name":"","type":"address"}],"payable":false,"type":"function"},{"constant":true,"inputs":[{"name":"_addr","type":"address"}],"name":"isAuthorized","outputs":[{"name":"","type":"bool"}],"payable":false,"type":"function"},{"payable":true,"type":"fallback"},{"anonymous":false,"inputs":[{"indexed":false,"name":"recipient","type":"address"},{"indexed":false,"name":"ether_amount","type":"uint256"},{"indexed":false,"name":"pay_amount","type":"uint256"},{"indexed":false,"name":"exchangerate","type":"uint256"}],"name":"TokenSold","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"name":"recipient","type":"address"},{"indexed":false,"name":"pay_amount","type":"uint256"}],"name":"AuthorizedCreate","type":"event"},{"anonymous":false,"inputs":[],"name":"MainSaleClosed","type":"event"}]
815  */
816 contract MainSale is Ownable, Authorizable {
817     using SafeMath for uint;
818     event TokenSold(address recipient, uint ether_amount, uint pay_amount, uint exchangerate);
819     event AuthorizedCreate(address recipient, uint pay_amount);
820     event AuthorizedBurn(address receiver, uint value);
821     event AuthorizedStartTrading();
822     event MainSaleClosed();
823     CBCToken public token = new CBCToken();
824 
825     address payable public multisigVault;
826 
827     uint hardcap = 100000000000000 ether;
828     ExchangeRate public exchangeRate;
829 
830     uint public altDeposits = 0;
831     uint public start = 1525996800;
832 
833     /**
834      * @dev modifier to allow token creation only when the sale IS ON
835      */
836     modifier saleIsOn() {
837         require(now > start && now < start + 28 days);
838         _;
839     }
840 
841     /**
842      * @dev modifier to allow token creation only when the hardcap has not been reached
843      */
844     modifier isUnderHardCap() {
845         require(multisigVault.balance + altDeposits <= hardcap);
846         _;
847     }
848 
849     /**
850      * @dev Allows anyone to create tokens by depositing ether.
851      * @param recipient the recipient to receive tokens.
852      */
853     function createTokens(address recipient) public isUnderHardCap saleIsOn payable {
854         uint rate = exchangeRate.getRate("ETH");
855         uint tokens = rate.mul(msg.value).div(1 ether);
856         token.mint(recipient, tokens);
857         require(multisigVault.send(msg.value));
858         emit TokenSold(recipient, msg.value, tokens, rate);
859     }
860 
861     /**
862      * @dev Allows to set the toal alt deposit measured in ETH to make sure the hardcap includes other deposits
863      * @param totalAltDeposits total amount ETH equivalent
864      */
865     function setAltDeposit(uint totalAltDeposits) public onlyOwner {
866         altDeposits = totalAltDeposits;
867     }
868 
869     /**
870      * @dev Allows authorized acces to create tokens. This is used for Bitcoin and ERC20 deposits
871      * @param recipient the recipient to receive tokens.
872      * @param tokens number of tokens to be created.
873      */
874     function authorizedCreateTokens(address recipient, uint tokens) public onlyAuthorized {
875         token.mint(recipient, tokens);
876         emit AuthorizedCreate(recipient, tokens);
877     }
878 
879     function authorizedStartTrading() public onlyAuthorized {
880         token.startTrading();
881         emit AuthorizedStartTrading();
882     }
883 
884     /**
885      * @dev Allows authorized acces to burn tokens.
886      * @param receiver the receiver to receive tokens.
887      * @param value number of tokens to be created.
888      */
889     function authorizedBurnTokens(address receiver, uint value) public onlyAuthorized {
890         token.burn(receiver, value);
891         emit AuthorizedBurn(receiver, value);
892     }
893 
894     /**
895      * @dev Allows the owner to set the hardcap.
896      * @param _hardcap the new hardcap
897      */
898     function setHardCap(uint _hardcap) public onlyOwner {
899         hardcap = _hardcap;
900     }
901 
902     /**
903      * @dev Allows the owner to set the starting time.
904      * @param _start the new _start
905      */
906     function setStart(uint _start) public onlyOwner {
907         start = _start;
908     }
909 
910     /**
911      * @dev Allows the owner to set the multisig contract.
912      * @param _multisigVault the multisig contract address
913      */
914     function setMultisigVault(address payable _multisigVault) public onlyOwner {
915         if (_multisigVault != address(0)) {
916             multisigVault = _multisigVault;
917         }
918     }
919 
920     /**
921      * @dev Allows the owner to set the exchangerate contract.
922      * @param _exchangeRate the exchangerate address
923      */
924     function setExchangeRate(address _exchangeRate) public onlyOwner {
925         exchangeRate = ExchangeRate(_exchangeRate);
926     }
927 
928     /**
929      * @dev Allows the owner to finish the minting. This will create the
930      * restricted tokens and then close the minting.
931      * Then the ownership of the PAY token contract is transfered
932      * to this owner.
933      */
934     function finishMinting() public onlyOwner {
935         uint issuedTokenSupply = token.totalSupply();
936         uint restrictedTokens = issuedTokenSupply.mul(49).div(51);
937         token.mint(multisigVault, restrictedTokens);
938         token.finishMinting();
939         token.transferOwnership(owner);
940         emit MainSaleClosed();
941     }
942 
943     /**
944      * @dev Allows the owner to transfer ERC20 tokens to the multi sig vault
945      * @param _token the contract address of the ERC20 contract
946      */
947     function retrieveTokens(address _token) public onlyOwner {
948         ERC20 token = ERC20(_token);
949         token.transfer(multisigVault, token.balanceOf(address(this)));
950     }
951 
952     /**
953      * @dev Fallback function which receives ether and created the appropriate number of tokens for the
954      * msg.sender.
955      */
956     function() external payable {
957         createTokens(msg.sender);
958     }
959 
960 }