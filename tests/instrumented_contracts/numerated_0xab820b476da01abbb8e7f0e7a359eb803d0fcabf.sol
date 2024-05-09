1 /*
2  * SuperFOMO - зарабатывай до 11,5% в сутки!
3  *
4  * Мин. размер депозита 0.05 eth
5  * Мин. размер депозита для участия в розыгрыше джек-пота: 1eth
6  *
7  * Схема распределения входящих средств:
8  * 100% на выплаты участникам
9  *
10  * ИНВЕСТИЦИОННЫЙ ПЛАН:
11  * чем позже зашел - тем больше заработал!
12  *
13  * Каждый депозит работает отдельно до своего удвоения
14  *
15  * Депозиты сделанные в период с 1 по 12 день жизни контракта: 2,5% в день
16  * Депозиты сделанные в период с 12 по 18 день жизни контракта: 3,5% в день
17  * Депозиты сделанные в период с 18 по 24 день жизни контракта: 4,5% в день
18  * Депозиты сделанные в период с 24 по 30 день жизни контракта: 5,5% в день
19  * Депозиты сделанные в период с 30 по 36 день жизни контракта: 6,5% в день
20  * Депозиты сделанные в период с 36 по 42 день жизни контракта: 7,5% в день
21  * Депозиты сделанные в период с 42 по 48 день жизни контракта: 8,5% в день
22  * Депозиты сделанные в период с 48 по 54 день жизни контракта: 9,5% в день
23  * Депозиты сделанные в период с 54 дня жизни контракта: 10% в день
24  *
25  * БОНУС ХОЛДЕРАМ:
26  * Тем, кто не заказывает вывод процентов в течение 48 часов включается бонус на все депозиты +1,5% в сутки каждый день.
27  *
28  * ДЖЕК-ПОТ:
29  * С каждого депозита 3% "замораживается" на балансе контракта в фонд джек-пота.
30  *
31  * Условия розыгрыша:
32  * При отсутствии новых депозитов (от 1 eth и более) более 24 часов фонд джек-пота распределяется между последними 5 вкладчиками с депозитом 1 eth и более.
33  * 60% джек-пота начисляются для вывода последнему вкладчику и по 10% еще 4м вкладчикам с депозитами от  1 eth и более.
34  * После розыгрыша джек-пот начинает накапливаться заново.
35  *
36  * Партнерская программа:
37  * Для участия в партнерской программе у вас должен быть свой депозит, по которому вы получаете начисления.
38  * Для получения вознаграждения ваш приглашенный должен указать адрес вашего кошелька eth в поле data.
39  *
40  * Бонус приглашенному: вносимый депозит увечивается на 2%
41  * Бонус пригласителю: автоматически выплачивается 5% от суммы пополнения
42  *
43  * ИНСТРУКЦИЯ:
44  * *  1. Отправить eth (больше 0.05) для создания депозита.
45  * *  2. Для получения выплаты по всем депозитам необходимо отправить от 0 до 0,05 eth на адрес смарт контракта, счетчик холда при это сбрасывается.
46  * *  3. Если отправлено 0,05 или более eth создается новый депозит, но начисленные проценты не выплачиваются и счетчик холда не сбрасывается. С каждой выплаты 12% отправляется на рекламу и 3% на тех. поддержку проекта.
47  *
48  */
49 
50 
51 
52 
53 
54 
55 
56 
57 pragma solidity 0.4.25;
58 
59 
60 library SafeMath {
61 
62 
63     function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
64         if (_a == 0) {
65             return 0;
66         }
67 
68         uint256 c = _a * _b;
69         require(c / _a == _b);
70 
71         return c;
72     }
73 
74     function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
75         require(_b > 0);
76         uint256 c = _a / _b;
77 
78         return c;
79     }
80 
81     function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
82         require(_b <= _a);
83         uint256 c = _a - _b;
84 
85         return c;
86     }
87 
88     function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
89         uint256 c = _a + _b;
90         require(c >= _a);
91 
92         return c;
93     }
94 
95     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
96         require(b != 0);
97         return a % b;
98     }
99 }
100 
101 contract Storage {
102 
103     address private owner;
104 
105     mapping (address => Investor) investors;
106 
107     struct Investor {
108         uint index;
109         mapping (uint => uint) deposit;
110         mapping (uint => uint) interest;
111         mapping (uint => uint) withdrawals;
112         mapping (uint => uint) start;
113         uint checkpoint;
114     }
115 
116     constructor() public {
117         owner = msg.sender;
118     }
119 
120     modifier onlyOwner() {
121         require(msg.sender == owner);
122         _;
123     }
124 
125     function updateInfo(address _address, uint _value, uint _interest) external onlyOwner {
126         investors[_address].deposit[investors[_address].index] += _value;
127         investors[_address].start[investors[_address].index] = block.timestamp;
128         investors[_address].interest[investors[_address].index] = _interest;
129     }
130 
131     function updateCheckpoint(address _address) external onlyOwner {
132         investors[_address].checkpoint = block.timestamp;
133     }
134 
135     function updateWithdrawals(address _address, uint _index, uint _withdrawal) external onlyOwner {
136         investors[_address].withdrawals[_index] += _withdrawal;
137     }
138 
139     function updateIndex(address _address) external onlyOwner {
140         investors[_address].index += 1;
141     }
142 
143     function ind(address _address) external view returns(uint) {
144         return investors[_address].index;
145     }
146 
147     function d(address _address, uint _index) external view returns(uint) {
148         return investors[_address].deposit[_index];
149     }
150 
151     function i(address _address, uint _index) external view returns(uint) {
152         return investors[_address].interest[_index];
153     }
154 
155     function w(address _address, uint _index) external view returns(uint) {
156         return investors[_address].withdrawals[_index];
157     }
158 
159     function s(address _address, uint _index) external view returns(uint) {
160         return investors[_address].start[_index];
161     }
162 
163     function c(address _address) external view returns(uint) {
164         return investors[_address].checkpoint;
165     }
166 }
167 
168 contract SuperFOMO {
169     using SafeMath for uint;
170 
171     address public owner;
172     address advertising;
173     address techsupport;
174 
175     uint waveStartUp;
176     uint jackPot;
177     uint lastLeader;
178 
179     address[] top;
180 
181     Storage x;
182 
183     event LogInvestment(address indexed _addr, uint _value);
184     event LogPayment(address indexed _addr, uint _value);
185     event LogReferralInvestment(address indexed _referrer, address indexed _referral, uint _value);
186     event LogGift(address _firstAddr, address _secondAddr, address _thirdAddr, address _fourthAddr, address _fifthAddr);
187     event LogNewWave(uint _waveStartUp);
188     event LogNewLeader(address _leader);
189 
190     modifier notOnPause() {
191         require(waveStartUp <= block.timestamp);
192         _;
193     }
194 
195     modifier notFromContract() {
196         address addr = msg.sender;
197         uint size;
198         assembly { size := extcodesize(addr) }
199         require(size <= 0);
200         _;
201     }
202 
203     constructor(address _advertising, address _techsupport) public {
204         owner = msg.sender;
205         advertising = _advertising;
206         techsupport = _techsupport;
207         waveStartUp = block.timestamp;
208         x = new Storage();
209     }
210 
211     function renounceOwnership() external {
212         require(msg.sender == owner);
213         owner = 0x0;
214     }
215 
216     function bytesToAddress(bytes _source) internal pure returns(address parsedreferrer) {
217         assembly {
218             parsedreferrer := mload(add(_source,0x14))
219         }
220         return parsedreferrer;
221     }
222 
223     function setRef() internal returns(uint) {
224         address _referrer = bytesToAddress(bytes(msg.data));
225         if (_referrer != msg.sender && getDividends(_referrer) > 0) {
226             _referrer.transfer(msg.value / 20);
227 
228             emit LogReferralInvestment(_referrer, msg.sender, msg.value);
229             return(msg.value / 50);
230         } else {
231             advertising.transfer(msg.value / 20);
232             return(0);
233         }
234     }
235 
236     function getInterest() public view returns(uint) {
237         uint multiplier = (block.timestamp.sub(waveStartUp)) / 6 days;
238         if (multiplier == 0) {
239             return 25;
240         }
241         if (multiplier <= 8){
242             return(15 + (multiplier * 10));
243         } else {
244             return 100;
245         }
246     }
247 
248     function toTheTop() internal {
249         top.push(msg.sender);
250         lastLeader = block.timestamp;
251 
252         emit LogNewLeader(msg.sender);
253     }
254 
255     function payDay() internal {
256         top[top.length - 1].transfer(jackPot * 3 / 5);
257         top[top.length - 2].transfer(jackPot / 10);
258         top[top.length - 3].transfer(jackPot / 10);
259         top[top.length - 4].transfer(jackPot / 10);
260         top[top.length - 5].transfer(jackPot / 10);
261         jackPot = 0;
262         lastLeader = block.timestamp;
263         emit LogGift(top[top.length - 1], top[top.length - 2], top[top.length - 3], top[top.length - 4], top[top.length - 5]);
264     }
265 
266     function() external payable {
267         if (msg.value < 50000000000000000) {
268             msg.sender.transfer(msg.value);
269             withdraw();
270         } else {
271             invest();
272         }
273     }
274 
275     function invest() public payable notOnPause notFromContract {
276 
277         require(msg.value >= 0.05 ether);
278         jackPot += msg.value * 3 / 100;
279 
280         if (x.d(msg.sender, 0) > 0) {
281             x.updateIndex(msg.sender);
282         } else {
283             x.updateCheckpoint(msg.sender);
284         }
285 
286         if (msg.data.length == 20) {
287             uint addend = setRef();
288         } else {
289             advertising.transfer(msg.value / 20);
290         }
291 
292         x.updateInfo(msg.sender, msg.value + addend, getInterest());
293 
294 
295         if (msg.value >= 1 ether) {
296             toTheTop();
297         }
298 
299         emit LogInvestment(msg.sender, msg.value);
300     }
301 
302     function withdraw() public {
303 
304         uint _payout;
305 
306         uint _multiplier;
307 
308         if (block.timestamp > x.c(msg.sender) + 2 days) {
309             _multiplier = 1;
310         }
311 
312         for (uint i = 0; i <= x.ind(msg.sender); i++) {
313             if (x.w(msg.sender, i) < x.d(msg.sender, i) * 2) {
314                 if (x.s(msg.sender, i) <= x.c(msg.sender)) {
315                     uint dividends = (x.d(msg.sender, i).mul(_multiplier.mul(15).add(x.i(msg.sender, i))).div(1000)).mul(block.timestamp.sub(x.c(msg.sender).add(_multiplier.mul(2 days)))).div(1 days);
316                     dividends = dividends.add(x.d(msg.sender, i).mul(x.i(msg.sender, i)).div(1000).mul(_multiplier).mul(2));
317                     if (x.w(msg.sender, i) + dividends <= x.d(msg.sender, i) * 2) {
318                         x.updateWithdrawals(msg.sender, i, dividends);
319                         _payout = _payout.add(dividends);
320                     } else {
321                         _payout = _payout.add((x.d(msg.sender, i).mul(2)).sub(x.w(msg.sender, i)));
322                         x.updateWithdrawals(msg.sender, i, x.d(msg.sender, i) * 2);
323                     }
324                 } else {
325                     if (x.s(msg.sender, i) + 2 days >= block.timestamp) {
326                         dividends = (x.d(msg.sender, i).mul(_multiplier.mul(15).add(x.i(msg.sender, i))).div(1000)).mul(block.timestamp.sub(x.s(msg.sender, i).add(_multiplier.mul(2 days)))).div(1 days);
327                         dividends = dividends.add(x.d(msg.sender, i).mul(x.i(msg.sender, i)).div(1000).mul(_multiplier).mul(2));
328                         if (x.w(msg.sender, i) + dividends <= x.d(msg.sender, i) * 2) {
329                             x.updateWithdrawals(msg.sender, i, dividends);
330                             _payout = _payout.add(dividends);
331                         } else {
332                             _payout = _payout.add((x.d(msg.sender, i).mul(2)).sub(x.w(msg.sender, i)));
333                             x.updateWithdrawals(msg.sender, i, x.d(msg.sender, i) * 2);
334                         }
335                     } else {
336                         dividends = (x.d(msg.sender, i).mul(x.i(msg.sender, i)).div(1000)).mul(block.timestamp.sub(x.s(msg.sender, i))).div(1 days);
337                         x.updateWithdrawals(msg.sender, i, dividends);
338                         _payout = _payout.add(dividends);
339                     }
340                 }
341 
342             }
343         }
344 
345         if (_payout > 0) {
346             if (_payout > address(this).balance && address(this).balance <= 0.1 ether) {
347                 nextWave();
348                 return;
349             }
350             x.updateCheckpoint(msg.sender);
351             advertising.transfer(_payout * 3 / 25);
352             techsupport.transfer(_payout * 3 / 100);
353             msg.sender.transfer(_payout * 17 / 20);
354 
355             emit LogPayment(msg.sender, _payout * 17 / 20);
356         }
357 
358         if (block.timestamp >= lastLeader + 1 days && top.length >= 5) {
359             payDay();
360         }
361     }
362 
363     function nextWave() private {
364         top.length = 0;
365         x = new Storage();
366         waveStartUp = block.timestamp + 10 days;
367         emit LogNewWave(waveStartUp);
368     }
369 
370     function getDeposits(address _address) public view returns(uint Invested) {
371         uint _sum;
372         for (uint i = 0; i <= x.ind(_address); i++) {
373             if (x.w(_address, i) < x.d(_address, i) * 2) {
374                 _sum += x.d(_address, i);
375             }
376         }
377         Invested = _sum;
378     }
379 
380     function getDepositN(address _address, uint _number) public view returns(uint Deposit_N) {
381         if (x.w(_address, _number - 1) < x.d(_address, _number - 1) * 2) {
382             Deposit_N = x.d(_address, _number - 1);
383         } else {
384             Deposit_N = 0;
385         }
386     }
387 
388     function getDividends(address _address) public view returns(uint Dividends) {
389 
390         uint _payout;
391         uint _multiplier;
392 
393         if (block.timestamp > x.c(_address) + 2 days) {
394             _multiplier = 1;
395         }
396 
397         for (uint i = 0; i <= x.ind(_address); i++) {
398             if (x.w(_address, i) < x.d(_address, i) * 2) {
399                 if (x.s(_address, i) <= x.c(_address)) {
400                     uint dividends = (x.d(_address, i).mul(_multiplier.mul(15).add(x.i(_address, i))).div(1000)).mul(block.timestamp.sub(x.c(_address).add(_multiplier.mul(2 days)))).div(1 days);
401                     dividends += (x.d(_address, i).mul(x.i(_address, i)).div(1000).mul(_multiplier).mul(2));
402                     if (x.w(_address, i) + dividends <= x.d(_address, i) * 2) {
403                         _payout = _payout.add(dividends);
404                     } else {
405                         _payout = _payout.add((x.d(_address, i).mul(2)).sub(x.w(_address, i)));
406                     }
407                 } else {
408                     if (x.s(_address, i) + 2 days >= block.timestamp) {
409                         dividends = (x.d(_address, i).mul(_multiplier.mul(15).add(x.i(_address, i))).div(1000)).mul(block.timestamp.sub(x.s(_address, i).add(_multiplier.mul(2 days)))).div(1 days);
410                         dividends += (x.d(_address, i).mul(x.i(_address, i)).div(1000).mul(_multiplier).mul(2));
411                         if (x.w(_address, i) + dividends <= x.d(_address, i) * 2) {
412                             _payout = _payout.add(dividends);
413                         } else {
414                             _payout = _payout.add((x.d(_address, i).mul(2)).sub(x.w(_address, i)));
415                         }
416                     } else {
417                         dividends = (x.d(_address, i).mul(x.i(_address, i)).div(1000)).mul(block.timestamp.sub(x.s(_address, i))).div(1 days);
418                         _payout = _payout.add(dividends);
419                     }
420                 }
421 
422             }
423         }
424 
425         Dividends = _payout * 17 / 20;
426     }
427 
428     function getWithdrawals(address _address) external view returns(uint) {
429         uint _sum;
430         for (uint i = 0; i <= x.ind(_address); i++) {
431             _sum += x.w(_address, i);
432         }
433         return(_sum);
434     }
435 
436     function getTop() external view returns(address, address, address, address, address) {
437         return(top[top.length - 1], top[top.length - 2], top[top.length - 3], top[top.length - 4], top[top.length - 5]);
438     }
439 
440     function getJackPot() external view returns(uint) {
441         return(jackPot);
442     }
443 
444     function getNextPayDay() external view returns(uint) {
445         return(lastLeader + 1 days);
446     }
447 
448 }