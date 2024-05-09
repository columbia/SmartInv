1 pragma solidity 0.4.19;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
10         uint256 c = a * b;
11         assert(a == 0 || c / a == b);
12         return c;
13     }
14 
15     function div(uint256 a, uint256 b) internal pure returns (uint256) {
16         // assert(b > 0); // Solidity automatically throws when dividing by 0
17         uint256 c = a / b;
18         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
19         return c;
20     }
21 
22     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
23         assert(b <= a);
24         return a - b;
25     }
26 
27     function add(uint256 a, uint256 b) internal pure returns (uint256) {
28         uint256 c = a + b;
29         assert(c >= a);
30         return c;
31     }
32 }
33 
34 /**
35  * @title Ownable
36  * @dev The Ownable contract has an owner address, and provides basic authorization control
37  * functions, this simplifies the implementation of "user permissions".
38  */
39 contract Ownable {
40     //Variables
41     address public owner;
42 
43     address public newOwner;
44 
45     //    Modifiers
46     /**
47      * @dev Throws if called by any account other than the owner.
48      */
49     modifier onlyOwner() {
50         require(msg.sender == owner);
51         _;
52     }
53 
54     /**
55      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
56      * account.
57      */
58     function Ownable() public {
59         owner = msg.sender;
60     }
61 
62     /**
63      * @dev Allows the current owner to transfer control of the contract to a newOwner.
64      * @param _newOwner The address to transfer ownership to.
65      */
66     function transferOwnership(address _newOwner) public onlyOwner {
67         require(_newOwner != address(0));
68         newOwner = _newOwner;
69 
70     }
71 
72     function acceptOwnership() public {
73         if (msg.sender == newOwner) {
74             owner = newOwner;
75         }
76     }
77 }
78 
79 /**
80  * @title ERC20Basic
81  * @dev Simpler version of ERC20 interface
82  * @dev see https://github.com/ethereum/EIPs/issues/179
83  */
84 contract ERC20Basic {
85     uint256 public totalSupply;
86     function balanceOf(address who) public constant returns (uint256);
87     function transfer(address to, uint256 value) public returns (bool);
88     event Transfer(address indexed from, address indexed to, uint256 value);
89 }
90 
91 /**
92  * @title ERC20 interface
93  * @dev see https://github.com/ethereum/EIPs/issues/20
94  */
95 contract ERC20 is ERC20Basic {
96     function allowance(address owner, address spender) public constant returns (uint256);
97     function transferFrom(address from, address to, uint256 value) public returns (bool);
98     function approve(address spender, uint256 value) public returns (bool);
99     event Approval(address indexed owner, address indexed spender, uint256 value);
100 }
101 
102 /**
103  * @title Basic token
104  * @dev Basic version of StandardToken, with no allowances.
105  */
106 contract BasicToken is ERC20Basic {
107 
108     using SafeMath for uint256;
109 
110     mapping (address => uint256) public balances;
111 
112     /**
113     * @dev transfer token for a specified address
114     * @param _to The address to transfer to.
115     * @param _value The amount to be transferred.
116     */
117     function transfer(address _to, uint256 _value) public returns (bool) {
118         require(_to != address(0));
119         require(_value <= balances[msg.sender]);
120 
121         // SafeMath.sub will throw if there is not enough balance.
122         balances[msg.sender] = balances[msg.sender].sub(_value);
123         balances[_to] = balances[_to].add(_value);
124         Transfer(msg.sender, _to, _value);
125         return true;
126     }
127 
128     /**
129     * @dev Gets the balance of the specified address.
130     * @param _owner The address to query the the balance of.
131     * @return An uint256 representing the amount owned by the passed address.
132     */
133     function balanceOf(address _owner) public constant returns (uint256 balance) {
134         return balances[_owner];
135     }
136 
137 }
138 
139 /**
140  * @title Standard ERC20 token
141  *
142  * @dev Implementation of the basic standard token.
143  * @dev https://github.com/ethereum/EIPs/issues/20
144  * @dev Based on code by FirstBlood:
145         https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
146  */
147 contract StandardToken is ERC20, BasicToken {
148 
149     mapping (address => mapping (address => uint256)) internal allowed;
150 
151     /**
152      * @dev Transfer tokens from one address to another
153      * @param _from address The address which you want to send tokens from
154      * @param _to address The address which you want to transfer to
155      * @param _value uint256 the amount of tokens to be transferred
156      */
157     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
158         require(_to != address(0));
159         require(_value <= balances[_from]);
160         require(_value <= allowed[_from][msg.sender]);
161 
162         balances[_from] = balances[_from].sub(_value);
163         balances[_to] = balances[_to].add(_value);
164         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
165         Transfer(_from, _to, _value);
166         return true;
167     }
168 
169     /**
170      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
171      *
172      * Beware that changing an allowance with this method brings the risk that someone may use both the old
173      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
174      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
175      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
176      * @param _spender The address which will spend the funds.
177      * @param _value The amount of tokens to be spent.
178      */
179     function approve(address _spender, uint256 _value) public returns (bool) {
180         allowed[msg.sender][_spender] = _value;
181         Approval(msg.sender, _spender, _value);
182         return true;
183     }
184 
185     /**
186      * @dev Function to check the amount of tokens that an owner allowed to a spender.
187      * @param _owner address The address which owns the funds.
188      * @param _spender address The address which will spend the funds.
189      * @return A uint256 specifying the amount of tokens still available for the spender.
190      */
191     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
192         return allowed[_owner][_spender];
193     }
194 
195     /**
196      * approve should be called when allowed[_spender] == 0. To increment
197      * allowed value is better to use this function to avoid 2 calls (and wait until
198      * the first transaction is mined)
199      * From MonolithDAO Token.sol
200      */
201     function increaseApproval(address _spender, uint _addedValue) public returns (bool success) {
202         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
203         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
204         return true;
205     }
206 
207     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool success) {
208         uint oldValue = allowed[msg.sender][_spender];
209         if (_subtractedValue > oldValue) {
210             allowed[msg.sender][_spender] = 0;
211         } else {
212             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
213         }
214         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
215         return true;
216     }
217 
218 }
219 
220 contract SparkERC20 is StandardToken, Ownable {
221 
222     using SafeMath for uint256;
223 
224     /* Public variables of the token */
225     uint256 public creationBlock;
226 
227     uint8 public decimals;
228 
229     string public name;
230 
231     string public symbol;
232 
233     string public standard;
234 
235     bool public locked;
236 
237     /* Initializes contract with initial supply tokens to the creator of the contract */
238     function SparkERC20(
239         uint256 _totalSupply,
240         string _tokenName,
241         uint8 _decimalUnits,
242         string _tokenSymbol,
243         bool _transferAllSupplyToOwner,
244         bool _locked
245     ) public {
246         standard = "ERC20 0.1";
247         locked = _locked;
248         totalSupply = _totalSupply;
249 
250         if (_transferAllSupplyToOwner) {
251             balances[msg.sender] = totalSupply;
252         } else {
253             balances[this] = totalSupply;
254         }
255         name = _tokenName;
256         // Set the name for display purposes
257         symbol = _tokenSymbol;
258         // Set the symbol for display purposes
259         decimals = _decimalUnits;
260         // Amount of decimals for display purposes
261         creationBlock = block.number;
262     }
263 
264     /* public methods */
265     function transfer(address _to, uint256 _value) public returns (bool) {
266         require(locked == false);
267         return super.transfer(_to, _value);
268     }
269 
270     function approve(address _spender, uint256 _value) public returns (bool success) {
271         if (locked) {
272             return false;
273         }
274         return super.approve(_spender, _value);
275     }
276 
277     function increaseApproval(address _spender, uint _addedValue) public returns (bool success) {
278         if (locked) {
279             return false;
280         }
281         return super.increaseApproval(_spender, _addedValue);
282     }
283 
284     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool success) {
285         if (locked) {
286             return false;
287         }
288         return super.decreaseApproval(_spender, _subtractedValue);
289     }
290 
291     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
292         if (locked) {
293             return false;
294         }
295 
296         return super.transferFrom(_from, _to, _value);
297     }
298 
299 }
300 
301 /*
302 This contract manages the minters and the modifier to allow mint to happen only if called by minters
303 This contract contains basic minting functionality though
304 */
305 contract MintingERC20 is SparkERC20 {
306 
307     // Variables
308     uint256 public maxSupply;
309 
310     mapping (address => bool) public minters;
311 
312     // Modifiers
313     modifier onlyMinters() {
314         require(true == minters[msg.sender]);
315         _;
316     }
317 
318     function MintingERC20(
319         uint256 _initialSupply,
320         uint256 _maxSupply,
321         string _tokenName,
322         uint8 _decimals,
323         string _symbol,
324         bool _transferAllSupplyToOwner,
325         bool _locked
326     ) public SparkERC20(
327         _initialSupply,
328         _tokenName,
329         _decimals,
330         _symbol,
331         _transferAllSupplyToOwner,
332         _locked
333     )
334     {
335         standard = "MintingERC20 0.1";
336         minters[msg.sender] = true;
337         maxSupply = _maxSupply;
338     }
339 
340     function addMinter(address _newMinter) public onlyOwner {
341         minters[_newMinter] = true;
342     }
343 
344     function removeMinter(address _minter) public onlyOwner {
345         minters[_minter] = false;
346     }
347 
348     function mint(address _addr, uint256 _amount) public onlyMinters returns (uint256) {
349         if (_amount == uint256(0)) {
350             return uint256(0);
351         }
352 
353         if (totalSupply.add(_amount) > maxSupply) {
354             return uint256(0);
355         }
356 
357         totalSupply = totalSupply.add(_amount);
358         balances[_addr] = balances[_addr].add(_amount);
359         Transfer(address(0), _addr, _amount);
360 
361         return _amount;
362     }
363 
364 }
365 
366 contract Spark is MintingERC20 {
367 
368     ICO public ico;
369 
370     SparkDividends public dividends;
371 
372     bool public transferFrozen = true;
373 
374     function Spark(
375         string _tokenName,
376         uint8 _decimals,
377         string _symbol,
378         uint256 _maxSupply,
379         bool _locked
380     ) public MintingERC20(0, _maxSupply, _tokenName, _decimals, _symbol, false, _locked)
381     {
382         standard = "Spark 0.1";
383     }
384 
385     function setICO(address _ico) public onlyOwner {
386         require(_ico != address(0));
387         ico = ICO(_ico);
388     }
389 
390     function setSparkDividends(address _dividends) public onlyOwner {
391         require(address(0) != _dividends);
392         dividends = SparkDividends(_dividends);
393     }
394 
395     function setLocked(bool _locked) public onlyOwner {
396         locked = _locked;
397     }
398 
399     // prevent manual minting tokens when ICO is active;
400     function mint(address _addr, uint256 _amount) public onlyMinters returns (uint256) {
401         uint256 mintedAmount;
402         if (msg.sender == owner) {
403             require(address(ico) != address(0));
404             if (!ico.isActive() && block.timestamp >= ico.startTime()) {
405                 mintedAmount = super.mint(_addr, _amount);
406             }
407         } else {
408             mintedAmount = super.mint(_addr, _amount);
409         }
410 
411         if (mintedAmount == _amount) {
412             require(address(dividends) != address(0));
413             dividends.logAccount(_addr, _amount);
414         }
415 
416         return mintedAmount;
417     }
418 
419     // Allow token transfer.
420     function freezing(bool _transferFrozen) public onlyOwner {
421         if (address(ico) != address(0) && !ico.isActive() && block.timestamp >= ico.startTime()) {
422             transferFrozen = _transferFrozen;
423         }
424     }
425 
426     // ERC20 functions
427     // =========================
428     function transfer(address _to, uint _value) public returns (bool) {
429         require(!transferFrozen);
430 
431         bool status = super.transfer(_to, _value);
432         if (status) {
433             require(address(dividends) != address(0));
434             dividends.logAccount(msg.sender, 0);
435             dividends.logAccount(_to, 0);
436         }
437 
438         return status;
439     }
440 
441     function transferFrom(address _from, address _to, uint _value) public returns (bool success) {
442         require(!transferFrozen);
443 
444         bool status = super.transferFrom(_from, _to, _value);
445         if (status) {
446             require(address(dividends) != address(0));
447             dividends.logAccount(_from, 0);
448             dividends.logAccount(_to, 0);
449         }
450 
451         return status;
452 
453     }
454 
455 }
456 
457 contract WhiteList is Ownable {
458 
459     mapping (address => bool) public whitelist;
460 
461     /* events */
462     event WhitelistSet(address contributorAddress);
463 
464     event WhitelistUnset(address contributorAddress);
465 
466     modifier onlyWhitelisted() {
467         require(true == whitelist[msg.sender]);
468         _;
469     }
470 
471     function WhiteList() public {
472         whitelist[msg.sender] = true;
473     }
474 
475     function addToWhitelist(address _address) public onlyOwner {
476         whitelist[_address] = true;
477         WhitelistSet(_address);
478     }
479 
480     function removeFromWhitelist(address _address) public onlyOwner {
481         whitelist[_address] = false;
482         WhitelistUnset(_address);
483     }
484 
485 }
486 
487 contract SparkDividends is Ownable {
488 
489     using SafeMath for uint256;
490 
491     Spark public spark;
492 
493     ICO public ico;
494 
495     address public treasuryAddress;
496 
497     mapping(address => DividendData[]) public accounts;
498 
499     FundsData[] public funds;
500 
501     struct DividendData {
502         uint256 period;
503         uint256 day;
504         uint256 balance;
505     }
506 
507     struct FundsData {
508         uint256 period;
509         uint256 ethersAmount;
510     }
511 
512     event Disbursed(address indexed holder, uint256 value);
513 
514     modifier onlySparkContracts() {
515         require(msg.sender == address(spark) || msg.sender == address(ico));
516         _;
517     }
518 
519     function SparkDividends(
520         address _spark,
521         address _ico,
522         address _treasuryAddress
523     ) public {
524         require(_spark != address(0) && _ico != address(0) && _treasuryAddress != address(0));
525         spark = Spark(_spark);
526         ico = ICO(_ico);
527         treasuryAddress = _treasuryAddress;
528     }
529 
530     function setSpark(address _spark) public onlyOwner {
531         require(_spark != address(0));
532         spark = Spark(_spark);
533     }
534 
535     function setICO(address _ico) public onlyOwner {
536         require(_ico != address(0));
537         ico = ICO(_ico);
538     }
539 
540     function setTreasuryAddress(address _treasuryAddress) public onlyOwner {
541         require(_treasuryAddress != address(0));
542         treasuryAddress = _treasuryAddress;
543     }
544 
545     function transferEthers() public onlyOwner {
546         owner.transfer(this.balance);
547     }
548 
549     function logAccount(address _address, uint256 _amount) public onlySparkContracts returns (bool) {
550         uint256 day = 0;
551         uint256 period = 1;
552 
553         if (now > ico.endTime()) {
554             (period, day) = getPeriod(now);
555         }
556 
557         if (_address != address(0) && period > 0) {
558             if (day != 0 && _amount > 0) {
559                 logData(_address, period, 0, _amount);
560             }
561 
562             logData(_address, period, day, 0);
563 
564             return true;
565         }
566 
567         return false;
568     }
569 
570     function setEtherAmount() public payable returns (bool) {
571         if (msg.value == 0) {
572             return false;
573         }
574 
575         uint256 day = 0;
576         uint256 period = 1;
577 
578         if (now > ico.endTime()) {
579             (period, day) = getPeriod(now);
580         }
581 
582         uint256 index = getFundsDataIndex(period);
583 
584         if (index == funds.length) {
585             funds.push(FundsData(period, msg.value));
586         } else {
587             funds[index].ethersAmount = funds[index].ethersAmount.add(msg.value);
588         }
589 
590         return true;
591     }
592 
593     function claim() public returns (bool) {
594         uint256 currentDay;
595         uint256 currentPeriod;
596         bool status;
597         (currentPeriod, currentDay) = getPeriod(now);
598         if (currentPeriod == 1) {
599             return false;
600         }
601 
602         uint256 dividendAmount;
603         uint256 outdatedAmount;
604         (dividendAmount, outdatedAmount) = calculateAmount(msg.sender, currentPeriod, currentDay);
605 
606         if (dividendAmount == 0) {
607             return false;
608         }
609 
610         msg.sender.transfer(dividendAmount);
611 
612         if (outdatedAmount > 0) {
613             treasuryAddress.transfer(outdatedAmount);
614         }
615 
616         if (cleanDividendsData(msg.sender, currentPeriod)) {
617             Disbursed(msg.sender, dividendAmount);
618             status = true;
619         }
620 
621         require(status);
622         return true;
623     }
624 
625     function calculateAmount(
626         address _address,
627         uint256 _currentPeriod,
628         uint256 _currentDay
629     ) public view returns (uint256 totalAmount, uint256 totalOutdated) {
630         for (uint256 i = 0; i < accounts[_address].length; i++) {
631             if (accounts[_address][i].period < _currentPeriod) {
632                 uint256 index = getFundsDataIndex(accounts[_address][i].period);
633                 if (index == funds.length) {
634                     continue;
635                 }
636                 uint256 dayEthers = funds[index].ethersAmount.div(90);
637                 uint256 balance;
638                 uint256 to = 90;
639 
640                 if (
641                     accounts[_address].length > i.add(1) &&
642                     accounts[_address][i.add(1)].period == accounts[_address][i].period
643                 ) {
644                     to = accounts[_address][i.add(1)].day;
645                 }
646 
647                 for (uint256 j = accounts[_address][i].day; j < to; j++) {
648                     balance = getBalanceByDay(_address, accounts[_address][i].period, j);
649                     if (_currentPeriod.sub(accounts[_address][i].period) > 1 && _currentDay > 2) {
650                         totalOutdated = totalOutdated.add(balance.mul(dayEthers).div(spark.maxSupply()));
651                     } else {
652                         totalAmount = totalAmount.add(balance.mul(dayEthers).div(spark.maxSupply()));
653                     }
654                 }
655             }
656         }
657     }
658 
659     function logData(address _address, uint256 _period, uint256 _day, uint256 _amount) internal {
660         uint256 index = getDividendDataIndex(_address, _period, _day);
661         if (accounts[_address].length == index) {
662             accounts[_address].push(DividendData(_period, _day, spark.balanceOf(_address).sub(_amount)));
663         } else if (_amount == 0) {
664             accounts[_address][index].balance = spark.balanceOf(_address);
665         }
666     }
667 
668     function getPeriod(uint256 _time) internal view returns (uint256, uint256) {
669         uint256 day = uint(_time.sub(ico.endTime()) % 90 days).div(1 days);
670         uint256 period = _time.sub(ico.endTime()).div(90 days);
671 
672         return (++period, day);
673     }
674 
675     function cleanDividendsData(address _address, uint256 _currentPeriod) internal returns (bool) {
676         for (uint256 i = 0; i < accounts[_address].length; i++) {
677             if (accounts[_address][i].period < _currentPeriod) {
678                 for (uint256 j = i; j < accounts[_address].length.sub(1); j++) {
679                     DividendData storage dividend = accounts[_address][j];
680 
681                     dividend.period = accounts[_address][j.add(1)].period;
682                     dividend.day = accounts[_address][j.add(1)].day;
683                     dividend.balance = accounts[_address][j.add(1)].balance;
684                 }
685                 delete accounts[_address][accounts[_address].length.sub(1)];
686                 accounts[_address].length--;
687                 i--;
688             }
689         }
690 
691         return true;
692     }
693 
694     function getFundsDataIndex(uint256 _period) internal view returns (uint256) {
695         for (uint256 i = 0; i < funds.length; i++) {
696             if (funds[i].period == _period) {
697                 return i;
698             }
699         }
700 
701         return funds.length;
702     }
703 
704     function getBalanceByDay(address _address, uint256 _period, uint256 _day) internal view returns (uint256) {
705         for (uint256 i = accounts[_address].length.sub(1); i >= 0; i--) {
706             if (accounts[_address][i].period == _period && accounts[_address][i].day <= _day) {
707                 return accounts[_address][i].balance;
708             }
709         }
710 
711         return 0;
712     }
713 
714     function getDividendDataIndex(address _address, uint256 _period, uint256 _day) internal view returns (uint256) {
715         for (uint256 i = 0; i < accounts[_address].length; i++) {
716             if (accounts[_address][i].period == _period && accounts[_address][i].day == _day) {
717                 return i;
718             }
719         }
720 
721         return accounts[_address].length;
722     }
723 
724 }
725 
726 contract Multivest is Ownable {
727     /* public variables */
728     mapping (address => bool) public allowedMultivests;
729 
730     /* events */
731     event MultivestSet(address multivest);
732 
733     event MultivestUnset(address multivest);
734 
735     event Contribution(address holder, uint256 value, uint256 tokens);
736 
737     modifier onlyAllowedMultivests(address _addresss) {
738         require(allowedMultivests[_addresss] == true);
739         _;
740     }
741 
742     /* constructor */
743     function Multivest(address _multivest) public {
744         allowedMultivests[_multivest] = true;
745     }
746 
747     function setAllowedMultivest(address _address) public onlyOwner {
748         allowedMultivests[_address] = true;
749         MultivestSet(_address);
750     }
751 
752     function unsetAllowedMultivest(address _address) public onlyOwner {
753         allowedMultivests[_address] = false;
754         MultivestUnset(_address);
755     }
756 
757     function multivestBuy(address _address, uint256 _value) public onlyAllowedMultivests(msg.sender) {
758         require(buy(_address, _value) == true);
759     }
760 
761     function multivestBuy(
762         address _address,
763         uint8 _v,
764         bytes32 _r,
765         bytes32 _s
766     ) public payable onlyAllowedMultivests(verify(keccak256(msg.sender), _v, _r, _s)) {
767         require(_address == msg.sender && buy(msg.sender, msg.value) == true);
768     }
769 
770     function verify(bytes32 _hash, uint8 _v, bytes32 _r, bytes32 _s) internal pure returns(address) {
771         bytes memory prefix = "\x19Ethereum Signed Message:\n32";
772 
773         return ecrecover(keccak256(prefix, _hash), _v, _r, _s);
774     }
775 
776     function buy(address _address, uint256 value) internal returns (bool);
777 
778 }
779 
780 contract SellableToken is Multivest {
781 
782     using SafeMath for uint256;
783 
784     // The token being sold
785     Spark public spark;
786 
787     // start and end timestamps where investments are allowed (both inclusive)
788     uint256 public startTime;
789     uint256 public endTime;
790 
791     // amount of sold tokens
792     uint256 public soldTokens;
793 
794     // amount of raised money in wei
795     uint256 public collectedEthers;
796 
797     // address where funds are collected
798     address public etherHolder;
799 
800     address public tokensHolder;
801 
802     Bonus[] public bonuses;
803 
804     struct Bonus {
805         uint256 maxAmount;
806         uint256 bonus;
807     }
808 
809     function SellableToken(
810         address _multivestAddress,
811         address _etherHolder,
812         address _tokensHolder,
813         address _spark,
814         uint256 _startTime,
815         uint256 _endTime
816     ) public Multivest(_multivestAddress)
817     {
818         require(_spark != address(0) && _etherHolder != address(0) && _tokensHolder != address(0));
819         spark = Spark(_spark);
820         etherHolder = _etherHolder;
821         tokensHolder = _tokensHolder;
822 
823         require(_startTime < _endTime);
824 
825         startTime = _startTime;
826         endTime = _endTime;
827     }
828 
829     function setSpark(address _spark) public onlyOwner {
830         require(_spark != address(0));
831         spark = Spark(_spark);
832     }
833 
834     function setEtherHolder(address _etherHolder) public onlyOwner {
835         require(_etherHolder != address(0));
836         etherHolder = _etherHolder;
837     }
838 
839     function setTokenHolder(address _tokensHolder) public onlyOwner {
840         require(_tokensHolder != address(0));
841         tokensHolder = _tokensHolder;
842     }
843 
844     function transferEthers() public onlyOwner {
845         etherHolder.transfer(this.balance);
846     }
847 
848     // @return true if sale period is active
849     function isActive() public constant returns (bool) {
850         if (soldTokens == spark.maxSupply()) {
851             return false;
852         }
853         return withinPeriod();
854     }
855 
856     // @return true if the transaction can buy tokens
857     function withinPeriod() public constant returns (bool) {
858         return block.timestamp >= startTime && block.timestamp <= endTime;
859     }
860 }
861 
862 contract ICO is SellableToken, WhiteList {
863 
864     uint256 public price;
865 
866     function ICO(
867         address _multivestAddress,
868         address _etherHolder,
869         address _tokensHolder,
870         address _spark,
871         uint256 _startTime,
872         uint256 _endTime,
873         uint256 _price
874     ) public SellableToken(
875         _multivestAddress,
876         _etherHolder,
877         _tokensHolder,
878         _spark,
879         _startTime,
880         _endTime
881     ) WhiteList() {
882         require(_price > 0);
883         price = _price;
884 
885         bonuses.push(Bonus(uint(10000000).mul(uint(10) ** spark.decimals()), uint256(150)));
886         bonuses.push(Bonus(uint(15000000).mul(uint(10) ** spark.decimals()), uint256(125)));
887         bonuses.push(Bonus(uint(20000000).mul(uint(10) ** spark.decimals()), uint256(110)));
888     }
889 
890     function() public payable onlyWhitelisted {
891         require(buy(msg.sender, msg.value) == true);
892     }
893 
894     function allocateUnsoldTokens() public {
895         if (!isActive() && block.timestamp >= startTime) {
896             uint256 amount = spark.maxSupply().sub(soldTokens);
897             require(amount > 0 && spark.mint(tokensHolder, amount) == amount);
898             soldTokens = spark.maxSupply();
899         }
900     }
901 
902     function calculateTokensAmount(uint256 _value) public view returns (uint256 amount) {
903         amount = _value.mul(uint(10) ** spark.decimals()).div(price);
904         amount = amount.add(calculateBonusAmount(amount));
905     }
906 
907     function calculateEthersAmount(uint256 _tokens) public view returns (uint256 ethers, uint256 bonus) {
908         if (_tokens == 0) {
909             return (0, 0);
910         }
911 
912         ethers = _tokens.mul(price).div(uint(10) ** spark.decimals());
913         bonus = calculateBonusAmount(_tokens);
914     }
915 
916     function buy(address _address, uint256 _value) internal returns (bool) {
917         if (_value == 0) {
918             return false;
919         }
920 
921         require(withinPeriod() && _address != address(0));
922 
923         uint256 amount = calculateTokensAmount(_value);
924 
925         require(amount > 0 && spark.mint(_address, amount) == amount);
926 
927         collectedEthers = collectedEthers.add(_value);
928         soldTokens = soldTokens.add(amount);
929 
930         Contribution(_address, _value, amount);
931 
932         return true;
933     }
934 
935     function calculateBonusAmount(uint256 _amount) internal view returns (uint256) {
936         uint256 newSoldTokens = soldTokens;
937         uint256 remainingValue = _amount;
938 
939         for (uint i = 0; i < bonuses.length; i++) {
940 
941             if (bonuses[i].maxAmount > soldTokens) {
942                 uint256 amount = remainingValue.mul(bonuses[i].bonus).div(100);
943                 if (newSoldTokens.add(amount) > bonuses[i].maxAmount) {
944                     uint256 diff = bonuses[i].maxAmount.sub(newSoldTokens);
945                     remainingValue = remainingValue.sub(diff.mul(100).div(bonuses[i].bonus));
946                     newSoldTokens = newSoldTokens.add(diff);
947                 } else {
948                     remainingValue = 0;
949                     newSoldTokens = newSoldTokens.add(amount);
950                 }
951 
952                 if (remainingValue == 0) {
953                     break;
954                 }
955             }
956         }
957 
958         return newSoldTokens.add(remainingValue).sub(soldTokens.add(_amount));
959     }
960 
961 }