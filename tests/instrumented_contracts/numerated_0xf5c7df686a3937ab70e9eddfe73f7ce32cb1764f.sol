1 pragma solidity ^0.4.22;
2 
3 pragma solidity ^0.4.22;
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
10         uint256 c = a * b;
11         assert(a == 0 || c / a == b);
12         return c;
13     }
14 
15     function div(uint256 a, uint256 b) internal pure returns (uint256) {
16         // assert(b > 0); // Solidity automatically throws when dividing by 0
17         uint256 c = a / b;
18         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
19         return c;
20     }
21 
22     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
23         assert(b <= a);
24         return a - b;
25     }
26 
27     function add(uint256 a, uint256 b) internal pure returns (uint256) {
28         uint256 c = a + b;
29         assert(c >= a);
30         return c;
31     }
32 }
33 
34 contract Win1Million {
35     
36     using SafeMath for uint256;
37     
38     address owner;
39     address bankAddress;
40     
41     bool gamePaused = false;
42     uint256 public houseEdge = 5;
43     uint256 public bankBalance;
44     uint256 public minGamePlayAmount = 30000000000000000;
45     
46     modifier onlyOwner() {
47         require(owner == msg.sender);
48         _;
49     }
50     modifier onlyBanker() {
51         require(bankAddress == msg.sender);
52         _;
53     }
54     modifier whenNotPaused() {
55         require(gamePaused == false);
56         _;
57     }
58     modifier correctAnswers(uint256 barId, string _answer1, string _answer2, string _answer3) {
59         require(compareStrings(gameBars[barId].answer1, _answer1));
60         require(compareStrings(gameBars[barId].answer2, _answer2));
61         require(compareStrings(gameBars[barId].answer3, _answer3));
62         _;
63     }
64     
65     struct Bar {
66         uint256     Limit;          // max amount of wei for this game
67         uint256     CurrentGameId;
68         string      answer1;
69         string      answer2;
70         string      answer3;
71     }
72     
73     struct Game {
74         uint256                         BarId;
75         uint256                         CurrentTotal;
76         mapping(address => uint256)     PlayerBidMap;
77         address[]                       PlayerAddressList;
78     }
79     
80     struct Winner {
81         address     winner;
82         uint256     amount;
83         uint256     timestamp;
84         uint256     barId;
85         uint256     gameId;
86     }
87 
88     Bar[]       public  gameBars;
89     Game[]      public  games;
90     Winner[]    public  winners;
91     
92     mapping (address => uint256) playerPendingWithdrawals;
93     
94     function getWinnersLen() public view returns(uint256) {
95         return winners.length;
96     }
97     
98     // helper function so we can extrat list of all players at the end of each game...
99     function getGamesPlayers(uint256 gameId) public view returns(address[]){
100         return games[gameId].PlayerAddressList;
101     }
102     // and then enumerate through them and get their respective bids...
103     function getGamesPlayerBids(uint256 gameId, address playerAddress) public view returns(uint256){
104         return games[gameId].PlayerBidMap[playerAddress];
105     }
106     
107     constructor() public {
108         owner = msg.sender;
109         bankAddress = owner;
110         
111         // ensure we are above gameBars[0] 
112         gameBars.push(Bar(0,0,"","",""));
113         
114         // and for games[0]
115         address[] memory _addressList;
116         games.push(Game(0,0,_addressList));
117         
118     }
119     
120     event uintEvent(
121         uint256 eventUint
122         );
123         
124     event gameComplete(
125         uint256 gameId
126         );
127         
128 
129     // Should only be used on estimate gas to check if the players bid
130     // will be acceptable and not be over the game limit...
131     // Should not be used to send Ether!
132     function playGameCheckBid(uint256 barId) public whenNotPaused payable {
133         uint256 houseAmt = (msg.value.div(100)).mul(houseEdge);
134         uint256 gameAmt = (msg.value.div(100)).mul(100-houseEdge);
135         uint256 currentGameId = gameBars[barId].CurrentGameId;
136         
137         if(gameBars[barId].CurrentGameId == 0) {
138             if(gameAmt > gameBars[barId].Limit) {
139                 require(msg.value == minGamePlayAmount);
140             }
141             
142         } else {
143             currentGameId = gameBars[barId].CurrentGameId;
144             require(games[currentGameId].BarId > 0); // Ensure it hasn't been closed already
145             if(games[currentGameId].CurrentTotal.add(gameAmt) > gameBars[barId].Limit) {
146                 require(msg.value == minGamePlayAmount);
147             }
148 
149         }
150 
151     }
152 
153     function playGame(uint256 barId,
154             string _answer1, string _answer2, string _answer3) public 
155             whenNotPaused 
156             correctAnswers(barId, _answer1, _answer2, _answer3) 
157             payable {
158         require(msg.value >= minGamePlayAmount);
159         
160         // check if a game is in play for this bar...
161         uint256 houseAmt = (msg.value.div(100)).mul(houseEdge);
162         uint256 gameAmt = (msg.value.div(100)).mul(100-houseEdge);
163         uint256 currentGameId = 0;
164         
165         
166         if(gameBars[barId].CurrentGameId == 0) {
167             
168             if(gameAmt > gameBars[barId].Limit) {
169                 require(msg.value == minGamePlayAmount);
170             }
171             
172             address[] memory _addressList;
173             games.push(Game(barId, gameAmt, _addressList));
174             currentGameId = games.length-1;
175             
176             gameBars[barId].CurrentGameId = currentGameId;
177             
178         } else {
179             currentGameId = gameBars[barId].CurrentGameId;
180             require(games[currentGameId].BarId > 0); // Ensure it hasn't been closed already
181             if(games[currentGameId].CurrentTotal.add(gameAmt) > gameBars[barId].Limit) {
182                 require(msg.value == minGamePlayAmount);
183             }
184             
185             games[currentGameId].CurrentTotal = games[currentGameId].CurrentTotal.add(gameAmt);    
186         }
187         
188         
189         
190         if(games[currentGameId].PlayerBidMap[msg.sender] == 0) {
191             games[currentGameId].PlayerAddressList.push(msg.sender);
192         }
193         
194         games[currentGameId].PlayerBidMap[msg.sender] = games[currentGameId].PlayerBidMap[msg.sender].add(gameAmt);
195         
196         bankBalance+=houseAmt;
197         
198         if(games[currentGameId].CurrentTotal >= gameBars[barId].Limit) {
199 
200             emit gameComplete(gameBars[barId].CurrentGameId);
201             gameBars[barId].CurrentGameId = 0;
202         }
203         
204         
205     }
206     event completeGameResult(
207             uint256 indexed gameId,
208             uint256 indexed barId,
209             uint256 winningNumber,
210             string  proof,
211             address winnersAddress,
212             uint256 winningAmount,
213             uint256 timestamp
214         );
215     
216     // using NotaryProxy to generate random numbers with proofs stored in logs so they can be traced back
217     // publish list of players addresses - random number selection (With proof) and then how it was selected
218     
219     function completeGame(uint256 gameId, uint256 _winningNumber, string _proof, address winner) public onlyOwner {
220 
221 
222         
223         if(!winner.send(games[gameId].CurrentTotal)){
224             
225             playerPendingWithdrawals[winner] = playerPendingWithdrawals[winner].add(games[gameId].CurrentTotal);
226         }
227         
228 
229         winners.push(Winner(
230                 winner,
231                 games[gameId].CurrentTotal,
232                 now,
233                 games[gameId].BarId,
234                 gameId
235             ));
236         
237         emit completeGameResult(
238                 gameId,
239                 games[gameId].BarId,
240                 _winningNumber,
241                 _proof,
242                 winner,
243                 games[gameId].CurrentTotal,
244                 now
245             );
246         
247         // reset the bar state...
248         gameBars[games[gameId].BarId].CurrentGameId = 0;
249         
250 
251         
252     }
253     
254     event cancelGame(
255             uint256 indexed gameId,
256             uint256 indexed barId,
257             uint256 amountReturned,
258             address playerAddress
259             
260         );
261     // players can cancel their participation in a game as long as it hasn't completed
262     // they lose their houseEdge fee (And pay any gas of course)
263     function player_cancelGame(uint256 barId) public {
264         address _playerAddr = msg.sender;
265         uint256 _gameId = gameBars[barId].CurrentGameId;
266         uint256 _gamePlayerBalance = games[_gameId].PlayerBidMap[_playerAddr];
267         
268         if(_gamePlayerBalance > 0){
269             // reset player bid amount
270             games[_gameId].PlayerBidMap[_playerAddr] = 1; // set to 1 wei to avoid duplicates
271             games[_gameId].CurrentTotal -= _gamePlayerBalance;
272             
273             if(!_playerAddr.send(_gamePlayerBalance)){
274                 // need to add to a retry list...
275                 playerPendingWithdrawals[_playerAddr] = playerPendingWithdrawals[_playerAddr].add(_gamePlayerBalance);
276             } 
277         } 
278         
279         emit cancelGame(
280             _gameId,
281             barId,
282             _gamePlayerBalance,
283             _playerAddr
284             );
285     }
286     
287     
288     function player_withdrawPendingTransactions() public
289         returns (bool)
290      {
291         uint withdrawAmount = playerPendingWithdrawals[msg.sender];
292         playerPendingWithdrawals[msg.sender] = 0;
293 
294         if (msg.sender.call.value(withdrawAmount)()) {
295             return true;
296         } else {
297             /* if send failed revert playerPendingWithdrawals[msg.sender] = 0; */
298             /* player can try to withdraw again later */
299             playerPendingWithdrawals[msg.sender] = withdrawAmount;
300             return false;
301         }
302     }
303 
304 
305     uint256 internal gameOpUint;
306     function gameOp() public returns(uint256) {
307         return gameOpUint;
308     }
309     function private_SetPause(bool _gamePaused) public onlyOwner {
310         gamePaused = _gamePaused;
311     }
312 
313     function private_AddGameBar(uint256 _limit, 
314                     string _answer1, string _answer2, string _answer3) public onlyOwner {
315 
316         gameBars.push(Bar(_limit, 0, _answer1, _answer2, _answer3));
317         emit uintEvent(gameBars.length);
318     }
319     function private_DelGameBar(uint256 barId) public onlyOwner {
320         if(gameBars[barId].CurrentGameId > 0){
321             delete games[gameBars[barId].CurrentGameId];
322         }
323         delete gameBars[barId];
324     }
325 
326     // Used to rebalance a game when the ETH/USD rate changes
327     function private_UpdateGameBarLimit(uint256 barId, uint256 _limit) public onlyOwner {
328         gameBars[barId].Limit = _limit;
329     }
330     function private_setHouseEdge(uint256 _houseEdge) public onlyOwner {
331         houseEdge = _houseEdge;
332     }
333     function private_setMinGamePlayAmount(uint256 _minGamePlayAmount) onlyOwner {
334         minGamePlayAmount = _minGamePlayAmount;
335     }
336     function private_setBankAddress(address _bankAddress) public onlyOwner {
337         bankAddress = _bankAddress;
338     }
339     function private_withdrawBankFunds(address _whereTo) public onlyBanker {
340         if(_whereTo.send(bankBalance)) {
341             bankBalance = 0;
342         }
343     }
344     function private_withdrawBankFunds(address _whereTo, uint256 _amount) public onlyBanker {
345         if(_whereTo.send(_amount)){
346             bankBalance-=_amount;
347         }
348     }
349     
350     
351     function compareStrings (string a, string b) internal pure returns (bool){
352         return keccak256(a) == keccak256(b);
353     }
354 
355 }