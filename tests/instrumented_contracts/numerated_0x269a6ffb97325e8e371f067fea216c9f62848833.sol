1 pragma solidity ^0.4.24;
2 
3 contract BO3Kevents {
4 	event onBuying ( 
5 		address indexed _addr, 
6 		uint256 ethAmount, 
7 		uint256 flagAmount,
8 		uint256 playerFlags,
9 		uint256 ethOfRound,
10 		uint256 keysOfRound,
11 		uint256 potOfRound
12 	);
13 
14 	event onTimeAdding(
15 		uint256 startTime,
16 		uint256 endTime,
17 		uint256 newTimeInterval,
18 		uint256 currentInterval
19 	);
20 
21 	event onDiscount(
22 		address indexed _addr,
23 		uint256 randomValue,
24 		uint256 discountValue,
25 		bool getDiscount
26 	);
27 
28 	event onRoundEnding(
29 		address indexed winnerAddr,
30 		uint teamID,
31 		uint256 winValue,
32 		uint256 soldierValue,
33 		uint256 teamValue,
34 		uint256 nextRoundStartTime,
35 		uint256 nextRoundEndTime,
36 		uint256 nextRoundPot
37 	);
38 
39 	event onWithdraw(
40 		address indexed withdrawAddr,
41 		uint256 discountRevenue,
42 		uint256 refferedRevenue,
43 		uint256 winRevenue,
44 		uint256 flagRevenue
45 	);
46 	
47 }
48 
49 contract modularLong is BO3Kevents {}
50 
51 contract BO3KMain is modularLong {
52 
53 	using SafeMath for *;
54 	using BO3KCalcLong for uint256;
55 
56 	address constant public Admin = 0x3ac98F5Ea4946f58439d551E20Ed12091AF0F597;
57 	uint256 constant public LEADER_FEE = 0.03 ether;
58 
59 	uint256 private adminFee = 0;
60 	uint256 private adminRevenue = 0;
61 	uint256 private winTeamValue = 0;
62 
63 	uint private winTeamID = 0;
64 
65 	string constant public name = "Blockchain of 3 Kindoms";
66     string constant public symbol = "BO3K";
67 
68 	uint256 constant private DISCOUNT_PROB = 200;
69 
70 	uint256 constant private DISCOUNT_VALUE_5PER_OFF = 50;
71 	uint256 constant private DISCOUNT_VALUE_10PER_OFF = 100;
72 	uint256 constant private DISCOUNT_VALUE_15PER_OFF = 150;
73 
74 	uint256 constant private DENOMINATOR = 1000;
75 
76 	uint256 constant private _nextRoundSettingTime = 0 minutes;                
77     uint256 constant private _flagBuyingInterval = 30 seconds;              
78     uint256 constant private _maxDuration = 24 hours;
79 
80     uint256 constant private _officerCommission = 150;
81 
82     bool _activated = false;
83     bool CoolingMutex = false;
84 
85     uint256 public roundID;
86     uint public _teamID;
87 
88    	BO3Kdatasets.PotSplit potSplit;
89    	BO3Kdatasets.FlagInfo Flag;
90 
91     mapping (uint256 => BO3Kdatasets.Team) team;
92     mapping (uint256 => mapping (uint256 => BO3Kdatasets.TeamData) ) teamData;
93 
94     mapping (uint256 => BO3Kdatasets.Round) round;
95 
96     mapping (uint256 => mapping (address => BO3Kdatasets.Player) ) player;
97     mapping (address => uint256) playerFlags;
98     
99 
100 	constructor () public {
101 
102 		team[1] = BO3Kdatasets.Team(0, 500, 250, 150, 50, 50, 0, 0 );
103 		team[2] = BO3Kdatasets.Team(1, 250, 500, 150, 50, 50, 0, 0 );
104 		team[3] = BO3Kdatasets.Team(2, 375, 375, 150, 50, 50, 0, 0 );
105 
106 
107 		potSplit = BO3Kdatasets.PotSplit(450, 450, 50, 50);
108 
109 		// to-do: formation of flag and time update
110 		Flag = BO3Kdatasets.FlagInfo( 10000000000000000, now );
111 	}
112 
113 
114 	modifier isActivated() { 
115 		require ( _activated == true, "Did not activated" );
116 		_; 
117 	}
118 
119 
120 	modifier isHuman() {
121         address _addr = msg.sender;
122         uint256 _codeLength;
123         
124         // size of the code at address _addre
125         assembly {_codeLength := extcodesize(_addr)}
126         require(_codeLength == 0, "Addresses not owned by human are forbidden");
127         _;
128     }
129 
130 
131     modifier isWithinLimits(uint256 _eth) {
132         require(_eth >= 100000000000, "ground limit");
133         require(_eth <= 100000000000000000000000, "floor limit");
134         _;    
135     }
136 
137     modifier isPlayerRegistered(uint256 _roundID, address _addr) {
138     	require (player[_roundID][_addr].hasRegistered, "The Player Has Not Registered!");
139     	_;
140     }
141 	
142 
143 	function buyFlag( uint _tID, address refferedAddr ) isActivated() isHuman() isWithinLimits(msg.value) public payable {
144 
145 		require( 
146 			_tID == 1 ||
147 			_tID == 2 ||
148 			_tID == 3 ,
149 			"Invalid Team ID!"
150 		);
151 		
152 		// core( msg.sender, msg.value, _teamID );
153 		uint256 _now = now;
154 		
155 		_teamID = _tID;
156 
157 		// if it's around the legal time
158 		if( isLegalTime( _now ) ) {
159 
160 			// main logic of buying
161 			uint256 flagAmount = buyCore( refferedAddr );
162 
163 			// 30 sec interval
164 			updateTimer( flagAmount );
165 
166 		} else {
167 
168 			if( !isLegalTime( _now ) && round[roundID].ended == false ) {
169 				round[roundID].ended = true;
170 				endRound();
171 			} else {
172 				revert();
173 			}
174 
175 			// to-do:rcountdown for 1 hour to cool down
176 
177 		}
178 	}
179 
180 
181 
182 	function buyCore( address refferedAddr) isActivated() isWithinLimits( msg.value ) private returns( uint256 ) {
183 		
184 		// flag formula
185 		if( player[roundID][refferedAddr].isGeneral == false ) {
186 			refferedAddr = address(0);
187 		}
188 
189 		address _addr = msg.sender;
190 		uint256 _value = msg.value;
191 
192 		uint256 flagAmount = (round[roundID].totalEth).keysRec( _value );
193 		require ( flagAmount >= 10 ** 18, "At least 1 whole flag" );
194 
195 		// discount info
196 		bool getDiscount = false;
197 
198 		// update data of the round, contains total eth, total flags, and pot value
199 		round[roundID].totalEth = ( round[roundID].totalEth ).add( _value );
200 		round[roundID].totalFlags = ( round[roundID].totalFlags ).add( flagAmount );
201 
202 		// distribute value to the pot of the round. 50%, 25%, 37.5%, respectively
203 		round[roundID].pot = ( round[roundID].pot ).add( ( _value.mul( team[_teamID].city ) ).div( DENOMINATOR ) );
204 
205 		// update data of the team, contains total eth, total flags
206 		team[_teamID].totalEth = ( team[_teamID].totalEth ).add( _value );
207 		team[_teamID].totalFlags = ( team[_teamID].totalFlags ).add( flagAmount );
208 
209 		teamData[roundID][_teamID].totalEth = ( teamData[roundID][_teamID].totalEth ).add( _value );
210 		teamData[roundID][_teamID].totalFlags = ( teamData[roundID][_teamID].totalFlags ).add( flagAmount );
211 
212 		// if the user has participated in before, just add the total flag to the player
213 		if( player[roundID][_addr].hasRegistered ) {
214 			player[roundID][_addr].flags += flagAmount;
215 
216 		} else {
217 
218 			// user data
219 			player[roundID][_addr] = BO3Kdatasets.Player({
220 				addr: _addr,
221 				flags: flagAmount,
222 				win: 0,
223 				refferedRevenue: 0,
224 				discountRevenue: 0,
225 				teamID: _teamID,
226 				generalID: 0,
227 				payMask: 0,
228 				hasRegistered: true,
229 				isGeneral: false,
230 				isWithdrawed: false
231 			});
232 		}
233 
234 		// player's flags
235 		playerFlags[_addr] += flagAmount;
236 
237 		// winner ID of the round
238 		round[roundID].playerID = _addr;
239 
240 		// random discount
241 		uint256 randomValue = random();
242 		uint256 discountValue = 0;
243 
244 		// discount judgement
245 		if( randomValue < team[_teamID].grain ) {
246 
247 			if( _value >= 10 ** 17 && _value < 10 ** 18 ) {
248 				discountValue = (_value.mul( DISCOUNT_VALUE_5PER_OFF )).div( DENOMINATOR );
249 			} else if( _value >= 10 ** 18 && _value < 10 ** 19 ) {
250 				discountValue = (_value.mul( DISCOUNT_VALUE_10PER_OFF )).div( DENOMINATOR );
251 			} else if( _value >= 10 ** 19 ) {
252 				discountValue = (_value.mul( DISCOUNT_VALUE_15PER_OFF )).div( DENOMINATOR );
253 			} 
254 			// _addr.transfer( discountValue );
255 
256 			// add to win bonus if getting discount 
257 			player[roundID][_addr].discountRevenue = (player[roundID][_addr].discountRevenue).add( discountValue );
258 			getDiscount = true;
259 		}
260 
261 		// distribute the eth values
262 		// the distribution ratio differs from reffered address
263 		uint256 soldierEarn;
264 
265 		// flag distribution
266 		if( refferedAddr != address(0) && refferedAddr != _addr ) {
267 			
268 			// 25%, 50%, 37.5% for soldier, respectively
269             soldierEarn = (((_value.mul( team[_teamID].soldier ) / DENOMINATOR).mul(1000000000000000000)) / (round[roundID].totalFlags)).mul(flagAmount)/ (1000000000000000000);
270 
271 			// 5% for admin
272 			adminFee += ( _value.mul( team[_teamID].teamWelfare ) ).div( DENOMINATOR );
273 
274 			// 15% for officer
275 			player[roundID][refferedAddr].refferedRevenue += ( _value.mul( team[_teamID].officer ) ).div( DENOMINATOR );
276 		
277 			// paymask
278 			round[roundID].payMask += ( (_value.mul( team[_teamID].soldier ) / DENOMINATOR).mul(1000000000000000000)) / (round[roundID].totalFlags);
279             player[roundID][_addr].payMask = ((( (round[roundID].payMask).mul( flagAmount )) / (1000000000000000000)).sub(soldierEarn)).add(player[roundID][_addr].payMask);
280 
281 		} else {
282              // 40%, 65%, 52.5% for soldier, respectively
283             soldierEarn = (((_value.mul( team[_teamID].soldier + team[_teamID].officer ) / DENOMINATOR).mul(1000000000000000000)) / (round[roundID].totalFlags)).mul(flagAmount)/ (1000000000000000000);
284 
285 			// 5% for admin
286 			adminFee += ( _value.mul( team[_teamID].teamWelfare ) ).div( DENOMINATOR );
287 
288 			// paymask
289 			round[roundID].payMask += ( (_value.mul( team[_teamID].soldier + team[_teamID].officer ) / DENOMINATOR).mul(1000000000000000000)) / (round[roundID].totalFlags);
290             player[roundID][_addr].payMask = ((( (round[roundID].payMask).mul( flagAmount )) / (1000000000000000000)).sub(soldierEarn)).add(player[roundID][_addr].payMask);
291             
292 		}
293 
294 		emit BO3Kevents.onDiscount( 
295 			_addr,
296 			randomValue,
297 			discountValue,
298 			getDiscount
299 		);
300 
301 		emit BO3Kevents.onBuying( 
302 			_addr, 
303 			_value,
304 			flagAmount,
305 			playerFlags[_addr],
306 			round[roundID].totalEth,
307 			round[roundID].totalFlags,
308 			round[roundID].pot
309 		);
310 
311 		return flagAmount;
312 	}
313 
314 
315 	function updateTimer( uint256 flagAmount ) private {
316 		uint256 _now = now;
317 		// uint256 newTimeInterval = ( round[roundID].end ).add( _flagBuyingInterval ).sub( _now );
318 		uint256 newTimeInterval = ( round[roundID].end ).add( flagAmount.div(1000000000000000000).mul(10) ).sub( _now );
319 
320 		if( newTimeInterval > _maxDuration ) {
321 			newTimeInterval = _maxDuration;
322 		}
323 
324 		round[roundID].end = ( _now ).add( newTimeInterval );
325 		round[roundID].updatedTimeRounds = (round[roundID].updatedTimeRounds).add(flagAmount.div(1000000000000000000));
326 
327 		emit BO3Kevents.onTimeAdding(
328 			round[roundID].start,
329 			round[roundID].end,
330 			newTimeInterval,
331 			( round[roundID].end ).sub( _now )
332 		);
333 	}
334 
335 	function endRound() isActivated() private {
336 		// end round: get winner ID, team ID, pot, and values, respectively
337 		require ( !isLegalTime(now), "The round has not finished" );
338 		
339 		
340 		address winnerPlayerID = round[roundID].playerID;
341 		uint winnerTeamID = player[roundID][winnerPlayerID].teamID;
342 		uint256 potValue = round[roundID].pot;
343 
344 		uint256 winValue = ( potValue.mul( potSplit._winRatio ) ).div( DENOMINATOR );
345 		uint256 soldierValue = ( potValue.mul( potSplit._soldiersRatio ) ).div( DENOMINATOR );
346 		uint256 nextRoundValue = ( potValue.mul( potSplit._nextRatio ) ).div( DENOMINATOR );
347 		uint256 adminValue = ( potValue.mul( potSplit._adminRatio ) ).div( DENOMINATOR );
348 
349 		uint256 teamValue = team[winnerTeamID].totalEth;
350 
351 		if( winnerPlayerID == address(0x0) ) {
352 			Admin.transfer( potValue );
353 			nextRoundValue -= nextRoundValue;
354 			adminValue -= adminValue;
355 
356 		} else {
357 			player[roundID][winnerPlayerID].win = ( player[roundID][winnerPlayerID].win ).add( winValue );
358 			winTeamID = winnerTeamID;
359 		}
360 
361 		// Admin.transfer( adminValue + adminFee );
362 		adminRevenue = adminRevenue.add( adminValue ).add( adminFee );
363 		adminFee -= adminFee;
364 
365 		round[roundID].ended = true;
366 		roundID++;
367 
368 		round[roundID].start = now.add( _nextRoundSettingTime );
369 		round[roundID].end = (round[roundID].start).add( _maxDuration );
370 		round[roundID].pot = nextRoundValue;
371 
372 		emit BO3Kevents.onRoundEnding(
373 			winnerPlayerID,
374 			winnerTeamID,
375 			winValue,
376 			soldierValue,
377 			teamValue,
378 			round[roundID].start,
379 			round[roundID].end,
380 			round[roundID].pot
381 		);
382 
383 
384 	}
385 
386 
387 	function activate() public {
388 		//activation
389 		require (
390 			msg.sender == 0xABb29fd841c9B919c3B681194c6173f30Ff7055D,
391 			"msg sender error"
392 			);
393 
394 		require ( _activated == false, "Has activated" );
395 		
396 		_activated = true;
397 
398 		roundID = 1;
399 
400 		round[roundID].start = now;
401 		round[roundID].end = round[roundID].start + _maxDuration;
402 
403 		round[roundID].ended = false;
404 		round[roundID].updatedTimeRounds = 0;
405 	}
406 
407 	/*
408 		*
409 		* other functions
410 		*
411 	*/
412 
413 	// next flag value
414 	function getFlagPrice() public view returns( uint256 ) {
415 		// return ( ((round[roundID].totalFlags).add(1000000000000000000)).ethRec(1000000000000000000) );
416 		uint256 _now = now;
417 		if( isLegalTime( _now ) ) {
418 			return ( ((round[roundID].totalFlags).add( 1000000000000000000 )).ethRec( 1000000000000000000 ) );
419 		} else {
420 			return (75000000000000);
421 		}
422 	}
423 
424     function getFlagPriceByFlags (uint256 _roundID, uint256 _flagAmount) public view returns (uint256) {
425     	return round[_roundID].totalFlags.add(_flagAmount.mul( 10 ** 18 )).ethRec(_flagAmount.mul( 10 ** 18 ));
426 	}
427 
428 	function getRemainTime() isActivated() public view returns( uint256 ) {
429 		return ( (round[roundID].start).sub( now ) );
430 	}
431 	
432 	function isLegalTime( uint256 _now ) internal view returns( bool ) {
433 		return ( _now >= round[roundID].start && _now <= round[roundID].end );
434 	}
435 
436 	function isLegalTime() public view returns( bool ) {
437 		uint256 _now = now;
438 		return ( _now >= round[roundID].start && _now <= round[roundID].end );
439 	}
440 	
441 	function random() internal view returns( uint256 ) {
442         return uint256( uint256( keccak256( block.timestamp, block.difficulty ) ) % DENOMINATOR );
443 	}
444 
445 	function withdraw( uint256 _roundID ) isActivated() isHuman() public {
446 
447 		require ( player[_roundID][msg.sender].hasRegistered == true, "Not Registered Before" );
448 
449 		uint256 _discountRevenue = player[_roundID][msg.sender].discountRevenue;
450 		uint256 _refferedRevenue = player[_roundID][msg.sender].refferedRevenue;
451 		uint256 _winRevenue = player[_roundID][msg.sender].win;
452 		uint256 _flagRevenue = getFlagRevenue( _roundID ) ;
453 
454 		if( isLegalTime( now ) && !round[_roundID].ended ) {
455 			// to-do: withdraw function
456 			msg.sender.transfer( _discountRevenue + _refferedRevenue + _winRevenue + _flagRevenue );
457 
458 		} else {
459 			msg.sender.transfer( getTeamBonus(_roundID) + _discountRevenue + _refferedRevenue + _winRevenue + _flagRevenue );
460 		}
461 
462 		player[_roundID][msg.sender].discountRevenue = 0;
463 		player[_roundID][msg.sender].refferedRevenue = 0;
464 		player[_roundID][msg.sender].win = 0;
465 		player[_roundID][msg.sender].payMask = _flagRevenue.add(player[_roundID][msg.sender].payMask);
466 
467 		// if( round[_roundID].ended ) {
468 		// 	player[_roundID][msg.sender].flags = 0;
469 		// }
470 
471 		player[_roundID][msg.sender].isWithdrawed = true;
472 
473 
474 		emit BO3Kevents.onWithdraw(
475 			msg.sender,
476 			_discountRevenue,
477 			_refferedRevenue,
478 			_winRevenue,
479 			_flagRevenue
480 		);
481 		
482 	}
483 
484 	function becomeGeneral( uint _generalID ) public payable {
485         require( msg.value >= LEADER_FEE && player[roundID][msg.sender].hasRegistered, "Not enough money or not player" );
486 
487         msg.sender.transfer( LEADER_FEE );
488 
489        	player[roundID][msg.sender].isGeneral = true;
490        	player[roundID][msg.sender].generalID = _generalID;
491     }
492 
493 
494 	/* 
495 		* Getters for Website 
496 	*/
497 	function getIsActive () public view returns (bool)  {
498 		return _activated;
499 	}
500 
501 	function getPot (uint256 _roundID) public view returns (uint256)  {
502 		return round[_roundID].pot;
503 	}
504 
505 	function getTime (uint256 _roundID) public view returns (uint256, uint256)  {
506 		if( isLegalTime( now ) ) {
507 			return (round[_roundID].start, (round[_roundID].end).sub( now ) );
508 		} else {
509 			return (0, 0);
510 		}
511 	}
512 
513 	function getTeam (uint256 _roundID) public view returns (uint)  {
514 		return player[_roundID][msg.sender].teamID;
515 	}
516 
517 	function getTeamData (uint256 _roundID, uint _tID) public view returns (uint256, uint256)  {
518 		return (teamData[_roundID][_tID].totalFlags, teamData[_roundID][_tID].totalEth);
519 	}
520 
521 	function getTeamBonus (uint256 _roundID) public view returns (uint256) {
522 		// pot * 0.45 * (playerflag/teamflag)
523 		uint256 potValue = round[_roundID].pot;
524 		uint256 _winValue = ( potValue.mul( potSplit._soldiersRatio ) ).div( DENOMINATOR );
525 		uint _tID = player[_roundID][msg.sender].teamID;
526 		if( isLegalTime( now ) && (_roundID == roundID)) {
527 			// return ((player[_roundID][msg.sender].flags).mul(_winValue)).div( team[_tID].totalFlags );
528 			return ((player[_roundID][msg.sender].flags).mul(_winValue)).div( teamData[_roundID][_tID].totalFlags );
529 		} else {
530 			if( _tID != winTeamID ) {
531 				return 0;
532 			} else if (player[_roundID][msg.sender].isWithdrawed) {
533 				return 0;
534 			} else {
535 				// return ((player[_roundID][msg.sender].flags).mul(_winValue)).div( team[_tID].totalFlags );
536 				return ((player[_roundID][msg.sender].flags).mul(_winValue)).div( teamData[_roundID][_tID].totalFlags );
537 			}
538 		}
539 	}
540 
541 	function getBonus (uint256 _roundID) public view returns (uint256) {
542 		return player[_roundID][msg.sender].discountRevenue + player[_roundID][msg.sender].win;
543 	}
544 
545 	function getAllRevenue (uint256 _roundID) public view returns (uint256)  {
546 		return (getTeamBonus(_roundID) + player[_roundID][msg.sender].discountRevenue + player[_roundID][msg.sender].win + getFlagRevenue(_roundID) + player[_roundID][msg.sender].refferedRevenue) ;
547 	}
548 
549 	function getAllWithdrawableRevenue (uint256 _roundID) public view returns (uint256)  {
550 		if( isLegalTime(now) && ( _roundID == roundID ) )
551 			return (player[_roundID][msg.sender].discountRevenue + player[_roundID][msg.sender].win + getFlagRevenue(_roundID) + player[_roundID][msg.sender].refferedRevenue) ;
552 		
553 		return (getTeamBonus(_roundID) + player[_roundID][msg.sender].discountRevenue + player[_roundID][msg.sender].win + getFlagRevenue(_roundID) + player[_roundID][msg.sender].refferedRevenue) ;
554 		
555 	}
556 
557 	function getFlagRevenue(uint _round) public view returns(uint256)
558     {
559         return((((player[_round][msg.sender].flags).mul(round[_round].payMask)) / (1000000000000000000)).sub(player[_round][msg.sender].payMask));
560         // return((((round[_round].payMask).mul(player[_round][msg.sender].flags)) / (1000000000000000000)).sub(player[_round][msg.sender].payMask));
561     }
562 
563     function getGeneralProfit (uint256 _roundID) public view returns (uint256)  {
564 		return player[_roundID][msg.sender].refferedRevenue;
565 	}
566 
567 	function getDistributedETH (uint256 _roundID) public view returns (uint256)  {
568 		return (round[_roundID].totalEth).sub(round[_roundID].pot).sub(adminFee);
569 	}
570 
571 	function getGeneral (uint256 _roundID) public view returns (bool, uint)  {
572 		return (player[_roundID][msg.sender].isGeneral, player[_roundID][msg.sender].generalID);
573 	}
574 
575 	function getPlayerFlagAmount (uint256 _roundID) public view returns (uint256)  {
576 		return player[_roundID][msg.sender].flags;
577 	}
578 
579 	function getTotalFlagAmount (uint256 _roundID) public view returns (uint256)  {
580 		return round[_roundID].totalFlags;
581 	}
582 
583 	function getTotalEth (uint256 _roundID) public view returns (uint256)  {
584 		return round[_roundID].totalEth;
585 	}
586 
587 	function getUpdatedTime (uint256 _roundID) public view returns (uint)  {
588 		return round[_roundID].updatedTimeRounds;
589 	}
590 	
591 	
592 	function getRoundData( uint256 _roundID ) public view returns( address, uint256, uint256, bool ) {
593 		return ( round[_roundID].playerID, round[_roundID].pot, round[_roundID].totalEth, round[_roundID].ended );
594 	}
595 
596 	/* admin */
597 	function getAdminRevenue () public view returns (uint)  {
598 		return adminRevenue;
599 	}
600 	
601 	function withdrawAdminRevenue() public {
602 		require (msg.sender == Admin );
603 
604 		Admin.transfer( adminRevenue );
605 		adminRevenue = 0;
606 	}
607 	
608 }
609 
610 
611 library BO3KCalcLong {
612     using SafeMath for *;
613 
614     function keysRec(uint256 _curEth, uint256 _newEth) internal pure returns (uint256){
615         return(keys((_curEth).add(_newEth)).sub(keys(_curEth)));
616     }
617 
618     function ethRec(uint256 _curKeys, uint256 _sellKeys) internal pure returns (uint256) {
619         return((eth(_curKeys)).sub(eth(_curKeys.sub(_sellKeys))));
620     }
621 
622     function keys(uint256 _eth) internal pure returns(uint256) {
623         return ((((((_eth).mul(1000000000000000000)).mul(312500000000000000000000000)).add(5624988281256103515625000000000000000000000000000000000000000000)).sqrt()).sub(74999921875000000000000000000000)) / (156250000);
624     }
625 
626     function eth(uint256 _keys) internal pure returns(uint256) {
627         return ((78125000).mul(_keys.sq()).add(((149999843750000).mul(_keys.mul(1000000000000000000))) / (2))) / ((1000000000000000000).sq());
628     }
629 }
630 
631 
632 /**
633  * The BO3Kdatasets library does this and that...
634  */
635 library BO3Kdatasets {
636 
637 
638 	struct Team {
639 		uint teamID;
640 		uint256 city;
641 		uint256 soldier;
642 		uint256 officer;
643 		uint256 grain;
644 		uint256 teamWelfare;
645 		uint256 totalEth;
646 		uint256 totalFlags;
647 	}
648 
649 	struct TeamData {
650 		uint256 totalEth;
651 		uint256 totalFlags;
652 	}
653 	
654 
655 	struct PotSplit {
656         uint256 _winRatio;
657         uint256 _soldiersRatio;
658         uint256 _nextRatio;
659         uint256 _adminRatio;
660     }
661 	
662 	struct Round {
663         address playerID;   // pID of player in lead
664         // uint256 teamID;   // tID of team in lead
665         uint256 start;   // time round started
666         uint256 end;    // time ends/ended
667         uint256 totalFlags;   // keys
668         uint256 totalEth;    // total eth in
669         uint256 pot;    // eth to pot (during round) / final amount paid to winner (after round ends)
670         uint256 payMask;
671         uint updatedTimeRounds;
672         bool ended;     // has round end function been ran
673     }
674 
675     struct Player {
676         address addr;   // player 
677         uint256 flags; 	// flags
678         uint256 win;    // winnings vault
679         uint256 refferedRevenue;
680         uint256 discountRevenue;
681         uint256 payMask;
682         uint teamID;
683         bool hasRegistered;
684         bool isGeneral;
685         uint generalID;
686         bool isWithdrawed;
687     }
688 
689     struct FlagInfo {
690     	uint256 _flagValue;
691     	uint256 updateTime;
692     }
693     
694 	
695   
696 }
697 
698 
699 library SafeMath {
700 
701     function mul(uint256 a, uint256 b)  internal  pure  returns (uint256 c) {
702         if (a == 0) {
703             return 0;
704         }
705         c = a * b;
706         require(c / a == b, "SafeMath mul failed");
707         return c;
708     }
709     
710     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
711         require(b <= a, "SafeMath sub failed");
712         return a - b;
713     }
714 
715     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
716         c = a + b;
717         require(c >= a, "SafeMath add failed");
718         return c;
719     }
720 
721     function div(uint256 a, uint256 b) internal pure returns (uint256) {
722     	require(b > 0);
723 
724         uint256 c = a / b;
725     	require(a == b * c + a % b); // There is no case in which this doesn't hold
726     	return a / b;
727 	}
728     
729     function sqrt(uint256 x) internal pure returns (uint256 y) {
730         uint256 z = ((add(x,1)) / 2);
731         y = x;
732 
733         while (z < y) {
734             y = z;
735             z = ((add((x / z),z)) / 2);
736         }
737     }
738     
739     function sq(uint256 x) internal pure returns (uint256) {
740         return (mul(x,x));
741     }
742     
743     function pwr(uint256 x, uint256 y) internal pure returns (uint256) {
744         if (x==0)
745             return (0);
746 
747         else if (y==0)
748             return (1);
749 
750         else {
751             uint256 z = x;
752             for (uint256 i=1; i < y; i++)
753                 z = mul(z,x);
754             return (z);
755         }
756     }
757 }