1 pragma solidity ^0.4.25;
2 
3 
4 /** 
5 Russian Roulette: the fair game for ether on smart contract.
6 
7 You and 4 other people place their bets. Placing
8 the bet you load a cartridge into the revolver cylinder -
9 currently unknown whether it is blank or live.
10 
11 The cylinder revolves, the revolver shoots players one
12 by one and the unlucky one who gets live cartridge gets killed,
13 others win 120% of their bets.
14 
15 Still the unlucky one has a chance for a jackpot.
16 
17 The game uses fair random number generator based on 
18 future block, so nobody, nor players nor developers can guess its results.
19 
20 Join the game and win: https://multi.today
21 */
22 
23 
24 library Random {
25     struct Data {
26         uint blockNumber;
27         bytes32 hash;
28     }
29 
30     function random(Data memory d, uint max) internal view returns (uint) {
31         if(d.hash == 0){
32             //Use simplified entropy
33             d.hash = keccak256(abi.encodePacked(now, block.difficulty, block.number, blockhash(block.number - 1)));
34         }else{
35             //Use entropy based on blockhash at which transaction has been confirmed
36             d.hash = keccak256(abi.encodePacked(d.hash));
37         }
38 
39         return uint(d.hash)%max;
40     }
41 
42     function init(Data memory d, uint blockNumber) internal view {
43         if(blockNumber != d.blockNumber){
44             //We have Random for different block. So we must reinit it
45             //If, in the unlikely case, the block is too far away, then the blockhash
46             //will return 0 and we will use simplified entropy.
47             //It is highly unlikely because nor players, nor administration are interested in it
48             d.hash = blockhash(blockNumber);
49             d.blockNumber = blockNumber;
50         }
51     }
52 }
53 
54 
55 library Cylinder {
56     using Random for Random.Data;
57 
58     uint constant CYLINDER_CAPACITY = 5;
59     uint constant MULTIPLIER_PERCENT = 120;
60     uint constant WITHDRAW_PERCENT = 99;
61     uint constant JACKPOT_PERCENT = 2;
62     uint constant SERVICE_PERCENT = 1;
63     uint constant PROMO_PERCENT = 1;
64 
65     //Jackpot chances - once in a number of games
66     uint constant HALF_JACKPOT_CHANCE = 100;
67     uint constant FULL_JACKPOT_CHANCE = 1000;
68 
69     address constant SERVICE = 0xDb058D036768Cfa9a94963f99161e3c94aD6f5dA;
70     address constant PROMO = 0xdA149b17C154e964456553C749B7B4998c152c9E;
71 
72     //The deposit structure holds all the info about the deposit made
73     struct Deposit {
74         address depositor; //The depositor address
75         uint64 timeAt; //When the deposit was made
76     }
77 
78     //The result of the game. Always stored at height%CYLINDER_CAPACITY index
79     struct GameResult{
80         uint48 timeAt;  //Time of finalization
81         uint48 blockAt;  //Block number of finalization
82         uint48 height;  //Height of the cylinder slots
83         uint8 unlucky;  //index of the unlucky one in slots relative to height
84         uint96 jackpot; //The jackpot won (if not 0)
85         bool full;      //Full jackpot won
86     }
87 
88     struct Data{
89         uint dep;
90         Deposit[] slots;
91         GameResult[] results;
92         uint currentCylinderHeight;
93         uint jackpot;
94     }
95 
96     function checkPercentConsistency() pure internal {
97         //All the percent should be consistent with each other
98         assert(100 * CYLINDER_CAPACITY == MULTIPLIER_PERCENT * (CYLINDER_CAPACITY-1) + (JACKPOT_PERCENT + SERVICE_PERCENT + PROMO_PERCENT)*CYLINDER_CAPACITY);
99         assert(WITHDRAW_PERCENT <= 100);
100     }
101 
102     function addDep(Cylinder.Data storage c, address depositor) internal returns (bool){
103         c.slots.push(Deposit(depositor, uint64(now)));
104         if(c.slots.length % CYLINDER_CAPACITY == 0) {
105             //Indicate that we need to put the game to the list of ready to finish games
106             c.currentCylinderHeight += CYLINDER_CAPACITY;
107             return true; //The game should be finished
108         }else{
109             return false; //The game continues
110         }
111     }
112 
113     function finish(Cylinder.Data storage c, uint height, Random.Data memory r) internal {
114         GameResult memory gr = computeGameResult(c, height, r);
115 
116         uint dep = c.dep;
117         uint unlucky = gr.unlucky; //The loser index
118         uint reward = dep*MULTIPLIER_PERCENT/100;
119         uint length = height + CYLINDER_CAPACITY;
120 
121         uint total = dep*CYLINDER_CAPACITY;
122         uint jackAmount = c.jackpot;
123         uint jackWon = gr.jackpot;
124 
125         for(uint i=height; i<length; ++i){
126             if(i-height != unlucky){ //Winners
127                 Deposit storage d = c.slots[i];
128                 if(!d.depositor.send(reward)) //If we can not send the money (it may be malicious contract)
129                     jackAmount += reward;     //add it to jackpot
130             }
131         }
132 
133         if(jackWon > 0){
134             //Jackpot won!!! Send it to (un)lucky one
135             Deposit storage win = c.slots[height + unlucky];
136             if(win.depositor.send(jackWon))
137                 jackAmount -= jackWon; //jackWon is always <= jackAmount
138         }
139 
140         c.jackpot = jackAmount + total*JACKPOT_PERCENT/100;
141 
142         c.results.push(gr);
143 
144         SERVICE.transfer(total*(SERVICE_PERCENT)/100);
145         PROMO.transfer(total*PROMO_PERCENT/100);
146     }
147 
148     function computeGameResult(Cylinder.Data storage c, uint height, Random.Data memory r) internal view returns (GameResult memory) {
149         assert(height + CYLINDER_CAPACITY <= c.currentCylinderHeight);
150 
151         uint unlucky = r.random(CYLINDER_CAPACITY); //The loser index
152         uint jackAmount = c.jackpot;
153         uint jackWon = 0;
154         bool fullJack = false;
155 
156         uint jpchance = r.random(FULL_JACKPOT_CHANCE);
157         if(jpchance % HALF_JACKPOT_CHANCE == 0){
158             //Jackpot won!!!
159             if(jpchance == 0){
160                 //Once in FULL_JACKPOT_CHANCE the unlucky one gets full jackpot
161                 fullJack = true;
162                 jackWon = jackAmount;
163             }else{
164                 //Once in HALF_JACKPOT_CHANCE the unlucky one gets half of jackpot
165                 jackWon = jackAmount/2;
166             }
167             //jackWon is always not more than c.jackpot
168         }
169 
170         return GameResult(uint48(now), uint48(block.number), uint48(height), uint8(unlucky), uint96(jackWon), fullJack);
171     }
172 
173     function withdraw(Cylinder.Data storage c, address addr) internal returns (bool){
174         uint length = c.slots.length;
175         uint dep = c.dep;
176         for(uint i=c.currentCylinderHeight; i<length; ++i){
177             Deposit storage deposit = c.slots[i];
178             if(deposit.depositor == addr){ //Return dep
179                 uint ret = dep*WITHDRAW_PERCENT/100;
180                 deposit.depositor.transfer(msg.value + ret);
181                 SERVICE.transfer(dep - ret);
182 
183                 --length; //We need only length-1 further on
184                 if(i < length){
185                     c.slots[i] = c.slots[length];
186                 }
187 
188                 c.slots.length = length;
189                 return true;
190             }
191         }
192     }
193 
194     function getCylinder(Cylinder.Data storage c, uint idx) internal view returns (uint96 dep, uint64 index, address[] deps, uint8 unlucky, int96 jackpot, uint64 lastDepTime){
195         dep = uint96(c.dep);
196         index = uint64(idx);
197         require(idx <= c.slots.length/CYLINDER_CAPACITY, "Wrong cylinder index");
198 
199         if(uint(index) >= c.results.length){
200             uint size = c.slots.length - index*CYLINDER_CAPACITY;
201             if(size > CYLINDER_CAPACITY)
202                 size = CYLINDER_CAPACITY;
203 
204             deps = new address[](size);
205         }else{
206             deps = new address[](CYLINDER_CAPACITY);
207 
208             Cylinder.GameResult storage gr = c.results[index];
209             unlucky = gr.unlucky;
210             jackpot = gr.full ? -int96(gr.jackpot) : int96(gr.jackpot);
211             lastDepTime = gr.timeAt;
212         }
213 
214         for(uint i=0; i<deps.length; ++i){
215             Deposit storage d = c.slots[index*CYLINDER_CAPACITY + i];
216             deps[i] = d.depositor;
217             if(lastDepTime < uint(d.timeAt))
218                 lastDepTime = d.timeAt;
219         }
220     }
221 
222     function getCapacity() internal pure returns (uint) {
223         return CYLINDER_CAPACITY;
224     }
225 }
226 
227 
228 contract RussianRoulette {
229     using Cylinder for Cylinder.Data;
230     using Random for Random.Data;
231 
232     uint[14] public BETS = [
233         0.01 ether,
234         0.05 ether,
235         0.1  ether,
236         0.2  ether,
237         0.3  ether,
238         0.5  ether,
239         0.7  ether,
240         1    ether,
241         1.5  ether,
242         2    ether,
243         3    ether,
244         5    ether,
245         7    ether,
246         10   ether
247     ];
248 
249     struct GameToFinish{
250         uint8 game;
251         uint64 blockNumber;
252         uint64 height;
253     }
254 
255     Cylinder.Data[] private games;
256     GameToFinish[] private gtf; //Games that are waiting to be finished
257     uint private gtfStart = 0; //Starting index of games to finish queue
258 
259     constructor() public {
260         Cylinder.checkPercentConsistency();
261         //Initialize games for different bets
262         games.length = BETS.length;
263     }
264 
265     function() public payable {
266         //first choose the game on the basis of the bets table
267         for(int i=int(BETS.length)-1; i>=0; i--){
268             uint bet = BETS[uint(i)];
269             if(msg.value >= bet){
270                 //Finish the games if there are any waiting
271                 finishGames();
272 
273                 if(msg.value > bet) //return change
274                     msg.sender.transfer(msg.value - bet);
275 
276                 Cylinder.Data storage game = games[uint(i)];
277                 if(game.dep == 0){ //Initialize game data on first deposit
278                     game.dep = bet;
279                 }
280 
281                 uint height = game.currentCylinderHeight;
282                 if(game.addDep(msg.sender)){
283                     //The game is ready to be finished
284                     //Put it to finish queue
285                     gtf.push(GameToFinish(uint8(i), uint64(block.number), uint64(height)));
286                 }
287                 return;
288             }
289         }
290 
291         if(msg.value == 0.00000112 ether){
292             withdraw();
293             return;
294         }
295 
296         if(msg.value == 0){
297             finishGames();
298             return;
299         }
300 
301         revert("Deposit is too small");
302     }
303 
304     function withdrawFrom(uint game) public {
305         require(game < BETS.length);
306         require(games[game].withdraw(msg.sender), "You are not betting in this game");
307 
308         //Finish the games if there are any waiting
309         finishGames();
310     }
311 
312     function withdraw() public {
313         uint length = BETS.length;
314         for(uint i=0; i<length; ++i){
315             if(games[i].withdraw(msg.sender)){
316                 //Finish the games if there are any waiting
317                 finishGames();
318                 return;
319             }
320         }
321 
322         revert("You are not betting in any game");
323     }
324 
325     function finishGames() private {
326         Random.Data memory r;
327         uint length = gtf.length;
328         for(uint i=gtfStart; i<length; ++i){
329             GameToFinish memory g = gtf[i];
330             uint bn = g.blockNumber;
331             if(bn == block.number)
332                 break; //We can not finish the game in the same block
333 
334             r.init(bn);
335 
336             Cylinder.Data storage c = games[g.game];
337             c.finish(g.height, r);
338 
339             delete gtf[i];
340         }
341 
342         if(i > gtfStart)
343             gtfStart = i;
344     }
345 
346     function getGameState(uint game) public view returns (uint64 blockNumber, bytes32 blockHash, uint96 dep, uint64 slotsCount, uint64 resultsCount, uint64 currentCylinderIndex, uint96 jackpot){
347         Cylinder.Data storage c = games[game];
348         dep = uint96(c.dep);
349         slotsCount = uint64(c.slots.length);
350         resultsCount = uint64(c.results.length);
351         currentCylinderIndex = uint64(c.currentCylinderHeight/Cylinder.getCapacity());
352         jackpot = uint96(c.jackpot);
353         blockNumber = uint64(block.number-1);
354         blockHash = blockhash(block.number-1);
355     }
356 
357     function getGameStates() public view returns (uint64 blockNumber, bytes32 blockHash, uint96[] dep, uint64[] slotsCount, uint64[] resultsCount, uint64[] currentCylinderIndex, uint96[] jackpot){
358         dep = new uint96[](BETS.length);
359         slotsCount = new uint64[](BETS.length);
360         resultsCount = new uint64[](BETS.length);
361         currentCylinderIndex = new uint64[](BETS.length);
362         jackpot = new uint96[](BETS.length);
363 
364         for(uint i=0; i<BETS.length; ++i){
365             (blockNumber, blockHash, dep[i], slotsCount[i], resultsCount[i], currentCylinderIndex[i], jackpot[i]) = getGameState(i);
366         }
367     }
368 
369     function getCylinder(uint game, int _idx) public view returns (uint64 blockNumber, bytes32 blockHash, uint96 dep, uint64 index, address[] deps, uint8 unlucky, int96 jackpot, uint64 lastDepTime, uint8 status){
370         Cylinder.Data storage c = games[game];
371         index = uint64(_idx < 0 ? c.slots.length/Cylinder.getCapacity() : uint(_idx));
372 
373         (dep, index, deps, unlucky, jackpot, lastDepTime) = c.getCylinder(index);
374         blockNumber = uint64(block.number-1);
375         blockHash = blockhash(block.number-1);
376         //status = 0; //The game is running
377 
378         uint8 _unlucky;
379         int96 _jackpot;
380 
381         //We will try to get preliminary results of the ready to be finished game
382         (_unlucky, _jackpot, status) = _getGameResults(game, index);
383         if(status == 2){
384             unlucky = _unlucky;
385             jackpot = _jackpot;
386         }
387     }
388 
389     function _getGameResults(uint game, uint index) private view returns (uint8 unlucky, int96 jackpot, uint8 status){
390         Cylinder.Data storage c = games[game];
391         if(index < c.results.length){
392             status = 3; //Finished and has finalized results
393         }else if(c.slots.length >= (index+1)*Cylinder.getCapacity()){
394             status = 1; //Closed, but no results yet
395             //This game needs finishing, so try to find out who wins
396             Random.Data memory r;
397             uint length = gtf.length;
398             for(uint i=gtfStart; i<length; ++i){
399                 GameToFinish memory g = gtf[i];
400                 uint bn = g.blockNumber;
401                 if(blockhash(bn) == 0)
402                     break; //We either on the same block or too far from this block
403 
404                 r.init(bn);
405 
406                 Cylinder.GameResult memory gr = games[g.game].computeGameResult(g.height, r);
407 
408                 if(uint(g.height) == index*Cylinder.getCapacity() && uint(g.game) == game){
409                     //We have found our game so just fill the results
410                     unlucky = gr.unlucky;
411                     jackpot = gr.full ? -int96(gr.jackpot) : int96(gr.jackpot); //The jackpot amount may be inaccurate
412                     status = 2; //Closed and has preliminary results
413                     break;
414                 }
415             }
416         }
417     }
418 
419     function getCylinders(uint game, uint idxFrom, uint idxTo) public view returns (uint blockNumber, bytes32 blockHash, uint96 dep, uint64[] index, address[] deps, uint8[] unlucky, int96[] jackpot, uint64[] lastDepTime, uint8[] status){
420         Cylinder.Data storage c = games[game];
421         uint lastCylinderIndex = c.slots.length/Cylinder.getCapacity();
422         blockNumber = block.number-1;
423         blockHash = blockhash(block.number-1);
424         dep = uint96(c.dep);
425 
426         require(idxFrom <= lastCylinderIndex && idxFrom <= idxTo, "Wrong cylinder index range");
427 
428         if(idxTo > lastCylinderIndex)
429             idxTo = lastCylinderIndex;
430 
431         uint count = idxTo - idxFrom + 1;
432 
433         index = new uint64[](count);
434         deps = new address[](count*Cylinder.getCapacity());
435         unlucky = new uint8[](count);
436         jackpot = new int96[](count);
437         lastDepTime = new uint64[](count);
438         status = new uint8[](count);
439 
440         _putCylindersToArrays(game, idxFrom, count, index, deps, unlucky, jackpot, lastDepTime, status);
441     }
442 
443     function _putCylindersToArrays(uint game, uint idxFrom, uint count, uint64[] index, address[] deps, uint8[] unlucky, int96[] jackpot, uint64[] lastDepTime, uint8[] status) private view {
444         for(uint i=0; i<count; ++i){
445             address[] memory _deps;
446             (, , , index[i], _deps, unlucky[i], jackpot[i], lastDepTime[i], status[i]) = getCylinder(game, int(idxFrom + i));
447             _copyDeps(i*Cylinder.getCapacity(), deps, _deps);
448         }
449     }
450 
451     function _copyDeps(uint start, address[] deps, address[] memory _deps) private pure {
452         for(uint j=0; j<_deps.length; ++j){
453             deps[start + j] = _deps[j];
454         }
455     }
456 
457     function getUnfinishedCount() public view returns (uint) {
458         return gtf.length - gtfStart;
459     }
460 
461     function getUnfinished(uint i) public view returns (uint game, uint blockNumber, uint cylinder) {
462         game = gtf[gtfStart + i].game;
463         blockNumber = gtf[gtfStart + i].blockNumber;
464         cylinder = gtf[gtfStart + i].height/Cylinder.getCapacity();
465     }
466 
467     function getTotalCylindersCount() public view returns (uint) {
468         return gtf.length;
469     }
470 
471     function testRandom() public view returns (uint[] numbers) {
472         numbers = new uint[](32);
473         Random.Data memory r;
474         for(uint i=0; i<256; i+=8){
475             numbers[i/8] = Random.random(r, 10);
476         }
477     }
478 }