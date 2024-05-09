1 pragma solidity ^0.4.22;
2 //
3 // complied with 0.4.24+commit.e67f0147.Emscripten.clang
4 // 2018-09-07
5 // With Optimization enabled
6 //
7 // Contact support@win1million.app
8 //
9 // Play at: https://win1million.app
10 // 
11 // Provably fair prize game where you can win $1m!
12 //
13 //
14 
15 /**
16  * @title SafeMath
17  * @dev Math operations with safety checks that throw on error
18  */
19 library SafeMath {
20     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
21         uint256 c = a * b;
22         assert(a == 0 || c / a == b);
23         return c;
24     }
25 
26     function div(uint256 a, uint256 b) internal pure returns (uint256) {
27         // assert(b > 0); // Solidity automatically throws when dividing by 0
28         uint256 c = a / b;
29         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
30         return c;
31     }
32 
33     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
34         assert(b <= a);
35         return a - b;
36     }
37 
38     function add(uint256 a, uint256 b) internal pure returns (uint256) {
39         uint256 c = a + b;
40         assert(c >= a);
41         return c;
42     }
43 }
44 
45 contract Win1Million {
46     
47     using SafeMath for uint256;
48     
49     address owner;
50     address bankAddress;
51     address charityAddress;
52     
53     bool gamePaused = false;
54     uint256 public housePercent = 2;
55     uint256 public charityPercent = 2;
56     uint256 public bankBalance;
57     uint256 public charityBalance;
58     uint256 public totalCharitySent = 0;
59     uint256 public minGamePlayAmount = 30000000000000000;
60     
61     modifier onlyOwner() {
62         require(owner == msg.sender);
63         _;
64     }
65     modifier onlyBanker() {
66         require(bankAddress == msg.sender);
67         _;
68     }
69     modifier whenNotPaused() {
70         require(gamePaused == false);
71         _;
72     }
73     modifier correctAnswers(uint256 barId, string _answer1, string _answer2, string _answer3) {
74         require(compareStrings(gameBars[barId].answer1, _answer1));
75         require(compareStrings(gameBars[barId].answer2, _answer2));
76         require(compareStrings(gameBars[barId].answer3, _answer3));
77         _;
78     }
79     
80     struct Bar {
81         uint256     Limit;          // max amount of wei for this game
82         uint256     CurrentGameId;
83         string      answer1;
84         string      answer2;
85         string      answer3;
86     }
87     
88     struct Game {
89         uint256                         BarId;
90         uint256                         CurrentTotal;
91         mapping(address => uint256)     PlayerBidMap;
92         address[]                       PlayerAddressList;
93     }
94     
95     struct Winner {
96         address     winner;
97         uint256     amount;
98         uint256     timestamp;
99         uint256     barId;
100         uint256     gameId;
101     }
102 
103     Bar[]       public  gameBars;
104     Game[]      public  games;
105     Winner[]    public  winners;
106     
107     mapping (address => uint256) playerPendingWithdrawals;
108     
109     function getWinnersLen() public view returns(uint256) {
110         return winners.length;
111     }
112     
113     // helper function so we can extrat list of all players at the end of each game...
114     function getGamesPlayers(uint256 gameId) public view returns(address[]){
115         return games[gameId].PlayerAddressList;
116     }
117     // and then enumerate through them and get their respective bids...
118     function getGamesPlayerBids(uint256 gameId, address playerAddress) public view returns(uint256){
119         return games[gameId].PlayerBidMap[playerAddress];
120     }
121     
122     constructor() public {
123         owner = msg.sender;
124         bankAddress = owner;
125         
126         // ensure we are above gameBars[0] 
127         gameBars.push(Bar(0,0,"","",""));
128         
129         // and for games[0]
130         address[] memory _addressList;
131         games.push(Game(0,0,_addressList));
132         
133     }
134     
135     event uintEvent(
136         uint256 eventUint
137         );
138         
139     event gameComplete(
140         uint256 gameId
141         );
142         
143 
144     // Should only be used on estimate gas to check if the players bid
145     // will be acceptable and not be over the game limit...
146     // Should not be used to send Ether!
147     function playGameCheckBid(uint256 barId) public whenNotPaused payable {
148         uint256 gameAmt = (msg.value.div(100)).mul(100-(housePercent+charityPercent));
149         uint256 currentGameId = gameBars[barId].CurrentGameId;
150         
151         if(gameBars[barId].CurrentGameId == 0) {
152             if(gameAmt > gameBars[barId].Limit) {
153                 require(msg.value == minGamePlayAmount);
154             }
155             
156         } else {
157             currentGameId = gameBars[barId].CurrentGameId;
158             require(games[currentGameId].BarId > 0); // Ensure it hasn't been closed already
159             if(games[currentGameId].CurrentTotal.add(gameAmt) > gameBars[barId].Limit) {
160                 require(msg.value == minGamePlayAmount);
161             }
162 
163         }
164 
165     }
166 
167     function playGame(uint256 barId,
168             string _answer1, string _answer2, string _answer3) public 
169             whenNotPaused 
170             correctAnswers(barId, _answer1, _answer2, _answer3) 
171             payable {
172         require(msg.value >= minGamePlayAmount);
173         
174         // check if a game is in play for this bar...
175         uint256 houseAmt = (msg.value.div(100)).mul(housePercent);
176         uint256 charityAmt = (msg.value.div(100)).mul(charityPercent);
177         uint256 gameAmt = (msg.value.div(100)).mul(100-(housePercent+charityPercent));
178         uint256 currentGameId = 0;
179         
180         
181         if(gameBars[barId].CurrentGameId == 0) {
182             
183             if(gameAmt > gameBars[barId].Limit) {
184                 require(msg.value == minGamePlayAmount);
185             }
186             
187             address[] memory _addressList;
188             games.push(Game(barId, gameAmt, _addressList));
189             currentGameId = games.length-1;
190             
191             gameBars[barId].CurrentGameId = currentGameId;
192             
193         } else {
194             currentGameId = gameBars[barId].CurrentGameId;
195             require(games[currentGameId].BarId > 0); // Ensure it hasn't been closed already
196             if(games[currentGameId].CurrentTotal.add(gameAmt) > gameBars[barId].Limit) {
197                 require(msg.value == minGamePlayAmount);
198             }
199             
200             games[currentGameId].CurrentTotal = games[currentGameId].CurrentTotal.add(gameAmt);    
201         }
202         
203         
204         
205         if(games[currentGameId].PlayerBidMap[msg.sender] == 0) {
206             games[currentGameId].PlayerAddressList.push(msg.sender);
207         }
208         
209         games[currentGameId].PlayerBidMap[msg.sender] = games[currentGameId].PlayerBidMap[msg.sender].add(gameAmt);
210         
211         bankBalance+=houseAmt;
212         charityBalance+=charityAmt;
213         
214         if(games[currentGameId].CurrentTotal >= gameBars[barId].Limit) {
215 
216             emit gameComplete(gameBars[barId].CurrentGameId);
217             gameBars[barId].CurrentGameId = 0;
218         }
219         
220         
221     }
222     event completeGameResult(
223             uint256 indexed gameId,
224             uint256 indexed barId,
225             uint256 winningNumber,
226             string  proof,
227             address winnersAddress,
228             uint256 winningAmount,
229             uint256 timestamp
230         );
231     
232     // using NotaryProxy to generate random numbers with proofs stored in logs so they can be traced back
233     // publish list of players addresses - random number selection (With proof) and then how it was selected
234     
235     function completeGame(uint256 gameId, uint256 _winningNumber, string _proof, address winner) public onlyOwner {
236 
237 
238         
239         if(!winner.send(games[gameId].CurrentTotal)){
240             
241             playerPendingWithdrawals[winner] = playerPendingWithdrawals[winner].add(games[gameId].CurrentTotal);
242         }
243         
244 
245         winners.push(Winner(
246                 winner,
247                 games[gameId].CurrentTotal,
248                 now,
249                 games[gameId].BarId,
250                 gameId
251             ));
252         
253         emit completeGameResult(
254                 gameId,
255                 games[gameId].BarId,
256                 _winningNumber,
257                 _proof,
258                 winner,
259                 games[gameId].CurrentTotal,
260                 now
261             );
262         
263         // reset the bar state...
264         gameBars[games[gameId].BarId].CurrentGameId = 0;
265         
266 
267         
268     }
269     
270     event cancelGame(
271             uint256 indexed gameId,
272             uint256 indexed barId,
273             uint256 amountReturned,
274             address playerAddress
275             
276         );
277     // players can cancel their participation in a game as long as it hasn't completed
278     // they lose their housePercent fee (And pay any gas of course)
279     function player_cancelGame(uint256 barId) public {
280         address _playerAddr = msg.sender;
281         uint256 _gameId = gameBars[barId].CurrentGameId;
282         uint256 _gamePlayerBalance = games[_gameId].PlayerBidMap[_playerAddr];
283         
284         if(_gamePlayerBalance > 0){
285             // reset player bid amount
286             games[_gameId].PlayerBidMap[_playerAddr] = 1; // set to 1 wei to avoid duplicates
287             games[_gameId].CurrentTotal -= _gamePlayerBalance;
288             
289             if(!_playerAddr.send(_gamePlayerBalance)){
290                 // need to add to a retry list...
291                 playerPendingWithdrawals[_playerAddr] = playerPendingWithdrawals[_playerAddr].add(_gamePlayerBalance);
292             } 
293         } 
294         
295         emit cancelGame(
296             _gameId,
297             barId,
298             _gamePlayerBalance,
299             _playerAddr
300             );
301     }
302     
303     
304     function player_withdrawPendingTransactions() public
305         returns (bool)
306      {
307         uint withdrawAmount = playerPendingWithdrawals[msg.sender];
308         playerPendingWithdrawals[msg.sender] = 0;
309 
310         if (msg.sender.call.value(withdrawAmount)()) {
311             return true;
312         } else {
313             /* if send failed revert playerPendingWithdrawals[msg.sender] = 0; */
314             /* player can try to withdraw again later */
315             playerPendingWithdrawals[msg.sender] = withdrawAmount;
316             return false;
317         }
318     }
319 
320 
321     uint256 internal gameOpUint;
322     function gameOp() public returns(uint256) {
323         return gameOpUint;
324     }
325     function private_SetPause(bool _gamePaused) public onlyOwner {
326         gamePaused = _gamePaused;
327     }
328 
329     function private_AddGameBar(uint256 _limit, 
330                     string _answer1, string _answer2, string _answer3) public onlyOwner {
331 
332         gameBars.push(Bar(_limit, 0, _answer1, _answer2, _answer3));
333         emit uintEvent(gameBars.length);
334     }
335     function private_DelGameBar(uint256 barId) public onlyOwner {
336         if(gameBars[barId].CurrentGameId > 0){
337             delete games[gameBars[barId].CurrentGameId];
338         }
339         delete gameBars[barId];
340     }
341 
342     // Used to rebalance a game when the ETH/USD rate changes
343     function private_UpdateGameBarLimit(uint256 barId, uint256 _limit) public onlyOwner {
344         gameBars[barId].Limit = _limit;
345     }
346     function private_setHousePercent(uint256 _housePercent) public onlyOwner {
347         housePercent = _housePercent;
348     }
349     function private_setMinGamePlayAmount(uint256 _minGamePlayAmount) onlyOwner {
350         minGamePlayAmount = _minGamePlayAmount;
351     }
352     function private_setBankAddress(address _bankAddress) public onlyOwner {
353         bankAddress = _bankAddress;
354     }
355     function private_withdrawBankFunds(address _whereTo) public onlyBanker {
356         if(_whereTo.send(bankBalance)) {
357             bankBalance = 0;
358         }
359     }
360     function private_withdrawBankFunds(address _whereTo, uint256 _amount) public onlyBanker {
361         if(_whereTo.send(_amount)){
362             bankBalance-=_amount;
363         }
364     }
365     function private_setCharityAddress(address _charityAddress) public onlyOwner {
366         charityAddress = _charityAddress;
367     }
368 
369     event charityDonation(
370             address indexed charityAddress,
371             string charityName,
372             uint256 amountDonated,
373             uint256 timestamp
374         );
375     function private_sendCharityFunds(string _charityName) public onlyOwner {
376         if(charityAddress.send(charityBalance)) {
377             totalCharitySent += charityBalance;
378             emit charityDonation(
379                     charityAddress,
380                     _charityName,
381                     charityBalance,
382                     now
383                 );
384             charityBalance = 0;
385         }
386     }
387     function private_sendCharityFunds(string _charityName, uint256 _amount) public onlyOwner {
388         require(_amount <= charityBalance);
389         if(charityAddress.send(_amount)) {
390             charityBalance -= _amount;
391             totalCharitySent += _amount;
392             emit charityDonation(
393                     charityAddress,
394                     _charityName,
395                     _amount,
396                     now
397                 );
398         }
399     }
400     
401     function compareStrings (string a, string b) internal pure returns (bool){
402         return keccak256(a) == keccak256(b);
403     }
404 
405 }