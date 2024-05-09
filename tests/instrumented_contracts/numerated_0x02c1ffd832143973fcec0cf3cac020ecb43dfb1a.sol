1 pragma solidity ^0.5.4;
2 
3 /**
4  *	Lottery 5 of 36 (Weekly)
5  */
6  
7 contract SmartLotto {
8     
9 	// For safe math operations
10     using SafeMath for uint;
11 	
12 	// Drawing time
13     uint8 private constant DRAW_DOW = 4;            // Day of week
14     uint8 private constant DRAW_HOUR = 11;          // Hour
15     
16     uint private constant DAY_IN_SECONDS = 86400;
17     
18 	// Member struct
19 	struct Member {
20 		address addr;								// Address
21 		uint ticket;								// Ticket number
22 		uint8[5] numbers;                           // Selected numbers
23 		uint prize;                                 // Winning prize
24 		uint8 payout;								// Payout prize
25 	}
26 	
27 	// Game struct
28 	struct Game {
29 		uint datetime;								// Game timestamp
30 		uint8[5] win_numbers;						// Winning numbers
31 		uint membersCounter;						// Members count
32 		uint totalFund;                             // Total prize fund
33 		uint p2;									// Prize for 2 guessed numbers
34 		uint p3;									// Prize for 3 guessed numbers
35 		uint p4;									// Prize for 4 guessed numbers
36 		uint p5;									// Prize for 5 guessed numbers
37 		uint8 status;                               // Game status: 0 - created, 1 - active
38 		mapping(uint => Member) members;		    // Members list
39 	}
40 	
41 	mapping(uint => Game) public games;
42 	
43 	uint private CONTRACT_STARTED_DATE = 0;
44 	uint private constant TICKET_PRICE = 0.01 ether;
45 	uint private constant MAX_NUMBER = 36;						            // Максимально возможное число -> 36
46 	
47 	uint private constant PERCENT_FUND_JACKPOT = 15;                        // (%) Increase Jackpot
48 	uint private constant PERCENT_FUND_4 = 35;                              // (%) Fund 4 of 5
49 	uint private constant PERCENT_FUND_3 = 30;                              // (%) Fund 3 of 5
50     uint private constant PERCENT_FUND_2 = 20;                              // (%) Fund 2 of 5
51     
52 	uint public JACKPOT = 0;
53 	
54 	// Init params
55 	uint public GAME_NUM = 0;
56 	uint private constant return_jackpot_period = 25 weeks;
57 	uint private start_jackpot_amount = 0;
58 	
59 	uint private constant PERCENT_FUND_PR = 15;                             // (%) PR & ADV
60 	uint private FUND_PR = 0;                                               // Fund PR & ADV
61 
62 	// Addresses
63 	address private constant ADDRESS_SERVICE = 0x203bF6B46508eD917c085F50F194F36b0a62EB02;
64 	address payable private constant ADDRESS_START_JACKPOT = 0x531d3Bd0400Ae601f26B335EfbD787415Aa5CB81;
65 	address payable private constant ADDRESS_PR = 0xCD66911b6f38FaAF5BFeE427b3Ceb7D18Dd09F78;
66 	
67 	// Events
68 	event NewMember(uint _gamenum, uint _ticket, address _addr, uint8 _n1, uint8 _n2, uint8 _n3, uint8 _n4, uint8 _n5);
69 	event NewGame(uint _gamenum);
70 	event UpdateFund(uint _fund);
71 	event UpdateJackpot(uint _jackpot);
72 	event WinNumbers(uint _gamenum, uint8 _n1, uint8 _n2, uint8 _n3, uint8 _n4, uint8 _n5);
73 	event PayOut(uint _gamenum, uint _ticket, uint _prize, uint8 _payout);
74 	
75 	// For many processing transactions
76 	uint private constant POOL_SIZE = 30;										// MAX processing tickets by transaction
77 	uint private POOL_COUNTER = 0;
78 	
79 	uint private w2 = 0;
80 	uint private w3 = 0;
81 	uint private w4 = 0;
82 	uint private w5 = 0;
83 	
84 	// Entry point
85 	function() external payable {
86 	    
87         // Select action
88 		if(msg.sender == ADDRESS_START_JACKPOT) {
89 			processStartingJackpot();
90 		} else {
91 			if(msg.sender == ADDRESS_SERVICE) {
92 				startGame();
93 			} else {
94 				processUserTicket();
95 			}
96 		}
97 		
98     }
99 	
100 
101 	///////////////////////////////////////////////////////////////////////////////////////////////////////
102 	// Starting Jackpot action
103 	///////////////////////////////////////////////////////////////////////////////////////////////////////
104 	function processStartingJackpot() private {
105 		// If value > 0, increase starting Jackpot
106 		if(msg.value > 0) {
107 			JACKPOT += msg.value;
108 			start_jackpot_amount += msg.value;
109 			emit UpdateJackpot(JACKPOT);
110 		// Else, return starting Jackpot
111 		} else {
112 			if(start_jackpot_amount > 0){
113 				_returnStartJackpot();
114 			}
115 		}
116 		
117 	}
118 	
119 	// Return starting Jackpot after 6 months
120 	function _returnStartJackpot() private { 
121 		
122 		if(JACKPOT > start_jackpot_amount * 2 || (now - CONTRACT_STARTED_DATE) > return_jackpot_period) {
123 			
124 			if(JACKPOT > start_jackpot_amount) {
125 				ADDRESS_START_JACKPOT.transfer(start_jackpot_amount);
126 				JACKPOT = JACKPOT - start_jackpot_amount;
127 				start_jackpot_amount = 0;
128 			} else {
129 				ADDRESS_START_JACKPOT.transfer(JACKPOT);
130 				start_jackpot_amount = 0;
131 				JACKPOT = 0;
132 			}
133 			emit UpdateJackpot(JACKPOT);
134 			
135 		} 
136 		
137 	}
138 	
139 	
140 	///////////////////////////////////////////////////////////////////////////////////////////////////////
141 	// Running a Game
142 	///////////////////////////////////////////////////////////////////////////////////////////////////////
143 	function startGame() private {
144 	    
145 		if(GAME_NUM == 0) {
146 		    GAME_NUM = 1;
147 		    games[GAME_NUM].datetime = now;
148 		    games[GAME_NUM].status = 1;
149 		    CONTRACT_STARTED_DATE = now;
150 		} else {
151 		    
152 	        if(games[GAME_NUM].status == 1) {
153 	            processGame();
154 		    } else {
155 		        games[GAME_NUM].status = 1;
156 		    }
157 		    
158 		}
159         
160 	}
161 	
162 	function processGame() private {
163 	    
164 		uint8[5] memory win_numbers;
165 		uint8 mn = 0;
166 		
167 	    // 1-st time generate winning numbers
168 		if(POOL_COUNTER == 0) {
169 			
170 			w2 = 0;
171 			w3 = 0;
172 			w4 = 0;
173 			w5 = 0;
174 		
175 			// Generate winning numbers
176 			for(uint8 i = 0; i < 5; i++) {
177 				win_numbers[i] = random(i);
178 			}
179 
180 			// Sort winning numbers array
181 			win_numbers = sortNumbers(win_numbers);
182 	    
183 			// Change dublicate numbers
184 			for(uint8 i = 0; i < 4; i++) {
185 				for(uint8 j = i + 1; j < 5; j++) {
186 					if(win_numbers[i] == win_numbers[j]) {
187 						win_numbers[j]++;
188 					}
189 				}
190 			}
191 	    
192 			games[GAME_NUM].win_numbers = win_numbers;
193 			emit WinNumbers(GAME_NUM, win_numbers[0], win_numbers[1], win_numbers[2], win_numbers[3], win_numbers[4]);
194 		
195 		} else {
196 		    
197 		    win_numbers = games[GAME_NUM].win_numbers;
198 		    
199 		}
200 		
201 
202 		// Process tickets list
203 		uint start 	= POOL_SIZE * POOL_COUNTER + 1;
204 		uint end 	= POOL_SIZE * POOL_COUNTER + POOL_SIZE;
205 		
206 		if(end > games[GAME_NUM].membersCounter) end = games[GAME_NUM].membersCounter;
207 		
208 		uint _w2 = 0;
209 		uint _w3 = 0;
210 		uint _w4 = 0;
211 		uint _w5 = 0;
212 		
213 	    for(uint i = start; i <= end; i++) {
214 	       
215 	        mn = findMatch(win_numbers, games[GAME_NUM].members[i].numbers);
216 				
217 			if(mn == 2) { _w2++; continue; }
218 			if(mn == 3) { _w3++; continue; }
219 			if(mn == 4) { _w4++; continue; }
220 			if(mn == 5) { _w5++; }
221 				
222 	    }
223 		
224 		if(_w2 != 0) { w2 += _w2; }
225 		if(_w3 != 0) { w3 += _w3; }
226 		if(_w4 != 0) { w4 += _w4; }
227 		if(_w5 != 0) { w2 += _w5; }
228 		
229 		if(end == games[GAME_NUM].membersCounter) {
230 		
231 			// Fund calculate
232 			uint totalFund = games[GAME_NUM].totalFund;
233 			
234 			uint fund2 = totalFund * PERCENT_FUND_2 / 100;
235 			uint fund3 = totalFund * PERCENT_FUND_3 / 100;
236 			uint fund4 = totalFund * PERCENT_FUND_4 / 100;
237 			uint _jackpot = JACKPOT + totalFund * PERCENT_FUND_JACKPOT / 100;
238 
239 			// If exist tickets 2/5
240 			if(w2 != 0) { 
241 				games[GAME_NUM].p2 = fund2 / w2; 
242 			} else { 
243 				_jackpot += fund2; 
244 			}
245 			
246 			// If exist tickets 3/5
247 			if(w3 != 0) { 
248 				games[GAME_NUM].p3 = fund3 / w3; 
249 			} else {
250 				_jackpot += fund3;
251 			}
252 			
253 			// If exist tickets 4/5
254 			if(w4 != 0) { 
255 				games[GAME_NUM].p4 = fund4 / w4; 
256 			} else {
257 				_jackpot += fund4;
258 			}
259 			
260 			// If exist tickets 5/5
261 			if(w5 != 0) { 
262 				games[GAME_NUM].p5 = _jackpot / w5; 
263 				JACKPOT = 0;
264 				start_jackpot_amount = 0;
265 			} else {
266 				JACKPOT = _jackpot;
267 			}
268 
269 			emit UpdateJackpot(JACKPOT);
270 	    
271 			// Init next Game /////////////////////////////////////////////////
272 			GAME_NUM++;
273 			games[GAME_NUM].datetime = now;
274 			emit NewGame(GAME_NUM);
275 			
276 			POOL_COUNTER = 0;
277 
278 			// Transfer PR 
279 			ADDRESS_PR.transfer(FUND_PR);
280 			FUND_PR = 0;
281 	    
282 		} else {
283 			
284 			POOL_COUNTER++;
285 
286 		}
287 		
288 	}
289 	
290 	// Find match numbers function
291 	function findMatch(uint8[5] memory arr1, uint8[5] memory arr2) private pure returns (uint8) {
292 	    
293 	    uint8 cnt = 0;
294 	    
295 	    for(uint8 i = 0; i < 5; i++) {
296 	        for(uint8 j = 0; j < 5; j++) {
297 	            if(arr1[i] == arr2[j]) {
298 	                cnt++;
299 	                break;
300 	            }
301 	        }
302 	    }
303 	    
304 	    return cnt;
305 
306 	}
307 	
308 	///////////////////////////////////////////////////////////////////////////////////////////////////////
309 	// Buy ticket process (if msg.value != 0.0 ETH) or payout winnings (if msg.value == 0.0 ETH)
310 	///////////////////////////////////////////////////////////////////////////////////////////////////////
311 	function processUserTicket() private {
312 		
313 		// Payout
314 		if(msg.value == 0) {
315 			
316 			if(games[GAME_NUM].status != 1 || POOL_COUNTER > 0) return;
317 			
318 			uint payoutAmount = 0;
319 			for(uint i = 1; i <= GAME_NUM; i++) {
320 				
321 				Game memory game = games[i];
322 				if(game.win_numbers[0] == 0) { continue; }
323 				
324 				for(uint j = 1; j <= game.membersCounter; j++) {
325 				    
326 				    Member memory member = games[i].members[j];
327 					
328 					if(member.payout == 1) { continue; }
329 					
330 					uint8 mn = findMatch(game.win_numbers, member.numbers);
331 					
332 					if(mn == 2) {
333 						games[i].members[j].prize = game.p2;
334 						payoutAmount += game.p2;
335 					}
336 					
337 					if(mn == 3) {
338 						games[i].members[j].prize = game.p3;
339 						payoutAmount += game.p3;
340 					}
341 					
342 					if(mn == 4) {
343 						games[i].members[j].prize = game.p4;
344 						payoutAmount += game.p4;
345 					}
346 					
347 					if(mn == 5) {
348 						games[i].members[j].prize = game.p5;
349 						payoutAmount += game.p5;
350 					}
351 					
352 					games[i].members[j].payout = 1;
353 					
354 					emit PayOut(i, j, games[i].members[j].prize, 1);
355 					
356 				}
357 				
358 			}
359 			
360 			if(payoutAmount != 0) msg.sender.transfer(payoutAmount);
361 			
362 			return;
363 		}
364 		
365 		// Buy ticket
366 		uint8 weekday = getWeekday(now);
367 		uint8 hour = getHour(now);
368 		
369 		if( GAME_NUM > 0 && games[GAME_NUM].status == 1 && POOL_COUNTER == 0 && 
370 		  (weekday != DRAW_DOW || (weekday == DRAW_DOW && (hour < (DRAW_HOUR - 1) || hour > (DRAW_HOUR + 2)))) ) {
371 
372 		    if(msg.value == TICKET_PRICE) {
373 			    createTicket();
374 		    } else {
375 			    if(msg.value < TICKET_PRICE) {
376 				    FUND_PR = FUND_PR + msg.value.mul(PERCENT_FUND_PR).div(100);
377 				    games[GAME_NUM].totalFund = games[GAME_NUM].totalFund + msg.value.mul(100 - PERCENT_FUND_PR).div(100);
378 				    emit UpdateFund(games[GAME_NUM].totalFund);
379 			    } else {
380 				    msg.sender.transfer(msg.value.sub(TICKET_PRICE));
381 				    createTicket();
382 			    }
383 		    }
384 		
385 		} else {
386 		     msg.sender.transfer(msg.value);
387 		}
388 		
389 	}
390 	
391 	function createTicket() private {
392 		
393 		bool err = false;
394 		uint8[5] memory numbers;
395 		
396 		// Calculate funds
397 		FUND_PR = FUND_PR + TICKET_PRICE.mul(PERCENT_FUND_PR).div(100);
398 		games[GAME_NUM].totalFund = games[GAME_NUM].totalFund + TICKET_PRICE.mul(100 - PERCENT_FUND_PR).div(100);
399 		emit UpdateFund(games[GAME_NUM].totalFund);
400 		
401 		// Parse and check msg.DATA
402 		(err, numbers) = ParseCheckData();
403 		
404 		uint mbrCnt;
405 		
406 		// If error DATA, generate random ticket numbers
407 		if(err) {
408 		    
409 		    // Generate numbers
410 	        for(uint8 i = 0; i < 5; i++) {
411 	            numbers[i] = random(i);
412 	        }
413 
414 	        // Change dublicate numbers
415 	        for(uint8 i = 0; i < 4; i++) {
416 	            for(uint8 j = i + 1; j < 5; j++) {
417 	                if(numbers[i] == numbers[j]) {
418 	                    numbers[j]++;
419 	                }
420 	            }
421 	        }
422 	        
423 		}
424 		
425 		// Sort ticket numbers array
426 	    numbers = sortNumbers(numbers);
427 
428 	    // Increase member counter
429 	    games[GAME_NUM].membersCounter++;
430 	    mbrCnt = games[GAME_NUM].membersCounter;
431 
432 	    // Save member
433 	    games[GAME_NUM].members[mbrCnt].addr = msg.sender;
434 	    games[GAME_NUM].members[mbrCnt].ticket = mbrCnt;
435 	    games[GAME_NUM].members[mbrCnt].numbers = numbers;
436 		    
437 	    emit NewMember(GAME_NUM, mbrCnt, msg.sender, numbers[0], numbers[1], numbers[2], numbers[3], numbers[4]);
438 
439 	}
440 	
441 	
442 	// Parse and check msg.DATA function
443 	function ParseCheckData() private view returns (bool, uint8[5] memory) {
444 	    
445 	    bool err = false;
446 	    uint8[5] memory numbers;
447 	    
448 	    // Check 5 numbers entered
449 	    if(msg.data.length == 5) {
450 	        
451 	        // Parse DATA string
452 		    for(uint8 i = 0; i < msg.data.length; i++) {
453 		        numbers[i] = uint8(msg.data[i]);
454 		    }
455 		    
456 		    // Check range: 1 - MAX_NUMBER
457 		    for(uint8 i = 0; i < numbers.length; i++) {
458 		        if(numbers[i] < 1 || numbers[i] > MAX_NUMBER) {
459 		            err = true;
460 		            break;
461 		        }
462 		    }
463 		    
464 		    // Check dublicate numbers
465 		    if(!err) {
466 		    
467 		        for(uint8 i = 0; i < numbers.length - 1; i++) {
468 		            for(uint8 j = i + 1; j < numbers.length; j++) {
469 		                if(numbers[i] == numbers[j]) {
470 		                    err = true;
471 		                    break;
472 		                }
473 		            }
474 		            if(err) {
475 		                break;
476 		            }
477 		        }
478 		        
479 		    }
480 		    
481 	    } else {
482 	        err = true;
483 	    }
484 
485 	    return (err, numbers);
486 
487 	}
488 	
489 	// Sort array of number function
490 	function sortNumbers(uint8[5] memory arrNumbers) private pure returns (uint8[5] memory) {
491 	    
492 	    uint8 temp;
493 	    
494 	    for(uint8 i = 0; i < arrNumbers.length - 1; i++) {
495             for(uint j = 0; j < arrNumbers.length - i - 1; j++)
496                 if (arrNumbers[j] > arrNumbers[j + 1]) {
497                     temp = arrNumbers[j];
498                     arrNumbers[j] = arrNumbers[j + 1];
499                     arrNumbers[j + 1] = temp;
500                 }    
501 	    }
502         
503         return arrNumbers;
504         
505 	}
506 	
507 	// Contract address balance
508     function getBalance() public view returns(uint) {
509         uint balance = address(this).balance;
510 		return balance;
511 	}
512 	
513 	// Generate random number
514 	function random(uint8 num) internal view returns (uint8) {
515         return uint8((uint(blockhash(block.number - 1 - num*2)) + now) % MAX_NUMBER + 1);
516     }
517 	
518 	function getHour(uint timestamp) private pure returns (uint8) {
519         return uint8((timestamp / 60 / 60) % 24);
520     }
521     
522     function getWeekday(uint timestamp) private pure returns (uint8) {
523         return uint8((timestamp / DAY_IN_SECONDS + 4) % 7);
524     }
525     
526 	
527 	//  API  //
528 	
529 	// i - Game number
530 	function getGameInfo(uint i) public view returns (uint, uint, uint8, uint8, uint8, uint8, uint8, uint8, uint, uint, uint, uint) {
531 	    Game memory game = games[i];
532 	    return (game.totalFund, game.membersCounter, game.win_numbers[0], game.win_numbers[1], game.win_numbers[2], game.win_numbers[3], game.win_numbers[4], game.status, game.p2, game.p3, game.p4, game.p5);
533 	}
534 	
535 	// i - Game number, j - Ticket number
536 	function getMemberInfo(uint i, uint j) public view returns (address, uint, uint8, uint8, uint8, uint8, uint8, uint, uint8) {
537 	    Member memory mbr = games[i].members[j];
538 	    return (mbr.addr, mbr.ticket, mbr.numbers[0], mbr.numbers[1], mbr.numbers[2], mbr.numbers[3], mbr.numbers[4], mbr.prize, mbr.payout);
539 	}
540 
541 }
542 
543 /**
544  * @title SafeMath
545  * @dev Math operations with safety checks that throw on error
546  */
547 library SafeMath {
548 
549     function mul(uint256 a, uint256 b) internal pure returns(uint256) {
550         uint256 c = a * b;
551         assert(a == 0 || c / a == b);
552         return c;
553     }
554 
555     function div(uint256 a, uint256 b) internal pure returns(uint256) {
556         // assert(b > 0); // Solidity automatically throws when dividing by 0
557         uint256 c = a / b;
558         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
559         return c;
560     }
561 
562     function sub(uint256 a, uint256 b) internal pure returns(uint256) {
563         assert(b <= a);
564         return a - b;
565     }
566 
567     function add(uint256 a, uint256 b) internal pure returns(uint256) {
568         uint256 c = a + b;
569         assert(c >= a);
570         return c;
571     }
572 
573 }