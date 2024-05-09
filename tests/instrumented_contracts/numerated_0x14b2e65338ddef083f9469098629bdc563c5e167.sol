1 pragma solidity ^0.4.23;
2 
3 contract Ownable {
4   address public owner;
5 
6   event OwnershipTransferred(
7     address indexed previousOwner,
8     address indexed newOwner
9   );
10 
11   /**
12    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
13    * account.
14    */
15   constructor() public {
16     owner = msg.sender;
17   }
18 
19   /**
20    * @dev Throws if called by any account other than the owner.
21    */
22   modifier onlyOwner() {
23     require(msg.sender == owner);
24     _;
25   }
26 
27   /**
28    * @dev Allows the current owner to transfer control of the contract to a newOwner.
29    * @param _newOwner The address to transfer ownership to.
30    */
31   function transferOwnership(address _newOwner) public onlyOwner {
32     _transferOwnership(_newOwner);
33   }
34 
35   /**
36    * @dev Transfers control of the contract to a newOwner.
37    * @param _newOwner The address to transfer ownership to.
38    */
39   function _transferOwnership(address _newOwner) internal {
40     require(_newOwner != address(0));
41     emit OwnershipTransferred(owner, _newOwner);
42     owner = _newOwner;
43   }
44 }
45 
46 
47 contract Mortal is Ownable{
48     uint public stopTS;
49     uint public minimumWait = 1 hours;
50     bool public killed;
51 
52     /**
53      * keep people from joining games or initiating new ones
54      * */
55     function stopPlaying() public onlyOwner{
56         stopTS = now;
57     }
58 
59     /**
60      * kills the contract if enough time has passed. time to pass = twice the waiting time for withdrawal of funds of a running game.
61      * */
62     function kill() public onlyOwner{
63         require(stopTS > 0 && stopTS + 2 * minimumWait <= now, "before killing, playing needs to be stopped and sufficient time has to pass");
64         selfdestruct(owner);
65     }
66 
67     /**
68      * like killing, because playing will no longer be possible and funds are withdrawn, but keeps the data available on the blockchain
69      * (especially scores)
70      * */
71     function permaStop() public onlyOwner{
72         require(stopTS > 0 && stopTS + 2 * minimumWait <= now, "before killing, playing needs to be stopped and sufficient time has to pass");
73         killed = true;
74         owner.transfer(address(this).balance);
75     }
76 
77     /**
78      * resume playing. stops the killing preparation.
79      * */
80     function resumePlaying() public onlyOwner{
81         require(!killed, "killed contract cannot be reactivated");
82         stopTS = 0;
83     }
84 
85     /**
86      * don't allow certain functions if playing has been stopped
87      * */
88     modifier active(){
89         require(stopTS == 0, "playing has been stopped by the owner");
90         _;
91     }
92 }
93 
94 contract Administrable is Mortal{
95     /** the different pots */
96     uint public charityPot;
97     uint public highscorePot;
98     uint public affiliatePot;
99     uint public surprisePot;
100     uint public developerPot;
101     /** the Percentage of the game stake which go into a pot with one decimal (25 => 2.5%) */
102     uint public charityPercent = 25;
103     uint public highscorePercent = 50;
104     uint public affiliatePercent = 50;
105     uint public surprisePercent = 25;
106     uint public developerPercent = 50;
107     uint public winnerPercent = 800;
108     /** the current highscore holder **/
109     address public highscoreHolder;
110     address public signer;
111     /** balance of affiliate partners */
112     mapping (address => uint) public affiliateBalance;
113     /** tells if a hash has already been used for withdrawal **/
114     mapping (bytes32 => bool) public used;
115     event Withdrawal(uint8 pot, address receiver, uint value);
116 
117     modifier validAddress(address receiver){
118         require(receiver != 0x0, "invalid receiver");
119         _;
120     }
121 
122 
123     /**
124      * set the minimum waiting time for withdrawal of funds of a started but not-finished game
125      * */
126     function setMinimumWait(uint newMin) public onlyOwner{
127         minimumWait = newMin;
128     }
129 
130     /**
131      * withdraw from the developer pot
132      * */
133     function withdrawDeveloperPot(address receiver) public onlyOwner validAddress(receiver){
134         uint value = developerPot;
135         developerPot = 0;
136         receiver.transfer(value);
137         emit Withdrawal(0, receiver, value);
138     }
139 
140     /**
141      * withdraw from the charity pot
142      * */
143     function donate(address charity) public onlyOwner validAddress(charity){
144         uint value = charityPot;
145         charityPot = 0;
146         charity.transfer(value);
147         emit Withdrawal(1, charity, value);
148     }
149 
150     /**
151      * withdraw from the highscorePot
152      * */
153     function withdrawHighscorePot(address receiver) public validAddress(receiver){
154         require(msg.sender == highscoreHolder);
155         uint value = highscorePot;
156         highscorePot = 0;
157         receiver.transfer(value);
158         emit Withdrawal(2, receiver, value);
159     }
160 
161     /**
162      * withdraw from the affiliate pot
163      * */
164     function withdrawAffiliateBalance(address receiver) public validAddress(receiver){
165         uint value = affiliateBalance[msg.sender];
166         require(value > 0);
167         affiliateBalance[msg.sender] = 0;
168         receiver.transfer(value);
169         emit Withdrawal(3, receiver, value);
170     }
171 
172     /**
173      * withdraw from the surprise pot
174      * */
175     function withdrawSurprisePot(address receiver) public onlyOwner validAddress(receiver){
176         uint value = surprisePot;
177         surprisePot = 0;
178         receiver.transfer(value);
179         emit Withdrawal(4, receiver, value);
180     }
181 
182     /**
183      * allows an user to withdraw from the surprise pot with a valid signature
184      * */
185     function withdrawSurprisePotUser(uint value, uint expiry, uint8 v, bytes32 r, bytes32 s) public{
186         require(expiry >= now, "signature expired");
187         bytes32 hash = keccak256(abi.encodePacked(msg.sender, value, expiry));
188         require(!used[hash], "same signature was used before");
189         require(ecrecover(hash, v, r, s) == signer, "invalid signer");
190         require(value <= surprisePot, "not enough in the pot");
191         surprisePot -= value;
192         used[hash] = true;
193         msg.sender.transfer(value);
194         emit Withdrawal(4, msg.sender, value);
195     }
196 
197     /**
198      * sets the signing address
199      * */
200     function setSigner(address signingAddress) public onlyOwner{
201         signer = signingAddress;
202     }
203 
204     /**
205      * sets the pot Percentages
206      * */
207     function setPercentages(uint affiliate, uint charity, uint dev, uint highscore, uint surprise) public onlyOwner{
208         uint sum =  affiliate + charity + highscore + surprise + dev;
209         require(sum < 500, "winner should not lose money");
210         charityPercent = charity;
211         affiliatePercent = affiliate;
212         highscorePercent = highscore;
213         surprisePercent = surprise;
214         developerPercent = dev;
215         winnerPercent = 1000 - sum;
216     }
217 }
218 
219 contract Etherman is Administrable{
220 
221     struct game{
222         uint32 timestamp;
223         uint128 stake;
224         address player1;
225         address player2;
226     }
227 
228     struct player{
229         uint8 team;
230         uint64 score;
231         address referrer;
232     }
233 
234     mapping (bytes32 => game) public games;
235     mapping (address => player) public players;
236 
237     event NewGame(bytes32 gameId, address player1, uint stake);
238     event GameStarted(bytes32 gameId, address player1, address player2, uint stake);
239     event GameDestroyed(bytes32 gameId);
240     event GameEnd(bytes32 gameId, address winner, uint value);
241     event NewHighscore(address holder, uint score, uint lastPot);
242 
243     modifier onlyHuman(){
244         require(msg.sender == tx.origin, "contract calling");
245         _;
246     }
247 
248     constructor(address signingAddress) public{
249         setSigner(signingAddress);
250     }
251 
252     /**
253      * sets the referrer for the lifetime affiliate program and initiates a new game
254      * */
255     function initGameReferred(address referrer, uint8 team) public payable active onlyHuman validAddress(referrer){
256         //new player which does not have a referrer set yet
257         if(players[msg.sender].referrer == 0x0 && players[msg.sender].score == 0)
258             players[msg.sender] = player(team, 0, referrer);
259         initGame();
260     }
261 
262     /**
263      * sets the team and initiates a game
264      * */
265     function initGameTeam(uint8 team) public payable active onlyHuman{
266         if(players[msg.sender].score == 0)
267             players[msg.sender].team = team;
268         initGame();
269     }
270 
271     /**
272      * initiates a new game
273      * */
274     function initGame() public payable active onlyHuman{
275         require(msg.value <= 10 ether, "stake needs to be lower than or equal to 10 ether");
276         require(msg.value > 1 finney, "stake needs to be at least 1 finney");
277         bytes32 gameId = keccak256(abi.encodePacked(msg.sender, block.number));
278         games[gameId] = game(uint32(now), uint128(msg.value), msg.sender, 0x0);
279         emit NewGame(gameId, msg.sender, msg.value);
280     }
281 
282     /**
283      * sets the referrer for the lifetime affiliate program and joins a game
284      * */
285     function joinGameReferred(bytes32 gameId, address referrer, uint8 team) public payable active onlyHuman validAddress(referrer){
286         //new player which does not have a referrer set yet
287         if(players[msg.sender].referrer == 0x0 && players[msg.sender].score == 0)
288             players[msg.sender] = player(team, 0, referrer);
289         joinGame(gameId);
290     }
291 
292     /**
293      * sets the team and joins a game
294      * */
295     function joinGameTeam(bytes32 gameId, uint8 team) public payable active onlyHuman{
296         if(players[msg.sender].score == 0)
297             players[msg.sender].team = team;
298         joinGame(gameId);
299     }
300 
301     /**
302      * join a game
303      * */
304     function joinGame(bytes32 gameId) public payable active onlyHuman{
305         game storage cGame = games[gameId];
306         require(cGame.player1!=0x0, "game id unknown");
307         require(cGame.player1 != msg.sender, "cannot play with one self");
308         require(msg.value >= cGame.stake, "value does not suffice to join the game");
309         cGame.player2 = msg.sender;
310         cGame.timestamp = uint32(now);
311         emit GameStarted(gameId, cGame.player1, msg.sender, cGame.stake);
312         if(msg.value > cGame.stake) developerPot += msg.value - cGame.stake;
313     }
314 
315     /**
316      * withdraw from the game stake in case no second player joined or the game was not ended within the
317      * minimum waiting time
318      * */
319     function withdraw(bytes32 gameId) public onlyHuman{
320         game storage cGame = games[gameId];
321         uint128 value = cGame.stake;
322         if(msg.sender == cGame.player1){
323             if(cGame.player2 == 0x0){
324                 delete games[gameId];
325                 msg.sender.transfer(value);
326             }
327             else if(cGame.timestamp + minimumWait <= now){
328                 address player2 = cGame.player2;
329                 delete games[gameId];
330                 msg.sender.transfer(value);
331                 player2.transfer(value);
332             }
333             else{
334                 revert("minimum waiting time has not yet passed");
335             }
336         }
337         else if(msg.sender == cGame.player2){
338             if(cGame.timestamp + minimumWait <= now){
339                 address player1 = cGame.player1;
340                 delete games[gameId];
341                 msg.sender.transfer(value);
342                 player1.transfer(value);
343             }
344             else{
345                 revert("minimum waiting time has not yet passed");
346             }
347         }
348         else{
349             revert("sender is not a player in this game");
350         }
351         emit GameDestroyed(gameId);
352     }
353 
354     /**
355      * The winner can claim his winnings, only with a signature from the contract owner.
356      * the pot is distributed amongst the winner, the developers, the affiliate partner, a charity and the surprise pot
357      * */
358     function claimWin(bytes32 gameId, uint8 v, bytes32 r, bytes32 s) public onlyHuman{
359         game storage cGame = games[gameId];
360         require(cGame.player2!=0x0, "game has not started yet");
361         require(msg.sender == cGame.player1 || msg.sender == cGame.player2, "sender is not a player in this game");
362         require(ecrecover(keccak256(abi.encodePacked(gameId, msg.sender)), v, r, s) == signer, "invalid signature");
363         uint256 value = 2*cGame.stake;
364         uint256 win = winnerPercent * value / 1000;
365         addScore(msg.sender, cGame.stake);
366         delete games[gameId];
367         charityPot += value * charityPercent / 1000;
368         //players of the leading team do not pay tributes
369         if(players[highscoreHolder].team == players[msg.sender].team){
370             win += value * highscorePercent / 1000;
371         }
372         else{
373             highscorePot += value * highscorePercent / 1000;
374         }
375         surprisePot += value * surprisePercent / 1000;
376         if(players[msg.sender].referrer == 0x0){
377             developerPot += value * (developerPercent + affiliatePercent) / 1000;
378         }
379         else{
380             developerPot += value * developerPercent / 1000;
381             affiliateBalance[players[msg.sender].referrer] += value * affiliatePercent / 1000;
382         }
383         msg.sender.transfer(win);//no overflow possible because stake is <= max uint128, but now we have 256 bit
384         emit GameEnd(gameId, msg.sender, win);
385     }
386 
387     function addScore(address receiver, uint stake) private{
388         player storage rec = players[receiver];
389         player storage hsh = players[highscoreHolder];
390         if(rec.team == hsh.team){
391             if(stake < 0.05 ether) rec.score += 1;
392             else if(stake < 0.5 ether) rec.score += 5;
393             else rec.score += 10;
394         }
395         else{//extra points if not belonging to the highscore team
396             if(stake < 0.05 ether) rec.score += 2;
397             else if(stake < 0.5 ether) rec.score += 7;
398             else rec.score += 13;
399         }
400         if(rec.score > hsh.score){
401             uint pot = highscorePot;
402             if(pot > 0){
403                 highscorePot = 0;
404                 highscoreHolder.transfer(pot);
405             }
406             highscoreHolder = receiver;
407             emit NewHighscore(receiver, rec.score, pot);
408         }
409     }
410 
411     /**
412      * any directly sent ETH are considered a donation for development
413      * */
414     function() public payable{
415         developerPot+=msg.value;
416     }
417     
418     function doNothing(){
419         
420     }
421 
422 }