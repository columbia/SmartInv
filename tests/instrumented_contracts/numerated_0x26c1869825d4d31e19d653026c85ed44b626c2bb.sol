1 pragma solidity ^0.5.1;
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
12     // Drawing time
13     uint8 private constant DRAW_DOW = 4;            // Day of week
14     uint8 private constant DRAW_HOUR = 11;          // Hour
15     
16     uint private constant DAY_IN_SECONDS = 86400;
17 	
18 	// Member struct
19 	struct Member {
20 		address payable addr;						// Address
21 		uint ticket;								// Ticket number
22 		uint8[5] numbers;                           // Selected numbers
23 		uint8 matchNumbers;                         // Match numbers
24 		uint prize;                                 // Winning prize
25 	}
26 	
27 	
28 	// Game struct
29 	struct Game {
30 		uint datetime;								// Game timestamp
31 		uint8[5] win_numbers;						// Winning numbers
32 		uint membersCounter;						// Members count
33 		uint totalFund;                             // Total prize fund
34 		uint8 status;                               // Game status: 0 - created, 1 - pleyed
35 		mapping(uint => Member) members;		    // Members list
36 	}
37 	
38 	mapping(uint => Game) public games;
39 	
40 	uint private CONTRACT_STARTED_DATE = 0;
41 	uint private constant TICKET_PRICE = 0.01 ether;
42 	uint private constant MAX_NUMBER = 36;						            // Максимально возможное число -> 36
43 	
44 	uint private constant PERCENT_FUND_JACKPOT = 15;                        // (%) Increase Jackpot
45 	uint private constant PERCENT_FUND_4 = 35;                              // (%) Fund 4 of 5
46 	uint private constant PERCENT_FUND_3 = 30;                              // (%) Fund 3 of 5
47     uint private constant PERCENT_FUND_2 = 20;                              // (%) Fund 2 of 5
48     
49 	uint public JACKPOT = 0;
50 	
51 	// Init params
52 	uint public GAME_NUM = 0;
53 	uint private constant return_jackpot_period = 25 weeks;
54 	uint private start_jackpot_amount = 0;
55 	
56 	uint private constant PERCENT_FUND_PR = 12;                             // (%) PR & ADV
57 	uint private FUND_PR = 0;                                               // Fund PR & ADV
58 
59 	// Addresses
60 	address private constant ADDRESS_SERVICE = 0x203bF6B46508eD917c085F50F194F36b0a62EB02;
61 	address payable private constant ADDRESS_START_JACKPOT = 0x531d3Bd0400Ae601f26B335EfbD787415Aa5CB81;
62 	address payable private constant ADDRESS_PR = 0xCD66911b6f38FaAF5BFeE427b3Ceb7D18Dd09F78;
63 	
64 	// Events
65 	event NewMember(uint _gamenum, uint _ticket, address _addr, uint8 _n1, uint8 _n2, uint8 _n3, uint8 _n4, uint8 _n5);
66 	event NewGame(uint _gamenum);
67 	event UpdateFund(uint _fund);
68 	event UpdateJackpot(uint _jackpot);
69 	event WinNumbers(uint _gamenum, uint8 _n1, uint8 _n2, uint8 _n3, uint8 _n4, uint8 _n5);
70 	event WinPrize(uint _gamenum, uint _ticket, uint _prize, uint8 _match);
71 
72 	// Entry point
73 	function() external payable {
74 	    
75         // Select action
76 		if(msg.sender == ADDRESS_START_JACKPOT) {
77 			processStartingJackpot();
78 		} else {
79 			if(msg.sender == ADDRESS_SERVICE) {
80 				startGame();
81 			} else {
82 				processUserTicket();
83 			}
84 		}
85 		
86     }
87 	
88 	///////////////////////////////////////////////////////////////////////////////////////////////////////
89 	// Starting Jackpot action
90 	///////////////////////////////////////////////////////////////////////////////////////////////////////
91 	function processStartingJackpot() private {
92 		// If value > 0, increase starting Jackpot
93 		if(msg.value > 0) {
94 			JACKPOT += msg.value;
95 			start_jackpot_amount += msg.value;
96 			emit UpdateJackpot(JACKPOT);
97 		// Else, return starting Jackpot
98 		} else {
99 			if(start_jackpot_amount > 0){
100 				_returnStartJackpot();
101 			}
102 		}
103 		
104 	}
105 	
106 	// Return starting Jackpot after 6 months
107 	function _returnStartJackpot() private { 
108 		
109 		if(JACKPOT > start_jackpot_amount * 2 || (now - CONTRACT_STARTED_DATE) > return_jackpot_period) {
110 			
111 			if(JACKPOT > start_jackpot_amount) {
112 				ADDRESS_START_JACKPOT.transfer(start_jackpot_amount);
113 				JACKPOT = JACKPOT - start_jackpot_amount;
114 				start_jackpot_amount = 0;
115 			} else {
116 				ADDRESS_START_JACKPOT.transfer(JACKPOT);
117 				start_jackpot_amount = 0;
118 				JACKPOT = 0;
119 			}
120 			emit UpdateJackpot(JACKPOT);
121 			
122 		} 
123 		
124 	}
125 	
126 	
127 	///////////////////////////////////////////////////////////////////////////////////////////////////////
128 	// Running a Game
129 	///////////////////////////////////////////////////////////////////////////////////////////////////////
130 	function startGame() private {
131 	    
132 	    uint8 weekday = getWeekday(now);
133 		uint8 hour = getHour(now);
134 	    
135 		if(GAME_NUM == 0) {
136 		    GAME_NUM = 1;
137 		    games[GAME_NUM].datetime = now;
138 		    games[GAME_NUM].status = 1;
139 		    CONTRACT_STARTED_DATE = now;
140 		} else {
141 		    if(weekday == DRAW_DOW && hour == DRAW_HOUR) {
142 
143 		        if(games[GAME_NUM].status == 1) {
144 		            processGame();
145 		        }
146 
147 		    } else {
148 		        games[GAME_NUM].status = 1;
149 		    }
150 		    
151 		}
152         
153 	}
154 	
155 	function processGame() private {
156 	    
157 	    uint8 mn = 0;
158 		uint winners5 = 0;
159 		uint winners4 = 0;
160 		uint winners3 = 0;
161 		uint winners2 = 0;
162 
163 		uint fund4 = 0;
164 		uint fund3 = 0;
165 		uint fund2 = 0;
166 	    
167 	    // Generate winning numbers
168 	    for(uint8 i = 0; i < 5; i++) {
169 	        games[GAME_NUM].win_numbers[i] = random(i);
170 	    }
171 
172 	    // Sort winning numbers array
173 	    games[GAME_NUM].win_numbers = sortNumbers(games[GAME_NUM].win_numbers);
174 	    
175 	    // Change dublicate numbers
176 	    for(uint8 i = 0; i < 4; i++) {
177 	        for(uint8 j = i+1; j < 5; j++) {
178 	            if(games[GAME_NUM].win_numbers[i] == games[GAME_NUM].win_numbers[j]) {
179 	                games[GAME_NUM].win_numbers[j]++;
180 	            }
181 	        }
182 	    }
183 	    
184 	    uint8[5] memory win_numbers;
185 	    win_numbers = games[GAME_NUM].win_numbers;
186 	    emit WinNumbers(GAME_NUM, win_numbers[0], win_numbers[1], win_numbers[2], win_numbers[3], win_numbers[4]);
187 	    
188 	    if(games[GAME_NUM].membersCounter > 0) {
189 	    
190 	        // Pocess tickets list
191 	        for(uint i = 1; i <= games[GAME_NUM].membersCounter; i++) {
192 	            
193 	            mn = findMatch(games[GAME_NUM].win_numbers, games[GAME_NUM].members[i].numbers);
194 				games[GAME_NUM].members[i].matchNumbers = mn;
195 				
196 				if(mn == 5) {
197 					winners5++;
198 				}
199 				if(mn == 4) {
200 					winners4++;
201 				}
202 				if(mn == 3) {
203 					winners3++;
204 				}
205 				if(mn == 2) {
206 					winners2++;
207 				}
208 				
209 	        }
210 	        
211 	        // Fund calculate
212 	        JACKPOT = JACKPOT + games[GAME_NUM].totalFund * PERCENT_FUND_JACKPOT / 100;
213 			fund4 = games[GAME_NUM].totalFund * PERCENT_FUND_4 / 100;
214 			fund3 = games[GAME_NUM].totalFund * PERCENT_FUND_3 / 100;
215 			fund2 = games[GAME_NUM].totalFund * PERCENT_FUND_2 / 100;
216 			
217 			if(winners4 == 0) {
218 			    JACKPOT = JACKPOT + fund4;
219 			}
220 			if(winners3 == 0) {
221 			    JACKPOT = JACKPOT + fund3;
222 			}
223 			if(winners2 == 0) {
224 			    JACKPOT = JACKPOT + fund2;
225 			}
226             
227 			for(uint i = 1; i <= games[GAME_NUM].membersCounter; i++) {
228 			    
229 			    if(games[GAME_NUM].members[i].matchNumbers == 5) {
230 			        games[GAME_NUM].members[i].prize = JACKPOT / winners5;
231 			        games[GAME_NUM].members[i].addr.transfer(games[GAME_NUM].members[i].prize);
232 			        emit WinPrize(GAME_NUM, games[GAME_NUM].members[i].ticket, games[GAME_NUM].members[i].prize, 5);
233 			    }
234 			    
235 			    if(games[GAME_NUM].members[i].matchNumbers == 4) {
236 			        games[GAME_NUM].members[i].prize = fund4 / winners4;
237 			        games[GAME_NUM].members[i].addr.transfer(games[GAME_NUM].members[i].prize);
238 			        emit WinPrize(GAME_NUM, games[GAME_NUM].members[i].ticket, games[GAME_NUM].members[i].prize, 4);
239 			    }
240 			    
241 			    if(games[GAME_NUM].members[i].matchNumbers == 3) {
242 			        games[GAME_NUM].members[i].prize = fund3 / winners3;
243 			        games[GAME_NUM].members[i].addr.transfer(games[GAME_NUM].members[i].prize);
244 			        emit WinPrize(GAME_NUM, games[GAME_NUM].members[i].ticket, games[GAME_NUM].members[i].prize, 3);
245 			    }
246 			    
247 			    if(games[GAME_NUM].members[i].matchNumbers == 2) {
248 			        games[GAME_NUM].members[i].prize = fund2 / winners2;
249 			        games[GAME_NUM].members[i].addr.transfer(games[GAME_NUM].members[i].prize);
250 			        emit WinPrize(GAME_NUM, games[GAME_NUM].members[i].ticket, games[GAME_NUM].members[i].prize, 2);
251 			    }
252 			    
253 			    if(games[GAME_NUM].members[i].matchNumbers == 1) {
254 			        emit WinPrize(GAME_NUM, games[GAME_NUM].members[i].ticket, games[GAME_NUM].members[i].prize, 1);
255 			    }
256 			    
257 			}
258 			
259 			// If exist Jackpot winners, init JACPOT
260 			if(winners5 != 0) {
261 			    JACKPOT = 0;
262 			    start_jackpot_amount = 0;
263 			}
264 			
265 	    }
266 	    
267 	    emit UpdateJackpot(JACKPOT);
268 	    
269 	    // Init next Game
270 	    GAME_NUM++;
271 	    games[GAME_NUM].datetime = now;
272 	    games[GAME_NUM].status = 0;
273 	    emit NewGame(GAME_NUM);
274 	    
275 	    // Transfer
276 	    ADDRESS_PR.transfer(FUND_PR);
277 	    FUND_PR = 0;
278 	    
279 	}
280 	
281 	// Find match numbers function
282 	function findMatch(uint8[5] memory arr1, uint8[5] memory arr2) private pure returns (uint8) {
283 	    
284 	    uint8 cnt = 0;
285 	    
286 	    for(uint8 i = 0; i < 5; i++) {
287 	        for(uint8 j = 0; j < 5; j++) {
288 	            if(arr1[i] == arr2[j]) {
289 	                cnt++;
290 	                break;
291 	            }
292 	        }
293 	    }
294 	    
295 	    return cnt;
296 
297 	}
298 	
299 	///////////////////////////////////////////////////////////////////////////////////////////////////////
300 	// Buy ticket process
301 	///////////////////////////////////////////////////////////////////////////////////////////////////////
302 	function processUserTicket() private {
303 		
304 		uint8 weekday = getWeekday(now);
305 		uint8 hour = getHour(now);
306 		
307 		if( GAME_NUM > 0 && games[GAME_NUM].status == 1 && 
308 		    (weekday != DRAW_DOW || (weekday == DRAW_DOW && (hour < (DRAW_HOUR - 1) || hour > (DRAW_HOUR + 2)))) ) {
309 
310 		    if(msg.value == TICKET_PRICE) {
311 			    createTicket();
312 		    } else {
313 			    if(msg.value < TICKET_PRICE) {
314 				    FUND_PR = FUND_PR + msg.value.mul(PERCENT_FUND_PR).div(100);
315 				    games[GAME_NUM].totalFund = games[GAME_NUM].totalFund + msg.value.mul(100 - PERCENT_FUND_PR).div(100);
316 				    emit UpdateFund(games[GAME_NUM].totalFund);
317 			    } else {
318 				    msg.sender.transfer(msg.value.sub(TICKET_PRICE));
319 				    createTicket();
320 			    }
321 		    }
322 		
323 		} else {
324 		     msg.sender.transfer(msg.value);
325 		}
326 		
327 	}
328 	
329 	function createTicket() private {
330 		
331 		bool err = false;
332 		uint8[5] memory numbers;
333 		
334 		// Calculate funds
335 		FUND_PR = FUND_PR + TICKET_PRICE.mul(PERCENT_FUND_PR).div(100);
336 		games[GAME_NUM].totalFund = games[GAME_NUM].totalFund + TICKET_PRICE.mul(100 - PERCENT_FUND_PR).div(100);
337 		emit UpdateFund(games[GAME_NUM].totalFund);
338 		
339 		// Parse and check msg.DATA
340 		(err, numbers) = ParseCheckData();
341 		
342 		uint mbrCnt;
343 		
344 		// If error DATA, generate random ticket numbers
345 		if(err) {
346 		    
347 		    // Generate numbers
348 	        for(uint8 i = 0; i < 5; i++) {
349 	            numbers[i] = random(i);
350 	        }
351 
352 	        // Sort ticket numbers array
353 	        numbers = sortNumbers(numbers);
354 	    
355 	        // Change dublicate numbers
356 	        for(uint8 i = 0; i < 4; i++) {
357 	            for(uint8 j = i+1; j < 5; j++) {
358 	                if(numbers[i] == numbers[j]) {
359 	                    numbers[j]++;
360 	                }
361 	            }
362 	        }
363 	        
364 		}
365 
366 	    // Increase member counter
367 	    games[GAME_NUM].membersCounter++;
368 	    mbrCnt = games[GAME_NUM].membersCounter;
369 
370 	    // Save member
371 	    games[GAME_NUM].members[mbrCnt].addr = msg.sender;
372 	    games[GAME_NUM].members[mbrCnt].ticket = mbrCnt;
373 	    games[GAME_NUM].members[mbrCnt].numbers = numbers;
374 	    games[GAME_NUM].members[mbrCnt].matchNumbers = 0;
375 		    
376 	    emit NewMember(GAME_NUM, mbrCnt, msg.sender, numbers[0], numbers[1], numbers[2], numbers[3], numbers[4]);
377 
378 	}
379 	
380 	
381 	// Parse and check msg.DATA function
382 	function ParseCheckData() private view returns (bool, uint8[5] memory) {
383 	    
384 	    bool err = false;
385 	    uint8[5] memory numbers;
386 	    
387 	    // Check 5 numbers entered
388 	    if(msg.data.length == 5) {
389 	        
390 	        // Parse DATA string
391 		    for(uint8 i = 0; i < msg.data.length; i++) {
392 		        numbers[i] = uint8(msg.data[i]);
393 		    }
394 		    
395 		    // Check range: 1 - MAX_NUMBER
396 		    for(uint8 i = 0; i < numbers.length; i++) {
397 		        if(numbers[i] < 1 || numbers[i] > MAX_NUMBER) {
398 		            err = true;
399 		            break;
400 		        }
401 		    }
402 		    
403 		    // Check dublicate numbers
404 		    if(!err) {
405 		    
406 		        for(uint8 i = 0; i < numbers.length-1; i++) {
407 		            for(uint8 j = i+1; j < numbers.length; j++) {
408 		                if(numbers[i] == numbers[j]) {
409 		                    err = true;
410 		                    break;
411 		                }
412 		            }
413 		            if(err) {
414 		                break;
415 		            }
416 		        }
417 		        
418 		    }
419 		    
420 	    } else {
421 	        err = true;
422 	    }
423 
424 	    return (err, numbers);
425 
426 	}
427 	
428 	// Sort array of number function
429 	function sortNumbers(uint8[5] memory arrNumbers) private pure returns (uint8[5] memory) {
430 	    
431 	    uint8 temp;
432 	    
433 	    for(uint8 i = 0; i < arrNumbers.length - 1; i++) {
434             for(uint j = 0; j < arrNumbers.length - i - 1; j++)
435                 if (arrNumbers[j] > arrNumbers[j + 1]) {
436                     temp = arrNumbers[j];
437                     arrNumbers[j] = arrNumbers[j + 1];
438                     arrNumbers[j + 1] = temp;
439                 }    
440 	    }
441         
442         return arrNumbers;
443         
444 	}
445 	
446 	// Contract address balance
447     function getBalance() public view returns(uint) {
448         uint balance = address(this).balance;
449 		return balance;
450 	}
451 	
452 	// Generate random number
453 	function random(uint8 num) internal view returns (uint8) {
454 	    
455         return uint8(uint(blockhash(block.number - 1 - num*2)) % MAX_NUMBER + 1);
456         
457     } 
458     
459     function getHour(uint timestamp) private pure returns (uint8) {
460         return uint8((timestamp / 60 / 60) % 24);
461     }
462     
463     function getWeekday(uint timestamp) private pure returns (uint8) {
464         return uint8((timestamp / DAY_IN_SECONDS + 4) % 7);
465     }
466 	
467 	
468 	// API
469 	
470 	// i - Game number
471 	function getGameInfo(uint i) public view returns (uint, uint, uint, uint8, uint8, uint8, uint8, uint8, uint8) {
472 	    Game memory game = games[i];
473 	    return (game.datetime, game.totalFund, game.membersCounter, game.win_numbers[0], game.win_numbers[1], game.win_numbers[2], game.win_numbers[3], game.win_numbers[4], game.status);
474 	}
475 	
476 	// i - Game number, j - Ticket number
477 	function getMemberInfo(uint i, uint j) public view returns (address, uint, uint8, uint8, uint8, uint8, uint8, uint8, uint) {
478 	    Member memory mbr = games[i].members[j];
479 	    return (mbr.addr, mbr.ticket, mbr.matchNumbers, mbr.numbers[0], mbr.numbers[1], mbr.numbers[2], mbr.numbers[3], mbr.numbers[4], mbr.prize);
480 	}
481 
482 }
483 
484 /**
485  * @title SafeMath
486  * @dev Math operations with safety checks that throw on error
487  */
488 library SafeMath {
489 
490     function mul(uint256 a, uint256 b) internal pure returns(uint256) {
491         uint256 c = a * b;
492         assert(a == 0 || c / a == b);
493         return c;
494     }
495 
496     function div(uint256 a, uint256 b) internal pure returns(uint256) {
497         // assert(b > 0); // Solidity automatically throws when dividing by 0
498         uint256 c = a / b;
499         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
500         return c;
501     }
502 
503     function sub(uint256 a, uint256 b) internal pure returns(uint256) {
504         assert(b <= a);
505         return a - b;
506     }
507 
508     function add(uint256 a, uint256 b) internal pure returns(uint256) {
509         uint256 c = a + b;
510         assert(c >= a);
511         return c;
512     }
513 
514 }