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
56 	address payable private constant ADDRESS_SERVICE = 0xA3ba6CA37E5A3904ECd79D31B575dc1B2BEA6A74;
57 	address payable private constant ADDRESS_START_JACKPOT = 0xa42b3D62471E3e9Cc502d3ef65857deb04032613;
58 	address payable private constant ADDRESS_PR = 0x173Ff9be87F1D282B7377d443Aa5C12842266BD3;
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
81 
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
99 	}
100 	
101 	// Return starting Jackpot after 6 months
102 	function _returnStartJackpot() private { 
103 		
104 		if(JACKPOT > start_jackpot_amount * 2 || (now - CONTRACT_STARTED_DATE) > return_jackpot_period) {
105 			
106 			if(JACKPOT > start_jackpot_amount) {
107 				ADDRESS_START_JACKPOT.transfer(start_jackpot_amount);
108 				JACKPOT = JACKPOT - start_jackpot_amount;
109 				start_jackpot_amount = 0;
110 			} else {
111 				ADDRESS_START_JACKPOT.transfer(JACKPOT);
112 				start_jackpot_amount = 0;
113 				JACKPOT = 0;
114 			}
115 			emit UpdateJackpot(JACKPOT);
116 			
117 		} 
118 		
119 	}
120 	
121 	
122 	///////////////////////////////////////////////////////////////////////////////////////////////////////
123 	// Running a Game
124 	///////////////////////////////////////////////////////////////////////////////////////////////////////
125 	function startGame() private {
126 	    
127 	    uint8 weekday = getWeekday(now);
128 		uint8 hour = getHour(now);
129 	    
130 		if(GAME_NUM == 0) {
131 		    GAME_NUM = 1;
132 		    games[GAME_NUM].datetime = now;
133 		    games[GAME_NUM].status = 1;
134 		    CONTRACT_STARTED_DATE = now;
135 		} else {
136 		    if(weekday == 7 && hour == 9) {
137 
138 		        if(msg.value == 111) {
139 		            processGame();
140 		        }
141 		    
142 		        if(msg.value == 222) {
143 		            games[GAME_NUM].status = 1;
144 		        }
145 
146 		    }
147 		}
148 
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
275 	}
276 	
277 	// Find match numbers function
278 	function findMatch(uint8[5] memory arr1, uint8[5] memory arr2) private pure returns (uint8) {
279 	    
280 	    uint8 cnt = 0;
281 	    
282 	    for(uint8 i = 0; i < 5; i++) {
283 	        for(uint8 j = 0; j < 5; j++) {
284 	            if(arr1[i] == arr2[j]) {
285 	                cnt++;
286 	                break;
287 	            }
288 	        }
289 	    }
290 	    
291 	    return cnt;
292 
293 	}
294 	
295 	///////////////////////////////////////////////////////////////////////////////////////////////////////
296 	// Buy ticket process
297 	///////////////////////////////////////////////////////////////////////////////////////////////////////
298 	function processUserTicket() private {
299 		
300 		uint8 weekday = getWeekday(now);
301 		uint8 hour = getHour(now);
302 		
303 		if( GAME_NUM > 0 && (weekday != 7 || (weekday == 7 && (hour < 8 || hour > 11 ))) ) {
304 
305 		    if(msg.value == TICKET_PRICE) {
306 			    createTicket();
307 		    } else {
308 			    if(msg.value < TICKET_PRICE) {
309 				    FUND_PR = FUND_PR + msg.value.mul(PERCENT_FUND_PR).div(100);
310 				    games[GAME_NUM].totalFund = games[GAME_NUM].totalFund + msg.value.mul(100 - PERCENT_FUND_PR).div(100);
311 				    emit UpdateFund(games[GAME_NUM].totalFund);
312 			    } else {
313 				    msg.sender.transfer(msg.value.sub(TICKET_PRICE));
314 				    createTicket();
315 			    }
316 		    }
317 		
318 		} else {
319 		     msg.sender.transfer(msg.value);
320 		}
321 		
322 	}
323 	
324 	function createTicket() private {
325 		
326 		bool err = false;
327 		uint8[5] memory numbers;
328 		
329 		// Calculate funds
330 		FUND_PR = FUND_PR + TICKET_PRICE.mul(PERCENT_FUND_PR).div(100);
331 		games[GAME_NUM].totalFund = games[GAME_NUM].totalFund + TICKET_PRICE.mul(100 - PERCENT_FUND_PR).div(100);
332 		emit UpdateFund(games[GAME_NUM].totalFund);
333 		
334 		// Parse and check msg.DATA
335 		(err, numbers) = ParseCheckData();
336 		
337 		uint mbrCnt;
338 
339 		// If no errors, sort numbers array and save member
340 		if(!err) {
341 		    numbers = sortNumbers(numbers);
342 
343 		    // Increase member counter
344 		    games[GAME_NUM].membersCounter++;
345 		    mbrCnt = games[GAME_NUM].membersCounter;
346 
347 		    // Save member
348 		    games[GAME_NUM].members[mbrCnt].addr = msg.sender;
349 		    games[GAME_NUM].members[mbrCnt].ticket = mbrCnt;
350 		    games[GAME_NUM].members[mbrCnt].numbers = numbers;
351 		    games[GAME_NUM].members[mbrCnt].matchNumbers = 0;
352 		    
353 		    emit NewMember(GAME_NUM, mbrCnt, msg.sender, numbers[0], numbers[1], numbers[2], numbers[3], numbers[4]);
354 		    
355 		}
356 
357 	}
358 	
359 	
360 	// Parse and check msg.DATA function
361 	function ParseCheckData() private view returns (bool, uint8[5] memory) {
362 	    
363 	    bool err = false;
364 	    uint8[5] memory numbers;
365 	    
366 	    // Check 5 numbers entered
367 	    if(msg.data.length == 5) {
368 	        
369 	        // Parse DATA string
370 		    for(uint8 i = 0; i < msg.data.length; i++) {
371 		        numbers[i] = uint8(msg.data[i]);
372 		    }
373 		    
374 		    // Check range: 1 - MAX_NUMBER
375 		    for(uint8 i = 0; i < numbers.length; i++) {
376 		        if(numbers[i] < 1 || numbers[i] > MAX_NUMBER) {
377 		            err = true;
378 		            break;
379 		        }
380 		    }
381 		    
382 		    // Check dublicate numbers
383 		    if(!err) {
384 		    
385 		        for(uint8 i = 0; i < numbers.length-1; i++) {
386 		            for(uint8 j = i+1; j < numbers.length; j++) {
387 		                if(numbers[i] == numbers[j]) {
388 		                    err = true;
389 		                    break;
390 		                }
391 		            }
392 		            if(err) {
393 		                break;
394 		            }
395 		        }
396 		        
397 		    }
398 		    
399 	    } else {
400 	        err = true;
401 	    }
402 
403 	    return (err, numbers);
404 
405 	}
406 	
407 	// Sort array of number function
408 	function sortNumbers(uint8[5] memory arrNumbers) private pure returns (uint8[5] memory) {
409 	    
410 	    uint8 temp;
411 	    
412 	    for(uint8 i = 0; i < arrNumbers.length - 1; i++) {
413             for(uint j = 0; j < arrNumbers.length - i - 1; j++)
414                 if (arrNumbers[j] > arrNumbers[j + 1]) {
415                     temp = arrNumbers[j];
416                     arrNumbers[j] = arrNumbers[j + 1];
417                     arrNumbers[j + 1] = temp;
418                 }    
419 	    }
420         
421         return arrNumbers;
422         
423 	}
424 	
425 	// Contract address balance
426     function getBalance() public view returns(uint) {
427         uint balance = address(this).balance;
428 		return balance;
429 	}
430 	
431 	// Generate random number
432 	function random(uint8 num) internal view returns (uint8) {
433 	    
434         return uint8(uint(blockhash(block.number - 1 - num*2)) % MAX_NUMBER + 1);
435         
436     } 
437     
438     function getHour(uint timestamp) private pure returns (uint8) {
439         return uint8((timestamp / 60 / 60) % 24);
440     }
441     
442     function getWeekday(uint timestamp) private pure returns (uint8) {
443         return uint8((timestamp / DAY_IN_SECONDS + 4) % 7);
444     }
445 	
446 	
447 	// API
448 	
449 	// i - Game number
450 	function getGameInfo(uint i) public view returns (uint, uint, uint, uint8, uint8, uint8, uint8, uint8, uint8) {
451 	    Game memory game = games[i];
452 	    return (game.datetime, game.totalFund, game.membersCounter, game.win_numbers[0], game.win_numbers[1], game.win_numbers[2], game.win_numbers[3], game.win_numbers[4], game.status);
453 	}
454 	
455 	// i - Game number, j - Ticket number
456 	function getMemberInfo(uint i, uint j) public view returns (address, uint, uint8, uint8, uint8, uint8, uint8, uint8, uint) {
457 	    Member memory mbr = games[i].members[j];
458 	    return (mbr.addr, mbr.ticket, mbr.matchNumbers, mbr.numbers[0], mbr.numbers[1], mbr.numbers[2], mbr.numbers[3], mbr.numbers[4], mbr.prize);
459 	}
460 
461 }
462 
463 /**
464  * @title SafeMath
465  * @dev Math operations with safety checks that throw on error
466  */
467 library SafeMath {
468 
469     function mul(uint256 a, uint256 b) internal pure returns(uint256) {
470         uint256 c = a * b;
471         assert(a == 0 || c / a == b);
472         return c;
473     }
474 
475     function div(uint256 a, uint256 b) internal pure returns(uint256) {
476         // assert(b > 0); // Solidity automatically throws when dividing by 0
477         uint256 c = a / b;
478         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
479         return c;
480     }
481 
482     function sub(uint256 a, uint256 b) internal pure returns(uint256) {
483         assert(b <= a);
484         return a - b;
485     }
486 
487     function add(uint256 a, uint256 b) internal pure returns(uint256) {
488         uint256 c = a + b;
489         assert(c >= a);
490         return c;
491     }
492 
493 }