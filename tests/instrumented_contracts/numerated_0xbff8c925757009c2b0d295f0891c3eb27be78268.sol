1 pragma solidity ^0.4.25;
2 
3 contract MajorityGameFactory {
4 
5     address[] private deployedGames;
6     address[] private endedGames;
7 
8     address private adminAddress;
9 
10     mapping(address => uint) private gameAddressIdMap;
11 
12     uint private gameCount = 320;
13     uint private endedGameCount = 0;
14 
15     modifier adminOnly() {
16         require(msg.sender == adminAddress);
17         _;
18     }
19 
20     constructor () public {
21         adminAddress = msg.sender;
22     }
23 
24     /**
25      * create new game
26      **/
27     function createGame (uint _gameBet, uint _endTime, string _questionText, address _officialAddress) public adminOnly payable {
28         gameCount ++;
29         address newGameAddress = new MajorityGame(gameCount, _gameBet, _endTime, _questionText, _officialAddress);
30         deployedGames.push(newGameAddress);
31         gameAddressIdMap[newGameAddress] = deployedGames.length;
32 
33         setJackpot(newGameAddress, msg.value);
34     }
35 
36     /**
37      * return all available games address
38      **/
39     function getDeployedGames() public view returns (address[]) {
40         return deployedGames;
41     }
42 
43     /**
44      * return all available games address
45      **/
46     function getEndedGames() public view returns (address[]) {
47         return endedGames;
48     }
49 
50     /**
51      * set bonus of the game
52      **/
53     function setJackpot(address targetAddress, uint val) adminOnly public {
54         if (val > 0) {
55             MajorityGame mGame = MajorityGame(targetAddress);
56             mGame.setJackpot.value(val)();
57         }
58     }
59     
60     /**
61      * player submit choose
62      **/
63     function submitChoose(address gameAddress, uint choose) public payable {
64         if (msg.value > 0) {
65             MajorityGame mGame = MajorityGame(gameAddress);
66             mGame.submitChooseByFactory.value(msg.value)(msg.sender, choose);
67         }
68     }
69 
70     /**
71      * end the game
72      **/
73     function endGame(address targetAddress) public {
74         uint targetGameIndex = gameAddressIdMap[address(targetAddress)];
75         endedGameCount++;
76         endedGames.push(targetAddress);
77         deployedGames[targetGameIndex-1] = deployedGames[deployedGames.length-1];
78 
79         gameAddressIdMap[deployedGames[deployedGames.length-1]] = targetGameIndex;
80 
81         delete deployedGames[deployedGames.length-1];
82         deployedGames.length--;
83 
84         MajorityGame mGame = MajorityGame(address(targetAddress));
85         mGame.endGame();
86     }
87 
88     /**
89      * force to end the game
90      **/
91     function forceEndGame(address targetAddress) public adminOnly {
92         uint targetGameIndex = gameAddressIdMap[address(targetAddress)];
93         endedGameCount++;
94         endedGames.push(targetAddress);
95         deployedGames[targetGameIndex-1] = deployedGames[deployedGames.length-1];
96 
97         gameAddressIdMap[deployedGames[deployedGames.length-1]] = targetGameIndex;
98 
99         delete deployedGames[deployedGames.length-1];
100         deployedGames.length--;
101 
102         MajorityGame mGame = MajorityGame(address(targetAddress));
103         mGame.forceEndGame();
104     }
105     
106     /**
107      * selfdestruct
108      */
109     function destruct() public adminOnly{
110         selfdestruct(adminAddress);
111     }
112     
113     
114     /**
115      * destruct a game
116      */
117     function destructGame(address targetAddress) public adminOnly{
118         MajorityGame mGame = MajorityGame(address(targetAddress));
119         mGame.destruct();
120     }
121 }
122 
123 
124 contract MajorityGame {
125 
126     uint private gameId;
127 
128     uint private jackpot;
129     uint private gameBet;
130 
131     // address of the creator
132     address private adminAddress;
133     address private officialAddress;
134 
135     // game start time
136     uint private startTime;
137     uint private endTime;
138 
139     // game data
140     string private questionText;
141 
142     // store all player option record
143     mapping(address => bool) private option1List;
144     mapping(address => bool) private option2List;
145 
146     // address list
147     address[] private option1AddressList;
148     address[] private option2AddressList;
149 
150 	// award
151     uint private awardCounter;
152 
153     address[] private first6AddresstList;
154     address private lastAddress;
155 
156     uint private winnerSide;
157     uint private finalBalance;
158     uint private award;
159 
160     modifier adminOnly() {
161         require(msg.sender == adminAddress);
162         _;
163     }
164 
165     modifier withinGameTime() {
166 		    require(now >= startTime);
167         require(now <= endTime);
168         _;
169     }
170 
171     modifier afterGameTime() {
172         require(now > endTime);
173         _;
174     }
175 
176     modifier notEnded() {
177         require(winnerSide == 0);
178         _;
179     }
180 
181     modifier isEnded() {
182         require(winnerSide > 0);
183         _;
184     }
185 
186     modifier withinLimitPlayer() {
187         require((option1AddressList.length + option2AddressList.length) < 500);
188         _;
189     }
190 
191     constructor(uint _gameId, uint _gameBet, uint _endTime, string _questionText, address _officialAddress) public {
192         gameId = _gameId;
193         adminAddress = msg.sender;
194 
195         gameBet = _gameBet;
196         startTime = _endTime - 25*60*60;
197         endTime = _endTime;
198         questionText = _questionText;
199 
200         winnerSide = 0;
201         award = 0;
202 
203         officialAddress = _officialAddress;
204     }
205 
206     /**
207      * set the bonus of the game
208      **/
209     function setJackpot() public payable adminOnly returns (bool) {
210         if (msg.value > 0) {
211             jackpot += msg.value;
212             return true;
213         }
214         return false;
215     }
216 
217     /**
218      * return the game details:
219      * 0 game id
220      * 1 start time
221      * 2 end time
222      * 3 no of player
223      * 4 game balance
224      * 5 question + option 1 + option 2
225      * 6 jackpot
226      * 7 is ended game
227      * 8 game bet value
228      **/
229     function getGameData() public view returns (uint, uint, uint, uint, uint, string, uint, uint, uint) {
230 
231         return (
232             gameId,
233             startTime,
234             endTime,
235             option1AddressList.length + option2AddressList.length,
236             address(this).balance,
237             questionText,
238             jackpot,
239             winnerSide,
240             gameBet
241         );
242     }
243     
244     /**
245      * player submit their option
246      **/
247     function submitChooseByFactory(address playerAddress, uint _chooseValue) public payable adminOnly notEnded withinGameTime {
248         require(!option1List[playerAddress] && !option2List[playerAddress]);
249         require(msg.value == gameBet);
250 
251         if (_chooseValue == 1) {
252             option1List[playerAddress] = true;
253             option1AddressList.push(playerAddress);
254         } else if (_chooseValue == 2) {
255             option2List[playerAddress] = true;
256             option2AddressList.push(playerAddress);
257         }
258 
259         // add to first 6 player
260         if(option1AddressList.length + option2AddressList.length <= 6){
261             first6AddresstList.push(playerAddress);
262         }
263 
264         // add to last player
265         lastAddress = playerAddress;
266     }
267 
268 
269     /**
270      * calculate the winner side
271      * calculate the award to winner
272      **/
273     function endGame() public afterGameTime {
274         require(winnerSide == 0);
275 
276         finalBalance = address(this).balance;
277 
278         // 10% for commision
279         uint totalAward = finalBalance * 9 / 10;
280 
281         uint option1Count = uint(option1AddressList.length);
282         uint option2Count = uint(option2AddressList.length);
283 
284         uint sumCount = option1Count + option2Count;
285 
286         if(sumCount == 0 ){
287             award = 0;
288             awardCounter = 0;
289             if(gameId % 2 == 1){
290                 winnerSide = 1;
291             }else{
292                 winnerSide = 2;
293             }
294             return;
295         }else{
296             if (option1Count != 0 && sumCount / option1Count > 10) {
297 				winnerSide = 1;
298 			} else if (option2Count != 0 && sumCount / option2Count > 10) {
299 				winnerSide = 2;
300 			} else if (option1Count > option2Count || (option1Count == option2Count && gameId % 2 == 1)) {
301 				winnerSide = 1;
302 			} else {
303 				winnerSide = 2;
304 			}
305         }
306 
307         if (winnerSide == 1) {
308             award = uint(totalAward / option1Count);
309             awardCounter = option1Count;
310         } else {
311             award = uint(totalAward / option2Count);
312             awardCounter = option2Count;
313         }
314     }
315 
316     /**
317      * calculate the winner side
318      * calculate the award to winner
319      **/
320     function forceEndGame() public adminOnly {
321         require(winnerSide == 0);
322 
323         finalBalance = address(this).balance;
324 
325         // 10% for commision
326         uint totalAward = finalBalance * 9 / 10;
327 
328         uint option1Count = uint(option1AddressList.length);
329         uint option2Count = uint(option2AddressList.length);
330 
331         uint sumCount = option1Count + option2Count;
332 
333         if(sumCount == 0 ){
334             award = 0;
335             awardCounter = 0;
336             if(gameId % 2 == 1){
337                 winnerSide = 1;
338             }else{
339                 winnerSide = 2;
340             }
341             return;
342         }
343 
344         if (option1Count != 0 && sumCount / option1Count > 10) {
345             winnerSide = 1;
346         } else if (option2Count != 0 && sumCount / option2Count > 10) {
347             winnerSide = 2;
348         } else if (option1Count > option2Count || (option1Count == option2Count && gameId % 2 == 1)) {
349             winnerSide = 1;
350         } else {
351             winnerSide = 2;
352         }
353 
354         if (winnerSide == 1) {
355             award = uint(totalAward / option1Count);
356             awardCounter = option1Count;
357         } else {
358             award = uint(totalAward / option2Count);
359             awardCounter = option2Count;
360         }
361     }
362 
363     /**
364      * send award to winner
365      **/
366     function sendAward() public isEnded {
367         require(awardCounter > 0);
368 
369         uint count = awardCounter;
370 
371         if (awardCounter > 400) {
372             for (uint i = 0; i < 400; i++) {
373                 this.sendAwardToLastOne();
374             }
375         } else {
376             for (uint j = 0; j < count; j++) {
377                 this.sendAwardToLastOne();
378             }
379         }
380     }
381 
382     /**
383      * send award to last winner of the list
384      **/
385     function sendAwardToLastOne() public isEnded {
386 		require(awardCounter > 0);
387         if(winnerSide == 1){
388             address(option1AddressList[awardCounter - 1]).transfer(award);
389         }else{
390             address(option2AddressList[awardCounter - 1]).transfer(award);
391         }
392 
393         awardCounter--;
394 
395         if(awardCounter == 0){
396             if(option1AddressList.length + option2AddressList.length >= 7){
397                 // send 0.5% of total bet to each first player
398                 uint awardFirst6 = uint(finalBalance / 200);
399                 for (uint k = 0; k < 6; k++) {
400                     address(first6AddresstList[k]).transfer(awardFirst6);
401                 }
402                 // send 2% of total bet to last player
403                 address(lastAddress).transfer(uint(finalBalance / 50));
404             }
405 
406             // send the rest of balance to officialAddress
407             address(officialAddress).transfer(address(this).balance);
408         }
409     }
410 
411     /**
412      * return the game details after ended
413      * 0 winner side
414      * 1 nomber of player who choose option 1
415      * 2 nomber of player who choose option 2
416      * 3 total award
417      * 4 award of each winner
418      **/
419     function getEndGameStatus() public isEnded view returns (uint, uint, uint, uint, uint) {
420         return (
421             winnerSide,
422             option1AddressList.length,
423             option2AddressList.length,
424             finalBalance,
425             award
426         );
427     }
428 
429     /**
430     * get the option of the player choosed
431     **/
432     function getPlayerOption() public view returns (uint) {
433         if (option1List[msg.sender]) {
434             return 1;
435         } else if (option2List[msg.sender]) {
436             return 2;
437         } else {
438             return 0;
439         }
440     }
441 
442     /**
443      * return the players who won the game
444      **/
445     function getWinnerAddressList() public isEnded view returns (address[]) {
446       if (winnerSide == 1) {
447         return option1AddressList;
448       }else {
449         return option2AddressList;
450       }
451     }
452 
453     /**
454      * return the players who lose the game
455      **/
456     function getLoserAddressList() public isEnded view returns (address[]) {
457       if (winnerSide == 1) {
458         return option2AddressList;
459       }else {
460         return option1AddressList;
461       }
462     }
463     
464     /**
465      * selfdestruct
466      */
467     function destruct() public adminOnly{
468         selfdestruct(adminAddress);
469     }
470 }