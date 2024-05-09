1 pragma solidity ^0.4.24;
2 
3 contract MajorityGameFactory {
4 
5     address[] public deployedGames;
6     address[] public endedGames;
7     address[] public tempArray;
8 
9     address public adminAddress;
10 
11     mapping(address => uint) private gameAddressIdMap;
12 
13     uint public gameCount = 0;
14     uint public endedGameCount = 0;
15 
16     modifier adminOnly() {
17         require(msg.sender == adminAddress);
18         _;
19     }
20 
21     constructor () public {
22         adminAddress = msg.sender;
23     }
24 
25     /**
26      * create new game
27      **/
28     function createGame (uint _gameBet, uint _startTime, string _questionText, address _officialAddress) public adminOnly payable {
29         gameCount ++;
30         address newGameAddress = new MajorityGame(gameCount, _gameBet, _startTime, _questionText, _officialAddress);
31         deployedGames.push(newGameAddress);
32         gameAddressIdMap[newGameAddress] = deployedGames.length;
33 
34         setJackpot(newGameAddress, msg.value);
35     }
36 
37     /**
38      * return all available games address
39      **/
40     function getDeployedGames() public view returns (address[]) {
41         return deployedGames;
42     }
43 
44     /**
45      * return all available games address
46      **/
47     function getEndedGames() public view returns (address[]) {
48         return endedGames;
49     }
50 
51     /**
52      * set bonus of the game
53      **/
54     function setJackpot(address targetAddress, uint val) adminOnly public {
55         if (val > 0) {
56             MajorityGame mGame = MajorityGame(targetAddress);
57             mGame.setJackpot.value(val)();
58         }
59     }
60 
61     /**
62      * end the game
63      **/
64     function endGame(address targetAddress) public {
65         uint targetGameIndex = gameAddressIdMap[address(targetAddress)];
66         endedGameCount++;
67         endedGames.push(targetAddress);
68         deployedGames[targetGameIndex-1] = deployedGames[deployedGames.length-1];
69 
70         gameAddressIdMap[deployedGames[deployedGames.length-1]] = targetGameIndex;
71 
72         delete deployedGames[deployedGames.length-1];
73         deployedGames.length--;
74 
75         MajorityGame mGame = MajorityGame(address(targetAddress));
76         mGame.endGame();
77     }
78 
79     /**
80      * force to end the game
81      **/
82     function forceEndGame(address targetAddress) public adminOnly {
83         uint targetGameIndex = gameAddressIdMap[address(targetAddress)];
84         endedGameCount++;
85         endedGames.push(targetAddress);
86         deployedGames[targetGameIndex-1] = deployedGames[deployedGames.length-1];
87 
88         gameAddressIdMap[deployedGames[deployedGames.length-1]] = targetGameIndex;
89 
90         delete deployedGames[deployedGames.length-1];
91         deployedGames.length--;
92 
93         MajorityGame mGame = MajorityGame(address(targetAddress));
94         mGame.forceEndGame();
95     }
96 }
97 
98 
99 contract MajorityGame {
100 
101     // 1 minute
102     //uint constant private AVAILABLE_GAME_TIME = 0;
103     uint constant private MINIMUM_BET = 50000000000000000;
104     uint constant private MAXIMUM_BET = 50000000000000000;
105 
106     uint public gameId;
107 
108     uint private jackpot;
109     uint private gameBet;
110 
111     // address of the creator
112     address public adminAddress;
113     address public officialAddress;
114 
115     // game start time
116     uint private startTime;
117 
118     // game data
119     string private questionText;
120 
121     // store all player bet value
122     mapping(address => bool) private playerList;
123     uint public playersCount;
124 
125     // store all player option record
126     mapping(address => bool) private option1List;
127     mapping(address => bool) private option2List;
128 
129     // address list
130     address[] private option1AddressList;
131     address[] private option2AddressList;
132     address[] private winnerList;
133 
134     uint private winnerSide;
135     uint private finalBalance;
136     uint private award;
137 
138     // count the player option
139     //uint private option1Count;
140     //uint private option2Count;
141     modifier adminOnly() {
142         require(msg.sender == adminAddress);
143         _;
144     }
145 
146     modifier withinGameTime() {
147         require(now <= startTime);
148         //require(now < startTime + AVAILABLE_GAME_TIME);
149         _;
150     }
151 
152     modifier afterGameTime() {
153         require(now > startTime);
154         //require(now > startTime + AVAILABLE_GAME_TIME);
155         _;
156     }
157 
158     modifier notEnded() {
159         require(winnerSide == 0);
160         _;
161     }
162 
163     modifier isEnded() {
164         require(winnerSide > 0);
165         _;
166     }
167 
168     constructor(uint _gameId, uint _gameBet, uint _startTime, string _questionText, address _officialAddress) public {
169         gameId = _gameId;
170         adminAddress = msg.sender;
171 
172         gameBet = _gameBet;
173         startTime = _startTime;
174         questionText = _questionText;
175 
176         playersCount = 0;
177         winnerSide = 0;
178         award = 0;
179 
180         officialAddress = _officialAddress;
181     }
182     /*
183     function() public payable {
184     }
185     */
186     /**
187      * set the bonus of the game
188      **/
189     function setJackpot() public payable adminOnly returns (bool) {
190         if (msg.value > 0) {
191             jackpot += msg.value;
192             return true;
193         }
194         return false;
195     }
196 
197     /**
198      * return the game data when playing
199      * 0 start time
200      * 1 end time
201      * 2 no of player
202      * 3 total bet
203      * 4 jackpot
204      * 5 is ended game boolean
205      * 6 game bet value
206      **/
207     function getGamePlayingStatus() public view returns (uint, uint, uint, uint, uint, uint, uint) {
208         return (
209         startTime,
210         startTime,
211         //startTime + AVAILABLE_GAME_TIME,
212         playersCount,
213         address(this).balance,
214         jackpot,
215         winnerSide,
216         gameBet
217         );
218     }
219 
220     /**
221      * return the game details:
222      * 0 game id
223      * 1 start time
224      * 2 end time
225      * 3 no of player
226      * 4 total bet
227      * 5 question + option 1 + option 2
228      * 6 jackpot
229      * 7 is ended game
230      * 8 game bet value
231      **/
232     function getGameData() public view returns (uint, uint, uint, uint, uint, string, uint, uint, uint) {
233         return (
234         gameId,
235         startTime,
236         startTime,
237         //startTime + AVAILABLE_GAME_TIME,
238         playersCount,
239         address(this).balance,
240         questionText,
241         jackpot,
242         winnerSide,
243         gameBet
244         );
245     }
246 
247     /**
248      * player submit their option
249      **/
250     function submitChoose(uint _chooseValue) public payable notEnded withinGameTime {
251         require(!playerList[msg.sender]);
252         require(msg.value == gameBet);
253 
254         playerList[msg.sender] = true;
255         playersCount++;
256 
257         if (_chooseValue == 1) {
258             option1List[msg.sender] = true;
259             option1AddressList.push(msg.sender);
260         } else if (_chooseValue == 2) {
261             option2List[msg.sender] = true;
262             option2AddressList.push(msg.sender);
263         }
264     }
265 
266     /**
267      * calculate the winner side
268      * calculate the award to winner
269      **/
270     function endGame() public afterGameTime {
271         require(winnerSide == 0);
272 
273         // 10% for operation fee
274         finalBalance = address(this).balance;
275 
276         uint totalAward = uint(finalBalance * 9 / 10);
277 
278         uint option1Count = option1AddressList.length;
279         uint option2Count = option2AddressList.length;
280 
281         if (option1Count > option2Count || (option1Count == option2Count && gameId % 2 == 1)) { // option1 win
282             award = option1Count == 0 ? 0 : uint(totalAward / option1Count);
283             winnerSide = 1;
284             winnerList = option1AddressList;
285         } else if (option2Count > option1Count || (option1Count == option2Count && gameId % 2 == 0)) { // option2 win
286             award = option2Count == 0 ? 0 : uint(totalAward / option2Count);
287             winnerSide = 2;
288             winnerList = option2AddressList;
289         }
290     }
291 
292     /**
293      * calculate the winner side
294      * calculate the award to winner
295      **/
296     function forceEndGame() public adminOnly {
297         require(winnerSide == 0);
298         // 10% for operation fee
299         finalBalance = address(this).balance;
300 
301         uint totalAward = uint(finalBalance * 9 / 10);
302 
303         uint option1Count = option1AddressList.length;
304         uint option2Count = option2AddressList.length;
305 
306         if (option1Count > option2Count || (option1Count == option2Count && gameId % 2 == 1)) { // option1 win
307             award = option1Count == 0 ? 0 : uint(totalAward / option1Count);
308             winnerSide = 1;
309             winnerList = option1AddressList;
310         } else if (option2Count > option1Count || (option1Count == option2Count && gameId % 2 == 0)) { // option2 win
311             award = option2Count == 0 ? 0 : uint(totalAward / option2Count);
312             winnerSide = 2;
313             winnerList = option2AddressList;
314         }
315     }
316 
317     /**
318      * send award to winner
319      **/
320     function sendAward() public isEnded {
321         require(winnerList.length > 0);
322 
323         uint count = winnerList.length;
324 
325         if (count > 250) {
326             for (uint i = 0; i < 250; i++) {
327                 this.sendAwardToLastWinner();
328             }
329         } else {
330             for (uint j = 0; j < count; j++) {
331                 this.sendAwardToLastWinner();
332             }
333         }
334     }
335 
336     /**
337      * send award to last winner of the list
338      **/
339     function sendAwardToLastWinner() public isEnded {
340         address(winnerList[winnerList.length - 1]).transfer(award);
341 
342         delete winnerList[winnerList.length - 1];
343         winnerList.length--;
344 
345         if(winnerList.length == 0){
346           address add=address(officialAddress);
347           address(add).transfer(address(this).balance);
348         }
349     }
350 
351     /**
352      * return the game details after ended
353      * 0 winner side
354      * 1 nomber of player who choose option 1
355      * 2 nomber of player who choose option 2
356      * 3 total award
357      * 4 award of each winner
358      **/
359     function getEndGameStatus() public isEnded view returns (uint, uint, uint, uint, uint) {
360         return (
361             winnerSide,
362             option1AddressList.length,
363             option2AddressList.length,
364             finalBalance,
365             award
366         );
367     }
368 
369     /**
370     * get the option os the player choosed
371     **/
372     function getPlayerOption() public view returns (uint) {
373         if (option1List[msg.sender]) {
374             return 1;
375         } else if (option2List[msg.sender]) {
376             return 2;
377         } else {
378             return 0;
379         }
380     }
381 
382     /**
383      * return the players who won the game
384      **/
385     function getWinnerAddressList() public isEnded view returns (address[]) {
386       if (winnerSide == 1) {
387         return option1AddressList;
388       }else {
389         return option2AddressList;
390       }
391     }
392 
393     /**
394      * return the players who won the game
395      **/
396     function getLoserAddressList() public isEnded view returns (address[]) {
397       if (winnerSide == 1) {
398         return option2AddressList;
399       }else {
400         return option1AddressList;
401       }
402     }
403 
404     /**
405      * return winner list
406      **/
407     function getWinnerList() public isEnded view returns (address[]) {
408         return winnerList;
409     }
410 
411     /**
412      * return winner list size
413      **/
414     function getWinnerListLength() public isEnded view returns (uint) {
415         return winnerList.length;
416     }
417 }