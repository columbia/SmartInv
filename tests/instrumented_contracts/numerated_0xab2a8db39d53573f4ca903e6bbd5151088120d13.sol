1 pragma solidity ^0.5.1;
2 
3 pragma solidity ^0.5.1;
4 
5 contract JackPot {
6 
7     using SafeMath for uint256;
8 
9     mapping (address => uint256) public depositBears;
10     mapping (address => uint256) public depositBulls;
11     uint256 public currentDeadline;
12     uint256 public lastDeadline = 1546257600;
13     uint256 public countOfBears;
14     uint256 public countOfBulls;
15     uint256 public totalSupplyOfBulls;
16     uint256 public totalSupplyOfBears;
17     uint256 public totalCBCSupplyOfBulls;
18     uint256 public totalCBCSupplyOfBears;
19     uint256 public probabilityOfBulls;
20     uint256 public probabilityOfBears;
21     address public lastHero;
22     address public lastHeroHistory;
23     uint256 public jackPot;
24     uint256 public winner;
25     bool public finished = false;
26 
27     Bears public BearsContract;
28     Bulls public BullsContract;
29     CBCToken public CBCTokenContract;
30 
31     constructor() public {
32         currentDeadline = block.timestamp + 60 * 60 * 24 * 3;
33     }
34 
35     /**
36     * @dev Setter the CryptoBossCoin contract address. Address can be set at once.
37     * @param _CBCTokenAddress Address of the CryptoBossCoin contract
38     */
39     function setCBCTokenAddress(address _CBCTokenAddress) public {
40         require(address(CBCTokenContract) == address(0x0));
41         CBCTokenContract = CBCToken(_CBCTokenAddress);
42     }
43 
44     /**
45     * @dev Setter the Bears contract address. Address can be set at once.
46     * @param _bearsAddress Address of the Bears contract
47     */
48     function setBearsAddress(address payable _bearsAddress) external {
49         require(address(BearsContract) == address(0x0));
50         BearsContract = Bears(_bearsAddress);
51     }
52 
53     /**
54     * @dev Setter the Bulls contract address. Address can be set at once.
55     * @param _bullsAddress Address of the Bulls contract
56     */
57     function setBullsAddress(address payable _bullsAddress) external {
58         require(address(BullsContract) == address(0x0));
59         BullsContract = Bulls(_bullsAddress);
60     }
61 
62     function getNow() view public returns(uint){
63         return block.timestamp;
64     }
65 
66     function getState() view public returns(bool) {
67         if (block.timestamp > currentDeadline) {
68             return false;
69         }
70         return true;
71     }
72 
73     function setInfo(address _lastHero, uint256 _deposit) public {
74         require(address(BearsContract) == msg.sender || address(BullsContract) == msg.sender);
75 
76         if (address(BearsContract) == msg.sender) {
77             require(depositBulls[_lastHero] == 0, "You are already in bulls team");
78             if (depositBears[_lastHero] == 0)
79                 countOfBears++;
80             totalSupplyOfBears = totalSupplyOfBears.add(_deposit.mul(90).div(100));
81             depositBears[_lastHero] = depositBears[_lastHero].add(_deposit.mul(90).div(100));
82         }
83 
84         if (address(BullsContract) == msg.sender) {
85             require(depositBears[_lastHero] == 0, "You are already in bears team");
86             if (depositBulls[_lastHero] == 0)
87                 countOfBulls++;
88             totalSupplyOfBulls = totalSupplyOfBulls.add(_deposit.mul(90).div(100));
89             depositBulls[_lastHero] = depositBulls[_lastHero].add(_deposit.mul(90).div(100));
90         }
91 
92         lastHero = _lastHero;
93 
94         if (currentDeadline.add(120) <= lastDeadline) {
95             currentDeadline = currentDeadline.add(120);
96         } else {
97             currentDeadline = lastDeadline;
98         }
99 
100         jackPot = (address(this).balance.add(_deposit)).mul(10).div(100);
101 
102         calculateProbability();
103     }
104 
105     function calculateProbability() public {
106         require(winner == 0 && getState());
107 
108         totalCBCSupplyOfBulls = CBCTokenContract.balanceOf(address(BullsContract));
109         totalCBCSupplyOfBears = CBCTokenContract.balanceOf(address(BearsContract));
110         uint256 percent = (totalSupplyOfBulls.add(totalSupplyOfBears)).div(100);
111 
112         if (totalCBCSupplyOfBulls < 1 ether) {
113             totalCBCSupplyOfBulls = 0;
114         }
115 
116         if (totalCBCSupplyOfBears < 1 ether) {
117             totalCBCSupplyOfBears = 0;
118         }
119 
120         if (totalCBCSupplyOfBulls <= totalCBCSupplyOfBears) {
121             uint256 difference = totalCBCSupplyOfBears.sub(totalCBCSupplyOfBulls).div(0.01 ether);
122             probabilityOfBears = totalSupplyOfBears.mul(100).div(percent).add(difference);
123 
124             if (probabilityOfBears > 8000) {
125                 probabilityOfBears = 8000;
126             }
127             if (probabilityOfBears < 2000) {
128                 probabilityOfBears = 2000;
129             }
130             probabilityOfBulls = 10000 - probabilityOfBears;
131         } else {
132             uint256 difference = totalCBCSupplyOfBulls.sub(totalCBCSupplyOfBears).div(0.01 ether);
133             probabilityOfBulls = totalSupplyOfBulls.mul(100).div(percent).add(difference);
134 
135             if (probabilityOfBulls > 8000) {
136                 probabilityOfBulls = 8000;
137             }
138             if (probabilityOfBulls < 2000) {
139                 probabilityOfBulls = 2000;
140             }
141             probabilityOfBears = 10000 - probabilityOfBulls;
142         }
143 
144         totalCBCSupplyOfBulls = CBCTokenContract.balanceOf(address(BullsContract));
145         totalCBCSupplyOfBears = CBCTokenContract.balanceOf(address(BearsContract));
146     }
147 
148     function getWinners() public {
149         require(winner == 0 && !getState());
150 
151         uint256 seed1 = address(this).balance;
152         uint256 seed2 = totalSupplyOfBulls;
153         uint256 seed3 = totalSupplyOfBears;
154         uint256 seed4 = totalCBCSupplyOfBulls;
155         uint256 seed5 = totalCBCSupplyOfBulls;
156         uint256 seed6 = block.difficulty;
157         uint256 seed7 = block.timestamp;
158 
159         bytes32 randomHash = keccak256(abi.encodePacked(seed1, seed2, seed3, seed4, seed5, seed6, seed7));
160         uint randomNumber = uint(randomHash);
161 
162         if (randomNumber == 0){
163             randomNumber = 1;
164         }
165 
166         uint winningNumber = randomNumber % 10000;
167 
168         if (1 <= winningNumber && winningNumber <= probabilityOfBears){
169             winner = 1;
170         }
171 
172         if (probabilityOfBears < winningNumber && winningNumber <= 10000){
173             winner = 2;
174         }
175     }
176 
177     /**
178     * @dev Payable function for take prize
179     */
180     function () external payable {
181         if (msg.value == 0 &&  !getState() && winner > 0){
182             require(depositBears[msg.sender] > 0 || depositBulls[msg.sender] > 0);
183 
184             uint payout = 0;
185             uint payoutCBC = 0;
186 
187             if (winner == 1 && depositBears[msg.sender] > 0) {
188                 payout = calculateETHPrize(msg.sender);
189             }
190             if (winner == 2 && depositBulls[msg.sender] > 0) {
191                 payout = calculateETHPrize(msg.sender);
192             }
193 
194             if (payout > 0) {
195                 depositBears[msg.sender] = 0;
196                 depositBulls[msg.sender] = 0;
197                 msg.sender.transfer(payout);
198             }
199 
200             if ((winner == 1 && depositBears[msg.sender] == 0) || (winner == 2 && depositBulls[msg.sender] == 0)) {
201                 payoutCBC = calculateCBCPrize(msg.sender);
202                 if (CBCTokenContract.balanceOf(address(BullsContract)) > 0)
203                     CBCTokenContract.transferFrom(
204                         address(BullsContract),
205                         address(this),
206                         CBCTokenContract.balanceOf(address(BullsContract))
207                     );
208                 if (CBCTokenContract.balanceOf(address(BearsContract)) > 0)
209                     CBCTokenContract.transferFrom(
210                         address(BearsContract),
211                         address(this),
212                         CBCTokenContract.balanceOf(address(BearsContract))
213                     );
214                 CBCTokenContract.transfer(msg.sender, payoutCBC);
215             }
216 
217             if (msg.sender == lastHero) {
218                 lastHeroHistory = lastHero;
219                 lastHero = address(0x0);
220                 msg.sender.transfer(jackPot);
221             }
222         }
223     }
224 
225     function calculateETHPrize(address participant) public view returns(uint) {
226 
227         uint payout = 0;
228         uint256 totalSupply = (totalSupplyOfBears.add(totalSupplyOfBulls));
229 
230         if (depositBears[participant] > 0) {
231             payout = totalSupply.mul(depositBears[participant]).div(totalSupplyOfBears);
232         }
233 
234         if (depositBulls[participant] > 0) {
235             payout = totalSupply.mul(depositBulls[participant]).div(totalSupplyOfBulls);
236         }
237 
238         return payout;
239     }
240 
241     function calculateCBCPrize(address participant) public view returns(uint) {
242 
243         uint payout = 0;
244         uint totalSupply = (totalCBCSupplyOfBears.add(totalCBCSupplyOfBulls)).mul(80).div(100);
245 
246         if (depositBears[participant] > 0) {
247             payout = totalSupply.mul(depositBears[participant]).div(totalSupplyOfBears);
248         }
249 
250         if (depositBulls[participant] > 0) {
251             payout = totalSupply.mul(depositBulls[participant]).div(totalSupplyOfBulls);
252         }
253 
254         return payout;
255     }
256 }
257 
258 contract Team {
259     using SafeMath for uint256;
260 
261     address payable public teamAddressOne = 0x5947D8b85c5D3f8655b136B5De5D0Dd33f8E93D9;
262     address payable public teamAddressTwo = 0xC923728AD95f71BC77186D6Fb091B3B30Ba42247;
263     address payable public teamAddressThree = 0x763BFB050F9b973Dd32693B1e2181A68508CdA54;
264 
265     JackPot public JPContract;
266     CBCToken public CBCTokenContract;
267 
268     /**
269     * @dev Payable function
270     */
271     function () external payable {
272         require(JPContract.getState() && msg.value >= 0.05 ether);
273 
274         JPContract.setInfo(msg.sender, msg.value.mul(90).div(100));
275 
276         teamAddressOne.transfer(msg.value.mul(4).div(100));
277         teamAddressTwo.transfer(msg.value.mul(4).div(100));
278         teamAddressThree.transfer(msg.value.mul(2).div(100));
279         address(JPContract).transfer(msg.value.mul(90).div(100));
280     }
281 }
282 
283 contract Bears is Team {
284     constructor(address payable _jackPotAddress, address payable _CBCTokenAddress) public {
285         JPContract = JackPot(_jackPotAddress);
286         JPContract.setBearsAddress(address(this));
287         CBCTokenContract = CBCToken(_CBCTokenAddress);
288         CBCTokenContract.approve(_jackPotAddress, 9999999999999999999000000000000000000);
289     }
290 }
291 
292 contract Bulls is Team {
293     constructor(address payable _jackPotAddress, address payable _CBCTokenAddress) public {
294         JPContract = JackPot(_jackPotAddress);
295         JPContract.setBullsAddress(address(this));
296         CBCTokenContract = CBCToken(_CBCTokenAddress);
297         CBCTokenContract.approve(_jackPotAddress, 9999999999999999999000000000000000000);
298     }
299 }
300 
301 
302 pragma solidity ^0.5.1;
303 
304 
305 /**
306  * @title Ownable
307  * @dev The Ownable contract has an owner address, and provides basic authorization control
308  * functions, this simplifies the implementation of "user permissions".
309  */
310 contract Ownable {
311     address public owner;
312 
313 
314     /**
315      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
316      * account.
317      */
318     constructor() public {
319         owner = msg.sender;
320     }
321 
322 
323     /**
324      * @dev Throws if called by any account other than the owner.
325      */
326     modifier onlyOwner() {
327         require (msg.sender == owner);
328         _;
329     }
330 
331 
332     /**
333      * @dev Allows the current owner to transfer control of the contract to a newOwner.
334      * @param newOwner The address to transfer ownership to.
335      */
336     function transferOwnership(address newOwner) public onlyOwner {
337         require(newOwner != address(0));
338         owner = newOwner;
339     }
340 }
341 
342 
343 
344 /**
345  * @title Authorizable
346  * @dev Allows to authorize access to certain function calls
347  *
348  * ABI
349  * [{"constant":true,"inputs":[{"name":"authorizerIndex","type":"uint256"}],"name":"getAuthorizer","outputs":[{"name":"","type":"address"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_addr","type":"address"}],"name":"addAuthorized","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[{"name":"_addr","type":"address"}],"name":"isAuthorized","outputs":[{"name":"","type":"bool"}],"payable":false,"type":"function"},{"inputs":[],"payable":false,"type":"constructor"}]
350  */
351 contract Authorizable {
352 
353     address[] authorizers;
354     mapping(address => uint) authorizerIndex;
355 
356     /**
357      * @dev Throws if called by any account tat is not authorized.
358      */
359     modifier onlyAuthorized {
360         require(isAuthorized(msg.sender));
361         _;
362     }
363 
364     /**
365      * @dev Contructor that authorizes the msg.sender.
366      */
367     constructor() public {
368         authorizers.length = 2;
369         authorizers[1] = msg.sender;
370         authorizerIndex[msg.sender] = 1;
371     }
372 
373     /**
374      * @dev Function to get a specific authorizer
375      * @param authorizerIndex index of the authorizer to be retrieved.
376      * @return The address of the authorizer.
377      */
378     function getAuthorizer(uint authorizerIndex) external view returns(address) {
379         return address(authorizers[authorizerIndex + 1]);
380     }
381 
382     /**
383      * @dev Function to check if an address is authorized
384      * @param _addr the address to check if it is authorized.
385      * @return boolean flag if address is authorized.
386      */
387     function isAuthorized(address _addr) public view returns(bool) {
388         return authorizerIndex[_addr] > 0;
389     }
390 
391     /**
392      * @dev Function to add a new authorizer
393      * @param _addr the address to add as a new authorizer.
394      */
395     function addAuthorized(address _addr) external onlyAuthorized {
396         authorizerIndex[_addr] = authorizers.length;
397         authorizers.length++;
398         authorizers[authorizers.length - 1] = _addr;
399     }
400 
401 }
402 
403 /**
404  * @title ExchangeRate
405  * @dev Allows updating and retrieveing of Conversion Rates for PAY tokens
406  *
407  * ABI
408  * [{"constant":false,"inputs":[{"name":"_symbol","type":"string"},{"name":"_rate","type":"uint256"}],"name":"updateRate","outputs":[],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"data","type":"uint256[]"}],"name":"updateRates","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[{"name":"_symbol","type":"string"}],"name":"getRate","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"owner","outputs":[{"name":"","type":"address"}],"payable":false,"type":"function"},{"constant":true,"inputs":[{"name":"","type":"bytes32"}],"name":"rates","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"newOwner","type":"address"}],"name":"transferOwnership","outputs":[],"payable":false,"type":"function"},{"anonymous":false,"inputs":[{"indexed":false,"name":"timestamp","type":"uint256"},{"indexed":false,"name":"symbol","type":"bytes32"},{"indexed":false,"name":"rate","type":"uint256"}],"name":"RateUpdated","type":"event"}]
409  */
410 contract ExchangeRate is Ownable {
411 
412     event RateUpdated(uint timestamp, bytes32 symbol, uint rate);
413 
414     mapping(bytes32 => uint) public rates;
415 
416     /**
417      * @dev Allows the current owner to update a single rate.
418      * @param _symbol The symbol to be updated.
419      * @param _rate the rate for the symbol.
420      */
421     function updateRate(string memory _symbol, uint _rate) public onlyOwner {
422         rates[keccak256(abi.encodePacked(_symbol))] = _rate;
423         emit RateUpdated(now, keccak256(bytes(_symbol)), _rate);
424     }
425 
426     /**
427      * @dev Allows the current owner to update multiple rates.
428      * @param data an array that alternates keccak256 hashes of the symbol and the corresponding rate .
429      */
430     function updateRates(uint[] memory data) public onlyOwner {
431         require (data.length % 2 <= 0);
432         uint i = 0;
433         while (i < data.length / 2) {
434             bytes32 symbol = bytes32(data[i * 2]);
435             uint rate = data[i * 2 + 1];
436             rates[symbol] = rate;
437             emit RateUpdated(now, symbol, rate);
438             i++;
439         }
440     }
441 
442     /**
443      * @dev Allows the anyone to read the current rate.
444      * @param _symbol the symbol to be retrieved.
445      */
446     function getRate(string memory _symbol) public view returns(uint) {
447         return rates[keccak256(abi.encodePacked(_symbol))];
448     }
449 
450 }
451 
452 /**
453  * @title SafeMath
454  * @dev Math operations with safety checks that revert on error
455  */
456 library SafeMath {
457     /**
458     * @dev Multiplies two numbers, reverts on overflow.
459     */
460     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
461         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
462         // benefit is lost if 'b' is also tested.
463         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
464         if (a == 0) {
465             return 0;
466         }
467 
468         uint256 c = a * b;
469         require(c / a == b);
470 
471         return c;
472     }
473 
474     /**
475     * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
476     */
477     function div(uint256 a, uint256 b) internal pure returns (uint256) {
478         // Solidity only automatically asserts when dividing by 0
479         require(b > 0);
480         uint256 c = a / b;
481         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
482 
483         return c;
484     }
485 
486     /**
487     * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
488     */
489     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
490         require(b <= a);
491         uint256 c = a - b;
492 
493         return c;
494     }
495 
496     /**
497     * @dev Adds two numbers, reverts on overflow.
498     */
499     function add(uint256 a, uint256 b) internal pure returns (uint256) {
500         uint256 c = a + b;
501         require(c >= a);
502 
503         return c;
504     }
505 
506     /**
507     * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
508     * reverts when dividing by zero.
509     */
510     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
511         require(b != 0);
512         return a % b;
513     }
514 }
515 
516 
517 /**
518  * @title ERC20Basic
519  * @dev Simpler version of ERC20 interface
520  * @dev see https://github.com/ethereum/EIPs/issues/20
521  */
522 contract ERC20Basic {
523     uint public totalSupply;
524     function balanceOf(address who) public view returns (uint);
525     function transfer(address to, uint value) public;
526     event Transfer(address indexed from, address indexed to, uint value);
527 }
528 
529 
530 
531 
532 /**
533  * @title ERC20 interface
534  * @dev see https://github.com/ethereum/EIPs/issues/20
535  */
536 contract ERC20 is ERC20Basic {
537     function allowance(address owner, address spender) view public returns (uint);
538     function transferFrom(address from, address to, uint value) public;
539     function approve(address spender, uint value) public;
540     event Approval(address indexed owner, address indexed spender, uint value);
541 }
542 
543 
544 
545 
546 /**
547  * @title Basic token
548  * @dev Basic version of StandardToken, with no allowances.
549  */
550 contract BasicToken is ERC20Basic {
551     using SafeMath for uint;
552 
553     mapping(address => uint) balances;
554 
555     /**
556      * @dev Fix for the ERC20 short address attack.
557      */
558     modifier onlyPayloadSize(uint size) {
559         require (size + 4 <= msg.data.length);
560         _;
561     }
562 
563     /**
564     * @dev transfer token for a specified address
565     * @param _to The address to transfer to.
566     * @param _value The amount to be transferred.
567     */
568     function transfer(address _to, uint _value) public onlyPayloadSize(2 * 32) {
569         balances[msg.sender] = balances[msg.sender].sub(_value);
570         balances[_to] = balances[_to].add(_value);
571         emit Transfer(msg.sender, _to, _value);
572     }
573 
574     /**
575     * @dev Gets the balance of the specified address.
576     * @param _owner The address to query the the balance of.
577     * @return An uint representing the amount owned by the passed address.
578     */
579     function balanceOf(address _owner) view public returns (uint balance) {
580         return balances[_owner];
581     }
582 
583 }
584 
585 
586 
587 
588 /**
589  * @title Standard ERC20 token
590  *
591  * @dev Implemantation of the basic standart token.
592  * @dev https://github.com/ethereum/EIPs/issues/20
593  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
594  */
595 contract StandardToken is BasicToken, ERC20 {
596 
597     mapping (address => mapping (address => uint)) allowed;
598 
599 
600     /**
601      * @dev Transfer tokens from one address to another
602      * @param _from address The address which you want to send tokens from
603      * @param _to address The address which you want to transfer to
604      * @param _value uint the amout of tokens to be transfered
605      */
606     function transferFrom(address _from, address _to, uint _value) public onlyPayloadSize(3 * 32) {
607         uint256 _allowance = allowed[_from][msg.sender];
608 
609         // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
610         // if (_value > _allowance) throw;
611 
612         balances[_to] = balances[_to].add(_value);
613         balances[_from] = balances[_from].sub(_value);
614         allowed[_from][msg.sender] = _allowance.sub(_value);
615         emit Transfer(_from, _to, _value);
616     }
617 
618     /**
619      * @dev Aprove the passed address to spend the specified amount of tokens on beahlf of msg.sender.
620      * @param _spender The address which will spend the funds.
621      * @param _value The amount of tokens to be spent.
622      */
623     function approve(address _spender, uint _value) public {
624 
625         // To change the approve amount you first have to reduce the addresses`
626         //  allowance to zero by calling `approve(_spender, 0)` if it is not
627         //  already 0 to mitigate the race condition described here:
628         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
629         if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) revert();
630 
631         allowed[msg.sender][_spender] = _value;
632         emit Approval(msg.sender, _spender, _value);
633     }
634 
635     /**
636      * @dev Function to check the amount of tokens than an owner allowed to a spender.
637      * @param _owner address The address which owns the funds.
638      * @param _spender address The address which will spend the funds.
639      * @return A uint specifing the amount of tokens still avaible for the spender.
640      */
641     function allowance(address _owner, address _spender) view public returns (uint remaining) {
642         return allowed[_owner][_spender];
643     }
644 
645 }
646 
647 
648 /**
649  * @title Mintable token
650  * @dev Simple ERC20 Token example, with mintable token creation
651  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
652  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
653  */
654 
655 contract MintableToken is StandardToken, Ownable {
656     event Mint(address indexed to, uint value);
657     event MintFinished();
658     event Burn(address indexed burner, uint256 value);
659 
660     bool public mintingFinished = false;
661     uint public totalSupply = 0;
662 
663 
664     modifier canMint() {
665         require(!mintingFinished);
666         _;
667     }
668 
669     /**
670      * @dev Function to mint tokens
671      * @param _to The address that will recieve the minted tokens.
672      * @param _amount The amount of tokens to mint.
673      * @return A boolean that indicates if the operation was successful.
674      */
675     function mint(address _to, uint _amount) onlyOwner canMint public returns (bool) {
676         totalSupply = totalSupply.add(_amount);
677         balances[_to] = balances[_to].add(_amount);
678         emit Mint(_to, _amount);
679         return true;
680     }
681 
682     /**
683      * @dev Function to stop minting new tokens.
684      * @return True if the operation was successful.
685      */
686     function finishMinting() onlyOwner public returns (bool) {
687         mintingFinished = true;
688         emit MintFinished();
689         return true;
690     }
691 
692 
693     /**
694      * @dev Burns a specific amount of tokens.
695      * @param _value The amount of token to be burned.
696      */
697     function burn(address _who, uint256 _value) onlyOwner public {
698         _burn(_who, _value);
699     }
700 
701     function _burn(address _who, uint256 _value) internal {
702         require(_value <= balances[_who]);
703         // no need to require value <= totalSupply, since that would imply the
704         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
705 
706         balances[_who] = balances[_who].sub(_value);
707         totalSupply = totalSupply.sub(_value);
708         emit Burn(_who, _value);
709         emit Transfer(_who, address(0), _value);
710     }
711 }
712 
713 
714 /**
715  * @title CBCToken
716  * @dev The main CBC token contract
717  *
718  * ABI
719  * [{"constant":true,"inputs":[],"name":"mintingFinished","outputs":[{"name":"","type":"bool"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"name","outputs":[{"name":"","type":"string"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_spender","type":"address"},{"name":"_value","type":"uint256"}],"name":"approve","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"totalSupply","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_from","type":"address"},{"name":"_to","type":"address"},{"name":"_value","type":"uint256"}],"name":"transferFrom","outputs":[],"payable":false,"type":"function"},{"constant":false,"inputs":[],"name":"startTrading","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"decimals","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_to","type":"address"},{"name":"_amount","type":"uint256"}],"name":"mint","outputs":[{"name":"","type":"bool"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"tradingStarted","outputs":[{"name":"","type":"bool"}],"payable":false,"type":"function"},{"constant":true,"inputs":[{"name":"_owner","type":"address"}],"name":"balanceOf","outputs":[{"name":"balance","type":"uint256"}],"payable":false,"type":"function"},{"constant":false,"inputs":[],"name":"finishMinting","outputs":[{"name":"","type":"bool"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"owner","outputs":[{"name":"","type":"address"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"symbol","outputs":[{"name":"","type":"string"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_to","type":"address"},{"name":"_value","type":"uint256"}],"name":"transfer","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[{"name":"_owner","type":"address"},{"name":"_spender","type":"address"}],"name":"allowance","outputs":[{"name":"remaining","type":"uint256"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"newOwner","type":"address"}],"name":"transferOwnership","outputs":[],"payable":false,"type":"function"},{"anonymous":false,"inputs":[{"indexed":true,"name":"to","type":"address"},{"indexed":false,"name":"value","type":"uint256"}],"name":"Mint","type":"event"},{"anonymous":false,"inputs":[],"name":"MintFinished","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"name":"owner","type":"address"},{"indexed":true,"name":"spender","type":"address"},{"indexed":false,"name":"value","type":"uint256"}],"name":"Approval","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"name":"from","type":"address"},{"indexed":true,"name":"to","type":"address"},{"indexed":false,"name":"value","type":"uint256"}],"name":"Transfer","type":"event"}]
720  */
721 contract CBCToken is MintableToken {
722 
723     string public name = "Crypto Boss Coin";
724     string public symbol = "CBC";
725     uint public decimals = 18;
726 
727     bool public tradingStarted = false;
728     /**
729      * @dev modifier that throws if trading has not started yet
730      */
731     modifier hasStartedTrading() {
732         require(tradingStarted);
733         _;
734     }
735 
736 
737     /**
738      * @dev Allows the owner to enable the trading. This can not be undone
739      */
740     function startTrading() onlyOwner public {
741         tradingStarted = true;
742     }
743 
744     /**
745      * @dev Allows anyone to transfer the PAY tokens once trading has started
746      * @param _to the recipient address of the tokens.
747      * @param _value number of tokens to be transfered.
748      */
749     function transfer(address _to, uint _value) hasStartedTrading public {
750         super.transfer(_to, _value);
751     }
752 
753     /**
754     * @dev Allows anyone to transfer the CBC tokens once trading has started
755     * @param _from address The address which you want to send tokens from
756     * @param _to address The address which you want to transfer to
757     * @param _value uint the amout of tokens to be transfered
758     */
759     function transferFrom(address _from, address _to, uint _value) hasStartedTrading public{
760         super.transferFrom(_from, _to, _value);
761     }
762 
763 }
764 
765 /**
766  * @title MainSale
767  * @dev The main CBC token sale contract
768  *
769  * ABI
770  * [{"constant":false,"inputs":[{"name":"_multisigVault","type":"address"}],"name":"setMultisigVault","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[{"name":"authorizerIndex","type":"uint256"}],"name":"getAuthorizer","outputs":[{"name":"","type":"address"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"exchangeRate","outputs":[{"name":"","type":"address"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"altDeposits","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"recipient","type":"address"},{"name":"tokens","type":"uint256"}],"name":"authorizedCreateTokens","outputs":[],"payable":false,"type":"function"},{"constant":false,"inputs":[],"name":"finishMinting","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"owner","outputs":[{"name":"","type":"address"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_exchangeRate","type":"address"}],"name":"setExchangeRate","outputs":[],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_token","type":"address"}],"name":"retrieveTokens","outputs":[],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"totalAltDeposits","type":"uint256"}],"name":"setAltDeposit","outputs":[],"payable":false,"type":"function"},{"constant":!1,"inputs":[{"name":"victim","type":"address"},{"name":"amount","type":"uint256"}],"name":"burnTokens","outputs":[],"payable":!1,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[],"name":"start","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"recipient","type":"address"}],"name":"createTokens","outputs":[],"payable":true,"type":"function"},{"constant":false,"inputs":[{"name":"_addr","type":"address"}],"name":"addAuthorized","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"multisigVault","outputs":[{"name":"","type":"address"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_hardcap","type":"uint256"}],"name":"setHardCap","outputs":[],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"newOwner","type":"address"}],"name":"transferOwnership","outputs":[],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_start","type":"uint256"}],"name":"setStart","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"token","outputs":[{"name":"","type":"address"}],"payable":false,"type":"function"},{"constant":true,"inputs":[{"name":"_addr","type":"address"}],"name":"isAuthorized","outputs":[{"name":"","type":"bool"}],"payable":false,"type":"function"},{"payable":true,"type":"fallback"},{"anonymous":false,"inputs":[{"indexed":false,"name":"recipient","type":"address"},{"indexed":false,"name":"ether_amount","type":"uint256"},{"indexed":false,"name":"pay_amount","type":"uint256"},{"indexed":false,"name":"exchangerate","type":"uint256"}],"name":"TokenSold","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"name":"recipient","type":"address"},{"indexed":false,"name":"pay_amount","type":"uint256"}],"name":"AuthorizedCreate","type":"event"},{"anonymous":false,"inputs":[],"name":"MainSaleClosed","type":"event"}]
771  */
772 contract MainSale is Ownable, Authorizable {
773     using SafeMath for uint;
774     event TokenSold(address recipient, uint ether_amount, uint pay_amount, uint exchangerate);
775     event AuthorizedCreate(address recipient, uint pay_amount);
776     event AuthorizedBurn(address receiver, uint value);
777     event AuthorizedStartTrading();
778     event MainSaleClosed();
779     CBCToken public token = new CBCToken();
780 
781     address payable public multisigVault;
782 
783     uint hardcap = 100000000000000 ether;
784     ExchangeRate public exchangeRate;
785 
786     uint public altDeposits = 0;
787     uint public start = 1525996800;
788 
789     /**
790      * @dev modifier to allow token creation only when the sale IS ON
791      */
792     modifier saleIsOn() {
793         require(now > start && now < start + 28 days);
794         _;
795     }
796 
797     /**
798      * @dev modifier to allow token creation only when the hardcap has not been reached
799      */
800     modifier isUnderHardCap() {
801         require(multisigVault.balance + altDeposits <= hardcap);
802         _;
803     }
804 
805     /**
806      * @dev Allows anyone to create tokens by depositing ether.
807      * @param recipient the recipient to receive tokens.
808      */
809     function createTokens(address recipient) public isUnderHardCap saleIsOn payable {
810         uint rate = exchangeRate.getRate("ETH");
811         uint tokens = rate.mul(msg.value).div(1 ether);
812         token.mint(recipient, tokens);
813         require(multisigVault.send(msg.value));
814         emit TokenSold(recipient, msg.value, tokens, rate);
815     }
816 
817     /**
818      * @dev Allows to set the toal alt deposit measured in ETH to make sure the hardcap includes other deposits
819      * @param totalAltDeposits total amount ETH equivalent
820      */
821     function setAltDeposit(uint totalAltDeposits) public onlyOwner {
822         altDeposits = totalAltDeposits;
823     }
824 
825     /**
826      * @dev Allows authorized acces to create tokens. This is used for Bitcoin and ERC20 deposits
827      * @param recipient the recipient to receive tokens.
828      * @param tokens number of tokens to be created.
829      */
830     function authorizedCreateTokens(address recipient, uint tokens) public onlyAuthorized {
831         token.mint(recipient, tokens);
832         emit AuthorizedCreate(recipient, tokens);
833     }
834 
835     function authorizedStartTrading() public onlyAuthorized {
836         token.startTrading();
837         emit AuthorizedStartTrading();
838     }
839 
840     /**
841      * @dev Allows authorized acces to burn tokens.
842      * @param receiver the receiver to receive tokens.
843      * @param value number of tokens to be created.
844      */
845     function authorizedBurnTokens(address receiver, uint value) public onlyAuthorized {
846         token.burn(receiver, value);
847         emit AuthorizedBurn(receiver, value);
848     }
849 
850     /**
851      * @dev Allows the owner to set the hardcap.
852      * @param _hardcap the new hardcap
853      */
854     function setHardCap(uint _hardcap) public onlyOwner {
855         hardcap = _hardcap;
856     }
857 
858     /**
859      * @dev Allows the owner to set the starting time.
860      * @param _start the new _start
861      */
862     function setStart(uint _start) public onlyOwner {
863         start = _start;
864     }
865 
866     /**
867      * @dev Allows the owner to set the multisig contract.
868      * @param _multisigVault the multisig contract address
869      */
870     function setMultisigVault(address payable _multisigVault) public onlyOwner {
871         if (_multisigVault != address(0)) {
872             multisigVault = _multisigVault;
873         }
874     }
875 
876     /**
877      * @dev Allows the owner to set the exchangerate contract.
878      * @param _exchangeRate the exchangerate address
879      */
880     function setExchangeRate(address _exchangeRate) public onlyOwner {
881         exchangeRate = ExchangeRate(_exchangeRate);
882     }
883 
884     /**
885      * @dev Allows the owner to finish the minting. This will create the
886      * restricted tokens and then close the minting.
887      * Then the ownership of the PAY token contract is transfered
888      * to this owner.
889      */
890     function finishMinting() public onlyOwner {
891         uint issuedTokenSupply = token.totalSupply();
892         uint restrictedTokens = issuedTokenSupply.mul(49).div(51);
893         token.mint(multisigVault, restrictedTokens);
894         token.finishMinting();
895         token.transferOwnership(owner);
896         emit MainSaleClosed();
897     }
898 
899     /**
900      * @dev Allows the owner to transfer ERC20 tokens to the multi sig vault
901      * @param _token the contract address of the ERC20 contract
902      */
903     function retrieveTokens(address _token) public onlyOwner {
904         ERC20 token = ERC20(_token);
905         token.transfer(multisigVault, token.balanceOf(address(this)));
906     }
907 
908     /**
909      * @dev Fallback function which receives ether and created the appropriate number of tokens for the
910      * msg.sender.
911      */
912     function() external payable {
913         createTokens(msg.sender);
914     }
915 
916 }