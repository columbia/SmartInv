1 pragma solidity 0.5.1;
2 
3 
4 /*
5 * @title Bank
6 * @dev Bank contract which contained all ETH from Dragons and Hamsters teams.
7 * When time in blockchain will be grater then current deadline or last deadline need call getWinner function
8 * then participants able get prizes.
9 *
10 * Last participant(last hero) win 10% from all bank
11 *
12 * - To get prize send 0 ETH to this contract
13 */
14 contract Bank {
15 
16     using SafeMath for uint256;
17 
18     mapping (address => uint256) public depositBears;
19     mapping (address => uint256) public depositBulls;
20     uint256 public currentDeadline;
21     uint256 public lastDeadline = 60 * 60 * 24 * 7;
22     uint256 public countOfBears;
23     uint256 public countOfBulls;
24     uint256 public totalSupplyOfBulls;
25     uint256 public totalSupplyOfBears;
26     uint256 public totalCBCSupplyOfBulls;
27     uint256 public totalCBCSupplyOfBears;
28     uint256 public probabilityOfBulls;
29     uint256 public probabilityOfBears;
30     address public lastHero;
31     address public lastHeroHistory;
32     uint256 public jackPot;
33     uint256 public winner;
34     bool public finished = false;
35 
36     Bears public BearsContract;
37     Bulls public BullsContract;
38     CBCToken public CBCTokenContract;
39 
40     /*
41     * @dev Constructor create first deadline
42     */
43     constructor() public {
44         currentDeadline = block.timestamp + 60 * 60 * 24 * 3;
45     }
46 
47     /**
48     * @dev Setter the CryptoBossCoin contract address. Address can be set at once.
49     * @param _CBCTokenAddress Address of the CryptoBossCoin contract
50     */
51     function setCBCTokenAddress(address _CBCTokenAddress) public {
52         require(address(CBCTokenContract) == address(0x0));
53         CBCTokenContract = CBCToken(_CBCTokenAddress);
54     }
55 
56     /**
57     * @dev Setter the Bears contract address. Address can be set at once.
58     * @param _bearsAddress Address of the Bears contract
59     */
60     function setBearsAddress(address payable _bearsAddress) external {
61         require(address(BearsContract) == address(0x0));
62         BearsContract = Bears(_bearsAddress);
63     }
64 
65     /**
66     * @dev Setter the Bulls contract address. Address can be set at once.
67     * @param _bullsAddress Address of the Bulls contract
68     */
69     function setBullsAddress(address payable _bullsAddress) external {
70         require(address(BullsContract) == address(0x0));
71         BullsContract = Bulls(_bullsAddress);
72     }
73 
74     /**
75     * @dev Getting time from blockchain for timer
76     */
77     function getNow() view public returns(uint){
78         return block.timestamp;
79     }
80 
81     /**
82     * @dev Getting state of game. True - game continue, False - game stopped
83     */
84     function getState() view public returns(bool) {
85         if (block.timestamp > currentDeadline) {
86             return false;
87         }
88         return true;
89     }
90 
91     /**
92     * @dev Setting info about participant from Bears or Bulls contract
93     * @param _lastHero Address of participant
94     * @param _deposit Amount of deposit
95     */
96     function setInfo(address _lastHero, uint256 _deposit) public {
97         require(address(BearsContract) == msg.sender || address(BullsContract) == msg.sender);
98 
99         if (address(BearsContract) == msg.sender) {
100             require(depositBulls[_lastHero] == 0, "You are already in bulls team");
101             if (depositBears[_lastHero] == 0)
102                 countOfBears++;
103             totalSupplyOfBears = totalSupplyOfBears.add(_deposit.mul(90).div(100));
104             depositBears[_lastHero] = depositBears[_lastHero].add(_deposit.mul(90).div(100));
105         }
106 
107         if (address(BullsContract) == msg.sender) {
108             require(depositBears[_lastHero] == 0, "You are already in bears team");
109             if (depositBulls[_lastHero] == 0)
110                 countOfBulls++;
111             totalSupplyOfBulls = totalSupplyOfBulls.add(_deposit.mul(90).div(100));
112             depositBulls[_lastHero] = depositBulls[_lastHero].add(_deposit.mul(90).div(100));
113         }
114 
115         lastHero = _lastHero;
116 
117         if (currentDeadline.add(120) <= lastDeadline) {
118             currentDeadline = currentDeadline.add(120);
119         } else {
120             currentDeadline = lastDeadline;
121         }
122 
123         jackPot = (address(this).balance.add(_deposit)).mul(10).div(100);
124 
125         calculateProbability();
126     }
127 
128     /**
129     * @dev Calculation probability for team's win
130     */
131     function calculateProbability() public {
132         require(winner == 0 && getState());
133 
134         totalCBCSupplyOfBulls = CBCTokenContract.balanceOf(address(BullsContract));
135         totalCBCSupplyOfBears = CBCTokenContract.balanceOf(address(BearsContract));
136         uint256 percent = (totalSupplyOfBulls.add(totalSupplyOfBears)).div(100);
137 
138         if (totalCBCSupplyOfBulls < 1 ether) {
139             totalCBCSupplyOfBulls = 0;
140         }
141 
142         if (totalCBCSupplyOfBears < 1 ether) {
143             totalCBCSupplyOfBears = 0;
144         }
145 
146         if (totalCBCSupplyOfBulls <= totalCBCSupplyOfBears) {
147             uint256 difference = totalCBCSupplyOfBears.sub(totalCBCSupplyOfBulls).div(0.01 ether);
148             probabilityOfBears = totalSupplyOfBears.mul(100).div(percent).add(difference);
149 
150             if (probabilityOfBears > 8000) {
151                 probabilityOfBears = 8000;
152             }
153             if (probabilityOfBears < 2000) {
154                 probabilityOfBears = 2000;
155             }
156             probabilityOfBulls = 10000 - probabilityOfBears;
157         } else {
158             uint256 difference = totalCBCSupplyOfBulls.sub(totalCBCSupplyOfBears).div(0.01 ether);
159             probabilityOfBulls = totalSupplyOfBulls.mul(100).div(percent).add(difference);
160 
161             if (probabilityOfBulls > 8000) {
162                 probabilityOfBulls = 8000;
163             }
164             if (probabilityOfBulls < 2000) {
165                 probabilityOfBulls = 2000;
166             }
167             probabilityOfBears = 10000 - probabilityOfBulls;
168         }
169 
170         totalCBCSupplyOfBulls = CBCTokenContract.balanceOf(address(BullsContract));
171         totalCBCSupplyOfBears = CBCTokenContract.balanceOf(address(BearsContract));
172     }
173 
174     /**
175     * @dev Getting winner team
176     */
177     function getWinners() public {
178         require(winner == 0 && !getState());
179 
180         uint256 seed1 = address(this).balance;
181         uint256 seed2 = totalSupplyOfBulls;
182         uint256 seed3 = totalSupplyOfBears;
183         uint256 seed4 = totalCBCSupplyOfBulls;
184         uint256 seed5 = totalCBCSupplyOfBulls;
185         uint256 seed6 = block.difficulty;
186         uint256 seed7 = block.timestamp;
187 
188         bytes32 randomHash = keccak256(abi.encodePacked(seed1, seed2, seed3, seed4, seed5, seed6, seed7));
189         uint randomNumber = uint(randomHash);
190 
191         if (randomNumber == 0){
192             randomNumber = 1;
193         }
194 
195         uint winningNumber = randomNumber % 10000;
196 
197         if (1 <= winningNumber && winningNumber <= probabilityOfBears){
198             winner = 1;
199         }
200 
201         if (probabilityOfBears < winningNumber && winningNumber <= 10000){
202             winner = 2;
203         }
204     }
205 
206     /**
207     * @dev Payable function for take prize
208     */
209     function () external payable {
210         if (msg.value == 0 &&  !getState() && winner > 0){
211             require(depositBears[msg.sender] > 0 || depositBulls[msg.sender] > 0);
212 
213             uint payout = 0;
214             uint payoutCBC = 0;
215 
216             if (winner == 1 && depositBears[msg.sender] > 0) {
217                 payout = calculateETHPrize(msg.sender);
218             }
219             if (winner == 2 && depositBulls[msg.sender] > 0) {
220                 payout = calculateETHPrize(msg.sender);
221             }
222 
223             if (payout > 0) {
224                 depositBears[msg.sender] = 0;
225                 depositBulls[msg.sender] = 0;
226                 msg.sender.transfer(payout);
227             }
228 
229             if ((winner == 1 && depositBears[msg.sender] == 0) || (winner == 2 && depositBulls[msg.sender] == 0)) {
230                 payoutCBC = calculateCBCPrize(msg.sender);
231                 if (CBCTokenContract.balanceOf(address(BullsContract)) > 0)
232                     CBCTokenContract.transferFrom(
233                         address(BullsContract),
234                         address(this),
235                         CBCTokenContract.balanceOf(address(BullsContract))
236                     );
237                 if (CBCTokenContract.balanceOf(address(BearsContract)) > 0)
238                     CBCTokenContract.transferFrom(
239                         address(BearsContract),
240                         address(this),
241                         CBCTokenContract.balanceOf(address(BearsContract))
242                     );
243                 CBCTokenContract.transfer(msg.sender, payoutCBC);
244             }
245 
246             if (msg.sender == lastHero) {
247                 lastHeroHistory = lastHero;
248                 lastHero = address(0x0);
249                 msg.sender.transfer(jackPot);
250             }
251         }
252     }
253 
254     /**
255     * @dev Getting ETH prize of participant
256     * @param participant Address of participant
257     */
258     function calculateETHPrize(address participant) public view returns(uint) {
259 
260         uint payout = 0;
261         uint256 totalSupply = (totalSupplyOfBears.add(totalSupplyOfBulls));
262 
263         if (depositBears[participant] > 0) {
264             payout = totalSupply.mul(depositBears[participant]).div(totalSupplyOfBears);
265         }
266 
267         if (depositBulls[participant] > 0) {
268             payout = totalSupply.mul(depositBulls[participant]).div(totalSupplyOfBulls);
269         }
270 
271         return payout;
272     }
273 
274     /**
275     * @dev Getting CBC Token prize of participant
276     * @param participant Address of participant
277     */
278     function calculateCBCPrize(address participant) public view returns(uint) {
279 
280         uint payout = 0;
281         uint totalSupply = (totalCBCSupplyOfBears.add(totalCBCSupplyOfBulls)).mul(80).div(100);
282 
283         if (depositBears[participant] > 0) {
284             payout = totalSupply.mul(depositBears[participant]).div(totalSupplyOfBears);
285         }
286 
287         if (depositBulls[participant] > 0) {
288             payout = totalSupply.mul(depositBulls[participant]).div(totalSupplyOfBulls);
289         }
290 
291         return payout;
292     }
293 }
294 
295 /**
296 * @dev Base contract for teams
297 */
298 contract CryptoTeam {
299     using SafeMath for uint256;
300 
301     //Developers fund
302     address payable public teamAddressOne = 0x5947D8b85c5D3f8655b136B5De5D0Dd33f8E93D9;
303     address payable public teamAddressTwo = 0xC923728AD95f71BC77186D6Fb091B3B30Ba42247;
304     address payable public teamAddressThree = 0x763BFB050F9b973Dd32693B1e2181A68508CdA54;
305 
306     Bank public BankContract;
307     CBCToken public CBCTokenContract;
308 
309     /**
310     * @dev Payable function. 10% will send to Developers fund and 90% will send to JackPot contract.
311     * Also setting info about player.
312     */
313     function () external payable {
314         require(BankContract.getState() && msg.value >= 0.05 ether);
315 
316         BankContract.setInfo(msg.sender, msg.value.mul(90).div(100));
317 
318         teamAddressOne.transfer(msg.value.mul(4).div(100));
319         teamAddressTwo.transfer(msg.value.mul(4).div(100));
320         teamAddressThree.transfer(msg.value.mul(2).div(100));
321         address(BankContract).transfer(msg.value.mul(90).div(100));
322     }
323 }
324 
325 /*
326 * @dev Bears contract. To play game with Bears send ETH to this contract
327 */
328 contract Bears is CryptoTeam {
329     constructor(address payable _bankAddress, address payable _CBCTokenAddress) public {
330         BankContract = Bank(_bankAddress);
331         BankContract.setBearsAddress(address(this));
332         CBCTokenContract = CBCToken(_CBCTokenAddress);
333         CBCTokenContract.approve(_bankAddress, 9999999999999999999000000000000000000);
334     }
335 }
336 
337 /*
338 * @dev Bulls contract. To play game with Bulls send ETH to this contract
339 */
340 contract Bulls is CryptoTeam {
341     constructor(address payable _bankAddress, address payable _CBCTokenAddress) public {
342         BankContract = Bank(_bankAddress);
343         BankContract.setBullsAddress(address(this));
344         CBCTokenContract = CBCToken(_CBCTokenAddress);
345         CBCTokenContract.approve(_bankAddress, 9999999999999999999000000000000000000);
346     }
347 }
348 
349 
350 
351 /**
352  * @title Ownable
353  * @dev The Ownable contract has an owner address, and provides basic authorization control
354  * functions, this simplifies the implementation of "user permissions".
355  */
356 contract Ownable {
357     address public owner;
358 
359 
360     /**
361      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
362      * account.
363      */
364     constructor() public {
365         owner = msg.sender;
366     }
367 
368 
369     /**
370      * @dev Throws if called by any account other than the owner.
371      */
372     modifier onlyOwner() {
373         require (msg.sender == owner);
374         _;
375     }
376 
377 
378     /**
379      * @dev Allows the current owner to transfer control of the contract to a newOwner.
380      * @param newOwner The address to transfer ownership to.
381      */
382     function transferOwnership(address newOwner) public onlyOwner {
383         require(newOwner != address(0));
384         owner = newOwner;
385     }
386 }
387 
388 
389 
390 /**
391  * @title Authorizable
392  * @dev Allows to authorize access to certain function calls
393  *
394  * ABI
395  * [{"constant":true,"inputs":[{"name":"authorizerIndex","type":"uint256"}],"name":"getAuthorizer","outputs":[{"name":"","type":"address"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_addr","type":"address"}],"name":"addAuthorized","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[{"name":"_addr","type":"address"}],"name":"isAuthorized","outputs":[{"name":"","type":"bool"}],"payable":false,"type":"function"},{"inputs":[],"payable":false,"type":"constructor"}]
396  */
397 contract Authorizable {
398 
399     address[] authorizers;
400     mapping(address => uint) authorizerIndex;
401 
402     /**
403      * @dev Throws if called by any account tat is not authorized.
404      */
405     modifier onlyAuthorized {
406         require(isAuthorized(msg.sender));
407         _;
408     }
409 
410     /**
411      * @dev Contructor that authorizes the msg.sender.
412      */
413     constructor() public {
414         authorizers.length = 2;
415         authorizers[1] = msg.sender;
416         authorizerIndex[msg.sender] = 1;
417     }
418 
419     /**
420      * @dev Function to get a specific authorizer
421      * @param authorizerIndex index of the authorizer to be retrieved.
422      * @return The address of the authorizer.
423      */
424     function getAuthorizer(uint authorizerIndex) external view returns(address) {
425         return address(authorizers[authorizerIndex + 1]);
426     }
427 
428     /**
429      * @dev Function to check if an address is authorized
430      * @param _addr the address to check if it is authorized.
431      * @return boolean flag if address is authorized.
432      */
433     function isAuthorized(address _addr) public view returns(bool) {
434         return authorizerIndex[_addr] > 0;
435     }
436 
437     /**
438      * @dev Function to add a new authorizer
439      * @param _addr the address to add as a new authorizer.
440      */
441     function addAuthorized(address _addr) external onlyAuthorized {
442         authorizerIndex[_addr] = authorizers.length;
443         authorizers.length++;
444         authorizers[authorizers.length - 1] = _addr;
445     }
446 
447 }
448 
449 /**
450  * @title ExchangeRate
451  * @dev Allows updating and retrieveing of Conversion Rates for PAY tokens
452  *
453  * ABI
454  * [{"constant":false,"inputs":[{"name":"_symbol","type":"string"},{"name":"_rate","type":"uint256"}],"name":"updateRate","outputs":[],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"data","type":"uint256[]"}],"name":"updateRates","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[{"name":"_symbol","type":"string"}],"name":"getRate","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"owner","outputs":[{"name":"","type":"address"}],"payable":false,"type":"function"},{"constant":true,"inputs":[{"name":"","type":"bytes32"}],"name":"rates","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"newOwner","type":"address"}],"name":"transferOwnership","outputs":[],"payable":false,"type":"function"},{"anonymous":false,"inputs":[{"indexed":false,"name":"timestamp","type":"uint256"},{"indexed":false,"name":"symbol","type":"bytes32"},{"indexed":false,"name":"rate","type":"uint256"}],"name":"RateUpdated","type":"event"}]
455  */
456 contract ExchangeRate is Ownable {
457 
458     event RateUpdated(uint timestamp, bytes32 symbol, uint rate);
459 
460     mapping(bytes32 => uint) public rates;
461 
462     /**
463      * @dev Allows the current owner to update a single rate.
464      * @param _symbol The symbol to be updated.
465      * @param _rate the rate for the symbol.
466      */
467     function updateRate(string memory _symbol, uint _rate) public onlyOwner {
468         rates[keccak256(abi.encodePacked(_symbol))] = _rate;
469         emit RateUpdated(now, keccak256(bytes(_symbol)), _rate);
470     }
471 
472     /**
473      * @dev Allows the current owner to update multiple rates.
474      * @param data an array that alternates keccak256 hashes of the symbol and the corresponding rate .
475      */
476     function updateRates(uint[] memory data) public onlyOwner {
477         require (data.length % 2 <= 0);
478         uint i = 0;
479         while (i < data.length / 2) {
480             bytes32 symbol = bytes32(data[i * 2]);
481             uint rate = data[i * 2 + 1];
482             rates[symbol] = rate;
483             emit RateUpdated(now, symbol, rate);
484             i++;
485         }
486     }
487 
488     /**
489      * @dev Allows the anyone to read the current rate.
490      * @param _symbol the symbol to be retrieved.
491      */
492     function getRate(string memory _symbol) public view returns(uint) {
493         return rates[keccak256(abi.encodePacked(_symbol))];
494     }
495 
496 }
497 
498 /**
499  * @title SafeMath
500  * @dev Math operations with safety checks that revert on error
501  */
502 library SafeMath {
503     /**
504     * @dev Multiplies two numbers, reverts on overflow.
505     */
506     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
507         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
508         // benefit is lost if 'b' is also tested.
509         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
510         if (a == 0) {
511             return 0;
512         }
513 
514         uint256 c = a * b;
515         require(c / a == b);
516 
517         return c;
518     }
519 
520     /**
521     * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
522     */
523     function div(uint256 a, uint256 b) internal pure returns (uint256) {
524         // Solidity only automatically asserts when dividing by 0
525         require(b > 0);
526         uint256 c = a / b;
527         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
528 
529         return c;
530     }
531 
532     /**
533     * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
534     */
535     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
536         require(b <= a);
537         uint256 c = a - b;
538 
539         return c;
540     }
541 
542     /**
543     * @dev Adds two numbers, reverts on overflow.
544     */
545     function add(uint256 a, uint256 b) internal pure returns (uint256) {
546         uint256 c = a + b;
547         require(c >= a);
548 
549         return c;
550     }
551 
552     /**
553     * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
554     * reverts when dividing by zero.
555     */
556     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
557         require(b != 0);
558         return a % b;
559     }
560 }
561 
562 
563 /**
564  * @title ERC20Basic
565  * @dev Simpler version of ERC20 interface
566  * @dev see https://github.com/ethereum/EIPs/issues/20
567  */
568 contract ERC20Basic {
569     uint public totalSupply;
570     function balanceOf(address who) public view returns (uint);
571     function transfer(address to, uint value) public;
572     event Transfer(address indexed from, address indexed to, uint value);
573 }
574 
575 
576 
577 
578 /**
579  * @title ERC20 interface
580  * @dev see https://github.com/ethereum/EIPs/issues/20
581  */
582 contract ERC20 is ERC20Basic {
583     function allowance(address owner, address spender) view public returns (uint);
584     function transferFrom(address from, address to, uint value) public;
585     function approve(address spender, uint value) public;
586     event Approval(address indexed owner, address indexed spender, uint value);
587 }
588 
589 
590 
591 
592 /**
593  * @title Basic token
594  * @dev Basic version of StandardToken, with no allowances.
595  */
596 contract BasicToken is ERC20Basic {
597     using SafeMath for uint;
598 
599     mapping(address => uint) balances;
600 
601     /**
602      * @dev Fix for the ERC20 short address attack.
603      */
604     modifier onlyPayloadSize(uint size) {
605         require (size + 4 <= msg.data.length);
606         _;
607     }
608 
609     /**
610     * @dev transfer token for a specified address
611     * @param _to The address to transfer to.
612     * @param _value The amount to be transferred.
613     */
614     function transfer(address _to, uint _value) public onlyPayloadSize(2 * 32) {
615         balances[msg.sender] = balances[msg.sender].sub(_value);
616         balances[_to] = balances[_to].add(_value);
617         emit Transfer(msg.sender, _to, _value);
618     }
619 
620     /**
621     * @dev Gets the balance of the specified address.
622     * @param _owner The address to query the the balance of.
623     * @return An uint representing the amount owned by the passed address.
624     */
625     function balanceOf(address _owner) view public returns (uint balance) {
626         return balances[_owner];
627     }
628 
629 }
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