1 pragma solidity ^0.4.24;
2 
3 interface CitizenInterface {
4     /*----------  READ FUNCTIONS  ----------*/
5     function getUsername(address _address) public view returns (string);
6     function getRef(address _address) public view returns (address);
7 }
8 
9 interface F2mInterface {
10     function pushDividends() public payable;
11 }
12 
13 library SafeMath {
14     int256 constant private INT256_MIN = -2**255;
15 
16     /**
17     * @dev Multiplies two unsigned integers, reverts on overflow.
18     */
19     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
20         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
21         // benefit is lost if 'b' is also tested.
22         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
23         if (a == 0) {
24             return 0;
25         }
26 
27         uint256 c = a * b;
28         require(c / a == b);
29 
30         return c;
31     }
32 
33     /**
34     * @dev Multiplies two signed integers, reverts on overflow.
35     */
36     function mul(int256 a, int256 b) internal pure returns (int256) {
37         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
38         // benefit is lost if 'b' is also tested.
39         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
40         if (a == 0) {
41             return 0;
42         }
43 
44         require(!(a == -1 && b == INT256_MIN)); // This is the only case of overflow not detected by the check below
45 
46         int256 c = a * b;
47         require(c / a == b);
48 
49         return c;
50     }
51 
52     /**
53     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
54     */
55     function div(uint256 a, uint256 b) internal pure returns (uint256) {
56         // Solidity only automatically asserts when dividing by 0
57         require(b > 0);
58         uint256 c = a / b;
59         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
60 
61         return c;
62     }
63 
64     /**
65     * @dev Integer division of two signed integers truncating the quotient, reverts on division by zero.
66     */
67     function div(int256 a, int256 b) internal pure returns (int256) {
68         require(b != 0); // Solidity only automatically asserts when dividing by 0
69         require(!(b == -1 && a == INT256_MIN)); // This is the only case of overflow
70 
71         int256 c = a / b;
72 
73         return c;
74     }
75 
76     /**
77     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
78     */
79     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
80         require(b <= a);
81         uint256 c = a - b;
82 
83         return c;
84     }
85 
86     /**
87     * @dev Subtracts two signed integers, reverts on overflow.
88     */
89     function sub(int256 a, int256 b) internal pure returns (int256) {
90         int256 c = a - b;
91         require((b >= 0 && c <= a) || (b < 0 && c > a));
92 
93         return c;
94     }
95 
96     /**
97     * @dev Adds two unsigned integers, reverts on overflow.
98     */
99     function add(uint256 a, uint256 b) internal pure returns (uint256) {
100         uint256 c = a + b;
101         require(c >= a);
102 
103         return c;
104     }
105 
106     /**
107     * @dev Adds two signed integers, reverts on overflow.
108     */
109     function add(int256 a, int256 b) internal pure returns (int256) {
110         int256 c = a + b;
111         require((b >= 0 && c >= a) || (b < 0 && c < a));
112 
113         return c;
114     }
115 
116     /**
117     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
118     * reverts when dividing by zero.
119     */
120     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
121         require(b != 0);
122         return a % b;
123     }
124 }
125 
126 contract Helper {
127     uint256 constant public GAS_COST = 0.002 ether;
128     uint256 constant public MAX_BLOCK_DISTANCE = 254;
129     uint256 constant public ZOOM = 1000000000;
130 
131     function getKeyBlockNr(uint256 _estKeyBlockNr)
132         public
133         view
134         returns(uint256)
135     {
136         require(block.number > _estKeyBlockNr, "blockHash not avaiable");
137         uint256 jump = (block.number - _estKeyBlockNr) / MAX_BLOCK_DISTANCE * MAX_BLOCK_DISTANCE;
138         return _estKeyBlockNr + jump;
139     }
140 
141     function getSeed(uint256 _keyBlockNr)
142         public
143         view
144         returns (uint256)
145     {
146         // Key Block not mined atm
147         if (block.number <= _keyBlockNr) return block.number;
148         return uint256(blockhash(_keyBlockNr));
149     }
150 
151     function getWinTeam(
152         uint256 _seed,
153         uint256 _trueAmount,
154         uint256 _falseAmount
155     )
156         public
157         pure
158         returns (bool)
159     {
160         uint256 _sum = _trueAmount + _falseAmount;
161         if (_sum == 0) return true;
162         return (_seed % _sum) < _trueAmount;
163     }
164 
165     function getWinningPerWei(
166         uint256 _winTeam,
167         uint256 _lostTeam
168     )
169         public
170         pure
171         returns (uint256)
172     {
173         return _lostTeam * ZOOM / _winTeam;
174     }
175 
176     function getMin(
177         uint256 a,
178         uint256 b
179     )
180         public
181         pure
182         returns (uint256)
183     {
184         return a < b ? a : b;
185     }
186 }
187 
188 contract SimpleDice is Helper{
189     using SafeMath for uint256;
190 
191     event Payment(address indexed _winner, uint _amount, bool _success);
192 
193     modifier onlyDevTeam() {
194         require(msg.sender == devTeam, "only development team");
195         _;
196     }
197 
198     modifier betable() {
199         uint256 _keyBlock = rounds[curRoundId].keyBlock;
200         require(msg.value >= MIN_BET, "betAmount too low");
201         require(block.number <= _keyBlock, "round locked");
202         _;
203     }
204 
205     modifier roundLocked() {
206         uint256 _keyBlock = rounds[curRoundId].keyBlock;
207         require(block.number > _keyBlock, "still betable");
208         _;
209     }
210 
211     struct Bet{
212         address buyer;
213         uint256 amount;
214     }
215 
216     struct Round {
217         mapping(bool => Bet[]) bets;
218         mapping(bool => uint256) betSum;
219 
220         uint256 keyBlock;
221         bool finalized;
222         bool winTeam;
223         uint256 cashoutFrom;
224         uint256 winningPerWei; // Zoomed
225     }
226     
227     uint256 constant public TAXED_PERCENT = 95;
228     uint256 constant public BLOCK_TIME = 15;
229     uint256 constant public DURATION = 300; // 5 min.
230     uint256 constant public MIN_BET = 0.05 ether;
231     uint256 constant public F2M_PERCENT = 10;
232     uint256 constant public MAX_ROUND = 888888888;
233 
234     uint256 public MAX_CASHOUT_PER_BLOCK = 100;
235 
236     address public devTeam;
237     F2mInterface public f2mContract;
238     uint256 public fund;
239 
240     uint256 public curRoundId;
241     mapping(uint256 => Round) public rounds;
242     mapping(address => mapping(uint256 => mapping(bool => uint256))) pRoundBetSum;
243 
244     CitizenInterface public citizenContract;
245 
246     constructor(address _devTeam, address _citizen) public {
247         devTeam = _devTeam;
248         citizenContract = CitizenInterface(_citizen);
249         initRound();
250     }
251 
252     function devTeamWithdraw()
253         public
254         onlyDevTeam()
255     {
256         require(fund > 0, "nothing to withdraw");
257         uint256 _toF2m = fund / 100 * F2M_PERCENT;
258         uint256 _toDevTeam = fund - _toF2m;
259         fund = 0;
260         f2mContract.pushDividends.value(_toF2m)();
261         devTeam.transfer(_toDevTeam);
262     }
263 
264     function initRound()
265         private
266     {
267         curRoundId++;
268         Round memory _round;
269         _round.keyBlock = MAX_ROUND; // block.number + 1 + DURATION / BLOCK_TIME;
270         rounds[curRoundId] = _round;
271     }
272 
273     function finalize()
274         private
275     {
276         uint256 _keyBlock = getKeyBlockNr(rounds[curRoundId].keyBlock);
277         uint256 _seed = getSeed(_keyBlock);
278         bool _winTeam = _seed % 2 == 0;
279         //getWinTeam(_seed, rounds[curRoundId].betSum[true], rounds[curRoundId].betSum[false]);
280         rounds[curRoundId].winTeam = _winTeam;
281         // winAmount Per Wei zoomed 
282         rounds[curRoundId].winningPerWei = getWinningPerWei(rounds[curRoundId].betSum[_winTeam], rounds[curRoundId].betSum[!_winTeam]);
283         rounds[curRoundId].finalized = true;
284         fund = address(this).balance - rounds[curRoundId].betSum[_winTeam] - rounds[curRoundId].betSum[!_winTeam];
285     }
286 
287     function payment(
288         address _buyer,
289         uint256 _winAmount
290     ) 
291         private
292     {
293         bool success = _buyer.send(_winAmount);
294         emit Payment(_buyer, _winAmount, success);
295     }
296 
297     function distribute()
298         private
299     {
300         address _buyer;
301         uint256 _betAmount;
302         uint256 _winAmount;
303         uint256 _from = rounds[curRoundId].cashoutFrom;
304         bool _winTeam = rounds[curRoundId].winTeam;
305         uint256 _teamBets = rounds[curRoundId].bets[_winTeam].length;
306         uint256 _to = getMin(_teamBets, _from + MAX_CASHOUT_PER_BLOCK);
307         uint256 _perWei = rounds[curRoundId].winningPerWei;
308         
309         //GAS BURNING 
310         while (_from < _to) {
311             _buyer = rounds[curRoundId].bets[_winTeam][_from].buyer;
312             _betAmount = rounds[curRoundId].bets[_winTeam][_from].amount;
313             _winAmount = _betAmount / ZOOM * _perWei + _betAmount;
314             payment(_buyer, _winAmount);
315             _from++;
316         }
317         rounds[curRoundId].cashoutFrom = _from;
318     }
319 
320     function isDistributed()
321         public
322         view
323         returns (bool)
324     {
325         bool _winTeam = rounds[curRoundId].winTeam;
326         return (rounds[curRoundId].cashoutFrom == rounds[curRoundId].bets[_winTeam].length);
327     }
328 
329     function endRound()
330         public
331         roundLocked()
332     {
333         if (!rounds[curRoundId].finalized) finalize();
334         distribute();
335         if (isDistributed()) initRound();
336     }
337 
338     // _team = {true, false}
339     function bet(
340         bool _team
341     )
342         public
343         payable
344         betable()
345     {
346         // active timer if both Teams got player(s)
347         if (rounds[curRoundId].betSum[_team] == 0 && rounds[curRoundId].betSum[!_team] > 0) 
348             rounds[curRoundId].keyBlock = block.number + 1 + DURATION / BLOCK_TIME;
349         address _sender = msg.sender;
350         uint256 _betAmount = (msg.value).sub(GAS_COST);
351         address _ref = getRef(msg.sender);
352         _ref.transfer(_betAmount / 100);
353         _betAmount = _betAmount / 100 * TAXED_PERCENT;
354         
355         Bet memory _bet = Bet(_sender, _betAmount);
356         rounds[curRoundId].bets[_team].push(_bet);
357         rounds[curRoundId].betSum[_team] += _betAmount;
358 
359         pRoundBetSum[_sender][curRoundId][_team] += _betAmount;
360     }
361 
362     // BACKEND FUNCTION
363 
364     function distributeSetting(uint256 _limit)
365         public
366         onlyDevTeam()
367     {
368         require(_limit >= 1, "cashout at least for one each tx");
369         MAX_CASHOUT_PER_BLOCK = _limit;
370     }
371 
372     function setF2mContract(address _address)
373         public
374     {
375         require(address(f2mContract) == 0x0, "already set");
376         f2mContract = F2mInterface(_address);
377     }
378 
379     // READING FUNCTIONS
380 
381     // if return true
382     // Backend : call endRound()
383     function isLocked() 
384         public
385         view
386         returns(bool)
387     {
388         return rounds[curRoundId].keyBlock <= block.number;
389     }
390 
391     function getRef(address _address)
392         public
393         view
394         returns(address)
395     {
396         address _ref = citizenContract.getRef(_address);
397         return _ref;
398     }
399 
400     function getUsername(address _address)
401         public
402         view
403         returns (string)
404     {
405         return citizenContract.getUsername(_address);
406     }
407 
408     function getBlockDist()
409         public
410         view
411         returns(uint256)
412     {
413         if (rounds[curRoundId].keyBlock == MAX_ROUND) return MAX_ROUND;
414         if (rounds[curRoundId].keyBlock <= block.number) return 0;
415         return rounds[curRoundId].keyBlock - block.number;
416 
417     }
418 
419     function getRoundResult(uint256 _rId)
420         public
421         view
422         returns(
423             uint256, // _trueAmount,
424             uint256, // _falseAmount,
425             uint256, // _trueBets
426             uint256, // _falseBets
427             uint256, // curBlock
428             uint256, // keyBlock
429             bool,
430             bool // winTeam
431         )
432     {
433         Round storage _round = rounds[_rId];
434         return(
435             _round.betSum[true],
436             _round.betSum[false],
437             _round.bets[true].length,
438             _round.bets[false].length,
439             block.number,
440             _round.keyBlock,
441             _round.finalized,
442             _round.winTeam
443         );
444     }
445 
446     function getCurRoundResult()
447         public
448         view
449         returns(
450             uint256, // _trueAmount
451             uint256, // _falseAmount
452             uint256, // _trueBets
453             uint256, // _falseBets
454             uint256, // curBlock
455             uint256, // keyBlock
456             bool, // finalized
457             bool // winTeam
458         )
459     {
460         Round storage _round = rounds[curRoundId];
461         return(
462             _round.betSum[true],
463             _round.betSum[false],
464             _round.bets[true].length,
465             _round.bets[false].length,
466             block.number,
467             _round.keyBlock,
468             _round.finalized,
469             _round.winTeam
470         );
471     }
472 
473     function getPRoundBetSum(address _player, uint256 _rId)
474         public
475         view
476         returns(string, uint256[2])
477     {
478         string memory _username = getUsername(_player);
479         return (_username, [pRoundBetSum[_player][_rId][true], pRoundBetSum[_player][_rId][false]]);
480     }
481 
482     function getRoundBetById(uint256 _rId, bool _team, uint256 _id)
483         public
484         view
485         returns(address, string, uint256)
486     {
487         address _address = rounds[_rId].bets[_team][_id].buyer;
488         string memory _username = getUsername(_address);
489         return (_address, _username, rounds[_rId].bets[_team][_id].amount);
490     }
491 }