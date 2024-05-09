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
58 
59 /*
60 * @title Bank
61 * @dev Bank contract which contained all ETH from Dragons and Hamsters teams.
62 * When time in blockchain will be grater then current deadline or last deadline need call getWinner function
63 * then participants able get prizes.
64 *
65 * Last participant(last hero) win 10% from all bank
66 *
67 * - To get prize send 0 ETH to this contract
68 */
69 contract Bank {
70 
71     using SafeMath for uint256;
72 
73     mapping (address => uint256) public depositBears;
74     mapping (address => uint256) public depositBulls;
75     uint256 public currentDeadline;
76     uint256 public lastDeadline = 60 * 60 * 24 * 7;
77     uint256 public countOfBears;
78     uint256 public countOfBulls;
79     uint256 public totalSupplyOfBulls;
80     uint256 public totalSupplyOfBears;
81     uint256 public totalCBCSupplyOfBulls;
82     uint256 public totalCBCSupplyOfBears;
83     uint256 public probabilityOfBulls;
84     uint256 public probabilityOfBears;
85     address public lastHero;
86     address public lastHeroHistory;
87     uint256 public jackPot;
88     uint256 public winner;
89     bool public finished = false;
90 
91     Bears public BearsContract;
92     Bulls public BullsContract;
93     CBCToken public CBCTokenContract;
94 
95     /*
96     * @dev Constructor create first deadline
97     */
98     constructor() public {
99         currentDeadline = block.timestamp + 60 * 60 * 24 * 3;
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
631 
632 
633 
634 /**
635  * @title Standard ERC20 token
636  *
637  * @dev Implemantation of the basic standart token.
638  * @dev https://github.com/ethereum/EIPs/issues/20
639  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
640  */
641 contract StandardToken is BasicToken, ERC20 {
642 
643     mapping (address => mapping (address => uint)) allowed;
644 
645 
646     /**
647      * @dev Transfer tokens from one address to another
648      * @param _from address The address which you want to send tokens from
649      * @param _to address The address which you want to transfer to
650      * @param _value uint the amout of tokens to be transfered
651      */
652     function transferFrom(address _from, address _to, uint _value) public onlyPayloadSize(3 * 32) {
653         uint256 _allowance = allowed[_from][msg.sender];
654 
655         // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
656         // if (_value > _allowance) throw;
657 
658         balances[_to] = balances[_to].add(_value);
659         balances[_from] = balances[_from].sub(_value);
660         allowed[_from][msg.sender] = _allowance.sub(_value);
661         emit Transfer(_from, _to, _value);
662     }
663 
664     /**
665      * @dev Aprove the passed address to spend the specified amount of tokens on beahlf of msg.sender.
666      * @param _spender The address which will spend the funds.
667      * @param _value The amount of tokens to be spent.
668      */
669     function approve(address _spender, uint _value) public {
670 
671         // To change the approve amount you first have to reduce the addresses`
672         //  allowance to zero by calling `approve(_spender, 0)` if it is not
673         //  already 0 to mitigate the race condition described here:
674         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
675         if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) revert();
676 
677         allowed[msg.sender][_spender] = _value;
678         emit Approval(msg.sender, _spender, _value);
679     }
680 
681     /**
682      * @dev Function to check the amount of tokens than an owner allowed to a spender.
683      * @param _owner address The address which owns the funds.
684      * @param _spender address The address which will spend the funds.
685      * @return A uint specifing the amount of tokens still avaible for the spender.
686      */
687     function allowance(address _owner, address _spender) view public returns (uint remaining) {
688         return allowed[_owner][_spender];
689     }
690 
691 }
692 
693 
694 /**
695  * @title Mintable token
696  * @dev Simple ERC20 Token example, with mintable token creation
697  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
698  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
699  */
700 
701 contract MintableToken is StandardToken, Ownable {
702     event Mint(address indexed to, uint value);
703     event MintFinished();
704     event Burn(address indexed burner, uint256 value);
705 
706     bool public mintingFinished = false;
707     uint public totalSupply = 0;
708 
709 
710     modifier canMint() {
711         require(!mintingFinished);
712         _;
713     }
714 
715     /**
716      * @dev Function to mint tokens
717      * @param _to The address that will recieve the minted tokens.
718      * @param _amount The amount of tokens to mint.
719      * @return A boolean that indicates if the operation was successful.
720      */
721     function mint(address _to, uint _amount) onlyOwner canMint public returns (bool) {
722         totalSupply = totalSupply.add(_amount);
723         balances[_to] = balances[_to].add(_amount);
724         emit Mint(_to, _amount);
725         return true;
726     }
727 
728     /**
729      * @dev Function to stop minting new tokens.
730      * @return True if the operation was successful.
731      */
732     function finishMinting() onlyOwner public returns (bool) {
733         mintingFinished = true;
734         emit MintFinished();
735         return true;
736     }
737 
738 
739     /**
740      * @dev Burns a specific amount of tokens.
741      * @param _value The amount of token to be burned.
742      */
743     function burn(address _who, uint256 _value) onlyOwner public {
744         _burn(_who, _value);
745     }
746 
747     function _burn(address _who, uint256 _value) internal {
748         require(_value <= balances[_who]);
749         // no need to require value <= totalSupply, since that would imply the
750         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
751 
752         balances[_who] = balances[_who].sub(_value);
753         totalSupply = totalSupply.sub(_value);
754         emit Burn(_who, _value);
755         emit Transfer(_who, address(0), _value);
756     }
757 }
758 
759 
760 /**
761  * @title CBCToken
762  * @dev The main CBC token contract
763  *
764  * ABI
765  * [{"constant":true,"inputs":[],"name":"mintingFinished","outputs":[{"name":"","type":"bool"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"name","outputs":[{"name":"","type":"string"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_spender","type":"address"},{"name":"_value","type":"uint256"}],"name":"approve","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"totalSupply","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_from","type":"address"},{"name":"_to","type":"address"},{"name":"_value","type":"uint256"}],"name":"transferFrom","outputs":[],"payable":false,"type":"function"},{"constant":false,"inputs":[],"name":"startTrading","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"decimals","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_to","type":"address"},{"name":"_amount","type":"uint256"}],"name":"mint","outputs":[{"name":"","type":"bool"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"tradingStarted","outputs":[{"name":"","type":"bool"}],"payable":false,"type":"function"},{"constant":true,"inputs":[{"name":"_owner","type":"address"}],"name":"balanceOf","outputs":[{"name":"balance","type":"uint256"}],"payable":false,"type":"function"},{"constant":false,"inputs":[],"name":"finishMinting","outputs":[{"name":"","type":"bool"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"owner","outputs":[{"name":"","type":"address"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"symbol","outputs":[{"name":"","type":"string"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_to","type":"address"},{"name":"_value","type":"uint256"}],"name":"transfer","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[{"name":"_owner","type":"address"},{"name":"_spender","type":"address"}],"name":"allowance","outputs":[{"name":"remaining","type":"uint256"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"newOwner","type":"address"}],"name":"transferOwnership","outputs":[],"payable":false,"type":"function"},{"anonymous":false,"inputs":[{"indexed":true,"name":"to","type":"address"},{"indexed":false,"name":"value","type":"uint256"}],"name":"Mint","type":"event"},{"anonymous":false,"inputs":[],"name":"MintFinished","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"name":"owner","type":"address"},{"indexed":true,"name":"spender","type":"address"},{"indexed":false,"name":"value","type":"uint256"}],"name":"Approval","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"name":"from","type":"address"},{"indexed":true,"name":"to","type":"address"},{"indexed":false,"name":"value","type":"uint256"}],"name":"Transfer","type":"event"}]
766  */
767 contract CBCToken is MintableToken {
768 
769     string public name = "Crypto Boss Coin";
770     string public symbol = "CBC";
771     uint public decimals = 18;
772 
773     bool public tradingStarted = false;
774     /**
775      * @dev modifier that throws if trading has not started yet
776      */
777     modifier hasStartedTrading() {
778         require(tradingStarted);
779         _;
780     }
781 
782 
783     /**
784      * @dev Allows the owner to enable the trading. This can not be undone
785      */
786     function startTrading() onlyOwner public {
787         tradingStarted = true;
788     }
789 
790     /**
791      * @dev Allows anyone to transfer the PAY tokens once trading has started
792      * @param _to the recipient address of the tokens.
793      * @param _value number of tokens to be transfered.
794      */
795     function transfer(address _to, uint _value) hasStartedTrading public {
796         super.transfer(_to, _value);
797     }
798 
799     /**
800     * @dev Allows anyone to transfer the CBC tokens once trading has started
801     * @param _from address The address which you want to send tokens from
802     * @param _to address The address which you want to transfer to
803     * @param _value uint the amout of tokens to be transfered
804     */
805     function transferFrom(address _from, address _to, uint _value) hasStartedTrading public{
806         super.transferFrom(_from, _to, _value);
807     }
808 
809 }
810 
811 /**
812  * @title MainSale
813  * @dev The main CBC token sale contract
814  *
815  * ABI
816  * [{"constant":false,"inputs":[{"name":"_multisigVault","type":"address"}],"name":"setMultisigVault","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[{"name":"authorizerIndex","type":"uint256"}],"name":"getAuthorizer","outputs":[{"name":"","type":"address"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"exchangeRate","outputs":[{"name":"","type":"address"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"altDeposits","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"recipient","type":"address"},{"name":"tokens","type":"uint256"}],"name":"authorizedCreateTokens","outputs":[],"payable":false,"type":"function"},{"constant":false,"inputs":[],"name":"finishMinting","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"owner","outputs":[{"name":"","type":"address"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_exchangeRate","type":"address"}],"name":"setExchangeRate","outputs":[],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_token","type":"address"}],"name":"retrieveTokens","outputs":[],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"totalAltDeposits","type":"uint256"}],"name":"setAltDeposit","outputs":[],"payable":false,"type":"function"},{"constant":!1,"inputs":[{"name":"victim","type":"address"},{"name":"amount","type":"uint256"}],"name":"burnTokens","outputs":[],"payable":!1,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[],"name":"start","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"recipient","type":"address"}],"name":"createTokens","outputs":[],"payable":true,"type":"function"},{"constant":false,"inputs":[{"name":"_addr","type":"address"}],"name":"addAuthorized","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"multisigVault","outputs":[{"name":"","type":"address"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_hardcap","type":"uint256"}],"name":"setHardCap","outputs":[],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"newOwner","type":"address"}],"name":"transferOwnership","outputs":[],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_start","type":"uint256"}],"name":"setStart","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"token","outputs":[{"name":"","type":"address"}],"payable":false,"type":"function"},{"constant":true,"inputs":[{"name":"_addr","type":"address"}],"name":"isAuthorized","outputs":[{"name":"","type":"bool"}],"payable":false,"type":"function"},{"payable":true,"type":"fallback"},{"anonymous":false,"inputs":[{"indexed":false,"name":"recipient","type":"address"},{"indexed":false,"name":"ether_amount","type":"uint256"},{"indexed":false,"name":"pay_amount","type":"uint256"},{"indexed":false,"name":"exchangerate","type":"uint256"}],"name":"TokenSold","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"name":"recipient","type":"address"},{"indexed":false,"name":"pay_amount","type":"uint256"}],"name":"AuthorizedCreate","type":"event"},{"anonymous":false,"inputs":[],"name":"MainSaleClosed","type":"event"}]
817  */
818 contract MainSale is Ownable, Authorizable {
819     using SafeMath for uint;
820     event TokenSold(address recipient, uint ether_amount, uint pay_amount, uint exchangerate);
821     event AuthorizedCreate(address recipient, uint pay_amount);
822     event AuthorizedBurn(address receiver, uint value);
823     event AuthorizedStartTrading();
824     event MainSaleClosed();
825     CBCToken public token = new CBCToken();
826 
827     address payable public multisigVault;
828 
829     uint hardcap = 100000000000000 ether;
830     ExchangeRate public exchangeRate;
831 
832     uint public altDeposits = 0;
833     uint public start = 1525996800;
834 
835     /**
836      * @dev modifier to allow token creation only when the sale IS ON
837      */
838     modifier saleIsOn() {
839         require(now > start && now < start + 28 days);
840         _;
841     }
842 
843     /**
844      * @dev modifier to allow token creation only when the hardcap has not been reached
845      */
846     modifier isUnderHardCap() {
847         require(multisigVault.balance + altDeposits <= hardcap);
848         _;
849     }
850 
851     /**
852      * @dev Allows anyone to create tokens by depositing ether.
853      * @param recipient the recipient to receive tokens.
854      */
855     function createTokens(address recipient) public isUnderHardCap saleIsOn payable {
856         uint rate = exchangeRate.getRate("ETH");
857         uint tokens = rate.mul(msg.value).div(1 ether);
858         token.mint(recipient, tokens);
859         require(multisigVault.send(msg.value));
860         emit TokenSold(recipient, msg.value, tokens, rate);
861     }
862 
863     /**
864      * @dev Allows to set the toal alt deposit measured in ETH to make sure the hardcap includes other deposits
865      * @param totalAltDeposits total amount ETH equivalent
866      */
867     function setAltDeposit(uint totalAltDeposits) public onlyOwner {
868         altDeposits = totalAltDeposits;
869     }
870 
871     /**
872      * @dev Allows authorized acces to create tokens. This is used for Bitcoin and ERC20 deposits
873      * @param recipient the recipient to receive tokens.
874      * @param tokens number of tokens to be created.
875      */
876     function authorizedCreateTokens(address recipient, uint tokens) public onlyAuthorized {
877         token.mint(recipient, tokens);
878         emit AuthorizedCreate(recipient, tokens);
879     }
880 
881     function authorizedStartTrading() public onlyAuthorized {
882         token.startTrading();
883         emit AuthorizedStartTrading();
884     }
885 
886     /**
887      * @dev Allows authorized acces to burn tokens.
888      * @param receiver the receiver to receive tokens.
889      * @param value number of tokens to be created.
890      */
891     function authorizedBurnTokens(address receiver, uint value) public onlyAuthorized {
892         token.burn(receiver, value);
893         emit AuthorizedBurn(receiver, value);
894     }
895 
896     /**
897      * @dev Allows the owner to set the hardcap.
898      * @param _hardcap the new hardcap
899      */
900     function setHardCap(uint _hardcap) public onlyOwner {
901         hardcap = _hardcap;
902     }
903 
904     /**
905      * @dev Allows the owner to set the starting time.
906      * @param _start the new _start
907      */
908     function setStart(uint _start) public onlyOwner {
909         start = _start;
910     }
911 
912     /**
913      * @dev Allows the owner to set the multisig contract.
914      * @param _multisigVault the multisig contract address
915      */
916     function setMultisigVault(address payable _multisigVault) public onlyOwner {
917         if (_multisigVault != address(0)) {
918             multisigVault = _multisigVault;
919         }
920     }
921 
922     /**
923      * @dev Allows the owner to set the exchangerate contract.
924      * @param _exchangeRate the exchangerate address
925      */
926     function setExchangeRate(address _exchangeRate) public onlyOwner {
927         exchangeRate = ExchangeRate(_exchangeRate);
928     }
929 
930     /**
931      * @dev Allows the owner to finish the minting. This will create the
932      * restricted tokens and then close the minting.
933      * Then the ownership of the PAY token contract is transfered
934      * to this owner.
935      */
936     function finishMinting() public onlyOwner {
937         uint issuedTokenSupply = token.totalSupply();
938         uint restrictedTokens = issuedTokenSupply.mul(49).div(51);
939         token.mint(multisigVault, restrictedTokens);
940         token.finishMinting();
941         token.transferOwnership(owner);
942         emit MainSaleClosed();
943     }
944 
945     /**
946      * @dev Allows the owner to transfer ERC20 tokens to the multi sig vault
947      * @param _token the contract address of the ERC20 contract
948      */
949     function retrieveTokens(address _token) public onlyOwner {
950         ERC20 token = ERC20(_token);
951         token.transfer(multisigVault, token.balanceOf(address(this)));
952     }
953 
954     /**
955      * @dev Fallback function which receives ether and created the appropriate number of tokens for the
956      * msg.sender.
957      */
958     function() external payable {
959         createTokens(msg.sender);
960     }
961 
962 }