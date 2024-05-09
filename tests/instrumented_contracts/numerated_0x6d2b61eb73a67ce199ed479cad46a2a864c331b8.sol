1 pragma solidity ^0.4.25;
2 
3 
4 /** 
5 Sweet Bet / Vainilla Donuts
6 */
7 
8 
9 library Random {
10     struct Data {
11         uint blockNumber;
12         bytes32 hash;
13     }
14 
15     function random(Data memory d, uint max) internal view returns (uint) {
16         if(d.hash == 0){
17             //Use simplified entropy
18             d.hash = keccak256(abi.encodePacked(now, block.difficulty, block.number, blockhash(block.number - 1)));
19         }else{
20             //Use entropy based on blockhash at which transaction has been confirmed
21             d.hash = keccak256(abi.encodePacked(d.hash));
22         }
23 
24         return uint(d.hash)%max;
25     }
26 
27     function init(Data memory d, uint blockNumber) internal view {
28         if(blockNumber != d.blockNumber){
29             //We have Random for different block. So we must reinit it
30             //If, in the unlikely case, the block is too far away, then the blockhash
31             //will return 0 and we will use simplified entropy.
32             //It is highly unlikely because nor players, nor administration are interested in it
33             d.hash = blockhash(blockNumber);
34             d.blockNumber = blockNumber;
35         }
36     }
37 }
38 
39 
40 library Cylinder {
41     using Random for Random.Data;
42 
43     uint constant CYLINDER_CAPACITY = 3;
44     uint constant MULTIPLIER_PERCENT = 144;
45     uint constant WITHDRAW_PERCENT = 99;
46     uint constant JACKPOT_PERCENT = 1;
47     uint constant SERVICE_PERCENT = 1;
48     uint constant PROMO_PERCENT = 2;
49 
50     //Jackpot chances - once in a number of games
51     uint constant HALF_JACKPOT_CHANCE = 50;
52     uint constant FULL_JACKPOT_CHANCE = 500;
53 
54     address constant SERVICE = 0x7B2395bC947f552b424cB9646fC261810D3CEB44;
55     address constant PROMO = 0x6eE0Bf1Fc770e7aa9D39F99C39FA977c6103D41e;
56 
57     //The deposit structure holds all the info about the deposit made
58     struct Deposit {
59         address depositor; //The depositor address
60         uint64 timeAt; //When the deposit was made
61     }
62 
63     //The result of the game. Always stored at height%CYLINDER_CAPACITY index
64     struct GameResult{
65         uint48 timeAt;  //Time of finalization
66         uint48 blockAt;  //Block number of finalization
67         uint48 height;  //Height of the cylinder slots
68         uint8 unlucky;  //index of the unlucky one in slots relative to height
69         uint96 jackpot; //The jackpot won (if not 0)
70         bool full;      //Full jackpot won
71     }
72 
73     struct Data{
74         uint dep;
75         Deposit[] slots;
76         GameResult[] results;
77         uint currentCylinderHeight;
78         uint jackpot;
79     }
80 
81     function checkPercentConsistency() pure internal {
82         //All the percent should be consistent with each other
83         assert(100 * CYLINDER_CAPACITY == MULTIPLIER_PERCENT * (CYLINDER_CAPACITY-1) + (JACKPOT_PERCENT + SERVICE_PERCENT + PROMO_PERCENT)*CYLINDER_CAPACITY);
84         assert(WITHDRAW_PERCENT <= 100);
85     }
86 
87     function addDep(Cylinder.Data storage c, address depositor) internal returns (bool){
88         c.slots.push(Deposit(depositor, uint64(now)));
89         if(c.slots.length % CYLINDER_CAPACITY == 0) {
90             //Indicate that we need to put the game to the list of ready to finish games
91             c.currentCylinderHeight += CYLINDER_CAPACITY;
92             return true; //The game should be finished
93         }else{
94             return false; //The game continues
95         }
96     }
97 
98     function finish(Cylinder.Data storage c, uint height, Random.Data memory r) internal {
99         GameResult memory gr = computeGameResult(c, height, r);
100 
101         uint dep = c.dep;
102         uint unlucky = gr.unlucky; //The loser index
103         uint reward = dep*MULTIPLIER_PERCENT/100;
104         uint length = height + CYLINDER_CAPACITY;
105 
106         uint total = dep*CYLINDER_CAPACITY;
107         uint jackAmount = c.jackpot;
108         uint jackWon = gr.jackpot;
109 
110         for(uint i=height; i<length; ++i){
111             if(i-height != unlucky){ //Winners
112                 Deposit storage d = c.slots[i];
113                 if(!d.depositor.send(reward)) //If we can not send the money (it may be malicious contract)
114                     jackAmount += reward;     //add it to jackpot
115             }
116         }
117 
118         if(jackWon > 0){
119             //Jackpot won!!! Send it to (un)lucky one
120             Deposit storage win = c.slots[height + unlucky];
121             if(win.depositor.send(jackWon))
122                 jackAmount -= jackWon; //jackWon is always <= jackAmount
123         }
124 
125         c.jackpot = jackAmount + total*JACKPOT_PERCENT/100;
126 
127         c.results.push(gr);
128 
129         SERVICE.transfer(total*(SERVICE_PERCENT)/100);
130         PROMO.transfer(total*PROMO_PERCENT/100);
131     }
132 
133     function computeGameResult(Cylinder.Data storage c, uint height, Random.Data memory r) internal view returns (GameResult memory) {
134         assert(height + CYLINDER_CAPACITY <= c.currentCylinderHeight);
135 
136         uint unlucky = r.random(CYLINDER_CAPACITY); //The loser index
137         uint jackAmount = c.jackpot;
138         uint jackWon = 0;
139         bool fullJack = false;
140 
141         uint jpchance = r.random(FULL_JACKPOT_CHANCE);
142         if(jpchance % HALF_JACKPOT_CHANCE == 0){
143             //Jackpot won!!!
144             if(jpchance == 0){
145                 //Once in FULL_JACKPOT_CHANCE the unlucky one gets full jackpot
146                 fullJack = true;
147                 jackWon = jackAmount;
148             }else{
149                 //Once in HALF_JACKPOT_CHANCE the unlucky one gets half of jackpot
150                 jackWon = jackAmount/2;
151             }
152             //jackWon is always not more than c.jackpot
153         }
154 
155         return GameResult(uint48(now), uint48(block.number), uint48(height), uint8(unlucky), uint96(jackWon), fullJack);
156     }
157 
158     function withdraw(Cylinder.Data storage c, address addr) internal returns (bool){
159         uint length = c.slots.length;
160         uint dep = c.dep;
161         for(uint i=c.currentCylinderHeight; i<length; ++i){
162             Deposit storage deposit = c.slots[i];
163             if(deposit.depositor == addr){ //Return dep
164                 uint ret = dep*WITHDRAW_PERCENT/100;
165                 deposit.depositor.transfer(msg.value + ret);
166                 SERVICE.transfer(dep - ret);
167 
168                 --length; //We need only length-1 further on
169                 if(i < length){
170                     c.slots[i] = c.slots[length];
171                 }
172 
173                 c.slots.length = length;
174                 return true;
175             }
176         }
177     }
178 
179     function getCylinder(Cylinder.Data storage c, uint idx) internal view returns (uint96 dep, uint64 index, address[] deps, uint8 unlucky, int96 jackpot, uint64 lastDepTime){
180         dep = uint96(c.dep);
181         index = uint64(idx);
182         require(idx <= c.slots.length/CYLINDER_CAPACITY, "Wrong cylinder index");
183 
184         if(uint(index) >= c.results.length){
185             uint size = c.slots.length - index*CYLINDER_CAPACITY;
186             if(size > CYLINDER_CAPACITY)
187                 size = CYLINDER_CAPACITY;
188 
189             deps = new address[](size);
190         }else{
191             deps = new address[](CYLINDER_CAPACITY);
192 
193             Cylinder.GameResult storage gr = c.results[index];
194             unlucky = gr.unlucky;
195             jackpot = gr.full ? -int96(gr.jackpot) : int96(gr.jackpot);
196             lastDepTime = gr.timeAt;
197         }
198 
199         for(uint i=0; i<deps.length; ++i){
200             Deposit storage d = c.slots[index*CYLINDER_CAPACITY + i];
201             deps[i] = d.depositor;
202             if(lastDepTime < uint(d.timeAt))
203                 lastDepTime = d.timeAt;
204         }
205     }
206 
207     function getCapacity() internal pure returns (uint) {
208         return CYLINDER_CAPACITY;
209     }
210 }
211 
212 
213 contract Donut {
214     using Cylinder for Cylinder.Data;
215     using Random for Random.Data;
216 
217     uint[14] public BETS = [
218         0.01 ether,
219         0.02 ether,
220         0.04  ether,
221         0.05  ether,
222         0.07  ether,
223         0.08  ether,
224         0.1  ether,
225         0.15    ether,
226         0.2  ether,
227         0.3   ether,
228         0.4    ether,
229         0.5    ether,
230         0.8    ether,
231         1   ether
232     ];
233 
234     struct GameToFinish{
235         uint8 game;
236         uint64 blockNumber;
237         uint64 height;
238     }
239 
240     Cylinder.Data[] private games;
241     GameToFinish[] private gtf; //Games that are waiting to be finished
242     uint private gtfStart = 0; //Starting index of games to finish queue
243 
244     constructor() public {
245         Cylinder.checkPercentConsistency();
246         //Initialize games for different bets
247         games.length = BETS.length;
248     }
249 
250     function() public payable {
251         //first choose the game on the basis of the bets table
252         for(int i=int(BETS.length)-1; i>=0; i--){
253             uint bet = BETS[uint(i)];
254             if(msg.value >= bet){
255                 //Finish the games if there are any waiting
256                 finishGames();
257 
258                 if(msg.value > bet) //return change
259                     msg.sender.transfer(msg.value - bet);
260 
261                 Cylinder.Data storage game = games[uint(i)];
262                 if(game.dep == 0){ //Initialize game data on first deposit
263                     game.dep = bet;
264                 }
265 
266                 uint height = game.currentCylinderHeight;
267                 if(game.addDep(msg.sender)){
268                     //The game is ready to be finished
269                     //Put it to finish queue
270                     gtf.push(GameToFinish(uint8(i), uint64(block.number), uint64(height)));
271                 }
272                 return;
273             }
274         }
275 
276         if(msg.value == 0.00000112 ether){
277             withdraw();
278             return;
279         }
280 
281         if(msg.value == 0){
282             finishGames();
283             return;
284         }
285 
286         revert("Deposit is too small");
287     }
288 
289     function withdrawFrom(uint game) public {
290         require(game < BETS.length);
291         require(games[game].withdraw(msg.sender), "You are not betting in this game");
292 
293         //Finish the games if there are any waiting
294         finishGames();
295     }
296 
297     function withdraw() public {
298         uint length = BETS.length;
299         for(uint i=0; i<length; ++i){
300             if(games[i].withdraw(msg.sender)){
301                 //Finish the games if there are any waiting
302                 finishGames();
303                 return;
304             }
305         }
306 
307         revert("You are not betting in any game");
308     }
309 
310     function finishGames() private {
311         Random.Data memory r;
312         uint length = gtf.length;
313         for(uint i=gtfStart; i<length; ++i){
314             GameToFinish memory g = gtf[i];
315             uint bn = g.blockNumber;
316             if(bn == block.number)
317                 break; //We can not finish the game in the same block
318 
319             r.init(bn);
320 
321             Cylinder.Data storage c = games[g.game];
322             c.finish(g.height, r);
323 
324             delete gtf[i];
325         }
326 
327         if(i > gtfStart)
328             gtfStart = i;
329     }
330 
331     function getGameState(uint game) public view returns (uint64 blockNumber, bytes32 blockHash, uint96 dep, uint64 slotsCount, uint64 resultsCount, uint64 currentCylinderIndex, uint96 jackpot){
332         Cylinder.Data storage c = games[game];
333         dep = uint96(c.dep);
334         slotsCount = uint64(c.slots.length);
335         resultsCount = uint64(c.results.length);
336         currentCylinderIndex = uint64(c.currentCylinderHeight/Cylinder.getCapacity());
337         jackpot = uint96(c.jackpot);
338         blockNumber = uint64(block.number-1);
339         blockHash = blockhash(block.number-1);
340     }
341 
342     function getGameStates() public view returns (uint64 blockNumber, bytes32 blockHash, uint96[] dep, uint64[] slotsCount, uint64[] resultsCount, uint64[] currentCylinderIndex, uint96[] jackpot){
343         dep = new uint96[](BETS.length);
344         slotsCount = new uint64[](BETS.length);
345         resultsCount = new uint64[](BETS.length);
346         currentCylinderIndex = new uint64[](BETS.length);
347         jackpot = new uint96[](BETS.length);
348 
349         for(uint i=0; i<BETS.length; ++i){
350             (blockNumber, blockHash, dep[i], slotsCount[i], resultsCount[i], currentCylinderIndex[i], jackpot[i]) = getGameState(i);
351         }
352     }
353 
354     function getCylinder(uint game, int _idx) public view returns (uint64 blockNumber, bytes32 blockHash, uint96 dep, uint64 index, address[] deps, uint8 unlucky, int96 jackpot, uint64 lastDepTime, uint8 status){
355         Cylinder.Data storage c = games[game];
356         index = uint64(_idx < 0 ? c.slots.length/Cylinder.getCapacity() : uint(_idx));
357 
358         (dep, index, deps, unlucky, jackpot, lastDepTime) = c.getCylinder(index);
359         blockNumber = uint64(block.number-1);
360         blockHash = blockhash(block.number-1);
361         //status = 0; //The game is running
362 
363         uint8 _unlucky;
364         int96 _jackpot;
365 
366         //We will try to get preliminary results of the ready to be finished game
367         (_unlucky, _jackpot, status) = _getGameResults(game, index);
368         if(status == 2){
369             unlucky = _unlucky;
370             jackpot = _jackpot;
371         }
372     }
373 
374     function _getGameResults(uint game, uint index) private view returns (uint8 unlucky, int96 jackpot, uint8 status){
375         Cylinder.Data storage c = games[game];
376         if(index < c.results.length){
377             status = 3; //Finished and has finalized results
378         }else if(c.slots.length >= (index+1)*Cylinder.getCapacity()){
379             status = 1; //Closed, but no results yet
380             //This game needs finishing, so try to find out who wins
381             Random.Data memory r;
382             uint length = gtf.length;
383             for(uint i=gtfStart; i<length; ++i){
384                 GameToFinish memory g = gtf[i];
385                 uint bn = g.blockNumber;
386                 if(blockhash(bn) == 0)
387                     break; //We either on the same block or too far from this block
388 
389                 r.init(bn);
390 
391                 Cylinder.GameResult memory gr = games[g.game].computeGameResult(g.height, r);
392 
393                 if(uint(g.height) == index*Cylinder.getCapacity() && uint(g.game) == game){
394                     //We have found our game so just fill the results
395                     unlucky = gr.unlucky;
396                     jackpot = gr.full ? -int96(gr.jackpot) : int96(gr.jackpot); //The jackpot amount may be inaccurate
397                     status = 2; //Closed and has preliminary results
398                     break;
399                 }
400             }
401         }
402     }
403 
404     function getCylinders(uint game, uint idxFrom, uint idxTo) public view returns (uint blockNumber, bytes32 blockHash, uint96 dep, uint64[] index, address[] deps, uint8[] unlucky, int96[] jackpot, uint64[] lastDepTime, uint8[] status){
405         Cylinder.Data storage c = games[game];
406         uint lastCylinderIndex = c.slots.length/Cylinder.getCapacity();
407         blockNumber = block.number-1;
408         blockHash = blockhash(block.number-1);
409         dep = uint96(c.dep);
410 
411         require(idxFrom <= lastCylinderIndex && idxFrom <= idxTo, "Wrong cylinder index range");
412 
413         if(idxTo > lastCylinderIndex)
414             idxTo = lastCylinderIndex;
415 
416         uint count = idxTo - idxFrom + 1;
417 
418         index = new uint64[](count);
419         deps = new address[](count*Cylinder.getCapacity());
420         unlucky = new uint8[](count);
421         jackpot = new int96[](count);
422         lastDepTime = new uint64[](count);
423         status = new uint8[](count);
424 
425         _putCylindersToArrays(game, idxFrom, count, index, deps, unlucky, jackpot, lastDepTime, status);
426     }
427 
428     function _putCylindersToArrays(uint game, uint idxFrom, uint count, uint64[] index, address[] deps, uint8[] unlucky, int96[] jackpot, uint64[] lastDepTime, uint8[] status) private view {
429         for(uint i=0; i<count; ++i){
430             address[] memory _deps;
431             (, , , index[i], _deps, unlucky[i], jackpot[i], lastDepTime[i], status[i]) = getCylinder(game, int(idxFrom + i));
432             _copyDeps(i*Cylinder.getCapacity(), deps, _deps);
433         }
434     }
435 
436     function _copyDeps(uint start, address[] deps, address[] memory _deps) private pure {
437         for(uint j=0; j<_deps.length; ++j){
438             deps[start + j] = _deps[j];
439         }
440     }
441 
442     function getUnfinishedCount() public view returns (uint) {
443         return gtf.length - gtfStart;
444     }
445 
446     function getUnfinished(uint i) public view returns (uint game, uint blockNumber, uint cylinder) {
447         game = gtf[gtfStart + i].game;
448         blockNumber = gtf[gtfStart + i].blockNumber;
449         cylinder = gtf[gtfStart + i].height/Cylinder.getCapacity();
450     }
451 
452     function getTotalCylindersCount() public view returns (uint) {
453         return gtf.length;
454     }
455 
456     function testRandom() public view returns (uint[] numbers) {
457         numbers = new uint[](32);
458         Random.Data memory r;
459         for(uint i=0; i<256; i+=8){
460             numbers[i/8] = Random.random(r, 10);
461         }
462     }
463 }