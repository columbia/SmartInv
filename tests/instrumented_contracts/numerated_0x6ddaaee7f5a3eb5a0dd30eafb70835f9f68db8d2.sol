1 pragma solidity ^0.4.25;
2 
3 
4 /*
5                                                                   
6 SuperCountries War Game #2 - Nuke countries and share a huge war chest                                           
7 SuperCountries Original Game #1 - Each player earns ether forever
8 
9 
10 ███████╗██╗   ██╗██████╗ ███████╗██████╗                                    
11 ██╔════╝██║   ██║██╔══██╗██╔════╝██╔══██╗                                   
12 ███████╗██║   ██║██████╔╝█████╗  ██████╔╝                                   
13 ╚════██║██║   ██║██╔═══╝ ██╔══╝  ██╔══██╗                                   
14 ███████║╚██████╔╝██║     ███████╗██║  ██║                                   
15 ╚══════╝ ╚═════╝ ╚═╝     ╚══════╝╚═╝  ╚═╝                                   
16                                                                             
17      ██████╗ ██████╗ ██╗   ██╗███╗   ██╗████████╗██████╗ ██╗███████╗███████╗
18     ██╔════╝██╔═══██╗██║   ██║████╗  ██║╚══██╔══╝██╔══██╗██║██╔════╝██╔════╝
19     ██║     ██║   ██║██║   ██║██╔██╗ ██║   ██║   ██████╔╝██║█████╗  ███████╗
20     ██║     ██║   ██║██║   ██║██║╚██╗██║   ██║   ██╔══██╗██║██╔══╝  ╚════██║
21     ╚██████╗╚██████╔╝╚██████╔╝██║ ╚████║   ██║   ██║  ██║██║███████╗███████║
22      ╚═════╝ ╚═════╝  ╚═════╝ ╚═╝  ╚═══╝   ╚═╝   ╚═╝  ╚═╝╚═╝╚══════╝╚══════╝
23                                                                             
24           ██╗    ██╗ █████╗ ██████╗                                         
25           ██║    ██║██╔══██╗██╔══██╗                                        
26 █████╗    ██║ █╗ ██║███████║██████╔╝    █████╗                              
27 ╚════╝    ██║███╗██║██╔══██║██╔══██╗    ╚════╝                              
28           ╚███╔███╔╝██║  ██║██║  ██║                                        
29            ╚══╝╚══╝ ╚═╝  ╚═╝╚═╝  ╚═╝                                        
30                                                                             
31 
32                                                                                                                                                      
33 
34 © 2018 SuperCountries
35 
36 所有权 - 4CE434B6058EC7C24889EC2512734B5DBA26E39891C09DF50C3CE3191CE9C51E
37 
38 Xuxuxu - LB - Xufo - MyPartridge
39 																										   
40 */
41 
42 
43 //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
44 //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
45 //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
46 //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
47 //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
48 
49 library SafeMath {
50 
51   /**
52   * @dev Multiplies two numbers, throws on overflow.
53   */
54   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
55     if (a == 0) {
56       return 0;
57     }
58     uint256 c = a * b;
59     assert(c / a == b);
60     return c;
61   }
62 
63   /**
64   * @dev Integer division of two numbers, truncating the quotient.
65   */
66   function div(uint256 a, uint256 b) internal pure returns (uint256) {
67     // assert(b > 0); // Solidity automatically throws when dividing by 0
68     uint256 c = a / b;
69     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
70     return c;
71   }
72 
73   /**
74   * @dev subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
75   */
76   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
77     assert(b <= a);
78     return a - b;
79   }
80 
81   /**
82   * @dev Adds two numbers, throws on overflow.
83   */
84   function add(uint256 a, uint256 b) internal pure returns (uint256) {
85     uint256 c = a + b;
86     assert(c >= a);
87     return c;
88   }
89 }
90 
91 
92 
93 
94 
95 //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
96 //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
97 //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
98 //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
99 //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
100 
101 //////////////////////////////////////////////////////////////////
102 //////////////////////////////////////////////////////////////////
103 /////		                                                 /////
104 /////				CALLING EXTERNAL CONTRACTS   			 /////
105 /////		                                                 /////
106 //////////////////////////////////////////////////////////////////
107 //////////////////////////////////////////////////////////////////
108 
109 
110 ////////////////////////////////////////////////
111 /// 	SUPERCOUNTRIES CONTRACT	FUNCTIONS	 ///	
112 ////////////////////////////////////////////////
113 
114 contract SuperCountriesExternal {
115   using SafeMath for uint256; 
116 
117 	function ownerOf(uint256) public pure returns (address) {	}
118 	
119 	function priceOf(uint256) public pure returns (uint256) { }
120 }
121 
122 
123 
124 ////////////////////////////////////////////////////////////
125 /// 	SUPERCOUNTRIES TROPHY CARDS CONTRACT FUNCTIONS	 ///	
126 ////////////////////////////////////////////////////////////
127 
128 contract SuperCountriesTrophyCardsExternal {
129   using SafeMath for uint256;
130   
131 	function countTrophyCards() public pure returns (uint256) {	}
132 	
133 	function getTrophyCardIdFromIndex(uint256) public pure returns (uint256) {	}
134 }
135 
136 
137 
138 
139 
140 
141 //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
142 //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
143 //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
144 //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
145 //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
146 
147 //////////////////////////////////////////////////////////
148 //////////////////////////////////////////////////////////
149 /////		                                         /////
150 /////		SUPERCOUNTRIES WAR - NEW CONTRACT    	 /////
151 /////		                                         /////
152 //////////////////////////////////////////////////////////
153 //////////////////////////////////////////////////////////
154 
155 contract SuperCountriesWar {
156   using SafeMath for uint256;
157 
158  
159 ////////////////////////////
160 /// 	CONSTRUCTOR		 ///	
161 ////////////////////////////
162    
163 	constructor () public {
164 		owner = msg.sender;
165 
166 		continentKing.length = 16;
167 		newOwner.length = 256;
168 		nukerAddress.length = 256;		
169 	}
170 	
171 	address public owner;  
172 
173 	
174 	
175 	
176 	
177 	
178 ////////////////////////////////
179 /// 	USEFUL MODIFIERS	 ///	
180 ////////////////////////////////
181 	
182   /**
183    * @dev Throws if called by any account other than the owner.
184    */
185 	modifier onlyOwner() {
186 		require(owner == msg.sender);
187 		_;
188 	}
189 
190 	
191 	
192   /**
193    * @dev Throws if called by address 0x0
194    */
195 	modifier onlyRealAddress() {
196 		require(msg.sender != address(0));
197 		_;
198 	}
199 	
200 	
201 	
202   /**
203    * @dev Can only be called when a game is running / unpaused
204    */	
205 	modifier onlyGameNOTPaused() {
206 		require(gameRunning == true);
207 		_;
208 	}
209 
210 	
211 
212 	/**
213    * @dev Can only be called when a game is paused / ended
214    */	
215 	modifier onlyGamePaused() {
216 		require(gameRunning == false);
217 		_;
218 	}
219     
220 	
221 	
222 	
223 
224 
225 	
226 ///////////////////////////////////////
227 /// 	TROPHY CARDS FUNCTIONS 		///
228 ///////////////////////////////////////
229 
230 ///Update the index of the next trophy card to get dividends, after each buy a new card will get divs
231 	function nextTrophyCardUpdateAndGetOwner() internal returns (address){
232 		uint256 cardsLength = getTrophyCount();
233 		address trophyCardOwner;
234 		
235 		if (nextTrophyCardToGetDivs < cardsLength){
236 				uint256 nextCard = getTrophyFromIndex(nextTrophyCardToGetDivs);
237 				trophyCardOwner = getCountryOwner(nextCard);	
238 		}
239 		
240 		/// Update for next time
241 		if (nextTrophyCardToGetDivs.add(1) < cardsLength){
242 				nextTrophyCardToGetDivs++;			
243 		}
244 			else nextTrophyCardToGetDivs = 0;
245 			
246 		return trophyCardOwner;			
247 	} 
248 
249 	
250 
251 /// Get the address of the owner of the "next trophy card to get divs"
252 	function getNextTrophyCardOwner() 
253 		public 
254 		view 
255 		returns (
256 			address nextTrophyCardOwner_,
257 			uint256 nextTrophyCardIndex_,
258 			uint256 nextTrophyCardId_
259 		)
260 	{
261 		uint256 cardsLength = getTrophyCount();
262 		address trophyCardOwner;
263 		
264 		if (nextTrophyCardToGetDivs < cardsLength){
265 				uint256 nextCard = getTrophyFromIndex(nextTrophyCardToGetDivs);
266 				trophyCardOwner = getCountryOwner(nextCard);
267 		}
268 			
269 		return (
270 			trophyCardOwner,
271 			nextTrophyCardToGetDivs,
272 			nextCard
273 		);
274 	}
275 	
276 	
277 	
278 
279 	
280 	
281 ////////////////////////////////////////////////////////
282 /// 	CALL OF OTHER SUPERCOUNTRIES CONTRACTS		 ///	
283 ////////////////////////////////////////////////////////
284 	
285 /// EXTERNAL VALUES
286 	address private contractSC = 0xdf203118A954c918b967a94E51f3570a2FAbA4Ac; /// SuperCountries Original game
287 	address private contractTrophyCards = 0xEaf763328604e6e54159aba7bF1394f2FbcC016e; /// SuperCountries Trophy Cards
288 		
289 	SuperCountriesExternal SC = SuperCountriesExternal(contractSC);
290 	SuperCountriesTrophyCardsExternal SCTrophy = SuperCountriesTrophyCardsExternal(contractTrophyCards);
291 	
292 	
293 
294 
295 	
296 ////////////////////////////////////////////////////
297 /// 	GET FUNCTIONS FROM EXTERNAL CONTRACTS	 ///	
298 ////////////////////////////////////////////////////
299 	
300 /// SuperCountries Original
301 	function getCountryOwner(uint256 _countryId) public view returns (address){        
302 		return SC.ownerOf(_countryId);
303     }
304 	
305 	
306 /// SuperCountries Original
307 	function getPriceOfCountry(uint256 _countryId) public view returns (uint256){			
308 		return SC.priceOf(_countryId);
309 	}
310 
311 	
312 /// SuperCountries Trophy Cards
313 	function getTrophyFromIndex(uint256 _index) public view returns (uint256){			
314 		return SCTrophy.getTrophyCardIdFromIndex(_index);
315 	}
316 
317 	
318 /// SuperCountries Trophy Cards	
319 	function getTrophyCount() public view returns (uint256){			
320 		return SCTrophy.countTrophyCards();
321 	}
322 	
323 
324 
325 
326 
327 	
328 ////////////////////////////////////////
329 /// 	VARIABLES & MAPPINGS		 ///	
330 ////////////////////////////////////////
331 	
332 /// Game enabled?	
333 	bool private gameRunning;
334 	uint256 private gameVersion = 1; /// game Id	
335 
336 	
337 /// Dates & timestamps
338 	uint256 private jackpotTimestamp; /// if this timestamp is reached, the jackpot can be shared
339 	mapping(uint256 => bool) private thisJackpotIsPlayedAndNotWon; /// true if currently played and not won, false if already won or not yet played
340 
341 	
342 /// *** J A C K P O T *** ///
343 /// Unwithdrawn jackpot per winner
344 	mapping(uint256 => mapping(address => uint256)) private winnersJackpot; 
345 	mapping(uint256 => uint256) private winningCountry; /// List of winning countries
346 
347 	
348 /// Payable functions prices: nuke a country, become a king ///
349 	uint256 private startingPrice = 1e16; /// ETHER /// First raw price to nuke a country /// nuke = nextPrice (or startingPrice) + kCountry*LastKnownCountryPrice
350 	mapping(uint256 => uint256) private nextPrice; /// ETHER /// Current raw price to nuke a country /// nuke = nextPrice + kCountry*LastKnownCountryPrice
351 	uint256 private kingPrice = 9e15; /// ETHER /// Current king price
352 
353 	
354 /// Factors ///
355 	uint256 private kCountry = 4; /// PERCENTS /// nuke = nextPrice + kCountry*LastKnownCountryPrice (4 = 4%)
356 	uint256 private kCountryLimit = 5e17; /// ETHER /// kCountry * lastKnownPrice cannot exceed this limit
357 	uint256 private kNext = 1037; /// PERTHOUSAND /// price increase after each nuke (1037 = 3.7% increase)
358 	uint256 private maxFlips = 16; /// king price will increase after maxFlips kings
359 	uint256 private continentFlips; /// Current kings flips
360 	uint256 private kKings = 101; /// king price increase (101 = 1% increase)
361 	
362 
363 /// Kings //
364 	address[] private continentKing;
365 
366 	
367 /// Nukers ///
368 	address[] private nukerAddress;
369 
370 	
371 /// Lovers ///
372 	struct LoverStructure {
373 		mapping(uint256 => mapping(address => uint256)) loves; /// howManyNuked => lover address => number of loves
374 		mapping(uint256 => uint256) maxLoves; /// highest number of loves for this country
375 		address bestLover; /// current best lover for this country (highest number of loves)
376 		}
377 
378 	mapping(uint256 => mapping(uint256 => LoverStructure)) private loversSTR; /// GameVersion > CountryId > LoverStructure
379 	uint256 private mostLovedCountry; /// The mostLovedCountry cannot be nuked if > 4 countries on the map
380 	
381 	mapping(address => uint256) private firstLove; /// timestamp for loves 
382 	mapping(address => uint256) private remainingLoves; /// remaining loves for today
383 	uint256 private freeRemainingLovesPerDay = 2; /// Number of free loves per day sub 1
384 
385 	
386 /// Cuts in perthousand /// the rest = potCut
387 	uint256 private devCut = 280; /// Including riddles and medals rewards
388 	uint256 private playerCut = 20; /// trophy card, best lover & country owner
389 	uint256 private potCutSuperCountries = 185;
390 	
391 
392 /// Jackpot redistribution /// 10 000 = 100%
393 	uint256 private lastNukerShare = 5000;
394 	uint256 private winningCountryShare = 4400; /// if 1 country stands, the current owner takes it all, otherwise shared between owners of remaining countries (of the winning continent)
395 	uint256 private continentShare = 450;
396 	uint256 private freePlayerShare = 150;
397 
398 
399 /// Minimal jackpot guarantee /// Initial funding by SuperCountries	
400 	uint256 private lastNukerMin = 3e18; /// 3 ethers
401 	uint256 private countryOwnerMin = 3e18; /// 3 ethers
402 	uint256 private continentMin = 1e18; /// 1 ether
403 	uint256 private freePlayerMin = 1e18; /// 1 ether
404 	uint256 private withdrawMinOwner; /// Dev can withdraw his initial funding if the jackpot equals this value.
405 
406 
407 /// Trophy cards
408 	uint256 private nextTrophyCardToGetDivs; /// returns next trophy card INDEX to get dividends
409 	
410 	
411 /// Countries ///
412 	uint256 private allCountriesLength = 256; /// how many countries
413 	mapping(uint256 => mapping(uint256 => bool)) private eliminated; /// is this country eliminated? gameVersion > countryId > bool
414 	uint256 private howManyEliminated; /// how many eliminated countries
415 	uint256 private howManyNuked; /// how many nuked countries
416 	uint256 private howManyReactivated; /// players are allowed to reactivate 1 country for 8 nukes
417 	uint256 private lastNukedCountry; /// last nuked country ID
418 	mapping(uint256 => uint256) lastKnownCountryPrice; ///
419 	address[] private newOwner; /// Latest known country owners /// A new buyer must send at least one love or reanimate its country to be in the array
420 
421 /// Continents ///	
422 	mapping(uint256 => uint256) private countryToContinent; /// country Id to Continent Id
423 
424 	
425 /// Time (seconds) ///	
426 	uint256 public SLONG = 86400; /// 1 day
427 	uint256 public DLONG = 172800; /// 2 days
428 	uint256 public DSHORT = 14400; /// 4 hrs
429 	
430 	
431 	
432 
433 	
434 ////////////////////////
435 /// 	EVENTS		 ///	
436 ////////////////////////
437 
438 	/// Pause / UnPause
439 	event PausedOrUnpaused(uint256 indexed blockTimestamp_, bool indexed gameRunning_);
440 	
441 	/// New Game ///
442 	event NewGameLaunched(uint256 indexed gameVersion_, uint256 indexed blockTimestamp_, address indexed msgSender_, uint256 jackpotTimestamp_);
443 	event ErrorCountry(uint256 indexed countryId_);
444 	
445 	/// Updates ///
446 	event CutsUpdated(uint256 indexed newDevcut_, uint256 newPlayercut_, uint256 newJackpotCountriescut_, uint256 indexed blockTimestamp_);	
447 	event ConstantsUpdated(uint256 indexed newStartPrice_, uint256 indexed newkKingPrice_, uint256 newKNext_, uint256 newKCountry_, uint256 newKLimit_, uint256 newkKings, uint256 newMaxFlips);
448 	event NewContractAddress(address indexed newAddress_);
449 	event NewValue(uint256 indexed code_, uint256 indexed newValue_, uint256 indexed blockTimestamp_);
450 	event NewCountryToContinent(uint256 indexed countryId_, uint256 indexed continentId_, uint256 indexed blockTimestamp_);		
451 	
452 	/// Players Events ///
453 	event PlayerEvent(uint256 indexed eventCode_, uint256 indexed countryId_, address indexed player_, uint256 timestampNow_, uint256 customValue_, uint256 gameId_);
454 	event Nuked(address indexed player_, uint256 indexed lastNukedCountry_, uint256 priceToPay_, uint256 priceRaw_);	
455 	event Reactivation(uint256 indexed countryId_, uint256 indexed howManyReactivated_);
456 	event NewKingContinent(address indexed player_, uint256 indexed continentId_, uint256 priceToPay_);
457 	event newMostLovedCountry(uint256 indexed countryId_, uint256 indexed maxLovesBest_);
458 	event NewBestLover(address indexed lover_, uint256 indexed countryId_, uint256 maxLovesBest_);	
459 	event NewLove(address indexed lover_, uint256 indexed countryId_, uint256 playerLoves_, uint256 indexed gameId_, uint256 nukeCount_);
460 	event LastCountryStanding(uint256 indexed countryId_, address indexed player_, uint256 contractBalance_, uint256 indexed gameId_, uint256 jackpotTimestamp);
461 	event ThereIsANewOwner(address indexed newOwner_, uint256 indexed countryId_);
462 	
463 	/// Payments /// 
464 	event CutsPaidInfos(uint256 indexed blockTimestamp_, uint256 indexed countryId_, address countryOwner_, address trophyCardOwner_, address bestLover_);
465 	event CutsPaidValue(uint256 indexed blockTimestamp_, uint256 indexed paidPrice_, uint256 thisBalance_, uint256 devCut_, uint256 playerCut_, uint256 indexed SuperCountriesCut_);
466 	event CutsPaidLight(uint256 indexed blockTimestamp_, uint256 indexed paidPrice_, uint256 thisBalance_, uint256 devCut_, uint256 playerCut_, address trophyCardOwner_, uint256 indexed SuperCountriesCut_);
467 	event NewKingPrice(uint256 indexed kingPrice_, uint256 indexed kKings_);
468 		
469 	/// Jackpot & Withdraws ///
470 	event NewJackpotTimestamp(uint256 indexed jackpotTimestamp_, uint256 indexed timestamp_);
471 	event WithdrawByDev(uint256 indexed blockTimestamp_, uint256 indexed withdrawn_, uint256 indexed withdrawMinOwner_, uint256 jackpot_);
472 	event WithdrawJackpot(address indexed winnerAddress_, uint256 indexed jackpotToTransfer_, uint256 indexed gameVersion_);	
473 	event JackpotDispatch(address indexed winner, uint256 indexed jackpotShare_, uint256 customValue_, bytes32 indexed customText_);
474 	event JackpotDispatchAll(uint256 indexed gameVersion_, uint256 indexed winningCountry_, uint256 indexed continentId_, uint256 timestampNow_, uint256 jackpotTimestamp_, uint256 pot_,uint256 potDispatched_, uint256 thisBalance);
475 
476 	
477 
478 	
479 	
480 
481 //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
482 //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
483 //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
484 	
485 ////////////////////////////
486 /// PUBLIC GET FUNCTIONS ///
487 ////////////////////////////
488 
489 /// Checks if a player can nuke or be a king
490 	function canPlayTimestamp() public view returns (bool ok_){
491 		uint256 timestampNow = block.timestamp;
492 		uint256 jT = jackpotTimestamp;
493 		bool canPlayTimestamp_;
494 		
495 			if (timestampNow < jT || timestampNow > jT.add(DSHORT)){
496 				canPlayTimestamp_ = true;		
497 			}
498 		
499 		return canPlayTimestamp_;	
500 	}
501 
502 
503 	
504 	
505 /// When eliminated, the country cannot be eliminated again unless someone rebuys this country	
506 	function isEliminated(uint256 _countryId) public view returns (bool isEliminated_){
507 		return eliminated[gameVersion][_countryId];
508 	}
509 
510 
511 	
512 	
513 /// The player can love few times a day (or more if loved yesterday)
514 	function canPlayerLove(address _player) public view returns (bool playerCanLove_){	
515 		if (firstLove[_player].add(SLONG) > block.timestamp && remainingLoves[_player] == 0){
516 			bool canLove = false;
517 		} else canLove = true;	
518 
519 		return canLove;
520 	}
521 
522 	
523 	
524 	
525 /// To reanimate a country, a player must rebuy it first on the marketplace then click the reanima button
526 /// Reanimations are limited: 1 allowed for 8 nukes ; disallowed if only 8 countries on the map
527 	function canPlayerReanimate(
528 		uint256 _countryId,
529 		address _player
530 	)
531 		public
532 		view
533 		returns (bool canReanimate_)
534 	{	
535 		if (
536 			(lastKnownCountryPrice[_countryId] < getPriceOfCountry(_countryId))	&&
537 			(isEliminated(_countryId) == true) &&
538 			(_countryId != lastNukedCountry) &&
539 			(block.timestamp.add(SLONG) < jackpotTimestamp || block.timestamp > jackpotTimestamp.add(DSHORT)) &&
540 			(allCountriesLength.sub(howManyEliminated) > 8) && /// If only 8 countries left, no more reactivation allowed even if other requires could allow
541 			((howManyReactivated.add(1)).mul(8) < howManyNuked) && /// 1 reactivation for 8 Nukes
542 			(lastKnownCountryPrice[_countryId] > 0) &&
543 			(_player == getCountryOwner(_countryId))
544 			) {
545 				bool canReanima = true;				
546 			} else canReanima = false;		
547 		
548 		return canReanima;
549 	}	
550 
551 	
552 	
553 	
554 /// Get the current gameVersion	
555 	function constant_getGameVersion() public view returns (uint256 currentGameVersion_){
556 		return gameVersion;
557 	}
558 
559 
560 	
561 	
562 /// Returns some useful informations for a country
563 	function country_getInfoForCountry(uint256 _countryId) 
564 		public 
565 		view 
566 		returns (
567 			bool eliminatedBool_,
568 			uint256 whichContinent_,
569 			address currentBestLover_,
570 			uint256 maxLovesForTheBest_,
571 			address countryOwner_,
572 			uint256 lastKnownPrice_
573 		) 
574 	{		
575 		LoverStructure storage c = loversSTR[gameVersion][_countryId];
576 		if (eliminated[gameVersion][_countryId]){uint256 nukecount = howManyNuked.sub(1);} else nukecount = howManyNuked;
577 		
578 		return (
579 			eliminated[gameVersion][_countryId],
580 			countryToContinent[_countryId],
581 			c.bestLover,
582 			c.maxLoves[nukecount],
583 			newOwner[_countryId],
584 			lastKnownCountryPrice[_countryId]
585 		);
586 	}
587 	
588 	
589 	
590 	
591 /// Returns the number of loves
592 	function loves_getLoves(uint256 _countryId, address _player) public view returns (uint256 loves_) {				
593 		LoverStructure storage c = loversSTR[gameVersion][_countryId];
594 		return c.loves[howManyNuked][_player];
595 	}
596 
597 	
598 	
599 	
600 /// Returns the number of loves of a player for a country for an old gameId for howManyNukedId (loves reset after each nuke)
601 	function loves_getOldLoves(
602 		uint256 _countryId,
603 		address _player,
604 		uint256 _gameId,
605 		uint256 _oldHowManyNuked
606 	) 
607 		public 
608 		view 
609 		returns (uint256 loves_) 
610 	{		
611 		return loversSTR[_gameId][_countryId].loves[_oldHowManyNuked][_player];
612 	}
613 
614 	
615 	
616 	
617 /// Calculate how many loves left for a player for today
618 	function loves_getPlayerInfo(address _player) 
619 		public 
620 		view 
621 		returns (
622 			uint256 playerFirstLove_,
623 			uint256 playerRemainingLoves_,
624 			uint256 realRemainingLoves_
625 		) 
626 	{
627 		uint256 timestampNow = block.timestamp;
628 		uint256 firstLoveAdd24 = firstLove[_player].add(SLONG);
629 		uint256 firstLoveAdd48 = firstLove[_player].add(DLONG);
630 		uint256 remainStored = remainingLoves[_player];
631 		
632 		/// This player loved today but has some loves left, remainingLoves are correct
633 		if (firstLoveAdd24 > timestampNow && remainStored > 0){
634 			uint256 remainReal = remainStored;
635 		}
636 			/// This player loved yesterday but not today, he can love "howManyEliminated.div(4)" + "freeRemainingLovesPerDay + 1" times today
637 			else if (firstLoveAdd24 < timestampNow && firstLoveAdd48 > timestampNow){
638 				remainReal = (howManyEliminated.div(4)).add(freeRemainingLovesPerDay).add(1);
639 			}		
640 				/// This player didn't love for 48h, he can love "freeRemainingLovesPerDay + 1" today
641 				else if (firstLoveAdd48 < timestampNow){
642 					remainReal = freeRemainingLovesPerDay.add(1);
643 				}		
644 					else remainReal = 0;
645 			
646 		return (
647 			firstLove[_player],
648 			remainStored,
649 			remainReal
650 		); 
651 	}
652 
653 	
654 	
655 
656 /// Returns the unwithdrawn jackpot of a player for a GameId
657 	function player_getPlayerJackpot(
658 		address _player,
659 		uint256 _gameId
660 	) 
661 		public 
662 		view 
663 		returns (
664 			uint256 playerNowPot_,
665 			uint256 playerOldPot_
666 		)
667 	{
668 		return (
669 			winnersJackpot[gameVersion][_player],
670 			winnersJackpot[_gameId][_player]
671 		);
672 	}	
673 
674 
675 	
676 	
677 /// Returns informations for a country for previous games	
678 	function country_getOldInfoForCountry(uint256 _countryId, uint256 _gameId)
679 		public
680 		view
681 		returns (
682 			bool oldEliminatedBool_,
683 			uint256 oldMaxLovesForTheBest_
684 		) 
685 	{	
686 		LoverStructure storage c = loversSTR[_gameId][_countryId];
687 		
688 		return (
689 			eliminated[_gameId][_countryId],
690 			c.maxLoves[howManyNuked]
691 			);
692 	}
693 	
694 	
695 	
696 	
697 /// Returns informations for a country for previous games requiring more parameters	
698 	function loves_getOldNukesMaxLoves(
699 		uint256 _countryId,
700 		uint256 _gameId,
701 		uint256 _howManyNuked
702 	) 
703 		public view returns (uint256 oldMaxLovesForTheBest2_)
704 	{		
705 		return (loversSTR[_gameId][_countryId].maxLoves[_howManyNuked]);
706 	}	
707 	
708 
709 	
710 
711 /// Returns other informations for a country for previous games	
712 	function country_getCountriesGeneralInfo()
713 		public
714 		view
715 		returns (
716 			uint256 lastNuked_,
717 			address lastNukerAddress_,
718 			uint256 allCountriesLength_,
719 			uint256 howManyEliminated_,
720 			uint256 howManyNuked_,
721 			uint256 howManyReactivated_,
722 			uint256 mostLovedNation_
723 		) 
724 	{		
725 		return (
726 			lastNukedCountry,
727 			nukerAddress[lastNukedCountry],
728 			allCountriesLength,			
729 			howManyEliminated,
730 			howManyNuked,
731 			howManyReactivated,
732 			mostLovedCountry
733 			);
734 	}
735 
736 
737 	
738 	
739 /// Get the address of the king for a continent	
740 	function player_getKingOne(uint256 _continentId) public view returns (address king_) {		
741 		return continentKing[_continentId];
742 	}
743 
744 	
745 
746 	
747 /// Return all kings	
748 	function player_getKingsAll() public view returns (address[] _kings) {	
749 		
750 		uint256 kingsLength = continentKing.length;
751 		address[] memory kings = new address[](kingsLength);
752 		uint256 kingsCounter = 0;
753 			
754 		for (uint256 i = 0; i < kingsLength; i++) {
755 			kings[kingsCounter] = continentKing[i];
756 			kingsCounter++;				
757 		}
758 		
759 		return kings;
760 	}
761 	
762 
763 	
764 
765 /// Return lengths of arrays
766 	function constant_getLength()
767 		public
768 		view
769 		returns (
770 			uint256 kingsLength_,
771 			uint256 newOwnerLength_,
772 			uint256 nukerLength_
773 		)
774 	{		
775 		return (
776 			continentKing.length,
777 			newOwner.length,
778 			nukerAddress.length
779 		);
780 	}
781 
782 	
783 	
784 
785 /// Return the nuker's address - If a country was nuked twice (for example after a reanimation), we store the last nuker only
786 	function player_getNuker(uint256 _countryId) public view returns (address nuker_) {		
787 		return nukerAddress[_countryId];		
788 	}
789 
790 	
791 	
792 	
793 /// How many countries were nuked by a player? 
794 /// Warning: if a country was nuked twice (for example after a reanimation), only the last nuker counts
795 	function player_howManyNuked(address _player) public view returns (uint256 nukeCount_) {		
796 		uint256 counter = 0;
797 
798 		for (uint256 i = 0; i < nukerAddress.length; i++) {
799 			if (nukerAddress[i] == _player) {
800 				counter++;
801 			}
802 		}
803 
804 		return counter;		
805 	}
806 	
807 	
808 	
809 	
810 /// Which countries were nuked by a player?	
811 	function player_getNukedCountries(address _player) public view returns (uint256[] myNukedCountriesIds_) {		
812 		
813 		uint256 howLong = player_howManyNuked(_player);
814 		uint256[] memory myNukedCountries = new uint256[](howLong);
815 		uint256 nukeCounter = 0;
816 		
817 		for (uint256 i = 0; i < allCountriesLength; i++) {
818 			if (nukerAddress[i] == _player){
819 				myNukedCountries[nukeCounter] = i;
820 				nukeCounter++;
821 			}
822 
823 			if (nukeCounter == howLong){break;}
824 		}
825 		
826 		return myNukedCountries;
827 	}
828 
829 
830 	
831 	
832 /// Which percentage of the jackpot will the winners share?
833 	function constant_getPriZZZes() 
834 		public 
835 		view 
836 		returns (
837 			uint256 lastNukeShare_,
838 			uint256 countryOwnShare_,
839 			uint256 contintShare_,
840 			uint256 freePlayerShare_
841 		) 
842 	{
843 		return (
844 			lastNukerShare,
845 			winningCountryShare,
846 			continentShare,
847 			freePlayerShare
848 		);
849 	}
850 
851 	
852 		
853 	
854 /// Returns the minimal jackpot part for each winner (if accurate)
855 /// Only accurate for the first game. If new games are started later, these values will be set to 0
856 	function constant_getPriZZZesMini()
857 		public
858 		view
859 		returns (
860 			uint256 lastNukeMini_,
861 			uint256 countryOwnMini_,
862 			uint256 contintMini_,
863 			uint256 freePlayerMini_,
864 			uint256 withdrMinOwner_
865 		)
866 	{
867 		return (
868 			lastNukerMin,
869 			countryOwnerMin,
870 			continentMin,
871 			freePlayerMin,
872 			withdrawMinOwner
873 		);
874 	}
875 
876 	
877 	
878 
879 /// Returns some values for the current game	
880 	function constant_getPrices()
881 		public 
882 		view 
883 		returns (
884 			uint256 nextPrice_,
885 			uint256 startingPrice_,
886 			uint256 kingPrice_,
887 			uint256 kNext_,
888 			uint256 kCountry_,
889 			uint256 kCountryLimit_,
890 			uint256 kKings_)
891 	{
892 		return (
893 			nextPrice[gameVersion],
894 			startingPrice,
895 			kingPrice,
896 			kNext,
897 			kCountry,
898 			kCountryLimit,
899 			kKings
900 		);
901 	}
902 
903 	
904 	
905 	
906 /// Returns other values for the current game
907 	function constant_getSomeDetails()
908 		public
909 		view
910 		returns (
911 			bool gameRunng_,
912 			uint256 currentContractBalance_,
913 			uint256 jackptTimstmp_,
914 			uint256 maxFlip_,
915 			uint256 continentFlip_,
916 			bool jackpotNotWonYet_) 
917 	{
918 		return (
919 			gameRunning,
920 			address(this).balance,
921 			jackpotTimestamp,
922 			maxFlips,
923 			continentFlips,
924 			thisJackpotIsPlayedAndNotWon[gameVersion]
925 		);
926 	}
927 
928 	
929 	
930 
931 /// Returns some values for previous games	
932 	function constant_getOldDetails(uint256 _gameId)
933 		public
934 		view
935 		returns (
936 			uint256 oldWinningCountry_,
937 			bool oldJackpotBool_,
938 			uint256 oldNextPrice_
939 		) 
940 	{
941 		return (
942 			winningCountry[_gameId],
943 			thisJackpotIsPlayedAndNotWon[_gameId],
944 			nextPrice[_gameId]
945 		);
946 	}
947 	
948 	
949 	
950 	
951 /// Returns cuts
952 	function constant_getCuts()
953 		public
954 		view
955 		returns (
956 			uint256 playerCut_,
957 			uint256 potCutSC,
958 			uint256 developerCut_)
959 	{
960 		return (
961 			playerCut,
962 			potCutSuperCountries,
963 			devCut
964 		);
965 	}
966 
967 	
968 	
969 
970 /// Returns linked contracts addresses: SuperCountries core contract, Trophy Cards Contract
971 	function constant_getContracts() public view returns (address SuperCountries_, address TrophyCards_) {
972 		return (contractSC, contractTrophyCards);
973 	}	
974 
975 
976 	
977 	
978 /// Calculates the raw price of a next nuke
979 /// This value will be used to calculate a nuke price for a specified country depending of its market price
980 	function war_getNextNukePriceRaw() public view returns (uint256 price_) {
981 		
982 		if (nextPrice[gameVersion] != 0) {
983 			uint256 price = nextPrice[gameVersion];
984 		}
985 			else price = startingPrice;
986 		
987 		return price;		
988 	}
989 
990 	
991 	
992 		
993 /// Calculates the exact price to nuke a country using the raw price (calculated above) and the market price of a country
994 	function war_getNextNukePriceForCountry(uint256 _countryId) public view returns (uint256 priceOfThisCountry_) {
995 
996 		uint256 priceRaw = war_getNextNukePriceRaw();
997 		uint256 k = lastKnownCountryPrice[_countryId].mul(kCountry).div(100);
998 		
999 		if (k > kCountryLimit){
1000 			uint256 priceOfThisCountry = priceRaw.add(kCountryLimit);
1001 		}
1002 			else priceOfThisCountry = priceRaw.add(k);				
1003 	
1004 		return priceOfThisCountry;		
1005 	}
1006 	
1007 
1008 	
1009 
1010 /// Returns all countries for a continent
1011 	function country_getAllCountriesForContinent(uint256 _continentId) public view returns (uint256[] countries_) {					
1012 		
1013 		uint256 howManyCountries = country_countCountriesForContinent(_continentId);
1014 		uint256[] memory countries = new uint256[](howManyCountries);
1015 		uint256 countryCounter = 0;
1016 				
1017 		for (uint256 i = 0; i < allCountriesLength; i++) {
1018 			if (countryToContinent[i] == _continentId){
1019 				countries[countryCounter] = i;
1020 				countryCounter++;						
1021 			}	
1022 				if (countryCounter == howManyCountries){break;}
1023 		}
1024 
1025 		return countries;
1026 	}
1027 
1028 	
1029 
1030 	
1031 /// Count all countries for a continent (standing and non standing)
1032 	function country_countCountriesForContinent(uint256 _continentId) public view returns (uint256 howManyCountries_) {
1033 		uint256 countryCounter = 0;
1034 				
1035 		for (uint256 i = 0; i < allCountriesLength; i++) {
1036 			if (countryToContinent[i] == _continentId){
1037 				countryCounter++;						
1038 			}		
1039 		}
1040 		
1041 		return countryCounter;
1042 	}	
1043 
1044 
1045 	
1046 		
1047 /// Return the ID of all STANDING countries for a continent (or not Standing if FALSE)
1048 	function country_getAllStandingCountriesForContinent(
1049 		uint256 _continentId,
1050 		bool _standing
1051 	) 
1052 		public
1053 		view
1054 		returns (uint256[] countries_)
1055 	{					
1056 		uint256 howManyCountries = country_countStandingCountriesForContinent(_continentId, _standing);
1057 		uint256[] memory countries = new uint256[](howManyCountries);
1058 		uint256 countryCounter = 0;
1059 		uint256 gameId = gameVersion;
1060 				
1061 		for (uint256 i = 0; i < allCountriesLength; i++) {
1062 			if (countryToContinent[i] == _continentId && eliminated[gameId][i] != _standing){
1063 				countries[countryCounter] = i;
1064 				countryCounter++;						
1065 			}	
1066 				if (countryCounter == howManyCountries){break;}
1067 		}
1068 
1069 		return countries;
1070 	}	
1071 
1072 	
1073 
1074 
1075 /// Count all STANDING countries for a continent (or not Standing if FALSE)	
1076 	function country_countStandingCountriesForContinent(
1077 		uint256 _continentId,
1078 		bool _standing
1079 	)
1080 		public
1081 		view
1082 		returns (uint256 howManyCountries_)
1083 	{
1084 		uint256 standingCountryCounter = 0;
1085 		uint256 gameId = gameVersion;
1086 				
1087 		for (uint256 i = 0; i < allCountriesLength; i++) {
1088 			if (countryToContinent[i] == _continentId && eliminated[gameId][i] != _standing){
1089 				standingCountryCounter++;						
1090 			}		
1091 		}
1092 		
1093 		return standingCountryCounter;
1094 	}
1095 
1096 
1097 	
1098 	
1099 /// Calculate the jackpot to share between all winners
1100 /// realJackpot: the real value to use when sharing
1101 /// expected: this is the jackpot as we should expect if there was no minimal guarantee. It can be different from the real one if we have not reached the minimal value yet. 
1102 /// WARNING: between the real and the expected, the REAL one is the only value to use ; the expected one is for information only and will never be used in any calculation
1103 	function calculateJackpot()
1104 		public
1105 		view
1106 		returns (
1107 			uint256 nukerJackpot_,
1108 			uint256 countryJackpot_,
1109 			uint256 continentJackpot_,
1110 			uint256 freeJackpot_,
1111 			uint256 realJackpot_,
1112 			uint256 expectedJackpot_
1113 		)
1114 	{
1115 		/// If thisJackpot = false, that would mean it was already won or not yet played,
1116 		///	if true it's currently played and not won yet
1117 		if (thisJackpotIsPlayedAndNotWon[gameVersion] != true) {
1118 			uint256 nukerJPT = 0;
1119 			uint256 countryJPT = 0;
1120 			uint256 continentJPT = 0;
1121 			uint256 freeJPT = 0;
1122 			uint256 realJackpotToShare = 0;
1123 			uint256 expectedJackpotFromRates = 0;
1124 		}
1125 		
1126 			else {
1127 				uint256 devGift = lastNukerMin.add(countryOwnerMin).add(continentMin).add(freePlayerMin);
1128 				expectedJackpotFromRates = ((address(this).balance).add(withdrawMinOwner).sub(devGift)).div(10000);
1129 				
1130 					uint256 temp_share = expectedJackpotFromRates.mul(lastNukerShare);
1131 					if (temp_share > lastNukerMin){
1132 						nukerJPT = temp_share;
1133 					} else nukerJPT = lastNukerMin;
1134 					
1135 					temp_share = expectedJackpotFromRates.mul(winningCountryShare);
1136 					if (temp_share > countryOwnerMin){
1137 						countryJPT = temp_share;
1138 					} else countryJPT = countryOwnerMin;
1139 
1140 					temp_share = expectedJackpotFromRates.mul(continentShare);
1141 					if (temp_share > continentMin){
1142 						continentJPT = temp_share;
1143 					} else continentJPT = continentMin;
1144 
1145 					temp_share = expectedJackpotFromRates.mul(freePlayerShare);
1146 					if (temp_share > freePlayerMin){
1147 						freeJPT = temp_share;
1148 					} else freeJPT = freePlayerMin;		
1149 				
1150 					realJackpotToShare = nukerJPT.add(countryJPT).add(continentJPT).add(freeJPT);
1151 			}
1152 		
1153 		return (
1154 			nukerJPT,
1155 			countryJPT,
1156 			continentJPT,
1157 			freeJPT,
1158 			realJackpotToShare,
1159 			expectedJackpotFromRates.mul(10000)
1160 		);	
1161 	}
1162 
1163 
1164 	
1165 
1166 /// Calculate how much the dev can withdraw now
1167 /// If the dev funded a minimal guarantee, he can withdraw gradually its funding when jackpot rises up to its funding amount
1168 	function whatDevCanWithdraw() public view returns(uint256 toWithdrawByDev_){
1169 		uint256 devGift = lastNukerMin.add(countryOwnerMin).add(continentMin).add(freePlayerMin);
1170 		uint256 balance = address(this).balance;
1171 		
1172 		(,,,,uint256 jackpotToDispatch,) = calculateJackpot();
1173 		uint256 leftToWithdraw = devGift.sub(withdrawMinOwner);
1174 		uint256 leftInTheContract = balance.sub(jackpotToDispatch);
1175 			
1176 		if (leftToWithdraw > 0 && balance > jackpotToDispatch){
1177 			/// ok he can still withdraw
1178 			if (leftInTheContract > leftToWithdraw){
1179 				uint256 devToWithdraw = leftToWithdraw;				
1180 			} else devToWithdraw = leftInTheContract;			
1181 		}
1182 		
1183 		return devToWithdraw;
1184 	}
1185 
1186 
1187 
1188 
1189 	
1190 //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
1191 //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
1192 //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
1193 	
1194 //////////////////////////
1195 /// INTERNAL FUNCTIONS ///
1196 //////////////////////////
1197 
1198 /// Heavy pay function for Nukes ///
1199 	function payCuts(
1200 		uint256 _value,
1201 		uint256 _balance,
1202 		uint256 _countryId,
1203 		uint256 _timestamp
1204 	) 
1205 		internal
1206 	{
1207 		require(_value <= _balance);
1208 		require(_value != 0);
1209 		
1210 		/// Get the next trophy card owner to send cuts
1211 		address nextTrophyOwner = nextTrophyCardUpdateAndGetOwner();
1212 		
1213 			if (nextTrophyOwner == 0) {
1214 				nextTrophyOwner = owner;
1215 			}
1216 		
1217 		
1218 		/// Get the country owner to send cuts
1219 		address countryOwner = newOwner[_countryId];
1220 		
1221 			if (countryOwner == 0) {
1222 				countryOwner = owner;
1223 			}		
1224 
1225 			
1226 		/// Get the best lover to send cuts
1227 		address bestLoverToGetDivs = loversSTR[gameVersion][_countryId].bestLover;
1228 		
1229 			if (bestLoverToGetDivs == 0) {
1230 				bestLoverToGetDivs = owner;
1231 			}
1232 
1233 			
1234 		/// Calculate cuts
1235 		uint256 devCutPay = _value.mul(devCut).div(1000);
1236 		uint256 superCountriesPotCutPay = _value.mul(potCutSuperCountries).div(1000);
1237 		uint256 trophyAndOwnerCutPay = _value.mul(playerCut).div(1000);
1238 		
1239 		
1240 		/// Pay cuts ///			
1241 		owner.transfer(devCutPay);
1242 		contractSC.transfer(superCountriesPotCutPay);
1243 		nextTrophyOwner.transfer(trophyAndOwnerCutPay);
1244 		countryOwner.transfer(trophyAndOwnerCutPay);
1245 		bestLoverToGetDivs.transfer(trophyAndOwnerCutPay);
1246 		
1247 		emit CutsPaidInfos(_timestamp, _countryId, countryOwner, nextTrophyOwner, bestLoverToGetDivs);
1248 		emit CutsPaidValue(_timestamp, _value, address(this).balance, devCutPay, trophyAndOwnerCutPay, superCountriesPotCutPay);
1249 		
1250 		assert(_balance.sub(_value) <= address(this).balance); 
1251 		assert((trophyAndOwnerCutPay.mul(3).add(devCutPay).add(superCountriesPotCutPay)) < _value);	
1252 	}
1253 
1254 
1255 
1256 /// Light pay function for Kings ///
1257 	function payCutsLight(
1258 		uint256 _value,
1259 		uint256 _balance,
1260 		uint256 _timestamp
1261 	) 
1262 		internal
1263 	{
1264 		require(_value <= _balance);
1265 		require(_value != 0);		
1266 
1267 		/// Get the next trophy card owner to send cuts
1268 		address nextTrophyOwner = nextTrophyCardUpdateAndGetOwner();
1269 		
1270 			if (nextTrophyOwner == 0) {
1271 				nextTrophyOwner = owner;
1272 			}
1273 
1274 		/// Get the last nuker to send cuts
1275 		address lastNuker = nukerAddress[lastNukedCountry];
1276 		
1277 			if (lastNuker == 0) {
1278 				lastNuker = owner;
1279 			}			
1280 			
1281 			
1282 		/// Calculate cuts
1283 		uint256 trophyCutPay = _value.mul(playerCut).div(1000);
1284 		uint256 superCountriesPotCutPay = ((_value.mul(potCutSuperCountries).div(1000)).add(trophyCutPay)).div(2); /// Divide by 2: one part for SCPot, one for lastNuker
1285 		uint256 devCutPay = (_value.mul(devCut).div(1000)).add(trophyCutPay);			
1286 
1287 		
1288 		/// Pay cuts ///			
1289 		owner.transfer(devCutPay);
1290 		contractSC.transfer(superCountriesPotCutPay);
1291 		lastNuker.transfer(superCountriesPotCutPay);
1292 		nextTrophyOwner.transfer(trophyCutPay);
1293 		
1294 		emit CutsPaidLight(_timestamp, _value, address(this).balance, devCutPay, trophyCutPay, nextTrophyOwner, superCountriesPotCutPay);
1295 		
1296 		assert(_balance.sub(_value) <= address(this).balance); 
1297 		assert((trophyCutPay.add(devCutPay).add(superCountriesPotCutPay)) < _value);
1298 	}
1299 	
1300 
1301 	
1302 /// Refund the nuker / new king if excess
1303 	function excessRefund(
1304 		address _payer,
1305 		uint256 _priceToPay,
1306 		uint256 paidPrice
1307 	) 
1308 		internal
1309 	{		
1310 		uint256 excess = paidPrice.sub(_priceToPay);
1311 		
1312 		if (excess > 0) {
1313 			_payer.transfer(excess);
1314 		}
1315 	}		
1316 	
1317 	
1318 	
1319 /// Update the jackpot timestamp each time a country is nuked or a new king crowned	
1320 	function updateJackpotTimestamp(uint256 _timestamp) internal {		
1321 
1322 		jackpotTimestamp = _timestamp.add(604800);  /// 1 week
1323 		
1324 		emit NewJackpotTimestamp(jackpotTimestamp, _timestamp);			
1325 	}
1326 
1327 
1328 
1329 /// If first love > 24h, the player can love again
1330 /// and get extra loves if loved yesterday
1331 	function updateLovesForToday(address _player, uint256 _timestampNow) internal {		
1332 		
1333 		uint256 firstLoveAdd24 = firstLove[_player].add(SLONG);
1334 		uint256 firstLoveAdd48 = firstLove[_player].add(DLONG);
1335 		uint256 remainV = remainingLoves[_player];
1336 		
1337 		/// This player loved today but has some loves left
1338 		if (firstLoveAdd24 > _timestampNow && remainV > 0){
1339 			remainingLoves[_player] = remainV.sub(1);
1340 		}
1341 			/// This player loved yesterday but not today
1342 			else if (firstLoveAdd24 < _timestampNow && firstLoveAdd48 > _timestampNow){
1343 				remainingLoves[_player] = (howManyEliminated.div(4)).add(freeRemainingLovesPerDay);
1344 				firstLove[_player] = _timestampNow;
1345 			}
1346 		
1347 				/// This player didn't love for 48h, he can love today
1348 				else if (firstLoveAdd48 < _timestampNow){
1349 					remainingLoves[_player] = freeRemainingLovesPerDay;
1350 					firstLove[_player] = _timestampNow;
1351 				}	
1352 					/// This player is a zombie
1353 					else remainingLoves[_player] = 0;
1354 
1355 	}
1356 
1357 	
1358 	
1359 	
1360 	
1361 //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
1362 //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
1363 //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
1364 	
1365 ////////////////////////////////////
1366 /// 	WAR - PUBLIC FUNCTIONS	 ///
1367 ////////////////////////////////////
1368 
1369 //////////////////////
1370 /// NUKE A COUNTRY ///
1371 //////////////////////
1372 	function nuke(uint256 _countryId) payable public onlyGameNOTPaused{
1373 		require(_countryId < allCountriesLength);
1374 		require(msg.value >= war_getNextNukePriceForCountry(_countryId)); 
1375 		require(war_getNextNukePriceForCountry(_countryId) > 0); 
1376 		require(isEliminated(_countryId) == false);
1377 		require(canPlayTimestamp()); /// Impossible to nuke 2 hours after the jackpot
1378 		require(loversSTR[gameVersion][_countryId].bestLover != msg.sender); /// The best lover cannot nuke his favorite country
1379 		require(_countryId != mostLovedCountry || allCountriesLength.sub(howManyEliminated) < 5); /// We cannot nuke the mostLovedCountry if more than 4 countries stand
1380 				
1381 		address player = msg.sender;
1382 		uint256 timestampNow = block.timestamp;
1383 		uint256 gameId = gameVersion;
1384 		uint256 thisBalance = address(this).balance;		
1385 		uint256 priceToPay = war_getNextNukePriceForCountry(_countryId);
1386 		
1387 		/// Update the latest nuker of the game in the nukerAddress array
1388 		nukerAddress[_countryId] = player;
1389 		
1390 		/// Get last known price of this country for next time
1391 		uint256 lastPriceOld = lastKnownCountryPrice[_countryId];
1392 		lastKnownCountryPrice[_countryId] = getPriceOfCountry(_countryId);
1393 		
1394 		/// Change the activation of this country
1395 		eliminated[gameId][_countryId] = true;
1396 		howManyEliminated++;
1397 		
1398 		if (howManyEliminated.add(1) == allCountriesLength){
1399 			jackpotTimestamp = block.timestamp;
1400 			emit LastCountryStanding(_countryId, player, thisBalance, gameId, jackpotTimestamp);
1401 		}	
1402 			else {
1403 				/// Update next price
1404 				uint priceRaw = war_getNextNukePriceRaw();			
1405 				nextPrice[gameId] = priceRaw.mul(kNext).div(1000);
1406 				
1407 				/// and update the jackpot
1408 				updateJackpotTimestamp(timestampNow);
1409 			}
1410 							
1411 		lastNukedCountry = _countryId;		
1412 		payCuts(priceToPay, thisBalance, _countryId, timestampNow);
1413 		excessRefund(player, priceToPay, msg.value);
1414 		howManyNuked++;
1415 		
1416 		/// emit the event
1417 		emit Nuked(player, _countryId, priceToPay, priceRaw);
1418 		emit PlayerEvent(1, _countryId, player, timestampNow, howManyEliminated, gameId);
1419 
1420 		assert(lastKnownCountryPrice[_countryId] >= lastPriceOld);
1421 	}
1422 
1423 	
1424 	
1425 ///////////////////////////
1426 /// REANIMATE A COUNTRY ///
1427 ///////////////////////////	
1428 	function reanimateCountry(uint256 _countryId) public onlyGameNOTPaused{
1429 		require(canPlayerReanimate(_countryId, msg.sender) == true);
1430 		
1431 		address player = msg.sender;
1432 		eliminated[gameVersion][_countryId] = false;
1433 		
1434 		newOwner[_countryId] = player;
1435 		
1436 		howManyEliminated = howManyEliminated.sub(1);
1437 		howManyReactivated++;
1438 		
1439 		emit Reactivation(_countryId, howManyReactivated);
1440 		emit PlayerEvent(2, _countryId, player, block.timestamp, howManyEliminated, gameVersion);		
1441 	} 
1442 
1443 
1444 
1445 /////////////////////
1446 /// BECOME A KING ///
1447 /////////////////////		
1448 	function becomeNewKing(uint256 _continentId) payable public onlyGameNOTPaused{
1449 		require(msg.value >= kingPrice);
1450 		require(canPlayTimestamp()); /// Impossible to play 2 hours after the jackpot
1451 				
1452 		address player = msg.sender;
1453 		uint256 timestampNow = block.timestamp;
1454 		uint256 gameId = gameVersion;
1455 		uint256 thisBalance = address(this).balance;
1456 		uint256 priceToPay = kingPrice;
1457 		
1458 		continentKing[_continentId] = player;
1459 		
1460 		updateJackpotTimestamp(timestampNow);
1461 
1462 		if (continentFlips >= maxFlips){
1463 			kingPrice = priceToPay.mul(kKings).div(100);
1464 			continentFlips = 0;
1465 			emit NewKingPrice(kingPrice, kKings);
1466 			} else continentFlips++;
1467 		
1468 		payCutsLight(priceToPay, thisBalance, timestampNow);
1469 		
1470 		excessRefund(player, priceToPay, msg.value);
1471 		
1472 		/// emit the event
1473 		emit NewKingContinent(player, _continentId, priceToPay);
1474 		emit PlayerEvent(3, _continentId, player, timestampNow, continentFlips, gameId);		
1475 	}	
1476 
1477 
1478 
1479 //////////////////////////////	
1480 /// SEND LOVE TO A COUNTRY ///
1481 //////////////////////////////	
1482 /// Everybody can love few times a day, and get extra loves if loved yesterday
1483 	function upLove(uint256 _countryId) public onlyGameNOTPaused{
1484 		require(canPlayerLove(msg.sender)); 
1485 		require(_countryId < allCountriesLength);	
1486 		require(!isEliminated(_countryId)); /// We cannot love an eliminated country
1487 		require(block.timestamp.add(DSHORT) < jackpotTimestamp || block.timestamp > jackpotTimestamp.add(DSHORT)); 
1488 	
1489 		address lover = msg.sender;
1490 		address countryOwner = getCountryOwner(_countryId);
1491 		uint256 gameId = gameVersion;
1492 		
1493 		LoverStructure storage c = loversSTR[gameId][_countryId];
1494 		uint256 nukecount = howManyNuked;
1495 		
1496 		/// Increase the number of loves for this lover for this country
1497 		c.loves[nukecount][lover]++;
1498 		uint256 playerLoves = c.loves[nukecount][lover];
1499 		uint256 maxLovesBest = c.maxLoves[nukecount];
1500 				
1501 		/// Update the bestlover if this is the case
1502 		if 	(playerLoves > maxLovesBest){
1503 			c.maxLoves[nukecount]++;
1504 			
1505 			/// Update the mostLovedCountry
1506 			if (_countryId != mostLovedCountry && playerLoves > loversSTR[gameId][mostLovedCountry].maxLoves[nukecount]){
1507 				mostLovedCountry = _countryId;
1508 				
1509 				emit newMostLovedCountry(_countryId, playerLoves);
1510 			}
1511 			
1512 			/// If the best lover is a new bets lover, update
1513 			if (c.bestLover != lover){
1514 				c.bestLover = lover;
1515 				
1516 				/// Send a free love to the king of this continent if he is not the best lover and remaining loves lesser than 16
1517 				address ourKing = continentKing[countryToContinent[_countryId]];
1518 				if (ourKing != lover && remainingLoves[ourKing] < 16){
1519 				remainingLoves[ourKing]++;
1520 				}
1521 			}
1522 			
1523 			emit NewBestLover(lover, _countryId, playerLoves);
1524 		}
1525 		
1526 		/// Update the ownership if this is the case
1527 		if (newOwner[_countryId] != countryOwner){
1528 			newOwner[_countryId] = countryOwner;
1529 			emit ThereIsANewOwner(countryOwner, _countryId);
1530 		}		
1531 		
1532 		/// Update the number of loves for today
1533 		updateLovesForToday(lover, block.timestamp);
1534 		
1535 		/// Emit the event		
1536 		emit NewLove(lover, _countryId, playerLoves, gameId, nukecount);
1537 	}
1538 	
1539 	
1540 	
1541 
1542 
1543 //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
1544 //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
1545 //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
1546 	
1547 ////////////////////////
1548 /// UPDATE FUNCTIONS ///
1549 ////////////////////////
1550 
1551 /// Get the price of all countries before the start of the game
1552 	function storePriceOfAllCountries(uint256 _limitDown, uint256 _limitUp) public onlyOwner {
1553 		require (_limitDown < _limitUp);
1554 		require (_limitUp <= allCountriesLength);
1555 		
1556 		uint256 getPrice;
1557 		address getTheOwner;
1558 		
1559 		for (uint256 i = _limitDown; i < _limitUp; i++) {
1560 			getPrice = getPriceOfCountry(i);
1561 			getTheOwner = getCountryOwner(i);
1562 			
1563 			lastKnownCountryPrice[i] = getPrice;
1564 			newOwner[i] = getTheOwner;
1565 			
1566 			if (getPrice == 0 || getTheOwner ==0){
1567 				emit ErrorCountry(i);
1568 			}
1569 		}
1570 	}
1571 
1572 	
1573 	
1574 
1575 /// Update cuts ///	
1576 /// Beware, cuts are PERTHOUSAND, not percent
1577 	function updateCuts(uint256 _newDevcut, uint256 _newPlayercut, uint256 _newSuperCountriesJackpotCut) public onlyOwner {
1578 		require(_newPlayercut.mul(3).add(_newDevcut).add(_newSuperCountriesJackpotCut) <= 700);
1579 		require(_newDevcut > 100);		
1580 		
1581 		devCut = _newDevcut;
1582 		playerCut = _newPlayercut;
1583 		potCutSuperCountries = _newSuperCountriesJackpotCut;
1584 
1585 		emit CutsUpdated(_newDevcut, _newPlayercut, _newSuperCountriesJackpotCut, block.timestamp);
1586 		
1587 	}
1588 
1589 	
1590 
1591 
1592 /// Change nuke and kings prices and other price parameters
1593 	function updatePrices(
1594 		uint256 _newStartingPrice,
1595 		uint256 _newKingPrice,
1596 		uint256 _newKNext,
1597 		uint256 _newKCountry,
1598 		uint256 _newKLimit,
1599 		uint256 _newkKings,
1600 		uint256 _newMaxFlips
1601 	)
1602 		public 
1603 		onlyOwner
1604 	{
1605 		startingPrice = _newStartingPrice;
1606 		kingPrice = _newKingPrice;
1607 		kNext = _newKNext;
1608 		kCountry = _newKCountry;
1609 		kCountryLimit = _newKLimit;
1610 		kKings = _newkKings;
1611 		maxFlips = _newMaxFlips;
1612 
1613 		emit ConstantsUpdated(_newStartingPrice, _newKingPrice, _newKNext, _newKCountry, _newKLimit, _newkKings, _newMaxFlips);		
1614 	}
1615 
1616 
1617 	
1618 
1619 /// Change various parameters
1620 	function updateValue(uint256 _code, uint256 _newValue) public onlyOwner {					
1621 		if (_code == 1 ){
1622 			continentKing.length = _newValue;
1623 		} 
1624 			else if (_code == 2 ){
1625 				allCountriesLength = _newValue;
1626 			} 
1627 				else if (_code == 3 ){
1628 					freeRemainingLovesPerDay = _newValue;
1629 					} 		
1630 		
1631 		emit NewValue(_code, _newValue, block.timestamp);		
1632 	}
1633 
1634 
1635 
1636 
1637 /// Store countries into continents - multi countries for 1 continent function
1638 	function updateCountryToContinentMany(uint256[] _countryIds, uint256 _continentId) external onlyOwner {					
1639 		for (uint256 i = 0; i < _countryIds.length; i++) {
1640 			updateCountryToContinent(_countryIds[i], _continentId);
1641 		}		
1642 	}
1643 
1644 
1645 
1646 
1647 /// Store countries into continents	- 1 country for 1 continent function
1648 	function updateCountryToContinent(uint256 _countryId, uint256 _continentId) public onlyOwner {					
1649 		require(_countryId < allCountriesLength);
1650 		require(_continentId < continentKing.length);
1651 		
1652 		countryToContinent[_countryId] = _continentId;
1653 		
1654 		emit NewCountryToContinent(_countryId, _continentId, block.timestamp);		
1655 	}
1656 
1657 
1658 	
1659 	
1660 /// If needed, update the external Trophy Cards contract address
1661 	function updateTCContract(address _newAddress) public onlyOwner() {
1662 		contractTrophyCards = _newAddress;
1663 		SCTrophy = SuperCountriesTrophyCardsExternal(_newAddress);
1664 		
1665 		emit NewContractAddress(_newAddress);			
1666 	}
1667 
1668 
1669 
1670 
1671 
1672 //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
1673 //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
1674 //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
1675 	
1676 /////////////////////////////////
1677 /// WIN THE JACKPOT FUNCTIONS ///
1678 /////////////////////////////////	
1679 
1680 
1681 	function jackpotShareDispatch(
1682 		address _winner,
1683 		uint256 _share,
1684 		uint256 _customValue,
1685 		bytes32 _customText
1686 	) 
1687 		internal
1688 		returns (uint256 shareDispatched_)
1689 	{
1690 		if (_winner == 0){
1691 			_winner = owner;
1692 		}
1693 		
1694 		uint256 potDispatched = _share;								
1695 		winnersJackpot[gameVersion][_winner] += _share;	
1696 		
1697 		emit JackpotDispatch(_winner, _share, _customValue, _customText);
1698 
1699 		return potDispatched;
1700 	}
1701 	
1702 	
1703 
1704 
1705 /// Internal jackpot function for Country Owners ///
1706 	function jackpotCountryReward(uint256 _countryPot) internal returns (uint256 winningCountry_, uint256 dispatched_){
1707 		
1708 		/// Is there a last standing country or not?
1709 		uint256 potDispatched;
1710 		
1711 		if (howManyStandingOrNot(true) == 1){
1712 			
1713 			/// There is only one country left: the winning country is the last standing country
1714 			/// And the owner of this country will not share the countryPot with other owners, all is for him!
1715 			uint256 winningCountryId = lastStanding();
1716 			address tempWinner = newOwner[winningCountryId];
1717 			potDispatched = jackpotShareDispatch(tempWinner, _countryPot, winningCountryId, "lastOwner");
1718 		} 	
1719 			else {
1720 				/// if else, there is more than one country standing, 
1721 				/// we will reward the standing countries of the last nuked country continent
1722 				winningCountryId = lastNukedCountry;
1723 				uint256 continentId = countryToContinent[winningCountryId];
1724 				
1725 				uint256[] memory standingNations = country_getAllStandingCountriesForContinent(continentId, true);
1726 				uint256 howManyCountries = standingNations.length;
1727 				
1728 				/// If there is at least one standing country in this continent
1729 				if (howManyCountries > 0) {
1730 				
1731 					uint256 winningCounter;
1732 					uint256 countryPotForOne = _countryPot.div(howManyCountries);
1733 					
1734 					for (uint256 i = 0; i < howManyCountries && potDispatched <= _countryPot; i++) {
1735 						
1736 						uint256 tempCountry = standingNations[i];
1737 						/// Get the current owner
1738 						tempWinner = newOwner[tempCountry];
1739 						potDispatched += jackpotShareDispatch(tempWinner, countryPotForOne, tempCountry, "anOwner");
1740 						winningCounter++;
1741 						
1742 						if (winningCounter == howManyCountries || potDispatched.add(countryPotForOne) > _countryPot){
1743 							break;
1744 						}
1745 					}
1746 				}
1747 					
1748 					/// There is no standing country in this continent, the owner of the last nuked country wins the jackpot (owner's share)
1749 					else {
1750 						tempWinner = newOwner[winningCountryId];
1751 						potDispatched = jackpotShareDispatch(tempWinner, _countryPot, winningCountryId, "lastNukedOwner");
1752 						
1753 					}
1754 				}	
1755 			
1756 		return (winningCountryId, potDispatched);
1757 	}
1758 
1759 
1760 
1761 
1762 	
1763 /// PUBLIC JACKPOT FUNCTION TO CALL TO SHARE THE JACKPOT
1764 /// After the jackpot, anyone can call the jackpotWIN function, it will dispatch prizes between winners
1765 	function jackpotWIN() public onlyGameNOTPaused {
1766 		require(block.timestamp > jackpotTimestamp); /// True if latestPayer + 7 days or Only one country standing
1767 		require(address(this).balance >= 1e11);
1768 		require(thisJackpotIsPlayedAndNotWon[gameVersion]); /// if true, we are currently playing this jackpot and it's not won yet 
1769 		
1770 		uint256 gameId = gameVersion;
1771 		
1772 		/// Pause the game
1773 		gameRunning = false;
1774 
1775 		
1776 		///////////////////////////////////////////////
1777 		////////// How much for the winners? //////////
1778 		///////////////////////////////////////////////	
1779 		
1780 		/// Calculate shares
1781 		(uint256 nukerPot, uint256 countryPot, uint256 continentPot, uint256 freePot, uint256 pot,) = calculateJackpot();
1782 		
1783 		/// This jackpot is won, disable it
1784 		/// If false, this function will not be callable again
1785 		thisJackpotIsPlayedAndNotWon[gameId] = false;		
1786 
1787 				
1788 		////////////////////////////////////////////////////
1789 		////////// Which country won the jackpot? //////////
1790 		////////////////////////////////////////////////////
1791 
1792 		/// Dispatch shares between country owners and save the winning country ///	
1793 		(uint256 winningCountryId, uint256 potDispatched) = jackpotCountryReward(countryPot);	
1794 		winningCountry[gameId] = winningCountryId;
1795 		uint256 continentId = countryToContinent[winningCountryId];
1796 
1797 			
1798 		////////////////////////////////////////////////
1799 		////////// Who are the other winners? //////////
1800 		////////////////////////////////////////////////	
1801 
1802 		/// The king of the right continent
1803 		potDispatched += jackpotShareDispatch(continentKing[continentId], continentPot, continentId, "continent");
1804 		
1805 		
1806 		/// The best lover for this country
1807 		potDispatched += jackpotShareDispatch(loversSTR[gameId][winningCountryId].bestLover, freePot, 0, "free");
1808 		
1809 		
1810 		/// The last nuker
1811 		potDispatched += jackpotShareDispatch(nukerAddress[winningCountryId], nukerPot, 0, "nuker");
1812 			
1813 				
1814 		/// Emit the events ///
1815 		emit JackpotDispatchAll(gameId, winningCountryId, continentId, block.timestamp, jackpotTimestamp, pot, potDispatched, address(this).balance);
1816 		emit PausedOrUnpaused(block.timestamp, gameRunning);
1817 
1818 		
1819 		/// Last check ///
1820 		assert(potDispatched <= address(this).balance);		
1821 	}
1822 			
1823 
1824 			
1825 
1826 /// After the sharing, all winners will be able to call this function to withdraw the won share to the their wallets
1827 	function withdrawWinners() public onlyRealAddress {
1828 		require(winnersJackpot[gameVersion][msg.sender] > 0);
1829 		
1830 		address _winnerAddress = msg.sender;
1831         uint256 gameId = gameVersion;
1832 		
1833         /// Prepare for the withdrawal
1834 		uint256 jackpotToTransfer = winnersJackpot[gameId][_winnerAddress];
1835 		winnersJackpot[gameId][_winnerAddress] = 0;
1836 		
1837         /// fire event
1838         emit WithdrawJackpot(_winnerAddress, jackpotToTransfer, gameId);
1839 		
1840 		/// Withdraw
1841         _winnerAddress.transfer(jackpotToTransfer);
1842 	}
1843 
1844 
1845 	
1846 
1847 	
1848 //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
1849 //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
1850 //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////		
1851 
1852 ///////////////////////////////
1853 ///		RESTART A NEW GAME 	///
1854 ///////////////////////////////	
1855 
1856 /// After the jackpot, restart a new game with same settings ///
1857 /// The owner can restart 2 hrs after the jackpot
1858 /// If the owner doesn't restart the game 30 days after the jackpot, all players can restart the game
1859 	function restartNewGame() public onlyGamePaused{
1860 		require((msg.sender == owner && block.timestamp > jackpotTimestamp.add(DSHORT)) || block.timestamp > jackpotTimestamp.add(2629000));
1861 		
1862 		uint256 timestampNow = block.timestamp;
1863 		
1864 		/// Clear all values, loves, nextPrices...	but bestlovers, lovers will remain
1865 		if (nextPrice[gameVersion] !=0){
1866 			gameVersion++;
1867 			lastNukedCountry = 0;
1868 			howManyNuked = 0;
1869 			howManyReactivated = 0;
1870 			howManyEliminated = 0;
1871 			
1872 			lastNukerMin = 0;
1873 			countryOwnerMin = 0;
1874 			continentMin = 0;
1875 			freePlayerMin = 0;
1876 			withdrawMinOwner = 0;
1877 
1878 			kingPrice = 1e16;
1879 			
1880 			newOwner.length = 0;
1881 			nukerAddress.length = 0;
1882 			newOwner.length = allCountriesLength;
1883 			nukerAddress.length = allCountriesLength;
1884 		}
1885 		
1886 		/// Set new jackpot timestamp
1887 		updateJackpotTimestamp(timestampNow);
1888 		
1889 		/// Restart
1890 		gameRunning = true;	
1891 		thisJackpotIsPlayedAndNotWon[gameVersion] = true;
1892 
1893         /// fire event
1894         emit NewGameLaunched(gameVersion, timestampNow, msg.sender, jackpotTimestamp);
1895 		emit PausedOrUnpaused(block.timestamp, gameRunning);		
1896 	}
1897 
1898 	
1899 
1900 
1901 
1902 //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
1903 //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
1904 //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
1905 	
1906 ////////////////////////
1907 /// USEFUL FUNCTIONS ///
1908 ////////////////////////
1909 
1910   /** 
1911    * @dev Fallback function to accept all ether sent directly to the contract
1912    * Nothing is lost, it will raise the jackpot!
1913    */
1914 	function() payable public {    }	
1915 
1916 
1917 
1918 
1919 	
1920 /// After the jackpot, the owner can restart a new game or withdraw if winners don't want their part
1921 	function withdraw() public onlyOwner {
1922 		require(block.timestamp > jackpotTimestamp.add(DSHORT) || address(this).balance <= 1e11 || whatDevCanWithdraw() > 0);
1923 		
1924 		uint256 thisBalance = address(this).balance;
1925 		
1926 		if (block.timestamp > jackpotTimestamp.add(DSHORT) || thisBalance <= 1e11 ){
1927 			uint256 toWithdraw = thisBalance;
1928 		}
1929 		
1930 		else {
1931 			
1932 			toWithdraw = whatDevCanWithdraw();
1933 			withdrawMinOwner += toWithdraw;
1934 		}			
1935 		
1936 		emit WithdrawByDev(block.timestamp, toWithdraw, withdrawMinOwner, thisBalance);
1937 		
1938 		owner.transfer(toWithdraw);	
1939 	}
1940 
1941 	
1942 
1943 
1944 
1945 //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
1946 //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
1947 //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
1948 
1949 ///////////////////////////////
1950 /// LAST STANDING FUNCTIONS ///
1951 ///////////////////////////////	
1952 
1953 	function trueStandingFalseEliminated(bool _standing) public view returns (uint256[] countries_) {
1954 		uint256 howLong = howManyStandingOrNot(_standing);
1955 		uint256[] memory countries = new uint256[](howLong);
1956 		uint256 standingCounter = 0;
1957 		uint256 gameId = gameVersion;
1958 		
1959 		for (uint256 i = 0; i < allCountriesLength; i++) {
1960 			if (eliminated[gameId][i] != _standing){
1961 				countries[standingCounter] = i;
1962 				standingCounter++;
1963 			}
1964 
1965 			if (standingCounter == howLong){break;}
1966 		}
1967 		
1968 		return countries;
1969 	}	
1970 
1971 	
1972 
1973 	
1974 	function howManyStandingOrNot(bool _standing) public view returns (uint256 howManyCountries_) {
1975 		uint256 standingCounter = 0;
1976 		uint256 gameId = gameVersion;
1977 		
1978 		for (uint256 i = 0; i < allCountriesLength; i++) {
1979 			if (eliminated[gameId][i] != _standing){
1980 				standingCounter++;
1981 			}					
1982 		}	
1983 		
1984 		return standingCounter;
1985 	}
1986 
1987 	
1988 
1989 	
1990 	function lastStanding() public view returns (uint256 lastStandingNation_) {
1991 		require (howManyStandingOrNot(true) == 1);
1992 
1993 		return trueStandingFalseEliminated(true)[0];
1994 	}
1995 	
1996 }