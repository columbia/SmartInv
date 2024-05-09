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
59                 return false;
60         }
61         if (year % 100 != 0) {
62                 return true;
63         }
64         if (year % 400 != 0) {
65                 return false;
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
76                 return 31;
77         }
78         else if (month == 4 || month == 6 || month == 9 || month == 11) {
79                 return 30;
80         }
81         else if (isLeapYear(year)) {
82                 return 29;
83         }
84         else {
85                 return 28;
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
99         _months = toYear * 12 + toMonth - fromYear * 12 - fromMonth;
100     }
101     
102     function addMonth(uint _month, uint _year, uint _add) internal pure returns (uint _nwMonth, uint _nwYear) {
103         require(_add < 12);
104         
105         if(_month + _add > 12){
106             _nwYear = _year + 1;
107             _nwMonth = 1;
108         } else {
109             _nwMonth = _month + _add;
110             _nwYear = _year;
111         }
112     }
113 }
114 
115 contract initLib is DateTime {
116     using SafeMath for uint;
117     
118     string  public symbol = "OWT";
119     uint256 public decimals = 18;
120     address public tokenAddress;
121     uint256 public tokenPrice = 43200;
122     
123     uint256 public domainCost = 500; 
124     uint256 public publishCost = 200; 
125     uint256 public hostRegistryCost = 1000; 
126     uint256 public userSurfingCost = 10; 
127     uint256 public registryDuration = 365 * 1 days;
128     uint256 public stakeLockTime = 31 * 1 days;
129     
130     uint public websiteSizeLimit = 512;
131     uint public websiteFilesLimit = 20;
132     
133     address public ow_owner;
134     address public cmcAddress;
135     uint public lastPriceUpdate;
136     
137     mapping ( address => uint256 ) public balanceOf;
138     mapping ( address => uint256 ) public stakeBalance;
139     mapping ( uint => mapping ( uint => uint256 )) public poolBalance;
140     mapping ( uint => mapping ( uint => uint256 )) public poolBalanceClaimed;
141     mapping ( uint => mapping ( uint => uint256 )) public totalStakes;
142     
143     uint256 public totalSubscriber;
144     uint256 public totalHosts;
145     uint256 public totalDomains;
146     
147     mapping ( address => UserMeta ) public users;
148     mapping ( bytes32 => DomainMeta ) public domains;
149     mapping ( bytes32 => DomainSaleMeta ) public domain_sale;
150     mapping ( address => HostMeta ) public hosts;
151     mapping ( uint => address ) public hostAddress;
152     mapping ( uint => bytes32 ) public hostConnection;
153     mapping ( bytes32 => bool ) public hostConnectionDB;
154     
155     mapping ( uint => mapping ( uint => mapping ( address => uint256 ) )) public hostStakes;
156     mapping ( uint => mapping ( uint => mapping ( address => uint256 ) )) public stakeTmpBalance;
157     mapping ( address => uint256 ) public stakesLockups;
158     
159     mapping ( uint => uint ) public hostUpdates;
160     uint public hostUpdatesCounter;
161     
162     mapping ( uint => string ) public websiteUpdates;
163     uint public websiteUpdatesCounter;
164     
165     struct DomainMeta {
166         string name;
167         uint admin_index;
168         uint total_admins;
169         mapping(uint => mapping(address => bool)) admins;
170         string git;
171         bytes32 domain_bytes;
172         bytes32 hash;
173         uint total_files;
174         uint version;
175         mapping(uint => mapping(bytes32 => bytes32)) files_hash;
176         uint ttl;
177         uint time;
178         uint expity_time;
179     }
180     
181     struct DomainSaleMeta {
182         address owner;
183         address to;
184         uint amount;
185         uint time;
186         uint expity_time;
187     }
188     
189     struct HostMeta {
190         uint id;
191         address hostAddress;
192         bytes32 connection;
193         bool active;
194         uint start_time;
195         uint time;
196     }
197     
198     struct UserMeta {
199         bool active;
200         uint start_time;
201         uint expiry_time;
202         uint time;
203     }
204     
205     function stringToBytes32(string memory source) internal pure returns (bytes32 result) {
206         bytes memory tempEmptyStringTest = bytes(source);
207         if (tempEmptyStringTest.length == 0) {
208             return 0x0;
209         }
210     
211         assembly {
212             result := mload(add(source, 32))
213         }
214     }
215     
216     function _currentPrice(uint256 _price) public view returns (uint256 _getprice) {
217         _getprice = (_price * 10**uint(24)) / tokenPrice;
218     }
219     
220     function __response(uint _price) public {
221         require(msg.sender == cmcAddress);
222         tokenPrice = _price;
223     }
224     
225     function fetchTokenPrice() public payable {
226         require(
227             lastPriceUpdate + 1 * 1 days <  now
228         );
229         
230         lastPriceUpdate = now;
231         uint _getprice = CoinMarketCapApi(cmcAddress)._cost();
232         CoinMarketCapApi(cmcAddress).requestPrice.value(_getprice)(symbol);
233     }
234     
235     function _priceFetchingCost() public view returns (uint _getprice) {
236         _getprice = CoinMarketCapApi(cmcAddress)._cost();
237     }
238     
239     function debitToken(uint256 _amount) internal {
240         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_amount);
241         balanceOf[ow_owner] = balanceOf[ow_owner].add(_amount);
242     }
243     
244     function creditUserPool(uint _duration, uint256 _price) internal {
245         uint _monthDays; uint _remainingDays; 
246         uint _year; uint _month; uint _day; 
247         (_year, _month, _day) = _timestampToDate(now);
248         
249         _day--;
250         uint monthDiff = diffMonths(now, now + ( _duration * 1 days )) + 1;
251         
252         for(uint i = 0; i < monthDiff; i++) {
253             _monthDays = getDaysInMonth(_month, _year, 0); 
254             
255             if(_day.add(_duration) > _monthDays){ 
256                 _remainingDays = _monthDays.sub(_day);
257                 balanceOf[address(0x0)] = balanceOf[address(0x0)].add((_remainingDays * _price * 10) / 100);
258                 poolBalance[_year][_month] = poolBalance[_year][_month].add((_remainingDays * _price * 90) / 100);
259                 
260                 (_month, _year) = addMonth(_month, _year, 1);
261                 
262                 _duration = _duration.sub(_remainingDays);
263                 _day = 0;
264                 
265             } else {
266                 balanceOf[address(0x0)] = balanceOf[address(0x0)].add((_duration * _price * 10) / 100);
267                 poolBalance[_year][_month] = poolBalance[_year][_month].add((_duration * _price * 90) / 100);
268             }
269             
270         }
271     }
272 }
273 
274 contract owContract is initLib {
275     
276     function owContract(address _token, address _cmc) public {
277         tokenAddress = _token;
278         ow_owner = msg.sender;
279         cmcAddress = _cmc;
280     }
281     
282     function _validateDomain(string _domain) internal pure returns (bool){
283         bytes memory b = bytes(_domain);
284         if(b.length > 32) return false;
285         
286         uint counter = 0;
287         for(uint i; i<b.length; i++){
288             bytes1 char = b[i];
289             
290             if(
291                 !(char >= 0x30 && char <= 0x39)   //9-0
292                 && !(char >= 0x61 && char <= 0x7A)  //a-z
293                 && !(char == 0x2D) // - 
294                 && !(char == 0x2E && counter == 0) // . 
295             ){
296                     return false;
297             }
298             
299             if(char == 0x2E) counter++; 
300         }
301     
302         return true;
303     }
304     
305     function registerDomain(string _domain, uint _ttl) public returns (bool _status) {
306         bytes32 _domainBytes = stringToBytes32(_domain);
307         DomainMeta storage d = domains[_domainBytes];
308         uint256 _cPrice = _currentPrice(domainCost);
309         
310         require(
311             d.expity_time < now 
312             && _ttl >= 1 * 1 hours 
313             && balanceOf[msg.sender] >= _cPrice 
314             && _validateDomain(_domain)
315         );
316         
317         debitToken(_cPrice);
318         uint _adminIndex = d.admin_index + 1;
319         
320         if(d.expity_time == 0){
321             totalDomains++;
322         }
323         
324         d.name = _domain;
325         d.domain_bytes = _domainBytes;
326         d.admin_index = _adminIndex;
327         d.total_admins = 1;
328         d.admins[_adminIndex][msg.sender] = true;
329         d.ttl = _ttl;
330         d.expity_time = now + registryDuration;
331         d.time = now;
332         
333         _status = true;
334     }
335     
336     function updateDomainTTL(string _domain, uint _ttl) public returns (bool _status) {
337         bytes32 _domainBytes = stringToBytes32(_domain);
338         DomainMeta storage d = domains[_domainBytes];
339         require(
340             d.admins[d.admin_index][msg.sender] 
341             && _ttl >= 1 * 1 hours 
342             && d.expity_time > now
343         );
344         
345         d.ttl = _ttl;
346         _status = true;
347     }
348     
349     function renewDomain(string _domain) public returns (bool _status) {
350         bytes32 _domainBytes = stringToBytes32(_domain);
351         DomainMeta storage d = domains[_domainBytes];
352         uint256 _cPrice = _currentPrice(domainCost);
353         
354         require(
355             d.expity_time > now 
356             && balanceOf[msg.sender] >= _cPrice
357         );
358         
359         debitToken(_cPrice);
360         d.expity_time = d.expity_time.add(registryDuration);
361         
362         _status = true;
363     }
364     
365     function addDomainAdmin(string _domain, address _admin) public returns (bool _status) {
366         bytes32 _domainBytes = stringToBytes32(_domain);
367         DomainMeta storage d = domains[_domainBytes];
368         require(
369             d.admins[d.admin_index][msg.sender] 
370             && !d.admins[d.admin_index][_admin]
371             && d.expity_time > now
372         );
373         
374         d.total_admins = d.total_admins.add(1);
375         d.admins[d.admin_index][_admin] = true;
376         
377         _status = true;
378     }
379     
380     function removeDomainAdmin(string _domain, address _admin) public returns (bool _status) {
381         bytes32 _domainBytes = stringToBytes32(_domain);
382         DomainMeta storage d = domains[_domainBytes];
383         require(
384             d.admins[d.admin_index][msg.sender] 
385             && d.admins[d.admin_index][_admin] 
386             && d.expity_time > now
387         );
388         
389         d.total_admins = d.total_admins.sub(1);
390         d.admins[d.admin_index][_admin] = false;
391         
392         _status = true;
393     }
394     
395     function sellDomain(
396         string _domain, 
397         address _owner, 
398         address _to, 
399         uint256 _amount, 
400         uint _expiry
401     ) public returns (bool _status) {
402         bytes32 _domainBytes = stringToBytes32(_domain);
403         DomainMeta storage d = domains[_domainBytes];
404         DomainSaleMeta storage ds = domain_sale[_domainBytes];
405         
406         require(
407             _amount > 0
408             && d.admins[d.admin_index][msg.sender] 
409             && d.expity_time > now 
410             && ds.expity_time < now
411         );
412         
413         ds.owner = _owner;
414         ds.to = _to;
415         ds.amount = _amount;
416         ds.time = now;
417         ds.expity_time = now + _expiry * 1 days;
418         
419         _status = true;
420     }
421     
422     function buyDomain(string _domain) public returns (bool _status) {
423         bytes32 _domainBytes = stringToBytes32(_domain);
424         DomainMeta storage d = domains[_domainBytes];
425         DomainSaleMeta storage ds = domain_sale[_domainBytes];
426         
427         if(ds.to != address(0x0)){
428             require( ds.to == msg.sender );
429         }
430         
431         require(
432             balanceOf[msg.sender] >= ds.amount 
433             && d.expity_time > now 
434             && ds.expity_time > now
435         );
436         
437         balanceOf[msg.sender] = balanceOf[msg.sender].sub(ds.amount);
438         balanceOf[ds.owner] = balanceOf[ds.owner].add(ds.amount);
439         
440         uint _adminIndex = d.admin_index + 1;
441         
442         d.total_admins = 1;
443         d.admin_index = _adminIndex;
444         d.admins[_adminIndex][msg.sender] = true;
445         ds.expity_time = 0;
446         
447         _status = true;
448     }
449     
450     function publishWebsite(
451         string _domain, 
452         string _git, 
453         bytes32 _filesHash,
454         bytes32[] _file_name, 
455         bytes32[] _file_hash
456     ) public returns (bool _status) {
457         bytes32 _domainBytes = stringToBytes32(_domain);
458         DomainMeta storage d = domains[_domainBytes];
459         uint256 _cPrice = _currentPrice(publishCost);
460         
461         require(
462             d.admins[d.admin_index][msg.sender] 
463             && balanceOf[msg.sender] >= _cPrice 
464             && _file_name.length <= websiteFilesLimit 
465             && _file_name.length == _file_hash.length
466             && d.expity_time > now
467         );
468         
469         debitToken(_cPrice);
470         d.version++;
471         
472         for(uint i = 0; i < _file_name.length; i++) {
473             d.files_hash[d.version][_file_name[i]] = _file_hash[i];
474         }
475         
476         d.git = _git;
477         d.total_files = _file_name.length;
478         d.hash = _filesHash;
479         
480         websiteUpdates[websiteUpdatesCounter] = _domain;
481         websiteUpdatesCounter++;
482         
483         _status = true;
484     }
485     
486     function getDomainMeta(string _domain) public view 
487         returns (
488             string _name,  
489             string _git, 
490             bytes32 _domain_bytes, 
491             bytes32 _hash, 
492             uint _total_admins,
493             uint _adminIndex, 
494             uint _total_files, 
495             uint _version, 
496             uint _ttl, 
497             uint _time, 
498             uint _expity_time
499         )
500     {
501         bytes32 _domainBytes = stringToBytes32(_domain);
502         DomainMeta storage d = domains[_domainBytes];
503         
504         _name = d.name;
505         _git = d.git;
506         _domain_bytes = d.domain_bytes;
507         _hash = d.hash;
508         _total_admins = d.total_admins;
509         _adminIndex = d.admin_index;
510         _total_files = d.total_files;
511         _version = d.version;
512         _ttl = d.ttl;
513         _time = d.time;
514         _expity_time = d.expity_time;
515     }
516     
517     function getDomainFileHash(string _domain, bytes32 _file_name) public view 
518         returns ( 
519             bytes32 _hash
520         )
521     {
522         bytes32 _domainBytes = stringToBytes32(_domain);
523         DomainMeta storage d = domains[_domainBytes];
524         
525         _hash = d.files_hash[d.version][_file_name];
526     }
527     
528     function verifyDomainFileHash(string _domain, bytes32 _file_name, bytes32 _file_hash) public view 
529         returns ( 
530             bool _status
531         )
532     {
533         bytes32 _domainBytes = stringToBytes32(_domain);
534         DomainMeta storage d = domains[_domainBytes];
535         
536         _status = ( d.files_hash[d.version][_file_name] == _file_hash );
537     }
538     
539     function registerHost(string _connection) public returns (bool _status) {
540         bytes32 hostConn = stringToBytes32(_connection);
541         HostMeta storage h = hosts[msg.sender];
542         uint256 _cPrice = _currentPrice(hostRegistryCost);
543         
544         require(
545             !h.active 
546             && balanceOf[msg.sender] >= _cPrice 
547             && !hostConnectionDB[hostConn]
548         );
549         
550         debitToken(_cPrice);
551         
552         h.id = totalHosts;
553         h.connection = hostConn;
554         h.active = true;
555         h.time = now;
556         
557         hostAddress[totalHosts] = msg.sender;
558         hostConnection[totalHosts] = h.connection;
559         hostConnectionDB[hostConn] = true;
560         totalHosts++;
561         
562         _status = true;
563     }
564     
565     function updateHost(string _connection) public returns (bool _status) {
566         bytes32 hostConn = stringToBytes32(_connection);
567         HostMeta storage h = hosts[msg.sender];
568         
569         require(
570             h.active 
571             && h.connection != hostConn 
572             && !hostConnectionDB[hostConn]
573         );
574         
575         hostConnectionDB[h.connection] = false;
576         h.connection = hostConn;
577         
578         hostConnectionDB[hostConn] = true;
579         hostUpdates[hostUpdatesCounter] = h.id;
580         hostConnection[h.id] = hostConn;
581         hostUpdatesCounter++;
582         
583         _status = true;
584     }
585     
586     function deListHost() public returns (bool _status) {
587         HostMeta storage h = hosts[msg.sender];
588         
589         require( h.active );
590         h.active = false;
591         totalHosts--;
592         
593         _status = true;
594     }
595     
596     function userSubscribe(uint _duration) public {
597         uint256 _cPrice = _currentPrice(userSurfingCost);
598         uint256 _cost = _duration * _cPrice;
599         
600         require(
601             _duration < 400 
602             && _duration > 0
603             && balanceOf[msg.sender] >= _cost
604         );
605         
606         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_cost);
607         creditUserPool(_duration, _cPrice);
608         
609         UserMeta storage u = users[msg.sender];
610         if(!u.active){
611             u.active = true;
612             u.time = now;
613             
614             totalSubscriber++;
615         }
616         
617         if(u.expiry_time < now){
618             u.start_time = now;
619             u.expiry_time = now + (_duration * 1 days);
620         } else {
621             u.expiry_time = u.expiry_time.add(_duration * 1 days);
622         }
623     }
624     
625     function stakeTokens(address _hostAddress, uint256 _amount) public {
626         require( balanceOf[msg.sender] >= _amount );
627         
628         uint _year; uint _month; uint _day; 
629         (_year, _month, _day) = _timestampToDate(now);
630         
631         HostMeta storage h = hosts[_hostAddress];
632         require( h.active );
633         
634         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_amount);
635         stakeBalance[msg.sender] = stakeBalance[msg.sender].add(_amount);
636         stakeTmpBalance[_year][_month][msg.sender] = stakeTmpBalance[_year][_month][msg.sender].add(_amount);
637         
638         stakesLockups[msg.sender] = now + stakeLockTime;
639         
640         hostStakes[_year][_month][_hostAddress] = hostStakes[_year][_month][_hostAddress].add(_amount);
641         totalStakes[_year][_month] = totalStakes[_year][_month].add(_amount);
642     }
643     
644     function validateMonth(uint _year, uint _month) internal view {
645         uint __year; uint __month; uint __day; 
646         (__year, __month, __day) = _timestampToDate(now);
647         if(__month == 1){ __year--; __month = 12; } else { __month--; }
648         
649         require( __year * 12 + __month - _year * 12 - _month >= 0 );
650     }
651     
652     function claimHostTokens(uint _year, uint _month) public {
653         validateMonth(_year, _month);
654         
655         HostMeta storage h = hosts[msg.sender];
656         require( h.active );
657         
658         if(totalStakes[_year][_month] > 0){
659             uint256 _tmpHostStake = hostStakes[_year][_month][msg.sender];
660             
661             if(_tmpHostStake > 0){
662                 uint256 _totalStakes = totalStakes[_year][_month];
663                 uint256 _poolAmount = poolBalance[_year][_month];
664                 
665                 hostStakes[_year][_month][msg.sender] = 0;
666                 uint256 _amount = ((_tmpHostStake.mul(_poolAmount)).mul(50)) / _totalStakes.mul(100);
667                 if(_amount > 0){
668                     balanceOf[msg.sender] = balanceOf[msg.sender].add(_amount);
669                     poolBalanceClaimed[_year][_month] = poolBalanceClaimed[_year][_month].add(_amount);
670                 }
671             }
672         }
673     }
674     
675     function claimStakeTokens(uint _year, uint _month) public {
676         validateMonth(_year, _month);
677         require(stakesLockups[msg.sender] < now);
678         
679         if(totalStakes[_year][_month] > 0){
680             uint256 _tmpStake = stakeTmpBalance[_year][_month][msg.sender];
681             
682             if(_tmpStake > 0){
683                 uint256 _totalStakesBal = stakeBalance[msg.sender];
684                 
685                 uint256 _totalStakes = totalStakes[_year][_month];
686                 uint256 _poolAmount = poolBalance[_year][_month];
687                 
688                 uint256 _amount = ((_tmpStake.mul(_poolAmount)).mul(50)) / _totalStakes.mul(100);
689                 
690                 stakeTmpBalance[_year][_month][msg.sender] = 0;
691                 stakeBalance[msg.sender] = 0;
692                 _amount = _amount.add(_totalStakesBal);
693                 
694                 if(_amount > 0){
695                     balanceOf[msg.sender] = balanceOf[msg.sender].add(_amount);
696                     poolBalanceClaimed[_year][_month] = poolBalanceClaimed[_year][_month].add(_amount);
697                 }
698             }
699         }
700     }
701     
702     function getHostTokens(address _address, uint _year, uint _month) public view returns (uint256 _amount) {
703         validateMonth(_year, _month);
704         
705         HostMeta storage h = hosts[_address];
706         require( h.active );
707         
708         _amount = 0;
709         if(h.active && totalStakes[_year][_month] > 0){
710             uint256 _tmpHostStake = hostStakes[_year][_month][_address];
711             
712             if(_tmpHostStake > 0){
713                 uint256 _totalStakes = totalStakes[_year][_month];
714                 uint256 _poolAmount = poolBalance[_year][_month];
715                 
716                 _amount = ((_tmpHostStake.mul(_poolAmount)).mul(50)) / _totalStakes.mul(100);
717             }
718         }
719     }
720     
721     function getStakeTokens(address _address, uint _year, uint _month) public view returns (uint256 _amount) {
722         validateMonth(_year, _month);
723         require(stakesLockups[_address] < now);
724         
725         _amount = 0;
726         if(stakesLockups[_address] < now && totalStakes[_year][_month] > 0){
727             uint256 _tmpStake = stakeTmpBalance[_year][_month][_address];
728             
729             if(_tmpStake > 0){
730                 uint256 _totalStakesBal = stakeBalance[_address];
731                 
732                 uint256 _totalStakes = totalStakes[_year][_month];
733                 uint256 _poolAmount = poolBalance[_year][_month];
734                 
735                 _amount = ((_tmpStake.mul(_poolAmount)).mul(50)) / _totalStakes.mul(100);
736                 _amount = _amount.add(_totalStakesBal);
737             }
738         }
739     }
740     
741     function burnPoolTokens(uint _year, uint _month) public {
742         validateMonth(_year, _month);
743         
744         if(totalStakes[_year][_month] == 0){
745             uint256 _poolAmount = poolBalance[_year][_month];
746             
747             if(_poolAmount > 0){
748                 poolBalance[_year][_month] = 0;
749                 balanceOf[address(0x0)] = balanceOf[address(0x0)].add(_poolAmount);
750             }
751         }
752     }
753     
754     function poolDonate(uint _year, uint _month, uint256 _amount) public {
755         require(
756             balanceOf[msg.sender] >= _amount
757         );
758         
759         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_amount);
760         
761         balanceOf[address(0x0)] = balanceOf[address(0x0)].add((_amount * 10) / 100);
762         poolBalance[_year][_month] = poolBalance[_year][_month].add((_amount * 90) / 100);
763     }
764     
765     function internalTransfer(address _to, uint256 _value) public returns (bool success) {
766         require(
767             _value > 0
768             && balanceOf[msg.sender] >= _value
769         );
770         
771         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
772         balanceOf[_to] = balanceOf[_to].add(_value);
773         
774         return true;
775     }
776     
777     function transfer(address _to, uint256 _value) public returns (bool success) {
778         require(
779             _value > 0
780             && balanceOf[msg.sender] >= _value
781         );
782         
783         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
784         ERC20(tokenAddress).transfer(_to, _value);
785         
786         return true;
787     }
788     
789     function burn() public {
790         uint256 _amount = balanceOf[address(0x0)];
791         require( _amount > 0 );
792         
793         balanceOf[address(0x0)] = 0;
794         ERC20(tokenAddress).transfer(address(0x0), _amount);
795     }
796     
797     function notifyBalance(address sender, uint tokens) public {
798         require(
799             msg.sender == tokenAddress
800         );
801         
802         balanceOf[sender] = balanceOf[sender].add(tokens);
803     }
804     
805     function () public payable {} 
806 }