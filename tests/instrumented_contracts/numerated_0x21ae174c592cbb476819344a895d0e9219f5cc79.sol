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
76 	uint256 constant private _nextRoundSettingTime = 1 hours;                
77     uint256 constant private _flagBuyingInterval = 30 seconds;              
78     uint256 constant private _maxDuration = 24 hours;
79 
80     uint256 constant private _officerCommission = 150;
81 
82     bool _activated = false;
83     bool mutex = false;
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
161 			buyCore( refferedAddr );
162 
163 			// 30 sec interval
164 			updateTimer();
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
182 	function buyCore( address refferedAddr) isActivated() isWithinLimits( msg.value ) private {
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
310 	}
311 
312 
313 	function updateTimer() private {
314 		uint256 _now = now;
315 		uint256 newTimeInterval = ( round[roundID].end ).add( _flagBuyingInterval ).sub( _now );
316 
317 		if( newTimeInterval > _maxDuration ) {
318 			newTimeInterval = _maxDuration;
319 		}
320 
321 		round[roundID].end = ( _now ).add( newTimeInterval );
322 		round[roundID].updatedTimeRounds = (round[roundID].updatedTimeRounds).add(1);
323 
324 		emit BO3Kevents.onTimeAdding(
325 			round[roundID].start,
326 			round[roundID].end,
327 			newTimeInterval,
328 			( round[roundID].end ).sub( _now )
329 		);
330 	}
331 
332 	function endRound() isActivated() private {
333 		// end round: get winner ID, team ID, pot, and values, respectively
334 		require ( !isLegalTime(now), "The round has not finished" );
335 		
336 		
337 		address winnerPlayerID = round[roundID].playerID;
338 		uint winnerTeamID = player[roundID][winnerPlayerID].teamID;
339 		uint256 potValue = round[roundID].pot;
340 
341 		uint256 winValue = ( potValue.mul( potSplit._winRatio ) ).div( DENOMINATOR );
342 		uint256 soldierValue = ( potValue.mul( potSplit._soldiersRatio ) ).div( DENOMINATOR );
343 		uint256 nextRoundValue = ( potValue.mul( potSplit._nextRatio ) ).div( DENOMINATOR );
344 		uint256 adminValue = ( potValue.mul( potSplit._adminRatio ) ).div( DENOMINATOR );
345 
346 		uint256 teamValue = team[winnerTeamID].totalEth;
347 
348 		if( winnerPlayerID == address(0x0) ) {
349 			Admin.transfer( potValue );
350 			nextRoundValue -= nextRoundValue;
351 
352 		} else {
353 			player[roundID][winnerPlayerID].win = ( player[roundID][winnerPlayerID].win ).add( winValue );
354 			winTeamID = winnerTeamID;
355 		}
356 
357 		// Admin.transfer( adminValue + adminFee );
358 		adminRevenue = adminRevenue.add( adminValue ).add( adminFee );
359 		adminFee -= adminFee;
360 
361 		round[roundID].ended = true;
362 		roundID++;
363 
364 		round[roundID].start = now.add( _nextRoundSettingTime );
365 		round[roundID].end = (round[roundID].start).add( _maxDuration );
366 		round[roundID].pot = nextRoundValue;
367 
368 		emit BO3Kevents.onRoundEnding(
369 			winnerPlayerID,
370 			winnerTeamID,
371 			winValue,
372 			soldierValue,
373 			teamValue,
374 			round[roundID].start,
375 			round[roundID].end,
376 			round[roundID].pot
377 		);
378 
379 	}
380 
381 
382 	function activate() public {
383 		//activation
384 		require (
385 			msg.sender == 0xABb29fd841c9B919c3B681194c6173f30Ff7055D,
386 			"msg sender error"
387 			);
388 
389 		require ( _activated == false, "Has activated" );
390 		
391 		_activated = true;
392 
393 		roundID = 1;
394 
395 		round[roundID].start = now;
396 		round[roundID].end = round[roundID].start + _maxDuration;
397 
398 		round[roundID].ended = false;
399 		round[roundID].updatedTimeRounds = 0;
400 	}
401 
402 	/*
403 		*
404 		* other functions
405 		*
406 	*/
407 
408 	// next flag value
409 	function getFlagPrice() public view returns( uint256 ) {
410 		// return ( ((round[roundID].totalFlags).add(1000000000000000000)).ethRec(1000000000000000000) );
411 		uint256 _now = now;
412 		if( isLegalTime( _now ) ) {
413 			return ( ((round[roundID].totalFlags).add( 1000000000000000000 )).ethRec( 1000000000000000000 ) );
414 		} else {
415 			return (75000000000000);
416 		}
417 	}
418 
419     function getFlagPriceByFlags (uint256 _roundID, uint256 _flagAmount) public view returns (uint256) {
420     	return round[_roundID].totalFlags.add(_flagAmount.mul( 10 ** 18 )).ethRec(_flagAmount.mul( 10 ** 18 ));
421 	}
422 
423 	function getRemainTime() isActivated() public view returns( uint256 ) {
424 		return ( (round[roundID].start).sub( now ) );
425 	}
426 	
427 	function isLegalTime( uint256 _now ) internal view returns( bool ) {
428 		return ( _now >= round[roundID].start && _now <= round[roundID].end );
429 	}
430 
431 	function isLegalTime() public view returns( bool ) {
432 		uint256 _now = now;
433 		return ( _now >= round[roundID].start && _now <= round[roundID].end );
434 	}
435 	
436 	function random() internal view returns( uint256 ) {
437         return uint256( uint256( keccak256( block.timestamp, block.difficulty ) ) % DENOMINATOR );
438 	}
439 
440 	function withdraw( uint256 _roundID ) isActivated() isHuman() public {
441 
442 		require ( player[_roundID][msg.sender].hasRegistered == true, "Not Registered Before" );
443 
444 		uint256 _discountRevenue = player[_roundID][msg.sender].discountRevenue;
445 		uint256 _refferedRevenue = player[_roundID][msg.sender].refferedRevenue;
446 		uint256 _winRevenue = player[_roundID][msg.sender].win;
447 		uint256 _flagRevenue = getFlagRevenue( _roundID ) ;
448 
449 		if( isLegalTime( now ) && !round[_roundID].ended ) {
450 			// to-do: withdraw function
451 			msg.sender.transfer( _discountRevenue + _refferedRevenue + _winRevenue + _flagRevenue );
452 
453 		} else {
454 			msg.sender.transfer( getTeamBonus(_roundID) + _discountRevenue + _refferedRevenue + _winRevenue + _flagRevenue );
455 		}
456 
457 		player[_roundID][msg.sender].discountRevenue = 0;
458 		player[_roundID][msg.sender].refferedRevenue = 0;
459 		player[_roundID][msg.sender].win = 0;
460 		player[_roundID][msg.sender].payMask = _flagRevenue.add(player[_roundID][msg.sender].payMask);
461 
462 		// if( round[_roundID].ended ) {
463 		// 	player[_roundID][msg.sender].flags = 0;
464 		// }
465 
466 		player[_roundID][msg.sender].isWithdrawed = true;
467 
468 
469 		emit BO3Kevents.onWithdraw(
470 			msg.sender,
471 			_discountRevenue,
472 			_refferedRevenue,
473 			_winRevenue,
474 			_flagRevenue
475 		);
476 		
477 	}
478 
479 	function becomeGeneral( uint _generalID ) public payable {
480         require( msg.value >= LEADER_FEE && player[roundID][msg.sender].hasRegistered, "Not enough money or not player" );
481 
482         msg.sender.transfer( LEADER_FEE );
483 
484        	player[roundID][msg.sender].isGeneral = true;
485        	player[roundID][msg.sender].generalID = _generalID;
486     }
487 
488 
489 	/* 
490 		* Getters for Website 
491 	*/
492 	function getIsActive () public view returns (bool)  {
493 		return _activated;
494 	}
495 
496 	function getPot (uint256 _roundID) public view returns (uint256)  {
497 		return round[_roundID].pot;
498 	}
499 
500 	function getTime (uint256 _roundID) public view returns (uint256, uint256)  {
501 		if( isLegalTime( now ) ) {
502 			return (round[_roundID].start, (round[_roundID].end).sub( now ) );
503 		} else {
504 			return (0, 0);
505 		}
506 	}
507 
508 	function getTeam (uint256 _roundID) public view returns (uint)  {
509 		return player[_roundID][msg.sender].teamID;
510 	}
511 
512 	function getTeamData (uint256 _roundID, uint _tID) public view returns (uint256, uint256)  {
513 		return (teamData[_roundID][_tID].totalFlags, teamData[_roundID][_tID].totalEth);
514 	}
515 
516 	function getTeamBonus (uint256 _roundID) public view returns (uint256) {
517 		// pot * 0.45 * (playerflag/teamflag)
518 		uint256 potValue = round[_roundID].pot;
519 		uint256 _winValue = ( potValue.mul( potSplit._soldiersRatio ) ).div( DENOMINATOR );
520 		uint _tID = player[_roundID][msg.sender].teamID;
521 		if( isLegalTime( now ) && (_roundID == roundID)) {
522 			// return ((player[_roundID][msg.sender].flags).mul(_winValue)).div( team[_tID].totalFlags );
523 			return ((player[_roundID][msg.sender].flags).mul(_winValue)).div( teamData[_roundID][_tID].totalFlags );
524 		} else {
525 			if( _tID != winTeamID ) {
526 				return 0;
527 			} else if (player[_roundID][msg.sender].isWithdrawed) {
528 				return 0;
529 			} else {
530 				// return ((player[_roundID][msg.sender].flags).mul(_winValue)).div( team[_tID].totalFlags );
531 				return ((player[_roundID][msg.sender].flags).mul(_winValue)).div( teamData[_roundID][_tID].totalFlags );
532 			}
533 		}
534 	}
535 
536 	function getBonus (uint256 _roundID) public view returns (uint256) {
537 		return player[_roundID][msg.sender].discountRevenue + player[_roundID][msg.sender].win;
538 	}
539 
540 	function getAllRevenue (uint256 _roundID) public view returns (uint256)  {
541 		return (getTeamBonus(_roundID) + player[_roundID][msg.sender].discountRevenue + player[_roundID][msg.sender].win + getFlagRevenue(_roundID) + player[_roundID][msg.sender].refferedRevenue) ;
542 	}
543 
544 	function getAllWithdrawableRevenue (uint256 _roundID) public view returns (uint256)  {
545 		if( isLegalTime(now) && ( _roundID == roundID ) )
546 			return (player[_roundID][msg.sender].discountRevenue + player[_roundID][msg.sender].win + getFlagRevenue(_roundID) + player[_roundID][msg.sender].refferedRevenue) ;
547 		
548 		return (getTeamBonus(_roundID) + player[_roundID][msg.sender].discountRevenue + player[_roundID][msg.sender].win + getFlagRevenue(_roundID) + player[_roundID][msg.sender].refferedRevenue) ;
549 		
550 	}
551 
552 	function getFlagRevenue(uint _round) public view returns(uint256)
553     {
554         return((((player[_round][msg.sender].flags).mul(round[_round].payMask)) / (1000000000000000000)).sub(player[_round][msg.sender].payMask));
555         // return((((round[_round].payMask).mul(player[_round][msg.sender].flags)) / (1000000000000000000)).sub(player[_round][msg.sender].payMask));
556     }
557 
558     function getGeneralProfit (uint256 _roundID) public view returns (uint256)  {
559 		return player[_roundID][msg.sender].refferedRevenue;
560 	}
561 
562 	function getDistributedETH (uint256 _roundID) public view returns (uint256)  {
563 		return (round[_roundID].totalEth).sub(round[_roundID].pot).sub(adminFee);
564 	}
565 
566 	function getGeneral (uint256 _roundID) public view returns (bool, uint)  {
567 		return (player[_roundID][msg.sender].isGeneral, player[_roundID][msg.sender].generalID);
568 	}
569 
570 	function getPlayerFlagAmount (uint256 _roundID) public view returns (uint256)  {
571 		return player[_roundID][msg.sender].flags;
572 	}
573 
574 	function getTotalFlagAmount (uint256 _roundID) public view returns (uint256)  {
575 		return round[_roundID].totalFlags;
576 	}
577 
578 	function getTotalEth (uint256 _roundID) public view returns (uint256)  {
579 		return round[_roundID].totalEth;
580 	}
581 
582 	function getUpdatedTime (uint256 _roundID) public view returns (uint)  {
583 		return round[_roundID].updatedTimeRounds;
584 	}
585 	
586 	
587 	function getRoundData( uint256 _roundID ) public view returns( address, uint256, uint256, bool ) {
588 		return ( round[_roundID].playerID, round[_roundID].pot, round[_roundID].totalEth, round[_roundID].ended );
589 	}
590 
591 	/* admin */
592 	function getAdminRevenue () public view returns (uint)  {
593 		return adminRevenue;
594 	}
595 	
596 	function withdrawAdminRevenue() public {
597 		require (msg.sender == Admin );
598 
599 		Admin.transfer( adminRevenue );
600 		adminRevenue = 0;
601 	}
602 	
603 }
604 
605 
606 library BO3KCalcLong {
607     using SafeMath for *;
608 
609     function keysRec(uint256 _curEth, uint256 _newEth) internal pure returns (uint256){
610         return(keys((_curEth).add(_newEth)).sub(keys(_curEth)));
611     }
612 
613     function ethRec(uint256 _curKeys, uint256 _sellKeys) internal pure returns (uint256) {
614         return((eth(_curKeys)).sub(eth(_curKeys.sub(_sellKeys))));
615     }
616 
617     function keys(uint256 _eth) internal pure returns(uint256) {
618         return ((((((_eth).mul(1000000000000000000)).mul(312500000000000000000000000)).add(5624988281256103515625000000000000000000000000000000000000000000)).sqrt()).sub(74999921875000000000000000000000)) / (156250000);
619     }
620 
621     function eth(uint256 _keys) internal pure returns(uint256) {
622         return ((78125000).mul(_keys.sq()).add(((149999843750000).mul(_keys.mul(1000000000000000000))) / (2))) / ((1000000000000000000).sq());
623     }
624 }
625 
626 
627 /**
628  * The BO3Kdatasets library does this and that...
629  */
630 library BO3Kdatasets {
631 
632 
633 	struct Team {
634 		uint teamID;
635 		uint256 city;
636 		uint256 soldier;
637 		uint256 officer;
638 		uint256 grain;
639 		uint256 teamWelfare;
640 		uint256 totalEth;
641 		uint256 totalFlags;
642 	}
643 
644 	struct TeamData {
645 		uint256 totalEth;
646 		uint256 totalFlags;
647 	}
648 	
649 
650 	struct PotSplit {
651         uint256 _winRatio;
652         uint256 _soldiersRatio;
653         uint256 _nextRatio;
654         uint256 _adminRatio;
655     }
656 	
657 	struct Round {
658         address playerID;   // pID of player in lead
659         // uint256 teamID;   // tID of team in lead
660         uint256 start;   // time round started
661         uint256 end;    // time ends/ended
662         uint256 totalFlags;   // keys
663         uint256 totalEth;    // total eth in
664         uint256 pot;    // eth to pot (during round) / final amount paid to winner (after round ends)
665         uint256 payMask;
666         uint updatedTimeRounds;
667         bool ended;     // has round end function been ran
668     }
669 
670     struct Player {
671         address addr;   // player 
672         uint256 flags; 	// flags
673         uint256 win;    // winnings vault
674         uint256 refferedRevenue;
675         uint256 discountRevenue;
676         uint256 payMask;
677         uint teamID;
678         bool hasRegistered;
679         bool isGeneral;
680         uint generalID;
681         bool isWithdrawed;
682     }
683 
684     struct FlagInfo {
685     	uint256 _flagValue;
686     	uint256 updateTime;
687     }
688     
689 	
690   
691 }
692 
693 
694 library SafeMath {
695 
696     function mul(uint256 a, uint256 b)  internal  pure  returns (uint256 c) {
697         if (a == 0) {
698             return 0;
699         }
700         c = a * b;
701         require(c / a == b, "SafeMath mul failed");
702         return c;
703     }
704     
705     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
706         require(b <= a, "SafeMath sub failed");
707         return a - b;
708     }
709 
710     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
711         c = a + b;
712         require(c >= a, "SafeMath add failed");
713         return c;
714     }
715 
716     function div(uint256 a, uint256 b) internal pure returns (uint256) {
717     	require(b > 0);
718 
719         uint256 c = a / b;
720     	require(a == b * c + a % b); // There is no case in which this doesn't hold
721     	return a / b;
722 	}
723     
724     function sqrt(uint256 x) internal pure returns (uint256 y) {
725         uint256 z = ((add(x,1)) / 2);
726         y = x;
727 
728         while (z < y) {
729             y = z;
730             z = ((add((x / z),z)) / 2);
731         }
732     }
733     
734     function sq(uint256 x) internal pure returns (uint256) {
735         return (mul(x,x));
736     }
737     
738     function pwr(uint256 x, uint256 y) internal pure returns (uint256) {
739         if (x==0)
740             return (0);
741 
742         else if (y==0)
743             return (1);
744 
745         else {
746             uint256 z = x;
747             for (uint256 i=1; i < y; i++)
748                 z = mul(z,x);
749             return (z);
750         }
751     }
752 }