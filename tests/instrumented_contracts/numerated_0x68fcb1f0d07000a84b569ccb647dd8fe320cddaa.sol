1 pragma solidity ^0.4.17;
2 
3 library SafeMath {
4     function add(uint a, uint b) internal pure returns (uint c) {
5         c = a + b;
6         require(c >= a);
7     }
8     function sub(uint a, uint b) internal pure returns (uint c) {
9         require(b <= a);
10         c = a - b;
11     }
12     function mul(uint a, uint b) internal pure returns (uint c) {
13         c = a * b;
14         require(a == 0 || c / a == b);
15     }
16     function div(uint a, uint b) internal pure returns (uint c) {
17         require(b > 0);
18         c = a / b;
19     }
20 }
21 
22 contract CoinMarketCapApi {
23     function requestPrice(string _ticker) public payable;
24     function _cost() public returns (uint _price);
25 }
26 
27 contract ERC20 {
28     function transfer(address to, uint tokens) public returns (bool success);
29 }
30 
31 contract DateTime {
32     using SafeMath for uint;
33     
34     uint constant SECONDS_PER_DAY = 24 * 60 * 60;
35     int constant OFFSET19700101 = 2440588;
36     
37     function _timestampToDate(uint256 _timestamp) internal pure returns (uint year, uint month, uint day) {
38         uint _days = _timestamp / SECONDS_PER_DAY;
39         int __days = int(_days);
40         
41         int L = __days + 68569 + OFFSET19700101;
42         int N = 4 * L / 146097;
43         L = L - (146097 * N + 3) / 4;
44         int _year = 4000 * (L + 1) / 1461001;
45         L = L - 1461 * _year / 4 + 31;
46         int _month = 80 * L / 2447;
47         int _day = L - 2447 * _month / 80;
48         L = _month / 11;
49         _month = _month + 2 - 12 * L;
50         _year = 100 * (N - 49) + _year + L;
51         
52         year = uint(_year);
53         month = uint(_month);
54         day = uint(_day);
55     }
56     
57     function isLeapYear(uint year) internal pure returns (bool) {
58         if (year % 4 != 0) {
59             return false;
60         }
61         if (year % 100 != 0) {
62             return true;
63         }
64         if (year % 400 != 0) {
65             return false;
66         }
67         return true;
68     }
69     
70     function getDaysInMonth(uint month, uint year, uint _addMonths) internal pure returns (uint) {
71         if(_addMonths > 0){
72             (month, year) = addMonth(month, year, _addMonths);
73         }
74         
75         if (month == 1 || month == 3 || month == 5 || month == 7 || month == 8 || month == 10 || month == 12) {
76             return 31;
77         }
78         else if (month == 4 || month == 6 || month == 9 || month == 11) {
79             return 30;
80         }
81         else if (isLeapYear(year)) {
82             return 29;
83         }
84         else {
85             return 28;
86         }
87     }
88     
89     function diffMonths(uint fromTimestamp, uint toTimestamp) internal pure returns (uint _months) {
90         require(fromTimestamp <= toTimestamp);
91         uint fromYear;
92         uint fromMonth;
93         uint fromDay;
94         uint toYear;
95         uint toMonth;
96         uint toDay;
97         (fromYear, fromMonth, fromDay) = _timestampToDate(fromTimestamp);
98         (toYear, toMonth, toDay) = _timestampToDate(toTimestamp);
99         
100         _months = (((toYear.mul(12)).add(toMonth)).sub(fromYear.mul(12))).sub(fromMonth);
101     }
102     
103     function addMonth(uint _month, uint _year, uint _add) internal pure returns (uint _nwMonth, uint _nwYear) {
104         require(_add < 12);
105         
106         if(_month + _add > 12){
107             _nwYear = _year + 1;
108             _nwMonth = 1;
109         } else {
110             _nwMonth = _month + _add;
111             _nwYear = _year;
112         }
113     }
114 }
115 
116 contract initLib is DateTime {
117     using SafeMath for uint;
118     
119     string  public symbol = "OWT";
120     uint256 public decimals = 18;
121     address public tokenAddress;
122     uint256 public tokenPrice = 150000;
123     
124     uint256 public domainCost = 500; 
125     uint256 public publishCost = 200; 
126     uint256 public hostRegistryCost = 1000; 
127     uint256 public userSurfingCost = 10; 
128     uint256 public registryDuration = 365 * 1 days;
129     uint256 public stakeLockTime = 31 * 1 days;
130     
131     uint public websiteSizeLimit = 512;
132     uint public websiteFilesLimit = 20;
133     
134     address public ow_owner;
135     address public cmcAddress;
136     uint public lastPriceUpdate;
137     
138     mapping ( address => uint256 ) public balanceOf;
139     mapping ( address => uint256 ) public stakeBalance;
140     mapping ( uint => mapping ( uint => uint256 )) public poolBalance;
141     mapping ( uint => mapping ( uint => uint256 )) public poolBalanceClaimed;
142     mapping ( uint => mapping ( uint => uint256 )) public totalStakes;
143     
144     uint256 public totalSubscriber;
145     uint256 public totalHosts;
146     uint256 public totalDomains;
147     
148     mapping ( address => UserMeta ) public users;
149     mapping ( bytes32 => DomainMeta ) public domains;
150     mapping ( bytes32 => DomainSaleMeta ) public domain_sale;
151     mapping ( address => HostMeta ) public hosts;
152     mapping ( uint => address ) public hostAddress;
153     mapping ( uint => bytes32 ) public hostConnection;
154     mapping ( bytes32 => bool ) public hostConnectionDB;
155     
156     mapping ( uint => mapping ( uint => mapping ( address => uint256 ) )) public hostStakes;
157     mapping ( uint => mapping ( uint => mapping ( address => uint256 ) )) public stakeTmpBalance;
158     mapping ( address => uint256 ) public stakesLockups;
159     
160     mapping ( uint => uint ) public hostUpdates;
161     uint public hostUpdatesCounter;
162     
163     mapping ( uint => string ) public websiteUpdates;
164     uint public websiteUpdatesCounter;
165     
166     struct DomainMeta {
167         string name;
168         uint admin_index;
169         uint total_admins;
170         mapping(uint => mapping(address => bool)) admins;
171         string git;
172         bytes32 domain_bytes;
173         bytes32 hash;
174         uint total_files;
175         uint version;
176         mapping(uint => mapping(bytes32 => bytes32)) files_hash;
177         uint ttl;
178         uint time;
179         uint expity_time;
180     }
181     
182     struct DomainSaleMeta {
183         address owner;
184         address to;
185         uint amount;
186         uint time;
187         uint expity_time;
188     }
189     
190     struct HostMeta {
191         uint id;
192         address hostAddress;
193         bytes32 connection;
194         bool active;
195         uint start_time;
196         uint time;
197     }
198     
199     struct UserMeta {
200         bool active;
201         uint start_time;
202         uint expiry_time;
203         uint time;
204     }
205     
206     function stringToBytes32(string memory source) internal pure returns (bytes32 result) {
207         bytes memory tempEmptyStringTest = bytes(source);
208         if (tempEmptyStringTest.length == 0) {
209             return 0x0;
210         }
211     
212         assembly {
213             result := mload(add(source, 32))
214         }
215     }
216     
217     function setOwOwner(address _address) public {
218         require(msg.sender == ow_owner);
219         ow_owner = _address;
220     }
221     
222     function _currentPrice(uint256 _price) public view returns (uint256 _getprice) {
223         _getprice = (_price * 10**uint(24)) / tokenPrice;
224     }
225     
226     function __response(uint _price) public {
227         require(msg.sender == cmcAddress);
228         tokenPrice = _price;
229     }
230     
231     function fetchTokenPrice() public payable {
232         require(
233             lastPriceUpdate + 1 * 1 days <  now
234         );
235         
236         lastPriceUpdate = now;
237         uint _getprice = CoinMarketCapApi(cmcAddress)._cost();
238         CoinMarketCapApi(cmcAddress).requestPrice.value(_getprice)(symbol);
239     }
240     
241     function _priceFetchingCost() public view returns (uint _getprice) {
242         _getprice = CoinMarketCapApi(cmcAddress)._cost();
243     }
244     
245     function debitToken(uint256 _amount) internal {
246         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_amount);
247         balanceOf[ow_owner] = balanceOf[ow_owner].add(_amount);
248     }
249     
250     function creditUserPool(uint _duration, uint256 _price) internal {
251         uint _monthDays; uint _remainingDays; 
252         uint _year; uint _month; uint _day; 
253         (_year, _month, _day) = _timestampToDate(now);
254         
255         _day--;
256         uint monthDiff = diffMonths(now, now + ( _duration * 1 days )) + 1;
257         
258         for(uint i = 0; i < monthDiff; i++) {
259             _monthDays = getDaysInMonth(_month, _year, 0); 
260             
261             if(_day.add(_duration) > _monthDays){ 
262                 _remainingDays = _monthDays.sub(_day);
263                 balanceOf[address(0x0)] = balanceOf[address(0x0)].add((_remainingDays * _price * 10) / 100);
264                 poolBalance[_year][_month] = poolBalance[_year][_month].add((_remainingDays * _price * 90) / 100);
265                 
266                 (_month, _year) = addMonth(_month, _year, 1);
267                 
268                 _duration = _duration.sub(_remainingDays);
269                 _day = 0;
270                 
271             } else {
272                 balanceOf[address(0x0)] = balanceOf[address(0x0)].add((_duration * _price * 10) / 100);
273                 poolBalance[_year][_month] = poolBalance[_year][_month].add((_duration * _price * 90) / 100);
274             }
275             
276         }
277     }
278 }
279 
280 contract owContract is initLib {
281     
282     function owContract(address _token, address _cmc) public {
283         tokenAddress = _token;
284         ow_owner = msg.sender;
285         cmcAddress = _cmc;
286     }
287     
288     function _validateDomain(string _domain) internal pure returns (bool){
289         bytes memory b = bytes(_domain);
290         if(b.length > 32) return false;
291         
292         uint counter = 0;
293         for(uint i; i<b.length; i++){
294             bytes1 char = b[i];
295             
296             if(
297                 !(char >= 0x30 && char <= 0x39)   //9-0
298                 && !(char >= 0x61 && char <= 0x7A)  //a-z
299                 && !(char == 0x2D) // - 
300                 && !(char == 0x2E && counter == 0) // . 
301             ){
302                     return false;
303             }
304             
305             if(char == 0x2E) counter++; 
306         }
307     
308         return true;
309     }
310     
311     function registerDomain(string _domain, uint _ttl) public returns (bool _status) {
312         bytes32 _domainBytes = stringToBytes32(_domain);
313         DomainMeta storage d = domains[_domainBytes];
314         uint256 _cPrice = _currentPrice(domainCost);
315         
316         require(
317             d.expity_time < now 
318             && _ttl >= 1 hours 
319             && balanceOf[msg.sender] >= _cPrice 
320             && _validateDomain(_domain)
321         );
322         
323         debitToken(_cPrice);
324         uint _adminIndex = d.admin_index + 1;
325         
326         if(d.expity_time == 0){
327             totalDomains++;
328         }
329         
330         d.name = _domain;
331         d.domain_bytes = _domainBytes;
332         d.admin_index = _adminIndex;
333         d.total_admins = 1;
334         d.admins[_adminIndex][msg.sender] = true;
335         d.ttl = _ttl;
336         d.expity_time = now + registryDuration;
337         d.time = now;
338         
339         _status = true;
340     }
341     
342     function updateDomainTTL(string _domain, uint _ttl) public returns (bool _status) {
343         bytes32 _domainBytes = stringToBytes32(_domain);
344         DomainMeta storage d = domains[_domainBytes];
345         require(
346             d.admins[d.admin_index][msg.sender] 
347             && _ttl >= 1 hours 
348             && d.expity_time > now
349         );
350         
351         d.ttl = _ttl;
352         _status = true;
353     }
354     
355     function renewDomain(string _domain) public returns (bool _status) {
356         bytes32 _domainBytes = stringToBytes32(_domain);
357         DomainMeta storage d = domains[_domainBytes];
358         uint256 _cPrice = _currentPrice(domainCost);
359         
360         require(
361             d.expity_time > now 
362             && balanceOf[msg.sender] >= _cPrice
363         );
364         
365         debitToken(_cPrice);
366         d.expity_time = d.expity_time.add(registryDuration);
367         
368         _status = true;
369     }
370     
371     function addDomainAdmin(string _domain, address _admin) public returns (bool _status) {
372         bytes32 _domainBytes = stringToBytes32(_domain);
373         DomainMeta storage d = domains[_domainBytes];
374         require(
375             d.admins[d.admin_index][msg.sender] 
376             && !d.admins[d.admin_index][_admin]
377             && d.expity_time > now
378         );
379         
380         d.total_admins = d.total_admins.add(1);
381         d.admins[d.admin_index][_admin] = true;
382         
383         _status = true;
384     }
385     
386     function removeDomainAdmin(string _domain, address _admin) public returns (bool _status) {
387         bytes32 _domainBytes = stringToBytes32(_domain);
388         DomainMeta storage d = domains[_domainBytes];
389         require(
390             d.admins[d.admin_index][msg.sender] 
391             && d.admins[d.admin_index][_admin] 
392             && d.expity_time > now
393         );
394         
395         d.total_admins = d.total_admins.sub(1);
396         d.admins[d.admin_index][_admin] = false;
397         
398         _status = true;
399     }
400     
401     function sellDomain(
402         string _domain, 
403         address _owner, 
404         address _to, 
405         uint256 _amount, 
406         uint _expiry
407     ) public returns (bool _status) {
408         bytes32 _domainBytes = stringToBytes32(_domain);
409         uint _sExpiry = now + ( _expiry * 1 days );
410         
411         DomainMeta storage d = domains[_domainBytes];
412         DomainSaleMeta storage ds = domain_sale[_domainBytes];
413         
414         require(
415             _amount > 0
416             && d.admins[d.admin_index][msg.sender] 
417             && d.expity_time > _sExpiry 
418             && ds.expity_time < now
419         );
420         
421         ds.owner = _owner;
422         ds.to = _to;
423         ds.amount = _amount;
424         ds.time = now;
425         ds.expity_time = _sExpiry;
426         
427         _status = true;
428     }
429     
430     function cancelSellDomain(string _domain) public returns (bool _status) {
431         bytes32 _domainBytes = stringToBytes32(_domain);
432         DomainMeta storage d = domains[_domainBytes];
433         DomainSaleMeta storage ds = domain_sale[_domainBytes];
434         
435         require(
436             d.admins[d.admin_index][msg.sender] 
437             && d.expity_time > now 
438             && ds.expity_time > now
439         );
440         
441         ds.owner = address(0x0);
442         ds.to = address(0x0);
443         ds.amount = 0;
444         ds.time = 0;
445         ds.expity_time = 0;
446         
447         _status = true;
448     }
449     
450     function buyDomain(string _domain) public returns (bool _status) {
451         bytes32 _domainBytes = stringToBytes32(_domain);
452         DomainMeta storage d = domains[_domainBytes];
453         DomainSaleMeta storage ds = domain_sale[_domainBytes];
454         
455         if(ds.to != address(0x0)){
456             require( ds.to == msg.sender );
457         }
458         
459         require(
460             balanceOf[msg.sender] >= ds.amount 
461             && d.expity_time > now 
462             && ds.expity_time > now
463         );
464         
465         balanceOf[msg.sender] = balanceOf[msg.sender].sub(ds.amount);
466         balanceOf[ds.owner] = balanceOf[ds.owner].add(ds.amount);
467         
468         uint _adminIndex = d.admin_index + 1;
469         
470         d.total_admins = 1;
471         d.admin_index = _adminIndex;
472         d.admins[_adminIndex][msg.sender] = true;
473         ds.expity_time = 0;
474         
475         _status = true;
476     }
477     
478     function publishWebsite(
479         string _domain, 
480         string _git, 
481         bytes32 _filesHash,
482         bytes32[] _file_name, 
483         bytes32[] _file_hash
484     ) public returns (bool _status) {
485         bytes32 _domainBytes = stringToBytes32(_domain);
486         DomainMeta storage d = domains[_domainBytes];
487         uint256 _cPrice = _currentPrice(publishCost);
488         
489         require(
490             d.admins[d.admin_index][msg.sender] 
491             && balanceOf[msg.sender] >= _cPrice 
492             && _file_name.length <= websiteFilesLimit 
493             && _file_name.length == _file_hash.length
494             && d.expity_time > now
495         );
496         
497         debitToken(_cPrice);
498         d.version++;
499         
500         for(uint i = 0; i < _file_name.length; i++) {
501             d.files_hash[d.version][_file_name[i]] = _file_hash[i];
502         }
503         
504         d.git = _git;
505         d.total_files = _file_name.length;
506         d.hash = _filesHash;
507         
508         websiteUpdates[websiteUpdatesCounter] = _domain;
509         websiteUpdatesCounter++;
510         
511         _status = true;
512     }
513     
514     function getDomainMeta(string _domain) public view 
515         returns (
516             string _name,  
517             string _git, 
518             bytes32 _domain_bytes, 
519             bytes32 _hash, 
520             uint _total_admins,
521             uint _adminIndex, 
522             uint _total_files, 
523             uint _version, 
524             uint _ttl, 
525             uint _time, 
526             uint _expity_time
527         )
528     {
529         bytes32 _domainBytes = stringToBytes32(_domain);
530         DomainMeta storage d = domains[_domainBytes];
531         
532         _name = d.name;
533         _git = d.git;
534         _domain_bytes = d.domain_bytes;
535         _hash = d.hash;
536         _total_admins = d.total_admins;
537         _adminIndex = d.admin_index;
538         _total_files = d.total_files;
539         _version = d.version;
540         _ttl = d.ttl;
541         _time = d.time;
542         _expity_time = d.expity_time;
543     }
544     
545     function getDomainFileHash(string _domain, bytes32 _file_name) public view 
546         returns ( 
547             bytes32 _hash
548         )
549     {
550         bytes32 _domainBytes = stringToBytes32(_domain);
551         DomainMeta storage d = domains[_domainBytes];
552         
553         _hash = d.files_hash[d.version][_file_name];
554     }
555     
556     function verifyDomainFileHash(string _domain, bytes32 _file_name, bytes32 _file_hash) public view 
557         returns ( 
558             bool _status
559         )
560     {
561         bytes32 _domainBytes = stringToBytes32(_domain);
562         DomainMeta storage d = domains[_domainBytes];
563         
564         _status = ( d.files_hash[d.version][_file_name] == _file_hash );
565     }
566     
567     function registerHost(string _connection) public returns (bool _status) {
568         bytes32 hostConn = stringToBytes32(_connection);
569         HostMeta storage h = hosts[msg.sender];
570         uint256 _cPrice = _currentPrice(hostRegistryCost);
571         
572         require(
573             !h.active 
574             && balanceOf[msg.sender] >= _cPrice 
575             && !hostConnectionDB[hostConn]
576         );
577         
578         debitToken(_cPrice);
579         
580         h.id = totalHosts;
581         h.connection = hostConn;
582         h.active = true;
583         h.time = now;
584         
585         hostAddress[totalHosts] = msg.sender;
586         hostConnection[totalHosts] = h.connection;
587         hostConnectionDB[hostConn] = true;
588         totalHosts++;
589         
590         _status = true;
591     }
592     
593     function updateHost(string _connection) public returns (bool _status) {
594         bytes32 hostConn = stringToBytes32(_connection);
595         HostMeta storage h = hosts[msg.sender];
596         
597         require(
598             h.active 
599             && h.connection != hostConn 
600             && !hostConnectionDB[hostConn]
601         );
602         
603         hostConnectionDB[h.connection] = false;
604         h.connection = hostConn;
605         
606         hostConnectionDB[hostConn] = true;
607         hostUpdates[hostUpdatesCounter] = h.id;
608         hostConnection[h.id] = hostConn;
609         hostUpdatesCounter++;
610         
611         _status = true;
612     }
613     
614     function userSubscribe(uint _duration) public {
615         uint256 _cPrice = _currentPrice(userSurfingCost);
616         uint256 _cost = _duration * _cPrice;
617         
618         require(
619             _duration < 400 
620             && _duration > 0
621             && balanceOf[msg.sender] >= _cost
622         );
623         
624         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_cost);
625         creditUserPool(_duration, _cPrice);
626         
627         UserMeta storage u = users[msg.sender];
628         if(!u.active){
629             u.active = true;
630             u.time = now;
631             
632             totalSubscriber++;
633         }
634         
635         if(u.expiry_time < now){
636             u.start_time = now;
637             u.expiry_time = now + (_duration * 1 days);
638         } else {
639             u.expiry_time = u.expiry_time.add(_duration * 1 days);
640         }
641     }
642     
643     function stakeTokens(address _hostAddress, uint256 _amount) public {
644         require( balanceOf[msg.sender] >= _amount );
645         
646         uint _year; uint _month; uint _day; 
647         (_year, _month, _day) = _timestampToDate(now);
648         
649         HostMeta storage h = hosts[_hostAddress];
650         require( h.active );
651         
652         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_amount);
653         stakeBalance[msg.sender] = stakeBalance[msg.sender].add(_amount);
654         stakeTmpBalance[_year][_month][msg.sender] = stakeTmpBalance[_year][_month][msg.sender].add(_amount);
655         
656         stakesLockups[msg.sender] = now + stakeLockTime;
657         
658         hostStakes[_year][_month][_hostAddress] = hostStakes[_year][_month][_hostAddress].add(_amount);
659         totalStakes[_year][_month] = totalStakes[_year][_month].add(_amount);
660     }
661     
662     function validateMonth(uint _year, uint _month) internal view {
663         uint __year; uint __month; uint __day; 
664         (__year, __month, __day) = _timestampToDate(now);
665         if(__month == 1){ __year--; __month = 12; } else { __month--; }
666         
667         require( (((__year.mul(12)).add(__month)).sub(_year.mul(12))).sub(_month) >= 0 );
668     }
669     
670     function claimHostTokens(uint _year, uint _month) public {
671         validateMonth(_year, _month);
672         
673         HostMeta storage h = hosts[msg.sender];
674         require( h.active );
675         
676         if(totalStakes[_year][_month] > 0){
677             uint256 _tmpHostStake = hostStakes[_year][_month][msg.sender];
678             
679             if(_tmpHostStake > 0){
680                 uint256 _totalStakes = totalStakes[_year][_month];
681                 uint256 _poolAmount = poolBalance[_year][_month];
682                 
683                 hostStakes[_year][_month][msg.sender] = 0;
684                 uint256 _amount = ((_tmpHostStake.mul(_poolAmount)).mul(50)).div(_totalStakes.mul(100));
685                 if(_amount > 0){
686                     balanceOf[msg.sender] = balanceOf[msg.sender].add(_amount);
687                     poolBalanceClaimed[_year][_month] = poolBalanceClaimed[_year][_month].add(_amount);
688                 }
689             }
690         }
691     }
692     
693     function claimStakeTokens(uint _year, uint _month) public {
694         validateMonth(_year, _month);
695         require(stakesLockups[msg.sender] < now);
696         
697         if(totalStakes[_year][_month] > 0){
698             uint256 _tmpStake = stakeTmpBalance[_year][_month][msg.sender];
699             
700             if(_tmpStake > 0){
701                 uint256 _totalStakesBal = stakeBalance[msg.sender];
702                 
703                 uint256 _totalStakes = totalStakes[_year][_month];
704                 uint256 _poolAmount = poolBalance[_year][_month];
705                 
706                 uint256 _amount = ((_tmpStake.mul(_poolAmount)).mul(50)).div(_totalStakes.mul(100));
707                 
708                 stakeTmpBalance[_year][_month][msg.sender] = 0;
709                 stakeBalance[msg.sender] = 0;
710                 uint256 _totamount = _amount.add(_totalStakesBal);
711                 
712                 if(_totamount > 0){
713                     balanceOf[msg.sender] = balanceOf[msg.sender].add(_totamount);
714                     poolBalanceClaimed[_year][_month] = poolBalanceClaimed[_year][_month].add(_amount);
715                 }
716             }
717         }
718     }
719     
720     function getHostTokens(address _address, uint _year, uint _month) public view returns (uint256 _amount) {
721         validateMonth(_year, _month);
722         
723         HostMeta storage h = hosts[_address];
724         require( h.active );
725         
726         _amount = 0;
727         if(h.active && totalStakes[_year][_month] > 0){
728             uint256 _tmpHostStake = hostStakes[_year][_month][_address];
729             
730             if(_tmpHostStake > 0){
731                 uint256 _totalStakes = totalStakes[_year][_month];
732                 uint256 _poolAmount = poolBalance[_year][_month];
733                 
734                 _amount = ((_tmpHostStake.mul(_poolAmount)).mul(50)).div(_totalStakes.mul(100));
735             }
736         }
737     }
738     
739     function getStakeTokens(address _address, uint _year, uint _month) public view returns (uint256 _amount) {
740         validateMonth(_year, _month);
741         require(stakesLockups[_address] < now);
742         
743         _amount = 0;
744         if(stakesLockups[_address] < now && totalStakes[_year][_month] > 0){
745             uint256 _tmpStake = stakeTmpBalance[_year][_month][_address];
746             
747             if(_tmpStake > 0){
748                 uint256 _totalStakesBal = stakeBalance[_address];
749                 
750                 uint256 _totalStakes = totalStakes[_year][_month];
751                 uint256 _poolAmount = poolBalance[_year][_month];
752                 
753                 _amount = ((_tmpStake.mul(_poolAmount)).mul(50)).div(_totalStakes.mul(100));
754                 _amount = _amount.add(_totalStakesBal);
755             }
756         }
757     }
758     
759     function burnPoolTokens(uint _year, uint _month) public {
760         validateMonth(_year, _month);
761         
762         if(totalStakes[_year][_month] == 0){
763             uint256 _poolAmount = poolBalance[_year][_month];
764             
765             if(_poolAmount > 0){
766                 poolBalance[_year][_month] = 0;
767                 balanceOf[address(0x0)] = balanceOf[address(0x0)].add(_poolAmount);
768             }
769         }
770     }
771     
772     function poolDonate(uint _year, uint _month, uint256 _amount) public {
773         require(
774             _amount > 0
775             && balanceOf[msg.sender] >= _amount
776         );
777         
778         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_amount);
779         
780         balanceOf[address(0x0)] = balanceOf[address(0x0)].add((_amount * 10) / 100);
781         poolBalance[_year][_month] = poolBalance[_year][_month].add((_amount * 90) / 100);
782     }
783     
784     function internalTransfer(address _to, uint256 _value) public returns (bool success) {
785         require(
786             _value > 0
787             && balanceOf[msg.sender] >= _value
788         );
789         
790         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
791         balanceOf[_to] = balanceOf[_to].add(_value);
792         
793         return true;
794     }
795     
796     function transfer(address _to, uint256 _value) public returns (bool success) {
797         require(
798             _value > 0
799             && balanceOf[msg.sender] >= _value
800         );
801         
802         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
803         ERC20(tokenAddress).transfer(_to, _value);
804         
805         return true;
806     }
807     
808     function burn() public {
809         uint256 _amount = balanceOf[address(0x0)];
810         require( _amount > 0 );
811         
812         balanceOf[address(0x0)] = 0;
813         ERC20(tokenAddress).transfer(address(0x0), _amount);
814     }
815     
816     function notifyBalance(address sender, uint tokens) public {
817         require(
818             msg.sender == tokenAddress
819         );
820         
821         balanceOf[sender] = balanceOf[sender].add(tokens);
822     }
823     
824     function () public payable {} 
825 }