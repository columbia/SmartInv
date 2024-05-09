1 pragma solidity ^0.4.21;
2 
3 
4 //**********************************************************************************
5 //	KITTYPILLAR CONTRACT
6 //**********************************************************************************
7 
8 contract KittyPillar {
9 	using SafeMath for uint256;
10 	
11 	address public owner;								//owner of this contract
12 	address public kittyCoreAddress;					//address of kittyCore
13 	KittyCoreInterface private kittyCore;				//kittycore reference
14 	
15 	
16 //**********************************************************************************
17 //	Events
18 //**********************************************************************************
19 	event PlayerJoined
20     (
21         address playerAddr,
22         uint256 pId,
23         uint256 timeStamp
24     );
25 	
26 	event KittyJoined
27     (
28         address ownerAddr,
29         uint256 kittyId,
30 		uint8 pillarIdx,
31         uint256 contribution,
32 		uint256 currentRound,
33         uint256 timeStamp
34     );
35 
36 	event RoundEnded
37 	(		
38 		uint256 currentRId,
39 		uint256 pillarWon,
40 		uint256 timeStamp
41 	);
42 	
43 	event Withdrawal
44 	(
45 		address playerAddr,
46         uint256 pId,
47 		uint256 amount,
48         uint256 timeStamp
49 	);
50 	
51 //**********************************************************************************
52 //	Modifiers
53 //**********************************************************************************
54 	modifier onlyOwner() {
55 		require(msg.sender == owner);
56 		_;
57 	}
58 		
59 //**********************************************************************************
60 //	Configs
61 //**********************************************************************************
62 	
63 	uint256 public contributionTarget_ = 100; //round target contributions
64 	bool public paused_ = false;
65 	uint256 public joinFee_ = 10000000000000000; //0.01 ether
66 	uint256 public totalDeveloperCut_ = 0;
67 	uint256 public minPower_ = 3; //minimum power of kitty
68 	uint256 public maxPower_ = 20; //maximum power of kitty
69 	
70 //**********************************************************************************
71 //	Data
72 //**********************************************************************************
73 	//***************************
74 	// Round
75 	//***************************
76 	uint256 public currentRId_;
77 	mapping (uint256 => KittyPillarDataSets.Round) public round_;		// (rId => data) round data
78 	
79 	//***************************
80 	// Player 
81 	//***************************
82 	uint256 private currentPId_;
83 	mapping (address => uint256) public pIdByAddress_;          										// (address => pId) returns player id by address
84 	mapping (uint8 => mapping (uint256 => KittyPillarDataSets.Pillar)) public pillarRounds_;			// (pillarIdx => roundId -> Pillar) returns pillar's round information
85 	mapping (uint256 => KittyPillarDataSets.Player) public players_;										// (pId => player) returns player information	
86 	mapping (uint256 => mapping (uint256 => uint256[])) public playerRounds_;		// (pId => roundId => uint256[]) returns player's round information
87 	mapping (uint256 => mapping (uint256 => KittyPillarDataSets.KittyRound)) public kittyRounds_;		// (kittyId => roundId => KittyRound) returns kitty's round information
88 	
89 	
90 //**********************************************************************************
91 //	Functions
92 //**********************************************************************************	
93 	constructor(address _kittyCoreAddress) public {
94 		owner = msg.sender; //init owner
95 		kittyCoreAddress = _kittyCoreAddress;
96         kittyCore = KittyCoreInterface(kittyCoreAddress);
97 		
98 		//start round
99 		currentRId_ = 1;
100 		round_[currentRId_].pot = 0;
101 		round_[currentRId_].targetContributions = contributionTarget_;
102 		round_[currentRId_].timeStarted = now;
103 		round_[currentRId_].ended = false;
104 	}
105 	
106 	function getPillarRoundsKitties(uint8 _pillarIdx, uint256 _rId) external view returns (uint256[]) {
107 		return pillarRounds_[_pillarIdx][_rId].kittyIds;
108 	}
109 	
110 	function getPlayerRoundsKitties(uint256 _pId, uint256 _rId) external view returns (uint256[]) {
111 		return playerRounds_[_pId][_rId];
112 	}
113 	
114 	function joinPillarWithEarnings(uint256 _kittyId, uint8 _pillarIdx, uint256 _rId) external {
115 		require(!paused_, "game is paused");
116 		
117 		require((_pillarIdx>=0)&&(_pillarIdx<=2), "there is no such pillar here");
118 
119         require(msg.sender == kittyCore.ownerOf(_kittyId), "sender not owner of kitty");
120 				
121 		uint256 _pId = pIdByAddress_[msg.sender];
122 		require(_pId!=0, "not an existing player"); //needs to be an existing player
123 		
124 		require(players_[_pId].totalEth >= joinFee_, "insufficient tokens in pouch for join fee");
125 		
126 		require(kittyRounds_[_kittyId][currentRId_].contribution==0, "kitty has already joined a pillar this round");
127 		
128 		require(_rId == currentRId_, "round has ended, wait for next round");
129 		
130 		players_[_pId].totalEth = players_[_pId].totalEth.sub(joinFee_); //deduct joinFee from winnings
131 		
132 		joinPillarCore(_pId, _kittyId, _pillarIdx);	
133 	}
134 	
135 	
136 	function joinPillar(uint256 _kittyId, uint8 _pillarIdx, uint256 _rId) external payable {
137 		require(!paused_, "game is paused");
138 
139         require(msg.value == joinFee_, "incorrect join fee");
140 		
141 		require((_pillarIdx>=0)&&(_pillarIdx<=2), "there is no such pillar here");
142 		
143         require(msg.sender == kittyCore.ownerOf(_kittyId), "sender not owner of kitty");
144 		
145 		require(kittyRounds_[_kittyId][currentRId_].contribution==0, "kitty has already joined a pillar this round");
146 		
147 		require(_rId == currentRId_, "round has ended, wait for next round");
148 		
149 		uint256 _pId = pIdByAddress_[msg.sender];
150 		//add player if he/she doesn't exists in game
151         if (_pId == 0) {
152 			currentPId_ = currentPId_.add(1);
153 			pIdByAddress_[msg.sender] = currentPId_;
154 			players_[currentPId_].ownerAddr = msg.sender;
155 			_pId = currentPId_;
156 			
157 			emit PlayerJoined
158 			(
159 				msg.sender,
160 				_pId,
161 				now
162 			);
163 		}
164 		
165 		joinPillarCore(_pId, _kittyId, _pillarIdx);	
166 	}
167 	
168 	function joinPillarCore(uint256 _pId, uint256 _kittyId, uint8 _pillarIdx) private {
169 		//record kitty under player for this round
170 		playerRounds_[_pId][currentRId_].push(_kittyId);
171 						
172 		//calculate kitty's power
173 		uint256 minPower = minPower_;
174 		if (pillarRounds_[_pillarIdx][currentRId_].totalContributions<(round_[currentRId_].targetContributions/2)) { //pillar under half, check other pillars
175 			uint8 i;
176 			for (i=0; i<3; i++) {
177 				if (i!=_pillarIdx) {
178 					if (pillarRounds_[i][currentRId_].totalContributions >= (round_[currentRId_].targetContributions/2)) {
179 						minPower = maxPower_/2; //minimum power increases, so to help the low pillar grow faster
180 						break;
181 					}
182 				}
183 			}
184 		}
185 				
186 		uint256 genes;
187         ( , , , , , , , , , genes) = kittyCore.getKitty(_kittyId);		
188 		uint256 _contribution = ((getKittyPower(genes) % maxPower_) + minPower); //from min to max power
189 		
190 		// add to kitty round
191 		uint256 joinedTime = now;
192 		kittyRounds_[_kittyId][currentRId_].pillar = _pillarIdx;
193 		kittyRounds_[_kittyId][currentRId_].contribution = _contribution;
194 		kittyRounds_[_kittyId][currentRId_].kittyOwnerPId = _pId;
195 		kittyRounds_[_kittyId][currentRId_].timeStamp = joinedTime;
196 		
197 		// update current round's info
198 		pillarRounds_[_pillarIdx][currentRId_].totalContributions = pillarRounds_[_pillarIdx][currentRId_].totalContributions.add(_contribution);
199 		pillarRounds_[_pillarIdx][currentRId_].kittyIds.push(_kittyId);
200 				
201 		//update current round pot
202 		totalDeveloperCut_ = totalDeveloperCut_.add((joinFee_/100).mul(4)); //4% developer fee
203 		round_[currentRId_].pot = round_[currentRId_].pot.add((joinFee_/100).mul(96)); //update pot minus fee
204 		
205 		emit KittyJoined
206 		(
207 			msg.sender,
208 			_kittyId,
209 			_pillarIdx,
210 			_contribution,
211 			currentRId_,
212 			joinedTime
213 		);
214 		
215 		//if meet target contribution, end round
216 		if (pillarRounds_[_pillarIdx][currentRId_].totalContributions >= round_[currentRId_].targetContributions) {			
217 			endRound(_pillarIdx);
218 		}	
219 	}
220 	
221 	
222 	function getKittyPower(uint256 kittyGene) private view returns(uint256) {
223 		return (uint(keccak256(abi.encodePacked(kittyGene,
224 			blockhash(block.number - 1),
225 			blockhash(block.number - 2),
226 			blockhash(block.number - 4),
227 			blockhash(block.number - 7))
228 		)));
229 	}
230 	
231 	
232 	function endRound(uint8 _wonPillarIdx) private {
233 				
234 		//distribute pot
235 		uint256 numWinners = pillarRounds_[_wonPillarIdx][currentRId_].kittyIds.length;
236 						
237 		
238 		uint256 numFirstMovers = numWinners / 2; //half but rounded floor
239 		
240 		//perform round up if required
241 		if ((numFirstMovers * 2) < numWinners) {
242 			numFirstMovers = numFirstMovers.add(1);
243 		}
244 		
245 		uint256 avgTokensPerWinner = round_[currentRId_].pot/numWinners;
246 		
247 		//first half (round up) of the pillar kitties get 20% extra off the pot to reward the precision, strength and valor!
248 		uint256 tokensPerFirstMovers = avgTokensPerWinner.add(avgTokensPerWinner.mul(2) / 10);
249 		
250 		//the rest of the pot is divided by the rest of the followers
251 		uint256 tokensPerFollowers = (round_[currentRId_].pot - (numFirstMovers.mul(tokensPerFirstMovers))) / (numWinners-numFirstMovers);
252 		
253 		uint256 totalEthCount = 0;
254 								
255 		for(uint256 i = 0; i < numWinners; i++) {
256 			uint256 kittyId = pillarRounds_[_wonPillarIdx][currentRId_].kittyIds[i];
257 			if (i < numFirstMovers) {
258 				players_[kittyRounds_[kittyId][currentRId_].kittyOwnerPId].totalEth = players_[kittyRounds_[kittyId][currentRId_].kittyOwnerPId].totalEth.add(tokensPerFirstMovers);
259 				totalEthCount = totalEthCount.add(tokensPerFirstMovers);
260 			} else {
261 				players_[kittyRounds_[kittyId][currentRId_].kittyOwnerPId].totalEth = players_[kittyRounds_[kittyId][currentRId_].kittyOwnerPId].totalEth.add(tokensPerFollowers);
262 				totalEthCount = totalEthCount.add(tokensPerFollowers);
263 			}			
264 		}
265 		
266 				
267 		//set round param to end
268 		round_[currentRId_].pillarWon = _wonPillarIdx;
269 		round_[currentRId_].timeEnded = now;
270 		round_[currentRId_].ended = true;
271 
272 		emit RoundEnded(
273 			currentRId_,
274 			_wonPillarIdx,
275 			round_[currentRId_].timeEnded
276 		);		
277 		
278 		//start next round
279 		currentRId_ = currentRId_.add(1);
280 		round_[currentRId_].pot = 0;
281 		round_[currentRId_].targetContributions = contributionTarget_;
282 		round_[currentRId_].timeStarted = now;
283 		round_[currentRId_].ended = false;		
284 	}
285 	
286 	function withdrawWinnings() external {
287 		uint256 _pId = pIdByAddress_[msg.sender];
288 		//player doesn't exists in game
289 		require(_pId != 0, "player doesn't exist in game, don't disturb");
290 		require(players_[_pId].totalEth > 0, "there is nothing to withdraw");
291 		
292 		uint256 withdrawalSum = players_[_pId].totalEth;
293 		players_[_pId].totalEth = 0; //all is gone from contract to user wallet
294 		
295 		msg.sender.transfer(withdrawalSum); //byebye ether
296 		
297 		emit Withdrawal
298 		(
299 			msg.sender,
300 			_pId,
301 			withdrawalSum,
302 			now
303 		);
304 	}
305 
306 
307 //**********************************************************************************
308 //	Admin Functions
309 //**********************************************************************************	
310 
311 
312 	function setJoinFee(uint256 _joinFee) external onlyOwner {
313 		joinFee_ = _joinFee;
314 	}
315 	
316 	function setPlayConfigs(uint256 _contributionTarget, uint256 _maxPower, uint256 _minPower) external onlyOwner {
317 		require(_minPower.mul(2) <= _maxPower, "min power cannot be more than half of max power");
318 		contributionTarget_ = _contributionTarget;
319 		maxPower_ = _maxPower;
320 		minPower_ = _minPower;
321 	}
322 		
323 	function setKittyCoreAddress(address _kittyCoreAddress) external onlyOwner {
324 		kittyCoreAddress = _kittyCoreAddress;
325         kittyCore = KittyCoreInterface(kittyCoreAddress);
326 	}
327 	
328 	/**
329 	* @dev Current owner can transfer control of the contract to a newOwner.
330 	* @param newOwner The address to transfer ownership to.
331 	*/
332 	function transferOwnership(address newOwner) external onlyOwner {
333 		require(newOwner != address(0));
334 		owner = newOwner;
335 	}
336 	
337 	function setPaused(bool _paused) external onlyOwner {
338 		paused_ = _paused;
339 	}
340 	
341 	function withdrawDeveloperCut() external onlyOwner {
342 		address thisAddress = this;
343 		uint256 balance = thisAddress.balance;
344 		uint256 withdrawalSum = totalDeveloperCut_;
345 
346 		if (balance >= withdrawalSum) {
347 			totalDeveloperCut_ = 0;
348 			owner.transfer(withdrawalSum);
349 		}
350 	}
351 	
352 }
353 
354 
355 
356 //**********************************************************************************
357 //	STRUCTS
358 //**********************************************************************************
359 library KittyPillarDataSets {	
360 	struct Round {
361 		uint256 pot;						// total Eth in pot
362 		uint256 targetContributions;		// target contribution to end game
363 		uint8 pillarWon;					// idx of pillar which won this round
364 		uint256 timeStarted;					// time round started
365 		uint256 timeEnded;					// time round ended
366 		bool ended;							// has round ended
367 	}
368 	
369 	struct Pillar {
370 		uint256 totalContributions;
371 		uint256[] kittyIds;
372 	}
373 	
374 	struct Player {
375         address ownerAddr; 	// player address
376 		uint256 totalEth;	// total Eth won and not yet claimed
377     }
378 	
379 	struct KittyRound {
380 		uint8 pillar;
381 		uint256 contribution;
382 		uint256 kittyOwnerPId;
383 		uint256 timeStamp;
384 	}	
385 }
386 	
387 
388 
389 //**********************************************************************************
390 //	INTERFACES
391 //**********************************************************************************
392 
393 //Cryptokitties interface
394 interface KittyCoreInterface {
395     function getKitty(uint _id) external returns (
396         bool isGestating,
397         bool isReady,
398         uint256 cooldownIndex,
399         uint256 nextActionAt,
400         uint256 siringWithId,
401         uint256 birthTime,
402         uint256 matronId,
403         uint256 sireId,
404         uint256 generation,
405         uint256 genes
406     );
407 
408     function ownerOf(uint256 _tokenId) external view returns (address owner);
409 }
410 
411 
412 
413 
414 //**********************************************************************************
415 //	LIBRARIES
416 //**********************************************************************************
417 
418 /**
419  * @title SafeMath from OpenZeppelin
420  * @dev Math operations with safety checks that throw on error
421  * Changes:
422  * - changed asserts to require with error log
423  * - removed div
424  */
425 library SafeMath {
426   /**
427   * @dev Multiplies two numbers, throws on overflow.
428   */
429   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
430     if (a == 0) {
431       return 0;
432     }
433     c = a * b;
434 	require(c / a == b, "SafeMath mul failed");
435     return c;
436   }
437 
438   /**
439   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
440   */
441   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
442     require(b <= a, "SafeMath sub failed");
443     return a - b;
444   }
445 
446   /**
447   * @dev Adds two numbers, throws on overflow.
448   */
449   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
450     c = a + b;
451     require(c >= a, "SafeMath add failed");
452     return c;
453   }
454 }