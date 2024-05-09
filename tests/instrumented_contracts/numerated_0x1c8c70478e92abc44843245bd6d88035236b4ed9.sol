1 pragma solidity ^0.4.24;
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
12     uint private gameCount = 38;
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
61      * end the game
62      **/
63     function endGame(address targetAddress) public {
64         uint targetGameIndex = gameAddressIdMap[address(targetAddress)];
65         endedGameCount++;
66         endedGames.push(targetAddress);
67         deployedGames[targetGameIndex-1] = deployedGames[deployedGames.length-1];
68 
69         gameAddressIdMap[deployedGames[deployedGames.length-1]] = targetGameIndex;
70 
71         delete deployedGames[deployedGames.length-1];
72         deployedGames.length--;
73 
74         MajorityGame mGame = MajorityGame(address(targetAddress));
75         mGame.endGame();
76     }
77 
78     /**
79      * force to end the game
80      **/
81     function forceEndGame(address targetAddress) public adminOnly {
82         uint targetGameIndex = gameAddressIdMap[address(targetAddress)];
83         endedGameCount++;
84         endedGames.push(targetAddress);
85         deployedGames[targetGameIndex-1] = deployedGames[deployedGames.length-1];
86 
87         gameAddressIdMap[deployedGames[deployedGames.length-1]] = targetGameIndex;
88 
89         delete deployedGames[deployedGames.length-1];
90         deployedGames.length--;
91 
92         MajorityGame mGame = MajorityGame(address(targetAddress));
93         mGame.forceEndGame();
94     }
95 }
96 
97 
98 contract MajorityGame {
99 
100     uint private gameId;
101 
102     uint private jackpot;
103     uint private gameBet;
104 
105     // address of the creator
106     address private adminAddress;
107     address private officialAddress;
108 
109     // game start time
110     uint private startTime;
111     uint private endTime;
112 
113     // game data
114     string private questionText;
115 
116     // store all player option record
117     mapping(address => bool) private option1List;
118     mapping(address => bool) private option2List;
119 
120     // address list
121     address[] private option1AddressList;
122     address[] private option2AddressList;
123 
124 	// award
125     uint private awardCounter;
126 
127     address[] private first6AddresstList;
128     address private lastAddress;
129 
130     uint private winnerSide;
131     uint private finalBalance;
132     uint private award;
133 
134     modifier adminOnly() {
135         require(msg.sender == adminAddress);
136         _;
137     }
138 
139     modifier withinGameTime() {
140 		require(now >= startTime);
141         require(now <= endTime);
142         _;
143     }
144 
145     modifier afterGameTime() {
146         require(now > endTime);
147         _;
148     }
149 
150     modifier notEnded() {
151         require(winnerSide == 0);
152         _;
153     }
154 
155     modifier isEnded() {
156         require(winnerSide > 0);
157         _;
158     }
159 
160     modifier withinLimitPlayer() {
161         require((option1AddressList.length + option2AddressList.length) < 500);
162         _;
163     }
164 
165     constructor(uint _gameId, uint _gameBet, uint _endTime, string _questionText, address _officialAddress) public {
166         gameId = _gameId;
167         adminAddress = msg.sender;
168 
169         gameBet = _gameBet;
170         startTime = _endTime - 25*60*60;
171         endTime = _endTime;
172         questionText = _questionText;
173 
174         winnerSide = 0;
175         award = 0;
176 
177         officialAddress = _officialAddress;
178     }
179 
180     /**
181      * set the bonus of the game
182      **/
183     function setJackpot() public payable adminOnly returns (bool) {
184         if (msg.value > 0) {
185             jackpot += msg.value;
186             return true;
187         }
188         return false;
189     }
190 
191     /**
192      * return the game details:
193      * 0 game id
194      * 1 start time
195      * 2 end time
196      * 3 no of player
197      * 4 game balance
198      * 5 question + option 1 + option 2
199      * 6 jackpot
200      * 7 is ended game
201      * 8 game bet value
202      **/
203     function getGameData() public view returns (uint, uint, uint, uint, uint, string, uint, uint, uint) {
204 
205         return (
206             gameId,
207             startTime,
208             endTime,
209             option1AddressList.length + option2AddressList.length,
210             address(this).balance,
211             questionText,
212             jackpot,
213             winnerSide,
214             gameBet
215         );
216     }
217 
218     /**
219      * player submit their option
220      **/
221     function submitChoose(uint _chooseValue) public payable notEnded withinGameTime {
222         require(!option1List[msg.sender] && !option2List[msg.sender]);
223         require(msg.value == gameBet);
224 		
225         if (_chooseValue == 1) {
226             option1List[msg.sender] = true;
227             option1AddressList.push(msg.sender);
228         } else if (_chooseValue == 2) {
229             option2List[msg.sender] = true;
230             option2AddressList.push(msg.sender);
231         }
232 
233         // add to first 6 player
234         if(option1AddressList.length + option2AddressList.length <= 6){
235             first6AddresstList.push(msg.sender);
236         }
237 
238         // add to last player
239         lastAddress = msg.sender;
240     }
241 
242     /**
243      * calculate the winner side
244      * calculate the award to winner
245      **/
246     function endGame() public afterGameTime {
247         require(winnerSide == 0);
248 
249         finalBalance = address(this).balance;
250 
251         // 10% for commision
252         uint totalAward = finalBalance * 9 / 10;
253 
254         uint option1Count = uint(option1AddressList.length);
255         uint option2Count = uint(option2AddressList.length);
256 
257         uint sumCount = option1Count + option2Count;
258 
259         if(sumCount == 0 ){
260             award = 0;
261             awardCounter = 0;
262             if(gameId % 2 == 1){
263                 winnerSide = 1;
264             }else{
265                 winnerSide = 2;
266             }
267             return;
268         }else{
269             if (option1Count != 0 && sumCount / option1Count > 10) {
270 				winnerSide = 1;
271 			} else if (option2Count != 0 && sumCount / option2Count > 10) {
272 				winnerSide = 2;
273 			} else if (option1Count > option2Count || (option1Count == option2Count && gameId % 2 == 1)) {
274 				winnerSide = 1;
275 			} else {
276 				winnerSide = 2;
277 			}
278         }
279 
280         if (winnerSide == 1) {
281             award = uint(totalAward / option1Count);
282             awardCounter = option1Count;
283         } else {
284             award = uint(totalAward / option2Count);
285             awardCounter = option2Count;
286         }
287     }
288 
289     /**
290      * calculate the winner side
291      * calculate the award to winner
292      **/
293     function forceEndGame() public adminOnly {
294         require(winnerSide == 0);
295 
296         finalBalance = address(this).balance;
297 
298         // 10% for commision
299         uint totalAward = finalBalance * 9 / 10;
300 
301         uint option1Count = uint(option1AddressList.length);
302         uint option2Count = uint(option2AddressList.length);
303 
304         uint sumCount = option1Count + option2Count;
305 
306         if(sumCount == 0 ){
307             award = 0;
308             awardCounter = 0;
309             if(gameId % 2 == 1){
310                 winnerSide = 1;
311             }else{
312                 winnerSide = 2;
313             }
314             return;
315         }
316 
317         if (option1Count != 0 && sumCount / option1Count > 10) {
318             winnerSide = 1;
319         } else if (option2Count != 0 && sumCount / option2Count > 10) {
320             winnerSide = 2;
321         } else if (option1Count > option2Count || (option1Count == option2Count && gameId % 2 == 1)) {
322             winnerSide = 1;
323         } else {
324             winnerSide = 2;
325         }
326 
327         if (winnerSide == 1) {
328             award = uint(totalAward / option1Count);
329             awardCounter = option1Count;
330         } else {
331             award = uint(totalAward / option2Count);
332             awardCounter = option2Count;
333         }
334     }
335 
336     /**
337      * send award to winner
338      **/    
339     function sendAward() public isEnded {
340         require(awardCounter > 0);
341 
342         uint count = awardCounter;
343 
344         if (awardCounter > 400) {
345             for (uint i = 0; i < 400; i++) {
346                 this.sendAwardToLastOne();
347             }
348         } else {
349             for (uint j = 0; j < count; j++) {
350                 this.sendAwardToLastOne();
351             }
352         }
353     }
354 
355     /**
356      * send award to last winner of the list
357      **/    
358     function sendAwardToLastOne() public isEnded {
359 		require(awardCounter > 0);
360         if(winnerSide == 1){
361             address(option1AddressList[awardCounter - 1]).transfer(award);
362         }else{
363             address(option2AddressList[awardCounter - 1]).transfer(award);
364         }
365         
366         awardCounter--;
367 
368         if(awardCounter == 0){
369             if(option1AddressList.length + option2AddressList.length >= 7){
370                 // send 0.5% of total bet to each first player
371                 uint awardFirst6 = uint(finalBalance / 200);
372                 for (uint k = 0; k < 6; k++) {
373                     address(first6AddresstList[k]).transfer(awardFirst6);
374                 }
375                 // send 2% of total bet to last player
376                 address(lastAddress).transfer(uint(finalBalance / 50));
377             }
378 
379             // send the rest of balance to officialAddress
380             address(officialAddress).transfer(address(this).balance);
381         }
382     }
383 
384     /**
385      * return the game details after ended
386      * 0 winner side
387      * 1 nomber of player who choose option 1
388      * 2 nomber of player who choose option 2
389      * 3 total award
390      * 4 award of each winner
391      **/
392     function getEndGameStatus() public isEnded view returns (uint, uint, uint, uint, uint) {
393         return (
394             winnerSide,
395             option1AddressList.length,
396             option2AddressList.length,
397             finalBalance,
398             award
399         );
400     }
401 
402     /**
403     * get the option of the player choosed
404     **/
405     function getPlayerOption() public view returns (uint) {
406         if (option1List[msg.sender]) {
407             return 1;
408         } else if (option2List[msg.sender]) {
409             return 2;
410         } else {
411             return 0;
412         }
413     }
414 
415     /**
416      * return the players who won the game
417      **/
418     function getWinnerAddressList() public isEnded view returns (address[]) {
419       if (winnerSide == 1) {
420         return option1AddressList;
421       }else {
422         return option2AddressList;
423       }
424     }
425 
426     /**
427      * return the players who lose the game
428      **/
429     function getLoserAddressList() public isEnded view returns (address[]) {
430       if (winnerSide == 1) {
431         return option2AddressList;
432       }else {
433         return option1AddressList;
434       }
435     }
436 }