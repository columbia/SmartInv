1 pragma solidity ^0.4.22;
2 
3 //TODO : Store Games in a Map instead of array. See if that has any advantages.
4 contract owned { 
5     address owner;
6     modifier onlyOwner()
7     {
8         require(msg.sender == owner);
9         _;
10     }
11 }
12 
13 contract priced {
14     modifier costs(uint256 price) {
15         require(msg.value >= price);
16         _;
17     }
18 }
19 
20 contract SplitStealContract is owned, priced {
21 
22     //Global Variables
23     uint constant STEAL = 0;
24     uint constant SPLIT = 1;
25     mapping(address=>bool) suspended;
26     mapping(address=>uint) totalGamesStarted;
27     mapping(address=>uint) totalGamesParticipated;   
28     uint256 contractEarnings = 0;
29     //Game Rules
30     uint256 REGISTRATION_COST = 10**14;// 0.0001 Ether //Editable by Owner
31     uint256 MINIMUM_COST_OF_BET = 10**17;// 0.1 Ether //Editable by Owner
32     uint256 MAXIMUM_COST_OF_BET = 5 * 10**18;//5 Ether //Editable by Owner
33     uint256 STAGE_TIMEOUT = 60*60*24*7;//1 Week
34 
35     //Reward Matrix Parameters
36     uint256 K = 25; //Editable by Owner
37 
38     //Events
39     event RegisterationOpened(uint indexed _gameNumber);
40     event RegisterationClosed(uint indexed _gameNumber);
41     event RevealStart(uint indexed _gameNumber);
42     event RevealStop(uint indexed _gameNumber);
43     event Transferred(uint indexed _gameNumber,address _to, uint256 _amount);
44     event ContractEarnings(uint indexed _gameNumber, uint256 _amount, string _reason);
45     event Disqualified(uint indexed _gameNumber, address indexed _player, bytes32 _encryptedChoice, uint _actualChoice, bytes32 _encryptedActualChoice);
46     event NewGameRules(uint _oldFees, uint _newFees, uint _oldMinBet, uint _newMinBet, uint _oldMaxBet, uint _newMaxBet, uint _oldStageTimeout, uint _newStageTimeout);
47     event NewRewardMatrix(uint _n1, uint _n2, uint _n3, uint _d);
48     event NewRewardPercentage(uint256 _oldK, uint256 _k);
49     event Suspended(address indexed _player);
50     event UnSuspended(address indexed _player);
51 
52     //BET Struct
53     struct Bet {
54         bytes32 encryptedChoice;
55         uint256 betAmount;
56         uint actualChoice;
57     }
58 
59     //GAME Struct
60     struct Game {
61         uint startTime;
62         uint revealTime;
63         uint finishTime;
64         address player1; 
65         address player2;
66         uint256 registrationCost;
67         uint256 k;
68         uint stageTimeout;
69         bool registerationOpen;
70         bool revealing;
71         bool lastGameFinished;
72         mapping(address=>address) opponent;
73         mapping(address=>bool) registered;
74         mapping(address=>Bet) bets;
75         mapping(address=>bool) revealed;
76         mapping(address=>bool) disqualified;
77         mapping(address=>bool) claimedReward;
78         mapping(address=>uint256) reward;
79     }
80     
81     Game[] games;
82 
83     constructor() public {
84         owner = msg.sender;
85     }   
86 
87     function fund() payable external {
88         contractEarnings = contractEarnings + msg.value;
89     }
90 
91     // UTILITY METHODS STARTS
92     function isEven(uint num) private pure returns(bool _isEven) {
93         uint halfNum = num / 2;
94         return (halfNum * 2) == num;
95     }
96     // UTILITY METHODS END
97 
98     // ADMIN METHODS START
99     function changeOwner(address _to) public onlyOwner {
100         require(_to != address(0));
101         owner = _to;
102     }
103     /** @dev So Owner can't take away player's money in the middle of the game.
104     Owner can only withdraw earnings of the game contract and not the entire balance.
105     Earnings are calculated after every game is finished, i.e.; when both players
106     have cliamed reward. If a player doens't claim reward for a game, those ether 
107     can not be reclaimed until 1 week. After 1 week Owner of contract has power of disqualifying 
108     Players who did not finihs the game. FAIR ENOUGH ?
109     */
110     function transferEarningsToOwner() public onlyOwner {
111         require(address(this).balance >= contractEarnings);
112         uint256 _contractEarnings = contractEarnings;
113         contractEarnings = 0;
114         // VERY IMPORTANT
115         // PREVENTS REENTRANCY ATTACK BY CONTRACT OWNER
116         // contract Earnings need to be set to 0 first,
117         // and then transferred to owner
118         owner.transfer(_contractEarnings);
119     }
120 
121     function suspend(address _player) public onlyOwner returns(bool _suspended){
122         require(!suspended[_player]);
123         require(_player != owner);
124         suspended[_player] = true;
125         emit Suspended(_player);
126         return true;
127     }
128 
129     function unSuspend(address _player) public onlyOwner returns(bool _unSuspended){
130         require(suspended[_player]);
131         suspended[_player] = false;
132         emit UnSuspended(_player);
133         return true;
134     }
135 
136     function setRewardPercentageK(uint256 _k) public onlyOwner {
137         //Max earnings is double.
138         require(_k <= 100);
139         emit NewRewardPercentage(K, _k);
140         K = _k;
141     }
142 
143     function setGameRules(uint256 _fees, uint256 _minBet, uint256 _maxBet, uint256 _stageTimeout) public onlyOwner {
144         require(_stageTimeout >= 60*60*24*7);//Owner can't set it to below 1 week
145         require((_fees * 100 ) < _minBet);//Fees will always be less that 1 % of bet
146         require(_minBet < _maxBet);
147         emit NewGameRules(REGISTRATION_COST, _fees, MINIMUM_COST_OF_BET, _minBet, MAXIMUM_COST_OF_BET, _maxBet, STAGE_TIMEOUT, _stageTimeout);
148         REGISTRATION_COST = _fees;
149         MINIMUM_COST_OF_BET = _minBet;
150         MAXIMUM_COST_OF_BET = _maxBet;
151         STAGE_TIMEOUT = _stageTimeout;
152     }
153     //ADMIN METHODS ENDS
154 
155     //VIEW APIs STARTS
156     function getOwner() public view returns(address _owner) {
157         return owner;
158     }
159 
160     function getContractBalance() public view returns(uint256 _balance) {
161         return address(this).balance;
162     }
163 
164     function getContractEarnings() public view returns(uint _earnings) {
165         return contractEarnings;
166     }
167 
168     function getRewardMatrix() public view returns(uint _k) {
169         return (K);
170     }
171 
172     function getGameRules() public view returns(uint256 _fees, uint256 _minBet, uint256 _maxBet, uint256 _stageTimeout) {
173         return (REGISTRATION_COST, MINIMUM_COST_OF_BET, MAXIMUM_COST_OF_BET, STAGE_TIMEOUT);
174     }
175 
176     function getGameState(uint gameNumber) public view returns(bool _registerationOpen, bool _revealing, bool _lastGameFinished, uint _startTime, uint _revealTime, uint _finishTime, uint _stageTimeout) {
177         require(games.length >= gameNumber);    
178         Game storage game = games[gameNumber - 1];    
179         return (game.registerationOpen, game.revealing, game.lastGameFinished, game.startTime, game.revealTime, game.finishTime, game.stageTimeout);
180     }
181 
182     function getPlayerState(uint gameNumber) public view returns(bool _suspended, bool _registered, bool _revealed, bool _disqualified, bool _claimedReward, uint256 _betAmount, uint256 _reward) {
183         require(games.length >= gameNumber);
184         uint index = gameNumber - 1;
185         address player = msg.sender;
186         uint256 betAmount = games[index].bets[player].betAmount;
187         return (suspended[player], games[index].registered[player], games[index].revealed[player], games[index].disqualified[player], games[index].claimedReward[player], betAmount, games[index].reward[player] );
188     }
189 
190     function getTotalGamesStarted() public view returns(uint _totalGames) {
191         return totalGamesStarted[msg.sender];
192     }
193 
194     function getTotalGamesParticipated() public view returns(uint _totalGames) {
195         return totalGamesParticipated[msg.sender];
196     }
197 
198     function getTotalGames() public view returns(uint _totalGames) {
199         return games.length;
200     }
201     //VIEW APIs ENDS
202 
203     //GAME PLAY STARTS
204     function startGame(uint256 _betAmount, bytes32 _encryptedChoice) public  payable costs(_betAmount) returns(uint _gameNumber) {
205         address player = msg.sender;
206         require(!suspended[player]);   
207         require(_betAmount >= MINIMUM_COST_OF_BET);
208         require(_betAmount <= MAXIMUM_COST_OF_BET);
209         Game memory _game = Game(now, now, now, player, address(0), REGISTRATION_COST, K, STAGE_TIMEOUT, true, false, false);  
210         games.push(_game); 
211         Game storage game = games[games.length-1]; 
212         game.registered[player] = true;
213         game.bets[player] = Bet(_encryptedChoice, _betAmount, 0);                   
214         totalGamesStarted[player] = totalGamesStarted[player] + 1;
215         emit RegisterationOpened(games.length);
216         return games.length;
217     }
218 
219     function joinGame(uint _gameNumber, uint256 _betAmount, bytes32 _encryptedChoice) public  payable costs(_betAmount) {
220         require(games.length >= _gameNumber);
221         Game storage game = games[_gameNumber-1];
222         address player = msg.sender;
223         require(game.registerationOpen); 
224         require(game.player1 != player); // Can also put ```require(game.registered[player]);``` meaning, Same player cannot join the game.
225         require(!suspended[player]);   
226         require(_betAmount >= MINIMUM_COST_OF_BET);
227         require(_betAmount <= MAXIMUM_COST_OF_BET);
228         require(game.player2 == address(0)); 
229         game.player2 = player;
230         game.registered[player] = true;
231         game.bets[player] = Bet(_encryptedChoice, _betAmount, 0);    
232         game.registerationOpen = false;
233         game.revealing = true;  
234         game.revealTime = now; // Set Game Reveal time in order to resolve dead lock if no one claims reward.
235         game.finishTime = now; // If both do not reveal for one week, Admin can immidiately finish game.
236         game.opponent[game.player1] = game.player2;    
237         game.opponent[game.player2] = game.player1;
238         totalGamesParticipated[player] = totalGamesParticipated[player] + 1;
239         emit RegisterationClosed(_gameNumber);
240         emit RevealStart(_gameNumber);
241     }
242 
243     function reveal(uint _gameNumber, uint256 _choice) public {
244         require(games.length >= _gameNumber);
245         Game storage game = games[_gameNumber-1];
246         require(game.revealing);
247         address player = msg.sender;
248         require(!suspended[player]);
249         require(game.registered[player]);
250         require(!game.revealed[player]);
251         game.revealed[player] = true;
252         game.bets[player].actualChoice = _choice;
253         bytes32 encryptedChoice = game.bets[player].encryptedChoice;
254         bytes32 encryptedActualChoice = keccak256(_choice);
255         if( encryptedActualChoice != encryptedChoice) {
256             game.disqualified[player] = true;
257             //Mark them as Claimed Reward so that 
258             //contract earnings can be accounted for
259             game.claimedReward[player] = true;
260             game.reward[player] = 0;
261             if (game.disqualified[game.opponent[player]]) {
262                 uint256 gameEarnings = game.bets[player].betAmount + game.bets[game.opponent[player]].betAmount;
263                 contractEarnings = contractEarnings + gameEarnings;
264                 emit ContractEarnings(_gameNumber, gameEarnings, "BOTH_DISQUALIFIED");
265             }
266             emit Disqualified(_gameNumber, player, encryptedChoice, _choice, encryptedActualChoice);
267         }
268         if(game.revealed[game.player1] && game.revealed[game.player2]) {
269             game.revealing = false;
270             game.lastGameFinished = true;
271             game.finishTime = now; //Set Game finish time in order to resolve dead lock if no one claims reward.
272             emit RevealStop(_gameNumber);
273         }
274     }
275     //GAME PLAY ENDS
276 
277 
278     //REWARD WITHDRAW STARTS
279     function ethTransfer(uint gameNumber, address _to, uint256 _amount) private {
280         require(!suspended[_to]);
281         require(_to != address(0));
282         if ( _amount > games[gameNumber-1].registrationCost) {
283             //Take game Commission
284             uint256 amount = _amount - games[gameNumber-1].registrationCost;
285             require(address(this).balance >= amount);
286             _to.transfer(amount);
287             emit Transferred(gameNumber, _to, amount);
288         }
289     }
290 
291 
292     function claimRewardK(uint gameNumber) public returns(bool _claimedReward)  {
293         require(games.length >= gameNumber);
294         Game storage game = games[gameNumber-1];
295         address player = msg.sender;
296         require(!suspended[player]);
297         require(!game.claimedReward[player]);
298         uint commission = games[gameNumber-1].registrationCost;
299         if (game.registerationOpen) {
300             game.claimedReward[player] = true;
301             game.registerationOpen = false;
302             game.lastGameFinished = true;
303             if ( now > (game.startTime + game.stageTimeout)) {
304                 //No commision if game was open till stage timeout.
305                 commission = 0;
306             }
307             game.reward[player] = game.bets[player].betAmount - commission;
308             if (commission > 0) {
309                 contractEarnings = contractEarnings + commission;
310                 emit ContractEarnings(gameNumber, commission, "GAME_ABANDONED");
311             }
312             //Bet amount can't be less than commission.
313             //Hence no -ve check is required
314             ethTransfer(gameNumber, player, game.bets[player].betAmount);
315             return true;
316         }
317         require(game.lastGameFinished);
318         require(!game.disqualified[player]);
319         require(game.registered[player]);
320         require(game.revealed[player]);
321         require(!game.claimedReward[player]);
322         game.claimedReward[player] = true;
323         address opponent = game.opponent[player];
324         uint256 reward = 0;
325         uint256 gameReward = 0;
326         uint256 totalBet = (game.bets[player].betAmount + game.bets[opponent].betAmount);
327         if ( game.disqualified[opponent]) {
328             gameReward = ((100 + game.k) * game.bets[player].betAmount) / 100;
329             reward = gameReward < totalBet ? gameReward : totalBet; //Min (X+Y, (100+K)*X/100)
330             game.reward[player] = reward - commission;
331             //Min (X+Y, (100+K)*X/100) can't be less than commision.
332             //Hence no -ve check is required
333             contractEarnings = contractEarnings + (totalBet - game.reward[player]);
334             emit ContractEarnings(gameNumber, (totalBet - game.reward[player]), "OPPONENT_DISQUALIFIED");
335             ethTransfer(gameNumber, player, reward);
336             return true;
337         }
338         if ( !isEven(game.bets[player].actualChoice) && !isEven(game.bets[opponent].actualChoice) ) { // Split Split
339             reward = (game.bets[player].betAmount + game.bets[opponent].betAmount) / 2;
340             game.reward[player] = reward - commission;
341             //(X+Y)/2 can't be less than commision.
342             //Hence no -ve check is required
343             if ( game.claimedReward[opponent] ) {
344                 uint256 gameEarnings = (totalBet - game.reward[player] - game.reward[opponent]);
345                 contractEarnings = contractEarnings + gameEarnings;
346                 emit ContractEarnings(gameNumber, gameEarnings, "SPLIT_SPLIT");
347             }
348             ethTransfer(gameNumber, player, reward);
349             return true;
350         }
351         if ( !isEven(game.bets[player].actualChoice) && isEven(game.bets[opponent].actualChoice) ) { // Split Steal
352             game.reward[player] = 0;
353             if ( game.claimedReward[opponent] ) {
354                 gameEarnings = (totalBet - game.reward[player] - game.reward[opponent]);
355                 contractEarnings = contractEarnings + gameEarnings;
356                 emit ContractEarnings(gameNumber, gameEarnings, "SPLIT_STEAL");
357             }
358             return true;
359         }
360         if ( isEven(game.bets[player].actualChoice) && !isEven(game.bets[opponent].actualChoice) ) { // Steal Split
361             gameReward = (((100 + game.k) * game.bets[player].betAmount)/100);
362             reward = gameReward < totalBet ? gameReward : totalBet; 
363             game.reward[player] = reward - commission;
364             //Min (X+Y, (100+K)*X/100) can't be less than commision.
365             //Hence no -ve check is required
366             if ( game.claimedReward[opponent] ) {
367                 gameEarnings = (totalBet - game.reward[player] - game.reward[opponent]);
368                 contractEarnings = contractEarnings + gameEarnings;
369                 emit ContractEarnings(gameNumber, gameEarnings, "STEAL_SPLIT");
370             }
371             ethTransfer(gameNumber, player, reward);
372             return true;
373         }
374         if ( isEven(game.bets[player].actualChoice) && isEven(game.bets[opponent].actualChoice) ) { // Steal Steal
375             reward = 0;
376             if( game.bets[player].betAmount > game.bets[opponent].betAmount) {
377                 //((100-K)*(X-Y)/2)/100 will always be less than X+Y so no need for min check on X+Y and reward
378                 reward = ((100 - game.k) * (game.bets[player].betAmount - game.bets[opponent].betAmount) / 2) / 100;
379             }
380             if(reward > 0) {
381                 //((100-K)*(X-Y)/2)/100 CAN BE LESS THAN COMMISSION.
382                 game.reward[player] = reward > commission ? reward - commission : 0;
383             }
384             if ( game.claimedReward[opponent] ) {
385                 gameEarnings = (totalBet - game.reward[player] - game.reward[opponent]);
386                 contractEarnings = contractEarnings + gameEarnings;
387                 emit ContractEarnings(gameNumber, gameEarnings, "STEAL_STEAL");
388             }
389             ethTransfer(gameNumber, player, reward);
390             return true;
391         }
392     }
393     //REWARD WITHDRAW ENDS
394 
395 
396     //OWNER OVERRIDE SECTION STARTS
397     /** 
398      *  Give back to game creator instead of consuming to contract.
399      *  So in case Game owner has PTSD and wants al game finished,
400      *  Game owner will call this on game which is in registeration open
401      *  state since past stage timeout.
402      *  Do some good :)
403      *  ALTHOUGH if game creator wants to abandon after stage timeout
404      *  No fees is charged. See claimReward Method for that.
405      */
406     function ownerAbandonOverride(uint _gameNumber) private returns(bool _overriden) {
407         Game storage game = games[_gameNumber-1];
408         if (game.registerationOpen) {
409             if (now > (game.startTime + game.stageTimeout)) {
410                 game.claimedReward[game.player1] = true;
411                 game.registerationOpen = false;
412                 game.lastGameFinished = true;
413                 game.reward[game.player1] = game.bets[game.player1].betAmount; 
414                 //Do not cut commision as no one came to play. 
415                 //This also incentivisies users to keep the game open for long time.
416                 ethTransfer(_gameNumber, game.player1, game.bets[game.player1].betAmount);
417                 return true;
418             }                  
419         }      
420         return false;
421     }
422 
423     /** 
424      *  If both palayer(s) does(-es) not reveal choice in time they get disqualified.
425      *  If both players do not reveal choice in time, Game's earnings are updated.
426      *  If one of the player does not reveal choice, then game's earnings are not updated.
427      *  Player who has revealed is given chance to claim reward.
428      */
429 
430     function ownerRevealOverride(uint _gameNumber) private returns(bool _overriden) {
431         Game storage game = games[_gameNumber-1];
432         if ( game.revealing) {
433             if (now > (game.revealTime + game.stageTimeout)) {
434                 if(!game.revealed[game.player1] && !game.revealed[game.player1]) {
435                     //Mark Player as following,
436                     //  1.)Revealed (To maintain sane state of game)
437                     //  2.)Disqualified (Since player did not finish the game in time)
438                     //  3.)Claimed Reward ( So that contract earnings can be accounted for)
439                     //  Also set reward amount as 0
440                     game.revealed[game.player1] = true;
441                     game.disqualified[game.player1] = true;
442                     game.claimedReward[game.player1] = true;
443                     game.reward[game.player1] = 0;
444                     emit Disqualified(_gameNumber, game.player1, "", 0, "");
445                     game.revealed[game.player2] = true;
446                     game.disqualified[game.player2] = true;
447                     game.claimedReward[game.player2] = true;
448                     game.reward[game.player2] = 0;
449                     emit Disqualified(_gameNumber, game.player2, "", 0, "");
450                     game.finishTime = now;
451                     uint256 gameEarnings = game.bets[game.player1].betAmount + game.bets[game.player2].betAmount;
452                     contractEarnings = contractEarnings + gameEarnings;
453                     emit ContractEarnings(_gameNumber, gameEarnings, "BOTH_NO_REVEAL");
454                 } else if (game.revealed[game.player1] && !game.revealed[game.player2]) {
455                     game.revealed[game.player2] = true;
456                     game.disqualified[game.player2] = true;
457                     game.claimedReward[game.player2] = true;
458                     game.reward[game.player2] = 0;
459                     emit Disqualified(_gameNumber, game.player2, "", 0, "");
460                     game.finishTime = now;
461                 } else if (!game.revealed[game.player1] && game.revealed[game.player2]) {           
462                     game.revealed[game.player1] = true;
463                     game.disqualified[game.player1] = true;
464                     game.claimedReward[game.player1] = true;
465                     game.reward[game.player1] = 0;
466                     emit Disqualified(_gameNumber, game.player1, "", 0, "");
467                     game.finishTime = now;
468                 }
469                 game.revealing = false;
470                 game.lastGameFinished = true;
471                 emit RevealStop(_gameNumber);
472                 return true;
473             }
474         }
475         return false;
476     }
477 
478     /**
479      *  If both palayer(s) does(-es) not claim reward in time 
480      *  they loose their chance to claim reward.
481      *  Game earnings are calculated as if this gets executed successully,
482      *  both players have claimed rewards eseentialy.      
483      */
484     function ownerClaimOverride(uint _gameNumber) private returns(bool _overriden) {
485         Game storage game = games[_gameNumber-1];
486         if ( game.lastGameFinished) {
487             if (now > (game.finishTime + game.stageTimeout)) {
488                 if(!game.claimedReward[game.player1] && !game.claimedReward[game.player1]) {
489                     game.claimedReward[game.player1] = true;
490                     game.reward[game.player1] = 0;
491                     game.claimedReward[game.player2] = true;
492                     game.reward[game.player2] = 0;
493                 } else if (game.claimedReward[game.player1] && !game.claimedReward[game.player2]) {
494                     game.claimedReward[game.player2] = true;
495                     game.reward[game.player2] = 0;
496                 } else if (!game.claimedReward[game.player1] && game.claimedReward[game.player2]) {           
497                     game.claimedReward[game.player1] = true;
498                     game.reward[game.player1] = 0;
499                 } else {
500                     //Both players have alreay claimed reward.
501                     return false;
502                 }
503                 uint256 totalBet = (game.bets[game.player1].betAmount + game.bets[game.player2].betAmount);
504                 uint gameEarnings = totalBet - game.reward[game.player1] - game.reward[game.player2];
505                 contractEarnings = contractEarnings + gameEarnings;
506                 emit ContractEarnings(_gameNumber, gameEarnings, "OWNER_CLAIM_OVERRIDE");
507             }
508         }
509     }
510 
511     function ownerOverride(uint _gameNumber) public onlyOwner returns(bool _overriden){
512         if (msg.sender == owner) {
513             if( ownerAbandonOverride(_gameNumber) || ownerRevealOverride(_gameNumber) || ownerClaimOverride(_gameNumber) ) {
514                 return true;
515             }
516         }
517         return false;
518     }
519     //OWNER OVERRIDE SECTION ENDS
520 
521 }