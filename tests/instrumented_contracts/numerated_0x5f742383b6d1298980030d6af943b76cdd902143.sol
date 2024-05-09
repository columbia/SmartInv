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
154 		var competition = game.competitions[gameStart.competitionIndex];
155 		
156 		// game should not take too long to be submited
157 		if(now - gameStart.time > durationRoundedDown + competition.lag){ 
158 			return;
159 		}
160 
161 		if(now >= competition.endTime + competition.verificationWaitTime){
162 			return; //this ensure verifier to get all the score at that time (should never be there though as game should ensure a maximumTime < verificationWaitTime)
163 		}
164 		
165 		var submission = competition.submissions[msg.sender];
166 		if(submission.submitBlockNumber < competition.switchBlockNumber){
167 			if(competition.numPlayers >= 4294967295){ //unlikely but if that happen this is for now the best place to stop
168 				return;
169 			}
170 		}else if (score <= submission.score){
171 			return;
172 		}
173 		
174 		var players = competition.players;
175 		//if player did not submit score yet => add player to list
176 		if(submission.submitBlockNumber < competition.switchBlockNumber){
177 			var currentNumPlayer = competition.numPlayers;
178 			if(currentNumPlayer >= players.length){
179 				players.push(msg.sender);
180 			}else{
181 				players[currentNumPlayer] = msg.sender;
182 			}
183 			competition.numPlayers = currentNumPlayer + 1;
184 		}
185 		
186 		competition.submissions[msg.sender] = Submission({
187 			proofHash:proofHash,
188 			seed:gameStart.seed,
189 			score:score,
190 			durationRoundedDown:durationRoundedDown,
191 			submitBlockNumber:uint64(block.number),
192 			version:gameStart.version
193 		});
194 		
195 	}
196 	
197 	/*
198 		accept donation payment : this increase the jackpot of the currentCompetition of the specified game
199 	*/
200 	function increaseJackpot(string gameID) payable{
201 		var game = games[gameID];
202 		game.competitions[game.currentCompetitionIndex].jackpot += uint128(msg.value); //extra ether is lost but this is not going to happen :)
203 	}
204 
205 //////////////////////////////////////////////////////////////////////////////////////////
206 
207 	
208 /////////////////////////////////////// PRIVATE ///////////////////////////////////////////
209 		
210 	function CompetitionStore(){
211 		organiser = msg.sender;
212 		depositAccount = msg.sender;
213 	}
214 
215 	
216 	//give a starting jackpot by sending ether to the transaction
217 	function _startNextCompetition(string gameID, uint32 version, uint88 price, uint8 numPastBlocks, uint8 houseDivider, uint16 lag, uint64 duration, uint32 verificationWaitTime, bytes32 codeHash, uint32[] rewardsDistribution) payable{
218 		if(msg.sender != organiser){
219 			throw;
220 		}
221 		var game = games[gameID];
222 		var newCompetition = game.competitions[1 - game.currentCompetitionIndex]; 
223 		var currentCompetition = game.competitions[game.currentCompetitionIndex];
224 		//do not allow to switch if endTime is not over
225 		if(currentCompetition.endTime >= now){
226 			throw;
227 		}
228 
229 		//block switch if reward was not called (numPlayers > 0)
230 		if(newCompetition.numPlayers > 0){
231 			throw;
232 		}
233 		
234 		if(houseDivider == 0){ 
235 			throw;
236 		}
237 		
238 		if(numPastBlocks < 1){
239 			throw;
240 		}
241 		
242 		if(rewardsDistribution.length == 0 || rewardsDistribution.length > 64){ // do not risk gas shortage on reward
243 			throw;
244 		}
245 		//ensure rewardsDistribution give always something and do not give more to a lower scoring player
246 		uint32 prev = 0;
247 		for(uint8 i = 0; i < rewardsDistribution.length; i++){
248 			if(rewardsDistribution[i] == 0 ||  (prev != 0 && rewardsDistribution[i] > prev)){
249 				throw;
250 			}
251 			prev = rewardsDistribution[i];
252 		}
253 
254 		if(version != currentCompetition.version){
255 			VersionChange(gameID,version,codeHash); 
256 		}
257 		
258 		game.currentCompetitionIndex = 1 - game.currentCompetitionIndex;
259 		
260 		newCompetition.switchBlockNumber = uint64(block.number);
261 		newCompetition.previousVersion = 0;
262 		newCompetition.versionChangeBlockNumber = 0;
263 		newCompetition.version = version;
264 		newCompetition.price = price; 
265 		newCompetition.numPastBlocks = numPastBlocks;
266 		newCompetition.rewardsDistribution = rewardsDistribution;
267 		newCompetition.houseDivider = houseDivider;
268 		newCompetition.lag = lag;
269 		newCompetition.jackpot += uint128(msg.value); //extra ether is lost but this is not going to happen :)
270 		newCompetition.endTime = uint64(now) + duration;
271 		newCompetition.verificationWaitTime = verificationWaitTime;
272 	}
273 	
274 	
275 	
276 	function _setBugFixVersion(string gameID, uint32 version, bytes32 codeHash, uint32 numBlockAllowedForPastVersion){
277 		if(msg.sender != organiser){
278 			throw;
279 		}
280 
281 		var game = games[gameID];
282 		var competition = game.competitions[game.currentCompetitionIndex];
283 		
284 		if(version <= competition.version){ // a bug fix should be a new version (greater than previous version)
285 			throw;
286 		}
287 		
288 		if(competition.endTime <= now){ // cannot bugFix a competition that already ended
289 			return;
290 		}
291 		
292 		competition.previousVersion = competition.version;
293 		competition.versionChangeBlockNumber = uint64(block.number + numBlockAllowedForPastVersion);
294 		competition.version = version;
295 		VersionChange(gameID,version,codeHash);
296 	}
297 
298 	function _setLagParams(string gameID, uint16 lag, uint8 numPastBlocks){
299 		if(msg.sender != organiser){
300 			throw;
301 		}
302 		
303 		if(numPastBlocks < 1){
304 			throw;
305 		}
306 
307 		var game = games[gameID];
308 		var competition = game.competitions[game.currentCompetitionIndex];
309 		competition.numPastBlocks = numPastBlocks;
310 		competition.lag = lag;
311 	}
312 
313 	function _rewardWinners(string gameID, uint8 competitionIndex, address[] winners){
314 		if(msg.sender != organiser){
315 			throw;
316 		}
317 		
318 		var competition = games[gameID].competitions[competitionIndex];
319 
320 		//ensure time has passed so that players who started near the end can finish their session 
321 		//game should be made to ensure termination before verificationWaitTime, it is the game responsability
322 		if(int(now) - competition.endTime < competition.verificationWaitTime){
323 			throw;
324 		}
325 
326 		
327 		if( competition.jackpot > 0){ // if there is no jackpot skip
328 
329 			
330 			var rewardsDistribution = competition.rewardsDistribution;
331 
332 			uint8 numWinners = uint8(rewardsDistribution.length);
333 
334 			if(numWinners > uint8(winners.length)){
335 				numWinners = uint8(winners.length);
336 			}
337 
338 			uint128 forHouse = competition.jackpot;
339 			if(numWinners > 0 && competition.houseDivider > 1){ //in case there is no winners (no players or only cheaters), the house takes all
340 				forHouse = forHouse / competition.houseDivider;
341 				uint128 forWinners = competition.jackpot - forHouse;
342 
343 				uint64 total = 0;
344 				for(uint8 i=0; i<numWinners; i++){ // distribute all the winning even if there is not all the winners
345 					total += rewardsDistribution[i];
346 				}
347 				for(uint8 j=0; j<numWinners; j++){
348 					uint128 value = (forWinners * rewardsDistribution[j]) / total;
349 					if(!winners[j].send(value)){ // if fail give to house
350 						forHouse = forHouse + value;
351 					}
352 				}
353 			}
354 			
355 			if(!depositAccount.send(forHouse)){
356 				//in case sending to house failed 
357 				var nextCompetition = games[gameID].competitions[1 - competitionIndex];
358 				nextCompetition.jackpot = nextCompetition.jackpot + forHouse;	
359 			}
360 
361 			
362 			competition.jackpot = 0;
363 		}
364 		
365 		
366 		competition.numPlayers = 0;
367 	}
368 
369 	
370 	/*
371 		allow to change the depositAccount of the house share, only the depositAccount can change it, depositAccount == organizer at creation
372 	*/
373 	function _setDepositAccount(address newDepositAccount){
374 		if(depositAccount != msg.sender){
375 			throw;
376 		}
377 		depositAccount = newDepositAccount;
378 	}
379 	
380 	/*
381 		allow to change the organiser, in case this need be 
382 	*/
383 	function _setOrganiser(address newOrganiser){
384 		if(organiser != msg.sender){
385 			throw;
386 		}
387 		organiser = newOrganiser;
388 	}
389 	
390 	
391 ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
392 
393 /////////////////////////////////////////////// OTHER CONSTANT CALLS TO PROBE VALUES ////////////////////////////////////////////////////
394 
395 	function getPlayerSubmissionFromCompetition(string gameID, uint8 competitionIndex, address playerAddress) constant returns(uint32 score, uint64 seed, uint32 duration, bytes32 proofHash, uint32 version, uint64 submitBlockNumber){
396 		var submission = games[gameID].competitions[competitionIndex].submissions[playerAddress];
397 		score = submission.score;
398 		seed = submission.seed;		
399 		duration = submission.durationRoundedDown;
400 		proofHash = submission.proofHash;
401 		version = submission.version;
402 		submitBlockNumber =submission.submitBlockNumber;
403 	}
404 	
405 	function getPlayersFromCompetition(string gameID, uint8 competitionIndex) constant returns(address[] playerAddresses, uint32 num){
406 		var competition = games[gameID].competitions[competitionIndex];
407 		playerAddresses = competition.players;
408 		num = competition.numPlayers;
409 	}
410 
411 	function getCompetitionValues(string gameID, uint8 competitionIndex) constant returns (
412 		uint128 jackpot,
413 		uint88 price,
414 		uint32 version,
415 		uint8 numPastBlocks,
416 		uint64 switchBlockNumber,
417 		uint32 numPlayers,
418 		uint32[] rewardsDistribution,
419 		uint8 houseDivider,
420 		uint16 lag,
421 		uint64 endTime,
422 		uint32 verificationWaitTime,
423 		uint8 _competitionIndex
424 	){
425 		var competition = games[gameID].competitions[competitionIndex];
426 		jackpot = competition.jackpot;
427 		price = competition.price;
428 		version = competition.version;
429 		numPastBlocks = competition.numPastBlocks;
430 		switchBlockNumber = competition.switchBlockNumber;
431 		numPlayers = competition.numPlayers;
432 		rewardsDistribution = competition.rewardsDistribution;
433 		houseDivider = competition.houseDivider;
434 		lag = competition.lag;
435 		endTime = competition.endTime;
436 		verificationWaitTime = competition.verificationWaitTime;
437 		_competitionIndex = competitionIndex;
438 	}
439 	
440 	function getCurrentCompetitionValues(string gameID) constant returns (
441 		uint128 jackpot,
442 		uint88 price,
443 		uint32 version,
444 		uint8 numPastBlocks,
445 		uint64 switchBlockNumber,
446 		uint32 numPlayers,
447 		uint32[] rewardsDistribution,
448 		uint8 houseDivider,
449 		uint16 lag,
450 		uint64 endTime,
451 		uint32 verificationWaitTime,
452 		uint8 _competitionIndex
453 	)
454 	{
455 		return getCompetitionValues(gameID,games[gameID].currentCompetitionIndex);
456 	}
457 }