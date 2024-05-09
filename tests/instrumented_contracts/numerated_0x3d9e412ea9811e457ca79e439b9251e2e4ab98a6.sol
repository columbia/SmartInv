1 pragma solidity ^0.4.17;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9         if (a == 0) {
10             return 0;
11         }
12         uint256 c = a * b;
13         assert(c / a == b);
14         return c;
15     }
16 
17     function div(uint256 a, uint256 b) internal pure returns (uint256) {
18         // assert(b > 0); // Solidity automatically throws when dividing by 0
19         uint256 c = a / b;
20         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
21         return c;
22     }
23 
24     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
25         assert(b <= a);
26         return a - b;
27     }
28 
29     function add(uint256 a, uint256 b) internal pure returns (uint256) {
30         uint256 c = a + b;
31         assert(c >= a);
32         return c;
33     }
34 }
35 
36 /**
37  * @title Ownable
38  * @dev The Ownable contract has an owner address, and provides basic authorization control
39  * functions, this simplifies the implementation of "user permissions".
40  */
41 contract Ownable {
42     address public owner;
43 
44     /**
45       * @dev The Ownable constructor sets the original `owner` of the contract to the sender
46       * account.
47       */
48     constructor() public {
49         owner = msg.sender;
50     }
51 
52     /**
53       * @dev Throws if called by any account other than the owner.
54       */
55     modifier onlyOwner() {
56         require(msg.sender == owner);
57         _;
58     }
59 
60     /**
61     * @dev Allows the current owner to transfer control of the contract to a newOwner.
62     * @param newOwner The address to transfer ownership to.
63     */
64     function transferOwnership(address newOwner) public onlyOwner {
65         if (newOwner != address(0)) {
66             owner = newOwner;
67         }
68     }
69 
70 }
71 
72 /**
73  * @title ERC20Basic
74  * @dev Simpler version of ERC20 interface
75  * @dev see https://github.com/ethereum/EIPs/issues/20
76  */
77 contract ERC20Basic {
78     uint public totalSupplyNum;
79 
80     function totalSupply() public constant returns (uint);
81 
82     function balanceOf(address who) public constant returns (uint);
83 
84     function transfer(address to, uint value) public;
85 
86     event Transfer(address indexed from, address indexed to, uint value);
87 }
88 
89 /**
90  * @title ERC20 interface
91  * @dev see https://github.com/ethereum/EIPs/issues/20
92  */
93 contract ERC20 is ERC20Basic {
94     function allowance(address owner, address spender) public constant returns (uint);
95 
96     function transferFrom(address from, address to, uint value) public;
97 
98     function approve(address spender, uint value) public;
99 
100     event Approval(address indexed owner, address indexed spender, uint value);
101 }
102 
103 /**
104  * @title Basic token
105  * @dev Basic version of StandardToken, with no allowances.
106  */
107 contract BasicToken is Ownable, ERC20Basic {
108     using SafeMath for uint;
109 
110     mapping(address => uint) public balances;
111 
112     // additional variables for use if transaction fees ever became necessary
113     uint public basisPointsRate = 0;
114     uint public maximumFee = 0;
115 
116     /**
117     * @dev Fix for the ERC20 short address attack.
118     */
119     modifier onlyPayloadSize(uint size) {
120         require(!(msg.data.length < size + 4));
121         _;
122     }
123 
124     /**
125     * @dev transfer token for a specified address
126     * @param _to The address to transfer to.
127     * @param _value The amount to be transferred.
128     */
129     function transfer(address _to, uint _value) public onlyPayloadSize(2 * 32) {
130         uint fee = (_value.mul(basisPointsRate)).div(10000);
131         if (fee > maximumFee) {
132             fee = maximumFee;
133         }
134         uint sendAmount = _value.sub(fee);
135         balances[msg.sender] = balances[msg.sender].sub(_value);
136         balances[_to] = balances[_to].add(sendAmount);
137         if (fee > 0) {
138             balances[owner] = balances[owner].add(fee);
139             emit Transfer(msg.sender, owner, fee);
140         }
141         emit Transfer(msg.sender, _to, sendAmount);
142     }
143 
144     /**
145     * @dev Gets the balance of the specified address.
146     * @param _owner The address to query the the balance of.
147     * @return An uint representing the amount owned by the passed address.
148     */
149     function balanceOf(address _owner) public constant returns (uint balance) {
150         return balances[_owner];
151     }
152 
153 }
154 
155 /**
156  * @title Standard ERC20 token
157  *
158  * @dev Implementation of the basic standard token.
159  * @dev https://github.com/ethereum/EIPs/issues/20
160  * @dev Based oncode by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
161  */
162 contract StandardToken is BasicToken, ERC20 {
163 
164     mapping(address => mapping(address => uint)) public allowed;
165 
166     uint public constant MAX_UINT = 2 ** 256 - 1;
167 
168     /**
169     * @dev Transfer tokens from one address to another
170     * @param _from address The address which you want to send tokens from
171     * @param _to address The address which you want to transfer to
172     * @param _value uint the amount of tokens to be transferred
173     */
174     function transferFrom(address _from, address _to, uint _value) public onlyPayloadSize(3 * 32) {
175         uint _allowance = allowed[_from][msg.sender];
176 
177         // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
178         // if (_value > _allowance) throw;
179 
180         uint fee = (_value.mul(basisPointsRate)).div(10000);
181         if (fee > maximumFee) {
182             fee = maximumFee;
183         }
184         if (_allowance < MAX_UINT) {
185             allowed[_from][msg.sender] = _allowance.sub(_value);
186         }
187         uint sendAmount = _value.sub(fee);
188         balances[_from] = balances[_from].sub(_value);
189         balances[_to] = balances[_to].add(sendAmount);
190         if (fee > 0) {
191             balances[owner] = balances[owner].add(fee);
192             emit Transfer(_from, owner, fee);
193         }
194         emit Transfer(_from, _to, sendAmount);
195     }
196 
197     /**
198     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
199     * @param _spender The address which will spend the funds.
200     * @param _value The amount of tokens to be spent.
201     */
202     function approve(address _spender, uint _value) public onlyPayloadSize(2 * 32) {
203 
204         // To change the approve amount you first have to reduce the addresses`
205         //  allowance to zero by calling `approve(_spender, 0)` if it is not
206         //  already 0 to mitigate the race condition described here:
207         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
208         require(!((_value != 0) && (allowed[msg.sender][_spender] != 0)));
209 
210         allowed[msg.sender][_spender] = _value;
211         emit Approval(msg.sender, _spender, _value);
212     }
213 
214     /**
215     * @dev Function to check the amount of tokens than an owner allowed to a spender.
216     * @param _owner address The address which owns the funds.
217     * @param _spender address The address which will spend the funds.
218     * @return A uint specifying the amount of tokens still available for the spender.
219     */
220     function allowance(address _owner, address _spender) public constant returns (uint remaining) {
221         return allowed[_owner][_spender];
222     }
223 
224 }
225 
226 contract BlackList is Ownable, BasicToken {
227 
228     /////// Getters to allow the same blacklist to be used also by other contracts (including upgraded Tether) ///////
229     function getBlackListStatus(address _maker) external constant returns (bool) {
230         return isBlackListed[_maker];
231     }
232 
233     function getOwner() external constant returns (address) {
234         return owner;
235     }
236 
237     mapping(address => bool) public isBlackListed;
238 
239     function addBlackList(address _evilUser) public onlyOwner {
240         isBlackListed[_evilUser] = true;
241         emit AddedBlackList(_evilUser);
242     }
243 
244     function removeBlackList(address _clearedUser) public onlyOwner {
245         isBlackListed[_clearedUser] = false;
246         emit RemovedBlackList(_clearedUser);
247     }
248 
249     function destroyBlackFunds(address _blackListedUser) public onlyOwner {
250         require(isBlackListed[_blackListedUser]);
251         uint dirtyFunds = balanceOf(_blackListedUser);
252         balances[_blackListedUser] = 0;
253         totalSupplyNum -= dirtyFunds;
254         emit DestroyedBlackFunds(_blackListedUser, dirtyFunds);
255     }
256 
257     event DestroyedBlackFunds(address _blackListedUser, uint _balance);
258 
259     event AddedBlackList(address _user);
260 
261     event RemovedBlackList(address _user);
262 
263 }
264 
265 /// @dev Models a uint -> uint mapping where it is possible to iterate over all keys.
266 contract IterableMapping
267 {
268     struct itmap
269     {
270         mapping(address => Account) data;
271         KeyFlag[] keys;
272         uint size;
273     }
274 
275     struct Account {
276         uint keyIndex;
277         address parentAddress;
278         bool active;
279     }
280 
281     struct KeyFlag {address key; bool deleted;}
282 
283     function insert(itmap storage self, address key, address parentAddress, bool active) internal returns (bool replaced)
284     {
285         uint keyIndex = self.data[key].keyIndex;
286         self.data[key].parentAddress = parentAddress;
287         self.data[key].active = active;
288 
289         if (keyIndex > 0)
290             return true;
291         else
292         {
293             keyIndex = self.keys.length++;
294             self.data[key].keyIndex = keyIndex + 1;
295             self.keys[keyIndex].key = key;
296             self.size++;
297             return false;
298         }
299     }
300 
301     function remove(itmap storage self, address key) internal returns (bool success)
302     {
303         uint keyIndex = self.data[key].keyIndex;
304         if (keyIndex == 0)
305             return false;
306         delete self.data[key];
307         self.keys[keyIndex - 1].deleted = true;
308         self.size --;
309         return true;
310     }
311 
312     function contains(itmap storage self, address key) internal view returns (bool)
313     {
314         return self.data[key].keyIndex > 0;
315     }
316 
317     function index(itmap storage self, address key) internal view returns (uint) {
318         return self.data[key].keyIndex;
319     }
320 
321     function iterate_start(itmap storage self) internal view returns (uint keyIndex)
322     {
323         return iterate_next(self, uint(- 1));
324     }
325 
326     function iterate_valid(itmap storage self, uint keyIndex) internal view returns (bool)
327     {
328         return keyIndex < self.keys.length;
329     }
330 
331     function iterate_next(itmap storage self, uint keyIndex) internal view returns (uint r_keyIndex)
332     {
333         keyIndex++;
334         while (keyIndex < self.keys.length && self.keys[keyIndex].deleted)
335             keyIndex++;
336         return keyIndex;
337     }
338 
339     function iterate_get(itmap storage self, uint keyIndex) internal view returns (address accountAddress, address parentAddress, bool active)
340     {
341         accountAddress = self.keys[keyIndex].key;
342         parentAddress = self.data[accountAddress].parentAddress;
343         active = self.data[accountAddress].active;
344     }
345 }
346 
347 
348 contract CtgToken is StandardToken, BlackList, IterableMapping {
349     string public name;
350     string public symbol;
351     uint public decimals;
352 
353     address public pool = 0x9492D2F14d6d4D562a9DA4793b347f2AaB3B607A; //矿池地址
354     address public teamAddress = 0x45D1c050C458de9b18104bdFb7ddEbA510f6D9f2; //研发团队地址
355     address public peer = 0x87dfEFFa31950584d6211D6A7871c3AdA2157aE1; //节点分红
356     address public foundation0 = 0x6eDFEaB0D0B6BD3d6848A3556B2753f53b182cCd;
357     address public foundation1 = 0x5CD65995e25EC1D73EcDBc61D4cF32238304D1eA;
358     address public foundation2 = 0x7D1E3dD3c5459BAdA93C442442D4072116e21034;
359     address public foundation3 = 0x5001c2917B18B18853032C3e944Fe512532E0FD1;
360     address public foundation4 = 0x9c131257919aE78B746222661076CF781a8FF7c6;
361     address public candy = 0x279C18756568B8717e915FfB8eFe2784abCb89cf;
362     address public contractAddress = 0x81E98EfF052837f7c1Dceb8947d08a2b908E8793;
363     uint public recommendNum;
364 
365     itmap accounts;
366 
367     mapping(uint => uint) public shareRate;
368     mapping(address => uint8) public levels;
369     mapping(uint => uint) public levelProfit;
370 
371     struct StaticProfit {
372         uint num;
373         uint8 day;
374         uint8 rate;
375     }
376 
377     mapping(uint => StaticProfit) public profits;
378     mapping(address => AddressInfo) public addressInfos;
379 
380     struct AddressInfo {
381         address[] children;
382         address _address;
383         uint[] profitsIndex;
384         bool activated;
385     }
386 
387     struct ProfitLog {
388         address _address;
389         uint levelNum;
390         uint num;
391         uint8 day;
392         uint8 rate;
393         uint8 getDay;
394         uint updatedAt;
395     }
396 
397     mapping(uint => ProfitLog) public profitLogs;
398     uint logIndex = 0;
399 
400     constructor(string _name, string _symbol, uint _decimals) public {
401         totalSupplyNum = formatDecimals(720000000);
402         name = _name;
403         symbol = _symbol;
404         decimals = _decimals;
405 
406         balances[pool] = formatDecimals(540000000);
407         balances[teamAddress] = formatDecimals(64800000);
408         balances[peer] = formatDecimals(43200000);
409         balances[foundation0] = formatDecimals(10080000);
410         balances[foundation1] = formatDecimals(10080000);
411         balances[foundation2] = formatDecimals(10080000);
412         balances[foundation3] = formatDecimals(10080000);
413         balances[foundation4] = formatDecimals(10080000);
414         balances[candy] = formatDecimals(21600000);
415 
416         //推广收益比例
417         shareRate[1] = 7;
418         shareRate[2] = 5;
419         shareRate[3] = 3;
420         shareRate[4] = 2;
421         shareRate[5] = 1;
422         shareRate[6] = 1;
423         shareRate[7] = 1;
424         shareRate[8] = 1;
425         shareRate[9] = 1;
426         shareRate[10] = 1;
427 
428         //等级奖励
429         levelProfit[1] = formatDecimals(1000);
430         levelProfit[2] = formatDecimals(3000);
431         levelProfit[3] = formatDecimals(10000);
432         levelProfit[4] = formatDecimals(50000);
433         levelProfit[5] = formatDecimals(100000);
434 
435         //合约收益配置
436         profits[formatDecimals(100)] = StaticProfit(formatDecimals(100), 30, 10);
437         profits[formatDecimals(1000)] = StaticProfit(formatDecimals(1000), 30, 15);
438         profits[formatDecimals(5000)] = StaticProfit(formatDecimals(5000), 30, 20);
439         profits[formatDecimals(10000)] = StaticProfit(formatDecimals(10000), 30, 25);
440         profits[formatDecimals(30000)] = StaticProfit(formatDecimals(30000), 30, 30);
441 
442         recommendNum = formatDecimals(23).div(10);
443     }
444 
445     function setLevelProfit(uint level, uint num) public onlyOwner {
446         require(levelProfit[level] > 0, "The level config doesn't exist!");
447         levelProfit[level] = formatDecimals(num);
448     }
449 
450     function setRecommendNum(uint num) public onlyOwner {
451         require(recommendNum != num, "The value is equal old value!");
452         recommendNum = num;
453     }
454 
455 
456     function setShareRateConfig(uint level, uint rate) public onlyOwner {
457         require(shareRate[level] > 0, "This level does not exist");
458 
459         uint oldRate = shareRate[level];
460         shareRate[level] = rate;
461 
462         emit SetShareRateConfig(level, oldRate, rate);
463     }
464 
465     function getProfitLevelNum(uint num) internal constant returns(uint) {
466         if (num < formatDecimals(100)) {
467             return 0;
468         }
469         if (num >=formatDecimals(100) && num < formatDecimals(1000)) {
470             return formatDecimals(100);
471         }
472         if (num >=formatDecimals(1000) && num < formatDecimals(5000)) {
473             return formatDecimals(1000);
474         }
475         if (num >=formatDecimals(5000) && num < formatDecimals(10000)) {
476             return formatDecimals(5000);
477         }
478         if (num >=formatDecimals(10000) && num < formatDecimals(30000)) {
479             return formatDecimals(10000);
480         }
481         if (num >=formatDecimals(30000)) {
482             return formatDecimals(30000);
483         }
484     }
485 
486     function getAddressProfitLevel(address _address) public constant returns (uint) {
487         uint maxLevel = 0;
488         uint[] memory indexes = addressInfos[_address].profitsIndex;
489         for (uint i=0; i<indexes.length; i++) {
490             uint k = indexes[i];
491             if (profitLogs[k].day > 0 && (profitLogs[k].day > profitLogs[k].getDay) && (profitLogs[k].levelNum > maxLevel)) {
492                 maxLevel = profitLogs[k].levelNum;
493             }
494         }
495         return maxLevel;
496     }
497 
498     function getAddressProfitNum(address _address) public constant returns (uint) {
499         uint num = 0;
500         uint[] memory indexes = addressInfos[_address].profitsIndex;
501         for (uint i=0; i<indexes.length; i++) {
502             uint k = indexes[i];
503             if (profitLogs[k].day > 0 && (profitLogs[k].day > profitLogs[k].getDay)) {
504                 num += profitLogs[k].num;
505             }
506         }
507 
508         return num;
509     }
510 
511     function getAddressActiveChildrenCount(address _address) public constant returns (uint) {
512         uint num  = 0;
513         for(uint i=0; i<addressInfos[_address].children.length; i++) {
514             address child = addressInfos[_address].children[i];
515             AddressInfo memory childInfo = addressInfos[child];
516             if (childInfo.activated) {
517                 num++;
518             }
519         }
520 
521         return num;
522     }
523 
524 
525     function setProfitConfig(uint256 num, uint8 day, uint8 rate) public onlyOwner {
526         require(profits[formatDecimals(num)].num>0, "This profit config not exist");
527         profits[formatDecimals(num)] = StaticProfit(formatDecimals(num), day, rate);
528 
529         emit SetProfitConfig(num, day, rate);
530     }
531 
532     function formatDecimals(uint256 _value) internal view returns (uint256) {
533         return _value * 10 ** decimals;
534     }
535 
536     function parent(address _address) public view returns (address) {
537         return accounts.data[_address].parentAddress;
538     }
539 
540     function checkIsCycle(address _child, address _parent) internal view returns (bool) {
541         address t = _parent;
542         while (t != address(0)) {
543             if (t == _child) {
544                 return true;
545             }
546             t = parent(t);
547         }
548         return false;
549     }
550 
551     function iterate_start() public view returns (uint keyIndex) {
552         return super.iterate_start(accounts);
553     }
554 
555     function iterate_next(uint keyIndex) public view returns (uint r_keyIndex)
556     {
557         return super.iterate_next(accounts, keyIndex);
558     }
559 
560     function iterate_valid(uint keyIndex) public view returns (bool) {
561         return super.iterate_valid(accounts, keyIndex);
562     }
563 
564     function iterate_get(uint keyIndex) public view returns (address accountAddress, address parentAddress, bool active) {
565         (accountAddress, parentAddress, active) = super.iterate_get(accounts, keyIndex);
566     }
567 
568     function sendBuyShare(address _address, uint _value) internal  {
569         address p = parent(_address);
570         uint level = 1;
571 
572         while (p != address(0) && level <= 10) {
573             uint activeChildrenNum = getAddressActiveChildrenCount(p);
574             if (activeChildrenNum < level) {
575                 p = parent(p);
576                 level = level + 1;
577                 continue;
578             }
579 
580             AddressInfo storage info = addressInfos[p];
581             if (!info.activated) {
582                 p = parent(p);
583                 level = level + 1;
584                 continue;
585             }
586 
587             uint profitLevel = getAddressProfitLevel(p);
588 
589 
590             uint addValue = _value.mul(shareRate[level]).div(100);
591             if (_value > profitLevel) {
592                 addValue = profitLevel.mul(shareRate[level]).div(100);
593             }
594 
595 
596             transferFromPool(p, addValue);
597             emit BuyShare(msg.sender, p, addValue);
598             p = parent(p);
599             level = level + 1;
600         }
601     }
602 
603     function releaseProfit(uint index) public onlyOwner {
604         ProfitLog memory log = profitLogs[index];
605         if (log.day == 0 || log.day == log.getDay) {
606             return;
607         }
608         uint addValue = log.num.mul(uint(log.rate).add(100)).div(100).div(uint(log.day));
609 
610         uint diffDay = 1;
611         if (log.updatedAt > 0) {
612             diffDay = now.sub(log.updatedAt).div(24*3600);
613         }
614         if (diffDay > 0) {
615             addValue = addValue.mul(diffDay);
616             transferFrom(pool, log._address, addValue);
617             profitLogs[index].getDay = log.getDay + uint8(diffDay);
618             profitLogs[index].updatedAt = now;
619 
620             emit ReleaseProfit(log._address, addValue, log.getDay+1);
621         }
622 
623     }
624 
625     function releaseAllProfit() public onlyOwner {
626         for (uint i = 0; i<logIndex; i++) {
627             releaseProfit(i);
628         }
629     }
630 
631 
632     function setLevel(address _address, uint8 level, bool sendProfit) public onlyOwner {
633         levels[_address] = level;
634 
635         emit SetLevel(_address, level);
636         if (sendProfit) {
637             uint num = levelProfit[uint(level)];
638             if (num > 0) {
639                 transferFromPool(_address, num);
640                 emit SendLevelProfit(_address, level, num);
641             }
642         }
643     }
644 
645     function transfer(address _to, uint _value) public {
646         address parentAddress = parent(msg.sender);
647         if (_value == recommendNum && parentAddress == address(0) && !checkIsCycle(msg.sender, _to)) {
648             IterableMapping.insert(accounts, msg.sender, _to, addressInfos[msg.sender].activated);
649             AddressInfo storage info = addressInfos[_to];
650             info.children.push(msg.sender);
651             super.transfer(_to, _value);
652             emit SetParent(msg.sender, _to);
653         } else if (_to == contractAddress) {
654             super.transfer(_to, _value);
655             // Static income
656             uint profitKey = getProfitLevelNum(_value);
657             StaticProfit storage profit = profits[profitKey];
658             if (profit.num > 0) {
659                 profitLogs[logIndex] = ProfitLog({_address:msg.sender, levelNum:profit.num, num : _value, day : profit.day, rate : profit.rate, getDay : 0, updatedAt: 0});
660             }
661             //activate user
662             addressInfos[msg.sender].profitsIndex.push(logIndex);
663             logIndex++;
664             if (profitKey >= 1000) {
665                 addressInfos[msg.sender].activated = true;
666                 IterableMapping.insert(accounts, msg.sender, parentAddress, true);
667             }
668             //Dynamic  income
669             if (profitKey > 0 && addressInfos[msg.sender].activated) {
670                 sendBuyShare(msg.sender, profitKey);
671             }
672 
673         } else {
674             super.transfer(_to, _value);
675         }
676     }
677 
678     function transferFromPool(address _to, uint _value) internal {
679         balances[pool] = balances[pool].sub(_value);
680         balances[_to] = balances[_to].add(_value);
681         emit Transfer(pool, _to, _value);
682     }
683 
684 
685 
686     function transferFrom(address _from, address _to, uint _value) public onlyOwner  {
687         require(!isBlackListed[_from]);
688 
689         //        var _allowance = allowed[_from][msg.sender];
690 
691         // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
692         // if (_value > _allowance) throw;
693 
694         uint fee = (_value.mul(basisPointsRate)).div(10000);
695         if (fee > maximumFee) {
696             fee = maximumFee;
697         }
698         //        if (_allowance < MAX_UINT) {
699         //            allowed[_from][msg.sender] = _allowance.sub(_value);
700         //        }
701         uint sendAmount = _value.sub(fee);
702         balances[_from] = balances[_from].sub(_value);
703         balances[_to] = balances[_to].add(sendAmount);
704         if (fee > 0) {
705             balances[owner] = balances[owner].add(fee);
706             emit Transfer(_from, owner, fee);
707         }
708         emit Transfer(_from, _to, sendAmount);
709     }
710 
711     // Forward ERC20 methods to upgraded contract if this one is deprecated
712     function balanceOf(address who) public constant returns (uint) {
713         return super.balanceOf(who);
714     }
715 
716     // Forward ERC20 methods to upgraded contract if this one is deprecated
717     function approve(address _spender, uint _value) public onlyPayloadSize(2 * 32) {
718         return super.approve(_spender, _value);
719     }
720 
721     // Forward ERC20 methods to upgraded contract if this one is deprecated
722     function allowance(address _owner, address _spender) public constant returns (uint remaining) {
723         return super.allowance(_owner, _spender);
724     }
725 
726     // deprecate current contract if favour of a new one
727     function totalSupply() public constant returns (uint) {
728         return totalSupplyNum;
729     }
730 
731 
732     event SetShareRateConfig(uint level, uint oldRate, uint newRate);
733     event SetProfitConfig(uint num, uint8 day, uint8 rate);
734     event SetParent(address _childAddress, address _parentAddress);
735     event SetLevel(address _address, uint8 level);
736     event SendLevelProfit(address _address, uint8 level,uint num);
737     event ReleaseProfit(address _address, uint num, uint8 day);
738     event BuyShare(address from, address to, uint num);
739 
740 }