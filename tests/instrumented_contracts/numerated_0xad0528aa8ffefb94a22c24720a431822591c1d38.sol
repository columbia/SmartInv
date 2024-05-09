1 pragma solidity 0.4.24;
2 
3 contract Owned {
4     address public owner;
5 
6     constructor() public {
7         owner = msg.sender;
8     }
9 
10     modifier onlyOwner() {
11         require(msg.sender == owner);
12         _;
13     }
14 
15     function transferOwnership(address newOwner) public onlyOwner {
16         require(newOwner != address(0));
17         owner = newOwner;
18     }
19 }
20 
21 contract SafeMath {
22     function multiplication(uint a, uint b) internal pure returns (uint) {
23         uint c = a * b;
24         assert(a == 0 || c / a == b);
25         return c;
26     }
27 
28     function division(uint a, uint b) internal pure returns (uint) {
29         assert(b > 0);
30         uint c = a / b;
31         assert(a == b * c + a % b);
32         return c;
33     }
34 
35     function subtraction(uint a, uint b) internal pure returns (uint) {
36         assert(b <= a);
37         return a - b;
38     }
39 
40     function addition(uint a, uint b) internal pure returns (uint) {
41         uint c = a + b;
42         assert(c >= a);
43         return c;
44     }
45 }
46 
47 contract LottoEvents {
48     event BuyTicket(uint indexed _gameIndex, address indexed from, bytes numbers, uint _prizePool, uint _bonusPool);
49     event LockRound(uint indexed _gameIndex, uint _state, uint indexed _blockIndex);
50     event DrawRound(uint indexed _gameIndex, uint _state, uint indexed _blockIndex, string _blockHash, uint[] _winNumbers);
51     event EndRound(uint indexed _gameIndex, uint _state, uint _jackpot, uint _bonusAvg, address[] _jackpotWinners, address[] _goldKeyWinners, bool _autoStartNext);
52     event NewRound(uint indexed _gameIndex, uint _state, uint _initPrizeIn);
53     event DumpPrize(uint indexed _gameIndex, uint _jackpot);
54     event Transfer(uint indexed _gameIndex, uint value);
55     event Activated(uint indexed _gameIndex);
56     event Deactivated(uint indexed _gameIndex);
57     event SelfDestroy(uint indexed _gameIndex);
58 }
59 
60 library LottoModels {
61 
62     // data struct hold each ticket info
63     struct Ticket {
64         uint rId;           // round identity
65         address player;     // the buyer
66         uint btime;         // buy time
67         uint[] numbers;     // buy numbers, idx 0,1,2,3,4 are red balls, idx 5 are blue balls
68         bool joinBonus;     // join bonus ?
69         bool useGoldKey;    // use gold key ?
70     }
71 
72     // if round ended, each state is freeze, just for view
73     struct Round {
74         uint rId;            // current id
75         uint stime;          // start time
76         uint etime;          // end time
77         uint8 state;         // 0: live, 1: locked, 2: drawed, 7: ended
78 
79         uint[] winNumbers;   // idx 0,1,2,3,4 are red balls, idx 5 are blue balls
80         address[] winners;   // the winner's addresses
81 
82         uint ethIn;          // how much eth in this Round
83         uint prizePool;      // how much eth in prize pool, 40% of ethIn add init prize in
84         uint bonusPool;      // how much eth in bonus pool, 40% of ethIn
85         uint teamFee;        // how much eth to team, 20% of ethIn
86 
87         uint btcBlockNoWhenLock; // the btc block no when lock this round
88         uint btcBlockNo;         // use for get win numbers, must higer than btcBlockNoWhenLock;
89         string btcBlockHash;     // use for get win numbers
90 
91         uint bonusAvg;       // average bouns price for players
92         uint jackpot;        // the jackpot to pay
93         uint genGoldKeys;    // how many gold key gens
94     }
95 }
96 
97 contract Lottery is Owned, SafeMath, LottoEvents {
98     string constant version = "1.0.1";
99 
100     uint constant private GOLD_KEY_CAP = 1500 ether;
101     uint constant private BUY_LIMIT_CAP = 100;
102     uint8 constant private ROUND_STATE_LIVE = 0;
103     uint8 constant private ROUND_STATE_LOCKED = 1;
104     uint8 constant private ROUND_STATE_DRAWED = 2;
105     uint8 constant private ROUND_STATE_ENDED = 7;
106 
107     mapping (uint => LottoModels.Round) public rounds;       // all rounds, rid -> round
108     mapping (uint => LottoModels.Ticket[]) public tickets;   // all tickets, rid -> ticket array
109     mapping (address => uint) public goldKeyRepo;            // all gold key repo, keeper address -> key count
110     address[] private goldKeyKeepers;                           // all gold key keepers, just for clear mapping?!
111 
112     uint public goldKeyCounter = 0;               // count for gold keys
113     uint public unIssuedGoldKeys = 0;             // un issued gold keys
114     uint public price = 0.03 ether;               // the price for each bet
115     bool public activated = false;                // contract live?
116     uint public rId;                              // current round id
117 
118     constructor() public {
119         rId = 0;
120         activated = true;
121         internalNewRound(0, 0); // init with prize 0, bonus 0
122     }
123 
124     // buy ticket
125     // WARNING!!!solidity only allow 16 local variables
126     function()
127         isHuman()
128         isActivated()
129         public
130         payable {
131 
132         require(owner != msg.sender, "owner cannot buy.");
133         require(address(this) != msg.sender, "contract cannot buy.");
134         require(rounds[rId].state == ROUND_STATE_LIVE,  "this round not start yet, please wait.");
135         // data format check
136         require(msg.data.length > 9,  "data struct not valid");
137         require(msg.data.length % 9 == 1, "data struct not valid");
138         // price check
139         require(uint(msg.data[0]) < BUY_LIMIT_CAP, "out of buy limit one time.");
140         require(msg.value == uint(msg.data[0]) * price, "price not right, please check.");
141 
142 
143         uint i = 1;
144         while(i < msg.data.length) {
145             // fill data
146             // [0]: how many
147             // [1]: how many gold key use?
148             // [2]: join bonus?
149             // [3-7]: red balls, [8]: blue ball
150             uint _times = uint(msg.data[i++]);
151             uint _goldKeys = uint(msg.data[i++]);
152             bool _joinBonus = uint(msg.data[i++]) > 0;
153             uint[] memory _numbers = new uint[](6);
154             for(uint j = 0; j < 6; j++) {
155                 _numbers[j] = uint(msg.data[i++]);
156             }
157 
158             // every ticket
159             for (uint k = 0; k < _times; k++) {
160                 bool _useGoldKey = false;
161                 if (_goldKeys > 0 && goldKeyRepo[msg.sender] > 0) { // can use gold key?
162                     _goldKeys--; // reduce you keys you want
163                     goldKeyRepo[msg.sender]--; // reduce you keys in repo
164                     _useGoldKey = true;
165                 }
166                 tickets[rId].push(LottoModels.Ticket(rId, msg.sender,  now, _numbers, _joinBonus, _useGoldKey));
167             }
168         }
169 
170         // update round data
171         rounds[rId].ethIn = addition(rounds[rId].ethIn, msg.value);
172         uint _amount = msg.value * 4 / 10;
173         rounds[rId].prizePool = addition(rounds[rId].prizePool, _amount); // 40% for prize
174         rounds[rId].bonusPool = addition(rounds[rId].bonusPool, _amount); // 40% for bonus
175         rounds[rId].teamFee = addition(rounds[rId].teamFee, division(_amount, 2));   // 20% for team
176         // check gen gold key?
177         internalIncreaseGoldKeyCounter(_amount);
178 
179         emit BuyTicket(rId, msg.sender, msg.data, rounds[rId].prizePool, rounds[rId].bonusPool);
180     }
181 
182 
183     // core logic
184     //
185     // 1. lock the round, can't buy this round
186     // 2. on-chain calc win numbuers
187     // 3. off-chain calc jackpot, jackpot winners, goldkey winners, average bonus, blue number hits not share bonus.
188     // if compute on-chain, out of gas
189     // 4. end this round
190 
191     // 1. lock the round, can't buy this round
192     function lockRound(uint btcBlockNo)
193     isActivated()
194     onlyOwner()
195     public {
196         require(rounds[rId].state == ROUND_STATE_LIVE, "this round not live yet, no need lock");
197         rounds[rId].btcBlockNoWhenLock = btcBlockNo;
198         rounds[rId].state = ROUND_STATE_LOCKED;
199         emit LockRound(rId, ROUND_STATE_LOCKED, btcBlockNo);
200     }
201 
202     // 2. on-chain calc win numbuers
203     function drawRound(
204         uint  btcBlockNo,
205         string  btcBlockHash
206     )
207     isActivated()
208     onlyOwner()
209     public {
210         require(rounds[rId].state == ROUND_STATE_LOCKED, "this round not locked yet, please lock it first");
211         require(rounds[rId].btcBlockNoWhenLock < btcBlockNo,  "the btc block no should higher than the btc block no when lock this round");
212 
213         // calculate winner
214         rounds[rId].winNumbers = calcWinNumbers(btcBlockHash);
215         rounds[rId].btcBlockHash = btcBlockHash;
216         rounds[rId].btcBlockNo = btcBlockNo;
217         rounds[rId].state = ROUND_STATE_DRAWED;
218 
219         emit DrawRound(rId, ROUND_STATE_DRAWED, btcBlockNo, btcBlockHash, rounds[rId].winNumbers);
220     }
221 
222     // 3. off-chain calc
223     // 4. end this round
224     function endRound(
225         uint jackpot,
226         uint bonusAvg,
227         address[] jackpotWinners,
228         address[] goldKeyWinners,
229         bool autoStartNext
230     )
231     isActivated()
232     onlyOwner()
233     public {
234         require(rounds[rId].state == ROUND_STATE_DRAWED, "this round not drawed yet, please draw it first");
235 
236         // end this round
237         rounds[rId].state = ROUND_STATE_ENDED;
238         rounds[rId].etime = now;
239         rounds[rId].jackpot = jackpot;
240         rounds[rId].bonusAvg = bonusAvg;
241         rounds[rId].winners = jackpotWinners;
242 
243         // if jackpot is this contract addr or owner addr, delete it
244 
245         // if have winners, all keys will gone.
246         if (jackpotWinners.length > 0 && jackpot > 0) {
247             unIssuedGoldKeys = 0; // clear un issued gold keys
248             // clear players gold key
249             // no direct delete mapping in solidity
250             // we give an array to store gold key keepers
251             // clearing mapping from key keepers
252             // delete keepers
253             for (uint i = 0; i < goldKeyKeepers.length; i++) {
254                 goldKeyRepo[goldKeyKeepers[i]] = 0;
255             }
256             delete goldKeyKeepers;
257         } else {
258             // else reward gold keys
259             if (unIssuedGoldKeys > 0) {
260                 for (uint k = 0; k < goldKeyWinners.length; k++) {
261                     // update repo
262                     address _winner = goldKeyWinners[k];
263 
264                     // except this address
265                     if (_winner == address(this)) {
266                         continue;
267                     }
268 
269                     goldKeyRepo[_winner]++;
270 
271                     // update keepers
272                     bool _hasKeeper = false;
273                     for (uint j = 0; j < goldKeyKeepers.length; j++) {
274                         if (goldKeyKeepers[j] == _winner) {
275                             _hasKeeper = true;
276                             break;
277                         }
278                     }
279                     if (!_hasKeeper) { // no keeper? push it in.
280                         goldKeyKeepers.push(_winner);
281                     }
282 
283                     unIssuedGoldKeys--;
284                     if (unIssuedGoldKeys <= 0) { // no more gold keys, let's break;
285                         break;
286                     }
287 
288                 }
289             }
290             // move this round gen gold key to un issued gold keys
291             unIssuedGoldKeys = addition(unIssuedGoldKeys, rounds[rId].genGoldKeys);
292         }
293 
294         emit EndRound(rId, ROUND_STATE_ENDED, jackpot, bonusAvg, jackpotWinners, goldKeyWinners, autoStartNext);
295         // round ended
296 
297         // start next?
298         if (autoStartNext) {
299             newRound();
300         }
301     }
302 
303     function newRound()
304     isActivated()
305     onlyOwner()
306     public {
307         // check this round is ended?
308         require(rounds[rId].state == ROUND_STATE_ENDED, "this round not ended yet, please end it first");
309 
310         // lets start next round
311         // calculate prize to move, (prize pool - jackpot to pay)
312         uint _initPrizeIn = subtraction(rounds[rId].prizePool, rounds[rId].jackpot);
313         // move bonus pool, if no one share bonus(maybe)
314         uint _initBonusIn = rounds[rId].bonusPool;
315         if (rounds[rId].bonusAvg > 0) { // if someone share bonus, bonusAvg > 0, move 0
316             _initBonusIn = 0;
317         }
318         // move to new round
319         internalNewRound(_initPrizeIn, _initBonusIn);
320 
321         emit NewRound(rId, ROUND_STATE_LIVE, _initPrizeIn);
322     }
323 
324     function internalNewRound(uint _initPrizeIn, uint _initBonusIn) internal {
325         rId++;
326         rounds[rId].rId = rId;
327         rounds[rId].stime = now;
328         rounds[rId].state = ROUND_STATE_LIVE;
329         rounds[rId].prizePool = _initPrizeIn;
330         rounds[rId].bonusPool = _initBonusIn;
331     }
332     
333     function internalIncreaseGoldKeyCounter(uint _amount) internal {
334         goldKeyCounter = addition(goldKeyCounter, _amount);
335         if (goldKeyCounter >= GOLD_KEY_CAP) {
336             rounds[rId].genGoldKeys = addition(rounds[rId].genGoldKeys, 1);
337             goldKeyCounter = subtraction(goldKeyCounter, GOLD_KEY_CAP);
338         }
339     }
340 
341     // utils
342     function calcWinNumbers(string blockHash)
343     public
344     pure
345     returns (uint[]) {
346         bytes32 random = keccak256(bytes(blockHash));
347         uint[] memory allRedNumbers = new uint[](40);
348         uint[] memory allBlueNumbers = new uint[](10);
349         uint[] memory winNumbers = new uint[](6);
350         for (uint i = 0; i < 40; i++) {
351             allRedNumbers[i] = i + 1;
352             if(i < 10) {
353                 allBlueNumbers[i] = i;
354             }
355         }
356         for (i = 0; i < 5; i++) {
357             uint n = 40 - i;
358             uint r = (uint(random[i * 4]) + (uint(random[i * 4 + 1]) << 8) + (uint(random[i * 4 + 2]) << 16) + (uint(random[i * 4 + 3]) << 24)) % (n + 1);
359             winNumbers[i] = allRedNumbers[r];
360             allRedNumbers[r] = allRedNumbers[n - 1];
361         }
362         uint t = (uint(random[i * 4]) + (uint(random[i * 4 + 1]) << 8) + (uint(random[i * 4 + 2]) << 16) + (uint(random[i * 4 + 3]) << 24)) % 10;
363         winNumbers[5] = allBlueNumbers[t];
364         return winNumbers;
365     }
366 
367     // for views
368     function getKeys() public view returns(uint) {
369         return goldKeyRepo[msg.sender];
370     }
371     
372     function getRoundByRId(uint _rId)
373     public
374     view
375     returns (uint[] res){
376         if(_rId > rId) return res;
377         res = new uint[](18);
378         uint k;
379         res[k++] = _rId;
380         res[k++] = uint(rounds[_rId].state);
381         res[k++] = rounds[_rId].ethIn;
382         res[k++] = rounds[_rId].prizePool;
383         res[k++] = rounds[_rId].bonusPool;
384         res[k++] = rounds[_rId].teamFee;
385         if (rounds[_rId].winNumbers.length == 0) {
386             for (uint j = 0; j < 6; j++)
387                 res[k++] = 0;
388         } else {
389             for (j = 0; j < 6; j++)
390                 res[k++] = rounds[_rId].winNumbers[j];
391         }
392         res[k++] = rounds[_rId].bonusAvg;
393         res[k++] = rounds[_rId].jackpot;
394         res[k++] = rounds[_rId].genGoldKeys;
395         res[k++] = rounds[_rId].btcBlockNo;
396         res[k++] = rounds[_rId].stime;
397         res[k++] = rounds[_rId].etime;
398     }
399 
400     // --- danger ops ---
401 
402     // angel send luck for players
403     function dumpPrize()
404     isActivated()
405     onlyOwner()
406     public
407     payable {
408         require(rounds[rId].state == ROUND_STATE_LIVE, "this round not live yet.");
409         rounds[rId].ethIn = addition(rounds[rId].ethIn, msg.value);
410         rounds[rId].prizePool = addition(rounds[rId].prizePool, msg.value);
411         // check gen gold key?
412         internalIncreaseGoldKeyCounter(msg.value);
413         emit DumpPrize(rId, msg.value);
414     }
415 
416     function activate() public onlyOwner {
417         activated = true;
418         emit Activated(rId);
419     }
420 
421     function deactivate() public onlyOwner {
422         activated = false;
423         emit Deactivated(rId);
424     }
425 
426     function selfDestroy() public onlyOwner {
427         selfdestruct(msg.sender);
428         emit SelfDestroy(rId);
429     }
430 
431     function transferToOwner(uint amount) public payable onlyOwner {
432         msg.sender.transfer(amount);
433         emit Transfer(rId, amount);
434     }
435     // --- danger ops end ---
436 
437     // modifiers
438     modifier isActivated() {
439         require(activated == true, "its not ready yet.");
440         _;
441     }
442 
443     modifier isHuman() {
444         address _addr = msg.sender;
445         require (_addr == tx.origin);
446 
447         uint256 _codeLength;
448 
449         assembly {_codeLength := extcodesize(_addr)}
450         require(_codeLength == 0, "sorry humans only");
451         _;
452     }
453 }