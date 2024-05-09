1 pragma solidity 0.5.1;
2 
3 
4 /**
5 * @dev Base contract for teams
6 */
7 contract CryptoTeam {
8     using SafeMath for uint256;
9 
10     //Developers fund
11     address payable public teamAddressOne = 0x5947D8b85c5D3f8655b136B5De5D0Dd33f8E93D9;
12     address payable public teamAddressTwo = 0xC923728AD95f71BC77186D6Fb091B3B30Ba42247;
13     address payable public teamAddressThree = 0x763BFB050F9b973Dd32693B1e2181A68508CdA54;
14 
15     Bank public BankContract;
16     CBCToken public CBCTokenContract;
17 
18     /**
19     * @dev Payable function. 10% will send to Developers fund and 90% will send to JackPot contract.
20     * Also setting info about player.
21     */
22     function () external payable {
23         require(BankContract.getState() && msg.value >= 0.05 ether);
24 
25         BankContract.setInfo(msg.sender, msg.value.mul(90).div(100));
26 
27         teamAddressOne.transfer(msg.value.mul(4).div(100));
28         teamAddressTwo.transfer(msg.value.mul(4).div(100));
29         teamAddressThree.transfer(msg.value.mul(2).div(100));
30         address(BankContract).transfer(msg.value.mul(90).div(100));
31     }
32 }
33 
34 /*
35 * @dev Bears contract. To play game with Bears send ETH to this contract
36 */
37 contract Bears is CryptoTeam {
38     constructor(address payable _bankAddress, address payable _CBCTokenAddress) public {
39         BankContract = Bank(_bankAddress);
40         BankContract.setBearsAddress(address(this));
41         CBCTokenContract = CBCToken(_CBCTokenAddress);
42         CBCTokenContract.approve(_bankAddress, 9999999999999999999000000000000000000);
43     }
44 }
45 
46 /*
47 * @dev Bulls contract. To play game with Bulls send ETH to this contract
48 */
49 contract Bulls is CryptoTeam {
50     constructor(address payable _bankAddress, address payable _CBCTokenAddress) public {
51         BankContract = Bank(_bankAddress);
52         BankContract.setBullsAddress(address(this));
53         CBCTokenContract = CBCToken(_CBCTokenAddress);
54         CBCTokenContract.approve(_bankAddress, 9999999999999999999000000000000000000);
55     }
56 }
57 
58 /*
59 * @title Bank
60 * @dev Bank contract which contained all ETH from Dragons and Hamsters teams.
61 * When time in blockchain will be grater then current deadline or last deadline need call getWinner function
62 * then participants able get prizes.
63 *
64 * Last participant(last hero) win 10% from all bank
65 *
66 * - To get prize send 0 ETH to this contract
67 */
68 contract Bank {
69 
70     using SafeMath for uint256;
71 
72     mapping (address => uint256) public depositBears;
73     mapping (address => uint256) public depositBulls;
74     uint256 public currentDeadline;
75     uint256 public lastDeadline;
76     uint256 public countOfBears;
77     uint256 public countOfBulls;
78     uint256 public totalSupplyOfBulls;
79     uint256 public totalSupplyOfBears;
80     uint256 public totalCBCSupplyOfBulls;
81     uint256 public totalCBCSupplyOfBears;
82     uint256 public probabilityOfBulls;
83     uint256 public probabilityOfBears;
84     address public lastHero;
85     address public lastHeroHistory;
86     uint256 public jackPot;
87     uint256 public winner;
88     bool public finished = false;
89 
90     Bears public BearsContract;
91     Bulls public BullsContract;
92     CBCToken public CBCTokenContract;
93 
94     /*
95     * @dev Constructor create first deadline
96     */
97     constructor() public {
98         currentDeadline = block.timestamp + 60 * 60 * 24 * 3;
99         lastDeadline = block.timestamp + 60 * 60 * 24 * 7;
100     }
101 
102     /**
103     * @dev Setter the CryptoBossCoin contract address. Address can be set at once.
104     * @param _CBCTokenAddress Address of the CryptoBossCoin contract
105     */
106     function setCBCTokenAddress(address _CBCTokenAddress) public {
107         require(address(CBCTokenContract) == address(0x0));
108         CBCTokenContract = CBCToken(_CBCTokenAddress);
109     }
110 
111     /**
112     * @dev Setter the Bears contract address. Address can be set at once.
113     * @param _bearsAddress Address of the Bears contract
114     */
115     function setBearsAddress(address payable _bearsAddress) external {
116         require(address(BearsContract) == address(0x0));
117         BearsContract = Bears(_bearsAddress);
118     }
119 
120     /**
121     * @dev Setter the Bulls contract address. Address can be set at once.
122     * @param _bullsAddress Address of the Bulls contract
123     */
124     function setBullsAddress(address payable _bullsAddress) external {
125         require(address(BullsContract) == address(0x0));
126         BullsContract = Bulls(_bullsAddress);
127     }
128 
129     /**
130     * @dev Getting time from blockchain for timer
131     */
132     function getNow() view public returns(uint){
133         return block.timestamp;
134     }
135 
136     /**
137     * @dev Getting state of game. True - game continue, False - game stopped
138     */
139     function getState() view public returns(bool) {
140         if (block.timestamp > currentDeadline) {
141             return false;
142         }
143         return true;
144     }
145 
146     /**
147     * @dev Setting info about participant from Bears or Bulls contract
148     * @param _lastHero Address of participant
149     * @param _deposit Amount of deposit
150     */
151     function setInfo(address _lastHero, uint256 _deposit) public {
152         require(address(BearsContract) == msg.sender || address(BullsContract) == msg.sender);
153 
154         if (address(BearsContract) == msg.sender) {
155             require(depositBulls[_lastHero] == 0, "You are already in bulls team");
156             if (depositBears[_lastHero] == 0)
157                 countOfBears++;
158             totalSupplyOfBears = totalSupplyOfBears.add(_deposit.mul(90).div(100));
159             depositBears[_lastHero] = depositBears[_lastHero].add(_deposit.mul(90).div(100));
160         }
161 
162         if (address(BullsContract) == msg.sender) {
163             require(depositBears[_lastHero] == 0, "You are already in bears team");
164             if (depositBulls[_lastHero] == 0)
165                 countOfBulls++;
166             totalSupplyOfBulls = totalSupplyOfBulls.add(_deposit.mul(90).div(100));
167             depositBulls[_lastHero] = depositBulls[_lastHero].add(_deposit.mul(90).div(100));
168         }
169 
170         lastHero = _lastHero;
171 
172         if (currentDeadline.add(120) <= lastDeadline) {
173             currentDeadline = currentDeadline.add(120);
174         } else {
175             currentDeadline = lastDeadline;
176         }
177 
178         jackPot = (address(this).balance.add(_deposit)).mul(10).div(100);
179 
180         calculateProbability();
181     }
182 
183     /**
184     * @dev Calculation probability for team's win
185     */
186     function calculateProbability() public {
187         require(winner == 0 && getState());
188 
189         totalCBCSupplyOfBulls = CBCTokenContract.balanceOf(address(BullsContract));
190         totalCBCSupplyOfBears = CBCTokenContract.balanceOf(address(BearsContract));
191         uint256 percent = (totalSupplyOfBulls.add(totalSupplyOfBears)).div(100);
192 
193         if (totalCBCSupplyOfBulls < 1 ether) {
194             totalCBCSupplyOfBulls = 0;
195         }
196 
197         if (totalCBCSupplyOfBears < 1 ether) {
198             totalCBCSupplyOfBears = 0;
199         }
200 
201         if (totalCBCSupplyOfBulls <= totalCBCSupplyOfBears) {
202             uint256 difference = totalCBCSupplyOfBears.sub(totalCBCSupplyOfBulls).div(0.01 ether);
203             probabilityOfBears = totalSupplyOfBears.mul(100).div(percent).add(difference);
204 
205             if (probabilityOfBears > 8000) {
206                 probabilityOfBears = 8000;
207             }
208             if (probabilityOfBears < 2000) {
209                 probabilityOfBears = 2000;
210             }
211             probabilityOfBulls = 10000 - probabilityOfBears;
212         } else {
213             uint256 difference = totalCBCSupplyOfBulls.sub(totalCBCSupplyOfBears).div(0.01 ether);
214             probabilityOfBulls = totalSupplyOfBulls.mul(100).div(percent).add(difference);
215 
216             if (probabilityOfBulls > 8000) {
217                 probabilityOfBulls = 8000;
218             }
219             if (probabilityOfBulls < 2000) {
220                 probabilityOfBulls = 2000;
221             }
222             probabilityOfBears = 10000 - probabilityOfBulls;
223         }
224 
225         totalCBCSupplyOfBulls = CBCTokenContract.balanceOf(address(BullsContract));
226         totalCBCSupplyOfBears = CBCTokenContract.balanceOf(address(BearsContract));
227     }
228 
229     /**
230     * @dev Getting winner team
231     */
232     function getWinners() public {
233         require(winner == 0 && !getState());
234 
235         uint256 seed1 = address(this).balance;
236         uint256 seed2 = totalSupplyOfBulls;
237         uint256 seed3 = totalSupplyOfBears;
238         uint256 seed4 = totalCBCSupplyOfBulls;
239         uint256 seed5 = totalCBCSupplyOfBulls;
240         uint256 seed6 = block.difficulty;
241         uint256 seed7 = block.timestamp;
242 
243         bytes32 randomHash = keccak256(abi.encodePacked(seed1, seed2, seed3, seed4, seed5, seed6, seed7));
244         uint randomNumber = uint(randomHash);
245 
246         if (randomNumber == 0){
247             randomNumber = 1;
248         }
249 
250         uint winningNumber = randomNumber % 10000;
251 
252         if (1 <= winningNumber && winningNumber <= probabilityOfBears){
253             winner = 1;
254         }
255 
256         if (probabilityOfBears < winningNumber && winningNumber <= 10000){
257             winner = 2;
258         }
259     }
260 
261     /**
262     * @dev Payable function for take prize
263     */
264     function () external payable {
265         if (msg.value == 0 &&  !getState() && winner > 0){
266             require(depositBears[msg.sender] > 0 || depositBulls[msg.sender] > 0);
267 
268             uint payout = 0;
269             uint payoutCBC = 0;
270 
271             if (winner == 1 && depositBears[msg.sender] > 0) {
272                 payout = calculateETHPrize(msg.sender);
273             }
274             if (winner == 2 && depositBulls[msg.sender] > 0) {
275                 payout = calculateETHPrize(msg.sender);
276             }
277 
278             if (payout > 0) {
279                 depositBears[msg.sender] = 0;
280                 depositBulls[msg.sender] = 0;
281                 msg.sender.transfer(payout);
282             }
283 
284             if ((winner == 1 && depositBears[msg.sender] == 0) || (winner == 2 && depositBulls[msg.sender] == 0)) {
285                 payoutCBC = calculateCBCPrize(msg.sender);
286                 if (CBCTokenContract.balanceOf(address(BullsContract)) > 0)
287                     CBCTokenContract.transferFrom(
288                         address(BullsContract),
289                         address(this),
290                         CBCTokenContract.balanceOf(address(BullsContract))
291                     );
292                 if (CBCTokenContract.balanceOf(address(BearsContract)) > 0)
293                     CBCTokenContract.transferFrom(
294                         address(BearsContract),
295                         address(this),
296                         CBCTokenContract.balanceOf(address(BearsContract))
297                     );
298                 CBCTokenContract.transfer(msg.sender, payoutCBC);
299             }
300 
301             if (msg.sender == lastHero) {
302                 lastHeroHistory = lastHero;
303                 lastHero = address(0x0);
304                 msg.sender.transfer(jackPot);
305             }
306         }
307     }
308 
309     /**
310     * @dev Getting ETH prize of participant
311     * @param participant Address of participant
312     */
313     function calculateETHPrize(address participant) public view returns(uint) {
314 
315         uint payout = 0;
316         uint256 totalSupply = (totalSupplyOfBears.add(totalSupplyOfBulls));
317 
318         if (depositBears[participant] > 0) {
319             payout = totalSupply.mul(depositBears[participant]).div(totalSupplyOfBears);
320         }
321 
322         if (depositBulls[participant] > 0) {
323             payout = totalSupply.mul(depositBulls[participant]).div(totalSupplyOfBulls);
324         }
325 
326         return payout;
327     }
328 
329     /**
330     * @dev Getting CBC Token prize of participant
331     * @param participant Address of participant
332     */
333     function calculateCBCPrize(address participant) public view returns(uint) {
334 
335         uint payout = 0;
336         uint totalSupply = (totalCBCSupplyOfBears.add(totalCBCSupplyOfBulls)).mul(80).div(100);
337 
338         if (depositBears[participant] > 0) {
339             payout = totalSupply.mul(depositBears[participant]).div(totalSupplyOfBears);
340         }
341 
342         if (depositBulls[participant] > 0) {
343             payout = totalSupply.mul(depositBulls[participant]).div(totalSupplyOfBulls);
344         }
345 
346         return payout;
347     }
348 }
349 
350 /**
351  * @title Ownable
352  * @dev The Ownable contract has an owner address, and provides basic authorization control
353  * functions, this simplifies the implementation of "user permissions".
354  */
355 contract Ownable {
356     address public owner;
357 
358 
359     /**
360      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
361      * account.
362      */
363     constructor() public {
364         owner = msg.sender;
365     }
366 
367 
368     /**
369      * @dev Throws if called by any account other than the owner.
370      */
371     modifier onlyOwner() {
372         require (msg.sender == owner);
373         _;
374     }
375 
376 
377     /**
378      * @dev Allows the current owner to transfer control of the contract to a newOwner.
379      * @param newOwner The address to transfer ownership to.
380      */
381     function transferOwnership(address newOwner) public onlyOwner {
382         require(newOwner != address(0));
383         owner = newOwner;
384     }
385 }
386 
387 
388 
389 /**
390  * @title Authorizable
391  * @dev Allows to authorize access to certain function calls
392  *
393  * ABI
394  * [{"constant":true,"inputs":[{"name":"authorizerIndex","type":"uint256"}],"name":"getAuthorizer","outputs":[{"name":"","type":"address"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_addr","type":"address"}],"name":"addAuthorized","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[{"name":"_addr","type":"address"}],"name":"isAuthorized","outputs":[{"name":"","type":"bool"}],"payable":false,"type":"function"},{"inputs":[],"payable":false,"type":"constructor"}]
395  */
396 contract Authorizable {
397 
398     address[] authorizers;
399     mapping(address => uint) authorizerIndex;
400 
401     /**
402      * @dev Throws if called by any account tat is not authorized.
403      */
404     modifier onlyAuthorized {
405         require(isAuthorized(msg.sender));
406         _;
407     }
408 
409     /**
410      * @dev Contructor that authorizes the msg.sender.
411      */
412     constructor() public {
413         authorizers.length = 2;
414         authorizers[1] = msg.sender;
415         authorizerIndex[msg.sender] = 1;
416     }
417 
418     /**
419      * @dev Function to get a specific authorizer
420      * @param authorizerIndex index of the authorizer to be retrieved.
421      * @return The address of the authorizer.
422      */
423     function getAuthorizer(uint authorizerIndex) external view returns(address) {
424         return address(authorizers[authorizerIndex + 1]);
425     }
426 
427     /**
428      * @dev Function to check if an address is authorized
429      * @param _addr the address to check if it is authorized.
430      * @return boolean flag if address is authorized.
431      */
432     function isAuthorized(address _addr) public view returns(bool) {
433         return authorizerIndex[_addr] > 0;
434     }
435 
436     /**
437      * @dev Function to add a new authorizer
438      * @param _addr the address to add as a new authorizer.
439      */
440     function addAuthorized(address _addr) external onlyAuthorized {
441         authorizerIndex[_addr] = authorizers.length;
442         authorizers.length++;
443         authorizers[authorizers.length - 1] = _addr;
444     }
445 
446 }
447 
448 /**
449  * @title ExchangeRate
450  * @dev Allows updating and retrieveing of Conversion Rates for PAY tokens
451  *
452  * ABI
453  * [{"constant":false,"inputs":[{"name":"_symbol","type":"string"},{"name":"_rate","type":"uint256"}],"name":"updateRate","outputs":[],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"data","type":"uint256[]"}],"name":"updateRates","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[{"name":"_symbol","type":"string"}],"name":"getRate","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"owner","outputs":[{"name":"","type":"address"}],"payable":false,"type":"function"},{"constant":true,"inputs":[{"name":"","type":"bytes32"}],"name":"rates","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"newOwner","type":"address"}],"name":"transferOwnership","outputs":[],"payable":false,"type":"function"},{"anonymous":false,"inputs":[{"indexed":false,"name":"timestamp","type":"uint256"},{"indexed":false,"name":"symbol","type":"bytes32"},{"indexed":false,"name":"rate","type":"uint256"}],"name":"RateUpdated","type":"event"}]
454  */
455 contract ExchangeRate is Ownable {
456 
457     event RateUpdated(uint timestamp, bytes32 symbol, uint rate);
458 
459     mapping(bytes32 => uint) public rates;
460 
461     /**
462      * @dev Allows the current owner to update a single rate.
463      * @param _symbol The symbol to be updated.
464      * @param _rate the rate for the symbol.
465      */
466     function updateRate(string memory _symbol, uint _rate) public onlyOwner {
467         rates[keccak256(abi.encodePacked(_symbol))] = _rate;
468         emit RateUpdated(now, keccak256(bytes(_symbol)), _rate);
469     }
470 
471     /**
472      * @dev Allows the current owner to update multiple rates.
473      * @param data an array that alternates keccak256 hashes of the symbol and the corresponding rate .
474      */
475     function updateRates(uint[] memory data) public onlyOwner {
476         require (data.length % 2 <= 0);
477         uint i = 0;
478         while (i < data.length / 2) {
479             bytes32 symbol = bytes32(data[i * 2]);
480             uint rate = data[i * 2 + 1];
481             rates[symbol] = rate;
482             emit RateUpdated(now, symbol, rate);
483             i++;
484         }
485     }
486 
487     /**
488      * @dev Allows the anyone to read the current rate.
489      * @param _symbol the symbol to be retrieved.
490      */
491     function getRate(string memory _symbol) public view returns(uint) {
492         return rates[keccak256(abi.encodePacked(_symbol))];
493     }
494 
495 }
496 
497 /**
498  * @title SafeMath
499  * @dev Math operations with safety checks that revert on error
500  */
501 library SafeMath {
502     /**
503     * @dev Multiplies two numbers, reverts on overflow.
504     */
505     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
506         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
507         // benefit is lost if 'b' is also tested.
508         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
509         if (a == 0) {
510             return 0;
511         }
512 
513         uint256 c = a * b;
514         require(c / a == b);
515 
516         return c;
517     }
518 
519     /**
520     * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
521     */
522     function div(uint256 a, uint256 b) internal pure returns (uint256) {
523         // Solidity only automatically asserts when dividing by 0
524         require(b > 0);
525         uint256 c = a / b;
526         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
527 
528         return c;
529     }
530 
531     /**
532     * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
533     */
534     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
535         require(b <= a);
536         uint256 c = a - b;
537 
538         return c;
539     }
540 
541     /**
542     * @dev Adds two numbers, reverts on overflow.
543     */
544     function add(uint256 a, uint256 b) internal pure returns (uint256) {
545         uint256 c = a + b;
546         require(c >= a);
547 
548         return c;
549     }
550 
551     /**
552     * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
553     * reverts when dividing by zero.
554     */
555     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
556         require(b != 0);
557         return a % b;
558     }
559 }
560 
561 
562 /**
563  * @title ERC20Basic
564  * @dev Simpler version of ERC20 interface
565  * @dev see https://github.com/ethereum/EIPs/issues/20
566  */
567 contract ERC20Basic {
568     uint public totalSupply;
569     function balanceOf(address who) public view returns (uint);
570     function transfer(address to, uint value) public;
571     event Transfer(address indexed from, address indexed to, uint value);
572 }
573 
574 
575 
576 
577 /**
578  * @title ERC20 interface
579  * @dev see https://github.com/ethereum/EIPs/issues/20
580  */
581 contract ERC20 is ERC20Basic {
582     function allowance(address owner, address spender) view public returns (uint);
583     function transferFrom(address from, address to, uint value) public;
584     function approve(address spender, uint value) public;
585     event Approval(address indexed owner, address indexed spender, uint value);
586 }
587 
588 
589 
590 
591 /**
592  * @title Basic token
593  * @dev Basic version of StandardToken, with no allowances.
594  */
595 contract BasicToken is ERC20Basic {
596     using SafeMath for uint;
597 
598     mapping(address => uint) balances;
599 
600     /**
601      * @dev Fix for the ERC20 short address attack.
602      */
603     modifier onlyPayloadSize(uint size) {
604         require (size + 4 <= msg.data.length);
605         _;
606     }
607 
608     /**
609     * @dev transfer token for a specified address
610     * @param _to The address to transfer to.
611     * @param _value The amount to be transferred.
612     */
613     function transfer(address _to, uint _value) public onlyPayloadSize(2 * 32) {
614         balances[msg.sender] = balances[msg.sender].sub(_value);
615         balances[_to] = balances[_to].add(_value);
616         emit Transfer(msg.sender, _to, _value);
617     }
618 
619     /**
620     * @dev Gets the balance of the specified address.
621     * @param _owner The address to query the the balance of.
622     * @return An uint representing the amount owned by the passed address.
623     */
624     function balanceOf(address _owner) view public returns (uint balance) {
625         return balances[_owner];
626     }
627 
628 }
629 
630 
631 
632 
633 /**
634  * @title Standard ERC20 token
635  *
636  * @dev Implemantation of the basic standart token.
637  * @dev https://github.com/ethereum/EIPs/issues/20
638  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
639  */
640 contract StandardToken is BasicToken, ERC20 {
641 
642     mapping (address => mapping (address => uint)) allowed;
643 
644 
645     /**
646      * @dev Transfer tokens from one address to another
647      * @param _from address The address which you want to send tokens from
648      * @param _to address The address which you want to transfer to
649      * @param _value uint the amout of tokens to be transfered
650      */
651     function transferFrom(address _from, address _to, uint _value) public onlyPayloadSize(3 * 32) {
652         uint256 _allowance = allowed[_from][msg.sender];
653 
654         // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
655         // if (_value > _allowance) throw;
656 
657         balances[_to] = balances[_to].add(_value);
658         balances[_from] = balances[_from].sub(_value);
659         allowed[_from][msg.sender] = _allowance.sub(_value);
660         emit Transfer(_from, _to, _value);
661     }
662 
663     /**
664      * @dev Aprove the passed address to spend the specified amount of tokens on beahlf of msg.sender.
665      * @param _spender The address which will spend the funds.
666      * @param _value The amount of tokens to be spent.
667      */
668     function approve(address _spender, uint _value) public {
669 
670         // To change the approve amount you first have to reduce the addresses`
671         //  allowance to zero by calling `approve(_spender, 0)` if it is not
672         //  already 0 to mitigate the race condition described here:
673         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
674         if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) revert();
675 
676         allowed[msg.sender][_spender] = _value;
677         emit Approval(msg.sender, _spender, _value);
678     }
679 
680     /**
681      * @dev Function to check the amount of tokens than an owner allowed to a spender.
682      * @param _owner address The address which owns the funds.
683      * @param _spender address The address which will spend the funds.
684      * @return A uint specifing the amount of tokens still avaible for the spender.
685      */
686     function allowance(address _owner, address _spender) view public returns (uint remaining) {
687         return allowed[_owner][_spender];
688     }
689 
690 }
691 
692 
693 /**
694  * @title Mintable token
695  * @dev Simple ERC20 Token example, with mintable token creation
696  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
697  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
698  */
699 
700 contract MintableToken is StandardToken, Ownable {
701     event Mint(address indexed to, uint value);
702     event MintFinished();
703     event Burn(address indexed burner, uint256 value);
704 
705     bool public mintingFinished = false;
706     uint public totalSupply = 0;
707 
708 
709     modifier canMint() {
710         require(!mintingFinished);
711         _;
712     }
713 
714     /**
715      * @dev Function to mint tokens
716      * @param _to The address that will recieve the minted tokens.
717      * @param _amount The amount of tokens to mint.
718      * @return A boolean that indicates if the operation was successful.
719      */
720     function mint(address _to, uint _amount) onlyOwner canMint public returns (bool) {
721         totalSupply = totalSupply.add(_amount);
722         balances[_to] = balances[_to].add(_amount);
723         emit Mint(_to, _amount);
724         return true;
725     }
726 
727     /**
728      * @dev Function to stop minting new tokens.
729      * @return True if the operation was successful.
730      */
731     function finishMinting() onlyOwner public returns (bool) {
732         mintingFinished = true;
733         emit MintFinished();
734         return true;
735     }
736 
737 
738     /**
739      * @dev Burns a specific amount of tokens.
740      * @param _value The amount of token to be burned.
741      */
742     function burn(address _who, uint256 _value) onlyOwner public {
743         _burn(_who, _value);
744     }
745 
746     function _burn(address _who, uint256 _value) internal {
747         require(_value <= balances[_who]);
748         // no need to require value <= totalSupply, since that would imply the
749         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
750 
751         balances[_who] = balances[_who].sub(_value);
752         totalSupply = totalSupply.sub(_value);
753         emit Burn(_who, _value);
754         emit Transfer(_who, address(0), _value);
755     }
756 }
757 
758 
759 /**
760  * @title CBCToken
761  * @dev The main CBC token contract
762  *
763  * ABI
764  * [{"constant":true,"inputs":[],"name":"mintingFinished","outputs":[{"name":"","type":"bool"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"name","outputs":[{"name":"","type":"string"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_spender","type":"address"},{"name":"_value","type":"uint256"}],"name":"approve","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"totalSupply","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_from","type":"address"},{"name":"_to","type":"address"},{"name":"_value","type":"uint256"}],"name":"transferFrom","outputs":[],"payable":false,"type":"function"},{"constant":false,"inputs":[],"name":"startTrading","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"decimals","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_to","type":"address"},{"name":"_amount","type":"uint256"}],"name":"mint","outputs":[{"name":"","type":"bool"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"tradingStarted","outputs":[{"name":"","type":"bool"}],"payable":false,"type":"function"},{"constant":true,"inputs":[{"name":"_owner","type":"address"}],"name":"balanceOf","outputs":[{"name":"balance","type":"uint256"}],"payable":false,"type":"function"},{"constant":false,"inputs":[],"name":"finishMinting","outputs":[{"name":"","type":"bool"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"owner","outputs":[{"name":"","type":"address"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"symbol","outputs":[{"name":"","type":"string"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_to","type":"address"},{"name":"_value","type":"uint256"}],"name":"transfer","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[{"name":"_owner","type":"address"},{"name":"_spender","type":"address"}],"name":"allowance","outputs":[{"name":"remaining","type":"uint256"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"newOwner","type":"address"}],"name":"transferOwnership","outputs":[],"payable":false,"type":"function"},{"anonymous":false,"inputs":[{"indexed":true,"name":"to","type":"address"},{"indexed":false,"name":"value","type":"uint256"}],"name":"Mint","type":"event"},{"anonymous":false,"inputs":[],"name":"MintFinished","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"name":"owner","type":"address"},{"indexed":true,"name":"spender","type":"address"},{"indexed":false,"name":"value","type":"uint256"}],"name":"Approval","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"name":"from","type":"address"},{"indexed":true,"name":"to","type":"address"},{"indexed":false,"name":"value","type":"uint256"}],"name":"Transfer","type":"event"}]
765  */
766 contract CBCToken is MintableToken {
767 
768     string public name = "Crypto Boss Coin";
769     string public symbol = "CBC";
770     uint public decimals = 18;
771 
772     bool public tradingStarted = false;
773     /**
774      * @dev modifier that throws if trading has not started yet
775      */
776     modifier hasStartedTrading() {
777         require(tradingStarted);
778         _;
779     }
780 
781 
782     /**
783      * @dev Allows the owner to enable the trading. This can not be undone
784      */
785     function startTrading() onlyOwner public {
786         tradingStarted = true;
787     }
788 
789     /**
790      * @dev Allows anyone to transfer the PAY tokens once trading has started
791      * @param _to the recipient address of the tokens.
792      * @param _value number of tokens to be transfered.
793      */
794     function transfer(address _to, uint _value) hasStartedTrading public {
795         super.transfer(_to, _value);
796     }
797 
798     /**
799     * @dev Allows anyone to transfer the CBC tokens once trading has started
800     * @param _from address The address which you want to send tokens from
801     * @param _to address The address which you want to transfer to
802     * @param _value uint the amout of tokens to be transfered
803     */
804     function transferFrom(address _from, address _to, uint _value) hasStartedTrading public{
805         super.transferFrom(_from, _to, _value);
806     }
807 
808 }
809 
810 /**
811  * @title MainSale
812  * @dev The main CBC token sale contract
813  *
814  * ABI
815  * [{"constant":false,"inputs":[{"name":"_multisigVault","type":"address"}],"name":"setMultisigVault","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[{"name":"authorizerIndex","type":"uint256"}],"name":"getAuthorizer","outputs":[{"name":"","type":"address"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"exchangeRate","outputs":[{"name":"","type":"address"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"altDeposits","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"recipient","type":"address"},{"name":"tokens","type":"uint256"}],"name":"authorizedCreateTokens","outputs":[],"payable":false,"type":"function"},{"constant":false,"inputs":[],"name":"finishMinting","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"owner","outputs":[{"name":"","type":"address"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_exchangeRate","type":"address"}],"name":"setExchangeRate","outputs":[],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_token","type":"address"}],"name":"retrieveTokens","outputs":[],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"totalAltDeposits","type":"uint256"}],"name":"setAltDeposit","outputs":[],"payable":false,"type":"function"},{"constant":!1,"inputs":[{"name":"victim","type":"address"},{"name":"amount","type":"uint256"}],"name":"burnTokens","outputs":[],"payable":!1,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[],"name":"start","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"recipient","type":"address"}],"name":"createTokens","outputs":[],"payable":true,"type":"function"},{"constant":false,"inputs":[{"name":"_addr","type":"address"}],"name":"addAuthorized","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"multisigVault","outputs":[{"name":"","type":"address"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_hardcap","type":"uint256"}],"name":"setHardCap","outputs":[],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"newOwner","type":"address"}],"name":"transferOwnership","outputs":[],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_start","type":"uint256"}],"name":"setStart","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"token","outputs":[{"name":"","type":"address"}],"payable":false,"type":"function"},{"constant":true,"inputs":[{"name":"_addr","type":"address"}],"name":"isAuthorized","outputs":[{"name":"","type":"bool"}],"payable":false,"type":"function"},{"payable":true,"type":"fallback"},{"anonymous":false,"inputs":[{"indexed":false,"name":"recipient","type":"address"},{"indexed":false,"name":"ether_amount","type":"uint256"},{"indexed":false,"name":"pay_amount","type":"uint256"},{"indexed":false,"name":"exchangerate","type":"uint256"}],"name":"TokenSold","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"name":"recipient","type":"address"},{"indexed":false,"name":"pay_amount","type":"uint256"}],"name":"AuthorizedCreate","type":"event"},{"anonymous":false,"inputs":[],"name":"MainSaleClosed","type":"event"}]
816  */
817 contract MainSale is Ownable, Authorizable {
818     using SafeMath for uint;
819     event TokenSold(address recipient, uint ether_amount, uint pay_amount, uint exchangerate);
820     event AuthorizedCreate(address recipient, uint pay_amount);
821     event AuthorizedBurn(address receiver, uint value);
822     event AuthorizedStartTrading();
823     event MainSaleClosed();
824     CBCToken public token = new CBCToken();
825 
826     address payable public multisigVault;
827 
828     uint hardcap = 100000000000000 ether;
829     ExchangeRate public exchangeRate;
830 
831     uint public altDeposits = 0;
832     uint public start = 1525996800;
833 
834     /**
835      * @dev modifier to allow token creation only when the sale IS ON
836      */
837     modifier saleIsOn() {
838         require(now > start && now < start + 28 days);
839         _;
840     }
841 
842     /**
843      * @dev modifier to allow token creation only when the hardcap has not been reached
844      */
845     modifier isUnderHardCap() {
846         require(multisigVault.balance + altDeposits <= hardcap);
847         _;
848     }
849 
850     /**
851      * @dev Allows anyone to create tokens by depositing ether.
852      * @param recipient the recipient to receive tokens.
853      */
854     function createTokens(address recipient) public isUnderHardCap saleIsOn payable {
855         uint rate = exchangeRate.getRate("ETH");
856         uint tokens = rate.mul(msg.value).div(1 ether);
857         token.mint(recipient, tokens);
858         require(multisigVault.send(msg.value));
859         emit TokenSold(recipient, msg.value, tokens, rate);
860     }
861 
862     /**
863      * @dev Allows to set the toal alt deposit measured in ETH to make sure the hardcap includes other deposits
864      * @param totalAltDeposits total amount ETH equivalent
865      */
866     function setAltDeposit(uint totalAltDeposits) public onlyOwner {
867         altDeposits = totalAltDeposits;
868     }
869 
870     /**
871      * @dev Allows authorized acces to create tokens. This is used for Bitcoin and ERC20 deposits
872      * @param recipient the recipient to receive tokens.
873      * @param tokens number of tokens to be created.
874      */
875     function authorizedCreateTokens(address recipient, uint tokens) public onlyAuthorized {
876         token.mint(recipient, tokens);
877         emit AuthorizedCreate(recipient, tokens);
878     }
879 
880     function authorizedStartTrading() public onlyAuthorized {
881         token.startTrading();
882         emit AuthorizedStartTrading();
883     }
884 
885     /**
886      * @dev Allows authorized acces to burn tokens.
887      * @param receiver the receiver to receive tokens.
888      * @param value number of tokens to be created.
889      */
890     function authorizedBurnTokens(address receiver, uint value) public onlyAuthorized {
891         token.burn(receiver, value);
892         emit AuthorizedBurn(receiver, value);
893     }
894 
895     /**
896      * @dev Allows the owner to set the hardcap.
897      * @param _hardcap the new hardcap
898      */
899     function setHardCap(uint _hardcap) public onlyOwner {
900         hardcap = _hardcap;
901     }
902 
903     /**
904      * @dev Allows the owner to set the starting time.
905      * @param _start the new _start
906      */
907     function setStart(uint _start) public onlyOwner {
908         start = _start;
909     }
910 
911     /**
912      * @dev Allows the owner to set the multisig contract.
913      * @param _multisigVault the multisig contract address
914      */
915     function setMultisigVault(address payable _multisigVault) public onlyOwner {
916         if (_multisigVault != address(0)) {
917             multisigVault = _multisigVault;
918         }
919     }
920 
921     /**
922      * @dev Allows the owner to set the exchangerate contract.
923      * @param _exchangeRate the exchangerate address
924      */
925     function setExchangeRate(address _exchangeRate) public onlyOwner {
926         exchangeRate = ExchangeRate(_exchangeRate);
927     }
928 
929     /**
930      * @dev Allows the owner to finish the minting. This will create the
931      * restricted tokens and then close the minting.
932      * Then the ownership of the PAY token contract is transfered
933      * to this owner.
934      */
935     function finishMinting() public onlyOwner {
936         uint issuedTokenSupply = token.totalSupply();
937         uint restrictedTokens = issuedTokenSupply.mul(49).div(51);
938         token.mint(multisigVault, restrictedTokens);
939         token.finishMinting();
940         token.transferOwnership(owner);
941         emit MainSaleClosed();
942     }
943 
944     /**
945      * @dev Allows the owner to transfer ERC20 tokens to the multi sig vault
946      * @param _token the contract address of the ERC20 contract
947      */
948     function retrieveTokens(address _token) public onlyOwner {
949         ERC20 token = ERC20(_token);
950         token.transfer(multisigVault, token.balanceOf(address(this)));
951     }
952 
953     /**
954      * @dev Fallback function which receives ether and created the appropriate number of tokens for the
955      * msg.sender.
956      */
957     function() external payable {
958         createTokens(msg.sender);
959     }
960 
961 }