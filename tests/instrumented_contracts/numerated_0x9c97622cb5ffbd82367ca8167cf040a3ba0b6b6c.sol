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
34 
35 contract Win1Million {
36     
37     using SafeMath for uint256;
38     
39     address owner;
40     address bankAddress;
41     
42     bool gamePaused = false;
43     uint256 public houseEdge = 5;
44     uint256 public bankBalance;
45     uint256 public minGamePlayAmount = 30000000000000000;
46     
47     modifier onlyOwner() {
48         require(owner == msg.sender);
49         _;
50     }
51     modifier onlyBanker() {
52         require(bankAddress == msg.sender);
53         _;
54     }
55     modifier whenNotPaused() {
56         require(gamePaused == false);
57         _;
58     }
59     modifier correctAnswers(uint256 barId, string _answer1, string _answer2, string _answer3) {
60         require(compareStrings(gameBars[barId].answer1, _answer1));
61         require(compareStrings(gameBars[barId].answer2, _answer2));
62         require(compareStrings(gameBars[barId].answer3, _answer3));
63         _;
64     }
65     
66     struct Bar {
67         uint256     Limit;          // max amount of wei for this gamePaused
68         uint256     CurrentGameId;
69         string      answer1;
70         string      answer2;
71         string      answer3;
72     }
73     
74     struct Game {
75         uint256                         BarId;
76         uint256                         CurrentTotal;
77         mapping(address => uint256)     PlayerBidMap;
78         address[]                       PlayerAddressList;
79     }
80     
81     struct Winner {
82         address     winner;
83         uint256     amount;
84         uint256     timestamp;
85         uint256     barId;
86         uint256     gameId;
87     }
88 
89     Bar[]       public  gameBars;
90     Game[]      public  games;
91     Winner[]    public  winners;
92     
93     mapping (address => uint256) playerPendingWithdrawals;
94     
95     function getWinnersLen() public view returns(uint256) {
96         return winners.length;
97     }
98     
99     // helper function so we can extrat list of all players at the end of each game...
100     function getGamesPlayers(uint256 gameId) public view returns(address[]){
101         return games[gameId].PlayerAddressList;
102     }
103     // and then enumerate through them and get their respective bids...
104     function getGamesPlayerBids(uint256 gameId, address playerAddress) public view returns(uint256){
105         return games[gameId].PlayerBidMap[playerAddress];
106     }
107     
108     constructor() public {
109         owner = msg.sender;
110         bankAddress = owner;
111         
112         // ensure we are above gameBars[0] 
113         gameBars.push(Bar(0,0,"","",""));
114         
115         // and for games[0]
116         address[] memory _addressList;
117         games.push(Game(0,0,_addressList));
118         
119     }
120     
121     event uintEvent(
122         uint256 eventUint
123         );
124         
125     event gameComplete(
126         uint256 gameId
127         );
128         
129 
130     // Should only be used on estimate gas to check if the players bid
131     // will be acceptable and not be over the game limit...
132     // Should not be used to send Ether!
133     function playGameCheckBid(uint256 barId) public whenNotPaused payable {
134         uint256 houseAmt = (msg.value.div(100)).mul(houseEdge);
135         uint256 gameAmt = (msg.value.div(100)).mul(100-houseEdge);
136         uint256 currentGameId = gameBars[barId].CurrentGameId;
137         //emit uintEvent(gameAmt);
138         //emit uintEvent(gameBars[barId].CurrentGameId);
139         //emit uintEvent(games[currentGameId].CurrentTotal);
140         //emit uintEvent(games[currentGameId].CurrentTotal.add(gameAmt));
141         //emit uintEvent(gameBars[barId].Limit);
142         
143         if(gameBars[barId].CurrentGameId == 0) {
144             if(gameAmt > gameBars[barId].Limit) {
145                 // gameAmt must be min bet only!
146                 require(msg.value == minGamePlayAmount);
147             }
148             //require(gameAmt <= gameBars[barId].Limit);
149             
150         } else {
151             currentGameId = gameBars[barId].CurrentGameId;
152             require(games[currentGameId].BarId > 0); // Ensure it hasn't been closed already
153             if(games[currentGameId].CurrentTotal.add(gameAmt) > gameBars[barId].Limit) {
154                 // gameAmt must be min bet only!
155                 require(msg.value == minGamePlayAmount);
156             }
157             //require(games[currentGameId].CurrentTotal.add(gameAmt) <= gameBars[barId].Limit); // Can't over bid = game full and closing
158         }
159 
160     }
161 
162     
163     // houseEdge goes to bankBalance, rest goes into game pot...
164     // answers submitted encrypted from website but can be replayed by users - issue?
165     // present as:
166     // Q1: What color are often the domes of churches in Russia?
167     // Q2: What is the national animal of Albania?
168     // Q3: How many oscars did the Titanic movie win?
169     // Solve the above questions or decipher the answers from the blockchain!
170     // https://www.quiz-questions.net/film.php
171     function playGame(uint256 barId,
172             string _answer1, string _answer2, string _answer3) public 
173             whenNotPaused 
174             correctAnswers(barId, _answer1, _answer2, _answer3) 
175             payable {
176         require(msg.value >= minGamePlayAmount);
177         
178         // check if a game is in play for this bar...
179         uint256 houseAmt = (msg.value.div(100)).mul(houseEdge);
180         uint256 gameAmt = (msg.value.div(100)).mul(100-houseEdge);
181         uint256 currentGameId = 0;
182         
183         
184         if(gameBars[barId].CurrentGameId == 0) {
185             
186             //require(gameAmt <= gameBars[barId].Limit); // Can't over bid = game full and closing
187             if(gameAmt > gameBars[barId].Limit) {
188                 // gameAmt must be min bet only!
189                 require(msg.value == minGamePlayAmount);
190             }
191             
192             // create new game...
193             address[] memory _addressList;
194             games.push(Game(barId, gameAmt, _addressList));
195             currentGameId = games.length-1;
196             
197             gameBars[barId].CurrentGameId = currentGameId;
198             
199         } else {
200             currentGameId = gameBars[barId].CurrentGameId;
201             require(games[currentGameId].BarId > 0); // Ensure it hasn't been closed already
202             if(games[currentGameId].CurrentTotal.add(gameAmt) > gameBars[barId].Limit) {
203                 // gameAmt must be min bet only!
204                 require(msg.value == minGamePlayAmount);
205             }
206             //require(games[currentGameId].CurrentTotal.add(gameAmt) <= gameBars[barId].Limit); // Can't over bid = game full and closing
207             
208             games[currentGameId].CurrentTotal = games[currentGameId].CurrentTotal.add(gameAmt);    
209         }
210         
211         
212         
213         if(games[currentGameId].PlayerBidMap[msg.sender] == 0) {
214             // Add to the PlayerAddressList...
215             // Above check avoids duplicates
216             games[currentGameId].PlayerAddressList.push(msg.sender);
217         }
218         
219         // Increase the player bid map...
220         games[currentGameId].PlayerBidMap[msg.sender] = games[currentGameId].PlayerBidMap[msg.sender].add(gameAmt);
221         
222         // Increase bankBalance...
223         bankBalance+=houseAmt;
224         
225         // is the game complete??
226         if(games[currentGameId].CurrentTotal >= gameBars[barId].Limit) {
227 
228             emit gameComplete(gameBars[barId].CurrentGameId);
229             gameBars[barId].CurrentGameId = 0;
230         }
231         
232         
233     }
234     event completeGameResult(
235             uint256 indexed gameId,
236             uint256 indexed barId,
237             uint256 winningNumber,
238             string  proof,
239             address winnersAddress,
240             uint256 winningAmount,
241             uint256 timestamp
242         );
243     
244     // using NotaryProxy to generate random numbers with proofs stored in logs so they can be traced back
245     // publish list of players addresses - random number selection (With proof) and then how it was selected
246     
247     function completeGame(uint256 gameId, uint256 _winningNumber, string _proof, address winner) public onlyOwner {
248 
249 
250         
251         if(!winner.send(games[gameId].CurrentTotal)){
252             // need to add to a retry list...
253             
254             playerPendingWithdrawals[winner] = playerPendingWithdrawals[winner].add(games[gameId].CurrentTotal);
255         }
256         
257         // Add to the winners array...
258         winners.push(Winner(
259                 winner,
260                 games[gameId].CurrentTotal,
261                 now,
262                 games[gameId].BarId,
263                 gameId
264             ));
265         
266         emit completeGameResult(
267                 gameId,
268                 games[gameId].BarId,
269                 _winningNumber,
270                 _proof,
271                 winner,
272                 games[gameId].CurrentTotal,
273                 now
274             );
275         
276         // reset the bar state...
277         gameBars[games[gameId].BarId].CurrentGameId = 0;
278         // delete the game 
279         //delete games[gameId];
280         
281 
282         
283     }
284     
285     event cancelGame(
286             uint256 indexed gameId,
287             uint256 indexed barId,
288             uint256 amountReturned,
289             address playerAddress
290             
291         );
292     // players can cancel their participation in a game as long as it hasn't completed
293     // they lose their houseEdge fee (And pay any gas of course)
294     function player_cancelGame(uint256 barId) public {
295         address _playerAddr = msg.sender;
296         uint256 _gameId = gameBars[barId].CurrentGameId;
297         uint256 _gamePlayerBalance = games[_gameId].PlayerBidMap[_playerAddr];
298         
299         if(_gamePlayerBalance > 0){
300             // reset player bid amount
301             games[_gameId].PlayerBidMap[_playerAddr] = 1; // set to 1 wei to avoid duplicates
302             games[_gameId].CurrentTotal -= _gamePlayerBalance;
303             
304             if(!_playerAddr.send(_gamePlayerBalance)){
305                 // need to add to a retry list...
306                 playerPendingWithdrawals[_playerAddr] = playerPendingWithdrawals[_playerAddr].add(_gamePlayerBalance);
307             } 
308         } 
309         
310         emit cancelGame(
311             _gameId,
312             barId,
313             _gamePlayerBalance,
314             _playerAddr
315             );
316     }
317     
318     
319     function player_withdrawPendingTransactions() public
320         returns (bool)
321      {
322         uint withdrawAmount = playerPendingWithdrawals[msg.sender];
323         playerPendingWithdrawals[msg.sender] = 0;
324 
325         if (msg.sender.call.value(withdrawAmount)()) {
326             return true;
327         } else {
328             /* if send failed revert playerPendingWithdrawals[msg.sender] = 0; */
329             /* player can try to withdraw again later */
330             playerPendingWithdrawals[msg.sender] = withdrawAmount;
331             return false;
332         }
333     }
334     // wei: 1000000000000000000
335     // to 100 = / 10000000000000000 (16 zeros)
336     
337 /*
338     function _generate_seed(uint256 _gameId) internal view returns(uint256) {
339         bytes32 _hash;
340         for(uint256 c = 0; c < games[_gameId].PlayerAddressList.length; c++) {
341             _hash = keccak256(_hash, games[_gameId].PlayerAddressList[c]);
342         }
343         return bytes32ToUInt256(_hash);
344     }
345 */
346 
347     uint256 internal gameOpUint;
348     function gameOp() public returns(uint256) {
349         return gameOpUint;
350     }
351     function private_SetPause(bool _gamePaused) public onlyOwner {
352         gamePaused = _gamePaused;
353     }
354     // 10=9.5/ $3800 Eth pot = 0.5 eth = $200
355     // 20=19/ $7600 eth pot = 1 eth $400
356     // 100=975.5/ $39,000 eth pot = 2.5 eth $1000
357     // 200=190/ $76,000 eth pot = 10 eth =  $4000
358     // 500=475/ $190,000 eth pot = 25 eth = $10k
359     // winnings @ $400/eth
360     // 
361 
362     function private_AddGameBar(uint256 _limit, 
363                     string _answer1, string _answer2, string _answer3) public onlyOwner {
364 
365         gameBars.push(Bar(_limit, 0, _answer1, _answer2, _answer3));
366         emit uintEvent(gameBars.length);
367     }
368     function private_DelGameBar(uint256 barId) public onlyOwner {
369         if(gameBars[barId].CurrentGameId > 0){
370             delete games[gameBars[barId].CurrentGameId];
371         }
372         delete gameBars[barId];
373     }
374 
375     // Used to rebalance a game when the ETH/USD rate changes
376     function private_UpdateGameBarLimit(uint256 barId, uint256 _limit) public onlyOwner {
377         gameBars[barId].Limit = _limit;
378     }
379     function private_setHouseEdge(uint256 _houseEdge) public onlyOwner {
380         houseEdge = _houseEdge;
381     }
382     function private_setMinGamePlayAmount(uint256 _minGamePlayAmount) onlyOwner {
383         minGamePlayAmount = _minGamePlayAmount;
384     }
385     function private_setBankAddress(address _bankAddress) public onlyOwner {
386         bankAddress = _bankAddress;
387     }
388     function private_withdrawBankFunds(address _whereTo) public onlyBanker {
389         if(_whereTo.send(bankBalance)) {
390             bankBalance = 0;
391         }
392     }
393     function private_withdrawBankFunds(address _whereTo, uint256 _amount) public onlyBanker {
394         if(_whereTo.send(_amount)){
395             bankBalance-=_amount;
396         }
397     }
398     function private_kill() public onlyOwner {
399         selfdestruct(owner);
400     }
401     
402     
403     function compareStrings (string a, string b) internal pure returns (bool){
404         return keccak256(a) == keccak256(b);
405     }
406 
407 }