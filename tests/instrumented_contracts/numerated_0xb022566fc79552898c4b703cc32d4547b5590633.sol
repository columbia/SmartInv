1 /* Copyright (C) Etherplay <contact@etherplay.io> - All Rights Reserved */
2 pragma solidity 0.4.4;
3 
4 contract CompetitionStore {
5 	
6 /////////////////////////////////////////////////////////////////// DATA /////////////////////////////////////////////////////////////
7 	
8 	//player's submission store the info required to verify its accuracy
9 	struct Submission{
10 		uint32 score; 
11 		uint32 durationRoundedDown; // duration in second of the game session
12 		uint32 version; // version of the game used
13 		uint64 seed; //seed used
14 		uint64 submitBlockNumber; // blockNumber at which the submission is processed
15 		bytes32 proofHash;//sha256 of proof : to save gas, the proof is not saved directly in the contract. Instead its hash is saved. The actual proof will be saved on a server. The player could potentially save it too. 
16 	}
17 	
18 	//player start game parameter
19 	struct Start{
20 		uint8 competitionIndex; //competition index (0 or 1) there is only 2 current competition per game, one is active, the other one being the older one which might have pending verification
21 		uint32 version;  //version of the game that the player score is based on
22 		uint64 seed; // the seed used for the game session
23 		uint64 time; // start time , used to check if the player is not taking too long to submit its score
24 	}
25 	
26 	// the values representing each competition
27 	struct Competition{
28 		uint8 numPastBlocks;// number of past block allowed, 1 is the minimum since you can only get the hash of a past block. Allow player to start play instantunously
29 		uint8 houseDivider; // how much the house takes : 4 means house take 1/4 (25%)
30 		uint16 lag; // define how much extra time is allowed to submit a score (to accomodate block time and delays)
31 		uint32 verificationWaitTime;// wait time allowed for submission past competition's end time 
32 		uint32 numPlayers;//current number of player that submited a score
33 		uint32 version; //the version of the game used for that competition, a hash of the code is published in the log upon changing
34 		uint32 previousVersion; // previousVersion to allow smooth update upon version change
35 		uint64 versionChangeBlockNumber; 
36 		uint64 switchBlockNumber; // the blockNumber at which the competition started
37 		uint64 endTime;//The time at which the competition is set to finish. No start can happen after that and the competition cannot be aborted before that
38 		uint88 price;  // the price for that competition, do not change 
39 		uint128 jackpot; // the current jackpot for that competition, this jackpot is then shared among the developer (in the deposit account for  funding development) and the winners (see houseDivider))
40 		uint32[] rewardsDistribution; // the length of it define how many winners there is and the distribution of the reward is the value for each index divided by the total
41 		mapping (address => Submission) submissions;  //only one submission per player per competition
42 		address[] players; // contain the list of players that submited a score for that competition
43 	}
44 		
45 	struct Game{
46 		mapping (address => Start) starts; // only 1 start per player, further override the current
47 		Competition[2] competitions; // 2 competitions only to save gas, overrite each other upon going to next competition
48 		uint8 currentCompetitionIndex; //can only be 1 or 0 (switch operation : 1 - currentCompetitionIndex)
49 	}
50 
51 	mapping (string => Game) games;
52 	
53 	address organiser; // admin having control of the reward 
54 	address depositAccount;	 // is the receiver of the house part of the jackpot (see houseDivider) Can only be changed by the depositAccount.
55 
56 //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
57 
58 
59 
60 ///////////////////////////////////////////////////////// EVENTS /////////////////////////////////////////////////////////////
61 
62 	//event logging the hash of the game code for a particular version
63 	event VersionChange(
64 		string indexed gameID,
65 		uint32 indexed version,
66 		bytes32 codeHash // the sha256 of the game code as used by the player
67 	);
68 
69 //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
70 
71 
72 
73 
74 //////////////////////////////////////////////////////// PLAYERS ACTIONS /////////////////////////////////////////////////////////////
75 	
76 	/*
77 	The seed is computed from the block hash and the sender address
78 	While the seed can be predicted for few block away (see : numPastBlocks) this is has no much relevance since a game session have a bigger duration,
79 	Remember this is not gambling game, this is a skill game, seed is only a small part of the game outcome
80 	*/
81 	function computeSeed(uint64 blockNumber, address player) internal constant returns(uint64 seed){ 
82 		return uint64(sha3(block.blockhash(blockNumber),block.blockhash(blockNumber-1),block.blockhash(blockNumber-2),block.blockhash(blockNumber-3),block.blockhash(blockNumber-4),block.blockhash(blockNumber-5),player)); 
83 	}
84 	
85 	/*
86 		probe the current state of the competition so player can start playing right away (need to commit a tx too to ensure its play will be considered though)
87 	*/
88 	function getSeedAndState(string gameID, address player) constant returns(uint64 seed, uint64 blockNumber, uint8 competitionIndex, uint32 version, uint64 endTime, uint88 price, uint32 myBestScore, uint64 competitionBlockNumber, uint64 registeredSeed){
89 		var game = games[gameID];
90 
91 		competitionIndex = game.currentCompetitionIndex;
92 		var competition = game.competitions[competitionIndex];
93 
94 		blockNumber = uint64(block.number-1);
95 		seed = computeSeed(blockNumber, player);
96 		version = competition.version;
97 		endTime = competition.endTime;
98 		price = competition.price;
99 		competitionBlockNumber = competition.switchBlockNumber;
100 		
101 		if (competition.submissions[player].submitBlockNumber >= competition.switchBlockNumber){
102 			myBestScore = competition.submissions[player].score;
103 		}else{
104 			myBestScore = 0;
105 		}
106 		
107 		registeredSeed = game.starts[player].seed;
108 	}
109 	
110 	
111 		
112 	function start(string gameID, uint64 blockNumber,uint8 competitionIndex, uint32 version) payable {
113 		var game = games[gameID];
114 		var competition = game.competitions[competitionIndex];
115 
116 		if(msg.value != competition.price){
117 			throw;
118 		}
119 
120 		if(
121 			competition.endTime <= now || //block play when time is up 
122 			competitionIndex != game.currentCompetitionIndex || //start happen just after a switch // should not be possible since endTime already ensure that a new competition cannot start before the end of the first
123 			version != competition.version && (version != competition.previousVersion || block.number > competition.versionChangeBlockNumber) || //ensure version is same as current (or previous if versionChangeBlockNumber is recent)
124 			block.number >= competition.numPastBlocks && block.number - competition.numPastBlocks > blockNumber //ensure start is not too old   
125 			){
126 				//if ether was sent, send it back if possible, else throw
127 				if(msg.value != 0 && !msg.sender.send(msg.value)){
128 					throw;
129 				}
130 				return;
131 		}
132 		
133 		competition.jackpot += uint128(msg.value); //increase the jackpot
134 		
135 		//save the start params
136 		game.starts[msg.sender] = Start({
137 			seed: computeSeed(blockNumber,msg.sender)
138 			, time : uint64(now)
139 			, competitionIndex : competitionIndex
140 			, version : version
141 		}); 
142 	}
143 		
144 	function submit(string gameID, uint64 seed, uint32 score, uint32 durationRoundedDown, bytes32 proofHash){ 
145 		var game = games[gameID];
146 
147 		var gameStart = game.starts[msg.sender];
148 			
149 		//seed should be same, else it means double start and this one executing is from the old one 
150 		if(gameStart.seed != seed){
151 			return;
152 		}
153 		
154 		//no start found
155 		if(gameStart.time == 0){
156 			return;
157 		}
158 		
159 		var competition = game.competitions[gameStart.competitionIndex];
160 		
161 		// game should not take too long to be submited
162 		if(now - gameStart.time > durationRoundedDown + competition.lag){ 
163 			return;
164 		}
165 
166 		if(now >= competition.endTime + competition.verificationWaitTime){
167 			return; //this ensure verifier to get all the score at that time (should never be there though as game should ensure a maximumTime < verificationWaitTime)
168 		}
169 		
170 		var submission = competition.submissions[msg.sender];
171 		if(submission.submitBlockNumber < competition.switchBlockNumber){
172 			if(competition.numPlayers >= 4294967295){ //unlikely but if that happen this is for now the best place to stop
173 				return;
174 			}
175 		}else if (score <= submission.score){
176 			return;
177 		}
178 		
179 		var players = competition.players;
180 		//if player did not submit score yet => add player to list
181 		if(submission.submitBlockNumber < competition.switchBlockNumber){
182 			var currentNumPlayer = competition.numPlayers;
183 			if(currentNumPlayer >= players.length){
184 				players.push(msg.sender);
185 			}else{
186 				players[currentNumPlayer] = msg.sender;
187 			}
188 			competition.numPlayers = currentNumPlayer + 1;
189 		}
190 		
191 		competition.submissions[msg.sender] = Submission({
192 			proofHash:proofHash,
193 			seed:gameStart.seed,
194 			score:score,
195 			durationRoundedDown:durationRoundedDown,
196 			submitBlockNumber:uint64(block.number),
197 			version:gameStart.version
198 		});
199 		
200 		gameStart.time = 0; //reset to force the need to start
201 		
202 	}
203 	
204 	/*
205 		accept donation payment : this increase the jackpot of the currentCompetition of the specified game
206 	*/
207 	function increaseJackpot(string gameID) payable{
208 		var game = games[gameID];
209 		game.competitions[game.currentCompetitionIndex].jackpot += uint128(msg.value); //extra ether is lost but this is not going to happen :)
210 	}
211 
212 //////////////////////////////////////////////////////////////////////////////////////////
213 
214 	
215 /////////////////////////////////////// PRIVATE ///////////////////////////////////////////
216 		
217 	function CompetitionStore(){
218 		organiser = msg.sender;
219 		depositAccount = msg.sender;
220 	}
221 
222 	
223 	//give a starting jackpot by sending ether to the transaction
224 	function _startNextCompetition(string gameID, uint32 version, uint88 price, uint8 numPastBlocks, uint8 houseDivider, uint16 lag, uint64 duration, uint32 verificationWaitTime, bytes32 codeHash, uint32[] rewardsDistribution) payable{
225 		if(msg.sender != organiser){
226 			throw;
227 		}
228 		var game = games[gameID];
229 		var newCompetition = game.competitions[1 - game.currentCompetitionIndex]; 
230 		var currentCompetition = game.competitions[game.currentCompetitionIndex];
231 		//do not allow to switch if endTime is not over
232 		if(currentCompetition.endTime >= now){
233 			throw;
234 		}
235 
236 		//block switch if reward was not called (numPlayers > 0)
237 		if(newCompetition.numPlayers > 0){
238 			throw;
239 		}
240 		
241 		if(houseDivider == 0){ 
242 			throw;
243 		}
244 		
245 		if(numPastBlocks < 1){
246 			throw;
247 		}
248 		
249 		if(rewardsDistribution.length == 0 || rewardsDistribution.length > 64){ // do not risk gas shortage on reward
250 			throw;
251 		}
252 		//ensure rewardsDistribution give always something and do not give more to a lower scoring player
253 		uint32 prev = 0;
254 		for(uint8 i = 0; i < rewardsDistribution.length; i++){
255 			if(rewardsDistribution[i] == 0 ||  (prev != 0 && rewardsDistribution[i] > prev)){
256 				throw;
257 			}
258 			prev = rewardsDistribution[i];
259 		}
260 
261 		if(version != currentCompetition.version){
262 			VersionChange(gameID,version,codeHash); 
263 		}
264 		
265 		game.currentCompetitionIndex = 1 - game.currentCompetitionIndex;
266 		
267 		newCompetition.switchBlockNumber = uint64(block.number);
268 		newCompetition.previousVersion = 0;
269 		newCompetition.versionChangeBlockNumber = 0;
270 		newCompetition.version = version;
271 		newCompetition.price = price; 
272 		newCompetition.numPastBlocks = numPastBlocks;
273 		newCompetition.rewardsDistribution = rewardsDistribution;
274 		newCompetition.houseDivider = houseDivider;
275 		newCompetition.lag = lag;
276 		newCompetition.jackpot += uint128(msg.value); //extra ether is lost but this is not going to happen :)
277 		newCompetition.endTime = uint64(now) + duration;
278 		newCompetition.verificationWaitTime = verificationWaitTime;
279 	}
280 	
281 	
282 	
283 	function _setBugFixVersion(string gameID, uint32 version, bytes32 codeHash, uint32 numBlockAllowedForPastVersion){
284 		if(msg.sender != organiser){
285 			throw;
286 		}
287 
288 		var game = games[gameID];
289 		var competition = game.competitions[game.currentCompetitionIndex];
290 		
291 		if(version <= competition.version){ // a bug fix should be a new version (greater than previous version)
292 			throw;
293 		}
294 		
295 		if(competition.endTime <= now){ // cannot bugFix a competition that already ended
296 			return;
297 		}
298 		
299 		competition.previousVersion = competition.version;
300 		competition.versionChangeBlockNumber = uint64(block.number + numBlockAllowedForPastVersion);
301 		competition.version = version;
302 		VersionChange(gameID,version,codeHash);
303 	}
304 
305 	function _setLagParams(string gameID, uint16 lag, uint8 numPastBlocks){
306 		if(msg.sender != organiser){
307 			throw;
308 		}
309 		
310 		if(numPastBlocks < 1){
311 			throw;
312 		}
313 
314 		var game = games[gameID];
315 		var competition = game.competitions[game.currentCompetitionIndex];
316 		competition.numPastBlocks = numPastBlocks;
317 		competition.lag = lag;
318 	}
319 
320 	function _rewardWinners(string gameID, uint8 competitionIndex, address[] winners){
321 		if(msg.sender != organiser){
322 			throw;
323 		}
324 		
325 		var competition = games[gameID].competitions[competitionIndex];
326 
327 		//ensure time has passed so that players who started near the end can finish their session 
328 		//game should be made to ensure termination before verificationWaitTime, it is the game responsability
329 		if(int(now) - competition.endTime < competition.verificationWaitTime){
330 			throw;
331 		}
332 
333 		
334 		if( competition.jackpot > 0){ // if there is no jackpot skip
335 
336 			
337 			var rewardsDistribution = competition.rewardsDistribution;
338 
339 			uint8 numWinners = uint8(rewardsDistribution.length);
340 
341 			if(numWinners > uint8(winners.length)){
342 				numWinners = uint8(winners.length);
343 			}
344 
345 			uint128 forHouse = competition.jackpot;
346 			if(numWinners > 0 && competition.houseDivider > 1){ //in case there is no winners (no players or only cheaters), the house takes all
347 				forHouse = forHouse / competition.houseDivider;
348 				uint128 forWinners = competition.jackpot - forHouse;
349 
350 				uint64 total = 0;
351 				for(uint8 i=0; i<numWinners; i++){ // distribute all the winning even if there is not all the winners
352 					total += rewardsDistribution[i];
353 				}
354 				for(uint8 j=0; j<numWinners; j++){
355 					uint128 value = (forWinners * rewardsDistribution[j]) / total;
356 					if(!winners[j].send(value)){ // if fail give to house
357 						forHouse = forHouse + value;
358 					}
359 				}
360 			}
361 			
362 			if(!depositAccount.send(forHouse)){
363 				//in case sending to house failed 
364 				var nextCompetition = games[gameID].competitions[1 - competitionIndex];
365 				nextCompetition.jackpot = nextCompetition.jackpot + forHouse;	
366 			}
367 
368 			
369 			competition.jackpot = 0;
370 		}
371 		
372 		
373 		competition.numPlayers = 0;
374 	}
375 
376 	
377 	/*
378 		allow to change the depositAccount of the house share, only the depositAccount can change it, depositAccount == organizer at creation
379 	*/
380 	function _setDepositAccount(address newDepositAccount){
381 		if(depositAccount != msg.sender){
382 			throw;
383 		}
384 		depositAccount = newDepositAccount;
385 	}
386 	
387 	/*
388 		allow to change the organiser, in case this need be 
389 	*/
390 	function _setOrganiser(address newOrganiser){
391 		if(organiser != msg.sender){
392 			throw;
393 		}
394 		organiser = newOrganiser;
395 	}
396 	
397 	
398 ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
399 
400 /////////////////////////////////////////////// OTHER CONSTANT CALLS TO PROBE VALUES ////////////////////////////////////////////////////
401 
402 	function getPlayerSubmissionFromCompetition(string gameID, uint8 competitionIndex, address playerAddress) constant returns(uint32 score, uint64 seed, uint32 duration, bytes32 proofHash, uint32 version, uint64 submitBlockNumber){
403 		var submission = games[gameID].competitions[competitionIndex].submissions[playerAddress];
404 		score = submission.score;
405 		seed = submission.seed;		
406 		duration = submission.durationRoundedDown;
407 		proofHash = submission.proofHash;
408 		version = submission.version;
409 		submitBlockNumber =submission.submitBlockNumber;
410 	}
411 	
412 	function getPlayersFromCompetition(string gameID, uint8 competitionIndex) constant returns(address[] playerAddresses, uint32 num){
413 		var competition = games[gameID].competitions[competitionIndex];
414 		playerAddresses = competition.players;
415 		num = competition.numPlayers;
416 	}
417 
418 	function getCompetitionValues(string gameID, uint8 competitionIndex) constant returns (
419 		uint128 jackpot,
420 		uint88 price,
421 		uint32 version,
422 		uint8 numPastBlocks,
423 		uint64 switchBlockNumber,
424 		uint32 numPlayers,
425 		uint32[] rewardsDistribution,
426 		uint8 houseDivider,
427 		uint16 lag,
428 		uint64 endTime,
429 		uint32 verificationWaitTime,
430 		uint8 _competitionIndex
431 	){
432 		var competition = games[gameID].competitions[competitionIndex];
433 		jackpot = competition.jackpot;
434 		price = competition.price;
435 		version = competition.version;
436 		numPastBlocks = competition.numPastBlocks;
437 		switchBlockNumber = competition.switchBlockNumber;
438 		numPlayers = competition.numPlayers;
439 		rewardsDistribution = competition.rewardsDistribution;
440 		houseDivider = competition.houseDivider;
441 		lag = competition.lag;
442 		endTime = competition.endTime;
443 		verificationWaitTime = competition.verificationWaitTime;
444 		_competitionIndex = competitionIndex;
445 	}
446 	
447 	function getCurrentCompetitionValues(string gameID) constant returns (
448 		uint128 jackpot,
449 		uint88 price,
450 		uint32 version,
451 		uint8 numPastBlocks,
452 		uint64 switchBlockNumber,
453 		uint32 numPlayers,
454 		uint32[] rewardsDistribution,
455 		uint8 houseDivider,
456 		uint16 lag,
457 		uint64 endTime,
458 		uint32 verificationWaitTime,
459 		uint8 _competitionIndex
460 	)
461 	{
462 		return getCompetitionValues(gameID,games[gameID].currentCompetitionIndex);
463 	}
464 }