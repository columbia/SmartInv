1 pragma solidity ^0.4.23;
2 
3 
4 contract Ownable {
5   address public owner;
6 
7   event OwnershipTransferred(
8     address indexed previousOwner,
9     address indexed newOwner
10   );
11 
12   /**
13    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
14    * account.
15    */
16   constructor() public {
17     owner = msg.sender;
18   }
19 
20   /**
21    * @dev Throws if called by any account other than the owner.
22    */
23   modifier onlyOwner() {
24     require(msg.sender == owner);
25     _;
26   }
27 
28   /**
29    * @dev Allows the current owner to transfer control of the contract to a newOwner.
30    * @param _newOwner The address to transfer ownership to.
31    */
32   function transferOwnership(address _newOwner) public onlyOwner {
33     _transferOwnership(_newOwner);
34   }
35 
36   /**
37    * @dev Transfers control of the contract to a newOwner.
38    * @param _newOwner The address to transfer ownership to.
39    */
40   function _transferOwnership(address _newOwner) internal {
41     require(_newOwner != address(0));
42     emit OwnershipTransferred(owner, _newOwner);
43     owner = _newOwner;
44   }
45 }
46 
47 
48 
49 contract Mortal is Ownable{
50     uint public stopTS;
51     uint public minimumWait = 1 hours;
52     bool public killed;
53 
54     /**
55      * keep people from joining games or initiating new ones
56      * */
57     function stopPlaying() public onlyOwner{
58         stopTS = now;
59     }
60 
61     /**
62      * kills the contract if enough time has passed. time to pass = twice the waiting time for withdrawal of funds of a running game.
63      * */
64     function kill() public onlyOwner{
65         require(stopTS > 0 && stopTS + 2 * minimumWait <= now, "before killing, playing needs to be stopped and sufficient time has to pass");
66         selfdestruct(owner);
67     }
68 
69     /**
70      * like killing, because playing will no longer be possible and funds are withdrawn, but keeps the data available on the blockchain
71      * (especially scores)
72      * */
73     function permaStop() public onlyOwner{
74         require(stopTS > 0 && stopTS + 2 * minimumWait <= now, "before killing, playing needs to be stopped and sufficient time has to pass");
75         killed = true;
76         owner.transfer(address(this).balance);
77     }
78 
79     /**
80      * resume playing. stops the killing preparation.
81      * */
82     function resumePlaying() public onlyOwner{
83         require(!killed, "killed contract cannot be reactivated");
84         stopTS = 0;
85     }
86 
87     /**
88      * don't allow certain functions if playing has been stopped
89      * */
90     modifier active(){
91         require(stopTS == 0, "playing has been stopped by the owner");
92         _;
93     }
94 }
95 
96 contract Administrable is Mortal{
97     /** the different pots */
98     uint public charityPot;
99     uint public highscorePot;
100     uint public affiliatePot;
101     uint public surprisePot;
102     uint public developerPot;
103     /** the Percentage of the game stake which go into a pot with one decimal (25 => 2.5%) */
104     uint public charityPercent = 25;
105     uint public highscorePercent = 50;
106     uint public affiliatePercent = 50;
107     uint public surprisePercent = 25;
108     uint public developerPercent = 50;
109     uint public winnerPercent = 800;
110     /** the current highscore holder **/
111     address public highscoreHolder;
112     address public signer;
113     /** balance of affiliate partners */
114     mapping (address => uint) public affiliateBalance;
115 
116     uint public minStake;
117     uint public maxStake;
118 
119     /** tells if a hash has already been used for withdrawal **/
120     mapping (bytes32 => bool) public used;
121     event Withdrawal(uint8 pot, address receiver, uint value);
122 
123     modifier validAddress(address receiver){
124         require(receiver != 0x0, "invalid receiver");
125         _;
126     }
127 
128 
129     /**
130      * set the minimum waiting time for withdrawal of funds of a started but not-finished game
131      * */
132     function setMinimumWait(uint newMin) public onlyOwner{
133         minimumWait = newMin;
134     }
135 
136     /**
137      * withdraw from the developer pot
138      * */
139     function withdrawDeveloperPot(address receiver) public onlyOwner validAddress(receiver){
140         uint value = developerPot;
141         developerPot = 0;
142         receiver.transfer(value);
143         emit Withdrawal(0, receiver, value);
144     }
145 
146     /**
147      * withdraw from the charity pot
148      * */
149     function donate(address charity) public onlyOwner validAddress(charity){
150         uint value = charityPot;
151         charityPot = 0;
152         charity.transfer(value);
153         emit Withdrawal(1, charity, value);
154     }
155 
156     /**
157      * withdraw from the highscorePot
158      * */
159     function withdrawHighscorePot(address receiver) public validAddress(receiver){
160         require(msg.sender == highscoreHolder);
161         uint value = highscorePot;
162         highscorePot = 0;
163         receiver.transfer(value);
164         emit Withdrawal(2, receiver, value);
165     }
166 
167     /**
168      * withdraw from the affiliate pot
169      * */
170     function withdrawAffiliateBalance(address receiver) public validAddress(receiver){
171         uint value = affiliateBalance[msg.sender];
172         require(value > 0);
173         affiliateBalance[msg.sender] = 0;
174         receiver.transfer(value);
175         emit Withdrawal(3, receiver, value);
176     }
177 
178     /**
179      * withdraw from the surprise pot
180      * */
181     function withdrawSurprisePot(address receiver) public onlyOwner validAddress(receiver){
182         uint value = surprisePot;
183         surprisePot = 0;
184         receiver.transfer(value);
185         emit Withdrawal(4, receiver, value);
186     }
187 
188     /**
189      * allows an user to withdraw from the surprise pot with a valid signature
190      * */
191     function withdrawSurprisePotUser(uint value, uint expiry, uint8 v, bytes32 r, bytes32 s) public{
192         require(expiry >= now, "signature expired");
193         bytes32 hash = keccak256(abi.encodePacked(msg.sender, value, expiry));
194         require(!used[hash], "same signature was used before");
195         require(ecrecover(hash, v, r, s) == signer, "invalid signer");
196         require(value <= surprisePot, "not enough in the pot");
197         surprisePot -= value;
198         used[hash] = true;
199         msg.sender.transfer(value);
200         emit Withdrawal(4, msg.sender, value);
201     }
202 
203     /**
204      * sets the signing address
205      * */
206     function setSigner(address signingAddress) public onlyOwner{
207         signer = signingAddress;
208     }
209 
210     /**
211      * sets the pot Percentages
212      * */
213     function setPercentages(uint affiliate, uint charity, uint dev, uint highscore, uint surprise) public onlyOwner{
214         uint sum =  affiliate + charity + highscore + surprise + dev;
215         require(sum < 500, "winner should not lose money");
216         charityPercent = charity;
217         affiliatePercent = affiliate;
218         highscorePercent = highscore;
219         surprisePercent = surprise;
220         developerPercent = dev;
221         winnerPercent = 1000 - sum;
222     }
223 
224     function setMinMax(uint newMin, uint newMax) public onlyOwner{
225         minStake = newMin;
226         maxStake = newMax;
227     }
228 }
229 
230 contract Etherman is Administrable{
231 
232     struct game{
233         uint32 timestamp;
234         uint128 stake;
235         address player1;
236         address player2;
237     }
238 
239     struct player{
240         uint8 team;
241         uint64 score;
242         address referrer;
243     }
244 
245     mapping (bytes12 => game) public games;
246     mapping (address => player) public players;
247 
248     event NewGame(bytes32 gameId, address player1, uint stake);
249     event GameStarted(bytes32 gameId, address player1, address player2, uint stake);
250     event GameDestroyed(bytes32 gameId);
251     event GameEnd(bytes32 gameId, address winner, uint value);
252     event NewHighscore(address holder, uint score, uint lastPot);
253 
254     modifier onlyHuman(){
255         require(msg.sender == tx.origin, "contract calling");
256         _;
257     }
258 
259     constructor(address signingAddress, uint min, uint max) public{
260         setSigner(signingAddress);
261         minStake = min;
262         maxStake = max;
263     }
264 
265     /**
266      * sets the referrer for the lifetime affiliate program and initiates a new game
267      * */
268     function initGameReferred(bytes12 gameId, address referrer, uint8 team) public payable active onlyHuman validAddress(referrer){
269         //new player which does not have a referrer set yet
270         if(players[msg.sender].referrer == 0x0 && players[msg.sender].score == 0)
271             players[msg.sender] = player(team, 0, referrer);
272         initGame(gameId);
273     }
274 
275     /**
276      * sets the team and initiates a game
277      * */
278     function initGameTeam(bytes12 gameId, uint8 team) public payable active onlyHuman {
279         if(players[msg.sender].score == 0)
280             players[msg.sender].team = team;
281         initGame(gameId);
282     }
283 
284     /**
285      * initiates a new game
286      * */
287     function initGame(bytes12 gameId) public payable active onlyHuman {
288         game storage cGame = games[gameId];
289         if(cGame.player1==0x0) _initGame(gameId);
290         else _joinGame(gameId);
291     }
292 
293     function _initGame(bytes12 gameId) internal {
294         require(msg.value <= maxStake, "stake needs to be lower than or equal to the max stake");
295         require(msg.value >= minStake, "stake needs to be at least the min stake");
296         require(games[gameId].stake == 0, "game with the given id already exists");
297         games[gameId] = game(uint32(now), uint128(msg.value), msg.sender, 0x0);
298         emit NewGame(gameId, msg.sender, msg.value);
299     }
300 
301     /**
302      * sets the referrer for the lifetime affiliate program and joins a game
303      * */
304     function joinGameReferred(bytes12 gameId, address referrer, uint8 team) public payable active onlyHuman validAddress(referrer){
305         //new player which does not have a referrer set yet
306         if(players[msg.sender].referrer == 0x0 && players[msg.sender].score == 0)
307             players[msg.sender] = player(team, 0, referrer);
308         joinGame(gameId);
309     }
310 
311     /**
312      * sets the team and joins a game
313      * */
314     function joinGameTeam(bytes12 gameId, uint8 team) public payable active onlyHuman{
315         if(players[msg.sender].score == 0)
316             players[msg.sender].team = team;
317         joinGame(gameId);
318     }
319 
320     /**
321      * join a game
322      * */
323     function joinGame(bytes12 gameId) public payable active onlyHuman{
324         game storage cGame = games[gameId];
325         if(cGame.player1==0x0) _initGame(gameId);
326         else _joinGame(gameId);
327 
328     }
329 
330     function _joinGame(bytes12 gameId) internal {
331         game storage cGame = games[gameId];
332         require(cGame.player1 != msg.sender, "cannot play with one self");
333         require(msg.value >= cGame.stake, "value does not suffice to join the game");
334         cGame.player2 = msg.sender;
335         cGame.timestamp = uint32(now);
336         emit GameStarted(gameId, cGame.player1, msg.sender, cGame.stake);
337         if(msg.value > cGame.stake) developerPot += msg.value - cGame.stake;
338     }
339 
340     /**
341      * withdraw from the game stake in case no second player joined or the game was not ended within the
342      * minimum waiting time
343      * */
344     function withdraw(bytes12 gameId) public onlyHuman{
345         game storage cGame = games[gameId];
346         uint128 value = cGame.stake;
347         if(msg.sender == cGame.player1){
348             if(cGame.player2 == 0x0){
349                 delete games[gameId];
350                 msg.sender.transfer(value);
351             }
352             else if(cGame.timestamp + minimumWait <= now){
353                 address player2 = cGame.player2;
354                 delete games[gameId];
355                 msg.sender.transfer(value);
356                 player2.transfer(value);
357             }
358             else{
359                 revert("minimum waiting time has not yet passed");
360             }
361         }
362         else if(msg.sender == cGame.player2){
363             if(cGame.timestamp + minimumWait <= now){
364                 address player1 = cGame.player1;
365                 delete games[gameId];
366                 msg.sender.transfer(value);
367                 player1.transfer(value);
368             }
369             else{
370                 revert("minimum waiting time has not yet passed");
371             }
372         }
373         else{
374             revert("sender is not a player in this game");
375         }
376         emit GameDestroyed(gameId);
377     }
378 
379     /**
380      * The winner can claim his winnings, only with a signature from a contract owners allowed address.
381      * the pot is distributed amongst the winner, the developers, the affiliate partner, a charity and the surprise pot
382      * */
383     function claimWin(bytes12 gameId, uint8 v, bytes32 r, bytes32 s) public onlyHuman{
384         game storage cGame = games[gameId];
385         require(cGame.player2!=0x0, "game has not started yet");
386         require(msg.sender == cGame.player1 || msg.sender == cGame.player2, "sender is not a player in this game");
387         require(ecrecover(keccak256(abi.encodePacked(gameId, msg.sender)), v, r, s) == signer, "invalid signature");
388         uint256 value = 2*cGame.stake;
389         uint256 win = winnerPercent * value / 1000;
390         addScore(msg.sender, cGame.stake);
391         delete games[gameId];
392         charityPot += value * charityPercent / 1000;
393         //players of the leading team do not pay tributes
394         if(players[highscoreHolder].team == players[msg.sender].team){
395             win += value * highscorePercent / 1000;
396         }
397         else{
398             highscorePot += value * highscorePercent / 1000;
399         }
400         surprisePot += value * surprisePercent / 1000;
401         if(players[msg.sender].referrer == 0x0){
402             developerPot += value * (developerPercent + affiliatePercent) / 1000;
403         }
404         else{
405             developerPot += value * developerPercent / 1000;
406             affiliateBalance[players[msg.sender].referrer] += value * affiliatePercent / 1000;
407         }
408         msg.sender.transfer(win);//no overflow possible because stake is <= max uint128, but now we have 256 bit
409         emit GameEnd(gameId, msg.sender, win);
410     }
411 
412     /**
413      * adds the score to the player.
414      * computed by ceiling(60x/(x+100))
415      * 20% bonus points if the winner does not belong to the leading team. minimum 1 point extra.
416      * */
417     function addScore(address receiver, uint stake) private{
418         player storage rec = players[receiver];
419         player storage hsh = players[highscoreHolder];
420         uint64 x = uint64(stake/(10 finney));
421         uint64 score = (61 * x + 100) / ( x + 100); //adding +1 to the formula above to be able to round up
422         if(rec.team != hsh.team){
423             uint64 extra = score * 25 / 100;
424             if (extra == 0) extra = 1;
425             score += extra;
426         }
427         rec.score += score;
428         if(rec.score > hsh.score){
429             uint pot = highscorePot;
430             if(pot > 0){
431                 highscorePot = 0;
432                 highscoreHolder.transfer(pot);
433             }
434             highscoreHolder = receiver;
435             emit NewHighscore(receiver, rec.score, pot);
436         }
437     }
438 
439     /**
440      * any directly sent ETH are considered a donation for development
441      * */
442     function() public payable{
443         developerPot+=msg.value;
444     }
445 
446     /**
447      * sets the score of an user. only after contract update.
448      * */
449      function setScore(address user, uint64 score, uint8 team) public onlyOwner{
450           players[user].score = score;
451           players[user].team = team;
452       }
453 
454 }