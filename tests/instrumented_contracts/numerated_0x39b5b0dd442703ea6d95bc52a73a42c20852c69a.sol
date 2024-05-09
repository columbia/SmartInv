1 pragma solidity ^0.4.24;
2 
3 contract owned {
4     address public owner;
5 
6     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
7 
8     /**
9     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
10     * account.
11     */
12     constructor() public {
13         owner = msg.sender;
14     }
15 
16 
17     /**
18     * @dev Throws if called by any account other than the owner.
19     */
20     modifier onlyOwner() {
21         require(msg.sender == owner);
22         _;
23     }
24 
25 
26     /**
27     * @dev Allows the current owner to transfer control of the contract to a newOwner.
28     * @param newOwner The address to transfer ownership to.
29     */
30     function transferOwnership(address newOwner) public onlyOwner {
31         require(newOwner != address(0));
32         emit OwnershipTransferred(owner, newOwner);
33         owner = newOwner;
34     }
35 }
36 
37 /// @title PONZIMOON
38 contract ponzimoon is owned {
39 
40     using SafeMath for uint256;
41 
42 
43     Spaceship[] spaceships;
44     Player[] players;
45     mapping(address => uint256) addressMPid;
46     mapping(uint256 => address) pidXAddress;
47     mapping(string => uint256) nameXPid;
48     uint256 playerCount;
49     uint256 totalTicketCount;
50     uint256 airdropPrizePool;
51     uint256 moonPrizePool;
52     uint256 lotteryTime;
53     uint256 editPlayerNamePrice = 0.01 ether;
54     uint256 spaceshipPrice = 0.01 ether;
55     uint256 addSpaceshipPrice = 0.00000001 ether;
56     address maxAirDropAddress;
57     uint256 maxTotalTicket;
58     uint256 round;
59     uint256 totalDividendEarnings;
60     uint256 totalEarnings;
61     uint256 luckyPayerId;
62 
63 
64     struct Spaceship {
65         uint256 id;
66         string name;
67         uint256 speed;
68         address captain;
69         uint256 ticketCount;
70         uint256 dividendRatio;
71         uint256 spaceshipPrice;
72         uint256 addSpeed;
73     }
74     struct Player {
75         address addr;
76         string name;
77         uint256 earnings;
78         uint256 ticketCount;
79         uint256 dividendRatio;
80         uint256 distributionEarnings;
81         uint256 dividendEarnings;
82         uint256 withdrawalAmount;
83         uint256 parentId;
84         uint256 dlTicketCount;
85         uint256 xzTicketCount;
86         uint256 jcTicketCount;
87     }
88 
89     constructor() public {
90         lotteryTime = now + 12 hours;
91         round = 1;
92 
93         spaceships.push(Spaceship(0, "dalao", 100000, msg.sender, 0, 20, 15 ether, 2));
94         spaceships.push(Spaceship(1, "xiaozhuang", 100000, msg.sender, 0, 50, 15 ether, 5));
95         spaceships.push(Spaceship(2, "jiucai", 100000, msg.sender, 0, 80, 15 ether, 8));
96 
97         uint256 playerArrayIndex = players.push(Player(msg.sender, "system", 0, 0, 3, 0, 0, 0, 0, 0, 0, 0));
98         addressMPid[msg.sender] = playerArrayIndex;
99         pidXAddress[playerArrayIndex] = msg.sender;
100         playerCount = players.length;
101         nameXPid["system"] = playerArrayIndex;
102     }
103 
104     function getSpaceship(uint256 _spaceshipId) public view returns (
105         uint256 _id,
106         string _name,
107         uint256 _speed,
108         address _captain,
109         uint256 _ticketCount,
110         uint256 _dividendRatio,
111         uint256 _spaceshipPrice
112     ){
113         _id = spaceships[_spaceshipId].id;
114         _name = spaceships[_spaceshipId].name;
115         _speed = spaceships[_spaceshipId].speed;
116         _captain = spaceships[_spaceshipId].captain;
117         _ticketCount = spaceships[_spaceshipId].ticketCount;
118         _dividendRatio = spaceships[_spaceshipId].dividendRatio;
119         _spaceshipPrice = spaceships[_spaceshipId].spaceshipPrice;
120     }
121     function getNowTime() public view returns (uint256){
122         return now;
123     }
124 
125     function checkName(string _name) public view returns (bool){
126         if (nameXPid[_name] == 0) {
127             return false;
128         }
129         return true;
130     }
131 
132     function setYxName(address _address, string _name) external onlyOwner {
133         if (addressMPid[_address] == 0) {
134             uint256 playerArrayIndex = players.push(Player(_address, _name, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0));
135             addressMPid[_address] = playerArrayIndex;
136             pidXAddress[playerArrayIndex] = _address;
137             playerCount = players.length;
138             nameXPid[_name] = playerArrayIndex;
139         } else {
140             uint256 _pid = addressMPid[_address];
141             Player storage _p = players[_pid.sub(1)];
142             _p.name = _name;
143             nameXPid[_name] = _pid;
144         }
145     }
146 
147     function setName(string _name) external payable {
148         require(msg.value >= editPlayerNamePrice);
149         if (addressMPid[msg.sender] == 0) {
150             uint256 playerArrayIndex = players.push(Player(msg.sender, _name, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0));
151             addressMPid[msg.sender] = playerArrayIndex;
152             pidXAddress[playerArrayIndex] = msg.sender;
153             playerCount = players.length;
154             nameXPid[_name] = playerArrayIndex;
155         } else {
156             uint256 _pid = addressMPid[msg.sender];
157             Player storage _p = players[_pid.sub(1)];
158             _p.name = _name;
159             nameXPid[_name] = _pid;
160 
161         }
162         Player storage _sysP = players[0];
163         _sysP.earnings = _sysP.earnings.add(msg.value);
164         _sysP.distributionEarnings = _sysP.distributionEarnings.add(msg.value);
165     }
166 
167     function _computePayMoney(uint256 _ticketCount, address _addr) private view returns (bool){
168         uint256 _initMoney = 0.01 ether;
169         uint256 _eachMoney = 0.0001 ether;
170         uint256 _payMoney = (spaceshipPrice.mul(_ticketCount)).add(addSpaceshipPrice.mul((_ticketCount.sub(1))));
171         _payMoney = _payMoney.sub((_eachMoney.mul(_ticketCount)));
172         uint256 _tmpPid = addressMPid[_addr];
173         Player memory _p = players[_tmpPid.sub(1)];
174         if (_p.earnings >= (_initMoney.mul(_ticketCount)) && _p.earnings >= _payMoney) {
175             return true;
176         }
177         return false;
178     }
179 
180     function checkTicket(uint256 _ticketCount, uint256 _money) private view returns (bool){
181         uint256 _initMoney = 0.01 ether;
182         uint256 _eachMoney = 0.0001 ether;
183         uint256 _payMoney = (spaceshipPrice.mul(_ticketCount)).add(addSpaceshipPrice.mul((_ticketCount.sub(1))));
184         _payMoney = _payMoney.sub((_eachMoney.mul(_ticketCount)));
185         if (_money >= (_initMoney.mul(_ticketCount)) && _money >= _payMoney) {
186             return true;
187         }
188         return false;
189 
190 
191     }
192 
193     function checkNewPlayer(address _player) private {
194         if (addressMPid[_player] == 0) {
195             uint256 playerArrayIndex = players.push(Player(_player, "", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0));
196             addressMPid[_player] = playerArrayIndex;
197             pidXAddress[playerArrayIndex] = _player;
198             playerCount = players.length;
199         }
200     }
201 
202     function addTicket(uint256 _ticketCount, uint256 _spaceshipNo, uint256 _pid) private {
203         spaceshipPrice = spaceshipPrice.add(addSpaceshipPrice.mul(_ticketCount));
204 
205         totalTicketCount = totalTicketCount.add(_ticketCount);
206         Player storage _p = players[_pid.sub(1)];
207         _p.ticketCount = _p.ticketCount.add(_ticketCount);
208         if (_spaceshipNo == 0) {
209             _p.dlTicketCount = _p.dlTicketCount.add(_ticketCount);
210             Spaceship storage _s = spaceships[0];
211             _s.ticketCount = _s.ticketCount.add(_ticketCount);
212             _s.speed = _s.speed.add(_ticketCount.mul(_s.addSpeed));
213 
214         }
215         if (_spaceshipNo == 1) {
216             _p.xzTicketCount = _p.xzTicketCount.add(_ticketCount);
217             Spaceship storage _s1 = spaceships[1];
218             _s1.ticketCount = _s1.ticketCount.add(_ticketCount);
219             _s1.speed = _s1.speed.add(_ticketCount.mul(_s1.addSpeed));
220         }
221         if (_spaceshipNo == 2) {
222             _p.jcTicketCount = _p.jcTicketCount.add(_ticketCount);
223             Spaceship storage _s2 = spaceships[2];
224             _s2.ticketCount = _s2.ticketCount.add(_ticketCount);
225             _s2.speed = _s2.speed.add(_ticketCount.mul(_s2.addSpeed));
226         }
227     }
228 
229 
230     function _payTicketByEarnings(uint256 _ticketCount, address _addr) private returns (uint256){
231         uint256 _tmpPid = addressMPid[_addr];
232         Player storage _p = players[_tmpPid.sub(1)];
233         uint256 _tmpMoney = spaceshipPrice.mul(_ticketCount);
234         uint256 _tmpMoney2 = addSpaceshipPrice.mul(_ticketCount.sub(1));
235         uint256 _returnMoney = _tmpMoney.add(_tmpMoney2);
236         _p.earnings = _p.earnings.sub(_returnMoney);
237         return _returnMoney;
238     }
239 
240 
241     function buyTicketByEarnings(uint256 _ticketCount, uint256 _spaceshipNo, string _name) external {
242         require(now < lotteryTime);
243         require(_spaceshipNo == 0 || _spaceshipNo == 1 || _spaceshipNo == 2);
244         require(addressMPid[msg.sender] != 0);
245         require(_computePayMoney(_ticketCount, msg.sender));
246         updateTime();
247         uint256 _money = _payTicketByEarnings(_ticketCount, msg.sender);
248 
249 
250         totalEarnings = totalEarnings.add(_money);
251 
252         Player storage _p = players[addressMPid[msg.sender].sub(1)];
253         if (_p.parentId == 0 && nameXPid[_name] != 0) {
254             _p.parentId = nameXPid[_name];
255         }
256         luckyPayerId = addressMPid[msg.sender];
257 
258         addTicket(_ticketCount, _spaceshipNo, addressMPid[msg.sender]);
259 
260 
261         addSpaceshipMoney(_money.div(100).mul(1));
262 
263         Player storage _player = players[0];
264         uint256 _SysMoney = _money.div(100).mul(5);
265         _player.earnings = _player.earnings.add(_SysMoney);
266         _player.dividendEarnings = _player.dividendEarnings.add(_SysMoney);
267 
268 
269         uint256 _distributionMoney = _money.div(100).mul(10);
270         if (_p.parentId == 0) {
271             _player.earnings = _player.earnings.add(_distributionMoney);
272             _player.distributionEarnings = _player.distributionEarnings.add(_distributionMoney);
273         } else {
274             Player storage _player_ = players[_p.parentId.sub(1)];
275             _player_.earnings = _player_.earnings.add(_distributionMoney);
276             _player_.distributionEarnings = _player_.distributionEarnings.add(_distributionMoney);
277         }
278         if (_ticketCount > maxTotalTicket) {
279             maxTotalTicket = _ticketCount;
280             maxAirDropAddress = msg.sender;
281         }
282 
283         uint256 _airDropMoney = _money.div(100).mul(2);
284         airdropPrizePool = airdropPrizePool.add(_airDropMoney);
285         if (airdropPrizePool >= 1 ether) {
286             Player storage _playerAirdrop = players[addressMPid[maxAirDropAddress].sub(1)];
287             _playerAirdrop.earnings = _playerAirdrop.earnings.add(airdropPrizePool);
288             _playerAirdrop.dividendEarnings = _playerAirdrop.dividendEarnings.add(airdropPrizePool);
289             airdropPrizePool = 0;
290         }
291 
292         uint256 _remainderMoney = _cMoney(_money, _SysMoney, _distributionMoney, _airDropMoney);
293 
294         updateGameMoney(_remainderMoney, _spaceshipNo, _ticketCount, addressMPid[msg.sender].sub(1));
295     }
296 
297     function _cMoney(uint256 _money, uint256 _SysMoney, uint256 _distributionMoney, uint256 _airDropMoney)
298     private pure returns (uint256){
299         uint256 _czSpaceshipMoney = _money.div(100).mul(1).mul(3);
300         return _money.sub(_czSpaceshipMoney).sub(_SysMoney).
301         sub(_distributionMoney).sub(_airDropMoney);
302     }
303 
304     function updateTime() private {
305         if (totalTicketCount < 50000) {
306             lotteryTime = now + 12 hours;
307 
308         } else {
309             lotteryTime = now + 1 hours;
310         }
311     }
312 
313 
314     function buyTicket(uint256 _ticketCount, uint256 _spaceshipNo, string _name) external payable {
315         require(now < lotteryTime);
316         require(_spaceshipNo == 0 || _spaceshipNo == 1 || _spaceshipNo == 2);
317         require(checkTicket(_ticketCount, msg.value));
318         checkNewPlayer(msg.sender);
319         updateTime();
320         totalEarnings = totalEarnings.add(msg.value);
321 
322         Player storage _p = players[addressMPid[msg.sender].sub(1)];
323         if (_p.parentId == 0 && nameXPid[_name] != 0) {
324             _p.parentId = nameXPid[_name];
325         }
326         luckyPayerId = addressMPid[msg.sender];
327         addTicket(_ticketCount, _spaceshipNo, addressMPid[msg.sender]);
328 
329 
330         addSpaceshipMoney(msg.value.div(100).mul(1));
331 
332         Player storage _player = players[0];
333         uint256 _SysMoney = msg.value.div(100).mul(5);
334         _player.earnings = _player.earnings.add(_SysMoney);
335         _player.dividendEarnings = _player.dividendEarnings.add(_SysMoney);
336 
337 
338         uint256 _distributionMoney = msg.value.div(100).mul(10);
339         if (_p.parentId == 0) {
340             _player.earnings = _player.earnings.add(_distributionMoney);
341             _player.distributionEarnings = _player.distributionEarnings.add(_distributionMoney);
342         } else {
343             Player storage _player_ = players[_p.parentId.sub(1)];
344             _player_.earnings = _player_.earnings.add(_distributionMoney);
345             _player_.distributionEarnings = _player_.distributionEarnings.add(_distributionMoney);
346         }
347         if (_ticketCount > maxTotalTicket) {
348             maxTotalTicket = _ticketCount;
349             maxAirDropAddress = msg.sender;
350         }
351 
352         uint256 _airDropMoney = msg.value.div(100).mul(2);
353         airdropPrizePool = airdropPrizePool.add(_airDropMoney);
354         if (airdropPrizePool >= 1 ether) {
355             Player storage _playerAirdrop = players[addressMPid[maxAirDropAddress].sub(1)];
356             _playerAirdrop.earnings = _playerAirdrop.earnings.add(airdropPrizePool);
357             _playerAirdrop.dividendEarnings = _playerAirdrop.dividendEarnings.add(airdropPrizePool);
358             airdropPrizePool = 0;
359         }
360 
361         uint256 _remainderMoney = msg.value.sub((msg.value.div(100).mul(1)).mul(3)).sub(_SysMoney).
362         sub(_distributionMoney).sub(_airDropMoney);
363 
364         updateGameMoney(_remainderMoney, _spaceshipNo, _ticketCount, addressMPid[msg.sender].sub(1));
365 
366 
367     }
368 
369     function getFhMoney(uint256 _spaceshipNo, uint256 _money, uint256 _ticketCount, uint256 _targetNo) private view returns (uint256){
370         Spaceship memory _fc = spaceships[_spaceshipNo];
371         if (_spaceshipNo == _targetNo) {
372             uint256 _Ticket = _fc.ticketCount.sub(_ticketCount);
373             if (_Ticket == 0) {
374                 return 0;
375             }
376             return _money.div(_Ticket);
377         } else {
378             if (_fc.ticketCount == 0) {
379                 return 0;
380             }
381             return _money.div(_fc.ticketCount);
382         }
383     }
384 
385     function updateGameMoney(uint256 _money, uint256 _spaceshipNo, uint256 _ticketCount, uint256 _arrayPid) private {
386         uint256 _lastMoney = addMoonPrizePool(_money, _spaceshipNo);
387         uint256 _dlMoney = _lastMoney.div(100).mul(53);
388         uint256 _xzMoney = _lastMoney.div(100).mul(33);
389         uint256 _jcMoney = _lastMoney.sub(_dlMoney).sub(_xzMoney);
390         uint256 _dlFMoney = getFhMoney(0, _dlMoney, _ticketCount, _spaceshipNo);
391         uint256 _xzFMoney = getFhMoney(1, _xzMoney, _ticketCount, _spaceshipNo);
392         uint256 _jcFMoney = getFhMoney(2, _jcMoney, _ticketCount, _spaceshipNo);
393         _fhMoney(_dlFMoney, _xzFMoney, _jcFMoney, _arrayPid, _spaceshipNo, _ticketCount);
394 
395     }
396 
397     function _fhMoney(uint256 _dlFMoney, uint256 _xzFMoney, uint256 _jcFMoney, uint256 arrayPid, uint256 _spaceshipNo, uint256 _ticketCount) private {
398         for (uint i = 0; i < players.length; i++) {
399             Player storage _tmpP = players[i];
400             uint256 _totalMoney = 0;
401             if (arrayPid != i) {
402                 _totalMoney = _totalMoney.add(_tmpP.dlTicketCount.mul(_dlFMoney));
403                 _totalMoney = _totalMoney.add(_tmpP.xzTicketCount.mul(_xzFMoney));
404                 _totalMoney = _totalMoney.add(_tmpP.jcTicketCount.mul(_jcFMoney));
405             } else {
406                 if (_spaceshipNo == 0) {
407                     _totalMoney = _totalMoney.add((_tmpP.dlTicketCount.sub(_ticketCount)).mul(_dlFMoney));
408                 } else {
409                     _totalMoney = _totalMoney.add(_tmpP.dlTicketCount.mul(_dlFMoney));
410                 }
411                 if (_spaceshipNo == 1) {
412                     _totalMoney = _totalMoney.add((_tmpP.xzTicketCount.sub(_ticketCount)).mul(_xzFMoney));
413                 } else {
414                     _totalMoney = _totalMoney.add(_tmpP.xzTicketCount.mul(_xzFMoney));
415                 }
416                 if (_spaceshipNo == 2) {
417                     _totalMoney = _totalMoney.add((_tmpP.jcTicketCount.sub(_ticketCount)).mul(_jcFMoney));
418                 } else {
419                     _totalMoney = _totalMoney.add(_tmpP.jcTicketCount.mul(_jcFMoney));
420                 }
421             }
422             _tmpP.earnings = _tmpP.earnings.add(_totalMoney);
423             _tmpP.dividendEarnings = _tmpP.dividendEarnings.add(_totalMoney);
424         }
425     }
426 
427     function addMoonPrizePool(uint256 _money, uint256 _spaceshipNo) private returns (uint){
428         uint256 _tmpMoney;
429         if (_spaceshipNo == 0) {
430             _tmpMoney = _money.div(100).mul(80);
431             totalDividendEarnings = totalDividendEarnings.add((_money.sub(_tmpMoney)));
432         }
433         if (_spaceshipNo == 1) {
434             _tmpMoney = _money.div(100).mul(50);
435             totalDividendEarnings = totalDividendEarnings.add((_money.sub(_tmpMoney)));
436         }
437         if (_spaceshipNo == 2) {
438             _tmpMoney = _money.div(100).mul(20);
439             totalDividendEarnings = totalDividendEarnings.add((_money.sub(_tmpMoney)));
440         }
441         moonPrizePool = moonPrizePool.add(_tmpMoney);
442         return _money.sub(_tmpMoney);
443     }
444 
445 
446 
447     function addSpaceshipMoney(uint256 _money) internal {
448         Spaceship storage _spaceship0 = spaceships[0];
449         uint256 _pid0 = addressMPid[_spaceship0.captain];
450         Player storage _player0 = players[_pid0.sub(1)];
451         _player0.earnings = _player0.earnings.add(_money);
452         _player0.dividendEarnings = _player0.dividendEarnings.add(_money);
453 
454 
455         Spaceship storage _spaceship1 = spaceships[1];
456         uint256 _pid1 = addressMPid[_spaceship1.captain];
457         Player storage _player1 = players[_pid1.sub(1)];
458         _player1.earnings = _player1.earnings.add(_money);
459         _player1.dividendEarnings = _player1.dividendEarnings.add(_money);
460 
461 
462 
463         Spaceship storage _spaceship2 = spaceships[2];
464         uint256 _pid2 = addressMPid[_spaceship2.captain];
465         Player storage _player2 = players[_pid2.sub(1)];
466         _player2.earnings = _player2.earnings.add(_money);
467         _player2.dividendEarnings = _player2.dividendEarnings.add(_money);
468 
469 
470     }
471 
472     function getPlayerInfo(address _playerAddress) public view returns (
473         address _addr,
474         string _name,
475         uint256 _earnings,
476         uint256 _ticketCount,
477         uint256 _dividendEarnings,
478         uint256 _distributionEarnings,
479         uint256 _dlTicketCount,
480         uint256 _xzTicketCount,
481         uint256 _jcTicketCount
482     ){
483         uint256 _pid = addressMPid[_playerAddress];
484         Player storage _player = players[_pid.sub(1)];
485         _addr = _player.addr;
486         _name = _player.name;
487         _earnings = _player.earnings;
488         _ticketCount = _player.ticketCount;
489         _dividendEarnings = _player.dividendEarnings;
490         _distributionEarnings = _player.distributionEarnings;
491         _dlTicketCount = _player.dlTicketCount;
492         _xzTicketCount = _player.xzTicketCount;
493         _jcTicketCount = _player.jcTicketCount;
494     }
495 
496     function addSystemUserEarnings(uint256 _money) private {
497         Player storage _player = players[0];
498         _player.earnings = _player.earnings.add(_money);
499     }
500 
501     function withdraw() public {
502         require(addressMPid[msg.sender] != 0);
503         Player storage _player = players[addressMPid[msg.sender].sub(1)];
504         _player.addr.transfer(_player.earnings);
505         _player.withdrawalAmount = _player.withdrawalAmount.add(_player.earnings);
506         _player.earnings = 0;
507         _player.distributionEarnings = 0;
508         _player.dividendEarnings = 0;
509     }
510 
511     function makeMoney() public {
512         require(now > lotteryTime);
513         uint256 _pMoney = moonPrizePool.div(2);
514         Player storage _luckyPayer = players[luckyPayerId.sub(1)];
515         _luckyPayer.earnings = _luckyPayer.earnings.add(_pMoney);
516         uint256 _nextMoonPrizePool = moonPrizePool.div(100).mul(2);
517         uint256 _luckyCaptainMoney = moonPrizePool.div(100).mul(5);
518         uint256 _luckyCrewMoney = moonPrizePool.sub(_nextMoonPrizePool).sub(_luckyCaptainMoney).sub(_pMoney);
519         uint256 _no1Spaceship = getFastestSpaceship();
520         Spaceship storage _s = spaceships[_no1Spaceship];
521         uint256 _pid = addressMPid[_s.captain];
522         Player storage _pPayer = players[_pid.sub(1)];
523         _pPayer.earnings = _pPayer.earnings.add(_luckyCaptainMoney);
524 
525         uint256 _eachMoney = _getLuckySpaceshipMoney(_no1Spaceship, _luckyCrewMoney);
526         for (uint i = 0; i < players.length; i++) {
527             Player storage _tmpP = players[i];
528             if (_no1Spaceship == 0) {
529                 _tmpP.earnings = _tmpP.earnings.add(_tmpP.dlTicketCount.mul(_eachMoney));
530                 _tmpP.dividendEarnings = _tmpP.dividendEarnings.add(_tmpP.dlTicketCount.mul(_eachMoney));
531             }
532             if (_no1Spaceship == 1) {
533                 _tmpP.earnings = _tmpP.earnings.add(_tmpP.xzTicketCount.mul(_eachMoney));
534                 _tmpP.dividendEarnings = _tmpP.dividendEarnings.add(_tmpP.xzTicketCount.mul(_eachMoney));
535             }
536             if (_no1Spaceship == 2) {
537                 _tmpP.earnings = _tmpP.earnings.add(_tmpP.jcTicketCount.mul(_eachMoney));
538                 _tmpP.dividendEarnings = _tmpP.dividendEarnings.add(_tmpP.jcTicketCount.mul(_eachMoney));
539             }
540             _tmpP.dlTicketCount = 0;
541             _tmpP.xzTicketCount = 0;
542             _tmpP.jcTicketCount = 0;
543             _tmpP.ticketCount = 0;
544         }
545         _initSpaceship();
546         totalTicketCount = 0;
547         airdropPrizePool = 0;
548         moonPrizePool = _nextMoonPrizePool;
549         lotteryTime = now + 12 hours;
550         spaceshipPrice = 0.01 ether;
551         maxAirDropAddress = pidXAddress[1];
552         maxTotalTicket = 0;
553         round = round.add(1);
554         luckyPayerId = 1;
555     }
556 
557     function _initSpaceship() private {
558         for (uint i = 0; i < spaceships.length; i++) {
559             Spaceship storage _s = spaceships[i];
560             _s.captain = pidXAddress[1];
561             _s.ticketCount = 0;
562             _s.spaceshipPrice = 15 ether;
563             _s.speed = 100000;
564         }
565 
566     }
567 
568     function _getLuckySpaceshipMoney(uint256 _spaceshipId, uint256 _luckyMoney) private view returns (uint256){
569         Spaceship memory _s = spaceships[_spaceshipId];
570         uint256 _eachLuckyMoney = _luckyMoney.div(_s.ticketCount);
571         return _eachLuckyMoney;
572 
573     }
574 
575     function getFastestSpaceship() private view returns (uint256){
576         Spaceship memory _dlSpaceship = spaceships[0];
577         Spaceship memory _xzSpaceship = spaceships[1];
578         Spaceship memory _jcSpaceship = spaceships[2];
579 
580         uint256 _maxSpeed;
581         if (_jcSpaceship.speed >= _xzSpaceship.speed) {
582             if (_jcSpaceship.speed >= _dlSpaceship.speed) {
583                 _maxSpeed = 2;
584             } else {
585                 _maxSpeed = 0;
586             }
587         } else {
588             if (_xzSpaceship.speed >= _dlSpaceship.speed) {
589                 _maxSpeed = 1;
590             } else {
591                 _maxSpeed = 0;
592             }
593         }
594         return _maxSpeed;
595 
596     }
597 
598     function getGameInfo() public view returns (
599         uint256 _totalTicketCount,
600         uint256 _airdropPrizePool,
601         uint256 _moonPrizePool,
602         uint256 _lotteryTime,
603         uint256 _nowTime,
604         uint256 _spaceshipPrice,
605         uint256 _round,
606         uint256 _totalEarnings,
607         uint256 _totalDividendEarnings
608     ){
609         _totalTicketCount = totalTicketCount;
610         _airdropPrizePool = airdropPrizePool;
611         _moonPrizePool = moonPrizePool;
612         _lotteryTime = lotteryTime;
613         _nowTime = now;
614         _spaceshipPrice = spaceshipPrice;
615         _round = round;
616         _totalEarnings = totalEarnings;
617         _totalDividendEarnings = totalDividendEarnings;
618     }
619 
620     function _updateSpaceshipPrice(uint256 _spaceshipId) internal {
621         spaceships[_spaceshipId].spaceshipPrice = spaceships[_spaceshipId].spaceshipPrice.add(
622             spaceships[_spaceshipId].spaceshipPrice.mul(3).div(10));
623     }
624 
625     function campaignCaptain(uint _spaceshipId) external payable {
626         require(now < lotteryTime);
627         require(msg.value == spaceships[_spaceshipId].spaceshipPrice);
628         if (addressMPid[msg.sender] == 0) {
629             uint256 playerArrayIndex = players.push(Player(msg.sender, "", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0));
630             addressMPid[msg.sender] = playerArrayIndex;
631             pidXAddress[playerArrayIndex] = msg.sender;
632             playerCount = players.length;
633         }
634         spaceships[_spaceshipId].captain.transfer(msg.value);
635         spaceships[_spaceshipId].captain = msg.sender;
636         _updateSpaceshipPrice(_spaceshipId);
637     }
638 }
639 
640 /**
641  * @title SafeMath
642  * @dev Math operations with safety checks that revert on error
643  */
644 library SafeMath {
645 
646     /**
647     * @dev Multiplies two numbers, reverts on overflow.
648     */
649     function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
650         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
651         // benefit is lost if 'b' is also tested.
652         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
653         if (_a == 0) {
654             return 0;
655         }
656 
657         uint256 c = _a * _b;
658         require(c / _a == _b);
659 
660         return c;
661     }
662 
663     /**
664     * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
665     */
666     function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
667         require(_b > 0);
668         // Solidity only automatically asserts when dividing by 0
669         uint256 c = _a / _b;
670         // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
671 
672         return c;
673     }
674 
675     /**
676     * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
677     */
678     function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
679         require(_b <= _a);
680         uint256 c = _a - _b;
681 
682         return c;
683     }
684 
685     /**
686     * @dev Adds two numbers, reverts on overflow.
687     */
688     function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
689         uint256 c = _a + _b;
690         require(c >= _a);
691 
692         return c;
693     }
694 
695     /**
696     * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
697     * reverts when dividing by zero.
698     */
699     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
700         require(b != 0);
701         return a % b;
702     }
703 }