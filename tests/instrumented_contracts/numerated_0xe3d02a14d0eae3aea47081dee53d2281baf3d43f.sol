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
12 	// Member struct
13 	struct Member {
14 		address addr;								// Address
15 		uint ticket;								// Ticket number
16 		uint8[5] numbers;                           // Selected numbers
17 		uint prize;                                 // Winning prize
18 		uint8 payout;								// Payout prize
19 	}
20 	
21 	// Game struct
22 	struct Game {
23 		uint datetime;								// Game timestamp
24 		uint8[5] win_numbers;						// Winning numbers
25 		uint membersCounter;						// Members count
26 		uint totalFund;                             // Total prize fund
27 		uint p2;									// Prize for 2 guessed numbers
28 		uint p3;									// Prize for 3 guessed numbers
29 		uint p4;									// Prize for 4 guessed numbers
30 		uint p5;									// Prize for 5 guessed numbers
31 		uint8 status;                               // Game status: 0 - created, 1 - active
32 		mapping(uint => Member) members;		    // Members list
33 	}
34 	
35 	mapping(uint => Game) public games;
36 	
37 	uint private CONTRACT_STARTED_DATE = 0;
38 	uint private constant TICKET_PRICE = 0.01 ether;
39 	uint private constant MAX_NUMBER = 36;						            // Максимально возможное число -> 36
40 	
41 	uint private constant PERCENT_FUND_JACKPOT = 15;                        // (%) Increase Jackpot
42 	uint private constant PERCENT_FUND_4 = 35;                              // (%) Fund 4 of 5
43 	uint private constant PERCENT_FUND_3 = 30;                              // (%) Fund 3 of 5
44     uint private constant PERCENT_FUND_2 = 20;                              // (%) Fund 2 of 5
45     
46 	uint public JACKPOT = 0;
47 	
48 	// Init params
49 	uint public GAME_NUM = 0;
50 	uint private constant return_jackpot_period = 25 weeks;
51 	uint private start_jackpot_amount = 0;
52 	
53 	uint private constant PERCENT_FUND_PR = 15;                             // (%) PR & ADV
54 	uint private FUND_PR = 0;                                               // Fund PR & ADV
55 
56 	// Addresses
57 	address private constant ADDRESS_SERVICE = 0x203bF6B46508eD917c085F50F194F36b0a62EB02;
58 	address payable private constant ADDRESS_START_JACKPOT = 0x531d3Bd0400Ae601f26B335EfbD787415Aa5CB81;
59 	address payable private constant ADDRESS_PR = 0xCD66911b6f38FaAF5BFeE427b3Ceb7D18Dd09F78;
60 	
61 	// Events
62 	event NewMember(uint _gamenum, uint _ticket, address _addr, uint8 _n1, uint8 _n2, uint8 _n3, uint8 _n4, uint8 _n5);
63 	event NewGame(uint _gamenum);
64 	event UpdateFund(uint _fund);
65 	event UpdateJackpot(uint _jackpot);
66 	event WinNumbers(uint _gamenum, uint8 _n1, uint8 _n2, uint8 _n3, uint8 _n4, uint8 _n5);
67 	event PayOut(uint _gamenum, uint _ticket, uint _prize, uint8 _payout);
68 	
69 	// For many processing transactions
70 	uint private constant POOL_SIZE = 30;										// MAX processing tickets by transaction
71 	uint private POOL_COUNTER = 0;
72 	
73 	uint private w2 = 0;
74 	uint private w3 = 0;
75 	uint private w4 = 0;
76 	uint private w5 = 0;
77 	
78 	// Entry point
79 	function() external payable {
80 	    
81         // Select action
82 		if(msg.sender == ADDRESS_START_JACKPOT) {
83 			processStartingJackpot();
84 		} else {
85 			if(msg.sender == ADDRESS_SERVICE) {
86 				startGame();
87 			} else {
88 				processUserTicket();
89 			}
90 		}
91 		
92     }
93 	
94 
95 	///////////////////////////////////////////////////////////////////////////////////////////////////////
96 	// Starting Jackpot action
97 	///////////////////////////////////////////////////////////////////////////////////////////////////////
98 	function processStartingJackpot() private {
99 		// If value > 0, increase starting Jackpot
100 		if(msg.value > 0) {
101 			JACKPOT += msg.value;
102 			start_jackpot_amount += msg.value;
103 			emit UpdateJackpot(JACKPOT);
104 		// Else, return starting Jackpot
105 		} else {
106 			if(start_jackpot_amount > 0){
107 				_returnStartJackpot();
108 			}
109 		}
110 		
111 	}
112 	
113 	// Return starting Jackpot after 6 months
114 	function _returnStartJackpot() private { 
115 		
116 		if(JACKPOT > start_jackpot_amount * 2 || (now - CONTRACT_STARTED_DATE) > return_jackpot_period) {
117 			
118 			if(JACKPOT > start_jackpot_amount) {
119 				ADDRESS_START_JACKPOT.transfer(start_jackpot_amount);
120 				JACKPOT = JACKPOT - start_jackpot_amount;
121 				start_jackpot_amount = 0;
122 			} else {
123 				ADDRESS_START_JACKPOT.transfer(JACKPOT);
124 				start_jackpot_amount = 0;
125 				JACKPOT = 0;
126 			}
127 			emit UpdateJackpot(JACKPOT);
128 			
129 		} 
130 		
131 	}
132 	
133 	
134 	///////////////////////////////////////////////////////////////////////////////////////////////////////
135 	// Running a Game
136 	///////////////////////////////////////////////////////////////////////////////////////////////////////
137 	function startGame() private {
138 	    
139 		if(GAME_NUM == 0) {
140 		    GAME_NUM = 1;
141 		    games[GAME_NUM].datetime = now;
142 		    games[GAME_NUM].status = 1;
143 		    CONTRACT_STARTED_DATE = now;
144 		} else {
145 		    
146 	        if(games[GAME_NUM].status == 1) {
147 	            processGame();
148 		    } else {
149 		        games[GAME_NUM].status = 1;
150 		    }
151 		    
152 		}
153         
154 	}
155 	
156 	function processGame() private {
157 	    
158 		uint8[5] memory win_numbers;
159 		uint8 mn = 0;
160 		
161 	    // 1-st time generate winning numbers
162 		if(POOL_COUNTER == 0) {
163 			
164 			w2 = 0;
165 			w3 = 0;
166 			w4 = 0;
167 			w5 = 0;
168 		
169 			// Generate winning numbers
170 			for(uint8 i = 0; i < 5; i++) {
171 				win_numbers[i] = random(i);
172 			}
173 
174 			// Sort winning numbers array
175 			win_numbers = sortNumbers(win_numbers);
176 	    
177 			// Change dublicate numbers
178 			for(uint8 i = 0; i < 4; i++) {
179 				for(uint8 j = i + 1; j < 5; j++) {
180 					if(win_numbers[i] == win_numbers[j]) {
181 						win_numbers[j]++;
182 					}
183 				}
184 			}
185 	    
186 			games[GAME_NUM].win_numbers = win_numbers;
187 			emit WinNumbers(GAME_NUM, win_numbers[0], win_numbers[1], win_numbers[2], win_numbers[3], win_numbers[4]);
188 		
189 		} else {
190 		    
191 		    win_numbers = games[GAME_NUM].win_numbers;
192 		    
193 		}
194 		
195 
196 		// Process tickets list
197 		uint start 	= POOL_SIZE * POOL_COUNTER + 1;
198 		uint end 	= POOL_SIZE * POOL_COUNTER + POOL_SIZE;
199 		
200 		if(end > games[GAME_NUM].membersCounter) end = games[GAME_NUM].membersCounter;
201 		
202 		uint _w2 = 0;
203 		uint _w3 = 0;
204 		uint _w4 = 0;
205 		uint _w5 = 0;
206 		
207 	    for(uint i = start; i <= end; i++) {
208 	       
209 	        mn = findMatch(win_numbers, games[GAME_NUM].members[i].numbers);
210 				
211 			if(mn == 2) { _w2++; continue; }
212 			if(mn == 3) { _w3++; continue; }
213 			if(mn == 4) { _w4++; continue; }
214 			if(mn == 5) { _w5++; }
215 				
216 	    }
217 		
218 		if(_w2 != 0) { w2 += _w2; }
219 		if(_w3 != 0) { w3 += _w3; }
220 		if(_w4 != 0) { w4 += _w4; }
221 		if(_w5 != 0) { w2 += _w5; }
222 		
223 		if(end == games[GAME_NUM].membersCounter) {
224 		
225 			// Fund calculate
226 			uint totalFund = games[GAME_NUM].totalFund;
227 			
228 			uint fund2 = totalFund * PERCENT_FUND_2 / 100;
229 			uint fund3 = totalFund * PERCENT_FUND_3 / 100;
230 			uint fund4 = totalFund * PERCENT_FUND_4 / 100;
231 			uint _jackpot = JACKPOT + totalFund * PERCENT_FUND_JACKPOT / 100;
232 
233 			// If exist tickets 2/5
234 			if(w2 != 0) { 
235 				games[GAME_NUM].p2 = fund2 / w2; 
236 			} else { 
237 				_jackpot += fund2; 
238 			}
239 			
240 			// If exist tickets 3/5
241 			if(w3 != 0) { 
242 				games[GAME_NUM].p3 = fund3 / w3; 
243 			} else {
244 				_jackpot += fund3;
245 			}
246 			
247 			// If exist tickets 4/5
248 			if(w4 != 0) { 
249 				games[GAME_NUM].p4 = fund4 / w4; 
250 			} else {
251 				_jackpot += fund4;
252 			}
253 			
254 			// If exist tickets 5/5
255 			if(w5 != 0) { 
256 				games[GAME_NUM].p5 = _jackpot / w5; 
257 				JACKPOT = 0;
258 				start_jackpot_amount = 0;
259 			} else {
260 				JACKPOT = _jackpot;
261 			}
262 
263 			emit UpdateJackpot(JACKPOT);
264 	    
265 			// Init next Game /////////////////////////////////////////////////
266 			GAME_NUM++;
267 			games[GAME_NUM].datetime = now;
268 			emit NewGame(GAME_NUM);
269 			
270 			POOL_COUNTER = 0;
271 
272 			// Transfer PR 
273 			ADDRESS_PR.transfer(FUND_PR);
274 			FUND_PR = 0;
275 	    
276 		} else {
277 			
278 			POOL_COUNTER++;
279 
280 		}
281 		
282 	}
283 	
284 	// Find match numbers function
285 	function findMatch(uint8[5] memory arr1, uint8[5] memory arr2) private pure returns (uint8) {
286 	    
287 	    uint8 cnt = 0;
288 	    
289 	    for(uint8 i = 0; i < 5; i++) {
290 	        for(uint8 j = 0; j < 5; j++) {
291 	            if(arr1[i] == arr2[j]) {
292 	                cnt++;
293 	                break;
294 	            }
295 	        }
296 	    }
297 	    
298 	    return cnt;
299 
300 	}
301 	
302 	///////////////////////////////////////////////////////////////////////////////////////////////////////
303 	// Buy ticket process (if msg.value != 0.0 ETH) or payout winnings (if msg.value == 0.0 ETH)
304 	///////////////////////////////////////////////////////////////////////////////////////////////////////
305 	function processUserTicket() private {
306 		
307 		// Payout
308 		if(msg.value == 0) {
309 			
310 			uint payoutAmount = 0;
311 			for(uint i = 1; i <= GAME_NUM; i++) {
312 				
313 				Game memory game = games[i];
314 				if(game.win_numbers[0] == 0) { continue; }
315 				
316 				for(uint j = 1; j <= game.membersCounter; j++) {
317 				    
318 				    Member memory member = games[i].members[j];
319 					
320 					if(member.payout == 1) { continue; }
321 					
322 					uint8 mn = findMatch(game.win_numbers, member.numbers);
323 					
324 					if(mn == 2) {
325 						games[i].members[j].prize = game.p2;
326 						payoutAmount += game.p2;
327 					}
328 					
329 					if(mn == 3) {
330 						games[i].members[j].prize = game.p3;
331 						payoutAmount += game.p3;
332 					}
333 					
334 					if(mn == 4) {
335 						games[i].members[j].prize = game.p4;
336 						payoutAmount += game.p4;
337 					}
338 					
339 					if(mn == 5) {
340 						games[i].members[j].prize = game.p5;
341 						payoutAmount += game.p5;
342 					}
343 					
344 					games[i].members[j].payout = 1;
345 					
346 					emit PayOut(i, j, games[i].members[j].prize, 1);
347 					
348 				}
349 				
350 			}
351 			
352 			if(payoutAmount != 0) msg.sender.transfer(payoutAmount);
353 			
354 			return;
355 		}
356 		
357 		// Buy ticket
358 		if( GAME_NUM > 0 && games[GAME_NUM].status == 1 && POOL_COUNTER == 0 ) {
359 
360 		    if(msg.value == TICKET_PRICE) {
361 			    createTicket();
362 		    } else {
363 			    if(msg.value < TICKET_PRICE) {
364 				    FUND_PR = FUND_PR + msg.value.mul(PERCENT_FUND_PR).div(100);
365 				    games[GAME_NUM].totalFund = games[GAME_NUM].totalFund + msg.value.mul(100 - PERCENT_FUND_PR).div(100);
366 				    emit UpdateFund(games[GAME_NUM].totalFund);
367 			    } else {
368 				    msg.sender.transfer(msg.value.sub(TICKET_PRICE));
369 				    createTicket();
370 			    }
371 		    }
372 		
373 		} else {
374 		     msg.sender.transfer(msg.value);
375 		}
376 		
377 	}
378 	
379 	function createTicket() private {
380 		
381 		bool err = false;
382 		uint8[5] memory numbers;
383 		
384 		// Calculate funds
385 		FUND_PR = FUND_PR + TICKET_PRICE.mul(PERCENT_FUND_PR).div(100);
386 		games[GAME_NUM].totalFund = games[GAME_NUM].totalFund + TICKET_PRICE.mul(100 - PERCENT_FUND_PR).div(100);
387 		emit UpdateFund(games[GAME_NUM].totalFund);
388 		
389 		// Parse and check msg.DATA
390 		(err, numbers) = ParseCheckData();
391 		
392 		uint mbrCnt;
393 		
394 		// If error DATA, generate random ticket numbers
395 		if(err) {
396 		    
397 		    // Generate numbers
398 	        for(uint8 i = 0; i < 5; i++) {
399 	            numbers[i] = random(i);
400 	        }
401 
402 	        // Change dublicate numbers
403 	        for(uint8 i = 0; i < 4; i++) {
404 	            for(uint8 j = i + 1; j < 5; j++) {
405 	                if(numbers[i] == numbers[j]) {
406 	                    numbers[j]++;
407 	                }
408 	            }
409 	        }
410 	        
411 		}
412 		
413 		// Sort ticket numbers array
414 	    numbers = sortNumbers(numbers);
415 
416 	    // Increase member counter
417 	    games[GAME_NUM].membersCounter++;
418 	    mbrCnt = games[GAME_NUM].membersCounter;
419 
420 	    // Save member
421 	    games[GAME_NUM].members[mbrCnt].addr = msg.sender;
422 	    games[GAME_NUM].members[mbrCnt].ticket = mbrCnt;
423 	    games[GAME_NUM].members[mbrCnt].numbers = numbers;
424 		    
425 	    emit NewMember(GAME_NUM, mbrCnt, msg.sender, numbers[0], numbers[1], numbers[2], numbers[3], numbers[4]);
426 
427 	}
428 	
429 	
430 	// Parse and check msg.DATA function
431 	function ParseCheckData() private view returns (bool, uint8[5] memory) {
432 	    
433 	    bool err = false;
434 	    uint8[5] memory numbers;
435 	    
436 	    // Check 5 numbers entered
437 	    if(msg.data.length == 5) {
438 	        
439 	        // Parse DATA string
440 		    for(uint8 i = 0; i < msg.data.length; i++) {
441 		        numbers[i] = uint8(msg.data[i]);
442 		    }
443 		    
444 		    // Check range: 1 - MAX_NUMBER
445 		    for(uint8 i = 0; i < numbers.length; i++) {
446 		        if(numbers[i] < 1 || numbers[i] > MAX_NUMBER) {
447 		            err = true;
448 		            break;
449 		        }
450 		    }
451 		    
452 		    // Check dublicate numbers
453 		    if(!err) {
454 		    
455 		        for(uint8 i = 0; i < numbers.length - 1; i++) {
456 		            for(uint8 j = i + 1; j < numbers.length; j++) {
457 		                if(numbers[i] == numbers[j]) {
458 		                    err = true;
459 		                    break;
460 		                }
461 		            }
462 		            if(err) {
463 		                break;
464 		            }
465 		        }
466 		        
467 		    }
468 		    
469 	    } else {
470 	        err = true;
471 	    }
472 
473 	    return (err, numbers);
474 
475 	}
476 	
477 	// Sort array of number function
478 	function sortNumbers(uint8[5] memory arrNumbers) private pure returns (uint8[5] memory) {
479 	    
480 	    uint8 temp;
481 	    
482 	    for(uint8 i = 0; i < arrNumbers.length - 1; i++) {
483             for(uint j = 0; j < arrNumbers.length - i - 1; j++)
484                 if (arrNumbers[j] > arrNumbers[j + 1]) {
485                     temp = arrNumbers[j];
486                     arrNumbers[j] = arrNumbers[j + 1];
487                     arrNumbers[j + 1] = temp;
488                 }    
489 	    }
490         
491         return arrNumbers;
492         
493 	}
494 	
495 	// Contract address balance
496     function getBalance() public view returns(uint) {
497         uint balance = address(this).balance;
498 		return balance;
499 	}
500 	
501 	// Generate random number
502 	function random(uint8 num) internal view returns (uint8) {
503         return uint8((uint(blockhash(block.number - 1 - num*2)) + now) % MAX_NUMBER + 1);
504     } 
505     
506 	
507 	//  API  //
508 	
509 	// i - Game number
510 	function getGameInfo(uint i) public view returns (uint, uint, uint8, uint8, uint8, uint8, uint8, uint8, uint, uint, uint, uint) {
511 	    Game memory game = games[i];
512 	    return (game.totalFund, game.membersCounter, game.win_numbers[0], game.win_numbers[1], game.win_numbers[2], game.win_numbers[3], game.win_numbers[4], game.status, game.p2, game.p3, game.p4, game.p5);
513 	}
514 	
515 	// i - Game number, j - Ticket number
516 	function getMemberInfo(uint i, uint j) public view returns (address, uint, uint8, uint8, uint8, uint8, uint8, uint, uint8) {
517 	    Member memory mbr = games[i].members[j];
518 	    return (mbr.addr, mbr.ticket, mbr.numbers[0], mbr.numbers[1], mbr.numbers[2], mbr.numbers[3], mbr.numbers[4], mbr.prize, mbr.payout);
519 	}
520 
521 }
522 
523 /**
524  * @title SafeMath
525  * @dev Math operations with safety checks that throw on error
526  */
527 library SafeMath {
528 
529     function mul(uint256 a, uint256 b) internal pure returns(uint256) {
530         uint256 c = a * b;
531         assert(a == 0 || c / a == b);
532         return c;
533     }
534 
535     function div(uint256 a, uint256 b) internal pure returns(uint256) {
536         // assert(b > 0); // Solidity automatically throws when dividing by 0
537         uint256 c = a / b;
538         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
539         return c;
540     }
541 
542     function sub(uint256 a, uint256 b) internal pure returns(uint256) {
543         assert(b <= a);
544         return a - b;
545     }
546 
547     function add(uint256 a, uint256 b) internal pure returns(uint256) {
548         uint256 c = a + b;
549         assert(c >= a);
550         return c;
551     }
552 
553 }