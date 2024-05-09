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
56 	address payable private constant ADDRESS_SERVICE = 0xa01d5284C84C0e1Db294C3690Eb49234dE775e78;
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
138 		        if(games[GAME_NUM].status == 1) {
139 		            processGame();
140 		        }
141 
142 		    } else {
143 		        games[GAME_NUM].status = 1;
144 		    }
145 		    
146 		}
147 
148 	}
149 	
150 	function processGame() private {
151 	    
152 	    uint8 mn = 0;
153 		uint winners5 = 0;
154 		uint winners4 = 0;
155 		uint winners3 = 0;
156 		uint winners2 = 0;
157 
158 		uint fund4 = 0;
159 		uint fund3 = 0;
160 		uint fund2 = 0;
161 	    
162 	    // Generate winning numbers
163 	    for(uint8 i = 0; i < 5; i++) {
164 	        games[GAME_NUM].win_numbers[i] = random(i);
165 	    }
166 
167 	    // Sort winning numbers array
168 	    games[GAME_NUM].win_numbers = sortNumbers(games[GAME_NUM].win_numbers);
169 	    
170 	    // Change dublicate numbers
171 	    for(uint8 i = 0; i < 4; i++) {
172 	        for(uint8 j = i+1; j < 5; j++) {
173 	            if(games[GAME_NUM].win_numbers[i] == games[GAME_NUM].win_numbers[j]) {
174 	                games[GAME_NUM].win_numbers[j]++;
175 	            }
176 	        }
177 	    }
178 	    
179 	    uint8[5] memory win_numbers;
180 	    win_numbers = games[GAME_NUM].win_numbers;
181 	    emit WinNumbers(GAME_NUM, win_numbers[0], win_numbers[1], win_numbers[2], win_numbers[3], win_numbers[4]);
182 	    
183 	    if(games[GAME_NUM].membersCounter > 0) {
184 	    
185 	        // Pocess tickets list
186 	        for(uint i = 1; i <= games[GAME_NUM].membersCounter; i++) {
187 	            
188 	            mn = findMatch(games[GAME_NUM].win_numbers, games[GAME_NUM].members[i].numbers);
189 				games[GAME_NUM].members[i].matchNumbers = mn;
190 				
191 				if(mn == 5) {
192 					winners5++;
193 				}
194 				if(mn == 4) {
195 					winners4++;
196 				}
197 				if(mn == 3) {
198 					winners3++;
199 				}
200 				if(mn == 2) {
201 					winners2++;
202 				}
203 				
204 	        }
205 	        
206 	        // Fund calculate
207 	        JACKPOT = JACKPOT + games[GAME_NUM].totalFund * PERCENT_FUND_JACKPOT / 100;
208 			fund4 = games[GAME_NUM].totalFund * PERCENT_FUND_4 / 100;
209 			fund3 = games[GAME_NUM].totalFund * PERCENT_FUND_3 / 100;
210 			fund2 = games[GAME_NUM].totalFund * PERCENT_FUND_2 / 100;
211 			
212 			if(winners4 == 0) {
213 			    JACKPOT = JACKPOT + fund4;
214 			}
215 			if(winners3 == 0) {
216 			    JACKPOT = JACKPOT + fund3;
217 			}
218 			if(winners2 == 0) {
219 			    JACKPOT = JACKPOT + fund2;
220 			}
221             
222 			for(uint i = 1; i <= games[GAME_NUM].membersCounter; i++) {
223 			    
224 			    if(games[GAME_NUM].members[i].matchNumbers == 5) {
225 			        games[GAME_NUM].members[i].prize = JACKPOT / winners5;
226 			        games[GAME_NUM].members[i].addr.transfer(games[GAME_NUM].members[i].prize);
227 			        emit WinPrize(GAME_NUM, games[GAME_NUM].members[i].ticket, games[GAME_NUM].members[i].prize, 5);
228 			    }
229 			    
230 			    if(games[GAME_NUM].members[i].matchNumbers == 4) {
231 			        games[GAME_NUM].members[i].prize = fund4 / winners4;
232 			        games[GAME_NUM].members[i].addr.transfer(games[GAME_NUM].members[i].prize);
233 			        emit WinPrize(GAME_NUM, games[GAME_NUM].members[i].ticket, games[GAME_NUM].members[i].prize, 4);
234 			    }
235 			    
236 			    if(games[GAME_NUM].members[i].matchNumbers == 3) {
237 			        games[GAME_NUM].members[i].prize = fund3 / winners3;
238 			        games[GAME_NUM].members[i].addr.transfer(games[GAME_NUM].members[i].prize);
239 			        emit WinPrize(GAME_NUM, games[GAME_NUM].members[i].ticket, games[GAME_NUM].members[i].prize, 3);
240 			    }
241 			    
242 			    if(games[GAME_NUM].members[i].matchNumbers == 2) {
243 			        games[GAME_NUM].members[i].prize = fund2 / winners2;
244 			        games[GAME_NUM].members[i].addr.transfer(games[GAME_NUM].members[i].prize);
245 			        emit WinPrize(GAME_NUM, games[GAME_NUM].members[i].ticket, games[GAME_NUM].members[i].prize, 2);
246 			    }
247 			    
248 			    if(games[GAME_NUM].members[i].matchNumbers == 1) {
249 			        emit WinPrize(GAME_NUM, games[GAME_NUM].members[i].ticket, games[GAME_NUM].members[i].prize, 1);
250 			    }
251 			    
252 			}
253 			
254 			// If exist Jackpot winners, init JACPOT
255 			if(winners5 != 0) {
256 			    JACKPOT = 0;
257 			    start_jackpot_amount = 0;
258 			}
259 			
260 	    }
261 	    
262 	    emit UpdateJackpot(JACKPOT);
263 	    
264 	    // Init next Game
265 	    GAME_NUM++;
266 	    games[GAME_NUM].datetime = now;
267 	    games[GAME_NUM].status = 0;
268 	    emit NewGame(GAME_NUM);
269 	    
270 	    // Transfer
271 	    ADDRESS_PR.transfer(FUND_PR);
272 	    FUND_PR = 0;
273 
274 	}
275 	
276 	// Find match numbers function
277 	function findMatch(uint8[5] memory arr1, uint8[5] memory arr2) private pure returns (uint8) {
278 	    
279 	    uint8 cnt = 0;
280 	    
281 	    for(uint8 i = 0; i < 5; i++) {
282 	        for(uint8 j = 0; j < 5; j++) {
283 	            if(arr1[i] == arr2[j]) {
284 	                cnt++;
285 	                break;
286 	            }
287 	        }
288 	    }
289 	    
290 	    return cnt;
291 
292 	}
293 	
294 	///////////////////////////////////////////////////////////////////////////////////////////////////////
295 	// Buy ticket process
296 	///////////////////////////////////////////////////////////////////////////////////////////////////////
297 	function processUserTicket() private {
298 		
299 		uint8 weekday = getWeekday(now);
300 		uint8 hour = getHour(now);
301 		
302 		if( GAME_NUM > 0 && (weekday != 7 || (weekday == 7 && (hour < 8 || hour > 11 ))) ) {
303 
304 		    if(msg.value == TICKET_PRICE) {
305 			    createTicket();
306 		    } else {
307 			    if(msg.value < TICKET_PRICE) {
308 				    FUND_PR = FUND_PR + msg.value.mul(PERCENT_FUND_PR).div(100);
309 				    games[GAME_NUM].totalFund = games[GAME_NUM].totalFund + msg.value.mul(100 - PERCENT_FUND_PR).div(100);
310 				    emit UpdateFund(games[GAME_NUM].totalFund);
311 			    } else {
312 				    msg.sender.transfer(msg.value.sub(TICKET_PRICE));
313 				    createTicket();
314 			    }
315 		    }
316 		
317 		} else {
318 		     msg.sender.transfer(msg.value);
319 		}
320 		
321 	}
322 	
323 	function createTicket() private {
324 		
325 		bool err = false;
326 		uint8[5] memory numbers;
327 		
328 		// Calculate funds
329 		FUND_PR = FUND_PR + TICKET_PRICE.mul(PERCENT_FUND_PR).div(100);
330 		games[GAME_NUM].totalFund = games[GAME_NUM].totalFund + TICKET_PRICE.mul(100 - PERCENT_FUND_PR).div(100);
331 		emit UpdateFund(games[GAME_NUM].totalFund);
332 		
333 		// Parse and check msg.DATA
334 		(err, numbers) = ParseCheckData();
335 		
336 		uint mbrCnt;
337 
338 		// If no errors, sort numbers array and save member
339 		if(!err) {
340 		    numbers = sortNumbers(numbers);
341 
342 		    // Increase member counter
343 		    games[GAME_NUM].membersCounter++;
344 		    mbrCnt = games[GAME_NUM].membersCounter;
345 
346 		    // Save member
347 		    games[GAME_NUM].members[mbrCnt].addr = msg.sender;
348 		    games[GAME_NUM].members[mbrCnt].ticket = mbrCnt;
349 		    games[GAME_NUM].members[mbrCnt].numbers = numbers;
350 		    games[GAME_NUM].members[mbrCnt].matchNumbers = 0;
351 		    
352 		    emit NewMember(GAME_NUM, mbrCnt, msg.sender, numbers[0], numbers[1], numbers[2], numbers[3], numbers[4]);
353 		    
354 		}
355 
356 	}
357 	
358 	
359 	// Parse and check msg.DATA function
360 	function ParseCheckData() private view returns (bool, uint8[5] memory) {
361 	    
362 	    bool err = false;
363 	    uint8[5] memory numbers;
364 	    
365 	    // Check 5 numbers entered
366 	    if(msg.data.length == 5) {
367 	        
368 	        // Parse DATA string
369 		    for(uint8 i = 0; i < msg.data.length; i++) {
370 		        numbers[i] = uint8(msg.data[i]);
371 		    }
372 		    
373 		    // Check range: 1 - MAX_NUMBER
374 		    for(uint8 i = 0; i < numbers.length; i++) {
375 		        if(numbers[i] < 1 || numbers[i] > MAX_NUMBER) {
376 		            err = true;
377 		            break;
378 		        }
379 		    }
380 		    
381 		    // Check dublicate numbers
382 		    if(!err) {
383 		    
384 		        for(uint8 i = 0; i < numbers.length-1; i++) {
385 		            for(uint8 j = i+1; j < numbers.length; j++) {
386 		                if(numbers[i] == numbers[j]) {
387 		                    err = true;
388 		                    break;
389 		                }
390 		            }
391 		            if(err) {
392 		                break;
393 		            }
394 		        }
395 		        
396 		    }
397 		    
398 	    } else {
399 	        err = true;
400 	    }
401 
402 	    return (err, numbers);
403 
404 	}
405 	
406 	// Sort array of number function
407 	function sortNumbers(uint8[5] memory arrNumbers) private pure returns (uint8[5] memory) {
408 	    
409 	    uint8 temp;
410 	    
411 	    for(uint8 i = 0; i < arrNumbers.length - 1; i++) {
412             for(uint j = 0; j < arrNumbers.length - i - 1; j++)
413                 if (arrNumbers[j] > arrNumbers[j + 1]) {
414                     temp = arrNumbers[j];
415                     arrNumbers[j] = arrNumbers[j + 1];
416                     arrNumbers[j + 1] = temp;
417                 }    
418 	    }
419         
420         return arrNumbers;
421         
422 	}
423 	
424 	// Contract address balance
425     function getBalance() public view returns(uint) {
426         uint balance = address(this).balance;
427 		return balance;
428 	}
429 	
430 	// Generate random number
431 	function random(uint8 num) internal view returns (uint8) {
432 	    
433         return uint8(uint(blockhash(block.number - 1 - num*2)) % MAX_NUMBER + 1);
434         
435     } 
436     
437     function getHour(uint timestamp) private pure returns (uint8) {
438         return uint8((timestamp / 60 / 60) % 24);
439     }
440     
441     function getWeekday(uint timestamp) private pure returns (uint8) {
442         return uint8((timestamp / DAY_IN_SECONDS + 4) % 7);
443     }
444 	
445 	
446 	// API
447 	
448 	// i - Game number
449 	function getGameInfo(uint i) public view returns (uint, uint, uint, uint8, uint8, uint8, uint8, uint8, uint8) {
450 	    Game memory game = games[i];
451 	    return (game.datetime, game.totalFund, game.membersCounter, game.win_numbers[0], game.win_numbers[1], game.win_numbers[2], game.win_numbers[3], game.win_numbers[4], game.status);
452 	}
453 	
454 	// i - Game number, j - Ticket number
455 	function getMemberInfo(uint i, uint j) public view returns (address, uint, uint8, uint8, uint8, uint8, uint8, uint8, uint) {
456 	    Member memory mbr = games[i].members[j];
457 	    return (mbr.addr, mbr.ticket, mbr.matchNumbers, mbr.numbers[0], mbr.numbers[1], mbr.numbers[2], mbr.numbers[3], mbr.numbers[4], mbr.prize);
458 	}
459 
460 }
461 
462 /**
463  * @title SafeMath
464  * @dev Math operations with safety checks that throw on error
465  */
466 library SafeMath {
467 
468     function mul(uint256 a, uint256 b) internal pure returns(uint256) {
469         uint256 c = a * b;
470         assert(a == 0 || c / a == b);
471         return c;
472     }
473 
474     function div(uint256 a, uint256 b) internal pure returns(uint256) {
475         // assert(b > 0); // Solidity automatically throws when dividing by 0
476         uint256 c = a / b;
477         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
478         return c;
479     }
480 
481     function sub(uint256 a, uint256 b) internal pure returns(uint256) {
482         assert(b <= a);
483         return a - b;
484     }
485 
486     function add(uint256 a, uint256 b) internal pure returns(uint256) {
487         uint256 c = a + b;
488         assert(c >= a);
489         return c;
490     }
491 
492 }