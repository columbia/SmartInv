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
12     uint private constant DAY_IN_SECONDS = 86400;
13 	
14 	// Member struct
15 	struct Member {
16 		address payable addr;						// Address
17 		uint ticket;								// Ticket number
18 		uint8[5] numbers;                           // Selected numbers
19 		uint8 matchNumbers;                         // Match numbers
20 		uint prize;                                 // Winning prize
21 	}
22 	
23 	
24 	// Game struct
25 	struct Game {
26 		uint datetime;								// Game timestamp
27 		uint8[5] win_numbers;						// Winning numbers
28 		uint membersCounter;						// Members count
29 		uint totalFund;                             // Total prize fund
30 		uint8 status;                               // Game status: 0 - created, 1 - pleyed
31 		mapping(uint => Member) members;		    // Members list
32 	}
33 	
34 	mapping(uint => Game) public games;
35 	
36 	uint private CONTRACT_STARTED_DATE = 0;
37 	uint private constant TICKET_PRICE = 0.01 ether;
38 	uint private constant MAX_NUMBER = 36;						            // Максимально возможное число -> 36
39 	
40 	uint private constant PERCENT_FUND_JACKPOT = 15;                        // (%) Increase Jackpot
41 	uint private constant PERCENT_FUND_4 = 35;                              // (%) Fund 4 of 5
42 	uint private constant PERCENT_FUND_3 = 30;                              // (%) Fund 3 of 5
43     uint private constant PERCENT_FUND_2 = 20;                              // (%) Fund 2 of 5
44     
45 	uint public JACKPOT = 0;
46 	
47 	// Init params
48 	uint public GAME_NUM = 0;
49 	uint private constant return_jackpot_period = 25 weeks;
50 	uint private start_jackpot_amount = 0;
51 	
52 	uint private constant PERCENT_FUND_PR = 12;                             // (%) PR & ADV
53 	uint private FUND_PR = 0;                                               // Fund PR & ADV
54 
55 	// Addresses
56 	address private constant ADDRESS_SERVICE = 0x203bF6B46508eD917c085F50F194F36b0a62EB02;
57 	address payable private constant ADDRESS_START_JACKPOT = 0x531d3Bd0400Ae601f26B335EfbD787415Aa5CB81;
58 	address payable private constant ADDRESS_PR = 0xCD66911b6f38FaAF5BFeE427b3Ceb7D18Dd09F78;
59 	
60 	// Events
61 	event NewMember(uint _gamenum, uint _ticket, address _addr, uint8 _n1, uint8 _n2, uint8 _n3, uint8 _n4, uint8 _n5);
62 	event NewGame(uint _gamenum);
63 	event UpdateFund(uint _fund);
64 	event UpdateJackpot(uint _jackpot);
65 	event WinNumbers(uint _gamenum, uint8 _n1, uint8 _n2, uint8 _n3, uint8 _n4, uint8 _n5);
66 	event WinPrize(uint _gamenum, uint _ticket, uint _prize, uint8 _match);
67 
68 	// Entry point
69 	function() external payable {
70 	    
71         // Select action
72 		if(msg.sender == ADDRESS_START_JACKPOT) {
73 			processStartingJackpot();
74 		} else {
75 			if(msg.sender == ADDRESS_SERVICE) {
76 				startGame();
77 			} else {
78 				processUserTicket();
79 			}
80 		}
81 		return;
82     }
83 	
84 	///////////////////////////////////////////////////////////////////////////////////////////////////////
85 	// Starting Jackpot action
86 	///////////////////////////////////////////////////////////////////////////////////////////////////////
87 	function processStartingJackpot() private {
88 		// If value > 0, increase starting Jackpot
89 		if(msg.value > 0) {
90 			JACKPOT += msg.value;
91 			start_jackpot_amount += msg.value;
92 			emit UpdateJackpot(JACKPOT);
93 		// Else, return starting Jackpot
94 		} else {
95 			if(start_jackpot_amount > 0){
96 				_returnStartJackpot();
97 			}
98 		}
99 		return;
100 	}
101 	
102 	// Return starting Jackpot after 6 months
103 	function _returnStartJackpot() private { 
104 		
105 		if(JACKPOT > start_jackpot_amount * 2 || (now - CONTRACT_STARTED_DATE) > return_jackpot_period) {
106 			
107 			if(JACKPOT > start_jackpot_amount) {
108 				ADDRESS_START_JACKPOT.transfer(start_jackpot_amount);
109 				JACKPOT = JACKPOT - start_jackpot_amount;
110 				start_jackpot_amount = 0;
111 			} else {
112 				ADDRESS_START_JACKPOT.transfer(JACKPOT);
113 				start_jackpot_amount = 0;
114 				JACKPOT = 0;
115 			}
116 			emit UpdateJackpot(JACKPOT);
117 			
118 		} 
119 		return;
120 	}
121 	
122 	
123 	///////////////////////////////////////////////////////////////////////////////////////////////////////
124 	// Running a Game
125 	///////////////////////////////////////////////////////////////////////////////////////////////////////
126 	function startGame() private {
127 	    
128 	    uint8 weekday = getWeekday(now);
129 		uint8 hour = getHour(now);
130 	    
131 		if(GAME_NUM == 0) {
132 		    GAME_NUM = 1;
133 		    games[GAME_NUM].datetime = now;
134 		    games[GAME_NUM].status = 1;
135 		    CONTRACT_STARTED_DATE = now;
136 		} else {
137 		    if(weekday == 3 && hour == 16) {
138 
139 		        if(games[GAME_NUM].status == 1) {
140 		            processGame();
141 		        }
142 
143 		    } else {
144 		        games[GAME_NUM].status = 1;
145 		    }
146 		    
147 		}
148         return;
149 	}
150 	
151 	function processGame() private {
152 	    
153 	    uint8 mn = 0;
154 		uint winners5 = 0;
155 		uint winners4 = 0;
156 		uint winners3 = 0;
157 		uint winners2 = 0;
158 
159 		uint fund4 = 0;
160 		uint fund3 = 0;
161 		uint fund2 = 0;
162 	    
163 	    // Generate winning numbers
164 	    for(uint8 i = 0; i < 5; i++) {
165 	        games[GAME_NUM].win_numbers[i] = random(i);
166 	    }
167 
168 	    // Sort winning numbers array
169 	    games[GAME_NUM].win_numbers = sortNumbers(games[GAME_NUM].win_numbers);
170 	    
171 	    // Change dublicate numbers
172 	    for(uint8 i = 0; i < 4; i++) {
173 	        for(uint8 j = i+1; j < 5; j++) {
174 	            if(games[GAME_NUM].win_numbers[i] == games[GAME_NUM].win_numbers[j]) {
175 	                games[GAME_NUM].win_numbers[j]++;
176 	            }
177 	        }
178 	    }
179 	    
180 	    uint8[5] memory win_numbers;
181 	    win_numbers = games[GAME_NUM].win_numbers;
182 	    emit WinNumbers(GAME_NUM, win_numbers[0], win_numbers[1], win_numbers[2], win_numbers[3], win_numbers[4]);
183 	    
184 	    if(games[GAME_NUM].membersCounter > 0) {
185 	    
186 	        // Pocess tickets list
187 	        for(uint i = 1; i <= games[GAME_NUM].membersCounter; i++) {
188 	            
189 	            mn = findMatch(games[GAME_NUM].win_numbers, games[GAME_NUM].members[i].numbers);
190 				games[GAME_NUM].members[i].matchNumbers = mn;
191 				
192 				if(mn == 5) {
193 					winners5++;
194 				}
195 				if(mn == 4) {
196 					winners4++;
197 				}
198 				if(mn == 3) {
199 					winners3++;
200 				}
201 				if(mn == 2) {
202 					winners2++;
203 				}
204 				
205 	        }
206 	        
207 	        // Fund calculate
208 	        JACKPOT = JACKPOT + games[GAME_NUM].totalFund * PERCENT_FUND_JACKPOT / 100;
209 			fund4 = games[GAME_NUM].totalFund * PERCENT_FUND_4 / 100;
210 			fund3 = games[GAME_NUM].totalFund * PERCENT_FUND_3 / 100;
211 			fund2 = games[GAME_NUM].totalFund * PERCENT_FUND_2 / 100;
212 			
213 			if(winners4 == 0) {
214 			    JACKPOT = JACKPOT + fund4;
215 			}
216 			if(winners3 == 0) {
217 			    JACKPOT = JACKPOT + fund3;
218 			}
219 			if(winners2 == 0) {
220 			    JACKPOT = JACKPOT + fund2;
221 			}
222             
223 			for(uint i = 1; i <= games[GAME_NUM].membersCounter; i++) {
224 			    
225 			    if(games[GAME_NUM].members[i].matchNumbers == 5) {
226 			        games[GAME_NUM].members[i].prize = JACKPOT / winners5;
227 			        games[GAME_NUM].members[i].addr.transfer(games[GAME_NUM].members[i].prize);
228 			        emit WinPrize(GAME_NUM, games[GAME_NUM].members[i].ticket, games[GAME_NUM].members[i].prize, 5);
229 			    }
230 			    
231 			    if(games[GAME_NUM].members[i].matchNumbers == 4) {
232 			        games[GAME_NUM].members[i].prize = fund4 / winners4;
233 			        games[GAME_NUM].members[i].addr.transfer(games[GAME_NUM].members[i].prize);
234 			        emit WinPrize(GAME_NUM, games[GAME_NUM].members[i].ticket, games[GAME_NUM].members[i].prize, 4);
235 			    }
236 			    
237 			    if(games[GAME_NUM].members[i].matchNumbers == 3) {
238 			        games[GAME_NUM].members[i].prize = fund3 / winners3;
239 			        games[GAME_NUM].members[i].addr.transfer(games[GAME_NUM].members[i].prize);
240 			        emit WinPrize(GAME_NUM, games[GAME_NUM].members[i].ticket, games[GAME_NUM].members[i].prize, 3);
241 			    }
242 			    
243 			    if(games[GAME_NUM].members[i].matchNumbers == 2) {
244 			        games[GAME_NUM].members[i].prize = fund2 / winners2;
245 			        games[GAME_NUM].members[i].addr.transfer(games[GAME_NUM].members[i].prize);
246 			        emit WinPrize(GAME_NUM, games[GAME_NUM].members[i].ticket, games[GAME_NUM].members[i].prize, 2);
247 			    }
248 			    
249 			    if(games[GAME_NUM].members[i].matchNumbers == 1) {
250 			        emit WinPrize(GAME_NUM, games[GAME_NUM].members[i].ticket, games[GAME_NUM].members[i].prize, 1);
251 			    }
252 			    
253 			}
254 			
255 			// If exist Jackpot winners, init JACPOT
256 			if(winners5 != 0) {
257 			    JACKPOT = 0;
258 			    start_jackpot_amount = 0;
259 			}
260 			
261 	    }
262 	    
263 	    emit UpdateJackpot(JACKPOT);
264 	    
265 	    // Init next Game
266 	    GAME_NUM++;
267 	    games[GAME_NUM].datetime = now;
268 	    games[GAME_NUM].status = 0;
269 	    emit NewGame(GAME_NUM);
270 	    
271 	    // Transfer
272 	    ADDRESS_PR.transfer(FUND_PR);
273 	    FUND_PR = 0;
274 	    
275 	    return;
276 
277 	}
278 	
279 	// Find match numbers function
280 	function findMatch(uint8[5] memory arr1, uint8[5] memory arr2) private pure returns (uint8) {
281 	    
282 	    uint8 cnt = 0;
283 	    
284 	    for(uint8 i = 0; i < 5; i++) {
285 	        for(uint8 j = 0; j < 5; j++) {
286 	            if(arr1[i] == arr2[j]) {
287 	                cnt++;
288 	                break;
289 	            }
290 	        }
291 	    }
292 	    
293 	    return cnt;
294 
295 	}
296 	
297 	///////////////////////////////////////////////////////////////////////////////////////////////////////
298 	// Buy ticket process
299 	///////////////////////////////////////////////////////////////////////////////////////////////////////
300 	function processUserTicket() private {
301 		
302 		uint8 weekday = getWeekday(now);
303 		uint8 hour = getHour(now);
304 		
305 		if( GAME_NUM > 0 && games[GAME_NUM].status == 1 ) {
306 
307 		    if(msg.value == TICKET_PRICE) {
308 			    createTicket();
309 		    } else {
310 			    if(msg.value < TICKET_PRICE) {
311 				    FUND_PR = FUND_PR + msg.value.mul(PERCENT_FUND_PR).div(100);
312 				    games[GAME_NUM].totalFund = games[GAME_NUM].totalFund + msg.value.mul(100 - PERCENT_FUND_PR).div(100);
313 				    emit UpdateFund(games[GAME_NUM].totalFund);
314 			    } else {
315 				    msg.sender.transfer(msg.value.sub(TICKET_PRICE));
316 				    createTicket();
317 			    }
318 		    }
319 		
320 		} else {
321 		     msg.sender.transfer(msg.value);
322 		}
323 		
324 	}
325 	
326 	function createTicket() private {
327 		
328 		bool err = false;
329 		uint8[5] memory numbers;
330 		
331 		// Calculate funds
332 		FUND_PR = FUND_PR + TICKET_PRICE.mul(PERCENT_FUND_PR).div(100);
333 		games[GAME_NUM].totalFund = games[GAME_NUM].totalFund + TICKET_PRICE.mul(100 - PERCENT_FUND_PR).div(100);
334 		emit UpdateFund(games[GAME_NUM].totalFund);
335 		
336 		// Parse and check msg.DATA
337 		(err, numbers) = ParseCheckData();
338 		
339 		uint mbrCnt;
340 
341 		// If no errors, sort numbers array and save member
342 		if(!err) {
343 		    numbers = sortNumbers(numbers);
344 
345 		    // Increase member counter
346 		    games[GAME_NUM].membersCounter++;
347 		    mbrCnt = games[GAME_NUM].membersCounter;
348 
349 		    // Save member
350 		    games[GAME_NUM].members[mbrCnt].addr = msg.sender;
351 		    games[GAME_NUM].members[mbrCnt].ticket = mbrCnt;
352 		    games[GAME_NUM].members[mbrCnt].numbers = numbers;
353 		    games[GAME_NUM].members[mbrCnt].matchNumbers = 0;
354 		    
355 		    emit NewMember(GAME_NUM, mbrCnt, msg.sender, numbers[0], numbers[1], numbers[2], numbers[3], numbers[4]);
356 		    
357 		}
358 
359 	}
360 	
361 	
362 	// Parse and check msg.DATA function
363 	function ParseCheckData() private view returns (bool, uint8[5] memory) {
364 	    
365 	    bool err = false;
366 	    uint8[5] memory numbers;
367 	    
368 	    // Check 5 numbers entered
369 	    if(msg.data.length == 5) {
370 	        
371 	        // Parse DATA string
372 		    for(uint8 i = 0; i < msg.data.length; i++) {
373 		        numbers[i] = uint8(msg.data[i]);
374 		    }
375 		    
376 		    // Check range: 1 - MAX_NUMBER
377 		    for(uint8 i = 0; i < numbers.length; i++) {
378 		        if(numbers[i] < 1 || numbers[i] > MAX_NUMBER) {
379 		            err = true;
380 		            break;
381 		        }
382 		    }
383 		    
384 		    // Check dublicate numbers
385 		    if(!err) {
386 		    
387 		        for(uint8 i = 0; i < numbers.length-1; i++) {
388 		            for(uint8 j = i+1; j < numbers.length; j++) {
389 		                if(numbers[i] == numbers[j]) {
390 		                    err = true;
391 		                    break;
392 		                }
393 		            }
394 		            if(err) {
395 		                break;
396 		            }
397 		        }
398 		        
399 		    }
400 		    
401 	    } else {
402 	        err = true;
403 	    }
404 
405 	    return (err, numbers);
406 
407 	}
408 	
409 	// Sort array of number function
410 	function sortNumbers(uint8[5] memory arrNumbers) private pure returns (uint8[5] memory) {
411 	    
412 	    uint8 temp;
413 	    
414 	    for(uint8 i = 0; i < arrNumbers.length - 1; i++) {
415             for(uint j = 0; j < arrNumbers.length - i - 1; j++)
416                 if (arrNumbers[j] > arrNumbers[j + 1]) {
417                     temp = arrNumbers[j];
418                     arrNumbers[j] = arrNumbers[j + 1];
419                     arrNumbers[j + 1] = temp;
420                 }    
421 	    }
422         
423         return arrNumbers;
424         
425 	}
426 	
427 	// Contract address balance
428     function getBalance() public view returns(uint) {
429         uint balance = address(this).balance;
430 		return balance;
431 	}
432 	
433 	// Generate random number
434 	function random(uint8 num) internal view returns (uint8) {
435 	    
436         return uint8(uint(blockhash(block.number - 1 - num*2)) % MAX_NUMBER + 1);
437         
438     } 
439     
440     function getHour(uint timestamp) private pure returns (uint8) {
441         return uint8((timestamp / 60 / 60) % 24);
442     }
443     
444     function getWeekday(uint timestamp) private pure returns (uint8) {
445         return uint8((timestamp / DAY_IN_SECONDS + 4) % 7);
446     }
447 	
448 	
449 	// API
450 	
451 	// i - Game number
452 	function getGameInfo(uint i) public view returns (uint, uint, uint, uint8, uint8, uint8, uint8, uint8, uint8) {
453 	    Game memory game = games[i];
454 	    return (game.datetime, game.totalFund, game.membersCounter, game.win_numbers[0], game.win_numbers[1], game.win_numbers[2], game.win_numbers[3], game.win_numbers[4], game.status);
455 	}
456 	
457 	// i - Game number, j - Ticket number
458 	function getMemberInfo(uint i, uint j) public view returns (address, uint, uint8, uint8, uint8, uint8, uint8, uint8, uint) {
459 	    Member memory mbr = games[i].members[j];
460 	    return (mbr.addr, mbr.ticket, mbr.matchNumbers, mbr.numbers[0], mbr.numbers[1], mbr.numbers[2], mbr.numbers[3], mbr.numbers[4], mbr.prize);
461 	}
462 
463 }
464 
465 /**
466  * @title SafeMath
467  * @dev Math operations with safety checks that throw on error
468  */
469 library SafeMath {
470 
471     function mul(uint256 a, uint256 b) internal pure returns(uint256) {
472         uint256 c = a * b;
473         assert(a == 0 || c / a == b);
474         return c;
475     }
476 
477     function div(uint256 a, uint256 b) internal pure returns(uint256) {
478         // assert(b > 0); // Solidity automatically throws when dividing by 0
479         uint256 c = a / b;
480         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
481         return c;
482     }
483 
484     function sub(uint256 a, uint256 b) internal pure returns(uint256) {
485         assert(b <= a);
486         return a - b;
487     }
488 
489     function add(uint256 a, uint256 b) internal pure returns(uint256) {
490         uint256 c = a + b;
491         assert(c >= a);
492         return c;
493     }
494 
495 }